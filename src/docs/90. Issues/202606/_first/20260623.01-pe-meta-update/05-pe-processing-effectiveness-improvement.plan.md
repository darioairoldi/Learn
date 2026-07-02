---
status: in-progress
domain: "prompt-engineering"
goal: "Make pe-meta (and the other pe-*) processing more efficient, effective, and reliable by (a) assessing how the .copilot/context/00.00-prompt-engineering guidance corpus supports that goal, and (b) deciding what to KEEP, what to CHANGE, and what to INTEGRATE — turning the assessment into committed workstreams once the owner resolves the open decisions below."
scope: "Analysis + proposal targeting the PE knowledge substrate under .copilot/context/00.00-prompt-engineering/ and the runtime checks that consume it. Candidate edit targets (NOT yet committed — gated by § Open decisions): the capability map (00.02) + coverage-gap guard (rule 5 / Phase 7b check 6); the duplicated threshold/boundary/tool-alignment restatements vs their single sources (01.06, 01.04); a minimal activation slice of the parked eval-regression contract (05.10) + state substrate (05.09). OUT OF SCOPE: any vision edit (human-only); building the full eval/golden-case harness; verifying external model/platform staleness; splitting large files for token reasons (all → § Park lot)."
motivation: "Spun up from OD-1 (the parked cost/value review of the rule-5 coverage-gap guard, parked in 04-capability-map-modernization.plan.md § Park lot). Investigation showed OD-1 is one symptom of a systemic pattern: the corpus defines artifact QUALITY well (active, load-bearing) but the ENGINE that is supposed to deliver autonomous, measured self-update is parked (05.09, 05.10, 00.06 all proposed/spec-only), and several high-traffic facts are hand-maintained mirrors that drift (00.02 drifted → the entire PL-6 plan repaired it; 00.01 governance summary is older than the map it summarizes; thresholds/boundaries/tool-alignment restated across ~5 files). So today 'effective' is asserted (no eval gate), and 'efficient/reliable' are taxed by recurring mirror-maintenance and silent drift."
authority: "Vision 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md (v15.10) is the source of truth for the goal and principles (single-source-of-truth, deterministic-where-possible, evidence-based, progressive-learning, coverage-completeness-guarantee). The vision is human-only — this plan proposes context/script/prompt changes only and routes any vision wording to the owner. The capability map is governed by 00.01-governance-and-capability-baseline.md ('MUST NOT remove capability entries without explicit approval')."
context_dependencies:
  - ".copilot/context/00.00-prompt-engineering/"
  - ".copilot/context/00.00-prompt-engineering/05.11-plan-authoring-discipline.md"
---

# PE-* processing effectiveness improvement (actionable)

This plan turns the systemic assessment of the PE knowledge substrate
([.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/))
into committed workstreams that make `pe-meta` (and the other `pe-*`) processing more
**efficient, effective, and reliable**. It is the follow-up owner of **OD-1**, parked in
[04-capability-map-modernization.plan.md](04-capability-map-modernization.plan.md) § Park lot.

> **Readiness status (IN-PROGRESS).** All four open decisions (OD-A…OD-D) are resolved, both
> § Discovery items carry defined negative branches, and the 8-check Actionability Gate passed (see
> § ✅ Actionability gate). The plan was promoted `draft → actionable` then entered `in-progress` on
> 2026-06-25 when WS-B1 was executed. Execution proceeds in the OD-D sequence (WS-B → WS-A + WS-C →
> KEEP); remaining steps are suffix-marked `(🟡 todo)` in § ⚙️ Workstreams.

## 📋 Table of contents

- § 🎯 Objective
- § 🧭 Scope and non-goals
- § 🔎 Systemic findings *(grounding — informational)*
- § ❓ Open decisions *(readiness — gates scope)*
- § 🔎 Discovery *(undecidable until execution)*
- § ✅ Actionability gate *(promotion record)*
- § ⚙️ Workstreams (edit mapping) *(things to do)*
- § 🧪 Exit criteria *(things to do)*
- § 📥 Park lot

## 🎯 Objective

Move `pe-*` processing from a **structural-validation + hand-maintained-mirror** model toward a
**measurement + generation** model, without disturbing the parts that already work:

- **KEEP** the quality-definition + coverage backbone (it makes `pe-*` effective and reliable
  by construction).
- **CHANGE** the drift surfaces (hand-maintained mirrors → generated, referenced, or removed) so
  efficiency and reliability stop being taxed by recurring maintenance and silent staleness.
- **INTEGRATE** a minimal slice of the parked measurement substrate so "effective" becomes a
  measured property, not an assertion.

## 🧭 Scope and non-goals

**In scope (candidate — gated by § Open decisions):** edits within
`.copilot/context/00.00-prompt-engineering/`, a possible generation script under `scripts/` or a
hook, and a minimal activation of the eval-regression contract spec.

**Non-goals:** any vision edit (human-only); building the full golden-case eval harness;
verifying external model/platform staleness; token-driven file splits. All → § Park lot.

## 🔎 Systemic findings *(grounding — informational)*

The corpus does three jobs at very different maturity levels:

| Job | Representative files | Maturity |
|---|---|---|
| Define WHAT "good" is (quality definition) | 00.03, 01.06, 01.07, 05.07, 05.08 | Strong, active, load-bearing |
| Define HOW the engine processes (reliability backbone) | 04.05, coverage-ledger machinery, 04.01 | Strong, active |
| Actually deliver autonomous, measured self-update (the engine) | 05.09, 05.10, 00.06 | Parked / spec-only / proposed |

Three faults follow, all sharing one root cause (facts represented twice, or asserted instead of measured):

1. **Hand-maintained mirrors drift** — violates `single-source-of-truth` / `deterministic-where-possible`.
   00.02 mirrors on-disk agent topology (drifted → PL-6); 00.01 restates the capability summary and
   is older than 00.02; thresholds/boundaries/tool-alignment restated across ~5 files vs single
   sources 01.06 / 01.04. OD-1's rule 5 is the most visible instance.
2. **Validation is structural, not behavioral** — every active check verifies SHAPE (files resolve,
   frontmatter present, boundaries ≥3, tokens ≤budget, chains resolve on disk). None verifies an
   artifact still PRODUCES good output. So "effective" is a proxy, not a measure. Rule 5's
   "resolves on disk" is existence, not capability.
3. **The measurement substrate is inert** — 05.10 (golden-case "v(N+1) no worse than v(N)" gate) and
   05.09 (config/state) are written but unconsumed; the vision's `evidence-based` / `progressive-learning`
   demands rest on parked builds.

**Why this resolves the OD-1 indecision:** rule 5's *cost* belongs in CHANGE (generate the map,
demote rule 5 to a cheap deterministic existence lint); rule 5's *intended job* (prove a capability
still works) belongs in INTEGRATE (the eval gate). It was never a single keep/drop call.

## ❓ Open decisions *(readiness — gates scope)*

Each decision names what resolves it and which future workstream it gates. Any unresolved
decision keeps the plan `draft`.

- **OD-A-integrate-eval-slice** — Commit now to activating a *minimal* slice of the eval-regression
  contract (05.10) — e.g. one golden case per artifact-type on its single most load-bearing
  dimension, wired to the 05.09 state namespace — or keep it fully parked?
  *Resolved by:* owner decision. *Gates:* the INTEGRATE workstream. *Note:* the full harness stays
  parked regardless (→ § Park lot); this is a thin, falsifiable starter only.
  **✅ Decision (2026-06-25):** commit — activate the minimal slice (one golden case per artifact-type
  on its single most load-bearing dimension, wired to the 05.09 state namespace). Full harness stays parked.

