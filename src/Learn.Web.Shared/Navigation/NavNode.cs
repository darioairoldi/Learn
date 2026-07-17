using System.Text.Json;

namespace Learn.Web.Shared.Navigation;

/// <summary>
/// A single node of the site menu, parsed from <c>navigation.json</c>. A node is either a
/// link (<see cref="Href"/>), a section header with children (<see cref="Section"/> +
/// <see cref="Contents"/>), or a separator (<c>text == "---"</c>).
/// </summary>
public sealed class NavNode
{
    public string? Text { get; init; }
    public string? Section { get; init; }
    public string? Href { get; init; }
    public string? Icon { get; init; }
    public IReadOnlyList<NavNode>? Contents { get; init; }

    public bool IsSeparator =>
        Text == "---" && Section is null && Href is null && (Contents is null || Contents.Count == 0);

    /// <summary>Parses a <c>contents</c> element (an array; a string glob is ignored).</summary>
    public static IReadOnlyList<NavNode> ParseContents(JsonElement contents)
    {
        if (contents.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<NavNode>();
        }

        var list = new List<NavNode>();
        foreach (JsonElement element in contents.EnumerateArray())
        {
            list.Add(ParseNode(element));
        }

        return list;
    }

    private static NavNode ParseNode(JsonElement element)
    {
        IReadOnlyList<NavNode>? children = null;
        if (element.TryGetProperty("contents", out JsonElement contents))
        {
            children = ParseContents(contents);
        }

        return new NavNode
        {
            Text = GetString(element, "text"),
            Section = GetString(element, "section"),
            Href = GetString(element, "href"),
            Icon = GetString(element, "icon"),
            Contents = children,
        };
    }

    private static string? GetString(JsonElement element, string name) =>
        element.TryGetProperty(name, out JsonElement value) && value.ValueKind == JsonValueKind.String
            ? value.GetString()
            : null;

    /// <summary>Maps a navigation href (e.g. <c>foo/overview.md</c>) to an app route (<c>foo/overview</c>).</summary>
    public static string ToRoute(string? href)
    {
        if (string.IsNullOrEmpty(href))
        {
            return string.Empty;
        }

        string route = href.Replace('\\', '/').Trim('/');
        foreach (string ext in new[] { ".md", ".qmd", ".html", ".htm" })
        {
            if (route.EndsWith(ext, StringComparison.OrdinalIgnoreCase))
            {
                route = route[..^ext.Length];
                break;
            }
        }

        // Top-level index/readme map to the site root.
        return route.Equals("index", StringComparison.OrdinalIgnoreCase) ||
               route.Equals("readme", StringComparison.OrdinalIgnoreCase)
            ? string.Empty
            : route;
    }
}
