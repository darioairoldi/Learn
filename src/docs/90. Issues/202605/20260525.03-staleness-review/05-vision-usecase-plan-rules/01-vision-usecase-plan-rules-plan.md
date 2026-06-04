---
title: "Plan: Generate vision/use-case/plan rule artifacts and update vision v15 to support actionability gating, principle-impact tagging, and use-case coverage validation"
author: "Dario Airoldi"
date: "2026-05-31"
categories: [plan, prompt-engineering, vision, governance, use-cases, staleness-review]
description: "Implementation plan for [01-overview.md](01-overview.md) (sub-issue `05-vision-usecase-plan-rules`). Delivers four instruction artifacts and one vision amendment that together close the scope-expansion / vision-drift gap surfaced by the v14 → v15 amendment. Adds: (1) `vision-frontmatter.instructions.md` — declared `principles:` block with P0/P1/P2 priority; (2) `vision-amendment.instructions.md` — per-item scope tag + principle impact + coverage promise; (3) extension to `plan-execution.instructions.md` — `draft → actionable → in-progress → done` lifecycle, 5-check actionability gate, park-lot rule; (4) `use-case-documents.instructions.md` — use-case clarity, priority-prefix discipline (`pN-NN-<slug>.md`), explicit coverage map to vision goal items, validation discipline (use cases as living tests of the vision); (5) vision v15 in-version amendment — bootstrap the `principles:` block with the candidate P0/P1 set from the overview Q4, add a § Validation infrastructure subsection referencing the four instruction files. Plan is designed to honor the very gate it introduces — every goal item carries a per-item scope tag, principle impact, and named downstream landing. NO new use-case content is authored by this plan; existing use cases under `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/` are left untouched and only audited for compliance with R4 in a follow-up plan."
draft: false
status: "done"
last_updated: "2026-05-31"
severity: "Medium"
component: "[20260531.01-vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md) + `.github/instructions/` (3 new files, 1 extension)"
framework: "GitHub Copilot Customization v1.107 (PE-meta vision v15)"
---

# Plan — Vision/use-case/plan rule artifacts and vision v15 amendment

**Parent issue:** [01-overview.md](01-overview.md) — sub-issue `05-vision-usecase-plan-rules`
**Plan ID:** `01-vision-usecase-plan-rules-plan`
**Date:** 2026-05-31
**Status:** Done — all five artifacts landed and exit criteria satisfied. The plan was used as the first concrete instance of the new lifecycle: draft → actionability-gate-passed → in-progress (artifact execution) → done.

---

## 🎯 Goal

> **Original trigger (verbatim):** "Create the suitable artifacts and update the vision to support the new validations identified in [01-overview.md](01-overview.md); ensure rules also exist for use-case documents (use cases must be easy to understand, communicate priority activities, and provide coverage for the vision goal and scope)."

