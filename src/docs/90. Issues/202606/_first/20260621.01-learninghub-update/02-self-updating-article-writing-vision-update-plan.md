---
title: "Self-updating article-writing — vision/strategy update plan"
author: "Dario Airoldi"
date: "2026-06-21"
status: in-progress
domain: "article-writing"
goal: "Amend the self-updating article-writing vision and supporting artifacts so the project meets its OWN goal — keeping any published documentation verified, reliable, readable, understandable, and up to date with reader-risk-calibrated autonomy — by closing the gaps that currently make it a reference standard with no executable system: no maintenance orchestrator, un-automated freshness scoring, no per-dimension skills, no domain-expert grounding, no feedback loop, and a stale, informal reuse seam onto the PE engine."
motivation: "Article-writing is general-purpose documentation maintenance whose scope is far broader than the Learning Hub's articles. Its vision (v1, 2026-04-28) is comprehensive but predates the current PE engine (v15) it claims to inherit, references 'PE v7', and ships zero autonomous agents. The detection signals, freshness model, and SLA tiers are defined but never executed. Closing these gaps makes article-writing valuable standalone AND turns it into the first real instantiation that proves the PE engine's portability."
rationales:
  - "Article-writing's own scope (any documentation) exceeds the Learning Hub role; the plan targets that scope first"
  - "The reuse of the PE engine must be an explicit building-block contract, not inherited prose"
  - "Vision changes are human-only; this plan is a draft proposal for owner approval"
---

# Self-updating article-writing — vision/strategy update plan

> Status: **in-progress** — Workstream A (A0–A4) is **applied as uncommitted edits** to the vision (now **v3.3.0**) + its changelog (2026-06-21): `principles:` block bootstrapped (the eight existing design principles), realigned to the PE engine v15, domain-config + feedback contract added. **Deferred by owner (2026-06-21):** Workstreams B/C/D (orchestrator agent, per-dimension skills, freshness-collection / claim-source / SLA specs) — this execution pass was scoped to **the vision only**, not implementation. Vision edits are human-only; applied with owner sign-off, uncommitted for review.

## 🎯 Goal

Close the gaps that keep the article-writing self-update project a *reference standard* rather than an *executable system*, so it meets its **own** goal — maintaining any published documentation at quality — and, secondarily, becomes the first concrete instantiation of the portable PE engine.

### Original trigger (verbatim)

> Review the self-updating article-writing vision/strategy and create an improvement plan that closes the critical issues and gaps in its vision and strategy.

### Goal items (scope-tagged + principle-impact-tagged)

Per `vision-amendment.instructions.md`, every in-scope item carries a scope tag, a principle-impact attestation, and a downstream landing. The target vision ([20260428.01-vision.v1.md](../../../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md)) had **no `principles:` block**; item **A0** bootstrapped it (2026-06-21) by declaring the vision's **eight existing design principles** (owner-confirmed). The `preserves:` ids below reference that declared block.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| A0 | Bootstrap the vision `principles:` block — declare the eight existing design principles (P0: `accuracy-over-everything`, `fix-broken-preserve-chosen`, `signal-dont-fix-pe`, `reader-risk-calibrated-autonomy`; P1: `freshness-as-heartbeat`, `series-before-articles`, `three-capabilities`, `cost-stratified-checks`) | `[vision-only: no-downstream]` | declares: the eight ids (bootstrap; no version bump) | `landing: vision-only` |
| A1 | Realign the vision to PE engine **v15** (replace "PE v7"; map onto the eight-parameter surface, plan-then-execute, processing-state, changelog discipline) | `[in-scope: original]` | preserves: `signal-dont-fix-pe` | `landing:` vision (resolves G6) |
| A2 | Add the **domain-config declaration** (dimensions, per-domain sources, SLA, freshness formula, `domain_profile` bindings) | `[in-scope: original]` | preserves: `accuracy-over-everything`, `cost-stratified-checks` | `landing:` vision (resolves G6, G4) |
| A3 | Add the **quality-feedback contract** (article-validation outcomes → PE engine) | `[in-scope: original]` | preserves: `signal-dont-fix-pe` | `landing:` vision + [05.05-practical-effectiveness-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md) (resolves G5) |
| B1 | Specify **one** article-maintenance orchestrator agent (Detect→Assess→Propose→Execute) | `[in-scope: original]` | preserves: `reader-risk-calibrated-autonomy`, `three-capabilities` | `landing:` `.github/agents/01.00-article-writing/` (resolves G1) |
| B2 | Specify **per-dimension skills** (link-check, freshness, readability, fact-verify, series-integrity) | `[in-scope: original]` | preserves: `cost-stratified-checks`, `three-capabilities` | `landing:` `.github/skills/` (resolves G3) |
| B3 | Endorse inherited article identity; verify `inputs_hash` freshness before acting | `[in-scope: original]` | preserves: `accuracy-over-everything` | `landing:` orchestrator contract + vision (consumes plan 04) |
| C1 | Specify the **freshness-collection contract** (signal collection against the formula) | `[in-scope: original]` | preserves: `freshness-as-heartbeat`, `cost-stratified-checks` | `landing:` orchestrator + IQPilot MCP (→ plan 03) (resolves G2) |
| C2 | Define the mechanically re-verifiable **claim→source** binding | `[in-scope: original]` | preserves: `accuracy-over-everything` | `landing:` vision + [02-validation-criteria.md](../../../../../.copilot/context/01.00-article-writing/02-validation-criteria.md) (resolves G8) |
| D1 | Add **iteration-budget + SLA** enforcement to the orchestrator contract | `[in-scope: original]` | preserves: `reader-risk-calibrated-autonomy` | `landing:` vision + orchestrator agent (resolves G7) |

