---
title: "Existing coverage map — VS Code 1.130"
publish: false
---

# Existing coverage map

## Coverage by area

| Area | Coverage | Local evidence | Taxonomy |
|---|---|---|---|
| Agent Host architecture + AHP | `partial` | `01.08-chat-modes-agent-hq-and-execution-contexts.md` covers Agent HQ UI but uses extension-host-era framing; Build 2026 session summary mentions AHP briefly | Concepts |
| Assisted tool approvals | `absent` | Only static permission settings covered (`chat.permissions.default`, `chat.tools.global.autoApprove`); no model-evaluated risk concept | Concepts |
| Agents window UX (compact diffs, worktrees) | `partial` | v1.107 and v1.128 release summaries; `01.08` article describes worktrees as Copilot-only | Overview / News |
| Chat timestamps & credit usage | `absent` | Not covered (low learning impact) | Overview / News |
| Terminal mnemonic prefix links | `absent` | Not covered (low learning impact) | Overview / News |
| TypeScript 7 | `absent` | No article; only mentioned in v1.130 overview | Overview / News |

## Integration priority assessment

- **Agent Host + AHP**: The architectural shift from extension host to Agent Host is a *foundational change* to how VS Code's AI features work. The existing `01.08` article would need restructuring to capture this — that's an **overwrite/restructure** → **gated**.
- **Assisted tool approvals**: Entirely new concept. Clear gap, additive → **autonomous** (as part of the release summary).
- **TypeScript 7**: New topic, clear gap → **autonomous** (as part of the release summary, with a note that a dedicated tech article could follow).
- **Agents window UX / Chat / Terminal**: Incremental changes → covered within the release summary.
