---
description: Instructions for creating and updating effective prompt files
applyTo: '.github/prompts/**/*.md'
---

# Prompt File Creation & Update Instructions

## Purpose
Prompt files are **reusable, plan-level workflows** for common development tasks. They define WHAT should be done and HOW to approach it, operating at the strategic/planning layer rather than implementation details.

## Context Engineering Principles

**📖 Complete guidance:** `.copilot/context/prompt-engineering/context-engineering-principles.md`

**Key principles** (see context file for full details):
1. **Narrow Scope** - One specific task per prompt
2. **Early Commands** - Critical instructions up front
3. **Imperative Language** - Direct, action-oriented instructions
4. **Three-Tier Boundaries** - Always Do / Ask First / Never Do
5. **Context Minimization** - Reference external files, don't embed
6. **Tool Scoping** - Only essential tools to prevent tool clash

## Tool Selection

**📖 Complete guidance:** `.copilot/context/prompt-engineering/tool-composition-guide.md`

**Tool/Agent Alignment:**
- `agent: plan` + read-only tools (read_file, grep_search, semantic_search)
- `agent: agent` + write tools (create_file, replace_string_in_file)
- **Never** mix `agent: plan` with write tools (validation fails)

**Tool scoping prevents**: Tool clash, distraction, context bloat

## Required YAML Frontmatter

```yaml
---
name: prompt-file-name
description: "One-sentence description"
agent: plan  # or: agent
model: claude-sonnet-4.5
tools:
  - read_file
  - grep_search
argument-hint: 'Expected input format'  # Optional
---
```

## Prompt Templates

**Use specialized templates** from `.github/templates/`:

1. **`prompt-simple-validation-template.md`** - Read-only validation with 7-day caching
2. **`prompt-implementation-template.md`** - File creation/modification workflows  
3. **`prompt-multi-agent-orchestration-template.md`** - Coordinates multiple specialized agents
4. **`prompt-analysis-only-template.md`** - Research and reporting

**To create new prompts:** Use `@prompt-create-orchestrator` which coordinates researcher → builder → validator agents.
## Repository-Specific Patterns

### Validation Caching (7-Day Rule)

**📖 Complete guidance:** `.copilot/context/prompt-engineering/validation-caching-pattern.md`

**Critical rules:**
- ❌ **NEVER modify top YAML** (Quarto metadata) from validation prompts
- ✅ **Update bottom metadata block only** (HTML comment at end of file)
- Check `last_run` timestamp before running validation
- Skip validation if `last_run < 7 days` AND content unchanged

**Dual YAML architecture:**
```yaml
# Top YAML (Quarto) - NEVER touch from prompts
---
title: "Article Title"
author: "Author"
date: "2025-12-06"
---

# Bottom YAML (Validation) - Update your section only
<!-- 
---
validations:
  grammar:
    status: "passed"
    last_run: "2025-12-06T10:30:00Z"
---
-->
```

## Naming Conventions

**Prompt files:**
- Location: `.github/prompts/`
- Format: `[task-name].prompt.md`
- Examples: `grammar-review.prompt.md`, `structure-validation.prompt.md`

**Template files:**
- Location: `.github/templates/`
- Format: `prompt-[type]-template.md`
- Examples: `prompt-simple-validation-template.md`, `prompt-implementation-template.md`

## Best Practices

1. **Start with template** - Use appropriate template from `.github/templates/`
2. **Reference context files** - Don't embed shared principles
3. **Narrow tool scope** - Only essential tools for the task
4. **Test execution** - Run on real repository content
5. **Iterate boundaries** - Tighten based on observed errors

## References

- [GitHub: How to write great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) - Best practices from 2,500+ repos
- [VS Code: Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization) - Official documentation
- [Microsoft: Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) - Comprehensive guide
- [OpenAI: Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering) - Foundational strategies
- `.github/copilot-instructions.md` - Repository-wide context and conventions
