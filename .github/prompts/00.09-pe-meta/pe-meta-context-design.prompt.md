---
name: pe-meta-context-design
description: "Design a new PE-for-PE context file with construction invariants, layer correctness, and non-redundancy checks"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - label: "Research"
    agent: pe-meta-researcher
    send: true
  - label: "Build"
    agent: pe-meta-builder
    send: true
  - label: "Validate"
    agent: pe-meta-validator
    send: true
argument-hint: '<description> — e.g., "context file for model routing patterns"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE context file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering with use-case challenge", "Pattern research from existing context files", "Construction with 6 guidance quality invariants", "Layer correctness and non-redundancy validation"]
  excludes: ["Domain context files (use /pe-con-design)", "Updates to existing files (use /pe-meta-context-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-context-review (applicability-scoped)"
  - "MUST apply 6 construction invariants: non-redundancy, non-contradiction, non-ambiguity, testability, completeness, layer-correctness"
  - "MUST verify file fits a STRUCTURE-README Functional Category"
  - "MUST use Level 1.5 category references"
  - "MUST meet exemplary quality bar from 05.06"
rationales:
  - "Context files are guidance producers — construction invariants ensure quality propagates to all consumers"
  - "Layer correctness prevents rule duplication across context hierarchy"
---

# Context File Design

## Process
1. Requirements gathering — use-case challenge (3-7 scenarios for who loads this and why)
2. Research existing context files for overlap (STRUCTURE-README categories)
3. Load type-specific checklist from `05.08-pe-meta-type-checklists.md` → context section
4. Determine Functional Category placement
5. Build via `@pe-meta-builder` with construction invariants enforced
6. Validate via `@pe-meta-validator` (structural + strategic)
7. Update STRUCTURE-README with new file entry

## Construction Invariants (Context-Specific)
- **Non-redundancy**: No rule duplicated from another context file at same or higher layer
- **Non-contradiction**: No rule conflicts with another context file
- **Non-ambiguity**: Every rule has single clear interpretation
- **Testability**: Each rule can be verified by checking consumer artifacts
- **Completeness**: Topic fully covered without gaps that force consumers to guess
- **Layer-correctness**: Rules at appropriate abstraction level for this file's position

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
