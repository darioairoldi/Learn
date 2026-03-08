# Prompt Engineering Artifact Dependency Map

**Purpose**: Documents every PE artifact, its outbound references, and what references it — enabling change impact analysis before modifying any file.

**Referenced by**: Meta-review prompts (`meta-prompt-engineering-review`, `meta-prompt-engineering-optimize`), `context-builder` agent, `instruction-builder` agent

---

## How to Use This Map

Before modifying ANY PE artifact:

1. **Find the artifact** in the tables below
2. **Check "Referenced By"** to identify all files that depend on it
3. **Assess impact** — changes to files with many dependents require broader re-validation
4. **After changes** — run `prompt-review` or `agent-review` on each dependent

**Impact classification:**

| Dependents | Impact | Action |
|---|---|---|
| 0–2 | Low | Apply change, validate dependents |
| 3–5 | Medium | Review dependents first, then apply |
| 6+ | High | Document change plan, validate incrementally |

---

## Layer Architecture

Artifacts form a clean dependency hierarchy with no circular references:

```
Layer 1: Context Files (16 files)
    ↑ referenced by
Layer 2: Instruction Files (4 files)
    ↑ auto-injected into
Layer 3: Agents (10 files) + Skills (1 skill + 3 templates)
    ↑ coordinated by
Layer 4: Prompts (8 files) + Templates (12+ PE-related)
```

**Rule**: Dependencies flow UPWARD only. Lower layers MUST NOT reference higher layers.

---

## Context Files (.copilot/context/00.00-prompt-engineering/)

### Tier: Foundations (01–04)

| # | File | References (outbound) | Referenced By |
|---|---|---|---|
| 01 | `01-context-engineering-principles.md` | None (foundational) | `prompts.instructions.md`, `agents.instructions.md`, `skills.instructions.md`, PE-validation skill, all agents (indirectly) |
| 02 | `02-prompt-assembly-architecture.md` | → `01-context-engineering-principles` | `prompts.instructions.md`, `agents.instructions.md`, `03-file-type-decision-guide`, `12-copilot-spaces-patterns`, `13-copilot-sdk-integration` |
| 03 | `03-file-type-decision-guide.md` | → `02-prompt-assembly-architecture`, → `04-tool-composition-guide`, → `12-copilot-spaces-patterns`, → `13-copilot-sdk-integration` | `agents.instructions.md`, all creation workflows |
| 04 | `04-tool-composition-guide.md` | None | `prompts.instructions.md`, `agents.instructions.md`, PE-validation skill, `prompt-researcher`, `agent-researcher`, `03-file-type-decision-guide` |

### Tier: Multi-Agent (05–07)

| # | File | References (outbound) | Referenced By |
|---|---|---|---|
| 05 | `05-handoffs-pattern.md` | → `06-context-window-and-token-optimization` | Orchestrator prompts, `agents.instructions.md` |
| 06 | `06-context-window-and-token-optimization.md` | → `05-handoffs-pattern`, → `04-tool-composition-guide` | `prompts.instructions.md`, orchestrator prompts, multi-agent agents, `09-model-specific-optimization` |
| 07 | `07-orchestrator-design-patterns.md` | → `10-agent-hooks-reference`, → `06-context-window-and-token-optimization` | Orchestrator prompts, `agents.instructions.md` |

### Tier: Specialized (08–13)

| # | File | References (outbound) | Referenced By |
|---|---|---|---|
| 08 | `08-progressive-disclosure-pattern.md` | None | `skills.instructions.md` |
| 09 | `09-model-specific-optimization.md` | → `06-context-window-and-token-optimization` | `prompts.instructions.md` (model selection) |
| 10 | `10-agent-hooks-reference.md` | → `07-orchestrator-design-patterns` | Agent/orchestrator files |
| 11 | `11-mcp-server-design-patterns.md` | → `04-tool-composition-guide`, → `03-file-type-decision-guide` | MCP-related prompts |
| 12 | `12-copilot-spaces-patterns.md` | → `02-prompt-assembly-architecture`, → `03-file-type-decision-guide` | Cross-project agents |
| 13 | `13-copilot-sdk-integration.md` | → `02-prompt-assembly-architecture`, → `04-tool-composition-guide`, → `11-mcp-server-design-patterns` | SDK application prompts |

