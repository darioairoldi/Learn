---
title: "Building a self-maintaining prompt engineering system"
author: "Dario Airoldi"
date: "2026-05-01"
categories: [tech, prompt-engineering, github-copilot, agents, self-update]
description: "Architecture overview of a system that maintains its own prompt engineering artifacts — detecting drift, assessing impact, and executing validated corrections with risk-calibrated autonomy."
---

# Building a self-maintaining prompt engineering system

Prompt engineering artifacts form a layered system where every layer depends on the ones below it. A context file defines a rule. An instruction file references that rule. An agent enforces it. A prompt orchestrates the agent. This architecture works well when it's fresh — but it decays through three forces: platform drift (VS Code ships monthly, Copilot evolves weekly), internal drift (subtle inconsistencies accumulate as you add artifacts), and ecosystem evolution (external best practices improve upon what you've built).

All three forces share the same outcome: **the system silently degrades**. Manual audits catch it eventually, but "eventually" is the failure mode.

This article describes a system that maintains itself — using the same agents and prompts it manages to detect, assess, and fix its own drift.

> **Series context:** This is a case study applying patterns from [How to Design Orchestrator Prompts](../04-howto/10.00-how_to_design_orchestrator_prompts.md) and [How to Design Subagent Orchestrations](../04-howto/11.00-how_to_design_subagent_orchestrations.md). The implementation articles cover [pe-meta](31-self-maintaining-prompt-engineering-pe-meta-implementation.md) (strategic oversight) and [pe-gra](32-self-maintaining-prompt-engineering-pe-gra-implementation.md) (per-artifact operations).

## Table of contents

