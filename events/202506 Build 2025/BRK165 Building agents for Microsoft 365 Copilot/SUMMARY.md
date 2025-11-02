# Building Agents for Microsoft 365 Copilot: From No-Code to Pro-Code

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK165  
**Speakers:** Aaron Bjork (Product Management Director, Microsoft), Abram Jackson (PM for M365 Copilot Extensibility, Microsoft)  
**Link:** [Microsoft Build 2025 Session BRK165]

![Building M365 Copilot Agents](images/m365-copilot-agents-development.png)

---

## Executive Summary

This comprehensive session demonstrates Microsoft's unified vision for agent development across the Microsoft 365 ecosystem, showcasing tools from no-code Agent Builder to professional SDK development. Aaron Bjork and Abram Jackson reveal how developers at every skill level can create powerful agents that integrate seamlessly with Microsoft 365 Copilot, featuring live demonstrations of multi-agent orchestration, enterprise integration, and innovative capabilities like Computer Use Agents and Office Add-in integration.

---

## Key Topics Covered

### ?? **1. The Agent-Centric World: A Paradigm Shift**

#### Defining Copilot and Agents
**Abram's Foundational Definition:**
> "Copilot is your personal assistant... It isn't 'the pilot,' it isn't running off without you, it is your copilot and it is assisting you."

**Agent Specialization:**

- **Business process specialists** - Understanding specific domains and workflows
- **Knowledge and API integrators** - Processing grounded information and real-time data
- **System bridges** - Connecting Copilot to enterprise systems of record
- **Workflow implementers** - Executing complex business processes autonomously

#### The Orchestra vs. Jazz Quartet Analogy
**Aaron's Architectural Vision:**

**App-Centric World (Orchestra):**

- **Structured coordination** - Each musician (application) plays from sheet music
- **Specialized roles** - Individual instruments with specific purposes
- **Central conductor** - Orchestrated control and coordination
- **Beautiful but rigid** - Precise execution within defined parameters

**Agent-Centric World (Jazz Quartet):**

- **Improvised collaboration** - Musicians playing off each other dynamically
- **Adaptive interaction** - Listening and responding to other participants
- **No sheet music** - Flexible, context-driven performance
- **Creative emergence** - New possibilities through spontaneous collaboration

#### The Billion Agent Future
**IDC Projection:**

- **1 billion new business process agents** over next four years
- **One agent per 7.5 people** worldwide (including children)
- **Every function and process** in organizations will be transformed
- **Universal adoption** across all business domains and verticals

---

### ??? **2. Agent Architecture: The Essential Components**

#### The Five Core Ingredients
**Aaron's Technical Framework:**
```
Agent Architecture
??? Orchestrator: Control layer managing component interactions
??? Model: The "brain" providing reasoning and decision-making
??? Knowledge: Grounding in verifiable, contextual information
??? Tools: Action-taking capabilities for real-world interactions
??? Triggers: Autonomous invocation and workflow initiation
```

#### Orchestrator and Model Relationship
**The Executive Function Metaphor:**

- **Model as brain** - Core reasoning and intelligence capabilities
- **Orchestrator as executive function** - Decision-making about when and how to act
- **Hand-in-hand operation** - Coordinated interaction for optimal performance
- **Strategic control** - Determining when to invoke models, APIs, or external systems

#### Knowledge and Grounding
**The Foundation of Reliability:**

- **Real, verifiable information** - Preventing hallucination and ensuring accuracy
- **Contextually relevant data** - Information specific to business domain and use case
- **Dynamic knowledge sources** - Connection to live systems and updated information
- **Multi-source integration** - SharePoint, OneDrive, email, Teams, external databases

#### Tools and Actions
**The Power of Agency:**

- **Real-time data access** - Live information retrieval and processing
- **First and third-party systems** - Comprehensive integration capabilities
- **Autonomous action execution** - Tasks performed on behalf of users
- **API orchestration** - Complex workflows across multiple systems

