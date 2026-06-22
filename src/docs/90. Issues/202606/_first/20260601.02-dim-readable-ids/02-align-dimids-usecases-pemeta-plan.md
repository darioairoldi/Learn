# ISSUE: Use-case READMEs don't anchor to the dimension catalog; dimension coverage is unenforceable - 20260601 (✅ done)

Date: **01 Jun 2026**<br>
Author: **Dario Airoldi**<br>
Status: **✅ Resolved 01 Jun 2026** — all 6 resolution steps complete. See [03-coverage-audit.md](03-coverage-audit.md) for the dimension-coverage report (35/35 dimensions, 12/12 `--dim` groups). Three non-blocking drift items parked for follow-up in the audit's PL section.

## Table of Contents

- [📝 DESCRIPTION](#-description)
- [ℹ️ CONTEXT INFORMATION / REPRO STEPS](#ℹ️-context-information--repro-steps)
- [🔍 ANALYSIS](#-analysis)
- [🛠️ RESOLUTION](#️-resolution)
- [➕ ADDITIONAL INFORMATION](#-additional-information)
- [📚 REFERENCES](#-references)

## 📝 DESCRIPTION

The use-case catalog under [06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) is the canonical landing target for vision-amendment coverage promises. After the suffix-append rename closed in issue [20260601.02-dim-readable-ids/01-dimids-rename-plan.md](01-dimids-rename-plan.md) and the catalog/vision alignment closed in [overview.md](overview.md) (catalog v1.4.0 — **35 dimensions, 12 `--dim` groups**), the use-case folder READMEs were left in a state where three coupled gaps remain visible:

1. **No anchor to the canonical dimension catalog.** Folder READMEs (e.g. [01-freshness/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/00-overview.md), [02-quality-gates/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/02-quality-gates/00-overview.md), [03-consumer-correctness/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/00-overview.md), [04-efficiency/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/04-efficiency/00-overview.md)) mention `--dim` shortcuts inline but do not link to [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) as the authoritative definition of those shortcuts. Only [05-reliability/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/00-overview.md) anchors back to a definitional source (the vision), and even that anchors to the vision rather than the dimension catalog.

2. **Coverage is asserted in prose, not enforced.** Each folder README declares "When to start here" prose, but no folder README publishes a `## 📐 Dimensions covered` matrix that maps the folder's use cases onto specific `D#-readable-id` rows and `--dim` groups from the catalog. Consequently, "every dimension and every `--dim` group is covered by at least one use case" is an unverifiable assertion: an audit script cannot mechanically detect the absence of, say, a use case touching `D32-rollback-safety` or invoking `--dim model`.

3. **Filename suffix proposal collides with the canonical use-case filename.** The user proposed adopting a `-usecase.md` suffix for use-case files. The canonical filename in [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) v1.0.0 is `p<priority>-<order>-<slug>.md`. Adding `-usecase.md` would either (a) extend the canonical pattern to `p<priority>-<order>-<slug>-usecase.md`, doubling identifier length without disambiguation benefit (the `pN-NN-` prefix is already a strong, unique marker that no other file class in the folder uses), or (b) replace the prefix with the suffix, losing mechanical prioritization.

Together these gaps mean the use-case set cannot serve as a reliable coverage object for the dimension catalog: a reader cannot quickly locate the catalog from any folder README, and a reviewer cannot mechanically verify that all 35 dimensions and all 12 `--dim` groups are realized somewhere in the use-case set.

## ℹ️ CONTEXT INFORMATION / REPRO STEPS

| Field | Value |
|---|---|
| **Authoritative catalog** | [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) v1.4.0 (35 dimensions, 12 `--dim` groups) |
| **Use-case catalog root** | [20260503.02-vision-pe-meta-usecases/00-overview.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) |
| **Use-case index** | [usecase-index.json](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json) |
| **Per-folder READMEs** | `01-freshness/README.md`, `02-quality-gates/README.md`, `03-consumer-correctness/README.md`, `04-efficiency/README.md`, `05-reliability/README.md` |
| **Use-case filename rule** | [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) v1.0.0 (`p<priority>-<order>-<slug>.md`) |
| **Predecessor issue** | [overview.md](overview.md) (catalog ⇄ vision alignment, suffix-append rename) |
| **Sibling plan** | [01-dimids-rename-plan.md](01-dimids-rename-plan.md) |
| **Governing instruction files** | [vision-amendment.instructions.md](../../../../../.github/instructions/vision-amendment.instructions.md), [plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md) |

**To reproduce:**

1. Open [20260503.02-vision-pe-meta-usecases/01-freshness/00-overview.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/01-freshness/00-overview.md). Search for `dimension catalog`, `05.07-pe-meta-dimension-catalog`, or any link to `.copilot/context/00.00-prompt-engineering/`. Observe: **no match**. The `--dim freshness` shortcut is referenced in the "Recommended command entry points" table but not linked to its definition.
2. Repeat for `02-quality-gates`, `03-consumer-correctness`, `04-efficiency`. Same result.
3. Open [05-reliability/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/00-overview.md). Search for the same patterns. Observe: a `📋 Coverage matrix (vision anchors → use cases)` table exists for vision anchors `R1`…`R12`, but **no equivalent matrix for `D#-readable-id` dimensions** and no link to the dimension catalog.
4. Open the top-level [20260503.02-vision-pe-meta-usecases/00-overview.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md). The `⚙️ Dimension group shortcuts` table embeds the catalog's `--dim` group definitions inline; it does not delegate to the catalog. Risk: drift the next time the catalog gains a group.
5. Open [usecase-index.json](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json). Observe: each entry has `id`, `group`, `priority`, `path`, `order`, `title`. **No `dimensions_covered: []` field.** An audit cannot derive the dimension-coverage matrix from the index alone.
6. Attempt the audit manually: list the 35 catalog dimensions (`D1-metadata` … `D35-portability-boundary`) and the 12 `--dim` groups. For each, locate the use case(s) realizing it. Observe that no single source records this mapping; the analysis must be reconstructed from individual use-case bodies.

## 🔍 ANALYSIS

### Root cause (gap 1 — no catalog anchor in folder READMEs)

The folder READMEs were authored before the catalog reached v1.4.0 and before the `--dim` group surface stabilized at 12 entries. At authoring time, the `--dim` token was self-explanatory in narrative context and no single dimension catalog file existed yet. After the catalog was extracted into [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md), no instruction file required folder READMEs to link back to it. The omission was therefore silent.

### Root cause (gap 2 — coverage is prose-only)

The use-case set inherited a prose-first authoring style from the vision: "use these cases when the main risk is X". This phrasing is human-readable and works for a human reviewer doing a single audit, but it does not yield a coverage matrix that a script can verify. The reliability folder ([05-reliability/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/00-overview.md)) pioneered a `Coverage matrix (vision anchors → use cases)` table but applied it only to the R1–R12 vision anchors, not to dimensions. The pattern was never generalized.

`usecase-index.json` is the natural carrier for a machine-checkable coverage object, but it currently records only routing metadata (id, group, priority, path, order, title). It has no field declaring which `D#-readable-id` dimensions a use case exercises, so even a perfect set of inline declarations inside each use case body would not be mechanically aggregatable.

### Root cause (gap 3 — `-usecase.md` suffix is redundant)

The proposal originates from a real concern: use-case files sit next to READMEs, index files, and templates in the same folder, and a naming convention would make them visually obvious. However:

- The canonical filename `p<priority>-<order>-<slug>.md` already begins with a unique 5-character marker (`p0-01-`, `p1-03-`, etc.) that no other file class in the use-case folders uses.
- README files are named `README.md`. The index is `usecase-index.json`. Templates live under `.github/templates/`. None of these overlap with the use-case filename pattern.
- The instruction file [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) v1.0.0 already provides a regex-equivalent recognition rule (`p[0-9]-[0-9]{2}-<slug>.md`).

Adding `-usecase.md` therefore solves no disambiguation problem and introduces three new costs: (a) every use-case path becomes longer, (b) the recognition regex changes (and every consumer of the regex must be updated in lockstep), (c) the canonical example links in the instruction file and in `usecase-index.json` need re-pointing. The cost-benefit analysis does not justify the change.

### Why this matters

| Concern | Impact |
|---|---|
| **Discoverability** | A reader landing on a folder README cannot reach the dimension catalog in one click. The `--dim` token is referenced but its definition is invisible from where it is used. |
| **Audit-ability** | "Every dimension is covered by ≥1 use case" cannot be mechanically verified. Coverage gaps are only detectable by ad-hoc manual review, which scales poorly as the catalog grows. |
| **Drift surface** | The top-level README's `Dimension group shortcuts` table embeds the catalog's `--dim` definitions inline. The catalog gains a 13th group → the top-level table becomes silently stale. |
| **Coverage promise enforcement** | [vision-amendment.instructions.md](../../../../../.github/instructions/vision-amendment.instructions.md) requires every in-scope vision item to land somewhere; use cases are the canonical landing target. Without a coverage matrix per folder and per index entry, the promise is unverifiable end-to-end. |
| **Filename churn risk** | Adopting `-usecase.md` reshapes ~30 paths and updates every back-reference. The cost is non-trivial and yields no audit benefit the canonical prefix does not already provide. |

### Why three coupled (but separable) workstreams

The three gaps share the same underlying concern (use-case set ⇄ dimension catalog coherence) but are independently actionable:

- Gap 1 is a documentation edit (link insertion across 5 READMEs + 1 top-level README).
- Gap 2 requires (a) a new `## 📐 Dimensions covered` section in each folder README, (b) a `dimensions_covered: []` field in `usecase-index.json`, (c) an extension to [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) that mandates both at the README and the index level, and (d) a one-shot back-fill of the new field from existing use-case bodies. This is the largest workstream by edit count but is mechanical once the rule and template land.
- Gap 3 is a decision: **do not adopt** `-usecase.md`. The decision should be recorded in the instruction file's rationale so the proposal does not recur.

Splitting them mirrors the pattern from [overview.md](overview.md) (rename ≠ count alignment), keeps each change reviewable in isolation, and lets gap 1 ship immediately while gap 2 absorbs the larger authoring effort.

## 🛠️ RESOLUTION

### Step 1 — Decision: reject the `-usecase.md` suffix (✅ done)

Record in [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) under a new `## Naming decisions` subsection that the canonical filename remains `p<priority>-<order>-<slug>.md`. Rationale: the `pN-NN-` prefix is already a unique marker within use-case folders, and `-usecase.md` adds path length without disambiguation benefit. The decision closes a recurring naming proposal so subsequent reviews do not relitigate it.

**Owner:** instruction-file authoring pass.
**Acceptance:** new subsection present; decision rationale linked from this issue.

### Step 2 — Anchor all folder READMEs to the dimension catalog (✅ done)

For each of the 5 folder READMEs (`01-freshness` … `05-reliability`) and the top-level `20260503.02-vision-pe-meta-usecases/00-overview.md`:

| Edit | Detail |
|---|---|
| **Catalog reference block** | Add a `## 📚 Dimension catalog` section near the top, linking to [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) and stating "The catalog is the authoritative definition of every `D#-readable-id` dimension and every `--dim` group referenced below." |
| **Delegate `--dim` definitions** | In the top-level README's `⚙️ Dimension group shortcuts` table, replace inline definitions with a single delegating paragraph + link to the catalog's *§ Dimension groups (shortcuts)*. Keep only the cross-folder routing column (which group → which folder). |

**Acceptance:**
- 6 READMEs link to the catalog by relative path
- Top-level README no longer duplicates the catalog's group definitions

**Outcome (01 Jun 2026):** Added `## 📚 Dimension catalog` section to top-level README and all 5 folder READMEs, each linking to [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md). Top-level README's `⚙️ Dimension group shortcuts` table replaced with a folder-routing table (group → primary folder → companion folders); inline dimension lists removed (now delegated to the catalog).

### Step 3 — Add `## 📐 Dimensions covered` matrix to every folder README (✅ done)

In each folder README, immediately after `📋 Run order`, add:

```markdown
## 📐 Dimensions covered

| Dimension (`D#-readable-id`) | `--dim` group | Realizing use case(s) |
|---|---|---|
| D6-consistency | quality | [p1-01-consistency-check](p1-01-consistency-check.md) |
| ... | ... | ... |
```

Rows MUST come from the folder's use-case bodies (no invention). Dimensions touched by ≥1 use case in the folder appear; dimensions belonging to other folders do not.

**Acceptance:**
- Every folder README contains the `📐 Dimensions covered` matrix
- Union of matrices across folders ≡ full catalog set (35 dimensions, 12 groups)
- Any gap surfaces as a Park lot item in this plan, not as a silent omission

**Outcome (01 Jun 2026):** Added `## 📐 Dimensions covered` matrix to all 5 folder READMEs. Row counts: 01-freshness (5), 02-quality-gates (13), 03-consumer-correctness (7), 04-efficiency (12), 05-reliability (9). Union ≡ 35 catalog dimensions (see [03-coverage-audit.md](03-coverage-audit.md)).

### Step 4 — Extend `usecase-index.json` with `dimensions_covered` (✅ done)

Schema change: each use-case entry gains an array field:

```json
{
  "id": "p1-02-multipass-validation-invariant",
  "group": "05-reliability",
  "priority": "P1",
  "path": "05-reliability/p1-02-multipass-validation-invariant.md",
  "order": 2,
  "title": "Multi-pass validation invariant",
  "dimensions_covered": ["D29-loop-stability", "D30-validation-invariant"]
}
```

Back-fill the field from each use case's `## 📐 Dimensions covered` section (mandated by Step 5).

**Acceptance:**
- Every entry has `dimensions_covered` (possibly empty `[]` with an explicit rationale in the use-case body)
- A simple aggregation script can produce a catalog-vs-realized coverage report

**Outcome (01 Jun 2026):** Index bumped to v2.3.0. All 33 entries now carry a non-empty `dimensions_covered` array using canonical `D#-readable-id` form, inserted between `title` and `command_family`. JSON validity preserved (no parse errors).

### Step 5 — Extend the use-case instruction file (✅ done)

Update [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) v1.0.0 → v1.1.0:

| Change | Detail |
|---|---|
| **Add README-level rule** | A new section "## README rules" mandating that every folder README contains (a) a `📚 Dimension catalog` link, (b) a `📐 Dimensions covered` matrix. |
| **Add index-level rule** | Mandate the `dimensions_covered` field in `usecase-index.json` entries. |
| **Promote `## 📐 Dimensions covered` to required-section status** | Already present in the required-section list as item 4; tighten the rule to require explicit `D#-readable-id` form (not bare `D#`) per the rewrite rules from [01-dimids-rename-plan.md](01-dimids-rename-plan.md). |
| **Naming decision** | Add the `## Naming decisions` subsection from Step 1. |

**Acceptance:**
- Instruction file version bumped
- Quality checklist updated to cover README and index rules
- References section points to the dimension catalog

**Outcome (01 Jun 2026):** [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) bumped v1.0.0 → v1.1.0. Added: README Rules section, Index Rules section, `## Naming Decisions` subsection (rejecting `-usecase.md`). Tightened required-sections rule #4 to demand canonical `D#-readable-id` form. Quality Checklist split into three subsections (Use-case document / Folder README / Index). References expanded with catalog link.

**Amendment (01 Jun 2026, ✅ done):** The Step 1 / Step 5 Naming Decision rejecting the `-usecase.md` suffix was **reversed** after surfacing the `applyTo`-targeting requirement (instruction-file rules need a glob pattern that excludes the folder overview file). The instruction file was bumped v1.1.0 → v1.2.0 to (a) adopt `p<priority>-<order>-<slug>-usecase.md` as canonical, (b) rename folder overviews from `README.md` to `00-overview.md` so they sort before use-case bodies in any listing AND can be targeted by a distinct `applyTo` glob. All 35 use-case files and 6 overview files were renamed, the index bumped to v2.4.0, and all cross-references updated. See [04-usecase-suffix-and-overview-sort-plan.md](04-usecase-suffix-and-overview-sort-plan.md) for the full reversal plan and rationale.

### Step 6 — Coverage audit (✅ done, after Steps 2–5)

Run a one-shot audit:

1. Parse `usecase-index.json` → collect union of `dimensions_covered` across all entries.
2. Parse [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) → extract the 35 canonical `D#-readable-id` rows and the 12 `--dim` groups.
3. Diff. Any catalog dimension or group with zero realizing use cases is a **coverage gap**.

**Acceptance:**
- Audit script (or manual report) committed under this issue folder
- Each gap is either: (a) closed by a new use case, or (b) explicitly accepted in a Park lot entry with rationale
- Catalog ⇄ use-case-set coverage promise is mechanically verifiable

**Outcome (01 Jun 2026):** Manual audit committed at [03-coverage-audit.md](03-coverage-audit.md). Result: **35/35 dimensions covered, 12/12 `--dim` groups covered. No coverage gaps.** Three non-blocking drift items surfaced (duplicate UC-23 id, missing index entry for `p0-02-autonomous-improvement-workflow`, no literal `--dim adherence` entry point) and parked in the audit's PL section for follow-up.

## ➕ ADDITIONAL INFORMATION

### Park lot (open items surfaced during analysis)

| ID | Item | Status | Rationale |
|---|---|---|---|
| Q1 | Should `dimensions_covered` distinguish *primary* dimensions (the use case's reason for existing) from *incidental* dimensions (touched as a side effect)? | 🟡 OPEN, non-blocking | Resolve once a coverage gap surfaces; until then, flat list is sufficient. |
| Q2 | Should the audit be wired into a recurring check (e.g. `pe-meta-scheduled-review`) rather than run one-shot? | 🟡 OPEN, deferred to scheduled-review redesign | Out of scope here; record in the scheduled-review backlog. |
| Q3 | Should folder READMEs also publish a `--dim` group → use cases matrix, distinct from the dimension → use case matrix? | 🟢 RESOLVED — no | The group → use case mapping is already implicit in the `📋 Run order` (each folder is a `--dim` group). A second matrix duplicates information. |
| Q4 | Does the `pe-prompt-engineering-validation` SKILL's parallel `D1`–`D11` namespace require representation in the use-case coverage object? | 🟢 RESOLVED — no | The SKILL is an independent framework (per [overview.md](overview.md) Park lot Q5); its dimensions are out of scope for the PE-catalog coverage promise. |

### Estimated edit footprint

| Step | Files touched | Type |
|---|---|---|
| 1 | 1 | instruction edit |
| 2 | 6 | README edits |
| 3 | 5 | README edits |
| 4 | 1 | JSON schema + back-fill |
| 5 | 1 | instruction edit (version bump) |
| 6 | 1 (audit report) | new file under this issue folder |

Total: ~15 files, all in two locations (`20260503.02-vision-pe-meta-usecases/` and `.github/instructions/`). Mechanical scope; no consumer-artifact churn.

### Out of scope

- Reorganizing use-case folders or creating new ones
- Renaming any existing use-case file
- Changing the dimension catalog itself (already at v1.4.0 per [overview.md](overview.md))
- Adopting the `-usecase.md` suffix (explicitly rejected in Step 1)

## 📚 REFERENCES

- **📒** [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) — authoritative dimension catalog (v1.4.0, 35 dimensions, 12 `--dim` groups)
- **📒** [20260503.02-vision-pe-meta-usecases/00-overview.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) — top-level use-case catalog
- **📒** [usecase-index.json](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json) — machine-readable index (to be extended in Step 4)
- **📒** [05-reliability/README.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/00-overview.md) — pioneered the per-folder coverage-matrix pattern (for vision anchors)
- **📘** [use-case-documents.instructions.md](../../../../../.github/instructions/use-case-documents.instructions.md) — canonical use-case filename and section rules (target of Step 5)
- **📘** [vision-amendment.instructions.md](../../../../../.github/instructions/vision-amendment.instructions.md) — defines the coverage promise that this work makes mechanically verifiable
- **📘** [plan-execution.instructions.md](../../../../../.github/instructions/plan-execution.instructions.md) — lifecycle rules governing this plan file
- **🔗** [overview.md](overview.md) — predecessor issue (catalog ⇄ vision alignment, suffix-append rename)
- **🔗** [01-dimids-rename-plan.md](01-dimids-rename-plan.md) — sibling plan (mechanical rename rules referenced by Step 5)
