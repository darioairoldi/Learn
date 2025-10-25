---
title: "Azure Blob Storage Access Approaches with C#"
description: "Comprehensive guide covering available approaches and libraries for accessing Azure Blob Storage using C#"
author: "Dario Airoldi"
date-modified: last-modified
categories: [azure, blob-storage, csharp, sdk]
format:
  html:
    toc: true
    toc-depth: 3
---

## Overview
**Azure Blob Storage** is Microsoft's object storage solution for the cloud, providing **massively scalable and secure storage** for unstructured data such as documents, media files, backups, and application data.<br> This guide covers the available approaches and libraries for accessing Azure Blob Storage using C#.

## Table of Contents

1. [📋 Overview](#overview)
2. [🚀 Available Approaches](#available-approaches)
   - [Azure.Storage.Blobs SDK (Recommended)](#1-azurestorageblobs-sdk-recommended)
   - [REST API Direct Access](#2-rest-api-direct-access)
   - [Legacy Approaches (Deprecated)](#3-legacy-approaches-deprecated)
3. [📦 Key Libraries](#key-libraries)
   - [Primary Library](#primary-library)
   - [Supporting Libraries (Optional)](#supporting-libraries-optional)
4. [⚙️ Basic Operations](#basic-operations)
   - [Setting Up Blob Storage Clients](#setting-up-blob-storage-clients)
   - [Client Architecture Overview](#client-architecture-overview)
5. [🔄 CRUD Operations](#crud-operations)
   - [Create (Upload)](#create-upload)
   - [Read (Download)](#read-download) 
   - [Update (Overwrite/Modify)](#update-overwritemodify)
   - [Delete](#delete)
6. [🎯 Advanced Patterns](#advanced-patterns)
   - [Batch Operations](#batch-operations)
   - [Streaming Operations](#streaming-operations)
   - [Conditional Operations](#conditional-operations)
   - [Dependency Injection Setup](#dependency-injection-setup)
7. [🔐 Authentication Approaches](#authentication-approaches)
   - [Managed Identity (Recommended)](#1-managed-identity-recommended)
   - [Connection String](#2-connection-string)
   - [Shared Access Signature (SAS)](#3-shared-access-signature-sas)
   - [Account Key (Not Recommended)](#4-account-key-not-recommended)
8. [✅ Best Practices](#best-practices)
   - [Security](#1-security)
   - [Performance](#2-performance)
   - [Reliability](#3-reliability)
   - [Cost Optimization](#4-cost-optimization)
9. [🔄 Migration from Legacy SDK](#migration-from-legacy-sdk)
   - [From WindowsAzure.Storage](#from-windowsazurestorage)
   - [From Microsoft.Azure.Storage](#from-microsoftazurestorage)
   - [Migration Checklist](#migration-checklist)
10. [📚 References](#references)

## Available Approaches

### 1. **Azure.Storage.Blobs SDK (Recommended)** 
- **Current unified SDK** for Azure Blob Storage with modern design
- Supports .NET 6+, .NET Core, .NET Framework 4.6.1+
- **Async-first** design with excellent performance
- Built-in retry policies and resilience patterns
- **NuGet Package**: `Azure.Storage.Blobs`

### 2. **REST API Direct Access**
- Direct HTTP calls to Azure Blob Storage REST endpoints
- Maximum flexibility and control
- Requires manual implementation of authentication, retries, and error handling
- Useful for non-.NET environments or specialized scenarios

### 3. **Legacy Approaches (Deprecated)**
- **WindowsAzure.Storage** - Original SDK (discontinued)
- **Microsoft.Azure.Storage** - Legacy SDK (deprecated October 2024)
- **Microsoft.WindowsAzure.Storage** - Classic SDK (retired)

**⚠️ Important**: Legacy SDKs should not be used for new projects and existing applications should migrate to `Azure.Storage.Blobs`.

## Key Libraries

### Primary Library
```xml
<PackageReference Include="Azure.Storage.Blobs" Version="12.21.2" />
```

### Supporting Libraries (Optional)
```xml
<!-- For dependency injection -->
<PackageReference Include="Microsoft.Extensions.DependencyInjection" Version="8.0.0" />
<PackageReference Include="Microsoft.Extensions.Configuration" Version="8.0.0" />

<!-- For managed identity authentication -->
<PackageReference Include="Azure.Identity" Version="1.12.0" />

<!-- For advanced data movement operations -->
<PackageReference Include="Azure.Storage.DataMovement.Blobs" Version="12.0.0-beta.6" />
```

## Basic Operations

### Setting Up Blob Storage Clients

**The Azure.Storage.Blobs SDK** provides three main client types for different levels of operations:

#### Client Architecture Overview

| Client Type | **BlobServiceClient** | **BlobContainerClient** | **BlobClient** |
|-------------|----------------------|-------------------------|----------------|
| **Scope** | Entire storage account | Single container | Single blob |
| **Operations** | Account-level management | Container and blob operations | Blob-specific operations |
| **Use Cases** | List containers, account properties | Upload, download, list blobs | Read, write, delete specific blob |
| **Authentication** | Account-level permissions | Container-level permissions | Blob-level permissions |

#### BlobServiceClient (Account-Level Operations)

**BlobServiceClient** manages storage account-level operations and serves as the entry point for accessing containers and blobs.

```csharp
using Azure.Storage.Blobs;
using Azure.Identity;

// Using Managed Identity (recommended)
var credential = new DefaultAzureCredential();
var serviceClient = new BlobServiceClient(
    new Uri("https://yourstorageaccount.blob.core.windows.net/"), 
    credential);

// Account-level operations
await foreach (var container in serviceClient.GetBlobContainersAsync())
{
    Console.WriteLine($"Container: {container.Name}");
}

// Get account properties
var properties = await serviceClient.GetPropertiesAsync();
Console.WriteLine($"Account type: {properties.Value.AccountKind}");
```

#### BlobContainerClient (Container Operations)

**BlobContainerClient** handles container-specific operations and blob management within a container.

```csharp
// Get container client from service client
var containerClient = serviceClient.GetBlobContainerClient("mycontainer");

// Or create directly
var containerClient2 = new BlobContainerClient(
    new Uri("https://yourstorageaccount.blob.core.windows.net/mycontainer"),
    credential);

// Ensure container exists
await containerClient.CreateIfNotExistsAsync();

// Container operations
var properties = await containerClient.GetPropertiesAsync();
Console.WriteLine($"Container created: {properties.Value.CreatedOn}");

// List blobs in container
await foreach (var blobItem in containerClient.GetBlobsAsync())
{
    Console.WriteLine($"Blob: {blobItem.Name} ({blobItem.Properties.ContentLength} bytes)");
}
```

#### BlobClient (Blob Operations)

**BlobClient** handles individual blob operations like upload, download, and metadata management.

```csharp
// Get blob client from container client
var blobClient = containerClient.GetBlobClient("myfile.txt");

// Or create directly
var blobClient2 = new BlobClient(
    new Uri("https://yourstorageaccount.blob.core.windows.net/mycontainer/myfile.txt"),
    credential);

// Check if blob exists
bool exists = await blobClient.ExistsAsync();
Console.WriteLine($"Blob exists: {exists}");

// Get blob properties
if (exists)
{
    var properties = await blobClient.GetPropertiesAsync();
    Console.WriteLine($"Blob size: {properties.Value.ContentLength} bytes");
    Console.WriteLine($"Content type: {properties.Value.ContentType}");
    Console.WriteLine($"Last modified: {properties.Value.LastModified}");
}
```

### How Azure.Storage.Blobs Works

The `Azure.Storage.Blobs` SDK abstracts the complexity of direct HTTP REST API calls by:

1. **REST API Foundation**: All operations translate to HTTP requests to Azure Blob Storage REST endpoints:
   - `GET` requests for download and list operations
   - `PUT` requests for upload and create operations
   - `POST` requests for batch operations
   - `DELETE` requests for delete operations

2. **Authentication Handling**: Automatically manages authentication headers (Azure AD tokens, SAS tokens, or account keys) for each REST call

3. **Serialization/Deserialization**: Handles conversion between .NET objects and JSON/XML used by the REST API

4. **Error Translation**: Transforms HTTP status codes into meaningful .NET exceptions with proper error messages

5. **Connection Management**: Implements HTTP connection pooling, timeouts, and retry logic

#### Key Benefits

- **Type Safety**: Strongly-typed operations instead of raw HTTP calls
- **Async Support**: Native async/await patterns for non-blocking operations
- **Built-in Retry**: Automatic retry logic with exponential backoff
- **Performance**: Optimized HTTP client with connection pooling
- **Cross-Platform**: Works on .NET 6+, .NET Core, and .NET Framework

## CRUD Operations

### Create (Upload)

Azure Blob Storage supports multiple upload approaches for different scenarios:

#### 1. Upload from File

```csharp
// Upload a local file
string localFilePath = @"C:\temp\document.pdf";
string blobName = "documents/document.pdf";

var blobClient = containerClient.GetBlobClient(blobName);

// Simple upload with overwrite
await blobClient.UploadAsync(localFilePath, overwrite: true);

// Upload with options
var uploadOptions = new BlobUploadOptions
{
    HttpHeaders = new BlobHttpHeaders 
    { 
        ContentType = "application/pdf",
        ContentLanguage = "en-US"
    },
    Metadata = new Dictionary<string, string>
    {
        ["UploadedBy"] = "MyApplication",
        ["UploadDate"] = DateTime.UtcNow.ToString("O")
    },
    Conditions = new BlobRequestConditions
    {
        IfNoneMatch = ETag.All // Only upload if blob doesn't exist
    }
};

await blobClient.UploadAsync(localFilePath, uploadOptions);
```

#### 2. Upload from Stream

```csharp
// Upload from memory stream
string content = "Hello, Azure Blob Storage!";
using var stream = new MemoryStream(Encoding.UTF8.GetBytes(content));

var blobClient = containerClient.GetBlobClient("messages/greeting.txt");

await blobClient.UploadAsync(stream, new BlobHttpHeaders 
{ 
    ContentType = "text/plain; charset=utf-8" 
});

// Upload large stream with progress tracking
using var fileStream = File.OpenRead(@"C:\temp\largefile.zip");
var progress = new Progress<long>(bytesUploaded =>
{
    Console.WriteLine($"Uploaded {bytesUploaded:N0} bytes");
});

await blobClient.UploadAsync(fileStream, new BlobUploadOptions
{
    ProgressHandler = progress,
    TransferOptions = new StorageTransferOptions
    {
        MaximumConcurrency = 4,
        InitialTransferSize = 1024 * 1024, // 1 MB
        MaximumTransferSize = 4 * 1024 * 1024 // 4 MB
    }
});
```

#### 3. Upload Binary Data

```csharp
// Upload byte array
byte[] data = File.ReadAllBytes(@"C:\temp\image.jpg");
var blobClient = containerClient.GetBlobClient("images/photo.jpg");

await blobClient.UploadAsync(new BinaryData(data), new BlobHttpHeaders
{
    ContentType = "image/jpeg"
});
```

#### 4. Upload with Access Tiers

```csharp
// Upload directly to Cool tier for cost optimization
await blobClient.UploadAsync(localFilePath, new BlobUploadOptions
{
    AccessTier = AccessTier.Cool,
    HttpHeaders = new BlobHttpHeaders { ContentType = "application/pdf" }
});

// Upload to Archive tier (lowest cost, highest access time)
await blobClient.UploadAsync(localFilePath, new BlobUploadOptions
{
    AccessTier = AccessTier.Archive
});
```

### Read (Download)

#### 1. Download to File

```csharp
string blobName = "documents/report.pdf";
string localPath = @"C:\downloads\report.pdf";

var blobClient = containerClient.GetBlobClient(blobName);

// Check if blob exists before downloading
if (await blobClient.ExistsAsync())
{
    // Simple download
    await blobClient.DownloadToAsync(localPath);
    
    // Download with progress tracking
    var progress = new Progress<long>(bytesDownloaded =>
    {
        Console.WriteLine($"Downloaded {bytesDownloaded:N0} bytes");
    });
    
    await blobClient.DownloadToAsync(localPath, new BlobDownloadToOptions
    {
        ProgressHandler = progress,
        TransferOptions = new StorageTransferOptions
        {
            MaximumConcurrency = 4
        }
    });
}
```

#### 2. Download to Stream

```csharp
var blobClient = containerClient.GetBlobClient("data/config.json");

// Download to memory stream
using var stream = new MemoryStream();
await blobClient.DownloadToAsync(stream);

// Read content as string
stream.Position = 0;
using var reader = new StreamReader(stream);
string content = await reader.ReadToEndAsync();
Console.WriteLine(content);
```

#### 3. Download Content as String/Binary

```csharp
var blobClient = containerClient.GetBlobClient("messages/note.txt");

// Download as BinaryData
BinaryData data = await blobClient.DownloadContentAsync();
string content = data.ToString();

// Download with response (includes metadata and properties)
var response = await blobClient.DownloadContentAsync();
string text = response.Value.Content.ToString();
var metadata = response.Value.Details.Metadata;
var contentType = response.Value.Details.ContentType;

Console.WriteLine($"Content: {text}");
Console.WriteLine($"Content Type: {contentType}");
Console.WriteLine($"Metadata count: {metadata.Count}");
```

#### 4. Conditional Downloads

```csharp
var blobClient = containerClient.GetBlobClient("documents/cached-report.pdf");

try
{
    // Only download if modified since last check
    var lastCheckTime = DateTime.UtcNow.AddHours(-1);
    var response = await blobClient.DownloadContentAsync(new BlobDownloadOptions
    {
        Conditions = new BlobRequestConditions
        {
            IfModifiedSince = lastCheckTime
        }
    });
    
    Console.WriteLine("Blob was modified, downloaded new version");
}
catch (RequestFailedException ex) when (ex.Status == 304)
{
    Console.WriteLine("Blob not modified since last check");
}
```

#### 5. Partial Downloads (Range Reads)

```csharp
var blobClient = containerClient.GetBlobClient("large-files/dataset.csv");

// Download first 1KB only
var range = new HttpRange(0, 1024);
var response = await blobClient.DownloadStreamingAsync(new BlobDownloadOptions
{
    Range = range
});

using var stream = response.Value.Content;
// Process first 1KB of the file
```

### Update (Overwrite/Modify)

#### 1. Overwrite Blob Content

```csharp
var blobClient = containerClient.GetBlobClient("config/settings.json");

// Simple overwrite
string newContent = JsonSerializer.Serialize(new { setting1 = "value1" });
await blobClient.UploadAsync(BinaryData.FromString(newContent), overwrite: true);

// Conditional overwrite (only if blob exists and has specific ETag)
try
{
    var properties = await blobClient.GetPropertiesAsync();
    await blobClient.UploadAsync(
        BinaryData.FromString(newContent), 
        new BlobUploadOptions
        {
            Conditions = new BlobRequestConditions
            {
                IfMatch = properties.Value.ETag // Only update if ETag matches
            }
        });
}
catch (RequestFailedException ex) when (ex.Status == 412)
{
    Console.WriteLine("Blob was modified by another process");
}
```

#### 2. Update Metadata Only

```csharp
var blobClient = containerClient.GetBlobClient("images/photo.jpg");

// Update metadata without changing blob content
var metadata = new Dictionary<string, string>
{
    ["ProcessedBy"] = Environment.MachineName,
    ["ProcessedAt"] = DateTime.UtcNow.ToString("O"),
    ["Version"] = "2.0"
};

await blobClient.SetMetadataAsync(metadata);
```

#### 3. Update Properties and Headers

```csharp
var blobClient = containerClient.GetBlobClient("documents/manual.pdf");

// Update HTTP headers
var headers = new BlobHttpHeaders
{
    ContentType = "application/pdf",
    ContentLanguage = "en-US",
    ContentDisposition = "attachment; filename=user-manual.pdf",
    CacheControl = "public, max-age=31536000" // Cache for 1 year
};

await blobClient.SetHttpHeadersAsync(headers);
```

#### 4. Change Access Tier

```csharp
var blobClient = containerClient.GetBlobClient("archives/old-data.zip");

// Move to Archive tier for cost savings
await blobClient.SetAccessTierAsync(AccessTier.Archive);

// Move back to Hot tier for frequent access
await blobClient.SetAccessTierAsync(AccessTier.Hot);
```

### Delete

#### 1. Simple Blob Deletion

```csharp
var blobClient = containerClient.GetBlobClient("temp/temp-file.txt");

// Delete blob if it exists
var deleteResponse = await blobClient.DeleteIfExistsAsync();
if (deleteResponse.Value)
{
    Console.WriteLine("Blob deleted successfully");
}
else
{
    Console.WriteLine("Blob does not exist");
}

// Delete with conditions
await blobClient.DeleteAsync(DeleteSnapshotsOption.IncludeSnapshots, 
    conditions: new BlobRequestConditions
    {
        IfUnmodifiedSince = DateTime.UtcNow.AddDays(-1)
    });
```

#### 2. Delete with Snapshot Handling

```csharp
var blobClient = containerClient.GetBlobClient("important/document.docx");

// Delete only if no snapshots exist
try
{
    await blobClient.DeleteAsync();
}
catch (RequestFailedException ex) when (ex.ErrorCode == "SnapshotsPresent")
{
    // Delete blob and all its snapshots
    await blobClient.DeleteAsync(DeleteSnapshotsOption.IncludeSnapshots);
}
```

#### 3. Soft Delete Recovery

```csharp
// List deleted blobs (requires soft delete enabled on storage account)
var options = new BlobTraits { Metadata = true };
var states = new BlobStates { Deleted = true };

await foreach (var deletedBlob in containerClient.GetBlobsAsync(
    traits: options, states: states))
{
    Console.WriteLine($"Deleted blob: {deletedBlob.Name}, " +
                     $"Deleted on: {deletedBlob.Properties.DeletedOn}");
    
    // Undelete if needed
    var blobClient = containerClient.GetBlobClient(deletedBlob.Name);
    await blobClient.UndeleteAsync();
    Console.WriteLine($"Restored blob: {deletedBlob.Name}");
}
```

## Advanced Patterns

### Batch Operations

Azure Blob Storage supports efficient batch operations for processing multiple blobs:

#### 1. Batch Delete Operations

```csharp
// Batch delete multiple blobs
var blobsToDelete = new List<string> 
{ 
    "temp/file1.txt", 
    "temp/file2.txt", 
    "temp/file3.txt" 
};

var batchClient = serviceClient.GetBlobBatchClient();
var batch = batchClient.CreateBatch();

foreach (var blobName in blobsToDelete)
{
    var blobClient = containerClient.GetBlobClient(blobName);
    batch.DeleteBlob(blobClient.Uri);
}

// Execute batch operation
try
{
    await batchClient.SubmitBatchAsync(batch);
    Console.WriteLine($"Successfully deleted {blobsToDelete.Count} blobs");
}
catch (AggregateException ex)
{
    // Handle individual failures
    foreach (var innerEx in ex.InnerExceptions)
    {
        Console.WriteLine($"Failed to delete blob: {innerEx.Message}");
    }
}
```

#### 2. Batch Set Access Tier

```csharp
// Move multiple blobs to Cool tier
var blobNames = await GetOldBlobNames(containerClient); // Custom method

var batchClient = serviceClient.GetBlobBatchClient();
var batch = batchClient.CreateBatch();

foreach (var blobName in blobNames)
{
    var blobUri = new Uri($"{containerClient.Uri}/{blobName}");
    batch.SetBlobAccessTier(blobUri, AccessTier.Cool);
}

await batchClient.SubmitBatchAsync(batch);
Console.WriteLine($"Moved {blobNames.Count} blobs to Cool tier");
```

### Streaming Operations

#### 1. Streaming Upload for Large Files

```csharp
async Task UploadLargeFileAsync(string filePath, BlobClient blobClient)
{
    using var fileStream = File.OpenRead(filePath);
    
    var uploadOptions = new BlobUploadOptions
    {
        TransferOptions = new StorageTransferOptions
        {
            // Upload in parallel chunks
            MaximumConcurrency = Environment.ProcessorCount,
            // 8MB chunks for better throughput
            MaximumTransferSize = 8 * 1024 * 1024,
            // Start with 1MB initial transfer
            InitialTransferSize = 1024 * 1024
        },
        ProgressHandler = new Progress<long>(bytesUploaded =>
        {
            var percentage = (double)bytesUploaded / fileStream.Length * 100;
            Console.WriteLine($"Uploaded {percentage:F1}% ({bytesUploaded:N0}/{fileStream.Length:N0} bytes)");
        })
    };

    await blobClient.UploadAsync(fileStream, uploadOptions);
}
```

#### 2. Streaming Download with Processing

```csharp
async Task ProcessLargeFileStreamingAsync(BlobClient blobClient)
{
    var downloadInfo = await blobClient.DownloadStreamingAsync();
    using var stream = downloadInfo.Value.Content;
    
    // Process file in chunks without loading entire file into memory
    var buffer = new byte[1024 * 1024]; // 1MB buffer
    long totalBytesRead = 0;
    
    while (true)
    {
        int bytesRead = await stream.ReadAsync(buffer);
        if (bytesRead == 0) break;
        
        totalBytesRead += bytesRead;
        
        // Process chunk (e.g., hash calculation, parsing, etc.)
        ProcessChunk(buffer.AsSpan(0, bytesRead));
        
        Console.WriteLine($"Processed {totalBytesRead:N0} bytes");
    }
}

void ProcessChunk(ReadOnlySpan<byte> chunk)
{
    // Custom processing logic
    // Example: calculate hash, parse data, etc.
}
```

### Conditional Operations

#### 1. Optimistic Concurrency Control

```csharp
async Task UpdateBlobWithOptimisticConcurrency(BlobClient blobClient, string newContent)
{
    int maxRetries = 5;
    int retryCount = 0;
    
    while (retryCount < maxRetries)
    {
        try
        {
            // Get current ETag
            var properties = await blobClient.GetPropertiesAsync();
            var currentETag = properties.Value.ETag;
            
            // Update only if ETag hasn't changed
            await blobClient.UploadAsync(
                BinaryData.FromString(newContent),
                new BlobUploadOptions
                {
                    Conditions = new BlobRequestConditions
                    {
                        IfMatch = currentETag
                    }
                });
                
            Console.WriteLine("Blob updated successfully");
            return;
        }
        catch (RequestFailedException ex) when (ex.Status == 412) // Precondition Failed
        {
            retryCount++;
            Console.WriteLine($"Blob was modified by another process. Retry {retryCount}/{maxRetries}");
            
            if (retryCount >= maxRetries)
            {
                throw new InvalidOperationException("Failed to update blob after maximum retries due to concurrent modifications");
            }
            
            // Wait before retry with exponential backoff
            await Task.Delay(TimeSpan.FromMilliseconds(100 * Math.Pow(2, retryCount)));
        }
    }
}
```

#### 2. Conditional Operations Based on Last Modified

```csharp
// Only process if blob was modified in the last hour
var blobClient = containerClient.GetBlobClient("data/sensor-readings.json");
var oneHourAgo = DateTimeOffset.UtcNow.AddHours(-1);

try
{
    var response = await blobClient.DownloadContentAsync(new BlobDownloadOptions
    {
        Conditions = new BlobRequestConditions
        {
            IfModifiedSince = oneHourAgo
        }
    });
    
    // Process new data
    await ProcessSensorData(response.Value.Content.ToString());
}
catch (RequestFailedException ex) when (ex.Status == 304) // Not Modified
{
    Console.WriteLine("No new sensor data available");
}
```

### Dependency Injection Setup

#### 1. Basic Registration

```csharp
// In Program.cs or Startup.cs
using Azure.Identity;
using Azure.Storage.Blobs;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// Register BlobServiceClient with DI
builder.Services.AddSingleton<BlobServiceClient>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();
    var storageAccountName = configuration["Azure:StorageAccount:Name"];
    var accountUri = new Uri($"https://{storageAccountName}.blob.core.windows.net");
    
    return new BlobServiceClient(accountUri, new DefaultAzureCredential());
});

// Register typed clients for specific containers
builder.Services.AddSingleton<IDocumentStorageService, DocumentStorageService>();

var app = builder.Build();
```

#### 2. Advanced Configuration with Options Pattern

```csharp
// Configuration class
public class BlobStorageOptions
{
    public string ConnectionString { get; set; }
    public string AccountName { get; set; }
    public string DefaultContainer { get; set; }
    public bool UseManagedIdentity { get; set; }
}

// Service registration
builder.Services.Configure<BlobStorageOptions>(
    builder.Configuration.GetSection("BlobStorage"));

builder.Services.AddSingleton<BlobServiceClient>(provider =>
{
    var options = provider.GetRequiredService<IOptions<BlobStorageOptions>>().Value;
    
    if (options.UseManagedIdentity)
    {
        var accountUri = new Uri($"https://{options.AccountName}.blob.core.windows.net");
        return new BlobServiceClient(accountUri, new DefaultAzureCredential());
    }
    else
    {
        return new BlobServiceClient(options.ConnectionString);
    }
});

// Service implementation
public interface IDocumentStorageService
{
    Task<string> UploadDocumentAsync(Stream document, string fileName);
    Task<Stream> DownloadDocumentAsync(string fileName);
}

public class DocumentStorageService : IDocumentStorageService
{
    private readonly BlobContainerClient _containerClient;
    private readonly ILogger<DocumentStorageService> _logger;

    public DocumentStorageService(BlobServiceClient blobServiceClient, 
        IOptions<BlobStorageOptions> options, 
        ILogger<DocumentStorageService> logger)
    {
        _containerClient = blobServiceClient.GetBlobContainerClient(options.Value.DefaultContainer);
        _logger = logger;
    }

    public async Task<string> UploadDocumentAsync(Stream document, string fileName)
    {
        try
        {
            var blobClient = _containerClient.GetBlobClient(fileName);
            await blobClient.UploadAsync(document, overwrite: true);
            
            _logger.LogInformation("Document {FileName} uploaded successfully", fileName);
            return blobClient.Uri.ToString();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to upload document {FileName}", fileName);
            throw;
        }
    }

    public async Task<Stream> DownloadDocumentAsync(string fileName)
    {
        try
        {
            var blobClient = _containerClient.GetBlobClient(fileName);
            var response = await blobClient.DownloadStreamingAsync();
            
            _logger.LogInformation("Document {FileName} downloaded successfully", fileName);
            return response.Value.Content;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to download document {FileName}", fileName);
            throw;
        }
    }
}
```

## Authentication Approaches

### 1. **Managed Identity (Recommended)**

Managed Identity is the **most secure approach** for Azure-hosted applications, eliminating the need for stored credentials.

#### System-Assigned Managed Identity

```csharp
using Azure.Identity;
using Azure.Storage.Blobs;

// Simple approach - uses system-assigned managed identity
var credential = new DefaultAzureCredential();
var blobServiceClient = new BlobServiceClient(
    new Uri("https://mystorageaccount.blob.core.windows.net"),
    credential);

// Verify authentication
try
{
    var properties = await blobServiceClient.GetPropertiesAsync();
    Console.WriteLine($"Successfully authenticated to {properties.Value.AccountKind} storage account");
}
catch (AuthenticationFailedException ex)
{
    Console.WriteLine($"Authentication failed: {ex.Message}");
}
```

#### User-Assigned Managed Identity

```csharp
// Specify user-assigned managed identity
var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions
{
    ManagedIdentityClientId = "your-user-assigned-identity-client-id"
});

var blobServiceClient = new BlobServiceClient(
    new Uri("https://mystorageaccount.blob.core.windows.net"),
    credential);
```

#### Local Development with Azure CLI

```csharp
// For local development - uses Azure CLI credentials
var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions
{
    ExcludeEnvironmentCredential = true,
    ExcludeManagedIdentityCredential = true,
    ExcludeSharedTokenCacheCredential = true,
    ExcludeVisualStudioCredential = true,
    ExcludeVisualStudioCodeCredential = true,
    ExcludeAzureCliCredential = false, // Use Azure CLI
    ExcludeInteractiveBrowserCredential = true
});

var blobServiceClient = new BlobServiceClient(
    new Uri("https://mystorageaccount.blob.core.windows.net"),
    credential);
```

### 2. **Connection String**

Connection strings are simple but less secure than managed identity. Use only for development or when managed identity isn't available.

```csharp
// From configuration
var connectionString = configuration.GetConnectionString("AzureStorage");
var blobServiceClient = new BlobServiceClient(connectionString);

// Directly specified (not recommended for production)
var connectionString = "DefaultEndpointsProtocol=https;AccountName=mystorageaccount;AccountKey=base64key;EndpointSuffix=core.windows.net";
var blobServiceClient = new BlobServiceClient(connectionString);

// Get specific container
var containerClient = blobServiceClient.GetBlobContainerClient("mycontainer");
```

### 3. **Shared Access Signature (SAS)**

SAS tokens provide fine-grained, time-limited access to storage resources.

#### Using SAS Token

```csharp
// Create BlobServiceClient with SAS token
var sasToken = "?sv=2021-06-08&ss=b&srt=sco&sp=rwdlacupx&se=2024-12-31T23:59:59Z&st=2024-01-01T00:00:00Z&spr=https&sig=signature";
var accountUri = new Uri("https://mystorageaccount.blob.core.windows.net");
var sasUri = new Uri($"{accountUri}{sasToken}");

var blobServiceClient = new BlobServiceClient(sasUri);
```

#### Generating SAS Tokens

```csharp
// Generate container-level SAS token
var containerClient = new BlobContainerClient(connectionString, "mycontainer");

var sasBuilder = new BlobSasBuilder
{
    BlobContainerName = containerClient.Name,
    Resource = "c", // Container
    ExpiresOn = DateTimeOffset.UtcNow.AddHours(2),
    Protocol = SasProtocol.Https
};

// Set permissions
sasBuilder.SetPermissions(BlobContainerSasPermissions.Read | 
                         BlobContainerSasPermissions.Write |
                         BlobContainerSasPermissions.List);

// Generate the SAS token
string sasToken = sasBuilder.ToSasQueryParameters(
    new StorageSharedKeyCredential(accountName, accountKey)).ToString();

var sasUri = new Uri($"{containerClient.Uri}?{sasToken}");
```

#### Blob-Level SAS Token

```csharp
// Generate blob-specific SAS token
var blobClient = containerClient.GetBlobClient("document.pdf");

var sasBuilder = new BlobSasBuilder
{
    BlobContainerName = blobClient.BlobContainerName,
    BlobName = blobClient.Name,
    Resource = "b", // Blob
    ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(30)
};

sasBuilder.SetPermissions(BlobSasPermissions.Read);

string sasToken = sasBuilder.ToSasQueryParameters(
    new StorageSharedKeyCredential(accountName, accountKey)).ToString();

// Share this URL with clients for temporary access
string publicUrl = $"{blobClient.Uri}?{sasToken}";
```

### 4. **Account Key (Not Recommended)**

Account keys provide full access and should be avoided in production. Use only when other methods aren't available.

```csharp
// Using StorageSharedKeyCredential
var accountName = "mystorageaccount";
var accountKey = "base64-encoded-key";
var credential = new StorageSharedKeyCredential(accountName, accountKey);

var blobServiceClient = new BlobServiceClient(
    new Uri($"https://{accountName}.blob.core.windows.net"),
    credential);
```

**⚠️ Security Warning**: Account keys provide full access to the storage account. If compromised, attackers have complete control over your data. Always prefer managed identity or SAS tokens.

### Authentication Decision Matrix

| Environment | **Recommended Approach** | **Alternative** | **Avoid** |
|-------------|--------------------------|-----------------|-----------|
| **Azure App Service** | System-Assigned Managed Identity | User-Assigned Managed Identity | Account Key |
| **Azure Functions** | System-Assigned Managed Identity | Connection String (dev only) | Account Key |
| **Azure Container Instances** | User-Assigned Managed Identity | SAS Token | Account Key |
| **Azure Kubernetes Service** | Workload Identity | Service Principal | Account Key |
| **Local Development** | Azure CLI + DefaultAzureCredential | Connection String | Account Key |
| **CI/CD Pipelines** | Service Principal | Federated Credentials | Account Key |
| **External Applications** | SAS Token | Service Principal | Account Key |

## Best Practices

### 1. **Security**

#### Use Managed Identity
```csharp
// ✅ Recommended: Use managed identity
var credential = new DefaultAzureCredential();
var blobServiceClient = new BlobServiceClient(accountUri, credential);

// ❌ Avoid: Hard-coded credentials
var connectionString = "DefaultEndpointsProtocol=https;AccountName=...;AccountKey=...";
```

#### Implement Least Privilege Access
```csharp
// Assign minimal required RBAC roles:
// - Storage Blob Data Reader: Read-only access
// - Storage Blob Data Contributor: Read/write access
// - Storage Blob Data Owner: Full access including permissions

// Use SAS tokens for limited-time access
var sasBuilder = new BlobSasBuilder
{
    Resource = "b", // Blob-level access only
    ExpiresOn = DateTimeOffset.UtcNow.AddHours(1), // Short expiration
    Protocol = SasProtocol.Https // HTTPS only
};
sasBuilder.SetPermissions(BlobSasPermissions.Read); // Read-only
```

#### Secure Configuration Management
```csharp
// ✅ Store configuration securely
services.Configure<BlobStorageOptions>(
    configuration.GetSection("BlobStorage"));

// Use Azure Key Vault for sensitive settings
services.AddAzureKeyVault(
    new Uri("https://myvault.vault.azure.net/"),
    new DefaultAzureCredential());
```

### 2. **Performance**

#### Configure Retry Policies
```csharp
var retryOptions = new RetryOptions
{
    MaxRetries = 3,
    Delay = TimeSpan.FromMilliseconds(100),
    MaxDelay = TimeSpan.FromSeconds(10),
    Mode = RetryMode.Exponential
};

var clientOptions = new BlobClientOptions
{
    Retry = retryOptions,
    Transport = new HttpClientTransport(new HttpClient())
};

var blobServiceClient = new BlobServiceClient(accountUri, credential, clientOptions);
```

#### Optimize Transfer Settings
```csharp
// For large file uploads
var uploadOptions = new BlobUploadOptions
{
    TransferOptions = new StorageTransferOptions
    {
        // Use multiple threads for parallel upload
        MaximumConcurrency = Environment.ProcessorCount,
        // Optimize chunk sizes based on content
        MaximumTransferSize = 8 * 1024 * 1024, // 8 MB for large files
        InitialTransferSize = 1024 * 1024      // 1 MB initial
    }
};

// For small files, use smaller chunks
var smallFileOptions = new BlobUploadOptions
{
    TransferOptions = new StorageTransferOptions
    {
        MaximumConcurrency = 1,
        MaximumTransferSize = 256 * 1024 // 256 KB
    }
};
```

#### Use Connection Pooling
```csharp
// Configure HttpClient for connection pooling
var httpClient = new HttpClient(new SocketsHttpHandler
{
    PooledConnectionLifetime = TimeSpan.FromMinutes(15),
    MaxConnectionsPerServer = 100
});

var clientOptions = new BlobClientOptions
{
    Transport = new HttpClientTransport(httpClient)
};

var blobServiceClient = new BlobServiceClient(accountUri, credential, clientOptions);
```

#### Implement Efficient Querying
```csharp
// ✅ Use prefix filtering for better performance
await foreach (var blob in containerClient.GetBlobsAsync(prefix: "logs/2024/"))
{
    // Process only relevant blobs
}

// ✅ Limit results for pagination
var options = new BlobTraits { Metadata = false }; // Don't fetch metadata if not needed
await foreach (var page in containerClient.GetBlobsAsync(traits: options).AsPages(pageSizeHint: 100))
{
    foreach (var blob in page.Values)
    {
        // Process in batches
    }
}
```

### 3. **Reliability**

#### Implement Circuit Breaker Pattern
```csharp
public class BlobStorageService
{
    private readonly BlobServiceClient _blobServiceClient;
    private readonly ICircuitBreakerPolicy _circuitBreaker;

    public BlobStorageService(BlobServiceClient blobServiceClient)
    {
        _blobServiceClient = blobServiceClient;
        
        _circuitBreaker = Policy
            .Handle<RequestFailedException>(ex => ex.Status >= 500)
            .CircuitBreakerAsync(
                handledEventsAllowedBeforeBreaking: 5,
                durationOfBreak: TimeSpan.FromMinutes(1),
                onBreak: (exception, duration) => 
                {
                    // Log circuit breaker opened
                },
                onReset: () => 
                {
                    // Log circuit breaker closed
                });
    }

    public async Task<BinaryData> DownloadWithCircuitBreakerAsync(string containerName, string blobName)
    {
        return await _circuitBreaker.ExecuteAsync(async () =>
        {
            var blobClient = _blobServiceClient
                .GetBlobContainerClient(containerName)
                .GetBlobClient(blobName);
                
            var response = await blobClient.DownloadContentAsync();
            return response.Value.Content;
        });
    }
}
```

#### Handle Transient Failures
```csharp
public async Task<bool> UploadWithResilience(Stream content, string containerName, string blobName)
{
    var retryPolicy = Policy
        .Handle<RequestFailedException>(ex => 
            ex.Status == 500 || ex.Status == 502 || ex.Status == 503 || ex.Status == 504)
        .Or<HttpRequestException>()
        .Or<TaskCanceledException>()
        .WaitAndRetryAsync(
            retryCount: 3,
            sleepDurationProvider: retryAttempt => 
                TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)) // Exponential backoff
        );

    try
    {
        await retryPolicy.ExecuteAsync(async () =>
        {
            content.Position = 0; // Reset stream position for retries
            var blobClient = _blobServiceClient
                .GetBlobContainerClient(containerName)
                .GetBlobClient(blobName);
                
            await blobClient.UploadAsync(content, overwrite: true);
        });
        
        return true;
    }
    catch (RequestFailedException ex)
    {
        // Log final failure
        return false;
    }
}
```

#### Implement Health Checks
```csharp
// In startup/program
services.AddHealthChecks()
    .AddCheck<BlobStorageHealthCheck>("blob_storage");

public class BlobStorageHealthCheck : IHealthCheck
{
    private readonly BlobServiceClient _blobServiceClient;

    public BlobStorageHealthCheck(BlobServiceClient blobServiceClient)
    {
        _blobServiceClient = blobServiceClient;
    }

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context, 
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Simple connectivity check
            await _blobServiceClient.GetPropertiesAsync(cancellationToken);
            return HealthCheckResult.Healthy("Blob Storage is accessible");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("Blob Storage is not accessible", ex);
        }
    }
}
```

### 4. **Cost Optimization**

#### Use Appropriate Access Tiers
```csharp
// Upload directly to appropriate tier
await blobClient.UploadAsync(content, new BlobUploadOptions
{
    AccessTier = AccessTier.Cool // For infrequently accessed data
});

// Implement lifecycle management
public async Task ArchiveOldBlobs(BlobContainerClient containerClient)
{
    var cutoffDate = DateTimeOffset.UtcNow.AddMonths(-6);
    
    await foreach (var blob in containerClient.GetBlobsAsync())
    {
        if (blob.Properties.LastModified < cutoffDate)
        {
            var blobClient = containerClient.GetBlobClient(blob.Name);
            await blobClient.SetAccessTierAsync(AccessTier.Archive);
        }
    }
}
```

#### Optimize Storage Operations
```csharp
// Use batch operations for efficiency
var batchClient = _blobServiceClient.GetBlobBatchClient();
var batch = batchClient.CreateBatch();

foreach (var blobName in blobsToArchive)
{
    var blobUri = new Uri($"{containerClient.Uri}/{blobName}");
    batch.SetBlobAccessTier(blobUri, AccessTier.Archive);
}

await batchClient.SubmitBatchAsync(batch); // Single API call for multiple operations
```

#### Monitor and Alert on Costs
```csharp
// Implement cost monitoring
public class BlobUsageMonitor
{
    public async Task<BlobContainerUsage> GetContainerUsageAsync(BlobContainerClient containerClient)
    {
        long totalSize = 0;
        int blobCount = 0;
        var tierCounts = new Dictionary<string, int>();

        await foreach (var blob in containerClient.GetBlobsAsync(BlobTraits.All))
        {
            totalSize += blob.Properties.ContentLength ?? 0;
            blobCount++;
            
            var tier = blob.Properties.AccessTier?.ToString() ?? "Unknown";
            tierCounts[tier] = tierCounts.GetValueOrDefault(tier) + 1;
        }

        return new BlobContainerUsage
        {
            TotalSizeBytes = totalSize,
            BlobCount = blobCount,
            TierDistribution = tierCounts
        };
    }
}

public class BlobContainerUsage
{
    public long TotalSizeBytes { get; set; }
    public int BlobCount { get; set; }
    public Dictionary<string, int> TierDistribution { get; set; }
}
```

## Migration from Legacy SDK

### From WindowsAzure.Storage

The `WindowsAzure.Storage` package was the original Azure Storage SDK and has been discontinued. Here's how to migrate:

#### Before (WindowsAzure.Storage)
```csharp
// Old SDK - DO NOT USE
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;

var storageAccount = CloudStorageAccount.Parse(connectionString);
var blobClient = storageAccount.CreateCloudBlobClient();
var container = blobClient.GetContainerReference("mycontainer");
var blockBlob = container.GetBlockBlobReference("myblob.txt");

await blockBlob.UploadTextAsync("Hello World");
string content = await blockBlob.DownloadTextAsync();
```

#### After (Azure.Storage.Blobs)
```csharp
// New SDK - RECOMMENDED
using Azure.Storage.Blobs;

var blobServiceClient = new BlobServiceClient(connectionString);
var containerClient = blobServiceClient.GetBlobContainerClient("mycontainer");
var blobClient = containerClient.GetBlobClient("myblob.txt");

await blobClient.UploadAsync(BinaryData.FromString("Hello World"));
var response = await blobClient.DownloadContentAsync();
string content = response.Value.Content.ToString();
```

### From Microsoft.Azure.Storage

The `Microsoft.Azure.Storage.*` packages were deprecated in October 2024:

#### Before (Microsoft.Azure.Storage)
```csharp
// Deprecated SDK - MIGRATE IMMEDIATELY
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;

var storageAccount = CloudStorageAccount.Parse(connectionString);
var blobClient = storageAccount.CreateCloudBlobClient();
var container = blobClient.GetContainerReference("mycontainer");

// Upload with metadata
var blob = container.GetBlockBlobReference("document.pdf");
blob.Metadata["author"] = "John Doe";
blob.Properties.ContentType = "application/pdf";

using (var fileStream = File.OpenRead(@"C:\document.pdf"))
{
    await blob.UploadFromStreamAsync(fileStream);
}

await blob.SetMetadataAsync();
await blob.SetPropertiesAsync();
```

#### After (Azure.Storage.Blobs)
```csharp
// Modern SDK - USE THIS
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

var blobServiceClient = new BlobServiceClient(connectionString);
var containerClient = blobServiceClient.GetBlobContainerClient("mycontainer");
var blobClient = containerClient.GetBlobClient("document.pdf");

// Upload with metadata and properties in single operation
var uploadOptions = new BlobUploadOptions
{
    HttpHeaders = new BlobHttpHeaders
    {
        ContentType = "application/pdf"
    },
    Metadata = new Dictionary<string, string>
    {
        ["author"] = "John Doe"
    }
};

using (var fileStream = File.OpenRead(@"C:\document.pdf"))
{
    await blobClient.UploadAsync(fileStream, uploadOptions);
}
```

### Migration Checklist

#### 1. **Package References**
```xml
<!-- Remove these deprecated packages -->
<PackageReference Include="WindowsAzure.Storage" Version="*" />
<PackageReference Include="Microsoft.Azure.Storage.Blob" Version="*" />
<PackageReference Include="Microsoft.Azure.Storage.Common" Version="*" />

<!-- Add modern package -->
<PackageReference Include="Azure.Storage.Blobs" Version="12.21.2" />
<PackageReference Include="Azure.Identity" Version="1.12.0" />
```

#### 2. **Namespace Updates**
```csharp
// Old namespaces - REMOVE
// using Microsoft.WindowsAzure.Storage;
// using Microsoft.WindowsAzure.Storage.Blob;
// using Microsoft.Azure.Storage;
// using Microsoft.Azure.Storage.Blob;

// New namespaces - USE THESE
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Identity;
```

#### 3. **Client Creation Patterns**
```csharp
// Old pattern
// var account = CloudStorageAccount.Parse(connectionString);
// var client = account.CreateCloudBlobClient();

// New pattern
var blobServiceClient = new BlobServiceClient(connectionString);
// Or with managed identity (recommended)
var blobServiceClient = new BlobServiceClient(
    new Uri("https://account.blob.core.windows.net"),
    new DefaultAzureCredential());
```

#### 4. **Method Mapping**

| **Legacy Method** | **Modern Equivalent** | **Notes** |
|-------------------|----------------------|-----------|
| `UploadFromStreamAsync()` | `UploadAsync(stream)` | Simplified API |
| `DownloadToStreamAsync()` | `DownloadToAsync()` | Better error handling |
| `UploadTextAsync()` | `UploadAsync(BinaryData.FromString())` | Type-safe approach |
| `DownloadTextAsync()` | `DownloadContentAsync().Value.Content.ToString()` | More explicit |
| `SetMetadataAsync()` | `SetMetadataAsync()` | Same method name |
| `SetPropertiesAsync()` | `SetHttpHeadersAsync()` | More specific naming |
| `GetSharedAccessSignature()` | `GenerateSasUri()` | Built-in SAS generation |
| `ListBlobsSegmentedAsync()` | `GetBlobsAsync().AsPages()` | Async enumerable |

#### 5. **Authentication Migration**
```csharp
// Legacy: Connection string only
// var account = CloudStorageAccount.Parse(connectionString);

// Modern: Multiple auth options
// Connection string (dev/test)
var client1 = new BlobServiceClient(connectionString);

// Managed Identity (production - recommended)
var client2 = new BlobServiceClient(accountUri, new DefaultAzureCredential());

// SAS Token
var client3 = new BlobServiceClient(sasUri);

// Account Key (not recommended)
var client4 = new BlobServiceClient(accountUri, new StorageSharedKeyCredential(name, key));
```

#### 6. **Error Handling Updates**
```csharp
// Legacy exception type
// catch (StorageException ex)

// Modern exception type
catch (RequestFailedException ex)
{
    // Better error information available
    Console.WriteLine($"Error: {ex.ErrorCode}, Status: {ex.Status}");
}
```

#### 7. **Testing Migration**

Create a comprehensive test to verify migration:

```csharp
[Test]
public async Task MigrationValidationTest()
{
    var blobServiceClient = new BlobServiceClient(connectionString);
    var containerClient = blobServiceClient.GetBlobContainerClient("test-container");
    
    await containerClient.CreateIfNotExistsAsync();
    
    // Test upload
    var blobClient = containerClient.GetBlobClient("test-blob.txt");
    var content = "Migration test content";
    await blobClient.UploadAsync(BinaryData.FromString(content), overwrite: true);
    
    // Test download
    var downloadResponse = await blobClient.DownloadContentAsync();
    var downloadedContent = downloadResponse.Value.Content.ToString();
    
    Assert.AreEqual(content, downloadedContent);
    
    // Test metadata
    var metadata = new Dictionary<string, string> { ["test"] = "value" };
    await blobClient.SetMetadataAsync(metadata);
    
    var properties = await blobClient.GetPropertiesAsync();
    Assert.AreEqual("value", properties.Value.Metadata["test"]);
    
    // Cleanup
    await containerClient.DeleteAsync();
}
```

## References

1. **[Azure Blob Storage Documentation](https://docs.microsoft.com/en-us/azure/storage/blobs/)**
   - Official Microsoft documentation providing comprehensive coverage of Azure Blob Storage concepts, features, and best practices. Essential reference for understanding storage account types, access tiers, and service capabilities.

2. **[Azure.Storage.Blobs NuGet Package](https://www.nuget.org/packages/Azure.Storage.Blobs/)**
   - The official NuGet package page for the modern Azure Blob Storage client library. Contains version information, release notes, and dependency details crucial for project setup and maintenance.

3. **[Azure Storage Client Library for .NET - GitHub](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/storage)**
   - Source code repository containing the implementation, samples, and issue tracking for the Azure Storage .NET SDK. Valuable for understanding implementation details and accessing community contributions.

4. **[Azure Identity Documentation](https://docs.microsoft.com/en-us/dotnet/azure/sdk/authentication/)**
   - Comprehensive guide to authentication patterns in Azure SDK, including managed identity, service principal, and DefaultAzureCredential usage. Critical for implementing secure authentication in production applications.

5. **[Azure Storage Security Guide](https://docs.microsoft.com/en-us/azure/storage/common/security-recommendations)**
   - Security best practices and recommendations for Azure Storage services. Essential reading for implementing proper security controls, access management, and compliance requirements.

6. **[Azure Storage Performance and Scalability Checklist](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-performance-checklist)**
   - Performance optimization guidelines and scalability considerations for blob storage workloads. Important for designing high-performance applications and avoiding common performance pitfalls.

7. **[Azure Storage Pricing](https://azure.microsoft.com/en-us/pricing/details/storage/blobs/)**
   - Detailed pricing information for Azure Blob Storage including access tiers, operations costs, and data transfer charges. Essential for cost optimization and capacity planning decisions.

8. **[Azure Blob Storage REST API Reference](https://docs.microsoft.com/en-us/rest/api/storageservices/blob-service-rest-api)**
   - Complete REST API specification for Azure Blob Storage services. Useful for understanding the underlying protocol and implementing custom solutions or advanced scenarios.

9. **[Migration Guide from Legacy SDKs](https://docs.microsoft.com/en-us/azure/storage/common/storage-sdk-migration)**
   - Official migration guidance for moving from deprecated WindowsAzure.Storage and Microsoft.Azure.Storage packages to modern Azure.Storage.Blobs SDK. Critical for maintaining existing applications and planning upgrade paths.

10. **[Azure Storage Samples Repository](https://github.com/Azure-Samples/storage-blobs-dotnet-quickstart)**
    - Collection of practical code samples demonstrating common Azure Blob Storage scenarios and patterns. Excellent resource for learning implementation techniques and getting started quickly with real-world examples.
