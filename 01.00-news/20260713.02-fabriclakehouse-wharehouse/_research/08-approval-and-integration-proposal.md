---
title: "Fabric Lakehouse/Warehouse observation — approval and integration proposal"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, integration-proposal, microsoft-fabric, taxonomy]
description: "Integration record for the Fabric Lakehouse/Warehouse observation: a clear coverage gap integrated autonomously into the LearnHub data area."
---

# Fabric Lakehouse/Warehouse observation — integration record

> Workflow steps 9–10. **`integration_state: completed`.** Microsoft Fabric data stores are a clear coverage gap, so the material was integrated autonomously (additive tech content, no destructive edits). `source_verdict` was `sound`, satisfying the integration precondition.

## 🚦 Why no approval gate

This integration was **additive and unambiguous**: the coverage map recorded Fabric data stores as `absent`, the mode is tech-article (not a meta/architecture amendment), and no existing article was overwritten or restructured. Under those conditions the only real decision is **placement and structure**, chosen for consistency and least redundancy — an agent-owned decision, not a user approval.

Approval is reserved for genuine judgment calls: meta/architecture amendments, overwrites or restructures of existing content, and unresolved scope conflicts.

## 🧭 Detected integration mode

**Mode (a) — tech-article integration.** This is a new **technology topic** (a data platform), not a change to `06.00-idea` visions or `.github` PE artifacts. So the deliverable is taxonomy-bound article placement plus a rewritten dated news overview — not a meta/architecture amendment plan.

## 🗂️ Placement (derived for consistency + least redundancy)

Fabric's Lakehouse and Warehouse are **analytical data stores**, so the subject joined the **data** area as a new sibling to the operational-storage access guides. It uses the **series convention** (a `readme.md` index + `XX.YY-topic.md` articles, taxonomy bands) already established elsewhere in `03.00-tech` (e.g. the Markdown area), because the topic has three distinct parts. The numeric prefix `04-` is the next free slot in the data area (01 = Table, 02 = Cosmos, 03 = Blob).

**New subject folder:** `03.00-tech/03.01-data/04-microsoft-fabric/`

| File | Content type (taxonomy band) | Source analysis | User question |
|---|---|---|---|
| `readme.md` | Index | — | — |
| `01.01-introduction-to-microsoft-fabric-data-stores.md` | Overview/Introduction (01) | A1 (reframed) | grounding |
| `02.01-lakehouse-vs-warehouse.md` | Concepts (02) | A2 | Q1 — the difference |
| `04.01-mapping-fabric-to-legacy-data-products.md` | Analysis (04) | A3 | Q2 — legacy mapping |

**Reframing applied:** the research "Problem statement" frames were translated into reader-facing framing — the introduction presents Fabric's data stores and their shared foundation, not a "problem."

**Provenance applied:** each article opens with a canonical Microsoft Learn source reference and link; original Mermaid diagrams visualize the OneLake/Delta foundation, the decision tree, the pairing architecture, and the legacy mapping (no third-party images were hotlinked).

**Deduction challenged and re-derived:** the observation's shorthand "Analysis Services is abandoned in Fabric" was not repeated verbatim. It was re-derived from evidence into an accurate claim — the *role* persists as Power BI semantic models (same tabular engine); there is no separate AS *workload*; Azure Analysis Services (the PaaS) is separately retiring.

## 🔗 Cross-linking (matching the local convention)

- News [overview.md](../overview.md) → the three tech articles (forward links).
- Subject `readme.md` → sibling data-area guides ([Table](../../../03.00-tech/03.01-data/01-table-storage-access-options/readme.md), [Cosmos](../../../03.00-tech/03.01-data/02-cosmosdb-access-options/01-azure-cosmosdb-access-options.md), [Blob](../../../03.00-tech/03.01-data/03-blob-storage-access-options/01-blob-storage-access-options.md)) under "where this fits" (operational vs analytical stores).
- Each article → official Microsoft Learn references (decision guide, Synapse migration, OneLake, lakehouse overview, SQL database in Fabric).
- The sibling data-area folders were **not** edited: they do not cross-link each other today, so forcing back-links would break local consistency.

## ✅ What was done

1. Created the `04-microsoft-fabric/` subject folder with a readme index and three articles.
2. Reframed the introduction (no "problem" framing) and added source provenance + original diagrams.
3. Corrected sibling cross-links to the data area's actual entry files (numbered files, not all `readme.md`).
4. Rewrote the news [overview.md](../overview.md) as a concise English summary with references — not a duplicate of the generated material (the original Q2 thread was partly in Italian; per request, the integrated material is English).
5. Recorded this integration; the research artifacts remain for provenance.

**Residual follow-ups (📌 next steps):** confirm current Azure Analysis Services retirement dates before deepening that claim; refresh the T-SQL surface-area parity on next review; consider a Real-Time Intelligence (Eventhouse/KQL) article if a future observation touches streaming stores.
