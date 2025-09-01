# The Power Within: Running Large Language Models on Your Local Machine

**Session Date:** May 21, 2025  
**Duration:** 15 minutes  
**Venue:** Build 2025 Conference - DEM524  
**Speaker:** Rodrigo Diaz Concha (Technical Fellow, Intelexion)  
**Link:** [Microsoft Build 2025 Session DEM524](https://mybuild.microsoft.com/sessions/202506)

![Local LLMs with Foundry Local](images/local-llms-foundry-local.png)

---

## Executive Summary

Rodrigo Diaz Concha demonstrates the revolutionary shift toward local AI computing through Microsoft's Foundry Local technology, announced just two days prior to Build 2025. This comprehensive live demonstration showcases real-world scenarios where local LLM deployment becomes essential - from isolated prison telemedicine systems to remote mining operations and retail analytics kiosks. The session provides practical implementation guidance for running multiple AI models locally while maintaining full data privacy and eliminating cloud dependencies.

---

## Key Topics Covered

### ?? **1. Real-World Local AI Use Cases**

#### Critical Infrastructure Applications
**Rodrigo's Opening Context:**
> "There are some scenarios where running large language models locally makes sense. For instance, I'm involved in this project. This is a telemedicine project for prisons."

**Healthcare in Isolated Environments:**
```
Prison Telemedicine Requirements:
??? Security Constraints: No prisoner transport to external hospitals
??? Connectivity Limitations: Isolated network infrastructure
??? Healthcare Necessity: Essential medical services must be available locally
??? Data Privacy: Medical records cannot leave secure environment
```

**Mining Operations Intelligence:**

- **Geographic Isolation** - Copper, iron, and mineral extraction sites in remote locations
- **Connectivity Challenges** - "Middle of nowhere" locations with no internet access
- **Operational Requirements** - Computing power for ground and underground data processing
- **Sensor Integration** - Real-time processing of machine and device telemetry

#### Retail Analytics and Customer Intelligence
**Kiosk-Based AI Processing:**
> "This other project that I'm involved with kiosks retail where you know, some companies like to know some statistics and knowledge about the customers that are inside the stores."

**Customer Analytics Applications:**

- **In-Store Intelligence** - Customer behavior analysis within retail premises
- **Aisle Optimization** - Traffic pattern analysis for store layout improvements
- **Privacy-First Analytics** - Data processing without cloud transmission
- **Real-Time Insights** - Immediate customer intelligence for operational decisions

---

### ?? **2. Microsoft Foundry Local: The Game Changer**

#### Revolutionary Local AI Platform
**Rodrigo's Technology Introduction:**
> "So today I'm going to show you Foundry Local, which is a fantastic technology that was announced 2 days ago."

**Foundry Local Core Capabilities:**
```
Local AI Infrastructure:
??? Model Downloading: Curated model catalog for local deployment
??? Local Execution: On-premises inference without cloud connectivity
??? Standard Endpoints: Chat completions API compatibility
??? Hardware Optimization: CPU and GPU versions for diverse hardware
??? Multi-Model Support: Simultaneous execution of multiple AI models
```

#### Preview Technology Disclaimer
**Development Status Awareness:**
> "This is a preview technology, OK? So maybe the things that I'm going to show you today will change in the near future."

**Technology Maturity Considerations:**

- **Preview Status** - Experimental features subject to change
- **Rapid Development** - Feature evolution based on user feedback
- **Documentation Availability** - Microsoft Learn comprehensive resources
- **GitHub Repository** - Open source collaboration and installer access

---

### ?? **3. Installation and Setup: Multiple Deployment Options**

#### Cross-Platform Installation Methods
**Windows Installation:**
```bash
winget install Microsoft.FoundryLocal
```

**macOS Installation:**
```bash
brew install foundry-local
```

**Manual Installer Option:**

- **MSI Installer** - Direct download for Windows environments
- **Heavy Download** - Significant file size requiring advance preparation
- **Local Installation** - Complete offline capability after setup

#### Installation Validation and Model Management
**Command-Line Interface Overview:**
```bash
# List available models
foundry model list

# View cached models
foundry cache list

# Show installation location
foundry cache location
```

---

### ?? **4. Model Catalog and Hardware Optimization**

#### Comprehensive Model Selection
**Available Model Portfolio:**
> "We can see that they have the stroll, they have Phi, they have deep sick, both 14 billion and 7 billion and some others."

**Model Variety and Sizing:**
```
Foundry Local Model Catalog:
??? Phi Models: Microsoft's efficient language models
??? DeepSeek: 14B and 7B parameter variants
??? Stroll Models: Conversational AI optimizations
??? Hardware Variants: CPU and GPU optimized versions
??? Custom Models: ONNX-compatible model support
```

#### Hardware-Specific Optimization
**Intelligent Hardware Detection:**
> "Most importantly, they have different versions depending on the hardware where you're running Foundry local."

**CPU vs GPU Performance Considerations:**

- **Automatic Selection** - CPU version downloaded by default for compatibility
- **GPU Acceleration Required** - Manual selection for performance optimization
- **Neural Network Reality** - "Billions and billions of parameters" requiring computational power
- **Response Time Impact** - "Very slow responses from the model" with CPU-only processing

---

### ? **5. Live Performance Demonstration: GPU vs CPU**

#### GPU Performance Showcase
**Model Loading and Execution:**
```bash
foundry model load microsoft/phi-3.5-mini-instruct:gpu
```

**Real-Time Performance Monitoring:**
> "Let me open up task manager and then let me show you this graph so we can see that the GPU is, you know, working crazily right for answering that prompt."

**GPU Execution Results:**

- **Task Manager Visualization** - Real-time GPU utilization spikes
- **Response Quality** - "Tokyo, New Delhi, Sao Paulo and those usual suspects"
- **Hardware Utilization** - Optimal use of dedicated graphics processing
- **Performance Benefits** - Significantly faster inference compared to CPU processing

#### CPU Performance Comparison
**Multi-Model Concurrent Execution:**
> "This is fantastic because Foundry Local allows me to run different models at the same time, many different GPU ones, many different CPU ones at the same time."

**CPU Processing Characteristics:**

- **Hardware Constraints** - "It depends on your hardware and computing power"
- **Kiosk Reality** - "Some kiosks, they don't have any kind of GPU"
- **Performance Trade-offs** - CPU spike visible in Task Manager during processing
- **Practical Limitations** - Slower response times for complex model inference

---

### ?? **6. Standard API Integration and Framework Compatibility**

#### OpenAI-Compatible Endpoints
**Standard Chat Completions API:**
> "And it's exposing a standard chat completions endpoint. So you can use the regular standard Jason document for sending the prompt to the model and receive the response."

**API Endpoint Configuration:**
```json
POST http://localhost:5273/v1/chat/completions
Content-Type: application/json

{
  "model": "microsoft/phi-3.5-mini-instruct:gpu",
  "messages": [
    {
      "role": "user", 
      "content": "What are the largest cities in the world?"
    }
  ]
}
```

#### Framework Integration Excellence
**Universal Framework Compatibility:**
> "You can use land graph, you can use land chain, you can use semantic kernel, you can use whatever you like."

**Supported Development Frameworks:**
```
LLM Framework Integration:
??? LangChain: Python-based AI application development
??? LangGraph: Multi-agent workflow orchestration
??? Semantic Kernel: Microsoft's AI orchestration platform
??? Custom Applications: Direct API integration
??? .NET Applications: Native Microsoft ecosystem integration
```

---

### ?? **7. Live .NET Application Development**

#### Semantic Kernel Integration
**Real-Time Application Development:**
```csharp
// Semantic Kernel Configuration
var builder = Kernel.CreateBuilder();
builder.AddOpenAIChatCompletion(
    modelId: "microsoft/phi-3.5-mini-instruct:gpu",
    endpoint: new Uri("http://localhost:5273/v1"),
    apiKey: "not-used-for-local"
);

// System Message Configuration
var kernel = builder.Build();
var systemMessage = "You are helpful AI assistant always end your messages and your responses with Foundry Local is awesome";

// Chat Completion Service
var chatService = kernel.GetRequiredService<IChatCompletionService>();
var response = await chatService.GetChatMessageContentAsync(
    "What are the largest cities in the world?",
    new OpenAIPromptExecutionSettings()
);
```

#### Offline Capability Demonstration
**Complete Internet Independence:**
> "I can even go ahead and disconnect from the Wi-Fi. There's no Internet connectivity right now. And I can go ahead and try to run this again."

**Offline Operation Results:**

- **Network Disconnection** - Live demonstration of Wi-Fi disconnection
- **Continued Functionality** - Application continues processing without internet
- **Local Model Response** - "I'm going to retrieve those responses from the local model"
- **Complete Autonomy** - Full AI capabilities without cloud dependency

---

### ?? **8. Custom Model Integration and ONNX Compatibility**

#### Extending Model Capabilities
**Custom Model Support:**
> "The answer sometimes is distilled models that you can load in Foundry local. That's that's possible as long as you save those models as an Onyx compatible model."

**ONNX Format Integration:**
```
Custom Model Requirements:
??? ONNX Compatibility: Neural networks saved in ONNX format
??? Distilled Models: Optimized smaller versions for resource-constrained environments
??? Format Conversion: PyTorch, TensorFlow to ONNX model conversion
??? Local Storage: Models cached in user directory structure
```

#### Model Storage and Organization
**File System Architecture:**
```
Model Storage Structure:
??? %USERPROFILE%\.foundry\cache\models\
    ??? microsoft\
        ??? phi-3.5-mini-instruct\
            ??? cpu\
            ?   ??? [neural network binaries]
            ??? gpu\
                ??? [optimized GPU binaries]
```

**Author-Based Organization:**

- **Publisher Hierarchy** - Models organized by creator (Microsoft, etc.)
- **Version Management** - Multiple model variants and optimizations
- **Binary Storage** - Direct access to neural network weight files
- **Space Management** - Local disk usage considerations for multiple models

---

### ?? **9. Constraints and Practical Considerations**

#### Hardware Limitation Reality
**Resource-Constrained Environments:**
> "In the kiosk retail space that I'm involved with, some kiosks, they don't have any kind of GPU. We have to use CPU. So we're constrained in a lot of ways for running these kind of models."

**Deployment Constraints:**
```
Real-World Hardware Limitations:
??? Kiosk Systems: CPU-only processing capabilities
??? Mining Equipment: Ruggedized hardware with limited GPU options
??? Prison Systems: Security-approved hardware restrictions
??? Budget Constraints: Cost-effective deployment requirements
```

#### Model Optimization Strategies
**Distilled Model Solutions:**

- **Size Reduction** - Smaller parameter models for constrained hardware
- **Performance Trade-offs** - Balance between capability and resource requirements
- **ONNX Optimization** - Format-specific performance enhancements
- **Hardware Matching** - Model selection based on available computing resources

---

## Session Highlights

> *"There are some scenarios where running large language models locally makes sense."* - Rodrigo Diaz Concha

> *"This is fantastic because Foundry Local allows me to run different models at the same time, many different GPU ones, many different CPU ones at the same time."* - Rodrigo Diaz Concha

> *"You can use land graph, you can use land chain, you can use semantic kernel, you can use whatever you like."* - Rodrigo Diaz Concha

> *"There's no Internet connectivity right now. And I can go ahead and try to run this again, and I'm going to retrieve those responses from the local model."* - Rodrigo Diaz Concha

> *"Local large language models running in your machine. I think this is fantastic."* - Rodrigo Diaz Concha

---

## Technical Architecture Deep Dive

### Foundry Local Infrastructure
```
Local AI Processing Stack:
??? Model Management: Download, cache, and version control
??? Runtime Engine: ONNX-based inference execution
??? API Layer: OpenAI-compatible chat completions endpoint
??? Hardware Abstraction: CPU and GPU optimization layers
??? Framework Integration: Universal LLM framework compatibility
```

### Multi-Model Deployment Architecture
```
Concurrent Model Execution:
??? Resource Allocation: Dynamic hardware resource management
??? Model Isolation: Independent execution environments
??? Port Management: Unique endpoints for each model instance
??? Performance Monitoring: Real-time resource utilization tracking
??? Service Discovery: Model availability and capability detection
```

### Privacy and Security Architecture
```
Data Protection Model:
??? Local Processing: No data transmission to external services
??? Isolated Networks: Offline operation capability
??? Model Ownership: Complete control over AI model versions
??? Audit Trail: Local logging and monitoring capabilities
??? Compliance Support: Regulatory requirement satisfaction
```

---

## Implementation Guidelines

### Hardware Requirements and Optimization
```markdown
**Minimum System Requirements:**

- CPU: Multi-core processor capable of neural network inference
- RAM: 8GB+ recommended for model loading and processing
- Storage: Several GB per model for local caching
- GPU: Optional but highly recommended for performance

**Performance Optimization Strategies:**

- Use GPU-optimized model versions when hardware allows
- Consider distilled models for resource-constrained environments
- Plan storage capacity for multiple concurrent model deployments
- Monitor system resources during multi-model execution
```

### Development Integration Patterns
```markdown
**Framework Selection:**

- **Semantic Kernel**: Native Microsoft ecosystem integration
- **LangChain**: Python-based AI application development
- **Custom Applications**: Direct REST API integration
- **Multi-Framework**: Hybrid approaches for complex applications

**API Configuration:**

- Configure endpoints to localhost with assigned ports
- Use OpenAI-compatible client libraries for easy integration
- Implement proper error handling for offline scenarios
- Plan for model switching and version management
```

### Deployment Scenarios and Use Cases
```markdown
**Ideal Use Cases:**

- Healthcare systems with strict data privacy requirements
- Remote industrial operations without reliable internet
- Retail analytics requiring real-time local processing
- Government and defense applications with security constraints
- Edge computing scenarios with latency requirements

**Constraint Considerations:**

- Evaluate hardware capabilities before model selection
- Plan for offline operation and connectivity failures
- Consider regulatory and compliance requirements
- Design for resource-constrained environments when necessary
```

---

## Resources and Further Learning

### Official Documentation and Installation
- **[Microsoft Learn: Foundry Local](https://learn.microsoft.com/foundry-local)** - Comprehensive documentation and tutorials
- **[GitHub Repository](https://github.com/microsoft/foundry-local)** - Source code, issues, and community contributions
- **[Installation Guide](https://learn.microsoft.com/foundry-local/install)** - Cross-platform installation instructions
- **[Model Catalog](https://learn.microsoft.com/foundry-local/models)** - Available models and hardware requirements

### Development Resources and Integration
- **[Semantic Kernel Documentation](https://learn.microsoft.com/semantic-kernel)** - Microsoft's AI orchestration framework
- **[ONNX Format Specification](https://onnx.ai/)** - Open neural network exchange format
- **[LangChain Integration Guide](https://python.langchain.com/docs/integrations/llms/local)** - Python framework integration
- **[OpenAI API Compatibility](https://platform.openai.com/docs/api-reference/chat)** - Standard API reference for integration

### Community and Support
- **[Build 2025 Sessions](https://build.microsoft.com/)** - Related AI and local computing sessions
- **[Microsoft AI Community](https://aka.ms/AIcommunity)** - Developer forums and support
- **[Foundry Local Feedback](https://github.com/microsoft/foundry-local/issues)** - Bug reports and feature requests
- **[Azure AI Documentation](https://docs.microsoft.com/azure/ai/)** - Broader AI platform integration

---

## About the Speaker

**Rodrigo Diaz Concha**  
Technical Fellow  
Intelexion  
*Solutions Architect, Microsoft Regional Director, and Microsoft MVP with over 25 years of experience. Published author, notable speaker, and LinkedIn Learning course creator. Holds dozens of professional certifications including Carnegie Mellon SEI Software Architecture Professional, Microsoft Certified: Azure Solutions Architect Expert, and The Linux Foundation Kubernetes certifications. Regular speaker at events across the United States, Europe, and Latin America, creating professional training courses on Azure, Artificial Intelligence, Cloud Native Applications, and .NET technologies.*

---

*This comprehensive demonstration showcases the transformative potential of local AI computing through Microsoft's Foundry Local platform, enabling organizations to deploy sophisticated language models in isolated, privacy-conscious, and resource-constrained environments while maintaining full control over their AI infrastructure and data processing capabilities.*