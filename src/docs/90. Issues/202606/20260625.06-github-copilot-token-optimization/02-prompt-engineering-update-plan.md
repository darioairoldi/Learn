---
title: "Plan: integrate token-optimization criteria into PE guidance"
author: "Dario Airoldi"
date: "2026-06-25"
status: "done"
domain: "prompt-engineering"
goal: "Fold the genuinely-missing token-optimization techniques from the olivomarco community guide into the PE guidance context — primarily 02.02-context-window-and-token-optimization.md — without restating already-covered material or adopting techniques that conflict with the PE clarity-over-compression boundary"
---

# Plan: integrate token-optimization criteria into PE guidance

## 🎯 Goal and motivation

**Source:** [olivomarco/github-copilot-token-optimization](https://github.com/olivomarco/github-copilot-token-optimization) — a **community resource** (not official GitHub/Microsoft guidance).

The PE guidance already covers most of the article's structural techniques: `applyTo` scoping, model routing, model-specific retuning, output-token reduction, provider/semantic caching, and tool token cost. This plan adds only the **seven genuinely-missing or under-specified criteria** (G1–G7 below) to the canonical token-optimization context file, and records two deliberate non-adoptions.

**Goal:** add G1–G7 to [02.02-context-window-and-token-optimization.md](../../../../../.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md) (with cross-references to `01.04` and `03.02` where those files are the canonical home), then reconcile metadata. No new artifact types; no rule removals.

## 🧭 Coverage map (gap → landing)

This table is informational (no status suffix).

| Gap | Technique | Landing |
|-----|-----------|---------|
| G1 | Terse output as a stated default behavior (output ~5× input cost) | `02.02` — extend strategy "Output Token Reduction" |
| G2 | Ask-vs-Agent interaction-mode right-sizing | `02.02` — new short subsection under information-flow/workflow |
| G3 | Convert rich files (`.docx/.pdf/.pptx/.xlsx/HTML`) to Markdown before ingestion | `02.02` — new "Input format tax" note |
| G4 | MCP/tool-surface audit + per-tool tax (~100–500 tokens/tool/step) | `02.02` cross-ref + `01.04-tool-composition-guide.md` |
| G5 | Always-on context recurring cost + caution vs LLM-generated boilerplate | `02.02` — extend context-window breakdown / instruction-minimization note |
| G6 | Cache-stability within a long thread (keep model/MCP/agent stable) | `02.02` provider-caching section + cross-ref `03.02` |
| G7 | Plan-first, then execute in a fresh session with a cheaper model | `02.02` — extend context-rot mitigations |

## ⚙️ Steps

1. Read [02.02-context-window-and-token-optimization.md](../../../../../.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md) in full to locate the exact insertion points for each gap (strategy list, context-window breakdown table, context-rot mitigations, provider-caching section). (✅ done)
2. **G5 — always-on context cost:** add a note that `copilot-instructions.md` and `AGENTS.md` are billed on every interaction and every agent step, and that LLM-generated `/init` boilerplate often inflates cost without improving correctness; cross-reference the existing instruction-minimization guidance rather than restating it. (✅ done)
3. **G1 — output-control-by-default:** extend the existing "Output Token Reduction" strategy with the "terse output as project default" pattern and the output-costs-more-than-input asymmetry (cite the provider pricing asymmetry, not a Copilot-specific number, since Copilot's per-model UBB table is unpublished). (✅ done)
4. **G2 — interaction-mode right-sizing:** add a short heuristic distinguishing Ask mode (simple, single-turn questions) from Agent mode (multi-step tasks), framed as avoiding agent-loop overhead. (✅ done)
5. **G4 — tool-surface audit:** add the per-tool token-tax figure (~100–500 tokens/tool/step) and the audit habit (disable unused MCP servers/extensions; use a focused profile or scoped custom agent); land the canonical figure in [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) and reference it from `02.02`. (✅ done)
6. **G3 — input format tax:** add a note that rich file formats carry layout/markup overhead and should be converted to Markdown before chat/agent/RAG ingestion. (✅ done)
7. **G6 — cache stability:** add guidance to keep `{model, active MCP set, active agent/profile}` stable inside a long thread to preserve cached-input discounts, and to start a fresh chat with a short handoff summary when switching lanes; cross-reference [03.02-model-specific-optimization.md](../../../../../.copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md). (✅ done)
8. **G7 — plan-first/fresh-session:** extend the context-rot mitigations with the "agree the plan with a strong model, persist it, then execute in a clean session (often a cheaper model)" pattern, linking to the existing plan-artifact discipline. (✅ done)
9. Add a **References** entry for the source article classified `📒 [Community]`, with a one-line note that it is a community resource and that the UBB-era output-cost asymmetry is the key framing. (✅ done)
10. Record the two **deliberate non-adoptions** (see § Park lot) as a short "Out of scope for this system" note in `02.02` so future reviewers do not re-propose them. (✅ done)
11. Bump the `02.02` (and any touched sibling) version and reconcile the bottom validation metadata per the dual-metadata rules. (✅ done)

## ✅ Exit criteria

- G1–G7 are present in the named context files, each as an addition (no rule removed). (✅ done)
- The source article is referenced and classified `📒`. (✅ done)
- Deliberate non-adoptions are documented in `02.02`. (✅ done)
- Touched files have reconciled version + validation metadata. (✅ done)

## 🅿️ Park lot

- Aggressive prompt compression / "caveman-speak" / intensity levels (article 2.1). → closed: conflicts with the PE boundary "prioritize clarity over token minimization"; documented as a non-adoption, not integrated.
- Language token-efficiency comparison (article 2.2). → closed: repo content is English-only; not applicable.
- `/chronicle cost tips`, `/chronicle improve`, CodeAct plugin (article 11–12). → defer: Copilot-CLI-only experimental tooling; revisit if the repo adopts CLI workflows.
- Enterprise governance / UBB budgets / FinOps-as-code (article 4.3). → closed: out of scope for a personal single-owner repo; `02.02` already notes UBB exists.

## 🗳️ Open decisions

- None blocking. All steps are additive documentation edits to identified files.

## 🔍 Discovery

- Exact insertion anchors inside `02.02` are resolved at execution time in Step 1 (`if a target subsection is absent → create it under the nearest matching H2`).
