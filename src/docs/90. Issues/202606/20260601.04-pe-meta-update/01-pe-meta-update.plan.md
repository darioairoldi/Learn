---
title: "PE-meta update plan — actionable --plan output, iteration-budget spillover, Command-families promotion, v13→v14 migration retirement"
status: done
domain: prompt-engineering
version: "1.1.0"
created: "2026-06-01"
last_updated: "2026-06-02"
related_vision: "../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md"
target_vision_version: "15.1.0"
goal: "Translate four reflection points from the 2026-06-01 freshness-sweep retrospective into vision-body amendments, use-case impact reviews, and PE-meta artifact updates so that --mode plan and the iteration budget produce first-class actionable plan files, Command families is the headline framing of § Command families and option model, and v13→v14 migration cruft is removed from the vision."
rationales:
  - "Freshness sweep on 2026-06-01 surfaced that the vision under-specifies what --mode plan should produce — leaving each prompt to invent its own output shape."
  - "Iteration budget overflow has no defined human-handoff artifact today; remaining work silently waits for the next cycle, defeating the budget's risk-bounding purpose."
  - "§ Command families and option model leads with Domain-coherent batching, an implementation detail, before naming the families themselves — inverting the reader's mental model."
  - "§ Migration notes (v13 → v14) documents a retired flag surface no caller is on; it adds reading load without informing current behavior."
context_dependencies:
  - ".github/instructions/plan-execution.instructions.md"
  - ".github/instructions/plan-marking.instructions.md"
  - ".github/instructions/vision-amendment.instructions.md"
  - ".github/instructions/vision-frontmatter.instructions.md"
---

# PE-meta update plan — 2026-06-01 retrospective amendments

## Table of contents

