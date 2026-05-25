---
name: pe-meta-agent-review
description: "Review a PE-for-PE agent across selected dimensions with tool alignment and handoff validation"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, replace_string_in_file, create_file]
handoffs:
  - {label: "Validate", agent: pe-meta-validator, send: true}
  - {label: "Apply complex improvements", agent: pe-con-builder, send: true}
argument-hint: '<file-path> [--mode plan|apply] [--dim <group|D#|full>] [--deps none|direct|full|<N>] [--scope <type>] [--skip research|external]'
version: "1.0.2"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE agent file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Dimension-scoped review", "Tool/mode alignment check", "Handoff target resolution", "Boundary completeness audit"]
  excludes: ["Domain agents"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-agent-design (applicability-scoped)"
  - "Default mode: apply — implements non-breaking improvements autonomously; proposes breaking changes for human confirmation. Use `--mode plan` to opt into assess-only output (findings report without changes)"
  - "Risk classification determines execution, not command identity — low-risk findings are applied without gating"
  - "Write tools (`replace_string_in_file`, `create_file`) are active by default (`--mode apply`). Suppressed ONLY when `--mode plan` is explicitly specified OR when the finding is classified as breaking"
  - "MUST always check tool alignment regardless of --dim"
  - "MUST verify handoff targets exist"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Agent Review

## Process
1. Parse `--dim`, `--deps`, `--scope`, and `--skip` flags
2. Load checklist from `05.08-pe-meta-type-checklists.md` → agent section
3. Check tool/mode alignment (plan mode should not have write tools)
4. Check handoff targets resolve to existing agents
5. Run selected dimensions via `@pe-meta-validator`
6. If `--deps full`: run full dependency-aware review (bounded recursion, default depth 2, scope-filtered), trace handoff chain, and validate data contracts
7. If `--deps direct`: run first-level-only dependency checks (scope-filtered), trace direct handoffs, and validate direct contracts
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



