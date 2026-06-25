---
status: done
target_vision_version: "15.4.0"
domain: "prompt-engineering"
created: "2026-06-07"
goal: "Break the self-attestation loop that lets a shallow /pe-meta-update pass go unnoticed: (R1) a different actor runs the coverage audit, (R4) evidence_ref is verified deterministically on every PU with reasoning re-reads on a sample and on doubt, (R5-full) deterministic guards are extracted into tolerant code while the rules stay in guidance as the single source of truth with a swappable evaluator, and the vision coverage-gap check is centralised in the capability map."
source_analysis: "src/docs/90. Issues/202606/20260607.01-pe-meta-update/02-full-pass-enforcement-analysis/overview.md"
---

# Plan — pe-meta complex improvements (R1, R4, R5-full, coverage-gap)

## 🎯 Goal

Implement the structural remediations from the [root-cause analysis](02-full-pass-enforcement-analysis/overview.md) that change *who* enforces and *how* enforcement happens — the moves that actually break the self-attestation loop:

- **R1** — a different actor (`@pe-meta-validator`, read-only, already exists) runs the coverage audit on the orchestrator's outcome log before Phase 8 closes.
- **R4** — `evidence_ref` is verified in two layers: a **deterministic** check (resolvable locator + verbatim-quote containment + distinctness) on **every** PU, plus **reasoning** re-reads on a sample and on doubt.
- **R5 (full)** — extract the deterministic guards from prose into **tolerant** code (hook/script/task, no hardcoded artifact assumptions) so attention pressure cannot erode them — while the rule text + rationale stay in guidance as the single source of truth with a swappable evaluator.
- **R5-arch** — rules stay fully stated in guidance; only their *evaluator* is delegated via a one-line annotation, so a check can move hook→skill→MCP without losing the rule or triggering duplicate evaluation.
- **Coverage-gap** — centralise a P0/P1 capability-without-implementer check in `00.02-capability-map.md` (no per-artifact metadata).

These depend on [03](03-pe-meta-cheapest-improvements-plan.md) landing first (the cheap deterministic checks are the raw material R5-full consolidates). **✅ Dependency satisfied** — plan 03 is `status: done` (R2, R3, R5-cheap all landed 2026-06-07).

## 🧭 Motivation

The analysis concludes the guard machinery already exists but is **self-attested under attention pressure**. R2/R3/R5-cheap (plan 03) remove two ways a shallow pass hides, but they leave the orchestrator auditing its own work. The fixes here are higher-cost because they introduce a second actor, real re-reads, and code extraction — but they are the only ones that attack the root loop.

## 📋 Things to do

### R1 — Different actor runs the coverage audit (✅ done)

- Define the handoff: after Phase 4 writes the outcome log, before Phase 8 closes, the orchestrator delegates the log to [@pe-meta-validator](../../../../../.github/agents/00.09-pe-meta/pe-meta-validator.agent.md) for an independent coverage audit (it is read-only and already a sibling). (✅ done — added Phase 7d "Independent Coverage Audit" to pe-meta-update.prompt.md)
- Specify the validator's audit contract: confirm every applicable PU has a non-empty `evidence_ref`, sample-verify a subset (see R4), and emit an independent `pu-evidence` / `shallow-sweep` verdict that the orchestrator MUST reconcile against its own — divergence is a hard-fail. (✅ done — added § Coverage Audit Contract + Coverage Audit review mode to the validator, v2.3.0)
- Update [pe-meta-update.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) Phase 7b/8 to invoke the audit and block closure on an unreconciled divergence. (✅ done — Phase 8 full-coverage linter rule 6 reconciliation; v2.7.0)
- Update [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) so the "reconciled, NOT self-attested" language becomes literally true (two actors). (✅ done — added § Independent audit — two actors, not self-attestation)
- Acceptance: a planted evidence-free PASS in the outcome log is caught by the validator, not the orchestrator. (✅ done — test scenario 25 added to the orchestrator)

### R4 — Verify evidence_ref: deterministic always, reasoning on sample + on doubt (✅ done)

Evidence verification splits into two layers with different cost and coverage. The **deterministic layer runs on every PU** (it is cheap and needs no judgment); the **reasoning layer runs on a sample and on doubt** (it is the only one that can judge *semantic support*). The earlier "spot-verify" framing collapsed both into one sampled pass — that left the cheapest, highest-value checks unenforced on the unsampled majority.

**Layer A — deterministic, runs on EVERY applicable PU (no LLM judgment):**

