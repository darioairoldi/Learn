---
title: "Guidance adherence matrix - pe-meta agents"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "guidance-first"
---

# Guidance adherence matrix - pe-meta agents

Purpose: map pe-meta agent behaviors to canonical context-rule sources so A-04 checks can use deterministic evidence before semantic checks.

## Canonical rule sources

- governance: `.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md`
- agent-patterns: `.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md`
- tool-alignment: `.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md`
- dependency-tracking: `.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md`
- pe-type-checklists: `.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md`

## Builder-critical adherence anchors

| Behavior | Canonical source | pe-meta-builder | pe-meta-designer | pe-meta-researcher | pe-meta-validator | pe-meta-optimizer |
|---|---|---|---|---|---|---|
| metadata contract | `00.03-metadata-contracts.md` | full | partial | partial | full | partial |
| boundary system | `02.04-agent-shared-patterns.md` | full | full | full | full | full |
| handoff integrity | `05.01-artifact-dependency-map.md` | full | partial | partial | partial | partial |
| deterministic-first and efficiency | `01.04-tool-composition-guide.md` | full | partial | partial | partial | partial |

## Deterministic evidence markers

For each agent, collect these markers during validation:

- metadata fields present: `description`, `version`, `last_updated`, `goal`, `scope`, `boundaries`, `rationales`
- boundary section counts: Always, Ask First, Never
- handoff targets resolve to existing agent files
- deterministic markers present in process or workflow language

## Notes

- This matrix is intentionally compact and optimized for status-file evidence linking.
- For deep semantic adherence analysis, run the guidance-first workflow after this deterministic pass.
