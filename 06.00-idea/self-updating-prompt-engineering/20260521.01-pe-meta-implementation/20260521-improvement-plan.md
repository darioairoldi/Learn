---
title: "pe-meta validation improvement plan"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.2.0"
status: "executed"
domain: "prompt-engineering"
goal: "Close all active failures from the pe-meta validation status set and refresh the status index with deterministic evidence"
scope:
  covers:
    - "Revalidation outcome for all rows currently marked failed in 02.00-validation-status.md"
    - "Root-cause grouping of still-failing rows"
    - "Execution plan to fix active failures in agents and prompts"
    - "Status refresh actions for rows that now pass"
  excludes:
    - "Vision changes"
    - "Non-pe-meta artifact changes"
    - "Publishing or deployment automation"
boundaries:
  - "Apply deterministic checks first, then rerun row runbooks for confirmation"
  - "Do not change artifact goals or scopes unless required to satisfy current validation rules"
  - "Keep edits minimal and localized to failing artifacts"
rationales:
  - "The status index is stale and currently mixes resolved and unresolved failures"
  - "Most active failures share a small number of repeated causes, enabling batched fixes"
  - "A phased plan reduces regression risk and shortens revalidation cycles"
---

# PE-meta validation improvement plan

## ✅ Execution outcome

The plan has been executed.

Final deterministic recheck result:
- Failed rows analyzed: 31
- Passing rows: 31
- Remaining failures: 0

Execution evidence:
- [recheck-failed-rows-20260521.json](recheck-failed-rows-20260521.json)

Status index updated:
- [02.00-validation-status.md](02.00-validation-status.md) now reflects complete status across all previously failed rows.

## 🎯 Current answer to your question
Yes, [02.00-validation-status.md](02.00-validation-status.md) is not fully updated to the current state.

A deterministic recheck of all rows currently marked failed was executed and written to:
- [recheck-failed-rows-20260521.json](recheck-failed-rows-20260521.json)

Recheck summary:
- Failed rows analyzed: 31
- Now passing: 6
- Still failing: 25

## ✅ Rows marked failed but now passing
The following rows are stale in [02.00-validation-status.md](02.00-validation-status.md) and can be updated to complete after runbook confirmation:

1. [02.06-validation-status-pe-meta-validator.md](02.06-validation-status-pe-meta-validator.md)
2. [02.07-validation-status-pe-meta-adherence.md](02.07-validation-status-pe-meta-adherence.md)
3. [02.13-validation-status-pe-meta-context-review.md](02.13-validation-status-pe-meta-context-review.md)
4. [02.25-validation-status-pe-meta-release-monitor.md](02.25-validation-status-pe-meta-release-monitor.md)
5. [02.27-validation-status-pe-meta-scheduled-review.md](02.27-validation-status-pe-meta-scheduled-review.md)
6. [02.37-validation-status-pe-meta-update.md](02.37-validation-status-pe-meta-update.md)

## ⚠️ Active failure set (25 rows)

### Root cause A: missing deterministic-first process signals (2 agent rows)
Affected:
1. [02.04-validation-status-pe-meta-optimizer.md](02.04-validation-status-pe-meta-optimizer.md)
2. [02.05-validation-status-pe-meta-researcher.md](02.05-validation-status-pe-meta-researcher.md)

Observed unmet check:
- A05_deterministic_first_signals

Fix intent:
- Add explicit deterministic-first language in process steps (for example: deterministic checks before LLM reasoning, token/efficiency/summarization signals).

