---
description: Domain-2 (article-writing) instruction-set review under hardened pe-meta-update v2.4.0 — findings, applied fixes, and stale-metadata proposal
status: done
version: "1.0.0"
last_updated: "2026-06-06"
domain: "article-writing"
---

# Domain-2 Instruction-Set Review — article-writing (F6 execution)

> **Most recent changes (v1.0.0, 2026-06-06).** Second per-domain pass under the hardened
> orchestrator (v2.4.0). Both article-writing instruction-file bodies read (Phase 4 coverage
> 2/2); 1 low-risk defect fixed; one stale-bottom-metadata smell parked as a proposal.

## 🎯 Objective

Run the genuine per-artifact instruction-set review for domain `article-writing` —
2 files, `--mode apply`, full Phase-4 body coverage.

## 📋 Run footprint

| Field | Value |
|---|---|
| Run id | `20260606-instructions-d2` |
| Domain | article-writing |
| Files in scope | 2 |
| research | ran |
| phase4-coverage | 2/2 |
| dims-exercised | full |
| Outcomes log | `.copilot/temp/pe-meta-state/outcomes/20260606-instructions-d2.jsonl` |

## 🔎 Findings

### Applied — low-risk, high-confidence (autonomous under `--mode apply`)

1. [H12] Stale `Related Instruction Files` references in `documentation.instructions.md`. (✅ done)
   - `prompts.instructions.md` → `pe-prompts.instructions.md`
   - `agents.instructions.md` → `pe-agents.instructions.md`
   - `context-files.instructions.md` → `pe-context-files.instructions.md`
   - `skills.instructions.md` → `pe-skills.instructions.md`
   - Verified the 4 old-named files do NOT exist (renamed with `pe-` prefix).
2. Version bump: `documentation.instructions.md` `1.10.0` → `1.10.1`. (✅ done)

### Clean — schema-compliant

Both files carry all 6 required YAML fields (description, applyTo, version, last_updated,
domain, context_dependencies), use imperative language, present required sections, and keep
context references as code-spans that resolve.

## 📌 Park lot — proposal awaiting decision

- MEDIUM — `article-writing.instructions.md` carries a legacy bottom `article_metadata`
  HTML comment (`version: "2.2"`, `last_updated: "2026-03-01"`) that contradicts the
  authoritative top YAML (`version: "1.4.0"`, `last_updated: "2026-06-06"`). Instruction files
  use top-YAML-only versioning (per `pe-instruction-files.instructions.md`); the bottom block
  is leftover from when this file followed article (dual-metadata) conventions. (🟡 todo —
  remove the legacy block OR reconcile it to mirror the top YAML.) → defer

## 🧪 Regression

- `documentation.instructions.md`: `get_errors` → 0 markdown errors. (✅ done)

## Exit criteria

- Both Domain-2 bodies read; Phase-4 coverage 2/2. (✅ done)
- Low-risk defect fixed and validated. (✅ done)
- Stale-metadata smell surfaced to park lot, not silently changed. (✅ done)
