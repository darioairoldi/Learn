using Learn.Web.Shared.Navigation;
using Microsoft.AspNetCore.Components;

namespace Learn.Web.Client.Layout;

public partial class TopMenuDropdown
{
    [Parameter] public IReadOnlyList<NavChild> Nodes { get; set; } = Array.Empty<NavChild>();
}
