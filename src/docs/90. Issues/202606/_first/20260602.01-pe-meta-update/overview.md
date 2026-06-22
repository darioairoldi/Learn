---
title: "Issue Analysis: vision v15.1 contracts not fully propagated across pe-meta artifacts"
author: "Dario Airoldi"
date: "2026-06-02"
categories: [issue, analysis, prompt-engineering, vision, pe-meta]
description: "Three-layer coverage audit (vision v15.1 -> use-case catalog -> pe-meta artifacts) finding that the v15.1 Plan-mode output contract and Iteration-budget contract are implemented only in pe-meta-update, plus internal --mode and command-naming contradictions that break consistent invocation processing."
draft: true
---

# Issue Analysis — vision v15.1 contracts not fully propagated across pe-meta artifacts

**Issue Title:** vision v15.1 contracts (Plan-mode output, Iteration-budget) only partially implemented; `--mode` and command-naming contradictions break consistent processing

**Date Reported:** 2026-06-02
**Date Analyzed:** 2026-06-02
**Reporter:** Dario Airoldi
**Status:** Open (analysis complete; remediation not started)
**Severity:** High
**Component:** [06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)
**Framework:** PE artifact system v15.1

---

## Table of Contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief description

A three-layer coverage/gap audit was run to answer whether the pe-meta system **fully implements the recent vision updates (v15.1)**, **fully implements vision v15 overall**, and **uniformly supports the invocation paradigm and consistent processing**.

The audit traced each contract across three layers:

1. **Vision** — `20260531.01-vision.md` (v15.1.0, last updated 2026-06-02)
2. **Use-case catalog** — `20260503.02-vision-pe-meta-usecases/usecase-index.json` (v2.4.0, generated 2026-06-01)
3. **pe-meta artifacts** — prompts, agents, applicability matrix, parser tests, prompt-snippets

The answer to all three questions is **NO / partial**. The v15.1 changelog added two new cross-family contracts (Plan-mode output, Iteration-budget) but they are implemented in only one prompt; meanwhile the vision body and parser tests still carry pre-v15.1 statements that contradict the new contracts.

### Verdict summary

| Question | Verdict |
|---|---|
| Do they fully implement the **recent (v15.1)** updates? | **No** — only `pe-meta-update` implements the new plan-mode/iteration-budget contracts; no use case covers them. |
| Do they fully implement the **v15** vision overall? | **Mostly** — Phase 0a/0b, CF-05, metadata-first domain resolution, seven-parameter surface, derived breadth are widely implemented; naming/contradiction defects remain. |
| Do they support a **consistent invocation paradigm**? | **No** — three/four-way contradictions on `--mode` applicability and a `release-diff` vs `release-monitor` command-name split. |

### Impact

- **`command-family-agnostic` (P0) is violated** — a P0 vision principle requires cross-family uniformity, yet the v15.1 contracts live in a single command family (`update`).
- **Inconsistent invocation processing** — a run that follows the parser tests will reject the very `pe-meta-review --mode plan` invocations the use cases prescribe.
- **Vision self-contradiction** — the v15.1 Plan-mode contract depends on `/pe-meta-update --mode plan`, yet the vision body still states `--mode` is not applicable to Update.
- **Stale catalog** — the use-case index predates v15.1 by one day and has no anchor for the new contracts.

---

## 🔍 Context information

### Environment

| Item | Value |
|---|---|
| Repository | `Learn` |
| Vision file | `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` |
| Vision version | v15.1.0 (last_updated 2026-06-02) |
| Use-case index | `20260503.02-vision-pe-meta-usecases/usecase-index.json` (v2.4.0, generated 2026-06-01) |
| pe-meta prompts | `.github/prompts/00.09-pe-meta/` |
| pe-meta agents | `.github/agents/00.09-pe-meta/`, `.github/agents/00.01-pe-consolidated/` |

### v15.1 new contracts (from changelog)

| Contract | Requirement | Priority |
|---|---|---|
| **Plan-mode output contract** | Every `--mode plan` run emits an actionable plan at `<run-folder>/<NN>-<kebab-name>.plan.md` and records `plan-file=<path>` as a first-line marker. | P2 (relies on command-family-agnostic) |
| **Iteration budget** | Default cap of 10 autonomous changes/cycle; overflow recorded in `<run-folder>/<NN>-<kebab-name>-spillover.plan.md` with a `spillover=<path>` first-line marker (`none` when no overflow). | Cross-family (command-family-agnostic, P0) |

### Artifacts inspected

| Artifact | v15.1 status |
|---|---|
| `pe-meta-update.prompt.md` (v2.2.0) | ✅ Fully implements plan-file emission + spillover |
| `pe-meta-review.prompt.md` (v2.2.0) | ⚠️ Supports `--mode plan` but emits no plan file |
| Per-type `*-review` prompts (context/agent/instruction/hook/...) | ⚠️ Support `--mode plan` but emit no plan file |
| `pe-meta-adherence`, `pe-meta-release-monitor` | ⚠️ Support `--mode plan` but emit no plan file / spillover |
| `pe-meta-option-applicability-matrix.md` | ⚠️ `--mode` ✅ for Review (conflicts with parser tests) |
| `pe-meta-option-parser-tests.md` | ❌ R-01 treats `pe-meta-review` as read-only, rejects `--mode` |
| `usecase-index.json` (v2.4.0) | ❌ Predates v15.1; no plan-mode / iteration-budget use case |

