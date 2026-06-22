---
title: "Learning Hub — vision/strategy update plan"
author: "Dario Airoldi"
date: "2026-06-21"
status: in-progress
domain: "learning-hub"
goal: "Amend the Learning Hub idea/vision and automated-content-lifecycle docs so the project meets its OWN goal — a personal, generalized analysis-and-elaboration engine over many content types that publishes incrementally — by closing the gaps that keep its automation aspirational: the unimplemented conference/event ingestion pipeline, the un-realized incremental build, the unbuilt subject-config sections of `_metadata.yml` (formerly the `_subject.yml` manifest), the undeployed content-freshness machinery, the missing knowledge graph, and the implicit (undeclared) building-block dependencies on the article-writing and PE projects."
motivation: "The Learning Hub is a personal learning system whose scope (analysis and elaboration over feeds, papers, transcripts, recordings, events) is broader than the documentation the other two projects maintain. Its vision is well-designed but much of the automation is designed-not-built, and its dependencies on the article-writing engine (for content maintenance) and the PE engine (for automation) are real but never declared as versioned building-block contracts. Making those explicit, and naming the unbuilt pieces, lets the Hub progress without re-deriving the architecture each cycle."
rationales:
  - "The Hub's own goal (knowledge development over many content types) exceeds its role as a publishing target for the other two projects"
  - "Building-block dependencies on article-writing and PE must be declared, not assumed"
  - "Vision changes are human-only; this plan is a draft proposal for owner approval"
---

# Learning Hub — vision/strategy update plan

> Status: **in-progress** — vision-amendment plan; owner confirmed the principle set (3 P0 / 4 P1 / 1 P2) and directed execution of the remaining feasible items (Dario Airoldi, 2026-06-22). Workstreams **A–D are executed** as **uncommitted** edits to the two Hub idea/vision docs ([01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) bumped to v1.2; [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) extended). The optional **rename** to a `*vision*` filename is deferred (see § Park lot) because it would break inbound links. Implementation builds remain parked. Pending owner review before commit.

## 🎯 Goal

Close the gaps that keep the Learning Hub's automation aspirational, so it meets its **own** goal — an information-centric, generalized analysis-and-elaboration engine that publishes incrementally — and, secondarily, consumes the article-writing and PE projects cleanly as declared building blocks.

### Original trigger (verbatim)

> Review the Learning Hub idea/vision and strategy and create an improvement plan that closes the critical issues and gaps in its vision and strategy.

### Goal items (scope-tagged + principle-impact-tagged)

