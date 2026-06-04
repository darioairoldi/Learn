---
title: "Plan: PE-meta artifact updates to enforce the v14 seven-parameter canonical surface, default-full invocation contract, derived breadth, value-shape --scope parser, Phase 0a, and per-artifact prompt invocation matrix"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, pe-meta]
description: "Plan for amending the PE-meta artifacts (orchestrator [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md), per-type prompts, agents, option-applicability matrix, option-parser tests, and missing `pe-self-update.config.json`) to implement the vision v14 contracts: (a) parameter-less manual invocations execute a full sweep (R-P8-default-full-investigation); (b) the canonical option surface is exactly seven parameters — `--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip` (R-P9-minimal-consistent-option-surface); (c) breadth is a derived attribute (`full`/`incremental`/`bounded-delta`) computed from `--start`/`--end` plus caller-type, not a flag; (d) the value-shape `--scope` parser accepts an artifact-type token OR a comma-separated set of folders/files; (e) Phase 0a — conversational pre-parser — resolves free-form input to canonical options before strict parsing; (f) the per-artifact prompt invocation matrix routes `(--scope artifact-type, --dim) → pe-meta-{type}-{review|create-update|design}`; (g) the pipeline-phases / `--skip` mapping is honored, including rule #2 (`--skip research` is INCOMPATIBLE with derived `breadth=full`); (h) Phase 1 research produces either a current-state snapshot, a change digest, or a bounded-window digest per derived breadth; (i) new Phase 1.5 Organizational Pass runs when `breadth=full` AND `--scope` is broader than a single file; (j) every run echoes the resolved invocation back to the caller before Phase 1 and emits a first-line `Resolved invocation: …` log; (k) the 10 deprecated v13 flags are rejected (CF-05) except for documented single-window aliases. Replaces the prior v13.x draft of this plan."
draft: false
status: "closed"
severity: "Critical"
component: "[.github/prompts/00.09-pe-meta/](../../../../../../.github/prompts/00.09-pe-meta/), [.github/agents/00.09-pe-meta/](../../../../../../.github/agents/00.09-pe-meta/)"
framework: "GitHub Copilot Customization v1.107 (vision v14.0.0)"
---

# Plan — PE-meta artifact updates to implement the vision v14 contracts

**Parent issue:** [overview.md](overview.md)
**Companion plans:** [01-vision-update-plan.md](01-vision-update-plan.md) (✅ closed — vision v14 published), [02-usecases-update-plan.md](02-usecases-update-plan.md) (✅ closed — 34 use cases, JSON v2.3.0)
**Plan ID:** `03-pe-meta-update-plan`
**Date:** 2026-05-29
**Status:** Closed (✅ done — all R0–R8 + R5′/R5″/R5‴ edits applied to live PE-meta artifacts on 2026-05-29)

---

## 📝 Revision note (2026-05-29) — supersedes prior v13.x draft

This plan was first drafted against the v13.x vision surface, which spoke in terms of an explicit `--breadth` flag, seven separate slice flags (`--since`, `--between`, `--area`, `--subject`, `--artifact`, `--consumer`, `--concern`), a `--mode-review` flag, and a `catch-up` breadth value. Vision v14 (2026-05-29) retired all of those in favor of a minimal seven-parameter canonical surface, a derived breadth attribute, a value-shape `--scope` parser, and Phase 0a. The current document realigns the plan to v14 verbatim. Where the v13.x semantics survive, they were preserved (e.g., per-source `last_review_timestamp`, change-digest output, Organizational Pass, outcome log, context construction-invariant gate). Where v13.x flags are gone, the plan now targets the parameter they were absorbed into. The retired-flag inventory below is the authoritative migration map for orchestrator edits.

| Retired v13.x surface | v14 destination | Notes |
|---|---|---|
| `--breadth full\|incremental\|catch-up` | Derived attribute; logged on first line of every run report | § Default-full invocation contract (vision v14) |
| `catch-up` breadth value | Replaced by `--start <older-than-default>` on any caller | No standalone replacement; bounded-delta covers the use case |
| `--since <date>` | `--start <date>` | Window resolves to `bounded-delta` per rule #2 |
| `--between <a>..<b>` | `--start <a> --end <b>` | Window resolves to `bounded-delta` per rule #2 |
| `--area <token>` | `--scope <artifact-type-token>` | Value-shape `--scope` parser, artifact-type form |
| `--artifact <path>` | `--scope <path>[,<path>...]` | Value-shape `--scope` parser, paths form |
| `--consumer <path>` | `--scope <agent-or-prompt-file> --deps full` | `--deps` is the depth axis; `--scope` is the entry point |
| `--subject <kw>` | Resolved by Phase 0a → comma-separated `--scope` enumeration | Free-form scoping intent never reaches phases 1–8 |
| `--concern <kw>` | Resolved by Phase 0a → `--scope` (+ `--dim` when the keyword maps to a dimension) | Same as above |
| `--mode-review individual\|dep-aware\|guidance-first` | Auto-derived from `--scope` artifact-type + per-artifact prompt invocation matrix; guidance-first leg covered by `--dim adherence` | No standalone flag; mode is structural |
| `--incremental` | Single-window deprecation alias resolving to derived `breadth=incremental` when caller-type is trigger-fired; rejected (CF-05) for manual callers (would violate R-P8) | Per "Deprecated-flag aliases MAY be accepted during a single migration window" |
| `--breadth` (any value) | Rejected (CF-05) with deterministic deprecation notice | No alias preserved |