### Root cause B: missing rationales in prompt YAML (17 prompt rows)
Affected:
1. [02.08-validation-status-pe-meta-agent-create-update.md](02.08-validation-status-pe-meta-agent-create-update.md)
2. [02.10-validation-status-pe-meta-agent-review.md](02.10-validation-status-pe-meta-agent-review.md)
3. [02.16-validation-status-pe-meta-hook-create-update.md](02.16-validation-status-pe-meta-hook-create-update.md)
4. [02.17-validation-status-pe-meta-hook-design.md](02.17-validation-status-pe-meta-hook-design.md)
5. [02.18-validation-status-pe-meta-hook-review.md](02.18-validation-status-pe-meta-hook-review.md)
6. [02.19-validation-status-pe-meta-instruction-create-update.md](02.19-validation-status-pe-meta-instruction-create-update.md)
7. [02.20-validation-status-pe-meta-instruction-design.md](02.20-validation-status-pe-meta-instruction-design.md)
8. [02.21-validation-status-pe-meta-instruction-review.md](02.21-validation-status-pe-meta-instruction-review.md)
9. [02.22-validation-status-pe-meta-prompt-create-update.md](02.22-validation-status-pe-meta-prompt-create-update.md)
10. [02.23-validation-status-pe-meta-prompt-design.md](02.23-validation-status-pe-meta-prompt-design.md)
11. [02.24-validation-status-pe-meta-prompt-review.md](02.24-validation-status-pe-meta-prompt-review.md)
12. [02.28-validation-status-pe-meta-skill-create-update.md](02.28-validation-status-pe-meta-skill-create-update.md)
13. [02.29-validation-status-pe-meta-skill-design.md](02.29-validation-status-pe-meta-skill-design.md)
14. [02.30-validation-status-pe-meta-skill-review.md](02.30-validation-status-pe-meta-skill-review.md)
15. [02.31-validation-status-pe-meta-snippet-create-update.md](02.31-validation-status-pe-meta-snippet-create-update.md)
16. [02.32-validation-status-pe-meta-snippet-design.md](02.32-validation-status-pe-meta-snippet-design.md)
17. [02.33-validation-status-pe-meta-snippet-review.md](02.33-validation-status-pe-meta-snippet-review.md)
18. [02.34-validation-status-pe-meta-template-create-update.md](02.34-validation-status-pe-meta-template-create-update.md)
19. [02.35-validation-status-pe-meta-template-design.md](02.35-validation-status-pe-meta-template-design.md)
20. [02.36-validation-status-pe-meta-template-review.md](02.36-validation-status-pe-meta-template-review.md)

Observed unmet check:
- G01_rationales_present

Fix intent:
- Add a `rationales:` section to each affected prompt YAML frontmatter with concise bullets aligned to prompt purpose.

### Root cause C: missing explicit phase/mode behavior guidance (24 prompt rows)
Affected:
1. [02.08-validation-status-pe-meta-agent-create-update.md](02.08-validation-status-pe-meta-agent-create-update.md)
2. [02.09-validation-status-pe-meta-agent-design.md](02.09-validation-status-pe-meta-agent-design.md)
3. [02.10-validation-status-pe-meta-agent-review.md](02.10-validation-status-pe-meta-agent-review.md)
4. [02.11-validation-status-pe-meta-context-create-update.md](02.11-validation-status-pe-meta-context-create-update.md)
5. [02.12-validation-status-pe-meta-context-design.md](02.12-validation-status-pe-meta-context-design.md)
6. [02.16-validation-status-pe-meta-hook-create-update.md](02.16-validation-status-pe-meta-hook-create-update.md)
7. [02.17-validation-status-pe-meta-hook-design.md](02.17-validation-status-pe-meta-hook-design.md)
8. [02.18-validation-status-pe-meta-hook-review.md](02.18-validation-status-pe-meta-hook-review.md)
9. [02.19-validation-status-pe-meta-instruction-create-update.md](02.19-validation-status-pe-meta-instruction-create-update.md)
10. [02.20-validation-status-pe-meta-instruction-design.md](02.20-validation-status-pe-meta-instruction-design.md)
11. [02.21-validation-status-pe-meta-instruction-review.md](02.21-validation-status-pe-meta-instruction-review.md)
12. [02.23-validation-status-pe-meta-prompt-design.md](02.23-validation-status-pe-meta-prompt-design.md)
13. [02.24-validation-status-pe-meta-prompt-review.md](02.24-validation-status-pe-meta-prompt-review.md)
14. [02.28-validation-status-pe-meta-skill-create-update.md](02.28-validation-status-pe-meta-skill-create-update.md)
15. [02.29-validation-status-pe-meta-skill-design.md](02.29-validation-status-pe-meta-skill-design.md)
16. [02.30-validation-status-pe-meta-skill-review.md](02.30-validation-status-pe-meta-skill-review.md)
17. [02.31-validation-status-pe-meta-snippet-create-update.md](02.31-validation-status-pe-meta-snippet-create-update.md)
18. [02.32-validation-status-pe-meta-snippet-design.md](02.32-validation-status-pe-meta-snippet-design.md)
19. [02.33-validation-status-pe-meta-snippet-review.md](02.33-validation-status-pe-meta-snippet-review.md)
20. [02.34-validation-status-pe-meta-template-create-update.md](02.34-validation-status-pe-meta-template-create-update.md)
21. [02.35-validation-status-pe-meta-template-design.md](02.35-validation-status-pe-meta-template-design.md)
22. [02.36-validation-status-pe-meta-template-review.md](02.36-validation-status-pe-meta-template-review.md)

