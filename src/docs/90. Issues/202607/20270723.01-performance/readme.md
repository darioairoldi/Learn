---
title: "Learn.Web UI navigation bugs: topbar dropdowns, sidebar keyboard nav, and section routing"
author: "Dario Airoldi"
date: "2026-07-24"
categories: [issue, bug-fix, learn-web]
description: "Multiple UI and navigation bugs discovered and fixed in the Learn.Web Blazor application: topbar menus clipped by CSS overflow, dropdown items without routes, missing keyboard tree navigation, cold-start cache poisoning, and section landing pages"
publish: true
---

# Learn.Web UI navigation bugs: topbar dropdowns, sidebar keyboard nav, and section routing

**Date reported:** 2026-07-24
**Reporter:** Dario Airoldi
**Status:** Resolved
**Severity:** Medium–High
**Component:** `Learn.Web` / `Learn.Web.Client` / `Learn.Web.Shared`
**Framework:** .NET 10 (Blazor WebAssembly with server prerendering)

## Table of Contents

- [📝 Description](#-description)
- [ℹ️ Context information](#%E2%84%B9%EF%B8%8F-context-information)
- [🔍 Analysis](#-analysis)
  - [Bug 1 — Topbar dropdown menus not opening](#bug-1--topbar-dropdown-menus-not-opening)
  - [Bug 2 — Dropdown items not navigating to articles](#bug-2--dropdown-items-not-navigating-to-articles)
  - [Bug 3 — Sidebar arrow-key navigation not working](#bug-3--sidebar-arrow-key-navigation-not-working)
  - [Bug 4 — Cold-start cache poisoning](#bug-4--cold-start-cache-poisoning)
- [✅ Solutions implemented](#-solutions-implemented)
- [📚 References](#-references)

## 📝 Description

A debugging and testing session uncovered four interconnected bugs in the Learn.Web Blazor WASM application that affected both mouse and keyboard navigation:

| # | Bug | Symptom | Impact |
|---|-----|---------|--------|
| 1 | Topbar dropdown menus clipped | Hovering/clicking top-bar section buttons (News, Events, Tech, How-To) produced no visible dropdown | Users could not browse section contents from the top bar |
| 2 | Dropdown items without routes | Items like "Azure", "Data", "Programming Languages" in the Tech dropdown were non-clickable headers | Many sections were unreachable from the top bar |
| 3 | Sidebar arrow-key navigation broken | ArrowLeft/Right had zero effect on the sidebar tree; no `tabindex`, `role`, or `aria-expanded` attributes existed | Keyboard-only users could not navigate the sidebar |
| 4 | Cold-start cache poisoning | First request during server startup returned a partial article count (e.g. 19 instead of 1,121) that got cached permanently | Footer stats showed wrong numbers until server restart |

## ℹ️ Context information

**Environment:**

| Property | Value |
|----------|-------|
| OS | Windows 11 |
| Runtime | .NET 10 (Blazor WASM + server prerender) |
| Server | Kestrel on `http://localhost:5280` |
| Browser | Microsoft Edge |
| Content source | Local filesystem |
| Caching | Diginsight SmartCache (server) + in-memory task cache (WASM client) |

**Application architecture:**

- `Learn.Web` — ASP.NET server host, Markdig renderer, navigation endpoints (`/_nav/*`)
- `Learn.Web.Client` — Blazor WASM interactive client, sidebar (`DynNav`/`DynNavNode`), topbar (`TopMenu`/`TopMenuDropdown`)
- `Learn.Web.Shared` — Razor Class Library shared between server and client (`ContentView`, `PageLoader`, `INavProvider`)
- Navigation tree is built at runtime by `DynamicNavBuilder` from the live content hierarchy and cached by `CachedDynamicNavBuilder`

## 🔍 Analysis

### Bug 1 — Topbar dropdown menus not opening

**Root cause:** The CSS rule `.topmenu-left` had `overflow: hidden` to prevent horizontal overflow when the window narrowed. This created a clipping context that hid the absolutely-positioned `.topmenu-dropdown` panels, which extend below the topbar.

```css
/* BEFORE (broken) */
.topmenu-left {
    flex: 1 1 auto;
    min-width: 0;
    overflow: hidden;        /* ← clips the dropdown */
    justify-content: flex-start;
}
```

The `.topmenu-dropdown` has `position: absolute; top: 100%; z-index: 60`, so it needs to overflow its parent vertically. The `overflow: hidden` on the flex container clipped it entirely.

**Impact:** All left-aligned topbar sections (News, Events, Tech, How-To) had invisible dropdowns. Right-aligned sections (Ideas, Other, Culture) were unaffected because `.topmenu-right` did not have `overflow: hidden`.

### Bug 2 — Dropdown items not navigating to articles

**Root cause:** `DynamicNavBuilder.BuildFolderAsync()` set a section's route to `null` when the folder had no index file and no direct articles:

```csharp
// BEFORE (broken)
string? href = index is not null || articles.Count > 0 ? Route(folder.Path) : null;
```

Many section folders (e.g. `03.00-tech/02.01-azure/`) contain only subfolders — no `index.md`, `readme.md`, or direct `.md` files. These sections got `route = null`.

In `TopMenuDropdown.razor`, items with `node.Route == null` rendered as `<span class="dropdown-header">` — visually similar to links but non-clickable:

```razor
@if (node.Route is not null)
    <li><a class="dropdown-link" href="@node.Route">@node.Text</a></li>
@else
    <li class="dropdown-group"><span class="dropdown-header">@node.Text</span></li>
```

Even for sections that DID have routes, navigating to a folder path with no index file resulted in a "Not found" page because `PageLoader.Candidates()` only tried `.md`/`index.md`/`overview.md`/`readme.md` extensions.

**Affected sections (Tech dropdown):** Azure, Data, Programming Languages, Web Development, Github, Httpclient, Markdown — 7 of 13 items were non-clickable.

### Bug 3 — Sidebar arrow-key navigation not working

**Root cause (part A — focus management):** The sidebar tree used native `<details>/<summary>` elements for collapsible sections and `<NavLink>` for articles, but none had `tabindex`, `role`, or `aria-expanded` attributes. Focus could not be moved to nav items via Tab or keyboard.

**Root cause (part B — key handler scoping):** The existing JavaScript handlers for ArrowLeft/Right in `app-ui.js` used `details.querySelector('ul.nav-list a.nav-link, ul.nav-list summary')` to find the first child when stepping into an expanded section. Due to CSS selector scoping (the `details` element is itself a descendant of an outer `<ul class="nav-list nav-top">`), this selector matched the *current* summary rather than a child — focus stayed put.

```javascript
// BEFORE (broken — matched self due to ancestor ul.nav-list)
var child = details.querySelector('ul.nav-list a.nav-link, ul.nav-list summary');

// AFTER (fixed — :scope restricts to direct child list)
var child = details.querySelector(':scope > ul.nav-list a.nav-link, :scope > ul.nav-list summary');
```

**Impact:** Keyboard-only navigation of the sidebar was completely non-functional. No WAI-ARIA tree pattern was present.

### Bug 4 — Cold-start cache poisoning

**Root cause:** During server startup, `WarmAllLevelsAsync()` was called before the content hierarchy was fully indexed. The first `GetChildrenAsync("")` call returned partial data (only the levels cached so far). This partial result was cached permanently by SmartCache, so all subsequent requests — including the footer article-count aggregation — used the stale data.

The fix was to call `InvalidateLevels()` between `GetIndexAsync()` (which populates the full tree) and `WarmAllLevelsAsync()` (which re-caches each level from the now-complete data).

**Impact:** Footer displayed "Total Articles: 19" instead of "Total Articles: 1,121" until the server was restarted.

## ✅ Solutions implemented

### Fix 1 — Topbar dropdown visibility

**File:** `src/Learn.Web/wwwroot/app.css`

Removed `overflow: hidden` from `.topmenu-left`. The flex layout with `min-width: 0` already handles horizontal shrinking without clipping vertical dropdown overflow.

```css
/* AFTER (fixed) */
.topmenu-left {
    flex: 1 1 auto;
    min-width: 0;
    justify-content: flex-start;
}
```

### Fix 2 — Section routing and landing pages

Three changes:

1. **`src/Learn.Web/Navigation/DynamicNavBuilder.cs`** — Always assign a route to sections, even without an index file:

    ```csharp
    string? href = Route(folder.Path);
    ```

2. **`src/Learn.Web.Client/Layout/TopMenuDropdown.razor`** — For sections without a route but with a prefix, render as a link using the prefix path:

    ```razor
    @if (node.Route is not null)
        <li><a class="dropdown-link" href="@node.Route">@node.Text</a></li>
    @else if (node.Prefix is not null)
        <li><a class="dropdown-link" href="@(node.Prefix.TrimEnd('/'))">@node.Text</a></li>
    ```

3. **`src/Learn.Web.Shared/Components/ContentView.razor` + `.razor.cs`** — When `PageLoader` finds no markdown but the path is a valid section with children, show a section landing page (list of child links) instead of "Not found":

    ```razor
    @if (_page is null && _sectionChildren is not null)
    {
        <article class="markdown-body section-landing">
            <h1>@SectionTitle()</h1>
            <ul class="section-landing-list">
                @foreach (NavChild child in _sectionChildren)
                    <li><a href="@child.Route">@child.Text</a></li>
            </ul>
        </article>
    }
    ```

### Fix 3 — Sidebar keyboard tree navigation

Two changes:

1. **`src/Learn.Web.Client/Layout/DynNavNode.razor`** — Added WAI-ARIA tree attributes:
    - `role="treeitem"` on `<li>` elements
    - `aria-expanded` on section `<li>` elements
    - `role="group"` on child `<ul>` lists
    - `tabindex="0"` on `<summary>` and `<NavLink>` elements

2. **`src/Learn.Web.Client/Layout/DynNav.razor`** — Added `role="tree"` to the root `<ul>`.

3. **`src/Learn.Web/wwwroot/js/app-ui.js`** — Fixed the `:scope` selector bug and set the standard tree-view arrow key mapping:
    - **ArrowRight:** expand section / enter first child
    - **ArrowLeft:** collapse section / go to parent
    - **ArrowUp/Down:** move between visible siblings

### Fix 4 — Cold-start cache invalidation

**File:** `src/Learn.Web/Program.cs`

Added `InvalidateLevels()` call between `GetIndexAsync` and `WarmAllLevelsAsync` to ensure the full tree is used for warm-up caching.

## 📚 References

- 📘 [WAI-ARIA Tree View pattern](https://www.w3.org/WAI/ARIA/apg/patterns/treeview/): W3C specification for keyboard-navigable tree views
- 📘 [CSS overflow and absolute positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/overflow): MDN documentation on how `overflow: hidden` creates a clipping context for positioned descendants
- 📘 [CSS :scope pseudo-class](https://developer.mozilla.org/en-US/docs/Web/CSS/:scope): MDN documentation on scoping `querySelector` selectors to the calling element
- 📘 [Blazor `details`/`summary` interaction](https://learn.microsoft.com/en-us/aspnet/core/blazor/): Microsoft documentation on Blazor component lifecycle and DOM interaction
