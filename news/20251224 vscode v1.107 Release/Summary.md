---
title: "Recording Summary: VS Code v1.107 Release Live Stream"
author: "Dario Airoldi"
date: "2025-12-24"
categories: [recording, vscode, release]
description: "Summary of VS Code v1.107 release livestream covering agentic experiences, model management, MCP updates, and SQL Python driver"
---

# Session Summary: VS Code v1.107 Release Live Stream

**Recording Date:** 2025-12-23  
**Summary Date:** 2025-12-24  
**Summarized By:** Dario Airoldi  
**Recording Link:** YouTube VS Code Channel  
**Duration:** 90 minutes  
**Speakers:** Olivia Guzzardo McVicker (VS Code Advocate), Kai Maetzel (Engineering Manager), Brigit Murtaugh (Product Manager), Logan Ramos (Engineer), Celina Hanouti (Hugging Face), Connor Peet (Engineer), David Levy (SQL Server Product Manager)  

![alt text](<images/001.01 session title.png>)

---

## Executive Summary

The VS Code v1.107 release livestream showcased the final release of 2024, highlighting major advances in AI-powered development workflows.  
The team demonstrated:  
- <mark>unified agent experiences</mark> across local, background, and cloud sessions, 
- <mark>improved model management</mark> with <mark>bring-your-own-key</mark> support,  
- <mark>enhanced MCP (Model Context Protocol) capabilities</mark>,  
- and the general availability of <mark>Microsoft's SQL Python driver</mark>.

**Note:** Update 1.107.1 (released shortly after) significantly improved the agent sessions experience with side-by-side view defaults, input-required markers, and workspace change copying support.

## Table of Contents