---

### ?? **3. No-Code Agent Builder: Democratizing AI Development**

#### Agent Builder Philosophy
**Abram's Accessibility Vision:**
> "Anyone can create an agent with these ingredients. It doesn't matter who you are and your persona and the way that you operate."

**Target Scenarios:**

- **Team processes** - Small groups (3-6 people) with specialized workflows
- **Individual automation** - Personal productivity and task management
- **Enterprise customization** - Department-specific adaptations of standard systems
- **No IT dependency** - End-user driven automation without formal IT projects

#### New Features and Capabilities
**Brand-New Agent Store Experience:**

- **Ground-up redesign** - Built specifically for agent discovery and management
- **Unified navigation** - Agents, conversations, pages in integrated interface
- **Search and filter** - Easy discovery of relevant agents for specific processes
- **One-click sharing** - Instant distribution to teams and organizations

**Enhanced Knowledge Integration:**

- **Team chat history** - Grounding in organizational conversation context
- **Email integration** - Access to communication patterns and content
- **Office entities** - SharePoint, OneDrive, Office 365 content
- **Specific websites** - Domain-restricted web grounding for controlled information
- **Embedded files** - Direct file sharing with agent distribution

#### Live Demo: Build 2025 Concierge Agent
**Real-World Implementation:**

- **Book of News grounding** - All Build announcements and updates
- **Website integration** - build.microsoft.com session and information data
- **Code interpreter capability** - Pre-built computational and analytical tools
- **Conversation starters** - Guided interaction patterns for optimal usage

**Query Example:**
```
User: "Tell me about the new features of Copilot Studio?"
Agent Response: Multi-agent orchestration, model fine-tuning, enterprise integration
Source: Grounded in website data and official documentation
```

#### Researcher Agent Integration Preview
**Multi-Agent Orchestration Demonstration:**

- **Lumen Quarterly Report Agent** - Custom formatting and presentation logic
- **Researcher coordination** - "How do you want to structure this report?"
- **Enterprise customization** - Organization-specific reporting standards
- **Seamless integration** - Works on first try across different agent types

---

### ?? **4. Copilot Studio: Professional Agent Development Platform**

#### Platform Capabilities and Positioning
**Aaron's Definition:**
> "Copilot Studio is a SaaS agent platform designed to help you really quickly and efficiently build agents that are ready to deploy in your organization... from starting point to deployed with metrics, analytics, safety rails, responsible AI literally in hours."

**Comprehensive Development Stack:**

- **Publishing channels** - M365 Copilot, websites, custom applications
- **Foundation model choice** - Managed models plus Azure AI Foundry integration
- **Knowledge customization** - Multiple source integration and RAG configuration
- **Tool integration** - First and third-party system connections
- **Autonomous workflows** - Self-directed task execution and process management

#### Advanced Model Integration
**Azure AI Foundry Connection:**

- **1,900+ available models** - Comprehensive model catalog access
- **Managed model defaults** - Pre-configured, optimized options
- **Custom deployment support** - API key and connection string configuration
- **Model specialization** - Different models for different agent components

#### Live Demo: Contoso Employee Resources Agent
**Enterprise Onboarding Automation:**

**Architecture Overview:**
```
Contoso Employee Resources
??? Knowledge: SharePoint site integration
??? Model: GPT-4o with custom RAG configuration  
??? Tools: Prompts, MCP servers, agent-to-agent connections
??? Analytics: Complete usage tracking and business outcome measurement
??? Publishing: M365 Copilot deployment with organizational sharing
```

**Business Intelligence Dashboard:**

- **Session analytics** - User interaction patterns and usage metrics
- **Knowledge source tracking** - Most accessed information and documents
- **Tool utilization** - Feature usage and workflow optimization data
- **Test framework** - Automated evaluation and outcome verification

