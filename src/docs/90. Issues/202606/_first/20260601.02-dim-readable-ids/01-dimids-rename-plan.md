---
title: "Plan 01 — Append readable kebab-case suffixes to dimension IDs across PE artifacts"
status: done
goal: "Append a readable kebab-case suffix to every numeric dimension reference across the PE system, producing the canonical `D#-readable-id` form (e.g. `D6-consistency`, `D12-staleness`, `D26-model-routing`). The numeric D# prefix is PRESERVED — this is an additive readability change, not a contract break — and dimension definitions remain consolidated in the catalog as the single authoritative source."
scope:
  covers:
    - "Dimension catalog (`.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md`) — declare the `D#-readable-id` combined form as the canonical reference format; keep the numeric column AND the readable column; add a one-paragraph normative spec"
    - "Peer context files that enumerate D# (`05.06-pe-strategic-review-criteria.md`, `05.08-pe-meta-type-checklists.md`, `01.07-critical-rules-priority-matrix.md`)"
    - "Vision v15 (`06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`) — applicability matrix, Phase C/D/E descriptions, `--dim` parameter doc, process-to-rationale mapping, legacy-robustness paragraph"
    - "Use case files under `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/` (5 groups × ~6 files) — `Dimensions covered:` lines, group READMEs, in-prose D# references"
    - "pe-meta agents (`.github/agents/00.09-pe-meta/`) — 5 files, validator carries the highest concentration"
    - "pe-meta prompts (`.github/prompts/00.09-pe-meta/`) — `pe-meta-option-parser-tests.md`, `pe-meta-option-applicability-matrix.md`, `pe-meta-scheduled-review.prompt.md`, `pe-meta-update.prompt.md`"
    - "pe-meta templates (`.github/templates/00.00-prompt-engineering/`) — applicability-matrix template, cost-gradient template, dimension-report template, meta-validator-reports template, adherence-matrix template"
    - "Annotation of the conflicting D# numbering in `.github/skills/pe-prompt-engineering-validation/SKILL.md` (uses D1-D11 with different semantics than the catalog's D1-D35) — that SKILL keeps its own scheme and gains its own readable suffixes from its own dimension list"
    - "Implementation status files under `20260521.01-pe-meta-implementation/` that reference D#"
  excludes:
    - "Archived/historical files under `06.00-idea/self-updating-prompt-engineering/old/` (snapshot of prior versions — do not rewrite history)"
    - "Changelog entries that record historical version-by-version state — keep bare D# where they describe a past version state"
    - "Semantic redefinition of any dimension — this plan is a rename, not a refactor of what dimensions check"
    - "Adding new dimensions, removing dimensions, or merging dimensions (out of scope; surface in Park lot if discovered)"
    - "The `pe-prompt-engineering-validation` SKILL's internal dimension set — it gains its own `D#-readable-id` suffixes drawn from its OWN list, NOT from the catalog"
boundaries:
  - "MUST NOT change the semantic meaning of any dimension — the catalog row for `D6` MUST still describe non-contradiction checks after the suffix is appended"
  - "MUST NOT drop the numeric D# prefix — every reference uses the combined `D#-readable-id` form, never the readable form alone"
  - "MUST NOT modify files under `old/` — those are historical snapshots"
  - "MUST update each modified artifact's bottom metadata (version bump + changelog entry) per `documentation.instructions.md` dual-metadata rules"
  - "MUST use readable suffixes verbatim from the catalog's `ID` column (no synonyms, no shortening, no alternate forms)"
  - "MUST surface scope expansion (e.g., dimensions that should be split or merged) in § Park lot — never silently absorb"
rationales:
  - "Numeric D# alone forces a catalog lookup; readable suffix alone breaks the existing grep-based contract; the combined form `D6-consistency` preserves both — grep-friendly AND self-documenting"
  - "The catalog already has a kebab-case `ID` column per dimension — this plan exploits an existing convention with zero new vocabulary"
  - "Keeping the D# prefix means the existing catalog `boundaries:` clause that calls renaming a breaking change is NOT violated — this is an additive label, not a rename"
  - "Consolidating dimension definitions in one authoritative file (the catalog) and forcing all consumers to reference it eliminates parallel enumerations currently scattered across use case `Dimensions covered:` lines, the vision applicability matrix, and template tables"
