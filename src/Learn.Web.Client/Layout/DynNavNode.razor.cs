using Learn.Web.Shared.Navigation;
using Microsoft.AspNetCore.Components;

namespace Learn.Web.Client.Layout;

public partial class DynNavNode
{
    [Parameter, EditorRequired] public NavChild Node { get; set; } = default!;
    [Parameter] public string CurrentRoute { get; set; } = string.Empty;

    // Bubble-up counter: this node reports its recursive subtree article count to its parent; the
    // parent replaces our previous contribution (never double counts) and re-reports upward. Passed
    // as a plain Action (not an EventCallback) so reporting never forces ancestor re-renders — only
    // the footer refreshes, via the debounced NavStats.
    [Parameter] public Action<(string Key, FolderArticleStats Value)>? OnCounted { get; set; }

    // Parent section info for article-hover reporting: when hovering an article, the footer shows
    // its containing section's label and count.
    [Parameter] public string? ParentPrefix { get; set; }
    [Parameter] public string? ParentLabel { get; set; }
    [Parameter] public int? ParentCount { get; set; }

    private bool _open;
    private IReadOnlyList<NavChild>? _children;

    // Latest counts reported by our (loaded) children, keyed by the child's own key.
    private readonly Dictionary<string, FolderArticleStats> _childCounts = new(StringComparer.OrdinalIgnoreCase);

    // Last value we pushed to the parent, so we skip redundant reports.
    private FolderArticleStats? _reported;

    // Stable identity for this node within its parent's child set.
    private string CountKey => Node.Prefix ?? Node.Route ?? Node.Text;

    // The active route this section was last auto-opened for. Prevents later re-renders from
    // re-opening a section the user has explicitly collapsed while staying on the same article.
    private string? _autoOpenedForRoute;

    private bool InActiveBranch =>
        Node.Prefix is not null && !string.IsNullOrEmpty(CurrentRoute) &&
        (string.Equals(CurrentRoute, Node.Route, StringComparison.OrdinalIgnoreCase) ||
         CurrentRoute.StartsWith(Node.Prefix + "/", StringComparison.OrdinalIgnoreCase));

    protected override void OnInitialized()
    {
        Sidebar.ExpandAllRequested += OnExpandAll;
        Sidebar.RefreshCountsRequested += OnRefreshCounts;
    }

    protected override async Task OnParametersSetAsync()
    {
        if (!Node.IsSection)
        {
            ReportCount(); // a leaf article contributes immediately (Home / empty routes contribute 0)

            // When this article IS the active route, report its parent section as the footer baseline.
            // This handles navigation (click) where no new mouseover fires because the pointer is
            // already over the element when the DOM re-renders. It is the lowest-priority tier, so it
            // never overwrites a hover/focus highlight.
            if (ParentPrefix is not null && !string.IsNullOrEmpty(Node.Route) &&
                string.Equals(CurrentRoute, Node.Route, StringComparison.OrdinalIgnoreCase))
            {
                Stats.SetSelectedSection(ParentPrefix, ParentLabel, ParentCount);
            }

            return;
        }

        // Auto-open the active branch once per active route (so a user who then collapses it with the
        // arrow keys / twisty isn't fought by later re-renders), and keep sections open while
        // expand-all is on.
        bool wantOpen = (InActiveBranch && _autoOpenedForRoute != CurrentRoute) || Sidebar.AllExpanded;
        if (wantOpen && !_open)
        {
            _open = true;
            if (_children is null && Node.Prefix is not null)
            {
                _children = await Provider.GetChildrenAsync(Node.Prefix);
            }
        }

        // Remember we've handled this active route, whether we just opened it or the user is free to
        // keep it collapsed from here on.
        if (InActiveBranch)
        {
            _autoOpenedForRoute = CurrentRoute;
        }

        // Report our subtree count: the server's recursive estimate while collapsed, the computed sum
        // of our children once they have loaded and reported.
        ReportCount();
    }

