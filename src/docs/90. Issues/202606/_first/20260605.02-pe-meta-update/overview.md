# ISSUE: `/pe-meta-update --mode apply` executed without materializing the plan file first - 20260605

Date: **05 Jun 2026**<br>
Author: **Dario Airoldi**

## Table of Contents

- [📝 DESCRIPTION](#-description)
- [ℹ️ CONTEXT INFORMATION / REPRO STEPS](#ℹ️-context-information--repro-steps)
- [🔍 ANALYSIS](#-analysis)
- [🛠️ RESOLUTION](#️-resolution)
- [➕ ADDITIONAL INFORMATION](#-additional-information)
- [📚 REFERENCES](#-references)

## 📝 DESCRIPTION

A `/pe-meta-update '.copilot\context\00.00-prompt-engineering' --mode apply` run completed its full pipeline (Phases 0→8), applied three context fixes, passed regression, and logged the run — **but never wrote a plan file to disk**. The plan existed only inline in the conversation (Phase 5), and the run's first-line log emitted `plan-file=none`.

This violates **vision v15.4**, which defines `apply = plan + execute` and states that *"the plan file is the single pivot artifact every mutating run passes through."* The plan-file contract reinforces this: *"Plan emission is non-skippable on every mutating run."* The expected, vision-compliant behavior is **materialize the plan file first, then execute steps from it** — exactly what the user expected and did not observe.

The gap is silent: nothing in the run surfaced the missing artifact, and the run otherwise reported success. Without the on-disk plan, the apply run produced no reviewable, version-controlled audit artifact and could not be re-run from a durable plan.

## ℹ️ CONTEXT INFORMATION / REPRO STEPS

| Field | Value |
|---|---|
| **Invoked command** | `/pe-meta-update '.copilot\context\00.00-prompt-engineering' --mode apply` |
| **Orchestrator** | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) (v2.3.0) |
| **Governing vision** | [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) (v15.4) |
| **Governing contract** | [pe-meta-plan-file-contract.md](../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md) |
| **Run folder** | `src/docs/90. Issues/202606/20260605.02-pe-meta-update/` |
| **Expected artifact** | `01-<kebab-name>.plan.md` in the run folder |
| **Observed artifact** | none — folder held only an empty `overview.md` |
| **First-line log marker** | `plan-file=none` (rejected by the contract's linter rule) |

**To reproduce:**

1. Invoke `/pe-meta-update <scope> --mode apply` on a context folder.
2. Let the pipeline run through Phase 5 (approval) and Phase 6 (apply).
3. Inspect the run folder after completion.
4. Observe that **no `*.plan.md` file** was written — the plan appeared only in the conversation.
5. Inspect the Phase 8 first-line log and observe `plan-file=none`.

## 🔍 ANALYSIS

### Root cause

The proximate cause is an **internal contradiction inside the orchestrator prompt**. The Phase 8 first-line-log instruction in [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) still carries stale **v15.1-era wording**:

> `plan-file=<path>` is emitted whenever `--mode=plan`

This contradicts the same file's `--mode apply` row and `scope.covers`, and contradicts vision v15.4's "materializes the plan on **every** run." Because the log contract was conditioned on `--mode=plan`, the apply run treated plan-file materialization as a plan-mode-only step, collapsed plan→execute into a chat-only flow, and emitted `plan-file=none` without raising any error.

### Why it matters

| Concern | Impact |
|---|---|
| **Vision compliance** | Directly violates the v15.4 `apply = plan + execute` invariant and the contract's "non-skippable on every mutating run" rule. |
| **Auditability** | No version-controlled, reviewable plan artifact remains after an apply run — the change record lives only in an ephemeral conversation. |
| **Re-runnability** | The plan cannot be re-executed or promoted later, because it was never persisted. |
| **Silent failure** | The run reported success while skipping a mandated step; nothing alerted the operator. |
| **Precedent drift** | The prior `2026-06-03` run did it correctly (left a plan file on disk), so behavior is inconsistent across runs. |

### Execution-mode note

The run was effectively a **fresh** execution (no baseline available, audits ran). The defect is **not** the execution path — research and apply behaved correctly — it is the **missing plan-file write** mandated independently of execution mode.

## 🛠️ RESOLUTION

### Step 1 — Confirm the gap against the authoritative contract (✅ done)

Verified against [pe-meta-plan-file-contract.md](../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md): *"A plan file is the single pivot artifact every mutating run passes through. Both modes materialize a plan."* and *"Plan emission is non-skippable on every mutating run."* The run's `plan-file=none` is non-compliant.

### Step 2 — Back-fill the missing on-disk plan artifact (✅ done)

Materialized [01-pe-meta-update-context-full.plan.md](01-pe-meta-update-context-full.plan.md) in the run folder, conforming to [plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md) and [plan-marking.instructions.md](../../../../../.github/instructions/plan-marking.instructions.md). Because the changes were already applied and regression-passed, the plan is recorded `status: done` with each row marked `(✅ done)`, `(✅ closed — no-op)`, or `(📌 next steps)`, plus a provenance note explaining the retroactive materialization.

### Step 3 — Correct the run log marker (✅ done)

Updated the `full-apply-20260606` entry in [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) — replaced `plan-file=none` with the materialized plan path and added a note recording the contract gap and back-fill.

### Step 4 — Fix the orchestrator prompt root cause (🟡 todo)

The stale Phase 8 log clause in [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) MUST be realigned with v15.4 so `plan-file=<path>` is emitted on **apply** runs too, and the plan is written to disk **before** execution. Recommended follow-up:

```text
/pe-meta-update --mode apply --scope .github/prompts/00.09-pe-meta/pe-meta-update.prompt.md
```

(or `/pe-meta-prompt-review`) to update the Phase 8 first-line-log contract. This is a different artifact type (`.github/prompts/`) outside the context-folder scope of the original run, which is why the original consistency pass did not catch it.

### Verification

| Check | Result |
|---|---|
| Plan artifact present in run folder | ✅ `01-pe-meta-update-context-full.plan.md` |
| Run-log marker references real plan path | ✅ |
| Applied context fixes intact (C1, C2, F3) | ✅ |
| 0 markdown errors on touched files | ✅ |
| Prompt root cause fixed | 🟡 pending follow-up run |

## ➕ ADDITIONAL INFORMATION

- The plan-file path algorithm is `<run-folder>/<NN>-<kebab-name>.plan.md`, with fallback `.copilot/temp/pe-meta-state/plans/YYYYMMDD-HHMMSS-<kebab-name>.plan.md` when no run folder exists.
- The contract's linter is documented to **reject reports that omit the `plan-file=<path>` marker** — this run should have failed that check rather than emitting `plan-file=none`.
- The three context fixes applied by the run (dead vision link repoint, orphaned `04.02` category mapping, glossary disambiguation) are unaffected and remain valid; this issue concerns only the **missing pivot artifact**, not the content changes.
- Until the prompt is fixed, operators SHOULD manually confirm a `*.plan.md` file exists in the run folder after every `--mode apply` run.

## 📚 REFERENCES

- [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) 📒 [Repo]<br>
  Vision v15.4 — defines `apply = plan + execute` and the "single pivot artifact" § Plan output contract that this run violated.

- [pe-meta-plan-file-contract.md](../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md) 📘 [Repo]<br>
  Authoritative plan-file contract — "plan emission is non-skippable on every mutating run"; path algorithm and `plan-file=<path>` log requirement.

- [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) 📘 [Repo]<br>
  Orchestrator prompt — Phase 8 first-line-log clause carries the stale v15.1 wording that is the root cause.

- [01-pe-meta-update-context-full.plan.md](01-pe-meta-update-context-full.plan.md) 📒 [Repo]<br>
  The plan artifact materialized retroactively to close the contract gap.

- [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) 📒 [Repo]<br>
  Run log — `full-apply-20260606` entry, corrected to reference the materialized plan path.

- [01-pe-meta-update-context-quality.plan.md](../20260603.02-pe-meta-update/01-pe-meta-update-context-quality.plan.md) 📒 [Repo]<br>
  Prior `2026-06-03` apply run that correctly persisted its plan file — the compliant precedent.

- [plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md) 📘 [Repo]<br>
  Plan-file lifecycle and frontmatter rules followed by the back-filled plan.
