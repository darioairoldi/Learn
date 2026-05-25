# UC-07: Coverage gaps and unhappy path handling

> **Group:** B - Guidance quality gates  
> **Priority:** P1  
> **Order in group:** 4 (run after UC-04)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode plan --skip research --dim quality`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim coverage --deps direct` (agent coverage check)
- `/pe-meta-prompt-review <path> --dim coverage` (prompt coverage check)
- `/pe-meta-context-review <path> --dim completeness` (guidance completeness)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim coverage` | Focus on D18 (use case coverage) |
| `--dim completeness` | Focus on D10 (guidance completeness) |
| `--scope agents` | Check coverage in agent artifacts |
| `--scope prompts` | Check coverage in prompt artifacts |
| `--deps direct` | Include referenced guidance for behavior-to-rule tracing |
| `--skip research,structure` | Focus on content coverage only |

## Behavior

Identifies missing guidance (rules that should exist but don't) and missing error handling (unhappy paths not covered by response management or process phases).

**Invocation examples:**
```
/pe-meta-agent-review pe-gra-agent-builder.agent.md --dim coverage
/pe-meta-prompt-review pe-meta-review.prompt.md --dim coverage
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim completeness
```

**Dimensions covered:** D10 (completeness), D18 (coverage)

**Checks performed:**
- D10 (guidance completeness): Scan agent behaviors (process phases, handoffs, tool usage) and check whether each behavior has backing guidance in a context file. Flag behaviors that lack backing rules.
- D18 (use case coverage): Does the artifact's process cover the happy path, ambiguous input, missing data, tool failures, out-of-scope requests? Does response management list specific error scenarios? Are embedded test scenarios present (≥3)?

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ❌ Requires LLM reasoning to identify "what guidance should exist but doesn't" |
| **False positives** | MEDIUM — may flag intentionally ungoverned behaviors as gaps |
| **False negatives** | HIGH — completeness is the hardest dimension (you can't detect what you don't know is missing) |
| **Consistency** | ⚠️ Different runs may identify different gaps depending on LLM attention |

**Reliability score: LOW-MEDIUM** — inherently difficult. The "what's missing" question has no deterministic answer. Mitigated by structured prompts that enumerate known behavior categories and check each one.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches the slash-command type of gap — rules that should exist but don't |
| **Real-world example** | H12 defined "cross-reference integrity" for `📖` refs and markdown links but not slash-commands — a completeness gap |
| **Unique value** | Only dimension that proactively discovers MISSING rules, not just problems with EXISTING rules |

**Effectiveness score: HIGH** — despite low reliability on any single run, repeated runs accumulate coverage. The most impactful findings come from this dimension.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | HIGH — requires reading artifact + its dependencies + reasoning about what's missing |
| **Model routing** | Reasoning model required |
| **Time** | 30-60s per artifact |
| **Recommended frequency** | During scheduled reviews; after adding new artifact types; NOT on every change |

**Efficiency score: LOW** — expensive and uncertain. Best used periodically or when specifically investigating quality gaps, not as a routine check.
