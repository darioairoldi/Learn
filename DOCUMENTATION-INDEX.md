---
title: "Documentation Index"
author: "Dario Airoldi"
date: "2025-12-26"
categories: [documentation, index, reference]
description: "Complete guide to all documentation automation files and resources in this repository"
---

# 📚 Documentation Index

Complete guide to all documentation automation files and resources in this repository.

## 🚀 Quick Links

### For New Users
- 📖 [GETTING-STARTED.md](GETTING-STARTED.md) - **Start here!** Quick setup and mode selection
- 📘 [.iqpilot/README.md](.iqpilot/README.md) - **IQPilot modes guide** - Enable/disable, mode comparison
- 🎯 [idea/IQPilot/01. IQPilot overview.md](idea/IQPilot/01.%20IQPilot%20overview.md) - What IQPilot is and why it matters
- 🚀 [idea/IQPilot/02. IQPilot Getting started.md](idea/IQPilot/02.%20IQPilot%20Getting%20started.md) - Installation and usage guide

### For Developers
- 🔧 [idea/IQPilot/03. IQPilot Implementation details.md](idea/IQPilot/03.%20IQPilot%20Implementation%20details.md) - Technical architecture & implementation
- 📊 [src/IQPilot/README.md](src/IQPilot/README.md) - IQPilot MCP server source code

### For Content Writers
- 📝 [.github/STRUCTURE-README.md](.github/STRUCTURE-README.md) - Automation structure overview
- 📋 [.github/copilot-instructions.md](.github/copilot-instructions.md) - Global editorial standards

---

## 📂 Documentation by Category

### 🛠️ Setup & Installation

| File | Purpose | Audience |
|------|---------|----------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | Complete IQPilot setup guide | All Users |
| [idea/IQPilot/02. IQPilot Getting started.md](idea/IQPilot/02.%20IQPilot%20Getting%20started.md) | Detailed installation & configuration | All Users |
| [.copilot/scripts/build-iqpilot.ps1](.copilot/scripts/build-iqpilot.ps1) | Build automation script | Developers |

### 🏗️ Architecture & Implementation

| File | Purpose | Audience |
|------|---------|----------|
| [idea/IQPilot/03. IQPilot Implementation details.md](idea/IQPilot/03.%20IQPilot%20Implementation%20details.md) | Architecture, folder structure, MCP integration | Developers |
| [idea/IQPilot/01. IQPilot overview.md](idea/IQPilot/01.%20IQPilot%20overview.md) | Concepts, philosophy, use cases | All Users |
| [src/IQPilot/README.md](src/IQPilot/README.md) | C# MCP Server source code documentation | Developers |
| [.github/STRUCTURE-README.md](.github/STRUCTURE-README.md) | Repository structure & automation overview | All Users |

### ✍️ Content Creation

| File | Purpose | Audience |
|------|---------|----------|
| [.github/templates/article-template.md](.github/templates/article-template.md) | General technical article template | Writers |
| [.github/templates/howto-template.md](.github/templates/howto-template.md) | Step-by-step guide template | Writers |
| [.github/templates/tutorial-template.md](.github/templates/tutorial-template.md) | Multi-step tutorial template | Writers |
| [.github/templates/issue-template.md](.github/templates/issue-template.md) | Problem + solution template | Writers |
| [.github/templates/recording-summary-template.md](.github/templates/recording-summary-template.md) | Conference/video notes template | Writers |
| [.github/templates/recording-analysis-template.md](.github/templates/recording-analysis-template.md) | Deep analysis template | Writers |
| [.github/templates/metadata-template.yml](.github/templates/metadata-template.yml) | Metadata schema template | Writers |

### 📏 Editorial Standards

| File | Purpose | Audience |
|------|---------|----------|
| [.github/copilot-instructions.md](.github/copilot-instructions.md) | Global editorial & validation standards | All Users |
| [.copilot/context/style-guide.md](.copilot/context/style-guide.md) | Writing style & formatting rules | Writers |
| [.copilot/context/validation-criteria.md](.copilot/context/validation-criteria.md) | Quality thresholds for publishing | Writers |
| [.copilot/context/domain-concepts.md](.copilot/context/domain-concepts.md) | Core concepts & terminology | All Users |

