---
title: "Plan: improve the lh-investigate observation-to-integration workflow"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [plan, learning-hub, prompt-engineering, loop-engineering]
description: "Actionable plan to fold three workflow lessons — deduction-validation loop, dual integration modes, report-quality conditions — into the lh-investigate workflow."
publish: false  # internal working artifact — never published (engine-neutral intent honored by the publish pipeline)
status: done
goal: "Fold the three workflow lessons from the loop-engineering session — an explicit deduction-validation loop, a second (meta/architecture) integration mode, and explicit report-quality conditions — into the observation-to-integration workflow (authority context, prompt, and agent), so a single lh-investigate run reproduces this session end-to-end, including its correction points."
motivation: "This conversation was a manual run of the lh-investigate workflow. Comparing the two showed the workflow already covers roughly 90% of the reasoning but under-encodes three moves the session relied on. Capturing them turns hard-won corrections into repeatable conditions so the next run doesn't repeat the same mistakes."
---

# Plan: improve the lh-investigate observation-to-integration workflow

> **Status: done.** All four workstreams were executed on 2026-07-11 — the workflow authority, prompt, and agent were updated and version-bumped (2.2.0 / 2.1.0 / 2.2.0).

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

Generalize this session into the workflow that already models it. The [loop-engineering analysis](../overview.md) was a manual run of the observation-to-integration workflow; three reasoning moves it relied on are not yet encoded. This plan folds those three into the workflow authority, prompt, and agent so one `lh-investigate` invocation reproduces the session — including the points where the analysis had to be corrected.

## 🧭 Context and motivation

The session mapped cleanly onto the existing workflow's ten steps, with three under-encoded moves:

| Lesson | What the session did | Where it's under-encoded today |
|---|---|---|
| **G1 — deduction-validation loop** | Each load-bearing deduction was surfaced, challenged, and re-derived from evidence | Approval states + a validation appendix exist, but not an explicit challenge-and-re-derive loop |
| **G2 — two integration modes** | The output was an analysis report **plus a gated amendment plan** for visions and PE artifacts | Step 10 assumes tech-article, taxonomy-bound integration only |
| **G3 — report-quality conditions** | Even-handed comparison, inline provenance, vision-vs-implementation accuracy | Partly covered by article-writing rules and the evidence appendix; not explicit exit-conditions |

The primary edit target is the workflow authority (the single source of truth); the prompt and agent carry synced boundaries and defer to it. All three move together to avoid drift.

## 📋 Proposed changes

### WS1 — deduction-validation loop (G1) (✅ done)

- **WS1a-authority-loop** — In the workflow authority (`.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`), extend Step 6 (per-area analysis) and Step 9 (approval gate) with an explicit **deduction-validation loop**: surface each load-bearing deduction as a challengeable claim, and on a user correction treat it as a failing condition — re-derive from evidence and re-check before locking conclusions. (✅ done)
- **WS1b-artifact-boundaries** — Add a matching boundary to the agent (`.github/agents/lh-observation-investigator.agent.md`) and the prompt (`.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md`): "MUST surface load-bearing deductions for challenge and re-derive on correction before locking conclusions." (✅ done)
- **WS1c-checklist** — Add one quality-checklist line to the agent covering the loop. (✅ done)

### WS2 — two integration modes (G2) (✅ done)

- **WS2a-authority-modes** — In the authority Step 10, define two **derived** integration modes: (i) **tech-article integration** — the existing taxonomy-bound placement; and (ii) **meta/architecture amendment** — when the observation's value is architectural (it changes visions or PE artifacts, not reader-facing tech content), produce a gated recommended-plan that amends the affected artifacts under the `plan-execution` and `vision-amendment` rules, instead of placing a tech article. Mode is **detected, not asked**, consistent with the existing "placement is derived" principle. (✅ done)
- **WS2b-mode-detection** — Add detection criteria: a new tech topic → article mode; impact on `06.00-idea` visions or `.github` PE artifacts → amendment-plan mode; mixed impact → both. (✅ done)
- **WS2c-artifact-mirror** — Mirror the second mode in the prompt execution steps and the agent Stage C, noting that `integration_proposal` may resolve to a gated amendment plan. (✅ done)
- **WS2d-output-contract** — Extend the output and artifact contracts so the meta mode's deliverable is a gated `NN-*-plan.md` (report plus plan) — exactly the shape this session produced. (✅ done)

