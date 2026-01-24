# Global GitHub Copilot Instructions for Learning Documentation Site

## Repository Architecture

Personal knowledge management system for Microsoft technical content built with **Quarto** for static site generation. The repository combines learning notes, conference analyses, technical articles, and project documentation with an advanced validation system powered by a custom C# MCP server.

### Content Organization

**Primary Folders (numbered for ordering):**
- `01.00 news/` - Latest VS Code releases, tool updates (date-prefixed: YYYYMMDD)
- `02.00 events/` - Conference notes (Build, Ignite) with session summaries
- `03.00 tech/` - Technical articles organized by topic (Azure, .NET, AI, etc.)
- `04.00 howto/` - Step-by-step guides and tutorials
- `05.00 issues/` - Problem solving and troubleshooting notes
- `06.00 idea/` - Project concepts (IQPilot, LearnHub)
- `07.00 projects/` - Active project documentation
- `90.00 travel/` - Personal travel and event planning

**Infrastructure Folders:**
- `.github/` - Instructions, prompts, templates, workflows for AI agents
- `.copilot/` - Context files, scripts, MCP server binaries
- `src/` - Source code for IQPilot MCP server and MetadataWatcher
- `.vscode/` - Workspace settings, tasks, custom extensions
- `scripts/` - PowerShell scripts for navigation, link checking

### Key Architecture Components

1. **Quarto Static Site Generator** (`_quarto.yml`, `*.qmd`)
   - Renders markdown + Quarto files to HTML
   - Output directory: `docs/` (GitHub Pages compatible)
   - Custom styling: `cerulean.scss`, `styles.css`
   - Navigation generated from `_quarto.yml` via `scripts/generate-navigation.ps1`

2. **IQPilot MCP Server** (`src/IQPilot/`)
   - C# .NET 8.0 Model Context Protocol server
   - Provides 16 specialized tools for content validation, metadata management, gap analysis
   - Integrates with GitHub Copilot via MCP protocol
   - Enables validation caching to avoid redundant AI calls
   - Build command: `dotnet build -c Release` from `src/IQPilot/`
   - Published to: `.copilot/mcp-servers/iqpilot/`

3. **MetadataWatcher VS Code Extension** (`.vscode/extensions/metadata-watcher/`)
   - TypeScript extension that monitors file renames
   - Automatically syncs `article_metadata.filename` in validation metadata
   - Setup task: "Setup Metadata Watcher (Full)" in tasks.json
   - Requires Node.js and npm for build

4. **Dual Metadata System** (Critical Pattern)
   - **Top YAML** (file start): Quarto rendering metadata (title, author, date, categories)
     - Edited manually by authors
     - **NEVER modify from validation prompts**
   - **Bottom HTML Comment** (file end): Validation tracking metadata (status, timestamps, scores)
     - Updated only by automation/validation tools
     - Invisible when rendered
   - See `.copilot/context/90.00 learning-hub/02-dual-yaml-metadata.md` for complete guidelines

## Critical Developer Workflows

### Building & Publishing the Site

```powershell
# Preview locally (auto-rebuilds on changes)
quarto preview

# Build static site to docs/ directory
quarto render

# Check if navigation needs regeneration (only if _quarto.yml changed)
.\scripts\generate-navigation.ps1
```

### Setting Up IQPilot (MCP Mode)

```powershell
# One-time setup - builds everything in sequence
# From repository root:
cd src/IQPilot
dotnet build -c Release

# Copy to MCP server location
Copy-Item bin/Release/net8.0/* ../../.copilot/mcp-servers/iqpilot/ -Recurse -Force

# Enable in VS Code settings.json:
# "iqpilot.enabled": true,
# "iqpilot.mode": "mcp"

# Reload VS Code window
# Verify with: Look for status bar indicator "✓ IQPilot MCP (16 tools)"
```

### Running Validations

**Without IQPilot (Standalone Prompts):**
- Reference prompts in `.github/prompts/` directory
- Use via GitHub Copilot: "Run grammar-review.prompt on this article"
- Manual metadata updates required

**With IQPilot (MCP Mode):**
- Tools automatically available via natural language
- Example: "Validate grammar for this article"
- Automatic metadata caching prevents redundant validations within 7 days
- Cross-reference and gap analysis capabilities

