---
title: "Issue: Severity-Index Parity Gap Surfaced During pe-meta-update Reconcile Run"
author: "Dario Airoldi"
date: "2026-06-06"
categories: [issue, prompt-engineering, pe-meta, reconcile]
description: "Analysis of the /pe-meta-update reconcile run over .github/instructions — two recurring failure modes avoided, one fix applied, and a genuine system gap (D1) surfaced: the instruction-file exemplary-bar severity-index requirement is unsatisfiable for document-governance instruction files without a severity-code registry extension."
draft: true
---

# Issue Report

**Issue Title:** Severity-index parity requirement is unsatisfiable for document-governance instruction files (surfaced during `/pe-meta-update` reconcile)

**Date Reported:** 2026-06-06
**Reporter:** Dario Airoldi
**Status:** Resolved (D1 closed by clarification — Option C; two ancillary fixes applied)

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Implemented](#-solution-implemented)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief Description

During a reconcile re-run of `/pe-meta-update '.github\instructions' --mode apply --deps all`,
the body-level audit surfaced finding **D1**: three document-governance instruction files
(`use-case-documents`, `vision-amendment`, `vision-frontmatter`) lack the **severity index**
that the instruction-file exemplary-bar checklist marks as Required.

On attempting to apply D1 as a "consistency/parity" fix, a deeper issue emerged: the severity
indexes in the 12 sibling PE instruction files **reuse global severity codes** (`[C6]`, `[H8]`, …)
defined in the shared `validation-rules` matrix. The three document-governance files' rules do
**not** map to any existing global code. Satisfying the checklist would therefore require
**inventing new severity-code namespaces** — a registry/convention change, not a mechanical
parity add.

### Severity & Classification

| Field | Value |
|---|---|
| **Severity** | Medium |
| **Type** | PE-system gap (checklist ↔ registry mismatch) |
| **Component** | `.github/instructions/` exemplary-bar checklist + `validation-rules` severity matrix |
| **Surfaced by** | `/pe-meta-update` reconcile run `20260606-instructions-deps` |
| **Framework** | PE meta-system vision v15.4, orchestrator `pe-meta-update.prompt.md` v2.3.2 |

### Impact Points

- The exemplary-bar checklist appears to mandate a severity index for **all** instruction files,
  but the requirement is **unsatisfiable** for document-governance files without first extending
  the global severity-code registry.
- An automated `apply` run that naively "fixes" D1 would **manufacture new severity codes** —
  violating reconcile discipline (do not invent content) and silently expanding the registry.

---

## 🔍 Context Information

### Environment

| Field | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Run id | `20260606-instructions-deps` |
| Invocation | `/pe-meta-update '.github\instructions' --mode apply --deps all` |
| Resolved | `--mode=apply --scope=.github/instructions/ --dim=full --deps=full` |
| Execution mode | **reconcile** (baseline available + fresh research ran) |
| Phase 0b | multi-domain footprint → sequential split selected by user |
| Files in scope | 17 (prompt-engineering ×15, article-writing ×2) |
| Body coverage | 17/17 read |

### Prior-Run Context

This invocation had **previously failed** (documented in repo memory + an open issue) by collapsing
into a shallow frontmatter-only metadata scan and by not materializing an on-disk plan file. Both
recurring failure modes were **avoided** this run via subagent body-level delegation and explicit
plan-file materialization.

### Key Artifacts

- Plan file: [01-instructions-reconcile-review.plan.md](../20260606.02-pe-meta-update/02-instruction-files-changes-deps/01-instructions-reconcile-review.plan.md)
- Checklist source: `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md`
- Severity matrix: shared `validation-rules` matrix (global `[C#]`/`[H#]`/`[M#]` codes)

---

## 🔬 Analysis

### Root Cause

The exemplary-bar checklist for instruction files lists "severity index present" as a Required
item. The 12 conforming PE instruction files satisfy it by **referencing global severity codes**
from a shared registry — they do not own a per-file severity namespace. The three document-governance
files govern **document shape** (filenames, header blockquotes, required sections, frontmatter
blocks), and their `MUST` rules have **no representation** in the global registry.

Therefore the checklist conflates two distinct shapes:

1. **Code-reuse severity index** — references pre-existing global codes (what the 12 files do).
2. **Net-new severity namespace** — would require minting `[C#]`/`[H#]`/`[M#]` codes for rules
   that exist nowhere in the registry (what D1 would force).

The checklist does not distinguish these, so it reads as a universal requirement when it is in
practice only satisfiable by files whose rules already live in the global registry.

### Impact Assessment

| Area | Impact |
|---|---|
| Reconcile integrity | High — a naive apply would manufacture registry content |
| Checklist accuracy | Medium — the Required item is unsatisfiable for a file class |
| Documentation parity | Low — cosmetic inconsistency between file classes |
| Downstream audits | Low — no functional rule is missing; only the index is absent |

### Affected Workflows

- `/pe-meta-update` apply runs that treat "missing severity index" as auto-fixable.
- Future exemplary-bar conformance audits over document-governance instruction files.

---

## 🔄 Reproduction Steps

1. Run `/pe-meta-update '.github\instructions' --mode apply --deps all`.
2. Allow the body-level audit to read all 17 instruction-file bodies.
3. Observe finding D1: three files lack a severity index.
4. Attempt to author a severity index for `use-case-documents.instructions.md` (or the other two).
5. Cross-reference an existing severity index (e.g. in a conforming PE instruction file) and note
   it uses global codes like `[C6]`, `[H8]`.
6. Confirm none of the document-governance files' `MUST` rules map to an existing global code →
   authoring an index requires **new** codes.

### Affected Code Locations

- `.github/instructions/use-case-documents.instructions.md`
- `.github/instructions/vision-amendment.instructions.md`
- `.github/instructions/vision-frontmatter.instructions.md`
- `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md` (the requirement source)

---

## ✅ Solution Implemented

### What Was Applied This Run

| # | File | Change | Status |
|---|---|---|---|
| 1 | `article-writing.instructions.md` | Removed stale bottom `article_metadata` HTML comment (`version: "2.2"`, `last_updated: "2026-03-01"`) contradicting authoritative top YAML; no version bump needed | ✅ done |
| 2 | `pe-common.instructions.md` | Added `goal:` + two `rationales:` frontmatter fields (exemplary-bar metadata); bumped `1.8.0 → 1.8.1` | ✅ done |

### What Was Deliberately NOT Applied (D1)

The severity-index addition was **held** and reclassified from "low-value additive" to
**"not auto-applicable"** because applying it would manufacture new severity-code namespaces —
out of scope for a reconcile `apply`.

### Proposed Resolution Paths for D1 (requires explicit decision)

- **Option A — Registry extension:** Add document-governance severity codes to the global
  `validation-rules` matrix, then have the three files reference them (parity with the 12 siblings).
- **Option B — Local namespaces by convention:** Allow document-governance instruction files to
  declare file-local severity codes, and amend the checklist to permit this shape.
- **Option C — Checklist scoping:** Narrow the exemplary-bar "severity index Required" item so it
  applies only to files whose rules map to the global registry; mark it N/A for document-governance
  files.

### D1 Resolution — Option C applied (✅ done)

Deeper investigation reframed the choice. A severity index is a **validator-facing projection of
the global `validation-rules` matrix** onto the artifact type an instruction file governs (its
entries reference global `[C#]`/`[H#]`/`[M#]` codes). It is meaningful only for instruction files
governing **PE artifacts** a validator runs the matrix against. The three files govern
**user-content documents** (use-case/vision docs) that **no validator** projects the matrix onto —
so a severity index is **N/A**, not missing. **D1 is not a defect.**

- **Option A rejected:** the global matrix is a *generic cross-artifact* index loaded by all 7
  validators + meta-validator and token-budgeted (≤2,500); single-file-class document-shape rules
  bloat a shared artifact and break its single-source-of-truth boundary.
- **Option B rejected:** a severity index is a projection of the *global* matrix, not a list of a
  file's own rules; a local index would project 2–3 barely-applicable codes or manufacture new ones.
- **Option C applied:** added a scope note to the `Severity index present` row in
  [05.08-pe-meta-type-checklists.md](../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md)
  clarifying applicability; bumped `1.0.3 → 1.0.4`. No severity codes manufactured.

---

## 📚 Additional Information

### Testing / Validation Recommendations

- `get_errors` on every edited instruction file (done for the two applied fixes → 0 errors).
- If D1 Option A/B is chosen, run a registry-consistency check so every referenced code resolves.

### Migration Considerations

- Any registry extension (Option A) must be additive and must not renumber existing global codes.

### Performance Impact

- None — these are documentation/governance artifacts.

---

## ✔️ Resolution Status

**Current Status:** Resolved (D1 closed by clarification — Option C; two ancillary fixes applied)

### Verification Checklist

- [x] All 17 instruction-file bodies read (17/17 coverage).
- [x] Subagent false positive (R1: `pe-templates`/`pe-skills` overlap) verified and dropped.
- [x] Parked legacy-metadata fix applied + validated (`article-writing`).
- [x] D3 (`pe-common` metadata) applied + validated.
- [x] On-disk plan file materialized.
- [x] D1 resolution path (C) chosen and executed (`05.08` scope note, `1.0.3 → 1.0.4`).

### Follow-up Actions

- [x] Decide D1 resolution (chose Option C — checklist scoping).
- [x] Update `05.08-pe-meta-type-checklists.md` to disambiguate the requirement.
- [ ] (Optional) Re-run conformance audit over the three document-governance files to confirm no
      severity-index flag recurs.

---

## 🎓 Lessons Learned

### What Went Right

- Both documented recurring failure modes (shallow scan, missing plan file) were avoided.
- Reconcile discipline held: only high-confidence additive changes applied; D1 was not
  force-fitted despite appearing in the checklist.
- A false positive was caught by verifying glob-overlap claims against real files.

### What Went Wrong / Risk Identified

- The exemplary-bar checklist's "severity index Required" item is **ambiguous** — it does not
  distinguish code-reuse indexes from net-new namespaces, making it read as universally required
  when it is not universally satisfiable.

### Improvements for the Future

- Treat "add severity index" as auto-applicable **only** when the file's rules already map to the
  global registry; otherwise surface as a decision, never an auto-fix.
- Consider annotating checklist items with an applicability condition (e.g. "Required when rules
  map to the global severity registry").

---

## 📎 Appendix

### Run Findings Summary

| # | Finding | Disposition |
|---|---|---|
| 1 | `article-writing` stale bottom metadata | ✅ Applied |
| 2 (was D3) | `pe-common` missing `goal:`/`rationales:` | ✅ Applied |
| R1 | `pe-templates`/`pe-skills` applyTo overlap | ❌ False positive — dropped |
| D1 | Three files lack severity index | ✅ Resolved by clarification (Option C); not a defect |
| D2 | Behavioral phrasing in instruction files | ✅ Applied to `pe-agents` + `pe-prompts`; `pe-templates` part = false positive |
| D4 | Four files over ≤1,500-token budget | ✅ Accepted as documented exception; `article-writing` flagged for a future externalization spike |

### References

- **📘** [01-instructions-reconcile-review.plan.md](../20260606.02-pe-meta-update/02-instruction-files-changes-deps/01-instructions-reconcile-review.plan.md) — reconcile run plan/baseline
- **📒** `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md` — exemplary-bar checklist (requirement source)
- **📘** `.github/instructions/use-case-documents.instructions.md` — D1 target
- **📘** `.github/instructions/vision-amendment.instructions.md` — D1 target
- **📘** `.github/instructions/vision-frontmatter.instructions.md` — D1 target
