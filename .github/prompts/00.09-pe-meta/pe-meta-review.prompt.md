---
name: pe-meta-review
description: "Review any PE-for-PE artifact against the PE vision, category contracts, quality bar, and ecosystem coherence — strategic review layer on top of structural validation"
agent: agent
model: claude-opus-4.6
tools:
  - semantic_search
  - read_file
  - file_search
  - grep_search
  - list_dir
  - replace_string_in_file
  - create_file
handoffs:
  - label: "Structural Validation"
    agent: pe-con-validator
    send: true
  - label: "Ecosystem Coherence"
    agent: pe-meta-validator
    send: true
  - label: "Fix Issues"
    agent: pe-con-builder
    send: true
  - label: "Optimize (--mode apply, complex findings)"
    agent: pe-meta-optimizer
    send: true
argument-hint: '<file-path> [--mode plan|apply] [--plan-file <path>] [bundle=accept] — e.g., ".github/agents/00.09-pe-meta/pe-meta-validator.agent.md" or ".copilot/context/00.00-prompt-engineering/01.04-tool-composition-guide.md"'
version: "2.3.0"
last_updated: "2026-06-04"
goal: "Produce a strategic + structural validation report for any PE-for-PE artifact, covering vision alignment, category compliance, quality bar, and self-update readiness"
scope:
  covers:
    - "Vision alignment check (llm-reasoning through progressive-learning applicability)"
    - "Category reference compliance (Level 1.5 enforcement)"
    - "PE quality bar assessment (exemplary vs standard)"
    - "N-1 structural separation audit"
    - "Self-update readiness (Phase 1-4 criteria)"
    - "Structural validation via pe-con-validator dispatch"
    - "Ecosystem coherence via pe-meta-validator"
    - "Phase 0b — domain coherence (per 04.05-pe-meta-invocation-gates.md)"
    - "bundle=accept consent token recognition on multi-domain scopes"
  excludes:
    - "Domain artifacts (article-writing, documentation — use /pe-con-review for those)"
    - "Ecosystem-wide audits (use /pe-meta-update --mode plan --skip research)"
boundaries:
  - "`apply = plan + execute` (vision v15.4): `--mode apply` first materializes/reconciles a plan (assessment phases) then executes it (implements non-breaking improvements autonomously; proposes breaking changes for human confirmation). `--mode plan` runs the same assessment and stops after the plan is materialized — assessment-only output"
  - "Risk classification determines execution, not command identity"
  - "Write tools (`replace_string_in_file`, `create_file`) are active during the execute step of `--mode apply`. Suppressed when `--mode plan` is specified (plan materialized, not executed) OR when the finding is classified as breaking"
  - "`--plan-file <path>` (vision v15.4) sets plan location/identity ONLY and never decides regenerate-vs-trust. Supplied → baseline: with assessment running this reconciles (preserves human-authored decisions, escalate-not-overwrite); with `--skip research` it trusts the baseline (cross-run drift guard REQUIRED). A same-conversation just-generated plan is an implicit baseline. Default auto-name path; see [pe-meta-plan-file-contract.md](../../prompt-snippets/pe-meta-plan-file-contract.md)"
  - "Model-routing seam (vision v15.4): the assessment/plan/reconcile phases run on the reasoning-grade `model:` declared here; delegated execution (pe-con-builder / pe-meta-optimizer) carries its own standard-grade `model:` — no mid-prompt switching"
  - "MUST load PE-strategic context before validation"
  - "MUST run both structural AND strategic validation"
  - "Only applies to PE-for-PE artifacts (pe-* prefix or .copilot/context/00.00-prompt-engineering/)"
  - "Phase 0b is NOT skippable; --skip domain-coherence is rejected with CF-05; Phase 0b runs on the resolved file set BEFORE delegating to pe-con-validator/pe-meta-validator/pe-con-builder"
  - "bundle=accept is the ONLY valid consent token (closed set); recorded on first-line `Resolved invocation:` log"
  - "Phase 0a CF-05 artifact-type/path consistency does NOT apply at this orchestrator-level layer (artifact-type-agnostic); enforced ONLY by per-artifact prompts"
