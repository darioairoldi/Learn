---
description: Domain-1 (prompt-engineering) instruction-set review under hardened pe-meta-update v2.4.0 — findings, applied fixes, and resolved applyTo-overlap proposal
status: done
version: "1.1.0"
last_updated: "2026-06-06"
domain: "prompt-engineering"
---

# Domain-1 Instruction-Set Review — prompt-engineering (F6 execution)

> **Most recent changes (v1.1.0, 2026-06-06).** Parked [H10] applyTo-overlap proposal
> resolved — `pe-instruction-files.instructions.md` bumped to v1.9.0 to recognize two
> Permitted Overlap shapes (shared-baseline + coordinated orthogonal pair). v1.0.0: first
> real per-domain pass under the hardened orchestrator (v2.4.0); all 15 bodies read
> (Phase 4 coverage 15/15); 6 low-risk defects fixed across 4 files.

## 🎯 Objective

Run the genuine per-artifact instruction-set review that the original shallow run skipped —
domain `prompt-engineering`, 15 files, `--mode apply`, full Phase-4 body coverage.

## 📋 Run footprint

| Field | Value |
|---|---|
| Run id | `20260606-instructions-d1` |
| Domain | prompt-engineering |
| Files in scope | 15 |
| research | ran |
| phase4-coverage | 15/15 |
| dims-exercised | full |
| Outcomes log | `.copilot/temp/pe-meta-state/outcomes/20260606-instructions-d1.jsonl` |

## 🔎 Findings

### Applied — low-risk, high-confidence (autonomous under `--mode apply`)

1. [H12] Broken context cross-links missing `../../` prefix. (✅ done)
   - `pe-prompts.instructions.md` lines 56, 57, 80 — fixed to `../../.copilot/context/...`
   - `pe-skills.instructions.md` line 97 — fixed
   - `pe-templates.instructions.md` line 105 — fixed
   - Verified all link targets exist at `.copilot/context/00.00-prompt-engineering/`.
2. Encoding corruption — `use-case-documents.instructions.md` line 91 carried a U+FFFD
   replacement character (`## � Dimensions covered`) instead of `📐`. (✅ done)
3. Version bumps on the 4 edited files: pe-prompts `1.6.1`, pe-skills `1.6.1`,
   pe-templates `1.6.1`, use-case-documents `1.2.1`. (✅ done)

### Clean — no defects

`pe-agents`, `pe-common`, `pe-context-files`, `pe-copilot-instructions-file`, `pe-hooks`,
`pe-instruction-files`, `pe-prompt-snippets`, `plan-execution`, `plan-marking`,
`vision-amendment`, `vision-frontmatter` — valid YAML, imperative language, within token
budget, required sections present, reference style consistent (code-span / `📘` refs resolve).

## 📌 Park lot — proposal awaiting decision

- [H10] `*plan*` applyTo overlap. `plan-execution.instructions.md` and
  `plan-marking.instructions.md` both fire on `*plan*`; `vision-amendment.instructions.md`
  (`*vision*plan*.md`) is a documented narrower override. The prior [H10] wording blessed
  only ONE overlap shape (single shared-baseline, `pe-common`), so this coordinated
  orthogonal pair (format vs behavior, precedence explicit in both files) tripped the rule
  on a literal read. **Resolved:** `pe-instruction-files.instructions.md` bumped to v1.9.0 —
  [H10] now recognizes two Permitted Overlap shapes (shared-baseline OR explicitly-coordinated
  orthogonal pair). The plan-execution / plan-marking / vision-amendment trio is a conformant
  Shape 2 pair-with-narrower-override; no file edits needed. (✅ done)

## 🧪 Regression

- All 4 edited files: `get_errors` → 0 markdown errors. (✅ done)

## Exit criteria

- All 15 Domain-1 bodies read; Phase-4 coverage 15/15. (✅ done)
- Low-risk defects fixed and validated. (✅ done)
- [H10] overlap surfaced to park lot, not silently applied. (✅ done)
- Domain-2 (article-writing, 2 files) pending as a separate pass. (📌 next steps)
