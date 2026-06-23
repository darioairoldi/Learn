---
title: "Article-writing vision update plan — adopt PE engine criteria and rationales"
author: "Dario Airoldi"
date: "2026-06-22"
status: in-progress
domain: "article-writing"
goal: "Amend the self-updating article-writing vision (20260428.01-vision.v1.md, v3.3.0) so it explicitly endorses the prompt-engineering (PE) engine criteria and rationales that transfer to article maintenance — Type A/Type B staleness framing, a canonical invocation surface (--scope/--dim/--deps/--start/--end with default-full), collection scope beyond series, multidimensional processing state, graded dimension verdicts, domain-expertise injection, metadata-guarded changes, source-trust/domain-coherent batching, and iteration-budget spillover emission — while preserving the article-specific quality layer (readability, understandability, logical connection)."
motivation: "Article maintenance faces the same drift, cost, usability, and autonomy problems the PE engine already solves, and the article-writing vision already declares itself an instantiation of that engine. The operational machinery (invocation surface, processing-state model, graded verdicts) was never adopted explicitly. Making the adoption explicit lets article maintenance inherit the PE engine's discipline instead of re-deriving it, without importing PE-only machinery that does not transfer."
rationales:
  - "The article-writing vision is already a consumer/instantiation of the PE engine, so most criteria are available by construction; this plan makes the relevant ones explicit"
  - "Type B (capability/logic) staleness is the primary reason technical articles go obsolete while passing every integrity check — the vision must name it"
  - "Vision changes are human-only; this plan is a draft proposal for owner approval"
companion_analysis: "overview.md"
---

# Article-writing vision update plan — adopt PE engine criteria and rationales

> Status: **in-progress** — vision-amendment plan backed by [overview.md](overview.md). **Executed** (Dario Airoldi, 2026-06-22): C1–C8 applied to the article-writing vision ([20260428.01-vision.v1.md](../../../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md) bumped **3.3.0 → 4.0.0**), the sibling changelog got a v4.0.0 entry, and the [invocation-surface appendix](../../../../../06.00-idea/self-updating-article-writing/20260428.03-vision-appendix-invocation-surface.md) was created. New P0 `domain-expertise-injection` + new P1 `predictable-invocation-surface` declared; `series-before-articles` broadened to collections. Orchestrator/coverage-store builds remain parked (§ Park lot). **Extended** (Dario Airoldi, 2026-06-23): C9 residual-gap closure applied — spillover-plan emission (C9a) + contract-vs-implementation note (C9b) + `domain-expertise-injection` P0 reaffirmation (C9c); vision bumped **4.0.0 → 4.1.0**, changelog v4.1.0 entry added. Uncommitted, pending owner review.

## 🎯 Goal

Make the article-writing vision explicitly endorse the PE engine criteria and rationales that transfer to article maintenance, so the article system inherits the engine's drift, cost, usability, and autonomy discipline rather than re-deriving it — while keeping readability, understandability, and logical connection first-class.

### Original trigger (verbatim)

> Article writing maintenance is subject to very similar problems that Are handled by self updating prompt engineering … understand how self updating article writing vision document could be updated to endore relevant criteria and rationales that are used for prompt engineering

### Goal items (scope-tagged + principle-impact-tagged)

