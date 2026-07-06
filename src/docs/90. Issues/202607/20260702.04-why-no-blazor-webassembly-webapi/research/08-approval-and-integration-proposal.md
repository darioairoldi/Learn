# Approval and integration proposal

## Approval state

`approved` — the proposed answer was accepted and already integrated into this issue's `overview.md`.

## Integration performed

`overview.md` was rewritten into a full analysis blending three taxonomy categories: technology **Overview**, the render-mode **Concepts** model, an **Analysis** decision section (two architectures with diagrams), and a **Reference** template-inventory table.

## Taxonomy mapping (approved conclusions → targets)

| Conclusion | Taxonomy category | Target |
|---|---|---|
| What Blazor is / hosting models | Overview + Concepts | `overview.md` (done); future `03.00-tech/<blazor>/01-overview.md`, `02-concepts-…` |
| Render modes & `.Client` project | Concepts | future `03.00-tech/<blazor>/02-concepts-hosting-and-render-modes.md` |
| Template inventory (legacy vs current) | Reference | `overview.md` table (done); future `…/06-reference-templates.md` |
| Web App vs WASM+API decision | Analysis | `overview.md` section (done); future `…/03-analysis-architecture-decision.md` |
| Migration from hosted WASM | How-to | future `…/04-howto-migrate-hosted-wasm.md` |
| Blazor + Aspire | Concepts | answer sibling issue `20260705.01`; future `…/05-concepts-blazor-with-aspire.md` |

## Deferred follow-ups (backlog)

- [x] **Done (2026-07-06):** Promoted into the first-class subject folder `03.00-tech/04.05-web-development/01.00-blazor/` following the taxonomy — `00-overview.md`, `02-concepts-hosting-models-and-render-modes.md`, `03-howto-migrate-hosted-wasm-to-blazor-web-app.md`, `04-analysis-architecture-decision.md`, `05-reference-templates.md`, `06-resources.md`.
- [x] **Done (2026-07-06):** Added the migration How-to (`03-howto-…`), grounded in the official .NET 7→8 conversion guide.
- [ ] Add `01-getting-started.md` (quickstart for `dotnet new blazor` / `blazorwasm`) — slot left in the subject folder.
- [x] **Done (2026-07-06):** Answered the Aspire sibling issue (`20260705.01-aspire-overview-how-it-works`) after inspecting its sample screenshots; added `03.00-tech/04.05-web-development/01.00-blazor/02.01-concepts-blazor-with-aspire.md` and confirmed the orchestration-vs-hosting-model framing (confidence upgraded medium → high).
