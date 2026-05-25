# Efficiency use cases

## 🎯 Purpose
Use these cases when the main objective is to reduce cost, token usage, routing waste, or operational inefficiency after critical quality issues are already under control.

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Token budget analysis | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency` | `--scope agents,prompts` |
| Model routing correctness | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency` | `--scope agents,prompts` |
| Pipeline efficiency audit | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency` | `--scope prompts` |
| Reference load optimization | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency` | `--scope agents,prompts` |
| Structural validation (low priority) | `/pe-meta-review <path>` | `--dim structural --skip research,consistency,content` |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`

## 📋 Run order
1. [p1-01-token-budget-analysis](p1-01-token-budget-analysis.md) — artifact and chain token baseline.
2. [p1-02-model-routing-correctness](p1-02-model-routing-correctness.md) — correct task-to-model fit.
3. [p2-01-processing-pipeline-efficiency](p2-01-processing-pipeline-efficiency.md) — pipeline-level efficiency.
4. [p2-02-reference-load-efficiency](p2-02-reference-load-efficiency.md) — reference load reduction.
5. [p2-03-handoff-efficiency](p2-03-handoff-efficiency.md) — handoff efficiency.
6. [p2-04-deterministic-first-optimization](p2-04-deterministic-first-optimization.md) — deterministic-first decomposition.
7. [p3-01-craftmanship-review](p3-01-craftmanship-review.md) — craftsmanship refinements.
8. [p3-02-structural-validation](p3-02-structural-validation.md) — structural hygiene baseline.

## ✅ When to start here
- Token pressure or cost pressure.
- Pipeline optimization work.
- Efficiency tuning after correctness is stable.
