---
title: "Fabric Lakehouse/Warehouse observation — investigation backlog"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, backlog, microsoft-fabric]
description: "Investigation backlog: questions to resolve per track, sources consulted, and residual follow-ups."
---

# Fabric Lakehouse/Warehouse observation — investigation backlog

> Workflow step 5: focused-investigation backlog (local-first, then authoritative external).

## 🔎 Questions per track

### A2 — Lakehouse vs Warehouse

- [x] What are the primary users, languages, and data types for each? → decision guide.
- [x] Transaction model difference (multi-table ACID vs none)? → Warehouse full transactions; Lakehouse SQL endpoint is read-only.
- [x] SQL surface: read/write Warehouse vs read-only Lakehouse SQL analytics endpoint? → decision guide comparison table.
- [x] Shared storage foundation (OneLake + Delta)? → both store open Delta in OneLake.
- [x] The common "land in Lakehouse, serve from Warehouse" architecture? → medallion + "pairing with Warehouse."

### A3 — Mapping to legacy products

- [x] Synapse Dedicated SQL Pool → Fabric Warehouse (official migration path)? → Synapse migration guide.
- [x] Is Warehouse "just a SQL pool"? → No: SaaS, no-knobs, Delta in OneLake, no distribution/index management.
- [x] ADLS Gen2 → OneLake + Lakehouse? → OneLake is built on ADLS Gen2, one logical lake per tenant.
- [x] SSAS / Azure Analysis Services → Power BI semantic models? → same tabular engine; AAS on retirement path.
- [x] Azure SQL Database vs Fabric SQL database workload? → OLTP; distinct from the analytical Warehouse.

## 📚 Sources consulted (authoritative external)

| Source | Class | Used for |
|---|---|---|
| [Fabric decision guide: Warehouse vs Lakehouse](https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse) | 📘 Official | A2 comparison, decision points, capability table |
| [Migration: Synapse Dedicated SQL Pools → Fabric Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) | 📘 Official | A3 Synapse lineage, "Fabric handles indexes automatically" |
| [What is a lakehouse in Microsoft Fabric?](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview) | 📘 Official | A1/A2 lakehouse definition, SQL analytics endpoint |
| [What is OneLake?](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) | 📘 Official | A1 OneLake/ADLS Gen2 foundation |
| [SQL database in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/database/sql/overview) | 📘 Official | A3 OLTP workload vs Warehouse |

## 📌 Residual follow-ups (next review)

- Confirm the current GA/retirement dates for Azure Analysis Services before deepening the AAS mapping claim.
- Add a Real-Time Intelligence (Eventhouse/KQL) note if a future observation touches streaming stores — out of scope here.
- Point-in-time capability parity (T-SQL surface area) evolves; refresh the comparison on next review.
