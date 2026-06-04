---
title: "PE-meta issue in-depth analysis"
author: "Dario Airoldi"
date: "2026-05-22"
categories: [issue, prompt-engineering, copilot, command-contract]
description: "In-depth analysis of PE-meta design and review command contracts, vision alignment, and supported command combinations across PE and domain flows, including capability-based option applicability and overlap handling."
status: "open"
version: "1.5.0"
---

# PE-meta issue in-depth analysis

## Table of contents

- [🎯 Context and question](#-context-and-question)
- [🔎 Conversation-derived position](#-conversation-derived-position)
- [📚 Vision and use-case alignment](#-vision-and-use-case-alignment)
- [🧭 Available command surface](#-available-command-surface)
- [⚙️ Supported combinations and boundaries](#️-supported-combinations-and-boundaries)
- [🏗️ Design versus review contract model](#️-design-versus-review-contract-model)
- [✅ Recommended contract for pe-meta and related pe flows](#-recommended-contract-for-pe-meta-and-related-pe-flows)
- [🚀 Next implementation steps](#-next-implementation-steps)
- [📚 References](#-references)

## 🎯 Context and question

This issue examines whether design prompts and review prompts should have the same goal and scope, with differences only in execution process.

Your position is clear and strong:

1. Artifact quality target should be identical for creation and review.
2. Design and review should differ in process, not in intended quality endpoint.
3. Command support and combinations should be explicit and deterministic.

This analysis validates that position against the current PE-meta prompt contracts, the v12 vision, and the use-case catalog.

## 🔎 Conversation-derived position

The current conversation converged on these core decisions:

1. Core review command surface should stay minimal and deterministic, with no redundant mode options when equivalent flags already exist.
2. `--with-deps` means full dependency-aware traversal.
3. `--with-deps-shallow` means first-level dependency checks only.
4. `--dim full` is a valid alias for all applicable dimensions.
5. Option applicability should be capability-based, not command-family-only.

These decisions are coherent and internally consistent. The open gap is not the direction, but final normalization across all prompt contracts and wording.

## 📚 Vision and use-case alignment

Alignment verdict: yes, your position aligns with the vision and the use-case system.

Why it aligns:

1. The vision defines one quality destination: maintain artifacts at peak reliability, effectiveness, and efficiency.
2. The autonomy model distinguishes actions by risk and confidence, not by lower quality standards.
3. Use cases separate operational modes by cost and depth, not by quality ambition.
4. UC-12 explicitly expects dependency-aware full review behavior and cross-dependency checks.
5. UC-02 treats guidance quality as a prerequisite for autonomy, reinforcing a common quality bar.

Implication:

Design and review should share the same quality objective and quality dimensions. They should differ in workflow role:

1. Design: requirements synthesis and initial construction to that target quality.
2. Review: verification, drift detection, and improvement back to that same target quality.

## 🧭 Available command surface

Current PE-meta prompt surface is organized into three layers.

### Core artifact actions

1. `/pe-meta-design`
2. `/pe-meta-create-update`
3. `/pe-meta-review`
4. Type-specific variants:
- `/pe-meta-{type}-design`
- `/pe-meta-{type}-create-update`
- `/pe-meta-{type}-review`

### System orchestration actions

1. `/pe-meta-scheduled-review`
2. `/pe-meta-update`
3. `/pe-meta-release-monitor`
4. `/pe-meta-adherence`

### Domain-routing separation

1. PE-for-PE artifacts stay in `/pe-meta-*` commands.
2. Domain artifacts route to `/pe-con-*` commands.

This separation matches the architecture decision that prompts orchestrate and specialized workers execute.

## ⚙️ Supported combinations and boundaries

The command contract should be explicit per capability and command family.

### Option applicability model

Option ownership is defined by capability class:

1. **Global options** — valid across command families when the operation supports the behavior (for example `--dim`).
2. **Capability-gated options** — available in any command that exposes the required capability (for example plan-only execution, phase skipping, source-research suppression).
3. **Command-specific options** — available only where no meaningful cross-command semantics exist.
4. **Deprecated or alias options** — retained for compatibility with deterministic routing to canonical options.

### Core review commands

Supported:

1. `<target> [--dim <group|D#|full>]`
2. `<target> [--with-deps | --with-deps-shallow]`
3. `<target> [--dim <group|D#|full>] [--with-deps | --with-deps-shallow]`
4. `<target1,target2,...> [--dim <group|D#|full>] [--with-deps | --with-deps-shallow]`

Rejected:

1. `--with-deps` with `--with-deps-shallow` in the same invocation.
2. Context-only dimension groups on non-context targets.
3. Malformed multi-target lists.

### Design and create-update commands

Supported:

1. `<description>` or `<artifact-type> <description>` for design.
2. `<file-path-or-description> [--dim <group>]` for create-update validation scoping.

Conditionally supported (capability-gated):

1. `--plan` when execution includes an apply phase that can be safely suppressed.
2. `--no-research` when explicit file scope and deterministic direct-apply behavior are available.
3. `--skip-*` only for commands that expose equivalent phase boundaries.

Rejected in these commands (until capability is implemented):

1. Dependency traversal flags (`--with-deps`, `--with-deps-shallow`) as first-class user controls.
2. Any option whose required capability is absent in the target command.

### Scheduled and update commands

These are orchestration-rich by design and are the primary owners of controls such as:

1. `--scope`
2. `--mode`
3. `--skip-*` phase controls
4. `--plan`
5. `--no-external`
6. `--no-research`
7. `--incremental`

These controls should remain orchestration-owned by default. Reuse in other commands is allowed only when it adds non-redundant capability and does not duplicate an existing parameter surface.

### Redundancy and overlap handling

Overlaps should be resolved explicitly:

1. Guidance-first behavior is canonicalized to `/pe-meta-adherence`, while `/pe-meta-review` rejects redundant `--mode` usage with deterministic routing guidance.
2. Release monitor orchestration versus targeted `/pe-meta-update` entry paths must have explicit ownership and handoff rules.
3. Legacy or overlapping flags should route to canonical semantics with corrective guidance.

## 🏗️ Design versus review contract model

### What should be the same

Goal and scope intent should be equivalent at quality level:

1. Same target quality bar.
2. Same quality dimensions and invariants, filtered only by artifact applicability.
3. Same vision alignment requirement.

### What should be different

Process and execution posture should differ:

1. Design process:
- requirement challenge
- construction invariant enforcement during build
- synthesis and initial architecture choices

2. Review process:
- read-only assessment (in plan mode)
- defect and drift discovery
- dependency-aware verification
- remediation recommendations and escalation

This difference preserves role clarity without introducing conflicting quality standards.

## ✅ Recommended contract for pe-meta and related pe flows

Adopt this unified principle:

Design and review must share a canonical quality objective and canonical applicability-scoped quality dimensions. They differ only by process role and mutation permissions.

Operational policy:

1. Keep quality objective text parallel between `*-design` and `*-review` prompts per type.
2. Keep scope intent parallel between `*-design` and `*-review` prompts per type.
3. Encode process difference in boundaries and process sections:
- design can construct
- review stays read-only unless routed through apply-capable orchestrators
4. Keep review command surface minimal.
5. Define option applicability by capability class (global, capability-gated, command-specific, deprecated/alias).
6. Keep deterministic invalid-combination behavior and corrective messages.
7. Dismiss, alias, or explicitly justify overlapping command surfaces.

## 🚀 Next implementation steps

1. Normalize wording across all type-specific design and review prompts:
- same quality objective phrasing
- same scope-intent phrasing
- process-specific execution language

2. Add a shared contract snippet for command families:
- core review
- design/create-update
- orchestration

2.1 Add a shared option applicability matrix and reference it from all PE-meta command prompts. (✅ done)

3. Add embedded contract tests in orchestrators:
- accepted combinations
- rejected combinations
- routing to `/pe-con-*` for non-PE artifacts

3.1 Add overlap tests for canonical command routing (for example guidance-first versus adherence entry points). (✅ done with deterministic evidence in 02.39 option-contract artifacts)

4. Add traceability rows in validation status artifacts for:
- design/review quality-objective parity
- option applicability matrix enforcement
- overlap/deprecation routing enforcement

5. Reconcile plan wording to avoid ambiguity around "richer controls" by naming concrete flags, capabilities, and canonical ownership.

## 📚 References

- **[Self-updating prompt engineering: vision and rationale (v12)](../../../../../06.00-idea/self-updating-prompt-engineering/20260515.02-vision.v12.md)** 📘 [Official internal]
Description: Canonical vision document for autonomy, quality objectives, and risk-calibrated process behavior.

- **[Use-case catalog README](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/00-overview.md)** 📘 [Official internal]
Description: Group-level execution map for freshness, quality gates, consumer correctness, and efficiency.

- **[Use-case index JSON](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/usecase-index.json)** 📘 [Official internal]
Description: Machine-readable source of use-case ordering and priority.

- **[UC-12 dependency-aware full review](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/03-consumer-correctness/p0-01-dependency-aware-full-review-usecase.md)** 📘 [Official internal]
Description: Canonical definition of full dependency-aware review behavior and depth.

- **[UC-02 guidance quality assessment](../../../../../06.00-idea/self-updating-prompt-engineering/20260503.02-vision-pe-meta-usecases/02-quality-gates/p0-01-guidance-quality-assessment-usecase.md)** 📘 [Official internal]
Description: Quality gate definition supporting autonomy preconditions.

- **[PE-meta review orchestrator](../../../../../.github/prompts/00.09-pe-meta/pe-meta-review.prompt.md)** 📘 [Official internal]
Description: Core review command grammar and dispatch behavior.

- **[PE-meta design orchestrator](../../../../../.github/prompts/00.09-pe-meta/pe-meta-design.prompt.md)** 📘 [Official internal]
Description: Core design orchestration behavior and type dispatch.

- **[PE-meta create-update orchestrator](../../../../../.github/prompts/00.09-pe-meta/pe-meta-create-update.prompt.md)** 📘 [Official internal]
Description: Build/update orchestration and validation handoff behavior.

- **[PE-meta scheduled review](../../../../../.github/prompts/00.09-pe-meta/pe-meta-scheduled-review.prompt.md)** 📘 [Official internal]
Description: Scheduled orchestration controls (`--scope`, `--mode`) and rotation behavior.

- **[PE-meta update](../../../../../.github/prompts/00.09-pe-meta/pe-meta-update.prompt.md)** 📘 [Official internal]
Description: Rich orchestration contract for phased execution and advanced flags.

- **[PE-meta option applicability matrix](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)** 📘 [Official internal]
Description: Canonical capability-based option applicability contract with alias routing and deterministic unsupported-option guidance.

- **[Workstream D option-contract evidence (JSON)](../../../../../06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.39-validation-status-option-contract/20260522-option-contract-evidence.json)** 📘 [Official internal]
Description: Deterministic accepted/rejected option-combination checks (D-AC-01..D-AC-05, D-RJ-01..D-RJ-05).

- **[Workstream D option-contract evidence (text)](../../../../../06.00-idea/self-updating-prompt-engineering/20260521.01-pe-meta-implementation/02.39-validation-status-option-contract/20260522-option-contract-evidence.txt)** 📘 [Official internal]
Description: Rerunnable execution summary with pass/fail outcomes and check identifiers for traceability rows.

- **[PE-meta adherence](../../../../../.github/prompts/00.09-pe-meta/pe-meta-adherence.prompt.md)** 📘 [Official internal]
Description: Guidance-first adherence matrix behavior that overlaps with guidance-first review semantics.

- **[PE-meta release monitor](../../../../../.github/prompts/00.09-pe-meta/pe-meta-release-monitor.prompt.md)** 📘 [Official internal]
Description: Release-driven orchestration that delegates targeted checks and may overlap with update entry paths.

- **[PE-meta option applicability matrix](../../../../../.github/prompts/00.09-pe-meta/pe-meta-option-applicability-matrix.md)** 📘 [Official internal]
Description: Canonical ownership and compatibility alias policy for overlap-prone capabilities.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
  structure: {status: "not_run", last_run: null}

article_metadata:
  filename: "02-issue-indept-analysis.md"
-->
