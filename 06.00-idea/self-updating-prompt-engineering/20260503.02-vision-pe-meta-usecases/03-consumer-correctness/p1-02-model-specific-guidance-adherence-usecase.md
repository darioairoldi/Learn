# UC-21: Model-specific guidance adherence

> **Group:** C - Consumer implementation correctness  
> **Priority:** P1  
> **Order in group:** 3 (run after UC-11)

## Invocation

**Command family:** Guidance-first / Review  
**Primary entry point:** `/pe-meta-adherence 03.02-model-specific-optimization.md`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim model` (consumer-side model adherence check)
- `/pe-meta-prompt-review <path> --dim model-adherence` (prompt model check)
- `/pe-meta-review --mode plan --skip research --dim model --scope agents,prompts` (system-wide model adherence)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim model` | Focus on `D27-model-adherence` |
| `--dim model-adherence` | Explicit `D27-model-adherence` targeting |
| `--scope agents` | Check agent model pattern compliance |
| `--scope prompts` | Check prompt model pattern compliance |
| `--deps direct` | Include model-specific context in assessment |
| `--skip research,structure,consistency` | Focus on model pattern adherence only |

> **Guidance-first semantics:** When invoked via `/pe-meta-adherence` with the model-specific optimization context file, enumerates all consumers that declare a target model and checks pattern compliance.

## Behavior

Verifies that an artifact's prompting patterns follow the best practices of the model it targets. An artifact declaring `model: claude-opus-4.6` should use Anthropic's recommended patterns; one targeting GPT should use OpenAI's. Using the wrong model's patterns degrades quality, efficiency, and reliability.

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim model-adherence
/pe-meta-prompt-review pe-meta-review.prompt.md --dim model
/pe-meta-prompt-review pe-gra-agent-design.prompt.md --dim quality
```

**Dimensions covered:** `D27-model-adherence`

**Source guidance:**
- `.copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md`
- `03.00-tech/05.02-prompt-engineering/04-howto/08.01-appendix-openai-prompting-guide.md`
- `03.00-tech/05.02-prompt-engineering/04-howto/08.02-appendix-anthropic-prompting-guide.md`
- `03.00-tech/05.02-prompt-engineering/04-howto/08.03-appendix-google-prompting-guide.md`

**Checks performed:**
1. **Identify model family** — read `model:` from YAML → Anthropic / OpenAI / Google / unspecified
2. **Load model guidance** — read the model-specific patterns from context files
3. **Pattern adherence** — check artifact structure against the model's recommended patterns:

   **Anthropic Claude patterns:**
   - ✅ Clear role definition in opening paragraph
   - ✅ MUST/NEVER imperative boundary language (Claude responds strongly to prohibitions)
   - ✅ Structured output via markdown tables/code blocks
   - ✅ Explicit reasoning chains for complex assessment steps
   - ✅ Progressive disclosure (important rules early — early commands principle)
   - ❌ Anti-pattern: "Do not..." phrasing (weaker than "NEVER..." for Claude)
   - ❌ Anti-pattern: implicit reasoning expectations without step-by-step structure

   **OpenAI GPT patterns:**
   - ✅ System/user prompt separation
   - ✅ JSON mode for structured output
   - ✅ Few-shot examples for complex tasks
   - ✅ Explicit output format specification
   - ❌ Anti-pattern: overly long system prompts without structural anchoring

4. **Anti-pattern detection** — flag patterns that work well on one model but poorly on the target
5. **Cross-model portability** — for artifacts without `model:`: assess whether patterns are model-agnostic

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM to compare artifact patterns against model-specific guidance (semantic) |
| **False positives** | MEDIUM — model-specific patterns have gray areas (some patterns work on all models) |
| **False negatives** | LOW — clear anti-patterns (e.g., "Do not..." on Claude) are reliably detected |
| **Consistency** | ⚠️ Pattern matching depends on how well the guidance file enumerates the patterns |

**Reliability score: MEDIUM** — depends on the quality of model-specific guidance files. Better guidance → more reliable detection. The existing articles (08.01, 08.02, 08.03) provide comprehensive pattern catalogs.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Most PE artifacts use generic prompting patterns — model-specific optimization improves output quality measurably |
| **Quality impact** | HIGH — model-aligned prompts produce more accurate, more structured output |
| **Efficiency impact** | MEDIUM — model-aligned prompts produce correct output in fewer tokens (less retry/reasoning) |
| **Reliability impact** | HIGH — model-aligned prompts produce more consistent results across invocations |
| **Unique value** | Only dimension that checks whether the artifact is OPTIMIZED for its target model, not just structurally correct |

**Effectiveness score: HIGH** — model-specific optimization is one of the highest-ROI improvements for prompt quality. The difference between "generic prompting" and "model-optimized prompting" is often 20-40% in output quality for complex tasks.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM — reads artifact + model-specific guidance file + reasoning for pattern comparison |
| **Model routing** | Reasoning model (must understand prompting patterns semantically, not just structurally) |
| **Time** | 20-30s per artifact |
| **Recommended frequency** | After creating artifacts; when changing `model:` field; as part of `--dim quality` or `--dim model` |
| **ROI** | HIGH — model-aligned artifacts produce better output on every invocation |

**Efficiency score: MEDIUM** — moderate cost to run, but findings have compounding quality AND efficiency benefits.

## Relationship to `D26-model-routing`

```
D26-model-routing:    "Is the RIGHT MODEL assigned to this step?"
                       → Ensures reasoning tasks get reasoning models, structural gets standard
                       → Primarily efficiency (wrong model = wasted tokens or degraded results)

D27-model-adherence:  "Does the artifact follow the assigned MODEL'S BEST PRACTICES?"
                       → Ensures Claude artifacts use Claude patterns, GPT artifacts use GPT patterns
                       → Primarily quality (wrong patterns = degraded output regardless of model choice)

Together:             "Is the right model doing the work (D26-model-routing), and is the work structured
                       for that model's strengths (D27-model-adherence)?"
```

`D26-model-routing` without `D27-model-adherence`: you have the right model but generic patterns → suboptimal
`D27-model-adherence` without `D26-model-routing`: you follow Claude patterns but route everything through standard model → wasted patterns
Both: right model + right patterns → maximum quality AND efficiency
