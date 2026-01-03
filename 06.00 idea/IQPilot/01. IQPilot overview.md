---
title: "IQPilot Overview: AI-Assisted Content Development Tool"
author: "Dario Airoldi"
date: "2025-11-22"
categories: [documentation, ai, tools]
description: "Introduction to IQPilot - a content development tool for creating, validating, maintaining, and evolving documentation, learning materials, and ideas with AI assistance"
---

# IQPilot Overview

## What is IQPilot?

**IQPilot** (Intelligence & Quality Pilot) is a content development tool that helps you create, validate, maintain, and evolve documentation, learning materials, and ideas.  
By seamlessly integrating with GitHub Copilot and VS Code, IQPilot provides AI-assisted quality checks, intelligent validation, and metadata management - all configurable to your specific editorial standards and content criteria.

Think of IQPilot as a quality assurance tool for written content - like ESLint for code quality, but for documentation quality.  
You write the content, IQPilot ensures it meets your standards.

## The Problem IQPilot Solves

### Before IQPilot

Content creators and technical writers typically face these challenges:

1. **Quality Inconsistency**: Different articles have varying levels of quality, structure, and completeness
2. **Manual Validation**: Grammar checks, readability analysis, and structure validation are manual and time-consuming
3. **Repetitive Work**: Every new article starts from scratch without consistent templates
4. **Repeated Validations**: Same checks run repeatedly, wasting AI calls and processing time with no memory of previous results
5. **Time intensive discovery of references**: Related articles aren't cross-referenced, making knowledge discovery difficult
6. **Time intensive discovery of information gaps**: Identifying missing information or gaps in logic requires manual review
7. **Time intensive analysis of connections and implications**: analysis of connections between concepts and their implications is manual and error-prone
8. **No Quality History**: No systematic way to track when articles were last validated or what issues were found
9. **Publication Anxiety**: No confidence that content is truly ready for publication

### After IQPilot

With IQPilot, content development becomes:

- ✅ **Consistent Quality**: All content follows the same structure and quality standards - eliminating inconsistency
- ✅ **Automated Validation**: AI-powered checks for grammar, readability, structure, and completeness - no more manual validation
- ✅ **Template-Based Creation**: Pre-built templates for common content types - no more starting from scratch
- ✅ **Optimized AI Usage**: Validation results cached in metadata - checks run only when content changes, avoiding redundant AI calls
- ✅ **Instant Reference Discovery**: Automatic identification of related content and cross-references - no more manual searching
- ✅ **Automated Gap Analysis**: AI-powered detection of missing information and logical inconsistencies - instant feedback
- ✅ **Connection Intelligence**: Automatic analysis of concept relationships and implications - comprehensive understanding
- ✅ **Quality History Tracking**: Complete validation timeline and metrics stored with each article - know what was checked and when
- ✅ **Publication Confidence**: Comprehensive pre-publish checks ensure content meets all quality criteria - publish with certainty

## Core Philosophy

### Intelligence & Quality

The name "IQPilot" reflects two fundamental principles:

1. **Intelligence**: Leverages AI (GitHub Copilot) to understand content, provide context-aware suggestions, and automate complex validation tasks
2. **Quality**: Enforces configurable quality standards through systematic validation, ensuring content meets your specific requirements

### Content Agnostic & Location Independent

IQPilot is designed to work with **any content, anywhere**:

**Content Agnostic:**
- Works with technical documentation, learning materials, research notes, wikis, blogs, or any written content
- No assumptions about your domain, topic, or subject matter
- Adapts to your content through configuration, prompts, and instructions

**Location Independent:**
- ✅ GitHub repositories
- ✅ Local folders on your computer
- ✅ OneDrive/cloud storage folders
- ✅ Network shares
- ✅ Any location accessible from VS Code

**Specialization Through Context:**
- Generic validation tools work out-of-the-box for any content
- Add site-specific prompts and instructions for maximum effectiveness
- Configure editorial standards, style guides, and validation criteria
- Tailor validation rules to your audience and purpose

**Example:**
- Generic IQPilot → "Check grammar and readability"
- + Technical docs context → "Check grammar using technical writing standards, target developers"
- + Learning platform context → "Check grammar for clarity, target beginners, use simple language"
- + API documentation context → "Check grammar, ensure examples work, validate parameter descriptions"

### AI-Assisted, Not AI-Generated

IQPilot **assists** content creation rather than replacing human creativity:

- **Humans Create**: You write the content with your expertise and voice
- **AI Validates**: IQPilot checks quality, structure, and completeness
- **AI Suggests**: Provides recommendations for improvements
- **AI Maintains**: Keeps metadata synchronized automatically

## Three Pillars of IQPilot

### 1. Support for Content Development

IQPilot provides comprehensive tools for creating high-quality content:

