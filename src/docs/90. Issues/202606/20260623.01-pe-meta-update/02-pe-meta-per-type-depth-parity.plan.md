---
status: done
domain: "prompt-engineering"
goal: "Close the entry-point depth-parity gap for the pe-meta per-type prompts by (1) declaring the existing pe-meta-evidence-coverage contract as the FIRST named technique module (engine Assess phase) with an explicit invocation contract, (2) creating a per-type-meta prompt template that routes every per-type entry path through that module, and (3) piloting on the `prompt` type — bringing pe-meta-prompt-review to evidence-depth parity with the pe-meta-review orchestrator and confirming pe-meta-prompt-design reaches the same depth via its review-parity gate."
scope: "Pilot = the `prompt` type only: pe-meta-prompt-review.prompt.md (primary, the stale artifact) and pe-meta-prompt-design.prompt.md (parity-gate verification, light touch). Net-new shared artifacts: a technique-module contract header inside pe-meta-evidence-coverage.md and a new prompt-pe-meta-per-type.template.md. Rollout to the other 7 artifact types and the create-update family is OUT and routed to § Park lot. Vision edits are OUT (human-only); the engine-vision depth-parity principle amendment is the sequenced human-only follow-up routed to § Park lot."
motivation: "A direct /pe-meta-prompt-review call is measurably shallower than the /pe-meta-review orchestrator. pe-meta-prompt-review is v2.2.0 (2026-05-31) — it predates the evidence-depth layer (issue 20260607.01): no pu-evidence / subcheck-coverage / shallow-sweep markers, no graded verdict, no independent second-actor audit. Depth currently depends on the entry path. The vision's `predictable-invocation-surface` principle guards BREADTH (a bare request must never be silently narrowed) but has no DEPTH-axis sibling. This plan proves the technique-module pattern — extract from the working snippet, never design in a vacuum — on ONE type before any rollout."
authority: "The agreed three-layer architecture (engine phases / interchangeable technique modules / domain config). Home for the depth-parity principle: 06.00-idea/self-updating-engine/20260622.01-self-updating-engine-vision.md (draft v1.0.0), as the depth-axis sibling to predictable-invocation-surface — a human-only amendment sequenced AFTER this plan. Realizes parent-plan park-lot item PL-4-per-type-redesign."
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# pe-meta per-type prompts — entry-point depth parity (PL-4 pilot)

This plan closes the **entry-point depth-parity** gap for the pe-meta per-type prompts:
today the depth of a review depends on *which command you invoke*. It realizes park-lot
item **PL-4-per-type-redesign** from
[01-pe-meta-design-review-improvement-plan.md](01-pe-meta-design-review-improvement-plan.md)
(that plan is `done` and is left untouched — terminal).

It is **not** a vision-amendment plan (per D5-not-vision-amendment). It frames the existing
[pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md)
contract as the **first named technique module** and routes the per-type entry paths through it.
The vision-level naming of the technique-module *layer* (and the depth-parity principle) is a
human-only engine-vision amendment, sequenced next per the owner's decision and routed to § Park lot.

> **Readiness status (done — executed 2026-06-24).** Readiness closed via read-only
> evidence: the gap was proven (pe-meta-prompt-review v2.2.0 lacked every evidence-depth marker the
> pe-meta-review orchestrator carries; a grep confirmed zero per-type prompts included the
> evidence-coverage snippet). All in-scope decisions were resolved (§ Assumptions and decisions);
> § Open decisions is empty; § Discovery held only execution-time probes with defined negative
> branches. The 8-check Actionability Gate passed (§ Actionability Gate result). **Executed** —
> WS-A…WS-D complete; pe-meta-prompt-review at v2.3.0 with full evidence-depth parity; run logged.
> Identifiers use the `ordinal + slug` form per `plan-marking.instructions.md`.

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Method — how the gap was characterized *(analysis)*
- § 🔎 Current state (gap landscape) *(analysis)*
- § ❓ Open decisions *(readiness)*
- § 🔎 Discovery *(readiness)*
- § ⚙️ Workstreams (things to do)
  - WS-A-module-contract — Declare evidence-coverage as the first technique module (Assess)
  - WS-B-per-type-template — Create the per-type-meta prompt template
  - WS-C-prompt-pilot — Bring pe-meta-prompt-review to evidence-depth parity; verify the design path
  - WS-D-validation-smoke — Validation, planted-defect smoke test, run logging
- § 🧭 Dependencies touched
- § 🧭 Sequencing
- § 🧪 Exit criteria
- § 📥 Park lot
- § 🔎 Assumptions and decisions *(analysis)*
- § 🔎 Actionability Gate result *(readiness)*

