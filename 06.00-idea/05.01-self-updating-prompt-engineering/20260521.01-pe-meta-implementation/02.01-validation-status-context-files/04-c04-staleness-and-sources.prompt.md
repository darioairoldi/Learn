---
title: "C-04 staleness and source verification prompt"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_case: "C-04"
---

# C-04 staleness and source verification prompt

Validate context file freshness and source quality.

## What to check

- Stale guidance indicators (`last_updated`, outdated version references)
- Broken or obsolete references
- Claims that lack source support
- References that no longer match current platform behavior

## Execution steps

1. Scan all context files for `last_updated` and version references.
2. Identify files likely stale based on age and referenced platform versions.
3. Validate source links and cited references.
4. Flag unsupported claims with no verifiable source.
5. Produce a stale-risk list with urgency levels.

## Output format

- Freshness report by file
- Source integrity report
- Urgent stale items and recommended update order
