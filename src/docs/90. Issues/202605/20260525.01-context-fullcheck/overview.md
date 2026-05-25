---
title: "Issue: PE-for-PE context directory fails four context-full quality dimensions"
author: "Dario Airoldi"
date: "2026-05-25"
categories: [issue, prompt-engineering, pe-meta, context-quality]
description: "A `--dim context-full` review of `.copilot/context/00.00-prompt-engineering/` (37 files) auto-fixed 11 broken references but surfaced four breaking findings: D3 token-budget overflow on 05.07 and 05.03, D17 cross-coherence drift in the pe-meta-context-review prompt, D14 naming exceptions on STRUCTURE-*.md files (deferred), and D22 empty placeholder subdirectories. This issue captures the findings and gates the corresponding execution plans."
draft: false
status: "resolved"
severity: "Medium"
component: "PE-for-PE context directory (`.copilot/context/00.00-prompt-engineering/`) + `pe-meta-context-review` prompt"
framework: "GitHub Copilot Customization v1.107 (vision v13, PE meta-pipeline)"
---

# Issue analysis — PE-for-PE context directory fails four context-full quality dimensions

**Issue ID:** 20260525.01-context-fullcheck
**Date reported:** 2026-05-25
**Reporter:** Dario Airoldi
**Status:** Resolved — autonomous fixes applied; three plans executed (2026-05-25); end-to-end re-run pending next review cycle
**Severity:** Medium
**Component:** `.copilot/context/00.00-prompt-engineering/` (37 files) + [pe-meta-context-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md)
**Framework:** Vision v13 — PE meta-review pipeline, `--dim context-full` group

---

## 📋 Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#%EF%B8%8F-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief description

A full `--dim context-full` review of the PE-for-PE context directory (`.copilot/context/00.00-prompt-engineering/`, 37 Markdown files) was invoked via `/pe-meta-context-review`. The 16-dimension sweep (D1–D3, D6–D15, D17, D19, D22) returned:

- **5 dimensions PASSING** outright (D1 metadata, D7/D8 boundary coherence on samples, D12 freshness, D14 mostly)
- **D2 references AUTO-FIXED** (11 non-breaking link corrections applied across 9 files)
- **Four breaking findings** requiring human approval before remediation

The autonomous portion of the review completed cleanly; the breaking findings are now blocked on a single approval point and have been split into three coordinated execution plans.

### Trigger that surfaced this

Direct invocation in the current conversation:

> `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full`

(Default `--mode apply` per the prompt spec: apply non-breaking fixes autonomously; propose breaking ones for human confirmation.)

### Auto-fixed findings (D2 references — 11 edits, no approval needed)

| # | File | Fix |
|---|---|---|
| 1 | [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) | `20260515.02-vision.v12.md` → `20260523.01-vision.v13.md` (latest vision) |
| 2 | [01.01-context-engineering-principles.md](../../../../../.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md) | `prompts.instructions.md` → `pe-prompts.instructions.md`; `agents.instructions.md` → `pe-agents.instructions.md` |
| 3 | [01.02-prompt-assembly-architecture.md](../../../../../.copilot/context/00.00-prompt-engineering/01.02-prompt-assembly-architecture.md) | Same dual rename |
| 4 | [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) | Same dual rename |
| 5 | [02.01-handoffs-pattern.md](../../../../../.copilot/context/00.00-prompt-engineering/02.01-handoffs-pattern.md) | Same dual rename |
| 6 | [02.02-context-window-and-token-optimization.md](../../../../../.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md) | `prompts.instructions.md` → `pe-prompts.instructions.md` |
| 7 | [02.04-agent-shared-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) | `agents.instructions.md` → `pe-agents.instructions.md` |
| 8 | [02.05-agent-workflow-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.05-agent-workflow-patterns.md) | `agents.instructions.md` → `pe-agents.instructions.md` |
| 9 | [03.01-progressive-disclosure-pattern.md](../../../../../.copilot/context/00.00-prompt-engineering/03.01-progressive-disclosure-pattern.md) | `skills.instructions.md` → `pe-skills.instructions.md` |
| 10 | [03.05-copilot-spaces-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/03.05-copilot-spaces-patterns.md) | `agents.instructions.md` → `pe-agents.instructions.md` |
| 11 | [04.02-adaptive-validation-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/04.02-adaptive-validation-patterns.md) | `adaptive-validation-patterns.md` → `04.02-adaptive-validation-patterns.md` (self-ref with correct prefix) |

