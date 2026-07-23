---
title: "Proposed result package — VS Code 1.130"
publish: false
---

# Proposed result package

## Triage verdict

VS Code 1.130 is a **significant release** with two high-impact areas (Agent Host architecture, assisted tool approvals) and one notable engineering milestone (TypeScript 7). The remaining features are incremental improvements that are well-covered within a release summary.

## Coverage map summary

| Area | Coverage | Action |
|---|---|---|
| Agent Host + AHP | `partial` → release summary (deep update to `01.08` is gated) | Autonomous summary; gated restructure flagged |
| Assisted tool approvals | `absent` → covered in release summary | Autonomous |
| TypeScript 7 | `absent` → covered in release summary | Autonomous |
| Agents window UX | `partial` → covered in release summary | Autonomous |
| Chat/Terminal | `absent` (low impact) → covered in release summary | Autonomous |

## Source verdict

`sound` — All sources are first-party official documentation (📘) with full clarity, internal consistency, sufficient detail, and cross-corroboration between VS Code release notes, AHP documentation, VS Code docs, and TypeScript team blog.

## Priority tracks

1. Agent Host + AHP (`standard`)
2. Assisted tool approvals (`standard`)
3. TypeScript 7 (`quick`)
4. Agents window UX (`quick`)
5. Chat/Terminal (`quick`)

## Per-area conclusions

### Agent Host + AHP
The most architecturally significant change: agent sessions move from the extension host to a dedicated Agent Host process, communicating via the open AHP protocol. This enables shared multi-client sessions, remote execution, and agent runtime independence. It's the "LSP moment" for AI agents.

### Assisted tool approvals
A new permission paradigm where the model evaluates tool-call risk to reduce approval fatigue. Introduces dynamic, context-aware risk assessment as a middle tier between static deny/allow. Only available on the Agent Host.

### TypeScript 7
A native Go port delivering 8–12× build speedups with parallel type-checking. VS Code itself now compiles with TS 7. Practical impact: faster agentic feedback loops and sub-second editor diagnostics.

### Agents window UX
Incremental improvements: file-level diff stats, compact gutters, compact quick chats, and worktree support extended to Claude and Codex (previously Copilot-only).

### Chat & Terminal
Chat timestamps with hover detail. Aggregate credit usage for Business/Enterprise users. Git diff mnemonic prefix link resolution in terminal.

## Integration state

`completed` — Clear-gap autonomous integration as a release summary article.

## Open issues (gated)

- **Agent Host restructure.** The existing `01.08-chat-modes-agent-hq-and-execution-contexts.md` article should be restructured to reflect the Agent Host architecture. This is an overwrite of existing content and requires approval.
- **PE tool-composition update.** Assisted permissions should be added to the tool-composition guide as a new permission tier. Requires approval.
