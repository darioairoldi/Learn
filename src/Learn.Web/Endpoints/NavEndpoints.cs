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
    public static IEndpointRouteBuilder MapNavEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/_nav/children", GetChildrenAsync);
        app.MapGet("/_nav/version", GetVersion);
        app.MapGet("/_nav/index", GetIndexAsync);
        app.MapPost("/_nav/invalidate", Invalidate);
        return app;
    }

    private static async Task<IResult> GetChildrenAsync(string? prefix, DynamicNavBuilder nav, ILoggerFactory loggerFactory, CancellationToken ct)
    {
        ILogger logger = loggerFactory.CreateLogger(typeof(NavEndpoints));
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        return Results.Json(await nav.GetChildrenAsync(prefix ?? string.Empty, ct));
    }

    private static IResult GetVersion(ILoggerFactory loggerFactory)
    {
        ILogger logger = loggerFactory.CreateLogger(typeof(NavEndpoints));
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(new { version = DynamicNavBuilder.Version });
    }

    private static async Task<IResult> GetIndexAsync(DynamicNavBuilder nav, ILoggerFactory loggerFactory, CancellationToken ct)
    {
        ILogger logger = loggerFactory.CreateLogger(typeof(NavEndpoints));
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return Results.Json(await nav.GetIndexAsync(ct));
    }

    private static IResult Invalidate(DynamicNavBuilder nav, ILoggerFactory loggerFactory)
    {
        ILogger logger = loggerFactory.CreateLogger(typeof(NavEndpoints));
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        nav.Invalidate();
        return Results.Ok(new { version = DynamicNavBuilder.Version });
    }
}
