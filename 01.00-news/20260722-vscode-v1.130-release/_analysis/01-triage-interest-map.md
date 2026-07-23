---
title: "Triage & interest map — VS Code 1.130 release"
publish: false
---

# Triage & interest map

## Intake

- `explicit_question`: "analyze interesting areas of the news" (VS Code 1.130 release notes)
- `pain_signal`: keep LearnHub current with the latest VS Code release
- `decision_pressure`: low (informational/currency)
- `domain_scope`: VS Code / AI-assisted development tooling

## Context signals (harvest)

- **Active file:** `01.00-news/20260722-vscode-v1.130-release/overview.md` — raw paste of VS Code 1.130 release notes.
- **Sibling releases:** `01.00-news/20260708-vscode-v1.128-release/` — prior VS Code release summary (establishes local convention: `overview.md` raw + `01-summary.md` reader-facing article + `_analysis/` working folder).
- **Repo scan:**
  - Agent Host mentioned in Build 2026 session (Claude in Copilot).
  - `03.00-tech/05.02-prompt-engineering/03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md` covers Agent HQ UI and execution contexts but uses extension-host-era architecture.
  - Assisted permissions (`chat.assistedPermissions.enabled`) not mentioned anywhere except this release.
  - TypeScript 7 not covered in any existing article.
  - Worktree support is documented as Copilot-only in existing content.

## Candidate areas (seeded from question + context)

| Area | relevance | urgency | learning_impact | confidence |
|---|---|---|---|---|
| Agent Host architecture + AHP | 5 | 4 | 5 | high |
| Assisted tool approvals (model-evaluated risk) | 5 | 3 | 5 | high |
| Agents window UX (compact diffs, stats, worktrees) | 4 | 2 | 3 | high |
| Chat timestamps & credit usage visibility | 2 | 1 | 2 | high |
| Terminal mnemonic prefix links | 2 | 1 | 1 | high |
| TypeScript 7 (engineering milestone) | 4 | 2 | 4 | high |
