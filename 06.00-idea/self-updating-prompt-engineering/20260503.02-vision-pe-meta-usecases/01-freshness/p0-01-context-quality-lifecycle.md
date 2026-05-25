# UC-22: Context quality lifecycle

> **Group:** A - Source-grounded freshness and lifecycle  
> **Priority:** P0  
> **Order in group:** 1 (run first in Group A)

## Invocation

**Command family:** Review / Update (orchestration)  
**Primary entry point:** `/pe-meta-context-review <path> --dim context-full`  
**Alternative entry points:**
- `/pe-meta-update --mode apply --scope context` (apply mode, full-depth lifecycle)
- `/pe-meta-update --mode plan --skip research --dim freshness --scope context` (quick freshness check)
- `/pe-meta-scheduled-review --dim freshness --deps full` (rotation-triggered)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim context-full` | Full context lifecycle dimensions (D6–D13, D17, D19, D22) |
| `--dim context-health` | Subset for health-mode assessment |
| `--scope context` | Focus on context files (primary target) |
| `--deps full` | Include transitive consumer impact verification |
| `--skip research` | Skip external source fetch (local-only mode) |
| `--mode apply` | Assess and implement improvements autonomously for low-risk findings; propose changes for high-risk findings (default) |
| `--mode plan` | Assessment only — produce findings report without changes (opt-in for read-only output) |

## Behavior

Runs a full context-quality lifecycle that starts from source-grounded staleness detection and ends with validated integration decisions. Unlike UC-16, this use case is not optimization-only. It orchestrates quality dimensions across consistency, redundancy, staleness, completeness, structure, and optimization.

**Invocation examples:**
```
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full         # assess + implement low-risk (default)
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-quality-lifecycle
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full --mode plan  # assess only (opt-in read-only)
/pe-meta-update --mode apply --dim context-quality-lifecycle
```

**Dimensions covered (default deep pass):** D6, D7, D8, D9, D10, D11, D12, D13, D17, D19, D22

**Lifecycle stages:**

### Stage 0: Source intake and validation
- Build one source set from authoritative defaults plus user-provided sources (if supplied)
- Score trust and relevance per source
- Produce claim-to-source evidence links and discard weak evidence

### Stage 1: Context-set impact assessment
- Detect which context areas and dimensions are affected
- Evaluate whether impacts are content-only or potentially structural
- Produce an impact packet with confidence and risk levels

### Stage 2: Structure decision
- Decide `no-change`, `split`, `merge`, `create`, `retire`, or `remap`
- Require approval for high-impact structural changes
- Produce a structure decision matrix

### Stage 3: Per-artifact update and verification
- Apply updates under the approved structure
- Run dimension checks and consumer-impact verification
- Emit final integration gate: `apply-autonomously`, `require-approval`, or `report-only`

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
| **Determinism** | MEDIUM — structural checks deterministic; source relevance and quality checks are mixed deterministic + LLM |
| **False positives** | MEDIUM — aggressive source signals may trigger unnecessary review without strong claim contradiction |
| **False negatives** | LOW-MEDIUM — broad source coverage reduces misses, but unavailable sources can still hide drift |
| **Consistency** | MEDIUM-HIGH — improves with structured source ledger and explicit gate decisions |

**Reliability score: MEDIUM-HIGH** — reliability increases because integration is gated by source evidence quality and explicit risk routing.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | HIGH — addresses Type B staleness and downstream context-quality degradation in one workflow |
| **Unique value** | Unifies source investigation, context-set reasoning, structure decisions, and verified integration |
| **Directly prevents** | Silent stale guidance integration and optimization-only reviews that miss quality regressions |

**Effectiveness score: HIGH** — this is the primary use case for autonomous, source-grounded context evolution.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM-HIGH for deep lifecycle runs; LOW-MEDIUM for health mode |
| **Model routing** | Deterministic for metadata/references/counts, standard for screening, reasoning for structure decisions |
| **Time** | 2-6 minutes depending on source set size and number of affected files |
| **Recommended frequency** | Triggered by platform/model/ecosystem changes and high-signal user-provided sources |

**Efficiency score: MEDIUM** — cost is controlled by progressive depth and explicit escalation gates.

## Relationship to other use cases

| Use case | Relationship |
|---|---|
| UC-05 (staleness verification) | Provides source-grounded drift evidence and claim validation inputs |
| UC-16 (context optimization) | Provides D22 optimization checks within the broader lifecycle |
| UC-02/03/04/07/10 | Provide quality checks for consistency, redundancy, completeness, and prioritization |
| UC-08 | Provides structure and scope optimization checks used in Stage 2 |

**Key distinction:** UC-16 answers "is the context set organized efficiently?" UC-22 answers "can we autonomously investigate, validate, decide, and integrate context changes reliably, effectively, and efficiently?"
