---
title: "Analysis: Dismiss redundant `--dim` aliases in favor of canonical dim-group names"
author: "Dario Airoldi"
date: "2026-05-25"
categories: [analysis, prompt-engineering, pe-meta, dim-groups, alias-governance, semantic-correctness]
description: "Inventory of every --dim alias in the PE meta-pipeline. Confirms one true alias remains (`robustness` → `adherence`) but surfaces a vision-implementation semantic contradiction: vision v13 declares `robustness` synonymous with `reliability` while the parser still resolves `robustness` → `adherence`. Recommends retiring the alias rather than silently rebinding it, and codifies a no-new-aliases boundary."
draft: false
status: "applied"
severity: "Medium"
component: "PE-for-PE option taxonomy (`05.07-pe-meta-dimension-catalog.md`, `pe-meta-option-applicability-matrix.md`, `pe-meta-option-parser-tests.md`) + vision v13 § Conflict resolution"
framework: "GitHub Copilot Customization v1.107 (vision v13, PE meta-pipeline)"
---

# Analysis — Dismiss redundant `--dim` aliases

**Analysis ID:** 20260525.03-dismiss-redundant-aliases
**Date:** 2026-05-25
**Author:** Dario Airoldi
**Trigger:** User observation on the open `overview.md` — `--dim context-quality-lifecycle` reads no better than `--dim context-full`; if it is only an alias it should be dismissed. Broaden the question to every `--dim` alias in the system. Follow-up question (this revision): why is `robustness` aliased to `adherence` when those are not synonymous? Robustness sits closer to `reliability` (repeatability of actions and validations).
**Mode:** `plan` (assessment + dismissal recommendation; no code edits in this document)
**Result:** PASS with one **upgraded** recommendation — retire `--dim robustness` outright (do **not** silently rebind to `reliability`); the user's semantic objection is corroborated by [vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) which itself contains the contradiction. No other true `--dim` aliases exist.

---

## 📋 Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Recommended dismissal plan](#-recommended-dismissal-plan)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#%EF%B8%8F-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix — full alias inventory](#-appendix--full-alias-inventory)

---

## 📝 Description

### Brief

The PE meta-pipeline exposes the `--dim <group>` option on review, update, and design commands. Groups have a canonical inventory in [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). On top of that inventory, several **alias names** have accumulated over the v12 → v13 evolution:

- `--dim robustness` — explicitly labelled deprecated alias for `--dim adherence`
- `--dim context-quality-lifecycle` — alias-shaped name that referenced `--dim context-full`, removed by [20260525.01-context-fullcheck/01.02-dim-group-naming-alignment-plan.md](../20260525.01-context-fullcheck/01.02-dim-group-naming-alignment-plan.md)
- `--dim context-quality-health` — same shape, removed by the same plan

The user's observation in [overview.md](overview.md): aliases that do not improve readability and do not enable new behavior add taxonomy noise. They duplicate the canonical name in three places (catalog, applicability matrix, parser tests) and create the exact kind of name-drift that produced [20260525.01](../20260525.01-context-fullcheck/overview.md) finding D17.

### Impact

| Impact | Severity |
|---|---|
| **Vision v13 declares `robustness` ≡ `reliability` but parser resolves `robustness` → `adherence`** — internal contradiction inside the vision document itself ([line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md)) | **Medium** |
| User typing `--dim robustness` expecting reliability checks (per vision wording) gets adherence checks instead — wrong dimensions executed, silent semantic miss | **Medium** |
| Two `--dim` names per concept inflate the catalog surface and the parser test matrix | Low |
| Each alias is one more place where catalog ↔ consumers can drift (D17 risk) | Low |
| Deprecation notices are emitted at runtime, training users to ignore parser warnings | Low |
| Functional impact at parse time — alias always resolves, just possibly to the wrong dimension set per vision intent | Medium |

**Net severity:** Medium. The pipeline does not crash, but the alias direction contradicts the vision and risks silent semantic misses. Lessons from [20260524.03 § Lessons learned](../20260524.03-use-cases-have-no-reliabilitychecks/overview.md): "Binding `--dim robustness` to an adherence cluster made the reliability gap invisible at the option-taxonomy layer." That risk persists for every day the alias remains.

