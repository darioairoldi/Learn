---
title: "Context improvement plan for pe-meta-builder validation hardening"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
validation_scope: "context-support-for-agent-validation"
source_status_file: "../02.02-validation-status-pe-meta-builder.md"
---

# Context improvement plan for pe-meta-builder validation hardening

Purpose: keep pe-meta-builder validations fully passing over time by improving the context layer that A-04 guidance adherence depends on.

Current state from this run:

- pe-meta-builder validation is complete.
- No blocking failures were found in G-01..G-05 and A-01..A-05.
- This plan focuses on hardening and drift prevention.

## Target outcomes

1. Preserve complete status for A-04 guidance adherence in future runs.
2. Reduce risk of regression caused by context drift, reference drift, or rule fragmentation.
3. Make reruns faster with deterministic checks and clearer evidence anchors.

## Improvement areas for context files

### 1. Canonical rule anchors for builder-critical behaviors

Actions:

1. In context files under `.copilot/context/00.00-prompt-engineering/`, add explicit anchor lines for builder-critical rules:
- pre-change guard
- post-change reconciliation
- construction invariants
- deterministic-first checks
2. Standardize one canonical source per rule and replace duplicate normative text with short references.

Success criteria:

- Each builder-critical behavior maps to one canonical context source.
- Duplicate normative statements reduced to intentional and documented exceptions.

### 2. Dependency-map freshness discipline

Actions:

1. Add a small deterministic check in validation runbooks to detect stale references between:
- `05.01-artifact-dependency-map.md`
- `STRUCTURE-README.md`
- active pe-meta agent files
2. Record stale-reference findings in status execution logs before semantic checks.

Success criteria:

- No stale or broken local references in builder-relevant context files.
- Dependency-map update rule is enforced in every change cycle.

### 3. Guidance adherence matrix for pe-meta agents

Actions:

1. Create or refresh a compact matrix artifact that maps each pe-meta agent behavior to context rule sources.
2. For pe-meta-builder specifically, include rows for:
- metadata contract
- boundary system
- handoff integrity
- deterministic-first/efficiency

Success criteria:

- A-04 can be validated with deterministic evidence first, then semantic checks.
- Missing guidance coverage is detectable in one place.

### 4. Drift-safe reference style normalization

Actions:

1. Normalize reference style in builder-relevant context files to prefer category-level references for external consumers.
2. Keep file-level references only where precision is required.

Success criteria:

- Reduced false failures from file renames.
- Better alignment with chain-alignment guidance.

## Execution sequence

1. Run deterministic link and metadata checks across `.copilot/context/00.00-prompt-engineering/`.
2. Patch rule-anchor clarity and canonical references in affected context files.
3. Refresh dependency and adherence mapping artifacts.
4. Re-run pe-meta-builder dedicated prompts (A-04 first, then full set).
5. Update `../02.02-validation-status-pe-meta-builder.md` with rerun evidence.

## Validation rerun checklist

- ✅ Context deterministic checks rerun captured.
- ✅ Canonical rule-anchor updates applied.
- ✅ Dependency-map freshness checks pass.
- ✅ A-04 rerun captured with explicit evidence links.
- ✅ Full builder validation remains complete.

## Completion notes

- ✅ Improvement-plan execution completed on 2026-05-21 15:19:37.
- Updated canonical builder-critical rule anchors in `.copilot/context/00.00-prompt-engineering/02.04-agent-shared-patterns.md`.
- Added deterministic freshness discipline in `.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md`.
- Created guidance adherence matrix: `20260521-guidance-adherence-matrix-pe-meta-agents.md`.
- Captured deterministic rerun evidence:
	- `20260521-context-deterministic-checks.txt`
	- `20260521-builder-rerun-evidence.txt`
- Logged rerun completion evidence in `../02.02-validation-status-pe-meta-builder.md` execution log.

## Evidence targets

- `../02.02-validation-status-pe-meta-builder.md` execution log
- `../02.00-validation-status.md` status index

