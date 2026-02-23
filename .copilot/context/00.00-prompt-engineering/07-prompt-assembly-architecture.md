# Prompt Assembly Architecture

**Purpose**: Defines how GitHub Copilot assembles the system prompt and user prompt from customization files, establishing WHERE each file type injects and in what order.

**Referenced by**: All prompt, agent, instruction, and skill files; `.github/instructions/prompts.instructions.md`, `.github/instructions/agents.instructions.md`

---

## System Prompt Assembly

The system prompt is assembled in this fixed order. Layers 1–4 are built-in (you don't control them). Layers 5–6 are your customization points.

```
┌─────────────────────────────────────────────────────────────┐
│                    SYSTEM PROMPT                            │
├─────────────────────────────────────────────────────────────┤
│  1. Core identity and global rules                         │
│     "You are an expert AI programming assistant..."         │
│                                                             │
│  2. General instructions                                   │
│     Model-specific behavioral rules                         │
│                                                             │
│  3. Tool use instructions                                  │
│     How to call tools, format parameters, handle results    │
│                                                             │
│  4. Output format instructions                             │
│     Markdown formatting, code block rules, link styles      │
│                                                             │
│  5. Custom instructions (.instructions.md files)           │
│     Your project-specific guidance (auto-injected)          │
│     ⚠️ copilot-instructions.md is always injected LAST      │
│                                                             │
│  6. Custom agent definition (.agent.md body)               │
│     Agent persona, workflow, and constraints                │
│     Only present when a custom agent is active              │
└─────────────────────────────────────────────────────────────┘
```

**Critical rules:**
- Custom instructions inject at the END of the system prompt
- `copilot-instructions.md` ALWAYS comes last, giving it final authority on project conventions
- Custom agents inject AFTER instructions—they act as a full identity override

## User Prompt Assembly

The user prompt is assembled separately from the system prompt:

```
┌─────────────────────────────────────────────────────────────┐
│                     USER PROMPT                             │
├─────────────────────────────────────────────────────────────┤
│  1. Prompt file contents (.prompt.md body)                 │
│     Only present when you invoke a prompt via /command       │
│                                                             │
│  2. Environment info                                       │
│     OS, IDE version, available extensions                   │
│                                                             │
│  3. Workspace info                                         │
│     Project structure, folder layout                        │
│                                                             │
│  4. Context info                                           │
│     Current date/time, open terminals, attached files        │
│                                                             │
│  5. Your message                                           │
│     The actual text you type in the chat input               │
└─────────────────────────────────────────────────────────────┘
```

**Critical rule:** Prompt files inject into the USER prompt, NOT the system prompt. This is the most commonly misunderstood concept.

## Execution Contexts (v1.107+)

| Context | Runs | Isolation | Best For |
|---------|------|-----------|----------|
| **Local** | Interactive, in workspace | None — shares workspace | Quick tasks, debugging |
| **Background** | Autonomous, Git work trees | Full — isolated work tree | Long tasks without blocking |
| **Cloud** | Remote (GitHub), creates PRs | Full — separate branch | Async, team collaboration |

**Agent HQ** (v1.107+) is the unified interface for managing sessions across all three contexts. Plan mode can delegate to any context via “Start Implementation.” Sessions can hand off between contexts, carrying conversation history.

## Injection Summary by File Type

| File Type | Injects Into | Layer | Mechanism | Persistence |
|-----------|-------------|-------|-----------|-------------|
| `.instructions.md` | System prompt | 5 | Auto-injected via `applyTo` | Pattern-matched |
| `copilot-instructions.md` | System prompt | 5 (last) | Always injected | Always |
| `.agent.md` body | System prompt | 6 | When agent is active | Session-wide |
| `.prompt.md` body | User prompt | 1 | On-demand via `/command` | Single execution |
| Prompt-snippets | User prompt | (inline) | Manual via `#file:` | On-demand |
| Tool results | Context window | Appended | After tool execution | Per-invocation |

### How Multiple Instructions Combine

- Multiple `.instructions.md` files inject based on `applyTo` patterns — **no guaranteed order**
- Effect is **cumulative**: all matching instructions are included simultaneously
- `copilot-instructions.md` is **always injected last** — giving it final authority
- Use `excludeAgent` frontmatter to skip specific agents (e.g., `"code-review"`, `"coding-agent"`)

## Prompt-Snippets

Reusable context fragments included on-demand via `#file:` references in chat or prompt files:

```markdown
#file:.github/prompt-snippets/security-checklist.md
```

| Aspect | Prompt-Snippets | Instructions |
|--------|-----------------|---------------|
| Activation | Manual (`#file:...`) | Auto (`applyTo`) |
| Token control | Full (only when needed) | Always for matching files |
| Use case | Task-specific context | Universal standards |
| Location | `.github/prompt-snippets/` (convention) | `.github/instructions/` |

## Skills Progressive Loading

Skills (`.github/skills/*/SKILL.md`) use three-level loading to optimize tokens:

1. **Level 1** (Always): `name` + `description` (~50–100 tokens per skill)
2. **Level 2** (On match): SKILL.md body (~500–1,500 tokens)
3. **Level 3** (On reference): Resource files (loaded only when needed)

Enable: `"chat.useAgentSkills": true`

## Variable Substitution

Available variables in `.prompt.md` files:

| Variable | Description |
|----------|-------------|
| `${selection}` / `${selectedText}` | Currently selected text in the editor |
| `${file}` | Full path of the current file |
| `${fileBasename}` | Filename without path |
| `${fileDirname}` | Directory containing the current file |
| `${workspaceFolder}` | Root folder of the workspace |
| `${workspaceFolderBasename}` | Name of the workspace folder |
| `${input:variableName}` | Prompts user for input |
| `${input:variableName:placeholder}` | User input with placeholder text |

## Decision Guide

| If you want to... | Use | Injects into |
|---|---|---|
| Set persistent project rules | Custom instructions | System prompt (Layer 5) |
| Run a reusable workflow | Prompt file | User prompt (Layer 1) |
| Give the model a new identity | Custom agent | System prompt (Layer 6) |
| Route to a cheaper model | Prompt file (`model:` field) | User prompt |

---

## References

- **Internal**: [01-context-engineering-principles.md](./01-context-engineering-principles.md)
- **Sources**: `03.00-tech/05.02-prompt-engineering/02-getting-started/01.00-how_github_copilot_uses_markdown_and_prompt_folders.md`, articles 10.00 and 12.00
- **External**: [VS Code Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — extracted from article series analysis | System |
| 1.1.0 | 2026-02-22 | Added execution contexts, Agent HQ, instruction combination rules, prompt-snippets, skills loading | System |
