---
title: "Adopting prompt-engineering criteria and rationales into the article-writing vision"
author: "Dario Airoldi"
date: "2026-06-22"
status: draft
domain: "article-writing"
goal: "Analyze the self-updating prompt-engineering (PE) vision and the self-updating article-writing vision side by side, identify which PE criteria and rationales already transfer, which transfer only partially, and which are missing — then propose how the article-writing vision could be amended to endorse the relevant PE machinery while keeping its article-specific quality layer (readability, understandability, logical connection)."
description: "Comparative analysis of the PE engine vision (v15.8.0) and the article-writing vision (v3.3.0), with a gap map and a proposed vision-amendment item set."
---

# Adopting prompt-engineering criteria and rationales into the article-writing vision

> Analysis only. Vision changes are human-only — this document proposes; it does not edit either vision.

> **Status (2026-06-23): executed.** The C1–C8 proposal below was applied to the vision in **v4.0.0** (2026-06-22); the two residual gaps surfaced after that execution — iteration-budget **spillover-plan emission** and the **(article × dimension) coverage-store contract-vs-implementation gap** — were closed as **C9** in **v4.1.0** (2026-06-23), and `domain-expertise-injection` was reaffirmed at **P0**. The "v3.3.0" column in the at-a-glance table is the pre-amendment baseline this analysis was written against. See [01-article-writing-vision-update-plan.md](01-article-writing-vision-update-plan.md).

> **Wave 2 (2026-06-23): executed (Path 1).** The second residual set — the PE engine's *operational* machinery that wave 1 left unported (complete the eight-parameter surface with `--mode`/`--source`/`--skip`/`--plan-file`; plan-then-execute as the single pivot; plan execution modes fresh/reconcile/trust; the model-routing seam; the named pipeline with per-phase `--skip`; the conversational pre-parser; the three review modes) — was applied as **C10–C16** in **v4.2.0** (2026-06-23) per [02-article-writing-vision-update-plan.md](02-article-writing-vision-update-plan.md). Owner resolved the fork against the [20260621.05 engine-extraction investigation](../20260621.05-self-updating-machinery-extraction/overview.md) in favor of **Path 1** (land in the article vision; re-homeable to a shared engine vision if extraction proceeds). Additive minor bump; the only declared-principle touch is broadening P1 `predictable-invocation-surface` to eight parameters.

## 🎯 Purpose

The article-writing vision already declares itself a **consumer and instantiation** of the portable PE engine (see its *Instantiating the PE engine* section). That framing means most of the PE engine's machinery is *available* to article maintenance by construction. The open question this analysis answers is narrower and sharper:

> Which PE **criteria** (cost discipline, invocation surface, processing-state model, graded verdicts) and **rationales** (the `kebab-case` design justifications) does the article-writing vision currently endorse, which does it endorse only implicitly, and which should it adopt explicitly — given that article maintenance faces the *same* drift, cost, usability, and autonomy problems?

The user's framing is correct: internal drift, ecosystem evolution, structural staleness, capability/logic (Type B) staleness, the cost challenge, and the usability/flexibility challenge all apply to articles, often more acutely than to PE artifacts. Articles also add a quality layer PE does not have — readability, understandability, logical connection — which the adoption must preserve, not flatten.

## 🧭 The two visions at a glance

