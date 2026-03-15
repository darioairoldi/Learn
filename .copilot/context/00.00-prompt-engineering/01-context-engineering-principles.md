# Context Engineering Principles for GitHub Copilot

**Purpose**: Consolidated best practices for crafting effective instructions, prompts, and agent personas for GitHub Copilot. This document serves as the single source of truth for context engineering principles across all file types.

**Referenced by**: `.github/instructions/prompts.instructions.md`, `.github/instructions/agents.instructions.md`, all prompt and agent files

---

## Core Principles

### 1. Narrow Scope, Specific Purpose

**Principle**: Each prompt, agent, or instruction file should have a single, well-defined responsibility.

**Why it matters**: 
- Reduces ambiguity in AI interpretation
- Makes files easier to maintain and debug
- Enables better composition through handoffs
- Improves caching and reuse efficiency

**Application**:
- ❌ **Bad**: "Create or update a prompt file, validate it, and update documentation"
- ✅ **Good**: Three separate agents: prompt-builder, prompt-validator, documentation-updater

**Guidelines**:
- One primary user goal per file
- Related sub-tasks are acceptable if they serve the primary goal
- Use handoffs for sequential workflows
- Use composition for parallel capabilities

### 2. Early Commands, Clear Structure

**Principle**: Place the most important instructions and commands at the beginning of your content.

**Why it matters**:
- AI models give more weight to earlier content
- Critical constraints must be established before detailed instructions
- Early structure aids AI's mental model formation

**Application**:
```markdown
<!-- HIGH PRIORITY - Place at top -->
1. Core objective statement
2. Critical constraints (NEVER/ALWAYS rules)
3. Primary workflow/process
4. Tool configuration
5. Handoff definitions

<!-- LOWER PRIORITY - Place after -->
6. Examples and edge cases
7. Quality checklists
8. Background context
9. Troubleshooting tips
```

**YAML Frontmatter Priority**:
Always place critical configuration in YAML frontmatter, not buried in Markdown:
```yaml
---
description: "Single-sentence role definition"  # AI reads this first
tools: ['read_file', 'editor']  # Tool scope defined immediately
agent: plan  # Behavioral constraints upfront
---
```

### 3. Imperative Language

**Principle**: Use direct, commanding language that leaves no room for interpretation.

**Why it matters**:
- Reduces probabilistic behavior in AI responses
- Creates enforceable boundaries
- Establishes clear expectations

**Command Hierarchy**:

| Strength | Phrase | Use Case | Example |
|----------|--------|----------|---------|
| **Absolute** | `NEVER`, `MUST NOT` | Hard boundaries, safety rules | "NEVER modify files outside .github/prompts/" |
| **Required** | `MUST`, `ALWAYS`, `WILL` | Core requirements | "You MUST validate YAML syntax before saving" |
| **Expected** | `SHOULD`, `PREFER` | Best practices, soft preferences | "You SHOULD use handoffs for multi-step workflows" |
| **Optional** | `CAN`, `MAY`, `CONSIDER` | Suggestions, alternatives | "You MAY ask for clarification if requirements are vague" |

**Examples**:

❌ **Weak** (probabilistic):
```markdown
It would be helpful if you could check for syntax errors.
Try to keep the file under 200 lines.
Consider using semantic search to find similar patterns.
```

✅ **Strong** (imperative):
```markdown
You MUST validate YAML syntax before saving any changes.
You WILL keep the file under 200 lines; factor into multiple files if needed.
You MUST use semantic_search to analyze at least 3 similar prompts before building.
```

### 4. Three-Tier Boundary System

**Principle**: Explicitly define what the AI MUST do, what requires approval, and what is forbidden.

**Why it matters**:
- Prevents overstepping boundaries (e.g., editing wrong files)
- Clarifies decision authority
- Reduces user interruptions for trivial decisions
- Establishes trust through predictable behavior

**Structure**:
```yaml
boundaries:
  always_do:  # No approval needed - execute immediately
    - "Validate YAML syntax before saving"
    - "Create backup files when updating"
    - "Use semantic_search before building new prompts"
  
  ask_first:  # Requires user approval before proceeding
    - "Modify existing validated prompts"
    - "Change agent handoff workflows"
    - "Delete any prompt files"
  
  never_do:  # Hard boundaries - refuse with explanation
    - "Modify instruction files without explicit request"
    - "Remove validation metadata from bottom YAML"
    - "Create prompts that violate repository conventions"
```

