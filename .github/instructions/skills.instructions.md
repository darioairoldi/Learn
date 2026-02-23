---
description: Instructions for creating Agent Skills (SKILL.md files)
applyTo: '.github/skills/**/SKILL.md,.github/templates/skill-*.md'
---

# Agent Skill Creation Instructions

> ⚠️ **Preview Feature**: Agent Skills (VS Code 1.107+) are in Preview. APIs may change.

## Purpose

Agent Skills are **portable, resource-rich workflows** that work across VS Code, CLI, and GitHub coding agent. Unlike prompts (on-demand tasks) or instructions (file-pattern rules), skills bundle templates, scripts, and examples with instructions following the open [agentskills.io](https://agentskills.io/) standard.

## Context Engineering Principles

**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](../../.copilot/context/00.00-prompt-engineering/)

**Key principles for skills** (see context folder for full details):
1. **Narrow Scope** - One specialized workflow per skill
2. **Early Commands** - Purpose and "When to Use" first
3. **Imperative Language** - Direct, action-oriented instructions
4. **Context Minimization** - Reference included resources, don't embed

## Progressive Disclosure System

**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](../../.copilot/context/00.00-prompt-engineering/)

Skills use a **three-level loading system** for efficient token usage:

| Level | What Loads | When | Token Impact |
|-------|------------|------|--------------|
| **1. Discovery** | `name` + `description` from YAML | Always | ~50-100 tokens/skill |
| **2. Instructions** | SKILL.md body content | Prompt matches description | ~500-1500 tokens |
| **3. Resources** | Templates, examples, scripts | Copilot references them | Loaded on-demand |

**Implication**: Optimize your `description` field for discovery accuracy—it determines whether Level 2 and 3 ever load.

## Cross-Platform Portability

Skills work across multiple platforms:

| Platform | Discovery | Instructions | Scripts |
|----------|-----------|--------------|---------|
| **VS Code Chat** | ✅ | ✅ | ⚠️ Requires approval |
| **Copilot CLI** | ✅ | ✅ | ⚠️ Requires approval |
| **Coding Agent** | ✅ | ✅ | ⚠️ Requires approval |

**Portability checklist:**
- Use **relative paths** only (no absolute paths)
- Include all resources in skill directory (no external URLs)
- Make scripts cross-platform when possible (or provide OS variants)
- Test activation with various prompt phrasings

## Required Directory Structure

```
.github/skills/skill-name/
├── SKILL.md                    # Required: Instructions + metadata
├── templates/                  # Optional: Reusable templates
├── examples/                   # Optional: Real-world examples
├── scripts/                    # Optional: Automation scripts
└── checklists/                 # Optional: Structured checklists
```

## Storage Locations

### Workspace Skills (Shared with Team)
```
.github/skills/skill-name/SKILL.md    # Recommended
.claude/skills/skill-name/SKILL.md    # Legacy (backward compatibility)
```

### Personal Skills (User-Level)
```
~/.copilot/skills/skill-name/SKILL.md # Recommended
~/.claude/skills/skill-name/SKILL.md  # Legacy
```

## Required YAML Frontmatter

```yaml
---
name: skill-name           # Required: lowercase, hyphens, max 64 chars
description: >             # Required: max 1024 chars
  What this skill does and technologies involved.
  Use when [scenario 1], [scenario 2], or [scenario 3].
---
```

### Name Field Requirements

| ✅ Valid | ❌ Invalid | Reason |
|----------|-----------|--------|
| `webapp-testing` | `WebApp Testing` | No uppercase/spaces |
| `security-review` | `test` | Too generic |
| `k8s-deploy` | `a-very-long-skill-name-exceeding-64-chars...` | Too long |

### Description Field Requirements

**Formula:** `[What it does] + [Technologies] + "Use when" + [Scenarios]`

```yaml
# ✅ Good - specific with use cases
description: >
  Generate test suites for React components using Jest and RTL.
  Use when writing unit tests, debugging failures, or setting up test infrastructure.

# ❌ Bad - vague, no technologies, no scenarios
description: Helps with testing
```

## Body Content Requirements

### Required Sections

| Section | Content |
|---------|---------|
| **Purpose** | 1-2 sentences explaining the skill's goal |
| **When to Use** | Bullet list of activation scenarios |
| **Workflow** | Step-by-step procedure |

### Recommended Sections

| Section | Content |
|---------|---------|
| **Templates** | Links to template files (relative paths) |
| **Examples** | Links to example files (relative paths) |
| **Common Issues** | Troubleshooting guide |

## File Path Rules

**ALWAYS use relative paths** from the SKILL.md location:

```markdown
# ✅ Correct
See [test template](./templates/component.test.js)

# ❌ Wrong - absolute path
See [template](/home/user/project/.github/skills/testing/templates/test.js)

# ❌ Wrong - external URL
See [template](https://github.com/user/repo/blob/main/templates/test.js)
```

## Length Guidelines

| Content | Recommended | Maximum |
|---------|-------------|---------|
| `description` | 100-200 chars | 1024 chars |
| SKILL.md body | 500-1000 words | 1500 words |
| Templates | 20-50 lines | 100 lines |
| Examples | 30-80 lines | 150 lines |
### Resource Budget Planning

Skills bundle multiple resources under progressive disclosure. Plan total size:

**Example Skill Budget:**
```
.github/skills/webapp-testing/
├─ SKILL.md
│  ├─ YAML description: 75 tokens          (Level 1: Always loaded)
│  └─ Body content: 1,000 tokens           (Level 2: Loaded when matched)
├─ templates/
│  ├─ component.test.js: 200 tokens        (Level 3: Loaded on reference)
│  └─ integration.test.js: 300 tokens      (Level 3: Loaded on reference)
└─ examples/
   ├─ simple-case.js: 400 tokens           (Level 3: Loaded on reference)
   └─ complex-case.js: 600 tokens          (Level 3: Loaded on reference)

Total Skill Footprint: 2,575 tokens (progressively loaded)
```

**Progressive Loading Strategy:**
- **Level 1 (Discovery)**: Always minimal (< 100 tokens)
- **Level 2 (Instructions)**: Load full body when matched (~500-1,000 tokens)
- **Level 3 (Resources)**: Load individually when Copilot references them (~200-600 tokens each)

**Budget Rule**: Description + Body should be < 1,500 tokens total

**Optimization Tips:**
- Keep descriptions under 200 characters for fast discovery
- Structure body with "Quick Reference" section first
- Make each resource independently useful (not interdependent)
- Use relative references between resources within skill folder
## Skill Template

**Use the template:** `.github/templates/skill-template.md`

## Skill-Specific Best Practices

### 1. Optimize for Discovery

The `description` determines activation. **Include keywords users might use**:

```yaml
# ✅ Good: Multiple matching keywords
description: >
  Generate comprehensive test suites for React components using Jest 
  and React Testing Library. Use when writing unit tests, creating 
  integration tests, testing user interactions, or validating rendering.
```

### 2. Make Resources Self-Contained

**Include everything needed** within the skill directory:
- Templates ready to copy-paste
- Examples demonstrating patterns
- Configuration samples
- Scripts with explicit dependencies

### 3. Clear Activation Triggers

In "When to Use", be explicit:

```markdown
## When to Use

Activate this skill when:
- "Write tests for this component"
- "My test is failing with [error]"
- "Configure Jest for this project"

Do NOT use this skill for:
- End-to-end testing with Playwright
- Backend API testing
```

### 4. Progressive Detail Structure

```markdown
## Quick Reference
[Essential patterns - 5-10 lines]

## Detailed Workflow
[Full procedure - 50-100 lines]

## Advanced Configuration
[Deep customization - references to docs]
```

## Testing Skills

1. Enable: `"chat.useAgentSkills": true` in VS Code settings
2. Verify discovery: "What skills are available?"
3. Test activation with various prompt phrasings
4. Verify resource loading with explicit references
5. Test cross-platform if skill should work in CLI/coding agent

## Validation Checklist

Before committing a skill:

- [ ] **Name** is lowercase with hyphens, ≤64 characters
- [ ] **Description** includes capabilities AND "Use when" scenarios
- [ ] **Description** ≤1024 characters
- [ ] **All resource paths** are relative
- [ ] **Templates** are minimal and copy-paste ready
- [ ] **Examples** demonstrate real-world usage
- [ ] **Scripts** work cross-platform (if applicable)
- [ ] **Skill activates** for intended prompts
- [ ] **Skill does NOT activate** for unrelated prompts

## Skills vs Other Customizations

| Need | Solution |
|------|----------|
| Cross-platform workflow with templates | **Skill** |
| File-specific coding standards | **Instruction** (with `applyTo`) |
| One-time task execution | **Prompt** |
| Persistent persona with tool control | **Agent** |

## Critical Limitations

### What Skills CANNOT Do

| Limitation | Workaround |
|------------|------------|
| **No tool control** | Suggest tool usage in instructions ("Use the terminal to run tests") |
| **No handoffs** | Use agents for multi-agent workflows |
| **No file pattern activation** | Use `description` keywords for matching |
| **No user input variables** | Use generic instructions with inline placeholders |

**When to use agents instead:**
- Complex tool orchestration required
- Multi-step handoff workflows
- VS Code-specific personas

## Common Pitfalls

1. **Vague descriptions** → Skill activates inappropriately
2. **Missing "Use when" scenarios** → Copilot can't determine activation
3. **External resource dependencies** → Skills fail when shared
4. **Absolute file paths** → Skills break when moved
5. **Over-scoped skills** → Create focused skills with clear boundaries
6. **Duplicating built-in capabilities** → Focus on domain-specific workflows

## References

- [VS Code: Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) - Official documentation
- [agentskills.io](https://agentskills.io/) - Open standard specification
- [github/awesome-copilot](https://github.com/github/awesome-copilot) - Community skills collection
- [anthropics/skills](https://github.com/anthropics/skills) - Reference skill implementations

**📖 Context files:**
- [13-file-type-decision-guide.md](.copilot/context/00.00-prompt-engineering/13-file-type-decision-guide.md) - Skills vs prompts vs agents decision guide
- [14-mcp-server-design-patterns.md](.copilot/context/00.00-prompt-engineering/14-mcp-server-design-patterns.md) - MCP servers complement skills for persistent state and external APIs

**📖 Complete guidance:** [03.00-tech/05.02-promptEngineering/06. how_to_structure_content_for_copilot_skills.md](../../03.00%20tech/05.02%20PromptEngineering/06.%20how_to_structure_content_for_copilot_skills.md)
