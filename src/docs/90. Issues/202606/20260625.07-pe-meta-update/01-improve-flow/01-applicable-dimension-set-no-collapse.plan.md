---
status: done
domain: "prompt-engineering"
goal: "Guarantee that every standard pe-meta invocation (1) defaults `--dim` to `full` explicitly at every per-type entry point, and (2) resolves its applicable-dimension SET — the `<applicable>` evidence denominator — from the 05.07 applicability matrix for the artifact type (the full type-applicable set, ~28 dims for prompts/agents), never silently collapsed to the ~8-row structural subset enumerated in 05.08."
scope: "In = the 8 per-type review prompts (re-source the applicable SET from 05.07; keep 05.08 for sub-checks), the 8 per-type create-update prompts (explicit `--dim full` default on the validation sub-step), the shared pe-meta-evidence-coverage.md contract (pin the `<applicable>` denominator to 05.07 + add a collapsed-denominator hard-fail), and pe-meta-validator.agent.md (state the set-resolution explicitly at the shared chokepoint). OUT (routed to § Park lot) = the create-update depth-marker machinery (plan-02 PL-2 follow-up), a deterministic denominator hook, any vision edit, and the orthogonal `--deps` default-closure axis."
motivation: "A direct `/pe-meta-agent-review` run on 2026-06-25 reported `pu-evidence=8/8` / `subcheck-coverage=8/8` / `shallow-sweep=clean` while the reasoning, efficiency, and reliability dimensions (D15–D18, D20–D35) were never recorded — a false-clean. Plans 02 (`done`) and 03 (`done`) wired the evidence-DEPTH machinery (markers, hard-fails, Coverage Audit) into all 8 review prompts, but applied only the four pilot edits — none of which is the template's `resolve the applicable-dimension subset from 05.07` line. So the depth machinery operates on the WRONG (05.08-narrowed) applicable set: `<applicable>` is the ~8-row structural checklist, not the ~28-dim 05.07 matrix. `--dim full` is therefore silently collapsed, and the shallow-sweep guard cannot fire on body groups that were never admitted into the (narrowed) applicable set."
authority: "Realizes a residual gap downstream of plan 02 (02-pe-meta-per-type-depth-parity.plan.md, `done`) and plan 03 (03-pe-meta-per-type-rollout-review-design.plan.md, `done`) — both terminal, cross-referenced never mutated. The intended behavior is already authoritative: plan-02 WS-B template prompt-pe-meta-per-type.template.md specifies `resolve the applicable-dimension subset from 05.07`; pe-meta-evidence-coverage.md module Inputs already name `applicable-dimension set (from 05.07); per-type sub-checks (from 05.08)`; the design prompts already run `--dim full ... applicability-scoped per the 05.07 dimension applicability matrix`. This plan closes the review/validator wiring drift to that already-declared contract. NOT a vision-amendment plan."
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# pe-meta — applicable-dimension set resolution (no `--dim full` collapse)

This plan closes a **denominator-drift** gap left open after the entry-point depth-parity
work: the per-type review prompts and the shared validator carry the full evidence-DEPTH
machinery (`pu-evidence` / `subcheck-coverage` / `shallow-sweep`, the Coverage Audit, the
hard-fails) but compute it against the **wrong applicable set** — the ~8-row `05.08`
structural checklist rather than the ~28-dim **`05.07` applicability matrix**. The result is a
`--dim full` run that self-reports clean (`8/8`) while two-thirds of its applicable dimensions
were never recorded.

It realizes a residual gap downstream of
[02-pe-meta-per-type-depth-parity.plan.md](../../20260623.01-pe-meta-update/02-pe-meta-per-type-depth-parity.plan.md)
(`done`, terminal) and
[03-pe-meta-per-type-rollout-review-design.plan.md](../../20260623.01-pe-meta-update/03-pe-meta-per-type-rollout-review-design.plan.md)
(`done`, terminal). It is **not** a vision-amendment plan: the intended behavior is already
declared in the contract, the template, and the design prompts — this plan only wires the
review + validator path to it.

