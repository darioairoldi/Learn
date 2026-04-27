---
title: "Artifact-type dispatch reference"
description: "Lookup table for consolidated PE agents — maps each artifact type to its instruction file, templates, validation rules, and context files"
version: "1.0.0"
last_updated: "2026-04-27"
audience: "pe-con-researcher, pe-con-builder, pe-con-validator ONLY — granular and meta agents do NOT use this"
---

# Artifact-type dispatch reference

> **Audience**: Consolidated PE agents (`pe-con-*`) only. Granular agents (`pe-gra-*`) have artifact type hardcoded — they do NOT load this file.
>
> **Context file references**: Per R-S5-chain-alignment, the default reference is the folder `.copilot/context/00.00-prompt-engineering/`. The "Key context files" column lists **priority files to load first** for each artifact type — not the only files available. If a listed file is missing or renamed, fall back to scanning the folder.

## Dispatch table

| Artifact type | Instruction file | Primary template | Key context files (load first) | Type-specific validation |
|---|---|---|---|---|
| **Agent** | `pe-agents.instructions.md` | `agent.template.md` | `02.04-agent-shared-patterns.md`, `01.04-tool-composition-guide.md` | Tool count 3–7, mode alignment, handoff resolution, boundary completeness ≥3/1/2 |
| **Prompt** | `pe-prompts.instructions.md` | `prompt.template.md` | `02.03-orchestrator-design-patterns.md`, `01.04-tool-composition-guide.md` | Gate checks, tool scope, agent references resolve |
| **Context file** | `pe-context-files.instructions.md` | — | `01.01-context-engineering-principles.md` | ≤2,500 tokens, single source of truth, no circular deps |
| **Instruction file** | `pe-instruction-files.instructions.md` | `instructions.template.md` | `01.07-critical-rules-priority-matrix.md` | applyTo conflict-free, ≤1,500 tokens, only testable rules |
| **Skill** | `pe-skills.instructions.md` | `skill.template.md` | `03.01-progressive-disclosure-pattern.md` | Description ≤1024 chars, Level 1 <100 tokens, required sections |
| **Template** | `pe-templates.instructions.md` | — | `03.07-template-authoring-patterns.md` | ≤100 lines, .template.md extension, category prefix |
| **Hook** | `pe-hooks.instructions.md` | — | `03.03-agent-hooks-reference.md` | Valid JSON, supported lifecycle event, companion script exists |
| **Prompt snippet** | `pe-prompt-snippets.instructions.md` | — | — | ≤500 words, no YAML frontmatter, self-contained |

## How consolidated agents use this table

1. **Determine artifact type** from user request or handoff context
2. **`read_file`** this dispatch table (MANDATORY Phase 1 step)
3. **Load the instruction file** for that type (`read_file`)
4. **Load the primary template** if creating/updating (`read_file`)
5. **Load key context files** if the artifact interacts with that domain
6. **Apply type-specific validation** rules during pre-save checks
