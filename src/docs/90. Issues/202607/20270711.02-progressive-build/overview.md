---
title: "Progressive build resolved: Learning Hub is now a markdown-first dynamic site"
author: "Dario Airoldi"
date: "2026-07-20"
categories: [issue, learn-web, architecture, markdown-first, navigation]
description: "Session recap: the full-site-rebuild issue is resolved because the Learning Hub is now a markdown-first dynamic app (Learn.Web) that renders Markdown on demand and builds navigation at runtime. Covers the UI, folder-metadata, documentation, and changelog-leak work that completed the migration."
draft: true
---

# Progressive build resolved: Learning Hub is now a markdown-first dynamic site

**Date reported:** 2026-07-11 · **Recap date:** 2026-07-20
**Reporter:** Dario Airoldi
**Status:** ✅ Resolved — markdown-first architecture implemented; documentation aligned; a changelog-leak regression found and fixed
**Severity:** High (developer productivity / scalability) → Resolved
**Component:** `Learn.Web` dynamic site (ASP.NET Core / Blazor Web App, Markdig) · runtime navigation
**Framework:** .NET 10 · Blazor Web App (interactive WebAssembly) · Markdig

> **This recap consolidates and supersedes** the three working documents that previously lived in this
> folder (`00-analysis.md`, `01-issue-resolution-plan.md`, `02-markdown-first-rendering.md`). They were
> the analysis and design that led to the current architecture; the design they recommended
> (**markdown-first, Option B**) has since been **implemented**, so those intermediate files were removed.

---

