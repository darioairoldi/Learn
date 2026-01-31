# Create Agents for Microsoft 365 Copilot with Microsoft 365 Agents SDK

**Session Date:** May 21, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK163  
**Speakers:** Sarah Critchley (Principal Product Manager, Microsoft), Matthew Barbour (Principal Architect/Development Manager, Microsoft)  
**Customer Speakers:** Renil Abdulkader (Engineering Director, KPMG LLP), Gaurave Sehgal (Senior Director, KPMG LLP)  
**Link:** [Microsoft Build 2025 Session BRK163]

![M365 Agents SDK Development](images/m365-agents-sdk-custom-engine.png)

---

## Executive Summary

This hands-on technical session demonstrates the power and flexibility of the Microsoft 365 Agents SDK for building custom-engine agents with complete developer control. Sarah Critchley and Matthew Barbour showcase live coding demonstrations spanning from Semantic Kernel integration through multi-agent orchestration, authentication management, and Microsoft 365 Copilot API integration, while KPMG presents their real-world implementation of tax intelligence agents serving global enterprise clients across multiple channels.

---

## Key Topics Covered

### ?? **1. The Conversational Technology Revolution**

#### The Fundamental Shift
**Sarah's Opening Vision:**
> "We have had a fundamental shift in technology. And that shift is the fact that it's normal now to use conversation and questions and natural language to interact with technology."

**Real-World Impact Examples:**

- **Banking apps** - Agents grounded in personal data providing specific responses
- **Enterprise tools** - AskHR agents answering travel questions based on individual context
- **Package tracking** - Moving from information delivery to action-oriented assistance
- **Personalized experiences** - Same questions yielding different answers based on user data

#### Why Agents Transform User Experience
**Beyond Information Retrieval:**

- **Focus delivery** - Agents provide targeted, relevant information rather than generic responses
- **Security-conscious access** - Information accessed with user-chosen permissions and security levels
- **Resolution-driven** - Agents drive toward outcomes, not just task completion
- **Contextual availability** - Right at your fingertips, whenever you need them

---

### ??? **2. Microsoft 365 Agents SDK: Complete Developer Control**

#### Core Philosophy and Capabilities
**Sarah's Developer-Centric Promise:**
> "You want value, choice, and flexibility... You want to be able to use the AI that's already been approved by your company's leadership. You want to be able to use your orchestrator that you're already familiar with."

**SDK Architecture and Flexibility:**
```
M365 Agents SDK Components:
??? AI Models: Any model or AI services (OpenAI, Azure AI, custom)
??? Orchestrator: Your choice (Semantic Kernel, LangChain, custom)
??? Knowledge: Enterprise data integration and grounding
??? Conversation Management: State, storage, authentication
??? Multi-Channel Deployment: Teams, M365 Copilot, Web, Slack, 15+ channels
```

#### Language and Framework Support
**Multi-Language Development:**

- **C# integration** - Full .NET ecosystem support with Semantic Kernel
- **JavaScript support** - LangChain and custom orchestrator integration
- **Python capabilities** - Open-source flexibility with enterprise management
- **Open-source foundation** - Transparent, extensible, community-driven development

---

### ?? **3. Microsoft 365 Agents Toolkit: End-to-End Development Experience**

#### From File New to Deployment
**Comprehensive Development Support:**
```
Toolkit Features:
??? Built-in Templates: Empty Agent, Weather Agent with pre-configured options
??? Agent Playground: Local testing with embedded debugging capabilities
??? Multi-Channel Publishing: Teams, M365 Copilot deployment automation
??? Debug Integration: Set debug target and test locally before deployment
??? Deployment Process: End-to-end automation for production readiness
```

#### Development Workflow Integration
**Sarah's Efficiency Promise:**
> "We're really trying to not just help get you started with the SDK but actually cover that end-to-end deployment and process so you can actually bring all of your components that you want to use together."

**Templates and Scaffolding:**

- **Empty Agent** - Basic scaffolding for complete customization
- **Weather Agent** - Pre-configured Semantic Kernel or LangChain integration
- **Azure AI Foundry integration** - Ready-to-use cloud AI service connections
- **OpenAI agent support** - Direct integration with OpenAI services

---

### ?? **4. Live Coding Demonstrations: Real-World Implementation**

#### Semantic Kernel to Multi-Channel Agent
**Matt's 15-Minute Development Challenge:**
> "That particular demo took me about 15 minutes to create... Starting with the Semantic Kernel and bringing some things over."