| Axis | PE engine (`20260531.01-vision.md`, v15.8.0) | Article-writing (`20260428.01-vision.v1.md`, v3.3.0) |
|---|---|---|
| **What it maintains** | PE artifacts (instructions, context, agents, prompts, skills, templates, hooks) | Published articles, article series, documentation |
| **Core loop** | Detect → Assess → Propose → Execute | Detect → Assess → Propose → Execute (same four phases) |
| **Degradation model** | Platform drift, internal drift, ecosystem evolution → structural (Type A) + capability/logic (Type B) staleness | Five forces: factual staleness, link rot, series incoherence, coverage gaps, standards non-compliance |
| **Cost discipline** | Progressive depth: research → screening → deep; four-level cost gradient | Cost tiers: Tier 0 (deterministic) → Tier 1 (LLM-light) → Tier 2 (LLM-deep) |
| **Autonomy** | Risk-calibrated gradient (impact × confidence) | Reader-risk-calibrated gradient (impact on readers) |
| **Invocation surface** | Eight canonical parameters; default-full contract; conversational pre-parser; resolved-breadth echo | None — triggers and SLA tiers only; no parameter surface |
| **Scope unit** | Artifact, artifact-type, folder/file set, dependency traversal | Article, article series |
| **State model** | Two-axis processing state (source ledger × per-artifact-per-dimension coverage) | Per-article freshness score + validation outcomes (bottom YAML) |
| **Verdict model** | Graded: `verified` / `pass-weak` / `partial` / `fail` | Severity only: CRITICAL / HIGH / MEDIUM / LOW |
| **Portability** | Engine/integration seam; per-consumer config | Declares itself a consumer of the PE engine; supplies a documentation domain config |

The two are deliberately aligned at the top (same loop, same cost philosophy, same autonomy philosophy) and deliberately divergent in operational surface (PE has a rich invocation/state/verdict machinery the article-writing vision has not yet adopted).

## 🔍 What article-writing already inherits (so we don't re-adopt)

These PE concepts are **already endorsed** in the article-writing vision — the proposal must not duplicate them:

- **The four-phase loop** (Detect → Assess → Propose → Execute) — present and phase-for-phase aligned.
- **Cost stratification** — `cost-stratified-checks` (P1) and `R-A8` mirror PE's `progressive-depth`; the Tier 0/1/2 model is the article analog of research → screening → deep.
- **Per-dimension isolation** — `R-A9-dimension-isolation` mirrors PE's selective-dimension model.
- **Reader-risk autonomy gradient** — `reader-risk-calibrated-autonomy` (P0) is PE's `autonomy-gradient` specialized to reader impact.
- **Capability separation** — `three-capabilities` (P1) (research / validation / building) is the article analog of PE's model-routing + capability split.
- **Signal-don't-fix boundary** — `signal-dont-fix-pe` (P0) preserves PE's separation-of-concerns and the quality-feedback loop.
- **PE-engine instantiation + portability** — the *Instantiating the PE engine* section already consumes PE's `portable-by-design` and the engine/integration seam.
- **Inherited governance table** — `R-G1` (autonomy), `R-L2` (multi-pass), `R-P2` (decomposition), `R-S1` (metadata contracts), `R-G3` (progressive learning), loop stability, `R-P1` (deterministic-first), iteration budget are already cross-referenced.

## 🧩 Mapping — PE criteria and rationales → article-writing

Legend: ✅ already endorsed · 🟡 partial / implicit · ⛔ gap (candidate for adoption).