**Application to File Types**:

| File Type | Always Do | Ask First | Never Do |
|-----------|-----------|-----------|----------|
| **Prompts** | Validate syntax, check tool availability | Modify workflow logic, change tool lists | Break YAML format, remove metadata |
| **Agents** | Validate handoff targets, check tool scope | Add new tools, modify persona | Grant unrestricted file access |
| **Instructions** | Verify `applyTo` patterns | Change core principles | Create circular dependencies |

### 5. Context Minimization

**Principle**: Include only the context necessary for the specific task; reference external sources for additional details.

**Why it matters**:
- Reduces token usage and execution cost
- Improves AI focus on relevant information
- Makes files easier to maintain (single source of truth)
- Enables better composition and reuse

**Techniques**:

**Use References Instead of Duplication**:
```markdown
❌ **Bad**: Embed 100 lines of context engineering principles in every prompt

✅ **Good**: 
For context engineering principles, see `.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md`
For tool composition patterns, see `.copilot/context/00.00-prompt-engineering/04-tool-composition-guide.md`
```

**Group References Over Individual Files**:

When referencing context files from `.github/` files (prompts, agents, instructions), prefer **group references** (folder-level) over individual file references. This improves maintainability and allows context files to evolve without breaking references.

```markdown
✅ **Good** - Group reference (folder-level):
📖 **Complete guidance:** [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)

❌ **Avoid** - Individual file reference (unless specifically needed):
📖 **Complete guidance:** [.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md](.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md)
```

**When to use individual file references:**
- Linking to a specific section or concept (e.g., "See [validation-caching-pattern.md] for the 7-day rule")
- Cross-referencing between context files within the same folder
- Deep-linking to troubleshooting or examples

**Benefits of group references:**
- Files can be added, renamed, or reorganized without updating all references
- Readers discover all related content in the folder
- Reduces maintenance burden as context evolves

**Selective File Reads**:
```markdown
❌ **Bad**: "Read all files in .github/prompts/ before starting"

✅ **Good**: "Use semantic_search with query 'validation workflow' to find 3 relevant prompts"
```

**Lazy Loading Pattern**:
```markdown
## Process

1. **Gather Requirements** - Minimal context, user interaction only
2. **Research Phase** - NOW use semantic_search, read_file, grep_search
3. **Build Phase** - Access templates and examples
4. **Validate Phase** - Load validation rules and checklists
```

### 6. Tool Scoping and Security

**Principle**: Grant only the minimum tools necessary for the agent's role; use `agent: plan` for read-only operations.

**Why it matters**:
- Prevents accidental file modifications
- Reduces risk of cascading errors
- Makes agent behavior more predictable
- Aligns with principle of least privilege

**📖 Complete tool reference:** [04-tool-composition-guide.md](04-tool-composition-guide.md) — tool categories, costs, composition patterns, role-based selection

**Key rules:**
- `agent: plan` + read-only tools ONLY (read_file, grep_search, semantic_search, file_search, list_dir, get_errors)
- `agent: agent` + read + write tools (create_file, replace_string_in_file, multi_replace_string_in_file)
- **NEVER** mix `agent: plan` with write tools — this is a CRITICAL validation failure
- Limit agents to 3–7 tools; >7 causes tool clash
- Always-available tools (manage_todo_list, ask_questions, runSubagent, tool_search_tool_regex) MUST NOT be listed in `tools:` frontmatter

---

### 7. Explicit Uncertainty Management

**Principle**: Define professional "I don't know" responses and data gap handling patterns that prevent hallucination and maintain user trust.

**Why it matters**:
- AI models have a bias toward providing answers even when lacking sufficient context
- Admitting uncertainty prevents confidently stated misinformation
- Explicit templates create consistent, professional uncertainty handling
- Missing data scenarios are inevitable in production systems
- Referenced from: **Mario Fontana's "6 VITAL Rules for Production-Ready Copilot Agents"** (Rule 1: Data Gaps, Rule 2: "I Don't Know")

---

### 8. Template-First Authoring (Token Efficiency)

**Principle**: **PREFER template files** over verbose embedded descriptions for output formats, input schemas, document structures, and workflows. Externalize to reusable template files rather than embedding inline.

**Core Rule**: If content exceeds 10 lines and could be reused, externalize it to a template.

