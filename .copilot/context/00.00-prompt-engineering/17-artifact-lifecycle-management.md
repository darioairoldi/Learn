# Prompt Engineering Artifact Lifecycle Management

**Purpose**: Defines the creation → review → update → deprecation workflow for PE artifacts, with responsibilities, triggers, and quality gates at each stage.

**Referenced by**: Meta-review prompt (`meta-prompt-engineering-review`), `prompt-design`, `agent-design`, all PE agents and prompts (indirectly via semantic search)

---

## Lifecycle Overview

Every PE artifact follows a four-stage lifecycle. Each stage has defined triggers, responsible agents/prompts, and quality gates.

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────────┐
│  CREATE  │───►│  REVIEW  │───►│  UPDATE  │───►│  DEPRECATE   │
│          │    │          │    │          │    │              │
│ Research │    │ Validate │    │ Optimize │    │ Migration    │
│ Build    │    │ Score    │    │ Fix      │    │ Notice       │
│ Validate │    │ Certify  │    │ Re-valid │    │ Replacement  │
└──────────┘    └──────────┘    └──────────┘    └──────────────┘
     │               │               │               │
     ▼               ▼               ▼               ▼
  [Quality Gate]  [Quality Gate]  [Quality Gate]  [Quality Gate]
```

---

## Stage 1: Creation

### Triggers

- New capability needed (user request or gap identified by meta-review)
- Existing artifact needs decomposition (scope too broad)
- New VS Code/Copilot feature requires coverage

### Process by Artifact Type

| Artifact Type | Prompt to Use | Agent Workflow | Quality Gate |
|---|---|---|---|
| **Context file** | `context-file-create-update` | `context-builder` → `prompt-validator` | Structure + no duplication |
| **Instruction file** | `instruction-file-create-update` | `instruction-builder` → `prompt-validator` | applyTo conflict check + structure |
| **Agent file** | `prompt-design` or `agent-create-update` | `agent-researcher` → `agent-builder` → `agent-validator` | Tool alignment + boundaries |
| **Prompt file** | `prompt-design` or `prompt-create-update` | `prompt-researcher` → `prompt-builder` → `prompt-validator` | Tool alignment + boundaries |
| **Skill file** | Manual (follow `skills.instructions.md`) | N/A | Progressive disclosure + description quality |
| **Template file** | Manual (follow naming conventions in `prompts.instructions.md`) | N/A | Structure compliance |

### Creation Quality Gate

An artifact MUST pass ALL of these before entering the "active" state:

- [ ] Structure compliant with relevant instruction file
- [ ] YAML frontmatter complete and valid
- [ ] Tool alignment verified (plan = read-only, agent = all)
- [ ] Tool count within 3–7 range (agents and prompts)
- [ ] Three-tier boundaries present (Always/Ask/Never) with 3/1/2 minimums
- [ ] No content duplication with existing artifacts (checked via dependency map)
- [ ] Cross-references resolve to existing files
- [ ] Token budget respected (context: ≤2,500; instruction: ≤1,500; prompt: ≤1,500)
- [ ] Dependency map updated ([16-artifact-dependency-map.md](16-artifact-dependency-map.md))
- [ ] STRUCTURE-README updated (context files only)

---

## Stage 2: Review

### Triggers

| Trigger | Frequency | Scope |
|---|---|---|
| **Scheduled health check** | Biweekly | All PE artifacts |
| **Post-creation validation** | Immediately | Newly created artifact |
| **Post-update re-validation** | After every update | Modified artifact + dependents |
| **Coherence review** | Monthly | Cross-artifact consistency |
| **VS Code release** | Per release | Artifacts affected by new features |

### Review Process

1. **Use the right prompt**:
   - Single prompt/agent: `prompt-review` or `agent-review`
   - System-wide review: `/meta-prompt-engineering-review` (scope + dimension parameters)
   - Example: `/meta-prompt-engineering-review all coherence+structure+references`

2. **Review dimensions**:

| Dimension | Check | Severity if Failed |
|---|---|---|
| **Tool alignment** | plan = read-only tools only | CRITICAL |
| **Structure compliance** | All required sections present | HIGH |
| **Boundary completeness** | 3 Always / 1 Ask / 2 Never minimum | HIGH |
| **Token budget** | Within limits for artifact type | MEDIUM |
| **Cross-reference validity** | All references resolve | MEDIUM |
| **Content currency** | No stale information | MEDIUM |
| **Redundancy** | No duplication with other artifacts | LOW |

3. **Generate review report** with severity scores and specific fix recommendations

### Review Quality Gate

Artifact retains "active" status if:
- Zero CRITICAL issues
- ≤2 HIGH issues (with fix plan documented)
- Quality score ≥ 70%

---

## Stage 3: Update

### Triggers

| Trigger | Update Type | Process |
|---|---|---|
| **Review found issues** | Fix | `prompt-updater` / `agent-updater` → re-validate |
| **New best practice discovered** | Enhancement | Read → plan → apply → re-validate |
| **Dependency changed** | Cascade | Check impact via dependency map → update references |
| **VS Code feature changed** | Adaptation | Research → update affected artifacts → re-validate |
| **Redundancy identified** | Deduplication | Identify canonical source → replace inline with reference → verify |

### Update Process

1. **Impact analysis** (MUST do first):
   - Consult [16-artifact-dependency-map.md](16-artifact-dependency-map.md)
   - Count dependents
   - Classify impact level (Low/Medium/High)

2. **Apply changes**:
   - Use `prompt-updater` for prompts, `agent-updater` for agents
   - Use `context-builder` for context files, `instruction-builder` for instructions
   - Categorize each change: CRITICAL / HIGH / MEDIUM / LOW

3. **Re-validate**:
   - CRITICAL/HIGH changes: Full re-validation of artifact + dependents
   - MEDIUM changes: Quick validation of artifact
   - LOW changes: No validation needed

### Update Safety Rules

- **MUST** read the complete file before modifying
- **MUST** include 3–5 lines of context in replace operations
- **MUST** verify tool alignment is preserved after changes
- **MUST** update version history / metadata timestamps
- **MUST NOT** remove capabilities without explicit approval
- **MUST NOT** modify high-impact files (6+ dependents) without documenting the change plan

### Update Quality Gate

Updated artifact MUST:
- [ ] Pass the same checks as the Creation Quality Gate
- [ ] Not introduce new CRITICAL or HIGH issues
- [ ] Not break dependent artifacts (verified via re-validation)
- [ ] Have updated version history

---

## Stage 4: Deprecation

### Triggers

- Artifact replaced by a better alternative
- Artifact's purpose absorbed by another artifact (consolidation)
- Underlying capability removed from VS Code / Copilot

### Deprecation Process

1. **Document the replacement**:
   - What replaces this artifact?
   - What migration steps are needed for users?

2. **Add deprecation notice** to the artifact:

```markdown
> ⚠️ **DEPRECATED** (YYYY-MM-DD)
> This file is deprecated and will be removed after YYYY-MM-DD.
> **Replacement**: `[path/to/replacement]`
> **Migration**: [Brief migration steps]
```

3. **Move to `old/` folder** (prompts only — context files and instructions are deleted after migration):
   - Add deprecation header with replacement path
   - Keep file accessible for reference during migration period

4. **Update dependency map**:
   - Remove deprecated artifact from [16-artifact-dependency-map.md](16-artifact-dependency-map.md)
   - Verify no active artifacts still reference the deprecated file

5. **Remove after grace period** (30 days recommended):
   - Verify zero references remain
   - Delete the file

### Deprecation Quality Gate

- [ ] Replacement artifact exists and is validated
- [ ] Deprecation notice added with replacement path
- [ ] All dependents updated to reference replacement
- [ ] Dependency map updated
- [ ] Grace period defined

---

## Responsibility Matrix

| Action | Who Performs | Who Validates |
|---|---|---|
| Create context file | `context-builder` agent | `prompt-validator` agent |
| Create instruction file | `instruction-builder` agent | `prompt-validator` agent |
| Create prompt file | `prompt-builder` agent | `prompt-validator` agent |
| Create agent file | `agent-builder` agent | `agent-validator` agent |
| Review prompt/agent | `prompt-validator` / `agent-validator` | Orchestrator prompt gates |
| Update prompt | `prompt-updater` agent | `prompt-validator` (re-validation) |
| Update agent | `agent-updater` agent | `agent-validator` (re-validation) |
| System review | `meta-prompt-engineering-review` prompt | User review of report |
| Deprecation | Manual decision | Dependency map verification |

---

## Anti-Patterns

### ❌ Creating Without Checking for Existing Coverage

**Wrong**: Creating a new context file without searching for existing files covering the same topic.
**Right**: Search context files first, consolidate if overlap exists, create only if gap confirmed.

### ❌ Updating Without Impact Analysis

**Wrong**: Modifying `04-tool-composition-guide.md` without checking its 6+ dependents.
**Right**: Consult dependency map, plan re-validation for all affected artifacts.

### ❌ Deprecating Without Migration Path

**Wrong**: Moving a prompt to `old/` without documenting what replaces it.
**Right**: Add deprecation notice with replacement path, update all dependents first.

### ❌ Skipping Re-Validation After Updates

**Wrong**: Fixing an issue found by the validator without re-running validation.
**Right**: CRITICAL/HIGH changes ALWAYS trigger re-validation.

---

## Checklist: Artifact Lifecycle Compliance

- [ ] New artifacts pass the Creation Quality Gate
- [ ] Active artifacts reviewed per scheduled cadence
- [ ] Updates follow impact analysis → change → re-validate sequence
- [ ] Deprecated artifacts have replacement and migration path
- [ ] Dependency map is current after every creation/update/deletion
- [ ] STRUCTURE-README updated for context file changes

---

## References

- **Internal**: [16-artifact-dependency-map.md](16-artifact-dependency-map.md), [03-file-type-decision-guide.md](03-file-type-decision-guide.md), [STRUCTURE-README.md](../STRUCTURE-README.md)
- **External**: [VS Code Copilot Customization](https://code.visualstudio.com/docs/copilot/copilot-customization)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-03-08 | Initial version — four-stage lifecycle with quality gates and responsibility matrix | System |