#### Agent-to-Agent Communication
**Multi-Agent Orchestration:**

**Connected Agents:**

- **Contoso Tax Advisor** - Specialized tax and financial guidance
- **Contoso Vacation Advisor** - HR policy and time-off management
- **Dynamic selection** - Host agent chooses appropriate specialist

**Live Interaction Example:**
```
User Query: "How much vacation do I get as a new employee and how do I accrue more?"
Process:
??? Employee Resources Agent receives query
??? Identifies vacation-related intent
??? Invokes Contoso Vacation Advisor
??? Receives structured response with documentation
??? Presents integrated answer with source verification

Result: "New employees receive 2.5 weeks vacation upon hire. 
After one year of service, vacation increases to 3.5 weeks."
```

**Activity Map Visualization:**

- **Chain of thought tracking** - Complete reasoning process display
- **Agent invocation visualization** - Multi-agent workflow mapping
- **Source document linking** - Direct validation and drill-through capability
- **Debugging tools** - Developer visibility into agent decision-making

#### Advanced Tool Integration
**Prompt Builder Innovation:**

- **Fine-tuned responses** - Specialized handling for specific question types
- **Prompt library** - Hundreds of pre-built, tested prompt templates
- **Model specialization** - Different models for different prompt categories
- **Testing framework** - Built-in evaluation and optimization tools

**Model Context Protocol (MCP) Support:**

- **Emerging standard** - Industry-standard agent-to-system communication
- **Client-server architecture** - Agent as MCP client, systems as MCP servers
- **Pre-configured servers** - Ready-to-use integrations with common systems
- **Custom server support** - Flexible integration with proprietary systems

#### Visual Studio Code Integration
**Revolutionary Development Experience:**
**Major Announcement:** New VS Code extension for direct Copilot Studio editing

**Capabilities:**
```
VS Code Copilot Studio Extension
??? Clone Agent: Download agent definitions to local development
??? YAML editing: Direct manipulation of agent configuration
??? Language server: IntelliSense and syntax support for agent definitions
??? GitHub Copilot integration: AI-assisted agent development
??? Push to server: Seamless deployment back to Copilot Studio
```

**Developer Productivity:**

- **Local development** - Full editing capabilities offline
- **Version control** - Git integration for agent configuration management
- **IntelliSense support** - Type-ahead and error detection
- **AI-assisted coding** - GitHub Copilot suggestions for agent configuration

---

### ?? **5. Industry Implementation: Nintex Partnership Demo**

#### Employee Onboarding Automation Case Study
**Safalo Finance Transformation:**

**Traditional Process Problems:**

- **30-minute manual workflow** - Document download, update, signature coordination
- **Legacy system integration** - On-premise financial system certification requirements
- **Multi-step coordination** - HR team managing complex approval workflows
- **Error-prone manual processes** - Inconsistent document handling and delays

#### Automated Solution Architecture
**Nintex Integration Components:**
```
Employee Onboarding Agent
??? Nintex Workflow: Document generation and template population
??? Nintex K2: On-premise system provisioning and certification
??? OneDrive integration: File storage and organization
??? E-signature workflow: Automated document signing process
??? Email coordination: Notification and process management
```

**Workflow Orchestration:**
1. **Information collection** - Agent gathers new employee details
2. **Document generation** - Nintex Workflow populates templates with employee data
3. **File organization** - Automated folder creation and document storage in OneDrive
4. **On-premise provisioning** - Legacy system access and certification setup
5. **E-signature initiation** - Automated delivery of documents for signature

**Performance Transformation:**

- **30 minutes ? 2 minutes** - 93% reduction in processing time
- **Zero manual errors** - Automated accuracy and consistency
- **Integrated experience** - Single Teams interface for complete workflow
- **Scalable process** - Consistent experience across all new hires

---

### ?? **6. Professional Development: M365 Agents Toolkit and SDK**

