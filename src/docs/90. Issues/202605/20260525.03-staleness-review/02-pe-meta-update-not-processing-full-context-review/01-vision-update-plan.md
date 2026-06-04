---
title: "Plan: Vision v13 → v14 — formalize default-full review with a minimal, consistent parameter surface"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, vision, pe-meta]
description: "Plan for amending [20260523.01-vision.v13.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) so that (a) parameter-less invocations are explicitly contracted as full-sweep maximal reviews, (b) the canonical option surface is reduced to seven minimal-and-consistent parameters (`--mode`, `--scope`, `--source`, `--dim`, `--start` / `--end`, `--deps`, `--skip`), (c) `--scope` is a value-shape parser accepting an artifact-type token OR a set of target folders / files (absorbing `--area` / `--artifact`), (d) a conversational pre-parser resolves natural-language hints to canonical options before any phase runs, (e) the research output contract distinguishes a full snapshot from an incremental delta keyed off `--start` / `--end`, (f) the vision explicitly shows how per-artifact-type PE prompts (`pe-meta-{type}-{create-update|design|review}`) are invoked by the orchestrator's slicers and dimensions, and (g) the vision explicitly lists the 8 pipeline phases with their `--skip` mapping."
draft: false
status: "done"
last_updated: "2026-05-29"
severity: "High"
component: "[20260523.01-vision.v13.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md)"
framework: "GitHub Copilot Customization v1.107 (vision v13)"
---

# Plan — Vision v13 → v14 — formalize default-full review with a minimal, consistent parameter surface

