# UC-29: Boundary actionability red-team

> **Group:** 05-reliability
> **Priority:** P1
> **Order in group:** 7
> **Vision anchor:** R7 — Guidance-quality property 6 (Actionability): "Can the model verify 'am I within scope?'"

## 🎯 Purpose

Adversarially test whether artifact **boundary declarations are actionable at runtime**. A boundary that looks crisp on paper but cannot be self-enforced by the agent ("am I within scope?") is a latent reliability defect: the agent will drift past the boundary without noticing, and no review will catch the drift until output quality degrades.

## ⚙️ Invocation

**Command family:** Review (red-team / adversarial)
**Primary entry point:** `/pe-meta-review <path> --dim reliability --mode plan`
**Alternative entry points:**

- `/pe-meta-adherence <path> --dim reliability` (guidance-first family — traces boundary statements to consumer behavior)

**Supported options:**

| Option | Relevance |
|---|---|
| `--dim reliability` | Engages boundary-actionability red-team (D33) |
| `--scope <type\|path>` | Narrow to an artifact type with declared boundaries (agents, prompts) |
| `--deps direct` | Include rules the boundary references |
| `--mode plan` | Default — red-team produces findings, not edits |
| `--skip research` | Optional — focus on internal boundary parsing only |

## 🔬 Behavior

### Phase A: Boundary extraction

For each in-scope artifact, parse the `boundaries:` block (YAML metadata) and the prose "MUST NOT" / "out of scope" statements in the body.

### Phase B: Actionability rubric

For each boundary statement, ask:

1. Can it be expressed as a boolean check on input or state?
2. Does the artifact provide the inputs needed to evaluate that check at runtime?
3. Is the failure mode specified (refuse / escalate / proceed-with-notice)?

Severity:

- All three Yes → **PASS** (actionable)
- One No → **MEDIUM** (needs rewording)
- Two or three No → **HIGH** (latent drift risk)

### Phase C: Red-team probes (when `--dim reliability` is engaged with `--deps direct`)

Generate 3–5 adversarial probes per artifact that target each boundary:

1. Input that sits exactly on the boundary edge.
2. Input that legitimately invokes a tangent the boundary forbids.
3. Input where the boundary's evaluation depends on context the agent does not have.

For each probe, simulate the agent response (LLM judgment) and check whether the agent invokes the declared failure mode. Cases where the agent proceeds despite the boundary → **HIGH** finding with the probe captured for the regression suite.

## 📐 Dimensions covered

D33 (boundary-actionability) — primary.
D7 (boundary precision) — secondary.

## 🚦 Reliability analysis

This UC operationalizes the vision's claim that guidance-quality property 6 is a precondition for autonomy. The red-team is the only deterministic way to confirm a boundary is more than rhetorical. Failures here should block autonomy-phase promotion (Phase 2→3) for the affected artifact.

## 💰 Cost & efficiency

Phase A is near-zero cost. Phase B is LLM-light (rubric grading). Phase C is LLM-heavy (probe synthesis + response simulation) — gate on `--deps direct` or higher to avoid running it on every cycle. Recommend running Phase C on a rotating subset of agents per cycle.

## 🔗 Related use cases

- [p2-01-autonomy-calibration-audit](p2-01-autonomy-calibration-audit.md) — failed probes feed the calibration signal
- [02-quality-gates/p0-01-context-quality-lifecycle](../02-quality-gates/p0-01-context-quality-lifecycle.md) — measures guidance quality properties; this UC stress-tests property 6 specifically
- [03-consumer-correctness/](../03-consumer-correctness/README.md) — adherence relies on boundaries actually being enforced
