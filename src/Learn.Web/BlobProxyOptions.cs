namespace Learn.Web;

/// <summary>
/// Configuration for the caching blob reverse-proxy. Bound from the <c>BlobProxy</c>
/// configuration section. The app forwards incoming requests to the storage account
/// described here, over HTTPS via the Blob SDK, using Managed Identity.
/// </summary>
public sealed class BlobProxyOptions
{
    /// <summary>
    /// Blob service endpoint of the target storage account, e.g.
    /// <c>https://samplestmcstitn01.blob.core.windows.net</c>.
    /// </summary>
    public string AccountUri { get; set; } = string.Empty;

    /// <summary>Container that holds the published static site (e.g. <c>learn</c>).</summary>
    public string ContainerName { get; set; } = string.Empty;

    /// <summary>Blob served (with a 404 status) when a requested path does not exist.</summary>
    public string NotFoundBlob { get; set; } = "404.html";

    /// <summary>Upper bound (in bytes) for the in-memory LRU cache. Default ~200 MB.</summary>
    public long CacheSizeLimitBytes { get; set; } = 200_000_000;

    /// <summary>
    /// Optional shared secret required (via the <c>X-Invalidate-Key</c> header) to call the
    /// cache-invalidation endpoint. When empty, the endpoint is open — rely on Easy Auth /
    /// network restrictions instead.
    /// </summary>
    public string InvalidateApiKey { get; set; } = string.Empty;
}
