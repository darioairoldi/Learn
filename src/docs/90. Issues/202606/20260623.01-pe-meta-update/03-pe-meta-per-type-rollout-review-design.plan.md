---
status: done
domain: "prompt-engineering"
goal: "Roll out the proven evidence-coverage technique module to the REVIEW and DESIGN families of the 7 remaining per-type pe-meta prompts (agent, context, hook, instruction, skill, snippet, template): bring each pe-meta-{type}-review to evidence-depth parity with the pe-meta-review orchestrator (the four pilot edits), and add the one-line technique-module reference clause to each pe-meta-{type}-design review-parity gate — applying the pattern proven on the `prompt` type in plan 02, with NO re-invention."
scope: "In = the 7 review prompts (full module treatment + minor version bump) and the 7 design prompts (one-line parity-gate clause + patch bump), plus validation, a zero-LLM planted-defect smoke test on one rolled-out type, and run logging. OUT (routed to § Park lot) = the create-update family depth parity (the owner-chosen follow-up plan), the `prompt` type (done in the pilot), and every vision edit (the engine-vision depth-parity principle, human-only — owner: out of scope for now)."
motivation: "Plan 02 piloted the technique-module pattern on the `prompt` type only and proved it (pe-meta-prompt-review now at v2.3.0 emits pu-evidence / subcheck-coverage / shallow-sweep and runs the independent Coverage Audit). A cohort grep confirms the other 7 types' review prompts are still v2.2.0 (2026-05-31) and carry NONE of the evidence-depth markers — so entry-point depth still depends on which command you invoke for 7 of 8 types. This plan rolls the proven, template-backed pattern across the review + design families; the create-update family is the owner-chosen follow-up split."
authority: "Realizes plan 02 § Park lot item PL-1-seven-type-rollout (the REVIEW + DESIGN slice; the create-update slice is deferred per the owner's review-first split). Applies, verbatim, the two artifacts plan 02 built: the technique-module contract header in pe-meta-evidence-coverage.md (plan 02 WS-A) and prompt-pe-meta-per-type.template.md (plan 02 WS-B). Realizes parent park-lot item PL-4-per-type-redesign from 01-pe-meta-design-review-improvement-plan.md (rollout phase). Plans 01 and 02 are both `done` and terminal — cross-referenced, never mutated."
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
---

# pe-meta per-type prompts — review + design rollout (PL-4 rollout, batch 1)

This plan rolls the **evidence-coverage technique module** out to the **review** and **design**
families of the **7 remaining per-type prompts** — `agent`, `context`, `hook`, `instruction`,
`skill`, `snippet`, `template`. It realizes plan 02 § Park lot item **PL-1-seven-type-rollout**
(review + design slice) by applying the pattern that plan 02
([02-pe-meta-per-type-depth-parity.plan.md](02-pe-meta-per-type-depth-parity.plan.md), `done`,
terminal) proved on the `prompt` type. The **create-update** family is the owner-chosen
**follow-up plan** and is routed to § Park lot.

> **Readiness status (met — investigated read-only).** The gap was proven and the edit patterns
> confirmed deterministic from evidence: a cohort read showed `pe-meta-agent-review` and
> `pe-meta-hook-review` are byte-identical in skeleton to the pilot's **pre-parity** shape (same
> four insertion anchors — Process step 5, the pre-"Generate severity-ranked report" step, the
> `## Risk Classification` boundary, the Output-contract markers), differing only in type-specific
> Process steps that stay untouched; and `pe-meta-agent-design` lacks **exactly** the one
> module-reference clause the pilot `pe-meta-prompt-design` carries in its Process step 6. The only
> per-type substitution is a single token (`prompt` → `{type}`). § Open decisions is empty;
> § Discovery holds only execution-time probes with defined negative branches. The 8-check
> Actionability Gate passed (§ Actionability Gate result) → `status: actionable`. Identifiers use
> the `ordinal + slug` form per `plan-marking.instructions.md`.

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Method — how the rollout pattern was confirmed *(analysis)*
- § 🔎 Current state (cohort gap) *(analysis)*
- § ❓ Open decisions *(readiness)*
- § 🔎 Discovery *(readiness)*
- § ⚙️ Workstreams (things to do)
  - WS-A-review-rollout — Apply the four pilot edits to the 7 review prompts
  - WS-B-design-clause — Add the module-reference clause to the 7 design prompts
  - WS-C-validation-smoke — Validation, planted-defect smoke test, cohort parity proof, run logging
