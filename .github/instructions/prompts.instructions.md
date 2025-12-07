---
description: Instructions for creating and updating effective prompt files
applyTo: '.github/prompts/**/*.md'
---

# Prompt File Creation & Update Instructions

## Purpose
Prompt files are **reusable, plan-level workflows** for common development tasks. They define WHAT should be done and HOW to approach it, operating at the strategic/planning layer rather than implementation details.

## Core Principles (Context Engineering)

### 1. Start with Clear, Specific Goals
- **Never try to solve everything in one prompt file**
- Define narrow scope for precise execution
- Broad prompts suffer from context rot and tool clash
- Example: `grammar-review.prompt.md` checks ONLY grammar, not readability or structure

### 2. Put Commands Early
- Place critical instructions in first sections
- Models under-weight middle content ("lost in the middle" problem)
- Front-load executable commands, boundaries, and key workflows

### 3. Be Specific and Direct
- Avoid polite filler ("Please kindly consider...")
- Every token counts - LLMs consume each character
- Use concise, actionable language
- Example: "Check these files" not "It would be helpful if you could please review"

### 4. Provide Examples
- Show expected output formats explicitly
- Include file naming patterns and structure examples
- Reference specific file collections for complex cases
- Use code blocks to demonstrate expected formats

### 5. Use Structured Sections
- Organize with clear markdown headings
- Standard sections: Purpose → Process → Boundaries → Expected Output
- LLMs process structured information more effectively

### 6. Set Clear Boundaries
Use three-tier boundary system:

```markdown
## Boundaries

### ✅ Always Do
- Validate input before processing
- Create intermediary reports before final output
- Ask for clarification on ambiguous requirements

### ⚠️ Ask First  
- Before deleting any file
- Before modifying configuration files
- When scope appears to expand beyond original task

### 🚫 Never Do
- Modify files outside designated directories
- Execute destructive operations without confirmation
- Assume context from previous conversations
```

## Required YAML Frontmatter

All prompt files MUST include:

```yaml
---
name: prompt-file-name
description: "One-sentence description of what this prompt does"
agent: agent  # or: edit, plan
model: claude-sonnet-4.5  # or: gpt-4o, gemini-2.0-flash
tools: ['codebase', 'editor', 'filesystem', 'web_search', 'fetch']  # Narrow tool scope
argument-hint: 'Works with files in active folder or specify paths'  # Optional
---
```

**Key Decisions:**
- `agent: agent` - Full autonomy with file editing (implementation level)
- `agent: plan` - Planning/analysis only, no file modifications
- `agent: edit` - Focused editing tasks with validation
- **Tools**: Specify ONLY required tools to prevent tool clash

## Prompt File Structure Template

```markdown
---
name: task-name
description: "Specific task description"
agent: agent
model: claude-sonnet-4.5
tools: ['relevant', 'tools', 'only']
---

# Task Name

[One paragraph explaining the prompt''s purpose and when to use it]

## Your Role
You are [specific role/persona: editor, analyst, architect] for this task.

## Goal  
[2-3 sentences defining the specific objective]

## Process

### Phase 1: [Discovery/Analysis]
1. Step-by-step instructions
2. What to look for
3. Where to search

### Phase 2: [Execution]
1. What actions to take
2. Expected outputs
3. Validation steps

### Phase 3: [Verification] 
1. Quality checks
2. Update metadata (if applicable)
3. Report results

## Context Requirements
- List what context must be discovered
- Reference instruction files to read first
- Specify repository patterns to understand

## Expected Output
[Describe format, location, naming conventions]

## Boundaries

### ✅ Always Do
- [Specific actions that should always happen]

### ⚠️ Ask First
- [Actions requiring user confirmation]

### �� Never Do  
- [Forbidden actions that could cause issues]

## Examples
[Show expected formats, naming patterns, or sample outputs]
```

## Repository-Specific Patterns

### Dual YAML Metadata
**CRITICAL**: All article-related prompts must respect dual YAML blocks:

1. **Top YAML (Quarto)**: title, author, date, categories
   - ❌ **NEVER modify from prompts**
   - Only authors edit manually

2. **Bottom YAML (Validation)**: grammar, readability, structure, etc.
   - ✅ **Update validation sections only**
   - Check `last_run` timestamp before validating
   - Skip if `last_run < 7 days` AND content unchanged

See: `.copilot/context/dual-yaml-helpers.md`

### Validation Caching (7-Day Rule)
```markdown
### Step 1: Check Existing Validation
1. Read entire article including both YAML blocks
2. Parse bottom YAML to extract validation section
3. Check `{type}.last_run` timestamp  
4. If validated within 7 days AND content unchanged:
   - Skip validation
   - Report existing outcome
```

### Phase-Based Workflows
For complex tasks, use checkpoint pattern:

```markdown
### Phase 1: Scan and Plan
1. Analyze requirements
2. Present plan to user
3. **STOP and wait for "go ahead"**

### Phase 2: Implementation  
1. Execute approved plan
2. Generate intermediary reports
3. Validate outputs
```

## Tool Scoping Strategy

**Narrow tool access prevents**:
- Tool clash (selecting wrong tool from large manifest)
- Distraction by irrelevant capabilities  
- Context bloat from unnecessary tool definitions

**Common tool combinations**:
- Read-only analysis: `[''codebase'', ''semantic_search'']`
- Content validation: `[''editor'', ''filesystem'']`
- Research tasks: `[''web_search'', ''fetch'', ''codebase'']`
- Implementation: `[''codebase'', ''editor'', ''filesystem'', ''terminal'']`

## Context Rot Prevention

### The Problem
Quality degrades beyond ~10,000 tokens due to:
1. **Poisoning**: Wrong info propagates as ground truth
2. **Distraction**: Peripheral info competes for attention
3. **Tunnel Vision**: Models focus on start/end, under-weight middle
4. **Confusion**: Attention problems mix unrelated concepts
5. **Clash**: Too many tools reduce selection accuracy

### Solutions in Prompts
1. **Narrow scope**: One specific task per prompt
2. **Early commands**: Critical instructions up front
3. **Limited tools**: Only essential capabilities
4. **Structured sections**: Clear organization aids parsing
5. **Intermediary reports**: Text with semantic structure between phases

## Testing & Iteration

1. **Start minimal**: Core task only
2. **Test execution**: Run on real repository content  
3. **Add detail**: When prompt makes mistakes, add specific guidance
4. **Iterate boundaries**: Tighten "Never do" based on observed errors
5. **Monitor token usage**: Keep prompts concise

## References

- [GitHub: How to write great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) - Best practices from 2,500+ repos
- [VS Code: Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization) - Official documentation
- [Microsoft: Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) - Comprehensive guide
- [OpenAI: Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering) - Foundational strategies
- `.github/copilot-instructions.md` - Repository-wide context and conventions
