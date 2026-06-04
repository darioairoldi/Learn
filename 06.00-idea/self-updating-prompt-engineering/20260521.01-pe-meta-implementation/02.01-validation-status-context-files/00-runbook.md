---
title: "Context validation runbook"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "context-set"
---

# Context validation runbook

## Why this exists 🎯

This runbook lets you validate the context layer even when pe-meta automation is not yet available.

You run five focused prompts, one per validation case.

## Execution order ⚙️

1. [C-01 structure and metadata](01-c01-structure-and-metadata.prompt.md)
2. [C-02 construction invariants](02-c02-construction-invariants.prompt.md)
3. [C-03 coverage versus consumers](03-c03-coverage-consistency.prompt.md)
4. [C-04 staleness and source verification](04-c04-staleness-and-sources.prompt.md)
5. [C-05 category mapping and index integrity](05-c05-category-index-integrity.prompt.md)

## How to run each prompt ✅

1. Open the prompt file.
2. Paste its Prompt block into Copilot Chat.
3. Keep scope limited to `.copilot/context/00.00-prompt-engineering/` unless stated otherwise.
4. Save findings into the execution log in [../02.01-validation-status-context-files.md](../02.01-validation-status-context-files.md).

## Output format required from each run 📌

Use this structure in each prompt response:

1. Summary.
2. Findings by severity.
3. Evidence with file paths.
4. Pass/fail decision for the case.
5. Recommended next action.
