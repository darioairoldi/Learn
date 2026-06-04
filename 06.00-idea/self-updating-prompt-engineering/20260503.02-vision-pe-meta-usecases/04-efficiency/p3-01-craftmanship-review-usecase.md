# UC-09: Craftmanship review

> **Group:** D - Efficiency and operating economics  
> **Priority:** P3  
> **Order in group:** 7 (run before UC-01)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-review <path> --dim structural`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim craftmanship` (single agent craftsmanship)
- `/pe-meta-context-review <path> --dim craftmanship` (context craftsmanship)
- `/pe-meta-update --mode plan --skip research --dim structural` (system-wide structural health)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim craftmanship` | Focus on `D5-boundaries` + `D14-craftsmanship` |
| `--dim structural` | Broader structural group |
| `--scope agents` | Agent boundary and formatting checks |
| `--scope context` | Context file craftsmanship |
| `--deps none` | Craftsmanship assessed per-artifact |
| `--skip research,consistency,content` | Focus on structural quality only |

## Behavior

Checks structural quality and craftsmanship conventions: N-1 separation, naming conventions, progressive disclosure, section ordering, formatting consistency.

**Invocation examples:**
```
/pe-meta-agent-review pe-gra-agent-builder.agent.md --dim craftmanship
/pe-meta-context-review 01.04-tool-composition-guide.md --dim craftmanship
```

**Dimensions covered:** `D5-boundaries`, `D14-craftsmanship`

**Checks performed:**
- `D5-boundaries`: Boundary completeness — ≥5/2/3 (exemplary bar); each boundary item is testable and actionable; boundaries cross-reference tools and responsibilities
- `D14-craftsmanship`: N-1 separation — rule-bearing sections use `Rule`/`Rationale`/`Example` labeled blocks; naming follows kebab-case convention; content follows progressive disclosure (summary → detail → reference); section ordering matches type-specific template; emoji H2 headings present (for articles); metadata comment block at file end

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ `D5-boundaries` boundary count is deterministic; actionability assessment requires LLM. `D14-craftsmanship` N-1 label presence is deterministic; naming/ordering is pattern-matchable |
| **False positives** | LOW — most checks are against known patterns |
| **False negatives** | LOW — structural patterns are well-defined |
| **Consistency** | ✅ Pattern-matching checks are consistent |

**Reliability score: MEDIUM-HIGH** — mostly pattern-based with limited LLM judgment.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches N-1 gaps (Phase 3 blocker), weak boundaries, inconsistent structure |
| **Real-world example** | This session: all 8 validators had Phase 0.5 decision rules without N-1 labeling |
| **Directly prevents** | Phase 3 autonomous execution with unclassifiable diffs |

**Effectiveness score: HIGH** — craftmanship issues directly block autonomy phase progression.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | LOW — mostly pattern matching and counting |
| **Model routing** | Standard model; deterministic for counting and pattern matching |
| **Time** | 10-15s per artifact |
| **Recommended frequency** | After creation/update; as part of `--dim structural` |

**Efficiency score: HIGH** — cheap and catches important structural gaps.
