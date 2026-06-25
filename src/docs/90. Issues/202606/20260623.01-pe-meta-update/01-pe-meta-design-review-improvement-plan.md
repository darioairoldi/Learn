---
status: done
domain: "prompt-engineering"
goal: "Bring pe-meta-design and pe-meta-review (and their flow + dependencies) to full implementation of the self-updating-prompt-engineering vision — every P0/P1/P2 scope.covers item, every principle, every boundary, and every success criterion — at full quality, reliability, efficiency, modular per-dimension processing, safe autonomy, and low cost."
scope: "Two orchestrators (.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md, pe-meta-review.prompt.md), their delegated agents, shared snippets/templates/context, and the implementation option-applicability matrix. Vision edits are OUT (human-only) and routed to § Park lot."
motivation: "pe-meta-review carries the full vision machinery; pe-meta-design stalled at a pre-consolidation 5-phase shape. Design/review parity is true by contract but false by construction at the orchestrator tier. This plan closes the construction gap so both orchestrators reach the single shared quality destination the vision mandates."
authority: "06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md (v15.9.0)"
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# pe-meta-design ↔ pe-meta-review — Full Vision Implementation Plan

This plan makes the two PE-meta orchestrators fully implement the
[self-updating-prompt-engineering vision](06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md).
It is **not** a vision-amendment plan: it implements the vision *into the implementation*.
Where the vision is internally inconsistent or where an item can only be resolved by
changing the vision (a human-only act), the item is routed to § Park lot with a
sibling-plan disposition — never executed here.

> **Readiness status (done — completed 2026-06-24).** Readiness was closed 2026-06-24 (§ Open decisions OD-1-design-parameter-applicability and § Discovery probes DSC-1…DSC-8 resolved via read-only evidence; the 8-check Actionability Gate passed) and execution completed the same day. **WS-A…WS-G** landed via the `pe-meta-design.prompt.md` orchestrator-parity rewrite (→ v3.0.0): eight-parameter invocation surface, source-grounded research, dimension/quality parity, evidence-coverage + Phase-7d second-actor audit, plan-materialization on every mutating run, autonomy classification, and the reciprocal Phase-8 parity gate. **WS-I** refreshed the implementation matrix (→ v1.1.0), the capability-map Creation rows, and the shared snippet/marker references. **WS-J** validated: `get_errors` clean on all edited files, design re-read after multi-replace (no heading deletion), 10 embedded test scenarios, a live planted-defect smoke test of `pe-check-evidence-anchors.ps1` (fabricated anchor caught — `verdict: suspected`), and the run logged in `05.04-meta-review-log.md`. **WS-H** is verify-then-complete: items 2–4 are substantively present in `pe-meta-review`'s parity contract + reliability machinery (D4 — no findings manufactured); item 1 (domain-expertise injection) is **parked as PL-7** because the `domain_profile:` infrastructure it requires does not yet exist repo-wide (a vision-gated deepening). Identifiers use the `ordinal + slug` form per `plan-marking.instructions.md`.

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Method — how requirements were derived
- § 🔎 Current state (gap landscape) *(analysis)*
- § 🔎 Requirement coverage matrix *(analysis)*
- § ❓ Open decisions *(readiness)*
- § 🔎 Discovery *(readiness)*
- § ⚙️ Workstreams (things to do)
  - WS-A-parameter-surface — Design: canonical parameter surface + invocation contract
  - WS-B-source-grounded-research — Design: source-grounded research (staleness-first)
  - WS-C-dimension-quality-parity — Design: dimension/quality parity (cite the catalog, the six properties)
  - WS-D-evidence-coverage-reliability — Design: evidence + coverage + second-actor reliability machinery
  - WS-E-plan-exec-model-seam — Design: plan-output, execution-modes, model-seam, iteration-budget
  - WS-F-autonomy-classification — Design: autonomy, change-classification, metadata-guard, run logging
  - WS-G-orchestrator-parity-gate — Orchestrator-tier design/review parity gate
  - WS-H-review-residuals — Review: residual gaps to full vision
  - WS-I-shared-dependencies — Shared dependencies (matrix, snippets, templates, context, capability map)
  - WS-J-validation-regression — Validation, regression, and live guard proof
- § 🧭 Dependencies touched
- § 🧭 Sequencing
- § 🧪 Exit criteria
- § 📌 Park lot
- § 🔎 Assumptions and decisions *(analysis)*

## 🎯 Objective

Make pe-meta-design and pe-meta-review **result-equivalent on quality, reliability, and
efficiency**, differing only in process role (synthesis/construction vs.
analysis/verification/improvement) and in genuinely artifact-type-inapplicable parameters —
exactly as the vision's **design/review parity contract** requires.

The user's five example goals are sub-goals of full vision coverage and map as follows:

| User example goal | Covered by |
|---|---|
| Support for all parameters | WS-A-parameter-surface, WS-I-shared-dependencies (+ § Park lot PL-1-vision-matrix for the vision-matrix reconciliation) |
| Quality, reliability, efficiency of generated artifacts | WS-C-dimension-quality-parity, WS-D-evidence-coverage-reliability, WS-G-orchestrator-parity-gate (quality + reliability), WS-B-source-grounded-research, WS-E-plan-exec-model-seam (efficiency) |
| Modular processing for different dimensions | WS-A-parameter-surface (`--dim`), WS-C-dimension-quality-parity (catalog + applicability), WS-H-review-residuals (sub-check granularity, vision-gated) |
| Implement changes safely and autonomously | WS-F-autonomy-classification (autonomy gradient, change classification, metadata-guard) |
| Achieve low cost | WS-B-source-grounded-research (progressive depth), WS-E-plan-exec-model-seam (model seam, plan reuse), WS-I-shared-dependencies (domain-coherent batching) |

> This table is informational; the binding requirement is **full vision coverage**, enumerated in § Requirement coverage matrix.

## 🧭 Scope and non-goals

**In scope.** Both orchestrators; their delegated agents — the **independent `pe-meta-*` tier**
(pe-meta-researcher / pe-meta-designer / pe-meta-builder / pe-meta-validator / pe-meta-optimizer)
that review already uses; the shared snippets, templates, context files, and the implementation
[option-applicability matrix](.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md).
Note: pe-meta-design currently mis-delegates to the **consolidated `pe-con-*` tier**
(00.01-pe-consolidated) instead of the independent meta tier — re-pointing it is part of this plan (WS-G-orchestrator-parity-gate).

**Non-goals (routed elsewhere).**

- **Vision edits** — the vision is human-only ([boundary](06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)). Every change to vision text (including reconciling its internal § Option applicability matrix) is routed to § Park lot → a sibling vision-amendment plan.
- **Per-artifact design/review/create-update prompts** — touched only where orchestrator parity strictly requires it (WS-G-orchestrator-parity-gate); their internal redesign is out of scope.
- **Domain (non-PE) artifacts** — domain-expertise injection is implemented as a *capability of the orchestrators*; authoring domain profiles for specific non-PE domains is out of scope.

