# An Overview of Windows AI Foundry: Local AI Development and Deployment

**Session Date:** May 19, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK223  
**Speakers:** Tucker Burns (GPM, Windows Platform + Developer Team), Dian Hartono (Product Manager Lead, Windows Developer Platform Team)  
**Link:** [Microsoft Build 2025 Session BRK223]

![Windows AI Foundry Platform](images/windows-ai-foundry-overview.png)

---

## Executive Summary

This comprehensive session introduces Windows AI Foundry, Microsoft's complete platform for local AI development on Windows. The session demonstrates three key components: Windows ML for custom model execution, Windows AI APIs for ready-to-use AI capabilities, and Foundry Local for open-source model deployment. Through extensive live demonstrations, Tucker Burns and Dian Hartono showcase how developers can leverage on-device AI across CPU, GPU, and NPU hardware while maintaining flexibility between local and cloud deployment models.

---

## Key Topics Covered

### ?? **1. The Case for Local AI: Beyond Cloud-Only Solutions**

#### The Turning Point for Client-Side AI
**Tucker's Opening Statement:**
> "We are at a turning point for local AI. Some applications will only run cloud models, while others will only run them locally, yet others will prefer a hybrid approach. We believe that power comes in flexibility."

#### Key Drivers for Local AI Adoption

**Compliance and Privacy Requirements:**

- **GDPR compliance** - Data sovereignty and user control
- **HIPAA regulations** - Healthcare data protection requirements
- **DMA compliance** - Digital Markets Act data handling rules
- **Full data control** - Models run without data leaving the device

**Performance and User Experience:**

- **Zero network latency** - Critical for real-time applications
- **Sensor proximity** - Audio, video, and input processing benefits
- **High availability** - Operations without internet dependency
- **Cost optimization** - Local models don't need cloud-scale infrastructure

**Power Efficiency and Background Processing:**

- **NPU utilization** - Dedicated neural processing units for efficient AI workloads
- **Proactive processing** - Constantly running models without performance impact
- **New experience classes** - Background AI capabilities enabling innovative features

### ?? **2. Windows AI Foundry Architecture: Three-Pillar Platform**

#### Comprehensive AI Development Stack
```
Windows AI Foundry
??? Windows AI APIs: Ready-to-use inbox models
??? Foundry Local: Open-source model catalog and execution
??? Windows ML: Foundation layer for custom models
```

**Strategic Platform Benefits:**

- **Built-in and third-party model support** - Flexibility in model selection
- **Versatile development environment** - Multiple approaches for different use cases
- **Cross-silicon compatibility** - CPU, GPU, NPU execution across hardware vendors
- **Hybrid deployment options** - Seamless switching between local and cloud inference

---

### ?? **3. Windows ML: The Foundation Layer**

#### Public Preview Announcement
**Major Release:** Windows ML now available in public preview

**Core Capabilities:**

- **ONNX Runtime powered** - Industry-standard model execution framework
- **Cross-silicon execution** - CPU, GPU, NPU support with automatic optimization
- **Flexible model support** - PyTorch, custom models, Hugging Face catalog integration
- **Out-of-box runtime** - No binary embedding required, reduced application size

#### Developer Workflow and Tooling
**AI Toolkit for VS Code Integration:**
1. **Model conversion** - PyTorch to ONNX or silicon-specific formats
2. **Optimization scripts** - Pre-built optimizations for common architectures
3. **Custom optimization** - Starter templates for specialized model tuning
4. **Quality evaluation** - Built-in model testing and validation
5. **Application integration** - Windows ML NuGet package integration

#### Live Demo: AI Dev Gallery Image Classification
**Device Policy Demonstration:**

- **Manual control** - Explicit CPU, GPU, or NPU selection
- **Smart policies** - Automatic hardware selection based on optimization goals:
  - **Max efficiency** - Prioritizes power-efficient execution
  - **Max performance** - Optimizes for speed and throughput
  - **Minimize power** - Balances performance with battery life

**Technical Implementation:**
```csharp
// Core Windows ML Implementation Pattern
1. Reference infrastructure package
2. Download execution providers (via Microsoft Store)
3. Register execution providers with runtime
4. Set device selection policy
5. Compile model for target hardware
6. Execute inference with optimized model
```

#### Developer Feedback and Impact
**Industry Testimonials:**

- **Development timeline reduction** - "5x faster" deployment across silicon platforms
- **Integration simplification** - Reduced complexity for ISVs and enterprise developers
- **Time-to-market improvement** - Weeks reduced to days for multi-platform AI deployment

---

