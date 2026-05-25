---
name: pe-meta-prompt-design
description: "Design a new PE-for-PE prompt with argument-hint, model selection, and phase structure"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "prompt for batch dimension validation"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE prompt meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "Argument-hint design", "Model selection rationale", "Phase structure definition"]
  excludes: ["Domain prompts", "Updates (use /pe-meta-prompt-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-prompt-review (applicability-scoped)"
  - "MUST include argument-hint with concrete example"
  - "MUST justify model selection in YAML or rationales"
  - "MUST structure body as numbered phases"
  - "MUST include handoffs to relevant agents"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Prompt Design

## Process
1. Requirements gathering — use-case challenge (3-7 invocation scenarios)
2. Research existing PE prompts for patterns
3. Load checklist from `05.08-pe-meta-type-checklists.md` → prompt section
4. Define: argument-hint, model, mode, phases, handoffs
5. Build via `@pe-meta-builder`
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