### Creating New Articles

1. Use template from `.github/templates/article-template.md`
2. Ensure both YAML blocks present (top for Quarto, bottom for validation)
3. Add to `_quarto.yml` in appropriate section if you want it rendered
4. Run validation prompts before publishing

## Project-Specific Conventions

### File Naming
- Date-prefixed folders: `YYYYMMDD Topic Name/` for events, news, issues
- README.md variations: `README.Sonnet4.md`, `SUMMARY.md` for AI-generated analyses
- Prompt files: `*.prompt.md` in `.github/prompts/`
- Metadata files: `*.metadata.yml` (deprecated - now in HTML comments)

### Reference Classification (Critical for Citations)

All article references MUST be classified with emoji markers:

- 📘 **Official** - `*.microsoft.com`, `learn.microsoft.com`, `docs.github.com`
- 📗 **Verified Community** - `github.blog`, `devblogs.microsoft.com`, academic
- 📒 **Community** - `medium.com`, `dev.to`, personal blogs
- 📕 **Unverified** - Broken links, unknown sources (fix before publishing)

Format: `**[Title](url)** `[📘 Official]`  
Description explaining value and relevance.

See `.github/instructions/documentation.instructions.md` for complete rules.

### Validation Workflow

1. Check validation metadata timestamp (`last_run` in bottom YAML)
2. Skip validation if `< 7 days` AND content unchanged
3. Run appropriate validation (grammar, readability, structure, fact-check, logic)
4. Update only your validation section in bottom metadata
5. **NEVER touch top YAML from validation prompts**

### Code Style (C# Projects)

- Target: .NET 8.0
- Use top-level statements where appropriate
- Async/await for I/O operations
- Follow Microsoft coding conventions
- XML documentation comments for public APIs
- MCP tool implementations in `src/IQPilot/Tools/`

## Integration Points & Dependencies

### External Tools Required
- **Quarto CLI** - Static site generation (primary rendering engine)
- **.NET 8.0 SDK** - IQPilot MCP server compilation
- **Node.js/npm** - MetadataWatcher extension build
- **PowerShell** - Automation scripts (navigation, link checking)
- **yq** (optional) - YAML processing in navigation generation

### VS Code Tasks (`.vscode/tasks.json`)
- `Build MetadataWatcher` - Compile C# watcher
- `Publish MetadataWatcher` - Publish to `.copilot/bin/`
- `Build Extension` - Compile TypeScript extension
- `Setup Metadata Watcher (Full)` - **One-command setup** (runs all prerequisites)

### GitHub Copilot Configuration
```jsonc
// .vscode/settings.json
{
  "iqpilot.enabled": true,      // Enable/disable IQPilot
  "iqpilot.mode": "mcp",        // "mcp" | "prompts-only" | "off"
  "iqpilot.autoStart": true,    // Auto-start MCP server
  "github.copilot.chat.mcp.enabled": true
}
```

## Key Files Reference

**Architecture & Guidance:**
- [.github/STRUCTURE-README.md](.github/STRUCTURE-README.md) - Complete structure documentation
- [GETTING-STARTED.md](GETTING-STARTED.md) - IQPilot setup and usage
- [.iqpilot/README.md](.iqpilot/README.md) - Mode switching guide
- [src/IQPilot/README.md](src/IQPilot/README.md) - MCP server technical docs

**Templates & Standards:**
- [.github/templates/article-template.md](.github/templates/article-template.md) - New article scaffold
- [.copilot/context/90.00 learning-hub/02-dual-yaml-metadata.md](.copilot/context/90.00%20learning-hub/02-dual-yaml-metadata.md) - Metadata parsing rules
- [.github/instructions/documentation.instructions.md](.github/instructions/documentation.instructions.md) - Writing style guide

**Configuration:**
- [_quarto.yml](_quarto.yml) - Site structure and rendering config
- [.vscode/tasks.json](.vscode/tasks.json) - Build and automation tasks
- [.vscode/settings.json](.vscode/settings.json) - Workspace preferences

**Model Preference:** Claude Sonnet 4.5 for complex analysis and generation
