---
title: "Level up your VS Code productivity: mastering AI workflows"
author: "Dario Airoldi"
date: "2026-02-14"
categories: [recording, github-copilot, vs-code, ai-workflows, prompt-engineering]
description: "Summary of Burke Holland's deep-dive into the VS Code agent system prompt architecture, custom instructions, prompt files, custom agents, and how to compose token-saving agentic workflows."
---

# Level up your VS Code productivity: mastering AI workflows

**Session Date:** 2026-02-14  
**Summary Date:** 2026-02-14  
**Summarized By:** Dario Airoldi  
**Recording Link:** [Watch on YouTube](https://www.youtube.com/watch?v=0XoXNG65rfg)  
**Duration:** ~21 minutes  
**Speakers:** Burke Holland (Senior Cloud Advocate, Microsoft)

![Session title slide](<images/001.01 session title.png>)

---

## Executive summary

Burke Holland deconstructs the VS Code agent system prompt to reveal exactly where custom instructions, prompt files, and custom agents are inserted—and why that matters. He then demonstrates a practical three-phase workflow (Plan → Generate → Implement) that maximizes premium model usage by pairing expensive planning/coding with cheap implementation, saving tokens and improving accuracy.

---

## Table of contents

- 🏗️ [The VS Code agent system prompt architecture](#the-vs-code-agent-system-prompt-architecture)
- 📋 [Custom instructions](#custom-instructions)
- 📝 [Prompt files](#prompt-files)
- 🧠 [Context rot and context window management](#context-rot-and-context-window-management)
- 🤖 [Custom agents](#custom-agents)
- ⚡ [Composing agentic workflows: plan, generate, implement](#composing-agentic-workflows-plan-generate-implement)

---

## Session content

### 🏗️ The VS Code agent system prompt architecture

**Discussed by:** Burke Holland  
**Timestamps:** 0:00 – 3:55

Burke walks through the complete anatomy of what happens when you send a message in VS Code Copilot Chat. The prompt sent to the model is built up in layers:

**Key points:**

- The <mark>system prompt</mark> contains four layers: core identity and global rules, general instructions (model-specific quirks), tool use instructions, and output format instructions
- A <mark>user prompt</mark> is appended with environment info (OS, etc.) and workspace info (project structure in text format)
- A second user prompt adds context info—current date/time, open terminals, and any files explicitly attached to the chat
- Finally, the actual user message is appended, and the entire assembled prompt is sent to the model
- The model's response becomes part of the <mark>context window</mark>, which grows with each exchange

> "Behind the scenes, Copilot composes a prompt and it starts with a system prompt. The system prompt starts off with some core identity and global rules—this is just very generic stuff. It's like 'you are an intelligent AI coding assistant.'" — Burke Holland

![alt text](<images/02.001 system prompt.png>)
![alt text](<images/02.002 user prompt.png>)
![alt text](<images/002.03 user prompt.png>)
![alt text](<images/002.04 assistant message.png>)


---

### 📋 Custom instructions

**Discussed by:** Burke Holland  
**Timestamps:** 3:56 – 6:56

<mark>Custom instructions</mark> provide high-level project information that helps the model give better answers. They're the most common customization layer.

**Key points:**

- The most canonical use is to contain high-level information about your project architecture, patterns, and conventions
- VS Code can auto-generate chat instructions via the gear menu → "Generate chat instructions"—recommended for every project
- Custom instructions are injected at the **end of the system prompt**, making them part of the system-level context
- You can create multiple instruction files; the `copilot-instructions.md` file always comes **last** in the system prompt
- Additional instruction files (e.g., framework-specific best practices) are inserted before `copilot-instructions.md`

![alt text](<images/02.005 system prompt with custom instructions.png>)
![alt text](<images/02.004 user prompt w prompt file.png>)

**Demo summary:**
Burke installs a Next.js best practices instruction file from the <mark>[Awesome Copilot](https://github.com/github/awesome-copilot) repository</mark>. After installation, both the Next.js instructions and the project's copilot instructions are automatically passed with every request.

**Resources mentioned:**

- <mark>[Awesome Copilot](https://github.com/github/awesome-copilot)</mark> — community-contributed prompt files, custom instructions, and custom agents

---

### 📝 Prompt files

**Discussed by:** Burke Holland  
**Timestamps:** 6:57 – 12:07

<mark>Prompt files</mark> are reusable prompts you define and invoke from the chat with a `/` command. They offer powerful workflow composition capabilities.

**Key points:**

- Prompt files support front matter properties: <mark>`agent`</mark>, <mark>`description`</mark>, and <mark>`model`</mark>  
- The <mark>`model` property</mark> lets you override the active model—useful for routing cheap tasks to smaller models and saving premium requests
- <mark>Prompt files</mark> are inserted into the **user prompt** (NOT the system prompt)—their contents appear before context info
- The user message references the prompt file by name using an internal syntax
- <mark>Prompt files</mark> can generate instruction files, creating a feedback loop between the two customization layers

**Demo summary:**
Burke demonstrates a "remember" prompt file that uses GPT-4.1 (a cheaper model) to build up a memory/instruction file. Even though the active model is Claude Opus 4.5 (3x premium), the prompt file automatically switches to GPT-4.1 for the task, saving premium requests while building persistent project knowledge.

> "You can see here how I'm kind of starting to build up workflows using actually both prompt files and custom instructions." — Burke Holland

---

### 🧠 Context rot and context window management

**Discussed by:** Burke Holland  
**Timestamps:** 10:24 – 12:07

<mark>Context rot</mark> is the degradation of model accuracy as the context window grows longer.  
This phenomenon directly impacts how you should think about custom instructions and prompt files.

**Key points:**

- As the context window grows, model performance degrades—this is a documented phenomenon
- <mark>At 32,000 tokens</mark>, accuracy drops dramatically; even Claude 3.5 Sonnet goes from 88% to 30% accuracy
- VS Code limits context windows at certain thresholds specifically to maintain performance
- The practical advice: don't worry about whether instructions perform better in the system prompt vs. user prompt—use each mechanism as designed for workflow composition
- <mark>Start new chat sessions frequently to reset the context window</mark>

---

### 🤖 Custom agents

**Discussed by:** Burke Holland  
**Timestamps:** 12:08 – 15:07

Custom agents (formerly called <mark>custom modes</mark>) give the model a completely new identity and behavior, unlike custom instructions that only provide information.

**Key points:**

- Custom agents override or augment default agent behavior with a full agent-style prompt (identity, workflow, tools)
- They support `tools` (what capabilities the agent has) and `handoffs` (delegation to other agents)
- Custom agents are injected **after** custom instructions in the system prompt—they're the very last thing in the agent system prompt
- The key distinction: custom instructions give the model *information*; custom agents give the model an *identity*

![alt text](<images/03.001 system prompt with agent.png>)

**Demo summary:**
Burke examines the built-in Plan mode agent, which follows a three-step workflow: gather context and research, present a concise plan for iteration, and handle user feedback. The Plan agent uses handoffs to delegate implementation to other agents.

> "If we look at custom instructions, it's just giving it information. This [custom agent] is giving it an identity. So, it's very much like an agent system prompt." — Burke Holland

---

### ⚡ Composing agentic workflows: plan, generate, implement

**Discussed by:** Burke Holland  
**Timestamps:** 15:08 – 20:00

Burke demonstrates his personal three-phase workflow that maximizes premium model value while minimizing cost. This is the session's key practical takeaway.

**Key points:**

- **Phase 1 — Plan** (prompt file, premium model): A custom planning prompt file uses Claude Opus 4.5 to research the codebase and produce a branch-oriented plan where each step is a testable commit
- **Phase 2 — Generate** (prompt file, premium model): A "generate" prompt takes the plan file and writes all implementation code into a markdown document—step by step, with checkboxes—without modifying the project
- **Phase 3 — Implement** (custom agent, free model): An "implement" custom agent uses a small, free model (VS Code Raptor Prime / GPT-4.1 mini variant) to implement code verbatim from the generated document
- Clear the context window between each phase to avoid context rot
- The implementation agent stops after each step, returning control so you can test, stage, and commit before proceeding
- Commits build up into a single pull request

**Demo summary:**
Burke runs the full workflow: he plans a UI refactor with Opus 4.5, generates a ~2,000-line implementation document with all required code, then clears context and uses a free model to implement step by step. The result is a clean PR built iteratively with maximum use of the premium model's reasoning and minimal cost during implementation.

> "This strategy lets you sort of one-shot with a huge model and then implement and iterate with a small free model." — Burke Holland

---

## Main takeaways

1. **The prompt hierarchy is layered and predictable**
   - System prompt: core identity → general instructions → tool use → output format → custom instructions → custom agents
   - User prompt: prompt file contents → environment info → workspace info → context info → user message

2. **Each customization mechanism has a distinct purpose**
   - Custom instructions = project information (system prompt)
   - Prompt files = reusable workflows with model routing (user prompt)
   - Custom agents = full identity override with tools and handoffs (system prompt, after instructions)

3. **Context rot is real—design your workflow around it**
   - Clear context between workflow phases
   - Use the right-sized model for each task
   - Don't chase the "perfect" prompt position; use mechanisms as designed

4. **Premium model savings through workflow composition**
   - Use expensive models for planning and code generation (high reasoning)
   - Use free/cheap models for implementation (low reasoning, high execution)
   - A plan → generate → implement pattern can cut premium usage significantly

---

## Questions raised

1. **Q:** Does the placement of instructions (system prompt vs. user prompt) actually affect accuracy?
   - **A:** Burke says "I don't know"—but advises not to worry about it and instead use each mechanism as designed
   - **Status:** Open — no definitive answer

2. **Q:** How much premium request savings does the three-phase workflow achieve?
   - **A:** Burke uses Opus 4.5 (3x multiplier) only twice (plan + generate), then a free model for all implementation
   - **Status:** Answered — roughly 2 premium uses per feature vs. unlimited free implementation

---

## Action items

- [ ] Set up auto-generated chat instructions for your projects
- [ ] Explore the [Awesome Copilot](https://github.com/github/awesome-copilot) repo for community workflow files
- [ ] Create a "remember" prompt file to build up project memory with a cheap model
- [ ] Try the plan → generate → implement workflow pattern on your next feature

---

## 📚 Resources and references

### Official documentation

**[Visual Studio Code — Custom instructions](https://code.visualstudio.com/docs/copilot/copilot-customization)** `[📘 Official]`  
Official VS Code documentation on customizing GitHub Copilot with instructions files, prompt files, and custom agents. Covers the `.github/copilot-instructions.md` file, instruction file front matter, and the full customization hierarchy.

**[Visual Studio Code — Prompt files](https://code.visualstudio.com/docs/copilot/copilot-customization#_reusable-prompt-files-experimental)** `[📘 Official]`  
Documentation on reusable prompt files (`.prompt.md`) including front matter properties like `model`, `agent`, and `description`. Explains how to define and invoke prompt files in chat.

**[Visual Studio Code — Custom agents (modes)](https://code.visualstudio.com/docs/copilot/copilot-customization#_custom-chat-modes)** `[📘 Official]`  
Guide to creating custom chat agents with tools, handoffs, and full identity overrides. Includes the built-in Plan mode as an example.

### Session materials

**[Level Up Your VS Code Productivity (YouTube)](https://www.youtube.com/watch?v=0XoXNG65rfg)** `[📗 Verified Community]`  
Full recording of Burke Holland's session including live demos of the system prompt architecture, Awesome Copilot integration, and the three-phase plan → generate → implement workflow.

### Community resources

**[Awesome Copilot](https://github.com/github/awesome-copilot)** `[📗 Verified Community]`  
Community-curated collection of prompt files, custom instructions, and custom agents for GitHub Copilot. Includes Burke Holland's personal workflow files and contributions from the broader community. A great starting point for building your own AI workflows.

**[Context Rot — Understanding AI](https://www.understandingai.org/p/context-rot)** `[📒 Community]`  
Article exploring how model performance degrades as context windows grow longer. Referenced by Burke Holland to explain why clearing context between workflow phases is important and why VS Code limits context window sizes.

---

## Follow-up topics

1. **Handoffs between custom agents** — Burke mentions handoffs briefly but doesn't deep-dive into the mechanism. Worth exploring how to chain multiple custom agents together.
2. **Optimal model routing strategies** — Which models are best for planning vs. code generation vs. implementation? How do you benchmark this?
3. **Context window size limits in VS Code** — What are the actual limits, and how do they vary by model?

---

## Next steps

- Review Burke Holland's workflow files on [Awesome Copilot](https://github.com/github/awesome-copilot)
- Experiment with model overrides in prompt files to optimize premium request usage
- Build a custom implement agent tailored to your project's tech stack

---

## Related content

**Related articles in this repository:**

- [01.00-news/20260130-6-advanced-rules-for-production-copilot-agents/](../20260130-6-advanced-rules-for-production-copilot-agents/) — Advanced rules for production-ready Copilot agents
- [01.00-news/20260111-6-vital-rules-for-production-ready-copilot-agents/](../20260111-6-vital-rules-for-production-ready-copilot-agents/) — Vital rules for production-ready Copilot agents

---

<details>
<summary>Expand for key transcript excerpts</summary>

### System prompt architecture

**Timestamp:** 0:52

```
Behind the scenes, Copilot composes a prompt and it starts with a system prompt. 
The system prompt starts off with some core identity and global rules. And this is 
just very generic stuff. It's like "you are an intelligent AI coding assistant."
```

### Custom instructions placement

**Timestamp:** 5:06

```
Custom instructions should show up right here in the system prompt and they're 
actually added right here. So they are the last thing in the agent system prompt. 
And it should be noted that the copilot instructions will always be the last thing 
in the agent system prompt.
```

### Prompt files placement

**Timestamp:** 9:07

```
So the answer is they don't—not in the system prompt. They actually show up down 
here in the user prompt. The prompt files, their contents get added right here at 
the very top. So even before the context info, we'll have prompt files.
```

### Context rot impact

**Timestamp:** 10:55

```
As the context window grows, for example, a 32,000 token prompt, accuracy drops 
dramatically. Even Claude 3.5 Sonnet goes from 88% to 30% accuracy.
```

### Three-phase workflow strategy

**Timestamp:** 17:36

```
I'm trying to maximize my premium model usage. I've used Claude Opus 4.5 twice now. 
It is a 3x multiplier—six premium requests. I want to make sure that I'm getting the 
most bang for my buck. So, I'm actually going to use a smaller model to implement and 
a bigger model to write the code.
```

### Custom agents vs. custom instructions

**Timestamp:** 13:00

```
If we look at the custom instructions, it's just giving it information. This is 
giving it an identity. So, it's very much like an agent system prompt.
```

</details>

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
  filename: "summary.md"
  last_updated: "2026-02-14"
-->


