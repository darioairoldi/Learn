# Freshness and lifecycle use cases

## 🎯 Purpose
Use these cases when the main risk is stale logic, stale external assumptions, or context evolution after platform, model, or ecosystem change.

## 📚 Dimension catalog

Dimension references in this README use the canonical `D#-readable-id` form defined in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). The catalog is the single source of truth for what each `D#-readable-id` and each `--dim` group resolves to.

**Primary `--dim` groups for this folder:** `--dim freshness`, `--dim context-full`, `--dim context-health` (see catalog § *Dimension groups*).

## 📐 Dimensions covered

Dimensions exercised by at least one use case in this folder. Empty rows for catalog dimensions outside this folder's scope are intentionally omitted (see top-level [coverage audit](../../../../src/docs/90.%20Issues/202606/20260601.02-dim-readable-ids/03-coverage-audit.md)).

| Dimension | `--dim` group(s) | Realizing use case(s) |
|---|---|---|
| `D6-consistency` | quality | [p0-01-context-quality-lifecycle](p0-01-context-quality-lifecycle-usecase.md) |
| `D12-staleness` | freshness | [p0-01-context-quality-lifecycle](p0-01-context-quality-lifecycle-usecase.md), [p0-02-release-impact-assessment](p0-02-release-impact-assessment-usecase.md), [p1-01-staleness-source-verification](p1-01-staleness-source-verification-usecase.md) |
| `D13-source-verification` | freshness | [p0-02-release-impact-assessment](p0-02-release-impact-assessment-usecase.md), [p1-01-staleness-source-verification](p1-01-staleness-source-verification-usecase.md) |
| `D22-context-optimization` | context-full / context-health | [p0-01-context-quality-lifecycle](p0-01-context-quality-lifecycle-usecase.md), [p1-02-context-optimization](p1-02-context-optimization-usecase.md) |
| `D23-reference-efficiency` | optimize / context-health | [p1-02-context-optimization](p1-02-context-optimization-usecase.md) |

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Scheduled freshness sweep | `/pe-meta-scheduled-review` | `--dim freshness` |
| Targeted context lifecycle check | `/pe-meta-context-review <path>` | `--dim freshness --deps direct` |
| Release-driven impact assessment | `/pe-meta-update --source <url>` | `--dim freshness --scope context` |
| Full staleness audit | `/pe-meta-update --mode plan --skip research` | `--dim freshness` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p0-01-context-quality-lifecycle](p0-01-context-quality-lifecycle-usecase.md) — main lifecycle orchestrator.
2. [p0-02-release-impact-assessment](p0-02-release-impact-assessment-usecase.md) — detects release-driven impact.
3. [p1-01-staleness-source-verification](p1-01-staleness-source-verification-usecase.md) — validates freshness and sources for scoped areas.
4. [p1-02-context-optimization](p1-02-context-optimization-usecase.md) — optimizes organization after impact is understood.

## ✅ When to start here
- Platform, model, or ecosystem updates.
- Suspected Type B staleness.
- Context-set refresh or source-grounded update work.

## 🔁 What gets processed on a trigger (vision v15.3)

When a platform, model, or ecosystem event fires the freshness path, "what gets processed" is **not** every artifact and **not** a scalar "everything since date X". The work set is the set of **stale processing units (PUs)**, where a PU is one `(artifact × applicable-dimension)`:

- A PU enters the work set when a dependency source's ledger `last_seen_version`/`last_seen_timestamp` is newer than the PU's recorded `source_versions[<dep>]`, OR its `status` is `never`/non-`pass` (the at-least-once guarantee from `coverage-completeness-guarantee`).
- PUs already covered at the new source version with `status=pass` are skipped (no-redundant).
- To re-process an already-covered window when a prior run is distrusted, supply an explicit `--start <date|version>` / `--end` bound — this derives `breadth=bounded-delta` and overrides recorded `pass` coverage inside the window (re-baseline / distrust-recovery).

See [p0-02-release-impact-assessment](p0-02-release-impact-assessment-usecase.md) § *Coverage model* and [p1-01-staleness-source-verification](p1-01-staleness-source-verification-usecase.md) § *State model: two axes* for the full rules.
