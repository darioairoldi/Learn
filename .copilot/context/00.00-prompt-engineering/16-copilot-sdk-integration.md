# Copilot SDK Integration Patterns

**Purpose**: Decision framework for consuming prompt engineering artifacts (prompt files, agent definitions, instruction files, skills, MCP servers) from SDK-based applications outside VS Code.

**Referenced by**: SDK application development prompts, multi-surface deployment agents, CI/CD integration prompts

---

## What the SDK Is

The **GitHub Copilot SDK** (technical preview, January 2026) brings Copilot's agentic loop to any application. Available for Node.js, Python, Go, and .NET. The critical insight: **the SDK consumes the same files you already write**.

## Architecture

```
Your Application (Node.js/Python/Go/.NET)
    │ JSON-RPC
    ▼
Copilot CLI (server mode)
    │ Discovers: .prompt.md, .agent.md, .instructions.md, SKILL.md, MCP servers
    ▼
Copilot API → Models (GPT-5, Claude, Gemini, etc.)
```

The SDK manages the CLI process lifecycle automatically. The CLI performs workspace scanning to discover prompt engineering artifacts.

## VS Code vs SDK Feature Comparison

| Feature | VS Code | SDK Apps |
|---|---|---|
| Interactive `#file` picker | ✅ | ❌ |
| Slash commands | ✅ | ❌ (programmatic) |
| Chat modes (Agent/Plan/Ask/Edit) | ✅ | ❌ |
| Visual diff review | ✅ | ❌ |
| `.prompt.md` files | ✅ | ✅ (loaded programmatically) |
| `.agent.md` files | ✅ | ✅ (via session config) |
| `.instructions.md` (auto `applyTo`) | ✅ | ✅ |
| `SKILL.md` discovery | ✅ | ✅ |
| MCP servers | ✅ | ✅ (via `mcp.json`) |

## YAML Frontmatter Behavior Differences

| Field | VS Code | SDK |
|---|---|---|
| `name` | Sets slash command | Identification only |
| `description` | Shown in picker | Metadata only |
| `agent` | Sets chat mode | Agent definition applied |
| `model` | Sets session model | Respected if session allows |
| `tools` | Restricts tools | Restricts tools ✅ |

**Key**: `tools` field provides identical tool restriction behavior across both surfaces.

## SDK Usage Patterns

### Loading Prompts Programmatically

```typescript
const promptContent = readFileSync(".github/prompts/review.prompt.md", "utf-8");
const session = await client.createSession({ model: "gpt-5" });
await session.send({ prompt: promptContent });
```

### Using Agents

```typescript
const session = await client.createSession({
    model: "claude-opus-4.6",
    agent: "security-reviewer",  // → .github/agents/security-reviewer.agent.md
});
```

### Multi-Model Routing (Model-Per-Task)

```typescript
// Fast model for classification
const triage = await client.createSession({ model: "gpt-4o" });
// Frontier model for deep analysis
const analysis = await client.createSession({ model: "claude-opus-4.6" });
```

## MCP Integration

MCP servers configured via `mcp.json` (shared with VS Code):

```json
{
  "servers": {
    "validation-server": {
      "command": "dotnet",
      "args": ["run", "--project", "src/McpServer/"]
    }
  }
}
```

Tool call flow: SDK App → CLI Server → Model → MCP Server → result → Model → response. The agentic loop manages all orchestration automatically.

## Memory and Persistence

- **Session persistence**: Context maintained across multiple `send()` calls
- **Intelligent compaction**: Auto-compacts when approaching token limits (300-turn threshold, ~15% retention of most relevant content)
- **Infinite sessions**: Long workflows don't fail from overflow

## Prompt Engineering Implications

### What Transfers Directly
All prompt engineering patterns from articles 01–13 apply without modification:
- Context engineering principles
- Tool composition and restriction
- Progressive disclosure in skills
- Instruction file scoping via `applyTo`

### What Requires Adaptation
- **No `#file:` references** — load file content programmatically instead
- **No slash commands** — invoke prompts via API calls
- **No chat modes** — specify agent in session configuration
- **Manual prompt discovery** — scan workspace programmatically or use CLI scanning

## Billing Considerations

- Each `send()` counts toward **premium request quota**
- SDK usage follows same billing as Copilot CLI
- Premium model multipliers apply (e.g., Claude Opus 4.6 has higher cost multiplier)
- Enterprise and individual plans have different quotas

## When to Use SDK vs VS Code

| Scenario | Recommendation |
|---|---|
| Interactive development | VS Code |
| CI/CD pipeline integration | SDK |
| Custom tooling / dashboards | SDK |
| Batch processing (many files) | SDK |
| Team onboarding workflows | VS Code + Spaces |
| Automated code review | SDK |

---

## References

- **Internal**: [07-prompt-assembly-architecture.md](./07-prompt-assembly-architecture.md), [02-tool-composition-guide.md](./02-tool-composition-guide.md), [14-mcp-server-design-patterns.md](./14-mcp-server-design-patterns.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/14.00-how_to_use_prompts_with_the_github_copilot_sdk.md`
- **External**: [GitHub Copilot SDK](https://github.com/github/copilot-sdk), [Copilot Billing](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-23 | Initial version — architecture, feature comparison, usage patterns, billing | System |
