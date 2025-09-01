# An Overview of Windows AI Foundry: Local AI Development and Deployment

**Session Date:** May 19, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK223  
**Speakers:** Tucker Burns (GPM, Windows Platform + Developer Team), Dian Hartono (Product Manager Lead, Windows Developer Platform Team)  
**Link:** [Microsoft Build 2025 Session BRK223](https://mybuild.microsoft.com/sessions/BRK223)

---

## Table of Contents

- [Introduction: The Case for Local AI](#introduction-the-case-for-local-ai)
  - [Why Local AI Matters](#why-local-ai-matters)
  - [Windows AI Foundry Platform Overview](#windows-ai-foundry-platform-overview)
- [Windows ML: The Foundation Layer](#windows-ml-the-foundation-layer)
  - [Public Preview Announcement](#public-preview-announcement)
  - [Developer Experience and Tooling](#developer-experience-and-tooling)
  - [Live Demo: AI Dev Gallery](#live-demo-ai-dev-gallery)
- [Windows AI APIs: Ready-to-Use AI Capabilities](#windows-ai-apis-ready-to-use-ai-capabilities)
  - [Inbox Model Integration](#inbox-model-integration)
  - [API Portfolio and Capabilities](#api-portfolio-and-capabilities)
  - [Live Demo: Image Description API](#live-demo-image-description-api)
- [Customization and Fine-Tuning](#customization-and-fine-tuning)
  - [LoRA Fine-Tuning](#lora-fine-tuning)
  - [Knowledge Retrieval (RAG)](#knowledge-retrieval-rag)
  - [Live Demo: Fine-Tuning Workflow](#live-demo-fine-tuning-workflow)
- [Foundry Local: Open-Source Model Ecosystem](#foundry-local-open-source-model-ecosystem)
  - [Platform Capabilities](#platform-capabilities)
  - [Command-Line Interface](#command-line-interface)
  - [Live Demo: Local Model Execution](#live-demo-local-model-execution)
- [AI Workstations and Hardware Optimization](#ai-workstations-and-hardware-optimization)
- [Call to Action and Resources](#call-to-action-and-resources)
- [Appendix](#appendix)
- [References](#references)

---

## Introduction: The Case for Local AI

**Timeframe:** 00:00:30 - 7m 15s  
**Speakers:** Tucker Burns, Dian Hartono

### Why Local AI Matters

Tucker Burns opens the session by establishing the fundamental premise that **we are at a turning point for local AI**. The presentation begins with a critical insight: running AI models exclusively in the cloud is not always optimal. With the miniaturization of AI models and advances in silicon capability, client-side AI processing has become increasingly viable and necessary.

The speakers identify four key drivers for local AI adoption:

#### 1. Compliance and Data Privacy

The evolving regulatory landscape presents specific challenges:

- **GDPR (General Data Protection Regulation)** requirements for data sovereignty
- **HIPAA (Health Insurance Portability and Accountability Act)** compliance in healthcare
- **DMA (Digital Markets Act)** data handling regulations
- **Complete data control** - models run without data ever leaving the device

#### 2. Performance and User Experience

Local processing offers significant advantages:

- **Zero network latency** - critical for real-time applications
- **Sensor proximity benefits** - audio, video, and input processing optimizations
- **High availability** - operations without internet dependency
- **Cost optimization** - reduced cloud infrastructure requirements

#### 3. Power Efficiency and Background Processing

Modern hardware enables new capabilities:

- **NPU utilization** - Neural Processing Units designed for efficient AI workloads
- **Proactive processing** - models running continuously without performance impact
- **New experience classes** - background AI capabilities enabling innovative features

#### 4. Hybrid Flexibility

The ultimate goal is flexibility between deployment models:

- Cloud-only applications for massive scale requirements
- Local-only applications for privacy and performance
- Hybrid approaches leveraging the best of both worlds

### Windows AI Foundry Platform Overview

Tucker Burns introduces Windows AI Foundry as Microsoft's comprehensive solution for local AI development. The platform is built on three foundational pillars:

```text
Windows AI Foundry Architecture
├── Windows AI APIs: Ready-to-use inbox models
├── Foundry Local: Open-source model catalog and execution
└── Windows ML: Foundation layer for custom models
```

This three-tier approach provides developers with complete flexibility in how they implement AI capabilities, from simple API calls to complex custom model deployment.

---

## Windows ML: The Foundation Layer

**Timeframe:** 00:07:45 - 18m 30s  
**Speakers:** Tucker Burns (primary), Dian Hartono (supporting)

### Public Preview Announcement

Tucker Burns announces the **public preview availability of Windows ML**, marking a significant milestone in Microsoft's local AI strategy. Windows ML serves as the foundational layer upon which both Windows AI APIs and Foundry Local are built.

#### Core Technical Capabilities

**ONNX Runtime Integration:**

- Industry-standard model execution framework
- Cross-silicon compatibility (CPU, GPU, NPU)
- Support for PyTorch models and Hugging Face catalog
- Out-of-box runtime reducing application binary size

**Hardware Acceleration Strategy:**

- **Intel** - CPU and integrated graphics optimization
- **AMD** - Ryzen processors and Radeon GPU acceleration  
- **NVIDIA** - CUDA and Tensor Core utilization
- **Qualcomm** - NPU-optimized execution for Snapdragon platforms

### Developer Experience and Tooling

The Windows ML development workflow integrates seamlessly with existing developer tools:

#### AI Toolkit for VS Code Integration
1. **Model Conversion** - PyTorch to ONNX or silicon-specific formats
2. **Optimization Scripts** - Pre-built optimizations for common architectures
3. **Custom Optimization** - Starter templates for specialized model tuning
4. **Quality Evaluation** - Built-in model testing and validation
5. **Application Integration** - Windows ML NuGet package integration

#### Implementation Pattern
```csharp
// Core Windows ML Implementation Workflow
1. Reference Microsoft.AI.MachineLearning package
2. Download execution providers via downloadPackagesAsync()
3. Register execution providers with runtime
4. Set device selection policy (CPU/GPU/NPU)
5. Compile model for target hardware
6. Execute inference with optimized performance
```

### Live Demo: AI Dev Gallery

Tucker demonstrates the **AI Dev Gallery**, a Microsoft Store application that showcases Windows AI Foundry capabilities. The demo focuses on image classification using a custom model.

#### Device Policy Demonstration

The demo highlights Windows ML's intelligent hardware selection capabilities:

**Manual Control Options:**

- Explicit CPU execution
- Explicit GPU execution  
- Explicit NPU execution

**Smart Policy Options:**

- **Max Efficiency** - Prioritizes power-efficient execution
- **Max Performance** - Optimizes for speed and throughput
- **Minimize Power** - Balances performance with battery life

#### Technical Implementation Details

The demo reveals the underlying code structure:

```csharp
// Key Implementation Steps Demonstrated
1. Reference infrastructure package
2. Download execution providers (via Microsoft Store)
3. Register execution providers with runtime
4. Set device selection policy
5. Compile model for target hardware
6. Execute inference with optimized model
```

#### Developer Testimonials

The session includes video testimonials from early adopters highlighting quantified benefits:
- **"5x faster development"** - Luyan Zhang, Filmora
- **Weeks to days** deployment timeline reduction
- **Cross-platform compatibility** with minimal code changes
- **Simplified ISV integration** reducing time-to-market

---

## Windows AI APIs: Ready-to-Use AI Capabilities

**Timeframe:** 00:26:15 - 15m 45s  
**Speakers:** Dian Hartono (primary), Tucker Burns (supporting)

### Inbox Model Integration

Dian Hartono explains that Windows AI APIs are built on top of **inbox models** distributed through Windows Update and optimized for Copilot+ PCs. These APIs provide abstraction layers so developers don't need to manage underlying models directly.

#### Distribution and Management Architecture
- **Windows Update delivery** - Models distributed via OS updates
- **Copilot+ PC optimization** - Enhanced performance on new hardware
- **API abstraction layer** - Consistent interface regardless of underlying model versions
- **WinApp SDK integration** - Native integration with Windows development frameworks

### API Portfolio and Capabilities

The comprehensive API suite covers both vision and language processing:

#### Vision APIs
- **Image Super Resolution** - Intelligent image scaling and enhancement
- **Image Segmentation** - Background removal and object isolation  
- **Object Erase** - Selective content removal from images
- **Image Description** - Natural language image analysis and captioning
- **Text Recognition (OCR)** - Text extraction from images and documents

#### Language APIs
- **Text Generation** - Phi Silica-powered content creation
- **Conversation Summarization** - Key point extraction and meeting summaries
- **Content Moderation** - Automatic content safety and compliance checking

### Live Demo: Image Description API

Dian demonstrates the Image Description API through the AI Dev Gallery, showcasing the complete developer workflow from exploration to implementation.

#### Development Integration Process
1. **API Capability Check** - Verify model availability on device
2. **Model Instantiation** - Create API instance with required parameters
3. **API Invocation** - Execute model inference with input data
4. **Result Processing** - Handle structured output from AI model
5. **Visual Studio Export** - Direct integration into development projects

#### Practical Demonstration Results

The demo includes a humorous comparison between human and AI image description:

**Human Description (Tucker):** "A simple one-bedroom apartment"

**AI Model Output:** "The image shows a simple, minimalistic floor plan of a small apartment or studio with a kitchenette, one bedroom, and one bathroom."

This comparison demonstrates the AI's superior attention to detail and comprehensive analysis capabilities.

---

## Customization and Fine-Tuning

**Timeframe:** 00:42:00 - 12m 20s  
**Speakers:** Dian Hartono (primary), Tucker Burns (supporting)

### LoRA Fine-Tuning

Dian introduces **Low-Rank Adaptation (LoRA)** as a lightweight method for customizing inbox models. LoRA allows developers to "nudge" models toward specific domains, tones, or organizational communication styles without requiring full model retraining.

#### Use Cases for LoRA Fine-Tuning
- **Company Voice Optimization** - Align output with organizational communication style
- **Workflow Specialization** - Adapt models for specific business processes
- **Technical Terminology** - Enhanced understanding of domain-specific language
- **Tone Adjustment** - Modify model personality and response style

### Knowledge Retrieval (RAG)

**Retrieval-Augmented Generation (RAG)** enables models to ground their responses in private, local knowledge bases.

#### RAG Implementation Benefits
- **Semantic Search Powered** - Intelligent information retrieval from local data
- **Private Knowledge Grounding** - Answers based on proprietary documents and content
- **Dynamic Content Handling** - Real-time access to changing information
- **Multi-Modal Support** - Text, image, and document integration

### Live Demo: Fine-Tuning Workflow

Dian demonstrates the complete fine-tuning workflow using AI Toolkit for VS Code, focusing on a feedback categorization use case.

#### LoRA Training Process
1. **Project Creation** - Define fine-tuning objectives and model selection
2. **Dataset Preparation** - Training and test data for custom scenarios
3. **Azure Integration** - Cloud-based training with local model deployment
4. **Evaluation and Testing** - Quality assessment through AI Dev Gallery
5. **Production Deployment** - Seamless integration into applications

#### Practical Example: Feedback Categorization

**Input:** "This app is awesome, but it needs a better Get Started icon"

**Before Fine-Tuning:** Generic response handling
**After LoRA Adapter:** Properly categorized as "Compliment + Feature Request"

This demonstrates how fine-tuning enables models to understand nuanced business contexts and provide more accurate, actionable insights.

---

## Foundry Local: Open-Source Model Ecosystem

**Timeframe:** 00:54:20 - 8m 40s  
**Speakers:** Tucker Burns (primary), Dian Hartono (supporting)

### Platform Capabilities

Tucker introduces **Foundry Local** as Microsoft's solution for running open-source language models locally on Windows. The platform integrates with Azure AI Foundry while supporting extensible model catalogs.

#### Key Features
- **Azure AI Foundry Integration** - Pre-optimized models for local execution
- **Cross-Platform Compatibility** - CPU, NPU, GPU support across hardware vendors
- **Extensible Platform** - Support for multiple model catalogs beyond Azure
- **Simple Installation** - `WinGet install Microsoft.FoundryLocal` for immediate access

### Command-Line Interface

Foundry Local provides developer-friendly command-line tools for model management:

```bash
# Core Commands Demonstrated
foundry model list          # Check available models for current hardware
foundry model run <name>    # Download and run model locally
foundry model cache         # Check cached models on device
foundry model run phi-4-mini-reasoning  # Interactive chat mode
```

#### SDK and API Integration

The platform enables seamless migration from cloud to local inference:

```javascript
// Cloud Endpoint Configuration
const cloudEndpoint = "https://api.azure.com/openai";
const cloudModel = "phi-4-reasoning";

// Local Endpoint with Minimal Code Changes
import { FoundryLocalManager } from 'foundry-local-sdk';
const manager = new FoundryLocalManager();
const localEndpoint = await manager.getEndpoint("phi-4-mini");
```

### Live Demo: Local Model Execution

Tucker demonstrates real-time local model execution with reasoning capabilities:

**Query:** "Tucker has one computer. There are four total. How many does Dian have?"
**Model Response:** Step-by-step logical reasoning with final answer
**Hardware:** Local NPU execution with real-time processing

#### Resource Optimization Benefits
- **Single Instance Sharing** - Multiple applications share one model copy
- **Automatic Hardware Optimization** - Performance tuning for specific silicon
- **Storage Efficiency** - Reduced disk usage across applications
- **Intelligent Memory Management** - Automatic loading and unloading of models

---

## AI Workstations and Hardware Optimization

**Timeframe:** 01:03:00 - 2m 15s  
**Speakers:** Dian Hartono

Dian briefly introduces **Windows AI Workstations** as optimized hardware solutions for AI development. She explains that AI model performance is shaped by the entire lifecycle: training, fine-tuning, and inferencing.

### Hardware Selection Strategy
- **GPU Selection** - Optimized for training and intensive inference workloads
- **NPU Utilization** - Efficient background processing and real-time inference
- **Cloud Integration** - Hybrid approaches combining local and cloud resources
- **Development Workflow** - Hardware matching specific development stages

The AI Workstation Booth at Build 2025 provides hands-on experience with optimized hardware configurations.

---

## Call to Action and Resources

**Timeframe:** 01:05:15 - 1m 45s  
**Speakers:** Dian Hartono

Dian concludes with specific actionable steps for developers:

### Immediate Next Steps
1. **Explore Documentation** - Visit aka.ms/WindowsAI for comprehensive resources
2. **Provide Feedback** - Share scenarios and requirements with the Windows AI team
3. **Attend Build Sessions** - Multiple Windows AI Foundry breakouts, labs, and booth visits
4. **Install Tools** - AI Dev Gallery, AI Toolkit for VS Code, Foundry Local

### Community Engagement
- **Email Feedback** - Direct communication with Windows AI team for scenarios and requirements
- **Build Booth Visits** - AI Workstation demonstrations and expert consultations
- **Hands-on Labs** - Practical experience with fine-tuning and customization

---

## Appendix

### Technical Terminology Reference

**ONNX (Open Neural Network Exchange):** Industry-standard format for representing machine learning models, enabling interoperability between different AI frameworks.

**NPU (Neural Processing Unit):** Specialized processor designed specifically for AI workloads, offering superior power efficiency compared to general-purpose processors.

**LoRA (Low-Rank Adaptation):** Fine-tuning technique that adapts pre-trained models to specific tasks by learning low-rank decompositions of weight updates.

**RAG (Retrieval-Augmented Generation):** AI technique that combines language generation with information retrieval from external knowledge sources.

### Session Production Details

**Technical Setup:** Live demonstrations required coordination between AI Dev Gallery, Visual Studio Code with AI Toolkit, and Foundry Local command-line interface.

**Demo Coordination:** Both speakers coordinated seamlessly during live demos, with Dian leading Windows AI APIs demonstrations and Tucker handling Windows ML and Foundry Local sections.

**Audience Interaction:** The session included spontaneous moments like the French Bulldog vs. Bernese Mountain Dog correction and the apartment description comparison, demonstrating genuine AI capability assessment.

### Industry Context and Competitive Landscape

The session positioned Windows AI Foundry within the broader context of local AI development trends, emphasizing Microsoft's unique approach of providing multiple pathways (APIs, custom models, open-source integration) rather than forcing developers into a single solution.

---

## References

### Official Microsoft Documentation
- **[Windows AI Documentation](https://aka.ms/WindowsAI)** - Comprehensive developer resources including API references, implementation guides, and best practices. Essential starting point for developers implementing Windows AI Foundry capabilities.

- **[AI Toolkit for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-windows-ai-studio.windows-ai-studio)** - Visual Studio Code extension providing model conversion, optimization, and fine-tuning capabilities. Critical tool for the complete Windows ML development workflow demonstrated in the session.

- **[Windows ML Documentation](https://docs.microsoft.com/windows/ai/windows-ml/)** - Technical documentation for the Windows ML platform, including API references and implementation patterns shown during the live demonstrations.

### Development Tools and Resources
- **[AI Dev Gallery (Microsoft Store)](https://aka.ms/AIDevGallery)** - Sample application showcasing Windows AI Foundry capabilities. Provides hands-on exploration of APIs and exportable project templates as demonstrated by both speakers.

- **[Windows ML NuGet Package](https://www.nuget.org/packages/Microsoft.AI.MachineLearning)** - Core runtime package for Windows ML development. Essential for implementing the device policies and cross-silicon optimization features shown in Tucker's demonstrations.

- **[WinApp SDK](https://docs.microsoft.com/windows/apps/windows-app-sdk/)** - Windows application development SDK including Windows AI APIs integration. Provides the abstraction layer for inbox models discussed by Dian Hartono.

### Industry Standards and Frameworks
- **[ONNX (Open Neural Network Exchange)](https://onnx.ai/)** - Industry-standard model format underlying Windows ML's cross-platform compatibility. Critical for understanding the model conversion and optimization processes demonstrated in the session.

- **[Hugging Face Model Hub](https://huggingface.co/models)** - Open-source model catalog referenced as a source for Windows ML model integration. Demonstrates the platform's commitment to open-source ecosystem support.

### Regulatory and Compliance Resources
- **[GDPR Compliance Guide](https://gdpr.eu/)** - European Union data protection regulation referenced as a key driver for local AI processing. Relevant for understanding privacy benefits of on-device model execution.

- **[HIPAA Security Rule](https://www.hhs.gov/hipaa/for-professionals/security/)** - Healthcare data protection requirements mentioned as compliance driver for local AI. Important context for healthcare applications of Windows AI Foundry.

### Hardware and Silicon Partners
- **[Intel AI Developer Resources](https://www.intel.com/content/www/us/en/developer/topic/ai/overview.html)** - Documentation for Intel CPU and GPU optimization supported by Windows ML cross-silicon strategy.

- **[Qualcomm AI Development](https://developer.qualcomm.com/software/qualcomm-neural-processing-sdk)** - NPU development resources for Snapdragon platforms supported by Windows AI Foundry's hardware acceleration approach.

### Related Build 2025 Sessions
- **Windows ML Deep Dive** - Advanced implementation patterns and optimization techniques building on concepts introduced in this overview session.

- **Foundry Local Architecture** - Technical deep dive into the open-source model management and execution platform demonstrated in the final section of this session.

- **AI Workstation Optimization** - Hardware selection and configuration guidance expanding on the brief AI Workstation introduction by Dian Hartono.

Each reference provides essential context for understanding and implementing the concepts demonstrated throughout the session, from foundational AI development principles to specific technical implementation details.