**Content Creation:**
- Pre-built templates for common content types (articles, how-to guides, tutorials, API docs)
- Variable substitution for consistent document initialization
- Automatic metadata initialization with validation tracking
- Guided workflow from draft to publication

**Quality Assurance:**
- Grammar and spelling validation
- Readability analysis (Flesch score, grade level targeting)
- Structure validation (TOC, sections, references, heading hierarchy)
- Fact-checking prompts for technical accuracy
- Logic flow analysis to ensure coherent argumentation

**Content Analysis:**
- Gap analysis to identify missing information
- Related article discovery for cross-referencing
- Topic extraction and categorization
- Series validation for multi-article documentation

### 2. Support for Learning

IQPilot is specifically designed to support learning and knowledge development:

**Learning-Focused Features:**
- **Understandability Validation**: Ensures content is appropriate for target audience skill level
- **Concept Clarity Checks**: Verifies that technical concepts are explained clearly
- **Prerequisite Tracking**: Identifies and validates prerequisites for learning paths
- **Progressive Complexity**: Validates that content builds knowledge incrementally
- **Example Quality**: Ensures code examples are clear, working, and well-explained

**Knowledge Organization:**
- Series planning for creating learning paths
- Topic correlation to connect related concepts
- Prerequisites validation across article series
- Concept dependency tracking

**Accessibility:**
- Readability metrics ensure content is accessible to target audience
- Grade level targeting prevents content from being too simple or too complex
- Clear structure requirements improve scanability and comprehension

### 3. Support for Idea Development

IQPilot helps you develop and refine ideas systematically:

**Idea Capture:**
- Quick article templates for capturing ideas rapidly
- Recording summary templates for conference notes and talks
- Issue templates for documenting problems and solutions

**Idea Refinement:**
- Gap analysis prompts reveal missing pieces of your argument
- Logic analysis ensures your reasoning is sound
- Correlated topics help you discover connections between ideas

**Idea Evolution:**
- Validation history tracks how your ideas have evolved over time
- Cross-references show how ideas connect across your knowledge base
- Series planning helps you expand single ideas into comprehensive guides

## Key Innovations

### 1. Dual Metadata Architecture

**The Problem:** Without memory, AI validation tools would run the same checks repeatedly every time you ask "Is this article ready?" - wasting AI calls, time, and money.

**IQPilot's Solution:** Store validation results directly in each article as hidden metadata. When you ask for validation, IQPilot checks: "Was this already validated? Has content changed since last check?" Only run AI validation when actually needed.

**How It Works - Two Metadata Blocks:**

**Top YAML Block** (Document Properties):
```yaml
---
title: "Article Title"
author: "Author Name"
date: "2025-11-22"
---
```
- For site generators (Quarto, Jekyll, Hugo)
- Modified manually by you
- Visible in source and rendered output

**Bottom YAML Block** (Article Additional Metadata - Hidden):
```html
<!-- 
---
validations:
  grammar: { last_run: "2025-11-22", outcome: "passed" }
article_metadata:
  filename: "article.md"
  word_count: 2500
---
-->
```
- Wrapped in HTML comment - **invisible when rendered**
- Modified automatically by IQPilot after each validation
- Stores validation results, timestamps, quality metrics

**The AI Optimization:**

```
User: "Check grammar on this article"

Without Metadata:
→ Run full AI grammar check (costs tokens, takes time)
→ No memory of previous results
→ Same check repeated every time = wasted AI calls

With IQPilot Metadata:
→ Check metadata: "Grammar validated 2 hours ago, passed"
→ Check if content changed since then
→ If unchanged: "Grammar still valid ✓" (instant, no AI call)
→ If changed: Run AI check only on changed sections
```

**Benefits:**
- **Minimize AI Calls**: Run validations only when content actually changes
- **Focus AI Usage**: Spend AI resources on new content, not re-checking old content
- **Instant Feedback**: Previously validated content shows status immediately
- **Quality History**: Track when each validation ran and what was found
- **Self-Contained**: Everything travels with the article, no orphaned files
- **Invisible**: Metadata hidden from readers when article is rendered

### 2. MCP Protocol Integration

IQPilot uses the Model Context Protocol (MCP) for GitHub Copilot integration:

**What is MCP?**
- Standard protocol for AI tool invocation
- Direct communication between GitHub Copilot and IQPilot
- No manual command running required

**How It Works:**
```
GitHub Copilot → MCP Request → IQPilot Tools → Validation/Analysis → Results
```

**Available Tools:**
- 16 specialized tools for validation, content analysis, and workflow management
- Tools invokable directly from Copilot chat
- Structured JSON responses for consistent results

### 3. VS Code and File System Integration

**The Problem:** When you rename a file in VS Code, metadata with the old filename becomes incorrect. Manual updates are tedious and error-prone.