This plan is now a `*vision*plan*.md`, so per `vision-amendment.instructions.md` every in-scope item carries a scope tag, a principle-impact attestation, and a downstream landing. The lead Hub doc ([01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md)) has **no `principles:` block**; item **A0** declares one (bootstrap, naming the doc's existing *Core Transformation Principles* + the configuration / visibility / generalized-engine invariants). The `preserves:` ids below reference the principle set A0 will declare, **owner-confirmed (2026-06-22)**: P0 — `information-centric`, `generalized-content-engine`, `per-piece-visibility`; P1 — `incremental-integration`, `configuration-driven`, `structured-knowledge-development`, `active-critical-and-creative-development`; P2 — `collaborative-learning`.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| A0 | Promote the lead Hub doc to a formal vision — declare a `principles:` block (`information-centric`, `structured-knowledge-development`, `active-critical-and-creative-development`, `collaborative-learning`, `configuration-driven`, `per-piece-visibility`, `generalized-content-engine`, `incremental-integration`) | `[vision-only: no-downstream]` | declares the principle set (bootstrap; no version bump) | `landing: vision-only` |
| A1 | Building-block dependency declaration (article-writing + PE as versioned blocks) | `[in-scope: original]` | preserves: `generalized-content-engine` | `landing:` introduction doc (resolves H8) |
| A2 | Reconcile the two self-update timescales | `[in-scope: original]` | preserves: `configuration-driven` | `landing:` lifecycle doc (resolves H6) |
| A3 | Publish promotion-gate policy | `[in-scope: original]` | preserves: `per-piece-visibility` | `landing:` lifecycle doc (resolves H9) |
| A4 | Knowledge-graph / semantic cross-linking concept | `[in-scope: original]` | preserves: `structured-knowledge-development` | `landing:` lifecycle doc (resolves H5) |
| B1 | Subject config (`identity:` + `monitoring:` sections of `_metadata.yml`) | `[in-scope: original]` | preserves: `configuration-driven`, `structured-knowledge-development` | `landing:` lifecycle doc + schema sketch (resolves H3) |
| B2 | Conference/event ingestion workflow | `[in-scope: original]` | preserves: `generalized-content-engine`, `information-centric` | `landing:` lifecycle doc (resolves H1) |
| C1 | Incremental-build requirement | `[in-scope: original]` | preserves: `incremental-integration` | `landing:` introduction + lifecycle doc (resolves H2) |
| C2 | IQPilot MCP extensions | `[in-scope: original]` | preserves: `structured-knowledge-development` | `landing:` lifecycle doc (resolves H7) |
| D1 | Content-freshness wiring contract (interface spec) | `[in-scope: original]` | preserves: `information-centric` | `landing:` lifecycle doc (resolves H4) |
| D2 | Endorse inherited identity in the freshness lifecycle | `[in-scope: original]` | preserves: `information-centric` | `landing:` lifecycle doc (consumes plan 04) |

No `[scope-expansion]` rows in the active list; surfaced expansions live in § Park lot. No P0/P1 *touches* — A0 *declares* the principle set; A1–D2 are additive amendments that preserve it (no consent lines required — the owner confirmed the P0/P1 split, and none of A1–D2 touch a principle).

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

### A. Vision amendments — `01-learning-hub-introduction.md` + `01-automated-content-lifecycle-…md` (✅ done)

0. **Promote the lead Hub doc to a formal vision** — declare a `principles:` block in [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md), naming its existing **Core Transformation Principles** (`information-centric`, `structured-knowledge-development`, `active-critical-and-creative-development`, `collaborative-learning`) plus the **configuration-driven**, **per-piece-visibility**, **generalized-content-engine**, and **incremental-integration** invariants. Bootstrap declaration (no version bump per `vision-frontmatter.instructions.md`); enables the principle-impact tagging of A1–D2. Consider renaming the doc to include `vision` so `vision-frontmatter.instructions.md` auto-applies. Landing: that doc. (✅ done — declared the `principles:` block with all 8 ids (3 P0 / 4 P1 / 1 P2); annotated each body principle with a `**Priority: Pn** · `id`` line; doc bumped to v1.2. The optional rename is deferred to § Park lot — it would break inbound links from `_quarto.yml`, `README.md`, `index.qmd`, and the lifecycle doc.)
1. Add a **building-block dependency declaration**: name article-writing (content maintenance) and PE (automation) as versioned building blocks the Hub consumes, with the contract each provides (resolves H8). Landing: [01-learning-hub-introduction.md](../../../../../06.00-idea/learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md). (✅ done — added the **Building blocks: article-writing and PE engines** section to the introduction, plus a mirror in the lifecycle doc's new requirements section.)
2. Reconcile the **two self-update timescales** (tooling vs. content) into one stated model (resolves H6). Landing: [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md). (✅ done — added the **Two self-update timescales** subsection with the reconciliation rule.)
3. Add a **publish promotion-gate** policy (draft→in-review→published; content vs. metadata write-permission split) (resolves H9). Landing: lifecycle doc. (✅ done — added the **Publish promotion gate** subsection with the three states and write-permission split.)
4. Add a **knowledge-graph / semantic cross-linking** concept for completeness and gap detection (resolves H5). Landing: lifecycle doc. (✅ done — added the **Knowledge graph and semantic cross-linking** subsection (depends-on / elaborates / contradicts / supersedes relations).)

### B. Subject config + ingestion pipeline (✅ done)

1. Specify the **subject config** — the `identity:` + `monitoring:` sections of a subject folder's `_metadata.yml` (formerly proposed as a standalone `_subject.yml`): scope, goal, coverage matrix, product dependencies, monitoring cadence — and mark it *planned* in the lifecycle doc, reconciled into the shared `_metadata.yml` mechanism per [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md) (subject identity → `identity:` section, monitoring → `monitoring:` section) (resolves H3). Landing: lifecycle doc + schema sketch. (✅ done — added a **Reconciliation note (planned)** under Improvement 2 folding `_subject.yml` into the `_metadata.yml` `identity:`/`monitoring:` sections, linking the inheritance context file.)
2. Specify the **conference/event ingestion** workflow as a concrete subagent orchestration (resolves H1). Landing: lifecycle doc; references the existing ingestion prompt. (✅ done — framed the existing 7-step pipeline as a retryable subagent orchestration in the Conference & event ingestion section.)

### C. Deterministic infrastructure (✅ done)

1. Define the **incremental-build** target (publish-agnostic; integration cost ∝ change size) as a vision requirement with a candidate approach (resolves H2). Landing: introduction + lifecycle doc; tool replacement parked. (✅ done — already stated in the introduction's *Publishing & Incremental Integration* and the lifecycle doc's *Phase 7: Publish*; reinforced via the new requirements section. Tool replacement stays parked.)
2. Specify the **IQPilot MCP extensions** (navigation check, xref validate) as deterministic tools (resolves H7). Landing: lifecycle doc (new "IQPilot extensions" section; promoted to a separate spec file only if it outgrows the doc). (✅ done — `iqpilot/xref/validate` already specified in Layer 4; added the `iqpilot/navigation/check` tool spec. Build stays parked.)

### D. Content-freshness wiring (✅ done)

1. Specify the **content-freshness wiring contract** — the interface by which the Hub's freshness machinery consumes the article-writing orchestrator + per-dimension skills (resolves H4). The orchestrator/skills are **deferred in plan 02** (its B/C/D), so this is an *interface spec*, not live wiring, and is therefore **not blocked** on that build. Landing: lifecycle doc. (✅ done — added the **Content-freshness wiring contract** subsection (input / capability / output interface).)
2. **Endorse inherited identity in the freshness lifecycle.** An ancestor `_metadata.yml` change is a staleness signal that invalidates descendant articles' effective metadata; revalidation triage MUST reverify the `effective:` block (`inputs_hash`) and recompute before assessing (consumes [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md)). Landing: lifecycle doc. (✅ done — added the **Inherited identity is a staleness signal** subsection linking the inheritance context file.)

## 🧪 Actionability Gate (run before promoting to `actionable`)

- Clarity — every step names a concrete edit to a concrete file. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation (D1 = interface spec, not live wiring; C2 lands in the lifecycle doc). (✅ done)
- Scope discipline — items stay within the Hub's own goal; capabilities owned by article-writing/PE are referenced, not duplicated; no `[scope-expansion]` in the active list. (✅ done)
- Coverage promise — every gap maps to a workstream landing (H1→B2, H2→C1, H3→B1, H4→D1, H5→A4, H6→A2, H7→C2, H8→A1, H9→A3). (✅ done)
- Dependency check — D1 is an *interface spec* (not blocked on plan 02's deferred orchestrator, B1); H6/H8 reference plan 01 (done) + plan 02 (vision done) contracts. (✅ done)
- Principle impact — § Goal items table tags every item per `vision-amendment.instructions.md`; the principle set A0 will declare is **owner-confirmed (2026-06-22)** — 3 P0 / 4 P1 / 1 P2. (✅ done)
- Owner sign-off on the building-block declaration (H8) and incremental-build requirement (H2). (✅ done — Dario Airoldi, 2026-06-22)

## 🅿️ Park lot

- Rename the lead Hub doc to a `*vision*` filename so `vision-frontmatter.instructions.md` auto-applies the principle-block gate → defer: requires updating inbound links (`_quarto.yml` ×2, `README.md`, `index.qmd`, the lifecycle doc) and regenerating `navigation.json`; the `principles:` block is declared regardless, so the rename is a separate link-maintenance pass.
- Replace Quarto with an incremental publisher (engineering) → defer: vision requirement is in scope; the tool replacement is a separate effort.
- Build the IQPilot MCP extensions → defer: spec in scope; build separate.
- Implement the knowledge graph → defer: concept in scope; implementation separate.
- Author subject configs (`identity:` + `monitoring:` sections of `_metadata.yml`) for specific Hub subjects → defer: the mechanism is in [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md); per-subject authoring is a separate effort.

## 🏁 Exit criteria

- Vision + lifecycle docs amended for H5, H6, H8, H9 and the incremental-build requirement (H2). (✅ done — applied as uncommitted edits; owner-directed, pending final review before commit.)
- Subject `identity:` + `monitoring:` config (formerly the `_subject.yml` manifest) schema and conference-ingestion workflow specified (marked planned). (✅ done)
- IQPilot extensions + content-freshness wiring specified (implementation parked). (✅ done)
