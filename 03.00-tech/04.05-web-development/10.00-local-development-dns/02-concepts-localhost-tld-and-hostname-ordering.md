---
title: "Concepts: The .localhost TLD and Hostname Ordering"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [dns, local-development, networking, dotnet, web-development, concepts]
description: "How the reserved .localhost TLD works and why app-first hostname ordering (contosoapi.dev.localhost) beats environment-first (dev.contosoapi.localhost) for cookies, certificates, CORS, and routing."
---

# Concepts: The `.localhost` TLD and Hostname Ordering

When you enable the .NET 10 option to use the `.dev.localhost` TLD, a project called `ContosoApi` gets a local URL like `https://contosoapi.dev.localhost:7043`. This article explains how `.localhost` resolution works and — the key mental model — **why the labels are ordered app-first (`contosoapi.dev.localhost`) rather than environment-first (`dev.contosoapi.localhost`)**.

## 📑 Table of Contents

1. [The `.localhost` TLD](#the-localhost-tld)
2. [DNS names are read right-to-left](#dns-names-are-read-right-to-left)
3. [Why app-first ordering wins](#why-app-first-ordering-wins)
4. [Resolution is a non-issue either way](#resolution-is-a-non-issue-either-way)
5. [Summary](#summary)
6. [References](#references)

## The `.localhost` TLD

`.localhost` is a **reserved special-use domain** (RFC 6761). Resolvers and browsers map it — and anything under it — to the loopback address (127.0.0.1 / ::1). So `contosoapi.dev.localhost`, `frontend.dev.localhost`, and `api.dev.localhost` all resolve to your own machine with no DNS or `hosts` configuration. That's what makes it safe for tools to generate arbitrary local hostnames.

## DNS names are read right-to-left

A hostname is a hierarchy where the **rightmost label is the top**, and each label to its left is a child *under* it:

```text
contosoapi . dev . localhost          dev . contosoapi . localhost
    └service   │      └TLD (loopback)    │       └app        └TLD
               └"the dev environment"    └"an environment under one app"
```

- **`contosoapi.dev.localhost`** treats **`dev.localhost` as a shared suffix** ("the local dev environment"), with each service a sibling leaf under it: `contosoapi.dev.localhost`, `frontend.dev.localhost`, `identity.dev.localhost`.
- **`dev.contosoapi.localhost`** treats **`contosoapi.localhost` as the domain** ("this one app"), with `dev`, `staging`, and `prod` as environments beneath that single app.

## Why app-first ordering wins

**1. It mirrors production naming.** Production is `service.company.com` (`api.contoso.com`, `app.contoso.com`) — service leftmost, shared organization suffix on the right. `contosoapi.dev.localhost` matches that shape, so redirect URIs, CORS origins, certificate names, and links all look production-like. Environment-first ordering inverts the convention.

**2. It groups all your local services under one shared suffix, which is what enables sharing:**

| Concern | With `app.dev.localhost` (shared `dev.localhost` suffix) | With `dev.app.localhost` |
|---|---|---|
| Cookies / auth / SSO | A cookie scoped to `Domain=dev.localhost` reaches every `*.dev.localhost` host — shared session across services, like production scoped to `contoso.com`. | The shared parent is `contosoapi.localhost`, so a shared cookie spans *environments of one app*, not *services of one environment* — the wrong grouping. |
| CORS | Allowed origins are a clean set of `*.dev.localhost` siblings. | Origins scatter across per-app parents. |
| Wildcard TLS certificate | One `*.dev.localhost` cert covers all local services. | Needs a separate `*.contosoapi.localhost` cert per app. |
| Host-based routing | A local reverse proxy routes by leftmost label: `{service}.dev.localhost` → that service. | Routing key is buried under each app. |

## Resolution is a non-issue either way

Both orderings end in `.localhost`, so both resolve to loopback. The difference is **purely semantic grouping** — and app-first gives the grouping that makes cross-service cookies, certificates, CORS, and routing natural.

## Summary

`contosoapi.dev.localhost` makes **"dev" the shared domain** and each app a **service under it** (like production `service.company.com`), so local apps can share cookies/SSO, a wildcard certificate, and routing. `dev.contosoapi.localhost` makes **one app the domain** and environments its children — which breaks cross-service sharing and doesn't match production conventions. That's why .NET generates `{projectname}.dev.localhost`.

This concept shows up directly in [Blazor with Aspire](../01.00-blazor/02.01-concepts-blazor-with-aspire.md), where local orchestration assigns each service its own hostname.

## References

- [RFC 6761 — Special-Use Domain Names (`localhost`)](https://www.rfc-editor.org/rfc/rfc6761) 📘 [Official]
- [MDN — `Set-Cookie` `Domain` attribute](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie) 📗 [Verified Community]
- [ASP.NET Core / .NET local development](https://learn.microsoft.com/en-us/aspnet/core/) 📘 [Official]

<!--
article_metadata:
  content_type: "concepts"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Local development DNS / TLD"
  source_issue: "src/docs/90. Issues/202607/20260702.03-whatisTLD"
-->
