# Unlock Agentic Interactions for Your Apps Using MCP on Windows

**Session Date:** May 19-22, 2025  
**Duration:** 1 hour  
**Venue:** Microsoft Build 2025 Conference - Session BRK229  
**Speakers:** Michael Von Hippel (Senior Product Manager, Microsoft Windows), Donald Thompson (Distinguished Engineer, Microsoft), Alexander Sklar, Jesse Bishop, Kiran Kumar  
**Link:** [Microsoft Build 2025 Session BRK229](https://build.microsoft.com)

---

## Table of Contents

1. [Introduction and Session Overview](#1-introduction-and-session-overview)
2. [The Challenge of Agentic Integration](#2-the-challenge-of-agentic-integration)
   - 2.1. [Agent Utility Requirements](#21-agent-utility-requirements)
   - 2.2. [The Tool Problem for Agents](#22-the-tool-problem-for-agents)
3. [Model Context Protocol (MCP) Fundamentals](#3-model-context-protocol-mcp-fundamentals)
   - 3.1. [MCP Architecture and Components](#31-mcp-architecture-and-components)
   - 3.2. [Transport Mechanisms](#32-transport-mechanisms)
   - 3.3. [Benefits and Strategic Value](#33-benefits-and-strategic-value)
4. [Live Development Demonstration](#4-live-development-demonstration)
   - 4.1. [WSL Integration Through MCP](#41-wsl-integration-through-mcp)
   - 4.2. [Contoso Business Scenario](#42-contoso-business-scenario)
   - 4.3. [GitHub Copilot Agent Mode](#43-github-copilot-agent-mode)
5. [Creating MCP Servers](#5-creating-mcp-servers)
   - 5.1. [C# SDK Implementation](#51-c-sdk-implementation)
   - 5.2. [Tool Metadata and Descriptions](#52-tool-metadata-and-descriptions)
   - 5.3. [Local Testing with VS Code](#53-local-testing-with-vs-code)
6. [MCP on Windows Platform](#6-mcp-on-windows-platform)
   - 6.1. [Three Pillars Architecture](#61-three-pillars-architecture)
   - 6.2. [Security Framework](#62-security-framework)
   - 6.3. [Application Identity and Manifest System](#63-application-identity-and-manifest-system)
7. [Built-in MCP Servers for Windows](#7-built-in-mcp-servers-for-windows)
   - 7.1. [Windows System Integration](#71-windows-system-integration)
   - 7.2. [App Actions for Windows](#72-app-actions-for-windows)
8. [Enterprise and Development Considerations](#8-enterprise-and-development-considerations)
   - 8.1. [Trust and Identity Model](#81-trust-and-identity-model)
   - 8.2. [Development Workflow Integration](#82-development-workflow-integration)
9. [Multi-Application Workflow Demonstrations](#9-multi-application-workflow-demonstrations)
   - 9.1. [Perplexity Partnership Demo](#91-perplexity-partnership-demo)
   - 9.2. [Cross-Application Automation](#92-cross-application-automation)

---

## 1. Introduction and Session Overview

**Timeframe:** 00:00:00 - 00:02:30 (2m 30s)  
**Speakers:** Michael Von Hippel, Donald Thompson

This session introduces Microsoft's comprehensive approach to making Windows the premier platform for AI agent development through the Model Context Protocol (MCP). The presentation focuses on solving critical challenges in agent extensibility, security, and discoverability.

Michael Von Hippel opens the session by establishing the strategic importance of MCP for Microsoft, noting that "MCP's a pretty big deal for Microsoft" and explaining that their goal is to "make Windows the best OS for AI developers, both working on agents, and making your apps and services work well with agents."

Donald Thompson, a Distinguished Engineer at Microsoft working on "agents and agent technology across the company," introduces the demonstration approach using Contoso, Microsoft's traditional demo company, to show practical applications of MCP in real-world scenarios.

The session establishes the core premise that while "it's easy to make agents," the real challenge lies in "making them useful" through proper tool integration and extensibility.

---

## 2. The Challenge of Agentic Integration

**Timeframe:** 00:02:30 - 00:06:15 (3m 45s)  
**Speakers:** Michael Von Hippel, Donald Thompson

### 2.1. Agent Utility Requirements

Michael Von Hippel identifies four critical requirements for useful agents:

1. **Context and memory** - Agents should understand user needs without extensive prompting
2. **Action capabilities** - Tools that enable agents to act on behalf of users
3. **Content access** - Real-time data retrieval and system integration
4. **Personalization** - User-specific information and preference handling

### 2.2. The Tool Problem for Agents

The core challenge articulated is that "if an agent doesn't have access to the right tools for accessing content, personalizing things, and acting on it, then all they can do is tell you what to do based on some limited information."

Donald Thompson demonstrates this challenge through a practical scenario: creating a sales agent for field personnel who need to "look up products and inventory" without "having to mess with a traditional form and database application." The agent should allow users to "just chat something into their agent, and let it figure out what the inventory is."

The demonstration begins with a boilerplate C# SDK agent that has "an empty collection of tools," highlighting that "an agent, in order to be an agent, needs to take action and use tools."

---

## 3. Model Context Protocol (MCP) Fundamentals

**Timeframe:** 00:06:15 - 00:12:00 (5m 45s)  
**Speakers:** Michael Von Hippel

### 3.1. MCP Architecture and Components

Michael Von Hippel explains the fundamental vocabulary of MCP:

- **Hosts**: Agents that want to access data and tools through MCP
- **Clients**: Connection interfaces between hosts and servers  
- **Servers**: Lightweight programs exposing specific capabilities
- **Tools**: Action-taking functions for real-world tasks
- **Resources**: Atomic units of functionality for accessing files, databases, and services

### 3.2. Transport Mechanisms

Donald Thompson details the available transport options:

- **Standard IO**: Local server communication through process pipes
- **Server-Sent Events (SSE)**: Traditional HTTP bidirectional communication
- **HTTP Streamable**: Enhanced protocol with WebSocket support
- **Future expansions**: Additional transport methods in development

### 3.3. Benefits and Strategic Value

The strategic advantages of MCP include:

- **Investment magnification**: Same integration work scales across all MCP-capable agents
- **Unified integration**: Multiple services integrated simultaneously for broad tool sets
- **Industry adoption**: Microsoft and other major players investing in MCP standardization
- **Cross-platform compatibility**: Single standard replacing multiple bespoke plugin systems

Michael Von Hippel emphasizes that "MCP has seen a huge uptick on GitHub, and for really good reason. It magnifies your agentic investments."

---

## 4. Live Development Demonstration

**Timeframe:** 00:12:00 - 00:25:30 (13m 30s)  
**Speakers:** Donald Thompson, Michael Von Hippel

### 4.1. WSL Integration Through MCP

Donald Thompson demonstrates how MCP enables natural language control of Windows Subsystem for Linux through GitHub Copilot's Agent Mode. The demonstration shows:

- Querying available Linux distributions: "What Linux distros are available for WSL?"
- Installing distributions: "Install the Fedora Linux distro"
- Managing development environments through conversational commands

The integration requires user approval for each action, with popup dialogs specifying the exact tool being used (e.g., "WSL list online distros").

### 4.2. Contoso Business Scenario

The demonstration uses a realistic sales scenario where agents help field personnel access product and inventory information. The process involves:

1. Setting up a Fedora Linux environment in WSL
2. Cloning a FastAPI REST server repository
3. Installing dependencies using UV (Python package manager)
4. Starting the REST server with product and inventory endpoints

The server exposes two key endpoints:

- **Search products**: Fuzzy matching on product names and descriptions
- **Get product**: Detailed product information including inventory levels

### 4.3. GitHub Copilot Agent Mode

The demonstration showcases how GitHub Copilot's Agent Mode can:

- Execute WSL commands based on natural language requests
- Set up complete development environments automatically
- Translate user intent into specific system commands
- Provide user control through approval dialogs for each action

Donald Thompson notes that the agent "knows how to translate my intent into the right set of commands" even when users "don't know all the commands."

---

## 5. Creating MCP Servers

**Timeframe:** 00:25:30 - 00:35:00 (9m 30s)  
**Speakers:** Donald Thompson

### 5.1. C# SDK Implementation

Donald Thompson demonstrates creating an MCP server using Microsoft's C# SDK. The implementation is remarkably simple:

```csharp
[MCPServerTool(description: "Search products by name or description")]
public string SearchProducts(string query)
{
    return httpClient.GetAsync($"/search?q={query}").Result;
}

[MCPServerTool(description: "Get detailed product information by ID")]
public ProductInfo GetProduct(int productId) 
{
    return httpClient.GetAsync($"/product/{productId}").Result;
}
```

Key implementation points:

- **Standard console application**: No complex infrastructure required
- **HTTP client abstraction**: Supports any backend (GraphQL, SOAP, gRPC)
- **Minimal code**: Approximately 15 lines for complete integration
- **Transport flexibility**: Choice between Standard IO, SSE, or HTTP Streamable

### 5.2. Tool Metadata and Descriptions

The metadata decorating each tool is critical for LLM understanding:

- **Description**: Explains what the tool does in natural language
- **Parameters**: Defines input requirements and types
- **Return types**: Specifies output structure

Donald Thompson emphasizes that "this metadata is really important because it's what the LLM uses to know when it's deciding which of the tools that you passed it to select to perform the action that you've asked it to."

### 5.3. Local Testing with VS Code

The development workflow includes:

1. Creating a local MCP.JSON configuration file
2. Using VS Code's built-in MCP server management UI
3. Testing tools directly through GitHub Copilot integration
4. Real-time server restart and debugging capabilities

The local configuration enables immediate testing without full Windows Registry integration, streamlining the development process.

---

## 6. MCP on Windows Platform

**Timeframe:** 00:35:00 - 00:45:00 (10m 00s)  
**Speakers:** Michael Von Hippel, Donald Thompson, Kiran Kumar

### 6.1. Three Pillars Architecture

Michael Von Hippel introduces the foundational architecture:

1. **MCP Registry for Windows**: Application identity and server discovery system
2. **MCP Servers for Windows**: Activated through proxy with user control
3. **Built-in MCP Servers**: Out-of-the-box Windows capabilities

### 6.2. Security Framework

The security approach follows three core principles:

**Trust Implementation:**

- Identity requirement for all registered servers
- User control through end-user and enterprise settings
- Transparency in tool usage with clear explanations
- Complete audit trails of all MCP interactions

**Security Measures:**

- Server isolation through proxy architecture
- Permission brokering with Windows as mediator
- Anti-malware integration with real-time abuse detection
- Enterprise IT policy integration through MDM

**Safety Practices:**

- Responsible AI integration with built-in guardrails
- Privacy controls for user data protection
- Real-time monitoring and abuse detection
- Granular tool-level access control

### 6.3. Application Identity and Manifest System

Applications register MCP servers through standard Windows manifests:

```xml
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

Key features:

- **Off by default**: No immediate privilege escalation
- **Manual activation**: Explicit user consent required
- **Settings integration**: Control through Windows Settings app
- **Enterprise policies**: IT administrator governance capabilities

---

## 7. Built-in MCP Servers for Windows

**Timeframe:** 00:45:00 - 00:50:00 (5m 00s)  
**Speakers:** Michael Von Hippel, Donald Thompson

### 7.1. Windows System Integration

Built-in MCP servers provide immediate Windows capabilities:

- **Windows Subsystem for Linux (WSL)**: Linux environment management
- **Snap Layouts**: Window management and arrangement
- **File System MCP**: File operations and semantic search
- **Settings MCP**: Windows configuration and preference management

### 7.2. App Actions for Windows

The App Actions framework enables inter-application communication:

- **Enterprise integration**: Goodnotes, Todoist, Spark Mail connectivity
- **Partner ecosystem**: Expanding application integration support
- **Workflow automation**: Cross-application task coordination
- **Native extensibility**: Built-in application action capabilities

Donald Thompson demonstrates Snap Layouts integration where a simple command "Snap Windows next to each other" automatically arranges windows using native Windows functionality.

---

## 8. Enterprise and Development Considerations

**Timeframe:** 00:50:00 - 00:55:00 (5m 00s)  
**Speakers:** Michael Von Hippel, Donald Thompson, Kiran Kumar

### 8.1. Trust and Identity Model

Enterprise requirements include:
- **Installed applications only**: No arbitrary script execution
- **Identity verification**: Cryptographic application signatures  
- **Trust relationships**: Verified connections between clients and servers
- **Enterprise governance**: IT administrator control and oversight

### 8.2. Development Workflow Integration

Visual Studio Code MCP extension enables:
- **Local testing**: Immediate MCP server validation
- **GitHub Copilot integration**: Agent-assisted development workflows
- **Hot reload**: Real-time server updates during development
- **Multi-environment support**: Local, remote, and hybrid configurations

Enterprise management features:
- **MDM integration**: Mobile Device Management policy enforcement
- **Private repositories**: Enterprise-controlled MCP server catalogs
- **Audit logging**: Complete interaction tracking and monitoring
- **Granular permissions**: Tool and server-level access control

---

## 9. Multi-Application Workflow Demonstrations

**Timeframe:** 00:55:00 - 01:00:00 (5m 00s)  
**Speakers:** Donald Thompson, Michael Von Hippel

### 9.1. Perplexity Partnership Demo

A comprehensive productivity workflow demonstration shows:

1. **File System Search**: AI-powered document discovery across enterprise content
2. **Document Summarization**: Automated analysis of found documents  
3. **Email Creation**: Spark Mail integration via App Actions
4. **Background Removal**: Paint.NET integration for image editing
5. **Email Attachment**: Complete workflow automation

### 9.2. Cross-Application Automation

Additional demonstrations include:

**Figma Integration**: Design-to-code workflow
- Access to currently selected Figma design
- Automatic HTML/CSS generation from design
- Seamless code integration into existing projects
- Live preview with immediate functional website updates

**Complex Query Processing**: Inventory management scenario
- User query: "What is the total inventory of widgets?"
- Agent automatically searches for "widgets" products
- Retrieves detailed information for Widget A and Widget B
- Calculates total inventory (45 + 30 = 75 widgets)
- Requires user approval for each tool invocation

---

## Appendix: Technical Implementation Details

### A.1. MCP Client Implementation Pattern

Consumer applications integrate MCP through the following pattern:

```csharp
var catalog = MCPServerCatalog.GetInstance();
var clientContext = new MCPClientContext("MyAgentApp");
var servers = await catalog.EnumerateServersAsync(clientContext);
var contosoServer = servers.First(s => s.Name == "Contoso");
var client = await catalog.ActivateServerAsync(contosoServer);
var tools = await client.ListToolsAsync();
```

### A.2. Security Proxy Architecture

All MCP communication flows through Windows-mediated channels:
```
Agent Application → Windows MCP Proxy → MCP Server
├── Identity verification at each step
├── Permission checking and user consent  
├── Audit logging and monitoring
└── Enterprise policy enforcement
```

### A.3. Development Timeline and Availability

**Kiran Kumar** provides timeline information:
- **Private Preview**: Available within 1 month of the session
- **Public Release**: Approximately 2-3 months after private preview
- **App Actions**: Currently available for immediate use
- **MCP Integration**: Future automatic conversion from App Actions to MCP servers

### A.4. Tool Description Best Practices

Effective tool metadata should be optimized for LLM understanding:

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
}
```

---

## References

### Official Documentation and Resources

1. **[MCP C# SDK Repository](https://github.com/microsoft/model-context-protocol-csharp)**  
   *Complete development framework for creating MCP servers and clients using C#. Essential resource for developers implementing MCP integration.*

2. **[MCP Protocol Specification](https://spec.modelcontextprotocol.io/)**  
   *Official protocol documentation defining the standard for Model Context Protocol. Critical reference for understanding transport mechanisms, message formats, and implementation requirements.*

3. **[MCP Security Blog](https://aka.ms/mcp-security)**  
   *Microsoft's detailed security approach for MCP on Windows, published concurrently with this session. Explains trust, security, and safety frameworks discussed in the presentation.*

4. **[Windows App Actions Documentation](https://docs.microsoft.com/windows/apps/develop/app-actions/)**  
   *Framework for application extensibility that serves as a foundation for MCP integration. Relevant for developers preparing applications for future MCP compatibility.*

### Development Tools and Extensions

5. **[VS Code MCP Extension](https://marketplace.visualstudio.com/vscode-mcp)**  
   *Visual Studio Code extension enabling local MCP server development and testing. Demonstrated extensively in the session for GitHub Copilot integration.*

6. **[Windows MCP Registry Documentation](https://aka.ms/windows-mcp-registry)**  
   *System for server discovery and management on Windows. Central to the three-pillars architecture discussed in the session.*

### Related Microsoft Build 2025 Sessions

7. **[BRK220: App Actions for Windows](https://build.microsoft.com/sessions/brk220)**  
   *Complementary session covering application extensibility framework that underlies MCP integration capabilities demonstrated.*

8. **[Microsoft Extensions.AI Documentation](https://docs.microsoft.com/dotnet/ai/)**  
   *AI framework used in the demonstration for OpenAI client integration. Relevant for developers building AI-enabled applications.*

### Community and Development Resources

9. **[Windows MSIX Packaging Documentation](https://docs.microsoft.com/windows/msix/)**  
   *Application packaging requirements for Windows app identity, essential for MCP server registration and security model.*

10. **[GitHub MCP Repository Examples](https://github.com/topics/model-context-protocol)**  
    *Community examples and implementations of MCP servers across various platforms and languages. Valuable for learning different implementation approaches.*

---

*This comprehensive analysis captures the transformative vision presented in BRK229, where Microsoft positions Windows as the premier platform for AI agent development through MCP, solving critical challenges in extensibility, security, and discoverability while providing developers with powerful tools for creating sophisticated agentic applications.*
