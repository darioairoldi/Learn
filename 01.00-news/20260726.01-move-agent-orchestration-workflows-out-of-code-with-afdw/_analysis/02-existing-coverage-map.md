---
title: "Existing-LearnHub coverage map — Declarative Workflows 1.0"
publish: false
---

# Existing-LearnHub coverage map

| Area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| Microsoft **Agent Framework Declarative Workflows** (YAML orchestration, `WorkflowFactory` / `DeclarativeWorkflowBuilder`) | **absent** | none found — only event-talk mentions | Concepts / How-to (Tech) |
| Microsoft Agent Framework SDK in general | **partial** | `02.00-events/202606-build-2026/…` summaries (odsp915, dem362, od805) — talks, not reference articles | Resources (Events) |
| Orchestration of **GitHub Copilot** prompt/agent files | **present** | `03.00-tech/05.02-prompt-engineering/04-howto/10.00-how-to-design-orchestrator-prompts.md`, `11.00-how-to-design-subagent-orchestrations.md`, `12.00-…information-flow…`, `09.50-…leverage-tools…` | How-to (Tech) |
| PE handoff / orchestrator design patterns | **present** | `.copilot/context/00.00-prompt-engineering/02.01-handoffs-pattern.md`, `02.03-orchestrator-design-patterns.md` | Context (PE) |

## Key distinction

The Hub's existing orchestration content is about **coordinating GitHub Copilot customization files** (prompts, agents, subagents) — the *authoring* layer. The news is about the **Microsoft Agent Framework SDK's declarative workflow feature** — a *runtime application* layer (.NET/Python apps that run multi-agent orchestrations from YAML). These are adjacent but distinct; the new article must cross-link and disambiguate rather than duplicate.

## Gap conclusion

**Absent** reader-facing coverage of Agent Framework Declarative Workflows → clear, additive tech gap. Integrate autonomously.
