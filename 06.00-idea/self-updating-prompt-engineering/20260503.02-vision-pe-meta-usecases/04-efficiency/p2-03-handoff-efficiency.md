# UC-18: Handoff and summarization efficiency

> **Group:** D - Efficiency and operating economics  
> **Priority:** P2  
> **Order in group:** 5 (run after UC-17)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope prompts,agents`  
**Alternative entry points:**
- `/pe-meta-prompt-review <path> --dim handoff-efficiency` (single prompt handoff check)
- `/pe-meta-agent-review <path> --dim optimize` (agent handoff review)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim handoff-efficiency` | Focus on D24 specifically |
| `--dim optimize` | Broader efficiency group including D24 |
| `--scope prompts` | Multi-phase prompts with handoffs |
| `--scope agents` | Agents with handoff data contracts |
| `--deps none` | Handoff efficiency assessed per-artifact |
| `--skip research,structure,consistency` | Focus on handoff patterns only |

## Behavior

Checks whether multi-phase prompts and agent handoffs use summarization protocols to compress context between phases — preventing context window exhaustion during complex workflows.

**Invocation examples:**
```
/pe-meta-prompt-review pe-gra-agent-design.prompt.md --dim handoff-efficiency
/pe-meta-prompt-review pe-meta-review.prompt.md --dim efficiency
```

**Dimensions covered:** D24 (handoff-efficiency)

**Checks performed:**
1. **Max token enforcement** — Does every `handoffs:` entry's data contract specify a max token budget?
2. **Summarization protocol** — Does the prompt define checkpoints where accumulated context is compressed? Does it specify what to keep vs. discard at each checkpoint?
3. **Structured handoffs** — Do handoff payloads use structured formats (templates, tables, YAML) or raw prose?
4. **Information funnel** — Does the token budget decrease along the chain? (researcher 2000 → builder 1500 → validator 1000) A flat or increasing budget suggests insufficient compression
5. **Context accumulation estimate** — Estimate the total context size at each phase boundary. Flag prompts where accumulated context exceeds 8,000 tokens before any summarization occurs

**Real-world context from this session:** pe-gra-agent-design defines an 8-phase workflow. Without summarization, by Phase 7 the context accumulates requirements, research results, specification, build output, dependency analysis, and validation results — easily exceeding 12,000 tokens. The prompt's summarization protocol (when present) compresses this to ~2,500 tokens of essential state.

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Handoff contract presence is deterministic; context accumulation estimation requires judgment |
| **False positives** | LOW — missing summarization protocol in a 6+ phase prompt is a genuine concern |
| **False negatives** | LOW — the checks are concrete (does the section exist? does it specify max tokens?) |
| **Consistency** | ✅ Mostly deterministic checks on prompt structure |

**Reliability score: MEDIUM-HIGH** — structural checks dominate.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Context rot (R-P2) is a documented accuracy degradation factor — 88% → 30% at 32K tokens |
| **Directly prevents** | Context window exhaustion in multi-phase prompts; degraded reasoning quality from context rot |
| **Unique value** | Only dimension that checks whether the HANDOFF PROTOCOL supports efficient context management |

**Effectiveness score: HIGH** — context rot is the vision's primary decomposition concern. Handoff efficiency is the mechanism that controls it.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW — reads the prompt once, checks for summarization sections and handoff contracts |
| **Model routing** | Standard model; mostly structural pattern matching |
| **Time** | 10-15s per prompt |
| **Recommended frequency** | After creating multi-phase prompts; as part of `--dim efficiency` |

**Efficiency score: HIGH** — cheap to run, directly prevents expensive context rot problems.
