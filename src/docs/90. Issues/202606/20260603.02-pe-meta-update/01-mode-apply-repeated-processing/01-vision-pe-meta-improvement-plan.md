---
title: "Vision amendment — make `--mode apply` always plan-then-execute (pe-meta)"
author: "Dario Airoldi"
date: "2026-06-03"
created: "2026-06-03"
status: "draft"
domain: "prompt-engineering"
target_vision_version: "15.4.0"
goal: "Amend vision v15 and every writing pe-meta artifact so `--mode apply` always materializes a plan and then executes it (one execution engine, plan as single pivot artifact), pinning the reasoning→execution model seam to the plan→execute boundary — without adding a parameter and without weakening the default-full guarantee."
---

# Vision amendment — make `--mode apply` always plan-then-execute

> Source analysis: [01-overview.md](01-overview.md) § "Refinement: make `--mode apply` ALWAYS plan-then-execute".
> This plan amends a **vision document**; per the vision boundary *"MUST NOT be modified by autonomous processes — vision changes are human-only"*, the vision edits in this plan are **proposals requiring human consent before execution** (see § Human consent).

## Goal

**Verbatim trigger (this turn):** *"create a `01-vision-pe-meta-improvement-plan.md` with all details vision update, and the change is to be applied to all pe-meta artifacts."*

**Verbatim trigger (originating analysis):** *"in case of `/pe-meta-update --mode apply` (no plan) we could anyway generate the plan and then run it immediately — this would bring more consistency between the two paths, comparable costs, and the generated plan would always be available for analysis."*

The change: `--mode apply` becomes **materialize plan → execute plan** (same execution engine as `--plan-file` consumption), so plan and apply stop being two divergent pipelines. The plan file becomes the single pivot artifact every mutating run passes through. The reasoning→standard model seam is pinned to the plan→execute boundary.

| # | Item | Scope tag | Principle impact | Downstream landing |
|---|------|-----------|------------------|--------------------|
| 1 | Rewrite vision § *Plan-mode output contract* → § *Plan output contract*: a plan file is materialized in **both** `plan` and `apply` modes; `apply` additionally executes it. | `[in-scope: original]` | preserves: `minimal-canonical-surface`, `default-full-invocation`, `invocation-shape-agnostic`; touches: `human-governance-autonomous-execution` (P1 justification: extends the on-disk-plan audit/handoff guarantee from plan-mode-only to every mutating apply run, strengthening — not weakening — the human-handoff loop the principle requires) | `landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md` |
| 2 | Add to the vision a **model-routing seam** statement pinning the reasoning→standard boundary to the plan→execute boundary (plan/research on reasoning model; execution of a validated plan on standard/cheaper model). | `[in-scope: original]` | preserves: `minimal-canonical-surface`, `deterministic-where-possible`; touches: `model-routing` (P1 scope item; justification: makes the already-declared `model-routing` / `model-specialization` scope items concrete by naming the exact cut point, closing the vision↔implementation gap) | `landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md` |
| 3 | Add to the vision an **execution-ready plan precision** requirement: a plan consumed by a (possibly cheaper) executor MUST carry literal edits or unambiguous anchors per row, so execution is deterministic. | `[in-scope: original]` | preserves: `evidence-based`, `deterministic-where-possible`, `human-governance-autonomous-execution` | `landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.v15.md` |
| 4 | Bump vision version `15.3.0 → 15.4.0`, update `last_updated`, and add a changelog entry describing the always-plan-then-execute contract. | `[vision-only: no-downstream]` | preserves: `single-source-of-truth` | `landing: vision-only` |
| 5 | Update `pe-meta-plan-file-contract.md`: (a) state the plan is emitted on **every mutating run**, not only `--mode plan`; (b) add the **execution-ready precision** clause (literal edit or unambiguous anchor per row); (c) add the same-run vs cross-run drift-guard rule. | `[in-scope: original]` | preserves: `single-source-of-truth`, `human-governance-autonomous-execution`, `evidence-based` | `landing: .github/prompt-snippets/pe-meta-plan-file-contract.md` |
| 6 | Update `pe-meta-iteration-budget.md`: reframe the spillover plan as a **special case** of the always-plan checkpoint (it already emits-and-resumes via a plan), so overflow is no longer a bolt-on. | `[in-scope: original]` | preserves: `single-source-of-truth`, `command-family-agnostic` | `landing: .github/prompt-snippets/pe-meta-iteration-budget.md` |
| 7 | Rewrite the `--mode` table in `pe-meta-update.prompt.md` so `apply` reads "materialize plan (Phases 1–4) → execute plan (Phases 5–7) → report"; add the same-run-skips-drift-guard / cross-run-requires-it rule; add a per-phase model-routing note (Phases 1–4 reasoning model, Phases 5–7 standard model). | `[in-scope: original]` | preserves: `default-full-invocation`, `minimal-canonical-surface`, `command-family-agnostic` | `landing: .github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` |
| 8 | Propagate the always-plan-then-execute contract + model-routing seam to **every other writing pe-meta orchestrator** so the contract holds uniformly: `pe-meta-create-update.prompt.md`, `pe-meta-design.prompt.md`, `pe-meta-review.prompt.md`, `pe-meta-scheduled-review.prompt.md`. | `[in-scope: original]` | preserves: `command-family-agnostic`, `invocation-shape-agnostic`, `default-full-invocation`; touches: `command-family-agnostic` (P0 justification → see § Human consent: the contract change must land in every writing family to keep the principle true; this realizes the principle rather than altering its statement) | `landing: .github/prompts/00.09-pe-meta/` |
| 9 | Verify per-artifact dispatch prompts (`pe-meta-{context,prompt,instruction,agent,skill,template,snippet,hook}-{create-update,design,review}.prompt.md`) inherit the contract via the shared snippets and need **no per-file edit**; record the finding. | `[in-scope: original]` | preserves: `single-source-of-truth`, `command-family-agnostic` | `landing: 01-vision-pe-meta-improvement-plan.md` (this plan, § Execution notes) |