---

## 🔬 Analysis

### Finding A — `--mode` support for `pe-meta-review` is a four-way contradiction

This is the primary "inconsistent processing" defect.

| Source | Says about `pe-meta-review --mode` |
|---|---|
| `pe-meta-review.prompt.md` | Default **apply**; `--mode plan` supported; **write tools active** |
| `pe-meta-option-applicability-matrix.md` | `--mode` ✅ for Review |
| Use cases (UC-29, UC-30, ...) | `/pe-meta-review --mode plan` is a first-class invocation |
| `pe-meta-option-parser-tests.md` R-01 | "`--mode` is **not supported** ... review is **read-only**" → reject |

The parser test encodes a pre-v15 "review is read-only" assumption; everything else treats `pe-meta-review` as apply-capable. **A run that honors the parser tests rejects valid use-case invocations.**

### Finding B — Vision body internally contradicts the v15.1 Plan-mode contract

- `20260531.01-vision.md` line ~1536: "`--mode` is **NOT applicable to Update**/Release-diff ... `apply` is their natural and only mode."
- `20260531.01-vision.md` line ~1546: repeats "Not applicable to ... Update".

These statements were not reconciled when v15.1 added the **Plan-mode output contract**, whose canonical command is `/pe-meta-update --mode plan`. The vision is therefore self-inconsistent after the v15.1 edit. **Highest-priority defect** because the vision is the top authority.

### Finding C — v15.1 contracts not propagated (command-family-agnostic violated)

The vision marks `command-family-agnostic` as **P0**, and the Plan-mode + Iteration-budget contracts are explicitly cross-family. But **only `pe-meta-update` implements them.** These commands support `--mode plan` (or write) yet emit **no plan file / no spillover**:

- per-type `*-review` prompts (`pe-meta-context-review`, `-agent-review`, `-instruction-review`, `-hook-review`, ...)
- `pe-meta-review` (orchestrator)
- `pe-meta-adherence`
- `pe-meta-release-monitor`

None reference `pe-meta-plan-file-contract.md` or `pe-meta-iteration-budget.md`. **Core "not fully implementing recent vision updates" finding.**

### Finding D — Use-case catalog staleness

- `usecase-index.json` is v2.4.0, `generated_at: 2026-06-01` — **one day before v15.1 (2026-06-02)**.
- **No use case covers** plan-file emission or iteration-budget/spillover. These cross-family reliability/human-handoff guarantees belong in `05-reliability/` alongside D28–D35, but no anchor exists.
- `00-overview.md` "Complete use-case list" omits `p0-02-autonomous-improvement-workflow` (exists in `03-consumer-correctness/`).

### Finding E — `release-diff` vs `release-monitor` naming split

- Vision line ~1478 names the command `pe-meta-release-diff`; the implemented command is `pe-meta-release-monitor`.
- UC-14 `primary_entry_point: /pe-meta-release-diff <url>` references the non-existent command.
- The matrix/parser-tests/prompt all use `release-monitor` and treat `release-diff` only as a compatibility alias.

### Impact assessment

| Finding | Layer | Severity | Effect |
|---|---|---|---|
| A | parser tests vs prompt/matrix/use cases | High | Valid invocations rejected; non-deterministic processing |
| B | vision body vs v15.1 contract | High | Top-authority document self-contradicts |
| C | prompts (cross-family) | High | P0 `command-family-agnostic` violated; contracts unenforced |
| D | use-case catalog | Medium | New contracts untested/uncovered; overview drift |
| E | vision + UC-14 | Medium | Command-name references resolve to nothing |

---

## 🔄 Reproduction steps

1. Open the vision changelog and confirm v15.1 (2026-06-02) added the **Plan-mode output contract** and rewrote **Iteration budget**.
2. Open `20260531.01-vision.md` ~lines 1536/1546 — observe "`--mode` not applicable to Update" (contradicts Finding B).
3. Open `20260531.01-vision.md` ~line 1478 — observe command named `pe-meta-release-diff` (Finding E).
4. Open `pe-meta-option-parser-tests.md` R-01 — observe `pe-meta-review --mode apply` is rejected as "read-only" (Finding A) while `pe-meta-review.prompt.md` and the applicability matrix mark `--mode` supported.
5. Grep the per-type `*-review`, `pe-meta-adherence`, `pe-meta-release-monitor` prompts for `pe-meta-plan-file-contract` / `pe-meta-iteration-budget` — observe no references (Finding C).
6. Open `usecase-index.json` — confirm `version: 2.4.0`, `generated_at: 2026-06-01`, and no plan-mode / iteration-budget use case (Finding D).

