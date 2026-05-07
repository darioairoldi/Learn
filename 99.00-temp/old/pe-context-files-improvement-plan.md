# PE artifact analysis and context file improvement plan

## 🎯 Objective

Reach best effectiveness, reliability, and efficiency for context files and the broader PE artifact system — covering coverage, structure, consistency, autonomous update support, and token optimization.

---

## 📋 Analysis summary by artifact type

### Context files (`.copilot/context/00.00-prompt-engineering/`, 18 files)

**Strengths:**
- Comprehensive topic coverage: foundations (01–04), multi-agent (05–07), specialized (08–13), repo-specific (14–15), meta (16–18)
- Clean tiered architecture with explicit dependency map (file 16)
- Consistent document structure: Purpose → Referenced by → Core content → References → Version History
- Single-source-of-truth principle explicitly stated and mostly followed
- Token budgets, tool alignment rules, and boundary patterns are well-documented in canonical locations
- Lifecycle management (file 17) and workflow entry points (file 18) support autonomous review/update cycles

**Weaknesses:**

| # | Issue | Severity | Files affected |
|---|---|---|---|
| C1 | **File 01 is oversized** — `01-context-engineering-principles.md` is ~400 lines (~2,400 tokens), close to the 2,500 budget. It bundles 8 principles + token budgets + anti-patterns + application-by-type. Principle 7 (Uncertainty) and Principle 8 (Templates) were appended later and feel bolted on, with redundant sections (e.g., data-gap templates repeated in both P7 and P8). | HIGH | 01, all dependents |
| C2 | **Redundancy between files 05 and 06** — "Reliability Checksum" content appears in both `05-handoffs-pattern.md` and `06-context-window-and-token-optimization.md`. File 06 has a cross-reference to 05 but still includes its own summary, violating single-source-of-truth. | MEDIUM | 05, 06 |
| C3 | **Redundancy between files 03 and 02** — Token budget guidelines for instructions appear in both `03-file-type-decision-guide.md` (table) and `01-context-engineering-principles.md` (detailed section). Two sources of truth for the same numbers. | MEDIUM | 01, 03 |
| C4 | **No explicit priority ranking across principles** — The 8 principles in file 01 are numbered but not ranked by importance. When principles conflict (e.g., "context minimization" vs "explicit uncertainty management" adding content), there's no tie-breaking guidance. | MEDIUM | 01 |
| C5 | **Missing "Referenced by" accuracy** — Several context files declare generic "Referenced by" (e.g., "All prompt files") but the dependency map (file 16) has precise data. The in-file "Referenced by" headers are often stale or vague. | MEDIUM | Most context files |
| C6 | **File 15 is example-heavy** — `15-adaptive-validation-patterns.md` is dominated by three long worked examples (~150+ lines of use-case challenge walkthroughs). These examples could be moved to templates, keeping the pattern description lean. | MEDIUM | 15 |
| C7 | **Inconsistent cross-reference format** — Some files use `📖 Complete guidance:` pattern, others use `**📖 Related guidance:**`, and some use plain markdown links. No single convention is enforced. | LOW | All context files |
| C8 | **No freshness/staleness indicator** — Version history exists but there's no automated way to detect which files haven't been updated since VS Code/Copilot features changed. File 12 (Copilot Spaces) says "Public preview (February 2026)" — this may already be GA. | MEDIUM | 12, 13, others |
| C9 | **Context files lack actionable "rules vs. guidance" separation** — Most files mix MUST/SHOULD rules with explanatory guidance and examples in a linear flow. A prompt consuming a context file can't quickly extract only the rules it needs. | HIGH | All context files |
| C10 | **Incomplete coverage: no context file for prompt-snippet patterns** — File 02 and 06 mention prompt-snippets briefly but there's no dedicated context file for when/how to create effective prompt-snippets, despite `.github/prompt-snippets/` existing. | LOW | 02, 06 |

### Instruction files (`.github/instructions/`, 4 PE-relevant)

**Strengths:**
- Correct `applyTo` scoping ensures auto-injection into the right files
- Lean by design — reference context files via `📖` folder links rather than embedding content
- Consistent structure: Purpose → Principles (summary) → Tool Selection → Templates → Best Practices

**Weaknesses:**

