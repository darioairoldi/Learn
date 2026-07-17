using System.Security.Cryptography;
using Microsoft.AspNetCore.StaticFiles;
using Learn.Web.Shared;

namespace Learn.Web.ContentSources;

/// <summary>
/// Reads content from the local repo clone. Used on the developer machine so the app renders
/// straight from source with no storage credentials.
/// </summary>
public sealed class FileSystemContentSource : IContentSource
{
    private static readonly FileExtensionContentTypeProvider ContentTypes = new();
    private readonly string _root;

    public FileSystemContentSource(string rootPath)
    {
        _root = Path.TrimEndingDirectorySeparator(Path.GetFullPath(rootPath));
    }

    public async Task<ContentResult?> GetAsync(string contentKey, CancellationToken ct = default)
    {
        string relative = contentKey.Replace('\\', '/').TrimStart('/');
        string full = Path.GetFullPath(Path.Combine(_root, relative));

        // Path-traversal guard: never serve outside the configured root (OWASP A01/A05).
        string boundary = _root + Path.DirectorySeparatorChar;
        if (!full.Equals(_root, StringComparison.OrdinalIgnoreCase) &&
            !full.StartsWith(boundary, StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        if (!File.Exists(full))
        {
            return null;
        }

        byte[] bytes = await File.ReadAllBytesAsync(full, ct);
        string contentType = ContentTypes.TryGetContentType(full, out string? mime) && mime is not null
            ? mime
            : "text/plain; charset=utf-8";
        string etag = "\"" + Convert.ToHexString(SHA1.HashData(bytes)) + "\"";
        return new ContentResult(bytes, contentType, etag);
    }
}
