# UC-03: Consistency check (non-contradiction)

> **Group:** B - Guidance quality gates  
> **Priority:** P1  
> **Order in group:** 2 (run after UC-02)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode plan --dim quality --skip research,structure`  
**Alternative entry points:**
- `/pe-meta-context-review <path> --dim consistency` (single file)
- `/pe-meta-review <path> --dim consistency --deps full` (cross-dependency coherence)
- `/pe-meta-scheduled-review --dim quality --deps full` (rotation-triggered, deep dep check)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim consistency` | Focus on D6 (consistency) + D17 (cross-coherence) |
| `--deps full` | Required for cross-dependency consistency checking |
| `--deps direct` | First-level dependency consistency only |
| `--scope context` | Limit to context files |
| `--skip research,structure` | Focus on consistency analysis only |

## Behavior

Verifies that rules across artifacts don't contradict each other. Operates at two scales: within a single artifact (internal consistency) and across loaded dependencies (cross-dependency coherence).

**Invocation examples:**
```
/pe-meta-context-review 01.06-system-parameters.md --dim consistency
/pe-meta-agent-review pe-meta-validator.agent.md --dim consistency --deps full
/pe-meta-update --mode plan --skip research --dim consistency
```

**Dimensions covered:** D6 (consistency), D17 (cross-coherence when `--deps full`)

**Checks performed:**
- Within-file: Do any two rules in the same artifact contradict? (e.g., one section says "3-7 tools", another says "max 5 tools")
- Cross-file: Does the artifact's rules contradict rules in its `📖`-referenced context files?
- With `--deps full`: Do the context files an agent loads contradict each other? (e.g., 01.04 says "3-7 tools" but 01.06 says "3-5 tools")
- Priority matrix: Where contradictions exist, is the precedence documented?

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM reasoning to detect semantic contradictions (not just string mismatch) |
| **False positives** | MEDIUM — LLM may flag complementary rules as contradictory (e.g., "use active voice" and "be concise" are complementary, not contradictory) |
| **False negatives** | LOW-MEDIUM — direct contradictions are usually caught; subtle priority conflicts may be missed |
| **Consistency** | ⚠️ Depends on LLM reasoning quality — mitigated by structured comparison prompts |

**Reliability score: MEDIUM** — semantic contradiction detection inherently requires judgment. Mitigated by (1) checking against explicit priority matrix entries first (deterministic), (2) flagging uncertain cases for human review rather than asserting contradiction.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches rule conflicts that cause agents to receive contradictory directives |
| **Real-world example** | Two context files both defining token budgets with different numbers; instruction file rule contradicting a context file rule |
| **Directly prevents** | Agents receiving ambiguous or conflicting guidance at runtime |

**Effectiveness score: HIGH** — contradictions are among the most damaging quality issues because they silently degrade agent behavior.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM (within-file), HIGH (cross-dependency — requires reading multiple files) |
| **Model routing** | Reasoning model for semantic comparison; deterministic for priority matrix lookup |
| **Time** | 10-20s within-file; 30-60s with dependencies |
| **Recommended frequency** | After any rule change; during scheduled reviews; as part of `--dim quality` |

**Efficiency score: MEDIUM** — cross-dependency mode is expensive but essential for artifacts that load multiple context files. Bounded by only comparing actually-loaded dependencies, not all context files.
