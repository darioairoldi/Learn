# Plan 04 — `-usecase.md` suffix adoption + folder overview sort-before

> **Status:** ✅ done — 2026-06-01
> **Parent issue:** 20260601.02-dim-readable-ids
> **Supersedes (partially):** the Naming Decisions section of `02-align-dimids-usecases-pemeta-plan.md` Step 1 (which rejected the `-usecase.md` suffix)
> **Trigger:** user request 2026-06-01 — two new requirements not weighed in the v1.1.0 decision:
>
> 1. Adopting `-usecase.md` enables **instruction-file `applyTo` targeting** specifically for use-case bodies (vs. folder overviews), which the previous decision did not consider.
> 2. Folder overview files must **sort before** the use-case files in folder listings AND must be **governable by their own instruction rules** (separate from use-case rules).

## 🎯 Goal

Adopt `-usecase.md` as the canonical use-case-document suffix and rename folder `README.md` → `00-overview.md` so the overview sorts first (case-insensitive and case-sensitive) and can be targeted by a distinct `applyTo` glob.

## 📋 Scope

- 35 use-case files across 5 folders under `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/`:
  - `01-freshness/` — 4 files
  - `02-quality-gates/` — 7 files
  - `03-consumer-correctness/` — 4 files
  - `04-efficiency/` — 8 files
  - `05-reliability/` — 12 files
- 6 README files (5 folder READMEs + the top-level set README) renamed to `00-overview.md`
- `usecase-index.json` — bump v2.3.0 → v2.4.0, append `-usecase` to every `path`
- `.github/instructions/use-case-documents.instructions.md` — bump v1.1.0 → v1.2.0, reverse Naming Decisions, change filename rule, add overview-file rule, add applyTo split note
- `src/docs/90. Issues/202606/20260601.02-dim-readable-ids/03-coverage-audit.md` — update use-case path references
- External references in other plans/contexts that link to use-case files — update in place

## 🚫 Out of scope

- Renaming `usecase-index.json` itself (canonical machine-readable index name retained)
- Touching the dimension catalog (already fixed in v1.5.0 sibling change)
- Re-doing dimensions-covered matrices (content unchanged — only link targets change)

## 🛠️ Steps

### Step 1 — Update instruction file `use-case-documents.instructions.md` to v1.2.0 (✅ done)

- Reverse the Naming Decisions item that forbade `-usecase.md`; replace with adopting it and record the new rationale (instruction-file applyTo targeting)
- Change canonical filename rule from `p<priority>-<order>-<slug>.md` to `p<priority>-<order>-<slug>-usecase.md`
- Update Scope of Application regex pattern accordingly
- Add Folder Overview Rules: filename MUST be `00-overview.md` (sorts first; governable by distinct applyTo glob); previous `README.md` is deprecated for this folder set
- Update Quality Checklist line items
- Bump version and add changelog entry

### Step 2 — Rename 35 use-case files (✅ done)

- `pN-NN-<slug>.md` → `pN-NN-<slug>-usecase.md` for every use-case file in all 5 folders
- Use `Move-Item` so git tracks as renames

### Step 3 — Rename 6 overview files (✅ done)

- 5 folder READMEs → `00-overview.md`
- Top-level set README → `00-overview.md`

### Step 4 — Update all link/path references (✅ done)

Regex `pN-NN-<slug>.md` → `pN-NN-<slug>-usecase.md` (with negative lookbehind to avoid double-suffixing) applied to:

- All 35 renamed use-case bodies (cross-links in `## 🔗 Related use cases` and elsewhere)
- All 6 renamed overview files (dimensions-covered matrix, run-order list, index links)
- `usecase-index.json` — all `path` fields
- `src/docs/90. Issues/202606/20260601.02-dim-readable-ids/03-coverage-audit.md`
- `src/docs/90. Issues/202605/20260525.03-staleness-review/` family — 02-usecases-update-plan, 01-vision-usecase-plan-rules-plan
- `src/docs/90. Issues/202605/20260525.03-dismiss-redundant-aliases/` — analysis.md, 01.01-retire-robustness-alias-plan.md
- `src/docs/90. Issues/202605/20260521.03-update-pe-artifacts-for-pemeta/` — 01-overview.md, 02-issue-indept-analysis.md
- `src/docs/90. Issues/202605/20260524.04-dim-vs-healthcheck/01.02-use-cases-update-plan.md`
- `.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md` (line 229)
- `.github/instructions/use-case-documents.instructions.md` (Reference examples)

Regex `vision-pe-meta-usecases/<group>/README.md` → `vision-pe-meta-usecases/<group>/00-overview.md` applied to any cross-reference that names a folder README. Top-level overview ref same treatment.

### Step 5 — Bump index version (✅ done)

`usecase-index.json` v2.3.0 → v2.4.0 with comment in the parent plan or repo memory noting the suffix transition.

### Step 6 — Mark plan 02 amendment (✅ done)

Add a short reversal note in `02-align-dimids-usecases-pemeta-plan.md` Step 1 outcome pointing to this plan (so the historical decision trail is intact).

### Step 7 — Verify (✅ done)

- `get_errors` on all touched markdown/JSON files
- Spot-check by reading 2-3 renamed files and one overview
- Repo-wide grep: `pN-NN-<slug>\.md(?!-usecase)` should yield zero matches inside touched scope; any matches outside touched scope are unrelated false positives to triage

## 🧷 Park lot

- The `applyTo` glob in `use-case-documents.instructions.md` currently catches both use cases and overview; once both rules diverge, consider splitting into two instruction files: one for `**/*-usecase.md`, one for `**/*usecases/**/00-overview.md`. Out of scope for this plan; record as next-step.
- The 99.00-temp/ directory may contain stale references — exempt unless explicitly listed in Step 4.

## ✅ Exit criteria

- All 35 use-case files end in `-usecase.md` (✅ done)
- All 6 folder/set overview files are named `00-overview.md` (✅ done)
- `usecase-index.json` at v2.4.0 with all paths suffixed (✅ done)
- Instruction file at v1.2.0 with reversed Naming Decisions (✅ done)
- Repo grep for bare `p[0-9]-[0-9]{2}-<slug>\.md` inside `vision-pe-meta-usecases/` yields zero matches (✅ done)
- `get_errors` clean on all touched files (✅ done — see Step 7 below)
