
## Analysis Summary

### 1. The prompt-createorupdate-prompt-file.prompt.md Problem

This **483-line monolithic prompt** tries to do everything in one shot: requirements gathering, use case challenge validation, role validation, workflow reliability testing, tool mapping, boundary validation, user clarification protocol, best practices research, prompt generation, and final validation — all within a single prompt execution.

**Key problems:**

| Issue | Impact |
|-------|--------|
| **Monolithic scope** | Single prompt handles 4 phases with 6 sub-steps in Phase 1 alone — violates "one task per prompt" principle |
| **Duplicates the orchestrated workflow** | prompt-design-and-create.prompt.md already orchestrates researcher → builder → validator → updater for the same task |
| **~1,200 tokens of inline process** | Despite template externalization, the validation methodology is still embedded rather than delegated to specialists |
| **No handoffs** | Doesn't leverage the 8 existing specialist agents (4 prompt + 4 agent) |
| **No skills** | Only 1 skill exists (`article-review`); there's no `prompt-engineering` skill for reusable validation workflows |

### 2. What Already Exists (Agent Inventory)

The repository already has **two parallel systems** for creating prompts:

| System | File | Approach | Status |
|--------|------|----------|--------|
| **Monolithic** | prompt-createorupdate-prompt-file.prompt.md | Single prompt does everything | 483 lines, no handoffs |
| **Orchestrated** | prompt-design-and-create.prompt.md | 8-phase orchestrator coordinating 8 agents | 1,164 lines, full handoff chain |

**8 specialist agents:** `prompt-researcher`, `prompt-builder`, `prompt-validator`, `prompt-updater`, `agent-researcher`, `agent-builder`, `agent-validator`, `agent-updater`

**Parallel monolithic prompts:** agent-createorupdate-agent-file.prompt.md (461 lines, same pattern)

### 3. Gap Analysis

| Gap | Description | Severity |
|-----|-------------|----------|
| **No prompt-engineering skill** | Validation patterns (use case challenge, role validation, tool alignment) are duplicated across the monolithic prompt AND all 8 agents, rather than being a reusable skill | HIGH |
| **Monolithic prompt redundancy** | prompt-createorupdate-prompt-file.prompt.md duplicates what prompt-design-and-create.prompt.md + agents already do | HIGH |
| **Missing context/instruction creation agents** | prompt-createorupdate-context-information.prompt.md and prompt-createorupdate-prompt-instructions.prompt.md are monolithic (537-556 lines each) with no agent decomposition | MEDIUM |
| **No skill-builder workflow** | No agents or prompts for creating/updating skills | MEDIUM |
| **Orchestrator bloat** | prompt-design-and-create.prompt.md at 1,164 lines exceeds the 2,500-token budget for orchestrators | MEDIUM |

---

## Implementation Plan

### Strategy: Consolidate, Don't Proliferate

Rather than creating more agents, the plan **simplifies** by:
1. Retiring the monolithic prompt-createorupdate-prompt-file.prompt.md (redirect to orchestrator)
2. Creating a reusable **skill** for the shared validation patterns
3. Updating existing agents to use the skill (reducing their token footprint)
4. Creating minimal new agents only where genuine gaps exist (context/instruction specialists)

### Phase 1: Create Prompt Engineering Skill (NEW)

**File:** SKILL.md

**Purpose:** Bundles the shared validation patterns (use case challenge, role validation, tool alignment, boundary testing) into a single reusable skill. This eliminates duplication across the monolithic prompt, the 4 prompt agents, and the 4 agent agents.

**Content extracted from:**
- prompt-createorupdate-prompt-file.prompt.md Steps 3-5 (validation depth, use case challenge, role validation)
- `06-adaptive-validation-patterns.md` context file
- `02-tool-composition-guide.md` tool alignment rules

**Resources to include:**
- `templates/use-case-challenge.template.md` — Use case generation and testing template
- `templates/role-validation.template.md` — Authority/expertise/specificity test template
- `templates/tool-alignment.template.md` — Tool/agent mode verification checklist

**Token savings:** Each agent that currently embeds 50-80 lines of validation logic can reference the skill instead (~10 lines of reference vs. 50-80 inline).

### Phase 2: Retire Monolithic Prompt → Redirect to Orchestrator

**File:** prompt-createorupdate-prompt-file.prompt.md

**Action:** Replace the 483-line monolithic prompt with a **lightweight redirector** (~30 lines) that:
1. Detects create vs. update mode (same logic, ~10 lines)
2. For **create**: Hands off to `prompt-design-and-create` orchestrator
3. For **update**: Hands off to `prompt-updater` agent directly
4. Preserves the user-facing `/prompt-createorupdate-v2` slash command name

