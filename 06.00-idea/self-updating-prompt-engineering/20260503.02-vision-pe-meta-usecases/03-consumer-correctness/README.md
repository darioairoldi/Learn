# Consumer correctness use cases

## 🎯 Purpose
Use these cases when the main concern is whether prompts and agents correctly implement the guidance they load and produce the expected quality.

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
1. [p0-01-dependency-aware-full-review](p0-01-dependency-aware-full-review.md) — end-to-end correctness baseline.
2. [p0-02-autonomous-improvement-workflow](p0-02-autonomous-improvement-workflow.md) — full investigate → reason → validate → apply flow (demonstrates Create/Review parity).
3. [p1-01-guidance-adherence-verification](p1-01-guidance-adherence-verification.md) — rule-to-consumer adherence check.
4. [p1-02-model-specific-guidance-adherence](p1-02-model-specific-guidance-adherence.md) — verifies target-model prompting quality.

## ✅ When to start here
- Generated output quality regression.
- Consumer behavior not matching guidance.
- Critical prompt or agent validation before release.
