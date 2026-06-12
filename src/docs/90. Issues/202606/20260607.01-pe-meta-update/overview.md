---
title: "Issue: /pe-meta-update reports a 'full pass' that is actually a shallow metadata sweep"
author: "Dario Airoldi"
date: "2026-06-07"
status: "In Progress"
categories: [issue, prompt-engineering, pe-meta, process]
description: "Recurring failure where /pe-meta-update --mode apply reports a complete full-dimension pass that, on inspection, only exercised frontmatter dimensions — root-cause analysis and remediation plans."
draft: true
---

# Issue Report

**Issue Title:** `/pe-meta-update` reports a "full pass" that is actually a shallow metadata sweep

**Date Reported:** 2026-06-07
**Reporter:** Dario Airoldi
**Status:** In Progress
**Severity:** High
**Component:** PE meta-system (`.github/prompts/00.09-pe-meta/`, `.github/agents/00.09-pe-meta/`)
**Framework:** GitHub Copilot customization framework (VS Code)

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Direction](#-solution-direction)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Summary

`/pe-meta-update <scope> --mode apply` (and any full-breadth run) repeatedly reports a complete "Phases 1–4 / full-dimension" pass that, on inspection, only genuinely exercised **frontmatter dimensions** (`D1-metadata`, `D6-consistency`). Content, craftsmanship, efficiency, and reliability dimensions are asserted PASS **without body-level evidence**. The clean report is indistinguishable from a genuine full pass, so silent degradation goes unnoticed until a human re-audits by hand.

### Observed symptom

A run reports e.g. **"2 findings, health 100/100"** with both findings living in frontmatter, and everything else "clean" — the textbook shallow-review signature.

### Impact

| Impact point | Effect |
|---|---|
| Trust | Clean reports cannot be trusted; every "full pass" needs a human re-audit |
| Quality | Real residuals (encoding, metadata-key, rollback, structural divergence) survive multiple "full" runs |
| Cost | The system pays for a full pass and delivers a metadata grep |
| Recurrence | Four challenges in one week — the guard machinery exists but keeps being bypassed |

---

## 🔍 Context Information

### Environment

| Item | Value |
|---|---|
| Repository | `darioairoldi/Learn` (branch `main`) |
| Orchestrator | [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) v2.5.0 (9-phase pipeline) |
| Dimension catalog | `05.07-pe-meta-dimension-catalog.md` v1.5.0 — 35 dimensions |
| Coverage contract | [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) (`pu-evidence`, `shallow-sweep`) |
| Affected agents | 5 pe-meta agents under `.github/agents/00.09-pe-meta/` |

### Existing guard machinery (present, yet bypassed)

`pu-evidence` marker · `shallow-sweep` heuristic · Phase 8 full-coverage linter (5 rules) · anti-batch-marking · JSONL outcome log. The machinery is **comprehensive** — the failure is not a missing guard.

---

## 🔬 Analysis

### Root cause analysis

Five root causes block a genuine full-pass-in-all-details:

| # | Root cause | Evidence |
|---|---|---|
| **R1** | **Self-attestation loop** — every coverage guard is computed by the *same* orchestrator from an outcome log the *same* orchestrator writes. "Reconciled, NOT self-attested" is aspirational; there is no second actor. | Phase 8 linter; repo memory `pe-meta-shallow-review-gap.md` |
| **R2** | **Unsound trust/reconcile inheritance** — reconcile/trust inherits the baseline's PASS markers. The premise is **backwards**: re-running the *same* command signals doubt, not trust. `shallow-sweep` is gated on full-breadth, so reconcile dodges it. | execution-modes table (`trust` = "execute baseline as-is") |
| **R3** | **Coverage hole + contradicted canonical source** — no dimension compares an artifact's section-header set against its cohort, so the builder's morphological divergence was invisible. Worse, `agent.template.md` + the `02.04` boundary template prescribe `## Your Role` + emoji headers, while the four normalized agents use `## Persona` + plain — no single craftsmanship authority resolves which is canonical. | [agent.template.md](../../../../../.github/templates/00.00-prompt-engineering/agent.template.md); [02.04-agent-shared-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) |
| **R4** | **Depth not enforced per processing unit** — the `pu-evidence` contract closed the *counting* hole but only checks `evidence_ref` is *non-empty*, not that it *supports* the asserted status. | [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) |
| **R5** | **Attention dilution** — prose guards executed by the same LLM under token/compaction pressure get narrated as done rather than performed. | recurrence log 2026-06-06 (reported full review, did metadata-only backfill) |

### Two failure classes

| Class | Causes | What fails | Remedy shape |
|---|---|---|---|
| **Depth / enforcement** | R1, R2, R4, R5 | Check exists but is faked, skipped, or trusted away | Different actor + deterministic code |
| **Coverage** | R3 | No check exists for the property | Fix at the source (craftsmanship guidance) |

### Two corrected design decisions

1. **R2's trust premise is backwards** — a same-command re-run must *lower* baseline confidence, not authorise skipping evidence re-derivation.
2. **R3 is solved by craftsmanship guidance, not per-artifact metadata** — the heavy `architecture:` block (`cohort`/`role`/`implements`/`vision`/`usecases`) is rejected as too costly to maintain; vision coverage stays central in `00.02-capability-map.md`.

### Affected workflows

Every `/pe-meta-*` review/update over agent, prompt, instruction, and context scopes that runs at `--dim full` or in reconcile/trust mode.

---

## 🔄 Reproduction Steps

1. Run `/pe-meta-update '.github\agents\00.09-pe-meta' --mode apply --deps all`.
2. Observe the report: small finding count, all findings in frontmatter dimensions, health 100.
3. Hand-audit the 5 agent **bodies** against `D14-craftsmanship`, `D30-metadata-guard`, `D32-rollback-readiness`, `D28–D35`.
4. Observe residuals the run asserted-but-did-not-demonstrate (encoding corruption, non-canonical metadata key, missing rollback declaration, cross-sibling structural divergence).

### Affected code locations

| Location | Role |
|---|---|
| [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) | Orchestrator — Phase 8 linter, execution-modes table |
| [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) | `pu-evidence` / `shallow-sweep` contract |
| [agent.template.md](../../../../../.github/templates/00.00-prompt-engineering/agent.template.md) | Canonical agent scaffolding (contradicts agents) |

---

## ✅ Solution Direction

Remediation is split into two plans (not yet executed — both `status: draft`):

### Cheapest improvements — [03-pe-meta-cheapest-improvements-plan.md](03-pe-meta-cheapest-improvements-plan.md)

- **R3** — pick one canonical agent-structure authority; align template + `02.04` + all 5 agents.
- **R2** — same-command re-run must not inherit body-group PASS; ungate `shallow-sweep`.
- **R5-cheap** — deterministic frontmatter-vs-bottom `version` desync check.

### Complex improvements — [04-pe-meta-complex-improvements-plan.md](04-pe-meta-complex-improvements-plan.md)

- **R1** — `@pe-meta-validator` (read-only) runs an independent coverage audit before Phase 8.
- **R4** — spot-verify `evidence_ref` (re-read cited file+line).
- **R5-full** — extract deterministic guards from prose into code.
- **Coverage-gap** — central P0/P1-capability-without-implementer check in `00.02-capability-map.md`.

### Root-cause detail

Full evidence and rationale: [02-full-pass-enforcement-analysis/overview.md](02-full-pass-enforcement-analysis/overview.md).

---

## 📚 Additional Information

### Testing recommendations

- Plant an evidence-free PASS, a mis-pointed `evidence_ref`, a version desync, and an empty P0 capability chain; confirm each is caught by an actor **other than** the orchestrator.

### Migration considerations

- The agent-structure authority change touches `agent.template.md`, `02.04`, and all 5 pe-meta agents in one coordinated edit to avoid a new three-way divergence.

### Performance impact

- The second-actor audit (R1) adds one read-only delegation per run; the deterministic guards (R5) reduce per-run LLM reasoning by moving mechanical checks to code.

---

## ✔️ Resolution Status

**Current status:** Analysis complete; remediation plans drafted; implementation pending approval.

### Verification checklist

- [x] Root causes identified and evidenced (R1–R5)
- [x] Two corrected design decisions recorded
- [x] Cheapest-improvements plan drafted (03)
- [x] Complex-improvements plan drafted (04)
- [ ] Plan 03 passes actionability gate and is executed
- [ ] Plan 04 passes actionability gate and is executed
- [ ] Agent-structure contradiction resolved across template + 02.04 + agents

### Follow-up actions

1. Resolve the `agent.template.md` ↔ `02.04` ↔ agents three-way structural contradiction (plan 03, R3).
2. Break the self-attestation loop via a second-actor audit (plan 04, R1).

---

## 🎓 Lessons Learned

### What went wrong

- A comprehensive guard machinery was trusted to enforce depth, but every guard was **self-attested by the same actor** that produced the work — so an evidence-free PASS was indistinguishable from a dimension never run.
- "Match the neighbours" was mistaken for "match the canonical source" twice (the `article_metadata` key, then the builder boundary headers).

### What went right

- Persistent user skepticism of clean reports surfaced real residuals every time.
- The `pu-evidence` / `shallow-sweep` contract closed the counting hole and made the *depth* gap nameable.

### Improvements for the future

- "Full" must mean **evidence cited per dimension group by an actor other than the one that did the work**, with deterministic checks moved into code where attention pressure cannot erode them.
- A run reporting findings **only** in frontmatter dimensions should be treated as suspect by default.

---

## 📎 Appendix

### Related documents

- [02-full-pass-enforcement-analysis/overview.md](02-full-pass-enforcement-analysis/overview.md) — root-cause analysis
- [03-pe-meta-cheapest-improvements-plan.md](03-pe-meta-cheapest-improvements-plan.md) — R2 / R3 / R5-cheap
- [04-pe-meta-complex-improvements-plan.md](04-pe-meta-complex-improvements-plan.md) — R1 / R4 / R5-full / coverage-gap
- [01-update-run-analysis/overview.md](01-update-run-analysis/overview.md) — the run audit that first exposed the shallow signature

### Related issues

- Prior same-class recurrences logged in `05.04-meta-review-log.md` (2026-06-06 instruction-files run; 2026-06-07 agents run)