    // Computes this node's recursive article count and pushes it to the parent when it changed.
    private void ReportCount()
    {
        FolderArticleStats value;
        if (!Node.IsSection)
        {
            value = string.IsNullOrEmpty(Node.Route)
                ? new FolderArticleStats(0, null, null)                          // Home and other non-article links
                : new FolderArticleStats(1, Node.Date, Node.Author);            // a navigable article
        }
        else if (_children is null || _childCounts.Count == 0)
        {
            // Collapsed (or children not reported yet) → trust the server's recursive aggregate so the
            // total is right without expanding, and avoid a transient drop to 0.
            value = new FolderArticleStats(Node.ArticleCount ?? 0, Node.LatestArticleUtc, null);
        }
        else
        {
            int count = 0;
            DateTimeOffset? latest = null;
            string? author = null;
            foreach (FolderArticleStats c in _childCounts.Values)
            {
                count += c.Count;
                if (c.LatestUtc is { } l && (latest is null || l > latest))
                {
                    latest = l;
                    author = c.LatestAuthor;
                }
            }

            value = new FolderArticleStats(count, latest, author);
        }

        if (_reported == value)
        {
            return;
        }

        _reported = value;
        OnCounted?.Invoke((CountKey, value));
    }

    // A child reported its subtree count → fold it in and, if we are expanded, re-report upward.
    private void OnChildCounted((string Key, FolderArticleStats Value) report)
    {
        _childCounts[report.Key] = report.Value;
        if (_children is not null)
        {
            ReportCount();
        }
    }

    // Broadcast handler: expand (true) opens + lazily loads; the child renders then cascade further.
    private async void OnExpandAll(bool expand)
    {
        if (!Node.IsSection)
        {
            return;
        }

        _open = expand;
        if (expand && _children is null && Node.Prefix is not null)
        {
            _children = await Provider.GetChildrenAsync(Node.Prefix);
        }

        await InvokeAsync(StateHasChanged);
    }

    // Folder click / Enter: closed → open + select (navigate to) the first article under it;
    // open → collapse (no navigation). Children load lazily on first open.
    private async Task OnSummaryActivate()
    {
        if (_open)
        {
            _open = false;
            return;
        }

        _open = true;
        if (_children is null && Node.Prefix is not null)
        {
            _children = await Provider.GetChildrenAsync(Node.Prefix);
        }

        NavChild? first = _children?.FirstOrDefault(c => !c.IsSection && !string.IsNullOrEmpty(c.Route));
        if (first?.Route is not null)
        {
            NavMgr.NavigateTo(first.Route);
        }
        else if (!string.IsNullOrEmpty(Node.Route))
        {
            NavMgr.NavigateTo(Node.Route);
        }
    }

    // Twisty (chevron) / arrow keys / Space: expand or collapse only — no navigation.
    private async Task ToggleOpenOnly()
    {
        _open = !_open;
        if (_open && _children is null && Node.Prefix is not null)
        {
            _children = await Provider.GetChildrenAsync(Node.Prefix);
        }
    }

    // Pointer entered or keyboard focused this item ("marked for selection") → highest-priority footer
    // override. Sections report themselves (the folder itself); articles report their parent section.
    private void OnPointerEnter()
    {
        if (Node.IsSection && Node.Prefix is not null)
        {
            Stats.SetHoverSection(Node.Prefix, Node.Text, _reported?.Count);
        }
        else if (ParentPrefix is not null)
        {
            Stats.SetHoverSection(ParentPrefix, ParentLabel, ParentCount);
        }
    }

    // Pointer/focus left this item → drop the override (guarded by key) so the footer reverts to the
    // selected article's section.
    private void OnPointerLeave()
    {
        if (Node.IsSection && Node.Prefix is not null)
        {
            Stats.ClearHoverSection(Node.Prefix);
        }
        else if (ParentPrefix is not null)
        {
            Stats.ClearHoverSection(ParentPrefix);
        }
    }

    // Counts converged / pushed → an open section re-reads its child level so any folder count that
    // was still unknown (rendered as 0) or stale when it first loaded is replaced with the current
    // value. Reads from the client cache (which the metadata push updates in place) — no API hit.
    private async void OnRefreshCounts()
    {
        if (!Node.IsSection || Node.Prefix is null || _children is null)
        {
            return;
        }

        _children = await Provider.GetChildrenAsync(Node.Prefix);
        ReportCount();
        await InvokeAsync(StateHasChanged);
    }

    public void Dispose()
    {
        Sidebar.ExpandAllRequested -= OnExpandAll;
        Sidebar.RefreshCountsRequested -= OnRefreshCounts;
    }
}
