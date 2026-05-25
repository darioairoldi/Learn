---
name: pe-meta-context-create-update
description: "Create or update a PE-for-PE context file with pre-change guards, construction invariants, and post-change reconciliation"
agent: agent
model: claude-opus-4.6
tools: [read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - label: "Build"
    agent: pe-meta-builder
    send: true
  - label: "Validate"
    agent: pe-meta-validator
    send: true
argument-hint: '<file-path-or-description> [--dim <group>]'
version: "1.0.0"
last_updated: "2026-05-15"
goal: "Create or update PE-for-PE context files with construction invariant enforcement and post-change STRUCTURE-README reconciliation"
scope:
  covers: ["Direct creation with construction invariants", "Updates with pre-change compatibility gate", "Post-change reconciliation (STRUCTURE-README, version, category)"]
  excludes: ["Requirements research (use /pe-meta-context-design)", "Domain context files"]
boundaries:
  - "MUST enforce 6 construction invariants on every change"
  - "MUST run pre-change guard for updates (check goal/scope/boundary preservation)"
  - "MUST update STRUCTURE-README after creation"
  - "MUST bump version and last_updated after every change"
rationales:
  - "Construction invariants prevent quality degradation in guidance files"
  - "STRUCTURE-README reconciliation keeps the file index accurate"
---

# Context File Create/Update

## Process
1. Determine mode: CREATE (file absent) or UPDATE (file exists)
2. **UPDATE**: Pre-change guard — read metadata, verify proposed change doesn't contradict goal/scope/boundaries
3. Load checklist from `05.08-pe-meta-type-checklists.md` → context section
4. Build via `@pe-meta-builder` with 6 construction invariants enforced
5. Validate via `@pe-meta-validator` (scoped by `--dim` if provided)
6. Post-change reconciliation: version bump, STRUCTURE-README update, category assignment

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during pre-change review steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for create-update commands — reject per `pe-meta-option-applicability-matrix.md`.