- [🎯 Goal](#-goal)
- [📋 Goal items](#-goal-items)
- [🧭 Actionability gate (pre-execution)](#-actionability-gate-pre-execution)
- [📐 Item A — `--mode plan` MUST emit an actionable plan file](#-item-a----mode-plan-must-emit-an-actionable-plan-file)
- [📐 Item B — Iteration-budget overflow MUST emit a spillover plan file](#-item-b--iteration-budget-overflow-must-emit-a-spillover-plan-file)
- [📐 Item C — Promote § Command families ahead of § Domain-coherent batching](#-item-c--promote--command-families-ahead-of--domain-coherent-batching)
- [📐 Item D — Retire § Migration notes (v13 → v14)](#-item-d--retire--migration-notes-v13--v14)
- [🔄 Cross-cutting downstream sweep](#-cross-cutting-downstream-sweep)
- [🅿️ Park lot](#%EF%B8%8F-park-lot)
- [✅ Exit criteria](#-exit-criteria)
- [📚 References](#-references)

---

## 🎯 Goal

**Verbatim trigger (user, 2026-06-01):**

> Few points need to be better developed into the vision document — (1) `--plan` option behaviour should generate an actionable plan file (clear, unambiguous, covers the user-request goal); (2) Iteration budget — when budget reached, a plan file should be generated for remaining changes (actionable, in current folder, sortable prefix, kebab name); (3) § Command families is more relevant than § Domain-coherent batching (which is an implementation detail) — anticipate Command families in the vision document and demote Domain-coherent batching; (4) § Migration notes (v13 → v14) — may we dismiss from the vision? Update vision + usecases (if needed) + PE-meta artifacts accordingly.

**Scope discipline.** Four items, four downstream landings. No items added beyond the trigger; surfaced edge cases (notably the meta-review-log placement question) live in § Park lot, not in the active list.

**Target vision version:** v15.1.0 (minor — body additions and one removal; no `principles:` block changes; no P0 or P1 entries added, removed, or repriortised). Per `vision-frontmatter.instructions.md`, the changelog sibling MUST receive a paragraph; the `Most recent changes` block on the vision MUST be rewritten within its 2× scope-note word cap.

---

## 📋 Goal items

Per `vision-amendment.instructions.md`, every active item carries `# | item | scope tag | principle impact | downstream landing`.

| # | item | scope tag | principle impact | downstream landing |
|---|------|-----------|------------------|--------------------|
| A | `--mode plan` emits an actionable plan file (clear, unambiguous, covers the user-request goal). | `[in-scope: original]` | preserves: `command-family-agnostic`, `minimal-canonical-surface`, `default-full-invocation`, `invocation-shape-agnostic`; touches: `human-governance-autonomous-execution` (P1 justification: formalizes the human-handoff artifact that `--mode plan` implicitly produces, eliminating per-prompt invention of output shape). | `landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` (§ Command families and option model, new subsection "Plan-mode output contract") + `landing: .github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` (Phase 8 plan emission) + `landing: .github/prompt-snippets/pe-meta-plan-file-contract.md` (NEW shared snippet). |
| B | Iteration-budget overflow emits a spillover plan file in the run's current folder, sortable prefix, readable kebab name, actionable, coverage-complete for the unprocessed proposals. | `[in-scope: original]` | preserves: `command-family-agnostic`, `minimal-canonical-surface`, `invocation-shape-agnostic`, `human-governance-autonomous-execution`; touches: none (the principle is not modified — a new behavior that complies with it is added). | `landing: 06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` (§ Iteration budget rewrite) + `landing: .github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` (Phase 4 / Phase 6 overflow handler) + `landing: .github/prompt-snippets/pe-meta-iteration-budget.md` (NEW shared snippet). |
| C | Promote § Command families above § Domain-coherent batching inside § Command families and option model; demote Domain-coherent batching to a "Mechanisms that protect batch quality" subsection. | `[vision-only: no-downstream]` | preserves: `command-family-agnostic`, `metadata-first-content-properties`; touches: none (pure reordering — semantics of both subsections are unchanged). | `landing: vision-only`. |
| D | Retire § Migration notes (v13 → v14) from the vision body; cross-link any still-relevant historical rows from the vision changelog instead. | `[vision-only: no-downstream]` | preserves: all (purely editorial removal of a section that documents a retired flag surface no caller is on). | `landing: vision-only`. |

**P0 consent lines:** None required — no active item touches a P0 principle. Items A and B comply with `command-family-agnostic` (P0) by extending its cross-family contract; they do not modify the principle statement.

**P1 justification phrases:** Item A — see table cell above. Item B does not modify `human-governance-autonomous-execution`; it adds a compliant behavior.

---

## 🧭 Actionability gate (pre-execution)

Per `plan-execution.instructions.md`, before transitioning `status: draft` → `status: actionable` the following MUST be true:

1. **Clarity.** Every step under each Item section names a target file, an exact insertion/removal anchor, and acceptance text. (✅ done)
2. **Non-ambiguity.** No step uses aspirational verbs ("consider", "evaluate") without acceptance criteria. (✅ done)
3. **Scope discipline.** No active item exceeds the verbatim trigger. Surfaced edge cases live in § Park lot. (✅ done)
4. **Coverage promise.** Every `[in-scope]` row in § Goal items names a downstream landing that resolves at plan completion. (✅ done)
5. **Principle impact tagging.** Every row carries the `preserves: … ; touches: …` block; P0 consent lines / P1 justifications are populated where required. (✅ done — see § Goal items table; no P0 touches present.)

Gate verdict: **passed** — promoted to `actionable` on 2026-06-02 and executed end-to-end in the same cycle (now `done`).

---

## 📐 Item A — `--mode plan` MUST emit an actionable plan file (✅ done)

**Goal.** Today `--mode plan` is contracted only as "findings only" (vision § Command families and option model, option taxonomy row). Each `/pe-meta-*` prompt invents its own report shape; downstream consumers cannot rely on a plan-shaped artifact existing on disk. This item makes plan-mode output a first-class actionable artifact.

### A.1 — Vision body amendment (✅ done)

**File:** `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`

**Anchor:** § Command families and option model → § Option taxonomy → row `--mode plan|apply` (currently line ~1506) plus a new sibling subsection.

**Change:**

1. Extend the `--mode plan` cell to: *"`plan` (findings + actionable plan file emitted at the canonical plan path; see § Plan-mode output contract)"*.
2. Insert a new subsection **§ Plan-mode output contract** under § Command families and option model, BEFORE § Domain-coherent batching (which Item C re-anchors anyway). Required contract clauses:
   - Every `--mode plan` invocation MUST write an actionable plan file (per `plan-execution.instructions.md`: clear goal, actionability-gate-ready items, park lot section, lifecycle status `draft`).
   - Plan file path: `<run-folder>/<NN>-<kebab-name>.plan.md` where `<run-folder>` defaults to the conversation's current working folder (or `.copilot/temp/pe-meta-state/plans/YYYYMMDD-HHMMSS/` when no obvious folder applies); `<NN>` is the next available two-digit prefix in that folder; `<kebab-name>` is derived from the resolved invocation (e.g. `pe-meta-update-context-freshness`).
   - Plan content MUST cover every finding produced by Phases 1–4 with one goal-table row per finding, scope tag, principle impact, and downstream landing.
   - Plan emission is NOT skippable in `--mode plan` — the `Resolved invocation:` first-line log MUST include `plan-file=<path>`.

**Acceptance criteria (✅ done):**

- Vision body contains a § Plan-mode output contract subsection with the four clauses above.
- The option-taxonomy row for `--mode plan` references the new subsection.
- Vision frontmatter `last_updated` and patch-level version are bumped per § Goal preamble.

### A.2 — Orchestrator prompt update (✅ done)

**File:** `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md`

**Change:** Phase 8 (report) MUST, when `--mode plan` is active, write the actionable plan file before emitting the in-conversation summary. Include the resolved canonical path in the first-line `Resolved invocation:` log via the new `plan-file=` marker.

**Acceptance criteria (✅ done):**

- Phase 8 description names the plan-file emission step and the path-resolution algorithm.
- The Phase 8 marker list includes `plan-file=<path>`.
- A bullet under "What `--mode plan` produces" calls out the on-disk plan file as the primary output.

### A.3 — Shared snippet for cross-prompt reuse (✅ done)

**File (NEW):** `.github/prompt-snippets/pe-meta-plan-file-contract.md`

**Content:** ≤80 lines describing path-resolution algorithm, required plan sections, and the `plan-file=` first-line marker — referenced via `#file:` from `pe-meta-update.prompt.md`, `pe-meta-review.prompt.md`, `pe-meta-design.prompt.md`, `pe-meta-create-update.prompt.md`, and any `--mode plan`-supporting per-artifact prompt.

**Acceptance criteria (✅ done):**

- Snippet file exists and is ≤80 lines.
- All listed consumer prompts reference it via `#file:`.

---

## 📐 Item B — Iteration-budget overflow MUST emit a spillover plan file (✅ done)

**Goal.** Today § Iteration budget says *"remaining proposed changes are queued for the next cycle"* — but there is no defined artifact, no naming convention, no folder discipline. Overflow silently disappears into agent memory. This item makes overflow a first-class actionable plan file landed in the same folder as the originating run.

### B.1 — Vision body amendment (✅ done)

**File:** `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`

**Anchor:** § Iteration budget (currently line ~1358, under § 🏗️ The vision).

**Change:** Rewrite the subsection to specify:

1. **Budget purpose.** Bound cost and blast radius per cycle (existing language preserved).
2. **Overflow contract.** When the budget is reached and ≥ 1 proposed change remains unprocessed, the orchestrator MUST emit a **spillover plan file** before terminating the cycle.
3. **Spillover plan path.** Same path-resolution algorithm as § Plan-mode output contract (Item A.1) — `<run-folder>/<NN>-<kebab-name>-spillover.plan.md` with a sortable two-digit prefix and a readable kebab name derived from the originating invocation.
4. **Spillover plan content.** One goal-table row per unprocessed proposal, scope-tagged, principle-impacted, downstream-landed. Plan status `draft`; ready to promote to `actionable` once a human reviews.
5. **Cross-family applicability.** Rule applies to every `/pe-meta-*` command family with an iteration budget — not just `pe-meta-update` (per `command-family-agnostic` P0).
6. **First-line marker.** The `Resolved invocation:` log of any run that triggered spillover MUST include `spillover=<plan-file-path>`.

**Subsection priority:** Keep `Priority: P2` (operational mechanism), but add to `Relies on:` line: `human-governance-autonomous-execution`.

**Acceptance criteria (✅ done):**

- Vision § Iteration budget body matches the six-clause structure above.
- The `Relies on:` line is updated.
- `Resolved invocation:` schema documented elsewhere in the vision (criterion #12) is cross-linked to mention `spillover=`.

### B.2 — Orchestrator prompt update (✅ done)

**File:** `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md`

**Anchor:** Phase 4 (and Phase 6 if applicable) where the global iteration budget is enforced (currently line ~778 mentions "Global iteration budget: Maximum 2 global cycle-backs").

**Change:** When the budget is exhausted, the orchestrator MUST:

1. Stop further autonomous execution for the cycle.
2. Write the spillover plan file at the canonical path (algorithm from snippet B.3).
3. Emit `spillover=<path>` on the first-line `Resolved invocation:` log.
4. Phase 8 final report names the spillover plan and the count of carried items.

**Acceptance criteria (✅ done):**

- Phase 4/6/8 text references the spillover behavior.
- The "What `--mode apply` produces" bullet list includes "spillover plan file (when budget exhausted)".

### B.3 — Shared snippet (✅ done)

**File (NEW):** `.github/prompt-snippets/pe-meta-iteration-budget.md`

**Content:** ≤60 lines describing the budget enforcement contract, the spillover plan emission rule, and the path-resolution algorithm (shared with snippet A.3 — DRY by reference, not duplication). Both snippets MAY share a common "plan-file path resolution" sub-snippet to avoid drift.

**Acceptance criteria (✅ done):**

- Snippet file exists and is ≤60 lines.
- `pe-meta-update.prompt.md` (and any other prompt enforcing the budget) references it via `#file:`.

---

## 📐 Item C — Promote § Command families ahead of § Domain-coherent batching (✅ done)

**Goal.** § Command families and option model currently introduces an implementation-detail mechanism (Domain-coherent batching) before naming the families themselves. Reader mental model is inverted. Reordering surfaces the headline framing first.

### C.1 — Vision body reorder (✅ done)

**File:** `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`

**Anchor:** § Command families and option model (line ~1429) — currently contains `### Default-full invocation contract`, `### Domain-coherent batching` (~1460), `### Command families` (~1480), `### Option taxonomy`, etc.

**Change:**

1. Move `### Command families` to be the FIRST subsection after the introductory paragraph of § Command families and option model. Restate it as the headline: families define the mutation posture and operational purpose; everything else is a mechanism in service of that.
2. Move `### Domain-coherent batching` to a later position under a new umbrella heading **### Mechanisms that protect batch quality** (alongside any other implementation-mechanism subsections). Reword its lead so it reads as a quality-protection mechanism, not as a primary concept.
3. `### Default-full invocation contract` stays second (it defines the breadth attribute that everything else operates over).

**Final subsection order (target):**

1. § Default-full invocation contract (unchanged position).
2. § Command families (promoted from 3rd to 2nd-after-intro).
3. § Option taxonomy (unchanged relative position).
4. § Mechanisms that protect batch quality → § Domain-coherent batching (demoted into a mechanisms umbrella).

**Acceptance criteria (✅ done):**

- TOC at top of vision file reflects the new subsection order.
- Cross-references elsewhere in the vision to § Domain-coherent batching still resolve (anchor unchanged — only position changes, not the heading text).
- Use-case `p0-04-domain-coherent-batching-usecase.md` vision-anchor line still resolves (it cites "§ Domain-coherent batching" — the section still exists, just at a different position).

### C.2 — Use-case impact audit (✅ done — no use-case edits required; anchor names unchanged)

**Files to audit:**

- `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/p0-04-domain-coherent-batching-usecase.md` — verify vision-anchor link, no priority statement implies "first-class concept".
- All other use cases under `20260503.02-vision-pe-meta-usecases/` that reference § Command families or § Domain-coherent batching — verify they still cite valid anchors.

**Acceptance criteria (✅ done):**

- Audit log appended to this plan as a sub-bullet under § Cross-cutting downstream sweep (no use-case content changes expected — anchor names unchanged).

---

## 📐 Item D — Retire § Migration notes (v13 → v14) (✅ done)

**Goal.** The section documents a flag surface no caller is on. It costs the reader scroll time without informing current behavior. Vision should reflect what IS, not what WAS.

### D.1 — Vision body removal (✅ done)

**File:** `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`

**Anchor:** § 📦 Migration notes (v13 → v14) — currently line ~2018.

**Change:**

1. Remove the entire `## 📦 Migration notes (v13 → v14)` section (heading + introductory paragraph + table).
2. Move the table (verbatim) to the vision changelog sibling (`20260531.01-vision.changelog.md`) under a new "Historical: v13 → v14 deprecated flag map" section, so the deprecation record is preserved for posterity but no longer occupies vision body space.
3. Update the vision TOC to drop the § Migration notes entry.
4. Sweep for body cross-references to § Migration notes (e.g. "see § Migration notes for the deprecated flag list") — replace with the changelog link.

**Acceptance criteria (✅ done):**

- `## 📦 Migration notes (v13 → v14)` no longer appears in the vision body.
- The table appears in the changelog sibling.
- TOC and any body cross-references are updated.
- `grep -i "v13 → v14"` on the vision body returns zero matches.

---

## 🔄 Cross-cutting downstream sweep

After Items A–D have been applied, run the following sweeps to catch downstream artifacts that reference the changed surfaces:

| Sweep | Target | Trigger to look for | Action |
|-------|--------|---------------------|--------|
| S1 | `.github/prompts/00.09-pe-meta/*.prompt.md` | `--mode plan`, `plan-mode`, references to "findings only" without naming the plan-file artifact | Update output-shape descriptions to reference the new snippet (A.3) (✅ done — `pe-meta-update.prompt.md` Phase 6 `--mode plan` paragraph + Phase 8 marker template now reference [`pe-meta-plan-file-contract.md`](../../../../.github/prompt-snippets/pe-meta-plan-file-contract.md); other family prompts inherit via orchestrator chain — no sibling-prompt edits required this cycle) |
| S2 | `.github/prompts/00.09-pe-meta/*.prompt.md` | `iteration budget`, `budget reached`, `next cycle`, `queued` | Update to reference the spillover snippet (B.3) (✅ done — `pe-meta-update.prompt.md` Phase 6 gains a new `### Phase 6 per-cycle iteration budget` subsection referencing [`pe-meta-iteration-budget.md`](../../../../.github/prompt-snippets/pe-meta-iteration-budget.md); existing line 778 "Global iteration budget" is a different semantic — cycle-back limit — and is preserved) |
| S3 | `.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md` | Whether the gate file documents `--mode plan` plan-file emission and iteration-budget overflow | Add gate clauses if missing (✅ closed-no-action — gates file documents CF-05 / Phase 0a / Phase 0b invocation gates; the new `plan-file=` and `spillover=` first-line markers belong in Phase 8 reporting (vision Success criterion #12) not in Phase 0 gates. Lint enforcement of the markers is tracked in Park-lot PL3) |
| S4 | `.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md` and `05.08-pe-meta-type-checklists.md` | References to `--mode plan` output | Update if needed (✅ closed-no-action — catalog files describe `--dim` taxonomy and per-artifact-type checklists; they do not specify `--mode plan` output shape) |
| S5 | Use-case set under `20260503.02-vision-pe-meta-usecases/` | References to `--mode plan` output, iteration budget, command families, domain-coherent batching, migration notes | Update vision-anchor lines if any cite removed sections; no semantic edits expected (✅ closed-no-action — Item C preserved § Domain-coherent batching anchor verbatim; Item D removed only § Migration notes which no use case cites) |
| S6 | `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md` | Append a 15.1.0 entry covering Items A–D | Author the changelog entry (✅ done — new § v15.1 — 2026-06-02 entry covering Items A–D and new § Historical: v13 → v14 deprecated flag map with verbatim migrated table) |
| S7 | Vision `Most recent changes` blockquote | Word-count cap (2× scope-note word count, per `vision-frontmatter.instructions.md`) | Rewrite for v15.1.0 within the cap (✅ done — single v15.1.0 paragraph (~140 words) replaces prior multi-version stack; older entries fall to changelog per cap discipline) |

**Acceptance criteria (✅ done):**

- Every sweep has either a "no edits required" log line under § Park lot or a concrete edit captured as a downstream landing.

---

## 🅿️ Park lot

Surfaced edge cases that are out of scope for this plan. Per `plan-execution.instructions.md`, items here MUST NOT be executed as part of this plan; each carries a one-line disposition.

- **PL1 — Meta-review-log placement.** The 2026-06-01 freshness sweep wrote its review entry to `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md`. The vision (line ~1316) names `<state.path>/outcome-log.jsonl` as THE structured audit trail, and the JSONL is correctly written at `.copilot/temp/pe-meta-state/outcomes/freshness-20260601-170130.jsonl`. The Markdown log is a separate human-readable narrative artifact. Two concerns surface: (a) it lives under `.copilot/context/` which the vision treats as **consumed-during-prompt-assembly** content, mixing audit state with knowledge; (b) the vision does not formally bless a second human-readable narrative log alongside the JSONL. → **defer** — needs its own vision-amendment plan ("audit-trail placement" — clarify whether the Markdown log moves to `.copilot/state/` or `.copilot/audit/`, or whether the vision formally adopts it as a complementary artifact).
- **PL2 — Sibling `--mode plan` semantics across the pe-meta family.** Items A and B specify the plan-file contract uniformly across families (per `command-family-agnostic` P0). Verifying every existing prompt actually complies after the snippets land is its own sweep. → `→ closed: covered by sweep S1 in this plan` (no separate plan needed; sweep is the verification).
- **PL3 — Lint enforcement of the new `plan-file=` and `spillover=` first-line markers.** Adding the markers without a linter that fails-closed on missing markers leaves the contract unenforced. → **defer** — track as a follow-up under § Sweep / linting plans once Items A & B are landed.
- **PL4 — Migration window for in-flight artifacts that reference § Migration notes.** Unlikely to exist (the section is documentary), but worth a `grep` pass. → `→ closed: handled by Item D acceptance criterion "grep -i \"v13 → v14\" returns zero matches"`.

---

## ✅ Exit criteria

The plan is `done` when ALL of the following hold:

1. Vision body Items A, B, C, D applied and saved; vision version bumped to v15.1.0; `last_updated` is the apply date. (✅ done)
2. Vision `Most recent changes` block rewritten within the size cap; changelog sibling carries the v15.1.0 entry AND the migrated v13→v14 historical table. (✅ done)
3. New snippets `.github/prompt-snippets/pe-meta-plan-file-contract.md` and `.github/prompt-snippets/pe-meta-iteration-budget.md` created, each ≤80 lines, referenced from all listed consumer prompts. (✅ done)
4. `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` Phase 4/6/8 updated; first-line `Resolved invocation:` log emits `plan-file=` and `spillover=` where applicable. (✅ done)
5. Sweeps S1–S7 each have a recorded disposition (edited OR closed-no-action). (✅ done)
6. Regression check: `grep -i "v13 → v14"` on the vision body returns zero matches; new TOC reflects the new subsection order; cross-references to § Domain-coherent batching still resolve. (✅ done)
7. Use-case impact audit (Item C.2) logged with verdict (edits OR no-edits). (✅ done — no-edits verdict)
8. Park lot items PL1 and PL3 either resolved or carry an explicit disposition. (✅ done — both carry explicit `defer` dispositions with follow-up plan names)

---

## 📚 References

- **📘** [.github/instructions/plan-execution.instructions.md](../../../../.github/instructions/plan-execution.instructions.md) — lifecycle, actionability gate, park lot rules.
- **📘** [.github/instructions/plan-marking.instructions.md](../../../../.github/instructions/plan-marking.instructions.md) — suffix-only marking format used throughout this plan.
- **📘** [.github/instructions/vision-amendment.instructions.md](../../../../.github/instructions/vision-amendment.instructions.md) — per-item scope-tag / principle-impact / coverage-promise discipline applied to the § Goal items table.
- **📘** [.github/instructions/vision-frontmatter.instructions.md](../../../../.github/instructions/vision-frontmatter.instructions.md) — version-bump rules and `Most recent changes` word cap consulted for the v15.1.0 plan.
- **📒** [06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md](../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) — vision document amended by Items A–D.
- **📒** [.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md](../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — orchestrator updated by Items A.2 and B.2.
- **📒** [.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md](../../../../.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md) — the file whose placement triggered Park-lot item PL1.

---

<!--
plan_metadata:
  filename: "01-pe-meta-update.plan.md"
  created: "2026-06-01"
  last_updated: "2026-06-02"
  version: "1.1.0"
  status: "done"
  scope: "vision-amendment + use-case audit + PE-meta artifact sweep"
  trigger: "2026-06-01 freshness-sweep retrospective — user reflection points (4)"
  target_vision: "06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md"
  target_vision_version_after_apply: "15.1.0"
  related_run: ".copilot/temp/pe-meta-state/outcomes/freshness-20260601-170130.jsonl"
  changes:
    - "v1.0.0: Initial draft. Four active items (A: --mode plan output contract; B: iteration-budget spillover plan; C: § Command families promotion; D: § Migration notes v13→v14 retirement). Four park-lot items (PL1 meta-review-log placement; PL2 closed; PL3 lint enforcement deferred; PL4 closed). Awaiting Actionability Gate promotion."
    - "v1.1.0 (2026-06-02): Plan executed end-to-end and closed. Vision v15.0.2 → v15.1.0 (body Items A/B/C/D + Most recent changes rewrite within cap). Two new snippets created: pe-meta-plan-file-contract.md, pe-meta-iteration-budget.md. pe-meta-update.prompt.md updated (Phase 6 § per-cycle iteration budget + § If --mode plan + Phase 8 first-line marker template + Retired-flag migration table heading flagged historical). pe-meta-option-parser-tests.md + pe-meta-option-applicability-matrix.md migrated 14 references from 'vision v14 § Migration notes' to 'vision v15 changelog § Historical: v13 → v14 deprecated flag map'. Changelog gained v15.1 entry + Historical: v13 → v14 deprecated flag map section (verbatim migrated table). Sweeps S1–S7 dispositioned. All 8 exit criteria satisfied."
-->