## 📑 Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction (historical)](#-reproduction-historical)
- [✅ Solution implemented](#-solution-implemented)
- [🧭 What changed this session](#-what-changed-this-session)
- [📋 Documentation to update](#-documentation-to-update)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)
- [📚 References](#-references)

---

## 📝 Description

The Learning Hub was originally a **Quarto `website` project**: every deploy performed a **full render of
the entire site**, and a one-word edit cost the same as a complete rebuild (tens of minutes, growing with
article count). The original analysis framed this as a build that is **O(site size) per change** instead of
**O(change size)**, and proposed two directions: a phased change-detection build (Phase 1/2) or a
**markdown-first** redesign that removes the build entirely.

**The markdown-first direction was chosen and implemented.** The live site is now the `Learn.Web` app,
which renders Markdown to HTML **on demand at request time** (Markdig) and builds its navigation **at
runtime** from the live content hierarchy. There is **no build step, no static `docs/` output, and no
`gh-pages` push** — publishing an article collapses to "make the Markdown available to the app."

This session completed the migration's loose ends: it aligned the UI (top bar, sidebar keyboard
navigation, folder-metadata-driven placement), instrumented the new nav/content entry points with
Diginsight, rewrote the repository documentation that still described the retired Quarto model, and found
and fixed a regression where sidecar `*.changelog.md` files leaked into the live menu.

---

## 🔍 Context information

| Property | Value |
|---|---|
| Live site | `Learn.Web` on Azure App Service (`learn-testmc-app-itn-01`), content from storage account `samplestmcstitn01/learn` |
| Rendering | Markdig, in-process, on demand — no build step, no static output |
| Navigation | `DynamicNavBuilder` + `/_nav` API, built at runtime from the content hierarchy |
| Content source | `FileSystemContentSource` (dev, repo clone) or `BlobContentSource` (prod), selected by `Content:Source` config |
| Projects | `src/Learn.Web` (server host) + `src/Learn.Web.Client` (WASM) + `src/Learn.Web.Shared` (RCL) |
| Observability | Diginsight (server project only) |

### Architecture: before → after

| Concern | Before (Quarto static) | After (markdown-first dynamic) |
|---|---|---|
| Page body HTML | Pandoc at build time → `docs/*.html` | Markdig in-process, per request |
| Left menu / sidebar | Baked into every rendered page | App shell builds it at runtime from the hierarchy |
| Menu ordering / labels | Hand-wired in `_quarto.yml` | Deterministic `NavRules` + per-folder `metadata.yml` |
| Publish | Full render → upload/`gh-pages` push | Upload the changed `.md` — live on next request |
| Source of truth | `.md` in git → `docs/` HTML in storage | `.md` in the content source |
| Build cost per edit | O(site size) — tens of minutes | O(change size) — effectively zero |

---

## 🔬 Analysis

The original analysis attributed the full rebuild to four independent factors. The markdown-first
architecture **eliminates each by construction** rather than mitigating it:

| # | Original root cause | How markdown-first removes it |
|---|---|---|
| 1 | Sidebar baked into every page (whole-site coupling) | The app owns the shell; the menu is built at runtime and is **never part of a page artifact**. Menu independence is automatic. |
| 2 | CI wiped the cache before every render | There is no CI render and no cache to wipe; rendering is a per-request, in-process operation. |
| 3 | Project-mode `quarto render` re-ran Pandoc on the whole list | There is no project render; a page's HTML is a pure function of **its own** Markdown plus the shared shell. |
| 4 | `freeze` unset (and useless for prose) | Irrelevant — there is no build cache to configure; the corpus is ~99% CommonMark, which Markdig renders in sub-millisecond time. |

### Regression discovered this session — changelog files leaked into the live menu

While reconciling the documentation with the code, a gap surfaced: the retired Quarto model kept
`*.changelog.md` sidecar files off the site via the `render:` allow-list. The dynamic builder has no
allow-list, and its filters did **not** exclude changelog files:

- `FileSystemContentSource.ListChildrenAsync` enumerates **every** file (no hidden/changelog filter).
- `FrontMatter.Hidden` is only `true` for `publish: false` / `draft: true` — which changelog files do not set.
- `NavRules.IsExcludedName` only skipped `_`/`.`-prefixed names.

So `article.changelog.md` siblings were **markdown, not index, not excluded** → they appeared as menu
items **and** flipped single-article folders into expandable sections (because `articles.Count` counted the
changelog as a second article). This was live: ~26 changelog files existed in content folders.

---

## 🔄 Reproduction (historical)

The original build-time problem (now moot) reproduced as:

1. Make a one-line edit to any whitelisted article.
2. Push to `main`.
3. CI deleted `docs/`, `.quarto/`, `_freeze/`, ran a whole-project `quarto render` across 267 render-list
   entries, and uploaded the entire regenerated `docs/` tree.
4. Wall-clock time was **independent of the change size** and scaled with total article count.

Under the current architecture there is nothing to reproduce: an edited `.md` is live on the next request.

---

## ✅ Solution implemented

The resolution is the **markdown-first dynamic app** (`Learn.Web`), already in production:

- **On-demand rendering** — Markdig renders Markdown → HTML per request; HTML exists only in an in-memory
  cache, never as a stored artifact.
- **Runtime navigation** — `DynamicNavBuilder` (`/_nav`) discovers content live; a menu item exists because
  its folder/file exists. Ordering/labels/icons/visibility come from `NavRules` + per-folder `metadata.yml`.
- **Content-source abstraction** — `IContentSource` with `FileSystemContentSource` (dev) and
  `BlobContentSource` (prod); the dev path renders straight from the repo clone with no credentials.
- **Publish = upload a `.md`** — no build, no `gh-pages`, no baseline-SHA bookkeeping.

---

## 🧭 What changed this session

| Area | Change |
|---|---|
| **Observability** | Added Diginsight `StartMethodActivity` to the nav/content entry points: [ServerNavProvider.cs](../../../../../src/Learn.Web/Navigation/ServerNavProvider.cs), [ContentEndpoints.cs](../../../../../src/Learn.Web/Endpoints/ContentEndpoints.cs), [NavEndpoints.cs](../../../../../src/Learn.Web/Endpoints/NavEndpoints.cs). Static endpoint classes use `ILoggerFactory.CreateLogger(typeof(...))` since `ILogger<T>` can't take a static type argument. |
| **Top bar** | Whole menu cluster right-aligned and flush to the border; on shrink, items clip from the **left** (right-side controls stay reachable) — verified flush (12 px) with zero overflow from 1400 → 640 px. |
| **Folder metadata (new keys)** | `topbar-hidden` (drop a folder from the top bar only — used to remove **Issues**, kept in the sidebar) and `topbar-align: left\|right` (metadata-driven left/right split, replacing the hardcoded `RightOrder`). Carried on `NavChild`, honored in `TopMenu`. |
| **Sidebar keyboard nav** | Fixed ArrowLeft not collapsing an active-branch folder: `DynNavNode` was force-opening the active branch on **every** parent re-render, so a collapse never stuck. Now the active branch auto-opens **once per active route**. Verified in a visible browser with real key presses. |
| **Documentation migration** | De-Quarto-ized ~40 artifacts (see [Appendix](#-appendix)): [copilot-instructions.md](../../../../../.github/copilot-instructions.md), the `90.00-learning-hub` context files, the vision lifecycle doc, the learning-hub prompts, and a bulk "Quarto metadata" → "frontmatter metadata" label fix across prompts/templates/agents/skills. |
| **Changelog-leak fix** | [NavRules.cs](../../../../../src/Learn.Web.Shared/Navigation/NavRules.cs) `IsExcludedName` now also excludes `*.changelog.md` — a single choke point covering the level menu, the flat search index, and the section-vs-collapse decision. Verified: index dropped 1143 → **1117** (~26 changelogs removed), 0 changelog entries remaining, single-article folders stay collapsed. |

---

## 📋 Documentation to update

A repository scan found Learn-Site documentation and code comments that described the retired Quarto
model. The `.github` and `.copilot/context/90.00-learning-hub` artifacts were fixed earlier this session;
the **P1 and P2 context/instruction items were fixed in this pass**. The table records each item's disposition:

| Priority | Location | Issue | Status |
|---|---|---|---|
| **P1 — misdirects** | [01-article-creation-workflow.md](../../../../../.copilot/context/01.00-article-writing/workflows/01-article-creation-workflow.md) | "Update `_quarto.yml` if article should appear in navigation" | ✅ **Fixed** — now "navigation updates automatically (no config to edit)" |
| **P1 — misdirects** | [03-series-planning-workflow.md](../../../../../.copilot/context/01.00-article-writing/workflows/03-series-planning-workflow.md) | "Add all articles to `_quarto.yml` navigation" | ✅ **Fixed** — now "navigation updates automatically" |
| **P2 — stale index** | [00.00-context-folder-index.md](../../../../../.copilot/context/00.00-context-folder-index.md) | `06`/`07` rows described as Quarto / `_quarto.yml` | ✅ **Fixed** — rows now point to `src/Learn.Web` DynamicNavBuilder / NavRules |
| **P2 — stale framing** | [00.06-folder-metadata-inheritance.md](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md) | "Quarto-safe by location / Quarto render root" | ✅ **Fixed** — now "renderer-safe by location" (`_`-prefix excluded by `NavRules`) |
| **P2 — label** | [01.07-critical-rules-priority-matrix.md](../../../../../.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md), [03-article-creation-rules.md](../../../../../.copilot/context/01.00-article-writing/03-article-creation-rules.md) | "Quarto metadata" / "Quarto rendering convention" labels | ✅ **Fixed** — "renderer frontmatter" |
| **P2 — self-reference** | [technical-writing series](../../../../../03.00-tech/40.00-technical-writing/) (`00-foundations`, `02-structure`) | Used the site's own `_quarto.yml` as a live example | ✅ **Fixed** — reframed to the runtime folder-hierarchy model, with sibling changelogs (v1.1.1 / v1.0.1) |
| **P3 — navigation.json** | `TopMenu`/`TopMenuDropdown` rewritten on `NavChild`; [ContentView.razor](../../../../../src/Learn.Web.Shared/Components/ContentView.razor) index-based breadcrumb; `NavigationService`/`NavNode`/`NavMenu`/`NavTree` **deleted**; [deploy-learninghub.yml](../../../../../.github/workflows/deploy-learninghub.yml) no longer uploads it | `navigation.json` dependency (top bar + breadcrumb + deploy) | ✅ **Dismissed** — top bar unified onto `DynamicNavBuilder`; `navigation.json` never requested (verified) |
| **Retired machinery** | `_quarto.yml`, `index.qmd`, `navigation.json`, `theme-*.scss`, `styles*.css`, `header-includes.html`, `_filters/`, `_includes/`, `scripts/generate-navigation.ps1`, `dev-serve.bat`, disabled `*quarto*` + `workflows/old/*` | Retired Quarto machinery | ✅ **Removed** — deleted this pass; `docs/` is gitignored local output (left) |
| **Topic tutorials — leave** | `03.00-tech/20.01-markdown/01-quarto/**`, `…/03-hugo/**` | Teach Quarto/Hugo as subjects | ➖ **Leave** — not descriptions of the live site |

> **Resolved:** the top-bar/sidebar hybrid is gone — the top bar was unified onto `DynamicNavBuilder`,
> `navigation.json` (and `NavigationService`/`NavNode`/`NavMenu`/`NavTree`) were removed, and the deploy
> no longer uploads it. Both the top bar and the sidebar now build from the same live content hierarchy.

---

## ✔️ Resolution status

- Markdown-first architecture implemented and live (`Learn.Web`, Markdig, `/_nav`). (✅ done)
- Original four root causes eliminated by construction. (✅ done)
- Top bar right-aligned with left-clipping; **Issues** removed from the top bar via `topbar-hidden`. (✅ done)
- Sidebar ArrowLeft collapse fixed and verified with real key presses. (✅ done)
- Nav/content entry points instrumented with Diginsight. (✅ done)
- `.github` + `90.00-learning-hub` documentation de-Quarto-ized (~40 artifacts). (✅ done)
- Changelog-leak regression fixed and verified (index 1143 → 1117). (✅ done)
- P1 + P2 (context/instruction) documentation updates applied; see [Documentation to update](#-documentation-to-update). (✅ done)
- Technical-writing content articles reframed (`00-foundations` v1.1.1, `02-structure` v1.0.1) with changelogs. (✅ done)
- Top bar unified onto `DynamicNavBuilder`; `navigation.json` and its components removed (verified never requested). (✅ done)
- Retired Quarto machinery removed (`_quarto.yml`, `index.qmd`, `navigation.json`, themes/styles/includes, nav generator, disabled workflows). (✅ done)

---

## 🎓 Lessons learned

- **Removing a build can remove a guarantee.** The Quarto `render:` allow-list silently kept changelog
  files off the site. Dropping the build dropped that guarantee — the changelog leak only surfaced because
  documentation and code were reconciled. When retiring a pipeline, enumerate the *implicit* guarantees it
  provided, not just its explicit outputs.
- **A single choke point beats scattered filters.** The changelog fix landed in one method
  (`NavRules.IsExcludedName`) that every enumeration path already flows through — level menu, flat index,
  and the section/collapse decision — so one line closed all three surfaces.
- **Docs drift outlives the code migration.** The infrastructure had already moved off Quarto (disabled
  workflows, Pages redirect), but ~40 documentation artifacts still taught the old model — and a truncated
  first grep hid a duplicate template tree. Verify scope with an un-truncated search before estimating.
- **Verify UI on real hardware.** The MCP browser harness does not deliver real key events; a headed Edge
  window driven by `playwright-core` was required to confirm the ArrowLeft fix behaves for a real user.

---

## 📎 Appendix

### Documentation artifacts changed this session (de-Quarto migration)

- **Highest authority:** [copilot-instructions.md](../../../../../.github/copilot-instructions.md) (+ its governing `pe-copilot-instructions-file.instructions.md`).
- **Context (`90.00-learning-hub`):** `00-repository-configuration`, `01-domain-concepts`, `02-dual-yaml-metadata`, `05-visual-formatting-guidelines`, `06-folder-organization-and-navigation`, `07-sidebar-menu-rules`.
- **Vision:** [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) (incremental-integration principle recast) and the automated-content-lifecycle doc (Phase 7 rewrite).
- **Prompts:** the Quarto-menu prompt retired to a deprecation stub; the conference-sessions and kebab-notation learning-hub prompts de-Quarto-ized; a bulk "Quarto metadata" → "frontmatter metadata" label fix across ~30 article-writing prompts, templates (two duplicate trees), agents, and skills.

### Code changed this session

- [ServerNavProvider.cs](../../../../../src/Learn.Web/Navigation/ServerNavProvider.cs), [ContentEndpoints.cs](../../../../../src/Learn.Web/Endpoints/ContentEndpoints.cs), [NavEndpoints.cs](../../../../../src/Learn.Web/Endpoints/NavEndpoints.cs) — Diginsight instrumentation.
- [NavRules.cs](../../../../../src/Learn.Web.Shared/Navigation/NavRules.cs) — `*.changelog.md` exclusion.
- `FolderMeta` / `NavChild` / `DynamicNavBuilder` / `TopMenu` — `topbar-hidden` + `topbar-align` folder-metadata keys.
- `DynNavNode` — active-branch auto-open once per route; `MainLayout` + `app.css` — top-bar layout.

---

## 📚 References

**[Program.cs — Learn.Web host](../../../../../src/Learn.Web/Program.cs)** 📘 [Internal]
Wires the content-source abstraction, Markdig renderer, dynamic nav, and endpoints.

**[DynamicNavBuilder.cs](../../../../../src/Learn.Web/Navigation/DynamicNavBuilder.cs)** 📘 [Internal]
Builds the menu and flat index at runtime from the content hierarchy.

**[NavRules.cs](../../../../../src/Learn.Web.Shared/Navigation/NavRules.cs)** 📘 [Internal]
Deterministic naming/ordering/exclusion rules — now the single point that excludes `*.changelog.md`.

**[07-sidebar-menu-rules.md](../../../../../.copilot/context/90.00-learning-hub/07-sidebar-menu-rules.md)** 📘 [Internal]
The runtime navigation spec (reframed this session).

**[06-folder-organization-and-navigation.md](../../../../../.copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md)** 📘 [Internal]
Folder naming + runtime ordering (glob/`_quarto.yml` section removed).

**[deploy-learninghub.yml](../../../../../.github/workflows/deploy-learninghub.yml)** 📘 [Internal]
Current content deploy — uploads Markdown source; no Quarto build.

**[Markdig — CommonMark/GFM processor for .NET](https://github.com/xoofx/markdig)** 📘 [Official]
The in-process rendering engine that replaced the Quarto toolchain.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}

article_metadata:
  filename: "overview.md"
  created: "2026-07-20"
  status: "resolved"
  issue_type: "architecture-migration-recap"
  supersedes: ["00-analysis.md", "01-issue-resolution-plan.md", "02-markdown-first-rendering.md"]
-->
