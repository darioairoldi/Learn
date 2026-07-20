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

    /// <summary>SmartCache layer over the content source (off by default; see <see cref="CacheOptions"/>).</summary>
    public CacheOptions Cache { get; set; } = new();
}

/// <summary>
/// SmartCache configuration for the content layer. Caches the Markdown source-byte fetch
/// (the expensive blob/file read) in-memory, optionally backed by Redis for distributed,
/// multi-instance sharing. Disabled by default — behavior is unchanged unless <see cref="Enabled"/> is set.
/// </summary>
public sealed class CacheOptions
{
    /// <summary>Enables the SmartCache decorator over the content source.</summary>
    public bool Enabled { get; set; }

    /// <summary>How long a cached content entry stays fresh before it is re-fetched, in seconds (default: 60 minutes).</summary>
    public int MaxAgeSeconds { get; set; } = 3600;

    /// <summary>Optional Redis backing store enabling distributed, multi-instance caching.</summary>
    public RedisOptions Redis { get; set; } = new();
}

/// <summary>Redis backing-store settings for <see cref="CacheOptions"/>.</summary>
public sealed class RedisOptions
{
    /// <summary>StackExchange.Redis connection string. When empty, caching stays in-memory only.</summary>
    public string Configuration { get; set; } = string.Empty;

    /// <summary>Key prefix isolating this app's entries within a shared Redis instance.</summary>
    public string KeyPrefix { get; set; } = "learn-content:";
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
