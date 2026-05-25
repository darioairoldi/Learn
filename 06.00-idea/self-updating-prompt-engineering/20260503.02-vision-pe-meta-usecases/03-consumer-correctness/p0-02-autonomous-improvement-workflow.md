# UC-23: Autonomous improvement workflow

> **Group:** C - Consumer implementation correctness  
> **Priority:** P0  
> **Order in group:** 2 (run after UC-12)

## Invocation

**Command family:** Review (default `--mode apply`)  
**Primary entry point:** `/pe-meta-review <path> --deps direct`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --deps direct` (agent-focused improvement)
- `/pe-meta-prompt-review <path> --deps direct` (prompt-focused improvement)
- `/pe-meta-scheduled-review --deps direct` (rotation-triggered autonomous improvement)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--deps direct` | Check first-level dependencies for coherence (default for this UC) |
| `--deps full` | Recursive dependency traversal (depth 2) for comprehensive improvement |
| `--dim full` | All applicable dimensions (default) |
| `--dim quality` | Focus on quality-related dimensions only |
| `--scope agents` | Target agent artifacts |
| `--scope prompts` | Target prompt artifacts |
| `--skip research` | Skip external source fetch for speed |
| `--mode apply` | Assess and implement improvements autonomously for low-risk findings; propose changes for high-risk findings (default) |
| `--mode plan` | Assessment only — produce findings report without changes (opt-in for read-only output) |

## Purpose

Demonstrate how Review achieves the same quality goal as Create — by investigating existing artifacts, identifying improvements, classifying risk, and applying low-risk changes autonomously. This is the **default behavior** when no explicit `--mode` is specified.

**Parity principle:** If an artifact were created from scratch, it would reach the same quality target that `--mode apply` now brings the existing artifact to — just via a different path (understand + improve vs. research + build).

## Behavior

The autonomous improvement workflow implements the full investigate → reason → validate → apply flow:

**Invocation examples:**
```
/pe-meta-review pe-meta-validator.agent.md --deps direct               # assess + implement low-risk (default)
/pe-meta-review pe-meta-validator.agent.md --deps direct --mode plan   # assess only (opt-in read-only)
/pe-meta-review pe-meta-validator.agent.md --dim quality               # targeted improvement (default apply)
```

**Dimensions covered:** All applicable dimensions + risk classification per finding

**Workflow:**
1. Full dimensional assessment of target artifact + direct dependencies
2. Generate findings with per-finding risk classification
3. For each non-breaking finding with high confidence: apply fix → validate fix → record change
4. For each non-breaking finding with medium confidence: apply with pre-notification
5. For each breaking finding: add to proposal report
6. Output: combined report (applied changes + proposed changes requiring confirmation)

**Risk classification logic:**

| Change type | Risk level | Action |
|---|---|---|
| Formatting, reference links, metadata fixes | Non-breaking | Apply autonomously |
| Missing dimensions, expanded coverage | Non-breaking | Apply with notification |
| Content removals or rewrites | Potentially breaking | Propose |
| Scope changes (new types, new boundaries) | Breaking | Always propose |

## Post-assessment behavior

By default (`--mode apply`), the command evaluates each finding against the vision's change classification:

| Finding risk | Action | Confirmation |
|---|---|---|
| **Non-breaking** (goal, scope, boundaries preserved) + high confidence | Apply autonomously | Post-execution notification only |
| **Non-breaking** + medium confidence | Apply with lightweight pre-notification | User can abort within notification window |
| **Breaking** (changes goal, scope, or boundaries) | Propose as plan | Requires explicit human confirmation |
| **Uncertain** (cannot classify risk) | Propose as plan | Requires explicit human confirmation |

The risk assessment integrates with the autonomy gradient defined in the vision:
- **Structural fixes** (formatting, reference links, metadata) → Always non-breaking → Autonomous
- **Content additions** (missing dimensions, expanded coverage) → Usually non-breaking → Autonomous with notification
- **Content removals or rewrites** → May be breaking → Propose
- **Scope changes** (new artifact types, new boundary rules) → Breaking → Always propose

## Relationship to Create

| Aspect | Create | Review (default apply) |
|---|---|---|
| **Starting point** | Empty / research | Existing artifact |
| **Investigation** | Research → build | Assess → improve |
| **Quality target** | Same | Same |
| **Output** | New artifact at quality target | Existing artifact improved to quality target |
| **Path** | Research + build | Understand + improve |

Both paths converge to the same quality target. The only difference is the starting point and the investigation direction.

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | Mixed — structural fixes are deterministic; semantic improvements require LLM |
| **False positives** | LOW — risk classification prevents inappropriate autonomous changes |
| **False negatives** | LOW-MEDIUM — conservative risk assessment may classify some safe changes as uncertain |
| **Consistency** | MEDIUM-HIGH — risk classification provides a stable decision framework |

**Reliability score: MEDIUM-HIGH** — the risk classification framework provides consistent decision-making. Conservative bias ensures safety at the cost of occasionally proposing changes that could be applied autonomously.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ All findings from full dimensional assessment |
| **Unique value** | Closes the loop — findings become improvements without manual intervention |
| **Coverage** | Maximum — applies the same quality assessment as all other Review use cases |

**Effectiveness score: VERY HIGH** — the gold standard for autonomous quality improvement. Achieves the same outcomes as Create by iterating on existing artifacts.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM-HIGH — assessment + implementation + validation per finding |
| **Model routing** | Standard for structural fixes; reasoning for semantic improvements; deterministic for validation |
| **Time** | 2-5 minutes per artifact (depends on finding count and complexity) |
| **Recommended frequency** | Default behavior for all Review invocations; scheduled reviews; post-release updates |

**Efficiency score: MEDIUM** — more expensive than assessment-only but delivers immediate value. Cost justified by eliminating the manual confirmation → re-invocation cycle for low-risk improvements.
