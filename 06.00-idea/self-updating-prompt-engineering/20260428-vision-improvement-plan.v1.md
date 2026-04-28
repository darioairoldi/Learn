---
title: "Vision improvement plan: category-based chain alignment (R-S5 extension)"
author: "Dario Airoldi"
date: "2026-04-28"
version: "2.0.0"
status: "completed"
domain: "prompt-engineering"
target: "06.000-vision.v6.md"
produces: "06.000-vision.v7.md"
goal: "Extend the vision's R-S5 chain alignment rationale to endorse category-based indirection via structure indexes, with metadata-enforced category contracts that survive refactoring — improving robustness, preserving effectiveness, and maintaining efficiency"
scope:
  covers:
    - "R-S5 chain alignment extension with category-based indirection"
    - "Three-level reference hierarchy (folder → category → file)"
    - "Structure index role as category registry"
    - "Category metadata contracts for refactoring protection"
    - "Enforcement flow: metadata → categories → consumers → refactoring validation"
    - "Impact on Assess, Propose, Execute layers"
    - "Impact on design principles (chain alignment, metadata-guarded, deterministic, portable)"
  excludes:
    - "Implementing the changes in actual artifacts (20260428-pe-improvement-plan.v1.md handles this)"
    - "STRUCTURE-README.md content changes (improvement plan handles this)"
    - "Changes unrelated to reference robustness"
boundaries:
  - "MUST NOT alter the vision's goal, foundational principles, or governance model"
  - "MUST be a non-breaking extension of R-S5, not a replacement"
  - "MUST preserve all existing valid reference patterns (folder-level, precision file-level)"
  - "Changes are additive — they introduce a new reference level without removing existing ones"
rationales:
  - "R-S5 currently defines two reference levels (folder and file) — a third level (category) fills the gap between imprecise folder references and fragile file references"
  - "Category-based indirection enables deterministic file discovery (R-P1) while maintaining the stale-proof quality of folder references"
  - "Structure indexes already exist and are already maintained — no new infrastructure required"
  - "Category IDs are stable semantic identifiers that survive file renames, renumbering, and splitting"
  - "Categories declared in metadata become constraints that the pre-change guard and post-change reconciliation enforce during refactoring — using the vision's existing enforcement mechanisms"
  - "Without metadata-declared categories, refactoring can silently drop functional coverage that consumers depend on"
---

# Vision improvement plan: category-based chain alignment

## Table of contents

