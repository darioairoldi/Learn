# Efficiency use cases

## 🎯 Purpose
Use these cases when the main objective is to reduce cost, token usage, routing waste, or operational inefficiency after critical quality issues are already under control.

## 📚 Dimension catalog

Dimension references in this README use the canonical `D#-readable-id` form defined in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). The catalog is the single source of truth for what each `D#-readable-id` and each `--dim` group resolves to.

**Primary `--dim` groups for this folder:** `--dim efficiency`, `--dim structural` (see catalog § *Dimension groups*).

## 📐 Dimensions covered

| Dimension | `--dim` group(s) | Realizing use case(s) |
|---|---|---|
| `D1-metadata` | structural | [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D2-hierarchy` | structural | [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D3-token-budget` | structural / efficiency | [p1-01-token-budget-analysis](p1-01-token-budget-analysis-usecase.md), [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D4-tool-alignment` | structural / efficiency | [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D5-boundaries` | structural | [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D14-craftsmanship` | structural | [p3-01-craftmanship-review](p3-01-craftmanship-review-usecase.md), [p3-02-structural-validation](p3-02-structural-validation-usecase.md) |
| `D20-token-chain` | efficiency | [p1-01-token-budget-analysis](p1-01-token-budget-analysis-usecase.md) |
| `D21-deterministic-first` | efficiency | [p2-04-deterministic-first-optimization](p2-04-deterministic-first-optimization-usecase.md) |
| `D23-reference-efficiency` | efficiency | [p2-02-reference-load-efficiency](p2-02-reference-load-efficiency-usecase.md) |
| `D24-handoff-efficiency` | efficiency | [p2-03-handoff-efficiency](p2-03-handoff-efficiency-usecase.md) |
| `D25-processing-efficiency` | efficiency | [p2-01-processing-pipeline-efficiency](p2-01-processing-pipeline-efficiency-usecase.md) |
| `D26-model-routing` | efficiency / model | [p1-02-model-routing-correctness](p1-02-model-routing-correctness-usecase.md) |

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Token budget analysis | `/pe-meta-review --mode apply --dim efficiency --skip research,structure,consistency` | `--scope agents,prompts` |
| Model routing correctness | `/pe-meta-review --mode apply --dim efficiency --skip research,structure,consistency` | `--scope agents,prompts` |
| Pipeline efficiency audit | `/pe-meta-review --mode apply --dim efficiency --skip research,structure,consistency` | `--scope prompts` |
| Reference load optimization | `/pe-meta-review --mode apply --dim efficiency --skip research,structure,consistency` | `--scope agents,prompts` |
| Structural validation (low priority) | `/pe-meta-review <path>` | `--dim structural --skip research,consistency,content` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p1-01-token-budget-analysis](p1-01-token-budget-analysis-usecase.md) — artifact and chain token baseline.
2. [p1-02-model-routing-correctness](p1-02-model-routing-correctness-usecase.md) — correct task-to-model fit.
3. [p2-01-processing-pipeline-efficiency](p2-01-processing-pipeline-efficiency-usecase.md) — pipeline-level efficiency.
4. [p2-02-reference-load-efficiency](p2-02-reference-load-efficiency-usecase.md) — reference load reduction.
5. [p2-03-handoff-efficiency](p2-03-handoff-efficiency-usecase.md) — handoff efficiency.
6. [p2-04-deterministic-first-optimization](p2-04-deterministic-first-optimization-usecase.md) — deterministic-first decomposition.
7. [p3-01-craftmanship-review](p3-01-craftmanship-review-usecase.md) — craftsmanship refinements.
8. [p3-02-structural-validation](p3-02-structural-validation-usecase.md) — structural hygiene baseline.

## ✅ When to start here
- Token pressure or cost pressure.
- Pipeline optimization work.
- Efficiency tuning after correctness is stable.
