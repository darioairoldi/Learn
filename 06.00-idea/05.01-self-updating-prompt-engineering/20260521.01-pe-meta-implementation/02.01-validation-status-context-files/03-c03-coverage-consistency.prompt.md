---
title: "C-03 coverage consistency validation prompt"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_case: "C-03"
---

# C-03 coverage consistency validation prompt

Validate that context guidance coverage is consistent with consuming artifacts.

## Scope

- Guidance source: `.copilot/context/00.00-prompt-engineering/`
- Consumers: `.github/agents/00.09-pe-meta/`, `.github/prompts/00.09-pe-meta/`, `.github/instructions/`

## Execution steps

1. Extract key rules and topics from context files.
2. Sample consumer artifacts and map referenced guidance.
3. Detect consumer behavior without backing guidance.
4. Detect guidance that has no consumer usage.
5. Flag scope mismatches where consumer intent contradicts guidance scope.
6. Produce a coverage matrix: guidance topic to consumer artifacts.

## Output format

- Coverage matrix
- Uncovered consumer behaviors
- Orphan guidance topics
- Prioritized remediation list