- **OD-B-generate-capability-map** — Commit to deriving the capability-map chains (00.02) from the
  real on-disk prompt `handoffs:` + agent folders (so PL-6-class drift becomes impossible), and to
  demoting rule 5 / Phase 7b check 6 to a deterministic existence lint?
  *Resolved by:* owner decision + OD-B2. *Gates:* the CHANGE-mirror workstream.
  - **OD-B2-drift-enforcement** — If OD-B = yes, what makes drift **fail closed**? *(The original
    "manual script vs session hook" framing was rejected: both put the anti-drift guarantee on a
    human remembering or a soft trigger — exactly the PL-6 failure mode. "Where the generator runs"
    is not the robustness axis; "does drift fail closed" is.)* Two robust shapes:
    - **B2a — derive-on-read (no stored mirror):** the consuming check computes chains from each
      prompt's `handoffs:` at runtime; nothing is stored twice, so drift is structurally impossible.
      *Cost:* 00.02 loses its human-browsable narrative (or becomes a generated, banner-marked copy).
    - **B2b — generated artifact + deterministic drift-gate:** a generator writes 00.02's chain rows
      from on-disk handoffs, and a check in `pe-meta-review` Phase 7b (optionally CI) regenerates
      in-memory and **fails if committed ≠ regenerated**. Generator trigger (manual or hook) is then
      immaterial — the fail-closed gate catches staleness loudly.
    *Resolved by:* owner choice between B2a and B2b (the rejected manual/hook-only option is off the table).
  **✅ Decision (2026-06-25):** neither B2a nor B2b — choose **B0 (drop the drift-prone column)**.
  The agent-chain column is the only part that drifts; the command column is stable. Remove the
  chain detail from 00.02 so each row is *capability → command* only; the real chain is read from
  each prompt's `handoffs:` on demand. Demote rule 5 / Phase 7b check 6 to a cheap existence lint.
  No generator, no drift-gate — drift is eliminated because the duplicated fact is no longer stored.
  This **supersedes OD-B2** (B2a/B2b both moot: nothing left to generate or gate). This is a P2
  plumbing fix, kept deliberately proportionate.

- **OD-C-consolidate-duplication** — Commit to collapsing the duplicated threshold / boundary-minimum
  / tool-alignment restatements into single-source references (canonical: 01.06 for parameters,
  01.04 for tool alignment), leaving derivative files as `📖` links?
  *Resolved by:* owner decision + a precise read-only inventory naming, per duplicated fact, which
  file is authoritative vs derivative (produced during readiness, not assumed).
  *Gates:* the CHANGE-duplication workstream.
  **✅ Decision (2026-06-25):** commit — collapse the duplicated restatements into single-source
  references (canonical: 01.06 parameters, 01.04 tool alignment); derivatives become `📖` links.
  The per-fact authoritative-vs-derivative inventory (`DSC-duplication-inventory`) is still required
  at readiness before any edit.

- **OD-D-sequencing** — Confirm the proposed order — INTEGRATE thin eval slice → CHANGE drift
  surfaces → KEEP backbone untouched — or reprioritize (e.g. CHANGE first as the cheapest win)?
  *Resolved by:* owner decision.
  **✅ Decision (2026-06-25):** confirm the proposed order — INTEGRATE thin eval slice (WS-B) →
  CHANGE drift surfaces (WS-A capability map + WS-C duplication) → KEEP backbone untouched.

## 🔎 Discovery *(undecidable until execution)*

- **DSC-duplication-inventory** — Read-only inventory naming, per duplicated fact (thresholds,
  boundary minimums, tool-alignment rules), which file is authoritative vs derivative. Required by
  OD-C before any consolidation edit. *Negative branch:* a fact with two plausible authoritative
  homes is surfaced to the owner rather than collapsed by assumption.
- **DSC-eval-state-sufficiency** — Whether the 05.09 state namespace, as specified, can host a
  minimal eval slice without any harness build.
  *Negative branch:* if insufficient, the INTEGRATE workstream is scoped to spec + a single recorded
  golden case only, and the gate wiring is deferred to the parked harness.

## ✅ Actionability gate *(promotion record)*

Run at the `draft → actionable` transition on 2026-06-25. All eight checks pass.

