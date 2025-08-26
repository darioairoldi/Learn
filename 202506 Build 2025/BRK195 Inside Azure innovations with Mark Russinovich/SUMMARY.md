# Inside Azure Innovations with Mark Russinovich

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK195  
**Speaker:** Mark Russinovich (CTO, Deputy CISO, Technical Fellow for Microsoft Azure)  
**Link:** [Microsoft Build 2025 Session BRK195]

![Azure Infrastructure Innovation](images/azure-innovations-russinovich.png)

---

## Executive Summary

Mark Russinovich delivers his signature "Inside Azure Innovations" session, showcasing cutting-edge infrastructure developments, cloud-native computing advances, and groundbreaking research initiatives. This comprehensive tour spans Azure Boost 2.0 performance enhancements, revolutionary storage scaling, Linux security innovations, confidential computing breakthroughs, and concludes with Microsoft Research's optical computing—the world's first analog optical computer demonstration at a major tech conference.

---

## Key Topics Covered

### ?? **1. Azure Infrastructure Innovation: Azure Boost 2.0**

#### The Evolution of Accelerated Computing
**Mark's Infrastructure Philosophy:**
> "You're moving all of that computing of storage and network and the data path onto accelerated hardware, and you're taking the control plane... off the host as well. You get a lot of benefits from doing this because now you're freeing up the server cores to actually do server things."

**Azure Boost 2.0 Architecture:**
```
Azure Boost 2.0 Card Components:
??? Dual 100-Gigabit Ports: Network connectivity with redundancy
??? FPGA (Center Block): Accelerated storage and networking offload
??? ARM Processor Complex: Control plane agents with dedicated DRAM
??? Isolation Benefits: Server cores freed for application workloads
```

#### Cloud-Leading Performance Metrics
**Storage and Network Achievements:**
- **Remote Disks:** 14 GB/s with 800K IOPS
- **Local SSD:** 36 GB/s with 6.6 million IOPS  
- **Network Bandwidth:** Up to 200 GB/s with 400K connections per second
- **Fleet Deployment:** 20% of Azure fleet with 100% new server installation

#### Infrastructure Resilience and Maintenance
**Operational Excellence:**
- **Dual top-of-rack router connections** - Failure tolerance without service interruption
- **Transparent maintenance** - Router upgrades with temporary single-link operation
- **Sub-second software updates** - Data plane upgrades without virtual machine impact
- **Strong isolation** - Boost components independent of server core operations

---

### ? **2. Revolutionary Networking: Guest RDMA Implementation**

#### Beyond Traditional TCP/IP Stack
**The Network Stack Problem:**
> "This is a lot of layers of packet encapsulation and retry logics and timing windows that slow down in the cases where you know these two applications are going to talk to each other and they want to share information very quickly."

**RDMA Direct Memory Access:**
```
Traditional Path: App ? TCP/IP ? Driver ? NIC ? [Network] ? NIC ? Driver ? TCP/IP ? App
RDMA Path: App Memory ? NIC ? [Network] ? NIC ? App Memory (Direct)
```

**GPU-to-GPU Direct Communication:**
- **GPUDirect RDMA** - Direct GPU memory to GPU memory transfer
- **AI Training Optimization** - AllReduce operations without CPU intervention
- **Weight Sharing Efficiency** - Direct GPU weight synchronization across network
- **Bypass Software Stack** - Eliminate network processing overhead

#### Live Performance Demonstration
**AllReduce Operation Results:**
- **Traditional Method:** 51,000 microseconds, 1.4 GB/s average bandwidth
- **Guest RDMA:** 4,600 microseconds, 14 GB/s average bandwidth
- **Performance Improvement:** **11x speed-up** for GPU-to-GPU communication
- **Production Impact:** Dramatically faster AI training and inference operations

---

### ?? **3. Advanced Update Technologies: Zero-Impact Maintenance**

#### Evolution of Azure Update Capabilities
**Update Technology Progression:**
```
Azure Update Evolution:
??? 2010s: Server Reboots (Full downtime)
??? Microcode Updates: Impact-less CPU updates
??? Live Migration: VM transition between servers
??? Hot Patching: Transparent hypervisor and driver updates
??? Hypervisor Hot Restart: State transfer between Hyper-V versions
??? Driver Hot Swap: Side-by-side driver replacement
```

