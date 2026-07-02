---
title: "Article-writing vision update plan (wave 2) — adopt PE operational machinery"
author: "Dario Airoldi"
date: "2026-06-23"
status: in-progress
domain: "article-writing"
goal: "Amend the self-updating article-writing vision (20260428.01-vision.v1.md, v4.1.0) so it explicitly endorses the prompt-engineering (PE) engine's OPERATIONAL machinery that wave 1 (C1–C9) did not adopt — completing the canonical parameter surface (--mode/--source/--skip/--plan-file), plan-then-execute as the single pivot, plan execution modes (fresh/reconcile/trust), the model-routing seam, the named pipeline with per-phase --skip, the conversational pre-parser, and the three review modes — while keeping these as additive operational criteria that touch no P0 principle and preserve the article-specific quality layer."
motivation: "Wave 1 (C1–C9) adopted the PE engine's quality, cost, and state criteria but left the engine's later invocation/execution surface unported. The owner confirmed (2026-06-23) that the residual operational items are also relevant to article maintenance. This plan makes them explicit so article maintenance inherits the engine's execution discipline (reviewable plans, reconcile-on-rerun, cheap-model execution, named skippable phases, free-form intent resolution, three review modes) instead of re-deriving it — without importing PE-only machinery (command families framing beyond --mode, N-1 blocks, the 35-dim catalog)."
rationales:
  - "All wave-2 items are engine-generic — they are the same operational machinery the 20260621.05 extraction investigation proposes to move into a shared self-updating-engine vision; this plan flags that fork rather than pre-deciding it"
  - "None of the items touches a P0 principle; the only declared-principle touch is broadening the P1 predictable-invocation-surface from four to eight parameters (additive)"
  - "Vision changes are human-only; owner approved Path 1 and the additive minor bump (2026-06-23), so this plan executed C10–C16 into the vision and appendix"
companion_analysis: "overview.md"
predecessor_plan: "01-article-writing-vision-update-plan.md"
---

# Article-writing vision update plan (wave 2) — adopt PE operational machinery

> Status: **in-progress (executed)** — wave-2 vision-amendment plan, backed by [overview.md](overview.md) and continuing [01-article-writing-vision-update-plan.md](01-article-writing-vision-update-plan.md) (C1–C9). **Executed** (Dario Airoldi, 2026-06-23): owner resolved the fork in favor of **Path 1** and confirmed `--mode` default `apply`; C10–C16 were applied to the vision ([20260428.01-vision.v1.md](../../../../../06.00-idea/self-updating-article-writing/20260428.01-vision.v1.md) bumped **4.1.0 → 4.2.0**), the [invocation-surface appendix](../../../../../06.00-idea/self-updating-article-writing/20260428.03-vision-appendix-invocation-surface.md) was extended to eight parameters + named pipeline + pre-parser, and the sibling changelog got a v4.2.0 entry. All builds remain parked (§ Park lot).

## ⚠️ Fork flag (read before promoting)

Every item in this plan (C10–C16) is **engine-generic** — none is article-specific. The open investigation [20260621.05-self-updating-machinery-extraction/overview.md](../20260621.05-self-updating-machinery-extraction/overview.md) recommends extracting exactly this kind of machinery into a shared `self-updating-engine` vision that article-writing would *reference*, not absorb. Two mutually-exclusive landings exist:

- **Path 1 (this plan):** land C10–C16 in the article-writing vision now. Fastest; increases coupling/duplication the extraction would later have to undo.
- **Path 2 (extraction-first):** author C10–C16 into the new engine vision; article-writing inherits them by reference. Slower to start; no rework.

This plan is written for **Path 1** but every landing is re-homeable to the engine vision unchanged. **Fork resolved (Dario Airoldi, 2026-06-23): Path 1** — C10–C16 landed in the article-writing vision. If the [20260621.05](../20260621.05-self-updating-machinery-extraction/overview.md) extraction proceeds later, these engine-generic items move to the engine vision and article-writing references them.

## 🎯 Goal

Make the article-writing vision explicitly endorse the PE engine's operational machinery that wave 1 left unported, as additive operational criteria, so article maintenance gains reviewable plans, reconcile-on-rerun, cheap-model execution, named skippable phases, free-form intent resolution, and three review modes — while keeping readability, understandability, and logical connection first-class and touching no P0 principle.

### Original trigger (verbatim)

