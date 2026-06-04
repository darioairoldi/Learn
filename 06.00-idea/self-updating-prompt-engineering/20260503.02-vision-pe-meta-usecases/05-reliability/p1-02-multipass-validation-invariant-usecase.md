# UC-27: Multi-pass validation invariant

> **Group:** 05-reliability
> **Priority:** P1
> **Order in group:** 5
> **Vision anchor:** R2 — R-L2-self-correction; "It doesn't mean: executing changes that haven't passed at least one independent validation pass"

## Purpose 🎯

Assert the invariant that **every committed change has at least one independent validation pass entry** in the outcome log. R-L2 is a precondition for the autonomy gradient — if the invariant is breached even once, the gradient's safety guarantee is invalid.

## Invocation ⚙️

**Command family:** Review / Scheduled
**Primary entry point:** `/pe-meta-review --dim reliability`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation)
- `/pe-meta-update --mode plan --skip research --dim reliability` (quick mode — log scan only)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages multi-pass invariant check (`D31-multipass-validation-invariant`) |
| `--scope <type\|path>` | Narrow to commits touching a target |
| `--mode plan` | Default — reports breaches; does not modify |
| `--skip research` | Skip external evidence (this UC is internal log audit) |

## Behavior 🔬

1. Walk `outcome-log.jsonl` entries in the window (default: last 30 days).
2. For each `outcome: success|rolled_back` entry with `autonomy_level ∈ {autonomous, notify}`:
   - Look for a `validation_passes` array.
   - Require ≥1 entry with `pass_kind: independent` (independent = different model OR different invocation OR deterministic check).
3. Classify breaches:
   - Missing array → **CRITICAL** (no validation recorded)
   - Empty array → **CRITICAL**
   - Array with only `pass_kind: self` → **HIGH** (self-pass is not independent)
   - Array with ≥1 independent pass but reported failure → **MEDIUM** (validation ran but committed anyway — process bug)
4. Output breach list with commit ID, target artifact, missing-pass kind, and remediation suggestion.

## Dimensions covered 📐

`D31-multipass-validation-invariant` — primary.
`D30-metadata-guard` — adjacent (validation entries live in the same log structure).

## Reliability analysis 🚦

The vision explicitly forbids skipping validation to save tokens (conflict rule R-L2 vs R-P2). This UC is the deterministic enforcement of that rule. It is a release-gate for any change to the pe-meta engine itself: a regression in the validation-pass recorder would silently invalidate the autonomy gradient.

## Cost & efficiency 💰

Near-zero cost (log scan). Should run on every scheduled review cycle.

## Related use cases 🔗

- [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) — adjacent audit on the same log
- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md) — uses validation-pass density as a calibration input
- [p0-02-regression-protection](p0-02-regression-protection-usecase.md) — regression check is one form of validation pass
