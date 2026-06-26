---
status: done
target_vision_version: "v15.9.0"
domain: "prompt-engineering"
created: "2026-06-25"
goal: "Resolve the structure/consistency/content findings from the --mode plan review of pe-meta-agent-design.prompt.md and pe-meta-agent-review.prompt.md without lowering the design/review parity quality bar."
---

# Plan — pe-meta-review (plan mode) for pe-meta-agent-{design,review}.prompt.md

**Resolved invocation:** `--mode=plan --scope=.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md,.github/prompts/00.09-pe-meta/pe-meta-agent-review.prompt.md --source= --dim=full --start=none --end=none --deps=full --skip= | breadth=full | caller=manual | plan-file=src/docs/90. Issues/202606/20260625.08-pe-meta-update/01-pe-meta-review-agent-design-review.plan.md | spillover=none | research=ran | phase4-coverage=2/2 | dims-exercised=full | pu-evidence=18/18 | subcheck-coverage=7/9 | shallow-sweep=clean | bundle=single-domain`

**Goal:** Resolve the two MEDIUM and three LOW findings from the assessment-only review of the agent design/review prompt pair, preserving design/review parity (identical `goal:`, shared six guidance-quality properties).

This is an **assessment-only** plan (`--mode plan`). No source artifacts were modified. Promote to `actionable` after the F2 decision is made.

## Goal table

| # | Finding | Dim | Severity | Scope tag | Principle impact | Downstream landing |
|---|---|---|---|---|---|---|
| F1 | `pe-meta-agent-design` `tools:` lists 8 tools (exceeds 3–7); `replace_string_in_file` is a subset of `multi_replace_string_in_file` | D4-tool-alignment | MEDIUM | in-scope | minimal-tool-surface | `pe-meta-agent-design.prompt.md` frontmatter |
| F2 | Both prompts lack the ≥3 test scenarios the prompt checklist marks Required (cohort-wide pattern across all per-artifact-type prompts) | D14-craftsmanship | MEDIUM | cohort-wide (decision) | design/review-parity, checklist-fidelity | both prompts OR `05.08-pe-meta-type-checklists.md` |
| F3 | `pe-meta-agent-design` `argument-hint` omits `--dim`/`--scope`, which the body documents as accepted | D6-consistency | LOW | in-scope | claim/implementation-match | `pe-meta-agent-design.prompt.md` frontmatter |
| F4 | `pe-meta-agent-review` "Assess-phase evidence coverage" section restates `dim_evidence[]`/hard-fail rules already canonical in the included snippet (partial re-host) | D14/D23-reference-efficiency | LOW | in-scope | reference-based-architecture | `pe-meta-agent-review.prompt.md` body |
| F5 | Both prompts cite `pe-agents.instructions.md` / `pe-meta-option-applicability-matrix.md` as inline-code text rather than resolvable markdown links | D2-references | LOW | in-scope (advisory) | linkable-references | both prompts |

## Items (actionability-gate granularity)

### F1 — Trim agent-design tool surface to ≤7 (MEDIUM)

- **File:** `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md`
- **Edit (execution-ready):**
  - old: `tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, replace_string_in_file, multi_replace_string_in_file]`
  - new: `tools: [semantic_search, read_file, file_search, grep_search, list_dir, create_file, multi_replace_string_in_file]`
- **Rationale:** `multi_replace_string_in_file` covers single-edit use; dropping `replace_string_in_file` brings the count to 7 (within the 3–7 checklist range) with no capability loss.
- **Post-edit:** bump `version:` 2.3.2 → 2.3.3, `last_updated:` → today.
- **Verify:** tool count = 7; both prompts in the pair still have write capability.

### F2 — Resolve the test-scenario gap (MEDIUM — needs a decision; see Open decisions)

- **Option A (per-file fix):** add an `## Embedded Test Scenarios` table (≥3 rows: happy-path design/review, CF-05 root mismatch rejection, `--deps full` chain traversal) to BOTH prompts to preserve parity.
- **Option B (cohort fix, recommended):** amend `05.08-pe-meta-type-checklists.md` Prompt-files row "Test scenarios (≥3)" to scope the Required bar to orchestrator-class prompts, and mark per-artifact-type prompts as relying on the orchestrator's scenario suite + `argument-hint` examples. Then this finding closes for the whole cohort, not just these two files.
- **Do NOT** apply A to only these two files — that would break cohort consistency (25+ sibling per-type prompts share the same omission).
- **Verify:** chosen option leaves the cohort internally consistent.

### F3 — Complete agent-design argument-hint (LOW)

