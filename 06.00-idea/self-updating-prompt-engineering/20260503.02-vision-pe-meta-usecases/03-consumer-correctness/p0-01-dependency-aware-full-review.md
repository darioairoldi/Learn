# UC-12: Dependency-aware full review

> **Group:** C - Consumer implementation correctness  
> **Priority:** P0  
> **Order in group:** 1 (run first in Group C)

## Invocation

**Command family:** Review  
**Primary entry point:** `/pe-meta-review <path> --deps full`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --deps full --dim full` (agent with full dimensions + deps)
- `/pe-meta-prompt-review <path> --deps full --dim adherence` (prompt with adherence focus)
- `/pe-meta-scheduled-review --deps full` (rotation-triggered full-depth review)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--deps full` | Required — enables recursive dependency traversal (depth 2) |
| `--deps direct` | Shallow variant — one-hop dependency check |
| `--dim full` | All applicable dimensions (default) |
| `--dim adherence` | Focus on boundary and adherence dimensions (legacy alias: `--dim robustness`) |
| `--scope agents` | Target agent artifacts |
| `--scope prompts` | Target prompt artifacts |
| `--skip research` | Skip external source fetch for speed |
| `--mode apply` | Assess and implement improvements autonomously for low-risk findings; propose changes for high-risk findings (default) |
| `--mode plan` | Assessment only — produce findings report without changes (opt-in for read-only output) |

## Behavior

The most comprehensive review mode: validates the target artifact individually, validates each of its dependencies individually, then checks cross-dependency coherence and adherence. Recursive (bounded to depth 2).

**Invocation examples:**
```
/pe-meta-agent-review pe-meta-validator.agent.md --deps full               # assess + implement low-risk (default)
/pe-meta-agent-review pe-meta-validator.agent.md --dim full --deps full     # full dimensions + deps (default apply)
/pe-meta-prompt-review pe-meta-review.prompt.md --deps full --mode plan    # assess only (opt-in read-only)
```

**Dimensions covered:** All applicable dimensions + cross-dependency checks (D17, D20)

**Workflow:**
1. Individual full review of target (all applicable dimensions)
2. Identify dependencies (`📖` refs, `context_dependencies:`, `handoffs:`, `applyTo` matches)
3. For each dependency: individual full review (recursive — depth capped at 2)
4. Cross-dependency coherence (D17): Do loaded context files contradict each other?
5. Adherence verification (D16): Does the target implement all rules from its dependencies?
6. Token chain analysis (D20): Total loading cost of the target's guidance set
7. Consumer burden analysis: Does the target load guidance it doesn't use?
8. Combined report: target + per-dependency + cross-dependency + adherence matrix

**Note:** Can be combined with `--dim` to run dependency-aware review on a specific dimension only:
```
/pe-meta-agent-review pe-meta-validator.agent.md --deps full --dim consistency
```
This checks consistency of the target AND its dependencies, plus cross-dependency contradiction — without running other dimensions.

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

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | Mixed — structural dimensions are deterministic; semantic dimensions require LLM |
| **False positives** | MEDIUM — aggregation increases the chance of at least one false positive per run |
| **False negatives** | LOW — the comprehensive scope minimizes blind spots |
| **Consistency** | ⚠️ Full runs may produce different finding counts across runs due to LLM variability |

**Reliability score: MEDIUM** — the most comprehensive but also the most variable. Best used for thorough audits, not routine checks.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches everything that individual dimensions catch + cross-cutting issues |
| **Unique value** | Only mode that sees the artifact in the context of its full dependency chain |
| **Coverage** | Maximum — no known blind spots (assuming all dimensions are included) |

**Effectiveness score: VERY HIGH** — the gold standard review. Catches both per-artifact and system-level issues.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | VERY HIGH — reads target + all dependencies + runs all dimension checks |
| **Model routing** | Reasoning model for semantic dimensions; standard for structural; deterministic where possible |
| **Time** | 3-10 minutes per artifact (depends on dependency count) |
| **Recommended frequency** | Before major releases; during phase transition assessments; for critical PE infrastructure |

**Efficiency score: LOW** — the most expensive review. Should be reserved for important artifacts and critical milestones. Use targeted dimensions (`--dim structural`, `--dim quality`) for routine reviews.
