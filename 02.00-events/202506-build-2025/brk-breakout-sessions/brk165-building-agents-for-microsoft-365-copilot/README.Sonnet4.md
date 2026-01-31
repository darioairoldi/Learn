# Building Agents for Microsoft 365 Copilot: From No-Code to Pro-Code

**Session Date:** May 19, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK165  
**Speakers:** Aaron Bjork (Product Management Director, Microsoft Copilot Studio Team), Abram Jackson (PM for M365 Copilot Extensibility, Microsoft)  
**Link:** [Microsoft Build 2025 Session BRK165](https://mybuild.microsoft.com/sessions/BRK165)

---

## Table of Contents

1. [Introduction and Session Overview](#introduction-and-session-overview)
   1. [Welcome and Speaker Introductions](#welcome-and-speaker-introductions)
   2. [Session Objectives and Agenda](#session-objectives-and-agenda)
2. [Fundamental Concepts: Copilot and Agents](#fundamental-concepts-copilot-and-agents)
   1. [Understanding Copilot](#understanding-copilot)
   2. [Defining Agents](#defining-agents)
   3. [The Symbiotic Relationship](#the-symbiotic-relationship)
3. [The Agent-Centric World: Paradigm Shift](#the-agent-centric-world-paradigm-shift)
   1. [Market Transformation Scale](#market-transformation-scale)
   2. [Orchestra vs Jazz Quartet Analogy](#orchestra-vs-jazz-quartet-analogy)
   3. [Copilot as the UI for AI](#copilot-as-the-ui-for-ai)
4. [Agent Architecture: Technical Deep Dive](#agent-architecture-technical-deep-dive)
   1. [The Five Core Ingredients](#the-five-core-ingredients)
   2. [Orchestrator and Model Synergy](#orchestrator-and-model-synergy)
   3. [Knowledge Grounding](#knowledge-grounding)
   4. [Tools and Actions](#tools-and-actions)
   5. [Multi-Agent Collaboration](#multi-agent-collaboration)
5. [No-Code Agent Builder: Democratizing AI Development](#no-code-agent-builder-democratizing-ai-development)
   1. [Agent Builder Philosophy](#agent-builder-philosophy)
   2. [New Features and Capabilities](#new-features-and-capabilities)
   3. [Live Demo: Build 2025 Concierge Agent](#live-demo-build-2025-concierge-agent)
   4. [Multi-Agent Integration Preview](#multi-agent-integration-preview)
6. [Copilot Studio: Professional Agent Platform](#copilot-studio-professional-agent-platform)
   1. [Platform Positioning and Capabilities](#platform-positioning-and-capabilities)
   2. [Advanced Model Integration](#advanced-model-integration)
   3. [Live Demo: Contoso Employee Resources Agent](#live-demo-contoso-employee-resources-agent)
   4. [Agent-to-Agent Communication](#agent-to-agent-communication)
   5. [Visual Studio Code Integration](#visual-studio-code-integration)
7. [Industry Implementation: Nintex Partnership Demo](#industry-implementation-nintex-partnership-demo)
   1. [Employee Onboarding Use Case](#employee-onboarding-use-case)
   2. [Automated Solution Architecture](#automated-solution-architecture)
   3. [Performance Results](#performance-results)
8. [Professional Development: M365 Agents Toolkit and SDK](#professional-development-m365-agents-toolkit-and-sdk)
   1. [Microsoft 365 Agents Toolkit](#microsoft-365-agents-toolkit)
   2. [Office Add-in Integration](#office-add-in-integration)
   3. [Microsoft 365 Agents SDK](#microsoft-365-agents-sdk)
   4. [Live Demo: Weather Agent Development](#live-demo-weather-agent-development)
9. [Session Wrap-Up and Resources](#session-wrap-up-and-resources)
   1. [Key Takeaways](#key-takeaways)
   2. [Additional Sessions and Learning](#additional-sessions-and-learning)

---

## Introduction and Session Overview

### Welcome and Speaker Introductions

**Time: 00:00:00 - 00:01:30**  
**Duration: 1m 30s**  
**Speakers: Aaron Bjork, Abram Jackson**

Aaron Bjork opened the session by welcoming attendees to the third floor venue on the first day of Microsoft Build 2025 at 6:00 PM. He introduced himself as a Product Manager on the Copilot Studio Team and welcomed Abram Jackson to the stage. Abram Jackson introduced himself as working on Microsoft 365 Copilot extensibility, expressing enthusiasm for the topic.

The speakers established the session's focus on building agents for Microsoft 365 Copilot and acknowledged the comprehensive agenda ahead, including multiple demonstrations and technical deep dives.

### Session Objectives and Agenda

**Time: 00:01:30 - 00:02:00**  
**Duration: 30s**  
**Speakers: Aaron Bjork**

Aaron outlined the session's ambitious scope, mentioning "a lot of ground to cover" with "a bunch of demos" planned. The session was structured to move quickly through different development approaches, from no-code solutions to professional development tools.

---

## Fundamental Concepts: Copilot and Agents

### Understanding Copilot

**Time: 00:02:00 - 00:04:30**  
**Duration: 2m 30s**  
**Speakers: Abram Jackson**

Abram provided a foundational definition of Copilot, emphasizing Microsoft's intentional naming strategy:

> "We want Copilot to be your personal assistant, that you use it and it is helping you with your work. We're pretty intentional about matching the products to that name. It isn't 'the pilot,' it isn't running off without you, it is your copilot and it is assisting you."

**Key Copilot Characteristics:**

- **Personal Context Awareness:** Knows about the user, their work, projects, and colleagues
- **Assistive Role:** Designed to help users achieve more and "look great" using AI assistance
- **Work Integration:** Connected to Microsoft 365 data and enterprise systems
- **User-Controlled:** Always working with the user, not autonomously replacing them

### Defining Agents

**Time: 00:04:30 - 00:06:00**  
**Duration: 1m 30s**  
**Speakers: Abram Jackson**

Abram defined agents as specialized entities with specific business focus:

> "Agents are specialists to represent business processes or to understand a space. This is an excellent use for agents of the grounding information, the knowledge, and the APIs, and the data, to process and understand and work through some business process."

**Agent Characteristics:**

- **Business Process Specialists:** Understanding specific domains and workflows
- **Knowledge Integrators:** Processing grounded information and real-time data
- **Implementation Engines:** Actually executing business processes
- **Copilot Connectors:** Enabling Copilot interaction with specialized systems

### The Symbiotic Relationship

**Time: 00:06:00 - 00:07:00**  
**Duration: 1m**  
**Speakers: Abram Jackson**

The relationship between Copilot and agents was established as symbiotic, where Copilot provides the personal assistant interface while agents provide specialized domain expertise and system integration capabilities.

---

## The Agent-Centric World: Paradigm Shift

### Market Transformation Scale

**Time: 00:07:00 - 00:09:30**  
**Duration: 2m 30s**  
**Speakers: Aaron Bjork**

Aaron presented the transformational scale of agent adoption, citing IDC research:

> "IDC, recently, if you are familiar with IDC, they're an analyst, they projected that there's over a billion new business process agents that are going to be created over the next four years."

**Transformation Metrics:**

- **1 billion new business process agents** over 4 years
- **1 agent per 7.5 people** globally (including children)
- **Every function and process** in organizations will be affected
- **Universal business impact** across all industries and domains

### Orchestra vs Jazz Quartet Analogy

**Time: 00:09:30 - 00:12:00**  
**Duration: 2m 30s**  
**Speakers: Aaron Bjork**

Aaron introduced a compelling metaphor to illustrate the paradigm shift:

**App-Centric World (Orchestra):**

- **Structured coordination:** Musicians following sheet music
- **Specialized roles:** Each instrument with specific purpose
- **Central conductor:** Orchestrated control and coordination
- **Beautiful but rigid:** Precise execution within defined parameters

**Agent-Centric World (Jazz Quartet):**

- **Improvised collaboration:** Musicians playing off each other dynamically
- **Adaptive interaction:** Listening and responding to other participants
- **No sheet music:** Flexible, context-driven performance
- **Creative emergence:** New possibilities through spontaneous collaboration

### Copilot as the UI for AI

**Time: 00:12:00 - 00:15:00**  
**Duration: 3m**  
**Speakers: Abram Jackson**

Abram expanded on Satya Nadella's concept of "Copilot is the UI for AI":

> "You've heard Satya say now lots of times, if you've been watching his keynotes, that Copilot is the UI for AI... But without agents, it's not connected to your work systems."

**Key Points:**

- **Bridge Function:** Agents connect Copilot to work systems where business gets done
- **System Integration:** Connection to systems of record, ticket tracking, customer databases
- **Microsoft 365 Context:** Hundreds of millions of workers using Teams, Outlook, Word, Excel, PowerPoint
- **Security and Governance:** Safest, most governed environment for AI deployment

---

## Agent Architecture: Technical Deep Dive

### The Five Core Ingredients

**Time: 00:15:00 - 00:18:00**  
**Duration: 3m**  
**Speakers: Aaron Bjork**

Aaron presented the fundamental architecture components that define any agent:

```yaml
Agent Architecture Components:
├── Orchestrator: Control layer managing component interactions
├── Model: The "brain" providing reasoning and decision-making  
├── Knowledge: Grounding in verifiable, contextual information
├── Tools: Action-taking capabilities for real-world interactions
└── Triggers: Autonomous invocation and workflow initiation
```

### Orchestrator and Model Synergy

**Time: 00:18:00 - 00:19:30**  
**Duration: 1m 30s**  
**Speakers: Aaron Bjork**

Aaron explained the relationship between orchestrator and model using an executive function metaphor:

> "One of the ways to think about this is think of the model being the brain of the agent, but the orchestrator really being the executive function. They sort of work together hand-in-hand."

**Functional Relationship:**

- **Model as Brain:** Core reasoning and intelligence capabilities
- **Orchestrator as Executive Function:** Decision-making about when and how to act
- **Coordinated Operation:** Determining when to invoke models, APIs, or external systems
- **Strategic Control:** Managing the flow of information and actions

### Knowledge Grounding

**Time: 00:19:30 - 00:20:30**  
**Duration: 1m**  
**Speakers: Aaron Bjork**

Knowledge grounding was defined as the foundation of reliable agent operation:

> "We call this grounding. And that's the idea that when you bring knowledge into an agent, you're really connecting that agent to real, verifiable and contextually relevant information."

**Grounding Benefits:**

- **Prevents Hallucination:** Ensures accuracy through verifiable information
- **Contextual Relevance:** Information specific to business domain and use case
- **Real-time Data:** Connection to live systems and updated information
- **Multi-source Integration:** SharePoint, OneDrive, email, Teams, external databases

### Tools and Actions

**Time: 00:20:30 - 00:21:30**  
**Duration: 1m**  
**Speakers: Aaron Bjork**

Tools were positioned as the action-taking components of agents:

> "Tools are what we use to do things. So these are the things that actually take action."

**Tool Capabilities:**

- **Real-time Data Access:** Live information retrieval and processing
- **First and Third-party Systems:** Comprehensive integration capabilities
- **Autonomous Action Execution:** Tasks performed on behalf of users
- **API Orchestration:** Complex workflows across multiple systems

### Multi-Agent Collaboration

**Time: 00:21:30 - 00:22:00**  
**Duration: 30s**  
**Speakers: Aaron Bjork**

Aaron introduced the concept of agent teams, referencing Satya's keynote announcement:

> "One of the real goals is to build teams of agents where agents can work together, talk together."

---

## No-Code Agent Builder: Democratizing AI Development

### Agent Builder Philosophy

**Time: 00:22:00 - 00:25:30**  
**Duration: 3m 30s**  
**Speakers: Abram Jackson**

Abram articulated the inclusive philosophy behind Agent Builder:

> "The idea and the reason why we wanted to talk through those ingredients of an agent... is that anyone can create an agent with these ingredients. It doesn't matter who you are and your persona and the way that you operate."

**Universal Accessibility:**

- **All Skill Levels:** From end users who "have never opened Visual Studio" to professional developers
- **Universal Deployment:** Web, Windows, Office applications, mobile M365 Copilot app
- **License Flexibility:** Works for both licensed and unlicensed M365 users
- **Team-Scale Solutions:** Perfect for 3-6 person team processes
- **IT Independence:** End users don't need to request IT projects for automation

**IDC Context:**

- **Billion Agent Need:** Referencing IDC's projection of 1 billion agents needed
- **Personal Usage:** Abram uses Agent Builder for his own agents despite having access to pro-code tools

### New Features and Capabilities

**Time: 00:25:30 - 00:28:00**  
**Duration: 2m 30s**  
**Speakers: Abram Jackson**

Abram announced several brand-new features being discussed for the first time at Build:

**Enhanced Knowledge Integration:**

- **Team Chat History:** Access to organizational conversation context
- **Email Integration:** Grounding in communication patterns and content
- **Office 365 Entities:** SharePoint, OneDrive for Business integration
- **Organizational Connectors:** Whatever connectors the organization has configured
- **Website Grounding:** Specific websites and web domains
- **Embedded Files:** Direct file sharing with agent distribution

**Agent Store Redesign:**

- **Ground-up Rebuild:** Completely new user experience designed for agent discovery
- **Unified Navigation:** Agents, conversations, pages in integrated interface
- **Search and Filter:** Easy discovery of relevant agents for specific processes
- **One-click Sharing:** Instant distribution to teams and organizations

### Live Demo: Build 2025 Concierge Agent

**Time: 00:28:00 - 00:33:00**  
**Duration: 5m**  
**Speakers: Abram Jackson**

Abram demonstrated the new Agent Store interface and Agent Builder capabilities through a practical example:

**Demo Components:**

- **Knowledge Sources:** Build 2025 "Book of News" and build.microsoft.com website
- **Agent Creation Time:** "Just a couple of minutes" to complete
- **Pre-built Capabilities:** Code interpreter and conversation starters
- **Agent Store Interface:** New navigation showing agents, conversations, pages
- **Knowledge Picker:** Search functionality for information sources

**Live Query Example:**

```text
User Query: "Tell me about the new features of Copilot Studio?"
Agent Response: Multi-agent orchestration, model fine-tuning, and many others
Grounding: Website data and official documentation
Result: Accurate, contextual information from verified sources
```

### Multi-Agent Integration Preview

**Time: 00:33:00 - 00:36:00**  
**Duration: 3m**  
**Speakers: Abram Jackson**

Abram showcased a preview of multi-agent capabilities through a Lumen partnership demonstration:

**Researcher Agent Integration:**

- **Task:** Create executive financial report on Lumen including financial performance and press releases
- **Multi-agent Coordination:** Researcher agent coordinating with Lumen Quarterly Report Agent
- **Organizational Customization:** "How do you want to structure this report?"
- **Seamless Integration:** "It works the first try every single time"
- **Enterprise Implementation:** Agents built by Lumen for their own organizational use

**Future Availability:**

- Not yet available to all users but coming soon
- Preview capability being developed for broader multi-agent support

---

## Copilot Studio: Professional Agent Platform

### Platform Positioning and Capabilities

**Time: 00:36:00 - 00:38:30**  
**Duration: 2m 30s**  
**Speakers: Aaron Bjork**

Aaron positioned Copilot Studio as an enterprise-ready agent development platform:

> "Copilot Studio is a SaaS agent platform and it's designed to help you really quickly and efficiently build agents that are ready to deploy in your organization. You can go from starting point to deployed with metrics, with analytics, with safety rails, with responsible AI literally in hours if not a number of days."

**Platform Capabilities:**

- **Rapid Development:** Hours to days vs. weeks for traditional development
- **Enterprise-Ready:** Built-in metrics, analytics, safety rails, responsible AI
- **Multi-Channel Publishing:** M365 Copilot and other destinations
- **Foundation Model Choice:** Managed models plus Azure AI Foundry integration
- **Knowledge Customization:** Multiple source integration and RAG configuration
- **Tool Integration:** First and third-party system connections
- **Autonomous Workflows:** Self-directed task execution

**Architecture Control:**

- **Full Access:** All shaded areas in the architecture diagram
- **Model Selection:** Managed models and Azure AI Foundry connections
- **Publishing Channels:** Multiple deployment destinations
- **Knowledge and Tools:** Complete customization capabilities
- **Orchestrator Limitation:** Currently managed by Microsoft (future opening expected)

### Advanced Model Integration

**Time: 00:38:30 - 00:40:00**  
**Duration: 1m 30s**  
**Speakers: Aaron Bjork**

Aaron highlighted four key features before the demonstration:

**Key Features:**

1. **Azure AI Foundry Integration:** Access to 1,900+ models through API key configuration
2. **Computer Use Agents (CUA):** Preview feature allowing human-like computer interaction
3. **Agent-to-Agent Interactions:** Multi-agent coordination and communication
4. **Model Context Protocol (MCP):** Connection to external servers and systems

### Live Demo: Contoso Employee Resources Agent

**Time: 00:40:00 - 00:50:00**  
**Duration: 10m**  
**Speakers: Aaron Bjork**

Aaron provided a comprehensive demonstration of Copilot Studio's enterprise capabilities:

**Agent Configuration:**

```yaml
Contoso Employee Resources Agent:
├── Purpose: Employee onboarding assistance for fictitious company
├── Knowledge Source: Company SharePoint site
├── Model: GPT-4o with custom RAG configuration
├── Orchestration: Generative Orchestration enabled
└── Analytics: Complete usage tracking and business outcome measurement
```

**Business Intelligence Features:**

- **Session Analytics:** User interaction patterns and usage metrics
- **Knowledge Source Tracking:** Most accessed information and documents
- **Tool Utilization:** Feature usage and workflow optimization data
- **Test Framework:** Automated evaluation and outcome verification

**Model Customization:**

- **RAG Configuration:** Full control over retrieval and generation parameters
- **Moderation Levels:** Adjustable content filtering and safety controls
- **Custom Instructions:** Specific guidance on model response behavior
- **Model Selection:** Choice between managed models or Azure AI Foundry deployments

### Agent-to-Agent Communication

**Time: 00:50:00 - 00:55:00**  
**Duration: 5m**  
**Speakers: Aaron Bjork**

Aaron demonstrated sophisticated multi-agent orchestration:

**Connected Agents:**

- **Contoso Tax Advisor:** Specialized tax and financial guidance
- **Contoso Vacation Advisor:** HR policy and time-off management
- **Dynamic Selection:** Host agent choosing appropriate specialist

**Live Interaction Example:**

```text
User Query: "How much vacation do I get as a new employee and how do I accrue more?"

Process Flow:
1. Employee Resources Agent receives query
2. Identifies vacation-related intent  
3. Invokes Contoso Vacation Advisor
4. Receives structured response with documentation
5. Presents integrated answer with source verification

Result: "New employees receive 2.5 weeks vacation upon hire. 
After one year of service, vacation increases to 3.5 weeks."
```

**Activity Map Visualization:**

- **Chain of Thought Tracking:** Complete reasoning process display
- **Agent Invocation Visualization:** Multi-agent workflow mapping
- **Source Document Linking:** Direct validation and drill-through capability
- **Debugging Tools:** Developer visibility into agent decision-making

### Visual Studio Code Integration

**Time: 00:55:00 - 00:58:00**  
**Duration: 3m**  
**Speakers: Aaron Bjork**

Aaron announced and demonstrated a revolutionary development experience:

**Major Announcement:** New VS Code extension for direct Copilot Studio editing

**Extension Capabilities:**

```yaml
VS Code Copilot Studio Extension:
├── Clone Agent: Download agent definitions to local development
├── YAML Editing: Direct manipulation of agent configuration
├── Language Server: IntelliSense and syntax support for agent definitions
├── GitHub Copilot Integration: AI-assisted agent development
└── Push to Server: Seamless deployment back to Copilot Studio
```

**Developer Experience:**

- **Local Development:** Full editing capabilities offline
- **Version Control:** Git integration for agent configuration management
- **IntelliSense Support:** Type-ahead and error detection for YAML structures
- **AI-Assisted Development:** GitHub Copilot suggestions for agent configuration
- **Bi-directional Sync:** Seamless movement between VS Code and Copilot Studio

---

## Industry Implementation: Nintex Partnership Demo

### Employee Onboarding Use Case

**Time: 00:58:00 - 01:00:00**  
**Duration: 2m**  
**Speakers: Video presentation (Nintex partner)**

The Nintex demonstration showcased real-world enterprise agent implementation at Safalo Finance:

**Business Challenge:**

- **30-minute Manual Workflow:** Document download, update, signature coordination
- **Legacy System Integration:** On-premise financial system certification requirements
- **Multi-step Coordination:** HR team managing complex approval workflows
- **Error-prone Processes:** Inconsistent document handling and delays

### Automated Solution Architecture

**Time: 01:00:00 - 01:03:00**  
**Duration: 3m**  
**Speakers: Video presentation (Nintex partner)**

**Solution Components:**

```yaml
Employee Onboarding Agent Architecture:
├── Nintex Workflow: Document generation and template population
├── Nintex K2: On-premise system provisioning and certification
├── OneDrive Integration: File storage and organization
├── E-signature Workflow: Automated document signing process
└── Email Coordination: Notification and process management
```

**Workflow Process:**

1. **Information Collection:** Agent gathers new employee details through conversational interface
2. **Document Generation:** Nintex Workflow populates templates with employee data
3. **File Organization:** Automated folder creation and document storage in OneDrive
4. **On-premise Provisioning:** Legacy system access and certification setup through Nintex K2
5. **E-signature Initiation:** Automated delivery of documents for signature

### Performance Results

**Time: 01:03:00 - 01:03:30**  
**Duration: 30s**  
**Speakers: Video presentation (Nintex partner)**

**Transformation Metrics:**

- **30 minutes → 2 minutes:** 93% reduction in processing time
- **Zero Manual Errors:** Automated accuracy and consistency
- **Integrated Experience:** Single Teams interface for complete workflow
- **Scalable Process:** Consistent experience across all new hires

---

## Professional Development: M365 Agents Toolkit and SDK

### Microsoft 365 Agents Toolkit

**Time: 01:03:30 - 01:07:00**  
**Duration: 3m 30s**  
**Speakers: Abram Jackson**

Abram introduced the professional development platform for complete agent control:

> "The Microsoft 365 Agents Toolkit... gives you full control, full power over these agent ingredients... you can change out any part of this architecture."

**Complete Control Architecture:**

```yaml
Professional Developer Control:
├── Orchestrator: Custom logic and decision-making frameworks
├── Models: Any model from any provider, hosted anywhere
├── Knowledge: Custom knowledge sources and processing
├── Tools: Unlimited integration possibilities  
└── Deployment: Full control over hosting and distribution
```

**Platform Features:**

- **Teams Meetings Integration:** Agents running directly in meeting contexts
- **Universal M365 Compatibility:** Licensed and unlicensed M365 users
- **Visual Studio Code Integration:** Professional development environment
- **TypeSpec Support:** Simplified API specification management
- **Office Add-in Integration:** Direct manipulation of Word, Excel, PowerPoint

**Evolution from Teams Toolkit:**

- **Enhanced Power:** Significant additional capabilities beyond previous toolkit
- **Flexible Architecture:** Choice of Microsoft or custom orchestrators, models, tools
- **Multi-platform Publishing:** Teams meetings, M365 Copilot chat, external platforms

### Office Add-in Integration

**Time: 01:07:00 - 01:10:00**  
**Duration: 3m**  
**Speakers: Abram Jackson**

Abram demonstrated breakthrough Office Add-in integration through LexisNexis partnership:

**LexisNexis Legal Professional Integration:**

**Clause Rewriting Capability:**

- **Context Awareness:** Agent understands selected text in Word document
- **Domain Expertise:** Legal language and formatting optimization
- **In-place Editing:** Direct document modification with user confirmation
- **Professional Accuracy:** Legal-grade precision and compliance

**Shepardize® Feature:**

- **Citation Validation:** Automated legal citation checking and verification
- **Case Law Analysis:** Determining if precedents are still valid or overturned
- **Document Enhancement:** Adding visual indicators for citation status
- **Professional Workflow:** Integration with existing legal research processes

**Technical Implementation:**

- **Context Transfer:** Selected Word content automatically available to agent
- **Language Model Integration:** Custom legal domain understanding
- **Document Modification:** Direct text replacement in Word documents
- **Visual Enhancement:** Automated icon and formatting additions

### Microsoft 365 Agents SDK

**Time: 01:10:00 - 01:12:00**  
**Duration: 2m**  
**Speakers: Aaron Bjork**

Aaron introduced the comprehensive development framework:

> "The SDK is a full developer framework and it's designed to simplify the creation of full stack, multi-channel, enterprise-grade AI agents that can operate across M365, Teams, Copilot Studio and external platforms like Slack, Twilio and others."

**SDK Capabilities:**

- **Full-Stack Development:** Complete agent creation framework
- **Multi-Channel Publishing:** M365, Teams, Copilot Studio, external platforms
- **Enterprise-Grade:** Production-ready with enterprise requirements built-in
- **Multi-Language Support:** C#, Python, JavaScript
- **Complete Control:** Choice of orchestrator, models, knowledge sources, deployment

**Integration Features:**

- **Azure AI Services:** Complete Microsoft AI stack integration
- **Semantic Kernel:** Advanced AI orchestration framework
- **Third-party AI Services:** Provider-agnostic model integration
- **External Platforms:** Slack, Twilio, custom systems

### Live Demo: Weather Agent Development

**Time: 01:12:00 - 01:16:00**  
**Duration: 4m**  
**Speakers: Aaron Bjork**

Aaron demonstrated the Visual Studio template system and rapid agent development:

**Visual Studio Template System:**

```yaml
Visual Studio Agent Development Process:
├── Template Selection: Multiple agent patterns available
├── Service Configuration: OpenAI/Azure OpenAI integration
├── Scaffolding Generation: Complete project structure
├── Emulator Testing: Built-in testing and debugging
└── Deployment Options: Multiple distribution channels
```

**Available Templates:**

- **API Integration Agent:** Working with external APIs
- **Basic Teams Agent:** Simple Teams-focused functionality
- **Declarative Agent:** Using Microsoft's orchestration
- **Empty Agent:** Starting from scratch
- **Weather Agent:** Demonstration template with emulator

**Development Experience:**

- **Service Selection:** Choice between OpenAI and Azure OpenAI
- **Configuration Input:** API keys, endpoints, deployment names
- **Instant Scaffolding:** Complete agent project in minutes
- **Built-in Emulator:** Local testing and debugging environment
- **Adaptive Card Responses:** Rich formatting and interactive elements

**Demo Results:**

```text
User Query: "Compare the average rainfall of Seattle, Washington to Boston, Massachusetts"
Agent Response: Structured comparison with weather data, formatted as adaptive card
Development Time: Minutes from template to working agent
Integration: Direct Azure OpenAI model connection
```

---

## Session Wrap-Up and Resources

### Key Takeaways

**Time: 01:16:00 - 01:17:00**  
**Duration: 1m**  
**Speakers: Abram Jackson, Aaron Bjork**

The speakers acknowledged the comprehensive nature of the presentation:

> "So I think that might have been a lot for everybody across Agent Builder, Copilot Studio, the Agent Toolkit and the Agents SDK. And we did not talk about all of the new features in all of these things."

**Coverage Summary:**

- **Agent Builder:** No-code democratization of agent development
- **Copilot Studio:** Professional platform for enterprise agent deployment
- **Agents Toolkit:** Full-control development for professional developers
- **Agents SDK:** Complete framework for multi-platform enterprise solutions

### Additional Sessions and Learning

**Time: 01:17:00 - 01:18:00**  
**Duration: 1m**  
**Speakers: Aaron Bjork, Abram Jackson**

The speakers directed attendees to additional learning opportunities:

**Related Sessions at Build:**

- **Building Agents:** More detailed agent construction techniques
- **Architecting Agents:** Advanced architectural patterns
- **Multi-agent Systems with Copilot Studio:** Deep dive into agent orchestration
- **Agents SDK:** Comprehensive SDK coverage
- **MCP and Copilot Studio:** Model Context Protocol implementation
- **Labs and Hands-on:** Practical implementation exercises

**Interactive Opportunities:**

- **Agent Instructions Contest:** Community engagement activity
- **OpenHack:** Hands-on development experience
- **Product Team Access:** Direct interaction with Microsoft experts
- **Documentation and Examples:** Comprehensive learning resources
- **Q&A Session:** Continued discussion in the hallway after formal session

**Availability:** Both speakers committed to being available throughout the remainder of Build 2025 for questions and deeper discussions.

---

## References

### Microsoft Official Documentation

- **[Microsoft Build 2025 Official Site](https://build.microsoft.com)** - Complete conference content, session recordings, and announcements. Essential resource for accessing all Build 2025 materials and staying current with Microsoft's latest AI and development announcements.

- **[Microsoft 365 Copilot Documentation](https://docs.microsoft.com/microsoft-365/copilot/)** - Comprehensive guide to Microsoft 365 Copilot features, deployment, and best practices. Critical for understanding the platform foundation that agents extend and integrate with.

- **[Copilot Studio Documentation](https://docs.microsoft.com/power-platform/copilot-studio/)** - Official documentation for Copilot Studio platform, including tutorials, API references, and enterprise deployment guidance. Essential for implementing the professional agent development approach demonstrated in the session.

### Development Tools and SDKs

- **[Microsoft 365 Agents SDK](https://github.com/microsoft/teams-ai)** - GitHub repository for the Microsoft 365 Agents SDK with code samples, templates, and community contributions. Provides hands-on resources for professional developers building enterprise-grade agents.

- **[Visual Studio Code Extensions Marketplace](https://marketplace.visualstudio.com/vscode)** - Location to find and install the new Copilot Studio extension for VS Code mentioned in the session. Enables professional development workflows with local agent editing capabilities.

- **[Azure AI Foundry](https://azure.microsoft.com/services/ai/)** - Microsoft's comprehensive AI platform providing access to 1,900+ models mentioned in the session. Critical for understanding model selection and custom AI service integration options.

### Industry Analysis and Research

- **[IDC AI and Automation Research](https://www.idc.com/research/artificial-intelligence)** - Source for the billion-agent projection cited in the session. Provides market context and validates the scale of transformation predicted for business process automation.

- **[Nintex Process Automation Platform](https://www.nintex.com/microsoft/)** - Partner platform demonstrated for employee onboarding automation. Shows real-world enterprise implementation of agent-driven process automation and integration patterns.

### Technical Standards and Protocols

- **[Model Context Protocol (MCP) Specification](https://spec.modelcontextprotocol.io/)** - Emerging standard for agent-to-system communication mentioned in the session. Important for understanding how agents integrate with external systems and services.

- **[OpenAPI Specification](https://swagger.io/specification/)** - Standard referenced for API integration and the TypeSpec alternative mentioned for simplifying agent tool development. Essential for understanding service integration patterns.

### Related Microsoft Technologies

- **[Microsoft Semantic Kernel](https://github.com/microsoft/semantic-kernel)** - AI orchestration framework mentioned as part of the SDK integration capabilities. Provides advanced AI reasoning and integration patterns for professional development.

- **[Power Platform](https://powerplatform.microsoft.com/)** - Low-code platform ecosystem that Copilot Studio extends. Important for understanding the broader Microsoft development platform strategy and integration opportunities.

---

## Appendix

### Demonstration Details and Technical Specifications

**Build 2025 Concierge Agent Configuration:**

```yaml
Agent: Build 2025 Concierge
Knowledge Sources:
  - Book of News (Microsoft Build 2025)
  - build.microsoft.com website content
Features:
  - Code interpreter capability
  - Conversation starters
  - Website grounding
  - File embedding
Development Time: "Just a couple of minutes"
```

**Contoso Employee Resources Agent Architecture:**

```yaml
Agent: Contoso Employee Resources
Model: GPT-4o with custom RAG
Knowledge: SharePoint site integration
Connected Agents:
  - Contoso Tax Advisor
  - Contoso Vacation Advisor
Analytics:
  - Session tracking
  - Knowledge source utilization
  - Tool usage metrics
  - Business outcome measurement
```

**Weather Agent SDK Template Configuration:**

```yaml
Template: Weather Agent
Language: C# (with Python/JavaScript options)
Service: Azure OpenAI
Components:
  - Agent instructions
  - Model connection configuration  
  - Emulator for testing
  - Adaptive card response formatting
Development Time: Minutes from template to working agent
```

### Partnership Implementation Details

**Nintex-Safalo Finance Integration:**

```yaml
Business Process: Employee Onboarding
Original Duration: 30 minutes manual process
Automated Duration: 2 minutes
Reduction: 93% time savings

Technology Stack:
  - Nintex Workflow (document generation)
  - Nintex K2 (on-premise system integration)
  - OneDrive (file management)
  - E-signature workflow
  - Email coordination
  - Teams interface
```

**LexisNexis Legal Professional Integration:**

```yaml
Features:
  - Clause rewriting with legal language optimization
  - Shepardize® citation validation
  - Case law verification
  - Document enhancement with visual indicators
  
Technical Implementation:
  - Word document context transfer
  - In-place text editing
  - Legal domain-specific language models
  - Professional workflow integration
```

### Session Logistics and Context

**Event Details:**

- **Conference:** Microsoft Build 2025
- **Date:** May 19-22, 2025 (Session on May 19)
- **Time:** 6:00 PM (Day 1)
- **Location:** Third floor, secondary building
- **Format:** 1-hour session with live demonstrations
- **Audience:** Mixed technical background, from end users to professional developers

**Session Flow:**

- **Introduction:** 1.5 minutes
- **Fundamental concepts:** 15 minutes
- **Agent Builder demo:** 12 minutes
- **Copilot Studio deep dive:** 20 minutes
- **Partnership demonstrations:** 5 minutes
- **Professional tools:** 15 minutes
- **Wrap-up and resources:** 2 minutes

This appendix provides detailed technical specifications and context that supplements the main concepts discussed in the session while maintaining focus on the primary learning objectives and business value propositions presented by the speakers.
