---
title: "Fabric Lakehouse vs Warehouse, and the legacy-product mapping"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [news, microsoft-fabric, lakehouse, warehouse, synapse]
description: "An observation about the difference between Microsoft Fabric's Lakehouse and Warehouse — and how Fabric's data stores map onto the classic Microsoft data stack — investigated and integrated into the Learning Hub's data area."
---

# Fabric Lakehouse vs Warehouse, and the legacy-product mapping

> **Observation.** Two questions came up while explaining Microsoft Fabric: *what is the difference between a Lakehouse and a Warehouse?* and *is the Warehouse basically SQL Server / Analysis Services on Delta tables?* I investigated both and folded the durable answers into the Learning Hub.

## 🔎 What I looked into

In Microsoft Fabric, the **Lakehouse** and the **Warehouse** both store open **Delta** tables in **OneLake**, so the difference is not storage — it is the **engine, persona, and capabilities** on top. The Lakehouse is Spark-centric (data engineering, data science, unstructured data, medallion ETL) with a **read-only** SQL endpoint; the Warehouse is T-SQL-centric with **full read/write** and **multi-table ACID transactions** for BI serving. They are complementary: a common design lands data in a Lakehouse and serves it from a Warehouse.

The second question is really about **lineage**. The most accurate mental map is: **Synapse Dedicated SQL Pool → Fabric Warehouse**, **Azure Data Lake → OneLake + Lakehouse**, **Analysis Services Tabular → Power BI semantic models**, and **Azure SQL Database → OLTP** (a Fabric SQL database workload or external Azure SQL) — each an orientation aid, not an equivalence.

This filled a genuine gap: the Hub's data area covered operational storage access (Table, Cosmos, Blob) but nothing on Fabric's analytical stores.

## 📦 What was integrated

The durable write-up now lives in the data tech area:

- **[Introduction to Microsoft Fabric data stores](../../03.00-tech/03.01-data/04-microsoft-fabric/01.01-introduction-to-microsoft-fabric-data-stores.md)** — the OneLake + open Delta foundation.
- **[Lakehouse vs Warehouse](../../03.00-tech/03.01-data/04-microsoft-fabric/02.01-lakehouse-vs-warehouse.md)** — how to choose, and the common pairing architecture.
- **[Mapping Fabric to legacy Microsoft data products](../../03.00-tech/03.01-data/04-microsoft-fabric/04.01-mapping-fabric-to-legacy-data-products.md)** — Synapse, ADLS, Analysis Services, and Azure SQL.
- Series index: **[Microsoft Fabric data stores](../../03.00-tech/03.01-data/04-microsoft-fabric/readme.md)**.

## 📚 References

- [Fabric decision guide: choose between Warehouse and Lakehouse](https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse) 📘 [Official]
- [Migration: Azure Synapse dedicated SQL pools to Fabric Data Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse) 📘 [Official]
- [What is OneLake?](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) 📘 [Official]

<!-- Original observation (raw Q&A, partly in Italian) preserved below for provenance. -->

<!--
Q. Can you explain the difference between lakehouse and warehouse?

A. Yes. In Microsoft Fabric, both Lakehouse and Warehouse store data in OneLake using the open Delta format, but they are optimized for different workloads and user personas. [1][2]
Area	Lakehouse	Warehouse
Primary users	Data Engineers, Data Scientists	SQL Developers, BI Developers
Main language	Spark (Python, Scala, SQL, R)	T-SQL
Data types	Structured + Unstructured	Structured only
Transactions	No multi-table transactions	Full ACID multi-table transactions
Data ingestion	Notebooks, Spark, Pipelines, Dataflows, Shortcuts	T-SQL, Pipelines, Dataflows
SQL support	Read-only SQL Analytics Endpoint	Full T-SQL support (DDL, DML, DQL)
Best for	Data engineering, ETL, Data science, Medallion architecture	Enterprise data warehousing, dimensional models, BI reporting
A simple way to think about it:
• Choose Lakehouse when you need flexibility, Spark, data science, or to work with raw and semi-structured data.
• Choose Warehouse when your team is SQL-centric and needs traditional enterprise data warehouse capabilities such as stored procedures, transactions, and advanced SQL development. [1]​[2]
A very common Fabric architecture is:
Land and transform data in a Lakehouse using Spark.
Create curated business-ready datasets.
Expose those datasets through a Warehouse for SQL-based reporting and BI consumption. [2]
Key references:
Microsoft Fabric decision guide: https://learn.microsoft.com/en-us/fabric/fundamentals/decision-guide-lakehouse-warehouse
Lakehouse overview: https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview
If you tell me more about your scenario (ETL, reporting, data science, migration from Synapse/SQL Server, etc.), I can recommend which one is the better fit.
 


