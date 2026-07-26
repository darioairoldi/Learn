---
title: "Proposed result package — Declarative Workflows 1.0"
publish: false
---

# Proposed result package

- **Triage verdict**: single dominant tech area (Declarative Workflows 1.0) + a quick cross-linking concern; no meta/architecture impact.
- **Coverage map summary**: reader-facing coverage of Agent Framework declarative workflows is **absent**; adjacent Copilot prompt-file orchestration is **present** (different layer).
- **Source verdict**: **sound** (📘 Official Microsoft DevBlogs, corroborated by Learn docs + repo).
- **Prioritized tracks**: A (standard) — the feature; B (quick) — disambiguation cross-link.
- **selected_workflow_pattern**: not_applicable.

## Concise answer

Declarative Workflows 1.0 lets you define multi-agent orchestration — the sequence of steps, branching, state, and human handoffs — as a **YAML document** instead of application code. Agent Framework loads that document into the **same `Workflow` type** as a code-first workflow, so it runs, streams, and composes identically with no runtime tradeoff. 1.0 is available across **Python** (`agent-framework-declarative`) and **.NET** (`Microsoft.Agents.AI.Workflows.Declarative`). The value is reviewability and versioning: an approval step, a new handoff, or a branching change becomes a diffable YAML change rather than a code change. This is a different layer from the Hub's existing GitHub Copilot prompt-file orchestration how-tos — those coordinate *customization files*; declarative workflows coordinate *agents inside a running app*.

## Confidence & assumptions

- Confidence: high — facts drawn directly from the official announcement and corroborated.
- Assumption: the news-folder `overview.md`-as-article convention is the correct home (matches reverse-paradox / loop-engineering; no dedicated `03.00-tech` agent-framework subject folder exists yet, and creating one for a single announcement would be premature).

## Open decisions for user

None blocking. Watch-items (future how-to on Power Fx expressions; a Foundry agents subject folder) recorded in the backlog.
