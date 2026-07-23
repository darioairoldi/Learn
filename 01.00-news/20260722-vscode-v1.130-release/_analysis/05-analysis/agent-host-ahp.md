---
title: "Agent Host architecture + AHP — analysis"
publish: false
---

# Agent Host architecture + AHP

## Problem

VS Code is shifting agent session orchestration from the extension host to a dedicated **Agent Host** process. This is a fundamental architectural change that affects how sessions are managed, where agents run, and how clients connect. The existing LearnHub article (`01.08-chat-modes-agent-hq-and-execution-contexts.md`) describes "Agent HQ" as a UI surface for managing sessions, but doesn't explain the underlying architectural shift to a separate process model.

## Considerations

1. **Process isolation.** The Agent Host runs as a dedicated process, separate from the extension host. This means agent sessions aren't blocked by busy extensions, and agents can continue running when no editor window is connected.

2. **Agent Host Protocol (AHP).** A new open protocol (in the lineage of LSP and DAP) that uses JSON-RPC for communication and immutable state with pure reducers for synchronized session data. Key properties:
   - Totally ordered mutations (monotonic sequence numbers)
   - Optimistic local application with server-echo reconciliation
   - URI-addressed channels for sessions, chats, terminals, changesets
   - Reconnection with missed-action replay or fresh snapshot

3. **Multi-client shared sessions.** Because the host owns authoritative session state, multiple VS Code windows (or other AHP clients) can observe and control the same agent session simultaneously. This is the key differentiator from the extension-host model.

4. **Remote execution.** The Agent Host can run as a standalone process on a remote machine, exposed over WebSocket. Clients connect via SSH or dev tunnels, keeping the UI local while workspace operations run close to the source code.

5. **Agent adapters.** Different agent runtimes (Copilot, Claude, Codex) plug into the host through adapters that translate between their native runtime and the common AHP session model. This means new agent backends can be added without changing the client.

6. **Copilot SDK alignment.** The Copilot agent on the Agent Host is powered by the Copilot SDK, aligning behavior across the Copilot CLI, the standalone GitHub Copilot app, and VS Code.

7. **Client-contributed tools.** While the Agent Host is self-contained, connected clients can contribute tools (browser tools, extension-provided tools) that the host routes tool calls back to.

## Deductions

- **D1.** The Agent Host represents a shift from "agent as extension" to "agent as first-class infrastructure" — this is the same pattern that moved language services from extensions to LSP.
- **D2.** AHP's totally-ordered immutable state model is designed for multi-client correctness, not just single-window convenience. This suggests future scenarios like collaborative agent sessions or mobile/web clients.
- **D3.** The `code agent host` CLI command and `--tunnel` option indicate that remote agent hosting is a first-class scenario, not an afterthought.

## Conclusions

The Agent Host + AHP represents the most significant architectural change to VS Code's AI features since the introduction of Copilot Chat. It moves agent session orchestration to a dedicated process, enables multi-client shared sessions, and provides a protocol foundation for future extensibility. This release (1.130) marks the point where the Agent Host becomes the recommended runtime for agent features, with new capabilities (assisted permissions, worktree support) available only on the Agent Host.

## Appendix A — Evidence

| Source | Classification | Key evidence |
|---|---|---|
| VS Code 1.130 release notes | 📘 Official | Agent Host description, AHP mention, settings |
| AHP documentation site | 📘 Official | Protocol specification, architecture diagram |
| VS Code Agent Host architecture page | 📘 Official | Process model, remote hosts, client tools |
| Build 2026 — "Claude is in Copilot" | 📘 Official | AHP introduction in presentation context |

## Appendix B — Validation

Conclusions validated against three official Microsoft sources (release notes, AHP documentation, VS Code docs). All sources are consistent and reinforce each other.