Q.  praticamente Warehouse è un SQL Server a tutti gli effetti ... basato su Azure Storage delta tables?
 
forse un SQL analysis service ? 
 
A. warehouse è più un sql pool.. il vecchio synapse. VOlendo in fabric puoi instanziare un SQL "classico" (azure SQL) ma è un'altra cosa. Analysis services ti direi che è abbandonato in fabric

Direi "sì, con qualche sfumatura".
Sul primo punto, Fabric Warehouse è effettivamente l'evoluzione naturale per molti scenari che in passato sarebbero finiti su Synapse Dedicated SQL Pool. Microsoft ha persino documentazione e tooling specifici per la migrazione da Synapse Dedicated SQL Pool a Fabric Data Warehouse e posiziona Fabric DW come il percorso di modernizzazione raccomandato.
12
Tuttavia non è corretto dire che sia semplicemente "un SQL Pool in Fabric":
è completamente SaaS;
i dati sono salvati in OneLake in formato Delta aperto;
non devi gestire distribuzioni, indici e gran parte del tuning tipico di Synapse;
supporta nativamente integrazione con Lakehouse, semantic models e gli altri workload Fabric. 12
Riguardo Azure SQL Database, confermo che è un'altra cosa:
Azure SQL è un database OLTP transazionale "classico";
Fabric Warehouse è una piattaforma analitica (OLAP/data warehousing);
oggi in Fabric esiste anche il workload "Databases" con SQL Database, ma il suo scopo è diverso dal Warehouse. Non lo userei come sostituto del Warehouse per BI o analytics su larga scala.
Su Analysis Services, direi che la tua osservazione è sostanzialmente corretta. In Fabric il ruolo storico di SSAS/Azure Analysis Services è stato assorbito dai Power BI Semantic Models (tabular engine). Le raccomandazioni Microsoft per i modelli analitici sono orientate verso Semantic Models e la migrazione dei modelli Analysis Services verso Semantic Models Fabric/Power BI.
3
Quindi, se dovessi fare un mapping "mentale" dei prodotti:
Synapse Dedicated SQL Pool → Fabric Warehouse
Azure Data Lake → OneLake + Lakehouse
Azure Analysis Services / SSAS Tabular → Power BI Semantic Models
Azure SQL Database → SQL Database (workload Databases di Fabric o Azure SQL esterno)
Fonti:
Fabric Warehouse vs Synapse migration guidance: https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool-warehouse
Fabric modernization path for Synapse customers: https://community.fabric.microsoft.com/t5/Fabric-Updates-Blog/Why-Fabric-Data-Warehouse-is-the-Modernization-Path-for-Synapse/ba-p/5178874
Analysis Services migration guidance toward Semantic Models: https://teams.microsoft.com/l/message/19%3Aebd5245e2cb246c78ab70aeaf2b33624%40thread.skype/1741191303435?groupId=77f40803-dca6-4e92-bcab-1104d6a99c97&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47&createdTime=1741191303435&parentMessageId=1741191303435
In pratica, quando spiego Fabric a clienti con background Microsoft, spesso la semplificazione più efficace è: "Lakehouse = Data Lake + Spark, Warehouse = successore di Synapse SQL Pool, Semantic Model = successore di Analysis Services Tabular". Questa analogia non è perfetta, ma è abbastanza vicina per orientarsi rapidamente.
-->