This is a `*vision*plan*.md`, so per `vision-amendment.instructions.md` every item carries a scope tag, a principle-impact attestation, and a downstream landing. The article-writing vision **already declares a `principles:` block** (P0: `accuracy-over-everything`, `fix-broken-preserve-chosen`, `signal-dont-fix-pe`, `reader-risk-calibrated-autonomy`; P1: `freshness-as-heartbeat`, `series-before-articles`, `three-capabilities`, `cost-stratified-checks`) — so no bootstrap is needed; the items below tag against that set. The full criterion-by-criterion mapping lives in [overview.md](overview.md).

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| C1 | Re-frame the five degradation forces as **Type A (structural)** vs **Type B (capability/logic)** staleness | `[in-scope: original]` | preserves: `accuracy-over-everything` (additive framing) | vision § The problem → *How articles degrade* |
| C2 | Add a **usability/flexibility/predictability** triad + a canonical `--scope`/`--dim`/`--deps`/`--start`/`--end` invocation surface (default-full, resolved-breadth echo) | `[in-scope: original]` | **adds a new P1 principle** (`predictable-invocation-surface`) — changelog + justification; owner consent | vision body (new principle) + new companion appendix (parameter surface) |
| C3 | Generalize the collection unit **beyond series** (folder / subject / tag) | `[in-scope: original]` | **touches P1** `series-before-articles` (broaden, additive) — changelog + justification; owner consent | vision § goal + § assess |
| C4 | Adopt a **(article × dimension) coverage record + source ledger** (multidimensional processing state) | `[in-scope: original]` | preserves: `freshness-as-heartbeat` (adds state model) | vision § detect/assess + key definitions |
| C5 | Add a **graded dimension verdict** (`verified`/`pass-weak`/`partial`/`fail`) + evidence-following dimensions + dimension-rule self-containment | `[in-scope: original]` | preserves: `cost-stratified-checks` | vision § assess (finding classification) |
| C6 | Elevate **domain-expertise injection** to a principle | `[in-scope: original]` | **adds a new principle** (propose P1; owner may set P0) — consent | vision body (new principle) + rationale |
| C7 | Adopt **metadata-guarded changes** (pre/post guard) + runtime-grounding tie-in | `[in-scope: original]` | preserves: `fix-broken-preserve-chosen` | vision § execute + governance table |
| C8 | Wire **source-trust** (📘/📗/📒/📕) into verification + **domain-coherent batching** for multi-domain sweeps | `[in-scope: original]` | preserves: `accuracy-over-everything` | vision § detect/assess |
| C9a | Add an **iteration-budget spillover-plan emission** contract for article cycles | `[in-scope: original]` | preserves: `freshness-as-heartbeat`, `reader-risk-calibrated-autonomy` (inherited iteration-budget governance; no declared principle touched) | vision § Operational criteria (new subsection) + § Risks |
| C9b | Make the **contract-vs-implementation gap** explicit for the (article × dimension) coverage store | `[in-scope: original]` | preserves: `freshness-as-heartbeat` (clarification only) | vision § Operational criteria → Multidimensional processing state + § Park lot |
| C9c | Reaffirm **`domain-expertise-injection` at P0** (owner accepts the governance friction) | `[vision-only: no-downstream]` | preserves: `domain-expertise-injection` (reaffirmation; no change) | landing: vision-only |

No `[scope-expansion]` rows. **Principle touches:** C2 adds new P1 `predictable-invocation-surface`; C6 adds new **P0** `domain-expertise-injection`; C3 broadens P1 `series-before-articles`. Priorities are **owner-confirmed (2026-06-22)**. Per `vision-frontmatter.instructions.md`, the new P0 makes the execute a vision **major** bump (consent recorded here); the P1 additions/broadening carry changelog entries + justification. **C9 touches no declared principle** — C9a/C9b are additive operational criteria (minor bump, 4.0.0 → 4.1.0); C9c reaffirms P0 `domain-expertise-injection` without changing it (no bump from C9c). Owner reaffirmation of the P0 placement recorded (Dario Airoldi, 2026-06-23).

## 🧭 Standalone scope vs. integrated role

- **Own goal (primary):** keep published articles, series, and documentation verified, reliable, readable, understandable, and up to date — a broader remit than the PE artifacts the engine maintains.
- **Building-block consumption:** article-writing *consumes* the PE engine (the portable Detect → Assess → Propose → Execute core, the autonomy gradient, the parameter surface) and supplies a documentation **domain config**. This plan adopts more of that engine's surface explicitly.
- **Integrated role (secondary):** article-writing is itself a building block the Learning Hub consumes (see learning-hub plan 03, A1/D1). Strengthening this vision strengthens that consumer contract.

## 🔎 Gap analysis (vs. the PE engine, condensed from overview.md) (✅ done)

| # | Gap | PE concept it adopts | Article-writing status today |
|---|------|----------------------|------------------------------|
| A | Five degradation forces conflate structural and capability/logic drift | Type A vs Type B staleness | ⛔ absent — "factual staleness" ≈ Type B but unnamed |
| B | No invocation contract — same usability failure modes (cognitive overhead, silent re-interpretation, no intent→execution path) | usability/flexibility/predictability triad + 8-parameter surface + default-full | ⛔ absent |
| C | Collection unit limited to authored series | `--scope` (folder/subject/tag set) | 🟡 partial — series only |
| D | Single per-article freshness scalar | `processing-state-is-multidimensional` + `coverage-completeness-guarantee` | ⛔ absent |
| E | Severity rates findings, not coverage | `evidence-based` graded verdict + `active-dimensions-follow-evidence` + `dimension-rule-self-containment` | ⛔ absent |
| F | `domain_profile` grounding mentioned once, not a principle | `domain-expertise-injection` | 🟡 partial |
| G | Metadata contract exists, no pre/post guard | `metadata-guarded-changes` + `runtime-grounding` | 🟡 partial |
| H | Source citations not trust-weighted; multi-domain sweeps not split | `trust-calibrated-adoption` + `domain-coherent-batching` | 🟡 partial / latent |