### 🔄 Workflows & Processes

| File | Purpose | Audience |
|------|---------|----------|
| [.copilot/context/workflows/article-creation-workflow.md](.copilot/context/workflows/article-creation-workflow.md) | Step-by-step article creation process | Writers |
| [.copilot/context/workflows/review-workflow.md](.copilot/context/workflows/review-workflow.md) | Maintenance & update workflow | Writers |
| [.copilot/context/workflows/series-planning-workflow.md](.copilot/context/workflows/series-planning-workflow.md) | Multi-article series planning | Writers |

### 🤖 AI Prompt Files

**IQPilot supports dual-mode operation:**

#### Standalone Prompts (Work Without IQPilot)
Located in `.github/prompts/` - accessible via natural language with GitHub Copilot:

**Content Creation:**
- [article-writing.prompt.md](.github/prompts/article-writing.prompt.md) - Generate articles from topics

**Validation:**
- [structure-validation.prompt.md](.github/prompts/structure-validation.prompt.md) - Document structure check
- [grammar-review.prompt.md](.github/prompts/grammar-review.prompt.md) - Grammar and spelling
- [readability-review.prompt.md](.github/prompts/readability-review.prompt.md) - Readability analysis
- [understandability-review.prompt.md](.github/prompts/understandability-review.prompt.md) - Concept clarity
- [fact-checking.prompt.md](.github/prompts/fact-checking.prompt.md) - Verify claims & citations

**Analysis:**
- [logic-analysis.prompt.md](.github/prompts/logic-analysis.prompt.md) - Logical flow review
- [gap-analysis.prompt.md](.github/prompts/gap-analysis.prompt.md) - Identify missing content
- [correlated-topics.prompt.md](.github/prompts/correlated-topics.prompt.md) - Find related articles
- [series-validation.prompt.md](.github/prompts/series-validation.prompt.md) - Series consistency check

**Publishing:**
- [publish-ready.prompt.md](.github/prompts/publish-ready.prompt.md) - Comprehensive pre-publish check

#### Enhanced Prompts (Require IQPilot MCP)
Located in `.iqpilot/prompts/` - used automatically when IQPilot is in MCP mode:

- [grammar-review-enhanced.prompt.md](.iqpilot/prompts/grammar-review-enhanced.prompt.md) - With validation caching
- *(More enhanced prompts to be added)*

**Automatic Selection:** Copilot automatically chooses enhanced version if IQPilot MCP is active, falls back to standalone if not.

### 📋 Path-Specific Instructions

Automatically applied to files in specific folders:

| File | Applies To | Purpose |
|------|-----------|---------|
| [.github/instructions/documentation.instructions.md](.github/instructions/documentation.instructions.md) | `**/*.md` | All Markdown files |
| [.github/instructions/tech-articles.instructions.md](.github/instructions/tech-articles.instructions.md) | `tech/**/*.md` | Technical content |
| [.github/instructions/prompts.instructions.md](.github/instructions/prompts.instructions.md) | `.github/prompts/**/*.md` | Prompt file creation |
| [.github/instructions/agents.instructions.md](.github/instructions/agents.instructions.md) | `.github/agents/**/*.agent.md` | Agent file creation |
| [.github/instructions/context-files.instructions.md](.github/instructions/context-files.instructions.md) | `.copilot/context/**/*.md` | Context file creation |

---

## 🤖 Prompt Engineering Ecosystem

Complete guide to prompt, agent, and context engineering in this repository.