### ?? **4. Windows AI APIs: Ready-to-Use AI Capabilities**

#### Inbox Model Integration
**Distribution and Management:**

- **Windows Update delivery** - Models distributed via OS updates
- **Copilot+ PC optimization** - Enhanced performance on new hardware
- **API abstraction layer** - Developers don't need to manage underlying models
- **WinApp SDK delivery** - Integrated into standard Windows development frameworks

#### Comprehensive API Portfolio
**Vision APIs:**

- **Image Super Resolution** - Intelligent image scaling and enhancement
- **Image Segmentation** - Background removal and object isolation
- **Object Erase** - Selective content removal from images
- **Image Description** - Natural language image analysis and captioning
- **Text Recognition (OCR)** - Text extraction from images and documents

**Language APIs:**

- **Text Generation** - Phi Silica-powered content creation
- **Conversation Summarization** - Key point extraction and meeting summaries
- **Content Moderation** - Automatic content safety and compliance checking

#### Live Demo: Image Description API
**Real-World Comparison:**
```
Human Description: "A simple one-bedroom apartment"
AI Model Output: "The image shows a simple, minimalistic floor plan of a 
small apartment or studio with a kitchenette, one bedroom, and one bathroom."
```

**Development Integration Flow:**
1. **API capability check** - Verify model availability on device
2. **Model instantiation** - Create API instance with required parameters
3. **API invocation** - Execute model inference with input data
4. **Result processing** - Handle structured output from AI model
5. **Visual Studio export** - Direct integration into development projects

### ??? **5. Customization and Fine-Tuning Capabilities**

#### Two-Track Customization Strategy
**LoRA Fine-Tuning:**

- **Lightweight adaptation** - Nudge models toward specific domains or tones
- **Company voice optimization** - Align output with organizational communication style
- **Workflow specialization** - Adapt models for specific business processes
- **Technical terminology** - Enhanced understanding of domain-specific language

**Knowledge Retrieval (RAG):**

- **Semantic search powered** - Intelligent information retrieval from local data
- **Private knowledge grounding** - Answers based on proprietary documents and content
- **Dynamic content handling** - Real-time access to changing information
- **Multi-modal support** - Text, image, and document integration

#### Live Demo: LoRA Fine-Tuning Workflow
**AI Toolkit Integration:**
1. **Project creation** - Define fine-tuning objectives and model selection
2. **Dataset preparation** - Training and test data for custom scenarios
3. **Azure integration** - Cloud-based training with local model deployment
4. **Evaluation and testing** - Quality assessment through AI Dev Gallery
5. **Production deployment** - Seamless integration into applications

**Use Case: Feedback Categorization**
```
Input: "This app is awesome, but it needs a better Get Started icon"
Before fine-tuning: Generic response
After LoRA adapter: Categorized as "Compliment + Feature Request"
```

#### Live Demo: Knowledge Retrieval (RAG)
**Contoso Note App Implementation:**

- **Multi-modal content** - Text documents, images, and mixed media indexing
- **Semantic search** - Meaning-based rather than keyword-based retrieval
- **Natural language queries** - "Find me a vegetarian recipe and turn it vegan"
- **Contextual responses** - Relevant images and content alongside text answers

### ?? **6. Foundry Local: Open-Source Model Ecosystem**

#### Public Preview Features
**Azure AI Foundry Integration:**

- **Extensive model catalog** - Pre-optimized models for local execution
- **Cross-platform compatibility** - CPU, NPU, GPU support across hardware vendors
- **Extensible platform** - Support for multiple model catalogs beyond Azure
- **No complex setup** - `WinGet install Microsoft.FoundryLocal` for immediate access

#### Command-Line Interface Capabilities
**Developer-Friendly Tools:**
```bash
# Check available models for current hardware
foundry model list

# Download and run model locally
foundry model run <model-name>

# Check cached models on device
foundry model cache

# Interactive chat mode
foundry model run phi-4-mini-reasoning
```

#### Live Demo: Reasoning Model Execution
**Local Inference Example:**
```
Query: "Tucker has one computer. There are four total. How many does Dian have?"
Model Response: Step-by-step logical reasoning with final answer
Hardware: Local NPU execution with real-time processing
```

#### SDK and API Integration
**Seamless Cloud-to-Local Migration:**
```javascript
// Cloud endpoint configuration
const cloudEndpoint = "https://api.azure.com/openai";
const cloudModel = "phi-4-reasoning";

// Local endpoint with three lines of code
import { FoundryLocalManager } from 'foundry-local-sdk';
const manager = new FoundryLocalManager();
const localEndpoint = await manager.getEndpoint("phi-4-mini");
```

