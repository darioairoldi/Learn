

---
# Quarto Metadata
title: "Issue: Sidebar and body use mismatched backgrounds in dark mode"
author: "Dario Airoldi"
date: "2026-06-04"
categories: [issue, theming, dark-mode, quarto, css]
description: "When switching to a dark theme, the left navigation sidebar and the right content/body area render with two different dark backgrounds. The sidebar is painted #2b3035 by styles.css while the body uses #1a1d20 from theme-dark.scss, producing a visible two-tone split between the panels. Aligning the sidebar background to the body background removes the seam."
draft: true
---

# Issue Report

**Issue Title:** Left sidebar and right body area show two different dark backgrounds in dark mode

**Date Reported:** 2026-06-04
**Reporter:** Dario Airoldi
**Status:** Resolved — fix applied

| Field | Value |
|---|---|
| **Severity** | Low (visual polish / dark-mode consistency) |
| **Component** | Quarto docked sidebar (`#quarto-sidebar`) · page body background |
| **Framework / Tooling** | Quarto HTML render · `styles.css` · `theme-dark.scss` |
| **Symptom surface** | Any page rendered with a dark theme active (`body.quarto-dark`) |
| **Affected branch** | `main` |

---

## 📑 Table of Contents

- [📝 Observation](#-observation)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)

---

## 📝 Observation

When switching to a dark theme, the left navigation panel and the right body area are clearly
two different shades of dark. The sidebar looks lighter/greyer than the content area, leaving a
visible vertical seam down the page.

![The left sidebar and the right body area use two different dark backgrounds](images/001.01-bgcolor-issue.png)

---

## 🔍 Context information

Dark styling in this repo is produced by two cooperating layers:

| Surface | Background color | Defined in |
|---|---|---|
| Body / content area | `#1a1d20` | `$body-bg` in [theme-dark.scss](../../../../../theme-dark.scss) |
| Left sidebar (`#quarto-sidebar`) | `#2b3035` | `body.quarto-dark #quarto-sidebar` rule in [styles.css](../../../../../styles.css) |

`#2b3035` is the `$light` surface token (used for cards and code blocks). It is a lighter grey
than the body's `#1a1d20`, so the sidebar and the content area never matched.

The runtime Bootswatch theme switcher in
[header-includes.html](../../../../../header-includes.html) re-emits an equivalent sidebar rule
for dark Bootswatch themes, but there it correctly uses each theme's own `theme.bg`, so the
mismatch only appeared with the repo's built-in `theme-dark.scss` dark mode.

---

## 🔬 Analysis

**Root cause.** The sidebar background and the body background were set from two *different*
tokens:

- The body inherited `$body-bg` (`#1a1d20`) — the genuine dark base color.
- The sidebar was explicitly overridden to the lighter surface token `#2b3035` (`$light`).

Because both rules use `!important`, the lighter sidebar color won within the sidebar and the
darker body color won everywhere else, so the two panels could never converge. The intent of a
"surface" tint for the sidebar was reasonable in isolation, but against the very dark body it
read as a mismatch rather than as subtle layering.

**Impact.** Purely visual: no functional or accessibility regression, but the two-tone split
breaks the "single uniform dark surface" expectation and looks unintentional.

---

## ✅ Solution implemented

Aligned the dark-mode sidebar background to the body background so both panels render as one
uniform dark surface. The border color is retained so the sidebar edge stays distinguishable.

```css
/* Dark theme: ensure the left sidebar (docked navigation) follows dark styles.
   Match the body background ($body-bg in theme-dark.scss) so the sidebar and
   the content area render as a single, uniform dark surface. */
body.quarto-dark #quarto-sidebar,
body.quarto-dark .sidebar.sidebar-navigation,
body.quarto-dark nav.sidebar-navigation {
  background-color: #1a1d20 !important;  /* was #2b3035 */
  border-color: #495057 !important;
}
```

**File changed:** [styles.css](../../../../../styles.css)

---

## 📚 Additional information

- **Alternative direction:** If a layered look is preferred instead of a flat one, the opposite
  fix is valid — set `$body-bg` (or the body background) to `#2b3035` so the *content* matches
  the lighter sidebar. The current fix favors a single flat dark surface.
- **Single source of truth:** A more robust long-term approach is to drive the sidebar
  background from a CSS variable tied to `$body-bg` (e.g. `var(--bs-body-bg)`) rather than a
  hard-coded hex, so the two surfaces can never drift apart again.
- **Bootswatch parity:** No change was needed in `header-includes.html`; its dark override
  already derives the sidebar color from the active theme's `bg`.

---

## ✔️ Resolution status

**Status:** Resolved

- [x] Root cause identified (two different background tokens)
- [x] Fix applied to `styles.css`
- [ ] Visually verified in dark mode after Quarto rebuild
- [ ] Confirmed Bootswatch dark themes still match (no regression)

---

## 🎓 Lessons learned

- **Use one token for one surface intent.** Sidebar and body should reference the same base
  background variable when the design goal is a uniform surface; hard-coded hex values in
  separate files drift apart silently.
- **`!important` hides mismatches.** Because both rules forced their color, the discrepancy
  could only be resolved by editing the source values, not by cascade order.
- **Check both styling layers.** Dark mode here is produced by `theme-dark.scss` *and*
  `styles.css` (plus the runtime switcher). A color question must be traced through all of them.