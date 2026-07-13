---
title: "Fabric Lakehouse/Warehouse observation — priority and depth"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, prioritization, microsoft-fabric]
description: "Prioritized investigation tracks, recommended depth per track, source-soundness verdict, and workflow-pattern applicability."
---

# Fabric Lakehouse/Warehouse observation — priority and depth

> Workflow step 4: prioritize tracks and depth; step 3.5 source-soundness recorded.

## 🔒 Source-soundness gate

| Dimension | Assessment |
|---|---|
| Clarity | Pass — two unambiguous questions (difference; legacy-product mapping). |
| Internal consistency | Pass — the Q&A is coherent; the proposed analogies are consistent with each other. |
| Sufficiency | Pass — Fabric, OneLake, Warehouse, and Lakehouse are richly documented products. |
| Novelty & value | Pass — absent from LearnHub; high reuse value for a Microsoft-centric audience. |
| Verifiability | Pass — every claim is checkable against Microsoft Learn (decision guide, Synapse migration guide, OneLake docs). |
| Corroboration | Pass — the official Fabric decision guide and the Synapse-to-Fabric migration guide independently confirm the core claims. |

**`source_verdict: sound`** → deep analysis and (autonomous, for the clear gap) integration are permitted.

One caveat carried forward: the observation's Q2 contains a strong shorthand ("Analysis Services is abandoned in Fabric"). This is reframed accurately during integration — there is no standalone Analysis Services *workload* in Fabric; its analytical-model role is served by Power BI semantic models (the same tabular engine), and Azure Analysis Services (the PaaS) is separately on a retirement path.

## 📊 Prioritized tracks

| Priority | Track | Depth | Rationale |
|---|---|---|---|
| 1 | A2 — Lakehouse vs Warehouse | **deep** | The primary question; anchors the whole subject. |
| 2 | A3 — Mapping to legacy products | **deep** | Directly asked; highest reuse value; needs careful accuracy. |
| 3 | A1 — Data-store fundamentals | **standard** | Grounding (OneLake, Delta) that both A2 and A3 build on. |

## 🔁 Workflow-pattern applicability

`selected_workflow_pattern: not_applicable` — the observation concerns **data-platform products**, not a choice between chain-first retrieval, agentic retrieval, or multi-agent orchestration. Product comparison is handled as analysis areas (A2, A3). Therefore `06-external-approaches-contrast.md` is intentionally omitted.