**Rationale:** The orchestrator + 8 agents already implement the same workflow more effectively. The monolithic prompt is redundant and wastes ~1,200 tokens every invocation.

### Phase 3: Retire Monolithic Agent Prompt → Same Pattern

**File:** agent-createorupdate-agent-file.prompt.md

**Action:** Same treatment — replace 461-line monolithic prompt with lightweight redirector to `agent-design-and-create` orchestrator.

### Phase 4: Update Existing Agents to Reference Skill

**Files:** All 8 specialist agents

**Action:** Replace inline validation logic with skill references:
- `prompt-researcher` (719 lines) → Remove embedded use case challenge methodology (~100 lines), reference skill
- `prompt-validator` (875 lines) → Remove embedded tool alignment rules (~50 lines), reference skill
- `prompt-builder` (656 lines) → Remove embedded pre-save validation (~60 lines), reference skill
- `agent-researcher` (449 lines) → Remove embedded role challenge (~80 lines), reference skill
- `agent-validator` (394 lines) → Remove embedded tool alignment (~40 lines), reference skill
- Similarly for `prompt-updater` and `agent-updater` and `agent-builder`

**Estimated savings:** ~400-500 lines total across 8 agents (= ~2,000-2,500 tokens saved per session when multiple agents load)

### Phase 5: Create Context/Instruction Specialist Agents (NEW)

Currently prompt-createorupdate-context-information.prompt.md (556 lines) and prompt-createorupdate-prompt-instructions.prompt.md (537 lines) are monolithic prompts with 9 tools each — the maximum before tool clash.

**New agents:**

| Agent | Mode | Tools | Purpose |
|-------|------|-------|---------|
| `context-builder` | `agent` | `read_file`, `grep_search`, `file_search`, `create_file`, `replace_string_in_file` | Create/update context files following structure patterns |
| `instruction-builder` | `agent` | `read_file`, `grep_search`, `file_search`, `create_file`, `replace_string_in_file` | Create/update instruction files following path-specific patterns |

**New orchestrator prompts** (replace the monolithic versions):

| Orchestrator | Coordinates | Purpose |
|-------------|-------------|---------|
| `context-design-and-create.prompt.md` | `prompt-researcher` + `context-builder` + `prompt-validator` | Context file creation workflow |
| `instruction-design-and-create.prompt.md` | `prompt-researcher` + `instruction-builder` + `prompt-validator` | Instruction file creation workflow |

**Why reuse existing agents:** `prompt-researcher` already handles requirements/pattern discovery. `prompt-validator` already validates structure. Only the *builder* is content-type-specific.

### Phase 6: Slim Down Orchestrators

**Files:** prompt-design-and-create.prompt.md (1,164 lines), prompt-review-and-validate.prompt.md

**Action:** Extract the inline workflow diagrams, gate check templates, and handoff configuration examples into:
- `.github/templates/output-orchestrator-gates.template.md` — Standard gate check format
- `.github/templates/output-orchestrator-workflow-metadata.template.md` — Workflow tracking YAML

**Estimated savings:** ~300-400 lines from the design orchestrator alone.

---

### Priority Order and Dependencies

| Priority | Action | Files | Dependency | Impact |
|----------|--------|-------|------------|--------|
| **P1** | Create prompt-engineering-validation skill | 1 new skill + 3 templates | None | Enables P3 |
| **P2** | Retire monolithic prompt → redirector | 1 file rewrite | None | Immediate token savings |
| **P3** | Update 8 agents to reference skill | 8 file updates | P1 | ~2,500 tokens saved/session |
| **P4** | Retire monolithic agent prompt → redirector | 1 file rewrite | None | Immediate token savings |
| **P5** | Create context-builder + instruction-builder agents | 2 new agents | None | Enables P6 |
| **P6** | Create context/instruction orchestrators, retire monolithic versions | 2 new + 2 rewrites | P5 | Clean orchestration for all file types |
| **P7** | Slim down orchestrators with templates | 2 file updates + 2 templates | None | ~300 tokens saved |

### Expected Outcomes

| Metric | Before | After |
|--------|--------|-------|
| Lines in monolithic prompts | 483 + 461 + 556 + 537 = **2,037** | ~30 + ~30 = **60** (redirectors) |
| Average agent size | ~590 lines | ~450 lines (-24%) |
| Skills available | 1 (article-review) | 2 (+prompt-engineering-validation) |
| Orchestrators | 2 (prompt, agent) | 4 (+context, instruction) |
| Validation logic duplication | 10 files embed same patterns | 1 skill, referenced by all |
| Token budget compliance | 3 files over budget | All compliant |

---

Shall I proceed with implementation? I recommend starting with **P1** (create the skill) and **P2** (retire the monolithic prompt), as they have no dependencies and deliver immediate value. We can then iterate through P3-P7.