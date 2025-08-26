# Unlock Agentic Interactions for Your Apps Using MCP on Windows

**Session Date:** May 20, 2025  
**Duration:** 1 hour  
**Venue:** Build 2025 Conference - BRK229  
**Speakers:** Donald Thompson (Distinguished Engineer, Microsoft), Michael Von Hippel (Senior Product Manager, Microsoft)  
**Additional Speakers:** Alexander Sklar, Jesse Bishop, Kiran Kumar  
**Link:** [Microsoft Build 2025 Session BRK229]

![MCP on Windows Platform](images/mcp-windows-agentic-interactions.png)

---

## Executive Summary

This groundbreaking session introduces Microsoft's comprehensive MCP (Model Context Protocol) implementation for Windows, positioning the platform as the premier development environment for AI agents. Donald Thompson and Michael Von Hippel demonstrate how MCP on Windows solves critical challenges in agent extensibility, security, and discoverability through live demonstrations spanning from basic MCP server creation to enterprise-scale multi-agent workflows with built-in Windows capabilities.

---

## Key Topics Covered

### 🎯 **1. The Agentic Integration Challenge**

#### The Tool Problem for Agents
**Michael's Core Challenge:**
> "It's easy to make agents, but making them useful is a major challenge. If an agent doesn't have access to the right tools for accessing content, personalizing things, and acting on it, then all they can do is tell you what to do based on some limited information."

**Agent Utility Requirements:**
- **Context and memory** - Agents know what you want without long prompts
- **Action capabilities** - Tools let agents act on your behalf, completing tasks
- **Content access** - Real-time data retrieval and system integration
- **Personalization** - User-specific information and preferences

#### MCP as the Solution
**The Strategic Value:**
- **Investment magnification** - Same integration work scales across all MCP-capable agents
- **Unified integration** - Multiple services integrated simultaneously for broad tool sets
- **Industry adoption** - Microsoft and other major players investing in MCP standardization
- **Cross-platform compatibility** - Single standard replacing multiple bespoke plugin systems

### 🏗️ **2. MCP Fundamentals and Architecture**

#### MCP Vocabulary and Components
**Core Architectural Elements:**
```
MCP Architecture
├── Hosts: Agents wanting access to data and tools
├── Clients: Connection interfaces between hosts and servers
├── Servers: Lightweight programs exposing capabilities
├── Tools: Action-taking functions for real-world tasks
└── Resources: Atomic units of data access (files, databases, services)
```

#### Transport Mechanisms
**Protocol Communication Options:**
- **Standard IO** - Local server communication through process pipes
- **Server-Sent Events (SSE)** - Traditional HTTP bidirectional communication
- **HTTP Streamable** - Enhanced protocol with WebSocket support
- **Future expansions** - Additional transport methods in development

### 🛠️ **3. Live Development Demonstration: Contoso Agent**

#### The Business Scenario
**Sales Agent Use Case:**
> "A salesperson's out in the field, needs to look up products and inventory. They shouldn't have to mess with a traditional form and database application. They should just chat something into their agent, and let it figure out what the inventory is."

**Technical Requirements:**
- **FastAPI REST server** - Product and inventory management system
- **WSL integration** - Linux development environment on Windows
- **Agent tooling** - Natural language to system action translation
- **Multi-step workflows** - Complex query decomposition and execution

#### WSL Integration Through MCP
**Development Workflow Automation:**
```
Agent Commands → MCP Tools → WSL Actions
├── "What Linux distros are available?" → WSL list online distros
├── "Install Fedora Linux distro" → WSL install command execution
├── "Clone GitHub repo" → Git operations in Linux environment
├── "Create virtual environment" → UV Python environment setup
└── "Start the server" → FastAPI application launch
```

**Developer Experience Benefits:**
- **Natural language commands** - No need to remember specific syntax
- **Cross-platform orchestration** - Windows agent controlling Linux services
- **Approval workflows** - User consent for system-level operations
- **Complete automation** - End-to-end development environment setup

#### MCP Server Creation
**C# SDK Implementation:**
```csharp
// MCP Server Tools Definition
[MCPServerTool(description: "Search products by name or description")]
public string SearchProducts(string query)
{
    // Fuzzy matching product search
    return httpClient.GetAsync($"/search?q={query}").Result;
}

[MCPServerTool(description: "Get detailed product information by ID")]
public ProductInfo GetProduct(int productId) 
{
    // Product details and inventory lookup
    return httpClient.GetAsync($"/product/{productId}").Result;
}
```

