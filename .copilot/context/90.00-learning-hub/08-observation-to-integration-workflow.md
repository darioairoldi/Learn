---
title: "Observation-to-integration workflow"
description: "Single-entry workflow for converting a raw user question into triage, proposed results, approval discussion, and post-approval LearnHub integration proposal"
domain: "learning-hub"
goal: "Provide one authoritative workflow contract that prompts and agents can load on demand"
scope:
  covers:
    - "Single-entry intake with context harvest (active file, sibling issues, repo)"
    - "Triage that seeds candidate areas from question AND current context"
    - "Existing-LearnHub coverage map (internal grounding) before prioritization"
    - "Per-area in-depth analysis for standard/deep tracks"
    - "Proposed-result package for user discussion"
    - "Approval gate before integration"
    - "Taxonomy-bound post-approval LearnHub integration proposal"
    - "Integration modes (tech-article vs meta/architecture amendment), a deduction-validation loop, and report-quality conditions"
    - "Source-soundness gate (six dimensions and a gating verdict) run before deep analysis and enforced as an integration precondition"
    - "Issue-folder artifact contracts"
  excludes:
    - "Article writing style mechanics"
    - "Repository folder naming conventions"
boundaries:
  - "MUST treat the user question as sufficient initial input"
  - "MUST harvest current context (active file, sibling issues, repo) to seed candidate areas"
  - "MUST run triage before deep investigation unless explicitly skipped by user"
  - "MUST produce an existing-LearnHub coverage map before locking priority tracks"
  - "MUST prioritize local repository evidence before external evidence"
  - "MUST produce a per-area in-depth analysis (problem, considerations, deductions, conclusions) for every standard/deep track"
  - "MUST run external pattern contrast only when recommendation quality depends on workflow-pattern choice"
  - "MUST present a proposed result package before proposing integration"
  - "MUST propose integration only after explicit user approval"
  - "MUST map every integration target to a LearnHub taxonomy category"
  - "MUST derive each article's folder and numeric prefix from its taxonomy content-type via the subject-folder template (00 overview · 01 getting-started · 02 concepts · 03 how-to · 04 analysis · 05 reference · 06 resources; fractional XX.YY- for additional articles in one band)"
  - "MUST integrate every approved result fully into the corpus by default: taxonomy-band placement, bidirectional cross-links, redundancy consolidation into the canonical article, and related-backlog closure"
  - "MUST reserve user questions for genuine judgment calls (proposed answer, integration approval, unresolved scope conflicts) and MUST NOT ask users to choose article numbering/positioning or whether to integrate"
  - "MUST NOT execute integration changes without explicit implementation confirmation"
rationales:
  - "Single-entry usage reduces workflow friction for end users"
  - "Context harvest and coverage map ground investigation in what LearnHub already knows"
  - "Per-area analysis guarantees critical depth instead of a single shallow package"
  - "Approval gating prevents premature documentation churn"
  - "Taxonomy-bound integration lands outputs in the right content type"
  - "Centralized workflow context keeps prompts and agents consistent"
---

# Observation-to-integration workflow

## Purpose

Define the authoritative, reusable workflow for handling a user question from first observation to LearnHub integration proposal.

## Referenced by

- `.github/prompts/90.00-learning-hub/lh-investigate-observation-and-integrate.prompt.md`
- `.github/agents/lh-observation-investigator.agent.md`

## Workflow contract

### Step 1: Single-entry intake + context harvest

Accept one user input: the raw question or doubt.

Required extraction:

- `explicit_question`
- `pain_signal`
- `decision_pressure`
- `domain_scope`

Then harvest the surrounding context so triage is not question-only. Record `context_signals` from:

- active/attached file(s) and the current editor selection
- sibling issue folders and any linked/adjacent observations
- a repository scan for the subject (`grep_search`/`semantic_search`)

### Step 2: Fast triage

Infer candidate investigation areas seeded from BOTH `explicit_question` and `context_signals`.

For each area, score:

- `relevance` (1-5)
- `urgency` (1-5)
- `learning_impact` (1-5)
- `confidence` (low/medium/high)

### Step 3: Existing-LearnHub coverage map (internal grounding)

Before locking priorities, map each candidate area against current LearnHub content. For each area, record:

- `coverage` = `present` | `partial` | `absent`
- linked local evidence (paths) or "none found"
- the taxonomy category it belongs to (Overview, Getting Started, Concepts, How-to, Analysis, Reference, Resources)

**📖 Taxonomy:** `06.00-idea/learning-hub/02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md`

### Step 3.5: Source-soundness gate

Before investing in deep analysis, assess the source itself against the rubric (📖 `09-source-soundness-gate.md`) and emit `source_verdict`: `sound` → proceed; `promising-but-unverified` → proceed only with mandatory external corroboration and explicit caveats; `insufficient` (ambiguous, contradictory, thin, or low-value) → STOP, return "source insufficient" with what would raise it. Re-asserted as a hard precondition at Steps 9–10.

### Step 4: Prioritize tracks and depth

Select tracks using triage scores and coverage gaps (prefer high-impact `absent`/`partial` areas). Recommend depth per track: `quick` | `standard` | `deep`.

### Step 5: Focused investigation

Run focused research for selected tracks:

- local repository evidence first
- authoritative external evidence second
- explicit separation: facts vs assumptions vs open questions

### Step 6: Per-area in-depth analysis

For every `standard` and `deep` track, produce one structured analysis containing:

1. Problem statement
2. Additional considerations
3. Deductions
4. Conclusions
5. Appendix A — Evidence (local + external, classified)
6. Appendix B — Validation (how conclusions were checked)

`quick` tracks may collapse to a short conclusion note. Deep tracks MAY be delegated to `documentation-researcher`.

**Deduction-validation loop.** Surface each load-bearing deduction as a challengeable claim. On a user correction, treat it as a failing condition — re-derive from evidence and re-check before locking conclusions.

### Step 7: External pattern contrast (conditional)

Only when the recommendation depends on workflow-pattern choice, compare chain-first retrieval, agentic retrieval, and multi-agent orchestration (strengths, weaknesses, expected UX, fit) and select `selected_workflow_pattern`. Otherwise record `not_applicable` with a one-line reason.

### Step 8: Proposed result package

Produce a discussion-ready package:

- triage verdict
- coverage map summary
- prioritized tracks and depth
- per-area conclusions
- concise recommendation/answer
- confidence and assumptions
- open decisions for user

**Report-quality conditions** (all MUST hold before the package is presentable): even-handed comparison (similarities / differences / strengths / weaknesses — never competitive "ahead/behind"); inline provenance (a source callout plus claim-to-source links); vision-vs-implementation accuracy (never label an implementation-maturity gap as a design gap). General writing voice follows `article-writing.instructions.md`.

### Step 9: Approval gate

Use explicit states:

- `pending` (proposal delivered)
- `revised` (updated after feedback)
- `approved` (user accepted)

Integration proposal is forbidden before `approved`.

**Source-soundness precondition.** Integration is additionally forbidden unless `source_verdict` is `sound`, or a `promising-but-unverified` source has since been corroborated — regardless of how polished the proposal looks.

### Step 10: Post-approval integration proposal

**Two derived integration modes (detected, not asked).** (a) **Tech-article integration** — taxonomy-bound placement, detailed below. (b) **Meta/architecture amendment** — when the observation changes visions or PE artifacts rather than reader-facing tech content, the deliverable is a gated recommended-plan that amends the affected artifacts under the `plan-execution` and `vision-amendment` rules, not a placed article. Detect by impact: new tech topic → (a); impact on `06.00-idea` visions or `.github` PE artifacts → (b); mixed → both.

For mode (a), after approval, propose a LearnHub integration plan that maps every approved conclusion to:

- a taxonomy category (Overview / Getting Started / Concepts / How-to / Analysis / Reference / Resources)
- a concrete target path (prefer a `03.00-tech/<subject>/` subject folder)
- section-level edits, sequencing, risks, and dependencies

**Placement is derived, not asked.** Compute each article's folder and numeric prefix from its taxonomy content-type using the subject-folder template (`00-overview` · `01-getting-started` · `02-concepts` · `03-how-to-*` · `04-analysis-*` · `05-reference` · `06-resources`); when a content-type band is already occupied, use a fractional `XX.YY-` prefix (e.g. a second Concepts article becomes `02.01-…`). 📖 `.copilot/context/90.00-learning-hub/06-folder-organization-and-navigation.md`.

**Integration completeness is the default, not a scope option.** Weave every approved result fully into the corpus: correct taxonomy-band placement, bidirectional cross-links (related articles, the subject overview's "where to go next", navigation), consolidation of duplicated explanation into the single canonical article, and closure of related backlog items. Do not ask the user how much to integrate.

**Reserve user questions for judgment calls** — the proposed answer/recommendation, integration approval, and genuine scope conflicts — not mechanical numbering or whether to integrate.

Building the integrated articles MAY be delegated to `documentation-builder`. Only execute integration edits after explicit implementation confirmation.

## Issue-folder artifact contract

Use `<issue-folder>/research/` and maintain at minimum:

1. `01-triage-interest-map.md` (includes context-harvest signals)
2. `02-existing-coverage-map.md` (internal grounding: present/partial/absent + taxonomy)
3. `03-triage-priority-and-depth.md`
4. `04-investigation-backlog.md`
5. `05-analysis/` — one `<area-slug>.md` per standard/deep area (problem → conclusions + appendices)
6. `06-external-approaches-contrast.md` (only when Step 7 applies)
7. `07-proposed-result-package.md`
8. `08-approval-and-integration-proposal.md`

Before returning, VALIDATE that persisted filenames match this contract and report any drift.

## Output contract

Every run must return:

1. `triage_verdict`
2. `context_signals`
3. `coverage_map`
4. `source_verdict`
5. `priority_tracks`
6. `area_analyses`
7. `selected_workflow_pattern` (or `not_applicable`)
8. `proposed_result_package`
9. `approval_state`
10. `integration_proposal` (only if approved) — `taxonomy_mapping` in article mode, or a gated `amendment_plan` reference in meta/architecture mode
11. `artifacts_written`

## References

- `src/docs/90. Issues/` for issue-first research workflow
- `03.00-tech/` for long-form integration targets
- [Get Started with AI Architecture Design - Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/) 📘 [Official]
- [LangChain Agents](https://docs.langchain.com/oss/python/langchain/agents) 📗 [Verified Community]
- [Using tools (OpenAI)](https://developers.openai.com/api/docs/guides/tools) 📗 [Verified Community]

## Version history

- **v2.3.0** (2026-07-11): Added a source-soundness gate (Step 3.5 + `09-source-soundness-gate.md`) with a gating verdict, and a hard integration precondition barring unsound or uncorroborated sources.
- **v2.2.0** (2026-07-11): Added a deduction-validation loop (Step 6), report-quality conditions (Step 8: even-handed comparison, inline provenance, vision-vs-implementation accuracy), and two derived integration modes (Step 10: tech-article vs meta/architecture amendment plan).
- **v2.1.0** (2026-07-06): Made article placement (folder + numeric prefix) a derived, agent-owned decision via the subject-folder template; made full corpus integration the default; barred mechanical numbering/integration-scope questions to the user.
- **v2.0.0** (2026-07-06): Added context harvest, internal coverage map, per-area in-depth analysis, taxonomy-bound integration, and artifact self-validation. Renumbered artifact contract; external pattern contrast made conditional.
- **v1.0.0** (2026-07-03): Initial single-entry workflow contract.

<!--
context_metadata:
  version: "2.3.0"
  created: "2026-07-03"
  last_updated: "2026-07-11"
-->
