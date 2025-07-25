---
title: "Azure Table Storage Access with C#"
description: "Guide covering available approaches and libraries for accessing Azure Table Storage using C#"
author: "Dario Airoldi"
date-modified: last-modified
categories: [azure, table-storage, csharp, sdk]
format:
  html:
    toc: true
    toc-depth: 3
---

## Overview
**Azure Table Storage** is a NoSQL key/attribute store service that provides **fast and cost-effective storage** for structured, non-relational data.<br> This guide covers the available approaches and libraries for accessing Azure Table Storage using C#.

## Table of Contents

1. [Overview](#overview)
2. [Available Approaches](#available-approaches)
   - [Azure.Data.Tables SDK (Recommended)](#1-azuredatatables-sdk-recommended)
   - [Azure Cosmos DB Table API](#2-azure-cosmos-db-table-api)
3. [Key Libraries](#key-libraries)
   - [Primary Library](#primary-library)
   - [Supporting Libraries (Optional)](#supporting-libraries-optional)
4. [Basic Operations](#basic-operations)
   - [Setting Up a Table Client](#setting-up-a-table-client)
   - [Define Your Entity](#define-your-entity)
5. [CRUD Operations](#crud-operations)
   - [Query (Read)](#query-read)
   - [Create (Insert)](#create-insert)
   - [Update](#update)
   - [Delete](#delete)
6. [Advanced Patterns](#advanced-patterns)
   - [Batch Operations](#batch-operations)
   - [Retry Logic with Exponential Backoff](#retry-logic-with-exponential-backoff)
   - [Dependency Injection Setup](#dependency-injection-setup)
7. [Authentication Approaches](#authentication-approaches)
   - [Managed Identity (Recommended)](#1-managed-identity-recommended-for-azure-hosted-apps)
   - [Connection String (Development/Local)](#2-connection-string-developmentlocal)
   - [Service Principal (CI/CD)](#3-service-principal-cicd)
8. [Best Practices](#best-practices)
   - [Security](#1-security)
   - [Performance](#2-performance)
   - [Error Handling](#3-error-handling)
   - [Connection Management](#4-connection-management)
9. [Migration from Legacy SDK](#migration-from-legacy-sdk)
10. [Useful Resources](#useful-resources)
11. [Summary](#summary)

## Available Approaches

### 1. **Azure.Data.Tables SDK (Recommended)**
- **Current unified SDK** that works with both Azure Table Storage and Azure Cosmos DB Table API
- Modern, async-first design with better performance
- Supports .NET Core/.NET 5+ and .NET Framework
- **NuGet Package**: `Azure.Data.Tables`

### 2. **Azure Cosmos DB Table API**
- Premium capabilities with global distribution
- Single-digit millisecond latencies
- Guaranteed high availability
- Automatic secondary indexing
- Uses the same `Azure.Data.Tables` SDK

## Key Libraries

### Primary Library
```xml
<PackageReference Include="Azure.Data.Tables" Version="12.8.3" />
```

### Supporting Libraries (Optional)
```xml
<!-- For dependency injection -->
<PackageReference Include="Microsoft.Extensions.DependencyInjection" Version="7.0.0" />
<PackageReference Include="Microsoft.Extensions.Configuration" Version="7.0.0" />

<!-- For managed identity authentication -->
<PackageReference Include="Azure.Identity" Version="1.10.4" />
```

## Basic Operations

### Setting Up a Table Client

**The TableClient class** is the primary interface for interacting with Azure Table Storage. It serves as a **lightweight wrapper around the Azure Table Storage REST API**, providing a strongly-typed, async-first experience for .NET developers.


```csharp
using Azure.Data.Tables;
using Azure.Identity;

// Using Managed Identity (basic example - see Authentication section for details)
var credential = new DefaultAzureCredential();
var serviceClient = new TableServiceClient(
    new Uri("https://yourstorageaccount.table.core.windows.net/"), 
    credential);

var tableClient = serviceClient.GetTableClient("YourTableName");

// Ensure table exists
await tableClient.CreateIfNotExistsAsync();
```
#### How TableClient Works

The `TableClient` class abstracts the complexity of direct HTTP REST API calls by:

1. **REST API Foundation**: Under the hood, all operations are translated into HTTP requests to the Azure Table Storage REST endpoints:
   - `GET` requests for query operations
   - `POST` requests for insert operations  
   - `PUT`/`PATCH` requests for update operations
   - `DELETE` requests for delete operations

2. **Authentication Handling**: Automatically manages authentication headers (Azure AD tokens, SAS tokens, or account keys) for each REST call

3. **Serialization/Deserialization**: Converts your .NET objects to/from JSON or AtomPub XML format used by the REST API

4. **Error Translation**: Transforms HTTP status codes and error responses into meaningful .NET exceptions

5. **Connection Management**: Handles HTTP connection pooling, timeouts, and retry logic

#### Key Benefits

- **Type Safety**: Strongly-typed entity operations instead of raw HTTP calls
- **Async Support**: Native async/await patterns for non-blocking operations
- **Built-in Retry**: Automatic retry logic with exponential backoff
- **Performance**: Optimized HTTP client with connection pooling
- **Cross-Platform**: Works on .NET Core, .NET Framework, and .NET 5

#### TableServiceClient ve TableClient 

**TableServiceClient** is **designed for table management operations** at the account level. You use it to create, delete, or list tables within your Azure Storage account. Think of it as the tool for setting up and organizing your tables.

**TableClient** is focused on **data operations within a specific, existing table**. Once a table exists, you use TableClient to insert, query, update, or delete entities (rows) in that table. It’s the tool for day-to-day data manipulation.


| Feature | **TableServiceClient** | **TableClient** |
|---------|------------------------|------------------|
| **Primary Purpose** | Account-level client for managing multiple tables | Table-level client for CRUD operations on entities |
| **Operations** | Create, delete, list tables | Insert, query, update, delete entities |
| **Scope** | Entire storage account | Single table |
| **Typical Usage** | Table management operations | Data operations (CRUD) |
| **Authentication** | Requires account-level permissions | Requires table-level permissions |
| **Creation** | `new TableServiceClient(uri, credential)` | `serviceClient.GetTableClient("TableName")` |
| **Key Methods** | `CreateTableAsync()`, `DeleteTableAsync()`, `GetTablesAsync()` | `AddEntityAsync()`, `QueryAsync()`, `UpdateEntityAsync()`, `DeleteEntityAsync()` |
| **When to Use** | Setting up infrastructure, managing table lifecycle | Day-to-day data operations |

| **TableServiceClient** | **TableClient** |
|------------------------|------------------|
| Account-level client for managing multiple tables | Table-level client for CRUD operations on entities |
| ![alt text](<images/001.00 TableServiceClient.png>) | ![alt text](<images/001.01 TableClient.png>) |


### Define Your Entity

Azure Table Storage supports two primary approaches for defining entities: implementing the `ITableEntity` interface for strongly-typed entities, or using the built-in `TableEntity` class for dynamic/flexible scenarios.

#### ITableEntity Interface

The `ITableEntity` interface is the **modern, recommended approach** for defining strongly-typed entities. It provides compile-time safety, IntelliSense support, and explicit control over your data model.

<img src="images/002.00 ITableEntity.png" alt="ITableEntity Interface Diagram" style="border: 2px solid #0078d4; border-radius: 8px; padding: 10px; background-color: #f8f9fa; display: block; margin: 20px auto; max-width: 100%;">

**Key Characteristics of ITableEntity:**
- **Strongly-typed**: Compile-time safety with custom properties
- **Interface-based**: Flexible implementation without inheritance constraints
- **Required properties**: Must implement PartitionKey, RowKey, Timestamp, and ETag
- **Performance**: Optimized serialization/deserialization
- **Validation**: Custom validation and business logic in your entity class
- **Migration-friendly**: Easy to evolve schema over time

**When to use ITableEntity:**
- Well-defined, stable entity schemas
- Need compile-time safety and IntelliSense
- Custom business logic in entity classes
- Performance-critical applications
- Large development teams requiring type safety

```csharp
using Azure.Data.Tables;

public class EmployeeEntity : ITableEntity
{
    // Required ITableEntity properties
    public string PartitionKey { get; set; } = default!;  // Logical grouping (e.g., Department)
    public string RowKey { get; set; } = default!;        // Unique identifier within partition
    public DateTimeOffset? Timestamp { get; set; }        // System-managed last modified time
    public ETag ETag { get; set; }                        // Optimistic concurrency control
    
    // Custom business properties
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Department { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public DateTime HireDate { get; set; }
    public decimal Salary { get; set; }
    public bool IsActive { get; set; } = true;

    // Optional: Custom business logic
    public string FullName => $"{FirstName} {LastName}";
    public int YearsOfService => DateTime.UtcNow.Year - HireDate.Year;
}
```

#### TableEntity Class

The `TableEntity` class is a **built-in implementation** that provides dynamic property access through a dictionary-like interface. It's perfect for scenarios where the schema is unknown, evolving, or when working with heterogeneous data.

**Key Characteristics of TableEntity:**
- **Dynamic**: Properties accessed via dictionary-like syntax (`entity["PropertyName"]`)
- **Flexible**: No predefined schema required
- **Built-in**: Ready to use without custom classes
- **Type conversion**: Built-in methods for type safety (`GetString()`, `GetInt32()`, etc.)
- **Schema evolution**: Easy to handle changing data structures
- **Polymorphic**: Can store different entity types in the same table

**When to use TableEntity:**
- Unknown or evolving schemas
- Rapid prototyping and development
- Working with external/legacy data
- Multiple entity types in same table
- Schema migration scenarios
- JSON-like flexible data storage

```csharp
using Azure.Data.Tables;

// Create TableEntity with constructor
var employee = new TableEntity("Sales", "001")
{
    ["FirstName"] = "John",
    ["LastName"] = "Doe",
    ["Department"] = "Sales",
    ["Email"] = "john.doe@company.com",
    ["HireDate"] = DateTime.UtcNow,
    ["Salary"] = 75000.00m,
    ["IsActive"] = true
};

// Access properties dynamically
var firstName = employee.GetString("FirstName");
var salary = employee.GetDouble("Salary");
var hireDate = employee.GetDateTime("HireDate");
var isActive = employee.GetBoolean("IsActive");

// Check if property exists
if (employee.TryGetValue("Department", out var department))
{
    Console.WriteLine($"Department: {department}");
}

// Add properties dynamically
employee["LastReview"] = DateTime.UtcNow.AddMonths(-6);
employee["PerformanceRating"] = "Excellent";
```

#### Comparison: ITableEntity vs TableEntity

| Feature | **ITableEntity Implementation** | **TableEntity Class** |
|---------|--------------------------------|----------------------|
| **Type Safety** | ✅ Compile-time safety | ⚠️ Runtime type checking |
| **IntelliSense** | ✅ Full property support | ❌ Dictionary-style access |
| **Performance** | ✅ Optimized serialization | ⚠️ Slight overhead for type conversion |
| **Schema Flexibility** | ❌ Fixed at compile time | ✅ Dynamic schema changes |
| **Code Maintenance** | ✅ Easy refactoring | ⚠️ Property name typos possible |
| **Business Logic** | ✅ Custom methods/properties | ❌ External logic required |
| **Learning Curve** | ⚠️ Requires interface knowledge | ✅ Simple dictionary-like usage |
| **Multiple Entity Types** | ❌ One class per type | ✅ Single class for all types |

#### Hybrid Approach: Custom Entity with Dynamic Properties

You can also create a hybrid approach that combines the benefits of both patterns:

```csharp
public class FlexibleEmployeeEntity : ITableEntity
{
    // Required ITableEntity properties
    public string PartitionKey { get; set; } = default!;
    public string RowKey { get; set; } = default!;
    public DateTimeOffset? Timestamp { get; set; }
    public ETag ETag { get; set; }
    
    // Core strongly-typed properties
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    
    // Dynamic properties for extensibility
    private readonly Dictionary<string, object> _dynamicProperties = new();
    
    public void SetDynamicProperty(string key, object value)
    {
        _dynamicProperties[key] = value;
    }
    
    public T? GetDynamicProperty<T>(string key)
    {
        return _dynamicProperties.TryGetValue(key, out var value) && value is T typedValue 
            ? typedValue 
            : default;
    }
}
```

### CRUD Operations

#### Query (Read)

Azure Table Storage supports **OData query syntax** for filtering and querying entities. Here are the supported query operations:

**Supported Query Options:**
- `$filter` - Filter entities (max 15 discrete comparisons)
- `$top` - Limit number of results
- `$select` - Select specific properties

**OData Filter Operators:**
- **Comparison**: `eq`, `ne`, `gt`, `ge`, `lt`, `le`
- **Logical**: `and`, `or`, `not`
- **String functions**: `startswith()`, `endswith()`, `contains()`, `length()`, `substring()`
- **Date/Time functions**: `year()`, `month()`, `day()`, `hour()`, `minute()`, `second()`

#### Query Return Types

Azure Table Storage supports **multiple return types** for queries, giving you flexibility in how you handle data:

##### 1. **Strongly-Typed Entities (Recommended)**
Uses your custom classes that implement `ITableEntity` - provides compile-time safety, IntelliSense support, and is best for well-defined schemas.

##### 2. **TableEntity (Dynamic/Flexible)**
Built-in class for dynamic data access with dictionary-like property access (`entity["PropertyName"]`) and type conversion methods (`GetString()`, `GetInt32()`, etc.). Perfect for unknown schemas or schema evolution.

##### 3. **Raw JSON Response (Advanced)**
For advanced scenarios where you need the raw JSON - can convert TableEntity to JSON string using `JsonSerializer.Serialize(entity.ToDictionary())`.

##### 4. **Mixed Data Types**
Handle different entity types in the same table using discriminator properties to identify entity types and switch between different handling logic.

##### 5. **Custom Serialization**
Store complex nested objects as JSON within table properties using custom entity classes with JSON serialization helpers.

**When to Use Each Approach:**
- **Strongly-typed**: Well-defined schema + compile-time safety
- **TableEntity**: Dynamic data, schema evolution, or multiple entity types
- **Custom serialization**: Complex nested objects stored as JSON

**Examples of Different Return Types:**

```csharp
// 1. Strongly-typed entities (recommended)
var typedEmployees = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales'");

await foreach (var employee in typedEmployees)
{
    Console.WriteLine($"{employee.FirstName} {employee.LastName}"); // IntelliSense support
}

// 2. Dynamic TableEntity (flexible)
var dynamicEntities = tableClient.QueryAsync<TableEntity>(
    filter: $"PartitionKey eq 'Sales'");

await foreach (var entity in dynamicEntities)
{
    // Access properties dynamically
    if (entity.TryGetValue("FirstName", out var firstName))
    {
        Console.WriteLine($"FirstName: {firstName}");
    }
    
    // Type conversion methods
    var department = entity.GetString("Department");
    var hireDate = entity.GetDateTime("HireDate");
}

// 3. Mixed entity types with discriminator
var mixedEntities = tableClient.QueryAsync<TableEntity>(
    filter: $"PartitionKey eq 'Mixed'");

await foreach (var entity in mixedEntities)
{
    var entityType = entity.GetString("EntityType");
    switch (entityType)
    {
        case "Employee":
            var empName = entity.GetString("FirstName");
            Console.WriteLine($"Employee: {empName}");
            break;
        case "Customer":
            var custName = entity.GetString("CompanyName");
            Console.WriteLine($"Customer: {custName}");
            break;
    }
}
```

```csharp
// 1. Point query (most efficient - single entity by PartitionKey + RowKey)
try
{
    var employee = await tableClient.GetEntityAsync<EmployeeEntity>("Sales", "001");
    Console.WriteLine($"Found: {employee.Value.FirstName} {employee.Value.LastName}");
}
catch (RequestFailedException ex) when (ex.Status == 404)
{
    Console.WriteLine("Employee not found");
}

// 2. Query by PartitionKey (efficient - queries single partition)
var salesEmployees = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales'",
    maxPerPage: 100);

await foreach (var employee in salesEmployees)
{
    Console.WriteLine($"{employee.FirstName} {employee.LastName}");
}

// 3. Complex filter queries with multiple conditions
var recentSalesEmployees = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales' and HireDate gt datetime'2023-01-01T00:00:00Z'",
    maxPerPage: 50);

// 4. String operations
var employeesWithJohnName = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"startswith(FirstName, 'John')",
    maxPerPage: 100);

// 5. Range queries
var employeesByRowKeyRange = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales' and RowKey ge '001' and RowKey le '100'",
    maxPerPage: 100);

// 6. Select specific properties (reduces bandwidth)
var employeeNames = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales'",
    select: new[] { "FirstName", "LastName", "Email" },
    maxPerPage: 100);

// 7. Using LINQ (alternative syntax)
var linqQuery = tableClient.Query<EmployeeEntity>(
    e => e.PartitionKey == "Sales" && e.Department == "Engineering");

await foreach (var employee in linqQuery)
{
    Console.WriteLine($"{employee.FirstName} works in {employee.Department}");
}

// 8. Count entities (be careful with large datasets)
var count = 0;
await foreach (var employee in tableClient.QueryAsync<EmployeeEntity>(filter: $"PartitionKey eq 'Sales'"))
{
    count++;
}
Console.WriteLine($"Total employees: {count}");

// 9. Pagination handling
var pageSize = 10;
var allEmployees = new List<EmployeeEntity>();

await foreach (var page in tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales'",
    maxPerPage: pageSize).AsPages())
{
    Console.WriteLine($"Processing page with {page.Values.Count} employees");
    allEmployees.AddRange(page.Values);
    
    // Optional: break after certain number of pages
    if (allEmployees.Count >= 100) break;
}
```

**Query Performance Tips:**
- **Always include PartitionKey** in filters when possible
- **Point queries** (PartitionKey + RowKey) are most efficient
- **Avoid table scans** (queries without PartitionKey)
- **Use pagination** for large result sets
- **Limit selected properties** with `$select` to reduce bandwidth

**Common Filter Examples:**
```csharp
// Date range
"HireDate ge datetime'2023-01-01T00:00:00Z' and HireDate le datetime'2023-12-31T23:59:59Z'"

// String contains
"contains(Email, '@company.com')"

// Numeric comparisons
"Salary gt 50000 and Salary lt 100000"

// Multiple partitions
"PartitionKey eq 'Sales' or PartitionKey eq 'Marketing'"

// Null checks
"Department ne null"

// Boolean properties
"IsActive eq true"
```



#### Create (Insert)

You can insert entities using either a strongly-typed class or a dynamic approach. Here are the main options:

**1. Strongly-Typed Entity (Recommended for well-defined schemas)**
```csharp
var employee = new EmployeeEntity
{
    PartitionKey = "Sales",
    RowKey = "001",
    FirstName = "John",
    LastName = "Doe",
    Department = "Sales",
    Email = "john.doe@company.com",
    HireDate = DateTime.UtcNow
};

try
{
    await tableClient.AddEntityAsync(employee);
    Console.WriteLine("Employee added successfully");
}
catch (RequestFailedException ex) when (ex.Status == 409)
{
    Console.WriteLine("Employee already exists");
}
```

**2. Dynamic Entity with TableEntity (No class required)**
```csharp
var dynamicEmployee = new TableEntity("Marketing", "002")
{
    ["FirstName"] = "Jane",
    ["LastName"] = "Smith",
    ["Department"] = "Marketing",
    ["Email"] = "jane.smith@company.com",
    ["HireDate"] = DateTime.UtcNow,
    ["Salary"] = 75000,
    ["IsActive"] = true
};

await tableClient.AddEntityAsync(dynamicEmployee);
```

**3. Insert from JSON (Dictionary-based, flexible for external data)**
```csharp
using System.Text.Json;

var jsonString = @"{\n  \"PartitionKey\": \"Sales\",\n  \"RowKey\": \"003\",\n  \"FirstName\": \"Bob\",\n  \"Department\": \"Sales\",\n  \"Email\": \"bob@company.com\",\n  \"HireDate\": \"2024-01-15T10:30:00Z\"\n}";

var jsonData = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString);
var entity = new TableEntity(jsonData);
await tableClient.AddEntityAsync(entity);
```

**4. Batch Insert from JSON Array**
```csharp
var jsonArray = @"[
  { \"PartitionKey\": \"Batch\", \"RowKey\": \"001\", \"FirstName\": \"Alice\" },
  { \"PartitionKey\": \"Batch\", \"RowKey\": \"002\", \"FirstName\": \"Charlie\" }
]";

var employeeList = JsonSerializer.Deserialize<List<Dictionary<string, object>>>(jsonArray);
var batchActions = new List<TableTransactionAction>();

foreach (var empData in employeeList)
{
    var batchEntity = new TableEntity(empData);
    batchActions.Add(new TableTransactionAction(TableTransactionActionType.Add, batchEntity));
}

await tableClient.SubmitTransactionAsync(batchActions);
```

**When to use each approach:**
- Use **strongly-typed** for compile-time safety and well-known schemas.
- Use **dynamic TableEntity** or **JSON** for flexible, schema-less, or external data scenarios.
- Use **batch** for efficient insertion of multiple records with the same PartitionKey.
```csharp
// 1. Dynamic entity (no class)
var dynamicEmployee = new TableEntity("Sales", "004")
{
    ["FirstName"] = "Mark",
    ["LastName"] = "Johnson",
    ["Department"] = "Sales",
    ["Email"] = "mark.johnson@company.com",
    ["HireDate"] = DateTime.UtcNow
};

await tableClient.AddEntityAsync(dynamicEmployee);

// 2. Insert from JSON string
var jsonString = @"{
    ""PartitionKey"": ""Sales"",
    ""RowKey"": ""005"",
    ""FirstName"": ""Lucy"",
    ""LastName"": ""Brown"",
    ""Department"": ""Sales"",
    ""Email"": ""lucy.brown@company.com"",
    ""HireDate"": ""2024-02-20T09:00:00Z""
}";

var jsonData = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString);
await tableClient.AddEntityAsync(new TableEntity(jsonData));

// 3. Batch insert from JSON array
var jsonArray = @"[
  { ""PartitionKey"": ""Sales"", ""RowKey"": ""006"", ""FirstName"": ""Tom"" },
  { ""PartitionKey"": ""Sales"", ""RowKey"": ""007"", ""FirstName"": ""Jerry"" }
]";

var employeeList = JsonSerializer.Deserialize<List<Dictionary<string, object>>>(jsonArray);
var batchActions = new List<TableTransactionAction>();

foreach (var empData in employeeList)
{
    var batchEntity = new TableEntity(empData);
    batchActions.Add(new TableTransactionAction(TableTransactionActionType.Add, batchEntity));
}

await tableClient.SubmitTransactionAsync(batchActions);
```

#### Update
```csharp
// Get existing entity
var employee = await tableClient.GetEntityAsync<EmployeeEntity>("Sales", "001");
var entity = employee.Value;

// Modify properties
entity.Department = "Marketing";
entity.Email = "john.doe.marketing@company.com";

// Update with optimistic concurrency
try
{
    await tableClient.UpdateEntityAsync(entity, entity.ETag, TableUpdateMode.Replace);
    Console.WriteLine("Employee updated successfully");
}
catch (RequestFailedException ex) when (ex.Status == 412)
{
    Console.WriteLine("Entity was modified by another process");
}
```

#### Delete
```csharp
try
{
    await tableClient.DeleteEntityAsync("Sales", "001");
    Console.WriteLine("Employee deleted successfully");
}
catch (RequestFailedException ex) when (ex.Status == 404)
{
    Console.WriteLine("Employee not found");
}
```

## Advanced Patterns

### Batch Operations
```csharp
var batchActions = new List<TableTransactionAction>();

// Add multiple entities to batch (same partition key)
for (int i = 0; i < 10; i++)
{
    var employee = new EmployeeEntity
    {
        PartitionKey = "Sales",
        RowKey = $"00{i}",
        FirstName = $"Employee{i}",
        LastName = "Batch",
        Department = "Sales"
    };
    
    batchActions.Add(new TableTransactionAction(TableTransactionActionType.Add, employee));
}

// Execute batch
try
{
    await tableClient.SubmitTransactionAsync(batchActions);
    Console.WriteLine("Batch operation completed");
}
catch (RequestFailedException ex)
{
    Console.WriteLine($"Batch operation failed: {ex.Message}");
}
```

### Retry Logic with Exponential Backoff
```csharp
using Polly;

var retryPolicy = Policy
    .Handle<RequestFailedException>(ex => ex.Status >= 500)
    .WaitAndRetryAsync(
        retryCount: 3,
        sleepDurationProvider: retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
        onRetry: (outcome, timespan, retryCount, context) =>
        {
            Console.WriteLine($"Retry {retryCount} after {timespan} seconds");
        });

await retryPolicy.ExecuteAsync(async () =>
{
    await tableClient.AddEntityAsync(employee);
});
```

### Dependency Injection Setup
```csharp
// Program.cs or Startup.cs
using Azure.Data.Tables;
using Azure.Identity;
using Microsoft.Extensions.DependencyInjection;

public void ConfigureServices(IServiceCollection services)
{
    services.AddSingleton<TableServiceClient>(provider =>
    {
        var credential = new DefaultAzureCredential();
        return new TableServiceClient(
            new Uri("https://yourstorageaccount.table.core.windows.net/"), 
            credential);
    });
    
    services.AddScoped<IEmployeeService, EmployeeService>();
}

// Service implementation
public interface IEmployeeService
{
    Task<EmployeeEntity?> GetEmployeeAsync(string partitionKey, string rowKey);
    Task AddEmployeeAsync(EmployeeEntity employee);
}

public class EmployeeService : IEmployeeService
{
    private readonly TableClient _tableClient;
    
    public EmployeeService(TableServiceClient serviceClient)
    {
        _tableClient = serviceClient.GetTableClient("Employees");
    }
    
    public async Task<EmployeeEntity?> GetEmployeeAsync(string partitionKey, string rowKey)
    {
        try
        {
            var response = await _tableClient.GetEntityAsync<EmployeeEntity>(partitionKey, rowKey);
            return response.Value;
        }
        catch (RequestFailedException ex) when (ex.Status == 404)
        {
            return null;
        }
    }
    
    public async Task AddEmployeeAsync(EmployeeEntity employee)
    {
        await _tableClient.AddEntityAsync(employee);
    }
}
```

## Authentication Approaches

### 1. **Managed Identity (Recommended for Azure-hosted apps)**
```csharp
using Azure.Data.Tables;
using Azure.Identity;

var credential = new DefaultAzureCredential();
var serviceClient = new TableServiceClient(
    new Uri("https://yourstorageaccount.table.core.windows.net/"), 
    credential);
```

### 2. **Connection String (Development/Local)**
```csharp
using Azure.Data.Tables;

var connectionString = "DefaultEndpointsProtocol=https;AccountName=yourstorageaccount;AccountKey=yourkey;EndpointSuffix=core.windows.net";
var serviceClient = new TableServiceClient(connectionString);
```

### 3. **Service Principal (CI/CD)**
```csharp
using Azure.Data.Tables;
using Azure.Identity;

var credential = new ClientSecretCredential(
    tenantId: "your-tenant-id",
    clientId: "your-client-id",
    clientSecret: "your-client-secret");

var serviceClient = new TableServiceClient(
    new Uri("https://yourstorageaccount.table.core.windows.net/"), 
    credential);
```

## Best Practices

### 1. **Security**
- **Always use Managed Identity** for Azure-hosted applications
- Store sensitive configuration in Azure Key Vault
- Use least-privilege access with Azure RBAC

### 2. **Performance**
- Use point queries (PartitionKey + RowKey) when possible
- Design partition keys to distribute load evenly
- Use batch operations for multiple entities in same partition
- Implement proper retry logic with exponential backoff

### 3. **Error Handling**
```csharp
try
{
    await tableClient.AddEntityAsync(employee);
}
catch (RequestFailedException ex)
{
    switch (ex.Status)
    {
        case 409: // Conflict - entity already exists
            // Handle duplicate
            break;
        case 404: // Not Found
            // Handle missing resource
            break;
        case 412: // Precondition Failed - ETag mismatch
            // Handle concurrency conflict
            break;
        default:
            // Handle other errors
            throw;
    }
}
```

### 4. **Connection Management**
- Use singleton pattern for **TableServiceClient**
- Implement proper disposal in long-running applications
- Configure appropriate timeouts

## Migration from Legacy SDK

### Why Legacy SDKs Were Discontinued

The legacy `Microsoft.Azure.Cosmos.Table` and `WindowsAzure.Storage` SDKs have been **deprecated and discontinued** for several important reasons:

#### **1. Architecture & Design Issues**
- **Monolithic Design**: `WindowsAzure.Storage` was a massive package that included all Azure Storage services (Blob, Queue, Table, File), making it heavyweight
- **Synchronous-First**: Legacy SDKs were designed with sync-first patterns, making async operations less efficient
- **Complex Dependencies**: Multiple internal dependencies that caused versioning conflicts

#### **2. Modern Development Standards**
- **Async/Await Patterns**: Modern applications require efficient async operations from the ground up
- **Performance**: Legacy SDKs had performance bottlenecks and inefficient memory usage
- **Target Framework Support**: Limited support for newer .NET versions and .NET Core

#### **3. Service Evolution**
- **Unified Experience**: Need for a single SDK to work with both Azure Table Storage and Azure Cosmos DB Table API
- **Feature Parity**: Legacy SDKs couldn't easily support new features across both services
- **Consistency**: Microsoft moved to consistent Azure SDK guidelines across all services

### Key Differences Between Libraries

| Feature | `WindowsAzure.Storage` (Legacy) | `Microsoft.Azure.Cosmos.Table` (Legacy) | `Azure.Data.Tables` (Current) |
|---------|--------------------------------|------------------------------------------|-------------------------------|
| **Status** | ❌ Deprecated | ❌ Deprecated | ✅ Active & Recommended |
| **Target Services** | Azure Table Storage only | Azure Cosmos DB Table API only | Both Azure Table Storage & Cosmos DB |
| **Package Size** | Large (includes all storage services) | Medium | Small (table-focused) |
| **Async Support** | Partial (retrofitted) | Better | Native async-first |
| **Performance** | Slower | Moderate | Optimized |
| **Authentication** | Connection strings, SAS | Connection strings, SAS | Managed Identity, SAS, Connection strings |
| **.NET Core Support** | Limited | Good | Full support |
| **Entity Model** | `TableEntity` inheritance | `TableEntity` inheritance | `ITableEntity` interface |
| **Query API** | Basic LINQ | Enhanced LINQ | Modern LINQ + OData |
| **Batch Operations** | Limited | Good | Enhanced |
| **Error Handling** | Basic exceptions | Enhanced | Detailed with retry policies |
| **Dependency Injection** | Manual setup | Manual setup | Built-in support |

### Migration Steps & Code Changes

If you're migrating from the legacy `Microsoft.Azure.Cosmos.Table` or `WindowsAzure.Storage` SDKs:

#### **1. Update Package References**
```xml
<!-- REMOVE legacy packages -->
<!-- <PackageReference Include="Microsoft.Azure.Cosmos.Table" Version="1.0.8" /> -->
<!-- <PackageReference Include="WindowsAzure.Storage" Version="9.3.3" /> -->

<!-- ADD modern package -->
<PackageReference Include="Azure.Data.Tables" Version="12.8.3" />
<PackageReference Include="Azure.Identity" Version="1.10.4" />
```

#### **2. Update Namespace Imports**
```csharp
// OLD namespaces
// using Microsoft.Azure.Cosmos.Table;
// using Microsoft.WindowsAzure.Storage;
// using Microsoft.WindowsAzure.Storage.Table;

// NEW namespace
using Azure.Data.Tables;
using Azure.Identity;
```

#### **3. Update Entity Model**
```csharp
// OLD - Inheritance model
/*
public class EmployeeEntity : TableEntity
{
    public EmployeeEntity() { }
    
    public EmployeeEntity(string department, string employeeId)
    {
        PartitionKey = department;
        RowKey = employeeId;
    }
    
    public string FirstName { get; set; }
    public string LastName { get; set; }
}
*/

// NEW - Interface model
public class EmployeeEntity : ITableEntity
{
    public string PartitionKey { get; set; } = default!;
    public string RowKey { get; set; } = default!;
    public DateTimeOffset? Timestamp { get; set; }
    public ETag ETag { get; set; }
    
    // Your custom properties
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
}
```

#### **4. Update Client Initialization**
```csharp
// OLD - WindowsAzure.Storage
/*
var storageAccount = CloudStorageAccount.Parse(connectionString);
var tableClient = storageAccount.CreateCloudTableClient();
var table = tableClient.GetTableReference("Employees");
await table.CreateIfNotExistsAsync();
*/

// OLD - Microsoft.Azure.Cosmos.Table
/*
var account = CloudStorageAccount.Parse(connectionString);
var client = account.CreateCloudTableClient(new TableClientConfiguration());
var table = client.GetTableReference("Employees");
await table.CreateIfNotExistsAsync();
*/

// NEW - Azure.Data.Tables
var credential = new DefaultAzureCredential();
var serviceClient = new TableServiceClient(
    new Uri("https://yourstorageaccount.table.core.windows.net/"), 
    credential);
var tableClient = serviceClient.GetTableClient("Employees");
await tableClient.CreateIfNotExistsAsync();
```

#### **5. Update CRUD Operations**
```csharp
// OLD - Insert operation
/*
var insertOperation = TableOperation.Insert(employee);
var result = await table.ExecuteAsync(insertOperation);
*/

// NEW - Insert operation
await tableClient.AddEntityAsync(employee);

// OLD - Query operation
/*
var query = new TableQuery<EmployeeEntity>()
    .Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, "Sales"));
var results = await table.ExecuteQuerySegmentedAsync(query, null);
*/

// NEW - Query operation
var employees = tableClient.QueryAsync<EmployeeEntity>(
    filter: $"PartitionKey eq 'Sales'");
```

### Migration Benefits

Moving to `Azure.Data.Tables` provides:

✅ **Better Performance** - Optimized for modern async patterns  
✅ **Unified SDK** - Works with both Azure Table Storage and Cosmos DB  
✅ **Enhanced Security** - Built-in support for Managed Identity  
✅ **Improved Developer Experience** - Better IntelliSense and error messages  
✅ **Future-Proof** - Active development and feature updates  
✅ **Smaller Package Size** - Focused on table operations only  
✅ **Better Error Handling** - Detailed exceptions with retry policies  

### Timeline & Support

| SDK | Last Update | Support Status | Recommendation |
|-----|-------------|----------------|----------------|
| `WindowsAzure.Storage` | March 2021 | ❌ End of Life | Migrate immediately |
| `Microsoft.Azure.Cosmos.Table` | October 2021 | ❌ Deprecated | Migrate immediately |
| `Azure.Data.Tables` | Current | ✅ Active Development | ✅ Use for all new projects |

> **⚠️ Important**: Microsoft will not provide security updates or bug fixes for legacy SDKs. Migration to `Azure.Data.Tables` is strongly recommended for security and compatibility reasons.

## Useful Resources

- **Official Documentation**: [Azure Table Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/tables/)<br>
  Comprehensive documentation covering Azure Table Storage concepts, capabilities, limitations, and service-level features. Essential for understanding storage account setup, pricing models, scalability limits, and architectural considerations when designing table storage solutions.

- **SDK Reference**: [Azure.Data.Tables Reference](https://learn.microsoft.com/en-us/dotnet/api/azure.data.tables)<br>
  Complete API reference documentation for the Azure.Data.Tables SDK, including all classes, methods, properties, and their signatures. Critical development resource for understanding method parameters, return types, exceptions, and proper usage patterns when writing table storage code.

- **Samples**: [Azure SDK for .NET Samples](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/tables/Azure.Data.Tables/samples)<br>
  Official code samples demonstrating real-world implementation patterns, authentication methods, CRUD operations, and advanced scenarios. Provides practical examples of best practices, error handling, and common use cases that developers can adapt for their specific table storage implementations.

- **Migration Guide**: [Migrating to Azure.Data.Tables](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/tables/Azure.Data.Tables/MigrationGuide.md)<br>
  Step-by-step guide for migrating from legacy SDKs (WindowsAzure.Storage, Microsoft.Azure.Cosmos.Table) to the modern Azure.Data.Tables SDK. Essential for teams upgrading existing applications, providing code comparisons, breaking change explanations, and migration strategies to ensure smooth transitions.

## Summary

The **Azure.Data.Tables** SDK is the recommended approach for accessing Azure Table Storage from C#. It provides:

- ✅ Modern async/await patterns
- ✅ Unified API for both Azure Table Storage and Cosmos DB Table API
- ✅ Better performance and reliability
- ✅ Built-in retry logic and error handling
- ✅ Support for managed identity authentication
- ✅ Comprehensive LINQ query support

Choose **Azure Table Storage** for cost-effective NoSQL storage, or **Azure Cosmos DB Table API** when you need premium features like global distribution and guaranteed low latency.