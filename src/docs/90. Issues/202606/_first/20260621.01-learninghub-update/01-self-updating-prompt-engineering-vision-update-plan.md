---
title: "Self-updating prompt engineering — vision/strategy update plan"
author: "Dario Airoldi"
date: "2026-06-21"
status: in-progress
domain: "prompt-engineering"
goal: "Amend the self-updating PE vision and its supporting context so the engine fully meets its OWN goal — maintaining any portable PE artifact system at peak reliability/effectiveness/efficiency — by closing the gaps that currently limit it: no domain-expertise injection (role/domain switch + a per-domain `domain_profile` convention), unbuilt config/state/eval infrastructure, the undecided pe-simple tier, and an undrawn engine/integration portability seam."
motivation: "The PE engine is a general-purpose, portable self-update system (its scope is far broader than the artifacts needed by article-writing or the Learning Hub). Several capabilities required by that broad scope are missing or implicit: the engine assesses every domain through a PE lens, has no first-class notion of target-domain expertise, lacks the monitored-source/state/outcome substrate its own autonomy gradient depends on, and has never had its portability seam instantiated. These gaps cap both the engine's standalone value AND its usefulness as a building block for the other two projects."
rationales:
  - "Each project evolves on its own roadmap; this plan targets the PE engine's own goal first and its building-block role second"
  - "Vision changes are human-only (PE boundary); this plan is a draft proposal for owner approval, not an autonomous amendment"
  - "Per-item landing docs keep the amendment auditable and prevent silent scope expansion"
---

# Self-updating prompt engineering — vision/strategy update plan

> Status: **in-progress** — owner consent given (2026-06-21) for the P0 touches (A2, A3) and the additive C1 vision pointer; A1 resolved as **P1**; E1 resolved as **implement independently**. All workstreams A–E are **applied as uncommitted edits** for review before commit (vision v15.8.0 + changelog; the B1 template; the B2/C1/D1 context + index edits). Implementation of the config/state substrate, the eval harness, and the pe-simple tier are separate efforts (§ Park lot). Vision changes are human-only per the PE vision `boundaries:` block.

## 🎯 Goal

Close the critical gaps in the self-updating PE vision and supporting context so the engine meets its **own** stated goal — *maintain PE artifacts at peak reliability, effectiveness, and efficiency, with the maximum autonomy that assessed risk allows, portably across any repository* — and, as a secondary lens, serves cleanly as the foundational building block the article-writing and Learning Hub projects consume.

### Original trigger (verbatim)

> Review the self-updating prompt-engineering vision/strategy and create an improvement plan that closes the critical issues and gaps in its vision and strategy.

### Goal items (scope-tagged + principle-impact-tagged)

Per `vision-amendment.instructions.md`, every in-scope item carries a scope tag, a principle-impact attestation against the vision `principles:` block, and a downstream landing. Scope-expansion items (if any) are quarantined in § Park lot.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| A1 | Add a `domain-expertise-injection` principle (role/domain switch) | `[in-scope: original]` | preserves: `staleness-avoidance-first`, `portable-by-design`, `minimal-canonical-surface`; adds a NEW **P1** principle (changelog entry; no version bump) | [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) (+ changelog) |
| A2 | Generalize `external-knowledge` to per-domain authoritative sources | `[in-scope: original]` | preserves: `portable-by-design`, `metadata-first-content-properties`; touches: `staleness-avoidance-first` (P0 consent) | vision § The rationale (+ changelog) |
| A3 | Specify the engine/integration portability seam | `[in-scope: original]` | preserves: `command-family-agnostic`, `invocation-shape-agnostic`; touches: `portable-by-design` (P0 consent) | vision § The vision (+ changelog) |
| A4 | Make target domain a *resolved* creation attribute (no new parameter) | `[in-scope: original]` | preserves: `minimal-canonical-surface`; touches: `metadata-first-content-properties` (P1 justification: domain becomes a derived creation attribute resolved at Phase 0a, never a `--domain` flag) | vision § The vision + § Command families (+ changelog) |
| B1 | Per-domain profile convention (the `domain_profile:` section per 00.06) | `[in-scope: original]` | preserves: `metadata-first-content-properties`, `single-source-of-truth` | template under [.github/templates/00.00-prompt-engineering/](../../../../../.github/templates/00.00-prompt-engineering/); mechanism in [00.06](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md) |
| B3 | Distinguish the `domain_profile:` (grounding) from `pe-domain-map.yaml` (resolution) | `[vision-only: no-downstream]` | preserves: `metadata-first-content-properties` | `landing: vision-only` (§ Domain detection wording) |
| C1 | Specify config + state substrate (implementation parked) | `[in-scope: original]` | preserves: `portable-by-design`, `staleness-avoidance-first` | vision § The vision + new context spec |
| D1 | Specify eval/regression contract (implementation parked) | `[in-scope: original]` | preserves: `evidence-based` | [05.05-practical-effectiveness-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md) + new eval context file |
| E1 | Record the pe-simple tier decision | `[vision-only: no-downstream]` | preserves: `minimal-canonical-surface` | `landing: vision-only` (§ The vision) + [.github/agents/00.00-pe-simple/](../../../../../.github/agents/00.00-pe-simple/) |

