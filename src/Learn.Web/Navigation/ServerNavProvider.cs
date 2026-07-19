using Diginsight.Diagnostics;
using Learn.Web.Shared.Navigation;
using Microsoft.Extensions.Logging;

namespace Learn.Web.Navigation;

/// <summary>Server-side <see cref="INavProvider"/> — builds levels in-process (used during prerender).</summary>
public sealed class ServerNavProvider(DynamicNavBuilder builder, ILogger<ServerNavProvider> logger) : INavProvider
{
    public Task<IReadOnlyList<NavChild>> GetChildrenAsync(string prefix, CancellationToken ct = default)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger, new { prefix });

        return builder.GetChildrenAsync(prefix, ct);
    }

    public Task<IReadOnlyList<NavLeaf>> GetIndexAsync(CancellationToken ct = default)
    {
        var activity = Observability.ActivitySource.StartMethodActivity(logger);

        return builder.GetIndexAsync(ct);
    }
}