### Tier: Repo-Specific (14–15)

| # | File | References (outbound) | Referenced By |
|---|---|---|---|
| 14 | `14-validation-caching-pattern.md` | None | `prompts.instructions.md`, validation prompts |
| 15 | `15-adaptive-validation-patterns.md` | → `04-tool-composition-guide` | PE-validation skill, `prompt-create-update`, `agent-create-update` |

### Tier: Meta (16–18)

| # | File | References (outbound) | Referenced By |
|---|---|---|---|
| 16 | `16-artifact-dependency-map.md` | All context files | Meta agents, meta prompts, builder agents |
| 17 | `17-artifact-lifecycle-management.md` | → `16-artifact-dependency-map`, → `03-file-type-decision-guide` | Meta agents, meta prompts |
| 18 | `18-pe-workflow-entry-points.md` | → `16-artifact-dependency-map`, → `17-artifact-lifecycle-management`, → `03-file-type-decision-guide` | Meta agents, users |

**Highest-impact context files** (most dependents):
1. `01-context-engineering-principles.md` — foundational, affects all artifacts indirectly
2. `04-tool-composition-guide.md` — referenced by 6+ files directly
3. `02-prompt-assembly-architecture.md` — referenced by 5+ files directly
4. `03-file-type-decision-guide.md` — entry point for all file-type decisions

---

## Instruction Files (.github/instructions/)

| File | applyTo | References (outbound) | Referenced By |
|---|---|---|---|
| `prompts.instructions.md` | `.github/prompts/**/*.md` | → all 18 context files (📖 folder ref), → templates (`output-*`, `input-*`) | All prompt files (auto-injected) |
| `agents.instructions.md` | `.github/agents/**/*.agent.md` | → all 18 context files (📖 folder ref), → templates (26+), → `03-file-type-decision-guide` | All agent files (auto-injected) |
| `context-files.instructions.md` | `.copilot/context/**/*.md` | → `prompts.instructions.md`, → `agents.instructions.md` | All context files (auto-injected), `context-builder` agent |
| `skills.instructions.md` | `.github/skills/**/SKILL.md` | → all 16 context files (📖 folder ref), → `08-progressive-disclosure-pattern` | All skill files (auto-injected) |

**Impact note**: Instruction files auto-inject into EVERY matching file. Changes affect all artifacts in the `applyTo` scope.

---

## Agent Files (.github/agents/00.00 prompt-engineering/)

### Prompt Workflow Agents

| Agent | Mode | Tools | Handoffs (outbound) | References | Referenced By |
|---|---|---|---|---|---|
| `prompt-researcher` | `plan` | 5 read-only | → `prompt-builder` (send: false) | PE-validation skill, `04-tool-composition-guide` | `prompt-design` orchestrator |
| `prompt-builder` | `agent` | 5 (read+write) | → `prompt-validator` (send: true) | `prompts.instructions.md`, templates | `prompt-design` orchestrator |
| `prompt-validator` | `plan` | 5 read-only | → `prompt-updater` (send: true) | PE-validation skill, tool-alignment template | `prompt-design`, `prompt-review` |
| `prompt-updater` | `agent` | 5 (read+write) | → `prompt-validator` (send: true) | PE-validation skill, tool-alignment template | `prompt-review`, `prompt-validator` |

### Agent Workflow Agents

| Agent | Mode | Tools | Handoffs (outbound) | References | Referenced By |
|---|---|---|---|---|---|
| `agent-researcher` | `plan` | 5 read-only | → `agent-builder` (send: false) | PE-validation skill, `04-tool-composition-guide` | `agent-design`, `prompt-design` |
| `agent-builder` | `agent` | 5 (read+write) | → `agent-validator` (send: true) | `agents.instructions.md`, templates | `agent-design`, `prompt-design` |
| `agent-validator` | `plan` | 5 read-only | → `agent-updater` (send: true) | PE-validation skill, tool-alignment template | `agent-design`, `agent-review` |
| `agent-updater` | `agent` | 5 (read+write) | → `agent-validator` (send: true) | PE-validation skill, tool-alignment template | `agent-review`, `agent-validator` |

### Infrastructure Agents

