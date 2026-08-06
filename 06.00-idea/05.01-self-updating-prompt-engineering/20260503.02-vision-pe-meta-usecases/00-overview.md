# pe-meta use cases

> Companion to `20260515.01-pe-meta-update-plan.md` and `20260515.02-vision.v12.md`.
> 
> This catalog is now organized for usability: readable folders, readable filenames, and high-priority-first ordering.
> 
> Machine-readable catalog index: [`usecase-index.json`](usecase-index.json)

---

## 📂 Folder map

| Folder | Purpose | Priority flow |
|---|---|---|
| [01-freshness](01-freshness/00-overview.md) | Source-grounded freshness and lifecycle | P0 -> P1 |
| [02-quality-gates](02-quality-gates/00-overview.md) | Guidance quality gates | P0 -> P1 -> P2 |
| [03-consumer-correctness](03-consumer-correctness/00-overview.md) | Consumer implementation correctness | P0 -> P1 |
| [04-efficiency](04-efficiency/00-overview.md) | Efficiency and operating economics | P1 -> P2 -> P3 |
| [05-reliability](05-reliability/00-overview.md) | System-reliability validation (reproducibility, loop stability, rollback, autonomy calibration) | P0 -> P1 -> P2 |

---

## 🧭 Quick start

| Trigger | Start here | Then |
|---|---|---|
| Platform/model/ecosystem update | [01-freshness](01-freshness/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md), [03-consumer-correctness](03-consumer-correctness/00-overview.md), [04-efficiency](04-efficiency/00-overview.md) |
| Generated output quality regression | [03-consumer-correctness](03-consumer-correctness/00-overview.md) | [01-freshness](01-freshness/00-overview.md), [02-quality-gates](02-quality-gates/00-overview.md) |
| Process reliability concern (oscillation, rollback, calibration) | [05-reliability](05-reliability/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md), [03-consumer-correctness](03-consumer-correctness/00-overview.md) |
| Scheduled review pass | [01-freshness](01-freshness/00-overview.md) (P0) | [02-quality-gates](02-quality-gates/00-overview.md) (P0), [05-reliability](05-reliability/00-overview.md) (P0), [04-efficiency](04-efficiency/00-overview.md) (P1) |
| Localized artifact incident | Relevant folder by symptom | Re-enter full sequence if incident recurs |

---

## 📚 Dimension catalog

The **authoritative** definition of every dimension (`D#-readable-id`) and every `--dim` group referenced anywhere in this use-case set lives in [`05.07-pe-meta-dimension-catalog.md`](../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). Folder READMEs and individual use cases anchor to that catalog — they MUST NOT redefine dimensions inline.

## ⚙️ Dimension group shortcuts — routing across folders

Use `--dim <group>` to scope a review or update to a specific cluster of dimensions. The catalog enumerates the exact dimensions in each group; this table only routes the **group** to the folder(s) where its primary use cases live.

| `--dim` group | Primary folder | Companion folders |
|---|---|---|
| `--dim freshness` | [01-freshness](01-freshness/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md) |
| `--dim quality` | [02-quality-gates](02-quality-gates/00-overview.md) | [01-freshness](01-freshness/00-overview.md), [03-consumer-correctness](03-consumer-correctness/00-overview.md) |
| `--dim strategic` | [02-quality-gates](02-quality-gates/00-overview.md) | — (`D15-vision-alignment` only) |
| `--dim adherence` | [03-consumer-correctness](03-consumer-correctness/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md) |
| `--dim model` | [03-consumer-correctness](03-consumer-correctness/00-overview.md) | [04-efficiency](04-efficiency/00-overview.md) |
| `--dim structural` | [04-efficiency](04-efficiency/00-overview.md) | — |
| `--dim efficiency` | [04-efficiency](04-efficiency/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md) |
| `--dim context-full` | [01-freshness](01-freshness/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md) |
| `--dim context-health` | [01-freshness](01-freshness/00-overview.md) | [02-quality-gates](02-quality-gates/00-overview.md) |
| `--dim reliability` | [05-reliability](05-reliability/00-overview.md) | — |
| `--dim full` | (all folders) | — |

