# Guidance quality gates use cases

## 🎯 Purpose
Use these cases when the main goal is to verify that guidance is safe, complete, non-contradictory, and ready to support autonomy.

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Full quality assessment | `/pe-meta-update --mode plan --skip research` | `--dim quality` |
| Single context file review | `/pe-meta-context-review <path>` | `--dim quality --deps direct` |
| Single instruction review | `/pe-meta-instruction-review <path>` | `--dim quality` |
| Consistency-only focus | `/pe-meta-update --mode plan` | `--dim quality --skip research,structure` |
| Redundancy check scoped to context | `/pe-meta-update --mode plan --skip research` | `--dim optimize --scope context` |
| Recurring quality gate | `/pe-meta-scheduled-review` | `--dim quality --deps direct` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment.md) — primary autonomy-readiness gate.
2. [p1-01-consistency-check](p1-01-consistency-check.md) — removes contradictions.
3. [p1-02-redundancy-check](p1-02-redundancy-check.md) — enforces single source of truth.
4. [p1-03-coverage-gaps](p1-03-coverage-gaps.md) — finds missing guidance.
5. [p1-04-prioritization-review](p1-04-prioritization-review.md) — makes precedence explicit.
6. [p2-01-artifact-structure-review](p2-01-artifact-structure-review.md) — improves structure and scope.
7. [p2-02-vision-alignment-check](p2-02-vision-alignment-check.md) — confirms strategic alignment.

## ✅ When to start here
- Guidance changes before autonomous rollout.
- Ambiguity, contradiction, or completeness concerns.
- Rule-priority or structure cleanup work.
