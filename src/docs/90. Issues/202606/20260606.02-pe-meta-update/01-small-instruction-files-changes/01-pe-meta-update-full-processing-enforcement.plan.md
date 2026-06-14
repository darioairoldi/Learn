---
status: done
target_vision_version: "15.4.0"
domain: "prompt-engineering"
created: "2026-06-06"
goal: "Harden pe-meta-update.prompt.md so a --mode apply full-breadth run cannot silently collapse into a frontmatter-only metadata scan — make Phase 1 research, Phase 4 per-artifact review coverage, and --dim full dimension breadth observable and enforced by a Phase 8 linter, then re-run the instruction-set review properly."
run_id: "instructions-full-processing-enforcement-20260606"
related_issue: "src/docs/90. Issues/202606/20260606.02-pe-meta-update/01-small-instruction-files-changes/overview.md"
---

# Plan — pe-meta-update full-processing enforcement

## 🎯 Goal

Make `/pe-meta-update <multi-file-scope> --mode apply` honor the vision v15.4 default-full contract **verifiably**: every audit phase must run its mandated delegation, Phase 4 must invoke the per-artifact review prompt for **every** in-scope file, and `--dim full` must exercise the full applicable dimension set — with a Phase 8 linter that **blocks** the report when any of these is unmet. Then re-run the `.github/instructions/` review properly to produce the genuine improvement plan the original run should have generated.

This closes the systemic root cause documented in the analysis: a load-bearing `MUST` (delegate / route via matrix) with **no runtime invariant**, the same failure class as the plan-file gap fixed in `pe-meta-update.prompt.md` v2.3.1.

## 🧭 Resolved invocation

```text
Resolved invocation: --mode=plan --scope=.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md --source= --dim=full --start=none --end=none --deps=direct --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260606.02-pe-meta-update/01-small-instruction-files-changes/01-pe-meta-update-full-processing-enforcement.plan.md | spillover=none
```

Execution mode: **fresh** (no baseline). Scope of THIS plan = the orchestrator prompt fix plus a verified re-run of the instruction-set review.

## 📋 Goal table

| # | Finding | Target file | Scope tag | Principle impact | Downstream landing | Status |
|---|---|---|---|---|---|---|
| F1 | First-line log carries no phase-execution / coverage / dimension evidence — a shallow run is indistinguishable from a full one | `pe-meta-update.prompt.md` | in-scope | strengthens `verification-before-completion` | Phase 8 first-line log spec | (✅ done) |
| F2 | No Phase 8 linter enforces research-ran / Phase 4 coverage / dimension breadth on full-breadth apply | `pe-meta-update.prompt.md` | in-scope | strengthens `verification-before-completion` | Phase 8 § linter | (✅ done) |
| F3 | Per-artifact review invocations are not recorded per file, so body-level audit cannot be proven | `pe-meta-update.prompt.md` | in-scope | none (observability) | Phase 4 + outcome-log spec | (✅ done) |
| F4 | Embedded test inventory does not assert full-coverage enforcement | `pe-meta-update.prompt.md` | in-scope | strengthens `verification-before-completion` | test scenarios | (✅ done) |
| F5 | Execution-discipline guidance does not forbid batch-marking audit phases | `pe-meta-update.prompt.md` | in-scope | none (discipline) | Phase ordering note | (✅ done) |
| F6 | The `.github/instructions/` set was never genuinely reviewed (only a domain backfill) | `.github/instructions/*` | follow-up | none (deferred work) | sibling re-run + new plan | (📌 next steps) |

## ⚙️ Actionable items (execution-ready)

### F1 — Add phase-execution / coverage / dimension evidence markers (✅ done)

- Extend the Phase 8 first-line `Resolved invocation:` log shape with three new markers appended after `spillover=…`: `research=<ran|skipped|n-a>`, `phase4-coverage=<covered>/<total>`, `dims-exercised=<full|csv-of-D#>`. (✅ done — added to the log-shape code block plus a `v15.4 coverage-evidence markers` prose block defining each marker)
- Require the identical extended line to be emitted BEFORE Phase 1 runs and echoed in the Phase 8 report. (✅ done — existing emit-before-Phase-1 + Phase-8-echo requirement covers the extended shape)
- Bump `pe-meta-update.prompt.md` frontmatter `version` (minor) and append a changelog entry. (✅ done — v2.3.2 → v2.4.0 with changelog)

### F2 — Add the Phase 8 full-coverage linter (mirrors the plan-file linter) (✅ done)

