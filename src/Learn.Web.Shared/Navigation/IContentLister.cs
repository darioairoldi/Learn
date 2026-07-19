namespace Learn.Web.Shared.Navigation;

/// <summary>A raw child of a storage "folder": either a sub-folder or a file, path-addressed.</summary>
public sealed record ChildEntry(string Name, bool IsFolder, string Path);

/// <summary>
/// Implemented by server-side content sources (filesystem/blob) that can enumerate one level of
/// the hierarchy and cheaply read a file's leading frontmatter. The WASM client never lists — it
/// calls the server nav API instead.
/// </summary>
public interface IContentLister
{
    /// <summary>Lists the immediate children (folders + files) under <paramref name="prefix"/> (one level).</summary>
    Task<IReadOnlyList<ChildEntry>> ListChildrenAsync(string prefix, CancellationToken ct = default);

    /// <summary>Reads just the leading frontmatter/header text of a file (no full download).</summary>
    Task<string?> ReadHeadAsync(string key, CancellationToken ct = default);
}

/// <summary>One built menu node returned by the nav API for a single level.</summary>
public sealed record NavChild(
    string Text,
    string? Route,
    string? Prefix,
    string? Icon,
    bool IsSection,
    bool HasChildren,
    string? Short = null);

/// <summary>A flattened navigable article (leaf) with its section breadcrumb — used by menu search.</summary>
public sealed record NavLeaf(string Text, string Route, string Path);
