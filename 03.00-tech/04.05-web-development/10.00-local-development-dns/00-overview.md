---
title: "Local Development DNS and the .localhost TLD"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [dns, local-development, networking, dotnet, web-development, overview]
description: "First-touch orientation to local development hostnames — what the reserved .localhost TLD is, why tools generate names like myapp.dev.localhost, and when to use them."
---

# Local Development DNS and the `.localhost` TLD

Modern tooling (Visual Studio, .NET 10+, Aspire, and reverse proxies) increasingly gives your local apps real-looking hostnames like `myapp.dev.localhost` instead of bare `localhost:5001`. This overview explains what that is, why it helps, and where to go for the details.

## 📑 Table of Contents

1. [What it is](#what-it-is)
2. [Why it exists](#why-it-exists)
3. [When to use it](#when-to-use-it)
4. [When not to bother](#when-not-to-bother)
5. [Where to go next](#where-to-go-next)
6. [References](#references)

## What it is

`.localhost` is a **reserved top-level domain** that always resolves to the loopback address (127.0.0.1 / ::1) — no DNS registration and no `hosts` file edits. Crucially, *anything* ending in `.localhost` resolves to your own machine, so `myapp.dev.localhost`, `api.dev.localhost`, and `frontend.dev.localhost` all just work. Tools use this to give each local service a distinct, production-like hostname.

## Why it exists

Running several services on bare `localhost` forces you to juggle ports (`localhost:5001`, `localhost:5002`, …) and makes authentication, cookies, and CORS behave differently than they will in production. Named hosts under a shared suffix (`*.dev.localhost`) let your local setup mirror a real `service.company.com` topology.

## When to use it

- Multi-service solutions (a front end plus one or more APIs).
- Auth flows that depend on realistic hosts (OIDC, OAuth, cookies, CORS).
- Subdomain- or host-based routing through a local reverse proxy.
- Aspire / .NET 10 local development, where tooling generates the names for you.

## When not to bother

- A single app with no auth or cross-service concerns — bare `localhost:PORT` is simpler.

## Where to go next

- [Concepts: the `.localhost` TLD and hostname ordering](02-concepts-localhost-tld-and-hostname-ordering.md) — the DNS mental model and why `app.dev.localhost` beats `dev.app.localhost`.
- [How-to: route `*.dev.localhost` with YARP and a wildcard dev certificate](03-howto-route-dev-localhost-with-yarp-and-wildcard-cert.md) — the practical multi-service setup.
- [Blazor Concepts: using Blazor with Aspire](../01.00-blazor/02.01-concepts-blazor-with-aspire.md) — where these local hostnames show up in practice.

## References

- [RFC 6761 — Special-Use Domain Names (`localhost`)](https://www.rfc-editor.org/rfc/rfc6761) 📘 [Official]
- [ASP.NET Core Blazor / .NET local development](https://learn.microsoft.com/en-us/aspnet/core/) 📘 [Official]

<!--
article_metadata:
  content_type: "overview"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Local development DNS / TLD"
  source_issue: "src/docs/90. Issues/202607/20260702.03-whatisTLD"
-->
