---
title: "PE-meta implementation improvement plan"
author: "Dario Airoldi"
date: "2026-05-21"
categories: [issue, prompt-engineering, copilot, implementation-plan]
description: "Actionable implementation plan for PE-meta changes after vision and use-case updates for source-grounded context quality lifecycle."
status: "executed"
version: "1.1.0"
---

# PE-meta implementation improvement plan

## ✅ Execution status

This implementation plan has been executed.

Completion date: 2026-05-21

Execution evidence:

- `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.00-validation-status.md`
- `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.38-validation-status-context-quality-lifecycle.md`
- `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-validation-summary.json`

Result summary:

- ✅ Workstream 1 complete
- ✅ Workstream 2 complete
- ✅ Workstream 3 complete
- ✅ Workstream 4 complete

## Scope

This plan covers implementation changes in PE-meta prompts, agents, and validation artifacts to support:

- autonomous investigation of authoritative and user-provided sources,
- source validation before integration,
- context quality lifecycle execution (not optimization-only),
- reliable, effective, and efficient autonomous updates with risk-calibrated gates.

Out of scope:

- additional vision changes,
- non-PE-meta artifact systems,
- deployment and publishing workflows.

## ✅ Inputs already completed

1. Vision updated:
- source-grounded staleness resolution elevated as top priority.

2. Use-case set updated:
- UC-16 boundary clarified (optimization only),
- UC-05 extended with lifecycle handoff outputs,
- UC-22 added for context quality lifecycle,
- use-case README updated to include UC-22.

## Target behavior for implementation

PE-meta context workflows must execute this sequence when context scope is selected:

1. Stage 0: source intake and validation
2. Stage 1: context-set impact assessment
3. Stage 2: structure decision
4. Stage 3: per-artifact update and verification

Stage-order rule:
- Stage 3 cannot execute before Stage 2 completes.

Integration gate outcomes:
- `apply-autonomously`
- `require-approval`
- `report-only`

## ✅ Implementation workstreams

## ✅ Workstream 1: Context review orchestration

Files:
- `.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md`

Changes:
1. Add new mode dispatch:
- `--dim context-quality-lifecycle`
- `--dim context-quality-health`

2. Add explicit lifecycle phases with contracts:
- stage inputs,
- stage outputs,
- fail-fast conditions,
- escalation gates.

3. Add source mode support:
- authoritative-default mode,
- user-augmented mode,
- report-only fallback.

Acceptance checks:
- mode parsing deterministic,
- stage ordering explicit,
- lifecycle runs produce stage artifacts.

Status: ✅ complete (2026-05-21)

Completion note:
- `pe-meta-context-review.prompt.md` now supports lifecycle and lifecycle-health dispatch, stage ordering, and source-mode handling with explicit output contracts.

## ✅ Workstream 2: Research and validation role contracts

Files:
- `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md`
- `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md`

Changes:
1. Researcher responsibilities:
- source discovery and ingestion,
- trust/relevance scoring,
- claim-to-source evidence ledger output.

2. Validator responsibilities:
- dimension checks for D6-D13, D17, D19, D22 in lifecycle mode,
- structure decision input synthesis,
- integration gate recommendation.

3. Non-overlap contract:
- researcher produces evidence,
- validator evaluates quality and integration readiness.

Acceptance checks:
- no responsibility ambiguity,
- structured handoff schema defined and referenced.

Status: ✅ complete (2026-05-21)

Completion note:
- `pe-meta-researcher.agent.md` now emits `stage_0_source_ledger` with claim-to-source mapping.
- `pe-meta-validator.agent.md` now defines stage 1/2/3 lifecycle outputs and ownership boundaries.

## ✅ Workstream 3: Full-update and scheduled-review alignment

Files:
- `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md`
- `.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md`

Changes:
1. `pe-meta-update`:
- call lifecycle stage order when context files are in scope,
- enforce integration gate routing before write steps.

