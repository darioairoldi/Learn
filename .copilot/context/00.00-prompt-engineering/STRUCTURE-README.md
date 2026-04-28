---
goal: "Map every context file to its purpose, tier, dependencies, consumers, and functional category — enabling deterministic discovery, refactoring-safe references, and category coverage enforcement"
scope:
  covers:
    - "Context file inventory by tier"
    - "Functional categories for cross-artifact references (R-S5 Level 1.5)"
    - "Cross-reference rules for consumers"
    - "Adding/maintaining context files procedures"
  excludes:
    - "Context file content (each file owns its own content)"
    - "Non-PE context folders"
boundaries:
  - "MUST maintain all required_categories with ≥1 mapped file at all times"
  - "MUST be updated when context files are added, renamed, split, or removed"
  - "Category IDs are a contract — renaming a category is a breaking change"
rationales:
  - "Functional categories provide stable semantic identifiers for cross-artifact references (R-S5)"
  - "Single source of truth for category→file mapping reduces blast radius of file renames to one file"
  - "required_categories in metadata makes category contracts enforceable by pre-change guards"
required_categories:
  governance:
    description: "Files that define the system's purpose, capability requirements, quality criteria, and stability rules — the north star that all other tiers validate against"
  validation-rules:
    description: "Files containing enforceable principles, severity-ranked checks, and challenge-based validation methodology for PE artifact quality assurance"
  assembly-architecture:
    description: "Files explaining how Copilot assembles system/user prompts from customization files — injection layers, ordering, execution contexts, variable substitution"
  file-type-guide:
    description: "Files providing decision frameworks for choosing the right artifact type (prompt, agent, instruction, skill, snippet, MCP, Spaces, SDK) with comparison tables and naming conventions"
  tool-alignment:
    description: "Files governing tool selection, mode alignment rules (plan=read-only, agent=read+write), tool count limits, priority hierarchy, and per-tool cost guidance"
  glossary:
    description: "Files providing canonical definitions for PE-specific terms — single source of truth for terminology consistency across all artifacts"
  token-optimization:
    description: "Files covering quantitative thresholds, token budgets, context window management, optimization strategies, and phase budget allocation"
  orchestration-patterns:
    description: "Files describing multi-agent coordination — handoff conventions, orchestrator design patterns, architecture tier decisions, and subagent mechanics"
  agent-patterns:
    description: "Files containing shared structural and behavioral patterns for PE agents — output minimization, handoff validation, escalation protocols, scope control, and complexity gates"
  specialized-patterns:
    description: "Files covering platform-specific features — skill loading, model-specific optimization, agent hooks, MCP servers, Copilot Spaces, SDK integration, and template authoring"
  validation-caching:
    description: "Files defining the validation caching policy — cache duration, staleness detection, dual YAML metadata rules, and skip conditions"
  production-readiness:
    description: "Files specifying production-readiness requirements — response management, error recovery, embedded tests, token budgets, context rot prevention, and template externalization"
  runtime-validation:
    description: "Files providing gate check patterns, goal alignment verification, cumulative progress tracking, and drift detection for multi-phase orchestrator prompts"
  dependency-tracking:
    description: "Files maintaining the complete dependency graph of PE artifacts — outbound references, inbound consumers, impact classification, and blast radius analysis"
  lifecycle-ops:
    description: "Files documenting artifact lifecycle stages (create/review/update/deprecate), workflow entry points, and decision guides for choosing the right prompt or agent"
  audit-trail:
    description: "Files tracking meta-workflow execution history — when each mode was last run, what sources were analyzed, what changes were applied, and staleness detection data"
  effectiveness-tracking:
    description: "Files recording user-reported outcomes from PE workflow executions — practical results that ground rule refinement beyond self-referential validation"
version: "4.0.0"
last_updated: "2026-04-28"
---

# Prompt Engineering Context — Structure Index

**Purpose**: Maps every context file in this folder to its purpose, tier, dependencies, and key consumers. Builder agents, meta-agents, and lifecycle workflows depend on this index to discover, organize, and validate context files.

**Referenced by**: `context-builder`, `context-validator`, `meta-researcher`, `meta-designer`, `meta-validator`, `meta-optimizer`, `context-information-create-update` prompt

---

## Folder Overview

**Location**: `.copilot/context/00.00-prompt-engineering/`

**Scope**: All context engineering principles, patterns, and reference material for creating and maintaining GitHub Copilot customization files (prompts, agents, instructions, skills, hooks, MCP servers, templates).