| PE concept / rationale | PE role | Article-writing status | How it maps to articles |
|---|---|---|---|
| **Detect → Assess → Propose → Execute** | Core loop | ✅ | Same four phases already defined |
| **`progressive-depth` / cost gradient** | Bound assessment cost | ✅ (`cost-stratified-checks`, `R-A8`) | Tier 0/1/2 = research → screening → deep |
| **`autonomy-gradient`** | Risk-calibrated action | ✅ (`reader-risk-calibrated-autonomy`) | Calibrated to reader impact |
| **`external-knowledge`** | Per-domain authoritative sources | 🟡 | Each article's technical-domain sources; partly in `R-A2` (verify before change) but not framed as a per-domain source map |
| **Type A vs Type B staleness** | Structural vs capability/logic drift | ⛔ | The five forces conflate the two; "factual staleness" ≈ Type B but the *structural-passes-yet-logic-obsolete* framing is absent and is exactly why articles "look fine but are wrong" |
| **Usability/flexibility/predictability triad** | Invocation must be learnable, flexible, predictable | ⛔ | Article maintenance has no invocation contract; the same three failure modes (cognitive overhead, silent re-interpretation, no intent→execution path) apply |
| **Eight canonical parameters / `minimal-canonical-surface`** | Small consistent input surface | ⛔ | `--scope`, `--dim`, `--deps`, `--start`/`--end` map directly to "which articles, which quality dimensions, follow cross-refs, time-window the source research" |
| **`default-full-investigation`** | Parameter-less = full review | ⛔ | A bare "review my articles" should mean *all articles, all dimensions, all sources* — not the cheapest path |
| **Resolved-breadth echo / predictability** | Log the resolved invocation | ⛔ | A maintenance run should state what it actually assessed (which articles × which dimensions × which window) |
| **`--scope` (artifact-type OR file/folder set)** | Target selection | 🟡 | Article-writing has "article" and "series" but not arbitrary collections (folder, subject, tag) |
| **`--deps` traversal** | Include dependents/dependencies | 🟡 | Articles have cross-refs, series links, and source citations; `chain-alignment` exists but no traversal-depth control |
| **`--start`/`--end` bounded-delta (date OR source-version)** | Time/version-windowed re-baseline | ⛔ | "Re-verify everything that depends on VS Code 1.100–1.110" or "re-check articles touched since date X" |
| **`processing-state-is-multidimensional`** | Source ledger × per-artifact-per-dimension coverage | ⛔ | Per-article freshness is one scalar; a `(article × dimension)` coverage record is the honest unit (readability current, facts stale) |
| **`coverage-completeness-guarantee`** | Never-covered units always in work set | ⛔ | A never-checked dimension on an article must never be skipped as "current" |
| **`evidence-based` graded verdict** | `verified`/`pass-weak`/`partial`/`fail` | ⛔ | Severity (CRITICAL…LOW) rates *findings*; a graded *coverage* verdict rates whether a dimension was actually evaluated — prevents a dimension going green on its easiest sub-check |
| **`active-dimensions-follow-evidence`** | Drop dims whose evidence was skipped | ⛔ | If source research is skipped, "factual accuracy" must report *not assessed*, not low-confidence-pass |
| **`dimension-rule-self-containment`** | Every rule reachable from its dimension | ⛔ | A readability rule housed in a style guide the readability check never loads = silent false-clean |
| **`domain-expertise-injection`** | Adopt target-domain role + `domain_profile` | 🟡 | Article-writing mentions `domain_profile` grounding in one table but does not elevate it to a principle; an Azure article should be assessed with Azure expertise |
| **`metadata-guarded-changes`** (pre/post guard) | Block changes that violate declared metadata; reconcile after | 🟡 | `R-S1`/bottom-YAML exists; the pre-change guard + mandatory post-change reconciliation framing is absent |
| **`runtime-grounding`** | Enforce metadata at execution; inherited-metadata staleness check | 🟡 | Relevant once folder-level `_metadata.yml` inheritance lands (see learning-hub plan 04) |
| **`structural-separation` (N-1)** | Rule/Rationale/Example → deterministic diff classification | 🟡 (analog) | Articles aren't rule-bearing; the analog is separating *verifiable factual claims* from *editorial prose* — already the spirit of `fix-broken-preserve-chosen` |
| **`trust-calibrated-adoption`** | Trust registry for external sources | 🟡 | Articles cite external sources; a source-trust signal would strengthen fact-checking and reference classification (📘/📗/📒/📕 already exists in the repo) |
| **`loop-stability` (convergence/oscillation)** | Maintenance converges | ✅ (inherited) | Already cross-referenced |
| **`iteration-budget` + spillover** | Bound autonomous changes; emit spillover plan | 🟡 | Iteration budget is inherited; the *spillover-plan emission* contract is not stated for articles |
| **`domain-coherent-batching`** | Don't mix domains in one review | ⛔ (latent) | A cross-folder maintenance run spanning Azure + auth + markdown articles has the same reviewer-granularity problem |
| **`progressive-learning`** | Outcome log tunes thresholds | ✅ (`R-G3` + quality-feedback) | Already present, and feeds the PE engine |