**Model Management Benefits:**

- **Single instance sharing** - Multiple applications share one model copy
- **Automatic optimization** - Hardware-specific performance tuning
- **Storage efficiency** - Reduced disk usage across applications
- **Memory management** - Intelligent loading and unloading of models

---

## Technical Architecture Deep Dive

### Hardware Acceleration Strategy
**Cross-Silicon Support:**

- **Intel** - CPU and integrated graphics optimization
- **AMD** - Ryzen processors and Radeon GPU acceleration
- **NVIDIA** - CUDA and Tensor Core utilization
- **Qualcomm** - NPU-optimized execution for Snapdragon platforms

### Model Deployment Pipeline
**End-to-End Model Lifecycle:**
```
Model Selection ? Optimization ? Local Deployment ? Runtime Execution
??? Azure AI Foundry Catalog
??? AI Toolkit preprocessing
??? Windows ML runtime
??? Hardware-specific acceleration
```

### Security and Privacy Architecture
**On-Device Processing Benefits:**

- **Zero data transmission** - All processing occurs locally
- **Compliance alignment** - GDPR, HIPAA, DMA requirements met by design
- **Enterprise control** - IT policies can govern local AI usage
- **Audit capabilities** - Complete visibility into AI operations

---

## Live Demonstration Results

### AI Dev Gallery Showcase
**Image Classification Performance:**

- **Real-time inference** across CPU, GPU, NPU hardware
- **Dynamic policy adjustment** for power vs. performance optimization
- **Visual Studio integration** with one-click project export
- **Cross-platform model compatibility** testing

### Windows AI APIs Integration
**Image Description Accuracy:**

- **Detailed spatial analysis** - Room layout and furniture recognition
- **Contextual understanding** - Apartment type and feature identification
- **Natural language output** - Human-readable descriptions
- **Real-time processing** - Sub-second inference on local hardware

### Foundry Local Performance
**Multi-Model Support:**

- **Quin, Phi, Mistral, DeepSeek** - Diverse model ecosystem
- **Reasoning capabilities** - Complex logical problem solving
- **Interactive chat modes** - Real-time conversation interfaces
- **Resource optimization** - Shared models across applications

## Industry Impact and Adoption

### Developer Community Feedback
**Quantified Benefits:**

- **5x faster development** - From weeks to days for multi-platform deployment
- **Timeline reduction** - Massive cuts in development cycles
- **Integration simplification** - Reduced complexity for ISVs
- **Market acceleration** - Faster time-to-market for AI features

### Production Deployments
**Windows Features Powered by AI APIs:**

- **Click to Do** - Enhanced user interaction capabilities
- **Windows Search improvements** - Intelligent search and discovery
- **Outlook email summarization** - On-device conversation analysis
- **Gaming content creation** - Real-time highlight reel generation

### Web Standards Integration
**Microsoft Edge and Browser Support:**

- **Prompting APIs** - Web-based AI interaction capabilities
- **Writing assistance** - Browser-native AI-powered content creation
- **Web standards proposal** - Industry-wide API standardization efforts
- **Cross-platform compatibility** - Consistent AI experiences across environments

---

## Session Highlights

> *"We are at a turning point for local AI... We believe that power comes in flexibility."* - Tucker Burns

> *"With power efficient NPUs, you can run models proactively or constantly in the background with no regrets. This enables a new class of experiences."* - Tucker Burns

> *"Windows ML cuts dev timelines massively, letting us focus on delighting gamers."* - Developer Testimonial

> *"Five times faster... we spent two weeks just getting our AI feature to work on NPUs. With Windows ML we got everything working on three different chip platforms in just three days."* - Luyan Zhang, Filmora

> *"For us, the Holy Grail is being able to take a single high precision model and have it just work seamlessly across the range of Windows silicon."* - Aidan Fitzpatrick, Rewind AI

---

## Implementation Guide

### Getting Started with Windows ML

#### 1. Development Environment Setup
```markdown
**Required Tools:**

- Visual Studio or VS Code with AI Toolkit extension
- Windows 11 with latest updates
- Windows ML NuGet package
- AI Dev Gallery from Microsoft Store

**Basic Implementation Pattern:**
1. Reference Microsoft.AI.MachineLearning package
2. Download execution providers via downloadPackagesAsync()
3. Register execution providers with runtime
4. Set device selection policy (CPU/GPU/NPU)
5. Compile model for target hardware
6. Execute inference with optimized performance
```

