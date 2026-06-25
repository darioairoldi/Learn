---
title: "VS Code 1.124–1.126 freshness reconciliation — PE context corpus"
status: done
mode: plan
goal: "Produce an evidence-bound freshness assessment and an actionable (non-executed) remediation plan for `.copilot/context/00.00-prompt-engineering/` against VS Code releases 1.124–1.126: advance the stale source watermark (1.123 → 1.126) and re-point doc links broken-to-canonical by the 1.125/1.126 docs restructure. Net-new feature coverage is explicitly out-of-dimension for `--dim freshness` and is parked, not silently absorbed."
source_invocation: "/pe-meta-review --source https://code.visualstudio.com/updates --dim freshness --scope .copilot/context/00.00-prompt-engineering/ --mode plan"
run_id: "freshness-20260625"
resolved_invocation: "--mode=plan --scope=.copilot/context/00.00-prompt-engineering/ --source=https://code.visualstudio.com/updates --dim=freshness --start=∅ --end=∅ --deps=none --skip=∅ --plan-file=src/docs/90. Issues/202606/20260625.01-vscode-update/01-vscode-freshness-reconcile.plan.md | breadth=full | caller=manual | bundle=single-domain"
hidden: true
---

# VS Code 1.124–1.126 Freshness Reconciliation — PE Context Corpus

Plan-mode output of a `/pe-meta-review --dim freshness` run. This file is the deliverable: an
assessment plus an actionable list. **No source artifacts are mutated by plan mode** — execution
is deferred to a follow-up `--mode apply` run that consumes this plan.

## Table of contents