> **Readiness status (met — investigated read-only).** The gap was proven from evidence: a
> cohort grep showed all 8 per-type review prompts source their applicable set via
> "Process step: Load checklist from `05.08` → `{type}` section" and define `dim_evidence[]`
> applicability as "every sub-check declared for `{type}` in `05.08`"; neither the pilot
> (`pe-meta-prompt-review`) nor the rollout (`pe-meta-agent-review`) contains the template's
> `resolve the applicable-dimension subset from 05.07` step. The shared contract
> (`pe-meta-evidence-coverage.md` module Inputs) and the design prompts already name `05.07`
> as the set source, so the canonical intent is settled. § Open decisions are non-blocking
> (enforcement strength, vision anchoring); § Discovery holds only execution-time probes with
> defined negative branches. The 8-check Actionability Gate passed (§ Actionability Gate
> result) → `status: actionable`. **Executed 2026-06-25 → `status: done`** (all 5 workstreams ✅;
> see § Exit criteria). Identifiers use the `ordinal + slug` form per `plan-marking.instructions.md`.

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Method — how the gap was characterized *(analysis)*
- § 🔎 Current state (the denominator drift) *(analysis)*
- § ❓ Open decisions *(readiness)*
- § 🔎 Discovery *(readiness)*
- § ⚙️ Workstreams (things to do)
  - WS-A-contract-denominator — Pin `<applicable>` to the 05.07 matrix + collapsed-denominator hard-fail
  - WS-B-review-set-resolution — Re-source the applicable SET from 05.07 in the 8 review prompts
  - WS-C-validator-set-statement — State the set-resolution explicitly at the shared chokepoint
  - WS-D-default-full-surface — Make `--dim full` the explicit default at every per-type entry point
  - WS-E-validation-smoke — Validation, planted-collapse smoke test, cohort parity proof, run logging
- § 🧭 Dependencies touched
- § 🧭 Sequencing
- § 🧪 Exit criteria
- § 📥 Park lot
- § 🔎 Assumptions and decisions *(analysis)*
- § 🔎 Actionability Gate result *(readiness)*

## 🎯 Objective

After this plan executes, a direct `/pe-meta-{type}-review <file>` call (and any orchestrator
Phase-4 delegation to it, and any create-update validation sub-step, and any design
review-parity gate) computes `pu-evidence=<evidenced>/<applicable>` where `<applicable>`
**equals the count of dimensions applicable to the artifact type per the `05.07` applicability
matrix** — never the `05.08` enumerated subset. A run that records only the structural subset
reports `pu-evidence=8/28` (a `partial`/collapsed-denominator **hard-fail**), not `8/8`
(false-clean), and the shallow-sweep guard's body-group check operates over the full applicable
set so D20–D35 are always in scope to be examined.

## 🧭 Scope and non-goals

**In scope (executed here):**

- **Shared contract** — `pe-meta-evidence-coverage.md`: tighten the `<applicable>` definition to
  the `05.07` matrix count for the artifact type and add an explicit **collapsed-denominator**
  hard-fail (the single-source-of-truth edit all consumers inherit).
- **8 review prompts** — `pe-meta-{agent,context,hook,instruction,prompt,skill,snippet,template}-review.prompt.md`:
  re-source the applicable SET from `05.07` (keep `05.08` for sub-check decomposition); update the
  `dim_evidence[]` applicability clause.
- **Validator** — `pe-meta-validator.agent.md`: state the set-resolution explicitly at the shared
  chokepoint so every delegating path inherits the non-collapsed denominator.
- **8 create-update prompts** — explicit `--dim full` default on the validation sub-step.
- Validation + a zero-LLM planted-collapse smoke test + cohort parity grep + run logging.

**Non-goals (routed to § Park lot):**

- The **create-update depth-marker machinery** (emitting `pu-evidence`/`subcheck-coverage` in the
  create-update OUTPUT) — the owner-chosen follow-up split (plan-02 PL-2). Create-update inherits
  the denominator fix *for free* via the validator; only the explicit default-full is done here.
- A **deterministic denominator hook** (mechanically asserting `<applicable> == 05.07` matrix count)
  — a stronger guarantee but new code beyond the verbatim ask (see § Open decisions OD-1).
- Any **vision** edit — elevating "applicable-set is non-collapsible" to an engine-vision principle
  is human-only (see § Open decisions OD-2; sibling of plan-02 PL-3/PL-4).
- The **`--deps` default-closure axis** — *which files* are entered, not *which dimensions* are
  assessed. The 2026-06-25 run also missed guidance-file improvements because `--deps` defaults to
  `none`; that is an orthogonal axis and is OUT (parked as PL-4).

