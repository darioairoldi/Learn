# Boost Development Productivity: Windows Latest Tools and Tips

**Session Date:** May 22, 2025  

**Duration:** 1 hour  
**Speakers:** Kayla Cinnamon (Senior Product Manager, Microsoft), Craig Loewen (Senior Product Manager, Microsoft), Larry Osterman (Principal Software Design Engineer, Microsoft)  

**Link:** [Microsoft Build 2025 Session BRK226]

![Windows Developer Tools](images/windows-dev-tools.png)


## Executive Summary

This session showcases the latest productivity tools and enhancements from the Windows developer tools team, featuring live demonstrations of PowerToys, Windows Terminal, Windows Subsystem for Linux (WSL), WinGet, and the new Edit text editor. The speakers demonstrate how these tools work together to streamline developer workflows and boost productivity across Windows development environments.

---

## Key Topics Covered

### ⚡ **1. PowerToys: Enhanced Windows Utilities Suite**

#### ZoomIt Integration 
**New Addition:** Screen annotation and zoom tool integrated from SysInternals
- **Bundled experience** - No separate installation required
- **Live annotation** during presentations and demos
- **Seamless PowerToys integration** with open source availability

#### Advanced Paste: AI-Powered Clipboard Enhancement

**Core Capabilities:**
- **Format transformation** - Paste content in any desired format
- **Local API integration** - Seamless blend of local and AI capabilities
- **AI-powered scenarios** - Complex content transformations

**Live Demo Highlights:**
- **HTML → Markdown conversion** with GitHub issue content
- **CSV → Markdown table** with custom formatting requests
- **Image OCR extraction** - Serial number from image to file
- **Media format conversion** - MOV to MP4/MP3 using Windows APIs

**AI Agent Integration:**
```
User action: Copy image with serial number
AI workflow: Image OCR → Text extraction → File creation → Explorer integration
```

---

### 🚀 **2. Command Palette: Next-Generation Launcher**

#### Evolution from PowerToys Run
**Design Goals:**
- **Performance optimization** from ground up
- **Extensibility framework** - Top user request fulfilled
- **Progressive enhancement** while maintaining familiar functionality

#### Core Features Demonstration
- **Application launcher** with instant search
- **Run commands** - Windows R replacement capability
- **File search and bookmarks** - URL and file path support
- **WinGet integration** - Package search with markdown previews

#### Live Extension Development
**On-Stage Development:**
1. **Scaffolding** - `dotnet new` template for Command Palette extensions
2. **Visual Studio integration** - Full debugging experience
3. **Performance Monitor extension** - CPU/memory monitoring example
4. **Breakpoint debugging** - Full development environment support

**Developer Experience:**
- **Built-in scaffolding** via Command Palette interface
- **Comprehensive documentation** with namespace declarations
- **Community ecosystem** - Extensions available via WinGet repository
- **ARM64 support** for modern hardware

---

### 📝 **3. Windows Built-in Text Editor: "Edit"**

#### Revolutionary Command-Line Integration
**Problem Solved:** Breaking workflow when editing configuration files
- **Console-based editing** without leaving command line context
- **Windows-familiar interface** - File menus, mouse support, standard shortcuts
- **No learning curve** - File → Exit instead of cryptic command sequences

#### Advanced Capabilities
**Performance Features:**
- **Large file handling** - 100MB+ files load instantly
- **Smart loading** - Only reads visible content portions
- **Dynamic resizing** - Automatic adjustment to console window changes

**Standard Features:**
- **Search functionality** - Ctrl+F familiar experience
- **Word wrap and formatting** options
- **Full keyboard and mouse support**
- **Scratch pad functionality** for quick notes and protocol decoding

#### Open Source Availability
- **GitHub repository:** github.com/MicrosoftEdit
- **Active community** - Issues, pull requests, and contributions welcomed
- **Release distribution** - Available now via GitHub releases page
- **Future integration** - Coming to Windows as built-in component

---

### 🖥️ **4. Windows Settings Improvements**

#### Developer Settings Reorganization
**"For Developers" → "Advanced" Page Redesign:**
- **Improved discoverability** - Features useful beyond developers
- **Better organization** - Popular features prominently displayed
- **Maintained search compatibility** - Deep linking and search terms preserved

