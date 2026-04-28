---
title: "Robust artifact references: analysis plan and findings"
author: "Dario Airoldi"
date: "2026-04-28"
version: "2.0.0"
status: "completed"
domain: "prompt-engineering"
implements: "06.000-vision.v6.md"
goal: "Identify fragile file-level references across all PE artifacts and propose a category-based indirection strategy via STRUCTURE-README.md that improves robustness without breaking or degrading artifact logic"
scope:
  covers:
    - "All PE artifact tiers: pe-meta, pe-consolidated, pe-granular agents"
    - "PE prompts across all tiers"
    - "Context files in .copilot/context/00.00-prompt-engineering/"
    - "Instruction files in .github/instructions/"
    - "Skills in .github/skills/"
    - "Templates in .github/templates/00.00-prompt-engineering/"
    - "Vision document references"
  excludes:
    - "Non-PE artifacts (article-writing agents, domain prompts)"
    - "Implementing the changes (this is analysis and planning only)"
    - "References that are inherently file-specific (e.g., dispatch table)"
boundaries:
  - "MUST NOT propose changes that would degrade artifact behavior"
  - "MUST NOT propose folder references where file-level precision is load-bearing"
  - "Changes are non-breaking — they improve robustness without altering logic"
rationales:
  - "Vision R-S5 (chain alignment) recommends coarse-grained folder references as default to be stale-proof"
  - "File-level references break silently when files are renamed, versioned, or reorganized"
  - "Folder-level references are self-healing — they remain valid when files within the folder change"
---

# Robust artifact references: analysis plan and findings

## Table of contents