Each row in the per-file plan below cites the v14 section it implements.

---

## 🎯 Goal

Bring the PE-meta artifacts into compliance with [vision v14](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md). Every change in this plan maps to one of the recommendations **R0 – R8** defined in the [parent issue overview](overview.md), interpreted through the v14 surface (R5 is retired by v14 and is removed from the mapping; see § Recommendation mapping for the realigned slot).

The orchestrator currently (a) silently re-interprets parameter-less manual invocations as incremental (violates R-P8-default-full-investigation), (b) carries the v13.x `--incremental` flag without the v14 deprecation contract, (c) exposes `--scope` as a single-form (type-only) parameter rather than the v14 value-shape parser, (d) has no Phase 0a conversational pre-parser, (e) has no per-artifact prompt invocation matrix wiring, (f) has no first-line `Resolved invocation:` log, and (g) lacks the pipeline-phases / `--skip` mapping required by v14 rule #2 (which makes `--skip research` INCOMPATIBLE with derived `breadth=full`).

This plan codifies the fix at the artifact level so the behavior is enforced **deterministically** by prompt + agent definitions (not by runtime assistant judgment). All edits are additive where possible; v13.x flags are removed and replaced with v14 canonical equivalents, with a single migration-window alias for `--incremental` only.

---

## 📋 Table of contents

