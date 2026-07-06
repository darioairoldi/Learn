---
title: "How-to: Route *.dev.localhost with YARP and a Wildcard Dev Certificate"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [dns, local-development, networking, yarp, tls, web-development, how-to]
description: "Serve multiple local services behind clean *.dev.localhost hostnames on one HTTPS port using a YARP reverse proxy and a trusted wildcard development certificate."
---

# How-to: Route `*.dev.localhost` with YARP and a Wildcard Dev Certificate

**Goal:** run several local services behind production-like hostnames (`frontend.dev.localhost`, `api.dev.localhost`) on a single HTTPS port, using a [YARP](https://microsoft.github.io/reverse-proxy/) reverse proxy and one trusted `*.dev.localhost` certificate.

## 📑 Table of Contents

1. [Prerequisites](#prerequisites)
2. [How name resolution works (and the Windows caveat)](#how-name-resolution-works-and-the-windows-caveat)
3. [Step 1 — Create a trusted wildcard certificate](#step-1--create-a-trusted-wildcard-certificate)
4. [Step 2 — Create the YARP proxy](#step-2--create-the-yarp-proxy)
5. [Step 3 — Configure routes by host](#step-3--configure-routes-by-host)
6. [Step 4 — Run and verify](#step-4--run-and-verify)
7. [When to use / when not to](#when-to-use--when-not-to)
8. [References](#references)

## Prerequisites

- .NET SDK installed.
- [`mkcert`](https://github.com/FiloSottile/mkcert) (generates a locally trusted CA and wildcard certs — `dotnet dev-certs` can't issue custom SANs).
- One or more services already running locally (e.g. a front end on `https://localhost:5001`, an API on `https://localhost:5002`).

## How name resolution works (and the Windows caveat)

Anything under `.localhost` is reserved to loopback (RFC 6761). **Chromium browsers** (Chrome/Edge) resolve `*.localhost` to 127.0.0.1 automatically, so browser access to `frontend.dev.localhost` needs no configuration.

> ⚠️ **Windows caveat:** the Windows OS resolver only resolves `localhost` itself, not arbitrary `*.localhost` subdomains. Browser access works (Chromium resolves in-app), but `curl`, `HttpClient`, and other non-browser clients may fail. For those, add explicit `hosts` entries:
>
> ```text
> # C:\Windows\System32\drivers\etc\hosts
> 127.0.0.1 frontend.dev.localhost
> 127.0.0.1 api.dev.localhost
> ```

## Step 1 — Create a trusted wildcard certificate

```bash
mkcert -install                       # trust the local CA (once per machine)
mkcert -pkcs12 "*.dev.localhost"      # → ./_wildcard.dev.localhost.p12 (password: changeit)
```

This produces a PKCS#12 file covering every `*.dev.localhost` host, trusted by your browsers.

## Step 2 — Create the YARP proxy

```bash
dotnet new web -n DevProxy
cd DevProxy
dotnet add package Yarp.ReverseProxy
```

`Program.cs`:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"));

var app = builder.Build();
app.MapReverseProxy();
app.Run();
```

Bind Kestrel to HTTPS with the wildcard cert (`appsettings.json`):

```json
{
  "Kestrel": {
    "Endpoints": {
      "Https": {
        "Url": "https://*:443",
        "Certificate": { "Path": "_wildcard.dev.localhost.p12", "Password": "changeit" }
      }
    }
  }
}
```

## Step 3 — Configure routes by host

Add to `appsettings.json` — YARP matches the incoming `Host` header and forwards to the matching cluster:

```json
{
  "ReverseProxy": {
    "Routes": {
      "frontend": { "ClusterId": "frontend", "Match": { "Hosts": [ "frontend.dev.localhost" ] } },
      "api":      { "ClusterId": "api",      "Match": { "Hosts": [ "api.dev.localhost" ] } }
    },
    "Clusters": {
      "frontend": { "Destinations": { "d1": { "Address": "https://localhost:5001/" } } },
      "api":      { "Destinations": { "d1": { "Address": "https://localhost:5002/" } } }
    }
  }
}
```

Adding a new service is one route + one cluster — no new port to remember, no new certificate.

## Step 4 — Run and verify

```bash
dotnet run                            # proxy listens on https://*:443
```

Open `https://frontend.dev.localhost` and `https://api.dev.localhost` in a Chromium browser. You should see:

- a valid padlock (the wildcard cert is trusted), and
- each host routed to the correct downstream service.

A cookie set with `Domain=dev.localhost` will now be sent to **both** hosts — the shared-suffix behavior explained in [Concepts: the `.localhost` TLD and hostname ordering](02-concepts-localhost-tld-and-hostname-ordering.md).

## When to use / when not to

- **Use it** for multi-service local development where you want production-like hosts, shared cookies/SSO, and one HTTPS surface.
- **Skip it** for a single app with no auth or cross-service concerns — bare `localhost:PORT` is simpler. Note that Aspire can provide equivalent local hostnames and routing without hand-rolling a proxy.

## References

- [YARP — Reverse Proxy](https://microsoft.github.io/reverse-proxy/) 📘 [Official]
- [mkcert](https://github.com/FiloSottile/mkcert) 📗 [Verified Community]
- [RFC 6761 — Special-Use Domain Names (`localhost`)](https://www.rfc-editor.org/rfc/rfc6761) 📘 [Official]

<!--
article_metadata:
  content_type: "how-to"
  subcategory: "task-guide"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Local development DNS / TLD"
  source_issue: "src/docs/90. Issues/202607/20260702.03-whatisTLD"
-->
