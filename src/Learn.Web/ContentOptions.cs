namespace Learn.Web;

/// <summary>
/// Content configuration bound from the <c>Content</c> section. Source-agnostic keys live at
/// the top; source-specific settings are nested. <see cref="Source"/> selects the active block.
/// </summary>
public sealed class ContentOptions
{
    /// <summary>Active content source: <c>Blob</c> or <c>FileSystem</c>.</summary>
    public string Source { get; set; } = "Blob";

    /// <summary>Path served (with a 404) when a request resolves to nothing.</summary>
    public string NotFoundPath { get; set; } = "404.html";

    /// <summary>Optional shared secret guarding the cache-invalidation endpoint.</summary>
    public string InvalidateApiKey { get; set; } = string.Empty;

    public BlobOptions Blob { get; set; } = new();

    public FileSystemOptions FileSystem { get; set; } = new();
}

public sealed class BlobOptions
{
    public string AccountUri { get; set; } = string.Empty;
    public string ContainerName { get; set; } = string.Empty;
}

public sealed class FileSystemOptions
{
    /// <summary>Root folder that holds the Markdown content (resolved against the content root).</summary>
    public string RootPath { get; set; } = ".";
    public bool WatchForChanges { get; set; }
}
