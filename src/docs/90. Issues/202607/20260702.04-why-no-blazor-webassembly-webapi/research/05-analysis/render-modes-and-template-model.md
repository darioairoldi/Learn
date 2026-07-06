# Area analysis — Render modes and the template model

Depth: **deep**. Taxonomy target: **Concepts** + **Reference**.

## Problem statement

Why is there no single Visual Studio / `dotnet new` template that produces "Blazor WebAssembly client + Web API" in one project, when that shape feels like the natural full-stack default?

## Additional considerations

- Before .NET 8, the hosting model was chosen **per app at creation**, which produced one template per shape (Blazor Server, standalone WASM, Hosted WASM = Client + Server + Shared).
- .NET 8 replaced that with the **Blazor Web App** (`blazor`), where rendering is a **per-component render mode**: Static SSR, Interactive Server, Interactive WebAssembly, Interactive Auto.
- A `.Client` project is added **on demand** only when a WebAssembly/Auto render mode is selected.
- The Hosted WebAssembly template (the old "WASM + API + Shared") was removed from the default experience; it is reachable only by targeting `net7.0` or earlier.

## Deductions

- Because the framework no longer fixes a hosting model per app, it cannot assume a fixed API boundary per app either.
- "UI rendering choice" and "backend boundary choice" became **independent decisions**; a bundled "WASM + API" template would re-couple them and silently pick an architecture.
- Therefore the missing template is intentional, not an oversight.

## Conclusions

- Current templates: `blazor` (Blazor Web App — recommended default) and `blazorwasm` (standalone WASM). Legacy: Hosted WASM, `blazorserver`/`-empty`, `blazorwasm-empty`.
- A REST API is now a **composition choice** you add (`webapi` project or endpoints), not a template default.
- The two correct modern shapes are: (A) Blazor Web App + APIs as needed; (B) standalone WASM + separate ASP.NET Core Web API.

## Appendix A — Evidence

- [Tooling for ASP.NET Core Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/tooling?view=aspnetcore-10.0) 📘 [Official] — template list; "Hosted … isn't available in .NET 8 or later"; `blazor-wasm-servicedefaults` (.NET 11).
- [ASP.NET Core Blazor project structure](https://learn.microsoft.com/en-us/aspnet/core/blazor/project-structure?view=aspnetcore-10.0) 📘 [Official] — `.Client` project behavior; hosted-solution structure.
- [ASP.NET Core Blazor hosting models](https://learn.microsoft.com/en-us/aspnet/core/blazor/hosting-models?view=aspnetcore-10.0) 📘 [Official] — Server/WASM/Hybrid trade-offs.
- Local: this issue's `overview.md`.

## Appendix B — Validation

- Cross-checked across three official pages (tooling, project-structure, hosting-models) under the `aspnetcore-10.0`/`aspnetcore-11.0` monikers; the template list and the "hosted removed in .NET 8" statement are consistent across all three.
- Confidence: **high** for template classification and render-mode model.
