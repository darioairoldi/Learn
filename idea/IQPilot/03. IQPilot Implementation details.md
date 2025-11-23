---
title: "IQPilot Implementation Details"
author: "Dario Airoldi"
date: "2025-11-23"
categories: [documentation, technical, architecture]
description: "Deep dive into IQPilot's architecture, folder structure, and integration with GitHub Copilot, VS Code, and the file system"
---

# IQPilot Implementation Details

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Folder Structure](#folder-structure)
- [GitHub Copilot Integration](#github-copilot-integration)
- [VS Code Integration](#vs-code-integration)
- [File System Integration](#file-system-integration)
- [MCP Protocol Implementation](#mcp-protocol-implementation)
- [Services Architecture](#services-architecture)
- [Configuration System](#configuration-system)
- [Template System](#template-system)
- [Prompt System](#prompt-system)
- [Metadata Management](#metadata-management)
- [Event Flow](#event-flow)

## Architecture Overview

IQPilot consists of three main components that work together:

```
┌─────────────────────────────────────────────────────────────┐
│                        GitHub Copilot                        │
│  (AI Agent - reads instructions, invokes MCP tools)         │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │ MCP Protocol (JSON-RPC)
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                    IQPilot MCP Server                        │
│  (C# .NET 8.0 - provides 16 content tools)                  │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Validation   │  │ Metadata     │  │ Content      │     │
│  │ Tools        │  │ Tools        │  │ Tools        │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌──────────────────────────────────────────────────┐      │
│  │           Services Layer                          │      │
│  │  • ValidationEngine  • MetadataManager           │      │
│  │  • TemplateService   • EventCoordinator          │      │
│  │  • FileWatcherService                            │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │ File System Events
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                   VS Code + File System                      │
│                                                              │
│  VS Code Extension ←→ FileSystemWatcher ←→ File System      │
│  (monitors renames)    (monitors changes)   (*.md files)    │
└──────────────────────────────────────────────────────────────┘
```

**Why This Architecture?**

1. **Separation of Concerns**: AI logic (Copilot), tool implementation (MCP Server), and file monitoring (VS Code + FileWatcher) are separate
2. **Standard Protocols**: Uses MCP (Model Context Protocol) for tool communication - GitHub's standard for AI tool integration
3. **Language Strengths**: C# for robust file handling and background services, TypeScript for VS Code integration
4. **Reliability**: VS Code manages server lifecycle - automatic start/stop, crash recovery

## Folder Structure

IQPilot uses a clear folder structure that separates framework components from site-specific customizations:

### Repository Root

```
your-repository/
├── .github/                      # GitHub-specific automation
│   ├── copilot-instructions.md   # Global Copilot guidelines
│   ├── instructions/             # Path-specific rules
│   ├── prompts/                  # Site-specific validation prompts
│   └── templates/                # Site-specific content templates
│
├── .iqpilot/                     # IQPilot framework (committed)
│   ├── config.default.json       # Framework default configuration
│   ├── config.json               # Site-specific overrides
│   ├── templates/                # Default templates (fallback)
│   ├── prompts/                  # Generic prompts (framework)
│   └── logs/                     # Runtime logs (gitignored)
│
├── .copilot/                     # Rich context for AI
│   ├── context/                  # Domain knowledge
│   │   ├── domain-concepts.md
│   │   ├── style-guide.md
│   │   ├── validation-criteria.md
│   │   └── workflows/
│   ├── scripts/                  # Automation scripts
│   └── mcp-servers/              # MCP server executables
│       └── iqpilot/              # IQPilot MCP server (gitignored)
│
├── src/IQPilot/                  # MCP Server source code
│   ├── Program.cs                # LSP server initialization
│   ├── Server/                   # MCP protocol implementation
│   ├── Tools/                    # MCP tool implementations
│   ├── Services/                 # Core services
│   ├── Models/                   # Data structures
│   └── IQPilot.csproj
│
├── .vscode/                      # VS Code configuration
│   ├── extensions/
│   │   └── iqpilot/              # VS Code extension
│   │       ├── src/extension.ts
│   │       └── package.json
│   ├── tasks.json                # Build tasks
│   ├── launch.json               # Debug configurations
│   └── settings.json             # Workspace settings
│
└── [your content folders]/       # Articles go here
    ├── tech/
    ├── howto/
    └── ...
```

### Why This Structure?

**`.github/` - Site-Specific Automation**
- Prompts and templates tailored to your content
- GitHub Copilot reads `copilot-instructions.md` automatically
- Path-specific instructions applied based on file location

**`.iqpilot/` - Framework Configuration**
- Generic, reusable across any repository
- `config.default.json` = framework defaults
- `config.json` = your overrides (merged at runtime)

**`.copilot/` - AI Context**
- Domain knowledge that makes AI suggestions better
- Workflows guide AI through complex tasks
- Scripts automate repetitive operations

**`src/IQPilot/` - Implementation**
- MCP Server that provides tools to Copilot
- Services for validation, metadata, templates
- Compiled to `.copilot/mcp-servers/iqpilot/`

**`.vscode/` - Integration**
- Extension bridges VS Code events to IQPilot
- Tasks for building and debugging
- Settings configure behavior

## GitHub Copilot Integration

### How Copilot Discovers IQPilot

1. **VS Code starts IQPilot MCP Server** when workspace opens
2. **Copilot queries available tools** via MCP protocol
3. **IQPilot registers 16 tools** (metadata, validation, content, workflow)
4. **Copilot uses tools** based on user requests in chat

### Context Injection

GitHub Copilot reads these files to understand IQPilot:

#### Global Instructions (`copilot-instructions.md`)

```markdown
# GitHub Copilot Instructions for [Your Site]

## IQPilot Integration

This repository uses IQPilot for AI-assisted content development.

### Dual Metadata Structure
- Top YAML: Document properties (title, author, date)
- Bottom YAML in HTML comment: article additional metadata
- **CRITICAL**: Never modify top YAML with validation prompts
- Always update bottom YAML after validation

### Editorial Standards
- Target audience: [describe]
- Readability target: Grade [X]
- Required sections: TOC, Introduction, Conclusion, References
- Validation requirements: Grammar, readability, structure, facts
```

**Why This Matters:**
- Copilot knows about dual metadata structure
- Won't accidentally modify top YAML during validation
- Understands your editorial standards
- Applies site-specific rules automatically

#### Path-Specific Instructions

Located in `.github/instructions/`, automatically applied to matching files:

**`.github/instructions/documentation.instructions.md`**
```yaml
---
description: Instructions for documentation and article content
applyTo: '**/*.md'
---

# Documentation Content Instructions

## Writing Style
- Use active voice whenever possible
- Keep sentences concise (aim for 15-25 words)
...
```

**`.github/instructions/tech-articles.instructions.md`**
```yaml
---
description: Instructions for technical articles and guides
applyTo: 'tech/**/*.md'
---

# Technical Articles Instructions

## Code Examples
- All code must be tested and working
- Include comments for complex logic
...
```

**How It Works:**
1. User opens `tech/docker-guide.md`
2. Copilot sees `applyTo: 'tech/**/*.md'`
3. Automatically applies technical article guidelines
4. Validates code examples, checks prerequisites, etc.

### Tool Invocation Flow

```
User: "Check grammar on this article"
    ↓
GitHub Copilot (reads copilot-instructions.md)
    ↓ Recognizes intent: grammar validation
    ↓ Looks for available tools
    ↓
MCP Protocol: "List available tools"
    ↓
IQPilot Server: "iqpilot/validate/grammar available"
    ↓
Copilot: Invokes tool with article path
    ↓
IQPilot: Runs grammar validation
    ↓
IQPilot: Returns results + updates metadata
    ↓
Copilot: Shows results to user
```

**Natural Language → Tool Mapping:**

| User Request | Copilot Interprets As | Tool Invoked |
|--------------|----------------------|--------------|
| "Check grammar" | Grammar validation needed | `iqpilot/validate/grammar` |
| "Is this readable?" | Readability analysis | `iqpilot/validate/readability` |
| "What's missing?" | Gap analysis | `iqpilot/content/analyze_gaps` |
| "Find related articles" | Cross-reference discovery | `iqpilot/content/find_related` |
| "Ready to publish?" | Comprehensive check | `iqpilot/content/publish_ready` |

**No explicit tool names required** - Copilot maps natural language to appropriate tools.

## VS Code Integration

### VS Code Extension

The IQPilot extension (`.vscode/extensions/iqpilot/`) provides tight integration:

#### Extension Activation

**`src/extension.ts`** (simplified):

```typescript
export function activate(context: vscode.ExtensionContext) {
    // 1. Locate IQPilot MCP Server executable
    const serverPath = findIQPilotServer(context);
    
    // 2. Create LSP client configuration
    const serverOptions: ServerOptions = {
        run: { command: serverPath, args: [] },
        debug: { command: serverPath, args: ['--debug'] }
    };
    
    // 3. Configure which files the server handles
    const clientOptions: LanguageClientOptions = {
        documentSelector: [{ scheme: 'file', language: 'markdown' }],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.md')
        }
    };
    
    // 4. Start the LSP client
    client = new LanguageClient('iqpilot', 'IQPilot', 
                                serverOptions, clientOptions);
    client.start();
    
    // 5. Add status bar indicator
    statusBar = vscode.window.createStatusBarItem(
        vscode.StatusBarAlignment.Right, 100
    );
    statusBar.text = "$(check) IQPilot";
    statusBar.show();
}
```

**What This Does:**

1. **Finds Server**: Looks for `iqpilot.exe` in `.copilot/mcp-servers/iqpilot/`
2. **Starts Server**: Launches MCP server as child process
3. **Monitors Markdown**: Watches all `*.md` files for changes
4. **Status Indicator**: Shows "✓ IQPilot" in status bar
5. **Lifecycle Management**: Stops server when VS Code closes

#### File Event Bridge

VS Code monitors file operations and notifies IQPilot:

```typescript
// Watch for file renames
const renameWatcher = vscode.workspace.onDidRenameFiles(event => {
    event.files.forEach(file => {
        // Send rename event to IQPilot server
        client.sendNotification('iqpilot/fileRenamed', {
            oldPath: file.oldUri.fsPath,
            newPath: file.newUri.fsPath
        });
    });
});
```

**Why This Matters:**
- VS Code knows about renames immediately (user action)
- FileSystemWatcher gets notified later (OS event)
- Extension sends event to IQPilot to avoid duplicate processing
- EventCoordinator deduplicates events from both sources

#### Commands

Extension registers commands accessible via Command Palette:

```typescript
// Ctrl+Shift+P → "IQPilot: Restart Server"
vscode.commands.registerCommand('iqpilot.restart', () => {
    client.stop();
    client.start();
});

// Ctrl+Shift+P → "IQPilot: Show Logs"
vscode.commands.registerCommand('iqpilot.showLogs', () => {
    const logPath = path.join(workspace, '.iqpilot/logs/iqpilot.log');
    vscode.workspace.openTextDocument(logPath).then(doc => {
        vscode.window.showTextDocument(doc);
    });
});
```

### Configuration

Settings in `.vscode/settings.json`:

```json
{
  "iqpilot.enabled": true,
  "iqpilot.logLevel": "Information",
  "iqpilot.serverPath": ".copilot/mcp-servers/iqpilot/iqpilot.exe",
  "iqpilot.autoValidateOnSave": true,
  "iqpilot.autoSyncMetadata": true
}
```

**User can adjust:**
- Enable/disable IQPilot
- Log verbosity (Error, Warning, Information, Debug)
- Custom server path
- Automatic validation triggers

## File System Integration

### FileSystemWatcher Service

**Problem:** Need to detect when users rename articles to sync metadata automatically.

**Solution:** .NET `FileSystemWatcher` monitors file system events in real-time.

#### Implementation (`Services/FileWatcherService.cs`)

```csharp
public class FileWatcherService : BackgroundService
{
    private readonly FileSystemWatcher _watcher;
    private readonly EventCoordinator _coordinator;
    private readonly MetadataManager _metadataManager;
    
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        // Configure watcher
        _watcher.Path = _workspaceRoot;
        _watcher.Filter = "*.md";
        _watcher.IncludeSubdirectories = true;
        _watcher.NotifyFilter = NotifyFilters.FileName;
        
        // Subscribe to rename events
        _watcher.Renamed += OnFileRenamed;
        
        // Start watching
        _watcher.EnableRaisingEvents = true;
        
        await Task.Delay(Timeout.Infinite, stoppingToken);
    }
    
    private void OnFileRenamed(object sender, RenamedEventArgs e)
    {
        // Send to EventCoordinator for deduplication
        _coordinator.ProcessRenameEvent(new RenameEvent
        {
            Source = EventSource.FileSystem,
            OldPath = e.OldFullPath,
            NewPath = e.FullPath,
            Timestamp = DateTime.UtcNow
        });
    }
}
```

**How It Works:**

1. **Monitors Workspace**: Watches all `*.md` files recursively
2. **Detects Renames**: OS notifies watcher when files are renamed
3. **Coordinates Events**: Sends to EventCoordinator (see next section)
4. **Background Service**: Runs continuously while VS Code is open

### EventCoordinator

**Problem:** Rename events come from two sources (VS Code Extension + FileSystemWatcher). Need to process each event once.

**Solution:** EventCoordinator deduplicates events within a time window.

#### Implementation (`Services/EventCoordinator.cs`)

```csharp
public class EventCoordinator
{
    private readonly ConcurrentDictionary<string, RenameEvent> _recentEvents;
    private readonly TimeSpan _deduplicationWindow = TimeSpan.FromMilliseconds(500);
    
    public void ProcessRenameEvent(RenameEvent renameEvent)
    {
        string eventKey = $"{renameEvent.OldPath}→{renameEvent.NewPath}";
        
        // Check if we've seen this event recently
        if (_recentEvents.TryGetValue(eventKey, out var existingEvent))
        {
            var timeSinceFirst = DateTime.UtcNow - existingEvent.Timestamp;
            
            if (timeSinceFirst < _deduplicationWindow)
            {
                // Duplicate event - ignore
                _logger.LogDebug(
                    "Duplicate rename event ignored: {EventKey} from {Source}",
                    eventKey, renameEvent.Source
                );
                return;
            }
        }
        
        // New event - process and remember
        _recentEvents[eventKey] = renameEvent;
        
        // Clean up old events
        CleanupOldEvents();
        
        // Process the rename
        ProcessRename(renameEvent.OldPath, renameEvent.NewPath);
    }
    
    private void ProcessRename(string oldPath, string newPath)
    {
        // 1. Rename metadata file
        string oldMetadata = Path.ChangeExtension(oldPath, ".metadata.yml");
        string newMetadata = Path.ChangeExtension(newPath, ".metadata.yml");
        
        if (File.Exists(oldMetadata))
        {
            File.Move(oldMetadata, newMetadata);
        }
        
        // 2. Update filename field inside YAML
        _metadataManager.UpdateFilename(newMetadata, 
                                       Path.GetFileName(newPath));
        
        _logger.LogInformation(
            "Metadata synchronized: {OldPath} → {NewPath}", 
            oldPath, newPath
        );
    }
}
```

**Deduplication Strategy:**

1. **Event Key**: Combine old + new path as unique identifier
2. **Time Window**: 500ms window to catch duplicates
3. **First Event Wins**: Process first event, ignore subsequent duplicates
4. **Cleanup**: Remove old events after window expires

**Why 500ms?**
- VS Code extension sends event immediately (user action)
- FileSystemWatcher notifies 100-300ms later (OS event)
- 500ms catches both without delaying processing

### Monitoring Multiple Sources

```
User renames file in VS Code Explorer (F2)
    ↓
VS Code Extension detects (onDidRenameFiles)
    ├─→ Sends notification to IQPilot server
    │
    ↓ (100-300ms later)
    │
OS File System detects rename
    ├─→ FileSystemWatcher raises event
    │
    ↓
Both events arrive at EventCoordinator
    ├─→ First event: Process rename + sync metadata
    ├─→ Second event: Duplicate detected, ignored
```

**Benefits:**

- ✅ **Reliability**: Multiple sources = no missed events
- ✅ **Efficiency**: Deduplication = no duplicate processing
- ✅ **Speed**: VS Code extension = immediate response
- ✅ **Fallback**: FileSystemWatcher = catches external renames

## MCP Protocol Implementation

### What is MCP?

**Model Context Protocol (MCP)** is GitHub's standard for AI tool integration. It allows AI models (like Copilot) to invoke external tools in a standardized way.

**Key Concepts:**

- **Server**: Provides tools (IQPilot)
- **Client**: Uses tools (GitHub Copilot)
- **Tools**: Discrete capabilities with inputs/outputs
- **JSON-RPC**: Communication protocol

### Server Initialization

**`Program.cs`** (simplified):

```csharp
public class Program
{
    public static async Task Main(string[] args)
    {
        // 1. Configure logging
        var logPath = Path.Combine(workspace, ".iqpilot/logs/iqpilot.log");
        
        // 2. Build service container
        var services = new ServiceCollection()
            .AddLogging(builder => builder.AddFile(logPath))
            .AddSingleton<MetadataManager>()
            .AddSingleton<ValidationEngine>()
            .AddSingleton<TemplateService>()
            .AddSingleton<EventCoordinator>()
            .AddHostedService<FileWatcherService>()
            .BuildServiceProvider();
        
        // 3. Create MCP server
        var server = await OmniSharp.Extensions.LanguageServer.Server
            .LanguageServer.From(options => options
                .WithInput(Console.OpenStandardInput())
                .WithOutput(Console.OpenStandardOutput())
                .WithServices(services)
                .WithHandler<IQPilotToolHandler>()
            );
        
        // 4. Start server and wait for shutdown
        await server.WaitForExit;
    }
}
```

**What Happens:**

1. **Logging**: Creates log file at `.iqpilot/logs/iqpilot.log`
2. **Dependency Injection**: Registers all services
3. **MCP Server**: Listens on stdin/stdout (JSON-RPC)
4. **Tool Registration**: Registers tool handler
5. **Blocking**: Waits for exit signal from VS Code

### Tool Registration

**`Tools/IQPilotToolHandler.cs`** (simplified):

```csharp
public class IQPilotToolHandler : IToolHandler
{
    private readonly MetadataManager _metadata;
    private readonly ValidationEngine _validation;
    
    public Task<ToolResponse> HandleTool(ToolRequest request)
    {
        return request.ToolName switch
        {
            // Metadata tools
            "iqpilot/metadata/get" => GetMetadata(request),
            "iqpilot/metadata/update" => UpdateMetadata(request),
            "iqpilot/metadata/validate" => ValidateMetadata(request),
            
            // Validation tools
            "iqpilot/validate/grammar" => ValidateGrammar(request),
            "iqpilot/validate/readability" => ValidateReadability(request),
            "iqpilot/validate/structure" => ValidateStructure(request),
            "iqpilot/validate/all" => ValidateAll(request),
            
            // Content tools
            "iqpilot/content/create" => CreateContent(request),
            "iqpilot/content/analyze_gaps" => AnalyzeGaps(request),
            "iqpilot/content/find_related" => FindRelated(request),
            "iqpilot/content/publish_ready" => PublishReady(request),
            
            // Workflow tools
            "iqpilot/workflow/article_creation" => ArticleCreation(request),
            "iqpilot/workflow/review" => ReviewWorkflow(request),
            "iqpilot/workflow/series_planning" => SeriesPlanning(request),
            
            _ => Task.FromResult(ToolResponse.Error($"Unknown tool: {request.ToolName}"))
        };
    }
}
```

**Tool Naming Convention:**
- `iqpilot/` prefix = namespace
- `category/` = metadata, validate, content, workflow
- `action` = get, update, grammar, etc.

### Request/Response Flow

**Example: Grammar Validation**

**1. Copilot sends request (JSON-RPC):**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/invoke",
  "params": {
    "toolName": "iqpilot/validate/grammar",
    "arguments": {
      "filePath": "e:/docs/tech/article.md"
    }
  }
}
```

**2. IQPilot processes:**

```csharp
private async Task<ToolResponse> ValidateGrammar(ToolRequest request)
{
    string filePath = request.Arguments["filePath"];
    
    // Read article content
    string content = await File.ReadAllTextAsync(filePath);
    
    // Run validation (delegates to ValidationEngine)
    var result = await _validation.ValidateGrammar(content);
    
    // Update metadata
    await _metadata.UpdateValidation(filePath, "grammar", result);
    
    // Return results
    return new ToolResponse
    {
        Success = true,
        Data = new
        {
            passed = result.Passed,
            issues_found = result.Issues.Count,
            issues = result.Issues,
            timestamp = DateTime.UtcNow
        }
    };
}
```

**3. IQPilot responds (JSON-RPC):**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "success": true,
    "data": {
      "passed": false,
      "issues_found": 2,
      "issues": [
        "Line 5: 'it's' should be 'its' (possessive)",
        "Line 12: Missing comma after introductory phrase"
      ],
      "timestamp": "2025-11-23T10:30:00Z"
    }
  }
}
```

**4. Copilot shows to user:**

```
Grammar check found 2 issues:

1. Line 5: 'it's' should be 'its' (possessive)
2. Line 12: Missing comma after introductory phrase

Metadata updated with validation results.
```

## Services Architecture

IQPilot is built with a layered services architecture:

### ValidationEngine

**Purpose:** Performs all content validation checks.

**Responsibilities:**
- Grammar and spelling analysis
- Readability scoring (Flesch-Kincaid)
- Structure validation (TOC, sections, headings)
- Fact-checking coordination
- Logic flow analysis

**Key Methods:**

```csharp
public class ValidationEngine
{
    public async Task<ValidationResult> ValidateGrammar(string content);
    public async Task<ValidationResult> ValidateReadability(string content);
    public async Task<ValidationResult> ValidateStructure(string content);
    public async Task<ValidationResult> ValidateFacts(string content);
    public async Task<ValidationResult> ValidateLogic(string content);
    public async Task<ValidationResult> ValidateAll(string content);
}
```

**How It Works:**

1. **Receives content** from tool handler
2. **Applies validation rules** from configuration
3. **Returns results** with pass/fail + details
4. **No metadata updates** - only validation logic

### MetadataManager

**Purpose:** Manages all metadata operations.

**Responsibilities:**
- Parse dual YAML blocks from articles
- Update validation results in bottom YAML
- Sync filename field on renames
- Validate metadata schema
- Preserve user customizations

**Key Methods:**

```csharp
public class MetadataManager
{
    // Parsing
    public async Task<ArticleMetadata> GetMetadata(string filePath);
    
    // Updates
    public async Task UpdateValidation(string filePath, string validationType, 
                                      ValidationResult result);
    public async Task UpdateFilename(string filePath, string newFilename);
    public async Task UpdateField(string filePath, string fieldPath, object value);
    
    // Validation
    public async Task<MetadataValidationResult> ValidateMetadata(string filePath);
}
```

**Dual Metadata Handling:**

```csharp
public async Task<ArticleMetadata> GetMetadata(string filePath)
{
    string content = await File.ReadAllTextAsync(filePath);
    
    // 1. Extract top YAML (between first --- and ---)
    var topYaml = ExtractTopYaml(content);
    
    // 2. Extract bottom YAML (inside HTML comment at end)
    var bottomYaml = ExtractBottomYaml(content);
    
    // 3. Parse both with YamlDotNet
    var metadata = new ArticleMetadata
    {
        // From top YAML
        Title = topYaml["title"],
        Author = topYaml["author"],
        Date = topYaml["date"],
        
        // From bottom YAML
        Validations = bottomYaml["validations"],
        ArticleMetadata = bottomYaml["article_metadata"],
        CrossReferences = bottomYaml["cross_references"]
    };
    
    return metadata;
}
```

**Critical Rule:** MetadataManager NEVER modifies top YAML. Only bottom YAML is updated by validation tools.

### TemplateService

**Purpose:** Manages article templates and variable substitution.

**Responsibilities:**
- Load embedded default templates
- Load site-specific templates from `.github/templates/`
- Resolve template priority (site > default)
- Substitute variables (${title}, ${author}, ${date}, etc.)

**Key Methods:**

```csharp
public class TemplateService
{
    public async Task<string> GetTemplate(string templateName);
    public async Task<string> CreateFromTemplate(string templateName, 
                                                 Dictionary<string, string> variables);
    public IEnumerable<string> ListTemplates();
}
```

**Template Resolution:**

```csharp
public async Task<string> GetTemplate(string templateName)
{
    // 1. Check site-specific templates first
    string sitePath = Path.Combine(_workspaceRoot, 
                                   ".github/templates", 
                                   $"{templateName}.md");
    if (File.Exists(sitePath))
    {
        return await File.ReadAllTextAsync(sitePath);
    }
    
    // 2. Fall back to embedded defaults
    var assembly = Assembly.GetExecutingAssembly();
    string resourceName = $"IQPilot.Templates.{templateName}.md";
    
    using var stream = assembly.GetManifestResourceStream(resourceName);
    using var reader = new StreamReader(stream);
    return await reader.ReadToEndAsync();
}
```

**Why Embedded Resources?**
- Framework ships with default templates
- Users can override by creating `.github/templates/`
- No external dependencies required

### EventCoordinator

**Purpose:** Deduplicates file system events from multiple sources.

**Covered in detail in [File System Integration](#file-system-integration).**

### FileWatcherService

**Purpose:** Monitors file system for rename events.

**Covered in detail in [File System Integration](#file-system-integration).**

## Configuration System

### Configuration Hierarchy

IQPilot uses a two-tier configuration system:

```
.iqpilot/config.default.json  (Framework defaults - committed)
    ↓ Merged with ↓
.iqpilot/config.json          (Site overrides - committed)
    ↓ Results in ↓
Runtime Configuration         (In-memory merged config)
```

### Default Configuration

**`.iqpilot/config.default.json`** (framework level):

```json
{
  "site": {
    "name": "Documentation Site",
    "type": "documentation",
    "author": "",
    "repository": ""
  },
  "validation": {
    "grammar": {
      "enabled": true,
      "autoFix": false
    },
    "readability": {
      "enabled": true,
      "targetGradeLevel": 9,
      "fleschScoreMin": 60,
      "fleschScoreMax": 80
    },
    "structure": {
      "enabled": true,
      "requireTOC": true,
      "requireIntroduction": true,
      "requireConclusion": true,
      "requireReferences": true
    },
    "facts": {
      "enabled": true,
      "requireSources": true
    }
  },
  "templates": {
    "directory": ".github/templates",
    "useDefaults": true
  },
  "workflows": {
    "autoValidateOnSave": false,
    "autoSyncMetadata": true,
    "requirePublishCheck": true
  },
  "filePatterns": {
    "articles": "**/*.md",
    "exclude": [
      "**/node_modules/**",
      "**/README.md",
      "**/.git/**"
    ]
  }
}
```

### Site-Specific Overrides

**`.iqpilot/config.json`** (your site):

```json
{
  "site": {
    "name": "Learn Hub",
    "type": "learning",
    "author": "Dario Airoldi",
    "repository": "https://github.com/darioairoldi/Learn"
  },
  "validation": {
    "readability": {
      "targetGradeLevel": 8,
      "fleschScoreMin": 65
    }
  }
}
```

**Merge Result (runtime):**

```json
{
  "site": {
    "name": "Learn Hub",                    // ← Override
    "type": "learning",                     // ← Override
    "author": "Dario Airoldi",             // ← Override
    "repository": "https://github.com/..." // ← Override
  },
  "validation": {
    "grammar": {
      "enabled": true,                      // ← Default
      "autoFix": false                      // ← Default
    },
    "readability": {
      "enabled": true,                      // ← Default
      "targetGradeLevel": 8,               // ← Override
      "fleschScoreMin": 65,                // ← Override
      "fleschScoreMax": 80                 // ← Default
    },
    // ... rest from defaults
  }
}
```

**Merge Strategy:**
- Deep merge (not shallow replace)
- Site values override defaults
- Missing site values use defaults
- Arrays are replaced (not merged)

### Configuration Loading

```csharp
public class ConfigurationService
{
    public IQPilotConfig LoadConfiguration(string workspaceRoot)
    {
        // 1. Load framework defaults (always exists - embedded resource)
        var defaultConfig = LoadEmbeddedDefaults();
        
        // 2. Load site overrides (may not exist)
        string sitePath = Path.Combine(workspaceRoot, 
                                      ".iqpilot/config.json");
        var siteConfig = File.Exists(sitePath) 
            ? JsonSerializer.Deserialize<IQPilotConfig>(
                File.ReadAllText(sitePath))
            : null;
        
        // 3. Merge
        var merged = MergeConfigurations(defaultConfig, siteConfig);
        
        // 4. Validate
        ValidateConfiguration(merged);
        
        return merged;
    }
}
```

## Template System

### Template Types

IQPilot provides several built-in templates:

| Template | Purpose | Use Case |
|----------|---------|----------|
| `article` | General technical article | Technical deep dives, concept explanations |
| `howto` | Step-by-step guide | Task-oriented instructions |
| `tutorial` | Multi-step learning path | Educational content, courses |
| `issue` | Problem + solution | Troubleshooting, FAQs |
| `recording-summary` | Conference/video notes | Event summaries, talk notes |
| `recording-analysis` | Deep analysis | Detailed analysis of talks/papers |
| `api-reference` | API documentation | Endpoint documentation |

### Template Structure

**Example: `article-template.md`**

```markdown
---
title: "${title}"
author: "${author}"
date: "${date}"
categories: [${categories}]
description: "${description}"
---

# ${title}

## Table of Contents

- [Introduction](#introduction)
- [Main Content](#main-content)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

${introduction}

## Main Content

${main_content}

## Conclusion

${conclusion}

## References

${references}

<!-- 
---
validations:
  grammar:
    last_run: null
    outcome: null
  readability:
    last_run: null
    outcome: null
  structure:
    last_run: null
    outcome: null

article_metadata:
  filename: "${filename}"
  created_date: "${date}"
  last_updated: "${date}"
  word_count: 0
  article_type: "article"

cross_references:
  related_articles: []
  topics: []
---
-->
```

### Variable Substitution

When creating from template:

```csharp
var variables = new Dictionary<string, string>
{
    ["title"] = "Docker Basics",
    ["author"] = "Dario Airoldi",
    ["date"] = "2025-11-23",
    ["categories"] = "tech, docker, containers",
    ["description"] = "Introduction to Docker containers",
    ["filename"] = "docker-basics.md"
};

string content = await _templateService.CreateFromTemplate(
    "article", variables
);
```

**Result:**

```markdown
---
title: "Docker Basics"
author: "Dario Airoldi"
date: "2025-11-23"
categories: [tech, docker, containers]
description: "Introduction to Docker containers"
---

# Docker Basics
...
```

### Custom Templates

Users can add custom templates in `.github/templates/`:

**`.github/templates/api-endpoint-template.md`:**

```markdown
---
title: "${endpoint_name} API"
author: "${author}"
date: "${date}"
categories: [api, reference]
---

# ${endpoint_name}

## Endpoint

\`\`\`
${http_method} ${endpoint_path}
\`\`\`

## Parameters

${parameters}

## Response

${response_schema}

## Example Request

\`\`\`bash
curl -X ${http_method} ${base_url}${endpoint_path} \\
  -H "Authorization: Bearer ${token}"
\`\`\`

## Example Response

\`\`\`json
${example_response}
\`\`\`
```

**Usage:**

```
User: "Create API documentation for GET /users endpoint"

Copilot: Invokes iqpilot/content/create with:
  - templateName: "api-endpoint"
  - variables: { endpoint_name: "List Users", http_method: "GET", ... }
```

## Prompt System

### Prompt Types

IQPilot uses two types of prompts:

**1. Generic Prompts (Framework Level)**

Located in `.iqpilot/prompts/`, embedded as resources:

- Validation prompts (grammar, readability, structure)
- Analysis prompts (gap analysis, logic flow)
- Content prompts (creation, improvement)

These work with any content, no domain assumptions.

**2. Site-Specific Prompts (Repository Level)**

Located in `.github/prompts/`:

- Customized validation criteria
- Domain-specific checks
- Site editorial standards
- Specialized workflows

### Prompt Structure

**Example: Grammar Validation Prompt**

**`.iqpilot/prompts/grammar-validation.prompt.md`:**

```markdown
---
name: grammar-validation
description: Check grammar, spelling, and punctuation
inputs:
  - name: content
    type: string
    description: Article content to validate
  - name: standards
    type: string
    description: Editorial standards (from config)
outputs:
  - passed: boolean
  - issues: array of strings
  - suggestions: array of strings
---

# Grammar Validation Prompt

You are a professional editor reviewing technical documentation.

## Task

Check the following content for grammar, spelling, and punctuation errors.

## Content

${content}

## Editorial Standards

${standards}

## Instructions

1. Identify all grammar errors
2. Identify all spelling mistakes
3. Check punctuation correctness
4. Consider technical terminology (may not be in dictionary)
5. Return results in structured format

## Output Format

Return JSON:

\`\`\`json
{
  "passed": true/false,
  "issues": [
    "Line X: error description"
  ],
  "suggestions": [
    "suggestion for improvement"
  ]
}
\`\`\`
```

### Prompt Loading

```csharp
public class PromptService
{
    public async Task<string> LoadPrompt(string promptName, 
                                        Dictionary<string, string> variables)
    {
        // 1. Try site-specific first
        string sitePath = Path.Combine(_workspaceRoot, 
                                      ".github/prompts", 
                                      $"{promptName}.prompt.md");
        
        string template;
        if (File.Exists(sitePath))
        {
            template = await File.ReadAllTextAsync(sitePath);
        }
        else
        {
            // 2. Fall back to embedded generic
            template = LoadEmbeddedPrompt(promptName);
        }
        
        // 3. Substitute variables
        foreach (var kvp in variables)
        {
            template = template.Replace($"${{{kvp.Key}}}", kvp.Value);
        }
        
        return template;
    }
}
```

### Context Injection

Prompts can reference configuration values:

```markdown
## Readability Target

Target grade level: ${config.validation.readability.targetGradeLevel}
Target Flesch score: ${config.validation.readability.fleschScoreMin} - ${config.validation.readability.fleschScoreMax}
```

**At runtime:**

```csharp
var variables = new Dictionary<string, string>
{
    ["content"] = articleContent,
    ["config.validation.readability.targetGradeLevel"] = 
        config.Validation.Readability.TargetGradeLevel.ToString(),
    ["config.validation.readability.fleschScoreMin"] = 
        config.Validation.Readability.FleschScoreMin.ToString(),
    ["config.validation.readability.fleschScoreMax"] = 
        config.Validation.Readability.FleschScoreMax.ToString()
};
```

## Metadata Management

### Dual Metadata Architecture

Every article contains two separate YAML blocks:

#### Top YAML (Quarto/Jekyll/Hugo Metadata)

```yaml
---
title: "Article Title"
author: "Your Name"
date: "2025-11-23"
categories: [tech, tutorial]
description: "SEO description"
---
```

**Purpose:** Site generator metadata  
**Modified by:** Authors (manually)  
**Used by:** Quarto/Jekyll/Hugo for rendering  
**Visibility:** Visible in source, used in rendered output

#### Bottom YAML (Article Additional Metadata)

```html
<!-- 
---
validations:
  grammar:
    last_run: "2025-11-23T10:30:00Z"
    model: "claude-sonnet-4"
    tool: "iqpilot/validate/grammar"
    outcome: "passed"
    issues_found: 0
  readability:
    last_run: "2025-11-23T10:30:00Z"
    flesch_score: 65.3
    grade_level: 9.2
    outcome: "passed"
  structure:
    last_run: "2025-11-23T10:30:00Z"
    outcome: "passed"
    has_toc: true
    has_introduction: true

article_metadata:
  filename: "article.md"
  created_date: "2025-11-20"
  last_updated: "2025-11-23"
  word_count: 2500
  article_type: "tutorial"

cross_references:
  related_articles:
    - "related-article-1.md"
    - "related-article-2.md"
  topics:
    - "docker"
    - "containers"
---
-->
```

**Purpose:** Validation tracking, analytics, cross-references  
**Modified by:** IQPilot validation tools + FileWatcherService  
**Used by:** IQPilot for optimization (caching validation results)  
**Visibility:** **Completely hidden** (HTML comment, not rendered)

### Metadata Update Flow

```
User: "Check grammar"
    ↓
GitHub Copilot → IQPilot: iqpilot/validate/grammar
    ↓
ValidationEngine.ValidateGrammar()
    ├─→ Runs grammar check
    ├─→ Returns ValidationResult
    ↓
MetadataManager.UpdateValidation()
    ├─→ Reads bottom YAML from article
    ├─→ Updates validations.grammar section
    ├─→ Preserves all other metadata
    ├─→ Writes updated YAML back (in HTML comment)
    ↓
Article file updated with new validation timestamp
```

**Critical Rules:**

1. ❌ **Never modify top YAML** with validation tools
2. ✅ **Always update bottom YAML** after validation
3. ✅ **Preserve existing metadata** (don't overwrite user data)
4. ✅ **HTML comment wrapper** ensures invisibility
5. ✅ **Atomic updates** (read-modify-write as single operation)

### Metadata Schema

**`Models/ArticleMetadata.cs`:**

```csharp
public class ArticleMetadata
{
    // Top YAML (not modified by IQPilot)
    public string Title { get; set; }
    public string Author { get; set; }
    public DateTime Date { get; set; }
    public List<string> Categories { get; set; }
    public string Description { get; set; }
    
    // Bottom YAML (managed by IQPilot)
    public ValidationMetadata Validations { get; set; }
    public ArticleInfo ArticleMetadata { get; set; }
    public CrossReferences CrossReferences { get; set; }
}

public class ValidationMetadata
{
    public ValidationEntry Grammar { get; set; }
    public ValidationEntry Readability { get; set; }
    public ValidationEntry Structure { get; set; }
    public ValidationEntry Facts { get; set; }
    public ValidationEntry Logic { get; set; }
}

public class ValidationEntry
{
    public DateTime? LastRun { get; set; }
    public string Model { get; set; }
    public string Tool { get; set; }
    public string Outcome { get; set; } // "passed", "failed", "warning"
    public int IssuesFound { get; set; }
    public List<string> Issues { get; set; }
    public Dictionary<string, object> Metrics { get; set; }
}
```

## Event Flow

### Complete Workflow Example

Let's trace a complete workflow from user action to final result:

#### Scenario: User Renames Article

**Step 1: User Action**

```
User: Right-clicks "docker-guide.md" in VS Code Explorer
      → Selects "Rename" (F2)
      → Types "docker-basics.md"
      → Presses Enter
```

**Step 2: VS Code Extension Detects**

```typescript
vscode.workspace.onDidRenameFiles(event => {
    // VS Code immediate notification
    event.files.forEach(file => {
        client.sendNotification('iqpilot/fileRenamed', {
            oldPath: "e:/docs/tech/docker-guide.md",
            newPath: "e:/docs/tech/docker-basics.md",
            timestamp: Date.now()
        });
    });
});
```

**Step 3: FileSystemWatcher Detects (100-300ms later)**

```csharp
_watcher.Renamed += (sender, e) => {
    _coordinator.ProcessRenameEvent(new RenameEvent
    {
        Source = EventSource.FileSystem,
        OldPath = "e:/docs/tech/docker-guide.md",
        NewPath = "e:/docs/tech/docker-basics.md",
        Timestamp = DateTime.UtcNow
    });
};
```

**Step 4: EventCoordinator Deduplicates**

```csharp
ProcessRenameEvent(renameEvent)
{
    string key = "docker-guide.md→docker-basics.md";
    
    if (_recentEvents.ContainsKey(key))
    {
        // Duplicate detected (from FileSystemWatcher)
        // First event already processed (from VS Code)
        return; // Ignore
    }
    
    // First event (from VS Code Extension)
    _recentEvents[key] = renameEvent;
    ProcessRename(oldPath, newPath);
}
```

**Step 5: Metadata Synchronization**

```csharp
ProcessRename(oldPath, newPath)
{
    // 1. Rename metadata file
    File.Move("docker-guide.metadata.yml", 
             "docker-basics.metadata.yml");
    
    // 2. Update filename field inside YAML
    _metadataManager.UpdateFilename(
        "docker-basics.metadata.yml",
        "docker-basics.md"
    );
    
    _logger.LogInformation(
        "Metadata synchronized: docker-guide.md → docker-basics.md"
    );
}
```

**Step 6: User Sees Result**

```
Status Bar: "✓ IQPilot" (no errors)
Log File: "Metadata synchronized: docker-guide.md → docker-basics.md"

Before:
  docker-guide.md
  docker-guide.metadata.yml

After:
  docker-basics.md
  docker-basics.metadata.yml (filename field updated)
```

**Total Time: <500ms**

#### Scenario: User Validates Grammar

**Step 1: User Request**

```
User types in Copilot Chat: "Check grammar on docker-basics.md"
```

**Step 2: Copilot Interprets**

```
GitHub Copilot:
  1. Reads copilot-instructions.md (knows about IQPilot)
  2. Identifies intent: grammar validation
  3. Queries available tools via MCP
  4. Finds: iqpilot/validate/grammar
  5. Prepares tool invocation
```

**Step 3: MCP Request**

```json
{
  "jsonrpc": "2.0",
  "method": "tools/invoke",
  "params": {
    "toolName": "iqpilot/validate/grammar",
    "arguments": {
      "filePath": "e:/docs/tech/docker-basics.md"
    }
  }
}
```

**Step 4: IQPilot Processes**

```csharp
// Tool Handler receives request
var result = await _validation.ValidateGrammar(filePath);

// Validation Engine processes
var issues = new List<string>();
// ... analysis logic ...

// Metadata Manager updates bottom YAML
await _metadata.UpdateValidation(filePath, "grammar", result);
```

**Step 5: MCP Response**

```json
{
  "jsonrpc": "2.0",
  "result": {
    "passed": false,
    "issues_found": 2,
    "issues": [
      "Line 5: 'it's' should be 'its' (possessive)",
      "Line 12: Missing comma after introductory phrase"
    ],
    "timestamp": "2025-11-23T10:30:00Z"
  }
}
```

**Step 6: Copilot Displays**

```
Grammar check found 2 issues:

1. Line 5: 'it's' should be 'its' (possessive)
   Suggested fix: "its functionality" (possessive, not contraction)

2. Line 12: Missing comma after introductory phrase
   Suggested fix: "In this example, we'll..."

Metadata has been updated with validation results.
```

**Step 7: Bottom YAML Updated**

```yaml
validations:
  grammar:
    last_run: "2025-11-23T10:30:00Z"
    model: "claude-sonnet-4"
    tool: "iqpilot/validate/grammar"
    outcome: "failed"
    issues_found: 2
```

**Total Time: 2-5 seconds (depending on article length)**

## Summary

### Key Integration Points

1. **GitHub Copilot**
   - Reads `.github/copilot-instructions.md` for context
   - Applies path-specific instructions automatically
   - Invokes IQPilot tools via MCP protocol
   - No explicit tool names needed (natural language)

2. **VS Code**
   - Extension starts/stops IQPilot server
   - Monitors file renames immediately
   - Status bar shows server health
   - Commands for restart/logs

3. **File System**
   - FileSystemWatcher monitors `*.md` files
   - EventCoordinator deduplicates events
   - Metadata synced automatically on rename
   - No manual intervention required

### Architecture Benefits

✅ **Reliability**: Multiple event sources, deduplication ensures no missed events  
✅ **Performance**: Background services, async operations, optimized caching  
✅ **Maintainability**: Clear separation of concerns, dependency injection  
✅ **Extensibility**: Plugin architecture for new validation types  
✅ **Configurability**: Everything controlled via JSON configuration  
✅ **Content Agnostic**: Works with any Markdown content anywhere  
✅ **Location Independent**: GitHub, local, cloud - works everywhere

### Critical Design Decisions

**Why C# for MCP Server?**
- Robust file system handling (FileSystemWatcher)
- Strong typing and dependency injection
- Background services (FileWatcherService)
- Mature ecosystem (YamlDotNet, OmniSharp)

**Why TypeScript for VS Code Extension?**
- Native VS Code extension language
- Direct access to VS Code APIs
- Standard for editor integrations

**Why MCP Protocol?**
- GitHub's standard for AI tool integration
- Well-documented, proven protocol
- Direct Copilot support

**Why Dual Metadata?**
- Top YAML: Site generator needs (Quarto/Jekyll/Hugo)
- Bottom YAML: IQPilot optimization (cache validation results)
- HTML comment: Complete invisibility in rendered output
- Clean separation: Manual vs. automatic updates

**Why Event Deduplication?**
- Rename events from VS Code + OS
- Process once, avoid duplicate work
- 500ms window catches both sources
- Reliability + efficiency

### Next Steps

For practical usage guidance, see:
- **[IQPilot Overview](01.%20IQPilot%20overview.md)** - Philosophy and use cases
- **[IQPilot Getting Started](02.%20IQPilot%20Getting%20started.md)** - Installation and usage

For development:
- **Source Code**: `src/IQPilot/` - All implementation details
- **VS Code Extension**: `.vscode/extensions/iqpilot/` - Integration code
- **Build Script**: `.copilot/scripts/build-iqpilot.ps1` - Automated build

---

<!-- 
---
validations:
  grammar:
    last_run: "2025-11-23"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    issues_found: 0
  readability:
    last_run: "2025-11-23"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    flesch_score: 52.3
    grade_level: 12
  structure:
    last_run: "2025-11-23"
    model: "claude-sonnet-4"
    tool: "manual-review"
    outcome: "passed"
    has_toc: true
    has_introduction: true
    has_conclusion: true
    has_references: false

article_metadata:
  filename: "03. IQPilot Implementation details.md"
  created_date: "2025-11-23"
  last_updated: "2025-11-23"
  word_count: 8500
  estimated_reading_time: "43 min"
  article_type: "technical-reference"

cross_references:
  related_articles:
    - "01. IQPilot overview.md"
    - "02. IQPilot Getting started.md"
  topics:
    - "architecture"
    - "implementation"
    - "mcp protocol"
    - "github copilot"
    - "vs code integration"
    - "file system"
---
-->
