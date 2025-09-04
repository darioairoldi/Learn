# .NET 10 Preview: Run C# Files Directly with `dotnet run app.cs`

**Session Date:** May 22, 2025  
**Duration:** 15 minutes  
**Venue:** Build 2025 Conference - DEM518  
**Speakers:** Damian Edwards (Principal Architect, Microsoft)  
**Link:** [Microsoft Build 2025 Session DEM518](https://mybuild.microsoft.com/sessions/DEM518)

---

## Table of Contents

1. [Introduction: The Developer Experience Problem](#1-introduction-the-developer-experience-problem)
2. [The Traditional C# Learning Barrier](#2-the-traditional-c-learning-barrier)
   - 2.1 [Project Ceremony Complexity](#21-project-ceremony-complexity)
   - 2.2 [Cognitive Overload for Beginners](#22-cognitive-overload-for-beginners)
3. [.NET 6 Progress: Top-Level Programs](#3-net-6-progress-top-level-programs)
   - 3.1 [Code Simplification](#31-code-simplification)
   - 3.2 [Remaining Challenges](#32-remaining-challenges)
4. [.NET 10 Revolution: Direct File Execution](#4-net-10-revolution-direct-file-execution)
   - 4.1 [Core Feature Demonstration](#41-core-feature-demonstration)
   - 4.2 [Performance Characteristics](#42-performance-characteristics)
5. [Package Management with Ignore Directives](#5-package-management-with-ignore-directives)
   - 5.1 [NuGet Package Integration](#51-nuget-package-integration)
   - 5.2 [Progressive Disclosure Learning](#52-progressive-disclosure-learning)
6. [Cross-Platform Support: Linux and Shebang](#6-cross-platform-support-linux-and-shebang)
   - 6.1 [Shebang Implementation](#61-shebang-implementation)
   - 6.2 [Executable Script Creation](#62-executable-script-creation)
7. [Advanced Applications: Web APIs and Beyond](#7-advanced-applications-web-apis-and-beyond)
   - 7.1 [Single-File Web API](#71-single-file-web-api)
   - 7.2 [SDK Switching Capabilities](#72-sdk-switching-capabilities)
8. [Project Conversion and Migration Path](#8-project-conversion-and-migration-path)
   - 8.1 [Seamless Project Creation](#81-seamless-project-creation)
   - 8.2 [Maintaining Functionality](#82-maintaining-functionality)
9. [Tooling Integration and Developer Experience](#9-tooling-integration-and-developer-experience)
   - 9.1 [Visual Studio Code Support](#91-visual-studio-code-support)
   - 9.2 [IntelliSense and Debugging](#92-intellisense-and-debugging)

---

## 1. Introduction: The Developer Experience Problem

**Timeframe:** 00:00:00  
**Duration:** 1m 30s  
**Speaker:** Damian Edwards

Damian Edwards opened the session by highlighting a fundamental problem in C# developer onboarding: the overwhelming complexity of the initial experience for newcomers to the language. The session focused on a revolutionary new feature in .NET 10 that addresses this longstanding barrier to entry.

The core premise was that when teaching C# to new developers, the traditional approach required understanding numerous concepts unrelated to the actual C# language itself - project files, XML configuration, folder structures, and ceremonial code that obscured the learning objectives.

**Key Problem Statement:**
> *"I'm new to C#. I don't know anything about this language. And then I'm like, OK, what does this mean? And what is a namespace? And why don't I need a class thing?"* - Describing typical beginner confusion

The session aimed to demonstrate how .NET 10 eliminates these barriers through direct C# file execution capabilities.

---

## 2. The Traditional C# Learning Barrier

**Timeframe:** 00:00:40  
**Duration:** 2m 00s  
**Speaker:** Damian Edwards

### 2.1 Project Ceremony Complexity

Edwards illustrated the traditional new developer experience by showing what happened when someone ran `dotnet new console`:

**Traditional Console Application Structure:**
```csharp
namespace MyFirstApp;
class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello World!");
    }
}
```

**Associated Project Files:**

- `.csproj` file with XML configuration
- `bin/` and `obj/` directories with mysterious contents
- `Program.cs` file with confusing naming (why "Program" when the app is called "MyFirstApp"?)

### 2.2 Cognitive Overload for Beginners

The traditional approach presented numerous unfamiliar concepts simultaneously:

**Overwhelming Terminology:**

- **Namespace:** Unfamiliar concept requiring explanation
- **Class:** Object-oriented programming concept
- **Static:** Modifier with complex implications
- **Void:** Return type concept
- **Main:** Entry point convention
- **String[] args:** Command-line arguments array

**Non-Essential Complexity:**

- XML project files for simple scripts
- Hidden folder structures (`bin`, `obj`)
- Multiple files for single-purpose applications
- Separation between file names and application purpose

Edwards emphasized that these elements, while important for full application development, created unnecessary cognitive load for developers trying to learn basic C# syntax and concepts.

---

## 3. .NET 6 Progress: Top-Level Programs

**Timeframe:** 00:02:35  
**Duration:** 1m 00s  
**Speaker:** Damian Edwards

### 3.1 Code Simplification

.NET 6 introduced significant improvements through top-level programs, reducing the ceremonial code required:

**Simplified Console Application:**
```csharp
// Program.cs
Console.WriteLine("Hello World!");
```

This eliminated the namespace, class, and Main method ceremony, focusing on the actual functionality developers wanted to implement.

### 3.2 Remaining Challenges

Despite the code simplification, several barriers remained:

**Persistent Issues:**

- **Project Files:** Still required XML configuration files
- **File Naming Confusion:** `Program.cs` vs. actual application name
- **Project Structure:** Multiple files and directories for simple tasks
- **Ceremony Overhead:** XML and project configuration for basic scripting

Edwards noted that while the code became simpler, the overall development experience still included unnecessary complexity for newcomers focusing purely on learning C# language features.

---

## 4. .NET 10 Revolution: Direct File Execution

**Timeframe:** 00:03:00  
**Duration:** 2m 30s  
**Speaker:** Damian Edwards

### 4.1 Core Feature Demonstration

Edwards demonstrated the revolutionary capability of .NET 10 Preview 4:

**Pure C# File Creation:**
```csharp
// hello.cs
Console.WriteLine("Hello, C#!");
```

**Direct Execution:**
```bash
dotnet run hello.cs
# Output: Hello, C#!
```

**Key Innovation Points:**

- **Zero Ceremony:** No project files, XML, or additional structure required
- **Pure C# Learning:** Focus exclusively on language concepts
- **Immediate Feedback:** Write code and execute instantly
- **Progressive Disclosure:** Introduce complexity only when needed

### 4.2 Performance Characteristics

**Initial Performance Metrics:**

- **Cold Start:** ~3.6 seconds (first execution)
- **Warm Start:** <1 second (subsequent executions)
- **Performance Improvements:** Planned for Preview 5 and 6

Edwards acknowledged the current performance characteristics while emphasizing this was the first working implementation:

> *"This is literally the first version of this that works. .NET 10 Preview 4 has this capability inside of it."*

**Development Status:**

- Available in .NET 10 Preview 4
- VS Code C# extension support arriving within days of the session
- Performance optimizations planned for future previews

---

## 5. Package Management with Ignore Directives

**Timeframe:** 00:04:00  
**Duration:** 2m 30s  
**Speaker:** Damian Edwards

### 5.1 NuGet Package Integration

Edwards demonstrated how to add external packages using the new ignore directive system:

**Package Reference Syntax:**
```csharp
#r "nuget: Humanizer, 2.*"
using Humanizer;

var buildStart = new DateTimeOffset(2025, 5, 19, 0, 0, 0, TimeSpan.Zero);
var timeSince = DateTimeOffset.Now - buildStart;

Console.WriteLine($"It has been {timeSince.Humanize()} since Build started.");
// Output: It has been 2 days since Build started.
```

**Ignore Directive (`#r`) Features:**

- **Language Instruction:** Tells C# compiler how to handle external references
- **Metadata Separation:** Keeps package information separate from actual C# code
- **Extensible System:** Foundation for additional directive types
- **Clean Code:** Maintains pure C# syntax in the main code body

### 5.2 Progressive Disclosure Learning

The package integration demonstrated progressive disclosure principles:

**Learning Progression:**
1. **Start Simple:** Pure C# syntax and basic operations
2. **Add Complexity:** Variable declarations, method calls, date operations
3. **Include External Code:** Package references and using statements
4. **Expand Functionality:** More sophisticated operations with external libraries

Edwards noted that the using statement introduction came naturally after adding packages:
> *"That's a new thing I need to think about as a C# developer after I've added this package. So good, good progressive disclosure. I'm learning the things I need to do."*

This approach allows developers to encounter concepts when they become relevant rather than overwhelming them upfront.

---

## 6. Cross-Platform Support: Linux and Shebang

**Timeframe:** 00:06:30  
**Duration:** 2m 00s  
**Speaker:** Damian Edwards

### 6.1 Shebang Implementation

Edwards demonstrated Linux integration by showing shebang support in .NET 10:

**Linux-Executable C# Script:**
```csharp
#!/usr/bin/env dotnet run
#r "nuget: Humanizer, 2.*"
using Humanizer;

var inputDate = DateTimeOffset.Parse(args[0]);
var age = DateTimeOffset.Now - inputDate;
Console.WriteLine($"You are {age.Humanize()} old.");
```

**Shebang Line Explanation:**

- **`#!/usr/bin/env dotnet run`:** Standard Unix/Linux executable specification
- **Cross-Platform Consistency:** Same experience across Windows, Linux, and macOS
- **Shell Integration:** Direct execution from command line without explicit `dotnet run`

### 6.2 Executable Script Creation

**Linux Execution Process:**
```bash
# Make file executable
chmod +x script.cs

# Run directly
./script.cs "1978-01-01"
# Output: You are 47 years old.
```

**Cross-Platform Benefits:**

- **WSL Integration:** Seamless experience with Windows Subsystem for Linux
- **Container Support:** Works in Docker and containerized environments
- **DevOps Scripting:** Enables C# for automation and system administration tasks
- **Unified Experience:** Same file works on Windows and Linux with appropriate execution methods

Edwards highlighted this as bringing C# in line with other scripting languages:
> *"We were kind of lagging behind, but I'm very happy to say that we're catching up in .NET 10."*

---

## 7. Advanced Applications: Web APIs and Beyond

**Timeframe:** 00:08:30  
**Duration:** 2m 00s  
**Speaker:** Damian Edwards

### 7.1 Single-File Web API

Edwards demonstrated that the direct execution capability extends beyond simple console applications:

**Complete Web API in Single File:**
```csharp
#!/usr/bin/env dotnet run
#!set sdk Microsoft.NET.Sdk.Web
#r "nuget: Swashbuckle.AspNetCore"

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () => "Hello World!")
    .WithName("GetHelloWorld")
    .WithOpenApi();

app.Run();
```

**Advanced Capabilities Demonstrated:**

- **Full ASP.NET Core Support:** Complete web framework functionality
- **Swagger Integration:** Automatic API documentation generation
- **OpenAPI Support:** Modern API specification compliance
- **Development Server:** Built-in web server for immediate testing

### 7.2 SDK Switching Capabilities

**SDK Selection Directive:**
The `#!set sdk Microsoft.NET.Sdk.Web` directive demonstrates the system's flexibility:

- **Dynamic SDK Selection:** Choose appropriate SDK for application type
- **Web Development:** Full web application capabilities without project ceremony
- **Blazor Support:** Server-side Blazor applications with Razor files
- **Framework Features:** Access to complete ASP.NET Core feature set

**Supported Application Types:**

- Console applications (default)
- Web APIs and web applications
- Blazor Server applications
- Background services and hosted services

This capability positions single-file execution as suitable for rapid prototyping of complex applications, not just simple scripts.

---

## 8. Project Conversion and Migration Path

**Timeframe:** 00:10:30  
**Duration:** 1m 30s  
**Speaker:** Damian Edwards

### 8.1 Seamless Project Creation

Edwards demonstrated the smooth migration path from single files to full projects:

**Project Conversion Command:**
```bash
dotnet project convert hello.cs
```

**Conversion Process:**
1. **Project Folder Creation:** Creates directory with same name as file
2. **`.csproj` Generation:** Automatic project file creation with appropriate references
3. **Directive Stripping:** Removes ignore directives from C# file
4. **Package Integration:** Converts `#r` directives to proper PackageReference elements
5. **Code Preservation:** Maintains all functionality in project format

### 8.2 Maintaining Functionality

**Before Conversion:**
```
hello.cs (standalone file with directives)
```

**After Conversion:**
```
hello/
├── hello.csproj
└── hello.cs (clean C# code)
```

**Benefits of Conversion:**

- **Full Tooling Support:** Complete Visual Studio and VS Code integration
- **Advanced Features:** MSBuild targets, custom build processes, multi-file projects
- **Team Development:** Source control, collaborative development features
- **Production Deployment:** Standard deployment and packaging mechanisms

The conversion process ensures that learning efforts aren't wasted - code written in single-file mode seamlessly transitions to full project development when additional capabilities are needed.

---

## 9. Tooling Integration and Developer Experience

**Timeframe:** 00:12:00  
**Duration:** 3m 00s  
**Speaker:** Damian Edwards

### 9.1 Visual Studio Code Support

**Immediate Tooling Integration:**
Edwards demonstrated that the feature includes full tooling support:

- **IntelliSense:** Complete code completion and error detection
- **Syntax Highlighting:** Full C# language service support
- **Error Reporting:** Comprehensive compiler feedback
- **Debugging Support:** Breakpoints and step-through debugging capabilities

**Extension Availability:**
> *"The version of VS Code I'm using, the C# extension that lights up the IntelliSense when you're running in this mode will be available imminently, if not by the end of the day, then hopefully by tomorrow."*

**Pre-release Channel:**

- C# extension updates available through pre-release channel
- Full language services without project configuration
- Contextual help and documentation integration

### 9.2 IntelliSense and Debugging

**Development Experience Features:**

- **Code Completion:** Full IntelliSense support for standalone files
- **Error Detection:** Real-time compilation error reporting
- **Debugging:** Complete debugging experience without project setup
- **Refactoring:** Code transformation and improvement suggestions

**Educational Benefits:**
The tooling integration supports the educational goals by providing:

- Immediate feedback on code correctness
- Contextual help for language features
- Debugging capabilities for understanding program flow
- Professional development environment without complexity overhead

This comprehensive tooling support ensures that the simplified execution model doesn't compromise the development experience quality.

---

## References

### Official Microsoft Documentation

1. **[.NET 10 Preview Releases](https://dotnet.microsoft.com/download/dotnet/10.0)**
   - Official download page for .NET 10 preview versions including Preview 4
   - Essential for accessing the direct C# file execution capabilities demonstrated in the session
   - Provides installation instructions and release notes for new features

2. **[Top-level Programs in C#](https://docs.microsoft.com/dotnet/csharp/fundamentals/program-structure/top-level-statements)**
   - Documentation covering the .NET 6+ simplified program structure
   - Relevant for understanding the evolution leading to .NET 10's direct execution feature
   - Provides context for the progression from traditional to simplified C# applications

3. **[.NET CLI Overview](https://docs.microsoft.com/dotnet/core/tools/)**
   - Comprehensive guide to .NET command-line interface tools
   - Important for understanding the foundation that enables `dotnet run file.cs` functionality
   - Covers existing CLI capabilities that the new feature extends

### Package Management and Ignore Directives

4. **[NuGet Package Manager](https://docs.microsoft.com/nuget/)**
   - Official NuGet documentation covering package management in .NET
   - Relevant for understanding how the `#r "nuget:"` directive integrates with existing package systems
   - Provides background on package resolution and management that powers the new inline package references

5. **[C# Preprocessor Directives](https://docs.microsoft.com/dotnet/csharp/language-reference/preprocessor-directives/)**
   - Documentation on existing C# preprocessor directives like `#if`, `#region`
   - Important for understanding the foundation that ignore directives (`#!`) build upon
   - Shows the precedent for hash-based language instructions in C#

### Cross-Platform Development

6. **[Shebang (Unix/Linux)](https://en.wikipedia.org/wiki/Shebang_(Unix))**
   - Wikipedia article explaining shebang (`#!`) syntax in Unix-like systems
   - Essential for understanding the Linux integration demonstrated in the session
   - Provides context for how .NET 10 integrates with standard Unix scripting conventions

7. **[Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/windows/wsl/)**
   - Microsoft documentation for WSL, demonstrated in the session
   - Relevant for understanding the cross-platform development environment shown
   - Important for developers wanting to replicate the Linux scripting examples on Windows

### Alternative Language Comparisons

8. **[Node.js Execution Model](https://nodejs.org/docs/latest/api/cli.html)**
   - Documentation showing how Node.js executes JavaScript files directly (`node file.js`)
   - Provides comparison point for understanding how .NET 10 brings C# in line with other languages
   - Demonstrates industry standard for simple script execution

9. **[Python Script Execution](https://docs.python.org/3/using/cmdline.html)**
   - Python documentation covering direct script execution (`python file.py`)
   - Another comparison point showing how other languages handle simple script execution
   - Illustrates the industry trend that .NET 10 is following

### Educational Resources and Learning Paths

10. **[C# Programming Guide](https://docs.microsoft.com/dotnet/csharp/programming-guide/)**
    - Comprehensive C# learning resource from Microsoft
    - Relevant for developers who want to progress beyond single-file scripting
    - Provides the full language context that the new feature makes more accessible

11. **[ASP.NET Core Minimal APIs](https://docs.microsoft.com/aspnet/core/fundamentals/minimal-apis)**
    - Documentation for the minimal API approach demonstrated in single-file web applications
    - Important for understanding how complex applications can be built with the new execution model
    - Shows the foundation for the web API examples in the session

12. **[Visual Studio Code C# Extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)**
    - Official VS Code extension providing C# language support
    - Essential tool for developers wanting to use the features demonstrated
    - Pre-release channel provides access to the single-file execution support mentioned in the session

---

## Appendix: Technical Implementation Details

### A.1 Performance Characteristics and Optimization

The session revealed specific performance metrics that, while not central to the main learning concepts, provide important context for practical usage:

**Current Performance Profile (.NET 10 Preview 4):**

- **Initial Execution:** ~3.6 seconds for cold start
- **Subsequent Executions:** <1 second when runtime is warmed up
- **Planned Improvements:** Performance optimizations scheduled for Preview 5 and Preview 6

**Performance Context:**
Edwards acknowledged that the current performance is a result of this being the first working implementation of the feature. The development team prioritized functionality delivery over optimization in Preview 4, with performance improvements planned for future releases.

### A.2 Development Timeline and Availability

**Feature Availability Schedule:**

- **.NET 10 Preview 4:** Core functionality available at session time (May 22, 2025)
- **VS Code Extension:** Pre-release channel availability within 24-48 hours of session
- **Performance Improvements:** Preview 5 and 6 releases
- **General Availability:** November 2025 with .NET 10 release

**Extension Installation Process:**
Users need to access the pre-release channel for VS Code C# extension to get IntelliSense and debugging support for single-file execution mode.

### A.3 Comparison with Other Language Ecosystems

Edwards referenced several other programming languages that already supported direct file execution, positioning .NET 10's feature as bringing C# up to industry standards:

**Language Comparison:**

- **Node.js:** `node hello.js` - Industry standard for JavaScript execution
- **Python:** `python hello.py` - Well-established scripting model
- **Go:** `go run hello.go` - Modern language with simple execution
- **Rust:** `rust-script hello.rs` - Systems language with scripting capability
- **C# (.NET 10):** `dotnet run hello.cs` - New capability bringing C# to parity

This comparison illustrates that the feature addresses a gap in the .NET ecosystem rather than pioneering a new concept.

### A.4 Educational Psychology and Learning Theory

The session touched on educational concepts that support the design decisions:

**Progressive Disclosure Principles:**

- **Cognitive Load Theory:** Minimize extraneous cognitive load to focus on essential learning
- **Scaffolding:** Provide support structures that can be removed as competence develops
- **Just-in-Time Learning:** Introduce concepts when they become relevant to current tasks

**Learning Path Optimization:**

- **Immediate Feedback:** Rapid write-execute-observe cycles support learning
- **Conceptual Isolation:** Separate C# language learning from tooling and infrastructure concerns
- **Smooth Transitions:** Migration path preserves investment while adding capabilities

### A.5 Future Development and Community Feedback

Edwards indicated that the feature development is actively seeking community input:

**Feedback Channels:**

- **GitHub Repository:** dotnet/sdk for feature-specific feedback
- **Community Validation:** Real-world usage patterns to guide development
- **Performance Benchmarking:** Community testing to validate optimization priorities

**Expected Evolution:**
The feature represents the foundation for further enhancements, with the development team monitoring usage patterns to guide future improvements and additions.

This appendix information, while valuable for completeness, was kept separate from the main content to maintain focus on the core concepts and demonstrations that comprised the primary session value.