### Affected locations

| File | Location | Finding |
|---|---|---|
| `20260531.01-vision.md` | ~L1478, ~L1536, ~L1546 | B, E |
| `pe-meta-option-parser-tests.md` | R-01 | A |
| `pe-meta-option-applicability-matrix.md` | `--mode` row | A |
| `pe-meta-review.prompt.md` | frontmatter / mode table | A |
| Per-type `*-review`, `-adherence`, `-release-monitor` prompts | plan/spillover emission | C |
| `usecase-index.json` | version/header + missing UCs | D |
| `00-overview.md` | "Complete use-case list" | D |

---

## ✅ Solution implemented

No remediation has been applied yet — this issue captures analysis only.

### Recommended fixes (priority order)

| # | Fix | Authority note |
|---|---|---|
| 1 | Reconcile vision § Option taxonomy (L1536/L1546): `--mode plan` **is** applicable to Update (required by Plan-mode output contract). | Human-only edit (vision `boundaries: MUST NOT be modified by autonomous processes`) |
| 2 | Settle `pe-meta-release-diff` vs `pe-meta-release-monitor` on one canonical name in vision L1478 + UC-14. | Vision portion human-only |
| 3 | Fix parser test R-01: remove the stale "review is read-only" rule to match the apply-capable `pe-meta-review` contract. | pe-meta artifact |
| 4 | Propagate v15.1 contracts: add plan-file emission to every `--mode plan`-capable prompt and spillover to every writing family, per `command-family-agnostic` (P0). | pe-meta artifact |
| 5 | Regenerate `usecase-index.json` (v2.5) and add `05-reliability` anchors for plan-file emission + iteration-budget/spillover; fix `00-overview.md` list drift. | use-case catalog |

---

## 📚 Additional information

### Testing recommendations

- Add parser-test cases asserting `pe-meta-review --mode plan` is **accepted** and `--mode apply` resolves correctly.
- Add a cross-family conformance test: every `--mode plan`-capable command emits a `plan-file=` first-line marker.
- Add an iteration-budget test: a writing run exceeding 10 changes emits a `spillover=` marker and a spillover plan file.

### Migration considerations

- Vision edits (fixes #1, #2) require human approval and a version bump per frontmatter discipline.
- Regenerating the use-case index should be paired with the v15.1 vision so `generated_at` post-dates the vision.

---

## ✔️ Resolution status

**Current status:** Open — analysis complete, remediation not started.

### Verification checklist

- Vision § Option taxonomy reconciled with Plan-mode output contract (Finding B) (🟡 todo)
- `release-diff` / `release-monitor` naming unified in vision + UC-14 (Finding E) (🟡 todo)
- Parser test R-01 corrected for apply-capable `pe-meta-review` (Finding A) (🟡 todo)
- Plan-file emission added to all `--mode plan`-capable prompts (Finding C) (🟡 todo)
- Spillover emission added to all writing families (Finding C) (🟡 todo)
- `usecase-index.json` regenerated (v2.5) with new reliability use cases (Finding D) (🟡 todo)
- `00-overview.md` "Complete use-case list" drift fixed (Finding D) (🟡 todo)

### Follow-up actions

1. Prepare a human-review plan for vision edits (fixes #1, #2).
2. Open an implementation plan for cross-family contract propagation (fix #4).
3. Schedule use-case index regeneration after vision edits land (fix #5).

---

## 🎓 Lessons learned

### What went wrong

- A v15.1 changelog entry introduced new cross-family contracts without a propagation checklist, so they landed in one command family only.
- The vision body's older Option-taxonomy section was not reconciled with the new contract added in the same release.
- The use-case index was regenerated before the vision edit, leaving the catalog permanently behind the contract.

### What went right

- `pe-meta-update` is a complete, correct reference implementation of both v15.1 contracts — propagation has a working template to copy.
- Agent handoffs (`pe-con-*`, `pe-meta-*`) all resolve; the structural skeleton is sound.

### Improvements for the future

- When a vision change is tagged `command-family-agnostic` (P0), require a propagation matrix listing every affected command family before the change is considered done.
- Add a coherence check that fails when the parser tests and the applicability matrix disagree on any option/command pair.
- Gate use-case-index regeneration on `generated_at >= vision.last_updated`.

---

## 📎 Appendix

### A. Source authorities

| Artifact | Path |
|---|---|
| Vision (v15.1) | `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` |
| Use-case index (v2.4.0) | `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json` |
| Use-case overview | `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md` |
| Option applicability matrix | `.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md` |
| Option parser tests | `.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md` |
| pe-meta-update prompt (reference impl) | `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` |

### B. Finding-to-fix traceability

| Finding | Fix # | Verification item |
|---|---|---|
| A | 3 | Parser test R-01 corrected |
| B | 1 | Vision § Option taxonomy reconciled |
| C | 4 | Plan-file + spillover propagated cross-family |
| D | 5 | Use-case index regenerated; overview drift fixed |
| E | 2 | `release-diff`/`release-monitor` unified |
