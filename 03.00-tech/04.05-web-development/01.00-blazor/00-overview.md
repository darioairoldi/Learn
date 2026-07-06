---
title: "Blazor Overview: What It Is and How to Choose an App Model"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [blazor, dotnet, web-development, overview]
description: "First-touch orientation to Blazor — what it is, why it exists, the hosting models, and the two modern app shapes you actually choose between today."
---

# Blazor Overview: What It Is and How to Choose an App Model

Blazor lets you build interactive web UI with **C# and .NET instead of JavaScript**. This overview gives you the mental map: what Blazor is, why it exists, how it's hosted, and which app shape to reach for today. It's the entry point for the deeper articles in this subject.

## 📑 Table of Contents

1. [What Blazor is](#what-blazor-is)
2. [Why it exists](#why-it-exists)
3. [The three hosting models](#the-three-hosting-models)
4. [What changed in .NET 8](#what-changed-in-net-8)
5. [The two modern app shapes](#the-two-modern-app-shapes)
6. [How you're meant to use it today](#how-youre-meant-to-use-it-today)
7. [Where to go next](#where-to-go-next)
8. [References](#references)

## What Blazor is

Blazor is a framework for building web UI from **Razor components** (`.razor` files) that combine markup and C# logic. The key idea: the *same* component can run in different places without a rewrite. *Where* it runs is its **hosting model** (or, in modern Blazor, its **render mode**).

## Why it exists

It exists so .NET teams can build rich, interactive front ends while reusing their existing language, libraries, tooling, and — crucially — **sharing code between client and server**, instead of maintaining a separate JavaScript stack.

## The three hosting models

| Hosting model | Initial load | Needs a live server | Offline / CDN | Full .NET API |
|---|---|---|---|---|
| Blazor Server | Fast (small payload) | Yes (SignalR circuit) | No | Yes |
| Blazor WebAssembly | Slower (downloads runtime) | No (after download) | Yes | No (browser subset) |
| Blazor Hybrid | Fast (native) | No | Yes (native app) | Yes |

## What changed in .NET 8

Before .NET 8 you picked a hosting model *per app* at creation. .NET 8 introduced the **Blazor Web App**, where rendering is a **per-component render mode** (Static SSR, Interactive Server, Interactive WebAssembly, Interactive Auto). The old Hosted WebAssembly template (Client + Server + Shared) was retired from the default experience. See [Concepts](02-concepts-hosting-models-and-render-modes.md) for the full model.

## The two modern app shapes

For "a web app talking to a server," you choose between two supported shapes:

- **Blazor Web App (client + server in one)** — one deployable app; server components call data services directly; add APIs only where needed.
- **Standalone WebAssembly + separate Web API** — a static/CDN-friendly client that talks to an independent backend over REST/gRPC.

The full decision guide, with diagrams and a matrix, is in [Analysis](04-analysis-architecture-decision.md).

## How you're meant to use it today

1. **Default to `blazor` (Blazor Web App).** Start with Interactive Auto unless you have a reason not to.
2. **Use `blazorwasm` (standalone) + a separate Web API** when you need static/CDN hosting, offline/PWA, or a backend shared across clients.
3. **Treat Hosted WebAssembly and standalone Blazor Server templates as legacy** — see the [migration How-to](03-howto-migrate-hosted-wasm-to-blazor-web-app.md).
4. **Add REST/gRPC/SignalR endpoints deliberately**, only at real boundaries.

## Where to go next

- [Concepts: hosting models and render modes](02-concepts-hosting-models-and-render-modes.md) — the mental model.
- [Concepts: using Blazor with Aspire](02.01-concepts-blazor-with-aspire.md) — what the AppHost/ServiceDefaults projects add.
- [How-to: migrate hosted WASM to a Blazor Web App](03-howto-migrate-hosted-wasm-to-blazor-web-app.md).
- [Analysis: architecture decision](04-analysis-architecture-decision.md) — which shape to pick.
- [Reference: templates and render modes](05-reference-templates.md).
- [Resources](06-resources.md) — curated links.

## References

- [ASP.NET Core Blazor hosting models](https://learn.microsoft.com/en-us/aspnet/core/blazor/hosting-models?view=aspnetcore-10.0) 📘 [Official]
- [ASP.NET Core Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/?view=aspnetcore-10.0) 📘 [Official]
- [.NET Blog](https://devblogs.microsoft.com/dotnet/) 📗 [Verified Community]

<!--
article_metadata:
  content_type: "overview"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Blazor"
  source_issue: "src/docs/90. Issues/202607/20260702.04-why-no-blazor-webassembly-webapi"
-->
