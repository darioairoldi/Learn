# UC-24: Regression protection

> **Group:** 05-reliability
> **Priority:** P0
> **Order in group:** 2
> **Vision anchor:** R4 — Goal "executing validated corrections"; Risks § False confidence

## 🎯 Purpose

Enforce that every autonomous change is gated by a **before/after behavioral snapshot**. A change MUST NOT be committed autonomously if the post-change snapshot regresses on any captured behavior (schema-level snapshot today; consumer-behavioral snapshot when Phase 2–3 routes apply).

## ⚙️ Invocation

**Command family:** Update / Review
**Primary entry point:** `/pe-meta-review <target> --dim reliability` (regression-protection mode triggered by the dimension)
**Alternative entry points:**

- `/pe-meta-review <path> --dim reliability --mode plan` (assess whether existing autonomous changes had snapshots)
- `/pe-meta-scheduled-review --dim reliability` (rotation entry — audits N most recent autonomous commits)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages regression-protection check (`D29-regression-protection` series) |
| `--scope <type\|path>` | Narrow the audited change set |
| `--deps direct\|full` | Include dependents in the post-change snapshot diff |
| `--mode plan` | Audit historical commits without re-running them |
| `--skip research` | Skip external evidence fetch (the audit is internal to the outcome log) |

## 🔬 Behavior

### Pre-commit gate (real-time)

When a Review or Update command proposes an autonomous change:

1. Capture **before-snapshot**: schema-level fields (YAML structure, section headings, metadata field names), reference resolutions, and (for agents/prompts) the artifact's declared `goal`, `scope`, and `boundaries`.
2. Apply the change in a sandbox.
3. Capture **after-snapshot**.
4. Diff. If any captured field changed beyond the declared-intent set, classify as **regression-suspect** and escalate (do not auto-apply).
5. On clean diff: commit, record snapshot pair in `outcome-log.jsonl`.

### Audit pass (this UC's primary mode)

1. Walk recent `autonomy_level: autonomous | notify` entries in the outcome log.
2. For each, verify the entry includes `before_snapshot` and `after_snapshot` references.
3. Re-run the schema-level diff on the snapshot pair.
4. Emit findings for: missing snapshots, divergent snapshots, snapshots not matching commit content.

## 📐 Dimensions covered

`D29-regression-protection` — primary.
`D30-metadata-guard` — checks the snapshot pair was recorded.

## 🚦 Reliability analysis

This UC operationalizes the vision's hard limit on autonomous effectiveness: "validation can check structural integrity and internal consistency, but cannot verify that a prompt still produces good output." Regression protection at schema level is the strongest deterministic gate available today. Phase 2/3 will add consumer-behavioral snapshots (LLM-driven), which this UC's coverage matrix MUST expand to track.

## 💰 Cost & efficiency

Schema-level snapshots are near-zero cost (deterministic). The audit pass scales linearly with autonomous-commit volume. Recommend bounded window (last 30 days or last N commits).

## 🔗 Related use cases

- [p0-01-process-reproducibility](p0-01-process-reproducibility-usecase.md) — reproducibility is a precondition for trustworthy regression diffs
- [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) — snapshot pair is one of the metadata-guard entries
- [p1-03-rollback-exercise](p1-03-rollback-exercise-usecase.md) — rollback uses the before-snapshot as restore target
