# HowTo: Use Azure CLI to Create Azure Container Apps

![alt text](<images/00.000 azure container app.png>)

## 📑 Table of Contents

- [🎯 Overview](#-overview)
- [📋 Prerequisites](#-prerequisites)
- [🚀 Step-by-Step Guide](#-step-by-step-guide)
  - [Step 1: Authenticate with Azure](#step-1-authenticate-with-azure)
  - [Step 2: Create a Resource Group](#step-2-create-a-resource-group)
  - [Step 3: Install Container App Extension](#step-3-install-container-app-extension)
  - [Step 4: Create Container App Environment](#step-4-create-container-app-environment)
  - [Step 5: Deploy the Container App](#step-5-deploy-the-container-app)
- [🔗 References](#-references)

## 🎯 Overview

This guide demonstrates how to use the Azure Command-Line Interface (Azure CLI) to create and deploy an Azure Container App. Azure Container Apps is a fully managed serverless container service that enables you to run microservices and containerized applications on a serverless platform. 

By following this tutorial, you will learn how to:
- Authenticate with Azure using the CLI
- Set up the necessary Azure resources
- Create a Container App environment
- Deploy a containerized application

This approach is ideal for developers who prefer command-line tools and automation over using the Azure Portal.

## 📋 Prerequisites

Before starting, ensure you have:
- Azure CLI installed on your machine
- An active Azure subscription
- Your Azure tenant ID
- Basic understanding of container concepts

## 🚀 Step-by-Step Guide

### Step 1: Authenticate with Azure

First, log in to your Azure account using device code authentication. This method is particularly useful when working in environments where interactive browser login isn't available.

```bash
az login -t <your-tenant-id> --use-device-code
```

![Azure Login](<images/01.001 az login.png>)

### Step 2: Create a Resource Group

Create a resource group to organize and manage your Azure Container App resources. This example uses the Italy North region.

```bash
az group create --location italynorth --name diginsighttools-testmc-rg-01
```

![Create Resource Group](<images/01.002 az group create.png>)

### Step 3: Install Container App Extension

Add the Container App extension to Azure CLI. The `--upgrade` flag ensures you have the latest version.

```bash
az extension add --name containerapp --upgrade
```

![Add Container App Extension](<images/01.003a az extension add and providers register.png>)

### Step 4: Create Container App Environment

Create a Container App environment, which provides a secure boundary around a group of container apps. These apps share the same virtual network and write logs to the same Log Analytics workspace.

```bash
az containerapp env create --name diginsighttools-testmc-cae-01 --resource-group diginsighttools-testmc-rg-01 --location italynorth
```

![Create Container App Environment](<images/01.004 az containerapp env create.png>)

### Step 5: Deploy the Container App

Finally, create and deploy your container app using a sample "Hello World" image from Microsoft. This command configures external ingress on port 80 and returns the fully qualified domain name (FQDN).

```bash
az containerapp create --name diginsighttools-testmc-ca-01 --resource-group diginsighttools-testmc-rg-01 --environment diginsighttools-testmc-cae-01 --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest --target-port 80 --ingress 'external' --query properties.configuration.ingress.fqdn
```

![Create Container App](<images/01.005 az containerapp create.png>)

After successful deployment, you can access your application using the FQDN returned by the command.

## 🔗 References

### Official Azure Documentation

- **[Azure Container Apps Overview](https://learn.microsoft.com/azure/container-apps/overview)**  
  Comprehensive introduction to Azure Container Apps, explaining the service architecture, key features, and use cases. Essential reading for understanding when and why to use Container Apps.

- **[Azure CLI Reference for Container Apps](https://learn.microsoft.com/cli/azure/containerapp)**  
  Complete command-line reference documentation for all `az containerapp` commands. Useful for exploring additional configuration options and advanced scenarios.

- **[Quickstart: Deploy your first container app](https://learn.microsoft.com/azure/container-apps/quickstart-portal)**  
  Official quickstart guide from Microsoft that provides context and alternative deployment methods, including Portal and ARM templates.

### Additional Resources

- **[Azure Container Apps Environments](https://learn.microsoft.com/azure/container-apps/environment)**  
  Detailed explanation of Container App environments, networking, and security boundaries. Important for understanding the environment concept used in Step 4.

- **[Ingress in Azure Container Apps](https://learn.microsoft.com/azure/container-apps/ingress-overview)**  
  In-depth guide on configuring ingress settings, including HTTP/HTTPS traffic, authentication, and custom domains. Relevant for production deployments beyond this basic tutorial.

- **[Azure CLI Installation Guide](https://learn.microsoft.com/cli/azure/install-azure-cli)**  
  Step-by-step instructions for installing Azure CLI on Windows, macOS, and Linux. Essential prerequisite for following this tutorial.