- [🎯 Problem statement](#-problem-statement)
- [📋 Analysis methodology](#-analysis-methodology)
- [🔍 Reference pattern taxonomy](#-reference-pattern-taxonomy)
- [🔄 Category-based indirection strategy](#-category-based-indirection-strategy)
- [🏗️ Findings by artifact tier](#️-findings-by-artifact-tier)
- [💡 Improvement opportunities](#-improvement-opportunities)
- [⚠️ References that MUST remain file-specific](#️-references-that-must-remain-file-specific)
- [📌 Proposed changes](#-proposed-changes)
- [✅ Implementation guidelines](#-implementation-guidelines)
- [📚 References](#-references)

---

## 🎯 Problem statement

The vision document (R-S5, chain alignment) establishes that artifacts should reference rule *sets* by folder/domain (coarse-grained, default — stale-proof) rather than individual rule IDs or filenames (fine-grained — fragile). Adding, removing, or renaming a rule shouldn't break any consumer.

Current PE artifacts contain numerous **fragile file-level references** — explicit filenames with version numbers, numeric prefixes, or specific paths that break when files are renamed, versioned, or reorganized. This analysis identifies those fragile references and proposes robust alternatives.

### Guiding principle

> **Folder references are the default.** Use file-level references only when precision is load-bearing — when the artifact genuinely needs a specific file and no other file in the folder would suffice.

---

## 📋 Analysis methodology

### Artifacts scanned

| Tier | Location | Files scanned |
|---|---|---|
| **pe-meta** | `.github/agents/00.09-pe-meta/` | 4 agents |
| **pe-consolidated** | `.github/agents/00.01-pe-consolidated/` | 3 agents |
| **pe-granular** | `.github/agents/00.02-pe-granular/` | 24 agents |
| **pe-meta prompts** | `.github/prompts/00.09-pe-meta/` | 3 prompts |
| **pe-consolidated prompts** | `.github/prompts/00.01-pe-consolidated/` | 3 prompts |
| **pe-granular prompts** | `.github/prompts/00.02-pe-granular/` | all prompts |
| **Instructions** | `.github/instructions/` | all PE instruction files |
| **Skills** | `.github/skills/pe-*/`, `.github/skills/artifact-*/` | 4 skills |
| **Templates** | `.github/templates/00.00-prompt-engineering/` | all templates |
| **Context files** | `.copilot/context/00.00-prompt-engineering/` | all context files |

### Search patterns used

1. Explicit versioned filenames (e.g., `06.000-vision.v6.md`)
2. Numeric-prefixed context file references (e.g., `05.01-artifact-dependency-map.md`, `01.06-system-parameters.md`)
3. Template file references with full paths
4. `read_file` instructions pointing to specific files
5. `📖` reference markers pointing to individual files

---

## 🔍 Reference pattern taxonomy

### Pattern A: Versioned file references (HIGHEST fragility)

References that embed a version number in the filename. These break on every version bump.

**Example:**
```
`read_file` on `06.00-idea/self-updating-prompt-engineering/06.000-vision.v6.md`
```

**Why fragile:** When the vision advances to v7, every reference must be manually updated. The folder `06.00-idea/self-updating-prompt-engineering/` always contains exactly one current vision document — the folder reference is unambiguous.

**Robust alternative:**
```
`read_file` on the current vision document in `06.00-idea/self-updating-prompt-engineering/`
```

### Pattern B: Numbered context file references (MEDIUM fragility)

References to specific context files by their numeric-prefixed filename.

**Example:**
```
📖 `05.01-artifact-dependency-map.md`
```

**Why fragile:** If the file is renumbered (e.g., from `05.01-` to `06.01-`), renamed, or split into multiple files, every reference breaks. However, many of these references are **precision-necessary** — they point to a specific file because the consumer needs exactly that file's content, not the entire folder.

**Assessment required:** Each reference must be evaluated individually:
- If the consumer needs the *entire folder's knowledge* → use folder reference
- If the consumer needs *one specific file* → keep file reference but consider removing the numeric prefix from the reference text

### Pattern C: Template file references (LOW-MEDIUM fragility)

References to specific template files in `.github/templates/00.00-prompt-engineering/`.

**Example:**
```
📖 Report format: `.github/templates/00.00-prompt-engineering/output-meta-validator-reports.template.md`
```

**Why fragile (moderate):** Template filenames are relatively stable because they're named by purpose, not by number. However, they could be reorganized into subfolders. These are generally acceptable as-is because the consumer genuinely needs that specific template.

### Pattern D: Bare filename references without path context (MEDIUM fragility)

References using just the filename without the full path.

**Example:**
```
📖 Full priority matrix: `01.07-critical-rules-priority-matrix.md`
```

**Why fragile:** The file could be found in any directory. If a file with the same name exists elsewhere, the reference becomes ambiguous. If the numeric prefix changes, the reference breaks.

---

## 🔄 Category-based indirection strategy

### The problem with direct file references

The v1 analysis identified two classes of fragile references:
1. **Versioned filenames** (Pattern A) — break on every version bump
2. **Numeric-prefixed filenames** (Patterns B/D) — break on renumbering or reorganization

The v1 proposed changes (C2–C5) addressed these with ad-hoc solutions: topic-based discovery, glob patterns, folder references. Each finding got its own fix. But a systemic problem deserves a systemic solution.

### The insight: STRUCTURE-README as category registry

STRUCTURE-README.md already serves as the canonical index for context files — it maps every file to its purpose, tier, and consumers. It's the one file that *must* be updated when files are added, renamed, or reorganized.

The key insight: **extend STRUCTURE-README.md with functional categories** that group files by the capability they provide, not the tier they belong to. Artifacts reference categories instead of filenames. When files change, only STRUCTURE-README.md needs updating — the category identifiers remain stable.

### How it works

**STRUCTURE-README.md gains a "Functional Categories" section:**

```markdown
## Functional Categories

Categories group context files by the capability they provide to consumers.
Artifacts reference categories to discover which files to load.

| Category | Purpose | Files |
|---|---|---|
| `validation-rules` | Core principles and checks for PE artifact validation | `01.01-*`, `01.07-*`, `04.02-*` |
| `token-optimization` | Token budgets, limits, and optimization strategies | `01.06-*`, `02.02-*` |
| `tool-alignment` | Tool composition, mode alignment, and count limits | `01.04-*` |
| `dependency-tracking` | Artifact dependency graph and impact analysis | `05.01-*` |
| `lifecycle-ops` | Lifecycle stages, transitions, and workflow entry points | `05.02-*`, `05.03-*` |
| `audit-trail` | Review log, staleness detection, and outcome tracking | `05.04-*` |
| `effectiveness-tracking` | User-reported workflow outcomes | `05.05-*` |
| `assembly-architecture` | How Copilot assembles prompts from customization files | `01.02-*` |
| `orchestration-patterns` | Multi-agent coordination and handoff patterns | `02.01-*`, `02.03-*` |
| `agent-patterns` | Shared structural and behavioral patterns for agents | `02.04-*`, `02.05-*` |
| `production-readiness` | Response management, error recovery, embedded tests | `04.03-*` |
```

**Consumers reference categories instead of filenames:**

```markdown
# Before (fragile — breaks on renumbering):
Load `05.04-meta-review-log.md` for review history.
Load `01.01-context-engineering-principles.md` for validation.

# After (robust — category is stable):
Load the `audit-trail` files from `.copilot/context/00.00-prompt-engineering/`
  (see STRUCTURE-README.md → Functional Categories).
Load the `validation-rules` files from `.copilot/context/00.00-prompt-engineering/`
  (see STRUCTURE-README.md → Functional Categories).
```

### Alternatives evaluated

| # | Alternative | Pros | Cons | Verdict |
|---|---|---|---|---|
| **A** | **Category registry in STRUCTURE-README** (proposed) | Single source of truth already exists; categories are semantic and stable; agents already load STRUCTURE-README; refactoring updates one file; categories can group multiple files | Adds indirection step; STRUCTURE-README becomes critical infrastructure; categories must be maintained | **Recommended** |
| **B** | **Ad-hoc topic descriptions per artifact** (v1 approach) | Simple per-artifact; no new infrastructure | Each finding gets a different fix; no systemic solution; topic descriptions may not uniquely resolve; no single file to update on rename | Rejected — doesn't scale |
| **C** | **Dedicated YAML category map file** | Lightweight; fast to parse; pure data | New file to maintain alongside STRUCTURE-README; duplicate of information already in STRUCTURE-README; adds a file rather than extending one | Rejected — duplicates existing infrastructure |
| **D** | **Role declarations in file YAML frontmatter** | Distributed; no central file to maintain; files declare their own role | Agents must scan all files' YAML to discover; expensive at runtime; no single place to see all categories; role consistency harder to enforce | Rejected — expensive discovery |
| **E** | **LLM semantic discovery** ("find files about X") | Zero infrastructure; relies on LLM capability | Non-deterministic; different models may resolve differently; no reproducibility guarantee; violates R-P1 (deterministic where possible) | Rejected — violates determinism principle |
| **F** | **Folder-only references** | Simplest; always valid | Loses all precision; agent must load entire folder or guess which files matter; wastes tokens loading irrelevant files | Rejected — loses precision |

### Why Alternative A wins

1. **STRUCTURE-README already exists** and is maintained — no new infrastructure
2. **Categories are semantic identifiers** — they describe *what capability is needed*, not *where it lives*
3. **Single update point** — when files are renamed/renumbered, update STRUCTURE-README's category mappings only
4. **Preserves precision** — categories map to specific files, so agents load exactly what they need
5. **Deterministic resolution** — agent reads STRUCTURE-README, looks up category, gets file list (R-P1 compliant)
6. **Refactoring-safe** — splitting a file into two means updating the category's file list, not 20+ consumer references
7. **Self-documenting** — categories make the *purpose* of each reference explicit, improving artifact readability
8. **Graduated adoption** — categories can be added incrementally; existing direct references continue to work

### Design constraints

1. **Category IDs are kebab-case strings** — stable, human-readable identifiers
2. **Categories are cross-cutting** — a file can belong to multiple categories
3. **Categories are exhaustive for external consumers** — every file that external artifacts need to reference MUST appear in at least one category
4. **STRUCTURE-README is the single source of truth** for category→file mappings
5. **Category IDs are treated as a contract** — renaming a category is a breaking change (same rules as renaming a file today, but the blast radius is much smaller because only STRUCTURE-README and its immediate consumers use IDs)
6. **Inter-context-file references stay file-specific** — within the same folder, context files reference each other directly (they're peers, not consumers)

---

## 🏗️ Findings by artifact tier

### Finding F1: Vision document reference in pe-meta-researcher (HIGHEST fragility)

**File:** `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md`
**Lines:** 155, 217
**Current reference:**
```
`read_file` on `06.00-idea/self-updating-prompt-engineering/06.000-vision.v6.md`
```
and
```
(`06.000-vision.v6.md`)
```

**Risk:** Breaks on every vision version bump (v6→v7→v8...). The folder contains only one current vision document.

**Proposed fix:** Reference the folder `06.00-idea/self-updating-prompt-engineering/` and instruct the agent to find the current vision document (the one with the highest version number or no `supersedes` entry pointing to it). Alternatively, reference as "the current vision document in `06.00-idea/self-updating-prompt-engineering/`".

**Impact:** LOW — behavior unchanged, just more resilient to version bumps.

---

### Finding F2: Dependency map file reference (20+ occurrences)

**Files:** Multiple agents, skills, prompts across all tiers
**Current reference (variants):**
```
`.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md`
```
or
```
`05.01-artifact-dependency-map.md`
```

**Occurrences:** 20+ across pe-meta agents, pe-granular agents, skills, prompts

**Assessment:** This is a **precision-necessary reference** — the consumer needs exactly this one file, not the entire `00.00-prompt-engineering/` folder. The file serves a unique, specific role (dependency map) that no other file in the folder duplicates.

**However:** The numeric prefix `05.01-` is fragile. If the file is renumbered during reorganization, all 20+ references break.

**Proposed fix:** Keep file-level reference but consider a canonical alias mechanism or documenting the expected filename in a single source (e.g., the STRUCTURE-README). Alternatively, accept this as a tolerable risk since renumbering is rare and the filename is descriptive enough to find.

**Impact:** LOW — reference is already well-targeted; renumbering risk is low.

---

### Finding F3: Context file references in Knowledge Base tables (MEDIUM fragility)

**File:** `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md` (lines 97-103)
**Current reference:**
```markdown
| `01.01-context-engineering-principles.md` | Validate principles compliance |
| `01.02-prompt-assembly-architecture.md` | Validate assembly layer correctness |
| `01.04-tool-composition-guide.md` | Validate tool alignment |
| `02.02-context-window-and-token-optimization.md` | Validate token budget compliance |
| `05.01-artifact-dependency-map.md` | Validate dependency integrity |
| `05.02-artifact-lifecycle-management.md` | Validate lifecycle stage compliance |
```

**Risk:** Every file renaming or renumbering breaks 6 references in this single table. The table lists individual files the validator should load.

**Assessment:** This is a **mixed case**:
- The validator genuinely needs each of these specific files for different validation checks
- However, the table could reference the topics/capabilities rather than filenames, with a "discover the relevant file in `.copilot/context/00.00-prompt-engineering/`" instruction

**Proposed fix:** Convert to topic-based references with folder discovery:
```markdown
Load from `.copilot/context/00.00-prompt-engineering/`:
| Topic | Use For |
|---|---|
| Context engineering principles | Validate principles compliance |
| Prompt assembly architecture | Validate assembly layer correctness |
| Tool composition guide | Validate tool alignment |
| ... | ... |
```

**Impact:** MEDIUM — changes how the agent discovers files but doesn't change what it loads.

---

### Finding F4: `📖` references to individual context files across all instruction files

**Files:** All PE instruction files (`.github/instructions/pe-*.instructions.md`, `.github/instructions/*.instructions.md`)
**Current pattern (repeated in 12+ instruction files):**
```
📖 Full priority matrix: `01.07-critical-rules-priority-matrix.md`
```
and
```
📖 `.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md` — Token budgets
```

**Risk:** If context files are renumbered, all instruction files referencing them break. The numeric prefix is the fragile element.

**Assessment:** These references are **informational pointers** — they tell the LLM where to find additional context. The instruction files don't `read_file` on them; they're guidance for agents that consume the instruction files.

**Proposed fix (two options):**
1. **Replace with folder reference:** `📖 Full guidance: .copilot/context/00.00-prompt-engineering/` — simpler but less precise
2. **Replace numeric prefix with topic:** `📖 Full priority matrix: see critical-rules-priority-matrix in .copilot/context/00.00-prompt-engineering/` — preserves precision, removes fragile prefix

**Impact:** LOW — these are hints, not hard dependencies.

---

### Finding F5: `read_file` instructions for specific operational files

**Files:** pe-meta-researcher.agent.md (lines 187-191)
**Current references:**
```
Read `.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md`
Check `05.04-meta-review-log.md`
Read the "Authoritative Sources (curated)" section from `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md`
```

**Assessment:** These are **precision-necessary** — the agent needs exactly these operational files. However, the `05.04-` and `05.05-` numeric prefixes are fragile.

**Proposed fix:** These files serve unique roles (review log, effectiveness log). The references should remain file-specific but could use descriptive names without numeric prefixes:
```
Read the practical effectiveness log in `.copilot/context/00.00-prompt-engineering/`
Check the meta-review log in `.copilot/context/00.00-prompt-engineering/`
```

**Impact:** LOW — behavior unchanged, slightly more resilient.

---

### Finding F6: Template references in agents and prompts

**Files:** Multiple agents across all tiers
**Current pattern:**
```
📖 Handoff output format: `output-builder-handoff.template.md`
📖 Fix report format: `output-validator-fixes.template.md`
📖 Researcher output format: `.github/templates/00.00-prompt-engineering/output-researcher-report.template.md`
```

**Occurrences:** 20+ across agents and prompts

**Assessment:** Template references are **precision-necessary** — each consumer needs a specific template. Template filenames are descriptive and stable (named by purpose, not by number). The fragility here is LOW.

**Proposed fix:** No change recommended. Template references are already robust because:
- Filenames are descriptive and purpose-based
- No numeric prefixes to break
- Each template serves a unique, non-ambiguous role

**Impact:** N/A — no change needed.

---

### Finding F7: Dispatch table reference in pe-consolidated agents

**Files:** All 3 pe-consolidated agents
**Current reference (6 occurrences):**
```
`read_file` `.github/templates/00.00-prompt-engineering/artifact-type-dispatch.template.md`
```

**Assessment:** This is a **singleton reference** — there's exactly one dispatch table and it's the cornerstone of the consolidated agent architecture. The filename is descriptive and stable.

**Proposed fix:** No change recommended. The reference is to a unique, purpose-named file.

**Impact:** N/A — no change needed.

---

### Finding F8: STRUCTURE-README references

**Files:** pe-meta-designer, pe-gra-context-builder, pe-meta-optimizer, STRUCTURE-README.md itself
**Current references (various):**
```
`.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md`
`.copilot/context/STRUCTURE-README.md`
```

**Assessment:** STRUCTURE-README.md is a **singleton by convention** — one per context folder. The filename is non-numeric and descriptive. However, there's an inconsistency: some references use `00.00-prompt-engineering/STRUCTURE-README.md` and others use just `STRUCTURE-README.md`.

**Proposed fix:** Standardize to the full path `STRUCTURE-README.md` within the relevant context folder. No fragility issue — just consistency.

**Impact:** LOW — consistency improvement only.

---

### Finding F9: `📖` references using section anchors (ROBUST — no change)

**Files:** Multiple agents
**Current pattern:**
```
📖 Domain expertise activation: `02.05-agent-workflow-patterns.md` → "Domain Expertise Activation"
📖 Output minimization: `02.04-agent-shared-patterns.md`
```

**Assessment:** These reference specific files AND specific sections within them. The section anchor (→ "...") is fragile if the section heading changes, but this is **intentional precision** — the consumer needs a specific pattern from a specific file.

**Proposed fix:** No change recommended for the file reference. Consider whether section anchors could be replaced with topic descriptions, but this would reduce precision without meaningful robustness gain.

**Impact:** N/A — acceptable pattern.

---

### Finding F10: `context_dependencies` in YAML frontmatter (ALREADY ROBUST)

**Files:** All PE agents and instruction files
**Current pattern:**
```yaml
context_dependencies:
  - "00.00-prompt-engineering/"
```

**Assessment:** Already uses folder-level references as R-S5 recommends. This is the **gold standard** pattern — other references should aspire to this level of robustness.

**Impact:** N/A — already optimal.

---

## 💡 Improvement opportunities

### Priority ranking (updated with category strategy)

| Priority | Change | Resolves | Fragility | Fix complexity |
|---|---|---|---|---|
| **P0** | ~~C0: Establish functional categories in STRUCTURE-README~~ ✅ DONE | Foundation for all others | N/A (enabler) | MEDIUM |
| **P1** | ~~C1: Vision document version in filename~~ ✅ DONE | F1 | HIGHEST | LOW |
| **P2** | ~~C2: Knowledge Base table → category references~~ ✅ DONE | F3 | MEDIUM | LOW (with C0) |
| **P3** | ~~C3: Operational file refs → category references~~ ✅ DONE | F5 | MEDIUM | LOW (with C0) |
| **P4** | ~~C4: `📖` instruction file refs → category references~~ ✅ DONE | F4 | LOW-MEDIUM | LOW but wide |
| **P5** | ~~C5: Dependency map refs → category references~~ ✅ DONE | F2 | LOW | LOW but wide |
| **P6** | ~~C6: STRUCTURE-README path consistency~~ ✅ DONE | F8 | LOW | LOW |
| — | F6, F7, F9, F10 | — | LOW/none | No change needed |

### Recommended implementation order

1. ~~**C0 first** (establish categories in STRUCTURE-README)~~ ✅ DONE
2. ~~**C1** (vision reference)~~ ✅ DONE
3. ~~**C2** (Knowledge Base table)~~ ✅ DONE
4. ~~**C3** (operational files)~~ ✅ DONE
5. ~~**C4 and C5**~~ ✅ DONE
6. ~~**C6**~~ ✅ DONE

---

## ⚠️ References that MUST remain file-specific

Not all file references should become folder references. The following patterns require file-level precision:

| Pattern | Why file-specific is required |
|---|---|
| **Dispatch table** (`artifact-type-dispatch.template.md`) | Singleton by design — the entire consolidated architecture depends on loading this exact file |
| **Template references** (`output-*.template.md`) | Each template serves a unique formatting role — no folder-level alternative exists |
| **Handoff targets** (`agent: pe-meta-validator`) | Must resolve to an exact agent file |
| **Instruction file references in builder/validator agents** (`pe-agents.instructions.md`) | Agents `read_file` these as rule specifications for the artifact type they build/validate — not auto-injected in this context because `applyTo` targets the file being edited, not the file the agent reads about |
| **`applyTo` patterns in instruction frontmatter** | These ARE the routing mechanism — they must be precise |

---

## 📌 Proposed changes

### Change C0: Establish functional categories in STRUCTURE-README (FOUNDATION) — ✅ DONE

**File:** `.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md`
**Operation:** Update — add a Functional Categories section

**What to add** (after the existing "Cross-Reference Rules" section):

```markdown
## Functional Categories

Categories group context files by the capability they provide to consumers.
Artifacts reference categories instead of filenames for robust, refactoring-safe references.

**Rules:**
- Category IDs are kebab-case stable identifiers
- Every file referenced by external artifacts MUST appear in at least one category
- When files are renamed or split, update the category's file list here — consumer artifacts don't change
- Inter-context-file references (within this folder) stay file-specific

| Category | Purpose | Files |
|---|---|---|
| `validation-rules` | Core principles and checks for PE artifact validation | `01.01-context-engineering-principles.md`, `01.07-critical-rules-priority-matrix.md`, `04.02-adaptive-validation-patterns.md` |
| `token-optimization` | Token budgets, limits, and optimization strategies | `01.06-system-parameters.md`, `02.02-context-window-and-token-optimization.md` |
| `tool-alignment` | Tool composition, mode alignment, and count limits | `01.04-tool-composition-guide.md` |
| `assembly-architecture` | How Copilot assembles prompts from customization files | `01.02-prompt-assembly-architecture.md` |
| `file-type-guide` | Decision guide for choosing the right artifact type | `01.03-file-type-decision-guide.md` |
| `dependency-tracking` | Artifact dependency graph and impact analysis | `05.01-artifact-dependency-map.md` |
| `lifecycle-ops` | Lifecycle stages, transitions, and workflow entry points | `05.02-artifact-lifecycle-management.md`, `05.03-pe-workflow-entry-points.md` |
| `audit-trail` | Review history, staleness detection, and outcome tracking | `05.04-meta-review-log.md` |
| `effectiveness-tracking` | User-reported workflow outcomes | `05.05-practical-effectiveness-log.md` |
| `orchestration-patterns` | Multi-agent coordination and handoff patterns | `02.01-handoffs-pattern.md`, `02.03-orchestrator-design-patterns.md` |
| `agent-patterns` | Shared structural and behavioral patterns for agents | `02.04-agent-shared-patterns.md`, `02.05-agent-workflow-patterns.md` |
| `production-readiness` | Response management, error recovery, embedded tests | `04.03-production-readiness-patterns.md` |
| `runtime-validation` | Gate checks, goal alignment, drift detection for orchestrators | `04.04-orchestrator-runtime-validation.md` |
| `validation-caching` | 7-day validation caching policy and dual YAML rules | `04.01-validation-caching-pattern.md` |
| `specialized-patterns` | Platform-specific: skills, models, hooks, MCP, Spaces, SDK, templates | `03.01-*` through `03.07-*` |
| `governance` | North star governance, capability map | `00.01-governance-and-capability-baseline.md`, `00.02-capability-map.md` |
```

**Update the Cross-Reference Rules section** to add a category-based referencing pattern:

```markdown
### Referencing TO this folder by category (PREFERRED for external consumers)

Use category IDs from the Functional Categories table:

  Load the `validation-rules` files from `.copilot/context/00.00-prompt-engineering/`
  (see STRUCTURE-README.md → Functional Categories for file mapping).

This is preferred over direct file references because:
- Category IDs are stable — they don't change when files are renamed or renumbered
- Category mappings are maintained in one place (this file)
- Artifacts describe what capability they need, not which file implements it
```

**Classification:** Non-breaking | Confidence: Deterministic | Impact: LOW (additive — no existing behavior changes)

**STRUCTURE-README.md metadata** should include in its rationales:
```yaml
rationales:
  - "Functional categories provide stable semantic identifiers for cross-artifact references (R-S5)"
  - "Single source of truth for category→file mapping reduces blast radius of file renames to one file"
```

---

### Change C1: Vision document reference (F1) — ✅ DONE

**File:** `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md`

**Before (line 155):**
```markdown
1. **Load the vision document** (`read_file` on `06.00-idea/self-updating-prompt-engineering/06.000-vision.v6.md`) — this is the authoritative reference...
```

**After:**
```markdown
1. **Load the vision document** (`read_file` on the current vision document in `06.00-idea/self-updating-prompt-engineering/` — find the file matching `*-vision.v*.md` with the highest version) — this is the authoritative reference...
```

**Before (line 217):**
```markdown
...evaluate whether it aligns with the vision's goal (`06.000-vision.v6.md`)...
```

**After:**
```markdown
...evaluate whether it aligns with the vision's goal (current vision document in `06.00-idea/self-updating-prompt-engineering/`)...
```

**Classification:** Non-breaking | Confidence: Deterministic | Impact: LOW

---

### Change C2: Knowledge Base table → category references (F3) — ✅ DONE

**File:** `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md`

**Before:**
```markdown
| `01.01-context-engineering-principles.md` | Validate principles compliance |
| `01.02-prompt-assembly-architecture.md` | Validate assembly layer correctness |
| `01.04-tool-composition-guide.md` | Validate tool alignment |
| `02.02-context-window-and-token-optimization.md` | Validate token budget compliance |
| `05.01-artifact-dependency-map.md` | Validate dependency integrity |
| `05.02-artifact-lifecycle-management.md` | Validate lifecycle stage compliance |
```

**After:**
```markdown
Load context files from `.copilot/context/00.00-prompt-engineering/` by category (see STRUCTURE-README.md → Functional Categories):

| Category | Use For |
|---|---|
| `validation-rules` | Validate principles compliance |
| `assembly-architecture` | Validate assembly layer correctness |
| `tool-alignment` | Validate tool alignment |
| `token-optimization` | Validate token budget compliance |
| `dependency-tracking` | Validate dependency integrity |
| `lifecycle-ops` | Validate lifecycle stage compliance |
```

**Classification:** Non-breaking | Confidence: Deterministic (category→file mapping is explicit in STRUCTURE-README) | Impact: LOW

**Improvement over v1 C2:** v1 proposed topic-based discovery (LLM-assisted). With categories, resolution is deterministic — read STRUCTURE-README, lookup category, get file list. No LLM judgment needed.

---

### Change C3: Operational file refs → category references (F5) — ✅ DONE

**File:** `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md`

**Before:**
```markdown
5. **Load effectiveness log**: Read `.copilot/context/00.00-prompt-engineering/05.05-practical-effectiveness-log.md`
6. **Load rejection history**: Check `05.04-meta-review-log.md`
7. **Load authoritative sources list**: Read the "Authoritative Sources (curated)" section from `.copilot/context/00.00-prompt-engineering/05.04-meta-review-log.md`
```

**After:**
```markdown
5. **Load effectiveness log**: Read the `effectiveness-tracking` files from `.copilot/context/00.00-prompt-engineering/` (see STRUCTURE-README.md → Functional Categories)
6. **Load rejection history**: Read the `audit-trail` files from `.copilot/context/00.00-prompt-engineering/` (see STRUCTURE-README.md → Functional Categories)
7. **Load authoritative sources list**: Read the "Authoritative Sources (curated)" section from the audit-trail file loaded in step 6
```

**Classification:** Non-breaking | Confidence: Deterministic | Impact: LOW

---

### Change C4: `📖` references in instruction files → category references (F4) — ✅ DONE

**Files:** 12+ instruction files
**Status:** Ready for batch processing (no longer deferred — category infrastructure makes this mechanical)

**Pattern change:**
```markdown
# Before (fragile numeric prefix):
📖 Full priority matrix: `01.07-critical-rules-priority-matrix.md`
📖 `.copilot/context/00.00-prompt-engineering/01.06-system-parameters.md` — Token budgets

# After (category reference):
📖 Full priority matrix: see `validation-rules` in `.copilot/context/00.00-prompt-engineering/` (STRUCTURE-README.md → Functional Categories)
📖 Token budgets: see `token-optimization` in `.copilot/context/00.00-prompt-engineering/` (STRUCTURE-README.md → Functional Categories)
```

**Why no longer deferred:** With C0 in place, this change becomes mechanical — replace filename with category ID. No LLM judgment about which file to load; the category registry provides deterministic resolution.

**Classification:** Non-breaking | Confidence: Deterministic | Impact: LOW (each change is a simple text substitution)

---

### Change C5: Dependency map references → category reference (F2) — ✅ DONE

**Files:** 20+ agents, skills, prompts
**Status:** Ready for batch processing (no longer deferred — category infrastructure makes this mechanical)

**Pattern change:**
```markdown
# Before (fragile numeric prefix, 20+ occurrences):
Load `05.01-artifact-dependency-map.md`
`read_file` on `.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md`

# After (category reference):
Load the `dependency-tracking` file from `.copilot/context/00.00-prompt-engineering/`
  (see STRUCTURE-README.md → Functional Categories)
```

**Why no longer deferred:** The category `dependency-tracking` maps to exactly one file. The 20+ file blast radius is the same, but the change is mechanical and uniform — no per-file judgment required.

**Classification:** Non-breaking | Confidence: Deterministic | Impact: LOW

---

### Change C6: STRUCTURE-README path consistency (F8) — ✅ DONE

Unchanged from v1. Standardize all references to use `.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md`.

---

## ✅ Implementation guidelines

### Principles for robust references (updated with category strategy)

1. **Use category references as default** — reference files by their functional category in STRUCTURE-README.md, not by filename
2. **Keep file references only when precision is load-bearing** — dispatch table, template files, handoff targets, instruction file `applyTo` patterns
3. **Never use versioned filenames** in cross-artifact references — reference by folder + pattern or by role description
4. **Category IDs are a contract** — renaming a category requires updating all consumers (but the set is much smaller than direct file references)
5. **STRUCTURE-README.md is the single update point** — when files are renamed, update the category's file list here; consumer artifacts don't change
6. **Inter-context-file references stay file-specific** — within the same folder, context files reference each other directly

### Implementation sequence

1. **C0: Add Functional Categories to STRUCTURE-README.md** — this is the foundation
2. **C1: Fix vision reference** — independent of C0, immediate value
3. **C2: Update pe-meta-validator Knowledge Base** — first consumer of categories, validates the pattern
4. **C3: Update pe-meta-researcher operational refs** — second consumer, confirms pattern works
5. **Validate C0–C3** — run affected agents on test scenarios, verify correct file loading
6. **C4: Batch update instruction files** — mechanical: replace filename → category ID
7. **C5: Batch update dependency map references** — mechanical: replace filename → category ID
8. **C6: Standardize STRUCTURE-README paths** — cosmetic, do during any of the above

### Validation approach

For each change:
1. Apply the change to the artifact
2. Run the affected agent/prompt on a test scenario
3. Verify the agent loads the correct file via the category lookup
4. Check that no other artifact's behavior is affected (consumers of the modified artifact)
5. For C0 specifically: verify all existing files appear in at least one category

### Rollback strategy

Each change is independently reversible:
- C0: Remove the Functional Categories section from STRUCTURE-README.md
- C1–C6: Restore the original file-specific reference text
- Category removal doesn't break consumer artifacts that haven't been updated yet (they still use direct filenames)

---

## 📚 References

- **[06.000-vision.v6.md](06.000-vision.v6.md)** 📘 Internal
  Vision document defining R-S5 (chain alignment) — the rationale for folder-level references as default.

- **[R-S5 chain alignment](06.000-vision.v6.md)** 📘 Internal
  "Artifacts should reference rule sets by folder/domain (coarse-grained, default — stale-proof) rather than individual rule IDs (fine-grained — fragile)."

- **[05.01-artifact-dependency-map.md](.copilot/context/00.00-prompt-engineering/05.01-artifact-dependency-map.md)** 📘 Internal
  Dependency map used to trace reference impacts across the artifact graph.

<!--
article_metadata:
  filename: "20260428-pe-improvement-plan.v1.md"
  created: "2026-04-28"
  type: "idea"
  purpose: "Analysis plan for improving PE artifact reference robustness per vision R-S5 with category-based indirection via STRUCTURE-README.md"
  changes:
    - "v2.0.0: Added category-based indirection strategy — STRUCTURE-README.md as functional category registry; 6 alternatives evaluated; C0 foundation change added; C4/C5 no longer deferred; implementation sequence updated"
    - "v1.0.0: Initial analysis — 10 findings, 5 proposed changes (3 immediate, 2 deferred)"
-->