#### Key Features Highlighted
**Process Management:**
- **End Task** - Right-click context menu for running applications
- **Task Manager integration** without switching applications

**File System Enhancements:**
- **Long Path support** - Registry modification via simple toggle
- **Dev Drive creation** - High-performance developer storage

**Virtual Environment Controls:**
- **Hyper-V enablement** - Single-click activation
- **Windows Sandbox** access
- **WSL integration** (planned) - Centralized virtual workspace management

#### File Explorer Git Integration
**Version Control Awareness:**
- **Git repository detection** - Automatic integration in File Explorer columns
- **Branch information** - Current branch display in status bar
- **File status indicators** - Modified, committed, staged visualization
- **Diff information** - Changes between branch and origin

**Technical Implementation:**
- **Open source component** - Powered by Windows Advanced Settings
- **Column integration** - Native File Explorer enhancement
- **Windows Insider availability** - Dev and Beta channels

---

### 📦 **5. WinGet Configuration Management**

#### Export and Import System Configuration

**Configuration Export:**
```bash
winget configure export
```

**Capabilities Demonstrated:**
- **Complete system state capture** - Applications, settings, and configurations
- **PowerShell script integration** - Dynamic configuration detection
- **Team standardization** - Shared configuration files for consistent environments

#### Desired State Configuration (DSC) v3
**Advanced Features:**
- **Application-specific settings** - Beyond just application installation
- **WinGet settings preservation** - Progress bar themes, visual preferences
- **Registry and system settings** - Dark/light mode, advanced preferences

**Live Demo Results:**
- **Hands-free setup** - Automated team environment configuration
- **Validation checks** - Skip already-installed components
- **Settings synchronization** - Complete environment replication

---

### 💻 **6. Windows Terminal Enhancements**

#### User Interface Improvements

**Tab Menu Customization:**
- **Visual drag-and-drop** - Rearrange profiles without JSON editing
- **Folder organization** - Group related profiles (WSL, development environments)
- **Separator support** - Visual organization of favorites

**Path Translation Features:**
- **Automatic slash conversion** - Windows backslashes → Linux forward slashes
- **Drive letter mapping** - D:\ → /mnt/d/ automatic conversion
- **WSL auto-detection** - Enabled by default for Linux distributions
- **Drag-and-drop enhancement** - Seamless file path integration

---

### 🐧 **7. Windows Subsystem for Linux (WSL) Open Source**

#### Community and Ecosystem Impact

**Major Announcement:** WSL is now fully open source
- **Repository:** github.com/Microsoft/WSL
- **Documentation Hub:** wsl.dev

**Partner Ecosystem:**
- **Linux Distributions:** Red Hat, OpenSUSE, Canonical, Debian, Arch Linux, Fedora
- **Development Tools:** NVIDIA AI Workbench, Docker Desktop, Podman Desktop
- **Industry Applications:** DreamWorks Moonray rendering engine for films

#### Developer Workflow Integration
**Real-World Usage:**
- **Azure SDK team adoption** - Entire teams using WSL for cross-platform development
- **Windows host, Linux development** - Best of both worlds approach
- **Seamless integration** - "Feels like the same machine" experience

---

## Technical Architecture and Integration

### PowerToys Ecosystem
**Unified Platform:**
- **Consistent experience** across utilities
- **Shared infrastructure** for settings, updates, and community contributions
- **Open source foundation** enabling community extensions and improvements

### Windows Terminal as Development Hub
**Central Command Interface:**
- **Profile management** for different development environments
- **WSL integration** with automatic path translation
- **Customizable workflows** supporting diverse development scenarios

### Configuration as Code
**Infrastructure Approach:**
- **Declarative configuration** via WinGet DSC files
- **Version control friendly** YAML-based configuration management
- **Team standardization** through shared configuration repositories

---

## Live Demo Highlights

### Extension Development Workflow
**Real-Time Development:**
1. **Command Palette extension creation** - Scaffolded in seconds
2. **Performance Monitor utility** - CPU/memory monitoring integration
3. **Full debugging support** - Breakpoints and step-through debugging
4. **Immediate deployment** - Extension available instantly in Command Palette

