---
title: "PE-meta improvement step 1 plan"
author: "Dario Airoldi"
date: "2026-05-22"
categories: [issue, prompt-engineering, copilot, implementation-plan]
description: "Step 1 plan to stabilize the PE-meta review command contract, dependency flags, and review-command grammar."
status: "completed"
version: "1.2.0"
---

# PE-meta improvement step 1 plan

## 🎯 Objective

Stabilize the core PE-meta review command contract so that review prompts share one clear invocation model:

- target selector,
- `--dim` selector,
- dependency traversal selector.

This step is intentionally narrow. It focuses on the review commands only, not the broader orchestration commands.

## Already completed (✅ done)

- Canonicalized dependency traversal flags across PE-meta review prompts. (✅ done)
  Completion note (2026-05-22): `--with-deps` now means full dependency-aware review, and `--with-deps-shallow` now means first-level-only dependency review.

- Normalized `--dim full` as an explicit alias for all applicable dimensions. (✅ done)
  Completion note (2026-05-22): Review prompt argument hints were aligned to `--dim <group|D#|full>`.

- Updated the issue analysis document with the approved contract direction. (✅ done)
  Completion note (2026-05-22): `01-overview.md` now reflects the approved dependency semantics and explicit `--dim full` support.

- Added canonical invocation examples in review prompt grammar and embedded scenarios. (✅ done)
  Completion note (2026-05-22): `pe-meta-review.prompt.md` now includes explicit examples for full and shallow dependency-aware invocations.

## Remaining actions (✅ done)

- Add an explicit invalid-combinations matrix to the review orchestrator. (✅ done)
  Completion note (2026-05-22): Added fail-fast matrix covering dependency-flag exclusivity, context-only dimension misuse, mixed-type multi-target conflicts, and malformed target-list input.

- Add user-facing error messages for invalid command combinations. (✅ done)
  Completion note (2026-05-22): Added deterministic corrective error messages for each invalid-combination case in the orchestrator prompt.

- Clarify the separation between core review commands and orchestration commands. (✅ done)
  Completion note (2026-05-22): Added command surface boundary section clarifying core review parameters vs orchestration controls.

## Validation approach (✅ done)

- Run consistency checks across all `pe-meta-*-review.prompt.md` files. (✅ done)
  Completion note (2026-05-22): Argument hints and dependency semantics were rechecked and aligned across review prompts.

- Run deterministic scenario checks for the contract surface. (✅ done)
  Completion note (2026-05-22): Added explicit embedded invalid-combination scenarios in orchestrator tests and verified diagnostics across updated files.

- Recheck the issue document after prompt changes. (✅ done)
  Completion note (2026-05-22): `01-overview.md` was updated after grammar and dependency-flag changes.

## Exit criteria (✅ done)

These are acceptance criteria for considering this plan implemented. They are not next steps. (✅ done)

- Every PE-meta review prompt exposes the same command grammar. (✅ done)
- `--dim full` is explicit everywhere review grammar is described. (✅ done)
- `--with-deps` and `--with-deps-shallow` are fully differentiated. (✅ done)
- Invalid combinations are explicitly rejected with deterministic messages. (✅ done)
- The issue document and prompt implementation say the same thing. (✅ done)

## 📚 References

- `01-overview.md`
- `.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md`
- `.github/prompts/00.09-pe-meta/pe-meta-agent-review.prompt.md`
- `.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md`

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}

article_metadata:
  filename: "01-pe-meta-improvement-step1-plan.md"
-->