**Reconciled — already applied via plan 04 / spec 00.06 (not re-executed here):**

| # | Item | Status |
|---|------|--------|
| A6 | Runtime cache-staleness step under `runtime-grounding` + Tier-1 folder-inheritance in § Domain detection | (✅ done — applied as uncommitted vision edits via [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md) / [00.06](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md)) |

#### P0 consent lines (confirmed)

- This item (**A2**) touches **P0** `staleness-avoidance-first` — additive (broadens the monitored-source scope from PE-only to per-domain; no weakening). Vision version bump applied (minor, additive → v15.8.0). Consent confirmed by: **Dario Airoldi (2026-06-21)**.
- This item (**A3**) touches **P0** `portable-by-design` — additive (specifies the previously-undrawn portable-core / consumer-config seam; no weakening). Vision version bump applied (minor, additive → v15.8.0). Consent confirmed by: **Dario Airoldi (2026-06-21)**.

> **A1 priority resolved: P1** (owner decision, 2026-06-21). Added to the vision `principles:` block as a new P1 principle with a matching body section and a changelog entry (no version bump on its own account).

## 🧭 Standalone scope vs. integrated role

This project is **not** a layer of one super-system. Its scope is *every PE artifact system anywhere*, of which the article-writing and Learning Hub artifacts are merely two consumers.

- **Own goal (primary):** a portable, repository-agnostic self-update engine for prompt-engineering artifacts of any domain, installable via MCP / GHCP SDK / VS Code extension.
- **Integrated role (secondary):** the engine that keeps the article-writing and Learning Hub PE artifacts fresh. This role is satisfied by the same general capabilities — it does **not** justify any PE-specific coupling to those consumers.

The amendments below are justified by the **own goal**; the integrated role is noted only where it sharpens a requirement.

## 🔎 Gap analysis (vs. own goal, with integrated lens) (✅ done)

Findings from the cross-layer review. Each row is an observation; resolutions are in § Workstreams.

| # | Gap | Why it matters to the OWN goal | Integrated lens |
|---|------|-------------------------------|-----------------|
| G1 | **No domain-expertise injection (role/domain switch).** The engine reads `domain:` metadata for *batching* (Phase 0b) but has no mechanism for a researcher/builder to *adopt* target-domain expertise when creating or maintaining a non-PE-domain artifact. Every artifact is assessed "through a PE lens." | The vision claims to maintain artifacts of *any* domain; without domain-expertise injection that claim is unmet for everything except prompt-engineering itself. | Directly caps the quality of azure/k8s/etc. artifacts and of article-writing/Hub artifacts. |
| G2 | **No standardized per-domain profile.** Domains already exist as top-level `.copilot/context/{domain}/` siblings, but none carries a machine-readable `domain_profile:` — the domain's identity-and-contract (role, authoritative sources, invariants, plus the domain's boundaries and quality criteria) the facets G1/G3 need. (A "knowledge pack" is not a new concept; it IS the per-domain context folder — only the profile is missing.) | The keystone that makes G1/G3 reliable: without a structured profile, domain expertise and per-domain source maps stay parametric and unauditable. | One convention serves creation grounding (tiers) and content grounding (article-writing/Hub). |
| G3 | **Type-B staleness detection has no per-domain authoritative-source map.** `external-knowledge` monitors PE/VS Code/Copilot sources only. | The engine's top-priority objective (source-grounded Type-B resolution) cannot fire for non-PE domains — the hardest staleness class is undetectable there. | Blocks autoupdate of any non-PE-domain artifact. |
| G4 | **`pe-simple` tier is an empty stub** (`.github/agents/00.00-pe-simple/` is `.gitkeep`-only; 4 orphan prompts). | An undecided tier leaves the authoring architecture incomplete and the maintainer scope ambiguous. | — |
| G5 | **Self-update config + state substrate absent.** No `pe-self-update.config.json` (monitored sources, autonomy thresholds), no `.copilot/state/<engine_id>/` (outcome log, rename log, snapshots). | The autonomy gradient and `progressive-learning` depend on historical success data and a source registry that do not exist; confidence inputs are missing. | — |
| G6 | **No eval harness / regression suite.** `progressive-learning` and the practical-effectiveness log gesture at measurement but there is no golden-output dataset. | "Effective" is asserted, never measured; the engine cannot prove v(N+1) beats v(N). | — |
| G7 | **Engine/integration portability seam undrawn.** The `portable` / engine-integration-separation P0 items exist, but the seam (portable core vs. domain config a consumer supplies) is never specified, and portability has never been instantiated. | A core P0 claim is unfalsified; nothing defines what a consumer must provide to instantiate the engine. | This seam IS the contract article-writing and the Hub consume. |
| G8 | **Authoring tiers differentiated by granularity only.** simple/consolidated/granular differ in triad decomposition; "target domain" is not a first-class creation axis. | The engine cannot express "build an azure agent with azure expertise" — only "build an agent." | — |

