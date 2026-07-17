using Azure.Identity;
using Azure.Storage.Blobs;
using Learn.Web.Shared;

namespace Learn.Web.ContentSources;

/// <summary>
/// Reads content from the storage account container over HTTPS using a managed/CLI identity.
/// Used in production; the browser never sees storage credentials.
/// </summary>
public sealed class BlobContentSource : IContentSource
{
    private readonly BlobContainerClient _container;

    public BlobContentSource(string accountUri, string containerName)
    {
        var account = new Uri(accountUri.TrimEnd('/') + "/");
        var containerUri = new Uri(account, containerName);
        _container = new BlobContainerClient(containerUri, new DefaultAzureCredential());
    }

    public async Task<ContentResult?> GetAsync(string contentKey, CancellationToken ct = default)
    {
        BlobClient blob = _container.GetBlobClient(contentKey);
        if (!await blob.ExistsAsync(ct))
        {
            return null;
        }

        var response = await blob.DownloadContentAsync(ct);
        byte[] bytes = response.Value.Content.ToArray();
        string contentType = string.IsNullOrEmpty(response.Value.Details.ContentType)
            ? "text/plain; charset=utf-8"
            : response.Value.Details.ContentType;
        return new ContentResult(bytes, contentType, response.Value.Details.ETag.ToString());
    }
}
