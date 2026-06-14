---
title: "Why the pe-meta 'full pass' keeps coming up shallow — root-cause analysis"
author: "Dario Airoldi"
date: "2026-06-07"
status: "draft"
domain: "prompt-engineering"
categories: [prompt-engineering, pe-meta, review, process]
description: "Consolidated root-cause analysis of the recurring shallow-'full pass' failure in /pe-meta-update: five root causes (self-attestation, unsound trust-inheritance, catalog coverage holes, unenforced depth, attention dilution), the two failure classes underneath them, and two corrected design decisions from this investigation (the trust-inheritance premise is backwards; structural conformance is solved by craftsmanship guidance, not per-artifact metadata)."
---

# Why the pe-meta "full pass" keeps coming up shallow — root-cause analysis

## 🎯 Why this analysis exists

Across four challenges in one week, `/pe-meta-update <scope> --mode apply` repeatedly reported a complete "full pass" that, on inspection, was not one. Each time the user — correctly — distrusted the clean report and a hand-pass found residuals the run had asserted-but-not-demonstrated:

- A run that reported "2 findings, health 100" while both findings lived in frontmatter dimensions (the [01-update-run-analysis](../01-update-run-analysis/overview.md) audit).
- A reconcile re-run that inherited a same-day baseline's PASS markers.
- A third challenge that surfaced a cross-sibling structural divergence (the builder's `## Your Expertise` + emoji boundary headers vs four siblings' `## Persona` + plain headers) that **no dimension checks**.

This document consolidates **why** the failure recurs despite a comprehensive guard machinery (`pu-evidence`, `shallow-sweep`, the Phase 8 full-coverage linter, anti-batch-marking, the JSONL outcome log), and records two design corrections made during this investigation. It is the shared rationale for the two remediation plans:

- [03-pe-meta-cheapest-improvements-plan.md](../03-pe-meta-cheapest-improvements-plan.md) — low-cost, high-leverage fixes.
- [04-pe-meta-complex-improvements-plan.md](../04-pe-meta-complex-improvements-plan.md) — structural fixes that break the self-attestation loop.

**Verdict:** the machinery is not missing — it is **self-attested under attention pressure**, with one true coverage hole and one unsound trust assumption. Adding more prose guidance will not fix it.

## 📋 Root causes blocking a genuine full-pass-in-all-details

| # | Root cause | Evidence | Fix direction | Plan |
|---|---|---|---|---|
| **R1** | **Self-attestation loop.** Every coverage guard (`phase4-coverage`, `pu-evidence`, `shallow-sweep`, the Phase 8 linter) is computed by the *same* orchestrator from an outcome log that *same* orchestrator writes. "Reconciled from outcome log, NOT self-attested" is aspirational — there is no second actor. The fox audits the henhouse. | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 8 linter; repo memory `pe-meta-shallow-review-gap.md` "SELF-ATTESTATION" | A **different actor** runs the coverage audit — hand the outcome log to `@pe-meta-validator` (read-only, already exists) before Phase 8 closes. | 04 |
| **R2** | **Unsound trust/reconcile inheritance.** Reconcile/trust inherits the baseline's prior PASS markers instead of re-deriving body evidence. The premise is **backwards**: re-running the *same* command is a signal the prior pass was incomplete or that conditions changed — not a licence to trust it. `shallow-sweep` is also gated on full-breadth, so a reconcile run presents as already-covered and never trips it. | [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) execution-modes table — `trust` row = "execute baseline as-is"; memory "RECONCILE BYPASS" | A same-command re-run MUST NOT inherit body-group PASS; it re-derives `evidence_ref` for evidence-bearing dimensions OR inherits the baseline's `shallow-sweep=suspected` state. | 03 |
| **R3** | **Coverage hole + contradicted canonical source.** No dimension compares an artifact's section-header set against its cohort, so the builder's morphological divergence was invisible to D6/D14/D17/D19 (each reads one body). Worse, the canonical scaffolding **disagrees with practice**: `agent.template.md` and the `02.04` boundary template prescribe `## Your Role` + emoji headers, while the four normalized agents use `## Persona` + plain headers. There is no single craftsmanship authority that resolves which is canonical. | [agent.template.md](../../../../../../.github/templates/00.00-prompt-engineering/agent.template.md) L25/L31/L33/L38/L43; [02.04-agent-shared-patterns.md](../../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) "Boundary Section Template"; memory "NO CROSS-SIBLING DIMENSION" | Fix at the **source**: pick one canonical agent structure, align template + shared-patterns + all agents to it (craftsmanship guidance), so the shape is never wrong — rather than a cross-sibling dimension that fires after the fact. | 03 |
| **R4** | **Depth not enforced per processing unit.** Historically a dimension PASS required no evidence, so an evidence-free PASS was indistinguishable from a dimension never run. The `pu-evidence`/`shallow-sweep` contract (v2.5.0) closed the *counting* hole but still only checks that an `evidence_ref` string is *non-empty* — not that it actually supports the asserted status. | [pe-meta-evidence-coverage.md](../../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md); memory "STRUCTURAL FIX" | **Spot-verify** `evidence_ref` — sample N refs per run, re-read the cited file+line, confirm it supports the status. Self-attested → spot-checked. | 04 |
| **R5** | **Attention dilution.** The guards that exist are prose instructions executed by the same LLM under token/compaction pressure. Late in a long run they lose attention and get narrated as done rather than performed — the original "Phases 1–4 complete" that was actually a frontmatter grep. | memory recurrence log 2026-06-06 (reported full review, did metadata-only backfill) | **Move deterministic guards into code** (hook/script/task): frontmatter-`version` vs bottom-`version` match, section-header order check, `evidence_ref` non-empty count — none require LLM judgment. | 03 (cheap subset) / 04 (full) |

