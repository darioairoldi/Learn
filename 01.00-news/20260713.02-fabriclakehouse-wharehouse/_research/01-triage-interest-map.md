---
title: "Fabric Lakehouse/Warehouse observation — triage and interest map"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, triage, microsoft-fabric, lakehouse, warehouse]
description: "Triage of the Fabric Lakehouse-vs-Warehouse observation: context-harvest signals and scored candidate investigation areas."
---

# Fabric Lakehouse/Warehouse observation — triage and interest map

> Workflow step 1–2: single-entry intake, context harvest, and fast triage.

## 🎯 Intake

Raw observation (from `overview.md` in this folder) — a two-thread Q&A:

- **Q1:** "Can you explain the difference between Lakehouse and Warehouse?"
- **Q2:** "Is Warehouse practically a SQL Server / SQL Analysis Service based on Azure Storage Delta tables?" — which expands into a mental mapping of Fabric workloads onto legacy Microsoft data products.

Extraction:

| Field | Value |
|---|---|
| `explicit_question` | What distinguishes a Fabric Lakehouse from a Fabric Warehouse, and how do Fabric's data stores map onto the legacy Microsoft data stack (Synapse, ADLS, Analysis Services, Azure SQL)? |
| `pain_signal` | Orientation for a practitioner with a classic Microsoft data background (SQL Server, Synapse, SSAS) trying to build a correct mental model of Fabric. |
| `decision_pressure` | Medium — the questioner explains Fabric to customers, so a durable, accurate analogy has direct reuse value. |
| `domain_scope` | Microsoft Fabric data platform: OneLake, Lakehouse, Warehouse, semantic models, and Synapse/SSAS/Azure SQL lineage. |

## 🧭 Context-harvest signals

| Signal source | Finding |
|---|---|
| Active file | `01.00-news/20260713.02-fabriclakehouse-wharehouse/overview.md` — the raw two-thread Q&A (Q2 partly in Italian). |
| Sibling issue folders | `20260713.01-markitdown` (same day) — unrelated topic, but confirms the news-dated observation pattern and the readme-index integration convention. |
| Repository scan (`grep` over `03.00-tech`, `01.00-news`, `02.00-events`, `04.00-howto` for `Fabric\|Lakehouse\|Warehouse\|OneLake\|Synapse\|Semantic Model\|Delta`) | **No matches.** Fabric data-platform content is entirely absent from the content areas. |
| Adjacent tech area | `03.00-tech/03.01-data/` covers storage-access options (Table, Cosmos, Blob) with C# — data-store adjacent, but nothing on Fabric analytics stores. |

## 📊 Candidate areas (scored 1–5)

| Area | Relevance | Urgency | Learning impact | Confidence |
|---|---|---|---|---|
| A1 — Fabric data-store fundamentals (OneLake, Delta, the store types) | 5 | 3 | 4 | high |
| A2 — Lakehouse vs Warehouse (the comparison, when to choose, common architecture) — **Q1** | 5 | 4 | 5 | high |
| A3 — Mapping Fabric stores to legacy products (Synapse SQL Pool, ADLS, SSAS/AAS, Azure SQL) — **Q2** | 5 | 4 | 5 | high |

## Triage verdict

**Proceed.** The observation splits cleanly into two explicit questions (A2, A3) plus the grounding needed to answer them (A1). All three areas are absent from LearnHub and are high learning-impact for a Microsoft-centric data audience. The Q2 thread is partly in Italian; per the request, all integrated material is written in English.
