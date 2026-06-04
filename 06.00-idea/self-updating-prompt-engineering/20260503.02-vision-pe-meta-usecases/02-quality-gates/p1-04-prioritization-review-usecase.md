# UC-10: Rules prioritization review

> **Group:** B - Guidance quality gates  
> **Priority:** P1  
> **Order in group:** 5 (run after UC-07)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-context-review 01.07-critical-rules-priority-matrix.md --dim prioritization`  
**Alternative entry points:**
- `/pe-meta-update --mode plan --skip research --dim quality --scope context` (broader quality sweep including prioritization)
- `/pe-meta-context-review <folder> --dim prioritization` (folder-wide priority check)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim prioritization` | Focus on `D8-prioritization` (explicit precedence) |
| `--scope context` | Primary target — priority matrix lives in context |
| `--deps none` | Self-contained check against priority matrix |
| `--skip research,structure,consistency` | Focus on prioritization audit only |

## Behavior

Verifies that when rules could conflict, explicit precedence is documented in the critical rules priority matrix or within the artifacts themselves.

**Invocation examples:**
```
/pe-meta-context-review 01.07-critical-rules-priority-matrix.md --dim prioritization
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim prioritization
```

**Dimensions covered:** `D8-prioritization`

**Checks performed:**
- Enumerate all MUST/NEVER/ALWAYS rules across active context files
- Identify rule pairs that could conflict (same topic, different thresholds or different guidance)
- Check whether each conflict pair has an entry in 01.07 (critical rules priority matrix)
- Check whether the priority matrix covers all HIGH-severity rules
- Flag rules where priority is implicit ("probably this one wins") rather than explicit ("01.07 says H2 overrides H5")

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Rule enumeration is deterministic (grep for MUST/NEVER/ALWAYS); conflict pair identification requires LLM judgment |
| **False positives** | MEDIUM — may flag non-conflicting rules as potential conflicts |
| **False negatives** | MEDIUM — subtle conflicts (same concept, different implied thresholds) may be missed |
| **Consistency** | ⚠️ Conflict pair identification depends on LLM attention |

**Reliability score: MEDIUM** — the deterministic part (checking matrix coverage) is reliable; the LLM part (identifying potential conflicts) is less so.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches priority gaps that cause ambiguous behavior when agents load conflicting guidance |
| **Real-world example** | Two context files both defining boundary minimums — which threshold applies? |
| **Directly prevents** | Agents receiving guidance with implicit priority and making inconsistent decisions |

**Effectiveness score: MEDIUM-HIGH** — prioritization gaps are subtle but impactful. Most valuable when run across the full context folder.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM — requires reading priority matrix + scanning rules across context files |
| **Model routing** | Standard model for rule enumeration; reasoning model for conflict identification |
| **Time** | 20-40s for full context folder |
| **Recommended frequency** | After adding new rules; during scheduled reviews; as part of `--dim quality` |

**Efficiency score: MEDIUM** — moderate cost with moderate frequency.
