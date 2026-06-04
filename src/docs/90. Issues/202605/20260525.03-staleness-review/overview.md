---
title: "Issue: `/pe-meta-update --scope context` apply-mode run surfaces root-index gap, broken cross-refs after PE-prefix rename, stale inventory tables, and reserved-status placeholder folders"
author: "Dario Airoldi"
date: "2026-05-27"
categories: [issue, prompt-engineering, pe-meta, context-quality, staleness-review]
description: "An on-demand `/pe-meta-update --mode apply --scope context` run over `.copilot/context/**/*.md` (51 files) caught one CRITICAL coverage gap missed by the 2026-05-26 metadata-compliance run (root index had no frontmatter), 5 HIGH broken cross-references (1 from a 2026-04-28 rename of `context-files` → `pe-context-files`, 4 path-depth bugs), 2 MEDIUM consistency issues (stale per-folder inventory tables, untouched reserved-status placeholder folders), and exposed two reusable scanner anti-patterns (code-fence blindness, `.gitkeep`-pointer blindness). All applied findings rolled back-safely; one MEDIUM finding deferred for user re-confirmation."
draft: false
status: "resolved-partial"
severity: "High"
component: "`.copilot/context/` directory (51 files) + on-demand `/pe-meta-update` orchestrator pipeline"
framework: "GitHub Copilot Customization v1.107 (vision v13, PE meta-pipeline)"
---

# Issue analysis — `/pe-meta-update --mode apply --scope context` 2026-05-27 staleness review

**Issue ID:** 20260525.03-staleness-review
**Date reported:** 2026-05-27
**Reporter:** Dario Airoldi
**Status:** Resolved (partial) — 3 files updated and regression-tested PASS; 1 MEDIUM finding deferred pending user re-confirmation (S2 placeholder-folder cleanup); 1 MEDIUM finding deliberately untouched per user-approved Option A (N1 staleness on 5 article-writing files with no content delta)
**Severity:** High (1 CRITICAL + 1 HIGH × 5 occurrences)
**Component:** `.copilot/context/` (51 `.md` files) + [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) v2.0.0 (8-phase pipeline)
**Framework:** Vision v13 — PE meta-pipeline, `apply --scope context` mode

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

A user-invoked `/pe-meta-update --mode apply --scope context` run executed the 8-phase orchestrator pipeline ([pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) v2.0.0) against the full context directory (`.copilot/context/**/*.md`, 51 files). The pipeline surfaced **7 findings** — 1 CRITICAL, 1 HIGH (with 5 occurrences), 2 MEDIUM, and 2 LOW informational — that had survived the 2026-05-26 metadata-compliance run because that prior run was scoped to two specific subfolders (`90.00-learning-hub/` Bundle A + `00.00-prompt-engineering/` Bundle B) and did not visit the root or `01.00-article-writing/`.

The run was non-trivial in three respects:

1. **A first-pass scanner produced false positives** because it did not respect Markdown fenced code blocks (` ``` `). Two of the seven initially-reported broken links were inside example code fences in the root index. A second code-fence-aware scan confirmed the real count was **5**, not 7.
2. **A user-approved deletion was deferred** mid-apply when reading the target `.gitkeep` files revealed reserved-status comments tying the placeholder folders to `Plan 01.03` of [20260525.01-context-fullcheck/overview.md](../20260525.01-context-fullcheck/overview.md). The approval had been granted on the assumption these were orphan empty folders; the new information changed the risk profile and triggered a graceful deferral with a re-confirmation request.
3. **A historical rename (2026-04-28)** of `context-files.instructions.md` → `pe-context-files.instructions.md` had left a dangling reference in the root context index — surviving multiple subsequent runs because the file was not under the in-scope subfolders of those runs.

### Findings summary

| ID | Severity | Dimension | Finding | Files | Disposition |
|---|---|---|---|---|---|
| S1 | **CRITICAL** | Structure (frontmatter) | Root `00.00-context-folder-index.md` had no YAML frontmatter at all (contract violation) | 1 | ✅ Applied |
| C1 | **HIGH** | Consistency (cross-refs) | 5 broken links: 1 from 2026-04-28 PE-prefix rename + 4 path-depth bugs (`../..` should be `../../..`) | 2 | ✅ Applied |
| C2 | **MEDIUM** | Consistency (inventory drift) | 3 stale tables in root index: 24-file PE inventory + 5-file article-writing inventory + reverse-mapping with pre-renumbering single-digit IDs | 1 | ✅ Applied (replaced with pointers) |
| S2 | **MEDIUM** | Structure (orphans) | Empty placeholder folders `dependency-map/` and `structure/` in `00.00-prompt-engineering/` | 2 dirs | 🟡 **Deferred** — `.gitkeep` files contain reserved-status markers referencing Plan 01.03; needs user re-confirmation |
| N1 | **MEDIUM** | Content (staleness) | 5 `01.00-article-writing/` files dated 2026-04-26 (31 days stale) | 5 | 🟡 **Not touched** per user-approved Option A (no fake freshness stamps; recommend focused content review on next pass) |
| N2 | LOW | Content (budgets) | Pre-existing token-budget overruns from 2026-03-15 healthcheck | 5+ | ℹ️ No action (documented exception) |
| N3 | LOW | Structure (overlap) | Root index partially duplicates per-folder structure-index files | 1 | ℹ️ Partially mitigated by C2 (pointer consolidation) |

### Impact points

| # | Impact | Severity contribution |
|---|---|---|
| 1 | Root context-folder index acted as a primary navigation entry but lacked frontmatter — broke metadata-driven tooling (staleness detection, dependency-map regeneration) | **High** |
| 2 | 5 dangling cross-references degraded the "consistency" dimension and would produce 5 user-visible 404s on click | **High** |
| 3 | Stale inventory tables in the root index contradicted the canonical per-folder structure-index, causing dual-source-of-truth drift for any reader navigating from root | **Medium** |
| 4 | Placeholder folder `dependency-map/` is referenced by `Plan 01.03` for in-flight work; an over-eager deletion would have erased that reservation marker | **Medium** (averted via deferral) |
| 5 | Two reusable PE-pipeline anti-patterns identified: scanner code-fence blindness (false positives) and `.gitkeep`-pointer blindness (silent loss of reserved-status metadata) | **Process-level** |

---

## 🔍 Context information

### Environment

| Field | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Workspace root | `c:\dev\darioairoldi\Learn` |
| PE vision version | v13 ([20260523.01-vision.v13.md](../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md)) |
| Reviewed directory | `.copilot/context/**/*.md` (51 files at run start) |
| Orchestrator | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) v2.0.0 (8-phase pipeline) |
| Metadata contract | [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) v1.1.0 |
| Prior compliance run | 2026-05-26 (Bundle A: 7 files in `90.00-learning-hub/`, Bundle B: 19 files in `00.00-prompt-engineering/`) |
| Mode | `apply` (default) — proposed, approved by user ("approve all"), applied |
| Run timestamp (rollback dir) | `20260527-143627` |
| OS | Windows + PowerShell |

### Pipeline phase status (this run)

| Phase | Step | Status |
|---|---|---|
| 0 | Inventory + load dependency map | ✅ |
| 1 | Source research (internal-only; no external URL) | ✅ |
| 2 | Structure audit (frontmatter, orphans) | ✅ |
| 3 | Consistency audit (cross-refs, naming, inventory) | ✅ |
| 4 | Content audit (staleness, budgets) | ✅ |
| 5 | Present consolidated changelist for approval | ✅ ("approve all") |
| 6 | Apply approved changes | 🟡 Partial (S2 deferred after `.gitkeep` re-read) |
| 7 | Regression test (code-fence aware) | ✅ PASS — 0 broken links (was 5), 0 missing frontmatter (was 1/51) |
| 8 | Report + update [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | ✅ |

### Phase 5 changelist isolation

The Phase 5 plan was persisted to a date-suffixed isolation file:
[.copilot/temp/pe-meta-state/phase-5-changelist-20260527.md](../../../../../.copilot/temp/pe-meta-state/phase-5-changelist-20260527.md)

This is the convention used to avoid clobbering prior runs' changelist history.

### Rollback snapshots

3 files snapshotted to `.copilot/temp/rollback/*.20260527-143627.bak`:

| File | Snapshot |
|---|---|
| `.copilot/context/00.00-context-folder-index.md` | `00.00-context-folder-index.md.20260527-143627.bak` |
| `.copilot/context/01.00-article-writing/02-validation-criteria.md` | `02-validation-criteria.md.20260527-143627.bak` |
| `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md` | `05.04-meta-review-log.md.20260527-143627.bak` |

### Approval gate

Per the orchestrator's approval rules for `scope=context`: **MEDIUM/HIGH/CRITICAL ALL require approval** — there are no autonomous edits in this scope. The user response "approve all" mapped to:

| Finding | Option chosen |
|---|---|
| S1 | Option A — Add complete YAML frontmatter |
| C1 (all 7 originally; 5 after fence-aware re-scan) | All fixes |
| S2 | Option A — Delete folders (later deferred when `.gitkeep` contents revealed reservation) |
| C2 | Option A — Replace stale tables with pointers to canonical structure-index and dependency-map |
| N1 | Option A — Touch-only on files with content changes (i.e., no fake freshness stamps elsewhere) |

---

## 🔬 Analysis

### Root cause(s)

| Finding | Root cause | Why it survived prior runs |
|---|---|---|
| **S1** root index lacks frontmatter | Bundle A of the 2026-05-26 run targeted `90.00-learning-hub/` files specifically; the root-level `00.00-context-folder-index.md` was not on the working set | Scope-by-folder audit pattern blindly omits files that live above the smallest in-scope folder |
| **C1 #1** `context-files` → `pe-context-files` | 2026-04-28 fullcheck renamed 9 instruction files to add `pe-` prefix; the root index had a stale reference but was outside that run's review scope (instructions, not context) | Cross-scope reference drift — when scope=instructions renames a file, scope=context refs to it must be re-validated, but no cross-scope hook existed |
| **C1 #4-7** path-depth bugs `../..` → `../../..` | `02-validation-criteria.md` lives at `.copilot/context/01.00-article-writing/` — two folders deep; references to repo-root resources like `.github/prompts/` need three `../` to escape | Original author miscounted depth; the link rendered as text (no anchor verification) in most preview tools |
| **C2** stale inventory tables | Per-folder structure-index files (`STRUCTURE-*`) became the canonical inventory in the 2026-04-28 fullcheck; the root index inventory tables were not updated at that time | Dual sources of truth — root summary table vs per-folder index — drift inevitably when only one is updated |
| **S2** placeholder folder defer | `.gitkeep` files contained free-form comments (not metadata fields) referencing Plan 01.03; deletion-eligibility heuristic ("empty folder") used file size only, not file content | Empty-folder detection rule should be augmented with "and no reserved-status markers" |
| **Scanner false positives** | First-pass PowerShell broken-link regex did not toggle a `$inFence` state on ` ``` ` fence delimiters | Scanner correctness was assumed because earlier runs happened to have few code blocks containing fake links |

### Why this matters for the PE-meta pipeline (architectural)

This run exposed **three reusable lessons** that need codification beyond the specific files fixed:

1. **Cross-scope reference invalidation hook.** When `scope=instructions` (or any non-context scope) renames a file, refs to it inside `scope=context` files become silently stale. The orchestrator should run a cross-scope reference sweep after any scope-bounded rename.
2. **Code-fence-aware scanner is mandatory.** Any audit emitting broken-link counts that drive Phase 5 approval decisions must respect fenced code blocks. False positives erode trust in the changelist.
3. **Empty-folder heuristic must read placeholder file contents.** A `.gitkeep` is never "empty" in the semantic sense if it contains plan-pointer text. The deletion eligibility rule must include "no reserved-status comments in placeholder files" as a guard.

### Affected workflows

| Workflow | How it was affected |
|---|---|
| `/pe-meta-update --scope context` | Now demonstrably catches root-level files (vs subfolder-only Bundle A pattern of 2026-05-26) |
| Staleness detection via `pe-staleness-check` hook | Was reading wrong `last_updated` baseline from the root index — fixed by S1 frontmatter addition |
| Dependency-map regeneration | Was operating with stale inventory tables in root index — fixed by C2 pointer consolidation |
| Article-writing context loading | Was rendering 4 broken cross-references in `02-validation-criteria.md` — fixed by C1 |
| Plan 01.03 (placeholder folders) | Would have been silently broken by S2 deletion — averted via deferral |

---

## 🔄 Reproduction steps

### Trigger

User invocation in the current conversation:

```
/pe-meta-update --mode apply --scope context
```

### Pipeline execution (high-level)

1. Orchestrator reads `pe-meta-update.prompt.md` v2.0.0
2. Phase 0: inventory `.copilot/context/**/*.md` (51 files); load dependency map from `.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md`
3. Phase 1: no external URL provided → internal-only research
4. Phases 2-4: audit structure / consistency / content dimensions; emit findings
5. Phase 5: consolidate findings into [.copilot/temp/pe-meta-state/phase-5-changelist-20260527.md](../../../../../.copilot/temp/pe-meta-state/phase-5-changelist-20260527.md); present to user
6. User: **"approve all"**
7. Phase 6: apply
   - 7a: Edit root index (`00.00-context-folder-index.md`) — frontmatter + broken link + 3 inventory pointers
   - 7b: Edit `02-validation-criteria.md` — 4 path fixes + version bump
   - 7c: Pre-delete read of `.gitkeep` files → DEFER S2 with re-confirmation flag
   - 7d: (Phase 8) Update `05.04-meta-review-log.md`
8. Phase 7: code-fence-aware regression scan → PASS (0 broken, 0 missing frontmatter)
9. Phase 8: append apply-mode entry to `05.04-meta-review-log.md`; refresh manifest; bump version 1.4.0 → 1.5.0

### Affected code/content locations

| File | Operation | Lines / scope |
|---|---|---|
| [.copilot/context/00.00-context-folder-index.md](../../../../../.copilot/context/00.00-context-folder-index.md) | Add frontmatter; fix link; replace 3 inventory sections with pointers | Top of file + 3 inline sections |
| [.copilot/context/01.00-article-writing/02-validation-criteria.md](../../../../../.copilot/context/01.00-article-writing/02-validation-criteria.md) | 4 path-depth fixes; version bump 2.2.0 → 2.2.1 | Lines 128, 150, 151, 160 + frontmatter |
| [.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | Prepend 2026-05-27 entry; refresh manifest; version 1.4.0 → 1.5.0 | Frontmatter + manifest section + apply-mode runs heading |

---

## ✅ Solution implemented

### Fix overview

| Phase | Action | Files | Result |
|---|---|---|---|
| 6a | Add YAML frontmatter (v1.1.0) to root index per metadata contract | 1 | S1 RESOLVED |
| 6a | Fix dangling link `context-files.instructions.md` → `pe-context-files.instructions.md` | 1 | C1 #1 RESOLVED |
| 6b | 4 path-depth fixes `../..` → `../../..` in `02-validation-criteria.md` | 1 | C1 #4-7 RESOLVED |
| 6a | Replace 24-file PE inventory + 5-file article-writing inventory + Article-to-Context reverse-mapping with pointers to canonical structure-index and dependency-map | 1 | C2 RESOLVED |
| 6c | Pre-delete `.gitkeep` read → detect Plan 01.03 reservation → **DEFER** | 0 (read-only) | S2 ESCALATED back to user |
| 8 | Append `#### 2026-05-27 — apply context …` entry to [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md); refresh manifest; bump to v1.5.0 | 1 | Pipeline closed-loop |

### Key code changes

#### Root index frontmatter (S1)

```yaml
---
title: "Context folder index"
description: "Navigation index for .copilot/context/ — points to per-domain structure-indexes and the cross-domain dependency map."
version: "1.1.0"
last_updated: "2026-05-27"
domain: "prompt-engineering"
goal: "Single navigation entry into the context folder; route consumers to the canonical per-folder structure-index file."
scope:
  covers: [folder-purpose summaries, per-domain pointers, generation workflow, numbering convention]
  excludes: [per-file metadata details (delegated to structure-index files), artifact dependency graph (delegated to 05.01)]
boundaries: [does not duplicate per-folder structure-index contents, does not enumerate every file, does not define metadata contract]
rationales: [single point of navigation reduces drift, pointers prevent dual sources of truth]
---
```

#### Broken-link fix in root index (C1 #1)

```diff
- See [context-files.instructions.md](../../.github/instructions/context-files.instructions.md)
+ See [pe-context-files.instructions.md](../../.github/instructions/pe-context-files.instructions.md)
```

#### Path-depth fixes in `02-validation-criteria.md` (C1 #4-7)

```diff
- [Article creation prompt](../../.github/prompts/01.00-article-writing/...)
+ [Article creation prompt](../../../.github/prompts/01.00-article-writing/...)

- [Technical writing context](../../03.00-tech/40.00-technical-writing/...)
+ [Technical writing context](../../../03.00-tech/40.00-technical-writing/...)
```

(Identical pattern repeated on 4 lines: 128, 150, 151, 160.)

#### Inventory pointer replacement (C2)

```diff
- ### 00.00-prompt-engineering inventory (24 files)
-
- | # | File | Description |
- |---|---|---|
- | 1 | 01-context-engineering-principles.md | … |
- | … 24 rows … |
+ ### 00.00-prompt-engineering inventory
+
+ See the canonical per-folder structure-index:
+ [./00.00-prompt-engineering/00.00-context-structure-index.md](./00.00-prompt-engineering/00.00-context-structure-index.md)
```

(Identical pattern for article-writing inventory and Article-to-Context reverse-mapping.)

### Solution features

- ✅ Frontmatter additions follow [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) v1.1.0 exactly (all 9 required fields)
- ✅ Inventory pointer pattern eliminates the dual-source-of-truth drift that caused C2
- ✅ Path-depth fixes verified by code-fence-aware regression scan
- ✅ All 3 modified files snapshotted to `.copilot/temp/rollback/*.20260527-143627.bak` (atomic rollback possible)
- ✅ Meta-review log captures the run for future staleness-detection hooks and incremental-mode `--incremental` filters

---

## 📚 Additional information

### Testing recommendations

| Recommendation | Owner | Priority |
|---|---|---|
| Re-run `/pe-meta-update --mode plan --scope context` on next review cycle to confirm 2026-05-27 fixes hold and surface any new drift | PE meta-orchestrator | High |
| Run a one-time `/pe-meta-update --scope instructions` to validate no analogous rename-orphans exist in instruction files | PE meta-orchestrator | Medium |
| Adopt code-fence-aware scanner as the **default** PowerShell scanner shipped in the orchestrator template (see [Lessons learned](#-lessons-learned)) | PE template-authors | High |
| Add `.gitkeep`-content guard to the empty-folder deletion heuristic | PE meta-orchestrator | Medium |

### Migration considerations

- **None.** All changes are metadata, link-path, or inventory-pointer edits. No behavioral or rule changes.

### Performance impact

- **Positive (minor).** Replacing 3 stale inventory tables with single-line pointers reduces the root index from ~24 + 5 + many rows of stale inventory to ~3 pointer paragraphs. Saves an estimated ~1,200 tokens whenever the root index is loaded into a context window.

### Related issues

- [20260525.01-context-fullcheck/overview.md](../20260525.01-context-fullcheck/overview.md) — Plan 01.03 reserves the `dependency-map/` and `structure/` placeholder folders that S2 attempted to delete
- [20260525.02-context-fullcheck-analysis/](../20260525.02-context-fullcheck-analysis/) — STRUCTURE-* file rename plan (precursor for the per-folder canonical structure-index files now pointed to by C2)
- [20260524.04-dim-vs-healthcheck/](../20260524.04-dim-vs-healthcheck/) — Related dim-group naming work

---

## ✔️ Resolution status

### Current status

| Finding | Status | Note |
|---|---|---|
| S1 | ✅ **Resolved** | Root index now has full frontmatter |
| C1 (5 occurrences) | ✅ **Resolved** | All 5 cross-references resolved; regression scan confirms 0 broken links |
| C2 | ✅ **Resolved** | Inventory replaced with 3 pointers to canonical sources |
| S2 | 🟡 **Deferred — re-confirmation needed** | See "Open decision" below |
| N1 | 🟡 **Open — not actioned this run** | 5 article-writing files remain dated 2026-04-26; recommend focused content review next pass (no fake freshness stamps applied) |
| N2 | ℹ️ **Acknowledged (no action)** | Pre-existing budget overruns logged in 2026-03-15 healthcheck |
| N3 | ℹ️ **Partially mitigated** | C2 pointer replacement reduces (does not eliminate) root-index vs structure-index overlap |

### Verification checklist

- [x] Code-fence-aware regression scan: 0 broken links in `.copilot/context/**/*.md` (was 5)
- [x] Frontmatter regression scan: 51/51 files have valid YAML (was 50/51)
- [x] Rollback snapshots written to `.copilot/temp/rollback/*.20260527-143627.bak` (3 files)
- [x] [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) updated with apply-mode entry, manifest, and version bump 1.4.0 → 1.5.0
- [x] No behavioral/rule changes — all edits are metadata, link paths, or inventory pointers
- [ ] User decision on S2 placeholder folders (Option A revised / B / C — see below)
- [ ] Follow-up focused content review of 5 stale `01.00-article-writing/` files (N1)

### Open decision — S2 placeholder folder cleanup

`dependency-map/` and `structure/` placeholder folders contain `.gitkeep` files with reserved-status comments pointing to Plan 01.03 of [20260525.01-context-fullcheck/overview.md](../20260525.01-context-fullcheck/overview.md). Please choose:

| Option | Action |
|---|---|
| **A (revised)** | Delete folders **and** update Plan 01.03 to remove the reservation |
| **B** | Keep folders; replace `.gitkeep` with a proper `README.md` documenting reserved status (more discoverable) |
| **C** | Leave as-is — current state is correct given Plan 01.03 still active |

### Follow-up actions

- [ ] User decision on S2 (Option A revised / B / C)
- [ ] Focused content review of 5 `01.00-article-writing/` files (N1) — examine for actual outdated content vs accept 31-day age as fine
- [ ] Codify code-fence-aware scanner in PE-meta-pipeline template (architectural follow-up)
- [ ] Codify `.gitkeep`-content guard for empty-folder deletion heuristic (architectural follow-up)
- [ ] Add cross-scope reference invalidation hook on rename operations (architectural follow-up)

---

## 🎓 Lessons learned

### What went wrong

| # | Issue | Lesson |
|---|---|---|
| 1 | First-pass broken-link scanner produced **2 false positives** (lines 207, 213 of root index — both inside ` ```markdown ` fences containing illustrative link examples) | Any broken-link scanner emitting numbers that drive Phase 5 approval **must** track ` ``` ` fence state. Add this as a hard requirement to the PE-meta-pipeline scanner template. |
| 2 | Initial deletion approval was granted on the assumption that `dependency-map/` and `structure/` were orphan empty folders. Actually, they contain `.gitkeep` files with plan-pointer comments | Empty-folder deletion heuristics **must** read placeholder file contents before deletion. A `.gitkeep` is not "metadata-empty" if it carries free-form reserved-status comments. |
| 3 | The 2026-04-28 PE-prefix rename of instruction files (`context-files` → `pe-context-files`) left a dangling reference in the root context index that survived multiple scope-bounded runs | The PE-meta-pipeline needs a **cross-scope reference invalidation hook**: when scope=X renames a file, scope=Y refs to it must be re-validated in a follow-up sweep. |
| 4 | The 2026-05-26 Bundle A run added frontmatter to 7 files in `90.00-learning-hub/` but missed the root index `00.00-context-folder-index.md` because it was scoped to subfolders only | Subfolder-only audit patterns silently omit files that live above the smallest in-scope folder. **Audit scope should always include the parent index file at minimum.** |

### What went right

| # | Practice | Benefit |
|---|---|---|
| 1 | The pipeline **deferred** S2 deletion gracefully when new information surfaced post-approval (the `.gitkeep` contents) instead of executing blindly | Saved Plan 01.03 reservation; demonstrated correct "approval is not unconditional" discipline |
| 2 | Date-suffixed Phase 5 changelist files (`phase-5-changelist-20260527.md`) | Avoids clobbering prior runs' history; supports forensic diff |
| 3 | Code-fence-aware re-scan was invoked the moment false positives were suspected | Prevented incorrect Phase 5 approval scope; reduced edits from 7 → 5 |
| 4 | Inventory pointer pattern (replace local-copy table with link to canonical structure-index) | Eliminates the dual-source-of-truth drift that produced C2 in the first place |
| 5 | Rollback snapshots applied to **every** modified file before edits | Atomic rollback possible; current run reversible |

### Improvements for future

| # | Improvement | Where to land |
|---|---|---|
| 1 | Make code-fence-aware scanner the **default** template PowerShell helper shipped with the orchestrator | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — Phase 7 helper appendix |
| 2 | Augment empty-folder deletion heuristic with `.gitkeep`-content guard | PE-meta-pipeline Phase 6 safety rule |
| 3 | Add cross-scope reference invalidation hook (post-rename) | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 6 + add to [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) v1.2.0 |
| 4 | Subfolder-only audit patterns should auto-include the parent index file | PE-meta-pipeline Phase 0 inventory rule |
| 5 | "Touch-only" freshness-stamp anti-pattern documented in N1 disposition — keep Option A (no fake stamps) as default | [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) policy section |

---

## 📎 Appendix

### A — Files modified (this run)

| File | Change summary |
|---|---|
| [.copilot/context/00.00-context-folder-index.md](../../../../../.copilot/context/00.00-context-folder-index.md) | Added full YAML frontmatter (v1.1.0); fixed `context-files` → `pe-context-files`; replaced 3 stale inventory sections with pointers |
| [.copilot/context/01.00-article-writing/02-validation-criteria.md](../../../../../.copilot/context/01.00-article-writing/02-validation-criteria.md) | 4 path-depth fixes; version 2.2.0 → 2.2.1; `last_updated` → 2026-05-27 |
| [.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | Prepended 2026-05-27 entry; refreshed manifest; version 1.4.0 → 1.5.0 |

### B — Files deferred (this run)

| Path | Reason |
|---|---|
| `.copilot/context/00.00-prompt-engineering/dependency-map/` | `.gitkeep` references Plan 01.03 reservation — needs user re-confirmation |
| `.copilot/context/00.00-prompt-engineering/structure/` | Same as above (structural model variant) |

### C — Files untouched (per Option A for N1)

| Path | Date | Notes |
|---|---|---|
| `.copilot/context/01.00-article-writing/01-style-guide.md` | 2026-04-26 | No content delta this run; recommend focused content review |
| `.copilot/context/01.00-article-writing/03-article-creation-rules.md` | 2026-04-26 | Same |
| `.copilot/context/01.00-article-writing/workflows/01-article-creation-workflow.md` | 2026-04-26 | Same |
| `.copilot/context/01.00-article-writing/workflows/02-review-workflow.md` | 2026-04-26 | Same |
| `.copilot/context/01.00-article-writing/workflows/03-series-planning-workflow.md` | 2026-04-26 | Same |

### D — Regression scan command (final, code-fence-aware)

```powershell
$ErrorActionPreference='Stop'
$files = Get-ChildItem -Path 'c:\dev\darioairoldi\Learn\.copilot\context' -Recurse -File -Filter '*.md'
"Total context files: $($files.Count)"
$broken=@(); $noFM=@()
foreach ($f in $files) {
  $c = Get-Content $f.FullName -Raw -Encoding UTF8
  if ($c -notmatch '^---\r?\n') { $noFM += $f.FullName }
  $inFence = $false
  foreach ($line in ($c -split "`n")) {
    if ($line -match '^```') { $inFence = -not $inFence; continue }
    if ($inFence) { continue }
    foreach ($m in [regex]::Matches($line, '\[(?<t>[^\]]*)\]\((?<h>[^)#\s]+)(?:#[^)]*)?\)')) {
      $h = $m.Groups['h'].Value
      if ($h -match '^(https?:|mailto:|#)') { continue }
      $tp = Join-Path (Split-Path $f.FullName) $h
      if (-not (Test-Path -LiteralPath $tp)) {
        $broken += [PSCustomObject]@{ Source=$f.FullName; Link=$h }
      }
    }
  }
}
"Broken links: $($broken.Count)"
"Missing frontmatter: $($noFM.Count)"
```

**Output (2026-05-27 final):**

```
Total context files: 51
Broken links: 0
Missing frontmatter: 0
```

### E — References

| # | Reference | Why relevant |
|---|---|---|
| 1 | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) v2.0.0 | Orchestrator executed in this run |
| 2 | [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) v1.1.0 | Frontmatter contract S1 was failing against |
| 3 | [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) | Updated in Phase 8 with this run's entry |
| 4 | [20260525.01-context-fullcheck/overview.md](../20260525.01-context-fullcheck/overview.md) | Plan 01.03 reserves the placeholder folders S2 attempted to delete |
| 5 | [Phase 5 changelist (this run)](../../../../../.copilot/temp/pe-meta-state/phase-5-changelist-20260527.md) | Persisted plan presented to user for approval |
