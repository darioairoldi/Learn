# Agent Validation Phase Output Templates

**Purpose:** Reusable output format templates for agent creation/update workflows.

**Referenced by:** `agent-createorupdate-agent-file-v2.prompt.md` and related prompts

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

### From Existing Agent (if update)
- [What structure exists and will be preserved]

### From Inference
- [What was derived from role type and patterns]

### From Defaults
- [What used agent engineering best practices]

### Initial Values
- **Name:** `[agent-name]`
- **Description:** "[one-sentence]"
- **Role (initial):** [inferred role]
- **Responsibilities (initial):** [key tasks]
- **Tools (initial):** [inferred tools]
- **Agent Mode:** [agent/plan]
```

---

## Phase 1: Validation Depth Assessment Output

```markdown
### Validation Depth Assessment

**Complexity Level:** [Simple / Moderate / Complex]

**Indicators:**
- Role pattern: [Standard / Domain-specific / Novel]
- Tool selection: [Obvious / Needs discovery / Unclear]
- Handoffs: [None / Simple / Complex workflow]
- Agent mode: [Clear / Needs validation / Unclear]

**Validation Strategy:**
- **Use cases to generate:** [3 / 5 / 7]
- **Role validation:** [Basic check / Full specialization test / Multi-faceted analysis]
- **Tool composition:** [Pattern match / Discovery + validation / Full composition analysis]
```

---

## Phase 1: Use Case Challenge Template

```markdown
**Scenario [N]:** [Realistic situation this agent should handle]
**Test Question:** [Can this role handle this scenario?]
**Current Role Capability:** [What does current role imply?]
**Gap Identified:** [What's missing or unclear]
**Tool Requirement Discovered:** [If scenario reveals need for specific tool]
**Responsibility Boundary Discovered:** [If scenario reveals in/out-of-scope question]
**Handoff Discovered:** [If scenario requires delegation to another agent]
**Refinement Needed:** [Specific change to role/responsibilities]
```

---

## Phase 1: Role Challenge Results Output

```markdown
### 4.1 Role Challenge Results

**Use Cases Generated:** [3/5/7]

[For each use case: scenario, test, gaps, discoveries]

**Validation Status:**
- ✅ Role is appropriately specialized → Proceed to Step 4.2
- ⚠️ Role needs clarification → Proposed refinements, ask user for confirmation
- ❌ Role is too broad/narrow → BLOCK, ask user for direction

**If ⚠️ or ❌:**

## Questions for User

### ❌ Critical Issues (Must Resolve Before Proceeding)
[List fundamental role issues with alternative approaches]

### ⚠️ High Priority Questions
[List decisions affecting agent mode, tools, handoffs]

### 📋 Suggestions (Optional Improvements)
[List optional refinements for specialization]

**Refined Role (if validated):**
[Updated role incorporating discoveries from use case testing]

**Refined Responsibilities:**
[Updated task list based on scenarios]

**Tools Discovered:**
- [tool-name]: [why needed based on use case]

**Handoffs Discovered:**
- [agent-name]: [when to delegate]

**Scope Boundaries Discovered:**
- IN SCOPE: [what this agent handles]
- OUT OF SCOPE: [what's delegated or excluded]
```

---

## Phase 1: Tool Composition Validation Output

```markdown
### 4.2 Tool Composition Validation

**Responsibilities → Tool Mapping:**
[List each responsibility with required capability and tool]

**Tool List:**
1. [tool-name] - [justification from responsibility mapping]
2. [tool-name] - [justification]
...

**Tool Count:** [N] tools
**Status:** [✅ Within 3-7 / ⚠️ Too few / ❌ Too many - decompose needed]

**Agent Mode Alignment:**
- **Proposed mode:** [agent/plan]
- **Tools:** [read-only / read+write]
- **Alignment:** [✅ Compatible / ❌ Mismatch - fix needed]

**Pattern Validation:**
- **Composition pattern:** [name from tool-composition-guide.md]
- **Match:** [✅ Follows proven pattern / ⚠️ Novel composition - justify]

**Tool Conflict Check:**
[For each potential overlap: analysis and decision]

**Handoff Validation (if applicable):**
- **Handoffs to:** [list agent names]
- **Existence check:** [✅ Exists / ❌ Must create]
- **Dependency chain:** [if new agents needed]

**Validation Status:**
- ✅ Tool composition validated → Proceed to Step 4.3
- ⚠️ Tool count issues → Recommend adjustments
- ❌ Agent/tool mismatch → BLOCK, fix alignment
- ⚠️ Missing dependencies → Ask user about creation chain
```

---

## Phase 1: Boundary Validation Results Output

```markdown
### 4.3 Boundary Validation Results

**Initial Boundaries:**
[List initial Always/Ask/Never boundaries]

**Boundary Testing:**

**[Tier] - [Boundary Text]**
- **Testability:** [✅ AI can determine / ❌ Subjective/vague]
- **Refinement:** [Specific, testable version]
- **Actionable:** [✅ Yes / ❌ Still vague]
- **Criticality:** [For agent mode constraints]

[Repeat for each boundary]

**Coverage Check:**
[Cross-reference against failure modes from Step 4.1]
- **Missing boundaries added:** [list]

**Agent Mode Constraints:**
[Specific boundaries for plan vs. agent mode]

**Refined Boundaries:**

**✅ Always Do:**
[Refined, actionable requirements]

**⚠️ Ask First:**
[Refined, clear conditions]

**🚫 Never Do:**
[Refined, specific prohibitions]

**Validation Status:**
- ✅ All boundaries actionable → Complete Step 4
- ⚠️ Some boundaries still vague → Propose refinements
```

---

## Phase 1: User Clarification Request Format

```markdown
## Agent Requirements Validation Results

I've analyzed your request and identified some gaps. Please clarify:

### ❌ Critical Issues (Must Resolve Before Proceeding)

**1. [Issue Name]**

**Problem:** [Description of ambiguity or gap]

**Your role "[original role]" could mean:**
- **Interpretation A:** [Option 1]
  - **Implications:** Agent mode: [plan/agent], Tools: [list], Complexity: [level]
- **Interpretation B:** [Option 2]
  - **Implications:** Agent mode: [plan/agent], Tools: [list], Complexity: [level]
- **Interpretation C:** [Option 3 or recommendation]
  - **Implications:** Agent mode: [plan/agent], Tools: [list], Complexity: [level]

**Which interpretation is correct?** Or describe your intent differently.

---

### ⚠️ High Priority Questions

**2. [Question]**

**Context:** [Why this matters]

**Options:**
- **Option A:** [Choice 1] → Impact: [agent mode, tools, handoffs]
- **Option B:** [Choice 2] → Impact: [agent mode, tools, handoffs]

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

**Please answer Critical and High Priority questions before I proceed with agent generation.**
```

---

## Phase 1: Final Requirements Summary Output

```markdown
## Agent Requirements Analysis - VALIDATED

### Operation
- **Mode:** [Create / Update]
- **Target path:** `.github/agents/[agent-name].agent.md`
- **Complexity:** [Simple / Moderate / Complex]
- **Validation Depth:** [Quick / Standard / Deep]

### YAML Frontmatter (Validated)
- **name:** `[agent-name]`
- **description:** "[one-sentence description]"
- **agent:** [agent / plan]
- **model:** [claude-sonnet-4.5 / gpt-4o / other]
- **tools:** [validated list of 3-7 tools]
- **handoffs:** [if applicable - validated agents exist or creation planned]
- **argument-hint:** "[usage guidance]"

### Agent Persona (Validated)

**Role (Validated through [N] use cases):**
[Refined role with appropriate specialization]

**Expertise:**
[Areas of specialized knowledge]

**Responsibilities (Validated):**
1. [Refined responsibility 1]
2. [Refined responsibility 2]
3. [Refined responsibility 3]

**Scope Boundaries:**
- **IN SCOPE:** [What this agent handles]
- **OUT OF SCOPE:** [What's delegated or excluded]

### Tools (Validated)
**Tool Composition Pattern:** [pattern name from tool-composition-guide.md]

1. [tool-1] - [justification from responsibility mapping]
2. [tool-2] - [justification from responsibility mapping]
...

**Agent/Tool Alignment:** ✅ [agent: plan + read-only] OR [agent: agent + read+write]

### Boundaries (Validated - All Actionable)

**✅ Always Do:**
[Refined, testable requirements]

**⚠️ Ask First:**
[Refined, clear conditions]

**🚫 Never Do:**
[Refined, specific prohibitions]

### Handoffs (if applicable)
- **To [agent-name]:** [when and why]
- **Dependency status:** [✅ Exists / ❌ Must create first]

### Validation Summary
- **Use cases tested:** [N]
- **Role specialization:** ✅ Appropriately narrow
- **Tool composition:** ✅ [N] tools, follows [pattern]
- **Agent/tool alignment:** ✅ Verified
- **Boundaries:** ✅ All actionable
- **Handoff dependencies:** [✅ Resolved / ⚠️ Creation needed]

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
- [✅/❌] Role appropriately specialized
- [✅/❌] Agent/tool alignment verified
- [✅/❌] Template externalization applied (no verbose inline formats)

### Similar Agents Analyzed
1. **[file-path]** - [Key patterns extracted]
2. **[file-path]** - [Key patterns extracted]

### Patterns to Apply
- [Pattern 1 from similar agents]
- [Pattern 2 from similar agents]

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
- [ ] All required sections present (Role, Expertise, Responsibilities, Boundaries, Process)
- [ ] Sections in correct order (critical info early)
- [ ] Markdown formatting is correct

### Content Quality
- [ ] Role is specialized (not generic "helper agent")
- [ ] Expertise areas are specific
- [ ] Responsibilities are concrete and actionable
- [ ] Boundaries include all three tiers with actionable rules
- [ ] Process phases (if any) have clear goals
- [ ] Examples demonstrate when to use agent

### Agent Engineering
- [ ] Tool count is 3-7 (optimal range)
- [ ] Agent mode matches tools (plan → read-only, agent → read+write)
- [ ] No tool conflicts or redundancy
- [ ] Follows proven composition pattern from tool-composition-guide.md
- [ ] Imperative language used (WILL, MUST, NEVER)
- [ ] Critical instructions placed early
- [ ] Verbose output formats externalized to templates (Principle 8)

### Repository Conventions
- [ ] Filename follows `[name].agent.md` pattern
- [ ] Bottom YAML metadata block included
- [ ] References instruction files appropriately
- [ ] Follows patterns from similar agents

**All checks passed? (yes/no)**
```

---

## Agent Metadata Block Template

```markdown
<!-- 
---
agent_metadata:
  created: "[ISO timestamp]"
  created_by: "agent-createorupdate-v2"
  last_updated: "[ISO timestamp]"
  version: "1.0"
  validation:
    use_cases_tested: [N]
    complexity: "[simple/moderate/complex]"
    depth: "[quick/standard/deep]"
    tool_count: [N]
  production_ready:
    template_externalization: true
  
validations:
  structure:
    status: "validated"
    last_run: "[ISO timestamp]"
    checklist_passed: true
  agent_tool_alignment:
    status: "verified"
    mode: "[plan/agent]"
    tools_compatible: true
---
-->
```

---

## Example: Simple Agent - JSON Schema Validator (Complete)

This example demonstrates validated role, tools, and boundaries for a simple agent.

### Use Case Challenge Results

```markdown
**Initial Role:** "Schema validator"

**Use Case 1 (Common):**
- **Scenario:** User provides JSON file and schema, agent validates conformance
- **Test:** Can "schema validator" authoritatively determine conformance?
- **Current Capability:** ✅ Clear - validates JSON against schema
- **Gap:** None for common case
- **Tool Discovered:** read_file (to load JSON and schema)
- **Refinement:** None needed for basic case

**Use Case 2 (Edge Case - External References):**
- **Scenario:** Schema contains $ref to external schema file
- **Test:** Should agent resolve external references?
- **Current Capability:** ⚠️ Unclear - "validator" doesn't specify scope
- **Gap:** External reference handling not defined
- **Tool Discovered:** file_search (to locate referenced schemas)
- **Responsibility Boundary:** IN SCOPE - resolve local file references, OUT OF SCOPE - HTTP URLs
- **Refinement:** "JSON schema validator with local reference resolution"

**Use Case 3 (Failure Mode - Invalid Schema):**
- **Scenario:** Schema itself has syntax errors
- **Test:** Should agent validate the schema before using it?
- **Current Capability:** ❌ Not addressed
- **Gap:** Schema validation step missing
- **Boundary:** ALWAYS validate schema before using it
- **Refinement:** Add to boundaries: "ALWAYS validate schema syntax before validation"

**Refined Role After Challenge:**
"JSON schema validator with local reference resolution"

**Refined Responsibilities:**
1. Validate schema syntax before use
2. Resolve local schema $ref references
3. Validate JSON data against schema
4. Report validation errors with line numbers

**Tools Discovered:**
- read_file (load JSON and schema files)
- file_search (find referenced schema files)

**Agent Mode:** `plan` (read-only validation, no file modification)

**Validation Result:** ✅ Role is appropriately specialized
```

### Boundary Refinement Results

```markdown
**Initial Boundaries:**
- ✅ Always Do: "Validate carefully"
- ⚠️ Ask First: "Before reporting errors"
- 🚫 Never Do: "Make mistakes"

**Refined Boundaries:**

**✅ Always Do:**
- ALWAYS validate schema syntax before using it for validation
- ALWAYS attempt to resolve local $ref references before flagging as error
- ALWAYS include schema line number and description in validation errors

**⚠️ Ask First:**
- ASK before validation if file is large (>10,000 lines) as validation may be slow

**🚫 Never Do:**
- NEVER modify JSON or schema files (read-only analysis agent)
- NEVER skip schema syntax validation
- NEVER report errors without context (line number + description required)
```