#### Microsoft 365 Agents Toolkit
**Professional Developer Platform:**
> "The Microsoft 365 Agents Toolkit... gives you full control, full power over these agent ingredients... you can change out any part of this architecture."

**Complete Control Architecture:**
```
Professional Developer Control
??? Orchestrator: Custom logic and decision-making frameworks
??? Models: Any model from any provider, hosted anywhere
??? Knowledge: Custom knowledge sources and processing
??? Tools: Unlimited integration possibilities
??? Deployment: Full control over hosting and distribution
```

**Advanced Integration Capabilities:**

- **Teams Meetings** - Agents running directly in meeting contexts
- **Licensed and unlicensed M365** - Universal compatibility across user types
- **Visual Studio Code integration** - Professional development environment
- **TypeSpec support** - Simplified API specification management
- **Office Add-in integration** - Direct manipulation of Word, Excel, PowerPoint

#### Office Add-in Integration Breakthrough
**LexisNexis Legal Professional Demo:**

**Clause Rewriting Capability:**

- **Context awareness** - Agent understands selected text in Word document
- **Domain expertise** - Legal language and formatting optimization
- **In-place editing** - Direct document modification with user confirmation
- **Professional accuracy** - Legal-grade precision and compliance

**Shepardize™ Feature:**

- **Citation validation** - Automated legal citation checking and verification
- **Case law analysis** - Determining if precedents are still valid or overturned
- **Document enhancement** - Adding visual indicators for citation status
- **Professional workflow** - Integration with existing legal research processes

#### Microsoft 365 Agents SDK
**Full-Stack Enterprise Development:**
**Aaron's Technical Overview:**
> "A full developer framework designed to simplify the creation of full stack, multi-channel, enterprise-grade AI agents that can operate across M365, Teams, Copilot Studio and external platforms."

**Multi-Language Support:**

- **C# development** - Full .NET ecosystem integration
- **Python support** - AI and machine learning library compatibility  
- **JavaScript framework** - Web and Node.js development patterns

**Enterprise Integration:**

- **Azure AI services** - Complete Microsoft AI stack integration
- **Semantic Kernel** - Advanced AI orchestration framework
- **Third-party AI services** - Provider-agnostic model integration
- **External platforms** - Slack, Twilio, custom systems

#### Live Demo: Weather Agent Development
**Visual Studio Template System:**

**Project Creation Workflow:**
```
Visual Studio Agent Development
??? Template selection: Multiple agent patterns available
??? Service configuration: OpenAI/Azure OpenAI integration
??? Scaffolding generation: Complete project structure
??? Emulator testing: Built-in testing and debugging
??? Deployment options: Multiple distribution channels
```

**Development Experience:**

- **Instant scaffolding** - Complete agent project in minutes
- **Built-in emulator** - Local testing and debugging environment
- **Adaptive card responses** - Rich formatting and interactive elements
- **Full customization** - Complete control over agent behavior and integration

**Demo Results:**
```
User Query: "Compare the average rainfall of Seattle, Washington to Boston, Massachusetts"
Agent Response: Structured comparison with weather data, formatted as adaptive card
Development Time: Minutes from template to working agent
Integration: Direct Azure OpenAI model connection
```

---

## Technical Architecture Deep Dive

### Agent Communication Patterns
**Multi-Agent Orchestration:**

- **Agent-to-agent delegation** - Specialized agents handling domain-specific queries
- **Context preservation** - Information flow between agents with full context retention
- **Result aggregation** - Combining outputs from multiple specialized agents
- **Chain of thought tracking** - Complete visibility into multi-agent reasoning processes

### Knowledge Integration Strategies
**Grounding Sources and Methods:**

- **Microsoft 365 content** - SharePoint, OneDrive, Teams, email integration
- **External websites** - Domain-specific web content grounding
- **Embedded documents** - Direct file sharing with agent distribution
- **Real-time data** - Live system integration for current information

