---
title: "Improvement plan: context quality lifecycle integration for pe-meta"
author: "Dario Airoldi"
date: "2026-05-21"
categories: [issue, prompt-engineering, copilot, implementation-plan]
description: "Actionable implementation plan to integrate autonomous source investigation, validation, and context quality lifecycle analysis into pe-meta."
status: "in_progress"
version: "1.4.0"
---

# Improvement plan

## Table of contents

- [Problem statement](#problem-statement)
- [Vision constraints to preserve](#vision-constraints-to-preserve)
- [Priority goals to elevate](#priority-goals-to-elevate)
- [Target operating model](#target-operating-model)
- [Dimension model for context quality](#dimension-model-for-context-quality)
- [Integration blueprint for pe-meta](#integration-blueprint-for-pe-meta)
- [Actionable implementation backlog](#actionable-implementation-backlog)
- [Things to be done next (execution priority)](#-things-to-be-done-next-execution-priority)
- [Things to be done after wiring (stabilization)](#-things-to-be-done-after-wiring-stabilization)
- [Validation and evidence plan](#validation-and-evidence-plan)
- [Rollout plan](#rollout-plan)
- [Definition of done](#definition-of-done)
- [References](#references)

## Problem statement

The current gap is not only missing external freshness wiring in the narrow context review path.

The broader gap is that context maintenance is treated too often as single-file freshness, while context quality is a system property that spans multiple dimensions and dependencies.

`16-context-optimization.md` is valid, but it is scoped to D22 organization and optimization concerns. It is not the full context quality lifecycle.

Context quality as a whole must include, at minimum:

- consistency and cross-coherence,
- non-redundancy and priority clarity,
- completeness and coverage gaps,
- staleness and source verification,
- structure and scope correctness,
- optimization and efficiency as a separate concern.

## Vision constraints to preserve

This plan preserves the vision contract in `20260515.02-vision.v12.md`:

1. Goal alignment:
- maintain artifacts at peak reliability, effectiveness, and efficiency,
- maximize autonomy only where assessed risk allows,
- continuously detect drift, evaluate improvements, and execute validated corrections.

2. Scope alignment:
- use Detect -> Assess -> Propose -> Execute architecture,
- keep context-first assessment ordering,
- keep progressive depth (research -> screening -> deep),
- keep selective dimensions and model routing.

3. Boundary alignment:
- no autonomous changes to vision artifacts,
- conservative autonomy thresholds by default,
- self-update infrastructure staleness remains critical and never skipped.

## Priority goals to elevate

The following goals are promoted to top-priority outcomes for the PE system.

1. Autonomous staleness resolution:
- investigate authoritative sources autonomously,
- investigate user-provided sources autonomously when present,
- convert validated findings into actionable context-update proposals.

2. Source validation before integration:
- verify source trust and relevance,
- verify claim-to-source consistency,
- block integration when source evidence is weak or contradictory.

3. Autonomous integration with quality guardrails:
- integrate validated updates autonomously when risk is below threshold,
- escalate only high-impact or ambiguous changes,
- preserve reliability, effectiveness, and efficiency as non-negotiable outcomes.

4. Use-case usability requirement:
- implementation must be easy to invoke,
- flexible across trigger types and source sets,
- effective in catching real staleness,
- reliable across repeated runs.

## Target operating model

The context update lifecycle must be executed in three ordered stages whenever external or internal triggers indicate possible drift.

Pre-stage: Source intake and validation
- accept two source channels: authoritative default sources and user-provided sources,
- normalize source evidence into a single change digest,
- score source trust and applicability before Stage 1.

### Stage 1: Context-set impact assessment

Purpose:
- determine whether new information affects context goals, scopes, and boundaries at set level.

Outputs:
- impacted context areas,
- impacted dimensions,
- risk classification for structural versus content changes,
- source evidence map linking each impact claim to validated sources.

### Stage 2: Structure decision before content edits

Purpose:
- decide whether artifact structure must change before per-file updates.

Decisions:
- keep structure as-is,
- split files,
- merge files,
- create new files,
- retire files,
- remap category associations.

Outputs:
- structure decision matrix,
- dependency impact map,
- required human approvals for high-impact structural changes.

### Stage 3: Per-artifact update and verification

Purpose:
- apply content changes under the selected structure, then validate quality and adherence.

Outputs:
- file-level change set,
- validation pass report by dimension,
- post-change adherence and consumer impact report.

## Dimension model for context quality

Use D22 as one part of context quality, not the umbrella.

### Core context quality bundle

For context quality lifecycle runs, the default deep-pass bundle should include:

- D6 consistency,
- D7 non-redundancy,
- D8 prioritization,
- D9 clarity,
- D10 completeness,
- D11 actionability,
- D12 staleness,
- D13 source verification,
- D17 cross-coherence (context peer mode),
- D19 artifact-structure,
- D22 context optimization.

### Fast health bundle

For frequent and low-cost checks, run:

- D6,
- D7,
- D10,
- D12,
- D22.

Escalate to full context quality bundle when:

- external change digest is non-empty,
- Tier 2 screening finds relevance,
- internal modifications touch context guidance files.

## Integration blueprint for pe-meta

### New integration concept

Add a first-class workflow concept: context quality lifecycle.

This integrates existing use cases rather than replacing them.

- UC-16 remains optimization-specific (D22).
- UC-02, UC-03, UC-04, UC-05, UC-07, UC-10, UC-08 are orchestrated as one lifecycle path.

### Source intake modes

1. Default mode:
- use curated authoritative sources from PE-meta configuration.

2. User-augmented mode:
- include user-provided sources in the same run,
- apply identical trust and verification checks before any integration decision.

3. Fail-safe mode:
- if source validation fails, produce findings and recommendations only,
- do not apply autonomous integration.

### Proposed invocation behavior

1. Context lifecycle invocation:
- `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-quality-lifecycle`

2. Fast lifecycle invocation:
- `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-quality-health`

3. Full system update integration:
- `pe-meta-update` should call context lifecycle stage 1 and stage 2 before stage 3 when context is in scope.

### Tooling and wiring requirements

1. External verification path:
- every D12 and D13 deep pass must be routed through an execution path that has `fetch_webpage` access.

2. Prompt-agent contract:
- context review prompt must declare external capability requirements for freshness and source verification modes.
- validator and researcher responsibilities must be explicit and non-overlapping.

3. Scheduled review integrity:
- phases that reference external fetch must declare compatible tools in tool lists.

## Actionable implementation backlog

## ✅ Workstream A: Vision and use-case alignment updates (implemented)

- ✅ Updated `20260515.02-vision.v12.md` to elevate source-grounded staleness resolution as a top-priority goal.
  Completion note (2026-05-21): Updated goal and scope coverage to include autonomous investigation of authoritative and user-provided sources with source validation before integration.

- ✅ Updated `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/README.md`.
  Completion note (2026-05-21): Added UC-22 to phase and cross-type indexes and clarified UC-16 as optimization-scoped.

- ✅ Updated `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/16-context-optimization.md`.
  Completion note (2026-05-21): Added explicit boundary note stating that UC-16 does not replace full context quality lifecycle analysis.

- ✅ Created `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/22-context-quality-lifecycle.md`.
  Completion note (2026-05-21): Added lifecycle behavior, staged execution model, dimension coverage, and reliability/effectiveness/efficiency profile.

- ✅ Updated `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-staleness-verification.md`.
  Completion note (2026-05-21): Added lifecycle handoff outputs for stage-1 impact packets, stage-2 structure decision inputs, and integration gate signals.

## ✅ Workstream B: Prompt and agent orchestration (implemented)


- ✅ Update `.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md`.
  Completion note (2026-05-21): Added lifecycle mode dispatch, source-mode handling, stage-ordering constraints, and structured lifecycle outputs for `context-quality-lifecycle` and `context-quality-health`.

- ✅ Update `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md`.
  Completion note (2026-05-21): Clarified lifecycle ownership boundaries and added required structured outputs for stage 1, stage 2, and stage 3.

- ✅ Update `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md`.
  Completion note (2026-05-21): Added stage-0 source ledger contract with claim-to-source mapping and gate floor recommendation for downstream lifecycle stages.

- ✅ Update `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md`.
  Completion note (2026-05-21): Enforced context lifecycle stage ordering and integration-gate behavior in orchestration boundaries.

- ✅ Update `.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md`.
  Completion note (2026-05-21): Added missing external-fetch tool declaration and aligned scheduled review with lifecycle health behavior.

- ✅ Add explicit source-mode handling in lifecycle execution.
  Completion note (2026-05-21): Implemented authoritative-only, authoritative-plus-user-provided, and report-only gate behavior in lifecycle prompt and handoff contracts.

## ✅ Workstream C: Validation status and implementation evidence (implemented)

- ✅ Update implementation tracking docs under `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/`.
  Completion note (2026-05-21): Added lifecycle-specific tracking row in `02.00-validation-status.md` and completion mapping in `20260521-improvement-plan.md` linked to runbook outputs.

- ✅ Add a new validation status entry for context lifecycle orchestration.
  Completion note (2026-05-21): Created `02.38-validation-status-context-quality-lifecycle.md` with C-01 through C-05 checks (mode parsing, stage ordering, source ledger integrity, integration gate behavior, and tool/phase integrity).

- ✅ Add evidence outputs.
  Completion note (2026-05-21): Created lifecycle runbook and evidence pack under `02.38-validation-status-context-quality-lifecycle/` including source validation ledger, structure decision report, consumer impact report, and post-change adherence report.

## 📌 Things to be done next (execution priority)

1. Complete Workstream B prompt and agent updates first.
Reason: lifecycle behavior and source handling must exist before validation artifacts can be trustworthy.

2. Run targeted checks for stage ordering and tool alignment immediately after Workstream B edits.
Reason: this catches the highest-risk execution mismatches before broader rollout.

3. Execute quarterly lifecycle regression checks against Workstream B and C contracts.
Reason: prevent drift in stage ordering, source evidence handoff, and integration gate behavior.

## 📌 Things to be done after wiring (stabilization)

1. Build repeatable runbooks for mixed source sets.
Goal: prove consistent decisions in default and user-augmented source modes.

2. Add regression checks for prompt phase-to-tool integrity.
Goal: prevent future mismatch between declared tools and executable phases.

3. Update completion metadata after each implemented checkpoint.
Goal: keep status readable and auditable with date-stamped completion notes.

## Validation and evidence plan

For each lifecycle run, collect the following artifacts.

1. Stage-1 report:
- trigger source,
- impacted dimensions,
- impacted files and categories,
- risk profile.

2. Stage-2 structure decision matrix:
- decision type per affected area (split, merge, create, retire, remap, no-change),
- rationale and expected impact,
- required approvals.

3. Stage-3 execution report:
- changed files,
- dimension pass or fail results,
- unresolved findings with severity.

4. Post-change consumer report:
- affected consumers,
- adherence deltas,
- chain integrity confirmation.

5. Source validation ledger:
- source list by mode (default and user-provided),
- trust and relevance scoring,
- claim-to-source mappings,
- accept or reject integration decisions with rationale.

## Rollout plan

### Phase 1: Design and contract updates

Deliverables:
- use-case and README updates,
- lifecycle spec file,
- updated mode contracts in prompts and agents.

### Phase 2: Wiring and execution

Deliverables:
- context review lifecycle routing implemented,
- external verification path validated,
- scheduled-review tool mismatch resolved,
- source intake mode handling implemented.

### Phase 3: Reliability hardening

Deliverables:
- end-to-end runbooks with deterministic evidence,
- regression tests for stage ordering,
- repeated runs showing stable outcomes,
- repeated runs with mixed source sets (default plus user-provided) showing consistent decisions.

## Definition of done

The implementation is complete when all items below are true.

1. Functional completeness:
- context lifecycle mode exists and runs through all three stages.

2. Quality completeness:
- full bundle dimensions (D6, D7, D8, D9, D10, D11, D12, D13, D17, D19, D22) are supported in lifecycle mode.

3. Wiring integrity:
- D12 and D13 runs always use a tool-enabled external fetch path.

4. Stage-order enforcement:
- per-artifact updates cannot run before stage-2 structure decision in lifecycle mode.

5. Evidence quality:
- each lifecycle run produces stage reports and post-change consumer impact evidence.

6. Outcome quality:
- context updates show improved reliability, effectiveness, and efficiency against baseline validations.

7. Source-handling completeness:
- lifecycle mode supports authoritative and user-provided sources in one contract.

8. Source-validation integrity:
- every integrated change has claim-to-source evidence and trust classification.

9. Usability and flexibility:
- one-step invocation for default mode,
- optional user-provided source extension without workflow changes,
- report-only fallback available when confidence is low.

## References

- `06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/README.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/02-guidance-quality.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consistency-check.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/04-redundancy-check.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-staleness-verification.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/07-coverage-gaps.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/16-context-optimization.md`

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}

article_metadata:
  filename: "01-improvement-plan.md"
  created: "2026-05-21"
  last_updated: "2026-05-21"
  version: "1.2"
  status: "in_progress"
-->
