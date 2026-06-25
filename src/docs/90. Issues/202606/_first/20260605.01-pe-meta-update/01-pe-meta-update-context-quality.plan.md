---
status: done
target_vision_version: "v15.4"
domain: "prompt-engineering"
created: "2026-06-05"
goal: "Resolve quality-dimension findings (D6/D7 redundancy + surfaced metadata/structural debt) across the 00.00-prompt-engineering context folder."
---

# Plan — pe-meta-update `--scope .copilot/context/00.00-prompt-engineering` `--dim quality` `--mode plan`

> **Resolved invocation:** `--mode=plan --scope=.copilot/context/00.00-prompt-engineering/ --source=(all) --dim=quality --start=(none) --end=(none) --deps=none --skip=(none) --plan-file=src/docs/90. Issues/202606/20260605.01-pe-meta-update/01-pe-meta-update-context-quality.plan.md | breadth=full | caller=manual | bundle=single-domain`

**Goal (1 sentence):** Eliminate numeric-threshold duplication that violates the single-source contract and clear the surfaced YAML/structural debt across the PE context folder, restoring quality-dimension cleanliness.

`--dim quality` = `D6-consistency`, `D7-non-redundancy`, `D8-prioritization`, `D9-clarity`, `D10-completeness`, `D11-actionability`, `D27-model-adherence`.

## Phase 0b — domain footprint

| path | role | domain | domain-source |
|---|---|---|---|
| `.copilot/context/00.00-prompt-engineering/*.md` (40 files) | seed | `prompt-engineering` | declared |

Seed footprint = 1 (`prompt-engineering`); dependency footprint = 0 (`--deps none`). Disposition: **`bundle=single-domain`** — no gate.

## Findings (validated)

| # | Dim | File(s) | Finding | Scope tag | Principle impact | Downstream landing |
|---|---|---|---|---|---|---|
| F1 | D7-non-redundancy / D6-consistency | [01.01-context-engineering-principles.md](../../../../../.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md) | Principle 4 inlines boundary minimums `≥3/≥1/≥2` and Principle 6 inlines tool count `3–7` — numeric thresholds that `01.06-system-parameters.md` declares single-source. 01.01's OWN boundary states "MUST NOT duplicate parameter tables from 01.06", so the file contradicts its own boundary. | in-dim | Reinforces `single-source-of-truth` (H3) and 01.06's numeric-authority boundary | Edit 01.01 Principles 4 & 6 |
| F2 | D7-non-redundancy (low) | [01.07-critical-rules-priority-matrix.md](../../../../../.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md) | C3 restates full token-budget numbers (`≤2,500 / ≤1,500 / ≤3,000…`) inline rather than pointing to `01.06`. Borderline — the matrix is a by-design quick-reference, so this is advisory, not a violation. | in-dim (advisory) | Minor; quick-ref restatement is partially intentional | Park lot (decide policy) |

## Surfaced edge cases (out-of-dim — park lot)

These were detected during the quality pass but fall outside the `quality` dimension group. They do NOT block promotion of F1.

| # | Dim | File(s) | Finding | Suggested fix |
|---|---|---|---|---|
| P1 | D1-metadata / D30-metadata-guard | [01.05-glossary.md](../../../../../.copilot/context/00.00-prompt-engineering/01.05-glossary.md), [01.06-system-parameters.md](../../../../../.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md), [01.07-critical-rules-priority-matrix.md](../../../../../.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md) | YAML frontmatter `scope:`/`boundaries:`/`rationales:` blocks are **tab-indented**. The YAML spec forbids tabs for indentation; strict parsers fail. (01.01 correctly uses spaces.) | **(✅ done 2026-06-05)** Converted leading tabs → 2-space indentation in the frontmatter of all 3 files; bumped versions (01.05 → 1.0.4, 01.06 → 1.3.4, 01.07 → 1.2.6) + changelog rows. Grep for tabs in the 3 files returns zero. |
| P2 | D22-context-optimization (orphans) | `00.00-prompt-engineering/dependency-map/`, `00.00-prompt-engineering/structure/` | Empty placeholder folders persist (logged as S2 MEDIUM, deferred, in [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)). | **(✅ done 2026-06-05 — no deletion)** Already resolved by Plan 01.03 (`20260525.01-context-fullcheck/01.03-empty-subdir-gitkeep-plan.md`, status `executed`): folders are user-confirmed in-flight placeholders; deletion is explicitly out of scope. The `.gitkeep` reserved-status comments are the intended resolution and clear D22. Reconciled the stale S2 entry in 05.04 to mark it RESOLVED (superseded). |