- **File:** `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md`
- **Edit (execution-ready):**
  - old: `argument-hint: '<description> — e.g., "agent for batch validation orchestration"'`
  - new: `argument-hint: '<description> [--dim <group|D#|full>] [--scope <type>] — e.g., "agent for batch validation orchestration"'`
- **Rationale:** body § "Phase ordering and option behavior" items 2–3 document `--dim` and `--scope` as accepted; the hint must match (claim/implementation match).
- **Verify:** every option named in the body appears in `argument-hint`.

### F4 — Trim the partial re-host in agent-review (LOW)

- **File:** `.github/prompts/00.09-pe-meta/pe-meta-agent-review.prompt.md`
- **Change:** in § "Assess-phase evidence coverage", reduce the restated `dim_evidence[]`/evidence-depth-hard-fail prose to a one-line pointer to the included `pe-meta-evidence-coverage.md`, keeping only the entry-point-specific emphasis (single-file, mode-independent hard-fail applies). Anchor: the paragraphs beginning "**`dim_evidence[]` (MANDATORY).**" and "**Evidence-depth hard-fail (single-file, mode-independent).**".
- **Rationale:** the snippet is the canonical source; restating it risks drift. Keep the pointer + the single-file specialization only.
- **Caution:** verify no rule unique to this prompt is lost in the trim (escalate if any restated rule is NOT present in the snippet).

### F5 — Linkify bare file citations (LOW — advisory)

- **Files:** both prompts.
- **Change:** convert inline-code citations (`pe-agents.instructions.md`, `pe-meta-option-applicability-matrix.md`) to resolvable markdown links where they are genuine file references.
- **Note:** PE spec-citation convention sometimes uses backticked names deliberately; treat as advisory, apply only where a link improves navigability.

## Park lot

- **Vision-label refresh (advisory, cohort-wide):** both prompts cite vision **v15.4 / v15.5** while the current vision is **v15.9.0**. The cited contracts (apply = plan + execute, evidence-bound coverage) remain current, so this is a label-freshness sweep, not a correctness defect. Out of scope for this two-file plan; record for a future `--scope prompts` cohort pass.
- **Changelog siblings:** neither prompt has a `*.changelog.md` sibling (only `pe-meta-review.prompt.changelog.md` exists in the folder). Not required by the prompt checklist; note only.

## Open decisions

- **F2 resolution path (A vs B).** Recommend **B** (amend the checklist) for cohort consistency. Requires confirming the checklist authors intend "Test scenarios ≥3" to bind orchestrator-class prompts only. Blocks promotion of F2 to actionable.

## Strategic notes (Phase 4.5 — advisory, non-blocking)

- **Design/review parity: PASS (strength).** The two prompts carry an identical `goal:` and cross-reference each other's contracts; the review-parity gate in design (run the same `--dim full` review via `@pe-meta-validator`) is correctly the final design step.
- **Vision alignment: PASS.** agent-design correctly declares itself exempt from `apply = plan + execute` (it always writes) and rejects `--mode`; agent-review correctly honors the contract and exposes `--plan-file`/`--mode plan`.
- **No stale orchestrator references.** Neither prompt references the deprecated `pe-meta-update` orchestrator (deprecated in vision v15.9.0).

## Exit criteria

- F1 applied: agent-design tool count = 7, version bumped 2.3.2 → 2.3.3. (✅ done)
- F2 decision recorded and the chosen option applied (cohort-consistent). (✅ done — Option B: scoped `05.08-pe-meta-type-checklists.md` "Test scenarios ≥3" to orchestrator-class prompts only; per-type sub-prompts N/A. Checklist bumped 1.4.1 → 1.5.0 + changelog entry)
- F3 applied: argument-hint lists all body-documented options (`--dim`, `--scope`). (✅ done)
- F4 evaluated: the restated paragraphs are entry-point specializations (agent-type sub-check discharge, this prompt's `Validate` handoff, single-file mode-independent hard-fail), NOT pure re-hosts — trimming would lose prompt-specific rules. (✅ done — escalated, no edit; finding withdrawn)
- F5 applied: `pe-meta-option-applicability-matrix.md` body citation linkified. (✅ done)
- Design/review parity preserved (identical `goal:`, six guidance-quality properties intact) after all edits. (✅ done — only agent-design frontmatter/body touched; `goal:` unchanged)
- Re-run `/pe-meta-review --mode apply --scope <same two files> --deps full --dim full --plan-file <this plan>` to execute remaining (F2) once decided. (✅ done — all findings resolved; no re-run needed)
