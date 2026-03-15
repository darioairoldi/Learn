---
title: "TuneIQ: automatic feedback loop for AI-assisted workflows"
author: "Dario Airoldi"
date: "2026-03-02"
categories: [idea, prompt-engineering, github-copilot, ai, automation]
description: "Design document for TuneIQ — an automatic feedback loop that analyzes AI execution sessions to continuously improve prompts, agents, skills, instructions, and hooks."
---

# TuneIQ: automatic feedback loop for AI-assisted workflows

## What is TuneIQ?

**TuneIQ** (Tune Intelligence Quality) is an automatic feedback loop system that captures, analyzes, and learns from AI execution sessions to continuously improve the customization stack — prompts, agents, skills, instruction files, context files, MCP servers, and hooks.

While the initial implementation targets **GitHub Copilot sessions in VS Code**, TuneIQ's architecture is intentionally general: the capture-analyze-aggregate pipeline can adapt to any AI execution context — Claude Code, Cursor, background agents, cloud agents, or custom MCP-based workflows.

Think of it as an **automated sprint retrospective** that runs after every AI session, asking: *"What worked? What didn't? What should we change?"* — but against the entire customization infrastructure rather than a team's process.

## The problem TuneIQ solves

### Current state

The Copilot customization stack (7 agents, 32+ prompts, 2 skills, 7 instruction files, 13+ context files, multiple MCP servers) is maintained through **manual observation and intuition**. When a prompt produces poor results or an agent misses context, the author notices *if they notice at all* and corrects the file manually. There's no systematic way to:

1. **Detect drift** — prompts that once worked but now underperform due to model updates or content changes
2. **Identify gaps** — sessions where the user needed context or guidance that no customization file provided
3. **Measure effectiveness** — whether a specific agent, prompt, or skill consistently achieves user goals
4. **Track patterns** — recurring failure modes across sessions (missing context, wrong tool selection, excessive iterations)
5. **Prioritize maintenance** — which files need attention most urgently

### After TuneIQ

| Before | After |
|--------|-------|
| No visibility into session outcomes | Structured per-session analysis reports |
| Manual detection of prompt failure | Automatic detection of goal misalignment |
| Guesswork about which files need updates | Data-driven improvement recommendations |
| No cross-session trend analysis | Aggregated patterns across sessions |
| Reactive fixes after visible failures | Proactive identification of degradation |

---

## Table of contents