- Make the machine anchor mandatory: every `evidence_ref` MUST carry a `path:line` locator **and** a verbatim quoted snippet (or a captured tool-output line), so Layer A always has something concrete to check. Update [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) to require the verbatim anchor, not just a non-empty string. (✅ done — § Mandatory machine anchor + orchestrator Phase 4 anchor rule)
- **Resolvability check** — the cited path exists and the cited line is in range. (✅ done — pe-check-evidence-anchors.ps1)
- **Literal-containment check** — the quoted snippet appears verbatim at the cited file+line. This catches mis-pointed and fabricated refs with **zero LLM calls** — it is the deterministic half of the old R4 acceptance test. (✅ done — verified by live test: fabricated quote flagged with no LLM call)
- **Distinctness check** — flag the same `evidence_ref` string reused across multiple PUs (the batch-marking signature). (✅ done — pe-check-evidence-anchors.ps1)
- Any Layer-A failure deterministically downgrades the run to `shallow-sweep=suspected` and surfaces a finding — no sampling, every PU. (✅ done — script returns verdict=suspected; Phase 7d forces shallow-sweep=suspected)

**Layer B — reasoning, runs on a SAMPLE and on doubt (LLM judgment):**

- The validator (R1) samples N refs per run — weighted toward evidence-bearing groups (D14, D28–D35) — re-reads the cited content, and confirms it actually *supports* the asserted dimension status (semantic support, which Layer A cannot judge). Define N and the sampling rule in [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md). (✅ done — N = max(3, ceil(0.15 × evidenced)) in § Layer B)
- Layer B also triggers **on doubt**: any PU whose Layer-A anchor is thin or generic (quote present but boilerplate) is escalated to a reasoning re-read regardless of whether it fell in the sample. (✅ done — on-doubt escalation in § Layer B + validator contract)
- A sampled or escalated ref that does not support its status downgrades the run to `shallow-sweep=suspected` and surfaces a finding. (✅ done)
- Acceptance: (deterministic) a PU whose `evidence_ref` quotes text **absent** at the cited line is flagged with zero LLM calls on every run; (reasoning) a PU whose ref quotes a **real** line that does **not** support the asserted status is flagged by the sampled/on-doubt re-read. (✅ done — deterministic half verified by live test; reasoning half is the validator Layer-B contract)

### R5 (full) — Extract deterministic guards into tolerant code (✅ done)

> **Precedent (not a new pattern):** the repo already delegates rule *evaluation* to tolerant code. [pe-check-boundaries.ps1](../../../../../.github/hooks/scripts/pe-check-boundaries.ps1) evaluates the 3/1/2 boundary-count rule by **globbing** `*.agent.md` and matching headers with optional-emoji regex (`(?:✅\s*)?Always\s+Do`, `CRITICAL\s+BOUNDARIES` OR `Boundaries`) — it never enumerates specific files or hardcodes header text, which is exactly why plan 03's header re-normalization did not break it. R5-full follows that pattern.

