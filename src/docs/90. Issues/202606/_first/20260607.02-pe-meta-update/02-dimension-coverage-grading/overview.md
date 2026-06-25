---
title: "pe-meta-validator quality issues + why the 'full pass' missed them — dimension coverage grading"
author: "Dario Airoldi"
date: "2026-06-11"
status: "draft"
domain: "prompt-engineering"
categories: [prompt-engineering, pe-meta, review, process, coverage]
description: "Two-layer analysis: (Part 1) the concrete quality issues found in pe-meta-validator.agent.md by manual review — stale goal/mode count, boundary-to-YAML misalignment, boundary positioning and severity-ordering, re-hosted Coverage Audit Contract, and relegation candidates; (Part 2) why /pe-meta-update reported '26/27 PASS, 1 trivial finding' yet missed all of them — the dimension is treated as a scalar so it goes green on its easiest sub-property — and a proposed sub-check-granular, ternary, graded coverage model that closes the leak deterministically."
---

# pe-meta-validator quality issues + why the "full pass" missed them

## 🎯 Why this analysis exists

On 2026-06-11 a full-breadth apply run —
`/pe-meta-update --mode=apply --scope=.github/agents/00.09-pe-meta/pe-meta-validator.agent.md --source=(all) --dim=full --deps=full` —
reported **26/27 dimensions PASS with one trivial `D14` heading fix**. A manual adversarial probe of the same artifact immediately afterward found **substantive issues across four findings** the run had marked PASS (detailed in Part 1):

| # | Finding | Dimension marked PASS |
|---|---|---|
| F1 | `goal`/`description` name three review modes; the body implements four | `D6-consistency` |
| F2 | Four YAML `boundaries:` entries have **no** corresponding Always/Never body enforcement entry (H14), *and* some body entries restate YAML verbatim | `D5-boundaries` |
| F3 | Boundaries section sits at ~45% of the body and is not severity-ordered | `D19-artifact-structure` / `D5-boundaries` |
| F4 | The Coverage Audit Contract section re-hosts content that is canonical in a referenced snippet | `D14` / `D23` |

The unsettling part: **the invocation resolved correctly and every guard passed honestly.** This is not the [self-attestation failure](../../20260607.01-pe-meta-update/02-full-pass-enforcement-analysis/overview.md) already remediated by plan 04 — a genuine second actor ran the Phase 7d audit and agreed. This is a **new failure class one level deeper**: the dimension is shallow at the *sub-check* level while passing breadth, depth, and shallow-sweep guards simultaneously.

**Verdict:** the coverage unit is one level too coarse. Coverage is measured per *dimension*, but a dimension is a *checklist*; "covered" currently means *touched with one real quote*, not *checklist discharged*.

This document has two parts. **Part 1** documents the concrete quality issues in the artifact (what a correct review should have reported). **Part 2** diagnoses why the automated run did not report them and proposes the systemic fix.

---

# Part 1 — The concrete issues in `pe-meta-validator.agent.md`

These are the findings a faithful full review should have produced. They answer the four questions raised during manual review: is the agent well-defined wrt goal/role/scope; are the boundaries positioned by priority; are the body boundaries redundant with the YAML metadata; and why is so much space given to *Review Modes* and the *Coverage Audit Contract* relative to the actual *Process*.

## 📐 Best-practice baseline (what the repo's own rules require)

From [02.04-agent-shared-patterns.md](../../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) and [00.03-metadata-contracts.md](../../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md):

| Rule | Statement |
|---|---|
| **Runtime-grounding** | The `## 🚨 CRITICAL BOUNDARIES` body section is the *enforcement mechanism* for the YAML `boundaries:`; it references them **operationally** and does not restate the full list — "This is NOT duplication. YAML remains the single source of truth; the body is the enforcement mechanism." |
| **Alignment (H14, HIGH)** | *Every* YAML boundary MUST have a corresponding Always/Never body entry, and no body entry may contradict YAML. |
| **Early-commands [M2]** | Critical instructions belong in the first ~30% of the body. |
| **Reference-based architecture** | Mechanically-computable contracts live once in a canonical file; agents *point* to them, they don't *re-host* them. |
| **Agent budget** | 2,500 tokens / ~375 lines. This file (~215 body lines) is **within** budget — so the issues below are about **focus and redundancy**, not size. |