> **Eight canonical parameters** Has 5 probably all `--mode`, `--source`, `--skip`, `--plan-file`
> **Plan-then-execute as the single pivot** (Plan output contract) Only emits a plan on iteration-budget *overflow* (C9 spillover) Every mutating maintenance run writes a reviewable plan file, not just on overflow
> **Plan execution modes** (fresh / reconcile / trust) + reconcile semantics Absent Re-running maintenance on an evolving article set should reuse prior human decisions, not re-litigate them (convergence)
> **Model-routing seam** (reasoning model plans, cheap model executes) Absent (has capability split, not model-pinned-to-phase) Fact-verification/assessment on a reasoning model; applying a verified, anchored edit on a cheaper model
> **Eight-phase pipeline + per-phase `--skip`** Has Tier 0/1/2 but no named skippable phases Lets a run skip e.g. source research while still running structural+readability tiers
> **Conversational pre-parser (Phase 0a)** Absent — surface is parameter-only "review the Azure articles touched since 1.100 for factual drift" → resolved canonical invocation, echoed back
> **Three review modes** (individual / dependency-aware / guidance-first) Has the quality-feedback-to-PE loop (≈ guidance-first) but not the three modes formalized individual article · article+its-collection · "audit which articles violate this standard"
> all these could be interesting for article writing too

### Goal items (scope-tagged + principle-impact-tagged)

This is a `*vision*plan*.md`, so per `vision-amendment.instructions.md` every item carries a scope tag, a principle-impact attestation against the vision's declared `principles:` block (P0: `accuracy-over-everything`, `fix-broken-preserve-chosen`, `signal-dont-fix-pe`, `reader-risk-calibrated-autonomy`, `domain-expertise-injection`; P1: `freshness-as-heartbeat`, `series-before-articles`, `three-capabilities`, `cost-stratified-checks`, `predictable-invocation-surface`), and a downstream landing.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| C10 | Complete the canonical parameter surface: add `--mode` (plan\|apply), `--source` (which monitored source feed), `--skip` (drop a phase), `--plan-file` (where the plan lands) — four → eight | `[in-scope: original]` | touches: `predictable-invocation-surface` (P1 justification: broadens the canonical surface from four to eight parameters; default-full and the resolved-scope echo are preserved and extended to the new parameters); preserves: `cost-stratified-checks`, `reader-risk-calibrated-autonomy` | landing: `06.00-idea/self-updating-article-writing/20260428.03-vision-appendix-invocation-surface.md` + vision principle `predictable-invocation-surface` |
| C11 | Plan-then-execute as the single pivot (Plan output contract): every mutating run writes a reviewable plan file, not only on overflow; `plan = apply − execute`, `apply = plan + execute`, one execution engine | `[in-scope: original]` | preserves: `reader-risk-calibrated-autonomy` (human handoff on every mutating run), `fix-broken-preserve-chosen` | landing: vision § Operational criteria (new *Plan output contract* subsection) + § Risks |
| C12 | Plan execution modes (fresh / reconcile / trust) + reconcile semantics: a re-run reuses prior human editorial decisions (park-lot rulings, "editorial — do not modify" marks) and escalates contradictions instead of overwriting | `[in-scope: original]` | preserves: `fix-broken-preserve-chosen` (preserve deliberate editorial choices across re-runs); supports loop-stability (convergence) | landing: vision § Operational criteria (*Plan execution modes*) |
| C13 | Model-routing seam: pin the reasoning→standard boundary to the plan→execute boundary — research/validation (assess, verify facts) on a reasoning model; building (apply anchored edits) on a cheaper model | `[in-scope: original]` | preserves: `three-capabilities` (makes the research/validation-vs-building split model-explicit), `accuracy-over-everything` (fact verification stays on the reasoning model) | landing: vision § Operational criteria (*Model-routing seam*) + § Execute |
| C14 | Named pipeline + per-phase `--skip`: name the phases (inventory → pre-parser → collection/domain-coherence → research → collection pass → structural tier → readability/understandability tier → factual/up-to-date tier → approval → apply → regression → report); make Tier 0/1/2 the named content phases; allow `--skip` of a phase; inventory, pre-parser, domain-coherence, and report are never skippable | `[in-scope: original]` | touches: `predictable-invocation-surface` (P1 justification: specifies the phase list that the new `--skip` parameter from C10 operates on); preserves: `cost-stratified-checks` (tiers become named, individually-skippable phases), `freshness-as-heartbeat` | landing: `06.00-idea/self-updating-article-writing/20260428.03-vision-appendix-invocation-surface.md` + vision § Assess |
| C15 | Conversational pre-parser (Phase 0a): resolve free-form intent ("review the Azure articles touched since 1.100 for factual drift") into the canonical surface, echo the resolved invocation before execution; never silently invent scope | `[in-scope: original]` | preserves: `predictable-invocation-surface` (the pre-parser is the front door that resolves intent to the canonical surface; default-full and resolved-scope echo are preserved) | landing: `06.00-idea/self-updating-article-writing/20260428.03-vision-appendix-invocation-surface.md` + vision body |
| C16 | Three review modes: **individual** (one article) · **collection-aware** (article + its collection, the dependency-aware analog) · **standards-audit** (which articles violate a given standard — the article analog of guidance-first) | `[in-scope: original]` | preserves: `series-before-articles` (collection-aware mode), `cost-stratified-checks`, `signal-dont-fix-pe` (standards-audit feeds the quality-feedback loop) | landing: vision § Assess (*Review modes*) |

