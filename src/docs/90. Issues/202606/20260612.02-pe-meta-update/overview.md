---
title: "Issue: pe-meta agent cohort carries two divergent non-canonical bottom-metadata field sets"
author: "Dario Airoldi"
date: "2026-06-12"
status: "In Progress"
categories: [issue, prompt-engineering, pe-meta, metadata, consistency]
description: "A /pe-meta-update full-cohort run surfaced that the five pe-meta agents carry two different non-canonical bottom agent_metadata extension patterns (filename/type vs created_by), neither of which appears in the canonical metadata contract."
draft: true
---

# Issue Report

**Issue Title:** pe-meta agent cohort carries two divergent non-canonical bottom-metadata field sets

**Date Reported:** 2026-06-12
**Reporter:** Dario Airoldi
**Status:** In Progress
**Severity:** Low
**Component:** PE meta-system agents (`.github/agents/00.09-pe-meta/`)
**Framework:** GitHub Copilot customization framework (VS Code)

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution direction](#-solution-direction)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Summary

A full-cohort `/pe-meta-update --mode=apply --scope=.github/agents/00.09-pe-meta/ --deps=full` run read all five pe-meta agent bodies and reconciled them against the three canonical metadata authorities. The cohort is otherwise healthy (all five were edited on 2026-06-12 for vision v15.6.0), but the bottom `agent_metadata` blocks carry **two different non-canonical extension patterns**. Neither pattern is enumerated in the canonical bottom-block contract.

### Observed symptom

The five agents split into two camps on which extra fields they tack onto the required `version` / `last_updated`:

| Camp | Agents | Extra (non-canonical) fields |
|---|---|---|
| A | `pe-meta-validator`, `pe-meta-builder` | `filename:`, `type:` |
| B | `pe-meta-designer`, `pe-meta-researcher`, `pe-meta-optimizer` | `created_by:` |

All five pass the *required-field* check; the divergence is purely in which non-canonical extras each carries.

### Impact

| Impact point | Effect |
|---|---|
| Consistency | A single five-agent cohort presents two metadata shapes, undermining "one cohort, one schema" |
| Drift risk | `filename:` duplicates the on-disk name and silently goes stale on any rename |
| Authority clarity | The canonical contract enumerates four bottom-block fields; the extras have no declared owner or consumer |
| Severity | **Low** — no tooling reads these fields; effect is cosmetic/maintenance, not functional |

---

## 🔍 Context information

### Environment

| Item | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Invocation | `/pe-meta-update --mode=apply --scope=.github/agents/00.09-pe-meta/ --deps=full` |
| Breadth / source / dim | `full` / `all` / `full` |
| Bundle | `single-domain` (all five agents + closure are `prompt-engineering`) |
| Affected agents | 5 agents under [.github/agents/00.09-pe-meta/](../../../../../.github/agents/00.09-pe-meta/) |

### Canonical authorities consulted

| Authority | Bottom-block contract |
|---|---|
| [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) (v1.3.0) | Universal bottom-block fields: `version` (MUST), `last_updated` (MUST), `created` (SHOULD), `changelog` (OPTIONAL) |
| [pe-agents.instructions.md](../../../../../.github/instructions/pe-agents.instructions.md) (v1.13.0) | Bottom `agent_metadata` requires `version` + `last_updated`; `created`/`changelog` optional. Does not list `filename`/`type`/`created_by` |
| [agent.template.md](../../../../../.github/templates/00.00-prompt-engineering/agent.template.md) | Example bottom block uses only `version`, `last_updated`, `created`, `changelog` |

**None** of the three authorities enumerates `filename:`, `type:`, or `created_by:` as agent bottom-block fields.

---

## 🔬 Analysis

### Root cause

| # | Root cause | Evidence |
|---|---|---|
| R1 | **No closed-set rule.** `00.03` lists required/should/optional fields but does not explicitly declare the bottom block a *closed* set, so historical extras were never flagged. | `00.03` "Universal bottom-block fields" table (no prohibition clause) |
| R2 | **Two authoring lineages.** Camp A (`filename`/`type`) and Camp B (`created_by`) reflect different creation eras/templates that were never reconciled when the cohort was normalized. | `created:` dates differ (validator/builder vs the 2026-03-08 trio) |
| R3 | **No dimension compares bottom-block field *shape* across a cohort.** The metadata-guard dimension checks required-field presence, not extra-field consistency. | dimension catalog — `D30-metadata-guard` checks presence, not closed-set parity |

### Why it stayed invisible

The required-field conformance check passes for all five (each has `version` + `last_updated` in the bottom block, none in top frontmatter). A run that only verifies *required* fields reports a clean metadata dimension while the *extras* silently diverge — a narrower cousin of the documented shallow-sweep failure mode.

### Secondary finding (same run)

A typo was found in the `pe-meta-designer` bottom rationale: `"...design specifications dont prematurely modify artifacts"` — `dont` should be `don't`. Cosmetic, high-confidence, `D14-craftsmanship`.

### Affected workflows

Any `/pe-meta-*` review over the agent cohort that asserts a clean `D1-metadata` / `D6-consistency` pass without comparing bottom-block field *shape* across siblings.

---

## 🔄 Reproduction steps

1. Run `/pe-meta-update --mode=apply --scope=.github/agents/00.09-pe-meta/ --deps=full`.
2. Read the bottom `agent_metadata` HTML comment in each of the five agent files.
3. Compare the field sets: validator/builder carry `filename:` + `type:`; designer/researcher/optimizer carry `created_by:`.
4. Cross-check against [00.03-metadata-contracts.md](../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) — confirm none of the three extras is canonical.

### Affected code locations

| Location | Role |
|---|---|
| [pe-meta-validator.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-validator.agent.md) | Camp A — `filename:`, `type:` |
| [pe-meta-builder.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-builder.agent.md) | Camp A — `filename:`, `type:` |
| [pe-meta-designer.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-designer.agent.md) | Camp B — `created_by:`; plus `dont` typo |
| [pe-meta-researcher.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md) | Camp B — `created_by:` |
| [pe-meta-optimizer.agent.md](../../../../../.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md) | Camp B — `created_by:` |

---

## ✅ Solution direction

Two options were surfaced; neither was auto-applied (agent files require user approval for all changes, and stripping non-required fields risks a manufactured normalization).

| Option | Action | Trade-off |
|---|---|---|
| **A (recommended)** | Normalize all five to the canonical set — keep `version`/`last_updated`/`created`/`changelog`, drop `filename:`, `type:`, `created_by:`. Patch-bump each. | Matches the enumerated contract; removes `filename:` rename-drift; one cohort, one shape |
| **B** | Leave as-is. | No manufactured churn — all five pass the required-field check |

A durable fix would also clarify whether the bottom block is a **closed set** in `00.03` and add a cohort field-shape parity check to `D30-metadata-guard` so future divergence is caught automatically.

The `pe-meta-designer` typo fix (`dont` → `don't`) is independent, high-confidence, and applicable under either option.

---

## 📚 Additional information

- No workspace tooling consumes `filename:`, `type:`, or `created_by:` — the `MetadataWatcher` C# source is not present in the current tree, and no script greps these keys.
- Capability counts across the cohort (researcher 8, builder 6, validator 6, designer 5, optimizer 4) exceed the instruction's "3–5" soft guideline but represent the established cohort norm — parked, not a per-file defect.
- The cohort-wide absence of a `model:` field is out of scope for this single-folder run — parked.

---

## ✔️ Resolution status

**Current status:** Findings surfaced; awaiting user direction on Option A vs B before any apply.

### Verification checklist

- All five agent bodies read in full and reconciled against the three canonical authorities. (✅ done)
- Bottom-block field divergence confirmed across the cohort. (✅ done)
- Canonical contract confirmed to list neither `filename`/`type` nor `created_by`. (✅ done)
- No tooling consumer of the extra fields found. (✅ done)
- Designer `dont` typo confirmed. (✅ done)
- User decision on normalization direction (Option A or B). (🟡 todo)
- Apply approved changes with per-file patch bump + changelog entry. (🟡 todo)
- Clarify closed-set rule in `00.03` and add cohort field-shape parity check. (📌 next steps)

---

## 🎓 Lessons learned

### What went right

- The run reconciled against the *declared authority* (contract + instruction + template) before flagging divergence, avoiding the "match neighbours ≠ match canonical" false-premise trap.
- The cohort was split with no clean majority, so canonical authority — not majority vote — was used as the tiebreaker.

### What to improve

- A required-field-only metadata check reports clean while extras diverge. Metadata dimensions should compare bottom-block field *shape* across a cohort, not just presence of required fields.
- `00.03` should state explicitly whether the bottom block is a closed set, removing the ambiguity that let two extension patterns coexist.

---

## 📎 Appendix

### Canonical bottom-block field set (00.03 v1.3.0)

| Field | Required | Purpose |
|---|---|---|
| `version:` | MUST | SemVer |
| `last_updated:` | MUST | Date of most recent change |
| `created:` | SHOULD | Creation date |
| `changelog:` | OPTIONAL | Pointer to sibling `*.changelog.md` |

### Observed cohort divergence

```text
validator : version, last_updated, filename, type, created, changelog
builder   : version, last_updated, filename, type, created, changelog
designer  : version, last_updated, created_by, created, changelog
researcher: version, last_updated, created_by, created, changelog
optimizer : version, last_updated, created_by, created, changelog
```

<!--
article_metadata:
  filename: "overview.md"
  version: "1.0.0"
  last_updated: "2026-06-12"
-->
