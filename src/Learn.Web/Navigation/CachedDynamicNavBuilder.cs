using Diginsight.Diagnostics;
using Diginsight.SmartCache;
using Learn.Web.Caching;
using Learn.Web.Shared.Navigation;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Navigation;

/// <summary>
/// SmartCache decorator over <see cref="INavBuilder"/>. Caches navigation levels and the flattened
/// index in-memory (optionally Redis-backed) keyed on <see cref="ContentPathCacheKey"/> so a
/// content write can invalidate exactly the affected branch. Also owns the monotonic version that
/// clients poll to drop their own cache.
/// </summary>
public sealed class CachedDynamicNavBuilder(
    INavBuilder inner,
    ISmartCache smartCache,
    ILogger<CachedDynamicNavBuilder> logger) : INavBuilder
{
    private static long _version = 1;

    /// <summary>Current nav version; bumps on <see cref="Invalidate()"/>.</summary>
    public static long Version => Interlocked.Read(ref _version);

    /// <summary>
    /// Invalidates the whole navigation (and content) cache: bumps the version — the signal clients
    /// poll via <c>/_nav/version</c> to drop their own cache — and evicts every server-side entry on
    /// every node via an empty-path rule.
    /// </summary>
    public void Invalidate() => Invalidate(string.Empty);

    /// <summary>
    /// Invalidates just the branch touched by a content write at <paramref name="path"/>: the cached
    /// article plus every menu level that lists an ancestor of it, on every node. Still bumps the
    /// version so clients (which hold only a single version number, not per-path state) refetch.
    /// An empty <paramref name="path"/> invalidates everything.
    /// </summary>
    public void Invalidate(string path)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { path });

        Interlocked.Increment(ref _version);
        smartCache.Invalidate(new ContentPathInvalidationRule(ContentPathCacheKey.Normalize(path)));
    }

    public async Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        prefix = (prefix ?? string.Empty).Replace('\\', '/').Trim('/');

        // Path-addressed key: Invalidate(path) drops this level when the changed path is on its branch.
        // CoalesceRacingCacheMisses gives the cache-stampede protection that used to be a manual
        // ConcurrentDictionary; SlidingExpiration mirrors the previous 60s idle eviction (MaxAge still
        // inherits Diginsight:SmartCache config).
        var options = new SmartCacheOperationOptions
        {
            CoalesceRacingCacheMisses = true,
            SlidingExpiration = TimeSpan.FromSeconds(60),
        };
        var key = new ContentPathCacheKey("nav-level", prefix);

        string levelPrefix = prefix;
        NavChildrenEnvelope envelope = await smartCache.GetAsync(
            key,
            async innerCt => new NavChildrenEnvelope((await inner.GetChildrenAsync(levelPrefix, innerCt)).ToArray()),
            options,
            callerType: typeof(CachedDynamicNavBuilder),
            cancellationToken: ct);

        return envelope.Items;
    }

    public async Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        // The whole-tree walk is the expensive cold path, so coalesce racing misses and hold the
        // result longer (15 min idle) than a single level. Keyed at the root path so any content
        // change invalidates it.
        var options = new SmartCacheOperationOptions
        {
            CoalesceRacingCacheMisses = true,
            SlidingExpiration = TimeSpan.FromMinutes(15),
        };
        var key = new ContentPathCacheKey("nav-index", string.Empty);

        NavIndexEnvelope envelope = await smartCache.GetAsync(
            key,
            async innerCt => new NavIndexEnvelope((await inner.GetIndexAsync(innerCt)).ToArray()),
            options,
            callerType: typeof(CachedDynamicNavBuilder),
            cancellationToken: ct);

        return envelope.Items;
    }

    /// <summary>Serializable envelope so a built level round-trips through SmartCache (incl. Redis).</summary>
    private sealed record NavChildrenEnvelope(NavChild[] Items);

    /// <summary>Serializable envelope so the flattened index round-trips through SmartCache.</summary>
    private sealed record NavIndexEnvelope(NavLeaf[] Items);
}
