---
title: "AN2 analysis: PE artifacts ranked for declarative restructuring"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [analysis, prompt-engineering, declarative-design, trigger-model, pe-artifacts]
description: "Ranked candidate list of process-heavy PE artifacts for declarative condition-driven restructuring and trigger-model coherence impact."
---

# AN2 analysis: PE artifacts ranked for declarative restructuring

## 📋 Table of contents

- [Scope and method](#scope-and-method)
- [Findings summary](#findings-summary)
- [Ranked candidate list (leverage x risk)](#ranked-candidate-list-leverage-x-risk)
- [Blast radius assessment for unified trigger model](#blast-radius-assessment-for-unified-trigger-model)
- [Reusable review mechanisms](#reusable-review-mechanisms)
- [Actionability check](#actionability-check)
- [Conclusion](#conclusion)
- [References](#references)

## 🎯 Scope and method

This analysis covers PE artifacts under `.github/` with focus on prompts, agents, skills, and instructions that are process-heavy and likely to benefit from declarative condition-driven restructuring.

## 🔎 Findings summary

- The ecosystem already has strong contracts (metadata, dimensions, applicability, risk routing).
- Highest token/process weight is concentrated in orchestration prompts and validator/researcher agents.
- Most artifacts are not conceptually wrong; they are operationally procedural and can be reframed around conditions and contracts.

## 📊 Ranked candidate list (leverage x risk)

| Rank | Artifact | Why candidate (process-heavy signal) | Leverage | Risk | Recommended first move (analysis-only) |
|---|---|---|---|---|---|
| 1 | `.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md` | Very high phase/step density, canonical orchestrator, broad option contracts | Very High | High | Extract phase exit-conditions per phase and keep procedural steps as fallback examples |
| 2 | `.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md` | Strong sequential workflow and checks; central for trigger-fired incremental runs | High | High | Reframe around trigger class + staleness conditions + gate conditions |
| 3 | `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md` | Multi-phase imperative audit flow with dense rule execution sequence | High | Medium-High | Convert phase progression to condition map (`structural-evidence-ready`, `dimension-coverage-complete`, etc.) |
| 4 | `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md` | Shape-dependent output and many procedural checks | High | Medium | Declare shape-selection and source-trust conditions as primary contract |
| 5 | `.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md` | Long extraction/discovery/verification pipeline and matrix generation flow | Medium-High | Medium | Define rule-extraction/adherence-completeness conditions before row-level procedures |
| 6 | `.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md` | Explicit step-by-step lifecycle with strong gating already | Medium-High | Medium | Keep gates, convert steps to lifecycle conditions and required outputs |
| 7 | `.github/agents/lh-observation-investigator.agent.md` | Stage-based process with many MUST workflow steps | Medium | Medium | Add condition contracts per stage and explicit stop criteria |
| 8 | `.github/agents/01.00-article-writing/documentation-validator.agent.md` | Procedural 7-dimension workflow, but already dimension-structured | Medium | Low-Medium | Promote per-dimension pass conditions as primary, keep phases as execution strategy |

## 🧭 Blast radius assessment for unified trigger model

| Surface | Impact of adopting unified taxonomy (`event/schedule/scoped-invocation`) | Blast radius |
|---|---|---|
| `pe-meta-review.prompt.md` and derivatives | Requires vocabulary alignment in resolved invocation, phase gating text, and docs | High |
| Scheduled review prompt | Needs explicit mapping from “scheduled” behavior to taxonomy class contract | Medium-High |
| Researcher/validator agents | Mostly terminology and contract harmonization; logic stays similar | Medium |
| Learning Hub investigate prompt/agent | Primarily framing/gating language alignment; low structural risk | Medium |
| Article-writing validator | Minimal direct trigger dependency | Low |

## 🔁 Reusable review mechanisms

Use these existing artifacts during execution planning (not rewrites yet):

- `pe-meta-review.prompt.md` as the canonical audit entry.
- `pe-meta-{type}-review.prompt.md` for type-scoped checks.
- `pe-meta-validator.agent.md` for dimension-evidenced validation.
- `documentation-validator.agent.md` for documentation quality checks on resulting notes/plans.

## ✅ Actionability check

Yes — AN2 is clear and actionable:

- Candidates are ranked by leverage and risk.
- Trigger-model blast radius is explicit.
- Existing reusable review paths are identified.

No rewrite scope is taken yet.

## 🏁 Conclusion

Yes, we have everything needed to proceed. The next execution step can start with high-leverage, medium-risk candidates (2–4) before touching the highest-risk orchestrator (rank 1), while keeping terminology coherence under the unified trigger model.

## 📚 References

- [PE meta review prompt](../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) 📒 [Internal]
- [PE meta scheduled review prompt](../../.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md) 📒 [Internal]
- [PE meta validator agent](../../.github/agents/00.09-pe-meta/pe-meta-validator.agent.md) 📒 [Internal]
- [PE meta researcher agent](../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) 📒 [Internal]
- [PE meta adherence prompt](../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md) 📒 [Internal]
- [LH investigate prompt](../../.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md) 📒 [Internal]
- [LH observation investigator agent](../../.github/agents/lh-observation-investigator.agent.md) 📒 [Internal]

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "06-an2-pe-artifacts-analysis-ranked-candidates.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "analysis"
-->
