# .NET 10 Preview: Run C# Files Directly with `dotnet run app.cs`

**Session Date:** May 22, 2025  
**Duration:** 15 minutes  
**Venue:** Build 2025 Conference - DEM518  
**Speakers:** Damian Edwards (Principal Architect, Microsoft)  
**Link:** [Microsoft Build 2025 Session DEM518]

![Direct C# File Execution](images/dotnet-run-direct.png)

---

## Executive Summary

This session demonstrates a revolutionary new feature coming in .NET 10 that eliminates the project ceremony for simple C# development. Developers can now run C# files directly using `dotnet run app.cs` without creating projects, solutions, or dealing with XML configuration files. The feature provides a smooth learning path from simple scripts to full project-based development.

---

## Key Topics Covered

### ?? **1. The Problem: Overwhelming Initial C# Experience**

**Traditional Learning Barrier:**
When teaching C# to newcomers, the initial experience was overwhelming with unnecessary complexity:

```csharp
// Traditional new console app
namespace MyFirstApp;
class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello World!");
    }
}
```

**Cognitive Overload for Beginners:**
- **Unfamiliar terminology**: Namespace, class, static, void, Main, args
- **Project ceremony**: `.csproj` files with XML configuration
- **Hidden folders**: `bin`, `obj` directories with mysterious contents
- **Multiple files**: `Program.cs` vs actual application name confusion

---

### ?? **2. .NET 6 Improvements: Top-Level Programs**

**.NET 6 Simplification:**
```csharp
// Simplified with top-level programs
Console.WriteLine("Hello World!");
```

**Remaining Challenges:**
- Still required project files and XML configuration
- File naming confusion (`Program.cs` vs application name)
- Project structure complexity for simple tasks
- Multiple files when only wanting to learn C# syntax

---

### ? **3. .NET 10 Revolution: Direct C# File Execution**

#### Core Feature: `dotnet run <file.cs>`

**Ultimate Simplification:**
```csharp
// hello.cs - Just pure C#
Console.WriteLine("Hello, C#!");
```

**Execution:**
```bash
dotnet run hello.cs
# Output: Hello, C#!
```

**Key Benefits:**
- **Zero ceremony** - No projects, no XML, no extra files
- **Pure C# learning** - Focus only on language concepts
- **Immediate feedback** - Write and run instantly
- **Progressive disclosure** - Introduce concepts when needed

---

### ?? **4. Package Management with Ignore Directives**

#### Adding NuGet Packages
```csharp
#r "nuget: Humanizer, 2.*"
using Humanizer;

var buildStart = new DateTimeOffset(2025, 5, 19, 0, 0, 0, TimeSpan.Zero);
var timeSince = DateTimeOffset.Now - buildStart;

Console.WriteLine($"It has been {timeSince.Humanize()} since Build started.");
// Output: It has been 2 days since Build started.
```

**Ignore Directive (`#!`):**
- **Language instruction** to C# compiler
- **Separates metadata** from actual C# code
- **Extensible system** for various directives
- **Clean separation** of concerns

---

### ?? **5. Linux Integration: Shebang Support**

#### Shell Execution on Linux
```csharp
#!/usr/bin/env dotnet run
#r "nuget: Humanizer, 2.*"
using Humanizer;

var inputDate = DateTimeOffset.Parse(args[0]);
var age = DateTimeOffset.Now - inputDate;
Console.WriteLine($"You are {age.Humanize()} old.");
```

**Linux Features:**
- **Shebang support** (`#!/usr/bin/env dotnet run`)
- **Executable permissions** with `chmod +x script.cs`
- **Direct execution** `./script.cs "1978-01-01"`
- **Cross-platform consistency** with Windows

---

### ?? **6. Advanced Applications: Web APIs and Blazor**

#### Web API in a Single File
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

**Advanced Capabilities:**
- **SDK switching** with `#!set sdk` directive
- **Web API development** without project files
- **Blazor Server applications** with Razor files
- **Full ASP.NET Core feature support**

---

### ?? **7. Smooth Migration Path: Convert to Projects**

#### Seamless Project Conversion
```bash
dotnet project convert hello.cs
```

**Conversion Process:**
1. **Creates project folder** with same name as file
2. **Generates `.csproj`** with appropriate package references
3. **Strips ignore directives** from C# file
4. **Maintains functionality** in project format
5. **Enables full tooling** support

**Before Conversion:**
```
hello.cs (standalone file with directives)
```

**After Conversion:**
```
hello/
??? hello.csproj
??? hello.cs (clean C# code)
```

---

### ?? **8. Performance and Tooling Integration**

#### Current Status (.NET 10 Preview 4)
- **Initial execution**: ~3.6 seconds (cold start)
- **Subsequent runs**: Under 1 second (warmed up)
- **Performance improvements** planned for future previews

#### Visual Studio Code Integration
- **IntelliSense support** for standalone files
- **Debugging capabilities** without project configuration
- **Extension updates** available in pre-release channel
- **Full language services** including completion and error checking

---

### ?? **9. Educational Benefits and Use Cases**

#### Perfect for Learning and Teaching
**Progressive Learning Path:**
1. **Start simple**: `Console.WriteLine("Hello World!");`
2. **Add complexity**: Variables, control flow, methods
3. **Include packages**: External library usage
4. **Build applications**: Web APIs, console tools
5. **Convert to projects**: When needing full features

**Comparison with Other Languages:**
- **Node.js**: `node hello.js`
- **Python**: `python hello.py` 
- **Go**: `go run hello.go`
- **Rust**: `rust-script hello.rs`
- **C#**: `dotnet run hello.cs` ?

#### Professional Development Scenarios
- **Rapid prototyping** and experimentation
- **Script automation** for DevOps tasks
- **Quick utilities** and one-off tools
- **Teaching and workshops** without setup overhead
- **Cross-platform scripting** with C# power

---

## Technical Implementation Details

### Architecture Components

**Compiler Integration:**
- **Direct file compilation** without intermediate project generation
- **Dependency resolution** through ignore directives
- **SDK selection** via `#!set sdk` directive
- **Package restoration** handled automatically

**Cross-Platform Support:**
- **Windows**: Full feature support with performance optimizations
- **Linux/macOS**: Shebang integration for shell execution
- **WSL**: Seamless integration with Windows Subsystem for Linux
- **Container**: Docker and containerized environments

### Developer Experience Enhancements

**Tooling Evolution:**
- **VS Code**: Enhanced C# extension with standalone file support
- **IntelliSense**: Full language services without projects
- **Debugging**: Breakpoints and step-through debugging
- **Error reporting**: Comprehensive compiler feedback

---

## Session Highlights

> *"I'm new to C#. I don't know anything about this language. And then I'm like, OK, what does this mean? And what is a namespace? And why don't I need a class thing?"* - Damian Edwards (describing beginner confusion)

> *"My first notch into learning C# should just be C#, right? It shouldn't be anything else."* - Damian Edwards

> *"This is literally the first version of this that works. .NET 10 Preview 4 has this capability inside of it."* - Damian Edwards

> *"We were kind of lagging behind, but I'm very happy to say that we're catching up in .NET 10."* - Damian Edwards

---

## Practical Implementation Guide

### Getting Started Steps

1. **Install .NET 10 Preview 4**
   ```bash
   # Download from official .NET preview releases
   dotnet --version  # Verify preview installation
   ```

2. **Update VS Code C# Extension**
   ```
   # Install pre-release channel extension
   # Available end of May 22, 2025
   ```

3. **Create Your First Standalone C# File**
   ```csharp
   // hello.cs
   Console.WriteLine($"Hello from C# at {DateTime.Now}!");
   ```

4. **Run Directly**
   ```bash
   dotnet run hello.cs
   ```

### Advanced Usage Patterns

**Package Integration:**
```csharp
#r "nuget: Newtonsoft.Json, 13.*"
#r "nuget: RestSharp, 110.*"
using Newtonsoft.Json;
using RestSharp;

// Your application code here
```

**Web Development:**
```csharp
#!set sdk Microsoft.NET.Sdk.Web
#r "nuget: Microsoft.AspNetCore.OpenApi"

var builder = WebApplication.CreateBuilder(args);
// Configure services and build app
```

**Linux Scripting:**
```bash
#!/usr/bin/env dotnet run
#r "nuget: CommandLineParser, 2.*"
// C# script with command-line argument parsing
```

---

## Future Roadmap and Feedback

### Immediate Availability
- **.NET 10 Preview 4**: Core functionality available now
- **VS Code Extension**: Pre-release channel (May 22-23, 2025)
- **Performance improvements**: Coming in Preview 5 and 6

### Feedback Channels
- **GitHub Repository**: dotnet/sdk for feature feedback
- **Community input**: Shaping Preview 5 and 6 development
- **Usage patterns**: Real-world scenario validation

### Expected GA Timeline
- **.NET 10 Release**: November 2025
- **Production ready**: Performance and tooling maturity
- **Ecosystem integration**: Full Visual Studio support

---

## About the Speaker

**Damian Edwards**  
Principal Architect  
Microsoft  
*Product architect on the .NET team focused on developer experience and platform evolution.*

---

*This session marks a significant milestone in .NET's evolution, removing barriers to entry while maintaining the power and flexibility that makes C# a premier development platform. The direct file execution capability represents Microsoft's commitment to developer productivity and learning accessibility.*

