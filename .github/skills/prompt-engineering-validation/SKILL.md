---
name: prompt-engineering-validation
description: >
  Reusable validation patterns for prompt and agent file engineering: 
  use case challenge, role validation, tool alignment verification, 
  workflow reliability testing, and boundary actionability checks.
  Use when creating prompts, validating agents, reviewing tool alignment,
  or testing workflow reliability for GitHub Copilot customization files.
---

# Prompt Engineering Validation Skill

## Purpose

Provide reusable validation workflows for prompt and agent engineering. Eliminates duplication of validation logic across prompt-researcher, agent-researcher, prompt-validator, agent-validator, prompt-builder, and agent-builder agents.

## When to Use

Activate this skill when:
- **Creating prompts/agents**: "Validate requirements for this new prompt"
- **Challenging goals**: "Test this prompt purpose with use cases"
- **Validating roles**: "Check if this role is appropriate for the goal"
- **Checking tool alignment**: "Verify tool/agent mode alignment"
- **Testing workflows**: "Test this workflow for failure modes"
- **Reviewing boundaries**: "Check if boundaries are actionable"

Do NOT use this skill for:
- Article content review (use `article-review` skill)
- Code review or security auditing
- Context file creation (use context-builder agent)

## Quick Reference

### Validation Sequence

```
1. Complexity Assessment → determines depth
2. Use Case Challenge → discovers gaps (3/5/7 scenarios)
3. Role Validation → authority + expertise + specificity
4. Tool Alignment → mode matches tool capabilities
5. Workflow Reliability → failure mode analysis
6. Boundary Actionability → testable by AI
```

### Complexity → Depth Mapping

| Complexity | Indicators | Use Cases | Validation |
|------------|------------|-----------|------------|
| **Simple** | 1-2 objectives, standard role, obvious tools | 3 | Quick |
| **Moderate** | 3+ objectives, domain expertise needed | 5 | Standard |
| **Complex** | Multiple interpretations, novel workflow, >7 tools | 7 | Deep |

### Tool Alignment Rules

| Agent Mode | Allowed Tools | Forbidden Tools |
|------------|---------------|-----------------|
| `plan` | `read_file`, `grep_search`, `semantic_search`, `file_search`, `list_dir`, `get_errors`, `fetch_webpage` | `create_file`, `replace_string_in_file`, `multi_replace_string_in_file`, `run_in_terminal` |
| `agent` | All read tools + write tools | None (but minimize write tools) |

**Alignment formula:**
- `plan` + write tools = **CRITICAL violation** (BLOCK)
- `agent` + no write tools = **WARNING** (should this be `plan`?)
- Tool count outside 3-7 = **WARNING** (>7 = tool clash risk)

### Tool Count Budget

| Range | Status | Action |
|-------|--------|--------|
| 1-2 | ⚠️ Sparse | Verify task is truly simple |
| 3-7 | ✅ Optimal | Proceed |
| 8+ | ❌ Tool clash | MUST decompose into agents |

## Detailed Workflows

### Workflow 1: Use Case Challenge

Use [use case challenge template](./templates/use-case-challenge.template.md) to test goals.

**Process:**
1. Generate N use cases (3/5/7 based on complexity)
2. For each scenario, test: Does goal clearly indicate what to do?
3. Record gaps: ambiguities, missing tools, scope boundary questions
4. Refine goal to address discovered gaps
5. Present critical gaps to user for clarification

**Gap Severity Classification:**

| Severity | Impact | Action |
|----------|--------|--------|
| CRITICAL | Multiple valid interpretations, different tool needs | BLOCK — ask user |
| HIGH | Affects scope or major workflow phases | ASK — present options |
| MEDIUM | Minor edge case handling | PROPOSE — suggest default |
| LOW | Cosmetic or optional enhancement | DEFER — note for later |

### Workflow 2: Role Validation

Use [role validation template](./templates/role-validation.template.md) to verify roles.

**Three Tests:**
1. **Authority**: Can this role make necessary judgments?
2. **Expertise**: Does role imply required knowledge?
3. **Specificity**: Is role concrete or generic?

**Common Role Anti-Patterns:**/
- "Helpful assistant" → Too generic, lacks authority signal
- "Expert in everything" → Overscoped, unfocused
- "Code reviewer" for documentation tasks → Wrong domain

### Workflow 3: Tool Alignment Verification

Use [tool alignment template](./templates/tool-alignment.template.md) for systematic checks.

**Write Tools List** (forbidden for `plan` mode):
- `create_file`
- `replace_string_in_file`
- `multi_replace_string_in_file`
- `run_in_terminal`
- `edit_notebook_file`
- `run_notebook_cell`

### Workflow 4: Workflow Reliability Testing

**For each proposed phase, ask:** "What could go wrong?"

**Common failure modes:**
- Input validation missing (malformed files, wrong format)
- Scale handling absent (large files, many results)
- Error recovery missing (tool failures, network issues)
- Missing dependency discovery (external refs, imports)
- Cache/skip logic absent (repeat validations)

### Workflow 5: Boundary Actionability

**Test each boundary:** Can AI unambiguously determine compliance?

**Vague → Actionable transformation:**

| Vague | Actionable |
|-------|------------|
| "Be thorough" | "Check all 5 criteria: X, Y, Z, A, B" |
| "Be careful" | "NEVER modify files without reading first" |
| "Handle errors" | "When tool fails, log error and skip to next item" |

**Minimum boundary counts:** Always Do ≥3, Ask First ≥1, Never Do ≥2

## Templates

- **[Use Case Challenge](./templates/use-case-challenge.template.md)** — Structured format for testing goals with scenarios
- **[Role Validation](./templates/role-validation.template.md)** — Authority/expertise/specificity test checklist
- **[Tool Alignment](./templates/tool-alignment.template.md)** — Tool/agent mode verification with write-tool detection

## Common Issues

### Issue: Use Case Challenge Reveals Too Many Gaps

**Symptom**: 4+ CRITICAL gaps after use case testing  
**Solution**: Goal is too broad. Decompose into multiple prompts/agents. Use orchestrator pattern.

### Issue: Role Fails Authority Test

**Symptom**: Role can't make required judgments  
**Solution**: Add domain qualifier. "Grammar reviewer" → "English grammar and style reviewer with technical writing expertise"

### Issue: Tool Count Exceeds 7

**Symptom**: Phase mapping identifies 8+ tools  
**Solution**: Decompose into orchestrator + specialist agents. Each agent gets 3-5 tools.

### Issue: Plan Mode Needs Write Tools

**Symptom**: Validation finds `plan` agent with `create_file`  
**Solution**: Either change to `agent` mode or remove write tools and restructure workflow.

## Resources

- **📖 Complete validation examples:** `.copilot/context/00.00-prompt-engineering/06-adaptive-validation-patterns.md`
- **📖 Tool composition patterns:** `.copilot/context/00.00-prompt-engineering/02-tool-composition-guide.md`
- **📖 Context engineering principles:** `.copilot/context/00.00-prompt-engineering/01-context-engineering-principles.md`
