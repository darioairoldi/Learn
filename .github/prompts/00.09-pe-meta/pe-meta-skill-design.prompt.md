---
name: pe-meta-skill-design
description: "Design a new PE-for-PE skill with progressive disclosure structure and description accuracy"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "skill for PE dimension validation"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE skill meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "Description accuracy for AI discovery", "Progressive disclosure structure", "Context autonomy routing"]
  excludes: ["Domain skills", "Updates (use /pe-meta-skill-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-skill-review (applicability-scoped)"
  - "MUST write description for AI-discoverability (trigger phrases)"
  - "MUST structure content with progressive disclosure (summary → detail)"
  - "MUST include USE FOR / DO NOT USE FOR in description"
  - "MUST be self-contained (context autonomy)"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Skill Design

## Process
1. Requirements gathering — what AI agent reads this and when?
2. Research existing PE skills for gap/overlap
3. Load checklist from `05.08-pe-meta-type-checklists.md` → skill section
4. Design description with trigger phrases for AI discovery
5. Build via `@pe-meta-builder` with progressive disclosure
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
