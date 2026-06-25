---
title: "VS Code 1.124–1.126 net-new feature coverage — PE context corpus (intake)"
status: draft
mode: plan
goal: "Capture and eventually land the net-new feature-coverage gaps for VS Code releases 1.124–1.126 that the sibling `--dim freshness` run (plan 01) deliberately did not absorb — Autopilot/chat-permission autonomy, the Agents window, cost surfaces, model-picker/providers, agentic-code-feedback tools, plus the carried-over 1.123 chronicle-session-sync and research-agent gaps. This is a DRAFT backlog: it records the candidate gaps and their target homes but is NOT actionable until a content-design pass (a `--dim full` / content run) resolves the exact insertion points and wording per item."
source_invocation: "spawned from plan 01 park-lot disposition (/pe-meta-review --source https://code.visualstudio.com/updates --dim freshness --scope .copilot/context/00.00-prompt-engineering/ --mode plan)"
run_id: "coverage-20260625"
hidden: true
---

# VS Code 1.124–1.126 Net-New Feature Coverage — PE Context Corpus (Intake)

Draft backlog spawned from the [01-vscode-freshness-reconcile.plan.md](01-vscode-freshness-reconcile.plan.md)
park lot. The `--dim freshness` run advanced the source watermark and canonicalized doc links but, by
dimension contract, did **not** absorb net-new feature coverage. Those gaps are intake here.

**Status rationale (`draft`):** the candidate items below name target files but not concrete edits.
Per the Actionability Gate, "add coverage of X to file Y" is not execution-deterministic until a
content-design pass fixes the exact insertion point and wording. This plan therefore holds an
objective, an intake table, § Open decisions, § Park lot, and § Discovery only — **no actionable
body** — until that pass promotes it `draft → actionable`.

## Table of contents

- [Objective](#objective)
- [Context and inputs](#context-and-inputs)
- [Candidate coverage items (intake — not yet actionable)](#candidate-coverage-items-intake--not-yet-actionable)
- [Open decisions](#open-decisions)
- [Park lot](#park-lot)
- [Discovery](#discovery)
- [References](#references)

## Objective

Land net-new feature coverage for the agent/customization surfaces introduced across VS Code
**1.124–1.126** into the prompt-engineering context corpus, so the corpus describes current
capabilities (autonomy/approval model, multi-session Agents window, cost visibility, model
selection) rather than only the 1.123-era surface. Scope is **content addition** (a `--dim full`
pass), explicitly distinct from the mechanical watermark/link work already completed in plan 01.

## Context and inputs

| Input | Value | Evidence |
|---|---|---|
| Parent run | `freshness-20260625` (plan 01, applied 2026-06-25) | [01-vscode-freshness-reconcile.plan.md](01-vscode-freshness-reconcile.plan.md) |
| Watermark (now current) | VS Code 1.126 | [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) "Last Processed Versions" |
| Scope | `.copilot/context/00.00-prompt-engineering/` (single-domain) | plan 01 Context table |
| Dimension (target) | `full` / content (NOT freshness) | this plan |
| Mode | `plan` (draft backlog; no source writes) | — |

**Change digest** (the net-new surfaces, from plan 01): 1.124 Autopilot / chat permission levels +
Agents window; 1.125 additional-spend usage + install model providers; 1.126 session-level cost +
unified model picker + Agents-window agentic code feedback.

## Candidate coverage items (intake — not yet actionable)

Informational intake (no status suffixes — these are candidates, not authorized steps). Each becomes
an actionable item only after § Open decisions OD-1 is resolved for it.

| Id | Priority | Net-new surface (release) | Candidate home(s) |
|---|---|---|---|
| C1-autopilot-autonomy | MEDIUM | Autopilot / chat permission levels — `chat.permissions.default`, `chat.tools.global.autoApprove`, Advanced Autopilot (1.124) | `01.04-tool-composition-guide.md` (tool auto-approval), `02.03-orchestrator-design-patterns.md` (autonomy/termination) |
| C2-agents-window | MEDIUM | Agents window — multi-session, background send, agentic code feedback (1.124 + 1.126) | `01.02-prompt-assembly-architecture.md` (extends `**Agent HQ** (v1.107+)`, ~L104) |
| C3-cost-surfaces | MEDIUM | Additional-spend usage (1.125) + session-level cost (1.126) | `02.02-context-window-and-token-optimization.md` (usage-based billing, ~L51) |
| CG-chronicle-session-sync | carry-over (1.123) | `/chronicle` session sync | TBD at design time |
| CG-research-agent | carry-over (1.123) | research agent | TBD at design time |

## Open decisions

- **OD-1-per-item-content-design** — For each intake item, the exact insertion point and wording are
  undecided; this is a content-authoring decision, not an evidence lookup. Resolves by a content-design
  pass (the `--dim full` run). Gates: the entire actionable body. Until resolved, plan stays `draft`.
- **OD-2-c4-c5-inclusion** — Whether the two LOW gaps (C4-model-picker-providers,
  C5-agentic-code-feedback-tools) are pulled into this plan or left deferred. Resolves by an author
  priority call at design time. Gates: only the C4/C5 rows (currently parked, see § Park lot).

## Park lot

Out of scope for this intake. MUST NOT be executed here.

- **C4-model-picker-providers** → defer (revisit with the next model-card cycle; touches `03.02-model-specific-optimization.md` BYOK ~L153 and `01.06-system-parameters.md`)
- **C5-agentic-code-feedback-tools** → defer (`listComments`/`resolveComments`/`addComment` + `typeInPage` `submit`; the tool-catalog template is partly outside the context-folder scope)

## Discovery

- **DSC-1-refetch-at-design-time** — Before authoring any insertion, re-fetch the 1.124–1.126 release
  notes and the relevant `docs/agent-customization/*` / `docs/agents/*` pages to confirm the feature
  details and setting keys have not shifted since 2026-06-24. Negative branch: if a documented setting
  key or behavior changed, record the delta and design against the current docs rather than this
  plan's digest.

## References

- Parent plan: [01-vscode-freshness-reconcile.plan.md](01-vscode-freshness-reconcile.plan.md)
- Meta-review log: [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)
- Orchestrator: [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md)
- Live sources (re-fetch at design time): `https://code.visualstudio.com/updates/v1_124`, `/v1_125`, `/v1_126`
