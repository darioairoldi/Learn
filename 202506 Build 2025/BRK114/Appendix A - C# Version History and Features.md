# Appendix A: C# Version History and Features

This appendix provides a comprehensive chronological overview of C# language evolution from version 1.0 to the upcoming C# 14.0. Each version entry includes major language features, their purposes, and links to official documentation.

## C# 1.0 (2002) - .NET Framework 1.0

**Core Language Features:**

- **Classes and Objects** - Object-oriented programming foundation with inheritance, encapsulation, and polymorphism
- **Value Types and Reference Types** - Distinction between stack-allocated value types and heap-allocated reference types
- **Properties** - Encapsulated field access with get/set accessors
- **Indexers** - Array-like access to object members using bracket notation
- **Events** - Type-safe callback mechanism built on delegates
- **Operator Overloading** - Custom behavior for operators on user-defined types
- **Attributes** - Metadata decoration system for types and members

**Reference:** [C# 1.0 Language Specification](https://www.ecma-international.org/publications/standards/Ecma-334.htm)

## C# 1.1 (2003) - .NET Framework 1.1

**Minor Updates:**

- **APM Pattern Support** - Improved asynchronous programming model support
- **Performance Improvements** - Various compiler and runtime optimizations

**Reference:** [.NET Framework 1.1 Release Notes](https://docs.microsoft.com/en-us/dotnet/framework/whats-new/)

## C# 2.0 (2005) - .NET Framework 2.0

**Major Language Features:**

- **Generics** - Type-safe collections and methods with compile-time type checking
- **Partial Types** - Split type definitions across multiple files for code generation scenarios
- **Anonymous Methods** - Inline delegate definitions using `delegate` keyword
- **Iterators** - `yield return` and `yield break` for lazy enumeration
- **Nullable Types** - `int?` syntax for value types that can be null
- **Covariance and Contravariance** - Basic variance support for delegates
- **Static Classes** - Classes that cannot be instantiated and contain only static members
- **Property Accessor Accessibility** - Different access levels for get/set accessors

**Reference:** [What's New in C# 2.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-20)

## C# 3.0 (2007) - .NET Framework 3.5

**Major Language Features:**

- **LINQ (Language Integrated Query)** - Query syntax for data sources with compile-time checking
- **Extension Methods** - Add methods to existing types without modification
- **Lambda Expressions** - Concise syntax for anonymous functions: `x => x * 2`
- **Expression Trees** - Represent code as data for dynamic query generation
- **Anonymous Types** - `new { Name = "John", Age = 30 }` for temporary data structures
- **Automatic Properties** - `public string Name { get; set; }` shorthand syntax
- **Object and Collection Initializers** - Simplified initialization syntax
- **Implicitly Typed Local Variables** - `var` keyword for type inference
- **Partial Methods** - Method declarations without implementations in partial types

**Reference:** [What's New in C# 3.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-30)

## C# 4.0 (2010) - .NET Framework 4.0

**Major Language Features:**

- **Dynamic Binding** - `dynamic` keyword for runtime type resolution
- **Named and Optional Parameters** - Method parameters with default values and named arguments
- **Generic Covariance and Contravariance** - `out` and `in` keywords for interface and delegate variance
- **Embedded Interop Types** - "No PIA" feature for COM interop simplification

**Reference:** [What's New in C# 4.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-40)

## C# 5.0 (2012) - .NET Framework 4.5

**Major Language Features:**

- **Async and Await** - Asynchronous programming with `async`/`await` keywords
- **Caller Information Attributes** - `[CallerMemberName]`, `[CallerFilePath]`, `[CallerLineNumber]` for debugging

**Reference:** [What's New in C# 5.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-50)

## C# 6.0 (2015) - .NET Framework 4.6

**Major Language Features:**

- **Static Imports** - `using static` to import static members
- **Exception Filters** - `catch (Exception ex) when (condition)` syntax
- **Auto-property Initializers** - `public string Name { get; set; } = "Default";`
- **Expression-bodied Members** - `public string FullName => $"{First} {Last}";`
- **Null-conditional Operators** - `?.` and `?[]` for safe member access
- **String Interpolation** - `$"Hello {name}"` syntax
- **nameof Expressions** - `nameof(variable)` for refactor-safe string literals
- **Index Initializers** - Dictionary initialization with `[key] = value` syntax

**Reference:** [What's New in C# 6.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-60)

## C# 7.0 (2017) - .NET Framework 4.7

**Major Language Features:**

- **Tuples** - `(int, string)` value tuple syntax with named elements
- **Pattern Matching** - `is` expressions and `switch` patterns
- **Out Variables** - `int.TryParse(s, out var result)` inline declarations
- **Local Functions** - Nested function definitions within methods
- **More Expression-bodied Members** - Constructors, destructors, property accessors
- **Throw Expressions** - `throw` as expression in conditional operators
- **Binary Literals and Digit Separators** - `0b1010` and `1_000_000` syntax

**Reference:** [What's New in C# 7.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-70)

## C# 7.1 (2017) - .NET Framework 4.7.1

**Minor Language Features:**

- **Async Main** - `async Task Main()` method support
- **Default Literal Expressions** - `default` without type specification
- **Inferred Tuple Element Names** - Automatic naming from variable names
- **Pattern Matching on Generic Type Parameters** - Enhanced pattern matching capabilities

**Reference:** [What's New in C# 7.1](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-71)

## C# 7.2 (2017) - .NET Framework 4.7.2

**Performance and Safety Features:**

- **Reference Semantics with Value Types** - `ref struct`, `ref readonly`, `in` parameters
- **Non-trailing Named Arguments** - Mixed positional and named arguments
- **Leading Underscores in Numeric Literals** - `_1000` syntax support
- **private protected Access Modifier** - Assembly and inheritance restricted access
- **Conditional ref Expressions** - `ref` in ternary operations

**Reference:** [What's New in C# 7.2](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-72)

## C# 7.3 (2018) - .NET Framework 4.7.2

**Performance and Usability Features:**

- **Enhanced Generic Constraints** - `Enum`, `Delegate`, and `unmanaged` constraints
- **Tuple Equality** - `==` and `!=` operators for tuples
- **Expression Variables in More Places** - Extended scope for pattern variables
- **Attributes on Backing Fields** - `[field: SomeAttribute]` syntax
- **Performance Improvements** - Various `ref` and `stackalloc` enhancements

**Reference:** [What's New in C# 7.3](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history#c-version-73)

## C# 8.0 (2019) - .NET Core 3.0

**Major Language Features:**

- **Nullable Reference Types** - Compile-time null safety with `?` annotations
- **Asynchronous Streams** - `IAsyncEnumerable<T>` and `await foreach`
- **Ranges and Indices** - `[1..^1]` slice syntax and `^` index operator
- **Switch Expressions** - Expression-based switch with `=>` syntax
- **Property Patterns** - Destructuring in pattern matching
- **Using Declarations** - Resource management without braces
- **Static Local Functions** - Performance optimization for local functions
- **Disposable ref structs** - `IDisposable` support for `ref struct` types
- **Null-coalescing Assignment** - `??=` operator for conditional assignment

**Reference:** [What's New in C# 8.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-8)

## C# 9.0 (2020) - .NET 5.0

**Major Language Features:**

- **Records** - Immutable reference types with value semantics
- **Init-only Setters** - `init` keyword for immutable properties
- **Top-level Programs** - Simplified program structure without `Main` boilerplate
- **Pattern Matching Enhancements** - Relational patterns, logical patterns
- **Native ints** - `nint` and `nuint` for platform-specific integers
- **Function Pointers** - Low-level function pointer support
- **Target-typed `new` Expressions** - Type inference for object creation
- **Static Anonymous Functions** - `static` lambdas and local functions
- **Target-typed Conditional Expressions** - Better type inference for ternary
- **Covariant Return Types** - Override methods with more derived return types
- **Module Initializers** - Assembly-level initialization code

**Reference:** [What's New in C# 9.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-9)

## C# 10.0 (2021) - .NET 6.0

**Major Language Features:**

- **Global Using Directives** - `global using` for project-wide imports
- **File-scoped Namespaces** - Simplified namespace syntax
- **Record Structs** - Value type records with similar semantics
- **Improvements to Structure Types** - Parameterless constructors and field initializers
- **Interpolated String Handler** - Performance optimization for string interpolation
- **Lambda Improvements** - Natural type inference and attributes
- **Extended Property Patterns** - Nested property access in patterns
- **Allow const Interpolated Strings** - Compile-time string interpolation
- **Record Types Can Seal ToString** - Prevent further overriding
- **Assignment and Declaration in Same Deconstruction** - Mixed deconstruction syntax
- **Allow AsyncMethodBuilder Attribute on Methods** - Custom async builders

**Reference:** [What's New in C# 10.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-10)

## C# 11.0 (2022) - .NET 7.0

**Major Language Features:**

- **Raw String Literals** - Multi-line strings with `"""` syntax
- **Generic Math Support** - Static abstract members in interfaces
- **Generic Attributes** - Type parameters in attribute declarations
- **UTF-8 String Literals** - `"text"u8` byte array syntax
- **Newlines in String Interpolation** - Multi-line expressions in `{}`
- **List Patterns** - Pattern matching for lists and arrays
- **File-local Types** - `file` keyword for assembly-private types
- **Required Members** - `required` keyword for mandatory initialization
- **Auto-default Structs** - Automatic parameterless constructor
- **Pattern Match Span\<char\> on String** - Performance optimization
- **Extended nameof Scope** - Parameter names in attributes
- **Numeric IntPtr** - Arithmetic operations on `IntPtr`/`UIntPtr`

**Reference:** [What's New in C# 11.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-11)

## C# 12.0 (2023) - .NET 8.0

**Major Language Features:**

- **Primary Constructors** - Constructor parameters available throughout class
- **Collection Expressions** - `[1, 2, 3]` syntax for any collection type
- **Inline Arrays** - Fixed-size arrays as value types
- **Optional Parameters in Lambda Expressions** - Default values in lambdas
- **ref readonly Parameters** - Efficient large value type passing
- **Default Lambda Parameters** - Default values for lambda parameters
- **Alias Any Type** - `using` aliases for any type, including tuples
- **Experimental Attribute** - Mark APIs as experimental
- **Interceptors** - Source generator method call interception (experimental)

**Reference:** [What's New in C# 12.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-12)

## C# 13.0 (2024) - .NET 9.0

**Major Language Features:**

- **Params Collections** - `params` with any collection type, not just arrays
- **New Lock Type** - `System.Threading.Lock` for better performance
- **New Escape Sequence** - `\e` for escape character (ASCII 27)
- **Method Group Natural Type** - Better type inference for method groups
- **Implicit Index Access** - `^` operator in more contexts
- **Partial Properties and Indexers** - Split property definitions across files
- **Overload Resolution Priority** - `[OverloadResolutionPriority]` attribute

**Reference:** [What's New in C# 13.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-13)

## C# 14.0 (2025) - .NET 10.0 (Preview/Upcoming)

**Major Language Features (As discussed in this session):**

- **Field Keyword in Auto-Properties** - Access backing fields with `field` keyword
- **Extension Members** - Extension properties, static extension methods, and future operators
- **Null Conditional Assignment** - `?.=` operator for safe assignment
- **Partial Events and Constructors** - Complete partial member support
- **Compound Assignment Operators** - Direct overloading of `+=`, `-=`, etc.
- **Dictionary Expressions** - `{key: value}` syntax building on collection expressions
- **Lambda Type Inference Improvements** - Better inference with modifiers
- **NameOf Generic Type Fix** - Support for unbound generics in `nameof`

**Reference:** [What's New in C# 14.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14) (when available)