| # | Issue | Severity |
|---|---|---|
| I1 | `prompts.instructions.md` mentions `@prompt-create-orchestrator` which doesn't exist (should be `prompt-design` prompt). Stale reference. | HIGH |
| I2 | `agents.instructions.md` also mentions `@prompt-create-orchestrator`. Same stale reference. | HIGH |
| I3 | `agents.instructions.md` embeds a "Six Essential Agents" section from a 2,500-repo analysis — this is informational/example content that belongs in a context file, not an always-injected instruction file consuming tokens on every agent conversation. | MEDIUM |
| I4 | `context-files.instructions.md` shows an outdated "Current Structure" example that doesn't match the actual 18-file numbered structure in `.copilot/context/00.00-prompt-engineering/`. | MEDIUM |
| I5 | No instruction file for template files (`.github/templates/`). Templates are mentioned in `prompts.instructions.md` and `agents.instructions.md` but there's no `templates.instructions.md` with naming conventions and structure requirements auto-injected when editing templates. | LOW |

### Agent files (`.github/agents/00.00 prompt-engineering/`, 12 files)

**Strengths:**
- Clean role specialization: researcher (plan) → builder (agent) → validator (plan) → updater (agent)
- Tool alignment is correct across all sampled agents
- Three-tier boundaries present and well-structured
- Handoff chains form valid DAGs with no circular references
- Meta-agents (meta-reviewer, meta-optimizer) enable system self-improvement

**Weaknesses:**

| # | Issue | Severity |
|---|---|---|
| A1 | No agent for template creation/update — `context-builder` and `instruction-builder` exist but there's no `template-builder` despite templates being a core artifact type. | LOW |
| A2 | Agents don't declare `agents:` array restrictions — most default to `['*']`, meaning any agent can invoke any other. In production, specialist agents should have `agents: []` to prevent recursive invocation. | MEDIUM |

### Prompt files (`.github/prompts/00.00-prompt-engineering/`, 8 active + 2 deprecated)

**Strengths:**
- Clear orchestrator vs standalone distinction
- Parameterized meta-review prompt (`meta-prompt-engineering-review`) with scope+dimension parsing
- Deprecated prompts properly marked and moved to `old/`
- `prompt-create-update.prompt.md` is comprehensive with 5 test scenarios, error recovery, and response management

**Weaknesses:**

| # | Issue | Severity |
|---|---|---|
| P1 | Deprecated prompts in `old/` have no removal date or grace period documented. | LOW |
| P2 | `prompt-create-update.prompt.md` is very long — the inline process spans 100+ lines. Some phases could reference templates more aggressively. | MEDIUM |

### Skill files (`.github/skills/`, 2 PE skills)

**Strengths:**
- `prompt-engineering-validation` skill is the most-referenced artifact; well-structured with 9 workflows
- `artifact-coherence-check` skill provides systematic cross-artifact validation
- Both include bundled templates

**Weaknesses:**

| # | Issue | Severity |
|---|---|---|
| S1 | `artifact-coherence-check` SKILL.md references `coherence-report.template.md` and `reference-integrity.template.md` in its dependency map entry, but I haven't verified these files exist. | MEDIUM |

### Template files (`.github/templates/`, 26+)

**Strengths:**
- Rich library covering output formats, input schemas, document structures, and guidance
- Naming convention (`output-*`, `input-*`, `guidance-*`) is clear and documented

**Weaknesses:**

| # | Issue | Severity |
|---|---|---|
| T1 | No instruction file auto-injected when editing templates — conventions are documented only in `prompts.instructions.md` and `agents.instructions.md`. | LOW |
| T2 | No inventory or index file listing all available templates with purpose summaries — users must scan the folder. | LOW |

---

## 📋 Autonomous update cycle support

| Artifact type | Autonomous update supported? | Mechanism | Gap |
|---|---|---|---|
| **Context files** | ✅ Yes | `meta-reviewer` → `meta-optimizer` → `prompt-validator` | Triggered manually via `/meta-prompt-engineering-review`. No scheduled/automated trigger. |
| **Instruction files** | ✅ Yes | `instruction-builder` → `prompt-validator` | Same — manual trigger only. |
| **Agent files** | ✅ Yes | `agent-validator` ↔ `agent-updater` cycle | Validation loop exists but no automatic freshness check. |
| **Prompt files** | ✅ Yes | `prompt-validator` ↔ `prompt-updater` cycle | Same as agents. |
| **Skill files** | ⚠️ Partial | No dedicated skill-builder/updater agent | Skills must be manually updated. Validation is indirect via PE-validation skill. |
| **Template files** | ❌ No | No builder, validator, or update mechanism | Templates are entirely manual. No validation, no lifecycle management. |