---

## 🔍 Context information

### Environment

| Field | Value |
|---|---|
| Repo | `darioairoldi/Learn` |
| Branch | `main` |
| PE meta version | v13 (post-vision alignment) |
| Catalog version | [05.07](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) v1.2.0 (2026-05-25) |
| Consumer prompt | [`pe-meta-context-review.prompt.md`](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) v1.1.3 (2026-05-25) |
| Applicability matrix | [`pe-meta-option-applicability-matrix.md`](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) |
| Parser test evidence | [`pe-meta-option-parser-tests.md`](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) |

### Authoritative sources reviewed

| Source | What it tells us |
|---|---|
| `05.07-pe-meta-dimension-catalog.md` § Dimension groups | The canonical list of 12 groups + 1 deprecated alias row |
| `pe-meta-option-parser-tests.md` § A-R12 / A-R14 / CF-05 / CF-06 | Parser behavior on canonical, deprecated, and unknown `--dim` values |
| `pe-meta-option-applicability-matrix.md` § Dimension scoping | Documents `--dim robustness` as deprecated alias for `--dim adherence`; flags `--dim reliability` as the canonical D28–D35 group |
| `pe-meta-update.prompt.md` line 65 | Lists the v13 taxonomy (no aliases) |
| [`20260523.01-vision.v13.md` line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) § Conflict resolution / Terminology overload | **Declares the contradiction:** "'Robustness' is a reliability property in standard SE usage… The name 'robustness' is freed and kept synonymous with `--dim reliability`… Back-compat: `--dim robustness` resolves to `--dim adherence`." Two adjacent sentences specify opposite resolutions. |
| [20260524.03-use-cases-have-no-reliabilitychecks](../20260524.03-use-cases-have-no-reliabilitychecks/overview.md) | Origin issue. Established that the v12 `robustness` label was a misnomer for D5/D6/D16/D18 (those are adherence dimensions) and that the reliability concept (D28–D35) needed its own group. "The word 'robustness' got bound to the wrong cluster, suppressing the gap by making it look filled." |
| [20260525.01-context-fullcheck](../20260525.01-context-fullcheck/overview.md) | Confirms `context-quality-lifecycle` / `context-quality-health` were prompt-text drift, never parser aliases |

### User intent

Direct quote from [overview.md](overview.md):

> `--dim context-quality-lifecycle` is not more readable than `--dim context-full`. If it is only an alias we can just dismiss it.
>
> Please analyze existing `--dim` aliases and understand if any of them are redundant and can be dismissed in favor of the canonical dim-group names in the catalog.

Follow-up question (this revision):

> Why is `robustness` replaced with `adherence`? They don't seem synonymous. At most `robustness` could be replaced with `reliability`. Robustness dimension should stand for repeatability of actions and validations. Investigate whether changes should be done to the vision use cases and the PE-meta implementation.

---

## 🔬 Analysis

### Definitions

- **Canonical group** — listed as its own row in [05.07 § Dimension groups (shortcuts)](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) with its own dimension set. Independent identity.
- **Alias** — resolves to a canonical group at parse time, has no independent dimension set, exists only to ease migration or readability.
- **Ghost name** — a name that appears in prose (e.g., in a prompt body) but is **not** wired into the parser as either a canonical group or an alias. Always a bug.

### Root-cause framing

`--dim` aliases entered the system through three distinct paths:

1. **v12 → v13 rename migration** — `--dim robustness` was a v12 group name that bundled D5/D6/D16/D18 (boundaries, consistency, adherence, coverage). In v13 it was renamed to `--dim adherence` because those dimensions are about **adherence to rules**, not reliability properties. The alias was kept "for one release" with a deprecation notice (parser test rows A-R14 / CF-06). Migration aliases are time-boxed by construction; this one's release window is the open question.
2. **Working-name drift** — `context-quality-lifecycle` / `context-quality-health` were working names used while the catalog was being normalized. They never made it into the parser, only into prose. Fixed by [20260525.01 plan 01.02](../20260525.01-context-fullcheck/01.02-dim-group-naming-alignment-plan.md).
3. **Vocabulary expansion** — net new groups (`--dim context-full`, `--dim context-health`, `--dim reliability`, `--dim model`, `--dim optimize`) are **not** aliases; they bundle different dimension sets and have independent identity.

