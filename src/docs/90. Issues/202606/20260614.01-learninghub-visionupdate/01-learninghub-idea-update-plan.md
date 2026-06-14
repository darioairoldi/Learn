---
title: "Learning Hub idea update plan"
author: "Dario Airoldi"
date: "2026-06-14"
status: done
domain: "learning-hub"
goal: "Update the three Learning Hub idea documents (overview, taxonomy, automated-content-lifecycle) so they reflect capabilities now implemented in the repository and incorporate the owner's refinements on visibility, ingestion, architecture layering, publishing, and metadata discipline"
motivation: "The idea documents describe an aspirational system that the actual implementation has partly overtaken. Several shipped capabilities (external-repository configuration, public/private content separation, conference ingestion, the full automation-layer stack) are undocumented, and the metadata + publishing models in the docs no longer match the intended direction."
rationales:
  - "Idea docs that lag the implementation mislead future contributors and the AI about what already exists"
  - "Owner refinements change the intended vision (incremental publishing, richer stable-metadata model) and must be captured before the docs drift further"
  - "Per-item scope tagging keeps this update from silently expanding beyond the agreed seven points"
---

# Learning Hub idea update plan

> Status: **done** — all workstreams executed; see suffixes below.

## Goal

**Verbatim trigger (owner request):** "create a plan to update learning hub idea according to your analysis" with seven specific considerations on repository configuration, public/private content separation, conference/event ingestion, the missing automation layers, the PE meta-system, Quarto publishing, and dual metadata.

The table below lists every in-scope work item. Scope tags follow the project convention; `landing` names the target document each item lands in.

