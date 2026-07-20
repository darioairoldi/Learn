using Learn.Web.Shared;
using Learn.Web.Shared.Navigation;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;

namespace Learn.Web.Client.Layout;

public partial class DynNav
{
    private const int MaxResults = 200;
    private static readonly StringComparison OIC = StringComparison.OrdinalIgnoreCase;

    private IReadOnlyList<NavChild>? _root;
    private string _current = string.Empty;
    private bool _scrollPending;

    private string _query = string.Empty;
    private IReadOnlyList<NavLeaf>? _index;
    private bool _indexing;

    protected override async Task OnInitializedAsync()
    {
        _current = CurrentRoute();
        NavMgr.LocationChanged += OnLocationChanged;
        _root = await Provider.GetChildrenAsync(string.Empty);
        _scrollPending = true;
    }

    private bool IsActiveRail(NavChild n) =>
        n.Prefix is not null && !string.IsNullOrEmpty(_current) &&
        _current.StartsWith(n.Prefix, StringComparison.OrdinalIgnoreCase);

    // Rail icon: navigate to the section's landing route if it has one; the sidebar stays collapsed
    // (hovering the rail opens the temporary flyout for full browsing).
    private void OnRailClick(NavChild n)
    {
        if (!string.IsNullOrEmpty(n.Route))
        {
            NavMgr.NavigateTo(n.Route);
        }
    }

    private async Task OnSearchInput(ChangeEventArgs e)
    {
        _query = e.Value?.ToString() ?? string.Empty;

        if (!string.IsNullOrWhiteSpace(_query) && _index is null && !_indexing)
        {
            _indexing = true;
            _index = await Provider.GetIndexAsync();
            _indexing = false;
        }

        StateHasChanged();
    }

    private void ClearSearch() => _query = string.Empty;

    // Esc exits search mode and drops back to the tree, revealing/scrolling the active article.
    private void OnKeyDown(KeyboardEventArgs e)
    {
        if (e.Key == "Escape" && !string.IsNullOrEmpty(_query))
        {
            _query = string.Empty;
            _scrollPending = true;
        }
    }

    private static List<NavLeaf> Filter(IReadOnlyList<NavLeaf> index, string query) =>
        index.Where(l => l.Text.Contains(query, OIC) || l.Path.Contains(query, OIC))
             .Take(MaxResults)
             .ToList();

    // Wraps every case-insensitive occurrence of the query in a highlight <mark>.
    private RenderFragment Highlight(string text, string query) => builder =>
    {
        query = query?.Trim() ?? string.Empty;
        if (query.Length == 0 || string.IsNullOrEmpty(text))
        {
            builder.AddContent(0, text);
            return;
        }

        int seq = 0;
        int pos = 0;
        while (pos < text.Length)
        {
            int idx = text.IndexOf(query, pos, OIC);
            if (idx < 0)
            {
                builder.AddContent(seq++, text[pos..]);
                break;
            }

            if (idx > pos)
            {
                builder.AddContent(seq++, text[pos..idx]);
            }

            builder.OpenElement(seq++, "mark");
            builder.AddAttribute(seq++, "class", "nav-search-hl");
            builder.AddContent(seq++, text.Substring(idx, query.Length));
            builder.CloseElement();
            pos = idx + query.Length;
        }
    };

    private void OnLocationChanged(object? sender, LocationChangedEventArgs e)
    {
        _current = CurrentRoute();
        _scrollPending = true;
        InvokeAsync(StateHasChanged);
    }

    private string CurrentRoute()
    {
        string rel = NavMgr.ToBaseRelativePath(NavMgr.Uri);
        int cut = rel.IndexOfAny(new[] { '?', '#' });
        if (cut >= 0)
        {
            rel = rel[..cut];
        }

        return rel.Trim('/');
    }

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (_scrollPending && _root is { Count: > 0 } && string.IsNullOrEmpty(_query) && !Sidebar.Collapsed)
        {
            _scrollPending = false;
            try { await JS.InvokeVoidAsync("appUi.scrollActiveNavIntoView"); } catch { /* prerender */ }
        }
    }

    public void Dispose() => NavMgr.LocationChanged -= OnLocationChanged;
}
