---
description: Instructions for creating and maintaining context files
applyTo: '.copilot/context/**/*.md'
---

# Context File Creation & Maintenance Instructions

## Purpose

Context files are **shared reference documents** that provide consolidated guidance for prompts, agents, and instruction files. They serve as the single source of truth for principles, patterns, and conventions used across multiple files.

**Automatic discovery**: Context files in `.copilot/context/` are **automatically indexed by semantic search**, allowing Copilot to discover relevant context without explicit `#file:` references. This makes them the preferred location for reusable knowledge.

### Context Files vs Instructions vs Snippets

| Aspect | Context files | Instruction files | Prompt snippets |
|--------|--------------|-------------------|----------------|
| **Location** | `.copilot/context/` | `.github/instructions/` | Inline `#file:` |
| **Discovery** | Semantic search (automatic) | `applyTo` glob (automatic) | Manual reference |
| **Scope** | Cross-cutting knowledge | File-type-specific rules | Single prompt |
| **Size limit** | ~2,500 tokens | ~1,500 tokens | No formal limit |
| **When to use** | Shared patterns, principles | Editing rules per filetype | One-off context |

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

**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)

**Key principles** (see context folder for full details):
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
├── 02-dual-yaml-metadata.md                    # Metadata parsing
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

When referenced FROM prompts/agents (prefer group references):

```markdown
**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)
```

Use individual file references only when linking to a specific section:

```markdown
**See the 7-day rule:** [validation-caching-pattern.md](.copilot/context/00.00-prompt-engineering/05-validation-caching-pattern.md)
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

**📖 Context files:**
- [08-context-window-management.md](.copilot/context/00.00-prompt-engineering/08-context-window-management.md) - Context rot prevention and information flow patterns
- [13-file-type-decision-guide.md](.copilot/context/00.00-prompt-engineering/13-file-type-decision-guide.md) - When to use context files vs instructions vs prompts

---

## Content Length Guidelines

Context files are referenced on-demand (not auto-loaded like instructions), so they can be longer but must remain focused:

### Recommended Sizes by Type

| Context File Type | Token Budget | Word Count | Line Count | Rationale |
|------------------|-------------|------------|------------|----------|
| **Core Principles** | 800-1,200 tokens | ~600-900 words | ~120-180 lines | Referenced frequently, should stay concise |
| **Pattern Libraries** | 1,500-2,500 tokens | ~1,100-1,875 words | ~220-375 lines | Multiple patterns need examples |
| **Workflow Documentation** | 1,000-2,000 tokens | ~750-1,500 words | ~150-300 lines | Step-by-step procedures require detail |
| **Terminology/Glossary** | 500-1,000 tokens | ~375-750 words | ~75-150 lines | Quick reference, concise definitions |

**Maximum Recommended**: 3,000 tokens (~2,250 words, ~450 lines)

### Conversion Reference

| Metric | Approximate Conversion | Example |
|--------|----------------------|----------|
| **Tokens → Words** | Divide by 1.33 | 1,000 tokens = ~750 words |
| **Tokens → Lines** | Divide by 6-8 (avg 6) | 1,000 tokens = ~165 lines |
| **Tokens → Characters** | Multiply by 4 | 1,000 tokens = ~4,000 chars |
| **Words → Tokens** | Multiply by 1.33 | 750 words = ~1,000 tokens |

### When Context Files Are Too Large

**Warning signs:**
- File exceeds 2,500 tokens (1,875 words, 400+ lines)
- Multiple unrelated topics in one file
- Prompts/agents only reference specific sections
- File updates frequently affect unrelated consumers

**Refactoring strategies:**

1. **Split by Topic**: One principle per file
   ```
   Before: ai-guidelines.md (3,500 tokens)
   After:  prompt-principles.md (1,200 tokens)
           agent-principles.md (1,000 tokens)
           skill-principles.md (800 tokens)
   ```

2. **Extract Examples**: Move detailed examples to separate files
   ```
   core-pattern.md (800 tokens)           # Principles only
   core-pattern-examples.md (1,500 tokens) # Detailed examples
   ```

3. **Layer Specificity**: General context + specific sub-context files
   ```
   validation-guide.md (800 tokens)        # Core principles
   validation-examples/ (separate files)   # Detailed examples per type
   validation-workflows.md (1,200 tokens)  # Process documentation
   ```

4. **Create Index File**: Master context file with references
   ```markdown
   # Validation Context Index
   
   ## Core Principles
   **📖 See:** [validation-principles.md](./validation-principles.md)
   
   ## Examples by Type
   - Grammar: [validation-examples/grammar.md](./validation-examples/grammar.md)
   - Structure: [validation-examples/structure.md](./validation-examples/structure.md)
   ```

### Performance Impact

**Context file loading:**
- Loaded only when explicitly referenced by prompts/agents
- Multiple files can be referenced in single prompt
- Consider cumulative impact when designing reference chains

**Example Cumulative Impact:**
```
Prompt file: 800 tokens
+ References context-engineering-principles.md: 1,000 tokens
+ References tool-composition-guide.md: 1,200 tokens
+ References validation-caching-pattern.md: 800 tokens
= 3,800 tokens from context files alone
```

**Best Practices:**
- Reference only needed context files (not entire libraries)
- Use specific sections when possible
- Consider creating focused sub-context files for common reference patterns
- Balance detail with token efficiency

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.1.0 | 2026-01-14 | Added Content Length Guidelines | System |
| 1.0.0 | 2025-12-26 | Initial version | System |
