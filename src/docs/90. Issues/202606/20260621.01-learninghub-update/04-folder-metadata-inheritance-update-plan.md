---
title: "Folder-metadata inheritance (`_metadata.yml`) — cross-cutting update plan"
author: "Dario Airoldi"
date: "2026-06-21"
status: in-progress
domain: "prompt-engineering"
goal: "Define a repository-wide folder-level metadata mechanism (`_metadata.yml`) with a deterministic keyed-merge inheritance rule and a materialized cache, so folder-scoped identity metadata (goal/scope/boundaries/rationales/primary + additional domains) is declared once on a folder and inherited by descendant articles — eliminating per-article redundancy, making the folder a first-class reasoning unit, and unifying the separately-proposed `_domain.yml` and `_subject.yml` concepts under one sectioned schema."
motivation: "This is a cross-cutting building block consumed by all three project plans (01 domain grounding, 02 article identity inheritance, 03 subject identity + monitoring). The repo already cascades configuration by folder depth (appsettings) and already caches generated metadata (the bottom validation block) — so folder-metadata inheritance reuses two proven patterns rather than introducing new architecture. The only genuine risk is resolution-semantics divergence between consumers; this plan therefore gates adoption on specifying the merge algorithm and the materialized-cache contract FIRST."
rationales:
  - "Folder-scoped identity restated per article is redundant and drift-prone — single-source-of-truth applied to the folder"
  - "Reuses the appsettings folder-depth cascade and the validation-caching generated-block pattern the repo already runs"
  - "A deterministic merge + materialized cache is the precondition that prevents silent metadata divergence between the AI, MetadataWatcher, validators, and Quarto"
  - "Vision/contract changes are human-only; this plan is a draft proposal for owner approval"
---

# Folder-metadata inheritance (`_metadata.yml`) — cross-cutting update plan

> Status: **in-progress** — owner approved (2026-06-21); executing as uncommitted changes for review before commit. The keystone spec is authored at [00.06-folder-metadata-inheritance.md](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md); the live PE-vision/contract/index propagation (D, G) is **applied** as uncommitted edits and awaits owner review before the plan closes.

## 🎯 Goal

Introduce a repository-wide `_metadata.yml` folder file whose `identity:` section is inherited by descendant articles through a deterministic keyed-merge, materialized into a generated cache block — so folder identity is authored once, the folder becomes a reasoning unit, and the three separate per-folder-manifest proposals collapse into one sectioned schema.

## 🧭 Cross-cutting scope (shared building block)

This mechanism is **not owned by one project** — it is repo-wide metadata infrastructure consumed by all three plans. It is defined **once here** (single-source-of-truth) and referenced by:

- [01-self-updating-prompt-engineering-vision-update-plan.md](01-self-updating-prompt-engineering-vision-update-plan.md) — domain grounding (G2) is one facet of the non-inherited `domain_profile:` section.
- [02-self-updating-article-writing-vision-update-plan.md](02-self-updating-article-writing-vision-update-plan.md) — article identity inheritance reduces per-article redundancy across the documentation corpus.
- [03-learning-hub-update-plan.md](03-learning-hub-update-plan.md) — the proposed `_subject.yml` (H3) becomes the `identity:` + `monitoring:` sections.

## 🔎 Why this is needed (analysis) (✅ done)

| # | Driver | Detail |
|---|--------|--------|
| M1 | **Redundancy** | Folder-scoped `goal`/`scope`/`boundaries` are restated in every article; siblings drift. |
| M2 | **No folder reasoning unit** | A folder (subject/domain) has its own identity but nowhere to declare it; coverage/gap reasoning has no anchor. |
| M3 | **Three competing manifest concepts** | `_domain.yml` (plan 01), `_subject.yml` (plan 03), and per-article identity are the same mechanism viewed three ways. |
| M4 | **Silent inheritance risk** | If constraints are inherited but invisible where you read, boundaries can apply without being seen — unsafe. |
| M5 | **Computed-metadata divergence risk** | If the AI, MetadataWatcher, validators, and Quarto each resolve the cascade differently, metadata silently diverges. |

**Resolution (proven in this conversation):** a deterministic keyed-merge + a materialized cache + a sectioned schema overcome M4/M5 using patterns the repo already uses (folder-depth cascade, generated validation block). The materialized block doubles as the effective-vs-declared view (closes M4); a single computing component closes M5.

