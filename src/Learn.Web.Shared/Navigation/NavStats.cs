namespace Learn.Web.Shared.Navigation;

/// <summary>
/// One node's best-known recursive article count plus the newest article seen in its subtree
/// (with that article's author, for the footer's "Last Change" line).
/// </summary>
public readonly record struct NavCount(int Count, DateTimeOffset? LatestUtc, string? LatestAuthor);

/// <summary>
/// Per-circuit status-bar aggregator for the footer article counter.
/// <para>
/// It is fed <em>opportunistically</em> by the navigation menu as it loads levels — no dedicated
/// "count" query is ever issued. Every menu node reports its own recursive subtree count to its
/// parent; only the top-level (root) nodes land here via <see cref="SetRoot"/>. The total is simply
/// the sum of the latest value reported per root, so re-reporting a root just replaces its previous
/// contribution (idempotent, never double counts).
/// </para>
/// <para>
/// Refreshes are coalesced: a burst of updates raises <see cref="Changed"/> at most once per debounce
/// window and always with the newest aggregate ("last one wins"), so a fast-loading menu can never
/// flood the footer with renders. Nothing here awaits I/O, so it can never block client or server
/// processing.
/// </para>
/// </summary>
public sealed class NavStats
{
    private readonly Dictionary<string, NavCount> _roots = new(StringComparer.OrdinalIgnoreCase);
    private readonly object _gate = new();
    private bool _refreshScheduled;

    /// <summary>Running total across all reporting root nodes.</summary>
    public int TotalArticles { get; private set; }

    /// <summary>Newest article date across all roots (UTC).</summary>
    public DateTimeOffset? LatestUtc { get; private set; }

    /// <summary>Author of the newest article, when known (only for articles already discovered).</summary>
    public string? LatestAuthor { get; private set; }

    /// <summary>True once at least one root has reported, so the footer can stop showing "…".</summary>
    public bool HasData { get; private set; }

    /// <summary>Raised (debounced) after the aggregate changes.</summary>
    public event Action? Changed;

    /// <summary>
    /// Records (or overwrites) a root node's recursive subtree count and recomputes the aggregate.
    /// Cheap and synchronous; a UI refresh is scheduled only when the total actually changes.
    /// </summary>
    public void SetRoot(string key, NavCount value)
    {
        lock (_gate)
        {
            _roots[key ?? string.Empty] = value;

            int total = 0;
            DateTimeOffset? latest = null;
            string? author = null;
            foreach (NavCount v in _roots.Values)
            {
                total += v.Count;
                if (v.LatestUtc is { } l && (latest is null || l > latest))
                {
                    latest = l;
                    author = v.LatestAuthor;
                }
            }

            if (HasData && total == TotalArticles && latest == LatestUtc && author == LatestAuthor)
            {
                return; // nothing observable changed — no render needed
            }

            TotalArticles = total;
            LatestUtc = latest;
            LatestAuthor = author;
            HasData = true;
            ScheduleRefresh();
        }
    }

    // Collapse a cascade of SetRoot calls into a single Changed. Only one refresh is ever in flight;
    // the listener reads the newest aggregate when it fires.
    private void ScheduleRefresh()
    {
        if (_refreshScheduled)
        {
            return;
        }

        _refreshScheduled = true;
        _ = RaiseSoonAsync();
    }

    private async Task RaiseSoonAsync()
    {
        // A short settle window lets a burst of node reports coalesce before we touch the UI.
        await Task.Delay(50).ConfigureAwait(false);
        _refreshScheduled = false;
        Changed?.Invoke();
    }
}
