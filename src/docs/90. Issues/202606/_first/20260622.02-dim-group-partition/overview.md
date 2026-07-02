---
title: "Issue: --dim group redesign — disjoint partition over all 35 dimensions"
author: "Dario Airoldi"
date: "2026-06-22"
status: resolved
severity: high
domain: "prompt-engineering / pe-meta"
component: "pe-meta dimension catalog + pe-meta-review prompt"
framework: "PE artifact system (35-dimension catalog)"
goal: "Redefine the four headline --dim groups (strategic, quality, efficiency, reliability) as a clean disjoint partition that together cover all 35 dimensions, remove the redundant optimize group, and propagate the contract change to every consumer and use case."
description: "Contract-breaking redesign of the four primary --dim dimension groups in the pe-meta system. The old four-group union covered only 27/35 dimensions and the optimize group overlapped efficiency while also carrying apply-delegation behavior. The redesign makes the four groups a disjoint, complete partition (1 + 18 + 8 + 8 = 35), retires the optimize group, rewires its apply-delegation to --dim efficiency --mode apply, adds a user-facing decision guide, sharpens D14-craftsmanship, and updates all consumers, use cases, and the use-case index."
---

# Issue: `--dim` group redesign — disjoint partition over all 35 dimensions

> Part of the pe-meta-update work tracked under [`20260622.01-pe-meta-update`](../20260622.01-pe-meta-update/overview.md). This document analyzes the **dimension-group contract redesign** specifically. The change is **complete and validated**.

## 📋 Metadata

| Field | Value |
|---|---|
| **Date** | 2026-06-22 |
| **Author** | Dario Airoldi |
| **Status** | ✅ Resolved |
| **Severity** | High (breaking contract change to a shared option surface) |
| **Component** | `05.07-pe-meta-dimension-catalog.md`, `pe-meta-review.prompt.md` |
| **Framework** | PE artifact system — 35-dimension catalog (`D1-metadata` … `D35-portability-boundary`) |

## 📝 Description

The `--dim` parameter of `/pe-meta-review` selects which validation dimensions run. Four "headline" groups — `strategic`, `quality`, `efficiency`, `reliability` — were meant to give users an intuitive way to scope a review without naming individual dimensions. A fifth group, `optimize`, existed as an efficiency-flavoured subset that also triggered apply-delegation to the `@pe-meta-optimizer` agent.

Two structural defects had accumulated:

1. **Incomplete coverage.** The union of the four headline groups covered only **27 of 35** dimensions. Eight dimensions (`D1-metadata`, `D2-references`, `D5-boundaries`, `D12-staleness`, `D13-source-verification`, `D14-craftsmanship`, `D18-coverage`, `D22-context-optimization`) belonged to **none** of the four — so "the four groups" was not a usable mental model and `--dim full` could not be described as their union.
2. **Overlap + behavioral coupling.** The `optimize` group overlapped `efficiency`, and it additionally carried the apply-delegation trigger — conflating *which dimensions to assess* with *what mode to run in*.

**Impact:** users could not reason about the groups as a partition, the catalog could not state a coverage guarantee, and the `optimize` group duplicated `efficiency` while smuggling in mode semantics.

## 🎯 Trigger (verbatim)

> - please ensure that strategic + quality + efficiency + reliability cover all dimentions
> - please remove optimize
> - please update the use cases focusing on high priority dimentions first
> - yes please add it *(the "which `--dim` group should I pick?" decision guide)*
> - ok for strategic = vision-alignment only

Confirmed semantic definitions (verbatim):

> **Quality** = should ensure quality of generated artifacts (goal alignment); **efficiency** = should ensure low latency and token efficiency; **reliability** = should ensure repeatable behaviour; **Strategic** = judge the artifact against the vision document — external, slow-moving, high-level reference. Run rarely, expensive.

## 🔬 Analysis

### Root cause

The groups had grown organically rather than being designed as a partition. `quality` and `efficiency` were defined by *theme* (some clarity/redundancy dimensions landed in `efficiency`; some structural dimensions landed nowhere), and `strategic` was an over-broad bucket (`D15`–`D19`). No invariant enforced completeness or disjointness, so coverage silently drifted to 27/35.