**Why it matters**:
- **Token efficiency**: Large inline formats consume context budget; templates load only when needed
- **Flexibility**: Different templates for different conditions (simple vs. complex output, different audiences)
- **Consistency**: Single source of truth for output formatting across multiple prompts/agents
- **Maintainability**: Update format once, all references benefit
- **Composability**: Templates can be combined or swapped without modifying prompt logic

**When to Use Templates (Quick Reference)**:

| Content Type | ❌ Don't Embed | ✅ Use Template |
|--------------|----------------|------------------|
| **Output formats** | Multi-line output examples inline | `output-*.template.md` |
| **Input schemas** | Detailed input field descriptions | `input-*.template.md` |
| **Document structures** | Section-by-section layout specs | `*-structure.template.md` |
| **Validation checklists** | Long inline checklists (>12 items) | Instruction file or template |
| **Multi-step workflows** | Phase descriptions > 20 lines | Phase templates or context files |
| **Report layouts** | Summary formats > 8 lines | `*-summary.template.md` |

**What to externalize (with thresholds):**

| Content Type | Inline Size Threshold | Template Location |
|--------------|----------------------|-------------------|
| **Output Formats** | > 10 lines | `.github/templates/output-*.template.md` |
| **Validation Reports** | > 15 lines | `.github/templates/report-*.template.md` |
| **Input Collection Guides** | > 10 lines | `.github/templates/guidance-input-*.template.md` |
| **Summary Layouts** | > 8 lines | `.github/templates/*-summary-*.template.md` |
| **Checklists** | > 12 items | `.github/templates/checklist-*.template.md` |
| **Phase Output Formats** | > 15 lines per phase | `.copilot/context/*/phase-*.md` |

**Template reference pattern:**

```markdown
❌ **Don't** embed verbose format inline:
## Output Format
### Section 1: Summary
[...50+ lines of format specification...]

✅ **Do** reference template:
## Output Format
**Use template:** `.github/templates/output-summary.template.md`
```

**Conditional template selection** — select based on task complexity:

| Condition | Template | Purpose |
|-----------|----------|---------|
| Simple task, < 3 outputs | `output-minimal.template.md` | Fast response |
| Standard task | `output-standard.template.md` | Default format |
| Complex/orchestration | `output-detailed.template.md` | Full trace |
| Error scenario | `output-error.template.md` | Recovery focus |

**Token savings:** Inline 50 lines ≈ 300 tokens → template reference 3 lines ≈ 18 tokens (94% savings). Multiply by 6 phases in an orchestrator → ~1,700 tokens saved.

**When to keep inline:** Format is < 10 lines, unique to this prompt (never reused), or requires heavy dynamic interpolation.

**Template naming conventions:**

| Purpose | Naming Pattern | Example |
|---------|----------------|---------|
| **Output formats** | `output-{purpose}.template.md` | `output-prompt-validation-phases.template.md` |
| **Input schemas** | `input-{purpose}.template.md` | `input-article-metadata.template.md` |
| **Document structures** | `{type}-structure.template.md` | `promptengineering-instruction-structure.template.md` |
| **Guidance sections** | `guidance-{topic}.template.md` | `guidance-input-collection.template.md` |

**Existing templates:** See `.github/templates/` (26+ reusable templates available)

**Integration with Principle 5 (Context Minimization):**
Template externalization is a specific application of context minimization for structured outputs. While Principle 5 focuses on *reference knowledge*, Principle 8 addresses *output scaffolding*—both reduce inline token consumption.

**Three-Part "I Don't Know" Template**:

```markdown
I couldn't find [specific information] in [locations searched].
I did find [partial/related context] in [location].
Recommendation: [escalation path or alternative approach]
```

**Why this structure works**: Transparency about what's missing, shares partial value, provides actionable next steps.

**Data Gap Scenarios**:

| Scenario | Response Pattern |
|----------|------------------|
| **Information Missing** | "Couldn't find X in Y. Did find Z. Recommend: [action]" |
| **Ambiguous Requirements** | "Could mean A or B. Which interpretation? [list trade-offs]" |
| **Tool Failure** | "Tool failed: [reason]. Tried: [fallbacks]. Recommend: [escalation]" |
| **Out of Scope** | "This requires [capability not in tools]. Recommend: [manual step / alternative tool]" |
| **Conflicting Data** | "Found contradictory patterns: [list with evidence]. Recommend: [user guidance needed]" |

**Error Recovery Workflows**:

| Tool Failure | Fallback Strategy |
|---|---|
| `semantic_search` returns nothing | Try `grep_search` with keywords → `file_search` with globs → report with search terms tried |
| `read_file` fails | Verify path with `file_search` → check with `list_dir` → report path issue |
| Reference file missing | Search similar patterns → check instruction files → report with alternatives |

**Confidence Indicators** — qualify conclusions drawn from partial data:

| Level | Criteria |
|---|---|
| **High** | 5+ consistent examples in codebase |
| **Medium** | 2–4 examples, some variation |
| **Low** | 1 example or conflicting patterns |
| **None** | No examples found, using industry best practices |
**Low Confidence**: Found 1 example or conflicting patterns
**No Confidence**: No examples found, proceeding with industry best practices
---

## Application by File Type

Each file type applies these principles with different priorities:

| File Type | Key Priorities | Token Budget | Details |
|---|---|---|---|
| **Prompts** (.prompt.md) | Narrow scope, early commands, tool scoping | ≤1,500 (multi-step) | 📖 [prompts.instructions.md](../../.github/instructions/prompts.instructions.md) |
| **Agents** (.agent.md) | Single role, tool alignment, boundaries | ≤1,000 (specialist) | 📖 [agents.instructions.md](../../.github/instructions/agents.instructions.md) |
| **Instructions** (.instructions.md) | Concise rules, reference context files | ≤800 | 📖 [context-files.instructions.md](../../.github/instructions/context-files.instructions.md) |
| **Skills** (SKILL.md) | Discovery-optimized description, progressive disclosure | ≤1,500 (body) | 📖 [skills.instructions.md](../../.github/instructions/skills.instructions.md) |
| **Context files** (.copilot/context/) | Single source of truth, no duplication | ≤2,500 | 📖 [context-files.instructions.md](../../.github/instructions/context-files.instructions.md) |

**Content allocation rule:** Repository-specific conventions → instruction files. Reusable patterns → context files. Verbose output formats → templates. Process workflows → prompts or agents.

---

## Token Budget Guidelines

### File Size Budgets by Type

| File Type | Budget | Typical | Action if Exceeded |
|-----------|--------|---------|-------------------|
| **Prompt** (simple) | < 500 tokens | ~75 lines | Split with handoffs |
| **Prompt** (multi-step) | < 1,500 tokens | ~220 lines | Create orchestrator |
| **Prompt** (orchestrator) | < 2,500 tokens | ~375 lines | Decompose agent teams |
| **Agent** (specialist) | < 1,000 tokens | ~150 lines | Extract to instructions |
| **Agent** (orchestrator) | < 2,000 tokens | ~300 lines | Split by role |
| **Instruction** | < 800 tokens | ~120 lines | Split by layer or extract to context |
| **Skill** (body) | < 1,500 tokens | ~200 lines | Use progressive disclosure |
| **Context file** | < 2,500 tokens | ~375 lines | Split by topic |

**Quick estimation**: words × 1.33 ≈ tokens; lines × 6 ≈ tokens

### Combined Context Consumption

```
Typical Prompt Execution:
  Prompt file: 800 tokens
+ Referenced agent: 1,000 tokens
+ Active instructions (3 files): 900 tokens
+ User question: 50 tokens
+ Code context: 2,000 tokens
= 4,750 tokens before AI responds ✅ Comfortable
```

**Thresholds**: < 10,000 tokens optimal; 10,000–15,000 warning; > 15,000 degraded performance

**📖 Detailed optimization strategies:** [06-context-window-and-token-optimization.md](06-context-window-and-token-optimization.md)

---

## Common Anti-Patterns

### ❌ Anti-Pattern 1: Vague Instructions
```markdown
Try to keep prompts focused.
It's generally better to use handoffs.
Consider checking for errors.
```
**Problem**: Probabilistic language creates inconsistent behavior

**Fix**: Use imperative language with clear requirements
```markdown
You MUST limit prompts to one primary task; use handoffs for multi-step workflows.
You WILL validate YAML syntax before saving.
```

### ❌ Anti-Pattern 2: Scope Creep
```markdown
# prompt-validator.agent.md
You are a validation specialist. You check prompts for errors,
suggest improvements, update the files with fixes, and also
generate documentation about validation results.
```
**Problem**: Agent has 4 responsibilities (validate, suggest, update, document)

**Fix**: Split into specialized agents
- `prompt-validator`: Check and report (read-only)
- `prompt-updater`: Apply fixes (write access)
- `documentation-updater`: Generate docs (separate domain)

