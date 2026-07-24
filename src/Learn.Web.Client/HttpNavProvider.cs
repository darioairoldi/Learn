using System.Net.Http.Json;
using Learn.Web.Shared.Navigation;

namespace Learn.Web.Client;

/// <summary>WASM <see cref="INavProvider"/> — fetches one level per prefix from the nav API, cached in-memory.</summary>
public sealed class HttpNavProvider(HttpClient http) : INavProvider
{
    // Cache the in-flight TASK (not just the result) so concurrent callers for the same prefix
    // (sidebar + both top-bar halves during the initial render) share ONE HTTP request instead of
    // each firing their own. WASM is single-threaded, so a plain Dictionary is safe here.
    private readonly Dictionary<string, Task<IReadOnlyList<NavChild>>> _children = new();
    private Task<IReadOnlyList<NavLeaf>>? _index;

    public Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        prefix ??= string.Empty;
        if (_children.TryGetValue(prefix, out Task<IReadOnlyList<NavChild>>? existing))
        {
            return existing;
        }

        Task<IReadOnlyList<NavChild>> task = FetchChildrenAsync(prefix, ct);
        _children[prefix] = task;
        return task;
    }

    /// <summary>Drops the cached task for <paramref name="prefix"/> so the next fetch re-hits the API.</summary>
    public Task<IReadOnlyList<NavChild>> RefreshChildrenAsync(string prefix, CancellationToken ct = default)
    {
        prefix ??= string.Empty;
        _children.Remove(prefix);
        return GetChildrenAsync(prefix, ct);
    }

    private async Task<IReadOnlyList<NavChild>> FetchChildrenAsync(string prefix, CancellationToken ct)
    {
        try
        {
            List<NavChild>? result = await http.GetFromJsonAsync<List<NavChild>>(
                $"_nav/children?prefix={Uri.EscapeDataString(prefix)}", ct);
            return result ?? new List<NavChild>();
        }
        catch
        {
            _children.Remove(prefix); // drop the failed task so a later call can retry
            return Array.Empty<NavChild>();
        }
    }

    public Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
        => _index ??= FetchIndexAsync(ct);

    private async Task<IReadOnlyList<NavLeaf>> FetchIndexAsync(CancellationToken ct)
    {
        try
        {
            List<NavLeaf>? result = await http.GetFromJsonAsync<List<NavLeaf>>("_nav/index", ct);
            return result ?? new List<NavLeaf>();
        }
        catch
        {
            _index = null; // drop the failed task so a later call can retry
            return Array.Empty<NavLeaf>();
        }
    }
}
