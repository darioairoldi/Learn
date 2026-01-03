# Bring Your Own Model to Windows using Windows ML

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK225  
**Speakers:** Ryan Demopoulos (Principal Product Manager, Microsoft), Xiaoxi Han (Senior Software Engineer, Microsoft)  
**Link:** [Microsoft Build 2025 Session BRK225]

![Windows ML 2.0](images/windows-ml-bring-your-own-model.png)

---

## Executive Summary

Ryan Demopoulos and Xiaoxi Han unveil Windows ML 2.0 Experimental 1, a complete ground-up redesign of Microsoft's AI inferencing framework for Windows. This session demonstrates how developers can achieve unprecedented hardware scalability across CPU, GPU, and NPU with a single codebase, automated dependency management, and intelligent device selection policies. The live coding demonstration showcases building a ResNet-50 image classification app from scratch, while Powder's real-world implementation proves the platform's production readiness for AI-native gaming experiences.

---

## Key Topics Covered

### ?? **1. The Windows AI Revolution**

#### Windows Ecosystem Dominance
**Ryan's Opening Vision:**
> "Windows powers the vast majority of desktop and laptop PCs all around the world. That alone is sometimes staggering to think about... when you apply it to the revolution in AI that we are seeing all across the world, it really means that that AI revolution is going to unfold on Windows more than any other place."

**Hardware Diversity Challenge:**

- **Range:** $300 laptops to $3,000+ high-performance desktops
- **Silicon Variety:** Multiple NPU manufacturers, diverse GPU architectures, CPU variations
- **Developer Burden:** Targeting hardware diversity traditionally complex and time-consuming
- **Windows ML Goal:** Write once, run optimally everywhere across all hardware configurations

#### The Three Core Objectives
**Developer Empowerment Framework:**
1. **Cross-Hardware Scalability** - Single codebase running across all Windows hardware diversity
2. **Performance Maximization** - Optimal utilization of each individual PC's capabilities
3. **Dependency Simplification** - Eliminate complex dependency management, procurement, and updates

---

### ?? **2. Live Hardware Demonstration: One App, Four Platforms**

#### Multi-Device Performance Showcase
**Identical ResNet-50 Application Running Across:**
```
Hardware Platform Matrix:
??? Surface Laptop 7 (Qualcomm Snapdragon NPU)
??? Intel Surface Device (Lunar Lake NPU)
??? AMD Machine (AMD NPU)
??? Dell Alienware (NVIDIA RTX 4090 GPU)
```

**Demonstration Results:**

- **Same executable** - 2MB app size across all platforms
- **Automatic hardware detection** - No device-specific configuration required
- **Optimal performance** - Each platform utilizing best available processor
- **Unified prediction results** - 99%+ confidence golden retriever classification across all devices

#### Cross-Silicon Intelligence
**Windows ML's Platform Adaptability:**

- **NPU Diversity** - Three different manufacturers, different chip designs, automatic optimization
- **GPU Integration** - Seamless fallback to discrete graphics for maximum performance
- **CPU Compatibility** - Universal baseline ensuring compatibility on any Windows 11 PC
- **Future Hardware Support** - Automatic compatibility with unreleased silicon architectures

---

### ??? **3. Windows ML 2.0 Architecture: Built from Ground Up**

#### From DirectML to Complete Redesign
**The Performance Imperative:**
> "We need something in the platform that's faster, faster in two different ways. First, just wall clock faster, something that can strip away the layers and the abstractions between your app code and the silicon... But we also need the platform to be able to move at the speed of AI innovation."

**Windows AI Foundry Integration:**
```
Windows AI Foundry Architecture:
??? Windows ML Runtime (Core inferencing engine)
??? Foundry Local (Ready-to-use catalog models)
??? Built-in Windows AI APIs (OCR, text intelligence, etc.)
??? Public APIs (Direct Windows ML access)
??? Hardware Certification Program (IHV partnership)
```

#### ONNX Runtime Foundation
**Technical Infrastructure:**

- **Open Standard ONNX Models** - Mature, fast inferencing runtime with proven performance
- **20%+ Performance Improvement** - Typical inference gains after ONNX conversion
- **PyTorch Conversion** - Direct path from PyTorch training to Windows deployment
- **Execution Provider Architecture** - Translation layer between runtime and diverse silicon

#### Execution Provider Innovation
**Hardware Abstraction Excellence:**

- **Dedicated GPU Providers** - Optimized for wide range of GPU hardware
- **Refreshed NPU Providers** - Partnership-developed with hardware manufacturers
- **CPU Excellence** - ONNX's proven CPU support for universal compatibility
- **First-Class Treatment** - Each processor type treated as primary target, not fallback

---

### ?? **4. Dependency Management Revolution**

