---
title: "Issue analysis: PE-meta use cases are not prioritized by impact"
author: "Dario Airoldi"
date: "2026-05-21"
categories: [issue, prompt-engineering, prioritization]
description: "Analysis and prioritization of PE-meta use cases by relevance and impact, with emphasis on context effectiveness and source-grounded updates."
draft: true
---

# Issue analysis

**Issue title:** PE-meta use cases are not sorted by relevance and impact

**Date reported:** 2026-05-21  
**Reporter:** Dario Airoldi  
**Status:** Open  
**Severity:** High  
**Component:** PE-meta use-case portfolio and execution planning  
**Framework:** GitHub Copilot customization framework in VS Code

## Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution direction](#-solution-direction)
- [🧩 Test-case evaluation model](#-test-case-evaluation-model)
- [🗂️ Grouped test-case portfolio](#️-grouped-test-case-portfolio)
- [🔗 Consolidation and integration plan](#-consolidation-and-integration-plan)
- [➕ Additional test cases needed](#-additional-test-cases-needed)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

## 📝 Description

This issue concerns prioritization quality, not use-case availability. The PE-meta vision and companion use-case set are rich and technically coherent, but operational prioritization is not explicit enough for execution planning.

The current set mixes high-impact system-level use cases with lower-impact local or narrow checks without a clear default execution order for "what to do first" when cost or iteration budget is limited.

The most important concern raised in this conversation is correct: use cases related to overall effectiveness and context freshness are critical because they directly control Type B staleness risk (logic becoming obsolete while still structurally valid). By comparison, isolated single-context-file checks are useful, but lower priority unless a trigger specifically indicates local breakage.

## 🔍 Context information

| Item | Value |
|---|---|
| Issue folder | `src/docs/90. Issues/202605/20260521.01-pe-meta-use-casesnot-sorted-prioritized/` |
| Input signal | Request to prioritize PE-meta use cases by relevance and impact |
| Reference vision | `06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md` |
| Use-case set | `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/` |
| Primary concern | Over-indexing on local checks while system-level freshness and effectiveness carry higher impact |

### Relevant scope and boundaries from the vision

- Goal: maintain PE artifacts at peak reliability, effectiveness, and efficiency under risk-calibrated autonomy.
- Primary risk: silent capability/logic staleness (Type B), not only structural staleness.
- Required behavior: source-grounded staleness detection, validation, and integration.
- Assessment model: context-first and dependency-aware sequencing.

## 🔬 Analysis

### Root cause summary

The portfolio is organized by artifact type and dimensions, but not explicitly ranked by business and system risk impact. This causes tactical ambiguity in execution.

### Why this matters for generated prompt artifacts quality

When priorities are unclear, teams tend to execute what is easiest to validate rather than what protects generated prompt artifact quality the most. Deterministic local checks are cheaper and therefore attractive, but they do not mitigate Type B staleness or generated-output degradation on their own.

### Risk framing used for prioritization

This analysis ranks use cases by five weighted factors:

| Factor | Question |
|---|---|
| Staleness prevention | Does this use case reduce risk of obsolete guidance? |
| Blast radius | If this is weak, how many artifacts or workflows degrade? |
| Quality ceiling effect | Does this set the maximum achievable quality for downstream consumers? |
| Cost leverage | Does it improve many workflows per unit cost? |
| Recovery speed | How quickly does it expose and correct critical drift? |

### Key finding

System-level context quality lifecycle and release-driven impact detection should be in the top priority tier, together with dependency-aware full review and guidance quality dimensions. Single-file context checks belong to a secondary tier unless incident-specific triggers elevate them.

An additional quality lens is required: prioritize test cases by measurable impact on generated prompt artifact quality, not only by implementation convenience.

## 🔄 Reproduction steps

1. Open the vision document and note the explicit priority of Type B staleness and source-grounded autonomy.
2. Open the use-case README and observe the complete list across dimensions and artifact types.
3. Compare high-blast-radius use cases (`UC-22`, `UC-14`, `UC-12`, `UC-16`) with local checks (for example, isolated single-file structural review).
4. Observe there is no explicit default impact ranking used to guide execution under constrained budget.
5. Confirm that without ranking, low-cost local checks may be selected before high-impact lifecycle checks.

## ✅ Solution direction

### Fix overview

Introduce an explicit impact-priority model for PE-meta test-case execution. Keep all cases, but group, consolidate, and sort them by impact on generated prompt artifacts and system relevance.

### Policy proposal

- Tier P0 (critical): always run on broad triggers (platform, model, ecosystem).
- Tier P1 (high): run after P0, or immediately on moderate-risk triggers.
- Tier P2 (medium): run opportunistically or on scoped/local triggers.
- Tier P3 (low): run for deep audits, refactoring windows, or explicit requests.

### Minimal implementation

Add a machine-readable priority map consumed by orchestration prompts and agents, then enforce category-based execution order.

```yaml
priority_policy:
	p0:
		- UC-22  # context quality lifecycle
		- UC-14  # release impact
		- UC-12  # dependency-aware full review
		- UC-02  # guidance quality assessment
	p1:
		- UC-16  # context set optimization
		- UC-13  # vision alignment
		- UC-11  # adherence verification
		- UC-05  # staleness and source verification (scoped)
	p2:
		- UC-01  # structural validation
		- UC-06  # token budget analysis
		- UC-10  # prioritization review
		- UC-08  # artifact structure review
	p3:
		- UC-09  # craftsmanship review
		- UC-17  # reference efficiency
		- UC-18  # handoff efficiency
		- UC-19  # processing efficiency
```

## 🧩 Test-case evaluation model

### Scoring dimensions for generated prompt artifacts quality

| Dimension | Meaning | Weight |
|---|---|---|
| Output quality impact | Improvement or degradation risk for generated prompt artifacts | 0.30 |
| Drift prevention | Ability to prevent Type B staleness | 0.25 |
| Blast radius | Number of dependent artifacts and workflows affected | 0.20 |
| Relevance to vision v12 | Alignment with context-first, source-grounded lifecycle, and phased assessment | 0.15 |
| Cost efficiency | Expected quality return per execution cost | 0.10 |

$$
PriorityScore = 0.30\cdotOutputQuality + 0.25\cdotDriftPrevention + 0.20\cdotBlastRadius + 0.15\cdotVisionAlignment + 0.10\cdotCostEfficiency
$$

### Priority thresholds

| Tier | Score range | Execution rule |
|---|---|---|
| P0 | 4.2-5.0 | Mandatory for broad triggers |
| P1 | 3.6-4.19 | Mandatory after P0 or on scoped high-risk triggers |
| P2 | 2.8-3.59 | Conditional and opportunistic |
| P3 | 0.0-2.79 | Optional or campaign-based |

## 🗂️ Grouped test-case portfolio

### Category A: Source-grounded freshness and lifecycle

| Order | Priority | Test case | Portfolio role |
|---|---|---|---|
| 1 (run first) | P0 | UC-22 | Lifecycle orchestrator; strongest quality and staleness control for context evolution |
| 2 | P0 | UC-14 | External release impact detection feeding lifecycle updates |
| 3 | P1 | UC-05 | Scoped staleness and source verification for impacted areas |
| 4 | P1 | UC-16 | Set-level optimization after freshness and impact are established |

### Category B: Guidance correctness and quality gates

| Order | Priority | Test case | Portfolio role |
|---|---|---|---|
| 1 (run first) | P0 | UC-02 | Master quality gate for autonomy readiness |
| 2 | P1 | UC-03 | Contradiction elimination before optimization |
| 3 | P1 | UC-04 | Canonical source enforcement and duplication removal |
| 4 | P1 | UC-07 | Coverage-gap closure for missing guidance |
| 5 | P1 | UC-10 | Conflict precedence and rule ordering |
| 6 | P2 | UC-08 | Artifact structure and scope hardening |
| 7 | P2 | UC-13 | Vision alignment confirmation |

### Category C: Consumer implementation correctness

| Order | Priority | Test case | Portfolio role |
|---|---|---|---|
| 1 (run first) | P0 | UC-12 | End-to-end dependency-aware correctness baseline |
| 2 | P1 | UC-11 | Rule-to-implementation adherence matrix |
| 3 | P1 | UC-21 | Model-specific pattern quality for generated artifacts |

### Category D: Efficiency and operating economics

| Order | Priority | Test case | Portfolio role |
|---|---|---|---|
| 1 (run first) | P1 | UC-06 | Token-budget and chain-cost baseline |
| 2 | P1 | UC-20 | Correct task-to-model routing for cost and quality |
| 3 | P2 | UC-19 | Pipeline-level efficiency and early-exit behavior |
| 4 | P2 | UC-17 | Reference-load efficiency |
| 5 | P2 | UC-18 | Handoff and summarization efficiency |
| 6 | P2 | UC-15 | Deterministic-first phase optimization |
| 7 | P3 | UC-09 | Craftsmanship refinements |
| 8 | P3 | UC-01 | Structural hygiene verification |

### Group-level run rules (non-ambiguous)

| Group | First mandatory case | Escalation condition | Stop condition |
|---|---|---|---|
| Category A | UC-22 | If external change signal exists, force UC-14 next | Stop only when no unresolved P0/P1 findings remain |
| Category B | UC-02 | If quality gate fails, run UC-03 and UC-04 before others | Stop when all critical guidance defects are closed |
| Category C | UC-12 | If adherence gaps found, run UC-11 and then UC-21 | Stop when critical consumer mismatches are resolved |
| Category D | UC-06 | If token/model issues found, run UC-20 then UC-19 | Stop when efficiency defects are below threshold |

These rules make the plan actionable and non-ambiguous by defining first case, escalation, and explicit completion criteria for each group.

### Recommended default execution sequence

1. Category A P0 then P1
2. Category B P0 then P1
3. Category C P0 then P1
4. Category D P1 then P2

This sequence is intentionally not artifact-flat. It protects generated prompt artifact quality first, then operational efficiency.

## 🔗 Consolidation and integration plan

### Consolidation candidates

| Proposal | Current cases | Action | Rationale |
|---|---|---|---|
| Freshness bundle | UC-05, UC-14, UC-22 | Keep UC-22 as lifecycle orchestrator; treat UC-05 and UC-14 as feeder checks | Removes overlap while preserving specialized entry points |
| Guidance quality bundle | UC-02, UC-03, UC-04, UC-07, UC-10 | Keep UC-02 as umbrella; keep others as targeted drill-down profiles | Consolidates portfolio semantics without losing diagnostics |
| Consumer correctness bundle | UC-11, UC-12 | Keep both; make UC-12 mandatory when UC-11 finds partial/missing implementation | Makes adherence actionable through dependency-aware escalation |
| Efficiency bundle | UC-06, UC-15, UC-17, UC-18, UC-19, UC-20 | Keep all but group under one efficiency execution package | Avoids fragmented low-impact runs and improves execution clarity |

### Integration rules

| Rule | Decision |
|---|---|
| Broad triggers (platform/model/ecosystem) | Start with Freshness bundle and Guidance quality bundle |
| Generated artifact quality regressions | Escalate immediately to Consumer correctness bundle |
| Cost pressure only | Run Efficiency bundle without skipping prior unresolved P0 findings |
| Single-file incident | Allow targeted case execution, but require portfolio-level re-entry on recurrence |

## ➕ Additional test cases needed

The updated vision introduces lifecycle and governance expectations that are only partially covered by current cases. Add the following test cases.

| New case | Priority | Why needed | Complements |
|---|---|---|---|
| UC-23 Generated artifact quality regression | P0 | Validates output quality against golden prompts and expected outcomes after updates | UC-11, UC-21 |
| UC-24 Effectiveness verification loop | P0 | Measures whether updates improve real task success, not only structural conformance | UC-12, UC-22 |
| UC-25 Trigger wiring and observability reliability | P1 | Validates that scheduled and event triggers are active and complete | UC-14 |
| UC-26 Autonomy decision auditability | P1 | Verifies impact-confidence decisions are logged, explainable, and reproducible | UC-02, UC-12 |
| UC-27 Rollback and recovery drill | P1 | Ensures high-impact changes can be safely reverted with integrity | UC-22 |
| UC-28 Evidence provenance integrity | P1 | Confirms claim-to-source lineage remains valid through integration stages | UC-05, UC-22 |

These additions close the largest current gap: quality-of-output verification for generated prompt artifacts after self-update actions.

### Single-file vs. portfolio-level decision rule

| Scenario | Default route |
|---|---|
| Broad external change (platform/model/ecosystem) | Start with Category A and B P0 cases |
| Incident localized to one file | Start with scoped P1/P2 cases, then re-enter category sequence if repeated |
| Budget-constrained periodic review | Run all P0 cases, then highest-scoring P1 cases |
| Deep quality campaign | Run full category sequence plus additional test cases UC-23 to UC-28 |

## 📚 Additional information

### Severity rationale

Severity is High because this is a portfolio-governance issue that can systematically misallocate review budget away from the highest-risk failure mode.

### Recommended validation checks

- Add a "priority applied" check to PE-meta runbooks.
- Verify every broad-trigger execution starts from P0.
- Verify category sequencing is respected, not only flat tier ordering.
- Verify generated artifact quality checks run after critical updates.
- Record skipped tiers with reason and risk acceptance note.
- Track incidents by tier to calibrate rankings quarterly.

### Expected outcomes

- Faster detection of materially important drift.
- Better cost-to-impact ratio for each review cycle.
- Clearer operational decisions during constrained execution windows.

## ✔️ Resolution status

### Current status

- [x] Issue characterized from conversation and vision scope.
- [x] Prioritization logic proposed.
- [x] Initial tier matrix drafted.
- [ ] Priority policy integrated into PE-meta orchestration files.
- [ ] Runbooks updated to enforce tier-first execution.
- [ ] Evidence gathered from at least two scheduled cycles.

### Follow-up actions

- [ ] Add `priority_policy` section to relevant PE-meta prompts.
- [ ] Add `category_policy` section mapping use cases to bundles.
- [ ] Add execution logging for selected and skipped tiers.
- [ ] Define UC-23 to UC-28 specs and acceptance criteria.
- [ ] Add a monthly tuning step based on incident outcomes.

## 🎓 Lessons learned

- Completeness of use cases is not the same as actionable prioritization.
- Low-cost checks are useful, but they should not dominate critical-path execution.
- Context quality lifecycle should be treated as a first-class risk-control mechanism, not as a discretionary review path.
- Flat ranking is insufficient for quality governance; category-based portfolio sequencing is required.
- Generated prompt artifact quality must be directly tested, not inferred from structural correctness.

## 📎 Appendix

### Analyzed sources

- `06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/README.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-structural-validation.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/02-guidance-quality.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-staleness-verification.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/12-dependency-aware-review.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/14-release-impact.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/16-context-optimization.md`
- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/22-context-quality-lifecycle.md`

### Optional numeric scoring model

Use a weighted score to automate ranking per use case:

$$
PriorityScore = 0.35\cdotStaleness + 0.25\cdotBlastRadius + 0.20\cdotQualityCeiling + 0.10\cdotCostLeverage + 0.10\cdotRecoverySpeed
$$

Higher scores map to higher tiers.


