# Token Optimization Strategies

**Purpose**: Nine actionable strategies for reducing token consumption in prompt orchestrations, organized by category (Input, Processing, Output) with implementation priority and expected savings.

**Referenced by**: All orchestrator prompts, multi-agent workflows, `.github/instructions/prompts.instructions.md`

---

## The Token Multiplication Problem

Without optimization, multi-phase workflows multiply token consumption dramatically:

```
Single request:     1,000 input + 500 output = 1,500 tokens

5-phase workflow with full context transfer:
├── Phase 1:  1,000 + 500 = 1,500 tokens
├── Phase 2:  1,500 + 800 = 2,300 tokens (inherited context)
├── Phase 3:  2,300 + 600 = 2,900 tokens
├── Phase 4:  2,900 + 700 = 3,600 tokens
├── Phase 5:  3,600 + 400 = 4,000 tokens
└── TOTAL: 14,300 tokens (9.5× single request)
```

## Strategy Overview

### Input Optimization

| # | Strategy | Savings | Effort | Best For |
|---|---|---|---|---|
| 1 | **Context Reduction** | 30–90% | Low | All workflows |
| 2 | **Provider Prompt Caching** | 50–90% | Low | High-volume, consistent prompts |
| 3 | **Semantic Caching** | 50–80% | High | Repeated queries, documentation |

### Processing Optimization

| # | Strategy | Savings | Effort | Best For |
|---|---|---|---|---|
| 4 | **Model Selection** | 60–80% | Low | Simple tasks, high volume |
| 5 | **Batch Processing** | 50% cost | Low | Non-urgent, high volume |
| 6 | **Request Consolidation** | 40–60% | Medium | Multi-step pipelines |

### Output Optimization

| # | Strategy | Savings | Effort | Best For |
|---|---|---|---|---|
| 7 | **Output Token Reduction** | 30–50% | Low | Verbose outputs |
| 8 | **Deterministic Tools** | 70–100% | Medium | Cache checks, validation, file ops |
| 9 | **Streaming/Parallelization** | Latency only | Low–Medium | User-facing, independent tasks |

## Provider Caching Comparison

Structure your prompts with static content first and dynamic content last to maximize cache hits.

| Provider | Min Tokens | Cache Duration | Read Discount | Write Cost |
|---|---|---|---|---|
| **OpenAI** | 1,024 | 5–60 min (or 24h extended) | 50% | No extra |
| **Anthropic** | 1,024–4,096 (model-dependent) | 5 min–1h | 90% | 25% premium |
| **Google** | Varies | Context caching available | Reduced | Initial write cost |

**Prompt structure rule:** Place static instructions first, dynamic context last. This maximizes the cacheable prefix.

### Cache Invalidation & Break-Even

**Cache invalidated by:** tool definition changes, feature toggles (web search, citations, thinking), image additions/removals, any prefix content edit.

**Anthropic break-even:** write cost is 1.25×, read cost is 0.1×. Savings start at the **3rd reuse** (1.25 + 0.1 + 0.1 = 1.45 vs 3.0 without caching).

**Batch + Cache discounts stack:** Batch 50% + Cache read 90% = **95% combined savings**.

## Context Window Breakdown (Optimization Targets)

| Category | Typical % | Optimization Target |
|---|---|---|
| System context | 5–15% | Instruction pruning, narrow `applyTo` |
| User context | 5–20% | Prompt compression, snippet elimination |
| Tool results | 20–60% | **Targeted reads, result limits, deterministic tools** |
| Conversation history | 10–50% | **Progressive summarization, file-based isolation** |

**Focus on tool results and conversation history first** — they represent 70%+ of typical context.

## Deterministic Tools Decision

Use deterministic tools (not AI) for predictable operations:

| Operation | Use AI? | Use Tool? |
|---|---|---|
| Parse YAML frontmatter | No | Regex/parser |
| Check if file exists | No | File system check |
| Validate JSON schema | No | Schema validator |
| Count pattern matches | No | grep + wc |
| Compare timestamps | No | Date comparison |
| **Analyze code semantics** | **Yes** | No |
| **Generate creative content** | **Yes** | No |
| **Make judgment calls** | **Yes** | No |

## Strategy Selection Flowchart

```
Is the operation predictable/deterministic?
├── YES → DETERMINISTIC TOOL (zero tokens)
└── NO → Is it a repeated query pattern?
         ├── YES → Is the prefix stable?
         │         ├── YES → PROVIDER CACHING (50–90%)
         │         └── NO → SEMANTIC CACHING (50–80%)
         └── NO → Is it high volume, non-urgent?
                  ├── YES → BATCH PROCESSING (50% discount)
                  └── NO → Is output verbose?
                           ├── YES → OUTPUT REDUCTION (30–50%)
                           └── NO → CONTEXT REDUCTION (30–90%)
```

## Implementation Priority

Implement strategies in this order for maximum impact with minimum effort:

| Priority | Strategy | Expected Savings | Effort |
|---|---|---|---|
| 1 | Context reduction (targeted reads) | 30–50% | Low |
| 2 | Provider caching (prompt structure) | 50–90% | Low |
| 3 | Model selection (right-size tasks) | 60–80% | Low |
| 4 | Batch processing (async high-volume) | 50% cost | Low |
| 5 | Output reduction (structured output) | 30–50% | Low |
| 6 | Request consolidation (combine steps) | 40–60% | Medium |
| 7 | Deterministic tools (cache checks) | 70%+ for cached ops | Medium |
| 8 | Semantic caching | 50–80% | High |
| 9 | Streaming/parallelization | Latency only | Low–Medium |

## Combined Optimization Example

Stacking strategies yields cumulative savings of 75–90%:

```
Phase 1: Research    — MODEL SELECTION + CONTEXT REDUCTION + CACHING     → 70% savings
Phase 2: Cache Check — DETERMINISTIC TOOL                                → 70% skip AI
Phase 3: Analysis    — CONTEXT REDUCTION + CACHING + CONSOLIDATION       → 60% savings
Phase 4: Generation  — CONTEXT REDUCTION + SEMANTIC CACHING + OUTPUT RED → 50% savings
Phase 5: Validation  — DETERMINISTIC TOOL + BATCH PROCESSING             → 70% bypass AI
```

## Real-World Cost Impact

| Scenario | Unoptimized | Optimized | Savings |
|---|---|---|---|
| Simple 3-phase workflow | ~8,000 tokens | ~3,000 tokens | 62% |
| Complex 6-phase orchestration | ~45,000 tokens | ~12,000 tokens | 73% |
| Validation pipeline (10 articles) | ~200,000 tokens | ~40,000 tokens | 80% |
| Daily development workflow | ~500,000 tokens | ~100,000 tokens | 80% |

**Context rot warning:** At 32,000 tokens, accuracy drops from 88% to 30% — optimization preserves accuracy, not just cost.

## Token Sources Reference

| Source | Description | Cost Impact |
|---|---|---|
| **Input tokens** | Context window content | Paid per request |
| **Output tokens** | Model-generated response | 3–5× input cost |
| **Reasoning tokens** | Internal reasoning (o3, Extended Thinking) | 10–50× visible output |

---

## References

- **Internal**: [08-context-window-management.md](./08-context-window-management.md), [02-tool-composition-guide.md](./02-tool-composition-guide.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/13.00-how_to_optimize_token_consumption_during_prompt_orchestrations.md`
- **External**: [OpenAI Prompt Caching](https://platform.openai.com/docs/guides/prompt-caching), [Anthropic Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — 9 strategies, provider caching, deterministic tools, selection flowchart | System |
| 1.1.0 | 2026-02-22 | Added cache invalidation triggers, break-even rule, batch+cache stacking, context breakdown targets, real-world cost impact | System |
