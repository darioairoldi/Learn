# ODFP957: Sentry + GitHub Copilot Integration for AI-Powered Debugging

**Session Date:** May 19-22, 2025  
**Duration:** ~15 minutes  
**Venue:** Microsoft Build 2025  
**Speakers:** Cody De Arkland (Head of Developer Experience, Sentry)  
**Link:** [Session ODFP957](https://build.microsoft.com/en-US/sessions/ODFP957) 

## Table of Contents

1. [Introduction to AI-Powered Debugging Workflow](#1-introduction-to-ai-powered-debugging-workflow)
2. [Sentry-Copilot Integration Demonstration](#2-sentry-copilot-integration-demonstration)
   - 2.1. [Setting Up the Demo Environment](#21-setting-up-the-demo-environment)
   - 2.2. [Feature Flag Activation and Issue Detection](#22-feature-flag-activation-and-issue-detection)
   - 2.3. [Copilot Commands and Issue Management](#23-copilot-commands-and-issue-management)
3. [Root Cause Analysis with Seer AI Agent](#3-root-cause-analysis-with-seer-ai-agent)
   - 3.1. [Autofix Feature Overview](#31-autofix-feature-overview)
   - 3.2. [Interactive Debugging Process](#32-interactive-debugging-process)
   - 3.3. [Solution Generation and Code Analysis](#33-solution-generation-and-code-analysis)
4. [GitHub Integration and Pull Request Automation](#4-github-integration-and-pull-request-automation)
   - 4.1. [Automated Code Fix Generation](#41-automated-code-fix-generation)
   - 4.2. [Pull Request Creation Workflow](#42-pull-request-creation-workflow)
5. [Developer Workflow Philosophy and Future Vision](#5-developer-workflow-philosophy-and-future-vision)

---

## 1. Introduction to AI-Powered Debugging Workflow

**Timeframe:** 00:00:00 - 00:02:30  
**Duration:** 2m 30s  
**Speaker:** Cody De Arkland

Cody De Arkland introduces the session's core focus on revolutionizing debugging workflows through AI integration. He emphasizes Sentry's commitment to enhancing developer experience by combining GitHub Copilot with Sentry's error monitoring capabilities.

### Key Concepts Discussed

- **Developer Experience Philosophy**: Focus on streamlining debugging workflows for modern development teams
- **AI Integration Strategy**: Leveraging GitHub Copilot to bring Sentry's contextual information directly into the IDE
- **Workflow Efficiency**: Reducing context switching between debugging tools and development environments

The session establishes the "vibe code" era premise - where more developers are building (and breaking) applications than ever before, necessitating more intelligent debugging solutions.

---

## 2. Sentry-Copilot Integration Demonstration

**Timeframe:** 00:02:30 - 00:08:45  
**Duration:** 6m 15s  
**Speaker:** Cody De Arkland

### 2.1. Setting Up the Demo Environment

**Timeframe:** 00:02:30 - 00:03:15  
**Duration:** 45s

Cody demonstrates the "Unborked marketplace" application, showing a functioning e-commerce cart system that serves as the testing ground for the debugging workflow demonstration.

### 2.2. Feature Flag Activation and Issue Detection

**Timeframe:** 00:03:15 - 00:04:30  
**Duration:** 1m 15s

The demonstration shows how enabling the "GOODS_PRODUCTQUERY" feature flag through Sentry's toolbar immediately introduces application errors, specifically problems with the products backend communication.

### 2.3. Copilot Commands and Issue Management

**Timeframe:** 00:04:30 - 00:08:45  
**Duration:** 4m 15s

Key features demonstrated:

- **@sentry Command Integration**: Using "@sentry" in VS Code Copilot to access Sentry tools
- **Issue Listing**: "list all issues in the unborked project" command functionality
- **Detailed Issue Analysis**: "tell me more about issue 1" for comprehensive error context
- **Bidirectional Workflow**: Copying Sentry context into Copilot for local debugging

The integration allows developers to:

- Pull down issues from specific projects
- Get detailed issue information including transactions
- Create GitHub issues linked to Sentry issues
- Resolve issues directly from the IDE

---

## 3. Root Cause Analysis with Seer AI Agent

**Timeframe:** 00:08:45 - 00:12:30  
**Duration:** 3m 45s  
**Speaker:** Cody De Arkland

### 3.1. Autofix Feature Overview

**Timeframe:** 00:08:45 - 00:10:00  
**Duration:** 1m 15s

Seer, Sentry's AI agent, performs comprehensive analysis by collecting:

- **Traces and Spans**: Understanding communication flow patterns
- **GitHub Integration**: Analyzing recent commits and file changes
- **Stack Traces**: Pinpointing exact code locations of problems
- **Database Query Analysis**: Examining failed database interactions (Neon Postgres in this case)

### 3.2. Interactive Debugging Process

**Timeframe:** 00:10:00 - 00:11:15  
**Duration:** 1m 15s

Key interactive features:

- **Root Cause Validation**: Ability to mark findings as invalid or irrelevant
- **Real-time Feedback**: Interactive chat interface for refining analysis
- **Solution Prioritization**: AI evaluates multiple potential solutions and recommends the best approach

### 3.3. Solution Generation and Code Analysis

**Timeframe:** 00:11:15 - 00:12:30  
**Duration:** 1m 15s

Seer's solution evaluation process considers:

1. **Feature Flag Disabling**: Quick fix but not desirable for testing
2. **Database Table Creation**: Potentially over-engineered solution
3. **Code Modification**: Preferred solution to use correct database table
4. **Feature Transition Implementation**: Long-term stability improvements

The AI correctly identifies that changing the SQL query from 'goods' table to 'product' table resolves the core issue.

---

## 4. GitHub Integration and Pull Request Automation

**Timeframe:** 00:12:30 - 00:14:45  
**Duration:** 2m 15s  
**Speaker:** Cody De Arkland

### 4.1. Automated Code Fix Generation

**Timeframe:** 00:12:30 - 00:13:30  
**Duration:** 1m 00s

Autofix generates comprehensive code changes:

- **SQL Query Updates**: Modifying productQuery.ts to select from correct table
- **Logging Improvements**: Updating log messages to reflect accurate table names  
- **Error Handling**: Cleaning up spans and error catches
- **Markdown Export**: Option to copy solutions for manual implementation in Copilot

### 4.2. Pull Request Creation Workflow

**Timeframe:** 00:13:30 - 00:14:45  
**Duration:** 1m 15s

The automated workflow includes:

- **Direct PR Creation**: Sentry can create GitHub pull requests automatically
- **Code Review Ready**: Generated changes are immediately available for review
- **Integration Flexibility**: Choice between automated PR creation or manual implementation
- **Complete Change Tracking**: All modifications clearly documented in the PR

---

## 5. Developer Workflow Philosophy and Future Vision

**Timeframe:** 00:14:45 - 00:15:30  
**Duration:** 45s  
**Speaker:** Cody De Arkland

### Core Principles

- **Workflow Flexibility**: Supporting both IDE-centric and platform-centric debugging approaches
- **Context Preservation**: Maintaining rich error context throughout the debugging process  
- **AI-Human Collaboration**: Balancing automated solutions with developer oversight
- **Integrated Toolchain**: Seamless integration between Sentry, GitHub, and VS Code

### Future Vision

- **Multiple Debugging Pathways**: Supporting diverse developer preferences and workflows
- **Enhanced AI Capabilities**: Continued improvement in root cause analysis accuracy
- **Broader Integration**: Expanding compatibility with additional development tools and platforms

---

## References

### 1. Sentry Documentation

**Link:** [https://docs.sentry.io/](https://docs.sentry.io/)  
**Relevance:** Official documentation for Sentry's error monitoring and debugging capabilities. Essential for understanding the platform's features, integrations, and best practices discussed in the session.

### 2. GitHub Copilot Extensions

**Link:** [https://docs.github.com/en/copilot/building-copilot-extensions](https://docs.github.com/en/copilot/building-copilot-extensions)  
**Relevance:** Technical documentation for building GitHub Copilot extensions like the Sentry integration demonstrated. Provides developers with the framework for creating similar AI-powered debugging tools.

### 3. Sentry GitHub Integration Guide

**Link:** [https://docs.sentry.io/product/integrations/source-code-mgmt/github/](https://docs.sentry.io/product/integrations/source-code-mgmt/github/)  
**Relevance:** Specific documentation for setting up Sentry-GitHub integration, enabling the automated PR creation and repository analysis features shown in the demo.

### 4. VS Code Extensions Development

**Link:** [https://code.visualstudio.com/api](https://code.visualstudio.com/api)  
**Relevance:** Microsoft's official guide for VS Code extension development, relevant for understanding how the Sentry-Copilot integration works within the VS Code environment.

### 5. AI-Powered Debugging Research

**Link:** [https://arxiv.org/abs/2301.05591](https://arxiv.org/abs/2301.05591)  
**Relevance:** Academic research on AI applications in software debugging, providing theoretical background for the practical implementations demonstrated with Seer and Autofix.

### 6. Feature Flags Best Practices

**Link:** [https://launchdarkly.com/blog/feature-flag-best-practices/](https://launchdarkly.com/blog/feature-flag-best-practices/)  
**Relevance:** Best practices for feature flag implementation and debugging, contextualizing the GOODS_PRODUCTQUERY feature flag scenario used in the demonstration.

### 7. Database Error Monitoring

**Link:** [https://neon.tech/docs/guides/monitoring](https://neon.tech/docs/guides/monitoring)  
**Relevance:** Neon Postgres monitoring documentation, relevant to the database query debugging scenario demonstrated in the session.

### 8. Microsoft Build 2025 Session Catalog

**Link:** [https://build.microsoft.com/sessions](https://build.microsoft.com/sessions)  
**Relevance:** Complete catalog of Microsoft Build 2025 sessions, providing context for this presentation within the broader conference themes of AI integration and developer productivity.
