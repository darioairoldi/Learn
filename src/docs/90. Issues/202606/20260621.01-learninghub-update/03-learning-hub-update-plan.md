---
title: "Learning Hub — vision/strategy update plan"
author: "Dario Airoldi"
date: "2026-06-21"
status: draft
domain: "learning-hub"
goal: "Amend the Learning Hub idea/vision and automated-content-lifecycle docs so the project meets its OWN goal — a personal, generalized analysis-and-elaboration engine over many content types that publishes incrementally — by closing the gaps that keep its automation aspirational: the unimplemented conference/event ingestion pipeline, the un-realized incremental build, the unbuilt subject-config sections of `_metadata.yml` (formerly the `_subject.yml` manifest), the undeployed content-freshness machinery, the missing knowledge graph, and the implicit (undeclared) building-block dependencies on the article-writing and PE projects."
motivation: "The Learning Hub is a personal learning system whose scope (analysis and elaboration over feeds, papers, transcripts, recordings, events) is broader than the documentation the other two projects maintain. Its vision is well-designed but much of the automation is designed-not-built, and its dependencies on the article-writing engine (for content maintenance) and the PE engine (for automation) are real but never declared as versioned building-block contracts. Making those explicit, and naming the unbuilt pieces, lets the Hub progress without re-deriving the architecture each cycle."
rationales:
  - "The Hub's own goal (knowledge development over many content types) exceeds its role as a publishing target for the other two projects"
  - "Building-block dependencies on article-writing and PE must be declared, not assumed"
  - "Vision changes are human-only; this plan is a draft proposal for owner approval"
---

# Learning Hub — vision/strategy update plan

> Status: **draft** — proposal for owner review. Structural Actionability-Gate checks pass (2026-06-22); **two items remain**: the idea-doc-vs-formal-vision decision (gate check 5) and owner sign-off (H8/H2). No vision/idea-doc edits are executed until those resolve and the owner approves.

## 🎯 Goal

Close the gaps that keep the Learning Hub's automation aspirational, so it meets its **own** goal — an information-centric, generalized analysis-and-elaboration engine that publishes incrementally — and, secondarily, consumes the article-writing and PE projects cleanly as declared building blocks.

## 🧭 Standalone scope vs. integrated role

- **Own goal (primary):** transform passive consumption into active knowledge development across many content types (feeds, papers, transcripts, recordings, conference proceedings), with publish-agnostic, incremental integration.
- **Building-block consumption:** the Hub *consumes* the article-writing project to keep its published articles current, and the PE project to automate its lifecycle. These are dependencies the Hub uses, not capabilities it owns.
- **Integrated role (secondary):** it is the most demanding *consumer* of the other two projects — a proving ground, not their purpose.

## 🔎 Gap analysis (vs. own goal, with integrated lens) (✅ done)

| # | Gap | Why it matters to the OWN goal | Building-block lens |
|---|------|-------------------------------|---------------------|
| H1 | **Conference/event ingestion pipeline unimplemented.** Named as a flagship channel but has no concrete agent spec (catalog → manifest → posters → transcripts → summaries → menu). | The Hub's premier high-quality content channel is aspirational. | Consumes PE authoring tiers to build the pipeline. |
| H2 | **Incremental build mandated but not realized.** Quarto does a full rebuild; the vision names this as a limitation to move past. | "Integration cost scales with change size" is a core promise that is currently false. | — |
| H3 | **Subject-level config not built** — the proposed `_subject.yml` is now the `identity:` + `monitoring:` sections of `_metadata.yml`, still unrealized. Subject scope/coverage/monitoring config is proposed only. | Subject-level coverage and freshness monitoring depend on it. | — |
| H4 | **Content-freshness machinery designed, not deployed.** `product_dependencies`, `key_claims`, revalidation cadence are defined but no monitor/triage runs. | The Hub's "keep knowledge current" promise is inert at scale. | Depends on the article-writing orchestrator (plan 02 **B1**, currently deferred); the Hub specifies the wiring *contract* against that interface (D1). |
| H5 | **No knowledge graph / semantic cross-linking.** xref validation checks reference integrity only; there is no semantic map for completeness/gap detection. | "Knowledge development" and gap analysis are shallow without relationship modeling. | — |
| H6 | **Two self-update timescales unreconciled.** PE-artifact self-update vs. content revalidation run on different cadences with no defined relationship. | Operators cannot reason about when content vs. tooling refreshes. | Needs both building blocks' contracts to reconcile. |
| H7 | **IQPilot MCP extensions designed, not built** (navigation check, xref validate). | Deterministic infrastructure the lifecycle relies on is missing. | — |
| H8 | **Building-block dependencies undeclared.** The Hub's reliance on article-writing and PE is real but not declared as versioned contracts. | Architecture is re-derived each cycle; no stable spine. | This is the explicit reference the owner wants. |
| H9 | **No publish promotion-gate policy.** No defined draft→in-review→published flow or write-permission split between content and validation metadata. | Content governance is implicit. | — |

## ⚙️ Workstreams

