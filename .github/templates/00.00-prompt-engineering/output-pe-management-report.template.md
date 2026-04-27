---
description: "PE management report format for meta-update orchestration"
---

## PE Management Report

**Mode:** [fullcheck / healthcheck / performancecheck]
**Scope:** [all / specific type / specific file]
**Date:** [current date]
**Source:** [update source (fullcheck) / N/A]

### Results

| Metric | Value |
|---|---|
| Artifacts analyzed | [N] |
| Issues found | [N] (C:[N] H:[N] M:[N] L:[N]) |
| Changes applied | [N] (fullcheck/performancecheck) or N/A (healthcheck) |
| Health score | [N]/100 (healthcheck) or N/A |
| Token savings | ~[N] lines (performancecheck) or N/A |

### Changes Applied (fullcheck/performancecheck only)

| # | File | Change | Validated |
|---|---|---|---|
| 1 | `[path]` | [description] | ✅/❌ |

### Issues Found

| # | Severity | File | Issue | Status |
|---|---|---|---|---|
| 1 | [CRITICAL/HIGH/MEDIUM/LOW] | `[path]` | [description] | [Fixed/Open/Deferred] |

### Optimization Summary (performancecheck only)

| # | Type | File | Change | Lines Saved |
|---|---|---|---|---|
| 1 | [Dedup/Compress/Externalize] | `[path]` | [description] | ~[N] |

**Total estimated savings:** ~[N] lines (~[N] tokens)

### Rollback

To undo all changes:
1. `git diff` — review what changed
2. `git stash` — save and revert all changes
3. `git stash pop` — re-apply if desired

To undo specific file: `git checkout -- [file path]`

<!--
---
template_metadata:
  version: "1.0.0"
  last_updated: "2026-03-20"
  created: "2026-03-20"
  consumers:
    - "meta-prompt-engineering-update"
  changes:
    - "v1.0.0: Initial version tracking (A-24)"
---
-->
