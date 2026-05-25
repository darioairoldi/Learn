---
name: pe-meta-skill-review
description: "Review a PE-for-PE skill across selected dimensions with description accuracy and progressive disclosure checks"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, replace_string_in_file, create_file]
handoffs:
  - {label: "Validate", agent: pe-meta-validator, send: true}
  - {label: "Apply complex improvements", agent: pe-con-builder, send: true}
argument-hint: '<file-path> [--mode plan|apply] [--dim <group|D#|full>] [--deps none|direct|full|<N>] [--scope <type>] [--skip research|external]'
version: "1.0.2"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE skill meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Dimension-scoped review", "Description accuracy audit", "Progressive disclosure check", "Self-containment verification"]
  excludes: ["Domain skills"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-skill-design (applicability-scoped)"
  - "Default mode: apply — implements non-breaking improvements autonomously; proposes breaking changes for human confirmation. Use `--mode plan` to opt into assess-only output (findings report without changes)"
  - "Risk classification determines execution, not command identity — low-risk findings are applied without gating"
  - "Write tools (`replace_string_in_file`, `create_file`) are active by default (`--mode apply`). Suppressed ONLY when `--mode plan` is explicitly specified OR when the finding is classified as breaking"
  - "MUST always check description accuracy and progressive disclosure"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Skill Review

## Process
1. Parse `--dim`, `--deps`, `--scope`, and `--skip` flags
2. Load checklist from `05.08-pe-meta-type-checklists.md` → skill section
3. Check description includes trigger phrases, USE FOR, DO NOT USE FOR
4. Verify progressive disclosure (summary before detail)
5. Run selected dimensions via `@pe-meta-validator`
6. If `--deps full`: run full dependency-aware review (bounded recursion, default depth 2, scope-filtered) and verify context autonomy (no dangling refs)
7. If `--deps direct`: run first-level-only dependency checks (scope-filtered) and verify direct context autonomy risks
8. Generate severity-ranked report


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