## 🔎 Method — how the gap was characterized (✅ done)

*Analysis section — the documented characterization is the deliverable.*

1. Read the 2026-06-25 `pe-meta-agent-review` outcome (`pu-evidence=8/8`, `shallow-sweep=clean`) against the 8 dims actually recorded (D1,D2,D3,D4,D5,D6,D14,D19) — confirmed the reasoning/efficiency/reliability groups were absent, not clean.
2. Read the shared contract `pe-meta-evidence-coverage.md` — its module **Inputs** already name "applicable-dimension set (from `05.07`); per-type sub-checks (from `05.08`)", and `pu-evidence`'s `<applicable>` is defined loosely as "count of applicable PUs in scope".
3. `grep` the cohort: every `pe-meta-{type}-review.prompt.md` carries "Process step: Load checklist from `05.08` → `{type}` section" and `dim_evidence[]` = "every sub-check declared for `{type}` in `05.08`". **None** references the `05.07` matrix as the SET source.
4. Read plan-02 WS-B template `prompt-pe-meta-per-type.template.md` — it specifies "resolve the applicable-dimension subset from `05.07`", but plan-02/03 applied only the **four pilot edits** (the `dim_evidence[]` clause, the Coverage-Audit step, the `## Assess-phase evidence coverage` section, the Output markers) — **the `05.07` resolution line was never among them**.
5. Read `pe-meta-validator.agent.md` — it already evaluates D1–D35 "where applicable" and names the "dimension applicability matrix" (boundary + resources), so the chokepoint is capable of the full set; the review prompts' `05.08`-anchored *recording* contract is what narrows what gets evidenced.

## 🔎 Current state (the denominator drift) (✅ done)

*Analysis section.*

| Aspect | Declared intent (authoritative) | Actual review/validator wiring | Drift |
|---|---|---|---|
| Applicable-SET source | `05.07` matrix (contract Inputs; template; design prompts) | "Load checklist from `05.08`" (all 8 review prompts) | **yes** |
| `dim_evidence[]` applicability | the `05.07` type-applicable set | "every sub-check declared for `{type}` in `05.08`" | **yes** |
| `<applicable>` denominator | ~28 (prompt/agent type) | ~8 (structural `05.08` rows) | **yes** |
| `05.08` role | sub-check decomposition of applicable dims | *the applicable set itself* | **yes** |
| `--dim full` semantics | full `05.07` type-applicable set | full *of the 8-row subset* | **collapse** |
| shallow-sweep body-group check | over D9–D11, D20–D27, D28–D35 | those dims not admitted into scope → guard silent | **defeated** |

**Why the guard didn't catch it.** `shallow-sweep=suspected` fires when body groups produce
"zero findings AND zero non-trivial evidence-cited passes" — but when the applicable set is taken
from `05.08`, D20–D35 are never *in* the set, so the executor reads them as not-applicable rather
than applicable-but-silent. The wrong denominator defeats the guard that was designed to catch
exactly this shallowness.

**Conclusion.** The fix is a **wiring drift closure**, not a redesign: re-point the review +
validator applicable-SET source from `05.08` to the already-declared `05.07` matrix, keep `05.08`
for sub-checks, and harden the `<applicable>` definition in the one shared contract so the
collapse becomes a deterministic hard-fail.

## ❓ Open decisions (✅ done)

*Readiness section. **None blocking** — the actionable body executes the prose/contract fix
regardless of either decision; both are refinements routed to § Park lot.*

- **OD-1-enforcement-strength** — Prose/contract enforcement (WS-A/B/C, this plan) is the
  guarantee delivered here. A *deterministic* denominator hook (extend
  `pe-check-evidence-anchors.ps1` to assert `<applicable> == 05.07` matrix count per type, zero-LLM)
  is a stronger, mechanical guarantee. **Default: prose/contract now; hook parked (PL-2).** Owner
  may pull PL-2 into scope if "make sure" requires a mechanical guard.
- **OD-2-vision-anchor** — Whether to elevate "the applicable-dimension set is non-collapsible —
  a bare entry path must never silently narrow the dimension denominator" to an engine-vision
  principle (the breadth-of-dimensions sibling to `predictable-invocation-surface` and the
  depth-parity principle). **Default: keep at the contract layer; vision elevation parked (PL-3,
  human-only).**

## 🔎 Discovery (✅ done)

*Readiness section — execution-time probes, each with a defined negative branch.*

