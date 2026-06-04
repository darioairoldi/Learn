# UC-23: Process reproducibility

> **Group:** 05-reliability — system-reliability validation
> **Priority:** P0
> **Order in group:** 1
> **Vision anchor:** R3 — Key definition of "Reliable" — "produces consistent, predictable outcomes across invocations"

## Purpose 🎯

Verify that the self-update system is **reproducible**: running the same command twice on unchanged inputs MUST produce the same observable outcome (same findings set, same proposed diffs, same risk classification). Non-deterministic divergence is a CRITICAL reliability defect — it invalidates the "validated corrections" guarantee.

## Invocation ⚙️

**Command family:** Review
**Primary entry point:** `/pe-meta-review <path> --dim reliability --skip apply`
**Alternative entry points:**

- `/pe-meta-update --mode plan --skip research --dim reliability` (scheduled rotation entry)
- `/pe-meta-scheduled-review --dim reliability --deps none` (rotation)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Reliability dimensions including `D28-reproducibility` |
| `--scope <type\|path>` | Narrow the reproducibility check to one artifact type or path |
| `--deps none\|direct\|full` | Whether dependency artifacts are included in the second run |
| `--mode plan` | Assessment-only (default for this UC — we are measuring the system, not changing it) |
| `--skip research` | Skip external-source fetch to isolate determinism from network variability |

## Behavior 🔬

1. **Snapshot inputs.** Hash all in-scope artifact files plus the outcome-log tail position.
2. **Run pass A.** Execute the target command in `--mode plan` and capture its full findings report (JSON-normalized).
3. **Verify inputs unchanged.** Re-hash; if any file changed between runs, abort with a contamination notice.
4. **Run pass B.** Re-execute with identical arguments and capture its findings report.
5. **Diff A vs B.** Canonical diff on:
   - Findings IDs and severities
   - Proposed diffs (normalized; ignore timestamps)
   - Risk classifications
   - Cost estimates (within ±5% tolerance)
6. **Emit verdict.** PASS if the diff is empty (or within declared tolerance); FAIL otherwise with the divergent fields surfaced.

**Invocation examples:**

```text
/pe-meta-review .github/agents/ --dim reliability --skip research
/pe-meta-update --mode plan --dim reliability --skip research --scope context
```

## Dimensions covered 📐

`D28-reproducibility` — primary.
`D31-multipass-validation-invariant` — sanity check that the second pass actually ran.

## Reliability analysis 🚦

This UC is a **meta-check on the reliability pole itself**. If it fails, no other UC in this folder can be trusted: rollback drills, regression checks, and metadata-guard enforcement all assume that "running the same command twice gives the same answer." Treat sustained PASS as a prerequisite for promoting any artifact set toward higher autonomy phases.

**Known sources of legitimate divergence** (must be allowlisted):

- Timestamps inside outcome-log entries (normalize before diff)
- External fetch payloads (use `--skip research` for this UC)
- Model-routing fallbacks logged when a primary model is unavailable (must be reported, not silently absorbed)

## Cost & efficiency 💰

Two full passes — roughly 2× a single `--dim reliability` run. Recommend running on a narrow `--scope` for routine scheduled execution; widen to full system before autonomy-promotion decisions.

## Related use cases 🔗

- [p0-02-regression-protection](p0-02-regression-protection-usecase.md) — regression check assumes reproducibility holds
- [p1-01-loop-stability-audit](p1-01-loop-stability-audit-usecase.md) — different concept: state-trajectory stability across N runs vs. output-equivalence across 2 runs
- [p1-02-multipass-validation-invariant](p1-02-multipass-validation-invariant-usecase.md) — multi-pass on changes vs. multi-run on assessments
