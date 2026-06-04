---
title: "pe-meta-builder validation runbook"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "individual"
---

# pe-meta-builder validation runbook

Use this runbook when pe-meta orchestration commands are unavailable.

## Goal 🎯

Run all global cases (G-01..G-05) and type-specific cases (A-01..A-05) as independent prompt executions, with traceable evidence per case.

## Target artifact 📋

- Path: `C:\dev\darioairoldi\Learn\.github\agents\00.09-pe-meta\pe-meta-builder.agent.md`
- Status file: `../02.02-validation-status-pe-meta-builder.md`

## Execution modes ⚙️

1. Preferred: invoke each local prompt file in this folder from Copilot Chat (copy-paste prompt content).
2. Alternative: if pe-meta slash commands exist, use them; otherwise stay in this runbook flow.

## Step-by-step ✅

1. Check if the target file exists.
2. If missing, run `00a-bootstrap-create-agent.prompt.md` first.
3. Run each case prompt file in numeric order.
4. Capture result as `pass`, `fail`, or `blocked` with one-line evidence.
5. Update checkboxes in `../02.02-validation-status-pe-meta-builder.md`.
6. Add an execution-log row with date, runner, result, and residual blockers.

## Case order 🔢

1. `01-g01-metadata-contract.prompt.md`
2. `02-g02-reference-integrity.prompt.md`
3. `03-g03-scope-fidelity.prompt.md`
4. `04-g04-boundary-compliance.prompt.md`
5. `05-g05-versioning-discipline.prompt.md`
6. `06-a01-mode-tool-alignment.prompt.md`
7. `07-a02-boundary-completeness.prompt.md`
8. `08-a03-handoff-contract-integrity.prompt.md`
9. `09-a04-guidance-adherence.prompt.md`
10. `10-a05-deterministic-first-efficiency.prompt.md`

## Output contract for each case run 📌

Use this compact output shape:

- Case: G-01
- Result: pass|fail|blocked
- Evidence: 1-3 bullet points
- Suggested fix: only when fail or blocked