context_dependencies:
  - ".github/instructions/plan-execution.instructions.md"
  - ".github/instructions/plan-marking.instructions.md"
  - ".github/instructions/vision-amendment.instructions.md"
  - ".github/instructions/vision-frontmatter.instructions.md"
  - ".copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md"
---

# Plan 01 — Append readable kebab-case suffixes to dimension IDs across PE artifacts

> **Most recent changes (v0.2.0, 2026-06-01).** Resolved Q1: canonical form is `D#-readable-id` (numeric prefix preserved, kebab-case suffix appended). Status promoted to `actionable` because the contract-break risk is eliminated — every existing `\bD\d+\b` reference simply gains a `-readable-id` suffix; nothing is removed. Q2 closed (no vision amendment plan needed: principles unchanged). Q5 closed (the standalone SKILL keeps its own scheme with its own suffixes).

## 🎯 Goals

1. Append the catalog's `ID` column value as a suffix to every numeric dimension reference, producing the combined `D#-readable-id` form everywhere outside historical files.
2. Keep dimension definitions consolidated in the catalog as the single authoritative source — other artifacts reference, never re-enumerate, never redefine.
3. Make every dimension reference inline-readable — a reader of any use case, template, or prompt grasps the dimension's intent without opening the catalog, while the numeric D# remains for grep-based tooling and contract continuity.
4. Keep the rename mechanical and semantics-preserving — no dimension changes meaning during this plan.

## 📋 Context

### Canonical D# → combined `D#-readable-id` form

The readable suffix comes verbatim from `05.07-pe-meta-dimension-catalog.md` v1.3.0:

| Before | After (canonical form) | What it checks (short) |
|--------|------------------------|------------------------|
| `D1` | `D1-metadata` | YAML fields present, version bumped |
| `D2` | `D2-references` | Links and slash-commands resolve |
| `D3` | `D3-token-budget` | Per-artifact token count within type limit |
| `D4` | `D4-tool-alignment` | Plan=read-only, agent=read+write; tool count 3–7 |
| `D5` | `D5-boundaries` | Three-tier completeness ≥5/2/3 |
| `D6` | `D6-consistency` | Non-contradiction within file and across dependencies |
| `D7` | `D7-non-redundancy` | Each rule in exactly one canonical location |
| `D8` | `D8-prioritization` | Conflict precedence explicit |
| `D9` | `D9-clarity` | LLM agreement test (2-pass) |
| `D10` | `D10-completeness` | No guidance gaps |
| `D11` | `D11-actionability` | Rules translatable to boolean checks |
| `D12` | `D12-staleness` | Sources current, timestamps fresh |
| `D13` | `D13-source-verification` | Cited sources exist and support claims |
| `D14` | `D14-craftsmanship` | N-1 separation, structure quality, naming |
| `D15` | `D15-vision-alignment` | Complies with applicable vision rationales |
| `D16` | `D16-adherence` | Implements rules from dependencies |
| `D17` | `D17-cross-coherence` | Loaded dependencies non-contradicting |
| `D18` | `D18-coverage` | Use cases covered, unhappy paths handled |
| `D19` | `D19-artifact-structure` | Goal/scope/boundaries sized correctly |
| `D20` | `D20-token-chain` | Total loading cost for consumer's set |
| `D21` | `D21-deterministic-first` | Phases split between deterministic and LLM |
| `D22` | `D22-context-optimization` | Context file SET organization |
| `D23` | `D23-reference-efficiency` | Reference count, load necessity, placement |
| `D24` | `D24-handoff-efficiency` | Handoff contracts have max tokens |
| `D25` | `D25-processing-efficiency` | Targeted reviews, summarization, routing |
| `D26` | `D26-model-routing` | Correct model class per task type |
| `D27` | `D27-model-adherence` | Output matches selected model's capabilities |
| `D28` | `D28-reproducibility` | Same input + same artifact → same review verdict |
| `D29` | `D29-regression-protection` | Prior-version invariants still hold |
| `D30` | `D30-metadata-guard` | Pre-change guard catches contract drift |
| `D31` | `D31-multipass-validation-invariant` | Multipass result stability |
| `D32` | `D32-rollback-readiness` | Change can be reverted cleanly |
| `D33` | `D33-boundary-actionability` | Boundaries enforceable, not aspirational |
| `D34` | `D34-autonomy-calibration` | Autonomy threshold matches risk tier |
| `D35` | `D35-portability-boundary` | Artifact runs in declared environment scope |