## ⚙️ Workstreams

Each item names its landing document and is `(🟡 todo)` pending owner approval.

### A. Vision amendments — `20260531.01-vision.md` (+ changelog) (✅ done)

> Applied as uncommitted edits (2026-06-21). Owner consent confirmed for the P0 touches (A2, A3); A1 added as a new **P1** principle. Vision bumped 15.7.0 → **15.8.0**; changelog v15.8.0 cut (V1–V5).

1. Add a **domain-expertise injection** principle/rationale (role/domain switch): an artifact-authoring or maintenance pass MAY adopt a declared target-domain role, grounded by an authoritative domain source, before producing or assessing content (resolves G1). Added as **P1** to the `principles:` + `scope.covers` blocks with a matching body principle section. (✅ done)
2. Generalize the **`external-knowledge`** rationale from "PE/platform sources" to "per-domain authoritative sources," with the source map declared in config (resolves G3). Touches **P0** `staleness-avoidance-first` (additive; consent confirmed). (✅ done)
3. Add an **engine/integration portability seam** subsection defining the portable core vs. the domain-config a consumer supplies (resolves G7). Touches **P0** `portable-by-design` (additive; consent confirmed). Landed in vision § The vision. (✅ done)
4. Make **target domain** a *resolved* creation attribute — **not** a new parameter (`minimal-canonical-surface` P0 preserved); resolved via Phase 0a, grounded by the matching `domain_profile:` (resolves G8). Touches **P1** `metadata-first-content-properties`. Landed in vision § The vision (“Target domain is a resolved creation attribute”). (✅ done)
5. Recorded all of the above in [20260531.01-vision.changelog.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md) as **v15.8.0** with priority-touch + minor version bump per `vision-frontmatter.instructions.md`. (✅ done)
6. **Inherited/effective metadata at execution time — already applied.** The `runtime-grounding` cache-staleness step (recompute `inputs_hash` over the ancestor chain; on mismatch recompute, else fail-closed/escalate) and the § Domain detection Tier-1 folder-inheritance were applied via [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md) / [00.06](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md). (✅ done — via plan 04; nothing further required here)

### B. Per-domain `domain_profile` convention (✅ done)

> Not a new artifact category. Domains already exist as top-level siblings under [.copilot/context/](../../../../../.copilot/context/) (`00.00-prompt-engineering/`, `01.00-article-writing/`, `10.00-application-development/`, `11.00-application-migration/`, `90.00-learning-hub/`). A "knowledge pack" IS that per-domain folder; the only missing piece is a standardized profile inside each. The profile is realized via the shared `_metadata.yml` mechanism — see [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md); domain grounding is one facet of its non-inherited `domain_profile:` section.

1. Define a standardized **per-domain profile** — the `domain_profile:` section of a domain folder's `_metadata.yml` (NOT a separate file; the earlier `_domain.yml` idea is folded into this section, just as the Hub's `_subject.yml` folds into the `identity:` + `monitoring:` sections) — carrying the machine-readable facets G1/G3 need plus the domain contract: role / expert framing, authoritative sources + version schemes, monitored invariants, and the contract facets (scope, boundaries, quality_criteria, conventions) (resolves G2, supports G1/G3). The schema is **already specified** as the `domain_profile:` section in [00.06](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md); this item adds an authoring template. Landing: a template under [.github/templates/00.00-prompt-engineering/](../../../../../.github/templates/00.00-prompt-engineering/); profiles live as the `domain_profile:` section of each top-level domain folder's `_metadata.yml` under [.copilot/context/](../../../../../.copilot/context/). (✅ done — template: [guidance-domain-profile.template.md](../../../../../.github/templates/00.00-prompt-engineering/guidance-domain-profile.template.md))
2. Document the "domains are top-level `.copilot/context/` siblings, each carrying a `domain_profile`" convention in the cross-domain index. The folder-inheritance note is **already present** (added via plan 04 G); this item extends it with the `domain_profile` convention. Landing: [00.00-context-folder-index.md](../../../../../.copilot/context/00.00-context-folder-index.md). (✅ done — added “Per-domain `domain_profile` convention” subsection)
3. Distinguish the `domain_profile:` (domain *grounding* facets — role/sources/invariants — plus contract facets) from the existing `pe-domain-map.yaml` (domain *resolution* — which domain is this file?) so the two are not conflated. Landing: vision § Domain detection. (✅ done — applied: “Resolution vs. profile” callout added to vision § Domain detection)

