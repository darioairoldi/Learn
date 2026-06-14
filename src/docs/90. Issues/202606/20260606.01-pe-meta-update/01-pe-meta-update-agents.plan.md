---
status: done
target_vision_version: "15.4.0"
domain: "prompt-engineering"
created: "2026-06-06"
goal: "Realign the five pe-meta agent files (00.09-pe-meta) with the 35-dimension catalog and fix the builder domain declaration so the domain-coherence gate collapses to single-domain."
backfill: true
backfill_reason: "Back-filled after execution: the --mode apply run executed Phases 5–8 from an in-conversation plan only. Vision v15.4.0 § Plan output contract requires the plan to be materialized on disk on every mutating run. This file restores the missing pivot artifact for run-id agents-apply-20260606."
run_id: "agents-apply-20260606"
---

# Plan — pe-meta agent realignment (`/pe-meta-update '.github\agents\00.09-pe-meta' --mode apply`)

## Goal

Bring the five `00.09-pe-meta` agent files into alignment with the 35-dimension dimension catalog (`05.07-pe-meta-dimension-catalog.md` v1.5.0) and fix the builder's `domain:` declaration so Phase 0b resolves `bundle=single-domain`.

## Resolved invocation

```text
Resolved invocation: --mode=apply --scope=.github/agents/00.09-pe-meta/ --source= --dim=all --start=none --end=none --deps=direct --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260606.01-pe-meta-update/01-pe-meta-update-agents.plan.md | spillover=none
```

Execution mode: **fresh** (no baseline, research ran). Drift guard: skipped (back-to-back plan+execute).

## Goal table

| # | Finding | File | Scope tag | Principle impact | Downstream landing | Status |
|---|---|---|---|---|---|---|
| F0 | Builder declares `domain: meta-operations`; Phase 0b gate fires (not a recognized domain), blocking single-domain collapse | `pe-meta-builder.agent.md` | in-scope | none (metadata correctness) | `pe-meta-builder.agent.md` | ✅ done |
| F1 | Agents reference `D1…D27-model-adherence`; catalog now defines D1–D35 (`D35-portability-boundary`) | builder, researcher, designer | in-scope | none (catalog sync) | three agent files | ✅ done |
| F2 | Validator covers only 27 dimensions; D28–D35 (reliability group) unvalidated | `pe-meta-validator.agent.md` | in-scope | strengthens `verification-before-completion` | `pe-meta-validator.agent.md` | ✅ done |
| F3 | Stale bottom validation-metadata (designer `1.0`/`2026-03-20`; optimizer out of sync) | designer, optimizer | in-scope | none (metadata sync) | two agent files | ✅ done |

## Actionable items (execution-ready)

### F0 — builder domain fix

- [x] `pe-meta-builder.agent.md` frontmatter: `domain: "meta-operations"` → `domain: "prompt-engineering"` ✅
- [x] `pe-meta-builder.agent.md` version: `1.0.0` → `1.0.1`; append changelog entry ✅
- [x] Re-run Phase 0b: footprint collapses to `bundle=single-domain` ✅

### F1 — dimension-range refresh (D27 → D35)

- [x] `pe-meta-builder.agent.md`: dimension reference `D1…D27-model-adherence` → `D1…D35-portability-boundary` ✅
- [x] `pe-meta-researcher.agent.md`: `v2.2.0` → `2.2.1`; D27 → D35 range refresh; append changelog ✅
- [x] `pe-meta-designer.agent.md`: `v2.0.1` → `2.0.2`; D27 → D35 range refresh ✅

### F2 — validator reliability pass

- [x] `pe-meta-validator.agent.md`: description + goal "27 quality dimensions" → "35" ✅
- [x] `pe-meta-validator.agent.md`: D27 → D35 in capabilities and boundaries ✅
- [x] `pe-meta-validator.agent.md`: add **Phase 4b Reliability Pass** covering `D28-reproducibility` through `D35-portability-boundary` ✅
- [x] `pe-meta-validator.agent.md`: add `scope.covers` reliability entry ✅
- [x] `pe-meta-validator.agent.md`: fix test scenario 2 (remove stale "21 applicable dims") ✅
- [x] `pe-meta-validator.agent.md`: `v2.1.1` → `2.2.0` ✅

### F3 — version / bottom-metadata sync

- [x] `pe-meta-designer.agent.md`: sync bottom validation-metadata (was stale `1.0`/`2026-03-20`) ✅
- [x] `pe-meta-optimizer.agent.md`: `v1.1.1` → `1.1.2`; sync bottom validation-metadata ✅

### Phase 6–8 (execution / verification)

- [x] Phase 7 regression: `get_errors` → 0 markdown errors across all five agents ✅
- [x] Phase 7 chain verification: all `handoffs:` targets resolve; tool/mode alignment intact (`plan` agents read-only; `optimizer` keeps write tools) ✅
- [x] Phase 8 audit log: append `agents-apply-20260606` entry to `05.04-meta-review-log.md` ✅

## Park lot

- **Orchestrator prompt does not materialize the plan file in `--mode apply`** → closed: fixed in `pe-meta-update.prompt.md` v2.3.1 (plan materialization hoisted into Phase 6 § Plan materialization, non-skippable on every mutating run) ✅

## Exit criteria

- All five agents reference the 35-dimension range; validator validates D28–D35.
- Builder domain resolves `bundle=single-domain`.
- 0 markdown errors; all handoffs resolve; additive-only (no Always/Ask/Never items removed).
- Audit-log entry recorded with first-line `Resolved invocation:` log carrying `plan-file=<this file>`.
