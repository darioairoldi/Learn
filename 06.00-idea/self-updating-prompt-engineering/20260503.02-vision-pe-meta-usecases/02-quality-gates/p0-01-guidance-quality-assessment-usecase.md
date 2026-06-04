# UC-02: Guidance quality assessment

> **Group:** B - Guidance quality gates  
> **Priority:** P0  
> **Order in group:** 1 (run first in Group B)

## Invocation

**Command family:** Review / Update  
**Primary entry point:** `/pe-meta-update --mode plan --skip research --dim quality`  
**Alternative entry points:**
- `/pe-meta-context-review <path> --dim quality` (single context file review)
- `/pe-meta-instruction-review <path> --dim quality` (single instruction file review)
- `/pe-meta-scheduled-review --dim quality --deps direct` (recurring quality gate)

**Supported options:**

| Option | Relevance to this use case |
|---|---|
| `--dim quality` | Limits to `D6-consistency` through `D11-actionability` guidance quality dimensions |
| `--dim clarity` | Focus on `D9-clarity` only |
| `--scope context` | Assess context files only |
| `--scope instructions` | Assess instruction files only |
| `--deps direct` | Include immediate referenced guidance |
| `--skip research,structure` | Focus on content quality only |

## Behavior

Assesses the 6 guidance quality properties (from vision v10 § Guidance quality as prerequisite) on context files and other guidance-bearing artifacts. This is the quality gate for autonomy phase progression — guidance must meet minimum thresholds before the system can autonomously act on it.

**Invocation examples:**
```
/pe-meta-update --mode plan --skip research --scope instructions --dim full
/pe-meta-update --mode plan --skip research .github/instructions/pe-agents.instructions.md --dim full
/pe-meta-update --mode plan --skip research .github/instructions/pe-prompts.instructions.md --dim full
/pe-meta-instruction-review pe-agents.instructions.md --dim full
/pe-meta-context-review 01.07-critical-rules-priority-matrix.md --dim quality
/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim quality
/pe-meta-instruction-review pe-agents.instructions.md --dim clarity
```

**Dimensions covered:** `D6-consistency`, `D7-non-redundancy`, `D8-prioritization`, `D9-clarity`, `D10-completeness`, `D11-actionability`

**Checks performed:**
- `D6-consistency`: Do rules within the file contradict each other? Do rules contradict rules in files this one references?
- `D7-non-redundancy`: Is each rule defined in exactly one place? `grep_search` for key phrases across context files
- `D8-prioritization`: Where rules could conflict, is the priority matrix entry present? Are priorities explicit?
- `D9-clarity`: LLM agreement test — two independent passes produce the same interpretation of each rule
- `D10-completeness`: Scan agent behaviors that lack backing rules — are there agents that do things no rule governs?
- `D11-actionability`: Can each rule be translated into a boolean pass/fail check?

## Reliability analysis

| Factor | Assessment |
|---|---|
| **Determinism** | ⚠️ `D7-non-redundancy`, `D8-prioritization` partially deterministic (grep-based); `D6-consistency`, `D9-clarity`, `D10-completeness`, `D11-actionability` require LLM judgment |
| **False positives** | MEDIUM — clarity and actionability are subjective; LLMs may flag clear rules as ambiguous |
| **False negatives** | MEDIUM — completeness gaps are hard to detect (you don't know what you don't know) |
| **Consistency** | ⚠️ `D9-clarity` (clarity 2-pass) may produce different results across runs due to LLM variability |

**Reliability score: MEDIUM** — LLM-dependent dimensions introduce variability. Mitigated by: (1) running `D9-clarity` with temperature=0, (2) accepting findings only when both passes agree, (3) using `D7-non-redundancy` / `D8-prioritization` deterministic checks as anchors.

## Effectiveness analysis

| Factor | Assessment |
|---|---|
| **Catches real issues** | ✅ Catches ambiguous rules, duplicate definitions, missing priority declarations, guidance gaps |
| **Directly prevents** | Autonomous actions based on ambiguous or contradictory guidance |
| **Unique value** | This is the ONLY check that assesses whether guidance is good enough to trust for autonomous operation |

**Effectiveness score: HIGH** — this is the prerequisite check for the entire autonomy gradient. Without it, the system can't distinguish "rule is clear, apply it" from "rule is ambiguous, escalate."

## Efficiency analysis

| Factor | Assessment |
|---|---|
| **Token cost** | MEDIUM-HIGH — `D9-clarity` requires two full LLM passes per rule; `D10-completeness` requires cross-referencing agents against rules |
| **Model routing** | `D7-non-redundancy`, `D8-prioritization`: standard model. `D6-consistency`, `D9-clarity`, `D10-completeness`, `D11-actionability`: reasoning model |
| **Time** | 30-60 seconds per context file (depends on rule count) |
| **Recommended frequency** | At phase transitions (Phase 1→2→3); during scheduled reviews; after context file changes |

**Efficiency score: MEDIUM** — expensive but essential. Cost is bounded by running only on changed context files, not the entire set. The `--dim quality` shortcut runs all 6 properties; individual properties can be targeted for even lower cost.

## Latest execution status (2026-05-21)

- Consolidated status: [99.00-temp/20260521-uc02-consolidated-post-hardening.md](../../../../99.00-temp/20260521-uc02-consolidated-post-hardening.md)
- Single-file quality rerun (01.07, post-H13 baseline): [99.00-temp/20260521-uc02-guidance-quality-assessment-01.07-rerun-2.md](../../../../99.00-temp/20260521-uc02-guidance-quality-assessment-01.07-rerun-2.md)
- Single-file quality hardening rerun (`D9-clarity` / `D11-actionability` focus): [99.00-temp/20260521-uc02-guidance-quality-assessment-01.07-rerun-3.md](../../../../99.00-temp/20260521-uc02-guidance-quality-assessment-01.07-rerun-3.md)
- Folder-level completeness rerun (`D10-completeness`): [99.00-temp/20260521-context-review-completeness-folder-rerun.md](../../../../99.00-temp/20260521-context-review-completeness-folder-rerun.md)

Current interpretation:
- UC-02 gate is pass-with-findings at single-file quality level.
- `D10-completeness` is pass at folder level.
- Context structural health baseline is stable (recursive links and budget checks are both pass).
