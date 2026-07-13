# Microsoft Fabric data stores

A concise guide to **Microsoft Fabric's** analytical data stores — the **Lakehouse** and the **Warehouse** — how to choose between them, and how they map onto the classic Microsoft data stack (Synapse, Azure Data Lake, Analysis Services, Azure SQL).

## 📚 Series overview

**Target audience:** Developers, data engineers, and BI practitioners — especially those with a classic Microsoft data background (SQL Server, Synapse, SSAS) — building a correct mental model of where data lives in Fabric.

**Series scope:**

- ✅ **Covered:** the shared OneLake + Delta foundation, the Lakehouse-vs-Warehouse decision, and the mapping from legacy Microsoft products to their Fabric successors
- ❌ **Not covered:** step-by-step provisioning, T-SQL surface-area reference, and Real-Time Intelligence (Eventhouse/KQL) — see the [official Fabric documentation](https://learn.microsoft.com/en-us/fabric/)

**Source:** [Microsoft Fabric documentation](https://learn.microsoft.com/en-us/fabric/) 📘 [Official] · **Last updated:** July 13, 2026

---

## 🗺️ Reading order

### 01 — Introduction and fundamentals

**1. [Introduction to Microsoft Fabric data stores](01.01-introduction-to-microsoft-fabric-data-stores.md)**  
What Fabric is, the OneLake + open Delta foundation, and the data-store items that sit on top of it.

---

### 02 — Concepts

**2. [Lakehouse vs Warehouse](02.01-lakehouse-vs-warehouse.md)**  
The core distinction: personas, languages, transactions, SQL surface, and the common "engineer in the Lakehouse, serve from the Warehouse" architecture.

---

### 04 — Analysis

**3. [Mapping Fabric to legacy Microsoft data products](04.01-mapping-fabric-to-legacy-data-products.md)**  
How Fabric's stores map onto Synapse Dedicated SQL Pool, Azure Data Lake, Analysis Services, and Azure SQL Database — as orientation aids, with the caveats that keep them honest.

---

## 🧭 Where this fits

This subject sits in the **data** area alongside the operational-storage access guides ([Azure Table Storage](../01-table-storage-access-options/readme.md), [Cosmos DB](../02-cosmosdb-access-options/01-azure-cosmosdb-access-options.md), [Blob Storage](../03-blob-storage-access-options/01-blob-storage-access-options.md)). Those cover **operational (OLTP-style) storage access**; this series covers **analytical data stores** in the Microsoft Fabric SaaS platform.
