---
title: "Plan: Use-case catalog realignment to vision v14 — default-breadth metadata, canonical seven-parameter surface, and v14 cross-references"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, pe-meta, usecases]
description: "Plan for amending the use-case catalog under [20260503.02-vision-pe-meta-usecases/](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) so that (a) every use case declares its `default_breadth` (`full` | `incremental` | `bounded-delta`) — the *resolved* breadth its canonical parameter-less invocation produces under the v14 default-full invocation contract; (b) every `primary_entry_point` and in-file invocation example is audit-clean against the v14 seven-parameter canonical surface (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`); (c) the README links out to the v14 vision's conversational pre-parser, per-artifact prompt invocation matrix, pipeline-phases / `--skip` mapping, and deprecated-flags migration table instead of redefining them; and (d) `usecase-index.json` records `default_breadth` per entry for tooling."
draft: false
status: "closed"
last_updated: "2026-05-29"
severity: "High"
component: "[20260503.02-vision-pe-meta-usecases/](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/)"
framework: "GitHub Copilot Customization v1.107 (vision v14.0.0)"
---

# Plan — Use-case catalog realignment to vision v14

**Parent issue:** [overview.md](overview.md)
**Companion plans:** [01-vision-update-plan.md](01-vision-update-plan.md) (✅ done, vision v14 applied), [02-pe-meta-update-plan.md](02-pe-meta-update-plan.md)
**Plan ID:** `02-usecases-update-plan`
**Date:** 2026-05-29 (revised against vision v14 surface)
**Status:** Closed (executed 2026-05-29 — see [✅ Completion notes](#-completion-notes-2026-05-29-execution))

---

## 📝 Revision note (2026-05-29) — supersedes prior v13.x draft

This plan was originally drafted against the v13.x intermediate proposal that exposed seven investigation strategies (`temporal`, `area`, `subject`, `source`, `artifact`, `consumer`, `concern`) as first-class slicers and a separate `--breadth` flag. **That proposal was deliberately collapsed in vision v14**:

- `--breadth` retired → breadth is a *derived attribute* (`full` / `incremental` / `bounded-delta`) logged on the first line of every run report.
- `--area`, `--artifact`, `--consumer` retired → absorbed by the **value-shape `--scope` parser** (artifact-type token OR path / comma-separated path list; folders end in `/`, files end in `.md`).
- `--subject`, `--concern` retired → resolved by **Phase 0a (conversational pre-parser)** into a canonical `--scope` enumeration before strict parsing.
- `--incremental`, `--catch-up` retired → derived from caller-type plus `--start` / `--end` window.
- `--adherence`, `--mode-review` retired → `--dim adherence` and auto-derived per-artifact mode from `--scope` artifact-type.

The catalog therefore does NOT need a `06-strategies/` folder (which would re-introduce the surface v14 collapsed), does NOT add a `strategies:` frontmatter field, and does NOT add a "Strategy" column to README tables. **Strategies are no longer a v14 axis.** Natural-language slicing is handled by Phase 0a; structural slicing is handled by value-shape `--scope`.

**Audit finding (2026-05-29).** A repository-wide grep across the catalog confirms zero use of `--breadth`, `--area`, `--adherence`, `--incremental` in any use-case markdown. The catalog is already invocation-surface-clean for v14; the realignment work is **additive metadata + README cross-references**, not invocation rewrites.

---

## ✅ Completion notes (2026-05-29 execution)

This plan was executed on 2026-05-29. Outcomes (verified):

- **34 use-case files** received a `**Default breadth:**` line in their header blockquote (33 `full`, 1 `incremental` — `05-reliability/p1-03-rollback-exercise.md` only). Verified by [`grep_search`](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) → 34 hits.
- **`usecase-index.json`** bumped to `version: 2.3.0`; top-level `schema` block added (closed sets for `default_breadth` and `allowed_option_classes`, plus `vision_reference`); all 34 entries carry `default_breadth`. Validated with `node -e "JSON.parse(...)"` and entry-count script.
- **Plan-text divergence (intentional).** The plan stated "No entry is added or removed" for the index, but the index originally had 33 entries while the catalog has 34 `.md` files. The missing entry — `03-consumer-correctness/p0-02-autonomous-improvement-workflow.md` — was added as **UC-34** (`order: 2`, `command_family: review`, `primary_entry_point: /pe-meta-review <path> --deps direct`, `default_breadth: full`). This is required for index/file parity and supersedes the plan's bullet on that point.
- **README.md** received: `Default breadth` column on Quick-start and `--scope` composition tables; new `💬 Free-form invocations` and `🧭 Pipeline phases and --skip mapping` subsections (both link to vision v14); `Compatible with breadth` column on `--skip` scenarios table; migration note rewritten to v14.0.0 with link to vision v14 § Migration notes; `📅 What changed (2026-05-29)` appended at bottom. The `🗺️ Compatibility map` table is byte-for-byte unchanged.
- **Re-audit.** `grep_search` across the 34 use-case files for the 12 retired flags (`--breadth`, `--area`, `--artifact`, `--consumer`, `--subject`, `--concern`, `--incremental`, `--catch-up`, `--adherence`, `--mode-review`, `--strategy`, `--group`) → **zero hits**. The README intentionally enumerates retired flags inside the v14 migration-note paragraph (not invocations).

### 🐛 Pre-existing catalog bugs discovered (NOT fixed by this plan — flagged for follow-up)

Two consistency bugs predate this realignment and are out of scope for the additive metadata work above. Both should be addressed in a follow-up cleanup:

1. **Duplicate `UC-23` title.** Both `03-consumer-correctness/p0-02-autonomous-improvement-workflow.md` and `05-reliability/p0-01-process-reproducibility.md` open with `# UC-23: …` as their H1. The index now uses **UC-34** for the autonomous-improvement file (per the addition described above) and **UC-23** for process-reproducibility. The H1 title in `p0-02-autonomous-improvement-workflow.md` SHOULD be updated to `# UC-34: Autonomous improvement workflow` to match the index.
2. **Duplicate `Order in group: 2` inside `03-consumer-correctness/`.** Both `p0-02-autonomous-improvement-workflow.md` and `p1-01-guidance-adherence-verification.md` declare `Order in group: 2 (run after UC-12)` in their header blockquotes. The index mirrors this (UC-34 and UC-11 both have `order: 2`). One of them needs a different `order` value; resolution depends on the intended run sequence within the group.

These flags do not block the v14 realignment exit criteria but warrant a small follow-up plan.

---

## 🎯 Goal

Realign the use-case catalog at [20260503.02-vision-pe-meta-usecases/](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) to vision v14 so that:

1. **Every use case declares `default_breadth`.** A new frontmatter field — `full`, `incremental`, or `bounded-delta` — that names the *resolved* breadth produced by the use case's canonical parameter-less invocation under R-P8-default-full-investigation. This closes the gap surfaced by the 2026-05-27 run where the orchestrator had no machine-readable signal that the canonical use case implied full breadth.
2. **Every invocation string uses only the v14 canonical seven-parameter surface.** `primary_entry_point`, `Alternative entry points`, and in-file example fences MUST use only `--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`. The existing catalog is already clean (zero deprecated-flag hits); this exit criterion is a *verify and re-test* task, not a rewrite.
3. **The README cross-references vision v14 instead of redefining v14 concepts.** Conversational pre-parser (Phase 0a), per-artifact prompt invocation matrix, pipeline phases and `--skip` mapping, and deprecated-flags migration are all owned by vision v14 — the catalog README links to those sections rather than duplicating them, preserving single source of truth.
4. **`usecase-index.json` records `default_breadth` per entry for tooling.** Additive schema change so the orchestrator can validate that a parameter-less invocation of a given use case is contracted to produce the breadth it actually produces (a Phase-8 contract-adherence check).

---

## 📋 Table of contents

- [📝 Revision note (2026-05-29) — supersedes prior v13.x draft](#-revision-note-2026-05-29--supersedes-prior-v13x-draft)
- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [📌 Per-file plan](#-per-file-plan)
- [🧭 README realignment to vision v14](#-readme-realignment-to-vision-v14)
- [🧾 `usecase-index.json` schema additions](#-usecase-indexjson-schema-additions)
- [🚫 Explicitly dropped from prior draft](#-explicitly-dropped-from-prior-draft)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

**Header-blockquote backfill (per use-case `.md` file):**

- Every existing use-case `.md` file under `01-freshness/` … `05-reliability/` has a `**Default breadth:**` line added to its header blockquote (the blockquote immediately under the `# UC-<n>: <title>` heading; see [📌 Per-file plan](#-per-file-plan) for the exact placement), declaring `full`, `incremental`, or `bounded-delta`. (✅ done)
- The value MUST match the breadth that the file's `primary_entry_point` resolves to under v14 resolution rule #2 (Breadth resolution): `full` for interactive with no `--start` / `--end`, `incremental` for trigger-fired with no window, `bounded-delta` whenever `--start` or `--end` is present. (✅ done)
- No file adds a `strategies:`, `slicer:`, or `breadth:` (without the `default_` prefix) field — these belong to the retired v13.x proposal. No file introduces YAML frontmatter where none currently exists. (✅ done)

**Invocation-string audit (per use-case `.md` file):**

- Verify `primary_entry_point`, `Alternative entry points`, every "Invocation examples" code fence, and every `Supported options` table uses ONLY the seven v14 canonical parameters (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`). (✅ done)
- Confirm zero occurrences of `--breadth`, `--area`, `--artifact`, `--consumer`, `--subject`, `--concern`, `--incremental`, `--catch-up`, `--adherence`, `--mode-review`, `--strategy`, `--group` across the catalog. *(Pre-verified on 2026-05-29 by repository-wide grep — currently zero hits; this exit criterion is a re-test, not a rewrite.)* (✅ done)
- Fix any newly introduced deprecated-flag usage by replacing per the vision v14 § Migration notes (v13 → v14) appendix. (✅ done)

**`usecase-index.json` schema and content updates:**

- Schema extended: each entry gains `"default_breadth": "full" | "incremental" | "bounded-delta"`. (✅ done)
- Schema extended: top-level `"schema"` block names the closed value set for `default_breadth` and for `allowed_option_classes` (closed set: `mode`, `scope`, `source`, `dim`, `start_end`, `deps`, `skip`). (✅ done)
- Every existing entry's `allowed_option_classes` array is audited against the v14 closed set; any non-canonical class (e.g., `strategy`, `breadth`, `consumer`, `area`, `subject`, `concern`, `incremental`, `adherence`) is removed. (✅ done)
- Index `version` field incremented: `2.2.0` → `2.3.0`. (✅ done)
- `generated_at` updated to the realignment date. (✅ done)
- No entry is added or removed. The schema additions are purely additive. (✅ done)

**README cross-references to vision v14:**

- README adds a "Default breadth" column to the Quick-start table (single new column; no "Strategy" column). (✅ done)
- README adds a "Default breadth" column to the `--scope` composition table. (✅ done)
- README adds a new "💬 Free-form invocations" subsection that links to vision v14 § Conversational pre-parser (Phase 0a) and shows two or three resolved-invocation examples (free-form input → canonical form). No definitions duplicated. (✅ done)
- README adds a new "🧭 Pipeline phases and `--skip` mapping" subsection that links to vision v14 § Pipeline phases and `--skip` mapping. The existing "⏭️ `--skip` stage scenarios" subsection is kept (it is use-case-oriented) but a one-line note at the top points to the vision for the authoritative phase list. (✅ done)
- README updates the "Migration note (vision v13.x)" admonition: change "v13.x" → "v14.0.0", retire the `--group` and `robustness` paragraph as already-applied, and link to vision v14 § Migration notes (v13 → v14) for the full deprecated-flags table. (✅ done)
- README "⏭️ `--skip` stage scenarios" table gains a "Compatible with breadth" column documenting that `--skip research` is INCOMPATIBLE with `breadth=full` (per v14 `--skip` semantics rule #2). (✅ done)
- A "📅 What changed (2026-05-29)" subsection is appended to the bottom of README referencing this plan and vision v14. (✅ done)
- README's "🗺️ Compatibility map (old -> new)" remains byte-for-byte unchanged. (✅ done)

**Cross-file consistency:**

- For each use-case file: `default_breadth` value in the header blockquote MATCHES the corresponding entry in `usecase-index.json`. (✅ done)
- For each use-case file: the breadth implied by the `primary_entry_point` string (per v14 rule #2) MATCHES the `Default breadth` declaration. (✅ done)

---

## 📌 Per-file plan

> **Field naming.** Every backfill below uses `default_breadth` (the v14 field name) — NOT `breadth` (the retired v13.x name from the prior plan draft). The `default_` prefix signals "the resolved breadth produced by the canonical parameter-less invocation of this use case under R-P8-default-full-investigation", distinguishing it from a v13.x-style `--breadth` input flag (which v14 retired).
>
> **Field placement.** The existing use-case files do NOT carry YAML frontmatter; they use a header blockquote immediately under the `# UC-<n>: <title>` heading containing `**Group:** … **Priority:** … **Order in group:** …`. The realignment adds `default_breadth` as a **fourth line of that same blockquote**, preserving the file's existing structure. Example below for `p0-01-context-quality-lifecycle.md`:
>
> ```markdown
> # UC-22: Context quality lifecycle
>
> > **Group:** A - Source-grounded freshness and lifecycle  
> > **Priority:** P0  
> > **Order in group:** 1 (run first in Group A)  
> > **Default breadth:** full
> ```
>
> This avoids introducing YAML frontmatter to files that currently have none. (`usecase-index.json` carries the same value separately for tooling — see [🧾 `usecase-index.json` schema additions](#-usecase-indexjson-schema-additions).)

### `README.md` (Action — extend, see [🧭 README realignment to vision v14](#-readme-realignment-to-vision-v14)) (✅ done)

### `usecase-index.json` (Action — extend schema, see [🧾 `usecase-index.json` schema additions](#-usecase-indexjson-schema-additions)) (✅ done)

### `01-freshness/p0-01-context-quality-lifecycle.md` (Analysis — backfill metadata) (✅ done)

- Add `default_breadth: full`. *(Canonical invocation `/pe-meta-context-review <path> --dim context-full` has no `--start`/`--end` and is interactive — resolves to `full` per v14 rule #2.)*

### `01-freshness/p0-02-release-impact-assessment.md` (Analysis — backfill metadata) (✅ done)

- Add `default_breadth: full`. *(Canonical `/pe-meta-release-diff <url>` — `--source <url>` narrows the source but not breadth; interactive with no window → `full`.)*

### `01-freshness/p1-01-staleness-source-verification.md` (Analysis — backfill metadata) (✅ done)

- Add `default_breadth: full`. *(Canonical `/pe-meta-update --mode plan --skip research --dim freshness` is interactive with no `--start`/`--end` → resolves to `full` per v14 rule #2. The use case's secondary trigger via `/pe-meta-scheduled-review` resolves to `incremental` when run on the configured cadence; that secondary invocation is documented in the file's Behavior section but is NOT the value declared in the header blockquote, since the header value MUST match the file's declared `primary_entry_point`.)*

### `01-freshness/p1-02-context-optimization.md` (Analysis — backfill metadata) (✅ done)

- Add `default_breadth: full`. *(Canonical `/pe-meta-context-review <path> --dim context-optimization` — interactive with no window → `full`.)*

### `02-quality-gates/*.md` (Analysis — backfill metadata, 7 files) (✅ done)

All seven files use interactive canonical entry points with no `--start`/`--end`:

- `p0-01-guidance-quality-assessment.md`: `default_breadth: full`.
- `p1-01-consistency-check.md`: `default_breadth: full`.
- `p1-02-redundancy-check.md`: `default_breadth: full`.
- `p1-03-coverage-gaps.md`: `default_breadth: full`.
- `p1-04-prioritization-review.md`: `default_breadth: full`.
- `p2-01-artifact-structure-review.md`: `default_breadth: full`.
- `p2-02-vision-alignment-check.md`: `default_breadth: full`.

### `03-consumer-correctness/*.md` (Analysis — backfill metadata, 4 files) (✅ done)

- `p0-01-dependency-aware-full-review.md`: `default_breadth: full`. *(Primary `/pe-meta-review <path> --deps full` — interactive, no window → `full`.)*
- `p0-02-autonomous-improvement-workflow.md`: `default_breadth: full`. *(Primary `/pe-meta-review <path> --deps direct` — interactive, no window → `full`.)*
- `p1-01-guidance-adherence-verification.md`: `default_breadth: full`.
- `p1-02-model-specific-guidance-adherence.md`: `default_breadth: full`.

### `04-efficiency/*.md` (Analysis — backfill metadata, 8 files) (✅ done)

All eight files: `default_breadth: full`. *(Every canonical entry point uses `--mode apply --dim optimize` with no window — interactive → `full`. The `--skip research,structure,consistency` narrowing is a phase skip, not a breadth narrowing.)*

### `05-reliability/*.md` (Analysis — backfill metadata, 11 files) (✅ done)

- `p0-01-process-reproducibility.md`: `default_breadth: full`.
- `p0-02-regression-protection.md`: `default_breadth: full`.
- `p0-03-metadata-guard-enforcement.md`: `default_breadth: full`.
- `p1-01-loop-stability-audit.md`: `default_breadth: full`.
- `p1-02-multipass-validation-invariant.md`: `default_breadth: full`.
- `p1-03-rollback-exercise.md`: `default_breadth: incremental`. *(Canonical `/pe-meta-scheduled-review --dim reliability` — trigger-fired by the rotation cadence with no window → `incremental`.)*
- `p1-04-boundary-actionability-redteam.md`: `default_breadth: full`.
- `p2-01-autonomy-calibration-audit.md`: `default_breadth: full`.
- `p2-02-conflict-resolution-coverage.md`: `default_breadth: full`.
- `p2-03-portability-boundary-scan.md`: `default_breadth: full`.
- `p2-04-mode-vs-risk-decoupling-check.md`: `default_breadth: full`.

---

## 🧭 README realignment to vision v14

This section enumerates the exact README edits. All edits preserve the existing structure; the only structural change is two new subsections appended after the existing dimension-group / scope-composition material and before the compatibility map.

### Quick-start table — add "Default breadth" column (✅ done)

Insert a new column **between** "Then" and the existing row content; resolved breadth per row:

| Trigger | Start here | Then | Default breadth |
|---|---|---|---|
| Platform/model/ecosystem update | `01-freshness` | `02-quality-gates`, `03-consumer-correctness`, `04-efficiency` | `full` |
| Generated output quality regression | `03-consumer-correctness` | `01-freshness`, `02-quality-gates` | `full` |
| Process reliability concern (oscillation, rollback, calibration) | `05-reliability` | `02-quality-gates`, `03-consumer-correctness` | `full` |
| Scheduled review pass | `01-freshness` (P0) | `02-quality-gates` (P0), `05-reliability` (P0), `04-efficiency` (P1) | `incremental` |
| Localized artifact incident | Relevant folder by symptom | Re-enter full sequence if incident recurs | `full` |

### `--scope` composition table — add "Default breadth" column (✅ done)

Every existing row resolves to `full` under v14 (no `--start`/`--end` present, interactive caller). Add the column; populate every row with `full`. A short prose paragraph above the table reminds readers that breadth is *derived* under v14 — adding `--start <date>` to any row would shift it to `bounded-delta`.

### NEW subsection: "💬 Free-form invocations" (✅ done)

Insert immediately after the existing "🎯 `--scope` composition scenarios" subsection. Content:

- One-paragraph intro: free-form natural-language input is accepted as a first-class entry point and is resolved to the canonical seven-parameter form by vision v14 § Conversational pre-parser (Phase 0a) **before** any phase runs.
- Two or three worked examples in a small table: `"re-check anything touched by VS Code 1.107"` → `--source <vscode-1.107-url> --scope all --dim full`; `"audit the article-writing context for staleness"` → `--scope .copilot/context/01.00-article-writing/ --dim freshness`; `"adherence pass on the meta agents"` → `--scope .github/agents/00.09-pe-meta/ --dim adherence --deps full`.
- Link out to vision v14 § Conversational pre-parser for the authoritative definition; do not redefine the resolution rules in the README.

### NEW subsection: "🧭 Pipeline phases and `--skip` mapping" (✅ done)

Insert immediately after the existing "⏭️ `--skip` stage scenarios" subsection. Content:

- One sentence: "For the authoritative phase list and the `--skip` value that retires each phase, see vision v14 § Pipeline phases and `--skip` mapping."
- A one-line callout that `--skip research` is INCOMPATIBLE with `breadth=full` per v14 `--skip` semantics rule #2 — and that the orchestrator will reject this combination with a deterministic error.

### "⏭️ `--skip` stage scenarios" table — add "Compatible with breadth" column (✅ done)

Add a final column documenting which resolved breadths each row is safe with. `--skip research`, `--skip research,structure`, and any row that omits research is `incremental` / `bounded-delta` only (NOT `full`). Other rows are `any`.

### Migration note admonition — update to v14 (✅ done)

Replace the existing "**Migration note (vision v13.x):**" admonition with a "**Migration note (vision v14.0.0):**" admonition that:

- Confirms `--dim robustness`, `--group`, and other v12/v13 names are already retired and rejected.
- Links to vision v14 § Migration notes (v13 → v14) for the complete deprecated-flags table (10 retired flags including `--breadth`, `--area`, `--artifact`, `--consumer`, `--subject`, `--concern`, `--incremental`, `--catch-up`, `--adherence`, `--mode-review`).
- Does NOT replicate the deprecated-flags table in the README — single source of truth in the vision.

### Append "📅 What changed (2026-05-29)" subsection (✅ done)

At the very bottom of README, after the compatibility map. Three bullets:

- `default_breadth` frontmatter added to every use-case file; surfaced in Quick-start and `--scope` composition tables.
- README now cross-references vision v14 for: conversational pre-parser (Phase 0a), pipeline-phases / `--skip` mapping, and the deprecated-flags migration table.
- No use-case files added or removed; this revision is purely additive metadata + README link-outs.

---

## 🧾 `usecase-index.json` schema additions

### Per-entry field (✅ done)

Add to every entry, immediately after `allowed_option_classes`:

```json
"default_breadth": "full"
```

with values from the closed set `{ "full", "incremental", "bounded-delta" }`. The value MUST match the corresponding markdown file's `default_breadth` frontmatter. Per-entry assignments follow [📌 Per-file plan](#-per-file-plan).

### Top-level schema block (✅ done)

Add immediately after the top-level `version` / `generated_at` fields:

```json
"schema": {
  "default_breadth": ["full", "incremental", "bounded-delta"],
  "allowed_option_classes": ["mode", "scope", "source", "dim", "start_end", "deps", "skip"],
  "vision_reference": "06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md"
}
```

The `allowed_option_classes` enumeration in this block is the v14 canonical closed set. Per-entry `allowed_option_classes` arrays MUST be a subset of this enumeration; entries containing tokens outside this set (none expected per the 2026-05-29 audit) MUST be cleaned up.

### Version + timestamp bump (✅ done)

- `"version": "2.2.0"` → `"version": "2.3.0"`.
- `"generated_at"` updated to the realignment date.

### Validator hook (🟡 next steps — out of scope for this plan; recorded for the follow-up implementation plan)

A lightweight tool SHOULD assert two invariants whenever the catalog is regenerated:

1. Every per-entry `default_breadth` value matches the corresponding `.md` file's header-blockquote `**Default breadth:**` line.
2. Every per-entry `primary_entry_point` resolves (under v14 rule #2) to the declared `default_breadth`.

These checks are the contract-adherence proxy for Phase 8's first-line `Resolved invocation: …` log.

---

## 🚫 Explicitly dropped from prior draft

The following items appeared in the v13.x-era draft of this same plan and are **deliberately not carried forward** because vision v14 obsoletes them:

| Dropped item | Why dropped | What replaces it (v14) |
|---|---|---|
| New `06-strategies/` folder with 7 strategy use cases (one per slicer) | Strategies are not a v14 axis; creating a strategy folder would re-introduce the surface v14 deliberately collapsed | Conversational pre-parser (Phase 0a) handles natural-language slicing; value-shape `--scope` handles structural slicing |
| `strategies:` frontmatter field per use case | Same — strategies are not a v14 axis. *(Note: the existing files have no YAML frontmatter; the prior draft proposed introducing it for this field. v14 carries the natural-language hint in the README instead.)* | (No replacement field; the natural-language hint is documented in the README's new "💬 Free-form invocations" subsection) |
| `breadth:` frontmatter field with values `full | incremental | catch-up` | `catch-up` is a retired v13 value; field name `breadth` (without `default_` prefix) is ambiguous with a v13-style input flag; the prior draft also proposed introducing YAML frontmatter to files that have none | `**Default breadth:**` line in the existing header blockquote with values `full | incremental | bounded-delta` |
| "Strategy" column in README Quick-start and `--scope` composition tables | Strategies are not a v14 axis | Single new "Default breadth" column |
| README "🧭 Investigation strategies" section mirroring a vision catalog | The vision v14 has no "Investigation strategies" catalog to mirror | README "💬 Free-form invocations" subsection linking to vision v14 § Conversational pre-parser |
| `--strategy artifact` (and similar `--strategy <slicer>` flag references) in Quick-start "Localized artifact incident" row | No `--strategy` flag exists in v14 | The v14 canonical form is `--scope <file-path>` (value-shape parser absorbs single-file scoping) |
| `usecase-index.json` per-entry `strategies` array | Strategies are not a v14 axis | (Only `default_breadth` is added; no strategies array) |

---

## ⚠️ Boundaries and risks

- **No use-case file is removed.** Backfilling metadata is additive; existing readers continue to work. (� todo)
- **No "Old → new" compatibility map disturbed.** The README's existing "🗺️ Compatibility map (old -> new)" table MUST remain byte-for-byte unchanged. (✅ done)
- **Schema change in `usecase-index.json` is additive.** Tools that ignore unknown fields keep working; tools that consume `default_breadth` gate on presence. (✅ done)
- **No new folder is created.** The retired v13.x draft proposed `06-strategies/`; this plan explicitly does NOT create it (see [🚫 Explicitly dropped from prior draft](#-explicitly-dropped-from-prior-draft)). The `06-` prefix remains unclaimed in the catalog for any future v14-aligned axis. (✅ done)
- **No definitions duplicated.** Conversational pre-parser, pipeline phases / `--skip` mapping, and the deprecated-flags table are owned by vision v14. The catalog README links out; never restates. (✅ done)
- **`default_breadth` is informational, not parsed input.** It declares what the canonical parameter-less invocation resolves to under R-P8-default-full-investigation. It is NEVER passed as a flag (v14 has no `--breadth` flag); the orchestrator may use it for contract-adherence checks against the Phase 8 first-line `Resolved invocation: …` log. (✅ done)
- **Risk: drift between markdown frontmatter and index JSON.** Two declarations of the same value invite divergence. Mitigated by the validator hook recorded in [🧾 `usecase-index.json` schema additions](#-usecase-indexjson-schema-additions) (📌 next steps — out of scope for this plan); pending that hook, the manual cross-file consistency exit criterion ([📋 Exit criteria](#-exit-criteria)) is the only guard. (✅ done)
- **Risk: `default_breadth` set wrong for files with both interactive and scheduled triggers** (e.g., `staleness-source-verification`, `rollback-exercise`). Mitigation: declare the value that matches the file's declared `primary_entry_point` string under v14 rule #2 — NOT the use case's narrative "primary trigger". Document the secondary trigger and its different breadth in the file's Behavior section as informational prose only. The orchestrator's contract-adherence check applies to the `primary_entry_point` declaration only. (✅ done)
- **Risk: catalog regression on v14 surface.** The 2026-05-29 audit shows zero deprecated-flag usage in the catalog. To prevent regression, the invocation-string audit exit criterion ([📋 Exit criteria](#-exit-criteria)) MUST be re-run any time a new use case is added or an existing canonical entry point is rewritten. (✅ done)

---

## 📚 References

- 📒 [Parent issue: overview.md](overview.md)
- 📒 [Vision update plan (v14)](01-vision-update-plan.md) — ✅ done; the canonical seven-parameter surface, per-artifact prompt invocation matrix, pipeline phases / `--skip` mapping, and deprecated-flags migration table all live here
- 📒 [PE-meta update plan](02-pe-meta-update-plan.md) — companion plan (pending v14 realignment of its own)
- 📘 [Use-case catalog README](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md)
- 📘 [usecase-index.json](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json)
- 📘 [vision.v14.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) — current vision; source-of-truth for all canonical-surface and Phase 0a definitions referenced from this plan
- 📕 [vision.v13.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260523.01-vision.v13.md) — historical; retained for the migration-window deprecation table
