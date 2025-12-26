---
title: "Getting Started with IQPilot in Learn Hub"
author: "Dario Airoldi"
date: "2025-12-26"
categories: [getting-started, iqpilot, guide]
description: "Quick start guide for IQPilot - optional AI-assisted content development tool enhancing GitHub Copilot"
---

# Getting Started with IQPilot in Learn Hub

## 🎯 Overview

This repository uses **IQPilot** - an optional AI-assisted content development tool that enhances GitHub Copilot with specialized validation, gap analysis, and metadata management capabilities.

**✨ IQPilot is completely optional** - all core features work with GitHub Copilot alone!

### What IQPilot Provides

**Without IQPilot (GitHub Copilot only):**
- ✅ Automated content validation (grammar, readability, structure)
- ✅ Template-based content creation
- ✅ Manual metadata management
- ✅ Standalone prompts via `.github/prompts/`

**With IQPilot (Enhanced MCP Mode):**
- ✅ Everything above, PLUS:
- ✅ Validation caching (avoids redundant AI calls)
- ✅ Automatic metadata synchronization on file renames
- ✅ Advanced gap analysis and cross-referencing
- ✅ 16 specialized MCP tools
- ✅ Series validation and consistency checks

**Choose your mode:**
- **MCP Mode** - Full IQPilot experience
- **Prompts Only** - Standalone prompts, no MCP server
- **Off** - Standard GitHub Copilot