### Model Selection and Optimization
**Flexible Model Architecture:**

- **Component-specific models** - Different models for different agent functions
- **Cost optimization** - Right-sized models for specific tasks
- **Performance tuning** - Model selection based on response time and accuracy requirements
- **Provider agnostic** - Support for any model from any provider

---

## Live Demonstration Results

### Agent Builder Success Metrics
**Build 2025 Concierge Performance:**

- **Instant deployment** - Agent creation in minutes
- **Accurate responses** - Grounded in official Build documentation
- **User-friendly interface** - Intuitive interaction patterns
- **Seamless sharing** - One-click distribution across organization

### Copilot Studio Enterprise Integration
**Contoso Employee Resources Results:**

- **Multi-agent coordination** - Successful delegation between HR, tax, and vacation specialists
- **Source verification** - Direct links to authoritative documents
- **Analytics visibility** - Complete usage tracking and optimization data
- **Business outcome measurement** - Quantified productivity improvements

### Professional SDK Development
**Weather Agent Implementation:**

- **Rapid scaffolding** - Complete project structure in minutes
- **Azure integration** - Seamless OpenAI service connection
- **Rich responses** - Adaptive card formatting with structured data
- **Extensible foundation** - Ready for custom business logic and integration

---

## Session Highlights

> *"We're sort of moving out of what we would call the app-centric world and into an agent-centric world."* - Aaron Bjork

> *"Copilot is the UI for AI... Without agents, it's not connected to your work systems."* - Abram Jackson

> *"Anyone can create an agent with these ingredients. It doesn't matter who you are and your persona and the way that you operate."* - Abram Jackson

> *"You get full control, full power over these agent ingredients... you can change out any part of this architecture."* - Abram Jackson

> *"What used to be a 30-minute segment of the onboarding process has now been streamlined down into about a two-minute interaction."* - Nintex Demo

---

## Implementation Roadmap

### Getting Started by Skill Level

#### No-Code (Agent Builder)
```markdown
**Best For:** End users, team leads, departmental automation
**Timeline:** Minutes to hours
**Capabilities:** Knowledge grounding, simple workflows, team sharing
**Limitations:** Pre-built orchestration, managed models only

**Getting Started:**
1. Access Agent Builder in M365 Copilot
2. Define agent purpose and instructions
3. Add knowledge sources (files, websites, Office content)
4. Configure conversation starters and capabilities
5. Test and share with team or organization
```

#### Low-Code (Copilot Studio)
```markdown
**Best For:** Business analysts, citizen developers, IT professionals
**Timeline:** Hours to days
**Capabilities:** Custom models, advanced analytics, multi-channel publishing
**Features:** Visual workflow design, enterprise integration, compliance

**Getting Started:**
1. Access Copilot Studio platform
2. Create agent with visual designer
3. Configure knowledge sources and tools
4. Set up agent-to-agent communication
5. Deploy with analytics and governance
```

#### Pro-Code (M365 Agents SDK)
```markdown
**Best For:** Professional developers, enterprise architects
**Timeline:** Days to weeks for complex solutions
**Capabilities:** Full control, custom orchestration, any model/platform
**Languages:** C#, Python, JavaScript

**Getting Started:**
1. Install M365 Agents Toolkit in VS Code
2. Use Visual Studio agent templates
3. Configure custom models and services
4. Implement business logic and integrations
5. Deploy across multiple channels and platforms
```

### Enterprise Deployment Strategy

#### Phase 1: Experimentation (Weeks 1-2)
- **Agent Builder pilots** - Departmental team automation
- **Use case identification** - High-impact, low-risk scenarios
- **Success metrics** - Time savings, user adoption, process improvement
- **Governance framework** - Security, compliance, data handling policies

#### Phase 2: Expansion (Months 1-3)
- **Copilot Studio deployment** - Enterprise-wide agent development
- **Multi-agent orchestration** - Complex workflow automation
- **Analytics implementation** - Usage tracking and ROI measurement
- **Training programs** - User enablement and best practices