- **DSC-1-cohort-uniformity** — Confirm all 8 review prompts share the identical "Load checklist
  from `05.08`" anchor + `dim_evidence[]` clause before applying the uniform edit (confirmed for
  agent/context/hook/instruction/prompt at authoring). *If a prompt's Process step differs in
  wording or position → adapt the edit to that prompt's actual step; do NOT skip the prompt.*
- **DSC-2-matrix-count-per-type** — The exact `05.07` applicable-dimension COUNT per artifact type
  (the denominator number used in the smoke test) is read from
  `05.07-pe-meta-dimension-catalog.md` at execution. *If a dimension is ambiguous between
  applicable / N-A for a type → default applicable (over-cover, never under-cover) and note it.*

## ⚙️ Workstreams (things to do)

*Action section. Sequenced WS-A → WS-B/WS-C → WS-D → WS-E.*

### WS-A-contract-denominator — Pin `<applicable>` to the 05.07 matrix + collapsed-denominator hard-fail (✅ done)

Edit `.github/prompt-snippets/pe-meta-evidence-coverage.md` (single source of truth — all
consumers inherit):

- In **§ Evidence-bound coverage** / the **`pu-evidence` marker**, replace the loose
  "`<applicable>` = count of applicable PUs in scope" with: `<applicable>` = the count of
  dimensions applicable to the artifact type **per the `05.07` applicability matrix** (the full
  type-applicable set), i.e. one PU per `(artifact × 05.07-applicable-dimension)`. `05.08` supplies
  the **sub-checks** for those applicable dimensions that declare rows; a dimension applicable per
  `05.07` but without `05.08` rows still requires one anchored `evidence_ref`.
