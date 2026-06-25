---
status: done
target_vision_version: "15.4"
domain: "prompt-engineering"
created: "2026-06-06"
goal: "Resolve the full-sweep structure + consistency + clarity findings surfaced by the --mode apply review of the prompt-engineering context file set, materialized as the on-disk pivot artifact the vision § Plan output contract requires."
---

# Plan — `--dim full` apply review of `.copilot/context/00.00-prompt-engineering/`

> `Resolved invocation: --mode=apply --scope=.copilot/context/00.00-prompt-engineering/ --source= --dim=full --start=none --end=none --deps=none --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260605.02-pe-meta-update/01-pe-meta-update-context-full.plan.md | spillover=none | bundle=single-domain`

> **Provenance note.** This plan file was materialized **retroactively** on 2026-06-06 to close a vision § Plan output contract gap: the originating `--mode apply` run executed its changes directly from an in-conversation plan and emitted `plan-file=none`, skipping the on-disk pivot artifact the contract requires on **every** mutating run. The changes below were already applied and regression-passed before this file was written; it is recorded `status: done` to serve as the durable, version-controlled audit artifact the contract mandates. The fresh/reconcile/trust execution-mode that ran was effectively **fresh** (no baseline, audits ran) — the defect was the missing plan-file write, not the execution path.

## Goal

Close the structure (orphaned category mapping), consistency (dead cross-reference), and clarity (overlapping scenario terms) findings across the 38 prompt-engineering context files, **without removing any capability** — every fix extends, repoints, or disambiguates an existing rule.

This is **not** a vision-amendment plan: no item changes a vision principle. All items land in context files only.

## Scope

- **In scope:** the 38 `.md` files under `.copilot/context/00.00-prompt-engineering/` (single declared domain `prompt-engineering` → `bundle=single-domain`).
- **Dimensions exercised:** structure (Phase 1.5/2), consistency (Phase 3 — coherence/references), content/strategic/freshness/optimize lenses (Phase 4). The `--dim quality` group (D6–D11) was applied 2026-06-03 and was re-verified here as still-fixed (no regressions).
- **Out of scope:** vision documents, non-context artifact types (including the `pe-meta-update.prompt.md` defect noted in the park lot), the standalone `optimize`/`freshness` deep passes (deferred — see park lot).

## Health score

`100 − (CRITICAL·25 + HIGH·10 + MEDIUM·3 + LOW·1)` = `100 − (0·25 + 2·10 + 3·3 + 2·1)` = **69 / 100** (plan) → **89 / 100** after the 3 net fixes landed (residual: 2 deferred LOW).

| Severity | Count |
|---|---|
| CRITICAL | 0 |
| HIGH | 2 |
| MEDIUM | 3 |
| LOW | 2 |

## Goal table (validated findings → downstream landing) (✅ done)

> **Applied 2026-06-06** (`--mode apply`): 3 of 7 rows landed an edit; F4 and F5 closed as verified no-ops; F6 and F7 deferred. See the apply-mode entry in `05.04-meta-review-log.md` (`full-apply-20260606`).

Each actionable row is one editable artifact + one verifiable change with an execution-ready `old → new` anchor.

