# Consumer correctness use cases

## 🎯 Purpose
Use these cases when the main concern is whether prompts and agents correctly implement the guidance they load and produce the expected quality.

## 📚 Dimension catalog

Dimension references in this README use the canonical `D#-readable-id` form defined in [`05.07-pe-meta-dimension-catalog.md`](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). The catalog is the single source of truth for what each `D#-readable-id` and each `--dim` group resolves to.

**Primary `--dim` groups for this folder:** `--dim adherence`, `--dim model` (see catalog § *Dimension groups*).

## 📐 Dimensions covered

| Dimension | `--dim` group(s) | Realizing use case(s) |
|---|---|---|
| `D5-boundaries` | structural / adherence | [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md) |
| `D6-consistency` | quality / adherence | [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md) |
| `D16-adherence` | strategic / adherence | [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md), [p0-02-autonomous-improvement-workflow](p0-02-autonomous-improvement-workflow-usecase.md), [p1-01-guidance-adherence-verification](p1-01-guidance-adherence-verification-usecase.md) |
| `D17-cross-coherence` | strategic | [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md) |
| `D18-coverage` | quality / adherence | [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md) |
| `D26-model-routing` | optimize / model | [p1-02-model-specific-guidance-adherence](p1-02-model-specific-guidance-adherence-usecase.md) |
| `D27-model-adherence` | quality / model | [p1-02-model-specific-guidance-adherence](p1-02-model-specific-guidance-adherence-usecase.md) |

## ⚙️ Recommended command entry points

| Scenario | Command | Options |
|---|---|---|
| Full dependency-aware review | `/pe-meta-review <path>` | `--deps full` |
| Guidance-first adherence check | `/pe-meta-adherence <guidance-path>` | (default: `--mode apply` — autonomous improvement for low-risk findings) |
| Consumer-side adherence check | `/pe-meta-agent-review <path>` | `--dim adherence --deps direct` |
| Model-specific guidance adherence | `/pe-meta-adherence 03.02-model-specific-optimization.md` | `--scope agents,prompts` |
| Scheduled adherence rotation | `/pe-meta-scheduled-review` | `--deps full` (every 4th run delegates to adherence) |

**Allowed option classes:** `--dim`, `--scope`, `--deps`, `--skip`, `--mode` (default `apply`; use `plan` to opt into assessment-only output)

**Routing note:** For guidance-first flows, always use `/pe-meta-adherence` directly. Don't overload review commands with adherence intent — the adherence command inverts the direction (starts from guidance, enumerates consumers).

## 📋 Run order
1. [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review-usecase.md) — end-to-end correctness baseline.
2. [p0-02-autonomous-improvement-workflow](p0-02-autonomous-improvement-workflow-usecase.md) — full investigate → reason → validate → apply flow (demonstrates Create/Review parity).
3. [p1-01-guidance-adherence-verification](p1-01-guidance-adherence-verification-usecase.md) — rule-to-consumer adherence check.
4. [p1-02-model-specific-guidance-adherence](p1-02-model-specific-guidance-adherence-usecase.md) — verifies target-model prompting quality.

## ✅ When to start here
- Generated output quality regression.
- Consumer behavior not matching guidance.
- Critical prompt or agent validation before release.
