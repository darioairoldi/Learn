using Diginsight.Diagnostics;
using Learn.Web.Navigation;
using Learn.Web.Shared;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Learn.Web.Endpoints;

/// <summary>
/// Content-mutation endpoints used to exercise the navigation metrics pipeline end to end
/// (add/remove an article, observe the counts settle). Mapped ONLY when
/// <c>Testing:ContentMutationEnabled</c> is true, which is never the case outside local runs.
/// </summary>
public static class TestContentEndpoints
{
    private static ILogger? cachedLogger;
    private static ILogger? logger => cachedLogger ??= Observability.LoggerFactory?.CreateLogger(typeof(TestContentEndpoints));

    public static IEndpointRouteBuilder MapTestContentEndpoints(this IEndpointRouteBuilder app, IConfiguration configuration)
    {
        if (!configuration.GetValue("Testing:ContentMutationEnabled", false))
        {
            return app;
        }

        app.MapPost("/_test/article", AddArticleAsync);
        app.MapDelete("/_test/article", RemoveArticleAsync);
        app.MapGet("/_nav/metrics", DumpMetrics);
        return app;
    }

    private static async Task<IResult> AddArticleAsync(
        string folder, string name,
        IOptions<ContentOptions> options, IWebHostEnvironment env,
        CachedDynamicNavBuilder nav, FolderMetricsIndex metrics, NavChangePublisher publisher)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { folder, name });

        if (!TryResolve(options, env, folder, name, out string dir, out string relative))
        {
            return Results.BadRequest(new { error = "invalid path" });
        }

        Directory.CreateDirectory(dir);
        await File.WriteAllTextAsync(Path.Combine(dir, "overview.md"),
            $"---\ntitle: \"Nav count probe {name}\"\ndate: \"{DateTime.UtcNow:yyyy-MM-dd}\"\n---\n\n# Nav count probe {name}\n\nTemporary article created by the navigation metrics test.\n");

        return await ApplyAsync(nav, metrics, publisher, relative);
    }

    private static async Task<IResult> RemoveArticleAsync(
        string folder, string name,
        IOptions<ContentOptions> options, IWebHostEnvironment env,
        CachedDynamicNavBuilder nav, FolderMetricsIndex metrics, NavChangePublisher publisher)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { folder, name });

        if (!TryResolve(options, env, folder, name, out string dir, out string relative))
        {
            return Results.BadRequest(new { error = "invalid path" });
        }

        if (Directory.Exists(dir))
        {
            Directory.Delete(dir, recursive: true);
        }

        return await ApplyAsync(nav, metrics, publisher, relative);
    }

    /// <summary>
    /// The app-originated write path: invalidate the branch, stamp the metric spine, then drain
    /// immediately so the response carries settled counts instead of leaving the caller to poll.
    /// </summary>
    private static async Task<IResult> ApplyAsync(
        CachedDynamicNavBuilder nav, FolderMetricsIndex metrics, NavChangePublisher publisher, string relative)
    {
        nav.Invalidate(relative);                 // structural: the parent level gained/lost a child
        publisher.PublishChangeAsync(relative);   // metrics: stamp the ancestor spine
        await metrics.DrainAsync();               // fold + publish now (bypasses the debounce)

        return Results.Ok(new
        {
            path = relative,
            version = metrics.Version,
            counts = metrics.Dump()
                .Where(kv => relative.StartsWith(kv.Key, StringComparison.OrdinalIgnoreCase) || kv.Key.Length == 0)
                .ToDictionary(kv => kv.Key, kv => kv.Value.Count),
        });
    }

    private static IResult DumpMetrics(FolderMetricsIndex metrics, string? prefix) =>
        Results.Json(new
        {
            version = metrics.Version,
            cells = metrics.Dump()
                .Where(kv => prefix is null || kv.Key.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
                .OrderBy(kv => kv.Key, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(kv => kv.Key, kv => kv.Value),
        });

    // Keeps the test writer inside the configured content root (same guard the readers apply).
    private static bool TryResolve(
        IOptions<ContentOptions> options, IWebHostEnvironment env,
        string folder, string name, out string dir, out string relative)
    {
        dir = string.Empty;
        relative = string.Empty;

        if (string.IsNullOrWhiteSpace(folder) || string.IsNullOrWhiteSpace(name) ||
            name.Contains('/') || name.Contains('\\') || name.Contains(".."))
        {
            return false;
        }

        string root = Path.GetFullPath(Path.Combine(env.ContentRootPath, options.Value.FileSystem.RootPath));
        relative = $"{folder.Replace('\\', '/').Trim('/')}/{name}";
        dir = Path.GetFullPath(Path.Combine(root, relative));

        return dir.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase);
    }
}
