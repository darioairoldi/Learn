# Prompt Validation Phase Output Templates

**Purpose:** Reusable output format templates for prompt creation/update workflows.

**Referenced by:** `prompt-createorupdate-prompt-file-v2.prompt.md` and related prompts

---

## Phase 1: Operation Type Output

```markdown
### Operation Type
- **Mode:** [Create / Update]
- **Target:** [New file / Existing file path]
```

---

## Phase 1: Initial Requirements Extraction Output

```markdown
## Initial Requirements Extraction

### From User Input
- [What was explicitly provided]

### From Existing Prompt (if update)
- [What structure exists and will be preserved]

### From Inference
- [What was derived from task type and patterns]

### From Defaults
- [What used template defaults]

### Initial Values
- **Name:** `[prompt-name]`
- **Description:** "[one-sentence]"
- **Goal (initial):** 
  1. [Objective 1]
  2. [Objective 2]
- **Role (initial):** [inferred role]
- **Tools (initial):** [inferred tools]
- **Agent Mode:** [agent/plan/edit/ask]
```

---

## Phase 1: Validation Depth Assessment Output

```markdown
### Validation Depth Assessment

**Complexity Level:** [Simple / Moderate / Complex]
**Use cases to generate:** [3 / 5 / 7]
**Validation approach:** [Reference adaptive-validation-patterns.md for methodology]
```

---

## Phase 1: Goal Challenge Results Output

```markdown
### 4.1 Goal Challenge Results

**Use Cases Generated:** [3/5/7]

**Scenario [N]:** [Realistic situation]
**Test Question:** [Specific question about goal's applicability]
**Current Guidance:** [What does current goal say?]
**Gap Identified:** [What's missing/ambiguous]
**Tool Discovered:** [If scenario reveals tool need]
**Scope Boundary:** [If scenario reveals in/out-of-scope]
**Refinement:** [Specific change needed]

[Repeat for each use case]

**Validation Status:**
- ✅ Goal is clear and testable → Proceed to Step 4.2
- ⚠️ Minor ambiguities found → Refinements proposed, ask user for confirmation
- ❌ Critical gaps found → BLOCK, ask user for clarifications (proceed to Step 5)

**Refined Goal (if validated):**
[Updated goal incorporating discoveries from use case testing]

**Tools Discovered:**
- [tool-name]: [why needed based on use case]

**Scope Boundaries Discovered:**
- IN SCOPE: [what's included]
- OUT OF SCOPE: [what's explicitly excluded]
```

---

## Phase 1: Role Validation Results Output

```markdown
### 4.2 Role Validation Results

**Initial Role:** [role from Step 2]

**Authority Test:** [✅ Sufficient / ❌ Insufficient + gap analysis]
**Expertise Test:** [✅ Sufficient / ❌ Insufficient + gap analysis]
**Specificity Test:** [✅ Adequate / ⚠️ Too generic / ⚠️ Too narrow]

**Pattern Search:**
- **Found [N] similar roles in workspace**
- **Best match:** [file path and role used]

**Validation Status:**
- ✅ Role appropriate → Proceed to Step 4.3
- ⚠️ Role needs refinement → Proposed refinement below
- ❌ Role mismatch with goal → BLOCK, ask user to clarify intent

**Refined Role (if validated):**
[Updated role with justification]
```

---

## Phase 1: Workflow Validation Results Output

```markdown
### 4.3 Workflow Validation Results

**Initial Workflow:**
[List proposed phases]

**Failure Mode Analysis:**

**Phase [N]: [Phase Name]**
- **Test:** What if [failure scenario]?
- **Current Handling:** [Addressed / Not addressed]
- **Gap:** [What's missing]
- **Refinement:** [Specific addition/change]

[Repeat for critical failure modes]

**Pattern Validation:**
- **Similar prompts analyzed:** [count]
- **Gaps vs. proven patterns:** [list]

**Refined Workflow:**
[Updated phase structure with additions]

**Validation Status:**
- ✅ Workflow is reliable → Proceed to Step 4.4
- ⚠️ Minor gaps → Refinements proposed
- ❌ Fundamental issues → BLOCK, recommend redesign
```

---

## Phase 1: Tool Requirements Analysis Output

