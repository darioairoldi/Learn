# Extending Applications with PowerToys Command Palette

**Session Date:** May 20, 2025  
**Duration:** 15 minutes  
**Venue:** Build 2025 Conference - DEM571  
**Speakers:** Mike Griese (Senior Software Engineer, Microsoft), Niels Laute (Senior Software Engineer, Microsoft)  
**Link:** [Microsoft Build 2025 Session DEM571]

![Command Palette Extensibility](images/command-palette-extension.png)

---

## Executive Summary

This session demonstrates the extensibility model of PowerToys Command Palette, the next generation of PowerToys Run. Through live coding, the speakers build a complete Command Palette extension from scratch in under 15 minutes, showcasing the SDK, best practices for handling latency, rich UI components, and the distribution model for community extensions.

---

## Key Topics Covered

### ?? **1. PowerToys Command Palette Overview**

#### Next Generation Launcher
**Built from Scratch with WinUI:**
- **Performance focus** - "Blazing fast" execution and response times
- **Accessibility improvements** - Enhanced screen reader and keyboard navigation support
- **Modern architecture** - Complete rewrite from PowerToys Run foundation
- **Extensibility-first design** - SDK and plugin architecture from day one

#### Core Functionality Demonstration
**Basic Features:**
- **Application launcher** - Fast app discovery and launch
- **File search** - Quick access to documents and projects
- **Calculator integration** - Inline mathematical calculations
- **Built-in commands** - System operations and utilities

---

### ?? **2. Extensibility Architecture**

#### Plugin Integration Model
**Any Application Integration:**
- **External app connectivity** - Applications can add their own commands and functionality
- **Context preservation** - Extensions maintain app-specific context and workflows
- **User fingertip access** - Immediate access to deep application features

#### Live GitHub Extension Demo
**Real-World Example:**
```
GitHub Extension Capabilities:
??? Issue Management
?   ??? List all project issues
?   ??? Search and filter issues
?   ??? Quick actions (copy link, browse)
??? Repository Operations
?   ??? Clone and navigation
?   ??? Integration with local development
??? Workflow Integration
    ??? Issue triage from Command Palette
    ??? Direct GitHub browsing
```

---

### ????? **3. Live Extension Development**

#### 13-Minute Build Process
**Step-by-Step Development:**

**Phase 1: Project Setup (1 minute)**
- **Built-in scaffolding** - `Create new extension` command in Command Palette
- **Template generation** - Complete project structure with build configuration
- **Visual Studio integration** - Immediate development environment setup

**Phase 2: Basic Commands (30 seconds each)**
- **URL command** - PowerToys GitHub repository link
- **Process execution** - Command prompt launch capability
- **Icon integration** - Custom icons from applications or web sources

**Phase 3: Rich UI Components (2 minutes)**
- **Details pane integration** - Markdown content rendering
- **Side panel activation** - Extended information display
- **Automatic formatting** - Images and formatting preserved from markdown

**Phase 4: Nested Commands (3 minutes)**
- **Sub-command architecture** - Hierarchical command organization
- **Context-sensitive actions** - Multiple operations per top-level command
- **Command palette within command palette** - Nested navigation experience

#### Technical Implementation Details

**Command Provider Structure:**
```csharp
public class BuildDemoCommandProvider
{
    // Command Palette calls into extension
    public IEnumerable<ICommandItem> GetCommands()
    {
        yield return new CommandItem
        {
            Title = "PowerToys Repository",
            Command = new OpenUrlCommand("https://github.com/microsoft/powertoys"),
            Icon = GitHubIcon,
            Details = markdownContent,
            DetailsVisible = true
        };
    }
}
```

**Rich Details Integration:**
- **Markdown rendering** - Complete PowerToys README content displayed
- **Image preservation** - Automatic image loading and display
- **Formatting support** - Headers, lists, code blocks maintained
- **No custom rendering required** - Framework handles markdown conversion

---

### ?? **4. User Experience Design Patterns**

#### Command Organization Philosophy

**Top-Level vs. Nested Commands:**
- **Discoverability** - Essential commands at surface level
- **Organization** - Related commands grouped in sub-menus
- **Context awareness** - Users understand command relationships
- **Cognitive load management** - Prevent overwhelming main interface

#### Visual Design Elements

**Icon Strategy:**
- **Application icons** - Extract from executable files
- **Web-based icons** - Remote icon URLs supported
- **Custom assets** - Project-specific imagery
- **Emoji support** - Simple emoji as quick icon solution (?? for folder commands)

**Information Architecture:**
- **Progressive disclosure** - Basic commands first, details on demand
- **Rich content support** - Full markdown rendering in details pane
- **Contextual actions** - Multiple operations per command item

---

### ?? **5. Distribution and Community Ecosystem**

#### Extension Packaging
**MSIX Distribution Model:**
- **Standard packaging** - Extensions packaged as MSIX like regular applications
- **Multiple distribution channels** - WinGet, Microsoft Store, direct distribution
- **Automatic discovery** - Command Palette can find extensions in WinGet repository

#### Community Engagement
**Existing Extension Ecosystem:**
- **Community contributions** - Active developer community creating extensions
- **WinGet integration** - Extensions marked with metadata for discoverability
- **Open submission model** - Developers can publish extensions freely

#### Microsoft Store Integration
**Major Announcement:**
- **Removed onboarding fee** - Individual developers can now publish for free
- **Lowered barrier to entry** - No cost for publishing Command Palette extensions
- **Streamlined distribution** - Direct store publication pathway

---

