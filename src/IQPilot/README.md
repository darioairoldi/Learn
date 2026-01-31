# IQPilot MCP Server

**Intelligence & Quality Pilot for AI-Assisted Content Development**

## Overview

IQPilot is a Model Context Protocol (MCP) server written in C# that provides automated content validation, metadata management, and workflow orchestration for documentation sites. It integrates with GitHub Copilot to enhance content development with specialized tools and intelligent assistance.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  GitHub Copilot Chat                     │
│  ┌────────────────────────────────────────────────────┐ │
│  │      GitHub Copilot Extension (VS Code)            │ │
│  │  • MCP client integration                           │ │
│  │  • Tool invocation via natural language             │ │
│  │  • Context-aware assistance                         │ │
│  └──────────────┬──────────────────────────────────────┘ │
│                 │  MCP Protocol (stdio)                   │
└─────────────────┼─────────────────────────────────────────┘
                  │
        ┌─────────▼────────────────────┐
        │     IQPilot MCP Server        │
        │    (C# .NET 8.0)              │
        │  ┌─────────────────────────┐  │
        │  │  16 MCP Tools            │  │
        │  │  • Validation Tools      │  │
        │  │  • Content Tools         │  │
        │  │  • Metadata Tools        │  │
        │  │  • Workflow Tools        │  │
        │  └─────────────────────────┘  │
        └───────────────────────────────┘
```

## 🎯 Key Features

- ✅ **Framework-agnostic**: Works with Quarto, Jekyll, Hugo, Docusaurus, MkDocs, or any Markdown-based site
- ✅ **Configuration-driven**: Customize for your site without changing code
- ✅ **Dual metadata system**: Visible Quarto/Jekyll frontmatter + hidden article additional metadata
- ✅ **AI-native**: Built for GitHub Copilot integration via MCP protocol
- ✅ **Validation caching**: Avoids redundant AI calls by tracking validation state
- ✅ **Automatic metadata sync**: Updates metadata on file renames and content changes
- ✅ **Extensible**: Add custom templates, prompts, and validation rules

## Features

### Content Validation
- **Grammar & Spelling**: Comprehensive language checks with AI assistance
- **Readability Analysis**: Flesch score, grade level, sentence complexity
- **Structure Validation**: TOC, required sections, proper heading hierarchy
- **Fact Checking**: Verify claims against authoritative sources
- **Logic Analysis**: Evaluate conceptual flow and coherence
- **Understandability**: Assess audience-appropriate complexity

### Metadata Management
- **Dual YAML Architecture**: Top block (Quarto) + bottom HTML comment (tracking)
- **Automatic Sync**: Updates `article_metadata.filename` on file renames
- **Validation Tracking**: Caches validation results to avoid redundant checks
- **Cross-References**: Automatic discovery of related articles

### Workflow Orchestration
- **Article Creation**: Guided workflow from concept to publication
- **Review Process**: Systematic review and validation steps
- **Series Planning**: Multi-article series coordination
- **Gap Analysis**: Identify missing information and perspectives

## 🚀 Quick Start

### Prerequisites

1. **.NET 8.0 SDK** - [Download](https://dotnet.microsoft.com/download/dotnet/8.0)
2. **VS Code** - Version 1.85.0 or later
3. **GitHub Copilot** - Active subscription with Copilot Chat enabled

### 1. Build IQPilot

```powershell
# From repository root
cd src/IQPilot
dotnet build -c Release
```

### 2. Publish to MCP Server Location

```powershell
# Publish self-contained executable
dotnet publish -c Release `
    -r win-x64 `
    --self-contained `
    /p:PublishSingleFile=true `
    -o ../../.copilot/mcp-servers/iqpilot
```

### 3. Configure VS Code

Add to your workspace `.vscode/settings.json`:

```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "iqpilot": {
      "command": "${workspaceFolder}/.copilot/mcp-servers/iqpilot/IQPilot.exe",
      "args": [],
      "env": {}
    }
  }
}
```

### 4. Configure IQPilot

Create `.iqpilot/config.json` in your documentation repository:

```json
{
  "site": {
    "name": "My Documentation Site",
    "type": "documentation",
    "author": "Your Name"
  },
  "validation": {
    "readability": {
      "targetGradeLevel": 10,
      "fleschScoreMin": 60
    },
    "structure": {
      "requireToc": true,
      "requireReferences": true
    }
  },
  "metadata": {
    "autoSync": true,
    "embeddedFormat": "html-comment"
  }
}
```

### 5. Reload VS Code

Press `Ctrl+Shift+P` → "Developer: Reload Window"

### 6. Verify Installation

In GitHub Copilot Chat:
```
@iqpilot Hello! Are you working?
```

IQPilot should respond confirming it's active.

## 📖 Available MCP Tools

### Validation Tools
- `iqpilot/validate/grammar` - Grammar and spelling check with AI assistance
- `iqpilot/validate/readability` - Readability analysis (Flesch score, grade level)
- `iqpilot/validate/structure` - Structure compliance (TOC, sections, references)
- `iqpilot/validate/facts` - Fact checking with source verification
- `iqpilot/validate/logic` - Logical flow and coherence analysis
- `iqpilot/validate/understandability` - Audience-appropriate complexity check
- `iqpilot/validate/all` - Run all validations

### Content Tools
- `iqpilot/content/create` - Generate article from template
- `iqpilot/content/analyze_gaps` - Identify missing information
- `iqpilot/content/find_related` - Discover correlated topics
- `iqpilot/content/publish_ready` - Pre-publish checklist

### Metadata Tools
- `iqpilot/metadata/get` - Retrieve article metadata
- `iqpilot/metadata/update` - Update metadata fields
- `iqpilot/metadata/validate` - Validate metadata schema
- `iqpilot/metadata/sync` - Sync metadata on file rename (automatic)

### Workflow Tools
- `iqpilot/workflow/article_creation` - Guide through article creation
- `iqpilot/workflow/review` - Guide through review process
- `iqpilot/workflow/series_planning` - Plan article series

## Usage

### Using with GitHub Copilot Chat

IQPilot tools are invoked automatically by GitHub Copilot when you ask relevant questions:

### Using with GitHub Copilot Chat

IQPilot tools are invoked automatically by GitHub Copilot when you ask relevant questions:

**Grammar Validation:**
```
User: "Check grammar in this article #file:article.md"
Copilot: [Calls iqpilot/validate/grammar]
Result: Grammar check complete. 2 issues found...
```

**Article Creation:**
```
User: "Create a new article about Docker containers"
Copilot: [Calls iqpilot/content/create]
Result: Article created with template structure...
```

**Metadata Management:**
```
User: "Show me the validation status for this article"
Copilot: [Calls iqpilot/metadata/get]
Result: Last validated 2 days ago. Grammar: passed, Readability: 65 Flesch score...
```

**Gap Analysis:**
```
User: "What information is missing from this article?"
Copilot: [Calls iqpilot/content/analyze_gaps]
Result: Missing sections: Prerequisites, Examples, Troubleshooting...
```

### Automatic Behaviors

**File Rename Synchronization:**
When you rename an article in VS Code:

1. **Before Rename:**
   ```
   tech/article-example.md
   ```

2. **Rename the article** (F2 or right-click → Rename)

3. **IQPilot automatically updates** the embedded metadata:
   ```markdown
   <!-- 
   ---
   article_metadata:
     filename: new-article-name.md  ← updated automatically
   ---
   -->
   ```

**Validation Caching:**
IQPilot tracks validation state to avoid redundant checks:
- Grammar validated 2 hours ago, content unchanged? Skip re-validation
- Article modified? Invalidate cache, re-run validation
- Manual override available via `force: true` parameter

### Direct Tool Invocation

You can also invoke tools directly in Copilot Chat:

```
@iqpilot validate grammar in #file:article.md
@iqpilot analyze gaps in current article
@iqpilot create article from template "howto"
@iqpilot check if article is publish-ready
```

## Configuration

### VS Code Settings

Settings in `.vscode/settings.json`:

| Setting | Default | Description |
|---------|---------|-------------|
| `iqpilot.enabled` | `true` | Enable/disable IQPilot MCP server |
| `iqpilot.mode` | `"mcp"` | Operating mode: `"mcp"`, `"prompts-only"`, or `"off"` |
| `iqpilot.autoStart` | `true` | Auto-start server when workspace opens |
| `iqpilot.logLevel` | `"Information"` | Log verbosity: `"Error"`, `"Warning"`, `"Information"`, `"Debug"` |

### IQPilot Configuration

Configure in `.iqpilot/config.json`:

```json
{
  "site": {
    "name": "My Documentation Site",
    "type": "documentation",
    "author": "Your Name",
    "language": "en"
  },
  "validation": {
    "readability": {
      "targetGradeLevel": 10,
      "fleschScoreMin": 60,
      "maxSentenceLength": 25
    },
    "structure": {
      "requireToc": true,
      "requireIntroduction": true,
      "requireConclusion": true,
      "requireReferences": true
    },
    "grammar": {
      "checkSpelling": true,
      "checkGrammar": true,
      "checkPunctuation": true
    }
  },
  "metadata": {
    "autoSync": true,
    "embeddedFormat": "html-comment",
    "trackValidations": true,
    "cacheValidations": true,
    "cacheDurationHours": 24
  },
  "content": {
    "defaultTemplate": "article-template.md",
    "templatesPath": ".iqpilot/templates",
    "promptsPath": ".iqpilot/prompts"
  }
}
```

## 🎨 Customization

IQPilot is designed to adapt to your documentation site's needs:

### Custom Templates

Add templates to `.iqpilot/templates/`:

```markdown
---
title: "{{ TITLE }}"
author: "{{ AUTHOR }}"
date: "{{ DATE }}"
categories: [{{ CATEGORIES }}]
---