No `[scope-expansion]` rows. **Principle touches:** C10 and C14 broaden P1 `predictable-invocation-surface` (additive — inline justifications above); no P0 is touched, so no new P0 consent line is required and the execute is an additive **minor** bump (4.1.0 → 4.2.0), pending owner confirmation. No new principle is declared — C11/C12/C13/C16 land as additive operational criteria/mechanisms, matching how PE treats them (P1/P2 mechanisms, not P0 invariants).

## 🔎 Gap analysis (condensed) (✅ done)

| # | Item | PE concept it adopts | Article-writing status today (v4.1.0) |
|---|------|----------------------|---------------------------------------|
| C10 | Complete the parameter surface | eight canonical parameters / `minimal-canonical-surface` | 🟡 partial — has 4 (`--scope`/`--dim`/`--deps`/`--start`/`--end`); missing `--mode`, `--source`, `--skip`, `--plan-file` |
| C11 | Plan-then-execute single pivot | Plan output contract | 🟡 partial — emits a plan only on iteration-budget *overflow* (C9a spillover) |
| C12 | Plan execution modes + reconcile | fresh / reconcile / trust | ⛔ absent — re-runs re-litigate instead of reconciling |
| C13 | Model-routing seam | reasoning-plans / cheap-executes boundary | ⛔ absent — has `three-capabilities` split, not model-pinned-to-phase |
| C14 | Named pipeline + `--skip` | eight-phase pipeline + per-phase skip | 🟡 partial — has Tier 0/1/2 but no named skippable phases |
| C15 | Conversational pre-parser | Phase 0a | ⛔ absent — surface is parameter-only |
| C16 | Three review modes | individual / dependency-aware / guidance-first | 🟡 partial — quality-feedback loop ≈ guidance-first, not the three modes formalized |

## ⚙️ Workstreams

Each workstream lands in `20260428.01-vision.v1.md` and/or the invocation-surface appendix `20260428.03-vision-appendix-invocation-surface.md`. All builds (orchestrator, model routing, coverage store) stay parked — these items add **contract**, not implementation.

### J. Parameter surface completion (C10) (✅ done)

1. In the invocation-surface appendix, extend the parameter table from four to eight: add `--mode plan|apply` (preview vs apply, default `apply` for maintenance runs), `--source <feed|all>` (which monitored source/technology feed to research, complementing `--start`/`--end` which only *windows* it), `--skip <phase[,…]>` (drop named phases — see C14), `--plan-file <path>` (plan location/identity only; never decides regenerate-vs-trust). Keep default-full and the resolved-scope echo, extended to the new parameters. (✅ done)
2. In the vision, broaden the `predictable-invocation-surface` principle text to cite the eight-parameter surface and add a changelog entry + the P1 justification. (✅ done)

### K. Plan output contract (C11) (✅ done)

1. Add a *Plan output contract* subsection to § Operational criteria: every mutating maintenance run (every `--mode apply`, every explicit `--mode plan`) writes one reviewable plan file at a canonical path conforming to `plan-execution.instructions.md`; `plan = apply − execute`, `apply = plan + execute`, one shared execution engine. Require execution-ready precision (each actionable row carries a literal `old → new` edit or an unambiguous file+section anchor) so a cheaper executor (C13) applies without re-derivation. Generalize C9a so spillover is the *budget-overflow* case of the same plan artifact. Echo `plan-file=<path>` in the resolved-scope first line. (✅ done)

### L. Plan execution modes (C12) (✅ done)

1. Add a *Plan execution modes* subsection: **fresh** (no baseline + research → generate, write, execute), **reconcile** (baseline + research → merge fresh evidence, preserve human-authored park-lot rulings / "editorial — do not modify" marks, escalate contradictions instead of overwriting, re-verify, overwrite, execute), **trust** (baseline + no research → execute as-is, with a target-section drift guard). State that reconcile is what makes repeated maintenance on an evolving article set converge (loop stability) rather than thrash. (✅ done)

### M. Model-routing seam (C13) (✅ done)

