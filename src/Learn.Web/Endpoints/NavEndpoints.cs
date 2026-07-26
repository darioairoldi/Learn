using Diginsight.Diagnostics;
using Learn.Web.Navigation;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Endpoints;

/// <summary>
/// Dynamic navigation API, built live from the content store by <see cref="CachedDynamicNavBuilder"/>:
/// one menu level per call, a monotonic version, a flattened article index (for menu search /
/// prev-next), and an invalidation hook for content writers.
/// </summary>
public static class NavEndpoints
{
    private static ILogger? cachedLogger;
    private static ILogger? logger => cachedLogger ??= Observability.LoggerFactory?.CreateLogger(typeof(NavEndpoints));

    public static IEndpointRouteBuilder MapNavEndpoints(this IEndpointRouteBuilder app)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        app.MapGet("/_nav/children", GetNavChildrenAsync);
        app.MapGet("/_nav/version", GetNavVersion);
        app.MapGet("/_nav/index", GetNavIndexAsync);
        app.MapPost("/_nav/invalidate", InvalidateNavCache);
        return app;
    }

    private static async Task<IResult> GetNavChildrenAsync(string? prefix, INavBuilder nav, CachedDynamicNavBuilder cachedNav, CancellationToken ct)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        var children = await nav.GetChildrenAsync(prefix ?? string.Empty, ct);

        // Fire-and-forget: warm +2 levels deeper so the next expand is instant.
        _ = Task.Run(async () =>
        {
            try { await cachedNav.WarmLevelsAsync(prefix ?? string.Empty, 3, CancellationToken.None); }
            catch { /* best-effort */ }
        });

        return Results.Json(children);
    }

    private static IResult GetNavVersion()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(new { version = CachedDynamicNavBuilder.Version });
    }

    private static async Task<IResult> GetNavIndexAsync(INavBuilder nav, CancellationToken ct)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(await nav.GetIndexAsync(ct));
    }

    private static IResult InvalidateNavCache(string? path, CachedDynamicNavBuilder nav, NavChangePublisher publisher)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { path });

        // No path → whole cache (content + nav, every node); a path → just that branch.
        if (string.IsNullOrWhiteSpace(path))
        {
            nav.Invalidate();
        }
        else
        {
            nav.Invalidate(path);
        }

        // Recompute the affected folder aggregates and push them to connected clients (debounced),
        // so sidebar counts and the footer total update live without polling.
        publisher.PublishChangeAsync(path ?? string.Empty);

        return Results.Ok(new { version = CachedDynamicNavBuilder.Version });
    }
}