### Core Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    INSTRUCTION LAYER                            │
│  .github/instructions/*.instructions.md                         │
│  (Auto-applied based on file path globs)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CONTEXT LAYER                                │
│  .copilot/context/prompt-engineering/*.md                       │
│  (Shared principles, patterns, and guidelines)                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OPERATIONAL LAYER                            │
│  .github/prompts/*.prompt.md  |  .github/agents/*.agent.md     │
│  (Task workflows)             |  (Role-based specialists)       │
└─────────────────────────────────────────────────────────────────┘
```

### Context Files (Shared Principles)

**Location**: `.copilot/context/prompt-engineering/`

| File | Purpose | Key Content |
|------|---------|-------------|
| [context-engineering-principles.md](.copilot/context/prompt-engineering/context-engineering-principles.md) | Core principles | 6 principles: Narrow Scope, Early Commands, Imperative Language, Three-Tier Boundaries, Context Minimization, Tool Scoping |
| [tool-composition-guide.md](.copilot/context/prompt-engineering/tool-composition-guide.md) | Tool selection | Priority rules, role-based tool sets, composition patterns |
| [validation-caching-pattern.md](.copilot/context/prompt-engineering/validation-caching-pattern.md) | 7-day caching | Dual YAML architecture, cache check workflow |
| [handoffs-pattern.md](.copilot/context/prompt-engineering/handoffs-pattern.md) | Multi-agent coordination | Handoff patterns: Linear Chain, Parallel Research, Validation Loop, Supervised |

### Prompt Files

**Location**: `.github/prompts/`

**Prompt Creation/Update**:
- [prompt-createorupdate-prompt-file-v2.prompt.md](.github/prompts/prompt-createorupdate-prompt-file-v2.prompt.md) - ✅ **Recommended** - Multi-agent orchestration
- [prompt-createorupdate-prompt-file.prompt.md](.github/prompts/prompt-createorupdate-prompt-file.prompt.md) - ⚠️ Deprecated (use v2)
- [prompt-design-and-create.prompt.md](.github/prompts/prompt-design-and-create.prompt.md) - Design from scratch
- [prompt-review-and-validate.prompt.md](.github/prompts/prompt-review-and-validate.prompt.md) - Validate existing prompts

**Guidance Maintenance**:
- [prompt-createorupdate-prompt-guidance.prompt.md](.github/prompts/prompt-createorupdate-prompt-guidance.prompt.md) - Update instruction and context files

### Agent Files

**Location**: `.github/agents/`

**Agent Creation/Update**:
- [agent-createorupdate-agent-file-v2.prompt.md](.github/prompts/agent-createorupdate-agent-file-v2.prompt.md) - ✅ **Recommended** - Multi-agent orchestration
- [agent-createorupdate-agent-file.prompt.md](.github/prompts/agent-createorupdate-agent-file.prompt.md) - ⚠️ Deprecated (use v2)
- [agent-design-and-create.prompt.md](.github/prompts/agent-design-and-create.prompt.md) - Design from scratch
- [agent-review-and-validate.prompt.md](.github/prompts/agent-review-and-validate.prompt.md) - Validate existing agents

**Specialized Agents by Role**:

| Role | Agent | Purpose | Tools |
|------|-------|---------|-------|
| Researcher | [@prompt-researcher](.github/agents/prompt-researcher.agent.md) | Pattern discovery | Read-only |
| Builder | [@prompt-builder](.github/agents/prompt-builder.agent.md) | File creation | Read + Write |
| Validator | [@prompt-validator](.github/agents/prompt-validator.agent.md) | Quality assurance | Read-only |
| Updater | [@prompt-updater](.github/agents/prompt-updater.agent.md) | Fix issues | Read + Write |

### Tech Articles (Learning)

**Location**: `tech/PromptEngineering/`

| Article | Topic |
|---------|-------|
| [01. Copilot File Consumption](tech/PromptEngineering/01.%20how_to_write_prompts_copilot_file_consumption.md) | How Copilot reads files |
| [02. Naming Conventions](tech/PromptEngineering/02.%20how_to_write_prompts_naming_conventions.md) | File and folder organization |
| [03. Prompt Structure](tech/PromptEngineering/03.%20how_to_write_prompts_prompt_structure.md) | YAML frontmatter and sections |
| [04. Agent Structure](tech/PromptEngineering/04.%20how_to_write_prompts_agent_structure.md) | Personas, handoffs, boundaries |
| [05. Instruction Structure](tech/PromptEngineering/05.%20how_to_write_prompts_instruction_structure.md) | Path-specific instructions |
| [06. Multi-Agent Prompts](tech/PromptEngineering/06.%20how_to_write_prompts_multi_agent_prompts.md) | Orchestration patterns |
| [07. Implementation Example](tech/PromptEngineering/07.%20how_to_write_prompts_example_with_agents.md) | Real-world multi-agent workflow |
| [08. Documentation Site](tech/PromptEngineering/08.%20how_to_write_prompts_documentation_site_patterns.md) | Repository-specific patterns |

### Templates

**Location**: `.github/templates/`

| Template | Use Case |
|----------|----------|
| [prompt-simple-validation-template.md](.github/templates/prompt-simple-validation-template.md) | Read-only validation with 7-day caching |
| [prompt-implementation-template.md](.github/templates/prompt-implementation-template.md) | File creation/modification workflows |
| [prompt-multi-agent-orchestration-template.md](.github/templates/prompt-multi-agent-orchestration-template.md) | Multi-agent coordination |
| [prompt-analysis-only-template.md](.github/templates/prompt-analysis-only-template.md) | Research and reporting |

### Quick Reference: Creating New Files

**To create a new prompt**:
```
/prompt-createorupdate-prompt-file-v2 [describe purpose]
```

**To create a new agent**:
```
/agent-createorupdate-agent-file-v2 [describe role]
```

**To update guidance files**:
```
/prompt-createorupdate-prompt-guidance [describe updates needed]
```

### 🔧 Automation Scripts

| File | Purpose | Usage |
|------|---------|-------|
| [.copilot/scripts/build-metadata-watcher.ps1](.copilot/scripts/build-metadata-watcher.ps1) | Build LSP server & extension | `.\.copilot\scripts\build-metadata-watcher.ps1` |
| [.copilot/scripts/validate-metadata.ps1](.copilot/scripts/validate-metadata.ps1) | Validate metadata schema | `.\.copilot\scripts\validate-metadata.ps1` |
| [.copilot/scripts/check-stale-validations.ps1](.copilot/scripts/check-stale-validations.ps1) | Find outdated validations | `.\.copilot\scripts\check-stale-validations.ps1` |

### ⚙️ VS Code Configuration

| File | Purpose | Audience |
|------|---------|----------|
| [.vscode/tasks.json](.vscode/tasks.json) | Build & publish tasks | Developers |
| [.vscode/launch.json](.vscode/launch.json) | Debug configurations | Developers |
| [.vscode/settings.json](.vscode/settings.json) | Workspace settings | All Users |
| [.vscode/extensions.json](.vscode/extensions.json) | Recommended extensions | All Users |

### 📦 Source Code

| Directory | Purpose | Audience |
|-----------|---------|----------|
| [src/IQPilot/](src/IQPilot/) | C# MCP Server source code | Developers |
| [.vscode/extensions/iqpilot/](.vscode/extensions/iqpilot/) | VS Code extension (TypeScript) | Developers |

---

## 🗺️ Documentation Roadmap

### Phase 1: IQPilot Core ✅
- [x] IQPilot overview and concepts
- [x] Getting started guide
- [x] Implementation details
- [x] MCP server architecture

### Phase 2: Integration 🚧
- [x] VS Code extension
- [ ] MCP tools implementation
- [ ] Validation engine
- [ ] Template system

### Phase 3: User Guides ✅
- [x] Prompt documentation
- [x] Workflow guides
- [x] Templates

### Phase 4: Deployment (Planned)
- [ ] Build and publish scripts
- [ ] Installation automation
- [ ] GitHub Copilot configuration
- [ ] Complete end-to-end testing

---

## 📊 Documentation Statistics

| Category | Count | Total Lines |
|----------|-------|-------------|
| Setup Guides | 2 | ~5,000 |
| Technical Docs | 3 | ~10,000 |
| Templates | 7 | ~700 |
| Prompts | 13 | ~3,000 |
| Instructions | 3 | ~300 |
| Workflows | 3 | ~600 |
| Scripts | 3 | ~500 |
| **Total** | **34** | **~20,100** |

---

## 🔍 Finding What You Need

### By Task

**I want to understand IQPilot:**
→ [idea/IQPilot/01. IQPilot overview.md](idea/IQPilot/01.%20IQPilot%20overview.md)

**I want to set up the repository:**
→ [GETTING-STARTED.md](GETTING-STARTED.md)

**I want to write a new article:**
→ [article-creation-workflow.md](.copilot/context/workflows/article-creation-workflow.md)
→ Choose template from `.github/templates/`

**I want to validate my content:**
→ Use prompts in `.github/prompts/` (via `/command` in Copilot)

**I want to understand the architecture:**
→ [idea/IQPilot/03. IQPilot Implementation details.md](idea/IQPilot/03.%20IQPilot%20Implementation%20details.md)

**I want to develop IQPilot:**
→ [src/IQPilot/README.md](src/IQPilot/README.md)

**I want to configure settings:**
→ [.vscode/settings.json](.vscode/settings.json)

### By Role

**Content Writer:**
1. [GETTING-STARTED.md](GETTING-STARTED.md) - Setup
2. [.copilot/context/style-guide.md](.copilot/context/style-guide.md) - Writing standards
3. [.github/templates/](.github/templates/) - Templates
4. [.github/prompts/](.github/prompts/) - Validation tools

**Developer:**
1. [idea/IQPilot/03. IQPilot Implementation details.md](idea/IQPilot/03.%20IQPilot%20Implementation%20details.md) - Architecture
2. [src/IQPilot/README.md](src/IQPilot/README.md) - Technical details
3. [.vscode/tasks.json](.vscode/tasks.json) - Build tasks
4. [.vscode/launch.json](.vscode/launch.json) - Debug configs

**Editor/Reviewer:**
1. [.github/copilot-instructions.md](.github/copilot-instructions.md) - Standards
2. [.copilot/context/validation-criteria.md](.copilot/context/validation-criteria.md) - Quality thresholds
3. [.copilot/context/workflows/review-workflow.md](.copilot/context/workflows/review-workflow.md) - Review process

### By File Type

**Markdown Documentation:**
- All `.md` files in root directory
- `.copilot/context/*.md`
- `src/IQPilot/README.md`, `src/IQPilot/README.IQPilot.md`

**YAML Configuration:**
- `.github/templates/metadata-template.yml`
- `.vscode/settings.json` (JSON, but related)

**PowerShell Scripts:**
- `.copilot/scripts/*.ps1`

**TypeScript Source:**
- `.vscode/extensions/iqpilot/src/*.ts`

**C# Source:**
- `src/IQPilot/*.cs`

---

## 🆘 Quick Help

### Most Common Needs

1. **Setup:** [GETTING-STARTED.md](GETTING-STARTED.md) ← Start here!
2. **Write Article:** Use template + `/article-writing`
3. **Validate:** `/structure-validation` → `/grammar-review` → `/publish-ready`
4. **Rename Article:** F2 in VS Code (metadata syncs automatically)
5. **Troubleshoot:** Check logs via status bar

### Key Commands

- **Reload VS Code:** `Ctrl+Shift+P` → "Developer: Reload Window"
- **Run Task:** `Ctrl+Shift+P` → "Tasks: Run Task"
- **Restart IQPilot:** `Ctrl+Shift+P` → "IQPilot: Restart Server"
- **Show Logs:** Click status bar `✓ IQPilot`

---

## 🎯 Next Steps

1. ✅ Read [idea/IQPilot/01. IQPilot overview.md](idea/IQPilot/01.%20IQPilot%20overview.md) to understand the concepts
2. ✅ Read [GETTING-STARTED.md](GETTING-STARTED.md) for setup instructions
3. ✅ Build IQPilot: `.\.copilot\scripts\build-iqpilot.ps1`
4. ✅ Reload VS Code
5. ✅ Create test article
6. ✅ Try validation prompts via GitHub Copilot
7. ✅ Start writing real content!

---

**Last Updated:** 2025-11-23  
**Total Documentation Files:** 34  
**Repository:** [darioairoldi/Learn](https://github.com/darioairoldi/Learn)
