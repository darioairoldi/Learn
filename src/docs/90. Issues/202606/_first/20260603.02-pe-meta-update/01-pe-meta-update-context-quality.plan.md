---
status: done
target_vision_version: "15.3"
domain: "prompt-engineering"
created: "2026-06-03"
goal: "Resolve the quality-dimension (D6/D7/D8/D9/D10/D11) findings surfaced by the plan-mode review of the prompt-engineering context file set so each rule is contradiction-free, single-sourced, unambiguous, complete, and verifiable."
---

# Plan — `--dim quality` review of `.copilot/context/00.00-prompt-engineering/`

> `Resolved invocation: --mode=plan --scope=.copilot/context/00.00-prompt-engineering/ --source= --dim=quality --start=none --end=none --deps=none --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260603.02-pe-meta-update/01-pe-meta-update-context-quality.plan.md | spillover=none | bundle=single-domain`

## Goal

Close the consistency (D6), non-redundancy (D7), prioritization (D8), clarity (D9), completeness (D10), and actionability (D11) gaps found across the 38 prompt-engineering context files, **without removing any capability** — every fix extends, deduplicates, or disambiguates an existing rule.

This is **not** a vision-amendment plan: no item changes a vision principle. All items land in context files only.

## Scope

- **In scope:** the 38 `.md` files under `.copilot/context/00.00-prompt-engineering/` (single declared domain `prompt-engineering` → `bundle=single-domain`).
- **Dimensions exercised:** D6-consistency, D7-non-redundancy, D8-prioritization, D9-clarity, D10-completeness, D11-actionability (the `--dim quality` group; D27-model-adherence is N/A to context files per the applicability matrix).
- **Out of scope:** vision documents, non-context artifact types, the `optimize`/`freshness`/`reliability` dimension groups.

## Health score

`100 − (CRITICAL·25 + HIGH·10 + MEDIUM·3 + LOW·1)` = `100 − (0·25 + 3·10 + 7·3 + 5·1)` = **44 / 100**

| Severity | Count |
|---|---|
| CRITICAL | 0 |
| HIGH | 3 |
| MEDIUM | 7 |
| LOW | 5 |

The score reflects the **number of open quality refinements** in a mature, actively-maintained set — not a structural failure. No capability chains are broken.

## Goal table (validated findings → downstream landing) (✅ done)

> **Applied 2026-06-03** (`--mode apply`): 13 of 15 rows landed an edit; Q11 closed as no-op (already single-sourced in `01.06`); Q15 resolved transitively by the Q6 deduplication. See the apply-mode entry in `05.04-meta-review-log.md` (`quality-apply-20260603`).

