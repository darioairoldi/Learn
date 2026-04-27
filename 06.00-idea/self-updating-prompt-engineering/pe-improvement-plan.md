---
title: "PE meta-system improvement plan"
author: "Dario Airoldi"
date: "2026-04-27"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
implements: "06.000-vision.v6.md"
goal: "Close the gaps between pe-meta's current implementation and the vision's 9-step self-update workflow — making pe-meta fully capable of researching, analyzing, reasoning, designing, planning, validating, implementing, verifying, and iterating across all PE tiers"
scope:
  covers:
    - "pe-meta vision compliance gaps (6 findings)"
    - "Vision 9-step workflow alignment"
    - "Vision-specific requirements compliance (R-S1 through R-G3)"
  excludes:
    - "pe-sim, pe-con, pe-gra improvements (downstream — driven by improved pe-meta)"
    - "Vision document changes"
    - "Self-update infrastructure (outcome log, rename log, snapshots) — separate concern"
    - "Portable packaging (MCP server, SDK, extension)"
boundaries:
  - "MUST NOT modify the vision document"
  - "MUST preserve all existing pe-meta capabilities"
  - "All changes to pe-meta agents MUST stay under 200 lines"
rationales:
  - "pe-meta is the self-improvement engine — gaps here cascade to every PE tier"
  - "Vision document loading is the #1 gap — without it, the system can't evaluate against its own design intent"
---

# PE meta-system improvement plan

> **Goal**: Close the gaps between pe-meta's current implementation and the vision's 9-step self-update workflow.

---

## 🎯 Current compliance: pe-meta vs vision's 9-step workflow

| Vision step | pe-meta component | Compliance | Key issue |
|---|---|---|---|
| **1. Search** | Researcher (`fetch_webpage`), Update (Phase 1), Release Monitor (Phase 2) | ✅ STRONG | 3 components with internet research. Trust-calibrated source evaluation. All human-initiated (no auto-trigger — platform limitation). |
| **2. Analyze** | Researcher (dependency map, context files, structure scan, effectiveness log, rejection history) | ✅ STRONG | Comprehensive analysis with cross-artifact awareness. |
| **3. Reason** | Researcher (trust classification, trade-offs), Update (3-tier classification protocol) | ⚠️ MODERATE | **Vision document never loaded** — reasoning can't evaluate against strategic direction. |
| **4. Design** | Designer (layer-ordered specs, builder delegation, cooperation design, rollback per change) | ✅ STRONG | Dedicated agent producing independently executable change specifications. |
| **5. Plan** | Designer (L1→L4 ordering), Update (risk-ordered execution, rollback snapshots) | ✅ STRONG | Dependency-aware, risk-ordered with rollback. |
| **6. Validate** | Validator Mode 1 (Design Validation — 6 check categories D1-D6) | ✅ STRONG | Pre-implementation validation with SAFE/FIX/UNSAFE verdict. |
| **7. Implement** | Optimizer (`replace_string_in_file`, `multi_replace_string_in_file`), Update Phase 6 | ✅ STRONG | Write access properly scoped. |
| **8. Verify** | Validator Mode 2 (Implementation Validation), Update Phase 7 (capability regression test) | ✅ STRONG | Two-part verification: system-level + per-artifact-type. |
| **9. Iterate** | Optimizer (max 3 per file), Update (max 3 files between checkpoints) | ⚠️ MODERATE | Iteration is local (fix→revalidate). **No global cycle-back** to search/analyze/reason. |

**Overall: 6/9 steps STRONG, 2/9 MODERATE, 1/9 N/A (auto-trigger = platform limitation)**

---

## 📊 Gap analysis (6 findings)