#### The Current Developer Pain Point
**Xiaoxi's Problem Statement:**
> "The status quo today is that you also need to grab an AI runtime out of the sea of complex options, and that runtime becomes part of your app, where the burden of maintaining it falls on you... It's just the norm, and it sucks."

**Traditional Complexity:**
```
Legacy Dependency Management:
??? Runtime Selection: Choose from complex AI runtime options
??? Hardware Add-ons: ONNX execution providers for specific hardware
??? Model Variants: Multiple model copies optimized for different processors
??? Installer Logic: Complex hardware detection and model selection
??? Maintenance Burden: Updates, patches, compatibility testing
```

#### Windows ML Simplified Approach
**One NuGet Package Solution:**
```
Streamlined Development:
??? Single NuGet: Microsoft.Windows.AI.MachineLearning
??? Automatic Runtime: Bootstrapper API installs Windows ML runtime
??? Store Servicing: Microsoft handles runtime updates and fixes
??? Hardware Scanning: Automatic execution provider downloads
??? Model Resource Packs: Microsoft Store automatic model selection
```

**Intelligent Resource Management:**

- **Hardware-Specific Downloads** - Only necessary execution providers downloaded per device
- **Minimal App Size** - No bundled execution providers or multiple model variants
- **Store Integration** - Model variants with hardware metadata for automatic selection
- **Zero Installer Logic** - No complex hardware detection required in application code

---

### ? **5. Device Policies: Intelligent Performance Optimization**

#### Smart Workload Distribution
**Ryan's Performance Philosophy:**
> "Device policies are basically a way for you to describe what outcome you want when you run your AI workload with Windows ML."

**Policy Options and Behavior:**
```
Windows ML Device Policies:
??? Max Performance: Select discrete GPU for fastest inference
??? Min Overall Power: Choose NPU for battery optimization
??? Default/Unspecified: CPU for universal compatibility and accuracy
??? Explicit Selection: Direct NPU/GPU specification when desired
??? Future: Workload Splitting across multiple processors
```

#### Live Policy Demonstration
**Real-Time Hardware Switching:**

- **CPU Baseline** - Universal compatibility demonstration
- **GPU Engagement** - Task Manager showing graphics engine activation
- **NPU Utilization** - Neural processing unit spike demonstration
- **One-Line Changes** - Single property modification redirects entire workload

#### Future Workload Splitting
**Multi-Processor Coordination:**

- **Single AI Workload** - Distributed across multiple processor types
- **Maximum Performance** - Utilize all available hardware simultaneously
- **Device Policy Integration** - Seamless integration with existing policy system
- **Performance Multiplication** - Greater than sum-of-parts optimization

---

### ?? **6. Live Coding Demonstration: ResNet-50 from Scratch**

#### AI Toolkit VS Code Extension
**Model Conversion Innovation:**
> "We have just added a new functionality to it that makes this much easier... What this tool does is it provides a streamlined experience to get a model from Hugging Face, convert it to ONNX, optimize, and quantize it."

**Model Lab Capabilities:**
```
AI Toolkit New Features:
??? Hugging Face Integration: Direct model sourcing
??? ONNX Conversion: Automatic format transformation  
??? Optimization: IHV-specific performance tuning
??? Quantization: Size and power consumption optimization
??? 11 Popular Models: Pre-optimized for Windows ML
```

**Hardware-Specific Optimization Workflows:**

- **Convert to QNN** - Qualcomm NPU optimization
- **Convert to AMD NPU** - AMD-specific neural processing optimization
- **Convert to Intel NPU** - Intel neural processing unit tuning
- **Future Convergence** - Single model working optimally across all NPUs

#### Complete Application Development
**From Zero to AI in Minutes:**
```csharp
// Initialization
var infrastructure = new Infrastructure();
await infrastructure.DownloadPackagesAsync();
await infrastructure.RegisterExecutionProviderLibrariesAsync();

// Session Creation with Policy
var sessionOptions = new SessionOptions();
sessionOptions.DeviceSelectionPolicy = DeviceSelectionPolicy.MaxPerformance;
var session = new InferenceSession(modelPath, sessionOptions);

// Inference
var results = session.Run(inputTensor);
```

**Live Development Results:**

- **Hardware Detection** - Automatic Qualcomm NPU utilization
- **Performance Switching** - GPU engagement with single property change
- **Power Optimization** - NPU selection for battery conservation
- **Cross-Platform Guarantee** - Same code working on AMD, Intel, NVIDIA hardware

#### Model Compilation API
**Performance Optimization:**

- **Pre-compilation** - Avoid runtime compilation delays for large models
- **Disk Caching** - Save compiled models for instant loading
- **Multi-gigabyte Models** - Essential for LLM and complex AI workloads
- **Seamless Integration** - Optional optimization with minimal code changes

