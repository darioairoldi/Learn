# Model-Specific Optimization

**Purpose**: Quick-reference guide for optimizing prompts per model family. Each model is a different compiler — the same prompt produces different results depending on which model processes it.

**Referenced by**: All prompt files with `model:` field, orchestrator prompts with model-per-role patterns, agent files

---

## Core Rule

**Re-validate on every model change.** When you change model or version:

1. Read the official prompt guide for that specific model
2. Connect the model change to a test pipeline updated with the latest guide
3. Re-validate existing prompts against the new model's behavior

## Standard vs Reasoning Models

| Aspect | Standard Models | Reasoning Models |
|---|---|---|
| **Instruction style** | Detailed, step-by-step | High-level goals |
| **Chain of thought** | Must be prompted explicitly | Happens internally |
| **"Think step by step"** | Helpful | Unnecessary/harmful |
| **Few-shot examples** | Often required | Try zero-shot first |
| **Constraints** | Embedded in instructions | Specify success criteria |

> "A reasoning model is like a senior coworker — you give them goals. A standard model is like a junior coworker — they need explicit instructions."

## Per-Family Quick Reference

| Model Family | Key Optimization Strategy |
|---|---|
| **GPT (4o, 5)** | Explicit instructions, few-shot examples, `developer` messages |
| **Claude** | XML structure, clear context, CoT for complex tasks |
| **Gemini** | Consistent formatting, completion patterns, structured prompts |
| **Reasoning (o3, Extended Thinking)** | High-level goals, minimal guidance, trust internal reasoning |

### GPT Core Techniques

- Use `developer` messages for identity, instructions, examples, context
- Message role priority: `developer` > `user` > `assistant`
- Use Markdown/XML delimiters for structure
- Provide 2–5 few-shot examples for consistent output
- **Place static content first** for prompt caching (50% discount on cached prefix)
- Use `instructions` parameter (API) for system-level guidance that persists across turns
- **Structured outputs**: Use JSON mode with explicit schema for reliable parsing
- **Reasoning models (o3, o4-mini)**: Never say "think step by step" — provide goals + success criteria only

### Claude Core Techniques

- Use XML tags (`<instructions>`, `<context>`, `<examples>`) for structure
- **Golden rule**: Show your prompt to a colleague with minimal context — if they're confused, Claude will likely be too
- Use Extended Thinking mode with high-level instructions, not step-by-step
- Place critical instructions at the beginning of the prompt
- Anthropic caching gives **90% discount** on cached prefix
- **9-technique priority for Claude optimization** (in order): clear/direct → examples → XML tags → chain of thought → prefill → long context → extended thinking → agentic tools → citations
- **Extended Thinking**: Set `budget_tokens` parameter; model self-allocates reasoning depth
- XML tag nesting patterns for complex multi-part instructions

### Gemini Core Techniques

- Use XML or Markdown headers consistently (don't mix formats)
- Often performs well with **zero-shot** — try without examples first
- Use **completion strategy** (provide partial outputs for the model to complete)
- Use **context anchoring** with transition phrases after large content blocks
- **Prefix patterns**: Provide response opening for steering direction
- **Grounding with Google Search**: Enable for real-time factual verification

### Reasoning Model Rules

- Provide high-level goals, NOT step-by-step instructions
- NEVER use "think step by step" — it's redundant and can degrade performance
- Try zero-shot first before adding examples
- Specify success criteria instead of embedding constraints in instructions
- Cost warning: reasoning tokens are often **10–50× visible output tokens**

## Multi-Model Architecture

### Pattern: Planner + Executors

Use a reasoning model for planning, standard models for execution:

```
Planner (o3/Extended Thinking)  →  Executor 1 (GPT-4o)
                                →  Executor 2 (Claude Sonnet 4)
                                →  Executor 3 (GPT-4o mini)
```

### Model-Per-Role Guidance

MUST define by task characteristics, NOT by specific model names (those are volatile):

| Task Type | Model Characteristic |
|---|---|
| Orchestration/coordination | Fast, low-cost, good at following instructions |
| Complex reasoning/planning | Reasoning model with internal chain of thought |
| Long document analysis | Large context window model |
| Code generation | Code-optimized model |
| Evaluation/grading | Reasoning model for consistent judgment |
| Agentic multi-step | Strong tool-use, large context model |

---

## Anti-Patterns

### ❌ One Prompt for All Models
**Problem**: Using the same prompt text across GPT, Claude, and Gemini without adjustment
**Fix**: Adapt formatting, examples, and instruction style per model family

### ❌ Hardcoded Model Names in Guidance
**Problem**: Recommending "use GPT-4o for orchestration" — outdated within months
**Fix**: Describe task characteristics and let users select current best-fit model

---

## References

- **Internal**: [09-token-optimization-strategies.md](./09-token-optimization-strategies.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/08.00-how_to_optimize_prompts_for_specific_models.md`
- **External**: [OpenAI Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering), [Anthropic Prompt Engineering](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview), [Google AI Prompting](https://ai.google.dev/docs/prompt_best_practices)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — compiler analogy, per-family techniques, multi-model arch | System |
| 1.1.0 | 2026-02-23 | Expanded GPT (structured outputs, instructions parameter), Claude (9-technique priority, extended thinking), Gemini (prefix patterns, grounding) | System |