**Implementation Simplicity:**
- **Standard console application** - No complex infrastructure required
- **HTTP client abstraction** - Any backend (GraphQL, SOAP, gRPC) supported
- **Metadata-driven** - LLM uses descriptions for tool selection
- **15 lines of code** - Minimal integration complexity for consuming applications

---

### 🔐 **4. MCP on Windows: Security and Registry System**

#### The Three Pillars Architecture
**Core Platform Components:**
```
MCP on Windows Platform
├── MCP Registry: Application identity and server discovery
├── MCP Servers for Windows: Activated through proxy with user control
└── Built-in MCP Servers: Out-of-the-box Windows capabilities
```

#### Security-First Design Philosophy
**Trust, Security, and Safety Framework:**

**Trust Implementation:**
- **Identity requirement** - All registered servers must have application identity
- **User control** - End user and enterprise settings control server availability
- **Transparency** - Clear explanation of tool usage before approval
- **Audit trails** - Complete logging of all MCP interactions

**Security Measures:**
- **Server isolation** - Proxy server with security and enterprise controls
- **Permission brokering** - Windows mediates all client-server interactions
- **Anti-malware integration** - Real-time abuse detection and correction
- **Enterprise IT policies** - MDM and admin control integration

**Safety Practices:**
- **Responsible AI integration** - Built-in safety guardrails
- **Privacy controls** - User data protection and handling policies
- **Real-time monitoring** - Continuous security and abuse detection
- **Granular permissions** - Tool-level access control capabilities

#### Application Identity and Manifest System
**Installation and Registration Process:**
```xml
<!-- Application Manifest -->
<Package>
    <Applications>
        <Application>
            <Extensions>
                <Extension Category="microsoft.ai.mcpserver">
                    <MCPServer>
                        <ServerConfig>
                            <Command>app.exe</Command>
                            <Arguments>--mcp-server</Arguments>
                        </ServerConfig>
                    </MCPServer>
                </Extension>
            </Extensions>
        </Application>
    </Applications>
</Package>
```

**Registry Management:**
- **Off by default** - No immediate privilege escalation
- **Manual activation** - User explicit consent required
- **Settings integration** - Windows Settings app control interface
- **Enterprise policies** - IT administrator control and governance

---

### 🎪 **5. Live Demonstrations: Real-World Agent Scenarios**

#### Contoso Inventory Management
**Complex Query Processing:**
```
User: "What is the total inventory of widgets?"

Agent Process:
├── Search Products: "widgets" → Returns Widget A and Widget B
├── Get Product: Widget A → Inventory: 45 units
├── Get Product: Widget B → Inventory: 30 units
└── Calculate Total: 45 + 30 = 75 total widgets
```

**Multi-Tool Coordination:**
- **Three approval dialogs** - User consent for each tool invocation
- **Intelligent decomposition** - Agent determines necessary tools automatically
- **Mathematical processing** - Calculation performed by agent logic
- **Real-time execution** - Complete workflow in single user request

#### Windows Integration: Snap Layouts Demo
**Built-in Windows Capabilities:**
```
User: "Snap Windows next to each other"
Agent → Snap Layouts MCP Server → Windows snapping functionality
Result: Automatic window arrangement using native Windows features
```

#### Perplexity Partnership Demo
**Multi-App Workflow Automation:**
```
Productivity Workflow:
├── File System Search: "Find MCP research documents"
├── Document Summarization: AI analysis of found documents
├── Email Creation: Spark Mail integration via App Actions
├── Background Removal: Paint.NET integration for image editing
└── Email Attachment: Complete workflow automation
```

**Cross-Application Benefits:**
- **Semantic file search** - AI-powered document discovery
- **App Actions integration** - Native application extensibility
- **Multi-tool coordination** - Complex workflows across multiple applications
- **User experience** - Single interface for multi-application tasks

#### Figma Integration: UI Generation
**Design-to-Code Workflow:**
```
Design Process:
├── Figma MCP Server: Access to currently selected design
├── UI Import: Automatic HTML/CSS generation from design
├── Code Integration: Seamless insertion into existing project
└── Live Preview: Immediate functional website update
```

---

### 🔧 **6. Built-in MCP Servers for Windows**