---

### ?? **7. Industry Partnership and Certification Program**

#### Hardware Vendor Collaboration
**Certification Program Vision:**
> "As these manufacturers bring new hardware to market, at the same time, they will either refresh or create new execution providers to coincide with that new hardware... You don't have to change any of your app code."

**Partner Ecosystem:**
```
IHV Partnership Program:
??? NVIDIA: GPU and future hardware optimization
??? AMD: NPU and graphics integration
??? Intel: Neural processing and CPU optimization
??? Qualcomm: Snapdragon NPU development
??? Certification Process: Quality assurance and accuracy testing
```

#### Hardware Partner Testimonials
**Manish Sirdeshmukh (Hardware Perspective):**
> "The Windows ML runtime offers exactly that by auto install of the runtime and execution providers specific to the hardware it's running on. ISVs do not need to select EPs at compile time."

**Jesse Clayton (NVIDIA):**
> "Windows ML helps Nvidia and other hardware vendors deliver optimizations to ISVs and users, while reducing the barriers to adoption."

---

### ????? **8. Developer Partner Success Stories**

#### Enterprise Adoption Feedback
**Volker Rölke (Adobe Premier Pro/After Effects):**
> "Premier Pro and After Effects are leading professional video editing applications that often handle terabytes of video footage. Our goal is to adopt the new Windows ML once it matures enough to handle the heavy ML workloads."

**Carl Woodward (Development Perspective):**
> "We look forward to replacing model load and inference code from multiple SDKs with Windows ML. This will simplify our code and testing whenever runtimes update."

#### Rapid Development Success
**Luyan Zhang (Simplicity Achievement):**
> "The simplicity amazed me. Following Microsoft easy approach, get an ONNX model, add it to your app, and integrate it into your code, we converted a complex AI feature to Windows ML in just three days."

**Barthélémy Kiss (Powder Strategic Advantage):**
> "Powder is an early adopter of Windows ML, and it has enabled us to integrate models three times faster, transforming speed into a key strategic advantage."

---

### ?? **9. Powder: Real-World AI Gaming Application**

#### Automatic Gameplay Highlight Detection
**Barthélémy's AI-Native Vision:**
> "We transform gameplay into highlights automatically. How does it work? You just play. We record, find great moments, and package them for sharing... It's the kind of AI-native experience that just starts to be possible."

**Powder Technical Achievement:**
```
AI Gaming Platform:
??? Real-Time Analysis: Live gameplay AI model execution
??? Semantic Understanding: Audio and visual game comprehension
??? Cross-Hardware Deployment: Single model across all NPUs
??? Zero SDK Integration: No game developer modification required
??? Automatic Content Creation: AI-generated highlight reels
```

#### Live Gaming Demonstration
**Technical Implementation:**

- **AMD Strix Halo** - ASUS Z30 Copilot+ PC demonstration
- **Level Completion Detection** - Custom AI model trained for game events
- **Background Processing** - Vision model running continuously during gameplay
- **Instant Results** - Two level completions detected and packaged automatically
- **Cinematic Highlights** - 40 minutes of Skull and Bones condensed to key moments

#### Business Impact and Scale
**Small Team Achievement:**

- **15-Person Team** - 10 developers achieving enterprise-grade AI deployment
- **Cross-Silicon Success** - "We do the work once, and it works everywhere"
- **Deployment Simplification** - No deep silicon knowledge required
- **Strategic Advantage** - 3x faster integration enabling competitive differentiation

---

## Session Highlights

> *"Windows powers the vast majority of desktop and laptop PCs all around the world... that AI revolution is going to unfold on Windows more than any other place."* - Ryan Demopoulos

> *"The status quo today is that you also need to grab an AI runtime out of the sea of complex options... It's just the norm, and it sucks."* - Xiaoxi Han

> *"We need something in the platform that's faster, faster in two different ways. First, just wall clock faster... But we also need the platform to be able to move at the speed of AI innovation."* - Ryan Demopoulos

> *"The simplicity amazed me... we converted a complex AI feature to Windows ML in just three days."* - Luyan Zhang (Developer Partner)

> *"We do the work once, and it works everywhere."* - Barthélémy Kiss (Powder)

---

## Technical Architecture Deep Dive

### Windows ML 2.0 Core Components
```
Runtime Architecture:
??? ML Layer: Initialization APIs, Generative AI helpers (WinRT with C/managed projections)
??? ONNX Runtime Layer: Full ONNX Runtime API surface via flat C APIs
??? Execution Providers: Hardware-specific optimization layers
??? Device Policies: Intelligent workload distribution system
??? Certification Program: IHV partnership ensuring future compatibility
```