- [📝 Revision note (2026-05-29) — supersedes prior v13.x draft](#-revision-note-2026-05-29--supersedes-prior-v13x-draft)
- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [🗺️ Recommendation → file mapping](#%EF%B8%8F-recommendation--file-mapping)
- [📌 Per-file plan](#-per-file-plan)
- [📌 New artifacts to create](#-new-artifacts-to-create)
- [📌 Sequencing](#-sequencing)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

All exit criteria below cite the [vision v14](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) section they enforce.

- Orchestrator exposes exactly the **seven canonical parameters** — `--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip` — and rejects all other `--*` flags with CF-05 deprecation notices (§ Command families and option model § Option taxonomy; R-P9-minimal-consistent-option-surface). (✅ done — `pe-meta-update.prompt.md` v2.1.0 argument-parsing section rewritten with table-driven rejection)
- Orchestrator **derives** breadth (`full` / `incremental` / `bounded-delta`) per v14 rule #2 — interactive + no window → `full`; trigger-fired + no window → `incremental`; any `--start`/`--end` → `bounded-delta` — and does NOT accept `--breadth` as a flag (§ Default-full invocation contract; R-P8-default-full-investigation). (✅ done — new § Derived breadth (no flag) subsection)
- Orchestrator implements the **value-shape `--scope` parser**: a single artifact-type token (`context|instructions|agents|prompts|skills|hooks|snippets|templates|all`) OR a comma-separated set of paths (folders end `/`, files end `.md`) (§ Option taxonomy; rationale R-P9). (✅ done — `--scope` subsection rewritten; mixing rejected)
- Orchestrator implements **Phase 0a — conversational pre-parser**: free-form scoping intent (subjects, concerns, consumer chains) is resolved into the seven canonical parameters BEFORE strict parsing; phases 1–8 only ever consume canonical options (§ Option taxonomy; R-P9). (✅ done — § Phase 0a — Conversational pre-parser inserted with worked example)
- Orchestrator implements the **per-artifact prompt invocation matrix**: `(--scope-resolved-artifact-type, --dim) → pe-meta-{type}-{review|create-update|design}` selection (§ Per-artifact prompt invocation matrix). (✅ done — 8×3 matrix codified in orchestrator + matrix file)
- Orchestrator honors the **pipeline phases / `--skip` mapping**, including rule #2: `--skip research` is INCOMPATIBLE with derived `breadth=full` and MUST be rejected with CF-05 (§ Pipeline phases and `--skip` mapping). (✅ done — new § Pipeline phases and `--skip` mapping subsection; rule #2 rejection in parser-tests R-S01)
- Orchestrator **echoes the resolved invocation** back to the caller before Phase 1 runs AND emits a first-line `Resolved invocation: --mode=… --scope=… --source=… --dim=… --start=… --end=… --deps=… --skip=… | breadth=… | caller=…` log in the Phase 8 report (§ Default-full invocation contract; § Detect; success criterion #12). (✅ done — Phase 8 report requirement + Phase 1 echo)
- Phase 1 (Source Research) produces a **current-state snapshot** (`breadth=full`), a **change digest** (`breadth=incremental`), or a **bounded-window digest** (`breadth=bounded-delta`) per the v14 research-phase output contract (§ Assess; "Research-phase output contract by invocation shape"). (✅ done — § Research-phase output contract by derived breadth added; 3 templates created)
- New **Phase 1.5 Organizational Pass** runs when `breadth=full` AND the value-shape resolved `--scope` is broader than a single file (vision v14 § Most recent changes; § The goal § Default-full invocation contract). (✅ done — Phase 1.5 inserted between Phase 1 and Phase 2 with gate condition)
- [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) covers all seven canonical parameters (currently `--source` and `--start`/`--end` are missing) and includes the derived-breadth row (§ Option taxonomy). (✅ done — 7 classes + § Derived breadth + § Per-artifact matrix + § Pipeline phases + § Retired flags sections added)
- [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) contains: acceptance tests for the seven canonical parameters; derived-breadth resolution tests (manual no-args, trigger-fired no-args, `--start` window); value-shape `--scope` tests (artifact-type token, single path, comma-separated paths); rejection tests for all 10 retired v13.x flags via CF-05; rejection test for `--skip research` when derived `breadth=full`; Phase 0a free-form-to-canonical resolution tests; first-line `Resolved invocation:` log shape tests. (✅ done — A-U09–U13, A-D01–D04, A-P0a-01/02, A-M01–M03, A-L01, R-S01, R-A01, RV-01–RV-10 added)
- New file `pe-self-update.config.json` exists at the repo root (or `.copilot/config/`) with `monitored_sources`, `state.namespace`, `state.path`, `lookback.default_days`, `sampling.adherence_consumers_per_file` fields populated (R1; see § New artifacts to create). (✅ done — created at `.copilot/config/pe-self-update.config.json`)
- [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) consumes the config, produces the three contracted research outputs (snapshot/digest/window-digest), and persists `last_review_timestamp` per source under `<state.path>/triggers/<source-id>.json` (R2). (✅ done — researcher v2.2.0 with Configuration source + three-shape output contract + per-source state I/O)
- [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) version bumped (`2.0.0` → `2.1.0`); changelog entry added; the `--incremental` migration-window alias documented with its rejection rules for manual callers. (✅ done — version 2.1.0, changelog entry, alias contract codified)
- [pe-meta-adherence.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md) auto-samples N consumers per guidance file (N from config) when the orchestrator's resolved `breadth=full` is passed through (R8). (✅ done — adherence v1.4.0 with Phase 2a Sampling step + 3 test scenarios)
- Outcome-log append hook wired in Phases 6 and 8 of the orchestrator (R7). (✅ done — append-hook documented in Phase 6 apply step and Phase 8 final summary)
- [pe-meta-context-review.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) carries a six-property construction-invariant gate that blocks any apply path on a failed property (R6). (✅ done — context-review v1.2.0 with step 4a six-property R6 gate + step 8 blocker-first ordering)

---

## 🗺️ Recommendation → file mapping

The R0–R8 statements come from the [parent issue overview](overview.md). The "v14 interpretation" column restates each recommendation in v14 terms (where the original wording assumed retired flags). R5 is **retired by v14** (its `--mode-review` flag no longer exists; mode is derived structurally). Its slot is reused below for the v14-introduced workstreams that have no R-numbered slot in the original overview: **Phase 0a (conversational pre-parser)**, the **per-artifact prompt invocation matrix**, and the **pipeline-phases / `--skip` mapping** with rule #2 enforcement.

| Rec | v14 interpretation | Primary file(s) | Vision v14 anchor | Status |
|---|---|---|---|---|
| **R0** | Default-full invocation contract + canonical seven-parameter parser + value-shape `--scope` parser; remove `--breadth` flag and reject all 10 retired v13.x flags via CF-05 (preserve `--incremental` only as a single-window deprecation alias bound to trigger-fired callers) | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md), [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md), [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) | § Default-full invocation contract; § Option taxonomy; R-P8 + R-P9 | (✅ done) |
| **R1** | Monitored-sources registry (unchanged from v13; v14 leaves config shape unchanged) | New `pe-self-update.config.json`; consumed by [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) | § Detect (monitored sources) | (✅ done) |
| **R2** | Three-shape research output contract (snapshot / change-digest / bounded-window digest) keyed on **derived breadth** (NOT a flag); persist `last_review_timestamp` per source | [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md); new templates under `.github/templates/00.00-prompt-engineering/`; state under `.copilot/temp/pe-meta-state/triggers/` | § Assess ("Research-phase output contract by invocation shape") | (✅ done) |
| **R3** | Tier-2 relevance screening wired into Phases 2–4 against the resolved research output (snapshot diff / digest / window digest) | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 2–4 sections | § Assess (Tier-2 relevance screening) | (✅ done) |
| **R4** | New Phase 1.5 Organizational Pass; trigger condition is `derived breadth=full` AND `--scope` broader than a single file (NOT `--breadth full` since that flag does not exist) | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) | § Most recent changes; § Default-full invocation contract (Phase 1.5 gate) | (✅ done) |
| **R5** | **RETIRED by v14.** Original recommendation introduced `--mode-review individual\|dep-aware\|guidance-first`. v14 derives mode structurally from `--scope` artifact-type (via the per-artifact prompt invocation matrix) and covers the guidance-first leg via `--dim adherence`. No flag, no per-call selection. Slot reused below. | _(none — slot reused)_ | § Per-artifact prompt invocation matrix; R-P9 (no surface duplication) | (✅ done by removal) |
| **R5′** | **Phase 0a — conversational pre-parser.** Free-form scoping intent (subjects, concerns, consumer chains) resolves to canonical options BEFORE strict parsing; phases 1–8 only consume canonical options | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) (new § Phase 0a); [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) (Phase 0a resolution tests) | § Option taxonomy (conversational pre-parser); R-P9 | (✅ done) |
| **R5″** | **Per-artifact prompt invocation matrix.** `(--scope-resolved-artifact-type, --dim) → pe-meta-{type}-{review\|create-update\|design}` selection codified inside the orchestrator and exercised by parser tests | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) (new § Per-artifact prompt invocation matrix); [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md); [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) | § Per-artifact prompt invocation matrix | (✅ done) |
| **R5‴** | **Pipeline-phases / `--skip` mapping + rule #2 enforcement.** `--skip research` is INCOMPATIBLE with derived `breadth=full` (CF-05 rejection); document the per-phase `--skip` token set | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) (new § Pipeline phases / `--skip` mapping); [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md); [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) | § Pipeline phases and `--skip` mapping | (✅ done) |
| **R6** | Six-property construction-invariant gate for context (unchanged from v13) | [pe-meta-context-review.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) | § Guidance quality as prerequisite | (✅ done) |
| **R7** | `outcome-log.jsonl` write hook in Phases 6 and 8 (unchanged from v13) | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) | § Execute (outcome log) | (✅ done) |
| **R8** | Auto-sample N consumers in adherence prompt when **derived breadth=full** is passed through from the orchestrator (NOT when `--breadth full` is passed — that flag does not exist) | [pe-meta-adherence.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md) | § Detect (sampling); R-P8 (full-investigation contract) | (✅ done) |

---

## 📌 Per-file plan

### [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — primary orchestrator changes (Action — extend) (✅ done — v2.1.0)

Sections to edit, in document order. Each item cites the v14 section it implements.

1. **Frontmatter** — bump `version: "2.0.0"` → `"2.1.0"`. Replace `argument-hint:` value with EXACTLY the seven canonical parameters: `'[--mode plan|apply] [--scope <type|path>[,<path>...]] [--source <id>[,<id>...]] [--dim <group|D#>] [--start <date>] [--end <date>] [--deps none|direct|full|<N>] [--skip <stage>[,<stage>...]]'`. Do NOT include `--breadth`, `--since`, `--between`, `--area`, `--subject`, `--artifact`, `--consumer`, `--concern`, `--mode-review`. (§ Option taxonomy; R-P9) (✅ done)
2. **§ Invocation options** — DELETE the existing `### --incremental` subsection; INSERT a new `### Derived breadth (no flag)` subsection between `--mode` and `--dim` that explains breadth is computed from `--start`/`--end` plus caller-type per v14 rule #2 (interactive + no window → `full`; trigger-fired + no window → `incremental`; any window → `bounded-delta`) and is logged on the first line, never passed as a flag. (§ Default-full invocation contract; R-P8) (✅ done)
3. **§ Invocation options § `--scope`** — rewrite to document the **value-shape parser**: accepts either an artifact-type token (`context|instructions|agents|prompts|skills|hooks|snippets|templates|all`) OR a comma-separated set of paths (folders end `/`, files end `.md`). State explicitly that `--scope all` does NOT alter breadth — `--scope` controls WHAT artifacts to process; breadth controls research-phase output shape; they are orthogonal. (§ Option taxonomy; R-P9) (✅ done)
4. **§ Invocation options** — INSERT a new `### --source <id>[,<id>...]` subsection (currently missing) documenting source-filter semantics: when omitted, all configured monitored sources are considered; when present, only the listed sources participate in Phase 1. Resolution against `pe-self-update.config.json` `monitored_sources.*` keys. (§ Option taxonomy; § Detect) (✅ done)
5. **§ Invocation options** — INSERT a new `### --start <date> / --end <date>` subsection (currently missing) documenting the window form: ISO-8601 dates; `--start` alone is interpreted as "from `<date>` to now"; `--end` alone is interpreted as "from beginning of lookback default to `<date>`"; both together define a closed window. ANY window resolves derived breadth to `bounded-delta` per rule #2. (§ Default-full invocation contract; R-P8) (✅ done)
6. **§ Invocation options** — REPLACE the existing `### --skip` subsection content with the v14 pipeline-phases / `--skip` mapping (see item 11) and add the rule #2 incompatibility: `--skip research` MUST be REJECTED with CF-05 when derived `breadth=full` (manual no-window caller). (§ Pipeline phases and `--skip` mapping) (✅ done)
7. **§ Intent resolution from natural-language input** — REPLACE this section title with **§ Phase 0a — Conversational pre-parser**. Document that free-form scoping intent (subject keywords, concern keywords, consumer-chain expressions) is resolved into canonical options BEFORE strict parsing; the resolution is echoed to the caller; phases 1–8 only consume the resolved canonical options. Include a short worked example: "review the new vscode build" → `--scope all --source vscode-release-notes --dim full` (derived breadth: `incremental` if trigger-fired, `full` if manual). (§ Option taxonomy; R-P9) (✅ done)
8. **§ Argument parsing** — REWRITE to enforce the seven-parameter surface. The parser MUST: (a) accept exactly the seven canonical parameters; (b) reject every other `--*` token with a CF-05 deprecation notice that names the retired flag and points to its v14 replacement (use the migration map in § Revision note as the authoritative table); (c) accept `--incremental` as a single-window deprecation ALIAS that resolves to derived `breadth=incremental` ONLY when caller-type is trigger-fired — reject it with CF-05 when caller-type is manual (would silently violate R-P8). Emit a one-line deprecation notice for every alias acceptance. (§ Option taxonomy; R-P9; "Deprecated-flag aliases MAY be accepted during a single migration window") (✅ done)
9. **§ Argument parsing** — INSERT a new subsection **§ Per-artifact prompt invocation matrix** that codifies the routing: `(--scope-resolved-artifact-type, --dim) → pe-meta-{type}-{review|create-update|design}` where `{review|create-update|design}` is selected from `--mode` semantics (`plan`/`apply` collapse to the `review` family for the assessment posture; `create-update` and `design` are selected by absence of a target file path vs presence of a description). Include the full 8×3 matrix for the 8 artifact types (context, instructions, agents, prompts, skills, hooks, snippets, templates). (§ Per-artifact prompt invocation matrix) (✅ done)
10. **Pipeline phases (top of section)** — INSERT a new **§ Pipeline phases and `--skip` mapping** subsection BEFORE Phase 1 that enumerates every `--skip` token (`research`, `structure`, `consistency`, `content`, `external`, plus any others surfaced by v14) and maps it to its phase; restate rule #2 (`--skip research` INCOMPATIBLE with derived `breadth=full`); state that `--skip` of Phases 5 (approval) and 8 (report) is FORBIDDEN — they are never skippable. (§ Pipeline phases and `--skip` mapping) (✅ done)
11. **§ Pipeline phases — Phase 1** — add subsection **§ Research-phase output contract by derived breadth** that documents three output shapes per v14: snapshot (`breadth=full`), change-digest (`breadth=incremental`), bounded-window digest (`breadth=bounded-delta`). Link to the templates created in R2. (§ Assess; "Research-phase output contract by invocation shape") (✅ done)
12. **§ Pipeline phases — Phases 2, 3, 4** — add a screening step: "If a change-digest or bounded-window digest is available, screen the artifact set against the digest before deep tier; if a snapshot is available, screen against the snapshot's diff with the prior snapshot if any." This is R3. (§ Assess (Tier-2 relevance screening)) (✅ done)
13. **§ Pipeline phases — INSERT new Phase 1.5 Organizational Pass** between Phase 1 and Phase 2. Gate condition: `derived breadth == full AND --scope-resolved-artifact-set has cardinality > 1 (i.e., not a single file)`. (§ Most recent changes; § Default-full invocation contract) (✅ done)
14. **§ Pipeline phases — Phase 6 (Apply)** — add outcome-log append hook (R7). (§ Execute (outcome log)) (✅ done)
15. **§ Pipeline phases — Phase 8 (Report)** — REQUIRE that the **first line** of the report is EXACTLY `Resolved invocation: --mode=<…> --scope=<…> --source=<…> --dim=<…> --start=<…> --end=<…> --deps=<…> --skip=<…> | breadth=<full|incremental|bounded-delta> | caller=<manual|trigger-fired>`. The same string MUST be echoed to the caller before Phase 1 runs (matches success criterion #12). Add outcome-log append for the final summary (R7). (§ Default-full invocation contract; § Detect; success criterion #12) (✅ done)
16. **Top of file (after frontmatter)** — append a `2.1.0` changelog entry listing every change above and naming each retired flag plus its v14 destination (mirrors § Revision note's migration map). (✅ done)

### [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) (Action — extend) (✅ done)

- The current matrix lists 5 classes (Dimension, Dependency, Scope, Mode, Skip) but v14 requires SEVEN canonical parameters. ADD two missing classes: **Source** (`--source <id>[,<id>...]`) and **Window** (`--start <date> / --end <date>`). Restate the seven-parameter intent verbatim from § Option taxonomy. (✅ done — heading rewritten to "7 classes"; Source + Window rows added)
- Update the **§ Option detail: `--scope`** section to document the v14 value-shape parser (artifact-type token OR comma-separated paths); the current table already touches on path scope but does not state the formal value-shape rule (folders end `/`, files end `.md`). (✅ done — new § `--scope` value shape (formal) section added)
- ADD a **§ Derived breadth** section (NOT a column — breadth is not a flag) showing the three derived values, their resolution rule, and where they appear in the first-line log. (✅ done — § Derived breadth (vision v14) with caller-type × window table + Rule #2)
- ADD a **§ Per-artifact prompt invocation matrix** section reproducing the 8×3 matrix from the orchestrator's new § Per-artifact prompt invocation matrix subsection (single source of truth: the matrix file). (✅ done — § Per-artifact prompt invocation matrix with 8×3 table added)
- ADD a **§ Pipeline phases and `--skip` mapping** section reproducing the per-token → phase mapping and the rule #2 incompatibility. (✅ done — § Pipeline phases and `--skip` mapping with 8 rows added)
- ADD a **§ Retired flags (rejected)** section listing the 10 retired v13.x flags with their CF-05 rejection messages and v14 destinations (one-row table; row order matches § Revision note's migration map). (✅ done — § Retired v13.x flags (vision v14) with 10-row CF-05 table added)

### [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) (Action — extend) (✅ done)

Add deterministic parser-test rows for:

- Acceptance tests for every value of every canonical parameter (`--source` single, `--source` comma-separated, `--start` alone, `--end` alone, `--start` + `--end` window, `--scope` artifact-type, `--scope` single path, `--scope` comma-separated paths). (✅ done — A-U09–U13 added)
- Derived-breadth resolution tests:
  - A-D01: `/pe-meta-update` (manual, no args, no env trigger) → `breadth=full`. (✅ done)
  - A-D02: `/pe-meta-update` invoked via trigger env signal → `breadth=incremental`. (✅ done)
  - A-D03: `/pe-meta-update --start 2026-05-01` → `breadth=bounded-delta`. (✅ done)
  - A-D04: `/pe-meta-update --start 2026-05-01 --end 2026-05-15` → `breadth=bounded-delta` with closed window. (✅ done)
- Phase 0a free-form resolution tests:
  - A-P0a-01: `/pe-meta-update "review the new vscode build"` → resolved to `--scope all --source vscode-release-notes --dim full` with echoed resolution string. (✅ done)
  - A-P0a-02: `/pe-meta-update "check adherence in the pe-meta agents"` → resolved to `--scope .github/agents/00.09-pe-meta/ --dim adherence`. (✅ done)
- Per-artifact invocation matrix tests:
  - A-M01: `/pe-meta-update --scope prompts --dim full` → routes through `pe-meta-prompt-review`. (✅ done)
  - A-M02: `/pe-meta-update --scope context --dim quality` → routes through `pe-meta-context-review`. (✅ done)
  - A-M03: `/pe-meta-design "new instruction for X" --scope instructions` → routes through `pe-meta-instruction-design`. (✅ done)
- First-line `Resolved invocation:` log shape test: A-L01 asserts the exact first-line format on EVERY run including `--mode plan`. (✅ done)
- Rule #2 rejection test: R-S01 `/pe-meta-update --skip research` (no window, manual) → REJECTED with CF-05 (incompatible with derived `breadth=full`). (✅ done)
- Rejection tests for the 10 retired v13.x flags (one row per flag — `--breadth`, `--since`, `--between`, `--area`, `--artifact`, `--consumer`, `--subject`, `--concern`, `--mode-review`, plus a manual `--incremental` rejection): each REJECTED with CF-05 naming the v14 destination. The single passing alias test (R-A01) covers `--incremental` accepted on trigger-fired callers only with a deprecation notice emitted. (✅ done — RV-01–RV-10 + R-A01 added)

### [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) (Action — extend) (✅ done — v2.2.0)

- Add a **§ Configuration source** section pointing to `pe-self-update.config.json` (R1). (✅ done)
- Add a **§ Output contract** section that documents the THREE output shapes (snapshot / change-digest / bounded-window digest) and selects by **derived breadth** (NOT by a flag); cite v14 § Assess "Research-phase output contract by invocation shape". (✅ done)
- Persist `last_review_timestamp` per source under `<state.path>/triggers/<source-id>.json` after every research step (R2). (✅ done — per-source state I/O documented)
- Replace the v13.x lookback logic ("when `--breadth catch-up` is passed, extend the lookback…") with v14 semantics: when the caller passes `--start <older-than-default>`, the resolver derives `breadth=bounded-delta` and the researcher uses the explicit window. No `catch-up` value exists. (✅ done — catch-up removed; window semantics documented)
- Add a **§ Source-filter** subsection documenting the `--source` parameter pass-through from the orchestrator: when present, only the listed `monitored_sources.*` entries participate. (✅ done)

### [pe-meta-context-review.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) (Action — extend) (✅ done — v1.2.0)

- Add a six-property construction-invariant gate (R6) to be evaluated before any rewrite proposal:
  1. Frontmatter completeness (all required keys present).
  2. Reference integrity (every link resolves).
  3. Anchor stability (no broken intra-file anchors).
  4. Scope statement parity (frontmatter `scope:` matches in-body Scope section).
  5. Boundaries actionability (each boundary uses MUST/MUST NOT and is observable).
  6. Rationale presence (every non-trivial choice has a rationale).
- Block any "apply" path if any property fails; emit a structured finding instead. (§ Guidance quality as prerequisite) (✅ done — step 4a R6 gate inserted; step 8 blocker-first ordering enforced)

### [pe-meta-adherence.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md) (Action — extend) (✅ done — v1.4.0)

- Add a **§ Sampling** section: when invoked from `pe-meta-update` with **derived `breadth=full`** passed through (NOT `--breadth full` — that flag does not exist), automatically sample N consumers per guidance file (N tunable via `sampling.adherence_consumers_per_file` in `pe-self-update.config.json`) instead of requiring `--scope` per consumer (R8). The sampling protocol MUST be stratified by artifact-type and layer (see § Boundaries and risks). (§ Detect (sampling); R-P8) (✅ done — Phase 2a Sampling step + stratified deterministic alphabetical order)

---

## 📌 New artifacts to create

### `pe-self-update.config.json` (Action — create) (✅ done — placed at `.copilot/config/pe-self-update.config.json`)

- **Path:** `pe-self-update.config.json` at repo root (top-level discoverability) OR `.copilot/config/pe-self-update.config.json` if hidden-folder discipline is preferred. Decide in implementation.
- **Required fields:**
  - `monitored_sources.platform[]` — e.g., VS Code release notes URLs.
  - `monitored_sources.model[]` — Copilot model release pages.
  - `monitored_sources.ecosystem[]` — extensions, MCP servers, related repos.
  - `state.namespace` — string, e.g., `"learn-hub"`.
  - `state.path` — relative path, e.g., `".copilot/temp/pe-meta-state"`.
  - `lookback.default_days` — integer, e.g., `30`. Used by Phase 1 when the caller does NOT provide `--start`/`--end`.
  - `sampling.adherence_consumers_per_file` — integer for R8.

### Templates for snapshot, change-digest, and bounded-window digest (Action — create) (✅ done — 3 templates created in `.github/templates/00.00-prompt-engineering/`)

- **Path:** `.github/templates/00.00-prompt-engineering/`.
- **Files (three shapes per v14):**
  - `pe-meta-research-snapshot.template.md` — full current-state snapshot shape (selected when derived `breadth=full`); one section per source category.
  - `pe-meta-research-digest.template.md` — incremental change digest (selected when derived `breadth=incremental`); carries forward the existing digest schema referenced by the orchestrator.
  - `pe-meta-research-window-digest.template.md` — bounded-window digest (selected when derived `breadth=bounded-delta`); includes explicit `window.start` / `window.end` fields per v14.
- **Cross-link:** referenced from [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) "Output contract" section.

### State location for `last_review_timestamp` (Action — create) (✅ done — `.copilot/temp/pe-meta-state/triggers/` documented in researcher contract; directory created on first write)

- **Path:** `.copilot/temp/pe-meta-state/triggers/` (one JSON file per source).
- **File shape:** `{ "source_id": "...", "last_review_timestamp": "...", "last_digest_hash": "..." }`.

---

## 📌 Sequencing

| Order | Group | Reason | Status |
|---|---|---|---|
| 1 | R0 (default-full + canonical seven-parameter parser + value-shape `--scope` + CF-05 rejections + `--incremental` alias contract) | Foundation. Without R0 the new shape has no entry point and the retired flags keep leaking into runtime | (✅ done) |
| 2 | R5′ (Phase 0a) + R5″ (per-artifact invocation matrix) + R5‴ (pipeline-phases / `--skip` mapping with rule #2) in parallel | All three are mechanical extensions to the orchestrator that hang off R0's parser; none can land without R0 | (✅ done) |
| 3 | R1 (config) + R2 (three-shape research contract — snapshot / digest / window-digest) in parallel | Required for Phase 1 to honor the v14 research-phase output contract; depends on R0 for derived-breadth signal | (✅ done) |
| 4 | R4 (Phase 1.5 Organizational Pass) | Adds the new phase that broad sweeps rely on; depends on R0 for the `breadth=full` derivation and on R2 for the snapshot input | (✅ done) |
| 5 | R3 (Tier-2 screening) + R6 (context construction-invariant gate) + R7 (outcome log) + R8 (adherence sampling on derived `breadth=full`) in parallel | Each is self-contained once R0–R4 land | (✅ done) |
| 6 | Option-applicability matrix + parser tests | Updated last so they capture the final shape of all seven canonical parameters, all derived-breadth resolutions, all Phase 0a resolutions, the per-artifact invocation matrix, and all CF-05 rejections | (✅ done) |
| 7 | Version bump + changelog | Final commit gate; verifies the migration map in § Revision note matches the actual rejection set in the parser | (✅ done) |

---

## ⚠️ Boundaries and risks

- **Vision v14 is the authority.** This plan does not invent contracts the vision does not specify. Each artifact change MUST cite the corresponding § in [vision v14](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) (cited inline in § Recommendation mapping and § Per-file plan). Where v14 says "MUST", this plan says MUST; where v14 says "MAY", this plan says MAY. (✅ done — every artifact edit cites a v14 §)
- **Backward compatibility (single migration window).** Existing invocations without any flags continue to work and acquire the documented derived breadth per caller-type (manual → `full`; trigger-fired → `incremental`). The ONLY preserved v13.x alias is `--incremental`, and ONLY for trigger-fired callers; manual `--incremental` is REJECTED with CF-05 because accepting it would silently violate R-P8-default-full-investigation. Every other retired flag is rejected with CF-05 and a deprecation notice naming its v14 destination. No undocumented aliases. (✅ done — alias rules enforced in orchestrator parser + R-A01 / RV-01–RV-10 tests)
- **Determinism gate.** The first-line `Resolved invocation:` log MUST be machine-parseable and IDENTICAL across `--mode plan` and `--mode apply`. The same string MUST be echoed to the caller BEFORE Phase 1 runs. This is success criterion #12 and the observable proxy used by the parent issue's exit criteria. (✅ done — A-L01 asserts identical format across modes)
- **Risk of partial rollout.** Landing R0 without R1 + R2 leaves Phase 1 with no contracted output shape for the three derived breadths. R0 MUST NOT be merged independently of R1 + R2. (✅ done — R0 + R1 + R2 landed together in this rollout)
- **Risk of double-narrowing.** The orchestrator must not silently combine derived `breadth=incremental` with a `--scope` narrower than full unless the caller passed both explicitly. v14 § Option taxonomy ("Phases 1–8 only ever consume canonical options") covers this: every narrowing is explicit and traceable to a caller-supplied parameter or a Phase 0a resolution. (✅ done — Phase 0a echo-back guarantee enforced)
- **Adherence prompt sampling (R8).** Random sampling can mask outliers. Sampling protocol MUST be stratified by artifact-type and layer; N MUST be configurable via `sampling.adherence_consumers_per_file`; the sampling decision MUST appear in the first-line `Resolved invocation:` log when it is exercised. (✅ done — Phase 2a stratified deterministic alphabetical order)
- **Phase 0a non-determinism risk.** Free-form input resolution is LLM-mediated; two callers with the same prompt MAY get the same canonical resolution, but reproducibility is not guaranteed. Mitigation: every Phase 0a resolution is echoed to the caller BEFORE Phase 1 runs (gives caller a chance to abort/correct); the resolved canonical string is logged on the first line; phases 1–8 only consume the canonical resolution, so downstream determinism is preserved. (✅ done — echo + first-line log mitigations codified)
- **CF-05 message uniformity.** Every retired-flag rejection MUST share a uniform message template (`<flag> retired in v14; use <v14-replacement> — see vision v14 § Migration notes`). Implementation MUST NOT hand-write per-flag prose; use a table-driven rejection in the parser. (✅ done — uniform template applied to all 10 RV-* test rows)
- **State files in `.copilot/temp/`.** Triggers state is per-machine; document that CI runs must seed or skip per-source state. (📌 next steps)
- **Config discoverability.** Placing `pe-self-update.config.json` at repo root vs `.copilot/config/` is a UX trade. Decide before R1 lands. (📌 next steps)
- **Pre-existing catalog bugs (flagged by the closed 02-usecases plan, NOT to be fixed in this plan):** duplicate `# UC-23` H1 across two use-case files; duplicate `Order in group: 2 (run after UC-12)` across two consumer-correctness use-case files. These do not block this plan; track in a separate housekeeping plan. (📌 next steps)

---

## 📚 References

- 📒 [Parent issue: overview.md](overview.md) — defines R0 – R8
- 📒 [Vision update plan](01-vision-update-plan.md) — ✅ closed; vision v14 published
- 📒 [Use-cases update plan](02-usecases-update-plan.md) — ✅ closed; 34 use cases catalog v2.3.0
- 📘 [vision v14 (2026-05-29)](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) — authoritative source for all contracts cited above
- 📘 [vision v14 changelog](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.changelog.md) — v13 → v14 migration map (cross-reference for § Revision note)
- 📘 [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — orchestrator (primary target)
- 📘 [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)
- 📘 [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md)
- 📘 [pe-meta-researcher.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md)
- 📘 [pe-meta-context-review.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md)
- 📘 [pe-meta-adherence.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md)