### C. Config + state substrate (✅ done)

1. Specify `pe-self-update.config.json` (monitored sources per domain, autonomy thresholds, state namespacing) and the `.copilot/state/<engine_id>/` layout (outcome log, rename log, snapshots) (resolves G5). **Context spec written** — [05.09-self-update-config-and-state.md](../../../../../.copilot/context/00.00-prompt-engineering/05.09-self-update-config-and-state.md) (registered in the structure index + category catalog). The vision § The vision (Per-repo integration model) now points its inline config/state description at that contract (additive/P2 pointer, owner-approved 2026-06-21; changelog staged under Unreleased). Implementation parked. (✅ done)

### D. Eval harness (✅ done)

1. Define an eval/regression contract (golden inputs/outputs per artifact type and per dimension) that feeds `progressive-learning` (resolves G6). Landing: [05.05-practical-effectiveness-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md) + new eval context file. (✅ done — contract: [05.10-eval-regression-contract.md](../../../../../.copilot/context/00.00-prompt-engineering/05.10-eval-regression-contract.md); complementary-evidence note added to 05.05; registered in the structure index + category catalog)

### E. pe-simple decision (✅ done)

1. Resolve the `pe-simple` tier: delegate-to-consolidated vs. remove vs. implement (resolves G4). **Decision (owner, 2026-06-21): implement independently** — pe-simple is *retained* as its own lightweight tier and built as a separate effort; it is NOT delegated to consolidated and NOT removed, and no routing/folding of the existing `pe-sim-*` prompts is performed. The vision needs no change (it does not enumerate authoring tiers); the existing [.github/agents/00.00-pe-simple/](../../../../../.github/agents/00.00-pe-simple/) scaffold + `pe-sim-*` prompts are retained as the seed of that independent effort. (✅ done — decision recorded; implementation is a separate effort, see § Park lot)

## 🧪 Actionability Gate (structural checks passed 2026-06-21; P0 consent pending)

- Clarity — every workstream step names a concrete edit to a concrete file. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation. (✅ done)
- Scope discipline — no item exceeds the PE engine's own goal; cross-layer items are framed as building-block contracts, not coupling; no `[scope-expansion]` rows in the active goal list (implementation efforts are in § Park lot). (✅ done)
- Coverage promise — every gap G1–G8 maps to a goal-table row with a resolving landing (G1→A1, G2→B1, G3→A2, G4→E1, G5→C1, G6→D1, G7→A3, G8→A4). (✅ done)
- Principle impact — § Goal items table tags every in-scope item with `preserves:`/`touches:` against the vision `principles:` block; P1 touch (A4) carries an inline justification. (✅ done)
- Principle impact — P0 consent lines present and **confirmed** for A2 and A3 (Dario Airoldi, 2026-06-21). (✅ done)
- Owner sign-off on the genuinely new vision elements: domain-expertise injection (A1 → P1), and the P0 touches (A2 `staleness-avoidance-first`, A3 `portable-by-design`). (✅ done)

## 🅿️ Park lot

- Implement the config/state substrate (engineering) → defer: vision-level mandate is in scope; the build is a separate effort.
- Implement the eval harness tooling → defer.
- Implement the `pe-simple` tier independently (owner decision E1) → defer: retained as its own lightweight tier; the build is a separate effort — no routing to consolidated, the existing `pe-sim-*` prompts are its seed.
- Author per-domain `domain_profile`s for specific domains (azure, k8s, …) → → consumed by `02-self-updating-article-writing-vision-update-plan.md` and `03-learning-hub-vision-update-plan.md`; per-domain profile *authoring* is a separate effort.
- Champion-challenger benchmarking across the three tiers → defer: depends on eval harness (D).

## 🏁 Exit criteria

- Vision + changelog amended for G1, G3, G7, G8 with owner sign-off (A1–A4). (✅ done — uncommitted; vision v15.8.0)
- Per-domain profile convention (G2) defined: `domain_profile:` schema is in 00.06; authoring template + cross-domain index note added (B1, B2). (✅ done)
- pe-simple tier decision recorded (E1). (✅ done — decision: implement independently; the build is a separate effort)
- Config/state and eval contracts specified, implementation parked (C1, D1). (✅ done — D1 eval contract; C1 config/state spec + additive vision pointer; both implementations parked)
- Runtime cache-staleness step + § Domain detection Tier-1 inheritance (A6) + resolution-vs-grounding distinction (B3). (✅ done)
