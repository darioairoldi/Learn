# Azure Web App CLI Commands Guide

## Table of Contents

- 🌐 [Introduction](#introduction)
- 📋 [Prerequisites](#prerequisites)
- 🚀 [Web App Management](#web-app-management)
  - [Creating Web Apps](#creating-web-apps)
  - [Listing and Viewing Web Apps](#listing-and-viewing-web-apps)
- ⚙️ [Configuration and Settings](#configuration-and-settings)
  - [App Settings Management](#app-settings-management)
  - [Connection Strings](#connection-strings)
- 📦 [Deployment Operations](#deployment-operations)
  - [Source Control Deployment](#source-control-deployment)
  - [ZIP and Local Git Deployment](#zip-and-local-git-deployment)
- 🔧 [Advanced Management](#advanced-management)
  - [Scaling and Performance](#scaling-and-performance)
  - [Monitoring and Diagnostics](#monitoring-and-diagnostics)
- 🔒 [Security and Access](#security-and-access)
  - [Authentication and Authorization](#authentication-and-authorization)
  - [SSL/TLS Configuration](#ssltls-configuration)
- 📚 [References](#references)

## 🌐 Introduction

Azure Web Apps provide a powerful platform-as-a-service (PaaS) solution for hosting web applications. The Azure CLI offers comprehensive commands to manage every aspect of your web apps, from creation and configuration to deployment and monitoring. This guide covers the essential `az webapp` commands and their practical applications.

## 📋 Prerequisites

Before using Azure Web App CLI commands, ensure you have:

- Azure CLI installed and configured
- An active Azure subscription
- Appropriate permissions to create and manage Azure resources

```bash
# Login to Azure
az login

# Set your default subscription
az account set --subscription "Your-Subscription-Name"
```

## 🚀 Web App Management

### Creating Web Apps

#### Create a new web app
```bash
# Create a resource group
az group create --name diginsighttools-testmc-rg-itn-01 --location "Italy North"

# Create an App Service plan
az appservice plan create --name diginsighttools-testmc-asp-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --sku FREE

# Create a web app
az webapp create --resource-group diginsighttools-testmc-rg-itn-01 --plan diginsighttools-testmc-asp-itn-01 --name diginsighttools-testmc-job-itn-01 --runtime "NODE:18-lts"
```

#### Create web app with specific configurations
```bash
# Create web app with custom settings
az webapp create \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --plan diginsighttools-testmc-asp-itn-01 \
  --name diginsighttools-testmc-job-itn-01 \
  --runtime "PYTHON:3.9" \
  --startup-file "app.py"
```

### Listing and Viewing Web Apps

#### List all web apps in subscription
```bash
az webapp list --output table
```

#### List web apps in specific resource group
```bash
az webapp list --resource-group diginsighttools-testmc-rg-itn-01 --output table
```

#### Show detailed information about a web app
```bash
az webapp show --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

#### Get web app URL
```bash
az webapp show --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --query defaultHostName --output tsv
```

## ⚙️ Configuration and Settings

### App Settings Management

#### List all app settings
```bash
az webapp config appsettings list --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

#### Set app settings
```bash
# Set single app setting
az webapp config appsettings set --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --settings "ENVIRONMENT=production"

# Set multiple app settings
az webapp config appsettings set \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --settings "DATABASE_URL=your-db-url" "API_KEY=your-api-key"
```

#### Delete app settings
```bash
az webapp config appsettings delete --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --setting-names "OLD_SETTING"
```

### Connection Strings

#### Set connection strings
```bash
az webapp config connection-string set \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --connection-string-type SQLServer \
  --settings "DefaultConnection=Server=myserver;Database=mydb;..."
```

#### List connection strings
```bash
az webapp config connection-string list --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

## 📦 Deployment Operations

### Source Control Deployment

#### Configure continuous deployment from GitHub
```bash
az webapp deployment source config \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --repo-url https://github.com/username/repository \
  --branch main \
  --manual-integration
```

#### Configure deployment from local Git
```bash
az webapp deployment source config-local-git \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01
```

### ZIP and Local Git Deployment

#### Deploy from ZIP file
```bash
az webapp deployment source config-zip \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --src path/to/your/app.zip
```

#### Get deployment credentials
```bash
az webapp deployment list-publishing-credentials \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01
```

#### Show deployment history
```bash
az webapp deployment list-publishing-profiles \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01
```

## 🔧 Advanced Management

### Scaling and Performance

#### Scale web app instances
```bash
# Scale to specific number of instances
az webapp scale --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --instance-count 3

# Enable auto-scaling
az monitor autoscale create \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --resource diginsighttools-testmc-job-itn-01 \
  --resource-type Microsoft.Web/sites \
  --name diginsighttools-testmc-autoscale \
  --min-count 1 \
  --max-count 10 \
  --count 2
```

#### Restart web app
```bash
az webapp restart --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

#### Stop and start web app
```bash
# Stop web app
az webapp stop --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01

# Start web app
az webapp start --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

### Monitoring and Diagnostics

#### Enable application logging
```bash
az webapp log config \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --application-logging filesystem \
  --level information
```

#### Stream logs
```bash
az webapp log tail --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

#### Download log files
```bash
az webapp log download --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --log-file logs.zip
```

## 🔒 Security and Access

### Authentication and Authorization

#### Configure Azure AD authentication
```bash
az webapp auth update \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --enabled true \
  --action LoginWithAzureActiveDirectory \
  --aad-client-id your-client-id \
  --aad-client-secret your-client-secret \
  --aad-tenant-id your-tenant-id
```

#### List authentication settings
```bash
az webapp auth show --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01
```

### SSL/TLS Configuration

#### Bind SSL certificate
```bash
az webapp config ssl bind \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --certificate-thumbprint your-cert-thumbprint \
  --ssl-type SNI
```

#### Upload SSL certificate
```bash
az webapp config ssl upload \
  --name diginsighttools-testmc-job-itn-01 \
  --resource-group diginsighttools-testmc-rg-itn-01 \
  --certificate-file path/to/certificate.pfx \
  --certificate-password your-password
```

#### Enable HTTPS only
```bash
az webapp update --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --https-only true
```

## 📚 References

### Official Documentation
- **[Azure CLI Web App Commands Reference](https://docs.microsoft.com/en-us/cli/azure/webapp)** - Complete reference documentation for all `az webapp` commands, including syntax, parameters, and examples. Essential for understanding all available options and command variations.

- **[Azure App Service CLI Samples](https://docs.microsoft.com/en-us/azure/app-service/samples-cli)** - Collection of practical CLI scripts and examples for common App Service scenarios. Valuable for learning real-world implementation patterns and best practices.

### Best Practices and Guides
- **[Azure App Service Deployment Best Practices](https://docs.microsoft.com/en-us/azure/app-service/deploy-best-practices)** - Comprehensive guide covering deployment strategies, slot management, and CI/CD integration. Important for understanding production deployment workflows and avoiding common pitfalls.

- **[Azure CLI Tips and Tricks](https://docs.microsoft.com/en-us/cli/azure/use-cli-effectively)** - Advanced techniques for using Azure CLI efficiently, including output formatting, querying, and automation. Helpful for improving productivity and creating robust automation scripts.

### Security and Configuration
- **[App Service Authentication and Authorization](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)** - Detailed explanation of built-in authentication features and configuration options. Critical for implementing secure access controls and identity integration.

- **[Configure SSL/TLS Certificates in Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-certificate)** - Step-by-step guide for SSL certificate management and HTTPS configuration. Essential for securing web applications and meeting compliance requirements.

### Monitoring and Troubleshooting
- **[Monitor Azure App Service Performance](https://docs.microsoft.com/en-us/azure/app-service/web-sites-monitor)** - Guide to monitoring tools, metrics, and diagnostic features available in App Service. Valuable for maintaining application health and performance optimization.

- **[Azure App Service Diagnostics](https://docs.microsoft.com/en-us/azure/app-service/overview-diagnostics)** - Overview of built-in diagnostic tools and troubleshooting capabilities. Important for quickly identifying and resolving application issues in production environments.