#### VM-Preserving Host Update (VM-PHU) Innovation
**Virtual Processor Auto-Suspend and Keep-Alive:**
> "For the most part, the vast majority of virtual machines now through virtual machine-preserving host update will see zero impact."

**Advanced VM-PHU Features:**
- **Selective VM freezing** - Only VMs requiring virtualization stack assistance pause
- **Continuous I/O operations** - Storage and network operations continue during updates
- **Request pinning** - Virtualization-dependent requests queued during maintenance
- **Zero-impact majority** - Most VMs experience no service interruption

#### Live Demonstration Results
**Traditional VM-PHU vs. Advanced VM-PHU:**
- **Traditional:** Complete VM freeze during fast save/restore cycle
- **Advanced:** Continuous ping responses and application counting during maintenance
- **Operational benefit:** Virtualization stack restart transparent to running workloads
- **Fleet impact:** Dramatically reduced maintenance windows across Azure infrastructure

---

### ?? **4. Scaled Storage: Petabyte-Scale Performance**

#### AI Workload Storage Demands
**The Scale Challenge:**
> "Now you're talking about not terabytes or hundreds of terabytes of data. Now you're talking about petabytes, and in some cases, even up to hundreds of petabytes of data, especially for autonomous driving model training."

**AI Storage Requirements:**
- **Training Data:** Multi-modal models with video content requiring petabyte datasets
- **Model Checkpoints:** Terabyte-sized failure recovery points during training
- **Model Deployment:** Terabyte models distributed to thousands of inference servers
- **Cache Optimization:** Hot model caches across distributed GPU infrastructure

#### Scaled Storage Account Innovation
**Architecture and Performance:**
```
Scaled Storage Account:
??? Logical Abstraction: Single account interface
??? Physical Implementation: Slices across storage infrastructure
??? Network Utilization: Data center-wide bandwidth access
??? Node Distribution: Storage nodes across entire data center
??? Performance Result: Terabits/second throughput, hundreds of petabytes
```

#### Live 320-Server Demonstration
**Unprecedented Storage Performance:**
- **Cluster Configuration:** 320 servers with BlobFuse2 mounting
- **Parallel Write Test:** All servers writing simultaneously to single account
- **Peak Write Performance:** **15 terabits per second**
- **Peak Read Performance:** **25 terabits per second**
- **Customer Availability:** White-glove offering for extreme performance requirements

---

### ?? **5. Azure Linux and Security Innovations**

#### Microsoft's Linux Journey
**Historical Milestone Reflection:**
> "For me, was kind of a wow moment in my professional career, having been at Microsoft since 2006, back when Linux was not necessarily the operating system that Microsoft used a lot."

**Linux Evolution at Microsoft:**
- **2014:** Satya announces "Microsoft loves Linux"
- **2012:** Azure launches with Linux IaaS support  
- **2023:** Azure Linux distribution announcement
- **2025:** LinuxGuard security enhancements and upstream contributions

#### LinuxGuard: Container Security Innovation
**Code Integrity Challenge:**
> "By the way, I'm Deputy Chief Information Security Officer for Azure now, so this is burned into my head, to say to everybody all the time, is to make sure that only the approved binaries can run."

**LinuxGuard Security Stack:**
```
LinuxGuard Architecture:
??? DM-verity: Container image layer verification
??? SELinux: Security controls and access policies
??? IPE (Integrity Policy Enforcement): Signature verification
??? Container Registry Signatures: Layer-by-layer authentication
??? Immutable OS: Read-only operating system foundation
```

#### Live Security Demonstration
**Policy Enforcement Results:**
- **Unsigned executable rejection** - "hello-host" execution blocked on host
- **Container policy enforcement** - "hello-container" execution blocked in container
- **Audit logging** - Complete record of allowed/denied execution attempts
- **Upstream contribution** - IPE already part of standard Linux distributions

---

### ?? **6. Hostile Multi-Tenancy and Hyperlight Innovation**

#### Microsoft's Security Boundary Policy
**The Isolation Imperative:**
> "We came up with this term internally at Microsoft, hostile multi-tenancy... you have to assume it's hostile. It wants to do bad things, and that means we need to isolate it from the infrastructure."