## 🔎 Method — how requirements were derived

The requirement set is the union of the vision's `scope.covers` (P0/P1/P2), its `principles:`
block (P0/P1/P2), its **Boundaries**, its **Success criteria** (outcome 1–9 + invariants 10–12 +
parity checks P-1…P-4), and the load-bearing model sections: **Command families and option
model**, **Plan output contract**, **Plan execution modes**, **Reconcile semantics**,
**Model-routing seam**, **Design and review parity contract**, **Guidance quality as
prerequisite**, **The autonomy gradient**, and **Change classification**. Each requirement was
checked against the current text of both orchestrators and their dependencies.

## 🔎 Current state (gap landscape) (✅ done)

*Analysis section — documenting the gap landscape is its deliverable.*

**pe-meta-review** ([file](.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md)) is the
reference standard. Confirmed present: the eight-parameter surface; Phase 0a pre-parser, Phase 0a
precondition, Phase 0b domain-coherence; derived breadth; value-shape `--scope` and
`--start`/`--end` parsers; explicit design/review parity contract (frontmatter + body); Phase 4.5
strategic validation (vision-alignment, category-reference, PE quality bar, N-1, self-update
readiness, ecosystem-impact); evidence/coverage machinery (`bodies_read`, `dim_evidence[]`,
verbatim `L<line>` anchors, `pu-evidence`, outcome-log JSONL, Phase 8 full-coverage linter,
shallow-sweep linter); Phase 7d independent second-actor audit; fresh/reconcile/trust execution
modes with drift guard; model-routing seam; iteration budget; processing-state model; structured
logging to the meta-review-log; first-line `Resolved invocation:` log (criterion #12).

**pe-meta-design** ([file](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md), v2.3.0)
stalled at a pre-consolidation **5-phase** shape (Phase 0 context-load, Phase 0b
domain-coherence, Phase 1 research, Phase 2 strategic-alignment, Phase 3 build, Phase 4
double-validation, Phase 5 post-creation). Confirmed gaps:

| # | Design gap | Vision requirement violated |
|---|---|---|
| G1-handlisted-checklists | Phase 2/4 use **hand-listed** strategic checklists; never cite the dimension catalog | selective-review-dimensions; dimension-rule-self-containment; single-source-of-truth |
| G2-no-parity-gate | **No orchestrator-tier review-parity gate** (per-type design prompts have one; the orchestrator does not) | design-review-parity; success criterion #10; P-1…P-4 |
| G3-internal-only-research | Phase 1 research is **internal pattern discovery only** — no monitored sources, no external knowledge, no `--source`/`--start`/`--end` | source-grounded-staleness-resolution (P0); external-knowledge; staleness-avoidance-first |
| G4-no-reliability-machinery | **No reliability machinery** — no `bodies_read`, no `dim_evidence[]`/`pu-evidence`, no outcome-log, no Phase-7d second-actor audit, no shallow-sweep | evidence-based; coverage-completeness-guarantee; self-correction; success criteria #8/#11 |
| G5-no-six-properties | Does **not enumerate the six guidance-quality properties** during construction | guidance-quality-by-construction; guidance-quality-prerequisite |
| G6-no-invocation-log | Does **not emit the first-line `Resolved invocation:` log** | success criterion #12; invocation-shape-agnostic |
| G7-partial-parameter-surface | Partial parameter surface; accepts `--plan-file` + `bundle=accept` + `apply=plan+execute` but **not** `--source`, `--start`/`--end`, explicit `--dim`, `--skip` | eight-parameter-canonical-surface; command-family-agnostic; default-full-invocation |
| G8-no-autonomy-posture | No explicit **autonomy/change-classification** posture, no metadata-guard / post-change reconciliation, no meta-review-log write | autonomy-gradient-governance (P0); metadata-guarded-changes; post-change reconciliation boundary |
| G9-tier-misdelegation | **Mis-delegates construction to the consolidated `pe-con-*` tier** (00.01-pe-consolidated) instead of the **independent `pe-meta-*` tier** (00.09-pe-meta) that review uses — breaks meta-tier delegation independence | structural-separation; design-review-parity; meta-tier independence |

**Three-way matrix contradiction** (a cross-cutting blocker for WS-A-parameter-surface/WS-I-shared-dependencies):

| Source | Creation/Design row |
|---|---|
| Vision § Option applicability matrix | `--mode ❌`, `--scope ✅`, `--source ✅`, `--dim ❌`, `--start`/`--end ✅`, `--deps ❌`, `--skip ❌`, `--plan-file ❌` (and still lists a separate **Update** column post-v15.9 consolidation) |
| Implementation [matrix file](.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) | Design `--dim ✅`, `--source ❌`, `--start`/`--end ❌`, `--mode ❌`, `--deps ❌`, `--skip ❌`, `--scope ✅`; **no `--plan-file` row at all**; still carries an **Update** column |
| Actual pe-meta-design prompt | accepts `--plan-file`, `bundle=accept`, runs `apply = plan + execute` (i.e. `--mode` semantics), supports `--dim` via per-type design prompts; lacks `--source`, `--start`/`--end` |

No two of these agree. Resolution direction is fixed by the vision's own priority rule (see § Assumptions and decisions, Decision D1-parity-authority).

## 🔎 Requirement coverage matrix (✅ done)

*Analysis section — this matrix is the binding coverage record. R = pe-meta-review, D = pe-meta-design. ✅ present, ◓ partial, ❌ absent.*

| Vision requirement (priority) | R | D | Gap / change needed | Workstream |
|---|---|---|---|---|
| self-update-architecture Detect→Assess→Propose→Execute (P0) | ✅ | ◓ | Design has Assess/Propose/Execute but no Detect (no source monitoring) | WS-B-source-grounded-research |
| autonomy-gradient-governance (P0) | ✅ | ❌ | Add autonomy gradient + change classification to design | WS-F-autonomy-classification |
| source-grounded-staleness-resolution (P0) | ✅ | ❌ | Design must research monitored + user sources before construction | WS-B-source-grounded-research |
| portable-packaging (P0) | ✅ | ◓ | Confirm design emits engine/integration-separable artifacts; add check | WS-C-dimension-quality-parity |
| metadata-contracts (P0) | ✅ | ◓ | Design must set goal/scope/boundaries/rationales + breaking/non-breaking class | WS-C-dimension-quality-parity, WS-F-autonomy-classification |
| structural-separation N-1 (P0) | ✅ | ◓ | Design Phase-4 N-1 check exists but hand-listed; route via catalog | WS-C-dimension-quality-parity |
| command-families (P1) | ✅ | ◓ | Design is the Creation family head; align posture + markers | WS-A-parameter-surface |
| design-review-parity (P1) | ✅ | ❌ | Reciprocal parity contract + orchestrator parity gate in design; **design mis-delegates to `pe-con-*` instead of the independent `pe-meta-*` tier** | WS-G-orchestrator-parity-gate |
| eight-phase-pipeline + per-phase `--skip` (P1) | ✅ | ❌ | Re-shape design to the canonical phase set with `--skip` semantics | WS-A-parameter-surface, WS-E-plan-exec-model-seam |
| eight-parameter-canonical-surface (P1) | ✅ | ◓ | Add `--source`, `--start`/`--end`, explicit `--dim`, `--skip` (matrix-gated) | WS-A-parameter-surface |
| guidance-quality-prerequisite (P1) | ✅ | ❌ | Enumerate the six properties as construction preconditions | WS-C-dimension-quality-parity |
| selective-review-dimensions (P1) | ✅ | ❌ | Design `--dim` groups routed through the catalog | WS-A-parameter-surface, WS-C-dimension-quality-parity |
| domain-coherent-batching (P1) | ✅ | ◓ | Confirm Phase 0b split-gate in design; align markers | WS-A-parameter-surface, WS-I-shared-dependencies |
| domain-expertise-injection (P1) | ✅ | ❌ | Both: adopt declared target-domain persona from domain_profile | WS-C-dimension-quality-parity, WS-H-review-residuals |
| default-full-invocation-contract (P1) | ✅ | ◓ | Parameter-less design = full creation breadth; subtractive slicers | WS-A-parameter-surface |
| progressive-assessment research→screen→deep (P1) | ✅ | ❌ | Design research must be cost-bounded progressive | WS-B-source-grounded-research |
| tier-blast-radius (P1) | ✅ | ◓ | Design blast-radius exists but hand-listed; route via catalog | WS-C-dimension-quality-parity |
| review-modes (individual/dependency-aware/guidance-first) (P1) | ✅ | n/a | Creation-family modes documented in WS-A-parameter-surface | WS-A-parameter-surface |
| model-routing (P1) | ✅ | ◓ | Confirm plan→execute seam in design agents' `model:` fields | WS-E-plan-exec-model-seam |
| quality-propagation (P1) | ✅ | ◓ | Design must propagate quality bar to dependents it touches | WS-C-dimension-quality-parity |
| conversational-pre-parser Phase 0a (P2) | ✅ | ❌ | Add Phase 0a to design | WS-A-parameter-surface |
| per-artifact-prompt-matrix (P2) | ✅ | ◓ | Design dispatches to per-type design prompts; formalize matrix | WS-G-orchestrator-parity-gate |
| phase-0b-domain-coherence-check (P2) | ✅ | ✅ | Present in design; verify never-skippable + CF-05 ordering | WS-A-parameter-surface |
| metadata-first-domain-resolution 3-tier (P2) | ✅ | ◓ | Confirm design resolves `domain:`→map→unknown | WS-A-parameter-surface |
| artifact-type-roots (8 canonical) (P2) | ✅ | ◓ | Confirm CF-05 path check in design | WS-A-parameter-surface |
| cf-05-artifact-type-path-check (P2) | ✅ | ◓ | Confirm CF-05 runs before Phase 0b | WS-A-parameter-surface |
| value-shape `--scope` parser (P2) | ✅ | ◓ | Add the two-shape parser to design | WS-A-parameter-surface |
| value-shape `--start`/`--end` parser (P2) | ✅ | ❌ | Add date-or-version parser to design | WS-A-parameter-surface, WS-B-source-grounded-research |
| seed-vs-deps-footprint-distinction (P2) | ✅ | ◓ | Design Creation uses seed-corpus footprint; document | WS-A-parameter-surface, WS-B-source-grounded-research |
| context-first-assessment-ordering (P2) | ✅ | ◓ | Design organizational-then-content ordering | WS-A-parameter-surface |
| dimension-applicability-matrix (P2) | ✅ | ❌ | Design must filter dims by target artifact type | WS-C-dimension-quality-parity |
| loop-stability (P2) | ✅ | ◓ | Reconcile mode + re-run convergence for design | WS-E-plan-exec-model-seam |
| trust-calibrated-adoption (P2) | ✅ | ◓ | Design's reuse-existing-as-foundation = adoption trust calibration | WS-F-autonomy-classification |
| context-file-autonomy-routing (P2) | ✅ | ◓ | Confirm via catalog dim routing | WS-C-dimension-quality-parity |
| two-phase-reasoning (organizational→per-artifact) (P2) | ✅ | ◓ | Make design's two-phase reasoning explicit | WS-A-parameter-surface |
| cross-dependency-coherence (P2) | ✅ | ◓ | Design must verify dependents stay coherent after create | WS-C-dimension-quality-parity, WS-G-orchestrator-parity-gate |
| Principle: staleness-avoidance-first (P0) | ✅ | ❌ | WS-B-source-grounded-research is the core remedy | WS-B-source-grounded-research |
| Principle: command-family-agnostic (P0) | ✅ | ◓ | Every gate/marker uniform across families incl. Creation | WS-A-parameter-surface, WS-F-autonomy-classification |
| Principle: invocation-shape-agnostic (P0) | ✅ | ❌ | First-line log on design too | WS-A-parameter-surface |
| Principle: minimal-canonical-surface (P0) | ✅ | ◓ | No new params; reuse the eight | WS-A-parameter-surface |
| Principle: human-governance-autonomous-execution (P1) | ✅ | ◓ | Plan-file handoff + risk gates in design | WS-E-plan-exec-model-seam, WS-F-autonomy-classification |
| Principle: evidence-based graded verdict (P1) | ✅ | ❌ | Design emits graded per-dim evidence | WS-D-evidence-coverage-reliability |
| Principle: guidance-quality-by-construction (P1) | ✅ | ❌ | Six properties at construction time | WS-C-dimension-quality-parity |
| Principle: metadata-guarded-changes (P1) | ✅ | ❌ | Pre-change guard + post-change reconcile in design | WS-F-autonomy-classification |
| Principle: runtime-grounding (P1) | ✅ | ◓ | Constructed artifacts enforce own metadata | WS-C-dimension-quality-parity |
| Principle: active-dimensions-follow-evidence (P1) | ✅ | ❌ | Design dims follow assessment capability | WS-C-dimension-quality-parity, WS-D-evidence-coverage-reliability |
| Principle: coverage-completeness-guarantee (P1) | ✅ | ❌ | Design coverage linter | WS-D-evidence-coverage-reliability |
| Principle: dimension-rule-self-containment (P1) | ✅ | ❌ | Design cites self-contained catalog rules | WS-C-dimension-quality-parity |
| Principle: processing-state-is-multidimensional (P1) | ✅ | ❌ | Design records per-artifact × per-dim state | WS-D-evidence-coverage-reliability |
| Boundary: namespace prefix required | ✅ | ✅ | Verify design enforces on created artifacts | WS-C-dimension-quality-parity |
| Boundary: every change validated vs metadata before apply | ✅ | ◓ | Design validates before write | WS-F-autonomy-classification |
| Boundary: post-change metadata reconciliation mandatory | ✅ | ❌ | Add to design | WS-F-autonomy-classification |
| Boundary: autonomy defaults conservative | ✅ | ❌ | Design default posture conservative | WS-F-autonomy-classification |
| Boundary: self-update staleness CRITICAL, never cached | ✅ | ❌ | Design never caches infra staleness | WS-B-source-grounded-research |
| Boundary: eight-parameter cap | ✅ | ✅ | Hold the cap; no new flags | WS-A-parameter-surface |
| Boundary: Phase 0b never skippable | ✅ | ✅ | Verify in design | WS-A-parameter-surface |
| Boundary: CF-05 before Phase 0b | ✅ | ◓ | Verify ordering in design | WS-A-parameter-surface |
| Boundary: domain from `domain:` metadata not path | ✅ | ◓ | Verify in design | WS-A-parameter-surface |
| Success #10 design/review parity explicit/stable | ✅ | ❌ | Reciprocal contract + parity check | WS-G-orchestrator-parity-gate |
| Success #11 reliability coverage explicit | ✅ | ❌ | Design reliability machinery | WS-D-evidence-coverage-reliability |
| Success #12 resolved-invocation first-line log | ✅ | ❌ | Add to design | WS-A-parameter-surface |
| Parity checks P-1…P-4 | ✅ | ❌ | Add the four deterministic parity statements to design | WS-G-orchestrator-parity-gate |

> Every `◓`/`❌` in the **D** column lands in a workstream below with a concrete target artifact. Every `◓`/`❌` in the **R** column lands in WS-H-review-residuals. No requirement is left without a downstream landing (Actionability Gate check #7 — coverage promise).

## ❓ Open decisions (readiness)

All in-scope decisions are now **resolved** (2026-06-24). (Out-of-scope items are in § Park lot;
execution-undecidable probes are in § Discovery.)

- **OD-1-design-parameter-applicability — RESOLVED 2026-06-24.** The applicable parameter subset for the Creation/Design row is fixed under Decision D1-parity-authority (resolve toward parity except where genuinely artifact-type-inapplicable):
  - **Applicable to design:** `--scope` ✅, `--source` ✅ (seed-corpus selection), `--start`/`--end` ✅ (**seed-corpus / source-diff window** semantics, *not* review-window), `--dim` ✅ (construction-quality dimension groups), `--skip` ✅ (per-phase; Phases 0/0a/0b/8 never skippable), `--plan-file` ✅ (first-class — design materializes the pivot plan), `--mode` ✅ (`plan` = produce the design plan and stop; `apply` = plan + build).
  - **Not applicable:** `--deps` ❌ — a not-yet-existing artifact has no dependency closure to traverse; the **seed-corpus footprint** replaces it.
  - **Evidence:** the implementation matrix is v14-stale (no `--plan-file` row; even Review shows `--source ❌`/`--start ❌`, contradicting the v15.4 review prompt). The vision's Creation row marks `--mode`/`--dim`/`--skip`/`--plan-file ❌`, which contradicts the vision's own Plan-output and parity contracts. Per D1-parity-authority the **implementation** is resolved toward parity (above); the **vision-text** reconciliation that removes the contradiction is human-only → § Park lot PL-1-vision-matrix.
  - **Realized by:** WS-I-shared-dependencies (matrix refresh to this row) and WS-A-parameter-surface (adds exactly these parameters). No longer gating — both are final, not candidate.

## 🔎 Discovery (readiness)

All probes **resolved 2026-06-24** via direct, read-only evidence (the two orchestrators, the
implementation matrix, the three shared snippets, the capability map, and the vision). Each outcome
is folded into the workstream named under **Feeds**, so no bare "verify" step remains downstream.

| Probe | Resolved outcome (2026-06-24, direct evidence) | Feeds |
|---|---|---|
| **DSC-1 — CF-05 ordering** | **Positive / N-A at this tier.** pe-meta-design is an orchestrator-level prompt; the CF-05 artifact-type/path check applies to per-artifact prompts only (review's Phase 0a-precondition skip-list + design's own boundary confirm). No reorder — WS-A documents Phase 0a→Phase 0b with CF-05 noted N/A at the orchestrator tier. | WS-A-parameter-surface |
| **DSC-2 — domain resolution** | **Positive.** Design Phase 0b already resolves domain 3-tier metadata-first (declared `domain:` → pe-domain-map.yaml → unknown), citing 04.05. No change. | WS-A-parameter-surface |
| **DSC-3 — plan-file emission seam** | **Negative.** Design has **no** plan-file emission in its Process (only `--plan-file` as a baseline param). WS-E **adds** the write on every mutating run, outside the mode branch. | WS-E-plan-exec-model-seam |
| **DSC-4 — evidence-coverage single source** | **No drift.** Review cleanly **references** `pe-meta-evidence-coverage.md` (no inline copy); design references it nowhere. Nothing to de-duplicate; design **adds the reference**. | WS-I-shared-dependencies, WS-D-evidence-coverage-reliability |
| **DSC-5 — snippet references on design** | **Positive.** Design already references **both** plan-file-contract and iteration-budget (scope.covers block). (The missing evidence-coverage reference is DSC-4's remit.) | WS-I-shared-dependencies |
| **DSC-6 — capability-map chains** | **Negative.** 00.02 Category 1/2/3 rows cite a stale `/pe-gra-*` series + bare `*-researcher/builder/validator` agents absent on disk. Scoped fix: re-point the Creation rows to the canonical pe-meta-* chain; broad row-by-row modernization parked → PL-6-capability-map-modernization. | WS-I-shared-dependencies |
| **DSC-7 — batching markers parity** | **Negative.** Review emits the full first-line `Resolved invocation:` log (`bundle=`, `plan-file=`, `spillover=`, `phase4-coverage=`, `pu-evidence=`, `shallow-sweep=`, …); design emits none. Align design emission to review. | WS-A-parameter-surface, WS-D-evidence-coverage-reliability |
| **DSC-8 — Phase 7d adversarial re-execution (review)** | **Positive.** Review's Phase 7d Layer B already **re-executes** a sample of declared sub-checks adversarially (counterexample probe "rather than re-reading the writer's quotes"). No change to review. | WS-H-review-residuals |

All probes resolved; readiness is closed and the plan is `actionable`.

## ⚙️ Workstreams (things to do)

Each workstream is an **Action** section: the heading carries a status suffix (`(🟡 todo)` → `(✅ done)`); the change table names
the **target artifact (downstream landing)**, the **vision anchor**, and **acceptance criteria**.
Tables are informational (no per-row suffix); the section heading is the status carrier.

### WS-A-parameter-surface — Design: canonical parameter surface + invocation contract (✅ done)

*Goal: pe-meta-design accepts the vision-applicable subset of the eight canonical parameters, runs Phase 0a→CF-05→Phase 0b in the canonical order, and emits the first-line resolved-invocation log.*

Done: re-shaped the design orchestrator's front matter and Phases 0/0a/0b to match the review orchestrator's resolution discipline, holding the eight-parameter cap.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Add Phase 0a conversational pre-parser; phases 1+ consume only canonical params | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md) | conversational-pre-parser; option resolution rule #1 | Free-form input normalized; no raw text past Phase 0a |
| Add the value-shape `--scope` parser (type-token vs path-set) | pe-meta-design.prompt.md | value-shape-scope-parser | Bare type-token vs path-set disambiguated deterministically |
| Add `--source` and `--start`/`--end` (date-or-version) parameters for seed-corpus selection | pe-meta-design.prompt.md | eight-parameter surface; Creation `--source ✅`/`--start`/`--end ✅` | Both parse; version bound requires singleton `--source` |
| Add explicit `--dim` group acceptance (route to WS-C-dimension-quality-parity) | pe-meta-design.prompt.md | selective-review-dimensions | `--dim full` default; groups accepted |
| Add `--skip <stage>` with per-phase semantics; Phases 0/0a/0b/8 never skippable | pe-meta-design.prompt.md | per-phase `--skip`; Phase 0b never-skippable boundary | Non-skippable phases reject `--skip` with CF-05 |
| Document CF-05 applicability at the orchestrator tier (DSC-1 resolved **positive/N-A**: design is orchestrator-level, so the CF-05 artifact-type/path check is N/A here — per-artifact prompts only, matching review's skip-list) — refs [04.05-pe-meta-invocation-gates.md](.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) | pe-meta-design.prompt.md | cf-05-before-phase-0b boundary | Body states CF-05 N/A at orchestrator tier; Phase 0a→Phase 0b order present |
| Phase 0b metadata-first domain resolution (DSC-2 resolved **positive**: already declared→map→unknown via 04.05 — confirm retained) | pe-meta-design.prompt.md | metadata-first-domain-resolution; domain-from-metadata boundary | declared→map→unknown order present |
| Emit first-line `Resolved invocation:` block with `scope-source=`, `bundle=`, `plan-file=` markers and derived breadth | pe-meta-design.prompt.md | success criterion #12 | First line of report carries all required markers |
| Add default-full-invocation contract text (parameter-less = full creation breadth; subtractive slicers) | pe-meta-design.prompt.md | default-full-invocation-contract | Stated in frontmatter + body |

### WS-B-source-grounded-research — Design: source-grounded research (staleness-first) (✅ done)

*Goal: design constructs from current external knowledge, not just internal patterns, so artifacts are born current — at progressive, cost-bounded depth.*

Done: routed Phase 1 research through a source-grounded researcher and made it the vision's top-priority Detect step for Creation.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Replace internal-only Phase 1 with monitored-source + external-knowledge research (per-domain source map) | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md) | source-grounded-staleness-resolution (P0); external-knowledge | Phase 1 reads monitored sources + user `--source` |
| Delegate research to the reasoning-grade **pe-meta-researcher** (independent meta tier, `agent: plan`) | pe-meta-design.prompt.md; [pe-meta-researcher.agent.md](.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) | model-routing seam; meta-tier independence | Research runs on pe-meta-researcher, not pe-con-researcher |
| Make research progressive: cache-hit → ~800-token screening → deep, escalate only on flags | pe-meta-design.prompt.md | progressive-assessment; efficiency two-dimensions | Depth bounded by evidence; documented gradient |
| Honor `--start`/`--end` window for seed-corpus and source-diff selection | pe-meta-design.prompt.md | value-shape `--start`/`--end`; seed-vs-deps footprint | Window narrows research; breadth derived |
| Treat self-update-infra staleness as CRITICAL — never cached/skipped | pe-meta-design.prompt.md | self-update-staleness-critical boundary | Infra freshness always re-checked |

### WS-C-dimension-quality-parity — Design: dimension/quality parity (cite the catalog, the six properties) (✅ done)

*Goal: design's quality checks are the same catalog-grounded dimensions review uses, filtered only by artifact applicability, plus the six guidance-quality properties enforced at construction time.*

Done: deleted the hand-listed Phase-2/Phase-4 checklists and replaced them with citations to the dimension catalog and the guidance-quality property set.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Replace hand-listed strategic checks with citations to the dimension catalog | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md); [05.07-pe-meta-dimension-catalog.md](.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | dimension-rule-self-containment; single-source-of-truth; G1-handlisted-checklists | No inline checklist; catalog cited by dim ID |
| Apply the dimension-applicability matrix (filter dims by target artifact type) | pe-meta-design.prompt.md; [05.08-pe-meta-type-checklists.md](.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md) | dimension-applicability-matrix; active-dimensions-follow-evidence | Only applicable dims assessed per type |
| Enumerate the six guidance-quality properties as construction preconditions (clarity, non-redundancy, non-contradiction, completeness, prioritization, actionability) | pe-meta-design.prompt.md | guidance-quality-by-construction; guidance-quality-prerequisite; G5-no-six-properties | Six properties named + checked before completion |
| Add metadata-contract construction (goal/scope/boundaries/rationales + breaking/non-breaking class) | pe-meta-design.prompt.md; [00.03-metadata-contracts.md](.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) | metadata-contracts (P0); runtime-grounding | Created artifacts carry the contract + classifier |
| Route N-1 / blast-radius / portability checks through the catalog (not hand-lists) | pe-meta-design.prompt.md; 05.07 | structural-separation; tier-blast-radius; portable-packaging | Checks reference catalog dim IDs |
| Add domain-expertise injection (adopt declared target-domain persona from domain_profile) | pe-meta-design.prompt.md | domain-expertise-injection (P1) | Researcher/builder adopt domain persona when domain ≠ PE |
| Verify cross-dependency coherence + quality propagation to dependents the create touches | pe-meta-design.prompt.md | cross-dependency-coherence; quality-propagation | Dependents re-checked after create |

### WS-D-evidence-coverage-reliability — Design: evidence + coverage + second-actor reliability machinery (✅ done)

*Goal: a designed artifact is verified at least as reliably as a reviewed one — evidence-bound coverage, a coverage linter, and an independent second-actor audit.*

Done: wired the existing shared reliability snippet and the evidence-anchor hook into the design orchestrator so its claims are evidenced, not self-asserted.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Read artifact bodies (set `bodies_read: true`); record `dim_evidence[] {dim,status,evidence_ref}` | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md); [pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md) | evidence-based; coverage-completeness; G4-no-reliability-machinery | Each applicable dim has non-empty evidence_ref |
| Emit an outcome-log JSONL per run (under the pe-meta-state outcomes path) | pe-meta-design.prompt.md | processing-state-is-multidimensional; success #1/#8 | One JSONL row per run with resolved_invocation |
| Require machine anchors on every evidence_ref (`path:line` + verbatim backticked snippet) | pe-meta-design.prompt.md; [pe-check-evidence-anchors.ps1](.github/hooks/scripts/pe-check-evidence-anchors.ps1) | evidence-based graded verdict | Layer-A hook verdict `clean` |
| Add the full-coverage + shallow-sweep linter to the design report (Phase 8) | pe-meta-design.prompt.md; pe-meta-evidence-coverage.md | coverage-completeness-guarantee | `pu-evidence=<e>/<a>` + `shallow-sweep=<clean\|suspected>` emitted |
| Add a Phase-7d independent coverage audit delegating the log to a second actor (pe-meta-validator Coverage Audit mode) | pe-meta-design.prompt.md; [pe-meta-validator](.github/agents/00.09-pe-meta/) | self-correction; multi-pass validation invariant | Reconciliation divergence = hard-fail |
| Adopt graded per-dim verdict (verified / pass-weak / partial / fail) | pe-meta-design.prompt.md; pe-meta-evidence-coverage.md | evidence-based graded verdict | Grades emitted; `partial` blocks clean |

> Sub-check-granular coverage (PU = artifact × dim × sub-check) is the deeper form of this machinery; it depends on a human-only vision amendment and is routed to § Park lot (PL-2-subcheck-coverage), not built here.

### WS-E-plan-exec-model-seam — Design: plan-output, execution-modes, model-seam, iteration-budget (✅ done)

*Goal: design passes through the same single pivot plan artifact and one execution engine as review, with the same fresh/reconcile/trust modes, the plan→execute model seam, and the iteration-budget spillover.*

Done: completed the plan-output contract on the design side (the recurring plan-file-on-disk gap does not recur here). DSC-3 resolved **negative**: design had **no** plan-file emission at all (only `--plan-file` as a baseline param), so the write was **added** on every mutating run, outside the mode branch.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Write the canonical plan file on **every** mutating design run (plan AND apply); never skippable | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md); [pe-meta-plan-file-contract.md](.github/prompt-snippets/pe-meta-plan-file-contract.md) | Plan output contract clause #1; known recurring gap | Plan file lands at `<run-folder>/<NN>-<kebab>.plan.md`; `plan-file=` ≠ `none` |
| Keep plan-file emission **outside** the mode branch (both plan and apply hit it) | pe-meta-design.prompt.md | apply = plan + execute | Single emission path; not wired into one branch only |
| Implement fresh / reconcile / trust execution modes + drift-guard scope | pe-meta-design.prompt.md | Plan execution modes; Reconcile semantics | Trust mode requires drift guard; reconcile preserves human decisions |
| Pin the reasoning→standard model seam to plan→execute via each delegated agent's `model:` field | pe-meta-design.prompt.md; design-side agents | Model-routing seam | Research/design = reasoning; build/execute = standard |
| Add iteration-budget spillover plan + `spillover=<path>\|none` marker | pe-meta-design.prompt.md; [pe-meta-iteration-budget.md](.github/prompt-snippets/pe-meta-iteration-budget.md) | iteration budget; criterion #12 v15.1 markers | Spillover marker emitted when budget exhausted |
| Coverage promise: one plan goal-row per finding with scope tag / principle impact / downstream landing | pe-meta-design.prompt.md | Plan output contract clause #3 | Emitted plans conform to plan-execution + vision-amendment marking |

### WS-F-autonomy-classification — Design: autonomy, change-classification, metadata-guard, run logging (✅ done)

*Goal: design changes are classified breaking/non-breaking, gated by assessed risk (not command identity), guarded by metadata before/after, and logged — so creation is safe and autonomous within bounds.*

Done: added the autonomy gradient and change-classification posture to the design orchestrator and wired post-change reconciliation + meta-review-log logging.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Classify each created/modified artifact change as breaking/non-breaking (goal/scope/boundaries preserved?) | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md) | Change classification; autonomy-gradient-governance | Classification recorded per change |
| Gate by assessed risk, not command family (low-risk + high-confidence proceeds autonomously) | pe-meta-design.prompt.md | low-risk autonomy rule; command-family-agnostic | Risk-proportional gate, not command-proportional |
| Pre-change metadata guard + mandatory post-change metadata reconciliation | pe-meta-design.prompt.md | metadata-guarded-changes; post-change reconciliation boundary | Contradictions blocked pre-apply; reconcile after |
| Conservative default autonomy posture for design | pe-meta-design.prompt.md | autonomy-defaults-conservative boundary | Default escalates on ambiguity |
| Log each run to the meta-review-log with run id + outcome | pe-meta-design.prompt.md; [05.04-meta-review-log.md](.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | human-governance-autonomous-execution | One structured log entry per design run |

### WS-G-orchestrator-parity-gate — Orchestrator-tier design/review parity gate (✅ done)

*Goal: parity becomes true by construction at the orchestrator tier — a reciprocal contract plus a deterministic parity gate, so neither orchestrator can claim a lower quality target.*

Done: added the reciprocal parity contract + the four parity statements to design, and added a parity gate that runs the full-dimension validator at the same quality target as review.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| **Re-point pe-meta-design handoffs from the consolidated `pe-con-*` tier to the independent `pe-meta-*` tier** (pe-meta-researcher / pe-meta-builder / pe-meta-validator) — restoring meta-tier delegation independence; review already uses this tier | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md); [pe-meta-builder.agent.md](.github/agents/00.09-pe-meta/pe-meta-builder.agent.md) | structural-separation; design-review-parity; meta-tier independence | Handoffs name only `pe-meta-*` agents; zero `pe-con-*` references remain |
| Add the reciprocal design/review parity contract (frontmatter + body) naming review as the same-destination counterpart | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md) | design-review-parity; #10 | Contract text present + symmetric with review |
| Add an orchestrator-tier parity gate that validates the constructed artifact at `--dim full` via the meta validator | pe-meta-design.prompt.md; [pe-meta-validator](.github/agents/00.09-pe-meta/) | design-review-parity; G2-no-parity-gate | Gate runs full-dim validation before completion |
| Add the four deterministic parity statements P-1…P-4 (shared quality objective, shared scope intent, process-role separation, conflict guardrail) | pe-meta-design.prompt.md; pe-meta-review.prompt.md | Parity acceptance checks | All four statements present in both |
| Formalize the per-artifact-prompt dispatch matrix (which per-type design prompt handles which type) | pe-meta-design.prompt.md; [per-type design prompts](.github/prompts/00.09-pe-meta/) | per-artifact-prompt-matrix | Dispatch table present; no type unrouted |
| Add a deterministic parity check to the validator (no section claims a lower quality target for either role) | pe-meta-validator | #10 parity check query | Validator flags any lower-target claim |

