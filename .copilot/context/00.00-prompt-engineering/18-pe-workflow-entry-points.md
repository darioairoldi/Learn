# PE Workflow Entry Points

**Purpose**: Decision guide for choosing the right prompt or agent when working with prompt engineering artifacts — differentiating standalone prompts from orchestrator prompts and clarifying when to use each.

**Referenced by**: All PE artifact creators, meta-review prompts, users starting PE workflows

---

## Quick Decision: What Do You Want to Do?

```
What do you want to do?
│
├─ CREATE a new artifact?
│  ├─ Complex/uncertain requirements → Orchestrator Prompt (Phase A)
│  └─ Clear requirements, known pattern → Standalone Prompt (Phase B)
│
├─ REVIEW/VALIDATE an existing artifact?
│  └─ → Validation Prompt (Phase C)
│
├─ UPDATE/FIX an existing artifact?
│  ├─ From validation report → Agent directly (Phase D)
│  └─ Ad hoc change → Standalone Prompt in update mode (Phase B)
│
├─ Review the PE SYSTEM itself?
│  └─ → Meta-Prompt (Phase E)
│
└─ Not sure which artifact type to create?
   └─ → Read 03-file-type-decision-guide.md first
```

---

## Phase A: Orchestrator Prompts (Complex Creation)

**Use when**: Requirements are unclear, scope is uncertain, or you want guided multi-phase creation with quality gates.

| Prompt | Slash Command | Creates | Agent Team | When to Use |
|---|---|---|---|---|
| `prompt-design` | `/prompt-design` | Prompt files + dependent agents | 8 agents (prompt + agent specialists) | New prompt with uncertain requirements, novel workflow, or when dependent agents may be needed |
| `agent-design` | `/agent-design` | Agent files | 4 agents (agent specialists) | New agent with role that needs challenge-testing, unclear tools, or possible decomposition |

**What orchestrators provide that standalone prompts do not:**
- Use case challenge validation (3–7 scenarios)
- Pattern research across existing codebase
- Quality gates between phases
- Automatic validation handoff
- Recursive creation of dependent agents

**Orchestrator workflow:**
```
User request → Researcher (requirements + patterns) → [User approval gate]
    → Builder (file creation) → Validator (quality check)
    → Updater (if issues) → Validator (re-check) → Done
```

---

## Phase B: Standalone Prompts (Direct Creation/Update)

**Use when**: Requirements are clear, you know the pattern, or you want a faster single-agent workflow.

| Prompt | Slash Command | Creates/Updates | When to Use |
|---|---|---|---|
| `prompt-create-update` | `/prompt-create-update` | Prompt files | Clear requirements, known template, quick creation or update |
| `agent-create-update` | `/agent-create-update` | Agent files | Clear role, known tools, quick creation or update |
| `context-file-create-update` | `/context-file-create-update` | Context files | New knowledge to document, source material available |
| `instruction-file-create-update` | `/instruction-file-create-update` | Instruction files | New file-type rules, known applyTo patterns |

**Standalone vs Orchestrator — Decision Matrix:**

| Factor | → Standalone | → Orchestrator |
|---|---|---|
| Requirements clarity | Clear, specific | Vague, exploratory |
| Pattern familiarity | Known pattern, existing template | Novel workflow, no precedent |
| Scope confidence | Well-scoped, single artifact | May need decomposition |
| Tool requirements | Known tools, ≤7 | Unclear tools, possibly >7 |
| Time priority | Fast turnaround needed | Quality over speed |
| Dependent artifacts | None needed | May need supporting agents |

---

## Phase C: Validation Prompts (Review/Validate)

**Use when**: You have an existing artifact that needs quality verification.

| Prompt | Slash Command | Validates | Agent Team | When to Use |
|---|---|---|---|---|
| `prompt-review` | `/prompt-review` | Prompt files | `prompt-validator` ↔ `prompt-updater` | After creation, after updates, periodic review |
| `agent-review` | `/agent-review` | Agent files | `agent-validator` ↔ `agent-updater` | After creation, after updates, periodic review |

**Validation workflow:**
```
Artifact → Tool alignment check (CRITICAL) → Structure check
    → Boundary check → Quality score → [If issues: updater → re-validate]
```

**Validation is mandatory after:**
- Any CRITICAL or HIGH impact change
- New artifact creation (usually auto-triggered via handoff)
- Changes to artifacts with 3+ dependents

---

## Phase D: Direct Agent Usage (Expert Mode)

**Use when**: You know exactly which agent to invoke and want to skip the orchestrator/prompt overhead.

| Agent | Invoke with | Best For |
|---|---|---|
| `@prompt-researcher` | `@prompt-researcher <description>` | Quick requirements check, pattern search |
| `@prompt-builder` | `@prompt-builder <spec>` | Build from known specification |
| `@prompt-validator` | `@prompt-validator <file>` | Quick validation of a single file |
| `@prompt-updater` | `@prompt-updater <file> <changes>` | Apply specific fixes from validation report |
| `@agent-researcher` | `@agent-researcher <description>` | Quick agent requirements check |
| `@agent-builder` | `@agent-builder <spec>` | Build from known specification |
| `@agent-validator` | `@agent-validator <file>` | Quick validation of a single file |
| `@agent-updater` | `@agent-updater <file> <changes>` | Apply specific fixes |
| `@context-builder` | `@context-builder <topic>` | Create/update context files |
| `@instruction-builder` | `@instruction-builder <domain>` | Create/update instruction files |
| `@meta-reviewer` | `@meta-reviewer` | Audit PE system for coherence, redundancy, completeness |
| `@meta-optimizer` | `@meta-optimizer <audit-report>` | Apply optimizations from meta-reviewer audit report |

