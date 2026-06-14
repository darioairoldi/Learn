---
title: "Issue Analysis: PE-meta invocation parameters and vision document structural confusion"
author: "Dario Airoldi"
date: "2026-06-01"
categories: [issue, analysis, prompt-engineering, vision]
description: "Analysis and resolution of the structural confusion in vision.v15.md (parallel principle taxonomies, unprioritized scope, opaque R-X# codes, goal-section overload) and of the under-specified dim/scope/deps/mode invocation parameters."
draft: true
---

# Issue Analysis — Vision document structural confusion + PE-meta invocation parameter clarity

**Issue Title:** PE-meta invocation parameters (`dim`/`scope`/`deps`/`mode`) and vision document structural confusion

**Date Reported:** 2026-05-27
**Date Analyzed:** 2026-06-01
**Reporter:** Dario Airoldi
**Status:** Resolved (foundation complete; 2 separate follow-ups tracked)
**Severity:** High
**Component:** [06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md)
**Framework:** PE artifact system v15

---

## Table of Contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

### Brief description

The vision document `20260531.01-vision.md` had grown two intertwined problems that blocked safe invariant evolution and made the document hard to read for new builders/reviewers:

1. **Structural confusion in the vision document itself**
   - Three parallel principle taxonomies (frontmatter `principles:`, frontmatter `rationales:`, body section *The rationale*) with no canonical owner.
   - Flat `scope.covers:` list with no priority distinction — load-bearing invariants sat next to aspirational/unimplemented items (e.g., *Progressive learning via structured outcome logs*).
   - A `rationales:` frontmatter block that duplicated body content.
   - Opaque rationale codes (`R-S1`, `R-P4`, `R-G1`, …) that forced cross-referencing for every read.
   - The Goal section had absorbed operational mechanisms (default-full invocation contract, domain-coherent batching, goal-trio↔use-case mapping) that belong in dedicated sections.
   - No clear distinction between `# goal` / `# description` and between *rationale* / *principle*.

2. **`dim` / `scope` / `deps` / `mode` parameters were under-specified**
   - Mentioned across body command-family tables but lacking a single, canonical definition with role, allowed values, and per-command applicability.
   - Could not be cited unambiguously from use-case documents.

### Impact

- **Invariant evolution unsafe** — frontmatter priority discipline (P0 ⇒ version bump) only applied to principles; flat `scope.covers:` allowed silent demotion/promotion of load-bearing items.
- **Aspirational items elevated to invariant** — *Progressive learning via outcome logs* was scoped as equal-weight to the self-update architecture and the autonomy gradient despite being unimplemented.
- **High reading cost** — opaque `R-X#` codes required cross-reference for every mention; ~150 occurrences in the body.
- **Reviewer ambiguity** — operational mechanisms living inside Goal blurred *what the system promises* (Goal) from *how it does it* (Command families, Governance).

---

## 🔍 Context information

### Environment

| Item | Value |
|---|---|
| Repository | `Learn` |
| Vision file | `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md` |
| Vision size | ~1 821 lines |
| Schema authority | `.github/instructions/vision-frontmatter.instructions.md` |
| Use-case catalog | `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md` |
| Vision version (pre-fix) | v15.0.0 (no version bump applied; reshape is mechanical) |

### Files touched in this session

