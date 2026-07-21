using Diginsight.Diagnostics;
using Diginsight.SmartCache;
using Learn.Web.Shared;
using Learn.Web.Shared.Navigation;

namespace Learn.Web.ContentSources;

/// <summary>
/// SmartCache decorator over an inner <see cref="IContentSource"/>. It caches the Markdown
/// source-byte fetch — the expensive blob/file read that runs on every prerender and on every
/// WASM navigation via <c>/_content-raw</c> — in-memory, optionally backed by Redis for
/// distributed, multi-instance sharing.
/// <para>
/// Only text Markdown keys (<c>.md</c>/<c>.qmd</c>) are cached; binary assets (images, downloads)
/// pass straight through so Redis is not bloated with large payloads. Listing/head calls delegate
/// to the inner source unchanged (navigation keeps its own cache).
/// </para>
/// </summary>
public sealed class CachedContentSource(
    IContentSource inner,
    ISmartCache smartCache,
    ICacheKeyService cacheKeyService,
    ILogger<CachedContentSource> logger) : IContentSource, IContentLister
{
    public async Task<ContentResult?> GetAsync(string contentKey, CancellationToken ct = default)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { contentKey });

        // Binary assets bypass the distributed cache — only Markdown source is worth caching.
        if (!IsCacheable(contentKey))
        {
            return await inner.GetAsync(contentKey, ct);
        }

        // Freshness (MaxAge / expirations) comes from Diginsight:SmartCache config — including the
        // class-aware MaxAge@CachedContentSource override — via the caller type below.
        var options = new SmartCacheOperationOptions();
        var key = new MethodCallCacheKey(cacheKeyService, typeof(CachedContentSource), nameof(GetAsync), contentKey);

        CachedContent envelope = await smartCache.GetAsync(
            key,
            async innerCt => new CachedContent(await inner.GetAsync(contentKey, innerCt)),
            options,
            callerType: typeof(CachedContentSource),
            cancellationToken: ct);

        return envelope.Result;
    }

    public Task<IReadOnlyList<ChildEntry>> ListChildrenAsync(string prefix, CancellationToken ct = default) =>
        ((IContentLister)inner).ListChildrenAsync(prefix, ct);

    public Task<string?> ReadHeadAsync(string key, CancellationToken ct = default) =>
        ((IContentLister)inner).ReadHeadAsync(key, ct);

    private static bool IsCacheable(string contentKey) =>
        contentKey.EndsWith(".md", StringComparison.OrdinalIgnoreCase) ||
        contentKey.EndsWith(".qmd", StringComparison.OrdinalIgnoreCase);

    /// <summary>
    /// Serializable envelope so both hits and misses (a <c>null</c> <see cref="ContentResult"/>)
    /// round-trip through the in-memory and Redis stores.
    /// </summary>
    public sealed record CachedContent(ContentResult? Result);
}
