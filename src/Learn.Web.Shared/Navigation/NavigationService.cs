using System.Text.Json;

namespace Learn.Web.Shared.Navigation;

/// <summary>
/// Loads and caches the site menu from <c>navigation.json</c> via the active
/// <see cref="IContentSource"/> (filesystem/blob on the server, HTTP in the WASM client).
/// </summary>
public sealed class NavigationService(IContentSource source)
{
    private IReadOnlyList<NavNode>? _cache;

    public async Task<IReadOnlyList<NavNode>> GetAsync(CancellationToken ct = default)
    {
        if (_cache is not null)
        {
            return _cache;
        }

        ContentResult? result = await source.GetAsync("navigation.json", ct);
        if (result is null)
        {
            return _cache = Array.Empty<NavNode>();
        }

        try
        {
            // Strip a leading UTF-8 BOM (EF BB BF) if present — System.Text.Json rejects it.
            ReadOnlyMemory<byte> json = result.Bytes;
            if (json.Length >= 3 && json.Span[0] == 0xEF && json.Span[1] == 0xBB && json.Span[2] == 0xBF)
            {
                json = json[3..];
            }

            using JsonDocument doc = JsonDocument.Parse(json);
            _cache = doc.RootElement.TryGetProperty("contents", out JsonElement contents)
                ? NavNode.ParseContents(contents)
                : Array.Empty<NavNode>();
        }
        catch (JsonException)
        {
            _cache = Array.Empty<NavNode>();
        }

        return _cache;
    }

    /// <summary>
    /// Builds the breadcrumb trail (section → … → article) for the given route by locating
    /// the matching link in the navigation tree. Returns an empty trail for the site root or
    /// when the route is not present in the menu.
    /// </summary>
    public async Task<IReadOnlyList<Crumb>> GetTrailAsync(string? route, CancellationToken ct = default)
    {
        IReadOnlyList<NavNode> nodes = await GetAsync(ct);
        string target = (route ?? string.Empty).Replace('\\', '/').Trim('/');
        if (target.Length == 0)
        {
            return Array.Empty<Crumb>();
        }

        var trail = new List<Crumb>();
        return FindPath(nodes, target, trail) ? trail : Array.Empty<Crumb>();
    }

    private static bool FindPath(IReadOnlyList<NavNode> nodes, string target, List<Crumb> trail)
    {
        foreach (NavNode n in nodes)
        {
            if (n.IsSeparator)
            {
                continue;
            }

            if (n.Href is not null &&
                string.Equals(NavNode.ToRoute(n.Href), target, StringComparison.OrdinalIgnoreCase))
            {
                trail.Add(new Crumb(n.Text ?? n.Section ?? target, NavNode.ToRoute(n.Href)));
                return true;
            }

            if (n.Contents is { Count: > 0 })
            {
                trail.Add(new Crumb(n.Section ?? n.Text ?? string.Empty, FirstRoute(n.Contents)));
                if (FindPath(n.Contents, target, trail))
                {
                    return true;
                }

                trail.RemoveAt(trail.Count - 1);
            }
        }

        return false;
    }

    private static string? FirstRoute(IReadOnlyList<NavNode> nodes)
    {
        foreach (NavNode n in nodes)
        {
            if (n.IsSeparator)
            {
                continue;
            }

            if (n.Href is not null)
            {
                return NavNode.ToRoute(n.Href);
            }

            if (n.Contents is { Count: > 0 } && FirstRoute(n.Contents) is { } r)
            {
                return r;
            }
        }

        return null;
    }
}

/// <summary>A single breadcrumb entry. <see cref="Route"/> is null when the entry is not linkable.</summary>
public sealed record Crumb(string Text, string? Route);