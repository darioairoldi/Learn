---
title: "Azure Naming Conventions"
description: "Standardized naming convention for Azure resources following Microsoft Cloud Adoption Framework best practices"
author: "Dario Airoldi"
date: "July 2, 2025"
date-modified: last-modified
categories: [azure, naming, conventions, best-practices, cloud-adoption-framework]
format:
  html:
    toc: true
    toc-depth: 3
---

## Table of Contents

1. [Overview](#overview)
2. [Core Naming Pattern](#core-naming-pattern)
3. [Environment Identifiers](#environment-identifiers)
4. [Region Codes](#region-codes)
5. [Azure Resource Types and Naming Rules](#azure-resource-types-and-naming-rules)
6. [Practical Examples](#practical-examples)
7. [Special Naming Considerations](#special-naming-considerations)
8. [Resource Tagging Strategy](#resource-tagging-strategy)
9. [Implementation Guidelines](#implementation-guidelines)
10. [Other Documented Practices](#other-documented-practices)
11. [Quick Reference](#quick-reference)

---

## Overview

This document establishes a standardized naming convention for Azure resources based on the **Microsoft Cloud Adoption Framework (CAF)** best practices. The naming pattern provides consistency across Azure subscriptions, environments, and regions while maintaining compliance with Azure-specific naming restrictions.

**Purpose:**
- Ensure consistent resource naming across all Azure deployments
- Enable easy identification of resource ownership, environment, and location
- Facilitate automation, cost tracking, and resource management
- Align with Microsoft recommended practices

**Document Information:**
- **Version**: 2.0
- **Date**: October 19, 2025
- **Based on**: [Microsoft Cloud Adoption Framework - Resource Naming](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

---

## Core Naming Pattern

### Standard Pattern

> **📋 Pattern:** `{workload}-{environment}-{resourcetype}-{region}-{instance}`

**Components:**

| Component | Description | Format | Example |
|-----------|-------------|--------|---------|
| **{workload}** | Application or workload name | lowercase, alphanumeric, hyphens | `samples`, `ecommerce`, `hr-portal` |
| **{environment}** | Deployment environment | 2-6 letter code | `dev`, `test`, `prod`, `testmc` |
| **{resourcetype}** | Azure resource type | 2-3 letter abbreviation | `rg`, `app`, `sql`, `akv` |
| **{region}** | Azure region | 2-4 letter code | `weu`, `eus`, `sea` |
| **{instance}** | Instance number | 2-digit zero-padded | `01`, `02`, `03` |

### Understanding the Pattern

```text
samples-testmc-rg-weu-01
   │      │     │   │   │
   │      │     │   │   └─ Instance number (01)
   │      │     │   └───── Region (weu = West Europe)
   │      │     └───────── Resource type (rg = Resource Group)
   │      └─────────────── Environment (testmc)
   └────────────────────── Workload (samples)
```

### Why This Pattern?

**Aligned with Microsoft CAF:**
- Follows [Microsoft's recommended structure](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- Provides clear hierarchy: business context → environment → resource → location
- Facilitates multi-region deployments

**Benefits:**

1. **Clear Environment Segregation** - Easy to identify which environment a resource belongs to
2. **Multi-Region Support** - Region identifier enables global deployments
3. **Resource Type Visibility** - Quick identification of resource type
4. **Scalability** - Instance numbers support multiple deployments
5. **Automation-Friendly** - Structured format simplifies scripting and IaC

---

## Environment Identifiers

Standard environment codes used across all resources:

| Environment | Code | Description | Typical Use |
|-------------|------|-------------|-------------|
| **Development** | `dev` | Development environment | Local/team development |
| **Test** | `test` | Testing environment | QA and integration testing |
| **Staging** | `stg` | Pre-production staging | Production-like testing |
| **Production** | `prod` | Production environment | Live workloads |
| **Test MC** | `testmc` | Microsoft Customer test | Customer-specific testing |
| **Test Personal** | `testpers` | Personal learning | Individual learning/POC |
| **Test AB** | `testab` | Customer A/B testing | A/B testing scenarios |

**Custom Environments:**
- Format: `test{name}` or abbreviation
- Keep codes short (2-6 characters) for name length compliance
- Document all custom environments in this section

---

## Region Codes

Standard Azure region abbreviations (2-4 letters):

### Americas

| Region | Code | Region | Code |
|--------|------|--------|------|
| East US | `eus` | East US 2 | `eus2` |
| Central US | `cus` | North Central US | `ncus` |
| South Central US | `scus` | West Central US | `wcus` |
| West US | `wus` | West US 2 | `wus2` |
| West US 3 | `wus3` | Canada Central | `cac` |
| Canada East | `cae` | Brazil South | `brs` |
| Brazil Southeast | `brse` | | |

### Europe

| Region | Code | Region | Code |
|--------|------|--------|------|
| **North Europe** | `neu` | **West Europe** | `weu` |
| UK South | `uks` | UK West | `ukw` |
| France Central | `frc` | France South | `frs` |
| Germany West Central | `gwc` | Germany North | `gn` |
| Norway East | `noe` | Norway West | `now` |
| Switzerland North | `swn` | Switzerland West | `sww` |
| Sweden Central | `swc` | Poland Central | `plc` |
| Italy North | `itn` | Spain Central | `spc` |

### Asia Pacific

| Region | Code | Region | Code |
|--------|------|--------|------|
| East Asia | `ea` | Southeast Asia | `sea` |
| Japan East | `jpe` | Japan West | `jpw` |
| Australia East | `aue` | Australia Southeast | `ause` |
| Australia Central | `auc` | Australia Central 2 | `auc2` |
| India Central | `inc` | India South | `ins` |
| India West | `inw` | Korea Central | `krc` |
| Korea South | `krs` | | |

### Middle East & Africa

| Region | Code | Region | Code |
|--------|------|--------|------|
| UAE North | `uaen` | UAE Central | `uaec` |
| South Africa North | `san` | South Africa West | `saw` |
| Qatar Central | `qac` | Israel Central | `ilc` |

**Note:** Region codes can be omitted for resource group-scoped resources in single-region deployments, but are recommended for globally scoped resources.

---

## Azure Resource Types and Naming Rules

> **⚠️ Important:** Each Azure resource type has specific naming restrictions. Always verify your names comply with Azure requirements.

### Core Infrastructure

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Resource Group** | `rg` | Subscription | 1-90 | Alphanumerics, underscores, parentheses, hyphens, periods | `samples-testmc-rg-weu-01` |
| **Virtual Network** | `vnet` | Resource Group | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-dev-vnet-weu-01` |
| **Subnet** | `snet` | Virtual Network | 1-80 | Alphanumerics, underscores, periods, hyphens | `samples-dev-snet-weu-01` |
| **Network Security Group** | `nsg` | Resource Group | 1-80 | Alphanumerics, underscores, periods, hyphens | `samples-dev-nsg-weu-01` |

### Storage Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Storage Account** | `st` | Global | 3-24 | Lowercase letters and numbers | `samplestestmcstweu01` |
| **File Share** | `share` | Storage Account | 3-63 | Lowercase letters, numbers, hyphens | `samples-testmc-share-weu-01` |

**Note**: Storage account names cannot contain hyphens and must be globally unique. Use concatenated format without hyphens.

---

### Data Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **App Configuration** | `appcs` | Global | 5-50 | Alphanumerics and hyphens | `samples-testmc-appcs-weu-01` |
| **Cosmos DB Account (NoSQL)** | `cosno` | Global | 3-44 | Lowercase letters, numbers, hyphens | `samples-prod-cosno-eus-01` |
| **Cosmos DB Account (MongoDB)** | `cosmon` | Global | 3-44 | Lowercase letters, numbers, hyphens | `samples-prod-cosmon-eus-01` |
| **Cosmos DB Account (generic)** | `cosmos` | Global | 3-44 | Lowercase letters, numbers, hyphens | `samples-prod-cosmos-eus-01` |
| **SQL Server** | `sql` | Global | 1-63 | Lowercase letters, numbers, hyphens | `samples-prod-sql-eus-01` |
| **SQL Database** | `sqldb` | SQL Server | 1-128 | Various characters allowed | `samples-prod-sqldb-eus-01` |
| **Azure Cache for Redis** | `redis` | Global | 1-63 | Alphanumerics and hyphens | `samples-dev-redis-weu-01` |
| **MySQL Server** | `mysql` | Global | 3-63 | Lowercase letters, numbers, hyphens | `samples-dev-mysql-weu-01` |
| **PostgreSQL Server** | `psql` | Global | 3-63 | Lowercase letters, numbers, hyphens | `samples-dev-psql-weu-01` |

### Messaging Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Service Bus Namespace** | `sbns` | Global | 6-50 | Alphanumerics and hyphens, start with letter | `samples-prod-sbns-eus-01` |
| **Event Hub Namespace** | `evhns` | Global | 6-50 | Alphanumerics and hyphens, start with letter | `samples-prod-evhns-eus-01` |
| **Event Hub** | `evh` | Event Hub Namespace | 1-256 | Alphanumerics, periods, hyphens, underscores | `samples-prod-evh-eus-01` |
| **Event Grid Topic** | `evgt` | Resource Group | 3-50 | Alphanumerics and hyphens | `samples-dev-evgt-weu-01` |
| **Event Grid System Topic** | `egst` | Resource Group | 3-50 | Alphanumerics and hyphens | `samples-dev-egst-weu-01` |

### Compute Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Virtual Machine** | `vm` | Resource Group | 1-15 (Win), 1-64 (Linux) | Limited special chars | `samples-dev-vm-weu-01` |
| **App Service Plan** | `asp` | Resource Group | 1-60 | Alphanumerics and hyphens | `samples-prod-asp-eus-01` |
| **Web App** | `app` | Global | 2-60 | Alphanumerics and hyphens | `samples-prod-app-eus-01` |
| **Function App** | `func` | Global | 2-60 | Alphanumerics and hyphens | `samples-prod-func-eus-01` |
| **Container App** | `ca` | Resource Group | 2-32 | Lowercase letters, numbers, hyphens | `samples-dev-ca-weu-01` |
| **Container Apps Environment** | `cae` | Resource Group | 2-32 | Lowercase letters, numbers, hyphens | `samples-dev-cae-weu-01` |
| **Container Registry** | `cr` | Global | 5-50 | Alphanumerics only | `samplesprodcreus01` |

**Note**: Function apps use `func` as the official Microsoft abbreviation.

### AI and Cognitive Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **OpenAI Service** | `oai` | Global | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-prod-oai-eus-01` |
| **Azure AI Services (multi-service)** | `ais` | Global | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-dev-ais-weu-01` |
| **AI Search** | `srch` | Global | 2-60 | Lowercase letters, numbers, hyphens | `samples-prod-srch-eus-01` |
| **Azure Machine Learning Workspace** | `mlw` | Resource Group | 2-260 | Alphanumerics and hyphens | `samples-prod-mlw-eus-01` |

**Note**: Microsoft changed naming - "Azure Cognitive Search" is now "AI Search" with abbreviation `srch`. "Cognitive Services" multi-service accounts use `ais`.

### Monitoring & Observability Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Application Insights** | `appi` | Resource Group | 1-260 | Alphanumerics, hyphens, periods, underscores, parentheses | `samples-testmc-appi-itn-01` |
| **Log Analytics Workspace** | `log` | Resource Group | 4-63 | Alphanumerics and hyphens | `samples-prod-log-eus-01` |
| **Azure Monitor Action Group** | `ag` | Resource Group | 1-260 | Alphanumerics, hyphens, periods, underscores | `samples-prod-ag-eus-01` |
| **Data Collection Rule** | `dcr` | Resource Group | 1-64 | Alphanumerics, hyphens, underscores | `samples-prod-dcr-eus-01` |
| **Data Collection Endpoint** | `dce` | Resource Group | 1-64 | Alphanumerics, hyphens, underscores | `samples-prod-dce-eus-01` |

**Note**: Application Insights uses `appi` and Log Analytics uses `log` per Microsoft CAF official abbreviations.

### Container Orchestration

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Azure Kubernetes Service (AKS)** | `aks` | Resource Group | 1-63 | Alphanumerics, hyphens, underscores | `samples-prod-aks-eus-01` |
| **AKS System Node Pool** | `npsystem` | AKS Cluster | 1-12 | Lowercase letters and numbers | `npsystem` |
| **AKS User Node Pool** | `np` | AKS Cluster | 1-12 | Lowercase letters and numbers | `np01` |
| **Container Instance** | `ci` | Resource Group | 1-63 | Lowercase letters, numbers, hyphens | `samples-dev-ci-weu-01` |

**Note**: AKS cluster names should be descriptive but concise due to the 63-character limit and DNS name requirements.

### Analytics & Data Platform

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Azure Data Factory** | `adf` | Global | 3-63 | Alphanumerics and hyphens | `samples-prod-adf-eus-01` |
| **Azure Synapse Analytics Workspace** | `synw` | Global | 1-50 | Alphanumerics and hyphens | `samples-prod-synw-eus-01` |
| **Azure Databricks Workspace** | `dbw` | Resource Group | 3-64 | Alphanumerics, underscores, hyphens | `samples-prod-dbw-eus-01` |
| **Microsoft Fabric Capacity** | `fc` | Global | 1-256 | Alphanumerics and spaces | `samples-prod-fc-eus-01` |
| **Stream Analytics Job** | `asa` | Resource Group | 3-63 | Alphanumerics, hyphens, underscores | `samples-prod-asa-eus-01` |
| **Data Lake Storage Gen2** | `dls` | Global | 3-24 | Lowercase letters and numbers | `samplesproddles01` |

**Note**: Data Lake Storage Gen2 follows the same naming constraints as Storage Accounts (no hyphens, lowercase only). Fabric Workspace is not officially documented, so Fabric Capacity (`fc`) is used.

### Security Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Key Vault** | `kv` | Global | 3-24 | Alphanumerics and hyphens | `samples-prod-kv-eus-01` |
| **Managed Identity** | `mi` or `id` | Resource Group | 3-128 | Alphanumerics, underscores, hyphens | `samples-prod-id-eus-01` |

**Note**: Microsoft's official abbreviation for Key Vault is `kv` and for Managed Identity is `id`.

---

## Practical Examples

> **💡 Real-world examples** showing how the naming convention applies to common scenarios.

### Example 1: Simple Web Application (Single Region)

```text
Resource Group:      samples-prod-rg-eus-01
App Service Plan:    samples-prod-asp-eus-01
Web App:             samples-prod-app-eus-01
SQL Server:          samples-prod-sql-eus-01
SQL Database:        samples-prod-sqldb-eus-01
Key Vault:           samples-prod-kv-eus-01
Storage Account:     samplesprodsteus01
```

### Example 2: Multi-Region Deployment

```text
# West Europe (Primary)
samples-prod-rg-weu-01
samples-prod-app-weu-01
samples-prod-sql-weu-01
samples-prod-cosno-weu-01

# East US (Secondary)
samples-prod-rg-eus-01
samples-prod-app-eus-01
samples-prod-sql-eus-01
samples-prod-cosno-eus-01
```

### Example 3: Development Environment

```text
Resource Group:      samples-dev-rg-weu-01
Container App Env:   samples-dev-cae-weu-01
Container App:       samples-dev-ca-weu-01
Cosmos DB (NoSQL):   samples-dev-cosno-weu-01
Key Vault:           samples-dev-kv-weu-01
App Configuration:   samples-dev-appcs-weu-01
```

### Example 4: Messaging Architecture

```text
Resource Group:        samples-prod-rg-eus-01
Service Bus:           samples-prod-sbns-eus-01
Event Hub Namespace:   samples-prod-evhns-eus-01
Event Hub:             samples-prod-evh-eus-01
Event Grid Topic:      samples-prod-evgt-eus-01
Function App:          samples-prod-func-eus-01
```

### Example 5: AI/ML Workload

```text
Resource Group:      samples-dev-rg-weu-01
OpenAI Service:      samples-dev-oai-weu-01
AI Search:           samples-dev-srch-weu-01
AI Services:         samples-dev-ais-weu-01
Storage Account:     samplesdevstweu01
Container Registry:  samplesdevcrweu01
```

### Example 6: Kubernetes (AKS) Deployment

```text
Resource Group:           samples-prod-rg-eus-01
AKS Cluster:              samples-prod-aks-eus-01
Container Registry:       samplesprodcreus01
Log Analytics:            samples-prod-log-eus-01
Application Insights:     samples-prod-appi-eus-01
Key Vault:                samples-prod-kv-eus-01
```

### Example 7: Data Analytics Platform

```text
Resource Group:           samples-prod-rg-eus-01
Data Factory:             samples-prod-adf-eus-01
Synapse Workspace:        samples-prod-synw-eus-01
Data Lake Storage:        samplesproddlseus01
Databricks Workspace:     samples-prod-dbw-eus-01
Stream Analytics Job:     samples-prod-asa-eus-01
Log Analytics:            samples-prod-log-eus-01
```

### Example 8: Microservices with Observability

```text
Resource Group:           samples-prod-rg-weu-01
Container Apps Env:       samples-prod-cae-weu-01
Container App (API):      samples-prod-ca-weu-01
Container App (Worker):   samples-prod-ca-weu-02
Application Insights:     samples-prod-appi-weu-01
Log Analytics:            samples-prod-log-weu-01
Service Bus:              samples-prod-sbns-weu-01
Redis Cache:              samples-prod-redis-weu-01
```

### Example 9: Microsoft Fabric Workspace

```text
Resource Group:           samples-prod-rg-eus-01
Fabric Capacity:          samples-prod-fc-eus-01
Data Lake Storage:        samplesproddlseus01
Key Vault:                samples-prod-kv-eus-01
```

---

## Special Naming Considerations

> **⚠️ Critical constraints** that affect resource naming in Azure.

### Global Uniqueness Requirements

Resources with global scope need unique names across all Azure:

- Storage accounts
- Web apps, Function apps, API apps
- Key Vaults
- Cosmos DB accounts
- SQL servers
- Service Bus namespaces
- Event Hub namespaces
- Container registries
- AI Search services
- OpenAI services

**Strategy**: 
- Include region codes for geographic uniqueness
- Use environment identifiers to differentiate deployments
- Consider adding organization/workload-specific prefixes

### Character Restrictions

| Resource Type | Special Restrictions |
|---------------|---------------------|
| **Storage Accounts** | No hyphens, lowercase only, 3-24 characters |
| **Container Registry** | Alphanumerics only, 5-50 characters |
| **Virtual Machines** | Limited special characters, length varies by OS |
| **Container Apps** | Lowercase only, 2-32 characters |
| **Cosmos DB** | Lowercase only, must start with letter |

### Length Limitations

When names approach or exceed Azure limits:

1. **Use shorter region codes** - `weu` instead of `westeu`
2. **Abbreviate workload names** - `hrportal` → `hr`
3. **Shorten environment codes** - `testpersonal` → `testpers`
4. **Omit region for RG-scoped resources** in single-region deployments
5. **Use single-digit instances** when possible

### Regional Considerations

**When to include region:**
- ✅ Globally scoped resources (required for tracking)
- ✅ Multi-region deployments (critical for identification)
- ✅ Disaster recovery scenarios
- ⚠️ Resource group-scoped resources (optional, but recommended)

**When region can be omitted:**
- Resource group-scoped resources in single-region deployments
- Resources that don't move between regions
- When name length is a concern

---

## Resource Tagging Strategy

> **🏷️ Complement naming** with standardized resource tags for better organization and cost tracking.

Tags provide additional metadata that naming alone cannot convey:

### Standard Tag Set

```json
{
  "Environment": "prod",
  "Workload": "samples",
  "Owner": "engineering-team",
  "CostCenter": "IT-123",
  "BusinessUnit": "Engineering",
  "DataClassification": "internal",
  "Criticality": "medium",
  "CreatedDate": "2025-10-19",
  "CreatedBy": "automation",
  "Project": "learning-platform",
  "MaintenanceWindow": "weekend"
}
```

### Tag Guidelines

1. **Required Tags** (Minimum):
   - `Environment` - Deployment environment
   - `Owner` - Team or individual responsible
   - `CostCenter` - For cost allocation

2. **Recommended Tags**:
   - `Workload` - Application or service name
   - `BusinessUnit` - Organizational unit
   - `Criticality` - Business impact level

3. **Optional Tags**:
   - `Project` - Project or initiative name
   - `DataClassification` - Data sensitivity level
   - `MaintenanceWindow` - Scheduled maintenance time
   - `BackupPolicy` - Backup requirements
   - `Compliance` - Regulatory requirements

### Tag Best Practices

- Use consistent casing (PascalCase recommended)
- Keep values short and descriptive
- Avoid sensitive information in tags
- Automate tag application via IaC
- Review and update tags regularly

---

## Implementation Guidelines

> **🚀 Practical steps** for implementing and maintaining the naming convention.

### 1. Validation Checklist

Before creating any Azure resource:

- [ ] Resource name follows `{workload}-{environment}-{resourcetype}-{region}-{instance}` pattern
- [ ] Name meets Azure length requirements (check table above)
- [ ] Characters are valid for the specific resource type
- [ ] Global resources have unique names (checked in Azure Portal or CLI)
- [ ] Region code matches actual deployment region
- [ ] Environment code is documented and approved
- [ ] Instance number is sequential and documented
- [ ] Required tags are defined and applied

### 2. Automation Considerations

**Infrastructure as Code (IaC):**

```bicep
// Bicep parameter example
param workloadName string = 'samples'
param environmentName string = 'prod'
param regionCode string = 'weu'
param instanceNumber string = '01'

// Generate resource names
var resourceGroupName = '${workloadName}-${environmentName}-rg-${regionCode}-${instanceNumber}'
var appServicePlanName = '${workloadName}-${environmentName}-asp-${regionCode}-${instanceNumber}'
var webAppName = '${workloadName}-${environmentName}-app-${regionCode}-${instanceNumber}'
```

**PowerShell Helper Function:**

```powershell
function New-AzureResourceName {
    param(
        [string]$Workload,
        [string]$Environment,
        [string]$ResourceType,
        [string]$Region,
        [string]$Instance = "01"
    )
    return "$Workload-$Environment-$ResourceType-$Region-$Instance"
}

# Usage
$rgName = New-AzureResourceName -Workload "samples" -Environment "prod" -ResourceType "rg" -Region "weu"
```

**Azure CLI Validation:**

```bash
# Check if resource name exists (for globally scoped resources)
az storage account check-name --name samplesprodstgweu01
az webapp show --name samples-prod-app-weu-01 --resource-group samples-prod-rg-weu-01
```

### 3. Documentation Requirements

Maintain documentation for:

- **Custom environment codes** - Document any non-standard environment identifiers
- **Region code mappings** - Keep region abbreviation reference updated
- **Workload registry** - Track all workload names in use
- **Exceptions** - Document any naming convention deviations with justification
- **Version history** - Track changes to naming convention over time

### 4. Naming Convention Enforcement

**Policy Enforcement:**
- Use Azure Policy to enforce naming patterns
- Implement naming validation in CI/CD pipelines
- Use Git pre-commit hooks for IaC validation

**Code Review Guidelines:**
- Verify naming compliance during PR reviews
- Check for duplicate or conflicting names
- Validate tag completeness

---

## Other Documented Practices

> **📚 Alternative naming patterns** from Microsoft and industry best practices.

This section compares different naming approaches to help you understand the rationale behind our chosen pattern.

### 1. Microsoft CAF Resource-Type-First Pattern

**Pattern:** `{resourcetype}-{workload}-{environment}-{region}-{instance}`

**Example:** `rg-samples-prod-weu-01`

**Description:**
Microsoft's Cloud Adoption Framework suggests resource type as the first component, emphasizing what the resource is before its business context.

**Pros:**
- ✅ Official Microsoft recommendation
- ✅ Resources grouped by type alphabetically
- ✅ Easy to identify resource type at a glance
- ✅ Useful for resource type-focused operations

**Cons:**
- ❌ Business context (workload/environment) not immediately visible
- ❌ Harder to filter by workload across resource types
- ❌ Less intuitive for application-centric teams
- ❌ Alphabetical grouping splits related resources

**When to use:**
- Infrastructure-focused teams
- Type-based resource management
- When resource type is more important than business context

**Reference:** [Microsoft CAF Naming Convention](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

---

### 2. Workload-Type-Environment Pattern

**Pattern:** `{workload}-{resourcetype}-{environment}-{region}-{instance}`

**Example:** `samples-rg-prod-weu-01`

**Description:**
Prioritizes workload identity, then resource type, then environment. This pattern emphasizes resource type before environment context.

**Pros:**
- ✅ Workload-first approach
- ✅ Resource types visible early in name
- ✅ Good for multi-resource workloads
- ✅ Simpler than full CAF pattern

**Cons:**
- ❌ Environment context buried in the middle
- ❌ Harder to filter by environment
- ❌ Less clear environment separation
- ❌ Not aligned with CAF recommendations

**When to use:**
- Small organizations with few environments
- Workloads with many resource types
- Type-focused operations within workloads

---

### 3. Prefix-Based Legacy Pattern

**Pattern:** `{prefix}-{projectname}-{environment}-{resourcetype}-{instance}`

**Example:** `samples-cosmosdb-testpersonal-cdb-01`

**Description:**
Uses a constant prefix (like "samples" or company abbreviation) followed by project name, often used in learning or multi-project environments. This was the previous version of this document.

**Pros:**
- ✅ Clear organizational identity via prefix
- ✅ Project names highly visible
- ✅ Good for learning/sample resources
- ✅ Easy code-to-resource traceability

**Cons:**
- ❌ Not aligned with Microsoft CAF
- ❌ Prefix adds extra length
- ❌ Less scalable for enterprise
- ❌ Region not included (single-region assumption)

**When to use:**
- Learning environments
- Sample/demo projects
- Multi-project workspaces with strong identity needs
- Single-region deployments

---

### 4. Minimalist Pattern

**Pattern:** `{workload}-{environment}-{instance}`

**Example:** `samples-prod-01`

**Description:**
Removes resource type and region from the name entirely, relying on Azure resource types and tags for classification.

**Pros:**
- ✅ Shortest possible names
- ✅ No character limit concerns
- ✅ Very simple to implement
- ✅ Clean, uncluttered naming

**Cons:**
- ❌ Resource type not visible in name
- ❌ Region not identifiable
- ❌ Requires tags for full context
- ❌ Poor multi-region support
- ❌ Difficult to distinguish resources without additional context

**When to use:**
- Small environments with few resource types
- Single-region deployments only
- When name length is extremely constrained
- Strong tagging infrastructure in place

---

### 5. Our Chosen Pattern (Workload-First with Region)

**Pattern:** `{workload}-{environment}-{resourcetype}-{region}-{instance}`

**Example:** `samples-prod-rg-weu-01`

**Description:**
Our adopted pattern prioritizes business context (workload and environment) while maintaining resource type visibility and explicit region identification.

**Pros:**
- ✅ Business context first (workload and environment)
- ✅ Clear environment segregation
- ✅ Excellent multi-region support
- ✅ Resource type still visible
- ✅ Balanced approach between CAF and practical needs
- ✅ Scalable for enterprise use

**Cons:**
- ❌ Slightly longer than minimalist approaches
- ❌ Not 100% CAF-compliant (workload before resource type)
- ❌ Requires documented region codes

**When to use:**
- Multi-environment organizations
- Multi-region deployments
- Application/workload-focused teams
- Balance between Microsoft guidance and practical needs

**Why we chose this:**
This pattern provides the best balance between Microsoft's recommendations and practical application development needs. It prioritizes how teams think about resources (by workload and environment first) while maintaining all critical information including region for global deployments.

---

## Quick Reference

> **� Comprehensive reference** for Azure naming conventions and related documentation.

### Official Microsoft Documentation

#### Cloud Adoption Framework (CAF)

1. **[Define your naming convention](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)**
   - Primary resource naming guidance
   - Recommended component order and structure
   - Best practices and examples

2. **[Abbreviation examples for Azure resources](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)**
   - Official Microsoft resource type abbreviations
   - Comprehensive list of Azure services
   - Standardized abbreviation recommendations

3. **[Azure Naming Tool](https://github.com/microsoft/CloudAdoptionFramework/tree/master/ready/AzNamingTool)**
   - Interactive tool for generating names
   - Configurable naming patterns
   - Validation and compliance checking

#### Azure Well-Architected Framework

4. **[Recommendations for naming and tagging](https://learn.microsoft.com/azure/well-architected/operational-excellence/naming-tagging)**
   - Operational excellence perspective
   - Tagging strategy guidance
   - Best practices for governance

#### Azure Service-Specific Documentation

5. **[Azure resource naming restrictions](https://learn.microsoft.com/azure/azure-resource-manager/management/resource-name-rules)**
   - Complete list of naming rules per service
   - Character limitations and requirements
   - Scope and length constraints

6. **[Azure regions](https://azure.microsoft.com/global-infrastructure/geographies/)**
   - Official Azure region documentation
   - Regional availability and capabilities
   - Geography and compliance information

### Quick Lookup Tables

#### Common Resource Type Abbreviations

| Type | Abbr | Type | Abbr | Type | Abbr |
|------|------|------|------|------|------|
| Resource Group | `rg` | Virtual Network | `vnet` | Storage Account | `st` |
| App Service Plan | `asp` | Web App | `app` | Function App | `func` |
| Container App | `ca` | SQL Server | `sql` | SQL Database | `sqldb` |
| Cosmos DB (NoSQL) | `cosno` | Cosmos DB (MongoDB) | `cosmon` | Key Vault | `kv` |
| Service Bus Namespace | `sbns` | Event Hub Namespace | `evhns` | Event Hub | `evh` |
| Event Grid Topic | `evgt` | OpenAI | `oai` | AI Search | `srch` |
| AI Services | `ais` | Virtual Machine | `vm` | Managed Identity | `id` |
| Container Registry | `cr` | Redis Cache | `redis` | Network Security Group | `nsg` |
| Application Insights | `ai` or `appi` | Log Analytics | `log` | Azure Monitor Action Group | `ag` |
| AKS Cluster | `aks` | Container Instance | `ci` | Data Factory | `adf` |
| Synapse Workspace | `synw` | Databricks | `dbw` | Fabric Capacity | `fc` |
| Stream Analytics | `asa` | Data Lake Storage | `dls` | File Share | `share` |

#### Common Environment Codes

| Environment | Code | Environment | Code |
|-------------|------|-------------|------|
| Development | `dev` | Test | `test` |
| Staging | `stg` | Production | `prod` |
| Test MC | `testmc` | Test Personal | `testpers` |

#### Common Region Codes (Top 10 Used)

| Region | Code | Region | Code |
|--------|------|--------|------|
| **West Europe** | `weu` | **East US** | `eus` |
| North Europe | `neu` | East US 2 | `eus2` |
| UK South | `uks` | Central US | `cus` |
| West US 2 | `wus2` | Southeast Asia | `sea` |
| Canada Central | `cac` | Australia East | `aue` |

### Pattern Template

```
{workload}-{environment}-{resourcetype}-{region}-{instance}

Examples:
samples-prod-rg-weu-01        (Resource Group)
samples-prod-app-weu-01       (Web App)
samples-prod-sql-eus-01       (SQL Server)
samples-dev-cdb-weu-01        (Cosmos DB)
samplesprodstgweu01           (Storage Account - no hyphens)
```

### Validation Checklist

- [ ] Follows `{workload}-{environment}-{resourcetype}-{region}-{instance}` pattern
- [ ] Meets Azure length requirements for resource type
- [ ] Uses only valid characters for resource type
- [ ] Globally unique for globally-scoped resources
- [ ] Region code matches deployment region
- [ ] Environment code is documented
- [ ] Instance number is sequential
- [ ] Tags are defined and complete

---

**Document Owner**: Engineering Team  
**Next Review**: January 19, 2026  
**Version History**: 
- 2.0 - Updated to CAF-aligned pattern (October 19, 2025)
- 1.0 - Initial creation (July 2, 2025)
