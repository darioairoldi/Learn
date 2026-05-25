---
title: "Context files improvement plan"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "context-set"
source_status_file: "../02.01-validation-status-context-files.md"
---

# Context files improvement plan

Purpose: resolve C-01, C-02, C-03, and C-04 blockers so the context-set state can be promoted from `failed` to `complete`.

## 🎯 Current blockers

1. C-01 fail: `STRUCTURE-README.md` is missing `description` in frontmatter.
2. C-02 partial: duplicated and ambiguously layered rules (especially tool alignment, boundary minimums, and response-management ownership).
3. C-03 partial: uncertain scope for lifecycle and entry-point files (`05.02`, `05.03`) plus uncovered behavior guidance.
4. C-04 fail: seven broken local links in context files.

## 📋 Scope and constraints

1. Scope is limited to `.copilot/context/00.00-prompt-engineering/*.md` and related references.
2. Do not change user-facing behavior of PE prompts/agents unless the change is explicitly required by blocker resolution.
3. Prefer reference consolidation over content duplication.
4. Keep `STRUCTURE-README.md` category taxonomy stable unless a category is proven unused.

## ⚙️ Work plan by validation case

### C-01 metadata validity

1. Add `description` to `STRUCTURE-README.md` frontmatter.
2. Re-run C-01 check.
3. Mark C-01 pass only if all files contain valid frontmatter and required fields (`description`, `version`, `last_updated`).

Pass criteria:
- `MissingFrontmatter=0`
- `MissingFields=0`
- `MalformedFrontmatter=0`

### C-02 construction invariants

1. Designate canonical sources:
- Tool alignment: `01.04-tool-composition-guide.md`
- Quantitative thresholds and boundary minimums: `01.06-system-parameters.md`
- Production readiness requirements: `04.03-production-readiness-patterns.md`
2. In non-canonical files, replace duplicated normative rules with short references.
3. Resolve contradictory reference-style guidance between principles and instruction-level rules.
4. Add explicit bridge text in `02.04-agent-shared-patterns.md` to state that response-management templates implement `04.03` requirements.
5. Add or reference a shared error-recovery template path so H5 is actionable in the same shared pattern set.

Pass criteria:
- No conflicting normative statements for the same rule.
- Duplicate normative rule count reduced to documented intentional duplicates only.
- Actionability gaps closed for response management, error recovery, and embedded tests.

### C-03 coverage consistency

1. For `05.02-artifact-lifecycle-management.md` and `05.03-pe-workflow-entry-points.md`, choose one status per file:
- actively consumed (add explicit consumer references), or
- intentionally parked (mark as out-of-scope/future in `STRUCTURE-README.md`).
2. Add missing behavior guidance for:
- orchestration phase sequencing,
- handoff failure recovery,
- dependency-map staleness detection,
- exemplary-bar enforcement timing.
3. Update consumer artifacts to reference new/updated guidance where required.

Pass criteria:
- No ambiguous orphan status for active workflow guidance files.
- Each critical consumer behavior has at least one discoverable guidance source.

### C-04 staleness and source verification

1. Fix broken local links:
- `00.03-metadata-contracts.md` (2 links)
- `01.01-context-engineering-principles.md` (4 links)
- `03.07-template-authoring-patterns.md` (1 link)
2. Re-run link verification over all context files.
3. Keep source-review notes for external links with unknown stability.

Pass criteria:
- `BrokenLocalLinks=0`
- `StaleOver180=0`

## 🏗️ Execution sequence

1. Fix C-04 links first (removes deterministic hard failures quickly).
2. Fix C-01 metadata gap.
3. Resolve C-02 canonical ownership and deduplication.
4. Resolve C-03 scope and behavior-coverage gaps.
5. Re-run C-01..C-04 and update `../02.01-validation-status-context-files.md`.

## ✅ Validation rerun checklist

- [x] C-01 rerun captured.
- [x] C-02 rerun captured.
- [x] C-03 rerun captured.
- [x] C-04 rerun captured.
- [x] Status file promoted to `complete` or kept `failed` with exact residual blockers.

## 📌 Ownership and evidence

Owner: `pe-meta-validator` workflow run (manual bootstrap until full automation is active).

Evidence files:
- `../context-validation-results-20260521.json`
- `../context-validation-full-run-20260521.txt`
