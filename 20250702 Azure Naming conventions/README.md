---
title: "Azure Naming Conventions"
description: "Standardized naming convention for Azure sample projects across multiple subscriptions"
author: "Dario Airoldi"
date: "July 2, 2025"
date-modified: last-modified
categories: [azure, naming, conventions, best-practices]
format:
  html:
    toc: true
    toc-depth: 3
---

## Table of Contents

1. [Document Information](#document-information)
2. [Executive Summary](#executive-summary)
3. [Core Naming Pattern](#core-naming-pattern)
4. [Environment Identifiers](#environment-identifiers)
5. [Sample Categories](#sample-categories)
6. [Azure Resource Types and Naming Rules](#azure-resource-types-and-naming-rules)
7. [Sample-Specific Examples](#sample-specific-examples)
8. [Cross-Environment Examples](#cross-environment-examples)
9. [Special Naming Considerations](#special-naming-considerations)
10. [Resource Tagging Strategy](#resource-tagging-strategy)
11. [Implementation Guidelines](#implementation-guidelines)
12. [Maintenance and Updates](#maintenance-and-updates)
13. [Quick Reference](#quick-reference)

## Document Information

- **Version**: 1.0
- **Date**: July 2, 2025
- **Purpose**: Standardized naming convention for Azure sample projects across multiple subscriptions

## Executive Summary

This document establishes a consistent naming convention for Azure sample resources across multiple Azure subscriptions. The convention prioritizes business context over resource types while maintaining compliance with Azure naming restrictions.

## Core Naming Pattern

> **📋 Standard Pattern:** `samples-{projectname}-{environment}-{type}-{##}`

> **📋 Optional Category Pattern:** `samples-{category}-{projectname}-{environment}-{type}-{##}`

**Components:**

- `samples` - Identifies resources as learning/sample projects
- `{projectname}` - Actual project/solution name (e.g., cosmosdbsample, servicebussample)
- `{environment}` - Environment context identifier (may span multiple subscriptions)
- `{type}` - Azure resource type abbreviation (2-3 letter standard)
- `{##}` - Instance number (01, 02, etc.)
- `{category}` - Optional domain category prefix for complex scenarios

### Understanding the Pattern with Examples

Let's break down the naming convention using real examples:

#### Example 1: CosmosDB Sample

```text
samples-cosmosdbsample-testpersonal-cdb-01
   │         │            │          │   │
   │         │            │          │   └─ Instance number
   │         │            │          └───── Resource type (cdb)
   │         │            └──────────────── Environment (testpersonal)
   │         └───────────────────────────── Project name (cosmosdbsample)
   └─────────────────────────────────────── Always "samples"
```

#### Example 2: Service Bus Sample

```text
samples-servicebussample-testms-sbn-01
   │         │              │     │   │
   │         │              │     │   └─ Instance number
   │         │              │     └───── Resource type (sbn)
   │         │              └─────────── Environment (testms)
   │         └────────────────────────── Project name (servicebussample)
   └──────────────────────────────────── Always "samples"
```

#### Example 3: Optional Category Usage (Complex Scenarios)

```text
samples-data-cosmosdbsample-testms-cdb-01
   │     │         │            │          │   │
   │     │         │            │          │   └─ Instance number
   │     │         │            │          └───── Resource type (cdb)
   │     │         │            └──────────────── Environment (testms)
   │     │         └───────────────────────────── Project name (cosmosdbsample)
   │     └─────────────────────────────────────── Optional category (data)
   └───────────────────────────────────────────── Always "samples"
```

### Key Components Explained

- **`samples`** - Always constant, identifies these as learning projects
- **`cosmosdbsample/servicebussample`** - Actual project/solution name (matches your code)
- **`testpersonal/testms`** - Which environment you're deploying to
- **`cdb/sbn/stg/vm/rg`** - Azure resource type (2-3 letter abbreviation)
- **`01/02/03`** - Instance number for multiple deployments
- **`data/messaging/storage`** - Optional category prefix for complex scenarios

### When to Use Categories

**Use simplified pattern (recommended):**

- Single-purpose samples
- Clear project names
- Direct code-to-resource mapping

**Use category prefix when:**

- Multiple samples share similar names
- Large-scale multi-domain projects
- Organizational requirements for grouping

<details>
<summary><strong>📋 Full Reference Tables</strong> (Click to expand)</summary>

### Environment Identifiers

| Environment | Identifier | Description |
|-------------|------------|-------------|
| Personal | `testpersonal` | Personal learning environment |
| Microsoft | `testms` | Microsoft/corporate environment |
| Customer A | `testab` | Customer A testing environment |
| Customer B | `testacme` | Customer "Acme" testing environment |
| Generic Customer | `testcustomer` | Generic customer environment |

### Sample Categories

| Category | Description | Sample Numbers |
|----------|-------------|----------------|
| `storage` | Azure Storage services | 03.00 AzureStorage |
| `data` | Database and data services | 03.01 CosmosDB, 03.02 AzureSql, 03.03 DataExplorer |
| `messaging` | Messaging and event services | 03.05 ServiceBus, 03.06 EventHub |
| `compute` | Compute services | VM, Container Apps, Functions |
| `network` | Networking services | VNet, Load Balancer, Application Gateway |
| `security` | Security services | Key Vault, Managed Identity |
| `ai` | AI and Cognitive services | OpenAI, Cognitive Services |

</details>

---

## Azure Resource Types and Naming Rules

> **⚠️ Important:** Each Azure resource type has specific naming restrictions. Always verify your names comply with Azure requirements.

### Core Infrastructure

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Resource Group** | `rg` | Subscription | 1-90 | Alphanumerics, underscores, parentheses, hyphens, periods | `samples-azurestoragesample-testpersonal-rg-01` |
| **Virtual Network** | `vnt` | Resource Group | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-networksample-testpersonal-vnt-01` |
| **Subnet** | `snt` | Virtual Network | 1-80 | Alphanumerics, underscores, periods, hyphens | `samples-networksample-testpersonal-snt-01` |
| **Network Security Group** | `nsg` | Resource Group | 1-80 | Alphanumerics, underscores, periods, hyphens | `samples-networksample-testpersonal-nsg-01` |

### Storage Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Storage Account** | `stg` | Global | 3-24 | Lowercase letters and numbers | `samplesazurestoragesampletestpers01` |
| **File Share** | `shr` | Storage Account | 3-63 | Lowercase letters, numbers, hyphens | `samples-azurestoragesample-testpersonal-shr-01` |

**Note**: Storage account names cannot contain hyphens and must be globally unique. Use concatenated format without hyphens.

---

### Data Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Cosmos DB Account** | `cdb` | Global | 3-44 | Lowercase letters, numbers, hyphens | `samples-cosmosdbsample-testpersonal-cdb-01` |
| **SQL Server** | `sql` | Global | 1-63 | Lowercase letters, numbers, hyphens | `samples-azuresqlsample-testpersonal-sql-01` |
| **SQL Database** | `sdb` | SQL Server | 1-128 | Various characters allowed | `samples-azuresqlsample-testpersonal-sdb-01` |
| **Azure Cache for Redis** | `rds` | Global | 1-63 | Alphanumerics and hyphens | `samples-redissample-testpersonal-rds-01` |
| **MySQL Server** | `mys` | Global | 3-63 | Lowercase letters, numbers, hyphens | `samples-mysqlsample-testpersonal-mys-01` |
| **PostgreSQL Server** | `pgs` | Global | 3-63 | Lowercase letters, numbers, hyphens | `samples-postgresqlsample-testpersonal-pgs-01` |

### Messaging Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Service Bus Namespace** | `sbn` | Global | 6-50 | Alphanumerics and hyphens, start with letter | `samples-servicebussample-testpersonal-sbn-01` |
| **Event Hub Namespace** | `ehn` | Global | 6-50 | Alphanumerics and hyphens, start with letter | `samples-eventhubsample-testpersonal-ehn-01` |
| **Event Hub** | `evh` | Event Hub Namespace | 1-256 | Alphanumerics, periods, hyphens, underscores | `samples-eventhubsample-testpersonal-evh-01` |
| **Event Grid Topic** | `egt` | Resource Group | 3-50 | Alphanumerics and hyphens | `samples-eventgridsample-testpersonal-egt-01` |
| **Event Grid System Topic** | `egt` | Resource Group | 3-50 | Alphanumerics and hyphens | `samples-tablestoragesample-testpersonal-egt-01` |

### Compute Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **Virtual Machine** | `vm` | Resource Group | 1-15 (Win), 1-64 (Linux) | Limited special chars | `samples-vmsample-testpersonal-vm-01` |
| **App Service Plan** | `asp` | Resource Group | 1-60 | Alphanumerics and hyphens | `samples-webappsample-testpersonal-asp-01` |
| **Web App** | `app`, `api`, `aps`, or `feapp` | Global | 2-60 | Alphanumerics and hyphens | `samples-webappsample-testpersonal-app-01`, `samples-apisample-testpersonal-api-01`, `samples-webappsample-testpersonal-aps-01`, or `samples-frontendappsample-testpersonal-feapp-01` |
| **Function App** | `fap` | Global | 2-60 | Alphanumerics and hyphens | `samples-functionssample-testpersonal-fap-01` |
| **Container App** | `cap` | Resource Group | 2-32 | Lowercase letters, numbers, hyphens | `samples-containerappsample-testpersonal-cap-01` |
| **Container Apps Environment** | `cae` | Resource Group | 2-32 | Lowercase letters, numbers, hyphens | `samples-containerappsample-testpersonal-cae-01` |
| **Container Registry** | `crg` | Global | 5-50 | Alphanumerics only | `samplescontainerregistrytestpers01` |

**Note**: Use `app` for general web applications, `api` for API-only services, `aps` for app services, or `feapp` for frontend applications to better reflect the purpose.

### AI and Cognitive Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **OpenAI Service** | `oai` | Global | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-openaisample-testpersonal-oai-01` |
| **Cognitive Services** | `cgs` | Global | 2-64 | Alphanumerics, underscores, periods, hyphens | `samples-cognitivesample-testpersonal-cgs-01` |
| **AI Search** | `ais` | Global | 2-60 | Lowercase letters, numbers, hyphens | `samples-aisearchsample-testpersonal-ais-01` |

### Security Services

| Resource Type | Abbreviation | Scope | Length | Valid Characters | Example |
|---------------|--------------|-------|--------|------------------|---------|
| **App Registration** | `appr` | Global | 1-120 | Various characters allowed | `samples-appsample-testpersonal-appr-01` |
| **Key Vault** | `kvt` | Global | 3-24 | Alphanumerics and hyphens | `samples-keyvaultsample-testpersonal-kvt-01` |
| **Managed Identity** | `appi` or `mi` | Resource Group | 3-128 | Alphanumerics, underscores, hyphens | `samples-identitysample-testpersonal-appi-01` or `samples-identitysample-testpersonal-mi-01` |

---

## Sample-Specific Examples

> **💡 Real-world examples** showing how the simplified naming convention applies to your specific samples.

### 03.00 Azure Storage Sample (azurestoragesample)

```text
# Resource Group
samples-azurestoragesample-testpersonal-rg-01

# Storage Account (no hyphens, globally unique)
samplesazurestoragesampletestpers01

# Related Resources
samples-azurestoragesample-testpersonal-vnt-01
samples-azurestoragesample-testpersonal-nsg-01
```

### 03.01 CosmosDB Sample (cosmosdbsample)

```text
# Resource Group
samples-cosmosdbsample-testpersonal-rg-01

# Cosmos DB Account
samples-cosmosdbsample-testpersonal-cdb-01

# Related Resources
samples-cosmosdbsample-testpersonal-vnt-01
samples-cosmosdbsample-testpersonal-kvt-01
```

### 03.02 Azure SQL Sample (azuresqlsample)

```text
# Resource Group
samples-azuresqlsample-testms-rg-01

# SQL Server
samples-azuresqlsample-testms-sql-01

# SQL Database
samples-azuresqlsample-testms-sdb-01
```

### 03.05 Service Bus Sample (servicebussample)

```text
# Resource Group
samples-servicebussample-testab-rg-01

# Service Bus Namespace
samples-servicebussample-testab-sbn-01
```

### 03.06 Event Hub Sample (eventhubsample)

```text
# Resource Group
samples-eventhubsample-testcustomer-rg-01

# Event Hub Namespace
samples-eventhubsample-testcustomer-ehn-01

# Event Hub
samples-eventhubsample-testcustomer-evh-01
```

---

## Cross-Environment Examples

> **🔄 Multi-environment deployment** showing consistency across different environments and subscriptions.

### Same Sample Across Different Environments

```text
# Personal Environment
samples-azurestoragesample-testpersonal-rg-01
samplesazurestoragesampletestpers01

# Microsoft Environment  
samples-azurestoragesample-testms-rg-01
samplesazurestoragesampletestms01

# Customer Environment
samples-azurestoragesample-testab-rg-01
samplesazurestoragesampletestab01
```

### Benefits of Simplified Naming

**Code-to-Resource Traceability:**

- Project name `azurestoragesample` maps directly to resources
- Easy to identify which resources belong to which sample
- Simplified CI/CD pipeline configuration

**Reduced Complexity:**

- Fewer naming components to manage
- More intuitive for developers
- Less prone to naming conflicts

---

## Special Naming Considerations

> **⚠️ Critical constraints** that affect resource naming in Azure.

### Global Uniqueness Requirements

Resources with global scope need unique names across all Azure:

- Storage accounts
- Web apps, Function apps
- Key Vaults
- Cosmos DB accounts
- SQL servers
- Service Bus namespaces
- Event Hub namespaces

**Strategy**: Use abbreviated environment identifiers to maintain uniqueness while keeping names readable.

### Character Restrictions

- **Storage Accounts**: No hyphens, lowercase only, 3-24 characters
- **Container Registry**: Alphanumerics only, 5-50 characters
- **Virtual Machines**: Limited special characters, length varies by OS
- **Container Apps**: Lowercase only, 2-32 characters

### Length Limitations

Always verify resource name length against Azure limits. When names exceed limits:

1. Abbreviate category names
2. Shorten specific sample names
3. Use shorter environment identifiers
4. Reduce instance numbers to single digits

---

## Resource Tagging Strategy

> **🏷️ Complement naming** with standardized resource tags for better organization and cost tracking.

Complement naming convention with standardized tags:

```json
{
  "Environment": "testpersonal",
  "Project": "azure-samples",
  "Owner": "your-name",
  "Category": "storage",
  "Sample": "azurestorage", 
  "CostCenter": "learning",
  "CreatedDate": "2025-07-02",
  "Purpose": "learning-sample"
}
```

---

## Implementation Guidelines

> **🚀 Practical steps** for implementing and maintaining the naming convention.

### 1. Validation Checklist

- [ ] Resource name meets Azure length requirements
- [ ] Characters are valid for the resource type
- [ ] Global resources have unique names
- [ ] Naming pattern is consistent across resources
- [ ] Tags are applied consistently

### 2. Automation Considerations

- Use naming templates in ARM/Bicep templates
- Implement validation in deployment scripts
- Create PowerShell/CLI functions for name generation
- Document exceptions and special cases

### 3. Documentation Requirements

- Document any deviations from the standard
- Maintain environment identifier mappings
- Keep category definitions updated
- Version control naming convention changes

## Maintenance and Updates

### Review Schedule

- **Quarterly**: Review naming convention effectiveness
- **As needed**: Update when new Azure services are added
- **Before major deployments**: Validate naming compliance

### Change Management

1. Document proposed changes
2. Assess impact on existing resources
3. Update templates and automation
4. Communicate changes to team
5. Update this document

---

## Summary

This naming convention prioritizes simplicity and code-to-resource alignment:

### Primary Pattern (Recommended)

`samples-{projectname}-{environment}-{type}-{##}`

**Example:** `samples-cosmosdbsample-testpersonal-cdb-01`

### Benefits

- **Direct Code Mapping**: Resource names match project/solution names
- **Simplified Management**: Fewer naming components to maintain
- **Better Traceability**: Easy to identify resources by project name
- **Flexible Environments**: Environment identifiers work across subscriptions

### Optional Category Pattern

Use `samples-{category}-{projectname}-{environment}-{type}-{##}` only when:

- Managing multiple similar project names
- Organizational requirements demand grouping
- Large-scale deployments need additional categorization

---

## Quick Reference

> **📚 Quick lookup** for common abbreviations and identifiers.

### Common Abbreviations

| Service | Abbreviation | Service | Abbreviation |
|---------|--------------|---------|--------------|
| Resource Group | `rg` | Storage Account | `stg` |
| Virtual Network | `vnt` | Cosmos DB | `cdb` |
| Network Security Group | `nsg` | SQL Database | `sdb` |
| App Registration | `appr` | Service Bus | `sbn` |
| Key Vault | `kvt` | Event Hub Namespace | `ehn` |
| Virtual Machine | `vm` | Event Grid Topic | `egt` |
| Web App | `app`, `api`, `aps`, `feapp` | Container App | `cap` |
| Function App | `fap` | App Service Plan | `asp` |
| Managed Identity | `appi` or `mi` | | |

### Environment Reference

- `testpersonal` - Personal environment
- `testms` - Microsoft/corporate environment  
- `testab` - Customer A environment
- `test{customername}` - Named customer environment

---

**Document Owner**: IT Architecture Team  
**Next Review**: October 2, 2025  
**Version History**: 1.0 - Initial creation (July 2, 2025)
