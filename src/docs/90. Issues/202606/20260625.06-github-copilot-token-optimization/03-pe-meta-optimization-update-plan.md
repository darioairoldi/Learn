---
title: "Plan: align pe-meta optimization with integrated token-optimization criteria"
author: "Dario Airoldi"
date: "2026-06-25"
status: "done"
domain: "prompt-engineering"
goal: "Confirm that the pe-meta efficiency dimension cluster and @pe-meta-optimizer already endorse the artifact-level token-optimization criteria, and apply targeted sharpening so the optimizer references the criteria integrated by plan 02 — without expanding the optimizer's mandate into runtime/user-session behavior"
---

# Plan: align pe-meta optimization with integrated token-optimization criteria

## 🎯 Goal and motivation

The `--dim efficiency` cluster (`D3-token-budget`, `D4-tool-alignment`, `D20-token-chain`, `D21-deterministic-first`, `D23-reference-efficiency`, `D24-handoff-efficiency`, `D25-processing-efficiency`, `D26-model-routing`) plus [@pe-meta-optimizer](../../../../../.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md) already endorse the **artifact-level** criteria from the article (token budgets, deduplication, model routing, reference/handoff/processing efficiency). The article's **runtime/user-behavior** criteria (Ask-vs-Agent, Markdown conversion, cache stability within a session) are correctly **outside** the optimizer's mandate — it optimizes artifacts, not live sessions.

**Goal:** (1) confirm and document the criteria→dimension mapping, and (2) apply two small sharpenings so the dimensions reference the criteria that plan 02 lands in `02.02`. No mandate expansion.

> **Dependency:** this plan executes **after** [02-prompt-engineering-update-plan.md](02-prompt-engineering-update-plan.md) lands G1–G7, because steps 3–4 reference those additions.

## ⚙️ Steps

1. Re-read the efficiency cluster rows in [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) and the `scope`/`boundaries` of [pe-meta-optimizer.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md). (✅ done)
2. **Confirm endorsement (analysis):** record a one-paragraph mapping showing each integrated artifact-level criterion (G4 tool tax, G5 always-on cost, G6 cache stability for model-routing steps) to its owning dimension; flag any criterion with no owning dimension. (✅ done)
3. **Sharpen `D4-tool-alignment`:** add the explicit expectation that agents/prompts declare the **minimal necessary tool surface**, referencing the per-tool token tax now documented in `01.04`/`02.02` — only if Step 2 confirms the current wording is silent on minimality. (✅ done)
4. **Wire always-on-context awareness:** ensure `D20-token-chain` and/or `D22-context-optimization` reference the always-on recurring-cost criterion (G5) added to `02.02`, so an efficiency review can cite it. (✅ done)
5. **Cross-link the optimizer:** add the updated `02.02` section to the optimizer agent's `context_dependencies` reference set (or confirm it is already reachable via the `00.00-prompt-engineering/` directory dependency). (✅ done — already reachable: the optimizer declares `context_dependencies: 00.00-prompt-engineering/`, so 02.02/01.04/05.07 are in scope; no edit needed)
6. Reconcile versions + metadata on any touched file per the dual-metadata rules. (✅ done)

## ✅ Exit criteria

- A documented mapping of each artifact-level criterion to its owning efficiency dimension exists. (✅ done)
- `D4` minimality wording and `D20`/`D22` always-on-cost reference are present (or explicitly confirmed already-present, with no edit needed). (✅ done)
- The optimizer reaches the updated `02.02` section through its dependency set. (✅ done)

## 🅿️ Park lot

- Expanding the optimizer's mandate to cover runtime/user-session behavior (Ask-vs-Agent selection, Markdown conversion, live cache stability). → closed: the optimizer optimizes artifacts, not sessions; these belong in user-facing how-to guidance, not the optimizer.
- Adding a brand-new efficiency dimension for "input format tax". → defer: G3 is a runtime authoring habit, not an artifact property the optimizer can measure; revisit only if a measurable artifact signal emerges.

## 🗳️ Open decisions

- None blocking. Steps 3–4 carry defined negative branches (`only if current wording is silent`).

## 🔍 Discovery

- Whether `02.02` is already reachable from the optimizer via the `00.00-prompt-engineering/` directory dependency is resolved in Step 5 (`if already reachable → no edit; else add explicit reference`).