# {{ TITLE }}

## Introduction

{{ INTRODUCTION }}

## Main Content

{{ CONTENT }}

## References

{{ REFERENCES }}

<!-- 
---
validations:
  grammar: {last_run: null, outcome: null}
  readability: {last_run: null, flesch_score: null}
article_metadata:
  filename: "{{ FILENAME }}"
  created: "{{ DATE }}"
  status: "draft"
---
-->
```

### Custom Prompts

Add prompts to `.iqpilot/prompts/`:

```markdown
---
description: Custom validation for my site
mode: ask
---

# My Custom Validation

Check for site-specific requirements:
- Internal link format
- Image size requirements
- Code block language specifications
- Custom metadata fields
```

### Custom Validation Rules

Extend validation in `.iqpilot/config.json`:

```json
{
  "validation": {
    "custom": {
      "checkInternalLinks": true,
      "requiredSections": ["Introduction", "Conclusion", "References"],
      "maxImageSizeKB": 500,
      "codeBlockLanguages": ["javascript", "typescript", "python", "bash"]
    }
  }
}
```

## 📂 Project Structure

```
your-docs-repo/
├── .iqpilot/
│   ├── config.json              # IQPilot configuration
│   ├── copilot-instructions.md  # IQPilot-specific Copilot guidance
│   ├── templates/               # Custom article templates
│   │   ├── article-template.md
│   │   └── howto-template.md
│   └── prompts/                 # Enhanced validation prompts
│       └── *-enhanced.prompt.md
│
├── .github/
│   ├── copilot-instructions.md  # Base Copilot instructions (IQPilot-independent)
│   ├── prompts/                 # Standalone prompts (work without IQPilot)
│   └── templates/               # Base templates
│
├── .copilot/
│   ├── mcp-servers/
│   │   └── iqpilot/             # IQPilot MCP server executable
│   ├── context/                 # Domain knowledge for Copilot
│   └── scripts/                 # Automation scripts
│
├── articles/                    # Your documentation content
│   └── my-article.md
│
└── .vscode/
    └── settings.json            # VS Code and MCP configuration
