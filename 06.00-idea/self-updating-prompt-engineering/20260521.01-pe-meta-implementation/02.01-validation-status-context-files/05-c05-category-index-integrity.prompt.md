---
title: "C-05 category and index integrity validation prompt"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_case: "C-05"
---

# C-05 category and index integrity validation prompt

Validate category mapping and index integrity for context files.

## Scope

- Context files: `.copilot/context/00.00-prompt-engineering/`
- Index file: `.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md`
- Dependency tracking and logs: `05.01` to `05.08` files

## Execution steps

1. List all context files and their inferred categories.
2. Compare actual files against entries in `STRUCTURE-README.md`.
3. Detect missing index entries, stale entries, and wrong category mappings.
4. Cross-check dependency map references against actual files.
5. Produce index-integrity findings with exact corrections.

## Output format

- Index integrity score
- Missing entries
- Stale entries
- Incorrect category mappings
- Suggested patch plan