- § 🧭 Dependencies touched
- § 🧭 Sequencing
- § 🧪 Exit criteria
- § 📥 Park lot
- § 🔎 Assumptions and decisions *(analysis)*
- § 🔎 Actionability Gate result *(readiness)*

## 🎯 Objective

After this plan executes, a direct `/pe-meta-{type}-review <file>` call for **every** type in
{agent, context, hook, instruction, skill, snippet, template} emits the **same** evidence-depth
markers (`pu-evidence`, `subcheck-coverage`, `shallow-sweep`) and runs the **same** independent
second-actor Coverage Audit as the `/pe-meta-review` orchestrator — and each
`/pe-meta-{type}-design` review-parity gate names the technique module it inherits depth from.
Entry-point depth parity then holds across **all 8 types** for the review + design families (the
`prompt` type was the plan-02 pilot). The create-update family follows in a sibling plan.

## 🧭 Scope and non-goals

**In scope (executed here):**

- **7 review prompts** — `pe-meta-{agent,context,hook,instruction,skill,snippet,template}-review.prompt.md` — receive the **four pilot edits** (Process step 5 `dim_evidence[]` clause; new Coverage-Audit Process step; `## Assess-phase evidence coverage` section after `## Risk Classification`; Output-contract coverage markers) + a minor version bump.
- **7 design prompts** — `pe-meta-{agent,context,hook,instruction,skill,snippet,template}-design.prompt.md` — receive the **one-line module-reference clause** in the existing Process step 6 review-parity gate + a patch version bump.
- Validation, a zero-LLM planted-defect smoke test on one rolled-out review type, a cohort-level parity grep, and run logging.

**Non-goals (routed to § Park lot):**

- The **create-update** family depth parity (8 prompts incl. the `pe-meta-create-update` orchestrator) — the owner-chosen follow-up split (PL-1).
- The **`prompt`** type — already done in the plan-02 pilot.
- Any **vision** edit — the engine-vision depth-parity principle and technique-module-layer naming are human-only; the owner placed them **out of scope for now** (PL-2).
- Any **non-evidence-coverage drift** found in the 7 prompts during the rollout — recorded and routed, never silently fixed (PL-3).

## 🔎 Method — how the rollout pattern was confirmed (✅ done)

*Analysis section — the documented confirmation is the deliverable.*

1. Re-read the **pilot target** `pe-meta-prompt-review.prompt.md` (v2.3.0, `done`) in full → captured the four edit anchors verbatim: Process step 5 records `dim_evidence[]`; a Coverage-Audit step precedes "Generate severity-ranked report"; the `## Assess-phase evidence coverage (entry-point depth parity)` section follows `## Risk Classification`; the Output contract heading + first-line log carry the three coverage markers.
2. Read **two lagging review prompts** of structurally different types — `pe-meta-agent-review` (markdown agent) and `pe-meta-hook-review` (script+config) — both v2.2.0 (2026-05-31). **Both share the pilot's pre-parity skeleton exactly**; they differ only in type-specific Process steps (agent: tool/handoff checks; hook: JSON-schema/trigger checks) and the CF-05 root, which are already type-correct and stay untouched. → the four edits are uniform and deterministic across the cohort.
3. Read the **design pilot** `pe-meta-prompt-design` (v2.3.1) and a lagging design prompt `pe-meta-agent-design` (v2.3.0) → the lagging one's Process step 6 review-parity gate is identical **except** it omits the single module-reference sentence. → the design edit is a one-sentence insertion, dependent on the same type's review edit landing first.
4. Confirmed the shared artifacts plan 02 built are present and reusable: the technique-module contract header in [pe-meta-evidence-coverage.md](.github/prompt-snippets/pe-meta-evidence-coverage.md) and [prompt-pe-meta-per-type.template.md](.github/templates/00.00-prompt-engineering/prompt-pe-meta-per-type.template.md).

