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
| [01-freshness](01-freshness/README.md) | Source-grounded freshness and lifecycle | P0 -> P1 |
| [02-quality-gates](02-quality-gates/README.md) | Guidance quality gates | P0 -> P1 -> P2 |
| [03-consumer-correctness](03-consumer-correctness/README.md) | Consumer implementation correctness | P0 -> P1 |
| [04-efficiency](04-efficiency/README.md) | Efficiency and operating economics | P1 -> P2 -> P3 |
| [05-reliability](05-reliability/README.md) | System-reliability validation (reproducibility, loop stability, rollback, autonomy calibration) | P0 -> P1 -> P2 |

---

## 🧭 Quick start

| Trigger | Start here | Then |
|---|---|---|
| Platform/model/ecosystem update | [01-freshness](01-freshness/README.md) | [02-quality-gates](02-quality-gates/README.md), [03-consumer-correctness](03-consumer-correctness/README.md), [04-efficiency](04-efficiency/README.md) |
| Generated output quality regression | [03-consumer-correctness](03-consumer-correctness/README.md) | [01-freshness](01-freshness/README.md), [02-quality-gates](02-quality-gates/README.md) |
| Process reliability concern (oscillation, rollback, calibration) | [05-reliability](05-reliability/README.md) | [02-quality-gates](02-quality-gates/README.md), [03-consumer-correctness](03-consumer-correctness/README.md) |
| Scheduled review pass | [01-freshness](01-freshness/README.md) (P0) | [02-quality-gates](02-quality-gates/README.md) (P0), [05-reliability](05-reliability/README.md) (P0), [04-efficiency](04-efficiency/README.md) (P1) |
| Localized artifact incident | Relevant folder by symptom | Re-enter full sequence if incident recurs |

---

## ⚙️ Dimension group shortcuts

Use `--dim` groups to run focused review slices against specific quality dimension clusters:

| Use-case group | `--dim` value | Dimensions | Typical usage |
|---|---|---|---|
| Freshness | `--dim freshness` | D12, D13 | Release updates, staleness incidents, context lifecycle checks |
| Quality gates | `--dim quality` | D6–D11, D27 | Contradictions, completeness, prioritization checks |
| Consumer correctness | `--dim adherence` | D5, D6, D16, D18 | Prompt/agent behavior regression validation (legacy alias: `--dim robustness`, deprecated — see migration note) |
| Efficiency | `--dim optimize` | D3, D7, D9, D11, D20–D26 | Token/cost pressure and routing optimization |
| Reliability | `--dim reliability` | D28–D35 | Reproducibility, loop stability, rollback readiness, autonomy calibration, boundary actionability |

Example dimension-scoped commands:

```text
/pe-meta-update --mode plan --skip research --dim freshness
/pe-meta-update --mode plan --skip research --dim quality
/pe-meta-update --mode plan --skip research --dim adherence
/pe-meta-update --mode plan --skip research --dim optimize
/pe-meta-update --mode plan --skip research --dim reliability
```

> **Migration note:** The `--dim robustness` value is **deprecated** as of vision v13. Use `--dim adherence` for consumer-correctness dimensions (D5, D6, D16, D18) and `--dim reliability` for the new system-reliability dimensions (D28–D35). `--dim robustness` is accepted for one release with a deprecation notice; the parser resolves it to `--dim adherence`. The deprecated `--group` syntax (e.g., `--group freshness`) is replaced by `--dim` per the v13 option taxonomy.

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

---

## 🔗 Complete use-case list (new paths)

### 01-freshness
- [p0-01-context-quality-lifecycle](01-freshness/p0-01-context-quality-lifecycle.md)
- [p0-02-release-impact-assessment](01-freshness/p0-02-release-impact-assessment.md)
- [p1-01-staleness-source-verification](01-freshness/p1-01-staleness-source-verification.md)
- [p1-02-context-optimization](01-freshness/p1-02-context-optimization.md)

### 02-quality-gates
- [p0-01-guidance-quality-assessment](02-quality-gates/p0-01-guidance-quality-assessment.md)
- [p1-01-consistency-check](02-quality-gates/p1-01-consistency-check.md)
- [p1-02-redundancy-check](02-quality-gates/p1-02-redundancy-check.md)
- [p1-03-coverage-gaps](02-quality-gates/p1-03-coverage-gaps.md)
- [p1-04-prioritization-review](02-quality-gates/p1-04-prioritization-review.md)
- [p2-01-artifact-structure-review](02-quality-gates/p2-01-artifact-structure-review.md)
- [p2-02-vision-alignment-check](02-quality-gates/p2-02-vision-alignment-check.md)

### 03-consumer-correctness
- [p0-01-dependency-aware-full-review](03-consumer-correctness/p0-01-dependency-aware-full-review.md)
- [p1-01-guidance-adherence-verification](03-consumer-correctness/p1-01-guidance-adherence-verification.md)
- [p1-02-model-specific-guidance-adherence](03-consumer-correctness/p1-02-model-specific-guidance-adherence.md)