1. Add a *Model-routing seam* subsection to § Operational criteria / § Execute: pin the reasoning→standard boundary to the plan→execute boundary — the research and validation capabilities (assessment, fact verification) run on a reasoning model; the building capability (applying validated, anchored edits) runs on a cheaper model. Note the precondition: execution-ready precision from C11 (anchored edits) + the cross-run drift guard from C12 (trust mode). Frame this as refining `three-capabilities`, not a new principle. (✅ done)

### N. Named pipeline + `--skip` (C14) (✅ done)

1. In the invocation-surface appendix, name the article-maintenance phases and their `--skip` semantics: inventory · pre-parser · collection/domain-coherence · research · collection pass · structural tier (T0) · readability/understandability tier (T1) · factual/up-to-date tier (T2) · approval · apply · regression · report. Mark inventory, pre-parser, domain-coherence, and report as **never skippable**; `--skip research` requires a fresh cached source ledger or fails closed; `--skip approval` is forbidden for content-altering changes. Tie skipped phases to `active-dimensions-follow-evidence` (a skipped phase drops its dependent dimensions, reported as *not assessed*). (✅ done)

### O. Conversational pre-parser (C15) (✅ done)

1. Add a Phase 0a description (appendix + vision body): free-form operator intent is normalized into the canonical surface, the resolved invocation is echoed before execution, a single clarification round is allowed, and scope is never silently invented. Default-full applies when intent is ambiguous. (✅ done)

### P. Review modes (C16) (✅ done)

1. Add a *Review modes* subsection to § Assess: **individual** (assess one article in isolation), **collection-aware** (assess an article together with its collection — the dependency-aware analog, runs the collection-structural gate), **standards-audit** (given a standard, enumerate which articles violate it — the article analog of guidance-first; feeds the quality-feedback-to-PE loop via `signal-dont-fix-pe`). Map each mode to a `--deps` depth and a default `--dim` set. (✅ done)

## 🧪 Actionability Gate (run before promoting to `actionable`)

- Clarity — every item names a concrete edit to a concrete vision/appendix section. (✅ done)
- Non-ambiguity — each item has one reasonable interpretation; the parameter set (C10), mode set (C12), and phase list (C14) are enumerated, not open-ended. (✅ done)
- Scope discipline — items stay within article-maintenance operational machinery; PE-only framing (command families beyond `--mode`, N-1 blocks, the 35-dim catalog, instruction-minimization) is **not** imported; no `[scope-expansion]` row. (✅ done)
- Coverage promise — every item names a downstream landing (appendix and/or vision section) that resolves. (✅ done)
- Principle impact — the § Goal table tags every item; C10 and C14 carry the P1 `predictable-invocation-surface` justification; no P0 touched. (✅ done)
- **Fork resolution** — owner chose **Path 1** (land in the article vision); re-homeable to the engine vision if 20260621.05 proceeds. (✅ done)
- **Owner sign-off** — recorded (Dario Airoldi, 2026-06-23): `--mode` default = `apply`; additive **minor** bump 4.1.0 → 4.2.0; no new principle declared. (✅ done)

## 🅿️ Park lot

- **Create/review parity contract** (article creation from research ↔ article maintenance share one quality target) → defer: the user did not request it in this wave, and article *creation* lives in the sibling research vision; revisit once the engine fork is resolved.
- **Command-families framing** (Creation / Review / Guidance-first / Scheduled with mutation posture) beyond the `--mode` parameter → defer: heavier conceptual import; `--mode` (C10) covers the immediate need.
- **Re-home C10–C16 into the `self-updating-engine` vision** if Path 2 is chosen → `→ 20260621.05-self-updating-machinery-extraction` (becomes that workstream's content, not an article-vision edit).
- **Build the article-maintenance orchestrator** implementing the eight-parameter surface, the named pipeline, plan modes, and the model-routing seam → defer: contract is in scope here; the build is separate (overlaps the wave-1 parked orchestrator).
- **Author the article `--dim` catalog** as a context artifact → defer: separate effort, unchanged from wave 1.

## 🏁 Exit criteria

- Fork resolved by owner — **Path 1** (land in the article vision). (✅ done)
- If Path 1: vision amended for C11, C12, C13, C16 (additive operational criteria) and the invocation-surface appendix extended for C10, C14, C15, owner-approved. (✅ done)
- `predictable-invocation-surface` (P1) broadened to the eight-parameter surface (C10/C14) with a changelog entry + justification. (✅ done)
- Vision version bumped to the next additive **minor** (4.1.0 → 4.2.0); sibling changelog updated. (✅ done)
- All builds (orchestrator, model routing, coverage store) remain parked. (✅ done)
