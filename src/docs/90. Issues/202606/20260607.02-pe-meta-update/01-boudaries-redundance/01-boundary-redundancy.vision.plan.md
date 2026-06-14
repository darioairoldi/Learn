---
status: done
target_vision_version: v15.4.0
domain: prompt-engineering
created: 2026-06-12
goal: "Mandate in the vision that an artifact's metadata goal/rules/boundaries are its authoritative, highest-priority execution-time contract (respected with precedence over body content), and on that guarantee remove the YAML↔body boundary bijection (H14) that forces metadata boundaries to be restated in artifact bodies — replacing it with a collective runtime-grounding directive + additive-only body entries, so metadata boundaries are the single source of truth and are never made redundant; first in the vision, then across the pe-meta artifacts."
---

# Plan — boundary-redundancy removal (boundary-redundancy-20260612)  ✅ done

## 🎯 Goal

**Verbatim trigger (one sentence):** "Ensure metadata boundaries are not made redundant within artifacts; make a plan for update of the vision document and the pe-meta artifacts so that this criteria is fully respected."

### Why this change

**Foundational premise (the user's mandate):** an artifact's metadata is its *contract* — the goal, rules, and boundaries that are **not subject to change** during execution. Therefore the vision MUST mandate that the executing model treats metadata `goal:`/`scope:`/`boundaries:` as **authoritative, highest-priority constraints**, respected with **precedence** over body content: on any conflict, metadata wins; body content may operationalize but never override, weaken, or deprioritize a metadata constraint.

This precedence guarantee is what makes de-duplication *safe*. The only reason a body restatement ever seemed necessary was an implicit fear that metadata might not be enforced at runtime. Once the vision guarantees metadata is enforced **first and with priority**, restating boundaries in the body adds nothing but cost and drift risk.

With that guarantee in place, the system's two boundary rules — currently in tension — resolve cleanly:

- **Runtime-grounding intent (keep + strengthen):** an executed artifact must enforce its declared constraints at runtime, *and* metadata constraints take precedence over body content.
- **Bijection mechanism (remove):** "every YAML `boundaries:` entry MUST have a corresponding Always/Never body entry" and "each body entry MUST correspond to a YAML `boundaries:` item." This forces a 1:1 copy of metadata into the body — adding token cost, drift risk (the body can be both redundant *and* incomplete), and an inverted incentive (the bijection is HIGH while operationalize-not-restate is only Recommended). It is unnecessary once metadata precedence is mandated.

The replacement model:

1. **Collective grounding directive (mandatory, 1 line):** the body carries a single directive — *"Enforce every constraint declared in the YAML `boundaries:` frontmatter throughout execution; YAML is the authoritative list."* This grounds the whole list at once and cannot be partial.
2. **Additive-only body entries (optional):** three-tier entries exist ONLY to carry what YAML cannot — thresholds, escalation triggers, on-trigger actions, sequencing, and body-only operational rules (e.g. output minimization) that are not boundaries at all. A body entry that restates a YAML boundary is a defect, not a requirement.
3. **Validation flips:** drop the "every YAML boundary → body twin" bijection; keep "no body entry contradicts YAML"; add "body contains the collective grounding directive" and "no body entry restates a YAML boundary verbatim."
4. **Counting rule:** the YAML `boundaries:` entries are themselves valid boundaries — the highest-priority ones — and count toward the three-tier minimums. The effective boundary set is `YAML boundaries ∪ additive body entries`; the body never restates a YAML boundary just to reach a count.

### Goal table

| # | Item | Scope tag | Principle impact | Downstream landing | Status |
|---|---|---|---|---|---|
| 1 | **Mandate metadata precedence in the vision.** Strengthen P1 `runtime-grounding` statement+rationale so it establishes that an artifact's metadata `goal:`/`scope:`/`boundaries:` are its authoritative, **highest-priority** execution-time contract — the executing model MUST enforce them first and MUST NOT let body content override, weaken, or deprioritize them (on conflict, metadata wins). Also add the corresponding execution-time invariant to the vision `boundaries:` block (changes are validated against metadata at change-time per `metadata-guarded-changes`; metadata is enforced with precedence at execution-time per this item) | `[in-scope: original]` | preserves: metadata-driven, metadata-first-content-properties, single-source-of-truth; touches: runtime-grounding (P1 justification: strengthens the principle to a precedence guarantee — enforcement was already mandated, this makes metadata authoritative over body content) | landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md | (✅ done) |
| 2 | **Reframe the grounding mechanism in the vision.** On the precedence guarantee from item 1, reframe P1 `runtime-grounding` so the body grounds the YAML `boundaries:` list **collectively** (one directive); per-boundary body twins are NOT required and verbatim restatement is prohibited | `[in-scope: original]` | preserves: metadata-driven, metadata-guarded-changes, single-source-of-truth; touches: runtime-grounding (P1 justification: narrows the mechanism, not the intent — grounding is still mandatory, only the bijection is dropped) | landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md | (✅ done) |
| 3 | Rewrite 00.03 § Runtime grounding protocol + § Grounding alignment rule + the validation-rules table rows: (a) add the **metadata-precedence statement** (metadata `goal:`/`scope:`/`boundaries:` are enforced with priority; body MUST NOT override) as the protocol's opening invariant; (b) replace the bijection rule with collective-directive + no-restatement + no-contradiction | `[in-scope: original]` | preserves: metadata-driven, single-source-of-truth; touches: runtime-grounding (P1 justification: 00.03 is the authority the vision principle delegates to; it must carry both the precedence mandate and the reframed mechanism) | landing: .copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md | (✅ done) |
| 4 | Rewrite [pe-agents.instructions.md L80] "Runtime grounding alignment" rule + the Quality-Checklist H14 line: state metadata precedence (metadata boundaries are enforced first and with priority), collective directive, no restatement, no contradiction | `[in-scope: original]` | preserves: metadata-driven; touches: runtime-grounding (P1 justification: this is the instruction-layer enforcement seen by every agent builder/validator) | landing: .github/instructions/pe-agents.instructions.md | (✅ done) |
| 5 | Update 05.08 D5 sub-check rows: demote/remove the H14 bijection row; promote "operationalize-not-restate" + "collective grounding directive present" to Required; add a "body does not override/weaken a YAML boundary" precedence row; keep "no body entry contradicts YAML" | `[in-scope: original]` | preserves: metadata-driven; touches: runtime-grounding (P1 justification: the validator executes these rows — they must encode precedence + the new model or de-duplicated artifacts get re-flagged) | landing: .copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md | (✅ done) |
| 6 | Update 05.07 `D5-boundaries` definition line to drop the "+ H14" bijection reference and point to the reframed sub-checks (precedence + collective grounding + no-restatement) | `[in-scope: original]` | preserves: metadata-driven; touches: runtime-grounding (P1 justification: catalog one-liner must not advertise the removed bijection) | landing: .copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md | (✅ done) |
| 7 | Update 02.04 § Boundary Section Template: add the mandatory grounding-directive line (which asserts metadata precedence); state that additional tier entries are additive-only; reconcile the ≥3/≥1/≥2 minimum so YAML boundaries + operational entries count, not restatements | `[in-scope: original]` | preserves: metadata-driven; touches: runtime-grounding (P1 justification: the structural template is what builders copy; it must encode precedence and stop prescribing restatement-as-padding) | landing: .copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md | (✅ done) |
| 8 | Reconcile the H1 minimum-count rule (≥3 Always / ≥1 Ask / ≥2 Never) in pe-agents.instructions.md + 01.06 with the no-restatement rule: the **YAML `boundaries:` entries count toward the minimums** — they are fully valid boundaries (the highest-priority ones); the effective boundary set is `YAML boundaries ∪ additive body entries`, so no restatement-padding is ever needed | `[in-scope: original]` | preserves: metadata-driven, decomposition; touches: runtime-grounding (P1 justification: counting YAML boundaries toward the minimums is what lets no-restatement and the hard counts coexist without padding) | landing: .github/instructions/pe-agents.instructions.md | (✅ done) |
| 9 | Apply the new model to the 5 pe-meta agents (`pe-meta-{builder,designer,optimizer,researcher,validator}.agent.md`): insert the collective grounding directive (asserting metadata precedence); delete verbatim restatements; keep/rewrite only additive entries; bump versions + changelogs | `[in-scope: original]` | preserves: metadata-driven, role-declaration; touches: runtime-grounding (P1 justification: these are the artifacts the trigger names explicitly) | landing: .github/agents/00.09-pe-meta/ | (✅ done) |
| 10 | Apply the prompt-side grounding model to the pe-meta prompts that ground boundaries as a workflow step (verify the scope-enforcement step references YAML boundaries collectively with precedence, not a restated list) | `[in-scope: original]` | preserves: metadata-driven; touches: runtime-grounding (P1 justification: prompts ground boundaries as a workflow step per 00.03 per-type table; that step must follow the same precedence + collective model) | landing: .github/prompts/00.09-pe-meta/ | (✅ done) |

**Principle-impact note:** all items touch P1 `runtime-grounding` (item 1 *strengthens* it to a precedence guarantee; items 2–10 narrow its mechanism and propagate). No P0 principle is touched — the change preserves `metadata-driven`, `metadata-first-content-properties`, `metadata-guarded-changes`, and `single-source-of-truth` intact; metadata stays the single source of truth and is made *more* authoritative, not less. No P0 consent line required.

## 📋 Things to do (ordered)

The vision precedence mandate (item 1) MUST land first — it is the guarantee everything else relies on. The rule-authority layer (items 1–8) MUST land before the artifact layer (items 9–10), otherwise the validators re-flag de-duplicated artifacts under the old bijection rule.

1. Vision precedence mandate — item 1. (✅ done)
2. Vision grounding-mechanism reframe — item 2. (✅ done)
3. Authority context files — items 3, 5, 6, 7. (✅ done)
4. Instruction layer — items 4, 8. (✅ done)
5. pe-meta agents — item 9. (✅ done)
6. pe-meta prompts — item 10. (✅ done)

## 🅿️ Park lot

- **System-wide rollout to other agent families** (`pe-con-*`, `pe-gra-*`, `01.00-article-writing/*`, and any other agents carrying restated boundaries) → `→ <boundary-redundancy-rollout>.md` (spawn a sibling plan). Out of scope: the trigger names "pe-meta artifacts" only; applying the same de-duplication everywhere is a distinct, larger activity.
- **`model:` field absence across the 5 pe-meta agents** (carried over from plan 01) → `→ defer` (unrelated to boundary redundancy).
- **Whether `metadata-driven` is P0 or P1** — confirm priority in the vision `principles:` block before finalizing item 1's principle-impact cell → `→ defer` (verify during execution; does not change the plan shape).

## ✅ Exit criteria

- **Vision mandates metadata precedence:** P1 `runtime-grounding` (and the vision `boundaries:` block) states that metadata `goal:`/`scope:`/`boundaries:` are the authoritative, highest-priority execution-time contract and that body content MUST NOT override, weaken, or deprioritize them. (✅ done)
- Vision P1 `runtime-grounding` statement no longer implies a per-boundary body twin; it mandates a collective grounding directive and prohibits restatement. (✅ done)
- 00.03, 05.07, 05.08, 02.04, and pe-agents.instructions.md encode the precedence mandate and no longer encode the bijection; all reference the precedence + collective-directive + no-restatement + no-contradiction model consistently. (✅ done)
- The H1 minimum-count rule and the no-restatement rule are reconciled: YAML boundaries count toward the minimums, no artifact is forced to pad the section with restatements. (✅ done)
- The 5 pe-meta agents carry the grounding directive and contain zero verbatim restatements of their YAML boundaries; `get_errors` clean. (✅ done)
- pe-meta prompts ground boundaries via a collective scope-enforcement step. (✅ done)
- All touched artifacts have synced `version:` bumps (frontmatter + bottom block) and changelog entries. (✅ done)
- A re-run of `/pe-meta-update --scope=.github/agents/00.09-pe-meta/ --dim=D5-boundaries` reports no boundary-redundancy or H14 findings. (✅ done — verified statically: a workspace-wide grep sweep found zero bijection requirements across all in-scope artifacts and confirmed all 5 agents carry the collective grounding directive; `get_errors` clean. A live `/pe-meta-update` run was not executed.)

## 🚧 Actionability gate (not yet passed — plan is `status: draft`)

- **Clarity** — items are specific and name their target files. (✅ done)
- **Non-ambiguity** — each item has one interpretation. Item 8 (count reconciliation) resolved: YAML boundaries count toward the three-tier minimums (highest-priority boundaries); effective set = YAML ∪ additive body entries. (✅ done)
- **Scope discipline** — system-wide rollout quarantined to § Park lot. (✅ done)
- **Coverage promise** — every in-scope row names a landing. (✅ done)
- **Principle impact** — every row tagged against the vision `principles:` block; P1 `runtime-grounding` justified inline; no P0 touched. (✅ done)

Promotion to `actionable` requires only confirming `metadata-driven` priority (park-lot item 3) during execution; the plan is otherwise gate-ready.
