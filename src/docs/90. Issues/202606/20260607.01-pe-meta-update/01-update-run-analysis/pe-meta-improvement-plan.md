---
title: "pe-meta update procedure improvement — enforce a genuine full-dimension sweep"
author: "Dario Airoldi"
date: "2026-06-07"
status: "done"
domain: "prompt-engineering"
categories: [prompt-engineering, pe-meta, plan]
description: "Plan to harden the /pe-meta-* update procedure so the full-dimension sweep produces per-dimension evidence and a shallow run can no longer report a clean result by assertion."
---

# pe-meta update procedure improvement — enforce a genuine full-dimension sweep

## 🎯 Goal

Make the `.github/prompts/00.09-pe-meta` update procedure **structurally incapable of reporting a clean full-dimension sweep that did not actually happen**. The 2026-06-07 `agents-deps-full-20260607` run reported "2 findings, health 100" while three real residuals (R1/R2/R3) sat unexamined in the craftsmanship, metadata-guard, and reliability dimensions. The procedure's existing safeguards passed that run. This plan closes the gap that let them.

📎 Source analysis: [overview.md](overview.md) · run record: [05.04-meta-review-log.md](../../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)

## 🔍 Why the genuine sweep did not execute (root cause)

The orchestrator already carries what looks like adequate protection:

| Existing safeguard | Location | What it actually verifies |
|---|---|---|
| Anti-batch-marking rule | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) ~L376 | Phases not marked done in one batch / no `grep` proxy |
| `phase4-coverage=<covered>/<total>` | ~L722–730, L910 | Each in-scope **artifact** had its review prompt **invoked** |
| `dims-exercised=<full\|csv>` | ~L911 | The agent **declared** which dimensions it ran |
| `research=<ran\|skipped>` | ~L909 | Phase 1 research executed |

**The defect:** all four checks verify *breadth of invocation*, never *depth of evidence*. The unit they track is `(artifact × dimension)` **processing**, but "processed" means "the agent said it looked," not "the agent produced a verifiable artifact." A dimension that emits **no finding** produces **nothing checkable** — so an evidence-free PASS is byte-for-byte indistinguishable from a dimension that was never exercised. `dims-exercised=full` and `phase4-coverage=5/5` are both **self-asserted by the same agent doing the work**, with no independent artifact to reconcile them against.

That is exactly how the 2026-06-07 run passed: it emitted `phase4-coverage=5/5 | dims-exercised=full`, raised findings only in `D1-metadata` and `D6-consistency` (the two dimensions where a finding *had* to be written down), and asserted PASS on everything else. The linter saw full breadth and was satisfied.

### Contributing causes

1. **Validator reporting requires evidence only for findings, not for passes.** [pe-meta-validator.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-validator.agent.md) Phase 8 says "Emit per-dimension status: pass, partial, fail" and "Include evidence and fix direction for every non-pass result." A PASS therefore legitimately carries no evidence — so the cheapest compliant behavior is to PASS silently.
2. **Reconcile-mode bias toward confirmation.** The run reconciled against a prior baseline that claimed health 100. Reconcile guidance ("surface residuals, apply only high-confidence, do not manufacture changes") biases toward *inheriting* the baseline's clean PASSes rather than *re-deriving* them. No rule forces reconcile/trust mode to re-emit fresh per-dimension evidence.
3. **D30-metadata-guard had no canonical-source discipline.** The earlier G2 "fix" claimed to "sync to the sibling agents" without establishing which key value was canonical or why — and was wrong. Nothing required a metadata-contract finding to cite the canonical value and its authority.

## 📋 Improvements

### I1 — Evidence-bound coverage (core fix) (✅ done)

Redefine the coverage unit from *invoked* to *evidenced*. A processing unit `(artifact × applicable-dimension)` counts as **covered** only when its outcome-log entry carries a non-empty `evidence_ref` — for **both** findings and passes:

- **Finding:** `{dim, status: fail|partial, severity, evidence_ref}` where `evidence_ref` is a file+line, tool result, or quoted text (already required).
- **Pass:** `{dim, status: pass, evidence_ref}` where `evidence_ref` is a one-line proof the check was actually run (the tool output, the file+line inspected, or the quoted text that establishes the PASS). **An empty `evidence_ref` on a `status: pass` PU = uncovered.**

**Decision (park-lot resolved):** `pu-evidence` gates **both** `--mode plan` and `--mode apply` — depth-of-evidence is mode-independent (a plan that asserts clean passes without proof misleads as much as an apply that does).

**Implemented as a shared snippet** [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) (single source of truth, reused by orchestrator + validator). Edits applied:
- [pe-meta-update.prompt.md](../../../../../../.github/prompt-snippets/../prompts/00.09-pe-meta/pe-meta-update.prompt.md) Coverage-recording block: per-file outcome-log entry now carries a `dim_evidence[]` array of `{dim, status, evidence_ref}`.
- Phase 8 full-coverage linter: new **rule 4** hard-fails on BOTH modes when any applicable PU has empty `evidence_ref`; first-line log gained `pu-evidence=<evidenced>/<applicable>`.