```

## 🔧 Troubleshooting

### IQPilot Not Responding

**Symptom:** Copilot Chat doesn't invoke IQPilot tools

**Solution:**
1. Check MCP is enabled: Settings → Search "github.copilot.chat.mcp.enabled" → Should be `true`
2. Verify server path: Check `.vscode/settings.json` for correct executable path
3. Reload VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"
4. Check Copilot output: View → Output → Select "GitHub Copilot Chat" from dropdown

### Server Crashes on Startup

**Symptom:** IQPilot fails to start when VS Code opens

**Solution:**
1. Check logs: `%LOCALAPPDATA%\IQPilot\logs\iqpilot-YYYYMMDD.log`
2. Look for:
   - **Missing configuration**: Ensure `.iqpilot/config.json` exists
   - **Path issues**: Workspace folder not detected
   - **Permissions**: Write access to log directory denied
3. Verify build: Ensure executable exists at `.copilot/mcp-servers/iqpilot/IQPilot.exe`
4. Rebuild if needed: See [Quick Start](#quick-start) section

### Metadata Not Syncing

**Symptom:** Renamed article, but embedded metadata unchanged

**Solution:**
1. Check autoSync setting: `.iqpilot/config.json` → `"metadata.autoSync": true`
2. Verify file format: Must have `.md` extension
3. Check metadata structure: Ensure bottom HTML comment block exists
4. Review logs for errors

### Validation Cache Issues

**Symptom:** IQPilot re-runs validations even when content unchanged

**Solution:**
1. Check cache settings: `.iqpilot/config.json` → `"metadata.cacheValidations": true`
2. Verify cache duration: Default 24 hours, adjust `cacheDurationHours` if needed
3. Force cache clear: Use `force: true` parameter in tool invocation
4. Check timestamp precision: Ensure system clock is accurate

### Build Errors

**Symptom:** `dotnet build` or `dotnet publish` fails

**Solution:**
```powershell
# Clean and rebuild
cd src/IQPilot
dotnet clean
dotnet restore
dotnet build -c Release
```

Check for:
- Missing .NET 8.0 SDK
- NuGet package restore issues
- Project file corruption

## 🛠️ Development

### Project Structure

```
src/IQPilot/
├── IQPilot.csproj              # Project file with NuGet packages
├── Program.cs                   # MCP server entry point
├── Services/                    # Core services
│   ├── ValidationService.cs     # Validation orchestration
│   ├── MetadataService.cs       # Metadata management
│   ├── ContentService.cs        # Content analysis
│   └── WorkflowService.cs       # Workflow coordination
├── Tools/                       # MCP tool implementations (16 tools)
│   ├── ValidationTools.cs       # Grammar, readability, structure, etc.
│   ├── ContentTools.cs          # Create, analyze, find related
│   ├── MetadataTools.cs         # Get, update, validate, sync
│   └── WorkflowTools.cs         # Article creation, review, series
├── Models/                      # Data models
│   ├── ArticleMetadata.cs
│   ├── ValidationResult.cs
│   └── ContentAnalysis.cs
└── Configuration/               # Configuration management
    └── IQPilotConfig.cs
