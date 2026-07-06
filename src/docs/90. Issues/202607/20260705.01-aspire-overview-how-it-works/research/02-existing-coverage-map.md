# Existing-LearnHub coverage map

Internal grounding for the Aspire observation, mapped to the documentation taxonomy, before locking the integration target.

**📖 Taxonomy:** `06.00-idea/learning-hub/02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md`

## Coverage by candidate area

| Candidate area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| Blazor (what it is, hosting/render models, app shapes) | `present` | `03.00-tech/04.05-web-development/01.00-blazor/` (6 articles) | Overview / Concepts / Analysis / How-to / Reference / Resources |
| Blazor + Aspire orchestration | `absent` | prior analysis stub only: sibling `20260702.04/research/05-analysis/aspire-vs-classic-wasm-api.md` (medium confidence, screenshots un-inspected) | Concepts |
| Aspire in general (AppHost, ServiceDefaults, dashboard, service discovery) | `absent` | none found in `03.00-tech/` | Concepts |
| Aspire vs classic composition — decision guidance | `partial` | `01.00-blazor/04-analysis-architecture-decision.md` covers Web App vs WASM+API but **not** the orchestration envelope | Analysis |

## Repository scan basis

- `grep_search` for `Aspire|Blazor|orchestrat` across `src/docs/**` and `Aspire|AppHost|ServiceDefaults|service discovery` across `03.00-tech/**`.
- The only Aspire mentions live in the sibling issue's research folder. `03.00-tech/` has **zero** Aspire coverage.

## Grounding conclusion

Blazor itself is now well covered by a first-class subject folder. The **Aspire orchestration layer is entirely absent** from the developed corpus. The right move is a single new **Concepts** article inside the existing Blazor folder that explains the Aspire sample and contrasts it with the classic shape — reusing (not duplicating) the render-mode and architecture-decision articles already present. This also closes the open backlog item recorded in the sibling issue's `08-approval-and-integration-proposal.md`.
