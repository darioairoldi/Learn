# ISSUE: Numeric `D#` dimension references opaque + vision dimension counts drift vs. catalog - 20260601

Date: **01 Jun 2026**<br>
Author: **Dario Airoldi**

## Table of Contents

- [📝 DESCRIPTION](#-description)
- [ℹ️ CONTEXT INFORMATION / REPRO STEPS](#ℹ️-context-information--repro-steps)
- [🔍 ANALYSIS](#-analysis)
- [🛠️ RESOLUTION](#️-resolution)
- [➕ ADDITIONAL INFORMATION](#-additional-information)
- [📚 REFERENCES](#-references)

## 📝 DESCRIPTION

Two coupled problems were observed in the PE artifact set under [.copilot/context/00.00-prompt-engineering/](../../../../../.copilot/context/00.00-prompt-engineering/) and [06.00-idea/self-updating-prompt-engineering/](../../../../../06.00-idea/self-updating-prompt-engineering/):

1. **Opaque numeric dimension references.** Across the catalog, peer context files, the vision, agents, templates, prompts, and use cases, review dimensions were referenced by bare numeric IDs (`D1` … `D27`). Readers could not tell what `D6` or `D17` meant without cross-referencing the catalog, and bare `D#` tokens were ambiguous when they appeared adjacent to ordinary numbers in narrative prose. The catalog itself had grown to **35 dimensions** but downstream artifacts still spoke about *"all 27"* dimensions, so the numeric IDs no longer corresponded reliably to a stable dimension count either.

2. **Vision dimension counts drifted from the catalog.** The [self-updating-prompt-engineering/20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) *Dimension applicability matrix* and its surrounding prose still described **27 dimensions**, **11 non-applicable** entries for `--dim full` on context files, and exposed only the legacy type-scoped groups (`--dim full / structural / quality / strategic / freshness / efficiency / adherence / model / optimize / context-full / context-health`). The authoritative catalog at v1.4.0 in [.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) had already grown to **35 dimensions** (D28-reproducibility … D35-portability-boundary added as the Tier 2 "reliability" pole) and **12 `--dim` shortcut groups** (adding `reliability`), but those additions were invisible from the vision. The dimension-count drift was first surfaced as **Park lot Q3** inside the rename plan and explicitly deferred so the mechanical rename phases could complete without scope creep.

Together these two problems made the dimension model harder to read, harder to invoke (the reliability shortcut was undocumented from the vision), and weakly self-consistent (downstream artifacts disagreed with the catalog on totals).

## ℹ️ CONTEXT INFORMATION / REPRO STEPS

| Field | Value |
|---|---|
| **Authoritative catalog** | [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) v1.4.0 (35 dimensions, 12 `--dim` groups) |
| **Primary downstream artifact** | [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) |
| **Companion changelog** | [20260531.01-vision.changelog.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md) |
| **Rename plan** | [01-dimids-rename-plan.md](01-dimids-rename-plan.md) (9 phases, suffix-append form) |
| **Files touched by rename** | ~45 across catalog, peer context, vision, use cases, agents, templates, prompts, implementation-status |
| **Park lot item closing the count drift** | Q3 — *"Inconsistent dimension counts in the vision"* |
| **Governing instruction files** | [vision-amendment.instructions.md](../../../../../.github/instructions/vision-amendment.instructions.md), [plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md), [plan-marking.instructions.md](../../../../../.github/instructions/plan-marking.instructions.md) |

**To reproduce (before the fix):**

1. Open the vision at [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) and search for bare tokens matching `\bD[0-9]+\b` (not followed by `-`). Observe 100+ occurrences across the dimension applicability matrix, Phase C/D/E descriptions, the `--dim <group|D#>` parameter row, the process-to-rationale mapping table, and the legacy-robustness paragraph.
2. Compare the *Dimension applicability matrix* in the vision against the same matrix in [.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). Note that the catalog defines D28–D35 while the vision matrix stops at D27.
3. Search the vision prose for `all 27` and `11 non-applicable`. Both phrasings predate the D28-D35 additions.
4. In the catalog, count the `--dim` groups in *§ Dimension groups (shortcuts)*: 12 groups including `reliability`. In the vision's *Type-scoped dimension groups* table: only 11 groups, no `reliability` row.
5. Open the `pe-prompt-engineering-validation` SKILL at [.github/skills/pe-prompt-engineering-validation/SKILL.md](../../../../../.github/skills/pe-prompt-engineering-validation/SKILL.md): observe a parallel `D1`-`D11` namespace that collides with the PE catalog's `D1`-`D11` when read in isolation.

## 🔍 ANALYSIS

### Root cause (problem 1 — opaque IDs)

The catalog originally exposed dimensions as numeric `D#` only. As the system grew (D17 added, D28-D35 added in v1.4.0), downstream artifacts kept the numeric form because:

- Numeric prefixes were easy to grep and stable under reordering.
- No instruction file required a readable suffix.
- The vision's `principles:` block depends on grep-able numeric prefixes, so authors avoided any change that looked like a "rename".

The result was a system where readers had to keep the catalog open in another window to interpret every `D#` reference in any other file.

### Root cause (problem 2 — count drift)

The vision's dimension surface area drifted because:

- The applicability matrix was authored at v12 (27 dimensions) and not extended when the catalog gained D28-D35.
- The phrasings `(all 27)` and `11 non-applicable` were embedded in narrative prose, not derived from any computed total, so adding catalog rows did not automatically invalidate them.
- The 12 `--dim` group shortcuts were defined in the catalog but never forward-referenced from the vision, so the vision's type-scoped table was the only group surface that authors saw — and it was incomplete (missing `reliability`).
- The mismatch was visible but explicitly deferred (Park lot Q3) so the in-flight rename plan could finish without absorbing scope creep.

### Why a suffix-append (not a rename) for problem 1

The original framing was "rename D# to readable IDs". Park lot Q1 showed that this would break the vision's `principles:` block (which relies on numeric grep-ability) and require a `*vision*plan*.md` amendment plan. Switching to a **suffix-append** — producing the combined form `D#-readable-id` (e.g., `D6-consistency`, `D35-portability-boundary`) — preserves the numeric prefix permanently while making every reference self-describing. This eliminated the contract-break risk, closed Q1/Q2/Q5 in the same decision, and removed the justification for splitting into a sibling amendment plan (Q6).

### Why the SKILL keeps its own `D1`-`D11`

The `pe-prompt-engineering-validation` SKILL is an independent framework with its own dimension namespace. Renaming its `D#` to the PE-catalog suffixes would conflate two distinct systems. The resolution (Park lot Q5) appends suffixes drawn from the SKILL's own list and adds a one-line disambiguation note rather than aligning to the PE catalog.

### Why this matters

| Concern | Impact |
|---|---|
| **Readability** | `D6` requires a catalog lookup; `D6-consistency` is self-describing in-line. |
| **Disambiguation** | Bare `D27` next to ordinary numbers ("D27 covers 5 cases") is brittle for grep and skim-reading. |
| **Discoverability of groups** | The vision is the most-read artifact; if it lists 11 groups, authors never invoke the missing one (`--dim reliability`). |
| **Self-consistency** | A vision that says `all 27` while the catalog says 35 is an immediately visible governance failure. |
| **Future churn** | The combined `D#-readable-id` form is stable under reordering AND under suffix changes (numeric prefix is the contract). |

### Why two phases, not one

The two problems are coupled but separable. The rename is purely mechanical (suffix-append per rewrite rules, verifiable by grep). The count alignment requires authorial judgement (which dimensions apply to which file type for D28-D35). Mixing them risked the mechanical rename absorbing the harder semantic work. The plan therefore explicitly SURFACED the count inconsistency in the vision's *Most recent changes* block during Phase 4 and opened Park lot Q3, then resolved Q3 in a follow-up vision edit (v15.0.2) once the rename was complete.

## 🛠️ RESOLUTION

### Step 1 — Confirm canonical form and rewrite rules (✅ done)

Resolved Park lot Q1 by adopting the **suffix-append** canonical form `D#-readable-id` (e.g., `D6-consistency`, `D35-portability-boundary`). Authored 5 explicit rewrite rules in [01-dimids-rename-plan.md](01-dimids-rename-plan.md) covering: list-style enumerations, table cells, narrative prose, historical/status assertions (which keep the bare `D#`), and the `--dim <group|D#>` parameter surface (which now reads `--dim <group|D#-readable-id>` while still accepting bare `D#` as input). The vision's `principles:` block is NOT modified; the numeric grep contract is preserved.

### Step 2 — Execute 9-phase mechanical rewrite (✅ done)

Phases 1–9 of [01-dimids-rename-plan.md](01-dimids-rename-plan.md) apply the rewrite rules to:

1. Authoritative catalog
2. Peer context files (`05.0x-*`)
3. SKILL files (with disambiguation note for `pe-prompt-engineering-validation` — Park lot Q5)
4. Vision body (applicability matrix, Phase C/D/E descriptions, `--dim` parameter row, process-to-rationale table, legacy-robustness paragraph)
5. Use-case documents
6. Agents
7. Templates
8. Prompts
9. Implementation-status references (per rewrite rule 5, historical assertions keep the bare `D#`)

Final residual scan via [scripts/find-residuals-wide.ps1](../../../../../scripts/find-residuals-wide.ps1) returns **TOTAL: 0** — no bare `D[0-9]+` token survives outside the principles block, historical-status contexts, and the SKILL's own namespace.

### Step 3 — Surface dimension-count drift in v15.0.1 (✅ done)

During Phase 4, the *Most recent changes* block of [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) was edited to surface the `(all 27)` / `11 non-applicable` / matrix-stops-at-D27 inconsistency vs. catalog v1.4.0, without fixing it. Park lot Q3 was opened with status `🟡 OPEN, non-blocking` and explicitly scoped out of the rename plan.

### Step 4 — Close Q3 via vision v15.0.2 alignment (✅ done)

A follow-up edit to the vision (no `principles:` change, no amendment plan required) closed Park lot Q3:

| Change | Detail |
|---|---|
| **Matrix extension** | Added 8 rows `D28-reproducibility` through `D35-portability-boundary` with ✅/❌ per catalog *Applicable-to* column. |
| **Totals recomputed** | Context **16→19**, Instruction **13→15**, Agent **21→29**, Prompt **22→30**, Skill **6→8**, Template **6→8**, Hook **4→5**, Snippet **5→6**. |
| **Prose alignment** | `(all 27)` → `(all 35)`; `11 non-applicable` → `16 non-applicable`; new dimensions listed (D28, D31-D34) for `--dim full` non-applicability on context files. |
| **Group surfacing** | New `--dim reliability` row added to the *Type-scoped dimension groups* table covering D28-D35 for agents and prompts. |
| **Forward reference** | New 📖 line after the groups table pointing to [.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md § Dimension groups (shortcuts)](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) so all 12 groups are discoverable from the vision. |
| **Tier classification** | New explanatory paragraph below the matrix names the two tiers: **Tier 1 = quality/strategic** (`D1-metadata` … `D27-model-adherence`), **Tier 2 = reliability** (`D28-reproducibility` … `D35-portability-boundary`). `--dim reliability` is the canonical Tier 2 invocation. |
| **Version bump** | Vision `version: "15.0.1"` → `"15.0.2"`. Changelog [v15.0.2 entry](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md) prepended under `## v15 — 2026-05-31`. |

### Step 5 — Close Park lot Q3 + finalize plan (✅ done)

In [01-dimids-rename-plan.md](01-dimids-rename-plan.md):

- Park lot preface line updated from *"Q1, Q2, Q5 are CLOSED"* to *"Q1, Q2, Q3, Q5 are CLOSED"*.
- Q3 marked `✅ CLOSED (2026-06-01, vision v15.0.2)` with resolution pointing to the v15.0.2 changes above.
- Bottom `plan_metadata` bumped: `version: "0.2.0" → "0.3.0"`, `status: "actionable" → "done"`, new `v0.3.0` changes entry recorded.

### Verification (✅ done)

| Check | Result |
|---|---|
| Final residual scan via [find-residuals-wide.ps1](../../../../../scripts/find-residuals-wide.ps1) | **TOTAL: 0** ✅ |
| Vision matrix row count matches catalog dimension count | 35 rows ✅ |
| Vision `Total applicable` row recomputed for D1-D35 | 19 / 15 / 29 / 30 / 8 / 8 / 5 / 6 ✅ |
| `--dim` groups surfaced in vision (table + forward reference) | 12 groups discoverable ✅ |
| Vision `principles:` block untouched (numeric grep contract preserved) | ✅ |
| `pe-prompt-engineering-validation` SKILL retains independent D1-D11 namespace with disambiguation note | ✅ |
| Plan status reflects done state at both top frontmatter and bottom `plan_metadata` | ✅ |

## ➕ ADDITIONAL INFORMATION

- The combined `D#-readable-id` form is **stable under suffix changes** as well as reordering — only the numeric prefix is part of the contract. Authors may refine a suffix (e.g., `D17-runtime-feasibility` → `D17-feasibility`) without breaking grep on `D17`.
- The vision's `principles:` block is the **only** location where bare `D#` form is contractually required. Anywhere else, the combined form is preferred even where the bare form would compile.
- Park lot items still open: **Q4** (implementation-status historical traceability — addressed by rewrite rule 5, validated during Phase 9) and **Q6** (split-plan decision — closed by the suffix-append approach). Verification item 3 in the plan (`pe-meta-validator regression`) is deferred and remains `🟡 todo` — explicit out-of-scope for this issue.
- Per-file version bumps for the ~45 files rewritten in Phases 5-9 were not individually applied; the per-file `version` field churn was deemed disproportionate to a mechanical token rewrite. Files touched in single-file targeted edits (vision, changelog, plan) did receive version bumps.
- The dimension-count drift can recur the next time the catalog gains a dimension. The mitigation is the new forward reference from the vision to the catalog's *§ Dimension groups (shortcuts)* — any future group addition surfaces in the catalog and the vision links to it, rather than the vision having to re-enumerate the group list.
- This issue does NOT propose lint enforcement of the `D#-readable-id` form. The current safeguard is the residual scan script ([find-residuals-wide.ps1](../../../../../scripts/find-residuals-wide.ps1)) which can be re-run after any PE artifact edit.

## 📚 REFERENCES

- [01-dimids-rename-plan.md](01-dimids-rename-plan.md) 📒 [Repo]<br>
  Companion 9-phase plan governing the mechanical rewrite. Now at v0.3.0 / `done`. Park lot tracks the surfaced questions and their resolutions.

- [.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) 📘 [Repo]<br>
  Authoritative dimension catalog (v1.4.0). Source of truth for the 35 dimensions and the 12 `--dim` shortcut groups. Vision body is aligned to this file.

- [20260531.01-vision.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) 📒 [Repo]<br>
  Primary downstream artifact aligned in v15.0.2 (matrix D1-D35, recomputed totals, `--dim reliability` row, forward reference to catalog groups, Tier 1/Tier 2 paragraph). `principles:` block intentionally untouched.

- [20260531.01-vision.changelog.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md) 📒 [Repo]<br>
  Canonical changelog. Carries the v15.0.2 entry documenting the count-alignment + group-surfacing work that closed Park lot Q3.

- [.github/skills/pe-prompt-engineering-validation/SKILL.md](../../../../../.github/skills/pe-prompt-engineering-validation/SKILL.md) 📘 [Repo]<br>
  Independent framework with its own D1-D11 namespace. Kept distinct from the PE catalog per Park lot Q5; received a one-line disambiguation note rather than alignment.

- [.github/instructions/vision-amendment.instructions.md](../../../../../.github/instructions/vision-amendment.instructions.md) 📘 [Repo]<br>
  Governs `*vision*plan*.md` amendment plans. Not triggered by this issue because the `principles:` block was not modified (Park lot Q2 resolution).

- [.github/instructions/plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md) 📘 [Repo]<br>
  Plan lifecycle (draft / actionable / in-progress / done) and Park lot semantics applied throughout this issue.

- [.github/instructions/plan-marking.instructions.md](../../../../../.github/instructions/plan-marking.instructions.md) 📘 [Repo]<br>
  Status suffix notation (`(✅ done)`, `(🟡 todo)`) used in the plan and in this overview's verification tables.

- [scripts/find-residuals-wide.ps1](../../../../../scripts/find-residuals-wide.ps1) 🔧 [Repo]<br>
  Residual-scan PowerShell script that verifies no bare `D[0-9]+` token survives outside the principles block, historical-status contexts, and the SKILL's namespace. Final run returns `TOTAL: 0`.
