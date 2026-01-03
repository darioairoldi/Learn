---
description: Instructions for creating and maintaining context files
applyTo: '.copilot/context/**/*.md'
---

# Context File Creation & Maintenance Instructions

## Purpose

Context files are **shared reference documents** that provide consolidated guidance for prompts, agents, and instruction files. They serve as the single source of truth for principles, patterns, and conventions used across multiple files.

**📖 Related guidance:**
- [prompts.instructions.md](../.github/instructions/prompts.instructions.md) - Prompt file creation
- [agents.instructions.md](../.github/instructions/agents.instructions.md) - Agent file creation

---

## Context File Principles

### 1. Single Source of Truth

**Principle**: Each concept MUST be documented in exactly one context file.

**Guidelines**:
- ❌ **DON'T** duplicate content across context files
- ❌ **DON'T** embed full principles in prompts/agents (reference instead)
- ✅ **DO** consolidate related concepts in one comprehensive file
- ✅ **DO** use cross-references between context files

### 2. Reference-Based Architecture

**Principle**: Prompts and agents MUST reference context files, not embed content.

**Pattern**:
```markdown
## Context Engineering Principles

**📖 Complete guidance:** [.copilot/context/prompt-engineering/context-engineering-principles.md]

**Key principles** (see context file for full details):
1. Narrow Scope
2. Early Commands
3. Imperative Language
```

### 3. Hierarchical Organization

**Principle**: Context files MUST be organized by domain in subdirectories.

**Current Structure**:
```
.copilot/context/
├── prompt-engineering/
│   ├── context-engineering-principles.md   # Core principles
│   ├── tool-composition-guide.md           # Tool selection patterns
│   ├── validation-caching-pattern.md       # 7-day caching rules
│   └── handoffs-pattern.md                 # Multi-agent orchestration
├── workflows/
│   ├── article-creation-workflow.md
│   ├── review-workflow.md
│   └── series-planning-workflow.md
├── dual-yaml-helpers.md                    # Metadata parsing
├── style-guide.md                          # Writing standards
├── validation-criteria.md                  # Quality thresholds
└── domain-concepts.md                      # Core terminology
```

---

## Required Structure

### YAML Frontmatter (Optional but Recommended)

```yaml
---
title: "Context File Title"
version: "1.0.0"
last_updated: "2025-12-26"
referenced_by:
  - ".github/instructions/prompts.instructions.md"
  - ".github/prompts/*.prompt.md"
---
```

### Document Header

Every context file MUST begin with:

```markdown
# [Context File Title]

**Purpose**: [One-sentence description of what this file provides]

**Referenced by**: [List of file types or specific files that use this context]

---
```

### Core Sections

| Section | Required | Purpose |
|---------|----------|---------|
| **Purpose statement** | ✅ MUST | Clarify what this file provides |
| **Referenced by** | ✅ MUST | Track which files depend on this context |
| **Core content** | ✅ MUST | The actual guidance, principles, or patterns |
| **Anti-patterns** | SHOULD | Common mistakes and how to avoid them |
| **Checklist** | SHOULD | Quick validation of compliance |
| **References** | ✅ MUST | External sources and related context files |
| **Version History** | SHOULD | Track significant changes |

### Footer

Every context file MUST end with:

```markdown
---

## References

- **External**: [Links to official documentation]
- **Internal**: [Links to related context files]

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | YYYY-MM-DD | Initial version | Author |
```

---

## Content Guidelines

### Imperative Language

Context files MUST use imperative language:

| Strength | Phrase | Use Case |
|----------|--------|----------|
| **Absolute** | `MUST NOT`, `NEVER` | Hard boundaries |
| **Required** | `MUST`, `ALWAYS` | Core requirements |
| **Expected** | `SHOULD`, `PREFER` | Best practices |
| **Optional** | `MAY`, `CAN` | Suggestions |

### Code Examples

All code examples MUST be:
- Complete and executable
- From THIS repository (not generic examples)
- Annotated with explanations

**Pattern**:
```markdown
**Example from this repository**:
```yaml
# .github/prompts/grammar-review.prompt.md
---
name: grammar-review
description: "Grammar and spelling validation"
agent: plan
tools: ['read_file', 'grep_search']
---
```
```

### Cross-References

When referencing other context files:

```markdown
**📖 Related guidance:** [tool-composition-guide.md](tool-composition-guide.md)
```

When referenced FROM prompts/agents:

```markdown
**📖 Complete guidance:** [.copilot/context/prompt-engineering/context-engineering-principles.md](.copilot/context/prompt-engineering/context-engineering-principles.md)
```

---

## Naming Conventions

### File Names

- **Format**: `[concept-name].md` (lowercase, hyphenated)
- **Examples**: `context-engineering-principles.md`, `tool-composition-guide.md`
- **Avoid**: `ContextEngineeringPrinciples.md`, `context_engineering.md`

### Directory Names

- **Format**: `[domain-name]/` (lowercase, hyphenated)
- **Examples**: `prompt-engineering/`, `workflows/`

---

## Maintenance Guidelines

### When to Create New Context File

Create a new context file when:
- ✅ Same content appears in 3+ prompts/agents
- ✅ Concept is complex enough to need dedicated documentation
- ✅ Multiple files need to reference the same guidance

### When to Update Existing Context File

Update existing context files when:
- ✅ Best practices evolve from experience
- ✅ New patterns emerge from template usage
- ✅ External documentation (VS Code, GitHub) changes
- ✅ Anti-patterns are discovered

### Update Process

1. **Research**: Review current usage across prompts/agents
2. **Update**: Modify content with new guidance
3. **Verify references**: Ensure all `Referenced by` files still work
4. **Version history**: Add entry with date and changes
5. **Test**: Run a prompt that uses this context to verify

---

## Quality Checklist

Before finalizing a context file:

- [ ] Purpose statement is clear and specific
- [ ] `Referenced by` section lists actual dependent files
- [ ] Uses imperative language (MUST, WILL, NEVER)
- [ ] Code examples are from this repository
- [ ] Cross-references use correct relative paths
- [ ] No duplicated content from other context files
- [ ] References section includes external sources
- [ ] Version history is current

---

## Anti-Patterns

### ❌ Duplicating Content

**Problem**: Same guidance in multiple context files
```markdown
# In context-engineering-principles.md
## Tool Selection Guidelines
[detailed tool guidance]

# In tool-composition-guide.md  
## Tool Selection Guidelines
[same detailed tool guidance duplicated]
```

**Fix**: Single source + cross-reference
```markdown
# In context-engineering-principles.md
## Tool Selection
**📖 Complete guidance:** [tool-composition-guide.md](tool-composition-guide.md)
```

### ❌ Generic Examples

**Problem**: Examples from other projects, not this repository
```markdown
# Example from some-other-project
```yaml
tools: ['some_tool', 'another_tool']
```

**Fix**: Use examples from `.github/prompts/` or `.github/agents/`

### ❌ Missing References

**Problem**: No tracking of dependent files
```markdown
# Context Engineering Principles

[content without Referenced by section]
```

**Fix**: Always include `Referenced by` in header

---

## References

- **Prompt Instructions**: [.github/instructions/prompts.instructions.md](../../.github/instructions/prompts.instructions.md)
- **Agent Instructions**: [.github/instructions/agents.instructions.md](../../.github/instructions/agents.instructions.md)
- **VS Code Copilot Docs**: [Custom Instructions](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-26 | Initial version | System |