**File count**: 29 context files + this index

**Token budget**: Each file MUST stay under 2,500 tokens (see `01.06-system-parameters.md`)

---

## Tier Architecture

Context files are organized into six tiers. Dependencies flow upward only — lower tiers MUST NOT reference higher tiers.

```
Tier 5: Meta-Ops (05.01–05.03)     ← System self-improvement
Tier 4: Conventions (04.01–04.04)   ← Validation and production readiness
Tier 3: Specialized (03.01–03.07)   ← Platform-specific patterns
Tier 2: Multi-Agent (02.01–02.03)   ← Orchestration and workflows
Tier 1: Foundations (01.01–01.04)   ← Core principles (highest impact)
Tier 0: Governance (00.01)          ← North star — most stable, rarely changes
```

---

## File Index

### Tier 0: Governance

The north star that defines WHAT the system must do and WHY. All other tiers validate against this. Changes require explicit user approval.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 00.01 | `00.01-governance-and-capability-baseline.md` | North star governance document — system purpose, capability requirements, quality criteria, stability rules, and verification contract. Use case coverage map documenting what the PE system can do, artifact chains per capability, and verification criteria for capability preservation | `meta-validator`, `meta-designer`, `meta-optimizer` |
| 00.02 | `00.02-capability-map.md` | Functional capability map — 5 categories, 20+ use cases with entry points, artifact chains, and verification criteria. Extracted from governance baseline for token budget compliance | `meta-validator`, `meta-designer`, `meta-prompt-engineering-update` |

### Tier 1: Foundations

These files are the highest-impact context files — they're referenced by nearly all instruction files, agents, and prompts (directly or indirectly).

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 01.01 | `01.01-context-engineering-principles.md` | 8 core principles for crafting effective instructions, prompts, and agent personas (narrow scope, early commands, imperative language, boundaries, context minimization, tool scoping, uncertainty management, template externalization) | `prompts.instructions.md`, `agents.instructions.md`, `skills.instructions.md`, PE-validation skill, all agents (indirectly) |
| 01.02 | `01.02-prompt-assembly-architecture.md` | How Copilot assembles system/user prompts from customization files — injection layers, ordering, execution contexts, variable substitution | `prompts.instructions.md`, `agents.instructions.md`, `01.03-file-type-decision-guide`, `03.05-copilot-spaces-patterns`, `03.06-copilot-sdk-integration` |
| 01.03 | `01.03-file-type-decision-guide.md` | Decision flowchart for choosing the right file type (prompt, agent, instruction, skill, snippet, MCP, Spaces, SDK) — comparison table, naming, folder structure, token budgets | `agents.instructions.md`, all creation workflows, `03.04-mcp-server-design-patterns`, `03.05-copilot-spaces-patterns` |
| 01.04 | `01.04-tool-composition-guide.md` | Tool selection, priority hierarchy, L1/L2 architecture, per-tool costs, mode alignment rules, tool sets shorthand, tool count limits | `prompts.instructions.md`, `agents.instructions.md`, PE-validation skill, `prompt-researcher`, `agent-researcher`, `02.02-context-window`, `03.04-mcp-server`, `03.06-copilot-sdk`, `04.02-adaptive-validation` |
| 01.05 | `01.05-glossary.md` | Canonical definitions for all PE-specific terms — single source of truth for terminology across all artifacts | All context files, instruction files, agents, prompts, skills |
| 01.06 | `01.06-system-parameters.md` | All quantitative thresholds, budgets, limits, and timing rules — single source of truth for numeric values | All context files, validators, instruction files |
| 01.07 | `01.07-critical-rules-priority-matrix.md` | Prioritized enforcement rules for PE artifact validation — severity-ranked (CRITICAL/HIGH/MEDIUM/LOW) with canonical sources and affected artifact types. Quick-reference for all validators | All validator agents, `meta-validator`, PE-validation skill |

### Tier 2: Multi-Agent

