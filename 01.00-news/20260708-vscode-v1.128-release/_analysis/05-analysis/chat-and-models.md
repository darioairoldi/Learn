---
title: "Analysis — Chat & models (VS Code 1.128)"
publish: false
---

# Analysis — Chat & models

## Problem statement (investigation framing)

Understand the Chat and model-configuration changes in VS Code 1.128.

## Deductions

- **Copilot Vision GA** is the headline: images/PDFs are now a supported,
  general-availability input channel (paste, drag-drop, context menu, tool read).
- BYOK expands into agent-host sessions (Experimental) and gains a utility-model
  control so background flows (title/commit generation) can work with BYOK.
- Custom-endpoint `modelOptions` (`temperature`/`top_p`) improve compatibility
  with strict providers; `null` defers to the server default.
- Deep links (`vscode://` with a `session` param) make chats directly addressable.

## Conclusions

1.128 improves both multimodal input (Vision GA) and BYOK/custom-model ergonomics.

## Appendix A — Evidence

- VS Code 1.128 release notes → "Chat" section. 📘 Official.
- Copilot Vision GA → GitHub changelog (2026-07-01). 📗 Verified community.

## Appendix B — Validation

- Setting names and the `modelOptions` JSON shape copied verbatim from notes.
