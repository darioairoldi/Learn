# Build, Deploy, & Use Your First Model Context Protocol (MCP) Server

**Session Code:** DEM517  
**Authors:** James Montemagno, Katie Savage  
**Date:** Build 2025
- Build link: [DEM517](https://build.microsoft.com/en-US/sessions/DEM517?source=sessions)
- Internal sharepoint stream: [DEM517](https://microsofteur.sharepoint.com/teams/MicrosoftInternal11/_layouts/15/stream.aspx?id=%2Fteams%2FMicrosoftInternal11%2FShared%20Documents%2FEvents%2F20250502%20%2D%20Build%202025%2FDEM517%20%2D%20Build%2C%20Deploy%2C%20%26%20Use%20Your%20First%20Model%20Context%20Protocol%20%28MCP%29%20Server%2FDEM517%2Emp4&referrer=StreamWebApp%2EWeb&referrerScenario=AddressBarCopied%2Eview%2Ea38d6185%2Dc17f%2D41d8%2D8748%2D0578c6324bab)

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Core Concepts](#core-concepts)
3. [MCP Architecture and Deployment Options](#mcp-architecture-and-deployment-options)
4. [Authentication and Security](#authentication-and-security)
5. [Practical Implementation Examples](#practical-implementation-examples)
6. [Key Benefits](#key-benefits)
7. [Technical Implementation](#technical-implementation)
8. [Use Cases Demonstrated](#use-cases-demonstrated)
9. [Industry Impact](#industry-impact)
10. [Best Practices for MCP Implementation](#best-practices-for-mcp-implementation)
11. [Microsoft's Role in MCP](#microsofts-role-in-mcp)
12. [Conclusion](#conclusion)
13. [References](#references)

---

## Executive Summary

**Model Context Protocol (MCP)** is an **open standard that enables AI applications to access external data sources, tools, and resources** through a standardized interface.

Think of it as a "universal adapter" for AI applications - just as a universal adapter connects physical devices to different accessories, MCP connects AI applications to various data sources and tools without requiring custom connections for each one.

## Core Concepts

### What is Model Context Protocol?

MCP addresses a fundamental challenge in AI development: **How do we provide AI models with more context and the ability to perform actions on our behalf?**

The protocol enables AI tools to access:

- **Real-time data**
- **Business-specific information**
- **External APIs** and **services**
- **Custom tools** and **resources**

![alt text](<images/000.01 MCPdefined.png>)

### The Three Components of MCP

#### 1. **Hosts**
- Programs that want access to data and tools through MCP
- Examples: **Visual Studio Code**, **GitHub Copilot**, **Copilot Studio**
- These are the applications where users interact with AI

#### 2. **Clients**
- Maintain one-to-one connections with MCP servers
- Can sometimes be the same as hosts
- Handle the communication protocol between hosts and servers

#### 3. **Servers**
- **Lightweight programs that expose capabilities through MCP**
- The actual providers of data, tools, and functionality
- Can run locally, in containers, or remotely

![alt text](<images/000.01 MCP Components.png>)

## MCP Architecture and Deployment Options

MCP servers offer flexible deployment models to meet different organizational needs, from local development to enterprise-scale cloud deployments. Each approach has specific advantages and use cases.

### Local Deployment

**Local deployment** runs MCP servers directly on the developer's machine or within the same environment as the host application.

#### Key Characteristics:
- **Run MCP servers locally within applications** - servers execute as processes on the same machine
- **Use Docker containers for isolated environments** - containerization provides consistency and dependency management
- **Direct access to local data and resources** - no network latency, immediate access to file systems and local databases

#### Advantages:
- **Low latency** - Direct communication between client and server
- **Offline capability** - Works without internet connectivity
- **Development-friendly** - Easy debugging and testing
- **Security** - Data never leaves the local environment

#### Use Cases:
- **Development environments** - Testing and building MCP servers
- **Sensitive data processing** - When data cannot leave the local machine
- **Personal productivity tools** - Individual developer workflows
- **Local database analysis** - Direct schema inspection and queries

#### Example Configuration:
```json
{
  "mcpServers": {
    "local-db": {
      "command": "docker",
      "args": ["run", "--rm", "-v", "/local/data:/data", "my-mcp-server"]
    }
  }
}
```

### Remote Deployment

**Remote deployment** hosts MCP servers in cloud environments, enabling scalable, shared access across teams and applications.

#### Key Characteristics:
- **Execute servers over Server-Sent Events (SSE)** - Real-time, persistent connections for streaming data
- **Deploy in Azure Functions, Container Apps, or App Service** - Leverages cloud-native compute platforms
- **Managed through API Management and API Center** - Enterprise-grade API governance and monitoring
- **Optimized for remote MCP server scenarios** - Built for scale, reliability, and multi-tenant access

#### Server-Sent Events (SSE) Deep Dive:
- **Persistent connections** - Maintains long-lived connections for real-time updates
- **Unidirectional streaming** - Server pushes data to clients as it becomes available
- **Automatic reconnection** - Built-in resilience for network interruptions
- **HTTP-based** - Works through firewalls and proxies

#### Azure Deployment Options:

| Service | Execution Model | Key Features | Best For |
|---------|----------------|--------------|----------|
| **Azure Functions** | Serverless execution | • Pay per execution, automatic scaling<br>• Event-driven (HTTP, timers, other events)<br>• No infrastructure management | Lightweight, stateless MCP servers with sporadic usage |
| **Azure Container Apps** | Containerized deployment | • Full control over runtime environment<br>• Automatic scaling (scales to zero)<br>• Built-in service discovery | Complex MCP servers with custom dependencies |
| **Azure App Service** | Platform-as-a-Service | • Managed hosting with built-in monitoring<br>• Always-on capability<br>• Integrated CI/CD and deployment slots | Production MCP servers requiring high availability |

#### API Management Integration:
- **Centralized governance** - Consistent policies across all MCP servers
- **Rate limiting** - Protect servers from overuse
- **Authentication** - Unified security model
- **Monitoring** - Real-time analytics and alerting

#### Use Cases:
- **Enterprise scenarios** - Shared access across multiple teams
- **Scalable data processing** - Handle high-volume requests
- **Global accessibility** - Access from anywhere with internet
- **Centralized management** - IT governance and compliance

### Web Services Integration

**Web Services Integration** connects MCP servers to external APIs and cloud services, extending AI capabilities beyond local resources.

#### Key Characteristics:
- **Connect to external APIs like GitHub** - Seamless integration with third-party services
- **Gather and create issues, pull requests, and other resources** - Bi-directional data flow
- **Seamless integration with existing workflows** - No disruption to established processes

#### Integration Patterns:

**API Aggregation:**

- **Single interface** - MCP server consolidates multiple APIs
- **Data normalization** - Consistent data formats across different services
- **Error handling** - Unified error responses and retry logic

**Real-time Data Sync:**

- **Webhook integration** - Receive updates from external services
- **Event processing** - React to changes in external systems
- **Data consistency** - Maintain synchronized state across services

**Workflow Automation:**

- **Action triggers** - Automatically perform tasks based on conditions
- **Multi-step processes** - Chain together multiple API calls
- **Business logic** - Implement complex workflows in MCP servers

#### Popular Integration Examples:

**GitHub Integration:**

- **Issue management** - Create, update, and query GitHub issues
- **Pull request automation** - Manage code review processes
- **Repository analysis** - Extract insights from code repositories
- **Project tracking** - Sync with project management tools

**Database Connectivity:**

- **Schema analysis** - Understand database structure and relationships
- **Query execution** - Run SQL queries and return results
- **Data visualization** - Generate charts and reports from database data

**Cloud Services:**

- **Azure Cognitive Services** - Add AI capabilities like translation or vision
- **Microsoft Graph** - Access Office 365 and Microsoft 365 data
- **Third-party SaaS** - Connect to CRM, ERP, and other business systems

#### Benefits of Web Services Integration:
- **Extended capabilities** - Access to vast ecosystem of services
- **Real-time data** - Always up-to-date information
- **Workflow continuity** - Maintain flow while accessing external resources
- **Centralized access** - Single point of integration for multiple services

#### Architecture Diagram Concept:
```
Local Machine          Cloud Services          External APIs
     |                       |                      |
[VS Code] <---> [Local MCP] <---> [Azure Functions] <---> [GitHub API]
     |                       |                      |
[Copilot] <---> [Docker]    <---> [Container Apps] <---> [Database]
     |                       |                      |
[Tools]   <---> [Process]   <---> [App Service]   <---> [Third-party]
```

This flexible architecture allows organizations to choose the right deployment model for their specific needs, whether prioritizing security, scalability, or integration capabilities.

## Authentication and Security

### Built-in OAuth 2.1 Support
- Clear separation between APIs and authorization servers
- Plug-and-play compatibility with existing auth systems
- Support for Microsoft Entra ID and other identity providers
- No need to implement authentication from scratch

### Security Best Practices
- MCP servers declare their authorization requirements
- Existing organizational security policies apply
- Token-based authentication for API access
- Secure handling of sensitive organizational data

## Practical Implementation Examples

### GitHub Integration
The session demonstrated a GitHub MCP server that enables:
- Listing open issues from repositories
- Creating and managing GitHub issues
- Accessing repository information
- All without leaving the development environment

### Custom MCP Servers

The session featured a compelling example called the **"Monkey MCP Server"** that demonstrated how developers can create custom MCP servers tailored to specific business needs or personal interests.

#### The "Monkey MCP Server" Example

**What it is:**

- A custom MCP server created by one of the presenters who "loves monkeys"
- Designed to work with the **"Monkey App Vibes"** .NET MAUI application
- Demonstrates how MCP servers can be domain-specific and highly personalized

**The Live Demonstration:**
During the session, the presenter showed a real-time example of how MCP works by using natural language queries:

1. **"Get me a list of monkeys"** - The AI automatically discovered and used the `get_monkeys` tool
2. **Data visualization** - The raw JSON data was automatically converted into a formatted table  
3. **Schema analysis** - When asked "what is the JSON schema here?", the AI analyzed and displayed the data structure
4. **Format conversion** - The presenter even asked "what would this look like in COBOL?" and the AI converted the data format

**Key Functionality:**

- **`get_monkeys` tool** - Retrieves structured monkey data from the custom server
- **JSON data provider** - Returns monkey information in a standardized format
- **Schema-aware responses** - Provides consistent data structure for AI analysis
- **Seamless integration** - Works alongside other MCP servers like the GitHub server

![alt text](<images/001.01 MCP Commands discovered.png>)

**Technical Implementation:**
```json
{
  "mcpServers": {
    "monkey-server": {
      "command": "path/to/monkey-mcp-server",
      "args": ["--data-source", "monkey-database"]
    }
  }
}
```

**Real-world Workflow Impact:**
As the presenter emphasized: *"I'm a developer. I no longer have to leave my flow no matter where I'm at. I might just be somewhere not in VS Code, some other editor... But I can say, OK, get me a list of monkeys here."*

This demonstrates the core value proposition of MCP - maintaining workflow continuity while accessing external data and tools through natural language interactions.

#### Why This Example Matters

**1. Personalization and Flexibility**
- Shows how MCP servers can be created for any use case, no matter how niche
- Demonstrates the ease of creating custom tools that integrate seamlessly with AI

**2. Development Workflow Integration**
- The monkey server worked alongside the GitHub MCP server
- Multiple MCP servers can operate simultaneously
- AI automatically selects the appropriate tool based on user intent

**3. Data Processing Intelligence**
- Raw data from the MCP server became intelligent, analyzable information
- AI handled visualization, formatting, and schema inference
- No need to pre-process data - the AI adapts to whatever format is returned

**4. Extensibility Pattern**
- Provides a template for creating other custom MCP servers
- Shows how domain expertise can be packaged into reusable AI tools
- Demonstrates the value of the MCP standard for custom development

#### Creating Your Own Custom MCP Server

**Step 1: Identify Your Use Case**
- What specific data or functionality do you want to expose?
- What APIs or databases do you need to connect to?
- What tools would enhance your workflow?

**Step 2: Design Your Tools**
- Define the functions your MCP server will expose
- Plan the data structures and response formats
- Consider authentication and security requirements

**Step 3: Implementation Options**
- **Local development** - Quick prototyping and testing
- **Containerized deployment** - Consistent runtime environment
- **Cloud hosting** - Scalable, shared access across teams

**Step 4: Integration**
- Configure your MCP client to connect to your server
- Test natural language queries against your tools
- Iterate based on AI interaction patterns

The "Monkey MCP Server" perfectly demonstrates that MCP's power lies not just in connecting to existing services, but in enabling developers to create entirely new AI-accessible tools that seamlessly integrate into their workflows.

## Key Benefits

### 1. **Workflow Continuity**
- Developers stay in their preferred tools
- No context switching between applications
- Seamless integration with existing workflows

### 2. **Standardization**
- Open standard created by Anthropic
- Industry-wide collaboration on standards
- Consistent interface across different tools

### 3. **Extensibility**
- Easy to add new data sources
- Custom server development
- Flexible deployment options

### 4. **Tool Integration**
- Natural language queries to access data
- AI-powered data analysis and visualization
- Automatic tool discovery and selection

## Technical Implementation

### Configuration
MCP servers are configured through JSON files that specify:
- Server endpoints and connection details
- Authentication requirements
- Available tools and capabilities
- Deployment configuration

### Tool Discovery
AI applications automatically discover available MCP tools:
- Dynamic tool selection based on user queries
- Real-time capability assessment
- Context-aware tool recommendations

### Data Processing
- MCP servers return raw data
- AI models handle visualization and analysis
- Flexible output formats (tables, charts, code)
- Schema inference and data structure analysis

## Use Cases Demonstrated

### 1. **Development Workflow Enhancement**
- Query GitHub issues directly from IDE
- Access project-specific data
- Integrate with development tools

### 2. **Data Analysis and Visualization**
- Convert raw data into structured formats
- Generate tables and visual representations
- Perform data transformation tasks

### 3. **Cross-Platform Integration**
- Connect different tools and services
- Unify data access across platforms
- Standardize API interactions

## Industry Impact

### Open Standard Adoption
- Not proprietary to any single vendor
- Collaborative development with industry partners
- Continuous evolution based on community feedback

### Ecosystem Growth
- Multiple tools implementing MCP support
- Growing library of available servers
- Community-driven development

### Future Potential
- Integration with Windows and other platforms
- Expansion to cloud desktop environments
- Broader AI application support

## Best Practices for MCP Implementation

### 1. **Server Design**
- Keep servers lightweight and focused
- Implement proper error handling
- Follow security best practices
- Document available tools and capabilities

### 2. **Authentication Setup**
- Use existing OAuth 2.1 infrastructure
- Implement proper token management
- Follow organizational security policies
- Regular security audits and updates

### 3. **Performance Optimization**
- Efficient data retrieval and processing
- Appropriate caching strategies
- Scalable deployment architectures
- Monitor server performance and usage

## Microsoft's Role in MCP

As emphasized during the presentation, **MCP is not a Microsoft technology** - it's an **open standard created by Anthropic**. However, Microsoft plays a significant role as an **infrastructure provider and community contributor** in the Model Context Protocol ecosystem.

**Key Quote from the Session:**
*"And the cool part about all of this is that this is an open standard. It's not a Microsoft thing. It's actually created originally by Anthropic, and companies around the entire ecosystem have worked closely with Anthropic to continue to evolve these standards."*

**Microsoft's Contributions:**

**Azure Infrastructure Support:**
Microsoft's Azure cloud platform provides the foundational infrastructure that makes enterprise-scale MCP deployment possible. Through services like Azure Functions, Container Apps, and App Service, Microsoft offers the compute platforms that host MCP servers in production environments. The integration with Azure API Management and API Center provides the governance, security, and monitoring capabilities that enterprises need to deploy MCP servers at scale.

**Developer Tools Integration:**
Microsoft has integrated MCP support into its developer tools ecosystem, with Visual Studio Code and GitHub Copilot serving as MCP hosts. As mentioned in the session, "Different tools such as VS Code and Visual Studio have different ways of configuring MCP servers."

**SDK and Community Support:**
The presenters noted that "here at Microsoft, we actually maintain the C SDK" for MCP, demonstrating Microsoft's commitment to supporting the broader MCP ecosystem with development tools and resources.

**Standards Collaboration:**
Rather than creating a proprietary alternative, Microsoft has embraced the open standard and focused on providing best-in-class infrastructure and tooling. This approach aligns with the collaborative nature of MCP development, where "companies around the entire ecosystem have worked closely with Anthropic to continue to evolve these standards."

**API Management Integration:**
Microsoft's API Management and API Center services are "optimized for remote MCP server scenarios," providing enterprise-grade capabilities for managing MCP servers at scale.

In essence, Microsoft's role is that of a **collaborative ecosystem partner** - they provide the platform, tools, and enterprise capabilities that make MCP practical for real-world deployment, while respecting and supporting the open standard created by Anthropic and the broader community.

![alt text](<images/002.01 MCP clients hosts tools.png>)

## Conclusion

Model Context Protocol represents a significant advancement in AI tool integration, providing a standardized way to extend AI capabilities with external data and tools. Its open standard approach, combined with robust security features and flexible deployment options, makes it an ideal solution for organizations looking to enhance their AI workflows while maintaining security and operational efficiency.

The demonstrated examples show how MCP can transform developer workflows by providing seamless access to external data sources and tools, all while maintaining the natural language interface that makes AI tools so powerful.

---

## References

### Official Documentation

- **[Model Context Protocol Official Website](https://modelcontextprotocol.io/)** - The primary resource for understanding MCP, including getting started guides, available servers, and community resources. Essential for anyone implementing or using MCP.

- **[MCP Specification](https://spec.modelcontextprotocol.io/)** - The official technical specification defining the MCP protocol, message formats, and implementation requirements. Critical for developers building MCP servers or clients.

- **[Anthropic MCP Documentation](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)** - Documentation from the creators of MCP, providing insights into tool use patterns and best practices for AI model integration with external tools.

### Microsoft Resources

- **[Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/)** - Documentation for managing and securing MCP servers deployed as APIs in Azure, providing centralized governance, rate limiting, and monitoring capabilities discussed in the session.

- **[Azure API Center](https://docs.microsoft.com/en-us/azure/api-center/)** - Resource for cataloging and discovering MCP servers within enterprise environments, enabling teams to find and reuse existing MCP implementations.

- **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/)** - Guide for deploying lightweight, serverless MCP servers with automatic scaling and pay-per-execution pricing, ideal for sporadic usage scenarios.

- **[Azure Container Apps](https://docs.microsoft.com/en-us/azure/container-apps/)** - Documentation for containerized MCP server deployments with auto-scaling capabilities, perfect for complex servers with custom dependencies.

- **[Microsoft Entra ID](https://docs.microsoft.com/en-us/azure/active-directory/)** - Authentication service that integrates seamlessly with MCP's OAuth 2.1 support, providing enterprise-grade identity management for MCP servers.

### GitHub and Development Tools

- **[GitHub API Documentation](https://docs.github.com/en/rest)** - Reference for the GitHub API used in the session's demonstration, showing how MCP servers can integrate with version control systems and project management workflows.

- **[VS Code Extension API](https://code.visualstudio.com/api)** - Documentation for extending VS Code with MCP capabilities, enabling developers to create custom integrations and enhance their development environment.

- **[GitHub Copilot Documentation](https://docs.github.com/en/copilot)** - Guide for the AI coding assistant that serves as an MCP host in the demonstrated examples, showing how AI tools can leverage MCP for enhanced capabilities.

### Security and Authentication Standards

- **[OAuth 2.1 Specification](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1)** - The authentication standard that MCP builds upon, providing secure, standardized authentication without requiring custom implementation from MCP server developers.

- **[Server-Sent Events (SSE) Standard](https://html.spec.whatwg.org/multipage/server-sent-events.html)** - The web standard used for real-time communication between MCP clients and remote servers, enabling persistent connections and streaming data updates.

- **[API Security Best Practices](https://owasp.org/www-project-api-security/)** - Security guidelines essential for protecting MCP servers and the sensitive data they access, ensuring enterprise-grade security in AI tool integrations.

### Related Technologies

- **[Docker Documentation](https://docs.docker.com/)** - Container platform documentation relevant for local MCP server deployment and development environments, providing isolation and consistency across different systems.

- **[JSON Schema](https://json-schema.org/)** - Standard for defining data structures returned by MCP servers, enabling AI models to understand and validate the format of data they receive from custom servers.

- **[WebVTT (Web Video Text Tracks)](https://developer.mozilla.org/en-US/docs/Web/API/WebVTT_API)** - Format used for the session transcript, demonstrating how structured data formats can be processed and analyzed using MCP-enabled AI tools.

other references:
![alt text](<images/002.01 references.png>)