**Parent issue:** [overview.md](overview.md) (this sub-issue's analysis)
**Plan ID:** `01-vision-update-plan`
**Date:** 2026-05-29
**Status:** Done (vision v14 applied 2026-05-29)

---

## 🎯 Goal

Update [vision.v13](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) so the document **specifies**:

1. **Default-full invocation contract.** Parameter-less `/pe-meta-update` MUST mean a full review — every in-scope artifact, the full monitored-sources catalog, deep tier. Strategies are *subtractive*; the system never silently narrows.
2. **Minimal canonical parameter surface (seven).** `--mode`, `--scope`, `--source`, `--dim`, `--start` / `--end`, `--deps`, `--skip`. No `--breadth`, `--area`, `--artifact`, `--consumer`, `--subject`, `--concern`, `--incremental`, `--catch-up`, `--adherence`, `--mode-review` as separate flags — each is either absorbed by an existing parameter or derived from invocation context.
3. **Value-shape `--scope` parser.** `--scope` accepts an artifact-type token (`context`, `instructions`, …) OR a set of target folders / files that are the target of the review. One parameter, two shapes, one disambiguation rule.
4. **Conversational pre-parser (Phase 0a).** Free-form input ("re-check anything affected by the April VS Code release") resolves to canonical options BEFORE strict parsing. Phases 1-8 only ever see canonical options.
5. **Breadth is a resolved attribute, not a flag.** `full` / `incremental` / `bounded-delta` is derived from `--start` / `--end` plus caller-type (interactive vs trigger-fired) and logged on the first line of the run report.
6. **Research output contract.** Phase 1 produces either a *current-state snapshot* (full breadth) or a *change digest* (incremental / bounded-delta breadth). Both shapes feed Tier-2 screening.
7. **Per-artifact prompt invocation matrix.** The vision MUST show how the resolved `(--scope, --dim)` pair determines which per-artifact PE prompt (`pe-meta-{type}-{create-update|design|review}`) the orchestrator delegates to.
8. **Phase / `--skip` mapping.** The vision MUST list the 8 phases (0 – 8 with sub-phases 0a, 1.5) and the `--skip` values that retire each.

---

## 📋 Table of contents

- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [📌 Proposed amendments](#-proposed-amendments)
- [⚙️ Canonical parameter surface (seven)](#%EF%B8%8F-canonical-parameter-surface-seven)
- [🔗 Per-artifact prompt invocation via slicers and dimensions](#-per-artifact-prompt-invocation-via-slicers-and-dimensions)
- [🧭 Pipeline phases and `--skip` mapping](#-pipeline-phases-and---skip-mapping)
- [🏗️ Section-by-section changes](#%EF%B8%8F-section-by-section-changes)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

- Vision document version bumped to `14.0.0` with a `v14 changelog` entry. (✅ done)
- New § Default-full invocation contract added under § The goal. (✅ done)
- § The vision § Detect updated so manual invocations are no longer described as "the Scheduled trigger." (✅ done)
- § The vision § Assess § Research phase updated to distinguish full snapshot vs incremental digest, keyed off `--start` / `--end` plus caller-type. (✅ done)
- § Command families and option model § Option taxonomy reduced to the seven canonical parameters; deprecated flags listed in a migration table only. (✅ done)
- § Command families and option model § new "Conversational pre-parser" subsection covering Phase 0a. (✅ done)
- § Command families and option model § new "Per-artifact prompt invocation matrix" subsection covering the (`--scope`-resolved-artifact-type, `--dim`) → prompt mapping for all eight artifact types. (✅ done)
- § Command families and option model § new "Pipeline phases and `--skip` mapping" subsection listing every phase (0, 0a, 1, 1.5, 2 – 8) with the `--skip` value (if any) that retires it. (✅ done)
- `scope.covers:` frontmatter list extended with the new concepts. (✅ done)
- `rationales:` frontmatter list extended with `R-P8-default-full-investigation` and `R-P9-minimal-consistent-option-surface`. (✅ done)
- All vision-internal anchor links remain resolvable after section adds. (✅ done)

---

## 📌 Proposed amendments

### Section: Default-full invocation contract (Action — new) (✅ done)

**Where:** Insert at end of § The goal, before § The rationale.

**Why:** Today the vision does not state what a parameter-less `/pe-meta-update` is *contracted* to do. The 2026-05-27 run exploited that gap by inverting the default to minimal. Stating the contract closes the loophole.

**Proposed text (essence):**

- A manual command-line invocation with no parameters is a **deliberate ask for a full review**: every in-scope artifact, every monitored source, deep per-artifact tier, organizational-pass-first.
- A trigger-fired invocation (scheduled, git-hook, file-watcher) is an **incremental review**: deltas since `last_review_timestamp` per source, screened via change digest.
- User-supplied parameters narrow the full default. They do not widen a minimal default.

### Section: § The vision § Detect — wording fix (Action — replace) (✅ done)

**Where:** `## The vision` → `### Detect` table and surrounding prose.

**Current claim to replace:** "Manual `/pe-meta-update` acts as the Scheduled trigger."

**Replacement claim:**

- Manual invocations are **out of band** of the five triggers — they explicitly request a full sweep rather than reacting to a delta.
- Triggers feed *incremental* mode; manual invocations default to *full* mode unless the user supplies `--start` (which moves them to bounded-delta).

### Section: § The vision § Assess § Research phase — full vs incremental contract (Action — extend) (✅ done)

**Where:** `## The vision` → `### Assess` → `#### Research phase`.

**Add a contract table** that distinguishes the two research output shapes and the resolution rule:

| Resolved breadth | Trigger conditions | Output |
|---|---|---|
| `full` | Interactive invocation; no `--start` / `--end` | Complete current-state corpus across the entire monitored-sources catalog; reference set for organizational pass and per-artifact deep tier |
| `incremental` | Trigger-fired invocation (scheduled / hook); no `--start` / `--end` | ~500-token structured delta since `last_review_timestamp` per source (the existing seven-category digest) |
| `bounded-delta` | Any caller with `--start` and/or `--end` provided | Delta between the explicit window endpoints; same digest schema as incremental |

**Rationale to add:** Tier-2 relevance screening works against any of the three outputs — it screens the artifact set against the digest *or* against the snapshot's diff with the previous snapshot. Breadth is a resolved attribute logged on the first line; it is not a separate parameter.

### Section: Conversational pre-parser (Phase 0a) (Action — new) (✅ done)

**Where:** New subsection under `## Command families and option model`, before `### Option taxonomy`.

**Why:** Users describe scope in natural language ("re-check anything touched by VS Code 1.107 in the last month"). The vision must specify that this hint is resolved to canonical options **before** any phase runs, so downstream phases only see one option shape.

**Proposed text (essence):**

- Phase 0a runs whenever the invocation contains free-form text alongside or instead of flags.
- It extracts intent into the seven canonical parameters and echoes the resolved invocation string back to the user.
- The strict parser then validates the canonical form. Phases 1 – 8 only ever consume canonical options.
- Explicit `--` flags always override hints derived from free-form text. Conflicts are logged and the explicit flag wins.

### Section: § Command families and option model § Option taxonomy — collapse to seven (Action — replace) (✅ done)

**Where:** `## Command families and option model` → `### Option taxonomy`.

**Replace** the v13 five-option table with the seven canonical parameters defined in [⚙️ Canonical parameter surface](#%EF%B8%8F-canonical-parameter-surface-seven). The new table replaces (does not extend) the v13 table.

**Add** a Deprecated-flags migration table immediately under the canonical table:

| v13 flag | v14 mapping | Notes |
|---|---|---|
| `--breadth full\|incremental\|catch-up` | Derived from `--start` / `--end` + caller-type | Logged as resolved attribute, not parsed as input |
| `--area <path>` | `--scope <path>/` (folder shape) | Value-shape parser disambiguates path-ending-in-`/` as folder |
| `--artifact <path>` | `--scope <path>.md` (file shape) | Value-shape parser disambiguates path-ending-in-`.md` as file |
| `--consumer @<agent>` / `/<prompt>` | `--scope <path-to-agent-or-prompt-file>` + `--deps full` | Consumer chain expressed as the consumer's file plus dependency walk; no separate consumer-reference syntax |
| `--subject "<keyword>"` | Conversational pre-parser → `--scope <comma-separated file/folder list>` | Keyword filter is enumeration, not a new axis |
| `--concern <issue-id>` | Conversational pre-parser → `--scope <comma-separated file/folder list>` | Issue ID is a stored subject string |
| `--incremental` | Omit `--start`; let caller-type resolve | Trigger-fired callers resolve to `incremental` by default |
| `--catch-up` | `--start <90-day-old-date>` | Bounded-delta with long lookback |
| `--adherence` | `--dim adherence` | Already a dimension group (D5, D6, D16, D18) |
| `--mode-review individual\|dep-aware\|guidance-first` | Auto-derived from `--scope` artifact-type | Context/instructions/templates/snippets → guidance-first; agents/prompts/skills → dep-aware; single file → individual |

### Section: § Command families and option model § Per-artifact prompt invocation matrix (Action — new) (✅ done)

**Where:** New subsection under `## Command families and option model`, after the new Option taxonomy.

**Why:** Today the vision describes command families abstractly. It does not show which per-artifact-type PE prompt (e.g., `pe-meta-context-review`, `pe-meta-agent-create-update`) the orchestrator delegates to for a given `(--scope, --dim)` pair. The user requested this be made evident.

**Content:** Insert the full matrix from [🔗 Per-artifact prompt invocation via slicers and dimensions](#-per-artifact-prompt-invocation-via-slicers-and-dimensions) below.

### Section: § Command families and option model § Pipeline phases and `--skip` mapping (Action — new) (✅ done)

**Where:** New subsection under `## Command families and option model`, after Per-artifact prompt invocation matrix.

**Why:** Today the vision describes phases abstractly under § The vision. The user requested an explicit table that names every phase the orchestrator supports and the `--skip` value (if any) that retires each, so a reader can see at a glance what `--skip <stage>` actually omits.

**Content:** Insert the full table from [🧭 Pipeline phases and `--skip` mapping](#-pipeline-phases-and---skip-mapping) below.

### Section: New rationale R-P8-default-full-investigation (Action — add) (✅ done)

**Where:** § The rationale.

**Statement:** "Manual invocations default to full investigation because the cost of a missed Type B finding exceeds the cost of an over-investigation. Parameters are subtractive: users opt into narrower scopes; the system never opts in on their behalf."

### Section: New rationale R-P9-minimal-consistent-option-surface (Action — add) (✅ done)

**Where:** § The rationale.

**Statement:** "The canonical option surface is minimized to seven parameters so semantics remain consistent across phases and command families. Every additional flag risks overlap, inconsistency, or silent re-interpretation downstream. Conversational input handles the long tail; resolution is a single Phase 0a step."

### Section: Frontmatter updates (Action — extend) (✅ done)

- `scope.covers:` add: "Default-full invocation contract", "Minimal canonical parameter surface (seven)", "Value-shape `--scope` parser", "Conversational pre-parser (Phase 0a)", "Per-artifact prompt invocation matrix", "Pipeline phases and `--skip` mapping".
- `rationales:` add R-P8 and R-P9 lines.
- `boundaries:` add: "Parameter additions beyond the seven canonical parameters MUST be justified against R-P9 and MUST NOT replicate semantics already covered by an existing parameter."
- Top-of-file version: `13.1.0` → `14.0.0`.
- `last_updated:` → `2026-05-29`.

---

## ⚙️ Canonical parameter surface (seven)

This table is the **proposed replacement** for the v13 Option taxonomy. The vision update inserts it verbatim under § Command families and option model § Option taxonomy.

| Parameter | Purpose | Values / shape | Default | Status |
|---|---|---|---|---|
| `--mode` | Mutation posture | `plan`, `apply` | `apply` | (✅ done) |
| `--scope` | Investigation target — value shape disambiguates | Artifact-type token (`context`, `instructions`, `agents`, `prompts`, `skills`, `hooks`, `snippets`, `templates`, `all`) OR one or more target folders / files (paths, comma-separated; folders end in `/`, files end in `.md`) | `all` | (✅ done) |
| `--source` | External focus — release / feed / catalog driving the review | URL or `<feed-id>` | none (all monitored sources for `full`; per-source `last_review_timestamp` for `incremental`) | (✅ done) |
| `--dim` | What to evaluate | Group token (`full`, `freshness`, `quality`, `adherence`, `reliability`, `optimize`, `model`, `structural`, `strategic`, `context-full`, `context-health`) OR specific `D1` – `D35` | `full` | (✅ done) |
| `--start` / `--end` | Temporal window endpoints | ISO-8601 date (either or both) | Absent → unbounded for interactive (full), `last_review_timestamp` for triggered (incremental) | (✅ done) |
| `--deps` | Dependency walk depth from each in-scope artifact | `direct`, `full`, integer hop count | Auto-derived from `--scope` artifact-type | (✅ done) |
| `--skip` | Phase skipping | One or more of `research`, `external`, `structure`, `consistency`, `content` | none | (✅ done) |

**Resolution rules (six, deterministic):**

1. **Slice default.** If `--scope` is absent → `--scope all`. If `--source` is absent → all monitored sources (full breadth) or per-source `last_review_timestamp` deltas (incremental breadth). (✅ done)
2. **Breadth resolution.** Breadth is derived, not parsed: `full` for interactive with no `--start` / `--end`; `incremental` for trigger-fired with no `--start` / `--end`; `bounded-delta` whenever `--start` or `--end` is present. Logged as the first line of the run report. (✅ done)
3. **Composition.** Parameters compose with AND across categories. Multiple values within `--scope` or `--dim` compose with OR. (✅ done)
4. **Depth auto-derivation.** Per-artifact investigation mode (individual / dependency-aware / guidance-first) is derived from the artifact-type of each in-scope file per the matrix below. When `--scope` is a path (or path list), the artifact-type is inferred from each path's location; mixed-type scopes invoke the matching mode per file. `--deps` overrides walk depth; mode follows the artifact type, not the depth. (✅ done)
5. **Conflict resolution.** Free-form-derived options yield to explicit `--` flags; the explicit flag wins and a notice is logged. Within explicit flags, the more specific value wins (a file path beats `--scope all`). (✅ done)
6. **First-line log.** Phase 8 (and Phase 0 echo) MUST emit a machine-parseable `Resolved invocation: mode=… scope=… source=… dim=… start=… end=… deps=… skip=… breadth=…` line. This is the observable proxy for contract adherence. (✅ done)

---

## 🔗 Per-artifact prompt invocation via slicers and dimensions

This table is the **proposed new subsection** under § Command families and option model. It makes evident how the resolved `(--scope, --dim)` pair selects the per-artifact-type PE prompt the orchestrator delegates to during Phase 4 (Content audit) and Phase 6 (Apply).

### Artifact-type → review/build prompt mapping

| `--scope` artifact-type | Review prompt (read-only) | Create/update prompt (mutating) | Design prompt (greenfield) | Default per-artifact mode |
|---|---|---|---|---|
| `context` | `pe-meta-context-review` | `pe-meta-context-create-update` | `pe-meta-context-design` | guidance-first |
| `instructions` | `pe-meta-instruction-review` | `pe-meta-instruction-create-update` | `pe-meta-instruction-design` | guidance-first |
| `agents` | `pe-meta-agent-review` | `pe-meta-agent-create-update` | `pe-meta-agent-design` | dependency-aware |
| `prompts` | `pe-meta-prompt-review` | `pe-meta-prompt-create-update` | `pe-meta-prompt-design` | dependency-aware |
| `skills` | `pe-meta-skill-review` | `pe-meta-skill-create-update` | `pe-meta-skill-design` | dependency-aware |
| `hooks` | `pe-meta-hook-review` | `pe-meta-hook-create-update` | `pe-meta-hook-design` | individual |
| `snippets` | `pe-meta-snippet-review` | `pe-meta-snippet-create-update` | `pe-meta-snippet-design` | guidance-first |
| `templates` | `pe-meta-template-review` | `pe-meta-template-create-update` | `pe-meta-template-design` | guidance-first |
| `all` | Each of the above, one per in-scope artifact-type | — | — | Per row |

### Dimension → per-prompt focus

The `--dim` value parameterizes the selected prompt; it does not change which prompt is invoked. The mapping:

| `--dim` group | Per-prompt focus passed in |
|---|---|
| `full` | All dimensions applicable to the artifact-type per the v13 applicability matrix |
| `freshness` | D12, D13 — staleness and lifecycle |
| `quality` | D6 – D11, D27 — contradictions, completeness, prioritization, construction invariants |
| `adherence` | D5, D6, D16, D18 — consumer implements declared rules (auto-on for `--dim full` if `--scope` is a guidance type) |
| `reliability` | D28 – D35 — reproducibility, loop stability, rollback, boundary actionability |
| `optimize` | D3, D7, D9, D11, D20 – D26 — token budgets, deduplication, routing |
| `model` | D1, D2, D4, D14, D17 — model-specific guidance |
| `structural` | D8, D10, D15, D19 — file structure, frontmatter completeness |
| `strategic` | D27 — vision alignment |
| `context-full` | All dimensions when `--scope context` |
| `context-health` | Health subset for `--scope context` quick checks |

### Worked examples

| Invocation | Resolved (mode, scope, source, dim, start, end, deps, breadth) | Phase 4 prompt(s) invoked |
|---|---|---|
| `/pe-meta-update` | `apply, all, all, full, -, -, auto, full` | All eight `pe-meta-*-review` prompts in the per-artifact pass, then `pe-meta-*-create-update` for findings |
| `/pe-meta-update --scope context` | `apply, context, all, full, -, -, auto, full` | `pe-meta-context-review` (guidance-first mode) → `pe-meta-context-create-update` |
| `/pe-meta-update --scope context --dim freshness` | `apply, context, all, freshness, -, -, auto, full` | `pe-meta-context-review` parameterized to D12, D13 only |
| `/pe-meta-update --scope .github/agents/00.09-pe-meta/pe-meta-researcher.agent.md --deps full` | `apply, <agent-file>, all, full, -, -, full, full` | `pe-meta-agent-review` for the agent + recursive review of every artifact in its dependency chain (consumer-chain pattern) |
| `/pe-meta-update --scope .copilot/context/01.00-article-writing/` | `apply, <folder>, all, full, -, -, auto, full` | `pe-meta-context-review` for every file under the folder |
| `/pe-meta-update --scope .copilot/context/01.00-article-writing/,.copilot/context/02.00-tech/` | `apply, <folder-list>, all, full, -, -, auto, full` | `pe-meta-context-review` for every file across the listed folders |
| `/pe-meta-update --source <VS Code 1.107 URL>` | `apply, all, <url>, full, -, -, auto, full(source-driven)` | Source-impact pre-screen narrows artifact set; matching `pe-meta-*-review` per artifact |
| `/pe-meta-update --start 2026-04-01` | `apply, all, all, full, 2026-04-01, now, auto, bounded-delta` | Tier-2 screen against bounded digest → matching `pe-meta-*-review` for intersecting artifacts only |
| `/pe-meta-update --mode plan --dim adherence` | `plan, all, all, adherence, -, -, auto, full` | All eight `pe-meta-*-review` prompts in plan mode parameterized for adherence dimensions |

---

## 🧭 Pipeline phases and `--skip` mapping

This table is the **proposed new subsection** under § Command families and option model. It makes evident which phases exist and which `--skip <stage>` value retires each.

| Phase | Name | Purpose | Skippable via | Notes |
|---|---|---|---|---|
| 0 | Inventory + dependency map | Enumerate in-scope artifacts and load dependency map for selected `--scope` | — (always runs) | Mandatory; cheap |
| 0a | Conversational pre-parser | Resolve free-form input to canonical options; echo `Resolved invocation: …` | — (always runs when free-form text present) | New in v14 |
| 1 | Source research | Fetch monitored sources (or compute delta since `--start` or `last_review_timestamp`); produce snapshot or change digest | `--skip research` (whole phase); `--skip external` (URL/network fetches only — local sources still consulted) | Phase 1 is the prerequisite for Tier-2 relevance screening in Phases 2 – 4 |
| 1.5 | Organizational pass | For broad sweeps: role clarity, coverage gaps, layer correctness, redundancy across the artifact set | `--skip research` also skips 1.5 (no digest → no organizational input); explicit `--skip organizational` retires 1.5 alone | New in v14; gated on `breadth=full` AND `--scope` broader than single file |
| 2 | Structure audit | Per-artifact frontmatter completeness, file shape, anchor stability | `--skip structure` | |
| 3 | Consistency audit | Cross-artifact references, terminology, link integrity, no-contradictions | `--skip consistency` | |
| 4 | Content audit | Per-artifact quality dimensions (driven by `--dim`); delegates to `pe-meta-{type}-review` per the matrix above | `--skip content` | The phase that consumes the Phase 1 snapshot / digest for Tier-2 screening |
| 5 | Approval | Present changelist; gate apply | — | Auto-bypassed by `--mode apply` for low-risk findings per autonomy gradient |
| 6 | Apply | Execute mutations via `pe-meta-{type}-create-update`; append `outcome-log.jsonl` | — | Bypassed entirely when `--mode plan` |
| 7 | Regression test | Code-fence-aware re-scan of changed artifacts | — | Bypassed when `--mode plan` |
| 8 | Report + log | Update `05.04-meta-review-log.md`; emit final `Resolved invocation: …` first-line and outcome summary | — | Always runs |

**`--skip` semantics (six rules):**

1. `--skip` accepts one or more comma-separated values; order is irrelevant. (✅ done)
2. `--skip research` is INCOMPATIBLE with `breadth=full` because a full sweep requires the snapshot; the orchestrator MUST reject this combination with a deterministic error. (✅ done)
3. `--skip external` is the local-only variant of `--skip research`: monitored sources are still consulted from any cached snapshot, but no network calls are made. (✅ done)
4. `--skip structure` and `--skip consistency` are independent and freely composable. (✅ done)
5. `--skip content` is the most aggressive — it disables Phase 4 entirely; integrity-only invocations use it. (✅ done)
6. Phases 0, 0a, 5, 6, 7, 8 are NOT skippable; only their *contents* can be no-ops (e.g., Phase 6 no-ops when `--mode plan`). (✅ done)

---

## 🏗️ Section-by-section changes

| Vision section | Change kind | Why | Status |
|---|---|---|---|
| Frontmatter `scope.covers`, `rationales`, `boundaries`, `version`, `last_updated` | Extend | Record the new contract concepts and R-P8 / R-P9 | (✅ done) |
| Top § v14 changelog block | New | Record what changed since v13.1 | (✅ done) |
| § The goal — new sub-section "Default-full invocation contract" | New | Make the contract explicit | (✅ done) |
| § The rationale — add R-P8, R-P9 | Extend | Anchor the contract and the minimal-surface discipline | (✅ done) |
| § The vision § Detect — rewrite manual-trigger paragraph | Replace | Remove the "manual = scheduled" mis-mapping | (✅ done) |
| § The vision § Assess § Research phase — add full / incremental / bounded-delta contract table | Extend | Distinguish snapshot from digest; show that breadth is derived from `--start` / `--end` + caller-type | (✅ done) |
| § Command families and option model § Option taxonomy — replace with seven canonical parameters | Replace | Collapse to minimal-consistent surface | (✅ done) |
| § Command families and option model — new "Conversational pre-parser (Phase 0a)" | New | Free-form input resolves to canonical options before strict parsing | (✅ done) |
| § Command families and option model — new "Per-artifact prompt invocation matrix" | New | Make `(--scope, --dim)` → prompt mapping explicit | (✅ done) |
| § Command families and option model — new "Pipeline phases and `--skip` mapping" | New | List the 8 phases (with 0a, 1.5) and `--skip` values | (✅ done) |
| § Command families and option model — new "Deprecated flags migration" table | New | One-pass migration for v13 callers | (✅ done) |
| § Success criteria — add "Resolved invocation logged on every run as first line" | Extend | Observable proxy for contract adherence | (✅ done) |

---

## ⚠️ Boundaries and risks

- **Vision is human-only.** Per the existing `boundaries:` "MUST NOT be modified by autonomous processes." This plan documents proposed human edits; nothing here authorizes autonomous vision edits. (📌 next steps)
- **Backward compatibility.** Every v13 flag in the Deprecated-flags migration table MUST keep working for one full release window (v14.x). The parser resolves them silently to canonical form and emits a one-line deprecation notice. (� next steps)
- **Loss of one bit of explicitness.** Dropping `--breadth` means a CI script that wants a full sweep from a trigger context has no way to say so. Two mitigations: (a) accept a single boolean `--full` as the explicit override, or (b) require the caller to omit any `--start` and rely on caller-type detection. Decide before v14 ships. (� next steps)
- **Value-shape `--scope` parser ambiguity.** A folder named exactly `context` could collide with the artifact-type token. Disambiguation rule: tokens MUST match the closed set of artifact-type names AND the value MUST NOT contain a path separator or `.md` suffix; otherwise treated as a path (single or comma-separated list of folders / files). (✅ done)
- **Anchor link integrity.** Vision-internal anchors are referenced from `06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13-further-improvements.md`, use-case READMEs, and PE-meta artifacts. Section reorders MUST be additive only. (✅ done)
- **Risk of conflating Detect triggers with manual invocation.** The fix must distinguish "trigger fired → incremental review" from "user manually asked → full review" without renaming the existing five triggers. (✅ done)
- **Phase 1.5 gating.** New Phase 1.5 (Organizational pass) MUST be gated on `breadth=full` AND `--scope` broader than a single file — otherwise narrow runs pay an organizational-pass cost they did not ask for. (✅ done)
- **Companion plans need realignment.** [02-usecases-update-plan.md](02-usecases-update-plan.md) and [02-pe-meta-update-plan.md](02-pe-meta-update-plan.md) were written against the seven-slicer + `--breadth` proposal. They must be revised to match this simplified surface before implementation begins. (📌 next steps)

---

## 📚 References

- 📒 [Parent issue: overview.md](overview.md) — analysis that motivates this plan
- 📒 [Use-cases update plan](02-usecases-update-plan.md) — companion plan for the use-case catalog (pending realignment to seven-parameter surface)
- 📒 [PE-meta update plan](02-pe-meta-update-plan.md) — companion plan for prompt + agent artifacts (pending realignment to seven-parameter surface)
- 📘 [vision.v13.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) — target document
- 📘 [vision.v13-further-improvements.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13-further-improvements.md) — companion improvement log
- 📘 [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — orchestrator that the new option surface will reshape
