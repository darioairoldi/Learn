---
title: "PE-meta implementation overview"
author: "Dario Airoldi"
date: "2026-05-21"
version: "1.0.0"
status: "draft"
domain: "prompt-engineering"
categories: [prompt-engineering, ai-agents, copilot, implementation]
description: "Implementation overview of pe-meta artifacts, including roles, scopes, limitations, and validation plans for each artifact type."
goal: "Provide a complete implementation map of pe-meta and define executable validation plans for every artifact type used by the system"
scope:
	covers:
		- "Inventory of all pe-meta implementation artifacts"
		- "Roles, scopes, and limitations for each artifact family"
		- "Validation cases and validation steps for every artifact type"
		- "Operational validation flow for individual artifacts and system-level runs"
	excludes:
		- "Applying artifact fixes"
		- "Changing vision decisions"
		- "Production rollout automation"
boundaries:
	- "This document is implementation guidance, not an execution prompt"
	- "Validation plans define what to check and how, but do not auto-apply changes"
	- "System-level validation must preserve phase ordering: context -> instruction -> agent -> template -> prompt -> hook/snippet -> skill"
rationales:
	- "A complete inventory is required before reliable governance can be automated"
	- "Role/scope/limitation clarity prevents orchestration overlap and hidden ownership gaps"
	- "Per-type validation checklists reduce drift and improve repeatability"
---

# PE-meta implementation overview

## 📋 Table of contents