| Agent | Mode | Tools | Handoffs (outbound) | References | Referenced By |
|---|---|---|---|---|---|
| `context-builder` | `agent` | 6 (read+write) | → `prompt-validator` (send: true) | `context-files.instructions.md`, `STRUCTURE-README.md` | `context-file-create-update` |
| `instruction-builder` | `agent` | 6 (read+write) | → `prompt-validator` (send: true) | All `.github/instructions/` files | `instruction-file-create-update` |

### Meta Agents (System Self-Improvement)

| Agent | Mode | Tools | Handoffs (outbound) | References | Referenced By |
|---|---|---|---|---|---|
| `meta-reviewer` | `plan` | 5 read-only | → `meta-optimizer` (send: true) | `16-artifact-dependency-map`, `17-artifact-lifecycle-management`, `artifact-coherence-check` skill | `meta-prompt-engineering-review`, `meta-prompt-engineering-optimize` |
| `meta-optimizer` | `agent` | 6 (read+write) | → `prompt-validator` (send: true) | `16-artifact-dependency-map`, `STRUCTURE-README.md`, PE-validation skill | `meta-reviewer` handoff, `meta-prompt-engineering-review`, `meta-prompt-engineering-optimize` |

---

## Prompt Files (.github/prompts/00.00-prompt-engineering/)

### Orchestrator Prompts (multi-agent coordination)

| Prompt | Mode | Handoffs (outbound) | References | Purpose |
|---|---|---|---|---|
| `prompt-design` | `agent` | → 8 agents (all prompt + agent specialists) | `prompts.instructions.md`, context files | Full prompt creation workflow (8 phases) |
| `agent-design` | `agent` | → 4 agents (agent specialists) | `agents.instructions.md`, context files | Full agent creation workflow (8 phases) |
| `prompt-review` | `plan` | → `prompt-validator`, `prompt-updater` | PE-validation skill | Prompt validation with fix loop |
| `agent-review` | `plan` | → `agent-validator`, `agent-updater` | PE-validation skill | Agent validation with fix loop |

### Meta-Prompts (system self-improvement)

| Prompt | Mode | Handoffs (outbound) | References | Purpose |
|---|---|---|---|---|
| `meta-prompt-engineering-review` | `plan` | → `meta-reviewer`, `meta-optimizer` | `16-artifact-dependency-map`, `17-artifact-lifecycle-management`, both PE skills | Parameterized system review (scope + dimension) |
| `meta-prompt-engineering-optimize` | `agent` | → `meta-reviewer`, `meta-optimizer`, `prompt-validator` | `16-artifact-dependency-map` | Apply optimizations (on-demand) |
| `meta-prompt-engineering-update` | `agent` | → `meta-reviewer`, `meta-optimizer`, `prompt-validator`, `agent-validator` | `16-artifact-dependency-map`, `fetch_webpage` | Incorporate new practices (event-driven) |

### Standalone Prompts (direct execution, no agent handoffs)

| Prompt | Mode | Tools | References | Purpose |
|---|---|---|---|---|
| `prompt-create-update` | `agent` | 4 (search+read) | `15-adaptive-validation-patterns`, `prompts.instructions.md`, templates | Create/update prompt files directly |
| `agent-create-update` | `agent` | 4 (search+read) | `agents.instructions.md`, templates | Create/update agent files directly |
| `context-file-create-update` | `agent` | 9 (search+read+write+fetch) | `context-files.instructions.md`, `STRUCTURE-README.md` | Create/update context files directly |
| `instruction-file-create-update` | `agent` | 9 (search+read+write+fetch) | `.github/instructions/` (conflict detection) | Create/update instruction files directly |

### Deprecated Prompts (.github/prompts/00.00-prompt-engineering/old/)

| Prompt | Status | Replacement |
|---|---|---|
| `prompt-createorupdate-prompt-guidance` | ⚠️ Deprecated | Split into `context-file-create-update` + `instruction-file-create-update` |
| `prompt-createorupdate-promptengineering-guidance` | ⚠️ Deprecated | Split into `context-file-create-update` + `instruction-file-create-update` |

---

## Skills (.github/skills/)

