---
title: "What's new in VS Code 1.128"
author: "Dario Airoldi"
date: "2026-07-08"
categories: [vscode, release, agents, chat]
description: "Overview of Visual Studio Code 1.128 — multi-chat agent sessions, workspace-less quick chats, Copilot Vision GA, browser tab placement, OS-level shortcuts, and OpenTelemetry."
---

# What's new in VS Code 1.128

Visual Studio Code **1.128** (released **July 8, 2026**) focuses on richer agent
sessions, generally available image support in Chat, and workflow conveniences
across the editor and enterprise controls. This article summarizes the
capabilities that matter most for day-to-day AI-assisted development.

**Source:** [Visual Studio Code 1.128 release notes](https://code.visualstudio.com/updates/v1_128) 📘 [Official]
· [Downloads and updates](https://code.visualstudio.com/updates)

![Visual Studio Code](https://code.visualstudio.com/opengraphimg/opengraph-home.png)

## Table of contents

- [Release at a glance](#release-at-a-glance)
- [Agents window](#agents-window)
- [Chat and models](#chat-and-models)
- [Editor experience](#editor-experience)
- [Enterprise](#enterprise)
- [Where this fits](#where-this-fits)
- [References](#references)

## Release at a glance

| Capability | What it does | Availability |
|---|---|---|
| Multi-chat Claude sessions | Run several related chats in one Claude session to compare, branch, and parallelize | Agent host |
| Quick chats | Ask a question in the Agents window without opening a workspace | Agent host |
| Read-only subagent chats | Follow delegated subagents' transcripts without steering them | Preview |
| Chat keyboard shortcuts | Keyboard-driven navigation of chats within the Agents window | Agent host |
| Copilot Vision | Attach images and PDFs to Chat (paste, drag-drop, context menu) | Generally available |
| BYOK in agent host | Use bring-your-own-key models in agent host Copilot sessions | Experimental |
| Custom endpoint sampling | Configure `temperature` / `top_p` per custom-endpoint model | Stable |
| BYOK utility model | Choose which model powers title/commit-message generation with BYOK | Stable |
| Deep links to a chat | `vscode://` links open the workspace and focus a specific chat | Stable |
| Browser tab placement | Choose where integrated browser tabs open (active/side/window) | Stable |
| OS-level shortcuts | Keybindings that fire even when VS Code isn't focused | Stable |
| OpenTelemetry export | Managed Copilot telemetry export to an approved collector | Enterprise |

## Agents window

The Agents window is a dedicated place to create, resume, and manage agent
sessions. Release 1.128 makes it substantially richer.

- **Multiple chats per session (Claude).** A Claude agent-host session can now
  hold several related chats instead of spreading them across separate
  top-level sessions. You can add chats, fork a chat from an earlier turn,
  switch between peer chats, and send turns concurrently — for example, one
  chat adds a `/health` endpoint while a peer writes its tests in parallel and a
  forked chat explores an alternative. Each chat keeps its own history, title,
  and model, and restores with the parent session after restart. Enabled via
  `chat.agentHost.enabled` and `chat.agents.claude.preferAgentHost`.
- **Chat without a selected workspace.** For questions not tied to a folder, you
  can start a workspace-less quick chat (`Cmd+K Cmd+N`, or the plus button on
  the Chats section). Quick chats have no Changes/Files side pane, are restored
  after reload, and stay separate from workspace sessions. Supported by agent
  host sessions only.
- **Read-only subagent chats (Preview).** When a session spawns subagents, their
  transcripts appear as read-only peer chats — hidden from the tab strip until
  opened from the Conversations menu, the running-subagents chip, or the inline
  subagent pill. Opened subagent chats show live progress and omit the composer
  so the worker transcript stays view-only.
- **Keyboard shortcuts for chats.** Create (`Cmd+T`), reopen last closed
  (`Shift+Cmd+T`), next/previous (`Shift+Cmd+]` / `Shift+Cmd+[`), quick switch
  (`Ctrl+Tab` / `Ctrl+Shift+Tab`), close active tab (`Cmd+W`), delete active
  non-main chat (`Cmd+Backspace`), and a searchable picker (`Shift+Cmd+O`).
  Shortcuts are scoped to the Agents window.

## Chat and models

- **Copilot Vision is generally available.** Multimodal support is now GA: attach
  images and PDFs by pasting, dragging and dropping, or via the context menu.
  The agent can also read images via a tool call. See the
  [GitHub changelog](https://github.blog/changelog/2026-07-01-copilot-vision-is-generally-available/)
  for supported formats.
- **BYOK models in agent host sessions (Experimental).** Enable
  `chat.agentHost.byokModels.enabled` and restart the agent host to use
  bring-your-own-key models on an agent host.
- **Sampling parameters for custom endpoints.** Add a `modelOptions` object to a
  model's JSON config to set `temperature` and `top_p`. A number overrides the
  default VS Code sends; `null` omits the parameter so the server's default
  applies. Works with Chat Completions, Responses, and Messages-compatible
  endpoints.
- **Default utility model for BYOK.** `chat.byokUtilityModelDefault` controls
  which model powers built-in utility flows (chat title, commit message) when a
  BYOK model is the main agent. By default no utility model is used with BYOK,
  so those background tasks don't run unless this is set. Ignored when the main
  model is a GitHub Copilot model.
- **Deep links to a specific chat.** When an app opens a `vscode://` session
  deep link, VS Code opens the workspace and focuses the chat identified by the
  link's `session` query parameter. The Agents window's *Open in VS Code* action
  uses the same behavior.

## Editor experience

- **Configurable browser tab placement.** `workbench.browser.newTabPlacement`
  controls where integrated browser tabs open: `activeGroup` (default),
  `sideGroup` (a locked dedicated side group), or `window` (a locked auxiliary
  window). Pages opened from an existing tab open in the parent's group.
- **OS-level keyboard shortcuts.** Add `"systemWide": true` to a keybinding in
  `keybindings.json` so it fires even when VS Code isn't focused — for example,
  focusing the Agents window from anywhere.

## Enterprise

- **Manage Copilot telemetry export with OpenTelemetry.** Organizations can
  mandate where GitHub Copilot sends OpenTelemetry (OTel) data so it flows to an
  approved collector without each developer setting `OTEL_*` variables. Delivered
  through the `telemetry` block in Copilot managed settings, it controls the OTLP
  endpoint and protocol, service name and resource attributes, exporter headers,
  and whether prompt/response content is captured. A managed value takes
  precedence over environment variables and user settings.

## Where this fits

This continues the trajectory from the earlier
[VS Code v1.107 release](../20251224-vscode-v1.107-release/01-summary.md), which
introduced the unified agentic experience (Agent HQ), model management, and
bring-your-own-key support. Release 1.128 deepens the Agents window into a
multi-chat, subagent-aware workspace and graduates Copilot Vision to general
availability.

**Next release:** [What's new in VS Code 1.130](../20260722-vscode-v1.130-release/01-summary.md) — Agent Host architecture, assisted tool approvals, cross-harness worktrees, TypeScript 7.

## References

**[Visual Studio Code 1.128 release notes](https://code.visualstudio.com/updates/v1_128)** 📘 [Official]
Complete official release notes for VS Code 1.128, covering Agents, Chat, Editor
Experience, and Enterprise. The authoritative source for every capability in this
summary.

**[Copilot Vision is generally available](https://github.blog/changelog/2026-07-01-copilot-vision-is-generally-available/)** 📗 [Verified Community]
GitHub changelog detailing supported image/PDF formats and availability for the
now-GA multimodal Chat support.

**[VS Code Updates](https://code.visualstudio.com/updates)** 📘 [Official]
Landing page for all VS Code release notes and downloads, including links to
previous versions.
