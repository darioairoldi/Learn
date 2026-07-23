using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using Learn.Web.Shared.Navigation;

namespace Learn.Web.Client.Layout;

public partial class MainLayout
{
    private bool _searchOpen;
    private bool _notifyOpen;
    private RepoStats? _stats;
    private CancellationTokenSource? _statsCts;
    private DotNetObjectReference<MainLayout>? _selfRef;

    private string TotalArticlesText
    {
        get
        {
            if (_stats is null)
            {
                return "…";
            }

            if (!_stats.Complete)
            {
                // Partial while the menu index is still loading; a trailing ellipsis signals "counting".
                return _stats.TotalArticles > 0 ? $"{_stats.TotalArticles:N0}…" : "…";
            }

            // Locale-aware thousands separator (browser culture in Blazor WASM).
            return _stats.TotalArticles.ToString("N0");
        }
    }

    private string LastChangeText
    {
        get
        {
            if (_stats?.LastChangeUtc is not { } lastChange)
            {
                return string.Empty;
            }

            // Short date in the browser's locale/format; local time zone is the browser's in WASM.
            string date = lastChange.ToLocalTime().ToString("d");
            return string.IsNullOrWhiteSpace(_stats.LastAuthor)
                ? $"Last Change: {date}"
                : $"Author: {_stats.LastAuthor} · Last Change: {date}";
        }
    }

    protected override void OnInitialized()
    {
        Theme.Changed += OnThemeChanged;
        Sidebar.Changed += OnSidebarChanged;
        _statsCts = new CancellationTokenSource();
        _ = LoadStatsAsync(_statsCts.Token);
    }

    // Best-effort footer stats derived from the SAME cached nav queries the app already issues — no
    // separate endpoint or round-trip. A cheap root-level pass yields a partial count immediately
    // (from folder aggregates); the flat index (already fetched for search/prev-next) then provides
    // the authoritative total + newest-article date/author. Fire-and-forget so it never blocks render.
    private async Task LoadStatsAsync(CancellationToken ct)
    {
        try
        {
            RepoStats? partial = await PartialFromRootAsync(ct);
            if (partial is not null && !ct.IsCancellationRequested)
            {
                _stats = partial;
                await InvokeAsync(StateHasChanged);
            }
        }
        catch (OperationCanceledException) { /* component disposed */ }
        catch { /* footer is informational only */ }

        try
        {
            RepoStats full = await ComputeFromIndexAsync(ct);
            if (!ct.IsCancellationRequested)
            {
                _stats = full;
                await InvokeAsync(StateHasChanged);
            }
        }
        catch (OperationCanceledException) { /* component disposed */ }
        catch { /* footer is informational only */ }
    }

    // Fast/partial: sum the recursive article counts on the top-level folder nodes (metadata.yml seed
    // or computed) from the already-cached root level. Author is unavailable until the index resolves.
    private async Task<RepoStats?> PartialFromRootAsync(CancellationToken ct)
    {
        IReadOnlyList<NavChild> root = await Nav.GetChildrenAsync(string.Empty, ct);

        int? total = null;
        DateTimeOffset? latest = null;
        foreach (NavChild folder in root)
        {
            if (folder.ArticleCount is { } count)
            {
                total = (total ?? 0) + count;
            }

            if (folder.LatestArticleUtc is { } l && (latest is null || l > latest))
            {
                latest = l;
            }
        }

        return total is null && latest is null ? null : new RepoStats(total ?? 0, latest, null, Complete: false);
    }

    // Authoritative: the flat index carries every article's date/author — total = leaf count, last
    // change = the newest leaf.
    private async Task<RepoStats> ComputeFromIndexAsync(CancellationToken ct)
    {
        IReadOnlyList<NavLeaf> index = await Nav.GetIndexAsync(ct);

        NavLeaf? newest = null;
        foreach (NavLeaf leaf in index)
        {
            if (leaf.Date is { } d && (newest?.Date is null || d > newest.Date))
            {
                newest = leaf;
            }
        }

        return new RepoStats(index.Count, newest?.Date, newest?.Author, Complete: true);
    }

    // Called from JS when the viewport crosses the responsive breakpoint: narrow → collapse the
    // sidebar to the icon rail (still usable via the hover flyout); wide → expand it.
    [JSInvokable]
    public Task SetSidebarCollapsed(bool collapsed)
    {
        Sidebar.SetCollapsed(collapsed);
        return Task.CompletedTask;
    }

    private void OnSidebarChanged() => InvokeAsync(StateHasChanged);

    private async void OnThemeChanged()
    {
        try
        {
            await JS.InvokeVoidAsync("localStorage.setItem", "lh-theme", Theme.ThemeId);
            await JS.InvokeVoidAsync("appUi.rerenderMermaid");
        }
        catch
        {
            /* JS not available during prerender */
        }

        await InvokeAsync(StateHasChanged);
    }

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender)
        {
            string? saved = await JS.InvokeAsync<string?>("localStorage.getItem", "lh-theme");
            Theme.SetTheme(saved);
            await JS.InvokeVoidAsync("appUi.initResizer");
            await JS.InvokeVoidAsync("appUi.initTocResizer");
            _selfRef = DotNetObjectReference.Create(this);
            await JS.InvokeVoidAsync("appUi.initResponsive", _selfRef);
        }
    }

    public void Dispose()
    {
        Theme.Changed -= OnThemeChanged;
        Sidebar.Changed -= OnSidebarChanged;
        _statsCts?.Cancel();
        _statsCts?.Dispose();
        _selfRef?.Dispose();
    }
}
