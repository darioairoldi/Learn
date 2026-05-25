---
description: Status marking rules for plan files — suffix notation, section/item classification, and consistency enforcement
applyTo: '*plan*'
version: "1.0.0"
last_updated: "2026-05-24"
goal: "Single source of truth for plan marking format — referenced by documentation.instructions.md and plan-execution.instructions.md"
rationales:
  - "Marking rules were duplicated across two instruction files, causing drift and inconsistent enforcement"
  - "Point-of-action principle: models need format rules present where plan operations trigger"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# Plan Marking Rules

## Purpose

Defines HOW to mark status on plan items and sections. Complements `plan-execution.instructions.md` (WHEN/WHY to mark, validation discipline). Both fire on `*plan*` files — no conflict: execution rules govern behavior, this file governs format.

## Status Markers

| Marker | Suffix | Use |
|---|---|---|
| ✅ | `(✅ done)` | Implemented/completed, acceptance conditions met |
| 🟡 | `(🟡 todo)` | Pending, in progress, or awaiting conditions |
| 📌 | `(📌 next steps)` | Follow-up after current scope |

## Format Rules (CRITICAL)

- MUST use suffix-only notation: `Task text. (✅ done)`
- MUST NOT use checkbox syntax (`[x]` or `[ ]`) — convert ALL to suffix on first edit
- MUST NOT use prefix notation (`🟡 todo: Task text`)
- MUST NOT mix prefix and suffix on same line
- Completed items MUST include a short completion note when non-obvious
- Pending items SHOULD include `To do:` explanation
- Leading heading emojis are decorative ONLY — MUST NOT use status emojis (✅, 🟡, 📌) as heading prefix; use neutral emojis (📋, 🔎, 🧭, ⚙️, 🧪)

## Section Classification

Classify BEFORE marking. Not all content is actionable.

| Section type | Definition | Suffix rule |
|---|---|---|
| **Action** | Work to perform (deliverables, implementation steps, stabilization) | `(✅ done)` when done; `(🟡 todo)` when pending |
| **Analysis** | Analytical work whose documented content IS the deliverable | `(✅ done)` once analysis is written — documenting findings completes it |
| **Proposal** | Design decision awaiting implementation | `(🟡 todo)` until realized; `(✅ done)` after |

**Sections that do NOT get suffixes:** Goal/objective statements (`## 🎯 Objective`), purely informational tables, non-actionable structural headings.

## Item Classification

| Item type | Definition | Marker rule |
|---|---|---|
| **Actionable** | Task requiring work (create, update, add, remove) | MUST carry suffix |
| **Observation** | Factual statement (X supports Y, X appears in Y) | MUST NOT carry suffix |
| **Design-decision** | Proposal element describing how something should work | MUST carry suffix (pending until implemented) |

**Test:** If removing it means work won't get done → actionable. If it means a fact won't be recorded → observation.

## Consistency Rules

- Section suffix and contained list items MUST be status-consistent
- Section suffix and status-bearing paragraphs MUST be status-consistent
- When status changes, update BOTH section suffix and affected item suffixes in same edit
- Plain unmarked actionable bullets in plan sections are NOT allowed
- Plan TOCs MUST include "things to do" sections when such sections exist

## Exit Criteria Mapping

- `(🟡 todo)` while conditions are pending
- `(✅ done)` only after ALL conditions are met
- `(📌 next steps)` only for deferred post-exit follow-ups, not pending criteria