**Step-by-Step Transformation:**
1. **Base Semantic Kernel app** - Console application with OpenWeather API integration
2. **Agent SDK integration** - Add cloud adapter, memory storage, agent applications
3. **Multi-channel deployment** - Same agent running in Playground, Teams, M365 Copilot, Web Chat
4. **Adaptive card generation** - AI-generated rich responses across all channels

#### Technical Implementation Deep Dive
**Agent SDK Architecture Patterns:**
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
    var response = await weatherKernel.InvokeAsync(turnContext.Activity.Text);
    await turnContext.SendActivityAsync(response);
}
```

#### Multi-Channel Consistency
**Unified Agent Experience:**

- **Agent Playground** - Local development and testing environment
- **Microsoft Teams** - Enterprise collaboration platform integration
- **M365 Copilot** - Native AI assistant interface
- **Web Chat** - Custom website and application embedding
- **Same codebase** - No channel-specific modifications required

---

### ?? **5. Streaming Responses and User Experience Enhancement**

#### Interactive Status Communication
**Matt's UX Innovation:**
> "Use streaming is a capability that was added to the Microsoft ecosystem... streaming response allows us to be a little bit more interactive with our tech."

**Channel-Adaptive Streaming:**

- **Low-resolution channels** - Basic typing indicators with final response
- **High-resolution channels** - Real-time status updates throughout processing
- **Automatic adaptation** - SDK handles upscale/downscale based on channel capabilities
- **Timeout management** - Critical for M365 Copilot's aggressive 15-second timeout requirements

#### Implementation Strategy
**Channel-Specific Requirements:**
> "Those of you that want to target this chat, specifically on the M365 cloud, I cannot stress strongly enough, use streaming responses. They are very, very brutal on timeout."

**Best Practices:**

- **Immediate acknowledgment** - Send status as soon as request received
- **Regular updates** - Continuous communication during processing
- **Channel optimization** - Adapt streaming behavior to channel capabilities
- **Error prevention** - Avoid timeout errors through proactive status communication

---

### ?? **6. Multi-Agent Orchestration and Integration**

#### Dispatcher Pattern Implementation
**Semantic Kernel + Copilot Studio Integration:**
```
Multi-Agent Architecture:
??? Agent SDK Host: Central orchestration and channel management
??? Semantic Kernel: AI reasoning and tool selection
??? OpenAI Integration: Foundation model for decision-making
??? Copilot Studio Agent: Specialized weather service
??? Authentication Layer: Seamless user token management
```

#### Advanced Authentication Management
**Matt's Authentication Breakthrough:**
> "I cannot tell you how much we've invested in making that work... We don't want you to have to deal with this crap anymore."

**Token Management Innovation:**

- **User authorization exchange** - Automatic token acquisition for external services
- **Scoped permissions** - Granular access control based on service requirements
- **SSO integration** - Seamless single sign-on across Microsoft ecosystem
- **Identity passthrough** - Agent runs as system but communicates as authenticated user

#### Live Authentication Demo
**Visual Studio Debugging Revelation:**
```json
// Decoded JWT Token in Visual Studio
{
  "audience": "https://api.powerplatform.com/",
  "scope": "https://api.powerplatform.com/Copilot.Studio.Invoke",
  "upn": "user@microsoft.com"
}
```

**Technical Achievement:**

- **Automatic token exchange** - No manual authentication handling required
- **Multi-environment support** - Switch between different Copilot Studio environments
- **Scoped access** - User permissions determine available agents and data
- **Debugging transparency** - Visual Studio token decoding for development insight

---

### ?? **7. Microsoft 365 Copilot APIs Integration**

#### Four Core APIs for Enterprise Integration
**Sarah's API Portfolio:**
```
M365 Copilot APIs:
??? Retrieval API: Grounded data from M365 without data extraction
??? Chat API: Completion API for headless M365 Copilot usage
??? Meeting Insights API: Teams meeting analysis and insights
??? Interactions Export API: User prompts and usage analytics
```

#### Retrieval API Deep Dive
**Enterprise Data Grounding:**
> "This allows you to ground on your M365 data without taking your data out of M365."

**Technical Implementation:**

- **SharePoint integration** - Target specific sites and document folders
- **Permission inheritance** - User access controls automatically applied
- **Semantic indexing** - Leverage M365's built-in content understanding
- **Private preview status** - Actively developing with enterprise customers

#### Live API Demonstration Challenges
**Matt's Real-World Testing:**
> "This demo you're going to see, specifically these API calls, are in private preview... Cross your fingers. We'll get all the way through it, and it'll work properly."

**Development Reality:**

- **API instability** - Daily changes during private preview development
- **Integration challenges** - Coordinating multiple preview services
- **Debugging transparency** - Live problem-solving during demonstration
- **Future stability** - "Give us another week, another week and a half"

---

### ?? **8. KPMG Enterprise Implementation Case Study**

#### Global Tax Intelligence Platform
**Gaurave's Business Context:**
> "We help our clients, the biggest clients on the planet, help plan, prepare, and comply with tax laws and regulations... We are 250 plus K employees working for us."

**Digital Gateway Platform:**
```
KPMG Digital Gateway:
??? Workflows: Tax process automation and management
??? Document Management: Regulatory document handling
??? GenAI Capabilities: Intelligent personas and assistants
??? Multi-Channel Access: Web platform + Teams + M365 integration
??? Global Scale: Serving Fortune 500 clients worldwide
```

#### Tax Intelligence Personas
**Domain Expertise Integration:**

- **Global Tax Incentive Researcher** - Specialized knowledge for international tax scenarios
- **Regulatory Compliance** - Up-to-date tax law and regulation interpretation
- **Document Attachment** - Direct integration with tax professionals' knowledge
- **Thought Leadership** - KPMG's intellectual property embedded in AI responses

#### Cross-Tenant Authentication Excellence
**Renil's Technical Achievement:**
> "Authenticating the users across hundreds, sometimes thousands of Entra ID tenants and bringing all this tax intelligence into their hands, providing secure access, continued governance, and seamless experience."

**Enterprise Security Implementation:**

- **Multi-tenant architecture** - Client tenants accessing KPMG services
- **Single sign-on** - Transparent authentication across organizational boundaries
- **On-behalf-of tokens** - Secure service-to-service communication
- **Governance compliance** - Regulatory requirements and audit trails

#### Real-World Use Cases
**Live Demonstration Scenarios:**
```
Tax Intelligence Queries:
??? "Manufacturing in China, R&D in US - what tax incentives available?"
??? "Tax funds available in Mexico for automobile manufacturing?"
??? Cross-border scenarios with changing regulations
??? Real-time tax law updates and implications
```

---

## Session Highlights

> *"We have had a fundamental shift in technology. And that shift is the fact that it's normal now to use conversation and questions and natural language to interact with technology."* - Sarah Critchley

> *"That particular demo took me about 15 minutes to create... Starting with the Semantic Kernel and bringing some things over."* - Matthew Barbour

> *"I cannot tell you how much we've invested in making that work... We don't want you to have to deal with this crap anymore."* - Matthew Barbour on authentication

> *"Cross your fingers. We'll get all the way through it, and it'll work properly. If not, we'll get an exercise in debugging."* - Matthew Barbour on live API demos

> *"We are not just keeping up. We are setting the pace, but the leadership only matters if we can continue to innovate."* - Renil Abdulkader, KPMG

---

## Technical Architecture Deep Dive

### Agent SDK Core Components
```
Microsoft 365 Agents SDK Architecture:
??? Cloud Adapter: Multi-channel communication management
??? Memory Storage: Conversation state and context preservation
??? Agent Applications: Core agent logic and orchestration
??? Authentication Layer: Token management and user identity
??? Activity Protocol: Microsoft's A2A communication standard
??? Extension System: Channel-specific capabilities (Teams, etc.)
```

### Multi-Channel Deployment Pattern
```
Single Agent ? Multiple Channels:
??? Development: Agent Playground (local testing)
??? Collaboration: Microsoft Teams (enterprise communication)
??? AI Interface: M365 Copilot (native AI assistant)
??? Web Integration: Web Chat (custom applications)
??? External Platforms: Slack, custom channels (15+ supported)
```

### Authentication and Authorization Flow
```
Token Management Workflow:
??? User Authentication: Initial login to client channel
??? Service Registration: Azure Bot Service with OAuth handlers
??? Token Exchange: User tokens ? Service-specific tokens
??? Permission Validation: Scoped access control
??? Identity Passthrough: System agent communicating as user
```

---

## Implementation Guidelines

### Getting Started with M365 Agents SDK
```markdown
**Prerequisites:**