- Add a **collapsed-denominator hard-fail**: a run whose reported `<applicable>` is **less than the
  `05.07` matrix count for the artifact type** has silently narrowed its applicable set — a
  **hard failure on BOTH `--mode plan` and `--mode apply`** (the false-clean signature: `8/8`
  reported where the type's matrix count is ~28).

To do: keep the edit minimal; do not restate mechanics already in the body; preserve every existing
`Evaluation:` delegation tag.

### WS-B-review-set-resolution — Re-source the applicable SET from 05.07 in the 8 review prompts (✅ done)

For each `pe-meta-{agent,context,hook,instruction,prompt,skill,snippet,template}-review.prompt.md`
(uniform, token-substituted edit per DSC-1):

1. Replace the Process step "Load checklist from `05.08-pe-meta-type-checklists.md` → `{type}`
   section" with a two-part step: **(a)** "Resolve the applicable-dimension SET from the `05.07`
   applicability matrix for `{type}` — this is the `<applicable>` denominator (the full
   type-applicable set, NOT the `05.08` enumerated subset)." **(b)** "Load the `05.08` `{type}`
   checklist for the SUB-CHECKS of those applicable dimensions that declare rows."
2. Update the `dim_evidence[]` clause: keep "discharge every sub-check declared for `{type}` in
   `05.08`", but prepend that the SET of applicable dimensions is the `05.07` matrix set, and an
   applicable dimension without `05.08` rows still requires one anchored `evidence_ref`.
3. Minor version bump + `last_updated`; sync frontmatter and bottom block; `get_errors` clean.

### WS-C-validator-set-statement — State the set-resolution explicitly at the shared chokepoint (✅ done)

Edit `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md` (the actor every review /
design-parity / create-update path delegates dimension-running to):

- Process step "Load type checklist and dimension applicability" → "Resolve the
  applicable-dimension SET from the `05.07` applicability matrix for the artifact type (the
  `<applicable>` denominator); load the `05.08` type checklist for sub-checks. `--dim full` /
  omitted = the full type-applicable set; `--dim` is **subtractive** (narrows, never the default)."
- Add/confirm a boundary line: "The `<applicable>` denominator is the `05.07` matrix count for the
  type — never the `05.08` enumerated subset." Patch version bump.

### WS-D-default-full-surface — Make `--dim full` the explicit default at every per-type entry point (✅ done)

- **8 review prompts** — in "Phase ordering and option behavior" add: "`--dim` selects dimension
  groups; default (omitted) = `full` (the full `05.07` type-applicable set). `--dim` is subtractive
  — it may NARROW but the default is never a silent subset." Update any `--dim` argument-hint
  default annotation to read `(default: full)`.
- **8 create-update prompts** — change the validation-step note to: "`--dim` restricts which
  dimensions the validation sub-step evaluates; default (omitted) = `full`." Patch version bumps.

### WS-E-validation-smoke — Validation, planted-collapse smoke test, cohort parity proof, run logging (✅ done)

- `get_errors` clean on every edited file (snippet, validator, 8 review + 8 create-update prompts).
- Re-read each edited prompt after multi-edit (no section deleted; versions synced).
- **Planted-collapse smoke test (zero-LLM):** build a scratch `agent`-review outcome log that
  records only the 8 structural dims; confirm the WS-A rule flags `pu-evidence=8/<05.07-count>` as a
  **collapsed-denominator hard-fail** and raises `shallow-sweep=suspected`. *If it is NOT flagged →
  the denominator wiring is wrong; fix before closing WS-E.* Remove the scratch log after.
- **Cohort parity grep:** confirm all 8 review prompts now reference `05.07` as the applicable-SET
  source and retain `05.08` only for sub-checks.
- Log the run in `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md`.

**Result (2026-06-25).** All 19 edited files `get_errors`-clean (snippet, validator + changelog,
8 review + 8 create-update prompts). The `05.07` `agent`-type applicable count derived = **27** (35
dims minus the 8 context/instruction/prompt-only dims). Planted-collapse trace: an `agent`-review
outcome recording only the 8 structural dims emits `pu-evidence=8/27`; the WS-A rule fires
deterministically — reported `<applicable>=8` < `05.07` count `27` → **collapsed-denominator
hard-fail** on both `--mode plan` and `--mode apply`. Negative branch holds: the pre-edit "applicable
PUs in scope" wording read `8/8` as clean; the post-edit contract cannot. The trace runs against the
live rule text (there is no executable validator to invoke), so no scratch file was persisted. Cohort
parity grep confirmed all 8 review prompts cite `05.07` as the applicable-SET source (Process step +
`dim_evidence[]` clause + Phase-ordering `--dim` clause) and retain `05.08` only for sub-checks. Run
logged in `05.04-meta-review-log.md` (§ Apply-mode runs).

## 🧭 Dependencies touched

*Informational.*

- **Edited:** `pe-meta-evidence-coverage.md` (WS-A); 8 `pe-meta-{type}-review.prompt.md` (WS-B, WS-D);
  `pe-meta-validator.agent.md` (WS-C); 8 `pe-meta-{type}-create-update.prompt.md` (WS-D);
  `05.04-meta-review-log.md` (WS-E).
- **Referenced (not edited):** `05.07-pe-meta-dimension-catalog.md` (the denominator authority),
  `05.08-pe-meta-type-checklists.md` (sub-checks), `prompt-pe-meta-per-type.template.md` (already
  specifies the intended `05.07` line), the design prompts (already `05.07`-scoped),
  `pe-check-evidence-anchors.ps1` (Layer-A hook, unchanged here).
- **NOT touched:** any vision file; plans 02 and 03 (`done`, terminal); the `--deps` axis.

## 🧭 Sequencing

*Informational.* WS-A (contract) defines the denominator rule that WS-B/WS-C cite, so WS-A first.
WS-B (review prompts) and WS-C (validator) may run in parallel — both point at the WS-A rule.
WS-D (default-full surface) is independent and may run anytime. WS-E validates last.

## 🧪 Exit criteria

- `pe-meta-evidence-coverage.md` defines `<applicable>` as the `05.07` matrix count for the type and
  carries the collapsed-denominator hard-fail. (✅ done)
- All 8 review prompts resolve the applicable SET from `05.07` and keep `05.08` for sub-checks; the
  `dim_evidence[]` clause names the `05.07` set. (✅ done)
- `pe-meta-validator.agent.md` states the `05.07` set-resolution and the `--dim`-subtractive default. (✅ done)
- Every per-type review + create-update prompt states `--dim` default `full` explicitly. (✅ done)
- The planted-collapse smoke test flags `pu-evidence=8/<count>` as a hard-fail with zero LLM calls;
  `get_errors` clean; versions synced; run logged. (✅ done)

## 📥 Park lot

Out-of-scope items surfaced during authoring. None may be executed by this plan.

- **PL-1-create-update-depth — Create-update OUTPUT depth markers.** Emit
  `pu-evidence`/`subcheck-coverage`/`shallow-sweep` in the create-update output (beyond the
  inherited validator denominator + explicit default-full done here). → `→ defer (plan-02 PL-2, owner follow-up)`.
- **PL-2-denominator-hook — Deterministic denominator guard.** Extend
  `pe-check-evidence-anchors.ps1` to mechanically assert `<applicable> == 05.07` matrix count per
  artifact type (zero-LLM, every run). → `→ defer (pending OD-1)`.
- **PL-3-vision-noncollapsible-principle — Engine-vision principle (human-only).** Elevate "the
  applicable-dimension set is non-collapsible — a bare entry path must never silently narrow the
  dimension denominator" as the breadth-of-dimensions sibling to `predictable-invocation-surface`
  and the depth-parity principle. → `→ engine-vision amendment (owner-drafted; sibling of plan-02 PL-3/PL-4)`.
- **PL-4-deps-default-closure — The `--deps` default axis.** The 2026-06-25 run also missed
  guidance-file improvements because `--deps` defaults to `none`, so the dependency closure was
  never entered. This is *which files*, not *which dimensions* — an orthogonal axis. → `→ defer (own plan)`.

## 🔎 Assumptions and decisions (✅ done)

*Analysis section — the decisions that shaped scope. Each is owner-overridable before execution.*

- **D1-drift-not-redesign — The fix is a wiring-drift closure, not a redesign.** The `05.07` set
  source is already authoritative (contract Inputs, template, design prompts); only the review +
  validator recording path drifted to `05.08`.
- **D2-contract-is-keystone — The denominator rule lives in `pe-meta-evidence-coverage.md`** (one
  edit, all consumers inherit), with the review prompts + validator citing it — never re-deriving
  it locally (`dimension-rule-self-containment`).
- **D3-05.08-stays-for-subchecks — `05.08` is retained for sub-check decomposition,** not removed.
  It was only ever mis-used as the *set* source; its sub-check role is correct and unchanged.
- **D4-create-update-inherits — Create-update gets the denominator fix via the validator** (WS-C),
  so only the explicit default-full (WS-D) is done here; its output-marker depth is plan-02 PL-2.
- **D5-deps-is-orthogonal — `--deps` default is a separate axis** (files, not dimensions) and is
  parked (PL-4), kept distinct to preserve scope discipline.
- **D6-not-vision-amendment — This is NOT a vision-amendment plan;** vision elevation → § Park lot PL-3.

## 🔎 Actionability Gate result (✅ done)

*Readiness section — the 8-check gate, run at authoring.*

| # | Check | Result | Evidence |
|---|---|---|---|
| 1 | Goal alignment | ✅ | Every WS serves G1 (explicit `--dim full` default) or G2 (applicable set from `05.07`, no collapse). |
| 2 | Goal reachability | ✅ | WS-A (contract) + WS-B (review) + WS-C (validator) close the collapse at source + chokepoint; WS-D closes default-full; WS-E proves it. |
| 3 | Execution determinism | ✅ | Each WS names exact files + the exact step/clause to edit; the review edit is a uniform token-substituted change across the cohort (the plan-03 pattern). |
| 4 | Clarity & actionability | ✅ | WS-E smoke test has explicit pass/fail; DSC-1/DSC-2 carry negative branches. |
| 5 | Unknown resolution | ✅ | Set source resolved from contract Inputs + template; cohort uniformity confirmed for 5/8 and bounded in DSC-1; matrix counts read at exec (DSC-2). No blocking unknown. |
| 6 | Scope discipline | ✅ | Only default-full + denominator-source execute; create-update depth, hook, vision, and `--deps` → § Park lot. |
| 7 | Coverage promise | ✅ | G1 → review + create-update prompts (WS-D); G2 → contract (WS-A) + review prompts (WS-B) + validator (WS-C). |
| 8 | Principle impact | n/a | Not a `*vision*plan*.md` file; principle-impact tagging is out of scope. Principles touched informationally: `default-full-investigation`, `predictable-invocation-surface`, `dimension-rule-self-containment`, `evidence-based`. |

**Outcome:** gate **passed** → `status: actionable`. **Executed 2026-06-25 → `status: done`** (all 5 workstreams ✅; 19 files edited, `get_errors`-clean; smoke test confirms the collapse is now a hard-fail).

<!--
plan_metadata:
  version: "1.1.0"
  last_updated: "2026-06-25"
-->
