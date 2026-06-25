---
# Quarto Metadata
title: "Issue: `--deps` default behavior misread as `--deps all` in pe-meta-update Phase 0b footprint log"
author: "Dario Airoldi"
date: "2026-06-06"
categories: [issue, prompt-engineering, pe-meta]
description: "Investigation of why the pe-meta-update Phase 0b domain-footprint log reports no dependency closure when --deps is omitted, and whether the default should be --deps all."
draft: true
---

# Issue Report

**Issue Title:** `--deps` default behavior misread as `--deps all` in pe-meta-update Phase 0b footprint log

**Date Reported:** 2026-06-06
**Reporter:** Dario Airoldi
**Status:** Resolved (default kept as-is; guidance improvements proposed)

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution / Decision](#-solution--decision)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief Description

During a `/pe-meta-update '.github/instructions' --mode apply` run, the Phase 0b
(domain coherence) log emitted:

```
Domain footprint table (seed = all 17 files; --deps none so no dependency closure)
```

The reporter expected that omitting `--deps` would behave as `--deps all` (i.e.,
traverse and assess the full dependency closure of the seed set). The observed
behavior — no dependency closure, and a footprint table appearing to list only the
13 directly modified files — contradicted that mental model.

### Core Question

1. What does the footprint log line actually mean?
2. Does `--deps` default to `all` when unspecified?
3. Why did the footprint table appear to show only 13 (modified) files instead of all 17?
4. What guidance changes would make `--deps` behavior unambiguous in future runs?

### Impact Points

- **Operator confusion** about what a parameter-less manual run assesses.
- **Mismatch** between the "default-full invocation contract" naming and actual
  `--deps` default (`none`).
- **Reporting ambiguity** between the seed count (17) and the modified-files table (13).

---

## 🔍 Context Information

| Field | Value |
|---|---|
| **Component** | `pe-meta-update` orchestrator (PE meta-update pipeline) |
| **Artifact version** | `pe-meta-update.prompt.md` v2.4.0 |
| **Authority docs** | vision v15, `04.05-pe-meta-invocation-gates.md` |
| **Phase involved** | Phase 0b — domain coherence check |
| **Invocation** | `/pe-meta-update '.github/instructions' --mode apply` |
| **Resolved scope** | All 17 instruction files (seed set) |
| **Resolved `--deps`** | `none` (default) |
| **Environment** | Learning Hub repo, branch `main` |

### Relevant Authority Statements

| Layer | Statement | Location |
|---|---|---|
| Orchestrator | `### --deps none\|direct\|full\|<N> (default: none)` | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) line 144 |
| Vision v15 | "deps defaults to the command's natural traversal depth" | §"Scope and depth compose orthogonally" (line ~1467) |
| Gates context | "Resolve scope to file set … If `--deps direct\|full\|<N>` is present, traverse the closure" | [04.05-pe-meta-invocation-gates.md](../../../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) line 98 |

---

## 🔬 Analysis

### Root Cause

The reporter's expectation rests on two incorrect premises:

1. **There is no `--deps all` value.** The valid value set is `none | direct | full | <N>`.
   The maximal traversal is `--deps full` (bounded recursive, default depth 5).
2. **The default is `none`, by explicit design** — stated identically across the
   orchestrator prompt, the vision, and the gates context file.

