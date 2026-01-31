---
title: "How to Create a Prompt Orchestrating Multiple Agents"
author: "Dario Airoldi"
date: "2025-12-26"
categories: [tech, github-copilot, prompt-engineering, agents, orchestration]
description: "Design orchestrator prompts that coordinate specialized agents through multi-phase workflows with intelligent architecture analysis and handoffs"
---

# How to Create a Prompt Orchestrating Multiple Agents

When building complex AI workflows, a single prompt file often isn't enough.  
Tasks like "create a new prompt following best practices" involve multiple distinct phases—research, building, validation, and fixing—each requiring different expertise and tools.  

This article explains how to design an <mark>orchestrator prompt</mark> that coordinates specialized agents, including intelligent architecture analysis to determine when new agents need to be created.

## Table of Contents

- [🎯 The Problem: Complex Multi-Phase Workflows](#-the-problem-complex-multi-phase-workflows)
- [🏗️ Architecture Overview](#️-architecture-overview)
  - [Advanced Agent Deployment Options](#advanced-agent-deployment-options)
  - [Sharing Agents Across Teams](#sharing-agents-across-teams)
  - [Cross-Platform Compatibility: Claude Skills](#cross-platform-compatibility-claude-skills)
- [📋 The Specialized Agent Pattern](#-the-specialized-agent-pattern)
- [🎯 Use Case Challenge Methodology](#-use-case-challenge-methodology)
- [🔀 Orchestrator Design: Phase-Based Coordination](#-orchestrator-design-phase-based-coordination)
- [📡 Information Exchange Protocols](#-information-exchange-protocols)
  - [Explicit Data Contracts](#explicit-data-contracts)
  - [Communication Format: Text Reports > JSON](#communication-format-text-reports--json)
  - [Context Carryover Strategies](#context-carryover-strategies)
  - [Token-Efficient Communication Patterns](#token-efficient-communication-patterns)
- [🧠 Structure Definition & Architecture Analysis (Phase 3)](#-structure-definition--architecture-analysis-phase-3)
  - [Tool Composition Validation](#tool-composition-validation)
  - [Agent Dependencies Planning (Phases 5-6)](#agent-dependencies-planning-phases-5-6)
- [🔧 Handling Agent Creation Within the Workflow](#-handling-agent-creation-within-the-workflow)
- [🔄 The Complete Workflow](#-the-complete-workflow)
- [🔄 Execution Flow Control Patterns](#-execution-flow-control-patterns)
  - [Iteration Control with Bounded Loops](#iteration-control-with-bounded-loops)
  - [Recursion Control for Agent Creation](#recursion-control-for-agent-creation)
  - [Error Handling Paths](#error-handling-paths)
  - [Parallel vs. Sequential Execution](#parallel-vs-sequential-execution)
- [💡 Key Design Decisions](#-key-design-decisions)
  - [Validation Loop Limits](#validation-loop-limits)
  - [Pre-Save Validation](#pre-save-validation)
- [📝 Implementation Example](#-implementation-example)
- [📊 Real Implementation Case Study](#-real-implementation-case-study)
- [🎯 Conclusion](#-conclusion)
- [📚 References](#-references)

## 🎯 The Problem: Complex Multi-Phase Workflows

Consider the task: **"Create a new prompt file following repository best practices."**

This seemingly simple request actually involves multiple distinct phases:

1. **Research**: Discover existing patterns, find similar prompts, identify conventions
2. **Architecture Analysis**: Determine if a single prompt suffices or if multiple agents are needed
3. **Building**: Generate the actual file(s) following discovered patterns
4. **Validation**: Check structure, conventions, and quality
5. **Fixing**: Address any issues found during validation

Each phase requires different:
- **Tools**: Research needs `semantic_search`, building needs `create_file`, validation needs `read_file`
- **Expertise**: Researcher mindset vs. builder mindset vs. quality auditor mindset
- **Access levels**: Some phases are read-only, others need write access

### The Monolithic Prompt Problem

A single prompt trying to do everything suffers from:

| Problem | Impact |
|---------|--------|
| **<mark>Tool Clash</mark>** | 20+ tools cause confusion and wrong tool selection |
| **<mark>Context Rot</mark>** | Instructions for later phases get "lost in the middle" |
| **<mark>Mixed Responsibilities</mark>** | Hard to maintain, debug, or improve individual phases |
| **<mark>No Reusability</mark>** | Can't reuse the "research" capability for other tasks |

### The Solution: Orchestrator + Specialized Agents

Split the monolithic prompt into:

```
┌─────────────────────────────────────────────────────────────┐
│          ORCHESTRATOR PROMPT                                │
│   prompt-design-and-create.prompt.md                        │
│                                                             │
│   • Gathers requirements (Phase 1)                          │
│   • Coordinates agent handoffs                              │
│   • Analyzes architecture needs (Phase 3)                   │
│   • Presents results at each phase                          │
│   • Does NOT implement—delegates everything                 │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┬─────────────┐
        │             │             │             │
        ▼             ▼             ▼             ▼
┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐
│ RESEARCHER│ │  BUILDER  │ │ VALIDATOR │ │  UPDATER  │
│           │ │           │ │           │ │           │
│ Phase 2   │ │ Phase 4   │ │ Phase 5   │ │ Phase 6   │
│ read-only │ │ write     │ │ read-only │ │ write     │
│ research  │ │ create    │ │ analyze   │ │ fix       │
└───────────┘ └───────────┘ └───────────┘ └───────────┘
```

## 🏗️ Architecture Overview

### The Prompt Creation System

We designed a complete system for creating prompts and agents:

```
ORCHESTRATORS (Prompts)
├── prompt-design-and-create.prompt.md    # Creates NEW prompts/agents
└── prompt-review-and-validate.prompt.md  # Improves EXISTING prompts/agents

SPECIALIZED AGENTS (Prompt Domain)
├── prompt-researcher.agent.md   # Research patterns, recommend templates
├── prompt-builder.agent.md      # Create prompt files
├── prompt-validator.agent.md    # Validate prompt quality
└── prompt-updater.agent.md      # Fix validation issues

SPECIALIZED AGENTS (Agent Domain) - Created when needed
├── agent-researcher.agent.md    # Research agent patterns
├── agent-builder.agent.md       # Create agent files
├── agent-validator.agent.md     # Validate agent quality
└── agent-updater.agent.md       # Fix agent issues
```

### Why Separate Prompt vs. Agent Specialists?

While prompts and agents share similar structure, they have important differences:

| Aspect | Prompt Files | Agent Files |
|--------|--------------|-------------|
| **<mark>Location</mark>** | `.github/prompts/` | `.github/agents/` |
| **<mark>Extension</mark>** | `.prompt.md` | `.agent.md` |
| **<mark>Key Fields</mark>** | `agent: plan/agent`, `tools` | `tools`, `handoffs`, persona |
| **<mark>Focus</mark>** | Task workflow | Specialist role |
| **<mark>Templates</mark>** | `prompt-*.md` templates | Agent-specific templates |

A `prompt-builder` trained on prompt patterns may not produce optimal agent files. Hence the need for specialized `agent-builder` when creating agents.

### Advanced Agent Deployment Options

Custom agents aren't limited to interactive chat sessions. VS Code v1.107+ provides <mark>**three execution contexts**</mark> for orchestrated workflows, unified through the Agent HQ interface.

#### Execution Contexts Comparison

| Context | Isolation | Workspace Changes | Best For | Orchestration Use Cases |
|---------|-----------|-------------------|----------|-------------------------|
| **<mark>Local</mark>** | None—modifies workspace directly | Immediate in active workspace | Quick tasks, interactive refinement | Interactive research, immediate validation |
| **<mark>Background</mark>** | Full—uses Git work tree | Isolated, can be applied back | Long-running tasks without blocking | Code generation, multi-file refactoring |
| **<mark>Cloud</mark>** | Full—new branch and PR | Creates pull request | Large changes, async collaboration | Automated PR workflows, scheduled audits |

**Work Tree Isolation (Background Context):**

Background agents automatically create <mark>**Git work trees**</mark> to isolate changes:
- No conflicts with your active workspace edits
- Review changes before applying to main workspace
- Safe parallel execution of validation agents
- One-click "Apply" action to merge changes

**v1.107.1 Enhancements:**
- Side-by-side session view for easier comparison
- Input-required markers to track workflow state
- Workspace change copying support
- Collapsed tool calls in cloud sessions for cleaner output

All three contexts reuse the same `.agent.md` files, making orchestrator patterns fully portable across execution environments.

#### Agent HQ: Unified Session Management

<mark>**Agent HQ**</mark> (introduced in v1.107) provides a unified interface for managing all agent sessions—local, background, and cloud—in one view.

**Key Features for Orchestrations:**

- **<mark>Recent Sessions List</mark>**: Track all active and completed multi-phase workflows
- **<mark>Filtering and Search</mark>**: Find specific orchestration runs by name or agent type
- **<mark>Read/Unread Markers</mark>**: Visual indicators show which sessions need attention
- **<mark>Archive Capability</mark>**: Clean up completed workflows while preserving history
- **<mark>Side-by-Side View</mark>**: Compare orchestrator output with specialist agent results (v1.107.1)

**Orchestration Workflow Pattern:**

```
User runs orchestrator prompt
        ↓
Orchestrator gathers requirements (Phase 1-2)
        ↓
Orchestrator shows analysis, prompts:
  "Ready to delegate to specialist agent?"
        ↓
User clicks "Continue in Background/Cloud"
        ↓
Agent HQ shows new session running
        ↓
User continues working in local session
        ↓
Background/cloud session completes
        ↓
Agent HQ marks session as "unread" (needs attention)
        ↓
User reviews results, applies changes
```

**Benefits for Multi-Agent Workflows:**
- **<mark>Parallel Execution</mark>**: Run validation in background while continuing local research
- **<mark>Session Continuity</mark>**: Background sessions persist across VS Code restarts
- **<mark>Clear Handoff Points</mark>**: Visual separation between orchestrator and specialist execution
- **<mark>Audit Trail</mark>**: Complete history of all phases in multi-step workflows

#### The "Continue in" Delegation Pattern

The <mark>**"Continue in"**</mark> workflow is the primary mechanism for orchestrators to delegate work to specialized agents.

**Available From:**
- Chat view "Continue in" button
- Untitled prompt file "Continue in" button
- Agent handoff suggestions

**Delegation Workflow:**

```yaml
# In orchestrator prompt
---
name: prompt-design-and-create
agent: plan  # Planning mode for analysis
---

# Phase 1-2: Gather requirements and research
# Phase 3: Present findings to user

## Delegation Options

Based on analysis, I recommend:

**Option A - Continue in Background:**
- Isolated work tree for safe experimentation
- Review changes before applying
- Continue working while agent builds

**Option B - Continue in Cloud:**
- Automatic PR creation
- Team collaboration via GitHub
- No local resource usage

**Option C - Continue Local (Interactive):**
- Real-time feedback and refinement
- Immediate workspace updates
```

**How Delegation Works:**

1. **<mark>User triggers</mark>**: Clicks "<mark>Continue in Background</mark>" or "<mark>Continue in Cloud</mark>"
2. **<mark>Context transfer</mark>**: Orchestrator's conversation history transfers to new session
3. **<mark>Agent execution</mark>**: Specialist agent (e.g., `prompt-builder`) runs in selected context
4. **<mark>Notification</mark>**: Agent HQ marks session complete when done
5. **<mark>Review</mark>**: User reviews results in Agent HQ, applies changes if satisfied

**Orchestrator Best Practices:**
- Present delegation options clearly at transition points
- Explain trade-offs between contexts (isolation vs. immediacy)
- Recommend context based on task complexity and duration
- Provide clear success criteria for delegated work

#### Planning Mode Integration

<mark>**Planning mode**</mark> (`agent: plan` in YAML frontmatter) generates implementation plans before delegating to builder agents.

**How Orchestrators Use Planning Mode:**

```yaml
---
name: prompt-design-and-create
agent: plan  # Enable planning mode
---

# Phase 0: Planning (Optional)
Generate implementation plan including:
- File structure recommendations
- Required agent specialists
- Estimated complexity
- Risk assessment

# Phase 1-2: Requirements gathering
...

# Phase 3: Delegate plan to builder agent
Present plan and offer "Continue in" delegation
```

**Benefits for Orchestrations:**
- **Upfront clarity**: Users see complete plan before work begins
- **Better delegation**: Plans specify which specialist agents are needed
- **Risk mitigation**: Identify potential issues before implementation
- **User control**: Review and approve plan before delegating

**Planning → Implementation Workflow:**

```
Orchestrator (planning mode)
        ↓
Generates detailed implementation plan
        ↓
Shows plan to user with delegation options
        ↓
User approves and clicks "Continue in Background"
        ↓
Builder agent executes plan in isolated work tree
        ↓
User reviews completed work in Agent HQ
        ↓
Applies changes to main workspace
```

#### Subagents (Experimental)

VS Code supports <mark>**subagents**</mark>—the ability to <mark>spawn child agents from within a parent agent's execution</mark>.  
This enables dynamic orchestration patterns where agents can delegate subtasks programmatically.

```yaml
---
name: code-review-orchestrator
description: "Orchestrates code review workflow"
tools:
  - runSubagent  # Enables spawning child agents
  - read_file
infer: true  # Allow this agent to be used as a subagent (default)
---
```

**Subagent patterns:**
- Parent orchestrator spawns specialized reviewers on-demand
- Dynamic agent selection based on file types discovered
- Recursive workflows where validators can trigger fixers

> **Note:** Subagent support is experimental. Set `infer: false` in agent YAML to prevent an agent from being invoked as a subagent.

Learn more: [VS Code Subagents with Custom Agents](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental)

### Sharing Agents Across Teams

Orchestrated workflows become more valuable when shared across your organization:

#### Workspace-Level Sharing

Store agents in `.github/agents/` folder—they're automatically available to anyone who clones the repository:

```
repository/
├── .github/
│   ├── agents/
│   │   ├── prompt-researcher.agent.md
│   │   ├── prompt-builder.agent.md
│   │   └── code-review-orchestrator.agent.md
│   └── prompts/
│       └── prompt-design-and-create.prompt.md
```

#### Organization-Level Sharing (Experimental)

For enterprises, VS Code supports <mark>**organization-level custom agents**</mark> defined at the GitHub organization level. These agents appear automatically for all organization members.

**Benefits:**
- Centralized agent libraries maintained by platform teams
- Consistent tooling across all repositories
- Version-controlled agent definitions with org-wide rollout

**Enable discovery:**
```json
// settings.json
{
  "github.copilot.chat.customAgents.showOrganizationAndEnterpriseAgents": true
}
```

Organization agents appear in the Agents dropdown alongside personal and workspace agents.

Learn more: [GitHub - Create Custom Agents for Organizations](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)

### Cross-Platform Compatibility: Claude Skills

If your team uses Claude across multiple platforms, VS Code can integrate <mark>**Claude skills**</mark>—reusable instruction sets that work across Claude interfaces.

**How it works:**
- Define skills in `SKILL.md` files
- Store in `~/.claude/skills/skill-name/SKILL.md` (user-level) or `.claude/skills/skill-name/SKILL.md` (workspace)
- VS Code loads skills on-demand when the `read` tool is enabled

**Example skill structure:**
```markdown
# Code Review Skill

You are an expert code reviewer focused on:
- Security vulnerabilities
- Performance anti-patterns
- Code maintainability

## Process
1. Analyze code structure
2. Identify issues by severity
3. Suggest specific fixes
```

**Enable Claude skills in VS Code:**
```json
// settings.json (experimental)
{
  "chat.useClaudeSkills": true
}
```

**When to use Claude skills vs. custom agents:**

| Feature | Claude Skills | Custom Agents |
|---------|---------------|---------------|
| **<mark>Scope</mark>** | Cross-platform (Claude.ai, API, VS Code) | VS Code only |
| **<mark>Tools</mark>** | Limited (`allowed-tools` not supported in VS Code) | Full tool configuration |
| **<mark>Handoffs</mark>** | Not supported | Full handoff orchestration |
| **<mark>Best for</mark>** | Portable personas/instructions | Complex orchestrated workflows |

> **Note:** The `allowed-tools` attribute in Claude skills is not currently supported in VS Code. For tool-specific workflows, use custom agents.

## 📋 The Specialized Agent Pattern

Each specialized agent follows a consistent structure:

### Agent Anatomy

```yaml
---
description: "One-sentence specialist description"
agent: plan  # or: agent (for write access)
tools:
  - tool_1    # Narrow scope: 3-7 tools max
  - tool_2
handoffs:
  - label: "Next Step"
    agent: next-agent
    send: true  # automatic or false for user approval
---

# Agent Name

[Role description - what this specialist does]

## Your Expertise
- [Capability 1]
- [Capability 2]

## 🚨 CRITICAL BOUNDARIES

### ✅ Always Do
- [Required behaviors]

### ⚠️ Ask First  
- [Actions requiring confirmation]

### 🚫 Never Do
- [Prohibited actions]

## Process
[Phase-by-phase workflow]
```

### The Four Prompt Specialists

#### 1. prompt-researcher.agent.md
**Role**: Research specialist (read-only)

```yaml
agent: plan  # Read-only
tools:
  - semantic_search
  - read_file
  - file_search
  - grep_search
```

**Responsibilities**:
- Find similar existing prompts (3-5 examples)
- Analyze patterns and conventions
- Recommend appropriate template
- Provide implementation guidance

**Key Boundary**: Never creates or modifies files

#### 2. prompt-builder.agent.md
**Role**: File creation specialist

```yaml
agent: agent  # Write access
tools:
  - read_file
  - semantic_search
  - create_file
  - file_search
handoffs:
  - label: "Validate Prompt"
    agent: prompt-validator
    send: true  # Automatic validation
```

**Responsibilities**:
- Load and customize templates
- Apply research recommendations
- Create new prompt files
- Self-validate before handoff

**Key Boundary**: Creates NEW files only (never modifies existing)

#### 3. prompt-validator.agent.md
**Role**: Quality assurance specialist (read-only)

```yaml
agent: plan  # Read-only
tools:
  - read_file
  - grep_search
  - file_search
```

**Responsibilities**:
- Validate structure against template
- Check convention compliance
- Assess quality and completeness
- Produce detailed report with scores

**Key Boundary**: Never modifies files—only reports issues

#### 4. prompt-updater.agent.md
**Role**: Fix specialist

```yaml
agent: agent  # Write access
tools:
  - read_file
  - grep_search
  - replace_string_in_file
  - multi_replace_string_in_file
handoffs:
  - label: "Re-validate After Update"
    agent: prompt-validator
    send: true  # Automatic re-validation
```

**Responsibilities**:
- Apply fixes from validation report
- Make targeted, surgical changes
- Preserve existing structure
- Trigger re-validation

**Key Boundary**: Modifies EXISTING files only (never creates new)

### Extending Agents with MCP Servers

Custom agents can use tools from [Model Context Protocol (MCP) servers](https://modelcontextprotocol.io/), enabling access to external systems like databases, APIs, and file systems beyond VS Code's built-in capabilities.

MCP tools are referenced in agent YAML just like built-in tools:

```yaml
---
name: database-analyzer
tools:
  - read_file
  - mcp.database-server.query  # MCP tool
  - mcp.database-server.schema # MCP tool
---
```

**When to use MCP for orchestrations:**
- Agent needs database access (PostgreSQL, MongoDB, etc.)
- External API integration required (GitHub, Slack, etc.)
- Custom tools specific to your domain or workflow

Learn more: [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)

## 🎯 Use Case Challenge Methodology

Before building any prompt or agent, <mark>**validate that the goal is clear and actionable**</mark> by generating realistic use cases.  
This battle-tested methodology prevents scope creep and reveals tool/boundary requirements early.

### Why Use Case Challenge?

Goals often seem clear until tested against real scenarios.  
A prompt like "validate code quality" sounds straightforward, but:
- Does it include security checks?
- Should it analyze test coverage?
- What about documentation completeness?

The **Use Case Challenge** generates 3/5/7 scenarios (based on complexity) to stress-test goal clarity before any implementation begins.

### Complexity Assessment

First, determine task complexity:

| Complexity | Indicators | Use Cases to Generate |
|------------|------------|----------------------|
| **Simple** | Clear single task, standard role, well-defined scope | 3 |
| **Moderate** | Multiple objectives, domain-specific knowledge, some ambiguity | 5 |
| **Complex** | Broad scope, novel workflow, cross-domain expertise needed | 7 |

### Use Case Generation Process

```markdown
### Use Case Challenge Results

**Initial Goal**: [starting goal definition]
**Complexity Level**: [Simple/Moderate/Complex]
**Use Cases Generated**: [3/5/7]

---

**Use Case 1: [Common Case]**
- **Scenario**: User asks to [realistic situation]
- **Test**: Does goal provide clear guidance for this case?
- **Result**: [✅ Clear / ⚠️ Ambiguous / ❌ Gap]
- **Tool Discovered**: [if scenario reveals tool need]
- **Boundary Discovered**: [if scenario reveals scope limit]
- **Refinement**: [specific goal adjustment]

**Use Case 2: [Edge Case]**
[...repeat pattern...]

**Use Case 3: [Conflict Case]**
[...repeat pattern...]

---

**Validation Status**:
- ✅ Goal appropriately scoped → Proceed to Phase 2
- ⚠️ Goal needs refinement → [proposed changes, ask user]
- ❌ Goal fundamentally unclear → BLOCK, ask user for direction

**Refined Goal**: [updated goal definition]
**Tools Discovered**: [list with justifications]
**Scope Boundaries**: 
  - IN: [what's included]
  - OUT: [what's excluded]
```

### Real Example: Prompt Creation Orchestrator

When designing the prompt creation system, the Use Case Challenge revealed:

**Initial Goal**: "Create prompts following best practices"

**Use Case Challenge (5 cases for Moderate complexity)**:

| # | Scenario | Result | Discovery |
|---|----------|--------|----------|
| 1 | Simple validation prompt | ✅ Clear | Needs template selection |
| 2 | Multi-phase workflow prompt | ⚠️ Ambiguous | When to recommend orchestrator vs. single prompt? |
| 3 | Prompt requiring new agents | ❌ Gap | No guidance on agent creation sub-workflow |
| 4 | Prompt with conflicting requirements | ⚠️ Ambiguous | How to handle tool count >7? |
| 5 | Updating existing prompt | ❌ Gap | Build vs. Update are different workflows |

**Refinements Applied**:
- Split into two orchestrators: `design-and-create` vs. `review-and-validate`
- Added Phase 3 architecture analysis for complexity detection
- Added agent dependency planning phases (5-6)
- Added tool count enforcement with decomposition strategy

### Role Challenge for Agents

When creating agents (not prompts), apply additional **Role Challenge** tests:

```markdown
### Role Challenge Tests

**Agent**: [agent name]
**Initial Role**: [starting role definition]

**Test 1: Authority Test**
- Question: Does this agent have authority to [action]?
- Result: [✅/❌]
- Implication: [adjust boundaries]

**Test 2: Expertise Test**  
- Question: Is this agent the best specialist for [task]?
- Result: [✅/❌]
- Implication: [refine or split role]

**Test 3: Specificity Test**
- Question: Is this role too broad or too narrow?
- Result: [✅/❌]
- Implication: [adjust scope]

**Validated Role**: [final role definition]
```

## 🔀 Orchestrator Design: Phase-Based Coordination

The orchestrator prompt coordinates the workflow through distinct phases, optionally using <mark>planning mode</mark> for upfront design:

### Orchestrator Structure

```yaml
---
name: prompt-create-orchestrator
description: "Orchestrates specialized agents to research, build, and validate"
agent: plan  # Optional: Use planning mode for Phase 0
tools:
  - read_file        # For Phase 1 requirements analysis only
  - semantic_search  # For Phase 3 architecture analysis only
  # Note: Minimal tools for orchestrator - agents have specialized tools
handoffs:
  - label: "Research prompt requirements"
    agent: prompt-researcher
    send: false  # User reviews research
  - label: "Build prompt file"
    agent: prompt-builder
    send: false  # User reviews file
  - label: "Validate prompt quality"
    agent: prompt-validator
    send: true   # Automatic validation
---
```

### Phase Flow

```
Phase 0: Planning (Optional - if agent: plan)
    │
    │ Generate implementation plan
    │ Identify required specialists
    │ Present plan with "Continue in" delegation options
    │ □ USER APPROVAL CHECKPOINT
    │
    ▼
Phase 1: Requirements Gathering (Orchestrator)
    │
    │ User provides: "Create a prompt for X"
    │ Orchestrator extracts: type, scope, tools, constraints
    │ ✓ Use Case Challenge validates goal clarity
    │ Present delegation options (Local/Background/Cloud)
    │
    ▼
Phase 2: Research (→ prompt-researcher)
    │
    │ Researcher returns: patterns, template recommendation, guidance
    │ Orchestrator presents findings to user
    │ □ USER APPROVAL CHECKPOINT
    │ Option: "Continue in Background" for next phase
    │
    ▼
Phase 3: Structure Definition & Architecture Analysis (Orchestrator)
    │
    │ Orchestrator determines: single-prompt vs. orchestrator+agents
    │ ✓ Tool Composition Validation
    │ If complex: identifies which agents to create
    │ □ USER APPROVAL CHECKPOINT
    │ Present delegation to background/cloud for build phase
    │
    ┣───────────────────────────┫
    │                            │
    ▼ (Simple)                   ▼ (Complex)
Phase 4: Build                 Phase 5: Agent Updates Plan
(→ prompt-builder)            │ □ USER APPROVAL CHECKPOINT
    │                          │ Option: Background with work tree isolation
    │                          │
    │                          ▼
    │                      Phase 6: New Agent Creation Plan
    │                          │ □ USER APPROVAL CHECKPOINT
    │                          │
    │                          ▼
    │                      Phase 4a: Create Agents (Iterative)
    │                      (→ agent-builder, max 2 recursion)
    │                          │ Track in Agent HQ
    │                          │
    │                          ▼
    │                      Phase 4b: Create Orchestrator
    │                      (→ prompt-builder)
    │                          │
    ┣───────────────────────────┫
    │
    ▼
Phase 7: Validation (→ prompt-validator)
    │
    │ Validator checks quality, reports issues
    │ Automatic handoff (send: true)
    │ Can run in background for large codebases
    │
    ├─── PASSED → ✅ Complete (Agent HQ marks session complete)
    │
    ▼ (FAILED)
Phase 8: Fix (→ prompt-updater)
    │
    │ Updater applies fixes (max 3 iterations)
    │ Re-validates automatically
    │
    ├─── Iteration < 3 → Loop to Phase 7
    │
    ▼ (Iteration = 3, still failing)
    ❌ Escalate to user
```

### Handoff Configuration: `send: true` vs `send: false`

| Configuration | Behavior | Use When |
|---------------|----------|----------|
| `send: false` | User sees output, decides whether to proceed | User should review intermediate results |
| `send: true` | Automatic handoff, no user intervention | High confidence, routine validation |

**Our Pattern**:
- Research → User reviews findings (`send: false`)
- Build → User reviews file (`send: false`)
- Validate → Automatic, builder self-checked (`send: true`)
- Fix → Automatic re-validation (`send: true`)

## 📡 Information Exchange Protocols

Effective multi-agent orchestration requires **explicit protocols** for how information flows between components. Without clear contracts, context is lost, tokens are wasted, and reliability suffers.

### Explicit Data Contracts

Every handoff MUST define **what flows** between agents using explicit contracts:

```yaml
handoffs:
  - label: "Research Requirements"
    agent: prompt-researcher
    send: true           # Current conversation context flows to agent
    receive: "report"    # Expects structured text report back
    data_contract:
      input: "User requirements + initial goal"
      output: "Research report (patterns, templates, recommendations)"
      format: "Structured markdown"
```

### Communication Format: Text Reports > JSON

<mark>**Critical Decision**</mark>: Use **structured natural language** instead of JSON between agents.

| Format | Reliability | Human Review | Token Efficiency |
|--------|-------------|--------------|------------------|
| **<mark>Structured Text</mark>** | ✅ High (LLM native) | ✅ Easy | ✅ Good (context reuse) |
| **JSON** | ⚠️ Lower (parsing issues) | ❌ Harder | ⚠️ Poor (verbose) |

**Why Text Over JSON?**
- LLMs process natural language more reliably than structured data
- Semantic structure provides implicit prioritization
- Creates human-readable checkpoints for review
- Easier to debug and verify correctness

### Standardized Report Formats

Agents should produce **consistent, structured reports** for downstream consumption:

**Research Report Template**:
```markdown
# Research Report: {Topic}

## Context Summary
[1-2 paragraph overview - what orchestrator provided]

## Key Patterns Discovered
### Pattern 1: {Name}
- **Location**: {file paths}
- **Relevance**: {why it matters for this task}

## Recommendations
1. **MUST apply**: {critical patterns with justifications}
2. **SHOULD consider**: {best practices}
3. **AVOID**: {anti-patterns}

## Handoff Notes
**For Builder Agent**: 
- Focus on: {specific aspects from research}
- Apply patterns: {list with file references}
- Template recommendation: {specific template path}
```

**Validation Report Template**:
```markdown
# Validation Report: {File}

## Summary
- **Status**: {PASS / FAIL / NEEDS_REVIEW}
- **Issues Found**: {count by severity}

## Checks Performed
### ✅ PASSED
- [x] YAML syntax valid
- [x] Required fields present

### ❌ FAILED
- [ ] Three-tier boundaries incomplete
  - **Issue**: Missing "Never Do" section
  - **Location**: Line {N}
  - **Fix**: Add boundary section

## Recommended Actions
### For Updater Agent
1. Add missing section at line {N}
2. Fix broken reference at line {M}
```

### Context Carryover Strategies

<mark>**Problem**</mark>: Information loss during agent transitions is the #1 cause of multi-agent workflow failures.

**Solution: Natural Language References to Conversation Context**

When a handoff occurs (via `send: true` or user click), the **entire conversation history** flows to the target agent.  
Use natural language references to prior outputs:

```yaml
handoffs:
  - label: "Generate Tests"
    agent: test-specialist
    prompt: |
      Create comprehensive tests for the implementation discussed above.
      
      Validate all requirements identified in the research phase.
      Cover the edge cases documented during planning.
      Reference the implementation details from the builder's output.
      
      Generate tests covering all requirements and edge cases.
```

**Key Principle**: Handoff prompts reference previous phase outputs using **natural language** ("the requirements above", "from the research phase") because conversation history is automatically available to the target agent.

> **⚠️ Feature Gap: Explicit Variable Binding**
> 
> VS Code handoff prompts do **not** currently support custom variable interpolation like `${requirements}` or `${edgeCases}`. This would improve reliability by:
> - Explicitly binding named values from prior phases
> - Preventing context loss when conversation history is long
> - Enabling validation that required context exists before handoff
> 
> **Current workaround**: Use explicit natural language references and rely on conversation history. For critical data, consider file-based context passing (see Pattern 1 below).

#### Supported VS Code Variables (Prompt Files Only)

VS Code supports these **built-in variables** in `.prompt.md` file bodies (not in handoff `prompt:` fields):

| Category | Variables |
|----------|----------|
| **Workspace** | `${workspaceFolder}`, `${workspaceFolderBasename}` |
| **File context** | `${file}`, `${fileBasename}`, `${fileDirname}`, `${fileBasenameNoExtension}` |
| **Selection** | `${selection}`, `${selectedText}` |
| **User input** | `${input:variableName}`, `${input:variableName:placeholder}` |

<mark>These are **not available** in agent handoff prompts</mark> but only in the main prompt body.

### Token-Efficient Communication Patterns

<mark>**The Token Cost Problem**</mark>: When `send: true` triggers a handoff, VS Code transfers the **entire conversation history** to the receiving agent. For multi-phase workflows, this creates compounding token costs:

| Workflow Stage | Cumulative Context | Token Estimate |
|----------------|-------------------|----------------|
| Phase 1: Requirements | User request only | ~200 tokens |
| Phase 2: Research | + Research report | ~3,500 tokens |
| Phase 3: Architecture | + Analysis output | ~5,000 tokens |
| Phase 4: Build | + All previous phases | ~6,500 tokens |
| Phase 5: Validate | + Built file content | ~8,000 tokens |

**Why This Matters:**
- **<mark>Cost</mark>**: Each handoff multiplies API token usage
- **<mark>Context Window Limits</mark>**: Long histories may exceed model limits (128K-200K tokens)
- **<mark>"Lost in the Middle" Effect</mark>**: LLMs attend less to middle portions of long contexts
- **<mark>Irrelevant Context</mark>**: Validator doesn't need research discovery process—just the spec

#### VS Code Handoff Mechanism: Current Limitations

The `send` field in handoff configuration is **binary**:

| Setting | Behavior | Token Impact |
|---------|----------|--------------|
| `send: true` | **Full conversation history** transfers to agent | High—all prior phases included |
| `send: false` | User sees output, manually triggers next step | Variable—user controls what's shared |

<mark>**Key Limitation**</mark>: VS Code does **not** currently support selective context filtering in handoffs. You cannot specify "send only Phase 3 output" directly.

**Available Workarounds:**

| Technique | Token Reduction | Effort | Best For |
|-----------|-----------------|--------|----------|
| **Prompt-Directed Attention** | ⚠️ None (attention only) | Low | Focusing agent behavior |
| **Progressive Summarization** | ✅ Moderate | Medium | Multi-phase workflows |
| **User-Mediated Handoff** | ✅ High | High | Maximum control |
| **File-Based Isolation** | ✅ Maximum | Medium | Specialized agents |

---

#### Pattern 1: Reference-First (Not Embed-First)

**Token Savings**: ~80-90% for referenced content

```markdown
✅ **Efficient** (~50 tokens): 
"For validation rules, see .copilot/context/00.00 prompt-engineering/06-adaptive-validation-patterns.md"

❌ **Wasteful** (~2,000 tokens):
[Embeds 200 lines of validation rules in handoff prompt]
```

**When to Use**: For stable reference material (patterns, templates, guidelines) that the receiving agent can read via `read_file` tool.

---

#### Pattern 2: Selective Context Passing (Conceptual)

Define **what each agent actually needs** to prevent unnecessary context accumulation:

**Validator Agent Needs:**
- ✅ File path to validate (~20 tokens)
- ✅ Specification from Phase 3 (~300 tokens)
- ✅ Critical boundaries to check (~100 tokens)
- **Total needed: ~420 tokens**

**Validator Does NOT Need:**
- ❌ Entire research report (~2,500 tokens) — pattern history irrelevant to validation
- ❌ User's original request (~200 tokens) — already incorporated in spec
- ❌ Template discovery process (~800 tokens) — not relevant to validation
- **Wasted context: ~3,500 tokens**

**Implementation**: Use Progressive Summarization (Pattern 3) or File-Based Isolation (Pattern 7) to achieve selective passing.

---

#### Pattern 3: Progressive Summarization

**Token Savings**: 70-85% reduction across multi-phase workflows

Each phase produces **preprocessed summaries** for downstream consumption, discarding intermediate work:

```markdown
Phase 2: Research
├── Full output: **3,000 tokens** (patterns, examples, analysis)
└── Summary for next phase: **400 tokens** (recommendations only)
        ↓
Phase 3: Structure Definition  
├── Full output: **1,500 tokens** (analysis, decisions)
└── Specification for builder: **500 tokens** (what to build)
        ↓
Phase 4: Builder receives **500 tokens**, not 4,500
```

**Implementation in Agent Instructions:**

```markdown
## Output Format

### Full Report (for user review)
[Complete analysis with evidence and reasoning]

### Handoff Summary (for next agent)
<!-- HANDOFF_START -->
**File**: {path}
**Template**: {template name}
**Key Requirements**:
1. {requirement 1}
2. {requirement 2}
**Boundaries**: {critical constraints}
<!-- HANDOFF_END -->
```

The orchestrator extracts only the `<!-- HANDOFF_START -->` block for the next phase.

---

#### Pattern 4: Narrow-Before-Wide Search

**Token Savings**: 60-80% on search operations

```markdown
✅ **Efficient Search Order** (~2,500 tokens total):
1. grep_search for specific pattern → 500 tokens (targeted results)
2. read_file only matched files → 2,000 tokens (relevant content)
3. semantic_search only if grep finds nothing → (avoided)

❌ **Expensive Search Order** (~12,500 tokens total):
1. semantic_search for broad query → 2,000 tokens (many results)
2. read_file on all results → 10,000 tokens (mostly irrelevant)
3. grep_search to find specific pattern → 500 tokens (should have started here)
```

---

#### Pattern 5: Prompt-Directed Attention

**Token Savings**: ⚠️ None—but improves reliability

When full context must be sent, use the `prompt:` field to **direct the agent's attention** to specific elements:

```yaml
handoffs:
  - label: "Apply Updates"
    agent: prompt-updater
    send: true  # Full history still sent
    prompt: |
      Apply the updates from the validation report above.
      
      **FOCUS ON** (ignore other conversation context):
      - File: `.github/prompts/grammar-review.prompt.md`
      - Issues to fix: See "❌ FAILED" section in validation report
      - Preserve: All passing sections unchanged
      
      **IGNORE**: Research phase, architecture analysis, template selection.
```

**Why This Helps**: Even though full context is sent, the explicit `prompt:` instructions tell the agent what subset matters, reducing "lost in the middle" attention problems.

---

#### Pattern 6: User-Mediated Selective Handoff

**Token Savings**: ✅ Maximum control (user filters context)

Use `send: false` to create a **manual checkpoint** where the user controls what context continues:

```yaml
handoffs:
  - label: "Validate Prompt"
    agent: prompt-validator
    send: false  # User decides what to share
```

**Workflow:**

1. Orchestrator completes Phase 3, produces specification
2. User sees: "Ready to validate. Click 'Validate Prompt' to continue."
3. User clicks handoff button
4. **New chat session opens** with validator agent
5. User pastes **only the specification** (not full history)
6. Validator works with minimal context

**Trade-off**: Higher user effort, but maximum token efficiency and context control.

---

#### Pattern 7: File-Based Context Isolation

**Token Savings**: ✅ Maximum (conversation history bypassed entirely)

For agents that need **truly isolated context**, write structured input to a temporary file:

**Orchestrator writes spec file:**
```markdown
## Phase 3 Output → Write to file

Create specification file for downstream agents:

**File**: `.copilot/temp/{timestamp}-phase3-spec.md`

```markdown
# Build Specification

**Target**: `.github/prompts/grammar-review.prompt.md`
**Template**: `prompt-validation-template.md`
**Requirements**:
1. Check grammar in markdown articles
2. Exclude code blocks from analysis
3. Report issues by severity

**Boundaries**:
- IN SCOPE: Grammar, spelling, punctuation
- OUT OF SCOPE: Style, tone, technical accuracy
```
```

**Handoff instructs agent to read file:**
```yaml
handoffs:
  - label: "Build from Specification"
    agent: prompt-builder
    send: false  # Don't send conversation
    prompt: |
      Read the build specification from `.copilot/temp/latest-spec.md`
      and create the prompt file according to that specification.
      
      Ignore any other context—the spec file contains everything you need.
```

**File Location Convention:**
- **Path**: `.copilot/temp/` (add to `.gitignore`)
- **Naming**: `{ISO-timestamp}-{phase}-{topic}.md`
- **Cleanup**: Delete after workflow completes or after 24 hours

**Example `.gitignore` entry:**
```gitignore
# Temporary handoff context files
.copilot/temp/
```

---

### Agent Input Expectations

Each agent should document its **minimal required inputs** to help orchestrators compress context appropriately:

#### Declaring Input Expectations (in Agent Files)

Add an `## Expected Inputs` section to each agent:

```markdown
## Expected Inputs

This agent requires minimal context to operate effectively:

| Input | Required | Token Budget | Source |
|-------|----------|--------------|--------|
| **File path** | ✅ Yes | ~20 tokens | Orchestrator |
| **Update specification** | ✅ Yes | ~300 tokens | Phase 3 output |
| **Issues to fix** | ✅ Yes | ~200 tokens | Validation report |
| **Research context** | ❌ No | 0 tokens | Not needed |
| **User's original request** | ❌ No | 0 tokens | Already in spec |

**Total input budget**: ~520 tokens (vs. ~5,000 for full conversation)

### Preferred Handoff Method

1. **Best**: File-based isolation (Pattern 7)
2. **Good**: User-mediated with spec paste (Pattern 6)  
3. **Acceptable**: Full context with prompt-directed attention (Pattern 5)
```

#### Quick Reference: Agent Input Requirements

| Agent | Required Inputs | Unnecessary Context | Preferred Method |
|-------|-----------------|---------------------|------------------|
| `prompt-validator` | File path, checklist | Research, architecture decisions | File-based or directed |
| `prompt-updater` | File path, issues list, fix instructions | Full validation report, research | File-based |
| `prompt-builder` | Specification, template path | Research discovery process | Summarized handoff |
| `grammar-review` | Article path, grammar rules reference | All workflow context | File-based (article only) |
| `readability-review` | Article path, readability metrics | All workflow context | File-based (article only) |

---

### Token Budget Estimates by Handoff Strategy

| Strategy | Typical Tokens | Best For | Trade-off |
|----------|---------------|----------|-----------|
| **Full context** (`send: true`) | 5,000-15,000 | Simple 2-3 phase workflows | High cost, simple setup |
| **Prompt-directed** | 5,000-15,000 | When full context needed but focus required | No reduction, better attention |
| **Progressive summarization** | 1,500-3,000 | Multi-phase workflows | Moderate effort, good reduction |
| **User-mediated** | 200-800 | Maximum control needed | High user effort |
| **File-based isolation** | 300-600 | Specialized single-purpose agents | Setup overhead, maximum reduction |

**Rule of Thumb**: 
- **<3 phases**: Full context acceptable
- **3-5 phases**: Use progressive summarization  
- **>5 phases or specialized agents**: Consider file-based isolation

---

### Handoff Prompt Template (Token-Optimized)

Use this structure for all phase transitions:

```yaml
handoffs:
  - label: "{Action Description}"
    agent: {target-agent}
    send: true
    prompt: |
      {Primary Task Statement - 1 sentence}
      
      **FOCUS ON** (from conversation above):
      - {Specific output from previous phase}
      - {Key decision or specification}
      
      **IGNORE** (not relevant to your task):
      - {Earlier phases not needed}
      - {Discovery/research process}
      
      **Your Required Inputs**:
      - {Input 1}: {value or reference to above}
      - {Input 2}: {value or reference to above}
      
      **Expected Output Format**:
      {Structured template for this agent's response}
      
      **Success Criteria**:
      - {Criterion 1}
      - {Criterion 2}
```

---

### Reliability Checksum Pattern

Before each handoff, the orchestrator validates that **critical data survives the transition**:

```markdown
## Phase Transition Checklist

Before handing off Phase {N} → Phase {N+1}, verify:

- [ ] **Goal Preservation**: Refined goal from Phase 1 still intact?
- [ ] **Scope Boundaries**: IN/OUT scope still clear?
- [ ] **Tool Requirements**: Tool list carried forward?
- [ ] **Critical Constraints**: Boundaries included in handoff?
- [ ] **Success Criteria**: Validation criteria defined?

**If any checkbox fails**: Re-inject missing context before handoff.
```

## 🧠 Structure Definition & Architecture Analysis (Phase 3)

The orchestrator's most important job is **determining optimal architecture** for the task. This happens in Phase 3, which now includes tool composition validation and agent dependency planning.

### The Architecture Decision Problem

When a user requests "Create a prompt for code review," should we create:

**Option A: Single Prompt**
- One file: `code-review.prompt.md`
- Contains all logic in one place
- Simpler but potentially bloated

**Option B: Orchestrator + Agents**
- Orchestrator: `code-review-orchestrator.prompt.md`
- Agents: `security-reviewer.agent.md`, `style-reviewer.agent.md`, etc.
- More complex but modular and reusable

### Phase 3: Architecture Analysis Process

```markdown
### Phase 3: Prompt and Agent Structure Definition (Orchestrator)

**Goal:** Analyze task requirements to determine optimal architecture.

#### 1. Task Complexity Assessment

Analyze requirements from Phase 1 and research from Phase 2:

**Multi-phase workflow?**
- Does task divide into distinct phases? (analyze → execute → validate)
- Are phases sequential with clear handoff points?

**Cross-domain expertise?**
- Does task span multiple domains? (code, tests, docs)
- Would different specialists have different tool needs?

**Complexity Level:**
- **Low**: Single focused task, one domain
- **Medium**: 2-3 steps, same tools
- **High**: 3+ phases, multiple domains, different tools per phase
```

### Decision Framework

| Criteria | Single Prompt | Orchestrator + Agents |
|----------|---------------|----------------------|
| **<mark>Phases</mark>** | 1-2 linear steps | 3+ distinct phases |
| **<mark>Domains</mark>** | Single domain | Cross-domain |
| **<mark>Tools</mark>** | Consistent tools | Different tools per phase |
| **<mark>Existing agents</mark>** | None applicable | 1+ agents reusable |
| **<mark>New agents</mark>** | None justified | Reusable specialists identified |
| **<mark>Complexity</mark>** | Low-Medium | Medium-High |

### Existing Agent Inventory

Before recommending new agents, the orchestrator checks what already exists:

```markdown
#### 2. Existing Agent Inventory

Search `.github/agents/` directory for applicable agents:

1. List all agents: `file_search` in `.github/agents/*.agent.md`
2. Read agent descriptions (YAML frontmatter + purpose sections)
3. Match agent capabilities to task phases
4. Evaluate: Can existing agents be reused or extended?

**Analysis output:**

### Existing Agents Applicable to Task

**Directly applicable:**
- `prompt-researcher` → Research phase (100% match)
- `prompt-validator` → Validation phase (100% match)

**Coverage:** 50% existing, 25% new, 25% orchestrator-only
```

### New Agent Opportunities

When existing agents don't cover all phases:

```markdown
#### 3. New Agent Opportunities

**Criteria for new agent:**
- [ ] Represents reusable specialist persona (not task-specific)
- [ ] Has distinct tool needs from other agents
- [ ] Could be coordinated by multiple orchestrators
- [ ] Has clear boundaries and single responsibility

**Anti-patterns (don't create agent):**
- Task-specific logic with no reuse potential
- Same tools as existing agent (extend instead)
- One-off implementation need

**Recommendation:**

### Recommended New Agents

**Agent 1: security-analyzer.agent.md**
- **Purpose:** Analyze code for security vulnerabilities
- **Reusability:** Security audits, PR reviews, compliance checks
- **Justification:** Distinct expertise, reusable across multiple workflows
```

### Tool Composition Validation

Before finalizing architecture, validate tool composition to prevent common failures:

```markdown
### Tool Composition Validation Report

**Prompt/Agent**: [name]
**Agent Mode**: [plan/agent]

#### 1. Tool Count Check
**Count**: [N] tools
- ✅ 3-7 tools: Optimal scope
- ⚠️ <3 tools: May be insufficient for task
- ❌ >7 tools: Tool clash risk - MUST decompose

**If >7 tools detected:**
→ Decompose into orchestrator + specialized agents
→ Each agent gets subset of tools (3-7 each)
→ Re-run architecture analysis

#### 2. Agent/Tool Alignment Check

| Agent Mode | Allowed Tools | Status |
|------------|---------------|--------|
| `plan` | Read-only tools only | [✅/❌] |
| `agent` | Read + Write tools | [✅/❌] |

**Write tools** (require `agent: agent`):
- `create_file`
- `replace_string_in_file`
- `multi_replace_string_in_file`
- `run_in_terminal`

**Alignment failures:**
- `plan` + write tools → ❌ FAIL (agent can't execute writes)
- `agent` + only read tools → ⚠️ Warning (may be intentional, but verify)

#### 3. Tool Redundancy Check
- Overlapping capabilities: [list any]
- Recommendation: [consolidate or justify]

**Validation Result**: [✅ PASSED / ⚠️ WARNINGS / ❌ FAILED]
```

### Agent Dependencies Planning (Phases 5-6)

When Phase 3 identifies agent dependencies, dedicated phases plan their creation:

#### Phase 5: Agent Update Planning

For **existing agents** that need modification:

```markdown
## Phase 5: Agent Updates Required

### Update Queue

**1. prompt-researcher.agent.md**
- **Change Type**: Behavioral
- **Changes**: Add use case challenge validation to research output
- **Impact**: Low - additive only
- **Approval**: Required before proceeding

**2. prompt-validator.agent.md**
- **Change Type**: Structural  
- **Changes**: Add tool alignment validation checks
- **Impact**: Medium - affects validation output format
- **Approval**: Required before proceeding

### Change Impact Categories

| Category | Definition | Approval |
|----------|------------|----------|
| **Structural** | Changes file organization, sections, or YAML | Required |
| **Behavioral** | Changes what agent does or how | Required |
| **Cosmetic** | Formatting, typos, clarifications | Optional |
| **Fix** | Addresses validation failure | Auto-approved |

**Approve update plan? (yes/no/modify)**
```

#### Phase 6: New Agent Creation Planning

For **new agents** that need to be created:

```markdown
## Phase 6: New Agent Creation Plan

### Agents to Create

**1. agent-researcher.agent.md**
- **Purpose**: Research agent patterns and conventions
- **Role**: Read-only specialist for agent domain
- **Tools**: [semantic_search, read_file, file_search, grep_search]
- **Agent mode**: plan (read-only)
- **Boundaries**:
  - Always: Search .github/agents/ first
  - Ask First: When no similar agents found
  - Never: Create or modify files
- **Handoffs**: None (returns to orchestrator)
- **Template**: agent-researcher-template.md

**2. agent-builder.agent.md**
- **Purpose**: Create new agent files
- **Role**: Write specialist for agent domain
- **Tools**: [read_file, semantic_search, create_file, file_search]
- **Agent mode**: agent (write access)
- **Boundaries**:
  - Always: Follow template structure
  - Ask First: When tool count approaches 7
  - Never: Modify existing agents
- **Handoffs**: → agent-validator (send: true)
- **Template**: agent-builder-template.md

### Recursion Control

**Maximum recursion depth**: 2 levels
- Level 0: Main orchestrator creates prompt
- Level 1: Prompt creation requires new agent
- Level 2: Agent creation can use existing agents only

❌ If Level 2 requires new agents → STOP, escalate to user

### Processing Recommendation

Create agents using: `@agent-design-and-create`

**Approve creation plan? (yes/no/modify)**
```

## 🔧 Handling Agent Creation Within the Workflow

When Phase 3 determines that new agents are needed, the workflow branches:

### Modified Build Phase

```
Phase 3 Output: "Orchestrator + Agents" recommended
    │
    │ New agents needed: 2
    │ Existing agents reusable: 2
    │
    ▼
Phase 4a: Create New Agents (Iterative)
    │
    │ For each new agent:
    │   → Research agent patterns (prompt-researcher)
    │   → Build agent file (agent-builder)
    │   → Validate agent (agent-validator)
    │   → User reviews
    │
    ▼
Phase 4b: Create Orchestrator
    │
    │ Build orchestrator that coordinates:
    │   - Existing agents
    │   - Newly created agents
    │
    ▼
Phase 5: Validate All Files
```

### The Agent Creation Sub-Workflow

When creating agents, we need **agent-specific specialists**:

```yaml
# Phase 4a handoff for each new agent
handoff:
  label: "Build agent file: security-analyzer"
  agent: agent-builder  # NOT prompt-builder!
  send: false
  context: |
    Build new agent file from Phase 3 recommendations.
    
    Agent specifications:
    - Name: security-analyzer
    - Purpose: Analyze code for security vulnerabilities
    - Persona: Security expert
    - Tools: [read_file, grep_search, semantic_search]
    - Agent type: plan (read-only analysis)
    
    Create file at: .github/agents/security-analyzer.agent.md
```

### Why Separate `agent-builder` from `prompt-builder`?

| Aspect | prompt-builder | agent-builder |
|--------|----------------|---------------|
| **Output location** | `.github/prompts/` | `.github/agents/` |
| **Template knowledge** | Prompt templates | Agent templates |
| **Key patterns** | Phase workflows, tool lists | Personas, handoffs, expertise |
| **YAML focus** | `agent:`, `tools:`, `argument-hint:` | `tools:`, `handoffs:`, `description:` |

The builder needs domain-specific knowledge to produce optimal files.

### Iterative Agent Creation

When multiple agents are needed, create them iteratively:

```markdown
## Phase 4a Progress: Agent Creation

**Agents to create:** 2
**Agents completed:** 1

### Agent 1: security-analyzer.agent.md
**Status:** ✅ Created
**Path:** `.github/agents/security-analyzer.agent.md`
**Tools:** [read_file, grep_search, semantic_search]

### Agent 2: performance-analyzer.agent.md
**Status:** 🔄 In Progress

**Proceed with Agent 2? (yes/no/review Agent 1)**
```

## 🔄 The Complete Workflow

### Standard Flow (Single Prompt)

```
User: "Create a prompt to validate API documentation"

Phase 1: Requirements
├── Type: validation (read-only)
├── Scope: API docs files
└── Tools: read_file, grep_search

Phase 2: Research → prompt-researcher
├── Found 3 similar prompts
├── Template: prompt-simple-validation-template.md
└── Key patterns identified

Phase 3: Architecture Analysis
├── Complexity: Low
├── Phases: 1 (validation only)
└── Decision: Single Prompt ✓

Phase 4: Build → prompt-builder
└── Created: api-docs-validation.prompt.md

Phase 5: Validate → prompt-validator
└── Status: PASSED ✅

✅ Complete: api-docs-validation.prompt.md ready for use
```

### Complex Flow (Orchestrator + New Agents)

```
User: "Create a comprehensive code review system"

Phase 1: Requirements
├── Type: orchestration
├── Scope: Full codebase review
└── Multi-domain: security, style, performance, tests

Phase 2: Research → prompt-researcher
├── Found orchestration patterns
├── Template: prompt-multi-agent-orchestration-template.md
└── Identified 4 review domains

Phase 3: Architecture Analysis
├── Complexity: High
├── Phases: 4 distinct review phases
├── Existing agents: 0 applicable
├── New agents needed: 4
└── Decision: Orchestrator + Agents ✓

Phase 4a: Create Agents (Iterative)
├── Agent 1: security-reviewer.agent.md ✅
├── Agent 2: style-reviewer.agent.md ✅
├── Agent 3: performance-reviewer.agent.md ✅
└── Agent 4: test-coverage-reviewer.agent.md ✅

Phase 4b: Create Orchestrator → prompt-builder
└── Created: code-review-orchestrator.prompt.md
    └── Coordinates all 4 new agents

Phase 5: Validate All → prompt-validator
├── security-reviewer.agent.md: PASSED ✅
├── style-reviewer.agent.md: PASSED ✅
├── performance-reviewer.agent.md: PASSED ✅
├── test-coverage-reviewer.agent.md: PASSED ✅
└── code-review-orchestrator.prompt.md: PASSED ✅

✅ Complete: Full code review system ready
```

## ⚙️ Execution Flow Control Patterns

Multi-agent orchestrations require explicit **flow control** to prevent infinite loops, handle errors gracefully, and coordinate parallel execution.

### Iteration Control with Bounded Loops

<mark>**Critical Rule**</mark>: All validation-fix cycles MUST have **explicit termination conditions**.

```markdown
## Validation Loop Control

### Loop Constraints
- **Maximum iterations**: 3
- **Current iteration**: {N}/3

### Exit Conditions
1. ✅ **Clean Exit**: All validation checks pass
2. ⚠️ **User Override**: User explicitly approves despite issues
3. ❌ **Escalation**: Maximum iterations reached
```

#### Escalation Protocol

When validation loops exhaust their iteration limit:

```markdown
## ⚠️ Validation Loop Exhausted

After 3 fix attempts, validation still reports issues:

**Remaining Issues**:
- {Critical issue 1 with line numbers}
- {Critical issue 2 with line numbers}

**Options**:
1. **Continue with current state** - Accept issues, mark as "needs-review"
2. **Manual intervention** - Provide specific guidance for next fix attempt
3. **Restart workflow** - Abandon current file, start fresh with refined requirements

**Recommended**: Option 2 if issues are minor; Option 3 if fundamental.

**Your decision?**
```

### Recursion Control for Agent Creation

<mark>**Pattern**</mark>: Agent creation within orchestration MUST have **depth limits** to prevent complexity explosion.

```markdown
## Recursive Agent Creation Constraints

### Maximum Recursion Depth: 2 Levels

**Level 0**: Main orchestrator (prompt-design-and-create)
  ↓ Creates prompt requiring new agent
**Level 1**: Prompt creation triggers agent-design-and-create
  ↓ Agent creation can use existing agents only
**Level 2**: If Level 2 requires NEW agents → ❌ STOP, escalate
```

#### Recursion Depth Escalation

```markdown
## 🛑 Recursion Depth Limit Reached

The current workflow has reached maximum agent creation depth:

**Current Chain**:
- Level 0: Creating prompt "{prompt-name}"
- Level 1: Prompt requires new agent "{agent-1-name}"
- Level 2: Agent requires new agent "{agent-2-name}"
- **BLOCKED**: Cannot create "{agent-2-name}" (depth > 2)

**Options**:
1. **Use existing agent** - Select from: {list of applicable agents}
2. **Simplify design** - Redesign "{agent-1-name}" to not require "{agent-2-name}"
3. **Manual intervention** - Create "{agent-2-name}" separately, then resume

**Recommended**: Option 2 (simplification) to avoid complexity explosion.
```

### Error Handling Paths

Every handoff should define **failure scenarios and recovery strategies**:

```yaml
handoffs:
  - label: "{Primary Action}"
    agent: {primary-agent}
    send: true
    on_success:
      next: "{success-handler-agent}"
    on_failure:
      recovery: "{failure-handler-agent}"
      user_intervention: {true/false}
```

#### Build Phase Error Handling Example

```markdown
## Phase 4: Build → Validation

### Primary Path (Success)
**If builder succeeds**:
→ Automatic handoff to validator

### Fallback Path (Recoverable Failure)
**If builder fails** (tool count > 7, missing template, etc.):
→ Handoff to prompt-researcher with:
  "Builder failed due to: {error}. Research alternative approach."
→ User reviews alternative approach
→ Re-attempt build with refined specification

### Terminal Failure Path
**If 2 build attempts fail**:
→ Escalate to user with:
  "Build phase failed twice. Issues: {list}. 
   Options: (1) Manual intervention, (2) Restart with different requirements"
```

### Parallel vs. Sequential Execution

VS Code v1.107+ supports **background execution** with work tree isolation. Choose execution mode based on phase dependencies:

| Phases | Dependencies | Recommendation |
|--------|--------------|----------------|
| Research + External Validation | None (independent) | ✅ **Parallel** possible |
| Research → Build | Build needs research output | ❌ **Sequential** required |
| Build → Validate | Validation needs built file | ❌ **Sequential** required |
| Fix → Re-validate | Re-validation needs fixed file | ❌ **Sequential** required |

#### Background Delegation Pattern

```markdown
## Phase 2: Research Complete

Research findings ready.

**Delegation Options**:

1. **"Continue in Background"** (Recommended for large tasks):
   - Build phase runs in isolated work tree
   - You can continue other work
   - Review completed file when background session completes
   - Agent HQ marks session for your attention
   
2. **"Continue Local"** (Interactive mode):
   - Build phase runs immediately in workspace
   - See file creation in real-time
   - Best for quick iterations
```

### Flow Control Decision Matrix

| Situation | Control Mechanism | Example |
|-----------|-------------------|---------|
| Validation fails repeatedly | **Bounded iteration** | Max 3 attempts, then escalate |
| Agent creation needs more agents | **Recursion limit** | Max depth 2, then escalate |
| Phase can't complete | **Error recovery path** | Try alternative approach or manual intervention |
| Long-running build | **Background execution** | Continue in work tree, notify on completion |
| High-risk operation | **User checkpoint** | Explicit approval before destructive action |
| Independent phases | **Parallel execution** | Multiple researchers simultaneously |

### Implementing Checkpoints

Strategic checkpoints ensure user control at critical moments:

```markdown
## Checkpoint Placement Guidelines

### ✅ ALWAYS checkpoint before:
- File creation or modification (Phase 4)
- Agent creation (Phase 4a, 6)
- Deployment or external system changes

### ✅ ALWAYS checkpoint after:
- Research phase (user reviews patterns)
- Structure definition (user approves spec)
- Validation with warnings (user decides to accept or fix)

### ⚠️ Optional checkpoint:
- Validation with clean pass (can auto-proceed)
- Fix phase (auto-triggers re-validation)
```

## 💡 Key Design Decisions

### 1. Orchestrator Never Implements

The orchestrator's only jobs are:
- Gather requirements
- Analyze architecture
- Hand off to specialists
- Present results

**Why?** Keeps orchestrator focused, prevents context bloat, ensures specialists have full context for their domain.

### 2. Builder Creates, Updater Modifies

Clear separation of responsibilities:

| Action | Agent |
|--------|-------|
| Create NEW file | `prompt-builder` or `agent-builder` |
| Modify EXISTING file | `prompt-updater` or `agent-updater` |

**Why?** Prevents accidental overwrites, different tools needed (create_file vs. replace_string_in_file).

### 3. Automatic Validation After Build

```yaml
handoffs:
  - label: "Validate"
    agent: prompt-validator
    send: true  # Automatic
```

**Why?** Builder already self-checks, validation is routine, reduces user fatigue.

### 4. Automatic Re-validation After Fix

```yaml
# In prompt-updater
handoffs:
  - label: "Re-validate After Update"
    agent: prompt-validator
    send: true  # Automatic
```

**Why?** Ensures fixes actually resolved issues, creates feedback loop.

### 5. User Approval for Research and Build

```yaml
handoffs:
  - label: "Research"
    agent: prompt-researcher
    send: false  # User reviews
  - label: "Build"
    agent: prompt-builder
    send: false  # User reviews
```

**Why?** User should validate research direction and review generated files before validation.

### Validation Loop Limits

Validation/fix cycles can loop indefinitely without limits. Apply these constraints:

```markdown
### Validation Loop Rules

**Maximum iterations**: 3
**Current iteration**: [1/2/3]

**After each iteration:**
- Iteration 1: Apply fixes, re-validate automatically
- Iteration 2: Apply fixes, re-validate automatically  
- Iteration 3: If still failing → STOP, escalate to user

**Escalation message:**
"Validation failed after 3 fix attempts. Issues remaining:
- [issue 1]
- [issue 2]

Options:
1. Continue with current state (acknowledge issues)
2. Manually review and provide guidance
3. Abandon and restart with different approach"
```

**Why?** Prevents infinite loops when validation and fixing can't converge on a solution.

### Pre-Save Validation

Builders must self-validate **before** saving files to catch issues early:

```markdown
### Pre-Save Validation Checklist

**Before saving file, verify:**

- [ ] **Tool count**: [N] tools (MUST be 3-7)
      - If <3: Verify task is narrow enough
      - If >7: STOP → decompose into multiple agents

- [ ] **Agent mode / tool alignment**:
      - `plan` + write tools = ❌ FAIL
      - `agent` + only read tools = ⚠️ Verify intentional

- [ ] **Three-tier boundaries complete**:
      - ✅ Always Do section present
      - ⚠️ Ask First section present  
      - 🚫 Never Do section present

- [ ] **Bottom metadata block present** (for articles)

- [ ] **Examples included** (minimum 2 usage examples)

**If any critical check fails**: STOP, report issue, do not save
```

**Why?** Catching issues before file creation is cheaper than validation/fix cycles.

## 🎛️ Context Engineering for Orchestrators

Multi-agent workflows can exceed token limits without optimization. Apply these patterns:

### Lazy Loading Pattern

Orchestrators should **not** preload all context in Phase 1:

❌ **Inefficient:**
```markdown
Phase 1: Read all templates, all context files, all existing agents
```

✅ **Efficient:**
```markdown
Phase 1: Gather requirements only
Phase 2: Agent loads only relevant templates
Phase 3: Agent accesses only needed context
```

### Context Caching

When an agent is active, search results are cached in the conversation:
- First `semantic_search` indexes relevant files
- Subsequent `read_file` calls on same files reuse context
- Switch agents only when role truly changes

### Tool Selection Optimization

Use narrow tool scopes per agent:
- **Orchestrator**: `[read_file, semantic_search]` only (Phase 1 analysis)
- **Specialist agents**: 3-7 tools max per agent
- **Avoid** giving all agents all tools (causes "tool clash")

### Handling Large Tool Sets

When orchestrations involve many MCP servers:
- VS Code supports **virtual tools** (automatic loading when >128 tools)
- Use **tool sets** to group related MCP + built-in tools
- Configure threshold via `github.copilot.chat.virtualTools.threshold` setting

Learn more: `.copilot/context/00.00 prompt-engineering/01-context-engineering-principles.md`

## 📝 Implementation Example

### The Orchestrator YAML

```yaml
---
name: prompt-design-and-create
description: "Orchestrate prompt file design and creation using specialized agents with use case challenge validation"
agent: agent
model: claude-sonnet-4.5
tools:
  - read_file        # Phase 1: Requirements analysis
  - semantic_search  # Phase 3: Architecture analysis
handoffs:
  - label: "Research prompt requirements and patterns"
    agent: prompt-researcher
    send: false  # User reviews research findings
  - label: "Build prompt file from validated specification"
    agent: prompt-builder
    send: false  # User reviews created file
  - label: "Build agent file from validated specification"
    agent: agent-builder
    send: false  # User reviews created agent
  - label: "Validate prompt quality and compliance"
    agent: prompt-validator
    send: true   # Automatic validation after build
  - label: "Validate agent quality and compliance"
    agent: agent-validator
    send: true   # Automatic validation after build
  - label: "Fix validation issues"
    agent: prompt-updater
    send: false  # User reviews fixes if issues persist
argument-hint: 'Describe the prompt purpose: what task it should accomplish, expected inputs/outputs, any constraints'
---

# Prompt Design and Create Orchestrator

You coordinate specialized agents to design and create prompt files following repository best practices.

## 🚨 CRITICAL BOUNDARIES

### ✅ Always Do
- Gather complete requirements before any handoffs
- Challenge goals with use cases before accepting
- Wait for user approval at each phase transition
- Delegate all research/build/validate/update to specialists
- Validate files before declaring completion

### ⚠️ Ask First
- When requirements are ambiguous after use case challenge
- When Phase 3 identifies agent dependencies
- When validation finds critical issues (>3 iterations)

### 🚫 Never Do
- NEVER skip requirements gathering (Phase 1)
- NEVER skip use case challenge validation
- NEVER build without approved specification
- NEVER skip validation phase
- NEVER implement yourself - orchestrate only
```

### Phase 3 Architecture Decision Output

```markdown
## Phase 3 Complete: Architecture Analysis

### Task Complexity
**Level:** High
**Phases identified:** 4
- Phase 1: Security analysis
- Phase 2: Style review
- Phase 3: Performance analysis
- Phase 4: Test coverage check

**Domains:** [security, style, performance, testing]
**Tool variation:** Yes (different tools per phase)

### Agent Inventory
**Existing agents applicable:** 0
**New agents recommended:** 4
- `security-reviewer` → Phase 1 (reusable for: security audits)
- `style-reviewer` → Phase 2 (reusable for: PR reviews)
- `performance-reviewer` → Phase 3 (reusable for: optimization)
- `test-reviewer` → Phase 4 (reusable for: coverage checks)

### Architecture Recommendation

**Recommended approach:** Orchestrator + Agents

**Justification:**
Task has 4 distinct phases spanning multiple domains. Each phase benefits from specialized expertise and different tool sets. All 4 proposed agents are highly reusable for other workflows.

**Implementation strategy:**
1. Create 4 new agents first (Phase 4a)
2. Create orchestrator to coordinate them (Phase 4b)
3. Validate all files (Phase 5)

**Proceed to build phase? (yes/no/modify)**
```

### Real Validator Output Format

Validators produce structured reports that enable automated fix cycles:

```markdown
## Validation Report: prompt-design-and-create.prompt.md

**Overall Status**: ⚠️ WARNINGS (1 critical, 2 minor)
**Validation Iteration**: 1/3

### Agent-Specific Checks

| Check | Result | Details |
|-------|--------|--------|
| Tool Count | ✅ PASS | 2 tools (within 3-7 range for orchestrator) |
| Agent/Tool Alignment | ✅ PASS | `agent` mode with read-only tools (intentional) |
| Handoff Validity | ✅ PASS | 6 handoffs, all targets exist |
| Three-Tier Boundaries | ✅ PASS | Always/Ask/Never sections present |

### Structure Checks

| Check | Result | Details |
|-------|--------|--------|
| YAML Frontmatter | ✅ PASS | All required fields present |
| Description Length | ⚠️ WARN | 98 chars (recommend <80) |
| Role Section | ✅ PASS | Clear specialist description |
| Process Section | ✅ PASS | Phases documented |

### Content Checks

| Check | Result | Details |
|-------|--------|--------|
| Examples Included | ❌ FAIL | 0 examples (minimum 2 required) |
| Boundary Specificity | ⚠️ WARN | "Never Do" could be more specific |

### Issues Summary

**Critical (must fix)**:
1. Missing usage examples - add at least 2 examples

**Minor (should fix)**:
2. Description exceeds 80 characters
3. "Never Do" boundaries could reference specific anti-patterns

### Recommended Actions

```yaml
fixes:
  - type: "add_section"
    location: "after Process section"
    content: "## Usage Examples\n\n### Example 1: Simple Prompt...\n### Example 2: Complex Orchestration..."
  - type: "edit"
    target: "description"
    current: "Orchestrate prompt file design and creation using specialized agents with use case challenge validation"
    proposed: "Orchestrate prompt creation with specialized agents and use case validation"
```

**Handoff to updater? (auto if critical issues)**
```

## 📊 Real Implementation Case Study

The patterns in this article were battle-tested by designing and implementing a complete prompt/agent creation system. The case study documents:

### What Was Built

- **4 Orchestration Prompts**:
  - `prompt-design-and-create.prompt.md` - Creates new prompts/agents
  - `prompt-review-and-validate.prompt.md` - Improves existing prompts/agents
  - `agent-design-and-create.prompt.md` - Creates new agents specifically
  - `agent-review-and-validate.prompt.md` - Improves existing agents

- **8 Specialized Agents** (4 for prompts, 4 for agents):
  - Researchers (read-only pattern discovery)
  - Builders (file creation)
  - Validators (quality assurance)
  - Updaters (targeted fixes)

### Lessons Learned

| Challenge | Solution Applied |
|-----------|------------------|
| Goals seemed clear but failed edge cases | Use Case Challenge methodology (3/5/7 scenarios) |
| Tool count exceeded 7 in initial designs | Tool Composition Validation with decomposition |
| Validation/fix loops didn't converge | Maximum 3 iterations before escalating |
| Agents created with wrong mode/tool combos | Agent/tool alignment validation (`plan` + write = FAIL) |
| Recursive agent creation caused complexity explosion | Maximum recursion depth: 2 levels |
| File changes without user awareness | Explicit approval checkpoints at each phase |

### Success Metrics Achieved

- **Reliability**: 100% of created files pass validation within 3 iterations
- **Quality**: All agents have complete three-tier boundaries
- **Workflow**: Clear approval checkpoints prevent unwanted changes
- **Reusability**: Agents used across multiple orchestrators

### Full Case Study

For complete specifications, implementation roadmap, and detailed agent designs, see:

**[📝 Prompt Creation Multi-Agent Flow - Implementation Plan](./06.1%20example_prompt_interacting_with_agents_plan.md)** `[📒 Internal]`

This companion document includes:
- Complete YAML specifications for all 4 orchestrators
- Detailed agent specifications with boundaries
- 2-week staged implementation roadmap
- Success criteria and validation checklists

## 🎯 Conclusion

Building complex AI workflows requires moving beyond monolithic prompts to orchestrated multi-agent systems. The key principles are:

### Design Principles

1. **Separation of Concerns**: Each agent does one thing well
2. **Narrow Tool Scope**: 3-7 tools per agent maximum (enforced)
3. **Clear Handoffs**: Explicit transitions between agents with approval checkpoints
4. **Use Case Challenge**: Validate goals with 3/5/7 scenarios before building
5. **Architecture Intelligence**: Orchestrator analyzes complexity before building
6. **Tool Composition Validation**: `plan` + write tools = automatic failure
7. **Iterative Creation**: Build agents one at a time with validation
8. **Validation Loop Limits**: Maximum 3 fix iterations before escalating
9. **Pre-Save Validation**: Builders self-check before creating files
10. **Context Optimization**: Lazy loading, context caching, minimal orchestrator tools
```

### The Pattern

```
Orchestrator (coordinates, never implements)
    │
    ├── Researcher (read-only, discovers patterns)
    ├── Builder (write, creates new files, pre-validates)
    ├── Validator (read-only, checks quality, max 3 iterations)
    └── Updater (write, fixes issues)
```

### When to Use This Pattern

| Scenario | Approach |
|----------|----------|
| Simple, focused task | Single prompt file |
| Multi-phase workflow | Orchestrator + existing agents |
| Complex, multi-domain task | Orchestrator + new specialized agents |
| Improving existing prompts | Different orchestrator (review-and-validate) |

By following this pattern, you create maintainable, reusable, and reliable AI workflows that scale with complexity.

---

# ⚠️ Common Mistakes in Multi-Agent Orchestration

Orchestrating multiple agents introduces complexity beyond single-agent workflows. These mistakes can cause coordination failures, context loss, or frustrating user experiences.

## Mistake 1: Unclear Orchestration Responsibility

**Problem**: Confusion about whether the prompt or the agent controls workflow progression.

**❌ Bad example:**
```yaml
# orchestrator.prompt.md
---
agent: planner
---

Plan the implementation, then hand off to @developer.
```

```yaml
# planner.agent.md
---
handoffs:
  - label: "Implement"
    agent: developer
---

Create a plan. Then hand off to developer agent.
```

**Problem:** Both prompt AND agent try to control handoff → duplicate instructions, unclear flow.

**✅ Solution: Orchestrator prompt controls flow, agents execute:**
```yaml
# orchestrator.prompt.md
---
name: feature-workflow
agent: planner
---

# Multi-Phase Feature Implementation

## Phase 1: Planning (@planner)

Create detailed implementation plan.

**When plan is ready:** Hand off to @developer with:
"Implement the plan above, following all specified requirements."

## Phase 2: Implementation (@developer)

[Developer implements]

**When code is ready:** Hand off to @test-specialist with:
"Generate comprehensive tests for this implementation."

## Phase 3: Testing (@test-specialist)

[Tester creates tests]

**Final step:** Hand off to @code-reviewer for merge readiness assessment.
```

```yaml
# planner.agent.md
---
handoffs:
  - label: "Start Implementation"
    agent: developer
    send: false
---

Create implementation plans. The orchestrator prompt controls when to proceed.
```

## Mistake 2: Context Loss Between Handoffs

**Problem**: Critical information from earlier phases gets lost when transitioning between agents.

**❌ Bad example:**
```yaml
handoffs:
  - label: "Test"
    agent: test-specialist
    prompt: "Write tests"
```

**Problem:** Test specialist doesn't know:
- What was implemented
- What requirements it must satisfy
- What edge cases to cover

**✅ Solution: Explicit context carryover in handoff prompts:**
```yaml
handoffs:
  - label: "Generate Tests"
    agent: test-specialist
    prompt: |
      Create comprehensive tests for the implementation above.
      
      **Requirements to validate:**
      ${requirements}
      
      **Edge cases identified during planning:**
      ${edgeCases}
      
      **Expected behavior:**
      ${expectedBehavior}
      
      Generate tests that verify all requirements and edge cases.
```

## Mistake 3: Too Many Sequential Handoffs

**Problem**: Creating workflows with 6+ sequential handoffs creates slow, fragile chains.

**❌ Bad example:**
```yaml
Phase 1: Requirements Analyst
  ↓
Phase 2: Technical Architect
  ↓
Phase 3: Database Designer
  ↓
Phase 4: API Designer
  ↓
Phase 5: Frontend Developer
  ↓
Phase 6: Test Engineer
  ↓
Phase 7: Security Auditor
  ↓
Phase 8: Performance Optimizer
  ↓
Phase 9: Documentation Writer
```

**Problems:**
- 9 context switches
- High chance of failure at any step
- Context dilution
- Slow execution

**✅ Solution: Consolidate related phases, parallelize when possible:**
```yaml
Phase 1: Planning Agent
  - Requirements analysis
  - Technical architecture
  - Database and API design (combined)
  ↓
Phase 2: Implementation Agent
  - Frontend and backend together
  - Security patterns included
  ↓
Phase 3: Quality Agent
  - Testing + performance review (combined)
  - Documentation generation
```

**Reduced to 3 phases, each handling related concerns.**

## Mistake 4: No Failure Recovery Strategy

**Problem**: Workflow has no path forward when an agent can't complete its task.

**❌ Bad example:**
```yaml
handoffs:
  - label: "Deploy"
    agent: deployment-agent
    send: true
```

**What happens if deployment fails?** No fallback, no alternative path.

**✅ Solution: Include fallback handoffs or user intervention points:**
```yaml
## Phase 4: Deployment (@deployment-agent)

Deploy to staging environment.

**On success:** Hand off to @smoke-tester for validation.

**On failure:** Hand off to @troubleshooter with:
"Deployment failed with error: [error details]. Diagnose and suggest fixes."

**If troubleshooting doesn't resolve:** Return control to user for manual intervention.
```

```yaml
# deployment-agent.agent.md
---
handoffs:
  - label: "Validate Deployment"
    agent: smoke-tester
    prompt: "Run smoke tests on staging deployment"
  - label: "Troubleshoot Failure"
    agent: troubleshooter
    prompt: "Diagnose deployment failure: ${error}"
---
```

## Mistake 5: Mixing Orchestration Levels

**Problem**: Creating orchestrators that call other orchestrators, creating confusing nested workflows.

**❌ Bad example:**
```yaml
# master-orchestrator.prompt.md
agent: planning-orchestrator  # Calls another orchestrator

# planning-orchestrator.agent.md
handoffs:
  - agent: implementation-orchestrator  # Calls yet another orchestrator

# implementation-orchestrator.agent.md
handoffs:
  - agent: developer  # Finally, a real agent
```

**Result:** 3 levels of orchestration before actual work starts.

**✅ Solution: One orchestrator, specialized agents:**
```yaml
# feature-workflow.prompt.md (SINGLE orchestrator)
agent: planner

Phase 1: @planner - Create plan
  ↓
Phase 2: @developer - Implement
  ↓
Phase 3: @tester - Test
  ↓
Phase 4: @reviewer - Review
```

**Rule:** One orchestrator (prompt file) → Multiple execution agents (agent files)

## Mistake 6: Hardcoded Agent Names

**Problem**: Orchestrator references specific agent names that might not exist in all projects.

**❌ Bad example:**
```yaml
Hand off to @react-specialist for component implementation.
```

**Problem:** Project might use Vue, or might not have `@react-specialist` agent defined.

**✅ Solution: Document required agents, provide defaults:**
```yaml
---
name: component-workflow
description: "Multi-phase component implementation"
---

# Component Implementation Workflow

**Required agents:**
- `@designer` or `@planner` - Creates component specification
- `@developer` - Implements component (any framework)
- `@test-specialist` - Generates tests

**If custom agents don't exist:** Falls back to `@agent` mode.

## Phase 1: Design (@designer)

Create component specification...

**Handoff:** @developer (or default @agent if @developer doesn't exist)
```

## Mistake 7: No User Checkpoint Before Destructive Operations

**Problem**: Orchestrator auto-progresses through destructive or irreversible steps.

**❌ Bad example:**
```yaml
Phase 3: @deployment-agent
  send: true  # Automatically deploys without user review
```

**✅ Solution: Explicit checkpoints before high-risk operations:**
```yaml
## Phase 3: Deployment Preparation (@deployment-agent)

Prepare deployment artifacts and configuration.

**USER CHECKPOINT:**

⚠️ **Review the deployment plan above before proceeding.**

Verify:
- [ ] Target environment is correct
- [ ] Database migrations are safe
- [ ] Rollback plan is clear

**When ready to deploy:** Click "Deploy to Production" handoff below.

handoffs:
  - label: "Deploy to Production"
    agent: deployment-agent
    prompt: "Execute deployment with user approval"
    send: false  # User must click to proceed
```

## Mistake 8: Poor Handoff Prompt Quality

**Problem**: Handoff prompts are too generic, providing insufficient context for next agent.

**❌ Bad examples:**
```yaml
prompt: "Continue"            # What should agent continue?
prompt: "Do your thing"       # What thing?
prompt: "Next phase"          # What is the next phase?
```

**✅ Solution: Specific, actionable handoff prompts:**
```yaml
handoffs:
  - label: "Generate Tests"
    prompt: |
      Create comprehensive test suite for the ${componentName} component implemented above.
      
      **Test coverage requirements:**
      - Unit tests for all public methods
      - Integration tests for component interactions
      - Edge cases: null inputs, empty arrays, error conditions
      
      **Testing framework:** Jest with React Testing Library
      
      **Success criteria:** 80%+ code coverage, all edge cases handled
```

## Mistake 9: Ignoring Agent Execution Context

**Problem**: Not considering where agents run (local vs. background vs. cloud).

**❌ Bad example (assumes all agents run locally):**
```yaml
Phase 1: @planner (local)
Phase 2: @developer (background)  # Has isolated work tree
Phase 3: @reviewer (local)         # Can't see background changes!
```

**Problem:** Background agents work in isolated work trees; local agents can't see their changes until merged.

**✅ Solution: Match workflow to execution context:**
```yaml
# Option 1: All local (synchronous, visible)
Phase 1: @planner (local)
Phase 2: @developer (local)
Phase 3: @reviewer (local)

# Option 2: Background with merge points
Phase 1: @planner (local)
Phase 2: @developer (background - creates PR)
  → USER reviews PR
Phase 3: @reviewer (local - after PR merged)

# Option 3: All cloud (GitHub PR workflow)
Phase 1: @pr-analyzer (cloud)
Phase 2: @security-scanner (cloud)
Phase 3: @approval-agent (cloud)
```

## Key Takeaways

✅ **DO:**
- Let orchestrator prompt control workflow; agents execute tasks
- Include explicit context in handoff prompts
- Consolidate related phases (aim for 3-5, not 9+)
- Provide fallback paths for failures
- Use single orchestrator layer, not nested orchestrators
- Document required agents with fallback options
- Add user checkpoints before destructive operations
- Write specific, actionable handoff prompts
- Match workflow design to agent execution contexts

❌ **DON'T:**
- Split control between prompt and agent
- Lose context between handoffs
- Create excessively long sequential chains
- Omit failure recovery strategies
- Nest orchestrators multiple levels deep
- Hardcode agent names without fallbacks
- Auto-progress through high-risk operations
- Use vague handoff prompts like "continue"
- Ignore execution context differences

By avoiding these orchestration mistakes, you'll build robust multi-agent workflows that handle complexity gracefully, recover from failures, and provide clear user control points.

---

## 📚 References

### Official Documentation

**[VS Code - Customize Chat to Your Workflow](https://code.visualstudio.com/docs/copilot/copilot-customization)** `[📘 Official]`  
Comprehensive VS Code documentation covering custom agents, prompt files, custom instructions, language models, and MCP integration. Authoritative source for VS Code-specific Copilot customization features.

**[VS Code - Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)** `[📘 Official]`  
Detailed guide to creating custom agents in VS Code, including agent file structure, YAML frontmatter fields, handoff configuration, and sharing agents across teams. Covers background agents, cloud agents, and subagent integration.

**[VS Code v1.107 Release Notes](https://code.visualstudio.com/updates/v1_107)** `[📘 Official]`  
December 2024 release introducing Agent HQ unified interface, background agents with work tree isolation, "Continue in" delegation workflow, planning mode, MCP 1.0 features, and Claude skills integration. Essential for understanding the v1.107+ orchestration capabilities discussed in this article.

**[VS Code - Chat Sessions (Agent HQ)](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)** `[📘 Official]`  
Official documentation for Agent HQ interface covering session management across local, background, and cloud execution contexts. Explains "Continue in" workflow, work tree isolation, session filtering, and archive capabilities for multi-agent orchestrations.

**[VS Code - Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)** `[📘 Official]`  
Official guide to creating reusable prompt files with YAML frontmatter, tool configuration, variables, and integration with custom agents. Essential for understanding the building blocks orchestrators coordinate.

**[VS Code - Use MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)** `[📘 Official]`  
Official guide to integrating Model Context Protocol (MCP) servers with VS Code Copilot. Covers MCP tool configuration, resource access, tool sets, and how agents can leverage MCP capabilities for database access, external APIs, and custom integrations.

**[Model Context Protocol Documentation](https://modelcontextprotocol.io/)** `[📘 Official]`  
Official MCP standard documentation explaining how to connect AI applications to external systems (databases, APIs, file systems). Critical for understanding agent extensibility beyond built-in VS Code tools.

**[Microsoft - Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering)** `[📘 Official]`  
Microsoft's comprehensive guide to prompt engineering covering components, few-shot learning, chain of thought, context grounding, and best practices. Foundational knowledge for designing effective prompts and orchestrators.

### Community Best Practices

**[GitHub Blog - How to Write Great Agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)** `[📗 Verified Community]`  
GitHub's analysis of 2,500+ agent files revealing best practices for agent personas, boundaries, and tool selection. Essential reading for understanding what makes agents succeed or fail in production.

**[GitHub Docs - GitHub Copilot Documentation](https://docs.github.com/copilot/)** `[📗 Verified Community]`  
Central hub for GitHub Copilot features including chat, CLI, code review, coding agent, and Spaces. Covers auto model selection, response customization, and concepts underlying Copilot's multi-agent architecture.

### Internal Reference Materials

**[06.1 Prompt Creation Multi-Agent Flow - Implementation Plan](./06.1%20example_prompt_interacting_with_agents_plan.md)** `[📒 Internal]`  
Complete case study documenting the real-world implementation of the multi-agent prompt creation system. Includes detailed YAML specifications for all orchestrators and agents, 2-week implementation roadmap, and battle-tested patterns that informed this article.

**[04. How to Structure Content for Copilot Agent Files](./04.%20how_to_structure_content_for_copilot_agent_files.md)** `[📒 Community]`  
Detailed guide to agent file structure, personas, handoffs, tool configuration, and composing agents with prompts. Companion article covering implementation details for the patterns described here.

**[03. How to Structure Content for Copilot Prompt Files](./03.%20how_to_structure_content_for_copilot_prompt_files.md)** `[📒 Community]`  
Comprehensive coverage of prompt file structure, YAML frontmatter, tool selection, and workflow design. Essential for understanding the building blocks that orchestrators coordinate.

**Context Engineering Principles** (`.copilot/context/00.00 prompt-engineering/01-context-engineering-principles.md`) `[📒 Internal]`  
Repository-specific guidelines for narrow scope, imperative language, three-tier boundaries, context minimization, and lazy loading patterns. Critical for building efficient multi-agent orchestrations.

**Tool Composition Guide** (`.copilot/context/00.00 prompt-engineering/02-tool-composition-guide.md`) `[📒 Internal]`  
Patterns and recipes for tool selection by role, performance optimization, and avoiding tool clash. Explains orchestrator tool patterns and agent tool specialization.

---

<!-- 
---
article_metadata:
  filename: "20-how_to_create_a_prompt_interacting_with_agents.md"
  created: "2025-12-10T00:00:00Z"
  last_updated: "2025-12-14T00:00:00Z"
  author: "prompt-builder"
  
validations:
  structure:
    status: null
    last_run: null
  grammar:
    status: null
    last_run: null
  consistency_review:
    status: "completed"
    last_run: "2025-12-14T00:00:00Z"
    model: "claude-sonnet-4.5"
    references_checked: 11
    references_valid: 11
    references_broken: 0
    references_path_issues: 0
    references_added: 5
    gaps_identified: 10
    gaps_addressed: 10
    changes_summary: "Major update integrating real implementation experience from case study (06.1). Added: Use Case Challenge Methodology section with 3/5/7 scenario generation; Tool Composition Validation with agent/tool alignment checks; Agent Dependencies Planning (Phases 5-6) with recursion limits; Pre-Save Validation checklist for builders; Validation Loop Limits (max 3 iterations); Updated phase flow diagrams with approval checkpoints; Real validator output format example; Real Implementation Case Study section with lessons learned. Updated orchestrator YAML with complete boundaries and fix handoff. Renamed case study file to 06.1 for companion reference."
---
-->