```markdown
### 4.4 Tool Requirements Analysis

**Phase → Tool Mapping:**
[List each phase with required capabilities and selected tools]

**Tool List:**
1. [tool-name] - [justification from phase mapping]
2. [tool-name] - [justification]
...

**Tool Count:** [N] tools
**Status:** [✅ Within 3-7 / ⚠️ Consider decomposition if >7]

**Agent Mode Alignment:**
- **Proposed mode:** [agent/plan/edit/ask]
- **Tools:** [read-only / read+write]
- **Alignment:** [✅ Compatible / ❌ Mismatch]

**Pattern Validation:**
- **Composition pattern:** [name from tool-composition-guide.md]
- **Match:** [✅ Follows proven pattern / ⚠️ Novel composition]

**Validation Status:**
- ✅ Tools validated → Proceed to Step 4.5
- ⚠️ Tool count high → Recommend decomposition
- ❌ Agent/tool mismatch → BLOCK, fix alignment
```

---

## Phase 1: Boundary Validation Results Output

```markdown
### 4.5 Boundary Validation Results

**Initial Boundaries:**
[List initial Always/Ask/Never boundaries]

**Boundary Testing:**

**[Tier] - [Boundary Text]**
- **Testability:** [✅ Can AI determine compliance / ❌ Subjective/vague]
- **Refinement:** [Specific, testable version]
- **Actionable:** [✅ Yes / ❌ Still vague]

[Repeat for critical boundaries]

**Coverage Check:**
[Cross-reference against failure modes from Step 4.3]
- **Missing boundaries added:** [list]

**Refined Boundaries:**

**✅ Always Do:**
[List refined, actionable boundaries]

**⚠️ Ask First:**
[List refined conditions]

**🚫 Never Do:**
[List refined prohibitions]

**Validation Status:**
- ✅ All boundaries actionable → Complete Step 4
- ⚠️ Some boundaries still vague → Propose refinements
```

---

## Phase 1: User Clarification Request Format

```markdown
## Requirements Validation Results

I've analyzed your request and identified some gaps. Please clarify:

### ❌ Critical Issues (Must Resolve Before Proceeding)

**1. [Issue Name]**

**Problem:** [Description of ambiguity or gap]

**Your goal "[original goal]" could mean:**
- **Scenario A:** [Interpretation 1]
  - **Implications:** Tools: [list], Boundaries: [list], Complexity: [level]
- **Scenario B:** [Interpretation 2]
  - **Implications:** Tools: [list], Boundaries: [list], Complexity: [level]
- **Scenario C:** [Interpretation 3]
  - **Implications:** Tools: [list], Boundaries: [list], Complexity: [level]

**Which interpretation is correct?** Or describe your intent differently.

---

### ⚠️ High Priority Questions

**2. [Question]**

**Context:** [Why this matters]

**Options:**
- **Option A:** [Choice 1] → Impact: [what changes]
- **Option B:** [Choice 2] → Impact: [what changes]

**Recommendation:** [If you have one]

**Your choice:** [Ask user to select]

---

### 📋 Suggestions (Optional Improvements)

**3. [Suggestion]**

**Current:** [What's currently proposed]
**Improvement:** [What could be better]
**Benefit:** [Why it matters]

**Accept this suggestion?** (yes/no/modify)

---

**Please answer Critical and High Priority questions before I proceed with prompt generation.**
```

---

## Phase 1: Final Requirements Summary Output

```markdown
## Prompt Requirements Analysis - VALIDATED

### Operation
- **Mode:** [Create / Update]
- **Target path:** `.github/prompts/[prompt-name].prompt.md`
- **Complexity:** [Simple / Moderate / Complex]
- **Validation Depth:** [Quick / Standard / Deep]

### YAML Frontmatter (Validated)
- **name:** `[prompt-name]`
- **description:** "[one-sentence description]"
- **agent:** [agent / plan / edit / ask]
- **model:** [claude-sonnet-4.5 / gpt-4o / other]
- **tools:** [validated list of 3-7 tools]
- **argument-hint:** "[usage guidance]"

### Content Structure (Validated)

**Role (Validated):**
[Refined role with authority and expertise for goal]

**Goal (Validated through [N] use cases):**
1. [Refined objective 1]
2. [Refined objective 2]
3. [Refined objective 3]

**Scope Boundaries:**
- **IN SCOPE:** [What's included]
- **OUT OF SCOPE:** [What's explicitly excluded]

### Workflow (Validated)
[List refined phases with failure mode handling]

### Boundaries (Validated - All Actionable)

**✅ Always Do:**
[Refined, testable requirements]

**⚠️ Ask First:**
[Refined, clear conditions]

**🚫 Never Do:**
[Refined, specific prohibitions]

### Tools (Validated)
[List with phase mapping and justification]

### Validation Summary
- **Use cases tested:** [N]
- **Goal clarity:** ✅ Clear and testable
- **Role appropriateness:** ✅ Authority and expertise confirmed
- **Workflow reliability:** ✅ Failure modes addressed
- **Tool composition:** ✅ [N] tools, follows [pattern name]
- **Boundaries:** ✅ All actionable

### Source Information
- **From user input:** [explicitly provided]
- **From use case discovery:** [discovered through validation]
- **From pattern search:** [found in workspace]
- **From refinement:** [improved through validation]

---

**✅ VALIDATION COMPLETE - Proceed to Phase 2? (yes/no)**
```

