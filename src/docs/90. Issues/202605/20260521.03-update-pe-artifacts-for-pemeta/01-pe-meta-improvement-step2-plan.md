---
title: "PE-meta improvement step 2 plan"
author: "Dario Airoldi"
date: "2026-05-22"
categories: [issue, prompt-engineering, copilot, implementation-plan]
description: "Step 2 plan to harden deterministic validation, evidence capture, and rollout of the PE-meta review command contract."
status: "planned"
version: "1.1.0"
---

# PE-meta improvement step 2 plan

## 🎯 Objective

Turn the stabilized PE-meta review command contract into a reproducible, evidence-backed workflow with deterministic validation and clear rollout boundaries.

This step starts after step 1 command grammar is considered stable.

## Planned workstream A: deterministic validation (🟡 todo)

- Add parser-oriented validation scenarios for accepted combinations. (🟡 todo)
  To do: Cover individual review, `--dim full`, dimension groups, full dependency-aware traversal, shallow dependency traversal, and multi-target review.

- Add parser-oriented validation scenarios for rejected combinations. (🟡 todo)
  To do: Cover mutually exclusive dependency flags, type-specific dimension misuse, and malformed multi-target inputs.

- Add embedded test scenarios where missing. (🟡 todo)
  To do: Ensure the orchestrator and key type-specific review prompts describe the expected behavior for both valid and invalid invocations.

## Planned workstream B: evidence and status tracking (🟡 todo)

- Create or extend validation evidence for the updated review contract. (🟡 todo)
  To do: Capture prompt-level evidence that `--dim full`, `--with-deps`, and `--with-deps-shallow` are wired consistently.

- Add or update validation-status entries for command-contract checks. (🟡 todo)
  To do: Track grammar consistency, invalid-combination rejection, and multi-target handling as explicit validation rows.

- Record implementation evidence in the PE-meta implementation folder. (🟡 todo)
  To do: Keep evidence paths stable and rerunnable.

## Planned workstream C: rollout and UX hardening (🟡 todo)

- Separate minimal review-command parameters from orchestration-command parameters in documentation. (🟡 todo)
  To do: Keep review commands limited to target(s), `--dim`, and dependency flags; keep richer controls in scheduled/update flows.

- Add concise user guidance for command selection. (🟡 todo)
  To do: Explain when to use individual review, full dependency-aware review, shallow dependency-aware review, and guidance-first review.

- Re-run a final consistency pass across issue docs and prompt files. (🟡 todo)
  To do: Remove any remaining wording that refers to the pre-normalized contract.

## 📋 Exit criteria (🟡 todo)

These are acceptance criteria that remain pending until this plan is fully implemented. (🟡 todo)

- Accepted and rejected command combinations are both test-covered. (🟡 todo)
- Evidence exists for the updated review contract and can be rerun. (🟡 todo)
- Validation status reflects the new command model. (🟡 todo)
- Review-command docs stay minimal, while orchestration-command docs keep advanced controls. (🟡 todo)
- The updated contract is understandable without reading the entire issue history. (🟡 todo)

## 📚 References

- `01-pe-meta-improvement-step1-plan.md`
- `01-overview.md`
- `.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md`
- `.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md`
- `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md`

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}

article_metadata:
  filename: "01-pe-meta-improvement-step2-plan.md"
-->