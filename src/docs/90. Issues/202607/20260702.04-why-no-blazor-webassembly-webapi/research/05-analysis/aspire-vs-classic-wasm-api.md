# Area analysis — Blazor + Aspire vs classic WASM client + Web API

Depth: **standard**. Taxonomy target: **Concepts**. Linked to sibling issue `20260705.01-aspire-overview-how-it-works` (open).

## Problem statement

How does a "Blazor + .NET Aspire" sample work, and how is it different from a classic sample with a Blazor WebAssembly client plus an ASP.NET Core Web API?

## Additional considerations

- .NET Aspire is an **orchestration/composition layer**, not a new Blazor hosting model or render mode.
- A classic solution wires the pieces manually: a `blazorwasm` client, a `webapi` backend, and any dependencies (databases, caches), each configured by hand for URLs, config, and startup order.
- An Aspire solution adds an **AppHost** project that declares and orchestrates those resources, plus a **ServiceDefaults** library that standardizes cross-cutting concerns (telemetry/OpenTelemetry, health checks, HTTP resilience, service discovery). .NET 11 ships `blazor-wasm-servicedefaults` specifically for wiring WASM clients into that stack.

## Deductions

- The **UI code and the client↔server REST boundary are unchanged** between the two samples — the render-mode/template model still applies underneath.
- What Aspire changes is **dev-time orchestration and ops wiring**: one run launches the whole graph, service discovery replaces hard-coded endpoints, and telemetry is consistent across projects.
- So "Blazor + Aspire" is best framed as "classic WASM + API **plus** an orchestration/observability envelope," not a different application architecture.

## Conclusions (provisional)

- Difference is **composition and operations**, not Blazor mechanics.
- Choose Aspire when the solution has multiple services/dependencies and you want unified local orchestration, service discovery, and telemetry; a classic two-project split is fine for a single client + single API.

## Appendix A — Evidence

- [Tooling for ASP.NET Core Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/tooling?view=aspnetcore-10.0) 📘 [Official] — `blazor-wasm-servicedefaults` features: OpenTelemetry, service discovery, HTTP resilience.
- Local: sibling issue `../../20260705.01-aspire-overview-how-it-works/overview.md` (contains the two sample screenshots to be inspected).

## Appendix B — Validation

- Confidence: **medium**. The orchestration-vs-hosting-model framing is grounded in official tooling docs, but the specific sample in the sibling issue (`image.png`, `image-1.png`) has **not yet been inspected**.
- Open item: inspect the two screenshots and confirm whether the sample uses a Blazor Web App or a standalone `blazorwasm` client before finalizing the sibling-issue answer.
