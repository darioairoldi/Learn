---
title: "pe-meta-agent-design validation runbook"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "individual"
---

# pe-meta-agent-design validation runbook

Use this runbook when pe-meta orchestration commands are unavailable.

## Goal 🎯

Run all global cases and type-specific cases as independent prompt executions, with traceable evidence per case.

## Target artifact 📋

- Path: `C:\dev\darioairoldi\Learn\.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md`
- Status file: `../02.09-validation-status-pe-meta-agent-design.md`

## Execution modes ⚙️

1. Preferred: invoke each local prompt file in this folder from Copilot Chat (copy-paste prompt content).
2. Do not depend on pe-meta slash commands for completion of this runbook.

## Step-by-step ✅

1. Check if the target file exists.
2. If missing, run `00a-bootstrap-create-prompt.prompt.md` first.
3. Run each case prompt file in numeric order.
4. Capture result as `pass`, `fail`, or `blocked` with one-line evidence.
5. Update checkboxes in `../02.09-validation-status-pe-meta-agent-design.md`.
6. Add an execution-log row with date, runner, result, and residual blockers.

## Case order 🔢

1. `01-g01-metadata-contract.prompt.md`
2. `02-g02-reference-integrity.prompt.md`
3. `03-g03-scope-fidelity.prompt.md`
4. `04-g04-boundary-compliance.prompt.md`
5. `05-g05-versioning-discipline.prompt.md`
6. `06-p01-argument-parsing.prompt.md`
7. `07-p02-type-dispatch-correctness.prompt.md`
8. `08-p03-phase-ordering-mode-behavior.prompt.md`
9. `09-p04-delegation-handoff-correctness.prompt.md`
10. `10-p05-scope-boundary-safety.prompt.md`

## Output contract for each case run 📌

Use this compact output shape:

- Case: G-01|G-02|G-03|G-04|G-05|A-01|A-02|A-03|A-04|A-05|P-01|P-02|P-03|P-04|P-05
- Result: pass|fail|blocked
- Evidence: 1-3 bullet points
- Suggested fix: only when fail or blocked