## 🔎 Findings

### F1 — Goal/description are stale: three modes named, four implemented (`D6-consistency` / `D1-metadata`, MEDIUM)

The role (PE validation specialist, plan-mode read-only, self-contained) is clear and `scope.covers`/`excludes` are well-formed. But the `goal:` and `description:` name only **three** modes — *"individual, dependency-aware, and guidance-first review modes"* — while the agent actually has **four**. The **Coverage Audit** mode (the v2.3.0 "independent second actor", arguably the most important capability) appears in `capabilities:`, in `scope.covers`, and as a body section, but is absent from the goal and description. The artifact under-advertises its own headline capability.

**Fix:** update `goal:`/`description:` to name all four modes (or describe them by class so the count cannot drift again).

### F2 — Body boundaries are misaligned with YAML boundaries: incomplete *and* partly redundant (`D5-boundaries`, HIGH)

Two defects against the same rule pair:

- **Incomplete (the worse half — H14 violation).** Several YAML `boundaries:` entries have **no** corresponding Always/Never body entry: *route CRITICAL findings to immediate human escalation*, *apply the exemplary quality bar*, *emit structured stage outputs*, and *must not approve changes that break existing capabilities*. The body — the enforcement mechanism — does not enforce them.
- **Redundant (the runtime-grounding violation).** Conversely, several Always Do / Never Do entries restate their YAML counterpart **verbatim** (read-only, delegate-to-`pe-gra`, map-finding, recompute-markers appear two-to-three times) without adding the operational framing the body is supposed to contribute.

**Fix:** add body Always/Never entries for the four unmapped YAML boundaries; rewrite the verbatim restatements to add operational/enforcement detail (thresholds, escalation triggers) instead of copying the YAML.

### F3 — Boundaries sit too late and are not severity-ordered (`D19-artifact-structure` / `D5-boundaries`, MEDIUM)

The `## 🚨 CRITICAL BOUNDARIES` section begins at roughly **45%** of the body — past the first-~30% window the **[M2] early-commands** principle reserves for critical instructions. Within the section, the tiers are **not severity-ordered**, so the most safety-critical rules are not the most prominent.

**Fix:** move the boundaries section above *Review Modes* / *Coverage Audit Contract* (into the first 30%); order the tiers by severity (Never → Ask First → Always, or an explicit risk order).

### F4 — *Coverage Audit Contract* re-hosts canonical snippet content (`D14`/`D23-reference-efficiency`, MEDIUM)

The `## Coverage Audit Contract` section re-states the Layer A / Layer B mechanics that are **canonical** in [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md). This is the reference-based-architecture violation: the agent should **point** to the snippet, not re-host it. Re-hosting is both wasted budget and a drift source (two copies that can diverge).

**Fix:** replace the re-hosted mechanics with a one-line reference to the snippet; keep only the agent-specific *invocation* detail.

## 🧹 Relegation candidates (what can move out of the agent)

The answer to "why so much space on *Review Modes* and the *Coverage Audit Contract*" is that **operational mechanics that belong in a contract are inlined in the agent**. Candidates to relegate:

| Content in the agent | Should live in | Why |
|---|---|---|
| Coverage Audit Layer A/B mechanics (`## Coverage Audit Contract`) | the [evidence-coverage snippet](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) (already canonical) | reference-based architecture; remove the duplicate |
| Verbose per-mode procedure inside `## Review Modes` | a referenced contract / the per-artifact review prompt | the agent should declare *which* modes it offers + when; the step-by-step is execution detail |
| Verbatim YAML-restatement boundary lines | deleted (kept once in YAML) or rewritten as enforcement framing | runtime-grounding rule |

Relegating these frees budget and lets the boundaries + the actual *Process* occupy the prominent early space, directly addressing the proportionality concern.

## ✅ Answers to the four review questions