### Human consent (vision boundary + P0 touch)

This plan touches the P0 principle `command-family-agnostic` (item 8) and edits the vision document (items 1–4), which the vision boundary marks human-only.

> This plan touches P0 `command-family-agnostic`. Vision version bump required (`15.3.0 → 15.4.0`). The vision and orchestrator edits are proposals; **consent confirmed by: Dario Airoldi** (author of this plan and vision owner). Execution of items 1–4 MUST be performed by, or under explicit approval of, the human vision owner — never autonomously.

## Why this change (one-paragraph rationale)

Today `plan` and `apply` are two independent pipelines that both start at Phase 1 research; `apply` has no plan-consumption path. That makes the two routes able to diverge in result and cost. Making `apply` *always* materialize a plan and then execute it collapses the behaviors to one rule — `apply = plan + execute`; `plan = apply minus execute`; `--plan-file = apply minus the plan-generation half` — sharing a single execution engine. This is vision-**reinforcing**: it adds no parameter, strengthens `human-governance-autonomous-execution` (a reviewable plan lands on every mutating run, not just `--mode plan`), and gives `model-routing` a clean cut point. The single hard precondition is plan-format precision (item 3 / item 5b): a cheaper executor applying a plan cold must receive execution-ready edits, or quality degrades.

## Execution steps

Execute in dependency order. Vision edits (steps 1–4) require human consent per § Human consent.

1. Apply vision item 1 — rewrite § *Plan-mode output contract* → § *Plan output contract* (both modes materialize a plan; apply executes it). (🟡 todo)
2. Apply vision item 2 — add the model-routing seam statement (reasoning→execute boundary = plan→execute boundary). (🟡 todo)
3. Apply vision item 3 — add the execution-ready plan-precision requirement. (🟡 todo)
4. Apply vision item 4 — bump `version` to `15.4.0`, update `last_updated`, add changelog entry. (🟡 todo)
5. Apply snippet item 5 — `pe-meta-plan-file-contract.md`: emitted-on-every-mutating-run + precision clause + drift-guard rule. (🟡 todo)
6. Apply snippet item 6 — `pe-meta-iteration-budget.md`: reframe spillover as a special case of the always-plan checkpoint. (🟡 todo)
7. Apply orchestrator item 7 — `pe-meta-update.prompt.md` `--mode` table rewrite + drift-guard rule + per-phase model routing. (🟡 todo)
8. Apply orchestrator item 8 — propagate the contract to the other four writing orchestrators. (🟡 todo)
9. Apply verification item 9 — confirm per-artifact dispatch prompts inherit via snippets; record the result in § Execution notes. (🟡 todo)
10. Run a consistency pass — verify no artifact still describes `apply` as "Full Research → Build → Validate cycle" without the plan-then-execute framing; verify the seven-parameter surface is unchanged. (🟡 todo)

## Execution notes

(Populated during execution — e.g. the item-9 finding on dispatch-prompt inheritance.)

## Exit criteria

- The vision describes `apply` as materialize-plan-then-execute, with the plan emitted in both modes. (🟡 todo)
- The vision names the reasoning→execute model seam and the execution-ready plan-precision requirement. (🟡 todo)
- Vision version is `15.4.0` with a changelog entry; `last_updated` refreshed. (🟡 todo)
- `pe-meta-plan-file-contract.md` states "emitted on every mutating run", carries the precision clause, and the same-run/cross-run drift-guard rule. (🟡 todo)
- All five writing orchestrators describe `apply` as plan-then-execute with the per-phase model-routing note; no orchestrator retains the old "Full Research → Build → Validate cycle" framing for `apply`. (🟡 todo)
- The seven-parameter canonical surface is unchanged (no new flag added by this plan). (🟡 todo)
- The `--plan-file` / auto-detect question remains parked (not introduced by this plan). (🟡 todo)

## Park lot

- **Cross-run plan reuse surface (`--plan-file` vs auto-detect a sibling `*.plan.md`).** `[scope-expansion: needs-own-plan]` → `02-plan-reuse-surface-plan.md` — introducing a way to consume a *prior-run* plan is a distinct activity (it touches `minimal-canonical-surface` P0 and needs the drift guard fully specified). Out of scope here; this plan only makes same-run apply always plan-then-execute.
- **Should apply-from-plan apply higher-risk findings autonomously, or only the plan's autonomous-marked low-risk ones?** → defer (revisit when the reuse surface is designed).
- **Stale-plan policy for cross-run reuse (auto-fall-back to full re-investigation vs hard-stop).** → defer (belongs with the reuse-surface plan).
- **Does the cheaper executor need its own minimal regression pass, or is plan-time validation sufficient?** → defer (settle during item-7 implementation review).
- **Same plan path for `plan` and `apply` (single artifact lineage) vs distinct paths (audit separation).** → defer (decide during item-5 implementation).

## Actionability gate status

This plan is authored to pass the gate (clarity, non-ambiguity, scope discipline, coverage promise, principle-impact tagging). It remains `status: draft` because promotion to `actionable` is an explicit human action, and because the vision edits require the human-consent step above before execution.