## 🔎 Current state (cohort gap) (✅ done)

*Analysis section.*

| Type | `pe-meta-{type}-review` | Includes evidence module? | Coverage markers? | Coverage-Audit step? | `pe-meta-{type}-design` clause? |
|---|---|---|---|---|---|
| prompt *(pilot — done)* | v2.3.0 | ✅ | ✅ | ✅ | ✅ |
| agent | v2.2.0 | ❌ | ❌ | ❌ | ❌ |
| context | v2.2.0 (expected) | ❌ | ❌ | ❌ | ❌ |
| hook | v2.2.0 | ❌ | ❌ | ❌ | ❌ |
| instruction | v2.2.0 (expected) | ❌ | ❌ | ❌ | ❌ |
| skill | v2.2.0 (expected) | ❌ | ❌ | ❌ | ❌ |
| snippet | v2.2.0 (expected) | ❌ | ❌ | ❌ | ❌ |
| template | v2.2.0 (expected) | ❌ | ❌ | ❌ | ❌ |

*Rows marked "(expected)" are read per file at execution (DSC-2); agent and hook were read directly and confirm v2.2.0 with the pre-parity skeleton. The cohort split is "1 done (prompt) vs 7 lagging", confirmed by the grep that found the evidence-coverage snippet only in the two orchestrators, the validator, and the pilot prompt pair.*

## ❓ Open decisions (✅ done)

*Readiness section.* **None blocking.** The batching (review + design first, create-update as a
follow-up) and the vision deferral (out of scope for now) are owner decisions already made. Every
edit pattern is resolved from evidence (§ Assumptions and decisions). Closing all open decisions is
an Actionability-Gate precondition — met.

## 🔎 Discovery (✅ done)

*Readiness section — execution-time probes, each with a defined negative branch.*

- **DSC-1-type-token** — The single token substituted in each review prompt's `## Assess-phase evidence coverage` section is read per file: the sub-check-discharge sentence's `` `prompt` type `` → `` `{type}` type `` and the self-reference `/pe-meta-prompt-review` → `/pe-meta-{type}-review`. *If a prompt's `## Risk Classification` or `## Output contract …` heading text differs from the pilot's → anchor the insertion on the actual heading, do not force the pilot's exact heading string.*
- **DSC-2-version-base** — Each prompt's current `prompt_metadata.version` is read at execution; review bumps minor (2.2.0 → 2.3.0), design bumps patch from its **actual** base (do not assume 2.3.0). *If a prompt already carries the module (unexpected) → skip its edit and note it in the run log.*
- **DSC-3-section-survival** — After each multi-edit on a prompt, re-read it to confirm no heading was dropped (the documented multi-replace deletion risk). *If a heading vanished → restore it immediately before proceeding to the next file.*

## ⚙️ Workstreams (things to do) (✅ done)

*Action section.*

### WS-A-review-rollout — Apply the four pilot edits to the 7 review prompts (✅ done)

For **each** `pe-meta-{type}-review.prompt.md` in {agent, context, hook, instruction, skill,
snippet, template}, apply the four edits **lifted verbatim from the pilot**
[pe-meta-prompt-review.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-prompt-review.prompt.md),
substituting only the type token (DSC-1):

