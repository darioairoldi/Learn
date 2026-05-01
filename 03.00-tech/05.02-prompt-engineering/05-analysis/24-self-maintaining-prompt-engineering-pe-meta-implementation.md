---
title: "Self-maintaining PE: pe-meta implementation"
author: "Dario Airoldi"
date: "2026-05-01"
categories: [tech, prompt-engineering, github-copilot, agents, self-update]
description: "How pe-meta provides strategic oversight for the PE system — vision alignment, ecosystem coherence, quality bar enforcement, and self-update readiness assessment."
---

# Self-maintaining PE: pe-meta implementation

pe-meta is the **strategic oversight layer** of the self-maintaining prompt engineering system. While pe-gra operates on individual artifacts (one agent, one prompt at a time), pe-meta looks at the system as a whole — asking whether the PE infrastructure aligns with the vision, meets the quality bar, and maintains ecosystem coherence.

> **Series context:** This article covers the pe-meta tier. See the [system overview](23-self-maintaining-prompt-engineering-system-overview.md) for architecture and the [pe-gra implementation](25-self-maintaining-prompt-engineering-pe-gra-implementation.md) for per-artifact operations.

## Table of contents

- [Goal and strategy](#goal-and-strategy)
- [The 4 agents](#the-4-agents)
- [The 6 prompts](#the-6-prompts)
- [How to use pe-meta](#how-to-use-pe-meta)
- [Strategic review criteria](#strategic-review-criteria)
- [Design rationales](#design-rationales)
- [References](#references)

---

## Goal and strategy

pe-meta's goal is to ensure PE-for-PE artifacts (agents, prompts, context files, instructions, skills, templates that serve the PE system itself) meet a higher quality bar than domain artifacts. PE-for-PE artifacts are the **reference implementation** — when pe-gra-builder creates a new agent, it follows the patterns it sees in existing PE agents. Weak PE infrastructure produces weak domain artifacts.

The strategy has two dimensions:

**Structural + strategic double validation.** pe-meta doesn't replace pe-gra validation — it adds a strategic layer on top. Structural correctness (YAML syntax, tool alignment, boundary completeness) is necessary but insufficient. pe-meta checks vision alignment, category reference compliance, quality bar adherence, N-1 separation, and self-update readiness.

**Ecosystem coherence.** Individual artifacts can each be structurally correct yet contradict each other. pe-meta detects cross-artifact inconsistencies — rules that conflict between context files, agents that overlap in scope, handoff chains that don't connect.

---

## The 4 agents

All pe-meta agents live in `.github/agents/00.09-pe-meta/`:

| Agent | Mode | Role |
|---|---|---|
| `pe-meta-designer` | `agent` | Designs new PE-for-PE artifacts with vision alignment from the start |
| `pe-meta-researcher` | `plan` | Researches PE system health, discovers gaps, analyzes ecosystem changes |
| `pe-meta-optimizer` | `agent` | Applies validated improvements to PE artifacts |
| `pe-meta-validator` | `plan` | Validates ecosystem coherence across multiple artifacts |

### pe-meta-validator — the ecosystem auditor

The most distinctive pe-meta agent. While pe-gra validators check one artifact at a time, pe-meta-validator checks **cross-artifact coherence**: do rules in context file A contradict rules in context file B? Does agent X's boundary list conflict with agent Y's scope? Are handoff chains complete — does every `send: true` have a receiving agent?

### pe-meta-researcher — the strategic analyst

Researches system-wide health. Loads the vision document, scans for staleness, identifies improvement opportunities. Its output feeds pe-meta-optimizer or pe-meta-designer for action.

---

## The 6 prompts

All pe-meta prompts live in `.github/prompts/00.09-pe-meta/`:

| Prompt | Purpose | When to use |
|---|---|---|
| `/pe-meta-design` | Design new PE-for-PE artifacts with strategic alignment | Creating a new PE agent, prompt, or context file |
| `/pe-meta-create-update` | Create or update PE artifacts with vision validation | Modifying existing PE infrastructure |
| `/pe-meta-review` | Strategic review of any PE artifact | Auditing an artifact against vision + quality bar |
| `/pe-meta-update` | Run health checks (fullcheck, healthcheck, performancecheck) | Scheduled maintenance, post-release audit |
| `/pe-meta-scheduled-review` | Time-based periodic review of PE system health | Catching drift that event triggers missed |
| `/pe-meta-release-monitor` | Monitor VS Code/Copilot release notes for PE impact | After a platform release |

---

## How to use pe-meta

### Strategic review of a specific artifact

```
/pe-meta-review .github/agents/00.02-pe-granular/pe-gra-agent-builder.agent.md
```

This runs both structural validation (via pe-gra-validator dispatch) AND strategic validation (6 criteria from the strategic review criteria). Output is a combined report with structural score + strategic checklist + ecosystem impact assessment.

### System health check

```
/pe-meta-update healthcheck
```

Runs pe-meta-validator in ecosystem audit mode — scans for cross-artifact contradictions, broken handoff chains, stale references, and scope overlaps across the entire PE system.

### After a VS Code release

```
/pe-meta-release-monitor <release notes URL>
```

Analyzes release notes for PE-relevant changes (new YAML fields, tool behavior changes, deprecations), assesses which artifacts are affected, and proposes targeted updates.

### Review all artifacts in a tier

```
/pe-meta-review .github/agents/00.02-pe-granular/
```

Reviews all agents in the pe-gra tier against strategic criteria. Produces a cohort-level assessment with per-agent findings and cross-cutting issues.

---

## Strategic review criteria

pe-meta-review evaluates against 6 criteria (defined in `.copilot/context/00.00-prompt-engineering/05.06-pe-strategic-review-criteria.md`):

| # | Criterion | What it checks |
|---|---|---|
| 1 | **Vision alignment** | Does the artifact comply with applicable vision rationales (R-S1, R-S5, R-P4, etc.)? |
| 2 | **Category reference compliance** | Are context file references using Level 1.5 (category) rather than Level 2 (filename)? |
| 3 | **PE quality bar** | Does the artifact meet the "exemplary" standard (≥5/2/3 boundaries, handoff contracts, ≥3 test scenarios)? |
| 4 | **N-1 structural separation** | Do rule-bearing sections use `Rule`/`Rationale`/`Example` labeled blocks? |
| 5 | **Self-update readiness** | Which rollout phase is the artifact ready for? What's blocking the next phase? |
| 6 | **Ecosystem impact** | How many dependents? What's the blast radius of a change? |

---

## Design rationales

### Why a separate tier from pe-gra?

pe-gra answers "is this artifact structurally correct?" — a question about individual compliance. pe-meta answers "does this artifact serve the system's purpose?" — a question about strategic fit. These require different context: pe-gra loads artifact-type rules; pe-meta loads the vision document, the dependency map, and the strategic review criteria.

Combining them would overload individual validators with strategic context they don't need for most invocations. The separation keeps each agent focused and within token budget.

### Why `plan` mode for validator and researcher?

Strategic review is analysis, not modification. pe-meta-validator and pe-meta-researcher are read-only by design — they produce reports and recommendations. Only pe-meta-optimizer and pe-meta-designer have write access, and only after strategic analysis has been completed.

### Why 6 prompts instead of 1?

Each prompt has a distinct trigger and workflow. `/pe-meta-review` is artifact-scoped. `/pe-meta-update` is system-scoped. `/pe-meta-release-monitor` is event-driven. Combining them into a single prompt would require the LLM to disambiguate intent every invocation — wasting tokens and increasing error risk.

### Why the strategic review criteria live in a context file

The 6 criteria could be embedded in pe-meta-review's body. Instead, they're in a separate context file (05.06) that multiple consumers reference — pe-meta-review, pe-meta-design, pe-meta-create-update, and pe-meta-validator. Single source of truth prevents drift between consumers.

---

## References

- **pe-meta agents:** `.github/agents/00.09-pe-meta/`
- **pe-meta prompts:** `.github/prompts/00.09-pe-meta/`
- **Strategic review criteria:** `.copilot/context/00.00-prompt-engineering/05.06-pe-strategic-review-criteria.md`
- **System overview:** [Building a self-maintaining PE system](23-self-maintaining-prompt-engineering-system-overview.md)
- **pe-gra implementation:** [Self-maintaining PE: pe-gra implementation](25-self-maintaining-prompt-engineering-pe-gra-implementation.md)
