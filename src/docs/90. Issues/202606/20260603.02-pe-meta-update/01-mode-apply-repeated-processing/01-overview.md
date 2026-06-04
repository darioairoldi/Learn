---
title: "Does `--mode apply` re-run the full pe-meta pipeline? Investigation + plan-consumption proposal"
author: "Dario Airoldi"
date: "2026-06-03"
status: "draft"
domain: "prompt-engineering"
goal: "Determine whether the second `--mode apply` invocation reprocessed the full pe-meta workflow, and evaluate a plan-generate / plan-execute split with a cheaper execution model."
---

# Does `--mode apply` re-run the full pe-meta pipeline?

## TL;DR

- **What you observed this conversation: NO reprocessing happened.** The `--mode plan` run did the full research and emitted the plan file. The "apply" step did **not** re-invoke `/pe-meta-update --mode apply`; the agent applied the plan's already-validated findings directly from chat, reading only the target lines each finding pointed at. So research ran **once**, not twice.
- **But per the written contract, a literal `--mode apply` WOULD have reprocessed.** `--mode apply` is defined as a *"Full Research → Build → Validate cycle."* There is **no plan-consumption pathway** — `plan` and `apply` are two independent pipelines that both start at Phase 1 research. Had you literally typed `/pe-meta-update --mode apply --dim quality`, it would have re-run research from scratch and re-derived the same findings (double cost + drift risk).
- **Your proposed change is sound and partially already in the vision.** "Cheaper model for execution" is *already* a P1 vision principle (`model-routing` / `model-specialization`) — it is simply **not implemented** (the orchestrator hardcodes one model for every phase). "Generate plan, then execute that plan" (plan reuse) is **not** in the vision yet, but a precedent exists (spillover plans already carry `original-run=` linkage *"so the next cycle can resume context without re-investigating"*).

## What the contract actually says

From `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` (`--mode` table):

| Value | Behavior |
|---|---|
| `apply` | **Full Research → Build → Validate cycle** with low-risk autonomous apply + propose for higher-risk findings (default). |
| `plan` | **Research-only** execution — Build/Validate skipped; produces health score, findings report, AND an actionable plan file on disk; no source writes. |

Key facts confirmed by reading the prompt + snippets:

1. **No `--plan-file` parameter exists.** The canonical surface is exactly seven parameters (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`). Nothing lets `apply` ingest a plan produced by a prior `plan` run.
2. **Apply re-derives findings via Phase 1 research**, then Build, then Validate. Plan mode's output (the on-disk plan file) is a *human/agent handoff artifact*, never an `apply`-mode input.
3. **`--skip research` cannot rescue this** for a full sweep: rule #2 rejects `--skip research` when `breadth=full` (a full sweep without research is "structurally meaningless").
4. The single closest existing reuse mechanism is the **spillover plan** (`pe-meta-iteration-budget.md`): on overflow it records `original-run=<plan-or-run-id>` *"so the next cycle can resume context without re-investigating."* — i.e. resume-without-re-research is **already a legitimized pattern**, just scoped to overflow only.

## Where the vision already supports the cost idea

`20260531.01-vision.v15.md` already contains (P1 scope items + rationales):

- **`model-routing`** — *"Routing reasoning tasks to reasoning models, execution tasks to standard models … optimizes both cost AND quality."* → *"Research/analysis → reasoning models. Implementation/formatting → standard models."*
- **`model-specialization`** — *"Reasoning models excel at analysis and planning. Standard models excel at execution. Small models suffice for deterministic-like tasks."*
- The Detect→Assess→Propose→Execute table separates **Implement** (*"Execute the plan / Apply changes through tool use"*) from the analysis steps.

**The gap:** the orchestrator declares one model (`model: claude-opus-4.6`) for the *entire* pipeline. The vision says execution should run on a cheaper/standard model; the implementation never routes it there.

## Why a naive "apply always skips research" is the wrong fix

Making `--mode apply` skip research **by default** would violate **`default-full-investigation` (P1)**: a parameter-less manual invocation must remain a deliberate full sweep, never a silent narrowing. A one-shot `apply` that re-investigates is *legitimately valuable* — it catches findings that drifted since any earlier plan. So the re-research default should stay; the efficiency win belongs to the **explicit** plan-then-apply workflow.

## Recommended implementation: explicit plan-consumption apply

Introduce an **apply-from-plan** path, opt-in and explicit, so both P1 principles are honored:

| Invocation | Behavior | Model |
|---|---|---|
| `/pe-meta-update --mode apply` (no plan) | Today's full pipeline (Research → Build → Validate → apply → regression → report). Unchanged. | reasoning model |
| `/pe-meta-update --mode apply --plan-file <p>` | **Consume the validated plan**, SKIP Phases 1–4, run only execution + Phase 7 regression + Phase 8 report. | standard/cheaper model |

This is exactly the path the agent took manually this conversation — now made a first-class, repeatable contract.

### Why it is safe to run apply-from-plan on a cheaper model

- Plan rows are already **validated by the reasoning model** during plan mode.
- The plan file already conforms to `plan-execution.instructions.md`: one row per finding at **actionability-gate granularity** (one editable artifact + one verifiable change). Execution of pre-validated, localized edits is low-reasoning work — the model-routing sweet spot.

### Guard rails to design in

1. **Drift / staleness guard (required).** Record a content hash (or precise anchor) of each target section in the plan. At apply-from-plan time, re-check before editing; if a target drifted since the plan, **escalate that finding back to research** instead of blindly applying. This mirrors the existing `validation-caching` hash discipline.
2. **Edit precision.** For reliable cheap-model application, plan rows should carry the literal old→new edit (or anchors precise enough to be unambiguous), not just a prose description.
3. **Regression stays.** Phase 7 regression must still run (can itself be deterministic / cheaper-model).
4. **Per-phase model assignment.** The single `model:` frontmatter is too coarse. Route per phase/agent: research+design → reasoning model; apply-from-plan → standard model; YAML/reference/hash checks → deterministic tools.

### Open design tension to resolve (vision-level)

`--plan-file` would be an **eighth** parameter, which conflicts with **`minimal-consistent-option-surface` (seven canonical parameters)**. Three resolutions, in order of preference:

1. **Auto-detect (no new flag).** When `--mode apply` runs in a run-folder that already contains a sibling `*.plan.md` from a prior plan run, offer to consume it (`Found plan <p> — consume it (skip research) or re-investigate?`). Zero surface growth; preserves explicitness via the prompt.
2. **Value-shape an existing parameter** (e.g. fold plan-path into `--scope` as a `.plan.md` shape that means "apply this plan").
3. **Accept `--plan-file` as a justified new parameter** per `capability-applicability` (new params must be justified against the minimal surface). Least preferred — grows the surface.

## Recommendation summary

1. **Keep** `--mode apply` (no plan) as a full re-investigation — it protects `default-full-investigation`.
2. **Add** an explicit **apply-from-plan** path that consumes a prior plan, skips Phases 1–4, and runs execution + regression + report (preferably auto-detected to avoid an 8th flag).
3. **Implement `model-routing`** (already P1 in the vision): reasoning model for plan/research, standard/cheaper model for apply-from-plan, deterministic tools for predictable checks.
4. **Add the drift guard** (target-section hashing) so plan reuse cannot apply stale edits.
5. **Generalize the spillover `original-run=` resume precedent** from overflow-only to the whole plan→apply handoff.

This is genuinely vision-impactful: it closes a vision↔implementation gap (`model-routing`), removes a real double-research cost for the plan-then-apply workflow, and reuses an already-legitimized "resume without re-investigating" pattern — without weakening the default-full guarantee.

## Refinement: make `--mode apply` ALWAYS plan-then-execute

> **The insight.** The two rows above describe two *different code paths* (one interleaves research+apply, one consumes a plan). Different paths → different results and different costs. Your proposal removes that divergence: **`--mode apply` always materializes a plan first, then immediately executes that plan** — so the execute half is the *same engine* whether the plan was just generated or supplied via `--plan-file`.

### Reframed mode model

| Mode | Behavior | Plan file on disk? |
|---|---|---|
| `--mode plan` | Materialize plan, **stop** (assessment-only). | Yes |
| `--mode apply` (no plan) | Materialize plan, **then execute it** (same execution engine). | Yes |
| `--mode apply --plan-file <p>` | Skip research, **execute the supplied plan** (same execution engine). | Reuses `<p>` |

This collapses three behaviors into one clean rule: **`apply` = `plan` + execute; `plan` = `apply` minus execute; `--plan-file` = `apply` minus the plan-generation half.** The plan file is the *single pivot artifact* every path passes through.

### Why this is better than the two-divergent-paths design

1. **Consistency by construction.** apply-no-plan and apply-from-plan share one execution engine, so they cannot drift in *how* they apply. The only difference is whether research ran — which is the honest, transparent cost difference, not a behavioral one.
2. **Plan always available for analysis.** Every apply run leaves the same reviewable, version-controllable artifact that plan mode does. This directly satisfies `human-governance-autonomous-execution` (P1) — the audit/handoff loop closes on *every* mutating run, not just `--mode plan`.
3. **Clean model-routing boundary.** The plan→execute seam is exactly where `model-routing` wants the cut: reasoning model produces the plan, standard/cheaper model executes it — identically in both apply variants. One seam, one routing rule.
4. **Cost is comparable and transparent.** `apply(no-plan)` = plan-cost + execute-cost; `apply(--plan-file)` = execute-cost only. The delta is precisely the research you chose to skip — observable, not hidden in a different pipeline shape.
5. **Aligns with the vision's own sequence.** Detect → Assess → **Propose (plan)** → Execute is already a plan-first sequence. Today's apply mode *interleaves* assess+execute, which is actually *less* aligned with the vision than the proposed plan-first checkpoint.
6. **Generalizes the spillover precedent.** Spillover already emits a plan mid-apply and resumes by consuming it. Making the plan a first-class checkpoint on *every* apply makes spillover a natural special case rather than a bolt-on.

### Costs and tensions (honest accounting)

1. **No cost saving for the no-plan case.** This refinement is about *consistency and auditability*, not speed. `apply(no-plan)` still pays full research. The cost win remains exclusively in the `--plan-file` reuse path. (You acknowledged this — "comparable costs" — so it matches intent.)
2. **Forces full-assess-before-any-execute.** If today's apply ever interleaves "research one finding → apply it → next," the plan-first checkpoint forbids that. This is a net positive: it lets the iteration-budget cap and prioritization see *all* findings before spending budget, and it gives the approval gate one clean surface. But it is a behavioral change to characterize in the changelog.
3. **Handoff information loss is the one real quality risk.** A single continuous context that researches *and* applies can produce better-integrated edits than a (possibly cheaper) executor applying a plan cold. **Mitigation is the plan format**: rows must carry execution-ready precision (literal old→new edits or unambiguous anchors), not prose intent. With a precise plan there is no quality loss; with a prose-only plan a cheap executor can misapply. **Plan precision is the quality lever.**
4. **Minor extra I/O.** Serializing a plan file on every apply is negligible disk/latency for a large audit and consistency benefit.

### Why same-run execution is safe (and the drift guard relaxes)

The drift guard (target-section hashing) matters when consuming an **old** plan (`--plan-file` from a prior run). For `apply(no-plan)`, plan and execute happen back-to-back in one run, so drift is effectively zero — the guard can be **skipped for same-run execution** and **required only for cross-run plan reuse**. This keeps the common path fast while protecting the reuse path.

### Net verdict

**Adopt it.** The change is vision-*reinforcing*, not vision-expanding:

- It **adds no parameter** (the seven-parameter surface is untouched; `--plan-file`/auto-detect is the same open item as before).
- It **strengthens** `human-governance-autonomous-execution`, `model-routing`, and the Detect→Assess→Propose→Execute sequence.
- It **removes** the path-divergence risk you identified — at no efficiency loss (the no-plan path cost is unchanged) and no quality loss **provided the plan format carries execution-ready precision**.

The one hard precondition to write into the vision/implementation: **the plan-file contract must guarantee execution-ready edit precision** so the execute half (especially on a cheaper model) is deterministic. That single requirement is what converts this from "nice idea" to "safe to ship."

### Concrete edits this implies

- **Vision (`20260531.01-vision.v15.md`):** refine § Plan-mode output contract → *Plan output contract* — a plan file is materialized in **both** `plan` and `apply` modes; `apply` additionally executes it. Add an explicit `model-routing` note pinning the reasoning→execute seam to the plan→execute boundary.
- **`pe-meta-plan-file-contract.md`:** (a) state the plan is emitted on every mutating run, not only `--mode plan`; (b) add an **execution-ready precision** clause (literal edit or unambiguous anchor per row).
- **`pe-meta-update.prompt.md`:** rewrite the `--mode` table so `apply` reads "materialize plan (Phases 1–4) → execute plan (Phases 5–7) → report"; route Phases 1–4 to the reasoning model and Phases 5–7 to a standard model; add same-run-skips-drift-guard / cross-run-requires-it rule.

## Park lot (decide later)

- Should apply-from-plan be allowed to apply *higher-risk* findings autonomously, or only the low-risk ones the plan marked autonomous?
- Should a stale plan (e.g. > N days, or target hash mismatch) auto-fall-back to full re-investigation, or hard-stop and ask?
- Does the cheaper execution model need its own minimal regression-validation pass, or is the reasoning model's plan-time validation sufficient?
- Should `--mode plan` and `--mode apply` write to the *same* plan path so an apply run is literally "the plan file, now executed" (single artifact lineage), or to distinct paths for audit separation?
