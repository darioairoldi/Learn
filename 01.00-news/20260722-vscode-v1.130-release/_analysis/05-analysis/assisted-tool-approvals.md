---
title: "Assisted tool approvals — analysis"
publish: false
---

# Assisted tool approvals

## Problem

Agent tasks are frequently interrupted by tool-approval prompts. The existing permission model in VS Code offers static choices: allow all, deny all, or approve each tool call manually. There's no middle ground that accounts for the *risk* of a specific tool call in its current context.

## Considerations

1. **The approval fatigue problem.** Long-running agent tasks may trigger dozens of tool calls. Manually approving each one breaks flow and adds no security value for low-risk operations (reading a file, searching code).

2. **Model-evaluated risk.** Assisted permissions use the language model itself to evaluate the risk of each tool call and decide whether it can proceed automatically or needs user confirmation. This is a fundamentally different approach from static permission rules.

3. **Opt-in via picker.** The setting `chat.assistedPermissions.enabled` adds "Assisted permissions" as an option in the permissions picker alongside existing modes. It's not a default behavior.

4. **Agent Host requirement.** Assisted permissions only work for agents running on the Agent Host, reinforcing the Agent Host as the future runtime for advanced agent features.

5. **Relationship to existing permission surface.** Existing settings (`chat.permissions.default`, `chat.tools.global.autoApprove`) provide static, rule-based permissions. Assisted permissions add a *dynamic* tier where the model itself makes context-aware risk decisions.

## Deductions

- **D1.** This introduces a three-tier permission model: static deny → model-evaluated risk → static allow. The model sits in the middle, handling the gray area.
- **D2.** The approach is philosophically similar to how security systems use ML for anomaly detection — let the model identify what's routine versus what requires human judgment.
- **D3.** Trust calibration is implicit: you trust the model to correctly assess risk, which means the quality of risk evaluation is a function of the model's understanding of tool semantics.

## Conclusions

Assisted tool approvals represent a paradigm shift from static permission rules to dynamic, context-aware risk evaluation. This is the first production feature in VS Code where the model makes meta-decisions about its own tool usage, not just task-level decisions. It directly addresses approval fatigue while maintaining human oversight for high-risk operations.

## Appendix A — Evidence

| Source | Classification | Key evidence |
|---|---|---|
| VS Code 1.130 release notes | 📘 Official | Feature description, setting name, comparison video |
| VS Code Agent Host docs | 📘 Official | Agent Host requirement confirmed |

## Appendix B — Validation

Feature description validated against official release notes. The setting name and behavior are explicitly documented.