1. **Process step 5 clause.** Replace `Run selected dimensions via \`@pe-meta-validator\`` with the pilot's wording: `Run selected dimensions via \`@pe-meta-validator\`, recording \`dim_evidence[]\` (one anchored \`{dim, status, evidence_ref}\` per applicable dimension — passes included) per the § Assess-phase evidence coverage contract`.
2. **New Coverage-Audit Process step.** Insert, immediately **before** the final `Generate severity-ranked report` step (renumbering it): `Run the independent Coverage Audit (\`@pe-meta-validator\`, Coverage Audit mode) and reconcile \`pu-evidence\`/\`subcheck-coverage\`/\`shallow-sweep\`; apply the evidence-depth hard-fails before any clean health score`.
3. **`## Assess-phase evidence coverage (entry-point depth parity)` section.** Insert immediately **after** the `## Risk Classification` section, copied from the pilot — the module `#file:` include fence, the `dim_evidence[]` MANDATORY paragraph, the Independent Coverage Audit paragraph, the three Evidence-depth hard-fail bullets, and the Layer-A hook line — substituting `` `prompt` type `` → `` `{type}` type `` and `/pe-meta-prompt-review` → `/pe-meta-{type}-review`. Relative link paths are **identical** (all per-type prompts share the `.github/prompts/00.09-pe-meta/` folder) — no path adjustment.
4. **Output contract markers.** Rename the heading to `## Output contract (coverage + plan-file + spillover markers)`; extend the first-line `Resolved invocation:` log to append `| pu-evidence=<evidenced>/<applicable> | subcheck-coverage=<fully-covered-dims>/<applicable-dims> | shallow-sweep=<clean|suspected>`; add the marker-explanation bullet from the pilot.
5. **Version.** Bump bottom `prompt_metadata.version` 2.2.0 → **2.3.0** + `last_updated`.

**Untouched per type:** the type-specific Process steps (e.g. agent tool/handoff checks, hook
JSON-schema/trigger checks), the CF-05 root, and the `05.08` type-checklist reference — already
type-correct.

Done: all 7 review prompts edited (4 edits each) and bumped 2.2.0 → 2.3.0; cohort grep 8/8 (`## Assess-phase evidence coverage` section, `## Output contract (coverage + plan-file + spillover markers)` heading, the independent Coverage-Audit step, version 2.3.0); DSC-3 section-survival confirmed (`## Phase ordering and option behavior` survived 8/8, the `context` outlier on `## Lifecycle mode behavior` handled as expected).

### WS-B-design-clause — Add the module-reference clause to the 7 design prompts (✅ done)

For **each** `pe-meta-{type}-design.prompt.md`, into the **existing** Process step 6 review-parity
gate, insert the one sentence the pilot
[pe-meta-prompt-design.prompt.md](.github/prompts/00.09-pe-meta/pe-meta-prompt-design.prompt.md)
carries — placed **after** `identical to what \`/pe-meta-{type}-review\` runs.` and **before**
`The artifact is NOT done until this PASSes`:

> That review path includes the [assess/evidence-coverage technique module](../../prompt-snippets/pe-meta-evidence-coverage.md), so the design path inherits the same evidence depth (`pu-evidence`/`subcheck-coverage`/`shallow-sweep`) without re-inlining it.

Then bump `prompt_metadata.version` by **patch** from its actual base (DSC-2) + `last_updated`.

**Ordering constraint:** a type's design clause MUST land **after** that type's WS-A review edit —
the clause asserts "that review path includes the module", true only once the review prompt
includes it.

Done: all 7 design prompts received the one-line module-reference clause + patch bump 2.3.0 → 2.3.1; cohort grep 8/8 (clause + version). The clause is type-independent — no token substitution needed.

### WS-C-validation-smoke — Validation, smoke test, cohort parity proof, run logging (✅ done)