- Visual Studio or VS Code with M365 Agents Toolkit extension
- Azure subscription for Bot Service registration
- Microsoft 365 tenant for testing and deployment
- OpenAI or Azure OpenAI API access

**Quick Start Process:**
1. Install M365 Agents Toolkit extension
2. Create new project with Weather Agent template
3. Configure AI service credentials (OpenAI/Azure OpenAI)
4. Test locally with Agent Playground
5. Deploy to target channels (Teams, M365 Copilot)
```

### Development Best Practices
```markdown
**Channel Optimization:**

- Use streaming responses for M365 Copilot (aggressive 15-second timeout)
- Implement immediate status acknowledgment for all channels
- Test across multiple channels during development
- Leverage channel-adaptive UI (adaptive cards, rich responses)

**Authentication Strategy:**

- Use scoped tokens for user-friendly consent experiences
- Implement proper OAuth handlers for external service integration
- Leverage automatic token exchange for seamless user experience
- Plan for multi-tenant scenarios in enterprise environments
```

### Multi-Agent Architecture Patterns
```markdown
**Dispatcher/Broker Pattern:**

- Central Agent SDK agent as orchestration hub
- Multiple specialized agents for domain-specific tasks
- Semantic Kernel or custom orchestrator for decision-making
- Unified authentication and channel management