```

### Building from Source

```bash
cd src/IQPilot
dotnet build -c Release
```

### Running Tests

```bash
dotnet test
```

### Debugging

#### Debug MCP Server

1. Set breakpoints in service files
2. Press `F5` → Select "Launch IQPilot (Debug)"
3. Server runs with debugger attached
4. Use GitHub Copilot Chat to trigger tool calls

#### Debug with VS Code

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch IQPilot (Debug)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build-iqpilot",
      "program": "${workspaceFolder}/src/IQPilot/bin/Debug/net8.0/IQPilot.dll",
      "args": [],
      "cwd": "${workspaceFolder}",
      "console": "internalConsole",
      "stopAtEntry": false
    }
  ]
}
```

### Logging

**Server Logs Location:**
```
%LOCALAPPDATA%\IQPilot\logs\iqpilot-YYYYMMDD.log
```

**Log Levels:**
- **Error**: Critical failures (configuration errors, file access denied)
- **Warning**: Non-critical issues (cache misses, optional features unavailable)
- **Information**: Normal operations (tool invoked, validation completed, metadata synced)
- **Debug**: Detailed diagnostics (MCP protocol messages, cache operations, file events)

### Contributing

See [../../CONTRIBUTING.md](../../CONTRIBUTING.md) for development guidelines and contribution process.

