using System.Net.Http.Json;
using Learn.Web.Shared.Navigation;

namespace Learn.Web.Client;

/// <summary>WASM <see cref="INavProvider"/> — fetches one level per prefix from the nav API, cached in-memory.</summary>
public sealed class HttpNavProvider(HttpClient http) : INavProvider
{
    private readonly Dictionary<string, IReadOnlyList<NavChild>> _cache = new();
    private IReadOnlyList<NavLeaf>? _index;

    public async Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        prefix ??= string.Empty;
        if (_cache.TryGetValue(prefix, out IReadOnlyList<NavChild>? cached))
        {
            return cached;
        }

        try
        {
            List<NavChild>? result = await http.GetFromJsonAsync<List<NavChild>>(
                $"_nav/children?prefix={Uri.EscapeDataString(prefix)}", ct);
            IReadOnlyList<NavChild> value = result ?? new List<NavChild>();
            _cache[prefix] = value;
            return value;
        }
        catch
        {
            return Array.Empty<NavChild>();
        }
    }

    public async Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
    {
        if (_index is not null)
        {
            return _index;
        }

        try
        {
            List<NavLeaf>? result = await http.GetFromJsonAsync<List<NavLeaf>>("_nav/index", ct);
            return _index = result ?? new List<NavLeaf>();
        }
        catch
        {
            return Array.Empty<NavLeaf>();
        }
    }
}