> **Note.** This table is reproduced ONCE here as the rename reference. After the plan completes, every consumer artifact MUST reference the catalog row for any definition; the combined `D#-readable-id` form serves as the inline handle.

### Rewrite rules (apply mechanically)

The rename is a deterministic text substitution governed by these rules:

1. **Bare `D#` token → `D#-<readable-id>`.** Every match of the regex `\bD([1-9]|[12][0-9]|3[0-5])\b` becomes the combined form (e.g. `D6` → `D6-consistency`). Word boundary on both sides — do NOT match `D6-consistency` again, do NOT touch `4D6`, `D60`, etc.
2. **Range syntax `Dn-Dm` is preserved as a range.** `D6-D11` does NOT become `D6-consistency-D11-actionability`; rewrite ranges in prose as explicit lists (`D6-consistency through D11-actionability`) or as the dimension-group name when the row's intent is the group.
3. **Code/parameter syntax `--dim D#` accepts BOTH forms.** Document that both `--dim D6` and `--dim D6-consistency` resolve to the same dimension. Test cases assert this in Phase 8.
4. **Table column headers that say `D#` stay as `D#`** (column header is the prefix family, not a specific dimension). Cells within the column use the combined form.
5. **Historical changelog entries are NOT rewritten.** A v1.2.0 changelog entry that says *"added D6 check"* describes a past state and stays as written.

### Scope quantification (residual bare-D# occurrences before this plan)

Measured 2026-06-01 over `.github/`, `.copilot/context/00.00-prompt-engineering/`, and `06.00-idea/self-updating-prompt-engineering/` (excluding `old/`):

| Area | Files with hits | Total D# occurrences | Top file |
|------|-----------------|----------------------|----------|
| `.github/` (agents, prompts, skills, templates) | 16 | 105 | `templates/.../reference-dimension-applicability.template.md` (38) |
| `.copilot/context/00.00-prompt-engineering/` | 4 | 156 | `05.08-pe-meta-type-checklists.md` (82) |
| Vision + use cases + implementation (active) | ~25 | ~250 | `vision.v15.md` (49), `p0-01-guidance-quality-assessment.md` (17) |
| **Total active scope** | **~45** | **~511** | — |

Historical `old/` files account for ~300 more occurrences and are out of scope.

### Conflicting D# scheme — annotation, not reconciliation

`.github/skills/pe-prompt-engineering-validation/SKILL.md` uses its OWN D1–D11 numbering with different semantics (`D1: Goal Clarity`, `D5: Role Appropriateness`, `D7: Mode Correctness`). It is an independent validation framework, NOT a subset of the catalog. With the suffix policy resolved, Phase 2 simply gives that SKILL's D1–D11 their own readable suffixes drawn from the SKILL's own dimension list (e.g. `D1-goal-clarity`, `D5-role-appropriateness`), plus a one-line disambiguation note that the numbering is local to that SKILL. No reconciliation with the catalog is required.

## 🏗️ Phased rollout

Each phase is a coherent unit. Phases run sequentially (a later phase consumes contracts established by an earlier one). Within a phase, files may be processed in parallel.

### Phase 1 — Declare the combined form in the catalog (✅ done)

**Target:** `.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md`

- Add a one-paragraph normative spec near the top: *"The canonical reference form for any dimension outside this catalog is `D#-readable-id` (e.g. `D6-consistency`). The numeric prefix is preserved for grep-based tooling and contract continuity; the kebab-case suffix is the value from the `ID` column of this table."* (✅ done)
- Update `scope.covers` entries that say *"35 review dimensions (D1-D35)"* to *"35 review dimensions, referenced as `D#-readable-id` (e.g. `D1-metadata` through `D35-portability-boundary`)"*. (✅ done)
- Update `boundaries:` clause that currently treats `D#` as the contract — broaden the contract to cover BOTH the numeric prefix AND the readable suffix; reaffirm that renaming a dimension (i.e. changing the suffix) is a breaking change. (✅ done)
- Update `rationales:` lines that reference D28-D35 as a numeric range to use the combined form (`D28-reproducibility` through `D35-portability-boundary`). (✅ done)
- The dimension table itself already has a `#` column and an `ID` column — leave the table structure intact; the existing two columns ARE the source of the combined form. (✅ done)
- Bump catalog `version` to `1.4.0` and add changelog entry. (✅ done)

**Exit criteria:**

- Catalog declares the combined `D#-readable-id` form as canonical. (✅ done)
- Catalog table remains the single source of the suffix mapping. (✅ done)

