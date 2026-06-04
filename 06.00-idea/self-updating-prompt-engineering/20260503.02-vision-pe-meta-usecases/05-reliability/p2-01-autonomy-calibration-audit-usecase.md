# UC-30: Autonomy calibration audit

> **Group:** 05-reliability
> **Priority:** P2
> **Order in group:** 8
> **Vision anchor:** R9 — R-G3-progressive-learning: "outcome log informs threshold tuning"

## Purpose 🎯

Verify the **autonomy gradient stays calibrated to observed outcomes**. If autonomous changes are rolling back at >5%, the autonomous threshold is too loose. If autonomous changes are 100% success but human-approval queue is overflowing with trivial fixes, the threshold is too tight. This UC turns the outcome log into a calibration recommendation.

## Invocation ⚙️

**Command family:** Review (long-cycle)
**Primary entry point:** `/pe-meta-review --dim reliability --mode plan`
**Alternative entry points:**

- `/pe-meta-scheduled-review --dim reliability` (rotation; monthly cadence recommended)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages autonomy-calibration audit (`D34-autonomy-calibration`) |
| `--scope <type>` | Recommended to scope by artifact type — thresholds may differ per type |
| `--mode plan` | Default — emits calibration recommendation; threshold change is human-only |
| `--skip research` | Skip external evidence (audit is internal log analysis) |

## Behavior 🔬

1. **Window selection.** Rolling 30/60/90-day windows on `outcome-log.jsonl`.
2. **Metrics computed per window:**
   - `autonomous_success_rate` = success / (success + rolled_back) for `autonomy_level: autonomous`
   - `notify_success_rate` = same for `autonomy_level: notify`
   - `human_approval_queue_depth` = entries pending human action
   - `human_rejection_rate` = rejected / (approved + rejected) for `autonomy_level: human_required`
   - `escalation_appropriateness` = of human-required entries, what fraction the human approved with no change (suggests over-escalation)
3. **Threshold-vs-outcome comparison.** For each metric, compare against the vision's declared targets (e.g., success criterion #8: >95%).
4. **Recommendations.**
   - Below target → suggest tightening threshold for the affected change class.
   - Above target with high human-approval rate on trivial items → suggest loosening.
   - Recommendations include the specific gradient row to adjust and an estimated outcome.
5. **Human-only escalation.** Threshold changes require human approval — this UC does NOT autonomously adjust the gradient.

## Dimensions covered 📐

`D34-autonomy-calibration` — primary.
`D29-regression-protection` — input signal.

## Reliability analysis 🚦

R-G3 makes calibration a *system property*, not a one-time configuration. Without periodic recalibration, the gradient drifts: software evolves, artifact mix changes, model capabilities change. This UC is the operational expression of R-G3.

The hard rule: this UC **proposes**, the human **disposes**. Vision changes are human-only (vision boundary), and the autonomy gradient is part of the vision.

## Cost & efficiency 💰

Pure log analysis — near-zero cost. Optional LLM call for recommendation phrasing. Should run monthly minimum, weekly during autonomy-phase transitions.

## Related use cases 🔗

- [p1-02-multipass-validation-invariant](p1-02-multipass-validation-invariant-usecase.md) — invariant must hold before calibration is meaningful
- [p1-04-boundary-actionability-redteam](p1-04-boundary-actionability-redteam-usecase.md) — probe failures feed into calibration signal
- [p0-02-regression-protection](p0-02-regression-protection-usecase.md) — rollback rate is a primary calibration input
