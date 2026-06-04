# UC-31: Conflict-resolution coverage

> **Group:** 05-reliability
> **Priority:** P2
> **Order in group:** 9
> **Vision anchor:** R10 — Rationale "Conflict resolution among rationales" table

## Purpose 🎯

Verify the **conflict-resolution table is complete and exercised**. Every rationale pair that has produced a real-world tension SHOULD have a precedence rule. Pairs without a rule are latent oscillation risks (see [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md)) and latent disagreement risks across reviews.

## Invocation ⚙️

**Command family:** Review (long-cycle)
**Primary entry point:** `/pe-meta-review .copilot/context/ --dim reliability --mode plan`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages conflict-resolution coverage scan |
| `--scope path` | Recommended — scope to the vision file and rationale documents |
| `--mode plan` | Default — reports gaps; rule additions are human-only (vision change) |

## Behavior 🔬

1. **Rationale inventory.** Parse the vision's rationale tables (R-L*, R-P*, R-S*, R-G*) to build the full rationale ID set.
2. **Observed-conflict mining.** Scan `outcome-log.jsonl` for entries with non-null `conflict_pair` field — these are conflicts the system encountered at runtime.
3. **Documented-conflict inventory.** Parse the vision's "Conflict resolution among rationales" table.
4. **Gap analysis.**
   - **Observed but not documented**: conflict appeared in logs, no precedence rule exists → **HIGH** finding (proposes a new table row, human-only to commit).
   - **Documented but never observed**: precedence rule exists but no log entry references it → **INFO** (may be dead code or may be successful prevention).
   - **Coverage ratio**: `documented / (documented + undocumented_observed)`.
5. **Output.** Gap list with proposed table rows, log evidence, suggested rationale references.

## Dimensions covered 📐

`D29-regression-protection` — secondary (oscillation often stems from missing precedence)
`D17-cross-coherence` — secondary
Reliability group — primary (no single D# captures this; covered by the group)

## Reliability analysis 🚦

The conflict-resolution table is the vision's mechanism for cross-rationale coherence. Without coverage of observed conflicts, the same conflict will re-emerge across runs (oscillation) or across reviews (disagreement) — both are reliability defects. This UC closes the feedback loop from "we hit a conflict at runtime" to "we have a rule for it next time."

## Cost & efficiency 💰

Log scan + table parse — near-zero cost. LLM call only for the recommendation phrasing on detected gaps.

## Related use cases 🔗

- [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md) — oscillation detection feeds this UC's input
- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md) — calibration recommendations and conflict-rule recommendations are batched in the same vision-update cycle
