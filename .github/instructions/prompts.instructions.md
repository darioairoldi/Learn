---
description: Instructions for creating and updating effective prompt files
applyTo: '.github/prompts/**/*.md'
---

# Prompt File Creation Instructions

## Purpose
Prompt files are **reusable, plan-level workflows** for common development tasks. They define WHAT should be done and HOW to approach it, operating at the strategic/planning layer rather than implementation details.

## Context Engineering Principles

**📖 Complete guidance:** [.copilot/context/00.00 prompt-engineering/](.copilot/context/00.00%20prompt-engineering/)

**Key principles** (see context folder for full details):
1. **Narrow Scope** - One specific task per prompt
2. **Early Commands** - Critical instructions up front
3. **Imperative Language** - Direct, action-oriented instructions
4. **Three-Tier Boundaries** - Always Do / Ask First / Never Do
5. **Context Minimization** - Reference external files, don't embed
6. **Tool Scoping** - Only essential tools to prevent tool clash
7. **Explicit Uncertainty Management** - Professional "I don't know" patterns
8. **Template Externalization** - Externalize verbose output formats, summaries, and layouts to reusable templates for token efficiency and flexibility

## Template-First Authoring ⭐ (CRITICAL)

**ALWAYS PREFER template files** over verbose embedded descriptions in prompts. This is a **mandatory principle** that reduces token usage, improves maintainability, and enables reuse across prompts.

**🚨 RULE:** Any inline content block **exceeding 10 lines** MUST be externalized to a template file.

### When to Use Templates

| Content Type | ❌ NEVER Embed | ✅ ALWAYS Use Template |
|--------------|----------------|------------------------|
| **Output formats** | Multi-line output examples inline (>10 lines) | `output-*.template.md` |
| **Input schemas** | Detailed input field descriptions | `input-*.template.md` |
| **Document structures** | Section-by-section layout specs | `*-structure.template.md` |
| **Validation checklists** | Long inline checklists (>5 items) | Separate instruction file or template |
| **Multi-step workflows** | Detailed phase descriptions (>20 lines) | Phase templates or context files |
| **Process step outputs** | Verbose "Output:" format blocks | `output-{prompt-name}-phases.template.md` |
| **Markdown examples** | Full document structure examples | Dedicated structure templates |
| **Quality criteria** | Detailed scoring rubrics | `criteria-*.template.md` or instruction file |

### Template Reference Pattern

**Instead of:**
```markdown
## Output Format
### Section 1: Summary
- Title (H1)
- Overview paragraph
- Key points as bullet list
[...50+ lines of format specification...]
```

**Use:**
```markdown
## Output Format

**Use template:** `.github/templates/output-summary.template.md`
```

### Inline Content Anti-Patterns (NEVER DO)

❌ **Verbose Phase Outputs** - Don't embed multi-line "Output:" blocks for each phase
```markdown
## Phase 1: Requirements
... [process details] ...

**Output:**
```markdown
## Requirements Summary

### Core Requirements
- **Topic**: [Full topic description]
- **Scope**: [What article will cover specifically]
... [20+ more lines of format] ...
```  ← NEVER DO THIS
```

✅ **Correct Pattern:**
```markdown
## Phase 1: Requirements
... [process details] ...

**Output Format:** Use `.github/templates/output-article-phases.template.md` → "Phase 1 Output"
```

❌ **Embedded Article Structures** - Don't describe full document layouts inline
❌ **Inline Quality Checklists** - Don't embed long validation checklists (>5 items)
❌ **Repeated Format Blocks** - Don't repeat similar output formats across phases

### Template Location

- **General templates:** `.github/templates/`
- **Prompt output templates:** `.github/templates/output-*.template.md`
- **Domain-specific:** `.github/templates/{domain}-*.template.md`

### Template Naming Convention

| Purpose | Naming Pattern | Example |
|---------|----------------|---------|
| Output format | `output-{purpose}.template.md` | `output-prompt-validation-phases.template.md` |
| Input schema | `input-{purpose}.template.md` | `input-article-metadata.template.md` |
| Document structure | `{type}-structure.template.md` | `promptengineering-instruction-structure.template.md` |
| Guidance sections | `guidance-{topic}.template.md` | `guidance-input-collection.template.md` |

**📖 Existing templates:** `.github/templates/` (see list for reusable options)

### Why Template-First Matters (Token Budget)

**Embedding verbose content directly wastes tokens and causes context rot:**

| Approach | Token Cost | Maintainability | Reusability |
|----------|------------|-----------------|-------------|
| Embed 6 phase outputs (40 lines each) | ~1600 tokens | Poor - edits in each prompt | None |
| Reference 1 template | ~50 tokens | Good - single source of truth | Full |
| **Savings** | **~1550 tokens** | | |

**Budget impact example:**
- Prompt with embedded outputs: 2,200 tokens (exceeds 1,500 budget)
- Same prompt with template references: 650 tokens (well under budget)

**CRITICAL:** A prompt exceeding token budget may experience "lost in the middle" effects where instructions in the center are ignored.

---

## Tool Selection

**📖 Complete guidance:** [.copilot/context/00.00 prompt-engineering/](.copilot/context/00.00%20prompt-engineering/)

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

**📖 Complete guidance:** [.copilot/context/00.00 prompt-engineering/05-validation-caching-pattern.md](.copilot/context/00.00 prompt-engineering/05-validation-caching-pattern.md)

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

1. **Use templates for verbose content** - Extract output formats, input schemas, and document structures to `.github/templates/`
2. **Start with template** - Use appropriate template from `.github/templates/`
3. **Reference context files** - Don't embed shared principles
4. **Narrow tool scope** - Only essential tools for the task
5. **Test execution** - Run on real repository content
6. **Iterate boundaries** - Tighten based on observed errors

