namespace Learn.Web.Shared;

/// <summary>
/// Per-circuit sidebar UI state shared by the layout, the sidebar toolbar, and the nav nodes:
/// collapsed (icon-rail) state plus a broadcast expand-all / collapse-all toggle. The search
/// filter is kept local to the sidebar component since only it consumes it.
/// </summary>
public sealed class SidebarState
{
    /// <summary>Whether the left menu is collapsed to a narrow icon rail (false = full menu).</summary>
    public bool Collapsed { get; private set; }

    /// <summary>Latest expand-all state; newly rendered sections honour it while it is true.</summary>
    public bool AllExpanded { get; private set; }

    /// <summary>Raised when <see cref="Collapsed"/> changes (layout re-renders the sidebar).</summary>
    public event Action? Changed;

    /// <summary>Raised on expand-all (true) / collapse-all (false) so live nodes react.</summary>
    public event Action<bool>? ExpandAllRequested;

    public void ToggleCollapsed()
    {
        Collapsed = !Collapsed;
        Changed?.Invoke();
    }

    public void SetCollapsed(bool value)
    {
        if (Collapsed == value)
        {
            return;
        }

        Collapsed = value;
        Changed?.Invoke();
    }

    /// <summary>Flips expand-all ⇄ collapse-all for the whole tree (single-button toggle).</summary>
    public void ToggleExpandAll()
    {
        AllExpanded = !AllExpanded;
        ExpandAllRequested?.Invoke(AllExpanded);
    }
}
