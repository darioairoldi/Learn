---
name: pe-meta-context-review
description: "Lifecycle-aware context review across quality dimensions with source-mode handling and stage-ordered outputs"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, fetch_webpage, replace_string_in_file, create_file]
handoffs:
  - label: "Validate"
    agent: pe-meta-validator
    send: true
  - label: "Apply complex improvements"
    agent: pe-con-builder
    send: true
argument-hint: '<file-path> [--mode plan|apply] [--dim <group|D#|full>] [--deps none|direct|full|<N>] [--scope <type>] [--skip research|external]'
version: "2.2.0"
last_updated: "2026-05-31"
goal: "Ensure a PE-for-PE context file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Dimension-scoped review", "Construction invariant verification (6 properties)", "Construction-quality gate (6 properties — vision v14 R6)", "Consumer adherence spot-check", "Dependency traversal (--deps none|direct|full)", "Context quality lifecycle mode", "Source-mode handling (authoritative/user-augmented/report-only)"]
  excludes: ["Domain context files"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-context-design (applicability-scoped)"
  - "Default mode: apply — implements non-breaking improvements autonomously; proposes breaking changes for human confirmation. Use `--mode plan` to opt into assess-only output (findings report without changes)"
  - "Risk classification determines execution, not command identity — low-risk findings are applied without gating"
  - "Write tools (`replace_string_in_file`, `create_file`) are active by default (`--mode apply`). Suppressed ONLY when `--mode plan` is explicitly specified OR when the finding is classified as breaking"
  - "MUST check construction invariants regardless of --dim scope"
  - "MUST run the construction-quality gate (6 properties: frontmatter completeness, reference integrity, anchor stability, scope statement parity, boundaries actionability, rationale presence) before any apply path — block apply on ANY failure"
  - "MUST report consumer count and adherence sampling"
  - "MUST enforce lifecycle stage order when --dim context-full is selected"
  - "MUST NOT run per-artifact update outputs before structure decision outputs"
rationales:
  - "Context files are the foundation — invariant checks catch systemic issues early"
  - "Consumer adherence sampling validates that guidance is actually followed"
  - "Construction-quality gate (R6) prevents apply paths from running on artifacts whose surface contract is broken (missing frontmatter, dead references, drifted anchors, scope-vs-boundaries mismatch, rationale-less rules) — failures here mean downstream consumers cannot rely on the artifact, so apply MUST block"
---

# Context File Review

> **v15.4 alignment.** This prompt honors the vision v15.4 **`apply = plan + execute`** contract: every `--mode apply` run first materializes/reconciles a plan, then executes it; `--mode plan` materializes the same plan and stops (see § Plan output contract and [pe-meta-plan-file-contract.md](../../prompt-snippets/pe-meta-plan-file-contract.md)). The eighth canonical parameter **`--plan-file`** sets plan location/identity only; the **fresh / reconcile / trust** execution modes follow from (baseline-available? × research-runs?), and the § Iteration budget checkpoint (see [pe-meta-iteration-budget.md](../../prompt-snippets/pe-meta-iteration-budget.md)) emits a plan with a `trust`-mode resume when a run hits the per-cycle change cap. The first-line `Resolved invocation:` log echoes `plan-file=<path-or-none>` and `spillover=<path-or-none>` markers.

## Phase 0a CF-05 + Phase 0b — Invocation gates

This prompt enforces the **Phase 0a CF-05 artifact-type/path consistency check** AND the **Phase 0b domain coherence gate** defined in [`04.05-pe-meta-invocation-gates.md`](../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) (upstream authority: vision v15 § Domain detection, § Pipeline phases).

**Locally true for this prompt:**

- **CF-05 expected root.** Any resolved target path (positional `<file-path>`, `--scope`, or design output target) MUST resolve under `.copilot/context/`. Paths outside this root are REJECTED before Phase 0b runs; the rejection message MUST suggest the canonical replacement prompt name from the SoT § Per-prompt-class applicability matrix.
- **Phase 0b scope.** Resolved file set = the target path (+ closure under `--deps full` when this prompt's argument-hint exposes `--deps`); degenerate single-file scope is single-domain by construction.
- **Algorithm.** 3-tier metadata-first per the SoT: Tier 1 = each in-scope file's declared `domain:` frontmatter; Tier 2 = optional `pe-domain-map.yaml`; Tier 3 = `unknown`. The seed path does NOT constrain consumer domains when `--deps full` traverses the closure.
- **Gate timing.** Runs BEFORE delegating to handoffs declared in this prompt's frontmatter.
- **Consent tokens.** `bundle=accept` is recognized AND propagated when delegating to the orchestrator so it does not re-prompt; `--skip domain-coherence` is REJECTED with CF-05.
- **When delegated from an orchestrator.** Phase 0a CF-05 is verified by the dispatcher and Phase 0b has already run on the single-domain resolved scope — this section's gate is a no-op in that path.

## Process
1. Parse `--dim`, `--deps`, `--scope`, and `--skip` flags
2. Resolve review mode:
  - Standard mode: any `--dim` except lifecycle groups
  - Lifecycle mode: `--dim context-full`
  - Lifecycle health mode: `--dim context-health`
3. Load checklist from `05.08-pe-meta-type-checklists.md` → context section
4. Run construction invariant checks (non-redundancy, non-contradiction, non-ambiguity, testability, completeness, layer-correctness)
4a. Run construction-quality gate — the 6 properties below MUST all pass before any `--mode apply` write tool is invoked. Failure of ANY property blocks apply for the affected file and downgrades the finding to a report (caller may re-run after the surface contract is repaired):

  | # | Property | Check |
  |---|---|---|
  | 1 | Frontmatter completeness | All required keys present (`description`, `applyTo`/`agent`, `version`, `last_updated`, `goal`, `scope.covers`, `scope.excludes`, `boundaries`, `rationales` per artifact-type schema) and non-empty |
  | 2 | Reference integrity | All `#file:`, `.copilot/`, `.github/`, and template paths resolve to existing files; no broken anchors inside referenced files |
  | 3 | Anchor stability | Heading anchors used as link targets are unique within the file and have not drifted since the last referenced revision |
  | 4 | Scope statement parity | Every `boundaries[]` rule maps to a `scope.covers[]` or `scope.excludes[]` entry, and vice versa — no orphan boundaries, no scope items without enforcement |
  | 5 | Boundaries actionability | Each `boundaries[]` entry is testable (contains MUST/MUST NOT/SHOULD and a concrete subject) — no aspirational statements |
  | 6 | Rationale presence | `rationales[]` has at least one entry justifying each MUST-class boundary; no rule without a reason |

5. Run selected dimensions via `@pe-meta-validator`
6. If `--deps full`: run full dependency-aware review (bounded recursion, default depth 2, scope-filtered), sample consumers, and check adherence to this file's rules
7. If `--deps direct`: run first-level-only dependency checks (scope-filtered), sample direct consumers, and check adherence
8. Generate dimension report with severity-ranked findings (construction-quality gate failures listed FIRST as `gate-blocker`)

## Lifecycle mode behavior

When `--dim context-full` is selected, follow strict stage order:

1. Stage 0: source intake and validation
  - Source mode `authoritative-only`: use curated authoritative sources
  - Source mode `authoritative-plus-user-provided`: include user-provided sources with same trust checks
  - If source confidence is below threshold: set gate to `report-only`
2. Stage 1: context-set impact assessment
  - Produce impacted dimensions and claim-to-source evidence map
3. Stage 2: structure decision
  - Produce `no-change|split|merge|create|retire|remap` decision with risk level
4. Stage 3: per-artifact update readiness report (read-only in plan mode)
  - Emit structured integration gate: `apply-autonomously|require-approval|report-only`

Required output contract in lifecycle mode:
- `stage_0_source_ledger`
- `stage_1_impact_packet`
- `stage_2_structure_decision`
- `stage_3_integration_gate`

Lifecycle health mode (`--dim context-health`) runs lightweight checks and MAY skip Stage 2 unless structural risk is detected.


## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. Default mode is `--mode apply` — assess and implement non-breaking improvements autonomously. Use `--mode plan` to opt into assessment-only output.
3. `--deps` controls dependency traversal: `none` (per-artifact only), `direct` (first-level deps), `full` (bounded recursive). Default: `none`.
4. `--scope` filters which dependency types to focus on during `--deps` traversal (e.g., `--scope context` focuses on context file dependencies only). When omitted, traverse all dependency types.
5. `--skip research|external` suppresses external source fetching during review.
6. Guidance-first behavior is handled through `/pe-meta-adherence`.
7. When `--mode apply` is active and findings require multi-file changes, delegate to `@pe-con-builder`.

## Risk Classification

#file:.github/prompt-snippets/pe-meta-risk-classification.md

## Output contract (plan-file + spillover markers)

The report MUST open with a first-line `Resolved invocation:` log echoing the `plan-file=` and `spillover=` markers:

```text
Resolved invocation: --mode=<plan|apply> … | plan-file=<path-or-none> | spillover=<path-or-none>
```

- **`--mode plan` (assessment-only):** emit an actionable plan file at the canonical plan-mode path per [pe-meta-plan-file-contract.md](../../prompt-snippets/pe-meta-plan-file-contract.md) and record `plan-file=<path>`. When `--mode apply`, record `plan-file=none`.
- **`--mode apply` overflow:** if the per-cycle change cap is hit with validated findings remaining, emit a spillover plan at `<run-folder>/<NN>-<kebab-name>-spillover.plan.md` per [pe-meta-iteration-budget.md](../../prompt-snippets/pe-meta-iteration-budget.md) and record `spillover=<path>`; otherwise record `spillover=none`.