- `get_errors` clean on **all 14** edited prompts. (✅ done)
- Re-read each edited prompt after its multi-edit (DSC-3 — no section/heading deleted). (✅ done)
- Confirm `version`/`last_updated` bumped on each (review = 2.3.0; design = patch). (✅ done)
- **Planted-defect smoke test (zero-LLM), one rolled-out review type (agent):** plant a fabricated `evidence_ref` (mis-pointed `path:line` + quote) in a scratch outcome log; confirm `pe-check-evidence-anchors.ps1` flags it (`shallow-sweep=suspected`); remove the scratch log. The wiring is copied identically per type from the shared module, so one demonstration validates the cohort. *If the hook does not flag it → the wiring is wrong; fix before closing WS-C.* (✅ done — `smoke-test-pl4-20260624` over a valid `L52` anchor + a fabricated `L50` snippet → exactly one `literal-containment` HIGH, valid anchor clean, `verdict: suspected`; scratch log removed)
- **Cohort parity proof (the "grep the WHOLE cohort" discipline):** grep `.github/prompts/00.09-pe-meta/pe-meta-*-review.prompt.md` for the module `#file:` include + the three markers → all 8 types present; grep `pe-meta-*-design.prompt.md` for the module reference → all 8 types present. (✅ done — review family 8/8, design family 8/8)
- Log the run in [05.04-meta-review-log.md](.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) (one entry, e.g. `20260624-pe-meta-per-type-review-design-rollout`). If per-file `.changelog.md` siblings exist for any prompt, add an entry there too; otherwise the run log is the record. (✅ done — logged as `20260624-pe-meta-per-type-review-design-rollout`; no per-prompt `.changelog.md` siblings, run log is the record)

## 🧭 Dependencies touched

*Informational.*

- **Edited (14):** `pe-meta-{agent,context,hook,instruction,skill,snippet,template}-review.prompt.md` (WS-A); `pe-meta-{agent,context,hook,instruction,skill,snippet,template}-design.prompt.md` (WS-B).
- **Edited (1):** `05.04-meta-review-log.md` (WS-C run log).
- **Referenced (not edited):** `pe-meta-evidence-coverage.md` (the module + contract header — plan 02 WS-A), `prompt-pe-meta-per-type.template.md` (plan 02 WS-B), `pe-meta-prompt-review.prompt.md` + `pe-meta-prompt-design.prompt.md` (the verbatim pilot sources), `05.07-pe-meta-dimension-catalog.md`, `05.08-pe-meta-type-checklists.md`, `04.05-pe-meta-invocation-gates.md`, `pe-meta-validator.agent.md`, `pe-check-evidence-anchors.ps1`.
- **NOT touched:** any vision file; the create-update family prompts; `01-…-plan.md` and `02-…-plan.md` (both `done`, terminal).

## 🧭 Sequencing

*Informational.* Per type: WS-A (review) → WS-B (design clause). Process all 7 types, then WS-C
(validation + smoke + cohort grep + log). The per-type review-before-design order is the only hard
constraint (WS-B's clause depends on WS-A's module inclusion); types are otherwise independent and
may be processed in any order.

## 🧪 Exit criteria

- All **7 review prompts** include the evidence-coverage module, record `dim_evidence[]` on Process step 5, carry the Coverage-Audit Process step, host the `## Assess-phase evidence coverage` section, emit the three coverage markers, and sit at v2.3.0. (✅ done)
- All **7 design prompts** carry the one-line module-reference clause in their Process step 6 review-parity gate and have a patch-bumped version. (✅ done)
- The planted-defect smoke test flags a fabricated anchor (`shallow-sweep=suspected`) with zero LLM calls. (✅ done)
- The cohort grep confirms **8/8** types present for both the review-module include and the design-clause reference. (✅ done)
- `get_errors` clean on all 14 edited artifacts; versions/`last_updated` bumped; run logged in `05.04-meta-review-log.md`. (✅ done)

## 📥 Park lot

Out-of-scope items surfaced during authoring. None may be executed by this plan.