**Enterprise Integration:**

- Copilot Studio agents for low-code specialized functions
- Custom agents for complex business logic and external systems
- API integration for data retrieval and processing
- Cross-tenant authentication for B2B scenarios
```

---

## Advanced Applications and Use Cases

### Enterprise Knowledge Integration
**Tax Intelligence and Compliance:**

- **Regulatory expertise** - Domain-specific knowledge embedded in AI personas
- **Cross-border scenarios** - Complex international tax law interpretation
- **Real-time updates** - Dynamic regulatory change incorporation
- **Multi-tenant security** - Client data isolation with seamless user experience

### Development Productivity Enhancement
**Rapid Prototyping and Deployment:**

- **15-minute development cycles** - From Semantic Kernel to multi-channel agent
- **Local testing environment** - Agent Playground for immediate feedback
- **Live debugging** - Visual Studio integration with token inspection
- **Multi-channel validation** - Test across Teams, M365 Copilot, Web Chat simultaneously

### API Integration and Data Access
**Microsoft 365 Data Leverage:**

- **Retrieval API** - Access M365 content without data extraction
- **Meeting Insights API** - Teams meeting analysis and action item extraction
- **Chat API** - Headless M365 Copilot for custom application integration
- **Interactions Export API** - Usage analytics and optimization insights

---

## Resources and Further Learning

### Official Documentation and Tools
- **[M365 Agents SDK](https://aka.ms/agents)** - Primary SDK documentation and getting started guide
- **[Microsoft 365 Agents Toolkit](https://marketplace.visualstudio.com/m365-agents-toolkit)** - Visual Studio extension for agent development
- **[Agent Development Labs](https://aka.ms/build-labs)** - Hands-on learning opportunities starting 8:30 AM
- **[Build Agent Instructions Contest](https://aka.ms/build-agent-contest)** - Competition for best agent instruction design

### Community and Learning Opportunities
- **[Open Hack Event](https://aka.ms/build-openhack)** - Real-time feedback from Microsoft product team
- **Create a Custom Engine Agent Lab** - Step-by-step guided implementation
- **Agent Playground** - Local testing and debugging environment
- **Microsoft Partner Ecosystem** - Collaboration with Accenture AI Refinery and industry partners

### Technical Integration Resources
- **[Semantic Kernel Documentation](https://docs.microsoft.com/semantic-kernel/)** - Microsoft's orchestration framework
- **[Azure Bot Service](https://docs.microsoft.com/azure/bot-service/)** - Authentication and registration platform
- **[Microsoft Graph APIs](https://docs.microsoft.com/graph/)** - M365 data access and integration
- **[Azure AI Services](https://docs.microsoft.com/azure/ai-services/)** - Model hosting and AI service integration

---

## About the Speakers

**Sarah Critchley**  
Principal Product Manager  
Microsoft  
*Principal Product Manager for the Microsoft 365 Agents SDK, dedicated to providing companies with flexibility when building agents for meaningful business outcomes.*

**Matthew Barbour**  
Principal Architect / Development Manager  
Microsoft  
*Developer, Architect and Manager for Power Platform focusing on SDKs, APIs, Developer and Partner ecosystems. Development Manager for the Agents SDK.*

**Renil Abdulkader**  
Engineering Director  
KPMG LLP  
*Engineering Director leading Identity and Access practice for Global Tax & Legal. 20 years of Microsoft technology experience, incorporating emerging technologies including GenAI.*

**Gaurave Sehgal**  
Senior Director  
KPMG LLP  
*Senior Director responsible for driving Generative AI strategy and innovation across Global Tax and Legal function. Over a decade of AI-driven transformation leadership.*

---

*This comprehensive session demonstrates the power and flexibility of the Microsoft 365 Agents SDK for enterprise agent development, showcasing how organizations can build sophisticated, multi-channel agents with complete control over AI models, orchestration, and knowledge integration while leveraging Microsoft's enterprise-grade security and authentication infrastructure.*

