---
title: "Investigation backlog — Declarative Workflows 1.0"
publish: false
---

# Investigation backlog

## Resolved in this run

- [x] Confirm scope of the 1.0 release (Python `agent-framework-declarative` → 1.0.0; .NET `Microsoft.Agents.AI.Workflows.Declarative` already stable). — source article.
- [x] Capture the canonical YAML authoring model (`kind: Workflow`, `trigger`, `actions`, `InvokeAzureAgent`, `If`/condition, Power Fx expressions). — source article.
- [x] Capture the runtime loaders: Python `WorkflowFactory.create_workflow_from_yaml_path`; .NET `DeclarativeWorkflowBuilder.Build<T>`. — source article.
- [x] Enumerate the building blocks (state & expressions, control flow, agent invocation, function/MCP/HTTP tools, human-in-the-loop, checkpoint & resume). — source article.
- [x] Distinguish from the Hub's Copilot prompt-file orchestration how-tos. — coverage map.

## Open / watch items (non-blocking)

- [ ] Deep-dive Power Fx expression surface in declarative workflows (future how-to candidate if demand appears).
- [ ] Relationship to Foundry-hosted agents referenced by name in the YAML (`TriageAgent`, `BillingAgent`, …) — a future integration article if a Foundry subject folder emerges.