The `optimize` group was a second symptom: it existed because "run efficiency *and apply the fixes*" had no clean expression, so a whole group name was spent encoding a `--mode` intent.

### Design decision — a disjoint, complete partition

Redefine the four headline groups so that **every dimension belongs to exactly one**, and their union is the complete set:

| Group | Count | Semantics (owner's definition) |
|---|---|---|
| `--dim quality` | 18 | Is the generated artifact **good**? (goal alignment, correctness, completeness, consistency, freshness, craft) |
| `--dim efficiency` | 8 | Does it run **economically**? (low latency + token cost) |
| `--dim reliability` | 8 | Is the behaviour **repeatable** every run? |
| `--dim strategic` | 1 | Does it still serve the **vision**? (`D15-vision-alignment` only — rare, expensive) |

$$1 + 18 + 8 + 8 = 35 \quad\text{(disjoint, complete)}$$

**Full membership:**

- **strategic** = `D15-vision-alignment`
- **quality** = `D1-metadata`, `D2-references`, `D5-boundaries`, `D6-consistency`, `D7-non-redundancy`, `D8-prioritization`, `D9-clarity`, `D10-completeness`, `D11-actionability`, `D12-staleness`, `D13-source-verification`, `D14-craftsmanship`, `D16-adherence`, `D17-cross-coherence`, `D18-coverage`, `D19-artifact-structure`, `D22-context-optimization`, `D27-model-adherence`
- **efficiency** = `D3-token-budget`, `D4-tool-alignment`, `D20-token-chain`, `D21-deterministic-first`, `D23-reference-efficiency`, `D24-handoff-efficiency`, `D25-processing-efficiency`, `D26-model-routing`
- **reliability** = `D28-reproducibility` … `D35-portability-boundary`

Key placement decisions:

- **`D7`, `D9`, `D11` moved out of efficiency → quality.** They are pure guidance-quality properties (`D7-non-redundancy` is one of the canonical six), not latency/token concerns. Removing them makes the partition disjoint.
- **`D27-model-adherence` stays in quality.** Model-adherence is an effectiveness / goal-alignment property, not latency. (The `model` convenience group therefore spans `D26` efficiency + `D27` quality — acceptable because it is a *named* convenience group, not an ambiguous alias.)
- **`strategic` narrowed to `D15` only.** The owner confirmed "strategic = vision-alignment only." The relational checks that used to live under strategic (`D16`/`D17`/`D18`/`D19`) move to `quality`, and the review prompt's **Phase 4.5** trigger now fires on `--dim strategic` (D15) **or** `--dim quality` (relational-quality D16–D19).

### Removing `optimize` without losing behavior

The `optimize` **group** is retired, but the `@pe-meta-optimizer` **agent** is unchanged. Its apply-delegation is now reached via `--dim efficiency --mode apply` — separating *dimension selection* from *mode*. This is the critical non-obvious point: deleting the group does **not** delete the optimizer.

## 🔄 What changed (reproduction of the edits)

### Contract artifacts (version-bumped + changelog)

| File | Change | Version |
|---|---|---|
| [05.07-pe-meta-dimension-catalog.md](../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) | New disjoint partition; "Which `--dim` group should I pick?" decision guide; coverage-guarantee note; `optimize` row removed; `D14-craftsmanship` sharpened; handler-mapping row reworked | v1.7.0 → **v2.0.0** (BREAKING) |
| [pe-meta-review.prompt.md](../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md) | Every `--dim optimize` → `--dim efficiency --mode apply`; Phase 4.5 trigger reworded for the strategic/quality split; frontmatter `description`, `scope.covers`, and boundary clause updated | v3.0.0 → **v3.1.0** |

### Consumers repointed (mechanical, no version bump)

- [00.02-capability-map.md](../../../../.copilot/context/00.00-prompt-engineering/00.02-capability-map.md) (cap 4.3)
- [04.04-orchestrator-runtime-validation.md](../../../../.copilot/context/00.00-prompt-engineering/04.04-orchestrator-runtime-validation.md)
- [pe-maintenance.md](../../../../.github/skills/pe-prompt-engineering-validation/checklists/pe-maintenance.md)
- [pe-meta-option-applicability-matrix.md](../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)
- [pe-meta-option-parser-tests.md](../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) (A-U03)

### Use cases (high-priority dimensions first)

`06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/`: `00-overview.md` routing table, the four folder overviews (`01-freshness`, `02-quality-gates`, `03-consumer-correctness`, `04-efficiency`) group-mapping columns, and `usecase-index.json` (6 entry points) all repointed `optimize` → `efficiency` and `strategic` → `quality` for the relational dimensions.

## ✅ Solution Implemented

- ✅ Catalog redefined as a disjoint, complete partition (1 + 18 + 8 + 8 = 35) with a coverage-guarantee blockquote.
- ✅ User-facing **"Which `--dim` group should I pick?"** decision table added.
- ✅ `optimize` group removed; apply-delegation rewired to `--dim efficiency --mode apply`; `@pe-meta-optimizer` agent retained.
- ✅ `D14-craftsmanship` sharpened — surface craft only (N-1 block separation, naming, formatting); sizing / single-responsibility explicitly delegated to `D19-artifact-structure`.
- ✅ Phase 4.5 trigger reworded (fires on `--dim strategic` for `D15`, or `--dim quality` for relational `D16`–`D19`).
- ✅ All consumers + use cases + use-case index propagated.
- ✅ Contract artifacts version-bumped (catalog 2.0.0, review prompt 3.1.0) with changelog entries.

## 📚 Additional Information

- **Convenience groups retained** as deliberately overlapping subsets for targeted runs: `structural`, `freshness`, `adherence`, `model`, `context-full`, `context-health`. These are not part of the partition and may overlap the primary four.
- **Quality is necessarily large (18 dims).** Because the four groups must cover all 35, `quality` is the catch-all "is the artifact good" bucket. The convenience subsets exist precisely to scope narrower runs within it.
- **Pre-existing catalog changelog gap** (top entry was v1.5.0 while the file read 1.7.0) was left as-is — out of scope for this change.

## ✔️ Resolution Status

**Status:** ✅ Resolved and validated.

- [x] Partition verified disjoint and complete (union = 35)
- [x] `optimize` group removed from all active artifacts
- [x] `@pe-meta-optimizer` agent and its handoff confirmed unchanged
- [x] `get_errors` clean on every edited file
- [x] `usecase-index.json` re-validated as well-formed JSON
- [x] Workspace grep confirms no active `--dim optimize` consumer remains (only immutable historical issue drafts, the meta-review run log, and rollback backups)
- [x] Contract artifacts version-bumped + changelogged

**Follow-up (optional, not blocking):**

- [ ] Reconcile the pre-existing catalog changelog version gap (v1.5.0 vs file 1.7.0) in a future maintenance pass.
- [ ] Verify the `D2-hierarchy` vs `D2-references` label inconsistency in the `04-efficiency` use-case table (pre-existing, unrelated to this change).

## 🎓 Lessons Learned

- **Group sets that must be "complete" need an enforced invariant.** Coverage drifted to 27/35 because nothing checked that the four headline groups partitioned the dimension set. A coverage-guarantee note now makes the invariant explicit; a future static check could assert it.
- **Don't spend a group name on a mode.** The `optimize` group encoded a `--mode apply` intent. Separating dimension-selection from mode (`--dim efficiency --mode apply`) removed the redundancy.
- **Retiring a group ≠ retiring its agent.** The behavioral delegation had to be rehomed before the group could be safely deleted.
- **Contract changes require version bumps + changelogs; mechanical propagation does not.** Only the two contract artifacts (catalog, review prompt) were bumped; the mechanical consumer repoints rode along without per-file bumps.

## 📎 Appendix — verification

```text
union(quality, efficiency, reliability, strategic)
  = 18 + 8 + 8 + 1 = 35   (disjoint, complete)
remaining active "--dim optimize" references = 0
  (only historical: src/docs/90. Issues drafts, 05.04 meta-review-log, .copilot/temp rollback backups)
get_errors on all edited files = clean
usecase-index.json = valid JSON
```
