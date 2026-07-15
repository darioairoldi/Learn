---
title: "Analysis — Agents window (VS Code 1.128)"
publish: false
---

# Analysis — Agents window

## Problem statement (investigation framing)

Understand how VS Code 1.128 changes the Agents window and what it enables for
agent-driven workflows.

## Considerations

- The Agents window is the primary surface for creating/resuming/managing sessions.
- 1.128 shifts it from single-session to **multi-chat, subagent-aware**.

## Deductions

- Multi-chat Claude sessions let a user compare approaches and parallelize work
  within one logical session (fork from a turn, peer chats, concurrent turns).
- Workspace-less quick chats broaden the window to ad-hoc questions, not just
  project work.
- Read-only subagent transcripts make delegated work observable without steering.

## Conclusions

The Agents window becomes a genuine multi-thread cockpit for agent workflows.
Most capabilities require the **agent host** (`chat.agentHost.enabled`), an
org-managed setting.

## Appendix A — Evidence

- VS Code 1.128 release notes → "Agents" section (multiple chats, quick chat,
  read-only subagent chats, keyboard shortcuts). 📘 Official.

## Appendix B — Validation

- Cross-checked settings names (`chat.agentHost.enabled`,
  `chat.agents.claude.preferAgentHost`, `sessions.list.showEmptyDefaultGroups`)
  directly against the release-notes text.