**Approved Isolation Technologies:**
- **Hyper-V Virtual Machines** - Primary isolation for full applications
- **Hyper-V Isolated Containers** - LCOW and WCOW for container workloads  
- **Hyperlight Micro-VMs** - WebAssembly user-defined functions
- **Azure Front Door Integration** - Edge computing with micro-sandboxing

#### Hyperlight: Micro-VM Innovation
**WebAssembly Sandboxing Architecture:**
```
Hyperlight Micro-VM:
??? Size: Tens of megabytes (not hundreds/gigabytes)
??? Runtime: WebAssembly with WASI standard interfaces
??? Isolation: Hypervisor APIs creating micro virtual machines
??? Languages: Multi-language support through WASM compilation
??? Use Case: User-defined functions in storage and edge stacks
```

#### Azure Front Door Production Integration
**Edge Computing Demonstration:**
- **Image Processing Function** - Crop face functionality implemented in C (apologetically)
- **Micro-VM Execution** - Function running in Hyperlight sandbox at edge
- **Edge Optimization** - Processing before content reaches origin website
- **CNCF Contribution** - Open source release supporting both Hyper-V and KVM

---

### ?? **7. Serverless Container Innovation: ACI Scale**

#### Azure Container Instances (ACI) Evolution
**Microsoft's Serverless Container Leadership:**
> "We were the first company, hyperscaler cloud to come up with serverless containers with ACI... ACI is our future of our infrastructure."

**ACI Strategic Positioning:**
- **Serverless Focus** - Application and container focus, not infrastructure
- **Platform Orchestration** - Automatic application deployment and management
- **AKS Integration** - Virtual nodes for bursting from fixed pools
- **Standby Pools** - Low-latency scale-out with minimal cost

#### 10,000 Container Demonstration
**Massive Scale Deployment:**
```
Container Launch Test:
??? Target: 10,000 containers across 3 deployments
??? Configuration: 2,500 containers per deployment
??? Infrastructure: ACI standby pools for rapid provisioning
??? Content: Full-blown containers with operating systems and applications
??? Result: Complete deployment in under 2 minutes
```

**Performance Achievement:**
- **Scale:** 10,000 containers simultaneously launched
- **Time:** Under 2 minutes from initiation to completion
- **Infrastructure:** Serverless deployment without pre-provisioned nodes
- **Cost Efficiency:** Standby pools at fraction of running container cost

---

### ?? **8. Azure Incubations: Open Source Innovation**

#### Innovation Pipeline Strategy
**Mark's Incubation Philosophy:**
> "Azure Incubations, I started in 2016, it was, kind of, an accidental starting of an incubations team... one of the principles is open source, CNCF, open governance."

**Graduated CNCF Projects:**
- **KEDA (2023)** - Kubernetes Event-Driven Autoscaler
- **Copa/Copacetic (2023)** - Container image patching without rebuilds
- **Dapr (2024)** - Distributed application runtime (5-year journey)

#### Project Radius: Platform Engineering Revolution
**Multi-Cloud Application Deployment:**
```
Radius Benefits:
??? Team Collaboration: Focus on app architecture, not infrastructure
??? Infrastructure Binding: Deploy to arbitrary clouds and environments  
??? Dependency Visualization: Application resource relationship graphs
??? Recipe System: Environment-specific deployment configurations
??? Cloud Neutrality: AWS, Azure, on-premises deployment flexibility
```

**FINOS TraderX Demonstration:**
- **Reference Application** - Real trading application from financial consortium
- **Ratification Time** - One day to convert from Helm charts and bash scripts
- **Deployment Targets** - Both AKS and ACI container groups
- **Production Ready** - Multiple customers already in production deployment

#### Project Drasi: Reactive Programming Revolution
**Continuous Query Pattern:**
> "Those changes, those state changes you're interested in, you simply define as... a database query... when this happens, return this."

**Complex State Management Solved:**
```
Traditional Challenges:
??? Multiple Data Sources: Polling, change feeds, streaming
??? State Tracking: Remember what triggered, avoid duplicates
??? Complex Logic: Multi-condition, multi-source event correlation
??? Code Maintenance: Brittle logic across disparate systems

Drasi Solution:
??? Continuous Queries: Cypher/GraphQL query definitions
??? Automatic Source Management: Handle polling, feeds, streams
??? Result Set Changes: Notifications when query results change
??? Non-Event Detection: Timeout-based condition monitoring
```

