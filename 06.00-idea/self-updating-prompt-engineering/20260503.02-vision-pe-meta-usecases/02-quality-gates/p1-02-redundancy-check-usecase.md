# UC-04: Redundancy check (single source of truth)

> **Group:** B - Guidance quality gates  
> **Priority:** P1  
> **Order in group:** 3 (run after UC-03)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-review --mode plan --skip research --dim efficiency --scope context`  
**Alternative entry points:**
- `/pe-meta-context-review <path> --dim non-redundancy` (single folder scan)
- `/pe-meta-review --mode apply --dim optimize --skip research,structure,consistency --scope context` (apply redundancy fixes)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim non-redundancy` | Focus on `D7-non-redundancy` specifically |
| `--dim efficiency` | Broader group including `D7-non-redundancy` |
| `--scope context` | Primary target — redundancy most impactful in context files |
| `--deps none` | Assess within the context set (no consumer traversal) |
| `--skip research,structure,consistency` | Focus on redundancy detection only |

## Behavior

Detects rules or concepts defined in more than one canonical location. Redundancy causes drift — when a rule is updated in one file but not the other, the system has two versions of truth.

**Invocation examples:**
```
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim non-redundancy
/pe-meta-review --mode plan --skip research --dim efficiency
```

**Dimensions covered:** `D7-non-redundancy`

**Checks performed:**
- Extract key rules (MUST/NEVER/ALWAYS statements) from each context file
- `grep_search` for each rule's key phrases across all other context files
- Flag duplicates with both file locations and an assessment of whether they are identical, compatible, or conflicting copies
- Propose which location is canonical and which should reference it

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Partially deterministic — grep detects identical text; LLM needed for paraphrased duplicates |
| **False positives** | LOW — identical text found in two files is definitively redundant |
| **False negatives** | MEDIUM — paraphrased duplicates (same rule, different wording) may be missed by grep; LLM catch rate depends on prompt quality |
| **Consistency** | ✅ Grep-based detection is fully consistent; LLM detection is mostly consistent |

**Reliability score: MEDIUM-HIGH** — grep catches exact duplicates reliably; paraphrased duplicates require LLM assistance but false negatives are recoverable (they'll be caught in the next review).

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches the "two places with different numbers" problem the vision identifies as internal drift |
| **Real-world example** | Tool count limit (3-7) defined in both 01.04 and 01.06 — if one changes, the other drifts |
| **Directly prevents** | Silent drift when one copy is updated but not the other |

**Effectiveness score: HIGH** — redundancy is a root cause of internal drift. Catching it prevents downstream contradictions.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW-MEDIUM — grep is cheap; LLM comparison needed only for flagged candidates |
| **Model routing** | Deterministic (grep) for detection; standard model for paraphrase analysis |
| **Time** | 20-30s for full context folder scan |
| **Recommended frequency** | After creating new context files; during scheduled reviews; as part of `--dim quality` or `--dim efficiency` |

**Efficiency score: HIGH** — mostly grep-based with LLM only for edge cases. One of the cheaper semantic dimensions.