#### Comprehensive Windows Integration
**Available Built-in Servers:**
- **Windows Subsystem for Linux (WSL)** - Linux environment management
- **Snap Layouts** - Window management and arrangement
- **App Actions for Windows** - Inter-application communication and automation
- **Settings MCP** - Windows configuration and preference management
- **File System MCP** - File operations and semantic search capabilities

#### App Actions for Windows
**Enterprise Application Integration:**
- **Goodnotes integration** - Note-taking and document annotation
- **Todoist connectivity** - Task and project management
- **Spark Mail automation** - Email composition and management
- **Partner ecosystem** - Expanding application integration support

#### File System Capabilities
**Advanced File Operations:**
- **Directory search** - Traditional file system navigation
- **Semantic search** - AI-powered content discovery
- **Content analysis** - Document understanding and summarization
- **Cross-application file sharing** - Seamless integration workflows

---

### 💼 **7. Enterprise and Development Considerations**

#### Identity and Trust Model
**Application Requirements:**
- **Installed applications only** - No arbitrary script execution
- **Identity verification** - Cryptographic application signatures
- **Trust relationships** - Verified connections between clients and servers
- **Enterprise governance** - IT administrator control and oversight

#### Development Workflow Integration
**Visual Studio Code MCP Extension:**
```json
// VS Code MCP Configuration
{
  "mcpServers": {
    "contoso-server": {
      "command": "dotnet",
      "args": ["run", "--project", "path/to/server.csproj"],
      "transport": "stdio"
    }
  }
}
```

**Developer Benefits:**
- **Local testing** - Immediate MCP server validation
- **GitHub Copilot integration** - Agent-assisted development workflows
- **Hot reload** - Real-time server updates during development
- **Multi-environment support** - Local, remote, and hybrid configurations

#### Enterprise Management and Security
**IT Administrator Controls:**
- **MDM integration** - Mobile Device Management policy enforcement
- **Private repositories** - Enterprise-controlled MCP server catalogs
- **Audit logging** - Complete interaction tracking and monitoring
- **Granular permissions** - Tool and server-level access control

---

## Technical Architecture Deep Dive

### MCP Client Implementation
**Consumer Application Pattern:**
```csharp
// Agent MCP Integration
var catalog = MCPServerCatalog.GetInstance();
var clientContext = new MCPClientContext("MyAgentApp");

var servers = await catalog.EnumerateServersAsync(clientContext);
var contosoServer = servers.First(s => s.Name == "Contoso");

var client = await catalog.ActivateServerAsync(contosoServer);
var tools = await client.ListToolsAsync();

// Tools automatically integrate with existing agent framework
foreach (var tool in tools)
{
    agentTools.Add(tool);
}
```

### Security Proxy Architecture
**Windows-Mediated Communication:**
```
Agent Application → Windows MCP Proxy → MCP Server
├── Identity verification at each step
├── Permission checking and user consent
├── Audit logging and monitoring
└── Enterprise policy enforcement
```

### Tool Description Best Practices
**Effective Tool Metadata:**
```csharp
[MCPServerTool(
    description: "Search for products using fuzzy matching on name and description",
    parameters: new[] {
        new ParameterInfo("query", "Product name or description to search for")
    }
)]
public string SearchProducts(string query)
{
    // Implementation focuses on human-understandable actions
    // LLM uses description to map user intent to tool selection
}
```

---

## Session Highlights

> *"It's easy to make agents, but making them useful is a major challenge."* - Michael Von Hippel

> *"MCP magnifies your agentic investments. Multiple services can be integrated simultaneously, giving your agent a broad tool set."* - Michael Von Hippel

> *"The same work you do to integrate your tool with one agent, scales across all MCP capable agents with little friction."* - Michael Von Hippel

> *"This is like the first step of our J.A.R.V.I.S. dreams. So work as hard as you can on this."* - Audience Member

> *"We want to make Windows the best OS for AI developers, both working on agents, and making your apps and services work well with agents."* - Michael Von Hippel

---

## Implementation Roadmap

### Getting Started Today
```markdown
**Immediate Actions:**
1. Explore MCP SDK examples and documentation
2. Build simple MCP servers using C# SDK
3. Test local MCP integration with VS Code
4. Experiment with existing MCP servers and clients
5. Design application extensibility using App Actions

**Preparation Phase:**
- Study MCP protocol specifications and best practices
- Identify high-value integration scenarios in your applications
- Plan security and authentication requirements
- Design tool descriptions and metadata for optimal LLM interaction
```