**IQPilot's Solution:** Automatic synchronization between VS Code and file system - IQPilot watches for changes and keeps metadata current without any manual intervention.

**How It Works:**

**Monitoring Multiple Sources:**
- **VS Code Events**: Save, open, close, rename, move
- **File System Events**: Changes made outside VS Code (Git operations, scripts, other editors)

**Intelligent Deduplication:**
- Same event can trigger from both sources (e.g., rename in VS Code → VS Code event + file system event)
- EventCoordinator deduplicates within 500ms window
- Ensures metadata updated once, not twice

**Automatic Updates:**
- File renamed → `article_metadata.filename` updated instantly
- Content saved → `article_metadata.last_updated` timestamp refreshed
- All automatic, no manual action required

## Use Cases

### 1. Technical Documentation Sites

**Perfect for:**
- Product documentation
- API reference guides
- Developer tutorials
- Technical knowledge bases

**IQPilot provides:**
- Consistent structure across all documentation
- Validation that code examples work
- Up-to-date cross-references between related docs
- Quality metrics for doc coverage

### 2. Learning Platforms & Courses

**Perfect for:**
- Online course content
- Tutorial series
- Educational blogs
- Training materials

**IQPilot provides:**
- Learning path validation (prerequisites, progression)
- Readability targeting for specific skill levels
- Understandability checks for complex concepts
- Series consistency validation

### 3. Internal Wikis & Knowledge Bases

**Perfect for:**
- Company internal documentation
- Team knowledge sharing
- Troubleshooting guides
- Best practices documentation

**IQPilot provides:**
- Standardized templates for consistency
- Search optimization through structured metadata
- Automatic linking of related content
- Quality gates before publication

### 4. Research Notes & Idea Development

**Perfect for:**
- Personal knowledge management
- Research paper drafts
- Idea exploration
- Conference notes and summaries

**IQPilot provides:**
- Quick capture templates
- Gap analysis for incomplete ideas
- Connection discovery between concepts
- Evolution tracking over time

### 5. Customer-Facing Content

**Perfect for:**
- Product wikis for customers
- Support documentation
- FAQ repositories
- User guides

**IQPilot provides:**
- Publish-ready quality checks
- Readability validation for non-technical audiences
- Fact-checking for accuracy
- Consistent formatting and structure

## Architecture Overview

### Component Layers

```
┌─────────────────────────────────────────┐
│         GitHub Copilot (AI)             │
│  Natural language interaction           │
└───────────────┬─────────────────────────┘
                │ MCP Protocol
┌───────────────▼─────────────────────────┐
│       IQPilot MCP Server (.NET)         │
│  • Tool Registry (16 tools)             │
│  • JSON-RPC Communication               │
└───────────────┬─────────────────────────┘
                │
    ┌───────────┼───────────┐
    │           │           │
┌───▼───┐  ┌───▼────┐  ┌──▼─────┐
│ Tools │  │Services│  │Watcher │
│ Layer │  │ Layer  │  │Service │
└───────┘  └────────┘  └────────┘
    │           │           │
    └───────────┴───────────┘
                │
┌───────────────▼─────────────────────────┐
│     File System (Markdown + YAML)       │
└─────────────────────────────────────────┘
```

### Key Components

1. **MCP Server**: Handles GitHub Copilot communication
2. **Tool Registry**: Manages 16 specialized tools
3. **Services Layer**: Core validation and metadata logic
4. **File Watcher**: Monitors file system for changes
5. **VS Code Extension**: Bridges editor events to IQPilot

## Universal Applicability

### Works with Any Content Type

IQPilot doesn't care what you're writing about:

- ✅ Technical documentation (APIs, SDKs, products)
- ✅ Learning materials (tutorials, courses, guides)
- ✅ Research notes (papers, ideas, conference summaries)
- ✅ Internal wikis (procedures, troubleshooting, best practices)
- ✅ Customer content (FAQs, support docs, user guides)
- ✅ Personal knowledge bases (notes, journal, ideas)
- ✅ Blog posts (technical, educational, opinion)
- ✅ Any written content in Markdown format

### Works in Any Location

IQPilot doesn't require GitHub or any specific platform:

- ✅ **GitHub Repositories** - Version-controlled documentation
- ✅ **Local Folders** - `C:\MyDocs`, `~/Documents/Notes`
- ✅ **OneDrive/Cloud Storage** - Synced across devices
- ✅ **Network Shares** - Team-accessible locations
- ✅ **Any VS Code Workspace** - Wherever you open VS Code

**How It Works:**
IQPilot watches the workspace folder you have open in VS Code. No Git required, no cloud required, no specific structure required.

### Works with Any Site Generator (or None)

IQPilot doesn't depend on how you publish:

- ✅ Quarto sites
- ✅ Jekyll blogs
- ✅ Hugo sites
- ✅ MkDocs projects
- ✅ Docusaurus
- ✅ Plain Markdown files (no publishing)
- ✅ Custom documentation systems
- ✅ Just local files for personal use

### Specialization Through Configuration

Everything is configurable via `.iqpilot/config.json`:

```json
{
  "site": {
    "name": "Your Site Name",
    "type": "documentation",
    "author": "Your Name"
  },
  "validation": {
    "grammar": { "enabled": true },
    "readability": { 
      "targetGradeLevel": 9,
      "fleschScoreMin": 60
    }
  },
  "templates": {
    "directory": ".iqpilot/templates",
    "useDefaults": true
  }
}
```

**Your Rules, Your Standards:**
- Set your own readability targets
- Define your own validation criteria
- Choose which checks to enable/disable
- Configure for your audience and purpose### Context Injection

IQPilot relies on GitHub Copilot's automatic context injection:

- `.github/copilot-instructions.md` - Site-specific editorial standards
- `.copilot/context/*.md` - Domain knowledge and style guides
- IQPilot prompts remain generic, context adapts them

**Example:**
- Generic prompt: "Check grammar"
- Learn Hub context: "Check grammar using technical writing style"
- API Docs context: "Check grammar using API documentation standards"

## Why IQPilot Matters

### For Content Creators

- **Confidence**: Know your content meets quality standards before publishing
- **Efficiency**: Spend time creating, not manually validating
- **Consistency**: All content follows the same structure and standards
- **Learning**: Improve writing skills through systematic feedback

### For Teams

- **Standardization**: Everyone follows the same editorial guidelines
- **Onboarding**: New team members get instant feedback on content quality
- **Quality Gates**: Prevent low-quality content from being published
- **Knowledge Management**: Cross-references and metadata improve discoverability

### For Organizations

- **Brand Consistency**: All public-facing content meets brand standards
- **Reduced Maintenance**: Article additional metadata tracks what needs review
- **Better SEO**: Structured metadata improves search engine visibility
- **Audit Trail**: Complete history of content quality over time

## The Vision

IQPilot represents a new paradigm for content development:

**From:** Manual, inconsistent, error-prone content creation  
**To:** Tool-assisted, systematic, quality-assured content development

**From:** Isolated documents with separate metadata files  
**To:** Self-contained articles with embedded quality tracking

**From:** Reactive quality checking (fix errors after publication)  
**To:** Proactive quality assurance (validate before publication)

**From:** Content creation as solitary work  
**To:** AI-assisted content development with intelligent guidance

**The Tool Mindset:**
Just as developers wouldn't ship code without running linters and tests, content creators shouldn't publish without running IQPilot validations. It's a tool in your workflow, not the workflow itself.

## Next Steps

Ready to get started with IQPilot? Continue to:

- **[IQPilot Getting Started](02.%20IQPilot%20Getting%20started.md)** - Learn how to install, configure, and use IQPilot
- **[IQPilot Implementation Details](03.%20IQPilot%20Implementation%20details.md)** - Understand the technical architecture and file structure

## Summary

**IQPilot is:**
- 🛠️ A content development tool for quality assurance
- 🤖 An AI-assisted validation system
- 🔄 An automatic metadata synchronization tool
- 📊 A configurable quality enforcement system
- 💡 An idea development and learning support assistant

**IQPilot provides:**
- 16 specialized validation and analysis tools
- Dual metadata architecture (visible + hidden)
- MCP protocol integration with GitHub Copilot
- Repository-agnostic design for any documentation system
- Configuration-driven behavior for maximum flexibility

**IQPilot enables:**
- Systematic content quality assurance
- Automated validation workflows
- Intelligent content discovery and cross-referencing
- Confidence in publication readiness
- Continuous content improvement

**Think of IQPilot as:**
- ESLint for content quality (not code quality)
- A test runner for documentation completeness
- A quality gate before publishing
- Your AI-assisted content review partner

The future of technical documentation is AI-assisted, quality-focused, and systematically validated. IQPilot makes that future available today.

---

<!-- 
---
validations:
  grammar:
    last_run: "2025-11-22"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    issues_found: 0
  readability:
    last_run: "2025-11-22"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    flesch_score: 62.5
    grade_level: 10
  structure:
    last_run: "2025-11-22"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    has_toc: false
    has_introduction: true
    has_conclusion: true
    has_references: false

article_metadata:
  filename: "01. IQPilot overview.md"
  created_date: "2025-11-22"
  last_updated: "2025-11-22"
  word_count: 2850
  estimated_reading_time: "14 min"
  article_type: "overview"

cross_references:
  related_articles:
    - "02. IQPilot Getting started.md"
    - "03. IQPilot Implementation details.md"
  topics:
    - "ai-assisted development"
    - "content quality"
    - "documentation automation"
    - "github copilot"
    - "mcp protocol"
---
-->
