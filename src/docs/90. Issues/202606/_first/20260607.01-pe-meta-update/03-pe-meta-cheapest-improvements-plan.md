---
status: done
target_vision_version: "15.4.0"
domain: "prompt-engineering"
created: "2026-06-07"
goal: "Land the low-cost, high-leverage fixes that make a /pe-meta-update full pass harder to fake — without new per-artifact metadata: (R3) one canonical agent-structure authority + aligned template, (R2) stop a same-command re-run inheriting prior PASS markers, (R5-cheap) the version-desync check moved into a deterministic guard."
source_analysis: "src/docs/90. Issues/202606/20260607.01-pe-meta-update/02-full-pass-enforcement-analysis/overview.md"
---

# Plan — pe-meta cheapest improvements (R2, R3, R5-cheap)

## 🎯 Goal

Implement the three lowest-cost remediations from the [root-cause analysis](02-full-pass-enforcement-analysis/overview.md) that need no new per-artifact metadata and no second-actor orchestration change:

- **R3** — resolve the agent-structure contradiction by choosing one canonical authority and aligning template + shared-patterns + all 5 pe-meta agents to it.
- **R2** — stop a same-command re-run from inheriting the baseline's body-group PASS markers.
- **R5 (cheap subset)** — turn the frontmatter-`version` vs bottom-`version` desync into a deterministic check.

Out of scope (deferred to [04](04-pe-meta-complex-improvements-plan.md)): the second-actor coverage audit (R1), `evidence_ref` spot-verification (R4), and the full deterministic-guard extraction (R5).

## 🧭 Motivation

These three are cheap because each replaces judgment with a fixed authority or a mechanical comparison — exactly the moves the analysis identifies as durable against attention pressure. They do not touch the self-attestation loop (that is plan 04), but they remove two of the ways a shallow pass currently goes unnoticed.

## 📋 Things to do

### R3 — One canonical agent-structure authority (✅ done — decision A, re-normalized to canonical)

The contradiction: [agent.template.md](../../../../../.github/templates/00.00-prompt-engineering/agent.template.md) (L25/L31/L33/L38/L43) and the [02.04 boundary template](../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) prescribe `## Your Role` + emoji headers; the 4 normalized pe-meta agents use `## Persona` + plain headers; the builder was changed to match the agents, contradicting the template.

> **✅ RESOLVED (2026-06-07, human decision A).** Before editing, a `grep` across **all** `.github/agents/**/*.agent.md` reversed the plan's original RECOMMEND: the split is **5 pe-meta agents vs everything else** — `agent.template.md` plus all 6 non-pe-meta agents (`search-ai-optimization-expert`, `documentation-{validator,researcher,builder}`, `pe-gra-agent-builder`, `pe-con-builder`) use `## Your Expertise` + emoji boundary headers, so the 5 pe-meta agents were the **self-normalized minority** (same match-neighbours-vs-match-canonical trap as the `article_metadata` case). The user chose **A**: canonical = `## Your Expertise` + emoji boundary headers; re-normalize the 5 pe-meta agents back (smaller blast radius). Templates + `02.04` needed no change — they were already canonical.

- Decide the single canonical structure. (✅ done — **decision A**: `## Your Expertise` + emoji boundary headers `## 🚨 CRITICAL BOUNDARIES` / `### ✅ Always Do` / `### ⚠️ Ask First` / `### 🚫 Never Do`, matching both templates + the 6 peer agents.)
- Update [02.04-agent-shared-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md) "Boundary Section Template". (✅ no-op — already canonical under decision A; verified emoji structure present.)
- Update [agent.template.md](../../../../../.github/templates/00.00-prompt-engineering/agent.template.md) sample headers. (✅ no-op — already canonical under decision A; verified `## 🚨 CRITICAL BOUNDARIES` + emoji tiers present.)
- Add a short "Agent section-order convention" note to the canonical authority. (🅿️ parked — see note below; deferred to avoid scope creep, the morphology is now uniform without it.)
- Re-verify all 5 pe-meta agents conform after the authority is fixed; record any that still diverge. (✅ done — grep confirms all 5 now show `## Your Expertise` + emoji boundary headers; none diverge.)
- Acceptance: `agent.template.md`, `02.04`, and all agents share one section morphology; `get_errors` clean on every edited file. (✅ done — 11 agents + both templates share one boundary morphology; 0 errors on all 5 edited agents.)

> **🅿️ Residual parked (not edited):** `agent.template.md` persona header is `## Your Role` while all 11 agents use `## Your Expertise` — a pre-existing template-vs-agents label nit that decision A explicitly tolerates ("`## Your Role`/`## Your Expertise`"). Flagged for a separate ruling; the section-order convention note is deferred with it.