- [🎯 Problem this solves](#-problem-this-solves)
- [💡 Core proposal](#-core-proposal)
- [� Enforcement flow: how categories survive refactoring](#-enforcement-flow-how-categories-survive-refactoring)
- [�📋 Proposed changes to the vision](#-proposed-changes-to-the-vision)
- [⚠️ Risk assessment](#️-risk-assessment)
- [✅ Validation criteria](#-validation-criteria)
- [📚 References](#-references)

---

## 🎯 Problem this solves

R-S5 (chain alignment) currently defines two reference levels:

| Level | Mechanism | Pros | Cons |
|---|---|---|---|
| **Level 1: Folder/domain** | `enforces_rulesets` by canonical folder path | Stale-proof; survives file renames | Imprecise — consumer must load entire folder or guess which files matter |
| **Level 2: File-specific** | `enforces_rules` with specific rule IDs | Precise — consumer loads exactly what's needed | Fragile — breaks on rename, renumber, or split |

The gap between these two levels creates a practical problem: most cross-artifact references need *more precision than a folder* but *more robustness than a filename*. The result is that artifact authors default to Level 2 (file-specific) because Level 1 is too imprecise — and the system accumulates fragile references that break during refactoring.

The `20260428-pe-improvement-plan.v1.md` analysis found 40+ fragile file references across PE artifacts, with blast radii of 12–20+ files per rename. Six alternative resolution strategies were evaluated. **Category-based indirection** emerged as the clear winner.

### What the vision currently lacks

Beyond the two-level gap, the vision has four additional gaps that prevent robust reference management:

1. **No concept of structure indexes as reference intermediaries.** R-S5 says "reference by folder" but doesn't explain how consumers discover which files within the folder they need. The filesystem is the only index — imprecise and opaque.

2. **No enforcement mechanism for functional coverage during refactoring.** The metadata-guarded changes principle checks `goal`, `scope`, `boundaries`, `rationales` — but has no concept of "this file serves functional category X" as a constraint. When a file is split or renamed, the pre-change guard doesn't check whether the categories that consumers depend on still resolve.

3. **The refactoring protection paragraph** mentions scope coverage regression but not functional category coverage regression. A context file refactoring can silently break category→file mappings without triggering any guard.

4. **R-S5 provides no preference ordering guidance** for artifacts that need more precision than a folder but less fragility than a file. Artifact authors default to Level 2 because they have no practical alternative.

---

## 💡 Core proposal

Introduce **Level 1.5: Category-based indirection** — a third reference level that sits between folder references and file references.

| Level | Mechanism | Pros | Cons |
|---|---|---|---|
| **Level 1: Folder/domain** | Reference by folder path | Stale-proof | Imprecise |
| **Level 1.5: Category** (NEW) | Reference by functional category ID in a structure index | Precise AND robust — categories map to specific files but survive renames | Requires structure index maintenance |
| **Level 2: File-specific** | Reference by filename | Most precise | Fragile |

### How it works

1. Each context folder's **structure index** (e.g., `STRUCTURE-README.md`) maintains a **Functional Categories** section that maps stable category IDs to current filenames
2. Consumer artifacts reference categories instead of filenames: *"Load the `validation-rules` files from `.copilot/context/00.00-prompt-engineering/`"*
3. When files are renamed or reorganized, **only the structure index's category mappings are updated** — consumer artifacts don't change
4. Category IDs are **stable semantic identifiers** (kebab-case strings describing the capability needed, not the file that provides it)

### Why this aligns with vision principles

| Principle | Alignment |
|---|---|
| **R-P1 Deterministic processing** | Category→file resolution is a deterministic table lookup, not LLM judgment |
| **R-S5 Chain alignment** | Categories are the natural middle ground the two-level system was missing |
| **R-S7 Portable packaging** | Categories are a convention, not infrastructure — any repo with a structure index can adopt them |
| **R-P4 Structural separation** | Categories separate the *what* (capability needed) from the *where* (file that provides it) |
| **Scoped over exhaustive** | Category lookup loads only the files relevant to the capability, not the entire folder |

---

## 🔄 Enforcement flow: how categories survive refactoring

### The problem

Categories are only valuable if they're **maintained during refactoring**. Without enforcement, a file rename or split silently breaks the category→file mapping in STRUCTURE-README.md, and consumers referencing that category load nothing or the wrong files.

### The flow

The enforcement uses **mechanisms the vision already defines** — metadata-driven automation (R-S1), pre-change guards, and post-change reconciliation. No new mechanisms required; just new metadata fields that feed into existing guards.

```
1. STRUCTURE-README.md metadata declares required categories
   (boundary: "MUST maintain functional categories: validation-rules, ...")
        ↓
2. Functional Categories table maps category IDs → current files
        ↓
3. Consumer artifacts reference categories, not filenames
   ("Load `validation-rules` from .copilot/context/00.00-prompt-engineering/")
        ↓
4. Refactoring trigger: file renamed, split, or merged
        ↓
5. Pre-change guard reads STRUCTURE-README.md metadata
   → discovers required categories
   → checks: will every required category still have ≥1 valid file after this change?
   → if NO: BLOCK (category coverage regression)
        ↓
6. Post-change reconciliation updates Functional Categories table
   → maps renamed/split files to their categories
   → verifies all required categories still resolve
        ↓
7. Consumer artifacts remain untouched — category IDs are stable
```

### How this uses existing vision mechanisms

| Vision mechanism | Role in category enforcement |
|---|---|
| **R-S1 Metadata-driven** | Required categories declared as metadata constraints in STRUCTURE-README.md |
| **Pre-change guard** (Metadata-guarded changes) | Before any context file refactoring, guard checks that required categories won't lose coverage |
| **Post-change reconciliation** (Metadata-guarded changes) | After refactoring, update category→file mappings and verify all categories resolve |
| **R-P1 Deterministic processing** | Category→file resolution is a table lookup — deterministic, not LLM judgment |
| **R-S5 Chain alignment** | Categories ARE the Level 1.5 chain alignment mechanism |
| **Refactoring protection** (Metadata-guarded changes) | Extended to include category coverage regression alongside scope coverage regression |

### Alternatives for enforcement

| # | Alternative | Pros | Cons | Verdict |
|---|---|---|---|---|
| **A** | **Metadata in STRUCTURE-README + existing pre-change/post-change guards** | Zero new mechanisms; uses metadata-driven principle directly; STRUCTURE-README is already guarded | Relies on agents following the guard protocol (already a requirement for all artifacts) | **Recommended** — minimal, uses existing infrastructure |
| **B** | **Hook-based enforcement** (file watcher triggers category check) | Automatic on every file change; no agent discipline required | Hooks are deterministic but limited — they can't resolve category mappings; requires a complex hook; adds infrastructure | Rejected — over-engineered for the problem |
| **C** | **Validator check only** (pe-meta-validator audit adds category coverage) | Catches issues during periodic audits | Reactive, not preventive — damage may already be done between audits | Complement, not primary — add as V2 audit check |
| **D** | **All of the above** | Defense in depth | Complexity overhead; multiple enforcement paths create confusion about which is authoritative | Rejected — A+C is sufficient, B adds no value |

### The recommended approach: A + C

1. **Primary (preventive): Metadata constraints + pre-change/post-change guards** (Alternative A)
   - STRUCTURE-README.md declares required categories in its `boundaries:` metadata
   - Any refactoring that would remove a required category triggers BLOCK
   - Post-change reconciliation updates the category→file mapping

2. **Secondary (detective): Validator audit check** (Alternative C)
   - pe-meta-validator ecosystem audit includes a category coverage check
   - Catches category drift that somehow bypassed the guards (e.g., manual edits without running guards)

### Why this is feasible

1. **Pre-change guards already exist** and are already mandatory for all artifact changes — extending them to check category coverage is a natural extension
2. **STRUCTURE-README.md already has metadata** (`goal:`, `scope:`, `boundaries:`) — adding category constraints to `boundaries:` uses existing fields
3. **Post-change reconciliation already runs** after every change — updating the categories table is one more step in the existing protocol
4. **The enforcement is self-documenting** — required categories are visible in metadata, not hidden in agent logic
5. **Progressive adoption** — categories can be declared gradually; unreferenced categories have no enforcement cost

---

## 📋 Proposed changes to the vision

### Change V1: Extend R-S5 chain alignment with Level 1.5 (HIGH priority) — ✅ DONE

**Location:** System infrastructure rationale table → R-S5-chain-alignment row

**Current text:**
```
| **R-S5-chain-alignment** | **Chain alignment for stable cross-artifact references.** Artifacts should reference rule *sets* by folder/domain (coarse-grained, default — stale-proof) rather than individual rule IDs (fine-grained — fragile). Adding, removing, or renaming a rule doesn't break any consumer. Fine-grained rule ID references are used only when precision is load-bearing, validated by the `pe-artifact-coherence-check` skill. | Declare `enforces_rulesets` by canonical file path (Level 1, default). Use `enforces_rules` with specific IDs only by exception (Level 2). A rename log at `<state.path>/rename-log.jsonl` records every rule/file rename with `old → new` mapping for automated reference rewrite. |
```

**Proposed text:**
```
| **R-S5-chain-alignment** | **Chain alignment for stable cross-artifact references.** Artifacts should reference capabilities at the coarsest grain that preserves precision. Three levels are available, in order of preference: **Level 1 (folder/domain)** — reference by folder path, stale-proof but imprecise. **Level 1.5 (category)** — reference by functional category ID defined in a structure index (e.g., STRUCTURE-README.md), precise AND stale-proof because category IDs are stable semantic identifiers that survive file renames. **Level 2 (file-specific)** — reference by filename, most precise but fragile. Default to Level 1.5 for cross-artifact references. Use Level 1 when the entire folder's content is relevant. Use Level 2 only when precision is load-bearing (singleton files like dispatch tables, templates, handoff targets) and the filename is descriptive and non-numeric. | Declare `enforces_rulesets` by canonical file path (Level 1, default for YAML metadata). For prose references in agent bodies and prompts, use category IDs from the structure index (Level 1.5, preferred). Use `enforces_rules` with specific IDs only by exception (Level 2). Structure indexes maintain a Functional Categories section mapping stable category IDs to current filenames. A rename log at `<state.path>/rename-log.jsonl` records every rule/file rename with `old → new` mapping for automated reference rewrite. |
```

**Classification:** Non-breaking (additive — introduces a new level without removing existing ones)
**Confidence:** Deterministic
**Impact:** MEDIUM — this change affects how all future references are written, but doesn't invalidate any existing references

---

### Change V7: Extend metadata-guarded refactoring protection to include category coverage (HIGH priority) — ✅ DONE

**Location:** Design principles → Metadata-guarded changes → Refactoring protection paragraph

**Current text:**
```
**Refactoring protection.** During refactoring (restructuring, splitting, merging artifacts), pre-change guards detect scope reduction — if a refactored artifact covers less than its predecessor's declared scope, the gap is flagged as a coverage regression. This prevents silent capability loss.
```

**Proposed text:**
```
**Refactoring protection.** During refactoring (restructuring, splitting, merging artifacts), pre-change guards detect two types of coverage regression:

1. **Scope regression** — if a refactored artifact covers less than its predecessor's declared scope, the gap is flagged.
2. **Category regression** — if a refactored artifact is listed in a structure index's functional categories, the pre-change guard verifies that every affected category will still map to at least one valid file after the change. Missing category coverage is flagged as a regression.

Both types prevent silent capability loss — scope regression protects individual artifact coverage; category regression protects the stable reference contracts that consumers depend on.
```

**Classification:** Non-breaking (additive — extends existing protection)
**Confidence:** Deterministic
**Impact:** MEDIUM — extends the pre-change guard protocol with a new check

---

### Change V8: Add required categories to metadata contract (MEDIUM priority) — ✅ DONE

**Location:** Design principles → Metadata-driven → list of metadata fields

The current list of "every artifact should declare" metadata doesn't include functional categories. Structure indexes (STRUCTURE-README.md files) are a specific artifact type that need an additional metadata field.

**Add to the Metadata-driven principle, after the `version:` bullet:**
```markdown
- **`required_categories:`** (structure indexes only) — list of functional category IDs that MUST remain mapped to at least one existing file. Refactoring operations that would leave a required category unmapped are blocked by the pre-change guard. This extends R-S5 chain alignment to make category contracts enforceable.
```

**Classification:** Non-breaking (additive metadata field for one artifact type)
**Confidence:** Deterministic
**Impact:** LOW — new field applies only to structure indexes

---

### Change V9: Add category coverage to Assess finding severity (LOW priority) — ✅ DONE

**Location:** The vision → Assess → Finding severity classification table

**Add to the CRITICAL row's examples:**
```
..., required category with no mapped files in structure index
```

**Add to the HIGH row's examples:**
```
..., category-based reference resolves to non-existent category ID
```

**Classification:** Non-breaking (additive examples)
**Confidence:** Deterministic
**Impact:** LOW

---

### Change V2: Add category-based resolution to Assess layer (MEDIUM priority) — ✅ DONE

**Location:** The vision → Assess section, after the chain alignment checks paragraph

**Current text (excerpt from Assess):**
```
The `pe-prompt-engineering-validation` and `pe-artifact-coherence-check` skills are the validation pattern library. Chain alignment checks (R-S5-chain-alignment) run here: every `enforces_rulesets` path resolves to an existing file; every specific `enforces_rules` ID is non-dangling (consulting the rename log).
```

**Proposed text:**
```
The `pe-prompt-engineering-validation` and `pe-artifact-coherence-check` skills are the validation pattern library. Chain alignment checks (R-S5-chain-alignment) run here: every `enforces_rulesets` path resolves to an existing file; every specific `enforces_rules` ID is non-dangling (consulting the rename log). Category-based references (Level 1.5) are validated by checking that the referenced category ID exists in the target folder's structure index and maps to at least one existing file.
```

**Classification:** Non-breaking (additive)
**Confidence:** Deterministic
**Impact:** LOW

---

### Change V3: Add category validation to Execute static validation (LOW priority) — ✅ DONE

**Location:** The vision → Execute → Static validation technique row

**Current text (partial):**
```
| **Static validation** | Schema validity, reference resolution, boundary preservation, token budgets, goal/scope preservation, N-1 block-level classification (deterministic when labels present; LLM fallback when absent). Also includes named check types: **consistency check** (...), **efficiency check** (...), and **behavioral compatibility check** (...) |
```

**Proposed text:**
```
| **Static validation** | Schema validity, reference resolution (including category ID resolution via structure indexes), boundary preservation, token budgets, goal/scope preservation, N-1 block-level classification (deterministic when labels present; LLM fallback when absent). Also includes named check types: **consistency check** (...), **efficiency check** (...), and **behavioral compatibility check** (...) |
```

**Classification:** Non-breaking (clarification)
**Confidence:** Deterministic
**Impact:** LOW

---

### Change V4: Update scope.covers to include category-based references (LOW priority) — ✅ DONE

**Location:** Top YAML frontmatter → scope.covers

**Add to the list:**
```yaml
    - "Category-based indirection for robust cross-artifact references (Level 1.5)"
```

**Classification:** Non-breaking (additive metadata)
**Confidence:** Deterministic
**Impact:** LOW

---

### Change V5: Update description to mention category-based indirection (LOW priority) — ✅ DONE

**Location:** Top YAML frontmatter → description

**Current:**
```yaml
description: "Vision for a portable self-updating PE system with rationale-preserving metadata, N-1 structural separation as a foundational enabler, instruction minimization for collision prevention, and conflict-safe namespaced state paths for multi-domain repositories."
```

**Proposed:**
```yaml
description: "Vision for a portable self-updating PE system with rationale-preserving metadata, N-1 structural separation as a foundational enabler, instruction minimization for collision prevention, category-based chain alignment for robust cross-artifact references, and conflict-safe namespaced state paths for multi-domain repositories."
```

**Classification:** Non-breaking (additive metadata)
**Confidence:** Deterministic
**Impact:** LOW

---

### Change V6: Add category indirection to design principles (MEDIUM priority) — ✅ DONE

**Location:** Design principles section, inside the existing "Deterministic where possible" or as an extension of the R-S5 discussion.

Since the vision already has extensive chain alignment coverage in R-S5, the cleanest approach is to **not add a new design principle** but instead ensure R-S5's extension (V1) is sufficient. The three-level hierarchy described in V1 captures the design principle implicitly.

**However**, if a more explicit principle is desired, add a brief paragraph to the **"Portable by design"** principle section:

**Add after the "Instruction minimization" paragraph in "Portable by design":**
```markdown
**Category-based references (RECOMMENDED for cross-artifact references).** When artifacts reference specific context files, they should use functional category IDs defined in the folder's structure index rather than filenames. Category IDs are stable semantic identifiers that describe the capability needed (e.g., `validation-rules`, `token-optimization`) and map to specific files in the structure index. This decouples consumer artifacts from the physical file layout — renames, renumbering, and file splits only require updating the structure index, not every consumer.
```

**Classification:** Non-breaking (additive)
**Confidence:** Deterministic
**Impact:** LOW

---

## ⚠️ Risk assessment

### Risks

| Risk | Severity | Mitigation |
|---|---|---|
| **Structure index becomes critical infrastructure** | MEDIUM | Structure indexes are already critical (STRUCTURE-README.md is loaded by multiple agents). Category section adds responsibility but not a new failure mode. Apply the staleness avoidance principle: structure index staleness is HIGH severity. |
| **Category proliferation** | LOW | Keep categories at a manageable count (10–20 per folder). Each category should represent a distinct capability. Review during ecosystem audits. |
| **Category naming conflicts across repos** | LOW | Category IDs are scoped to their structure index. No cross-repo resolution needed. |
| **Agents fail to look up categories** | LOW | Category→file lookup is deterministic (read index, find row, extract files). This is simpler than the current approach of constructing filenames from memory. |
| **Over-engineering for current scale** | MEDIUM | The PE system already has 30+ context files with 40+ cross-references. The scale justifies the indirection. |

### What this doesn't change

- Vision's goal, foundational principles, and governance model remain unchanged
- Existing Level 1 (folder) and Level 2 (file) references remain valid
- No existing artifact behavior is altered — changes are purely additive
- The autonomy gradient, breaking/non-breaking classification, and metadata-guarded changes are unaffected (V7 extends, not replaces)
- Pre-change guard and post-change reconciliation protocols are extended, not redesigned

---

## ✅ Validation criteria

The vision update succeeds when:

1. **R-S5 explicitly describes three reference levels** with clear preference ordering
2. **No existing vision content is removed or contradicted** — changes are purely additive
3. **The Assess and Execute layers reference category validation** as part of chain alignment checks
4. **The three-level hierarchy is consistent** with all other vision principles (R-P1, R-S7, R-P4)
5. **The improvement plan's proposed changes (C0–C6)** are consistent with the updated vision
6. **Refactoring protection explicitly includes category coverage regression** alongside scope regression
7. **Structure indexes can declare required categories** in their metadata, enforceable by pre-change guards
8. **Finding severity classification includes** category-related findings at appropriate levels

---

## 📚 References

- **[06.000-vision.v6.md](06.000-vision.v6.md)** 📘 Internal
  Current vision document — target of these proposed changes.

- **[20260428-pe-improvement-plan.v1.md](20260428-pe-improvement-plan.v1.md)** 📘 Internal
  Implementation plan for category-based indirection — 10 findings, 7 proposed changes (C0–C6), alternatives analysis.

- **[STRUCTURE-README.md](../../.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md)** 📘 Internal
  Current structure index — target for Functional Categories section addition (C0).

<!--
article_metadata:
  filename: "20260428-vision-improvement-plan.v1.md"
  created: "2026-04-28"
  type: "idea"
  purpose: "Propose vision changes to endorse category-based chain alignment with metadata-enforced category contracts as the preferred reference mechanism"
  changes:
    - "v2.0.0: Added enforcement flow analysis — how categories survive refactoring via existing metadata guards; 4 enforcement alternatives evaluated; added V7 (refactoring protection extension), V8 (required_categories metadata), V9 (severity classification); updated validation criteria"
    - "v1.0.0: Initial plan — 6 proposed vision changes (V1-V6), risk assessment, validation criteria"
-->
