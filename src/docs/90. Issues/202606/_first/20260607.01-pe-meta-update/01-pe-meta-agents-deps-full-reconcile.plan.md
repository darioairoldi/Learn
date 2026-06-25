---
status: done
target_vision_version: "15.4.0"
domain: "prompt-engineering"
created: "2026-06-07"
goal: "Re-review the five pe-meta agent files with a full dependency closure (--deps full) and close the two residual validator metadata/consistency inconsistencies the 2026-06-06 baseline (F2/F3) missed."
run_id: "agents-deps-full-20260607"
baseline: "src/docs/90. Issues/202606/20260606.01-pe-meta-update/01-pe-meta-update-agents.plan.md"
---

# Plan — pe-meta agent re-review (`/pe-meta-update '.github\agents\00.09-pe-meta' --mode apply --deps all`)

## Goal

Re-review the five `00.09-pe-meta` agent files against the 35-dimension catalog (v1.5.0) with the dependency closure widened from `direct` (yesterday's baseline) to `full`, and resolve the residual validator inconsistencies missed by the 2026-06-06 baseline.

## Resolved invocation

```text
Resolved invocation: --mode=apply --scope=.github/agents/00.09-pe-meta/ --source= --dim=full --start=none --end=none --deps=full --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260607.01-pe-meta-update/01-pe-meta-agents-deps-full-reconcile.plan.md | spillover=none | research=ran | phase4-coverage=5/5 | dims-exercised=full | bundle=single-domain
```

- **Phase 0a:** positional `'.github\agents\00.09-pe-meta'` normalized to path-scope `.github/agents/00.09-pe-meta/`; `--deps all` resolved to canonical `--deps full` (`all` is not a canonical `--deps` value).
- **Phase 0b:** seed footprint = `{prompt-engineering}` (5 agents); `--deps full` closure resolves under `.copilot/context/00.00-prompt-engineering/` (prompt-engineering) → `bundle=single-domain`. No gate.
- **Execution mode:** the 2026-06-06 done baseline is from a prior conversation and was not passed via `--plan-file`, so this is a **fresh** research-backed re-review (research ran), treated as a reconcile-in-spirit pass — surface residuals, apply only high-confidence corrections, do NOT manufacture changes.

## Phase 1 research summary (breadth=full snapshot)

- Dimension contract = **35 dimensions** (`D1-metadata` … `D35-portability-boundary`), catalog `05.07` v1.5.0. No D36+. Confirms the validator `scope.covers` "27-dimension" string is stale.
- VS Code custom-agents doc (edited 2026-06-03): agent file format stable; `infer` deprecated in favor of `user-invocable`/`disable-model-invocation` — **none of the 5 agents use `infer`**, so no deprecation impact.
- No PE-relevant external change affects these 5 files since the 2026-06-06 baseline.

## Goal table

| # | Finding | File | Scope tag | Principle impact | Downstream landing | Status |
|---|---|---|---|---|---|---|
| G1 | `scope.covers` declares "27-dimension assessment with selective --dim invocation" while description/goal/capabilities/boundaries all declare 35 — internal D6 contradiction missed by baseline F2 | `pe-meta-validator.agent.md` | in-scope | strengthens `verification-before-completion` (metadata matches behavior) | `pe-meta-validator.agent.md` | ✅ done |
| G2 | Bottom `article_metadata` block lacks `version:`/`last_updated:` fields the four sibling agents carry (baseline F3 synced designer+optimizer but not validator) | `pe-meta-validator.agent.md` | in-scope | none (D1 metadata sync) | `pe-meta-validator.agent.md` | ✅ done |

Builder, researcher, designer, optimizer: **clean** — D35-aligned, `domain: prompt-engineering`, bottom-metadata synced (no findings).

## Actionable items (execution-ready)

### G1 — validator scope.covers dimension-count correction

- [x] `pe-meta-validator.agent.md` `scope.covers`: `"27-dimension assessment with selective --dim invocation"` → `"35-dimension assessment with selective --dim invocation"` ✅

### G2 — validator bottom-metadata sync + version bump

- [x] `pe-meta-validator.agent.md` frontmatter `version:` `2.2.0` → `2.2.1`; `last_updated:` `2026-06-06` → `2026-06-07` ✅
- [x] `pe-meta-validator.agent.md` frontmatter: append v2.2.1 changelog entry ✅
- [x] `pe-meta-validator.agent.md` bottom `article_metadata`: add `version: "2.2.1"` and `last_updated: "2026-06-07"`; append v2.2.1 changelog line ✅

### Phase 6–8 (execution / verification)

- [x] Rollback snapshot taken before edit ✅
- [x] Phase 7 regression: `get_errors` → 0 markdown errors; all five `handoffs:` targets resolve; tool/mode alignment intact (plan agents read-only) ✅
- [x] Phase 8 audit log: append `agents-deps-full-20260607` entry to `05.04-meta-review-log.md` ✅

## Park lot

- _(none)_

## Exit criteria

- Validator `scope.covers` declares 35 dimensions consistently with the rest of the file.
- Validator bottom-metadata carries `version`/`last_updated` matching its four siblings.
- 0 markdown errors; all handoffs resolve; additive/corrective only (no Always/Ask/Never items removed).
- Audit-log entry recorded with first-line `Resolved invocation:` log carrying `plan-file=<this file>`.