## 🎯 Objective

Deliver the three artifacts the owner named — **shared single-file audit contract + per-type-meta
template + one-type pilot** — with the shared audit contract framed explicitly as the **first
technique module** in the engine's Assess phase. After this plan executes, a direct
`/pe-meta-prompt-review <file>` call emits the **same** evidence-depth markers
(`pu-evidence`, `subcheck-coverage`, graded verdict, `shallow-sweep`) and runs the **same**
independent second-actor audit as the `/pe-meta-review` orchestrator — proving entry-point
depth parity on one type before any rollout.

## 🧭 Scope and non-goals

**In scope (executed here):**

- A **technique-module contract header** added to `pe-meta-evidence-coverage.md` (no new file).
- A new **`prompt-pe-meta-per-type.template.md`** skeleton under `.github/templates/00.00-prompt-engineering/`.
- The **`prompt`-type pilot**: `pe-meta-prompt-review.prompt.md` brought to evidence-depth parity;
  `pe-meta-prompt-design.prompt.md` verified to reach the same depth via its review-parity gate.
- Validation + a zero-LLM planted-defect smoke test + run logging.

**Non-goals (routed to § Park lot):**

- Rollout to the other 7 artifact types (agent, context, hook, instruction, skill, snippet, template).
- The create-update family depth parity.
- Any **vision** edit — including naming the technique-module layer and adding the depth-parity
  principle to the engine vision (human-only, sequenced next).
- Promoting technique modules to a first-class file type (they remain prompt-snippets here).

## 🔎 Method — how the gap was characterized (✅ done)

*Analysis section — the documented characterization is the deliverable.*

1. Listed `.github/prompts/00.09-pe-meta/` → confirmed **24 per-type prompts** (`pe-meta-{type}-{create-update|design|review}` across 8 types) plus the orchestrators.
2. Read the proto-module `pe-meta-evidence-coverage.md` in full — a complete single-file audit contract (evidence-bound coverage, mandatory machine anchor, graded verdict, two-layer verification, independent audit, delegation tags, shallow-sweep guard).
3. `grep` for `pe-meta-evidence-coverage` across `.github/**` → it is included **only** by `pe-meta-review` (orchestrator), `pe-meta-design` (orchestrator), and `pe-meta-validator`. **Zero per-type prompts reference it.**
4. Read the pilot candidates: `pe-meta-prompt-review.prompt.md` (v2.2.0, 2026-05-31) and `pe-meta-prompt-design.prompt.md` (v2.3.0, 2026-06-22).
5. Read `artifact-type-dispatch.template.md` → the existing model for type→dimension dispatch the new template will mirror.

## 🔎 Current state (gap landscape) (✅ done)

*Analysis section.*

| Aspect | Orchestrator `pe-meta-review` | Per-type `pe-meta-prompt-review` (v2.2.0) | Gap |
|---|---|---|---|
| Includes the evidence-coverage contract | ✅ (lines 737, 929, 956, 977, 979) | ❌ never references it | **yes** |
| `dim_evidence[]` outcome log (passes included) | ✅ MANDATORY | ❌ absent | **yes** |
| First-line markers | `pu-evidence`, `subcheck-coverage`, `shallow-sweep` | only `plan-file=`, `spillover=` | **yes** |
| Evidence-depth hard-fail (plan + apply) | ✅ Phase-8 linter rule 4 | ❌ absent | **yes** |
| Graded verdict (`verified/pass-weak/partial/fail`) | ✅ rule 6 | ❌ absent | **yes** |
| Independent second-actor audit | ✅ `@pe-meta-validator` Coverage Audit before clean | partial — `Validate` handoff exists but no audit-before-clean contract | **yes** |
| Layer-A hook delegation | ✅ `pe-check-evidence-anchors.ps1` | ❌ not wired | **yes** |

**Asymmetry within the type:** `pe-meta-prompt-design` (v2.3.0) reaches depth *indirectly* — its
**review-parity gate** (boundary + Process step 6) runs `--dim full` via `@pe-meta-validator`,
which *does* use the contract. `pe-meta-prompt-review` has no such path. So even within one type,
design and review diverge in depth (the construction-lag pattern: the laggard keeps the older shape).

**Conclusion:** the audit-depth contract is the engine's **Assess-phase realization**; the per-type
entry paths simply don't invoke it. Framing it as a named technique module and routing the entry
paths through it is the minimal, evidence-grounded fix.