**When to use agents directly instead of prompts:**
- You have a clear, single-step task
- You already have the research report / specification
- You want to skip orchestration overhead
- You are an experienced user who knows the agent capabilities

---

## Phase E: Meta-Agents and Meta-Prompts (System Self-Improvement)

**Use when**: You want to review, optimize, or update the PE artifact system itself.

### Available Meta-Agents

| Agent | Purpose | Mode | Use Directly |
|---|---|---|---|
| `@meta-reviewer` | Audit all PE artifacts for coherence, redundancy, completeness | Read-only (`plan`) | `@meta-reviewer` — produces audit report |
| `@meta-optimizer` | Apply deduplication, token savings, structural improvements | Read-write (`agent`) | `@meta-optimizer <audit-report>` — applies fixes |

**Meta-agent workflow:**
```
@meta-reviewer → audit report → @meta-optimizer → changes → @prompt-validator → re-validation
```

### Meta-Prompts (Slash Commands)

| Prompt | Slash Command | Purpose | Mode | Frequency |
|---|---|---|---|---|
| `meta-prompt-engineering-review` | `/meta-prompt-engineering-review` | Parameterized system review — scope by artifact type, dimension by quality check | Read-only | Biweekly / on-demand |
| `meta-prompt-engineering-optimize` | `/meta-prompt-engineering-optimize` | Apply optimizations from review findings | Read-write | As needed |
| `meta-prompt-engineering-update` | `/meta-prompt-engineering-update` | Incorporate new best practices or VS Code changes | Read-write | Event-driven |

**`/meta-prompt-engineering-review` parameters:**
- **Scope**: `all`, `context`, `instructions`, `agents`, `prompts`, `skills`
- **Dimensions**: `coherence`, `completeness`, `structure`, `rules`, `references`, `budgets`
- **Examples**: `/meta-prompt-engineering-review all`, `/meta-prompt-engineering-review context coherence+references`, `/meta-prompt-engineering-review agents rules+structure`

**Typical workflow:**
```
/meta-prompt-engineering-review → audit report → user review
    → /meta-prompt-engineering-optimize (if fixes needed)
    → prompt-validator (automatic re-validation)
```

---

## Common Scenarios — Recommended Entry Point

| Scenario | Recommended Entry Point | Why |
|---|---|---|
| "I need a new prompt for grammar checking" | `/prompt-create-update` | Simple, known pattern |
| "I need a new multi-agent workflow for code review" | `/prompt-design` | Complex, needs decomposition |
| "Is my prompt file valid?" | `/prompt-review` | Direct validation |
| "Fix the tool alignment issue in my agent" | `@agent-updater` | Specific fix, known issue |
| "I have a new best practice to document" | `/context-file-create-update` | Context file creation |
| "I need rules for a new file type" | `/instruction-file-create-update` | Instruction file creation |
| "I want to create a new specialized agent" | `/agent-design` | Complex, needs role challenge |
| "Are my PE artifacts consistent?" | `@meta-reviewer` | System-level audit with coherence checks |
| "I want to reduce token waste in my PE artifacts" | `@meta-reviewer` → `@meta-optimizer` | Audit first, then apply optimizations |

---

## Anti-Patterns

### ❌ Using Orchestrator for Simple Tasks

**Wrong**: Running `/prompt-design` for a simple validation prompt with clear requirements.
**Right**: Use `/prompt-create-update` — faster, fewer tokens, same quality for known patterns.

### ❌ Using Standalone Prompts for Novel Workflows

**Wrong**: Using `/prompt-create-update` for a complex multi-agent orchestration with uncertain scope.
**Right**: Use `/prompt-design` — the use case challenge and pattern research phases will catch issues early.

### ❌ Skipping Validation After Creation

**Wrong**: Creating an agent with `/agent-design` and never validating it.
**Right**: Orchestrator prompts auto-hand-off to validators. If using standalone, run `/agent-review` after.

### ❌ Modifying Agents Directly Instead of Using Updaters

**Wrong**: Manually editing `.agent.md` files without validation.
**Right**: Use `@agent-updater` with specific changes, which auto-hands-off to `@agent-validator` for re-validation.

---

## References

- **Internal**: [16-artifact-dependency-map.md](16-artifact-dependency-map.md), [17-artifact-lifecycle-management.md](17-artifact-lifecycle-management.md), [03-file-type-decision-guide.md](03-file-type-decision-guide.md)
- **Prompts**: `.github/prompts/00.00-prompt-engineering/` (all PE prompts)
- **Agents**: `.github/agents/00.00 prompt-engineering/` (all PE agents)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2026-03-08 | Initial version — decision trees, scenario mapping, anti-patterns | System |
| 1.1.0 | 2026-03-08 | Phase 3 — added meta-reviewer, meta-optimizer to agent listing and Phase E; updated scenarios | System |
| 1.2.0 | 2026-03-08 | Phase 4 — meta-prompts now created; updated Phase E with slash commands and workflow | System |