No `[scope-expansion]` rows in the active list; surfaced expansions live in § Park lot. No P0/P1 *touches* — all amendments are additive to the declared principle set, so no consent lines are required.

## 🧭 Standalone scope vs. integrated role

- **Own goal (primary):** define and operate the quality standard + maintenance system for *any* published documentation (articles, series, docs), independent of where the content comes from.
- **Building-block consumption:** article-writing *consumes* the PE engine (it is maintained by it) and SHOULD consume **per-domain profiles** (the `domain_profile:` section per plan 01 G2) for domain-expert grounding. Article identity metadata is inherited from folder `_metadata.yml` per [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md), reducing per-article redundancy. It *provides* the domain config (dimensions, sources, SLA, freshness formula) that instantiates the engine for the documentation domain.
- **Integrated role (secondary):** it keeps Learning Hub articles current — one consumer among many, requiring no Hub-specific coupling.

## 🔎 Gap analysis (vs. own goal, with integrated lens) (✅ done)

| # | Gap | Why it matters to the OWN goal | Integrated lens |
|---|------|-------------------------------|-----------------|
| G1 | **No autonomous maintenance orchestrator.** The vision describes Detect→Assess→Propose→Execute but `.github/agents/` has zero article-maintenance agents. | The system exists only as a standard; the maintenance cycle is unrunnable. | The Hub's content-freshness story depends on this orchestrator. |
| G2 | **Freshness scoring defined but not automated.** The 5-signal model lives in [02-validation-criteria.md](../../../../../.copilot/context/01.00-article-writing/02-validation-criteria.md); nothing collects the signals. | The primary detection signal is inert. | — |
| G3 | **No per-dimension skill isolation.** The vision prescribes cost-stratified per-dimension processing (link-check, freshness, readability, fact-check); only ~3 context files exist, no skills. | Cost-stratification is a principle with no capability structure. | — |
| G4 | **No domain-expert grounding / role-switch.** Research/validation/building capabilities are not specialized by the article's technical domain. | An article on Kubernetes vs. Copilot SDK needs different domain grounding; the vision can't express it. | Should consume per-domain profiles (the `domain_profile:` section, plan 01 G2). |
| G5 | **No quality-feedback loop to the PE engine.** The vision wants to signal PE from article outcomes; undesigned. | The writing artifacts cannot learn from their measured effectiveness. | Closes the loop the integrated system needs. |
| G6 | **Reuse seam onto the PE engine is informal and stale.** The vision "inherits PE v7 patterns" in prose while PE is at v15 (eight-parameter surface, plan-then-execute, processing-state model, domain-coherent batching, changelog discipline). | The building block it depends on has moved; inherited prose drifts. | This is the explicit building-block contract the owner wants. |
| G7 | **No iteration-budget / SLA enforcement.** 10-changes/cycle and P0–P4 SLA tiers are defined but nothing enforces them. | Autonomous maintenance could cascade unchecked. | — |
| G8 | **Claim-to-source binding not mechanically re-verifiable.** `key_claims` + `docs_url` exist but no enforced binding the maintenance loop can re-check. | Factual-staleness detection (a top reader-risk) is manual. | — |

## ⚙️ Workstreams

### A. Vision realignment + building-block contract — `20260428.01-vision.v1.md` (+ changelog) (✅ done)

> Applied as uncommitted edits (2026-06-21). Vision bumped 3.2.0 → **3.3.0**; changelog v3.3.0 cut. All amendments additive — no P0/P1 principle or `scope.covers` entry touched.

