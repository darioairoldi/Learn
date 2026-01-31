---
title: "Documentation Index"
author: "Dario Airoldi"
date: "2026-01-04"
categories: [documentation, index, reference]
description: "Complete guide to all documentation automation files and resources in this repository"
---

# 📚 Documentation Index

Complete guide to all documentation automation files and resources in this repository.

## 🚀 Quick Links

### For New Users
- 📖 [GETTING-STARTED.md](GETTING-STARTED.md) - **Start here!** Quick setup and mode selection
- 📘 [.iqpilot/README.md](.iqpilot/README.md) - **IQPilot modes guide** - Enable/disable, mode comparison
- 🎯 [06.00-idea/iqpilot/01-iqpilot-overview.md](06.00-idea/iqpilot/01-iqpilot-overview.md) - What IQPilot is and why it matters
- 🚀 [06.00-idea/iqpilot/02-iqpilot-getting-started.md](06.00-idea/iqpilot/02-iqpilot-getting-started.md) - Installation and usage guide

### For Developers
- 🔧 [06.00-idea/iqpilot/03-iqpilot-implementation-details.md](06.00-idea/iqpilot/03-iqpilot-implementation-details.md) - Technical architecture & implementation
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
| [06.00-idea/iqpilot/02-iqpilot-getting-started.md](06.00-idea/iqpilot/02-iqpilot-getting-started.md) | Detailed installation & configuration | All Users |
| [.copilot/scripts/build-iqpilot.ps1](.copilot/scripts/build-iqpilot.ps1) | Build automation script | Developers |

### 🏗️ Architecture & Implementation

| File | Purpose | Audience |
|------|---------|----------|
| [06.00-idea/iqpilot/03-iqpilot-implementation-details.md](06.00-idea/iqpilot/03-iqpilot-implementation-details.md) | Architecture, folder structure, MCP integration | Developers |
| [06.00-idea/iqpilot/01-iqpilot-overview.md](06.00-idea/iqpilot/01-iqpilot-overview.md) | Concepts, philosophy, use cases | All Users |
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
| [.github/templates/techsession-summary-template.md](.github/templates/techsession-summary-template.md) | Tech session summary template | Writers |
| [.github/templates/techsession-analysis-template.md](.github/templates/techsession-analysis-template.md) | Tech session analysis template | Writers |
| [.github/templates/prompt-template.md](.github/templates/prompt-template.md) | Blank prompt file template | Writers |
| [.github/templates/metadata-template.yml](.github/templates/metadata-template.yml) | Metadata schema template | Writers |

### 📏 Editorial Standards

| File | Purpose | Audience |
|------|---------|----------|
| [.github/copilot-instructions.md](.github/copilot-instructions.md) | Global editorial & validation standards | All Users |
| [.copilot/context/01.00-article-writing/01-style-guide.md](.copilot/context/01.00-article-writing/01-style-guide.md) | Writing style & formatting rules | Writers |
| [.copilot/context/01.00-article-writing/02-validation-criteria.md](.copilot/context/01.00-article-writing/02-validation-criteria.md) | Quality thresholds for publishing | Writers |
| [.copilot/context/90.00-learning-hub/01-domain-concepts.md](.copilot/context/90.00-learning-hub/01-domain-concepts.md) | Core concepts & terminology | All Users |

### 🤖 AI Prompt Files

**IQPilot supports dual-mode operation:**

#### Standalone Prompts (Work Without IQPilot)
Located in `.github/prompts/` and subdirectories - accessible via natural language with GitHub Copilot:

**Article Prompts** (`.github/prompts/01.00-article-writing/`):
- [article-design-and-create.prompt.md](.github/prompts/01.00-article-writing/article-design-and-create.prompt.md) - Design articles from scratch
- [article-generate-techsession-summary.prompt.md](.github/prompts/01.00-article-writing/article-generate-techsession-summary.prompt.md) - Generate tech session summaries
- [article-generate-techsession-analysis.prompt.md](.github/prompts/01.00-article-writing/article-generate-techsession-analysis.prompt.md) - Generate tech session analysis
- [article-review-for-consistency-gaps-and-extensions.prompt.md](.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md) - Review article for consistency and gaps
- [article-review-series-for-consistency-gaps-and-extensions.prompt.md](.github/prompts/01.00-article-writing/article-review-series-for-consistency-gaps-and-extensions.prompt.md) - Review article series

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
| [.github/instructions/article-writing.instructions.md](.github/instructions/article-writing.instructions.md) | `tech/**/*.md` | Technical content (merged into article-writing) |
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
│  .copilot/context/00.00-prompt-engineering/*.md                 │
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

**Location**: `.copilot/context/00.00-prompt-engineering/`

| File | Purpose | Key Content |
|------|---------|-------------|
| [01-context-engineering-principles.md](.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md) | Core principles | 6 principles: Narrow Scope, Early Commands, Imperative Language, Three-Tier Boundaries, Context Minimization, Tool Scoping |
| [02-tool-composition-guide.md](.copilot/context/00.00-prompt-engineering/02-tool-composition-guide.md) | Tool selection | Priority rules, role-based tool sets, composition patterns |
| [05-validation-caching-pattern.md](.copilot/context/00.00-prompt-engineering/05-validation-caching-pattern.md) | 7-day caching | Dual YAML architecture, cache check workflow |
| [04-handoffs-pattern.md](.copilot/context/00.00-prompt-engineering/04-handoffs-pattern.md) | Multi-agent coordination | Handoff patterns: Linear Chain, Parallel Research, Validation Loop, Supervised |

### Prompt Files

**Location**: `.github/prompts/`

**Prompt Creation/Update** (`.github/prompts/00.00-prompt-engineering/`):
- [prompt-createorupdate-prompt-file.prompt.md](.github/prompts/00.00-prompt-engineering/prompt-createorupdate-prompt-file.prompt.md) - Create or update prompt files
- [prompt-design-and-create.prompt.md](.github/prompts/00.00-prompt-engineering/prompt-design-and-create.prompt.md) - Design prompts from scratch
- [prompt-review-and-validate.prompt.md](.github/prompts/00.00-prompt-engineering/prompt-review-and-validate.prompt.md) - Validate existing prompts

**Guidance Maintenance** (`.github/prompts/00.00-prompt-engineering/`):
- [prompt-createorupdate-prompt-instructions.prompt.md](.github/prompts/00.00-prompt-engineering/prompt-createorupdate-prompt-instructions.prompt.md) - Update instruction files
- [prompt-createorupdate-context-information.prompt.md](.github/prompts/00.00-prompt-engineering/prompt-createorupdate-context-information.prompt.md) - Update context files

### Agent Files

**Location**: `.github/agents/`

**Agent Creation/Update** (`.github/prompts/00.00-prompt-engineering/`):
- [agent-createorupdate-agent-file.prompt.md](.github/prompts/00.00-prompt-engineering/agent-createorupdate-agent-file.prompt.md) - Create or update agent files
- [agent-design-and-create.prompt.md](.github/prompts/00.00-prompt-engineering/agent-design-and-create.prompt.md) - Design agents from scratch
- [agent-review-and-validate.prompt.md](.github/prompts/00.00-prompt-engineering/agent-review-and-validate.prompt.md) - Validate existing agents

**Specialized Agents by Role**:

| Role | Agent | Purpose | Tools |
|------|-------|---------|-------|
| Prompt Researcher | [@prompt-researcher](.github/agents/prompt-researcher.agent.md) | Prompt pattern discovery | Read-only |
| Prompt Builder | [@prompt-builder](.github/agents/prompt-builder.agent.md) | Prompt file creation | Read + Write |
| Prompt Validator | [@prompt-validator](.github/agents/prompt-validator.agent.md) | Prompt quality assurance | Read-only |
| Prompt Updater | [@prompt-updater](.github/agents/prompt-updater.agent.md) | Fix prompt issues | Read + Write |
| Agent Researcher | [@agent-researcher](.github/agents/agent-researcher.agent.md) | Agent pattern discovery | Read-only |
| Agent Builder | [@agent-builder](.github/agents/agent-builder.agent.md) | Agent file creation | Read + Write |
| Agent Validator | [@agent-validator](.github/agents/agent-validator.agent.md) | Agent quality assurance | Read-only |
| Agent Updater | [@agent-updater](.github/agents/agent-updater.agent.md) | Fix agent issues | Read + Write |

### Tech Articles (Learning)

**Location**: `03.00-tech/05.02-prompt-engineering/`

| Article | Topic |
|---------|-------|
| [02.00 Naming Conventions](03.00-tech/05.02-prompt-engineering/02.00-how_to_name_and_organize_prompt_files.md) | File and folder organization |
| [03.00 Prompt Structure](03.00-tech/05.02-prompt-engineering/03.00-how_to_structure_content_for_copilot_prompt_files.md) | YAML frontmatter and sections |
| [04.00 Agent Structure](03.00-tech/05.02-prompt-engineering/04.00-how_to_structure_content_for_copilot_agent_files.md) | Personas, handoffs, boundaries |
| [05.00 Instruction Structure](03.00-tech/05.02-prompt-engineering/05.00-how_to_structure_content_for_copilot_instruction_files.md) | Path-specific instructions |
| [06.00 Skills Structure](03.00-tech/05.02-prompt-engineering/06.00-how_to_structure_content_for_copilot_skills.md) | Agent skills (SKILL.md files) |
| [07.00 MCP Servers](03.00-tech/05.02-prompt-engineering/07.00-how_to_create_mcp_servers_for_copilot.md) | Model Context Protocol servers |
| [20-21 Multi-Agent Example](03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md) | Real-world multi-agent workflow |
| [22 Documentation Site](03.00-tech/05.02-prompt-engineering/22-prompts-and-markdown-structure-for-a-documentation-site.md) | Repository-specific patterns |

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
@workspace /prompt-createorupdate-prompt-file-v2 [describe purpose]
```

**To create a new agent**:
```
@workspace /agent-createorupdate-agent-file-v2 [describe role]
```

**To update guidance files**:
```
@workspace /prompt-createorupdate-prompt-guidance [describe updates needed]
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
→ [06.00-idea/iqpilot/01-iqpilot-overview.md](06.00-idea/iqpilot/01-iqpilot-overview.md)

**I want to set up the repository:**
→ [GETTING-STARTED.md](GETTING-STARTED.md)

**I want to write a new article:**
→ Choose template from `.github/templates/`
→ Use prompts in `.github/prompts/01.00-article-writing/`

**I want to validate my content:**
→ Use prompts in `.github/prompts/` (via `/command` in Copilot)

**I want to understand the architecture:**
→ [06.00-idea/iqpilot/03-iqpilot-implementation-details.md](06.00-idea/iqpilot/03-iqpilot-implementation-details.md)

**I want to develop IQPilot:**
→ [src/IQPilot/README.md](src/IQPilot/README.md)

**I want to configure settings:**
→ [.vscode/settings.json](.vscode/settings.json)

### By Role

**Content Writer:**
1. [GETTING-STARTED.md](GETTING-STARTED.md) - Setup
2. [.copilot/context/01.00-article-writing/01-style-guide.md](.copilot/context/01.00-article-writing/01-style-guide.md) - Writing standards
3. [.github/templates/](.github/templates/) - Templates
4. [.github/prompts/](.github/prompts/) - Validation tools

**Developer:**
1. [06.00-idea/iqpilot/03-iqpilot-implementation-details.md](06.00-idea/iqpilot/03-iqpilot-implementation-details.md) - Architecture
2. [src/IQPilot/README.md](src/IQPilot/README.md) - Technical details
3. [.vscode/tasks.json](.vscode/tasks.json) - Build tasks
4. [.vscode/launch.json](.vscode/launch.json) - Debug configs

**Editor/Reviewer:**
1. [.github/copilot-instructions.md](.github/copilot-instructions.md) - Standards
2. [.copilot/context/01.00-article-writing/02-validation-criteria.md](.copilot/context/01.00-article-writing/02-validation-criteria.md) - Quality thresholds
3. Use validation prompts in `.github/prompts/` for review process

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

1. ✅ Read [06.00-idea/iqpilot/01-iqpilot-overview.md](06.00-idea/iqpilot/01-iqpilot-overview.md) to understand the concepts
2. ✅ Read [GETTING-STARTED.md](GETTING-STARTED.md) for setup instructions
3. ✅ Build IQPilot: `.\.copilot\scripts\build-iqpilot.ps1`
4. ✅ Reload VS Code
5. ✅ Create test article
6. ✅ Try validation prompts via GitHub Copilot
7. ✅ Start writing real content!

---

**Last Updated:** 2026-01-04  
**Total Documentation Files:** 34  
**Repository:** [darioairoldi/Learn](https://github.com/darioairoldi/Learn)
