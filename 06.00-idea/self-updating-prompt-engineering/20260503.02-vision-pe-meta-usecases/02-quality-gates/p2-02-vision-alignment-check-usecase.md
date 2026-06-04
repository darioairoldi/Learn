# UC-13: Vision alignment check

> **Group:** B - Guidance quality gates  
> **Priority:** P2  
> **Order in group:** 7 (run after UC-08)

## Invocation

**Command family:** Review  
**Primary entry point:** `/pe-meta-review <path> --dim strategic`  
**Alternative entry points:**
- `/pe-meta-agent-review <path> --dim vision-alignment` (agent vision check)
- `/pe-meta-context-review <path> --dim vision-alignment` (context vision check)
- `/pe-meta-update --mode plan --skip research --dim strategic` (system-wide strategic health)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim vision-alignment` | Focus on `D15-vision-alignment` (vision compliance) |
| `--dim strategic` | Broader strategic group including `D15-vision-alignment` |
| `--deps none` | Vision compliance assessed per-artifact |
| `--skip research,structure,consistency` | Focus on strategic alignment only |
| `--mode apply` | Assess and implement improvements autonomously for low-risk findings; propose changes for high-risk findings (default) |
| `--mode plan` | Assessment only — produce findings report without changes (opt-in for read-only output) |

## Behavior

Verifies that a PE artifact complies with the applicable vision rationales (R-L1 through R-G3, R-S9, R-S10). This is the PE-for-PE strategic check that distinguishes pe-meta from pe-gra.

**Invocation examples:**
```
/pe-meta-agent-review pe-gra-agent-builder.agent.md --dim vision-alignment               # assess + implement low-risk (default)
/pe-meta-context-review 02.04-agent-shared-patterns.md --dim vision-alignment            # context vision check (default apply)
/pe-meta-agent-review pe-gra-agent-builder.agent.md --dim vision-alignment --mode plan   # assess only (opt-in read-only)
```

**Dimensions covered:** `D15-vision-alignment`

**Checks performed:**
- Load vision document (latest `*-vision.v*.md`)
- Load strategic review criteria (05.06) with vision alignment checklist
- For the artifact's type, read down the applicable column in the checklist matrix
- For each applicable rationale: does the artifact comply?
- Report: rationale-by-rationale compliance status

**Rationales checked per artifact type** (from 05.06 matrix):

| Rationale | Agents | Prompts | Context | Instructions | Skills | Templates |
|---|---|---|---|---|---|---|
| R-S1 Metadata-driven | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| R-S5 Chain alignment | ✓ | ✓ | inter-file specific | ✓ | ✓ | — |
| R-P4 N-1 separation | ✓ boundaries | — | ✓ MUST | ✓ MUST | ✓ partial | — |
| R-S4 Role declaration | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| R-P2 Decomposition | ✓ ≤7 tools | ✓ phases | ✓ ≤2,500 tokens | ✓ ≤1,500 tokens | ✓ progressive | — |
| R-L2 Self-correction | ✓ handoff to validator | ✓ validation phase | ✓ reviewed by validator | ✓ reviewed | ✓ reviewed | ✓ reviewed |

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
| **Determinism** | ⚠️ Some rationales have deterministic checks (R-P2 token count, R-S1 metadata presence); others require LLM judgment (R-S4 role clarity) |
| **False positives** | LOW — the checklist matrix provides clear criteria |
| **False negatives** | LOW — the matrix is comprehensive for known rationales |
| **Consistency** | ✅ Matrix-driven — same checks every time |

**Reliability score: MEDIUM-HIGH** — the structured checklist matrix makes this more reliable than open-ended LLM assessment.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches vision misalignment that structural checks miss (e.g., Level 2 refs where Level 1.5 required) |
| **Real-world example** | This session: pe-gra agents had Level 2 refs to 02.04/02.05 — vision alignment check would flag R-S5 non-compliance |
| **Unique value** | Only pe-meta does this — pe-gra has no vision awareness |

**Effectiveness score: HIGH** — the defining check of pe-meta's strategic layer.

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM — requires loading vision document + strategic criteria + target artifact |
| **Model routing** | Reasoning model for semantic rationale checks; deterministic for metadata/token checks |
| **Time** | 15-30s per artifact |
| **Recommended frequency** | After creation; during scheduled reviews; as part of `--dim strategic` |

**Efficiency score: MEDIUM** — moderate cost. The vision document is loaded once per invocation and reused across multiple artifacts.
