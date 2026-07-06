---
title: "Blazor Reference: Templates, Render Modes, and Roadmap"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [blazor, dotnet, web-development, reference]
description: "Authoritative lookup tables for Blazor — the template inventory (current vs legacy), render-mode reference, and the .NET 8–11 roadmap direction."
---

# Blazor Reference: Templates, Render Modes, and Roadmap

Quick-lookup tables for Blazor project templates, render modes, and version direction. For the reasoning behind them, see [Concepts](02-concepts-hosting-models-and-render-modes.md) and [Analysis](04-analysis-architecture-decision.md).

## 📑 Table of Contents

1. [Template inventory](#template-inventory)
2. [Render-mode reference](#render-mode-reference)
3. [Roadmap direction](#roadmap-direction)
4. [References](#references)

## Template inventory

| Template (`dotnet new`) | Produces | Status (.NET 8–11) |
|---|---|---|
| `blazor` | **Blazor Web App** (single project; render modes; adds `.Client` when Wasm/Auto is selected) | ✅ **Current — recommended default** |
| `blazorwasm` | **Standalone Blazor WebAssembly** (static, CDN-deployable client-only app) | ✅ **Current — for SPA / static hosting** |
| `blazor-wasm-servicedefaults` | Aspire service-defaults library for Wasm clients | ✅ Current (helper, .NET 11) |
| `blazorwasm --hosted` (`-ho`) | **Hosted Blazor WebAssembly** (Client + Server + Shared) | 🕳️ **Legacy — removed from default; only via targeting `net7.0` or earlier** |
| `blazorserver` / `blazorserver-empty` | Blazor Server app | 🕳️ **Legacy — .NET 7 and earlier; superseded by Blazor Web App (Interactive Server)** |
| `blazorwasm-empty` | Minimal standalone Wasm | 🕳️ Legacy naming (.NET 7); folded into `blazorwasm` options |

## Render-mode reference

| Render mode | Executes | Interactive | Typical use |
|---|---|---|---|
| Static SSR | Server (once) | No | Content pages, SEO-first |
| Interactive Server | Server (SignalR circuit) | Yes | Fast first paint, full .NET API |
| Interactive WebAssembly | Browser (Wasm) | Yes | Offline-capable, client offload |
| Interactive Auto | Server → then Wasm | Yes | Fast start + client offload after load |

- Enabling a WebAssembly or Auto mode adds a `.Client` project; those components must live there.
- Render mode can be set per component or globally at app creation.

## Roadmap direction

| Version | Direction |
|---|---|
| .NET 8 | Introduced the Blazor Web App and per-component render modes; retired Hosted WebAssembly and standalone Blazor Server templates from the default experience. |
| .NET 9–10 | Refinements to render modes, static-asset fingerprinting/compression, navigation (including a `NotFound` component), and performance. |
| .NET 11 | Adds an Aspire-oriented `blazor-wasm-servicedefaults` library for wiring Wasm clients into observability and service discovery. |

## References

- [Tooling for ASP.NET Core Blazor (template options)](https://learn.microsoft.com/en-us/aspnet/core/blazor/tooling?view=aspnetcore-10.0) 📘 [Official]
- [ASP.NET Core Blazor project structure](https://learn.microsoft.com/en-us/aspnet/core/blazor/project-structure?view=aspnetcore-10.0) 📘 [Official]
- [ASP.NET Core Blazor render modes](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/render-modes?view=aspnetcore-10.0) 📘 [Official]
- [.NET default templates for `dotnet new`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-new-sdk-templates) 📘 [Official]

<!--
article_metadata:
  content_type: "reference"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Blazor"
  source_issue: "src/docs/90. Issues/202607/20260702.04-why-no-blazor-webassembly-webapi"
-->