## 🕳️ Gaps worth adopting (grouped)

The ⛔ and 🟡 rows above cluster into eight coherent adoption groups.

### A. Type A / Type B staleness framing

Re-cast the five degradation forces under the **structural (Type A)** vs **capability/logic (Type B)** distinction the PE vision makes its *primary motivating concern*. Link rot and broken cross-references are Type A (deterministic, fail-closed). Factual staleness, coverage gaps, and standards drift are Type B (pass every integrity check yet read wrong). This sharpens *why* deterministic checks are insufficient and why freshness scoring is a trigger, not a verdict.

### B. Usability, flexibility, and predictability — an invocation contract for articles

Adopt the PE triad and a **canonical parameter surface adapted to articles**, with `default-full` and resolved-breadth echo:

- `--scope` — a single article, a series, a folder, a subject, or a tag set.
- `--dim` — which quality dimensions to assess (verified, reliable, readable, understandable, up-to-date, plus series dimensions).
- `--deps` — follow cross-references / series links / cited sources to a chosen depth.
- `--start`/`--end` — time- or version-window the source research (the user's `--from --to`).

A bare "review my articles" resolves to **full** (all articles, all dimensions, all sources); the run reports the resolved scope first. This directly answers the user's "is there also for articles handling" — it is, and it is currently unaddressed.

### C. Collection scope beyond the series

Generalize `series-before-articles` so the collection unit is **any related set** — series, folder, subject, or tag — not only an authored series. The series-structural gate (orphan, scope overlap, navigation chain) becomes a *collection*-structural gate.

### D. Multidimensional processing state + coverage completeness

Replace (or augment) the single per-article freshness scalar with a **`(article × quality-dimension)` coverage record** plus a **source ledger** (per cited source / per monitored technology). This makes "readability is current but factual accuracy is stale" expressible, and guarantees a never-assessed dimension is always in the work set.

### E. Graded dimension verdict + evidence-following dimensions

Add the **`verified` / `pass-weak` / `partial` / `fail`** graded verdict *per dimension* (distinct from finding severity), and the rule that a dimension whose evidence pipeline was skipped reports **not assessed**, never a low-confidence pass. Add **dimension-rule-self-containment** so every readability/understandability rule is reachable from the dimension that owns it.

### F. Domain-expertise injection for articles

Elevate `domain_profile` grounding to a principle: before assessing an article whose technical domain has a profile, **adopt that domain's role and authoritative sources**. An Azure article assessed only through a writing lens caps at "well-written but technically naive." This is the single highest-leverage Type-B defense for technical articles.

### G. Metadata-guarded changes + runtime grounding

Adopt the **pre-change guard** (block a maintenance edit that violates the article's declared `goal`/`scope`/`audience`) and **mandatory post-change reconciliation** (update the article's metadata to match its new state). Tie `runtime-grounding`'s inherited-metadata staleness check to the folder-level `_metadata.yml` inheritance work already planned for the Learning Hub.

### H. Source-trust signal + domain-coherent batching

Borrow `trust-calibrated-adoption` as a **source-trust input** to fact-checking (the repo already classifies references 📘/📗/📒/📕 — wire that into the freshness/verification dimensions), and adopt `domain-coherent-batching` so a multi-domain maintenance sweep proposes a per-domain split before running.

## ✍️ The article-specific layer PE does not have

The adoption must **add to**, not replace, the dimensions that have no PE equivalent. These stay first-class and gain the graded-verdict + cost-tier treatment from group E:

- **Readability** — quantitative targets (Flesch, sentence length, active-voice ratio).
- **Understandability** — audience calibration, jargon explanation, table introductions, progressive complexity.
- **Logical connection** — logical flow, prerequisite ordering, progressive disclosure, series progression coherence.

PE's `guidance-quality` six-property model (clarity, non-redundancy, non-contradiction, completeness, prioritization, actionability) is a *useful structural analog* but is about rule quality, not prose quality — so it informs the framing without replacing the reader-facing dimensions.

## 🛠️ Proposed update approach

Because both visions are **human-only**, the change should run through the established **vision-amendment plan** workflow (as plans 01–03 did), not a direct edit. A companion plan (e.g. `01-article-writing-vision-update-plan.md` in this folder) would:

1. Rename to a `*vision*plan*.md` so `vision-amendment.instructions.md` applies.
2. Carry a § Goal item table, each row tagged with the article-writing principle it **preserves** or **touches**, against the vision's declared `principles:` block.
3. Land each item in the article-writing vision (`20260428.01-vision.v1.md`) and, where an operational surface is added, in a companion appendix.

Candidate amendment items (pre-tagged for the eventual plan):

| # | Candidate item | Group | Principle impact (article-writing) |
|---|---|---|---|
| C1 | Re-frame the five degradation forces as Type A / Type B staleness | A | preserves `accuracy-over-everything`; touches the degradation model (additive) |
| C2 | Add a usability/flexibility/predictability triad + canonical `--scope`/`--dim`/`--deps`/`--start`/`--end` surface with default-full + resolved-breadth echo | B | new operational principle; preserves `cost-stratified-checks` |
| C3 | Generalize the collection unit beyond series (folder / subject / tag) | C | touches `series-before-articles` (broaden, additive) |
| C4 | Adopt a `(article × dimension)` coverage record + source ledger | D | preserves `freshness-as-heartbeat`; adds multidimensional state |
| C5 | Add graded dimension verdict + evidence-following dimensions + dimension-rule self-containment | E | preserves `cost-stratified-checks`; sharpens assessment honesty |
| C6 | Elevate domain-expertise injection to a principle | F | preserves `accuracy-over-everything` (strong Type-B defense) |
| C7 | Adopt metadata-guarded changes (pre/post guard) + runtime grounding tie-in | G | preserves `fix-broken-preserve-chosen` |
| C8 | Wire source-trust (📘/📗/📒/📕) into verification + domain-coherent batching for multi-domain sweeps | H | preserves `accuracy-over-everything` |

None of C1–C8 removes or weakens an existing P0/P1 principle, so (pending owner confirmation) they are additive amendments rather than principle touches that would force a vision version bump beyond the additive minor.

## ⚠️ What NOT to import

Some PE machinery is PE-specific and should be left behind to avoid over-engineering the article vision:

- **N-1 structural separation (Rule/Rationale/Example blocks)** — articles are prose, not rule-bearing artifacts; import only its *spirit* (separate verifiable claims from editorial prose, already covered by `fix-broken-preserve-chosen`).
- **`instruction-minimization`** — about PE instruction-file collisions; no article analog.
- **`tier-blast-radius` by filename prefix** — PE's tier convention does not map to article importance; article "blast radius" is reader traffic/visibility (`R-A1`), which the vision already uses.
- **The full 35-dimension `--dim` catalog** — articles need their own (small) dimension catalog, not the PE one.

## 📚 References

- **[Self-updating prompt engineering vision (v15)](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)** 📒 Internal — source of the criteria and rationales analyzed here.
- **[Self-updating article writing vision (v3.3)](../../../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md)** 📒 Internal — the vision proposed for amendment.
- **[Vision-amendment authoring rules](../../../../../.github/instructions/vision-amendment.instructions.md)** 📘 Internal — discipline the companion plan must follow.
- **[Vision-frontmatter schema](../../../../../.github/instructions/vision-frontmatter.instructions.md)** 📘 Internal — `principles:` block the amendment items tag against.