0. **Bootstrap the vision `principles:` block** — declared the eight existing design principles (P0: `accuracy-over-everything`, `fix-broken-preserve-chosen`, `signal-dont-fix-pe`, `reader-risk-calibrated-autonomy`; P1: `freshness-as-heartbeat`, `series-before-articles`, `three-capabilities`, `cost-stratified-checks`) with matching `**Priority: Pn**` lines on the body headings. Additive declaration (no version bump per `vision-frontmatter.instructions.md`). Landing: [20260428.01-vision.v1.md](../../../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md). (✅ done)
1. Realign the vision to the **current PE engine (v15)**: replaced "PE v7" references and repointed the stale `…v7.md` links to `20260531.01-vision.md`; added an "Instantiating the PE engine" subsection mapping article-writing onto the eight-parameter surface, plan-then-execute, processing-state model, and changelog discipline (resolves G6). Landing: same vision. (✅ done)
2. Add a **domain-config declaration**: the concrete object article-writing supplies to instantiate the portable engine (dimensions, per-domain sources, SLA, freshness formula, `domain_profile` bindings) (resolves G6, G4). Landing: same vision (same subsection). (✅ done)
3. Add a **quality-feedback contract** describing how article-validation outcomes signal the PE engine (resolves G5). Landing: same vision (§ Quality feedback loop) + [05.05-practical-effectiveness-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md). (✅ done — vision contract added; the reciprocal 05.05 cross-link is deferred with B/C/D)
4. Record changes in the vision changelog. (✅ done — v3.3.0 entry)

> **Deferred (owner, 2026-06-21):** Workstreams B–D below are out of scope for this execution pass — the owner scoped it to **vision improvements only**. They remain valid future work; the orchestrator, per-dimension skills, and freshness/claim-source/SLA contracts are **not** implemented here.

### B. Maintenance orchestrator + per-dimension skills (🟡 todo)

1. Specify **one article-maintenance orchestrator** agent (Detect→Assess→Propose→Execute over published content; split into multiple agents only if a later step proves a single agent insufficient) (resolves G1). Landing: a new agent under `.github/agents/01.00-article-writing/`. (🟡 todo)
2. Specify **per-dimension skills** (link-check, freshness scoring, readability, fact-verification, series-integrity) as isolated, cost-stratified capabilities (resolves G3). Landing: new skills under [.github/skills/](../../../../../.github/skills/). (🟡 todo)
3. **Endorse inherited article identity.** Articles consume the *effective* (inherited) identity from plan 04; the maintenance orchestrator MUST verify effective-metadata freshness (`inputs_hash`) before assessing or acting, treating any ancestor `_metadata.yml` change as an invalidation signal (consumes [04-folder-metadata-inheritance-update-plan.md](04-folder-metadata-inheritance-update-plan.md)). Landing: orchestrator contract + vision. (🟡 todo)

### C. Freshness + provenance automation (🟡 todo)

1. **Specify the freshness-collection contract** — how the orchestrator collects the defined freshness signals against the formula (the build is parked under § Park lot) (resolves G2). Landing: orchestrator contract + IQPilot MCP (cross-ref to plan 03). (🟡 todo)
2. Define a mechanically re-verifiable **claim → source** binding (resolves G8). Landing: vision + [02-validation-criteria.md](../../../../../.copilot/context/01.00-article-writing/02-validation-criteria.md). (🟡 todo)

### D. Governance (🟡 todo)

1. Add iteration-budget + SLA enforcement to the orchestrator contract (resolves G7). Landing: vision + orchestrator agent. (🟡 todo)

## 🧪 Actionability Gate (run before promoting to `actionable`)

- Clarity — every step names a concrete edit to a concrete file. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation (B1 = one orchestrator; C1 = spec, build parked). (✅ done)
- Scope discipline — items stay within "any documentation"; Hub specifics are excluded; no `[scope-expansion]` in the active list. (✅ done)
- Coverage promise — every gap maps to a goal-table landing (G1→B1, G2→C1, G3→B2, G4→A2, G5→A3, G6→A1, G7→D1, G8→C2). (✅ done)
- Dependency check — items that consume per-domain profiles (G4 via A2) are gated on plan 01 G2 (`domain_profile` convention, now defined). (✅ done)
- Principle impact — § Goal items table tags every item per `vision-amendment.instructions.md`; the candidate principle ids are **owner-confirmed (2026-06-21)** and are materialized by execution step A0. (✅ done)
- Owner sign-off on the PE-v15 realignment (G6), the feedback contract (G5), and the bootstrapped principle set (A0). (✅ done — Dario Airoldi, 2026-06-21)

## 🅿️ Park lot

- Implement the orchestrator and skills (engineering) → defer: spec is in scope; build is a separate effort.
- Author per-domain profiles consumed by A4 → → `01-self-updating-prompt-engineering-vision-update-plan.md` (`domain_profile` convention) then per-domain authoring.
- Multi-language / localization maintenance → defer: out of current vision scope.

## 🏁 Exit criteria

- Vision realigned to PE v15 with explicit domain-config + feedback contracts, owner-approved. (✅ done — v3.3.0, uncommitted)
- Orchestrator + per-dimension skills specified (implementation parked). (🟡 todo)
- Freshness automation + claim-source binding specified. (🟡 todo)
- Changelog updated. (🟡 todo)