### Development Integration Stack
```
Developer Experience:
??? Single NuGet Package: Microsoft.Windows.AI.MachineLearning
??? AI Toolkit VS Code Extension: Model conversion and optimization
??? Automatic Dependency Management: Runtime and execution provider downloads
??? Store Integration: Model resource packs with hardware metadata
??? GitHub Resources: Sample code and documentation
```

### Hardware Compatibility Matrix
```
Supported Platforms:
??? NPU Support: Qualcomm Snapdragon, Intel Lunar Lake, AMD Strix
??? GPU Support: NVIDIA RTX series, AMD graphics, Intel integrated
??? CPU Support: Universal compatibility across all Windows 11 PCs
??? Future Hardware: Automatic compatibility through certification program
??? Performance Optimization: Hardware-specific execution providers
```

---

## Implementation Guidelines

### Getting Started with Windows ML 2.0
```markdown
**Prerequisites:**

- Windows 11 PC with any supported hardware (CPU minimum)
- Visual Studio with .NET target framework 10.0.26100.0
- AI Toolkit VS Code Extension for model conversion
- Microsoft.Windows.AI.MachineLearning NuGet package

**Basic Implementation Steps:**
1. Install Windows ML NuGet package
2. Initialize Infrastructure object for runtime setup
3. Download applicable execution providers automatically
4. Create InferenceSession with device policy
5. Run inference with ONNX model
```

### Performance Optimization Strategies
```markdown
**Device Policy Selection:**

- **Max Performance**: Discrete GPU utilization for fastest inference
- **Min Overall Power**: NPU selection for battery-optimized applications
- **Default**: CPU for universal compatibility and highest accuracy
- **Explicit Hardware**: Direct NPU/GPU specification when requirements known

**Model Optimization:**

- Use AI Toolkit VS Code Extension for hardware-specific optimization
- Implement model compilation API for large models (LLMs, complex networks)
- Leverage quantization for size and power consumption reduction
- Consider hardware-specific model variants through Store resource packs
```

### Enterprise Deployment Considerations
```markdown
**Production Readiness:**

- Current release is Experimental 1 - not for production use
- Windows ML 2.0 Stable planned for later 2025
- Feedback essential for stable release timeline and feature completeness
- Consider pilot programs with Experimental 1 for evaluation

**Hardware Planning:**

- Future hardware automatically supported through certification program
- No application updates required for new silicon compatibility
- Investment protection through forward compatibility guarantee
- Performance improvements delivered automatically through execution provider updates
```

---

## Resources and Further Learning

### Official Documentation and Tools
- **[Try Windows ML](https://aka.ms/TryWinML)** - Documentation and getting started guides
- **[Windows ML Build Repository](https://aka.ms/WinMLBuildRepo)** - Sample applications in C#, Python, C++
- **[AI Toolkit VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-windows-ai-studio.windows-ai-studio)** - Model conversion and optimization
- **[Windows AI Foundry Overview](https://docs.microsoft.com/windows/ai/)** - Complete AI platform documentation

### Community and Support
- **[The Hub Expert Meetups](https://aka.ms/BuildTheHub)** - Direct access to Windows AI team at Build
- **[GitHub Issues](https://github.com/microsoft/windows-ml)** - Bug reports and feature requests
- **[Windows AI Feedback](mailto:windowsai@microsoft.com)** - General Windows AI Foundry feedback
- **[Feedback Hub](https://aka.ms/FeedbackHub)** - Windows feedback collection

### Related Build Sessions
- **[BRK223: Windows AI Foundry Overview](https://aka.ms/Build25_BRK223)** - Platform comprehensive overview
- **[BRK155: Azure AI Foundry](https://aka.ms/Build25_BRK155)** - Cloud AI platform integration
- **[Windows AI APIs Session](https://aka.ms/Build25_WindowsAI)** - May 21, 3:00-4:00 PM detailed API coverage

---

## About the Speakers

**Ryan Demopoulos**  
Principal Product Manager  
Microsoft  
*18-year Product Manager veteran on Windows development platform, currently focused on Windows AI platform technologies. Previously worked on WinUI, Windows App SDK, and various Windows platform components. Passionate about curling, family, and gaming (Dota 2, roguelike deck builders).*

**Xiaoxi Han**  
Senior Software Engineer  
Microsoft  
*Senior Software Engineer focused on Windows AI platform technologies. Previously worked on Windows Subsystem for Android, PC Game Pass, and other Windows technologies. Deep expertise in AI runtime development and cross-platform optimization.*

---

*This comprehensive session demonstrates Microsoft's commitment to democratizing AI development on Windows through intelligent platform design, automatic hardware optimization, and unprecedented developer experience simplification. Windows ML 2.0 represents a fundamental shift toward write-once, run-everywhere AI applications with optimal performance across the entire Windows hardware ecosystem.*

