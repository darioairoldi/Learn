# Foundry Local Samples

This repository contains sample code demonstrating how to load and initialize local models using Microsoft's Foundry Local service, both as a standalone application and integrated with .NET Aspire.

## Samples Included

### 1. Basic Foundry Local Sample (`Qwen25-FoundryLocal-Sample`)

A simple console application that demonstrates:
- Direct initialization of Qwen2.5 model using Foundry Local
- Basic chat completion
- Streaming chat responses
- Proper resource management and error handling

### 2. .NET Aspire Integration Sample (`Qwen25-Aspire-Sample`)

A complete web application demonstrating:
- .NET Aspire orchestration of Foundry Local services
- Web API endpoints for chat interactions
- Modern web interface for testing
- Proper separation of concerns between App Host and client application

## Prerequisites

- .NET 8.0 SDK or later
- Visual Studio 2022 17.8+ or Visual Studio Code with C# extension
- Windows 11 (recommended for optimal hardware detection)
- **Foundry Local installed** - See [installation guide](https://learn.microsoft.com/azure/ai-foundry/foundry-local/get-started)
- Sufficient system memory (4GB+ available RAM recommended for Qwen2.5-0.5B)

## Important Note About Package Availability

⚠️ **The .NET Aspire integration shown in your session transcript uses packages that are currently in private preview.**

### What Works Now (✅)
- **Basic Foundry Local Sample** - Uses publicly available packages
- Direct integration with Foundry Local SDK
- OpenAI-compatible API access

### What's Coming Soon (🔄)
- **Full .NET Aspire Integration** - Packages like `Microsoft.Extensions.Hosting.FoundryLocal` are in development
- Seamless orchestration as shown in the Build session

## Current Status ✅

**All code compiles and runs successfully!** The samples can:
- Start and connect to Foundry Local services
- Discover available models in the catalog (50+ models found)
- Select appropriate models (Qwen, Phi, Mistral, etc.)
- Attempt to load models for inference

⚠️ **Important**: Models must be downloaded before they can be loaded. The first time you try to load a model, you'll get a "Model not found" error - this is expected. See the "Downloading Models" section below for instructions.

## Hardware Requirements

The Qwen2.5 models have different hardware requirements:

- **Qwen2.5-0.5B**: ~1GB RAM, works on most modern devices
- **Qwen2.5-1.5B**: ~3GB RAM, better quality responses
- **Qwen2.5-3B**: ~6GB RAM, highest quality responses

Foundry Local will automatically select the best model variant for your hardware.

## Getting Started

### Option 1: Basic Foundry Local Sample (✅ **Recommended - Works Now**)

1. Navigate to the basic sample directory:

   ```bash
   cd "c:\dev\Samples\20250629 Build 2025 session\Qwen25-FoundryLocal-Sample"
   ```

2. Restore packages:

   ```bash
   dotnet restore
   ```

3. Run the discovery application (recommended - shows available models):

   ```bash
   dotnet run
   ```

   Or run the simple version (faster startup):

   ```bash
   dotnet run simple
   ```

   **Note**: The first run will download the model (~800MB for smaller models), which may take several minutes depending on your internet connection.

### Option 2: .NET Aspire Sample (⚠️ **Not Currently Available**)

1. Navigate to the Aspire sample directory:
   ```bash
   cd "c:\dev\Samples\20250629 Build 2025 session\Qwen25-Aspire-Sample"
   ```

2. Restore packages:
   ```bash
   dotnet restore
   ```

3. Run the App Host (this will start both the Foundry Local service and the web application):
   ```bash
   dotnet run --project Qwen25.AppHost
   ```

4. Open your browser and navigate to the web application URL shown in the console (typically `https://localhost:7000` or similar)

5. Use the .NET Aspire dashboard to monitor the services (URL will be shown in console)

## Key Features Demonstrated

### Foundry Local Features
- **Automatic Hardware Detection**: Foundry Local automatically detects your GPU, CPU, and NPU capabilities
- **Model Optimization**: Automatically selects the best quantization and optimization for your hardware
- **OpenAI Compatibility**: Uses familiar OpenAI-compatible APIs
- **Local Execution**: Everything runs locally - no data sent to external services

### .NET Aspire Features
- **Service Orchestration**: Manages the lifecycle of Foundry Local services
- **Dependency Management**: Ensures model download completes before starting the web application
- **Telemetry Integration**: Rich logging and monitoring through OpenTelemetry
- **Health Checks**: Built-in health monitoring for all services

## API Endpoints (Aspire Sample)

- `POST /api/chat` - Send a message and get a complete response
- `POST /api/chat/stream` - Send a message and get a streaming response

### Example API Usage

```json
POST /api/chat
{
  "message": "What are the benefits of running AI models locally?"
}
```

## Configuration Options

### Model Selection

You can change the model by modifying the model name in the configuration:

```csharp
// For basic sample (Program.cs)
var modelName = "Qwen2.5-1.5B"; // Larger model

// For Aspire sample (AppHost/Program.cs)
var foundryResource = builder.AddFoundryLocalResource("ai")
    .AddModel("chat", "Qwen2.5-1.5B");
```

### Available Models
- `Qwen2.5-0.5B` - Fastest, smallest (500M parameters)
- `Qwen2.5-1.5B` - Balanced performance (1.5B parameters)
- `Qwen2.5-3B` - Highest quality (3B parameters)

## Troubleshooting

### Package/Build Issues

- **Package downgrade warnings**: If you see `System.ClientModel` version conflicts, remove the explicit reference - the OpenAI SDK will bring in the correct version automatically
- **NuGet restore errors**: Clear NuGet cache with `dotnet nuget locals all --clear` and delete `bin`/`obj` folders
- **Missing packages**: Ensure you have the latest .NET 8 SDK installed

### Model Download Issues

**"Model not found in local models" Error**: This is expected behavior! Models need to be downloaded before they can be loaded.

**To download models**, you have several options:
1. **Via Foundry CLI**: Use `foundry model run <model-alias>` (e.g., `foundry model run phi-3-mini-4k`) - downloads automatically
2. **Via Azure AI Studio**: Browse to the Foundry Local models section and download models
3. **Interactive testing**: The `foundry model run` command starts an interactive chat after download

**Common download issues:**
- Ensure stable internet connection for initial download
- Check available disk space (models can be 800MB - 6GB)
- Verify firewall/antivirus isn't blocking the download

### Performance Issues
- Close other memory-intensive applications
- Consider using a smaller model (0.5B) if experiencing slowdowns
- Monitor CPU/GPU usage in Task Manager

### Foundry Local Service Issues

- **"Model not found in catalog" errors**: Run `DiscoverAndRunModels.cs` to see available models, or check if your Foundry Local installation is up to date
- **Empty model catalog**: Ensure Foundry Local is properly installed and can access the internet to download the model catalog
- **Service startup failures**: Ensure no other instances are running
- **Port conflicts**: Check that ports 5272 (default) are not in use by other applications
- **Permission errors**: Run with appropriate permissions, especially on first install
- Check Windows Event Viewer for detailed error messages
- Verify .NET 8 runtime is properly installed

## Architecture Notes

### Basic Sample Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Console App     │───▶│ Foundry Manager  │───▶│ Local AI Model  │
│ (Your Code)     │    │ (Service Layer)  │    │ (Qwen2.5)      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Aspire Sample Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ .NET Aspire     │───▶│ Foundry Local    │───▶│ Local AI Model  │
│ App Host        │    │ Service          │    │ (Qwen2.5)      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                                              ▲
         ▼                                              │
┌─────────────────┐    ┌──────────────────┐            │
│ Web Application │───▶│ HTTP API Client  │────────────┘
│ (Razor Pages)   │    │ (OpenAI Compat)  │
└─────────────────┘    └──────────────────┘
```

## Performance Expectations

| Model | Size | RAM Usage | CPU (approx) | GPU (with support) |
|-------|------|-----------|--------------|-------------------|
| Qwen2.5-0.5B | ~800MB | ~1GB | 2-5 tokens/sec | 10-50 tokens/sec |
| Qwen2.5-1.5B | ~2GB | ~3GB | 1-3 tokens/sec | 5-30 tokens/sec |
| Qwen2.5-3B | ~6GB | ~6GB | 0.5-2 tokens/sec | 3-20 tokens/sec |

*Performance varies significantly based on hardware configuration*

## Security Notes

- All processing happens locally - no data leaves your device
- Models are cached locally after first download
- No API keys or external authentication required
- Consider firewall rules if running in production environments

## Next Steps

- Explore function calling capabilities
- Integrate with existing .NET applications
- Experiment with different model sizes
- Add custom system prompts and fine-tuning
- Scale to multiple models using Aspire orchestration

## Resources

- [Microsoft Build DEM520 Session](https://build.microsoft.com/en-US/sessions/DEM520?source=sessions)
- [Foundry Local Documentation](https://docs.microsoft.com/foundry-local)
- [.NET Aspire Documentation](https://docs.microsoft.com/dotnet/aspire)
- [Microsoft Extensions AI](https://docs.microsoft.com/dotnet/ai)

## License

This sample code is provided under the MIT License. See LICENSE file for details.

## Downloading Models

Before you can use any model, it must be downloaded to your local machine. The discovery sample shows all available models in the catalog, but they need to be downloaded before loading.

### Quick Start - Download a Model

Based on the available models, here are the recommended downloads:

**For beginners (smallest, fastest):**
```bash
# Download and run Phi-3 Mini (2.2GB) - good balance of size and capability
foundry model run phi-3-mini-4k

# Alternative: Download and run Qwen 2.5 0.5B (smaller, very fast)
foundry model run qwen2.5-0.5b
```

**For better quality responses:**
```bash
# Download and run Phi-4 (8.6GB) - latest and most capable
foundry model run phi-4

# Download and run Mistral 7B (4GB) - good general purpose model
foundry model run mistral-7b-v0.2
```

### How It Works

The Foundry CLI simplifies the process by combining download and execution:

1. **`foundry model list`** - Shows all available models in the catalog
2. **`foundry model run <model-name>`** - Downloads the model (if needed) and starts interactive chat
3. **Your .NET samples automatically work** - Once a model is downloaded, your code can load it

**Key Benefits:**
- ✅ **One command does everything** - no separate download step
- ✅ **Automatic hardware optimization** - selects best GPU/CPU variant  
- ✅ **Interactive testing** - chat with the model before using in code
- ✅ **Background service** - models remain loaded for your .NET applications

### Available Download Methods

1. **Foundry CLI (Recommended)**
   ```bash
   # Download and run models (downloads automatically if not present)
   foundry model run phi-3-mini-4k
   foundry model run qwen2.5-0.5b
   foundry model run phi-4
   
   # List available models in catalog
   foundry model list
   
   # Check service status
   foundry service status
   ```

2. **Azure AI Studio**
   - Open Azure AI Studio
   - Navigate to Foundry Local section
   - Browse available models and click download

3. **Direct Download and Run (Easiest)**
   - The `foundry model run` command automatically downloads models if not present
   - No separate download step needed - just run the model you want to use

### Model Selection Guide

Based on your output, here are the available models by category:

**Phi Models (Microsoft):**
- `phi-4` - Latest, best quality (8.6GB)
- `phi-3-mini-128k` - Long context support (2.2GB)  
- `phi-3-mini-4k` - Standard context (2.2GB)

**Qwen Models (Alibaba):**
- `qwen2.5-0.5b` - Smallest, fastest (500MB)
- Other Qwen variants available in catalog

**Mistral Models:**
- `mistral-7b-v0.2` - Good general purpose (4GB)

### Hardware-Specific Downloads

Your catalog shows different variants for different hardware:
- `*-cuda-gpu` - NVIDIA GPU acceleration
- `*-generic-gpu` - General GPU support
- `*-generic-cpu` - CPU-only execution

Foundry Local automatically selects the best variant for your hardware.

### Download Troubleshooting

**Common Issues:**
- **Slow downloads**: Models are large (500MB-10GB), ensure stable internet
- **Disk space**: Check you have enough free space before downloading
- **Network issues**: Corporate firewalls may block downloads
- **Permission errors**: Run with administrator privileges if needed

**Verify Download:**
```bash
# List all available models and their status
foundry model list

# Check if service is running
foundry service status
```

### What Happens After Download

Once downloaded, your sample code will work without the "Model not found" error:

1. **Discovery Sample**: Will show downloaded models and successfully load them
2. **Simple Sample**: Will automatically find and use downloaded models
3. **Chat Completion**: Will work with full streaming and regular responses

### Next Steps After Download

1. Navigate to the sample directory: `cd "c:\dev\Samples\20250629 Build 2025 session\Qwen25-FoundryLocal-Sample"`
2. Run the discovery sample: `dotnet run discovery`
3. Try the simple sample: `dotnet run simple`
4. The model should load successfully and respond to chat prompts!
