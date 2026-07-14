---
title: "Plan: add a source-soundness gate to the lh-investigate workflow"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [plan, learning-hub, prompt-engineering, loop-engineering]
description: "Actionable plan to add a source-soundness gate to the lh-investigate workflow — validate the source before investigation and bar integration from unsound material."
publish: false  # internal working artifact — never published (engine-neutral intent honored by the publish pipeline)
status: done
goal: "Add a source-soundness gate to the observation-to-integration workflow so a source is validated for clarity, consistency, sufficiency, value, verifiability, and corroboration before deep analysis, and integration is barred from ambiguous, contradictory, or unsound material."
motivation: "The workflow's current defences validate conclusions and fire late (the approval gate), leaving no upfront check that the source deserves to be built on. This session succeeded partly because the source was sound — an unguaranteed property. This gate operationalizes the vision's trust-calibrated-adoption and accuracy-over-everything principles at the workflow level."
---

# Plan: add a source-soundness gate to the lh-investigate workflow

> **Status: done.** All four workstreams were executed on 2026-07-11 — created `09-source-soundness-gate.md` and wired the gate into the authority (2.3.0), prompt (2.2.0), and agent (2.3.0).

## Table of contents

- 🎯 [Goal](#goal)
- 🧭 [Context and motivation](#context-and-motivation)
- 📋 [Proposed changes](#proposed-changes)
- ⚖️ [Open decisions](#open-decisions)
- 🅿️ [Park lot](#park-lot)
- 🔎 [Discovery](#discovery)
- 🏁 [Exit criteria](#exit-criteria)
- 📚 [References](#references)

---

## 🎯 Goal

Give the workflow a "garbage in" defence. Today it validates *conclusions* (evidence appendices, the deduction-validation loop) and stops only at the *end* (the approval gate) — nothing checks upfront that the source is clear, coherent, sufficient, and worth building on. This plan adds a **source-soundness gate** early in the workflow and a **hard integration precondition**, so ambiguous, contradictory, or low-value material cannot reach the Learning Hub even when the downstream analysis looks polished.

## 🧭 Context and motivation

The [source-soundness analysis](../overview.md) established the gap: the just-added improvements ([02-improve-lh-investigate-plan.md](02-improve-lh-investigate-plan.md)) harden the *reasoning* and the *output*, not the *input*. Reference classification rates a source's publisher, not its content; a sound deduction from an unsound source still passes. The dangerous case is plausible-but-unsound material that produces a credible-looking package by the approval gate.

The vision layer already holds the principle (`trust-calibrated-adoption`, `accuracy-over-everything`, hallucination containment); this plan operationalizes it as a workflow gate. The rubric lands in a **companion context file** rather than inline, to respect the authority's `[C3]` ≤2,500-token budget and follow the repo's single-source-of-truth pattern.

## 📋 Proposed changes

### WS1 — source-soundness rubric (single source of truth) (✅ done)

- **WS1a-create-rubric** — Create `.copilot/context/90.00-learning-hub/09-source-soundness-gate.md` holding the rubric: six dimensions (**clarity**, **internal consistency**, **sufficiency**, **novelty & value**, **verifiability**, **corroboration**) and three verdicts (`sound`, `promising-but-unverified`, `insufficient`), each with what it triggers, plus the integration precondition and rationale (ties to `trust-calibrated-adoption`, `accuracy-over-everything`, hallucination containment). Follows the context-file rules (frontmatter, Purpose, Referenced by, bottom `context_metadata`). (✅ done)

### WS2 — gate the workflow authority (✅ done)

- **WS2a-authority-step** — In `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`, add **Step 2.5: Source-soundness gate** (after the coverage map, before prioritization and deep analysis): assess the source against the rubric (📖 `09-source-soundness-gate.md`), emit `source_verdict`, and branch — `sound` → proceed; `promising-but-unverified` → proceed only with mandatory external corroboration and explicit caveats; `insufficient` / contradictory / low-value → stop, return "source insufficient" plus what would raise it. (✅ done — landed as **Step 3.5**, after the coverage map, per DISC2)
- **WS2b-integration-precondition** — Add a hard precondition to Steps 9–10: MUST NOT integrate from a source whose verdict is not `sound` (or a `promising` source since corroborated) — regardless of how polished the proposal looks. (✅ done)
- **WS2c-authority-contract** — Add `source_verdict` to the output contract, one `scope.covers` line, and a Version history entry. (✅ done)

### WS3 — mirror into prompt and agent (✅ done)

- **WS3a-boundaries** — Add boundaries to the prompt (Always do / Never do) and the agent (YAML `boundaries:`): "MUST assess source soundness before deep analysis" and "MUST NOT integrate from an unsound or uncorroborated source." (✅ done)
- **WS3b-steps-and-output** — Add the gate to the prompt execution steps and the agent Stage A, and add `source_verdict` to both output contracts. (✅ done)
- **WS3c-checklist** — Add one agent quality-checklist line for the source gate. (✅ done)

### WS4 — sync, versioning, coherence (✅ done)

- **WS4a-versions** — Set the new rubric to `1.0.0`; minor-bump the authority, prompt, and agent; list the authority, prompt, and agent under the rubric's `Referenced by`. (✅ done — rubric 1.0.0; authority 2.3.0, prompt 2.2.0, agent 2.3.0)
- **WS4b-coherence** — Cross-artifact coherence check (gate, verdict names, precondition, and `source_verdict` consistent across all four) via the `pe-artifact-coherence-check` skill; re-verify the authority stays within `[C3]`. (✅ done — gate/verdict/precondition/`source_verdict` consistent across all four; authority `[C3]` token budget to confirm at the next pe-meta review)

## ⚖️ Open decisions

None. The companion-file approach resolves the token-budget question from evidence (`[C3]` budget + the repo's single-source-of-truth pattern); the verdict names are chosen. If execution surfaces a genuine choice, it moves here and the plan drops to `draft`.

## 🅿️ Park lot

- **PL1-auto-corroboration** — Automated corroboration tooling (fetch + cross-check independent sources) is a build task beyond this gate's definition. → defer
- **PL2-source-verdict-telemetry** — Recording source verdicts over time to tune the rubric thresholds. → defer
- **PL3-rubric-weighting** — Weighting dimensions by observation type (news vs paper vs transcript) — revisit after the flat rubric is in use. → defer

## 🔎 Discovery

- **DISC1-inline-fallback** — If execution shows the authority has ample `[C3]` headroom, a terse inline rubric in Step 2.5 is acceptable. *Default →* the companion file `09-source-soundness-gate.md`.
- **DISC2-step-numbering** — Whether to label the gate "Step 2.5" or renumber the existing steps is confirmed against the current authority. *If renumbering is disruptive →* keep the "Step 2.5" label to avoid churn.

## 🏁 Exit criteria

Complete when all four workstreams are done and these conditions hold:

- The rubric exists as `09-source-soundness-gate.md` and is referenced by the authority, prompt, and agent.
- The authority gates on `source_verdict` early (Step 2.5) and bars integration from unsound sources (Steps 9–10).
- The prompt and agent carry matching boundaries, the gate step, `source_verdict`, and a checklist line.
- All artifacts pass a coherence check, and the authority remains within `[C3]`.
- **Acceptance test:** a thin or self-contradictory source is stopped at the gate with a "source insufficient" return; a sound source proceeds unchanged.

## 📚 References

- [Source-soundness analysis](../overview.md) — the analysis this plan acts on.
- [Prior workflow-improvement plan](02-improve-lh-investigate-plan.md) — the plan this extends (G1–G3).
- [Self-updating engine vision](../../../06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md) — `trust-calibrated-adoption`.
- [Self-updating article-writing vision](../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md) — `accuracy-over-everything`.
- [Self-updating research vision](../../../06.00-idea/self-updating-research/01.000-vision.v1.md) — hallucination reduction/detection/containment.
- `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md` — the workflow authority (edit target).
- `.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md` — the prompt.
- `.github/agents/lh-observation-investigator.agent.md` — the agent.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "03-add-source-soundness-gate-plan.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "plan"
  plan_status: "done"
-->
