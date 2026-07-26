---
title: "Triage & interest map — Agent Framework Declarative Workflows 1.0"
publish: false
---

# Triage & interest map

## Intake

- `explicit_question`: Analyze the news "Move Agent Orchestration/Workflows out of Code with Agent Framework Declarative Workflows 1.0" for the Learning Hub.
- `pain_signal`: Multi-agent orchestration wired in application code is hard to review, version, and change.
- `decision_pressure`: Low/medium — this is a capability announcement to understand and record, not an urgent decision.
- `domain_scope`: AI agents / multi-agent orchestration / Microsoft Agent Framework SDK (.NET + Python).

## Context signals (harvest)

- **Active file**: `01.00-news/20260726-…/overview.md` — a bare title + source URL + header image (`images/001.01-article-title.png`), the standard raw-news stub.
- **Sibling news**: same folder pattern as `20260716.01-reverse-paradox` and `20260710.01-loop-engineering` — each turns `overview.md` into a full reader-facing article with a source-provenance callout, and keeps working notes under `_analysis/`.
- **Repo scan** (`grep`): "Agent Framework" / "orchestration" / "multi-agent" appear in:
  - `03.00-tech/05.02-prompt-engineering/04-howto/10.00…`, `11.00…`, `12.00…`, `09.50…` — orchestration **of GitHub Copilot prompt/agent files** (a different layer than the Agent Framework SDK).
  - `02.00-events/202606-build-2026/…` — event summaries mentioning Microsoft Agent Framework and multi-agent workflows (talks, not reference articles).
  - `.copilot/context/00.00-prompt-engineering/02.0x…` — PE handoff/orchestrator patterns (customization-file authoring, not the SDK).

## Candidate areas (seeded from question AND context)

| # | Area | relevance | urgency | learning_impact | confidence |
|---|---|---|---|---|---|
| A | Agent Framework **Declarative Workflows 1.0** — what it is, YAML authoring, .NET/Python runtime | 5 | 3 | 5 | high |
| B | Where it sits vs the Hub's existing **Copilot prompt-file orchestration** how-tos (different layer) | 4 | 2 | 4 | high |
| C | Meta/architecture impact on Hub visions or PE artifacts | 1 | 1 | 1 | high |

## Triage verdict

Single dominant tech area (**A**), with a cross-linking concern (**B**). No meta/architecture impact (**C** ruled out). Additive tech-article integration.
