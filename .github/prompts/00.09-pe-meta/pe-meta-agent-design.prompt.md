---
name: pe-meta-agent-design
description: "Design a new PE-for-PE agent with tool alignment, boundary completeness, and handoff contract checks"
agent: agent
model: claude-opus-4.6
tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]
handoffs:
  - {label: "Research", agent: pe-meta-researcher, send: true}
  - {label: "Build", agent: pe-meta-builder, send: true}
  - {label: "Validate", agent: pe-meta-validator, send: true}
argument-hint: '<description> — e.g., "agent for batch validation orchestration"'
version: "1.0.1"
last_updated: "2026-05-22"
goal: "Ensure a PE-for-PE agent file meets the shared quality objective and scope intent (reliability, effectiveness, efficiency) with type-applicable requirements"
scope:
  covers: ["Shared quality objective and scope intent enforcement (applicability-scoped)", "Requirements gathering", "Tool/mode alignment verification", "Handoff contract definition", "Boundary completeness (≥5/2/3)"]
  excludes: ["Domain agents", "Updates (use /pe-meta-agent-create-update)"]
boundaries:
  - "MUST share the same quality objective and scope intent as /pe-meta-agent-review (applicability-scoped)"
  - "MUST verify tool alignment with agent mode (plan vs agent)"
  - "MUST define handoff contracts for every handoff target"
  - "MUST meet boundary minimums: ≥5 Always, ≥2 Ask, ≥3 Never"
  - "MUST reference pe-agents.instructions.md patterns"
rationales:
  - "Tool/mode misalignment is the #1 agent defect — caught at design time"
  - "Handoff contracts prevent data loss during agent transitions"
---

# Agent Design

## Process
1. Requirements gathering — use-case challenge (3-7 scenarios)
2. Research existing PE agents for patterns and gaps
3. Load checklist from `05.08-pe-meta-type-checklists.md` → agent section
4. Define: mode, tools, handoffs with data contracts, boundaries
5. Build via `@pe-meta-builder`
6. Validate via `@pe-meta-validator`

## Phase ordering and option behavior

1. Phase ordering: parse inputs first, execute the type-specific workflow second, then validate and report.
2. `--dim` restricts which quality dimensions to evaluate during design validation steps.
3. `--scope` filters which artifact types to focus on when composing dependencies.
4. Options `--mode`, `--deps`, and `--skip` are NOT supported for design commands — reject per `pe-meta-option-applicability-matrix.md`.