## 🛡️ Safety & backward-compatibility (additive by design)

Introducing the mechanism changes no existing file's behavior until a folder opts in by adding a `_metadata.yml`. These invariants are the safety contract the design MUST honor:

- **Zero-touch when absent** — if no `_metadata.yml` exists in an article's ancestor chain, nothing is computed and **no `effective:` block is written**; existing Learning Hub articles are untouched. (✅ done)
- **Nearest-wins preserves today's behavior** — while articles keep their declared frontmatter, effective = declared (identical to now); dropping now-redundant fields is a separate, later, opt-in retrofit (parked). (✅ done)
- **Bounded applicability domain** — the cascade runs ONLY in (a) article content trees and (b) `.copilot/context/{domain}/` identity; it is NEVER applied to PE artifact folders (`.github/agents|prompts|instructions|templates|skills|snippets`) or vision/use-case docs, whose mandated schemas stay authoritative. (✅ done)
- **Spec-now / build-later** — until MetadataWatcher implements the cascade the mechanism is inert; the watcher ships with a dry-run mode and the zero-touch guard. (✅ done)
- **Quarto-safe by location** — `.copilot/context/` `_metadata.yml` files are outside the Quarto render root (no render effect); content-tree `_metadata.yml` uses Quarto's own directory-metadata mechanism, gated by a reserved-key compatibility check before rollout (parked). No `_metadata.yml` exists in the repo today, so there is no collision. (✅ done)

## 🧱 Baseline field list (`_metadata.yml`) (✅ done)

> Baseline only — **designed to expand**. A top-level `schema_version` gates forward-compatibility; consumers MUST preserve unknown keys (never drop them). New fields are additive via a `schema_version` bump; renames/removals are breaking and human-only.

**File-level**

| Field | Type | Inherited? | Purpose |
|---|---|---|---|
| `schema_version` | int | n/a | Contract version for forward-compat (REQUIRED). |
| `inherit` | bool | n/a | Whether descendants inherit `identity:` (default `true`). |

**`identity:` — INHERITED** (the inheritable subset of the article stable-identity block; **never** includes per-article `title`, `date`, `description`)

| Field | Type | Merge rule |
|---|---|---|
| `author` | scalar | nearest-wins |
| `categories` | array | inherit-all + keyed ops |
| `domain` | scalar | nearest-wins · the single **primary** domain (classification / domain-coherent batching) |
| `additional_domains` | ordered list `[id, …]` | inherit-all + keyed ops (key = id, position = relevance) · the *secondary* related domains for role/domain-switch; full ranked list = `[domain] + additional_domains` |
| `goal` | scalar | nearest-wins (article refines) |
| `scope` | scalar | nearest-wins |
| `boundaries` | keyed array `[{id, text}]` | inherit-all · `remove` requires `reason` (no silent weakening) |
| `rationales` | keyed array `[{id, text}]` | inherit-all + keyed ops |

> **`domain` vs `additional_domains` vs `domain_profile` (three distinct names).** `domain:` (scalar) is the one *primary* domain used for classification and domain-coherent batching — kept scalar (not promoted to a section) so existing `domain: <id>` frontmatter stays valid. `additional_domains:` (ordered list) holds the *secondary* related domains for role/domain-switch grounding — each domain is stated exactly once (no redundancy with `domain`), and list position encodes descending relevance, so the full ranked list is `[domain] + additional_domains`. `domain_profile:` is neither a label nor a list — it is the *domain's own identity-and-contract* (a domain has an identity, just like an artifact does), defined once per domain and referenced by id; grounding is one facet. Canonical schema: [00.06](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md).

