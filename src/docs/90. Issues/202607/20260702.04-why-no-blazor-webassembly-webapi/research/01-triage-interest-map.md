# Triage interest map

## Observation snapshot

The user asks why Visual Studio no longer offers a direct Blazor WebAssembly + Web API hosted option and signals frustration with perceived complexity of current Blazor server-side patterns.

## Context harvest

Signals gathered from the surrounding context (not the question alone):

- **Active file / attachments:** the issue `overview.md` and three Blazor template screenshots.
- **Sibling issues:** `20260705.01-aspire-overview-how-it-works` asks how a Blazor + Aspire sample differs from a classic WASM client + API — a direct continuation of this thread.
- **Repo scan:** no `03.00-tech/` Blazor subject exists; only incidental mentions in `index.qmd` and a Quarto nav example. (Full mapping in `02-existing-coverage-map.md`.)

## Specific question vs broader interest

- Specific question: Why the hosted template option is missing in current .NET/Visual Studio flows.
- Broader interest: How to choose modern Blazor architecture shapes and migration paths with confidence.

## Inferred interest areas

| Area | Confidence | Why it likely matters |
|---|---|---|
| Template and tooling evolution (.NET 7 -> .NET 8+) | High | Directly tied to the explicit question |
| Architecture decision guide (Blazor Web App vs standalone WASM + API) | High | Needed to move from tooling confusion to design clarity |
| Migration patterns from hosted WASM legacy solutions | High | Practical next step for existing codebases |
| Performance/auth/deployment trade-offs | Medium | Implicit in "more complex and cumbersome" concern |
| Troubleshooting template confusion in VS and CLI | Medium | Repeated confusion likely in future observations |

## Evidence status

- Local evidence: Current issue overview and related LearnHub event coverage.
- External evidence: Official Blazor tooling and project structure docs support the template direction shift.

## Open questions to validate with user

1. Which area should be investigated first for immediate value?
2. Is current focus mostly architecture decision, migration, or tooling troubleshooting?
3. Is the desired output a quick decision memo, or a deeper reusable LearnHub guide?