---

## Phase 2: Best Practices Validation Output

```markdown
## Best Practices Validation

### Repository Guidelines
- [✅/❌] Follows context engineering principles
- [✅/❌] Uses imperative language
- [✅/❌] 3-7 tools (optimal range)
- [✅/❌] Narrow scope (one task)
- [✅/❌] Template externalization applied (no verbose inline formats)

### Similar Prompts Analyzed
1. **[file-path]** - [Key patterns extracted]
2. **[file-path]** - [Key patterns extracted]

### Patterns to Apply
- [Pattern 1 from similar prompts]
- [Pattern 2 from similar prompts]

### Anti-Patterns Avoided
- [Confirmed no anti-pattern X]
- [Confirmed no anti-pattern Y]

**Proceed to Phase 3? (yes/no)**
```

---

## Phase 4: Pre-Output Validation Checklist

```markdown
## Pre-Output Validation

### Structure
- [ ] YAML frontmatter is valid and complete
- [ ] All required sections present (Role, Goal, Boundaries, Process, Response Management, Error Recovery, Test Scenarios)
- [ ] Sections in correct order (critical info in first 30% of prompt)
- [ ] Markdown formatting is correct

### Content Quality
- [ ] Role is specific with authority and expertise (not generic "assistant")
- [ ] Boundaries include all three tiers with actionable, testable rules
- [ ] Goal has 2-3 concrete, validated objectives
- [ ] Process phases handle identified failure modes
- [ ] Output format is explicitly defined (or references template)
- [ ] Examples demonstrate expected behavior

### Context Engineering
- [ ] Imperative language used (WILL, MUST, NEVER, CRITICAL, MANDATORY)
- [ ] No polite filler or vague instructions
- [ ] Tool list is 3-7 and justified by workflow phases
- [ ] Scope is narrow (one specific task, not multiple concerns)
- [ ] Critical instructions placed in first 30% of prompt
- [ ] References context files instead of embedding content
- [ ] Verbose output formats externalized to templates (Principle 8)

### Production-Ready Requirements (6 VITAL Rules)
- [ ] Response Management section included (handles missing info, ambiguity, tool failures, out of scope)
- [ ] Error Recovery workflows defined for each critical tool
- [ ] Embedded Test Scenarios included (minimum 5: happy path, ambiguous input, missing context, out of scope, tool failure)
- [ ] Token budget compliant (≤1500 for multi-step workflows, ≤2500 for orchestrators)

### Repository Conventions
- [ ] Filename follows `[name].prompt.md` pattern
- [ ] Bottom YAML metadata block included
- [ ] References instruction files appropriately
- [ ] Follows patterns from similar prompts (validated via `semantic_search`)

**All checks passed? (yes/no)**
```

---

## Prompt Metadata Block Template

```markdown
<!-- 
---
prompt_metadata:
  created: "[ISO timestamp]"
  created_by: "prompt-createorupdate-v2"
  last_updated: "[ISO timestamp]"
  version: "1.0"
  validation:
    use_cases_tested: [N]
    complexity: "[simple/moderate/complex]"
    depth: "[quick/standard/deep]"
    token_count: [approximate token count]
  production_ready:
    response_management: true
    error_recovery: true
    embedded_tests: [N]
    token_budget_compliant: true
    template_externalization: true
  
validations:
  structure:
    status: "validated"
    last_run: "[ISO timestamp]"
    checklist_passed: true
---
-->
```
