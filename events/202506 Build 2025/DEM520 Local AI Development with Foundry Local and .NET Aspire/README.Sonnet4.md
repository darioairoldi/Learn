# DEM520: Local AI Development with Foundry Local and .NET Aspire

## Session Overview

**Session:** DEM520  
**Title:** Local AI development with Foundry Local and .NET Aspire  
**Duration:** ~13 minutes  
**Event:** Microsoft Build  
**Format:** Live demonstration with code examples  
**Link:** [Microsoft Build 2025 Session DEM520](https://mybuild.microsoft.com/sessions/DEM520)

## Session Introduction

The session begins with acknowledgment of the late hour and long week of the conference, with the presenter mentioning a challenge to do juggling throughout the session to keep the audience engaged.

## Key Topics Covered

### 1. Local AI vs Cloud AI: The Tradeoffs

#### Benefits of Running AI Models Locally

- **Cost savings**: Running models locally is free compared to paying for cloud services
- **Data privacy**: All information stays on your device, not sent to external clouds
- **Network independence**: No dependency on internet connectivity or network speed
- **Control**: Full control over data and processing speed based on device hardware
- **Offline capability**: Can run completely offline without cloud dependencies
- **No quotas or throttling**: You control the device completely

#### Challenges of Local AI Development

- **Hardware constraints**: Can't run any model on any hardware due to memory requirements
- **Model size limitations**: Large models require significant memory and appropriate hardware
- **Device diversity**: Different types of hardware across millions of users
- **Model distribution**: How to send the right model to the right device
- **Framework compatibility**: Different models and frameworks have different system capabilities

### 2. Introduction to Foundry Local

Foundry Local is Microsoft's solution to address local AI development challenges:

- **Intelligent model selection**: Automatically delivers the best model for your device
- **Local service**: Runs as a local service that decides the optimal model for the hardware
- **Hardware optimization**: Automatically determines whether to run on GPU, CPU, or NPU
- **Quantization support**: Supports appropriate quantization based on device capabilities
- **OpenAI compatibility**: Provides OpenAI-compliant HTTP endpoints for familiar integration

#### Code Example: Basic Foundry Local Usage

```csharp
// Import the Foundry Local namespace
using Microsoft.AI.FoundryLocal;

// Specify the model you want to use
var modelName = "Qwen2.5-0.5B"; // 0.5 billion parameter model

// Start a new Foundry manager with the model
var foundryManager = new FoundryManager(modelName);

// Get a model client for API calls
var modelClient = foundryManager.GetModelClient();
```

### 3. Distributed Applications and .NET Aspire

The session highlighted the challenges of managing distributed applications where you need to:

- Manage model download and service lifecycle
- Handle application consumption of the model
- Orchestrate multiple services working together

#### .NET Aspire Solution

.NET Aspire separates concerns by providing:

- **App Host**: Responsible for orchestrating model download and Foundry Local service management
- **Client Application**: Focuses solely on consuming the AI service
- **Service Integration**: Uses Microsoft Extensions Azure Inference SDK alongside OpenAI SDK patterns

### 4. Live Demonstration

The demonstration showed how to integrate Foundry Local with .NET Aspire:

#### App Host Configuration

```csharp
// Add Foundry hosting integration package
// Microsoft.Extensions.Hosting.FoundryLocal (pre-release)

// Configure the Foundry resource
var foundryResource = builder.AddFoundryLocalResource("ai")
    .AddModel("chat", "Qwen2.5-0.5B"); // Model family specification

// Pass reference to client application
builder.AddProject<Projects.WebApp>()
    .WithReference(foundryResource)
    .WaitFor(foundryResource); // Wait for model download before starting
```

#### Client Application Setup

```csharp
// Add Aspire Azure AI Inference integration
builder.Services.AddChatCompletionsClient("chat") // Reference to model defined in app host
    .AsOpenAIClient() // Convert to Microsoft Extensions AI interface
    .UseFunctionCalling() // Enable function calling capabilities
    .UseOpenTelemetry(); // Add diagnostic logging through Aspire
```

### 5. Key Technical Benefits

#### Automatic Hardware Detection

- No need to specify model version (CPU/GPU/NPU)
- Foundry Local automatically selects the appropriate model variant
- Handles quantization decisions based on available hardware

#### Development Experience

- Familiar OpenAI-compatible API patterns
- Integration with existing Microsoft Extensions AI ecosystem
- Rich diagnostic logging through OpenTelemetry
- Orchestration handled by .NET Aspire

#### Production Considerations

- Model caching for faster subsequent startups
- Dependency management between services
- Proper startup sequencing (models download before app starts)

## Session Challenges and Real-World Considerations

The live demonstration encountered network bandwidth limitations when downloading the Qwen 0.5B model (~800MB), highlighting real-world considerations:

- Conference Wi-Fi limitations affecting model download speeds
- Importance of model caching for production scenarios
- Need for fallback strategies in live demonstrations

## Technical Architecture

The session demonstrated a clean separation of concerns:

1. **Infrastructure Layer**: .NET Aspire App Host manages Foundry Local service
2. **AI Service Layer**: Foundry Local handles model selection and optimization
3. **Application Layer**: Web application consumes AI services through standard interfaces
4. **Integration Layer**: Microsoft Extensions AI provides unified abstractions

## Key Takeaways

1. **Local AI is viable** but requires careful consideration of hardware constraints and model management
2. **Foundry Local simplifies deployment** by handling hardware-specific optimizations automatically
3. **.NET Aspire provides orchestration** for complex distributed AI applications
4. **Developer experience remains familiar** through OpenAI-compatible APIs
5. **Production readiness** requires consideration of model caching and network dependencies

## Resources and Next Steps

- Foundry Local integration packages are in pre-release
- Templates available through Microsoft Extensions AI
- Integration with Visual Studio for streamlined development experience
- Rich diagnostic capabilities through .NET Aspire dashboard

## Session Conclusion

Despite technical challenges with the live demo, the session successfully demonstrated the potential for simplified local AI development using Foundry Local and .NET Aspire. The approach promises to reduce the complexity of managing local AI models while maintaining familiar development patterns for .NET developers.

---

*Note: This transcript was generated from the DEM520 session at Microsoft Build. The session included live coding demonstrations and real-time problem-solving that highlighted both the capabilities and practical considerations of local AI development.*
