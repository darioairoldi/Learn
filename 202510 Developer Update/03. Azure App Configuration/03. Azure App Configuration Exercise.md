# Azure App Configuration with Key Vault Integration 🚀

A comprehensive guide to setting up Azure App Configuration with Azure Key Vault for secure configuration management.

## Table of Contents 📑

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Step 1: Create Azure Resources](#step-1-create-azure-resources-)
   - [Create Resource Group](#create-resource-group)
   - [Create Azure Key Vault](#create-azure-key-vault)
   - [Create App Configuration Instance](#create-app-configuration-instance)
4. [Step 2: Add Configuration Values](#step-2-add-configuration-values-)
5. [Step 3: Integrate with Key Vault](#step-3-integrate-with-key-vault-)
6. [Step 4: Access Configuration in C#](#step-4-access-configuration-in-c-)
7. [References](#references-)

---

## Overview

This tutorial demonstrates how to:
- Set up Azure App Configuration for centralized configuration management
- Store sensitive data securely in Azure Key Vault
- Use Key Vault references in App Configuration (best practice for secrets)
- Access configuration values from a C# application using managed identity

## Prerequisites

- Azure CLI installed and configured
- An active Azure subscription
- PowerShell (commands use PowerShell syntax)
- .NET SDK for the C# code sample
- Appropriate permissions to create Azure resources

---

## Step 1: Create Azure Resources 🏗️

### Create Resource Group

Resource groups are logical containers for Azure resources. Use the `az group` commands to manage them:

![alt text](<images/01.001 az group commands.png>)

```powershell
az group create --name samples-testmc-rg-itn-01  --location italynorth
az group list -o table
az group delete --name samples-rg-testnc-01 --yes --no-wait
```

### Create Azure Key Vault

Azure Key Vault is used to securely store secrets like connection strings. Create a Key Vault and grant yourself permissions to manage secrets:

```powershell
$keyVaultName='samples-testmc-kv-itn-01'

az keyvault create --name $keyVaultName --resource-group $resourceGroup --location $location

# Grant yourself access to set secrets
az keyvault set-policy --name $keyVaultName --upn $userPrincipal --secret-permissions get list set delete
```
![alt text](<images/02.001 azure key vault.png>)

### Create App Configuration Instance

Azure App Configuration provides centralized configuration management. The following commands register the provider and create an instance in the Free tier:

![alt text](<images/02.000 az appconfig create.png>)

Use **`az appconfig create`** to create an Azure App Configuration instance in the Free tier:

```powershell
$resourceGroup='samples-testmc-rg-itn-01'
$location='italynorth'
$appConfigName='samples-testmc-apc-itn-01'

az provider register --namespace Microsoft.AppConfiguration
az provider show --namespace Microsoft.AppConfiguration --query "registrationState"
az appconfig create --location $location --name $appConfigName --resource-group $resourceGroup --sku Free
```

![alt text](<images/03.001 az appconfig create.png>)

**List App Configuration instances:**

Use **`az appconfig list`** to list all Azure App Configuration instances in your resource group:

```powershell
az appconfig list --resource-group $resourceGroup -o table
```

**Assign permissions:**

Use **`az role assignment create`** to assign the "App Configuration Data Reader" role to yourself, allowing you to read and manage its settings:
```powershell
$userPrincipal=$(az rest --method GET --url https://graph.microsoft.com/v1.0/me --headers 'Content-Type=application/json' --query userPrincipalName --output tsv)

$resourceID=$(az appconfig show --resource-group $resourceGroup --name $appConfigName --query id --output tsv)

az role assignment create --assignee $userPrincipal --role "App Configuration Data Reader" --scope $resourceID
```

---

## Step 2: Add Configuration Values ⚙️

Use **`az appconfig kv set`** to add a new configuration setting with key "Dev:conStr" and a sample connection string value to the App Configuration instance:
```powershell
az appconfig kv set --name $appConfigName --key Dev:conStr --value 'sampleconnectionString' --yes
```

![alt text](<images/03.002 az appconfig kv set.png>)

![alt text](<images/03.003 connectionstring view.png>)


## Step 3: add the connection string to Azure Key Vault and reference it from App Configuration

```powershell
$connectionString='Server=tcp:myserver.database.windows.net,1433;Database=mydb;User ID=myuser;Password=mypassword;'

az keyvault secret set --vault-name $keyVaultName --name 'DevConStr' --value $connectionString
```


![alt text](<images/04.001 akv secret.png>)


### Reference Key Vault Secret from App Configuration

**Get the secret URI:**

```powershell
$secretUri=$(az keyvault secret show --vault-name $keyVaultName --name 'DevConStr' --query id --output tsv)
```

**Set the App Configuration secret reference to Key Vault:**

```powershell
az appconfig kv set-keyvault --name $appConfigName --key 'Dev:conStr' --secret-identifier $secretUri --yes
```

![alt text](<images/04.002 akv secret from app configuration.png>)

### Configure Managed Identity

**Enable managed identity for App Configuration:**

```powershell
az appconfig identity assign --name $appConfigName --resource-group $resourceGroup
```

![alt text](<images/04.003 managed identity for appconfig.png>)

**Get the managed identity principal ID:**

```powershell
$principalId=$(az appconfig identity show --name $appConfigName --resource-group $resourceGroup --query principalId --output tsv)
```

**Grant the managed identity access to Key Vault secrets:**

```powershell
az keyvault set-policy --name $keyVaultName --object-id $principalId --secret-permissions get
```

---

## Step 4: Access Configuration in C# 💻

Use **`builder.AddAzureAppConfiguration`** to read the configuration value from Azure App Configuration in a C# application:

```c#
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureAppConfiguration;
using Azure.Identity;

// Set the Azure App Configuration endpoint, replace YOUR_APP_CONFIGURATION_NAME
// with the name of your actual App Configuration service
string endpoint = "https://YOUR_APP_CONFIGURATION_NAME.azconfig.io"; 

// Configure which authentication methods to use
// DefaultAzureCredential tries multiple auth methods automatically
DefaultAzureCredentialOptions credentialOptions = new()
{
    ExcludeEnvironmentCredential = true,
    ExcludeManagedIdentityCredential = true
};

// Create a configuration builder to combine multiple config sources
var builder = new ConfigurationBuilder();

// Add Azure App Configuration as a source
// This connects to Azure and loads configuration values
builder.AddAzureAppConfiguration(options =>
{
    options.Connect(new Uri(endpoint), new DefaultAzureCredential(credentialOptions));
});

// Build the final configuration object
try
{
    var config = builder.Build();
    
    // Retrieve a configuration value by key name
    Console.WriteLine(config["Dev:conStr"]);
}
catch (Exception ex)
{
    Console.WriteLine($"Error connecting to Azure App Configuration: {ex.Message}");
}
```

---

## References 📚

### Official Microsoft Documentation

1. **Azure App Configuration**
   - [Azure App Configuration Documentation](https://learn.microsoft.com/en-us/azure/azure-app-configuration/)
   - [Quickstart: Create an Azure App Configuration store](https://learn.microsoft.com/en-us/azure/azure-app-configuration/quickstart-azure-app-configuration-create)
   - [Use Key Vault references in App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/use-key-vault-references-dotnet-core)

2. **Azure Key Vault**
   - [Azure Key Vault Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
   - [About Azure Key Vault secrets](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets)
   - [Key Vault security overview](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features)

3. **Managed Identity**
   - [What are managed identities for Azure resources?](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)
   - [Configure managed identities for Azure resources](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)

4. **.NET Integration**
   - [Microsoft.Extensions.Configuration.AzureAppConfiguration](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.configuration.azureappconfiguration)
   - [Use Azure App Configuration in a .NET app](https://learn.microsoft.com/en-us/azure/azure-app-configuration/quickstart-dotnet-core-app)
   - [Azure Identity client library for .NET](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme)

5. **Azure CLI Reference**
   - [az appconfig commands](https://learn.microsoft.com/en-us/cli/azure/appconfig)
   - [az keyvault commands](https://learn.microsoft.com/en-us/cli/azure/keyvault)
   - [az role assignment commands](https://learn.microsoft.com/en-us/cli/azure/role/assignment)

### Best Practices and Patterns

- [Best practices for Azure App Configuration](https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-best-practices)
- [Azure Key Vault best practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices)
- [Secure application configuration management](https://learn.microsoft.com/en-us/azure/architecture/framework/security/design-storage-keys)

### NuGet Packages

- [Microsoft.Extensions.Configuration.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureAppConfiguration)
- [Azure.Identity](https://www.nuget.org/packages/Azure.Identity)
- [Microsoft.Extensions.Configuration](https://www.nuget.org/packages/Microsoft.Extensions.Configuration)






