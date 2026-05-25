---
title: "C-01 structure and metadata validation prompt"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_case: "C-01"
---

# C-01 structure and metadata validation prompt

Validate all files in `.copilot/context/00.00-prompt-engineering/` for structural and metadata validity.

## What to check

- YAML frontmatter is present and parseable
- Required fields exist where applicable (`description`, `version`, `last_updated` when required by type)
- Markdown structure is valid and readable
- No empty files, truncated frontmatter, or malformed section markers

## Execution steps

1. List all context files in `.copilot/context/00.00-prompt-engineering/`.
2. For each file, parse and validate frontmatter.
3. Flag missing required metadata fields.
4. Flag malformed markdown structure.
5. Produce a findings table with severity and file path.

## Output format

- Summary: pass or fail with counts
- Findings: CRITICAL, HIGH, MEDIUM, LOW
- Suggested fixes
