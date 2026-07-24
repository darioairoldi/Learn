using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using Learn.Web.Shared.Navigation;

namespace Learn.Web.Client.Layout;

public partial class MainLayout
{
    private bool _searchOpen;
    private bool _notifyOpen;
    private DotNetObjectReference<MainLayout>? _selfRef;

    private string TotalArticlesText
    {
        get
        {
            if (!Stats.HasData)
            {
                return "…"; // no menu node has reported a count yet
            }

            // Locale-aware thousands separator (browser culture in Blazor WASM). The count grows as
            // the menu discovers/loads nodes, so this reflects "known so far".
            return Stats.TotalArticles.ToString("N0");
        }
    }

    private string LastChangeText
    {
        get
        {
            if (Stats.LatestUtc is not { } lastChange)
            {
                return string.Empty;
            }

            // Short date in the browser's locale/format; local time zone is the browser's in WASM.
            string date = lastChange.ToLocalTime().ToString("d");
            return string.IsNullOrWhiteSpace(Stats.LatestAuthor)
                ? $"Last Change: {date}"
                : $"Author: {Stats.LatestAuthor} · Last Change: {date}";
        }
    }

    protected override void OnInitialized()
    {
        Theme.Changed += OnThemeChanged;
        Sidebar.Changed += OnSidebarChanged;

        // The footer counter is fed by the navigation menu as it loads (see NavStats): no dedicated
        // count query, and refreshes are debounced so they never impact rendering.
        Stats.Changed += OnStatsChanged;
    }

    private void OnStatsChanged() => InvokeAsync(StateHasChanged);

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
        Stats.Changed -= OnStatsChanged;
        _selfRef?.Dispose();
    }
}