## ❓ Open decisions (✅ done)

*Readiness section.* **None blocking.** Every in-scope decision was resolved from read-only evidence
during readiness and recorded in § Assumptions and decisions (D1–D6), each flagged owner-overridable
before execution begins. Closing all open decisions is an Actionability-Gate precondition — met.

## 🔎 Discovery (✅ done)

*Readiness section — execution-time probes, each with a defined negative branch.*

- **DSC-1-applicable-dim-set** — The exact applicable-dimension subset for the `prompt` type is read from `05.07-pe-meta-dimension-catalog.md` + `05.08-pe-meta-type-checklists.md` at execution. *If a dimension is ambiguous between applicable/N-A → default applicable (over-cover, never under-cover) and note it.*
- **DSC-2-second-actor-handoff-shape** — Whether `pe-meta-prompt-review`'s existing `Validate → pe-meta-validator` handoff can carry the Coverage-Audit `--audit <log>` contract unchanged. *If the handoff signature differs → add the explicit Coverage-Audit invocation line, do not redesign the handoff.*
- **DSC-3-template-line-budget** — Whether the per-type-meta skeleton fits the ≤100-line template budget once it carries gates + module inclusion + dispatch. *If it exceeds 100 lines → reference (not inline) the invocation-gate and module mechanics, keeping only the skeleton.*

## ⚙️ Workstreams (things to do) (✅ done)

*Action section. All workstreams executed and verified.*

### WS-A-module-contract — Declare evidence-coverage as the first technique module (Assess) (✅ done)

Add a concise **`## Technique module contract`** header to
[pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md)
declaring (no new file — single source of truth preserved):

- **Module id:** `assess/evidence-coverage` — **engine phase:** Assess.
- **Inputs:** in-scope artifact set; applicable-dimension set (from `05.07`); per-type sub-checks (from `05.08`); `--mode plan|apply`.
- **Outputs:** the `dim_evidence[]` outcome log; first-line markers `pu-evidence=<e>/<a>`, `subcheck-coverage=<ev>/<decl>` per dim, graded verdict, `shallow-sweep=<clean|suspected>`; the hard-fail conditions.
- **Invocation contract:** a consumer MUST (a) `#file:`-include this snippet, (b) emit the markers on its first-line `Resolved invocation:` log, and (c) hand the outcome log to the **independent second actor** (`@pe-meta-validator` Coverage Audit) before declaring a clean health score.
- **Cost tier:** deterministic Layer A (zero-LLM, every PU, `Evaluation: hook:.github/hooks/scripts/pe-check-evidence-anchors.ps1`) + sampled Layer B (reasoning).
- A one-line note: *"technique module" is an implementation-layer label realized by this snippet; the vision-level layer definition is a sequenced human-only engine-vision amendment (§ Park lot PL-3/PL-4).*

To do: keep the header minimal; do not restate the mechanics already in the body. Preserve every existing `Evaluation:` delegation tag.

### WS-B-per-type-template — Create the per-type-meta prompt template (✅ done)

Create **`.github/templates/00.00-prompt-engineering/prompt-pe-meta-per-type.template.md`** — a
skeleton for `pe-meta-{type}-{review|create-update}` prompts (design reaches depth via its parity
gate). Modeled on the orchestrator's structure, trimmed to single-file/degenerate scope. It bakes in:

- **Phase 0a CF-05 + Phase 0b** invocation gates (reference `04.05-pe-meta-invocation-gates.md`, don't inline).
- **Type dispatch:** load `05.08` → `{type}` checklist; resolve the applicable-dimension subset from `05.07`.
- **Technique-module inclusion:** `#file:.github/prompt-snippets/pe-meta-evidence-coverage.md`.
- **First-line `Resolved invocation:` log** carrying `pu-evidence`, `subcheck-coverage`, `shallow-sweep` (alongside the existing `plan-file=`/`spillover=`).
- **Independent second-actor audit** handoff (`@pe-meta-validator` Coverage Audit) before clean.
- **Output contract** pointing at the right `output-*` template.

To do: `.template.md` extension, `prompt-` category prefix, documented placeholders, ≤100 lines (per DSC-3 negative branch if over budget).

### WS-C-prompt-pilot — Bring pe-meta-prompt-review to parity; verify the design path (✅ done)

1. Apply the WS-B template to
   [pe-meta-prompt-review.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-prompt-review.prompt.md):
   include the technique module; add the evidence-depth phase (emit `dim_evidence[]` — passes
   included, non-empty `evidence_ref`); extend the first-line log with the three markers; add the
   single-file evidence-depth hard-fail + shallow-sweep block; wire the second-actor Coverage Audit
   before clean. Bump `version` 2.2.0 → 2.3.0 + `last_updated`; sync frontmatter and bottom block. (✅ done — v2.3.0, 2026-06-24; version lives in the bottom block only, no frontmatter desync)
2. Verify [pe-meta-prompt-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-prompt-design.prompt.md):
   confirm its review-parity gate (Process step 6 + boundary) genuinely routes `--dim full` through
   `@pe-meta-validator` (which uses the contract). Add a one-line explicit module reference for
   symmetry **only if** absent — light touch, no redesign. (✅ done — gate confirmed; module reference was absent, added one line; v2.3.0 → 2.3.1)
3. **Smoke test (zero-LLM):** plant a fabricated `evidence_ref` (mis-pointed `path:line` + quote) in
   a scratch outcome log; confirm `pe-check-evidence-anchors.ps1` and the review prompt's new gate
   catch it (`shallow-sweep=suspected`). *If the hook does not flag it → the wiring is wrong; fix
   before closing WS-C.* (✅ done — one `literal-containment` HIGH violation on the fabricated row, `verdict: suspected`; scratch log removed)

### WS-D-validation-smoke — Validation, smoke test, run logging (✅ done)

- `get_errors` clean on every edited file (snippet, template, both pilot prompts). (✅ done)
- Re-read each edited prompt after multi-edit (no section deleted). (✅ done)
- Confirm frontmatter `version`/`last_updated` match the bottom-block metadata. (✅ done — both pilot prompts carry version only in the bottom block; no top-frontmatter version field to desync)
- Log the run in `05.04-meta-review-log.md`. (✅ done — entry `20260624-pe-meta-per-type-depth-parity` under Apply-mode runs)
- **Parity proof:** capture a before/after of the `pe-meta-prompt-review` first-line log showing the three evidence markers now present — the concrete demonstration that entry-point depth parity holds on the pilot type. (✅ done — first-line log now appends `pu-evidence`/`subcheck-coverage`/`shallow-sweep`; recorded in the run-log entry)

## 🧭 Dependencies touched

*Informational.*

- **Edited:** `pe-meta-evidence-coverage.md` (WS-A); `pe-meta-prompt-review.prompt.md`, possibly `pe-meta-prompt-design.prompt.md` (WS-C); `05.04-meta-review-log.md` (WS-D).
- **Created:** `prompt-pe-meta-per-type.template.md` (WS-B).
- **Referenced (not edited):** `05.07-pe-meta-dimension-catalog.md`, `05.08-pe-meta-type-checklists.md`, `04.05-pe-meta-invocation-gates.md`, `pe-meta-validator.agent.md`, `pe-check-evidence-anchors.ps1`, the `pe-meta-review.prompt.md` orchestrator (depth reference).
- **NOT touched:** any vision file; `01-pe-meta-design-review-improvement-plan.md` (done, terminal).

## 🧭 Sequencing

*Informational.* WS-A → WS-B → WS-C → WS-D. WS-A defines the contract the template (WS-B) embeds;
the pilot (WS-C) applies the template; validation (WS-D) proves it. WS-C step 2 (design verification)
may run in parallel with step 1.

## 🧪 Exit criteria

- The technique-module contract header is present in `pe-meta-evidence-coverage.md` and names phase, inputs, outputs, invocation, and cost tier. (✅ done)
- `prompt-pe-meta-per-type.template.md` exists, fits the template budget, and embeds the module inclusion + markers + second-actor audit. (✅ done — 85 lines)
- `pe-meta-prompt-review` emits `pu-evidence` / `subcheck-coverage` / `shallow-sweep` and runs the Coverage Audit before clean — byte-for-byte the orchestrator's evidence-depth surface. (✅ done — v2.3.0)
- The planted-defect smoke test flags a fabricated anchor (`shallow-sweep=suspected`) with zero LLM calls. (✅ done — one `literal-containment` HIGH violation, `verdict: suspected`)
- `get_errors` clean on all edited artifacts; versions synced; run logged. (✅ done)

## 📥 Park lot

Out-of-scope items surfaced during authoring. None may be executed by this plan.

- **PL-1-seven-type-rollout — Apply the module + template to the other 7 types.** Each of agent/context/hook/instruction/skill/snippet/template × {review, create-update} routed through the technique module once the pilot validates the pattern. → `→ defer (own plan after pilot)`.
- **PL-2-create-update-family — Create-update family depth parity.** The writing family must run the review-parity gate after writing; bring it to the same evidence depth. → `→ defer`.
- **PL-3-engine-vision-depth-principle — Add the entry-point depth-parity principle to the engine vision (human-only).** The depth-axis sibling to `predictable-invocation-surface`: a bare entry path must never silently receive shallower processing than the orchestrator. → `→ engine-vision amendment (owner-drafted, sequenced next)`.
- **PL-4-technique-module-layer-naming — Name the technique-module layer + phase extension-points in the engine vision (human-only).** Formalize the third architecture layer (engine / technique modules / domain config) and the phase→module selection seam. → `→ defer (same amendment as PL-3 or sibling)`.
- **PL-5-technique-module-file-type — Whether technique modules become a first-class file type.** They remain prompt-snippets here; promoting them to a dedicated artifact type with its own instruction/template is an architecture decision. → `→ defer`.
- **PL-6-snippet-word-budget — pe-meta-evidence-coverage.md already exceeds the ≤500-word snippet budget (pre-existing).** Whether to split the contract from the mechanics is independent of this plan. → `→ defer`.

## 🔎 Assumptions and decisions (✅ done)

*Analysis section — the decisions that shaped scope. Each is owner-overridable before execution.*

- **D1-pilot-type-prompt — Pilot = the `prompt` type.** Rationale: the `pe-meta-review` orchestrator is itself prompt-tier (clearest depth target); `pe-meta-prompt-review` v2.2.0 is the most clearly stale (pre-evidence-depth, 2026-05-31); `pe-meta-prompt-design` already reaches depth via its parity gate, giving a same-type design/review contrast; the gap is smoke-testable with a planted defect.
- **D2-technique-module-implementation-term — "Technique module" is an implementation organizing label** realized by the existing snippet. This plan coins no vision concept and edits no vision; the vision-level layer definition is human-only and sequenced (PL-3/PL-4).
- **D3-template-standalone — The per-type-meta template is a new standalone `prompt-pe-meta-per-type.template.md`,** not an extension of generic `prompt.template.md`, because per-type-meta prompts have a distinctive shape (invocation gates + module inclusion + second-actor audit + dimension dispatch).
- **D4-contract-header-inside-snippet — The module contract header lives inside `pe-meta-evidence-coverage.md`** (no new file), preserving single-source-of-truth. The snippet's pre-existing word-budget overage is unchanged (PL-6).
- **D5-not-vision-amendment — This is NOT a vision-amendment plan.** Like the parent, it implements a pattern into the implementation; vision edits → § Park lot.
- **D6-realizes-PL-4 — This plan realizes parent park-lot item PL-4-per-type-redesign** (was `→ defer`). The parent plan is `done` and left untouched (terminal); this plan cross-references it rather than mutating its disposition.

## 🔎 Actionability Gate result (✅ done)

*Readiness section — the 8-check gate, run 2026-06-24.*

| # | Check | Result | Evidence |
|---|---|---|---|
| 1 | Goal alignment | ✅ | `goal:` restates the owner's verbatim request (shared single-file audit contract + per-type-meta template + one-type pilot), framed as the first technique module. |
| 2 | Goal reachability | ✅ | WS-A→WS-D form an ordered chain from contract → template → pilot → proof; no undocumented gap. |
| 3 | Execution determinism | ✅ | Each WS names exact files + edits; depth elements lifted verbatim from the orchestrator (markers, hard-fail, graded verdict, second-actor audit). |
| 4 | Clarity & actionability | ✅ | Verification steps carry explicit pass/fail (smoke test → `suspected`; `get_errors` clean); ambiguous probes live in § Discovery with negative branches. |
| 5 | Unknown resolution | ✅ | Pilot type, contract location, template form, term scoping all resolved from evidence (§ Assumptions and decisions); residual unknowns bounded in § Discovery. |
| 6 | Scope discipline | ✅ | Only the `prompt` pilot + two shared artifacts execute; 7-type rollout, create-update, and all vision edits → § Park lot. |
| 7 | Coverage promise | ✅ | Every in-scope deliverable names a landing: `pe-meta-evidence-coverage.md` (WS-A), `prompt-pe-meta-per-type.template.md` (WS-B), `pe-meta-prompt-review.prompt.md` (WS-C). |
| 8 | Principle impact | n/a | Not a vision-amendment plan (`*vision*plan*.md` glob does not match); check is out of scope. |

**Outcome:** gate **passed** → `status: actionable`. Not started; awaiting the owner's go to execute.

<!--
plan_metadata:
  version: "1.0.0"
  last_updated: "2026-06-24"
-->
