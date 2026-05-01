---
title: "Self-updating prompt engineering — Design workspace"
author: "Dario Airoldi"
date: "2026-05-01"
---

# Self-updating prompt engineering — Design workspace

This folder is the **active design workspace** for the self-updating prompt engineering system. It contains vision documents, improvement plans, and decision logs that drive the implementation in `.github/agents/`, `.github/prompts/`, and `.copilot/context/00.00-prompt-engineering/`.

## Relationship to published articles

This folder is the **workshop**. The published articles in `03.00-tech/05.02-prompt-engineering/05-analysis/` are the **showroom**.

- **Ideas** (here) → design decisions, rationales, review findings, improvement logs
- **Articles** (there) → distilled, reader-facing explanations derived from idea docs
- **Flow** → Ideas inform articles, but are never copied verbatim. Articles cite idea docs for "full design history."

## Current files

| File | Purpose | Status |
|---|---|---|
| `20260428.01-vision.v7.md` | Current vision — defines WHY the system exists, WHAT it aims for, design principles, rationales | Living (loaded by pe-meta agents) |
| `20260428.01-vision.v7-further-improvements.md` | Deferred backlog with trigger conditions | Living (items graduate to active work) |

## Completed improvement logs (in `old/`)

| File | Scope | Date |
|---|---|---|
| `20260430.01 pe-gra-improvements.md` | Round 1: tool alignment, category refs, handoff contracts, boundaries | 2026-04-30 |
| `20260501.01 pe-gra-improvements.md` | Round 2: validator contracts, tool guidance, loop caps, tool-failure recovery | 2026-05-01 |
| `20260501.01 pe-gra-improvements.v1.md` | Slash-command reference fixes + validation gap closure | 2026-05-01 |

## Archive (`old/`)

Contains all prior vision versions (v1–v6), superseded improvement plans, and intermediate working documents. These preserve the design evolution history — don't delete them, but don't expect them to be current.

## How to use this workspace

1. **Start a new improvement cycle** → create a new dated file (e.g., `20260601.01-topic.md`)
2. **Run a strategic review** → use `/pe-meta-review` on target artifacts, log findings here
3. **Update the vision** → increment version, update `vision.vN.md`, move prior version to `old/`
4. **Publish to articles** → distill stable findings into `03.00-tech/05.02-prompt-engineering/05-analysis/`
