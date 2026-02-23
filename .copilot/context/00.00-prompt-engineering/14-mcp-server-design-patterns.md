# MCP Server Design Patterns

**Purpose**: Architecture overview and decision framework for when and how to build custom MCP servers vs using other customization types.

**Referenced by**: MCP server implementation tasks, tool extension decisions, `.vscode/settings.json` MCP config

---

## Architecture Overview

MCP (Model Context Protocol) servers run as **separate processes** communicating via JSON-RPC 2.0. They provide tools, resources, and prompts to any MCP-compatible AI client.

| Concept | Description |
|---------|-------------|
| Server | Process providing tools, resources, prompts |
| Client | AI assistant connecting to servers |
| Tools | Functions the AI calls to perform actions |
| Resources | Data sources the AI reads |
| Transport | Communication: stdio (local) or SSE/HTTP (remote) |

**Benefits of process isolation**: Language independence, crash isolation, security boundaries, independent scaling.

## When to Build vs Use Alternatives

**Build an MCP server when you need to:**
- Query external systems (databases, APIs, internal services)
- Access live data (real-time metrics, monitoring)
- Perform complex computations
- Enforce business logic (validation, compliance)
- Integrate proprietary/legacy tools
- Share capabilities across projects and teams

**Use alternatives instead when:**

| Need | Use |
|------|-----|
| Coding standards/rules | Instruction files |
| Reusable task with user input | Prompt files |
| Persistent AI persona | Agent files |
| Workflow with scripts/templates | Skill files |

## Transport Decision

| Transport | Use case | Recommendation |
|-----------|----------|----------------|
| **stdio** | Local servers | **Default and recommended** for Copilot |
| **SSE/HTTP** | Remote/shared servers | Requires authentication setup |

## Server Lifecycle

```
1. INITIALIZATION: Client discovers server (mcp.json) → spawns process → server sends capabilities
2. CAPABILITY NEGOTIATION: Client asks "What can you do?" → Server lists tools (JSON Schema), resources, prompts
3. RUNTIME OPERATION: Client sends tool requests → Server executes → returns structured results (repeat)
4. SHUTDOWN: Client terminates server process → server cleans up resources
```

## Three MCP Primitives

| Primitive | Purpose | Direction | Example |
|---|---|---|---|
| **Tools** | Actions the AI calls | AI → Server | `validate_yaml`, `query_database` |
| **Resources** | Read-only data the AI accesses | Server → AI | `config://settings`, `metrics://cpu` |
| **Prompts** | Reusable template fragments | Server → AI | Common instruction sets, boilerplate |

Tools are the primary primitive for Copilot integration. Resources and Prompts provide supplementary context without requiring tool invocations.

## Tool Definition Anatomy

Every tool requires 4 components:

| Component | Purpose |
|---|---|
| **Name** | Unique identifier (e.g., `validate_yaml`) |
| **Description** | What it does — **AI uses this to decide when to call** |
| **Input Schema** | JSON Schema with required/optional parameters |
| **Handler** | Function that executes the tool logic |

**Description quality is critical**: The AI matches user intent to tool descriptions. Vague descriptions → wrong tool selection. Specify what, when, inputs, and outputs.

## Tool Design Rules

1. **Single-purpose** — if tempted to add an `action` parameter, split into multiple tools
2. **Descriptive descriptions** — include what, when, expected inputs/outputs
3. **Proper JSON Schema** — use `required`, `enum`, `minimum/maximum`, `additionalProperties: false`
4. **Structured results** — return typed objects with `success`, `error.code`, `error.message`, not vague strings

## Error Handling

Return structured errors via JSON-RPC:
- Use meaningful error codes (`VALIDATION_FAILED`, `NOT_FOUND`, `TIMEOUT`)
- Include actionable suggestions in error messages
- Always return `line`/`column` for parsing errors
- Log server-side but return user-friendly messages

## Agent-Level MCP Configuration

Agents can declare MCP servers in their YAML frontmatter:

```yaml
# .agent.md
---
tools:
  - mcp: my-validation-server
---
```

The `mcp:` prefix references servers defined in `mcp.json` or `.vscode/settings.json`, scoping specific MCP tools to specific agents.

## SDK Comparison

| Aspect | TypeScript | C# (.NET) | Python |
|--------|-----------|-----------|--------|
| Startup | Fast (<100ms) | Medium (~200ms) | Fast (<100ms) |
| Memory | Medium | Higher (CLR) | Lower |
| Best for | Web, npm ecosystem | Enterprise, .NET codebases | AI/ML, prototyping |
| Style | Functional | Attribute-based, DI | Decorator (FastMCP) |

All SDKs support identical capabilities. The client doesn't know or care what language the server uses.

### Language Selection

| If you need... | Choose |
|----------------|--------|
| Quick prototyping | Python (FastMCP) |
| npm ecosystem access | TypeScript |
| Enterprise/.NET integration | C# (.NET) |
| AI/ML capabilities | Python |
| Maximum type safety | C# or TypeScript |

## Tool Design Best Practices

1. **Descriptive descriptions** — AI uses descriptions to decide when to call tools
2. **Single-purpose tools** — If tempted to add an `action` parameter, split into multiple tools
3. **Proper JSON Schema** — Leverage input validation
4. **Structured results** — Return typed objects, not vague strings

## MCP vs Other Customization Types

| Feature | MCP Server | Skill | Agent | Prompt |
|---------|-----------|-------|-------|--------|
| Purpose | Add tools/data | Bundle workflows | AI persona | Reusable task |
| Language | Any | Markdown | Markdown | Markdown |
| Complexity | High | Medium | Low | Low |
| Cross-platform | Any MCP client | VS Code, CLI, Agent | VS Code only | VS Code only |

---

## References

- **Internal**: [02-tool-composition-guide.md](./02-tool-composition-guide.md), [13-file-type-decision-guide.md](./13-file-type-decision-guide.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/07.00-how_to_build_mcp_servers_for_extending_agent_capabilities.md`
- **External**: [MCP Specification](https://modelcontextprotocol.io/), [VS Code MCP](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — architecture, decision framework, SDK comparison | System |
| 1.1.0 | 2026-02-23 | Added server lifecycle, 3 primitives, tool definition anatomy, design rules, error handling, agent MCP config | System |
