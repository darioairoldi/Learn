# Guidance quality gates use cases

## 🎯 Purpose
Use these cases when the main goal is to verify that guidance is safe, complete, non-contradictory, and ready to support autonomy.

## 📚 Dimension catalog

Dimension references in this README use the canonical `D#-readable-id` form defined in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). The catalog is the single source of truth for what each `D#-readable-id` and each `--dim` group resolves to.

**Primary `--dim` groups for this folder:** `--dim quality`, `--dim structural`, `--dim strategic` (see catalog § *Dimension groups*).

## 📐 Dimensions covered

| Dimension | `--dim` group(s) | Realizing use case(s) |
|---|---|---|
| `D6-consistency` | quality / adherence | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-01-consistency-check](p1-01-consistency-check-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D7-non-redundancy` | quality | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-02-redundancy-check](p1-02-redundancy-check-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D8-prioritization` | quality | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-04-prioritization-review](p1-04-prioritization-review-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D9-clarity` | quality | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D10-completeness` | quality | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-03-coverage-gaps](p1-03-coverage-gaps-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D11-actionability` | quality | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md), [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) |
| `D14-craftsmanship` | quality / structural | [p2-01-artifact-structure-review](p2-01-artifact-structure-review-usecase.md) |
| `D15-vision-alignment` | strategic | [p2-02-vision-alignment-check](p2-02-vision-alignment-check-usecase.md) |
| `D16-adherence` | quality / adherence | [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md), [p2-02-vision-alignment-check](p2-02-vision-alignment-check-usecase.md) |
| `D17-cross-coherence` | quality | [p2-02-vision-alignment-check](p2-02-vision-alignment-check-usecase.md) |
| `D18-coverage` | quality / adherence | [p1-03-coverage-gaps](p1-03-coverage-gaps-usecase.md) |
| `D19-artifact-structure` | quality / structural | [p2-01-artifact-structure-review](p2-01-artifact-structure-review-usecase.md) |
| `D27-model-adherence` | quality / model | [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md) |

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Full quality assessment | `/pe-meta-review --mode plan --skip research` | `--dim quality` |
| Single context file review | `/pe-meta-context-review <path>` | `--dim quality --deps direct` |
| Single instruction review | `/pe-meta-instruction-review <path>` | `--dim quality` |
| Consistency-only focus | `/pe-meta-review --mode plan` | `--dim quality --skip research,structure` |
| Redundancy check scoped to context | `/pe-meta-review --mode plan --skip research` | `--dim quality --scope context` |
| Design/review parity gate | `/pe-meta-review <path>` | `--dim quality` |
| Recurring quality gate | `/pe-meta-scheduled-review` | `--dim quality --deps direct` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md) — primary autonomy-readiness gate.
2. [p1-01-consistency-check](p1-01-consistency-check-usecase.md) — removes contradictions.
3. [p1-02-redundancy-check](p1-02-redundancy-check-usecase.md) — enforces single source of truth.
4. [p1-03-coverage-gaps](p1-03-coverage-gaps-usecase.md) — finds missing guidance.
5. [p1-04-prioritization-review](p1-04-prioritization-review-usecase.md) — makes precedence explicit.
6. [p1-05-design-review-parity](p1-05-design-review-parity-usecase.md) — holds design output to the review quality bar.
7. [p2-01-artifact-structure-review](p2-01-artifact-structure-review-usecase.md) — improves structure and scope.
8. [p2-02-vision-alignment-check](p2-02-vision-alignment-check-usecase.md) — confirms strategic alignment.

## ✅ When to start here
- Guidance changes before autonomous rollout.
- Ambiguity, contradiction, or completeness concerns.
- Rule-priority or structure cleanup work.