## ⚖️ The two failure classes underneath

The five causes resolve into two classes that need different remedies:

| Class | Causes | What fails | Remedy shape |
|---|---|---|---|
| **Depth / enforcement** | R1, R2, R4, R5 | The check exists but is faked, skipped, or trusted away | Move enforcement to a **different actor** and/or to **deterministic code** |
| **Coverage** | R3 | No check exists for the property (cross-cohort structure) | Fix at the **source** (craftsmanship guidance), not by adding a brittle dimension |

The single highest-leverage move is shifting enforcement off the self-attesting orchestrator (R1, R5) — because that is the loop that lets R2 and R4 hide.

## 🧭 Two corrected design decisions from this investigation

### D1 — The trust-inheritance premise (R2) is backwards

The execution-modes table treats a same-day "done" baseline as trustworthy and lets `trust`/`reconcile` skip re-derivation. But trusting a same-day baseline assumes (a) no condition changed since, and (b) the earlier pass was perfectly successful. **Neither holds when a user re-runs the same command** — the re-run is itself the evidence of doubt. The trust gradient must be inverted: a same-command re-run should *lower* confidence in the baseline, not authorise skipping evidence re-derivation.

### D2 — Structural conformance (R3) is solved by craftsmanship guidance, not per-artifact metadata

An earlier proposal added an `architecture:` frontmatter block to every artifact (`cohort` / `role` / `implements` / `vision` / `usecases`) so a vision-anchored cross-artifact check could replace brittle majority-vote. **Rejected as too heavy:** every artifact would carry it, every rename would have to update it, and a stale `implements:` list is just a new drift source. The `D14-craftsmanship` structural problem is better solved by:

1. **Context guidance** — a canonical agent-structure section (section order, `## Persona`, plain boundary headers, no emoji) that makes the correct shape the path of least resistance.
2. **An aligned agent template** with sample section headers, so new agents are born correct.

Vision **coverage** (which P0/P1 capabilities have an implementer) stays **central** in `00.02-capability-map.md` — one document to keep current, not one block per artifact.

## ⚠️ Open contradiction this analysis surfaced

The B1/B2 "normalize the builder to match its siblings" fix moved the builder **toward** the four siblings but **away** from the documented `agent.template.md` and the `02.04` boundary template, which both still prescribe `## Your Role` + emoji headers. So five agents now contradict their own canonical scaffolding. This is the same false-premise trap as the earlier `article_metadata` case: "match the neighbours" is not the same as "match the canonical source." Plan 03 must resolve the three-way divergence (template ↔ shared-patterns ↔ agents) by choosing one authority, not by assuming the majority is right.

## 💡 Process lesson

A run that reports findings **only** in frontmatter dimensions, or that inherits a same-day baseline's PASS markers, should be treated as suspect — not as evidence of a clean system. "Full" must mean **evidence cited per dimension group by an actor other than the one that did the work**, with the deterministic checks moved into code where attention pressure cannot erode them.
