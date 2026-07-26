---
title: "Existing coverage map — VS Code 1.130 (duplicate entry)"
publish: false
---

# Existing coverage map

## Headline finding: PRESENT (duplicate)

The `20260723.01-vscode-rel` stub is the **same release** (VS Code 1.130, July 22, 2026) already documented by the canonical article:

- **Canonical article:** [`../../20260722-vscode-v1.130-release/01-summary.md`](../../20260722-vscode-v1.130-release/01-summary.md) — "What's new in VS Code 1.130"

## Coverage by area

| Area | Coverage | Local evidence (canonical) | Taxonomy |
|---|---|---|---|
| Agent Host + AHP | `present` | Canonical §"The Agent Host and AHP" (process model, AHP sync, remote host, opt-in) | Overview / News |
| Assisted tool approvals | `present` | Canonical §"Assisted tool approvals" (three-tier permission model) | Overview / News |
| Agents window UX | `present` | Canonical §"Agents window improvements" (diff stats, compact diff, quick chats, worktrees) | Overview / News |
| Chat timestamps & credit usage | `present` | Canonical §"Chat" | Overview / News |
| Terminal mnemonic-prefix links | `present` | Canonical §"Terminal" | Overview / News |
| TypeScript 7 | `present` | Canonical §"Engineering: TypeScript 7" | Overview / News |

## Net-new content in the stub

None. Every capability in the raw notes maps to an existing section of the canonical summary. No unique information would be lost by consolidating. (The stub additionally contains the "Thank you / contributions" PR list, which is not article-worthy signal.)

## Consequence for integration

Because coverage is `present`, this is **not** a clear-gap autonomous article creation. Creating a second 1.130 article would violate the least-redundancy principle. The correct outcome is **consolidation**: the stub becomes a summary-with-references pointing to the canonical article.
