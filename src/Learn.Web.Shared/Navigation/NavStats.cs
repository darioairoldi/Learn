namespace Learn.Web.Shared.Navigation;

/// <summary>
/// One node's best-known recursive article count plus the newest article seen in its subtree
/// (with that article's author, for the footer's "Last Change" line).
/// </summary>
public readonly record struct FolderArticleStats(int Count, DateTimeOffset? LatestUtc, string? LatestAuthor);

/// <summary>
/// Per-circuit status-bar aggregator for the footer article counter.
/// <para>
/// It is fed <em>opportunistically</em> by the navigation menu as it loads levels — no dedicated
/// "count" query is ever issued. Every menu node reports its own recursive subtree count to its
/// parent; only the top-level (root) nodes land here via <see cref="SetRoot"/>. The total is simply
/// the sum of the latest value reported per root, so re-reporting a root just replaces its previous
/// contribution (idempotent, never double counts).
/// </para>
/// </summary>
public sealed class NavStats
{
    private readonly Dictionary<string, (string Label, FolderArticleStats Stats)> _roots = new(StringComparer.OrdinalIgnoreCase);
    private bool _refreshPending;

    // The footer's section line resolves by priority:
    //   1. the item currently hovered / keyboard-focused in the sidebar ("marked for selection"), then
    //   2. the containing section of the selected (navigated) article — the persistent baseline.
    // Keeping the two tiers separate stops the selected article (whose OnParametersSetAsync re-fires on
    // every re-render) from clobbering the transient hover highlight.
    private string? _selKey, _selLabel;    // selected article's section (baseline)
    private int? _selCount;
    private string? _hovKey, _hovLabel;    // hovered / focused item's section (override)
    private int? _hovCount;

    /// <summary>Running total across all reporting root nodes.</summary>
    public int TotalArticles { get; private set; }

    /// <summary>Newest article date across all roots (UTC).</summary>
    public DateTimeOffset? LatestUtc { get; private set; }

    /// <summary>Author of the newest article, when known (only for articles already discovered).</summary>
    public string? LatestAuthor { get; private set; }

    /// <summary>True once at least one root has reported, so the footer can stop showing "…".</summary>
    public bool HasData { get; private set; }

    /// <summary>
    /// Label of the section shown in the footer: the hovered/focused item's section when one is
    /// highlighted, otherwise the selected article's section. Null when neither is known (root).
    /// </summary>
    public string? ActiveSectionLabel => _hovKey is not null ? _hovLabel : _selLabel;

    /// <summary>Article count matching <see cref="ActiveSectionLabel"/>, or null if unknown/root.</summary>
    public int? ActiveSectionCount => _hovKey is not null ? _hovCount : _selCount;

    /// <summary>Raised (debounced) after the aggregate or active section changes.</summary>
    public event Action? Changed;

    /// <summary>
    /// Records (or overwrites) a root node's recursive subtree count and recomputes the aggregate.
    /// A single <see cref="Changed"/> event fires after the burst settles (50 ms quiet window).
    /// </summary>
    /// <remarks>
    /// No lock needed: NavStats is scoped (one per circuit/tab) and all callers run on the
    /// circuit's synchronization context (single-threaded in WASM, serialized in Server).
    /// </remarks>
    public void SetRoot(string key, string label, FolderArticleStats value)
    {
        _roots[key ?? string.Empty] = (label, value);

        int total = 0;
        DateTimeOffset? latest = null;
        string? author = null;
        foreach (var (_, stats) in _roots.Values)
        {
            total += stats.Count;
            if (stats.LatestUtc is { } l && (latest is null || l > latest))
            {
                latest = l;
                author = stats.LatestAuthor;
            }
        }

        bool changed = !HasData || total != TotalArticles || latest != LatestUtc || author != LatestAuthor;

        TotalArticles = total;
        LatestUtc = latest;
        LatestAuthor = author;
        HasData = true;

        // Keep whichever tier(s) reference this root in sync with its freshly reported count/label.
        if (key is not null)
        {
            if (string.Equals(key, _hovKey, StringComparison.OrdinalIgnoreCase))
            {
                changed |= _hovLabel != label || _hovCount != value.Count;
                _hovLabel = label;
                _hovCount = value.Count;
            }
            if (string.Equals(key, _selKey, StringComparison.OrdinalIgnoreCase))
            {
                changed |= _selLabel != label || _selCount != value.Count;
                _selLabel = label;
                _selCount = value.Count;
            }
        }

        if (changed) ScheduleRefresh();
    }

    /// <summary>
    /// Records the selected (navigated) article's containing section — the persistent baseline the
    /// footer shows whenever nothing is hovered/focused. Idempotent, so the active article re-asserting
    /// it on every re-render is a no-op and never fires a redundant refresh.
    /// </summary>
    public void SetSelectedSection(string? key, string? label, int? count)
    {
        if (string.Equals(_selKey, key, StringComparison.OrdinalIgnoreCase)
            && _selLabel == label && _selCount == count)
        {
            return;
        }

        // The baseline is only visible when no override is active, so only then does it warrant a redraw.
        bool visible = _hovKey is null;
        _selKey = key;
        _selLabel = label;
        _selCount = count;
        if (visible) Changed?.Invoke();
    }

    /// <summary>
    /// Records the sidebar item currently hovered or keyboard-focused ("marked for selection") — the
    /// highest-priority override. Sections report themselves (including the folder itself); articles
    /// report their containing section.
    /// </summary>
    public void SetHoverSection(string? key, string? label, int? count)
    {
        if (key is null) return;
        if (string.Equals(_hovKey, key, StringComparison.OrdinalIgnoreCase)
            && _hovLabel == label && _hovCount == count)
        {
            return;
        }

        _hovKey = key;
        _hovLabel = label;
        _hovCount = count;
        Changed?.Invoke();
    }

    /// <summary>
    /// Clears the hover/focus override when the pointer or focus leaves an item, so the footer reverts
    /// to the selected article's section. Guarded by key so a stale leave (fired after a newer item was
    /// already entered) is ignored.
    /// </summary>
    public void ClearHoverSection(string? key)
    {
        if (_hovKey is null) return;
        if (key is not null && !string.Equals(_hovKey, key, StringComparison.OrdinalIgnoreCase)) return;

        _hovKey = null;
        _hovLabel = null;
        _hovCount = null;
        Changed?.Invoke();
    }

    // Coalesce a burst of SetRoot calls into one Changed event. The flag prevents multiple
    // in-flight delays; the subscriber always reads the latest aggregate when it fires.
    private void ScheduleRefresh()
    {
        if (_refreshPending) return;
        _refreshPending = true;
        _ = RaiseAfterSettleAsync();
    }

    private async Task RaiseAfterSettleAsync()
    {
        await Task.Delay(50).ConfigureAwait(false);
        _refreshPending = false;
        Changed?.Invoke();
    }
}
