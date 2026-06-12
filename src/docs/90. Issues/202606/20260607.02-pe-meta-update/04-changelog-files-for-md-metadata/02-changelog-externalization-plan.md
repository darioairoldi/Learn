---
status: done
domain: prompt-engineering
created: 2026-06-12
goal: "Externalize the embedded `changes:` per-version history out of every in-scope artifact's bottom metadata block into a sibling `<stem>.changelog.md` file, and replace it with a `changelog:` pointer — so history lives in the single source of truth mandated by changelog-files.instructions.md, with no parallel history left in metadata."
---

# Plan — Changelog externalization (changelog-externalization-20260612)

## 🎯 Goal

**Verbatim trigger:** *"`.github\agents\00.09-pe-meta\pe-meta-builder.agent.md` has changes on the bottom metadata folder => why were them not migrated to external changelog file? Please make sure that all articles within Learnhub has a proper change log History into external change file as per rules."*

### Why this change

The metadata-relocation effort ([01-pe-artifacts-changelog-fix-plan.md](01-pe-artifacts-changelog-fix-plan.md)) deliberately left the `changes:` history arrays in place — its **Decision D5** scoped history externalization out *"beyond adding the `changelog:` pointer"*, and its park lot recorded *"Externalize PE `changes:` history to sibling `*.changelog.md` across the 91 artifacts → spawn a sibling plan."* The article-layer analysis ([overview.md](overview.md)) reached the same decision: *"Rollout: going-forward for new/edited articles; no bulk retrofit … tracked as follow-up."* **This plan is that spawned sibling — the bulk retrofit.**

The rules already exist; only the data migration is outstanding:
- [changelog-files.instructions.md](../../../../../../.github/instructions/changelog-files.instructions.md): a `*.changelog.md` is the single source of truth for one document's per-version history; the tracked document **MUST NOT** embed a parallel history.
- [02-dual-yaml-metadata.md](../../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md): defines the optional `changelog:` pointer + `<stem>.changelog.md` sibling convention.

### Scope (per user decision, 2026-06-12)

**In scope:** PE artifacts (agents, prompts, context, templates) + **active** LearnHub articles. **Excluded:** files under any `old/` archive directory (superseded copies). The self-updating PE vision ([20260531.01-vision.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.changelog.md)) already has its changelog and is **not** re-processed.

### Surveyed inventory (active, non-`old/`, real bottom-block history)

| Area | Survey estimate | **Actual (discovered + migrated)** |
|---|---|---|
| PE templates | ~57 | **57** |
| PE agents | ~14 | **14** |
| PE prompts | ~17 | **14** |
| PE context | ~3 | **3** |
| **PE subtotal** | **~91** | **88** |
| Articles — tech | 4 | **4** |
| Articles — idea (active, non-`old/`) | 6 | **6** |
| **Article subtotal** | **~10** | **10** |
| **Total** | **~101** | **98** |

> The exact file set was produced deterministically by the discovery step (Item 1). Actual migrated total = **98** (prompt count was 14, not the ~17 estimated — the higher survey figure had counted body example blocks). No file used the `version_history:`/`change_summary:` shape — all embedded history was a `changes:` string array, so a single conversion mapping covered every artifact type.

### Goal table

