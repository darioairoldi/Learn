# UC-17: Reference load efficiency

> **Group:** D - Efficiency and operating economics  
> **Priority:** P2  
> **Order in group:** 4 (run after UC-19)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode apply --dim optimize --skip research,structure,consistency --scope agents,prompts`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim optimize --deps direct` (single agent reference analysis)
- `/pe-meta-prompt-review <path> --dim reference-efficiency` (prompt reference check)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim reference-efficiency` | Focus on D23 specifically |
| `--dim optimize` | Broader efficiency group including D23 |
| `--scope agents,prompts` | Consumer artifacts that load references |
| `--deps direct` | Include referenced files in load analysis |
| `--skip research,structure,consistency` | Focus on reference efficiency only |

## Behavior

Analyzes whether an artifact's `📖` and category references are efficiently organized — checking reference count, load necessity (is each reference actually consumed?), and load placement (phase-specific vs upfront).

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --dim reference-efficiency
/pe-meta-prompt-review pe-meta-review.prompt.md --dim efficiency
```

**Dimensions covered:** D23 (reference-efficiency)

**Checks performed:**
1. Count all `📖`, category, and template references in the artifact
2. For each reference: search the artifact's process phases, boundaries, and checklists — is the reference content actually used?
3. Check placement: is the reference in "Always Do" (loaded every invocation) or in a specific phase (loaded only when that phase runs)?
4. For high-count artifacts (>8 refs): estimate total token cost if all references are loaded

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ Reference counting is deterministic; "is this reference consumed?" requires LLM to trace usage |
| **False positives** | LOW — a reference that no process phase mentions is clearly unnecessary |
| **False negatives** | MEDIUM — implicit usage (reference consumed via a skill or template) may be missed |
| **Consistency** | ✅ Reference counting is consistent; usage tracing is mostly consistent |

**Reliability score: MEDIUM-HIGH** — the deterministic parts anchor the analysis.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ In this session: pe-gra-agent-validator had 21 references — some loaded but never used in process phases |
| **Unique value** | Only dimension that checks whether loaded context is actually CONSUMED, not just resolvable |
| **Directly prevents** | Token waste from loading context files that the artifact never reads |

**Effectiveness score: HIGH** — reference bloat is a common efficiency problem that compounds (loaded on every invocation).

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW — reads the artifact once, counts references, traces usage |
| **Model routing** | Standard model for usage tracing; deterministic for counting |
| **Time** | 10-15s per artifact |
| **Recommended frequency** | After adding references; as part of `--dim efficiency` |

**Efficiency score: HIGH** — cheap to run, high-value findings.
