---
name: pe-meta-snippet-design
description: "Design a new PE-for-PE prompt snippet with reusability focus and naming convention compliance"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "snippet for dimension group definitions"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE prompt snippet meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "Reusability optimization", "Naming convention compliance", "Consumer identification"]
  excludes: ["Domain snippets", "Updates (use /pe-meta-snippet-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-snippet-review (applicability-scoped)"
  - "MUST be reusable across ≥2 consumers (otherwise inline the content)"
  - "MUST follow naming convention from pe-prompt-snippets.instructions.md"
  - "MUST be self-contained (no external dependencies)"
  - "MUST identify all intended consumers"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Snippet Design

## Process
1. Requirements gathering — which prompts/agents include this via #file:?
2. Research existing snippets for overlap
3. Load checklist from `05.08-pe-meta-type-checklists.md` → snippet section
4. Verify ≥2 consumers justify extraction
5. Build via `@pe-meta-builder`
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
