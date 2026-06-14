---
# Quarto Metadata
title: "Issue: pe-meta-update `--mode apply` skips on-disk plan materialization"
author: "Dario Airoldi"
date: "2026-06-06"
categories: [issue, prompt-engineering, pe-meta, vision-compliance]
description: "The pe-meta-update orchestrator executed `--mode apply` without materializing the canonical plan file on disk, violating vision v15.4.0 § Plan output contract. Recurring defect; root cause and fix documented."
draft: false
---

# Issue Report

**Issue Title:** `pe-meta-update --mode apply` executes without materializing the on-disk plan file (vision v15.4 § Plan output contract violation)

**Date Reported:** 2026-06-06
**Reporter:** Dario Airoldi
**Status:** Resolved

| Field | Value |
|---|---|
| **Severity** | High |
| **Component** | `pe-meta-update.prompt.md` (PE meta-orchestrator) |
| **Framework** | GitHub Copilot customization (VS Code) — PE vision v15.4.0 |
| **Affected artifacts** | `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` |
| **Run IDs affected** | `full-apply-20260606`, `agents-apply-20260606` |

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Implemented](#-solution-implemented)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief Description

A `/pe-meta-update '.github\agents\00.09-pe-meta' --mode apply` invocation ran the full 9-phase pipeline (parse → domain-coherence gate → audit → approval → apply → regression → report) and **applied real edits to five agent files**, but **never materialized the canonical plan file on disk**. The "plan" existed only as an in-conversation Phase 5 approval message, and the Phase 8 first-line log recorded `plan-file=none`.

### Why It Matters

Vision v15.4.0 § Plan output contract defines `apply = plan + execute` and states that **a plan file is the single pivot artifact every mutating run passes through** — plan emission is **non-skippable** on every mutating run. A chat-only findings report disappears with the conversation; the on-disk plan is what makes a run reviewable later, version-controlled, and promotable through the same actionability gate that governs human-authored plans.

### Symptom Summary

| Symptom | Observed | Expected (vision v15.4) |
|---|---|---|
| Plan artifact | In-conversation message only | On-disk file at `<run-folder>/<NN>-<kebab-name>.plan.md` |
| First-line marker | `plan-file=none` | `plan-file=<path>` |
| Execution source | Re-derived intent in chat | Read from the written plan (plan→execute seam) |

---

## 🔍 Context Information

### Environment

| Item | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| OS / shell | Windows / PowerShell |
| Orchestrator version (at fault) | `pe-meta-update.prompt.md` v2.3.0 |
| Governing vision | v15.4.0 — `20260531.01-vision.md` § Plan output contract |
| Contract snippet | `.github/prompt-snippets/pe-meta-plan-file-contract.md` |
| Plan-format rules | `.github/instructions/plan-execution.instructions.md` v1.2.0 |

### Triggering Invocation

```text
/pe-meta-update '.github\agents\00.09-pe-meta' --mode apply
```

Derived: `breadth=full`, `caller=manual`, execution mode **fresh** (no baseline, research ran).

### The Vision Rule Being Violated

> **`--mode apply`** = materialize plan, **then execute it through the same execution engine** (`apply = plan + execute`). Plan emission is non-skippable on every mutating run; `--skip plan-emission` is REJECTED with CF-05.
> *(— `pe-meta-plan-file-contract.md` § Plan output contract)*

The **fresh** execution-mode row is explicit: *"Generate plan from research → **write** → execute."* The run skipped the **write**.

---

## 🔬 Analysis

### Root Cause

A **D6-consistency defect inside the orchestrator prompt itself**. The prompt's `--mode` table and frontmatter both claim apply *"Materializes the plan on every run,"* but the **Phase 6 execution body wired plan-file emission into the `--mode plan` branch only**:

```text
Phase 6:
  if --mode plan:
      ...emit actionable plan file at canonical path...   ← plan emission lived ONLY here
  Rollback Snapshots
  Apply                                                    ← apply branch wrote
                                                             phase-5-changelist.md +
                                                             rollback snapshots, but NOT
                                                             the canonical plan file
```

So when `--mode apply` ran, it produced the internal `phase-5-changelist.md` and rollback snapshots but **never the run-folder plan file**. The prompt's prose and its phase logic disagreed — the classic signature of a consistency defect.

### Impact Assessment

| Dimension | Impact |
|---|---|
| Auditability | High — no durable, reviewable record of what the run intended |
| Vision compliance | High — direct violation of a load-bearing v15.4 contract |
| Reproducibility | Medium — execution re-derived intent in chat rather than from a pinned plan |
| Data loss risk | Low — edits themselves were correct and validated |

### Recurrence Evidence (this is systemic, not a one-off)

The meta-review log shows **two consecutive apply runs** with the identical gap:

| Run ID | Date | Plan file at run time | Disposition |
|---|---|---|---|
| `full-apply-20260606` | 2026-06-06 | `none` | back-filled retroactively |
| `agents-apply-20260606` | 2026-06-06 | `none` | back-filled + root cause fixed |

Two in a row → the prompt was systematically skipping the step, confirming a prompt-level defect rather than an execution slip.

---

## 🔄 Reproduction Steps

1. Invoke the orchestrator in apply mode on any multi-file scope:
   ```text
   /pe-meta-update '.github\agents\00.09-pe-meta' --mode apply
   ```
2. Let the pipeline run through Phase 5 (approval) and Phase 6 (apply).
3. Inspect the run folder (e.g. `src/docs/90. Issues/202606/20260606.01-pe-meta-update/`) for a `*.plan.md` file.
4. **Observed (pre-fix):** no plan file exists; the Phase 8 first-line log ends `plan-file=none`.
5. **Expected:** a plan file at `<run-folder>/<NN>-<kebab-name>.plan.md` and `plan-file=<path>` in the log.

### Affected Code Locations

| File | Location | Defect |
|---|---|---|
| `pe-meta-update.prompt.md` | Phase 6 body | Plan emission gated to `--mode plan` branch only |
| `pe-meta-update.prompt.md` | Phase 8 first-line-log note | Stated `plan-file` emitted "whenever `--mode=plan`" |
| `pe-meta-update.prompt.md` | Test scenario 1 | Did not assert `plan-file=<path>` for apply happy-path |

---

## ✅ Solution Implemented

### Fix Overview

Two-part remediation: a **per-run back-fill** (restore the missing artifact) and a **systemic prompt fix** (prevent recurrence).

### 1. Systemic prompt fix — `pe-meta-update.prompt.md` v2.3.0 → v2.3.1

Hoisted plan materialization out of the mode-specific branch into a new, non-skippable Phase 6 sub-step that runs **before** Rollback/Apply for **both** modes:

```markdown
### Plan materialization (every mutating run — NEVER skippable)

Both `--mode plan` and `--mode apply` MUST materialize the actionable plan file
BEFORE any source-artifact write. ...
1. Resolve the path via the contract's path-resolution algorithm ...
2. Write the plan from the Phase 5 changelist using create_file ...
3. Record plan-file=<path> for Phase 8 (NEVER `none` on a mutating run).

If --mode plan:  After writing the plan, STOP (PLANNED — not applied).
If --mode apply: After writing the plan, execute it through the steps below
                 (the plan→execute seam: a cheaper executor applies the plan's
                 edits, it does not re-reason intent).
```

Supporting edits in the same version:
- Corrected the Phase 8 first-line-log note: `plan-file` is emitted on **every** mutating run, not only `--mode=plan`.
- Updated test scenario 1 to assert `plan-file=<path>` (not `none`) on the apply happy path.
- Bumped frontmatter + bottom-metadata version to `2.3.1` with a changelog entry.

### 2. Per-run back-fill — `01-pe-meta-update-agents.plan.md`

Materialized the missing plan at the canonical run-folder path with `status: done`, `backfill: true`, the resolved-invocation line carrying the real `plan-file=…` path, a goal table (F0–F3), execution-ready items, park lot, and exit criteria.

### 3. Audit trail correction — `05.04-meta-review-log.md`

Updated the `agents-apply-20260606` entry's first-line log to carry the real plan-file path and a note explaining the back-fill and the v2.3.1 fix.

### Code Changes

| File | Change | Result |
|---|---|---|
| `pe-meta-update.prompt.md` | Phase 6 § Plan materialization (non-skippable, both modes) | ✅ |
| `pe-meta-update.prompt.md` | Phase 8 marker note + test scenario 1 corrected | ✅ |
| `pe-meta-update.prompt.md` | version `2.3.0` → `2.3.1` + changelog | ✅ |
| `01-pe-meta-update-agents.plan.md` | back-filled canonical plan | ✅ |
| `05.04-meta-review-log.md` | corrected first-line log + note | ✅ |

---

## 📚 Additional Information

### Testing Recommendations

- Add a regression assertion to the embedded test inventory: **apply happy-path MUST emit `plan-file=<path>` and the file MUST exist on disk** before any source-artifact write.
- Consider a lightweight Phase 8 linter check that rejects a report whose first-line log shows `plan-file=none` while the outcome log contains `outcome: applied` entries (mutating run ⇒ plan-file required).

### Migration Considerations

- No breaking change to the invocation surface; the eight canonical parameters are unchanged.
- Existing `--plan-file <path>` override semantics are preserved (location/identity only).

### Performance Impact

- Negligible — one additional `create_file` write per mutating run; the plan content was already computed in Phase 5.

---

## ✔️ Resolution Status

**Current Status:** Resolved (fix landed; per-run artifact back-filled).

### Verification Checklist

- [x] Root cause identified (Phase 6 plan emission gated to `--mode plan` only) ✅
- [x] Systemic fix applied in `pe-meta-update.prompt.md` v2.3.1 ✅
- [x] Missing plan file back-filled at canonical run-folder path ✅
- [x] Audit-log first-line marker corrected (`plan-file=<path>`) ✅
- [x] All edited files validate with 0 markdown errors ✅
- [x] Recurrence recorded in repo memory ✅

### Follow-up Actions

- [x] Add the apply-happy-path `plan-file` regression assertion to the embedded test inventory (scenario 19) ✅
- [x] Add the Phase 8 linter check (mutating run ⇒ `plan-file ≠ none`) — scenario 20 + Phase 8 first-line-log linter, prompt v2.3.2 ✅
- [ ] Re-run a scoped `--mode apply` to confirm the plan file now lands automatically

---

## 🎓 Lessons Learned

### What Went Wrong

- A load-bearing contract step was wired into one mode branch instead of the shared path, so the prompt's prose and logic silently diverged.
- The gap was self-concealing: the run still "succeeded" (edits applied, regression passed), so the missing artifact was easy to miss until reviewed against the vision.

### What Went Right

- The first-line `Resolved invocation:` log made the violation observable (`plan-file=none` was the smoking gun).
- The meta-review log preserved enough history to detect the **recurrence** across two runs, escalating this from "slip" to "systemic defect."

### Improvements for the Future

- **Place non-skippable contract steps outside mode branches.** If a rule says "every mutating run," its implementation must live where both branches pass through it.
- **Treat `plan-file=none` on a mutating run as a hard failure**, not a soft marker.
- **Cross-check prose vs. logic for consistency** when a frontmatter claim ("materializes the plan on every run") could outlive a code path that no longer guarantees it.

---

## 📎 Appendix

### Authoritative References

| Reference | Path |
|---|---|
| Vision § Plan output contract | `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` |
| Plan-file contract snippet | `.github/prompt-snippets/pe-meta-plan-file-contract.md` |
| Plan lifecycle / actionability gate | `.github/instructions/plan-execution.instructions.md` |
| Orchestrator prompt (fixed) | `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` (v2.3.1) |
| Back-filled plan | `src/docs/90. Issues/202606/20260606.01-pe-meta-update/01-pe-meta-update-agents.plan.md` |
| Meta-review log | `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md` |

### Canonical Plan-File Path Algorithm (for reference)

```text
Default:  <run-folder>/<NN>-<kebab-name>.plan.md
Fallback: .copilot/temp/pe-meta-state/plans/YYYYMMDD-HHMMSS-<kebab-name>.plan.md
Override: --plan-file <path>  (location/identity ONLY)
```

---

# Article Additional Metadata

article_metadata:
  filename: "20260606 - pe-meta-update-apply-skips-plan-file.md"
  created: "2026-06-06"
  last_updated: "2026-06-06"
  version: "1.0"
  status: "resolved"
  issue_type: "bug"

cross_references:
  affected_articles:
    - ".github/prompts/00.09-pe-meta/pe-meta-update.prompt.md"
  related_issues: []
---
