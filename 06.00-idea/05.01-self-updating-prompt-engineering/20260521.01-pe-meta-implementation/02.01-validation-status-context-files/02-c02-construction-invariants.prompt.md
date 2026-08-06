---
title: "C-02 construction invariants validation prompt"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_case: "C-02"
---

# C-02 construction invariants validation prompt

Validate context files for construction invariants.

## Invariants

- Non-redundancy
- Non-contradiction
- Clarity
- Actionability
- Completeness
- Layer correctness

## Execution steps

1. Identify duplicate rule statements across context files.
2. Detect direct and indirect contradictions across related files.
3. Flag ambiguous rules that cannot be interpreted deterministically.
4. Flag rules that are not testable/actionable.
5. Identify missing rule coverage for known behavior areas.
6. Verify each file is in the correct conceptual layer.
7. Produce findings with invariant name, severity, and affected files.

## Output format

- Invariant scorecard (pass, partial, fail)
- Findings grouped by invariant
- Recommended canonical source for duplicated rules
