# UC-23: Design/review parity

> **Group:** 02-quality-gates
> **Priority:** P1
> **Order in group:** 5
> **Vision anchor:** design-review-parity (scope.covers, P1)
> **Default breadth:** full
> **Dimensions:** D6-consistency, D7-non-redundancy, D8-prioritization, D9-clarity, D10-completeness, D11-actionability, D16-adherence
> **Command family:** Review / Creation
> **Primary entry point:** `/pe-meta-review <path> --dim quality`
> **Allowed option classes:** dim, scope, deps, skip
> **Scope mechanism:** positional path | type-token | default-all

## 🎯 Purpose

Verify that an artifact produced by a design (creation) pass meets the **same** guidance-quality bar that a standalone review pass would enforce — so an artifact can never ship below the review threshold simply because it was authored rather than reviewed. Design and review share **one** quality objective and **one** scope intent; they differ only in process role (design mutates by intent; review proposes), per the vision `design-review-parity` contract.

## ⚙️ Invocation

**Command family:** Review / Creation
**Primary entry point:** `/pe-meta-review <path> --dim quality`

The parity gate has two reciprocal sides:

- **Design side (creation):** each `pe-meta-{type}-design` prompt runs the applicable review dimension set as its final step before an artifact is marked done — it invokes this command's quality assessment, applicability-scoped to the artifact type, via `@pe-meta-validator`.
- **Review side:** the unified `/pe-meta-review` command holds the same six guidance-quality properties through its quality dimensions and, when strategic dimensions are selected, its conditional Phase 4.5 strategic validation.

**Invocation examples:**
```
/pe-meta-review .github/agents/00.09-pe-meta/pe-meta-validator.agent.md --dim quality
/pe-meta-review --mode plan --skip research --dim quality
/pe-meta-review .github/prompts/00.09-pe-meta/ --dim quality --deps direct
```

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim quality` | Limits to the six guidance-quality properties shared by design and review |
| `--dim strategic` | Adds vision-alignment / adherence checks (triggers Phase 4.5 on the review side) |
| `--scope <type-token>` | Restricts the parity check to one artifact type |
| `--deps direct` | Includes immediately referenced guidance in the parity assessment |
| `--skip research,structure` | Focus on content-quality parity only |

## 🔬 Behavior

1. A design pass authors or mutates an artifact (context, instruction, agent, prompt, skill, template, hook, or snippet).
2. Before the artifact is marked done, the design prompt invokes the applicable review dimension set — the same six guidance-quality properties a standalone review would assess — applicability-scoped to the artifact type.
3. The shared quality objective is applied identically: design output is held to the review threshold, not a relaxed authoring threshold.
4. Findings below threshold block completion of the design pass exactly as they would block a review-proposed change.
5. On the review side, `/pe-meta-review --dim quality` asserts the same six properties; with `--dim strategic`, conditional Phase 4.5 adds vision-alignment / adherence on a separate advisory severity channel.
6. The reciprocal obligation is symmetric: neither role may define a lower quality objective than the other; process optimization may change cost or execution posture but MUST NOT lower the quality bar for either role (vision § conflict resolution — *Process optimization vs design/review parity*).

## 📐 Dimensions covered

This use case exercises the six guidance-quality properties plus adherence (design output adheres to the review bar). Dimension ids are defined in the canonical [dimension catalog](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md):

- `D6-consistency`
- `D7-non-redundancy`
- `D8-prioritization`
- `D9-clarity`
- `D10-completeness`
- `D11-actionability`
- `D16-adherence`

## 🔗 Related use cases

- [p0-01-guidance-quality-assessment](p0-01-guidance-quality-assessment-usecase.md) — defines the six-property quality bar that this use case enforces on the design side
- [p1-01-consistency-check](p1-01-consistency-check-usecase.md) — the `D6-consistency` property in isolation
- [p2-02-vision-alignment-check](p2-02-vision-alignment-check-usecase.md) — the strategic dimensions that Phase 4.5 adds on the review side

## 🚦 Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Inherits the determinism profile of the six guidance-quality properties — `D7-non-redundancy` / `D8-prioritization` partly grep-anchored; `D6-consistency`, `D9-clarity`, `D10-completeness`, `D11-actionability` require LLM judgment |
| **False positives** | MEDIUM — same subjectivity as the underlying quality dimensions |
| **Consistency** | ✅ Parity itself is a structural guarantee: design and review invoke the *same* dimension set, so cross-role drift is eliminated by construction |

**Reliability score: MEDIUM** — the parity contract removes cross-role inconsistency by design, but the shared dimensions retain their own LLM-dependent variability.

## 💰 Cost & efficiency

The design side adds the cost of one quality assessment per artifact at authoring time; this is offset by catching below-threshold guidance before it enters the ecosystem, where it would otherwise be caught later by a standalone review at higher remediation cost. Bounded by `--scope` (one artifact type) and `--skip` (content-only).

**Efficiency score: MEDIUM** — front-loaded cost with net savings from earlier defect capture.