| Question | Answer |
|---|---|
| Well-defined wrt goal/role/scope? | **Mostly** — role and scope are sound; the **goal is stale** (F1: three modes named, four implemented). |
| Boundaries positioned by priority/dependency? | **No** — they sit at ~45% (F3, violates [M2]) and are not severity-ordered. |
| Boundaries redundant with YAML metadata? | **Yes, and worse — also incomplete** (F2): some body entries copy YAML verbatim while four YAML boundaries have no body enforcement at all. |
| Why so much space on *Review Modes* / *Coverage Audit Contract*? | Because **contract mechanics are inlined** instead of referenced (F4); relegating them rebalances the agent toward boundaries + Process. |

---

# Part 2 — Why the "full pass" missed all of this

## 🔬 Root cause — the dimension is treated as a scalar

The dimension catalog defines each dimension as a **one-line scalar**. The entire `D5-boundaries` specification is:

- [05.07-pe-meta-dimension-catalog.md L53](../../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md#L53) — `Three-tier completeness (≥5/2/3 exemplary bar)`
- [05.08-pe-meta-type-checklists.md L80](../../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md#L80) — `Boundaries: ≥3 Always / ≥1 Ask / ≥2 Never · Exemplary ≥5/≥2/≥3`

So `D5` reduces to a **count**. The run's PASS evidence — "8 Always / 3 Ask / 6 Never, meets the ≥5/2/3 bar" — discharged the *entire* specified check. The rule that would have caught **both halves of F2** (every YAML `boundaries:` entry maps to a body Always/Never entry, HIGH; and the body must operationalize, not restate, YAML) **exists** — but in a *different file*, [00.03-metadata-contracts.md](../../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) (the H14 alignment rule) and [02.04-agent-shared-patterns.md](../../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) (runtime-grounding). **It is not wired into the `D5` definition the validator executes**, so `D5` never reaches it.

The same pattern holds across the missed findings:

| Dim passed | What 05.07/05.08 actually asks | Rule that would catch the finding | Where that rule lives | Wired into the dim? |
|---|---|---|---|---|
| `D5-boundaries` | count 8/3/6 vs bar | YAML-boundary ↔ body-entry alignment; operationalize-not-restate | 00.03, 02.04 | ❌ no |
| `D6-consistency` | "non-contradiction" (no enumerated sub-checks) | goal/description claims (mode count) match implementation | — (nowhere) | ❌ no |
| `D19-artifact-structure` | "goal/scope/boundaries correctly sized" | section proportionality (a contract dwarfs the core Process) | — (nowhere) | ❌ no |
| `D14`/`D23` | persona/process/scenarios present; ref count/placement | body must not re-host content canonical in a referenced snippet | implied by reference architecture | ❌ no |

The run was **complete-as-specified but shallow-as-needed.** The executor did not skip the checklist — the checklist is missing the rows that matter.

## ⚖️ Why every guard still went green

The three guards check *orthogonal* properties, and none checks sub-check completeness:

| Guard | What it verifies | Why it passed |
|---|---|---|
| `pu-evidence=27/27` | every dimension was touched with a non-empty `evidence_ref` | all 27 dims were touched with a real quote |
| Layer A (deterministic) | resolvability + verbatim literal-containment + distinctness | the quotes exist verbatim at the cited lines |
| Layer B (reasoning, sampled) | does the quote *support the asserted status*? | "8/3/6 meets ≥5/2/3" genuinely supports a `D5` pass **as `D5` is defined** |
| `shallow-sweep` | findings clustered in `D1`–`D5` **and** body groups silent | the one finding was `D14` (a body dim) + body evidence cited for `D28`–`D35` → both firing conditions false |

Every guard verifies *"each dimension was touched with a real quote that supports its asserted verdict."* **None verifies *"the dimension's full checklist was discharged."*** A **presence anchor** ("the section exists / the count is met") is byte-for-byte indistinguishable from a **property anchor** ("I compared the YAML list to the body list and entry *d* is unmapped") — and the whole evidence apparatus operates at *dimension* granularity, one level too coarse to tell them apart.

This is the vision's own **Completeness** principle — "no gaps where guidance is needed but absent" — turned recursively on the validation system itself.

## 💡 Key discovery — the sub-checks already exist, they are just never aggregated

The fix is smaller than a scoring redesign. [05.08-pe-meta-type-checklists.md](../../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md) **already decomposes most dimensions into table rows** — `D14-craftsmanship` is three rows ([L80–L82](../../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md#L80): persona present / process phases / ≥3 test scenarios); `D1-metadata` is ten rows. And [05.07 L48–L87](../../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md#L48) carries a `Deterministic?` column that already marks `D5`/`D14` as `⚠️ Partial` — an admission they are mixed-composite.

The bug is that the **evidence contract operates one level above the rows.** [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) defines a processing unit as `(artifact × applicable-dimension)` and requires **one** `evidence_ref` per **dimension**. A dimension with four rows is therefore "covered" the instant *one* row is evidenced; the other three rows are invisible to `pu-evidence`. The marker counts *dimensions touched*, so it reads 27/27 while three-quarters of some checklists never run.

## 🧭 Proposed model — sub-check granularity + ternary state + graded verdict

Two design instincts, both correct, combine into the fix.

### 1. The coverage unit becomes the sub-check

Redefine PU = `(artifact × dimension × sub-check)`, where a sub-check is one row of the 05.08 checklist for that artifact type. Each sub-check — not each dimension — carries its own anchored `evidence_ref`.

### 2. Every sub-check carries a *ternary* state, not a boolean

The hole was a hidden third state: with only pass/fail, "never ran" silently collapsed into "pass." Make the missing state explicit:

| Sub-check state | Meaning |
|---|---|
| `pass` | ran, evidence attached, satisfied |
| `fail` | ran, evidence attached, violated → a finding |
| `not-evaluated` | **no evidence — the check did not run** (the previously invisible state) |

### 3. The dimension verdict is *conjunctive* over its sub-checks

This makes the rule "a dimension is OK only if all its sub-checks are OK" mechanical:

- **Any** sub-check `fail` → dimension cannot be OK (it is a finding).
- **Any** sub-check `not-evaluated` → dimension cannot be *fully* OK (it is unverified).
- Dimension is OK **only when every sub-check is `pass`.**

A dimension can no longer go green by citing its easiest row, because that row discharges exactly one sub-check and the AND-gate stays open until the rest are discharged. This alone kills the "cite the count and stop" path that passed `D5`.

### 4. Grade the *quality* of coverage (boolean is too coarse)

Two orthogonal axes give a grade instead of a yes/no:

- **Coverage breadth** = `evaluated sub-checks / declared sub-checks`.
- **Evidence strength** per passed sub-check = is the anchor a **presence** anchor (cites a heading / a count) or a **property** anchor (cites the *result of the test*)? A sub-check that *is* a property test but is backed only by a presence anchor is a weak pass.

Collapse the axes into a per-dimension grade:

| Grade | Condition | Counts as OK? | Effect on health |
|---|---|---|---|
| `verified` | 100% sub-checks evaluated, all `pass`, property sub-checks backed by property anchors | ✅ yes | clean |
| `pass-weak` | 100% evaluated, all `pass`, but ≥1 property sub-check backed only by a presence anchor | ⚠️ provisional | flagged, not clean |
| `partial` | <100% sub-checks evaluated, none failed | ❌ no — **unverified** | **blocks clean** |
| `fail` | ≥1 sub-check `fail` | ❌ no — finding | blocks clean |

`partial` is the grade the 2026-06-11 run *should* have reported on `D5`/`D6`/`D19` instead of green. It is computed **deterministically** from the coverage ratio — no heuristic, no second-actor reasoning — and fires regardless of *which* dimension is thin (it would catch `D5`/`D6`/`D19`, none of which sit in the frontmatter cluster `shallow-sweep` watches).

## 🔧 What changes in the markers and guards

| Layer | Change |
|---|---|
| Coverage marker | `pu-evidence=27/27` → `subcheck-coverage=<evaluated>/<declared>` per dimension, aggregated; a dimension at 1/4 reports `partial` and blocks a clean score |
| `shallow-sweep` | demoted to a **backstop**; the deterministic coverage<100% gate now catches thin dimensions regardless of which group they fall in |
| Layer A | add a deterministic anchor-**type** classification (presence vs property) — a cheap pattern check feeding the `pass-weak` grade with zero LLM cost |
| Phase 7d Coverage Audit | **stop re-reading the writer's quotes** (which inherits the writer's blind spot — exactly what happened) and **re-execute a sample of sub-checks against the live artifact** to find counterexamples — the adversarial probe that found the five findings by hand |

## 📐 Why this is faithful to the existing architecture (not a rewrite)

- The 05.08 rows **are** the sub-checks — they need (a) completion with the missing rows (the H14 boundary↔YAML row from 00.03; the `D6` mode/goal-claim row; the `D19` proportionality row; the `D14`/`D23` no-re-host row) and (b) tagging with their expected anchor type.
- The `Deterministic? ⚠️ Partial` column in 05.07 is the existing acknowledgment that these dimensions are composite — the grade model makes "Partial" operational (a dimension whose sub-checks span deterministic + reasoning is exactly the one most prone to a `partial` coverage grade).
- The ternary `pass / fail / not-evaluated` reuses the `partial` status the evidence contract already names — it just promotes it from prose to a computed aggregate.

## 🚧 Boundary — what an autonomous run may and may not change

The vision is **human-only** ("MUST NOT be modified by autonomous processes"). The catalog/checklist/snippet/audit edits below are non-breaking, in-domain, and may be applied autonomously with a plan file and version bumps. The one vision-level statement — *coverage unit = sub-check; "covered" = checklist **discharged**, not **touched*** — must be **drafted for human approval**, not committed by the run.

## ✔️ Resolution status

| Item | Status |
|---|---|
| Concrete agent findings identified (F1 stale goal, F2 boundary↔YAML misalignment, F3 positioning + ordering, F4 re-hosted contract, relegation candidates) | ✅ documented (Part 1) |
| Root cause identified (dimension-as-scalar; evidence verifies existence not checklist-discharge) | ✅ confirmed against 05.07 / 05.08 / 00.03 |
| Coverage model designed (sub-check PU, ternary state, conjunctive + graded verdict) | ✅ delivered (Part 2) |
| Agent findings F1–F4 applied to `pe-meta-validator.agent.md` | ✅ applied (v2.4.0, 2026-06-11) |
| 05.08 sub-check rows completed + anchor-tagged | ⏳ parked → 02.02 implementation plan |
| PU redefinition + grade rubric in evidence-coverage snippet | ⏳ parked → 02.02 implementation plan |
| Phase 7d re-execution upgrade | ⏳ parked → 02.02 implementation plan |
| Vision note (human-only) | ✅ drafted for review → [02.01-vision-update-plan.md](../02.01-vision-update-plan.md) |

## 🎓 Lessons learned

- A run can pass **breadth** (`pu-evidence`), **depth** (Layer A/B real-quote verification), and **shallow-sweep** *simultaneously* and still be shallow at the **sub-check** level. "Dimension PASS with one real quote" is the new fox-in-the-henhouse.
- When a quality rule already exists (H14 in 00.03) but lives in a different file than the dimension that should enforce it, the dimension's execution **never reaches it**. Cross-references must be wired into the dimension definition, not left as ambient context.
- **Presence evidence is not property evidence.** "The section exists / the count is met" is not proof that the dimension's *test* was run. Distinguishing the two is a cheap deterministic check that should gate the verdict grade.
- The independent second actor must **re-execute**, not **re-read**. An auditor that only re-verifies the writer's quotes inherits the writer's blind spots.

## 🔗 Related

- [Boundaries redundancy findings (F2 detail)](../01-boudaries-redundance/overview.md)
- [Validator single-file apply plan](../01-pe-meta-validator-apply.plan.md)
- [Why the pe-meta "full pass" keeps coming up shallow (prior failure class)](../../20260607.01-pe-meta-update/02-full-pass-enforcement-analysis/overview.md)
- [Evidence-bound coverage contract](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md)
- [Dimension catalog](../../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)
- [Type checklists](../../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md)
