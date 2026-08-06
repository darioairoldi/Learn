# 05-reliability — system-reliability use cases

> **Pole:** Reliability (of the self-update process AND of artifacts).
> **Companion to:** [overview](../00-overview.md), [usecase-index.json](../usecase-index.json), [vision v13](../../20260523.01-vision.v13.md).

This folder addresses the **reliability** pole of the goal trio (reliability / effectiveness / efficiency). Every use case here has reliability of the system or of its artifacts as its primary subject — not as a self-property to score, but as the system property to validate.

---

## 📚 Dimension catalog

Dimension references in this README use the canonical `D#-readable-id` form defined in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). The catalog is the single source of truth for what each `D#-readable-id` and each `--dim` group resolves to.

**Primary `--dim` group for this folder:** `--dim reliability` (resolves to `D28-reproducibility` through `D35-portability-boundary`; see catalog § *Dimension groups*).

## 📐 Dimensions covered

Reliability dimensions plus the cross-cutting `D8-prioritization` (rationale precedence) exercised by at least one use case in this folder.

| Dimension | `--dim` group(s) | Realizing use case(s) |
|---|---|---|
| `D8-prioritization` | quality | [p2-02-conflict-resolution-coverage](p2-02-conflict-resolution-coverage-usecase.md) |
| `D28-reproducibility` | reliability | [p0-01-process-reproducibility](p0-01-process-reproducibility-usecase.md) |
| `D29-regression-protection` | reliability | [p0-02-regression-protection](p0-02-regression-protection-usecase.md), [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md) |
| `D30-metadata-guard` | reliability | [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) |
| `D31-multipass-validation-invariant` | reliability | [p1-02-multipass-validation-invariant](p1-02-multipass-validation-invariant-usecase.md) |
| `D32-rollback-readiness` | reliability | [p1-03-rollback-exercise](p1-03-rollback-exercise-usecase.md) |
| `D33-boundary-actionability` | reliability | [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam-usecase.md) |
| `D34-autonomy-calibration` | reliability | [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md), [p2-04-mode-vs-risk-decoupling-check](p2-04-mode-vs-risk-decoupling-check-usecase.md) |
| `D35-portability-boundary` | reliability | [p2-03-portability-boundary-scan](p2-03-portability-boundary-scan-usecase.md) |

---

## 🎯 Why this folder exists

The other four folders address freshness (cross-cutting), guidance quality (effectiveness), consumer adherence (effectiveness), and efficiency. None of them dedicates a use case to:

- Process reproducibility — does the same command on unchanged inputs produce the same outcome?
- Loop stability — do artifacts oscillate across runs?
- Multi-pass validation invariant — does every committed change have ≥1 independent validation pass?
- Rollback readiness — does the snapshot/restore drill succeed?
- Metadata-guard enforcement — does the pre-change/post-change protocol fire on every change?
- Boundary actionability — can the model verify its own scope/exclusion constraints at runtime?
- Autonomy calibration — do autonomy thresholds match observed outcome-log success rates?
- Conflict-resolution coverage — are all rationale-precedence rules exercised?
- Portability boundary — are all artifacts namespaced (`pe-` prefix) to avoid clashes on port?
- Mode-vs-risk decoupling — does the default `--mode plan` ever silently gate low-risk changes?

This folder fills the gap.

---

## 📋 Coverage matrix (vision anchors → use cases)

