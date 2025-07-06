# Working Qwen2.5 Sample with Foundry Local

## Important Note about Package Availability

The packages I initially used in the sample don't match the actual available packages. Based on Microsoft Learn documentation, here are the correct packages and approach:

## Fixed Basic Sample (Working)

The **basic console sample** has been updated with the correct packages:

- ✅ `Microsoft.AI.Foundry.Local` (version 0.1.0)
- ✅ `OpenAI` (version 2.2.0-beta.4)

### How to Run the Basic Sample

1. Navigate to the basic sample:
   ```bash
   cd "c:\dev\Samples\Qwen25-FoundryLocal-Sample"
   ```

2. Install packages:
   ```bash
   dotnet restore
   ```

3. Run the application:
   ```bash
   dotnet run
   ```

   Or run the simplified version:
   ```bash
   dotnet run SimpleProgram.cs
   ```

## About the Aspire Integration

The .NET Aspire integration shown in your session transcript uses packages that are likely in **private preview** or **internal Microsoft builds**:

- `Microsoft.Extensions.Hosting.FoundryLocal` - **Not yet publicly available**
- `Aspire.Azure.AI.Inference` - **Not yet publicly available**

### Expected Aspire Integration (When Available)

Based on your session transcript, the Aspire integration would work like this:

**AppHost (when packages are available):**
```csharp
var foundryResource = builder.AddFoundryLocalResource("ai")
    .AddModel("chat", "Qwen2.5-0.5B");

builder.AddProject<Projects.WebApp>()
    .WithReference(foundryResource)
    .WaitFor(foundryResource);
```

**Client App (when packages are available):**
```csharp
builder.Services.AddChatCompletionsClient("chat")
    .AsOpenAIClient()
    .UseFunctionCalling()
    .UseOpenTelemetry();
```

## Current Working Approach

Until the Aspire packages are publicly available, you can:

1. **Use the basic console sample** - This works with the current publicly available packages
2. **Create a manual Aspire setup** - Start Foundry Local manually and connect your web app to it
3. **Use the OpenAI SDK directly** - Connect to Foundry Local's OpenAI-compatible endpoint

## Model Aliases

Use these model aliases for optimal hardware selection:

- `qwen2.5-0.5b-instruct` - Smallest, fastest
- `qwen2.5-1.5b-instruct` - Balanced performance  
- `qwen2.5-3b-instruct` - Highest quality

## Sample Output

When you run the basic sample, you should see:

```
Starting Foundry Local service...
Foundry Local service started!
Service URI: http://localhost:5272
API Endpoint: http://localhost:5272/v1
Loading model: qwen2.5-0.5b-instruct
Model loaded successfully!

=== Chat Completion Example ===
AI Response: Running AI models locally offers several key benefits: cost savings since there are no cloud service fees, enhanced privacy as your data never leaves your device, offline capability without internet dependency, and complete control over processing speed based on your hardware capabilities.

=== Streaming Chat Example ===
Question: Explain local AI in 2 sentences.
AI Response (streaming): Local AI refers to running artificial intelligence models directly on your own device rather than sending data to cloud servers for processing. This approach provides better privacy, eliminates ongoing costs, and allows AI functionality to work offline while giving you complete control over your data.

Streaming completed!
Unloading model...
Stopping Foundry Local service...
Done!
```

## Prerequisites

1. **Foundry Local installed** - Follow the [installation guide](https://learn.microsoft.com/azure/ai-foundry/foundry-local/get-started)
2. **.NET 8.0 SDK** or later
3. **Sufficient RAM** - At least 4GB available for Qwen2.5-0.5B
4. **Good internet connection** - For initial model download (~800MB)

## Troubleshooting

### If you get package errors:
- Make sure you're using the exact package names and versions shown above
- Clear NuGet cache: `dotnet nuget locals all --clear`
- Try deleting `bin` and `obj` folders and run `dotnet restore` again

### If Foundry Local doesn't start:
- Make sure Foundry Local is properly installed on your system
- Check that no other instances are running
- Verify you have sufficient system resources

## Next Steps

1. Try the basic sample first to ensure everything works
2. Experiment with different model aliases
3. Monitor for availability of official Aspire integration packages
4. Consider building your own simple orchestration layer for web apps

The session transcript shows the future vision of seamless Aspire integration, but the current publicly available packages provide the foundation for local AI development.