#### 2. Windows AI APIs Integration
```csharp
// Image Description API Pattern
// 1. Check model availability
if (ImageDescriptionModel.IsSupported())
{
    // 2. Create model instance
    var model = await ImageDescriptionModel.CreateAsync();
    
    // 3. Process input with required parameters  
    var result = await model.DescribeImageAsync(imageData);
    
    // 4. Handle structured output
    ProcessDescription(result.Description);
}
```

#### 3. Foundry Local Setup
```bash
# Installation and basic usage
winget install Microsoft.FoundryLocal

# Browse available models
foundry model list

# Download and run specific model
foundry model run phi-4-mini-reasoning

# Check local model cache
foundry model cache
```

### Best Practices for Production Deployment

#### Hardware Optimization Strategy
- **NPU prioritization** for power-efficient background processing
- **GPU utilization** for compute-intensive inference workloads  
- **CPU fallback** ensuring compatibility across all hardware configurations
- **Dynamic policy adjustment** based on battery status and performance requirements

#### Model Selection and Management
- **Inbox APIs** for common scenarios requiring no model management
- **Windows ML** for custom models requiring specialized optimization
- **Foundry Local** for open-source models with cross-application sharing
- **Hybrid deployment** combining local inference with cloud capabilities

#### Development Workflow Optimization
- **AI Dev Gallery** for rapid prototyping and capability exploration
- **Visual Studio integration** for seamless project creation and deployment
- **Azure AI Toolkit** for model conversion, optimization, and fine-tuning
- **Cross-platform testing** ensuring compatibility across silicon vendors

---

## Advanced Applications

### Enterprise AI Deployment
**IT Management Capabilities:**

- **Group policy integration** for enterprise AI governance
- **Model distribution** through existing Windows Update infrastructure  
- **Compliance monitoring** for regulated industries and data handling
- **Performance analytics** for optimization and resource planning

### Developer Productivity Enhancement
**Integrated Development Experience:**

- **One-click model integration** from AI Dev Gallery to Visual Studio
- **Automatic hardware optimization** without manual configuration
- **Shared model libraries** reducing application size and complexity
- **Real-time testing** with immediate feedback on model performance

### Innovative User Experience Patterns
**New Application Categories:**

- **Proactive AI assistants** running continuously with NPU efficiency
- **Real-time content creation** without cloud dependency or latency
- **Privacy-preserving analytics** with complete on-device processing
- **Offline-first AI applications** maintaining functionality without internet access

---

## Resources and Further Learning

### Official Documentation
- **[Windows AI Documentation](https://aka.ms/WindowsAI)** - Comprehensive developer resources and API references
- **[AI Toolkit for VS Code](https://marketplace.visualstudio.com/vscode-ai-toolkit)** - Model optimization and development tools
- **[AI Dev Gallery](https://aka.ms/AIDevGallery)** - Sample applications and interactive demos

### Development Tools
- **[Windows ML NuGet Package](https://www.nuget.org/packages/Microsoft.AI.MachineLearning)** - Core runtime and APIs
- **[WinApp SDK](https://docs.microsoft.com/windows/apps/windows-app-sdk/)** - Windows AI APIs integration
- **[Foundry Local](winget install Microsoft.FoundryLocal)** - Open-source model management and execution

### Additional Build 2025 Sessions
- **Windows ML Deep Dive** - Advanced implementation patterns and optimization
- **Windows AI APIs Workshop** - Hands-on development with inbox models  
- **Foundry Local Architecture** - Technical details and deployment strategies
- **AI Workstation Optimization** - Hardware selection and configuration guidance

### Community Engagement
- **Email feedback:** Windows AI team contact for scenarios and requirements
- **Build booth visits** - AI Workstation demonstrations and expert consultations
- **Labs and breakouts** - Hands-on experience with fine-tuning and customization

---

## About the Speakers

**Tucker Burns**  
GPM, Windows Platform + Developer Team  
Microsoft  
*Group Program Manager focusing on AI initiatives within the Windows Developer Platform, leading the strategic direction for local AI capabilities and developer experience optimization.*

**Dian Hartono**  
Product Manager Lead, Windows Developer Platform Team  
Microsoft  
*Product Manager Lead specializing in enabling developers to build AI experiences on Windows, with focus on API design, developer workflows, and cross-platform compatibility.*

---

*This session establishes Windows AI Foundry as Microsoft's comprehensive platform for local AI development, demonstrating how developers can leverage on-device AI capabilities across diverse hardware while maintaining the flexibility to integrate with cloud services. The combination of ready-to-use APIs, custom model support, and open-source ecosystem access positions Windows as the premier platform for hybrid AI application development.*

