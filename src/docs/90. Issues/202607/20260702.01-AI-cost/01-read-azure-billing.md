---
title: "Stream A implementation: Azure Cost Management export and usage details"
author: "Dario Airoldi"
date: "2026-07-02"
status: draft
severity: medium
domain: "finops / ingestion"
component: "stream-a-billing-baseline"
framework: "bronze-silver-gold"
goal: "Implement Stream A as the financial baseline for all downstream cost allocations."
description: "Practical guide to configure Azure Cost Management export, ingest raw data to Bronze, normalize in Silver, and validate reconciliation for Stream A."
---

# Stream A implementation: Azure Cost Management export and usage details

## 📋 Table of contents

1.  [🎯 Scope and outcome](#-scope-and-outcome)
2.  [✅ Prerequisites](#-prerequisites)
3.  [⚙️ Configure Azure Cost Management export](#-configure-azure-cost-management-export)
4.  [🧱 Bronze ingestion contract](#-bronze-ingestion-contract)
5.  [🧭 Silver normalization contract](#-silver-normalization-contract)
6.  [🧮 Normalization and allocation formula](#-normalization-and-allocation-formula)
7.  [🔍 Validation queries](#-validation-queries)
8.  [🚀 Immediate next steps](#-immediate-next-steps)
9.  [📚 References](#-references)

## 🎯 Scope and outcome

This document implements only <mark>Stream A</mark>:

-   Azure Cost Management export
-   Azure usage details

This stream is the <mark>financial baseline</mark> for your whole platform. Every other stream (Copilot, M365, app telemetry) can influence attribution proportions, but cannot change billed totals.

Outcome of Stream A:

-   Daily raw billing files persisted in Bronze.
-   Canonical Silver table (`fact_cloud_cost`) ready.
-   Reconciliation checks proving Silver totals equal exported totals.

## ✅ Prerequisites

-   Access to the Azure subscription scope you want to track.
-   Permission to configure Cost Management export at the selected scope.
-   A storage target for export files (for example <mark>ADLS Gen2</mark> or <mark>Blob</mark>).
-   A compute path for processing (<mark>Fabric/SQL/Spark/Data Factory or equivalent</mark>).

Recommended scope hierarchy:

1.  Start at one subscription.
2.  Expand to management group when Stream A is stable.

## ⚙️ Configure Azure Cost Management export

Set up one export for the baseline dataset.

1.  In Azure Portal, open <mark>Cost Management</mark> for your target scope.
2.  Open <mark>Exports</mark> and create a new export.
3.  Schedule: <mark>daily export</mark>.
4.  Dataset: use <mark>usage-level billing details</mark> <mark>with cost fields</mark>.
5.  Destination: storage path dedicated to Stream A.
6.  Naming: <mark>include scope and date in file names</mark>.

Recommended file path pattern:

``` text
bronze/azure/costmanagement/scope=<scope-id>/year=<yyyy>/month=<mm>/day=<dd>/
```

Minimum required columns (use canonical mapping because export flavors can differ):

-   <mark>Billing date</mark>: `UsageDate` (or equivalent date column).
-   <mark>Resource type</mark>: `ResourceType`.
-   <mark>Resource identifier</mark>: `ResourceId` (when available).
-   <mark>Resource group</mark>: `ResourceGroupName` (when available).
-   <mark>Subscription</mark>: `SubscriptionId`.
-   <mark>Cost amount</mark>: `CostInBillingCurrency` or equivalent (`BilledCost`, `CostUSD`, or `Cost`, depending on export flavor and extraction path).
-   <mark>Currency</mark>: `BillingCurrencyCode` (or `Currency`).
-   <mark>Service/meter category</mark>: `MeterCategory` / `MeterSubCategory` (or equivalent category fields).

Observed in your current extraction examples:

-   Sheet-level columns: `UsageDate`, `ResourceType`, `CostUSD`, `Cost`, `Currency`.
-   Export-level column families: `BilledCost`, `BillingCurrency...`, `ConsumedService`, `Resource...`, `Service...`, `Sku...`, plus `x_` prefixed variants in some dataset versions.

Compatibility rule for Stream A:

-   Always map source-specific column names into canonical fields before Silver.
-   Keep raw source columns unchanged in Bronze for audit and future remapping.
-   If both `CostUSD` and `Cost` exist, select one authoritative `cost_amount` and store the other as auxiliary metadata.

## 🧱 Bronze ingestion contract

Bronze rules are strict:

-   Append-only, immutable records.
-   No business transformations in Bronze.
-   Add ingestion metadata only.

Required ingestion metadata:

-   `ingestion_timestamp_utc`
-   `source_system` (for example `azure-cost-management-export`)
-   `source_scope_id`
-   `source_file_name`
-   `source_file_etag_or_hash`
-   `ingestion_batch_id`

Bronze table suggestion:

-   `bronze_azure_cost_export_raw`

## 🧭 Silver normalization contract

Silver transforms raw billing rows into canonical billing facts.

Silver table suggestion:

-   `fact_cloud_cost`

Canonical fields:

-   `billing_date`
-   `provider` (fixed value: `azure`)
-   `subscription_id`
-   `resource_group_name`
-   `resource_id`
-   `resource_type`
-   `meter_category`
-   `meter_subcategory`
-   `cost_amount`
-   `currency`
-   `cost_bucket_key`

`cost_bucket_key` must encode the partition used as normalization denominator, for example:

``` text
<billing_month>|<subscription_id>|<resource_group_name>|<resource_type>|<meter_category>
```

## 🧮 Normalization and allocation formula

Stream A defines actual cost by bucket. Downstream usage streams only redistribute inside each bucket.

Allocation formula:

$$
allocated\_cost_{i} = actual\_cost_{bucket} \times \frac{usage\_weight_{i}}{\sum usage\_weight_{bucket}}
$$

Bucket identity constraint:

$$
\sum allocated\_cost_{bucket} = actual\_cost_{bucket}
$$

Important rule:

-   If usage is missing for a bucket, send that cost to `unattributed` for the same bucket.
-   Never create synthetic cost outside Stream A totals.

## 🔍 Validation queries

Run these checks after each daily load.

1.  Bronze completeness

``` sql
SELECT
    CAST(ingestion_timestamp_utc AS date) AS load_date,
    COUNT(*) AS rows_loaded
FROM bronze_azure_cost_export_raw
GROUP BY CAST(ingestion_timestamp_utc AS date)
ORDER BY load_date DESC;
```

2.  Silver financial reconciliation

``` sql
SELECT
    billing_date,
    SUM(cost_amount) AS silver_cost
FROM fact_cloud_cost
GROUP BY billing_date
ORDER BY billing_date DESC;
```

3.  Export vs Silver variance (target = zero)

``` sql
WITH export_totals AS (
    SELECT
        UsageDate AS billing_date,
        SUM(CostInBillingCurrency) AS export_cost
    FROM bronze_azure_cost_export_raw
    GROUP BY UsageDate
),
silver_totals AS (
    SELECT
        billing_date,
        SUM(cost_amount) AS silver_cost
    FROM fact_cloud_cost
    GROUP BY billing_date
)
SELECT
    e.billing_date,
    e.export_cost,
    s.silver_cost,
    (s.silver_cost - e.export_cost) AS variance
FROM export_totals e
LEFT JOIN silver_totals s ON s.billing_date = e.billing_date
ORDER BY e.billing_date DESC;
```

## 🚀 Immediate next steps

1.  Configure export and verify first file arrives.
2.  Build Bronze ingestion job (append-only + ingestion metadata).
3.  Build Silver normalization job with `cost_bucket_key`.
4.  Add reconciliation query as a blocking quality gate.
5.  Only after Stream A is stable, onboard Stream B (Copilot usage) and Stream C (M365 usage).

## 📚 References

[**Azure Cost Management documentation**](https://learn.microsoft.com/azure/cost-management-billing/cost-management-billing-overview) 📘 \[Official\]\
Description (2-4 sentences): Official overview of Azure Cost Management capabilities and billing analysis features. Use this as the baseline guidance for scope selection and financial governance. It is the authoritative source for understanding billing truth boundaries.

[**Understand usage details fields for Azure billing**](https://learn.microsoft.com/azure/cost-management-billing/automate/understand-usage-details-fields) 📘 \[Official\]\
Description (2-4 sentences): Field-level reference for Azure billing exports and usage details. Use this to map exported columns into the canonical Stream A schema. This is the key reference for stable transformations and reconciliation quality.

```{=html}
<!--
validations:
        grammar: {status: "not_run", last_run: null}
        readability: {status: "not_run", last_run: null}
        links: {status: "not_run", last_run: null}
        structure: {status: "not_run", last_run: null}

article_metadata:
        filename: "01-read-azure-billing.md"
        last_updated: "2026-07-02"
        update_summary: "Initial actionable Stream A guide for Azure Cost Management export ingestion, normalization, and reconciliation."
-->
```