### ??? **6. Development Experience and Tooling**

#### SDK and Framework Support

**Built-in Helpers:**
- **Icon discovery utilities** - Tools for finding and implementing icons
- **Process execution commands** - Pre-built system operation commands  
- **UI component library** - Rich interface elements ready to use
- **Debugging integration** - Full Visual Studio debugging support

#### Development Workflow
**Rapid Iteration:**
1. **Extension creation** - Built-in scaffolding command
2. **Code modification** - Standard C# development
3. **Build and deploy** - Automatic extension registration
4. **Command Palette reload** - Immediate testing and iteration
5. **Live debugging** - Breakpoints and runtime inspection

#### Best Practices Demonstrated
**Performance Considerations:**
- **Latency management** - Async operations for external data
- **UI responsiveness** - Non-blocking command execution
- **Resource efficiency** - Minimal memory footprint for extensions

---

## Technical Architecture Insights

### Extension Integration Points

**Command Provider Interface:**
- **GetCommands() method** - Primary extension entry point
- **Command objects** - Structured command definitions
- **Asynchronous support** - Non-blocking extension loading
- **Context management** - State preservation across sessions

### Rich UI Components

**Details Panel System:**
- **Markdown rendering engine** - Full markdown specification support
- **Image handling** - Automatic remote image loading
- **Responsive layout** - Adaptive sizing based on content
- **Accessibility compliance** - Screen reader and keyboard navigation

### Distribution Architecture

**Extension Discovery:**
- **WinGet metadata** - Special tags for Command Palette extensions
- **Store integration** - Microsoft Store extension category
- **Local installation** - Development and testing pathways
- **Community curation** - User-driven extension ecosystem

---

## Live Demo Highlights

### 13-Minute Complete Extension Build
**Accomplished Features:**
1. **Project scaffolding** and Visual Studio integration
2. **GitHub repository link** with custom GitHub icon
3. **Command prompt launcher** with process execution
4. **Rich details pane** with complete PowerToys README
5. **Nested sub-commands** for multiple file operations
6. **Visual polish** with emoji icons and proper organization

### Real-World GitHub Extension
**Production-Quality Features:**
- **Live issue tracking** integration
- **Search and filtering** across project issues
- **Quick actions** - copy links, browse GitHub directly
- **Workflow integration** - issue triage without leaving Command Palette

---

## Session Highlights

> *"Any app can plug into the Windows Command Palette and add their own commands and their own little snippets of functionality straight to it that give all the power of your app right at the user's fingertips."* - Niels Laute

> *"It's like a small command palette inside of a bigger command palette."* - Mike Griese (on nested commands)

> *"We can build an extension in like 13 minutes, not 15, including documentation."* - Niels Laute

> *"Creating an account on the Microsoft Store to submit your apps or publishing Command Palette extensions is now totally free."* - Niels Laute

---

## Getting Started Guide

### Prerequisites
- **PowerToys installed** - Latest version with Command Palette enabled
- **Visual Studio** - Development environment for C# extensions
- **SDK familiarity** - Basic understanding of C# and UI development

### Step-by-Step Extension Creation

1. **Launch Command Palette** (default: Alt+Space)
2. **Run "Create new extension"** command
3. **Provide extension name** and location
4. **Open generated solution** in Visual Studio
5. **Modify CommandProvider.cs** to add your commands
6. **Build and deploy** extension
7. **Reload Command Palette** to test changes

### Essential Code Patterns

**Basic Command:**
```csharp
yield return new CommandItem
{
    Title = "My Command",
    Command = new ProcessCommand("cmd.exe"),
    Icon = IconInfo.FromEmoji("?")
};
```

**Rich Details Command:**
```csharp
yield return new CommandItem
{
    Title = "Detailed Command",
    Command = new OpenUrlCommand("https://example.com"),
    Details = new MarkdownDetails(markdownContent),
    DetailsVisible = true
};
```

**Nested Commands:**
```csharp
yield return new CommandItem
{
    Title = "Parent Command",
    Commands = new[]
    {
        new CommandItem { Title = "Sub Command 1", ... },
        new CommandItem { Title = "Sub Command 2", ... }
    }
};
```

---

## Resources and Documentation

### Primary Documentation
- **Main Documentation Hub:** aka.ms/commandpal
- **SDK Reference:** Complete API documentation with samples
- **Getting Started Guides:** Step-by-step tutorials for common scenarios
- **Best Practices:** Performance, UX, and architectural guidelines

### Related Sessions
- **BRK226 (Wednesday):** "Boost your development productivity with Windows latest tools and tips"
- **Presenters:** Craig Loewen, Kayla Cinnamon, Larry Osterman
- **Focus:** New developer experiences launching at Build 2025

### Community and Distribution
- **WinGet Repository:** Command Palette extension discovery
- **Microsoft Store:** Free publishing for individual developers
- **GitHub Samples:** Example extensions and templates
- **Community Extensions:** Growing ecosystem of user-contributed extensions

---

## About the Speakers

**Mike Griese**  
Senior Software Engineer  
Microsoft  
*Expert on Terminal, PowerToys, Command Palette, and command-line development tools for Windows.*

**Niels Laute**  
Senior Software Engineer  
Microsoft  
*Windows Developer Platform team member working on AI Dev Gallery, Windows Community Toolkit, and Microsoft PowerToys.*

---

*This session demonstrates Microsoft's commitment to extensible developer tools, showing how a powerful application launcher can be extended by the community to create rich, integrated development experiences that bring application functionality directly to users' fingertips.*