Observed unmet check:
- P03_has_phase_or_mode_guidance

Fix intent:
- Add explicit phase headings and/or explicit mode behavior sections (for example: parse mode flags, review mode behavior, phase ordering language).

## ⚙️ Execution plan

### Phase 1: baseline refresh (no content edits)
1. Keep [recheck-failed-rows-20260521.json](recheck-failed-rows-20260521.json) as evidence baseline.
2. Mark the six stale failed rows as candidates for status refresh after runbook rerun.

### Phase 2: fix shared prompt YAML/meta gaps
1. Batch-edit all failing type-specific prompt files under [.github/prompts/00.09-pe-meta](../../../.github/prompts/00.09-pe-meta).
2. Add `rationales:` where missing.
3. Add explicit phase/mode behavior guidance where missing.
4. Keep existing goal/scope/boundaries unchanged unless strictly required.

### Phase 3: fix remaining agent A05 gaps
1. Update [.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md](../../../.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md) with deterministic-first process signals.
2. Update [.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md](../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) with deterministic-first process signals.

### Phase 4: rerun per-row validation runbooks
1. Rerun every row currently marked failed in [02.00-validation-status.md](02.00-validation-status.md).
2. Save new evidence per row under the existing 02.xx folders.
3. Regenerate row status fields from rerun evidence.

### Phase 5: update index and close
1. Update [02.00-validation-status.md](02.00-validation-status.md) with new status values and run timestamps.
2. Keep only active blockers in the table.
3. Bump version and last-updated metadata in the index.

## 📏 Definition of done

1. All rows previously marked failed are either complete or have a new, evidence-backed blocker.
2. No row remains failed due only to stale references in the index.
3. Root-cause checks are clean:
- A05_deterministic_first_signals = pass on both affected agents.
- G01_rationales_present = pass on all affected prompts.
- P03_has_phase_or_mode_guidance = pass on all affected prompts.
4. [02.00-validation-status.md](02.00-validation-status.md) and rerun evidence are consistent.

## 📚 Evidence

1. [02.00-validation-status.md](02.00-validation-status.md)
2. [recheck-failed-rows-20260521.json](recheck-failed-rows-20260521.json)
3. [validation-execution-summary-20260521.json](validation-execution-summary-20260521.json)

## ✅ Workstream C completion mapping

Lifecycle-specific tracking rows and completion evidence are now in place.

| Workstream C item | Completion status | Runbook output mapping |
|---|---|---|
| Update implementation tracking docs with lifecycle rows | complete | [02.00-validation-status.md](02.00-validation-status.md) row 38 and [02.38-validation-status-context-quality-lifecycle.md](02.38-validation-status-context-quality-lifecycle.md) |
| Add validation status entry for lifecycle orchestration | complete | [02.38-validation-status-context-quality-lifecycle.md](02.38-validation-status-context-quality-lifecycle.md) with C-01 to C-05 checks |
| Add evidence outputs | complete | [00-runbook.md](02.38-validation-status-context-quality-lifecycle/00-runbook.md), [source validation ledger](02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-source-validation-ledger.md), [structure decision report](02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-structure-decision-report.md), [consumer impact report](02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-consumer-impact-report.md), [post-change adherence report](02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-post-change-adherence-report.md), and [machine summary](02.38-validation-status-context-quality-lifecycle/20260521-lifecycle-validation-summary.json) |