- **PL-1-create-update-family — Create-update family depth parity.** The 8 `pe-meta-{type}-create-update` prompts (+ the `pe-meta-create-update` orchestrator) must run the review-parity gate after writing and reach the same evidence depth. The owner-chosen review-first split makes this the immediate follow-up. → `→ 04-pe-meta-per-type-create-update-rollout.plan.md (will spawn after this plan)`.
- **PL-2-engine-vision-depth-principle — Add the entry-point depth-parity principle + technique-module-layer naming to the engine vision (human-only).** The depth-axis sibling to `predictable-invocation-surface`. → `→ defer (owner: out of scope for now)`.
- **PL-3-other-drift — Non-evidence-coverage drift found in the 7 prompts during rollout.** Any stale v15.4-alignment note, metadata desync, or other divergence is OUT of this tightly-scoped rollout — record and route, never silently fix (scope discipline). → `→ defer (surface in the run log; spawn a reconcile plan if material)`.

## 🔎 Assumptions and decisions (✅ done)

*Analysis section — the decisions that shaped scope. Each is owner-overridable before execution.*

- **D1-verbatim-pilot-pattern — The rollout copies the pilot edits verbatim, substituting one type token.** Rationale: plan 02 proved the pattern; the cohort read confirmed the 7 review prompts share the pilot's pre-parity skeleton exactly. Re-inventing per type would risk drift — the memory lesson is "apply the proven pattern, don't redesign."
- **D2-review-and-design-only — This plan covers review + design only; create-update is the follow-up.** Per the owner's explicit "split: review + design-verify family first, create-update family as a follow-up plan."
- **D3-vision-out-of-scope — No vision edit.** Per the owner's "PL3 is not in scope for the moment." The depth-parity principle stays parked.
- **D4-design-depends-on-review — Per type, the design clause lands after the review edit.** The clause asserts the review path includes the module — only true post-WS-A.
- **D5-one-smoke-demonstration — One planted-defect smoke test validates the cohort.** The Layer-A wiring is copied identically from the shared module per type, so a per-type smoke test would be redundant; the cohort grep covers presence across all 7.
- **D6-realizes-PL-1 — This plan realizes plan 02 § Park lot PL-1-seven-type-rollout (review + design slice).** Plan 02 is `done`/terminal and left untouched; this plan cross-references it.

## 🔎 Actionability Gate result (✅ done)

*Readiness section — the 8-check gate, run at authoring.*

| # | Check | Result | Evidence |
|---|---|---|---|
| 1 | Goal alignment | ✅ | `goal:` restates the owner's verbatim request — roll the proven module out to the review + design families of the 7 remaining types, no re-invention. |
| 2 | Goal reachability | ✅ | WS-A (review) → WS-B (design) → WS-C (validate/log) form an ordered chain reaching parity across all 8 types; no undocumented gap. |
| 3 | Execution determinism | ✅ | Each edit names the exact file, anchor, and verbatim text (lifted from the pilot); the only per-type variable is one token (DSC-1). |
| 4 | Clarity & actionability | ✅ | Verification carries explicit pass/fail (smoke → `suspected`; cohort grep → 8/8; `get_errors` clean); ambiguous probes live in § Discovery with negative branches. |
| 5 | Unknown resolution | ✅ | Edit-pattern uniformity, the design dependency, the template/contract reuse, and the cohort split were all resolved from read-only evidence; residual unknowns bounded in § Discovery. |
| 6 | Scope discipline | ✅ | Only the 14 review+design prompts execute; create-update, the `prompt` type, all vision edits, and any incidental drift → § Park lot. |
| 7 | Coverage promise | ✅ | Every in-scope deliverable names a landing: the 7 `*-review` prompts (WS-A), the 7 `*-design` prompts (WS-B), `05.04-meta-review-log.md` (WS-C). |
| 8 | Principle impact | n/a | Not a vision-amendment plan (`*vision*plan*.md` glob does not match); check out of scope. |

**Outcome:** gate **passed** → `status: actionable`. Awaiting the owner's go to execute (or proceeds immediately under the standing "proceed with PL4" instruction).

<!--
plan_metadata:
  version: "1.1.0"
  last_updated: "2026-06-24"
-->