### Why was the v12 group called `robustness` at all?

The v12 catalog overloaded the word *robustness* onto the consumer-correctness cluster (D5/D6/D16/D18) because, at that point in the system's history, there were no dedicated reliability dimensions — `boundaries + consistency + adherence + coverage` was the closest thing to a "system holds together under perturbation" check. The name was a misnomer borrowed from general SE vocabulary.

When the reliability use-case folder ([20260524.03 fix workstream 2](../20260524.03-use-cases-have-no-reliabilitychecks/overview.md)) and dimensions D28–D35 were introduced in v13, the misnomer became visible. The fix had two halves:

- **Half 1 (executed):** rename the v12 group to `--dim adherence` so the name now matches what the dimensions actually check.
- **Half 2 (declared in vision, NOT executed in parser):** free the name `robustness` and make it a synonym for `--dim reliability` (D28–D35), per [vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md): *"The name 'robustness' is **freed and kept synonymous with `--dim reliability`**."*

The back-compat alias `robustness → adherence` was meant as a one-release migration bridge between Half 1 and Half 2. It was never meant to be the steady state.

### Finding 1 — Only one true `--dim` alias remains

After the 20260525.01 fixes, the alias inventory collapses to exactly one entry:

| Alias | Resolves to | Status | Catalog row | Parser test |
|---|---|---|---|---|
| `--dim robustness` | `--dim adherence` (D5, D6, D16, D18) | **Deprecated**, one-release window | [05.07 row 8](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | A-R14 (accepted with notice), CF-06 (deprecation message body) |

All other `--dim` names in the codebase are either canonical groups or specific dimension IDs (`D1`–`D35`).

### Finding 1b — The alias direction contradicts the vision

[Vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) (Conflict resolution table, *Terminology overload* row) states **both** of the following, one after the other:

> The name 'robustness' is **freed and kept synonymous with `--dim reliability`** (system-level process reliability — reproducibility, loop stability, rollback readiness, boundary actionability).
>
> Back-compat: `--dim robustness` accepted for one release with deprecation notice; **resolves to `--dim adherence`**.

These two sentences specify opposite resolutions for the same input. The vision is internally contradictory at this point. The parser implements the second sentence; the user-facing readability claim is the first sentence. Until the back-compat alias is removed, **every `--dim robustness` invocation executes against the vision's stated semantics**.

This is the technical content behind the user's intuition: *robustness and adherence are not synonymous*. They aren't — and the vision itself agrees in the very same paragraph that defines the alias.

### Finding 2 — `context-quality-lifecycle` / `-health` are NOT redundant aliases, they are already gone

The user's prompt names `--dim context-quality-lifecycle` as an alias for `--dim context-full`. That description is historically true but operationally stale:

- **Catalog:** never defined as either a group or an alias
- **Parser:** would reject as `Unknown --dim value 'context-quality-lifecycle'` per CF-05 behavior
- **Prompt text:** zero occurrences as of [20260525.02 verification](../20260525.02-context-fullcheck-analysis/overview.md) (D17 PASS row)

So the *original* observation that triggered this issue is already resolved. The remaining question — "are any other `--dim` aliases redundant?" — has a precise answer below.

### Finding 3 — `robustness` deprecation is ready to complete

Evidence the migration window is mature:

- The deprecation notice has been live since the v13 release (catalog v1.0+).
- [`pe-meta-update.prompt.md`](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) line 65 already lists the v13 taxonomy with **no** `robustness` entry — the canonical surface no longer references it.
- No issue-folder reference under [src/docs/90. Issues/](../) invokes `--dim robustness` after the rename.
- The catalog row for `--dim robustness` reads "accepted for one release"; we are now multiple cycles past that.
- The vision-implementation contradiction (Finding 1b) is *active risk*, not pending risk — each day the alias remains is a day the parser runs the wrong dimensions under the vision-blessed name.

Risk of removal:

- Any external invocations using `--dim robustness` would start getting `Unknown --dim value 'robustness'` (per CF-05). The corrective message in CF-05 already enumerates **both** `adherence` and `reliability` as canonical groups, so the user is forced into an explicit choice that resolves the contradiction at the call site.
- The parser test rows A-R14 and CF-06 need to flip from "accepted with notice" to "rejected via CF-05" or be deleted.

### Finding 3b — Why retiring is correct, and silently rebinding to `reliability` would be wrong

The user's framing ("at most robustness could be replaced with reliability") describes a third option not previously analyzed:

| Option | Behavior on `--dim robustness` | Pros | Cons |
|---|---|---|---|
| **A — Rebind** | Resolve to `--dim reliability` (D28–D35) per vision wording | Honors the "freed and kept synonymous" half of vision v13 line 299 | Silently changes behavior for any current consumer using `--dim robustness` expecting `adherence` (D5/D6/D16/D18). The dimension sets are **disjoint** — a rebind runs zero of the previously-executed checks |
| **B — Retire** (recommended) | Reject with CF-05 enumeration listing both `adherence` and `reliability` | Forces explicit choice at the call site; resolves the vision contradiction by deleting the contradictory clause; no silent behavioral change | Breaking for any external caller of `--dim robustness`. Migration is a one-character edit (`robustness` → either `adherence` or `reliability`) and CF-05 documents the path. |
| **C — Status quo** | Keep resolving to `--dim adherence` indefinitely | Zero immediate change | Permanently encodes the vision contradiction; permanently surfaces deprecation noise; permanently misleads anyone reading vision v13 line 299 |

**Option B is the correct path** because:

1. The two target dimension sets — `adherence` (D5, D6, D16, D18) and `reliability` (D28–D35) — are **completely disjoint**. There is no "close enough" between them. A silent rebind (Option A) is functionally as breaking as a removal (Option B), but worse because it executes silently.
2. The user's mental model ("robustness ≈ reliability") matches the vision intent and standard SE usage. Anyone typing `--dim robustness` today expecting reliability checks is already getting the wrong result — Option A would fix that case, but Option B forces the caller to *spell out* which they meant, which is more robust against the next semantic drift.
3. The CF-05 rejection message already enumerates both groups. The migration is self-documenting.
4. Vision v13 line 299 should be rewritten in lock-step with the parser change: delete the contradictory back-compat clause; keep only the "name is freed" half, with a note that `robustness` is no longer a parser-accepted value and that callers should use `--dim reliability` (system-level) or `--dim adherence` (consumer-correctness) explicitly.

### Finding 4 — No alias-creation pressure detected

Scanning the broader option surface for new alias candidates:

| Group pair | Overlap | Is one an alias of the other? |
|---|---|---|
| `--dim efficiency` (11 dims) vs `--dim optimize` (10 dims) | 9 dims shared | **No** — `optimize` adds the `@meta-optimizer` delegation behavior on apply; different consumer contract |
| `--dim context-full` (16 dims) vs `--dim context-health` (8 dims) | `context-health` ⊂ `context-full` | **No** — `context-health` is the lightweight subset with explicit Stage-2 skip; different lifecycle behavior |
| `--dim full` (35 dims) vs others | All ⊂ `full` | **No** — `full` is the default-everything sentinel; conceptually distinct |

No further consolidation candidates. The 12-group taxonomy is already minimal.

### Severity confirmation

| Dimension | Verdict | Note |
|---|---|---|
| Functional behavior | 🟠 medium | All invocations resolve, but `--dim robustness` resolves contrary to the vision-blessed semantics (vision v13 line 299 says "synonymous with `--dim reliability`"; parser says `--dim adherence`) |
| Vision-implementation coherence (D17) | 🟠 medium | Vision and parser tests disagree on the canonical resolution. Two adjacent sentences in vision v13 specify opposite resolutions. |
| Catalog ↔ consumer drift risk | 🟡 low | One alias remaining beyond the contradiction itself |
| Documentation hygiene | 🟡 low | Catalog still carries a deprecated row; matrix and parser tests carry alias rows |
| User experience | 🟠 medium | A user typing `--dim robustness` today expecting reliability checks (per vision) gets adherence checks (per parser) — silent semantic miss |

**Net severity:** Medium. Not a defect-in-execution, but a defect-in-meaning. The pipeline behaves consistently with itself; it does not behave consistently with the vision.

---

## 🔄 Reproduction steps

### Repro 1 — Verify `robustness` is the only `--dim` alias

```powershell
# From repo root
Select-String -Path .copilot\context\00.00-prompt-engineering\05.07-pe-meta-dimension-catalog.md -Pattern 'alias|deprecated' -SimpleMatch
# Expected: one match — the "Deprecated — accepted for one release" row for --dim robustness
```

### Repro 2 — Verify `context-quality-*` names are gone

```powershell
# From repo root
Select-String -Path .github\prompts\00.09-pe-meta\*.md, .copilot\context\00.00-prompt-engineering\*.md `
  -Pattern 'context-quality-lifecycle|context-quality-health'
# Expected: zero matches (both names already removed by 20260525.01 plan 01.02)
```

### Repro 3 — Confirm parser still accepts `robustness` with notice

Trace through [pe-meta-option-parser-tests.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) rows:

- **A-R14:** `/pe-meta-review path.md --dim robustness` → resolves to `adherence` + deprecation notice
- **CF-06:** `/pe-meta-review path.md --dim robustness` → `[DEPRECATION] --dim robustness is deprecated; resolving to --dim adherence. Update invocations to --dim adherence before the next release.`

Both rows are still present, confirming the alias is live but on a published path to removal.

### Affected code locations

| File | Lines | Content |
|---|---|---|
| [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | Dimension-groups table | Row `--dim robustness` (deprecated) |
| [pe-meta-option-applicability-matrix.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) | Line 149 | "Dim alias: `--dim robustness` is a deprecated alias for `--dim adherence`" |
| [pe-meta-option-parser-tests.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) | A-R14, CF-05, CF-06 | Three parser test rows that mention `robustness` |

---

## ✅ Recommended dismissal plan

Three-step plan: retire the parser alias, fix the contradiction in the vision, and codify the no-new-aliases boundary.

**Option rejected up front:** rebinding `--dim robustness` to `--dim reliability` ("Option A" in Finding 3b) is **NOT recommended**. The two target dimension sets are disjoint, so a rebind is functionally as breaking as a removal — only silently. Removal forces the explicit choice at the call site that the disjoint semantics demand.

### Step 1 — Retire `--dim robustness` from the parser

| # | File | Change | Effort |
|---|---|---|---|
| 1.1 | [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | Delete the `--dim robustness` row from the dimension-groups table. Remove the matching bullet from the boundaries block. Bump catalog version (v1.2.0 → v1.3.0). Update `last_updated`. | XS |
| 1.2 | [pe-meta-option-applicability-matrix.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) | Delete the "Dim alias" note (line 149) and rephrase to say `--dim reliability` is the canonical group for D28–D35 (drop the `robustness` clause). | XS |
| 1.3 | [pe-meta-option-parser-tests.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) | Delete A-R14 and CF-06. Update CF-05's enumeration message to remove the trailing "Deprecated alias: 'robustness' → 'adherence'" clause; ensure the enumeration explicitly lists both `adherence` and `reliability` so callers can disambiguate. | XS |
| 1.4 | Code (parser implementation, if separate from tests) | Remove the `robustness → adherence` branch; let it fall through to the `Unknown --dim value` path in CF-05. | XS–S |

**Risk classification:** **breaking** for any external invocation of `--dim robustness`. CF-05 already enumerates the canonical groups, and the user must pick `adherence` (consumer-correctness) or `reliability` (system reliability) explicitly — the disjoint dimension sets make this the only safe migration.

**Gate:** `require-approval` (breaking change per [pe-meta-context-review.prompt.md § Risk Classification](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md)).

### Step 2 — Resolve the vision v13 contradiction

[Vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) currently asserts both `robustness ≡ reliability` and `robustness → adherence (back-compat)` in adjacent sentences. With Step 1 landed, the back-compat clause becomes false. Rewrite the row to a single coherent statement.

| # | File | Change | Effort |
|---|---|---|---|
| 2.1 | [20260523.01-vision.v13.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) Conflict-resolution table, *Terminology overload* row | Replace the contradictory paragraph with: "'Robustness' is a reliability property in standard SE usage. The legacy v12 `--dim robustness` group (bundling D5, D6, D16, D18) was renamed to `--dim adherence` because those dimensions check adherence to rules, not reliability properties. The reliability concept is now its own group, `--dim reliability` (D28–D35). The bare name `robustness` is **not** a parser-accepted value; callers must choose `--dim adherence` (consumer-correctness) or `--dim reliability` (system reliability) explicitly." Update `version` and `last_updated`. | XS |
| 2.2 | [20260503.02-vision-pe-meta-usecases/00-overview.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) | Update the table row and migration note to drop the back-compat clause. Mention only that the v12 `robustness` name was retired and that callers should pick `adherence` or `reliability` based on intent. | XS |
| 2.3 | [03-consumer-correctness/p0-01-dependency-aware-full-review.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md) | Remove the "legacy alias: `--dim robustness`" hint from the option row. | XS |
| 2.4 | [03-consumer-correctness/p1-01-guidance-adherence-verification.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/p1-01-guidance-adherence-verification-usecase.md) | Same as 2.3. | XS |

**Risk classification:** **non-breaking** (documentation-only). Step 2 must land *with* or *immediately after* Step 1; landing it before would leave the parser executing the old behavior with no documentation backing.

**Gate:** `require-approval` (vision change requires the same review as the parser change it documents).

### Step 3 — Codify the no-new-aliases boundary

Add an explicit boundary to the catalog's `boundaries:` block so future contributors do not re-introduce alias-only groups:

> **Boundary (proposed):** `--dim` aliases that resolve 1:1 to a canonical group SHOULD NOT be added. Migration aliases are permitted for **at most one release** with a deprecation notice; permanent readability aliases are not (they inflate the taxonomy and create catalog ↔ consumer drift risk per D17). When the underlying concept genuinely splits into disjoint dimension sets (as `robustness` did into `adherence` and `reliability`), the migration alias MUST be retired no later than the release immediately following the rename — silently rebinding to a disjoint dimension set is forbidden.

**Risk classification:** **non-breaking** (documentation-only boundary).

**Gate:** `apply-autonomously`.

---

## 📚 Additional information

### Testing recommendations

After Step 1 lands:

- [ ] Run [pe-meta-option-parser-tests.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) row CF-05 against a fresh invocation of `/pe-meta-review path.md --dim robustness` — must produce the `Unknown --dim value 'robustness'` rejection with **both** `adherence` and `reliability` enumerated in the corrective message
- [ ] Grep the entire repo for `robustness` to confirm zero references outside this issue folder and historical docs
- [ ] Run `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full` to verify D17 cross-coherence stays clean

After Step 2 lands:

- [ ] Re-read [vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) and confirm the contradiction is gone (no "synonymous with reliability" + "resolves to adherence" in the same paragraph)
- [ ] Grep the use-cases catalog for `legacy alias` references to `robustness` — zero expected

### Migration considerations

- The CF-05 corrective message names **both** `adherence` and `reliability` — the caller must consciously pick. The disjoint dimension sets make a silent migration impossible by design.
- No user-facing documentation outside the PE meta-pipeline references `--dim robustness`.
- Issue folders under [src/docs/90. Issues/](../) are historical and do not need updating; the existing prose pinning `robustness → adherence` documents the v12→v13 history correctly.

### Performance impact

None — alias-resolution is a parse-time lookup.

---

## ✔️ Resolution status

**Current status:** Analysis complete; **edits applied 2026-05-25** via execution plan [01.01-retire-robustness-alias-plan.md](01.01-retire-robustness-alias-plan.md). User approved Steps 1, 2, and 3 (kept both `--dim adherence` and `--dim reliability` as canonical groups per explicit decision).

### Verification checklist

- [x] Inventoried all `--dim` groups in [05.07](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)
- [x] Confirmed `robustness` is the only true `--dim` alias
- [x] Confirmed `context-quality-lifecycle` / `context-quality-health` are not aliases (already removed)
- [x] Confirmed no other consolidation candidates exist among the 12 canonical groups
- [x] Identified vision↔parser contradiction at [vision v13 line 299](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) (Finding 1b)
- [x] Verified disjoint dimension sets between `adherence` (D5/D6/D16/D18) and `reliability` (D28–D35) (Finding 3b)
- [x] Drafted three-step retirement plan with file-level edit list and risk classification
- [x] **User approved** Step 1 (breaking), Step 2 (non-breaking, vision-doc), Step 3 (non-breaking, boundary)
- [x] **Step 1 + Step 2 + Step 3 executed:** catalog v1.3.0 bumped, deprecated row removed, no-new-aliases boundary added, applicability matrix updated, parser tests A-R14 flipped to rejected + CF-06 deleted + CF-05 cleaned, vision v13 line 299 + 1155 rewritten, use-case README + 2 consumer-correctness files cleaned (3 remaining `robustness` mentions in repo are all intentional retirement/test/rejection documentation)

### Follow-up actions

| # | Action | Owner | Trigger | Status |
|---|---|---|---|---|
| F-01 | Approve / decline Step 1 (retire `robustness` from parser) | Dario | Review this analysis | ✅ approved 2026-05-25 |
| F-02 | Approve / decline Step 2 (fix vision v13 line 299 contradiction + use-case prose) | Dario | Review this analysis | ✅ approved 2026-05-25 |
| F-03 | Approve / decline Step 3 (no-new-aliases boundary) | Dario | Review this analysis | ✅ approved 2026-05-25 |
| F-04 | Create execution plan if Steps 1+2 approved | Agent | F-01 = approve AND F-02 = approve | ✅ done 2026-05-25 — see [01.01-retire-robustness-alias-plan.md](01.01-retire-robustness-alias-plan.md) |
| F-05 | Re-run `/pe-meta-context-review --dim context-full` after edits | Agent | F-04 complete | 🟡 todo (post-execution verification) |

---

## 🎓 Lessons learned

### What went right

- The deprecation notice mechanism (CF-06) made `robustness` a clean rename in form: users got runtime feedback, the canonical name was documented in the same surface, and the corrective message in CF-05 names the replacement.
- The catalog's "deprecated" row format (with explicit "accepted for one release" wording) is self-expiring documentation — it telegraphs its own end-of-life.
- [Issue 20260524.03](../20260524.03-use-cases-have-no-reliabilitychecks/overview.md) already diagnosed the *semantic* problem ("the word 'robustness' got bound to the wrong cluster, suppressing the gap by making it look filled"). The fix landed Half-1 (rename to `adherence`) and Half-1.5 (the back-compat alias) but never landed Half-2 (free the name and stop accepting it). This analysis closes that gap.

### What could be improved

- **Renames across disjoint semantic domains are not aliases.** When the new meaning and the old meaning execute disjoint dimension sets, a back-compat alias is not a migration aid — it is a guaranteed silent semantic miss for someone. The right tool is a CF-05 rejection that names *both* candidate destinations and forces the caller to pick.
- **Vision documents must not self-contradict.** Vision v13 line 299 specifies opposite resolutions for `--dim robustness` in two adjacent sentences. The PE meta-pipeline's own D6 (consistency / non-contradiction) check should have flagged this; the alias direction means it didn't, because the parser test rows are consistent with one half of the paragraph in isolation. **Improvement:** D6 checks against vision should examine each "both A and B" claim, not just each clause in isolation.
- **No expiry tracking** — the catalog says "one release" but does not name which release. A `deprecation_since: v13.0` / `removal_target: v13.2` pair would make the lifecycle deterministic and audit-friendly.
- **Alias-shaped prose** — the working names `context-quality-lifecycle` / `context-quality-health` lived in the prompt body for multiple revisions while never being wired into the parser. The 20260525.01 D17 finding caught it, but the gap window was several days. Adding the proposed no-new-aliases boundary to the catalog raises the bar at write-time.
- **Test-row debt** — every alias row in [pe-meta-option-parser-tests.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) survives the deprecation it documents. Retirement plans should explicitly close the corresponding test rows.

### Improvements for future

1. When adding any `--dim` group, require either independent dimension set or independent consumer contract (delegation behavior, stage ordering). Pure-readability aliases are out of scope.
2. Tag deprecation rows with concrete `since` / `target` versions, not narrative phrases.
3. Each `--dim` rename PR should attach a retirement-plan stub that names the parser test rows to delete at end-of-window.

---

## 📎 Appendix — full alias inventory

### A.1 Canonical `--dim` groups (12)

| Group | Dimensions | Identity |
|---|---|---|
| `--dim full` | All 35 | Default sentinel |
| `--dim structural` | D1-D5, D14 | Structural pass |
| `--dim quality` | D6, D7, D8, D9, D10, D11, D27 | Guidance quality |
| `--dim strategic` | D15, D16, D17, D19 | Vision + adherence + structure |
| `--dim freshness` | D12, D13 | Staleness + sources |
| `--dim efficiency` | D3, D4, D7, D9, D11, D20, D21, D23, D24, D25, D26 | Efficiency review |
| `--dim adherence` | D5, D6, D16, D18 | Boundaries + consistency + coverage |
| `--dim context-full` | D1-D3, D6-D15, D17, D19, D22 (16 dims) | Full context review |
| `--dim context-health` | D6-D12, D22 | Lightweight context check |
| `--dim model` | D26, D27 | Model routing |
| `--dim optimize` | D3, D7, D9, D11, D20, D21, D23, D24, D25, D26 | Performance + apply delegation to `@meta-optimizer` |
| `--dim reliability` | D28-D35 | System-reliability (goal-trio reliability pole) |

### A.2 `--dim` aliases (1 active, 2 already retired)

| Name | Resolves to | Status | Origin |
|---|---|---|---|
| `--dim robustness` | `--dim adherence` | 🟡 **Deprecated** — recommended for dismissal per Step 1 above | v12 → v13 rename |
| `--dim context-quality-lifecycle` | `--dim context-full` | ✅ Already removed (20260525.01 plan 01.02) | Working-name drift |
| `--dim context-quality-health` | `--dim context-health` | ✅ Already removed (20260525.01 plan 01.02) | Working-name drift |

### A.3 Out-of-scope alias surfaces (not `--dim`)

The user's question scoped to `--dim` aliases only. For completeness, other alias surfaces in the parser exist and are documented in [pe-meta-option-parser-tests.md § Alias routing behavior](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md):

| Alias | Resolves to | Justification |
|---|---|---|
| `--with-deps` | `--deps full` | Legacy ergonomic shortcut |
| `--with-deps-shallow` | `--deps direct` | Legacy ergonomic shortcut |
| `--plan` | `--mode plan` | Single-flag idiom |
| `--no-external`, `--no-research` | `--skip external`, `--skip research` | Negative-flag idiom |
| `--skip-source` | `--skip research` | Legacy stage-name rename |
| `--skip-structure`, `--skip-consistency`, `--skip-content` | `--skip <stage>` (hyphenated) | Legacy hyphenated form |

These aliases provide ergonomic / negative-flag forms; they are **not** redundant with their canonical names in the same way `--dim` aliases are (because they enable distinct syntactic patterns, e.g., `--no-external` reads naturally as a disable-flag where `--skip external` reads as an enable-list entry). Out of scope for this dismissal; flagged here only so the inventory is complete.

---

<!--
article_metadata:
  filename: "analysis.md"
  created: "2026-05-25"
  last_updated: "2026-05-25"
  version: "1.0"
  status: "applied"
  issue_type: "improvement"

cross_references:
  affected_artifacts:
    - ".copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md"
    - ".github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md"
    - ".github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md"
  related_issues:
    - "src/docs/90. Issues/202605/20260525.01-context-fullcheck/overview.md"
    - "src/docs/90. Issues/202605/20260525.02-context-fullcheck-analysis/overview.md"

validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}
-->