## 🤝 Integration with Documentation Frameworks

### Quarto
Works out of the box with Quarto's YAML frontmatter. IQPilot respects Quarto rendering metadata.

### Jekyll
Compatible with Jekyll frontmatter. Add `layout` to top YAML block, IQPilot manages bottom metadata.

### Hugo
Compatible with Hugo frontmatter. Add `type` and `layout` as needed in top YAML.

### Docusaurus
Works with Docusaurus frontmatter. Add `sidebar_position` in top YAML block.

### MkDocs
Compatible with MkDocs. Place site-generator metadata in frontmatter, validation tracking in bottom HTML comment.

## ⚡ Performance

- **Memory**: ~40-60 MB (self-contained .NET runtime)
- **CPU**: Near-zero when idle; <2% during validation operations
- **Startup**: <3 seconds from VS Code launch
- **Tool Response**: <100ms for metadata operations, 2-10s for AI validations (cached when possible)
- **Validation Caching**: Reduces repeated AI calls by 80-90% for unchanged content

## 🚧 Limitations

1. **Windows Primary**: Tested on Windows, cross-platform support in progress
2. **Markdown Focus**: Optimized for `*.md` files
3. **MCP Protocol**: Requires GitHub Copilot with MCP support (VS Code 1.85.0+)
4. **Embedded Metadata**: Works best with dual YAML architecture (top + bottom HTML comment)

## 🔮 Future Enhancements

- [ ] Cross-platform builds (Linux, macOS)
- [ ] Multi-language support (i18n validation)
- [ ] Custom AI model integration (beyond GitHub Copilot)
- [ ] Batch operation optimization
- [ ] Real-time collaboration features
- [ ] Visual metadata editor UI
- [ ] Integration with CI/CD pipelines

## 📚 Examples

See the main repository for complete examples:
- **[Learn Hub](../../)** - Learning documentation with articles, tutorials, how-tos
- **[IQPilot Documentation](../../idea/IQPilot/)** - Self-documenting with IQPilot
- **[Configuration Examples](../../.iqpilot/)** - Various configuration patterns

## 📄 License

MIT License - see [../../LICENSE](../../LICENSE)

## 🙏 Acknowledgments

IQPilot was created to solve metadata management and content quality challenges in documentation projects. It evolved from a simple automation tool to a comprehensive MCP server framework for AI-assisted content development.

Special thanks to:
- GitHub Copilot team for MCP protocol
- Model Context Protocol community
- All contributors and early adopters

## 📞 Support

- **Documentation**: See [../../GETTING-STARTED.md](../../GETTING-STARTED.md) for setup
- **Conceptual Overview**: [../../idea/IQPilot/01. IQPilot overview.md](../../idea/IQPilot/01.%20IQPilot%20overview.md)
- **Detailed Guide**: [../../idea/IQPilot/02. IQPilot Getting started.md](../../idea/IQPilot/02.%20IQPilot%20Getting%20started.md)
- **Technical Details**: [../../idea/IQPilot/03. IQPilot Implementation details.md](../../idea/IQPilot/03.%20IQPilot%20Implementation%20details.md)
- **Issues**: [GitHub Issues](https://github.com/darioairoldi/Learn/issues)

---

**Made with ❤️ for documentation authors and AI-assisted content development**