Patterns for coordinating work across multiple agents in orchestrated workflows.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 02.01 | `02.01-handoffs-pattern.md` | Agent handoff conventions — single responsibility, send/label modes, intermediary reports, reliability checksum, 5 information flow strategies | Orchestrator prompts, `agents.instructions.md`, `02.02-context-window` |
| 02.02 | `02.02-context-window-and-token-optimization.md` | Context rot, 3 failure modes, 9 token optimization strategies, phase budgets, provider caching comparison, deterministic tools decision | `prompts.instructions.md`, orchestrator prompts, multi-agent agents, `03.02-model-specific-optimization` |
| 02.03 | `02.03-orchestrator-design-patterns.md` | When/how to build multi-agent orchestrations — architecture tier decision, 9 design principles, subagent mechanics | Orchestrator agents, multi-agent prompts, `03.03-agent-hooks-reference` |
| 02.04 | `02.04-agent-shared-patterns.md` | Structural patterns shared across all PE agents — output minimization, Phase 0 handoff validation, Phase 0.2 input quality challenge, response management, test scenario structure, boundary section template | All PE agents, `agents.instructions.md` |
| 02.05 | `02.05-agent-workflow-patterns.md` | Behavioral workflow patterns — domain expertise activation, internet research validation, standard escalation protocol, scope control, output schema compliance, complexity gate, tool call discipline | All PE agents, `agents.instructions.md` |

### Tier 3: Specialized

Platform-specific features and integration patterns. Each covers a distinct capability area.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 03.01 | `03.01-progressive-disclosure-pattern.md` | Three-level skill loading system (discovery → instructions → resources) for token-efficient skill design | `skills.instructions.md`, skill creation workflows |
| 03.02 | `03.02-model-specific-optimization.md` | Per-model-family prompt optimization — structural implications, caching behavior, guide references for OpenAI/Anthropic/Google | Prompt files with `model:` field, orchestrator prompts |
| 03.03 | `03.03-agent-hooks-reference.md` | 8 lifecycle events, JSON config schema, I/O protocol for deterministic automation via agent hooks | Agent files using hooks, `02.03-orchestrator-design-patterns`, hook-builder/validator agents |
| 03.04 | `03.04-mcp-server-design-patterns.md` | MCP architecture, decision framework (hooks vs MCP vs tools), implementation patterns | MCP-related prompts, `01.04-tool-composition-guide`, `01.03-file-type-decision-guide` |
| 03.05 | `03.05-copilot-spaces-patterns.md` | Persistent cross-project context via GitHub Copilot Spaces — content types, when to use, complementary role | Cross-project agents, `01.02-prompt-assembly-architecture`, `01.03-file-type-decision-guide` |
| 03.06 | `03.06-copilot-sdk-integration.md` | Consuming PE artifacts from SDK-based applications (Node.js, Python, Go, .NET) outside VS Code | SDK application prompts, `01.02-prompt-assembly-architecture`, `01.04-tool-composition-guide`, `03.04-mcp-server` |
| 03.07 | `03.07-template-authoring-patterns.md` | Template design patterns — audience-aware design, placeholder conventions, category selection, composition, anti-patterns | `templates.instructions.md`, all builder agents, template creation workflows |

### Tier 4: Conventions

Validation, caching, production readiness, and runtime validation patterns.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 04.01 | `04.01-validation-caching-pattern.md` | 7-day validation caching policy — metadata storage, dual YAML rules (never modify top YAML), staleness detection | `prompts.instructions.md`, all validation prompts |
| 04.02 | `04.02-adaptive-validation-patterns.md` | Challenge-based validation methodology — complexity assessment, use case challenge templates, role validation, workflow reliability testing, boundary actionability | PE-validation skill, `prompt-create-update`, `agent-create-update` |
| 04.03 | `04.03-production-readiness-patterns.md` | 6 production-readiness requirements — response management, error recovery, embedded tests, token budgets, context rot prevention, template externalization | `prompts.instructions.md`, `agents.instructions.md`, all builder and validator agents |
| 04.04 | `04.04-orchestrator-runtime-validation.md` | Gate check patterns, goal alignment verification, cumulative progress tracking, and drift detection for multi-phase orchestrator prompts | All orchestrator prompts, `prompt-builder`, `agent-builder` |

### Tier 5: Meta-Ops

System self-improvement infrastructure — dependency tracking, lifecycle management, and workflow entry points.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 05.01 | `05.01-artifact-dependency-map.md` | Complete dependency graph of all PE artifacts — outbound references, inbound consumers, impact classification | Meta agents, meta prompts, all builder agents |
| 05.02 | `05.02-artifact-lifecycle-management.md` | Four-stage lifecycle (create → review → update → deprecate) with triggers, responsible agents, and quality gates per stage | Meta agents, meta prompts, `prompt-design`, `agent-design` |
| 05.03 | `05.03-pe-workflow-entry-points.md` | Decision guide for choosing the right prompt or agent — orchestrator vs standalone, validation, direct agent, meta-prompts | Meta agents, users starting PE workflows |
| 05.04 | `05.04-meta-review-log.md` | Audit trail of meta-workflow executions — tracks when each mode was last run, what sources were analyzed, what changes were applied. Enables staleness detection | `pe-staleness-check` hook, `meta-prompt-engineering-scheduled-review`, `meta-prompt-engineering-update`, `meta-validator` |
| 05.05 | `05.05-practical-effectiveness-log.md` | User-reported outcomes from PE workflow executions — breaks the self-referential validation cycle by grounding rule refinement in practical results | `meta-researcher`, `meta-prompt-engineering-scheduled-review`, `meta-validator` |


