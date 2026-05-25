---
name: pe-meta-template-design
description: "Design a new PE-for-PE template with schema compliance and placeholder documentation"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "template for agent file scaffolding"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE template meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "Schema compliance", "Placeholder documentation", "Consumer identification"]
  excludes: ["Domain templates", "Updates (use /pe-meta-template-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-template-review (applicability-scoped)"
  - "MUST document every placeholder with type and example value"
  - "MUST verify schema compliance with target artifact type"
  - "MUST identify consuming prompts/agents via 📖 references"
  - "MUST follow pe-templates.instructions.md patterns"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Template Design

## Process
1. Requirements gathering — which prompts/agents consume this template?
2. Research existing templates for overlap
3. Load checklist from `05.08-pe-meta-type-checklists.md` → template section
4. Define placeholders with types and examples
5. Build via `@pe-meta-builder`
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
