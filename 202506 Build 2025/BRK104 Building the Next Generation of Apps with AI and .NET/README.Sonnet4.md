# Building the Next Generation of Apps with AI and .NET

**Session Date:** May 19-22, 2025  
**Duration:** ~45 minutes  
**Venue:** Microsoft Build 2025  
**Speakers:** 
- **Ed Charbeneau**  
- **Jeremy Likness**: Principal Product Manager responsible for AI and .NET experience
- **Jon Galloway**: Principal Tech PM on DevDiv Community team
- **Brady Gaster**: Developer and creative technologist


**Link:** [Session Recording](https://build.microsoft.com/sessions/BRK104)

## Table of Contents

- [Building the Next Generation of Apps with AI and .NET](#building-the-next-generation-of-apps-with-ai-and-net)
  - [Table of Contents](#table-of-contents)
  - [Introduction and AI Evolution](#introduction-and-ai-evolution)
  - [Microsoft's .NET AI Ecosystem](#microsofts-net-ai-ecosystem)
    - [Production AI Applications](#production-ai-applications)
    - [AI Investment Overview](#ai-investment-overview)
    - [Building Blocks and Extensions](#building-blocks-and-extensions)
  - [Getting Started with AI Templates](#getting-started-with-ai-templates)
    - [Template Installation and Options](#template-installation-and-options)
    - [Vector Store Configuration](#vector-store-configuration)
    - [Live Demo Walkthrough](#live-demo-walkthrough)
  - [Advanced AI Concepts and Agents](#advanced-ai-concepts-and-agents)
    - [Understanding AI Agents](#understanding-ai-agents)
    - [Building Blocks for Agents](#building-blocks-for-agents)
    - [Real-World Application Architecture](#real-world-application-architecture)
  - [Travel Booking and Expense Management Demo](#travel-booking-and-expense-management-demo)
    - [Application Architecture](#application-architecture)
    - [Demo Workflow](#demo-workflow)
  - [Structured Data and Multi-Modal Processing](#structured-data-and-multi-modal-processing)
    - [Structured Data Responses](#structured-data-responses)
    - [Vector Data and Document Ingestion](#vector-data-and-document-ingestion)
    - [Multi-Modal Receipt Processing](#multi-modal-receipt-processing)
  - [Model Context Protocol (MCP)](#model-context-protocol-mcp)
    - [MCP Overview](#mcp-overview)
    - [MCP SDK for .NET](#mcp-sdk-for-net)
    - [Creative MCP Implementation - Music Generation](#creative-mcp-implementation---music-generation)
  - [Workflow Orchestration and Deployment](#workflow-orchestration-and-deployment)
    - [Semantic Kernel Process Framework](#semantic-kernel-process-framework)
    - [.NET Aspire Integration](#net-aspire-integration)
    - [Azure Deployment with AZD](#azure-deployment-with-azd)
  - [Model Evaluation and Safety](#model-evaluation-and-safety)
    - [Safety Evaluation](#safety-evaluation)
    - [Testing and Evaluation Framework](#testing-and-evaluation-framework)
  - [Future Roadmap](#future-roadmap)
  - [References](#references)

## Introduction and AI Evolution

**00:00:00** *(5m 30s)* - **Speakers:** Jeremy Likness, Jon Galloway

The session opened with an overview of the rapid evolution of AI technologies since 2022. Jeremy Likness highlighted the unprecedented **adoption of ChatGPT**, which reached **100 million users in just five days**. The discussion emphasized the exponential pace of AI development, with **task completion capabilities** doubling every seven months when AI achieves 50% accuracy.

Key statistics presented:

- ChatGPT's record-breaking user adoption (**100M users in 5 days**)
- **Exponential growth in AI capabilities**
- Tasks that previously required specialized libraries can now be accomplished through generative AI

## Microsoft's .NET AI Ecosystem

**00:05:30** *(8m 15s)* - **Speakers:** Jeremy Likness, Ed Charbeneau

### Production AI Applications

Jeremy demonstrated that .NET AI applications are not just experimental but are running in production across Microsoft's ecosystem:

- Microsoft Copilot
- GitHub Copilot
- Xbox Copilot for gaming
- H&R Block's AI-enhanced tax applications

### AI Investment Overview

The session outlined Microsoft's key investments in AI and .NET over the past year:

1. **Microsoft Extensions for AI** (General Availability)
2. **Vector Data Extensions** (General Availability)
3. **C#-based MCP Server**
4. **AI Templates** with complex scenarios
5. **Semantic Kernel** integration
6. **Model Evaluation Suite**

### Building Blocks and Extensions

**00:08:45** *(6m 20s)* - **Speakers:** Jeremy Likness, Ed Charbeneau

Ed Charbeneau from Telerik demonstrated how the `IChatClient` interface enables seamless integration with UI components. The demo showed:

- Registration of `IChatClient` in Program.cs
- Direct integration with Telerik AI Prompt component
- Pre-configured prompt suggestions for guided user interaction
- Seamless backend switching between AI providers

```csharp
// Example of IChatClient registration
builder.Services.AddSingleton<IChatClient>(serviceProvider => 
    new OpenAIChatClient(connectionString, modelId));
```

## Getting Started with AI Templates

**00:15:05** *(12m 45s)* - **Speaker:** Jon Galloway

### Template Installation and Options

Jon Galloway provided a comprehensive walkthrough of the AI chat web app template:

```bash
dotnet new install Microsoft.AspNetCore.App.ProjectTemplates.AI
```

The template offers multiple AI provider options:

- **Local Llama**: For development on powerful machines with GPU support
- **GitHub Models**: Free tier for development and prototyping
- **Azure OpenAI**: Enterprise-ready with full Azure integration
- **OpenAI Platform**: Direct integration with OpenAI services

### Vector Store Configuration

The template includes sophisticated vector database options:

- **Local JSON**: For prototyping (not recommended for production)
- **Azure AI Search**: Enterprise-grade vector search
- **Qdrant**: Open-source vector database with container support

### Live Demo Walkthrough

**00:20:30** *(7m 35s)* - **Speaker:** Jon Galloway

Jon demonstrated the complete workflow:

1. PDF ingestion and embedding creation
2. Semantic search capabilities
3. Direct linking to source documents
4. Real-time vector data processing through Aspire dashboard

Key technical highlights:

- Automatic PDF text extraction and vectorization
- .NET annotations for vector data mapping
- IChatClient abstraction for provider switching
- Production-ready scaling architecture

## Advanced AI Concepts and Agents

**00:28:05** *(5m 50s)* - **Speaker:** Jeremy Likness

### Understanding AI Agents

Jeremy defined agents as "large language models enhanced by different features and services":

- **Tools**: Access to real-time data and external systems
- **Memory**: Long-running conversation state
- **Data Augmentation**: Integration with existing business data
- **Orchestration**: Multi-agent coordination and routing
- **Workflows**: Business process automation

### Building Blocks for Agents

The Microsoft Extensions for AI provide agent-ready primitives:

- IChatClient interface for consistent agent communication
- Integration with Semantic Kernel for agent orchestration
- Orleans for stateful workflow management
- Flexible architecture supporting different agent frameworks

### Real-World Application Architecture

**00:33:55** *(3m 25s)* - **Speaker:** Jeremy Likness

The session presented a distributed architecture including:

- React frontend
- .NET backend services
- Python agent integration (demonstrating polyglot capabilities)
- Multi-modal processing capabilities

## Travel Booking and Expense Management Demo

**00:37:20** *(8m 40s)* - **Speaker:** Jeremy Likness

### Application Architecture

The demo application showcased a complete business workflow:

- Travel itinerary planning and booking
- Administrative approval processes
- Receipt processing and categorization
- Expense report generation

### Demo Workflow

The recorded demonstration showed:

1. **Trip Planning**: Natural language trip request → AI-generated itinerary
2. **Approval Process**: Human-in-the-loop approval workflow
3. **Policy Questions**: Company policy integration via vector search
4. **Receipt Processing**: Multi-modal image analysis and categorization
5. **Expense Reporting**: Structured data extraction and report generation

## Structured Data and Multi-Modal Processing

**00:46:00** *(6m 30s)* - **Speaker:** Jeremy Likness

### Structured Data Responses

Jeremy demonstrated how structured responses serve dual purposes:

- Programmatic parsing of AI responses
- Intent clarification for the AI model

```csharp
public enum UserIntent
{
    PlanTrip,
    ProcessReceipt,
    PolicyQuestion,
    GenerateReport
}

// Usage
var intent = await chatClient.GetStructuredResponseAsync<UserIntent>(userMessage);
```

### Vector Data and Document Ingestion

The ingestion service handles:

- PDF parsing and text extraction
- Automatic embedding generation
- Vector database storage
- Semantic search capabilities

```csharp
public class IngestionService
{
    public async Task IngestDocumentAsync(string pdfPath)
    {
        var document = await ParsePdfAsync(pdfPath);
        await vectorStore.StoreAsync(document);
    }
}
```

### Multi-Modal Receipt Processing

**00:49:30** *(4m 15s)* - **Speaker:** Jeremy Likness

Receipt processing demonstrates advanced multi-modal capabilities:

```csharp
public record ReceiptData(
    string Description,
    decimal Amount,
    string Category,
    DateTime Date,
    string ImageData
);

// Usage
var receipts = await chatClient.GetStructuredResponseAsync<List<ReceiptData>>(
    prompt, imageContent);
```

## Model Context Protocol (MCP)

**00:53:45** *(8m 50s)* - **Speakers:** Jeremy Likness, Brady Gaster

### MCP Overview

Jeremy introduced MCP as "OpenAPI for agents":

- Distributed service discovery for AI agents
- Tool registration and invocation
- Cross-platform agent communication
- Enterprise-grade agent orchestration

### MCP SDK for .NET

**00:56:20** *(6m 45s)* - **Speaker:** Brady Gaster

Brady demonstrated the .NET MCP SDK hosted directly in the official Model Context Protocol GitHub repository, showcasing Microsoft's commitment to open standards.

### Creative MCP Implementation - Music Generation

Brady's innovative demo featured an MCP server for music generation:

```csharp
[MCPServerTool]
public class MidiServer
{
    [MCPServerTool(description: "Play a sequence based on JSON format")]
    public async Task PlaySequenceAsync(string sequenceJson, int deviceId)
    {
        // Music generation and playback logic
    }
    
    [MCPServerTool(description: "Get available MIDI devices")]
    public Task<List<MidiDevice>> GetMidiDevicesAsync()
    {
        // Device enumeration logic
    }
}
```

The demo showcased:

- Natural language to MIDI conversion
- Multiple device support (Windows Wavetable, VCV Rack)
- Real-time music generation and playback
- LLM-driven tool orchestration

## Workflow Orchestration and Deployment

**01:03:05** *(5m 20s)* - **Speaker:** Jeremy Likness

### Semantic Kernel Process Framework

The application uses Semantic Kernel's process framework for:

- Step-based workflow definition
- Human approval integration
- Agent routing based on user intent
- Complex business process automation

```csharp
public class TripApprovalStep : ProcessStep
{
    public override async Task<ProcessStepResult> ExecuteAsync(
        ProcessStepContext context)
    {
        var approval = await PromptForApprovalAsync(context.TripRequest);
        return approval.IsApproved ? Success() : Reject();
    }
}
```

### .NET Aspire Integration

**01:06:25** *(4m 35s)* - **Speaker:** Jeremy Likness

Aspire provides:

- Distributed application orchestration
- Resource dependency management
- Development-time observability
- Production deployment capabilities

Key benefits demonstrated:

- Visual resource topology
- Request tracing across services
- Exception handling and debugging
- Seamless polyglot service integration

### Azure Deployment with AZD

The Azure Developer CLI integration enables:

- One-command deployment (`azd up`)
- Automatic resource provisioning
- Container Apps deployment
- Infrastructure as Code generation

## Model Evaluation and Safety

**01:10:00** *(3m 45s)* - **Speaker:** Jeremy Likness

### Safety Evaluation

The demo showed content safety evaluation:

- Image content analysis for inappropriate material
- Violence detection in uploaded receipts
- Automatic content filtering
- Safety dimension scoring

### Testing and Evaluation Framework

**01:12:15** *(2m 30s)* - **Speaker:** Jeremy Likness

The evaluation framework provides:

- Accuracy measurement (1-5 scale)
- Completeness assessment
- Grounding verification
- Integration with standard test harnesses

```csharp
[Test]
public async Task TestPolicyRetrieval()
{
    var evaluator = new RetrievalEvaluator();
    var result = await evaluator.EvaluateAsync(
        question: "What is the reimbursement policy?",
        expectedResponse: policyText,
        actualResponse: await agent.QueryAsync(question)
    );
    
    Assert.GreaterThan(result.AccuracyScore, 4.0);
}
```

## Future Roadmap

**01:14:45** *(1m 15s)* - **Speaker:** Jeremy Likness

Jeremy announced the upcoming .NET 10 release scheduled for **November 11th, 2025**, promising continued investment in AI capabilities and developer experience improvements.

## References

1. **Microsoft Extensions for AI Documentation**  
   [https://learn.microsoft.com/en-us/dotnet/ai/](https://learn.microsoft.com/en-us/dotnet/ai/)  
   *Comprehensive guide to Microsoft's AI building blocks for .NET, including IChatClient interfaces, vector data extensions, and integration patterns. Essential for understanding the foundational components demonstrated in the session.*

2. **Model Context Protocol GitHub Repository**  
   [https://github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)  
   *Official MCP repository containing the .NET SDK and implementation examples. Critical for understanding agent communication protocols and building distributed AI systems.*

3. **.NET AI Templates and Getting Started Guide**  
   [https://learn.microsoft.com/en-us/dotnet/ai/get-started/](https://learn.microsoft.com/en-us/dotnet/ai/get-started/)  
   *Step-by-step walkthrough for the AI chat web app template demonstrated by Jon Galloway. Provides the "Hello World" experience for AI development in .NET.*

4. **Semantic Kernel Documentation**  
   [https://learn.microsoft.com/en-us/semantic-kernel/](https://learn.microsoft.com/en-us/semantic-kernel/)  
   *Multi-platform SDK for AI orchestration and agent workflows. Relevant for understanding the process framework and agent routing mechanisms shown in the travel demo.*

5. **.NET Aspire Documentation**  
   [https://learn.microsoft.com/en-us/dotnet/aspire/](https://learn.microsoft.com/en-us/dotnet/aspire/)  
   *Cloud-ready application development framework used for orchestrating the distributed AI application. Essential for understanding polyglot service integration and deployment strategies.*

6. **Azure AI Search Vector Database**  
   [https://learn.microsoft.com/en-us/azure/search/vector-search-overview](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)  
   *Enterprise vector database service used in the production deployment scenarios. Important for understanding scalable vector search implementations.*

7. **Qdrant Vector Database**  
   [https://qdrant.tech/](https://qdrant.tech/)  
   *Open-source vector database demonstrated as an alternative to cloud solutions. Valuable for understanding local development and self-hosted vector search options.*

8. **GitHub Models for Developers**  
   [https://github.com/marketplace/models](https://github.com/marketplace/models)  
   *Free AI model access for developers demonstrated in the getting started experience. Crucial for cost-effective AI development and prototyping.*

9. **Telerik AI Integration Components**  
   [https://demos.telerik.com](https://demos.telerik.com)  
   *Commercial UI components showcasing IChatClient integration. Demonstrates ecosystem adoption of Microsoft's AI building blocks.*

10. **Azure Developer CLI (AZD)**  
    [https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)  
    *Command-line tool for deploying .NET applications to Azure. Essential for understanding the deployment automation demonstrated in the session.*