- [Purpose and operating model 🎯](#purpose-and-operating-model)
- [Artifact inventory used by pe-meta 🏗️](#artifact-inventory-used-by-pe-meta)
- [Validation operating flow ⚙️](#validation-operating-flow)
- [Validation plan by artifact type ✅](#validation-plan-by-artifact-type)
- [Suggested execution order for implementation validation 🚀](#suggested-execution-order-for-implementation-validation)
- [References 📚](#references)

---

## 🎯 Purpose and operating model

This document defines the implementation view of the pe-meta system.

It answers four questions:

1. Which artifacts pe-meta uses.
2. What each artifact is responsible for.
3. What each artifact is allowed to do and not do.
4. How to validate each artifact type consistently.

The implementation model is aligned with the current vision and use-case stack, where validation is dimension-scoped and phase-ordered.

---

## 🏗️ Artifact inventory used by pe-meta

### Implementation artifact families

| Family | Location | Artifact count | Primary role | Scope | Limitations |
|---|---|---:|---|---|---|
| Vision | `06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md` | 1 | Defines system intent, principles, and non-negotiable boundaries | Strategic source of truth | Human-only for strategic changes |
| Use-case catalog | `06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/` | 22 files (README + 21 UCs) | Operationalizes dimensions into concrete review scenarios | Behavior-level validation design | Does not execute changes |
| Context knowledge base | `.copilot/context/00.00-prompt-engineering/` | 35 | Normative rules, patterns, catalogs, logs | Guidance for all runtime decisions | Becomes stale without scheduled/release checks |
| PE instructions | `.github/instructions/pe-*.instructions.md` | 10 | Path-scoped writing and engineering constraints | Artifact-shape and policy enforcement | Instruction scope depends on `applyTo` precision |
| Meta agents | `.github/agents/00.09-pe-meta/` | 5 | Specialized execution roles for research/design/build/validate/optimize | PE-for-PE operations | Each agent constrained by own mode and boundaries |
| Template library | `.github/templates/00.00-prompt-engineering/` | 36 | Standardized report/output and authoring structures | Output consistency and contract shape | Template drift if not versioned and validated |
| Meta prompts | `.github/prompts/00.09-pe-meta/` | 31 | Entry points and orchestrators for type-aware workflows | Invocation and orchestration | Prompt behavior bounded by tools, mode, and handoffs |
| Hooks and scripts | `.github/hooks/` and `.github/hooks/scripts/` | 3 hook defs + 7 scripts | Deterministic health/staleness/reference checks | Local pre/post checks and automation | Disabled/miswired hooks create blind spots |
| Prompt snippets | `.github/prompt-snippets/` | 1 | Reusable instruction fragments | Shared guidance composition | Reuse value depends on naming and reference hygiene |

### Context files used by pe-meta (knowledge base)

All files in `.copilot/context/00.00-prompt-engineering/` are part of the pe-meta knowledge base and are used either directly or by category lookup.

| Group | Files |
|---|---|
| Governance and contracts | `00.01-governance-and-capability-baseline.md`, `00.02-capability-map.md`, `00.03-metadata-contracts.md` |
| Core design principles | `01.01-context-engineering-principles.md`, `01.02-prompt-assembly-architecture.md`, `01.03-file-type-decision-guide.md`, `01.04-tool-composition-guide.md`, `01.05-glossary.md`, `01.06-system-parameters.md`, `01.07-critical-rules-priority-matrix.md` |
| Workflow and orchestration patterns | `02.01-handoffs-pattern.md`, `02.02-context-window-and-token-optimization.md`, `02.03-orchestrator-design-patterns.md`, `02.04-agent-shared-patterns.md`, `02.05-agent-workflow-patterns.md` |
| Runtime and platform patterns | `03.01-progressive-disclosure-pattern.md`, `03.02-model-specific-optimization.md`, `03.03-agent-hooks-reference.md`, `03.04-mcp-server-design-patterns.md`, `03.05-copilot-spaces-patterns.md`, `03.06-copilot-sdk-integration.md`, `03.07-template-authoring-patterns.md` |
| Validation patterns | `04.01-validation-caching-pattern.md`, `04.02-adaptive-validation-patterns.md`, `04.03-production-readiness-patterns.md`, `04.04-orchestrator-runtime-validation.md` |
| Meta operations and tracking | `05.01-artifact-dependency-map.md`, `05.02-artifact-lifecycle-management.md`, `05.03-pe-workflow-entry-points.md`, `05.04-meta-review-log.md`, `05.05-practical-effectiveness-log.md`, `05.06-pe-strategic-review-criteria.md`, `05.07-pe-meta-dimension-catalog.md`, `05.08-pe-meta-type-checklists.md`, `STRUCTURE-README.md` |

### PE instruction files used by pe-meta

| Artifact | Role | Scope (high level) | Limitations |
|---|---|---|---|
| `.github/instructions/pe-common.instructions.md` | Shared PE rules | Cross-artifact baseline conventions | Broad scope can increase coupling |
| `.github/instructions/pe-agents.instructions.md` | Agent authoring constraints | Agent structure and boundaries | Depends on precise enforcement |
| `.github/instructions/pe-prompts.instructions.md` | Prompt authoring constraints | Prompt structure and routing conventions | Can drift from runtime behavior |
| `.github/instructions/pe-context-files.instructions.md` | Context-file constraints | Context structure and rule separation | Requires consistent N-1 adoption |
| `.github/instructions/pe-instruction-files.instructions.md` | Instruction-file constraints | `applyTo` and instruction architecture | Sensitive to overlap errors |
| `.github/instructions/pe-hooks.instructions.md` | Hook authoring constraints | Hook schema and deterministic execution | Hook wiring errors reduce coverage |
| `.github/instructions/pe-skills.instructions.md` | Skill authoring constraints | Skill scope and trigger semantics | Trigger ambiguity can cause misuse |
| `.github/instructions/pe-templates.instructions.md` | Template constraints | Template schema and placeholder quality | Template drift impacts consumers |
| `.github/instructions/pe-prompt-snippets.instructions.md` | Snippet constraints | Snippet reuse and naming rules | Weak naming reduces discoverability |
| `.github/instructions/pe-copilot-instructions-file.instructions.md` | Copilot-instructions governance | Top-level instruction governance | High-impact changes require strict review |

### Meta agents (all artifacts)

| Artifact | Role | Scope (high level) | Limitations |
|---|---|---|---|
| `.github/agents/00.09-pe-meta/pe-meta-researcher.agent.md` | Researches platform/ecosystem change and impact | Change discovery, external/internal evidence, impact framing | Must not apply changes |
| `.github/agents/00.09-pe-meta/pe-meta-designer.agent.md` | Converts findings into implementation plans/specs | Type-aware architecture and change design | Must not apply changes directly |
| `.github/agents/00.09-pe-meta/pe-meta-builder.agent.md` | Creates or updates PE artifacts | Build/edit operations across PE artifact types | Must respect pre/post guards and quality bar |
| `.github/agents/00.09-pe-meta/pe-meta-validator.agent.md` | Validates artifacts across dimensions and modes | Individual, dependency-aware, guidance-first validation | Plan mode; read-only by boundary |
| `.github/agents/00.09-pe-meta/pe-meta-optimizer.agent.md` | Improves efficiency without capability loss | Deduplication, token/routing/reference optimization | Must preserve behavior and compatibility |

### Template artifacts used by pe-meta

| Artifact group | Role | Scope (high level) | Limitations |
|---|---|---|---|
| `.github/templates/00.00-prompt-engineering/output-*.template.md` | Output/report contracts | Standardizes validator/designer/researcher/orchestrator outputs | Schema drift can break downstream parsing |
| `.github/templates/00.00-prompt-engineering/guidance-*.template.md` | Guidance composition templates | Supports consistent guidance authoring | Requires strict placeholder discipline |
| `.github/templates/00.00-prompt-engineering/prompt*.template.md` | Prompt design templates | Prompt structure, validation, orchestration patterns | Over-generalization can dilute type specificity |
| `.github/templates/00.00-prompt-engineering/agent.template.md` and `skill.template.md` | Artifact skeletons | Base shape for agent/skill authoring | Must stay aligned with current metadata contracts |

### Meta prompts (all artifacts)

| Prompt | Role | Scope | Limitations |
|---|---|---|---|
| `.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md` | System-wide orchestrator | Fullcheck, healthcheck, performancecheck | Must follow phase ordering and approval rules |
| `.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md` | Review dispatcher | Type detection, dim parsing, routing | Must stay read-only and type-safe |
| `.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md` | Design dispatcher | Type-aware design orchestration | Must not bypass validation/boundaries |
| `.github/prompts/00.09-pe-meta/pe-meta-create-update.prompt.md` | Create/update dispatcher | Batch and single artifact updates | Must coordinate reconciliation |
| `.github/prompts/00.09-pe-meta/pe-meta-release-monitor.prompt.md` | Release impact monitor | VS Code/Copilot impact and targeted checks | External signal quality can vary |
| `.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md` | Periodic health workflow | Rotating health and staleness checks | Periodic cadence may miss urgent drift |
| `.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md` | Guidance-first adherence matrix | Rule-consumer adherence mapping | Depends on reliable dependency map |
| `.github/prompts/00.09-pe-meta/pe-meta-context-design.prompt.md` | Context design | New context artifact design | Must enforce invariants and category fit |
| `.github/prompts/00.09-pe-meta/pe-meta-context-create-update.prompt.md` | Context create/update | Controlled context modification | Must run pre/post reconciliation |
| `.github/prompts/00.09-pe-meta/pe-meta-context-review.prompt.md` | Context review | Context dimensions and adherence sampling | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-design.prompt.md` | Agent design | New PE agent design | Must enforce tool/handoff integrity |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-create-update.prompt.md` | Agent create/update | Agent changes with guardrails | Must enforce mode/tool alignment |
| `.github/prompts/00.09-pe-meta/pe-meta-agent-review.prompt.md` | Agent review | Agent quality and structural checks | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-instruction-design.prompt.md` | Instruction design | New instruction design | Must enforce `applyTo` precision |
| `.github/prompts/00.09-pe-meta/pe-meta-instruction-create-update.prompt.md` | Instruction create/update | Controlled instruction updates | Must preserve minimization and scope |
| `.github/prompts/00.09-pe-meta/pe-meta-instruction-review.prompt.md` | Instruction review | Structural/strategic review | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-prompt-design.prompt.md` | Prompt design | New prompt design | Must preserve workflow clarity |
| `.github/prompts/00.09-pe-meta/pe-meta-prompt-create-update.prompt.md` | Prompt create/update | Prompt updates | Must preserve argument-hint and phases |
| `.github/prompts/00.09-pe-meta/pe-meta-prompt-review.prompt.md` | Prompt review | Prompt quality checks | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-template-design.prompt.md` | Template design | New template design | Must preserve schema and placeholders |
| `.github/prompts/00.09-pe-meta/pe-meta-template-create-update.prompt.md` | Template create/update | Template updates | Must preserve backward compatibility |
| `.github/prompts/00.09-pe-meta/pe-meta-template-review.prompt.md` | Template review | Template quality checks | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-hook-design.prompt.md` | Hook design | New hook definition | Must satisfy JSON/trigger constraints |
| `.github/prompts/00.09-pe-meta/pe-meta-hook-create-update.prompt.md` | Hook create/update | Hook updates | Must preserve deterministic triggers |
| `.github/prompts/00.09-pe-meta/pe-meta-hook-review.prompt.md` | Hook review | Hook quality checks | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-skill-design.prompt.md` | Skill design | New skill definition | Must preserve progressive disclosure |
| `.github/prompts/00.09-pe-meta/pe-meta-skill-create-update.prompt.md` | Skill create/update | Skill updates | Must preserve scope semantics |
| `.github/prompts/00.09-pe-meta/pe-meta-skill-review.prompt.md` | Skill review | Skill quality checks | Read-only |
| `.github/prompts/00.09-pe-meta/pe-meta-snippet-design.prompt.md` | Snippet design | New snippet design | Must preserve reusability standards |
| `.github/prompts/00.09-pe-meta/pe-meta-snippet-create-update.prompt.md` | Snippet create/update | Snippet updates | Must preserve naming and portability |
| `.github/prompts/00.09-pe-meta/pe-meta-snippet-review.prompt.md` | Snippet review | Snippet quality checks | Read-only |

### Hooks, scripts, and snippets used by pe-meta

| Family | Key artifacts used | Role | Limitations |
|---|---|---|---|
| Hooks | `.github/hooks/pe-healthcheck.json`, `.github/hooks/pe-staleness-check.json`, `.github/hooks/pe-file-modification-tracker.json.disabled` | Event-driven checks | Disabled or stale hooks hide regressions |
| Hook scripts | `.github/hooks/scripts/pe-check-yaml.ps1`, `.github/hooks/scripts/pe-check-references.ps1`, `.github/hooks/scripts/pe-check-tool-alignment.ps1`, `.github/hooks/scripts/pe-check-boundaries.ps1`, `.github/hooks/scripts/pe-healthcheck.ps1`, `.github/hooks/scripts/pe-staleness-check.ps1`, `.github/hooks/scripts/pe-file-modification-tracker.ps1` | Deterministic technical validation | Script portability/execution policy constraints |
| Prompt snippets | `.github/prompt-snippets/security-checklist.md` | Reusable prompt fragment | Must stay synchronized with top-level security rules |

---

## ⚙️ Validation operating flow

Validation should follow a deterministic-first, phase-ordered strategy:

1. Validate structural integrity first.
2. Validate guidance quality and strategic coherence second.
3. Validate efficiency and optimization behavior third.
4. Validate external staleness and release impact last.

System-level ordering:

1. Context files.
2. Instruction files.
3. Agent files.
4. Template files.
5. Prompt files.
6. Hook and snippet files.
7. Skill files.

This ordering is mandatory because consumer adherence checks are invalid when foundation guidance is not yet validated.

---

## ✅ Validation plan by artifact type

### Global validation cases (apply to every artifact)

| Case ID | Case | What to check |
|---|---|---|
| G-01 | Metadata contract | Required YAML fields exist and are coherent |
| G-02 | Reference integrity | Links, file refs, slash commands, handoff targets resolve |
| G-03 | Scope fidelity | Content matches `goal` and `scope.covers`; no out-of-scope expansion |
| G-04 | Boundary compliance | No violation of `boundaries` and role restrictions |
| G-05 | Versioning discipline | `version` and `last_updated` are correctly maintained |

Global steps:

1. Parse YAML frontmatter.
2. Validate required fields for the artifact type.
3. Resolve all references and commands.
4. Compare body behavior against scope and boundaries.
5. Record findings with severity and recommended action.

### Context files (`.copilot/context/00.00-prompt-engineering/*.md`)

Validation cases:

1. C-01 Structure and metadata validity.
2. C-02 Construction invariants: non-redundancy, non-contradiction, clarity, actionability, completeness, layer correctness.
3. C-03 Coverage consistency against agent/prompt usage.
4. C-04 Staleness and source verification.
5. C-05 Category mapping and index integrity (`STRUCTURE-README.md`).

Validation steps:

1. Run structural checks (`D1-metadata` through `D3-token-budget`, `D14-craftsmanship` baseline).
2. Run quality checks (`D6-consistency` through `D11-actionability`) on changed or targeted files.
3. Run cross-coherence (`D17-cross-coherence` peer mode for context layer).
4. Validate category placement and dependency map entry consistency.
5. If changed, confirm downstream consumer adherence sampling.

### Instruction files (`.github/instructions/pe-*.instructions.md`)

Validation cases:

1. I-01 `applyTo` precision and non-overlap.
2. I-02 Rule clarity and contradiction absence.
3. I-03 Prioritization explicitness.
4. I-04 Minimized token footprint with full actionability.

Validation steps:

1. Validate YAML fields and `applyTo` syntax.
2. Check overlaps across instruction files.
3. Run quality checks for clarity/completeness/actionability.
4. Verify references to context guidance resolve and are current.

### Agent files (`.github/agents/00.09-pe-meta/*.agent.md`)

Validation cases:

1. A-01 Agent mode/tool alignment.
2. A-02 Boundary completeness and prohibition compliance.
3. A-03 Handoff contract integrity.
4. A-04 Guidance adherence to loaded context.
5. A-05 Deterministic-first process split and efficiency.

Validation steps:

1. Validate metadata, tool list, and mode compatibility.
2. Verify boundaries include always/ask-first/never semantics where applicable.
3. Resolve handoff agent labels and verify existence.
4. Execute adherence checks against loaded context files.
5. Validate efficiency dimensions (`D20-token-chain` through `D27-model-adherence` as applicable).

### Template files (`.github/templates/00.00-prompt-engineering/*.template.md`)

Validation cases:

1. T-01 Structural schema correctness.
2. T-02 Placeholder completeness and naming consistency.
3. T-03 Output compatibility with consuming prompts/agents.
4. T-04 Backward compatibility for existing workflows.

Validation steps:

1. Validate template metadata and section structure.
2. Enumerate placeholders and verify definitions.
3. Cross-check consumer prompts for expected output schema.
4. Run sample render and compare against expected output format.

### Prompt files (`.github/prompts/00.09-pe-meta/*.prompt.md`)

Validation cases:

1. P-01 Argument-hint and parameter parsing correctness.
2. P-02 Type dispatch correctness.
3. P-03 Phase ordering and mode behavior correctness.
4. P-04 Delegation/handoff correctness.
5. P-05 Scope and boundary safety.

Validation steps:

1. Validate metadata and invocation contract.
2. Run scenario tests for representative commands.
3. Verify type-routing and fallback behavior.
4. Validate adherence to required phase ordering.
5. Validate read-only vs write behavior by mode.

### Hook definitions (`.github/hooks/*.json`) and hook scripts (`.github/hooks/scripts/*.ps1`)

Validation cases:

1. H-01 JSON schema and trigger validity.
2. H-02 Script path and executable command validity.
3. H-03 Check coverage: yaml, references, boundaries, tools, staleness.
4. H-04 Failure-mode behavior (non-zero exits and diagnostics).

Validation steps:

1. Validate hook JSON structure.
2. Validate script existence and entry command consistency.
3. Execute hook scripts on controlled passing/failing fixtures.
4. Confirm diagnostics are actionable and deterministic.

### Prompt snippets (`.github/prompt-snippets/*.md`)

Validation cases:

1. S-01 Reusability and context-independence.
2. S-02 Naming and scope clarity.
3. S-03 Security and policy consistency with top-level guidance.

Validation steps:

1. Validate metadata and naming conventions.
2. Verify snippet insertion points in consumer prompts.
3. Compare snippet content with canonical security guidance.

### Skill files (when used by pe-meta workflows)

Validation cases:

1. K-01 Description accuracy and trigger fitness.
2. K-02 Scope boundaries and non-overlap with prompts.
3. K-03 Progressive disclosure and user intent mapping.

Validation steps:

1. Validate required metadata and description content.
2. Validate scope against neighboring skill/prompt artifacts.
3. Run trigger phrase tests for false positives and false negatives.

### Use-case and vision documents (implementation governance artifacts)

Validation cases:

1. V-01 Version alignment (vision version references are current).
2. V-02 Dimension mapping alignment with `05.07` catalog.
3. V-03 Consistency between use cases and executable prompts.
4. V-04 Completeness of operational scenarios.

Validation steps:

1. Validate metadata and reference integrity.
2. Check that use-case dimension names match dimension catalog.
3. Map each use case to at least one executable prompt pathway.
4. Flag stale references and update plan links.

---

## 🚀 Suggested execution order for implementation validation

Use this run order for a complete implementation audit:

1. Context files: structure + quality + coherence.
2. Instruction files: `applyTo`, minimization, non-contradiction.
3. Agent files: tool/mode, boundaries, adherence.
4. Template files: schema and consumer compatibility.
5. Prompt files: routing, phases, handoffs, scope safety.
6. Hook definitions/scripts: deterministic execution checks.
7. Prompt snippets and skills: reuse and trigger quality.
8. Vision/use-case governance docs: version and mapping consistency.
9. Produce consolidated report with severity-ranked findings and remediation order.

---

## 📚 References

**[Self-updating prompt engineering: vision and rationale (v12)](../20260515.02-vision.v12.md)** 📘 [Official]  
Description (2-4 sentences): Defines the strategic objective, autonomy model, and architecture principles that pe-meta implements. It is the normative source for system boundaries and validation philosophy. Use this when checking whether implementation behavior still reflects strategic intent.

**[pe-meta use cases](../20260503.02-vision-pe-meta-usecases/00-overview.md)** 📘 [Official]  
Description (2-4 sentences): Maps quality dimensions to executable scenarios and invocation examples. It provides the operational bridge between the vision and the prompt/agent artifacts. Use this when designing or validating targeted review workflows.

**[PE context pack structure](../../../.copilot/context/00.00-prompt-engineering/STRUCTURE-README.md)** 📘 [Official]  
Description (2-4 sentences): Indexes the context categories and tracking files consumed by pe-meta. It is the anchor for dependency, lifecycle, and category-level validation. Use this when validating context coverage and dependency map integrity.

**[PE meta dimension catalog](../../../.copilot/context/00.00-prompt-engineering/05.07-pe-meta-dimension-catalog.md)** 📘 [Official]  
Description (2-4 sentences): Defines the full dimension set and applicability model used by validator and review workflows. It is required for dimension-scoped validation and non-applicable dimension skipping. Use this as the authoritative source for `D1-metadata` through `D27-model-adherence` definitions.

**[PE meta type checklists](../../../.copilot/context/00.00-prompt-engineering/05.08-pe-meta-type-checklists.md)** 📘 [Official]  
Description (2-4 sentences): Provides type-specific structural and quality checklists used by design/create/review prompts. It operationalizes quality expectations by artifact type. Use this before validating any individual artifact.

<!--
validations:
	grammar: {status: "not_run", last_run: null}
	readability: {status: "not_run", last_run: null}
	references: {status: "not_run", last_run: null}
	consistency: {status: "not_run", last_run: null}

article_metadata:
	filename: "01-overview.md"
	authoring_phase: "draft"
-->
