---
title: "Review: self-updating PE vision — readability, robustness, completeness"
author: "Dario Airoldi"
date: "2026-04-19"
categories: [prompt-engineering, review]
description: "Post-restructuring review of the vision document. Identifies readability friction, robustness gaps, completeness holes, and limitations that could prevent goal achievement."
---

# Review: self-updating PE vision — readability, robustness, completeness

## Table of contents

- [🔍 Review scope](#-review-scope)
- [📖 Readability findings](#-readability-findings)
- [🛡️ Robustness findings](#️-robustness-findings)
- [📋 Completeness findings](#-completeness-findings)
- [⚠️ Limitations that could prevent goal achievement](#️-limitations-that-could-prevent-goal-achievement)
- [🏗️ Improvement plan](#️-improvement-plan)

## 🔍 Review scope

This review evaluates the current state of [readme.md](readme.md) after the seven-phase restructuring (Phases 1–5 applied, Phase 6 dropped, Phase 7 applied). The document now has: explicit goal, 14 structured rationales, four-layer vision, eight design principles, eight success criteria, ten risks.

The review checks three dimensions:

- **Readability** — Can a reader follow the argument from problem → goal → rationale → vision → principles → boundaries → risks → success? Does the structure help or hinder comprehension?
- **Robustness** — Are the claims defensible? Do the rationales actually support the vision? Are risks addressed honestly? Could a skeptic poke holes?
- **Completeness** — Are there gaps that leave critical questions unanswered? Does the document cover enough to serve as a governing reference for downstream artifacts?

---

## 📖 Readability findings

### R-1: Rationale IDs are non-sequential (MEDIUM)

The rationale numbering skips: R1, R2, R3, R7, then R4, R6, R8, then R5, R9, R10, R12, then R11, R13, R14. There is no R15 and some IDs are out of order within groups. This appears to be an artifact of grouping by category (LLM capabilities got R1/R2/R3/R7, processing strategies got R4/R6/R8, etc.) but the non-sequential numbering creates confusion when someone reads "this relies on R6" — they expect it after R5, not in a different section.

**Impact:** Readers referencing rationales by ID will stumble over the gaps. Downstream artifacts citing "R7" have to explain it's in the first group, not after R6.

**Fix option:** Renumber sequentially R1–R14 within the existing category grouping. Or number by category: R-L1/R-L2/R-L3/R-L4 (LLM), R-P1/R-P2/R-P3 (processing), R-S1/R-S2/R-S3/R-S4 (system), R-G1/R-G2/R-G3 (governance). Category-prefixed IDs make it immediately clear which group a rationale belongs to.

### R-2: Autonomy gradient table appears twice (LOW)

The four-level autonomy gradient table appears in "The goal" section and again in the "Human governance, autonomous execution" design principle. The second instance has slightly different column names ("Level / When it applies / Example" vs. "Autonomy level / Scope / Examples") but conveys the same information.

**Impact:** Readers notice the repetition. It also creates a maintenance risk — if the gradient is updated in one place but not the other, they'll diverge.

**Fix option:** Keep the canonical table in "The goal" (where it's first introduced). In the design principle, reference it: "The autonomy gradient defined in The Goal section determines..."

### R-3: "Two operating levels" and "Two prerequisites" feel disconnected (MEDIUM)

These subsections at the end of "The rationale" section contain important content (architecture vs. quality dimension levels, coupling analysis, clear vision + world access as prerequisites) but they read like appendices to the structured R1–R14 framework above them. The reader transitions from a dense rationale table → a mapping table → suddenly a discursive analysis of quality dimensions and coupling.

**Impact:** The quality dimension analysis and coupling insight are among the document's strongest conceptual contributions, but their placement makes them easy to overlook.

**Fix option:** Consider whether "Two operating levels" belongs better in "The vision" section (since it describes how the vision operates) and "Two prerequisites" belongs in "The goal" section (since they're preconditions for achieving the goal). Alternatively, elevate them to peer subsections: `### Operating levels` and `### Prerequisites` with brief introductory sentences that connect them to the rationale framework.

### R-4: The rationale section is table-heavy (LOW)

Four consecutive rationale tables (LLM capabilities, processing strategies, system infrastructure, governance model) followed by a process-to-rationale mapping table makes the middle of the document very dense. Tables are good for reference but create a wall of structured text that's hard to read linearly.

**Impact:** Readers scanning the document for the first time may skip the tables entirely and miss the design implications. Readers using the document as a reference will find the tables efficient.

**Fix option:** This is acceptable for a governing document — density is the point. Could add a 2-sentence introductory paragraph before each category table to improve scanability, but not strictly necessary.

### R-5: Design principles lack rationale references on some entries (LOW)

"Minimal disruption," "Scoped over exhaustive," "Evidence-based," and "Trust-based adoption" don't have `*Relies on:*` lines, while the other four principles do. This inconsistency makes it unclear whether those principles are ungrounded or simply missing their references.

**Impact:** Minor. A reader who notices the pattern will wonder if the unlabeled principles are less justified.

**Fix option:** Add rationale references: Minimal disruption → R11 (gradient enables quiet operation); Scoped over exhaustive → R9 (dependency graph), R5 (metadata); Evidence-based → R1 (reasoning), R8 (structured contracts); Trust-based adoption → R13 (trust calibration).

---

## 🛡️ Robustness findings

### B-1: Risk assessment is undefined (HIGH)

The document repeatedly says autonomy is determined by "assessed impact × confidence" but never defines how to measure either dimension. What makes a change "high impact"? How does the system calculate "confidence"? Without these definitions, the risk assessment formula is aspirational rather than operational.

A skeptic would ask: "If two different runs of the system produce different risk assessments for the same change, how do you know which one is right?" The document has no answer.

**Impact:** The entire autonomy gradient depends on risk assessment. If risk can't be assessed reliably, the gradient collapses — everything escalates to humans (safe but defeats the efficiency goal) or too much proceeds autonomously (effective but risky).

**Fix option:** The core concept is **breaking vs. non-breaking changes**. A non-breaking change preserves the artifact's declared goal, scope, and boundaries while improving its reliability, effectiveness, or efficiency. A breaking change alters what the artifact is for, what it covers, or what it constrains.

This reframes both risk dimensions concretely:

**Impact** = does the change alter goal, scope, or boundaries?

| Change category | Goal/scope/boundary impact | Impact level |
|---|---|---|
| Non-breaking (content fix, enhanced example, better wording) | Preserved — same goal, same scope, same boundaries | Low — regardless of dependent count |
| Additive non-breaking (deeper coverage within declared scope) | Preserved — stays within declared scope | Low-medium |
| Breaking-additive (extends scope to new topics) | Scope expands | Medium-high — dependents may overlap or conflict |
| Breaking-subtractive (removes coverage) | Scope contracts | High — dependents may rely on removed content |
| Breaking-fundamental (changes goal or relaxes boundaries) | Goal or boundaries change | High — full dependent chain affected |

**Confidence** = can the system verify the change is non-breaking?

| Verification method | Confidence contribution |
|---|---|
| Deterministic comparison of goal/scope/boundary metadata before and after | High — machine-verifiable preservation |
| Multi-pass LLM validation confirms content quality within scope (R2) | Medium-high — probabilistic but cross-checked |
| Deterministic structural checks pass (references resolve, YAML valid, token budget met) (R4) | High — binary pass/fail |
| Change type has historical success rate above threshold (R14) | Medium — statistical, improves over time |

**The key insight:** a non-breaking change that's verified as non-breaking is low risk by definition. The system doesn't need a complex scoring rubric — it needs to determine whether a change preserves or alters goal, scope, and boundaries, and whether that determination is machine-verifiable.

This connects directly to B-5 (goal/scope/boundary metadata): without structured declarations, "is this change non-breaking?" can only be answered by LLM judgment (lower confidence). With structured declarations, it can be answered by deterministic comparison (higher confidence).

Add a subsection in "The goal" or "Design principles" that defines breaking vs. non-breaking changes as the primary risk dimension, with the verification methods above as the confidence dimension.

### B-2: No rollback mechanism for the Execute layer (HIGH)

The Execute layer describes how the system makes changes but is silent on what happens when a change that passed validation turns out to be wrong. If an autonomous change degrades prompt effectiveness in ways the validation pass didn't catch (false confidence — already identified as a risk), how is it reversed?

**Impact:** Without rollback, the Execute layer's safety net is entirely pre-commit validation. If validation has a blind spot (and it will — the "False confidence" risk acknowledges this), there's no recovery path other than manual detection and manual repair. Human-dependent rollback is weak — the human may not understand the impact or recognize the need.

**Fix option:** Introduce **artifact versioning** with two levels that together enable automated rollback without human judgment:

**Individual artifact version (SemVer)** — encodes the breaking/non-breaking signal:

| Change type | SemVer bump | Risk signal |
|---|---|---|
| Content fix, typo, formatting | Patch (1.0.0 → 1.0.1) | Low — non-breaking |
| Enhanced example, deeper coverage within scope | Minor (1.0.0 → 1.1.0) | Low-medium — non-breaking |
| Scope extension, boundary change | Major (1.0.0 → 2.0.0) | High — breaking |
| Goal revision | Major (1.0.0 → 2.0.0) | High — breaking |

SemVer on individual artifacts serves risk assessment (B-1): the bump type is a machine-readable breaking/non-breaking signal that feeds the autonomy gradient.

**Group snapshot version (date-based)** — represents a validated, consistent state of a correlated artifact set (e.g., all files in `.copilot/context/00.00-prompt-engineering/`):

- Format: `YYYYMMDD.NN` (e.g., `2026-04-19.01`, `2026-04-19.02`)
- Bumps whenever any artifact in the group changes
- Records the last validated snapshot — the rollback target

**How rollback works:**

1. Before Execute: system records current group snapshot (`2026-04-19.01`)
2. During Execute: system changes individual artifacts, bumping their SemVer
3. After Execute: system validates the group, creates new snapshot (`2026-04-19.02`)
4. If regression detected (by later validation, human report, or outcome tracking): system reverts all artifacts in the group to their state at `2026-04-19.01` — automatically, without human judgment on what to revert

**Why both levels are needed:** the group snapshot is the rollback unit (what to revert to). The individual SemVer is the risk signal (whether the change was breaking). A group snapshot containing only patch bumps is low risk. A snapshot containing a major bump on any artifact is high risk and the system can use this deterministically.

This connects to B-5 (metadata) — version information is part of artifact metadata. It connects to B-1 (risk assessment) — SemVer bump type maps directly to the breaking/non-breaking classification. It connects to C-3 (audit trail) — version history provides the structured log of what changed and when.

### B-3: Infrastructure metadata integrity — bootstrapping and ongoing staleness (HIGH)

The system depends on infrastructure metadata to make every decision: dependency graph (R9) for scoping, validation history (R10) for caching, goal/scope/boundary declarations (B-5) for risk classification, purpose declarations (R12) for effectiveness evaluation, and outcome data (R14) for threshold tuning. The document only addresses the **bootstrapping** case (metadata doesn't exist yet), but the **ongoing** case is more severe: the system has metadata, it's wrong, and it doesn't know it's wrong.

This is the "silent degradation" problem applied to the self-update system's own inputs. Every decision flows through infrastructure data, and stale data produces wrong decisions silently:

| Infrastructure data | Decision it drives | Failure when stale |
|---|---|---|
| Dependency graph (R9) | Scope validation to affected artifacts | Missing dependency → change to A doesn't trigger validation of B → B silently drifts |
| Validation history (R10) | Skip recently-validated artifacts | Optimistic timestamp → artifact skips needed validation → drift goes undetected |
| Goal/scope/boundary metadata (B-5) | Breaking/non-breaking classification | Wrong scope → breaking change classified as non-breaking → unsafe autonomous execution |
| Purpose declarations (R12) | Evaluate effectiveness | Stale purpose → validates against wrong criteria → passes artifacts that should fail |
| Outcome data (R14) | Tune autonomy thresholds | Misaligned outcomes → thresholds tuned on incorrect signal → system becomes too cautious or too risky |

**Impact:** This is a circular dependency — the system uses metadata to decide what to check, but the metadata itself can drift. Stale infrastructure data causes the system to reason incorrectly without knowing it. This is higher severity than bootstrapping, which is at least a known state (no data = conservative defaults). Silently wrong data is an unknown-wrong state.

**Fix option:** Three-part solution:

**1. Deterministic metadata integrity pre-step.** Before every self-update cycle, run cheap deterministic cross-checks that validate infrastructure data against artifact reality:

| Metadata type | Deterministic consistency check |
|---|---|
| Dependency graph | Grep artifact content for references; compare against declared dependencies → detect missing/phantom dependencies |
| Validation history | Compare content hash at validation time against current hash → detect stale "validated" status |
| Goal/scope metadata | Parse content for topic coverage; compare against declared scope → detect scope drift |
| Boundary metadata | Check measurable constraints (token count, reference count) against declared limits → detect boundary violations |
| Outcome data | Cross-reference logged changes against artifact version history → detect orphaned/misaligned records |

These checks are deterministic (R4), don't require LLM judgment, and catch the most dangerous failure mode: making decisions based on wrong data.

**2. Conservative fallback on integrity failure.** When a metadata integrity check fails, the system treats the metadata as absent — widening validation scope and escalating autonomy level. This follows the Graceful Degradation principle: "the worst outcome should be missed a review opportunity, never applied an incorrect change." Suspect metadata → broader scoping, no autonomous execution until repaired.

The asymmetry is important: stale metadata that's too conservative (wider scope than needed) wastes tokens but is safe. Stale metadata that's too optimistic (narrower scope than needed) is dangerous. The system should always fail toward conservative.

**3. Metadata repair as a first-class finding.** Stale metadata detected by the pre-step enters the same detect → assess → propose → execute pipeline as any other finding. Metadata repair is a non-breaking change (patch version bump in B-2 terms) and can proceed autonomously — making the system self-healing for its own infrastructure.

This connects to B-1 (risk assessment depends on metadata accuracy), B-2 (version metadata is part of the infrastructure that needs integrity checking), B-5 (goal/scope/boundary metadata is a high-value target for integrity validation), and the Graceful Degradation principle (conservative fallback when infrastructure is suspect).

Add to the vision document as either an expansion of the Graceful Degradation principle, a new "Infrastructure integrity" principle, or a new risk in "Risks and tensions" — with the three-part solution as the mitigation.

### B-4: Rationales don't address conflict resolution between themselves (MEDIUM)

R4 (deterministic processing) and R1 (LLM reasoning) can conflict — should a given check use deterministic tools or LLM judgment? R10 (skip recently-validated) can conflict with R7 (detect platform changes that may have invalidated those validations). The document presents all 14 rationales as co-equal strategies but doesn't address what happens when they pull in different directions.

**Impact:** An implementation that follows all rationales simultaneously will hit decision points where two rationales disagree. Without a resolution strategy, the system's behavior becomes unpredictable at those points.

**Why a full linear ranking doesn't work:** Most rationale pairs are **orthogonal** — they operate in different decision spaces and never compete. R9 (dependency graph) and R3 (model specialization) don't conflict. R5 (metadata) and R8 (structured contracts) are complementary. A linear ranking (R2 > R4 > R11 > ...) would imply every pair has a dominant/subordinate relationship, creating false trade-offs where none exist.

**Fix option:** Three-level approach:

**1. Meta-principle** that applies to all conflicts: "When rationales conflict, **safety takes precedence over efficiency**, and **reliability takes precedence over autonomy**."

**2. Specific resolution rules** for each known conflict pair:

| Conflict | Resolution | Reasoning |
|---|---|---|
| R1 (LLM) vs R4 (deterministic) | **R4 wins when both can perform the operation.** LLM only when judgment is required. | Deterministic is cheaper and more reliable. Using LLM where deterministic suffices wastes tokens. |
| R10 (cached = skip) vs R7 (platform changed = re-check) | **R7 wins when there's evidence of platform change.** Re-validate even if cached. | A cached "valid" result against an old platform version is stale by definition. |
| R2 (more validation passes) vs R6 (token budget) | **R2 wins up to the budget, then escalate.** Don't skip validation to save tokens — escalate instead. | Skipping validation to save tokens is explicitly forbidden by the goal. |
| R11 (autonomy gradient) vs R2 (validation) | **R2 is a precondition for R11.** The gradient classifies only after validation has run. | Even autonomous changes require at least one validation pass. |
| R13 (trust = evaluate) vs R11 (high impact = escalate) | **R11 governs the final decision.** Trust reduces assessment cost, not the autonomy threshold. | A trusted source can still produce a high-impact change requiring human approval. |

**3. Acknowledgment that most rationales are orthogonal** and don't need resolution — they operate in different decision spaces. The conflict set is small (~5 pairs out of 91 possible) and bounded. New rationales added in the future would need to be checked for shared decision spaces, not force-ranked.

### B-5: Artifact metadata lacks semantic dimensions for risk scoping (HIGH)

R5 (metadata-driven automation) currently defines metadata as mechanical state: validation timestamps, content hashes, feature dependencies, dependency declarations. R12 (artifact role declaration) adds purpose and success criteria for evaluation. But neither defines **structured goal, scope, and boundary declarations** that the self-update system can parse and use to calibrate risk assessment and validation scope.

This matters because the nature of a change determines how much validation it requires — and the current model can only assess risk by counting dependents (R9). Two changes to the same high-dependency file could have completely different risk profiles:

| Change type | Goal/scope/boundary impact | Validation scope | Risk level |
|---|---|---|---|
| Content fix (typo, example update) | None — stays within declared scope | Artifact only | Low |
| Enhancement (new example, deeper explanation) | None — within scope | Artifact only | Low-medium |
| Scope extension (covers a new topic) | Scope expands | Artifact + all dependents that may now overlap | Medium-high |
| Scope narrowing (removes coverage) | Scope contracts | Artifact + dependents relying on removed coverage | High |
| Goal revision (serves a different purpose) | Goal changes | Full dependent chain + potential gap for old goal | High |
| Boundary change (new or relaxed constraints) | Boundaries change | Artifact + dependents that assumed old boundaries | Medium-high |

With structured goal/scope/boundary metadata, the system gains three capabilities it currently lacks:

1. **Precise risk scoping.** A change that stays within declared scope needs only artifact-level validation, regardless of how many dependents exist. A change that extends scope triggers dependent validation. This is more precise than "count dependents" and cheaper than "validate everything."

2. **Systematic adoption comparison.** When evaluating an external artifact (R13), structured scope metadata enables systematic comparison: same goal + same scope = adoption candidate; overlapping scope + different goal = incorporation candidate; different goal = not a replacement. Currently this comparison is LLM-based and subjective.

3. **Concrete risk assessment input.** The undefined "impact × confidence" formula (B-1) gains a concrete dimension: does this change preserve or alter the artifact's declared goal, scope, and boundaries? Preservation = lower impact. Alteration = higher impact. This directly feeds the autonomy gradient (R11).

**What goal, scope, and boundary mean for artifacts:**

| Field | What it declares | Example |
|---|---|---|
| **Goal** | The single outcome the artifact exists to achieve | "Define strategies for reducing token consumption in multi-agent workflows" |
| **Scope** | What topics the artifact covers and explicitly excludes | "Covers: context window management, optimization strategies. Excludes: model-specific optimization (see 09)" |
| **Boundaries** | Constraints the artifact operates within or enforces | "Max 2,500 tokens. Single source of truth for token budgets." |

**Impact:** Without this, risk assessment remains coarse (B-1), adoption comparison remains subjective, and validation scope defaults to conservative (check all dependents for any change).

**Fix option:** Expand R5 to include goal/scope/boundary metadata alongside mechanical metadata. Connect it to R11 (risk assessment uses goal/scope/boundary preservation as an impact dimension), R12 (purpose declaration becomes operationally parseable), and R13 (adoption comparison uses structured scope matching). Add a note to the "Metadata-driven" design principle explaining the dual role: mechanical metadata for efficiency, semantic metadata for risk precision.

---

## 📋 Completeness findings

### C-1: Maintenance vs. creation boundary is undefined (MEDIUM)

The document says "Generating new artifacts from scratch — that's the creation workflow's job." But it doesn't define where maintenance ends and creation begins. If a VS Code release deprecates an entire feature that a context file documents, does the system update the file (maintenance) or archive it and create a replacement (creation)? If a new platform capability requires a new context file that doesn't exist yet, is proposing it within scope?

**Impact:** The boundary affects the Execute layer's scope. Without it, the system either over-reaches (creating artifacts it shouldn't) or under-reaches (flagging gaps it could address but doesn't because "that's creation").

**Fix option:** Add a clarifying statement in "What self-updating means / doesn't mean." For example: "Maintenance includes updating, restructuring, merging, splitting, or deprecating existing artifacts. Creation of entirely new artifacts — those that don't replace or extend an existing one — is out of scope and should be flagged as a gap for human action."

### C-2: No concurrency or conflict handling (LOW)

What happens when two self-update cycles run concurrently — or when a human edits an artifact while the system is proposing changes to it? The document is silent on race conditions.

**Impact:** Low for current scale (manual invocation). Becomes relevant if the system moves to automated triggers. Two concurrent cycles could propose conflicting changes to the same file.

**Fix option:** Acknowledge in "Risks and tensions" that concurrent modification requires file-level locking or sequential processing. For now, this is acceptable as a future concern.

### C-3: No versioning or audit trail requirement (MEDIUM)

R14 says "log autonomous actions and their outcomes" but the document doesn't establish versioning or audit trail as a requirement. If the system makes 50 autonomous changes over a month, can a human reconstruct what changed, why, and in what order?

**Impact:** The "Auditing outcomes" bullet in the human governance principle depends on an audit trail that the document doesn't require. Without it, outcome auditing is impractical.

**Fix option:** Add an audit trail requirement to the "Metadata-driven" principle or to success criteria: "All autonomous changes produce a structured log entry: what was changed, what triggered it, what rationale justified it, what validation passed, and what the artifact looked like before the change."

### C-4: Human rejection feedback loop is implicit (LOW)

When a human rejects an escalation, that's signal the system should learn from (R14). But this is only implied. The document doesn't explicitly state that rejection + reason is input to the progressive learning loop.

**Fix option:** Add one sentence to R14's design implication or to the "Human governance" principle: "Human rejections, including the stated reason, feed back into the outcome log as negative signal for threshold tuning."

### C-5: Scope ambiguity — Copilot-specific or general? (LOW)

The document mixes Copilot-specific references (YAML frontmatter, VS Code releases, `applyTo` patterns) with general PE principles (context rot, self-correction, dependency graphs). It's unclear whether this vision is for GitHub Copilot PE specifically or for any PE system.

**Impact:** Low — the vision is clearly built for the current Copilot PE system. But if someone tried to apply it to a different PE framework, the Copilot-specific assumptions might mislead.

**Fix option:** Add one sentence early in the document: "This vision is designed for prompt engineering systems built on GitHub Copilot's customization framework (instructions, agents, prompts, context files, skills, templates) but the principles and rationales are transferable to other PE architectures."

---

## ⚠️ Limitations that could prevent goal achievement

These are structural constraints that the document should acknowledge honestly — not as fixable problems, but as inherent limitations of the approach.

### L-1: Validation can't catch effectiveness regressions

The document acknowledges this partially in "False confidence." But it understates the severity. Validation (R2) can check structural integrity, reference soundness, and internal consistency. It **cannot** check whether a prompt still produces good output after a change. Effectiveness is only measurable through actual use — and the self-update system doesn't have access to user-facing outcomes.

**Implication for goal achievement:** The goal says artifacts should be "effective." The system can maintain reliability and efficiency, but effectiveness can only be validated indirectly (structural proxies) or through human judgment. This is a permanent limitation, not a temporary one.

**Suggested acknowledgment:** Add to "Risks and tensions" or strengthen the existing "False confidence" entry to be explicit that effectiveness validation is a hard boundary for autonomous operation.

### L-2: Self-updates to system components carry amplified risk

The self-update system's operational components — context files encoding model guidance and token strategies, agents implementing review and optimization workflows, prompts orchestrating the update cycle, skills defining validation rules — are themselves PE artifacts. The system can update them through the same detect → assess → propose → execute pipeline it applies to any artifact, subject to the same breaking/non-breaking classification.

The system **can** update itself when:
- A new model is released → update model-specific guidance (non-breaking, within scope)
- Context window sizes change → update token optimization strategies (non-breaking, data update)
- A new platform tool becomes available → propose agent redesign to leverage it (breaking, human approval)
- Validation best practices evolve → update validation rules and skills (scope-dependent)

The system **cannot** update:
- The **vision** (goals, definitions) — changing what "better" means removes the reference point for evaluating all other changes
- The **meta-principles** (safety > efficiency, reliability > autonomy) — changing these would let the system justify unsafe changes by redefining "safe"
- The **risk threshold boundaries** — loosening its own autonomy thresholds without human consent would be self-escalation

**The real risk is amplified blast radius, not impossibility.** A bug in a regular context file affects the prompts that reference it. A bug in the system's own model guidance affects every decision the system makes next — including its ability to detect the bug. This is the B-3 circular dependency applied to content: the system reasons using its own components, and if those components are wrong, its reasoning is wrong.

**Implication for goal achievement:** Self-updates to system components should be treated with **elevated risk classification** — not banned. The breaking/non-breaking framework still applies, but the impact dimension is higher because of the amplified blast radius. A non-breaking update to the system's own model guidance (new data within declared scope) is low-risk. A breaking update to validation logic (scope change) is high-risk and requires human approval plus extended validation.

**Mitigations already in the framework:**
- R2 (multi-pass validation) — second pass by a different model catches judgment errors
- B-3 (integrity pre-step) — deterministic checks catch structural problems in self-updated components
- R14 (outcome tracking) — if self-updates correlate with quality drops, the system detects the pattern
- B-2 (rollback) — if a self-update causes regression, revert to previous group snapshot

**Suggested acknowledgment:** Replace the blanket "system can't update itself" framing with: "The system can update its own operational components through the standard pipeline, but these updates carry amplified blast radius and receive elevated risk classification. Updates to the vision, meta-principles, and risk threshold boundaries are human-only — these define the fixed points the system validates against."

### L-3: Token cost of comprehensive reasoning

The nine-step workflow (search through iterate) applied to a large artifact set is expensive. Even with scoping (R9), caching (R10), and deterministic processing (R4), the reasoning steps (R1) consume significant tokens. A monthly VS Code release that affects 30% of artifacts could trigger thousands of tokens in analysis alone.

**Implication for goal achievement:** Success criterion 7 says "cost stays bounded." But the document doesn't discuss what happens when the artifact set grows beyond the point where continuous monitoring is affordable. Is there a degradation strategy? Does the system prioritize high-dependency artifacts and skip leaf nodes?

**Suggested acknowledgment:** Strengthen the "Cost of vigilance" risk with a concrete degradation strategy: priority tiers for artifacts, where high-dependency files are always checked and leaf artifacts are checked on a longer cadence.

---

## 🏗️ Improvement plan

### Priority 1: Address robustness gaps (HIGH impact)

| # | Finding | Action | Section affected |
|---|---------|--------|-----------------|
| B-1 | Risk assessment undefined | Add risk assessment dimensions — include goal/scope/boundary preservation as a concrete impact indicator alongside dependent count and change type | The goal or Design principles |
| B-2 | No rollback mechanism | Add rollback/recovery consideration to the Execute layer or Design principles | The vision → Execute, or Design principles |
| B-3 | Infrastructure metadata integrity | Add metadata integrity pre-step (deterministic cross-validation), conservative fallback on integrity failure, metadata repair as first-class finding. Expand Graceful Degradation or add new principle. | Design principles or Risks and tensions |
| B-5 | Artifact metadata lacks semantic dimensions | Expand R5 to include goal/scope/boundary declarations; connect to R11 (risk input), R12 (operationalized purpose), R13 (adoption comparison); update Metadata-driven principle | The rationale → R5, R12; Design principles → Metadata-driven |

### Priority 2: Address completeness gaps (MEDIUM impact)

| # | Finding | Action | Section affected |
|---|---------|--------|-----------------|
| C-1 | Maintenance vs. creation boundary | Add clarifying statement defining the boundary | What self-updating means |
| C-3 | No audit trail requirement | Add audit trail to Metadata-driven principle or success criteria | Design principles or Success criteria |
| L-1 | Effectiveness validation is a hard limit | Strengthen "False confidence" to name this explicitly | Risks and tensions |
| L-2 | System can't update itself | Add as a named risk | Risks and tensions |

### Priority 3: Improve readability (LOW-MEDIUM impact)

| # | Finding | Action | Section affected |
|---|---------|--------|-----------------|
| R-1 | Non-sequential rationale IDs | Renumber or adopt category-prefixed IDs | The rationale |
| R-2 | Duplicated autonomy table | Remove the second instance, reference the first | Design principles |
| R-3 | Floating "Two operating levels" / "Two prerequisites" | Relocate or connect more explicitly to surrounding structure | The rationale |
| R-5 | Missing rationale refs on some principles | Add `*Relies on:*` lines to all eight principles | Design principles |

### Priority 4: Minor completeness (LOW impact)

| # | Finding | Action | Section affected |
|---|---------|--------|-----------------|
| B-4 | No rationale conflict resolution | Add brief resolution principle | The rationale or Design principles |
| C-2 | No concurrency handling | Acknowledge as future concern | Risks and tensions |
| C-4 | Implicit rejection feedback loop | Make explicit in R14 or Human governance | The rationale or Design principles |
| C-5 | Scope ambiguity | Add one clarifying sentence | The problem or The goal |
| L-3 | Token cost at scale | Add degradation strategy to Cost of vigilance | Risks and tensions |

### Execution notes

- Priority 1 items are structural gaps that weaken the document's defensibility. They should be addressed before the document is used as a governing reference.
- Priority 2 items are completeness gaps that leave important questions unanswered. They can be addressed alongside or shortly after Priority 1.
- Priority 3 items are readability improvements that make the document easier to follow. They're polish, not structural.
- Priority 4 items are minor. They improve completeness but the document functions without them.

Total estimated additions: ~400–600 words across all priorities. The document should remain under 4,500 words after all changes.

<!--
article_metadata:
  filename: "01-readme-update-plan1.md"
  created: "2026-04-19"
  type: "review"
  status: "draft"
-->
