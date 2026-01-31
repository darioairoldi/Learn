the following article analyzes interesting points about Azure App Configuration

## 📑 Table of Contents

- [💰 Q. What pricing tiers are available for Azure App Configuration?](#q-what-pricing-tiers-are-available-for-azure-app-configuration)
- [🔗 Q. Can Azure key vault be integrated on a value by value basis only?](#q-can-azure-key-vault-be-integrated-on-a-value-by-value-basis-only)

---

## 💰 Q. What pricing tiers are available for Azure App Configuration?
![alt text](<images/01.001 pricing tiers.png>)

Azure App Configuration offers four pricing tiers, each designed for different use cases:

**Free**: The Free tier provides a cost-free evaluation environment for exploring Azure App Configuration features in non-production settings. It offers basic configuration management, feature flags, and Key Vault references with **<mark>limited storage (10 MB)** and request quotas (**<mark>1,000 requests/day**).

> **Pros**:
> - No cost - perfect for learning and evaluation
> - Includes core functionality (config settings, feature > flags, Key Vault references)
> - Good for tutorials and proof-of-concept projects
> 
> **Cons**:
> - Limited to 1 store per region per subscription
> - Only 10 MB storage (regular + snapshot combined)
> - Low request quota (1,000 requests/day)
> - No SLA
> - No Private Link support
> - Revision history only 7 days
> - No guaranteed throughput

**Developer**: The Developer tier is a cost-efficient option tailored for development and testing environments. It provides **<mark>more storage (500 MB)** and **<mark>request capacity (6,000 requests/hour)** than Free tier, with Private Link support for secure development scenarios.

> **Pros**:
> - Cost-effective for development/testing
> - Private Link support for secure connectivity
> - Higher storage capacity (**<mark>500 MB regular** + **<mark>500 MB snapshot**)
> - Better request quota (**<mark>6,000 requests/hour**)
> - <mark>Unlimited stores</mark> per subscription
> 
> **Cons**:
> - Not designed for production use
> - <mark>No SLA</mark>
> - Revision history only <mark>7 days</mark>
> - <mark>No guaranteed throughput</mark>
> - <mark>No</mark> encryption with <mark>customer-managed keys</mark>
> - <mark>No</mark> <mark>soft delete</mark> or <mark>geo-replication</mark>

**Standard**: The Standard tier is designed for medium-volume production and non-production workloads, offering a balance of performance and cost-efficiency. It includes enterprise features like customer-managed encryption, soft delete, and geo-replication with a 99.9% SLA (99.95% with geo-replication).

> **Pros**:
> - Production-ready with <mark>99.9% SLA</mark>
> - <mark>1 GB storage</mark> (<mark>regular</mark> + <mark>snapshot</mark> each)
> - <mark>30-day</mark> revision history
> - Guaranteed throughput (<mark>300 RPS read</mark>, <mark>60 RPS write</mark>)
> - Private Link, customer-managed keys, soft delete
> - <mark>Geo-replication</mark> support for high availability
> - <mark>10 private endpoints</mark>
> - Reasonable request quota (<mark>30,000 requests/hour</mark>, <mark>200,000/day</mark> included)
> 
> **Cons**:
> - <mark>Limited compared to Premium</mark> for high-volume scenarios
> - <mark>Lower throughput than Premium tier</mark>
> - Request quota may be insufficient for very high-traffic > applications
> - <mark>Fewer private endpoints</mark> than Premium

**Premium**: The Premium tier provides the highest performance and scalability for high-volume, enterprise-level production applications. It features unlimited request quotas, maximum throughput (450 RPS read, 100 RPS write), and enhanced SLA (99.9% base, 99.99% with geo-replication).

> **Pros**:
> - <mark>No request quota limits</mark> - never blocked
> - Highest storage capacity (<mark>4 GB regular</mark> + </mark>4 GB snapshot</mark>)
> - Best throughput (<mark>450 RPS read</mark>, <mark>100 RPS write</mark>)
> - <mark>30-day revision history</mark>
> - Enhanced SLA (<mark>99.99% with geo-replication)
> - Maximum private endpoints (<mark>40</mark>)
> - All enterprise features included
> - Ideal for mission-critical applications
> 
> **Cons**:
> - <mark>Higher cost</mark> than other tiers
> - May be over-provisioned for smaller workloads
> - <mark>Cannot downgrade to Free or Developer tier directly</mark>

## 🔗 Q. Can Azure key vault be integrated on a value by value basis only?

**Yes, Azure Key Vault integration with Azure App Configuration works on a value-by-value basis ONLY.** You cannot do a bulk integration where all Key Vault secrets automatically appear in App Configuration.

### How It Works 🔍

You must explicitly create a **Key Vault reference** in App Configuration for each individual secret:

1. Store the actual secret value in Azure Key Vault
2. Create a reference in App Configuration that points to that specific Key Vault secret
3. The application reads from App Configuration, which resolves the Key Vault reference at runtime

> 💡 **See [03. Azure App Configuration Exercise](./03-azure-app-configuration-exercise.md#step-3-integrate-with-key-vault-) for detailed implementation steps**

### Why Use Key Vault References Instead of Direct Key Vault Access? 🤔

**Valid Alternative**: You CAN directly access all Key Vault secrets in your application:

```csharp
var builder = new ConfigurationBuilder();
builder.AddAzureAppConfiguration(options => { /* ... */ });
builder.AddAzureKeyVault(new Uri("https://myvault.vault.azure.net/"), new DefaultAzureCredential());
```

This loads **ALL** secrets from Key Vault into your application's configuration.

**Key Vault References Provide Better Control**:

1. **Centralized Configuration Management** 📋
   - All configuration (settings + secret references) managed in one place (App Configuration)
   - Easier to update which secrets are used without changing Key Vault access
   - Better visibility: see which secrets are used in which configurations

2. **Principle of Least Privilege** 🔒
   - Reference only the specific secrets each application needs
   - Avoid loading ALL Key Vault secrets into every application
   - Reduces attack surface if application is compromised

3. **Environment-Specific Secret Management** 🌍
   ```
   App Configuration can reference:
   - Dev:Database:Password → KeyVault/dev-db-password
   - Prod:Database:Password → KeyVault/prod-db-password
   
   vs. AddAzureKeyVault() loads ALL secrets from ONE vault
   ```

4. **Dynamic Configuration Updates** 🔄
   - Change which secret is referenced without code deployment
   - Point to different Key Vault secrets or versions
   - Use App Configuration's refresh capabilities

5. **Multi-Tenant Scenarios** 👥
   - Different configurations can reference different Key Vaults
   - Mix secrets from multiple Key Vaults in one configuration
   - Better for complex architectures

**When to Use Each Approach**:

| Use Key Vault References | Use AddAzureKeyVault() |
|--------------------------|------------------------|
| Need centralized config management | Simple scenarios with one Key Vault |
| Want fine-grained secret selection | Application needs most/all secrets from vault |
| Multi-environment configurations | Direct Key Vault access is sufficient |
| Need to mix configs and secrets | Simpler code, less infrastructure |
| Dynamic secret reference updates | No App Configuration requirement |

**Best Practice**: Use Key Vault references when you need centralized configuration management and selective secret access. Use direct Key Vault access for simpler scenarios where the application legitimately needs access to most secrets in the vault.