### Configuration Export/Import Demo
**System State Management:**
1. **Full system export** - Applications, settings, preferences captured
2. **Visual theme change** - Dark to light mode as demonstration
3. **Automated import** - Complete configuration restoration
4. **Team sharing capability** - Configuration files as team standards

---

## Session Highlights

> *"Our whole goal is to go faster than the speed of thought."* - Kayla Cinnamon (on Command Palette performance)

> *"It doesn't break my flow, and that's a big deal for me... I don't have to remember control W, Q, exclamation point, X, S, C, magic."* - Larry Osterman (on Edit text editor)

> *"It all feels like the same machine. You don't have to worry: Am I in Windows? Am I in Linux? You can just drag and drop files over. It just works."* - Craig Loewen (on WSL integration)

> *"Finally! It's just like I've wanted this feature for, like, forever."* - Larry Osterman (on Terminal UI customization)

---

## Practical Implementation Guide

### Getting Started Checklist

**PowerToys Installation:**
1. Install latest PowerToys from Microsoft Store or GitHub
2. Enable ZoomIt for presentation and debugging needs
3. Configure Advanced Paste with AI capabilities
4. Set up Command Palette as Windows+R replacement

**Development Environment Setup:**
1. Download Edit text editor from GitHub releases
2. Enable Windows Advanced settings for developer features
3. Configure File Explorer Git integration (Windows Insider)
4. Set up Terminal Canary for latest features

**Team Configuration Management:**
1. Export current development environment with `winget configure export`
2. Share configuration files via version control
3. Standardize team development environments
4. Document custom configurations and extensions

### Extension Development Resources

**Command Palette Extensions:**
- **Documentation:** Command Palette developer docs
- **Scaffolding:** Built-in extension creation tools
- **Community:** WinGet repository for extension sharing
- **Debugging:** Full Visual Studio integration support

---

## Future Roadmap and Community Engagement

### Immediate Availability
- **PowerToys 0.91:** Latest release with Command Palette improvements
- **Edit Text Editor:** Available now via GitHub releases
- **WSL Open Source:** Full source code and community contributions welcomed
- **Terminal Canary:** Advanced features preview channel

### Windows Insider Features
- **File Explorer Git Integration:** Dev and Beta channels
- **Advanced Settings Page:** Improved developer experience
- **Configuration Management:** DSC v3 capabilities

### Community Contribution Opportunities
- **PowerToys:** Open source contributions and community extensions
- **Edit Text Editor:** Active repository seeking contributions and feedback
- **WSL:** Full open source project with partner ecosystem
- **Documentation:** Community contributions to development guides

---

## Additional Resources and Links

### Download and Documentation Links
- **PowerToys:** Microsoft Store or GitHub repository
- **Windows Terminal Canary:** GitHub releases
- **Edit Text Editor:** github.com/MicrosoftEdit
- **WSL Documentation:** wsl.dev

### Community Engagement
- **Social Media:** Blue Sky and GitHub for team interaction
- **Conference Sessions:** 
  - Build demo on Command Palette extension development
  - DSC v3 deep dive session (following day)
- **Developer Booth:** Windows Developer Experiences for hands-on demos

### Documentation Hubs
- **Command Palette:** Developer documentation with API references
- **Terminal:** Comprehensive customization guides
- **PowerToys:** Feature documentation and contribution guides
- **WSL:** Complete developer documentation at wsl.dev

---

## About the Speakers

**Kayla Cinnamon**  

Senior Product Manager  
*Former PM for Windows Terminal, current PM for PowerToys. Design and technical background with focus on developer experiences. RPI graduate in information technology and UI design.*

**Craig Loewen**  

Senior Product Manager  

Microsoft  

*Primary product owner for Windows Subsystem for Linux (WSL), now focusing on AI tools and workflows. Mechatronics engineering background from University of Waterloo.*

**Larry Osterman**  

---

*This session demonstrates Microsoft's commitment to developer productivity by creating integrated tools that eliminate friction in daily development workflows while maintaining the openness and extensibility that developers demand.*

*40+ years at Microsoft spanning MS-DOS, networking, multimedia, Azure SDK development in C++ and Rust. Microsoft Learn video creator and Seattle Men's Chorus member.*
