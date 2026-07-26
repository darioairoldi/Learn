using Learn.Web.Shared.Navigation;

namespace Learn.Web.Navigation;

/// <summary>
/// Abstraction for building the site navigation tree on demand from the live content hierarchy.
/// </summary>
public interface INavBuilder
{
    /// <summary>Returns the immediate children for a given menu prefix (one level).</summary>
    Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default);

    /// <summary>Flattens the whole menu into navigable leaves + section breadcrumbs.</summary>
    Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default);

    /// <summary>
    /// Re-walks only the subtree under <paramref name="prefix"/> (bypassing any cache), refreshing
    /// the recursive per-folder aggregates for that branch. Used after a content change to update
    /// just the affected branch's counts instead of re-walking the whole tree. An empty prefix
    /// re-walks everything.
    /// </summary>
    Task RecomputeSubtreeAsync(string prefix, CancellationToken ct = default);
}