2. `pe-meta-scheduled-review`:
- align tool declarations with external-source phases,
- include lifecycle health mode for recurring checks.

Acceptance checks:
- no phase references without required tools,
- scheduled run can produce lifecycle health findings.

Status: ✅ complete (2026-05-21)

Completion note:
- `pe-meta-update.prompt.md` now enforces stage 0 to stage 3 ordering and integration gate behavior.
- `pe-meta-scheduled-review.prompt.md` now includes tool alignment for external-source phases and lifecycle health behavior.

## ✅ Workstream 4: Validation and evidence system updates

Files:
- `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.00-validation-status.md`
- new status entry for lifecycle orchestration (same folder)
- supporting runbooks and evidence outputs in the same implementation folder

Changes:
1. Add lifecycle validation row(s):
- mode parsing,
- stage ordering,
- source validation ledger generation,
- integration gate correctness.

2. Add evidence artifacts:
- stage-1 impact packet,
- stage-2 structure decision matrix,
- stage-3 execution report,
- source validation ledger,
- post-change consumer impact report.

Acceptance checks:
- reproducible runbook execution,
- evidence paths stable,
- status rows map to concrete checks.

Status: ✅ complete (2026-05-21)

Completion note:
- Added lifecycle validation row in `02.00-validation-status.md`.
- Added lifecycle validation status file `02.38-validation-status-context-quality-lifecycle.md`.
- Added runbook and evidence outputs under `02.38-validation-status-context-quality-lifecycle/`.

## ✅ Delivery sequence

### ✅ Phase A: Contract-first updates

Deliver:
- ✅ prompt and agent contracts,
- ✅ handoff schema,
- ✅ lifecycle mode definitions.

### ✅ Phase B: Wiring and gating

Deliver:
- ✅ stage-order enforcement,
- ✅ source mode routing,
- ✅ integration gate routing.

### ✅ Phase C: Validation hardening

Deliver:
- ✅ status entries and runbooks,
- ✅ baseline and rerun evidence,
- ✅ regression checks for tool alignment and stage order.

## Risks and mitigations

1. Risk: source quality variance (especially user-provided links)
- Mitigation: trust scoring + claim-level evidence + report-only fallback.

2. Risk: over-integration from weak signals
- Mitigation: mandatory integration gate with confidence thresholds.

3. Risk: workflow complexity increases runtime
- Mitigation: health mode for frequent checks, deep lifecycle mode only on high-signal triggers.

4. Risk: tool declaration drift in prompts
- Mitigation: regression check that phase behavior and tool lists remain aligned.

## Definition of done

1. Lifecycle behavior available in context-review workflow with both lifecycle and health modes.
2. Source handling supports authoritative defaults and user-provided sources in one contract.
3. Every autonomous integration decision has claim-to-source evidence and trust classification.
4. Stage-order contract enforced (no Stage 3 before Stage 2).
5. Integration gate outcomes are deterministic and test-covered.
6. Validation status and runbook evidence are updated and reproducible.

## 🟡 Immediate next edits

Implemented on 2026-05-21:

1. ✅ Edited `pe-meta-context-review.prompt.md` to add lifecycle mode and stage contracts.
2. ✅ Edited `pe-meta-researcher.agent.md` and `pe-meta-validator.agent.md` for handoff schema and ownership boundaries.
3. ✅ Edited `pe-meta-update.prompt.md` and `pe-meta-scheduled-review.prompt.md` for alignment and tool integrity.
4. ✅ Added lifecycle validation status row and runbook evidence outputs.

Next operational action:

1. 🟡 Run quarterly lifecycle regression checks against stage ordering, source ledger integrity, and integration gate behavior.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}

article_metadata:
  filename: "02-pe-meta-improvement-plan.md"
  created: "2026-05-21"
  last_updated: "2026-05-21"
  version: "1.1"
  status: "executed"
-->
