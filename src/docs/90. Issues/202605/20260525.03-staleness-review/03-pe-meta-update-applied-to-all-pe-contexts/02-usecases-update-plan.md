---
title: "Plan: pe-meta use cases — add domain-coherent batching, split-proposal flow, and per-domain examples"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, usecases, pe-meta]
description: "Plan for amending the use-case catalog at [20260503.02-vision-pe-meta-usecases/](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) to add a new P0 reliability use case (`p0-04-domain-coherent-batching.md`), update the catalog README quick-start table with a new heterogeneous-scope row, extend `usecase-index.json` with the new entry and a new `bundle_disposition` field, and update every existing use case that uses a broad `--scope <token>` to reference the split-proposal flow. Also introduces the **seed-footprint vs dependency-footprint distinction**: the new use case documents a `bundle=cross-domain-deps` branch where a single-seed positional invocation with `--deps full` produces a cross-domain dependency closure — ONE review runs against the union with per-dependency-domain specialized analysis lenses (e.g. Microsoft Writing Style Guide for `article-writing` deps, PE rationales for `prompt-engineering` deps), with NO split proposal because a consumer artifact needs ALL its declared dependencies to be reviewed correctly. Mirrors the vision v15 amendments in [01-vision-update-plan.md](01-vision-update-plan.md)."
draft: false
status: "done"
last_updated: "2026-05-31"
severity: "High"
component: "[20260503.02-vision-pe-meta-usecases/](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/)"
framework: "GitHub Copilot Customization v1.107 (vision v14 → v15)"
---

# Plan — pe-meta use cases — add domain-coherent batching, split-proposal flow, and per-domain examples