| # | Phase/Dim | Sev | Finding | Downstream landing | Scope tag | Status |
|---|---|---|---|---|---|---|
| C1 | P3 / D6 cross-ref | HIGH | Dead link: [00.03-metadata-contracts.md](../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md#L212) References block points to `20260523.01-vision.v13.md`, which does not exist (only `20260531.01-vision.md` does) | `00.03-metadata-contracts.md` — repoint `📖 …v13.md` → `…v15.md` | in-scope | (✅ done) |
| C2 | P1.5/P2 / structure | HIGH | Orphaned category: `04.02-adaptive-validation-patterns.md` (v2.1.1, 5 consumers) is absent from the category catalog and `required_categories` contract, violating "MUST maintain all required categories with at least one mapped file" | `00.04-context-category-catalog.md` + `00.00-context-structure-index.md` — add `adaptive-validation` category mapping `04.02` | in-scope | (✅ done) |
| F3 | P4 / D9 clarity | MEDIUM | Glossary defines `Use case challenge` (3–5/artifact) but not the sibling concepts `Role validation` (3–7/agent) and embedded `Test scenarios` (prompts 3–5 / agents 3) that coexist in `01.06`/`04.03`/`01.07`, leaving the three counts conflatable | `01.05-glossary.md` — add two canonical disambiguating entries | in-scope | (✅ done) |
| F4 | P3 / D7 redundancy | MEDIUM | Template-externalization ">10 lines → externalize" rule restated in `01.01` (Principle 8), `04.03` (§6), `01.06` (parameter) | — | in-scope | (✅ closed — no-op: intentional layering; `04.03` already 📖-refs `01.01`; `01.06` is the quantitative-parameter home) |
| F5 | P4 / D35 portability | MEDIUM | Alleged "reference vision by folder, not versioned filename" boundary would make `04.05` L228's versioned vision link non-compliant | — | in-scope | (✅ closed — no-op: no such boundary exists in `04.05`; link is valid → false positive) |
| F6 | P4 / optimize | LOW | Token-budget overflow candidates `02.04`, `01.02`, `03.04` (largest files; potential split/externalize targets) | (deferred) | in-scope | (📌 next steps — dedicated `--dim optimize` run) |
| F7 | P4 / freshness | LOW | Date-only staleness signal on `05.03`, `00.04`, `02.03` (`last_updated` 2026-05-25/26) with no concrete stale content found | (deferred) | in-scope | (📌 next steps — light refresh if a future platform delta touches them) |

## Recommended execution order (✅ done)

Risk-ordered per the orchestrator contract.

1. **Non-regressive, deterministic (autonomous-eligible in principle; gated here because context files are never blind-applied):** C1 (dead-link repoint), C2 (additive category mapping). (✅ done)
2. **Clarity addition (additive, low risk):** F3 (glossary entries). (✅ done)
3. **Verified no-ops (no edit):** F4, F5. (✅ done)
4. **Deferred (separate runs):** F6 (`--dim optimize`), F7 (freshness). (📌 next steps)

## Verification (Phase 7 regression) (✅ done)

- New vision link resolves — `20260531.01-vision.md` exists. (✅ done)
- Builder/validator + category symmetry restored for `04.02` (catalog + index both updated). (✅ done)
- No new contradictions introduced; quality fixes Q1–Q15 (2026-06-03) re-verified intact. (✅ done)
- 0 markdown errors across the 4 modified files. (✅ done)
- Versions bumped + `last_updated` → 2026-06-06 on `00.00`, `00.03`, `00.04`, `01.05`. (✅ done)

## Park lot (surfaced edge cases — do not block this plan)

- **Prompt defect (separate artifact type, out of this scope):** [pe-meta-update.prompt.md](../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 8 first-line-log instruction still carries stale v15.1 wording ("`plan-file=<path>` is emitted whenever `--mode=plan`"), which contradicts v15.4's "materializes the plan on every run" in the same file's `--mode apply` row and `scope.covers`. This stale clause is the root cause of the missing-plan-file gap this very plan back-fills. Recommended follow-up: `/pe-meta-update --mode apply --scope .github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` (or `/pe-meta-prompt-review`) to align the Phase 8 log contract with v15.4 so `plan-file=<path>` is emitted on apply runs too. (🟡 todo)

## Exit criteria

- All actionable rows (C1, C2, F3) applied and regression-passed. (✅ done)
- No-op rows (F4, F5) documented with rationale. (✅ done)
- Run logged in `05.04-meta-review-log.md` as `full-apply-20260606`. (✅ done)
- On-disk plan artifact materialized in the run folder (this file), closing the vision § Plan output contract gap. (✅ done)
- Deferred rows (F6, F7) carried forward as `📌 next steps` for dedicated runs. (📌 next steps)
