---
title: "Recommended plan: acting on the loop-engineering analysis"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [plan, loop-engineering, learning-hub, prompt-engineering]
description: "Draft recommendation for acting on the loop-engineering analysis — capture the architecture, scope trigger and declarative-prompt design, analyze the visions and PE artifacts, defer build."
publish: false  # internal working artifact — never published (engine-neutral intent honored by the publish pipeline)
status: in-progress
goal: "Recommend and sequence the concrete actions drawn from the loop-engineering analysis so the user can authorize which to execute — capture-now documentation actions, scope-next design actions (trigger coherence and declarative condition-driven prompts), analysis sessions over the foundational visions and the PE artifacts, and deferred build actions."
motivation: "The session produced real architectural clarity (the object/meta loop split and the terminology stack) and clarified the trigger picture: triggers are foundational in the vision, so the open work is implementation maturity (wiring the ingestion triggers) and coherence (one unified trigger model), not design. Without a plan these evaporate; execution is intentionally gated on the user choosing which actions to pursue."
---

# Recommended plan: acting on the loop-engineering analysis

> **Status: in-progress.** Execution started for the capture actions and their completed items are marked below.

## Table of contents

- 🎯 [Goal](#goal)
- 🧭 [Context and motivation](#context-and-motivation)
- 📋 [Proposed actions (prioritized)](#proposed-actions-prioritized)
- ⚖️ [Open decisions](#open-decisions)
- 🅿️ [Park lot](#park-lot)
- 🔎 [Discovery](#discovery)
- 🏁 [Exit criteria](#exit-criteria)
- 📚 [References](#references)

---

## 🎯 Goal

Turn the [loop-engineering analysis](../overview.md) into a small, prioritized set of actions the user can authorize selectively — separating cheap capture work from design, analysis, and build — so the architectural clarity from the session is preserved, the trigger work (implementation maturity and coherence) is scoped before it's built, the declarative-prompts direction is drafted where it belongs, and the foundational visions and PE artifacts are analyzed against these insights.

## 🧭 Context and motivation

The analysis compared the Learning Hub with the public loop-engineering framing: the two share most machinery, the Hub adds governance (risk-calibrated autonomy, a metadata-driven self-update meta-loop), and both treat self-starting triggers as foundational — so the Hub's open work on triggers is implementation and coherence, not design. The analysis also named a durable distinction — object loop (behavior) vs meta loop (self-update) — and a four-layer terminology stack. None of that is written down in an authoritative artifact yet. This plan proposes where each piece should land.

## 📋 Proposed actions (prioritized)

### Capture now — low effort, high leverage (✅ done)

- **A1-capture-architecture** — Add a short "object loop vs meta loop" section (the two-level table plus the five separation rules) and the four-layer terminology stack to the authoritative location for engine architecture. Landing resolved via `OD2-capture-landing` to the engine vision. (✅ done)
- **A2-fill-stubs** — Populate the two empty stubs the ideas should already occupy: this [overview.md](../overview.md) (done as part of this session) and the [autonomous-streams.md](../../../06.00-idea/autonomous-streams/autonomous-streams.md) definition, positioning "autonomous stream" against loop engineering and the self-updating engine. (✅ done)

### Scope next — trigger implementation and coherence (✅ done)

- **C1-scope-ingestion-loop** — Write a one-page scope for wiring the creation/ingestion triggers the vision already specifies (feeds, conference pipeline, scheduled dispatch): what fires them, what they draft, where the human gate sits, and how trigger-fired *creation* (not just maintenance) rides the autonomy gradient. Build on the existing observation-investigator agent as the seed. Output is a scope/vision doc, not code. Landed in [04-scope-trigger-implementation-and-coherence.md](04-scope-trigger-implementation-and-coherence.md). (✅ done)
- **C2-unify-trigger-model** — Consolidate the trigger model that is re-specified across three visions (the Hub's "Automated Prompts," the engine's "Scheduled" command family plus runtime hooks, and the research vision's scheduled automation) into one shared taxonomy in the engine layer that every domain instantiates. Output is a scope/design note, not code. Landed in [04-scope-trigger-implementation-and-coherence.md](04-scope-trigger-implementation-and-coherence.md). (✅ done)
- **C3-declarative-prompts-design** — Draft a design note for **declarative, condition-driven prompts**: goal + exit-conditions drawn from each artifact's metadata contract (`goal`/`scope`/`boundaries`, quality dimensions, actionability gate), an iteration budget, the graded verdict as the anti-gaming guard, and the separation of *conditions decide done* from *autonomy decides allowed*. Land it in the [self-updating prompt-engineering vision](../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) as its natural home. Output is a design note, not artifact rewrites. Landed in the vision under `§ Command families and option model` as "Declarative, condition-driven prompts (design note)". (✅ done)

### Analyze next — visions and artifacts (✅ done)

- **AN1-analyze-visions** — Run analysis sessions across the three foundational documents — the [Learning Hub vision](../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md), the [self-updating engine (machinery) vision](../../../06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md), and the [self-updating prompt-engineering vision](../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) — to reconcile this session's insights (object/meta loop split, unified trigger model, declarative condition-driven prompts) into each and list the specific amendments each needs. Output: per-vision findings + an amendment list, not the amendments themselves. Landed in [05-an1-vision-analysis-and-amendment-list.md](05-an1-vision-analysis-and-amendment-list.md). (✅ done)
- **AN2-analyze-pe-artifacts** — Run analysis sessions over the Learning Hub's PE artifacts (prompts, agents, skills, instructions under `.github/`) to identify which are process-based and are strong candidates for declarative, condition-driven restructuring, and to assess the blast radius of unifying the trigger model. Reuse the existing `pe-meta-*-review` prompts and documentation-review agents where they fit. Output: a candidate list ranked by leverage and risk, not the rewrites. Landed in [06-an2-pe-artifacts-analysis-ranked-candidates.md](06-an2-pe-artifacts-analysis-ranked-candidates.md). (✅ done)

### Deferred — after the scope is agreed (📌 next steps)

- **D1-build-dispatcher** — Implement the discovery dispatcher that turns `C1` into a running trigger. Depends on `C1-scope-ingestion-loop`. (📌 next steps)
- **E1-worktrees-parallelism** — Add parallel-agent fan-out for independent articles. Not the current bottleneck. (📌 next steps)

## ⚖️ Open decisions

- **OD1-authorize-capture** — Execute `A1` and `A2` now? *Resolved by:* user go-ahead. *Gates:* A1-capture-architecture, A2-fill-stubs. (✅ done)
- **OD2-capture-landing** — Should the architecture note (`A1`) land in the [self-updating engine vision](../../../06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md) (where the engine is defined) or stay reader-facing in [overview.md](../overview.md)? *Resolved by:* landed in the engine vision during execution. *Gates:* A1-capture-architecture. (✅ done)
- **OD3-authorize-scope-c** — Proceed with the scope/design work this cycle (`C1` ingestion wiring, `C2` unified trigger model, `C3` declarative-prompts design), or park it for later? *Resolved by:* user go-ahead to proceed with the plan. *Gates:* C1-scope-ingestion-loop, C2-unify-trigger-model, C3-declarative-prompts-design. (✅ done)
- **OD4-authorize-analysis** — Run the analysis sessions this cycle (`AN1` foundational visions, `AN2` PE artifacts), or schedule them separately? *Resolved by:* user go-ahead to proceed with the plan. *Gates:* AN1-analyze-visions, AN2-analyze-pe-artifacts. (✅ done)

## 🅿️ Park lot

- **PL1-streams-folder-dedup** — Two sibling folders exist (`autonomous streams` with a space and `autonomous-streams` with a hyphen); consolidate to the kebab-case one per repo naming rules. → closed: completed (folder consolidated to `autonomous-streams`)
- **PL2-autonomy-gradient-into-streams** — Fold the engine's risk-calibrated autonomy gradient explicitly into per-stream governance. → defer
- **PL3-loop-primitive-audit** — Full primitive-by-primitive audit of the Hub as a standalone idea doc. → defer

## 🔎 Discovery

- **DISC1-engine-vision-anchor** — The exact section in the engine vision where the object/meta note belongs is undecidable until `OD2` resolves toward the engine vision. *If absent →* create a new "Object loop vs meta loop" subsection under the vision's design-principles section.

## 🏁 Exit criteria

This plan is complete when: the user has authorized a subset of the proposed actions via [§ Open decisions](#open-decisions); every authorized action has been executed or spawned into a sibling plan; and any unauthorized action has an explicit disposition (deferred or closed). `OD1`–`OD4`, `C1`–`C3`, and `AN1`–`AN2` are now closed; deferred items `D1` and `E1` remain explicitly parked as next steps.

## 📚 References

- [Loop-engineering analysis](../overview.md) — the source analysis this plan acts on.
- [Self-updating engine vision](../../../06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md) — candidate landing for `A1`; analyzed by `AN1`.
- [Self-updating prompt-engineering vision](../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) — landing for `C3`; analyzed by `AN1`.
- [Learning Hub introduction](../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) — analyzed by `AN1`.
- [autonomous-streams.md](../../../06.00-idea/autonomous-streams/autonomous-streams.md) — target stub for `A2`.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "01-recommended-plan.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "plan"
  plan_status: "in-progress"
-->