- 🎯 [Topic 1: Year in Review and v1.107 Highlights](#topic-1-year-in-review-and-v1107-highlights)
- 🤖 [Topic 2: Unified Agentic Experience](#topic-2-unified-agentic-experience)
- 🧠 [Topic 3: Model Management and Bring Your Own Key](#topic-3-model-management-and-bring-your-own-key)
- 🔌 [Topic 4: HuggingFace Integration](#topic-4-huggingface-integration)
- 🛠️ [Topic 5: MCP Updates and New Features](#topic-5-mcp-updates-and-new-features)
- 🐍 [Topic 6: SQL Python Driver GA Release](#topic-6-sql-python-driver-ga-release)

---

### [01:44] Topic 1: Year in Review and v1.107 Highlights

**Speaker:** Kai Maetzel (Engineering Manager)

**Key Points:**
- 2024 was transformative - started without any <mark>agentic experience</mark>, now have full agent mode with <mark>local</mark>, <mark>background</mark>, and <mark>cloud execution</mark>
- <mark>Open-sourced all AI capabilities</mark> to align with VS Code's open-source principles
- Major progress on customization: <mark>bring-your-own-key</mark>, <mark>Copilot instructions</mark>, <mark>agent.md files</mark>, <mark>Claude skills support</mark>
- <mark>Next Edit Suggest (NES)</mark> introduced and continuously refined with language server integration
- <mark>MCP has the most complete client implementation</mark> of any tool
- Team self-hosts on VS Code Insiders daily to catch issues early

**Quotes:**
> "It's like mindblowing as a year, right? We didn't even have any agentic experience at the beginning of the year, right? We didn't have NES, you know, next edit suggest and tap tap tap."

**Resources mentioned:**
- Monthly iteration plans published by Kai on VS Code
- VS Code Insiders for daily builds

### [16:55] Topic 2: Unified Agentic Experience

**Speaker:** Brigit Murtaugh (Product Manager)

**Key Points:**
- New <mark>**Agent HQ**</mark> interface shows all sessions (local, background, cloud) in one unified view
- <mark>Recent sessions</mark> list with filtering, archiving, and search capabilities
- <mark>Sessions can continue in background</mark> without keeping VS Code focused
- <mark>Work trees provide isolation</mark> for background agents to avoid conflicts with local changes
- <mark>Read/unread status markers</mark> help track work-in-progress sessions
- <mark>Seamless delegation between agent types</mark>: local → background → cloud
- <mark>**Planning mode**</mark> generates plans that can be delegated to agents for implementation
- <mark>**Continue in**</mark> option available from multiple entry points:
  - Chat view "Continue in" button
  - Plan agent "Start Implementation" button  
  - Untitled prompt file "Continue in" button
- <mark>**Worktree workflow**</mark> for background agents:
  - Automatic Git worktree creation for isolation
  - Review and merge changes after completion
  - Direct apply action to integrate changes into main workspace

**Demo Summary:**
Demonstrated creating multiple concurrent agent sessions working on a dev containers website. Showed local agent planning improvements, background agent using isolated work trees, and delegating work to cloud agents that automatically create PRs.

**v1.107.1 Improvements:**
- Agent sessions view now defaults to side-by-side layout
- Sessions requiring user input are clearly marked
- Support for copying workspace changes when creating background sessions
- Chat prompt is not cleared when creating a new session
- Tool calls in cloud sessions are collapsed by default

**Resources mentioned:**
- GitHub Pull Request extension for enhanced PR integration
- Agent HQ interface at Universe announcement
- AI Dev Days session by Josh Valdo on unified agent experience

### [29:30] Topic 3: Model Management and Bring Your Own Key

**Speaker:** Logan Ramos (Engineer)

**Key Points:**
- Model picker now supports hiding unused models for cleaner interface
- Bring-your-own-key (BYOK) supports multiple providers: Cerebras, OpenRouter, Ollama, and more
- Models display context window size, tool calling, and vision support
- Filtering by capability (vision, tools) helps select appropriate models
- BYOK models don't consume GitHub Copilot quota but still require active subscription
- Background processes use GPT-4o Mini for query refinement without counting against usage
- Full prompt logging available in output channel for debugging and optimization

**Demo Summary:**
Showed adding Cerebras API key, selecting models with different capabilities, and building a complete VS Code product website using DeepSeek v3.2 via Cerebras - all in real-time with impressive speed.

#### Language Models Editor

New centralized interface for managing all available language models:

- **Model visibility toggling** - Hide unused models from picker for cleaner interface
- **Add models from installed providers** - Activate additional providers without leaving editor
- **Search and filter capabilities**:
  - Text search with highlighting
  - Provider filter: `@provider:"OpenAI"`
  - Capability filters: `@capability:tools`, `@capability:vision`, `@capability:agent`
  - Visibility filter: `@visible:true/false`
- **Grouping options** - Organize by provider or visibility status
- **Model information** - Context size, capabilities, billing details at a glance

Access via model picker in chat or Command Palette: "Chat: Manage Language Models"

**Quotes:**
> "Each time you add a model to copilot, you take the pool of GPUs that are available and have to divide them... that makes it really really hard for us to provide everything."

**Resources mentioned:**
- GitHub Copilot Free tier for getting started
- Cerebras for ultra-fast inference
- Model provider marketplace

### [39:28] Topic 4: HuggingFace Integration

**Speaker:** Celina Hanouti (Hugging Face Engineer)

**Key Points:**
- <mark>HuggingFace Inference Provider</mark> extension brings state-of-the-art open-weights models to VS Code
- One API provides access to multiple inference providers (Cerebras, Groq, Fireworks, etc.)
- No vendor lock-in - automatic provider selection for cost and speed optimization
- "Fastest" mode selects highest-performance provider; "cheapest" mode optimizes for cost
- Can filter models by provider to see all models served by specific backends
- Typical feature implementation costs ~20-30 cents with models like GLM-4.6
- Extension releases independently of VS Code for faster iteration

**Demo Summary:**
Installed HuggingFace provider extension, authenticated with access token, and used GLM-4.6 to implement a real GitHub issue for the HuggingFace Hub Python SDK using local agent mode.

**Quotes:**
> "The extension being outside of VS Code allows us to iterate faster add new features integrations bug fixes and all of that without relying on on VS Code releases."

**Resources mentioned:**
- [HuggingFace Inference Provider Extension](https://marketplace.visualstudio.com/items?itemName=huggingface.huggingface-vscode)
- HuggingFace Hub repository (open source)
- Free HuggingFace account with credits for testing

### [50:19] Topic 5: MCP Updates and New Features

**Speaker:** Connor Peet (Engineer)

**Key Points:**
- New MCP registry accessible via <mark>`@mcp` search</mark> in extensions view
- One-click installation of curated MCP servers (<mark>Playwright</mark>, <mark>GitHub</mark>, <mark>Wikipedia</mark>, etc.)
- Automatic server startup on first chat message
- <mark>**Latest MCP spec**</mark> (1.0 anniversary release) <mark>fully supported in VS Code</mark>
- **<mark>Custom icons</mark>** for servers and tools improve visual identification
- **<mark>URL mode elicitation</mark>** allows servers to request input via web interfaces
- **<mark>Sampling</mark>** enables MCP servers to make their own LLM requests on behalf of users
- **<mark>Tasks</mark>** provide durable, resumable operations that survive network issues and crashes
- Resources can be returned from tools and downloaded directly

**Demo Summary:**
Built a custom MCP server for website design that accepted sketch input via web interface, configured settings through elicitation, and used sampling to generate content autonomously - all with new spec features.

#### GitHub MCP Server (Preview)

Built-in GitHub remote MCP server now provided by GitHub Copilot Chat extension:

- **Seamless integration** - Reuses existing GitHub authentication, no additional prompts
- **Alignment with other harnesses** - Consistent with Copilot CLI and Cloud Agent
- **Enterprise support** - Transparent GHE.com endpoint support
- **Customization settings**:
  - `github.copilot.chat.githubMcpServer.toolsets` - Configure available tools (default, workflows, etc.)
  - `github.copilot.chat.githubMcpServer.readonly` - Force read-only operations
  - `github.copilot.chat.githubMcpServer.lockdown` - Additional security controls

Enable with: `github.copilot.chat.githubMcpServer.enabled: true` (Preview feature)

**Resources mentioned:**
- <mark>MCP Registry</mark> (GitHub curated version)
- Open source public MCP registry
- AI Dev Days session with Tyler for deep dive
- GitHub issue tracking tool-calling in sampling (coming soon)
- GitHub MCP Server documentation for remote toolsets

### [Multiple] Topic 7: Chat Experience Improvements

**Speakers:** Various (Product Team)

**Key Points:**

Major enhancements to chat interaction quality and security:

#### Security and Content Fetching
- **URL and domain auto-approval** - Two-step process:
  1. Approve domain contact (respects Trusted Domains feature)
  2. Review fetched content before use (prevents prompt injection)
- **Robust fetch tool** - Handles dynamic JavaScript content:
  - Works with Single-Page Applications (SPAs)
  - Waits for JavaScript execution before retrieving content
  - Returns actual browser-rendered content, not just HTML skeleton
- **Text Search in ignored files** - Search `node_modules`, build outputs with hints to agent

#### Terminal Integration
- **Rich terminal output** - Full xterm.js rendering in chat:
  - ANSI color support with terminal theme
  - Preserved output even after terminal exit
  - Screen reader support via Accessible View (Alt+F2)
- **Command metadata** - Hover shows start time, duration, exit code
- **Session-wide approval** - "Allow All Commands in this Session" option for trusted workflows
- **Keyboard shortcuts**:
  - Focus recent terminal: Ctrl+Shift+Alt+T
  - Toggle expansion: Ctrl+Shift+Alt+O

#### User Experience
- **Chat view appearance**:
  - Title control showing current chat
  - Optional welcome banner (configure via settings)
  - Restore previous session on restart (configurable)
- **Sensitive file diffs** - Visual diff preview for `settings.json`, `package.json` edits before approval
- **Collapsible sections** (Experimental):
  - Tool calls collapsed by default
  - AI-generated titles for reasoning/tools sections
  - Reduces visual noise for complex agent interactions

**Resources mentioned:**
- Chat tools documentation (URL approval, fetch, text search)
- Terminal commands in chat guide
- Sensitive files editing workflow

---

### [01:04:59] Topic 6: SQL Python Driver GA Release

**Speaker:** David Levy (SQL Server Product Manager)

**Key Points:**
- First <mark>first-party Python driver from Microsoft for SQL Server</mark>
- Single-line `pip install` with no dependencies makes sharing easy
- **Active Directory Default authentication** works on Mac via VS Code token sharing
- No need for repeated authentication prompts - integrates with Azure Resources extension
- Context managers (`with` statements) handle connection cleanup automatically
- Works with UV tool for virtual environment management
- UV automatically creates venv and installs dependencies on first `uv run` command
- Jupyter notebook support ideal for runbooks and troubleshooting documentation

**Roadmap Features:**
- **BCP streaming** for bulk data loading (coming in future release)
- **SQL Alchemy compatibility** - Near-complete, final fixes shipping soon
- **Streamlit integration** - Quick start available for rapid prototyping

**Demo Summary:**
Ran Python script using UV that automatically created virtual environment, connected to Azure SQL via Active Directory default auth, and displayed results in rich tables. Then showed Jupyter notebook creating Pandas dataframes and visualizations from SQL queries.

**Quotes:**
> "We spent a lot of time doing making this work. The trick is you need to be logged in as your entry authentication account... you use an extension like Azure resources, you add that extension, you connect it to your Azure account and then you have VS Code authentication."

**Resources mentioned:**
- [aka.ms/mssql-python](https://aka.ms/mssql-python) - Main landing page
- GitHub repository with quick starts, documentation wiki
- UV tool for Python package management
- Streamlit quick start for rapid prototyping

## Main Takeaways

1. **Unified Agent Architecture**
   - VS Code now provides seamless transitions between local, background (work tree isolated), and cloud (PR-based) agent execution
   - Enables new workflows where planning, implementation, and PR creation happen across different execution contexts
   - This represents a fundamental shift in how developers interact with AI assistants

2. **Model Democratization**
   - Bring-your-own-key and provider extensions (HuggingFace) give developers access to cutting-edge models immediately
   - Cost and speed optimization features help navigate the growing model landscape
   - VS Code maintains open-source principles while providing commercial GitHub Copilot integration

3. **MCP as Standard Protocol**
   - MCP 1.0 maturity brings production-ready features (tasks, sampling, elicitation)
   - VS Code's complete implementation positions it as the reference MCP client
   - Custom MCP servers enable domain-specific AI capabilities without core product changes

4. **Developer Experience Focus**
   - Authentication integration (Azure resources token sharing for SQL)
   - Virtual environment automation (UV integration)
   - Visual polish (custom icons, thinking token display, progress notifications)

## Questions Raised

1. **Q:** Does the team use VS Code to build VS Code?
   - **A:** Yes, entire team runs VS Code Insiders non-stop with pre-release extensions for continuous self-hosting
   - **Status:** Answered

2. **Q:** Do BYOK models count against GitHub Copilot quota?
   - **A:** No, but active Copilot subscription still required for background operations (commit messages, rename suggestions) that use GPT-4o Mini
   - **Status:** Answered

3. **Q:** Can custom MCP servers use tools from other MCP servers?
   - **A:** Not yet - sampling with tool calls is in the spec but not yet implemented in VS Code (coming in next release)
   - **Status:** Feature request tracked on GitHub

4. **Q:** Can BYOK models be used with cloud/background agents?
   - **A:** Yes, confirmed working with cloud agents; most users prefer local agents for interactive workflows
   - **Status:** Answered

## Action Items

- [ ] Watch AI Dev Days sessions for deeper dives - **Owner:** Community - **Due:** December 2024
- [ ] Explore MCP registry via `@mcp` search - **Owner:** Developers - **Due:** Immediate
- [ ] Try BYOK with Cerebras or HuggingFace - **Owner:** AI developers - **Due:** Ongoing
- [ ] Review SQL Python quick starts - **Owner:** Data developers - **Due:** Immediate

## Decisions Made

1. **MCP Registry Strategy**
   - **Rationale:** Balance between quality control and community openness during MCP maturity phase
   - **Impact:** Extension marketplace users get tested, reliable MCP servers

2. **Authentication Model for SQL Python Driver**
   - **Rationale:** Eliminate friction of repeated authentication prompts for developers on Mac/Linux
   - **Impact:** Cross-platform parity for Azure SQL development

## 📚 Resources and References

### Official Documentation

**[VS Code v1.107 Release Notes](https://code.visualstudio.com/updates/v1_107)** `[📘 Official]`  
Complete official release notes for VS Code v1.107 (November 2025 release). Includes all features demonstrated in livestream plus additional updates not covered in the recording, including v1.107.1 improvements. Essential reference for comprehensive feature list.

**[VS Code Agents Tutorial](https://code.visualstudio.com/docs/copilot/agents/agents-tutorial)** `[📘 Official]`  
Official tutorial for agent workflows covering local, background, and cloud agents. Demonstrates unified agent experience and delegation patterns shown in v1.107 release. Mentioned in release notes update 1.107.1.

**[VS Code Background Agents Documentation](https://code.visualstudio.com/docs/copilot/agents/background-agents)** `[📘 Official]`  
Official guide for using background agents with Git worktrees for isolation. Explains workflow for background agent creation, worktree management, and change application demonstrated in Topic 2.

**[VS Code Custom Agents Documentation](https://code.visualstudio.com/docs/copilot/customization/custom-agents)** `[📘 Official]`  
Comprehensive guide for defining custom agents using `.agent.md` files. Covers tool configuration, handoffs, and organizational sharing features mentioned in experimental features.

**[VS Code Language Models Documentation](https://code.visualstudio.com/docs/copilot/customization/language-models)** `[📘 Official]`  
Official guide for using language models in VS Code including BYOK providers, model management, and Language Models editor. Covers features demonstrated in Topic 3.

**[VS Code MCP Servers Documentation](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)** `[📘 Official]`  
Official documentation for configuring and using Model Context Protocol (MCP) servers in VS Code. Explains setup, toolsets, and integration patterns for MCP 1.0 features demonstrated in Topic 5.

**[Model Context Protocol Specification](https://modelcontextprotocol.io)** `[📘 Official]`  
Official MCP protocol specification including 2025-11-25 draft features (tasks, sampling, URL elicitation, custom icons). VS Code provides reference implementation as mentioned in Topic 5.

**[GitHub MCP Server Documentation](https://github.com/github/github-mcp-server/blob/main/docs/remote-server.md)** `[📘 Official]`  
Documentation for GitHub's remote MCP server including toolset configuration and permission requirements. Covers built-in GitHub MCP server preview feature from Topic 5.

**[Microsoft SQL Python Driver Documentation](https://aka.ms/mssql-python)** `[📘 Official]`  
Official landing page for first-party SQL Python driver including installation, authentication setup, UV integration, and code samples. All demos from Topic 6 available as starter projects.

**[VS Code Chat Tools Documentation](https://code.visualstudio.com/docs/copilot/chat/chat-tools)** `[📘 Official]`  
Guide for chat tools including URL approval workflow, fetch tool capabilities, and text search improvements. Covers security features from Topic 7.

**[VS Code Insiders](https://code.visualstudio.com/insiders/)** `[📘 Official]`  
Daily builds of VS Code with latest features. Used by entire VS Code team for self-hosting as mentioned in Topic 1. Required for testing unreleased features like MCP sampling with tool calls.

### Community Resources

**[HuggingFace Inference Provider Extension](https://marketplace.visualstudio.com/items?itemName=huggingface.huggingface-vscode)** `[📗 Verified Community]`  
Official extension from HuggingFace for using open-weights models (Cerebras, Groq, Fireworks providers) in VS Code Copilot Chat. Provides automatic cost/speed optimization demonstrated in Topic 4.

**[GitHub VS Code Repository](https://github.com/microsoft/vscode)** `[📘 Official]`  
Open-source VS Code repository including AI capabilities. All iteration plans published here (mentioned in Topic 1). Contains source code for features demonstrated in livestream.

**[GitHub Blog: Next Edit Suggestions Model Evolution](https://github.blog/ai-and-ml/github-copilot/evolving-github-copilots-next-edit-suggestions-through-custom-model-training/)** `[📗 Verified Community]`  
Official GitHub blog post detailing the new next edit suggestions model mentioned in release notes. Explains continuous improvements and custom model training approach.

### Session Materials

- **Recording:** YouTube VS Code Channel
- **AI Dev Days:** Additional sessions on unified agent experience (Josh Valdo) and MCP deep dive (Connor Peet, Tyler)

## Follow-Up Topics

Topics identified for deeper exploration:
1. **Custom Agents** - Development patterns, testing strategies, and deployment to cloud agents (teased for January 2025)
2. **Collaborative Planning** - Multi-user planning sessions with agents (teased for 2025)
3. **MCP Sampling with Tools** - Implementation timeline and SDK updates for custom servers
4. **SQL Alchemy Integration** - Final compatibility status and best practices when available
5. **BCP Streaming in Python** - Bulk data loading capabilities when released

## Next Steps

- Watch AI Dev Days sessions for deeper dives on unified agent experience and MCP
- Try BYOK with Cerebras or HuggingFace for access to latest models
- Explore MCP registry via `@mcp` search in extensions
- Review SQL Python quick starts at aka.ms/mssql-python
- Update to Insiders for early access to MCP sampling with tools
- Follow monthly iteration plans for custom agent development updates

## Related Content

**Series:** VS Code Release Live Streams (Final of 2024)

---

## Transcript Segments

<details>
<summary>Expand for key transcript excerpts</summary>

### [01:44] Kai on 2024 Transformation
```
It's like mindblowing as a year, right? When you think about it, we didn't even have 
any agentic experience at the beginning of the year, right? We we didn't have NES, 
you know, next edit suggest and tap tap tap, right? So, yeah, a lot of things have 
changed, right? And when you think about this, right, we started without now we 
actually at the, you know, we we have a really good agent experience now, right?
```

### [50:25] Connor on MCP Evolution
```
One thing that you see is um uh like recently we we improved how we deal with uh 
uh with resources. And so um um MCP tools uh can return resources which which you 
can like see attached now to the tool call and you can also download those. This 
just returned basically a like a a JSON blob here. But um I'll do more with that 
in a minute.
```

### [1:07:15] David on Python Driver Philosophy
```
We really emphasized on sharability. You know, being able to collaborate with your 
co-workers or share a script with business users. So, we made sure that our driver 
installs with a single line pip install makes it very very easy to share with other 
users. It also makes it very easy to deploy it.
```

</details>

---

*Recording Type: Release Stream / Technical Presentation*  
*Tags: vscode, ai, agents, mcp, python, sql, models, release-notes*  
*Status: Final*

<!-- 
---
validations:
  structure:
    last_run: null
    outcome: null
  consistency_review:
    status: "completed"
    last_run: "2024-12-24T15:30:00Z"
    model: "claude-sonnet-4.5"
    references_checked: 6
    references_valid: 6
    references_added: 8
    gaps_identified: 12
    gaps_addressed: 9
    change_summary: "Added v1.107.1 updates, Language Models Editor, GitHub MCP Server, Chat improvements section, expanded agent workflow details, updated references with classifications"
article_metadata:
  filename: 'Summary.md'
  created: '2024-12-24'
  session_date: '2024-12-23'
  duration_minutes: 90
  last_updated: "2024-12-24T15:30:00Z"
  version_history:
    - date: "2024-12-24"
      changes: "Comprehensive review and updates: v1.107.1 features, Language Models Editor, GitHub MCP Server, Chat improvements, expanded worktree workflow, classified references"
-->
