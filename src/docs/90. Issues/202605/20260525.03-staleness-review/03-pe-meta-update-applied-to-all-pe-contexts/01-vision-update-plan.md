---
title: "Plan: Vision v14 → v15 — domain-coherent batching; propose-split before apply on multi-domain scopes"
author: "Dario Airoldi"
date: "2026-05-29"
categories: [plan, prompt-engineering, vision, pe-meta]
description: "Plan for amending [20260529.01-vision.v14.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) so that whenever a resolved `--scope` covers ≥ 2 semantic domains (e.g. `--scope context` resolving across `prompt-engineering`, `article-writing`, `learning-hub`), the orchestrator MUST surface the domain footprint and propose a per-domain split BEFORE Phase 1 runs. Bundle execution requires explicit consent. Adds rationale R-P10-domain-coherent-batching, a new deterministic Phase 0b — Domain coherence check, a Phase 0a CF-05 artifact-type/path consistency check, and a **3-tier metadata-first domain resolution algorithm** (declared `domain:` frontmatter → optional per-repo `pe-domain-map.yaml` heuristic → `unknown`). Domain is a content property declared in artifact metadata, NOT a path property — PE infrastructure paths like `.github/prompts/00.09-pe-meta/` are housekeeping groupings whose contents may target any semantic domain. The algorithm is repo-portable: it specifies WHAT to read (`domain:`) and the fallback order, not any specific folder-naming convention. Generalizes the rule across every `/pe-meta-*` command per the v14 default-full + R-P9 minimal-surface contracts. **Also introduces the seed-footprint vs dependency-footprint distinction**: when the seed scope is single-domain and `--deps` traversal adds further domains, the orchestrator emits a new `bundle=cross-domain-deps` marker and runs ONE review with per-dependency-domain specialized analysis lenses (Microsoft Writing Style Guide for `article-writing` deps, PE rationales for `prompt-engineering` deps, etc.) — splitting in this case would produce incomplete reviews because a consumer artifact needs ALL its declared dependencies to be reviewed correctly."
draft: false
status: "done"
last_updated: "2026-05-30"
severity: "High"
component: "[20260529.01-vision.v14.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md)"
framework: "GitHub Copilot Customization v1.107 (vision v14)"
---

# Plan — Vision v14 → v15 — domain-coherent batching; propose-split before apply on multi-domain scopes

