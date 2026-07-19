using System.Globalization;
using System.Text.RegularExpressions;

namespace Learn.Web.Shared.Navigation;

/// <summary>
/// Optional per-folder navigation overrides, read from a dedicated <c>metadata.yml</c> file that
/// lives directly inside the folder. Any field left unset falls back to the code defaults
/// (curated root map, then the name-based heuristics in <see cref="NavRules"/>).
/// </summary>
/// <param name="Label">Sidebar (long) label overriding the derived folder name.</param>
/// <param name="Short">Top-bar (short) label; captured for the compact navbar.</param>
/// <param name="Icon">Bootstrap icon name overriding the icon heuristic.</param>
/// <param name="Order">Explicit sort weight (ascending) overriding the name-based ordering.</param>
/// <param name="Hidden">When true the folder is excluded from navigation entirely.</param>
public sealed record FolderMeta(string? Label, string? Short, string? Icon, double? Order, bool Hidden)
{
    /// <summary>No overrides — every field falls back to the code defaults.</summary>
    public static readonly FolderMeta None = new(null, null, null, null, false);

    // Flat "key: value" lines only (no nesting needed). Tolerates surrounding --- fences.
    private static readonly Regex KeyRx = new(
        @"(?m)^\s*(?<k>[A-Za-z0-9_-]+)\s*:\s*(?<v>.*?)\s*$", RegexOptions.Compiled);

    /// <summary>Parses the flat YAML of a folder's <c>metadata.yml</c>. Null/empty → <see cref="None"/>.</summary>
    public static FolderMeta Parse(string? yaml)
    {
        if (string.IsNullOrWhiteSpace(yaml))
        {
            return None;
        }

        string? label = null, shortLabel = null, icon = null;
        double? order = null;
        bool hidden = false;

        foreach (Match m in KeyRx.Matches(yaml))
        {
            string key = m.Groups["k"].Value.ToLowerInvariant();
            string value = Unquote(m.Groups["v"].Value);

            switch (key)
            {
                case "label" or "nav-label":
                    label = NullIfEmpty(value);
                    break;
                case "short" or "nav-short":
                    shortLabel = NullIfEmpty(value);
                    break;
                case "icon" or "nav-icon":
                    icon = NullIfEmpty(value);
                    break;
                case "order" or "nav-order":
                    if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out double o))
                    {
                        order = o;
                    }
                    break;
                case "hidden" or "nav-hidden":
                    hidden = value.Equals("true", StringComparison.OrdinalIgnoreCase);
                    break;
            }
        }

        return new FolderMeta(label, shortLabel, icon, order, hidden);
    }

    private static string Unquote(string v)
    {
        v = v.Trim();
        if (v.Length >= 2 && ((v[0] == '"' && v[^1] == '"') || (v[0] == '\'' && v[^1] == '\'')))
        {
            v = v[1..^1];
        }

        return v.Trim();
    }

    private static string? NullIfEmpty(string v) => string.IsNullOrWhiteSpace(v) ? null : v;
}
