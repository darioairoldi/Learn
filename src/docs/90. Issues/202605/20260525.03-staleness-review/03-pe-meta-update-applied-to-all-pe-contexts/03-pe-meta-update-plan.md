---
title: "Plan: pe-meta-update v2.1.0 → v2.2.0 — implement Phase 0b domain-coherence gate; inherit across all /pe-meta-* prompts"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, pe-meta, orchestrator]
description: "Plan for amending [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) (v2.1.0 → v2.2.0) and the 32 sibling prompts in [.github/prompts/00.09-pe-meta/](../../../../../../.github/prompts/00.09-pe-meta/) to implement the Phase 0b domain-coherence gate defined in [01-vision-update-plan.md](01-vision-update-plan.md) and exercised by [02-usecases-update-plan.md](02-usecases-update-plan.md). Adds a deterministic **metadata-first 3-tier domain resolution algorithm** (declared `domain:` frontmatter → optional per-repo `pe-domain-map.yaml` heuristic → `unknown`), a numbered split-proposal renderer, the `bundle=accept` consent token to the parser, a new CF-05 family for `--skip domain-coherence`, the **seed-footprint vs dependency-footprint distinction** with a new `bundle=cross-domain-deps` disposition (single-seed positional invocation whose `--deps full` closure spans additional dep-domains — one review with per-dep-domain specialized analysis lenses, no split), five new example invocations (originating incident + canonical split + bundle-accept variant + `--deps full` seed-multi-domain consumer-chain + `--deps full` single-seed cross-domain-deps article-writing prompt case), and a per-prompt impact-assessment table covering all 33 files in the pe-meta family. The eight canonical artifact-type roots remain in scope only for default-all scope expansion and the Phase 0a CF-05 artifact-type/path consistency check; they are NOT a domain partitioning. The pe-meta artifacts themselves remain single-domain on the consumer side (only `prompt-engineering`); the seed-vs-deps algorithm is implemented in the orchestrator because the orchestrator runs against ALL invocations, including invocations targeting consumer artifacts in other domains."
draft: false
status: "todo"
last_updated: "2026-05-29"
severity: "High"
component: "[pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md)"
framework: "GitHub Copilot Customization v1.107 (vision v14 → v15)"
---

# Plan — pe-meta-update v2.1.0 → v2.2.0 — implement Phase 0b domain-coherence gate; inherit across all /pe-meta-* prompts

**Parent issue:** [overview.md](overview.md) (this sub-issue's analysis)
**Plan ID:** `03-pe-meta-update-plan`
**Date:** 2026-05-29
**Status:** Todo
**Depends on:** [01-vision-update-plan.md](01-vision-update-plan.md), [02-usecases-update-plan.md](02-usecases-update-plan.md)

---

## 🎯 Goal

Update the orchestrator [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) and its 32 sibling prompts so the **Phase 0b — Domain coherence check** defined in vision v15 is:

1. **Implemented as a deterministic, non-skippable step** in the orchestrator pipeline (between Phase 0a and Phase 1), using the **metadata-first 3-tier domain resolution algorithm** defined in vision v15 § Domain detection (Tier 1: declared `domain:` frontmatter; Tier 2: optional per-repo `pe-domain-map.yaml` path-slug heuristic; Tier 3: `unknown`). The algorithm computes the **seed footprint** and **dependency footprint** SEPARATELY: when |seed footprint|=1 AND `--deps` adds ≥1 additional dep-domain, emit `bundle=cross-domain-deps` and run one review with per-dep-domain specialized analysis lenses (no split). The **eight canonical artifact-type roots** (`.copilot/context/`, `.github/prompts/`, `.github/instructions/`, `.github/agents/`, `.github/templates/`, `.github/skills/`, `.github/hooks/`, `.github/prompt-snippets/`) remain in scope only for (a) `--scope <token>` expansion, (b) default-all expansion per R-P8, and (c) the Phase 0a CF-05 artifact-type/path consistency check; they are NOT a domain partitioning.
2. **Inherited by every per-artifact-type prompt** through the per-artifact prompt invocation matrix — when a per-artifact prompt is invoked DIRECTLY by the user with a positional `<file-path>` (the canonical entry point for per-artifact prompts), it runs its own minimal Phase 0b stub. The stub MUST handle the positional-path scope-extraction step per vision v15 § Domain detection § per-invocation-type matrix and MUST read each in-scope file's `domain:` frontmatter to compute the footprint (the seed file's path does NOT constrain consumer domains when `--deps full` traverses the closure).
3. **Preceded by a Phase 0a artifact-type/path consistency check.** Per-artifact prompts encode an expected artifact-type root in their name; when the supplied positional path or `--scope` value resolves to a different root, the invocation is rejected with CF-05 BEFORE Phase 0b runs. The rejection error MUST suggest the canonically-correct prompt name. CF-05 operates on artifact-type ROOT (deterministic from path), NOT on semantic domain (which is declared in frontmatter).
4. **Exercised by concrete example invocations** covering: the originating heterogeneous-bundle incident, the canonical 3-way split, the `bundle=accept` variant, the user's artifact-type/path mismatch case (`/pe-meta-context-review '.github/prompts/...'`) with its CF-05 rejection and canonical replacement, AND the user's metadata-first payoff case (`/pe-meta-update '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full`) showing how `--deps full` per-file metadata reading produces an honest multi-domain footprint.
5. **Verified by new entries in [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md)** covering: single-domain shortcut, multi-domain gate, `bundle=accept` bypass, split-N selection, `--skip domain-coherence` CF-05 rejection, positional-path metadata-first domain extraction, declared-domain-overrides-path semantics, missing-`domain:`-with-no-map fallback to `unknown`, missing-`domain:`-with-map Tier-2 resolution, no-scope default-all expansion, artifact-type/path mismatch CF-05, `--dim` orthogonality to domain resolution, and `--deps full` multi-domain consumer-chain via per-file metadata reads.
6. **Documented in [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)** with a Phase 0b note explaining inheritance across every command family AND every invocation shape (token, path-set, positional, default-all) AND clarifying that `--dim` (a dimension-group selector per v14) is orthogonal to domain resolution.

7. **Augmented with the seed-footprint vs dependency-footprint decision matrix** in the orchestrator's algorithm spec. The algorithm computes seed footprint and deps footprint separately, then dispatches: (a) seed=1 ∧ deps adds 0 → `bundle=single-domain`; (b) seed=1 ∧ deps adds ≥1 → `bundle=cross-domain-deps` (one review, per-dep-domain specialized lenses, NO split); (c) seed≥2 → `bundle=multi-domain-gated` per R-P10 (split proposal). The `cross-domain-deps` disposition is NOT a bypass of R-P10 — it handles a case R-P10 was never the right tool for (user named ONE artifact; deps are infrastructure that artifact requires, not separate review targets). Splitting would produce incomplete reviews because a consumer artifact needs ALL its declared dependencies present to be evaluated correctly.