Each row is one editable artifact + one verifiable change. Severities are calibrated by the orchestrator (the research lenses' raw CRITICAL ratings were down-graded where the issue is a completeness/clarity refinement rather than an active contradiction).

| # | Dim | Sev | Finding | Downstream landing | Scope tag |
|---|---|---|---|---|---|
| Q1 | D6 | HIGH | Test-scenario count contradicts: [02.04-agent-shared-patterns.md](../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md#L213) says "3–5 scenarios per agent" while canonical rule H6 in [01.07-critical-rules-priority-matrix.md](../../../../.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md#L62) and [04.03-production-readiness-patterns.md](../../../../.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md#L99) say "3 per agent" | `02.04-agent-shared-patterns.md` | in-scope (✅ done) |
| Q2 | D10 | HIGH | Empty contract: the **Validation Contract** table in [00.01-governance-and-capability-baseline.md](../../../../.copilot/context/00.00-prompt-engineering/00.01-governance-and-capability-baseline.md#L76) is a header with no rows, yet meta-ops are told to "verify against this document at these checkpoints" (content exists further down under § How to Use This Baseline) | `00.01-governance-and-capability-baseline.md` | in-scope (✅ done) |
| Q3 | D7 | HIGH | Provider-caching table duplicated in [01.06-system-parameters.md](../../../../.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md) and [02.02-context-window-and-token-optimization.md](../../../../.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md); 01.06 is the declared single source of truth for quantitative thresholds | `02.02-context-window-and-token-optimization.md` (replace table with 📖 ref) | in-scope (✅ done) |
| Q4 | D9 | MEDIUM | ISO-8601 vs UTC-only contradiction in [04.01-validation-caching-pattern.md](../../../../.copilot/context/00.00-prompt-engineering/04.01-validation-caching-pattern.md#L72): an offset timestamp is marked "Bad (use UTC)" while the format is described as "ISO 8601", which permits offsets | `04.01-validation-caching-pattern.md` | in-scope (✅ done) |
| Q5 | D9 | MEDIUM | Domain-field "open question / `additional_domains`" note in [00.03-metadata-contracts.md](../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md#L61) leaves authors unable to tell whether list-valued domains are supported now or a future feature | `00.03-metadata-contracts.md` | in-scope (✅ done) |
| Q6 | D7 | MEDIUM | Phase-budget table duplicated in 01.06 and 02.02, with label drift ("Architecture/Design" vs "Architecture") and slightly different action text | `02.02-context-window-and-token-optimization.md` (ref to 01.06) + label fix | in-scope (✅ done) |
| Q7 | D9 | MEDIUM | Combined-context-budget worked examples in [01.06-system-parameters.md](../../../../.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md) (~10,200 "Warning") don't line up with the threshold table directly below ("< 10,000 = Optimal"), so a ~10,100-token case is unclassifiable | `01.06-system-parameters.md` | in-scope (✅ done) |
| Q8 | D8 | MEDIUM | No precedence stated when an artifact matches multiple budget categories (artifact-type budget in 01.06/C3 vs phase budget in 02.02); add a precedence row to the priority matrix | `01.07-critical-rules-priority-matrix.md` | in-scope (✅ done) |
| Q9 | D11 | MEDIUM | Role-validation tests in [04.02-adaptive-validation-patterns.md](../../../../.copilot/context/00.00-prompt-engineering/04.02-adaptive-validation-patterns.md#L104) (Authority/Expertise/Specificity…) are stated as reviewer questions, not boolean PASS/FAIL checks | `04.02-adaptive-validation-patterns.md` | in-scope (✅ done) |
| Q10 | D10 | MEDIUM | Deterministic freshness check in [05.01-artifact-dependency-map.md](../../../../.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md#L45) records `broken_local_links` / `missing_files` / `checked_files` with no pass/fail acceptance criteria | `05.01-artifact-dependency-map.md` | in-scope (✅ done) |
| Q11 | D7 | LOW | Token-to-line conversion heuristic stated as both "~6.67" and "6–8 lines" across 01.06 / 01.03 / 02.02; pick one and reference the canonical Conversion Reference | `01.06-system-parameters.md` (canonical) + refs | in-scope (✅ closed — no-op, already single-sourced in 01.06) |
| Q12 | D11 | LOW | Handoff validation-loop in [02.01-handoffs-pattern.md](../../../../.copilot/context/00.00-prompt-engineering/02.01-handoffs-pattern.md#L87) says "after 3 rounds STOP" without defining what STOP does operationally (abort / proceed-with-issues / escalate) | `02.01-handoffs-pattern.md` | in-scope (✅ done) |
| Q13 | D9 | LOW | Skill-file vs context-file glossary entries in [01.05-glossary.md](../../../../.copilot/context/00.00-prompt-engineering/01.05-glossary.md#L68) are too similar to support a "which should I create?" decision | `01.05-glossary.md` | in-scope (✅ done) |
| Q14 | D11 | LOW | Tool-failure recovery in [04.03-production-readiness-patterns.md](../../../../.copilot/context/00.00-prompt-engineering/04.03-production-readiness-patterns.md#L80) says "retry once with adjusted parameters" without defining "adjusted" per error class | `04.03-production-readiness-patterns.md` | in-scope (✅ done) |
| Q15 | D6 | LOW | Phase-name label drift "Architecture/Design" vs "Architecture" between 01.06 and 02.02 (consequence of Q6; track separately so the rename is verified on both sides) | `01.06` + `02.02` | in-scope (✅ closed — resolved transitively by Q6) |

## Recommended execution order (for a follow-up `--mode apply` run) (✅ done)

Risk-ordered per the orchestrator contract — deduplications and label fixes are non-regressive and can go first; contract/precedence additions need review.

1. **Non-regressive, deterministic (autonomous-eligible):** Q3, Q6, Q11, Q15 (table de-duplication + label/heuristic normalization — verify no rule text is lost). (✅ done)
2. **Contradiction/completeness fixes (review recommended):** Q1, Q2, Q4, Q7. (✅ done)
3. **Clarity/actionability rewrites (review required — wording is judgement-bearing):** Q5, Q9, Q10, Q12, Q13, Q14. (✅ done)
4. **New precedence rule (Ask First — touches the priority matrix, high dependent count):** Q8. (✅ done)

After each applied change: bump `version:`, set `last_updated:` to the apply date, confirm `scope.covers` still matches content, and append a structured entry to `05.04-meta-review-log.md`.

## Park lot

- Second research lens proposed prescriptive full-table rewrites of the token-budget tables (01.06) and a per-error-class recovery matrix (04.03). → defer — apply the *minimal* disambiguation in Q7/Q14 first; only expand if a consumer still mis-budgets.
- D27-model-adherence (part of the `quality` group) was not exercised because it is N/A to context files. → closed: not applicable to this artifact type.
- A broader `--dim optimize` pass (token-budget trimming, reference-efficiency) was repeatedly hinted at by redundancy findings. → `→ <sibling-plan>.md` (run `/pe-meta-update --scope context --dim optimize` separately).
- `01.07` rule C7 "article Markdown files" scope wording is underspecified, but it is a learning-hub/Quarto concern bleeding into PE. → defer — resolve when the dual-metadata boundary is next revisited.

## Exit criteria (✅ done)

- All HIGH and MEDIUM rows (Q1–Q10) have a landed edit or an explicit `→ closed`/`→ defer` disposition. (✅ done)
- No duplicated quantitative table remains outside its declared canonical source (01.06). (✅ done)
- Each touched file has a bumped `version:` / refreshed `last_updated:` and a `05.04-meta-review-log.md` entry. (✅ done)
- A regression pass confirms no Always-Do / Ask-First / Never-Do item or capability chain was weakened. (✅ done)
- This plan reaches `status: done`; any remaining items are migrated to a sibling plan. (✅ done)

## How to apply

Re-invoke against the same scope in apply mode (optionally narrowing to the autonomous-eligible batch first):

```text
/pe-meta-update '.copilot\context\00.00-prompt-engineering' --mode apply --dim quality
```