**Key gap:** While the *machinery* for autonomous updates exists (meta-reviewer + meta-optimizer), there's no **automated trigger** (e.g., on VS Code release, on file change, on schedule). The `/meta-prompt-engineering-update` prompt accepts release notes URLs, which is event-driven but requires manual invocation.

---

## 🏗️ Improvement plan for context files

### Priority 1: Structure — separate rules from guidance (fixes C9)

**Problem:** Context files mix imperative rules (MUST/NEVER) with explanatory prose and examples in a linear flow. Prompts consuming them can't efficiently extract just the rules.

**Action 1.1:** Adopt a **two-section pattern** for every context file:

```markdown
# [Topic]

**Purpose**: ...
**Referenced by**: ...

---

## Rules (quick reference)

> Extracted rules in table or bullet format — ONLY imperative statements.
> Prompts and agents scan this section first.

| # | Rule | Severity | Source Principle |
|---|---|---|---|
| R1 | NEVER mix `agent: plan` with write tools | CRITICAL | P6 |
| R2 | Keep agents to 3–7 tools | REQUIRED | P6 |
| R3 | Externalize inline content > 10 lines to templates | REQUIRED | P8 |

---

## Detailed guidance

[Full explanations, examples, rationale — for deeper reading]
```

**Files to refactor (in priority order):**
1. `01-context-engineering-principles.md` — Extract rules table from 8 principles
2. `04-tool-composition-guide.md` — Extract tool alignment rules
3. `05-handoffs-pattern.md` — Extract handoff contract rules
4. `06-context-window-and-token-optimization.md` — Extract strategy selection rules
5. Apply pattern to remaining files

**Expected outcome:** Prompts can reference the "Rules" section for fast, reliable rule extraction; the "Detailed guidance" section remains for deep context when needed.

### Priority 2: Deduplicate and right-size file 01 (fixes C1, C3, C4)

**Problem:** File 01 is the largest context file, approaching budget limits, with some redundant content.

**Action 2.1:** Extract token budget tables from file 01 into a new focused file:
- Create `19-token-budget-reference.md` containing ONLY the budget tables and thresholds
- File 01 references it: `📖 Token budgets: [19-token-budget-reference.md]`
- File 03 (decision guide) references it instead of maintaining its own copy
- Remove duplicate budget tables from file 01 and file 03

**Action 2.2:** Add priority ranking to the 8 principles:

```markdown
| Priority | Principle | Rationale |
|---|---|---|
| P1 (highest) | Tool Scoping & Security (P6) | Safety — wrong tools = irreversible damage |
| P2 | Three-Tier Boundaries (P4) | Safety — prevents overstepping |
| P3 | Narrow Scope (P1) | Reliability — broad scope = unpredictable behavior |
| P4 | Imperative Language (P3) | Reliability — weak language = probabilistic behavior |
| P5 | Early Commands (P2) | Effectiveness — misplaced commands = ignored |
| P6 | Context Minimization (P5) | Efficiency — bloat = context rot |
| P7 | Template-First Authoring (P8) | Efficiency — inline formats waste tokens |
| P8 | Uncertainty Management (P7) | Quality — hallucination prevention |
```

**Action 2.3:** Consolidate P7 (Uncertainty) and P8 (Templates) — remove the overlapping data-gap template content that appears in both sections. Keep the "Three-Part I Don't Know Template" in P7 only, and keep template externalization guidance in P8 only.

### Priority 3: Fix redundancy between files 05 and 06 (fixes C2)

**Action 3.1:** Remove the "Reliability Checksum" summary from file 06. Keep only the cross-reference: `📖 Reliability Checksum: [05-handoffs-pattern.md](05-handoffs-pattern.md) → "Reliability Checksum" section`

### Priority 4: Standardize "Referenced by" headers (fixes C5)

**Action 4.1:** For every context file, replace vague "Referenced by" with the precise list from `16-artifact-dependency-map.md`. Use a consistent format:

```markdown
**Referenced by**: `prompts.instructions.md`, `agents.instructions.md`, PE-validation skill, all 10 PE agents (indirectly via instructions)
```

**Action 4.2:** Add a maintenance rule to `context-files.instructions.md`: "When creating or updating a context file, update its 'Referenced by' header to match the dependency map (`16-artifact-dependency-map.md`). Run dependency map update if adding new references."

### Priority 5: Move examples from file 15 to templates (fixes C6)

**Action 5.1:** Extract the three worked examples (Grammar Checking, API Documentation Review, Security Code Review) from `15-adaptive-validation-patterns.md` into a new template file:
- Create `.github/templates/guidance-use-case-challenge-examples.template.md`
- File 15 retains only the pattern descriptions, tables, and template structures
- Add reference: `📖 Worked examples: .github/templates/guidance-use-case-challenge-examples.template.md`

