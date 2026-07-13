---
title: "Fabric Lakehouse/Warehouse observation — existing LearnHub coverage map"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, coverage-map, microsoft-fabric, taxonomy]
description: "Internal grounding: what LearnHub already covers for each Fabric data-store candidate area, mapped to the documentation taxonomy."
---

# Fabric Lakehouse/Warehouse observation — existing LearnHub coverage map

> Workflow step 3: internal grounding before locking priorities.

## 🗺️ Coverage by area

| Area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| A1 — Fabric data-store fundamentals | **absent** | none found | Overview |
| A2 — Lakehouse vs Warehouse | **absent** | none found | Concepts |
| A3 — Mapping to legacy products | **absent** | none found | Analysis |

A repository scan for `Fabric`, `Lakehouse`, `Warehouse`, `OneLake`, `Synapse`, `Semantic Model`, and `Delta` across `03.00-tech/`, `01.00-news/`, `02.00-events/`, and `04.00-howto/` returned **no matches**.

## 🧩 Nearest existing content

- `03.00-tech/03.01-data/` — data-store access guides for **Azure Table Storage**, **Cosmos DB**, and **Blob Storage** (C# SDK, single-`readme.md` subjects). Same content family (data stores), but transactional/operational storage rather than Fabric analytics stores.
- `03.00-tech/02.01-azure/` — Azure building blocks (Functions, Key Vault, Containers, cost analysis). No analytics-platform coverage.

## Deduction

Microsoft Fabric — and specifically the Lakehouse/Warehouse distinction plus the Synapse/SSAS/ADLS lineage — is a genuine **gap** in the corpus. It belongs under the data area (`03.00-tech/03.01-data/`) as a new subject, because it is about analytical data stores and complements the operational-storage guides already there.
