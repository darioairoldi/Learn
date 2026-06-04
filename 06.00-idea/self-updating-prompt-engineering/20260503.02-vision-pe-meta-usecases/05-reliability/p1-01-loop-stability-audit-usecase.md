# UC-26: Loop stability audit

> **Group:** 05-reliability
> **Priority:** P1
> **Order in group:** 4
> **Vision anchor:** R1 — `scope.covers`: "Loop stability (convergence and oscillation detection)"

## Purpose 🎯

Detect **artifact-state oscillation**: an artifact whose content is flipped back and forth across self-update runs (e.g., a context file alternately gains and loses a section because two rules pull in opposite directions). Loop stability is in the vision's `scope.covers` but has no validating UC today.

## Invocation ⚙️

**Command family:** Review / Scheduled
**Primary entry point:** `/pe-meta-review --dim reliability --deps full`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation; this UC is a natural fit for periodic execution)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages loop-stability scan (`D29-regression-protection` loop-stability) |
| `--scope <type\|path>` | Narrow to an artifact type or path |
| `--deps full` | Include dependents whose oscillation may be triggered by upstream churn |
| `--mode plan` | Default — reports oscillation; remediation routed to specific update flows |

## Behavior 🔬

1. **Window selection.** Read the last N runs from `outcome-log.jsonl` (default N=20; tunable).
2. **Per-artifact state trajectory.** For each artifact touched in the window, build the sequence of content-hash transitions: `[h1 → h2 → h3 → …]`.
3. **Detect oscillation patterns:**
   - **Direct flip**: `h1 → h2 → h1 → h2` (≥2 flips between two states) — HIGH
   - **Bounded cycle**: A → B → C → A (returns to a prior state within window) — MEDIUM
   - **Drift then revert**: A → B → A (one round-trip) — LOW (informational)
4. **Root-cause hint.** For each oscillation, surface the triggering rationale pair from the conflict-resolution table when identifiable.
5. **Output.** Findings list, severity, suggested resolution (typically: explicit precedence rule in the conflict-resolution table).

## Dimensions covered 📐

`D29-regression-protection` — primary.
`D17-cross-coherence` — secondary (oscillation often arises from cross-artifact contradiction).

## Reliability analysis 🚦

Oscillation is the canonical failure mode of a self-update loop without explicit conflict-resolution rules. The system can pass every individual review and still oscillate across runs. This UC is the only place oscillation is detectable, because it requires *cross-run* state.

Coordinate with [p2-02-conflict-resolution-coverage](p2-02-conflict-resolution-coverage-usecase.md): if oscillation is detected, the missing precedence rule is added there.

## Cost & efficiency 💰

Low — single pass over `outcome-log.jsonl` plus content-hash diffs. No LLM call needed for detection; LLM only invoked for root-cause hint synthesis (optional, gated by `--mode plan` verbosity).

## Related use cases 🔗

- [p2-02-conflict-resolution-coverage](p2-02-conflict-resolution-coverage-usecase.md) — remediation target for detected oscillations
- [p0-01-process-reproducibility](p0-01-process-reproducibility-usecase.md) — different scope: reproducibility is single-input determinism; this UC is multi-run stability
- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit-usecase.md) — oscillation rate is an input signal for autonomy-threshold tuning
