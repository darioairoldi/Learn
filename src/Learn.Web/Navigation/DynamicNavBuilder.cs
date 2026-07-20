using Diginsight.Diagnostics;
using Learn.Web.Shared.Navigation;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Navigation;

/// <summary>
/// Builds one level of the site menu on demand from the live content hierarchy, applying the
/// sidebar spec rules (exclusions, single-article collapse, index/readme representation,
/// date-preserving labels, newest-first ordering, icon heuristic). Results are cached per prefix
/// and gated by a monotonic version so an AI writer can invalidate after changing content.
/// </summary>
public sealed class DynamicNavBuilder(IContentLister lister, IMemoryCache cache, ILogger<DynamicNavBuilder> logger)
{
    private static long _version = 1;

    /// <summary>Current nav version; bumps on <see cref="Invalidate"/>.</summary>
    public static long Version => Interlocked.Read(ref _version);

    /// <summary>Drops all cached levels and advances the version (call after content writes).</summary>
    public void Invalidate()
    {
        Interlocked.Increment(ref _version);
        if (cache is MemoryCache mc)
        {
            mc.Clear();
        }
    }

    public async Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        prefix = (prefix ?? string.Empty).Replace('\\', '/').Trim('/');
        string key = $"nav:{_version}:{prefix}";
        if (cache.TryGetValue(key, out IReadOnlyList<NavChild>? cached) && cached is not null)
        {
            return cached;
        }

