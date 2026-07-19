namespace Learn.Web.Shared.Navigation;

/// <summary>
/// Supplies one menu level at a time. On the server it wraps the in-process nav builder; in the
/// WASM client it calls the <c>/_nav/children</c> API. This keeps prerender working without HTTP.
/// </summary>
public interface INavProvider
{
    Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default);

    /// <summary>Returns the flattened list of navigable articles for menu search.</summary>
    Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default);
}
