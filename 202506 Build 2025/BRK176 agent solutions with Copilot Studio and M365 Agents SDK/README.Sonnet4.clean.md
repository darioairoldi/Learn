# Architecting Multi-Agent Solutions with Copilot Studio and M365 Agents SDK

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Microsoft Build 2025 Conference - BRK176  
**Speakers:** Vid Chari (Copilot Studio Marketing), Gary Pretty (Principal Product Manager, Copilot Studio), Salem Bacha (Principal Architect, Copilot Studio), Mike Stall (Architect, Copilot Studio), Sarah Critchley (Principal PM, Microsoft 365 Agents SDK), Matthew Barbour (Principal Architect, Power Platform & Development Manager, Agents SDK)  
**Link:** [Microsoft Build 2025 Session BRK176](https://mybuild.microsoft.com/sessions/BRK176)

---

## Table of Contents

1. [The Multi-Agent Vision](#1-the-multi-agent-vision)
2. [Microsoft's Unified Platform](#2-microsofts-unified-platform)
3. [Copilot Studio Multi-Agent Architecture](#3-copilot-studio-multi-agent-architecture)
   - 3.1 [Lightweight Specialized Agents](#31-lightweight-specialized-agents)
   - 3.2 [Connected External Agents](#32-connected-external-agents)
4. [Live Demonstrations](#4-live-demonstrations)
   - 4.1 [Balance Information Agent](#41-balance-information-agent)
   - 4.2 [Lost/Stolen Card Workflow](#42-loststolen-card-workflow)
   - 4.3 [Cross-Platform Integration](#43-cross-platform-integration)
5. [Multilingual Capabilities](#5-multilingual-capabilities)
6. [VS Code Extension](#6-vs-code-extension)
7. [M365 Agents SDK](#7-m365-agents-sdk)
   - 7.1 [SDK Architecture](#71-sdk-architecture)
   - 7.2 [Technical Implementation](#72-technical-implementation)
8. [Advanced Features](#8-advanced-features)
9. [Integration Patterns](#9-integration-patterns)
10. [Future Roadmap](#10-future-roadmap)
11. [References](#references)

---

## 1. The Multi-Agent Vision

**Timeframe:** 00:00:00 - 00:08:30 (8m 30s)  
**Speaker:** Vid Chari

Vid Chari established Microsoft's fundamental distinction between Copilots and Agents, addressing common market confusion.

### Core Framework

**Copilots:**

- Personal AI assistants aligned to individual employees
- Grounded in personal data (emails, chats, meetings, documents)
- Universal "UI to AI" for Microsoft experiences
- One-to-one relationship with users

**Agents:**

- Programs using AI to automate business processes
- Aligned to organizational workflows and processes
- Range from simple retrieval to complex autonomous systems
- Work alongside individuals, teams, or organizations

### Market Scale Prediction

IDC predicts **1.3 billion agents by 2028**, driven by diverse organizational stakeholders:

- **Bottom-up development:** Process owners transforming specific business areas
- **Top-down strategy:** Enterprise initiatives enabling new business models
- **Grassroots innovation:** Individual contributors solving workflow inefficiencies

### Microsoft Platform Advantages

1. **Direct UI Integration:** All agents integrate with M365 Copilot interface
2. **Data Ecosystem:** Most enterprise data already in Microsoft platforms
3. **Enterprise Security:** Built-in governance, compliance, and security
4. **AI Access:** Direct integration with latest models and orchestration

---

## 2. Microsoft's Unified Platform

**Timeframe:** 00:08:30 - 00:12:15 (3m 45s)  
**Speaker:** Vid Chari

Microsoft provides choice across the development spectrum with unified underpinnings.

### Development Approaches

#### Low-Code: Copilot Studio

- **Audience:** Process owners, subject matter experts, citizen developers
- **Features:** Visual canvas, rapid authoring, pre-built defaults
- **Use Cases:** Process-specific transformations, rapid prototyping

#### Pro-Code: Visual Studio + GitHub

- **Audience:** Professional developers, technical teams
- **Features:** Custom control, enterprise-grade capabilities
- **Use Cases:** Organization-wide initiatives, complex integrations

### Common Foundation

Both approaches share:

- **Knowledge systems:** Unified data grounding and retrieval
- **Tools and connectors:** Shared integration library
- **AI models:** Common Azure AI Foundry access
- **Orchestration:** Unified multi-agent coordination

---

## 3. Copilot Studio Multi-Agent Architecture

**Timeframe:** 00:12:15 - 00:18:30 (6m 15s)  
**Speakers:** Gary Pretty, Salem Bacha

### Traditional Architecture

Current agent components:

- **Generative Orchestrator:** Recently GA worldwide
- **Knowledge Sources:** Document grounding and retrieval
- **Tools and Actions:** External system integration
- **Topics:** High-control workflow definitions

### 3.1 Lightweight Specialized Agents

**Design Philosophy:**

- Embedded within parent agents
- Instruction-driven behavior
- Focused task specialization
- Environment portability

**Key Capabilities:**

- **Natural Language Instructions:** Conversational behavior definition
- **Tool Inheritance:** Granular access to parent tools
- **Built-in Interaction Tools:** Pre-built question/message capabilities
- **Environment Portability:** Move with parent agent

### 3.2 Connected External Agents

**Architecture Benefits:**

- Independent lifecycle management
- Cross-team development and ownership
- Direct end-user availability
- Platform-agnostic integration

**Integration Features:**

- **Conversation History Control:** Full context vs. private mode
- **Authentication Options:** User vs. service account credentials
- **Multi-turn Support:** Seamless conversation continuity
- **Cross-platform Protocol:** Unified communication

---

## 4. Live Demonstrations

**Timeframe:** 00:18:30 - 00:35:45 (17m 15s)  
**Speakers:** Gary Pretty, Salem Bacha

### 4.1 Balance Information Agent

**Timeframe:** 00:18:30 - 00:23:00 (4m 30s)  
**Speaker:** Gary Pretty

**Configuration:**

- **Name:** Balance Information Agent
- **Description:** Provides balance information for user accounts
- **Instructions:** Three-step workflow for account balance retrieval

**Demo Results:**

- Dynamic questioning when account not specified
- Seamless tool integration with shared resources
- Natural follow-up question handling
- Complete conversation generation without predefined inputs

### 4.2 Lost/Stolen Card Workflow

**Timeframe:** 00:23:00 - 00:27:30 (4m 30s)  
**Speaker:** Gary Pretty

**Complex Instructions:**

1. Get user accounts list and request selection
2. Format account list with presentation rules
3. Freeze account and retrieve transactions
4. Show five recent transactions, check for suspicious activity
5. If suspicious found, call dispute endpoint

**Advanced Features:**

- Multi-tool orchestration between user interactions
- LLM-driven conditional processing
- Natural language input handling
- Complete execution transparency

### 4.3 Cross-Platform Integration

**Timeframe:** 00:27:30 - 00:35:45 (8m 15s)  
**Speaker:** Salem Bacha

#### Copilot Studio to Copilot Studio

**Mortgage Agent Connection:**

- Simple toggle-based availability
- Publishing requirement for connectivity
- Customizable interaction descriptions
- Full context vs. private mode options

#### Azure AI Foundry Integration

**Car Loan Agent Setup:**

- GPT-4.1 model integration
- Connection via URL, ID, and connection string
- Authentication options (user vs. author)
- Multi-turn conversation support

**Results:** Seamless cross-platform agent orchestration with conversation threads visible in both platforms.

---

## 5. Multilingual Capabilities

**Timeframe:** 00:35:45 - 00:42:00 (6m 15s)  
**Speaker:** Gary Pretty

### Revolutionary Announcement

**Public Preview:** Additional language support for generative orchestrator across all 29 Copilot Studio languages.

**Key Features:**

- **Single Development Language:** Build agents entirely in English
- **Automatic Translation:** Real-time conversation translation
- **Zero Additional Work:** Enable by checking language boxes
- **Weeks to GA:** General availability within weeks

### Live Spanish Demonstration

**Technical Achievement:**

- Agent built in English operated flawlessly in Spanish
- Complex lost card workflow conducted entirely in Spanish
- Natural language responses throughout conditional logic
- Single codebase serving multiple global markets

### Impact

- **Historical Context:** Previous implementations required extensive manual translation
- **Business Impact:** Rapid international expansion capability
- **Development Efficiency:** 29-language deployment with single-language effort

---

## 6. VS Code Extension

**Timeframe:** 00:42:00 - 00:50:30 (8m 30s)  
**Speaker:** Mike Stall

### Capabilities

**Now Available:** Public preview in VS Code marketplace with daily updates.

**Core Features:**

- **Clone/Push Workflow:** Git-like cloud synchronization
- **Offline Development:** Complete local development capability
- **Rich IDE Support:** IntelliSense, error detection, go-to-definition
- **File-based Editing:** YAML with semantic understanding
- **Source Control Integration:** Change tracking and collaboration

### Development Workflow

**Process:**

1. Clone agent from Copilot Studio URL
2. Local YAML file development with full IDE support
3. Offline capability for uninterrupted development
4. Push changes back to cloud with live updates

**Advanced Features:**

- Semantic understanding of agent structure
- Color-coded change indicators
- Meaningful error messages with corrections
- Complete agent component navigation

### Multilingual Solution

**System Topic Challenge:** Solved hardcoded welcome message limitation by replacing system topics with instruction-driven agents that inherit multilingual capabilities.

---

## 7. M365 Agents SDK

**Timeframe:** 00:50:30 - 01:00:00 (9m 30s)  
**Speakers:** Sarah Critchley, Matthew Barbour

### 7.1 SDK Architecture

**Speaker:** Sarah Critchley

**Definition:** Open source SDK in C#, JavaScript, and Python providing complete development control.

**Developer Control Areas:**

- **AI Models:** Any service or provider choice
- **Orchestrator:** Custom logic and decision-making
- **Knowledge Sources:** Custom grounding and data
- **Conversation Management:** Built-in state, storage, auth

**Multi-Channel Deployment:**

- Microsoft Teams, Slack, M365 Copilot
- 15+ channels out-of-the-box
- Custom channel development capability

### 7.2 Technical Implementation

**Speaker:** Matthew Barbour

**SDK Focus:** Integrate existing custom agents with Microsoft ecosystem.

**Core Capabilities:**

- **Channel Management:** Abstract communication complexity
- **Conversation Management:** Multi-turn conversations and state
- **User Authorization:** Built-in authentication management
- **State Management:** Persistent session handling

### Copilot Studio Client

**Implementation:**

```csharp
var client = new CopilotStudioClient();
await client.StartAsync();
await client.StartConversationAsync();
await client.AskAsync("Hi, who are you?");
```

**Configuration Options:**

- Direct connection URL for simple integration
- Environment ID for multi-agent switching
- Schema name for dynamic discovery
- Authentication flexibility

**Advanced Integration:**

- Semantic Kernel embedding (Python complete, .NET in progress)
- Full event infrastructure access
- Adaptive card and complex event support
- Platform-agnostic API consistency

---

## 8. Advanced Features

### Trigger System

**Event-Driven Activation:**

- **Conversation Start:** User session initiation
- **Orchestrator Decision:** AI-driven agent selection
- **External Events:** System-triggered operations
- **Custom Triggers:** Business-specific conditions

### Autonomous Operations

Both conversational and autonomous scenarios supported with identical multi-agent capabilities.

### Activity Monitoring

Enhanced visibility includes:

- Agent invocation tracking
- Internal tool usage monitoring
- Cross-agent communication summaries
- Complete execution transparency

---

## 9. Integration Patterns

### Development Approach Selection

**Copilot Studio Scenarios:**

- Process owner-led development
- Single team focused projects
- Rapid prototyping needs
- Direct end-user availability requirements

**SDK Scenarios:**

- Professional developer requirements
- Enterprise-scale implementations
- Existing application integration
- Complex orchestration patterns

### Architecture Patterns

**Lightweight Agents:**

- Single development team scenarios
- Logically grouped knowledge and tools
- Portable with parent agent
- Instruction-driven behavior

**Connected Agents:**

- Multi-team management
- Independent end-user availability
- Cross-platform integration
- Independent lifecycle management

---

## 10. Future Roadmap

### Immediate Availability (Build 2025)

- VS Code extension public preview
- Multilingual support (29 languages)
- Daily extension updates

### June 2025 Public Preview

- Multi-agent orchestration
- Cross-platform coordination
- Complete business process transformation

### Planned Expansions

- Google A2A protocol integration
- Extended cross-platform communication
- Enhanced SDK capabilities
- Expanded channel support

---

## References

### Official Documentation

- **[Copilot Studio Documentation](https://docs.microsoft.com/copilot-studio/)**  
  *Comprehensive guide to Microsoft's low-code agent platform. Essential for understanding visual development approaches demonstrated in the session.*

- **[Microsoft 365 Agents SDK](https://github.com/microsoft/agents)**  
  *Open source SDK repository with complete source code, samples, and documentation for professional agent development.*

- **[Azure AI Foundry Documentation](https://docs.microsoft.com/azure/ai-foundry/)**  
  *Platform documentation for AI infrastructure powering both Copilot Studio and SDK agents. Critical for understanding multi-agent orchestration foundation.*

### Development Tools

- **[VS Code Copilot Studio Extension](https://marketplace.visualstudio.com/items?itemName=microsoft.copilot-studio)**  
  *Newly announced extension for professional developers. Enables familiar IDE tools for agent development with low-code platform integration.*

- **[Semantic Kernel Documentation](https://docs.microsoft.com/semantic-kernel/)**  
  *Microsoft's orchestration framework integrating with M365 Agents SDK. Relevant for complex multi-agent scenarios and custom orchestration.*

### Architecture Resources

- **[Power Platform Guidance](https://aka.ms/PowerPlatformGuidance)**  
  *Official architecture patterns and best practices for Power Platform. Valuable for enterprise multi-agent solution deployment strategies.*

- **[Microsoft Power Platform Architecture](https://aka.ms/PowerArchitecture)**  
  *Enterprise architecture guidance for Power Platform implementations. Critical for large-scale agent deployments across multiple teams.*

- **[Copilot Studio Starter Kit](https://aka.ms/CopilotStudioKit)**  
  *Templates, best practices, and accelerators for Copilot Studio development. Useful for implementing demonstrated multi-agent patterns.*

### Industry Context

- **[IDC AI Agents Market Forecast](https://www.idc.com/)**  
  *Industry analysis supporting the 1.3 billion agents by 2028 prediction. Important for understanding business context driving Microsoft's strategy.*

- **[Microsoft Build 2025 Keynotes](https://mybuild.microsoft.com/)**  
  *Satya Nadella and Charles Lamanna keynotes referenced throughout the session. Provides broader context for Microsoft's AI and agent announcements.*

### Additional Sessions

- **[BRK163: Advanced Multi-Agent SDK Patterns](https://aka.ms/Build25_BRK163)**  
  *Follow-up session for advanced SDK implementation patterns and multi-agent switching scenarios.*

- **[Enterprise Agent Challenge](https://aka.ms/EnterpriseAgentChallenge)**  
  *May 28 - June 13 development competition for hands-on experience with demonstrated multi-agent capabilities.*

### Technical Samples

- **[M365 Agents SDK Samples](https://github.com/microsoft/agents/tree/main/samples)**  
  *Code samples including the Copilot Studio client console application demonstrated by Matthew Barbour.*

- **[Azure AI Foundry Agent Templates](https://docs.microsoft.com/azure/ai-foundry/quickstarts/)**  
  *Templates for building Foundry agents that integrate with Copilot Studio agents in cross-platform scenarios.*

---

*This comprehensive analysis captures Microsoft's revolutionary multi-agent capabilities announced at Build 2025, demonstrating unified orchestration across development approaches, platforms, and organizational boundaries while maintaining consistent user experience and enterprise-grade security.*
