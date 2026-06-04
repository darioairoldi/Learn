---
description: Rules for creating and processing plan files — lifecycle (draft/actionable/in-progress/done), actionability gate, park lot for surfaced edge cases, and on-save/on-ask triggering
applyTo: '*plan*'
version: "1.2.0"
last_updated: "2026-05-31"
domain: "prompt-engineering"
goal: "Ensure plans are goal-driven, actionable, scope-disciplined, and validated before execution"
rationales:
  - "Plans without clear goals produce misaligned work"
  - "Ambiguous steps lead to incorrect or incomplete execution"
  - "Pre-execution validation catches misalignment before changes are made"
  - "An explicit lifecycle prevents draft plans from being executed by accident"
  - "A park lot prevents edge cases surfaced during execution from silently inflating the active goal list"
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
- MUST declare `status:` in frontmatter, taking one of `draft | actionable | in-progress | done`
- MUST ensure every step is specific, actionable, and unambiguous
- MUST ensure every step directly contributes to the stated goal
- NEVER include steps that are vague, aspirational, or lack clear completion criteria

## Plan Lifecycle

Plans move through four states; transitions are gated.

| Status | Meaning | Allowed transitions |
|---|---|---|
| `draft` | Authoring in progress; goal and items may still change | → `actionable` (after passing the Actionability Gate) |
| `actionable` | Gate passed; ready to execute but not yet started | → `in-progress` (on first executed step) or back to `draft` (if a gate condition regresses) |
| `in-progress` | At least one item has been executed and marked done | → `done` (when all active items are completed and exit criteria met) |
| `done` | All active items completed; exit criteria satisfied | terminal — further changes require a new plan |

- A plan in `draft` MUST NOT have any of its items executed
- A plan in `done` MUST NOT have items added or removed — surface follow-ups via a sibling plan
- Status transitions MUST be reflected in the frontmatter `status:` field before the corresponding work begins

## Actionability Gate (MANDATORY)

Before transitioning a plan from `draft` to `actionable`, ALWAYS run these checks:

1. **Clarity** — every step is specific and unambiguous (no aspirational verbs without acceptance criteria)
2. **Non-ambiguity** — every step has exactly one reasonable interpretation
3. **Scope discipline** — no item exceeds the verbatim trigger; surfaced expansions live in § Park lot, not in the active list
4. **Coverage promise** — every in-scope goal item names a downstream landing (artifact path, sibling plan id, or `vision-only`)
5. **Principle impact** *(vision-amendment plans only)* — every item is tagged per `vision-amendment.instructions.md` against the target vision's `principles:` block, with P0 consent lines and P1 justification phrases populated where required

If any check fails: **fix the plan FIRST**, keep `status: draft`, then re-run the gate. NEVER execute a plan that has not passed the gate.

## Park Lot

Plans MUST contain a § Park lot section (may be empty) for edge cases surfaced during authoring or execution that are out of scope for the current plan.

- Items in § Park lot MUST NOT be executed as part of the current plan
- Each parked item MUST carry a one-line disposition: `→ <sibling-plan-id>.md` (will spawn a new plan), `→ defer` (revisit later, no commitment), or `→ closed: <reason>` (intentionally not pursued)
- Migrating an item from § Park lot into the active goal list MUST drop the plan back to `status: draft` and re-run the Actionability Gate

## Trigger

This file is auto-loaded for any file matching `*plan*`. The Actionability Gate runs:

- **On save** — whenever a plan file is modified and saved, the gate evaluates the current state and reports failures inline
- **On ask** — whenever a user asks the agent to execute a plan, the gate runs as the first action regardless of declared status

The gate does NOT auto-promote a plan from `draft` to `actionable` — promotion is an explicit author action.

## Execution Discipline

- MUST validate alignment and actionability BEFORE starting execution
- MUST mark steps as completed immediately after finishing each one
- MUST NOT skip validation to "save time"
- MUST NOT execute steps that cannot be verified against the goal
- MUST flag and resolve blockers rather than proceeding with uncertainty
- MUST route edge cases surfaced mid-execution to § Park lot rather than the active list

## Completion Marking Format

All marking format rules (suffix notation, section classification, consistency enforcement) are defined in `plan-marking.instructions.md` — auto-loaded alongside this file for `*plan*` files.

📖 **Full rules:** `.github/instructions/plan-marking.instructions.md`

**Key points (reinforced here for point-of-action reliability):**

- MUST use suffix notation: `Task text. (✅ done)` — NEVER checkbox syntax `[x]`
- MUST NOT preserve existing `[ ]` checkbox patterns — convert to suffix on first edit
- MUST mark section headings too — classify as Action/Analysis/Proposal before marking
- Sections that do NOT get suffixes: goal statements, informational tables, structural headings

## References

- **📘** `.github/instructions/plan-marking.instructions.md` — marking format authority
- **📘** `.github/instructions/vision-amendment.instructions.md` — narrower override of `*plan*` for vision-amendment plans (matches `*vision*plan*.md`); defines the per-item tagging consumed by Actionability Gate check #5
- **📘** `.github/instructions/vision-frontmatter.instructions.md` — declares the `principles:` block consumed by Actionability Gate check #5
- **📒** `src/docs/90. Issues/202605/20260525.03-staleness-review/05-vision-usecase-plan-rules/01-overview.md` — sub-issue analysis that motivated the lifecycle / park-lot additions in v1.2.0