The naming of the **"default-full invocation contract"** (`default-full-investigation`)
is the source of the confusion. That contract governs **breadth/scope** — a
parameter-less manual run sweeps *all seed artifacts* (here, all 17 instruction
files). It does **not** govern **dependency-traversal depth**. `--scope` and
`--deps` are **orthogonal by design** (vision §"Scope and depth compose
orthogonally", Priority P2):

- **`--scope`** = *what to assess* → the seed set
- **`--deps`** = *how deep to traverse dependencies* → opt-in expansion

So the footprint line decomposes as:

- `seed = all 17 files` → `--scope` resolved to all 17 instruction files (full breadth).
- `--deps none so no dependency closure` → because `--deps` defaulted to `none`,
  Phase 0b did **not** traverse outward to depended-on/dependent artifacts; the
  footprint was computed from the 17 seed files only.

### Why `--deps` Defaults to `none` (and should)

The vision's **cost challenge** justifies opt-in traversal: auto-expanding the full
dependency closure on every run is *"prohibitively expensive… cost grows with
artifacts × change-sources × dependency-chain depth."* Keeping deps traversal
subtractive-by-default keeps run cost proportional to the explicitly named scope.

### The 13-vs-17 Discrepancy

The headline says `seed = 17`, but the rendered footprint **table** appeared to list
only the 13 modified files. This is a **report-rendering inconsistency**, separate
from `--deps` semantics: the domain footprint is computed for **every in-scope file
(all 17)**, not only edited ones. A table that filters to modified files while the
headline counts seed files is internally inconsistent and worth correcting.

### Impact Assessment

| Area | Severity | Notes |
|---|---|---|
| Correctness of the run | None | Run behaved exactly per spec (full scope, no closure) |
| Operator predictability | Medium | Naming + log wording invite the `--deps all` misread |
| Report fidelity | Medium | 13-vs-17 table/headline mismatch is a genuine rendering gap |

---

## 🔄 Reproduction Steps

1. Invoke `/pe-meta-update '.github/instructions' --mode apply` (no `--deps`).
2. Observe the Phase 0b `Resolved invocation:` / domain-footprint log.
3. Note the line: `Domain footprint table (seed = all 17 files; --deps none so no dependency closure)`.
4. Note the footprint table renders fewer rows (13 modified files) than the seed count (17).

### Affected Code Locations

| File | Line(s) | Relevance |
|---|---|---|
| [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) | 144 | `--deps` definition + default |
| [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) | 299 | Phase 0b scope/closure resolution |
| [04.05-pe-meta-invocation-gates.md](../../../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) | 98–106 | Seed-vs-deps footprint computation |

---

## ✅ Solution / Decision

### Decision

**Keep the `--deps` default as `none`.** It is correct and intentional:

- Preserves orthogonality of `--scope` (what) and `--deps` (how deep).
- Honors the cost challenge (no implicit closure expansion per run).
- `--deps all` is not a valid value; `--deps full` is the maximal opt-in.

### Rejected Alternative

**Require `--deps` and error if missing** — rejected. It violates
`default-full-investigation` (parameter-less manual runs MUST work) and
`minimal-canonical-surface`/ease-of-use. The vision mandates *subtractive*
strategies (narrow from full), not mandatory flags.

### Proposed Guidance Improvements (non-blocking, optional)

| # | Change | Rationale | Risk |
|---|---|---|---|
| 1 | Split the Phase 0b footprint headline into explicit fields, e.g. `breadth=full (scope: 17 seed files) \| deps=none (no closure; pass --deps full to expand)` | Serves `predictability` (P0); prevents conflation | Low (wording) |
| 2 | Make the footprint **table** enumerate all seed files with `role=seed\|dep` and `modified=yes\|no` columns | Resolves 13-vs-17 mismatch; "modified" becomes a column, not a filter | Medium (substantive) |
| 3 | Add one sentence to the `--deps` definition block noting the default-full contract governs **breadth, not traversal depth**; deps is independently `none` by default | Removes the naming trap at the point of reference | Low (wording) |

> These were proposed but **not yet implemented**. Items 1 and 3 are low-risk
> wording fixes; item 2 is the substantive reporting fix.

---

## 📚 Additional Information

### Testing Recommendations

- After any item-2 change, re-run `/pe-meta-update '.github/instructions' --mode plan`
  and verify the footprint table enumerates all 17 seed files.
- Confirm the first-line `Resolved invocation:` log echoes `--deps=none` explicitly.

### Migration Considerations

- None. No behavior change is proposed — only log/report wording and a documentation
  clarification.

### Performance Impact

- None. The default `--deps none` is the cheapest traversal and remains unchanged.

---

## ✔️ Resolution Status

**Current Status:** Resolved — default kept; guidance improvements logged as optional follow-ups.

### Verification Checklist

- [x] Confirmed `--deps` valid values are `none | direct | full | <N>` (no `all`). ✅
- [x] Confirmed default is `none` across orchestrator, vision, and gates context. ✅
- [x] Confirmed orthogonality of `--scope` and `--deps` in vision. ✅
- [x] Explained the footprint log line semantics. ✅
- [x] Identified the 13-vs-17 table/headline rendering inconsistency. ✅
- [ ] (Optional) Implement guidance fix #1 (split footprint headline fields).
- [ ] (Optional) Implement guidance fix #2 (footprint table enumerates all seed files).
- [ ] (Optional) Implement guidance fix #3 (`--deps` definition clarification sentence).

### Follow-up Actions

- Decide whether to schedule guidance fixes #1–#3 in a future `pe-meta-update` revision.
- If fix #2 is adopted, mirror the table-enumeration rule in
  `04.05-pe-meta-invocation-gates.md` if it belongs at the gate layer.

---

## 🎓 Lessons Learned

### What Went Right

- The run behaved exactly per the documented contract.
- Cross-checking the paraphrased rule against the vision, gates context, and
  orchestrator prompt surfaced the real cause (naming, not logic).

### What Went Wrong

- The "default-full invocation contract" naming invites the false inference that
  *all* parameters default to maximal, including `--deps`.
- The footprint table filtered to modified files while the headline counted seed
  files — an internal inconsistency.

### Improvements for the Future

- Surface resolved parameter values (`deps=none`) explicitly at the point of
  reporting, not only in the canonical first-line log.
- When a MUST relies on a default, make the default visible in operator-facing output.

---

## 📎 Appendix

### Vision Excerpt — Orthogonality

> The `--scope` and `--deps` options address two independent concerns:
> `--scope` = "what artifacts to target"; `--deps` = "how deep to traverse".
> … Both default independently when omitted (scope defaults to all applicable
> types; deps defaults to the command's natural traversal depth).

### Orchestrator Excerpt — `--deps` Definition

> `### --deps none|direct|full|<N> (default: none)`
> Dependency-chain depth for Phase 4 per-artifact work. `direct` = first-level
> only; `full` = bounded recursive traversal (default depth 5); `<N>` = explicit
> numeric depth.


---

# Article Additional Metadata

article_metadata:
  filename: "20260606-deps-default-behavior-analysis.md"
  created: "2026-06-06"
  last_updated: "2026-06-06"
  version: "1.0"
  status: "resolved"
  issue_type: "documentation-clarification"

cross_references:
  affected_articles:
    - "../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md"
    - "../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md"
  related_issues: []
---