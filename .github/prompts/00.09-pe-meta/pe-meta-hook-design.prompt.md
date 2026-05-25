---
name: pe-meta-hook-design
description: "Design a new PE-for-PE hook with JSON schema validation and trigger wiring"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "hook for post-save metadata validation"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE hook meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "JSON schema definition", "Trigger event selection", "Deterministic execution guarantee"]
  excludes: ["Domain hooks", "Updates (use /pe-meta-hook-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-hook-review (applicability-scoped)"
  - "MUST define valid JSON schema for hook configuration"
  - "MUST specify exact trigger event (lifecycle point)"
  - "MUST guarantee deterministic execution (no AI judgment in trigger)"
  - "MUST follow pe-hooks.instructions.md patterns"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Hook Design

## Process
1. Requirements gathering — which lifecycle event triggers this?
2. Research existing hooks for overlap
3. Load checklist from `05.08-pe-meta-type-checklists.md` → hook section
4. Define JSON schema and trigger wiring
5. Build via `@pe-meta-builder`
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
