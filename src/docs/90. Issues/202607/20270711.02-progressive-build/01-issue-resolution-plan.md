---
title: "Phase 1 resolution plan: change-detection incremental build"
author: "Dario Airoldi"
date: "2026-07-12"
date-modified: last-modified
categories: [plan, quarto, build, ci-cd]
description: "Actionable Phase 1 plan to make the Learning Hub build incremental via change-detection, without changing the current Quarto website architecture."
status: actionable
goal: "Make the Learning Hub build incremental for the common case (content-only edits) by rendering only changed files and deploying only changed outputs — WITHOUT decoupling the menu. Full menu independence (Phase 2) is explicitly out of scope and parked pending design decisions."
draft: true
---

# Phase 1 resolution plan: change-detection incremental build

> **Source analysis:** [00-analysis.md](00-analysis.md). This plan implements the **Phase 1** solution only. **Phase 2** (client-side menu decoupling) is parked pending the open decisions in the analysis.

**Status:** actionable — gate passed (see [Actionability gate](#-actionability-gate)); not yet started.

## Motivation

Today every deploy re-renders all 267 render-list entries and force-pushes the whole `docs/` tree, so a one-line edit costs tens of minutes. Phase 1 removes that waste for content-only edits — the common case — by rendering and deploying only what changed, while keeping the current Quarto `website` architecture intact (low risk, high value).

## Table of contents

- [🎯 Goal and scope](#-goal-and-scope)
- [🧪 Actionability gate](#-actionability-gate)
- [⚙️ Things to do — Phase 1 workstream](#-things-to-do--phase-1-workstream)
- [🏁 Exit criteria](#-exit-criteria)
- [🅿️ Park lot](#-park-lot)
- [❓ Open decisions](#-open-decisions)
- [🔎 Discovery](#-discovery)

## 🎯 Goal and scope

**Goal:** a single-article edit publishes in seconds instead of tens of minutes, by rendering only changed files and committing only changed outputs to `gh-pages`.

**In scope (Phase 1):**

- Change-detection in CI (`git diff ∩ project.render whitelist`).
- Per-file `quarto render` of changed articles.
- Incremental deploy to `gh-pages` (replace the orphan-branch full wipe).
- A safe full-rebuild fallback for shared-asset and sidebar-YAML changes.

**Out of scope (parked → Phase 2):** disabling the native sidebar, the client-side `navigation.json` menu loader, and the search-index strategy. See [Park lot](#-park-lot).

## 🧪 Actionability gate (✅ done)

Run before writing the body (documented per `plan-execution.instructions.md`). Analysis section — complete once recorded.

| # | Check | Result |
|---|---|---|
| 1 | Goal alignment (narrowing explicit) | Pass — full request is incremental build; this plan is explicitly the Phase 1 narrowing |
| 2 | Goal reachability | Pass — steps below reach "single edit publishes in seconds" |
| 3 | Execution determinism | Pass — each step has one reasonable execution; render-parity risk routed to Discovery |
| 4 | Clarity & actionability | Pass — validations carry defined negative branches (Discovery) |
| 5 | Unknown resolution | Pass — no user-blocking decision in Phase 1; baseline-SHA uses a stated default |
| 6 | Scope discipline | Pass — Phase 2 items parked, not in the active list |
| 7 | Coverage promise | Pass — each goal item lands in a step below |
| 8 | Principle impact | N/A — not a vision-amendment plan |

## ⚙️ Things to do — Phase 1 workstream (🟡 todo)

Action section. Implement in order.

1. Add a **baseline SHA** mechanism: read the last-deployed commit from a `.last-deployed-sha` marker committed to the `gh-pages` branch; if absent, treat the run as a first build (full render). (🟡 todo)
2. Compute **changed inputs**: `git diff --name-only <baseline>..HEAD -- '*.md' '*.qmd'`, then intersect with the `project.render` whitelist to form `render_set`. (🟡 todo)
3. Remove the unconditional cache wipe (`Remove-Item docs/.quarto/_freeze`) from [quarto-publish.direct.yml](../../../../../.github/workflows/quarto-publish.direct.yml); retain `docs/` and `.quarto/` between runs. (🟡 todo)
4. Render **only** `render_set` via per-file `quarto render "<file>" --to html`, writing to the mirrored `docs/` path. (🟡 todo)
5. Add a **full-rebuild trigger**: if the diff touches `_quarto.yml`, `header-includes.html`, `styles.css`, or `theme-*.scss`, fall back to a whole-project `quarto render` (these legitimately affect every page or the baked-in menu). (🟡 todo)
6. Regenerate `navigation.json` (`scripts/generate-navigation.ps1`) and copy it to `docs/` only when `_quarto.yml` changed. (🟡 todo)
7. Replace the orphan-branch force-push with an **incremental deploy**: check out `gh-pages`, copy only changed `docs/` outputs, update `.last-deployed-sha`, commit, and push — preserving the current `.gitignore.gh-pages` handling. (🟡 todo)
8. Add a **manual full-rebuild switch** (`workflow_dispatch` input) to force a clean whole-site render on demand. (🟡 todo)

## 🏁 Exit criteria

- A one-line edit to a single article triggers a build that renders exactly one file and commits only that output. (🟡 todo)
- Wall-clock time for a single-article edit is seconds, not minutes. (🟡 todo)
- A `_quarto.yml` sidebar change correctly triggers a full rebuild (no stale baked-in menus). (🟡 todo)
- The manual full-rebuild switch reproduces a byte-equivalent site to the current full render. (🟡 todo)

## 🅿️ Park lot

Out-of-scope items surfaced during authoring. MUST NOT be executed in this plan.

- Disable the native `website.sidebar` so pages stop embedding the menu. → `02-menu-decoupling-plan.md` (after Open decisions resolved)
- Client-side `navigation.json` menu loader with current-page highlighting. → `02-menu-decoupling-plan.md`
- Site-wide search strategy (periodic full index vs. Pagefind). → `02-menu-decoupling-plan.md`
- Parallelise per-file renders across changed files. → defer (optimise only if per-file render batches become the bottleneck)

## ❓ Open decisions

In-scope decisions awaiting evidence or a user answer. None block Phase 1; all gate the parked Phase 2 work.

- **D1-sidebar-render-approach** — keep `website` project with an emptied sidebar (a) vs. a minimal non-website render profile (b). *Resolves by:* prototype comparison. *Gates:* Park-lot menu-decoupling items.
- **D2-search-strategy** — periodic full search index vs. incremental client index (Pagefind). *Resolves by:* user preference + Pagefind spike. *Gates:* Park-lot search item.
- **D3-nav-js-dependency** — confirm a JS-dependent navigation menu is acceptable for the Hub. *Resolves by:* user answer. *Gates:* whole Phase 2.

## 🔎 Discovery

Facts undecidable until execution; each carries a defined negative branch.

- **DISC1-render-path-parity** — does `quarto render "<file>"` write to the identical `docs/` path as a project render (including whitelisted `readme.md`/`summary.md`)? *If not →* derive the output path from the project render mapping and place the file explicitly, or fall back to a scoped project render with a temporary single-entry render list.
- **DISC2-cache-reuse-safety** — does retaining `.quarto/` between runs ever produce stale output for unchanged pages? *If yes →* clear only `.quarto/` (keep `docs/`) before the incremental render, or key cache reuse to a Quarto version stamp.
- **DISC3-gh-pages-diff-copy** — can the deploy reliably copy only changed outputs given Quarto also emits per-page `*_files/` asset folders? *If partial →* include each changed page's sibling `*_files/` directory in the copy set.

<!--
plan_metadata:
  version: "0.1.0"
  created: "2026-07-12"
  status: "actionable"
  source_analysis: "00-analysis.md"
  scope: "phase-1-change-detection-build"
-->