- Add a new MANDATORY self-check sub-section under Phase 8 (adjacent to the existing first-line-log linter) that runs before the report is emitted and BLOCKS on violation. (✅ done — `#### Full-coverage linter (MANDATORY — full-processing invariant)`)
  - Rule 1 — **research-ran:** if `breadth=full` AND `--mode apply` AND `research=skipped`, hard failure (`full-breadth apply skipped non-skippable Phase 1 research`). (✅ done)
  - Rule 2 — **Phase 4 coverage:** if `--mode apply` AND `phase4-coverage` numerator < denominator (i.e., the per-artifact review prompt was not invoked for every in-scope file), hard failure. (✅ done)
  - Rule 3 — **dimension breadth:** if `--dim full` AND `dims-exercised` is a strict subset of the applicable dimension set for the resolved artifact type(s), hard failure. (✅ done — references `05.07-pe-meta-dimension-catalog.md`)
  - On violation: BLOCK the report, surface the specific rule, and either resume the missing phase work or escalate to the user — NEVER publish a report whose evidence markers contradict a full-breadth claim. (✅ done — Rule 4)
- Cross-reference the linter to the related issue and to the plan-file linter as the precedent pattern. (✅ done)

### F3 — Record per-artifact review invocations in the outcome log (✅ done)

- Specify that Phase 4, on invoking the matrix-selected `pe-meta-{type}-review` prompt for each in-scope file, writes a coverage entry to `.copilot/temp/pe-meta-state/outcomes/<run-id>.jsonl` (e.g., `{"phase":4,"file":"<path>","prompt":"pe-meta-instruction-review","bodies_read":true}`). (✅ done — added the `Coverage recording (MANDATORY)` block to Phase 4-Research with a `bodies_read` + `dims[]` entry shape)
- Specify that the F2 linter computes `phase4-coverage` by reconciling these entries against the resolved in-scope file set. (✅ done — stated in both the Phase 4 block and linter Rule 2)

### F4 — Extend embedded test scenarios (✅ done)

- Add a scenario asserting that a full-breadth apply emitting `research=skipped` is BLOCKED. (✅ done — scenario 21)
- Add a scenario asserting that `phase4-coverage` < 100% of in-scope files is BLOCKED. (✅ done — scenario 22)
- Add a scenario asserting that `--dim full` with a strict-subset `dims-exercised` is BLOCKED. (✅ done — scenario 23)

### F5 — Encode execution discipline against batch-marking (✅ done)

- Add a short rule to the Phase ordering / execution note: audit phases (1, 1.5, 2, 3, 4) MUST be marked in-progress and completed **one at a time** with the mandated delegation performed between transitions; batch-marking audit phases complete is prohibited. (✅ done — Pipeline-phases Rule #3)

### F6 — Re-run the instruction-set review properly (follow-up)

- After F1–F5 land, re-invoke `/pe-meta-update '.github\instructions' --mode plan` (per-domain to keep each pass honest), letting the hardened pipeline run Phase 1 research and Phase 4 per-file `pe-meta-instruction-review`. (📌 next steps)
- Capture the genuine findings (token budget `[C3]`, applyTo overlap `[H10]`, imperative language `[H8]`, required sections `[H9]`, internal redundancy/contradiction, minimization) in a **sibling** plan and apply after approval. (📌 next steps)
- Resolve or explicitly accept the parked `[H10]` applyTo overlaps and confirm the `documentation.instructions.md` → `article-writing` domain judgment call. (📌 next steps)

## 🅿️ Park lot

- **Whether `dims-exercised` should be computed automatically vs. self-attested** — auto-derivation from per-dimension outcome entries is more robust but larger; for the first cut, self-attestation validated against the applicable set is acceptable. Surface as a refinement, not a blocker.
- **A `documentation` canonical domain value** — the backfill exposed that `documentation.instructions.md` has no exact domain match; whether to extend the canonical domain set is a vision-level decision, out of scope here.

## 🧪 Exit criteria

- `pe-meta-update.prompt.md` emits `research=`, `phase4-coverage=`, and `dims-exercised=` markers on every run, before Phase 1 and echoed in Phase 8. (✅ done)
- The Phase 8 linter BLOCKS a full-breadth apply that skipped research, under-covered Phase 4, or under-exercised `--dim full`. (✅ done)
- New test scenarios assert all three block conditions. (✅ done — scenarios 21–23)
- Execution-discipline rule forbids batch-marking audit phases. (✅ done — Pipeline-phases Rule #3)
- 0 markdown errors on the edited prompt; frontmatter version bumped with changelog. (✅ done — v2.4.0, 0 errors)
- A verified re-run of the `.github/instructions/` review is scheduled via F6 (sibling plan), not silently skipped. (📌 next steps — F6 follow-up)