**Expected token savings:** ~800 tokens removed from file 15, loaded only when needed.

### Priority 6: Standardize cross-reference format (fixes C7)

**Action 6.1:** Define a single cross-reference convention in `context-files.instructions.md`:

```markdown
## Cross-Reference Conventions

- **Between context files:** `📖 See: [filename.md](filename.md)` or `📖 See: [filename.md](filename.md) → "Section Name"`
- **From instructions/agents/prompts to context folder:** `📖 Complete guidance: [.copilot/context/00.00-prompt-engineering/](.copilot/context/00.00-prompt-engineering/)`
- **From instructions/agents/prompts to specific context file:** `📖 See: [filename.md](full-relative-path) → "Section Name"` (use only when linking to a specific concept)
```

**Action 6.2:** Apply the convention across all 18 context files (mechanical pass).

### Priority 7: Add freshness tracking (fixes C8)

**Action 7.1:** Add a `feature_dependencies` field to the version history footer of each context file that tracks which VS Code / Copilot features the file documents:

```markdown
## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.1.0 | 2026-02-23 | Added execution contexts | System |

**Feature dependencies:** VS Code 1.107 (Agent HQ, execution contexts), Copilot Spaces (public preview Feb 2026)
```

**Action 7.2:** Add a check to `meta-reviewer` Phase 1: "For each context file, verify `feature_dependencies` are current. Flag files whose feature dependencies may have changed (e.g., preview → GA, deprecated features)."

---

## 🔧 Quick wins (fixes for instruction files and agents)

| # | Action | Fixes | Effort |
|---|---|---|---|
| QW1 | Replace `@prompt-create-orchestrator` with correct reference `prompt-design` in `prompts.instructions.md` and `agents.instructions.md` | I1, I2 | 5 min |
| QW2 | Move "Six Essential Agents" section from `agents.instructions.md` to a context file or template | I3 | 15 min |
| QW3 | Update "Current Structure" example in `context-files.instructions.md` to match actual 18-file numbered structure | I4 | 10 min |
| QW4 | Add `agents: []` to specialist agents (researchers, validators, updaters) to prevent recursive invocation | A2 | 15 min |
| QW5 | Verify `artifact-coherence-check` skill template files exist (`coherence-report.template.md`, `reference-integrity.template.md`) | S1 | 5 min |

---

## 📊 Execution sequence

| Phase | Actions | Dependencies | Impact |
|---|---|---|---|
| **Phase 1: Quick wins** | QW1–QW5 | None | Fix broken references, reduce token waste |
| **Phase 2: Rules/guidance separation** | 1.1 (two-section pattern) | None | Major effectiveness improvement for prompt consumption |
| **Phase 3: File 01 right-sizing** | 2.1 (extract budgets), 2.2 (priority ranking), 2.3 (consolidate P7/P8) | Phase 2 done for file 01 | Reduce file 01 by ~30%, add principle prioritization |
| **Phase 4: Deduplication** | 3.1 (files 05/06), 5.1 (file 15 examples) | None | ~1,000 tokens saved across two files |
| **Phase 5: Standardization** | 4.1–4.2 (Referenced by), 6.1–6.2 (cross-refs) | Phase 2 done | Consistency across all 18 files |
| **Phase 6: Freshness tracking** | 7.1–7.2 (feature dependencies) | None | Autonomous staleness detection |
| **Phase 7: Validation pass** | Run `/meta-prompt-engineering-review all` | All phases done | Verify improvements, catch regressions |

---

## ✅ Success criteria

After completing all phases, the context file system should pass these checks:

1. **No context file exceeds 2,500 tokens** (and file 01 is under 2,000)
2. **Every context file has a "Rules" quick-reference section** separating imperative rules from guidance
3. **Zero duplicate content** across context files (each concept in exactly one file)
4. **All "Referenced by" headers match the dependency map** (file 16)
5. **All cross-references use the standardized format** from `context-files.instructions.md`
6. **Token budgets have a single canonical source** (new file 19)
7. **Principles in file 01 have explicit priority ranking**
8. **`/meta-prompt-engineering-review all` returns score ≥ 85/100** with zero CRITICAL findings

<!--
article_metadata:
  filename: "pe-context-files-improvement-plan.md"
  created: "2026-04-17"
  last_updated: "2026-04-17"
  version: "1.0"
  purpose: "Analysis and improvement plan for PE context files"
-->
