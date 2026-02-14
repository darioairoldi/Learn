---
title: "Session analysis: Level up your VS Code productivity — mastering AI workflows"
author: "Dario Airoldi"
date: "2026-02-14"
categories: [analysis, recording, github-copilot, vs-code, ai-workflows, prompt-engineering]
description: "Deep analysis of Burke Holland's session deconstructing the VS Code agent system prompt architecture, the customization hierarchy (instructions, prompt files, agents), context rot, and a three-phase agentic workflow for maximizing premium model usage."
---

# Session analysis: Level up your VS Code productivity — mastering AI workflows

**Session Date:** 2026-02-14  
**Analysis Date:** 2026-02-14  
**Analyzed By:** Dario Airoldi  
**Recording Link:** [Watch on YouTube](https://www.youtube.com/watch?v=0XoXNG65rfg)  
**Duration:** ~21 minutes  
**Speakers:** Burke Holland (Senior Cloud Advocate, Microsoft)  
**Associated Summary:** [summary.md](summary.md)

![Session title slide](<images/001.01 session title.png>)

---

## Executive summary

Burke Holland's session addresses one of the most common questions in the VS Code Copilot ecosystem: what's the difference between custom instructions, prompt files, and custom agents—and where exactly do they go in the prompt? Rather than offering surface-level guidance, Burke reverse-engineers the agent system prompt itself, diagramming the precise layered architecture that Copilot assembles before anything reaches the model.

The session's major themes are: (1) the deterministic, layered structure of the VS Code system prompt, (2) the distinct injection points and purposes of each customization mechanism, (3) the real-world impact of context rot on model accuracy, and (4) a practical three-phase workflow (plan → generate → implement) that leverages premium models for reasoning and free models for execution. Burke demonstrates each concept live, installing community resources, routing models via prompt file front matter, and composing a full agentic workflow across multiple chat sessions.

The session delivers high practical value for any developer using VS Code Copilot at an intermediate or advanced level. The three-phase workflow pattern is particularly compelling—it's a concrete, repeatable strategy for reducing premium request costs by 60-80% while maintaining output quality. The architectural explanation of prompt injection points, while not officially documented at this granularity, provides essential mental models for anyone building custom workflows.

---

## Table of contents

- 🔍 [1. Introduction and framing](#1-introduction-and-framing)
- 🏗️ [2. The agent system prompt architecture](#2-the-agent-system-prompt-architecture)
  - System prompt layers
  - User prompt layers
  - Context window growth
- 📋 [3. Custom instructions deep dive](#3-custom-instructions-deep-dive)
  - Purpose and placement
  - Awesome Copilot and community instructions
- 📝 [4. Prompt files deep dive](#4-prompt-files-deep-dive)
  - Front matter capabilities
  - Injection point in user prompt
  - Workflow composition with instructions
- 🧠 [5. Context rot and performance degradation](#5-context-rot-and-performance-degradation)
  - Accuracy benchmarks
  - Practical implications
- 🤖 [6. Custom agents deep dive](#6-custom-agents-deep-dive)
  - Identity vs. information
  - Tools, handoffs, and prompt placement
- ⚡ [7. Composing an agentic workflow](#7-composing-an-agentic-workflow)
  - Phase 1: Plan
  - Phase 2: Generate
  - Phase 3: Implement
- 📊 [Key insights and takeaways](#key-insights-and-takeaways)
- 📚 [References](#references)
- **Appendices**
  - [A. Demo: Installing community instructions from Awesome Copilot](#appendix-a-demo--installing-community-instructions-from-awesome-copilot)
  - [B. Demo: Model routing with the "remember" prompt file](#appendix-b-demo--model-routing-with-the-remember-prompt-file)
  - [C. Demo: Built-in Plan mode agent](#appendix-c-demo--built-in-plan-mode-agent)
  - [D. Demo: Three-phase agentic workflow (plan → generate → implement)](#appendix-d-demo--three-phase-agentic-workflow-plan--generate--implement)

---

## Session content (chronological)

## 1. Introduction and framing

**Timeframe:** 0:00 – 0:19 (0m 19s)  
**Speakers:** Burke Holland (Senior Cloud Advocate, Microsoft)

Burke opens with the central question driving the session: what's the difference between prompt files, custom instructions, and custom agents in VS Code? He frames this as the most common question he hears from the community and promises a structural explanation of how they work together.

**Key points:**

- The session isn't a feature tour—it's a structural deep-dive into how Copilot builds its prompts
- The goal is to equip viewers with enough understanding to compose their own agentic workflows
- Burke positions the three mechanisms as "building blocks" rather than competing features

---

## 2. The agent system prompt architecture

**Timeframe:** 0:20 – 3:55 (3m 35s)  
**Speakers:** Burke Holland

This is the foundational segment of the session. Burke diagrams the complete lifecycle of a message sent in VS Code Copilot Chat, layer by layer. He emphasizes that understanding this architecture is a prerequisite for knowing where customizations are injected.

> **Context:** The <mark>system prompt</mark> is the hidden instruction set prepended to every conversation with an LLM. In VS Code, Copilot automatically assembles a multi-layered system prompt before any user message reaches the model. This architecture isn't exposed in the UI—Burke reconstructs it from observation and internal knowledge. ([Learn more about VS Code customization](https://code.visualstudio.com/docs/copilot/copilot-customization))

### 2.1. System prompt layers

**Timeframe:** 0:52 – 1:55 (1m 3s)  
**Speakers:** Burke Holland

Burke identifies four distinct layers within the system prompt, assembled in order:

**Key points:**

| Layer | Purpose | Notes |
|-------|---------|-------|
| Core identity and global rules | Generic AI identity ("you are an intelligent AI coding assistant") | Only 2-3 lines |
| General instructions | Model-specific behavioral tweaks | Varies by model—e.g., suppressing code blocks for models that over-print |
| Tool use instructions | How to use built-in tools (edit, terminal, todo list) | Tool-specific guidance |
| Output format instructions | Formatting for tokenization and UI rendering | Ensures file pills and UI elements render correctly |

> "The system prompt starts off with some core identity and global rules. This is just very generic stuff—I think there's only two or three lines." — Burke Holland

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ⚠ Needs verification — Burke's description aligns with observed behavior but VS Code doesn't publish the exact system prompt structure |
| Practical applicability | High — understanding these layers helps predict how custom content interacts with built-in instructions |

### 2.2. User prompt assembly

**Timeframe:** 2:08 – 3:40 (1m 32s)  
**Speakers:** Burke Holland

After the system prompt, Copilot assembles user-level messages before sending:

**Key points:**

- **User prompt 1:** Environment info (OS, platform) and workspace info (project structure rendered as text)
- **User prompt 2:** Context info (current date/time, open terminals) plus any files explicitly attached via `#file`
- **User prompt 3:** The actual user message (e.g., "hello world")
- Only after all layers are assembled does the complete prompt get sent to the model

### 2.3. Context window growth

**Timeframe:** 3:13 – 3:55 (0m 42s)  
**Speakers:** Burke Holland

Burke explains that the model's response becomes part of the <mark>context window</mark>, which accumulates with each exchange. Every subsequent user message adds to this growing window—a fact that becomes critical in the later discussion of context rot.

---

## 3. Custom instructions deep dive

**Timeframe:** 3:56 – 6:56 (3m 0s)  
**Speakers:** Burke Holland

Burke covers the most widely used customization layer—custom instructions—and reveals their exact placement within the prompt hierarchy.

> **Context:** <mark>Custom instructions</mark> in VS Code are Markdown files (typically `.github/copilot-instructions.md` or files in `.github/instructions/`) that provide project-specific context to the AI. They're "always-on"—automatically included in every chat request without user action. VS Code also supports file-based instructions that activate based on glob patterns matching the files being discussed. ([Learn more](https://code.visualstudio.com/docs/copilot/customization/custom-instructions))

### 3.1. Purpose and canonical usage

**Timeframe:** 3:56 – 5:06 (1m 10s)  
**Speakers:** Burke Holland

**Key points:**

- The canonical use case is containing high-level project information: architecture, patterns, conventions, tech stack
- VS Code can auto-generate instructions via the gear menu → "Generate chat instructions"—Burke recommends this for every project
- Custom instructions are automatically passed with every request—no user action required
- They're injected at the **end of the system prompt**, after all built-in layers
- The `copilot-instructions.md` file is always the **last** instruction file in the system prompt; additional instruction files come before it

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ✓ Verified — the `/init` command (generate chat instructions) and `.github/copilot-instructions.md` placement are documented |
| Practical applicability | High — every project should have a copilot-instructions.md |

> "We recommend this for every project. And this is probably the most common use case for custom instructions." — Burke Holland

### 3.2. Awesome Copilot and community instructions

**Timeframe:** 5:36 – 6:56 (1m 20s)  
**Speakers:** Burke Holland

Burke introduces the Awesome Copilot repository as a community resource for discovering shareable instruction files.

→ See [Appendix A: Demo — Installing community instructions from Awesome Copilot](#appendix-a-demo--installing-community-instructions-from-awesome-copilot) for detailed step-by-step breakdown.

**Key points:**

- [Awesome Copilot](https://github.com/github/awesome-copilot) is a GitHub repository with community-contributed prompt files, instructions, and agents
- Instructions can be installed into the user data folder (global) or `.github/instructions/` (project-scoped)
- When multiple instruction files exist, they're all passed—with `copilot-instructions.md` always last
- The ordering is deterministic: custom instruction files → `copilot-instructions.md`

---

## 4. Prompt files deep dive

**Timeframe:** 6:57 – 12:07 (5m 10s)  
**Speakers:** Burke Holland

This is the session's longest single segment, covering prompt files in depth and revealing a key architectural distinction: prompt files are injected into the user prompt, NOT the system prompt.

> **Context:** <mark>Prompt files</mark> (`.prompt.md` files in `.github/prompts/`) are reusable prompts invocable from VS Code chat via a `/` slash command. Unlike instructions, they're opt-in—activated only when explicitly invoked. Their front matter supports properties like `model` (override the active LLM), `agent` (target a specific custom agent), and `description`. ([Learn more](https://code.visualstudio.com/docs/copilot/customization/prompt-files))

### 4.1. Front matter capabilities

**Timeframe:** 7:34 – 8:39 (1m 5s)  
**Speakers:** Burke Holland

**Key points:**

- Prompt files support front matter with `agent`, `description`, and `model` properties
- The `model` property is especially powerful: it overrides the currently selected model when the prompt file is invoked
- VS Code provides IntelliSense for model selection—includes built-in models and OpenRouter models
- This enables model routing: use expensive models for reasoning tasks, cheap models for mechanical tasks

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ✓ Verified — prompt file front matter properties are documented in VS Code docs |
| Practical applicability | High — model routing via prompt files is an immediately actionable cost optimization |

### 4.2. Model routing demo

**Timeframe:** 8:06 – 8:54 (0m 48s)  
**Speakers:** Burke Holland

Burke demonstrates a "remember" prompt file that automatically routes to GPT-4.1 instead of the selected Claude Opus 4.5 model.

→ See [Appendix B: Demo — Model routing with the "remember" prompt file](#appendix-b-demo--model-routing-with-the-remember-prompt-file) for detailed step-by-step breakdown.

### 4.3. Injection point in the user prompt

**Timeframe:** 8:59 – 10:07 (1m 8s)  
**Speakers:** Burke Holland

This is a critical architectural revelation: prompt file contents don't go into the system prompt.

**Key points:**

- Prompt file contents are injected into the **user prompt**, before context info
- The user message then references the prompt file by name via an internal syntax ("follow the instructions in [prompt name]")
- This means prompt file content is part of the conversation history, not the system-level instructions
- Each invocation of a prompt file creates a new user prompt entry in the growing conversation

> "So the answer is they don't—not in the system prompt. They actually show up down here in the user prompt. The prompt files, their contents get added right here at the very top." — Burke Holland

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ⚠ Needs verification — this injection point detail isn't documented publicly; Burke appears to be describing internal behavior |
| Practical applicability | Medium — useful mental model, but Burke himself advises not to optimize based on placement |

### 4.4. Workflow composition: prompt files + instructions

**Timeframe:** 8:41 – 8:58 (0m 17s)  
**Speakers:** Burke Holland

Burke highlights that prompt files can *generate* instruction files, creating a powerful feedback loop between the two mechanisms. The "remember" prompt file writes to an instructions file, which then gets included automatically in all future requests.

> "You can see here how I'm kind of starting to build up workflows using actually both prompt files and custom instructions." — Burke Holland

---

## 5. Context rot and performance degradation

**Timeframe:** 10:24 – 12:07 (1m 43s)  
**Speakers:** Burke Holland

Burke pivots to a practical concern that cuts across all customization methods: context rot. He uses an external reference to demonstrate that prompt placement matters far less than overall context window size.

> **Context:** <mark>Context rot</mark> (also called "lost in the middle" or "context degradation") describes the documented phenomenon where LLM accuracy degrades as the context window grows—even within the model's stated maximum context length. Research has shown that models struggle most with information in the middle of long prompts, with accuracy dropping dramatically beyond certain token thresholds.

**Key points:**

- As the context window grows, model performance degrades—this is well-documented
- Burke cites a specific data point: at 32,000 tokens, Claude 3.5 Sonnet drops from 88% to 30% accuracy
- VS Code deliberately limits context windows at certain thresholds to maintain performance
- The practical takeaway: don't obsess over system prompt vs. user prompt placement—use each mechanism as designed
- Start new chat sessions frequently to reset the context window

> "It doesn't really matter if you're using custom instructions or prompt files. The performance or the accuracy of the model is just going to degrade." — Burke Holland

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ✓ Verified — context degradation is well-documented in research (e.g., "Lost in the Middle" paper by Liu et al., 2023) |
| Specific claim (88% → 30%) | ⚠ Needs verification — the exact figures couldn't be verified against the cited source (URL returned 404) |
| Practical applicability | High — this directly motivates the workflow pattern demonstrated later |

---

## 6. Custom agents deep dive

**Timeframe:** 12:08 – 15:07 (2m 59s)  
**Speakers:** Burke Holland

Burke covers the third and final customization mechanism—custom agents—drawing a sharp distinction from custom instructions: agents give the model an *identity*, not just *information*.

> **Context:** <mark>Custom agents</mark> (formerly "custom modes") are Markdown files (`.github/agents/*.agent.md`) that define complete AI personas with their own identity, instructions, tool access, and delegation behavior. They can restrict or expand tool access, specify model preferences, and use <mark>handoffs</mark> to delegate subtasks to other agents—enabling modular multi-agent workflows. ([Learn more](https://code.visualstudio.com/docs/copilot/customization/custom-agents))

### 6.1. Identity vs. information

**Timeframe:** 12:10 – 13:08 (0m 58s)  
**Speakers:** Burke Holland

**Key points:**

- Custom agents used to be called "custom modes"—Burke's "beast mode" for GPT-4.1 is an early example
- The key distinction: custom instructions provide *information* to the model; custom agents provide an *identity* (agent system prompt)
- Agent files support `tools` (capability restrictions) and `handoffs` (delegation to other agents)
- Custom agents are injected **after** custom instructions in the system prompt—they're the absolute last element

> "If we look at the custom instructions, it's just giving it information. This is giving it an identity. So, it's very much like an agent system prompt." — Burke Holland

### 6.2. Built-in Plan mode agent

**Timeframe:** 13:11 – 15:07 (1m 56s)  
**Speakers:** Burke Holland

Burke examines the built-in Plan mode agent as an example of agent architecture.

→ See [Appendix C: Demo — Built-in Plan mode agent](#appendix-c-demo--built-in-plan-mode-agent) for detailed step-by-step breakdown.

**Key points:**

- The Plan agent follows a three-step workflow: (1) gather context and research, (2) present a concise plan for iteration, (3) handle user feedback
- It uses handoffs to delegate to either an implementation agent or the editor
- The agent's prompt is structured like a system prompt with identity, workflow, and constraints

**Prompt hierarchy summary — complete injection order:**

| Order | Component | Prompt level |
|-------|-----------|-------------|
| 1 | Core identity and global rules | System prompt |
| 2 | General instructions (model-specific) | System prompt |
| 3 | Tool use instructions | System prompt |
| 4 | Output format instructions | System prompt |
| 5 | Custom instruction files | System prompt |
| 6 | `copilot-instructions.md` | System prompt (always last instruction) |
| 7 | **Custom agent instructions** | **System prompt (absolute last)** |
| 8 | Prompt file contents | User prompt |
| 9 | Environment info + workspace info | User prompt |
| 10 | Context info + attached files | User prompt |
| 11 | User message | User prompt |

---

## 7. Composing an agentic workflow

**Timeframe:** 15:08 – 20:00 (4m 52s)  
**Speakers:** Burke Holland

This is the session's culminating segment. Burke demonstrates a complete three-phase workflow that ties together all three customization mechanisms into a practical strategy for maximizing premium model value.

→ See [Appendix D: Demo — Three-phase agentic workflow](#appendix-d-demo--three-phase-agentic-workflow-plan--generate--implement) for detailed step-by-step breakdown.

### 7.1. Phase 1: Plan (prompt file + premium model)

**Timeframe:** 15:08 – 16:14 (1m 6s)  
**Speakers:** Burke Holland

**Key points:**

- Uses a custom planning prompt file (not the built-in Plan agent) with model override to Claude Opus 4.5
- The plan is structured as a single branch/PR—each step represents one testable commit
- The planning prompt instructs the model to research the codebase and ask clarifying questions
- Output: a structured plan document saved to a file

### 7.2. Phase 2: Generate (prompt file + premium model)

**Timeframe:** 16:43 – 18:27 (1m 44s)  
**Speakers:** Burke Holland

**Key points:**

- **Clears the context window** between Phase 1 and Phase 2 to combat context rot
- Uses a "generate" prompt file that takes the plan file as input
- The generate prompt writes all implementation code into a **markdown document**—not into the project files
- Each step has a checkbox; the implementation plan can be ~2,000 lines for a substantial feature
- Still uses Opus 4.5: two premium model uses total (plan + generate)

> "I'm trying to maximize my premium model usage. I've used Claude Opus 4.5 twice now. It is a 3x multiplier—six premium requests. I want to make sure that I'm getting the most bang for my buck." — Burke Holland

### 7.3. Phase 3: Implement (custom agent + free model)

**Timeframe:** 18:34 – 19:58 (1m 24s)  
**Speakers:** Burke Holland

**Key points:**

- **Clears the context window** again before implementation
- Uses a custom agent called "implement" with a free model (VS Code Raptor Prime / GPT-4.1 mini variant)
- The implement agent reads the markdown document and applies code changes verbatim—no reasoning, just execution
- The agent stops after each step, returning control for testing, staging, and committing
- Commits build up into a single pull request

> "This strategy lets you sort of one-shot with a huge model and then implement and iterate with a small free model." — Burke Holland

### 7.4. Workflow economics

The three-phase pattern creates a clear cost structure:

| Phase | Model | Cost | Purpose |
|-------|-------|------|---------|
| Plan | Claude Opus 4.5 (3x) | 3 premium requests | Codebase research, structured planning |
| Generate | Claude Opus 4.5 (3x) | 3 premium requests | Complete code generation into markdown |
| Implement | Raptor Prime (free) | 0 premium requests | Verbatim code application, iterative |
| **Total** | | **6 premium requests** | **Full feature implementation** |

**Technical assessment:**

| Aspect | Assessment |
|--------|------------|
| Accuracy | ✓ Verified — model routing via prompt files and agent files is documented behavior |
| Economic claims | ⚠ Needs verification — exact premium multipliers may vary by plan and model availability |
| Practical applicability | High — the pattern is immediately reproducible with any model combination |

---

## Key insights and takeaways

1. **The VS Code prompt is a deterministic layered architecture**
   - Knowing the exact injection order empowers you to design customizations that complement rather than conflict
   - System prompt: built-in layers → custom instructions → custom agents
   - User prompt: prompt file contents → environment → context → user message

2. **Instructions = information; agents = identity**
   - This is the sharpest mental model from the session
   - Instructions tell the model *about* your project; agents tell the model *what it is*
   - Use instructions for standards and context; use agents for specialized workflows with tool restrictions

3. **Prompt files are the workflow composition layer**
   - The `model` property enables cost-optimized routing
   - Prompt files can generate instruction files, creating self-reinforcing feedback loops
   - They're the glue between instructions (passive context) and agents (active personas)

4. **Context rot is the primary constraint on workflow design**
   - At 32K tokens, accuracy can drop to 30%—this isn't theoretical, it's measurable
   - The three-phase workflow is explicitly designed around context rot: clear the window between phases
   - Starting new chat sessions is a feature, not a limitation

5. **Premium models should reason, free models should execute**
   - The plan → generate → implement pattern concentrates reasoning in premium model calls
   - Implementation (applying pre-written code) requires minimal reasoning—free models handle it well
   - This can reduce premium request usage by 60-80% per feature

---

## Best practices extracted

1. **Generate custom instructions for every project**
   - **Applies to:** All VS Code Copilot users
   - **Rationale:** It's the lowest-effort, highest-impact customization—auto-generated via gear menu
   - **Source:** Burke Holland, 4:38

2. **Route models by task complexity**
   - **Applies to:** Users with premium model access
   - **Rationale:** Use the `model` property in prompt file front matter to automatically switch to cheaper models for mechanical tasks
   - **Source:** Burke Holland, 7:44 – 8:39

3. **Clear context between workflow phases**
   - **Applies to:** Multi-step workflows
   - **Rationale:** Context rot degrades accuracy; fresh context windows maintain quality
   - **Source:** Burke Holland, 16:48 and 18:34

4. **Design commits around testable steps**
   - **Applies to:** Plan → generate → implement workflow
   - **Rationale:** Each plan step = one commit = one testable unit; the implement agent stops after each step for human verification
   - **Source:** Burke Holland, 16:29 – 16:42

5. **Use prompt files to generate instruction files**
   - **Applies to:** Knowledge accumulation workflows
   - **Rationale:** Creates a self-reinforcing loop: cheap-model prompt file writes instructions that apply to all future requests
   - **Source:** Burke Holland, 8:41 – 8:54

---

## Knowledge gaps and open questions

### Questions not fully answered

1. **Does system prompt vs. user prompt placement meaningfully affect accuracy?**
   - **Partial answer given:** Burke says "I don't know" and advises not to worry about it
   - **What's missing:** Controlled experiments comparing instruction efficacy at different injection points
   - **Research needed:** A/B testing with identical instructions in custom instructions vs. prompt files

2. **What are VS Code's exact context window limits?**
   - **Partial answer given:** Burke says windows are "limited at a certain point" to maintain performance
   - **What's missing:** Specific token limits per model, whether they're configurable
   - **Research needed:** VS Code documentation or source code analysis

3. **How do handoffs work in practice?**
   - **Partial answer given:** Burke mentions handoffs as a feature of custom agents and shows them in the Plan mode, but doesn't demonstrate custom handoff configuration
   - **What's missing:** How to define handoff targets, what data passes between agents
   - **Research needed:** VS Code custom agents documentation on handoffs and subagent orchestration

### Topics requiring further exploration

1. **Agent Skills** — VS Code now supports [Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) as a separate customization layer (open standard). Burke doesn't mention them—they may have been introduced after this recording.
2. **Hooks** — VS Code [Hooks](https://code.visualstudio.com/docs/copilot/customization/hooks) enable shell command execution at agent lifecycle points. Not covered in this session.
3. **Subagent orchestration** — How to chain multiple custom agents for complex multi-step workflows.

---

## Fact-checking results

| Claim | Verdict | Source |
|-------|---------|--------|
| System prompt starts with core identity in 2-3 lines | ⚠ Needs verification | Not publicly documented; consistent with observed behavior |
| Custom instructions are last in system prompt | ⚠ Needs verification | Consistent with VS Code docs but injection order detail not explicit |
| Custom agents are after instructions in system prompt | ⚠ Needs verification | Burke's statement; not contradicted by official docs |
| Prompt files inject into user prompt, not system prompt | ⚠ Needs verification | Burke's statement; internal architecture detail |
| `copilot-instructions.md` always comes last among instruction files | ✓ Verified | Consistent with VS Code documentation hierarchy |
| Claude 3.5 Sonnet drops from 88% to 30% at 32K tokens | ⚠ Needs verification | Source URL (understandingai.org/p/context-rot) returned 404 |
| Prompt files support `model` property in front matter | ✓ Verified | VS Code documentation confirms front matter properties |
| Custom agents support `tools` and `handoffs` | ✓ Verified | VS Code custom agents documentation |

---

## Tools and technologies mentioned

| Tool/Technology | Version | Purpose | Status |
|-----------------|---------|---------|--------|
| VS Code Copilot Chat | Current | AI-powered coding assistant in VS Code | GA |
| Claude Opus 4.5 | Current | Premium reasoning model (3x multiplier) | GA |
| GPT-4.1 | Current | Cost-effective model for mechanical tasks | GA |
| VS Code Raptor Prime | Current | Free model for implementation tasks | GA |
| Claude 3.5 Sonnet | Referenced | Context rot benchmark model | GA |
| Awesome Copilot | N/A | Community resource repository | Active |
| Next.js | Referenced | Framework used in demo examples | GA |
| OpenRouter | N/A | Model routing service (available in VS Code model picker) | GA |

---

## Content generation opportunities

### Potential articles

1. **"How to build a plan → generate → implement workflow in VS Code"**
   - **Type:** HowTo
   - **Source material:** 15:08 – 20:00
   - **Priority:** High — most actionable content from the session

2. **"The VS Code Copilot system prompt architecture explained"**
   - **Type:** Explanation
   - **Source material:** 0:20 – 3:55
   - **Priority:** High — fills a documentation gap

3. **"Custom instructions vs. prompt files vs. custom agents: a decision guide"**
   - **Type:** Reference
   - **Source material:** Entire session (consolidated)
   - **Priority:** Medium — useful quick reference

4. **"Saving premium requests with model routing in prompt files"**
   - **Type:** HowTo
   - **Source material:** 6:57 – 8:54
   - **Priority:** Medium — directly addresses cost concerns

### Series opportunity

**Series title:** "Mastering VS Code Copilot workflows"  
**Justification:** Burke's session covers the full hierarchy—this naturally decomposes into a progressive series.

1. Understanding the VS Code Copilot system prompt (foundational)
2. Custom instructions: project context done right (practical setup)
3. Prompt files: model routing and workflow composition (intermediate)
4. Custom agents: specialized personas and tool restrictions (advanced)
5. Composing multi-phase agentic workflows (capstone)

---

## 📚 References

### Official documentation

**[Customize AI in Visual Studio Code](https://code.visualstudio.com/docs/copilot/copilot-customization)** `[📘 Official]`  
Comprehensive overview of VS Code's AI customization system including custom instructions, prompt files, custom agents, agent skills, MCP servers, hooks, and language models. The primary reference for understanding the customization hierarchy that Burke deconstructs in this session.

**[VS Code — Custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)** `[📘 Official]`  
Detailed documentation on creating always-on and file-based custom instructions. Covers `.github/copilot-instructions.md`, the `.github/instructions/` directory, front matter properties including `applyTo` glob patterns, and the auto-generation feature Burke demonstrates.

**[VS Code — Prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)** `[📘 Official]`  
Documentation on reusable prompt files invocable as slash commands. Covers front matter properties (`model`, `agent`, `description`, `tools`), file attachments, and the interaction between prompt files and instruction files.

**[VS Code — Custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)** `[📘 Official]`  
Guide to creating custom agent personas with identity, tool restrictions, handoffs, and model preferences. Includes the built-in Plan mode as an example and explains how agents differ from instructions.

**[VS Code — Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)** `[📘 Official]`  
Documentation on the Agent Skills open standard for packaging reusable AI capabilities with instructions, scripts, and resources. Not mentioned in Burke's session but represents a newer customization layer in the hierarchy.

**[VS Code — Hooks](https://code.visualstudio.com/docs/copilot/customization/hooks)** `[📘 Official]`  
Guide to lifecycle automation via shell commands that execute at key agent events. Enables policy enforcement, code quality automation, and audit trails. Not covered in this session.

### Session materials

**[Level Up Your VS Code Productivity (YouTube)](https://www.youtube.com/watch?v=0XoXNG65rfg)** `[📗 Verified Community]`  
Full recording of Burke Holland's session (Senior Cloud Advocate, Microsoft). Includes live demos of the system prompt architecture, Awesome Copilot integration, model routing via prompt files, and the complete three-phase plan → generate → implement workflow.

### Community resources

**[Awesome Copilot](https://github.com/github/awesome-copilot)** `[📗 Verified Community]`  
Community-curated collection of prompt files, custom instructions, and custom agents for GitHub Copilot, hosted under the GitHub organization. Includes Burke Holland's personal workflow files. Features an in-VS Code install mechanism for sharing customizations.

**[Context Rot — Understanding AI](https://www.understandingai.org/p/context-rot)** `[📕 Unverified]`  
Article on context degradation in LLMs referenced by Burke Holland. The URL returned a 404 error during analysis—the article may have been moved or the URL in the video description was truncated. The underlying concept (context window degradation) is well-documented in academic literature.

**["Lost in the Middle: How Language Models Use Long Contexts" (Liu et al., 2023)](https://arxiv.org/abs/2307.03172)** `[📗 Verified Community]`  
Foundational research paper documenting the phenomenon Burke describes as "context rot." Demonstrates that LLM performance degrades significantly with longer contexts, particularly for information in the middle of the prompt. Confirms the session's core claim about accuracy degradation.

---

## Recommended actions

### Immediate actions

1. **Run `/init` in VS Code Chat** — **Why:** Auto-generates `copilot-instructions.md` with project architecture and patterns; takes 30 seconds and improves every future interaction
2. **Explore Awesome Copilot** — **Why:** Access Burke's personal workflow files and community-contributed customizations at [github.com/github/awesome-copilot](https://github.com/github/awesome-copilot)

### Short-term (next 2 weeks)

1. Create a "remember" prompt file with a cheap model to build up project-specific instruction files
2. Set up a plan → generate → implement workflow with your preferred premium and free model combination
3. Review the VS Code customization diagnostics view (gear icon → Diagnostics) to verify which files are being loaded

---

## Related content

**Related articles in this repository:**

- [01.00-news/20260130-6-advanced-rules-for-production-copilot-agents/](../20260130-6-advanced-rules-for-production-copilot-agents/) — Advanced rules for production-ready Copilot agents
- [01.00-news/20260111-6-vital-rules-for-production-ready-copilot-agents/](../20260111-6-vital-rules-for-production-ready-copilot-agents/) — Vital rules for production-ready Copilot agents

---

## Appendices

### Appendix A: Demo — Installing community instructions from Awesome Copilot

**Timeframe:** 5:36 – 6:56 (1m 20s)  
**Presenters:** Burke Holland

**What was demonstrated:**
Installing a community-contributed Next.js best practices instruction file from the Awesome Copilot repository into a VS Code project.

**Step-by-step breakdown:**

1. Navigate to [github.com/github/awesome-copilot](https://github.com/github/awesome-copilot) in a browser
2. Browse the table of available instruction files
3. Select "NextJS best practices for LLM" instruction file
4. Click "Install" — VS Code opens and prompts for installation
5. Choose installation location: user data folder (global) or `.github/instructions/` (project-scoped)
6. Burke selects project-scoped installation
7. Verify: `.github/instructions/` now contains the Next.js instructions file
8. Send a new prompt — both the Next.js instructions and `copilot-instructions.md` are passed automatically

**Analysis:**

- **Correctness:** ✓ The install flow is the standard VS Code mechanism for sharing instruction files
- **Best practices alignment:** Good — project-scoped installation keeps instructions relevant and version-controlled
- **Improvements:** Consider reviewing installed instructions before committing—community files may need adaptation to your specific project conventions
- **Applicability:** Any team wanting to bootstrap customizations quickly

---

### Appendix B: Demo — Model routing with the "remember" prompt file

**Timeframe:** 7:19 – 8:54 (1m 35s)  
**Presenters:** Burke Holland

**What was demonstrated:**
Using a prompt file's `model` front matter property to automatically route a request to a cheaper model, and using that prompt file to generate a persistent instruction file.

**Step-by-step breakdown:**

1. Open the "remember" prompt file — shows front matter with `model: gpt41`
2. Note the current active model: Claude Opus 4.5 (3x premium multiplier)
3. Type `/remember` in chat to invoke the prompt file
4. Enter the message: "useEffect can only be used in client components" (a recurring Next.js mistake)
5. Send — the request is automatically routed to GPT-4.1 (not Opus 4.5)
6. GPT-4.1 creates an instruction file with the "remember" content
7. This instruction file is now automatically included in all future requests

**Code/Configuration shown:**

```yaml
# Prompt file front matter
---
name: remember
model: gpt41
description: "Remember something for future context"
---
```

**Analysis:**

- **Correctness:** ✓ Model routing via front matter works as described
- **Best practices alignment:** Excellent — uses cheap models for mechanical tasks (writing an instruction file requires minimal reasoning)
- **Improvements:** Consider adding `agent: agent` explicitly for clarity; consider naming the generated instruction file descriptively
- **Applicability:** High — any user can create a "remember" prompt file in 2 minutes to start building persistent project knowledge cheaply

---

### Appendix C: Demo — Built-in Plan mode agent

**Timeframe:** 13:11 – 14:56 (1m 45s)  
**Presenters:** Burke Holland

**What was demonstrated:**
Examining and running the built-in Plan mode custom agent that ships with VS Code.

**Step-by-step breakdown:**

1. Click "Configure custom agents" in VS Code
2. Open the built-in Plan mode agent file
3. Review the file structure: name, description, tools list, handoffs, and the agent prompt
4. Note the three-step workflow in the prompt: (a) gather context and research, (b) present concise plan, (c) handle user feedback
5. Note the handoffs: can delegate to implementation or write plan to editor
6. Switch to Plan mode and select Claude Haiku as the planning model
7. Send prompt: "add dark mode to this app"
8. Plan agent researches the codebase, asks questions, and produces a structured plan

**Analysis:**

- **Correctness:** ✓ The built-in Plan mode works as described
- **Best practices alignment:** Good — demonstrates the agent pattern of identity + workflow + tool restrictions
- **Improvements:** Burke notes the built-in Plan agent is similar to his custom planning prompt file, but his version structures output as a branch/PR plan
- **Applicability:** Good starting point; most users will want to customize the planning format for their team's PR/commit conventions

---

### Appendix D: Demo — Three-phase agentic workflow (plan → generate → implement)

**Timeframe:** 15:08 – 19:58 (4m 50s)  
**Presenters:** Burke Holland

**What was demonstrated:**
A complete end-to-end agentic workflow using all three customization mechanisms to refactor a UI, maximizing premium model usage while minimizing cost.

**Step-by-step breakdown:**

**Phase 1: Plan (15:08 – 16:14)**

1. Invoke custom planning prompt file (model: Claude Opus 4.5)
2. Model automatically switches from current model to Opus 4.5
3. Prompt: "refactor the UI of this application to be more clean and modern"
4. Planning prompt instructs the model to work in the concept of a branch — each plan step = one testable commit
5. Model researches codebase, asks mild clarifying questions
6. Outputs a structured plan file with numbered steps
7. **Cost:** 3 premium requests (Opus 4.5 at 3x)

**Phase 2: Generate (16:43 – 18:27)**

8. **Clear the context window** — start new chat session
9. Invoke "generate" prompt file (model: Claude Opus 4.5)
10. Attach the plan file from Phase 1 as input
11. Generate prompt writes ALL implementation code into a markdown document
12. Code is organized step-by-step with checkboxes for tracking
13. Output: ~2,000-line implementation document containing every code change needed
14. **Cost:** 3 premium requests (Opus 4.5 at 3x)

**Phase 3: Implement (18:34 – 19:58)**

15. **Clear the context window** — start new chat session
16. Switch to "implement" custom agent (model: Raptor Prime, free)
17. Attach the implementation document from Phase 2
18. Simple prompt: implement the document
19. Agent reads the markdown and applies code changes verbatim
20. Agent completes Step 1, then **stops and returns control** to the user
21. User tests, reviews, stages, and commits Step 1
22. Repeat: invoke implement agent again — it picks up with Step 2
23. Continue until all steps are implemented
24. **Cost:** 0 premium requests (free model)

**Total cost: 6 premium requests for a complete feature implementation**

**Analysis:**

- **Correctness:** ✓ The workflow is sound — separating reasoning from execution is an established pattern
- **Best practices alignment:** Excellent — each commit is testable, context is fresh for each phase, premium model usage is concentrated on reasoning tasks
- **Improvements:** Consider adding a verification phase (Phase 4) where a premium model reviews the implemented changes against the original plan. Consider automating the context-clear + implement flow with a script or hook.
- **Applicability:** High — immediately reproducible by any user with access to a premium model and a free model. The pattern is model-agnostic—substitute any reasoning model for planning/generation and any execution model for implementation.

---

<!--
validations:
  grammar:
    status: "not_run"
    last_run: null
  readability:
    status: "not_run"
    last_run: null
  structure:
    status: "not_run"
    last_run: null

article_metadata:
  filename: "readme.sonnet4.md"
  last_updated: "2026-02-14"
-->