#### Phase 3: Transformation (Months 3-12)
- **Professional SDK adoption** - Custom enterprise solutions
- **Legacy system integration** - Complete workflow digitization
- **Cross-platform deployment** - Multi-channel agent distribution
- **Innovation acceleration** - Advanced AI capabilities and new use cases

---

## Advanced Applications and Use Cases

### Knowledge Work Transformation
**Document-Centric Processes:**

- **Legal document review** - Citation validation and clause optimization
- **Financial analysis** - Automated report generation and compliance checking
- **Healthcare documentation** - Patient record summarization and clinical decision support
- **Technical writing** - Documentation generation and accuracy verification

### Customer Service Automation
**Support Process Enhancement:**

- **Tier 1 support automation** - Common issue resolution without human intervention
- **Escalation intelligence** - Smart routing to appropriate specialists
- **Knowledge base integration** - Real-time access to support documentation
- **Multi-channel consistency** - Unified experience across all customer touchpoints

### Business Process Optimization
**Workflow Digitization:**

- **Employee onboarding** - Complete automation from hire to productivity
- **Procurement processes** - Vendor management and approval workflows
- **Compliance monitoring** - Automated policy enforcement and reporting
- **Project management** - Task coordination and status tracking

---

## Resources and Further Learning

### Official Documentation and Tools
- **[Microsoft 365 Copilot](https://copilot.microsoft.com/)** - Primary platform for agent deployment and usage
- **[Copilot Studio](https://copilotstudio.microsoft.com/)** - Low-code agent development platform
- **[M365 Agents Toolkit](https://marketplace.visualstudio.com/m365-agents-toolkit)** - Professional development tools for Visual Studio Code
- **[Microsoft 365 Agents SDK](https://docs.microsoft.com/m365-agents-sdk/)** - Full-stack development framework and documentation

### Development Resources
- **[Agent Templates](https://github.com/microsoft/m365-agents-templates)** - Pre-built project scaffolding for common scenarios
- **[MCP Integration Guide](https://docs.microsoft.com/copilot-studio/mcp)** - Model Context Protocol implementation patterns
- **[Office Add-in SDK](https://docs.microsoft.com/office/dev/add-ins/)** - Integration with Word, Excel, PowerPoint functionality

### Related Build 2025 Sessions
- **Multi-Agent Orchestration** - Advanced patterns for agent coordination
- **Computer Use Agents** - Direct computer interaction capabilities
- **MCP in Copilot Studio** - Model Context Protocol implementation
- **Agent Instructions Contest** - Community competition and best practices
- **OpenHack Sessions** - Hands-on development workshops

### Community Engagement
- **Agent Instructions Contest** - Community competition for innovative agent designs
- **OpenHack Events** - Hands-on development and learning experiences
- **Documentation and Examples** - Comprehensive guides and sample implementations
- **Build Week Support** - Direct access to product team for questions and guidance

---

## About the Speakers

**Aaron Bjork**  
Product Management Director  
Microsoft  
*22-year Microsoft veteran leading Copilot Studio development. Previous leadership roles in Copilot Apps, Azure IoT, Azure DevOps, and Visual Studio. Focused on building tools that promote team productivity and collaboration.*

**Abram Jackson**  
PM for M365 Copilot Extensibility  
Microsoft  
*Product manager specializing in AI products and platform development. Expert in scaling products from concept to millions of users. Currently focused on forward-looking features and experiences for agents in Microsoft 365 Copilot.*

---

*This comprehensive session demonstrates Microsoft's commitment to democratizing agent development across all skill levels, providing a complete toolkit from no-code Agent Builder through professional SDK development. The unified vision enables every organization to participate in the agent-centric transformation while maintaining enterprise security, governance, and integration capabilities.*