**Curbside Pickup Demonstration:**
- **Multi-Database Query** - Order status (Postgres) + Car location (SQL)
- **Join Logic** - "Order ready AND car at curbside"
- **Instant Response** - SignalR UI updates when conditions satisfied
- **Non-Event Handling** - "Car waiting >10 seconds" timeout detection

---

### ??? **9. Confidential Computing: Protecting Data in Use**

#### The Complete Data Protection Lifecycle
**Mark's Security Vision:**
> "What's been missing is protecting it while it's in use, where the data's being processed, it's sitting there out in the open. And that means the hypervisor can get to it, the host operating system can get to it."

**Confidential Computing Evolution:**
```
Microsoft Confidential Computing Timeline:
??? 2015: "Confidential Computing" term coined by Microsoft
??? 2020s: Intel TDX, AMD SEV-SNP virtual machine support
??? 2023: NVIDIA confidential GPU integration
??? 2024: Multi-GPU confidential computing with NVLink
??? 2025: H200 GPU confidential computing preview
```

#### Trusted Execution Environments (TEEs)
**Hardware-Based Protection:**
- **Cryptographic Shield** - Hardware-protected execution environment
- **Attestation Quotes** - Cryptographic proof of code and data integrity
- **Key Release Decision** - Trust verification before data decryption
- **Threat Protection** - Defense against operators, hypervisors, malicious code

#### Multi-GPU Confidential Computing
**Enterprise AI Protection:**
- **ServiceNow Implementation** - Agentic flows with protected seller commission data
- **Multi-GPU Models** - H200 GPUs with confidential NVLink connections
- **Protected PCIe** - Confidential communication between CPU and GPUs
- **End-to-End Encryption** - Request encrypted to VM/GPU, processed confidentially, encrypted response

---

### ?? **10. The Future: Optical Computing Research**

#### Microsoft Research Cambridge Innovation
**The Optical Computing Vision:**
> "What if we could use free space optics to do compute? It would be so environmentally friendly because you could do it at room temperature and it's also at, pun intended, light speed."

**Optical Operations for Neural Networks:**
```
Light-Based Computing:
??? Multiplication: Optical filters as multiply operations
??? Addition: Light combination onto sensors as pixel addition
??? Neural Network Mapping: Addition/multiplication for AI computation
??? Environmental Benefits: Room temperature operation, energy efficient
```

#### World's First Analog Optical Computer
**Live Hardware Demonstration:**
- **Physical Computer** - Actual optical computing hardware from MSR Cambridge
- **Light Beam Output** - Visible computation result through optical processing
- **Component Architecture** - Micro LEDs (input), weights configuration, SIMA sensors
- **Digit Classification** - Neural network operations performed entirely with light
- **Research Stage** - Few thousand parameters, proof of concept for scaling

**Live Classification Results:**
- **Digit Recognition** - Numbers 0-9 classification through optical processing
- **Processing Speed** - Currently slower than electronic, optimization ongoing  
- **Neural Network Operations** - First demonstration of complete light-based AI computation
- **Future Potential** - Room temperature, light-speed AI processing capabilities

---

## Session Highlights

> *"What I'm going to be showing you is some things that we are about to ship, some things that we're shipping, some things that we might never ship."* - Mark Russinovich

> *"You're freeing up the server cores to actually do server things and not do this I/O kind of intensive processing."* - Mark Russinovich on Azure Boost 2.0

> *"For the most part, the vast majority of virtual machines now through virtual machine-preserving host update will see zero impact."* - Mark Russinovich

> *"We came up with this term internally at Microsoft, hostile multi-tenancy."* - Mark Russinovich on security philosophy

> *"Should be written in... Rust."* - Mark Russinovich (with audience participation) on secure systems programming

> *"As Deputy Chief Information Security Officer for Azure, that is the policy in Azure."* - Mark Russinovich on Rust adoption

---

## Technical Architecture Deep Dive

### Azure Boost 2.0 Infrastructure
```
Performance Enhancement Stack:
??? Data Plane Offload: FPGA-based storage and networking acceleration
??? Control Plane Separation: ARM cores handling connection setup
??? Server Core Liberation: CPU resources dedicated to applications
??? Redundant Connectivity: Dual 100Gb links to top-of-rack routers
??? Live Upgrades: Sub-second data plane updates without VM impact
```