| Anchor | Vision reference | Use case |
|---|---|---|
| R1 — Loop stability | `scope.covers`: "Loop stability (convergence and oscillation detection)" | [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md) |
| R2 — Multi-pass validation invariant | R-L2-self-correction; "It doesn't mean: …skipping validation" | [p1-02-multipass-validation-invariant](p1-02-multipass-validation-invariant-usecase.md) |
| R3 — Reproducibility | Key definition of "Reliable" | [p0-01-process-reproducibility](p0-01-process-reproducibility-usecase.md) |
| R4 — Regression protection | Goal § "validated corrections"; risks § False confidence | [p0-02-regression-protection](p0-02-regression-protection-usecase.md) |
| R5 — Metadata-guard protocol | Boundary: "MUST trigger post-change metadata reconciliation" | [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) |
| R6 — Fail-closed on infra staleness | Boundary: "CRITICAL severity, never cached, never skipped" | [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) |
| R7 — Boundary actionability | Guidance-quality property 6: "can the model verify 'am I within scope?'" | [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam-usecase.md) |
| R8 — Rollback safety | R-S6-tier-blast-radius: tier-scoped group snapshots | [p1-03-rollback-exercise](p1-03-rollback-exercise-usecase.md) |
| R9 — Autonomy calibration | R-G3-progressive-learning: outcome-log feedback | [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md) |
| R10 — Conflict-resolution precedence | Rationale conflict-resolution table | [p2-02-conflict-resolution-coverage](p2-02-conflict-resolution-coverage-usecase.md) |
| R11 — Portability boundary | Boundary: "MUST use a namespace prefix… generic names not portable" | [p2-03-portability-boundary-scan](p2-03-portability-boundary-scan-usecase.md) |
| R12 — Mode-vs-risk decoupling | Goal § "Low-risk autonomy rule": command identity MUST NOT override risk | [p2-04-mode-vs-risk-decoupling-check](p2-04-mode-vs-risk-decoupling-check-usecase.md) |

Every anchor is addressed by at least one UC; some UCs cover multiple anchors.

---

## 🧭 Run order

Priority flow: `P0 → P1 → P2`.

### P0 — fundamentals (run every cycle)

1. [p0-01-process-reproducibility](p0-01-process-reproducibility-usecase.md) — same input twice → same diff
2. [p0-02-regression-protection](p0-02-regression-protection-usecase.md) — before/after snapshot on autonomous changes
3. [p0-03-metadata-guard-enforcement](p0-03-metadata-guard-enforcement-usecase.md) — pre/post-change protocol + fail-closed boundaries

### P1 — guardrails (run weekly or after structural change)

1. [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md) — oscillation / convergence
2. [p1-02-multipass-validation-invariant](p1-02-multipass-validation-invariant-usecase.md) — independent validation per commit
3. [p1-03-rollback-exercise](p1-03-rollback-exercise-usecase.md) — tier-scoped snapshot/restore drill
4. [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam-usecase.md) — runtime self-constraint stress test

### P2 — long-cycle health (run monthly or before autonomy promotion)

1. [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md) — outcome-log → gradient threshold
2. [p2-02-conflict-resolution-coverage](p2-02-conflict-resolution-coverage-usecase.md) — rationale precedence
3. [p2-03-portability-boundary-scan](p2-03-portability-boundary-scan-usecase.md) — namespace prefix scan
4. [p2-04-mode-vs-risk-decoupling-check](p2-04-mode-vs-risk-decoupling-check-usecase.md) — command default mode MUST NOT gate low-risk

---

## ⚙️ Entry points

```text
/pe-meta-review <path> --dim reliability                              # full reliability audit
/pe-meta-review --mode plan --skip research --dim reliability         # quick reliability pass
/pe-meta-scheduled-review --dim reliability --deps full               # rotation-triggered
/pe-meta-review .copilot/ --dim reliability --mode plan               # assessment-only
```

`--dim reliability` resolves to the reliability dimensions in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). See workstream 3 of the originating issue ([20260524.03](../../../../src/docs/90.%20Issues/202605/20260524.03-use-cases-have-no-reliabilitychecks/01.03-pe-meta-update-plan.md)) for the dimension specification.

---

## 🔗 Related folders

- [`01-freshness/`](../01-freshness/00-overview.md) — staleness drives the need for reliable corrections
- [`02-quality-gates/`](../02-quality-gates/00-overview.md) — guidance quality is a precondition for reliable autonomous behavior (R-S9)
- [`03-consumer-correctness/`](../03-consumer-correctness/00-overview.md) — adherence is what reliable enforcement *produces*; this folder validates the *enforcement mechanism itself*
- [`04-efficiency/`](../04-efficiency/00-overview.md) — efficiency MUST NOT trade away reliability (R-L2 vs R-P2)