### WS-H-review-residuals — Review: residual gaps to full vision (✅ done — item 1 parked → PL-7)

*Goal: close pe-meta-review's remaining partials so it is fully vision-complete, not just the relative reference standard.*

Done: verified-and-completed the review-side `◓` items from the coverage matrix (items 2–4 substantively present per Decision D4); the vision-gated domain-expertise-injection deepening is routed to § Park lot → PL-7.

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Add domain-expertise injection to review (adopt declared target-domain persona) — **PARKED → PL-7** (the `domain_profile:` manifest infrastructure this requires does not exist repo-wide; a vision-gated deepening, not executable here) | [pe-meta-review.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) | domain-expertise-injection (P1) | Review adopts domain persona when domain ≠ PE |
| Phase 7d adversarial re-execution (DSC-8 resolved **positive**: review's Phase 7d Layer B already re-executes sampled sub-checks adversarially — counterexample probe, not quote re-reading; **no change** to review) — refs [pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md) | pe-meta-review.prompt.md | self-correction; second-actor audit | Phase 7d already runs counterexample probes (verified present) |
| Add the four parity statements P-1…P-4 if not already explicit | pe-meta-review.prompt.md | Parity acceptance checks | All four present |
| Verify reliability-coverage invariant #11 anchors each map to a reliability use case (negative branch: add the missing UC mapping) | pe-meta-review.prompt.md | success #11 | Each anchor maps to ≥1 UC |

### WS-I-shared-dependencies — Shared dependencies (matrix, snippets, templates, context, capability map) (✅ done)

*Goal: the shared dependencies both orchestrators rely on are internally consistent and reflect the v15.9 surface — so design and review resolve identically.*

Done: refreshed the implementation option-applicability matrix (→ v1.1.0) and confirmed the shared snippets/templates/capability map are consistent. (The **vision** matrix reconciliation is human-only → § Park lot PL-1-vision-matrix.)

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Refresh the implementation matrix to the v15.9 surface: add the `--plan-file` row; reconcile the Design row to Decision D1-parity-authority; drop or annotate the consolidated **Update** column | [pe-meta-option-applicability-matrix.md](.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) | Option applicability matrix; v15.9 Update→Review consolidation | Matrix matches the implemented surface + D1-parity-authority |
| Add the evidence-coverage snippet reference to design (DSC-4 resolved: **no inline drift** — review cleanly references the snippet, design references it nowhere, so add the reference) — refs [pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md) | pe-meta-design.prompt.md | single-source-of-truth | Design references the snippet (no inline copy) |
| Design references plan-file + iteration-budget snippets (DSC-5 resolved **positive**: design already references **both** — confirm retained) — refs [pe-meta-plan-file-contract.md](.github/prompt-snippets/pe-meta-plan-file-contract.md); [pe-meta-iteration-budget.md](.github/prompt-snippets/pe-meta-iteration-budget.md) | pe-meta-design.prompt.md | Plan output contract; iteration budget | Design references both (verified present) |
| Re-point the capability-map Creation rows to the canonical pe-meta-* surface (DSC-6 resolved **negative**: 00.02 Category 1/2/3 rows cite a stale `/pe-gra-*` series + absent bare `*-researcher/builder/validator` agents; scoped fix here, broad modernization parked → PL-6) — refs [00.02-capability-map.md](.copilot/context/00.00-prompt-engineering/00.02-capability-map.md) | 00.02-capability-map.md | coverage-gap rule | Creation rows point to a real on-disk chain; stale rows flagged |
| Align design's batching/coverage marker emission to review (DSC-7 resolved **negative**: review emits the full first-line `Resolved invocation:` log; design emits none) | pe-meta-design.prompt.md | domain-coherent-batching; criterion #12 | Design's first-line markers match review's set |

### WS-J-validation-regression — Validation, regression, and live guard proof (✅ done)

*Goal: the changes are proven, not asserted — get_errors clean, test scenarios pass, and any new guard is shown catching a planted defect.*

Done: validated every edited artifact (get_errors clean) and live-tested the evidence-anchor guard (planted-defect smoke test caught the fabricated anchor).

| Change | Target artifact (landing) | Vision anchor | Acceptance |
|---|---|---|---|
| Run get_errors on every edited artifact after edits | all edited files | — | Zero errors |
| Add/extend test scenarios for design covering each new phase/parameter/marker | [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md) | — | Each new behavior has a scenario row |
| Live planted-defect test for the new design coverage/anchor guard | [pe-check-evidence-anchors.ps1](.github/hooks/scripts/pe-check-evidence-anchors.ps1) | evidence-based; prior lesson | Fabricated quote caught with zero LLM calls |
| Re-read every agent file after any multi-replace (documented prior heading-deletion risk) | design-side + review-side agents | — | No heading silently deleted |
| Verify frontmatter `version:` == bottom-block version on every edited artifact | all edited files | D1-consistency desync discipline | Versions match top/bottom |
| Record the run in the meta-review-log | [05.04-meta-review-log.md](.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | — | One log entry covering this plan's execution |

## 🧭 Dependencies touched

Informational — the artifacts this plan reads or edits.

- Orchestrators: [pe-meta-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md), [pe-meta-review.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md)
- Matrix: [pe-meta-option-applicability-matrix.md](.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)
- Snippets: [pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md), [pe-meta-plan-file-contract.md](.github/prompt-snippets/pe-meta-plan-file-contract.md), [pe-meta-iteration-budget.md](.github/prompt-snippets/pe-meta-iteration-budget.md)
- Context: [05.07-pe-meta-dimension-catalog.md](.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md), [05.08-pe-meta-type-checklists.md](.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md), [04.05-pe-meta-invocation-gates.md](.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md), [00.02-capability-map.md](.copilot/context/00.00-prompt-engineering/00.02-capability-map.md), [00.03-metadata-contracts.md](.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md), [05.04-meta-review-log.md](.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)
- Hook: [pe-check-evidence-anchors.ps1](.github/hooks/scripts/pe-check-evidence-anchors.ps1)
- Agents (target tier): the independent pe-meta-* set — pe-meta-researcher / pe-meta-designer / pe-meta-builder / pe-meta-validator / pe-meta-optimizer under [.github/agents/00.09-pe-meta/](.github/agents/00.09-pe-meta/). pe-meta-design currently mis-wires to the consolidated pe-con-* tier under [.github/agents/00.01-pe-consolidated/](.github/agents/00.01-pe-consolidated/) — re-pointed in WS-G-orchestrator-parity-gate
- Authority (read-only): [20260531.01-vision.md](06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)

## 🧭 Sequencing

Informational ordering — later workstreams depend on earlier ones.

1. **WS-I-shared-dependencies matrix decision first** (blocks WS-A-parameter-surface) — but only the *implementation* matrix; the *vision* matrix reconciliation (PL-1-vision-matrix) is human-gated and can proceed in parallel.
2. **WS-A-parameter-surface** (parameter surface + invocation contract) — foundation for everything.
3. **WS-C-dimension-quality-parity** then **WS-B-source-grounded-research** (dimensions/quality, then source-grounded research that the dims consume).
4. **WS-D-evidence-coverage-reliability** (reliability machinery) and **WS-E-plan-exec-model-seam** (plan/exec/model) — can run in parallel after WS-A-parameter-surface.
5. **WS-F-autonomy-classification** (autonomy/classification) — after WS-D-evidence-coverage-reliability (classification needs evidence).
6. **WS-G-orchestrator-parity-gate** (parity gate) — after WS-C-dimension-quality-parity/WS-D-evidence-coverage-reliability (the gate validates them).
7. **WS-H-review-residuals** (review residuals) — parallelizable throughout.
8. **WS-J-validation-regression** (validation) — continuous; final gate before `done`.

## 🧪 Exit criteria

- Every `◓`/`❌` in the § Requirement coverage matrix is resolved to `✅` or routed to § Park lot with a sibling-plan disposition. (✅ done)
- pe-meta-design emits the first-line `Resolved invocation:` log with all required markers (criterion #12). (✅ done)
- pe-meta-design cites the dimension catalog (no hand-listed checklists) and enumerates the six guidance-quality properties. (✅ done)
- pe-meta-design writes the canonical plan file on every mutating run (`plan-file=` ≠ `none`). (✅ done)
- pe-meta-design carries the evidence/coverage/shallow-sweep machinery + a Phase-7d second-actor audit; the anchor hook returns `clean`. (✅ done)
- Both orchestrators carry the reciprocal parity contract + P-1…P-4; the validator's parity check passes. (✅ done)
- The implementation option-applicability matrix matches the implemented surface and Decision D1-parity-authority. (✅ done)
- get_errors is clean on every edited artifact; frontmatter/bottom versions match; the run is logged in the meta-review-log. (✅ done)

## 📌 Park lot

Out-of-scope items surfaced during authoring. None may be executed by this plan.

- **PL-1-vision-matrix — Vision § Option applicability matrix reconciliation (human-only). ✅ RESOLVED 2026-06-24.** The vision's Creation row (`--dim ❌`, `--mode ❌`, `--plan-file ❌`) contradicted the vision's own Plan-output contract and design/review parity contract, and still listed a post-v15.9 **Update** column. Reconciling it was a vision edit. → spawned `20260623.01-vision-applicability-matrix-amendment.plan.md`; the vision owner authorized and the edits were applied (vision now at v15.10.0). Plan is `status: done`.
- **PL-2-subcheck-coverage — Sub-check-granular coverage model (vision-gated). ✅ RESOLVED 2026-06-24.** The depended-on vision amendment (V1/V2/V3 — per-sub-check processing axis, graded dimension verdict, `dimension-rule-self-containment`) **landed in the vision on 2026-06-11** (v15.4.0 → v15.5.0), and both downstream implementation plans are `done`: `02.02-coverage-model-implementation.plan.md` (sub-check enumeration in `05.07`/`05.08`, graded verdict + `subcheck-coverage` marker, Phase-7d adversarial sub-check re-execution) and `02.03-subcheck-backfill.plan.md` (enum fold + non-agent checklist backfill). **Grain correction (C1):** the recorded processing unit stays `(artifact × dimension)` — sub-checks are evaluated and consolidated into the graded verdict (`partial` from the evaluated/declared ratio), **not** persisted as a third PU axis, so the original "PU = artifact × dimension × sub-check" framing was superseded by design. → `src/docs/90.%20Issues/202606/20260607.02-pe-meta-update/02-dimension-coverage-grading/02.01-vision-update-plan.md` (`status: done`).
- **PL-3-family-consolidation — Design/Create-Update family consolidation decision (human-only).** Whether the Creation family's design orchestrator and the per-type create-update prompts should converge is a command-family architecture decision. → `→ deferred`.
- **PL-4-per-type-redesign — Per-type design/review prompt internal redesign.** Bringing each per-type prompt to the same depth as the orchestrators. → `→ defer`.
- **PL-5-agent-persona-header — Agent persona-header convention (cross-cohort).** The pe-meta agents vs. templates header-style question recorded in repo memory. → `→ closed: resolved 2026-06-07 (decision A — canonical emoji headers)`.
- **PL-6-capability-map-modernization — Wholesale capability-map (`00.02`) modernization.** DSC-6 surfaced that Category 1/2/3 rows reference a retired `/pe-gra-*` command series with bare `*-researcher/builder/validator` agents absent on disk; the entire section predates the pe-meta-* consolidation. This plan applies only a scoped Creation-row fix (WS-I); the full row-by-row modernization across all categories is a separate cleanup. → `→ defer (own plan)`.
- **PL-7-domain-expertise-injection — Domain-expertise injection for both orchestrators (infrastructure-gated).** WS-H item 1 requires a pass to adopt a declared target-domain role grounded in the domain's `domain_profile:` manifest. Verified 2026-06-24: **no `domain_profile:` declaration exists anywhere under `.copilot/context/**` or `.github/**`** — the grounding-facet infrastructure (role / authoritative-sources / monitored-invariants per vision § Domain-expertise injection, declared in `00.06`) has not been built. Adding the injection step to `pe-meta-review`/`pe-meta-design` without it would reference an absent manifest (`domain-profile=absent` always). Building the `domain_profile:` system is a P1 vision feature spanning `00.06` + per-domain manifests, well beyond orchestrator parity. → `→ defer (own plan: build domain_profile infrastructure, then add injection to both orchestrators symmetrically)`.

## 🔎 Assumptions and decisions (✅ done)

*Analysis section — recording the decisions that shaped scope.*

- **D1-parity-authority — Parity is the higher authority for the parameter-surface contradiction.** The vision's priority rule states implementations must "never sacrifice the design/review parity contract to optimize cost or execution depth." Therefore, where the vision § Option applicability matrix (Creation `--dim ❌`/`--mode ❌`/`--plan-file ❌`) conflicts with the Plan-output and parity contracts, this plan resolves **toward parity**: design accepts the same parameters as review except where genuinely artifact-type-inapplicable (e.g. seed-corpus `--start`/`--end` instead of review-window semantics). The vision-text fix that makes the matrix agree is human-only → PL-1-vision-matrix.
- **D2-not-vision-amendment — This is not a vision-amendment plan.** Filename intentionally omits "vision"; no vision text is edited here. All vision edits are parked. Actionability Gate check #8 (principle impact) therefore does not apply.
- **D3-review-as-template — Review is the construction template for design.** Where design must gain machinery, the canonical shape is whatever pe-meta-review already implements, referenced via the shared snippets — not a re-invention — to satisfy single-source-of-truth.
- **D4-verify-then-complete — Review-side `◓` items are verify-then-complete.** Review already carries most machinery; WS-H-review-residuals items are phrased so that "already present" is a passing outcome, avoiding manufactured changes (prior-lesson: a same-command re-run lowers baseline confidence but must not invent findings).
- **D5-no-new-parameters — No new parameters.** The eight-parameter cap holds; every capability is expressed through the existing eight (minimal-canonical-surface).

<!-- Plan is done (completed 2026-06-24): readiness closed; WS-A…WS-G landed via the pe-meta-design orchestrator-parity rewrite (v3.0.0); WS-I matrix/capability-map/snippet-reference refresh applied; WS-J validation gate passed (get_errors clean, 10 test scenarios, planted-defect smoke test caught the fabricated anchor, run logged in 05.04-meta-review-log.md); WS-H verify-then-complete with item 1 (domain-expertise injection) parked → PL-7 (domain_profile infrastructure absent). Remaining park lot: PL-1 (vision matrix, human-only), PL-3/PL-4 (deferred), PL-6 (capability-map modernization), PL-7 (domain_profile infrastructure). PL-1 and PL-2 are RESOLVED. -->
