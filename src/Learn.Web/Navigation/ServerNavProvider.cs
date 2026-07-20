using Diginsight.Diagnostics;
using Learn.Web.Shared.Navigation;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Navigation;

/// <summary>Server-side <see cref="INavProvider"/> — builds levels in-process (used during prerender).</summary>
public sealed class ServerNavProvider(DynamicNavBuilder builder, ILogger<ServerNavProvider> logger) : INavProvider
{
    public async Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        return await builder.GetChildrenAsync(prefix, ct);
    }

    public async Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return await builder.GetIndexAsync(ct);
    }
}
