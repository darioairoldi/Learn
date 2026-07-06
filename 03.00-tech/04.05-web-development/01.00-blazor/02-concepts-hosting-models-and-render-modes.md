---
title: "Blazor Concepts: Hosting Models and Render Modes"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [blazor, dotnet, web-development, concepts]
description: "The Blazor mental model — how hosting models became per-component render modes in .NET 8, what the .Client project is, and why the old Hosted WebAssembly template disappeared."
---

# Blazor Concepts: Hosting Models and Render Modes

This is the keystone mental model for modern Blazor. Once render modes click, the template choices, the missing "WASM + Web API" starter, and the migration path all make sense.

## 📑 Table of Contents

1. [Hosting models vs render modes](#hosting-models-vs-render-modes)
2. [The .NET 8 pivot](#the-net-8-pivot)
3. [The four render modes](#the-four-render-modes)
4. [The `.Client` project](#the-client-project)
5. [Why there's no "WASM + Web API" template](#why-theres-no-wasm--web-api-template)
6. [References](#references)

## Hosting models vs render modes

A **hosting model** describes *where* a Razor component executes:

- **Blazor Server** — on the server, with UI diffs sent over a SignalR (WebSocket) circuit.
- **Blazor WebAssembly** — in the browser, on a WebAssembly-based .NET runtime.
- **Blazor Hybrid** — natively inside a desktop/mobile app (.NET MAUI, WPF, Windows Forms) via an embedded web view.

The components you write are the same across all three — only their execution location differs.

## The .NET 8 pivot

Before .NET 8, you chose the hosting model **once, for the whole app**, at project creation. That produced one template per shape: Blazor Server, standalone WebAssembly, and Hosted WebAssembly (Client + Server + Shared).

.NET 8 replaced that with the **Blazor Web App** — a single project where the hosting decision moves down to **each component** through its **render mode**. Rendering is now a per-component choice made *inside* one app, not a template you pick up front.

## The four render modes

- **Static SSR** — the server renders HTML once; no interactivity. Ideal for content pages.
- **Interactive Server** — interactivity over a SignalR circuit (the old "Blazor Server").
- **Interactive WebAssembly** — interactivity via client-side Wasm (the old "Blazor WebAssembly").
- **Interactive Auto** — starts as Interactive Server for a fast first paint, then switches to WebAssembly once the runtime finishes downloading.

## The `.Client` project

When you enable a WebAssembly or Auto render mode, the Blazor Web App template adds a second **`.Client` project**. Components that must run in the browser live there; the built output is downloaded and executed on the client. It's the modern equivalent of the old "Client" project — but it's created **on demand**, not baked into every template.

## Why there's no "WASM + Web API" template

Because the framework no longer fixes a hosting model per app, it can't assume a fixed **API boundary** per app either. "UI rendering choice" and "backend boundary choice" became **independent decisions**. A bundled "WASM + Web API" template would re-couple them and silently pick an architecture — which is exactly the Hosted WebAssembly assumption that was retired. So a REST API is now a **composition choice** you add, not a template default. The two resulting shapes are covered in [Analysis](04-analysis-architecture-decision.md).

## References

- [ASP.NET Core Blazor render modes](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/render-modes?view=aspnetcore-10.0) 📘 [Official]
- [ASP.NET Core Blazor hosting models](https://learn.microsoft.com/en-us/aspnet/core/blazor/hosting-models?view=aspnetcore-10.0) 📘 [Official]
- [ASP.NET Core Blazor project structure](https://learn.microsoft.com/en-us/aspnet/core/blazor/project-structure?view=aspnetcore-10.0) 📘 [Official]

<!--
article_metadata:
  content_type: "concepts"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Blazor"
  source_issue: "src/docs/90. Issues/202607/20260702.04-why-no-blazor-webassembly-webapi"
-->
