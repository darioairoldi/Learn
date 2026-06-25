---
title: "Plan: consider token-optimization criteria for the PE vision"
author: "Dario Airoldi"
date: "2026-06-25"
status: "done"
domain: "prompt-engineering"
goal: "Decide whether the PE vision needs any amendment to absorb the olivomarco token-optimization criteria — the analysis finds the vision already enshrines efficiency as a co-equal goal, so only two marginal vision-only enrichments are candidates, both gated on human consent because vision edits are human-only"
---

# Plan: consider token-optimization criteria for the PE vision

> **Status: done.** Consent granted (option **a** — adopt both). Both vision-only enrichments were applied to [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) at **v15.11.0 (2026-06-25)**; the change is logged in [20260531.01-vision.changelog.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md). Vision edits are **human-only** (autonomy tier: Human-only); they were authored under Dario's explicit approval, not autonomously.

## 🎯 Goal

**Verbatim trigger:** "create a plan (01-vision-update-plan.md) to integrate relevant criteria into pe vision".

**Analysis finding (why this plan is marginal):** the vision at [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) already makes efficiency a co-equal goal ("peak reliability, effectiveness, and efficiency"; "consuming minimal tokens, attention, and effort") and already carries `instruction-minimization`, `minimal-canonical-surface`, `single-source-of-truth`, and `model-routing`. The article's structural philosophy **reinforces** these rather than adding new ones. Only two candidate enrichments remain, both `vision-only` (wording/rationale, no downstream artifact).

### Candidate amendment items

This table is the goal proposal (no status suffix); items move to an actionable body only after consent.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| 1 | Enrich an efficiency rationale: always-on context (`copilot-instructions.md`/`AGENTS.md`) carries a **recurring per-interaction and per-agent-step cost**, so minimization is a continuous economic constraint, not a one-time tidy-up | `[vision-only: no-downstream]` | preserves: `single-source-of-truth`, `deterministic-where-possible`; touches: `instruction-minimization` (P1 justification: clarifies the existing principle's economic basis without changing its requirement) | `landing: vision-only` (✅ applied to the `instruction-minimization` rationale cell, v15.11.0) |
| 2 | Add an explicit **non-goal**: the system prioritizes guidance **clarity over aggressive token compression** (caveman-speak / lossy abbreviation are rejected even when they cut tokens) | `[vision-only: no-downstream]` | preserves: `guidance-quality-by-construction`, `single-source-of-truth`; touches: none (states an existing boundary explicitly) | `landing: vision-only` (✅ applied to § What "self-updating" means — "It doesn't mean" list, v15.11.0) |

Neither item removes or weakens a principle; both are clarifications. No P0 principle is touched, so no version-bump consent line is required for a P0 change — but because the vision is human-only, item adoption itself still requires explicit confirmation (see § Open decisions).

## 🗳️ Open decisions

1. **Consent to amend the vision at all.** ✅ **Resolved — option (a) adopt both** (Dario approved 2026-06-25). Both items were applied to the vision at v15.11.0; plan 02 separately carries the operational guidance. No P0 principle was touched.

## 🅿️ Park lot

- Any new P0/P1 **principle** derived from the article (e.g., a standalone "efficiency-first" principle). → closed: efficiency is already a co-equal goal and is served by existing principles; a new principle would duplicate them.
- Operational token-optimization techniques (G1–G7). → `→ 02-prompt-engineering-update-plan.md` (these land in PE guidance, not the vision).

## 🔍 Discovery

- None. The decision is a human preference, not an execution-time fact.
