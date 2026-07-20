using Diginsight.Components.Azure.Extensions;
using Diginsight.Diagnostics;
using Learn.Web.Shared;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Endpoints;

/// <summary>
/// Raw Markdown/asset passthrough endpoint (<c>/_content-raw/{**key}</c>) consumed by the WASM
/// client's <c>HttpContentSource</c> to fetch content bytes from the server-side content store.
/// </summary>
public static class ContentEndpoints
{
    private static ILogger? cachedLogger;
    private static ILogger? logger => cachedLogger ??= Observability.LoggerFactory?.CreateLogger(typeof(ContentEndpoints));

    public static IEndpointRouteBuilder MapContentEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/_content-raw/{**key}", GetContentRawAsync);
        return app;
    }

    private static async Task<IResult> GetContentRawAsync(string key, IContentSource source, CancellationToken ct)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { key });

        ContentResult? result = await source.GetAsync(key, ct);
        return result is null
            ? Results.NotFound()
            : Results.Bytes(result.Bytes, result.ContentType ?? "text/markdown; charset=utf-8");
    }
}
