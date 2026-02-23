# File Type Decision Guide

**Purpose**: Quick-reference decision framework for choosing the correct customization file type (prompt, agent, instruction, skill, snippet, MCP server).

**Referenced by**: All prompt/agent/instruction creation workflows, `.github/prompts/`, `.github/agents/`, `.github/instructions/`

---

## Decision Flowchart

```
What do you need?
├─ Coding standards for specific files/languages?
│  → INSTRUCTION FILE (.instructions.md)
├─ Reusable task triggered by user?
│  → PROMPT FILE (.prompt.md)
├─ Persistent persona with tool restrictions?
│  → AGENT FILE (.agent.md)
├─ Complex workflow with templates/scripts?
│  → SKILL (SKILL.md + folder)
├─ Shared context fragment (no slash command)?
│  → PROMPT SNIPPET (.prompt.md in prompt-snippets/)
├─ General project architecture info?
│  → copilot-instructions.md
├─ Instructions for coding agent (GitHub.com)?
│  → AGENTS.md
├─ External API/database/real-time data access?
│  → MCP SERVER
├─ Cross-project knowledge or ephemeral docs?
│  → COPILOT SPACES
├─ Programmatic prompt consumption (CI/CD, apps)?
│  → COPILOT SDK
└─ One-time task?
   → Inline chat
```

## Comparison Table

| Aspect | Prompt | Agent | Instruction | Skill | MCP Server |
|--------|--------|-------|-------------|-------|------------|
| **Extension** | `.prompt.md` | `.agent.md` | `.instructions.md` | `SKILL.md` | Any language |
| **Location** | `.github/prompts/` | `.github/agents/` | `.github/instructions/` | `.github/skills/` | `src/` or external |
| **Trigger** | User `/command` | User `@mention` | Auto (`applyTo`) | AI-discovered | Tool call |
| **Tool control** | Yes (`tools:`) | Yes (`tools:`) | No | No | Defines tools |
| **Model control** | Yes (`model:`) | Yes (`model:`) | No | No | N/A |
| **Bundled resources** | No | No | No | Yes | Yes |
| **Cross-platform** | VS Code only | VS Code only | VS Code, VS | VS Code, CLI, Agent | Any MCP client |
| **Complexity** | Low | Low | Low | Medium | High |

**Additional context mechanisms**: See [15-copilot-spaces-patterns.md](./15-copilot-spaces-patterns.md) for persistent cross-project context and [16-copilot-sdk-integration.md](./16-copilot-sdk-integration.md) for programmatic consumption.

## Naming Conventions

| Rule | Example |
|------|---------|
| **kebab-case** (lowercase, hyphens) | `create-react-form.prompt.md` |
| **Action verb first** | `review-`, `generate-`, `refactor-` |
| **Include domain** when relevant | `create-api-endpoint.prompt.md` |
| **Under 5 words** for brevity | `validate-schema.prompt.md` |

**Critical extensions**: `.prompt.md`, `.agent.md`, `.instructions.md`, `SKILL.md`

## Folder Structure

| Path | Contents |
|------|----------|
| `.github/prompts/` | Prompt files → slash commands |
| `.github/agents/` | Agent files → @mentions |
| `.github/instructions/` | Instruction files → auto-applied |
| `.github/skills/` | Skill folders → AI-discovered |
| `.github/prompt-snippets/` | Reusable fragments → `#file:` ref |
| `.github/templates/` | Starting-point templates |
| `.github/copilot-instructions.md` | Global repo instructions |
| `.copilot/context/` | Domain documentation (semantically indexed) |
| `AGENTS.md` | Coding agent instructions (any location) |

## Execution Contexts (v1.107+)

| Context | Isolation | Best for |
|---------|-----------|----------|
| **Local** | None — modifies workspace | Quick tasks, interactive |
| **Background** | Full — isolated work tree | Long-running, non-blocking |
| **Cloud** | Full — new branch and PR | Large changes, async |

## Skill Loading System

| Level | What loads | When | Tokens |
|-------|-----------|------|--------|
| Discovery | Name + description | Always indexed | ~50-100 |
| Instructions | SKILL.md body | Prompt matches description | ~500-1500 |
| Resources | Templates, scripts | AI references them | On-demand |

## Token Budget Guidelines (Instructions)

| Scope | Max tokens | Typical |
|-------|-----------|---------|
| Single language/framework | 800 | 400-600 |
| Project-wide general | 500 | 200-400 |
| Specific feature/pattern | 300 | 150-250 |
| Repository root (global) | 600 | 300-500 |

Exceeding 1,000 tokens (~150 lines) → split into multiple files.

## Composable System Order

```
PROMPT FILE → Uses agent configuration →
AGENT FILE → Reads relevant instructions →
INSTRUCTION FILES (auto-applied by applyTo)
```

Tool priority: **Prompt tools > Agent tools > Default agent tools**

---

## References

- **Internal**: [07-prompt-assembly-architecture.md](./07-prompt-assembly-architecture.md), [02-tool-composition-guide.md](./02-tool-composition-guide.md)
- **Sources**: Articles 02.00, 03.00, 04.00, 05.00 in `03.00-tech/05.02-prompt-engineering/`
- **External**: [VS Code Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — decision framework, comparison table, naming, folders | System |
| 1.1.0 | 2026-02-23 | Added Spaces and SDK to decision flowchart, cross-references to files 15/16 | System |
