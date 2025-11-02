# Create Agents for Microsoft 365 Copilot with Microsoft 365 Agents SDK

**Session Date:** May 21, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK163  
**Speakers:** Sarah Critchley (Principal Product Manager, Microsoft), Matthew Barbour (Principal Architect/Development Manager, Microsoft)  
**Customer Speakers:** Renil Abdulkader (Engineering Director, KPMG LLP), Gaurave Sehgal (Senior Director, KPMG LLP)  
**Link:** [Microsoft Build 2025 Session BRK163](https://mybuild.microsoft.com/sessions/BRK163)

---

## Table of Contents

- [The Conversational Technology Revolution](#the-conversational-technology-revolution)
  - [The Fundamental Shift](#the-fundamental-shift)
  - [Real-World Impact Examples](#real-world-impact-examples)
  - [Why Agents Transform User Experience](#why-agents-transform-user-experience)
- [Microsoft 365 Agents SDK: Complete Developer Control](#microsoft-365-agents-sdk-complete-developer-control)
  - [Core Philosophy and Capabilities](#core-philosophy-and-capabilities)
  - [SDK Architecture and Flexibility](#sdk-architecture-and-flexibility)
  - [Language and Framework Support](#language-and-framework-support)
- [Microsoft 365 Agents Toolkit: End-to-End Development Experience](#microsoft-365-agents-toolkit-end-to-end-development-experience)
  - [From File New to Deployment](#from-file-new-to-deployment)
  - [Development Workflow Integration](#development-workflow-integration)
  - [Templates and Scaffolding](#templates-and-scaffolding)
- [Live Coding Demonstrations: Real-World Implementation](#live-coding-demonstrations-real-world-implementation)
  - [Semantic Kernel to Multi-Channel Agent](#semantic-kernel-to-multi-channel-agent)
  - [Technical Implementation Deep Dive](#technical-implementation-deep-dive)
  - [Multi-Channel Consistency](#multi-channel-consistency)
- [Streaming Responses and User Experience Enhancement](#streaming-responses-and-user-experience-enhancement)
  - [Interactive Status Communication](#interactive-status-communication)
  - [Channel-Adaptive Streaming](#channel-adaptive-streaming)
  - [Implementation Strategy](#implementation-strategy)
- [Multi-Agent Orchestration and Integration](#multi-agent-orchestration-and-integration)
  - [Dispatcher Pattern Implementation](#dispatcher-pattern-implementation)
  - [Advanced Authentication Management](#advanced-authentication-management)
  - [Live Authentication Demo](#live-authentication-demo)
- [Microsoft 365 Copilot APIs Integration](#microsoft-365-copilot-apis-integration)
  - [Four Core APIs for Enterprise Integration](#four-core-apis-for-enterprise-integration)
  - [Retrieval API Deep Dive](#retrieval-api-deep-dive)
  - [Live API Demonstration Challenges](#live-api-demonstration-challenges)
- [KPMG Enterprise Implementation Case Study](#kpmg-enterprise-implementation-case-study)
  - [Global Tax Intelligence Platform](#global-tax-intelligence-platform)
  - [Tax Intelligence Personas](#tax-intelligence-personas)
  - [Cross-Tenant Authentication Excellence](#cross-tenant-authentication-excellence)
- [Call to Action and Resources](#call-to-action-and-resources)
- [References](#references)

---

## The Conversational Technology Revolution
**Timeframe:** 00:02:30 - 7m 45s  
**Speakers:** Sarah Critchley

### The Fundamental Shift

Sarah Critchley opened the session by highlighting a profound transformation in how we interact with technology. She emphasized that we have experienced a fundamental shift where natural language conversation has become the normal way to interact with technology systems.

**Key Quote:** *"We have had a fundamental shift in technology. And that shift is the fact that it's normal now to use conversation and questions and natural language to interact with technology."*

This shift represents more than just a new interface paradigm—it's a complete reimagining of the human-computer interaction model. The technology itself isn't entirely new, but the normalization of conversational interfaces marks a watershed moment in computing history.

### Real-World Impact Examples

Sarah illustrated this transformation through several compelling real-world scenarios:

**Banking Applications:**

- Modern banking apps greet users with intelligent agents
- Agents are grounded in personal financial data
- Responses are personalized based on individual banking history and preferences
- The same question asked by different users yields different, contextually appropriate responses

**Enterprise HR Systems:**

- AskHR agents provide travel guidance specific to individual employee data
- Queries are processed within the context of personal employment history and company policies
- Information is delivered with appropriate security and permission controls

**Package Tracking Evolution:**

- Traditional systems simply provided tracking information
- Modern agent-powered systems offer proactive solutions: "What do you want to do about it?"
- One-click resolution options for delivery rescheduling and management

### Why Agents Transform User Experience

The transformation goes beyond mere information retrieval. Agents fundamentally change user experience through four key mechanisms:

**Focus Delivery:** Agents provide targeted, relevant information rather than generic responses, cutting through information noise to deliver precisely what users need.

**Security-Conscious Access:** Information is accessed with user-chosen permissions and security levels, maintaining data privacy while enabling personalized experiences.

**Resolution-Driven Interactions:** Agents don't just complete single tasks—they drive toward actual outcomes and ask "What else can I help you with?"

**Contextual Availability:** Agents are available right at users' fingertips, whenever and wherever they need assistance, integrated into existing workflows.

---

## Microsoft 365 Agents SDK: Complete Developer Control
**Timeframe:** 00:10:15 - 8m 30s  
**Speakers:** Sarah Critchley

### Core Philosophy and Capabilities

The Microsoft 365 Agents SDK embodies a developer-first philosophy that prioritizes choice, flexibility, and value. Sarah articulated the core promise to developers:

**Key Quote:** *"You want value, choice, and flexibility... You want to be able to use the AI that's already been approved by your company's leadership. You want to be able to use your orchestrator that you're already familiar with."*

This philosophy addresses real-world enterprise constraints where companies have already invested in specific AI models, training programs, and development frameworks. The SDK doesn't force developers to abandon existing investments but instead provides a bridge to extend and enhance current capabilities.

### SDK Architecture and Flexibility

The Microsoft 365 Agents SDK provides comprehensive flexibility across all layers of agent development:

**AI Model Agnostic:** 
- Support for any AI model or AI services (OpenAI, Azure AI, custom models)
- No lock-in to Microsoft-specific AI technologies
- Integration with existing AI service approvals and governance

**Orchestrator Choice:**

- Semantic Kernel integration for .NET developers
- LangChain support for JavaScript environments
- Custom orchestrator frameworks
- Preservation of existing developer expertise and training investments

**Knowledge Integration:**

- Enterprise data grounding capabilities
- Connection to existing knowledge bases and data sources
- Preservation of data governance and security policies

**Conversation Management:**

- Built-in state management across conversation sessions
- Storage abstraction for different persistence requirements
- Authentication handling for secure enterprise environments

**Multi-Channel Deployment:**

- Teams, Microsoft 365 Copilot, Web, Slack integration
- Over 15 supported channels out of the box
- Consistent agent behavior across all deployment targets

### Language and Framework Support

The SDK provides first-class support across multiple programming languages and frameworks:

**C# Integration:** Full .NET ecosystem support with deep Semantic Kernel integration, providing rich IntelliSense and debugging capabilities.

**JavaScript Support:** LangChain integration and custom orchestrator support, enabling web developers to leverage existing skills.

**Python Capabilities:** Open-source flexibility combined with enterprise management and governance features.

**Open-Source Foundation:** Transparent, extensible, community-driven development model that allows for customization and contribution.

---

## Microsoft 365 Agents Toolkit: End-to-End Development Experience
**Timeframe:** 00:18:45 - 5m 15s  
**Speakers:** Sarah Critchley

### From File New to Deployment

The Microsoft 365 Agents Toolkit provides comprehensive development support from project creation through production deployment:

**Built-in Templates:** 
- Empty Agent template for complete customization freedom
- Weather Agent template with pre-configured Semantic Kernel or LangChain integration
- Azure AI Foundry ready-to-use cloud AI service connections
- OpenAI agent support with direct service integration

**Agent Playground:** 
- Embedded local testing environment within the toolkit
- Real-time debugging capabilities for agent behavior
- Immediate feedback on AI orchestrator and knowledge integration
- Set debug target and test locally before channel deployment

**Multi-Channel Publishing:** 
- Automated deployment to Teams and Microsoft 365 Copilot
- Deep integration testing capabilities
- Production deployment process automation
- End-to-end deployment pipeline management

### Development Workflow Integration

Sarah emphasized the toolkit's comprehensive approach to developer productivity:

**Key Quote:** *"We're really trying to not just help get you started with the SDK but actually cover that end-to-end deployment and process so you can actually bring all of your components that you want to use together."*

The toolkit eliminates the traditional gap between development and deployment, providing:

- Seamless transition from local development to cloud deployment
- Integrated testing across all target channels
- Automated configuration management for different environments
- Built-in best practices and optimization guidance

### Templates and Scaffolding

The toolkit provides multiple starting points to accommodate different developer preferences and use cases:

**Empty Agent Template:** Basic scaffolding that allows developers to bring any AI model, orchestrator, and knowledge source while providing essential SDK integration points.

**Weather Agent Template:** Pre-configured demonstration that showcases Semantic Kernel or LangChain integration with real-world API consumption (OpenWeather API).

**Enterprise Templates:** Industry-specific templates that demonstrate common enterprise patterns and best practices for production deployment.

---

## Live Coding Demonstrations: Real-World Implementation
**Timeframe:** 00:24:00 - 12m 20s  
**Speakers:** Matthew Barbour

### Semantic Kernel to Multi-Channel Agent

Matthew Barbour demonstrated the transformation of a basic Semantic Kernel console application into a full multi-channel agent in approximately 15 minutes of development time:

**Key Quote:** *"That particular demo took me about 15 minutes to create... Starting with the Semantic Kernel and bringing some things over."*

**Starting Point:** A basic Semantic Kernel console application with OpenWeather API integration that operated in a command-line interface with simple text responses.

**Transformation Process:**
1. **Base Semantic Kernel app** - Console application with OpenWeather API integration
2. **Agent SDK integration** - Add cloud adapter, memory storage, agent applications
3. **Multi-channel deployment** - Same agent running in Playground, Teams, M365 Copilot, Web Chat
4. **Adaptive card generation** - AI-generated rich responses across all channels

**Technical Innovation:** The demonstration showed OpenAI generating adaptive cards without explicit programming—the agent was simply instructed to "create an adaptive card" and the AI model handled the formatting automatically.

### Technical Implementation Deep Dive

The Agent SDK introduces a fundamentally different architecture compared to traditional bot framework approaches:

```csharp
// Core Agent SDK Setup
services.AddCloudAdapter();
services.AddMemoryStorage();
services.AddAgentApplications();

// Event-Driven Agent Logic
public async Task OnMembersAddedAsync(ChannelAccount[] membersAdded, ITurnContext turnContext)
{
    // Welcome message logic
}

public async Task OnMessageAsync(ITurnContext turnContext)
{
    // Semantic Kernel integration for weather queries
    await turnContext.SendActivityAsync(response);
}
```

**Key Architectural Changes:**

- **Event-driven design** replaces activity handler overrides
- **Extension-based channel capabilities** instead of bespoke channel implementations
- **Core SDK capabilities** handle common functions (adaptive cards, streaming, general communication)
- **Channel-specific extensions** provide specialized functionality (Teams tabs, message extensions)

### Multi-Channel Consistency

The demonstration showcased true multi-channel deployment with zero code modifications:

**Deployment Targets:**

- **Agent Playground** - Local development and testing environment
- **Microsoft Teams** - Enterprise collaboration platform integration  
- **M365 Copilot** - Native AI assistant interface
- **Web Chat** - Custom website and application embedding

**Consistency Achievements:**

- Identical agent behavior across all channels
- Same codebase serving multiple deployment targets
- Automatic adaptation to channel-specific capabilities
- Unified debugging and development experience

The demonstration proved that developers can truly build once and deploy everywhere, eliminating the traditional need for channel-specific agent implementations.

---

## Streaming Responses and User Experience Enhancement
**Timeframe:** 00:36:20 - 6m 45s  
**Speakers:** Matthew Barbour

### Interactive Status Communication

Matthew demonstrated the critical importance of streaming responses for modern agent user experiences:

**Key Quote:** *"Use streaming is a capability that was added to the Microsoft ecosystem... streaming response allows us to be a little bit more interactive with our tech."*

Traditional agent interactions suffered from "black box" periods where users received no feedback during processing. Streaming responses transform this experience by providing continuous communication throughout the agent's thinking and processing phases.

### Channel-Adaptive Streaming

The Agent SDK automatically adapts streaming behavior based on channel capabilities:

**Low-Resolution Channels (Basic Web Chat):**

- Simple typing indicators during processing
- Single final response delivery
- Minimal real-time feedback capabilities

**High-Resolution Channels (Teams, M365 Copilot):**

- Real-time status updates throughout processing
- Granular progress communication
- Interactive feedback during long-running operations

**Automatic Adaptation:** The SDK handles upscale and downscale operations automatically, requiring no channel-specific code modifications from developers.

### Implementation Strategy

Matthew emphasized critical timeout management requirements:

**Key Quote:** *"Those of you that want to target this chat, specifically on the M365 cloud, I cannot stress strongly enough, use streaming responses. They are very, very brutal on timeout."*

**Microsoft 365 Copilot Requirements:**

- Extremely aggressive 15-second timeout enforcement
- Immediate acknowledgment required upon request receipt
- Regular status updates throughout processing mandatory
- Error prevention through proactive communication

**Best Practices:**

- **Immediate acknowledgment** - Send status as soon as request received
- **Regular updates** - Continuous communication during processing
- **Channel optimization** - Adapt streaming behavior to channel capabilities
- **Error prevention** - Avoid timeout errors through proactive status communication

This technical requirement represents a critical difference between traditional API development and modern conversational agent development, where user experience expectations drive technical architecture decisions.

---

## Multi-Agent Orchestration and Integration
**Timeframe:** 00:43:05 - 15m 30s  
**Speakers:** Matthew Barbour

### Dispatcher Pattern Implementation

Matthew demonstrated advanced multi-agent orchestration using a dispatcher pattern that coordinates between different agent technologies:

**Architecture Components:**

- **Agent SDK Host:** Central orchestration and channel management
- **Semantic Kernel:** AI reasoning and tool selection
- **OpenAI Integration:** Foundation model for decision-making  
- **Copilot Studio Agent:** Specialized weather service
- **Authentication Layer:** Seamless user token management

The dispatcher pattern allows different agent technologies to work together without requiring them to be aware of each other's existence. Semantic Kernel treats Copilot Studio as just another tool, while Copilot Studio operates independently as a specialized service.

### Advanced Authentication Management

The demonstration revealed sophisticated authentication token management that represents a significant breakthrough in enterprise agent development:

**Key Quote:** *"I cannot tell you how much we've invested in making that work... We don't want you to have to deal with this crap anymore."*

**Token Management Innovation:**

- **User authorization exchange** - Automatic token acquisition for external services
- **Scoped permissions** - Granular access control based on service requirements  
- **SSO integration** - Seamless single sign-on across Microsoft ecosystem
- **Identity passthrough** - Agent runs as system but communicates as authenticated user

**Technical Architecture:**
```csharp
// User Authorization Exchange
services.RegisterAuthorizationHandler("scopedToken", requiredScopes);
var token = await turnContext.GetUserTokenAsync("scopedToken");
```

This architecture allows agents to operate with system-level capabilities while maintaining user identity and permissions throughout all service interactions.

### Live Authentication Demo

Matthew provided unprecedented transparency into the authentication process through Visual Studio debugging:

**Visual Studio Token Decoding:**
```json
{
  "audience": "https://api.powerplatform.com/",
  "upn": "user@microsoft.com",
  "scopes": ["https://api.powerplatform.com/Invoke"]
}
```

**Technical Achievements:**

- **Automatic token exchange** - No manual authentication handling required
- **Multi-environment support** - Switch between different Copilot Studio environments
- **Scoped access** - User permissions determine available agents and data
- **Debugging transparency** - Visual Studio token decoding for development insight

The demonstration showed tokens being automatically exchanged for the appropriate scope (Power Platform API) with user identity preserved throughout the chain of service calls.

**Consent Management Innovation:** The system presents users with minimal, targeted consent dialogs rather than overwhelming permission lists, improving user experience while maintaining security.

---

## Microsoft 365 Copilot APIs Integration
**Timeframe:** 00:58:35 - 18m 25s  
**Speakers:** Sarah Critchley, Matthew Barbour

### Four Core APIs for Enterprise Integration

Sarah introduced the four core Microsoft 365 Copilot APIs designed for enterprise agent integration:

**Retrieval API:**

- Ground agents on Microsoft 365 data without data extraction
- Maintain data governance and security within M365 boundaries
- Semantic indexing leveraging M365's built-in content understanding
- Permission inheritance ensuring user access controls are preserved

**Chat API (Completion API):**

- Headless Microsoft 365 Copilot usage for custom applications
- Embed Copilot experiences within custom agent interfaces
- Programmatic access to Copilot reasoning capabilities
- Integration with native applications and custom workflows

**Meeting Insights API:**

- Teams meeting analysis and automated insights generation
- Pre-processed meeting data: speakers, action items, summaries
- Eliminate need for custom transcription processing
- Direct access to meeting intelligence without raw transcript analysis

**Interactions Export API:**

- User prompts and usage analytics from Copilot interactions
- Usage pattern analysis for optimization and compliance
- Application development based on interaction data
- Enterprise analytics and reporting capabilities

### Retrieval API Deep Dive

The Retrieval API represents a breakthrough in enterprise data grounding:

**Key Quote:** *"This allows you to ground on your M365 data without taking your data out of M365."*

**Technical Implementation:**

- **SharePoint integration** - Target specific sites and document folders
- **Permission inheritance** - User access controls automatically applied
- **Semantic indexing** - Leverage M365's built-in content understanding
- **Scoped access** - Granular control over accessible documents and folders

**Enterprise Benefits:**

- Data never leaves Microsoft 365 ecosystem
- Existing governance and compliance policies maintained
- No data replication or synchronization required
- Real-time access to current document versions

### Live API Demonstration Challenges

Matthew's live demonstration of the Retrieval API revealed the realities of working with preview technologies:

**Key Quote:** *"This demo you're going to see, specifically these API calls, are in private preview... Cross your fingers. We'll get all the way through it, and it'll work properly."*

**Technical Challenges Encountered:**

- **API instability** - Daily changes during private preview development
- **Integration complexity** - Coordinating multiple preview services simultaneously
- **Timeout management** - Teams timeout limitations during debugging sessions
- **Model coordination issues** - OpenAI and Semantic Kernel coordination challenges

**Development Reality Demonstration:**
The live debugging session showed several real-world challenges:

- Authentication token visualization in Visual Studio
- API timeout handling during development
- Integration between multiple preview services
- Model decision-making processes and potential infinite loops

**Future Stability Promise:** *"Give us another week, another week and a half"* - demonstrating Microsoft's commitment to resolving preview issues for production readiness.

The demonstration, despite technical challenges, successfully showed data retrieval from SharePoint via the Retrieval API with proper permission scoping and user authentication.

---

## KPMG Enterprise Implementation Case Study
**Timeframe:** 01:16:50 - 12m 15s  
**Speakers:** Gaurave Sehgal, Renil Abdulkader

### Global Tax Intelligence Platform

KPMG presented their Digital Gateway platform, demonstrating enterprise-scale implementation of the Microsoft 365 Agents SDK:

**Business Context:** 
- 125 years in business serving global enterprise clients
- 250,000+ employees worldwide
- Focus on tax planning, preparation, and compliance for Fortune 500 companies
- Core mission: translate complex tax codes into reliable, maintainable applications

**Digital Gateway Architecture:**
```
KPMG Digital Gateway Platform:
├── Workflows: Tax process automation and management
├── Document Management: Regulatory document handling  
├── GenAI Capabilities: Intelligent personas and assistants
├── Multi-Channel Access: Web platform + Teams + M365 integration
└── Global Scale: Serving Fortune 500 clients worldwide
```

### Tax Intelligence Personas

KPMG has developed specialized AI personas that embody decades of tax expertise:

**Global Tax Incentive Researcher:**

- Specialized knowledge for international tax scenarios
- Real-time regulatory compliance interpretation
- Integration with KPMG's intellectual property and thought leadership
- Document attachment capabilities for tax professionals

**Technical Innovation:**
Tax professionals can attach documents directly from their laptops or connect to existing Digital Gateway data sources, creating personalized knowledge bases for specific client scenarios.

**Example Scenarios Demonstrated:**
1. **US-China Operations:** "We have manufacturing operations in China but R&D in US. What are the different tax incentives available to us?"
2. **Mexico Manufacturing:** "What's the different tax funds available in Mexico if you are doing automobile manufacturing?"

These scenarios demonstrate the system's ability to handle complex, multi-jurisdictional tax questions that require deep domain expertise and current regulatory knowledge.

### Cross-Tenant Authentication Excellence

Renil demonstrated sophisticated cross-tenant authentication that represents a significant technical achievement:

**Technical Challenge:** Enabling users from hundreds or thousands of different Azure AD tenants to securely access KPMG's tax intelligence while maintaining governance and security.

**Authentication Architecture:**

- **On-behalf-of token generation** for logged-in users
- **Single sign-on** across tenant boundaries
- **Seamless experience** - users unaware of complex authentication processes
- **Heavy lifting** performed by Digital Gateway backend systems

**Implementation Benefits:**

- Users logged into their own tenant can access KPMG services
- No additional authentication prompts or complexity
- Maintained security and governance across organizational boundaries
- Scalable architecture supporting global enterprise client base

**Integration Achievement:** The same AI personas and capabilities available in Digital Gateway web platform are seamlessly accessible through Teams and Microsoft 365 Copilot, demonstrating true multi-channel consistency.

---

## Call to Action and Resources
**Timeframe:** 01:29:05 - 3m 45s  
**Speakers:** Sarah Critchley, Matthew Barbour

### Getting Started

Sarah concluded with specific next steps for developers:

**Primary Call to Action:** "Get started with the Toolkit and the SDK" - emphasizing immediate hands-on experimentation as the best learning approach.

**Available Resources:**

- **aka.ms/agents** - Primary SDK documentation and download location
- **Build Labs** - Hands-on workshops starting at 8:30 the following morning
- **Open Hack** - Real-time product group support for agent development
- **Competition** - Build challenge for best agent instructions

### Partner Ecosystem Acknowledgment

The session recognized key partners driving agent innovation:

**Accenture Partnership:** Integration of Microsoft 365 Agents SDK with AI Refinery and trusted agent huddle, helping organizations build networks of interoperable agents.

**Microsoft Partner Ecosystem:** Recognition of the dedication and time investment required for partners to build with preview technologies and provide crucial feedback for product development.

### Deployment Clarification

A final audience question clarified an important technical detail about the demonstration:

**Question:** "Did I miss the step where you deployed your code into the cloud?"

**Matthew's Response:** All demonstrations ran locally on his laptop with only Azure Bot Service registration and manifest deployment to the cloud. The Agent Toolkit provides full deployment automation for production scenarios, but local development and testing is fully supported without cloud deployment.

This clarification emphasizes the development-friendly nature of the SDK, allowing complete local development and testing before any cloud commitment.

---

## Appendix

### Technical Deep Dives Referenced But Not Demonstrated

**Visual Studio Code Integration:** The session referenced upcoming VS Code extension for Copilot Studio editing but did not demonstrate this capability.

**Computer Use Agents:** Mentioned in summary but not discussed during the actual presentation.

**Office Add-in Integration:** Referenced in materials but not demonstrated during the session.

### Presentation Context Details

**Conference Setting:** Microsoft Build 2025, Day 1, 6:00 PM session on third floor
**Audience:** Developer-focused audience comfortable with code demonstrations
**Session Philosophy:** "Code over PowerPoint" approach with live demonstrations prioritized over slides

### Related Sessions Referenced

**Previous Day Session:** Matthew referenced a previous session where he demonstrated full URL connection strings for Copilot Studio integration.

**Lab Availability:** "Create a Custom Engine Agent with M365 Agent SDK" lab mentioned as hands-on follow-up experience.

---

## References

### Official Microsoft Documentation
- **[Microsoft 365 Agents SDK Documentation](https://aka.ms/agents)** - Primary resource for SDK download, documentation, and getting started guides. Essential for developers beginning agent development with comprehensive tutorials and API references.

- **[Microsoft Build 2025 Session Recordings](https://build.microsoft.com)** - Complete session recordings and presentation materials. Valuable for reviewing demonstrations and accessing updated content as APIs move from preview to general availability.

### Development Tools and Resources
- **[Semantic Kernel GitHub Repository](https://github.com/microsoft/semantic-kernel)** - Open-source orchestration framework demonstrated extensively in the session. Critical for .NET developers implementing AI agents with Microsoft's recommended architecture patterns.

- **[Azure Bot Service Documentation](https://docs.microsoft.com/azure/bot-service/)** - Foundation service for agent registration and channel deployment. Essential for understanding the underlying infrastructure that powers multi-channel agent deployment.

### API Documentation
- **[Microsoft 365 Copilot APIs Documentation](https://docs.microsoft.com/graph/api/overview)** - Documentation for Retrieval, Chat, Meeting Insights, and Interactions Export APIs. Critical for developers implementing enterprise M365 integration with proper authentication and data governance.

- **[Microsoft Graph API Reference](https://docs.microsoft.com/graph/api/overview)** - Required for accessing M365 data with user permissions. Essential for understanding permission scopes and authentication patterns demonstrated in the session.

### Partner Solutions
- **[KPMG Digital Gateway](https://home.kpmg/xx/en/home/services/tax/digital-gateway.html)** - Enterprise tax intelligence platform demonstrating production-scale Agent SDK implementation. Valuable case study for understanding enterprise deployment patterns and cross-tenant authentication strategies.

### Community Resources
- **[Microsoft 365 & Power Platform Community](https://pnp.github.io/)** - Community-driven resources for agent development best practices. Important for staying current with community solutions and getting peer support for complex implementation challenges.

- **[Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)** - Enterprise architecture patterns for agent deployment. Critical for architects designing production agent systems with proper security, scalability, and governance.

Each reference provides specific value for different aspects of agent development, from initial learning through production deployment and enterprise integration.