| Skill | Templates | References (outbound) | Referenced By |
|---|---|---|---|
| `prompt-engineering-validation/SKILL.md` | `use-case-challenge.template.md`, `role-validation.template.md`, `tool-alignment.template.md` | `15-adaptive-validation-patterns`, `04-tool-composition-guide`, `01-context-engineering-principles`, `16-artifact-dependency-map`, `artifact-coherence-check` skill | All 10 agents (researchers + validators + builders + updaters + meta agents), validation prompts |
| `artifact-coherence-check/SKILL.md` | `reference-integrity.template.md`, `coherence-report.template.md` | `16-artifact-dependency-map`, `17-artifact-lifecycle-management`, `18-pe-workflow-entry-points`, `01-context-engineering-principles` | `meta-reviewer` agent, meta-prompts |

**Impact note**: The PE-validation skill is the **most-referenced artifact** in the ecosystem. Changes affect 12+ dependent files.

---

## Templates (.github/templates/)

### PE-Specific Templates

| Template | Referenced By |
|---|---|
| `prompt-template.md` | `prompt-builder`, `prompt-create-update` |
| `prompt-simple-validation-template.md` | `prompt-builder`, `prompts.instructions.md` |
| `prompt-implementation-template.md` | `prompt-builder`, `prompts.instructions.md` |
| `prompt-multi-agent-orchestration-template.md` | `prompt-builder`, `prompts.instructions.md` |
| `prompt-analysis-only-template.md` | `prompt-builder`, `prompts.instructions.md` |
| `agent-template.md` | `agent-builder`, `agent-create-update` |
| `skill-template.md` | `skills.instructions.md` |
| `output-prompt-validation-phases.template.md` | `prompt-validator`, `prompt-create-update` |
| `output-agent-validation-phases.template.md` | `agent-validator`, `agent-create-update` |
| `output-guidance-validation-phases.template.md` | `context-file-create-update`, `instruction-file-create-update` |
| `promptengineering-context-structure.template.md` | `context-builder` |
| `promptengineering-instruction-structure.template.md` | `instruction-builder` |

---

## Anti-Patterns

### ❌ Modifying High-Impact Files Without Impact Analysis

**Wrong**: Editing `04-tool-composition-guide.md` and only re-validating the file itself.
**Right**: Check this map → 6+ dependents → re-validate `prompts.instructions.md`, `agents.instructions.md`, PE-validation skill, researchers.

### ❌ Adding References That Create Circular Dependencies

**Wrong**: Context file references an agent file.
**Right**: Dependencies flow upward only: Context → Instructions → Agents/Skills → Prompts.

### ❌ Duplicating Content Instead of Referencing

**Wrong**: Copying tool alignment rules into a new agent file.
**Right**: Reference PE-validation skill: `📖 Use prompt-engineering-validation skill for tool alignment checks`.

---

## Checklist: Before Modifying Any PE Artifact

- [ ] Identified the artifact in this dependency map
- [ ] Counted dependents (Referenced By column)
- [ ] Classified impact level (Low/Medium/High)
- [ ] Planned re-validation for dependents if Medium/High
- [ ] Verified no circular dependency will be introduced
- [ ] Checked for content duplication risk

---

## References

- **Internal**: [02-prompt-assembly-architecture.md](02-prompt-assembly-architecture.md), [03-file-type-decision-guide.md](03-file-type-decision-guide.md), [STRUCTURE-README.md](../STRUCTURE-README.md)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-03-08 | Initial version — complete dependency audit of 40+ PE artifacts | System |
| 1.0.1 | 2026-03-08 | Phase 2 review — verified references after deduplication of 01, 08, instructions | System |
| 1.1.0 | 2026-03-08 | Phase 3 — added meta-reviewer, meta-optimizer agents; artifact-coherence-check skill; updated PE-validation skill references | System |
| 1.2.0 | 2026-03-08 | Phase 4 — added 4 meta-prompts (health-check, coherence-review, optimize, update) to prompt section | System |
| 1.3.0 | 2026-03-08 | Phase 5 — merged 08+09 into single file; updated all references; marked 09 as merged | System |
| 2.0.0 | 2026-03-08 | Phase 5b — renumbered all 18 context files into 5-tier logical grouping (Foundations 01–04, Multi-Agent 05–07, Specialized 08–13, Repo-Specific 14–15, Meta 16–18). Rewrote dependency tables. Updated all cross-references across 50+ files. | System |
