---
name: pe-meta-template-create-update
description: "Create or update a PE-for-PE template with schema compliance and placeholder validation"
agent: agent
model: claude-opus-4.6
tools: [read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<file-path-or-description> [--dim <group>]'
version: "1.0.0"
last_updated: "2026-05-15"
goal: "Create or update PE-for-PE templates with schema compliance and placeholder documentation"
scope:
  covers: ["Direct creation", "Updates with placeholder preservation", "Schema compliance enforcement"]
  excludes: ["Design (use /pe-meta-template-design)", "Domain templates"]
boundaries:
  - "MUST document all placeholders"
  - "MUST verify schema matches target artifact type"
  - "MUST verify consuming prompts still work after change"
rationales:
  - "Type-specific PE-meta workflow improves reliability and maintainability"
  - "Explicit orchestration metadata supports deterministic validation and safer automation"
---

# Template Create/Update

## Process
1. Determine mode: CREATE or UPDATE
2. **UPDATE**: Pre-change guard — verify placeholder documentation preserved
3. Load checklist from `05.08-pe-meta-type-checklists.md` → template section
4. Build via `@pe-meta-builder`
5. Validate via `@pe-meta-validator` (scoped by `--dim`)
6. Post-change: verify consumer compatibility, version bump

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during pre-change review steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for create-update commands — reject per `pe-meta-option-applicability-matrix.md`.
