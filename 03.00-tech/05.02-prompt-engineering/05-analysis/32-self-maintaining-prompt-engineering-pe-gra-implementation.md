---
title: "Self-maintaining PE: pe-gra implementation"
author: "Dario Airoldi"
date: "2026-05-01"
categories: [tech, prompt-engineering, github-copilot, agents, self-update]
description: "How pe-gra provides per-artifact operations for the PE system — 24 specialized agents organized as researcher/builder/validator triads for 8 artifact types."
---

# Self-maintaining PE: pe-gra implementation

pe-gra is the **per-artifact operations layer** of the self-maintaining prompt engineering system. It provides 24 specialized agents — organized as researcher/builder/validator triads — that handle the day-to-day work of creating, updating, and validating PE artifacts.

> **Series context:** This article covers the pe-gra tier. See the [system overview](30-self-maintaining-prompt-engineering-system-overview.md) for architecture and the [pe-meta implementation](31-self-maintaining-prompt-engineering-pe-meta-implementation.md) for strategic oversight.

## Table of contents

- [Goal and strategy](#goal-and-strategy)
- [The triad pattern](#the-triad-pattern)
- [The 8 artifact types](#the-8-artifact-types)
- [The 20 prompts](#the-20-prompts)
- [How to use pe-gra](#how-to-use-pe-gra)
- [Key implementation details](#key-implementation-details)
- [Design rationales](#design-rationales)
- [References](#references)

---

## Goal and strategy

pe-gra's goal is to ensure every PE artifact is structurally correct, follows conventions, and passes quality checks on first review. The strategy is **specialization by artifact type and role** — each agent knows one artifact type deeply and performs one role (research, build, or validate) rather than trying to do everything.

This decomposition solves three problems:
1. **Context window control** — each agent loads only the rules relevant to its artifact type, not the entire PE rule set
2. **Tool alignment** — researchers and validators are read-only (`plan` mode), builders have write access (`agent` mode)
3. **Quality gates** — the handoff from builder to validator is a mandatory quality gate, not an optional step

---

## The triad pattern

Every artifact type has 3 agents with clearly separated roles:

```
Researcher (plan)  ──►  Builder (agent)  ──►  Validator (plan)
  analyze gaps           create/update          check compliance
  discover patterns      apply changes          catch regressions
  recommend changes      follow specs           report issues
                              ▲                      │
                              └──── fix loop ────────┘
                              (max 2 round-trips)
```

| Role | Mode | Tools | What it does |
|---|---|---|---|
| **Researcher** | `plan` (read-only) | `read_file`, `grep_search`, `file_search`, `list_dir`, `semantic_search`, `fetch_webpage` | Analyzes the current state, discovers patterns in similar artifacts, identifies gaps, and produces a structured research report |
| **Builder** | `agent` (read+write) | `read_file`, `grep_search`, `file_search`, `create_file`, `replace_string_in_file`, `multi_replace_string_in_file`, + `list_dir` or `get_errors` | Creates or updates files following specifications, applies pre-change compatibility gates, runs post-change reconciliation |
| **Validator** | `plan` (read-only) | `read_file`, `grep_search`, `file_search`, `list_dir`, `semantic_search` | Validates structural compliance, checks tool alignment, verifies boundaries, produces fix reports |

### Handoff data contracts

Every transition has a formal contract:

| Direction | Template | Max tokens |
|---|---|---|
| Researcher → Builder | `output-researcher-report.template.md` | 2000 |
| Builder → Validator | `output-builder-handoff.template.md` | 1500 |
| Validator → Builder (fixes) | `output-validator-fixes.template.md` | 1000 |

The decreasing token budgets create a natural **information funnel** — each handoff distills the essential information and discards intermediate analysis.

---

## The 8 artifact types

| Type | Triad agents | What they manage |
|---|---|---|
| **Prompt** | prompt-researcher, prompt-builder, prompt-validator | `.prompt.md` files — slash commands, orchestrators |
| **Agent** | agent-researcher, agent-builder, agent-validator | `.agent.md` files — @mentionable specialists |
| **Context** | context-researcher, context-builder, context-validator | `.copilot/context/` files — rules, patterns, contracts |
| **Instruction** | instruction-researcher, instruction-builder, instruction-validator | `.instructions.md` files — auto-injected rules |
| **Skill** | skill-researcher, skill-builder, skill-validator | `SKILL.md` + resources — AI-discoverable capabilities |
| **Template** | template-researcher, template-builder, template-validator | `.template.md` files — reusable output formats |
| **Hook** | hook-researcher, hook-builder, hook-validator | `.json` files — lifecycle automation |
| **Prompt snippet** | prompt-snippet-researcher, prompt-snippet-builder, prompt-snippet-validator | `prompt-snippets/*.md` — reusable fragments |

---

## The 20 prompts

pe-gra prompts follow a consistent naming pattern: `/pe-gra-{type}-{workflow}`.

### Design prompts (7) — full multi-phase creation

| Prompt | Purpose |
|---|---|
| `/pe-gra-prompt-design` | Orchestrate prompt creation with research + build + validate |
| `/pe-gra-agent-design` | Orchestrate agent creation with use-case challenge |
| `/pe-gra-context-information-design` | Orchestrate context file creation with consumer analysis |
| `/pe-gra-instruction-file-design` | Orchestrate instruction file creation with applyTo analysis |
| `/pe-gra-skill-design` | Orchestrate skill creation with scope analysis |
| `/pe-gra-template-design` | Orchestrate template creation with audience analysis |
| `/pe-gra-hook-create-update` | Create or update hook configurations |

### Create/update prompts (6) — direct build without full research

| Prompt | Purpose |
|---|---|
| `/pe-gra-prompt-create-update` | Create or update a prompt file directly |
| `/pe-gra-agent-create-update` | Create or update an agent file directly |
| `/pe-gra-context-information-create-update` | Create or update a context file directly |
| `/pe-gra-instruction-file-create-update` | Create or update an instruction file directly |
| `/pe-gra-skill-create-update` | Create or update a skill directly |
| `/pe-gra-template-create-update` | Create or update a template directly |
| `/pe-gra-prompt-snippet-create-update` | Create or update a prompt snippet directly |

### Review prompts (7) — validation-only

| Prompt | Purpose |
|---|---|
| `/pe-gra-prompt-review` | Validate a prompt file |
| `/pe-gra-agent-review` | Validate an agent file |
| `/pe-gra-context-information-review` | Validate a context file |
| `/pe-gra-instruction-file-review` | Validate an instruction file |
| `/pe-gra-skill-review` | Validate a skill |
| `/pe-gra-template-review` | Validate a template |

---

## How to use pe-gra

### Create a new agent with full design workflow

```
/pe-gra-agent-design A researcher agent that analyzes Azure cost patterns
```

This triggers the 8-phase workflow: requirements gathering → use-case challenge → pattern research → structure definition → agent creation → dependency analysis → validation → issue resolution.

### Quick-update an existing file

```
/pe-gra-prompt-create-update .github/prompts/00.02-pe-granular/pe-gra-prompt-design.prompt.md
```

Skips the research phase — goes directly to builder with the existing file as input.

### Validate a file

```
/pe-gra-context-information-review .copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md
```

Runs the full validation checklist: YAML compliance, structural integrity, consumer dependency check, cross-reference resolution, token budget verification.

### Invoke an agent directly

```
@pe-gra-agent-validator validate .github/agents/00.02-pe-granular/pe-gra-hook-builder.agent.md
```

Bypasses the prompt orchestrator — useful when you know exactly which agent you need.

---

## Key implementation details

### Phase 0.5: Change impact analysis

All 8 validators include a **Phase 0.5** that classifies incoming changes before running full validation:

| Classification | Action | Rationale |
|---|---|---|
| **COSMETIC** | Skip consumer checks | Formatting can't break contracts |
| **STRUCTURAL** | Check consumers referencing modified sections | Section renames break heading references |
| **VOCABULARY** | Grep old term across all PE files | Term renames propagate silently |
| **BEHAVIORAL** | Check all consumers | Rule/boundary changes can invalidate assumptions |

Each validator has artifact-specific classification logic and consumer discovery strategies. Context-validator uses "Referenced by" sections (Risk Level 2). Instruction-validator expands `applyTo` globs (Risk Level 1). The other 6 use `grep_search` for the artifact name (Risk Level 3).

### Pre-change compatibility gate

All 8 builders apply a **3-tier compatibility gate** before any change:

| Outcome | Test | Action |
|---|---|---|
| **COMPATIBLE** | Change within declared scope/goal/boundaries | Proceed — body-only edit |
| **EXTENDING** | Change requires adding metadata entries | Proceed + add rationale |
| **CONTRADICTING** | Change requires removing/modifying metadata | **HALT** — present conflict to user |

If a `rationales:` entry explains WHY the contradicted item exists, the builder stops immediately — the prior decision was intentional.

### Builder↔validator loop cap

Builders hand off to validators for compliance checks. If the validator finds issues, it sends fix instructions back. The builder fixes and re-validates. This loop is capped at **max 2 round-trips**. If issues persist after 2 cycles, the builder escalates to the user with the full issue list.

### Tool-failure recovery

All agents inherit a standard recovery protocol from the production-readiness patterns:

| Failure | Recovery |
|---|---|
| `read_file`/`grep_search` error | Retry once with adjusted parameters, then stop |
| `replace_string_in_file` context mismatch | Re-read file (concurrent edit?), retry, then stop |
| `create_file` failure | Report with full path, stop |
| Tool timeout | Retry once, then stop |

### Slash-command reference integrity

Validators check that all `/name` references in body text resolve to existing prompt `name:` YAML fields. This was added after discovering 174 broken references that persisted across multiple review cycles — the original validators only checked `📖` references and markdown links, missing slash-commands entirely.

---

## Design rationales

### Why 24 agents instead of fewer?

Each artifact type has distinct rules: context files have token budgets and "Referenced by" sections; instructions have `applyTo` globs and collision risks; hooks have JSON schemas and security policies. A generic "PE validator" would need to load all rule sets for every invocation — exceeding token budgets and diluting attention.

The 3-per-type decomposition (researcher/builder/validator) further improves reliability: read-only agents can't accidentally write; builders can't skip validation.

### Why `multi_replace_string_in_file` in builders?

Builders routinely update YAML metadata, body content, and version history in a single operation. Without atomic multi-edit, they'd need sequential `replace_string_in_file` calls that risk partial writes if context changes between calls. All 8 builders carry 7 tools (the ceiling of the 3–7 tool range).

### Why Level 1.5 category references?

When context files are renamed or split, all references break. Category-based references (`agent-patterns` files) survive renames because the category ID is a stable semantic identifier — only the `STRUCTURE-README.md` mapping needs updating. This was validated by upgrading all 24 agents from Level 2 (filename) to Level 1.5 (category) references in a single batch.

### Why handoff contracts on all 22 agents (not just builders)?

Builders were the first to get contracts (Round 1). Researchers followed (they send data to builders). Validators were added last (Round 2) — closing an asymmetric gap where builders documented "I send to validator" but validators didn't document "I expect to receive X." Symmetric contracts prevent silent data loss when either side changes its output format.

### Why per-builder loop caps instead of a centralized rule?

The loop cap could live in the `agent-patterns` escalation protocol (centralized). Instead, it's embedded in each builder's handoff phase. This keeps agents self-contained — they don't depend on loading a shared pattern to know their loop limit. The trade-off is 8 lines of duplication, but each builder is independently correct.

---

## References

- **pe-gra agents:** `.github/agents/00.02-pe-granular/`
- **pe-gra prompts:** `.github/prompts/00.02-pe-granular/`
- **Output templates:** `.github/templates/00.00-prompt-engineering/output-*.template.md`
- **Agent shared patterns:** `agent-patterns` category in `.copilot/context/00.00-prompt-engineering/`
- **System overview:** [Building a self-maintaining PE system](30-self-maintaining-prompt-engineering-system-overview.md)
- **pe-meta implementation:** [Self-maintaining PE: pe-meta implementation](31-self-maintaining-prompt-engineering-pe-meta-implementation.md)
