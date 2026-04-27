# Prompt Engineering Context — Structure Index

**Purpose**: Maps every context file in this folder to its purpose, tier, dependencies, and key consumers. Builder agents, meta-agents, and lifecycle workflows depend on this index to discover, organize, and validate context files.

**Referenced by**: `pe-context-builder`, `pe-context-validator`, `pe-meta-researcher`, `pe-meta-designer`, `pe-meta-validator`, `pe-meta-optimizer`, `pe-context-information-create-update` prompt

---

## Folder Overview

**Location**: `.copilot/context/00.00-prompt-engineering/`

**Scope**: All context engineering principles, patterns, and reference material for creating and maintaining GitHub Copilot customization files (prompts, agents, instructions, skills, hooks, MCP servers, templates).

**File count**: 30 context files + this index

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
| 00.01 | `00.01-governance-and-capability-baseline.md` | North star governance document — system purpose, capability requirements, quality criteria, stability rules, and verification contract. Use case coverage map documenting what the PE system can do, artifact chains per capability, and verification criteria for capability preservation | `pe-meta-validator`, `pe-meta-designer`, `pe-meta-optimizer` |
| 00.02 | `00.02-capability-map.md` | Functional capability map — 5 categories, 20+ use cases with entry points, artifact chains, and verification criteria. Extracted from governance baseline for token budget compliance | `pe-meta-validator`, `pe-meta-designer`, `pe-meta-prompt-engineering-update` |
| 00.03 | `00.03-metadata-contracts.md` | Canonical metadata schema for all PE artifact types — required YAML fields (goal, scope, boundaries, rationales, version), placement rules, metadata-guarded change protocol, validation rules | All builder agents, all validator agents, all create-update prompts, `pe-meta-validator`, `pe-meta-optimizer` |

### Tier 1: Foundations

These files are the highest-impact context files — they're referenced by nearly all instruction files, agents, and prompts (directly or indirectly).

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 01.01 | `01.01-context-engineering-principles.md` | 8 core principles for crafting effective instructions, prompts, and agent personas (narrow scope, early commands, imperative language, boundaries, context minimization, tool scoping, uncertainty management, template externalization) | `pe-prompts.instructions.md`, `pe-agents.instructions.md`, `pe-skills.instructions.md`, PE-validation skill, all agents (indirectly) |
| 01.02 | `01.02-prompt-assembly-architecture.md` | How Copilot assembles system/user prompts from customization files — injection layers, ordering, execution contexts, variable substitution | `pe-prompts.instructions.md`, `pe-agents.instructions.md`, `01.03-file-type-decision-guide`, `03.05-copilot-spaces-patterns`, `03.06-copilot-sdk-integration` |
| 01.03 | `01.03-file-type-decision-guide.md` | Decision flowchart for choosing the right file type (prompt, agent, instruction, skill, snippet, MCP, Spaces, SDK) — comparison table, naming, folder structure, token budgets | `pe-agents.instructions.md`, all creation workflows, `03.04-mcp-server-design-patterns`, `03.05-copilot-spaces-patterns` |
| 01.04 | `01.04-tool-composition-guide.md` | Tool selection, priority hierarchy, L1/L2 architecture, per-tool costs, mode alignment rules, tool sets shorthand, tool count limits | `pe-prompts.instructions.md`, `pe-agents.instructions.md`, PE-validation skill, `pe-prompt-researcher`, `pe-agent-researcher`, `02.02-context-window`, `03.04-mcp-server`, `03.06-copilot-sdk`, `04.02-adaptive-validation` |
| 01.05 | `01.05-glossary.md` | Canonical definitions for all PE-specific terms — single source of truth for terminology across all artifacts | All context files, instruction files, agents, prompts, skills |
| 01.06 | `01.06-system-parameters.md` | All quantitative thresholds, budgets, limits, and timing rules — single source of truth for numeric values | All context files, validators, instruction files |
| 01.07 | `01.07-critical-rules-priority-matrix.md` | Prioritized enforcement rules for PE artifact validation — severity-ranked (CRITICAL/HIGH/MEDIUM/LOW) with canonical sources and affected artifact types. Quick-reference for all validators | All validator agents, `pe-meta-validator`, PE-validation skill |

### Tier 2: Multi-Agent

Patterns for coordinating work across multiple agents in orchestrated workflows.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 02.01 | `02.01-handoffs-pattern.md` | Agent handoff conventions — single responsibility, send/label modes, intermediary reports, reliability checksum, 5 information flow strategies | Orchestrator prompts, `pe-agents.instructions.md`, `02.02-context-window` |
| 02.02 | `02.02-context-window-and-token-optimization.md` | Context rot, 3 failure modes, 9 token optimization strategies, phase budgets, provider caching comparison, deterministic tools decision | `pe-prompts.instructions.md`, orchestrator prompts, multi-agent agents, `03.02-model-specific-optimization` |
| 02.03 | `02.03-orchestrator-design-patterns.md` | When/how to build multi-agent orchestrations — architecture tier decision, 9 design principles, subagent mechanics | Orchestrator agents, multi-agent prompts, `03.03-agent-hooks-reference` |
| 02.04 | `02.04-agent-shared-patterns.md` | Structural patterns shared across all PE agents — output minimization, Phase 0 handoff validation, Phase 0.2 input quality challenge, response management, test scenario structure, boundary section template | All PE agents, `pe-agents.instructions.md` |
| 02.05 | `02.05-agent-workflow-patterns.md` | Behavioral workflow patterns — domain expertise activation, internet research validation, standard escalation protocol, scope control, output schema compliance, complexity gate, tool call discipline | All PE agents, `pe-agents.instructions.md` |

