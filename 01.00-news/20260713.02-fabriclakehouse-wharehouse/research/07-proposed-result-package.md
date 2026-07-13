---
title: "Fabric Lakehouse/Warehouse observation — proposed result package"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, result-package, microsoft-fabric]
description: "Discussion-ready package: verdicts, coverage summary, per-area conclusions, and the concise answer to both questions."
---

# Fabric Lakehouse/Warehouse observation — proposed result package

> Workflow step 8: the decision-ready summary.

## 🧾 Verdicts

| Output | Value |
|---|---|
| `triage_verdict` | Proceed — two high-impact questions plus grounding, all absent from LearnHub. |
| `source_verdict` | **sound** — clear, valuable, verifiable, corroborated by the official decision guide and Synapse migration guide. |
| `selected_workflow_pattern` | not_applicable (data-platform product question, not an agentic-pattern choice). |
| `integration_state` | **completed** — clear, additive gap integrated autonomously. |

## 🗺️ Coverage summary

Microsoft Fabric data stores are **absent** from LearnHub. The nearest area, `03.00-tech/03.01-data/`, covers operational storage access (Table, Cosmos, Blob) — the analytical Fabric stores (Lakehouse, Warehouse) are missing.

## ✅ Per-area conclusions

**A1 — Fundamentals.** Fabric is SaaS; **OneLake** (on ADLS Gen2) is one tenant-wide logical lake; both Lakehouse and Warehouse store **open Delta** in OneLake. So the difference is engine/persona, not storage.

**A2 — Lakehouse vs Warehouse.** Choose **Lakehouse** for Spark, data science, and unstructured/medallion ETL; choose **Warehouse** for T-SQL, multi-table ACID transactions, and BI serving. The Lakehouse's SQL analytics endpoint is **read-only** (no DML); the Warehouse is full read/write T-SQL. They are **complementary** — land in a Lakehouse, serve from a Warehouse.

**A3 — Legacy mapping.** Warehouse ≈ successor to **Synapse Dedicated SQL Pool** (SaaS, no-knobs, Delta in OneLake — not a lift of the MPP pool); ADLS ≈ **OneLake + Lakehouse**; SSAS/AAS Tabular ≈ **Power BI semantic models** (same tabular engine; no separate AS workload); Azure SQL Database stays **OLTP** and is not replaced by the Warehouse (Fabric's SQL database workload is an OLTP option, not a BI store).

## 🗣️ Concise answer (to both questions)

1. **Lakehouse vs Warehouse?** Same lake (OneLake) and format (Delta), different engine and persona: Lakehouse = Spark + files + data science + medallion ETL (SQL is read-only); Warehouse = T-SQL + multi-table transactions + BI serving (full read/write). A common design uses both — engineer in the Lakehouse, serve from the Warehouse.
2. **Is Warehouse basically SQL Server / Analysis Services on Delta?** It is closest to the **successor of Synapse Dedicated SQL Pool**, but SaaS and no-knobs, storing open Delta in OneLake. Analysis Services' role is served by **Power BI semantic models**; Azure SQL Database is a different (OLTP) product. Mental map: *Synapse SQL Pool → Warehouse, Azure Data Lake → OneLake + Lakehouse, Analysis Services Tabular → Semantic models, Azure SQL → OLTP (Fabric SQL database or external)*.

## 🎚️ Confidence and assumptions

- **High confidence** on the Lakehouse/Warehouse comparison and the Synapse lineage (verified against the official decision guide and migration guide this session).
- **Medium confidence** on exact AAS retirement dates — flagged for refresh on next review.
- Capability parity (T-SQL surface area) is point-in-time (2026-07-13).

## 🔗 Integration outcome

Clear additive gap → integrated autonomously into `03.00-tech/03.01-data/04-microsoft-fabric/` (index + three articles). See `08-approval-and-integration-proposal.md`.
