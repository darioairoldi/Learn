using Diginsight.Diagnostics;
using Learn.Web.Shared.Navigation;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Navigation;

/// <summary>
/// Recomputes navigation folder aggregates after a content change and broadcasts them to connected
/// clients over <see cref="NavHub"/>, so sidebar counts and the footer total update in real time
/// without client polling.
/// <para>
/// It does NOT own invalidation: the <c>/_nav/invalidate</c> endpoint (the single freshness signal
/// every content path already sends) calls <see cref="PublishChangeAsync"/> after invalidating.
/// The startup warm-up calls <see cref="PublishCountsReadyAsync"/> once counts are computed.
/// </para>
/// <para>
/// Change publishing is debounced (a short quiet window) so a burst of writes triggers a single
/// whole-tree recompute + broadcast instead of one per file. The pushed value is the folder's new
/// <em>absolute</em> recursive count (+ newest article), for the changed folder and each ancestor
/// up to the root; the client replaces the count it holds for each matching prefix.
/// </para>
/// </summary>
public sealed class NavChangePublisher(
    CachedDynamicNavBuilder nav,
    IHubContext<NavHub> hub,
    ILogger<NavChangePublisher> logger) : IDisposable
{
    private static readonly TimeSpan DebounceWindow = TimeSpan.FromMilliseconds(500);
    private readonly object _gate = new();
    private readonly HashSet<string> _pending = new(StringComparer.OrdinalIgnoreCase);
    private Timer? _timer;

    /// <summary>
    /// Queues a changed content <paramref name="path"/> for publication. Coalesces a burst of calls
    /// into one recompute + broadcast after a short quiet window. Never throws to the caller.
    /// </summary>
    public void PublishChangeAsync(string path)
    {
        lock (_gate)
        {
            _pending.Add((path ?? string.Empty).Replace('\\', '/').Trim('/'));
            _timer ??= new Timer(_ => _ = FlushAsync(), null, Timeout.Infinite, Timeout.Infinite);
            _timer.Change(DebounceWindow, Timeout.InfiniteTimeSpan);
        }
    }

    private async Task FlushAsync()
    {
        string[] paths;
        lock (_gate)
        {
            paths = _pending.ToArray();
            _pending.Clear();
        }

        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { paths });

        try
        {
            // Recompute only the changed branch(es): re-walk the top path segment's subtree so its
            // (and its descendants') aggregates are current, then drop the levels so they rebuild
            // from the fresh aggregates when read. Far cheaper than a whole-tree walk per change.
            foreach (string top in paths
                .Select(p => p.Split('/', StringSplitOptions.RemoveEmptyEntries).FirstOrDefault() ?? string.Empty)
                .Where(s => s.Length > 0)
                .Distinct(StringComparer.OrdinalIgnoreCase))
            {
                await nav.RecomputeSubtreeAsync(top);
            }
            nav.InvalidateLevels();

            var byPrefix = new Dictionary<string, NavAggregateDelta>(StringComparer.OrdinalIgnoreCase);
            foreach (string path in paths)
            {
                foreach (NavAggregateDelta delta in await CollectAncestorsAsync(path))
                {
                    byPrefix[delta.Prefix] = delta; // last write wins; identical per recompute anyway
                }
            }

            if (byPrefix.Count > 0)
            {
                await hub.Clients.All.SendAsync(NavHubContract.MetadataChanged, byPrefix.Values.ToArray());
            }
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "Nav metadata change publish failed");
        }
    }

    /// <summary>
    /// Reads the new absolute aggregate for the changed folder and each ancestor up to the root.
    /// Only prefixes that resolve to a navigation <em>section</em> (a folder carrying a count) are
    /// emitted; leaf-article path segments are skipped.
    /// </summary>
    private async Task<List<NavAggregateDelta>> CollectAncestorsAsync(string path)
    {
        var result = new List<NavAggregateDelta>();
        if (string.IsNullOrEmpty(path))
        {
            return result;
        }

        string[] segments = path.Split('/', StringSplitOptions.RemoveEmptyEntries);
        for (int depth = 1; depth <= segments.Length; depth++)
        {
            string prefix = string.Join('/', segments[..depth]);
            string parent = depth == 1 ? string.Empty : string.Join('/', segments[..(depth - 1)]);

            IReadOnlyList<NavChild> siblings = await nav.GetChildrenAsync(parent);
            NavChild? node = siblings.FirstOrDefault(c =>
                c.IsSection && string.Equals(c.Prefix, prefix, StringComparison.OrdinalIgnoreCase));
            if (node is { ArticleCount: { } count })
            {
                result.Add(new NavAggregateDelta(prefix, count, node.LatestArticleUtc, null));
            }
        }

        return result;
    }

    /// <summary>
    /// Broadcasts every root section's current aggregate once the startup warm-up has computed the
    /// recursive counts. Replaces the client's cold-start polling for the footer total.
    /// </summary>
    public async Task PublishCountsReadyAsync()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        try
        {
            NavAggregateDelta[] deltas = await BuildRootDeltasAsync();
            if (deltas.Length > 0)
            {
                await hub.Clients.All.SendAsync(NavHubContract.CountsReady, deltas);
            }
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "Nav counts-ready publish failed");
        }
    }

    /// <summary>
    /// Sends the current root section aggregates to a single just-connected client. The warm-up
    /// <see cref="PublishCountsReadyAsync"/> broadcast only reaches clients already connected; a
    /// browser that connects after warm-up (the common case) would otherwise never learn the counts
    /// and its footer total would stay at the cold-start value. Sending on connect closes that gap.
    /// </summary>
    public async Task SendCurrentCountsAsync(IClientProxy caller)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        try
        {
            NavAggregateDelta[] deltas = await BuildRootDeltasAsync();
            if (deltas.Length > 0)
            {
                await caller.SendAsync(NavHubContract.CountsReady, deltas);
            }
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "Nav counts-ready send-on-connect failed");
        }
    }

    // Current absolute recursive aggregate for every root section that already has a computed count.
    private async Task<NavAggregateDelta[]> BuildRootDeltasAsync()
    {
        IReadOnlyList<NavChild> roots = await nav.GetChildrenAsync(string.Empty);
        return roots
            .Where(c => c.IsSection && c.Prefix is not null && c.ArticleCount is not null)
            .Select(c => new NavAggregateDelta(c.Prefix!, c.ArticleCount!.Value, c.LatestArticleUtc, null))
            .ToArray();
    }

    public void Dispose() => _timer?.Dispose();
}