## ⚙️ Workstreams

Each workstream lands in `20260428.01-vision.v1.md` unless noted; a companion appendix is created only for C2.

### A. Staleness framing (C1) (✅ done)

1. In § The problem → *How articles degrade*, group the five forces under **Type A (structural, deterministic, fail-closed)** — link rot, broken cross-references, metadata gaps — and **Type B (capability/logic, passes integrity yet reads wrong)** — factual staleness, coverage gaps, standards drift. State that Type B is the primary motivating concern and the reason freshness scoring is a *trigger*, not a verdict. Landing: vision § The problem. (✅ done)

### B. Invocation surface (C2) (✅ done)

1. Add a **usability/flexibility/predictability** subsection to § The goal mirroring the PE triad, with the three failure modes restated for articles. (✅ done)
2. Declare a new principle **`predictable-invocation-surface`** (priority pending owner) and a canonical parameter surface adapted to articles — `--scope` (article / series / folder / subject / tag), `--dim` (quality dimensions), `--deps` (cross-refs / series links / cited sources, with depth), `--start`/`--end` (time- or source-version-windowed research) — with **default-full** and a **resolved-scope echo** on every run. Landing: vision body (principle) + a new companion appendix `20260428.03-vision-appendix-invocation-surface.md` (created on execute; orchestrator build parked). (✅ done — appendix `20260428.03-vision-appendix-invocation-surface.md` created; orchestrator parked.)

### C. Collection scope (C3) (✅ done)

1. Generalize `series-before-articles` so the collection unit is **any related set** — series, folder, subject, or tag — and rename the series-structural gate to a **collection-structural gate** (orphan, scope overlap, navigation chain apply to any collection). Add the changelog entry + justification for the P1 broadening. Landing: vision § goal + § assess. (✅ done)

### D. Processing state (C4) (✅ done)

1. Replace the single per-article freshness scalar (as the unit of record) with a **(article × quality-dimension) coverage record** plus a **source ledger** (per cited source / monitored technology), so "readability current, facts stale" is expressible; add the **coverage-completeness guarantee** (a never-assessed dimension is always in the work set). Landing: vision § detect/assess + key definitions. (✅ done)

### E. Verdict model (C5) (✅ done)

1. Add a **graded dimension verdict** (`verified` / `pass-weak` / `partial` / `fail`), distinct from finding severity; add **active-dimensions-follow-evidence** (a dimension whose evidence was skipped reports *not assessed*, never a low-confidence pass) and **dimension-rule self-containment** (every readability/understandability rule is reachable from the dimension that owns it). Landing: vision § assess. (✅ done)

### F. Domain expertise (C6) (✅ done)

1. Elevate **domain-expertise injection** to a principle: before assessing an article whose technical domain has a `domain_profile`, adopt that domain's role and authoritative sources; degrade transparently (record `domain-profile=absent`) when none exists. Add the principle (priority pending owner) + a supporting rationale. Landing: vision body + § rationale. (✅ done — declared as **P0**; rationale `R-A10` added.)

### G. Metadata guards (C7) (✅ done)