1. **Goal alignment** — the `goal:` restates the owner request ("make pe-meta / pe-* more efficient,
   effective, reliable … KEEP / CHANGE / INTEGRATE"); the KEEP/CHANGE/INTEGRATE split is the verbatim
   framing. No silent narrowing. ✅
2. **Goal reachability** — the three workstreams (WS-B INTEGRATE, WS-A + WS-C CHANGE) plus the explicit
   KEEP-backbone non-edit cover every objective bullet; no undocumented gap. ✅
3. **Execution determinism** — each step below names one file/edit with one reasonable execution; the two
   genuinely undecidable items live in § Discovery with negative branches, not in the step list. ✅
4. **Clarity & actionability** — no bare verify/check/assess steps; the one inventory step (WS-C step 1)
   is a § Discovery item (`DSC-duplication-inventory`) with a defined negative branch, not an actionable
   guess. ✅
5. **Unknown resolution** — every blocking unknown is resolved by OD-A…OD-D; the residual two are bounded
   in § Discovery (`DSC-duplication-inventory`, `DSC-eval-state-sufficiency`), each fail-safe. ✅
6. **Scope discipline** — no step exceeds the goal; the full eval harness, model-staleness verification,
   token reorg, vision wording, and 00.06 inheritance are all in § Park lot. ✅
7. **Coverage promise** — every in-scope objective bullet names a downstream landing: KEEP → no-edit
   backbone list; CHANGE → WS-A (00.02 + rule 5) and WS-C (duplication single-sourcing); INTEGRATE → WS-B
   (eval slice). ✅
8. **Principle impact** — N/A; this is not a vision-amendment plan (it proposes no vision edit, and its
   filename contains no "vision" token). ✅

## ⚙️ Workstreams (edit mapping) *(things to do)*

Execute in the OD-D order: **WS-B (INTEGRATE) → WS-A + WS-C (CHANGE) → KEEP (no edit)**. Suffix status
notation only; identifier ids are ordinal + kebab slug.

### WS-B — INTEGRATE: minimal eval slice (first) (✅ done)

Activates a thin, falsifiable measurement starter per OD-A. The full harness stays parked (PL-1).
Gated by `DSC-eval-state-sufficiency`.

- **WS-B1-load-bearing-dimension** — For each PE artifact-type (prompt, agent, instruction, context,
  skill, template, snippet), name its single most load-bearing quality dimension (the property whose
  failure most degrades the artifact's job). (✅ done)

  Grounded in each type's per-type instruction file and the validation sequence in
  `pe-prompt-engineering-validation/SKILL.md`. The chosen dimension is, for each type, the property
  whose failure most directly defeats that type's reason to exist:

  | Artifact-type | Most load-bearing dimension | Why (failure → degradation) |
  |---|---|---|
  | **prompt** | Workflow reliability (failure-mode-free steps) | A prompt drives a reusable multi-step workflow; ambiguous, branching, or failing steps break the task it automates — structure/YAML can be perfect yet the prompt still mis-executes. |
  | **agent** | Tool–mode alignment (+ single responsibility) | An agent is defined by autonomous execution within one role; a mode/tool mismatch (e.g. `plan` + write tools) is the CRITICAL failure that makes it act outside or below its role. |
  | **instruction** | `applyTo` scope correctness (conflict-free) | Enforcement is auto-injected by glob; a wrong or undocumented-overlapping `applyTo` applies rules to the wrong files or creates undefined precedence — the rules silently misfire. |
  | **context** | Single-source-of-truth (no duplication) | A context file exists to be the one authoritative home; duplicated content turns it into a drift source, defeating its only purpose. |
  | **skill** | Description-triggered discoverability | A skill is reached only via description matching; a weak description means the capability is never invoked, so body quality is irrelevant. |
  | **template** | Content completeness (all expected fields/sections) | Templates are consumed structurally; a missing field or section silently breaks every downstream consumer that relied on it. |
  | **snippet** | Self-containment (works without surrounding context) | A snippet is pasted via `#file:` into arbitrary hosts; if it depends on absent context it produces broken or misleading output wherever included. |
- **WS-B2-golden-cases** — Author one golden case per artifact-type on its WS-B1 dimension: an input +
  the expected good-output property, small enough to be hand-checkable. (✅ done)

  Each case is a deliberately-broken minimal fixture plus the single property a correct evaluation
  MUST flag on that type's WS-B1 dimension. A case **passes** when the evaluation flags the property
  and **fails** when it misses it — a human reads the fixture and the evaluation output to decide, so
  no harness is required.

  | Artifact-type (dimension) | Golden-case input (broken fixture) | Expected good-output property (must flag) |
  |---|---|---|
  | **prompt** (workflow reliability) | A 3-phase prompt whose Phase 2 → 3 transition has no completion/gate check, and one step reads "handle errors appropriately." | Flags BOTH the ungated phase transition and the vague step as a workflow-reliability defect (non-deterministic execution). |
  | **agent** (tool–mode alignment) | An agent with `agent: plan` whose `tools:` lists `create_file` / `replace_string_in_file`. | Flags the mode/tool contradiction (a `plan`-mode agent must not carry write tools). |
  | **instruction** (`applyTo` correctness) | Two instruction files both `applyTo: '**/*.md'`, neither documenting the overlap shape. | Flags the undocumented `applyTo` overlap [H10]. *Negative control:* a single documented shared-baseline overlap must NOT be flagged. |
  | **context** (single-source-of-truth) | A context file restating "token budget ≤1,500" that already lives canonically in 01.06. | Flags the duplicated fact and points to the canonical home (01.06) [H3]. |
  | **skill** (description discoverability) | A skill whose `description` is "Helps with various tasks" (no [what] + [tech] + "Use when" + [scenarios]). | Flags the description as non-discoverable / missing the trigger formula [M7]. |
  | **template** (content completeness) | An `output-*` report template missing the `References` section its consuming prompt writes. | Flags the missing consumer-expected section. |
  | **snippet** (self-containment) | A snippet that says "the table above" and relies on a variable defined by the host prompt. | Flags the external dependency (not self-contained). |
- **WS-B3-state-wiring** — Wire the seven cases to the `05.09-self-update-config-and-state.md` state
  namespace so a result can be recorded against an artifact version. (✅ done)

  **`DSC-eval-state-sufficiency` outcome — negative branch taken.** 05.09 is `status: proposed`,
  "spec-now / build-later": its `outcome-log.jsonl` line schema (change class, decision, confidence,
  **eval result**, human override) *can* hold a golden-case result, but the state writer is parked and
  the contract states nothing reads or writes the namespace until the build is unparked. The slice
  therefore cannot be **live-wired** without a harness build, so WS-B reduces to **spec + one recorded
  golden case**, with live gate wiring deferred to **PL-1**.

  *Eval-slice → 05.09 mapping (spec, no schema change required):* each golden-case run is one
  `outcome-log.jsonl` line reusing the existing `eval result` field —
  `{ artifact_type, dimension, golden_case_id, fixture_version, eval_result: pass|fail, evaluator: human }`.

  *One recorded golden case (hand-evaluated, recorded here because the state writer is parked):*
  `{ artifact_type: "agent", dimension: "tool–mode alignment", golden_case_id: "GC-agent-tool-mode",
  fixture_version: "fixture@v1", eval_result: "pass", evaluator: "human" }` — the evaluation flagged the
  `plan`-mode + write-tools contradiction from WS-B2, the property a correct evaluation must catch.
  - *Negative branch (`DSC-eval-state-sufficiency`):* applied — slice reduced to spec + one recorded
    golden case; gate wiring deferred to PL-1. (✅ done)

### WS-A — CHANGE: capability-map B0 (second) (✅ done)

Eliminates the only drift surface in 00.02 by removing the duplicated fact, per OD-B = B0. No generator,
no drift-gate.

- **WS-A1-drop-chain-column** — Edit
  [.copilot/context/00.00-prompt-engineering/00.02-capability-map.md](.copilot/context/00.00-prompt-engineering/00.02-capability-map.md):
  remove the agent-chain column so each row is *capability → command* only. The real chain is read from
  each prompt's `handoffs:` on demand. (✅ done — dropped the chain column from Categories 1, 2, 4, 5; folded Cat-5 skill refs into the entry point; reframed the modernization note + Quick/Deep verification to read handoffs on demand; bumped 00.02 to v1.3.0.)
- **WS-A2-demote-rule-5** — Demote rule 5 / Phase 7b check 6 from a chain-resolution check to a cheap
  deterministic **existence lint** (the row's command file resolves on disk). (✅ done — Deep-Verification rule 5 in 00.02 and Phase 7b check 6 in `pe-meta-review.prompt.md` now verify a matching row + resolvable command; deeper handoff tracing delegated to check 3. Prompt bumped to v3.2.0 with a changelog entry.)
- **WS-A3-governance-sync** — In
  [.copilot/context/00.00-prompt-engineering/00.01-governance-and-capability-baseline.md](.copilot/context/00.00-prompt-engineering/00.01-governance-and-capability-baseline.md),
  update any text that references the removed chain column. **Governance note:** B0 removes a *column*,
  not capability *entries*, so the "MUST NOT remove capability entries without explicit approval" rule is
  not triggered — confirm this framing holds before editing. (✅ done — synced Purpose, token-budget note, and cross-reference to *capability → command*; runtime validation contract left intact (chains still resolve via handoffs); confirmed governance non-trigger; bumped 00.01 to v2.1.1 and resynced lagging bottom metadata.)

### WS-C — CHANGE: collapse duplication to single source (second) (🟡 todo)

Per OD-C. Read-only inventory first; no edit until each fact has a confirmed authoritative home. Gated by
`DSC-duplication-inventory`.

- **WS-C1-inventory** — Run `DSC-duplication-inventory`: a read-only pass naming, per duplicated fact
  (thresholds, boundary minimums, tool-alignment rules), which file is authoritative vs derivative. (🟡 todo)
  - *Negative branch:* a fact with two plausible authoritative homes is surfaced to the owner, not
    collapsed by assumption. (🟡 todo)
- **WS-C2-single-source** — Collapse the duplicated restatements into single-source references —
  canonical `01.06-system-parameters.md` for parameters/thresholds, `01.04` for tool alignment — and
  replace each derivative restatement with a `📖` link to its canonical home. (🟡 todo)

### KEEP — quality-definition + coverage backbone (no edit) (🟡 todo)

By construction this workstream is a deliberate **non-edit**: the quality-definition + coverage backbone
(00.03, 01.06, 01.07, 05.07, 05.08, 04.05, 04.01) already makes `pe-*` effective and reliable and MUST
NOT be touched by this plan. It stays `todo` as a guardrail held across execution; it completes only when
the final diff confirms no backbone edits (see § Exit criteria). Any change to these files is out of
scope. (🟡 todo)

## 🧪 Exit criteria *(things to do)*

All criteria must be met before the plan moves to `done`.

- **WS-B** — One golden case per artifact-type exists and records a result against an artifact version in
  the 05.09 state namespace; OR, on the negative branch, the spec plus one recorded golden case exists
  and the gate wiring is documented as deferred to PL-1. (✅ done)
- **WS-A** — 00.02 has no agent-chain column (rows are *capability → command*); rule 5 / Phase 7b check 6
  is an existence lint; 00.01 no longer references the chain column; no chain mirror remains to drift. (✅ done)
- **WS-C** — `DSC-duplication-inventory` is complete; every duplicated fact has exactly one authoritative
  home; each derivative is a `📖` link; any two-home fact was surfaced to the owner, not auto-collapsed. (🟡 todo)
- **KEEP** — The final diff shows no edits to the backbone files (00.03, 01.06 except its role as a
  single-source target for WS-C, 01.07, 05.07, 05.08, 04.05, 04.01). (🟡 todo)

## 📥 Park lot

- **PL-1-full-eval-harness** — Build the golden-case runner, scoring rubrics, and promotion gate
  for 05.10. → `→ defer` (05.10 build is parked by design; only a thin slice is in scope here).
- **PL-2-model-staleness-verification** — Verify the model version notes in 03.02 and the CRITICAL-rule
  re-validation dates in 01.07 against current vendor/VS Code docs. → `→ defer (own follow-up)`
  (separate verify-first task; not assumed by this plan).
- **PL-3-token-reorg** — Split large monolithic files (01.06 / 05.07 / 05.08) into summary + template
  externals to lower load. → `→ defer` (efficiency-only; lower leverage than drift removal).
- **PL-4-vision-wording** — Any vision principle/wording amendment to reflect a generated map or an
  active eval gate. → `→ vision-only` (human action; this plan proposes substrate changes only).
- **PL-5-00.06-folder-inheritance** — Activation of the proposed folder-metadata-inheritance spec
  (depends on MetadataWatcher build). → `→ defer` (separate parked build).