- [Architecture overview](#architecture-overview)
- [Component 1: Stop hook — session capture](#component-1-stop-hook--session-capture)
- [Component 2: Session analysis agent](#component-2-session-analysis-agent)
- [Component 3: Analysis prompt](#component-3-analysis-prompt)
- [Component 4: Feedback reports](#component-4-feedback-reports)
- [Component 5: Trend aggregation prompt](#component-5-trend-aggregation-prompt)
- [Data model](#data-model)
- [Analysis dimensions](#analysis-dimensions)
- [Implementation plan](#implementation-plan)
- [Directory structure](#directory-structure)
- [Limitations and considerations](#limitations-and-considerations)
- [References](#references)

---

## Architecture overview

TuneIQ operates in two phases: **capture** (deterministic, automatic) and **analysis** (AI-driven, on-demand or automatic).

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         COPILOT CHAT SESSION                                │
│                                                                             │
│  User prompt #1 ──► Agent response #1 (tools, context, subagents)          │
│  User prompt #2 ──► Agent response #2 (tools, context, subagents)          │
│  ...                                                                        │
│  User prompt #N ──► Agent response #N                                      │
│                                                                             │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │ Session ends
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 1: CAPTURE (Stop Hook — deterministic)                                │
│                                                                              │
│  1. Read transcript from transcript_path                                     │
│  2. Extract session metadata (duration, turn count, tools used)              │
│  3. Identify customization files referenced (agents, prompts, instructions)  │
│  4. Save structured session log to .tuneiq/sessions/                         │
│  5. Exit (does NOT block — no premium request cost)                          │
└──────────────────────────────┬───────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 2: ANALYSIS (Agent or Prompt — AI-driven, on-demand)                  │
│                                                                              │
│  Option A: User invokes "Analyze last session" prompt                        │
│  Option B: User invokes the TuneIQ agent for deep analysis                   │
│  Option C: SessionStart hook offers analysis of previous session             │
│                                                                              │
│  1. Load session log(s) from .tuneiq/sessions/                               │
│  2. Analyze each turn for goal achievement                                   │
│  3. Map interactions to customization files involved                         │
│  4. Evaluate precision, efficiency, and gaps                                 │
│  5. Generate improvement recommendations                                     │
│  6. Save report to .tuneiq/reports/                                          │
└──────────────────────────────┬───────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  PHASE 3: AGGREGATE (Periodic — AI-driven, manual trigger)                   │
│                                                                              │
│  1. Load multiple recent reports                                             │
│  2. Identify recurring patterns across sessions                              │
│  3. Generate prioritized improvement backlog                                 │
│  4. Track improvement trends over time                                       │
│  5. Save to .tuneiq/trends/                                                  │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Why two phases?

The Stop hook executes **shell commands** — it can read files and write JSON, but it can't perform AI reasoning. The analysis requires LLM capabilities (understanding intent, evaluating quality, generating recommendations). Splitting capture from analysis means:

- **No premium request cost** for capture — the hook runs your script, not the model
- **Flexible analysis timing** — analyze immediately, batch later, or skip trivial sessions
- **Data persistence** — session logs survive even if analysis is deferred

---

## Component 1: Stop hook — session capture

### Hook configuration

**File:** `.github/hooks/tuneiq.json`

```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "pwsh -NoProfile -File ./scripts/tuneiq/capture-session.ps1",
        "windows": "pwsh -NoProfile -File .\\scripts\\tuneiq\\capture-session.ps1",
        "timeout": 15,
        "env": {
          "TUNEIQ_DIR": ".tuneiq"
        }
      }
    ]
  }
}
```

### Capture script behavior

**File:** `scripts/tuneiq/capture-session.ps1`

The script receives JSON on stdin with:

```json
{
  "timestamp": "2026-03-02T14:30:00.000Z",
  "cwd": "c:/dev/darioairoldi/Learn",
  "sessionId": "abc-123-def",
  "hookEventName": "Stop",
  "transcript_path": "/path/to/transcript.json",
  "stop_hook_active": false
}
```

**Script responsibilities:**

1. **Read** the transcript JSON from `transcript_path`
2. **Extract** session metadata:
   - Session ID, start/end timestamps, duration
   - Total user turns and assistant turns
   - Tools invoked (with counts)
   - Files read, edited, created
   - Subagents spawned
3. **Identify** customization stack elements referenced in the session:
   - Agent mode active (name, from `.github/agents/`)
   - Prompts invoked (from `.github/prompts/`)
   - Skills loaded (from `.github/skills/`)
   - Instruction files applied (from `.github/instructions/`)
   - Context files referenced (from `.copilot/context/`)
   - MCP server tools called (tool name prefixes)
   - Other hooks that fired during session
4. **Extract** a condensed conversation log:
   - Each user message (full text)
   - Each assistant response (summarized — first 500 chars + tool calls)
   - Tool call results (success/failure + key data)
5. **Write** structured JSON to `.tuneiq/sessions/{date}_{sessionId}.json`
6. **Output** JSON to stdout (does NOT block the session from ending):

```json
{
  "continue": true
}
```

### Session log schema

```json
{
  "schema_version": "1.0.0",
  "session_id": "abc-123-def",
  "captured_at": "2026-03-02T14:35:00.000Z",
  "duration_seconds": 1200,
  "metadata": {
    "workspace": "Learn",
    "branch": "main",
    "agent_mode": "gpt-5-beast-mode",
    "model": "claude-opus-4.6"
  },
  "stats": {
    "user_turns": 8,
    "assistant_turns": 8,
    "tool_calls": 24,
    "files_read": 12,
    "files_edited": 3,
    "files_created": 1,
    "subagents_spawned": 2,
    "errors_encountered": 1
  },
  "customization_stack": {
    "agent": ".github/agents/gpt-5-beast-mode.agent.md",
    "prompts_invoked": [],
    "skills_loaded": ["article-review"],
    "instructions_applied": [
      ".github/instructions/documentation.instructions.md",
      ".github/instructions/article-writing.instructions.md"
    ],
    "context_files_referenced": [
      ".copilot/context/01.00-article-writing/03-article-creation-rules.md"
    ],
    "mcp_tools_used": [
      "mcp_microsoft_doc_microsoft_docs_search",
      "mcp_gitkraken_git_status"
    ],
    "hooks_fired": ["SessionStart", "Stop"]
  },
  "conversation": [
    {
      "turn": 1,
      "role": "user",
      "content": "Create an article about Azure Functions best practices",
      "timestamp": "2026-03-02T14:10:00.000Z"
    },
    {
      "turn": 1,
      "role": "assistant",
      "content_preview": "I'll create that article following your documentation standards...",
      "tool_calls": [
        {
          "tool": "semantic_search",
          "input_summary": "Azure Functions best practices",
          "success": true
        },
        {
          "tool": "read_file",
          "input_summary": ".github/templates/article-template.md",
          "success": true
        }
      ],
      "timestamp": "2026-03-02T14:10:15.000Z"
    }
  ],
  "transcript_path_original": "/path/to/transcript.json"
}
```

---

## Component 2: Session analysis agent

### Agent definition

**File:** `.github/agents/tuneiq.agent.md`

```markdown
---
description: 'Analyze AI execution sessions to identify improvement opportunities
  for the customization stack — prompts, agents, skills, instructions, and hooks.'
name: 'TuneIQ'
tools: ['codebase', 'search', 'edit/editFiles', 'think', 'todos', 'problems']
---

# TuneIQ — session analysis agent

Analyze captured session data to generate actionable improvement
recommendations for the AI customization stack.

## Role

You are a session quality analyst. You review session transcripts and logs
to evaluate whether the customization stack (agents, prompts, skills,
instructions, context files, MCP servers, hooks) effectively supported
the user's goals.

## Workflow

1. Load session log(s) from `.tuneiq/sessions/`
2. For each conversation turn, evaluate goal achievement
3. Map each interaction to the customization files involved
4. Score precision and efficiency
5. Generate specific, actionable recommendations
6. Save report to `.tuneiq/reports/`

## Analysis template

Use: `.github/templates/tuneiq/analysis-report.template.md`
```

### Invocation patterns

| Trigger | Command |
|---------|---------|
| **Analyze last session** | `@tuneiq Analyze the most recent session` |
| **Analyze specific session** | `@tuneiq Analyze session {date}_{id}` |
| **Analyze recent batch** | `@tuneiq Analyze all sessions from this week` |
| **Generate trend report** | `@tuneiq Generate trend report for last 2 weeks` |

---

## Component 3: Analysis prompt

**File:** `.github/prompts/00.00-prompt-engineering/tuneiq-analyze.prompt.md`

For users who prefer a one-shot analysis without switching to the agent mode.

```markdown
---
name: tuneiq-analyze
description: "Analyze the most recent AI session for improvement opportunities"
agent: agent
model: claude-opus-4.6
tools: ['codebase', 'search', 'think']
argument-hint: 'Optionally specify session file path or date range'
---

# Analyze session for customization stack improvements

## Goal

Read the most recent session log from `.tuneiq/sessions/`,
analyze each turn for goal achievement, and generate an improvement
report following the template in
`.github/templates/tuneiq/analysis-report.template.md`.

## Steps

1. Find the most recent session log
2. Load the session log and understand the user's goals per turn
3. For each turn, evaluate the 6 analysis dimensions
4. Generate specific recommendations per customization file
5. Write report to `.tuneiq/reports/`
```

---

## Component 4: Feedback reports

### Report template

**File:** `.github/templates/tuneiq/analysis-report.template.md`

```markdown
# TuneIQ report: {session_date}

**Session ID:** {session_id}
**Duration:** {duration}
**Agent mode:** {agent_mode}
**Model:** {model}
**Analyzed:** {analysis_date}

---

## Session summary

| Metric | Value |
|--------|-------|
| User turns | {user_turns} |
| Tool calls | {tool_calls} |
| Files touched | {files_touched} |
| Errors | {errors} |
| Overall effectiveness | {score}/5 |

## Goal achievement per turn

### Turn {N}: "{user_message_preview}"

- **Intended goal:** {inferred_goal}
- **Achieved:** {yes/partial/no}
- **Customization files involved:** {list}
- **Observations:** {what_worked_or_didn't}

## Customization stack analysis

### Agents

| File | Used | Effectiveness | Recommendation |
|------|------|---------------|----------------|
| {agent_file} | {yes/no} | {score}/5 | {recommendation} |

### Prompts

| File | Invoked | Goal match | Recommendation |
|------|---------|------------|----------------|
| {prompt_file} | {yes/no} | {score}/5 | {recommendation} |

### Instructions

| File | Applied | Coverage | Gaps identified |
|------|---------|----------|-----------------|
| {instruction_file} | {yes/no} | {score}/5 | {gaps} |

### Skills

| Skill | Loaded | Usefulness | Recommendation |
|-------|--------|-----------|----------------|
| {skill_name} | {yes/no} | {score}/5 | {recommendation} |

### Context files

| File | Referenced | Relevant | Recommendation |
|------|-----------|----------|----------------|
| {context_file} | {yes/no} | {score}/5 | {recommendation} |

### MCP servers

| Tool | Called | Success rate | Recommendation |
|------|-------|-------------|----------------|
| {mcp_tool} | {count} | {rate}% | {recommendation} |

### Hooks

| Hook | Fired | Outcome | Recommendation |
|------|-------|---------|----------------|
| {hook_event} | {yes/no} | {outcome} | {recommendation} |

## Improvement recommendations

### High priority (blocking or frequent failures)

1. **{File}**: {specific_change} — *Reason:* {why}

### Medium priority (efficiency improvements)

1. **{File}**: {specific_change} — *Reason:* {why}

### Low priority (nice-to-have refinements)

1. **{File}**: {specific_change} — *Reason:* {why}

### Missing customization (gaps)

1. **{Proposed new file}**: {what_it_would_do} — *Evidence:* {session_turns}
```

### Report storage

Reports are saved to `.tuneiq/reports/{date}_{sessionId}_tuneiq.md`.

---

## Component 5: Trend aggregation prompt

**File:** `.github/prompts/00.00-prompt-engineering/tuneiq-trends.prompt.md`

Aggregates multiple reports to find patterns:

- Recurring failure modes (same file, same type of problem)
- Customization files that are never used (candidates for removal)
- Customization files that always underperform (candidates for rewrite)
- Missing coverage patterns (sessions where no customization file helped)
- Improvement velocity (are recommendations being addressed?)

**Output:** `.tuneiq/trends/{date}_trend-report.md`

---

## Data model

### Directory structure

```
.tuneiq/
├── sessions/                     # Raw session logs (JSON)
│   ├── 2026-03-02_abc123.json
│   ├── 2026-03-02_def456.json
│   └── ...
├── reports/                      # Individual session analysis (Markdown)
│   ├── 2026-03-02_abc123_tuneiq.md
│   └── ...
├── trends/                       # Aggregated trend reports (Markdown)
│   ├── 2026-03-15_trend-report.md
│   └── ...
└── config.json                   # TuneIQ configuration
```

### Configuration

**File:** `.tuneiq/config.json`

```json
{
  "schema_version": "1.0.0",
  "capture": {
    "enabled": true,
    "include_full_transcript": false,
    "content_preview_length": 500,
    "exclude_patterns": ["trivial sessions < 2 turns"]
  },
  "analysis": {
    "auto_analyze": false,
    "auto_analyze_min_turns": 3,
    "dimensions": [
      "goal_achievement",
      "context_adequacy",
      "tool_efficiency",
      "instruction_adherence",
      "gap_detection",
      "iteration_waste"
    ]
  },
  "retention": {
    "sessions_max_age_days": 30,
    "reports_max_age_days": 90,
    "trends_max_age_days": 365
  }
}
```

---

## Analysis dimensions

The analysis agent evaluates each session turn across six dimensions:

### 1. Goal achievement

*Did the assistant accomplish what the user asked?*

| Score | Meaning |
|-------|---------|
| 5 | Fully achieved, exceeded expectations |
| 4 | Achieved with minor deviations |
| 3 | Partially achieved, required clarification |
| 2 | Mostly missed, significant rework needed |
| 1 | Failed or produced incorrect results |

### 2. Context adequacy

*Did the customization stack provide enough context for the task?*

- Were the right instruction files applied?
- Were relevant context files available?
- Was any critical information missing that caused the model to guess or ask?

### 3. Tool efficiency

*Were tool calls necessary and productive?*

- Redundant searches (same query multiple times)
- Excessive file reads (could have read a larger range)
- Failed tool calls that a better prompt could have prevented
- Missing tool calls that would have improved results

### 4. Instruction adherence

*Did the model follow the applicable instructions?*

- Voice and formatting compliance
- Boundary violations (did things it shouldn't)
- Missed requirements (didn't do things it should)

### 5. Gap detection

*Were there moments where no customization file covered the need?*

- User had to manually provide context the stack should have supplied
- No agent/prompt existed for a recurring task pattern
- Missing skill for a domain-specific capability

### 6. Iteration waste

*How many turns were spent on rework or correction?*

- Corrections due to model misunderstanding
- Rework due to wrong initial approach
- Repeated attempts at the same task
- Turns spent providing context the stack should have injected

---

## Implementation plan

### Phase 0: Foundation (estimated effort: 1-2 hours)

| Step | Task | Output |
|------|------|--------|
| 0.1 | Create directory structure | `.tuneiq/`, `scripts/tuneiq/` |
| 0.2 | Create configuration file | `.tuneiq/config.json` |
| 0.3 | Add `.tuneiq/sessions/` and `.tuneiq/reports/` to `.gitignore` | Updated `.gitignore` |
| 0.4 | Create report template | `.github/templates/tuneiq/analysis-report.template.md` |

### Phase 1: Capture (estimated effort: 2-4 hours)

| Step | Task | Output |
|------|------|--------|
| 1.1 | Write capture PowerShell script | `scripts/tuneiq/capture-session.ps1` |
| 1.2 | Create Stop hook configuration | `.github/hooks/tuneiq.json` |
| 1.3 | Test with a sample session | Validated session log JSON |
| 1.4 | Handle edge cases (empty sessions, missing transcript, large transcripts) | Robust script |

### Phase 2: Analysis (estimated effort: 3-5 hours)

| Step | Task | Output |
|------|------|--------|
| 2.1 | Create TuneIQ agent file | `.github/agents/tuneiq.agent.md` |
| 2.2 | Create analysis prompt | `.github/prompts/00.00-prompt-engineering/tuneiq-analyze.prompt.md` |
| 2.3 | Create analysis template | `.github/templates/tuneiq/analysis-report.template.md` |
| 2.4 | Test analysis against captured sessions | Validated report output |

### Phase 3: Aggregation (estimated effort: 2-3 hours)

| Step | Task | Output |
|------|------|--------|
| 3.1 | Create trend analysis prompt | `.github/prompts/00.00-prompt-engineering/tuneiq-trends.prompt.md` |
| 3.2 | Create trend report template | `.github/templates/tuneiq/trend-report.template.md` |
| 3.3 | Test with multiple session reports | Validated trend report |

### Phase 4: Integration (estimated effort: 2-3 hours)

| Step | Task | Output |
|------|------|--------|
| 4.1 | Create context file documenting TuneIQ | `.copilot/context/00.00-prompt-engineering/15-tuneiq.md` |
| 4.2 | Update copilot-instructions.md with TuneIQ reference | Updated global instructions |
| 4.3 | (Optional) Create SessionStart hook to surface previous session insights | `.github/hooks/tuneiq.json` updated |
| 4.4 | (Optional) Create a cleanup script for old session data | `scripts/tuneiq/cleanup.ps1` |

### Phase 5: Iteration (ongoing)

| Step | Task | Output |
|------|------|--------|
| 5.1 | Run TuneIQ on real sessions for 2 weeks | Baseline data |
| 5.2 | Analyze trends and validate the system detects real issues | Confidence in accuracy |
| 5.3 | Refine analysis dimensions based on real-world patterns | Updated prompts/templates |
| 5.4 | Consider auto-analysis on SessionStart for sessions > N turns | Enhanced automation |

---

## Directory structure (complete)

```
.github/
├── hooks/
│   └── tuneiq.json                         # Stop hook configuration
├── agents/
│   └── tuneiq.agent.md                     # Analysis agent definition
├── prompts/
│   └── 00.00-prompt-engineering/
│       ├── tuneiq-analyze.prompt.md          # One-shot analysis prompt
│       └── tuneiq-trends.prompt.md           # Trend aggregation prompt
├── templates/
│   └── tuneiq/
│       ├── analysis-report.template.md       # Per-session report template
│       └── trend-report.template.md          # Trend report template
scripts/
├── tuneiq/
│   ├── capture-session.ps1                 # Stop hook capture script
│   └── cleanup.ps1                         # Data retention cleanup
.tuneiq/
├── config.json                              # TuneIQ configuration
├── sessions/                                # Raw session logs (.gitignored)
├── reports/                                 # Analysis reports (.gitignored)
└── trends/                                  # Trend reports (tracked in git)
.copilot/
└── context/
    └── 00.00-prompt-engineering/
        └── 15-tuneiq.md                     # Context file for other agents
06.00-idea/
└── tuneiq/
    └── 01-tuneiq-design.md                  # This design document
```

---

## Limitations and considerations

### Technical constraints

| Constraint | Impact | Mitigation |
|------------|--------|------------|
| Stop hook runs shell commands only | Cannot perform AI analysis in the hook | Two-phase architecture (capture + analyze) |
| `transcript_path` format is not fully documented | Script may need adaptation as VS Code evolves | Schema version field + defensive parsing |
| Hook timeout (default 30s) | Large transcripts may exceed timeout | Set explicit timeout, truncate if needed |
| Premium request cost | Analysis phase uses model turns | On-demand analysis, configurable minimum turns |
| Session data can be large | Disk space for raw logs | Retention policy with cleanup script |

### Privacy and security

- Session logs may contain sensitive content (API keys in tool outputs, file contents)
- `.tuneiq/sessions/` and `.tuneiq/reports/` should be `.gitignored`
- Consider optional content redaction in the capture script
- Trend reports (aggregated, no raw content) can be tracked in git

### When NOT to analyze

- Trivial sessions (< 2 turns) — not enough signal
- Sessions that are themselves TuneIQ analysis sessions — avoid recursion
- Sessions in unrelated workspaces if the hook is user-global

---

## References

**[How to use agent hooks for lifecycle automation](../../03.00-tech/05.02-prompt-engineering/04-howto/09.00-how_to_use_agent_hooks_for_lifecycle_automation.md)** 📘 [Internal]
Complete reference for hook configuration, lifecycle events, and I/O protocol.

**[Agent hooks reference](../../.copilot/context/00.00-prompt-engineering/11-agent-hooks-reference.md)** 📘 [Internal]
Quick reference for hook events and JSON schema.

**[The GitHub Copilot customization stack](../../03.00-tech/05.02-prompt-engineering/01-overview/01.00-the_github_copilot_customization_stack.md)** 📘 [Internal]
Overview of all customization layers that TuneIQ monitors.

**[Understanding skills, hooks, and lifecycle automation](../../03.00-tech/05.02-prompt-engineering/03-concepts/01.05-understanding_skills_hooks_and_lifecycle_automation.md)** 📘 [Internal]
Conceptual foundation for hooks and skills.

**[VS Code Copilot customization](https://code.visualstudio.com/docs/copilot/copilot-customization)** 📘 [Official]
Official documentation for Copilot customization including hooks.
