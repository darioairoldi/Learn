namespace Learn.Web.Shared;

/// <summary>
/// Shared, per-circuit light/dark theme state. The layout applies it as a CSS
/// class; the standalone toggle button and the About menu's theme controls all
/// drive it through this single source of truth.
/// </summary>
public sealed class ThemeState
{
    public bool Dark { get; private set; }

    public event Action? Changed;

    public void SetDark(bool dark)
    {
        if (Dark == dark)
        {
            return;
        }

        Dark = dark;
        Changed?.Invoke();
    }

    public void Toggle() => SetDark(!Dark);

    public void Reset() => SetDark(false);
}