| # | Item | Scope tag | Preserves / touches | Landing |
|---|------|-----------|---------------------|---------|
| 1 | Add **repository configuration** as a Learning Hub infrastructure concept (layered `appsettings.json`, `Repository:ExternalRepositories`, user override) and note it as a growing foundation | `[in-scope: original]` | preserves: information-centric, collaborative-learning | [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) + [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |
| 2 | Add **public/private content separation** as a source/governance principle: every piece of information carries an exposure criterion, satisfied by routing non-shareable material to an external mirror | `[in-scope: original]` | preserves: information-centric; touches: knowledge-information-sources (additive) | [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) |
| 3 | Add **conference/event ingestion** as a flagship content channel + workflow, framed under "Learning Hub specializes in analysis and elaboration of many content types; conference events are high-quality sources" | `[in-scope: original]` | preserves: intelligent-gathering | [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) + [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |
| 4 | Expand the automation architecture from **4 layers to the real stack** by integrating instruction files, context files, skills, hooks, and scripts | `[in-scope: original]` | preserves: layered-automation; touches: architecture model (additive — no layer removed) | [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |
| 5 | Clarify that the **PE meta-system is NOT a Learning Hub capability** — it is generic tooling for obtaining suitable AI logic; add a one-line scoping note so it is not mistaken for a Hub feature | `[in-scope: original]` | preserves: all | [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |
| 6 | Reframe **publishing** as a publish-agnostic final lifecycle stage and **mandate an incremental build strategy** (only new/changed content is built for integration; full rebuild is an anti-requirement) | `[in-scope: original]` | touches: publishing model (NEW principle — incremental integration) | [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) + [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |
| 7 | Revise the **dual-metadata model**: top metadata holds all stable/identity fields (`title, author, description, categories, domain, goal, scope, boundaries, rationales`); changes to top metadata are discouraged and normally require explicit user request; autonomous edits only when provably additive and non-breaking | `[in-scope: original]` | touches: metadata model (refinement of existing dual-YAML system) | [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) + [02-dual-yaml-metadata.md](../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md) |
| 8 | Reconcile **IQPilot vs MetadataWatcher** naming: present IQPilot as the evolution of MetadataWatcher (deterministic engine), not two separate things | `[in-scope: original]` | preserves: deterministic-infrastructure | [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) |

No `[scope-expansion]` items are in the active list. Surfaced edge cases live in § Park lot.

## Owner decisions captured (analysis)

These are the resolved interpretations of the owner's feedback; the workstreams below implement them.

1. **Repository configuration** — Treat as a first-class, growing infrastructure foundation, not a one-off. The vision should state that the Hub is configuration-driven and that repository configuration will carry increasing responsibility over time. Anchor: [00-repository-configuration.md](../../../../../.copilot/context/90.00-learning-hub/00-repository-configuration.md).

2. **Public/private separation** — Frame as an *exposure-criteria* model: information learned by the Hub is subject to different visibility requirements; external-repository configuration is the mechanism that lets each piece be handled at its suitable visibility (public repo vs. internal mirror). Material is resolved and read in place — never copied into the public repo.

3. **Conference/event ingestion** — Position the Hub as a generalized *analysis-and-elaboration engine over many content types*, and call out conference/event proceedings as a premier high-quality channel with a dedicated ingestion pipeline (catalog → manifest → posters → transcripts → summaries → menu).

4. **Automation layers** — Keep the existing four (prompts, agents, subagents, MCP) and **add** instruction files, context files, skills, hooks, and scripts as peer mechanisms in the customization stack. Additive only; no existing layer is removed.

5. **PE meta-system** — Explicitly **out of scope** as a Hub capability. It is generic prompt-engineering tooling used to *produce* good AI logic; add a single clarifying note so readers do not mistake it for a Learning Hub feature. (No new section, no promotion.)

6. **Publishing** — Publishing is the terminal lifecycle stage and must be **publish-tool-agnostic** (Quarto is the current implementation, not a requirement). New vision principle: **incremental integration** — only new or changed content is built when integrating; a mandatory full rebuild (Quarto's current behavior) is explicitly named as a limitation the vision wants to move past.

7. **Dual metadata** — **Yes, the vision needs to change.** Reframe the two blocks as:
   - **Top = stable / identity metadata** — the fields that define what the article *is* and *why*: `title, author, description, categories, domain, goal, scope, boundaries, rationales`. These are change-averse: edits are discouraged and normally require explicit user request. Autonomous edits are permitted *only* when provably additive and non-breaking (e.g., extending `goal`, `scope`, or `rationales` without invalidating prior scenarios).
   - **Bottom = volatile / validation metadata** — generated and refreshed by the deterministic engine (validation status, scores, timestamps).
   This supersedes the doc's current framing of a "new" bottom `article_metadata` block and reconciles with the implemented dual-YAML system.

8. **IQPilot vs MetadataWatcher** — Document IQPilot as the **evolution** of MetadataWatcher: same deterministic role (metadata sync, validation caching, file operations), MCP-exposed. Avoid implying two competing tools.

## Workstreams

### A. `01-learning-hub-introduction.md` (overview / vision)
1. Add a **"Configuration-driven foundation"** subsection under Core Transformation Principles (item 1). (✅ done)
2. Add an **"Exposure criteria & public/private sources"** subsection to Knowledge Information Sources (item 2). (✅ done)
3. Expand the conference/event source bullet into a **"Content-type specialization"** note naming conference ingestion as a flagship channel (item 3). (✅ done)
4. Add a **"Publishing & incremental integration"** principle to the lifecycle/implementation section (item 6). (✅ done)
5. Bump doc `version` and append a "Most recent changes" note. (✅ done)

### B. `01-automated-content-lifecycle-with-prompts-agents-and-mcp.md` (automation)
1. Replace the **four-layer** architecture table/section with the **full customization stack** (prompts, agents, subagents, MCP, instruction files, context files, skills, hooks, scripts) (item 4). (✅ done)
2. Add a **repository-configuration / external-material-resolution** stage to the lifecycle (items 1–2). (✅ done)
3. Add a **conference/event ingestion workflow** subsection linking the implemented prompt (item 3). (✅ done)
4. Add a one-line **PE-meta scoping note** (item 5). (✅ done)
5. Rewrite the **dual-metadata** subsection per Owner decision 7; reconcile against the implemented system (item 7). (✅ done)
6. Rename/reframe **Layer 4** to present IQPilot as the evolution of MetadataWatcher (item 8). (✅ done)
7. Add the **incremental-build / publish-agnostic** stage to the lifecycle workflows (item 6). (✅ done)

### C. `01-learning-hub-documentation-taxonomy.md` (taxonomy)
1. Light touch only — add an `exposure`/visibility note to the subject-folder template and metadata guidance so taxonomy aligns with public/private separation (items 2, 7). (✅ done)

### D. Supporting context reconciliation
1. Cross-link [00-repository-configuration.md](../../../../../.copilot/context/90.00-learning-hub/00-repository-configuration.md) from the idea docs. (✅ done)
2. Update [02-dual-yaml-metadata.md](../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md) to define the stable-vs-volatile split and change-discipline rules (item 7). (✅ done)

## Park lot

- **Promote the PE meta-system to its own doc** → closed: owner ruled it out of Learning Hub scope; keep as generic tooling only.
- **Implement `_subject.yml` manifest** → defer: proposed in the lifecycle doc but not yet built; mark as *planned* in the doc rather than implement here.
- **Replace Quarto with an incremental publisher** → defer: vision-level mandate is in scope (item 6); the actual tool replacement is a separate engineering effort.
- **Add `$schema` / formal validation to `appsettings.json`** → → defer.
- **Delete temp transcript-move script/log under `99.00-temp/`** → defer: housekeeping, unrelated to this vision update.

## Actionability Gate (run before promoting to `actionable`)

- [ ] Clarity — every workstream step names a concrete edit to a concrete file
- [ ] Non-ambiguity — each item has one reasonable interpretation
- [ ] Scope discipline — no item exceeds the seven-point trigger; expansions are parked
- [ ] Coverage promise — every goal row names a resolving landing document
- [ ] Owner sign-off on the dual-metadata reframing (item 7) and incremental-publishing principle (item 6), which are the only genuinely *new* vision elements

## Exit criteria

- All three idea docs updated per workstreams A–C with version bumps and change notes
- Supporting context files (D) reconciled and cross-linked
- No undocumented shipped capability among the seven points remains
- PE meta-system explicitly scoped out; IQPilot/MetadataWatcher relationship stated once, consistently
