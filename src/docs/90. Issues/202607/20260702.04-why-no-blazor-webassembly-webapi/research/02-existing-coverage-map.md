# Existing-LearnHub coverage map

Internal grounding for the Blazor observation: what LearnHub already covers, mapped to the documentation taxonomy, before locking investigation priorities.

**📖 Taxonomy:** `06.00-idea/learning-hub/02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md`

## Coverage by candidate area

| Candidate area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| What Blazor is / why it exists | `absent` | none found (only a one-line mention in `index.qmd`) | Overview |
| Hosting models vs render modes (mental model) | `absent` | none found | Concepts |
| Template inventory (legacy vs current) | `partial` | this issue's `overview.md` | Reference |
| Architecture decision (Web App vs WASM+API vs Hybrid) | `partial` | this issue's `overview.md` | Analysis |
| Migration from hosted WASM | `absent` | none found | How-to |
| Blazor + Aspire orchestration | `absent` | sibling issue `20260705.01-aspire-overview-how-it-works` (open, unanswered) | Concepts |
| Curated Blazor samples / links | `partial` | references in this issue's `overview.md` | Resources |

## Repository scan basis

- `grep_search` for `Blazor|WebAssembly|Razor component|ASP.NET Core` across the repo.
- Matches outside this issue: `index.qmd` (one-line topic blurb) and `03.00-tech/20.01-markdown/01-quarto/01.01-introduction-to-quarto.md` (incidental nav example "BRK122: ASP.NET Core & Blazor").
- No `03.00-tech/` Blazor subject folder exists.

## Grounding conclusion

Blazor is effectively an **uncovered subject**: all substantive content lives in reactive issue docs under `90. Issues/`, none in the developed `03.00-tech/` corpus. The largest gaps are **Concepts** (render-model mental model) and **How-to** (migration), plus the open **Aspire** thread. This justifies prioritizing deep tracks on the concept model and architecture decision, and promoting the result into a first-class subject folder.
