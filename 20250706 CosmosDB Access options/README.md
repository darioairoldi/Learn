# Azure CosmosDB Access with C#

## Overview
**Azure Cosmos DB** is a fully managed NoSQL database service that provides **global distribution, elastic scaling, and multi-model support** with comprehensive SLAs for throughput, latency, availability, and consistency. It offers multiple APIs including **SQL (Core)**, **MongoDB**, **Cassandra**, **Gremlin**, and **Table**, making it highly versatile for various application patterns.

## Table of Contents

1. Overview
2. Available Approaches
   - SQL API (Core)
   - MongoDB API
   - Other APIs
3. Key Libraries
   - Primary Library
   - Supporting Libraries
4. Basic Operations
   - Setting Up a Cosmos Client
   - Managing Databases and Containers
   - Working with Items
5. CRUD Operations
   - Query (Read)
   - Create
   - Update
   - Delete
6. Advanced Patterns
   - Bulk Operations
   - Change Feed Processing
   - Server-Side Programming
   - Retry Policies
   - Dependency Injection Setup
7. Authentication Approaches
8. Migration from Legacy SDK
9. Useful Resources
10. Summary

## Available Approaches

### 1. **SQL API (Core)**
- **Native JSON document model** with rich SQL querying capabilities
- Recommended for new applications with flexible schema requirements
- **Primary C# SDK**: `Microsoft.Azure.Cosmos`
- Best performance and feature support

### 2. **MongoDB API**
- MongoDB-compatible API for existing MongoDB applications
- Use standard MongoDB drivers and tools
- No code changes required for MongoDB applications
- **C# SDK**: MongoDB .NET Driver

### 3. **Other APIs**
- **Cassandra API**: For existing Cassandra workloads (CqlClient)
- **Gremlin API**: For graph databases (Gremlin.Net)
- **Table API**: For Azure Table Storage applications (Azure.Data.Tables)

## Key Libraries

### Primary Library
```xml
<!-- For SQL API (Recommended) -->
<PackageReference Include="Microsoft.Azure.Cosmos" Version="3.37.0" />

<!-- For MongoDB API -->
<PackageReference Include="MongoDB.Driver" Version="2.22.0" />
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

### Setting Up a Cosmos Client

The **CosmosClient class** is the primary interface for interacting with Azure Cosmos DB SQL API. It provides a thread-safe client that manages connections, handles retries, and implements the Azure Cosmos DB protocol.

```csharp
using Microsoft.Azure.Cosmos;

// Connection using endpoint and key (basic example)
var endpoint = "https://your-account.documents.azure.com:443/";
var key = "your-primary-key";
var cosmosClient = new CosmosClient(endpoint, key, new CosmosClientOptions
{
    ConnectionMode = ConnectionMode.Direct,
    SerializerOptions = new CosmosSerializationOptions
    {
        PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
    }
});
```

#### Key CosmosClientOptions

The CosmosClient behavior can be customized with CosmosClientOptions:

```csharp
var clientOptions = new CosmosClientOptions
{
    // Performance options
    ConnectionMode = ConnectionMode.Direct, // Direct for better performance
    ApplicationName = "YourApplication",
    
    // Consistency level
    ConsistencyLevel = ConsistencyLevel.Session, // Default
    
    // Regional preferences
    ApplicationRegion = "West US 2",
    
    // Serialization
    SerializerOptions = new CosmosSerializationOptions
    {
        PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase,
        IgnoreNullValues = true
    },
    
    // Resilience
    MaxRetryAttemptsOnRateLimitedRequests = 9,
    MaxRetryWaitTimeOnRateLimitedRequests = TimeSpan.FromSeconds(30)
};

var cosmosClient = new CosmosClient(endpoint, key, clientOptions);
```

### Managing Databases and Containers

```csharp
// Create or get a database
Database database = await cosmosClient.CreateDatabaseIfNotExistsAsync("MyDatabase");

// Create container with RU/s provisioning and partition key
ContainerProperties containerProperties = new ContainerProperties
{
    Id = "MyContainer",
    PartitionKeyPath = "/partitionKey",
    
    // Optional: configure indexing policy
    IndexingPolicy = new IndexingPolicy
    {
        Automatic = true,
        IndexingMode = IndexingMode.Consistent,
        IncludedPaths = { new IncludedPath { Path = "/*" } },
        ExcludedPaths = { new ExcludedPath { Path = "/path/to/exclude/*" } }
    }
};

// Create with 400 RU/s throughput
Container container = await database.CreateContainerIfNotExistsAsync(
    containerProperties, 
    ThroughputProperties.CreateManualThroughput(400));
```

### Working with Items

In Azure Cosmos DB's SQL API, you work with "items" - JSON documents with unique IDs:

```csharp
// Define a model class
public class TodoItem
{
    [JsonProperty("id")]
    public string Id { get; set; } = Guid.NewGuid().ToString();
    
    [JsonProperty("partitionKey")]
    public string PartitionKey { get; set; }
    
    public string Title { get; set; }
    public bool Completed { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
}

// Alternative: Using System.Text.Json attributes
public class TodoItemWithSystemTextJson
{
    [JsonPropertyName("id")]
    public string Id { get; set; } = Guid.NewGuid().ToString();
    
    [JsonPropertyName("partitionKey")]
    public string PartitionKey { get; set; }
    