### 04-efficiency
- [p1-01-token-budget-analysis](04-efficiency/p1-01-token-budget-analysis.md)
- [p1-02-model-routing-correctness](04-efficiency/p1-02-model-routing-correctness.md)
- [p2-01-processing-pipeline-efficiency](04-efficiency/p2-01-processing-pipeline-efficiency.md)
- [p2-02-reference-load-efficiency](04-efficiency/p2-02-reference-load-efficiency.md)
- [p2-03-handoff-efficiency](04-efficiency/p2-03-handoff-efficiency.md)
- [p2-04-deterministic-first-optimization](04-efficiency/p2-04-deterministic-first-optimization.md)
- [p3-01-craftmanship-review](04-efficiency/p3-01-craftmanship-review.md)
- [p3-02-structural-validation](04-efficiency/p3-02-structural-validation.md)

### 05-reliability
- [p0-01-process-reproducibility](05-reliability/p0-01-process-reproducibility.md)
- [p0-02-regression-protection](05-reliability/p0-02-regression-protection.md)
- [p0-03-metadata-guard-enforcement](05-reliability/p0-03-metadata-guard-enforcement.md)
- [p1-01-loop-stability-audit](05-reliability/p1-01-loop-stability-audit.md)
- [p1-02-multipass-validation-invariant](05-reliability/p1-02-multipass-validation-invariant.md)
- [p1-03-rollback-exercise](05-reliability/p1-03-rollback-exercise.md)
- [p1-04-boundary-actionability-redteam](05-reliability/p1-04-boundary-actionability-redteam.md)
- [p2-01-autonomy-calibration-audit](05-reliability/p2-01-autonomy-calibration-audit.md)
- [p2-02-conflict-resolution-coverage](05-reliability/p2-02-conflict-resolution-coverage.md)
- [p2-03-portability-boundary-scan](05-reliability/p2-03-portability-boundary-scan.md)
- [p2-04-mode-vs-risk-decoupling-check](05-reliability/p2-04-mode-vs-risk-decoupling-check.md)

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
/pe-meta-update --mode plan --skip research --dim freshness
/pe-meta-update --mode plan --dim quality --skip research,structure,consistency
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
| Update all context files | `/pe-meta-update --mode apply --scope context` | Iterate context files only in batch |
| Health check prompts only | `/pe-meta-update --mode plan --skip research --scope prompts` | Diagnose prompt health, skip other types |
| Release impact on agents | `/pe-meta-release-diff <url> --scope agents` | Assess release impact on agent artifacts only |
| Efficiency audit on agents+prompts | `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts` | Token budgets most relevant for these types |

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
| `update --dim optimize` vs `review --dim optimize` | Both default to `--mode apply` — assess and implement low-risk improvements autonomously | Use `update --dim optimize --skip research,structure,consistency` for token/efficiency optimization with `@meta-optimizer` delegation; use `review --dim optimize` for broader quality optimization. Use `--mode plan` to opt into assessment-only output |

**No circular routing:** Each pair has a clear "canonical for this trigger" direction. Commands never redirect to each other in a loop.

---

## 🗺️ Compatibility map (old -> new)

| Old filename | New filename |
|---|---|
| `01-structural-validation.md` | `04-efficiency/p3-02-structural-validation.md` |
| `02-guidance-quality.md` | `02-quality-gates/p0-01-guidance-quality-assessment.md` |
| `03-consistency-check.md` | `02-quality-gates/p1-01-consistency-check.md` |
| `04-redundancy-check.md` | `02-quality-gates/p1-02-redundancy-check.md` |
| `05-staleness-verification.md` | `01-freshness/p1-01-staleness-source-verification.md` |
| `06-token-budget-analysis.md` | `04-efficiency/p1-01-token-budget-analysis.md` |
| `07-coverage-gaps.md` | `02-quality-gates/p1-03-coverage-gaps.md` |
| `08-artifact-structure-review.md` | `02-quality-gates/p2-01-artifact-structure-review.md` |
| `09-craftmanship-review.md` | `04-efficiency/p3-01-craftmanship-review.md` |
| `10-prioritization-review.md` | `02-quality-gates/p1-04-prioritization-review.md` |
| `11-adherence-verification.md` | `03-consumer-correctness/p1-01-guidance-adherence-verification.md` |
| `12-dependency-aware-review.md` | `03-consumer-correctness/p0-01-dependency-aware-full-review.md` |
| `13-vision-alignment.md` | `02-quality-gates/p2-02-vision-alignment-check.md` |
| `14-release-impact.md` | `01-freshness/p0-02-release-impact-assessment.md` |
| `15-deterministic-first.md` | `04-efficiency/p2-04-deterministic-first-optimization.md` |
| `16-context-optimization.md` | `01-freshness/p1-02-context-optimization.md` |
| `17-reference-efficiency.md` | `04-efficiency/p2-02-reference-load-efficiency.md` |
| `18-handoff-efficiency.md` | `04-efficiency/p2-03-handoff-efficiency.md` |
| `19-processing-efficiency.md` | `04-efficiency/p2-01-processing-pipeline-efficiency.md` |
| `20-model-routing.md` | `04-efficiency/p1-02-model-routing-correctness.md` |
| `21-model-adherence.md` | `03-consumer-correctness/p1-02-model-specific-guidance-adherence.md` |
| `22-context-quality-lifecycle.md` | `01-freshness/p0-01-context-quality-lifecycle.md` |
