---
title: "Scope next: trigger implementation and coherence"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [scope, trigger-model, loop-engineering, self-updating-engine, learning-hub]
description: "Scope note for ingestion trigger wiring and a unified trigger taxonomy across Learning Hub, self-updating engine, and research visions."
publish: false  # internal working artifact — never published (engine-neutral intent honored by the publish pipeline)
---

# Scope next: trigger implementation and coherence

This note executes the two scoped actions from the loop-engineering plan:

- **C1**: scope the ingestion loop wiring for creation triggers.
- **C2**: unify trigger vocabulary into one engine-layer taxonomy.

## 📋 Table of contents

- [Scope and intent](#scope-and-intent)
- [C1 — Scope for wiring the ingestion loop](#c1-scope-for-wiring-the-ingestion-loop)
- [C2 — Unified trigger model (engine-layer taxonomy)](#c2-unified-trigger-model-engine-layer-taxonomy)
- [Exit conditions for this scope note](#exit-conditions-for-this-scope-note)
- [Conclusion](#conclusion)
- [References](#references)

<a id="scope-and-intent"></a>
## 🎯 Scope and intent

The goal is to close the gap between trigger design and trigger implementation without writing runtime code yet. This document defines the operating contract: what fires, what gets drafted, where humans approve, and how creation-triggered work uses the same autonomy gradient already used for maintenance-triggered work.

<a id="c1-scope-for-wiring-the-ingestion-loop"></a>
## ⚙️ C1 — Scope for wiring the ingestion loop

### Trigger inputs (what fires creation work)

Creation/ingestion triggers are grouped into three source classes:

1. **Feed deltas** (RSS/Atom/newsletter/source monitors): new or substantially updated items in monitored sources.
2. **Conference pipeline signals**: discovered sessions, published transcripts, or new event assets entering the conference ingestion flow.
3. **Scheduled dispatch windows**: time-based triage/synthesis windows that run even without explicit external events.

### Draft outputs (what each trigger creates)

Each trigger creates a draft artifact set, never direct publish:

- **Feed delta** → draft triage entry + draft analysis candidate + optional draft plan item.
- **Conference signal** → draft session package (summary, key points, integration candidates, linkage stubs).
- **Scheduled dispatch** → draft backlog update + ranked proposed tasks + draft integration recommendations.

### Human gate location

The mandatory human gate sits between **Propose** and **Execute publish/integration**:

- Autonomous creation is allowed up to draft/proposal artifacts.
- Publication, canonical-structure rewrites, and cross-domain governance changes require approval.

This uses the existing observation-investigator pattern as the seed: triage and proposal can run autonomously; integration edits remain approval-gated.

### Autonomy-gradient behavior for creation triggers

Creation-triggered work follows the same risk-calibrated autonomy logic as maintenance work:

- **Low-risk**: draft generation, metadata enrichment, candidate ranking → autonomous.
- **Medium-risk**: additive, scoped integration proposals with clear evidence → autonomous with notification.
- **High-risk**: scope shifts, structural rewrites, governance-impacting changes → human approval required.
- **Strategic**: vision/principle changes → human-only.

The key rule is unchanged: trigger type does not set permission; assessed impact × confidence sets permission.

<a id="c2-unified-trigger-model-engine-layer-taxonomy"></a>
## 🧭 C2 — Unified trigger model (engine-layer taxonomy)

The three vision surfaces currently describe trigger behavior with overlapping language. A shared taxonomy in the engine layer removes drift.

### Canonical trigger taxonomy

1. **Event triggers** — external or internal events (platform, model, ecosystem, file/change events).
2. **Schedule triggers** — time-based execution windows (daily/weekly/periodic checks, scheduled reviews).
3. **Scoped invocation triggers** — user or workflow-invoked bounded requests (manual, bounded-delta, targeted scopes).

### Trigger contract fields (for every trigger)

Every trigger instance should declare:

- `trigger_id`
- `trigger_class` (`event` | `schedule` | `scoped-invocation`)
- `signal_source`
- `window` (full, incremental, bounded-delta)
- `intended_outputs` (draft/proposal/apply classes)
- `risk_baseline` (starting autonomy posture before evidence refinement)

### Mapping to current visions

- **Learning Hub "Automated Prompts"** maps to `schedule` + `scoped-invocation`.
- **Engine scheduled + runtime-hook model** maps to `schedule` + `event`.
- **Research scheduled automation** maps primarily to `schedule`, with `event` escalation when freshness/coverage signals cross thresholds.

Result: one taxonomy, many domain instantiations.

<a id="exit-conditions-for-this-scope-note"></a>
## ✅ Exit conditions for this scope note

This scope/design action is complete when:

- Trigger classes and draft outputs are explicit.
- Human gate placement is explicit.
- Creation-trigger autonomy routing is explicit.
- The unified taxonomy and mapping are explicit.

Implementation remains deferred to downstream execution plans.

<a id="conclusion"></a>
## 🏁 Conclusion

The scope is now explicit and consistent with the current architecture direction: creation triggers are wired as draft-first flows, human approval remains the governance boundary for high-impact integration, and trigger language is normalized into one engine-layer taxonomy that each domain can instantiate without redefining core semantics.

<a id="references"></a>
## 📚 References

- [Learning Hub concept](../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) 📒 [Internal]  
Source for automated prompts framing and scheduled prompt workflows.
- [Automated content lifecycle with prompts, agents, and MCP](../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) 📒 [Internal]  
Source for conference ingestion pipeline and lifecycle layering.
- [Self-updating engine: vision and rationale (v1.0)](../../../06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md) 📒 [Internal]  
Source for trigger evidence, autonomy gradient, and Detect/Assess/Propose/Execute contract.
- [Vision: future improvements and deferred infrastructure](../../../06.00-idea/self-updating-research/01.001-vision-further-improvements.md) 📒 [Internal]  
Source for research scheduled automation framing.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "04-scope-trigger-implementation-and-coherence.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "scope-note"
-->