8. **Scope-bounded for pe-meta artifacts themselves.** The pe-meta family artifacts all declare `domain: prompt-engineering` and live under `.github/prompts/00.09-pe-meta/`. Direct review invocations against pe-meta files (e.g. `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md' --deps full`) produce a single-domain footprint by construction and do NOT trigger `bundle=cross-domain-deps`. The seed-vs-deps algorithm is nonetheless implemented in the orchestrator because the orchestrator runs against ALL invocations, including invocations targeting consumer artifacts in other domains (e.g. an article-writing prompt whose dependencies span both `article-writing` and `prompt-engineering` context).

The user-issued example `/pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full` is EXPLICITLY called out as an **artifact-type/path mismatch** rejected at Phase 0a with CF-05; the canonical replacement is `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full`. The user-issued example `/pe-meta-update '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full` is the canonical metadata-first payoff case: Phase 0a skips CF-05 (orchestrator-level prompt), `--dim` is parsed and validated as a dimension-group selector (NOT a domain override), Phase 0b reads each file's declared `domain:` frontmatter across the `--deps full` closure, and emits the bundle gate iff the resulting footprint contains ≥ 2 distinct domains.

---

## 📋 Table of contents

- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [📌 pe-meta-update.prompt.md changes (v2.1.0 → v2.2.0)](#-pe-meta-updatepromptmd-changes-v210--v220)
- [⚙️ Phase 0b — concrete implementation](#%EF%B8%8F-phase-0b--concrete-implementation)
- [🔗 Per-prompt impact assessment (33 files)](#-per-prompt-impact-assessment-33-files)
- [🧪 Parser tests to add](#-parser-tests-to-add)
- [📝 Example invocations](#-example-invocations)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

- [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) frontmatter: `version: "2.1.0"` → `"2.2.0"`, `last_updated:` bumped, `scope.covers:` extended with `Phase 0b — domain coherence check`, `metadata-first 3-tier domain resolution`, `optional per-repo pe-domain-map.yaml fallback`, `per-invocation-type scope-extraction`, `seed footprint vs dependency footprint`, `bundle=cross-domain-deps disposition`, `bundle=accept consent token`. (✅ done)
- [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) `argument-hint:` updated to advertise the `bundle=accept` consent token alongside the seven canonical parameters. (✅ done)
- New § Phase 0a precondition — artifact-type/path consistency check inserted at the END of Phase 0a (BEFORE the Phase 0b boundary), with the prompt-name-prefix → expected-root table and CF-05 rejection rule. (✅ done)
- New § Phase 0b — Domain coherence check inserted between § Phase 0a and § Phase 1, with the contents described under § Phase 0b — concrete implementation below. (✅ done)
- Existing § Pipeline phases and `--skip` mapping table updated with the Phase 0b row (NOT skippable). (✅ done)
- Existing § Examples updated with new entries (originating incident, 3-way split, bundle-accept, positional invocation, positional + `--deps full` consumer-chain multi-domain) and rejected examples for `--skip domain-coherence` AND artifact-type/path mismatch. (✅ done)
- Existing § Rejected examples (CF-05) updated with new entries for `--skip domain-coherence`, `bundle=skip`, AND the user's exact artifact-type/path mismatch example. (✅ done)
- Existing § Critical Boundaries → § Always Do extended with "Run Phase 0a artifact-type/path consistency check before Phase 0b; run Phase 0b before Phase 1; never silently process multi-domain scopes". (✅ done)
- Existing § Critical Boundaries → § Never Do extended with "NEVER bypass Phase 0b; NEVER accept a bundle without explicit consent; NEVER process an artifact-type/path mismatch — always reject with CF-05 and suggest the canonical replacement prompt name". (✅ done)
- New § Per-artifact prompt invocation matrix row clarifying Phase 0b inheritance for direct positional-path invocations of per-artifact prompts. (✅ done)
- [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) updated with a Phase 0b note (applies to every command family regardless of `--mode` AND every scope-bearing mechanism). (✅ done)
- [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) extended with 14 new test cases P0b-01..P0b-14 (see § Parser tests to add) — includes the new P0b-14 case covering single-seed `bundle=cross-domain-deps` for an article-writing prompt review with `--deps full`. (✅ done)
- New § Phase 0b § Seed footprint vs dependency footprint subsection inserted into the orchestrator's algorithm spec, with the decision matrix (seed=1 deps+0 → single-domain; seed=1 deps≥1 → cross-domain-deps; seed≥2 → multi-domain-gated) and the rationale that splitting a single-seed cross-domain-deps invocation would produce incomplete reviews. Cross-references vision v15 § Domain detection — Seed footprint vs dependency footprint and [02-usecases-update-plan.md](02-usecases-update-plan.md) p0-04 § Specialized lens (cross-domain-deps). (✅ done)
- Updated § Gate behavior summary table extended from 5 rows to 7 rows including the new `cross-domain-deps` rows for both `--mode apply` and `--mode plan`. (✅ done)
- All 32 sibling prompts in [.github/prompts/00.09-pe-meta/](../../../../../../.github/prompts/00.09-pe-meta/) reviewed per the per-prompt impact assessment table; required edits applied. (✅ done) — Wave 1 (orchestrator + 2 helper docs), Wave 2 (6 supporting orchestrators), Wave 3 (24 per-artifact prompts) all complete on 2026-05-31.
- All "(if present)" hedges removed from the per-prompt impact assessment table — the actual file list at [.github/prompts/00.09-pe-meta/](../../../../../../.github/prompts/00.09-pe-meta/) has been confirmed and all referenced files exist. (✅ done)
- **Version alignment across the pe-meta family** — all 31 `.prompt.md` files under [.github/prompts/00.09-pe-meta/](../../../../../../.github/prompts/00.09-pe-meta/) MUST emerge from this plan at a single coordinated version `version: "2.2.0"` with `last_updated: "<plan-apply-date>"`. Rationale: the Phase 0a CF-05 + Phase 0b stub is a cross-cutting contract owned by the orchestrator; treating the family as a single coordinated release prevents version-drift confusion in the audit log and makes adherence-rubric checks (`pe-meta-adherence`) trivially verifiable (one shared version string). The orchestrator [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) drives the version anchor (2.1.0 → 2.2.0); the 30 siblings were lifted to `2.2.0` in two coordinated waves — Wave 2 lifted the 6 supporting orchestrators, Wave 3 lifted the 24 per-artifact prompts — with `last_updated: "2026-05-31"`. The 2 helper `.md` docs ([pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md), [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md)) got `last_updated:` bumped but retain their own version axes (they are not `.prompt.md` artifacts). (✅ done)
- All file links and anchor references in modified prompts remain resolvable. (✅ done) — lint-clean across all 31 `.prompt.md` files; relative path `../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md` resolves correctly from every `.github/prompts/00.09-pe-meta/*.prompt.md` sibling.

**Mid-stream architectural refactor (2026-05-31)** — During Wave 3 application, the Phase 0a CF-05 + Phase 0b spec was extracted from sibling prompts into a new shared context file [`04.05-pe-meta-invocation-gates.md`](../../../../../../.copilot/context/00.00-prompt-engineering/04.05-pe-meta-invocation-gates.md) (single source of truth). All 24 per-artifact prompts now cite this context file directly, eliminating the sibling-to-sibling citation anti-pattern (each prompt previously would have cited `pe-meta-update.prompt.md`, creating coupling between siblings). The orchestrator and 6 supporting orchestrators continue to own/disclaim CF-05 as before — only the per-artifact prompts gained the per-prompt enforcement section that cites the SoT.

---

## 📌 pe-meta-update.prompt.md changes (v2.1.0 → v2.2.0) (✅ done)

### Frontmatter (Action — replace) (✅ done)

- `version: "2.1.0"` → `"2.2.0"`
- `last_updated: "<today>"`
- Append to `scope.covers:` — `Phase 0b — domain coherence check`, `metadata-first 3-tier domain resolution`, `bundle=accept consent token`, `multi-domain split proposal`
- Append to `boundaries:` — `Phase 0b is NOT skippable; --skip domain-coherence is rejected with CF-05; bundle=accept is the only consent token; --dim is a dimension-group selector and never a domain override`
- `argument-hint:` extended: `'[--mode plan|apply] [--scope <type|path>[,<path>...]] [--source <id>[,<id>...]] [--dim <group|D#>] [--start <date>] [--end <date>] [--deps none|direct|full|<N>] [--skip <stage>[,<stage>...]] [bundle=accept]'`

### Section: § Phase 0b — Domain coherence check (Action — new) (✅ done)

**Where:** Insert between existing § Phase 0a — conversational pre-parser and existing § Phase 1: Source Research.

**Required subsections:**

1. **Goal.** One paragraph mirroring vision v15 § Domain-coherent batching.
2. **Inputs.** Resolved canonical invocation (output of Phase 0a) + the 3-tier domain resolution algorithm (declared `domain:` frontmatter → optional `pe-domain-map.yaml` → `unknown`) defined in vision v15 § Domain detection.
3. **Algorithm (deterministic, 5 steps).** (see § Phase 0b — concrete implementation below)
4. **Outputs.** Domain footprint table (with `domain-source` column showing the tier that resolved each file) + (if ≥ 2 domains) numbered split proposal.
5. **Gate behavior.** Table — `--mode apply` (hard gate) vs `--mode plan` (advisory).
6. **`bundle=accept` consent token.** Single-keystroke bypass; recorded on the first-line `Resolved invocation:` log.
7. **CF-05 rejection.** `--skip domain-coherence` is rejected; the orchestrator emits the canonical error message.
8. **`--dim` orthogonality note.** `--dim` is a dimension-group selector per v14 (filters which audit dimensions Phase 2–4 exercises). It is NEVER a domain override; the domain footprint is always computed from per-file `domain:` metadata regardless of `--dim` value.

### Section: § Pipeline phases and `--skip` mapping (Action — extend) (✅ done)

Insert this row between `0a` and `1`:

| Phase | Identifier | Purpose | `--skip` semantics |
|---|---|---|---|
| **0b** | `domain-coherence` | Compute domain footprint of resolved scope using the 3-tier metadata-first algorithm (per-file `domain:` frontmatter → optional `pe-domain-map.yaml` → `unknown`); produce split proposal when ≥ 2 distinct domains; gate Phase 1 in `--mode apply` until consent received | NOT skippable; `--skip domain-coherence` rejected with CF-05 |

### Section: § Examples (Action — extend) (✅ done)

Append:

- `/pe-meta-update --mode apply --scope context` — Manual, artifact-type token `context`. Phase 0a → derived `breadth=full` + `--scope=context`. Phase 0b detects 3 domains (`prompt-engineering`, `article-writing`, `learning-hub`) → emits split proposal → BLOCKS Phase 1 until user selects a split or appends `bundle=accept`. **First-line log:** `Resolved invocation: --mode apply --scope context | breadth=full | caller=manual | bundle=multi-domain-gated`.
- `/pe-meta-update --mode apply --scope .copilot/context/00.00-prompt-engineering/` — Single-domain path. Phase 0b detects 1 domain → emits `bundle=single-domain` → Phase 1 proceeds without prompt. **First-line log:** `… | bundle=single-domain`.
- `/pe-meta-update --mode apply --scope context bundle=accept` — Same as the first example but with explicit consent. Phase 0b detects 3 domains BUT consent is present → proceeds as one atomic bundle. **First-line log:** `… | bundle=accepted-bundle`.

### Section: § Rejected examples (CF-05) (Action — extend) (✅ done)

Append:

- `/pe-meta-update --skip domain-coherence` → CF-05: `--skip domain-coherence is rejected; Phase 0b is not skippable per vision v15 § Domain-coherent batching. To bypass the gate on a multi-domain scope, append bundle=accept to the invocation.`
- `/pe-meta-update '.github\prompts\00.02-pe-granular' --mode apply --scope context --deps full` → CF-05: `positional path argument and --scope <artifact-type-token> are mutually exclusive (--scope value-shape parser, vision v14). Canonical form: /pe-meta-update --mode apply --scope .github/prompts/00.02-pe-granular/ --deps full (per-file domain footprint is computed from each file's declared 'domain:' frontmatter; typically single-domain when all files in that folder declare the same domain).`
- `/pe-meta-update --scope context bundle=skip` → CF-05: `bundle=skip is not a valid consent token; only bundle=accept is accepted. To bypass Phase 0b on a multi-domain scope, append bundle=accept; to run per-domain, copy a single line from the split proposal.`
- `/pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full` → CF-05 (Phase 0a precondition): `artifact-type/path mismatch. Invoked prompt /pe-meta-context-review expects positional paths under .copilot/context/; supplied path resolves under .github/prompts/. Canonical replacement: /pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full.`

### Section: § Critical Boundaries (Action — extend) (✅ done)

**Always Do** — append:

- Run Phase 0b BEFORE Phase 1 on every invocation; never silently process multi-domain scopes
- Echo `bundle=…` marker on the first line of the `Resolved invocation:` log
- Record per-domain `outcome-log.jsonl` entries when a split-N run is selected (one entry per run)

**Never Do** — append:

- **NEVER bypass Phase 0b** — even when the caller passes `--skip all` (Phase 0b is not in the skippable set)
- **NEVER accept a bundle without explicit `bundle=accept`** consent
- **NEVER treat `bundle=` markers other than `accept` as consent** (closed set: only `accept`)
- **NEVER recompute the domain map mid-run** — it is computed once at Phase 0b entry and frozen for the rest of the run

### Section: § Per-artifact prompt invocation matrix (Action — extend) (✅ done)

Append a short paragraph after the existing matrix:

> **Phase 0b inheritance.** When the orchestrator delegates to a per-artifact prompt via the matrix, Phase 0b has already run at the orchestrator level — the per-artifact prompt sees a single-domain scope by construction. When a per-artifact prompt (`pe-meta-context-review`, `pe-meta-prompt-review`, etc.) is invoked DIRECTLY by the user with a positional `<file-path>` (or a multi-path `--scope`), the per-artifact prompt runs its own minimal Phase 0b stub — the same 3-tier metadata-first algorithm (read each in-scope file's `domain:` frontmatter; fall back to `pe-domain-map.yaml` then `unknown`), the same `bundle=` markers — and applies the same gate behavior. When `--deps full` is present, the consumer-chain expansion reads each consumer's `domain:` independently, so a single-file seed under a `pe-engineering` housekeeping path can legitimately resolve to a multi-domain footprint when its consumers span multiple domains.

---

## ⚙️ Phase 0b — concrete implementation

### Phase 0a precondition — artifact-type/path consistency check

Inserted at the END of Phase 0a (immediately before the Phase 0b boundary). Per-artifact prompts encode an expected artifact-type root in their NAME; the supplied positional path or `--scope` path MUST resolve under that root, otherwise the invocation is rejected with CF-05 BEFORE Phase 0b runs.

**Prompt-name-prefix → expected artifact-type root:**

| Prompt-name prefix | Expected root |
|---|---|
| `pe-meta-context-*` | `.copilot/context/` |
| `pe-meta-prompt-*` | `.github/prompts/` |
| `pe-meta-instruction-*` | `.github/instructions/` |
| `pe-meta-agent-*` | `.github/agents/` |
| `pe-meta-template-*` | `.github/templates/` |
| `pe-meta-skill-*` | `.github/skills/` |
| `pe-meta-hook-*` | `.github/hooks/` |
| `pe-meta-snippet-*` | `.github/prompt-snippets/` |

**Orchestrator-level prompts skip CF-05** (they are artifact-type-agnostic by design): `pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`.

**Rejection format (CF-05):**

```text
CF-05: artifact-type/path mismatch.
  Invoked prompt: /pe-meta-context-review
  Expected root: .copilot/context/
  Supplied path: .github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md
  Path resolves under: .github/prompts/
Canonical replacement: /pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' [original-options...]
```

### Algorithm (5 deterministic steps)

1. **Resolve scope to file set per invocation shape.** Five shapes per vision v15 § Domain detection § per-invocation-type scope-extraction matrix:
   - **Token** (`--scope context`): expand to the full subtree under the matching artifact-type root (one of the 8 canonical roots).
   - **Path-set single** (`--scope <path>`): the single file or folder.
   - **Path-set multi** (`--scope <p1>,<p2>,...`): the union of all paths.
   - **Positional `<file-path>`** (per-artifact prompts): the single file; if `--deps full` is present, expand to the consumer chain via the dependency-tracking files (each consumer's path is added to the file set independently — the consumer's domain is determined by its OWN frontmatter, NOT inherited from the seed).
   - **Default-all** (no `--scope`, no positional, per R-P8): the union of all eight artifact-type roots.
   The chosen shape MUST be recorded on the first-line log via the `scope-source=` marker (`token | path-set | positional | default-all | unrecognized-root`).
2. **Resolve domain per file via 3-tier metadata-first algorithm (vision v15 § Domain detection).** For each file in the resolved set, in this exact order:
   - **Tier 1 — declared metadata (authoritative).** Open the file's YAML frontmatter and read the `domain:` field. When present, the field value IS the domain-id. Record per-file `domain-source=declared-metadata`. Stop.
   - **Tier 2 — optional per-repo path-slug heuristic.** When `domain:` is absent AND the repository root contains `pe-domain-map.yaml` (or equivalent config registered with the orchestrator), apply path-prefix → domain-id mappings from that map (first-match wins). Record per-file `domain-source=path-heuristic` (flagged in the Phase 8 report). Stop.
   - **Tier 3 — `unknown` fallback.** When neither Tier 1 nor Tier 2 resolves, assign domain-id `unknown` and emit a per-file warning. Record per-file `domain-source=unknown`. `unknown` is a real domain-id for footprint purposes — a homogeneous set of `unknown` files passes silently as single-domain; mixing `unknown` with declared domains fires the gate, surfacing the metadata gap.
   Cache the per-file resolution map for the lifetime of the run.
3. **Compute domain footprint — seed and deps separately.** Partition the resolved file set into two subsets BEFORE counting domains:
   - **Seed subset** = files supplied directly by the invocation (positional path, `--scope` paths, or `--scope` token expansion) BEFORE `--deps` traversal.
   - **Deps subset** = files added by `--deps direct` / `--deps full` closure walk (only populated when `--deps` is present).

   Collect the distinct domain-ids over each subset:
   - **Seed footprint** = distinct domain-ids across the seed subset.
   - **Deps footprint** = distinct domain-ids across the deps subset.
   - **Additional dep-domains** = (deps footprint) \ (seed footprint).

   Build the per-domain footprint table reporting both subsets and the per-file `domain-source` tier breakdown.

4. **Decide gate disposition (seed-vs-deps matrix).** Apply this exact decision order on the computed footprints:
   - **|seed footprint| = 1 AND |additional dep-domains| = 0** → emit `bundle=single-domain`; proceed to Phase 1.
   - **|seed footprint| = 1 AND |additional dep-domains| ≥ 1** → emit `bundle=cross-domain-deps`; proceed to Phase 1 WITHOUT a split prompt; Phase 2–4 audits run ONCE on the seed with per-dep-domain specialized analysis lenses applied to the comparison sub-checks (vision v15 § Domain detection — Seed footprint vs dependency footprint). Phase 8 report sections findings under one subsection per dep-domain.
   - **|seed footprint| ≥ 2 AND `bundle=accept` present** → emit `bundle=accepted-bundle`; proceed to Phase 1.
   - **|seed footprint| ≥ 2 AND `bundle=accept` absent AND `--mode apply`** → emit `bundle=multi-domain-gated`; render the split proposal; BLOCK until user input.
   - **|seed footprint| ≥ 2 AND `--mode plan`** → emit `bundle=multi-domain-advisory`; render the split proposal as advisory text; proceed to Phase 1.

   **Rationale.** R-P10 fires on seed-multi-domain (user explicitly asked for broad scope). `cross-domain-deps` is NOT a bypass — it handles a different case (user named ONE artifact; the deps are infrastructure the artifact requires, not separate review targets). Splitting a single-seed cross-domain-deps invocation would produce incomplete reviews because a consumer artifact needs ALL its declared dependencies present to be evaluated correctly.
5. **Render split proposal (when gate fires).** For each domain in the footprint, emit one canonical invocation that scopes only to that domain's files. When the domain's file set maps cleanly to one or more folder-shaped paths, use those paths in `--scope`; when no such mapping exists (e.g. the domain is spread across non-contiguous paths), emit `--scope <comma-separated-file-paths>` explicitly. Use the same parameter values for `--mode`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip` as the originating invocation; replace only `--scope`. Number the proposals 1..N. Append a final option N+1: "Append `bundle=accept` to your original invocation to proceed as one atomic bundle".

### Split proposal renderer — output format

```text
Phase 0b: multi-domain scope detected (3 domains across 51 files)

Domain footprint:
  | Domain              | Files | Tier-1 dependents | domain-source breakdown                |
  | ------------------- | ----- | ----------------- | -------------------------------------- |
  | prompt-engineering  |    25 |                18 | declared-metadata=25                   |
  | article-writing     |    14 |                 7 | declared-metadata=12, path-heuristic=2 |
  | learning-hub        |    12 |                 4 | declared-metadata=10, unknown=2        |

Proposed per-domain split (recommended):
  [1] /pe-meta-update --mode apply --scope .copilot/context/00.00-prompt-engineering/
  [2] /pe-meta-update --mode apply --scope .copilot/context/01.00-article-writing/
  [3] /pe-meta-update --mode apply --scope .copilot/context/90.00-learning-hub/

Bypass option:
  [4] /pe-meta-update --mode apply --scope context bundle=accept

Select a split number (1-3) to run that domain only, run all three sequentially (`all`), or [4] to proceed as one atomic bundle.

Note: 2 files were resolved by path-heuristic (Tier 2) and 2 files by `unknown` fallback (Tier 3). Consider adding `domain:` to those files' YAML frontmatter; see the Phase 8 report for the exact file list.
```

### Gate behavior summary

| `--mode` | Seed footprint | Additional dep-domains | `bundle=accept` present? | Phase 0b disposition | Phase 1 runs? |
|---|---|---|---|---|---|
| `apply` | 1 | 0 | n/a | `single-domain` | Yes |
| `apply` | 1 | ≥ 1 | n/a | `cross-domain-deps` | Yes (one run; per-dep-domain lenses in Phase 2–4) |
| `apply` | ≥ 2 | n/a | no | `multi-domain-gated` | No — BLOCK on user input |
| `apply` | ≥ 2 | n/a | yes | `accepted-bundle` | Yes |
| `plan` | 1 | 0 | n/a | `single-domain` | Yes |
| `plan` | 1 | ≥ 1 | n/a | `cross-domain-deps` | Yes (one run; per-dep-domain lenses in Phase 2–4) |
| `plan` | ≥ 2 | n/a | n/a | `multi-domain-advisory` | Yes (with advisory in report) |

---

## 🔗 Per-prompt impact assessment (33 files)

| Prompt file | Category | Phase 0b impact | Required edit |
|---|---|---|---|
| `pe-meta-update.prompt.md` | Orchestrator | Primary owner — implements Phase 0b | Full v2.1.0 → v2.2.0 changes per § pe-meta-update.prompt.md changes |
| `pe-meta-review.prompt.md` | Orchestrator (review-only variant) | Implements Phase 0b in plan-mode-only form | Add § Phase 0b — Domain coherence check subsection; advisory-only since this orchestrator never `--mode apply`'s |
| `pe-meta-create-update.prompt.md` | Multi-artifact dispatcher | Dispatches to per-artifact `*-create-update` prompts; both Phase 0a CF-05 and Phase 0b stub apply per dispatched target | Add § Phase 0a precondition subsection (validate dispatched target's artifact-type/path consistency); add § Phase 0b inheritance subsection |
| `pe-meta-design.prompt.md` | Multi-artifact dispatcher | Dispatches to per-artifact `*-design` prompts; both Phase 0a CF-05 and Phase 0b stub apply per dispatched target | Add § Phase 0a precondition subsection; add § Phase 0b inheritance subsection |
| `pe-meta-adherence.prompt.md` | Orchestrator (guidance-first) | Inherits Phase 0b from orchestrator when delegated; owns the adherence rubric that audits orchestrator runs | Add one-line note in § Invocation; extend adherence rubric to check Phase 0a CF-05 markers and Phase 0b `bundle=…` markers on the first-line `Resolved invocation:` log (rubric items: presence of `bundle=…`, value within closed set `{single-domain, cross-domain-deps, multi-domain-gated, accepted-bundle, multi-domain-advisory}`, consistency with declared `--mode`) |
| `pe-meta-scheduled-review.prompt.md` | Orchestrator (scheduled) | Auto-rotation can land on cross-domain target | Add § Phase 0b inheritance subsection; document that the auto-rotation MUST surface the gate when triggered cross-domain |
| `pe-meta-release-monitor.prompt.md` | Orchestrator (release-diff) | Multi-source diff can imply cross-domain artifacts | Add § Phase 0b inheritance subsection |
| `pe-meta-context-review.prompt.md` | Per-artifact (review) | Direct positional-path invocation; CF-05 if path not under `.copilot/context/` | Add Phase 0a CF-05 subsection (expected root `.copilot/context/`); add minimal Phase 0b stub (positional-path scope-extraction; same algorithm and markers); link to orchestrator's full spec |
| `pe-meta-context-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.copilot/context/`) |
| `pe-meta-context-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.copilot/context/`) |
| `pe-meta-instruction-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/instructions/`; flat-root fallback applies) |
| `pe-meta-instruction-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/instructions/`) |
| `pe-meta-instruction-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/instructions/`) |
| `pe-meta-agent-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/agents/`) |
| `pe-meta-agent-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/agents/`) |
| `pe-meta-agent-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/agents/`) |
| `pe-meta-prompt-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/prompts/`) |
| `pe-meta-prompt-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/prompts/`) |
| `pe-meta-prompt-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/prompts/`) |
| `pe-meta-skill-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/skills/`; single-slug-root fallback applies) |
| `pe-meta-skill-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/skills/`) |
| `pe-meta-skill-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/skills/`) |
| `pe-meta-hook-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/hooks/`; flat-root fallback applies) |
| `pe-meta-hook-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/hooks/`) |
| `pe-meta-hook-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/hooks/`) |
| `pe-meta-template-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/templates/`) |
| `pe-meta-template-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/templates/`) |
| `pe-meta-template-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/templates/`) |
| `pe-meta-snippet-review.prompt.md` | Per-artifact (review) | Same | Same (expected root `.github/prompt-snippets/`; flat-root fallback applies) |
| `pe-meta-snippet-create-update.prompt.md` | Per-artifact (create-update) | Same | Same (expected root `.github/prompt-snippets/`) |
| `pe-meta-snippet-design.prompt.md` | Per-artifact (design) | Same | Same (expected root `.github/prompt-snippets/`) |
| `pe-meta-option-applicability-matrix.md` | Helper doc | Documentation only | Append Phase 0b note: "applies to every command family regardless of `--mode` AND every scope-bearing mechanism (token, path-set, positional, default-all)" |
| `pe-meta-option-parser-tests.md` | Helper doc | Test catalog | Add 14 new test cases P0b-01..P0b-14 (see § Parser tests to add) — covers single-domain shortcut, multi-domain gate, `bundle=accept` bypass, `--mode plan` advisory, path-set multi-domain, `--skip domain-coherence` CF-05, positional declared-metadata, declared-overrides-path, Tier-3 `unknown` fallback, Tier-2 `pe-domain-map.yaml` heuristic, default-all expansion, Phase 0a CF-05 mismatch, `--dim` + `--deps full` orthogonality, and single-seed `bundle=cross-domain-deps` for an article-writing prompt review with `--deps full` |

**Note.** The actual file inventory at `.github/prompts/00.09-pe-meta/` has been reconciled with this table: 31 `.prompt.md` files (7 orchestrator-level + 24 per-artifact across 8 roots × 3 ops) + 2 helper `.md` docs = 33 entries above. `pe-meta-router.prompt.md` and `pe-meta-meta-review.prompt.md` are NOT present in the family and have been removed from this table (the latter's adherence-rubric extension action has been absorbed into the `pe-meta-adherence.prompt.md` row, which owns the rubric).

### Minimal Phase 0b stub for per-artifact prompts (~12 lines)

Each per-artifact prompt that accepts a `--scope` capable of cross-domain resolution gets this subsection inserted in its § Invocation options or § Pipeline section:

> ### Phase 0b — Domain coherence check (inherited)
>
> When this prompt is invoked DIRECTLY by the user with a positional `<file-path>` (or `--scope`) that resolves to a file set spanning ≥ 2 semantic domains, this prompt:
>
> 1. Computes the domain footprint deterministically via the 3-tier metadata-first algorithm (Tier 1: each file's declared `domain:` YAML frontmatter; Tier 2: optional per-repo `pe-domain-map.yaml`; Tier 3: `unknown`) defined in vision v15 § Domain detection. The seed file's path does NOT constrain consumer domains when `--deps full` traverses the closure — each consumer's `domain:` is read independently.
> 2. In `--mode apply`: renders a numbered split proposal and BLOCKS the audit phases until the user selects a split OR appends `bundle=accept`.
> 3. In `--mode plan`: renders the proposal as an advisory note in the report and proceeds.
> 4. Records the disposition on the `Resolved invocation:` log via the `bundle=` marker and per-file `domain-source=` tiers in the Phase 8 report.
>
> When this prompt is delegated to by the orchestrator, Phase 0b has already run and the resolved scope is single-domain by construction; this stub is a no-op.
>
> See [pe-meta-update.prompt.md § Phase 0b](pe-meta-update.prompt.md) for the full specification.

---

## 🧪 Parser tests to add

Insert into [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md):

| ID | Input | Expected resolution | Expected Phase 0b disposition | Expected log marker |
|---|---|---|---|---|
| P0b-01 | `/pe-meta-update --mode apply --scope .copilot/context/00.00-prompt-engineering/` | `--scope=<single folder>`, breadth=full; each file's `domain:` read (assume homogeneous `prompt-engineering`) | `bundle=single-domain` | `bundle=single-domain \| scope-source=path-set` |
| P0b-02 | `/pe-meta-update --mode apply --scope context` | `--scope=context`, breadth=full; per-file `domain:` reads yield ≥ 2 distinct values | `bundle=multi-domain-gated`; BLOCK on input | `bundle=multi-domain-gated \| scope-source=token` |
| P0b-03 | `/pe-meta-update --mode apply --scope context bundle=accept` | `--scope=context`, breadth=full, consent=accept | `bundle=accepted-bundle`; proceed | `bundle=accepted-bundle \| scope-source=token` |
| P0b-04 | `/pe-meta-update --mode plan --scope context` | `--scope=context`, breadth=full, mode=plan | `bundle=multi-domain-advisory`; proceed | `bundle=multi-domain-advisory \| scope-source=token` |
| P0b-05 | `/pe-meta-update --mode apply --scope .copilot/context/01.00-article-writing/,.copilot/context/90.00-learning-hub/` | `--scope=<2 folders>`, breadth=full; per-file `domain:` reads yield 2 distinct values | `bundle=multi-domain-gated`; BLOCK on input | `bundle=multi-domain-gated \| scope-source=path-set` |
| P0b-06 | `/pe-meta-update --skip domain-coherence` | n/a (parser rejection) | CF-05 | n/a |
| P0b-07 | `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md'` | Positional path; Phase 0a CF-05 passes (path under `.github/prompts/`); file's frontmatter declares `domain: prompt-engineering` → Tier 1 resolution | `bundle=single-domain` | `bundle=single-domain \| scope-source=positional`; per-file `domain-source=declared-metadata` |
| P0b-08 | `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md'` (frontmatter declares `domain: article-writing`) | Metadata-first: declared `domain:` WINS over housekeeping path slug `00.09-pe-meta`; footprint = `article-writing` | `bundle=single-domain` | `bundle=single-domain \| scope-source=positional`; per-file `domain-source=declared-metadata` |
| P0b-09 | `/pe-meta-prompt-review 'some/non-pe-root/file.md'` (no `domain:` field; no `pe-domain-map.yaml` in repo) | Phase 0a CF-05 (path not under `.github/prompts/`) IF prompt is per-artifact `prompt-*`; if orchestrator-level (`pe-meta-update`), Phase 0a passes → Phase 0b Tier-1 absent → Tier-2 absent → Tier-3 `unknown` | `bundle=single-domain` (footprint=1, domain=`unknown`) with per-file warning | `bundle=single-domain \| scope-source=positional`; per-file `domain-source=unknown` |
| P0b-10 | `/pe-meta-update 'some/legacy/file.md'` (no `domain:`; repo ships `pe-domain-map.yaml` with `some/legacy/ → legacy`) | Phase 0a passes (orchestrator); Phase 0b Tier-1 absent → Tier-2 matches `some/legacy/ → legacy` | `bundle=single-domain` (footprint=1, domain=`legacy`) | `bundle=single-domain \| scope-source=positional`; per-file `domain-source=path-heuristic` (flagged in Phase 8 report) |
| P0b-11 | `/pe-meta-update --mode apply` | No `--scope`, no positional → default-all per R-P8 → expand to all 8 artifact-type roots → N distinct declared domains | `bundle=multi-domain-gated`; BLOCK on input | `bundle=multi-domain-gated \| scope-source=default-all` |
| P0b-12 | `/pe-meta-context-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md'` | Phase 0a CF-05: prompt expects `.copilot/context/`, supplied path under `.github/prompts/` | CF-05 (rejected BEFORE Phase 0b runs); suggested canonical replacement `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md'` | n/a |
| P0b-13 | `/pe-meta-update '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full` | Orchestrator-level prompt (Phase 0a skips CF-05); `--dim` parsed as dimension-group selector (NOT domain override); Phase 0b scope = seed + `--deps full` closure (≥ 2 distinct declared domains across consumers) | `bundle=multi-domain-gated`; BLOCK on input. Confirms `--dim` is orthogonal to domain footprint | `bundle=multi-domain-gated \| scope-source=positional`; per-file `domain-source=declared-metadata` for each in-scope file |
| P0b-14 | `/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full` | Phase 0a CF-05 passes (path under `.github/prompts/`); seed = 1 file, declared `domain: article-writing`; `--deps full` closure expands to context files declared `article-writing` AND `prompt-engineering`. Seed footprint = `{article-writing}`; Deps footprint = `{article-writing, prompt-engineering}`; Additional = `{prompt-engineering}` | `bundle=cross-domain-deps`; NO split prompt; Phase 2–4 audits run ONCE on the seed with per-dep-domain specialized lenses (MWSG/Diataxis for `article-writing` deps; R-P*/boundary-actionability for `prompt-engineering` deps); Phase 8 report sections findings per dep-domain | `bundle=cross-domain-deps \| scope-source=positional`; per-file `domain-source=declared-metadata`; report markers `seed-footprint={article-writing} \| deps-footprint={article-writing,prompt-engineering} \| additional-dep-domains={prompt-engineering}` |

---

## 📝 Example invocations

### Originating incident — what triggered this plan

```text
/pe-meta-update --mode apply --scope context
```

In v14, this resolves to derived `breadth=full` + `--scope=context` and processes 51 files across 3 domains as one atomic bundle. In v15 (this plan applied), Phase 0b detects the multi-domain footprint and BLOCKS Phase 1 until the user selects a split or appends `bundle=accept`.

### Canonical 3-way split (the recommended replacement)

```text
/pe-meta-update --mode apply --scope .copilot/context/00.00-prompt-engineering/
/pe-meta-update --mode apply --scope .copilot/context/01.00-article-writing/
/pe-meta-update --mode apply --scope .copilot/context/90.00-learning-hub/
```

Each run resolves to `bundle=single-domain`; Phase 0b proceeds without prompt. The three runs can be executed sequentially with independent approval gates and per-domain `outcome-log.jsonl` entries.

### Bundle-accept variant (single-keystroke bypass)

```text
/pe-meta-update --mode apply --scope context bundle=accept
```

Resolves to `bundle=accepted-bundle`; Phase 0b emits a one-line notice and proceeds as today. The user has explicitly accepted the heterogeneous batch.

### User's other example — currently rejected; corrected form

User submitted: `/pe-meta-update '.github\prompts\00.02-pe-granular' --mode apply --scope context --deps full`

This invocation mixes a **positional path argument** (`.github\prompts\00.02-pe-granular`) with `--scope <artifact-type-token>` — these are two competing scope specifications. Per the v14 value-shape `--scope` parser, this is rejected with CF-05 (see § Rejected examples above).

**Canonical replacement:**

```text
/pe-meta-update --mode apply --scope .github/prompts/00.02-pe-granular/ --deps full
```

This resolves to a single folder under the `prompts/` artifact-type root. Phase 0b detects 1 domain (`pe-granular`) → emits `bundle=single-domain` → Phase 1 proceeds without prompt.

### User's third example — artifact-type/path mismatch (Phase 0a CF-05)

User submitted: `/pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full`

The invoked prompt is `pe-meta-context-review`, which expects positional paths under `.copilot/context/`. The supplied positional path resolves under `.github/prompts/`. Per Phase 0a § precondition (artifact-type/path consistency check), this is rejected with CF-05 BEFORE Phase 0b runs.

**CF-05 rejection message:**

```text
CF-05: artifact-type/path mismatch.
  Invoked prompt: /pe-meta-context-review
  Expected root: .copilot/context/
  Supplied path: .github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md
  Path resolves under: .github/prompts/
Canonical replacement: /pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full
```

**Canonical replacement:**

```text
/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full
```

This resolves to a single file under the `.github/prompts/` artifact-type root. Phase 0a precondition passes (path matches expected root for `pe-meta-prompt-*`); Phase 0b reads the file's `domain:` frontmatter (Tier 1) to resolve the seed's domain → emits `bundle=single-domain` when consumer footprint is also that single domain. With `--deps full`, each consumer's `domain:` is read independently — the consumer footprint MAY widen to multiple domains, in which case Phase 0b's standard gate fires.

### User's fourth example — metadata-first payoff with `--deps full`

User submitted: `/pe-meta-update '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full`

This is the canonical metadata-first payoff case. Walkthrough:

1. **Phase 0a — CF-05 skipped.** `pe-meta-update` is an orchestrator-level prompt (per the prompt-name-prefix table); CF-05 artifact-type/path consistency check does NOT apply.
2. **Phase 0a — `--dim` validation.** `--dim context-quality-lifecycle` is parsed and validated as a **dimension-group selector** per vision v14 (filters which audit dimensions Phase 2–4 exercises). It is NEVER a domain override.
3. **Phase 0b — scope extraction.** Positional `<file-path>` shape; seed = the agent-design prompt file; `--deps full` expands to the consumer closure via the dependency-tracking files. `scope-source=positional`.
4. **Phase 0b — metadata-first per-file resolution.** For each file in the closure (seed + consumers), read the YAML frontmatter `domain:` field (Tier 1). The seed file declares `domain: prompt-engineering`; consumers may declare `prompt-engineering`, `article-writing`, `learning-hub`, or others depending on the dependency graph. Path slug `00.09-pe-meta` does NOT constrain consumer domains — each consumer's `domain:` is read from its own frontmatter.
5. **Phase 0b — footprint and gate.** Distinct declared domains across the closure form the footprint. If ≥ 2 distinct domains in `--mode apply`: emit `bundle=multi-domain-gated`, render the split proposal, BLOCK until user input or `bundle=accept`. The split proposal scopes per-domain (one canonical invocation per domain, with `--dim context-quality-lifecycle` and `--deps full` preserved unchanged).

This case demonstrates **why path-walk would silently misclassify** — a path-walk approach would map the seed file to domain `pe-meta` based on its housekeeping path slug `00.09-pe-meta/` and incorrectly treat the entire closure as single-domain `pe-meta`, hiding the genuine cross-domain footprint that `--deps full` produces.

### User's fifth example — single-seed cross-domain-deps for an article-writing prompt review

```text
/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full
```

**Walkthrough (the canonical `bundle=cross-domain-deps` case):**

1. **Phase 0a.** CF-05 passes (`pe-meta-prompt-*` expects `.github/prompts/`; supplied path matches).
2. **Phase 0b seed extraction.** Single positional file; read the seed's `domain:` frontmatter → `article-writing`. **Seed footprint = { article-writing }**.
3. **Phase 0b `--deps full` closure.** Walk the seed's references and file links. Closure includes context files under `.copilot/context/01.00-article-writing/` (all declared `domain: article-writing`) AND context files under `.copilot/context/00.00-prompt-engineering/` (all declared `domain: prompt-engineering`), plus two instruction files in `.github/instructions/`. Read each file's `domain:` independently. **Deps footprint = { article-writing, prompt-engineering }**. **Additional dep-domains = { prompt-engineering }**.
4. **Phase 0b decision.** seed=1 AND deps adds ≥ 1 → emit `bundle=cross-domain-deps`. NO split proposal. Log marker: `bundle=cross-domain-deps | scope-source=positional | seed-footprint={article-writing} | deps-footprint={article-writing,prompt-engineering} | additional-dep-domains={prompt-engineering}`. Phase 1 proceeds.
5. **Phase 2–4 audits.** Run ONCE on the seed prompt. The rule-adherence and context-comparison sub-checks within each audit apply per dep-domain: MWSG voice rules / Diátaxis type validation / accessibility / readability targets against the `article-writing` dependencies; R-P1…R-P10 rationale checks / boundary-actionability redteam / three-layer rule architecture against the `prompt-engineering` dependencies.
6. **Phase 8 report.** Two subsections: "Findings vs `article-writing` context" and "Findings vs `prompt-engineering` context". Each finding carries the lens label that produced it.

**Why this is NOT a bypass of R-P10.** R-P10 fires on seed-multi-domain (user explicitly asked for broad scope, like `--scope context`). This invocation names ONE artifact; the cross-domain deps are infrastructure that artifact requires (a prompt about article writing must comply with both article-writing rules and the prompt-engineering rationale set), not separate review targets. Splitting would produce incomplete reviews because the consumer artifact needs ALL its declared dependencies present to be evaluated correctly. This is the case the new `bundle=cross-domain-deps` disposition handles correctly per Goal item 7 and parser test P0b-14.

---

## ⚠️ Boundaries and risks

| Concern | Mitigation |
|---|---|
| Phase 0b adds latency to every invocation | The 3-tier algorithm is deterministic and runs in < 1 second on the largest workspace (51 files, 3 domains); each file's YAML frontmatter is read once and cached. No LLM call required |
| `bundle=accept` is too easy a bypass | Intentional — the gate exists to prevent *silent* heterogeneous batching, not to forbid it. Explicit consent satisfies R-P8's predictability contract. The first-line log marker (`bundle=accepted-bundle`) provides an audit trail |
| Files lack declared `domain:` frontmatter | Tier 2 (`pe-domain-map.yaml`) and Tier 3 (`unknown`) fallbacks ensure resolution never fails. Per-file `domain-source=path-heuristic` or `domain-source=unknown` markers are surfaced in the Phase 8 report so authors can backfill the metadata. Mixing `unknown` with declared domains fires the gate, surfacing metadata gaps automatically |
| `pe-domain-map.yaml` heuristic divergence from declared metadata | Heuristic NEVER overrides declared metadata (Tier 1 wins). When both are present for the same file, declared wins silently — no warning, because the map is heuristic by design. Map entries are flagged per-file in the Phase 8 report so authors can migrate to declared metadata |
| Cross-repo portability (other repos don't use `<NN>.<NN>-<slug>/` convention) | Tier 1 declared `domain:` is convention-agnostic. Tier 2 `pe-domain-map.yaml` is per-repo configurable. Tier 3 `unknown` always applies as final fallback. The orchestrator works on any repo without modification |
| `unknown` domain-id collides with a real domain named `unknown` | Documented as a reserved domain-id. Repos MUST NOT declare `domain: unknown` in any file; the orchestrator emits a Phase 8 report warning when a declared value collides with the reserved id |
| `--dim` orthogonality to domain resolution is non-obvious | The boundary is explicit in the algorithm step 2 note, the parser test P0b-13, the per-artifact stub spec, and the user's fourth example walkthrough. `--dim` filters audit dimensions Phase 2–4 exercises; it never affects Phase 0b footprint computation |
| `--deps full` multi-domain footprint surprises users who expected single-domain | This is the intended payoff of metadata-first — the gate honestly surfaces what `--deps full` actually traverses. The user can accept the bundle, split per-domain, or restrict to `--deps direct`/`--deps none` |
| CF-05 ROOT check confused with domain check | The Phase 0a CF-05 table is explicitly labeled "artifact-type ROOT consistency"; the rejection message names the expected root (a path), not a domain (a frontmatter value). The two checks operate on different inputs and run at different phases |
| Per-artifact prompts duplicate the algorithm | The stub is ~14 lines; the orchestrator's full spec is the single source of truth. Drift risk is low because both sides cite the same vision v15 § Domain detection sub-sections |
| Tests added to parser-tests but no regression harness exists | The parser-tests file is a markdown-based test catalog (same as today); it is consumed by `pe-meta-adherence` for adherence checks, not by an automated harness. The 14 new tests (including P0b-14 for cross-domain-deps) follow the existing format |
| Multi-path `--scope` users now have to think about domains | The error message and the split proposal both make the domain boundary explicit; this is an intentional UX improvement, not a regression |
| Phase 0b interferes with `--mode plan` workflows | Plan mode is unblocked — the gate is advisory only. The split proposal appears in the Phase 8 report so the user can act on it later if they decide to apply |
| `bundle=cross-domain-deps` could be conflated with `bundle=multi-domain-gated` (both involve >1 domain in the final closure) | The two dispositions key off SEED footprint, not closure footprint. The seed-vs-deps decision matrix in Phase 0b Step 4 is authoritative: seed=1 → cross-domain-deps; seed≥2 → multi-domain-gated. Parser test P0b-14 pins the discrimination. The first-line log marker is distinct (`bundle=cross-domain-deps` vs `bundle=multi-domain-gated`), and Phase 8 reports section findings differently (per-dep-domain subsections for cross-domain-deps; per-domain split proposal for multi-domain-gated) |
| The pe-meta family itself never needs `bundle=cross-domain-deps` (all pe-meta artifacts declare `domain: prompt-engineering`) but the algorithm is still implemented orchestrator-wide | The orchestrator runs against ALL invocations, not just pe-meta self-review. Reviews of consumer artifacts in other domains (e.g. article-writing prompts with cross-domain dependencies) are the canonical use case. Goal item 8 makes the scope split explicit; the algorithm lives in the orchestrator because the orchestrator is the right execution point, not because pe-meta artifacts themselves need it |

---

## 📚 References

**Internal (workspace):**

- [overview.md](overview.md) — Parent issue analysis
- [01-vision-update-plan.md](01-vision-update-plan.md) — Vision v14 → v15 amendments (R-P10, Phase 0b)
- [02-usecases-update-plan.md](02-usecases-update-plan.md) — Use-case catalog updates
- [pe-meta-update.prompt.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md) — Orchestrator (target file)
- [pe-meta-option-applicability-matrix.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md) — Option applicability matrix (target file)
- [pe-meta-option-parser-tests.md](../../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-parser-tests.md) — Parser tests catalog (target file)
- [20260529.01-vision.v14.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) — Current vision (precedent for v15 amendments)
- [02-pe-meta-update-not-processing-full-context-review/03-pe-meta-update-plan.md](../02-pe-meta-update-not-processing-full-context-review/03-pe-meta-update-plan.md) — Sibling plan format precedent