| # | Gap | Severity | Vision rationale violated | Current state | Required state |
|---|---|---|---|---|---|
| **G1** | **Vision document never loaded** | HIGH | R-L1, R-S4 — system can't evaluate changes against its own design intent | No meta-agent or prompt loads `06.000-vision.v6.md` | Researcher loads vision in Step 1 as a reference point for evaluating any change |
| **G2** | **No global iteration loop** (step 9 → step 1) | MEDIUM | R-L2 — iteration is bounded to the apply phase | Optimizer iterates locally (fix→validate→fix, max 3). No path back to Search/Analyze/Reason. | Update prompt Phase 7 includes an explicit "cycle back to Phase 1" decision gate when regression test reveals fundamental design issues |
| **G3** | **Optimizer lacks independent rollback snapshots** | MEDIUM | Reversibility guarantee — optimizer invoked outside Update prompt has no snapshots | Only Update prompt Phase 6 creates `.copilot/temp/rollback/`. Optimizer invoked from scheduled-review or direct audit skips snapshots. | Optimizer creates snapshots independently before any file modification |
| **G4** | **Breaking/non-breaking classification not in designer** | LOW | R-P4, R-G1 — classification is in orchestrator but not in the design specs | Designer produces change specs with Impact (Low/Med/High) but not breaking/non-breaking. Classification happens only when orchestrator runs. | Designer includes breaking/non-breaking classification in each change spec entry |
| **G5** | **Scheduled review lacks `fetch_webpage`** | LOW | R-L4 — can't check for external changes during weekly review | Scheduled review uses only `read_file`, `grep_search`, `file_search`, `list_dir`, `replace_string_in_file`. Delegates internet to release-monitor. | By design — separation of concerns. **Not a gap to fix.** |
| **G6** | **No automated trigger mechanism** | LOW | R-S1 — vision says "event-driven triggers" | All monitoring is human-initiated. User must run prompts manually. | Platform limitation (VS Code doesn't support cron-like prompt execution). **Not fixable at PE layer.** |

**Actionable gaps: G1, G2, G3, G4 (4 items). G5 and G6 are by-design or platform-limited.**

---

## 📋 Improvement plan

### Step 1: Add vision document loading to pe-meta-researcher (G1)

**What**: Add `06.000-vision.v6.md` to researcher's Step 1 context loading, with a Phase 3 "vision alignment check" that evaluates each finding against the vision's goal, principles, and success criteria.

**Where**: `pe-meta-researcher.agent.md`

**Changes**:
- Step 1 item 1: Add `Load the vision document: read_file on 06.00-idea/self-updating-prompt-engineering/06.000-vision.v6.md`
- Step 3 (Broaden the Analysis): Add a bullet: "**Vision alignment check** — for each improvement opportunity, evaluate whether it aligns with the vision's goal, respects its boundaries, and advances its success criteria. Reference specific vision rationales (R-L1 through R-G3) when applicable."
- Knowledge Base section: Add vision document to the list of files to load

**Risk**: LOW — additive. No existing behavior changed. Adds ~5 lines.

**Verification**: Run `grep_search` for `vision` in researcher body — should find the new references.

---

### Step 2: Add global iteration gate to pe-meta-prompt-engineering-update (G2)

**What**: In Phase 7 (Regression Test), add a decision gate: if regression test reveals a fundamental design issue (not just an implementation error), cycle back to Phase 1 (Source Research) or Phase 2 (Structure Audit) instead of just re-applying fixes.

**Where**: `pe-meta-prompt-engineering-update.prompt.md`

**Changes**: In Phase 7 (after 7b capability regression test), add:

```
### Phase 7c: Iteration Decision Gate

If regression test reveals:
- **Implementation error** (wrong content, missed file) → fix and re-run Phase 7a/7b (local iteration)
- **Design flaw** (change spec was structurally wrong) → cycle back to Phase 4 (Content Audit with updated scope)
- **Fundamental misalignment** (approach doesn't achieve stated goal) → cycle back to Phase 1 (Source Research) or STOP and escalate to human

Maximum global iterations: 2 (Phase 7 → Phase 1/4 → Phase 7). If still failing after 2 global iterations → STOP and report.
```

**Risk**: LOW — additive. Adds a decision point that currently doesn't exist. Existing behavior (local fix→revalidate) is preserved as the default path.

**Verification**: Run regression test scenario where Phase 7 finds a design flaw — should trigger global iteration.

---

### Step 3: Add snapshot creation to pe-meta-optimizer (G3)

**What**: Optimizer creates rollback snapshots before modifying any file, regardless of whether it was invoked from the Update prompt or from scheduled-review/direct audit.

**Where**: `pe-meta-optimizer.agent.md`

**Changes**: In the Process section, add to Phase 2 (before any file modification):

```
**Rollback snapshot (MANDATORY)**: Before modifying any file, create a backup at `.copilot/temp/rollback/<filename>.backup.md`. If the optimization fails validation after 3 iterations, restore from this backup.
```

Also add `create_file` to the tools list (currently missing — optimizer has `replace_string_in_file` and `multi_replace_string_in_file` but not `create_file`, so it can't create snapshot files). This requires adding 1 tool.

**Risk**: LOW — additive. Optimizer gains the ability to create its own snapshots. Existing behavior unchanged.

**Verification**: Invoke `@pe-meta-optimizer` directly (not from Update prompt). Verify snapshot files are created before modifications.

---

### Step 4: Add breaking/non-breaking classification to pe-meta-designer (G4)

**What**: Designer includes breaking/non-breaking classification in each change specification entry, using the 3-tier classification protocol already defined in the Update prompt.

**Where**: `pe-meta-designer.agent.md`

**Changes**: In the Change Specification template (Step 4), add a field:

```
| **Classification** | Breaking / Non-breaking (Deterministic / LLM-assisted) |
```

And in Step 5 (Self-Validate), add a check:

```
- [ ] Each change has a breaking/non-breaking classification with confidence level
```

**Risk**: LOW — additive. Adds ~3 lines. Classification was already happening in the orchestrator; this moves it earlier in the pipeline.

**Verification**: Review a designer output — each change spec should include the classification field.

---

## 🔄 Post-improvement: use pe-meta to improve other tiers

Once Steps 1–4 are applied, pe-meta becomes vision-compliant. Then use it to improve the other tiers:

| Action | Command | What it does |
|---|---|---|
| **First release monitor run** | `/pe-meta-prompt-engineering-release-monitor` | Populates "Last checked" dates in 05.04 for all 7 authoritative sources. Establishes baseline. |
| **First scheduled review** | `/pe-meta-prompt-engineering-scheduled-review` | Detects staleness across all PE artifacts. Establishes review cadence. |
| **Full system healthcheck** | `/pe-meta-prompt-engineering-update healthcheck` | Comprehensive audit across all tiers — finds metadata gaps, stale references, consistency issues. |
| **Targeted pe-gra metadata fix** | `/pe-meta-prompt-engineering-update fullcheck --scope agents` | Finds and fixes missing `scope:` / `boundaries:` in 24 granular agent YAML frontmatters. |
| **Targeted pe-sim metadata fix** | `/pe-meta-prompt-engineering-update fullcheck --scope prompts` | Finds and fixes missing `scope:` / `boundaries:` / `version:` in 3 simple prompt YAML frontmatters. |

---

## ✅ Success criteria

| Criterion | Verification |
|---|---|
| Researcher loads vision document | `grep_search` for `06.000-vision` in researcher body |
| Update prompt has global iteration gate | Phase 7c exists with cycle-back decision logic |
| Optimizer creates snapshots independently | Test: invoke `@pe-meta-optimizer` directly, verify snapshot files created |
| Designer specs include breaking/non-breaking | Change spec template has Classification field |
| All authoritative sources have "Last checked" dates | 7/7 entries in 05.04 have non-blank dates after first monitor run |
| Full healthcheck passes | `/pe-meta-prompt-engineering-update healthcheck` returns 0 CRITICAL |

---

## 📚 References

- **📖** [06.000-vision.v6.md](06.000-vision.v6.md) — Self-updating PE vision (authoritative)
- **📖** [06.000-prompt-engineering-improvement.plan.md](06.000-prompt-engineering-improvement.plan.md) — Prior improvement plan (Steps 1–11, completed)
- **📖** `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md` — Audit trail
- **📖** `.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md` — Effectiveness tracking

<!--
article_metadata:
  filename: "pe-improvement-plan.md"
  created: "2026-04-27"
  type: "plan"
  changes:
    - "v1.0: Initial plan — 6 gaps identified, 4 actionable fixes, vision 9-step compliance matrix"
-->
