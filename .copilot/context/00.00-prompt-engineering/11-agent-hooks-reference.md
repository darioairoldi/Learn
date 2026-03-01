# Agent Hooks Reference

**Purpose**: Quick reference for the 8 lifecycle events, JSON configuration schema, and I/O protocol for deterministic automation via agent hooks.

**Referenced by**: Agent files using hooks, orchestrator prompts, `.github/agents/*.agent.md`

---

## Overview

Agent hooks provide **deterministic** lifecycle automation — your code runs at specific events, not AI interpretation. Hooks execute shell commands with JSON stdin/stdout communication.

**Location**: `.github/hooks/*.json`

## When to Use Hooks vs Other Mechanisms

| Need | Use |
|---|---|
| Intercept/block tool calls | Hooks (`PreToolUse`) |
| Session lifecycle automation | Hooks (`SessionStart`/`Stop`) |
| Influence model behavior | Instructions or agents |
| File-specific coding standards | Instructions with `applyTo` |
| Reusable task workflows | Prompts or skills |
| Complex LLM reasoning | Prompts/agents (not hooks) |

## 8 Lifecycle Events

```
Session Start
    ├── SessionStart ——— Initialize resources, log session
    ├── UserPromptSubmit — Audit requests, inject context
    ├── PreToolUse ——— Block/allow/modify tool input
    │   └── [Tool executes]
    │       └── PostToolUse — Run formatters, log results
    ├── SubagentStart —— Track nested agents, inject context
    │   └── [Subagent runs]
    │       └── SubagentStop — Aggregate results, cleanup
    ├── PreCompact ——— Save state before context truncation
    └── Stop ————— Generate reports, cleanup, notify
```

| Event | When | Typical Use Cases |
|---|---|---|
| `SessionStart` | First prompt of new session | Init resources, validate project |
| `UserPromptSubmit` | User submits prompt | Audit, inject context |
| `PreToolUse` | Before any tool | Block/allow/modify input |
| `PostToolUse` | After tool completes | Formatters, logging |
| `SubagentStart` | Subagent spawned | Track nested agents |
| `SubagentStop` | Subagent completes | Aggregate results |
| `PreCompact` | Before context compacted | Save state |
| `Stop` | Session ends | Reports, cleanup |

## JSON Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": "./scripts/validate-tool.sh",
        "timeout": 15
      }
    ],
    "SessionStart": [
      {
        "type": "command",
        "command": "./scripts/init-session.sh"
      }
    ]
  }
}
```

| Property | Type | Required | Description |
|---|---|---|---|
| `type` | string | Yes | MUST be `"command"` |
| `command` | string | Yes | Default command |
| `windows` | string | No | Windows override |
| `linux` | string | No | Linux override |
| `osx` | string | No | macOS override |
| `cwd` | string | No | Working directory |
| `env` | object | No | Environment variables |
| `timeout` | number | No | Timeout in seconds (default: 30) |

## I/O Protocol

**Input** (stdin JSON):
```json
{
  "timestamp": "ISO-8601",
  "cwd": "/project/path",
  "sessionId": "uuid",
  "hookEventName": "PreToolUse",
  "transcript_path": "/path/to/transcript.json"
}
```
Plus event-specific fields (tool name, input, etc.).

**Output** (stdout JSON):
```json
{
  "continue": true,
  "stopReason": "",
  "systemMessage": "Additional context for model"
}
```

**Exit codes**: 0 = success (parse stdout), 2 = blocking error, other = non-blocking warning.

### PreToolUse-Specific Output

| Field | Values | Purpose |
|---|---|---|
| `permissionDecision` | `"allow"`, `"deny"`, `"ask"` | Control tool execution |
| `permissionDecisionReason` | string | Explain to model/user |
| `updatedInput` | object | Modified tool input |
| `additionalContext` | string | Extra context for model |

Priority: `deny` > `ask` > `allow`

### Stop-Specific

MUST check `stop_hook_active` field to prevent infinite loops when the Stop hook itself triggers another stop.

## Use Case Catalog

- **Security enforcement**: Block file writes outside approved directories
- **Code quality gates**: Run formatters after tool writes
- **Audit trails**: Log all tool calls with timestamps
- **Context injection**: Add project-specific context at session start
- **Approval control**: Require confirmation for destructive operations
- **Subagent governance**: Track and limit nested agent invocations

---

## References

- **Internal**: [12-orchestrator-design-patterns.md](./12-orchestrator-design-patterns.md)
- **Source**: `03.00-tech/05.02-prompt-engineering/04-howto/09.00-how_to_use_agent_hooks_for_lifecycle_automation.md`
- **External**: [VS Code Agent Hooks](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-02-22 | Initial version — 8 events, JSON schema, I/O protocol, use cases | System |
