---
title: "Issue analysis: Learning Hub rebuilds the entire site on every deploy"
author: "Dario Airoldi"
date: "2026-07-12"
date-modified: last-modified
categories: [issue, quarto, build, ci-cd, navigation]
description: "Root-cause analysis of why the Quarto Learning Hub performs a full-site render on every deploy, and the path to an incremental (progressive) build."
draft: true
---

# Issue analysis

**Issue title:** Learning Hub performs a full-site render on every deploy (no incremental build)

**Date reported:** 2026-07-11  
**Reporter:** Dario Airoldi  
**Status:** Open  
**Severity:** High (developer productivity / scalability)  
**Component:** Quarto build pipeline and site navigation (CI/CD, `_quarto.yml`)  
**Framework:** Quarto 1.6.42 static site generator; GitHub Actions (self-hosted runner); GitHub Pages

---

## Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution direction](#-solution-direction)
- [🗺️ Improvement plan](#️-improvement-plan)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

> **Companion document:** the deep architectural design lives in [overview.md](overview.md). This document is the issue-report framing (root cause, reproduction, resolution tracking); it cross-links to the overview for the target architecture rather than duplicating it.

## 📝 Description

The Learning Hub is a Quarto `website` project published to GitHub Pages. Every deploy performs a **full render of the entire site**, regardless of how little changed. A one-word edit to a single article triggers the same work as a complete rebuild.

**Expected behavior:** an *append-mostly* documentation site should build **incrementally** — only new or modified articles compiled to HTML and placed into `docs/` at the correct path, with the left menu updated as an independent step.

**Current behavior:** the CI deletes the entire output and cache, re-runs Pandoc across the whole render whitelist (267 entries, several of which are directory globs), and force-pushes the whole `docs/` tree to `gh-pages`.

**Impact points:**

- A routine content edit takes **tens of minutes** to publish.
- Build time grows **linearly with the archive size**, so the problem worsens monotonically as articles accumulate.
- The slow feedback loop discourages small, frequent edits — the natural cadence of a learning journal.
- CI compute (self-hosted runner) is consumed re-rendering hundreds of unchanged pages on every push.

## 🔍 Context information

| Item | Value |
|---|---|
| Repository | Learn |
| Issue folder | `src/docs/90. Issues/202607/20270711.02-progressive-build/` |
| Trigger | Build time reached "tens of minutes" as article count grew |
| Site generator | Quarto 1.6.42 (`project.type: website`) |
| Output directory | `docs/` (served by GitHub Pages from `gh-pages`) |
| Render whitelist size | 267 entries in `project.render` (several are `**/*.md` globs) |
| Total renderable `.md`/`.qmd` in repo | ~1,481 files |
| Native sidebar size | ≈340 lines under `website.sidebar.contents` |
| Shared shell | `header-includes.html` (521 lines), `styles.css`, `theme-light.scss`, `theme-dark.scss` |

### Type of issue

This is a **performance / scalability issue in the build pipeline**, not a content or correctness bug. The site builds *correctly*; it simply builds *wastefully*. Severity is rated **High** because the cost scales with content and already blocks fast iteration.

### Artifacts inspected

- [.github/workflows/quarto-publish.direct.yml](../../../../../.github/workflows/quarto-publish.direct.yml) — render + deploy steps
- [_quarto.yml](../../../../../_quarto.yml) — `project.type`, `project.render`, `website.sidebar`, `execute`, `format`
- [scripts/generate-navigation.ps1](../../../../../scripts/generate-navigation.ps1) — generates `navigation.json`
- `_includes/right-nav.html` — "Related Pages" widget (Loading… placeholder)
- `header-includes.html` — theme switcher + sidebar-resize handle (no navigation fetch)

## 🔬 Analysis

The full-site rebuild is caused by **four independent factors**, each of which forces whole-site work. All four must be addressed to reach a seconds-scale build. The design response to each is developed in [overview.md](overview.md); this section states the root causes.

### Root cause 1 — The sidebar is baked into every page

Quarto's `website.sidebar` is compiled into the HTML `<body>` of **every** rendered page, physically duplicating the ≈340-line menu into hundreds of output files. Any menu change invalidates every page, and even a content-only edit regenerates that page's sidebar block. The menu is therefore **not independent** of page content today — it is embedded in it.

### Root cause 2 — CI destroys the cache before every render

The render step deletes `docs/`, `.quarto/`, and `_freeze/` before calling `quarto render`. Even if Quarto could skip unchanged work, the wipe guarantees a cold start on every run.

### Root cause 3 — Project-mode `quarto render` re-runs Pandoc on the entire render list

A project-level `quarto render` converts **all** 267 whitelist entries. There is no built-in "skip if HTML is newer than Markdown" for website projects, so the Pandoc conversion runs for every prose page each time.

### Root cause 4 — `freeze` is unset (and would not help prose anyway)

There is no `freeze:` key under `execute:`. Quarto's freeze cache is unused — and even if enabled, `freeze` caches only *computational* output (executed code cells), not the Pandoc conversion of prose. For a mostly-prose site, `freeze` alone cannot deliver incremental builds.

### Two decisive findings

| # | Finding | Consequence |
|---|---|---|
| A | The live left menu is **100% native Quarto**, baked per page | The coupling to break for independent menu updates |
| B | `navigation.json` and `_includes/right-nav.html` **already exist but are vestigial** — generated/copied yet never fetched by the live site | Most of the client-side-menu plumbing is already built; it needs wiring, not inventing |

Finding B is the good news: the content-independent menu the solution needs was **already envisioned and partially implemented**. See [overview.md → Two decisive findings](overview.md#two-decisive-findings).

### Impact assessment

| Dimension | Assessment |
|---|---|
| Correctness | Unaffected — the site renders correctly today |
| Velocity | Severely degraded — minutes per trivial edit; worsens with growth |
| Scalability | Poor — cost is O(site size) per change instead of O(change size) |
| CI cost | High — hundreds of unchanged pages re-rendered every push |
| Risk of change | Moderate — decoupling the menu changes navigation UX and search indexing |

## 🔄 Reproduction steps

1. Make a one-line edit to any single whitelisted article (for example, a typo fix in a `summary.md`).
2. Commit and push to `main`.
3. Observe the CI run of [quarto-publish.direct.yml](../../../../../.github/workflows/quarto-publish.direct.yml):
   - The **Render Quarto Project** step deletes `docs/`, `.quarto/`, `_freeze/`, then runs `quarto render --to html` across all 267 render-list entries.
   - The **Deploy** step force-pushes the entire regenerated `docs/` tree to `gh-pages`.
4. Measure wall-clock time: it is **independent of the change size** and scales with total article count (currently tens of minutes).

**Expected (incremental):** step 3 should render only the one changed file and copy only the changed output.

### Affected code locations

| Location | Role in the issue |
|---|---|
| [.github/workflows/quarto-publish.direct.yml](../../../../../.github/workflows/quarto-publish.direct.yml) | Cache wipe + project-wide render + full force-push |
| [_quarto.yml](../../../../../_quarto.yml) `project.render` | 267 entries re-rendered every build |
| [_quarto.yml](../../../../../_quarto.yml) `website.sidebar` | ≈340-line menu baked into every page (Root cause 1) |
| [_quarto.yml](../../../../../_quarto.yml) `execute` | No `freeze:` configured (Root cause 4) |
| [scripts/generate-navigation.ps1](../../../../../scripts/generate-navigation.ps1) | Produces `navigation.json` that the live site never consumes |

## ✅ Solution direction

Two independences must hold simultaneously (full design in [overview.md → Target architecture](overview.md#target-architecture)):

1. **Page independence** — a page's HTML must be a pure function of *its own* Markdown plus shared CSS/JS, never of the menu or sibling pages. Achieved by removing the sidebar from page output.
2. **Menu independence** — the menu must live in **one** runtime-loaded artifact (`navigation.json`) so it behaves as an external "page selector": updating it replaces one file for the whole site, and updating a page never touches the menu.

With both in place, the build becomes: render only `git diff ∩ whitelist`, regenerate `navigation.json` only when structure changes, and deploy only changed files.

## 🗺️ Improvement plan

Sequenced to de-risk: Phase 1 captures most of the win with minimal architectural change; Phase 2 completes the decoupling. (📌 next steps — not yet started.)

### Phase 1 — Change-detection with the current architecture (🟡 todo)

- Stop deleting `docs/`, `.quarto/`, `_freeze/` in CI. (🟡 todo)
- Derive the render set from `git diff --name-only <last-deployed-sha>..HEAD` intersected with the `project.render` whitelist. (🟡 todo)
- Render each changed file individually via `quarto render "<file>"`. (🟡 todo)
- Replace the orphan-branch force-push with an incremental commit that copies only changed outputs. (🟡 todo)
- Trigger a full rebuild **only** when `_quarto.yml` sidebar YAML changes (rare), to avoid stale baked-in menus. (🟡 todo)

**Exit criteria:** a single-article edit publishes in seconds; menu-structure edits still full-rebuild. (🟡 todo)

### Phase 2 — Decouple the menu to client-side (🟡 todo)

- Disable/empty the native `website.sidebar` so pages stop embedding menu markup. (🟡 todo)
- Add a client-side menu loader (injected via a shared include) that fetches `navigation.json`, renders the left menu, and highlights the current page by `location.pathname`. (🟡 todo)
- Reduce menu updates to regenerating and copying a single `navigation.json`. (🟡 todo)
- Decide the site-wide search strategy (periodic full index vs. an incremental client index such as Pagefind). (🟡 todo)

**Exit criteria:** no change type except shared-asset edits touches more than the changed pages. (🟡 todo)

## 📚 Additional information

### Validation to perform before migrating

The six open validations (single-file render path parity, sidebar-disable approach, loader injection point, baseline-SHA persistence, first-build fallback, incremental deploy mechanics) are enumerated in [overview.md → Open questions and validations](overview.md#open-questions-and-validations).

### Performance expectation after migration

| Change type | Work performed | Rough cost |
|---|---|---|
| Edit one article | Render 1 file + deploy diff | seconds |
| Add one article | Render 1 file + regenerate `navigation.json` + deploy diff | seconds |
| Reorder/rename menu entry | Regenerate `navigation.json`, copy 1 file | ~1 second |
| Change theme / global CSS / shared header | Full rebuild | minutes (rare) |

### Migration considerations

- Client-side navigation makes the menu JS-dependent (page content remains server-rendered, so per-page SEO is unaffected).
- Quarto's built-in active-page highlighting and prev/next must be reimplemented in the loader.
- The self-hosted runner resets its Git state between runs, so the `<last-deployed-sha>` baseline must be persisted durably (a marker on `gh-pages`, a tag, or a workflow artifact).

## ✔️ Resolution status

**Current status:** Open — analysis complete, implementation not started.

### Verification checklist

- Root causes identified and evidenced. (✅ done)
- Target architecture documented in [overview.md](overview.md). (✅ done)
- Phase 1 CI change-detection implemented and verified. (🟡 todo)
- Phase 2 client-side menu implemented and verified. (🟡 todo)
- Single-file render path parity confirmed against project render. (🟡 todo)
- Incremental deploy confirmed to publish only changed files. (🟡 todo)

### Follow-up actions

- Draft the Phase 1 CI workflow changes (change-detection + incremental deploy). (📌 next steps)
- Prototype single-file `quarto render` output-path parity on one representative article. (📌 next steps)
- Wire `navigation.json` into a client-side loader behind a feature flag before disabling the native sidebar. (📌 next steps)

## 🎓 Lessons learned

**What went right:**

- The content-independent menu infrastructure (`navigation.json` generator, `right-nav.html` widget) was already designed and built — a strong head start for Phase 2.
- The `project.render` whitelist is explicit, which makes computing the incremental render set (`git diff ∩ whitelist`) straightforward.

**What went wrong:**

- The `navigation.json` plumbing was built but never wired into the live theme, so it silently rotted into dead infrastructure while the site kept using the baked-in native sidebar.
- The CI's defensive cache wipe (`Remove-Item docs/.quarto/_freeze`) hard-codes a cold build, foreclosing any incremental gains.
- The default Quarto `website` model was adopted without accounting for how it couples navigation to every page — acceptable for a small site, costly at scale.

**Improvements for the future:**

- Treat "generated-but-unconsumed" artifacts as a smell: either wire them in or delete them, so intent and reality stay aligned.
- For append-mostly content sites, design for O(change) builds from the start — keep navigation as data (a single fetched file), not as per-page markup.

## 📎 Appendix

### Evidence summary

| Claim | Evidence |
|---|---|
| Full render every build | CI deletes `docs/`,`.quarto/`,`_freeze/` then runs `quarto render --to html` |
| 267 whitelist entries | Count of `- ` entries in `project.render` in `_quarto.yml` |
| Menu baked per page | `website.sidebar.contents` (≈340 lines) rendered by native Quarto |
| `navigation.json` unused | No fetch in `header-includes.html`; `right-nav.html` not referenced by `_quarto.yml` |
| `freeze` unset | No `freeze:` key under `execute:` in `_quarto.yml` |

### Key references

**[Quarto — Project rendering & `render` list](https://quarto.org/docs/projects/quarto-projects.html)** 📘 [Official]  
Basis for single-file vs. project render behavior and output-path parity.

**[Quarto — Website navigation](https://quarto.org/docs/websites/website-navigation.html)** 📘 [Official]  
Documents the per-page sidebar compilation (Root cause 1).

**[Quarto — Freeze](https://quarto.org/docs/projects/code-execution.html#freeze)** 📘 [Official]  
Confirms freeze caches computations only, not prose (Root cause 4).

**[overview.md](overview.md)** 📘 [Internal]  
Companion design document: target architecture, incremental pipeline, trade-offs, and validations.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}

article_metadata:
  filename: "analysis.md"
  created: "2026-07-12"
  status: "open"
  issue_type: "performance-scalability"
-->