### Tier 3: Specialized

Platform-specific features and integration patterns. Each covers a distinct capability area.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 03.01 | `03.01-progressive-disclosure-pattern.md` | Three-level skill loading system (discovery → instructions → resources) for token-efficient skill design | `pe-skills.instructions.md`, skill creation workflows |
| 03.02 | `03.02-model-specific-optimization.md` | Per-model-family prompt optimization — structural implications, caching behavior, guide references for OpenAI/Anthropic/Google | Prompt files with `model:` field, orchestrator prompts |
| 03.03 | `03.03-agent-hooks-reference.md` | 8 lifecycle events, JSON config schema, I/O protocol for deterministic automation via agent hooks | Agent files using hooks, `02.03-orchestrator-design-patterns`, pe-hook-builder/validator agents |
| 03.04 | `03.04-mcp-server-design-patterns.md` | MCP architecture, decision framework (hooks vs MCP vs tools), implementation patterns | MCP-related prompts, `01.04-tool-composition-guide`, `01.03-file-type-decision-guide` |
| 03.05 | `03.05-copilot-spaces-patterns.md` | Persistent cross-project context via GitHub Copilot Spaces — content types, when to use, complementary role | Cross-project agents, `01.02-prompt-assembly-architecture`, `01.03-file-type-decision-guide` |
| 03.06 | `03.06-copilot-sdk-integration.md` | Consuming PE artifacts from SDK-based applications (Node.js, Python, Go, .NET) outside VS Code | SDK application prompts, `01.02-prompt-assembly-architecture`, `01.04-tool-composition-guide`, `03.04-mcp-server` |
| 03.07 | `03.07-template-authoring-patterns.md` | Template design patterns — audience-aware design, placeholder conventions, category selection, composition, anti-patterns | `pe-templates.instructions.md`, all builder agents, template creation workflows |

### Tier 4: Conventions

Validation, caching, production readiness, and runtime validation patterns.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 04.01 | `04.01-validation-caching-pattern.md` | 7-day validation caching policy — metadata storage, dual YAML rules (never modify top YAML), staleness detection | `pe-prompts.instructions.md`, all validation prompts |
| 04.02 | `04.02-adaptive-validation-patterns.md` | Challenge-based validation methodology — complexity assessment, use case challenge templates, role validation, workflow reliability testing, boundary actionability | PE-validation skill, `pe-prompt-create-update`, `pe-agent-create-update` |
| 04.03 | `04.03-production-readiness-patterns.md` | 6 production-readiness requirements — response management, error recovery, embedded tests, token budgets, context rot prevention, template externalization | `pe-prompts.instructions.md`, `pe-agents.instructions.md`, all builder and validator agents |
| 04.04 | `04.04-orchestrator-runtime-validation.md` | Gate check patterns, goal alignment verification, cumulative progress tracking, and drift detection for multi-phase orchestrator prompts | All orchestrator prompts, `pe-prompt-builder`, `pe-agent-builder` |

### Tier 5: Meta-Ops

System self-improvement infrastructure — dependency tracking, lifecycle management, and workflow entry points.

| # | File | Purpose | Key Consumers |
|---|---|---|---|
| 05.01 | `05.01-artifact-dependency-map.md` | Complete dependency graph of all PE artifacts — outbound references, inbound consumers, impact classification | Meta agents, meta prompts, all builder agents |
| 05.02 | `05.02-artifact-lifecycle-management.md` | Four-stage lifecycle (create → review → update → deprecate) with triggers, responsible agents, and quality gates per stage | Meta agents, meta prompts, `pe-prompt-design`, `pe-agent-design` |
| 05.03 | `05.03-pe-workflow-entry-points.md` | Decision guide for choosing the right prompt or agent — orchestrator vs standalone, validation, direct agent, meta-prompts | Meta agents, users starting PE workflows |
| 05.04 | `05.04-meta-review-log.md` | Audit trail of meta-workflow executions — tracks when each mode was last run, what sources were analyzed, what changes were applied. Enables staleness detection | `pe-staleness-check` hook, `pe-meta-prompt-engineering-scheduled-review`, `pe-meta-prompt-engineering-update`, `pe-meta-validator` |
| 05.05 | `05.05-practical-effectiveness-log.md` | User-reported outcomes from PE workflow executions — breaks the self-referential validation cycle by grounding rule refinement in practical results | `pe-meta-researcher`, `pe-meta-prompt-engineering-scheduled-review`, `pe-meta-validator` |


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
