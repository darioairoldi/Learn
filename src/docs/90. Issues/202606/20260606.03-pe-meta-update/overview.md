# ISSUE: Severity-index exemplary-bar requirement is unsatisfiable for document-governance instruction files - 20260606

Date: **06 Jun 2026**<br>
Author: **Dario Airoldi**
Status: **Resolved** (D1 closed by clarification — Option C)

## Table of Contents

- [📝 DESCRIPTION](#-description)
- [ℹ️ CONTEXT INFORMATION / REPRO STEPS](#ℹ️-context-information--repro-steps)
- [🔍 ANALYSIS](#-analysis)
- [🛠️ RESOLUTION](#️-resolution)
- [➕ ADDITIONAL INFORMATION](#-additional-information)
- [📚 REFERENCES](#-references)

## 📝 DESCRIPTION

A reconcile re-run of `/pe-meta-update '.github\instructions' --mode apply --deps all` surfaced finding **D1**: three document-governance instruction files (`use-case-documents`, `vision-amendment`, `vision-frontmatter`) lack the **severity index** that the instruction-file exemplary-bar checklist marks as Required.

On attempting to apply D1 as a "parity" fix, a deeper issue emerged: the 12 conforming PE instruction files satisfy the requirement by **reusing global severity codes** (`[C6]`, `[H8]`, …) from the shared `validation-rules` matrix. The three document-governance files' `MUST` rules map to **no existing global code**.

Further investigation clarified the root cause: a severity index is a **validator-facing projection of the global matrix** onto the artifact type an instruction file governs. It is meaningful only for instruction files governing **PE artifacts** that a PE validator runs the matrix against. The three files govern **user-content documents** (use-case and vision docs under `06.00-idea/`) that **no validator** projects the matrix onto — so a severity index is **N/A** for them, not missing. **D1 is therefore not a defect**; the checklist simply did not distinguish PE-artifact-governance from user-content-governance instruction files.

> **Full analysis:** [01-pe-meta-update-reconcile-issue-analysis.md](01-pe-meta-update-reconcile-issue-analysis.md)

## ℹ️ CONTEXT INFORMATION / REPRO STEPS

| Field | Value |
|---|---|
| **Invoked command** | `/pe-meta-update '.github\instructions' --mode apply --deps all` |
| **Resolved** | `--mode=apply --scope=.github/instructions/ --dim=full --deps=full` |
| **Execution mode** | reconcile (baseline available + fresh research ran) |
| **Run id** | `20260606-instructions-deps` |
| **Files in scope** | 17 (prompt-engineering ×15, article-writing ×2); 17/17 bodies read |
| **Requirement source** | `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md` |
| **Severity matrix** | shared `validation-rules` global `[C#]`/`[H#]`/`[M#]` codes |
| **Governing vision** | PE meta-system vision v15.4, orchestrator `pe-meta-update.prompt.md` v2.3.2 |

**To reproduce:**

1. Run `/pe-meta-update '.github\instructions' --mode apply --deps all`.
2. Allow the body-level audit to read all 17 instruction-file bodies.
3. Observe finding D1: three files lack a severity index.
4. Attempt to author an index for one of them and cross-reference a conforming sibling.
5. Confirm the sibling's index uses global codes (`[C6]`, `[H8]`) and that none of the document-governance files' rules map to an existing global code → authoring requires **new** codes.

## 🔍 ANALYSIS

### Root cause

The exemplary-bar checklist lists "severity index present" as Required but does not distinguish:

1. **Code-reuse severity index** — references pre-existing global codes (what the 12 conforming files do).
2. **Net-new severity namespace** — mints `[C#]`/`[H#]`/`[M#]` codes for rules absent from the registry (what D1 would force).

Document-governance files govern document *shape* (filenames, header blockquotes, required sections, frontmatter blocks); their `MUST` rules have no representation in the global registry, so only shape #2 could satisfy the checklist — which an automated `apply` must not do.

### Why it matters

| Concern | Impact |
|---|---|
| **Reconcile integrity** | A naive apply would manufacture registry content, violating "do not invent content." |
| **Checklist accuracy** | A Required item is unsatisfiable for an entire file class. |
| **Documentation parity** | Cosmetic inconsistency between file classes (low functional impact). |

### Execution-mode note

The run was **reconcile** (two `status: done` baselines from earlier 2026-06-06 plus a fresh subagent body audit). Both previously-recorded failure modes — shallow metadata-only scan and missing on-disk plan file — were **avoided** this run.

## 🛠️ RESOLUTION

### Applied this run (✅ done)

| # | File | Change |
|---|---|---|
| 1 | `article-writing.instructions.md` | Removed stale bottom `article_metadata` HTML comment contradicting authoritative top YAML; no version bump needed. |
| 2 | `pe-common.instructions.md` | Added `goal:` + two `rationales:` frontmatter fields; bumped `1.8.0 → 1.8.1`. |

Both validated via `get_errors` → 0 errors.

### Held — D1 (✅ resolved by clarification — Option C)

Investigation established that a severity index is a **validator-facing projection of the global matrix**, meaningful only for instruction files governing PE artifacts a validator runs the matrix against. The three files govern user-content documents no validator projects the matrix onto, so a severity index is **N/A** — D1 is not a real defect.

**Applied (Option C):** added a scope note to the `Severity index present` row in [05.08-pe-meta-type-checklists.md](../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md) clarifying the check applies only to PE-artifact-governance instruction files and is N/A for document-governance files; bumped `1.0.3 → 1.0.4`. No severity codes manufactured; no global-matrix change.

Rejected alternatives:

- **Option A (extend global matrix):** the matrix is a *generic cross-artifact* index loaded by all 7 validators + meta-validator and is token-budgeted (≤2,500); injecting single-file-class document-shape rules bloats a shared artifact and breaks its single-source-of-truth boundary.
- **Option B (file-local severity index):** a severity index here is a projection of the *global* matrix, not a list of a file's own rules; a local index would either project 2–3 barely-applicable codes or manufacture new codes.

### Other deferred findings

- **R1** (`pe-templates`/`pe-skills` applyTo overlap) — ❌ false positive, verified and dropped (no `skill-*.md` files exist).
- **D2** (non-mechanical process phrasing) — ✅ **applied**: removed the two lines from `pe-agents` and `pe-prompts` (the "test" half survives as existing Quality Checklist items); bumped `pe-agents 1.11.0→1.11.1`, `pe-prompts 1.6.1→1.6.2`. The `pe-templates` part was a **false positive** (its Rules are all mechanical `MUST`).
- **D4** (four files over the ≤1,500-token budget) — ✅ **accepted as documented exception**: the ceiling genuinely applies to all `.github/instructions/` files (no clarification escape), but splitting four files is a risky multi-file refactor needing its own plan. Two narrow-applyTo schema files (`vision-frontmatter`, `use-case-documents`) have contained injection cost; the two broad-applyTo files (`article-writing` ~5k, `documentation`) inject on every `*.md` task — `article-writing` recommended as a future dedicated externalization spike.

## ➕ ADDITIONAL INFORMATION

- Reconcile discipline held: only high-confidence additive changes applied; D1 was not force-fitted despite appearing in the checklist.
- Two subagent claims (R1, and the `pe-templates` part of D2) were **false positives**, caught by reading the actual file bodies rather than trusting the audit summary.
- Recommended future behavior: treat "add severity index" as auto-applicable **only** when the file's rules already map to the global registry; otherwise surface as a decision, never an auto-fix.

## 📚 REFERENCES

- **📘** [01-pe-meta-update-reconcile-issue-analysis.md](01-pe-meta-update-reconcile-issue-analysis.md) — full issue analysis
- **📘** [01-instructions-reconcile-review.plan.md](../20260606.02-pe-meta-update/02-instruction-files-changes-deps/01-instructions-reconcile-review.plan.md) — reconcile run plan/baseline
- **📒** `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md` — exemplary-bar checklist (requirement source)
- **📘** `.github/instructions/use-case-documents.instructions.md` — D1 target
- **📘** `.github/instructions/vision-amendment.instructions.md` — D1 target
- **📘** `.github/instructions/vision-frontmatter.instructions.md` — D1 target
