using Learn.Web.Shared.Navigation;
using Learn.Web.Shared.Rendering;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace Learn.Web.Shared.Components;

public partial class ContentView
{
    [Parameter] public string? Path { get; set; }

    private RenderedPage? _page;
    private bool _loading = true;
    private IReadOnlyList<Crumb> _trail = Array.Empty<Crumb>();
    private NavLeaf? _prev;
    private NavLeaf? _next;

    protected override async Task OnParametersSetAsync()
    {
        _loading = true;
        _prev = _next = null;
        _trail = Array.Empty<Crumb>();
        Toc.SetEntries(Array.Empty<TocEntry>());
        _page = await Loader.LoadAsync(Path);
        _loading = false;
        Toc.SetEntries(_page?.Toc ?? Array.Empty<TocEntry>());

        // Breadcrumb + prev/next come from the (warm) flat index. Bound the wait so they prerender and
        // appear together with the article when the index is warm, while a rare cold rebuild never
        // blocks the page — the breadcrumb then fills in via LoadPrevNextAsync's own StateHasChanged.
        Task navTask = LoadPrevNextAsync(Path);
        await Task.WhenAny(navTask, Task.Delay(600));
    }

    // After each render on the interactive client, turn any ```mermaid blocks into SVG. OnAfterRender
    // never fires during static prerender, so JS interop is safe here.
    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (_loading || _page is null)
        {
            return;
        }

        try
        {
            await global::Microsoft.JSInterop.JSRuntimeExtensions.InvokeVoidAsync(JS, "appUi.renderMermaid");
        }
        catch
        {
            // Interop can be unavailable during prerender or mid-navigation teardown; never fatal.
        }
    }

    private async Task LoadPrevNextAsync(string? forPath)
    {
        IReadOnlyList<NavLeaf> index = await NavProvider.GetIndexAsync();
        if (Norm(forPath) != Norm(Path))
        {
            return; // navigated away while the index was loading
        }

        string cur = Norm(forPath);
        int idx = -1;
        for (int i = 0; i < index.Count; i++)
        {
            if (Norm(index[i].Route) == cur)
            {
                idx = i;
                break;
            }
        }

        _prev = idx > 0 ? index[idx - 1] : null;
        _next = idx >= 0 && idx < index.Count - 1 ? index[idx + 1] : null;

        // Breadcrumb: build the trail from the flat index leaf's section path (text segments) plus
        // the article title — the runtime index is the single source for navigation.
        if (_trail.Count == 0 && idx >= 0)
        {
            NavLeaf leaf = index[idx];
            var crumbs = new List<Crumb>();
            if (!string.IsNullOrEmpty(leaf.Path))
            {
                foreach (string seg in leaf.Path.Split('›', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
                {
                    crumbs.Add(new Crumb(seg, null));
                }
            }

            crumbs.Add(new Crumb(leaf.Text, null));
            _trail = crumbs;
        }
        else if (_trail.Count == 0 && idx < 0 && !string.IsNullOrEmpty(cur))
        {
            // Section / index landing pages are not leaves in the flat index. Their ancestors are all
            // real sections, so build a clickable trail cheaply from the per-level nav (no full index).
            _trail = await BuildTrailFromRouteAsync(cur);
        }

        await InvokeAsync(StateHasChanged);
    }

    // Builds a breadcrumb from a route's ancestor levels. Each level is cheap and cached, so this
    // works for section pages the flat index does not enumerate as leaves.
    private async Task<IReadOnlyList<Crumb>> BuildTrailFromRouteAsync(string route)
    {
        string[] segs = route.Split('/', StringSplitOptions.RemoveEmptyEntries);
        var crumbs = new List<Crumb>();
        string parent = string.Empty;
        for (int i = 0; i < segs.Length; i++)
        {
            string prefix = parent.Length == 0 ? segs[i] : parent + "/" + segs[i];
            IReadOnlyList<NavChild> level = await NavProvider.GetChildrenAsync(parent);
            NavChild? node = null;
            foreach (NavChild n in level)
            {
                if (Norm(n.Prefix) == prefix || Norm(n.Route) == prefix)
                {
                    node = n;
                    break;
                }
            }

            bool last = i == segs.Length - 1;
            string text = node?.Text ?? _page?.Title ?? segs[i].Replace('-', ' ').Replace('_', ' ');
            string? crumbRoute = !last && node?.Route is { Length: > 0 } r ? "/" + r.TrimStart('/') : null;
            crumbs.Add(new Crumb(text, crumbRoute));
            parent = prefix;
        }

        return crumbs;
    }

    private static string Norm(string? route) =>
        (route ?? string.Empty).Replace('\\', '/').Trim('/').ToLowerInvariant();

    public void Dispose() => Toc.SetEntries(Array.Empty<TocEntry>());
}
