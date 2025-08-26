# AI-Powered .NET App Modernization: GitHub Copilot & Azure Migration Tools

**Session Date:** Microsoft Build 2025  
**Duration:** ~45 minutes  
**Venue:** Build 2025 Conference - BRK101  
**Speakers:** Scott Hunter (VP of Product, Azure Developer), Chester Husk (Product Manager, .NET Tools)  
**Link:** [Microsoft Build 2025 Session BRK101](https://build.microsoft.com/en-US/sessions/BRK101)

---

## Table of Contents

- [Introduction and Session Overview](#1-introduction-and-session-overview)
- [The Business Case for .NET Upgrades](#2-the-business-case-for-net-upgrades)
- [Understanding the Upgrade vs. Modernization Spectrum](#3-understanding-the-upgrade-vs-modernization-spectrum)
- [Traditional Migration Tools Analysis](#4-traditional-migration-tools-analysis)
  - [.NET Upgrade Assistant Capabilities](#41-net-upgrade-assistant-capabilities)
  - [Azure Migrate Application Code Assessment](#42-azure-migrate-application-code-assessment)
  - [Tool Limitations and Pain Points](#43-tool-limitations-and-pain-points)
- [AI-Powered Upgrade Revolution](#5-ai-powered-upgrade-revolution)
  - [GitHub Copilot for .NET Modernization](#51-github-copilot-for-net-modernization)
  - [Live Demonstration: eShopOnWeb Upgrade](#52-live-demonstration-eshoponweb-upgrade)
  - [Human-in-the-Loop Learning System](#53-human-in-the-loop-learning-system)
- [Formula-Based Code Transformation](#6-formula-based-code-transformation)
  - [Architecture and Implementation](#61-architecture-and-implementation)
  - [AWS to Azure Migration Demo](#62-aws-to-azure-migration-demo)
  - [Custom Pattern Creation](#63-custom-pattern-creation)
- [Real-World Impact and Success Stories](#7-real-world-impact-and-success-stories)
- [Future Roadmap and Vision](#8-future-roadmap-and-vision)
- [Technical Architecture Deep Dive](#9-technical-architecture-deep-dive)
- [Practical Implementation Guide](#10-practical-implementation-guide)
- [References](#references)
- [Appendix: Session Context and Ancillary Information](#appendix-session-context-and-ancillary-information)
  - [Speaker Introductions and Banter](#a1-speaker-introductions-and-banter)
  - [Audience Interaction and Polling](#a2-audience-interaction-and-polling)
  - [Technical Difficulties and Demo Adjustments](#a3-technical-difficulties-and-demo-adjustments)
  - [Community Engagement Opportunities](#a4-community-engagement-opportunities)

---

## 1. Introduction and Session Overview

**Timeframe:** 00:00:00 - 00:02:15  
**Duration:** 2m 15s  
**Speakers:** Chester Husk, Scott Hunter

**Chester Husk** opens the session with enthusiasm about AI-powered app modernization for .NET, establishing the collaborative nature of the presentation with Scott Hunter. <br>
The introduction sets the stage for demonstrating **how AI transforms the traditionally manual and error-prone process** of application modernization into an **intelligent, automated workflow**.

**Scott Hunter** provides his background context, emphasizing his long tenure with .NET and recent focus on Azure technologies.<br>
He positions the session as **showcasing how Azure migration technologies**, demonstrated earlier for Java in Jay's keynote, have been adapted and enhanced for .NET applications.

The speakers establish the session's dual focus: <mark>building upon existing booth demonstrations while providing deeper technical insights into AI-assisted modernization tools</mark>.

## 2. The Business Case for .NET Upgrades

**Timeframe:** 00:02:15 - 00:08:30  
**Duration:** 6m 15s  
**Speakers:** Chester Husk (primary), Scott Hunter (interjections)

**Chester Husk** presents a comprehensive argument for regular .NET upgrades, citing multiple compelling factors:

### Performance Improvements

Reference to **Stephen Toub's annual performance analysis** demonstrates significant runtime improvements with each release.<br>
This positions performance as a primary motivating factor for organizations considering upgrades.

### Security Enhancements

Monthly servicing releases include critical security fixes, protecting applications from vulnerabilities that may not be immediately apparent to development teams.<br>
This creates a security imperative for staying current with runtime versions.

### Tooling Advances

**Each .NET SDK release** brings productivity improvements and new capabilities that enhance developer experience, even when not directly forcing Target Framework Moniker (TFM) changes.

### Compliance and Support Lifecycle Management

The **Long-Term Support (LTS)** versus **Short-Term Support (STS) model** creates predictable but limited support windows, requiring proactive upgrade planning to maintain vendor support throughout application lifecycles.

### Ecosystem Alignment

NuGet package authors, **MSBuild task creators**, and **Roslyn analyzer developers** make independent decisions about framework targeting.<br>
As **ecosystem components advance, applications must keep pace** to maintain compatibility and access to new features.

## 3. Understanding the Upgrade vs. Modernization Spectrum

**Timeframe:** 00:08:30 - 00:12:45  
**Duration:** 4m 15s  
**Speakers:** Chester Husk

This section establishes critical distinctions between **upgrade** and **modernization** activities:

### Upgrade Activities (Point A → Point B)

- **Framework version migrations (.NET 6 → .NET 8 → .NET 9)**
- **Dependency updates and vulnerability patches**
- **Tooling and SDK transitions**
- **Maintaining current functionality while updating underlying platforms**

### Modernization Activities (Architectural Transformation)

- Decomposition into **microservices architectures**
- Migration to **cloud-native patterns** (Azure Functions, Container Apps)
- Adoption of **new deployment models** and **DevOps practices**
- Integration with **modern observability** and **monitoring systems**

### Business Motivations for Modernization

- **Cost reduction** through cloud provider service alignment
- **Talent attraction and retention** through modern technology adoption
- **Enhanced scalability** and operational efficiency
- **Reduced infrastructure management overhead**

Chester emphasizes that while these activities may feel similar to practitioners, existing tools target different points on this spectrum, with implications for tool selection and implementation strategies.

## 4. Traditional Migration Tools Analysis

**Timeframe:** 00:12:45 - 00:25:30  
**Duration:** 12m 45s  
**Speakers:** Chester Husk (Upgrade Assistant), Scott Hunter (Azure Migrate)

### 4.1 .NET Upgrade Assistant Capabilities

**Timeframe:** 00:12:45 - 00:20:15  
**Duration:** 7m 30s  
**Speakers:** Chester Husk

#### Analysis and Reporting Features

The .NET Upgrade Assistant provides comprehensive project assessment capabilities:

- **Aggregated dashboard** showing problem categories
- Project-by-project **detailed task breakdowns**
- **Story point estimates** for effort planning
- **Drill-down capabilities** for specific issue types

#### Multiple Upgrade Strategies

- **In-place migration**: Direct transformation of existing projects
- **Side-by-side migration**: Parallel development for A/B testing scenarios
- **Side-by-side incremental**: Gradual migration of ASP.NET application slices

#### Additional Migration Capabilities

- **NuGet Central Package Management**: Automated package consolidation across repositories
- **SDK-style project conversion**: Migration from full-featured to modern project files
- **Command-line interface**: Full functionality available outside Visual Studio

#### Supported Project Types

- **ASP.NET Web** Applications
- **WPF** and **Windows Forms** applications
- **Console Applications** and **Class Libraries**
- **Azure Functions** (with specific limitations)

### 4.2 Azure Migrate Application Code Assessment

**Timeframe:** 00:20:15 - 00:24:00  
**Duration:** 3m 45s  
**Speakers:** Scott Hunter

The Azure Migrate Application Code Assessment Tool focuses on cloud readiness evaluation:

#### Core Functionality

- **Static code analysis** for Azure compatibility assessment
- Cloud migration planning and readiness reporting
- Mandatory versus optional fix categorization
- Basic Copilot integration for documentation lookup

#### Demonstration Results

**Using the MVC Music Store** sample application, Scott demonstrates:

- Identification of mandatory fixes (Windows authentication incompatibility)
- Optional optimization recommendations (CDN usage, connection string improvements)
- Limited AI assistance providing documentation-style guidance

### 4.3 Tool Limitations and Pain Points

**Timeframe:** 00:24:00 - 00:25:30  
**Duration:** 1m 30s  
**Speakers:** Scott Hunter, Chester Husk

Both speakers acknowledge significant limitations of traditional tools:

- **Analysis-heavy, execution-light**: Tools generate extensive task lists requiring manual developer intervention
- **Limited automation**: Static analysis without intelligent code transformation
- **Overwhelming output**: 1,200+ line reports that discourage developer engagement
- **Shallow AI integration**: Documentation lookup rather than actionable code assistance

Scott's quote captures the frustration: *"Microsoft Field and Sales came to me and said, 'Scott, this is great. Now I give Jared this list of 1,200 line file, Please go fix all these things.' And Jared's like, 'I'm out.'"*

## 5. AI-Powered Upgrade Revolution

**Timeframe:** 00:25:30 - 00:38:15  
**Duration:** 12m 45s  
**Speakers:** Chester Husk (primary), Scott Hunter (commentary)

### 5.1 GitHub Copilot for .NET Modernization

**Timeframe:** 00:25:30 - 00:29:00  
**Duration:** 3m 30s  
**Speakers:** Chester Husk

#### Key Design Improvements Over Traditional Tools

- **Dependency-aware analysis**: <mark>Understanding project relationships</mark> and <mark>package usage patterns</mark>
- **Automated execution**: Moving beyond analysis to <mark>actual code transformation</mark>
- **Intelligent error handling**: <mark>Context-aware problem resolution</mark>
- **Git integration**: <mark>Checkpoint commits</mark> for each transformation step

#### Human-in-the-Loop Learning Architecture

- **Error capture**: When automated fixes fail, the system engages developers
- **Pattern recognition**: Learning from developer interventions for future similar issues
- **Knowledge persistence**: Accumulated fixes become part of the tool's capabilities
- **Contextual assistance**: Copilot-enabled problem-solving environment

### 5.2 Live Demonstration: eShopOnWeb Upgrade

**Timeframe:** 00:29:00 - 00:35:45  
**Duration:** 6m 45s  
**Speakers:** Chester Husk, Scott Hunter

#### Scenario Setup

Upgrade of eShopOnWeb solution from .NET 6.0 to .NET 9.0, demonstrating real-world complexity with multiple projects and dependencies.

#### Process Workflow

1. **Interactive Planning Phase**

   - <mark>Copilot generates customizable upgrade strategy</mark>
   - Markdown-based plans that users can review and modify
   - Clear visibility into proposed changes

2. **Automated Analysis and Vulnerability Detection**

   - <mark>Automatic identification of security issues</mark>
   - Package vulnerability assessment
   - Dependency conflict resolution

3. **Intelligent Execution**

   - <mark>Project-by-project transformation</mark>
   - Real-time progress reporting
   - Automatic build verification at each step

4. **Error Recovery Demonstration**

   - <mark>Compilation error encounter and resolution</mark>
   - Developer intervention integration
   - Learning system activation for future similar issues

#### Live Demo Results

- **Time efficiency**: ~2.5 minutes active upgrade time for 8 projects
- **Automation rate**: 80%+ automated transformation
- **Success metrics**: Clean compilation and build verification

Scott's commentary emphasizes the dramatic time savings: *"In that minute-and-a-half... it already saved Chet probably an hour or multiple hours of time to go manually update all those projects by hand."*

### 5.3 Human-in-the-Loop Learning System

**Timeframe:** 00:35:45 - 00:38:15  
**Duration:** 2m 30s  
**Speakers:** Chester Husk

The learning system represents a fundamental advancement in automated tooling:

#### Learning Mechanisms

- **Pattern extraction**: Analyzing successful developer interventions
- **Context preservation**: Maintaining situational awareness for similar problems
- **Incremental improvement**: Each interaction enhances tool capabilities
- **Knowledge sharing**: Learnings benefit all tool users

#### Developer Experience Integration

- **Transparent operation**: Visible decision-making and transformation steps
- **Controllable automation**: User approval workflows and modification capabilities
- **Feedback incorporation**: Continuous improvement from user interactions
- **Error resilience**: Graceful handling of edge cases and unexpected scenarios

## 6. Formula-Based Code Transformation

**Timeframe:** 00:38:15 - 00:43:00  
**Duration:** 4m 45s  
**Speakers:** Scott Hunter (demonstration), Chester Husk (technical details)

### 6.1 Architecture and Implementation

**Timeframe:** 00:38:15 - 00:39:30  
**Duration:** 1m 15s  
**Speakers:** Chester Husk

The formula system enables large-scale pattern-based code transformation:

#### System Components

- **Pre-built formulas**: Top 10 common migration patterns from AppCAT analysis
- **Custom formula creation**: Learning from developer examples
- **Prompt-based implementation**: Editable transformation logic
- **Cross-project application**: Bulk changes across entire codebases

#### Transformation Scope

Formulas can handle comprehensive migration scenarios including:

- Package references and import statements
- API method calls and signatures
- Configuration file modifications
- Connection string format changes
- Authentication mechanism updates

### 6.2 AWS to Azure Migration Demo

**Timeframe:** 00:39:30 - 00:42:15  
**Duration:** 2m 45s  
**Speakers:** Scott Hunter

#### Migration Complexity Demonstration

The AWS S3 to Azure Blob Storage migration showcases formula capabilities:

**Transformation Elements:**

- **Package Dependencies**: AWS SDK to Azure SDK package references
- **Import Statements**: Namespace and using directive changes
- **API Calls**: Method signature and parameter transformations
- **Configuration**: appsettings.json structure modifications
- **Authentication**: Access pattern and credential handling changes

#### Developer Experience Features

- **Plan Review Workflow**: Pre-transformation approval process
- **Real-time Visualization**: Live code transformation display
- **Automatic Verification**: Build confirmation after changes
- **Style Preservation**: Maintaining coding conventions and formatting

### 6.3 Custom Pattern Creation

**Timeframe:** 00:42:15 - 00:43:00  
**Duration:** 45s  
**Speakers:** Chester Husk

#### Formula Development Process

- **Example-based Learning**: Developers provide transformation examples
- **Pattern Extraction**: AI identifies reusable transformation rules
- **Validation Testing**: Automatic verification of formula accuracy
- **Distribution Mechanism**: Sharing formulas across teams and organizations

## 7. Real-World Impact and Success Stories

**Timeframe:** 00:43:00 - 00:44:30  
**Duration:** 1m 30s  
**Speakers:** Scott Hunter, Chester Husk

### Microsoft Internal Adoption

- **Teams and Xbox divisions**: Significant upgrade acceleration achieved
- **Diverse development pressures**: Different teams with varying timeline constraints
- **Quantified benefits**: Hours of manual work compressed to minutes of automated execution

### Partner and Customer Results

- **Enterprise transformations**: 8-month migration projects reduced to weeks
- **Legacy codebase modernization**: Automated pattern migrations at scale
- **Developer productivity gains**: Focus shift from mechanical updates to business logic development

### Organizational Impact

The tools enable development teams to redirect effort from routine maintenance tasks to value-creating feature development, fundamentally changing the economics of application lifecycle management.

## 8. Future Roadmap and Vision

**Timeframe:** 00:44:30 - 00:45:00  
**Duration:** 30s  
**Speakers:** Chester Husk, Scott Hunter

### Near-term Development Priorities

- **Framework → Core migration support**: Bridging the final gap in upgrade tooling
- **Multi-editor integration**: Visual Studio Code and additional development environment support
- **Bulk processing capabilities**: Organization-wide automated upgrade orchestration
- **Formula marketplace expansion**: Enhanced sharing and discovery of transformation patterns

### Long-term Strategic Vision

- **Unified workflow integration**: Seamless upgrade and modernization experience
- **SRE agent integration**: Automated monitoring and upgrade triggering
- **Cross-language expansion**: Python, C++, JavaScript formula system support
- **End-to-end DevOps automation**: Complete development lifecycle integration

## 9. Technical Architecture Deep Dive

### AI Integration Architecture

- **Roslyn Compiler Integration**: Deep semantic code understanding for accurate error detection and transformation
- **Large Language Model Integration**: Context-aware transformation instruction generation
- **Pattern Recognition Systems**: Machine learning from successful developer interventions
- **Validation Frameworks**: Automated testing and quality assurance throughout transformation process

### Developer Experience Design Principles

- **Transparency**: All transformation steps, decisions, and commits are visible to developers
- **Control**: User approval workflows and plan modification capabilities maintain developer agency
- **Feedback Integration**: Continuous improvement through user interaction data
- **Error Recovery**: Graceful degradation and developer escalation for edge cases

### Scalability and Performance Considerations

- **Incremental Processing**: Project-by-project transformation to manage complexity
- **Checkpoint Management**: Git-based rollback points for transformation safety
- **Parallel Execution**: Multi-project processing where dependencies allow
- **Resource Optimization**: Intelligent scheduling of analysis and transformation workloads

## 10. Practical Implementation Guide

### Immediate Adoption Steps

1. **Tool Installation**: GitHub Copilot App Modernization extension available in public preview
2. **Assessment Strategy**: Use existing tools for baseline analysis and planning
3. **Testing Infrastructure**: Ensure comprehensive test coverage before AI-assisted transformations
4. **Team Training**: Developer familiarity with AI-assisted development workflows

### Strategic Implementation Considerations

1. **Risk Management**: Start with non-critical applications to build confidence
2. **Quality Assurance**: Integrate automated testing and code review processes
3. **Knowledge Management**: Capture and share successful transformation patterns
4. **Feedback Participation**: Contribute usage data and feedback for tool improvement

### Success Metrics and Measurement

- **Time Reduction**: Quantify hours saved through automated transformation
- **Error Reduction**: Measure improvement in upgrade success rates
- **Developer Satisfaction**: Track team adoption and workflow integration
- **Business Impact**: Assess cost savings and productivity improvements

## References

### Microsoft Official Documentation

1. **GitHub Copilot App Modernization Extension** - [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.copilot-modernization)  
   *Official extension for AI-powered .NET application modernization. Essential for hands-on experience with the demonstrated capabilities.*

2. **.NET Upgrade Assistant Documentation** - [Microsoft Learn](https://learn.microsoft.com/dotnet/core/porting/upgrade-assistant-overview)  
   *Comprehensive guide to traditional upgrade tooling. Provides baseline understanding for comparing with AI-enhanced approaches.*

3. **Azure Migrate Application Assessment** - [Azure Documentation](https://learn.microsoft.com/azure/migrate/concepts-migration-assessment)  
   *Details on Azure migration planning and assessment tools. Context for understanding the evolution from static analysis to AI-driven transformation.*

4. **.NET Support Policy and Lifecycle** - [Microsoft .NET Support Policy](https://dotnet.microsoft.com/platform/support/policy)  
   *Official support lifecycle information including LTS vs STS models. Critical for understanding the business drivers for upgrade planning.*

### Performance and Security Resources

1. **Stephen Toub's .NET Performance Improvements** - [.NET Blog](https://devblogs.microsoft.com/dotnet/category/performance/)  
   *Annual performance analysis referenced in the session. Demonstrates quantifiable benefits of runtime upgrades.*

2. **.NET Security Updates** - [.NET Security](https://github.com/dotnet/announcements/labels/Security)  
   *Security bulletin tracking for understanding the security imperative of regular updates.*

### Technical Architecture References

1. **Roslyn Compiler Platform** - [Microsoft Docs](https://learn.microsoft.com/dotnet/csharp/roslyn-sdk/)  
   *Understanding the compiler integration that enables deep code analysis in AI-powered tools.*

2. **Azure DevOps and GitHub Integration** - [Azure DevOps Documentation](https://learn.microsoft.com/azure/devops/)  
   *Context for understanding how AI-assisted modernization integrates with existing development workflows.*

### Community and Ecosystem

1. **Microsoft Build 2025 Session Catalog** - [Build Conference](https://build.microsoft.com/sessions)  
   *Related sessions including BRK131 deep dive and hands-on labs for extended learning.*

2. **NuGet Central Package Management** - [Microsoft Learn](https://learn.microsoft.com/nuget/consume-packages/central-package-management)  
    *Details on package management modernization techniques demonstrated in the session.*

## Appendix: Session Context and Ancillary Information

### A.1 Speaker Introductions and Banter

The session opens with characteristic Microsoft conference humor, with Chester Husk noting the limited audience enthusiasm for AI-powered app modernization ("Alright, like, five of you, great"). This informal tone continues throughout, with speakers making self-deprecating comments about Microsoft's naming conventions and tool proliferation.

Scott Hunter's introduction emphasizes his .NET background and recent Azure focus, positioning him as a bridge between traditional .NET development and modern cloud-native approaches. The collaborative dynamic between the speakers reflects the cross-team nature of modern Microsoft tooling development.

### A.2 Audience Interaction and Polling

Several audience polls provide insight into the .NET ecosystem's current state:

- **Framework Application Usage**: Approximately one-third to half of attendees still maintain .NET Framework applications
- **Web Forms Applications**: Roughly 10% of Framework applications use Web Forms (identified as the most challenging migration scenario)
- **Tool Awareness**: Very few attendees were familiar with Azure Migrate Application Code Assessment Tool
- **Previous Migration Experience**: Significant portion of audience has performed Framework to Core migrations

These data points inform the speakers' emphasis on different tool capabilities and use cases.

### A.3 Technical Difficulties and Demo Adjustments

Scott Hunter's comment about Wi-Fi affecting AI performance ("It's amazing what Wi-Fi does for AI") acknowledges common conference demonstration challenges. The speakers adapt by switching between prepared demonstrations and explaining concepts when live demos encounter issues.

Chester Husk's decision to focus on analysis rather than full upgrade execution ("I want to make sure we have time to do the really fun stuff") demonstrates presentation time management and priority setting for maximum educational impact.

### A.4 Community Engagement Opportunities

The session references several engagement channels:

- **Conference Booth**: AI-assisted App Modernization booth for direct team interaction
- **Related Sessions**: BRK131 deep dive session with Timothy NG, hands-on labs
- **Visual Studio Marketplace**: Extension installation and feedback
- **Public Preview Participation**: Direct tool usage and improvement feedback

These opportunities allow attendees to extend learning beyond the session and contribute to tool development through usage and feedback.

---

*This comprehensive analysis captures the technical depth, practical implications, and strategic vision presented in Microsoft's AI-powered .NET modernization session, providing actionable insights for development teams planning application lifecycle management strategies.*