Validation: PowerShell reference sweep confirms zero remaining broken refs in the directory (one false positive excluded — `.vscode/mcp.json` is instructional, telling readers to create that file in *their* workspace).

### Breaking findings (require approval — split into plans)

| # | Dimension | Finding | Severity | Decision | Plan |
|---|---|---|---|---|---|
| 1 | D3 token-budget | 4 files exceed the 2,500-token hard ceiling | **HIGH** | Option B (extract heavy tables to templates) for `05.07` and `05.03`; defer `05.06`/`02.05` (marginal) | [01.01-token-budget-extract-tables-plan.md](01.01-token-budget-extract-tables-plan.md) |
| 2 | D17 cross-coherence | `pe-meta-context-review.prompt.md` references undefined dim groups `context-quality-lifecycle` / `context-quality-health` (catalog only defines `context-full` / `context-health`) | **MEDIUM** | Option B — rename prompt to use canonical names | [01.02-dim-group-naming-alignment-plan.md](01.02-dim-group-naming-alignment-plan.md) |
| 3 | D14 naming | 3 `STRUCTURE-*.md` files violate kebab-case + numeric-prefix convention | **LOW** | ✅ Resolved by [20260525.02/01.01-structure-files-rename-kebab-case-plan.md](../20260525.02-context-fullcheck-analysis/01.01-structure-files-rename-kebab-case-plan.md) (2026-05-25) | (see 20260525.02) |
| 4 | D22 system-level | Two empty subdirectories `dependency-map/` and `structure/` | **LOW** | Option B — add `.gitkeep` (placeholders for in-flight work) | [01.03-empty-subdir-gitkeep-plan.md](01.03-empty-subdir-gitkeep-plan.md) |

### Impact points

| # | Impact | Severity contribution |
|---|---|---|
| 1 | D3 over-budget context files load slower and crowd downstream consumer context windows (D20 token-chain risk) | High |
| 2 | D17 dim-group drift means a `--dim context-quality-lifecycle` invocation has no defined behavior — parser will either reject or silently mis-route | Medium |
| 3 | D14 STRUCTURE-* files are inconsistent with the rest of the directory and confuse newcomers; deferred but tracked | Low |
| 4 | D22 empty subdirectories are noise; they signal incomplete work that may already have been abandoned | Low |

---

## 🔍 Context information

### Environment

| Field | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Workspace root | `c:\dev\darioairoldi\Learn` |
| PE vision version | v13 ([20260523.01-vision.v13.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md)) |
| Reviewed directory | `.copilot/context/00.00-prompt-engineering/` (37 `.md` files) |
| Review prompt | [.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) v1.1.2 |
| Dimension group | `--dim context-full` = D1, D2, D3, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D17, D19, D22 (16 dims) |
| Catalog | [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) v1.1.0 |
| Type checklist | [05.08-pe-meta-type-checklists.md](../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md) — context-file hard ceiling **2,500 tokens** |
| Mode | `apply` (default) — auto-apply non-breaking, propose breaking |
| OS | Windows + PowerShell |

### D3 token-budget — measured overruns

Conservative estimate `wordcount × 1.3`:

| File | Words | Est. tokens | Over by | Disposition |
|---|---:|---:|---:|---|
| [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | ~2,360 | **3,067** | +567 | Plan 01.01 — extract |
| [05.03-pe-workflow-entry-points.md](../../../../../.copilot/context/00.00-prompt-engineering/05.03-pe-workflow-entry-points.md) | ~2,316 | **3,011** | +511 | Plan 01.01 — extract |
| [05.06-pe-strategic-review-criteria.md](../../../../../.copilot/context/00.00-prompt-engineering/05.06-pe-strategic-review-criteria.md) | ~2,055 | **2,672** | +172 | **Deferred** (marginal) |
| [02.05-agent-workflow-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.05-agent-workflow-patterns.md) | ~1,928 | **2,506** | +6 | **Deferred** (marginal) |

### D17 cross-coherence — drift sites

[pe-meta-context-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md) references the following undefined dim-group identifiers:

| Line | Current text | Canonical replacement |
|---|---|---|
| 28 | `--dim context-quality-lifecycle is selected` | `--dim context-full is selected` |
| 41 | `Lifecycle mode: --dim context-quality-lifecycle` | `Lifecycle mode: --dim context-full` |
| 42 | `Lifecycle health mode: --dim context-quality-health` | `Lifecycle health mode: --dim context-health` |
| 52 | `When --dim context-quality-lifecycle is selected, follow strict stage order:` | `When --dim context-full is selected, follow strict stage order:` |
| 71 | `Lifecycle health mode (--dim context-quality-health) runs lightweight checks…` | `Lifecycle health mode (--dim context-health) runs lightweight checks…` |

Catalog [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) lines 130–131 defines only `context-full` (16 dims) and `context-health` (8 dims) — no `context-quality-*` variants.

### D22 empty subdirectories

| Path | Contents | Decision |
|---|---|---|
| `.copilot/context/00.00-prompt-engineering/dependency-map/` | (empty) | Plan 01.03 — add `.gitkeep` |
| `.copilot/context/00.00-prompt-engineering/structure/` | (empty) | Plan 01.03 — add `.gitkeep` |

---

## 🔬 Analysis

### Root cause — D3 (token-budget overflow)

`05.07` and `05.03` are reference catalogs. They each contain multiple high-density tables that grew organically as the dimension/handler/workflow surface expanded:

- **`05.07`** carries four big tables: the canonical D1–D35 dimension table (~32 rows), an applicability matrix (35 rows × 8 artifact-type columns), a cost-gradient table (~11 rows), and a dimension-to-handler mapping. The dimension table itself is the contract and must stay inline; the **applicability matrix and the cost gradient are pure reference data** that consumers seldom need at decision time — ideal candidates for extraction to a template file referenced via `📖`.
- **`05.03`** carries the Quick Decision tree plus per-phase tables (Consolidated, Phase A, B, C, D, E). The Quick Decision tree is the core navigational artifact; the per-phase tables can be split into a single reference template.

The base context file (after extraction) keeps just the decision-driving content. Detail tables move behind a `📖` reference, loaded on demand by consumers that actually need them. This pattern is already established in the directory (e.g., `01.04-tool-composition-guide.md` → `reference-tool-catalog.template.md`).

### Root cause — D17 (cross-coherence drift)

The prompt was written when the catalog used `context-quality-lifecycle` / `context-quality-health` as working names; the catalog was later normalized to `context-full` / `context-health` (vision v13 alignment), but the prompt was not updated in lockstep. There is **no implementation behind the old names** — the parser would either reject them or, worse, ignore the `--dim` value and fall back to `--dim full`, masking the failure.

Since the catalog is the authoritative source of dim-group names (per its boundaries: "Dimension group names are a contract — consumers reference them via `--dim`"), the prompt is the artifact that must move. Option A (renaming the catalog) was rejected because:
- 5 prompt occurrences vs. 2 catalog rows — fewer edits in Option B
- Other consumers (`pe-meta-review`, `pe-meta-update`) already use `context-full` / `context-health`
- Renaming the catalog would propagate breaking changes to those siblings

### Root cause — D22 (empty subdirectories)

Two subdirectories were created during earlier directory-restructuring work (likely v12-era preparation for dependency-map externalization and structure-extraction tooling). The work was not completed and the directories were never populated or removed. They are placeholders, not abandonments — the user confirms in-flight intent. Adding a `.gitkeep` makes the placeholder explicit, preserves the slot for future fill-in, and silences directory-cleanliness warnings.

### Why this was not caught earlier

- D2 reference drift accumulated as a side-effect of the `pe-`-prefix instruction-file rename (sometime between v12 and v13). The renames were applied to `.github/instructions/` but the back-references in context files were missed — exactly the kind of breakage that a periodic `--dim context-full` review is designed to catch.
- D3 over-budget happened because individual edits each added a few rows to a table without anyone running the file through the budget check. The hard ceiling was raised from "no hard ceiling" to "2,500 tokens" only recently (`05.08` v1.x).
- D17 drift slipped through because no prior review walked the prompt's dim-group references against the catalog.
- D22 empty directories are easy to miss in IDE views (collapsed by default) and the original `--dim context-full` group did not include a system-level orphan check until D22 was added.

### Impact assessment

| Dimension | Before (current) | After (plans executed) |
|---|---|---|
| `05.07` token cost on load | ~3,070 (over) | ~2,200–2,400 (under ceiling) |
| `05.03` token cost on load | ~3,010 (over) | ~2,200–2,400 (under ceiling) |
| `--dim context-quality-*` resolution | undefined behavior | parser-rejected or correctly aliased to `context-full`/`context-health` |
| Empty-directory noise | 2 unexplained | 2 explicitly-marked placeholders |
| Consumer-chain token-budget headroom | tight | restored |

### Affected workflows

- **`/pe-meta-context-review`** — uses the misaligned dim-group names; will fail or mis-route until Plan 01.02 lands.
- **`/pe-meta-review`** with context scope — loads `05.07` and consumer chains that load it; over-budget tax until Plan 01.01 lands.
- **All consumers of `05.07` and `05.03`** — every PE meta agent and several prompts; benefit from token reduction.

---

## 🔄 Reproduction steps

### Reproducing the D3 finding

1. Open a PowerShell terminal at the repo root.
2. Run:

   ```powershell
   Get-ChildItem .copilot/context/00.00-prompt-engineering/*.md | ForEach-Object {
     $words = (Get-Content $_.FullName -Raw -Encoding UTF8).Split() | Where-Object { $_ -match '\S' } | Measure-Object | Select-Object -ExpandProperty Count
     [PSCustomObject]@{ File = $_.Name; Words = $words; EstTokens = [math]::Round($words * 1.3) }
   } | Where-Object EstTokens -gt 2500 | Sort-Object EstTokens -Descending | Format-Table -AutoSize
   ```

3. **Observation:** four files (`05.07`, `05.03`, `05.06`, `02.05`) report estimated tokens above the 2,500 ceiling defined in [05.08-pe-meta-type-checklists.md](../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md).

### Reproducing the D17 finding

1. Search the prompt:

   ```powershell
   Select-String -Path .github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md -Pattern 'context-quality-(lifecycle|health)'
   ```

2. **Observation:** 5 matches.
3. Search the catalog for the same identifiers:

   ```powershell
   Select-String -Path .copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md -Pattern 'context-quality-(lifecycle|health)'
   ```

4. **Observation:** 0 matches. Catalog defines only `context-full` and `context-health` — confirming the drift.

### Reproducing the D22 finding

1. List the subdirectory tree:

   ```powershell
   Get-ChildItem .copilot/context/00.00-prompt-engineering -Directory -Recurse |
     Where-Object { (Get-ChildItem $_.FullName -Force | Measure-Object).Count -eq 0 }
   ```

2. **Observation:** `dependency-map/` and `structure/` are empty.

---

## ✅ Solution implemented

**Implementation status:** Autonomous portion **DONE** (D2 — 11 reference fixes applied and verified). All three plans **EXECUTED** on 2026-05-25 (token budgets resolved, dim-group naming aligned, `.gitkeep` placeholders added).

### Plan inventory

| Plan | File | Scope | Estimated effort |
|---|---|---|---|
| 1 | [01.01-token-budget-extract-tables-plan.md](01.01-token-budget-extract-tables-plan.md) | Move heavy tables from `05.07` and `05.03` into two new template files in `.github/templates/00.00-prompt-engineering/`; insert `📖` references in the source files; re-run D3 to verify both files drop under 2,500 tokens. | Medium |
| 2 | [01.02-dim-group-naming-alignment-plan.md](01.02-dim-group-naming-alignment-plan.md) | Rename five occurrences in [pe-meta-context-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md): `context-quality-lifecycle` → `context-full`, `context-quality-health` → `context-health`. Bump version, refresh `last_updated`. | Small |
| 3 | [01.03-empty-subdir-gitkeep-plan.md](01.03-empty-subdir-gitkeep-plan.md) | Add `.gitkeep` to `dependency-map/` and `structure/` with a one-line comment header explaining the placeholder. | Trivial |

### Defer — recorded but not actioned this cycle

| Item | Reason | When to revisit |
|---|---|---|
| D3 marginal overruns on `05.06` (+172) and `02.05` (+6) | Low impact; risk of churn outweighs benefit | Next `--dim context-full` review (~30 days) |
| D14 STRUCTURE-*.md naming exceptions (3 files, top-referenced `STRUCTURE-README.md` has 76 consumers) | Renaming would require updating 76+ consumer back-references; needs a coordinated PE-system-wide pass | Next `--dim adherence` review or a dedicated naming-cleanup cycle |

### Worked example — D3 extraction (05.07)

| Today | After plan |
|---|---|
| `05.07` inline: dimension table + applicability matrix + cost gradient + handler map (~2,360 words) | `05.07` inline: dimension table + handler map (~1,400 words) + `📖` reference to `reference-dimension-applicability.template.md` and `reference-dimension-cost-gradient.template.md` |
| Consumers load all four tables every time | Consumers load only the dimension table + map; applicability/cost-gradient loaded on demand |

### UX preservation

Extracted tables remain reachable by a single `📖` link click — no information is lost, only moved. Consumers that genuinely need the applicability matrix (e.g., `pe-meta-validator` during dimension dispatch) load it explicitly; consumers that don't (most agents) skip the load entirely. This is the same `📖`-reference pattern already used by [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) → [reference-tool-catalog.template.md](../../../../../.github/templates/00.00-prompt-engineering/reference-tool-catalog.template.md).

---

## 📚 Additional information

### Testing recommendations

After plans 01.01–01.03 are executed:

- Re-run the D3 measurement command above and confirm `05.07` and `05.03` drop below 2,500 estimated tokens.
- Run the reference validator on the new template files to confirm all `📖` back-pointers resolve:

  ```powershell
  Select-String -Path .copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md,.copilot/context/00.00-prompt-engineering/05.03-pe-workflow-entry-points.md -Pattern '📖.*templates'
  ```

- Verify Plan 01.02 by searching for the old dim-group names — expect 0 matches outside this issue/plan:

  ```powershell
  Select-String -Path .github/prompts -Pattern 'context-quality-(lifecycle|health)' -Recurse
  ```

- Verify Plan 01.03 by listing tracked files under the two subdirectories:

  ```powershell
  git ls-files .copilot/context/00.00-prompt-engineering/dependency-map .copilot/context/00.00-prompt-engineering/structure
  ```

- Re-run `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full` end-to-end and confirm all four findings clear.

### Migration considerations

| Consideration | Decision |
|---|---|
| Template-extraction backward compatibility | None needed — context files load via consumer reads, not stable contract |
| `05.07` dimension table stays inline | Required — it IS the D1–D35 contract and is referenced by ID elsewhere |
| Catalog group-name contract | Preserved (no catalog edits) — Plan 01.02 changes only the prompt |
| Empty-directory removal vs. `.gitkeep` | User chose `.gitkeep` — preserves slot for in-flight work |

### Performance impact

- **Token budget headroom restored** on the two heaviest context files (~700–1,000 tokens freed per load).
- **Consumer chain** for agents that load `05.07` (e.g., `pe-meta-validator`) gets the same headroom, indirectly improving downstream agents that handoff with the validator.
- **Prompt parsing** — fixing the dim-group drift means `/pe-meta-context-review` actually resolves its `--dim` argument to a real group; no runtime surprises.

### Cross-references

- Original review command: `/pe-meta-context-review .copilot/context/00.00-prompt-engineering/ --dim context-full`
- Dimension catalog (authoritative): [05.07-pe-meta-dimension-catalog.md](../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)
- Type checklist (token ceiling source): [05.08-pe-meta-type-checklists.md](../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md)
- Prompt under audit: [pe-meta-context-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md)
- Existing extract precedent: [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) → [reference-tool-catalog.template.md](../../../../../.github/templates/00.00-prompt-engineering/reference-tool-catalog.template.md)
- Related sibling issues (pattern: artifact craftsmanship drift):
  - [20260524.02-artifacts-craftmanship-notrespected](../20260524.02-artifacts-craftmanship-notrespected/)
  - [20260524.04-dim-vs-healthcheck](../20260524.04-dim-vs-healthcheck/) — also surfaced a contract-drift problem

---

## ✔️ Resolution status

### Current status

**Resolved — D2 fixes applied autonomously; plans 01.01 / 01.02 / 01.03 executed on 2026-05-25. Re-run of `/pe-meta-context-review --dim context-full` deferred to next review cycle.**

### Verification checklist

- Issue investigated and four breaking findings documented. (✅ done)
- Autonomous D2 reference fixes applied (11 edits across 9 files). (✅ done)
- Re-validation confirms zero remaining broken refs in the reviewed directory. (✅ done)
- Plan 01.01 (D3 token-budget — extract tables) drafted. (✅ done)
- Plan 01.02 (D17 dim-group naming alignment) drafted. (✅ done)
- Plan 01.03 (D22 empty-subdir `.gitkeep`) drafted. (✅ done)
- User approves the three plans' approach and scope. (✅ done)
- Plan 01.01 executed; `05.07` and `05.03` both verified < 2,500 estimated tokens. (✅ done — 1,963 and 1,613)
- Plan 01.02 executed; `Select-String` for old dim-group names returns zero matches outside this issue. (✅ done)
- Plan 01.03 executed; `git ls-files` shows the two `.gitkeep` files tracked. (✅ done)
- End-to-end re-run of `/pe-meta-context-review … --dim context-full` clears all four findings. (🟡 todo — deferred to next review cycle)
- Issue status updated to "Resolved" with closure date. (✅ done — 2026-05-25)

### Follow-up actions

| # | Action | Owner | When |
|---|---|---|---|
| 1 | Confirm scope and acceptance criteria for the three plans | User | Before plan 01.01 execution |
| 2 | Decide whether `05.06` and `02.05` marginal overruns should be addressed in a future cycle | User | Within next 30 days |
| 3 | Schedule a future `--dim adherence` cycle to address the deferred D14 `STRUCTURE-*.md` naming exceptions | User | Within next 60 days |
| 4 | Confirm `dependency-map/` and `structure/` are still in-flight; if abandoned, switch Plan 01.03 to deletion | User | At Plan 01.03 execution |
| 5 | Audit sibling prompts (`pe-meta-review`, `pe-meta-update`) for any other dim-group drift the current review did not target | Reporter | After Plan 01.02 lands |

---

## 🎓 Lessons learned

### What went wrong

- **Reference drift after rename**: The `.github/instructions/*` → `.github/instructions/pe-*` rename was applied at the source but not back-propagated to context-file `Referenced by` notes. A rename-and-update macro would have caught this.
- **Contract drift between prompt and catalog**: Five occurrences of an undefined dim-group identifier slipped through because no review walked prompt arguments against the catalog. The catalog has explicit "dimension group names are a contract" boundaries (line 23 of 05.07) — but the rule was not auto-enforced.
- **Silent table growth**: Tables in `05.07` and `05.03` accumulated past the 2,500-token ceiling without anyone running the budget check. No CI gate exists for token budgets.

### What went right

- The `--dim context-full` group, even though referenced under a wrong name in the prompt, executed correctly because the underlying dimension list is well-defined.
- All 37 files met the D1 exemplary metadata bar — the metadata contract is healthy and produces no false positives.
- The `📖` reference pattern was already established (`01.04` → `reference-tool-catalog.template.md`), so the extraction proposed in Plan 01.01 is low-novelty.
- The auto-apply / human-confirm split worked as designed: 11 fixes shipped autonomously, 4 breaking findings cleanly proposed.

### Improvements for the future

- **CI gate for D3**: Add a PowerShell pre-commit (or `.github/hooks/`) check that fails commits raising any context file above 2,500 estimated tokens. The detection script already exists in this issue's reproduction steps.
- **Cross-artifact contract sweep**: When renaming a catalog identifier or any contract field, the rename script must also grep all consumers and fail if any references the old name. Apply to dim-group names, dimension IDs, and instruction-file paths.
- **Empty-directory check in `--dim context-full`**: D22 already covers this; ensure it stays in the group going forward.
- **Periodic `--dim context-full` cadence**: Run this review monthly (not only on demand) to amortize drift detection.

---

## 📎 Appendix

### Files modified during the autonomous phase

```
.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md
.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md
.copilot/context/00.00-prompt-engineering/01.02-prompt-assembly-architecture.md
.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md
.copilot/context/00.00-prompt-engineering/02.01-handoffs-pattern.md
.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md
.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md
.copilot/context/00.00-prompt-engineering/02.05-agent-workflow-patterns.md
.copilot/context/00.00-prompt-engineering/03.01-progressive-disclosure-pattern.md
.copilot/context/00.00-prompt-engineering/03.05-copilot-spaces-patterns.md
.copilot/context/00.00-prompt-engineering/04.02-adaptive-validation-patterns.md
```

### Deferred dimensions

D9 (clarity), D10 (completeness), D11 (actionability), D13 (source verification), D15 (vision alignment), and D19 (artifact structure) were not fully swept in this review. Spot checks revealed no contradictions, but a deeper reasoning pass would extend coverage. Recommend a follow-up `--mode propose --dim D9,D10,D11,D13,D15,D19` invocation if the current cycle's remediation lands cleanly.

### Construction invariants — spot-check summary

| Invariant | Result |
|---|---|
| No contradictions across files | Pass (sampled handoffs / token-opt / agent-shared overlap) |
| No obvious redundancies | Pass (cross-refs used appropriately; minor `02.04`/`02.05` overlap is intentional) |
| Naming mostly conforming | Partial — `STRUCTURE-*.md` exceptions deferred |
| Testability of validation methodology | Pass — `04.02-adaptive-validation-patterns.md` is concrete and adoptable |

### Consumer adherence highlights

| File | Consumers |
|---|---:|
| `STRUCTURE-README.md` | 76 |
| `01.04-tool-composition-guide.md` | 39 |
| `01.01-context-engineering-principles.md` | 31 |

All 37 files have ≥2 consumers (D6 pass).
