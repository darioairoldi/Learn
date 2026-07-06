# Area analysis — Aspire orchestration model vs classic WASM client + Web API

Depth: **standard**. Taxonomy target: **Concepts** (with an Analysis-style pros/cons + verdict). Resolves the open item in sibling `20260702.04/research/05-analysis/aspire-vs-classic-wasm-api.md`.

## Problem statement

The new sample pairs Blazor with **Aspire** and shows more projects than a developer expects. How does it actually work, and how does it differ from a classic solution of a Blazor WebAssembly client + an ASP.NET Core Web API? Which is the modern, recommended approach?

## What the two samples actually contain (from the screenshots)

**Modern — solution `01.02_BlazorSample`:**

| Project | Role |
|---|---|
| `BlazorAspireApp.Web` | The Blazor front end (UI / Razor components). |
| `BlazorAspireApp.ApiService` | The backend HTTP API. |
| `BlazorAspireApp.AppHost` | **Aspire orchestrator** — a code-first model that declares the resources (Web, ApiService, databases, caches…) and their relationships, and runs the whole graph with one command. |
| `BlazorAspireApp.ServiceDefaults` | Shared library applied by each service: **OpenTelemetry** (logs/metrics/traces), **health checks**, **HTTP resilience**, and **service discovery** defaults. |

**Classic — solution `02.02 AspnetBlazor`:**

| Project | Role |
|---|---|
| `B02_01_BlazorWebassemblyApp` | Standalone Blazor WebAssembly client (static, CDN-friendly). |
| `B02_02_BlazorWebassemblyApi` | Independent ASP.NET Core Web API. |
| `B02_02_BlazorWebassemblyModel` | Shared DTO/model library referenced by both. |

## Additional considerations

- Aspire is **not** a new Blazor hosting model or render mode, **not** an application framework, and **not** a cloud/production runtime. As of 2026 it is a **code-first, multi-language orchestration and observability layer** for distributed apps (it now supports C# *and* TypeScript AppHosts and orchestrates C#/Node/Python/Go/Java/… workloads).
- The classic solution wires everything **by hand**: start each project, hard-code endpoint URLs / connection strings, manage startup order, and bolt on telemetry per project.
- The Aspire solution adds the **AppHost** (the single source of truth for the topology) and **ServiceDefaults** (uniform cross-cutting concerns). `aspire run` starts the whole graph; the **Aspire Dashboard** shows unified logs/traces/metrics; **service discovery** replaces hard-coded endpoints so the same code works locally and when deployed.

## Deductions

- The **Blazor UI and the client↔server REST boundary are essentially unchanged** between the two samples. The `Web` + `ApiService` split mirrors the classic `client` + `Web API` split.
- The two *extra* projects (`AppHost`, `ServiceDefaults`) are **additive plumbing**, not a different application architecture. Remove them and you are back to "a Blazor app + an API."
- Therefore **"Blazor + Aspire" = "classic client + API" *plus* an orchestration + observability envelope.** The delta is **dev-time composition and operations**, not Blazor mechanics.
- The classic sample's separate `Model` project is an orthogonal code-sharing choice; Aspire neither requires nor forbids it.

## Conclusions

- **How it works:** AppHost declares and launches the resource graph; ServiceDefaults standardizes telemetry/health/resilience/discovery; the Dashboard and service discovery unify run + observe. The Blazor front end and the API are ordinary projects underneath.
- **Difference:** composition and operations, not architecture or Blazor internals.
- **Pros / cons:**

  | | Classic (WASM client + Web API) | Blazor + Aspire |
  |---|---|---|
  | Setup complexity | Lower (2–3 projects) | Higher (+AppHost, +ServiceDefaults) |
  | Run experience | Start each service; wire URLs by hand | `aspire run` starts the whole graph |
  | Config / endpoints | Hard-coded per environment | Service discovery, same code local↔prod |
  | Observability | Add per project | Uniform telemetry + one Dashboard |
  | Extra dependencies (DB, cache, queue) | Install & wire manually | `builder.AddPostgres(...)` etc., containerized |
  | Best fit | Single client + single API, minimal moving parts | Multiple services/dependencies, team dev, cloud target |

- **Modern & recommended:** For a **multi-service / multi-dependency** solution — or any team/cloud scenario where you want one-command run, service discovery, and built-in observability — **Aspire is the modern, recommended envelope**, and it composes *around* the recommended Blazor Web App or standalone-WASM+API shapes. For a **single client + single API** with minimal moving parts, the classic split is perfectly fine; Aspire is optional overhead there. Aspire is **orthogonal** to the Blazor app-shape decision, not a replacement for it.

## Appendix A — Evidence

- [What is Aspire?](https://aspire.dev/get-started/what-is-aspire/) 📘 [Official] — Aspire as a code-first, multi-language orchestration + observability layer; "is/isn't" list; AppHost as single source of truth; service discovery; Dashboard; `aspire run`; deploy same model.
- [Tooling for ASP.NET Core Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/tooling?view=aspnetcore-10.0) 📘 [Official] — `blazor-wasm-servicedefaults` (OpenTelemetry, service discovery, HTTP resilience) for wiring WASM clients into the Aspire stack.
- Local: the two sample screenshots in this issue (`images/001.00-*`, `images/001.01-*`); sibling `20260702.04` Blazor research + the existing `03.00-tech/04.05-web-development/01.00-blazor/` articles.

## Appendix B — Validation

- Confidence: **high**. The orchestration-vs-hosting-model framing is now grounded in the current official Aspire overview **and** confirmed against the actual project layout in the two screenshots (AppHost + ServiceDefaults + Web + ApiService), resolving the sibling issue's open "screenshots not yet inspected" item.
- Residual assumption: exact ServiceDefaults contents follow the standard Aspire template; sample-specific customizations were not inspected at source-code level.
