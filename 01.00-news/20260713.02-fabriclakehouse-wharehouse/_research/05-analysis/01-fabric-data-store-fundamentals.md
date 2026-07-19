---
title: "Analysis A1 — Fabric data-store fundamentals"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [analysis, microsoft-fabric, onelake, delta, overview]
description: "Grounding analysis: OneLake, the open Delta format, and the data-store items Fabric offers on top of them."
---

# Analysis A1 — Fabric data-store fundamentals

> Standard-depth analysis for the Overview track.

## 🎯 Problem statement

To answer "Lakehouse vs Warehouse" and "how does this map to the old stack," we first need the shared foundation both stores sit on: **OneLake** and the **open Delta format**.

## 🔍 Additional considerations

- **Fabric is SaaS.** Microsoft Fabric is "an all-in-one SaaS analytics solution" bundling Data Factory, Data Engineering, Data Warehousing, Data Science, Real-Time Intelligence, and Power BI. ([Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) 📘)
- **OneLake is the single logical lake.** One tenant-wide data lake, built on Azure Data Lake Storage (ADLS) Gen2, provisioned automatically — "the OneDrive for data." Every workspace and data item lives in it. ([OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) 📘)
- **Open Delta is the common table format.** Both Warehouse and Lakehouse "store data in OneLake in open Delta format." ([Decision guide](https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse) 📘) That means the *storage* is shared and open; the *engines and experiences* on top differ.
- **Shortcuts avoid copies.** OneLake shortcuts reference data in place (other lakes, ADLS, S3), so a Lakehouse or Warehouse can query external data without duplicating it. ([Decision guide](https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse) 📘)

## 💡 Deductions

1. Because storage (OneLake) and format (Delta) are shared, "Lakehouse vs Warehouse" is a question about **engine, experience, and persona** — not about where the bytes live.
2. The SaaS, no-infrastructure framing is the thread that recurs in every legacy-product comparison: Fabric removes the provisioning/tuning surface that Synapse and SSAS exposed.
3. OneLake being ADLS-Gen2-based is exactly why the "Azure Data Lake → OneLake + Lakehouse" analogy in Q2 holds.

## ✅ Conclusions

- Fabric is a **SaaS** analytics platform; **OneLake** (on ADLS Gen2) is its single logical data lake; **open Delta** is the shared table format.
- Lakehouse and Warehouse are two **items/experiences** over that same lake, optimized for different personas.
- This foundation is the anchor for both the Lakehouse-vs-Warehouse comparison (A2) and the legacy-product mapping (A3).

## Appendix A — Evidence

| Claim | Source | Class |
|---|---|---|
| Fabric is an all-in-one SaaS analytics solution | [Synapse migration guide](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) | 📘 Official |
| OneLake is a single tenant-wide lake on ADLS Gen2 | [OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) | 📘 Official |
| Both stores use OneLake + open Delta | [Decision guide](https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse) | 📘 Official |

## Appendix B — Validation

- The "OneLake + Delta for both" claim is quoted from the decision guide's own service descriptions, not inferred.
- The SaaS framing is corroborated across two independent official pages (Fabric overview via the migration guide, and the decision guide).
