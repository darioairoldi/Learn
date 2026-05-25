# UC-06: Token budget analysis

> **Group:** D - Efficiency and operating economics  
> **Priority:** P1  
> **Order in group:** 1 (run first in Group D)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim optimize --deps direct` (single agent token analysis)
- `/pe-meta-update --mode plan --skip research --dim efficiency` (broad efficiency health check)
- `/pe-meta-scheduled-review --dim optimize --deps direct` (rotation-triggered)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim optimize` | Efficiency dimension group including D3, D20 |
| `--dim token-budget` | Focus on D3 (per-artifact budget) |
| `--scope agents,prompts` | Token budgets most relevant for consumers |
| `--deps direct` | Include loaded context chain in token calculation |
| `--deps full` | Full transitive chain token analysis |
| `--skip research,structure,consistency` | Focus on token efficiency only |

## Behavior

Analyzes token consumption at two scales: per-artifact (is this file within its type-specific budget?) and per-chain (when an agent loads all its context files, does the total fit in the context window?).

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim token-budget
/pe-meta-agent-review pe-meta-validator.agent.md --dim token-chain --deps full
/pe-meta-update --mode plan --skip research --dim efficiency
```

**Dimensions covered:** D3 (token-budget), D20 (token-chain)

**Checks performed:**
- D3: Count tokens in the artifact body. Compare against type-specific limits from 01.06 (context: 2,500; instruction: 1,500; simple prompt: 1,500; orchestrator: 2,500; meta-prompt: 3,000)
- D20: Enumerate all `📖` references and `context_dependencies` for an agent/prompt. Sum the token counts of all referenced guidance files. Report: total chain cost, percentage of context window consumed, consumer burden (files loaded but not referenced in process phases)

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ✅ D3 fully deterministic (count tokens). D20 fully deterministic (sum referenced file sizes) |
| **False positives** | Near-zero — token count is a measurable fact |
| **False negatives** | LOW — may miss dynamically loaded context (files loaded via `read_file` at runtime, not declared in metadata) |
| **Consistency** | ✅ Same result every time (unless file content changes between runs) |

**Reliability score: HIGH** — purely deterministic measurement.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ D3 catches oversized files. D20 catches context window saturation |
| **Real-world example** | pe-meta-validator at 400+ lines exceeds 300-line guideline; agent loading 6 context files consuming 60% of context window |
| **Unique value** | D20 (chain analysis) is the ONLY check that assesses token cost at the consumer level, not the producer level |

**Effectiveness score: MEDIUM-HIGH** — D3 is straightforward; D20 provides unique insight into whether the guidance chain is practically usable.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | D3: near-zero (count lines). D20: LOW (sum file sizes, no LLM needed) |
| **Model routing** | Small model or deterministic tool — no LLM reasoning needed |
| **Time** | D3: <1s. D20: 5-10s (reads multiple files) |
| **Recommended frequency** | D3: on every change. D20: during scheduled reviews; after adding new `📖` references |

**Efficiency score: HIGH** — one of the cheapest dimensions. Should be included in every review as baseline.