### WS3 — report-quality conditions (G3) (✅ done)

- **WS3a-authority-conditions** — Add three report-quality exit-conditions to the authority (Steps 6 and 8): **even-handed comparison** (frame as similarities / differences / strengths / weaknesses; avoid competitive "ahead/behind"); **inline provenance** (a source callout plus claim-to-source links); **vision-vs-implementation accuracy** (never classify an implementation-maturity gap as a design gap). (✅ done)
- **WS3b-artifact-boundaries** — Add matching terse boundaries to the prompt and agent, cross-referencing `article-writing.instructions.md` for general voice so nothing is duplicated. (✅ done)
- **WS3c-checklist** — Add checklist lines for the three conditions. (✅ done)

### WS4 — sync, versioning, coherence (✅ done)

- **WS4a-versions** — Bump each artifact per its own convention: the authority's `context_metadata` plus a Version history entry, the prompt's `prompt_metadata`, and the agent's `agent_metadata` — minor bumps (additive, non-breaking). (✅ done — authority 2.2.0, prompt 2.1.0, agent 2.2.0)
- **WS4b-coherence** — Run a cross-artifact coherence check (boundaries, steps, and contracts consistent across authority, prompt, and agent) using the `pe-artifact-coherence-check` skill; fix any drift. (✅ done — the three conditions and the two integration modes appear consistently in all three artifacts; output contracts match)

## ⚖️ Open decisions

None. Placement was resolved from the separation-of-concerns evidence: comparison-specific framing and the meta/architecture mode belong to the workflow authority; general writing voice stays in `article-writing.instructions.md` and is only cross-referenced. If execution surfaces a genuine choice, it moves here and the plan drops to `draft`.

## 🅿️ Park lot

- **PL1-fully-declarative-prompt** — Restructuring the prompt itself into the fully declarative "goal + exit-conditions" shape (from the overview's design section) is broader than this plan. → [01-recommended-plan.md](01-recommended-plan.md) (`AN2` / `C3`)
- **PL2-article-writing-tone-line** — Adding an even-handed-comparison line directly to `article-writing.instructions.md` (instead of cross-referencing) — revisit only if the workflow-local condition proves insufficient. → defer
- **PL3-scored-triage** — Making the session's implicit triage explicit and scored is a usage habit, not an artifact change. → closed: no artifact change needed

## 🔎 Discovery

- **DISC1-insertion-points** — Whether each condition extends an existing step or adds a sub-step is confirmed at execution against the current artifact text. *If a step already covers part of a condition →* extend it rather than duplicate.
- **DISC2-agent-changelog** — Whether the agent uses an inline metadata block or a sibling `*.changelog.md` is confirmed at execution. *If a sibling changelog exists →* add an entry there; *if absent →* update the inline `agent_metadata` only.

## 🏁 Exit criteria

Complete when all four workstreams are done and these conditions hold:

- The authority defines the deduction-validation loop, both integration modes, and the three report-quality conditions.
- The prompt and agent carry matching boundaries and checklist lines and defer to the authority.
- All three artifacts are version-bumped and pass a coherence check with no drift.
- **Acceptance test:** a mental re-run of this session against the updated workflow reproduces its outputs — an even-handed analysis report with provenance plus a gated amendment plan — including the trigger vision-vs-implementation correction.

## 📚 References

- [Loop-engineering analysis](../overview.md) — the session this plan generalizes; see its "A design implication: declarative prompts" section.
- [Recommended plan](01-recommended-plan.md) — sibling plan; `AN2` is the broader declarative-restructuring track.
- `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md` — the workflow authority (primary edit target).
- `.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md` — the prompt.
- `.github/agents/lh-observation-investigator.agent.md` — the agent.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "02-improve-lh-investigate-plan.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "plan"
  plan_status: "done"
-->
