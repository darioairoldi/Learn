# C# 14 Language Features and Beyond: A Demo-Filled Tour

**Session Date:** May 19-22, 2025  
**Duration:** ~60 minutes  
**Venue:** Microsoft Build 2025  
**Speakers:** **Mads Torgersen** (Principal Architect, Microsoft), **Dustin Campbell** (Principal Software Engineer, Microsoft)  
**Link:** [Microsoft Build 2025 - BRK114](https://build.microsoft.com/sessions/BRK114)

## Table of Contents

- [Introduction and Session Overview](#introduction-and-session-overview)
- [Small Quality-of-Life Improvements](#small-quality-of-life-improvements)
  - [Null Conditional Assignments](#null-conditional-assignments)
  - [Lambda Expression Type Inference](#lambda-expression-type-inference)
  - [Partial Members Expansion](#partial-members-expansion)
  - [NameOf Generic Type Fix](#nameof-generic-type-fix)
- [Field Keyword in Auto-Properties](#field-keyword-in-auto-properties)
- [Extension Members Revolution](#extension-members-revolution)
  - [Extension Methods Reimagined](#extension-methods-reimagined)
  - [Extension Properties](#extension-properties)
  - [Static Extension Methods](#static-extension-methods)
  - [Generic Math Integration](#generic-math-integration)
- [Compound Assignment Operators](#compound-assignment-operators)
- [Dictionary Expressions](#dictionary-expressions)
- [Q&A Session](#qa-session)
- [References](#references)

## Introduction and Session Overview

**Timeframe:** 00:00:00 - 00:02:30  
**Duration:** 2m 30s  
**Speakers:** Mads Torgersen, Dustin Campbell

The session begins with Mads Torgersen and Dustin Campbell introducing themselves as architects at Microsoft who work on C# language design. They immediately establish the demo-focused nature of the presentation, emphasizing that most C# 14 features shown are already available in preview builds of Visual Studio 17.14.

The speakers outline their approach: starting with stable features available in Visual Studio preview, then transitioning to experimental features in VS Code with C# Dev Kit that may or may not make it into C# 14. This progression serves as a confidence indicator for feature inclusion.

Key points established:

- Features are in decreasing order of likelihood for C# 14 inclusion
- All demonstrated features use actual product implementations, not prototype code
- The session focuses on making C# "cleaner, clearer, and more expressive"

## Small Quality-of-Life Improvements

### Null Conditional Assignments

**Timeframe:** 00:02:30 - 00:05:45  
**Duration:** 3m 15s  
**Speakers:** Mads Torgersen, Dustin Campbell

This segment demonstrates the new null conditional assignment operator (`?.=`), addressing a long-standing inconsistency in C# where null conditional operators worked for member access but not for assignments.

**Technical Details:**

- Extends the null conditional operator (`?.`) to work with assignments
- Provides short-circuit evaluation: if the left-hand side is null, no assignment occurs
- Guards the entire assignment operation, including property access and value evaluation
- Available when using `<LangVersion>preview</LangVersion>` in project files

**Code Example Demonstrated:**

```csharp
person?.Name = "New Name"; // Only assigns if person is not null
```

The feature eliminates the need for explicit null checks or the "null forgiveness operator" (`!`) in assignment scenarios, making code more concise while maintaining safety.

### Lambda Expression Type Inference

**Timeframe:** 00:05:45 - 00:07:30  
**Duration:** 1m 45s  
**Speakers:** Dustin Campbell, Mads Torgersen

A small but appreciated improvement allowing lambda expressions to maintain type inference even when modifiers (like `out` parameters) are added.

**Previous Limitation:**

```csharp
// Previously required explicit types when using modifiers
(string name, out bool success) => { ... }
```

**New Capability:**

```csharp
// Now supports type inference with modifiers
(name, out success) => { ... }
```

This change removes a syntactic cliff where adding any modifier to lambda parameters forced developers into the verbose explicit type syntax.

### Partial Members Expansion

**Timeframe:** 00:07:30 - 00:11:15  
**Duration:** 3m 45s  
**Speakers:** Mads Torgersen, Dustin Campbell

Building on C# 13's introduction of partial properties and indexers, C# 14 expands partial member support to include events and constructors, completing the partial member story for source generators.

**Context and Evolution:**

- C# 3 introduced partial methods primarily for code generation extensibility
- Source generators reversed this pattern: user code declares, generator implements
- C# 13 added partial properties and indexers
- C# 14 completes the picture with partial events and constructors

**Demonstrated Implementation:**

```csharp
// User-defined class with partial event declaration
public partial class Person
{
    public partial event Action<string> NameChanged;
}

// Source generator provides implementation
public partial class Person
{
    public partial event Action<string> NameChanged
    {
        add { /* generated implementation */ }
        remove { /* generated implementation */ }
    }
}
```

This enhancement enables source generators to provide complete eventing infrastructure based on simple declarations.

### NameOf Generic Type Fix

**Timeframe:** 00:11:15 - 00:13:00  
**Duration:** 1m 45s  
**Speakers:** Dustin Campbell, Mads Torgersen

A long-overdue fix for a C# 6 limitation where `nameof` required dummy type arguments for generic types, unlike `typeof`.

**Previous Issue:**

```csharp
nameof(ChangedHandler<object>) // Required dummy type argument
typeof(ChangedHandler<>)       // Could use unbound generic
```

**C# 14 Solution:**

```csharp
nameof(ChangedHandler<>) // Now supports unbound generics
```

This fix, eight versions in the making, eliminates an arbitrary inconsistency that forced developers to provide meaningless type arguments when using `nameof` with generic types.

## Field Keyword in Auto-Properties

**Timeframe:** 00:13:00 - 00:18:30  
**Duration:** 5m 30s  
**Speakers:** Mads Torgersen, Dustin Campbell

This major feature addresses the "cliff" developers face when needing to add custom logic to auto-properties, previously requiring a complete rewrite to manual property implementation.

**The Problem:**
Auto-properties work perfectly until you need one small customization (validation, event triggering, etc.), forcing abandonment of the concise auto-property syntax.

**The Solution - Field Keyword:**

```csharp
public string Name 
{ 
    get => field;
    set 
    {
        field = value.Trim();
        NameChanged?.Invoke(value);
    }
}
```

**Key Features:**

- Maintains auto-property backing field generation
- Accessible via contextual `field` keyword
- Encapsulated: other members cannot access the backing field
- Works with any combination of custom getters/setters

**Breaking Change Considerations:**
The `field` keyword introduces a contextual keyword that could conflict with existing field names. The compiler provides warnings and suggested fixes:

- Use `@field` to reference the existing field as an identifier
- Use `this.field` to access the existing field via member access
- Automatic code fixes will be available at release

**Impact:**
This feature removes a significant pain point in C# development, allowing developers to incrementally add complexity to properties without losing the benefits of auto-property syntax.

## Extension Members Revolution

### Extension Methods Reimagined

**Timeframe:** 00:18:30 - 00:25:00  
**Duration:** 6m 30s  
**Speakers:** Mads Torgersen, Dustin Campbell

After 17 years since C# 3's extension methods, C# 14 introduces a revolutionary new syntax that enables extension properties, static extension methods, and future extension operators.

**Historical Context:**

- C# 3 (2008) introduced extension methods with immediate requests for extension properties
- The original syntax worked for methods due to their parameter lists and type parameters
- Properties lacked these syntactic elements, creating an insurmountable design challenge

**The Breakthrough - Extension Blocks:**

```csharp
extension MyEnumerable for IEnumerable<TSource>
{
    public TSource First()
    {
        // Implementation using 'source' parameter
        return source.FirstOrDefault() ?? throw new InvalidOperationException();
    }
}
```

**Key Design Decisions:**

- Extract method-specific elements (type parameters, receiver parameter) to extension block scope
- Remove redundant `static` and `this` keywords from member declarations
- Maintain parameter syntax for receiver to support modifiers, attributes, and nullability
- Generate compatible static extension methods for backward compatibility

### Extension Properties

**Timeframe:** 00:25:00 - 00:30:00  
**Duration:** 5m 00s  
**Speakers:** Dustin Campbell, Mads Torgersen

The most requested feature since extension methods finally arrives, enabling property-like syntax for extended types.

**Syntax Transformation:**

```csharp
extension MyEnumerable for IEnumerable<TSource>
{
    // Convert method to property by removing parameters and adding accessors
    public TSource First
    {
        get => source.FirstOrDefault() ?? throw new InvalidOperationException();
        set => throw new NotSupportedException(); // Optional setter
    }
}
```

**Usage:**

```csharp
var numbers = new[] { 1, 2, 3 };
var first = numbers.First; // Property access instead of method call
```

**Limitations and Design Principles:**

- No extension auto-properties (no state can be added to external objects)
- No extension fields or field-like events
- Setters must implement custom logic (often using external state stores)

**Disambiguation:**
Since properties can't use static method call syntax for disambiguation, the compiler generates special methods:

```csharp
var first = numbers.get_First(); // Disambiguate getter
numbers.set_First(value);        // Disambiguate setter
```

### Static Extension Methods

**Timeframe:** 00:30:00 - 00:35:00  
**Duration:** 5m 00s  
**Speakers:** Mads Torgersen, Dustin Campbell

Static extension methods solve discoverability issues for factory methods and utility functions by attaching them to relevant types.

**Problem Addressed:**
Factory methods like `Enumerable.Range()` are not discoverable through IntelliSense when working with the target type.

**Solution:**

```csharp
extension MyEnumerable for IEnumerable<TSource>
{
    public static IEnumerable<int> Range(int start, int count)
    {
        for (int i = 0; i < count; i++)
            yield return start + i;
    }
}
```

**Usage:**

```csharp
var range = IEnumerable<int>.Range(1, 10); // Discoverable via dot notation
```

**Receiver Type Flexibility:**
Static extension methods can target type parameters with constraints, enabling generic utility methods:

```csharp
extension NumericExtensions for T where T : INumber<T>
{
    public static IEnumerable<T> Range(T start, T count)
    {
        // Generic numeric range implementation
    }
}

var longRange = long.Range(1, 1000); // Available on any numeric type
```

### Generic Math Integration

**Timeframe:** 00:35:00 - 00:37:30  
**Duration:** 2m 30s  
**Speakers:** Dustin Campbell, Mads Torgersen

The session demonstrates how extension members integrate beautifully with .NET's generic math capabilities, showcasing the power of combining modern C# features.

**Generic Math with Extensions:**

```csharp
extension NumericExtensions for T where T : INumber<T>
{
    public static IEnumerable<T> Range(T start, T count)
    {
        for (T i = T.Zero; i < count; i++)
            yield return start + i; // Generic arithmetic operators
    }
}
```

**Cross-Type Compatibility:**

```csharp
var intRange = int.Range(1, 10);      // Works with int
var longRange = long.Range(1L, 100L); // Works with long
var uintRange = uint.Range(1u, 50u);  // Works with uint
```

This integration showcases how modern C# features work together to create expressive, type-safe, and efficient code.

## Compound Assignment Operators

**Timeframe:** 00:37:30 - 00:45:00  
**Duration:** 7m 30s  
**Speakers:** Mads Torgersen, Dustin Campbell

C# 14 introduces the ability to directly overload compound assignment operators, addressing performance concerns in high-performance computing scenarios.

**Current Limitation:**
Compound operators like `+=` are implemented by overloading the base operator (`+`) and using `x = x + y` semantics, which can be inefficient for large data structures.

**Performance Problem:**

```csharp
matrix1 += matrix2; // Currently: matrix1 = matrix1 + matrix2
                    // Creates temporary matrix, then assigns result
```

**New Direct Overloading:**

```csharp
public void operator +=(IEnumerable<TKey> keys)
{
    foreach (var key in keys)
        this.Add(key); // Direct mutation, no temporary objects
}
```

**Key Design Changes:**

- **Instance Methods**: Unlike traditional static operator overloads, compound operators are instance methods
- **Void Return**: Focus on mutation rather than returning new values
- **Virtual Support**: Can be virtual, abstract, or overridden (unlike static operators)
- **Selective Implementation**: Can implement compound operators without corresponding binary operators

**Usage Example:**

```csharp
var dict = new Dictionary<int, string> { [1] = "one", [2] = "two" };
dict -= [1, 3]; // Removes keys 1 and 3 (if present)
```

This feature particularly benefits mathematical libraries, game engines, and any domain working with large mutable data structures where allocation costs matter.

## Dictionary Expressions

**Timeframe:** 00:45:00 - 00:55:00  
**Duration:** 10m 00s  
**Speakers:** Dustin Campbell, Mads Torgersen

Building on collection expressions from earlier C# versions, dictionary expressions provide intuitive syntax for dictionary initialization and manipulation.

**Evolution from Object Initializers:**

```csharp
// Previous: Object initializer syntax
var dict = new Dictionary<int, string> 
{
    [1] = "one",
    [2] = "two",
    [3] = "three"
};

// New: Dictionary expression syntax
var dict = new Dictionary<int, string> 
{
    1: "one",
    2: "two", 
    3: "three"
};
```

**Technical Implementation:**

- Dictionary expressions are actually collection expressions with key-value pair elements
- Use colon (`:`) syntax to separate keys from values
- Target types with `KeyValuePair<TKey, TValue>` as element type support this syntax
- Last-write-wins semantics for duplicate keys (no exceptions thrown)

**Constructor Arguments with 'with' Syntax:**

```csharp
var dict = new Dictionary<string, int> 
{
    with: StringComparer.OrdinalIgnoreCase, // Pass constructor arguments
    "apple": 1,
    "banana": 2,
    "cherry": 3
};
```

**Integration with Compound Operators:**

```csharp
dict += { 4: "four", 5: "five" }; // Add multiple key-value pairs
dict -= ["apple", "banana"];      // Remove multiple keys
```

**Interface Support:**

```csharp
IDictionary<int, string> dict = { 1: "one", 2: "two" }; // Compiler chooses implementation
```

**Builder Pattern Support:**
Like collection expressions, dictionary expressions support custom builders for immutable collections and specialized dictionary types like `FrozenDictionary`.

## Q&A Session

**Timeframe:** 00:55:00 - 01:00:00  
**Duration:** 5m 00s  
**Speakers:** Mads Torgersen, Dustin Campbell, Conference Attendees

### Question 1: Extension Method Use Cases

**Attendee:** Alec from New Jersey  
**Context:** Expression of gratitude for static extension methods  
**Response:** Acknowledgment that DateTime.Min and DateTime.Max scenarios are common motivators for this feature.

### Question 2: Python-Inspired Data Types

**Attendee:** Question about Python data types missing in C#  
**Response:** C# already has comprehensive tuple support with named elements, which surpasses Python's tuple capabilities. The speakers emphasize C#'s superior tuple implementation with element names and extension method support.

### Question 3: Field Keyword Breaking Changes

**Attendee:** Alden from Portland, Oregon  
**Question:** Clarification on warnings for field keyword conflicts  
**Response:** The current plan provides warnings when existing code might be affected, with code fixes to restore previous semantics. The team moved away from upgrade-breaking approaches in favor of warnings with fixers.

### Question 4: Performance Philosophy

**Attendee:** Question about language complexity vs. performance trade-offs  
**Response:** Detailed explanation of Microsoft's commitment to making high-level language features perform as well as or better than hand-written code. Examples include:

- Pattern matching generates highly optimized code
- Collection expressions allow compiler optimizations
- Spans provide safe low-level performance
- The compiler continuously improves generated code across releases

## References

### Official Microsoft Documentation

- **[C# Language Specification](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/)** - The official specification for the C# programming language. Essential for understanding the formal semantics of new language features and how they integrate with existing functionality.

- **[What's new in C# 14](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14)** - Official documentation covering all C# 14 features as they become available. Provides comprehensive examples and migration guidance for each feature discussed in this session.

### Source Generators and Partial Members

- **[Source Generators in C#](https://docs.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/source-generators-overview)** - Comprehensive guide to source generators, which are the primary motivation for expanding partial member support. Understanding source generators is crucial for appreciating why partial events and constructors matter.

- **[Partial Types and Methods](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/partial-classes-and-methods)** - Foundation documentation for partial types, showing the evolution from C# 3's partial methods to the modern source generator ecosystem.

### Generic Math and High-Performance Computing

- **[Generic Math in .NET](https://devblogs.microsoft.com/dotnet/preview-features-in-net-6-generic-math/)** - Deep dive into .NET's generic math capabilities that enable the type-safe numeric extension methods demonstrated in the session. Critical for understanding how extension members can leverage modern .NET capabilities.

- **[Performance Improvements in .NET](https://devblogs.microsoft.com/dotnet/performance-improvements-in-net-6/)** - Ongoing series covering Microsoft's performance philosophy and how compiler optimizations make high-level language features performant. Relevant to the session's discussion of making elegant code fast.

### Collection Expressions and Language Design

- **[Collection Expressions in C#](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions)** - Foundation for understanding how dictionary expressions build upon collection expression syntax. Shows the evolutionary approach to language design demonstrated in this session.

- **[C# Language Design Process](https://github.com/dotnet/csharplang)** - The public repository where C# language features are designed and discussed. Provides insight into the decision-making process behind the features demonstrated, including design alternatives and trade-offs.

### Extension Methods Evolution

- **[Extension Methods (C# Programming Guide)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods)** - Historical foundation for understanding why the 17-year journey to extension properties was so significant. Shows the limitations that the new extension member syntax overcomes.

- **[LINQ and Extension Methods](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/)** - Demonstrates the transformative impact of extension methods in C# 3 and why extending this capability to other member types represents a major evolution in C# expressiveness.

## Appendix A: C# Version History and Features

For a comprehensive overview of C# language evolution from version 1.0 through the upcoming C# 14.0, including detailed feature descriptions and official documentation links, see the dedicated appendix document: **[Appendix A - C# Version History and Features](./appendix-a-cs-version-history-and-features.md)**

This appendix provides:

- **Chronological Evolution**: Complete timeline from C# 1.0 (2002) to C# 14.0 (2025)
- **Feature Categorization**: Major language features organized by version with clear descriptions
- **Historical Context**: Understanding how each version built upon previous capabilities
- **Official References**: Direct links to Microsoft documentation for each version
- **C# 14.0 Preview**: Detailed coverage of upcoming features discussed in this session

The appendix serves as both a reference guide for understanding the progression of C# language features and a resource for developers wanting to trace the evolution of specific capabilities like generics, LINQ, async/await, pattern matching, and the latest extension member innovations.
