---
title: "GitHub Copilot SDK: Building agents for any application"
author: "Dario Airoldi"
date: "2026-01-24"
categories: [GitHub Copilot, SDK, AI, Agents, MCP]
description: "Explore the new GitHub Copilot SDK in technical preview. Learn how to embed agentic AI workflows into any application using Node.js, Python, Go, or .NET."
---

# GitHub Copilot SDK: Building agents for any application

> Embed Copilot's production-tested agentic loop into your own applications—now available in technical preview for Python, TypeScript, Go, and .NET.

![alt text](<images/001.01 title.png>)

## Table of contents

- [Introduction](#introduction)
- [What is the GitHub Copilot SDK?](#what-is-the-github-copilot-sdk)
- [Key capabilities](#key-capabilities)
- [Architecture overview](#architecture-overview)
- [Getting started](#getting-started)
- [Implications for developers](#implications-for-developers)
- [Comparison with other agent frameworks](#comparison-with-other-agent-frameworks)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Building agentic AI workflows from scratch is hard. You need to manage context across turns, orchestrate tools and commands, route between models, integrate MCP servers, and think through permissions, safety boundaries, and failure modes. Even before you reach your actual product logic, you've already built a small platform.

The **GitHub Copilot SDK**, announced on January 22, 2026, removes that burden. It takes the same agentic core that powers GitHub Copilot CLI and makes it available as a programmable layer you can embed in any application.

**What you'll learn:**
- What the GitHub Copilot SDK is and how it works
- Key capabilities and supported languages
- Architecture and integration patterns
- Practical implications for your development workflow
- How it compares to other agent frameworks

**Prerequisites:**
- Familiarity with GitHub Copilot concepts
- Basic understanding of agentic AI workflows
- Experience with at least one supported language (Node.js, Python, Go, or .NET)

## What is the GitHub Copilot SDK?

The GitHub Copilot SDK is a <mark>multi-platform SDK</mark> that exposes the same production-tested agent runtime behind GitHub Copilot CLI as a programmable interface. Instead of building your own orchestration layer, you can embed Copilot's agentic loop directly into your applications.

**Think of it as an execution platform** where you:
- Define agent behavior and domain-specific tools
- Let Copilot handle planning, tool invocation, file edits, and more
- Build on top of production-tested infrastructure

GitHub handles the complex parts:
- **Authentication** — Seamless GitHub integration
- **Model management** — Access to multiple AI models
- **MCP server integration** — Full Model Context Protocol support
- **Chat sessions and streaming** — Real-time conversational AI
- **Context management** — Intelligent context compaction and infinite sessions

## Key capabilities

### Multi-language support

The SDK is available in four languages, each with full feature parity:

| Language | Package | Installation |
|----------|---------|--------------|
| **Node.js / TypeScript** | `@github/copilot-sdk` | `npm install @github/copilot-sdk` |
| **Python** | `github-copilot-sdk` | `pip install github-copilot-sdk` |
| **Go** | `github.com/github/copilot-sdk/go` | `go get github.com/github/copilot-sdk/go` |
| **.NET** | `GitHub.Copilot.SDK` | `dotnet add package GitHub.Copilot.SDK` |

### Agentic workflow features

The SDK inherits all capabilities from Copilot CLI:

- **Persistent memory** — Sessions maintain context across interactions
- **Intelligent compaction** — Automatic context optimization for long sessions
- **Custom agents and skills** — Define your own agents with specialized behaviors
- **Full MCP support** — Integrate Model Context Protocol servers
- **Async task delegation** — Delegate tasks to run asynchronously
- **Multi-model routing** — Choose different models for explore, plan, and review workflows

### Default tools

By default, the SDK operates with the equivalent of `--allow-all`, enabling:

- File system operations
- Git operations
- Web requests
- Command execution

You can customize tool availability through SDK client options to enable or disable specific tools based on your security requirements.

### BYOK (Bring Your Own Key)

The SDK supports using your own encryption keys for data security, giving you control over credential management in enterprise scenarios.

## Architecture overview

The SDK uses a client-server architecture where your application communicates with the Copilot CLI server via JSON-RPC:

```
Your Application
       ↓
  SDK Client
       ↓ JSON-RPC
  Copilot CLI (server mode)
       ↓
  AI Models & Tools
```

The SDK manages the CLI process lifecycle automatically. Alternatively, you can connect to an external CLI server for more complex deployment scenarios.

### Quick code example (TypeScript)

```typescript
import { CopilotClient } from "@github/copilot-sdk";

// Initialize the client
const client = new CopilotClient();
await client.start();

// Create a session with your preferred model
const session = await client.createSession({
    model: "gpt-5",
});

// Send prompts and receive streaming responses
await session.send({ prompt: "Hello, world!" });
```

This simple example demonstrates the core pattern:
1. Create a client instance
2. Start the client (initializes the CLI server)
3. Create a session with model configuration
4. Send prompts and handle responses

## Getting started

### Prerequisites

1. **GitHub Copilot subscription** — Required (free tier available with limited usage)
2. **Copilot CLI** — Must be installed separately; the SDK communicates with it in server mode
3. **Supported runtime** — Node.js, Python, Go, or .NET SDK

### Installation steps

1. **Install Copilot CLI** following the [official installation guide](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli)

2. **Install your preferred SDK:**

   ```bash
   # Node.js
   npm install @github/copilot-sdk

   # Python
   pip install github-copilot-sdk

   # Go
   go get github.com/github/copilot-sdk/go

   # .NET
   dotnet add package GitHub.Copilot.SDK
   ```

3. **Review the documentation** in the [SDK repository](https://github.com/github/copilot-sdk) for language-specific examples and API references.

### Billing model

SDK usage follows the same billing model as Copilot CLI:
- Each prompt counts toward your **premium request quota**
- Enterprise and individual plans have different quotas
- For details, see [Requests in GitHub Copilot](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## Implications for developers

### What changes for you?

1. **Reduced complexity** — No need to build your own agent orchestration layer
2. **Faster time-to-market** — Leverage production-tested infrastructure immediately
3. **Multi-platform flexibility** — Build once, deploy with your preferred language
4. **Enterprise-ready** — BYOK support and GitHub authentication integration

### Use cases from early adopters

GitHub's internal teams have already used the SDK to build:

| Use Case | Description |
|----------|-------------|
| **YouTube chapter generators** | Automated video content analysis and chapter creation |
| **Custom GUIs for agents** | Rich interfaces built on top of agentic workflows |
| **Speech-to-command workflows** | Voice-controlled desktop applications |
| **AI-powered games** | Interactive games with AI opponents |
| **Summarization tools** | Document and content summarization services |

### Best practices for getting started

1. **Start with a single task** — Define one clear goal like updating files, running commands, or generating structured output
2. **Let Copilot plan** — Provide domain-specific tools and constraints; let the SDK handle execution planning
3. **Iterate on tool definitions** — Refine your custom tools based on agent behavior
4. **Monitor and audit** — Track usage for billing and security purposes

## Comparison with other agent frameworks

The GitHub Copilot SDK occupies a unique position in the agent framework landscape:

| Aspect | GitHub Copilot SDK | M365 Agents SDK | Custom LangChain/Semantic Kernel |
|--------|-------------------|-----------------|----------------------------------|
| **Orchestration** | Built-in (Copilot CLI) | Your choice | Build yourself |
| **Model access** | Via Copilot subscription | Your models | Your models |
| **MCP support** | Full, built-in | Limited | Manual integration |
| **Authentication** | GitHub-managed | Your implementation | Your implementation |
| **Target platform** | Any app | M365 ecosystem | Any app |
| **Maturity** | Technical preview | Generally available | Varies |

### When to use GitHub Copilot SDK

- You want production-tested agentic infrastructure
- You're already in the GitHub ecosystem
- You need multi-model routing and MCP support
- You want to minimize infrastructure work

### When to consider alternatives

- You need to run fully offline without GitHub connectivity
- You require complete control over model selection and hosting
- You're building specifically for Microsoft 365 integration (consider M365 Agents SDK)
- You're already invested in another orchestration framework

## Conclusion

The GitHub Copilot SDK represents a significant shift in how developers can build AI-powered applications. By exposing the battle-tested agentic loop from Copilot CLI as a programmable SDK, GitHub has lowered the barrier to building sophisticated agent-based applications.

### Key takeaways

- **Multi-language support** — Node.js, Python, Go, and .NET all supported
- **Production infrastructure** — Leverage the same engine powering Copilot CLI
- **Full MCP integration** — Model Context Protocol servers work out of the box
- **Custom extensibility** — Define your own agents, skills, and tools
- **Technical preview status** — Not yet production-ready; expect changes

### Next steps

1. **Try the SDK** — Visit [github/copilot-sdk](https://github.com/github/copilot-sdk) and run the starter examples
2. **Review the cookbook** — Explore practical recipes for common patterns
3. **Join the community** — Report issues and feature requests on GitHub
4. **Monitor for GA** — Track the repository for production-readiness announcements

### Related articles in this workspace

- [How GitHub Copilot uses Markdown and prompt folders](../../03.00-tech/05.02-prompt-engineering/02-getting-started/01.00-how_github_copilot_uses_markdown_and_prompt_folders.md)
- [Understanding MCP on Windows](../../02.00-events/202506-build-2025/brk-breakout-sessions/brk229-unlock-agents-for-your-apps-using-mcp-on-windows/readme.sonnet4.md)
- [VS Code v1.107 Release Notes Analysis](../20251224-vscode-v1.107-release/02-readme.sonnet4.md)

## References

### Official documentation

**[Build an agent into any app with the GitHub Copilot SDK](https://github.blog/news-insights/company-news/build-an-agent-into-any-app-with-the-github-copilot-sdk/)** 📘 [Official]  
The announcement blog post from GitHub's Chief Product Officer, Mario Rodriguez. Covers the motivation behind the SDK, key features, and how it builds on Copilot CLI. Essential reading for understanding the product vision.

**[GitHub Copilot SDK Repository](https://github.com/github/copilot-sdk)** 📘 [Official]  
The official SDK repository containing setup instructions, starter examples, and SDK references for all four supported languages. The primary resource for getting started with development.

**[Copilot CLI Installation Guide](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli)** 📘 [Official]  
Official documentation for installing the Copilot CLI, which is a prerequisite for using the SDK. Includes platform-specific instructions and troubleshooting guidance.

**[GitHub Copilot Pricing](https://github.com/features/copilot#pricing)** 📘 [Official]  
Current pricing information for GitHub Copilot subscriptions, including the free tier with limited usage that's available for SDK development and testing.

**[Copilot Requests Documentation](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)** 📘 [Official]  
Explains how billing works for Copilot usage, including premium request quotas that apply to SDK usage. Important for understanding cost implications.

### Community resources

**[Awesome Copilot - SDK Instructions](https://github.com/github/awesome-copilot/blob/main/collections/copilot-sdk.md)** 📗 [Verified Community]  
Curated instructions for using Copilot to accelerate SDK development. Part of GitHub's official awesome-copilot collection.

**[SDK Cookbook](https://github.com/github/copilot-sdk/blob/main/cookbook/README.md)** 📘 [Official]  
Practical recipes for common tasks across all supported languages. Includes real-world patterns and integration examples.

**[SDK Samples](https://github.com/github/copilot-sdk/blob/main/samples/README.md)** 📘 [Official]  
Video walkthroughs and sample projects demonstrating SDK capabilities. Useful for visual learners and hands-on exploration.

<!-- 
---
validations:
  grammar:
    last_run: null
    model: null
    outcome: null
    issues_found: 0
  
  readability:
    last_run: null
    model: null
    outcome: null
    flesch_score: null
    grade_level: null
  
  understandability:
    last_run: null
    model: null
    outcome: null
    target_audience: null
  
  structure:
    last_run: null
    model: null
    outcome: null
    has_toc: true
    has_introduction: true
    has_conclusion: true
    has_references: true
  
  facts:
    last_run: null
    model: null
    outcome: null
    claims_checked: 0
    sources_verified: 0
  
  logic:
    last_run: null
    model: null
    outcome: null
    flow_score: null

article_metadata:
  filename: "github-copilot-sdk-building-agents-for-any-application.md"
  created: "2026-01-24"
  last_updated: "2026-01-24"
  version: "1.0"
  status: "draft"
  word_count: 1650
  reading_time_minutes: 8
  primary_topic: "GitHub Copilot SDK"

cross_references:
  related_articles:
    - "03.00-tech/05.02-promptEngineering/01.00 how_github_copilot_uses_markdown_and_prompt_folders.md"
    - "02.00-events/202506-build-2025/BRK - Breakout Sessions/BRK229 Unlock agents for your apps using MCP on Windows/readme.sonnet4.md"
    - "01.00-news/20251224-vscode-v1.107-release/02-readme.sonnet4.md"
  series: null
  prerequisites: null
---
-->