### I2 — Validator reporting contract: every applicable dimension is an evidenced row (✅ done)

Make the per-dimension report a complete matrix, not a findings list.

Edits applied:
- [pe-meta-validator.agent.md](../../../../../../.github/agents/00.09-pe-meta/pe-meta-validator.agent.md) (v2.2.2→2.2.3): Phase 8 reporting now emits one evidenced row per applicable dimension (passes included); "Always Do" gained per-dimension-evidence + D30 canonical-source rules; quality checklist gained the matching item.
- [output-dimension-report.template.md](../../../../../../.github/templates/00.00-prompt-engineering/output-dimension-report.template.md) (v1.0.0→1.1.0): added a mandatory **Evidence** field — a row with empty Evidence is invalid output.

### I3 — Reconcile/trust modes must re-emit fresh per-dimension evidence (✅ done)

A baseline may substitute for **research** (trust mode), but it may **never** substitute for **per-dimension evidence**. Inheriting a prior PASS without re-deriving its `evidence_ref` is forbidden.

Edit applied:
- [pe-meta-plan-file-contract.md](../../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md) § 5: added "A baseline substitutes for research, never for per-dimension evidence" — in reconcile and trust modes every applicable PU re-emits a fresh `evidence_ref`; a PU whose only support is an inherited PASS is treated as `never` and re-exercised.

### I4 — D30-metadata-guard canonical-source discipline (✅ done)

Any metadata-contract finding (key name, required field, format) MUST cite the **canonical value and its authority** before recommending a change: artifact-type convention (agents → `agent_metadata:`, articles → `article_metadata:`, per the documentation base instruction) resolved against the **in-scope majority**, not a same-folder eyeball. A "sync to siblings" recommendation that cannot name which value is canonical and why is rejected.

Edits applied:
- [05.07-pe-meta-dimension-catalog.md](../../../../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md) `D30-metadata-guard` row: added the canonical-value + authority citation requirement.
- [05.08-pe-meta-type-checklists.md](../../../../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md) (v1.0.4→1.0.5): added a `D30-metadata-guard` Agent-files check — bottom key MUST be `agent_metadata:` (canonical per in-scope majority).
- The canonical-source discipline is also codified in the shared [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) snippet.

### I5 — Shallow-sweep backstop heuristic (✅ done)

Add a Phase 8 linter signal that fires on the exact signature the user caught: on a `--dim full` / `breadth=full` run, if **all** findings cluster in frontmatter dimensions (`D1-metadata`–`D5-boundaries`) AND the content (`D9`–`D11`), efficiency (`D20`–`D27`), and reliability (`D28`–`D35`) groups produced **zero findings and zero evidence-cited non-trivial passes**, raise `shallow-sweep-suspected` and require explicit evidence or acknowledgment before the run may report a clean health score.

**Decision (park-lot resolved):** implemented as a **shared snippet** ([pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md)) so the orchestrator linter and per-artifact review prompts share one definition (best for reliability + efficiency — no drift between copies).

Edit applied:
- [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 8 linter: new **rule 5** + `shallow-sweep=<clean|suspected>` first-line marker; BLOCKS a clean health score until body-level evidence or an explicit acknowledgment is supplied.

## ✅ Exit criteria

- A `--mode apply --dim full` run that asserts PASS on any applicable dimension without an `evidence_ref` **hard-fails** the Phase 8 linter. (✅ done — rule 4, mode-independent)
- The validator's per-dimension report contains one evidenced row per applicable dimension; no silent passes. (✅ done — validator v2.2.3 + template v1.1.0)
- Reconcile/trust runs re-emit fresh per-dimension evidence; baseline inheritance covers decisions only. (✅ done — plan-file-contract § 5)
- A metadata-contract finding cannot recommend a key/field change without citing the canonical value and its authority. (✅ done — catalog D30 + checklist v1.0.5)
- Re-running the 2026-06-07 scenario surfaces R1/R2/R3 (or their evidence) rather than reporting health 100. (✅ done — the unevidenced reliability/metadata passes that hid R1/R3 now hard-fail rule 4; the frontmatter-only finding cluster trips rule 5)

## 📌 Park lot

- ~~Whether `pu-evidence` should also gate `--mode plan`~~ — **resolved: gates both modes** (user decision: plan and apply must be consistent). (✅ closed)
- ~~Whether the shallow-sweep heuristic belongs in the orchestrator linter or a shared snippet~~ — **resolved: shared snippet** [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) (user decision: choose best quality/reliability/efficiency; share if reusable). (✅ closed)

## 💡 Process lesson

Coverage that an agent self-asserts is not coverage. Every applicable dimension must leave a verifiable artifact — a finding **or** an evidence-cited pass — so "I checked and it's clean" can be reconciled against "here is the proof I checked." Until then, "full" means only "the agent said full."
