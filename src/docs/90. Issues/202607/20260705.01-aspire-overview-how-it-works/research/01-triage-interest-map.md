# Triage + interest map

## Explicit question

How does the new **Blazor + Aspire** sample work, and how is it different from a **classic** sample made of a Blazor WebAssembly client plus an ASP.NET Core Web API?

## Signals

- `explicit_question`: understand the Aspire sample's structure and contrast it with the classic WASM-client + Web-API shape.
- `pain_signal`: the Aspire solution shows *more* projects (AppHost, ServiceDefaults) than expected — "what are these extra projects and why?"
- `decision_pressure`: implicit — "is this the modern/recommended way, and should I adopt it?"
- `domain_scope`: .NET web development / Blazor / Aspire.

## Context harvest

- **Active file:** `overview.md` in this issue folder + two screenshots.
  - `001.01-blazor-sample-modern.png` → solution `01.02_BlazorSample` with projects: `BlazorAspireApp.ApiService`, `BlazorAspireApp.AppHost`, `BlazorAspireApp.ServiceDefaults`, `BlazorAspireApp.Web` (plus an unrelated `Json2Csv`).
  - `001.00-blazor-sample-classic.png` → solution `02.02 AspnetBlazor` with projects: `B02_01_BlazorWebassemblyApp`, `B02_02_BlazorWebassemblyApi`, `B02_02_BlazorWebassemblyModel`, `99. Other`.
- **Sibling issues** (`202607/`): `20260702.04-why-no-blazor-webassembly-webapi` is directly related — it already has a full `research/` folder, including `05-analysis/aspire-vs-classic-wasm-api.md` (opened this exact question but left the screenshots un-inspected) and a coverage map that flagged **"Blazor + Aspire orchestration" = absent** and linked forward to *this* issue.
- **Repo scan:** a first-class Blazor subject folder already exists at `03.00-tech/04.05-web-development/01.00-blazor/` (`00-overview`, `02-concepts-hosting-models-and-render-modes`, `03-howto-migrate-…`, `04-analysis-architecture-decision`, `05-reference-templates`, `06-resources`). **No Aspire article exists** in it. No other Aspire coverage anywhere in `03.00-tech/`.

## Candidate investigation areas

| # | Area | Relevance | Urgency | Learning impact | Confidence |
|---|---|---|---|---|---|
| 1 | Aspire orchestration model (AppHost + ServiceDefaults) vs manual wiring | 5 | 5 | 5 | high |
| 2 | What is unchanged (Blazor UI + client↔server REST boundary, render modes) | 5 | 4 | 4 | high |
| 3 | Pros/cons + "modern & recommended" verdict | 5 | 5 | 5 | high |
| 4 | Integration into the existing Blazor subject folder | 5 | 4 | 4 | high |

## Depth recommendation

- Area 1 + 2 + 3 → single **standard** analysis (`05-analysis/aspire-orchestration-model.md`), since the pieces are one coherent story and much groundwork exists in the sibling issue.
- Area 4 → integration proposal (Stage C, approval-gated).