---

## Cross-Reference Rules

### Referencing FROM this folder (between context files)

Use individual file references with relative paths:

```markdown
**📖 Related:** [02.01-handoffs-pattern.md](02.01-handoffs-pattern.md)
```

### Referencing TO this folder (from prompts, agents, instructions)

Prefer group references (folder-level) for general guidance:

```markdown
**📖 Complete guidance:** [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)
```

Use individual file references only for section-specific links:

```markdown
**See the 7-day rule:** [validation-caching-pattern.md](.copilot/context/00.00-prompt-engineering/04.01-validation-caching-pattern.md)
```

### Referencing TO this folder by category (PREFERRED for external consumers)

Use category IDs from the Functional Categories table below:

```markdown
Load the `validation-rules` files from `.copilot/context/00.00-prompt-engineering/`
  (see STRUCTURE-README.md → Functional Categories for file mapping).
```

This is preferred over direct file references because:
- Category IDs are stable — they don't change when files are renamed or renumbered
- Category mappings are maintained in one place (this file)
- Artifacts describe what capability they need, not which file implements it

---

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
| `governance` | North star governance, capability map | `00.01-governance-and-capability-baseline.md`, `00.02-capability-map.md` |
| `validation-rules` | Core principles and checks for PE artifact validation | `01.01-context-engineering-principles.md`, `01.07-critical-rules-priority-matrix.md`, `04.02-adaptive-validation-patterns.md` |
| `assembly-architecture` | How Copilot assembles prompts from customization files | `01.02-prompt-assembly-architecture.md` |
| `file-type-guide` | Decision guide for choosing the right artifact type | `01.03-file-type-decision-guide.md` |
| `tool-alignment` | Tool composition, mode alignment, and count limits | `01.04-tool-composition-guide.md` |
| `glossary` | Canonical definitions for all PE-specific terms | `01.05-glossary.md` |
| `token-optimization` | Token budgets, limits, and optimization strategies | `01.06-system-parameters.md`, `02.02-context-window-and-token-optimization.md` |
| `orchestration-patterns` | Multi-agent coordination and handoff patterns | `02.01-handoffs-pattern.md`, `02.03-orchestrator-design-patterns.md` |
| `agent-patterns` | Shared structural and behavioral patterns for agents | `02.04-agent-shared-patterns.md`, `02.05-agent-workflow-patterns.md` |
| `specialized-patterns` | Platform-specific: skills, models, hooks, MCP, Spaces, SDK, templates | `03.01-progressive-disclosure-pattern.md`, `03.02-model-specific-optimization.md`, `03.03-agent-hooks-reference.md`, `03.04-mcp-server-design-patterns.md`, `03.05-copilot-spaces-patterns.md`, `03.06-copilot-sdk-integration.md`, `03.07-template-authoring-patterns.md` |
| `validation-caching` | 7-day validation caching policy and dual YAML rules | `04.01-validation-caching-pattern.md` |
| `production-readiness` | Response management, error recovery, embedded tests | `04.03-production-readiness-patterns.md` |
| `runtime-validation` | Gate checks, goal alignment, drift detection for orchestrators | `04.04-orchestrator-runtime-validation.md` |
| `dependency-tracking` | Artifact dependency graph and impact analysis | `05.01-artifact-dependency-map.md` |
| `lifecycle-ops` | Lifecycle stages, transitions, and workflow entry points | `05.02-artifact-lifecycle-management.md`, `05.03-pe-workflow-entry-points.md` |
| `audit-trail` | Review history, staleness detection, and outcome tracking | `05.04-meta-review-log.md` |
| `effectiveness-tracking` | User-reported workflow outcomes | `05.05-practical-effectiveness-log.md` |

---

## Adding New Context Files

When adding a new file to this folder:

1. **Use the tier prefix** (e.g., `03.08-*.md` for a new Specialized file)
2. **Assign to a tier** based on the content scope
3. **Include required sections**: Purpose, Referenced by, Core content, References, Version History
4. **Verify no duplication** with existing files (single source of truth principle)
5. **Stay under 2,500 tokens**
6. **Update this STRUCTURE-README.md** with the new entry
7. **Update [05.01-artifact-dependency-map.md](05.01-artifact-dependency-map.md)** with the new file's references

---

## Highest-Impact Files (Change with Caution)

Files with 5+ direct consumers — changes require broader re-validation:

| File | Direct consumers | Impact level |
|---|---|---|
| `01.01-context-engineering-principles.md` | 6+ | HIGH |
| `01.04-tool-composition-guide.md` | 6+ | HIGH |
| `01.02-prompt-assembly-architecture.md` | 5+ | HIGH |
| `01.03-file-type-decision-guide.md` | 5+ | HIGH |

Before modifying any HIGH-impact file, consult `05.01-artifact-dependency-map.md` and verify all dependents.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial version — 18 context files indexed across 5 tiers |
| 1.1.0 | 2026-03-11 | Added file 19 (template-authoring-patterns) to Tier 3 |
| 1.2.0 | 2026-03-11 | Added file 20 (production-readiness-patterns) to Tier 4 |
| 1.3.0 | 2026-03-11 | Added file 21 (orchestrator-runtime-validation) to Tier 5 |
| 1.4.0 | 2026-03-11 | Added file 22 (capability-baseline) to Tier 5 |
| 2.0.0 | 2026-03-11 | Renumbered file 22 → 00.01-governance-and-capability-baseline (Tier 0: Governance) |
| 2.1.0 | 2026-03-11 | Renumbered Tier 5 Meta-Ops: 16 → 05.01, 17 → 05.02, 18 → 05.03 |
| 2.2.0 | 2026-03-11 | Renumbered Tier 4 Conventions: 14 → 04.01, 15 → 04.02, 20 → 04.03, 21 → 04.04 |
| 2.3.0 | 2026-03-11 | Renumbered Tier 3 Specialized: 08 → 03.01, 09 → 03.02, 10 → 03.03, 11 → 03.04, 12 → 03.05, 13 → 03.06, 19 → 03.07 |
| 2.4.0 | 2026-03-11 | Renumbered Tier 2 Multi-Agent: 05 → 02.01, 06 → 02.02, 07 → 02.03 |
| 2.5.0 | 2026-03-11 | Renumbered Tier 1 Foundations: 01 → 01.01, 02 → 01.02, 03 → 01.03, 04 → 01.04 |
| 2.6.0 | 2026-03-11 | Added 01.05-glossary (canonical term definitions) and 01.06-system-parameters (quantitative thresholds) to Tier 1 |
| 2.7.0 | 2026-03-11 | Added 01.07-critical-rules-priority-matrix (prioritized enforcement rules for validators) to Tier 1 |
| 2.8.0 | 2026-03-15 | Added 05.05-practical-effectiveness-log (user-reported PE workflow outcomes) to Tier 5. File count 25→26. |
| 2.9.0 | 2026-03-15 | Added 02.04-agent-shared-patterns (output minimization, Phase 0, response management, test scenario, boundary patterns) to Tier 2. File count 26→27. |
| 3.0.0 | 2026-03-19 | Token budget compliance: compressed 01.01 (4,503→2,512), 02.01 (3,640→2,041), 01.04 (3,306→2,446), 04.01 (2,708→1,217). All 27 context files now within 2,500-token budget. |
| 3.1.0 | 2026-03-19 | Batch 2: Added 00.02-capability-map (split from 00.01). Compressed 03.01, 05.02, 01.02, 02.02, 05.03, 03.07. File count 27→29. |
| 3.2.0 | 2026-03-19 | Structural improvements: Added `domain: "prompt-engineering"` to all 29 files. Added `authoritative_sources:` to 15 files with external references. Improved descriptions for 01.02 and 01.03 with higher-signal search keywords. |
| 3.3.0 | 2026-03-20 | Split 02.04-agent-shared-patterns into 02.04 (structural) + 02.05-agent-workflow-patterns (behavioral) for token budget compliance. File count 29→30. |
| 4.0.0 | 2026-04-28 | Added Functional Categories section — 18 categories mapping all 30 context files by capability for robust cross-artifact references (R-S5). Added category-based referencing pattern to Cross-Reference Rules. |
