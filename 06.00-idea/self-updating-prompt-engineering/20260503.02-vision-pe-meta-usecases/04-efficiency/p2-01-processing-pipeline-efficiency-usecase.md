# UC-19: Processing pipeline efficiency

> **Group:** D - Efficiency and operating economics  
> **Priority:** P2  
> **Order in group:** 3 (run after UC-20)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope prompts`  
**Alternative entry points:**
- `/pe-meta-prompt-review <path> --dim optimize` (single prompt efficiency review)
- `/pe-meta-update --mode plan --skip research --dim efficiency --scope prompts` (prompt pipeline health)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim optimize` | Efficiency group including `D25-processing-efficiency` |
| `--dim processing-efficiency` | Focus on `D25-processing-efficiency` specifically |
| `--scope prompts` | Primary target — prompts define processing pipelines |
| `--deps none` | Pipeline efficiency assessed per-artifact |
| `--skip research,structure,consistency` | Focus on pipeline efficiency only |

## Behavior

Assesses whether a prompt's processing pipeline supports efficient operation: targeted scope (not re-scanning everything), summarization between phases, model routing per step, change-scoped processing, and early exit conditions.

**Invocation examples:**
```
/pe-meta-prompt-review pe-meta-review.prompt.md --dim processing-efficiency
/pe-meta-prompt-review pe-gra-agent-design.prompt.md --dim efficiency
```

**Dimensions covered:** `D25-processing-efficiency`

**Checks performed:**
1. **Targeted scope** — Does the prompt support `--dim` or equivalent scope parameters? Can it run a subset of its checks without the full pipeline?
2. **Summarization protocol** — Does the prompt define a summarization checkpoint table with "summarize to" specs and "discard" lists per phase?
3. **Model routing** — Does the prompt specify different model classes for different steps? (deterministic steps → small model; reasoning steps → reasoning model)
4. **Change-scoped processing** — Does the prompt support Phase 0.5 (change impact analysis) that skips irrelevant checks based on what changed? Or does it always run the full checklist?
5. **Early exit conditions** — Does the prompt define conditions for stopping early? (e.g., "If CRITICAL metadata failure, skip remaining dimensions and report immediately")

**What this dimension captures that others don't:**
- `D21-deterministic-first` optimizes WITHIN a step (split deterministic from reasoning)
- `D24-handoff-efficiency` optimizes BETWEEN steps (compress handoff data)
- `D25-processing-efficiency` optimizes the PIPELINE itself (skip unnecessary steps, route to right model, exit early)

Together, `D21-deterministic-first`+`D24-handoff-efficiency`+`D25-processing-efficiency` cover all three levels of processing efficiency.

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Checking for the PRESENCE of sections (summarization table, model routing, early exit) is deterministic. Assessing their QUALITY requires judgment |
| **False positives** | LOW — a prompt with no summarization protocol in an 8-phase workflow genuinely needs one |
| **False negatives** | LOW — the checks are concrete (does this section exist? does it specify these fields?) |
| **Consistency** | ✅ Mostly deterministic checks on prompt structure |

**Reliability score: MEDIUM-HIGH** — structural checks dominate. Quality assessment of the summarization protocol adds mild variability.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ In this session: pe-meta-review had no `--dim` support → every invocation ran all 6 criteria even for single-dimension checks |
| **Real-world impact** | Each unnecessary dimension costs 500-2000 tokens. Across 24 agents × multiple reviews, the waste compounds significantly |
| **Unique value** | Only dimension that assesses the prompt's OWN operational efficiency — all other dimensions assess the artifact it produces, not the prompt itself |

**Effectiveness score: HIGH** — processing efficiency directly affects the cost of every review invocation. Findings here have compounding returns.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW — reads the prompt once, checks for structural features |
| **Model routing** | Standard model; mostly structural pattern matching |
| **Time** | 10-15s per prompt |
| **Recommended frequency** | After creating prompts; after adding phases; as part of `--dim efficiency` |
| **ROI** | VERY HIGH — each finding, when implemented, saves tokens on every future invocation of the prompt |

**Efficiency score: HIGH** — cheap to run, high compounding returns.

## Relationship to other efficiency dimensions

```
D3-token-budget               → "Is the ARTIFACT lean?"
D7-non-redundancy             → "Is the CONTENT lean?"
D9-clarity                    → "Is the GUIDANCE efficient to interpret?"
D11-actionability             → "Does the GUIDANCE produce behavioral change?"
D20-token-chain               → "Is the LOADING efficient?"
D21-deterministic-first       → "Is each STEP efficient?"
D23-reference-efficiency      → "Are REFERENCES efficient?"
D24-handoff-efficiency        → "Are HANDOFFS efficient?"
D25-processing-efficiency     → "Is the PIPELINE efficient?"
```

The full `--dim efficiency` group covers all 9 layers. Any individual dimension can be run alone for targeted assessment.