## Actionable items (execution-ready)

### Item 1 — F1: de-duplicate boundary minimums in 01.01 Principle 4

- **File:** `.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md`
- **Anchor:** Principle 4 "Three-Tier Boundary System".
- **Edit (old → new):**
  - old: `**Principle**: Every agent MUST define three tiers: Always Do (no approval), Ask First (requires approval), Never Do (hard refusal). Minimum items: ≥3/≥1/≥2.`
  - new: `**Principle**: Every agent MUST define three tiers: Always Do (no approval), Ask First (requires approval), Never Do (hard refusal). Minimum item counts are defined in 01.06-system-parameters.md → Agent Boundaries.`
- **Verify:** No literal `≥3/≥1/≥2` remains in 01.01; the 📖 reference to 01.06 (already present below the principle) is the sole numeric source.

### Item 2 — F1: de-duplicate tool-count threshold in 01.01 Principle 6

- **File:** `.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md`
- **Anchor:** Principle 6 "Tool Scoping and Security" → Key rules.
- **Edit (old → new):**
  - old: `- Limit agents to 3–7 tools; >7 causes tool clash`
  - new: `- Limit tool count per the range in 01.06-system-parameters.md → Agent Boundaries; exceeding it causes tool clash`
- **Verify:** No literal `3–7` numeric range remains in 01.01; 01.06 is the sole source.

### Item 3 — F1: bump 01.01 version + changelog

- **File:** `.copilot/context/00.00-prompt-engineering/01.01-context-engineering-principles.md`
- **Edit:** `version: "2.2.1"` → `version: "2.2.2"`; `last_updated: "2026-05-21"` → `last_updated: "2026-06-05"`; add a changelog line noting the de-duplication of numeric thresholds (moved to 01.06 single-source).
- **Verify:** Version bumped, `last_updated` current, changelog entry present (M8).

## Park lot (decisions needed, not blocking)

- **F2 policy — DECIDED: keep inline (advisory, no change).** The priority matrix is a by-design quick-reference index whose value is letting validators check compliance without leaving the matrix. C3 restating the token budgets is consistent with the established pattern in the same table — H1 (`≥3/≥1/≥2`), H2 (`3–7`), and H6 (`3–5`) all restate threshold values in the Check column, and every row already names `01.06-system-parameters.md` as the canonical source. 01.07's own boundary forbids duplicating *full rule bodies*, not individual numbers, so C3 does not violate it. This differs from F1: 01.01 is a principles narrative whose OWN boundary states "MUST NOT duplicate parameter tables from 01.06", a stricter constraint that the matrix does not carry. No edit to C3. (✅ done)
- **P1 / P2:** ~~Out-of-dimension; promote via a dedicated `--dim structural` run~~ — user approved closing both in this session. P1 applied (tabs → spaces in 01.05/01.06/01.07); P2 reconciled (already resolved by Plan 01.03 — no deletion, folders are confirmed in-flight placeholders). (✅ done)

## Exit criteria

- Items 1–3 applied; 01.01 carries no inline numeric thresholds owned by 01.06. (✅ done)
- `grep "≥3/≥1/≥2|3–7"` against 01.01 returns no frontmatter/body threshold restatements (only the changelog row describing the change remains). (✅ done)
- 01.01 version bumped (2.2.1 → 2.2.2) and changelog updated. (✅ done)
- F2 policy decision recorded. (✅ done) Decided: C3 keeps inline budgets (advisory) — consistent with the H1/H2/H6 quick-ref pattern; 01.06 stays canonical via the Canonical source column.
- P1/P2 closed in this session. (✅ done) P1: tabs → spaces in 01.05/01.06/01.07 (versions bumped, no tabs remain). P2: reconciled as already-resolved by Plan 01.03 (no deletion — user-confirmed in-flight placeholders).
