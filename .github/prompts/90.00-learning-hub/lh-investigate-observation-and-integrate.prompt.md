---
name: lh-investigate-observation-and-integrate
description: "Single-entry workflow: investigate a user question, propose results, discuss/approve, then propose LearnHub integration"
agent: agent
model: claude-opus-4.6
domain: "learning-hub"
tools:
  - read_file
  - list_dir
  - file_search
  - grep_search
  - semantic_search
  - fetch_webpage
  - vscode_askQuestions
  - create_file
  - replace_string_in_file
  - multi_replace_string_in_file
argument-hint: 'question="your observation/question" source="optional path to overview.md"'
---

# LH investigate observation and integrate

Run one complete flow from user question to approval-gated integration proposal.

**📖 Workflow authority:** `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`

## Purpose

1. Accept one user question as input.
2. Run triage + focused investigation.
3. Propose a decision-ready result package.
4. Discuss and capture approval state.
5. Propose LearnHub integration only after approval.

## Boundaries

### Always do

1. Harvest current context (active file, sibling issues, repo) to seed candidate areas.
2. Start with local evidence, then expand to authoritative external sources.
3. Produce an existing-LearnHub coverage map before locking priority tracks.
4. Separate facts, assumptions, and open questions.
5. Produce a per-area in-depth analysis for every standard/deep track.
6. Contrast external approaches only when recommendation quality depends on workflow-pattern choice.
7. Persist workflow artifacts in the issue-folder research subfolder.
8. Present proposal before integration.
9. Propose integration only after explicit approval, mapping each target to a taxonomy category.
10. Derive each article's folder and numeric prefix from its taxonomy content-type via the subject-folder template (00 overview · 01 getting-started · 02 concepts · 03 how-to · 04 analysis · 05 reference · 06 resources; fractional `XX.YY-` for additional articles in one band).
11. Integrate every approved result fully into the corpus (taxonomy-band placement, bidirectional cross-links, redundancy consolidation, related-backlog closure).

### Never do

- Never treat assumptions as facts.
- Never lock priority tracks before the coverage map exists.
- Never integrate before approval.
- Never edit top YAML metadata of existing articles during investigation updates.
- Never ask the user to choose article numbering/positioning or whether to integrate — these are agent-owned decisions governed by LearnHub criteria.

## Execution steps

1. Intake + context harvest.
2. Fast triage (seed areas from question AND context).
3. Existing-LearnHub coverage map (internal grounding + taxonomy).
4. Prioritize tracks and depth.
5. Focused investigation (local-first, then external).
6. Per-area in-depth analysis (problem → conclusions + appendices).
7. External pattern contrast (conditional).
8. Proposed result package.
9. Approval state (`pending`/`revised`/`approved`).
10. Post-approval, taxonomy-bound integration proposal.

## Artifact contract

Write/update under `<issue-folder>/research/`:

1. `01-triage-interest-map.md` (includes context-harvest signals)
2. `02-existing-coverage-map.md` (internal grounding: present/partial/absent + taxonomy)
3. `03-triage-priority-and-depth.md`
4. `04-investigation-backlog.md`
5. `05-analysis/` — one `<area-slug>.md` per standard/deep area
6. `06-external-approaches-contrast.md` (only when Step 7 applies)
7. `07-proposed-result-package.md`
8. `08-approval-and-integration-proposal.md`

Before returning, validate that persisted filenames match this contract and report any drift.

## Output contract

Return:

1. `triage_verdict`
2. `context_signals`
3. `coverage_map`
4. `priority_tracks`
5. `area_analyses`
6. `selected_workflow_pattern` (or `not_applicable`)
7. `proposed_result_package`
8. `approval_state`
9. `integration_proposal` with `taxonomy_mapping` (only if approved)
10. `artifacts_written`

<!--
prompt_metadata:
  version: "2.0.1"
  created: "2026-07-03"
  last_updated: "2026-07-06"
-->