## Production-Ready Prompt Requirements

**Applies to ALL prompt files** - based on Mario Fontana's ["6 VITAL Rules for Production-Ready Copilot Agents"](https://www.linkedin.com/learning/mastering-ai-agents-the-prompt-engineering-masterclass):

### 1. Response Management (Data Gaps Handling)

**Every prompt MUST include** a section defining professional responses when information is missing:

```markdown
## Response Management

### When Information is Missing
I couldn't find [specific] in [locations searched].
I did find [partial context] in [location].
Recommendation: [escalation path or alternative]
```

**Required scenarios** (customize per prompt type):
- Missing context/information
- Ambiguous requirements (present options, don't guess)
- Tool failures (fallback behavior)

**Templates provide** prompt-type-specific scenarios:
- **Orchestration**: Agent not found, phase validation failure, handoff ambiguity
- **Implementation**: Pattern not found, file access failure, convention unclear
- **Analysis**: No matches found, contradictory sources, insufficient data
- **Validation**: Missing metadata, ambiguous rules, caching issues

### 2. Error Recovery Workflows

**Define fallback behavior for every critical tool:**

```markdown
### When Tool Failures Occur

- `semantic_search` returns nothing → Try grep_search, then escalate
- `read_file` fails → Verify path, report error with context
- `create_file` fails → Check permissions, suggest manual creation
```

**Golden rule:** NEVER proceed with invented data or half-implemented changes.

### 3. Embedded Test Scenarios

**Every prompt MUST include 3-5 test scenarios** to validate behavioral reliability:

```markdown
## Embedded Test Scenarios

### Test 1: Standard Case (Happy Path)
**Input:** [well-formed input]
**Expected:** [success behavior]
**Pass Criteria:** [specific outcomes]

### Test 2: Ambiguous Input
**Input:** [vague/conflicting requirements]
**Expected:** Asks clarifying questions (doesn't guess)
**Pass Criteria:** Lists options, requests guidance

### Test 3: Missing Context (Plausible Trap)
**Input:** [incomplete/incorrect data that looks plausible]
**Expected:** Detects gap, reports what's missing
**Pass Criteria:** Doesn't hallucinate, uses "I couldn't find X" template

[Add 1-2 more tests specific to prompt type]
```

**Required test types:**
- **Happy Path** - Expected success scenario
- **Ambiguous Input** - Should ask clarification, not guess
- **Out of Scope** - Professional refusal for beyond-capability tasks
- **Plausible Trap** - Detects incorrect but believable data

### 4. Token Budget Compliance

**Type-specific limits** (prevent Context Rot):
- Simple validation prompts: **< 500 tokens**
- Multi-step workflow prompts: **< 1500 tokens**
- Multi-agent orchestrators: **< 2500 tokens**

**Optimization techniques:**
- Reference context files instead of embedding principles
- Use imperative language (no filler)
- Place critical instructions in first 30% of prompt
- Factor large prompts into multiple smaller, focused prompts

**Validation:** `@prompt-validator` checks token count in Phase 5 (Production Readiness).

#### Conversion Reference

Quick token estimation without tools:

| Metric | Conversion Factor | Example |
|--------|------------------|----------|
| **Words → Tokens** | Multiply by 1.33 | 600 words = ~800 tokens |
| **Lines → Tokens** | Multiply by 5-8 (avg 6) | 120 lines = ~720 tokens |
| **Characters → Tokens** | Divide by 4 | 3,000 chars = ~750 tokens |
| **Tokens → Words** | Divide by 1.33 | 1,000 tokens = ~750 words |

#### Combined Context Budget

When your prompt references agents and instructions, consider cumulative impact:

**Typical Execution (Comfortable):**
```
Your prompt file: 800 tokens
+ Referenced agent: 1,000 tokens
+ Active instructions (3 files): 900 tokens
+ User's question: 50 tokens
+ Attached code files: 2,000 tokens
= 4,750 tokens before AI responds ✅
```

**Warning Scenario (Refactor Recommended):**
```
Your prompt file: 1,800 tokens
+ Referenced agent: 1,500 tokens
+ Active instructions (6 files): 1,800 tokens
+ User's question: 100 tokens
+ Attached code files: 5,000 tokens
= 10,200 tokens before AI responds ⚠️
```

**Budget Guidelines:**
- **Optimal**: < 10,000 tokens total pre-response context
- **Warning**: 10,000-15,000 tokens (consider simplification)
- **Critical**: > 15,000 tokens (refactor required)

### 5. Explicit Uncertainty Management

**Principle 7** from `context-engineering-principles.md`: All prompts must define professional "I don't know" responses.

**Three-part template:**
1. **Transparency** - What's missing: "I couldn't find X in Y"
2. **Partial Value** - What was found: "I did find Z"
3. **Actionable** - Next steps: "Recommendation: [escalation]"

**See full guidance:** [.copilot/context/00.00 prompt-engineering/01-context-engineering-principles.md](.copilot/context/00.00 prompt-engineering/01-context-engineering-principles.md#7-explicit-uncertainty-management)

## References

- [GitHub: How to write great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) - Best practices from 2,500+ repos
- [VS Code: Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization) - Official documentation
- [Microsoft: Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) - Comprehensive guide
- [OpenAI: Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering) - Foundational strategies
- `.github/copilot-instructions.md` - Repository-wide context and conventions

**Related instruction files:**
- [skills.instructions.md](./skills.instructions.md) - Agent Skill (SKILL.md) creation guidance
- [agents.instructions.md](./agents.instructions.md) - Custom agent creation guidance