    public string Title { get; set; }
    public bool Completed { get; set; }
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
}
```

## CRUD Operations

### Query (Read)

CosmosDB SQL API provides a rich SQL-like query language for JSON documents. You can query using strongly-typed entities, dynamic objects, or raw JSON responses:

```csharp
// 1. Point read by ID and partition key (most efficient)
try
{
    ItemResponse<TodoItem> response = await container.ReadItemAsync<TodoItem>(
        id: "task-1", 
        partitionKey: new PartitionKey("personal"));
    
    TodoItem item = response.Resource;
    Console.WriteLine($"Retrieved item: {item.Title}, RUs consumed: {response.RequestCharge}");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
{
    Console.WriteLine("Item not found");
}

// 2. SQL Query
QueryDefinition query = new QueryDefinition(
    "SELECT * FROM c WHERE c.partitionKey = @partitionKey AND c.completed = @status")
    .WithParameter("@partitionKey", "personal")
    .WithParameter("@status", false);

FeedIterator<TodoItem> resultSet = container.GetItemQueryIterator<TodoItem>(
    query,
    requestOptions: new QueryRequestOptions
    {
        MaxItemCount = 10,
        PartitionKey = new PartitionKey("personal")
    });

double totalRequestCharge = 0;
List<TodoItem> results = new List<TodoItem>();

while (resultSet.HasMoreResults)
{
    FeedResponse<TodoItem> response = await resultSet.ReadNextAsync();
    totalRequestCharge += response.RequestCharge;
    results.AddRange(response.ToList());
}

Console.WriteLine($"Found {results.Count} items, total RU consumed: {totalRequestCharge}");

// 3. LINQ query 
using Microsoft.Azure.Cosmos.Linq;

IOrderedQueryable<TodoItem> linqQueryable = container.GetItemLinqQueryable<TodoItem>();

var query = linqQueryable
    .Where(t => t.PartitionKey == "personal" && !t.Completed)
    .OrderBy(t => t.CreatedDate);

using FeedIterator<TodoItem> linqResultSet = query.ToFeedIterator();

while (linqResultSet.HasMoreResults)
{
    foreach (var item in await linqResultSet.ReadNextAsync())
    {
        Console.WriteLine($"{item.Title}: {item.CreatedDate}");
    }
}
```

### Working with Dynamic Entities

You can work with dynamic objects when you don't want to define strongly-typed classes:

```csharp
// 1. Point read with dynamic object
ItemResponse<dynamic> dynamicResponse = await container.ReadItemAsync<dynamic>(
    id: "task-1", 
    partitionKey: new PartitionKey("personal"));

dynamic item = dynamicResponse.Resource;
Console.WriteLine($"Title: {item.title}, Completed: {item.completed}");

// 2. Query with dynamic objects
QueryDefinition dynamicQuery = new QueryDefinition(
    "SELECT * FROM c WHERE c.partitionKey = @partitionKey")
    .WithParameter("@partitionKey", "personal");

FeedIterator<dynamic> dynamicResultSet = container.GetItemQueryIterator<dynamic>(
    dynamicQuery,
    requestOptions: new QueryRequestOptions
    {
        PartitionKey = new PartitionKey("personal")
    });

while (dynamicResultSet.HasMoreResults)
{
    FeedResponse<dynamic> response = await dynamicResultSet.ReadNextAsync();
    foreach (dynamic item in response)
    {
        Console.WriteLine($"ID: {item.id}, Title: {item.title}");
    }
}

// 3. Creating items with dynamic objects
dynamic newDynamicItem = new
{
    id = "dynamic-task-1",
    partitionKey = "personal",
    title = "Task created with dynamic object",
    completed = false,
    tags = new[] { "dynamic", "example" }
};

await container.CreateItemAsync<dynamic>(
    newDynamicItem, 
    new PartitionKey("personal"));
```

### Working with Raw JSON Responses

For maximum flexibility, you can work directly with JSON strings:

```csharp
// 1. Query returning raw JSON stream
QueryDefinition jsonQuery = new QueryDefinition(
    "SELECT * FROM c WHERE c.partitionKey = @partitionKey")
    .WithParameter("@partitionKey", "personal");

FeedIterator jsonIterator = container.GetItemQueryStreamIterator(
    jsonQuery,
    requestOptions: new QueryRequestOptions
    {
        PartitionKey = new PartitionKey("personal")
    });

while (jsonIterator.HasMoreResults)
{
    using ResponseMessage response = await jsonIterator.ReadNextAsync();
    
    if (response.IsSuccessStatusCode)
    {
        using StreamReader reader = new StreamReader(response.Content);
        string jsonContent = await reader.ReadToEndAsync();
        
        Console.WriteLine($"Raw JSON Response: {jsonContent}");
        
        // Parse manually if needed
        using JsonDocument document = JsonDocument.Parse(jsonContent);
        JsonElement root = document.RootElement;
        
        if (root.TryGetProperty("Documents", out JsonElement documents))
        {
            foreach (JsonElement item in documents.EnumerateArray())
            {
                if (item.TryGetProperty("title", out JsonElement title))
                {
                    Console.WriteLine($"Title from JSON: {title.GetString()}");
                }
            }
        }
    }
}

// 2. Point read with raw JSON
using ResponseMessage jsonResponse = await container.ReadItemStreamAsync(
    "task-1", 
    new PartitionKey("personal"));

if (jsonResponse.IsSuccessStatusCode)
{
    using StreamReader reader = new StreamReader(jsonResponse.Content);
    string itemJson = await reader.ReadToEndAsync();
    
    Console.WriteLine($"Raw JSON Item: {itemJson}");
}

// 3. Create item with raw JSON
string newItemJson = """
{
    "id": "json-task-1",
    "partitionKey": "personal",
    "title": "Task created with raw JSON",
    "completed": false,
    "metadata": {
        "createdBy": "system",
        "priority": "high"
    }
}
""";

using MemoryStream stream = new MemoryStream(Encoding.UTF8.GetBytes(newItemJson));
using ResponseMessage createResponse = await container.CreateItemStreamAsync(
    stream, 
    new PartitionKey("personal"));

if (createResponse.IsSuccessStatusCode)
{
    Console.WriteLine($"Created item with status: {createResponse.StatusCode}");
}
```

### Performance Comparison

Different approaches have different performance characteristics:

```csharp
// Performance comparison example
var stopwatch = Stopwatch.StartNew();

// 1. Strongly-typed (fastest deserialization)
var typedResults = new List<TodoItem>();
var typedIterator = container.GetItemQueryIterator<TodoItem>(
    new QueryDefinition("SELECT * FROM c WHERE c.partitionKey = 'personal'"),
    requestOptions: new QueryRequestOptions { PartitionKey = new PartitionKey("personal") });

while (typedIterator.HasMoreResults)
{
    typedResults.AddRange(await typedIterator.ReadNextAsync());
}
stopwatch.Stop();
Console.WriteLine($"Strongly-typed query: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 2. Dynamic objects (flexible but slower)
var dynamicResults = new List<dynamic>();
var dynamicIterator = container.GetItemQueryIterator<dynamic>(
    new QueryDefinition("SELECT * FROM c WHERE c.partitionKey = 'personal'"),
    requestOptions: new QueryRequestOptions { PartitionKey = new PartitionKey("personal") });

while (dynamicIterator.HasMoreResults)
{
    dynamicResults.AddRange(await dynamicIterator.ReadNextAsync());
}
stopwatch.Stop();
Console.WriteLine($"Dynamic query: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 3. Raw JSON (fastest network transfer, manual parsing required)
var jsonIterator = container.GetItemQueryStreamIterator(
    new QueryDefinition("SELECT * FROM c WHERE c.partitionKey = 'personal'"),
    requestOptions: new QueryRequestOptions { PartitionKey = new PartitionKey("personal") });

while (jsonIterator.HasMoreResults)
{
    using var response = await jsonIterator.ReadNextAsync();
    using var reader = new StreamReader(response.Content);
    string json = await reader.ReadToEndAsync();
    // Process JSON as needed
}
stopwatch.Stop();
Console.WriteLine($"Raw JSON query: {stopwatch.ElapsedMilliseconds}ms");
```

#### Query Performance Tips

- **Always include the partition key** in your queries when possible
- **Point reads** (id + partition key) are the most efficient operations
- Use **parameterized queries** to prevent SQL injection and improve caching
- Monitor **request charge (RUs)** to optimize queries
- Use **projections** (`SELECT VALUE c.name`) to return only needed properties
- Consider **paging** with continuation tokens for large result sets

```csharp
// Query with continuation token (pagination)
QueryDefinition largeQuery = new QueryDefinition("SELECT * FROM c");
QueryRequestOptions options = new QueryRequestOptions
{
    MaxItemCount = 10
};

FeedIterator<TodoItem> iterator = container.GetItemQueryIterator<TodoItem>(
    largeQuery, 
    requestOptions: options);

string continuationToken = null;

// First page
FeedResponse<TodoItem> page = await iterator.ReadNextAsync();
continuationToken = page.ContinuationToken;
ProcessItems(page);

// Later, get the next page using the continuation token
options.RequestContinuation = continuationToken;
iterator = container.GetItemQueryIterator<TodoItem>(largeQuery, requestOptions: options);
```

### Create

You can create items using strongly-typed entities, dynamic objects, or raw JSON:

#### Creating with Strongly-Typed Entities

```csharp
// Create a new item with strongly-typed class
var newItem = new TodoItem
{
    Id = "task-1",
    PartitionKey = "personal",
    Title = "Complete Azure Cosmos DB documentation",
    Completed = false
};

// Insert the item
try
{
    ItemResponse<TodoItem> response = await container.CreateItemAsync(
        newItem, 
        new PartitionKey(newItem.PartitionKey));
    
    Console.WriteLine($"Created item: {newItem.Id}");
    Console.WriteLine($"Request charge: {response.RequestCharge} RUs");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.Conflict)
{
    Console.WriteLine("Item already exists");
}

// Upsert - create if not exists, replace if exists
await container.UpsertItemAsync(
    newItem, 
    new PartitionKey(newItem.PartitionKey));

// Create with custom options
ItemRequestOptions requestOptions = new ItemRequestOptions
{
    EnableContentResponseOnWrite = false, // Saves RUs by not returning the created item
    ConsistencyLevel = ConsistencyLevel.Session
};

await container.CreateItemAsync(
    newItem, 
    new PartitionKey(newItem.PartitionKey),
    requestOptions);
```

#### Creating with Dynamic Objects

```csharp
// Create with anonymous object
dynamic dynamicItem = new
{
    id = "dynamic-task-2",
    partitionKey = "personal",
    title = "Task created with dynamic object",
    completed = false,
    priority = "high",
    tags = new[] { "dynamic", "flexible" },
    metadata = new
    {
        createdBy = "system",
        version = "1.0"
    }
};

ItemResponse<dynamic> dynamicResponse = await container.CreateItemAsync<dynamic>(
    dynamicItem, 
    new PartitionKey("personal"));

Console.WriteLine($"Created dynamic item: {dynamicResponse.Resource.id}");

// Create with ExpandoObject for runtime flexibility
dynamic expandoItem = new ExpandoObject();
expandoItem.id = "expando-task-1";
expandoItem.partitionKey = "personal";
expandoItem.title = "Task created with ExpandoObject";
expandoItem.completed = false;

// Add properties dynamically
((IDictionary<string, object>)expandoItem)["customField"] = "customValue";
((IDictionary<string, object>)expandoItem)["timestamp"] = DateTime.UtcNow;

await container.CreateItemAsync<dynamic>(
    expandoItem, 
    new PartitionKey("personal"));

// Upsert with dynamic objects
await container.UpsertItemAsync<dynamic>(
    dynamicItem, 
    new PartitionKey("personal"));
```

#### Creating with Raw JSON

```csharp
// Create item with JSON string
string newItemJson = """
{
    "id": "json-task-2",
    "partitionKey": "personal",
    "title": "Task created with raw JSON",
    "completed": false,
    "priority": "medium",
    "tags": ["json", "manual"],
    "metadata": {
        "createdBy": "api",
        "source": "external-system",
        "timestamp": "2025-01-15T10:30:00Z"
    },
    "customProperties": {
        "nested": {
            "value": 42,
            "active": true
        }
    }
}
""";

// Create using stream for maximum performance
using MemoryStream stream = new MemoryStream(Encoding.UTF8.GetBytes(newItemJson));
using ResponseMessage createResponse = await container.CreateItemStreamAsync(
    stream, 
    new PartitionKey("personal"));

if (createResponse.IsSuccessStatusCode)
{
    Console.WriteLine($"Created JSON item with status: {createResponse.StatusCode}");
    Console.WriteLine($"Request charge: {createResponse.Headers.RequestCharge} RUs");
    
    // Read the created item from response if needed
    using StreamReader reader = new StreamReader(createResponse.Content);
    string createdItemJson = await reader.ReadToEndAsync();
    Console.WriteLine($"Created item: {createdItemJson}");
}
else
{
    Console.WriteLine($"Failed to create item: {createResponse.StatusCode}");
    using StreamReader errorReader = new StreamReader(createResponse.Content);
    string errorMessage = await errorReader.ReadToEndAsync();
    Console.WriteLine($"Error: {errorMessage}");
}

// Upsert with JSON stream
using MemoryStream upsertStream = new MemoryStream(Encoding.UTF8.GetBytes(newItemJson));
using ResponseMessage upsertResponse = await container.UpsertItemStreamAsync(
    upsertStream, 
    new PartitionKey("personal"));

// Create with custom request options using JSON
ItemRequestOptions jsonRequestOptions = new ItemRequestOptions
{
    EnableContentResponseOnWrite = false
};

using MemoryStream customStream = new MemoryStream(Encoding.UTF8.GetBytes(newItemJson));
using ResponseMessage customResponse = await container.CreateItemStreamAsync(
    customStream, 
    new PartitionKey("personal"),
    jsonRequestOptions);
```

#### Performance Comparison for Create Operations

```csharp
var stopwatch = Stopwatch.StartNew();

// 1. Strongly-typed (good balance of performance and type safety)
var typedItem = new TodoItem { Id = "perf-typed", PartitionKey = "test", Title = "Typed" };
await container.CreateItemAsync(typedItem, new PartitionKey("test"));
stopwatch.Stop();
Console.WriteLine($"Strongly-typed create: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 2. Dynamic object (flexible but slower serialization)
dynamic dynamicItem = new { id = "perf-dynamic", partitionKey = "test", title = "Dynamic" };
await container.CreateItemAsync<dynamic>(dynamicItem, new PartitionKey("test"));
stopwatch.Stop();
Console.WriteLine($"Dynamic create: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 3. Raw JSON (fastest, no serialization overhead)
string jsonItem = """{"id": "perf-json", "partitionKey": "test", "title": "JSON"}""";
using var stream = new MemoryStream(Encoding.UTF8.GetBytes(jsonItem));
await container.CreateItemStreamAsync(stream, new PartitionKey("test"));
stopwatch.Stop();
Console.WriteLine($"Raw JSON create: {stopwatch.ElapsedMilliseconds}ms");
```

### Update

You can update items using strongly-typed entities, dynamic objects, or raw JSON through replace operations or patch operations:

#### Updating with Strongly-Typed Entities

```csharp
// Read first, then update
try
{
    // Get the existing item
    ItemResponse<TodoItem> response = await container.ReadItemAsync<TodoItem>(
        "task-1", 
        new PartitionKey("personal"));
    
    TodoItem item = response.Resource;
    
    // Modify properties
    item.Title = "Updated title";
    item.Completed = true;
    
    // Update with optimistic concurrency control using ETag
    ItemRequestOptions options = new ItemRequestOptions
    {
        IfMatchEtag = response.ETag
    };
    
    // Replace the item
    await container.ReplaceItemAsync(
        item, 
        item.Id,
        new PartitionKey(item.PartitionKey), 
        options);
    
    Console.WriteLine("Item updated successfully");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.PreconditionFailed)
{
    Console.WriteLine("Item was modified by another process");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
{
    Console.WriteLine("Item not found");
}

// Direct patch operations without reading first
PatchItemRequestOptions patchOptions = new PatchItemRequestOptions();
List<PatchOperation> patchOperations = new List<PatchOperation>
{
    PatchOperation.Replace("/title", "New patched title"),
    PatchOperation.Replace("/completed", true),
    PatchOperation.Add("/tags", new[] { "important", "documentation" })
};

await container.PatchItemAsync<TodoItem>(
    "task-1", 
    new PartitionKey("personal"),
    patchOperations,
    patchOptions);
```

#### Updating with Dynamic Objects

```csharp
// Read and update with dynamic objects
ItemResponse<dynamic> dynamicResponse = await container.ReadItemAsync<dynamic>(
    "dynamic-task-1", 
    new PartitionKey("personal"));

dynamic item = dynamicResponse.Resource;

// Modify properties
item.title = "Updated dynamic title";
item.completed = true;
item.lastModified = DateTime.UtcNow;

// Add new properties dynamically
item.updatedBy = "system";
item.version = "2.0";

// Replace with dynamic object
await container.ReplaceItemAsync<dynamic>(
    item, 
    (string)item.id,
    new PartitionKey((string)item.partitionKey));

// Patch operations with dynamic values
List<PatchOperation> dynamicPatchOps = new List<PatchOperation>
{
    PatchOperation.Replace("/title", "Patched dynamic title"),
    PatchOperation.Add("/metadata/lastUpdated", DateTime.UtcNow.ToString("O")),
    PatchOperation.Replace("/priority", "urgent"),
    PatchOperation.Remove("/tags/0") // Remove first tag
};

await container.PatchItemAsync<dynamic>(
    "dynamic-task-1", 
    new PartitionKey("personal"),
    dynamicPatchOps);

// Create or update with ExpandoObject
dynamic expandoUpdate = new ExpandoObject();
var expandoDict = (IDictionary<string, object>)expandoUpdate;
expandoDict["id"] = "expando-task-1";
expandoDict["partitionKey"] = "personal";
expandoDict["title"] = "Updated ExpandoObject";
expandoDict["completed"] = true;
expandoDict["updatedAt"] = DateTime.UtcNow;

// Add nested objects
expandoDict["metadata"] = new Dictionary<string, object>
{
    ["lastModifiedBy"] = "api",
    ["version"] = 2,
    ["changes"] = new[] { "title", "status" }
};

await container.UpsertItemAsync<dynamic>(
    expandoUpdate, 
    new PartitionKey("personal"));
```

#### Updating with Raw JSON

```csharp
// Replace using JSON stream
string updatedItemJson = """
{
    "id": "json-task-1",
    "partitionKey": "personal",
    "title": "Updated JSON task",
    "completed": true,
    "priority": "high",
    "tags": ["json", "updated"],
    "metadata": {
        "lastModified": "2025-01-15T15:30:00Z",
        "modifiedBy": "api-service",
        "version": 2
    },
    "history": [
        {
            "action": "created",
            "timestamp": "2025-01-15T10:30:00Z"
        },
        {
            "action": "updated", 
            "timestamp": "2025-01-15T15:30:00Z",
            "changes": ["title", "completed", "priority"]
        }
    ]
}
""";

// Replace with JSON stream
using MemoryStream replaceStream = new MemoryStream(Encoding.UTF8.GetBytes(updatedItemJson));
using ResponseMessage replaceResponse = await container.ReplaceItemStreamAsync(
    replaceStream, 
    "json-task-1",
    new PartitionKey("personal"));

if (replaceResponse.IsSuccessStatusCode)
{
    Console.WriteLine($"Updated JSON item with status: {replaceResponse.StatusCode}");
    Console.WriteLine($"Request charge: {replaceResponse.Headers.RequestCharge} RUs");
}

// Upsert with JSON stream (create if not exists, replace if exists)
using MemoryStream upsertStream = new MemoryStream(Encoding.UTF8.GetBytes(updatedItemJson));
using ResponseMessage upsertResponse = await container.UpsertItemStreamAsync(
    upsertStream, 
    new PartitionKey("personal"));

// Optimistic concurrency with ETag using JSON
ItemRequestOptions etagOptions = new ItemRequestOptions
{
    IfMatchEtag = "\"some-etag-value\"" // Get this from a previous read operation
};

using MemoryStream concurrencyStream = new MemoryStream(Encoding.UTF8.GetBytes(updatedItemJson));
try
{
    using ResponseMessage concurrencyResponse = await container.ReplaceItemStreamAsync(
        concurrencyStream, 
        "json-task-1",
        new PartitionKey("personal"),
        etagOptions);
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.PreconditionFailed)
{
    Console.WriteLine("Item was modified by another process - ETag mismatch");
}
```

#### Advanced Patch Operations

```csharp
// Complex patch operations with different data types
List<PatchOperation> advancedPatchOps = new List<PatchOperation>
{
    // Replace operations
    PatchOperation.Replace("/title", "Advanced patched title"),
    PatchOperation.Replace("/completed", true),
    PatchOperation.Replace("/priority", "critical"),
    
    // Add operations
    PatchOperation.Add("/tags/-", "new-tag"), // Add to end of array
    PatchOperation.Add("/metadata/patchedAt", DateTime.UtcNow),
    PatchOperation.Add("/assignee", new { name = "John Doe", id = "user123" }),
    
    // Remove operations
    PatchOperation.Remove("/oldProperty"),
    PatchOperation.Remove("/tags/0"), // Remove first element from array
    
    // Increment operation (for numeric values)
    PatchOperation.Increment("/retryCount", 1),
    
    // Set operation (like replace, but creates the path if it doesn't exist)
    PatchOperation.Set("/status/lastChecked", DateTime.UtcNow)
};

// Apply patch with conditional predicate
PatchItemRequestOptions advancedPatchOptions = new PatchItemRequestOptions
{
    FilterPredicate = "FROM c WHERE c.version < 5" // Only apply if version is less than 5
};

try
{
    ItemResponse<dynamic> patchResponse = await container.PatchItemAsync<dynamic>(
        "task-1", 
        new PartitionKey("personal"),
        advancedPatchOps,
        advancedPatchOptions);
    
    Console.WriteLine($"Patch applied successfully. New version: {patchResponse.Resource.version}");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.PreconditionFailed)
{
    Console.WriteLine("Patch condition not met - item version is >= 5");
}
```

#### Performance Comparison for Update Operations

```csharp
var stopwatch = Stopwatch.StartNew();

// 1. Full replace with strongly-typed (type-safe but requires full object)
var typedItem = await container.ReadItemAsync<TodoItem>("perf-typed", new PartitionKey("test"));
typedItem.Resource.Title = "Updated";
await container.ReplaceItemAsync(typedItem.Resource, "perf-typed", new PartitionKey("test"));
stopwatch.Stop();
Console.WriteLine($"Strongly-typed replace: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 2. Patch operation (most efficient for partial updates)
await container.PatchItemAsync<TodoItem>(
    "perf-typed", 
    new PartitionKey("test"),
    new[] { PatchOperation.Replace("/title", "Patched") });
stopwatch.Stop();
Console.WriteLine($"Patch operation: {stopwatch.ElapsedMilliseconds}ms");

stopwatch.Restart();

// 3. JSON stream replace (fastest for full updates, no serialization)
string jsonUpdate = """{"id": "perf-json", "partitionKey": "test", "title": "JSON Updated"}""";
using var stream = new MemoryStream(Encoding.UTF8.GetBytes(jsonUpdate));
await container.ReplaceItemStreamAsync(stream, "perf-json", new PartitionKey("test"));
stopwatch.Stop();
Console.WriteLine($"Raw JSON replace: {stopwatch.ElapsedMilliseconds}ms");
```

### Delete

```csharp
// Delete an item
try
{
    await container.DeleteItemAsync<TodoItem>(
        "task-1", 
        new PartitionKey("personal"));
    
    Console.WriteLine("Item deleted successfully");
}
catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
{
    Console.WriteLine("Item not found");
}

// Delete with optimistic concurrency
string etag = "\"00000000-0000-0000-0000-000000000000\""; // ETag from previous read
ItemRequestOptions deleteOptions = new ItemRequestOptions
{
    IfMatchEtag = etag
};

await container.DeleteItemAsync<TodoItem>(
    "task-1", 
    new PartitionKey("personal"),
    deleteOptions);
```

## Advanced Patterns

### Bulk Operations

For high-throughput scenarios, Cosmos DB provides bulk operations through parallel tasks:

```csharp
// Prepare items to create
List<TodoItem> itemsToCreate = new List<TodoItem>();
for (int i = 1; i <= 100; i++)
{
    itemsToCreate.Add(new TodoItem
    {
        Id = $"bulk-task-{i}",
        PartitionKey = "bulk",
        Title = $"Bulk created item {i}",
        Completed = false
    });
}

// Create a list of tasks for parallel execution
List<Task> concurrentTasks = new List<Task>();
foreach (var item in itemsToCreate)
{
    concurrentTasks.Add(container.CreateItemAsync(
        item, 
        new PartitionKey(item.PartitionKey))
        .ContinueWith(itemTask =>
        {
            if (itemTask.IsCompletedSuccessfully)
            {
                ItemResponse<TodoItem> response = itemTask.Result;
                Console.WriteLine($"Created item {item.Id}: {response.RequestCharge} RUs");
            }
            else
            {
                AggregateException exceptions = itemTask.Exception;
                Console.WriteLine($"Failed to create item {item.Id}: {exceptions.InnerException.Message}");
            }
        }));
}

// Wait for all operations to complete
await Task.WhenAll(concurrentTasks);
```

### Change Feed Processing

The Change Feed is a powerful feature that provides a log of all changes to your containers:

```csharp
// 1. Basic change feed processor
Container leaseContainer = await database.CreateContainerIfNotExistsAsync(
    "leases", 
    "/id", 
    400);

var changeFeedProcessor = container.GetChangeFeedProcessorBuilder<TodoItem>(
    processorName: "todoChanges",
    onChangesDelegate: HandleChangesAsync)
    .WithInstanceName("workerInstance1")
    .WithLeaseContainer(leaseContainer)
    .Build();

await changeFeedProcessor.StartAsync();

// Handle changes
async Task HandleChangesAsync(
    ChangeFeedProcessorContext context, 
    IReadOnlyCollection<TodoItem> changes, 
    CancellationToken cancellationToken)
{
    Console.WriteLine($"Detected {changes.Count} document changes");
    foreach (TodoItem item in changes)
    {
        Console.WriteLine($"Changed item: {item.Id}, Title: {item.Title}");
        // Process changes - update cache, trigger workflows, etc.
    }
}

// Later - stop the processor
await changeFeedProcessor.StopAsync();
```

### Server-Side Programming

CosmosDB supports stored procedures, triggers, and UDFs for server-side logic:

```csharp
// 1. Create a stored procedure
string sprocId = "createTodoItem";
string sprocBody = @"
function createTodoItem(itemBody) {
    var context = getContext();
    var container = context.getCollection();
    var response = context.getResponse();
    
    // Generate ID if not provided
    if (!itemBody.id) {
        itemBody.id = generateGuid();
    }
    
    // Add creation timestamp
    itemBody.createdAt = new Date().toISOString();
    
    // Create document
    var accepted = container.createDocument(
        container.getSelfLink(),
        itemBody,
        function(err, documentCreated) {
            if (err) throw new Error('Error: ' + err.message);
            response.setBody(documentCreated);
        }
    );
    
    if (!accepted) throw new Error('The item create was not accepted');
    
    function generateGuid() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }
}";

StoredProcedureResponse response = await container.Scripts.CreateStoredProcedureAsync(
    new StoredProcedureProperties
    {
        Id = sprocId,
        Body = sprocBody
    });

// 2. Execute a stored procedure
dynamic todoItem = new
{
    partitionKey = "personal",
    title = "Learn about stored procedures",
    completed = false
};

StoredProcedureExecuteResponse<dynamic> executeResponse = await container.Scripts.ExecuteStoredProcedureAsync<dynamic>(
    sprocId,
    new PartitionKey("personal"),
    new[] { todoItem });

dynamic createdItem = executeResponse.Resource;
Console.WriteLine($"Created item ID: {createdItem.id}");
```

### Retry Policies

The Cosmos SDK has built-in retry policies, but you can customize them:

```csharp
// Custom retry policy for handling rate limiting (429) errors
CosmosClientOptions options = new CosmosClientOptions
{
    MaxRetryAttemptsOnRateLimitedRequests = 9,
    MaxRetryWaitTimeOnRateLimitedRequests = TimeSpan.FromSeconds(30)
};

var cosmosClient = new CosmosClient(endpoint, key, options);
```

For more complex scenarios, you can use Polly:

```csharp
using Polly;

// Define policy
var retryPolicy = Policy
    .Handle<CosmosException>(ex => ex.StatusCode == HttpStatusCode.TooManyRequests)
    .WaitAndRetryAsync(
        retryCount: 5,
        sleepDurationProvider: (attempt) => TimeSpan.FromSeconds(Math.Pow(2, attempt)),
        onRetry: (exception, timespan, retryCount, context) =>
        {
            Console.WriteLine($"Retry {retryCount} after {timespan.TotalSeconds}s due to {exception.Message}");
        });

// Execute with policy
await retryPolicy.ExecuteAsync(async () =>
{
    await container.CreateItemAsync(
        newItem, 
        new PartitionKey(newItem.PartitionKey));
});
```

### Dependency Injection Setup

```csharp
// Program.cs or Startup.cs
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.DependencyInjection;

public void ConfigureServices(IServiceCollection services)
{
    // Register CosmosClient as singleton
    services.AddSingleton(serviceProvider =>
    {
        var configuration = serviceProvider.GetRequiredService<IConfiguration>();
        return new CosmosClient(
            configuration["CosmosDb:EndpointUrl"], 
            configuration["CosmosDb:PrimaryKey"],
            new CosmosClientOptions
            {
                SerializerOptions = new CosmosSerializationOptions
                {
                    PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
                }
            });
    });
    
    // Register database and container clients
    services.AddSingleton(serviceProvider =>
    {
        var cosmosClient = serviceProvider.GetRequiredService<CosmosClient>();
        return cosmosClient.GetDatabase("MyDatabase");
    });
    
    services.AddSingleton(serviceProvider =>
    {
        var database = serviceProvider.GetRequiredService<Database>();
        return database.GetContainer("TodoItems");
    });
    
    // Register your services
    services.AddScoped<ITodoService, TodoService>();
}

// Service implementation
public interface ITodoService
{
    Task<TodoItem> GetItemAsync(string id, string partitionKey);
    Task<IEnumerable<TodoItem>> GetIncompleteItemsAsync(string partitionKey);
    Task<TodoItem> CreateItemAsync(TodoItem item);
    Task UpdateItemAsync(TodoItem item);
    Task DeleteItemAsync(string id, string partitionKey);
}

public class TodoService : ITodoService
{
    private readonly Container _container;
    
    public TodoService(Container container)
    {
        _container = container;
    }
    
    public async Task<TodoItem> GetItemAsync(string id, string partitionKey)
    {
        try
        {
            var response = await _container.ReadItemAsync<TodoItem>(
                id, 
                new PartitionKey(partitionKey));
                
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
        {
            return null;
        }
    }
    
    public async Task<IEnumerable<TodoItem>> GetIncompleteItemsAsync(string partitionKey)
    {
        var query = new QueryDefinition(
            "SELECT * FROM c WHERE c.partitionKey = @pk AND c.completed = false")
            .WithParameter("@pk", partitionKey);
            
        var results = new List<TodoItem>();
        
        var iterator = _container.GetItemQueryIterator<TodoItem>(
            query, 
            requestOptions: new QueryRequestOptions
            {
                PartitionKey = new PartitionKey(partitionKey)
            });
            
        while (iterator.HasMoreResults)
        {
            var response = await iterator.ReadNextAsync();
            results.AddRange(response);
        }
        
        return results;
    }
    
    public async Task<TodoItem> CreateItemAsync(TodoItem item)
    {
        var response = await _container.CreateItemAsync(
            item, 
            new PartitionKey(item.PartitionKey));
            
        return response.Resource;
    }
    
    // Additional methods...
}
```

## Authentication Approaches

Azure Cosmos DB supports multiple authentication methods, each with its own security characteristics and use cases:

### 1. **Primary Key Authentication (Connection String)**

```csharp
// Basic endpoint and key authentication
var endpoint = "https://your-account.documents.azure.com:443/";
var primaryKey = "your-primary-key";
var cosmosClient = new CosmosClient(endpoint, primaryKey);

// Alternative: Connection string
var connectionString = "AccountEndpoint=https://your-account.documents.azure.com:443/;AccountKey=your-primary-key;";
var cosmosClient = new CosmosClient(connectionString);
```

**Best for**: Development environments, simple applications, single-service scenarios.
**Security considerations**: Keys provide full access to the account and should be carefully protected.

### 2. **Azure Active Directory (AAD) Authentication**

```csharp
using Azure.Identity;

// Using Managed Identity
var credential = new DefaultAzureCredential();
var cosmosClient = new CosmosClient(endpoint, credential);

// Using Service Principal
var servicePrincipalCredential = new ClientSecretCredential(
    tenantId: "your-tenant-id",
    clientId: "your-client-id",
    clientSecret: "your-client-secret");
    
var cosmosClient = new CosmosClient(endpoint, servicePrincipalCredential);
```

**Best for**: Production environments, multi-service applications, Azure-hosted services.
**Security considerations**: No secrets in code, integrated with Azure RBAC, supports key rotation.

### 3. **Resource Token Authentication**

```csharp
// First, create a permission (typically on a server with master key)
var permissionResponse = await container.CreatePermissionAsync(
    new PermissionProperties
    {
        Id = "read-only-permission",
        PermissionMode = PermissionMode.Read,
        ResourceLink = container.Link,
        ResourcePartitionKey = new PartitionKey("user123")
    });

string resourceToken = permissionResponse.Resource.Token;

// On client side - use the limited resource token
var resourceTokenCosmosClient = new CosmosClient(
    endpoint,
    resourceToken,
    new CosmosClientOptions
    {
        ApplicationRegion = "West US 2"
    });
```

**Best for**: Client-side applications, multi-tenant scenarios, granular access control.
**Security considerations**: Fine-grained access control, short-lived tokens, limited to specific containers/partitions.

### Authentication Comparison

| Method | Security Level | Best For | Considerations |
|--------|--------------|----------|---------------|
| **Primary Key** | ⚠️ Basic | Development, Simple apps | Full account access, difficult to rotate |
| **AAD Authentication** | ✅ High | Production, Azure services | No secrets in code, easy to manage access |
| **Managed Identity** | ✅ Highest | Azure-hosted services | No secrets anywhere, automatic rotation |
| **Resource Tokens** | ✅ High | Client apps, Multi-tenant | Fine-grained, time-limited access |

### Best Practices

1. **Always use Managed Identity** for Azure-hosted applications
2. **Never store primary keys** in code or configuration files
3. **Use Azure Key Vault** to securely store connection strings when needed
4. **Apply Principle of Least Privilege** with resource tokens or RBAC
5. **Implement token caching** when using resource tokens
6. **Set up alerts** for unusual access patterns
7. **Regularly rotate keys** to limit exposure from potential leaks

## Migration from Legacy SDK

### Why Legacy SDKs Were Discontinued

The legacy `Microsoft.Azure.DocumentDB` SDK has been **deprecated and discontinued** for several important reasons:

#### **1. Architecture & Design Issues**
- **Callback-Based Patterns**: The legacy SDK was designed around callback patterns predating modern async/await
- **Inadequate Error Handling**: Limited status code mapping and retry policies
- **Complex Object Model**: Overly complex inheritance chains and abstractions

#### **2. Modern Development Standards**
- **Async/Await Patterns**: Modern applications require efficient async operations from the ground up
- **Performance**: Legacy SDK had performance bottlenecks and inefficient memory usage
- **Target Framework Support**: Limited support for newer .NET versions and .NET Core

#### **3. Service Evolution**
- **New Features**: Legacy SDK couldn't support newer features like change feed, bulk operations, and AAD auth
- **Consistency**: Microsoft moved to consistent Azure SDK guidelines across all services
- **Maintenance**: Supporting multiple SDKs was inefficient and led to inconsistencies

### Key Differences Between Libraries

| Feature | `Microsoft.Azure.DocumentDB` (Legacy) | `Microsoft.Azure.Cosmos` (Current) |
|---------|----------------------------------------|-------------------------------|
| **Status** | ❌ Deprecated | ✅ Active & Recommended |
| **API Design** | Callback-heavy, less intuitive | Modern async/await patterns |
| **Object Model** | Complex inheritance hierarchy | Simpler, more intuitive API |
| **Performance** | Less optimized | Better throughput and latency |
| **Bulk Operations** | Limited support | Native support |
| **Authentication** | Primary key only | AAD, Managed Identity, Resource Tokens |
| **.NET Core Support** | Limited | Full support |
| **Change Feed** | Basic | Comprehensive processor framework |
| **Server-Side** | Complex | Simplified API |
| **Serialization** | Custom JSON serializer | Newtonsoft.Json or System.Text.Json |
| **Diagnostics** | Limited | Rich diagnostics and metrics |

### Migration Steps & Code Changes

If you're migrating from the legacy `Microsoft.Azure.DocumentDB` SDK:

#### **1. Update Package References**
```xml
<!-- REMOVE legacy package -->
<!-- <PackageReference Include="Microsoft.Azure.DocumentDB" Version="2.x.x" /> -->

<!-- ADD modern package -->
<PackageReference Include="Microsoft.Azure.Cosmos" Version="3.37.0" />
```

#### **2. Update Namespace Imports**
```csharp
// OLD namespaces
// using Microsoft.Azure.Documents;
// using Microsoft.Azure.Documents.Client;

// NEW namespace
using Microsoft.Azure.Cosmos;
```

#### **3. Update Client Initialization**
```csharp
// OLD - DocumentDB
/*
DocumentClient client = new DocumentClient(
    new Uri("https://your-account.documents.azure.com:443/"),
    "your-primary-key");
await client.OpenAsync();
*/

// NEW - Cosmos SDK
CosmosClient cosmosClient = new CosmosClient(
    "https://your-account.documents.azure.com:443/",
    "your-primary-key");
```

#### **4. Update Database/Container Access**
```csharp
// OLD - DocumentDB
/*
Database database = await client.CreateDatabaseIfNotExistsAsync(
    new Database { Id = "MyDatabase" });

DocumentCollection collection = await client.CreateDocumentCollectionIfNotExistsAsync(
    UriFactory.CreateDatabaseUri("MyDatabase"),
    new DocumentCollection { Id = "MyCollection" },
    new RequestOptions { OfferThroughput = 400 });
*/

// NEW - Cosmos SDK
Database database = await cosmosClient.CreateDatabaseIfNotExistsAsync("MyDatabase");

Container container = await database.CreateContainerIfNotExistsAsync(
    id: "MyContainer",
    partitionKeyPath: "/partitionKey", 
    throughput: 400);
```

#### **5. Update CRUD Operations**
```csharp
// OLD - Create
/*
Document document = await client.CreateDocumentAsync(
    UriFactory.CreateDocumentCollectionUri("MyDatabase", "MyCollection"),
    new { id = "item1", name = "Item 1", partitionKey = "pk1" });
*/

// NEW - Create
ItemResponse<dynamic> response = await container.CreateItemAsync<dynamic>(
    new { id = "item1", name = "Item 1", partitionKey = "pk1" },
    new PartitionKey("pk1"));

// OLD - Read
/*
Document document = await client.ReadDocumentAsync(
    UriFactory.CreateDocumentUri("MyDatabase", "MyCollection", "item1"),
    new RequestOptions { PartitionKey = new PartitionKey("pk1") });
*/

// NEW - Read
ItemResponse<dynamic> response = await container.ReadItemAsync<dynamic>(
    "item1", 
    new PartitionKey("pk1"));

// OLD - Query
/*
FeedOptions options = new FeedOptions { EnableCrossPartitionQuery = true };
IDocumentQuery<dynamic> query = client.CreateDocumentQuery<dynamic>(
    UriFactory.CreateDocumentCollectionUri("MyDatabase", "MyCollection"),
    "SELECT * FROM c WHERE c.name = 'Item 1'", 
    options)
    .AsDocumentQuery();
    
while (query.HasMoreResults)
{
    FeedResponse<dynamic> results = await query.ExecuteNextAsync<dynamic>();
    foreach (var item in results)
    {
        Console.WriteLine(item.name);
    }
}
*/

// NEW - Query
QueryDefinition queryDefinition = new QueryDefinition(
    "SELECT * FROM c WHERE c.name = 'Item 1'");
    
FeedIterator<dynamic> resultSet = container.GetItemQueryIterator<dynamic>(
    queryDefinition,
    requestOptions: new QueryRequestOptions
    {
        MaxItemCount = 10
    });
    
while (resultSet.HasMoreResults)
{
    FeedResponse<dynamic> response = await resultSet.ReadNextAsync();
    foreach (var item in response)
    {
        Console.WriteLine(item.name);
    }
}
```

### Migration Benefits

Moving to `Microsoft.Azure.Cosmos` provides:

✅ **Better Performance** - Optimized for modern async patterns  
✅ **Advanced Features** - Support for bulk operations, change feed processor, AAD auth  
✅ **Improved Error Handling** - Detailed exceptions with diagnostic info  
✅ **Enhanced Diagnostics** - Better visibility into RU consumption and performance  
✅ **Future-Proof** - Active development and feature updates  
✅ **Better Development Experience** - More intuitive API design  

### Timeline & Support

| SDK | Last Update | Support Status | Recommendation |
|-----|-------------|----------------|----------------|
| `Microsoft.Azure.DocumentDB` | March 2020 | ❌ Deprecated | Migrate immediately |
| `Microsoft.Azure.Cosmos` | Current | ✅ Active Development | ✅ Use for all new projects |

> **⚠️ Important**: Microsoft will not provide security updates or bug fixes for legacy SDKs. Migration to `Microsoft.Azure.Cosmos` is strongly recommended for security and compatibility reasons.

## Useful Resources

- **Official Documentation**: [Azure Cosmos DB Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/)<br>
  Comprehensive documentation covering Azure Cosmos DB concepts, capabilities, APIs, and service-level features. Essential for understanding provisioning models, consistency levels, indexing policies, and architectural considerations for designing Cosmos DB solutions.

- **SDK Reference**: [Microsoft.Azure.Cosmos SDK Reference](https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.cosmos)<br>
  Complete API reference documentation for the Microsoft.Azure.Cosmos SDK, including all classes, methods, properties, and their signatures. Critical development resource for understanding method parameters, return types, exceptions, and proper usage patterns when writing Cosmos DB applications.

- **Code Samples**: [Azure Cosmos DB .NET SDK Samples](https://github.com/Azure/azure-cosmos-dotnet-v3/tree/master/Microsoft.Azure.Cosmos.Samples)<br>
  Official code samples demonstrating real-world implementation patterns, performance optimization techniques, and advanced scenarios like change feed processing and bulk operations. Provides practical examples of best practices, error handling, and common use cases.

- **Performance Tips**: [Performance Tips for Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/performance-tips-dotnet-sdk)<br>
  Expert guidance on optimizing your applications for maximum performance and cost-efficiency with Azure Cosmos DB, including connection management, query optimization, indexing strategies, and RU optimization techniques to ensure your applications run efficiently.

- **Migration Guide**: [Migrating from DocumentDB SDK to Cosmos DB SDK](https://github.com/Azure/azure-cosmos-dotnet-v3/blob/master/Microsoft.Azure.Cosmos/MIGRATE.md)<br>
  Detailed migration guide for transitioning from the legacy Microsoft.Azure.DocumentDB SDK to the modern Microsoft.Azure.Cosmos SDK, with code comparisons, breaking change explanations, and step-by-step migration strategies.

## Summary

The **Microsoft.Azure.Cosmos** SDK is the recommended approach for accessing Azure Cosmos DB from C#. It provides:

- ✅ Modern async/await patterns for responsive applications
- ✅ Comprehensive support for all Cosmos DB SQL API features
- ✅ Better performance and throughput optimization
- ✅ Built-in retry logic and error handling
- ✅ Support for AAD and managed identity authentication
- ✅ Rich diagnostic information for monitoring and troubleshooting
- ✅ Optimized bulk operations for high-throughput scenarios
- ✅ Simplified change feed processing

Azure Cosmos DB offers a globally distributed, multi-model database service with comprehensive SLAs for throughput, latency, availability, and consistency, making it ideal for modern cloud applications requiring global scale and low latency.