**Parent issue:** [overview.md](overview.md) (this sub-issue's analysis)
**Plan ID:** `01-vision-update-plan`
**Date:** 2026-05-29
**Status:** Done

---

## 🎯 Goal

Update [vision.v14](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) so the document **specifies**:

1. **Domain-coherent batching is mandatory.** Whenever the resolved scope (regardless of how scope was specified) resolves to artifacts spanning **≥ 2 semantic domains**, the orchestrator MUST surface the domain footprint and **propose a per-domain split** before Phase 1 runs. Bundle execution requires explicit consent and emits a `bundle=multi-domain` marker on the first-line `Resolved invocation:` log.
2. **Domain is a content property declared in artifact metadata — NOT a path property.** Two distinct concepts MUST not be conflated:
   - **Artifact-type root** (deterministic from path) — the `.copilot/context/`, `.github/prompts/`, `.github/instructions/`, `.github/agents/`, `.github/templates/`, `.github/skills/`, `.github/hooks/`, `.github/prompt-snippets/` prefix is structural and decidable from the file path. This is what CF-05 (artifact-type/path consistency) checks.
   - **Semantic domain** (declared, not derived) — the `domain:` field in each artifact's YAML frontmatter (e.g. `domain: "prompt-engineering"`, `domain: "article-writing"`). Path slugs like `00.09-pe-meta/` or `00.00-prompt-engineering/` denote *housekeeping/infrastructure* groupings — a prompt under `.github/prompts/00.09-pe-meta/` can target ANY semantic domain because pe-meta prompts are themselves customization tooling, not domain content. Path slug alone CANNOT determine semantic domain.
   - **`domain:` is a single scalar by design.** List form (`domain: [a, b]`), plural variant (`domains:`), and primary/secondary pairs are NOT supported. An artifact that appears to belong to multiple domains usually has dependencies that span domains — captured at the dependency-closure level via the `bundle=cross-domain-deps` mechanism (Goal item 10), NOT in the artifact's own metadata. The single-scalar constraint may prove too restrictive for genuinely cross-cutting artifacts; if so, the schema can be extended later with a separate `additional_domains:` list (kept distinct from `domain:` so the primary remains unambiguous). See [.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md](../../../../../../.copilot/context/00.00-prompt-engineering/00.03-metadata-contracts.md) § `domain:` field semantics for the canonical specification.
   - **`domain:` is REQUIRED on every PE artifact type** (Context, Instruction, Agent, Prompt, Skill, Template) per the canonical metadata contract. Hooks are exempt because they use JSON schema rather than YAML frontmatter. The metadata-first 3-tier resolution algorithm degrades gracefully (Tier 2 → Tier 3) when the field is absent, but absence in any PE artifact is a validator finding.
3. **Domain extraction follows a deterministic 3-tier priority order, applied per-file to every artifact in the resolved scope (and every file pulled in by `--deps full`):**
   - **Tier 1 — declared metadata.** Read the `domain:` field from the artifact's YAML frontmatter. When present, this is the domain-id. Authoritative.
   - **Tier 2 — repo-configurable path-slug heuristic (optional).** When `domain:` is absent AND the repository ships a `pe-domain-map.yaml` (or equivalent config) declaring path-prefix → domain-id mappings, apply that map. The vision specifies the algorithm shape; the **specific map is per-repo** (one repo may use `01.00-article-writing/`, another may use `articles/` or no convention at all). Heuristic-derived assignments MUST be flagged in the report as `domain-source=path-heuristic` so reviewers can see which files lack a declared domain.
   - **Tier 3 — `unknown`.** When neither tier resolves, assign domain-id `unknown` and emit a per-file warning. `unknown` is a real domain-id for footprint purposes — three files all assigned `unknown` form a single-domain footprint; one `unknown` plus one `prompt-engineering` forms a 2-domain footprint and triggers the gate.
4. **An artifact-type/path consistency check is added at Phase 0a (precondition to Phase 0b).** Per-artifact prompts have a name-encoded artifact-type expectation (e.g. `pe-meta-context-*` ⇒ paths under `.copilot/context/`). When the supplied positional path or `--scope` value resolves to a different artifact-type root, the invocation is rejected with CF-05 BEFORE Phase 0b runs. CF-05 operates on the **artifact-type ROOT** (deterministic from path), NOT on the semantic domain. The error message MUST identify both the supplied root and the expected root and SHOULD suggest the canonically-correct prompt name.
5. **A new deterministic phase — Phase 0b — Domain coherence check — runs between Phase 0a and Phase 1.** It produces the domain footprint (table: domain → file count → tier-1 dependents → `domain-source` per file) and the proposed split commands. It is NEVER skippable; `--skip` MUST reject `0b`/`domain-coherence` with CF-05.
6. **A new rationale — R-P10-domain-coherent-batching — is added.** It justifies the rule under the broader R-P8 default-full contract and explains why heterogeneous bundles undermine reviewer judgment, approval gating, and rollback granularity. It also justifies the metadata-first extraction model on portability grounds: the vision is repo-agnostic, so domain MUST be a declared content property the artifact carries with itself, not a property of the filesystem layout the artifact happens to live in.
7. **The rule is command-family-agnostic AND invocation-shape-agnostic.** Like R-P8 and R-P9, R-P10 applies to **every `/pe-meta-*` command** (review, update, create, design, scheduled, release-monitor) AND **every scope-bearing mechanism** (artifact-type token, path-set, positional file, no-scope default-all). The orchestrator AND every per-artifact prompt MUST run Phase 0b regardless of which family was invoked or how scope was specified. `--dim` is orthogonal (it filters which dimensions are audited, not which domain artifacts belong to).
8. **In `--mode plan`, splitting is *recommended but not enforced*.** A single plan output is still useful as a high-level overview; the split proposal is presented as an advisory next-step list. In `--mode apply`, the split proposal is a hard gate — apply MAY NOT proceed without explicit `bundle=accept` or accepting one of the proposed splits.
9. **`--deps full` traversal is where the metadata-first model pays off.** A positional invocation seeded with a single file from `.github/prompts/00.09-pe-meta/` (housekeeping path slug `pe-meta`) may have `domain: prompt-engineering` declared in its frontmatter; `--deps full` then pulls in consumers and dependencies whose domains come from THEIR own frontmatter — not from the seed file's path, not from the seed file's domain. Phase 0b computes the footprint by reading each file's metadata independently. This is the case where a path-walk-based approach would silently misclassify the entire run.
10. **Seed footprint vs dependency footprint — specialized-lens branch.** Phase 0b computes the domain footprint **separately for the seed scope** (the files explicitly named by `--scope` or by a positional path) and **for the dependency closure** (files added by `--deps direct`/`--deps full` traversal). Three outcomes:
    - **seed = 1 domain AND deps = 0 additional domains** → `bundle=single-domain`; Phase 1 proceeds without prompt.
    - **seed ≥ 2 domains** → `bundle=multi-domain-gated`; propose per-domain split (existing R-P10 rule). The seed itself is heterogeneous — the user explicitly asked for broad scope, and splitting produces complete per-domain reviews each of which is independently meaningful.
    - **seed = 1 domain AND deps adds ≥ 1 additional domain** → `bundle=cross-domain-deps`; the orchestrator runs ONE review against the union (seed + deps) but applies **per-dependency-domain specialized analysis lenses** in Phase 2–4 — e.g. when comparing the seed against `article-writing` context, exercise Microsoft Writing Style Guide, Diátaxis, and accessibility expectations; when comparing against `prompt-engineering` context, exercise the PE rationale set and the boundary-actionability redteam pattern. Splitting this case would produce **incomplete reviews** because a consumer artifact needs ALL its declared dependencies present to be evaluated correctly — you cannot meaningfully review an article-writing prompt without the prompt-engineering rules it inherits from, nor without the article-writing rules it targets. The Phase 8 report MUST section findings **per dependency-domain** so reviewers see which findings came from which lens.

---

## 📋 Table of contents

- [🎯 Goal](#-goal)
- [📋 Exit criteria](#-exit-criteria)
- [📌 Proposed amendments](#-proposed-amendments)
- [⚙️ Domain detection — metadata-first resolution](#%EF%B8%8F-domain-detection--metadata-first-resolution)
- [🧭 Phase 0b — Domain coherence check (insertion point)](#-phase-0b--domain-coherence-check-insertion-point)
- [🏗️ Section-by-section changes](#%EF%B8%8F-section-by-section-changes)
- [⚠️ Boundaries and risks](#%EF%B8%8F-boundaries-and-risks)
- [📚 References](#-references)

---

## 📋 Exit criteria

- Vision document version bumped to `15.0.0` with a `v15 changelog` entry under [20260529.01-vision.v14.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.changelog.md) (or new `20260529.01-vision.v15.md` per the existing version-bump convention). (✅ done)
- New § Domain-coherent batching subsection added under § The goal, after § Default-full invocation contract. (✅ done)
- New rationale R-P10-domain-coherent-batching added under § The rationale → Processing strategies. (✅ done)
- § The vision § Assess § Research phase updated to note that Phase 1 runs **after** Phase 0b confirms a single-domain-or-consented bundle. (✅ done)
- § Command families and option model § Pipeline phases and `--skip` mapping updated to list Phase 0b (not skippable) between 0a and 1. (✅ done)
- § Command families and option model § Option resolution rules extended with a new rule #7 — domain-coherence gate. (✅ done)
- § Command families and option model § Option resolution rules extended with a new rule #8 — artifact-type/path consistency check (CF-05 at Phase 0a precondition, BEFORE Phase 0b). (✅ done)
- New § Domain detection subsection added under § Command families and option model, documenting (a) the **artifact-type/semantic-domain distinction** (path determines artifact-type root; metadata determines semantic domain), (b) the **eight canonical artifact-type roots** (`.copilot/context/`, `.github/prompts/`, `.github/instructions/`, `.github/agents/`, `.github/templates/`, `.github/skills/`, `.github/hooks/`, `.github/prompt-snippets/`) used for CF-05 and scope expansion ONLY, (c) the **3-tier metadata-first domain resolution algorithm** (declared `domain:` → optional per-repo path-slug heuristic map → `unknown`), (d) the **per-invocation-type scope-extraction matrix** (artifact-type token, path-set single/multi, positional path, no-scope default-all), (e) the **artifact-type/path consistency rule** with prompt-name → expected-root table, (f) explicit examples of why path-walk-for-domain fails on PE infrastructure files (e.g. `.github/prompts/00.09-pe-meta/`) and on repositories that don't follow the `<NN>.<NN>-<slug>/` convention, and (g) the **seed-footprint vs dependency-footprint distinction** with the `bundle=cross-domain-deps` specialized-lens branch (single-seed multi-domain-deps invocations run as one review with per-dependency-domain specialized analysis lenses; splitting is NOT proposed because consumer artifacts need ALL their declared dependencies to be reviewable). (✅ done)
- `Resolved invocation:` log specification (criterion #12) extended with the `bundle=` marker (`single-domain` \| `multi-domain-gated` \| `accepted-bundle` \| `split-N` \| `cross-domain-deps`) AND a new `scope-source=` marker (`token` \| `path-set` \| `positional` \| `default-all`) so the audit log records HOW scope was specified, not just what it resolved to. The per-domain footprint table in the Phase 8 report additionally records `domain-source=` per file (`declared-metadata` \| `path-heuristic` \| `unknown`) so reviewers can see which assignments came from frontmatter vs. heuristic vs. fallback. When `bundle=cross-domain-deps`, the Phase 8 report MUST also section findings per dependency-domain (one subsection per distinct dep-domain) so reviewers see which lens produced which findings. (✅ done)
- `scope.covers:` frontmatter list extended with `domain-coherent batching`, `Phase 0b — domain coherence check`, `metadata-first domain extraction`, `artifact-type vs. semantic-domain distinction`, `eight canonical artifact-type roots (for CF-05 and scope expansion)`, `3-tier domain resolution algorithm`, `per-invocation-type scope extraction`, `artifact-type/path consistency check`, `portability — per-repo path-slug heuristic is optional`, `seed-footprint vs dependency-footprint distinction`, `bundle=cross-domain-deps specialized-lens branch`, `per-dependency-domain Phase 8 report sectioning`. (✅ done)
- `rationales:` frontmatter list extended with `R-P10-domain-coherent-batching`. (✅ done)
- `boundaries:` frontmatter list extended with: (a) `Phase 0b is NOT skippable; the bundle gate applies to every /pe-meta-* command in every command family AND every scope-bearing mechanism (artifact-type token, path-set, positional file, no-scope default-all)`, (b) `Artifact-type/path mismatches MUST be rejected at Phase 0a with CF-05 BEFORE Phase 0b runs; the rejection error MUST suggest the canonically-correct per-artifact prompt name`, and (c) `Semantic domain MUST be read from the artifact's declared 'domain:' metadata field; path-slug heuristics are optional, per-repo configurable, and MUST be flagged in the report when used; PE infrastructure paths like '.github/prompts/00.09-pe-meta/' are NOT semantic-domain indicators — they are housekeeping groupings whose contents may target any domain`. (✅ done)
- All vision-internal anchor links remain resolvable after section adds. (✅ done)

---

## 📌 Proposed amendments

### Section: Domain-coherent batching (Action — new) (✅ done)

**Where:** Insert at end of § The goal, immediately after § Default-full invocation contract.

**Why:** R-P8 (default-full) and R-P9 (minimal surface) together produced an unintended consequence: a parameter-less manual `/pe-meta-update --mode apply --scope context` correctly resolved to full breadth + full type scope, but then processed three semantically independent domains (`prompt-engineering`, `article-writing`, `learning-hub`) as one atomic bundle. Issue [20260525.03/03-pe-meta-update-applied-to-all-pe-contexts/overview.md](overview.md) documents the resulting unscannable changelist and the misaligned approval gate.

**Proposed text (essence):**

- Multi-domain scope is **legitimate** (it is what the default-full contract resolves to). What is **not legitimate** is silently treating it as one atomic batch.
- The orchestrator MUST: (a) compute the domain footprint of the resolved scope by reading the declared `domain:` metadata field from each file's YAML frontmatter (with optional per-repo path-slug heuristic fallback for files lacking the field, and `unknown` as final fallback), (b) when ≥ 2 distinct domain-ids are present, present a numbered split proposal showing the canonical per-domain invocations, (c) require explicit consent (`bundle=accept` or one of the splits) before Phase 1 runs in `--mode apply`.
- The split proposal MUST be canonical commands — same seven-parameter surface — so the user can copy/paste any single line into a fresh session.
- Splitting is the **default recommendation** because domain-coherent bundles produce: smaller approval surfaces, domain-specialist reviewability, granular rollback, and findings that are not mutually contaminated across unrelated rule sets.
- The metadata-first extraction model is **repo-portable**: the vision specifies WHAT to read (the `domain:` field) and the priority order; it does NOT mandate any particular folder-naming convention. A repository that does not use `<NN>.<NN>-<slug>/` subfolders can still drive Phase 0b correctly by ensuring every PE artifact declares `domain:` in its frontmatter.

### Section: § The rationale → Processing strategies → R-P10 (Action — new) (✅ done)

**Where:** Insert a new row after R-P9 in the *Processing strategies* table.

**Proposed text (essence):**

| ID | Rationale | Design implication |
|---|---|---|
| **R-P10-domain-coherent-batching** | **Multi-domain scope MUST be split or explicitly batched.** A scope resolving across ≥ 2 semantic domains is processed as N domain-coherent runs (default) or as one atomic bundle only with explicit user consent. Heterogeneous bundles undermine three guarantees: (1) approval-gate granularity — the user is forced into all-or-nothing on unrelated changes; (2) reviewer judgment — domain expertise rarely covers all domains in scope; (3) rollback granularity — a single-bundle rollback discards work across unrelated domains. The rule applies to every `/pe-meta-*` command, not just `/pe-meta-update`. Semantic domain is a **content property declared in artifact metadata** (the `domain:` YAML frontmatter field), NOT a path property — a file under `.github/prompts/00.09-pe-meta/` may target any semantic domain because pe-meta prompts are infrastructure tooling rather than domain content. | The orchestrator MUST run a deterministic domain-coherence check (Phase 0b) after Phase 0a and before Phase 1. Domain is resolved per-file via the 3-tier priority order: (1) declared `domain:` metadata (authoritative); (2) optional per-repo `pe-domain-map.yaml` path-slug heuristic (fallback for legacy or unannotated files); (3) `unknown` (final fallback, treated as a distinct domain-id). The check is never skippable. In `--mode apply`, the split proposal is a hard gate; in `--mode plan`, it is an advisory next-step list. The algorithm is repo-portable: it does not require any specific folder-naming convention. |

### Section: § The vision § Assess § Research phase (Action — extend) (✅ done)

**Where:** Existing § The vision → § Assess → § Research phase. Append one paragraph.

**Proposed text (essence):**

Phase 1 (Research) runs only after Phase 0b confirms either (a) a single-domain scope or (b) explicit consent on a multi-domain bundle. This avoids paying for cross-source research that will be discarded when the user accepts a per-domain split.

### Section: § Command families and option model § Pipeline phases and `--skip` mapping (Action — extend) (✅ done)

**Where:** Add a new row between Phase `0a` and Phase `1` in the pipeline-phases table.

**Proposed row:**

| Phase | Identifier | Purpose | `--skip` semantics |
|---|---|---|---|
| **0b** | `domain-coherence` | Deterministic domain-footprint computation against the path-prefix → domain map; produce per-domain split proposal when ≥ 2 domains in resolved scope | NOT skippable |

Add a new per-phase skip rule #7: `--skip domain-coherence` is REJECTED with CF-05 — `domain-coherence retired in v15 only via accepting a single-domain split OR by explicit bundle=accept consent`.

### Section: § Command families and option model § Option resolution rules (Action — extend) (✅ done)

**Where:** Existing six-rule list in § Option taxonomy → "Option resolution rules". Append rule #7.

**Proposed rule:**

7. **Domain-coherence gate (R-P10-domain-coherent-batching).** After Phase 0a resolves canonical options but BEFORE Phase 1 runs, the orchestrator MUST compute the domain footprint of the resolved `--scope`. When ≥ 2 domains are present: in `--mode apply`, emit a numbered split proposal and BLOCK Phase 1 until the user selects a split OR explicitly accepts the bundle with `bundle=accept`; in `--mode plan`, emit the proposal as an advisory next-step list and continue. The chosen disposition is recorded on the `Resolved invocation:` log as `bundle=single-domain` \| `bundle=accepted-bundle` \| `bundle=split-N`.

8. **Artifact-type/path consistency check (Phase 0a precondition, before rule #7 fires).** When the invoked prompt is a per-artifact prompt (name prefix `pe-meta-<artifact-type>-*`), the supplied positional `<file-path>` OR `--scope` value MUST resolve to a path under the artifact-type root encoded in the prompt name (e.g. `pe-meta-context-*` ⇒ paths under `.copilot/context/`; `pe-meta-prompt-*` ⇒ paths under `.github/prompts/`). On mismatch, REJECT with CF-05 BEFORE Phase 0b runs. The error message MUST name both the supplied artifact-type root and the expected root, and SHOULD suggest the canonically-correct prompt name. Orchestrator-level prompts (`pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`) are artifact-type-agnostic and skip this check.

### Section: § Command families and option model § Domain detection (Action — new) (✅ done)

**Where:** Insert a new subsection after § Conversational pre-parser (Phase 0a), before § Pipeline phases and `--skip` mapping.

**Required sub-sections** (full text lives in § Domain detection — metadata-first resolution of this plan):

1. **§ Artifact-type root vs. semantic domain** — establishes the conceptual distinction upfront: artifact-type root is structural and decidable from path (used for CF-05 and scope expansion); semantic domain is a content property carried in `domain:` metadata. PE infrastructure paths (`.github/prompts/00.09-pe-meta/`, `.copilot/context/00.00-prompt-engineering/`) are housekeeping groupings — their contents may target any domain.
2. **§ Eight canonical artifact-type roots** — table mapping each of the 8 roots to its scope-expansion glob. Used for `scope-source=token` resolution and for the CF-05 prompt-name/path consistency check, NOT for semantic-domain assignment.
3. **§ Domain resolution algorithm — metadata-first** — 3-tier deterministic priority order: (1) read `domain:` field from artifact frontmatter (authoritative; `domain-source=declared-metadata`); (2) when absent AND the repo ships `pe-domain-map.yaml`, apply path-prefix → domain-id mapping (`domain-source=path-heuristic`, flagged in report); (3) `unknown` (`domain-source=unknown`, per-file warning emitted; counts as a distinct domain-id for footprint purposes). Includes worked examples covering: a pe-meta prompt that declares `domain: prompt-engineering`; a pe-meta prompt that declares a different semantic domain; an unannotated file in a repo with the optional map; an unannotated file in a repo without the map.
4. **§ Per-invocation-type scope-extraction matrix** — 5-row table showing how the FILE SET is extracted for: artifact-type token, path-set (single), path-set (multi), positional `<file-path>`, no-scope default-all. Each row maps to a `scope-source=` log marker. Scope extraction is orthogonal to domain resolution — every row feeds the same metadata-first algorithm in step 3 above.
5. **§ Artifact-type/path consistency check (CF-05)** — prompt-name-prefix → expected-root table (8 entries); the CF-05 rejection rule with required error-message content; the orchestrator-level-prompts opt-out list. **CF-05 operates on artifact-type ROOT** (deterministic from path), **NOT on semantic domain**.
6. **§ Single-domain shortcut** — when every file in the resolved file set resolves to the SAME domain-id (regardless of which tier produced the resolution, regardless of invocation shape, regardless of whether the domain is `unknown`), Phase 0b emits `bundle=single-domain` and Phase 1 proceeds without prompt.
7. **§ Seed footprint vs dependency footprint — the specialized-lens branch** — defines seed footprint (domains across explicitly scoped files BEFORE `--deps` traversal) and dependency footprint (additional domains added by `--deps direct`/`full`). Decision matrix: seed=1 + deps=0 → `bundle=single-domain`; seed≥2 → `bundle=multi-domain-gated` (split proposal, R-P10); seed=1 + deps adds ≥1 → `bundle=cross-domain-deps` (ONE review against union, per-dependency-domain specialized analysis lenses, NO split because splitting would produce incomplete reviews — consumer artifacts need ALL declared dependencies present). Includes worked example using `/pe-meta-prompt-review` of an article-writing prompt with `--deps full` pulling cross-domain context.
8. **§ `--deps full` and the metadata-first payoff** — worked example showing that a positional invocation seeded with `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md --deps full` yields a footprint whose composition depends entirely on what each consumer/dependency declares in its OWN frontmatter, not on the seed file's path slug.
9. **§ Cross-repo portability** — explicit statement that the algorithm is repo-agnostic; the optional `pe-domain-map.yaml` config schema (path-prefix → domain-id list); migration guidance for repos without the convention (declare `domain:` in every PE artifact's frontmatter; the heuristic map is optional, not required).

### Section: `Resolved invocation:` log specification (Action — extend) (✅ done)

**Where:** Existing success criterion #12 in § Success criteria and the matching log spec in § Default-full invocation contract.

**Current marker set:** `breadth=… | caller=…`

**Proposed marker set:** `breadth=… | caller=… | scope-source=… | bundle=…`

Where:

- `scope-source` values are: `token` (artifact-type token like `context`), `path-set` (one or more comma-separated paths in `--scope`), `positional` (a positional `<file-path>` argument as accepted by per-artifact prompts), `default-all` (no scope token at all — resolves to `--scope=all` per R-P8). This marker exists so the audit log records HOW scope was specified, which is essential for diagnosing whether Phase 0b was reached via positional invocation, default-all expansion, or explicit scope.
- `bundle` values are: `single-domain`, `multi-domain` (Phase 0b detected but caller chose to proceed under apply gate — gated), `accepted-bundle` (explicit consent given), `split-N` (Phase 0b detected and caller chose split N of the proposal).

---

## ⚙️ Domain detection — metadata-first resolution

### Artifact-type root vs. semantic domain

**Two distinct concepts; conflating them is the root cause of the prior path-walk design failing.**

| Concept | Source | Decidable from path alone? | What it drives |
|---|---|---|---|
| **Artifact-type root** | The structural prefix of the file path matched against the 8 canonical roots listed below | **Yes** — deterministic | Scope expansion when `--scope <token>` is used; CF-05 prompt-name/path consistency check |
| **Semantic domain** | The `domain:` field declared in the artifact's YAML frontmatter | **No** — declared, not derived | Phase 0b footprint and bundle gating |

**Why the distinction matters.** Path slugs like `00.09-pe-meta/`, `00.00-prompt-engineering/`, `pe-granular/` denote *housekeeping/infrastructure* groupings. The prompts under `.github/prompts/00.09-pe-meta/` are PE customization tooling — they can target ANY semantic domain (their CONTENT determines what domain they belong to, not their location). The same is true of templates, skills, and prompt-snippets that ship with the PE system. Path slug alone CANNOT determine semantic domain.

A pe-meta prompt that designs agents for the `article-writing` domain may legitimately live under `.github/prompts/00.09-pe-meta/` and declare `domain: article-writing` in its frontmatter. A path-walk algorithm would misclassify it as `pe-meta`; the metadata-first algorithm reads the truth from the file itself.

### Eight canonical artifact-type roots (for scope expansion and CF-05)

These roots are used for (a) expanding `--scope <token>` to a file set and (b) the CF-05 prompt-name/path consistency check. They are NOT a semantic-domain partitioning.

| # | Artifact-type root | Scope-expansion glob |
|---|---|---|
| 1 | `.copilot/context/` | `.copilot/context/**/*.md` |
| 2 | `.github/prompts/` | `.github/prompts/**/*.prompt.md` |
| 3 | `.github/instructions/` | `.github/instructions/*.instructions.md` |
| 4 | `.github/agents/` | `.github/agents/**/*.agent.md` |
| 5 | `.github/templates/` | `.github/templates/**/*.md` |
| 6 | `.github/skills/` | `.github/skills/*/SKILL.md` |
| 7 | `.github/hooks/` | `.github/hooks/*` |
| 8 | `.github/prompt-snippets/` | `.github/prompt-snippets/**/*.md` |

### Domain resolution algorithm — metadata-first (3 tiers, deterministic)

Applied **per file** to every artifact in the resolved scope (and every file pulled in by `--deps`).

1. **Tier 1 — declared metadata (authoritative).** Open the artifact's YAML frontmatter and read the `domain:` field. When present, the field value is the domain-id. Record `domain-source=declared-metadata`. Stop.
2. **Tier 2 — optional per-repo path-slug heuristic (fallback).** When `domain:` is absent AND the repository root contains `pe-domain-map.yaml` (or equivalent config registered with the orchestrator), apply path-prefix → domain-id mappings from that map. Record `domain-source=path-heuristic`. The presence of any `domain-source=path-heuristic` assignment in the footprint MUST be flagged in the Phase 8 report ("N files lacked declared `domain:` and were classified by heuristic; consider adding `domain:` to their frontmatter"). Stop.
3. **Tier 3 — `unknown` (final fallback).** When neither tier resolves, assign domain-id `unknown` and emit a per-file warning. `unknown` is a real domain-id for footprint purposes (3 files all `unknown` = single-domain footprint; 1 `unknown` + 1 `prompt-engineering` = 2-domain footprint, gate fires).

**Worked examples.**

| Artifact path | `domain:` frontmatter | `pe-domain-map.yaml`? | Resolved domain-id | `domain-source` |
|---|---|---|---|---|
| `.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md` | `prompt-engineering` | n/a | `prompt-engineering` | `declared-metadata` |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md` (declared domain matches housekeeping slug) | `prompt-engineering` | n/a | `prompt-engineering` | `declared-metadata` |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md` (designs an agent for article-writing) | `article-writing` | n/a | `article-writing` | `declared-metadata` |
| `.github/instructions/legacy-instruction.instructions.md` (older file, no `domain:` declared) | absent | yes; map says `.github/instructions/legacy-* → legacy` | `legacy` | `path-heuristic` (flagged in report) |
| `.github/instructions/legacy-instruction.instructions.md` (same file, different repo without the map) | absent | no | `unknown` | `unknown` (per-file warning) |
| `articles/foo.md` (hypothetical other-repo layout) | `articles` | yes; map says `articles/ → articles` | `articles` | `path-heuristic` |

**Repo-portability property.** The algorithm makes no assumption about subfolder naming. A repo that doesn't use `<NN>.<NN>-<slug>/` and doesn't ship `pe-domain-map.yaml` still works correctly — every file declaring `domain:` in its frontmatter is resolved deterministically at Tier 1, and files without the declaration fall to `unknown` (recoverable by adding the field).

### Per-invocation-type scope-extraction matrix

Scope extraction (producing the FILE SET for Phase 0b) is **orthogonal** to domain resolution (producing the DOMAIN-ID per file). Every row below feeds the same 3-tier metadata-first algorithm above.

| Invocation shape | Example | `scope-source` marker | How files are resolved |
|---|---|---|---|
| **Artifact-type token** | `/pe-meta-update --scope context` | `token` | Expand token to all files under the matching artifact-type root (per the 8-root scope-expansion table) |
| **Path-set (single)** | `/pe-meta-update --scope .copilot/context/00.00-prompt-engineering/` | `path-set` | Glob the single path |
| **Path-set (multi)** | `/pe-meta-update --scope .copilot/context/00.00-prompt-engineering/,.copilot/context/01.00-article-writing/` | `path-set` | Glob each comma-separated path; union the file set |
| **Positional `<file-path>`** | `/pe-meta-context-review '.copilot/context/00.00-prompt-engineering/01.07-critical-rules-priority-matrix.md' --deps full` | `positional` | The positional path IS the file (or with `--deps`, the file + its dependency set) |
| **No scope (default-all)** | `/pe-meta-update --mode plan` | `default-all` | Per R-P8 default-full, expand to every file under every artifact-type root the invoked command supports |

**Phase 0b applies identically across all five rows.** After the file set is resolved, each file's `domain:` frontmatter (or fallback) is read; the resulting domain-id set is the footprint; the gate behavior is decided by footprint size and `--mode`.

Per-artifact prompts (`pe-meta-context-review`, `pe-meta-prompt-review`, etc.) typically use the **positional** row when invoked directly; a single-file positional invocation produces a one-file file set whose footprint is whatever that single file declares (Tier 1) or `unknown` (Tier 3). With `--deps full`, the traversal set MAY be multi-domain because consumers/dependencies declare their own `domain:` independently.

### Artifact-type/path consistency check (CF-05, Phase 0a precondition)

**This check operates on artifact-type ROOT (deterministic from path), NOT on semantic domain.**

Per-artifact prompts have a name-encoded artifact-type expectation:

| Prompt-name prefix | Expected artifact-type root |
|---|---|
| `pe-meta-context-*` | `.copilot/context/` |
| `pe-meta-prompt-*` | `.github/prompts/` |
| `pe-meta-instruction-*` | `.github/instructions/` |
| `pe-meta-agent-*` | `.github/agents/` |
| `pe-meta-template-*` | `.github/templates/` |
| `pe-meta-skill-*` | `.github/skills/` |
| `pe-meta-hook-*` | `.github/hooks/` |
| `pe-meta-snippet-*` | `.github/prompt-snippets/` |

**Rule.** When the positional path's artifact-type root does NOT match the expected root for the invoked prompt's prefix, Phase 0a MUST reject the invocation with CF-05 BEFORE Phase 0b runs. The error message MUST identify both the supplied artifact-type root and the expected root, and SHOULD suggest the canonically-correct prompt name.

**Worked rejection example.** `/pe-meta-context-review '.github\prompts\00.09-pe-meta\pe-meta-agent-design.prompt.md' --deps full` is REJECTED with CF-05: supplied path is under `.github/prompts/`, but `pe-meta-context-review` expects `.copilot/context/`. Canonical replacement: `/pe-meta-prompt-review '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --deps full`.

**Orchestrator-level prompts** (`pe-meta-update`, `pe-meta-review`, `pe-meta-create-update`, `pe-meta-design`, `pe-meta-scheduled-review`, `pe-meta-release-monitor`, `pe-meta-adherence`) are artifact-type-agnostic and skip this check.

### Single-domain shortcut

When every file in the resolved file set resolves to the SAME domain-id (regardless of which tier produced the resolution, regardless of invocation shape, regardless of whether the domain is `unknown`), Phase 0b emits `bundle=single-domain` in the log and Phase 1 proceeds without any prompt.

### Seed footprint vs dependency footprint — the specialized-lens branch

Phase 0b computes the domain footprint **separately for the seed scope and for the dependency closure**, then combines them through the following decision matrix:

| Seed footprint | Deps footprint (additional domains beyond seed) | Bundle disposition | Phase 1 behavior |
|---|---|---|---|
| 1 domain | 0 (same single domain, or `--deps off`) | `bundle=single-domain` | Proceed without prompt |
| ≥ 2 domains | any | `bundle=multi-domain-gated` | Propose per-domain split (R-P10) |
| 1 domain | ≥ 1 additional domain (from `--deps direct`/`full`) | `bundle=cross-domain-deps` | Proceed as ONE review against the union, with per-dependency-domain specialized analysis lenses |

**Definitions.**

- **Seed footprint** = set of distinct `domain:` values across files explicitly scoped by the invocation BEFORE any `--deps` traversal runs:
  - positional invocation → seed = the positional path(s) (single file or single token-expansion set)
  - `--scope <artifact-type-token>` → seed = all files under that artifact-type root (e.g. `--scope context` → all `.copilot/context/**`)
  - `--scope <path-set>` → seed = the listed paths
  - no `--scope` → seed = all artifacts under all eight canonical artifact-type roots
- **Dependency footprint** = set of distinct `domain:` values across files added by `--deps direct` (one hop) or `--deps full` (transitive closure) traversal from the seed.
- **Additional domain** = a domain that appears in the dependency footprint but NOT in the seed footprint.

**Why `bundle=cross-domain-deps` is not a split.** A consumer artifact NEEDS all its declared dependencies to be reviewable. Splitting a single-seed cross-domain-deps invocation by dep-domain would produce **incomplete reviews**: either each split reviews the seed against a subset of its context (the seed cannot be evaluated correctly because rules it inherits are missing), or each split drops the seed (the user's actual review request is silently ignored). Neither outcome is acceptable. The right behavior is to keep the union together and apply **per-dependency-domain specialized analysis lenses** during Phase 2–4 audits.

**What "specialized analysis lenses" means concretely.** Phase 2–4 audits run ONCE on the seed, but the rule-adherence and context-comparison checks within each audit are evaluated **per dependency-domain**, using domain-specific expectations:

- When comparing the seed against `article-writing` dependencies → exercise Microsoft Writing Style Guide voice rules, Diátaxis type validation, accessibility (alt text, inclusive language), readability targets, emoji-H2 rule.
- When comparing the seed against `prompt-engineering` dependencies → exercise the PE rationale set (R-P1…R-P10), boundary-actionability redteam pattern, three-layer rule architecture, tool-restriction-as-strict-allowlist, dimension scope contract.
- When comparing the seed against `learning-hub` dependencies → exercise dual-metadata system (top YAML / bottom HTML comment), reference-classification emoji markers, kebab-case naming.

The Phase 8 report MUST section findings **per dependency-domain** (one subsection per distinct dep-domain) so reviewers can see which lens produced which findings and trace each finding back to the rules that triggered it.

**Worked example — `bundle=cross-domain-deps`.**

`/pe-meta-prompt-review '.github/prompts/01.00-article-writing/article-review-for-consistency-gaps-and-extensions.prompt.md' --deps full`

1. **Seed footprint computation.** The positional path is one file. Open it, read `domain:` → `article-writing`. **Seed footprint = { article-writing }**.
2. **Deps full closure.** Walk the prompt's references, file links, and `#file:` snippet inclusions. Closure yields:
   - 6 files under `.copilot/context/01.00-article-writing/` → all declare `domain: article-writing`
   - 4 files under `.copilot/context/00.00-prompt-engineering/` → all declare `domain: prompt-engineering`
   - 2 instruction files (`article-writing.instructions.md`, `documentation.instructions.md`) → declare `domain: article-writing`
3. **Deps footprint = { article-writing, prompt-engineering }**. Additional domains beyond seed = `{ prompt-engineering }` (one).
4. **Decision matrix lookup.** seed = 1, deps adds ≥ 1 → `bundle=cross-domain-deps`. Phase 1 proceeds against the union without prompting for a split.
5. **Phase 8 report sections findings per dep-domain.** One subsection "Findings vs `article-writing` context" applying MWSG/Diátaxis lenses; another "Findings vs `prompt-engineering` context" applying R-P* and boundary-actionability lenses.

**Contrast with `bundle=multi-domain-gated`.** The same closure under `--scope context` (no positional seed) would produce **seed footprint = { article-writing, prompt-engineering, … }** because the user explicitly asked for the whole context-files artifact-type root. There R-P10 fires — splitting is appropriate because each split is independently meaningful (an article-writing review of the article-writing context subset; a PE review of the PE context subset).

**Why R-P10 still applies.** R-P10 governs the seed-multi-domain case, not the seed-single-domain case. The new `bundle=cross-domain-deps` branch is NOT a bypass of R-P10 — it's a different case that R-P10 was never the right tool for. R-P10's rationale (per-domain reviewer attention, scoped rollback boundaries, single-domain context windows) all assume the user's intent spans multiple domains. When the user named ONE artifact, the cross-domain deps are infrastructure the seed requires, not separate review targets.

### `--deps full` and the metadata-first payoff

This is the case where path-based domain extraction silently misclassifies entire runs and the metadata-first model pays off.

**Worked example.** `/pe-meta-update '.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md' --dim context-quality-lifecycle --deps full`:

1. **Phase 0a.** Orchestrator-level prompt (`pe-meta-update`), so CF-05 prompt-name/path check is skipped. `--dim context-quality-lifecycle` parsed and validated against the dimension-group enumeration.
2. **Phase 0b scope extraction.** Positional path → file set = { seed } ∪ deps-full-closure(seed). Suppose closure yields 12 files spanning `.github/prompts/00.09-pe-meta/`, `.copilot/context/00.00-prompt-engineering/`, `.copilot/context/01.00-article-writing/`, `.github/skills/pe-context-file-creation/`.
3. **Phase 0b domain resolution (per file, metadata-first).** Each of the 12 files is opened and its `domain:` field is read:
   - 8 files declare `domain: prompt-engineering`
   - 3 files declare `domain: article-writing`
   - 1 file has no `domain:` field and the repo has no `pe-domain-map.yaml` → `unknown`
4. **Footprint = 3 domains** (`prompt-engineering`, `article-writing`, `unknown`). Gate fires per R-P10.
5. **Phase 0b output.** Numbered split proposal showing 3 canonical per-domain invocations. `bundle=multi-domain` recorded on the log. User selects split 1 OR `bundle=accept`.

**Why path-walk fails this case.** A path-walk algorithm would read the seed file's path (`.github/prompts/00.09-pe-meta/`), derive `pe-meta` as the domain, and either (a) silently classify the entire 12-file traversal as `pe-meta` (false-negative; gate doesn't fire on a genuinely multi-domain bundle) or (b) classify each file by its own path-walk and produce a footprint based on housekeeping slugs (`pe-meta`, `prompt-engineering`, `article-writing`, `pe-context-file-creation`) that doesn't match what the FILES actually claim to be about.

**Note on `--dim` orthogonality.** `--dim context-quality-lifecycle` filters which dimensions Phase 2–4 audit — it does NOT declare or override the semantic domain of any artifact. Domain footprint is computed entirely from per-file `domain:` metadata.

### Cross-repo portability

The vision specifies WHAT to read (the `domain:` field) and HOW to fall back (optional path-slug map, then `unknown`). It does NOT mandate any folder-naming convention.

**Optional config schema** (`pe-domain-map.yaml` at repo root):

```yaml
# Per-repo path-slug heuristic for files lacking declared `domain:` metadata.
# Used at Tier 2 of the domain resolution algorithm. Optional.
mappings:
  - path-prefix: .copilot/context/00.00-prompt-engineering/
    domain: prompt-engineering
  - path-prefix: .copilot/context/01.00-article-writing/
    domain: article-writing
  - path-prefix: .github/prompts/00.09-pe-meta/
    domain: prompt-engineering    # Note: housekeeping slug ≠ semantic domain
```

**Migration guidance for repos adopting v15:** the recommended path is to declare `domain:` in every PE artifact's frontmatter (so Tier 1 always resolves). Shipping `pe-domain-map.yaml` is a transitional convenience for legacy/unannotated files only; it is NOT required for the algorithm to work.

---

## 🧭 Phase 0b — Domain coherence check (insertion point)

| Phase order | Phase | Mutates? | Runs always? |
|---|---|---|---|
| 0 | Inventory + dependency graph | No | Yes (not skippable) |
| 0a | Conversational pre-parser | No (only normalizes input) | When non-canonical input present |
| **0b** | **Domain coherence check** | **No (only proposes splits)** | **Yes (not skippable)** |
| 1 | Source research | No | Default; skippable only when derived `breadth ≠ full` |
| 1.5 | Organizational pass | No | When `breadth=full` AND scope > single file |
| 2–4 | Audits | No | Default; per-phase skippable |
| 5 | Approval | No | `--mode apply` only |
| 6 | Apply | Yes | `--mode apply` only |
| 7 | Regression | No | After Phase 6 |
| 8 | Report | No | Always |

**Interaction with Phase 1.5.** Phase 0b runs *before* Phase 1.5. When the user accepts a per-domain split (`bundle=multi-domain-gated` outcome), the N resulting runs each have a single-domain scope and Phase 1.5 still runs per-run (since single-domain scope is still "broader than a single file"). When the user accepts the bundle, Phase 1.5 runs once across all domains as today. When `bundle=cross-domain-deps` (single-seed cross-domain-deps), no split is proposed: Phase 1.5 runs once across the union, and Phase 2–4 audits apply per-dependency-domain specialized lenses (see § Seed footprint vs dependency footprint).

---

## 🏗️ Section-by-section changes

| Section in v14 | Change | Source authority |
|---|---|---|
| Frontmatter `scope.covers:` | Add 7 new entries (see exit criteria) | This plan |
| Frontmatter `rationales:` | Add `R-P10-domain-coherent-batching` | This plan |
| Frontmatter `boundaries:` | Add (a) Phase 0b non-skippability + invocation-shape-agnostic clause, (b) artifact-type/path consistency CF-05 rule | This plan |
| § The goal → new § Domain-coherent batching | INSERT after § Default-full invocation contract | This plan |
| § The rationale → Processing strategies table | INSERT R-P10 row after R-P9 | This plan |
| § The vision → Assess → Research phase | APPEND one-paragraph note about Phase 0b precondition | This plan |
| § Command families and option model → Option resolution rules | APPEND rule #7 (domain-coherence gate) AND rule #8 (artifact-type/path consistency precondition) | This plan |
| § Command families and option model → new § Domain detection | INSERT between Phase 0a and Pipeline-phases sections, with **nine** sub-sections: (a) artifact-type root vs. semantic domain, (b) eight canonical artifact-type roots (for scope expansion + CF-05), (c) domain resolution algorithm — metadata-first (3 tiers), (d) per-invocation-type scope-extraction matrix, (e) artifact-type/path consistency check (CF-05), (f) single-domain shortcut, (g) **seed footprint vs dependency footprint — the specialized-lens branch**, (h) `--deps full` and the metadata-first payoff, (i) cross-repo portability | This plan |
| § Command families and option model → Pipeline phases / `--skip` mapping table | INSERT Phase 0b row + per-phase rule #7 | This plan |
| § Success criteria → #12 (`Resolved invocation:` log) | EXTEND marker spec with `scope-source=…` AND `bundle=…` | This plan |

---

## ⚠️ Boundaries and risks

| Concern | Mitigation |
|---|---|
| Phase 0b adds one more user-prompt step on every multi-domain manual invocation | The gate is bypassable with `bundle=accept` on the SAME line of the invocation — single keystroke for callers who genuinely want the bundle |
| Files in legacy repos may lack the `domain:` frontmatter field, causing many `domain-source=path-heuristic` or `domain-source=unknown` assignments | Phase 8 report explicitly lists every file resolved at Tier 2 or Tier 3, surfacing the gap. The migration path is incremental: add `domain:` to frontmatter file-by-file. The optional `pe-domain-map.yaml` covers the transition window |
| `pe-domain-map.yaml` is repo-specific and may diverge between teams sharing PE artifacts | Each repo's map is local; the algorithm doesn't require cross-repo consistency. When sharing artifacts via copy, the receiving repo applies its own map (or relies on declared `domain:` which travels with the file) |
| Heterogeneity threshold is binary (1 domain vs ≥ 2) — no gradient | Intentional: a binary gate is deterministic and predictable. A gradient invites silent narrowing. The split proposal already gives the user fine control if they want one-domain-at-a-time |
| Bundle execution still allowed (`bundle=accept`) — does not eliminate the original problem | By design — explicit consent satisfies R-P8's predictability contract; the gate prevents *silent* heterogeneous batching, not all heterogeneous batching |
| Phase 0b interacts with `--mode plan` differently than `--mode apply` | Documented explicitly: plan = advisory, apply = hard gate. Echoed in the `Resolved invocation:` log so the disposition is auditable |
| The rule may be over-restrictive for trivial cross-domain changes (e.g. fixing a broken cross-reference) | Trivial cases naturally resolve to single-file `--scope` paths, which fall under the single-domain shortcut. The gate is only triggered when the user (or default-full) explicitly asked for broad scope |
| Per-artifact prompts use a positional `<file-path>` (not `--scope`), so the Phase 0b extraction step differs by invocation shape | The per-invocation-type scope-extraction matrix in § Domain detection covers all five shapes (token, path-set single, path-set multi, positional, no-scope default-all) with the same downstream gate behavior. The `scope-source=…` marker on the `Resolved invocation:` log records which shape was used, so audit trails distinguish positional invocations from token-based ones |
| `--deps full` from a single positional seed may produce a footprint that doesn't match the seed file's own declared domain | Intentional and correct: consumers/dependencies declare their OWN `domain:`; the footprint reflects what the FILES claim, not what the seed assumes. Phase 0b makes this visible by listing each file with its `domain-source` |
| Splitting a single-seed cross-domain-deps invocation by dep-domain would produce **incomplete reviews** (the seed needs ALL its declared dependencies to be reviewable) | The new `bundle=cross-domain-deps` marker keeps the union together as ONE review and applies per-dependency-domain specialized analysis lenses in Phase 2–4. The Phase 8 report sections findings per dep-domain. Splitting is reserved for seed-multi-domain invocations where each split is independently meaningful |
| Risk of conflating the new branch with R-P10 (people thinking specialized-lens "bypasses" the gate) | R-P10 governs the seed-multi-domain case ONLY. The specialized-lens branch handles a case R-P10 was never the right tool for (the user named ONE artifact; deps are infrastructure it requires, not separate review targets). Phase 0b explicitly computes seed footprint and deps footprint **separately** so the disposition can be derived deterministically from the decision matrix |
| Per-dependency-domain specialized lenses could be misapplied (e.g. running article-writing readability checks on a prompt-engineering rule file) | The lens is attached to the COMPARISON, not the seed: when comparing seed-vs-context, the rules exercised are the dep-context's domain rules. The seed itself is evaluated against its OWN domain's rules. Phase 8 report makes this explicit by labeling each finding with the lens that produced it |
| `unknown` may collide with a real domain-id named `unknown` in some repo | The orchestrator MUST reserve `unknown` as a system-level domain-id and reject any `pe-domain-map.yaml` or `domain:` value that uses the literal `unknown` (CF-05 at config-load time) |
| Artifact-type/path mismatch (e.g. `/pe-meta-context-review` invoked with a `.github/prompts/` path) is a separate concern from Phase 0b but easy to conflate | The check is a Phase 0a PRECONDITION that runs BEFORE Phase 0b — rejected with CF-05 with a suggested canonical replacement. It does NOT pollute the bundle-gate logic. CF-05 operates on artifact-type ROOT (deterministic from path), NOT on semantic domain. Orchestrator-level prompts (`pe-meta-update`, `pe-meta-review`, etc.) are artifact-type-agnostic and skip this check entirely |

---

## 📚 References

**Internal (workspace):**

- [overview.md](overview.md) — Parent issue analysis (Phase 0b motivation)
- [20260529.01-vision.v14.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.md) — Current vision being amended
- [20260529.01-vision.v14.changelog.md](../../../../../../06.00-idea/self-updating-prompt-engineering/old/20260529.01-vision.v14.changelog.md) — Changelog format precedent
- [20260525.01-context-fullcheck/overview.md](../20260525.01-context-fullcheck/overview.md) — Plan 01.03 reservation context
- [02-pe-meta-update-not-processing-full-context-review/01-vision-update-plan.md](../02-pe-meta-update-not-processing-full-context-review/01-vision-update-plan.md) — Sibling plan format precedent
- [20260525.03-staleness-review/overview.md](../overview.md) — Originating staleness review (R-P8 motivation)

**Sibling plans (this issue tree):**

- [02-usecases-update-plan.md](02-usecases-update-plan.md) — Use-case catalog updates for R-P10
- [03-pe-meta-update-plan.md](03-pe-meta-update-plan.md) — Orchestrator and per-artifact prompt updates for Phase 0b
