---
description: Rules for creating and processing plan files — ensuring goal clarity, step alignment, and pre-execution validation
applyTo: '*plan*'
version: "1.1.0"
last_updated: "2026-05-24"
goal: "Ensure plans are goal-driven, actionable, and validated before execution"
rationales:
  - "Plans without clear goals produce misaligned work"
  - "Ambiguous steps lead to incorrect or incomplete execution"
  - "Pre-execution validation catches misalignment before changes are made"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# Plan Execution Rules

## Purpose

Rules for **creating** plan files (structure/content) and **processing** them (pre-execution validation and execution discipline).

## Scope

These rules apply ONLY to plans **explicitly triggered by the interactive user** — e.g., when a user says "execute this plan", "process these steps", or invokes a plan file directly.

These rules MUST NOT be applied to:
- Internal todo lists created by agents to track their own work
- Plans generated and executed autonomously within predefined prompt workflows
- Lightweight task tracking used during agent-driven execution

**Rationale:** Pre-execution validation adds quality assurance for user-initiated plans but would create unnecessary overhead for agent-internal workflows where the agent already controls alignment.

## Plan Creation Rules

- MUST define a clear **goal/scope** and **motivation** before listing steps
- MUST ensure every step is specific, actionable, and unambiguous
- MUST ensure every step directly contributes to the stated goal
- NEVER include steps that are vague, aspirational, or lack clear completion criteria

## Pre-Execution Validation (MANDATORY)

Before processing any plan steps, ALWAYS perform these checks:

1. **Goal alignment** — verify each step contributes to achieving the plan's stated goal
2. **Actionability** — confirm every step is fully actionable (no ambiguity, no missing information)
3. **Information sufficiency** — verify that available information is sufficient to execute confidently
4. If ANY step is misaligned or ambiguous: **fix the plan FIRST**, then execute

## Execution Discipline

- MUST validate alignment and actionability BEFORE starting execution
- MUST mark steps as completed immediately after finishing each one
- MUST NOT skip validation to "save time"
- MUST NOT execute steps that cannot be verified against the goal
- MUST flag and resolve blockers rather than proceeding with uncertainty

## Completion Marking Format

All marking format rules (suffix notation, section classification, consistency enforcement) are defined in `plan-marking.instructions.md` — auto-loaded alongside this file for `*plan*` files.

📖 **Full rules:** `.github/instructions/plan-marking.instructions.md`

**Key points (reinforced here for point-of-action reliability):**

- MUST use suffix notation: `Task text. (✅ done)` — NEVER checkbox syntax `[x]`
- MUST NOT preserve existing `[ ]` checkbox patterns — convert to suffix on first edit
- MUST mark section headings too — classify as Action/Analysis/Proposal before marking
- Sections that do NOT get suffixes: goal statements, informational tables, structural headings