Deliver four instruction artifacts and one in-version vision amendment that together close gaps **G1–G5** identified in [01-overview.md § Root causes](01-overview.md#-root-causes). Every goal item below carries a per-item scope tag, principle-impact note, and named downstream landing — so this plan is itself the first concrete exercise of the [R3 actionability gate](#-actionability-gate-self-check) it introduces.

The PE vision's [candidate `principles:` block (Q4 of overview)](01-overview.md#%EF%B8%8F-open-questions-and-decisions) drives the per-item principle impact notes below. Where the vision's principles are not yet declared (the bootstrap lands in goal item 5), the impact is recorded against the **candidate** principle ids; the vision amendment then formalizes them.

| # | Goal item | Scope tag | Principle impact (candidate ids) | Downstream landing |
|---|---|---|---|---|
| 1 | Author `.github/instructions/vision-frontmatter.instructions.md` defining the `principles:` block schema (P0/P1/P2), with `applyTo` matching vision documents under `06.00-idea/**/*vision*.md` | `[in-scope: original]` | Preserves: `portable`, `command-family-agnostic`, `invocation-shape-agnostic`. Touches: none — additive frontmatter schema | New file (artifact 1) |
| 2 | Author `.github/instructions/vision-amendment.instructions.md` requiring trigger restatement, per-item scope tag, per-item principle impact, per-item coverage promise on every vision-amendment plan; `applyTo: '*vision*plan*.md'` | `[in-scope: original]` | Preserves: `single-source-of-truth` (rules live in instruction, plans cite). Touches: `default-full-invocation` (P1) — justification: the gate intentionally subtracts from default by quarantining scope expansion | New file (artifact 2) |
| 3 | Extend `.github/instructions/plan-execution.instructions.md` with the four-state lifecycle (`draft → actionable → in-progress → done`), the 5-check actionability gate, the park-lot rule, and the on-save + on-ask dual trigger from Q3 | `[in-scope: original]` | Preserves: `single-source-of-truth`. Touches: existing pre-execution validation block — non-breaking: today's three checks (goal alignment, actionability, information sufficiency) become checks #1–#2 of the new 5-check gate; no semantics removed | In-place edit (artifact 3) |
| 4 | Author `.github/instructions/use-case-documents.instructions.md` defining (a) `pN-NN-<slug>.md` filename discipline as priority-bearing, (b) required sections (problem, priority justification, success criteria, vision-item coverage map, anti-patterns), (c) clarity/non-ambiguity test, (d) coverage-closure check between use cases and vision goal items in both directions; `applyTo: '*usecase*.md'` AND `applyTo: '**/usecases/**/*.md'` | `[in-scope: original]` | Preserves: `portable` (rule is about file structure and content, not folder layout). Touches: existing use-case folder layout (`06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/`) — non-breaking: existing `pN-NN-*` filenames already comply with the priority-prefix rule | New file (artifact 4) |
| 5 | Amend [20260531.01-vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md) in-version: (a) add `principles:` block to frontmatter with the candidate P0/P1 set from [overview Q4](01-overview.md#%EF%B8%8F-open-questions-and-decisions), authored by the vision owner; (b) add § Validation infrastructure under § The vision referencing the four instruction files and their roles; (c) record the bootstrap in [20260531.01-vision.v15.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.changelog.md) as a non-version-bumping additive entry | `[in-scope: original]` | Preserves: every existing P0 principle (the bootstrap *declares* them, does not change them). Touches: vision frontmatter schema — additive only; no version bump because no behavior changes | Vision edit (artifact 5) |
| 6 | Bootstrap audit of existing use cases under `20260503.02-vision-pe-meta-usecases/**/*.md` for R4 compliance | `[scope-expansion: needs-own-plan]` | n/a — spawned as `02-usecase-audit-plan.md` | **Parked** — see [§ Park lot](#-park-lot) |
| 7 | Author a use-case for the `/pe-meta-update --mode apply --scope context` invocation that catches Type B staleness (gap surfaced by sub-issue 02) | `[scope-expansion: needs-own-plan]` | n/a — different sub-issue | **Parked** — see [§ Park lot](#-park-lot) |

Items 6 and 7 are surfaced here only to demonstrate the [park-lot rule](#-park-lot) in action. They MUST NOT mutate the active goal list.

---

## 📋 Table of contents

- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [⚙️ Actionability gate — self-check](#-actionability-gate--self-check)
- [📌 Artifact 1 — `vision-frontmatter.instructions.md`](#-artifact-1--vision-frontmatterinstructionsmd)
- [📌 Artifact 2 — `vision-amendment.instructions.md`](#-artifact-2--vision-amendmentinstructionsmd)
- [📌 Artifact 3 — `plan-execution.instructions.md` extension](#-artifact-3--plan-executioninstructionsmd-extension)
- [📌 Artifact 4 — `use-case-documents.instructions.md`](#-artifact-4--use-case-documentsinstructionsmd)
- [📌 Artifact 5 — vision v15 in-version amendment](#-artifact-5--vision-v15-in-version-amendment)
- [🅿️ Park lot](#%EF%B8%8F-park-lot)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

- **Artifact 1 exists** at `.github/instructions/vision-frontmatter.instructions.md` with `applyTo: '06.00-idea/**/*vision*.md'`, defining the `principles:` block schema (id / statement / priority ∈ {P0, P1, P2}) and the priority semantics table. (✅ done)
- **Artifact 2 exists** at `.github/instructions/vision-amendment.instructions.md` with `applyTo: '*vision*plan*.md'`, requiring trigger restatement + per-item scope tag + per-item principle impact + per-item coverage promise on every vision-amendment plan goal section. (✅ done)
- **Artifact 3 extension landed** in `.github/instructions/plan-execution.instructions.md`: adds the four-state lifecycle, the 5-check actionability gate, the park-lot rule; preserves the existing three-check pre-execution validation block by subsuming checks #1–#2 into the new gate (no semantics removed). Version bumped from `1.1.0` → `1.2.0`. (✅ done)
- **Artifact 4 exists** at `.github/instructions/use-case-documents.instructions.md` with `applyTo: '**/*usecases/**/*.md'` (consolidated to a single glob that matches the existing folder; covers the `*usecase*.md` filename intent), required sections list, priority-prefix rule (`pN-NN-<slug>.md`), and bidirectional coverage-map requirement via the `Vision anchor` field. (✅ done)
- **Artifact 5 landed**: [20260531.01-vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md) carries a `principles:` block in its frontmatter (4 P0 + 2 P1 entries naming pre-existing implicit principles); new § Validation infrastructure subsection added at the end of § The vision listing the four artifacts and pointing to their `applyTo` glob; [20260531.01-vision.v15.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.changelog.md) records the additive entry. No version bump (additive frontmatter + additive section). (✅ done)
- **Cross-references resolve**: every new instruction file references the others; the vision § Validation infrastructure points to each instruction file by path and `applyTo` glob. (✅ done)
- **YAML frontmatter valid** on all four new instruction files per [pe-instruction-files.instructions.md](../../../../../../.github/instructions/pe-instruction-files.instructions.md) — every file carries `description`, `applyTo`, `version`, `last_updated`, `domain`, `goal`, `rationales`, `context_dependencies`. (✅ done)
- **No regression** in existing plan-execution validation: the legacy three-check block (goal alignment, actionability, information sufficiency) is preserved as checks #1–#2 of the new 5-check gate — no semantics removed; check #5 (principle impact) is conditional on vision-amendment plans only. (✅ done)
- **`status:` of this plan** transitioned from `draft` → `actionable` after the [actionability gate self-check](#-actionability-gate--self-check) (recorded inline below). (✅ done)
- **Plan moved** to `status: done` after all artifacts landed and exit criteria satisfied. (✅ done)

---

## ⚙️ Actionability gate — self-check

This plan is the first instance subject to the new gate. The self-check below is performed once before flipping `status:` from `draft` to `actionable`.

| # | Check | Result on this plan |
|---|---|---|
| 1 | **Clarity** — § Goal opens with verbatim trigger restatement; every goal item is a complete, testable assertion | ✅ Pass — trigger restated; items 1–5 each name one artifact + one delivery condition; items 6–7 are parked, not active |
| 2 | **Non-ambiguity** — every goal item names exactly one outcome; no compound items | ✅ Pass — each row 1–5 produces one file (or one edit on one file) |
| 3 | **Scope discipline** — every goal item carries `[in-scope]` / `[scope-expansion]` / `[vision-only]`; zero `[scope-expansion]` in active list | ✅ Pass — items 1–5 are `[in-scope: original]`; items 6–7 are `[scope-expansion]` and parked |
| 4 | **Coverage promise** — every `[in-scope]` item names downstream artifact; named artifacts exist or have a spawned plan | ✅ Pass — items 1, 2, 4 = new files (now exist); item 3 = in-place edit (target existed); item 5 = vision edit (target existed) |
| 5 | **Principle impact** (vision-amendment plans only) — every goal item lists principles preserved/touched; P0 touches require explicit consent line; P1 touches require justification | ✅ Pass — this plan touches the *vision* (item 5) and *instruction* files. P0 candidates are *declared* by item 5, not amended (declaration ≠ amendment). Item 2's P1 touch on `default-full-invocation` is justified inline (the gate quarantines scope expansion). No P0 touches in this plan |

**Verdict:** ✅ All five checks pass. Plan transitioned `draft` → `actionable` → `in-progress` → `done`.

---

## 📌 Artifact 1 — `vision-frontmatter.instructions.md`

**Path:** `.github/instructions/vision-frontmatter.instructions.md`
**`applyTo`:** `'06.00-idea/**/*vision*.md'` (glob covers `20260531.01-vision.v15.md`, `old/20260529.01-vision.v14.md`, future vision versions)

### Required sections

- Frontmatter (per [pe-instruction-files.instructions.md](../../../../../../.github/instructions/pe-instruction-files.instructions.md)) — `description`, `applyTo`, `version: "1.0.0"`, `last_updated`, `goal`, `rationales:`, `context_dependencies:`
- § Purpose — one paragraph stating the rule's intent (force every vision to declare its principles up-front so amendment plans can audit principle impact mechanically)
- § The `principles:` block schema — YAML structure, field types, allowed values
- § Priority semantics — the three-tier table (P0 core principle / P1 strategic choice / P2 operational detail) with amendment-friction column
- § Discipline — P0 must be rare (3–7 items per vision); list of must / must-not rules
- § Bootstrap and migration — MUST/SHOULD policy per [Q1](01-overview.md#%EF%B8%8F-open-questions-and-decisions). Initial release ships **SHOULD**; promotion to MUST documented as a separate follow-up after a grace window
- § How amendment plans reference principles — pointer to artifact 2

### Key rules to encode

| # | Rule | Severity |
|---|---|---|
| VF-1 | Vision documents SHOULD declare a `principles:` block in frontmatter | SHOULD (initial release per Q1) |
| VF-2 | When present, each entry MUST have `id` (kebab-case, unique within the block), `statement` (one sentence), `priority` ∈ {P0, P1, P2} | MUST |
| VF-3 | P0 entries MUST be 3–7 per vision (broader interpretation invalidates the gate) | MUST |
| VF-4 | The `principles:` block is the ONLY authoritative source for vision principles — body text MUST NOT contradict it | MUST |
| VF-5 | Adding, removing, or repriotising a P0 entry constitutes a vision version bump | MUST |
| VF-6 | Adding, removing, or repriotising a P1 entry requires a changelog entry but NOT a version bump | MUST |
| VF-7 | P2 entries change freely; no special ceremony | MAY |

---

## 📌 Artifact 2 — `vision-amendment.instructions.md`

**Path:** `.github/instructions/vision-amendment.instructions.md`
**`applyTo`:** `'*vision*plan*.md'` (matches `01-vision-update-plan.md`, this file's siblings, and future vision-amendment plans)

### Required sections

- Frontmatter
- § Purpose — gate scope expansion at plan authoring time, not at execution time
- § Required goal-section structure — trigger restatement; per-item table with columns `# | item | scope tag | principle impact | downstream landing`
- § Scope tag taxonomy — the three values (`[in-scope: original]`, `[scope-expansion: needs-own-plan]`, `[vision-only: no-downstream]`) with definitions and decision criteria
- § Principle impact format — `preserves: <id>, <id>; touches: <id> (P0/P1 justification)`
- § Coverage promise format — `landing: <path-or-spawned-plan-id>`
- § Per-item P0 / P1 consent lines — required wording
- § Interaction with the actionability gate — pointer to artifact 3
- § Worked example — link to this plan (`01-vision-usecase-plan-rules-plan.md`) as the canonical reference

### Key rules to encode

| # | Rule | Severity |
|---|---|---|
| VA-1 | Vision-amendment plans MUST open § Goal with a verbatim one-sentence restatement of the original trigger | MUST |
| VA-2 | Every goal item MUST carry exactly one scope tag | MUST |
| VA-3 | Active goal list MUST contain zero `[scope-expansion]` items — they are reclassified, spawned to siblings, or parked | MUST |
| VA-4 | Every `[in-scope]` item MUST list at least one principle preserved | MUST |
| VA-5 | Every `[in-scope]` item that touches a P0 principle MUST carry an explicit consent line | MUST |
| VA-6 | Every `[in-scope]` item that touches a P1 principle MUST carry a justification line | MUST |
| VA-7 | Every `[in-scope]` item MUST name a downstream landing (existing artifact or spawned plan id) | MUST |
| VA-8 | `[vision-only]` items are exempt from VA-7 but MUST be flagged as such | MUST |

---

## 📌 Artifact 3 — `plan-execution.instructions.md` extension

**Path:** `.github/instructions/plan-execution.instructions.md` (in-place edit; bump `version: "1.1.0"` → `"1.2.0"`)

### Edits

- § Plan Creation Rules — add: "MUST declare `status:` in frontmatter, taking one of `draft | actionable | in-progress | done`"
- New § Plan Lifecycle (between § Plan Creation Rules and § Pre-Execution Validation):
  - The four-state lifecycle (`draft → actionable → in-progress → done`)
  - The `draft → actionable` transition fires the 5-check gate once
  - Failing any check refuses the transition and produces a check report
- § Pre-Execution Validation (rename to § Actionability Gate, 5 checks) — replace today's 3-item list with the 5-check gate from [01-overview.md § R3](01-overview.md#r3--extend-plan-lifecycle-with-a-draft--actionable-gate)
  - Today's check 1 (Goal alignment) → new check #1 (Clarity) — superset
  - Today's check 2 (Actionability) → new check #2 (Non-ambiguity) — superset
  - Today's check 3 (Information sufficiency) → folded into new check #4 (Coverage promise) — superset
  - New check #3 (Scope discipline) and new check #5 (Principle impact, vision-amendment plans only) are additions
- New § Park lot — defines `## 🅿️ Park lot` as the required quarantine section, the rule that edge cases surfaced during execution go there (not into the active goal list), and the exit-triage protocol (reclassify / spawn / defer)
- § Trigger — the actionability gate fires on TWO entry points per [Q3](01-overview.md#%EF%B8%8F-open-questions-and-decisions): on save when `status:` flips `draft → actionable`, and on explicit ask

### Key rules to encode

| # | Rule | Severity |
|---|---|---|
| PE-L1 | All plan files MUST declare `status:` ∈ {draft, actionable, in-progress, done} | MUST |
| PE-L2 | Flipping `status:` to `actionable` MUST trigger the 5-check gate | MUST |
| PE-L3 | A plan failing any check MUST remain in `status: draft` until the failing check is resolved | MUST |
| PE-L4 | Edge cases surfaced during execution MUST go to `## 🅿️ Park lot`; MUST NOT mutate the active goal list | MUST |
| PE-L5 | Park-lot items are triaged at plan exit: reclassify in-scope, spawn child plan, or defer | MUST |
| PE-L6 | Vision-amendment plans (matched by [artifact 2's](#-artifact-2--vision-amendmentinstructionsmd) `applyTo`) ALSO run check #5 (principle impact) | MUST |
| PE-L7 | Use-case-bearing plans (those that author or modify use cases under matched paths) ALSO run check #6 (use-case coverage map) — defined in [artifact 4](#-artifact-4--use-case-documentsinstructionsmd) | MUST |

---

## 📌 Artifact 4 — `use-case-documents.instructions.md`

**Path:** `.github/instructions/use-case-documents.instructions.md`
**`applyTo`:** `'*usecase*.md'` AND `'**/usecases/**/*.md'` (covers `20260503.02-vision-pe-meta-usecases/**/p*-*-*.md`, `usecase-index.json`-listed files, and future use-case folders)

### Why this artifact exists

Use cases are not implementation specs and not architecture documents. They are the **executable behavior the vision promises to support**. Readers — human or agent — validate the vision by reading use cases: if the use cases are unclear, prioritization is invisible, or coverage of the vision goal is absent, the vision becomes unverifiable from the user's side. The rule set below operationalizes the four user-stated requirements:

1. **Easy to understand** → clarity + non-ambiguity + required-section discipline
2. **Communicate priority activities** → the `pN-NN-<slug>.md` filename rule + a `priority:` field in frontmatter + priority justification section
3. **Provide coverage for the vision goal and scope** → bidirectional coverage map (every vision goal item links forward to ≥ 1 use case; every use case links back to ≥ 1 vision goal item)
4. **Validate the vision** → success-criteria and anti-pattern sections that double as acceptance tests

### Required sections

- Frontmatter — `description`, `applyTo`, `version: "1.0.0"`, `last_updated`, `goal`, `rationales:`, `context_dependencies:`
- § Purpose — what use-case documents are *for* in the PE infrastructure
- § Filename and folder convention — `pN-NN-<slug>.md` under a `<NNNNNNNN>.NN-<vision-id>-usecases/<NN>-<category>/` structure
- § Required frontmatter for use cases — `title`, `priority: pN`, `vision: <vision-id>`, `vision_items: [<goal item id>, …]`, `category: <freshness | quality-gates | …>`, `last_updated`
- § Required content sections — Problem, Priority justification, Actors, Trigger, Preconditions, Steps, Success criteria, Anti-patterns, Coverage map (links back to vision goal items)
- § Clarity rules — single sentence subject + verb + object per step; no compound steps; no "etc."; no aspirational verbs
- § Priority semantics — what P0 / P1 / P2 mean for use cases (P0 = vision is broken if this use case fails; P1 = vision is degraded; P2 = nice-to-have)
- § Coverage rules — bidirectional; every vision goal item must appear in ≥ 1 use case's `vision_items:`; every use case must reference ≥ 1 vision goal item
- § Use-case-bearing plan integration — pointer to PE-L7 in artifact 3
- § Worked example — link to `20260503.02-vision-pe-meta-usecases/01-freshness/p0-01-context-quality-lifecycle-usecase.md` (existing) for shape

### Key rules to encode

| # | Rule | Severity |
|---|---|---|
| UC-N1 | Use-case files MUST follow `pN-NN-<slug>.md` filename pattern where `N ∈ {0, 1, 2}` is priority | MUST |
| UC-N2 | The filename's `pN` prefix MUST match the `priority:` field in frontmatter | MUST |
| UC-F1 | Use-case frontmatter MUST include `priority`, `vision`, `vision_items` (non-empty list) | MUST |
| UC-S1 | Use-case body MUST contain Problem, Priority justification, Actors, Trigger, Preconditions, Steps, Success criteria, Anti-patterns, Coverage map sections | MUST |
| UC-S2 | Steps MUST be single-action assertions; no "and/etc."; numbered | MUST |
| UC-C1 | The vision goal section MUST cover every use case (forward coverage); the use-case index MUST cover every vision goal item (reverse coverage) | MUST |
| UC-C2 | A vision goal item without ≥ 1 P0 or P1 use case is a HIGH-severity coverage gap | MUST |
| UC-V1 | Use-case-bearing plans (those that author or modify ≥ 1 use case file) MUST run check #6 of the actionability gate (bidirectional coverage map after the change) | MUST |
| UC-P1 | Priority promotion (`p2` → `p1` → `p0`) requires a changelog entry and justification | MUST |
| UC-P2 | Priority demotion requires explicit consent recorded in the changelog | MUST |

### Notable: filename suffix as the priority surface

The existing use-case folder already uses `p0-01-context-quality-lifecycle.md`, `p0-02-release-impact-assessment.md`, `p1-01-staleness-source-verification.md`, `p1-02-context-optimization.md`. The R4 rule **formalizes** this convention — it is not invented here. R4 adds: (a) the priority is duplicated in frontmatter for tooling (UC-N2), (b) the priority maps to the same P0/P1/P2 semantics as vision principles in artifact 1 (consistent priority vocabulary across the PE infrastructure), (c) violations are auditable.

---

## 📌 Artifact 5 — Vision v15 in-version amendment

**Path:** [20260531.01-vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md) + [20260531.01-vision.v15.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.changelog.md)

### Edits

- **Add `principles:` block to frontmatter** with the candidate set from [01-overview.md § Q4](01-overview.md#%EF%B8%8F-open-questions-and-decisions). Final ids and prioritization are authored by Dario; the candidate set is a starting point only:

  ```yaml
  principles:
    - id: portable
      statement: "Rules MUST NOT depend on folder layout; content properties live in metadata"
      priority: P0
    - id: command-family-agnostic
      statement: "Rules apply uniformly to every /pe-meta-* command"
      priority: P0
    - id: invocation-shape-agnostic
      statement: "Rules apply uniformly across token, path-set, positional, default-all scope shapes"
      priority: P0
    - id: single-source-of-truth
      statement: "Normative rules live in the vision; downstream artifacts cite, never duplicate"
      priority: P0
    - id: metadata-first-content-properties
      statement: "Content properties (like domain) are declared in metadata, not derived from paths"
      priority: P1
    - id: default-full-invocation
      statement: "Parameter-less invocations default to a full review (R-P8)"
      priority: P1
  ```

- **Add § Validation infrastructure** as the last subsection under § The vision. Body lists:
  - [vision-frontmatter.instructions.md](../../../../../../.github/instructions/vision-frontmatter.instructions.md) — schema for this very block
  - [vision-amendment.instructions.md](../../../../../../.github/instructions/vision-amendment.instructions.md) — per-item principle-impact tagging on amendment plans
  - [plan-execution.instructions.md](../../../../../../.github/instructions/plan-execution.instructions.md) — actionability gate, park-lot, lifecycle
  - [use-case-documents.instructions.md](../../../../../../.github/instructions/use-case-documents.instructions.md) — use-case clarity, priority, coverage
- **Changelog entry** under [20260531.01-vision.v15.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.changelog.md) — additive: declares the `principles:` block + the new § Validation infrastructure subsection. No version bump (additive frontmatter + additive section, no behavioral change to the vision itself; the *gating* behavior lands in the four instruction files).

### Why no version bump

- The `principles:` block **declares** what was already implicit. It does not introduce a new P0; it names the existing ones. Naming is not amending.
- The § Validation infrastructure subsection **references** new instruction files; it does not change vision rules.
- Per the [VF-5 rule in artifact 1](#-artifact-1--vision-frontmatterinstructionsmd), adding a P0 entry requires a version bump *when the entry represents a new commitment*. Here the entries are *names for existing commitments* — confirmed against the v15 body. If the bootstrap audit reveals one of the candidate P0 entries does not actually exist in the v15 body, that item is removed from the bootstrap (and possibly proposed as a fresh P0 in a later v16 amendment).

---

## 🅿️ Park lot

Edge cases surfaced during this plan's authoring or execution land here. They MUST NOT mutate the [§ Goal](#-goal) active list.

| # | Item | Disposition | Spawn target |
|---|---|---|---|
| P1 | Audit existing use cases under `20260503.02-vision-pe-meta-usecases/**` for R4 compliance (frontmatter `priority:`, `vision_items:`, required sections, bidirectional coverage) | `[scope-expansion: needs-own-plan]` — distinct activity, distinct risk surface | `02-usecase-audit-plan.md` (this folder) |
| P2 | Author a use case for `/pe-meta-update --mode apply --scope context` that catches Type B staleness (sub-issue 02 gap) | `[scope-expansion: needs-own-plan]` — belongs under sub-issue 02, not this one | Cross-link to [02-pe-meta-update-not-processing-full-context-review/overview.md](../02-pe-meta-update-not-processing-full-context-review/overview.md) |
| P3 | Decide MUST vs SHOULD promotion timeline for `principles:` block (the grace-window question from [Q1](01-overview.md#%EF%B8%8F-open-questions-and-decisions)) | `[vision-only: no-downstream]` — vision-governance decision, not an artifact | Documented in v15 changelog under "Open governance decisions" |
| P4 | Extend gate to non-vision plans: which checks apply to use-case-bearing plans, implementation plans, infra plans | `[scope-expansion: needs-own-plan]` — [Q2](01-overview.md#%EF%B8%8F-open-questions-and-decisions) deferred to follow-up | `03-gate-scope-extension-plan.md` (future) |

---

## ⚠️ Boundaries and risks

### Boundaries (out of scope for this plan)

- This plan MUST NOT author new use-case content (R4 is a *rule set*, not new use cases). Existing use cases under `20260503.02-vision-pe-meta-usecases/` are left untouched and only audited in the spawned `02-usecase-audit-plan.md`.
- This plan MUST NOT amend vision principles. Item 5 *declares* the existing implicit principles; it does not introduce, remove, or repriotise any of them.
- This plan MUST NOT modify [plan-marking.instructions.md](../../../../../../.github/instructions/plan-marking.instructions.md). Suffix notation conventions remain unchanged.
- This plan MUST NOT promote the SHOULD on `principles:` to MUST. Promotion is parked as P3.

### Risks

| # | Risk | Mitigation |
|---|---|---|
| R1 | Author judgment is needed to seed P0 in vision v15; wrong seeding makes the gate either too strict (everything is P0) or too loose (nothing is P0) | The vision owner (Dario) authors the bootstrap; the candidate set in artifact 5 is explicitly provisional |
| R2 | The 5-check gate could be perceived as friction on routine plans | Apply checks 1–4 to all plans, gate check 5 to vision-amendment plans only ([Q2 recommendation](01-overview.md#%EF%B8%8F-open-questions-and-decisions)); document recourse to `[vision-only]` for clarification-only items |
| R3 | Existing in-flight plans (drafts of sub-issues 03 and 04) predate the new lifecycle | They are grandfathered — the new lifecycle applies to plans created after artifact 3 lands. Migration policy documented in artifact 3's changelog |
| R4 | Use cases under `20260503.02-vision-pe-meta-usecases/` may not pass R4 immediately | The bootstrap audit is parked as P1 with severity proportional to gap depth; no automatic invalidation of existing use cases |
| R5 | The four `applyTo` globs may overlap with existing instruction files and produce loading order surprises | Each new file's `applyTo` is narrower than the broadest existing globs; load order is validated by reading the resulting context list once on the v15 vision file + one sample use-case file + this plan file |

---

## 📚 References

**This sub-issue:**
- 📒 [01-overview.md](01-overview.md) — the analysis this plan implements

**Existing PE artifacts to modify or reference:**
- 📘 [plan-execution.instructions.md](../../../../../../.github/instructions/plan-execution.instructions.md) — target of artifact 3 extension
- 📘 [plan-marking.instructions.md](../../../../../../.github/instructions/plan-marking.instructions.md) — referenced; unchanged
- 📘 [pe-instruction-files.instructions.md](../../../../../../.github/instructions/pe-instruction-files.instructions.md) — schema authority for artifacts 1, 2, 4
- 📗 [20260531.01-vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md) — target of artifact 5
- 📗 [20260531.01-vision.v15.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.changelog.md) — changelog entry from artifact 5

**Existing use cases referenced for shape (not modified):**
- 📒 `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/p0-01-context-quality-lifecycle-usecase.md`
- 📒 `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/p0-02-release-impact-assessment-usecase.md`
- 📒 `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/p1-01-staleness-source-verification-usecase.md`
- 📒 `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/p1-02-context-optimization-usecase.md`

**Related plans and conventions:**
- 📒 [01-vision-update-plan.md](../03-pe-meta-update-applied-to-all-pe-contexts/01-vision-update-plan.md) — the v14 → v15 plan that motivated the gate (counter-example: would have stayed single-item under R2)
- 📘 [04.05-pe-meta-invocation-gates.md](../../../../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) — adjacent gate (invocation-time, not plan-authoring-time)
