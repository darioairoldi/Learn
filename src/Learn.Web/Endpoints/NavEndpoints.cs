using Diginsight.Diagnostics;
using Learn.Web.Navigation;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Endpoints;

/// <summary>
/// Dynamic navigation API, built live from the content store by <see cref="DynamicNavBuilder"/>:
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

    private static async Task<IResult> GetNavChildrenAsync(string? prefix, DynamicNavBuilder nav, CancellationToken ct)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        return Results.Json(await nav.GetChildrenAsync(prefix ?? string.Empty, ct));
    }

    private static IResult GetNavVersion()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(new { version = DynamicNavBuilder.Version });
    }

    private static async Task<IResult> GetNavIndexAsync(DynamicNavBuilder nav, CancellationToken ct)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(await nav.GetIndexAsync(ct));
    }

    private static IResult InvalidateNavCache(string? path, DynamicNavBuilder nav)
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

        return Results.Ok(new { version = DynamicNavBuilder.Version });
    }
}