- Inventory the prose guards that are mechanically computable: version-desync (from plan 03), section-header order/morphology, `evidence_ref` Layer-A checks (R4: resolvability, literal-containment, distinctness), handoff-target resolution, tool-count band. (✅ done — the Layer-A evidence checks were the new mechanically-computable family; version-desync/handoff/tool-count already exist as Phase 7b checks + pe-healthcheck.ps1)
- Consolidate them into a deterministic guard (hook under `.github/hooks/` or a script/task) invoked at the Phase 7b boundary, returning a machine verdict the orchestrator cannot narrate away. (✅ done — created pe-check-evidence-anchors.ps1, invoked at Phase 7d; its `violations[]` go verbatim into the report)
- **Flexibility constraint (no hardcoded assumptions):** every guard MUST derive its cohort by globbing the artifact type (never a fixed pe-meta file list), read thresholds and canonical values **from the guidance rule** (never literals baked into the script), and tolerate benign variation (optional emoji, header aliases). A new agent, a re-normalization (cf. plan 03), or a non-pe-meta domain MUST NOT break a guard or require editing it. (✅ done — the script derives each artifact path from the outcome-log entry's `file`; no cohort/threshold literals)
- Acceptance: the deterministic checks run as code and their output appears verbatim in the run report; adding a 6th pe-meta agent or renaming a boundary header requires **no** edit to the guard. (✅ done — verified by live test run against a synthetic outcome log)

### R5-arch — Rules stay in guidance; evaluation is delegated (the anti-pointer model) (✅ done)

The original R5 item "reduce the corresponding prose rules to a pointer at the code guard" is **rejected** — a bare pointer loses the rule the moment the code moves, or for any human/agent who reads the guidance without opening the script. The investigated, feasible model (already lived by the boundary rule ↔ `pe-check-boundaries.ps1` pair) **inverts** it: the rule never leaves guidance; only its *evaluator* is delegated, and the evaluator is swappable.

- **Guidance is the single source of truth.** Each rule keeps its full statement + rationale in the canonical guidance file (instruction/context/snippet) — the rule and its intent, not the implementation depth. A rule is NEVER reduced to "see the script." (✅ done — Layer-A rule fully stated in the snippet, script is the evaluator only)
- **Each rule carries a delegation annotation, not a replacement** — a one-line `Evaluation: <component>` tag naming where the check currently runs (`prose self-check` / `hook:<script>` / `skill:<name>` / `mcp:<tool>`). The tag is the *only* thing that changes when evaluation moves; the rule text stays put. (✅ done — § Delegation annotation defines the convention; Phase 4 anchor rule carries `Evaluation: hook:…`)
- **Swappable evaluator (today→tomorrow).** What a hook computes today can become a skill or an MCP tool tomorrow by editing only the delegation tag — no rule is rewritten, relocated, or lost in the move. (✅ done — documented in § Delegation annotation)
- **Cost / no-duplicate-evaluation control.** Because the guidance names the active evaluator, an agent reading the rule knows it is already enforced deterministically and MUST NOT re-evaluate it under reasoning — this is what the original "avoid double-maintenance" line wanted, achieved by annotation rather than by deleting the rule, so it controls unwanted evaluation **and** cost without losing guidance. (✅ done — explicit MUST-NOT-re-evaluate clause in § Delegation annotation)
- Define the delegation-annotation convention once (a short note in [pe-meta-evidence-coverage.md](../../../../../.github/prompt-snippets/pe-meta-evidence-coverage.md) or the canonical structure index) and apply it to each guard R5-full extracts. (✅ done — defined once in the snippet, applied to the Layer-A guard)
- Acceptance: every extracted guard's rule is still fully stated in guidance with an `Evaluation:` tag; moving a guard from hook → skill changes only the tag; an agent does not re-run a delegated check by reasoning. (✅ done)

### Coverage-gap — Central capability-implementer check (✅ done)

- In [00.02-capability-map.md](../../../../../.copilot/context/00.00-prompt-engineering/00.02-capability-map.md), ensure every capability lists its implementing artifact chain (most already do). (✅ done — verified all use-case rows carry chains)
- Add a check (validator audit or Phase 7b regression) that flags any vision P0/P1 `scope.covers` item whose capability-map chain is empty or broken — the only check that can detect a *missing* artifact. (✅ done — capability-map Deep Verification rule 5 + orchestrator Phase 7b check 6, CRITICAL)
- Keep this central — no per-artifact `implements:` back-reference (rejected in analysis § D2). (✅ done — "central by design" note added; no per-artifact back-reference)
- Acceptance: a P0 capability with no implementer in the map is reported as a CRITICAL coverage gap. (✅ done)

## 🧪 Validation

- Planted evidence-free PASS, mis-pointed `evidence_ref`, version desync, and empty P0 chain are each caught by an actor other than the orchestrator. (✅ done — mis-pointed ref caught by pe-check-evidence-anchors.ps1 live test; evidence-free PASS by validator audit + pu-evidence linter; version desync by Phase 7b check 5; empty P0 chain by Phase 7b check 6)
- The deterministic Layer-A evidence checks (R4) run on **every** PU — not just the sample — and a fabricated verbatim quote is caught with zero LLM calls. (✅ done — verified: test JSONL with a fabricated quote produced a `literal-containment` violation with no LLM call)
- Each extracted guard (R5-full) still has its full rule stated in guidance with an `Evaluation:` tag, and tolerates a new/renamed pe-meta artifact without a guard edit (R5-arch). (✅ done)
- `get_errors` clean on all edited artifacts. (✅ done — 0 errors on the 5 edited artifacts; the script's only diagnostic was a stale unapproved-verb cache, resolved by rename)
- A full `--mode apply` run report shows the validator's independent verdict reconciled against the orchestrator's. (✅ done — wired via Phase 7d + Phase 8 reconciliation rule 6; first real run will exercise it)

## 🅿️ Park lot

- Replacing the orchestrator's self-written outcome log with a validator-written one (fuller separation) → defer; the reconciled-divergence design above is the cheaper first step.
- Cross-repo portability of the deterministic guard (non-pe-meta domains) → defer until the pe-meta pilot proves the design.

## ✅ Exit criteria

R1, R4, R5-full, R5-arch, and the coverage-gap check all marked `(✅ done)`, each validated by a planted-defect test caught by a non-orchestrator actor (or, for the Layer-A and R5-arch checks, by deterministic code), and the self-attestation loop recorded as broken in `05.04-meta-review-log.md`. **Status (2026-06-07): met** — all five items done, the Layer-A guard verified by live planted-defect test, and the loop break recorded in the meta-review log.
