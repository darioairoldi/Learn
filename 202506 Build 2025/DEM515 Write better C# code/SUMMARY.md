# Write Better C# Code: Underutilized Features for Modern Development

**Session Date:** Microsoft Build 2025  
**Duration:** ~15 minutes  
**Venue:** Build 2025 Conference - A-Team Stage  
**Speakers:** Mads Torgersen (Lead Designer of C#, Microsoft)  
**Link:** [Session Recording - Build 2025 DEM515]

![C# Language Features](images/csharp-features.png)

---

## Executive Summary

This session focuses on three powerful but underutilized C# features that can significantly improve code quality, safety, and performance. Rather than introducing new features, Mads Torgersen demonstrates how **pattern matching**, **records**, and **collection expressions** work together to create simpler, safer, and more efficient code.

---

## Key Topics Covered

### 🔍 **1. Pattern Matching - Beyond Simple Type Checks**

**Core Concept:** Pattern matching extends beyond traditional type checking to provide flexible, expressive ways to test and extract data from objects.

**Key Features:**
- **Enhanced `is` expressions** with pattern extraction
- **Switch expressions** with pattern support  
- **Property patterns** for deep object inspection
- **List patterns** for collection matching
- **When clauses** for additional conditions

**Benefits:**
- More expressive intent in code
- Compiler optimizations for better performance
- Enhanced safety with exhaustiveness checking
- Automatic reachability analysis

**Example Use Cases:**
- External method implementation when data and functionality are separated
- Complex conditional logic with type hierarchies
- Safe extraction of nested object properties

---

### 📝 **2. Records - Value-Based Object Semantics**

**Core Concept:** Records flip C#'s default reference-based equality to content-based equality, perfect for representing immutable data.

**Key Features:**
- **Value-based equality** comparison by content, not reference
- **Automatic method implementation** (ToString, GetHashCode, Equals)
- **Non-destructive mutation** with `with` expressions
- **Primary constructors** for concise syntax
- **Virtual equality** support in inheritance hierarchies

**Benefits:**
- Correct value semantics without manual implementation
- Immutable data patterns with copy-and-modify operations
- Automatic generation of boilerplate code
- Type-safe hierarchical equality

---

### 🗂️ **3. Collection Expressions - Unified Collection Syntax**

**Core Concept:** A single, clean syntax that works across all collection types with compiler-optimized implementations.

**Key Features:**
- **Universal syntax** for arrays, lists, immutable collections, and interfaces
- **Compiler optimization** often outperforming manual code
- **Type flexibility** - works with mutable and immutable collections
- **Interface support** with automatic concrete type selection

**Benefits:**
- Consistent syntax regardless of collection type
- Optimal performance through compiler analysis
- Reduced cognitive load when switching between collection types
- Future-proof as new collection types are added

---

## Practical Implementation Guidance

### When to Use These Features

**Pattern Matching:**
- External processing of type hierarchies
- Complex conditional logic with data extraction
- API response handling and validation
- State machine implementations

**Records:**
- DTOs and data transfer objects
- Configuration objects
- Value objects in domain models
- API request/response models

**Collection Expressions:**
- Any collection initialization
- Switching between collection types during development
- Performance-critical collection operations
- Generic collection handling

### Migration Strategy

1. **Start with Collection Expressions** - immediate benefit with minimal risk
2. **Introduce Records for DTOs** - clear value semantics wins
3. **Refactor Complex Conditionals** with pattern matching last

---

## Technical Advantages

### Compiler Benefits
- **Enhanced optimization** through pattern analysis
- **Better code generation** for collection operations  
- **Static analysis** for exhaustiveness and reachability
- **Performance improvements** over manual implementations

### Developer Experience
- **Reduced boilerplate** code
- **Improved code safety** through compiler checks
- **Clearer intent** expression
- **Consistent patterns** across different scenarios

---

## Session Highlights

> *"These are syntactic simplifications that express your intent better, make your code safer and more likely to be correct, and allow the compiler to do a better job at making them efficient than you could have done manually."*

> *"When you use switches with patterns, the compiler really gets in there and tries to optimize your code for you... rather than you having to manually figure out the best sequence of ifs and nested ifs."*

---

## About the Speaker

**Mads Torgersen**  
Lead Designer, C# Programming Language  
Principal Architect, Microsoft  

Mads Torgersen is responsible for the evolution and design of the C# programming language, leading the language design team in developing features that balance developer productivity with performance and safety.

---

## Related Sessions

- **What's New in C#** (Build 2025) - Latest language features overview
- **Advanced C# Patterns** - Deep dive into pattern matching scenarios  
- **Modern .NET Development** - Broader ecosystem improvements

---

*This document provides a comprehensive overview of underutilized C# features that can immediately improve your development workflow and code quality.*