See [`.iqpilot/README.md`](.iqpilot/README.md) for mode comparison and switching guide.

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ **Visual Studio Code** (v1.85.0 or later)
- ✅ **GitHub Copilot** extension installed
- ✅ **.NET 8.0 SDK** - [Download here](https://dotnet.microsoft.com/download/dotnet/8.0)
- ✅ **Node.js** (v20.x or later) - [Download here](https://nodejs.org/)
- ✅ **PowerShell** (Windows - usually pre-installed)

## 🚀 First-Time Setup

### Quick Setup (Prompts Only Mode)

If you just want to use standalone prompts with GitHub Copilot (no MCP server):

1. **Prerequisites**: VS Code + GitHub Copilot extension
2. **Configure mode**: Edit `.vscode/settings.json`:
   ```jsonc
   {
       "iqpilot.enabled": true,
       "iqpilot.mode": "prompts-only"
   }
   ```
3. **Reload VS Code**: `Ctrl+Shift+P` → "Developer: Reload Window"
4. **Start using**: Prompts from `.github/prompts/` are available via Copilot Chat

✅ **No build required** - works immediately with GitHub Copilot!

### Full Setup (MCP Mode)

For the complete IQPilot experience with validation caching and automatic metadata sync:

### Step 1: Build IQPilot MCP Server

IQPilot runs as an MCP (Model Context Protocol) server that integrates with GitHub Copilot:

```powershell
# In VS Code terminal (Ctrl+`)
cd src/IQPilot
dotnet build --configuration Release
```

This will:
1. Build the C# MCP server
2. Create the executable in `bin/Release/net8.0/`
3. Prepare IQPilot for integration with VS Code

**Expected output:**
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

### Step 2: Copy to MCP Servers Directory

```powershell
# From repository root
Copy-Item src/IQPilot/bin/Release/net8.0/* .copilot/mcp-servers/iqpilot/ -Recurse -Force
```

### Step 3: Configure Mode

Edit `.vscode/settings.json` to enable MCP mode:

```jsonc
{
    "iqpilot.enabled": true,
    "iqpilot.mode": "mcp",  // Full MCP mode with all features
    "iqpilot.autoStart": true
}
```

### Step 4: Reload VS Code

```
Ctrl+Shift+P → Developer: Reload Window
```

### Step 5: Verify IQPilot Integration

Open GitHub Copilot Chat and ask:

```
@workspace Are IQPilot tools available?
```

**Expected responses:**

**MCP Mode Active:**
```
✅ IQPilot MCP server is active with 16 specialized tools:
- Metadata tools (get, update, validate)
- Validation tools (grammar, readability, structure, all)
- Content tools (create, analyze_gaps, find_related, publish_ready)
- Workflow tools (article_creation, review, series_planning)
```

**Prompts Only Mode:**
```
✅ IQPilot standalone prompts available from .github/prompts/:
- grammar-review, readability-review, structure-validation
- gap-analysis, correlated-topics, series-validation
- publish-ready, fact-checking, logic-analysis
```

**Off Mode:**
```
IQPilot is disabled. Using standard GitHub Copilot.
To enable: .vscode/settings.json → "iqpilot.enabled": true
```

If not working as expected, check the [Troubleshooting](#troubleshooting) section.

## 🎛️ Switching Modes

See [`.iqpilot/README.md`](.iqpilot/README.md) for complete guide on:
- Mode comparison (MCP vs Prompts Only vs Off)
- How to switch modes (settings, commands, status bar)
- Performance considerations
- Troubleshooting mode issues

## 📝 Using IQPilot

### Creating a New Article

1. **Choose a template** from `.github/templates/`:
   - `article-template.md` - General technical article
   - `howto-template.md` - Step-by-step guide
   - `tutorial-template.md` - Multi-step tutorial
   - `issue-template.md` - Problem + solution
   - `recording-summary-template.md` - Conference/video notes

2. **Use GitHub Copilot to create from template:**
   ```
   In Copilot Chat:
   "Create a new technical article about Docker containers using the article template"
   ```

3. **Write your content** (or use AI assistance)

4. **Validate as you go** using GitHub Copilot:
   ```
   "Check structure of this article"
   "Run grammar validation"
   "Check readability"
   "Analyze for content gaps"
   ```

5. **Final check before publishing:**
   ```
   "Is this article ready to publish?"
   ```

6. **Publish**: Commit and push to GitHub!

### Renaming an Article

IQPilot's FileWatcherService automatically syncs dual metadata when you rename files:

1. Right-click file in Explorer → Rename (or press F2)
2. Type new name
3. Press Enter

✅ IQPilot automatically updates bottom YAML metadata block  
✅ `article_metadata.filename` field synchronized  
✅ Last modified timestamp updated  
✅ All automatic - no manual action required

### Validating Existing Articles

Use natural language with GitHub Copilot:

```
"Analyze this article for missing content"
"Find articles related to this topic"
"Validate the article structure"
"Check if this series is consistent"
```

### Running Automation Scripts

PowerShell scripts in `.copilot/scripts/`:

```powershell
# Build IQPilot MCP server
cd src/IQPilot
dotnet build --configuration Release

# Validate metadata schema for all articles (if script exists)
.\.copilot\scripts\validate-metadata.ps1

# Find articles with outdated validation checks (if script exists)
.\.copilot\scripts\check-stale-validations.ps1
```

## 📖 Available IQPilot Capabilities

IQPilot provides 16 MCP tools accessible through natural language with GitHub Copilot:

### Content Creation
- **Create articles** - Generate from templates with variable substitution
- **Initialize metadata** - Set up dual YAML structure automatically

### Validation
- **Grammar check** - AI-powered grammar and spelling validation
- **Readability analysis** - Flesch score and grade level assessment
- **Structure validation** - TOC, sections, heading hierarchy
- **Fact checking** - Verify claims against sources
- **Logic analysis** - Coherent argumentation review

### Content Analysis
- **Gap analysis** - Identify missing information
- **Find related articles** - Automatic cross-referencing
- **Topic correlation** - Discover connections
- **Publish-ready check** - Comprehensive pre-publish validation

### Workflows
- **Article creation workflow** - Guided end-to-end process
- **Review workflow** - Systematic content maintenance
- **Series planning** - Multi-article coordination

**Usage:** Just ask in natural language - Copilot maps to appropriate tools automatically!

## 🎛️ Configuration

### IQPilot Configuration

IQPilot behavior is controlled by `.iqpilot/config.json`:

```json
{
  "site": {
    "name": "Learn Hub",
    "type": "learning",
    "author": "Dario Airoldi"
  },
  "validation": {
    "readability": {
      "targetGradeLevel": 9,
      "fleschScoreMin": 60
    }
  }
}
```

See [idea/IQPilot/02. IQPilot Getting started.md](idea/IQPilot/02.%20IQPilot%20Getting%20started.md) for complete configuration reference.

### VS Code Settings

Workspace settings are pre-configured in `.vscode/settings.json`:
- File associations for `.metadata.yml` and `.prompt.md`
- Markdown validation rules
- GitHub Copilot integration
- Search and watch exclusions

### Recommended Extensions

When you open this workspace, VS Code will suggest installing:
- GitHub Copilot
- GitHub Copilot Chat
- C# Dev Kit
- YAML
- Markdown All in One
- Markdown Lint

Accept the recommendations or install manually.

## 🏗️ Folder Structure Overview

```
.github/
├── copilot-instructions.md      # Global GitHub Copilot guidelines  
├── instructions/                # Path-specific rules
├── prompts/                     # Legacy prompts (being migrated to IQPilot)
└── templates/                   # Content templates

.iqpilot/
├── config.default.json          # Framework defaults
├── config.json                  # Site-specific overrides
├── templates/                   # Default templates (fallback)
├── prompts/                     # Generic prompts (framework)
└── logs/                        # Runtime logs (gitignored)

.copilot/
├── context/                     # Rich context for AI
│   ├── domain-concepts.md
│   ├── style-guide.md
│   ├── validation-criteria.md
│   └── workflows/
├── scripts/                     # PowerShell automation
└── mcp-servers/                 # MCP server executables
    └── iqpilot/                 # IQPilot MCP server (gitignored)

src/IQPilot/                     # MCP Server source code
├── Program.cs
├── Server/                      # MCP protocol implementation
├── Tools/                       # MCP tool implementations
├── Services/                    # Core services
└── Models/                      # Data structures

.vscode/
├── extensions/iqpilot/          # VS Code extension (planned)
├── tasks.json                   # Build tasks
├── launch.json                  # Debug configs
└── settings.json                # Workspace settings

tech/                            # Your articles go here
howto/                           # How-to guides
events/                          # Conference notes
```

## 🔍 Commands Reference

### VS Code Tasks

Press `Ctrl+Shift+P` → "Tasks: Run Task":

- **Build IQPilot** - Compile MCP server
- **Publish IQPilot** - Build release version
- **Build Extension** - Compile VS Code extension (when available)

### IQPilot via GitHub Copilot

In Copilot Chat, use natural language:

```
"Check this article's grammar"
"Analyze readability"
"Find content gaps"
"Is this ready to publish?"
"Find related articles"
```

Copilot automatically invokes appropriate IQPilot MCP tools.

## 🐛 Troubleshooting

### IQPilot Tools Not Available in Copilot

**Symptom:** Copilot doesn't recognize IQPilot tools

**Solution:**
1. Verify build succeeded: Check `src/IQPilot/bin/Release/net8.0/` for executable
2. Verify copy to MCP servers: Check `.copilot/mcp-servers/iqpilot/` exists
3. Check Copilot configuration: Review `.github/copilot-instructions.md`
4. Reload VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"
5. Test in Copilot Chat: `@workspace Are IQPilot tools available?`

### Build Fails

**"dotnet: command not found"**
- Install .NET 8.0 SDK: https://dotnet.microsoft.com/download/dotnet/8.0
- Restart terminal after installation

**"Build failed with errors"**
```powershell
cd src/IQPilot
dotnet clean
dotnet restore
dotnet build --configuration Release
```

### Metadata Not Syncing

**Symptom:** Renamed article but dual metadata unchanged

**Check:**
1. Is article using dual metadata structure? (Top YAML + Bottom YAML in HTML comment)
2. Is file a Markdown file? (Only `*.md` files monitored)
3. Check IQPilot logs: `.iqpilot/logs/iqpilot.log`

**Note:** IQPilot's FileWatcherService handles metadata sync automatically when running as MCP server.

## 📚 Additional Documentation

- **IQPilot Overview**: [idea/IQPilot/01. IQPilot overview.md](idea/IQPilot/01.%20IQPilot%20overview.md)
- **IQPilot Getting Started**: [idea/IQPilot/02. IQPilot Getting started.md](idea/IQPilot/02.%20IQPilot%20Getting%20started.md)
- **Implementation Details**: [idea/IQPilot/03. IQPilot Implementation details.md](idea/IQPilot/03.%20IQPilot%20Implementation%20details.md)
- **Structure Overview**: [.github/STRUCTURE-README.md](.github/STRUCTURE-README.md)
- **Technical Docs**: [src/IQPilot/README.md](src/IQPilot/README.md)

## 🎓 Learning Resources

### Workflow Guides
- `.copilot/context/workflows/article-creation-workflow.md`
- `.copilot/context/workflows/review-workflow.md`
- `.copilot/context/workflows/series-planning-workflow.md`

### Style & Standards
- `.copilot/context/style-guide.md`
- `.copilot/context/validation-criteria.md`
- `.github/copilot-instructions.md`

## 🎉 You're Ready!

Start creating content with confidence knowing that:
- ✅ IQPilot MCP server integrates with GitHub Copilot
- ✅ AI validation tools available through natural language
- ✅ Dual metadata architecture with validation caching
- ✅ Automatic file system synchronization
- ✅ Quality standards enforced consistently
- ✅ Comprehensive documentation available

**First Task:** Try creating a test article!

```
1. Ask Copilot: "Create a test article about Docker basics"
2. Write some content
3. Ask Copilot: "Check the structure of this article"
4. Ask Copilot: "Run grammar validation"
5. Rename the file (F2) and watch dual metadata sync automatically!
```

---

## 💡 Tips for Success

1. **Validate incrementally** - Check as you write sections, not at the end
2. **Use templates** - Saves time and ensures consistency
3. **Let metadata auto-create** - Validation prompts create it automatically
4. **Trust the watcher** - Rename files normally; metadata stays in sync
5. **Check logs when needed** - Status bar provides quick access
6. **Run publish-ready before commit** - Final comprehensive check

---

**Need help?** Check the troubleshooting section or view logs via the status bar item.

**Questions?** All documentation is in this repository - search for your topic!

**Ready to contribute?** Start writing! The automation handles the rest. 🚀