- [The problem: silent degradation](#the-problem-silent-degradation)
- [The goal](#the-goal)
- [Architecture: three tiers](#architecture-three-tiers)
- [The self-update cycle](#the-self-update-cycle)
- [Key design decisions](#key-design-decisions)
- [What makes it work in practice](#what-makes-it-work-in-practice)
- [Current status and limitations](#current-status-and-limitations)
- [References](#references)

---

## The problem: silent degradation

Silent degradation takes two forms that require different responses.

**Structural staleness** — dangling references, stale validation timestamps, broken chain alignment, mismatched metadata. These are deterministic to detect. A `grep_search` for a renamed file finds every broken reference. Fail-closed is the right response.

**Capability staleness** — the artifacts still parse, still reference-resolve, still pass structural checks, but the logic they encode is obsolete. A new model family is released and existing model-specific guidance is outdated. A feature moves from preview to GA and the "preview limitations" note remains. Capability staleness passes all integrity checks yet produces progressively worse outputs. This is the harder variant — and the primary motivating concern.

---

## The goal

Build a self-update system that maintains PE artifacts at peak **reliability** (consistent outcomes), **effectiveness** (achieving stated purpose), and **efficiency** (minimal resource consumption) — with the maximum degree of **autonomy** that assessed risk allows.

### The autonomy gradient

Autonomy isn't binary. It's a gradient calibrated to assessed risk:

| Level | Scope | Examples |
|---|---|---|
| **Autonomous** | Low impact, high confidence | Reference updates, formatting, stale timestamps |
| **Autonomous + notify** | Low-medium impact, validated | Redundancy removal, adding metadata fields |
| **Human approval** | High impact or medium confidence | Restructuring artifacts, changing rules |
| **Human-only** | Architectural or strategic | Vision changes, principle modifications |

Each proposed change carries an assessed risk level (impact × confidence). Changes below the threshold proceed automatically. Changes above escalate — only the individual step, not the whole change-set.

---

## Architecture: three tiers

The system is organized into three operational tiers, each with a distinct role:

```
┌─────────────────────────────────────────────┐
│  pe-meta (Tier 0.09)                        │
│  Strategic oversight — vision alignment,    │
│  ecosystem coherence, quality bar           │
│  4 agents + 6 prompts                       │
├─────────────────────────────────────────────┤
│  pe-gra (Tier 0.02)                         │
│  Per-artifact operations — research,        │
│  build, validate for each artifact type     │
│  24 agents + 20 prompts                     │
├─────────────────────────────────────────────┤
│  Context files (Tier 0.00)                  │
│  Rules, patterns, contracts — the           │
│  knowledge base that agents enforce         │
│  32 context files + 12 instruction files    │
└─────────────────────────────────────────────┘
```

**pe-meta** looks at the system as a whole — does the PE infrastructure align with the vision? Are artifacts at the right quality bar? Is the ecosystem coherent?

**pe-gra** operates on individual artifacts — researching requirements, building files, and validating compliance for each specific artifact type (prompts, agents, context files, instructions, skills, templates, hooks, snippets).

**Context files** encode the rules, patterns, and contracts that both tiers enforce. They're the knowledge base — updated by pe-gra builders, validated by pe-gra validators, and audited strategically by pe-meta.

### The triad pattern

pe-gra uses a consistent **researcher → builder → validator** triad for each artifact type:

| Role | Mode | Purpose |
|---|---|---|
| **Researcher** | `plan` (read-only) | Analyze gaps, discover patterns, recommend changes |
| **Builder** | `agent` (read+write) | Create or update files following specifications |
| **Validator** | `plan` (read-only) | Check structural compliance, catch regressions |

This separation enforces single-responsibility and provides natural quality gates. The builder can't skip validation — it hands off to the validator, which hands back fix instructions if needed. A loop cap (max 2 round-trips) prevents infinite fix cycles.

---

## The self-update cycle

The system follows a four-phase cycle: **Detect → Assess → Propose → Execute**.

### Detect

Five trigger sources initiate scoped health checks:

| Signal | Source | Example |
|---|---|---|
| Platform event | VS Code/Copilot release notes | New YAML field, tool behavior change |
| Model event | Provider release notes | New model capabilities |
| Ecosystem event | Trusted external sources | Better approach from Microsoft, Anthropic |
| Internal event | File modification tracker | An artifact was edited |
| Scheduled | Time-based interval | Catch anything event triggers missed |

### Assess

Risk classification uses a **progressive model** that matures with the rollout phases. At Phase 1, two coarse inputs provide the baseline: **tier** (which layers can depend on this artifact?) and **dependent count** (how many artifacts reference this?). At Phase 2+, the system upgrades to actual dependency topology with coupling-aware analysis — distinguishing behavioral dependencies (an agent enforcing rules from a context file) from informational mentions (a "see also" in a references section). This progressive refinement improves blast radius accuracy without requiring Phase 3 infrastructure at Phase 1.

The breaking/non-breaking classification is the critical decision. **Metadata-driven classification** checks whether a change alters the artifact's declared goal, scope, or boundaries. **N-1 structural separation** enables deterministic classification at the content level — if a diff touches a `Rule` block, it's a breaking candidate; if it only touches `Rationale` or `Example` blocks, it's non-breaking.

### Propose

When assessment reveals drift, the system generates a scoped correction plan. For ecosystem changes, it decides whether to **adopt** (rely on the external artifact directly) or **incorporate** (absorb useful ideas into owned artifacts).

Changes are decomposed into the smallest individually-verifiable steps, ordered by risk: non-regressive steps first (autonomous), potentially-regressive steps next (escalated), optimization steps last.

### Execute

Before committing any change, at least one independent validation pass runs. Risk-reduction techniques include static validation, redundant LLM processing (two independent passes), and reversibility guarantees (pre-change snapshots).

---

## Key design decisions

### Metadata contracts on every artifact

Every agent, prompt, and context file carries YAML metadata declaring its `goal:`, `scope:`, `boundaries:`, and `rationales:`. This transforms implicit knowledge into machine-readable state. When a change is proposed, the system checks it against the declared metadata — a change that contradicts the artifact's `goal:` is automatically flagged as breaking.

### Category-based references (Level 1.5)

Cross-artifact references use functional category IDs (e.g., `agent-patterns`) rather than specific filenames (e.g., `02.04-agent-shared-patterns.md`). Categories are stable semantic identifiers maintained in `STRUCTURE-README.md`. When files are renamed or split, only the category mapping updates — consumer artifacts don't change.

### Handoff data contracts

Every agent-to-agent transition specifies what data is sent, what template to use, and the maximum token budget. This prevents token bloat during multi-agent orchestration and ensures both sides agree on the data format.

### Validation at 3 reference types

The system validates all cross-artifact reference types: `📖` file references, markdown links, AND slash-command references (`/name`). This was added after discovering that 174 broken slash-command references persisted undetected across 29 files — the validators only checked `📖` references and markdown links.

---

## What makes it work in practice

**The vision document is the anchor.** Every strategic review checks artifacts against the vision's rationales. Without a clear "what we're trying to achieve and why," there's nothing to validate against.

**Decomposition controls context rot.** Each agent has a focused scope (one artifact type, one role). Handoffs carry only essential state. Token budgets prevent context window exhaustion.

**The quality bar compounds.** PE-for-PE artifacts are held to an "exemplary" standard — stricter boundaries, category-based references, handoff contracts, embedded test scenarios. Since pe-gra agents are the reference implementation that all domain artifacts copy, their quality propagates through everything they build.

**Safety takes precedence over efficiency.** The system defaults to conservative autonomy thresholds. Loop caps prevent infinite fix cycles. Pre-change compatibility gates block contradicting changes. Reversibility guarantees enable confident rollback.

**Guidance quality bounds autonomy.** The system's ability to make autonomous decisions is only as good as the rules it follows. Before increasing autonomy levels, the guidance those rules come from must be clear (unambiguous), complete (no gaps), non-contradictory (rules agree across files), and properly prioritized (conflicts are resolved explicitly). This is why pe-meta doesn't just check whether artifacts are structurally correct — it checks whether the guidance they follow is good enough to trust for autonomous operation.

---

## Current status and limitations

The system is operational at **Phase 2** readiness (structured metadata in place, deterministic diffs for YAML changes). The universal blocker to Phase 3 (autonomous prose edits) is N-1 structural separation — rule-bearing sections in agent bodies still use ad-hoc formatting rather than labeled `Rule`/`Rationale`/`Example` blocks.

**What works today:**
- pe-meta strategic reviews detecting Level 2 reference violations, missing contracts, boundary gaps
- pe-gra validators catching structural compliance issues, tool alignment violations, broken references
- Automated slash-command reference integrity checking
- Metadata-driven breaking/non-breaking classification for YAML changes

**Known limitations:**
- Capability staleness (Type B) detection relies on manual trigger (scheduled review)
- Engine is embedded in the Learning Hub repository but easily portable to other repositories — not yet portable via MCP/SDK/extension

---

## References

- **Vision document:** `06.00-idea/self-updating-prompt-engineering/20260501.01-vision.v8.md`
- **pe-meta implementation:** [Self-maintaining PE: pe-meta implementation](31-self-maintaining-prompt-engineering-pe-meta-implementation.md)
- **pe-gra implementation:** [Self-maintaining PE: pe-gra implementation](32-self-maintaining-prompt-engineering-pe-gra-implementation.md)
- **Orchestrator patterns:** [How to Design Orchestrator Prompts](../04-howto/10.00-how_to_design_orchestrator_prompts.md)
- **Subagent patterns:** [How to Design Subagent Orchestrations](../04-howto/11.00-how_to_design_subagent_orchestrations.md)