| # | Item | Downstream landing | Status |
|---|---|---|---|
| 1 | **Discover** the exact in-scope file set: every active (non-`old/`) `.md` whose **bottom** metadata block contains a `changes:` array. Exclude example blocks that live in template/prompt bodies (only the last HTML-comment block counts). Emit `externalization-inventory.json`. | .copilot/temp/externalize-changelog.ps1 (discovery mode) | (✅ done) |
| 2 | **Define + implement the conversion mapping**: parse each `changes:` entry (`"vX.Y[.Z] (YYYY-MM-DD): text"` or `"vX.Y: text"`), normalize the version to full SemVer (`v1.2` → `v1.2.0`), resolve the date (per-entry date if present; else the file's `last_updated` for the newest entry and a documented fallback for older undated entries — see D4), and render a `## vX.Y.Z — YYYY-MM-DD` entry. | externalize-changelog.ps1 (convert mode) | (✅ done) |
| 3 | **Create the sibling `<stem>.changelog.md`** for each in-scope file: top frontmatter only (`title`, `description`, `last_updated`, `status: "living"`), entries most-recent-first, NO bottom metadata block (per changelog-files rules). UTF-8 no-BOM. | <stem>.changelog.md beside each source | (✅ done) |
| 4 | **Strip the embedded `changes:` array** from each source's bottom metadata block and **add a `changelog:` pointer** (`changelog: "<stem>.changelog.md"`) in its place, preserving `version`/`last_updated`/`created`/other fields. | each in-scope source file | (✅ done) |
| 5 | **Set the OS hidden attribute** (best-effort) on every new `*.changelog.md`, consistent with the vision changelog. | new changelog files | (✅ done) |
| 6 | **Verify**: zero in-scope sources retain a bottom-block `changes:` array; every source has a `changelog:` pointer resolving to an existing sibling; every changelog parses (frontmatter present, no bottom block, headings full-SemVer + date, newest-first); `get_errors` clean on a representative sample of each type. Emit `externalization-report.json`. | report + sampled get_errors | (✅ done) |

## 📋 Current-state findings

- **F1 — History deferred, not done.** D5 + park lot of [01-pe-artifacts-changelog-fix-plan.md](01-pe-artifacts-changelog-fix-plan.md) and the rollout decision in [overview.md](overview.md) both explicitly deferred the bulk retrofit. The pointer (`changelog:`) was added to the *rules* but not populated on the *data*. (This is the direct answer to "why was pe-meta-builder not migrated?")
- **F2 — Uniform source shape.** Every in-scope file stores history as a `changes:` string array; none uses `version_history:`. One parser covers all types.
- **F3 — Two heading-shape inputs.** PE artifacts use full SemVer + date (`v1.1.0 (2026-06-12): …`); articles use two-part, undated versions (`v1.2: …`). Conversion MUST normalize both to the mandated `## vX.Y.Z — YYYY-MM-DD` form.
- **F4 — Example blocks are false positives.** A few templates/prompts contain example metadata in their *body* (e.g. `pe-meta-research-digest.template.md`); only the file's final HTML-comment block is the real metadata and is the sole conversion target.
- **F5 — Rules already landed.** `changelog-files.instructions.md` (v1.0.0), the `changelog:` schema field, and the article-rule carve-outs are already in place — no rule authoring is needed, only data migration.

## 🧭 Decisions

| ID | Decision | Choice | Rationale |
|---|---|---|---|
| D1 | Trigger source shape | Only the **final** HTML-comment metadata block per file | Body example blocks are not real metadata (F4) |
| D2 | Changelog file shape | Top frontmatter only (`title`, `description`, `last_updated`, `status: "living"`); no bottom block | changelog-files.instructions.md § Frontmatter / Exemption |
| D3 | Pointer field | `changelog: "<stem>.changelog.md"` added to the source's bottom block where `changes:` was removed | Explicit pointer beats relying on the convention fallback |
| D4 | Undated article entries | Newest entry → file `last_updated`; older undated entries → keep version heading with date `unknown` rendered as the file `created` date when present, else omit the date and add `— (date not recorded)` note | Full-SemVer + date is mandated; never fabricate a precise date — flag unknowns honestly |
| D5 | Version normalization | `vX` → `vX.0.0`, `vX.Y` → `vX.Y.0`, `vX.Y.Z` unchanged | Mandated full-SemVer headings |
| D6 | `old/` archives | Excluded | User decision 2026-06-12 |
| D7 | Vision changelog | Not re-processed (already externalized) | Done by the 03-changelog-files effort |
| D8 | Rollback | Git history + a `rollback/` snapshot of every touched source before edit | Consistent with the prior relocation effort's safety net |
| D9 | Encoding | UTF-8 no-BOM for all writes | Repo convention; preserves emoji |

## 📋 Things to do (ordered)

1. Write `.copilot/temp/externalize-changelog.ps1` with discovery + convert + apply modes; snapshot sources to `.copilot/temp/rollback-changelog/` first — item 1, D8. (✅ done)
2. Run discovery; review `externalization-inventory.json` against the survey estimate (~101) and confirm no `old/` or body-example files slipped in — items 1, 4 (F4). (✅ done — 98 discovered; `old/` and body-example blocks correctly excluded)
3. Generate sibling changelog files (convert + create) — items 2, 3, D2/D4/D5. (✅ done — 98 changelogs created)
4. Strip `changes:` + insert `changelog:` pointer in sources — item 4, D3. (✅ done — 0 residual `changes:` arrays)
5. Set hidden attribute best-effort — item 5. (✅ done)
6. Verify + emit report + sampled `get_errors` — item 6. (✅ done — `externalization-report.json` written; samples clean)
7. Update [overview.md](overview.md) follow-up note and [01-pe-artifacts-changelog-fix-plan.md](01-pe-artifacts-changelog-fix-plan.md) park-lot entry to `→ closed: done by 02-changelog-externalization-plan.md`; set this plan `status: done`. (✅ done)

## ⚠️ Execution notes

- **Rollback snapshot bug (non-blocking).** The `-Apply` run's `rollback-changelog/` snapshot collapsed to a single 0-byte file: the script's relative-path key kept the `C:` drive prefix, so the snapshot filename resolved to a drive-qualified path. The snapshots are therefore **not** a usable rollback source. This was harmless because the migration edits and new files are **uncommitted git changes** — `git restore` / `git clean` is the actual safety net (D8's git arm). No source content was lost (verified: 0 residual `changes:` arrays, all pointers resolve, sampled `get_errors` clean).
- **One faithful-but-unversioned changelog.** `pe-sim-prompt-create-update.prompt.changelog.md` rendered every entry as `## (unversioned)` because its source `changes:` array never carried version prefixes (plain descriptions). Per D4 (never fabricate), this is the honest representation, not a defect.
- **Vision changelog hygiene fix.** `20260531.01-vision.changelog.md` (created in a prior session, not re-processed here per D7) carried a forbidden bottom `article_metadata` block; it was removed to comply with changelog-files rules.

## 🅿️ Park lot

- **Superseded `.vN`-named visions not under `old/`** (e.g. `20260428.01-vision.v1.md`, `01.000-vision.v1.md`) — treat as archives like `old/`? → `closed: included as active` (migrated with the active set; re-confirm with user if they should instead be archived).
- **MetadataWatcher / git-hook async changelog writes** (replace the review-driven trigger with on-any-change) → `defer` (the .NET source is not in this checkout).
- **Going-forward enforcement** that new `changes:` arrays are rejected by a validator → `defer` (rules already say "MUST NOT embed"; a mechanical guard is a separate effort).

## ✅ Exit criteria

- No in-scope active source retains a bottom-block `changes:` array.
- Every in-scope source carries a `changelog:` pointer that resolves to an existing sibling `<stem>.changelog.md`.
- Every new changelog file: top frontmatter only (no bottom block), entries most-recent-first, full-SemVer + date headings, no fabricated dates (unknowns flagged per D4).
- `get_errors` clean on a representative sample of each type (agent, prompt, context, template, article).
- `externalization-report.json` written; overview + sibling-plan park-lot updated; this plan `status: done`.

## 📚 Related

- Sibling relocation plan (deferred this): [01-pe-artifacts-changelog-fix-plan.md](01-pe-artifacts-changelog-fix-plan.md)
- Article-layer analysis: [overview.md](overview.md)
- Changelog-file rules: [changelog-files.instructions.md](../../../../../../.github/instructions/changelog-files.instructions.md)
- Dual-metadata schema (`changelog:` field): [02-dual-yaml-metadata.md](../../../../../../.copilot/context/90.00-learning-hub/02-dual-yaml-metadata.md)