### Scaled Storage Account Architecture
```
Petabyte Storage System:
??? Logical Interface: Single storage account abstraction
??? Physical Distribution: Slices across data center storage infrastructure  
??? Network Aggregation: Data center-wide bandwidth utilization
??? Performance Result: Terabits/second throughput capability
??? Use Case: AI training, model distribution, checkpoint storage
```

### Confidential Computing Stack
```
End-to-End Protection:
??? Hardware TEE: Intel TDX, AMD SEV-SNP, NVIDIA confidential GPUs
??? Attestation: Cryptographic proof of execution environment
??? Key Management: Trust-based data decryption authorization
??? Multi-GPU: Confidential NVLink and protected PCIe connections
??? Application Protection: Model IP, training data, multi-party scenarios
```

---

## Implementation Guidelines

### Infrastructure Optimization Strategies
```markdown
**Azure Boost 2.0 Benefits:**
- Leverage accelerated storage and networking for I/O intensive applications
- Plan for 11x improvement in GPU-to-GPU communication with Guest RDMA
- Design applications to benefit from freed server cores
- Expect transparent infrastructure updates with zero VM impact

**Scaled Storage Applications:**
- AI training pipelines requiring petabyte datasets
- Model distribution across thousands of inference servers
- Checkpoint storage for large-scale training operations
- High-throughput data processing workflows
```

### Security and Compliance Implementation
```markdown
**Confidential Computing Adoption:**
- Protect sensitive AI models and training data
- Enable multi-party computation scenarios
- Implement zero-trust architecture with hardware attestation
- Design for regulatory compliance with data-in-use protection

**LinuxGuard Security:**
- Implement container image signing workflows
- Deploy DM-verity for layer verification
- Use IPE policies for execution control
- Plan for immutable operating system deployments
```

### Cloud-Native Development Patterns
```markdown
**Project Radius Benefits:**
- Separate application architecture from infrastructure concerns
- Enable multi-cloud deployment with recipe-based configuration
- Visualize application dependencies and resource relationships
- Implement platform engineering practices at scale

**Drasi Reactive Programming:**
- Replace complex state tracking logic with continuous queries
- Handle multi-source data change scenarios declaratively  
- Implement non-event detection with timeout conditions
- Simplify reactive application development patterns
```

---

## Resources and Further Learning

### Official Documentation and Projects
- **[Azure Boost Documentation](https://docs.microsoft.com/azure/virtual-machines/azure-boost/)** - Performance features and capabilities
- **[Azure Confidential Computing](https://docs.microsoft.com/azure/confidential-computing/)** - TEE technologies and implementation
- **[Project Radius](https://radapp.io/)** - Open source platform engineering framework
- **[Project Drasi](https://drasi.io/)** - Continuous query and reactive programming platform

### Open Source Contributions
- **[Hyperlight on CNCF](https://github.com/hyperlight-dev/hyperlight)** - Micro-VM sandboxing technology
- **[KEDA](https://keda.sh/)** - Kubernetes event-driven autoscaling
- **[Dapr](https://dapr.io/)** - Distributed application runtime
- **[Copa/Copacetic](https://github.com/project-copacetic/copacetic)** - Container image patching

### Research and Innovation
- **[Microsoft Research Cambridge](https://www.microsoft.com/research/lab/microsoft-research-cambridge/)** - Optical computing and advanced research
- **[Azure Incubations](https://github.com/azure-incubations)** - Open source innovation pipeline
- **[LinuxGuard Security](https://github.com/microsoft/linuxguard)** - Container security enhancements

---

## About the Speaker

**Mark Russinovich**  
CTO, Deputy CISO, Technical Fellow  
Microsoft Azure  
*Widely recognized expert in distributed systems, operating systems and cybersecurity. Ph.D. in Computer Engineering from Carnegie Mellon University. Co-founded Winternals Software, joined Microsoft in 2006. Author of Windows Internals book series and cybersecurity thriller novels. Popular speaker at industry conferences and creator of Sysinternals tools.*

---

*This comprehensive session showcases Microsoft Azure's continued innovation across infrastructure, security, and emerging computing paradigms, demonstrating the platform's evolution from traditional cloud services to cutting-edge technologies that will define the future of distributed computing.*
