---
description: Reconcile re-run of /pe-meta-update '.github\instructions' --mode apply --deps full — sequential two-domain review against the 2026-06-06 done baselines; one parked fix applied, discretionary findings surfaced
status: done
target_vision_version: "15.4"
domain: "article-writing"
created: "2026-06-06"
last_updated: "2026-06-06"
goal: "Faithfully reconcile the instruction-set review against existing done baselines, apply the one previously-parked low-risk consistency fix, and surface remaining discretionary findings without over-reach"
---

# Instruction-Set Reconcile Review — `.github/instructions/` (deps run)

> **Resolved invocation:** `--mode=apply --scope=.github/instructions/ --source= --dim=full --start=none --end=none --deps=full --skip= | breadth=full | caller=manual | bundle=multi-domain-gated → split=[3] sequential`
> (`--deps all` normalized to `--deps full`; positional `'.github\instructions'` → `--scope .github/instructions/`.)

## 🎯 Objective

Re-run the full-breadth instruction-set review (17 files, 2 domains) under the Phase 0b
sequential split the user selected. Execution mode = **reconcile** (fresh subagent body audit
+ two `status: done` baselines from 2026-06-06). Goal: avoid both failure modes on record —
the shallow metadata-only collapse AND the missing on-disk plan file.

## 📋 Run footprint

| Field | Value |
|---|---|
| Run id | `20260606-instructions-deps` |
| Domains | prompt-engineering (15) → article-writing (2), sequential |
| Files in scope | 17 |
| research | ran (subagent full-body audit) |
| phase4-coverage | 17/17 bodies read |
| dims-exercised | full (D1-metadata, D2-references, D3-token-budget, D14-craftsmanship/minimization, applyTo precision, overlap) |
| Baselines reconciled | `01-small-instruction-files-changes/02-domain1-...plan.md`, `.../03-domain2-...plan.md` |

## 🔎 Findings

### Applied — low-risk, previously-parked (✅ this run)

| # | File | Finding | Dimension | Action | Status |
|---|---|---|---|---|---|
| 1 | `article-writing.instructions.md` | Legacy bottom `article_metadata` HTML comment (`version: "2.2"`, `last_updated: "2026-03-01"`) contradicts authoritative top YAML (`version: "1.4.0"`, `last_updated: "2026-06-06"`). Instruction files use top-YAML-only versioning. Parked + deferred in Domain-2 baseline. | D6-consistency | Remove the stale bottom block (lines ~466–509). Top YAML already current → no version bump needed. | ✅ done |
| 2 | `pe-common.instructions.md` (was D3) | Optional `goal:` / `rationales:` absent; pe-common is a PE-for-PE instruction file (exemplary bar → both required) and the only one of 15 missing them. User approved discretionary cleanup. | D1-metadata | Add `goal:` + two `rationales:` lines; bump `1.8.0`→`1.8.1` (additive metadata, no rule change). | ✅ done |
| 3 | `05.08-pe-meta-type-checklists.md` (resolves D1) | The `Severity index present` check read as universally Required at the exemplary bar, but a severity index is a *validator-facing projection of the global matrix* — N/A for document-governance instruction files no PE validator runs the matrix against. | D14-craftsmanship | Add a scope note to the check row clarifying applicability; bump `1.0.3`→`1.0.4`. Closes D1 by clarification (no manufactured severity codes). | ✅ done |
| 4 | `pe-agents.instructions.md`, `pe-prompts.instructions.md` (resolves D2) | Non-mechanical process-advice lines ("Start minimal…test…iterate" / "Start with template…test…iterate boundaries") violate instruction-minimization. The "test" half is already a Quality Checklist item in both files, so removal loses no enforceable content. | D14-craftsmanship | Remove the two lines; bump `pe-agents 1.11.0`→`1.11.1`, `pe-prompts 1.6.1`→`1.6.2`. `pe-templates` part of D2 = **false positive** (its Rules are all mechanical `MUST`). | ✅ done |

### Reconciled away — not real (this run)

| # | Claimed finding (subagent) | Verdict |
|---|---|---|
| R1 | `pe-templates` (`.github/**/*template*`) + `pe-skills` (`.github/templates/skill-*.md`) undocumented applyTo overlap | **FALSE POSITIVE** — zero `skill-*.md` files exist in `.github/templates/`; `skill-*.md` has no "template" substring so `*template*` cannot match. No overlap, no action. |

### Discretionary — surfaced, NOT auto-applied (judged clean by baselines; risk of over-reach)