Example dimension-scoped commands:

```text
/pe-meta-review --mode plan --skip research --dim freshness
/pe-meta-review --mode plan --skip research --dim quality
/pe-meta-review --mode plan --skip research --dim adherence
/pe-meta-review --mode plan --skip research --dim efficiency
/pe-meta-review --mode plan --skip research --dim reliability
```

> **Migration note:** The `--dim robustness` value is **deprecated** as of vision v13. Use `--dim adherence` for consumer-correctness dimensions and `--dim reliability` for the system-reliability dimensions. `--dim robustness` is accepted for one release with a deprecation notice; the parser resolves it to `--dim adherence`. The deprecated `--group` syntax is replaced by `--dim` per the v13 option taxonomy.

---

## 🧾 Machine-readable index

Use [`usecase-index.json`](usecase-index.json) for tooling, automation, and deterministic run-order resolution.

Each entry includes:
- `id`
- `group`
- `priority`
- `path`
- `order`
- `title`
- `dimensions_covered` — array of canonical `D#-readable-id` strings (see [Dimension catalog 📚](#dimension-catalog)); the union across all entries MUST cover every dimension in the catalog (see audit at [`03-coverage-audit.md`](../../../src/docs/90.%20Issues/202606/20260601.02-dim-readable-ids/03-coverage-audit.md))

---

## 🔗 Complete use-case list (new paths)

### 01-freshness
- [p0-01-context-quality-lifecycle](01-freshness/p0-01-context-quality-lifecycle-usecase.md)
- [p0-02-release-impact-assessment](01-freshness/p0-02-release-impact-assessment-usecase.md)
- [p1-01-staleness-source-verification](01-freshness/p1-01-staleness-source-verification-usecase.md)
- [p1-02-context-optimization](01-freshness/p1-02-context-optimization-usecase.md)

### 02-quality-gates
- [p0-01-guidance-quality-assessment](02-quality-gates/p0-01-guidance-quality-assessment-usecase.md)
- [p1-01-consistency-check](02-quality-gates/p1-01-consistency-check-usecase.md)
- [p1-02-redundancy-check](02-quality-gates/p1-02-redundancy-check-usecase.md)
- [p1-03-coverage-gaps](02-quality-gates/p1-03-coverage-gaps-usecase.md)
- [p1-04-prioritization-review](02-quality-gates/p1-04-prioritization-review-usecase.md)
- [p2-01-artifact-structure-review](02-quality-gates/p2-01-artifact-structure-review-usecase.md)
- [p2-02-vision-alignment-check](02-quality-gates/p2-02-vision-alignment-check-usecase.md)

### 03-consumer-correctness
- [p0-01-dependency-aware-full-review](03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md)
- [p1-01-guidance-adherence-verification](03-consumer-correctness/p1-01-guidance-adherence-verification-usecase.md)
- [p1-02-model-specific-guidance-adherence](03-consumer-correctness/p1-02-model-specific-guidance-adherence-usecase.md)

### 04-efficiency
- [p1-01-token-budget-analysis](04-efficiency/p1-01-token-budget-analysis-usecase.md)
- [p1-02-model-routing-correctness](04-efficiency/p1-02-model-routing-correctness-usecase.md)
- [p2-01-processing-pipeline-efficiency](04-efficiency/p2-01-processing-pipeline-efficiency-usecase.md)
- [p2-02-reference-load-efficiency](04-efficiency/p2-02-reference-load-efficiency-usecase.md)
- [p2-03-handoff-efficiency](04-efficiency/p2-03-handoff-efficiency-usecase.md)
- [p2-04-deterministic-first-optimization](04-efficiency/p2-04-deterministic-first-optimization-usecase.md)
- [p3-01-craftmanship-review](04-efficiency/p3-01-craftmanship-review-usecase.md)
- [p3-02-structural-validation](04-efficiency/p3-02-structural-validation-usecase.md)

### 05-reliability
- [p0-01-process-reproducibility](05-reliability/p0-01-process-reproducibility-usecase.md)
- [p0-02-regression-protection](05-reliability/p0-02-regression-protection-usecase.md)
- [p0-03-metadata-guard-enforcement](05-reliability/p0-03-metadata-guard-enforcement-usecase.md)
- [p1-01-loop-stability-audit](05-reliability/p1-01-loop-stability-audit-usecase.md)
- [p1-02-multipass-validation-invariant](05-reliability/p1-02-multipass-validation-invariant-usecase.md)
- [p1-03-rollback-exercise](05-reliability/p1-03-rollback-exercise-usecase.md)
- [p1-04-boundary-actionability-redteam](05-reliability/p1-04-boundary-actionability-redteam-usecase.md)
- [p2-01-autonomy-calibration-audit](05-reliability/p2-01-autonomy-calibration-audit-usecase.md)
- [p2-02-conflict-resolution-coverage](05-reliability/p2-02-conflict-resolution-coverage-usecase.md)
- [p2-03-portability-boundary-scan](05-reliability/p2-03-portability-boundary-scan-usecase.md)
- [p2-04-mode-vs-risk-decoupling-check](05-reliability/p2-04-mode-vs-risk-decoupling-check-usecase.md)

---

## ⏭️ `--skip` stage scenarios

Use `--skip` to omit processing phases when prerequisites are met or when speed is prioritized:

| Scenario | Invocation | Rationale | Safe when |
|---|---|---|---|
| No external sources available | `--skip research` | Analyze current artifact state only | Offline or local-only audit |
| Structure is known-good | `--skip structure` | Focus on content quality dimensions | Last structural audit was <7 days ago |
| Cross-artifact consistency verified | `--skip consistency` | Focus on individual artifact quality | Consistency check passed in same session |
| Fast local-only check | `--skip external` | No internet-dependent analysis | Local dev environment without connectivity |
| Minimal viable health check | `--skip research,structure` | Quick content and strategic assessment | Routine health check on stable codebase |
| Content-only refresh | `--skip structure,consistency` | Only update content per new sources | Structural stability already confirmed |

**Example invocations:**

```text
/pe-meta-review --mode plan --skip research --dim freshness
/pe-meta-review --mode plan --dim quality --skip research,structure,consistency
/pe-meta-scheduled-review --deps direct --skip external
/pe-meta-review .copilot/context/ --dim full --skip research,structure
```

---

## 🎯 `--scope` composition scenarios

`--scope` controls **what** to assess; `--deps` controls **how deep** to traverse. They are orthogonal:

| Use case | Invocation | Meaning |
|---|---|---|
| Review prompt's context deps | `/pe-meta-review path --scope context --deps full` | Follow full dep chain, examine only context files |
| Review agent's instruction adherence | `/pe-meta-adherence path --scope instructions --deps direct` | Check first-level instruction deps only |
| Audit context file consumers | `/pe-meta-review path --scope prompts --deps direct` | Find prompts that load this context |
| Update all context files | `/pe-meta-review --mode apply --scope context` | Iterate context files only in batch |
| Health check prompts only | `/pe-meta-review --mode plan --skip research --scope prompts` | Diagnose prompt health, skip other types |
| Release impact on agents | `/pe-meta-release-diff <url> --scope agents` | Assess release impact on agent artifacts only |
| Efficiency audit on agents+prompts | `/pe-meta-review --mode apply --dim efficiency --skip research,structure,consistency --scope agents,prompts` | Token budgets most relevant for these types |

**Orthogonality principle:** `--scope` filters the artifact set; `--deps` controls traversal depth within that set. Combining both narrows the assessment surface precisely without mutual interference.

---

## ⚖️ Command overlap resolution

When multiple commands could serve a trigger, use this table to pick the canonical entry point:

| Overlap pair | Resolution | When to use each |
|---|---|---|
| `release-diff` vs `update --mode apply <url>` | `release-diff` is canonical for external-change-driven workflows | Use `release-diff` when a platform/model release triggers the work; use `update --mode apply` for general ad-hoc full-depth review |
| `adherence` vs `review --dim adherence` | `adherence` is canonical for "verify against loaded guidance" | Use `adherence` to trace guidance → consumers; use `review --dim adherence` to assess consumer quality independently (formerly `--dim robustness`) |
| `scheduled-review` rotation vs `update --mode plan --skip research` | `scheduled-review` orchestrates recurring cadence with auto-rotation | Use `scheduled-review` for periodic maintenance; use `update --mode plan --skip research` for ad-hoc one-time checks |
| `scheduled-review --deps` vs `/pe-meta-adherence` | Every 4th rotation, `scheduled-review` internally delegates to adherence | For ad-hoc adherence checks, invoke `/pe-meta-adherence` directly |
| `--dim efficiency --mode plan` vs `--dim efficiency --mode apply` | Both assess the efficiency dimensions; `--mode apply` also implements low-risk improvements autonomously | Use `--dim efficiency --mode apply --skip research,structure,consistency` for token/efficiency optimization with `@meta-optimizer` delegation; use `--mode plan` to opt into assessment-only output |

**No circular routing:** Each pair has a clear "canonical for this trigger" direction. Commands never redirect to each other in a loop.

---

## 🗺️ Compatibility map (old -> new)

| Old filename | New filename |
|---|---|
| `01-structural-validation.md` | `04-efficiency/p3-02-structural-validation-usecase.md` |
| `02-guidance-quality.md` | `02-quality-gates/p0-01-guidance-quality-assessment-usecase.md` |
| `03-consistency-check.md` | `02-quality-gates/p1-01-consistency-check-usecase.md` |
| `04-redundancy-check.md` | `02-quality-gates/p1-02-redundancy-check-usecase.md` |
| `05-staleness-verification.md` | `01-freshness/p1-01-staleness-source-verification-usecase.md` |
| `06-token-budget-analysis.md` | `04-efficiency/p1-01-token-budget-analysis-usecase.md` |
| `07-coverage-gaps.md` | `02-quality-gates/p1-03-coverage-gaps-usecase.md` |
| `08-artifact-structure-review.md` | `02-quality-gates/p2-01-artifact-structure-review-usecase.md` |
| `09-craftmanship-review.md` | `04-efficiency/p3-01-craftmanship-review-usecase.md` |
| `10-prioritization-review.md` | `02-quality-gates/p1-04-prioritization-review-usecase.md` |
| `11-adherence-verification.md` | `03-consumer-correctness/p1-01-guidance-adherence-verification-usecase.md` |
| `12-dependency-aware-review.md` | `03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md` |
| `13-vision-alignment.md` | `02-quality-gates/p2-02-vision-alignment-check-usecase.md` |
| `14-release-impact.md` | `01-freshness/p0-02-release-impact-assessment-usecase.md` |
| `15-deterministic-first.md` | `04-efficiency/p2-04-deterministic-first-optimization-usecase.md` |
| `16-context-optimization.md` | `01-freshness/p1-02-context-optimization-usecase.md` |
| `17-reference-efficiency.md` | `04-efficiency/p2-02-reference-load-efficiency-usecase.md` |
| `18-handoff-efficiency.md` | `04-efficiency/p2-03-handoff-efficiency-usecase.md` |
| `19-processing-efficiency.md` | `04-efficiency/p2-01-processing-pipeline-efficiency-usecase.md` |
| `20-model-routing.md` | `04-efficiency/p1-02-model-routing-correctness-usecase.md` |
| `21-model-adherence.md` | `03-consumer-correctness/p1-02-model-specific-guidance-adherence-usecase.md` |
| `22-context-quality-lifecycle.md` | `01-freshness/p0-01-context-quality-lifecycle-usecase.md` |
