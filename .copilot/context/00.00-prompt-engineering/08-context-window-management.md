# Context Window Management

**Purpose**: Defines context rot, failure modes, and information flow patterns for multi-agent workflows. Provides decision framework for choosing handoff strategies that balance token efficiency, robustness, and complexity.

**Referenced by**: All orchestrator prompts, agent files with handoffs, `.github/instructions/prompts.instructions.md`

---

## Context Rot

**Context rot** is the progressive degradation of model accuracy as the context window grows longer. Research by Liu et al. (2023) in "Lost in the Middle" demonstrated measurable impact:

- At **32,000 tokens**, accuracy drops from **88% to 30%** — even for capable models
- Earlier instructions progressively lose influence as conversation grows
- Every additional token actively degrades the model's ability to follow earlier instructions

**Mitigations:**
- Start new chat sessions frequently to reset the context window
- Clear context between workflow phases rather than carrying forward
- Transfer only essential information during handoffs
- Use right-sized models — smaller models hit thresholds faster

## Three Failure Modes

| Failure Mode | Symptom | Root Cause |
|---|---|---|
| **Context Loss** | Agent doesn't know about earlier decisions | Handoff didn't transfer critical context |
| **Context Bloat** | Responses become slow, expensive, or confused | Too much irrelevant context accumulated |
| **Context Conflict** | Agent receives contradictory instructions | Multiple sources provide conflicting guidance |

## Component Roles

Understanding what each customization component contributes to the context window:

| Component | Direction | Persistence | What It Provides |
|-----------|-----------|-------------|------------------|
| **Prompt File** | User → Model | Single execution | Task-specific instructions + variables |
| **Agent File** | System → Model | Session-wide | Persona + default tools + behavior |
| **Instruction File** | System → Model (auto) | Pattern-matched | Coding standards + context rules |
| **Prompt-Snippet** | User → Model | On-demand | Reusable context fragments |
| **Built-in Tools** | Model ↔ VS Code | Per-invocation | VS Code actions |
| **MCP Server Tools** | Model ↔ Server | Connection lifetime | Custom actions via MCP |

## Five Information Flow Patterns

| Strategy | Token Efficiency | Robustness | Complexity | Best For |
|---|---|---|---|---|
| **Full Context** (`send: true`) | Low | High | Low | Simple 2–3 phase workflows |
| **Progressive Summarization** | Medium | Medium-High | Medium | Multi-phase workflows (3–5) |
| **File-Based Isolation** | High | Medium | Medium | Specialized single-purpose agents |
| **User-Mediated Handoff** | Maximum | Variable | High (user effort) | Maximum control needed |
| **Structured Report Passing** | Medium-High | High | Medium | Complex orchestrations |

### Token Impact Comparison

```
Full Context (send: true):           ~20,500 tokens across all phases
Progressive Summarization:           ~9,800 tokens (52% reduction)
File-Based Isolation:                ~3,400 tokens (83% reduction)
```

### Strategy Selection

| Scenario | Recommended Strategy |
|---|---|
| Simple 2–3 phase workflow | Full context (`send: true`) |
| Multi-phase (3–5 phases) | Progressive summarization |
| Long workflow (5+ phases) | File-based isolation |
| Maximum control needed | User-mediated handoff |
| Complex data contracts | Structured report passing |
| Mixed requirements | Combine strategies per phase |

## Reliability Checksum Pattern

Before each handoff, validate critical data survives:

- [ ] **Goal Preservation**: Refined goal from previous phase still intact?
- [ ] **Scope Boundaries**: IN/OUT scope still clear?
- [ ] **Tool Requirements**: Tool list carried forward?
- [ ] **Critical Constraints**: Boundaries included in handoff?
- [ ] **Success Criteria**: Validation criteria defined?

If any checkbox fails, re-inject missing context before handoff.

## Phase Budget Guidelines

| Phase | Target Max | Action if Exceeded |
|---|---|---|
| Research | 3,000 tokens | Summarize to 1,000 tokens before handoff |
| Architecture | 2,000 tokens | Split into multiple specs if larger |
| Build | 4,000 tokens | Use file-based output, reference by path |
| Validation | 1,500 tokens | Compress to issues-only report |

## Context Window Breakdown

Typical distribution showing where optimization effort SHOULD focus:

| Category | Typical % | Optimization Target |
|---|---|---|
| System context | 5–15% | Instruction file pruning, agent streamlining |
| User context | 5–20% | Prompt compression, snippet elimination |
| Tool results | 20–60% | **Primary target**: targeted reads, result limits |
| Conversation history | 10–50% | Progressive summarization, file-based isolation |

## MCP Communication Flow

MCP tools add a distinct data pathway to the context window:

```
VS Code (MCP Host) → MCP Client → MCP Server
                                    ├── Tools (actions)
                                    ├── Resources (read-only data)
                                    └── Prompts (reusable templates)
```

Tool results from MCP servers flow back into the **Tool results** portion of the context window and follow the same token accumulation patterns as built-in tools. Agent-level MCP config uses `mcp-servers:` YAML syntax for the `github-copilot` target.

## Prompt-Snippets vs Instructions

Two mechanisms provide reusable context — choose based on inclusion method:

| Aspect | Prompt-Snippets | Instructions |
|---|---|---|
| Location | `.github/prompt-snippets/` | `.github/instructions/` |
| Inclusion | **Manual** via `#file:` | **Automatic** via `applyTo` |
| Scope | Per-invocation (user decides) | Pattern-matched (always injected) |
| Organization | `team-standards.md`, `api-conventions.md` | `*.instructions.md` with globs |
| Best for | Optional context, varying needs | Mandatory standards, always-on rules |

**Token impact**: Snippets add tokens only when explicitly referenced. Instructions always add tokens when their `applyTo` pattern matches.

## Architectural Boundary: VS Code Tasks

VS Code tasks (defined in `.vscode/tasks.json`) are **not directly accessible** to agents or prompts. Tasks are UI-driven commands, not part of the context pipeline. Agents can invoke `run_in_terminal` to achieve similar outcomes, but task definitions themselves are opaque to the prompt assembly system.

---

## References

- **Internal**: [04-handoffs-pattern.md](./04-handoffs-pattern.md), [09-token-optimization-strategies.md](./09-token-optimization-strategies.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/04-howto/12.00-how_to_manage_information_flow_during_prompt_orchestrations.md`
- **External**: Liu et al. (2023), "Lost in the Middle: How Language Models Use Long Contexts"

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — context rot, failure modes, 5 flow patterns, phase budgets | System |
| 1.1.0 | 2026-02-23 | Added MCP communication flow, prompt-snippets vs instructions, VS Code tasks boundary | System |
