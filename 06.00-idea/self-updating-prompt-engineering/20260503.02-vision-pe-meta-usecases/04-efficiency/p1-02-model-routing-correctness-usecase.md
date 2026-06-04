# UC-20: Model routing correctness

> **Group:** D - Efficiency and operating economics  
> **Priority:** P1  
> **Order in group:** 2 (run after UC-06)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim model-routing` (single agent routing check)
- `/pe-meta-prompt-review <path> --dim model` (prompt model routing)
- `/pe-meta-update --mode plan --skip research --dim efficiency` (broader efficiency sweep)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim model-routing` | Focus on `D26-model-routing` (model routing correctness) |
| `--dim optimize` | Broader efficiency group including `D26-model-routing` |
| `--scope agents` | Primary target — agents have multi-step routing |
| `--scope prompts` | Check prompt model declarations |
| `--deps none` | Routing assessed per-artifact |
| `--skip research,structure,consistency` | Focus on routing analysis only |

## Behavior

Verifies that each process step in an agent or prompt uses the correct model class for its task type — reasoning for analysis, standard for execution, deterministic for checks. Incorrect routing wastes tokens (over-provisioning) or degrades quality (under-provisioning).

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim model-routing
/pe-meta-prompt-review pe-gra-agent-design.prompt.md --dim model
/pe-meta-update --mode plan --skip research --dim efficiency
```

**Dimensions covered:** `D26-model-routing`

**Checks performed:**
1. Does the artifact specify `model:` in YAML? If unspecified, it inherits default (potentially suboptimal)
2. For each process phase/step: classify the task type and compare against the declared or implied model class
3. For multi-phase prompts: identify phases where a cheaper model would produce equivalent results
4. For handoff targets: does the target agent's model match the delegated task's requirements?

**Task-model alignment matrix:**

| Task type | Correct model class | Over-provisioned | Under-provisioned |
|---|---|---|---|
| YAML parsing, grep, file existence | Deterministic / small | Reasoning → token waste | N/A |
| Pattern matching, structural checks | Standard | Reasoning → token waste | Small → missed patterns |
| Semantic analysis, contradiction | Reasoning | N/A | Standard → shallow analysis |
| Vision alignment, adherence | Reasoning | N/A | Standard → missed violations |
| Web research, release analysis | Reasoning + web | N/A | Standard → missed implications |

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Task type classification requires LLM judgment ("is this step semantic or structural?") |
| **False positives** | LOW — over-provisioning findings are valid (reasoning model for YAML parsing IS wasteful) |
| **False negatives** | MEDIUM — borderline tasks (partially semantic, partially structural) may not be flagged |
| **Consistency** | ✅ Task-model matrix is a reference table — classification is anchored |

**Reliability score: MEDIUM-HIGH** — the alignment matrix provides clear criteria. Borderline cases are the only variability.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Every pe-gra/pe-meta prompt currently uses one model for all phases — clear over-provisioning |
| **Quality impact** | HIGH — under-provisioned steps (reasoning tasks on standard model) produce shallower analysis |
| **Efficiency impact** | HIGH — over-provisioned steps (deterministic tasks on reasoning model) waste 5-10× tokens |
| **Reliability impact** | MEDIUM — wrong model → inconsistent results across invocations |

**Effectiveness score: HIGH** — model routing is a cross-cutting concern that affects every dimension's quality AND cost.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW — reads artifact process phases, compares against task-model matrix |
| **Model routing** | Standard model (ironic but correct — task classification is structural pattern matching) |
| **Time** | 15-20s per artifact |
| **Recommended frequency** | After creating prompts/agents; after adding phases; as part of `--dim efficiency` or `--dim model` |
| **ROI** | VERY HIGH — each finding reduces cost of every future invocation of the optimized artifact |

**Efficiency score: HIGH** — cheap to run, high compounding returns.