| # | File(s) | Finding | Dimension | Recommendation |
|---|---|---|---|---|
| D1 | `use-case-documents`, `vision-amendment`, `vision-frontmatter` | No explicit severity index. Investigation showed a severity index is a *validator-facing projection of the global `validation-rules` matrix* (entries reference global `[C#]`/`[H#]`/`[M#]` codes); it is N/A for document-governance files, which no PE validator runs the matrix against. | D14 | ✅ **Closed by clarification (Option C).** Scoped the checklist row in `05.08` rather than authoring indexes. D1 is not a defect — the checklist did not distinguish PE-artifact-governance from user-content-governance instruction files. See Applied finding #3. |
| D2 | `pe-agents` ("Start minimal…test…iterate"), `pe-prompts` ("Start with template…iterate") | Borderline behavioral/strategic phrasing inside instruction files (instruction-minimization). The `pe-templates` claim ("Authors SHOULD prefer noun-phrase bullets…") does **not exist** in the file — its Rules are all mechanical `MUST`. | D14 | ✅ **Applied** (see Applied finding #4). Removed the two non-mechanical lines ("test" guidance survives as existing checklist items). `pe-templates` part = false positive, dropped. |
| D3 | `pe-common` | Optional `goal:` / `rationales:` absent (compliant per schema; 14 siblings carry them). | D1 | ✅ **Applied** (see Applied finding #2) after user approval. |
| D4 | `article-writing` (~4,963), `vision-frontmatter` (~3,924), `use-case-documents` (~3,041), `documentation` (~2,369) tok | Over the ≤1,500 instruction ceiling ([C3], `01.06-system-parameters.md`). No clarification escape — the ceiling applies to *all* `.github/instructions/` files ("auto-injected — must stay small"). | D3 | ✅ **Accepted as documented exception** (see § D4 disposition). Splitting is a risky multi-file refactor requiring its own plan — out of scope for a reconcile auto-apply. Two narrow-applyTo schema files (vision/use-case) have contained injection cost; two broad-applyTo files (article-writing/documentation) inject on every `*.md` task — article-writing (~5k) recommended as a future dedicated externalization spike. |

## 📌 Park lot

- None new. D1–D4 are all resolved (applied or accepted-by-design); none are blockers.

## 🔍 D4 disposition — token-budget exceptions

All four files genuinely exceed the [C3] 1,500-token instruction ceiling; there is **no clarification escape** (unlike D1) because `01.06-system-parameters.md` applies the ceiling to *all* `.github/instructions/` files with rationale "auto-injected — must stay small." They are accepted as **documented exceptions** rather than split, because splitting four files is a risky, content-loss-prone multi-file refactor that must be planned on its own (reconcile auto-apply discipline forbids it here).

| File | Tok est | `applyTo` | Injection frequency | Disposition |
|---|---|---|---|---|
| `article-writing` | ~4,963 | `*.md` (+ doc trees) | Every markdown task | **Accept now; recommend a dedicated externalization spike** — highest-value reduction (worst offender × broadest applyTo). |
| `documentation` | ~2,369 | `*.md` (+ doc trees) | Every markdown task | Accept; candidate for the same spike. |
| `vision-frontmatter` | ~3,924 | `06.00-idea/**/*vision*.md` | Only when editing vision docs | Accept — schema-heavy, contained injection cost. |
| `use-case-documents` | ~3,041 | `**/*usecases/**/*.md` | Only when editing use-case docs | Accept — schema-heavy, contained injection cost. |

## 🧪 Regression

- `article-writing.instructions.md`: `get_errors` → 0 markdown errors after block removal. (✅ done)
- `pe-common.instructions.md`: `get_errors` → 0 errors after frontmatter add + version bump. (✅ done)
- `05.08-pe-meta-type-checklists.md`: `get_errors` → 0 errors after scope-note add + version bump. (✅ done)
- `pe-agents.instructions.md`, `pe-prompts.instructions.md`: `get_errors` → 0 errors after D2 line removal + version bump. (✅ done)

## Exit criteria

- [x] All 17 bodies read; Phase-4 coverage 17/17.
- [x] Subagent false-positive (R1) verified and dropped.
- [x] Parked legacy-metadata fix (#1) applied + validated.
- [x] Discretionary items surfaced, not silently applied.
- [x] On-disk plan file materialized (this file) — closes the recurring plan-file gap.
- [x] D1 resolved by clarification (Option C — checklist scope note in `05.08`).
- [x] D2 applied (2 files; `pe-templates` part = false positive).
- [x] D4 accepted as documented exception (split deferred to a dedicated plan).
