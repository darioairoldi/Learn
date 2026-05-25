# UC-28: Rollback exercise

> **Group:** 05-reliability
> **Priority:** P1
> **Order in group:** 6
> **Vision anchor:** R8 — R-S6-tier-blast-radius: "Group snapshots for rollback are tier-scoped"

## 🎯 Purpose

Periodically exercise the **snapshot/restore** capability. A snapshot system that is never tested degrades silently — by the time a real rollback is needed, the snapshots may be incomplete, the restore script may be broken, or tier-scoping may be misconfigured. This UC fires a controlled drill.

## ⚙️ Invocation

**Command family:** Scheduled / Review
**Primary entry point:** `/pe-meta-scheduled-review --dim reliability` (rotation; drill runs on configured cadence)
**Alternative entry points:**

- `/pe-meta-review <path> --dim reliability --mode plan` (assess rollback readiness without executing the drill)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages rollback-readiness check (D32) |
| `--scope <type\|path>` | Narrow the drill to a tier or artifact set |
| `--deps direct\|full` | Verify dependent artifacts are included in the snapshot |
| `--mode plan` | Skip the actual restore (assessment-only); default `apply` runs the drill |

## 🔬 Behavior

### Pre-drill checks (always run)

1. Verify snapshot directory exists and is writable.
2. Verify the most recent N snapshots are well-formed (parse manifest, sample-check content hashes).
3. Verify tier-scoping metadata is present on every snapshot: each manifest declares its `tier_scope`.

### Drill (when `--mode apply`)

1. Pick a low-traffic artifact in the target scope (or a designated test fixture).
2. Take a fresh snapshot.
3. Mutate the artifact (controlled, reversible change).
4. Verify the mutation is observable in a follow-up Review pass.
5. Restore from the snapshot.
6. Verify the artifact is byte-identical to its pre-mutation state.
7. Verify dependent-artifact references still resolve.
8. Record drill outcome in `outcome-log.jsonl` with kind `drill: rollback`.

### Findings on drill failure

- **CRITICAL**: snapshot corruption, restore script failure, or post-restore reference breakage. Release-blocking.
- **HIGH**: tier-scope metadata missing or wrong.
- **MEDIUM**: drill succeeded but exceeded declared time budget.

## 📐 Dimensions covered

D32 (rollback-readiness) — primary.

## 🚦 Reliability analysis

This UC validates the "executing low-risk changes autonomously with post-execution notification" loop's safety net. Without a working rollback, "autonomous with notification" degrades to "autonomous with hope." The drill cadence is itself a configuration parameter that this UC reports on: too rare → silent rot risk; too frequent → cost overhead.

## 💰 Cost & efficiency

Pre-drill checks are near-zero cost. The full drill consumes one snapshot/restore cycle (filesystem-bound, no LLM cost). Default cadence: weekly on a designated test fixture; quarterly on a real low-tier artifact.

## 🔗 Related use cases

- [p0-02-regression-protection](p0-02-regression-protection.md) — uses snapshots as restore targets
- [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement.md) — snapshot pair is one of the metadata-guard entries
- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit.md) — drill failure rate factors into autonomy-threshold calibration
