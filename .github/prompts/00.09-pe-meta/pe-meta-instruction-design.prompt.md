---
name: pe-meta-instruction-design
description: "Design a new PE-for-PE instruction file with applyTo pattern and minimization (R-S8) focus"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "instruction file for hook JSON schema validation"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE instruction file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "applyTo pattern design", "Minimization (R-S8) enforcement", "Rule density optimization"]
  excludes: ["Domain instructions", "Updates (use /pe-meta-instruction-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-instruction-review (applicability-scoped)"
  - "MUST define precise applyTo glob pattern (no over-broad wildcards)"
  - "MUST minimize token footprint (R-S8: rules only, no examples unless essential)"
  - "MUST verify no overlap with existing instruction files"
  - "MUST include description field for IDE filtering"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Instruction Design

## Process
1. Requirements gathering — use-case challenge (which files trigger this?)
2. Research existing instructions for overlap in applyTo coverage
3. Load checklist from `05.08-pe-meta-type-checklists.md` → instruction section
4. Design applyTo pattern — test against workspace files
5. Build via `@pe-meta-builder` with minimization focus
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