| File | Change kind |
|---|---|
| [vision-frontmatter.instructions.md](../../../../../../.github/instructions/vision-frontmatter.instructions.md) | Schema authority updated to v1.3.0 |
| [20260531.01-vision.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) | Frontmatter restructured + body R-code rename |
| use-cases README | Pending (todo #9 — receives goal-trio↔use-case mapping) |

### Symptoms observed

- `principles:` frontmatter, `rationales:` frontmatter, body table § *The rationale* all held overlapping but non-identical lists.
- `scope.covers:` entry for *Progressive learning via structured outcome logs* present despite no implementation.
- Body lines such as line 411 — *"R-P8 (default-full) and R-P9 (minimal surface) together produce …"* — required two lookups to parse.
- Goal section line ~268 (*Default-full invocation contract*), line 291 (*Domain-coherent batching*), line ~435 (*Goal-trio↔use-case mapping*) all sit inside `## 💡 The goal` rather than in their natural sections.

---

## 🔬 Analysis

### Root cause analysis

| # | Root cause | Manifestation |
|---|---|---|
| A | Three parallel principle taxonomies with no canonical owner | `principles:` (prescriptive), `rationales:` (descriptive WHYs), body § *The rationale* (descriptive WHYs again with R-codes) — drift inevitable |
| B | Flat `scope.covers:` with no priority field | Cannot distinguish P0 invariant from aspirational item; *Progressive learning* sat at equal weight to *self-update architecture* |
| C | `rationales:` block in frontmatter duplicated the body | Two sources of truth for the same content; mechanical inconsistency over time |
| D | Opaque ID prefix `R-X#-readable-suffix` | Reader must memorize the prefix taxonomy; cross-reference cost per occurrence |
| E | Goal section absorbed operational mechanisms | Goal should state *what the system promises*; *how* belongs in Command families, Governance, or the use-case catalog |
| F | No two-tier model linking principles to body rationales | `relies_on` cross-ref missing; principles felt disconnected from the rationale catalogue |

### Why this was blocking

The vision document is the **single load-bearing artifact** for the PE self-update system. Every downstream artifact (instructions, prompts, agents, skills, context files) ultimately defers to it. Without a priority-stratified `scope.covers:` and a canonical principles block:

- A reviewer asked to validate a vision amendment cannot tell which items trigger a version bump.
- An autonomous agent scoping a `/pe-meta-update --mode plan` cannot decide which items are negotiable.
- Aspirational scope creep is silently absorbed as load-bearing.

### Affected workflows

- `/pe-meta-review` over the vision document — could not classify diffs by impact tier.
- `/pe-meta-update` planning — could not detect P0 amendments mechanically.
- Use-case authoring — could not cite vision principles unambiguously without `R-X#` lookup.
- Vision amendment plans — `vision-amendment.instructions.md` discipline could not be applied because everything looked equal-weight.

---

## 🔄 Reproduction steps

1. Open `06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md`.
2. Read the YAML frontmatter — observe three blocks: `principles:`, `rationales:`, and the body § *The rationale* tables.
3. Search the body for `R-S1` — must scroll to body § *The rationale* table to learn it means *Metadata-driven automation*.
4. Inspect `scope.covers:` — observe that *Progressive learning via structured outcome logs* sits next to *Self-update architecture* with no priority distinction.
5. Open `## 💡 The goal` — observe subsections *Default-full invocation contract*, *Domain-coherent batching*, *Goal-trio↔use-case mapping* embedded inside Goal.
6. Attempt to apply `vision-amendment.instructions.md` discipline — find no priority tags to drive scope expansion detection.

### Affected code locations

| Location | Issue |
|---|---|
| Vision frontmatter `principles:` | First parallel taxonomy |
| Vision frontmatter `rationales:` | Second parallel taxonomy (duplicates body) |
| Vision body § *The rationale* (lines ~451–574) | Third parallel taxonomy with R-X# codes |
| Vision frontmatter `scope.covers:` | Flat list, no priority field |
| Vision body lines 250, 357–411, 451, 472–574, 647–1140 | ~150 R-X# code references requiring rename |
| Vision body lines ~268, 291, 435 | Goal-section overload (3 misplaced subsections) |

---

## ✅ Solution implemented

### Fix overview

A two-tier model was adopted:

- **Principles** (prescriptive invariants): live in frontmatter `principles:`, priority-tagged, optional inline `rationale:` and optional `relies_on:` cross-refs.
- **Capabilities / rationales** (descriptive WHYs): live in the body § *The rationale*, kebab-case readable IDs, no R-X# prefix.

Connection: `relies_on:` on each principle points at one or more body rationale IDs.

The frontmatter `rationales:` block was retired (its content was duplicating the body).

### Code changes

#### 1. Schema authority — `.github/instructions/vision-frontmatter.instructions.md` (v1.3.0)

- Added **Scope Priority Block** schema: each `scope.covers` entry is now `{id, priority, item}`.
  - `P0` (3–7 band; removal triggers vision version bump).
  - `P1` (load-bearing; changelog entry required).
  - `P2` (operational; free to change).
  - `aspirational` (cannot be cited as load-bearing; documents future intent only).
- Expanded `principles:` schema — added optional `rationale:` and optional `relies_on:` fields.
- Added the **Readable ID rule**: kebab-case identifiers; the `R-X#-readable-suffix` form is no longer permitted within a single document.
- Retired the top-level `rationales:` block.
- Added full Quality Checklist sections per block.

#### 2. Vision frontmatter restructure — `20260531.01-vision.md`

- `last_updated: "2026-06-01"`.
- `description:` tightened from ~500 to ~120 words; lifted high-level design principles (metadata-first 3-tier domain resolution, seed-vs-dependency footprint distinction, autonomy gradient and risk-calibrated governance, supported command patterns) above implementation details.
- `scope.covers:` restructured into a flat list of 38 entries:
  - **7 P0**: `self-update-architecture`, `autonomy-gradient-governance`, `design-review-parity`, `source-grounded-staleness-resolution`, `portable-packaging`, `metadata-contracts`, `structural-separation`.
  - **12 P1** (load-bearing operational).
  - **18 P2** (operational).
  - **1 aspirational**: `progressive-learning-outcome-logs` (demoted from de-facto P0).
- `boundaries:` 13 flat strings (kept flat by design).
- `rationales:` block **deleted**.
- `principles:` 20 entries with `relies_on:` referencing body kebab-case IDs:
  - **7 P0**: `staleness-avoidance-first`, `rules-rationales-examples-separable`, `portable-by-design`, `command-family-agnostic`, `invocation-shape-agnostic`, `single-source-of-truth`, `minimal-canonical-surface`.
  - **6 P1**.
  - **7 P2**.

#### 3. Vision body R-code rename

27 prefixed IDs renamed to kebab-case, plus 9 bare-form references rewritten, plus the *Terminology note* on the ID convention itself rewritten. ~150 substitutions total. Zero `R-X#` references remain in the body.

| Domain | Sample renames |
|---|---|
| LLM capabilities (L) | `R-L1-llm-reasoning` → `llm-reasoning`, `R-L4-external-knowledge` → `external-knowledge` |
| Processing (P) | `R-P4-structural-separation` → `structural-separation`, `R-P10-domain-coherent-batching` → `domain-coherent-batching` |
| System (S) | `R-S1-metadata-driven` → `metadata-driven`, `R-S10-quality-propagation` → `quality-propagation` |
| Governance (G) | `R-G1-autonomy-gradient` → `autonomy-gradient`, `R-G3-progressive-learning` → `progressive-learning` |

See the [appendix](#-appendix) for the full rename map.

### Solution features

- **Single source of truth** for each rationale — body owns the description; frontmatter principles cross-reference via `relies_on:`.
- **Priority-stratified scope** — vision amendment discipline now mechanically applies.
- **Aspirational quarantine** — `aspirational` tier prevents silent promotion to load-bearing.
- **Self-documenting references** — kebab-case IDs eliminate cross-reference lookups.
- **No version bump** — reshape is classified as mechanical (no semantic change), consistent with the instruction file's rule for principles-block declaration and scope-restructure.

---

## 📚 Additional information

### Pending items (4 mechanical edits)

| # | Item | Notes |
|---|---|---|
| 6 | Add `**Priority: P0**` / `P1` / `P2` line under each of the 20 body principle headings | Headings sit ~lines 904–1140; aligns body with frontmatter priority |
| 7 | Move `### Default-full invocation contract` out of `## 💡 The goal` into `## 🎛️ Command families and option model`; leave a one-line forward stub | Mechanism, not promise |
| 8 | Move `### Domain-coherent batching` (line 291) into Command families; leave forward stub | Same rationale |
| 9 | Move `### Goal-trio↔use-case mapping` (~line 435) into the use-cases [README](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md); leave forward stub | Catalogue belongs with the catalogue |

### `dim` / `scope` / `deps` / `mode` parameter clarity — separate follow-up

The second half of the original issue (parameter definitions) is **not yet addressed**. Recommended next step: a dedicated subsection in `## 🎛️ Command families and option model` that defines each of the seven canonical parameters with role, value shape, applicability matrix, and Phase 0a pre-parser hooks. Today these parameters are scattered across body tables (`--mode`, `--scope`, `--source`, `--dim`, `--start`/`--end`, `--deps`, `--skip`) — discoverable but not single-source.

Suggested table layout:

| Parameter | Role | Value shape | Applies to | Default | Default-full semantics |
|---|---|---|---|---|---|
| `--mode` | mutation posture | `plan`/`apply`/`audit` | all `/pe-meta-*` | `plan` | full investigation, no apply |
| `--scope` | artifact selection | artifact-type token OR set of folders/files | all | resolved by Phase 0a | every file under every supported artifact-type root |
| `--dim` | assessment-breadth selection within the deep pass | dimension keyword list | review/update | all dimensions | all dimensions |
| `--deps` | dependency traversal extent | `none`/`direct`/`full` | review/update | `direct` | `full` under default-full |
| `--source` | external source filter | source ID list | review | all monitored sources | all monitored sources |
| `--start`/`--end` | time window | ISO dates | review/audit | last cycle to now | n/a (default-full ignores) |
| `--skip` | pipeline-stage exclusion | stage IDs | review/update | none | none |

### Testing recommendations

- Run `get_errors` on the vision file after each pending edit — confirm zero markdown-lint diagnostics.
- Grep `R-[LPSG]\d+` after every edit — must return zero matches.
- Validate that every `relies_on:` ID in the frontmatter resolves to an existing body heading or table row.
- After todo #6, verify priority lines under body headings match frontmatter priorities (no silent drift).
- After todo #9, confirm the use-cases README references the new home of the goal-trio mapping and no dangling link remains in the vision Goal section.

### Performance / token-budget impact

- Frontmatter is ~30% smaller (rationales block removed; description compressed).
- Body reading cost reduced (kebab-case IDs read inline; no cross-reference jumps).
- `/pe-meta-update` planning prompts can now ground priority decisions on `scope.covers[*].priority` directly — no LLM judgment call required at the priority-classification step.

### Migration considerations

- Any downstream artifact citing `R-X#` rationale codes must be updated to kebab-case. Sweep candidates:
  - Use-case documents under `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/`.
  - Vision-amendment plans (if any cite specific R-codes).
  - PE-meta prompts and agents that quote rationale IDs.
- No backward-compatibility shim was added (the instruction file forbids mixed-state R-codes within one document).

---

## ✔️ Resolution status

### Current status

**Resolved** — all 9 foundational todos complete; 2 separate follow-ups (canonical parameter reference subsection; downstream `R-X#` sweep) tracked below.

### Verification checklist

- `.github/instructions/vision-frontmatter.instructions.md` updated to v1.3.0 with Scope Priority Block, expanded principles schema, Readable ID rule, retired `rationales:` block. (✅ done)
- Vision frontmatter `scope.covers:` restructured to 38 priority-tagged entries (7 P0 / 12 P1 / 18 P2 / 1 aspirational). (✅ done)
- Vision frontmatter `principles:` consolidated to 20 entries with `relies_on:` cross-refs. (✅ done)
- Vision frontmatter `rationales:` block deleted. (✅ done)
- Vision frontmatter `description:` tightened to ~120 words; `last_updated` bumped. (✅ done)
- Vision body R-code rename — 27 IDs + 9 bare-form references + 1 terminology note; ~150 substitutions; zero `R-X#` remaining. (✅ done)
- Vision file validates with zero errors after each edit. (✅ done)
- Body principle headings carry explicit `**Priority:**` lines matching frontmatter (todo #6). (✅ done)
- `### Default-full invocation contract` lives in Command families with forward stub from Goal (todo #7). (✅ done)
- `### Domain-coherent batching` lives in Command families with forward stub from Goal (todo #8). (✅ done)
- `### Goal-trio↔use-case mapping` lives in use-cases README with forward stub from Goal (todo #9). (✅ done)
- Canonical seven-parameter reference subsection added to Command families (separate follow-up). (✅ done)
- Downstream sweep for `R-X#` references in use-cases / prompts / agents. (✅ done)

### Follow-up actions

1. Execute todos #6–#9 in a single session after user review. (✅ done)
2. Add the canonical parameter reference subsection (`dim`/`scope`/`deps`/`mode` etc.). (✅ done)
3. Run a downstream `R-X#` sweep across `06.00-idea/self-updating-prompt-engineering/` and `.github/prompts/` and `.github/agents/`. (✅ done)
4. Re-run vision-amendment discipline check on the next vision-amendment plan to confirm `scope.covers[*].priority` is now load-bearing. (🟡 todo)

---

## 🎓 Lessons learned

### What went wrong

- **Flat scope lists silently absorb aspirational items as load-bearing.** Without a priority field, scope creep is undetectable — *Progressive learning via outcome logs* was treated as architectural for months despite being unimplemented.
- **Parallel taxonomies drift apart.** Three places to write "the system uses LLM judgment for X" guarantees disagreement over time. One canonical owner + cross-refs is the only stable model.
- **Opaque ID codes impose lookup cost on every read.** `R-S1` is unreadable; `metadata-driven` is self-documenting. Mnemonic value beats sort-key value in prose.
- **Goal sections naturally absorb mechanisms.** Authors reach for the nearest top-level heading when adding new material; without explicit boundaries (Goal = what we promise; Command families = how options work; Governance = how risk is partitioned), the Goal section bloats.

### What went right

- **Schema-first repair.** Updating the instruction file *before* editing the vision body meant the body sweep had a single authoritative rule to converge on.
- **Mechanical reshape, no version bump.** Treating principle-block declaration + scope-restructure as mechanical kept v15.0.0 intact, avoiding cascading changelog churn across downstream artifacts.
- **PowerShell chained substitution for the body rename.** A single ordered `-replace` chain handled 27 suffixed forms safely (longer suffixes first), avoiding the per-edit overhead of 27 individual edits.
- **Two-tier model** (prescriptive principles + descriptive rationales connected via `relies_on:`) maps cleanly to existing PE artifact conventions and is reusable for sibling vision documents.

### Improvements for future

- **Vision documents should require priority on every scope item from creation** — enforce in the vision-frontmatter instruction file as a hard rule, not a v1.3.0 retrofit.
- **Single-source-of-truth declarations need linting.** A future check should ensure no two PE artifacts independently define the same rationale text.
- **Naming convention guards.** A pre-commit / agent-side check could reject `R-[A-Z]\d+` patterns in vision body content.
- **Goal-section discipline.** Add a content-affinity rule to the vision-frontmatter instruction file: Goal contains only *promises*; mechanisms live in their own top-level sections.
- **Use-case authoring discipline.** Use cases should cite vision principles by kebab-case ID — never copy the prose.

---

## 📎 Appendix

### A. Full body R-code rename map

| Old | New |
|---|---|
| `R-L1-llm-reasoning` | `llm-reasoning` |
| `R-L2-self-correction` | `self-correction` |
| `R-L3-model-specialization` | `model-specialization` |
| `R-L4-external-knowledge` | `external-knowledge` |
| `R-P1-deterministic-processing` | `deterministic-processing` |
| `R-P2-decomposition` | `decomposition` |
| `R-P3-structured-contracts` | `structured-contracts` |
| `R-P4-structural-separation` | `structural-separation` |
| `R-P5-progressive-depth` | `progressive-depth` |
| `R-P6-model-routing` | `model-routing` |
| `R-P7-capability-applicability` | `capability-applicability` |
| `R-P8-default-full-investigation` | `default-full-investigation` |
| `R-P9-minimal-consistent-option-surface` | `minimal-consistent-option-surface` |
| `R-P10-domain-coherent-batching` | `domain-coherent-batching` |
| `R-S1-metadata-driven` | `metadata-driven` |
| `R-S2-dependency-graph` | `dependency-graph` |
| `R-S3-validation-caching` | `validation-caching` |
| `R-S4-role-declaration` | `role-declaration` |
| `R-S5-chain-alignment` | `chain-alignment` |
| `R-S6-tier-blast-radius` | `tier-blast-radius` |
| `R-S7-portable-packaging` | `portable-packaging` |
| `R-S8-instruction-minimization` | `instruction-minimization` |
| `R-S9-guidance-quality` | `guidance-quality` |
| `R-S10-quality-propagation` | `quality-propagation` |
| `R-G1-autonomy-gradient` | `autonomy-gradient` |
| `R-G2-trust-calibrated-adoption` | `trust-calibrated-adoption` |
| `R-G3-progressive-learning` | `progressive-learning` |
| `R-P8/R-P9/R-P10` (bare combined) | `default-full-investigation/minimal-consistent-option-surface/domain-coherent-batching` |
| Bare `R-P8` / `R-P9` / `R-P10` references | rewritten to kebab-case in surrounding prose |

### B. Priority taxonomy semantics

| Tier | Cardinality | Semantics | Change discipline |
|---|---|---|---|
| **P0** | 3–7 entries | Architectural invariant; underpins multiple downstream contracts | Removal/weakening triggers vision **version bump** |
| **P1** | open | Load-bearing operational rule | Change requires **changelog entry** |
| **P2** | open | Operational detail | Free to change |
| **aspirational** | open | Documents future intent | **MUST NOT** be cited as load-bearing from any downstream artifact |

### C. Two-tier model — principles vs body rationales

```text
┌─ Frontmatter principles: ──────────────────┐
│ - id: staleness-avoidance-first            │
│   priority: P0                             │
│   statement: "..."                         │
│   rationale: "..."         (optional)      │
│   relies_on:                               │
│     - metadata-driven      ──┐             │
│     - external-knowledge   ──┤             │
│     - validation-caching   ──┤             │
└──────────────────────────────┼─────────────┘
                               │
                               ▼
┌─ Body § The rationale ─────────────────────┐
│ | metadata-driven    | Description … |     │
│ | external-knowledge | Description … |     │
│ | validation-caching | Description … |     │
└────────────────────────────────────────────┘
```

### D. Quick verification commands

```powershell
# Confirm zero R-X# references in vision body
$path = 'c:\dev\darioairoldi\Learn\06.00-idea\self-updating-prompt-engineering\20260531.01-vision.md'
([regex]::Matches((Get-Content $path -Raw), 'R-[LPSG]\d+')).Count

# List frontmatter scope.covers priorities
(Get-Content $path -Raw) -split '---' | Select-Object -Index 1 |
  Select-String -Pattern 'priority:\s*(\w+)' -AllMatches |
  ForEach-Object { $_.Matches } | Group-Object { $_.Groups[1].Value } |
  Select-Object Name, Count
```

### E. Related artifacts

- [vision-frontmatter.instructions.md](../../../../../../.github/instructions/vision-frontmatter.instructions.md) — schema authority.
- [vision-amendment.instructions.md](../../../../../../.github/instructions/vision-amendment.instructions.md) — discipline that now consumes `scope.covers[*].priority`.
- [vision.v15.md](../../../../../../06.00-idea/self-updating-prompt-engineering/20260531.01-vision.md) — the document under repair.
- [use-cases README](../../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md) — pending recipient of the goal-trio↔use-case mapping.
- [overview.md](overview.md) — the original issue write-up.

---

**Resolution (final)** — to be filled when todos #6–#9 are merged and the canonical parameter reference subsection is added.