        IReadOnlyList<NavChild> built = await BuildLevelAsync(prefix, ct);
        cache.Set(key, built, new MemoryCacheEntryOptions { SlidingExpiration = TimeSpan.FromSeconds(60) });
        return built;
    }

    /// <summary>Flattens the whole menu into navigable leaves + section breadcrumbs (cached per version).</summary>
    public async Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger);

        string key = $"navindex:{_version}";
        if (cache.TryGetValue(key, out IReadOnlyList<NavLeaf>? cached) && cached is not null)
        {
            return cached;
        }

        var leaves = new List<NavLeaf>();
        await WalkAsync(string.Empty, string.Empty, leaves, ct);
        cache.Set(key, (IReadOnlyList<NavLeaf>)leaves,
            new MemoryCacheEntryOptions { SlidingExpiration = TimeSpan.FromSeconds(60) });
        return leaves;
    }

    private async Task WalkAsync(string prefix, string path, List<NavLeaf> leaves, CancellationToken ct)
    {
        foreach (NavChild n in await GetChildrenAsync(prefix, ct))
        {
            if (n.IsSection && n.Prefix is not null)
            {
                string childPath = path.Length == 0 ? n.Text : $"{path} › {n.Text}";
                await WalkAsync(n.Prefix, childPath, leaves, ct);
            }
            else if (!string.IsNullOrEmpty(n.Route))
            {
                leaves.Add(new NavLeaf(n.Text, n.Route, path));
            }
        }
    }

    private async Task<IReadOnlyList<NavChild>> BuildLevelAsync(string prefix, CancellationToken ct)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        IReadOnlyList<ChildEntry> raw = await lister.ListChildrenAsync(prefix, ct);
        var scored = new List<(SortTuple Key, NavChild Node)>();

        foreach (ChildEntry entry in raw)
        {
            if (NavRules.IsExcludedName(entry.Name) || IsTempRoot(prefix, entry.Name))
            {
                continue;
            }

            if (entry.IsFolder)
            {
                FolderMeta meta = await ReadFolderMetaAsync(entry.Path, ct);
                if (meta.Hidden)
                {
                    continue; // metadata.yml opted the folder out of navigation
                }

                NavChild? folderNode = await ClassifyFolderAsync(entry, meta, ct);
                if (folderNode is not null)
                {
                    // An explicit metadata.yml order joins the numeric-prefix group (ascending).
                    SortTuple key = meta.Order is double order
                        ? new SortTuple(0, order, entry.Name.ToLowerInvariant())
                        : NavRules.SortKey(entry.Name);
                    scored.Add((key, folderNode));
                }
            }
            else if (NavRules.IsMarkdown(entry.Name) && !NavRules.IsIndexName(entry.Name))
            {
                string? head = await lister.ReadHeadAsync(entry.Path, ct);
                if (FrontMatter.Parse(head).Hidden)
                {
                    continue;
                }

                string label = FrontMatter.ResolveTitle(head)
                    ?? NavRules.Label(Path.GetFileNameWithoutExtension(entry.Name));
                scored.Add((NavRules.SortKey(entry.Name),
                    new NavChild(label, Route(entry.Path), null, null, false, false)));
            }
        }

        List<NavChild> result = scored
            .OrderBy(x => x.Key.Group).ThenBy(x => x.Key.Num).ThenBy(x => x.Key.Text, StringComparer.Ordinal)
            .Select(x => x.Node)
            .ToList();

        // The site root gets a leading Home link.
        if (prefix.Length == 0)
        {
            result.Insert(0, new NavChild("Home", string.Empty, null, "house-fill", false, false));
        }

        return result;
    }

    /// <summary>Decides whether a folder is a section, a collapsed single link, or nothing.</summary>
    private async Task<NavChild?> ClassifyFolderAsync(ChildEntry folder, FolderMeta meta, CancellationToken ct)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger, new { folder });

        IReadOnlyList<ChildEntry> kids = await lister.ListChildrenAsync(folder.Path, ct);

        var subFolders = kids.Where(k => k.IsFolder && !NavRules.IsExcludedName(k.Name) && !NavRules.IsAssetFolder(k.Name)).ToList();
        var articles = kids.Where(k => !k.IsFolder && NavRules.IsMarkdown(k.Name)
                                       && !NavRules.IsExcludedName(k.Name) && !NavRules.IsIndexName(k.Name)).ToList();
        ChildEntry? index = kids.FirstOrDefault(k => !k.IsFolder && NavRules.IsIndexName(k.Name));

        string icon = meta.Icon ?? NavRules.IconFor(folder.Name, folder.Name);

        // Section: has meaningful subfolders, or more than one article.
        if (subFolders.Count > 0 || articles.Count > 1)
        {
            string? href = index is not null || articles.Count > 0 ? Route(folder.Path) : null;
            return new NavChild(meta.Label ?? NavRules.Label(folder.Name), href, folder.Path, icon, true, true, meta.Short, meta.TopbarHidden, meta.TopbarAlign);
        }

        // Collapse: exactly one article (or only an index/readme) → single link.
        ChildEntry? single = articles.Count == 1 ? articles[0] : index;
        if (single is null)
        {
            return null; // no publishable content
        }

        // Collapsed folders render as article links: no folder symbol unless metadata.yml sets one.
        string? head = await lister.ReadHeadAsync(single.Path, ct);
        if (articles.Count == 1 && FrontMatter.Parse(head).Hidden)
        {
            return index is null ? null
                : new NavChild(meta.Label ?? NavRules.Label(folder.Name), Route(folder.Path), null, meta.Icon, false, false);
        }

        string? title = FrontMatter.ResolveTitle(head);
        string label = meta.Label ?? (title is not null
            ? NavRules.WithDatePrefix(folder.Name, title)
            : NavRules.Label(folder.Name));
        string route = single == index ? Route(folder.Path) : Route(single.Path);
        return new NavChild(label, route, null, meta.Icon, false, false);
    }

    /// <summary>Reads a folder's optional <c>metadata.yml</c> overrides (absent file → no overrides).</summary>
    private async Task<FolderMeta> ReadFolderMetaAsync(string folderPath, CancellationToken ct)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger, new { folderPath });

        string dir = (folderPath ?? string.Empty).Replace('\\', '/').Trim('/');
        string key = dir.Length == 0 ? "metadata.yml" : $"{dir}/metadata.yml";
        string? text = await lister.ReadHeadAsync(key, ct);
        return FolderMeta.Parse(text);
    }

    // Root-level folders that are project/infrastructure, not site content (only relevant when the
    // content source is the repo filesystem; the blob container holds content only).
    private static readonly HashSet<string> RootInfra = new(StringComparer.OrdinalIgnoreCase)
    {
        "src", "deploy", "docs", "scripts", "readme_files", "bin", "obj", "node_modules",
        "99.00-temp",
    };

    private static bool IsTempRoot(string prefix, string name) =>
        prefix.Length == 0 && RootInfra.Contains(name);

    private static string Route(string path)
    {
        string r = path.Replace('\\', '/').Trim('/');
        foreach (string ext in new[] { ".md", ".qmd" })
        {
            if (r.EndsWith(ext, StringComparison.OrdinalIgnoreCase))
            {
                return r[..^ext.Length];
            }
        }

        return r;
    }
}
