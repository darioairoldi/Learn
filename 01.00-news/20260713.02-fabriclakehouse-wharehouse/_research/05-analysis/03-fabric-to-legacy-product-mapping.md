---
title: "Analysis A3 — Mapping Fabric data stores to legacy Microsoft products"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [analysis, microsoft-fabric, synapse, analysis-services, azure-sql]
description: "In-depth analysis of how Fabric's data stores map onto the legacy Microsoft data stack: Synapse SQL Pool, ADLS, SSAS/AAS, and Azure SQL Database."
---

# Analysis A3 — Mapping Fabric data stores to legacy Microsoft products

> Deep-depth analysis for the legacy-mapping question (Q2).

## 🎯 Problem statement

For a practitioner with a classic Microsoft data background, what is the most accurate mental mapping of Fabric's stores onto the products they already know — Synapse Dedicated SQL Pool, Azure Data Lake, SQL Server Analysis Services (SSAS) / Azure Analysis Services (AAS), and Azure SQL Database?

## 🔍 Additional considerations

### Warehouse ≈ successor to Synapse Dedicated SQL Pool — with caveats

Microsoft publishes a dedicated **migration strategy from Azure Synapse Analytics dedicated SQL pools to Fabric Data Warehouse**, positioning Fabric DW as the modernization target. ([Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) 📘)

But it is **not** "just a SQL pool in Fabric":

- It is fully **SaaS** — no dedicated pool to provision or pause.
- Data is stored in **OneLake in open Delta**, not proprietary MPP storage.
- **No distribution/index management**: "indexes... usually aren't migrated... now Fabric takes care of that automatically for you." ([Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) 📘)
- It integrates natively with Lakehouse, semantic models, and the other Fabric workloads.

### Azure Data Lake ≈ OneLake + Lakehouse

OneLake is a single, tenant-wide logical lake built on **ADLS Gen2**; the **Lakehouse** is the item that organizes files and Delta tables on top of it. So the classic "raw data lake" role (ADLS + Spark) maps to **OneLake + Lakehouse**. ([OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) 📘)

### SSAS / Azure Analysis Services ≈ Power BI semantic models

There is **no standalone Analysis Services workload** in Fabric. The analytical semantic-model role once served by SSAS/AAS **Tabular** is served by **Power BI semantic models**, which run the same tabular (VertiPaq) engine. Microsoft's guidance for AAS customers is migration toward Power BI / Fabric semantic models, and **Azure Analysis Services is on a retirement path**. So the observation's shorthand ("Analysis Services is abandoned in Fabric") is directionally right, stated precisely: the *role* persists as semantic models; the *separate product* does not exist as a Fabric workload.

### Azure SQL Database ≠ Warehouse (different job)

Azure SQL Database is a **transactional (OLTP)** engine; the Warehouse is an **analytical (OLAP)** store. They are not substitutes. Fabric additionally offers a **SQL database** workload (an OLTP database inside Fabric, based on the Azure SQL engine) — but its purpose is operational, not enterprise BI at analytical scale. ([SQL database in Fabric](https://learn.microsoft.com/en-us/fabric/database/sql/overview) 📘)

## 💡 Deductions

1. The cleanest one-line analogies are: **Warehouse = successor to Synapse Dedicated SQL Pool**, **OneLake + Lakehouse = successor to Azure Data Lake + Spark**, **Semantic model = successor to Analysis Services Tabular**.
2. The analogies are **orientation aids, not equivalences** — the recurring difference is that Fabric removes the provisioning/tuning surface (distributions, indexes, pool sizing) and stores everything as open Delta in OneLake.
3. **Azure SQL Database stays in the OLTP lane**; do not present the Warehouse as its replacement, and treat Fabric's SQL database workload as an OLTP option, not a BI store.

## ✅ Conclusions

| Legacy product | Fabric successor / mapping | Caveat |
|---|---|---|
| Synapse Dedicated SQL Pool | **Fabric Warehouse** | SaaS, no-knobs, Delta in OneLake — not a lift of the MPP pool |
| Azure Data Lake (ADLS Gen2) | **OneLake + Lakehouse** | OneLake is one tenant-wide lake, auto-provisioned |
| SSAS / Azure Analysis Services (Tabular) | **Power BI semantic models** | Same tabular engine; no separate AS workload; AAS retiring |
| Azure SQL Database (OLTP) | **SQL database in Fabric** (or external Azure SQL) | Different job from the Warehouse; OLTP, not BI-scale analytics |

## Appendix A — Evidence

| Claim | Source | Class |
|---|---|---|
| Official Synapse Dedicated SQL Pool → Fabric Warehouse migration path | [Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) | 📘 Official |
| Fabric manages indexes automatically (no distribution/index tuning) | [Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) | 📘 Official |
| OneLake is a single tenant-wide lake on ADLS Gen2 | [OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) | 📘 Official |
| SQL database in Fabric is an OLTP workload | [SQL database in Fabric](https://learn.microsoft.com/en-us/fabric/database/sql/overview) | 📘 Official |
| "Why Fabric Data Warehouse is the Modernization Path for Synapse" | [Fabric community blog](https://community.fabric.microsoft.com/t5/Fabric-Updates-Blog/Why-Fabric-Data-Warehouse-is-the-Modernization-Path-for-Synapse/ba-p/5178874) | 📗 Verified Community |

## Appendix B — Validation

- The Synapse-lineage and "Fabric handles indexes automatically" claims are quoted from the official migration guide, not inferred.
- The Analysis Services shorthand from the observation was **challenged and re-derived**: rather than repeating "abandoned," the conclusion distinguishes the *role* (semantic models, same tabular engine) from the *product* (no AS workload; AAS retiring). This avoids overstating a design claim.
- The Azure SQL Database mapping is stated as a **non-equivalence** (OLTP vs OLAP), corroborated by the separate SQL-database-in-Fabric documentation.
