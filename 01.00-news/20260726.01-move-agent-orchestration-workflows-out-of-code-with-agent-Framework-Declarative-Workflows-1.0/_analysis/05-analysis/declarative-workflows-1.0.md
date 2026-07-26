---
title: "Analysis — Agent Framework Declarative Workflows 1.0"
publish: false
---

# Analysis: Agent Framework Declarative Workflows 1.0

## 1. Problem statement (investigation framing)

Understand what Microsoft Agent Framework **Declarative Workflows 1.0** delivers, why it matters for multi-agent apps, and how it relates to orchestration content the Learning Hub already has.

## 2. Additional considerations

- The Hub already documents orchestration, but at the **GitHub Copilot customization** layer (orchestrator prompts, subagents). The article must avoid conflating that with the **Agent Framework SDK** application layer.
- The source is a product announcement; the article should stay explanatory (what/why/how) and cite the official docs and runnable samples, not editorialize.

## 3. Source-soundness gate

| Dimension | Verdict |
|---|---|
| Clarity | Pass — the central claim (orchestration as a YAML document, loaded into the same `Workflow` type) is unambiguous |
| Internal consistency | Pass — no self-contradiction |
| Sufficiency | Pass — concrete API surface, YAML example, both SDK loaders, enumerated building blocks, links to samples/docs |
| Novelty & value | Pass — a 1.0 milestone; absent from the Hub |
| Verifiability | Pass — corroborated by Microsoft Learn docs and the public `microsoft/agent-framework` repo |
| Corroboration | Pass — official docs + GitHub samples are independent confirmations |

`source_verdict`: **sound** (Microsoft DevBlogs, authored by a Principal Engineer on the Agent Framework team, corroborated by Learn docs + repo). 📘 Official.

## 4. Deductions (load-bearing)

1. **Declarative = orchestration as data.** The sequence, branching, and handoffs move from application control flow into a YAML document you can diff, review, and ship independently. *(Evidence: source "Why teams choose…" + "Author in YAML…".)*
2. **No runtime tradeoff.** A declarative workflow loads into the **same `Workflow` type** as a code-first one — it runs, streams, and composes identically. *(Evidence: source.)*
3. **Symmetric across SDKs.** 1.0 covers both Python (`agent-framework-declarative` → 1.0.0) and .NET (`Microsoft.Agents.AI.Workflows.Declarative`, already stable). *(Evidence: source.)*
4. **Distinct layer from Copilot prompt-file orchestration.** The Hub's existing how-tos orchestrate Copilot customization files; this feature orchestrates **agents inside a running .NET/Python application**. Adjacent, not duplicate. *(Evidence: coverage map.)*

## 5. Conclusions

- Clear, additive tech gap → integrate as a reader-facing article in the news folder (matching the local `overview.md`-as-article convention used by reverse-paradox and loop-engineering).
- Include: the concept, the "why", the YAML support-router example, both SDK loaders, the building-blocks catalog, a disambiguation/cross-link paragraph to the Hub's Copilot orchestration how-tos, and a getting-started + references block.
- No meta/architecture amendment; no vision or PE-artifact edits.

## Appendix A — Evidence (classified)

- [Move Agent Orchestration/Workflows out of Code with Agent Framework Declarative Workflows 1.0](https://devblogs.microsoft.com/agent-framework/move-agent-orchestration-workflows-out-of-code-with-agent-framework-declarative-workflows-1-0/) — Peter Ibekwe, Microsoft DevBlogs, 2026-07-23 📘 [Official]
- [Declarative workflows overview](https://learn.microsoft.com/en-us/agent-framework/workflows/declarative) — Microsoft Learn 📘 [Official]
- [microsoft/agent-framework — Python declarative samples](https://github.com/microsoft/agent-framework/tree/main/python/samples/03-workflows/declarative) 📘 [Official]
- [microsoft/agent-framework — .NET declarative samples](https://github.com/microsoft/agent-framework/tree/main/dotnet/samples/03-workflows/Declarative) 📘 [Official]

## Appendix B — Validation

- API names and package identifiers cross-checked against the source snippets and Microsoft Learn docs path.
- Layer distinction validated against `03.00-tech/05.02-prompt-engineering/04-howto/10.00…`/`11.00…` (those orchestrate Copilot files, not SDK agents).