rationales:
  - "PE-for-PE artifacts set the quality standard — structural correctness alone is insufficient"
  - "Vision alignment cannot be assessed without loading the vision document"
  - "Double validation (structural + strategic) catches issues neither catches alone"
---

# PE-for-PE Artifact Review

Strategic review for PE artifacts that serve the PE system itself. Adds vision alignment, category compliance, quality bar, and self-update readiness checks on top of structural validation.

**When to use this vs `/pe-con-review`:**
- This prompt → artifact is PE infrastructure (pe-* agents, pe-* prompts, PE context files, pe-* instructions, pe-* skills)
- `/pe-con-review` → artifact is domain-specific (article-writing, documentation, devops)

> **v15.4 alignment.** This prompt honors the vision v15.4 contracts: **`apply = plan + execute`** (every `--mode apply` run first materializes/reconciles a plan, then executes it; `--mode plan` materializes the same plan and stops — see § Plan output contract and [pe-meta-plan-file-contract.md](../../prompt-snippets/pe-meta-plan-file-contract.md)); the eighth canonical parameter **`--plan-file`** (location/identity only); the **fresh / reconcile / trust** execution modes (baseline-available? × research-runs?) with the cross-run **drift guard** REQUIRED in trust mode; the **model-routing seam** (reasoning model for plan/reconcile, standard model for execution via each delegated agent's own `model:`); and § Iteration budget (an `apply` run that hits the per-cycle change cap checkpoints the remaining plan items for trust-mode resume — see [pe-meta-iteration-budget.md](../../prompt-snippets/pe-meta-iteration-budget.md)). The Phase 4 first-line `Resolved invocation:` log echoes `plan-file=<path-or-none>` and `spillover=<path-or-none>` markers.

## CRITICAL BOUNDARIES

### ✅ Always Do
- Verify target is PE-for-PE before proceeding (redirect domain artifacts to `/pe-con-review` or `/pe-gra-{type}-review`)
- Load vision document, STRUCTURE-README, strategic review criteria, dependency map before any validation
- Run BOTH structural validation (via pe-con-validator) AND strategic validation (6 criteria from 05.06)
- Report blast radius for artifacts with 3+ dependents
- Produce combined verdict covering both structural and strategic dimensions
- Check category reference compliance (Level 1.5 for context file references)
- Run Phase 0b on the resolved file set (positional path + `--deps` closure) BEFORE delegating to pe-con-validator
- Echo `bundle=…` marker on the first line of the `Resolved invocation:` log

### ⚠️ Ask First
- When structural PASS but strategic FAIL — confirm whether to recommend fixes or accept as-is
- When artifact has 6+ dependents — confirm scope of ecosystem coherence check before delegating to pe-meta-validator

### 🚫 Never Do
- NEVER skip strategic validation even if structural validation passes — structural correctness alone is insufficient for PE-for-PE artifacts
- NEVER approve artifacts that contradict vision rationales without explicit user override
- NEVER run ecosystem coherence check without first completing structural + strategic validation
- NEVER apply changes classified as breaking without human confirmation
- NEVER apply changes when `--mode plan` is explicitly specified
- NEVER bypass Phase 0b — `--skip domain-coherence` is rejected with CF-05; bypass multi-domain gating ONLY via `bundle=accept`

## Phase 0b — Domain coherence

This prompt enforces the Phase 0b domain coherence gate defined in [`04.05-pe-meta-invocation-gates.md`](../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) (upstream authority: current vision document § Domain-coherent batching). The 3-tier metadata-first domain resolution algorithm, seed-vs-deps decision matrix, split-proposal renderer, dispatch table, `bundle=…` closed set, and `bundle=accept` consent semantics are specified there and MUST NOT be re-implemented here.

**Locally true for this prompt:**

1. **Scope = the resolved target.** The `<file-path>` positional argument (plus any closure under `--deps full`) IS the in-scope file set Phase 0b operates on. Each in-scope file's declared `domain:` frontmatter is read first (Tier 1); `pe-domain-map.yaml` path-heuristic (Tier 2) and `unknown` fallback (Tier 3) follow.
2. **Gate runs BEFORE Phase 1.** Domain footprint is computed before delegating to pe-con-validator (Phase 1 structural). `--mode apply` blocks multi-domain footprints until `bundle=accept` consent or a per-domain split is selected; `--mode plan` is advisory (split proposal in report, no block).
3. **Consent token.** `bundle=accept` is the only valid token (closed set, case-sensitive). Recorded on the first-line `Resolved invocation:` log as `bundle=accepted-bundle`.
4. **Phase 0a CF-05 does NOT apply at this layer.** This prompt is artifact-type-agnostic by design — it routes any PE-for-PE path. CF-05 (artifact-type/path consistency) is enforced ONLY by per-artifact prompts (`/pe-meta-{context|prompt|instruction|agent|template|skill|hook|snippet}-review`).
5. **`--skip domain-coherence` rejected.** Phase 0b is not in the skippable set; the canonical rejection message points the user at `bundle=accept` instead.

## Process

### Phase 0: Load PE-domain strategic context

1. **Verify target is PE-for-PE** — check the file path starts with a PE location (`.github/agents/00.0x-pe-*`, `.github/prompts/00.0x-pe-*`, `.copilot/context/00.00-prompt-engineering/`, `.github/instructions/pe-*`, `.github/skills/pe-*`, `.github/templates/00.00-prompt-engineering/`). If NOT a PE artifact, recommend `/pe-con-review` instead and STOP.
2. **Load vision document** — `read_file` on the current vision document in `06.00-idea/self-updating-prompt-engineering/` (find the file matching `*-vision.v*.md` with the highest version)
3. **Load 00.00-context-structure-index.md** — `read_file` on `.copilot/context/00.00-prompt-engineering/00.00-context-structure-index.md` for Functional Categories
4. **Load strategic review criteria** — `read_file` on the `pe-strategic-review` files from `.copilot/context/00.00-prompt-engineering/` (see 00.00-context-structure-index.md → Functional Categories)
5. **Load dependency map** — `read_file` on the `dependency-tracking` files from `.copilot/context/00.00-prompt-engineering/` (see 00.00-context-structure-index.md → Functional Categories)
6. **Read the target artifact** completely

### Phase 1: Structural validation

Delegate to `@pe-con-validator` — structural correctness, YAML compliance, tool alignment, boundary completeness, token budget. This produces the standard severity-ranked validation report.

### Phase 2: Strategic validation (PE-meta specific)

Using the strategic review criteria loaded in Phase 0, assess:

1. **Vision alignment** — check the applicable rationales from the vision alignment checklist (matrix in `05.06`). Report any rationale that the artifact doesn't comply with.
2. **Category reference compliance** — audit all references to `.copilot/context/00.00-prompt-engineering/` files. Are they using Level 1.5 (category) references? Flag any that use Level 2 (file-specific) without justification.
3. **PE quality bar** — compare against the "exemplary" column in the quality bar table. Report gaps between "standard" and "exemplary" with specific recommendations.
4. **N-1 separation** — check the N-1 adoption table for this artifact type. If N-1 is applicable, verify rule-bearing sections use `**Rule**:` / `**Rationale**:` / `**Example**:` blocks.
5. **Self-update readiness** — determine which rollout phase this artifact type falls under. Check the readiness criteria. Report gaps.
6. **Ecosystem impact** — check the dependency map for this artifact's dependents. Report the blast radius.

### Phase 3: Ecosystem coherence (optional, for high-impact artifacts)

If the artifact has 6+ dependents, delegate to `@pe-meta-validator` (Ecosystem Audit mode, scoped to this artifact) for cross-artifact consistency verification.

### Phase 4: Consolidated report

Merge structural (Phase 1) and strategic (Phase 2) findings into a single report:

```markdown
## PE-for-PE Review: [filename]

### Structural Validation (from pe-con-validator)
**Score:** [X/10]
[severity-ranked structural findings]

### Strategic Validation (PE-meta specific)
| Check | Status | Details |
|---|---|---|
| Vision alignment | ✅/⚠️/❌ | [which rationales pass/fail] |
| Category references | ✅/⚠️/❌ | [Level 1.5 compliance] |
| PE quality bar | ✅/⚠️/❌ | [exemplary vs standard gaps] |
| N-1 separation | ✅/⚠️/❌/N/A | [rule-bearing sections status] |
| Self-update readiness | Phase [N] ready / gaps: [...] | [readiness criteria] |

### Ecosystem Impact
**Dependents:** [N] | **Blast radius:** [Low/Medium/High]

### Combined Verdict
**PASS** / **PASS with improvements** / **FAIL (structural)** / **FAIL (strategic)**

### Recommended improvements (priority-ordered)
1. [highest-impact improvement]
2. ...
```

If FAIL or improvements needed: offer handoff to `@pe-con-builder` for fixes.

### Phase 4a: Output contract (plan-file + spillover markers)

The Phase 4 report MUST open with a first-line `Resolved invocation:` log that echoes the `plan-file=` and `spillover=` markers:

```text
Resolved invocation: --mode=<plan|apply> … | bundle=<accepted-bundle|none> | plan-file=<path-or-none> | spillover=<path-or-none>
```

- **`--mode plan` (assessment-only):** emit an actionable plan file at the canonical plan-mode path per [pe-meta-plan-file-contract.md](../../prompt-snippets/pe-meta-plan-file-contract.md) and record `plan-file=<path>`. When `--mode apply`, record `plan-file=none`.
- **`--mode apply` overflow:** if the per-cycle change cap is hit with validated findings remaining, emit a spillover plan at `<run-folder>/<NN>-<kebab-name>-spillover.plan.md` per [pe-meta-iteration-budget.md](../../prompt-snippets/pe-meta-iteration-budget.md) and record `spillover=<path>`; otherwise record `spillover=none`.

pe-meta review prompts have a compact 4-phase pipeline and delegate structural validation to pe-con-validator. Context accumulation is manageable without formal summarization. If context exceeds 8,000 tokens before a handoff, summarize strategic findings to the 6-criterion checklist results only.

## Handoff Data Contracts

| Transition | Strategy | Include | Exclude | Max tokens |
|---|---|---|---|---|
| **Orchestrator → pe-con-validator** | send: true | File path + artifact type + "structural validation" | Vision document, strategic criteria | ≤200 |
| **pe-con-validator → Orchestrator** | Structured report | Severity-ranked findings with line numbers and fix recommendations | Passing checks, pattern analysis | ≤1,000 |
| **Orchestrator → pe-meta-validator** (optional) | send: true | File path + "ecosystem coherence check" + dependent count threshold (6+) | Structural findings, strategic analysis | ≤500 |
| **Orchestrator → pe-con-builder** (for fixes) | send: true | File path + specific issues to fix from combined report | Full validation analysis | ≤500 |

## Risk Classification

#file:.github/prompt-snippets/pe-meta-risk-classification.md

## Response Management

- **Not a PE artifact** → "This file is not a PE-for-PE artifact. Use `/pe-con-review` instead."
- **Structural PASS but strategic FAIL** → Report strategic findings; structural correctness doesn't substitute for vision alignment
- **All checks pass** → "This artifact meets both structural and strategic standards. No improvements needed."
- **`--mode plan` active** → Report all findings as proposals; do not apply any changes
- **`--mode apply` active (default)** → Apply non-breaking fixes autonomously; propose breaking changes for confirmation; delegate complex multi-file improvements to `@pe-meta-optimizer`

## Embedded Test Scenarios

| # | Scenario | Expected Behavior |
|---|---|---|
| 1 | Review PE context file (happy path) | Phase 0 loads vision + strategic criteria → Phase 1 structural validation → Phase 2 strategic check (6 criteria) → Phase 4 combined report with PASS |
| 2 | Review non-PE artifact (redirect) | Phase 0 detects non-PE path → "Use /pe-con-review instead" → STOP |
| 3 | Strategic FAIL but structural PASS | Structural validation passes → strategic check finds missing L1.5 refs → combined verdict: PASS with improvements → offers pe-con-builder handoff |
| 4 | High-dependency artifact (6+ dependents) | Asks user to confirm ecosystem coherence scope → delegates to pe-meta-validator → includes blast radius in report |