### A. Vision amendments — `01-learning-hub-introduction.md` + `01-automated-content-lifecycle-…md` (🟡 todo)

1. Add a **building-block dependency declaration**: name article-writing (content maintenance) and PE (automation) as versioned building blocks the Hub consumes, with the contract each provides (resolves H8). Landing: [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md). (🟡 todo)
2. Reconcile the **two self-update timescales** (tooling vs. content) into one stated model (resolves H6). Landing: [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md). (🟡 todo)
3. Add a **publish promotion-gate** policy (draft→in-review→published; content vs. metadata write-permission split) (resolves H9). Landing: lifecycle doc. (🟡 todo)
4. Add a **knowledge-graph / semantic cross-linking** concept for completeness and gap detection (resolves H5). Landing: lifecycle doc. (🟡 todo)

### B. Subject config + ingestion pipeline (🟡 todo)

1. Specify the **subject config** — the `identity:` + `monitoring:` sections of a subject folder's `_metadata.yml` (formerly proposed as a standalone `_subject.yml`): scope, goal, coverage matrix, product dependencies, monitoring cadence — and mark it *planned* in the lifecycle doc, reconciled into the shared `_metadata.yml` mechanism per [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md) (subject identity → `identity:` section, monitoring → `monitoring:` section) (resolves H3). Landing: lifecycle doc + schema sketch. (🟡 todo)
2. Specify the **conference/event ingestion** workflow as a concrete subagent orchestration (resolves H1). Landing: lifecycle doc; references the existing ingestion prompt. (🟡 todo)

### C. Deterministic infrastructure (🟡 todo)

1. Define the **incremental-build** target (publish-agnostic; integration cost ∝ change size) as a vision requirement with a candidate approach (resolves H2). Landing: introduction + lifecycle doc; tool replacement parked. (🟡 todo)
2. Specify the **IQPilot MCP extensions** (navigation check, xref validate) as deterministic tools (resolves H7). Landing: lifecycle doc (new "IQPilot extensions" section; promoted to a separate spec file only if it outgrows the doc). (🟡 todo)

### D. Content-freshness wiring (🟡 todo)

1. Specify the **content-freshness wiring contract** — the interface by which the Hub's freshness machinery consumes the article-writing orchestrator + per-dimension skills (resolves H4). The orchestrator/skills are **deferred in plan 02** (its B/C/D), so this is an *interface spec*, not live wiring, and is therefore **not blocked** on that build. Landing: lifecycle doc. (🟡 todo)
2. **Endorse inherited identity in the freshness lifecycle.** An ancestor `_metadata.yml` change is a staleness signal that invalidates descendant articles' effective metadata; revalidation triage MUST reverify the `effective:` block (`inputs_hash`) and recompute before assessing (consumes [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md)). Landing: lifecycle doc. (🟡 todo)

## 🧪 Actionability Gate (run before promoting to `actionable`)

- Clarity — every step names a concrete edit to a concrete file. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation (D1 = interface spec, not live wiring; C2 lands in the lifecycle doc). (✅ done)
- Scope discipline — items stay within the Hub's own goal; capabilities owned by article-writing/PE are referenced, not duplicated; no `[scope-expansion]` in the active list. (✅ done)
- Coverage promise — every gap maps to a workstream landing (H1→B2, H2→C1, H3→B1, H4→D1, H5→A4, H6→A2, H7→C2, H8→A1, H9→A3). (✅ done)
- Dependency check — D1 is an *interface spec* (not blocked on plan 02's deferred orchestrator, B1); H6/H8 reference plan 01 (done) + plan 02 (vision done) contracts. (✅ done)
- Principle impact — **decision pending:** the targets (`01-learning-hub-introduction.md`, `01-automated-content-lifecycle-…md`) are idea docs, not `*vision*.md` files, so `vision-frontmatter.instructions.md` / `vision-amendment.instructions.md` do not auto-apply. Choose (a) treat as idea-doc amendments (no `principles:` overlay; no rename) or (b) promote the Hub docs to formal visions first (adds the vision-amendment overlay + a `…-vision-update-plan.md` rename). (🟡 todo — owner decision)
- Owner sign-off on the building-block declaration (H8) and incremental-build requirement (H2). (🟡 todo)

## 🅿️ Park lot

- Replace Quarto with an incremental publisher (engineering) → defer: vision requirement is in scope; the tool replacement is a separate effort.
- Build the IQPilot MCP extensions → defer: spec in scope; build separate.
- Implement the knowledge graph → defer: concept in scope; implementation separate.
- Author subject configs (`identity:` + `monitoring:` sections of `_metadata.yml`) for specific Hub subjects → defer: the mechanism is in [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md); per-subject authoring is a separate effort.

## 🏁 Exit criteria

- Vision + lifecycle docs amended for H5, H6, H8, H9 and the incremental-build requirement (H2), owner-approved. (🟡 todo)
- Subject `identity:` + `monitoring:` config (formerly the `_subject.yml` manifest) schema and conference-ingestion workflow specified (marked planned). (🟡 todo)
- IQPilot extensions + content-freshness wiring specified (implementation parked). (🟡 todo)
