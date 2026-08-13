---
title: "Context validation prompts runbook"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
---

# Context validation prompts runbook

Use these prompts when pe-meta orchestration is not yet available.

Each prompt is designed to be run directly in chat against `.copilot/context/00.00-prompt-engineering/`.

## Prompt sequence

1. [01-c01-structure-and-metadata.prompt.md](01-c01-structure-and-metadata.prompt.md)
2. [02-c02-construction-invariants.prompt.md](02-c02-construction-invariants.prompt.md)
3. [03-c03-coverage-consistency.prompt.md](03-c03-coverage-consistency.prompt.md)
4. [04-c04-staleness-and-sources.prompt.md](04-c04-staleness-and-sources.prompt.md)
5. [05-c05-category-index-integrity.prompt.md](05-c05-category-index-integrity.prompt.md)

## Expected output from each prompt

- A pass or fail summary
- A severity-ranked findings list
- Exact file paths for findings
- Remediation recommendations

## Execution log template

| Case | Date | Runner | Result | Notes |
|---|---|---|---|---|
| C-01 |  |  |  |  |
| C-02 |  |  |  |  |
| C-03 |  |  |  |  |
| C-04 |  |  |  |  |
| C-05 |  |  |  |  |