**Parent issue:** [overview.md](overview.md) (this sub-issue's analysis)
**Plan ID:** `02-usecases-update-plan`
**Date:** 2026-05-29
**Status:** Done
**Depends on:** [01-vision-update-plan.md](01-vision-update-plan.md) (vision v15 must define R-P10 and Phase 0b first)

---

## 🎯 Goal

Update the [pe-meta use-case catalog](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/) so that:

1. **A new P0 reliability use case (`p0-04-domain-coherent-batching.md`)** captures the heterogeneous-scope split-proposal flow as a first-class operational pattern, including positional-path invocations from per-artifact prompts and the artifact-type/path consistency check.
2. **The catalog README quick-start table** gains two new rows: (a) "Heterogeneous scope detected" for the bundle gate; (b) "Per-artifact prompt invoked with positional path" for the silent single-domain pass; and (c) "Artifact-type/path mismatch" for the CF-05 rejection scenario.
3. **The README's `## 🔗 Complete use-case list` section** lists the new file under `05-reliability/`.
4. **`usecase-index.json`** is extended with the new entry AND a new `bundle_disposition` field on every existing entry whose `primary_entry_point` can resolve cross-domain (`{single-domain | accepted-bundle | split-N | cross-domain-deps | not-applicable}`), AND a `scope_mechanism` field on every entry recording which invocation shape the entry's primary example uses (`{token | path-set | positional | default-all}`).
5. **Existing use cases that show broad `--scope <token>` invocations** are updated to either (a) demonstrate the per-domain split proposal in their example block, or (b) add a one-line note explaining the Phase 0b gate.
6. **The README's "Migration note" paragraph** is extended with a v15 entry explaining the bundle gate, the Phase 0a artifact-type/path consistency check, and pointing at vision v15 § Domain-coherent batching AND § Domain detection.
7. **The new use case explicitly covers all five invocation shapes** (artifact-type token, path-set single, path-set multi, positional `<file-path>`, no-scope default-all) so authors of per-artifact prompts and orchestrators alike find the gate documented for their invocation pattern.
8. **The new use case introduces the seed-vs-deps decision matrix** and the `bundle=cross-domain-deps` branch: when a single-seed positional invocation with `--deps full` produces a cross-domain dependency closure (e.g. reviewing an article-writing prompt whose deps include both article-writing and prompt-engineering context), the orchestrator runs ONE review against the union with per-dependency-domain specialized analysis lenses, NO split. Documented with a worked example using `/pe-meta-prompt-review` of an article-writing prompt with `--deps full` traversal.

---

## 📋 Table of contents

- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [📌 New use case — p0-04-domain-coherent-batching.md](#-new-use-case--p0-04-domain-coherent-batchingmd)
- [📌 README updates](#-readme-updates)
- [⚙️ usecase-index.json updates](#%EF%B8%8F-usecase-indexjson-updates)
- [🏗️ Existing use cases requiring edits](#%EF%B8%8F-existing-use-cases-requiring-edits)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

- New file [`05-reliability/p0-04-domain-coherent-batching.md`](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/p0-04-domain-coherent-batching-usecase.md) exists with the structure described under § New use case below. (✅ done)
- The new use case's § Phase 0b flow table covers **all five invocation shapes** (artifact-type token, path-set single, path-set multi, positional `<file-path>`, no-scope default-all) and includes (a) a dedicated row showing positional-path `--deps full` producing a multi-domain consumer set that IS subject to the gate when seed≥2, AND (b) a NEW row showing positional-path `--deps full` with a single-domain seed producing a cross-domain deps closure — the row emits `bundle=cross-domain-deps` and proceeds without prompting for a split. (✅ done)
- The new use case includes a § Specialized lens (cross-domain-deps) subsection documenting how Phase 2–4 audits apply per-dependency-domain rule lenses (MWSG for `article-writing` deps, R-P* rationales for `prompt-engineering` deps, dual-metadata for `learning-hub` deps), with a worked example using an article-writing prompt review whose `--deps full` closure spans `article-writing` and `prompt-engineering` context. (✅ done)
- The new use case includes a § Phase 0a precondition subsection showing the artifact-type/path consistency check with a worked CF-05 rejection (the user's `/pe-meta-context-review '.github/prompts/...'` example) and its canonical replacement. (✅ done)
- README § Folder map row for `05-reliability` is unchanged (priority flow `P0 -> P1 -> P2` still holds; only the P0 count changes from 3 to 4). (✅ done)
- README § Quick start table gains a new row: "Heterogeneous scope detected (≥ 2 semantic domains)" → `05-reliability` (P0-04) → `02-quality-gates`, `03-consumer-correctness` → default breadth `full`. (✅ done)
- README § Quick start table gains a new row: "Per-artifact prompt invoked with positional path" → `05-reliability` (P0-04 § Positional invocations) → silent single-domain pass; no gate. (✅ done)
- README § Quick start table gains a new row: "Artifact-type/path mismatch (CF-05 at Phase 0a)" → `05-reliability` (P0-04 § Phase 0a precondition) → rejected with canonical-replacement suggestion. (✅ done)
- README § Quick start table gains a new row: "Single-seed cross-domain dependencies (positional `--deps full` whose closure adds dep-domains)" → `05-reliability` (P0-04 § Specialized lens) → `bundle=cross-domain-deps`; ONE review with per-dep-domain specialized analysis lenses; no split. (✅ done)
- README § Complete use-case list § `05-reliability` lists the new `p0-04-domain-coherent-batching` entry (placed between `p0-03-metadata-guard-enforcement` and `p1-01-loop-stability-audit`). (✅ done)
- README § Migration note paragraph gains a v15 entry: "Use cases that resolve broad `--scope <token>` now route through Phase 0b's split-proposal gate per vision v15 § Domain-coherent batching; positional-path invocations from per-artifact prompts ALSO route through Phase 0b after passing the Phase 0a artifact-type/path consistency check per vision v15 § Domain detection." (✅ done)
- `usecase-index.json` gains the new entry for `p0-04-domain-coherent-batching` with `bundle_disposition: "single-domain"` and `scope_mechanism: "path-set"` (it scopes itself per-domain by design). (✅ done)
- `usecase-index.json` adds a `bundle_disposition` AND `scope_mechanism` field on every existing entry per the rules in § usecase-index.json updates below. (✅ done)
- Every `p0-*` use case currently using `--scope <type-token>` in its primary invocation gets a "Domain coherence" subsection (≤ 8 lines) explaining what Phase 0b will do for that use case. (✅ done)
- All catalog-internal markdown links remain resolvable after the additions. (✅ done)

---

## 📌 New use case — p0-04-domain-coherent-batching.md

**Path:** [`05-reliability/p0-04-domain-coherent-batching.md`](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/p0-04-domain-coherent-batching-usecase.md)

**Required structure (mirror the existing `p0-*-...md` files):**

1. **Frontmatter** — `title`, `priority: "P0"`, `group: "05-reliability"`, `dimensions: ["D33-rollback-readiness", "D31-loop-stability", "D5-consumer-adherence"]`, `command_family: "review|update|create|scheduled"` (i.e. all), `primary_entry_point`, `allowed_option_classes: ["mode", "scope", "source", "dim", "start", "end", "deps", "skip"]`, `default_breadth: "full"`, `bundle_disposition: "single-domain"`, `references` to vision v15 § Domain-coherent batching and the parent issue overview.
2. **§ Goal** — One paragraph: "Prevent silent heterogeneous-bundle execution; surface the domain footprint and propose canonical per-domain split commands BEFORE any mutation runs."
3. **§ Trigger conditions** — Three bullets: (a) any `/pe-meta-*` invocation whose resolved `--scope` covers ≥ 2 semantic domains; (b) inherited from `pe-meta-scheduled-review` auto-rotation when the rotation lands on a cross-domain target; (c) user-issued bundle audit (`/pe-meta-update --mode plan --scope all --dim reliability`).
4. **§ Primary invocations** — Show the three canonical per-domain commands derived from the originating incident:

   ```text
   /pe-meta-update --mode apply --scope .copilot/context/00.00-prompt-engineering/
   /pe-meta-update --mode apply --scope .copilot/context/01.00-article-writing/
   /pe-meta-update --mode apply --scope .copilot/context/90.00-learning-hub/
   ```

   Then show the bundle-accept variant for callers who genuinely want one atomic run:

   ```text
   /pe-meta-update --mode apply --scope context bundle=accept
   ```

5. **§ Phase 0b flow** — A small table covering all five invocation shapes. Phase 0b applies identically to each shape; only the FILE SET differs by shape. The domain footprint is computed by reading each in-scope file's `domain:` YAML frontmatter (Tier 1), falling back to an optional per-repo `pe-domain-map.yaml` heuristic (Tier 2), and finally to `unknown` (Tier 3) per vision v15 § Domain detection.

   | Resolved scope | Invocation shape (`scope-source=`) | Domain footprint (read from per-file `domain:` metadata) | Phase 0b output | Gate behavior in `--mode apply` |
   |---|---|---|---|---|
   | `.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md` | `path-set` (single path) | 1 (whatever the file's `domain:` declares; typically `prompt-engineering`) | `bundle=single-domain` | Proceeds; no prompt |
   | `--scope context` | `token` | Typically 3+ (each file under `.copilot/context/` is read for its `domain:` value; the count is the number of distinct declared domains) | Numbered split proposal (one entry per distinct domain) | Hard gate; awaits selection or `bundle=accept` |
   | `--scope .copilot/context/01.00-article-writing/,.copilot/context/90.00-learning-hub/` | `path-set` (multi) | Typically 2 (assuming files in each subfolder declare matching `domain:` values; the count is N distinct domains found, NOT the number of path-set entries) | Numbered split proposal (N entries) | Hard gate; awaits selection or `bundle=accept` |
   | `--scope .github/prompts/00.09-pe-meta/` | `path-set` (single) | Depends on what each pe-meta prompt declares in its `domain:` field — may be 1 (`prompt-engineering`) if homogeneous, or N if some pe-meta prompts target other domains | `bundle=single-domain` iff all declared domains match; otherwise numbered split proposal | Hard gate iff N ≥ 2 |
   | `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md'` (no `--deps`) | `positional` | 1 (whatever the file's `domain:` declares) | `bundle=single-domain` | Proceeds; no prompt (single-file positional is single-domain by construction) |
   | `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md' --deps full` | `positional` (with `--deps` traversal) | **Seed footprint = 1** (the file's own `domain:`); **deps footprint** = N distinct domains read from each file in the closure | If deps adds 0 additional domains → `bundle=single-domain`. If seed=1 AND deps adds ≥ 1 additional domain → **`bundle=cross-domain-deps`** (ONE review, per-dep-domain specialized lenses; NO split). | Proceeds; no gate/split for `bundle=cross-domain-deps` |
   | `/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full` | `positional` (with `--deps` traversal) | **Seed footprint = 1** (`article-writing`); **deps closure** typically pulls in `article-writing` context files AND `prompt-engineering` context files → deps adds `{ prompt-engineering }` | `bundle=cross-domain-deps`: ONE review against the union; Phase 2–4 apply per-dep-domain specialized analysis lenses (MWSG/Diátaxis for `article-writing` deps; R-P* rationales for `prompt-engineering` deps); Phase 8 report sections findings per dep-domain | Proceeds; no gate |
   | `/pe-meta-update --mode apply` (no scope) | `default-all` (per R-P8) | All distinct declared domains across every artifact-type root | Numbered split proposal (one entry per distinct domain) | Hard gate; awaits selection or `bundle=accept` |

   **Note 1.** Positional `<file-path>` invocations are the canonical entry point for the per-artifact prompt family (`pe-meta-context-*`, `pe-meta-prompt-*`, etc.). Phase 0b applies to them identically — only the scope-extraction step differs (the positional path IS the file; with `--deps`, it expands to the traversal set).

   **Note 2.** The footprint columns above describe TYPICAL outcomes assuming each file declares its `domain:` field correctly. When `domain:` is absent, the orchestrator falls back to Tier 2 (per-repo `pe-domain-map.yaml` heuristic, if shipped) or Tier 3 (`unknown`). The Phase 8 report calls out every file resolved at Tier 2 or Tier 3 so authors can backfill the field. `unknown` counts as a distinct domain-id for footprint and gate purposes.

   **Note 3 — seed footprint vs dependency footprint.** Phase 0b computes the domain footprint **separately for the seed scope** (files explicitly named by `--scope` or positional path, BEFORE `--deps` traversal) and **for the dependency closure** (files added by `--deps direct`/`--deps full`). Three dispositions follow from a small decision matrix: (a) seed=1 AND deps=0 → `bundle=single-domain`; (b) seed≥2 (regardless of deps) → `bundle=multi-domain-gated` and propose split per R-P10; (c) seed=1 AND deps adds ≥ 1 additional domain → `bundle=cross-domain-deps`, run ONE review against the union with per-dependency-domain specialized analysis lenses (no split). Splitting a single-seed cross-domain-deps invocation would produce **incomplete reviews** because a consumer artifact needs ALL its declared dependencies present to be evaluated correctly — see § Specialized lens (cross-domain-deps) below.

6. **§ Specialized lens (cross-domain-deps)** — Documents how Phase 2–4 audits adapt when `bundle=cross-domain-deps`. The audits run ONCE on the seed; only the rule-adherence and context-comparison sub-checks within each audit are evaluated per dependency-domain:

   | Dep-domain | Specialized lens applied when comparing seed against this dep | Findings sectioned in Phase 8 report under |
   |---|---|---|
   | `article-writing` | Microsoft Writing Style Guide voice rules, Diátaxis type validation, accessibility (alt text, inclusive language), readability targets (Flesch 50–70, sentences 15–25 words), emoji-H2 rule | "Findings vs `article-writing` context" |
   | `prompt-engineering` | PE rationale set (R-P1…R-P10), boundary-actionability redteam pattern, three-layer rule architecture, tool-restriction-as-strict-allowlist, dimension scope contract | "Findings vs `prompt-engineering` context" |
   | `learning-hub` | Dual-metadata system (top YAML / bottom HTML comment), reference-classification emoji markers (📘/📗/📒/📕), kebab-case naming | "Findings vs `learning-hub` context" |
   | other | The dep-domain's own context-file rules (look up the dep-domain's instruction files in its declared artifact-type root) | "Findings vs `<dep-domain>` context" |

   **Worked example — `/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full`:**

   1. **Phase 0a.** CF-05 passes (`pe-meta-prompt-*` ⇒ `.github/prompts/` root; supplied path matches).
   2. **Phase 0b seed extraction.** Positional single file. Read `domain:` from the prompt's frontmatter → `article-writing`. **Seed footprint = { article-writing }**.
   3. **Phase 0b deps full closure.** Walk references and file links; closure yields 6 files under `.copilot/context/01.00-article-writing/`, 4 files under `.copilot/context/00.00-prompt-engineering/`, 2 instruction files in `.github/instructions/`. Read each file's `domain:`. **Deps footprint = { article-writing, prompt-engineering }**. Additional domains beyond seed = `{ prompt-engineering }`.
   4. **Phase 0b decision.** seed=1 AND deps adds ≥ 1 → `bundle=cross-domain-deps`. NO split proposal. Log marker: `bundle=cross-domain-deps`. Phase 1 proceeds.
   5. **Phase 2–4 audits.** Run ONCE on the seed prompt. Comparison sub-checks apply per dep-domain: PE rationale checks against the PE dependencies; MWSG/Diátaxis checks against the article-writing dependencies.
   6. **Phase 8 report.** Two subsections: "Findings vs `article-writing` context" and "Findings vs `prompt-engineering` context". Each finding is labeled with the lens that produced it.

   **Why this is not a bypass of R-P10.** R-P10 governs the seed-multi-domain case (the user explicitly asked for broad scope). The cross-domain-deps branch handles a case R-P10 was never the right tool for: the user named ONE artifact, and the cross-domain deps are infrastructure that artifact requires, not separate review targets. Splitting would produce incomplete reviews, which is the opposite of R-P10's intent.

7. **§ Phase 0a precondition — artifact-type/path consistency check** — Explain that per-artifact prompts encode an expected artifact-type root in their name (e.g. `pe-meta-context-*` ⇒ `.copilot/context/`). When the positional path or `--scope` value resolves to a different root, Phase 0a REJECTS with CF-05 BEFORE Phase 0b runs.

   **Worked rejection example:**

   ```text
   /pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full
   ```

   ⇒ CF-05: supplied path is under `.github/prompts/`, but `pe-meta-context-review` expects `.copilot/context/`.

   **Canonical replacement:**

   ```text
   /pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full
   ```

   Orchestrator-level prompts (`pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`) are artifact-type-agnostic and skip this check.

8. **§ Expected outputs** — Bullets covering: per-run report with `bundle=` (one of `single-domain | multi-domain-gated | accepted-bundle | split-N | cross-domain-deps`) AND `scope-source=` markers on the first line; per-domain `outcome-log.jsonl` entries; granular rollback bundle per domain when one run regresses without affecting the others; when `bundle=cross-domain-deps`, the Phase 8 report sections findings under one subsection per distinct dep-domain.
9. **§ Dimensions exercised** — D33 (rollback readiness), D31 (loop stability), D5 (consumer adherence), D28 (process reproducibility).
10. **§ Cross-references** — Vision v15 § Domain-coherent batching, § Domain detection (artifact-type root vs. semantic domain; metadata-first 3-tier resolution algorithm; per-invocation-type scope-extraction matrix; artifact-type/path consistency check; **seed footprint vs dependency footprint — the specialized-lens branch**; `--deps full` and the metadata-first payoff; cross-repo portability), R-P10-domain-coherent-batching, [03-pe-meta-update-plan.md](03-pe-meta-update-plan.md), [overview.md](overview.md).

**Length target:** ~140 lines, in line with sibling `p0-0X` files (slightly longer to accommodate the cross-domain-deps lens worked example).

---

## 📌 README updates

### § Folder map (Action — none) (✅ done)

No table edits; only the P0 count under `05-reliability` increases from 3 to 4 implicitly via the Complete-use-case-list section.

### § Quick start (Action — extend) (✅ done)

**Insert these four new rows** between the existing "Process reliability concern" and "Scheduled review pass" rows:

| Trigger | Start here | Then | Default breadth |
|---|---|---|---|
| Heterogeneous scope detected (≥ 2 semantic domains in resolved `--scope` seed) | [05-reliability/p0-04-domain-coherent-batching](05-reliability/p0-04-domain-coherent-batching.md) | [01-freshness](01-freshness/README.md), [02-quality-gates](02-quality-gates/README.md), [03-consumer-correctness](03-consumer-correctness/README.md) (per resulting per-domain run) | `full` |
| Per-artifact prompt invoked with positional `<file-path>` | [05-reliability/p0-04-domain-coherent-batching § Positional invocations](05-reliability/p0-04-domain-coherent-batching.md) | Silent single-domain pass; no gate (unless `--deps full` produces multi-domain consumer set) | `none` (single file) |
| Artifact-type/path mismatch (e.g. `/pe-meta-context-review` invoked with `.github/prompts/...` path) | [05-reliability/p0-04-domain-coherent-batching § Phase 0a precondition](05-reliability/p0-04-domain-coherent-batching.md) | Rejected with CF-05; canonical-replacement prompt name suggested | n/a |
| Single-seed cross-domain dependencies (positional `--deps full` whose closure adds dep-domains beyond the seed's domain, e.g. reviewing an article-writing prompt whose deps include `prompt-engineering` context) | [05-reliability/p0-04-domain-coherent-batching § Specialized lens (cross-domain-deps)](05-reliability/p0-04-domain-coherent-batching.md) | `bundle=cross-domain-deps`; ONE review with per-dep-domain specialized analysis lenses; NO split. Phase 8 report sections findings per dep-domain | `full` |

### § Dimension group shortcuts (Action — extend) (✅ done)

Append one row to the dimension-group table:

| Use-case group | `--dim` value | Dimensions | Typical usage |
|---|---|---|---|
| Domain-coherent batching | (inherits `--dim reliability` group) | D28, D31, D33, D5 | Bundle-gate flow; per-domain rollback granularity; multi-domain split proposal |

### § Migration note (Action — extend) (✅ done)

Append one new paragraph after the existing v14.0.0 migration note:

> **Migration note (vision v15.0.0):** Any use case that resolves a broad `--scope <type-token>` now routes through Phase 0b's domain-coherence gate per vision v15 § Domain-coherent batching. The catalog itself does not duplicate the gate logic — see the vision and the new [`05-reliability/p0-04-domain-coherent-batching`](05-reliability/p0-04-domain-coherent-batching.md) use case for the canonical flow.

### § Machine-readable index (Action — extend) (✅ done)

Add `bundle_disposition`, `scope_mechanism`, and `domain_footprint_hint` to the "Each entry includes" list:

- `bundle_disposition` — `single-domain` \| `accepted-bundle` \| `split-N` \| `cross-domain-deps` \| `not-applicable` (entries whose primary entry point is a single-file path or a single-folder path). The `cross-domain-deps` value indicates entries whose canonical example uses a positional `--deps full` invocation expected to produce a cross-domain dependency closure (one review with per-dep-domain specialized analysis lenses).
- `scope_mechanism` — `token` \| `path-set` \| `positional` \| `default-all` — records the invocation shape used by the entry's primary example. Mirrors the vision v15 § Domain detection per-invocation-type matrix and the `scope-source=` audit-log marker.
- `domain_footprint_hint` — informational hint for tooling about the expected domain count when the entry's primary entry point resolves; closed set `{ 1, "1+", "N" }`

### § Complete use-case list § 05-reliability (Action — extend) (✅ done)

Insert one bullet between `p0-03-metadata-guard-enforcement` and `p1-01-loop-stability-audit`:

- [p0-04-domain-coherent-batching](05-reliability/p0-04-domain-coherent-batching.md)

---

## ⚙️ usecase-index.json updates

**Schema additions:**

| Field | Type | Required | Allowed values |
|---|---|---|---|
| `bundle_disposition` | string | yes (every entry) | `single-domain` \| `accepted-bundle` \| `split-N` \| `cross-domain-deps` \| `not-applicable` |
| `scope_mechanism` | string | yes (every entry) | `token` \| `path-set` \| `positional` \| `default-all` |
| `domain_footprint_hint` | string | optional | `1` \| `1+` \| `N` |

**Per-entry assignment rules:**

| Primary entry point shape | `scope_mechanism` | `bundle_disposition` | `domain_footprint_hint` |
|---|---|---|---|
| Single file path supplied positionally (per-artifact prompt invocation) | `positional` | `not-applicable` when no `--deps`; `cross-domain-deps` when the canonical example uses `--deps full` and the closure is expected to span multiple dep-domains; `accepted-bundle` only when explicitly intended | `1` (or `1+` when `--deps full` is the canonical form) |
| Single file path supplied as `--scope <path>` | `path-set` | `not-applicable` | `1` |
| Single folder path supplied as `--scope <path>` | `path-set` | `single-domain` | `1` |
| Multi-path under one top-level subfolder | `path-set` | `single-domain` | `1` |
| Multi-path crossing top-level subfolders | `path-set` | `accepted-bundle` (require explicit consent) | `N` |
| Artifact-type token (`context`, `prompts`, …) | `token` | `accepted-bundle` (default; can resolve to `split-N`) | `1+` |
| No scope (default `all` per R-P8) | `default-all` | `accepted-bundle` (default; can resolve to `split-N`) | `N` |

**Existing entries requiring `bundle_disposition` annotation** (the catalog README lists 24 use cases; this plan does not redefine them — it only adds the field):

- `01-freshness/*` — 4 entries (all currently use `--scope context`; default `accepted-bundle`, hint `1+`)
- `02-quality-gates/*` — 7 entries (mix; per-entry per the rules above)
- `03-consumer-correctness/*` — 3 entries (per-agent or per-prompt; mostly `single-domain` hint `1`)
- `04-efficiency/*` — 8 entries (mostly `accepted-bundle` hint `1+`)
- `05-reliability/*` — 9 entries (after the new addition); the new `p0-04` is `single-domain` hint `1` because its example invocations are per-domain by construction

---

## 🏗️ Existing use cases requiring edits

| Use case | Why edit needed | Required edit |
|---|---|---|
| `01-freshness/p0-01-context-quality-lifecycle.md` | Currently shows `/pe-meta-update --mode apply --scope context` — exactly the heterogeneous-bundle trigger | Add § Domain coherence subsection (≤ 8 lines) showing the 3-way split proposal under `bundle_disposition: accepted-bundle` |
| `01-freshness/p0-02-release-impact-assessment.md` | Resolves multi-source AND multi-domain (release notes touch every domain) | Add § Domain coherence subsection noting that the release-diff family inherits Phase 0b |
| `02-quality-gates/p0-01-guidance-quality-assessment.md` | Uses `--scope context` for context-tier sweep | Add § Domain coherence subsection |
| `03-consumer-correctness/p0-01-dependency-aware-full-review.md` | Default-full dependency sweep can cross domains via consumer chains | Add § Domain coherence subsection noting that consumer-chain traversal does NOT bypass Phase 0b |
| `04-efficiency/p1-01-token-budget-analysis.md` | Uses `--scope context` for token-budget audit | Add § Domain coherence subsection (advisory only — this is typically `--mode plan`, so the gate is advisory) |
| `04-efficiency/p2-04-deterministic-first-optimization.md` | Multi-domain by construction (deterministic-tooling improvements touch every domain) | Add § Domain coherence subsection |
| `05-reliability/p0-01-process-reproducibility.md` | Reproducibility audit MUST exercise the gate to verify the gate itself | Add explicit § Cross-link to new `p0-04` |
| `05-reliability/p0-02-regression-protection.md` | Regression protection depends on per-domain rollback granularity | Add § Domain coherence subsection |
| `05-reliability/p0-03-metadata-guard-enforcement.md` | Metadata guards run cross-domain on broad sweeps | Add § Domain coherence subsection |

**Per-use-case edit template** (~8 lines each):

> ### Domain coherence (vision v15 § Domain-coherent batching)
>
> When this use case is invoked with a broad `--scope <type-token>` (e.g. `--scope context`), Phase 0b detects the multi-domain footprint and proposes a per-domain split BEFORE Phase 1 runs. In `--mode apply`, the split proposal is a hard gate. To accept the bundle explicitly, append `bundle=accept`. To run per-domain, copy a single line from the proposal into a fresh invocation.
>
> Default disposition for this use case: `{single-domain | accepted-bundle | split-N | not-applicable}`.

---

## ⚠️ Boundaries and risks

| Concern | Mitigation |
|---|---|
| Adding `bundle_disposition` to 24 existing entries is a lot of touch | Each touch is mechanical (one field add per entry), no semantic change; can be applied in a single deterministic editing pass |
| New `p0-04` use case overlaps with `p0-01-process-reproducibility` (both about reliability invariants) | They are complementary — `p0-01` covers process reproducibility across runs; `p0-04` covers the specific reliability invariant that multi-domain bundles MUST be gated. Cross-link both ways |
| Quick-start table is getting long | Three new rows added (heterogeneous-scope, positional, CF-05). Total rows: 5 → 8. Still scannable on a single screen |
| Per-use-case "Domain coherence" subsection adds noise to use cases that are not multi-domain | The subsection is added ONLY to use cases whose primary entry point can resolve cross-domain (≤ 9 of 24 entries). The other 15 keep their current shape |
| Risk that adding `domain_footprint_hint` to the JSON index encourages tooling to bypass Phase 0b | The hint is informational only; the orchestrator never reads it. Tooling that bypasses Phase 0b would violate R-P10 directly and fail the regression test added in [03-pe-meta-update-plan.md](03-pe-meta-update-plan.md) |
| Use-case examples claim specific domain footprints (e.g. `--scope context` → 3 domains) but actual footprints depend on each file's declared `domain:` field at runtime | The Phase 0b flow table in `p0-04` is explicit that footprints are TYPICAL and depend on declared metadata. Tier-2 (path-heuristic) and Tier-3 (`unknown`) resolutions are flagged in the Phase 8 report so authors can backfill missing `domain:` fields. Examples in other use cases are illustrative; the orchestrator never trusts use-case-level hints as ground truth |
| Cross-repo portability — use cases reference path-shaped examples (`.copilot/context/00.00-prompt-engineering/`) that may not exist in another repository | Use cases are catalog documentation, not contract. The PORTABLE contract is in vision v15 § Domain detection (read `domain:` from frontmatter; optional repo-specific `pe-domain-map.yaml` fallback). When the catalog is forked into a repo with different conventions, the path examples are updated to match; the algorithm shape remains unchanged |
| Authors might over-apply the `bundle=cross-domain-deps` branch to seed-multi-domain invocations | The branch is only emitted when **seed footprint = 1** AND deps adds additional domains. Seed-multi-domain invocations (`--scope context`, `--scope <multi-paths>` crossing top-level subfolders) continue to fire `bundle=multi-domain-gated` per R-P10. The seed-vs-deps decision matrix in `p0-04 § Phase 0b flow` (Note 3) is the authoritative reference; misapplication would be caught by the parser tests in [03-pe-meta-update-plan.md](03-pe-meta-update-plan.md) |
| Per-dependency-domain specialized lenses could be confused with "running multiple reviews" | The audits run **once** on the seed; only the comparison sub-checks within Phase 2–4 are evaluated per dep-domain. The Phase 8 report sectioning is a presentation concern (one subsection per dep-domain), not a separate-run concern. The `bundle=cross-domain-deps` marker on the first-line `Resolved invocation:` log makes the disposition unambiguous |

---

## 📚 References

**Internal (workspace):**

- [overview.md](overview.md) — Parent issue analysis
- [01-vision-update-plan.md](01-vision-update-plan.md) — Vision v14 → v15 amendments (R-P10, Phase 0b)
- [03-pe-meta-update-plan.md](03-pe-meta-update-plan.md) — Orchestrator and per-artifact prompt updates
- [20260503.02-vision-pe-meta-usecases/00-overview.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) — Current catalog index
- [20260503.02-vision-pe-meta-usecases/usecase-index.json](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json) — Current machine-readable catalog
- [20260503.02-vision-pe-meta-usecases/05-reliability/p0-01-process-reproducibility-usecase.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/05-reliability/p0-01-process-reproducibility-usecase.md) — Sibling use-case format precedent
- [02-pe-meta-update-not-processing-full-context-review/02-usecases-update-plan.md](../02-pe-meta-update-not-processing-full-context-review/02-usecases-update-plan.md) — Sibling plan format precedent