**`domain_profile:` — OPTIONAL · context folders · NOT inherited** (the domain's identity & contract; grounding is one facet)

*Grounding facets (acquire):* `role` (G1), `authoritative_sources` (G3), `monitored_invariants`.
*Contract facets (respect / graded against):* `scope`, `boundaries` (domain-wide constraints every artifact must respect), `quality_criteria` (domain-specific grading dimensions), `conventions` (terminology/style).

**`monitoring:` — OPTIONAL · subject folders · NOT inherited** (coverage is derived, not authored)

| Field | Type | Purpose |
|---|---|---|
| `product_dependencies` | `[{product, min_version, docs_url, alert_keywords}]` | content-freshness inputs |
| `review_cadence` | enum | revalidation cadence |
| `staleness_signals` | array | events that trigger revalidation |
| `grounds_on_domain` | ref | links a subject to a `domain_profile` domain (the bridge) |

**Materialized `effective:` block — GENERATED into each descendant article's bottom block** (do-not-edit; volatile per dual-metadata). It is both the effective-vs-declared view and the staleness key.

| Field | Type | Purpose |
|---|---|---|
| `resolved_at` | timestamp | when the cascade was last computed |
| `sources` | array | provenance: each ancestor `_metadata.yml@<hash>` + `self` |
| `identity` | object | the fully merged effective identity values |
| `inputs_hash` | hash | hash of (ancestor chain + declared) — the freshness key |
| `status` | `fresh` \| `stale` | consumed by the runtime staleness check (§ H) |

Minimal example:

```yaml
schema_version: 1
identity:
  author: "Dario Airoldi"
  domain: azure                              # the single primary
  additional_domains: [security, networking] # secondary, descending relevance
  scope: "Azure platform services, architecture, and cost."
  boundaries:
    - { id: b-no-secrets, text: "Never include real tenant IDs; redact to <tenant-id>." }
domain_profile:          # the domain's identity & contract — only in a .copilot/context/{domain}/ folder
  role: "Senior Azure solutions architect."          # grounding facet
  authoritative_sources:
    - { url: "https://learn.microsoft.com/azure/", version_scheme: date }
  boundaries:                                          # contract facet — every artifact in the domain respects it
    - { id: b-no-secrets, text: "Never embed real tenant IDs; redact to <tenant-id>." }
```

## ⚙️ Workstreams

### A. `_metadata.yml` sectioned schema (✅ done)

1. Define a sectioned schema — `identity:` (inherited), `domain_profile:` (optional · context folders · NOT inherited; the domain's identity & contract, of which grounding is one facet), `monitoring:` (optional · subject folders · coverage **derived**, not authored) — so one file holds three single-responsibility sections rather than a polymorphic god-file; the concrete fields are enumerated in § Baseline field list (design-decision). Landing: [00.06-folder-metadata-inheritance.md](../../../../../.copilot/context/00.00-prompt-engineering/00.06-folder-metadata-inheritance.md) (schema + embedded template). (✅ done — standalone template file deferred to activation)

### B. Deterministic keyed-merge rule (✅ done)

1. Specify the merge as a pure function over the ancestor chain (root → leaf, article frontmatter nearest) (design-decision):
   - **Scalars** (`goal`, `scope`, `author`, …): nearest-wins.
   - **Arrays** (`boundaries`, `rationales`, `additional_domains`, `categories`): inherit-all by default; per-element ops `add`, `override` (by key), `remove` (by key, **reason required**); dedupe by key.
   - **`boundaries`**: removal MUST carry a `reason` — no silent weakening of a safety constraint.
   - **Keys**: auto-assigned by the watcher (slug/hash of element text); a dangling `override`/`remove` key (parent text changed) is flagged, not silently dropped.
   Landing: the schema spec (A). (✅ done — specified in 00.06)

### C. Materialized-cache contract (✅ done)

1. Specify a generated `effective:` block per article — do-not-edit, maintained by MetadataWatcher; recomputed on any ancestor `_metadata.yml` change (subtree recompute) (design-decision). It integrates with the dual-metadata model (declared top block + generated effective block; the volatile bottom validation block is unchanged) and IS the effective-vs-declared view. Landing: contract specified in 00.06; live propagation into [02-dual-yaml-metadata.md](../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md) tracked in G. (✅ done — specified)

### D. Domain-resolution tier amendment (✅ done)

1. Slot the folder-inherited **`domain`** (primary) into the PE domain-resolution tiers: declared-own > inherited-from-`_metadata.yml` > `pe-domain-map.yaml` heuristic > `unknown` (design-decision). Landing: PE vision § Domain detection (cross-ref [01-…](01-self-updating-prompt-engineering-vision-update-plan.md)). (✅ done — applied: Tier 1 of § Domain detection now resolves `domain:` via the folder-inheritance cascade (own nearest-wins, else inherited from nearest ancestor `_metadata.yml`); P2 scope item `metadata-first-domain-resolution` refined; runtime staleness note added under § Runtime grounding; staged in the vision changelog Unreleased)

### E. Reconcile the separate manifest proposals (✅ done)

1. Map `_domain.yml` (plan 01 G2) → `domain_profile:` section; `_subject.yml` (plan 03 H3) → `identity:` + `monitoring:` sections. Record the **exemption set**: inheritance is NEVER applied to PE artifact folders (`.github/agents|prompts|instructions|templates|skills|snippets`, governed by their mandated `pe-*` schemas) nor to vision/use-case documents; the cascade's applicability domain is article content trees + `.copilot/context/{domain}/` identity only (design-decision). Landing: exemption set recorded in 00.06; cross-refs present in [01-…](01-self-updating-prompt-engineering-vision-update-plan.md) and [03-…](03-learning-hub-update-plan.md). (✅ done)

### F. Tooling — MetadataWatcher cascade (✅ done)

1. Extend MetadataWatcher to compute the cascade, materialize the `effective:` block, flag dangling override/remove keys, and recompute the subtree on ancestor change. Contract specified here; implementation parked. Landing: [src/MetadataWatcher/](../../../../../src/MetadataWatcher/). (✅ done — contract specified in 00.06; implementation parked)

### G. Repo-wide documentation (✅ done)

1. Document the mechanism in the dual-metadata contract and the cross-domain index. Landing: [02-dual-yaml-metadata.md](../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md), [00.00-context-folder-index.md](../../../../../.copilot/context/00.00-context-folder-index.md). (✅ done — applied: "Folder-level inheritance" section added to the dual-metadata contract; convention noted in the root context index; 00.06 registered under the governance category in [00.04-context-category-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/00.04-context-category-catalog.md))

### H. Runtime metadata-cache staleness verification (✅ done)

1. Specify a **staleness-verification step** for every consumer that reads metadata at execution time — notably PE artifacts under `runtime-grounding`: before relying on the `effective:` block, recompute `inputs_hash` over the current ancestor chain and compare to the cached value; on mismatch the block is **stale** → recompute, or fail-closed/escalate when recompute is unavailable rather than act on stale inheritance (design-decision). Extends `validation-caching` + `metadata-guarded-changes` from per-file to the cascade. Landing: step specified in 00.06; live PE-vision note tracked in D. (✅ done — specified)

## 🧪 Actionability Gate (passed 2026-06-21 — owner-approved)

- Clarity — every step names a concrete edit to a concrete file. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation. (✅ done)
- Scope discipline — the mechanism is defined once here; the three project plans only reference it. (✅ done)
- Coverage promise — drivers M1–M5 each map to a workstream. (✅ done)
- **Sequencing gate** — the merge rule (B) and materialized-cache contract (C) MUST be specified and owner-approved BEFORE any tooling (F), to prevent divergent resolution (M5). (✅ done — B+C specified in 00.06; F parked)
- **Safety invariants** — the § Safety contract (zero-touch-when-absent, nearest-wins, bounded applicability incl. PE-artifact exemption, dry-run) MUST be verified before any tooling rollout. (✅ done — recorded in 00.06 § Safety)
- Owner sign-off — adopting `_metadata.yml` + inheritance changes the repo-wide dual-metadata contract; requires explicit approval. (✅ done — owner approved 2026-06-21, reviewing before commit)

## 🅿️ Park lot

- Implement the MetadataWatcher cascade (engineering) → defer: contract is in scope; build is separate.
- Author per-domain profiles / per-subject configs → → consumed by `01-…` and `03-…`; authoring is separate.
- Retrofit existing articles to drop now-inherited fields → defer: a migration sweep after the mechanism ships.
- Validate Quarto's native `_metadata.yml` merge does not choke on custom identity fields → defer: compatibility check before rollout.

## 🏁 Exit criteria

- Sectioned schema (A) + merge rule (B) + materialized-cache contract (C) specified and owner-approved. (✅ done — in 00.06)
- Baseline field list ratified (extensible via `schema_version`); the three consumer plans (01/02/03) endorse inherited/`effective:` metadata. (✅ done)
- Runtime staleness-verification step (H) specified. (✅ done — in 00.06)
- `_domain.yml` / `_subject.yml` reconciled into the schema; vision/use-case carve-out recorded (E). (✅ done — in 00.06)
- MetadataWatcher cascade contract specified; implementation parked (F). (✅ done — contract in 00.06)
- PE-vision domain-tier amendment + staleness note applied (D). (✅ done — uncommitted)
- Dual-metadata contract + cross-domain index updated (G). (✅ done — uncommitted)
