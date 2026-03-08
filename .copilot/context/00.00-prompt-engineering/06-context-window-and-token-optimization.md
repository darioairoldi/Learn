# Context Window Management and Token Optimization

**Purpose**: Defines context rot, failure modes, information flow patterns, and nine actionable optimization strategies for reducing token consumption in multi-agent workflows.

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

What each customization component contributes to the context window:

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

Before each handoff, validate critical data survives. **📖 Full checklist:** [05-handoffs-pattern.md](05-handoffs-pattern.md) → "Reliability Checksum" section.

## Phase Budget Guidelines

| Phase | Target Max | Action if Exceeded |
|---|---|---|
| Research | 3,000 tokens | Summarize to 1,000 tokens before handoff |
| Architecture | 2,000 tokens | Split into multiple specs if larger |
| Build | 4,000 tokens | Use file-based output, reference by path |
| Validation | 1,500 tokens | Compress to issues-only report |

## Context Window Breakdown (Optimization Targets)

Typical distribution showing where optimization effort SHOULD focus:

| Category | Typical % | Optimization Target |
|---|---|---|
| System context | 5–15% | Instruction file pruning, narrow `applyTo`, agent streamlining |
| User context | 5–20% | Prompt compression, snippet elimination |
| Tool results | 20–60% | **Primary target**: targeted reads, result limits, deterministic tools |
| Conversation history | 10–50% | Progressive summarization, file-based isolation |

**Focus on tool results and conversation history first** — they represent 70%+ of typical context.

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

| Aspect | Prompt-Snippets | Instructions |
|---|---|---|
| Location | `.github/prompt-snippets/` | `.github/instructions/` |
| Inclusion | **Manual** via `#file:` | **Automatic** via `applyTo` |
| Scope | Per-invocation (user decides) | Pattern-matched (always injected) |
| Best for | Optional context, varying needs | Mandatory standards, always-on rules |

**Token impact**: Snippets add tokens only when explicitly referenced. Instructions always add tokens when their `applyTo` pattern matches.

## Architectural Boundary: VS Code Tasks

VS Code tasks (`.vscode/tasks.json`) are **not directly accessible** to agents or prompts. Tasks are UI-driven commands. Agents can invoke `run_in_terminal` to achieve similar outcomes, but task definitions are opaque to the prompt assembly system.

---

## Nine Token Optimization Strategies

### The Token Multiplication Problem

Without optimization, multi-phase workflows multiply token consumption dramatically:

```
Single request:     1,000 + 500 = 1,500 tokens
5-phase workflow:   14,300 tokens total (9.5× single request)
```

### Strategy Overview

| # | Strategy | Category | Savings | Effort | Best For |
|---|---|---|---|---|---|
| 1 | **Context Reduction** | Input | 30–90% | Low | All workflows |
| 2 | **Provider Prompt Caching** | Input | 50–90% | Low | High-volume, consistent prompts |
| 3 | **Semantic Caching** | Input | 50–80% | High | Repeated queries |
| 4 | **Model Selection** | Processing | 60–80% | Low | Simple tasks, high volume |
| 5 | **Batch Processing** | Processing | 50% cost | Low | Non-urgent, high volume |
| 6 | **Request Consolidation** | Processing | 40–60% | Medium | Multi-step pipelines |
| 7 | **Output Token Reduction** | Output | 30–50% | Low | Verbose outputs |
| 8 | **Deterministic Tools** | Output | 70–100% | Medium | Cache checks, validation, file ops |
| 9 | **Streaming/Parallelization** | Output | Latency only | Low–Medium | User-facing, independent tasks |

### Provider Caching Comparison

**Rule:** Place static instructions first, dynamic context last to maximize cache hits.

| Provider | Min Tokens | Cache Duration | Read Discount | Write Cost |
|---|---|---|---|---|
| **OpenAI** | 1,024 | 5–60 min (or 24h extended) | 50% | No extra |
| **Anthropic** | 1,024–4,096 | 5 min–1h | 90% | 25% premium |
| **Google** | Varies | Context caching available | Reduced | Initial write cost |

**Cache invalidation:** tool definition changes, feature toggles, image changes, any prefix content edit.
**Anthropic break-even:** savings start at the **3rd reuse** (1.25 + 0.1 + 0.1 = 1.45 vs 3.0 without caching).
**Batch + Cache discounts stack:** 50% + 90% = **95% combined savings**.

### Deterministic Tools Decision

Use deterministic tools (not AI) for predictable operations:

| Operation | Use AI? | Use Tool? |
|---|---|---|
| Parse YAML frontmatter | No | Regex/parser |
| Check if file exists | No | File system check |
| Count pattern matches | No | grep + wc |
| Compare timestamps | No | Date comparison |
| **Analyze code semantics** | **Yes** | No |
| **Generate creative content** | **Yes** | No |
| **Make judgment calls** | **Yes** | No |

### Strategy Selection Flowchart

```
Is the operation predictable/deterministic?
├── YES → DETERMINISTIC TOOL (zero tokens)
└── NO → Is it a repeated query pattern?
         ├── YES → PROVIDER CACHING (50–90%)
         └── NO → Is it high volume, non-urgent?
                  ├── YES → BATCH PROCESSING (50%)
                  └── NO → CONTEXT REDUCTION (30–90%)
```

### Implementation Priority

| Priority | Strategy | Expected Savings | Effort |
|---|---|---|---|
| 1 | Context reduction (targeted reads) | 30–50% | Low |
| 2 | Provider caching (prompt structure) | 50–90% | Low |
| 3 | Model selection (right-size tasks) | 60–80% | Low |
| 4 | Deterministic tools (cache checks) | 70%+ for cached ops | Medium |
| 5 | Output reduction (structured output) | 30–50% | Low |

### Real-World Cost Impact

| Scenario | Unoptimized | Optimized | Savings |
|---|---|---|---|
| Simple 3-phase workflow | ~8,000 tokens | ~3,000 tokens | 62% |
| Complex 6-phase orchestration | ~45,000 tokens | ~12,000 tokens | 73% |
| Validation pipeline (10 articles) | ~200,000 tokens | ~40,000 tokens | 80% |

**Context rot warning:** At 32,000 tokens, accuracy drops from 88% to 30% — optimization preserves accuracy, not just cost.

---

## References

- **Internal**: [05-handoffs-pattern.md](./05-handoffs-pattern.md), [04-tool-composition-guide.md](./04-tool-composition-guide.md)
- **Sources**: `03.00-tech/05.02-prompt-engineering/04-howto/12.00-how_to_manage_information_flow_during_prompt_orchestrations.md`, `03.00-tech/05.02-prompt-engineering/04-howto/13.00-how_to_optimize_token_consumption_during_prompt_orchestrations.md`
- **External**: Liu et al. (2023) "Lost in the Middle", [OpenAI Prompt Caching](https://platform.openai.com/docs/guides/prompt-caching), [Anthropic Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — context rot, failure modes, 5 flow patterns, phase budgets (from 08) | System |
| 1.1.0 | 2026-02-22 | Initial 9 strategies, provider caching, deterministic tools (from 09) | System |
| 1.2.0 | 2026-02-23 | Added MCP flow, prompt-snippets vs instructions, VS Code tasks boundary | System |
| 1.3.0 | 2026-03-08 | Deduplication: replaced reliability checksum with ref to 04 | System |
| 2.0.0 | 2026-03-08 | Phase 5: Merged 06-context-window-and-token-optimization + 06-context-window-and-token-optimization into single file. Removed duplicated context window breakdown table. Consolidated references. | System |
