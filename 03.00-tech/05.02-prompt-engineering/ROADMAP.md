---
title: "Prompt Engineering Series — Roadmap"
author: "Dario Airoldi"
date: "2026-02-20"
description: "Planned articles and topic map for the Prompt Engineering for GitHub Copilot series"
---

# Prompt Engineering Series — Roadmap

This document tracks the planned and published articles in the **Prompt Engineering for GitHub Copilot** series, organized by Diátaxis category.

## 🏗️ Folder structure

The series follows the [Diátaxis framework](https://diataxis.fr/) with six content folders:

| Folder | Diátaxis type | Purpose |
|--------|---------------|---------|
| `01-overview/` | Orientation | Series entry point and high-level map |
| `02-getting-started/` | Tutorial | First steps—naming, organizing, and Copilot Spaces |
| `03-concepts/` | Explanation | Mental models behind each customization mechanism |
| `04-howto/` | How-to | Task-oriented guides for building and optimizing prompts |
| `05-analysis/` | Analysis | Case studies and applied multi-agent patterns |
| `06-reference/` | Reference | Settings, IDE support, and compatibility tables |

## 📋 Published articles

### 01-overview (2 articles)

| Number | Title | Status |
|--------|-------|--------|
| 01.00 | [The GitHub Copilot customization stack](./01-overview/01.00-the-github-copilot-customization-stack.md) | ✅ Published |
| 01.01 | [Appendix: Copilot Spaces](./01-overview/01.01-appendix-copilot-spaces.md) | ✅ Published |

### 02-getting-started (3 articles)

| Number | Title | Status |
|--------|-------|--------|
| 01.00 | [How GitHub Copilot uses markdown and prompt folders](./02-getting-started/01.00-how-github-copilot-uses-markdown-and-prompt-folders.md) | ✅ Published |
| 01.01 | [Appendix: Getting started reference material](./02-getting-started/01.01-appendix-getting-started-reference.md) | ✅ Published |
| 02.00 | [How to name and organize prompt files](./02-getting-started/02.00-how-to-name-and-organize-prompt-files.md) | ✅ Published |

### 03-concepts (8 articles)

| Number | Title | Status |
|--------|-------|--------|
| 01.02 | [How Copilot assembles and processes prompts](./03-concepts/01.02-how-copilot-assembles-and-processes-prompts.md) | ✅ Published |
| 01.03 | [Understanding prompt files, instructions, and context layers](./03-concepts/01.03-understanding-prompt-files-instructions-and-context-layers.md) | ✅ Published |
| 01.04 | [Understanding agents, invocation, handoffs, and subagents](./03-concepts/01.04-understanding-agents-invocation-handoffs-and-subagents.md) | ✅ Published |
| 01.05 | [Understanding skills, hooks, and lifecycle automation](./03-concepts/01.05-understanding-skills-hooks-and-lifecycle-automation.md) | ✅ Published |
| 01.06 | [Understanding MCP and the tool ecosystem](./03-concepts/01.06-understanding-mcp-and-the-tool-ecosystem.md) | ✅ Published |
| 01.07 | [Understanding LLM models and model selection](./03-concepts/01.07-understanding-llm-models-and-model-selection.md) | ✅ Published |
| 01.08 | [Chat modes, Agent HQ, and execution contexts](./03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md) | ✅ Published |
| 01.09 | [Understanding Copilot Memory and persistent context](./03-concepts/01.09-understanding-copilot-memory-and-persistent-context.md) | ✅ Published |

### 04-howto (21 articles)

| Number | Title | Status |
|--------|-------|--------|
| 03.00 | [How to structure content for prompt files](./04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md) | ✅ Published |
| 03.01 | [Appendix: Prompt file YAML reference](./04-howto/03.01-appendix-prompt-file-yaml-reference.md) | ✅ Published |
| 04.00 | [How to structure content for agent files](./04-howto/04.00-how-to-structure-content-for-copilot-agent-files.md) | ✅ Published |
| 04.01 | [Appendix: Unified agent architecture](./04-howto/04.01-appendix-unified-agent-architecture.md) | ✅ Published |
| 05.00 | [How to structure content for instruction files](./04-howto/05.00-how-to-structure-content-for-copilot-instruction-files.md) | ✅ Published |
| 06.00 | [How to structure content for skill files](./04-howto/06.00-how-to-structure-content-for-copilot-skills.md) | ✅ Published |
| 07.00 | [How to create MCP servers for Copilot](./04-howto/07.00-how-to-create-mcp-servers-for-copilot.md) | ✅ Published |
| 07.01 | [Appendix: MCP implementation examples](./04-howto/07.01-appendix-mcp-implementation-examples.md) | ✅ Published |
| 07.02 | [Appendix: MCP Apps](./04-howto/07.02-appendix-mcp-apps.md) | ✅ Published |
| 08.00 | [How to optimize prompts for specific models](./04-howto/08.00-how-to-optimize-prompts-for-specific-models.md) | ✅ Published |
| 08.01 | [Appendix: OpenAI prompting guide](./04-howto/08.01-appendix-openai-prompting-guide.md) | ✅ Published |
| 08.02 | [Appendix: Anthropic prompting guide](./04-howto/08.02-appendix-anthropic-prompting-guide.md) | ✅ Published |
| 08.03 | [Appendix: Google prompting guide](./04-howto/08.03-appendix-google-prompting-guide.md) | ✅ Published |
| 09.00 | [How to use agent hooks for lifecycle automation](./04-howto/09.00-how-to-use-agent-hooks-for-lifecycle-automation.md) | ✅ Published |
| 09.50 | [How to leverage tools in prompt orchestrations](./04-howto/09.50-how-to-leverage-tools-in-prompt-orchestrations.md) | ✅ Published |
| 10.00 | [How to design orchestrator prompts](./04-howto/10.00-how-to-design-orchestrator-prompts.md) | ✅ Published |
| 11.00 | [How to design subagent orchestrations](./04-howto/11.00-how-to-design-subagent-orchestrations.md) | ✅ Published |
| 12.00 | [How to manage information flow during prompt orchestrations](./04-howto/12.00-how-to-manage-information-flow-during-prompt-orchestrations.md) | ✅ Published |
| 13.00 | [How to optimize token consumption during prompt orchestrations](./04-howto/13.00-how-to-optimize-token-consumption-during-prompt-orchestrations.md) | ⚠️ Stub (empty) |
| 13.01 | [Appendix: Token optimization patterns](./04-howto/13.01-appendix-token-optimization-patterns.md) | ✅ Published |
| 14.00 | [How to use prompts with the GitHub Copilot SDK](./04-howto/14.00-how-to-use-prompts-with-the-github-copilot-sdk.md) | ✅ Published |

### 05-analysis (5 articles)

| Number | Title | Status |
|--------|-------|--------|
| 20 | [How to create a prompt orchestrating multiple agents](./05-analysis/20-how-to-create-a-prompt-interacting-with-agents.md) | ✅ Published |
| 20.01 | [Appendix: Orchestration case study details](./05-analysis/20.01-appendix-orchestration-case-study-details.md) | ✅ Published |
| 21.1 | [Prompt creation multi-agent flow — Implementation plan](./05-analysis/21.1-example-prompt-interacting-with-agents-plan.md) | ✅ Published |
| 21.2 | [Appendix: Orchestration plan specifications](./05-analysis/21.2-appendix-orchestration-plan-specifications.md) | ✅ Published |
| 22 | [Prompts and markdown structure for a documentation site](./05-analysis/22-prompts-and-markdown-structure-for-a-documentation-site.md) | ✅ Published (unlisted) |

### 06-reference (3 articles)

| Number | Title | Status |
|--------|-------|--------|
| 01.09 | [Copilot settings, IDE support, and compatibility reference](./06-reference/01.09-copilot-settings-ide-support-and-compatibility-reference.md) | ✅ Published |
| 01.10 | [Customization decision framework reference](./06-reference/01.10-customization-decision-framework-reference.md) | ✅ Published |
| 01.11 | [YAML frontmatter reference](./06-reference/01.11-yaml-frontmatter-reference.md) | ✅ Published |

## 🚀 Planned articles

| Number | Folder | Topic | Priority | Notes |
|--------|--------|-------|----------|-------|
| 15.00 | 04-howto | How to test and iterate on prompts | Medium | Testing strategies, regression detection, A/B comparison |
| 16.00 | 04-howto | How to version and maintain prompt libraries | Medium | Version control patterns, deprecation, team collaboration |
| 17.00–19.00 | 04-howto | Reserved | — | Available for future how-to topics |

## 📚 Numbering convention

- **01.00**: Series overview and customization stack map
- **01.01**: Appendix (Copilot Spaces)
- **01.02–01.09**: Concept articles (one per customization mechanism + memory)
- **01.09–01.11**: Reference articles (settings, decision framework, YAML reference)
- **02.00**: Getting started (naming and organizing files)
- **03.00–09.50**: How-to guides — foundations (file types, hooks, models, tools)
- **10.00–14.00**: How-to guides — orchestration and advanced topics (design, subagents, info flow, tokens, SDK)
- **15.00–19.00**: How-to guides — reserved for future topics
- **20–29**: Case studies and applied patterns

**Total: 42 articles** (40 published + 1 stub + 1 unlisted)

---

## 🔧 PE Artifact Maintenance

### Infrastructure Overview

The PE artifact system includes 18 context files, 4 instruction files, 12 agents, 11 prompts, and 2 skills — all documented in the [dependency map](./.copilot/../../../.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md).

### Maintenance Schedule

| Review | Prompt | Cadence | Next Due |
|---|---|---|---|
| Full system review | `/meta-pe-review` | Biweekly (1st + 15th) | 2026-03-15 |
| Optimization pass | `/meta-pe-optimize` | After review (if needed) | As needed |
| VS Code update check | `/meta-pe-update` | Per VS Code release | Next release |

### Maintenance Checklist

See [pe-maintenance.md](../../.github/skills/prompt-engineering-validation/checklists/pe-maintenance.md) for the step-by-step guide.

### Improvement Backlog

| Priority | Item | Status | Notes |
|---|---|---|---|
| Medium | Slim bloated standalone prompts (460–555 lines) | Backlog | Embed PE-validation skill refs instead of inline |
| Medium | Slim bloated specialist agents (prompt-validator 852 lines) | Backlog | Extract to skill references |
| Low | Context files 01, 04 over 2,500-token budget | Accepted | Deep-reference docs, loaded on-demand |
| Low | Evaluate subdirectories for `.github/templates/` | Backlog | Scale readability at 30+ templates |

### Change Log

| Date | Change | Scope |
|---|---|---|
| 2026-03-08 | Phase 1–6: Full PE artifact improvement plan implemented | All PE artifacts |
| | — Phase 1: Foundation (dependency map, lifecycle, entry points) | 3 new context files |
| | — Phase 2: Deduplication (~2,570 tokens saved) | 01, 08, instructions |
| | — Phase 3: Meta agents + coherence skill | 2 agents, 1 skill |
| | — Phase 4: Meta prompts for self-improvement | 3 meta prompts |
| | — Phase 5: Renumbered 18 context files into 5-tier logical grouping | All context + refs |
| | — Phase 6: Maintenance setup (checklist, tasks, roadmap) | Maintenance artifacts |

---

*Last updated: 2026-03-08*