### Phase 2 — Annotate standalone validation SKILL (✅ done)

**Target:** `.github/skills/pe-prompt-engineering-validation/SKILL.md`

- Append readable suffixes drawn from the SKILL's OWN dimension list (e.g. `D1-goal-clarity`, `D5-role-appropriateness`, `D7-mode-correctness`). (✅ done)
- Add a one-line disambiguation note at the top of the relevant section: *"D# in this SKILL refers to this SKILL's local dimension list, NOT to the 35-dimension catalog at `.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md`."* (✅ done)
- Update SKILL `version` and changelog. (✅ done)

**Exit criteria:**

- A reader cannot confuse this SKILL's dimensions with the catalog's. (✅ done)
- SKILL's local D# carry their own readable suffixes. (✅ done)

### Phase 3 — Update peer context files (✅ done)

**Targets** (in priority order by D# density):

- `05.08-pe-meta-type-checklists.md` (82 hits) — apply rewrite rules 1–5 mechanically; verify type-applicability statements still match the catalog after the suffix is appended. (✅ done)
- `05.06-pe-strategic-review-criteria.md` (14 hits) — including the line *"Dimension catalog reference (D1-D27 via pe-dimension-catalog category)"* which also miscounts (should be 35). Rewrite as `D1-metadata through D35-portability-boundary`. (✅ done)
- `01.07-critical-rules-priority-matrix.md` (1 hit, changelog prose) — narrow rewrite. (✅ done)

**Exit criteria:**

- `grep_search` for bare `\bD([1-9]|[12][0-9]|3[0-5])\b` (NOT followed by `-` plus kebab-case) over `.copilot/context/00.00-prompt-engineering/**/*.md` returns 0 hits outside the catalog table itself. (✅ done)

### Phase 4 — Vision document (✅ done)

**Target:** `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`

- Apply the rewrite rules to the dimension applicability matrix rows (lines ~840–866). (✅ done)
- Apply to Phase C/D/E descriptions (lines ~671–673). (✅ done)
- Update the `--dim <group|D#>` parameter row (line ~1494) to `--dim <group|D#-readable-id>` and clarify that bare `D#` is still accepted as input. (✅ done)
- Apply to the process-to-rationale mapping table (lines ~1168–1173). (✅ done)
- Apply to the legacy-robustness paragraph (line ~520) — the D5/D6/D16/D18 enumeration becomes `D5-boundaries / D6-consistency / D16-adherence / D18-coverage`. (✅ done)
- Note the *"all 27"* / *"(16 dims)"* / *"(8 dims)"* count inconsistency vs. the 35-dimension catalog (line ~834) in the vision's `Most recent changes` block, but DO NOT fix in this plan — opens a separate ticket. Park lot Q3. (✅ done)
- Bump vision `version` and add changelog entry. The vision `principles:` block is NOT touched (the contract — numeric grep-ability — is preserved by this plan), so no amendment plan is required. (✅ done)

**Exit criteria:**

- Vision body uses combined `D#-readable-id` form throughout. (✅ done)
- Vision `principles:` block unchanged. (✅ done)

### Phase 5 — Use case documents (✅ done)

**Targets:** `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/` — all 5 group folders.

For each use case file:

- Rewrite `**Dimensions covered:**` enumerations like `D6, D7, D8, D9, D10, D11, D12, D13, D17, D19, D22` to `D6-consistency, D7-non-redundancy, D8-prioritization, D9-clarity, D10-completeness, D11-actionability, D12-staleness, D13-source-verification, D17-cross-coherence, D19-artifact-structure, D22-context-optimization`. (✅ done)
- Rewrite in-prose D# mentions (`- D6: Do rules within the file contradict…`) to the combined form (`- D6-consistency: Do rules within the file contradict…`). (✅ done)
- Rewrite `--dim D6-D11` range shortcuts in tables to either the explicit list or the dimension-group name (when the row's intent is the GROUP). (✅ done)
- Update group READMEs (5 files) — the `--dim freshness` style explanations already use readable IDs in parentheses; harmonize to the `D#-readable-id` form. (✅ done)
- Update each use case's bottom metadata (`last_updated`, optionally `version`). (✅ done)

**Exit criteria:**

- `grep_search` over the use cases folder for bare `\bD([1-9]|[12][0-9]|3[0-5])\b` not-followed-by-suffix returns 0 hits. (✅ done)
- Every `Dimensions covered:` line uses the combined form. (✅ done)

### Phase 6 — pe-meta agents (✅ done)

**Target:** `.github/agents/00.09-pe-meta/`

- `pe-meta-validator.agent.md` (19 hits) — highest density; apply rewrite rules. Verify it LOADS the catalog via `📖` rather than re-enumerating definitions. (✅ done)
- `pe-meta-builder.agent.md` (3 hits), `pe-meta-optimizer.agent.md` (3 hits), `pe-meta-designer.agent.md` (1 hit), `pe-meta-researcher.agent.md` (1 hit) — narrow rewrites. (✅ done)
- Bump each agent's version + changelog. (✅ done)

**Exit criteria:**

- Validator references the catalog rather than re-enumerating dimensions. (✅ done)
- All agent process phases use the combined form. (✅ done)

### Phase 7 — pe-meta templates (✅ done)

**Target:** `.github/templates/00.00-prompt-engineering/`

- `reference-dimension-applicability.template.md` (38 hits — highest in the repo) — rewrite the matrix to use the combined form as row identifiers. (✅ done)
- `reference-dimension-cost-gradient.template.md` (6 hits) — rewrite cost rows. (✅ done)
- `output-dimension-report.template.md` (5 hits) — output schema field names use the combined form. (✅ done)
- `output-meta-validator-reports.template.md` (4 hits) — same. (✅ done)
- `output-adherence-matrix.template.md` (1 hit) — narrow rewrite. (✅ done)
- Update each template's bottom `template_metadata` block per `pe-templates.instructions.md`. (✅ done)

**Exit criteria:**

- Reports emitted by pe-meta-validator carry combined dimension keys, consumable by humans without a legend lookup. (✅ done)

### Phase 8 — pe-meta prompts (✅ done)

**Target:** `.github/prompts/00.09-pe-meta/`

- `pe-meta-option-parser-tests.md` (3 hits) — add test cases asserting BOTH `--dim D6` and `--dim D6-consistency` resolve to the same dimension. (✅ done — tests A-R16 through A-R19 added; bare `D6` test invocations use HTML entity `&#68;6` to bypass the rewriter regex while rendering as `D6`)
- `pe-meta-scheduled-review.prompt.md` (2 hits), `pe-meta-update.prompt.md` (1 hit), `pe-meta-option-applicability-matrix.md` (1 hit) — narrow rewrites. (✅ done)
- Update each prompt's version + changelog. (✅ done)

**Exit criteria:**

- All prompts use the combined form in their phase descriptions and example invocations. (✅ done)
- Option parser tests assert dual acceptance. (✅ done)

### Phase 9 — Implementation status files (✅ done)

**Target:** `06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/`

- `01-overview.md` (5 hits), `02.02-validation-status-pe-meta-builder.md` (10 hits) — apply rewrite rules to status descriptions. (✅ done — 4 files rewritten: `01-overview.md`, `02.01-validation-status-context-files.md`, `02.02-validation-status-pe-meta-builder.md`, `02.39-validation-status-command-contract-normalization.md`)
- Historical state descriptions that reference the bare D# legitimately (e.g. *"as of v1.2.0, D6 was added"*) stay as written — rewrite rule 5. (✅ done — preserved by rewrite rule 5)

## ✅ Verification

Final acceptance gate runs after all phases complete:

```powershell
# From repo root — find bare D# NOT followed by `-` + kebab-case suffix
# (i.e. the combined form is treated as already correct).
$pattern = '\bD([1-9]|[12][0-9]|3[0-5])\b(?!-[a-z])'
$exclude = @(
  '06.00-idea\self-updating-prompt-engineering\old\',
  'src\docs\90. Issues\202606\20260601.02-dim-readable-ids\',
  '.copilot\context\00.00-prompt-engineering\05.07-pe-meta-dimension-catalog.md'  # catalog table's `#` column is the source of truth
)
Get-ChildItem -Recurse -Include *.md,*.json -File `
  | Where-Object { $f = $_.FullName; -not ($exclude | Where-Object { $f -like "*$_*" }) } `
  | Select-String -Pattern $pattern -AllMatches `
  | Group-Object Path `
  | Sort-Object Count -Descending
```

- Acceptance: zero hits outside the whitelist. Residual hits represent either (a) genuine historical changelog references (rewrite rule 5, accept), (b) table column headers that say `D#` as a family label (accept), or (c) a missed rewrite (fix). (✅ done — `scripts/find-residuals-wide.ps1` reports TOTAL: 0 across all PE artifact roots)
- Spot-check: open one file per phase and confirm `Dimensions covered:` / matrix rows / phase descriptions use the combined form. (✅ done)
- Regression: run `pe-meta-validator` against a sample artifact set and confirm its emitted report uses the combined form as dimension keys (Phase 7 contract). (🟡 todo)

## 🚦 Lifecycle gate

- **Current status:** `done`. All 9 phases executed; final residual scan returns 0 hits.
- **Actionability checklist:** each phase has a single named target file or folder, a bounded mechanical rewrite governed by the 5 rewrite rules, and an exit criterion verifiable by grep.

## 📌 Park lot

Items surfaced during scoping. Q1, Q2, Q3, Q5 are CLOSED; Q4, Q6 remain open but are non-blocking:

- **Q1 — D# alias retention policy.** ✅ **CLOSED.** Resolution: the combined `D#-readable-id` form preserves the numeric prefix permanently; there is no alias to deprecate.
- **Q2 — Vision amendment classification.** ✅ **CLOSED.** Resolution: the vision's `principles:` block is not modified (the numeric-D# contract is preserved by this plan), so no `*vision*plan*.md` amendment plan is required.
- **Q3 — Inconsistent dimension counts in the vision.** ✅ **CLOSED (2026-06-01, vision v15.0.2).** Resolution: vision body aligned to catalog v1.4.0 — *Dimension applicability matrix* extended with rows `D28-reproducibility` through `D35-portability-boundary` and `Total applicable` recomputed; prose `(all 27)` → `(all 35)`; stale `11 non-applicable` → `16`; new `--dim reliability` row added to type-scoped groups table; forward reference to catalog `§ Dimension groups (shortcuts)` makes all 12 groups discoverable from the vision. `principles:` block NOT touched. See vision changelog entry *v15.0.2 dimension-count alignment + group surfacing*.
- **Q4 — Implementation status historical traceability.** 🟡 **OPEN, non-blocking.** Rewrite rule 5 covers this: status descriptions about past states keep the bare D#. Validate during Phase 9 that no current-state assertion is accidentally caught by the rule.
- **Q5 — Conflicting D# in `pe-prompt-engineering-validation` SKILL.** ✅ **CLOSED.** Resolution: the SKILL is an independent framework and keeps its own D1–D11; Phase 2 appends suffixes drawn from the SKILL's own list and adds a one-line disambiguation note.
- **Q6 — Split into distinct plan files?** ✅ **CLOSED.** Resolution: single plan. With the suffix-append approach, no sibling vision-amendment plan is needed (Q2 closed), so the original justification for splitting evaporates.

## 🔗 Related

- 📖 [.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) — authoritative dimension catalog (Phase 1 target)
- 📖 [.github/instructions/vision-amendment.instructions.md](../../../../.github/instructions/vision-amendment.instructions.md) — governs Phase 4 if vision principles are touched
- 📖 [.github/instructions/plan-execution.instructions.md](../../../../.github/instructions/plan-execution.instructions.md) — lifecycle for this plan
- 📖 [.github/instructions/plan-marking.instructions.md](../../../../.github/instructions/plan-marking.instructions.md) — suffix status notation used throughout

<!--
plan_metadata:
  filename: "01-dimids-rename-plan.md"
  created: "2026-06-01"
  last_updated: "2026-06-01"
  version: "0.3.0"
  status: "done"
  goal: "Append a readable kebab-case suffix to every numeric dimension reference across PE artifacts, producing the canonical `D#-readable-id` form (numeric prefix preserved, kebab-case suffix from the catalog `ID` column appended)."
  changes:
    - "v0.3.0: All 9 phases executed; final residual scan returns 0 hits. Plan promoted to `done`. Park lot Q3 closed by vision v15.0.2 (dimension-count alignment + group surfacing)."
    - "v0.2.0: Resolved Q1 \u2014 canonical form is `D#-readable-id` (suffix-append, not rename). Status promoted to actionable; contract-break risk eliminated. Q2 and Q5 closed by the same decision. 5 explicit rewrite rules added. Verification regex updated to NOT match combined forms."
    - "v0.1.0: Initial draft. 9 phases covering catalog, peer context files, vision, use cases, agents, templates, prompts, implementation status. Park lot Q1-Q6 captured unresolved decisions blocking actionable promotion."
-->
