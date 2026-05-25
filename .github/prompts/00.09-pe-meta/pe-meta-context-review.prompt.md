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
version: "1.1.3"
last_updated: "2026-05-25"
goal: "Ensure a PE-for-PE context file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Dimension-scoped review", "Construction invariant verification (6 properties)", "Consumer adherence spot-check", "Dependency traversal (--deps none|direct|full)", "Context quality lifecycle mode", "Source-mode handling (authoritative/user-augmented/report-only)"]
  excludes: ["Domain context files"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-context-design (applicability-scoped)"
  - "Default mode: apply — implements non-breaking improvements autonomously; proposes breaking changes for human confirmation. Use `--mode plan` to opt into assess-only output (findings report without changes)"
  - "Risk classification determines execution, not command identity — low-risk findings are applied without gating"
  - "Write tools (`replace_string_in_file`, `create_file`) are active by default (`--mode apply`). Suppressed ONLY when `--mode plan` is explicitly specified OR when the finding is classified as breaking"
  - "MUST check construction invariants regardless of --dim scope"
  - "MUST report consumer count and adherence sampling"
  - "MUST enforce lifecycle stage order when --dim context-full is selected"
  - "MUST NOT run per-artifact update outputs before structure decision outputs"
rationales:
  - "Context files are the foundation — invariant checks catch systemic issues early"
  - "Consumer adherence sampling validates that guidance is actually followed"
---

# Context File Review

## Process
1. Parse `--dim`, `--deps`, `--scope`, and `--skip` flags
2. Resolve review mode:
  - Standard mode: any `--dim` except lifecycle groups
  - Lifecycle mode: `--dim context-full`
  - Lifecycle health mode: `--dim context-health`
3. Load checklist from `05.08-pe-meta-type-checklists.md` → context section
4. Run construction invariant checks (non-redundancy, non-contradiction, non-ambiguity, testability, completeness, layer-correctness)
5. Run selected dimensions via `@pe-meta-validator`
6. If `--deps full`: run full dependency-aware review (bounded recursion, default depth 2, scope-filtered), sample consumers, and check adherence to this file's rules
7. If `--deps direct`: run first-level-only dependency checks (scope-filtered), sample direct consumers, and check adherence
8. Generate dimension report with severity-ranked findings

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



