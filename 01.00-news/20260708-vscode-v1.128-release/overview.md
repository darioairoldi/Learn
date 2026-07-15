---
title: "VS Code release capabilities — investigation summary"
author: "Dario Airoldi"
date: "2026-07-15"
categories: [vscode, release, news]
description: "Investigation of the latest VS Code release capabilities and where the summary now lives."
---

# VS Code release capabilities — investigation summary

**Question investigated:** What are the new capabilities in the latest VS Code release?

## Short answer

This folder originally referenced **VS Code 1.129**, but at investigation time
1.129 was an **Insiders build with an empty release-notes skeleton** — no
published capabilities. The latest **stable** release with real content is
**VS Code 1.128** (July 8, 2026), which brings richer agent sessions, generally
available Copilot Vision, and several editor/enterprise conveniences.

The full capability breakdown lives in the summary article:

- 📄 [What's new in VS Code 1.128](01-summary.md)

## Highlights

- **Agents window** — multi-chat Claude sessions, workspace-less quick chats,
  read-only subagent chats (Preview), and chat keyboard shortcuts.
- **Chat & models** — Copilot Vision GA, BYOK in agent host, custom-endpoint
  sampling parameters, BYOK utility model, and `vscode://` deep links to a chat.
- **Editor** — configurable browser tab placement and OS-level keyboard shortcuts.
- **Enterprise** — managed Copilot telemetry export via OpenTelemetry.

## References

- [Visual Studio Code 1.128 release notes](https://code.visualstudio.com/updates/v1_128) 📘 [Official]
- Investigation trail: `_analysis/` (working notes, not published)
- Related: [VS Code v1.107 release summary](../20251224-vscode-v1.107-release/01-summary.md)