### Public Preview Preparation
```markdown
**Timeline:** Within 1 month for private preview, 2-3 months to public release

**Prerequisites:**
- Windows application with proper identity and packaging
- Signed application manifests with MCP server extension
- Tool descriptions optimized for agent interaction
- Security and privacy compliance requirements

**Enterprise Considerations:**
- IT administrator approval processes
- Enterprise policy integration and compliance
- Private MCP server repository management
- Audit and monitoring requirement planning
```

### Long-term Strategy
```markdown
**Platform Evolution:**
- Remote MCP server registration capabilities
- Enhanced granular permission systems
- Expanded built-in Windows MCP server catalog
- Cross-platform MCP standardization and compatibility

**Application Integration:**
- App Actions ecosystem expansion
- Multi-agent workflow orchestration
- Enterprise application marketplace integration
- AI-powered application discovery and automation
```

---

## Advanced Applications and Use Cases

### Enterprise Workflow Automation
**Document Processing Pipeline:**
- **File system search** - AI-powered document discovery across enterprise content
- **Content analysis** - Automated summarization and information extraction
- **Application integration** - Cross-platform workflow coordination
- **Compliance tracking** - Audit trails and governance policy enforcement

### Development Environment Enhancement
**AI-Assisted Development:**
- **Environment setup** - Automated development environment configuration
- **Code generation** - AI-powered application scaffolding and implementation
- **Testing automation** - Intelligent test case generation and execution
- **Deployment orchestration** - Multi-environment release management

### Customer Service and Support
**Intelligent Agent Workflows:**
- **Knowledge base integration** - Real-time access to support documentation
- **System diagnostic tools** - Automated troubleshooting and issue resolution
- **Multi-application coordination** - Seamless handoffs between support tools
- **Escalation management** - Intelligent routing based on issue complexity

---

## Resources and Further Learning

### Official Documentation and SDKs
- **[MCP C# SDK](https://github.com/microsoft/model-context-protocol-csharp)** - Complete development framework for MCP servers and clients
- **[MCP Protocol Specification](https://spec.modelcontextprotocol.io/)** - Official protocol documentation and standards
- **[Windows App Actions](https://docs.microsoft.com/windows/apps/develop/app-actions/)** - Application extensibility framework and integration patterns
- **[MCP Security Blog](https://aka.ms/mcp-security)** - Security approach and best practices documentation

### Development Tools and Resources
- **[VS Code MCP Extension](https://marketplace.visualstudio.com/vscode-mcp)** - Local development and testing tools
- **[Windows MCP Registry](https://aka.ms/windows-mcp-registry)** - Server discovery and management system
- **[Application Packaging Tools](https://docs.microsoft.com/windows/msix/)** - Windows app identity and distribution requirements

### Related Build 2025 Sessions
- **BRK220: App Actions for Windows** - Application extensibility and inter-app communication
- **MCP Implementation Sessions** - Additional protocol usage patterns and examples
- **Agent Development Workshops** - Hands-on development and integration guidance
- **Enterprise AI Sessions** - Governance, security, and compliance considerations

### Community and Support
- **Build Hub: MCP and App Actions Area** - Direct interaction with product team
- **Private Preview Registration** - Early access program for MCP on Windows
- **Developer Feedback Channels** - Input on features, security, and usability
- **Partner Integration Program** - Collaboration opportunities for application developers

---

## About the Speakers

**Donald Thompson**  
Distinguished Engineer  
Microsoft  
*35+ years as technical architect and CTO, co-founder of Maana (computational knowledge graphs), creator of Bing's "Satori" Internet-scale knowledge graph, co-founder of semantic computing initiative funded by Bill Gates, builder of Microsoft's first Internet display ad delivery system.*

**Michael Von Hippel**  
Senior Product Manager  
Microsoft  
*Windows Platform team leader for agentic experiences, creator of App Actions for Windows and MCP on Windows. Microsoft veteran since 2016 working across hardware, software, and AI from Surface devices to platform technologies including haptics, HDR, dynamic refresh rate, and agentic enablement.*

---

*This comprehensive session establishes Windows as the premier platform for AI agent development, demonstrating how MCP on Windows solves critical challenges in extensibility, security, and discoverability while providing developers with powerful tools for creating sophisticated agentic applications that seamlessly integrate with the Windows ecosystem.*