- [Objective](#objective)
- [Context and inputs](#context-and-inputs)
- [Findings (assessment)](#findings-assessment)
  - [In-dimension freshness findings](#in-dimension-freshness-findings)
  - [Out-of-dimension coverage gaps (parked)](#out-of-dimension-coverage-gaps-parked)
- [Things to do — active list (in-dimension freshness)](#things-to-do--active-list-in-dimension-freshness)
- [Open decisions](#open-decisions)
- [Discovery](#discovery)
- [Park lot](#park-lot)
- [Health score and coverage report](#health-score-and-coverage-report)
- [References](#references)

## Objective

Reconcile the **freshness dimension** (D12-staleness + D13-source-verification) of the
prompt-engineering context corpus against the current VS Code release ceiling (**1.126**,
2026-06-24), given a documented watermark of **1.123** (2026-06-03). Deliver the two in-dimension
remediations as an actionable list, and **park** the net-new-feature coverage gaps for a separate
content/`--dim full` pass — mirroring how the 2026-06-03 (1.117 → 1.123) run handled out-of-dimension
features.

## Context and inputs

| Input | Value | Evidence |
|---|---|---|
| Scope | `.copilot/context/00.00-prompt-engineering/` (39 files, all `domain: "prompt-engineering"`) | grep `^domain:` → uniform `prompt-engineering` ⇒ `bundle=single-domain` |
| Source | `vscode-release-notes` (`https://code.visualstudio.com/updates`, semver, stable) | [pe-self-update.config.json](../../../../../.copilot/config/pe-self-update.config.json) |
| Documented watermark | VS Code **1.123** (2026-06-03) | [05.04-meta-review-log.md#L82](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md#L82) — `\| VS Code release notes \| 1.123 \| 2026-06-03 \|` |
| Current ceiling | VS Code **1.126** (2026-06-24) | live fetch of source URL |
| Unprocessed releases | **1.124** (Jun 10), **1.125** (Jun 17), **1.126** (Jun 24) | live fetch of `/updates/v1_124`, `/v1_125`, `/v1_126` |
| Dimension | `freshness` = D12-staleness + D13-source-verification | orchestrator dimension map |
| Mode | `plan` (assessment + plan file on disk; **no source writes**; Phases 5–7 not executed) | orchestrator `--mode plan` contract |

**Change digest since watermark 1.123** (bounded to agent/tool/customization surfaces):

- **1.124** — Agents window (background send, session navigation, restore-on-reload, close-all, single-file diff); **Autopilot (Preview)** enabled by default — a chat *permission level* (`chat.permissions.default`, `chat.tools.global.autoApprove`) with Advanced Autopilot (`chat.autopilot.advanced.enabled`, utility-model done-detection, max 3 loops); `typeInPage` gains a `submit` param; enterprise-managed Copilot plugin policies. Deprecated: none.
- **1.125** — "View your additional spend usage in VS Code" (Copilot status dashboard shows % of additional budget consumed); install model providers from the Language Models editor; integrated-browser web search / remote proxy; configurable extension auto-update; native MDM delivery for managed Copilot settings. Docs now served under `docs/agent-customization/…`. Deprecated: none.
- **1.126** — session-level cost information; unified model customization picker (context size + reasoning effort merged); simplified model hover; Agents window agentic code feedback (`listComments`/`resolveComments`/`addComment`, `/code-review`); Restricted Mode for new folders; **website docs restructure** (agentic docs → `docs/agents/…`, customization → `docs/agent-customization/…`). Deprecated: none.

## Findings (assessment)

Each finding carries a machine anchor (`path:line`) and a verbatim snippet per the evidence-coverage
contract. (✅ done — analysis recorded.)

### In-dimension freshness findings

No **false assertions** were found (every dated capability claim — Copilot SDK GA, 1M-token context,
OpenTelemetry signals, BYOK, Execution Contexts/Agent HQ — remains true; 1.124–1.126 deprecated
**nothing**). The freshness debt is **watermark drift** plus **cohort-wide link non-canonicality**.

- **F1-watermark-advance — D12-staleness — HIGH.** The processed-version ledger is **3 releases
  behind**. Evidence: [05.04-meta-review-log.md#L82](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md#L82) — verbatim `| VS Code release notes | 1.123 | 2026-06-03 |`; the
  config source ledger agrees. Live ceiling is 1.126. 1.124/1.125/1.126 are unprocessed. Compounding:
  the 2026-06-03 run already deferred 1.123 features (`/chronicle` session sync, Agents window,
  research agent) as out-of-dimension — evidence [05.04-meta-review-log.md#L391](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md#L391) — and 1.124/1.126 deepen the Agents-window surface.

- **F2-docs-link-repoint — D13-source-verification — MEDIUM (cohort-wide).** The 1.125/1.126 website
  restructure moved canonical doc paths. Current links **still resolve via redirect** (not broken) but
  are **non-canonical**. Confirmed by live fetch (both target pages stamped "Edit this page 6/24/2026"):
  - `docs/copilot/guides/monitoring-agents` → canonical **`docs/agents/guides/monitoring-agents`**. Evidence: [03.03-agent-hooks-reference.md#L154](../../../../../.copilot/context/00.00-prompt-engineering/03.03-agent-hooks-reference.md#L154) — verbatim `See [Monitor agent usage with OpenTelemetry](https://code.visualstudio.com/docs/copilot/guides/monitoring-agents)`.
  - `docs/copilot/copilot-customization` (+ `#_custom-agents` / `#_agent-hooks` / `#_agent-skills`) → canonical **`docs/agent-customization/overview`** (and dedicated sub-pages `…/custom-agents`, `…/hooks`, `…/agent-skills`). Page now titled "Customize AI in Visual Studio Code"; all anchors under `docs/agent-customization/overview#_…`.
  - `docs/copilot/customization/agent-skills` → **`docs/agent-customization/agent-skills`**. Evidence: [03.01-progressive-disclosure-pattern.md#L217](../../../../../.copilot/context/00.00-prompt-engineering/03.01-progressive-disclosure-pattern.md#L217).
  - `docs/copilot/chat/mcp-servers` → **`docs/agent-customization/mcp-servers`**. Evidence: [03.04-mcp-server-design-patterns.md#L243](../../../../../.copilot/context/00.00-prompt-engineering/03.04-mcp-server-design-patterns.md#L243).

  **Footprint** (whole-cohort grep of `visualstudio\.com/docs`): **11 files + the trusted-sources
  table** — `01.01` (L26, L222), `01.02` (L22, L208), `01.03` (L22, L169), `01.04` (L22, L244),
  `02.01` (L6, L200), `02.03` (L6, L192), `03.01` (L6, L217), `03.03` (L6, L154, L172),
  `03.04` (L6, L243), `03.06` (L6), `05.04` (L64).

### Out-of-dimension coverage gaps (parked)

These are **net-new feature coverage**, which `--dim freshness` does not absorb (consistent with the
2026-06-03 run's framing of 1.123 features as "out-of-dimension coverage gaps"). They are recorded
here and dispositioned in [Park lot](#park-lot); they do **not** gate F1/F2.

- **C1-autopilot-autonomy — MEDIUM.** 1.124 Autopilot / chat permission levels (`chat.permissions.default`, `chat.tools.global.autoApprove`, Advanced Autopilot) is a **new autonomy/approval surface** absent from the corpus. Natural homes: [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) (tool auto-approval), [02.03-orchestrator-design-patterns.md](../../../../../.copilot/context/00.00-prompt-engineering/02.03-orchestrator-design-patterns.md) (autonomy/termination).
- **C2-agents-window — MEDIUM.** 1.124 + 1.126 Agents window (multi-session, agentic code feedback) extends the session-management story at [01.02-prompt-assembly-architecture.md#L104](../../../../../.copilot/context/00.00-prompt-engineering/01.02-prompt-assembly-architecture.md#L104) (`**Agent HQ** (v1.107+)`). Carried over from the 1.123 deferral.
- **C3-cost-surfaces — MEDIUM.** 1.125 additional-spend usage + 1.126 session-level cost belong in [02.02-context-window-and-token-optimization.md#L51](../../../../../.copilot/context/00.00-prompt-engineering/02.02-context-window-and-token-optimization.md#L51) (usage-based-billing scope).
- **C4-model-picker-providers — LOW.** 1.125 install model providers + 1.126 unified model picker (context size + reasoning effort) touch [03.02-model-specific-optimization.md#L153](../../../../../.copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md#L153) (BYOK) and [01.06-system-parameters.md](../../../../../.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md).
- **C5-agentic-code-feedback-tools — LOW.** 1.126 `listComments`/`resolveComments`/`addComment` + 1.124 `typeInPage` `submit` param touch [01.04-tool-composition-guide.md](../../../../../.copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md) and the tool-catalog template (partly out of context-folder scope).
- **CG-chronicle-session-sync / CG-research-agent — carried-over (1.123).** Still unabsorbed per [05.04-meta-review-log.md#L391](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md#L391).

## Things to do — active list (in-dimension freshness)

To be executed by a follow-up `--mode apply` run; not executed in plan mode.

- **F1-watermark-advance.** Advance the processed-version watermark **1.123 → 1.126** in both the
  human mirror ([05.04-meta-review-log.md#L82](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md#L82) "Last Processed Versions" table) and the config source ledger; append a
  meta-review-log entry recording this run and the deferred coverage gaps C1–C5 + CG-* (mirror the
  2026-06-03 entry pattern). Do **not** advance until F2 lands in the same apply run. (✅ done — 2026-06-25: watermark advanced to 1.126 in the 05.04 "Last Processed Versions" table; the config "source ledger" has no instantiated store (no `.copilot/temp/pe-meta-state/triggers/` dir; `pe-self-update.config.json` carries no `last_seen_version`), so the 05.04 table is the sole watermark; rich apply-mode entry + parked gaps C1–C5/CG-* recorded.)
- **F2-docs-link-repoint.** Re-point every `code.visualstudio.com/docs/copilot/…` occurrence in the
  11-file + trusted-sources footprint to its verified canonical path (mapping table in
  [F2 finding](#in-dimension-freshness-findings)); update the trusted-sources "Last checked" date to
  the apply date. Per-occurrence: edit both the frontmatter `url:` ref and the body link. (✅ done — 2026-06-25: the full 11-file footprint repointed (10 cohort files / 20 link sites → `agent-customization/*` + `agents/guides/monitoring-agents`, plus the 05.04 trusted-sources row 1 URL); trusted-sources rows 1 & 5 "Last checked" → 2026-06-25; DSC-1 confirmed every target resolves 200 directly; `get_errors` clean on all 11 files.)

## Open decisions

_None blocking._ The active list (F1, F2) is fully determined. The broaden-vs-defer question for the
coverage gaps is handled as a [Park lot](#park-lot) disposition, not an in-scope gate, so it does not
hold this plan in `draft`.

## Discovery

- **DSC-1-redirect-spot-check.** At apply time, confirm each re-pointed URL returns 200 directly (not
  only via redirect). Negative branch: if a sub-path has **no** canonical equivalent post-restructure,
  keep the existing (redirecting) URL and flag it in the apply report rather than guessing a target.

## Park lot

Out-of-scope for this `--dim freshness` plan. MUST NOT be executed here.

- **C1-autopilot-autonomy** → `02-vscode-feature-coverage.plan.md` (spawn a `--dim full` / content run)
- **C2-agents-window** → `02-vscode-feature-coverage.plan.md`
- **C3-cost-surfaces** → `02-vscode-feature-coverage.plan.md`
- **C4-model-picker-providers** → defer (revisit with the next model-card cycle)
- **C5-agentic-code-feedback-tools** → defer (tool-catalog template is partly outside the context-folder scope)
- **CG-chronicle-session-sync / CG-research-agent** → `02-vscode-feature-coverage.plan.md` (clear the 1.123 carry-over)

## Health score and coverage report

| Dimension | 2026-06-03 run | This assessment | Note |
|---|---|---|---|
| D12-staleness | 🟢 HEALTHY | 🟡 **DEGRADED** | Watermark 3 releases behind (1.123 vs 1.126); no false claims, but coverage drift accumulating (5 new + 2 carried-over gaps) |
| D13-source-verification | 🟢 HEALTHY | 🟡 **DEGRADED** | Cohort-wide doc links non-canonical post-restructure (resolve via redirect); 11 files + trusted-sources row |

**Overall freshness health: 🟡 DEGRADED (recoverable).** No broken links, no false assertions, no
deprecations to chase — the debt is watermark advance (F1) + systematic link repoint (F2), both
mechanical.

**Coverage report:** freshness dimension assessed across the full single-domain scope (39 files);
2 in-dimension findings (F1, F2) actionable; 6 out-of-dimension coverage gaps parked; 1 discovery
item bounded. Files with version/link evidence read at body level: `01.02`, `01.03`, `02.02`, `03.02`,
`03.03`, `03.06` + whole-cohort grep for version strings and `visualstudio.com/docs` links.

## References

- Orchestrator: [pe-meta-review.prompt.md](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md)
- Source ledger / watermark mirror: [05.04-meta-review-log.md](../../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md)
- Config: [pe-self-update.config.json](../../../../../.copilot/config/pe-self-update.config.json)
- Investigation write-up: [overview.md](overview.md)
- Live sources: `https://code.visualstudio.com/updates/v1_124`, `/v1_125`, `/v1_126`; `https://code.visualstudio.com/docs/agents/guides/monitoring-agents`; `https://code.visualstudio.com/docs/agent-customization/overview`