1. Adopt the **pre-change guard** (block a maintenance edit that violates the article's declared `goal`/`scope`/`audience`) and **mandatory post-change reconciliation** (update article metadata to match its new state); reference `runtime-grounding`'s inherited-metadata staleness check against the folder-level `_metadata.yml` cascade (consumes the folder-metadata inheritance work). Landing: vision § execute + governance table. (✅ done — landed in the new § Adopting the PE engine's operational criteria.)

### H. Source trust + batching (C8) (✅ done)

1. Wire the repo's reference classification (📘 Official / 📗 Verified Community / 📒 Internal / 📕 Unverified) into the **fact-checking** and **freshness** dimensions as a source-trust input, and add **domain-coherent batching** so a multi-domain maintenance sweep proposes a per-domain split before running. Landing: vision § detect/assess. (✅ done)

### I. Spillover + substrate gap (C9) (✅ done)

1. **C9a** — add an **§ Iteration-budget spillover** subsection to the vision (§ Operational criteria): a cycle that exhausts its autonomous-change budget with validated findings remaining emits a spillover plan (trigger, article, dimension, graded verdict, severity) so the next cycle resumes without re-assessment; reference it from § Risks → Series maintenance cascade and the Shared-governance iteration-budget bullet, and have the resolved-scope echo report `spillover=<path|none>`. Landing: vision § Operational criteria + § Risks. (✅ done)
2. **C9b** — add a **Current substrate (migration tracked)** note to § Operational criteria → Multidimensional processing state: the (article × dimension) coverage record is a target contract; today's substrate is per-validation-type bottom metadata (MetadataWatcher); the store build is parked. Landing: vision § Operational criteria + § Park lot. (✅ done)
3. **C9c** — reaffirm `domain-expertise-injection` at P0 in the changelog + plan (owner accepts the governance friction); no vision-body principle change. Landing: vision-only. (✅ done)

## 🧪 Actionability Gate (run before promoting to `actionable`)

- Clarity — every item names a concrete edit to a concrete vision section. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation; C2 surface and C5 verdict model are specified, not open-ended. (✅ done)
- Scope discipline — items stay within article maintenance; PE-only machinery (N-1 blocks, instruction-minimization, tier-by-filename, the 35-dim catalog) is explicitly **not** imported (see overview § *What NOT to import*); no `[scope-expansion]`. (✅ done)
- Coverage promise — every gap maps to a workstream (A→C1, B→C2, C→C3, D→C4, E→C5, F→C6, G→C7, H→C8). (✅ done)
- Dependency check — C7's inherited-metadata tie-in references the folder-metadata inheritance work (learning-hub plan 04, done) as a *contract*, not a build; C2's orchestrator is a *spec*, build parked (and relates to plan 02's deferred orchestrator). (✅ done)
- Principle impact — the § Goal table tags every item; C2 and C6 add a principle, C3 broadens a P1. (✅ done — tagging complete)
- **Owner sign-off** — recorded (Dario Airoldi, 2026-06-22): `predictable-invocation-surface` = **P1**; `domain-expertise-injection` = **P0** (strongest Type-B defense); `series-before-articles` broadened to collections in place. The new P0 makes the execute bump a vision **major**. (✅ done)
- **C9 gate + sign-off** — recorded (Dario Airoldi, 2026-06-23): C9a/C9b/C9c re-ran the Actionability Gate (clarity, non-ambiguity, scope discipline, coverage promise, principle impact all pass); no declared principle touched, so C9 is an additive **minor** bump (4.0.0 → 4.1.0); P0 `domain-expertise-injection` reaffirmed. (✅ done)

## 🅿️ Park lot

- Build the article-maintenance **orchestrator** implementing `--scope`/`--dim`/`--deps`/`--start`/`--end` → defer: the surface/contract is in scope; the build is separate (and overlaps plan 02's deferred orchestrator).
- Author the **article `--dim` catalog** (the small dimension set) as a context artifact → defer: the PE engine maintains it; separate effort.
- Implement the **(article × dimension) coverage store** in IQPilot/MetadataWatcher → defer: contract in scope (C9b makes the migration from per-validation-type bottom metadata explicit); build separate.
- Author **`domain_profile` manifests** for article technical domains (azure, auth, …) → defer: consumes the PE `domain_profile` mechanism; per-domain authoring is separate.

## 🏁 Exit criteria

- Vision amended for C1, C4, C5, C7, C8 (all preserve existing principles), owner-approved. (✅ done)
- New principles `predictable-invocation-surface` (C2, **P1**) and `domain-expertise-injection` (C6, **P0**) declared, each with a changelog entry. (✅ done)
- `series-before-articles` broadened to collections (C3) with a changelog entry. (✅ done)
- Companion invocation-surface appendix created; orchestrator/store builds parked. (✅ done)
- Vision version bumped to the next **major** (new P0 `domain-expertise-injection`) and the sibling changelog updated. (✅ done — 3.3.0 → 4.0.0.)
- C9 residual-gap closure applied: spillover-plan emission contract (C9a) + (article × dimension) substrate-gap note (C9b) + `domain-expertise-injection` P0 reaffirmation (C9c); vision bumped **4.0.0 → 4.1.0** (additive minor), sibling changelog v4.1.0 entry added. (✅ done)
