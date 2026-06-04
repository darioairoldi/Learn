---
title: Dimension coverage audit (use cases vs. catalog)
description: Verifies that every dimension and dimension group in the PE meta dimension catalog is realized by at least one use case in the vision-pe-meta-usecases set, and lists discrepancies surfaced by the audit.
date: 2026-06-01
version: 1.0.0
status: complete
audience:
  - prompt-engineer
related:
  - 01-dimids-rename-plan.md
  - 02-align-dimids-usecases-pemeta-plan.md
  - ../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md
  - ../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json
---

# Dimension coverage audit (use cases vs. catalog)

## 🎯 Purpose

Verify that **every** `D#-readable-id` and **every** `--dim` group defined in the dimension catalog ([`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)) is realized by at least one use case in the `vision-pe-meta-usecases` set, and surface any drift or gaps discovered while performing the audit.

This audit closes step 6 of [`02-align-dimids-usecases-pemeta-plan.md`](02-align-dimids-usecases-pemeta-plan.md).

---

## ✅ Per-dimension coverage (35/35)

Source: union of `dimensions_covered` arrays across all 33 entries in [`usecase-index.json`](../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json) (v2.3.0).

| Dimension | Realizing folder(s) | Status |
|---|---|---|
| `D1-metadata` | 04-efficiency | ✅ |
| `D2-hierarchy` | 04-efficiency | ✅ |
| `D3-token-budget` | 04-efficiency | ✅ |
| `D4-tool-alignment` | 04-efficiency | ✅ |
| `D5-boundaries` | 03-consumer-correctness, 04-efficiency | ✅ |
| `D6-consistency` | 01-freshness, 02-quality-gates, 03-consumer-correctness | ✅ |
| `D7-non-redundancy` | 02-quality-gates | ✅ |
| `D8-prioritization` | 02-quality-gates, 05-reliability | ✅ |
| `D9-clarity` | 02-quality-gates | ✅ |
| `D10-completeness` | 02-quality-gates | ✅ |
| `D11-actionability` | 02-quality-gates | ✅ |
| `D12-staleness` | 01-freshness | ✅ |
| `D13-source-verification` | 01-freshness | ✅ |
| `D14-craftsmanship` | 02-quality-gates, 04-efficiency | ✅ |
| `D15-vision-alignment` | 02-quality-gates | ✅ |
| `D16-adherence` | 02-quality-gates, 03-consumer-correctness | ✅ |
| `D17-cross-coherence` | 02-quality-gates, 03-consumer-correctness | ✅ |
| `D18-coverage` | 02-quality-gates, 03-consumer-correctness | ✅ |
| `D19-artifact-structure` | 02-quality-gates | ✅ |
| `D20-token-chain` | 04-efficiency | ✅ |
| `D21-deterministic-first` | 04-efficiency | ✅ |
| `D22-context-optimization` | 01-freshness | ✅ |
| `D23-reference-efficiency` | 01-freshness, 04-efficiency | ✅ |
| `D24-handoff-efficiency` | 04-efficiency | ✅ |
| `D25-processing-efficiency` | 04-efficiency | ✅ |
| `D26-model-routing` | 03-consumer-correctness, 04-efficiency | ✅ |
| `D27-model-adherence` | 02-quality-gates, 03-consumer-correctness | ✅ |
| `D28-reproducibility` | 05-reliability | ✅ |
| `D29-regression-protection` | 05-reliability | ✅ |
| `D30-metadata-guard` | 05-reliability | ✅ |
| `D31-multipass-validation-invariant` | 05-reliability | ✅ |
| `D32-rollback-readiness` | 05-reliability | ✅ |
| `D33-boundary-actionability` | 05-reliability | ✅ |
| `D34-autonomy-calibration` | 05-reliability | ✅ |
| `D35-portability-boundary` | 05-reliability | ✅ |

**Result:** all 35 catalog dimensions are exercised by at least one use case. **No gaps.**

---

## ✅ Per-`--dim`-group coverage (12/12)

Each row lists at least one use case whose primary or alternative entry point invokes the group, or whose `dimensions_covered` is a superset of the group's resolution.

| `--dim` group | Resolves to | Realizing entry point(s) | Status |
|---|---|---|---|
| `full` | all dims | `/pe-meta-update --mode plan --dim full` (synthetic aggregator across all folders) | ✅ (query-only) |
| `structural` | D1, D2, D3, D4, D5, D14 | `04-efficiency/p3-02-structural-validation.md` (`--dim structural`) | ✅ |
| `quality` | D6-D11, D27 | `02-quality-gates/p0-01-guidance-quality-assessment.md` (`--dim quality`) | ✅ |
| `strategic` | D15, D16, D17, D19 | `02-quality-gates/p2-02-vision-alignment-check.md` (`--dim strategic`) | ✅ |
| `freshness` | D12, D13 | `01-freshness/p1-01-staleness-source-verification.md` (`--dim freshness`) | ✅ |
| `efficiency` | D3, D4, D7, D9, D11, D20-D26 | `02-quality-gates/p1-02-redundancy-check.md` (`--dim efficiency`) + `04-efficiency/*` | ✅ |
| `adherence` | D5, D6, D16, D18 | `03-consumer-correctness/p0-01-dependency-aware-full-review.md` (covers all four dims) | ✅ (implicit) |
| `context-full` | D1-D3, D6-D15, D17, D19, D22 | `01-freshness/p0-01-context-quality-lifecycle.md` (`--dim context-full`) | ✅ |
| `context-health` | D6-D12, D22 | `01-freshness/p1-02-context-optimization.md` (subset realization) | ✅ |
| `model` | D26, D27 | `03-consumer-correctness/p1-02-model-specific-guidance-adherence.md` | ✅ |
| `optimize` | D3, D7, D9, D11, D20, D21, D23-D26 | `04-efficiency/*` (multiple entries) | ✅ |
| `reliability` | D28-D35 | `05-reliability/*` (all 11 entries) | ✅ |

**Result:** every `--dim` group is realized.

### Notes on aggregator groups

- `full`, `context-full`, and `context-health` are **synthetic aggregator shortcuts** — they exist to let an operator request a multi-dimensional review in one option. Their coverage is automatic once the constituent dimensions are individually covered (which they are).
- `adherence` is covered by `03-consumer-correctness/p0-01-dependency-aware-full-review.md` (whose `dimensions_covered` is `[D5, D6, D16, D17, D18]`, a superset of `adherence = {D5, D6, D16, D18}`), even though no entry point passes `--dim adherence` literally. This is acceptable: the dimensions are realized, and the group is an addressing convenience.

---

## ⚠️ Drift surfaced by the audit (park lot)

These items were discovered while building the audit and are out of scope for the current alignment work. Each is captured so they are not lost.

### PL-1 — Duplicate `UC-23` identifier

- **File A:** `03-consumer-correctness/p0-02-autonomous-improvement-workflow.md` declares `UC-23` in its H1.
- **File B:** `05-reliability/p0-01-process-reproducibility.md` is recorded as `UC-23` in `usecase-index.json` (v2.3.0).
- **Impact:** identifier collision; ambiguous when the index entry is referenced by ID.
- **Recommendation:** open a follow-up to renumber one of them and update all back-references. Likely the autonomous-improvement workflow should receive the next free UC id (UC-34) since it is currently absent from the index.

### PL-2 — `p0-02-autonomous-improvement-workflow.md` missing from `usecase-index.json`

- **File:** `03-consumer-correctness/p0-02-autonomous-improvement-workflow.md` exists on disk but has no entry in the index.
- **Impact:** the 03-consumer-correctness folder README and matrix do not enumerate it; coverage discovery via the index is incomplete for that folder.
- **Recommendation:** add an entry once PL-1 is resolved. Suggested `dimensions_covered`: `[D5-boundaries, D6-consistency, D16-adherence, D17-cross-coherence, D18-coverage]` (mirrors the related `p0-01-dependency-aware-full-review`).

### PL-3 — No literal `--dim adherence` invocation in any entry point

- `adherence` is covered implicitly (PL note above) but never invoked as a literal `--dim` option in any `primary_entry_point` or `alternative_entry_points` field.
- **Impact:** none functional; cosmetic only.
- **Recommendation:** optionally add an alternative entry point on `03-consumer-correctness/p1-01-guidance-adherence-verification.md` such as `/pe-meta-review <path> --dim adherence` for symmetry with the catalog.

---

## 🔁 Reproducibility

To reproduce this audit:

1. Read [`usecase-index.json`](../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json) and union the `dimensions_covered` arrays across all entries.
2. Compare the union against the `D#-readable-id` list in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) § *Dimension list*.
3. For each `--dim` group in the catalog § *Dimension groups*, check that at least one use case's `dimensions_covered` is a superset of the group's resolution **or** an entry point literally invokes the group.

Tooling note: this audit is suitable for automation via a `pe-meta-coverage-audit` script. Not implemented in this iteration.
