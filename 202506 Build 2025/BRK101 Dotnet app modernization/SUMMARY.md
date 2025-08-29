# AI-Powered .NET App Modernization: GitHub Copilot & Azure Migration Tools

**Session Date:** Microsoft Build 2025  
**Duration:** ~45 minutes  
**Venue:** Build 2025 Conference - BRK101  
**Speakers:** Scott Hunter (VP of Product, Azure Developer), Chester Husk (Product Manager, .NET Tools)  
**Link:** [Microsoft Build 2025 Session BRK101](https://build.microsoft.com/en-US/sessions/BRK101)

![.NET App Modernization](images/dotnet-modernization.png)

---

## Executive Summary

This session demonstrates how AI-powered tools are transforming .NET application modernization, featuring live demonstrations of GitHub Copilot-assisted upgrades and Azure migration capabilities. The speakers showcase the evolution from static analysis tools to intelligent, automated solutions that can perform complex code transformations with minimal developer intervention.

---

## Key Topics Covered

### 🚀 **1. The Imperative for .NET Upgrades**

**Core Concept:** Regular .NET upgrades are essential for performance, security, compliance, and ecosystem compatibility.

**Key Motivations:**
- **Performance gains** - Each release brings significant performance improvements
- **Security patches** - Monthly servicing releases include critical security fixes
- **Tooling enhancements** - New SDK capabilities and developer productivity features
- **Support lifecycle compliance** - LTS vs STS model requirements
- **Ecosystem alignment** - Community packages target newer frameworks

**Current State:**

- Many organizations still run .NET Framework applications
- Web Forms represent ~10% of legacy applications (hardest to migrate)
- Framework targeting remains supported for gradual transitions

---

### 🔄 **2. Upgrade vs. Modernization: Understanding the Spectrum**

**Upgrade (Point A → Point B):**
- Framework version migrations (.NET 6 → .NET 8 → .NET 9)
- Dependency updates and vulnerability patches
- Tooling and SDK transitions

**Modernization (Architectural Transformation):**
- Decomposition into microservices
- Migration to cloud-native patterns (Azure Functions, Container Apps)
- Adoption of new deployment models
- Integration with modern DevOps practices

**Business Benefits:**
- Cost reduction through cloud provider alignment
- Talent attraction and retention
- Scalability and operational efficiency

---

### 🛠️ **3. Traditional Tools: .NET Upgrade Assistant & Azure Migrate**

#### .NET Upgrade Assistant
**Capabilities:**
- **Analysis reporting** - Comprehensive project assessment with story point estimates
- **Multiple upgrade strategies** - In-place, side-by-side, incremental migration
- **NuGet Central Package Management** - Automatic package consolidation
- **SDK-style project conversion** - Modern project file transformation

**Supported Project Types:**
- ASP.NET Web Applications
- WPF and Windows Forms
- Console Applications and Class Libraries
- Azure Functions (with limitations)

#### Azure Migrate Application Code Assessment Tool
**Purpose:** Cloud readiness assessment and migration planning

**Features:**
- **Static code analysis** for Azure compatibility
- **Detailed remediation reports** with mandatory vs. optional fixes
- **Basic Copilot integration** for guidance (limited to documentation lookup)

**Limitations:** Generates extensive task lists requiring manual developer intervention

---

### 🤖 **4. AI-Powered Upgrade: GitHub Copilot for .NET Modernization**

**Core Innovation:** Intelligent, context-aware upgrades that learn from developer interventions.

#### Key Features
- **Dependency-aware analysis** - Understanding project relationships and package usage patterns
- **Automated execution** - Beyond analysis to actual code transformation
- **Human-in-the-loop learning** - Captures and reapplies developer fixes
- **Git integration** - Checkpoint commits for each transformation step
- **Editable upgrade plans** - Markdown-based plans that users can modify

#### Live Demonstration Highlights
**Scenario:** eShopOnWeb solution upgrade from .NET 6.0 → .NET 9.0

**Process Flow:**
1. **Interactive planning** - Copilot generates customizable upgrade strategy
2. **Vulnerability detection** - Automatic identification and resolution of security issues
3. **Automated execution** - Project-by-project transformation with real-time progress
4. **Error handling** - Intelligent recovery from compilation errors
5. **Learning integration** - Pattern recognition for future similar issues

**Results:** ~2.5 minutes active upgrade time for 8 projects with 80%+ automation

---

### 🌐 **5. AI-Assisted Modernization: Formula-Based Code Transformation**

**Concept:** Pre-built and custom "formulas" for large-scale code pattern migrations.

#### Formula System Architecture
- **Pre-built formulas** - Top 10 common migration patterns from AppCAT analysis
- **Custom formula creation** - Learn from developer examples to generate reusable patterns
- **Prompt-based implementation** - Editable transformation logic
- **Cross-project application** - Bulk changes across entire codebases

#### Live Demo: AWS S3 → Azure Blob Storage Migration
**Transformation scope:**
- Package references and imports
- API method calls and signatures
- Configuration settings (appsettings.json)
- Connection string formats
- Authentication mechanisms

**Developer Experience:**
- Plan review and approval workflow
- Real-time code transformation visualization
- Automatic build verification
- Style and convention preservation

---

### 📈 **6. Real-World Impact and Adoption**

#### Microsoft Internal Results
- **Teams and Xbox** - Significant upgrade acceleration
- **Diverse development pressures** - Different teams, different timelines
- **Reduced manual effort** - Hours of work compressed to minutes

#### Partner Success Stories
- **Enterprise customers** - 8-month migrations reduced to weeks
- **Legacy codebase modernization** - Automated pattern migrations
- **Developer productivity gains** - Focus shift to business logic vs. mechanical updates

---

### 🔮 **7. Future Roadmap and Vision**

#### Near-term Enhancements
- **Framework → Core migration support** - Bridge the final gap in upgrade tooling
- **Visual Studio Code integration** - Multi-editor support
- **Bulk/batch processing** - Automated organization-wide upgrades
- **Enhanced formula marketplace** - Shareable transformation patterns

#### Long-term Vision
- **Unified upgrade/modernization interface** - Seamless workflow integration
- **SRE agent integration** - Automated monitoring and upgrade triggering
- **Cross-language support** - Python, C++, JavaScript formula system
- **Ecosystem integration** - End-to-end DevOps automation

---

## Technical Architecture Insights

### AI Integration Points
- **Roslyn compiler integration** - Deep code understanding for error detection
- **LLM prompt engineering** - Context-aware transformation instructions
- **Pattern recognition** - Learning from successful developer interventions
- **Validation frameworks** - Automated testing and quality assurance

### Developer Experience Design
- **Transparency** - Visible plans, commits, and transformation steps
- **Control** - User approval workflows and modification capabilities
- **Feedback loops** - Continuous improvement from user interactions
- **Error recovery** - Graceful handling of edge cases and failures

---

## Session Highlights

> *"Any change is a breaking change for somebody, so we're sorry. Also, use these tools to help you migrate."* - Chet Husk

> *"It's amazing what Wi-Fi does for AI"* - Scott Hunter (during live demo challenges)

> *"In that minute-and-a-half... it already saved Chet probably an hour or multiple hours of time to go manually update all those projects by hand."* - Scott Hunter

---

## Practical Takeaways

### Immediate Actions
1. **Install GitHub Copilot App Modernization extension** - Available in public preview
2. **Assess current .NET Framework applications** - Use existing tools for analysis
3. **Establish testing infrastructure** - Better tests enable greater AI tool confidence
4. **Review upgrade strategies** - Plan gradual vs. bulk migration approaches

### Strategic Considerations
1. **AI tool adoption curve** - Start with low-risk, high-impact scenarios
2. **Developer training** - Team familiarity with AI-assisted workflows
3. **Quality assurance integration** - PR validation and testing pipelines
4. **Feedback participation** - Contribute to tool improvement through usage data

---

## Community Engagement Opportunities

### Immediate Feedback Channels
- **Visual Studio Marketplace** - Extension reviews and feature requests  
- **Microsoft Build sessions** - Follow-up deep dives and labs
- **AI-assisted App Modernization booth** - Direct team interaction

### Upcoming Sessions
- **BRK131** - Deep dive into modernization technology (Timothy NG)
- **Dedicated labs** - Hands-on experience with tools
- **SRE agent integration** - Site Reliability Engineering automation

---

## About the Speakers

**Scott Hunter**  
VP of Product, Azure Developer  
Microsoft  
*Leads Azure Developer Experience team including PaaS Services, Azure SDKs, and Developer Tools. Previously led .NET development.*

**Chester Husk**  
Product Manager, .NET Tools  
Microsoft  
*Product Manager for .NET SDK, .NET CLI, MSBuild, and .NET Upgrades, focusing on developer productivity and tooling excellence.*

---

*This session represents a pivotal moment in .NET development tooling, demonstrating how AI can transform the traditionally manual and error-prone process of application modernization into an intelligent, automated workflow that scales across entire organizations.*

