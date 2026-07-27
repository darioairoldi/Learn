---
title: "Triage and interest map — gpt-oss on Azure AI Foundry / Windows AI Foundry"
publish: false
---

# Triage and interest map

## Step 1 — Intake

| Field | Value |
|---|---|
| `explicit_question` | Analyze the Tech Community post about gpt-oss on Azure AI Foundry and Windows AI Foundry. Does it have an impact on LearnHub content? |
| `pain_signal` | Uncertainty about whether a captured link is worth turning into Hub content |
| `decision_pressure` | Low — no deadline; this is a "should I keep this?" triage |
| `domain_scope` | Open-weight models, Microsoft Foundry (formerly Azure AI Foundry), Foundry Local, Windows AI Foundry, local/edge inference |

## Step 1b — Context harvest (`context_signals`)

| Signal | Evidence |
|---|---|
| Active file | `01.00-news/20260726.02-gpt-oss-on-foundry/overview.md` — a raw stub containing only the URL |
| Folder convention | Date prefix `20260726.02` implies a July 26, 2026 news item; the **source is dated August 5–6, 2025** — a ~12-month mismatch |
| Sibling issue | `20260726.01-move-agent-orchestration-workflows-out-of-code-with-AFDW/` — same date, fully integrated via this workflow; sets the local convention (`overview.md` = the reader-facing article, `_analysis/` = working artifacts) |
| Repo scan — `gpt-oss` | **0 matches repo-wide** |
| Repo scan — `Foundry Local` / `Windows AI Foundry` | **98 matches across 13 files**, concentrated in `02.00-events/202506-build-2025/` and `02.00-events/202606-build-2026/` |
| Terminology drift | The source's own page surfaces sibling posts using **"Microsoft Foundry"** (July 2026) — the "Azure AI Foundry" branding in the source has since been superseded |

## Step 2 — Candidate areas

| # | Candidate area | Relevance | Urgency | Learning impact | Confidence |
|---|---|---|---|---|---|
| A1 | gpt-oss model family specifics (120b / 20b, sizes, hardware envelope, pricing) | 2 | 1 | 2 | high |
| A2 | Foundry Local / Windows AI Foundry as a local-inference runtime | 5 | 1 | 4 | high |
| A3 | Open-weight vs proprietary model selection (control, sovereignty, cost, fine-tuning levers) | 4 | 2 | 4 | medium |
| A4 | Hybrid cloud-to-edge inference topology | 4 | 2 | 4 | medium |
| A5 | Microsoft Foundry rebrand / terminology currency across Hub content | 3 | 3 | 3 | medium |

**Triage note.** A1 is the only thing the source uniquely contributes, and it is the most perishable (a model-catalog fact, superseded by a year of releases). A2–A4 are the durable concepts — and the coverage map (artifact 02) shows they are already present in the Hub.
