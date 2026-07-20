using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace Learn.Web.Client.Layout;

public partial class MainLayout
{
    private bool _searchOpen;
    private bool _notifyOpen;
    private DotNetObjectReference<MainLayout>? _selfRef;

    protected override void OnInitialized()
    {
        Theme.Changed += OnThemeChanged;
        Sidebar.Changed += OnSidebarChanged;
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
        _selfRef?.Dispose();
    }
}
