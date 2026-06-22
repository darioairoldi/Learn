# UC-08: Artifact structure and scope optimization

> **Group:** B - Guidance quality gates  
> **Priority:** P2  
> **Order in group:** 6 (run after P1 checks)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-review <path> --dim structural`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim artifact-structure` (agent structure audit)
- `/pe-meta-context-review <folder> --dim artifact-structure` (context set structure)
- `/pe-meta-review --mode plan --skip research --dim structural` (system-wide structure health)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim artifact-structure` | Focus on `D19-artifact-structure` (structure and scope) |
| `--dim structural` | Broader structural group |
| `--scope agents` | Audit agent structure only |
| `--scope context` | Audit context file organization |
| `--deps none` | Structure is assessed per-artifact |
| `--skip research,consistency,content` | Focus on structural assessment only |

## Behavior

Reviews whether an artifact's goal, scope, and boundaries are correctly sized — not too broad (should be split), not too narrow (should be merged), and properly focused (single responsibility).

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim artifact-structure
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim artifact-structure
```

**Dimensions covered:** `D19-artifact-structure`

**Checks performed:**
- Does the artifact's `goal:` describe a single clear purpose? (Multi-purpose goals → should split)
- Does `scope.covers:` list more than 5-6 items? (May be too broad)
- Does `scope.excludes:` effectively redirect to other artifacts? (Incomplete exclusions → scope bleed)
- Are `boundaries:` testable? (Vague boundaries → not enforceable)
- For agents: does the expertise section describe more than one distinct role? (Violates R-S4/H11 single responsibility)
- For context files: does the file cover more than one logical topic? (Should be split per topic)
- For context folders: are there too many small files (>10) or too few large files (<3)? (Organizational balance)

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM judgment — "is this scope too broad?" is subjective |
| **False positives** | MEDIUM — may flag intentionally broad artifacts as needing split |
| **False negatives** | LOW — artifacts with clearly overlapping scope are usually detected |
| **Consistency** | ⚠️ Borderline cases may get different assessments across runs |

**Reliability score: MEDIUM** — scope optimization is inherently judgmental. Mitigated by anchoring assessment to quantitative signals (item count in scope.covers, word count, dependency count) before applying LLM judgment.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches scope creep, role violations, organizational imbalance |
| **Real-world example** | pe-meta-researcher accumulating research + adherence checking + coherence analysis = scope creep |
| **Directly prevents** | Over-loaded agents, context files that grow unbounded, scope overlap between artifacts |

**Effectiveness score: MEDIUM-HIGH** — catches organizational issues that per-rule checks miss. Most effective when applied to the full folder (not individual files).

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM — reads artifact metadata + checks quantitative signals + LLM judgment |
| **Model routing** | Reasoning model for scope assessment; standard model for quantitative checks |
| **Time** | 15-30s per artifact; 2-5 minutes for full folder |
| **Recommended frequency** | After significant refactoring; during scheduled reviews; when adding new artifacts |

**Efficiency score: MEDIUM** — reasonable cost for the organizational insight it provides.