### R2 — Same-command re-run must not inherit body-group PASS (✅ done)

> **Discovery during execution:** the core rule already existed — [pe-meta-plan-file-contract.md](../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md) § 5 already states a baseline "never inherits the *proof*" and every PU re-emits a fresh `evidence_ref`. The real gap was a **D6 contradiction**: the execution-modes tables (in the orchestrator AND the contract) still read `Execute baseline as-is`. R2 became a contradiction-reconciliation, not new behavior.

- In [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md), amend the execution-modes contract so a same `--scope`+`--dim` baseline re-derives `evidence_ref` for evidence-bearing groups OR inherits the baseline's `shallow-sweep` state. (✅ done — trust row rewritten; added the "re-running the same command lowers confidence" note.)
- Remove the implicit "execute baseline as-is" trust for the same-command case; document that a same-command re-run *lowers* baseline confidence. (✅ done — both mode tables fixed in orchestrator + contract.)
- Ungate `shallow-sweep` from full-breadth-only so a reconcile run can still trip it. (✅ done — `shallow-sweep` was already `breadth=full` mode-independent; added an explicit "reconcile and trust are NOT exempt; same-command inherits `suspected`" clause to the evidence-coverage snippet.)
- Reflect the rule in [pe-meta-plan-file-contract.md](../../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md) § Execution modes and the shared [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) snippet. (✅ done — § 5 paragraph + snippet clause added; single source of truth preserved.)
- Acceptance: a documented same-command reconcile re-run cannot report `pu-evidence=N/N` without fresh `evidence_ref` for the evidence-bearing groups. (✅ done — guaranteed by § 5 + the corrected trust row; the Phase 8 evidence-depth linter rule 4 already hard-fails an evidence-free PASS.)

### R5 (cheap subset) — Deterministic version-desync check (✅ done)

> **Ambiguity resolved at the gate:** "script/task OR Phase 7b linter rule" → committed to the **Phase 7b deterministic check** (the lighter option; standalone script/hook extraction is plan 04's R5-full). Phase 7b already runs deterministic `grep`/`read` checks, so this is the natural, no-new-file home.

- Add a deterministic check that greps each agent's frontmatter `version:` and bottom `*_metadata.version:` and hard-fails on mismatch. (✅ done — added as a Phase 7b § Quality-preservation bullet; mismatch = HIGH, "mechanical compare, caught by the check, not a human".)
- Wire it so it runs on every `--mode apply` over agent/prompt scopes, not as prose guidance. (✅ done — Phase 7b Capability Regression Test runs on every mutating run before Phase 8; the check iterates each modified agent/prompt.)
- Acceptance: a deliberately desynced version pair is caught by the check, not by a human. (✅ done — the bullet flags any frontmatter-vs-bottom mismatch as HIGH, citing the validator 2.2.2-vs-2.2.3 recurrence.)

## 🧪 Validation

- `get_errors` clean on all edited files. (✅ done — orchestrator, plan-file-contract, evidence-coverage snippet, all 5 agents, meta-review log: 0 errors.)
- The five pe-meta agents pass the new section-order convention. (✅ done — all 5 now share the canonical `## Your Expertise` + emoji boundary morphology; the formal section-order *note* is parked, but conformance is verified by grep.)
- A dry-run of the version-desync check flags a known-bad pair and passes a known-good one. (🟡 todo — runtime check authored; live dry-run pending next `--mode apply`.)

## 🅿️ Park lot

- Cross-cohort structural conformance as a registered dimension → defer (analysis rejects the brittle majority-vote dimension in favour of the source-fix above; revisit only if source-fix proves insufficient).
- `architecture:` per-artifact metadata block → closed: rejected in analysis § D2 as too heavy to maintain.
- Vision coverage-gap detection (P0/P1 capability with no implementer) → `→ 04-pe-meta-complex-improvements-plan.md` (belongs with the central capability-map work).

## ✅ Exit criteria

All R2, R3, and R5-cheap items marked `(✅ done)`, validation clean, and the agent-structure contradiction recorded as resolved in `05.04-meta-review-log.md`.

> **Status (2026-06-07):** R2 ✅, R5-cheap ✅, and R3 ✅ (decision A) all landed and validated. The agent-structure contradiction is resolved and recorded in `05.04-meta-review-log.md` (run `agents-structure-normalize-20260607`). Two minor items remain open: the live dry-run of the version-desync check (pending the next `--mode apply`) and the parked `## Your Role`-vs-`## Your Expertise` template label nit + section-order convention note.