### ❌ Anti-Pattern 3: Embedded Documentation
```markdown
# Inside a prompt file:

## Context Engineering Principles
[100 lines of principles that belong in context files]

## Tool Usage Guide
[50 lines of tool documentation]

## Validation Rules
[80 lines of validation logic]
```
**Problem**: Duplicates content, increases maintenance burden, wastes tokens

**Fix**: Reference external context
```markdown
## Prerequisites

Before starting, review:
- Context engineering principles: `.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md`
- Tool usage patterns: `.copilot/context/00.00-prompt-engineering/04-tool-composition-guide.md`
```

### ❌ Anti-Pattern 4: Weak Boundaries
```markdown
## Boundaries
- Try not to modify files outside the target directory
- Probably should ask before deleting things
```
**Problem**: "Try not to" and "probably should" are not enforceable

**Fix**: Use three-tier system with imperative language
```markdown
## Boundaries

### 🚫 Never Do
- NEVER modify files outside `.github/prompts/` directory
- NEVER delete any files without explicit user approval
```

### ❌ Anti-Pattern 5: Late Critical Information
```markdown
[300 lines of examples and context]

## Important: NEVER modify the top YAML block
[Critical constraint buried at end]
```
**Problem**: AI may miss critical information placed late in content

**Fix**: Place critical constraints at the top
```yaml
---
description: "Validation specialist - read-only operations"
agent: plan  # Establishes read-only constraint immediately
---

# Prompt Validator Agent

**CRITICAL CONSTRAINTS**:
- You NEVER modify files; you only analyze and report
- You NEVER touch the top YAML block under any circumstances
```

---

## Validation Checklist

Use this checklist when creating or reviewing prompts, agents, or instructions:

### Scope and Purpose
- [ ] File has single, well-defined responsibility
- [ ] Purpose is stated in first sentence/YAML description
- [ ] Related to other files via handoffs/references, not duplication

### Structure and Priority
- [ ] YAML frontmatter contains critical configuration
- [ ] Most important instructions are in first 20% of content
- [ ] Process/workflow defined before examples
- [ ] Quality checklist or success criteria included

### Language and Clarity
- [ ] Uses imperative verbs (MUST, WILL, NEVER)
- [ ] Avoids weak phrases (try to, consider, probably)
- [ ] Commands are specific and actionable
- [ ] No ambiguous pronouns or references

### Boundaries and Safety
- [ ] Three-tier boundaries explicitly defined
- [ ] File access scope is clear (which directories)
- [ ] Destructive operations require approval
- [ ] Handoff targets are valid agent/prompt names

### Context and Efficiency
- [ ] References context files instead of embedding content
- [ ] Only includes context necessary for this specific task
- [ ] Uses lazy loading (tools called when needed, not preemptively)
- [ ] No duplicated content from other repository files

### Tools and Capabilities
- [ ] Tool list matches role (read-only for validators, write for builders)
- [ ] `agent: plan` used for analysis-only agents
- [ ] No unnecessary tools that increase risk
- [ ] External tools (fetch, terminal) have clear boundaries

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-12-10 | Initial consolidated version from analysis | System |
| 1.0.1 | 2026-02-23 | Added v1.107+ cross-references, Spaces/SDK references | System |
| 1.1.0 | 2026-03-08 | Deduplication: trimmed principle 6 (→ ref 02), condensed principles 7-8, compact token budgets, compact file-type application table | System |

---

## References

- **Official Documentation**: [VS Code Copilot Custom Agents](https://code.visualstudio.com/docs/copilot/copilot-customization)
- **Repository Articles**: `03.00-tech/05.02-prompt-engineering/` series
- **v1.107+ Architecture**: See [02-prompt-assembly-architecture.md](./02-prompt-assembly-architecture.md) for execution contexts (Local/Background/Cloud) that affect how principles apply per environment
- **Related Context**: 
  - [04-tool-composition-guide.md](./04-tool-composition-guide.md) - Tool selection patterns
  - [14-validation-caching-pattern.md](./14-validation-caching-pattern.md) - 7-day caching rules
  - [05-handoffs-pattern.md](./05-handoffs-pattern.md) - Multi-agent orchestration
  - [12-copilot-spaces-patterns.md](./12-copilot-spaces-patterns.md) - Cross-project context
  - [13-copilot-sdk-integration.md](./13-copilot-sdk-integration.md) - SDK consumption
