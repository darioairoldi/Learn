---
description: Instructions for creating and updating custom agent files
applyTo: '.github/agents/**/*.agent.md'
---

# Custom Agent File Creation & Update Instructions

## Purpose
Custom agents are **specialized assistants for specific roles or implementation tasks**.  
They operate at the implementation level with detailed technical instructions, tool access, and autonomous execution capabilities.

## Context Engineering Principles

**📖 Complete guidance:** [.copilot/context/prompt-engineering/context-engineering-principles.md](.copilot/context/prompt-engineering/context-engineering-principles.md)

**Key principles for agents** (see context file for full details):
1. **Narrow Scope** - One agent = One specialized role
2. **Early Commands** - Executable commands in first sections
3. **Imperative Language** - Direct, action-oriented instructions  
4. **Three-Tier Boundaries** - Always Do / Ask First / Never Do
5. **Context Minimization** - Reference external files, don't embed
6. **Tool Scoping** - Only essential tools for agent role

## Tool Selection

**📖 Complete guidance:** [.copilot/context/prompt-engineering/tool-composition-guide.md](.copilot/context/prompt-engineering/tool-composition-guide.md)

**Agent/Tool Alignment:**
- `agent: plan` (read-only) + [read_file, grep_search, semantic_search]
- `agent: agent` (full access) + read + write tools
- **Never** mix `agent: plan` with write tools

**Tool selection by role:**
- **Researcher**: semantic_search, grep_search, read_file, file_search, list_dir
- **Builder**: read_file, semantic_search, create_file, file_search
- **Validator**: read_file, grep_search, file_search (read-only)
- **Updater**: read_file, grep_search, replace_string_in_file, multi_replace_string_in_file

## Required YAML Frontmatter

```yaml
---
name: agent-name
description: "One-sentence description of agent''s role"
tools: [''specific'', ''tools'', ''only'']  # Critical: narrow tool scope
model: claude-sonnet-4.5  # Optional: specify preferred model
target: vscode  # Optional: vscode (default) or github-copilot
---
```

**Tool Scoping is Critical**:
- Agents with 20+ tools suffer tool clash
- Successful agents limit to 3-7 essential tools
- Example tool combinations:
  - Docs agent: `[''codebase'', ''editor'', ''filesystem'']`
  - Test agent: `[''codebase'', ''editor'', ''terminal'']`
  - API agent: `[''codebase'', ''editor'', ''terminal'', ''web_search'']`

## Execution Contexts (v1.107+)

VS Code 1.107 introduced **Agent HQ**, a unified interface for managing agent sessions across three execution contexts:

| Context | Description | Isolation | Best For |
|---------|-------------|-----------|----------|
| **Local** | Interactive agent in current workspace | None—modifies workspace directly | Quick tasks, interactive refinement |
| **Background** | Runs autonomously using Git work trees | Full—uses isolated work tree | Long-running tasks without blocking |
| **Cloud** | Runs on GitHub infrastructure, creates PRs | Full—new branch and PR | Large changes, async collaboration |

**Target field mapping:**
- `target: vscode` → Local or Background context
- `target: github-copilot` → Cloud context (coding agent)

**Cloud-specific features:**
- MCP server configurations via `mcp-servers` field
- Creates pull requests for review
- Runs asynchronously on GitHub infrastructure

**When to use each context:**
- **Local**: Interactive development, quick fixes, code exploration
- **Background**: Long-running refactoring, batch operations
- **Cloud**: Large-scale changes, cross-team collaboration, automated workflows

## Agent Templates

**Use specialized templates for agent creation:**

**Existing specialized agents** in `.github/agents/`:
1. **`prompt-researcher.agent.md`** - Research specialist for requirements and pattern discovery
2. **`prompt-builder.agent.md`** - File creation specialist following validated patterns
3. **`prompt-validator.agent.md`** - Quality assurance specialist for comprehensive validation
4. **`prompt-updater.agent.md`** - Update specialist for fixing validation issues

**To create new agents:** Use `@prompt-create-orchestrator` with type `agent` specified.

## Repository-Specific Patterns

### Validation Caching
**📖 Complete guidance:** [.copilot/context/prompt-engineering/validation-caching-pattern.md](.copilot/context/prompt-engineering/validation-caching-pattern.md)

Agents working with article files must:
- ❌ **NEVER modify top YAML** (Quarto metadata)
- ✅ **Update bottom metadata block only** (HTML comment at end)
- Check `last_run` timestamps before validation
- Skip validation if `last_run < 7 days` AND content unchanged

### Dual YAML Metadata (THIS Repository)
Agents working with article files must understand:

1. **Top YAML Block**: Quarto metadata (title, author, date)
   - ❌ Agents NEVER modify this block
   
2. **Bottom YAML Block**: Validation metadata  
   - ✅ Agents update relevant validation sections only
   - Must check `last_run` timestamps
   - Skip validation if recent (<7 days) and content unchanged

Reference: `.copilot/context/dual-yaml-helpers.md`

### Multi-Phase Workflows
For complex operations, implement checkpoint pattern:

```markdown
## Workflow

### Phase 1: Scan and Present Plan
1. Analyze codebase/requirements
2. Identify files to modify
3. Present plan to user
4. **STOP - Wait for "go ahead"**

### Phase 2: Execute Plan
1. Make approved changes
2. Run validation commands
3. Generate summary report
```

### Intermediary Reports
Use **text with semantic structure** between phases:
- LLMs process natural language more reliably than JSON
- Semantic structure provides implicit prioritization
- Creates human-readable checkpoints
- Example: Generate text report after analysis, use as input for generation phase

## Six Essential Agents (from 2,500+ Repo Analysis)

### 1. @docs-agent
**Purpose**: Technical documentation generation
**Tools**: `[''codebase'', ''editor'', ''filesystem'']`
**Key Boundaries**:
- ✅ Write to `docs/`, read from `src/`
- ⚠️ Ask before major rewrites
- 🚫 Never modify source code

### 2. @test-agent  
**Purpose**: Test generation and quality assurance
**Tools**: `[''codebase'', ''editor'', ''terminal'']`
**Key Boundaries**:
- ✅ Write to `tests/`, follow testing patterns
- ⚠️ Ask before changing test framework
- 🚫 Never remove failing tests to make builds pass

### 3. @lint-agent
**Purpose**: Code style and formatting fixes
**Tools**: `[''editor'', ''terminal'']`
**Key Boundaries**:
- ✅ Fix style issues, run formatters
- ⚠️ Ask if style rules conflict
- 🚫 Never change code logic

### 4. @api-agent
**Purpose**: API endpoint development  
**Tools**: `[''codebase'', ''editor'', ''terminal'', ''web_search'']`
**Key Boundaries**:
- ✅ Create/modify API routes
- ⚠️ Ask before database schema changes
- 🚫 Never modify authentication logic without approval

### 5. @security-agent
**Purpose**: Security analysis and vulnerability assessment
**Tools**: `[''codebase'', ''terminal'', ''web_search'']`
**Key Boundaries**:
- ✅ Scan for vulnerabilities, suggest fixes
- ⚠️ Ask before applying security patches
- 🚫 Never commit fixes that break functionality

### 6. @deploy-agent
**Purpose**: Build and deployment to dev environments
**Tools**: `[''terminal'', ''filesystem'']`
**Key Boundaries**:
- ✅ Deploy to dev/staging only
- ⚠️ **Always** require explicit approval
- 🚫 Never deploy to production

## Context Rot Prevention in Agents

Agents are particularly vulnerable to context rot due to long-running conversations. Mitigate with:

1. **Narrow Specialization**: One role, not "general helper"
2. **Limited Tools**: 3-7 tools maximum
3. **Clear Boundaries**: Prevent scope creep
4. **Structured Sections**: Organized for LLM parsing
5. **Early Commands**: Critical info up front
6. **Validation Checkpoints**: Phase-based workflows with user approval

## Multi-Agent Orchestration

### Using runSubagent Tool
Agents can invoke specialized sub-agents:

```markdown
## Available Sub-Agents
- @security-agent: Security review and vulnerability assessment
- @docs-agent: Documentation generation and updates
- @test-agent: Test case generation and validation

## Orchestration Workflow
1. Analyze user request
2. Decompose into sub-tasks  
3. Invoke appropriate sub-agent for each task using runSubagent tool
4. Aggregate results
5. Present unified response
```

Each sub-agent runs in **isolated context** to prevent cross-contamination.

### Supervisory Agents
For high-stakes operations, use supervisor pattern:

```markdown
## Supervisor Agent Workflow
1. Primary agent executes task
2. Supervisor agent reviews output
3. Supervisor validates boundaries respected
4. Supervisor can reject and request retry
```

## Testing & Iteration

1. **Start minimal**: Core persona + boundaries + 2-3 commands
2. **Test in real scenarios**: Invoke with actual repository tasks
3. **Observe failures**: Note when agent goes off-track
4. **Add specificity**: Tighten boundaries, add examples where agent erred
5. **Iterate gradually**: Best agents grow through iteration, not upfront planning

**Red Flags**:
- Agent asks for clarification on basic project structure → Add to "Project Knowledge"
- Agent attempts forbidden actions → Strengthen "Never Do" section
- Agent produces wrong code style → Add explicit examples
- Agent selects wrong tools → Narrow tool manifest

## Agent Generation with Meta-Agents

Use existing agents to generate new agents:

```markdown
Prompt to Meta-Agent:

Create new custom agent for GitHub Copilot

## Requirements  
- Role: [Documentation writer / Test engineer / API developer]
- Analyze source under [specific directories]
- Generate [specific outputs] in [target directories]
- Style: [Formal technical / Conversational / Reference docs]
- Audience: [Junior engineers / Security auditors / API consumers]

## Boundaries
- Can modify: [specific directories]
- Must ask first: [configuration changes, schema updates]
- Never modify: [protected areas]

## Best Practices
[Attach: .github/instructions/agents.instructions.md]
- Analyze key points
- Apply to generated agent

## Important Notes
- Use clear boundaries (Always/Ask/Never)
- Include executable commands
- Specify exact tools needed
- Provide code style examples
```

The meta-agent produces a complete agent file following this structure.

## Quality Assurance Checklist

Before finalizing an agent file:

- [ ] YAML frontmatter includes name, description, tools
- [ ] Tools list is minimal (3-7 items)
- [ ] Commands section lists exact commands with flags
- [ ] Three-tier boundaries (Always/Ask/Never) defined
- [ ] Code style examples included (good vs bad)
- [ ] Project knowledge specifies tech stack with versions
- [ ] File structure shows where agent reads/writes
- [ ] Naming conventions documented
- [ ] Role/persona clearly defined
- [ ] Tested with real repository tasks

## Production-Ready Agent Requirements

**Applies to ALL agent files** - based on Mario Fontana's ["6 VITAL Rules for Production-Ready Copilot Agents"](https://www.linkedin.com/learning/mastering-ai-agents-the-prompt-engineering-masterclass):

### 1. Response Management Sections

All agents MUST include context-appropriate "I don't know" templates per **Principle 7: Explicit Uncertainty Management**.

**See full guidance:** [.copilot/context/prompt-engineering/context-engineering-principles.md](.copilot/context/prompt-engineering/context-engineering-principles.md#7-explicit-uncertainty-management)

**Required for all agents:**
- Missing information scenario with three-part template
- Ambiguous requirements scenario with options presentation
- Tool failure scenarios with fallback behavior

**Role-specific scenarios:**
- **Researchers**: No matches found, contradictory sources, insufficient data
- **Builders**: Pattern not found, file access failure, convention unclear
- **Validators**: Missing metadata, ambiguous validation rules, cache issues
- **Updaters**: Cannot locate target code, conflicting patterns, unsafe changes

### 2. Embedded Test Scenarios

Agents with complex decision-making should include test scenarios:

```markdown
## Test Scenarios (Internal Validation)

### Test 1: Standard Case
**Input:** [typical request]
**Expected:** [correct behavior]

### Test 2: Ambiguous Input
**Input:** [vague request]
**Expected:** Asks clarifying questions

### Test 3: Missing Context
**Input:** [incomplete information]
**Expected:** Uses "I couldn't find X" template, doesn't hallucinate
```

**When to include tests:**
- Agents that make autonomous decisions (updaters, builders)
- Agents that validate complex patterns (validators, reviewers)
- Agents coordinating workflows (orchestrators)

**When to skip:**
- Simple utility agents with deterministic behavior
- Pure pass-through/delegation agents

### 3. Token Budget Awareness

**Agent file limits:** < 1500 tokens (recommended)

**Optimization techniques:**
- Reference context files extensively (`.copilot/context/`)
- Use imperative language (no filler)
- Factor complex agents into specialist + orchestrator
- Embed only role-critical knowledge

**Context Rot Prevention** (already implemented in this repository):
- SHA-256 content hashing for change detection
- 7-day validation caching to reduce redundant processing
- Timestamp-based validation skip logic

**See existing implementation:** `.copilot/context/prompt-engineering/validation-caching-pattern.md`

#### Agent Context Accumulation

Agents persist across multiple chat turns, so size impacts all interactions:

**Single Turn Impact:**
```
Agent: 1,200 tokens (loaded when switched)
+ Instructions: 800 tokens (auto-applied)
+ User question: 100 tokens
+ Code context: 2,000 tokens
= 4,100 tokens per turn
```

**5-Turn Conversation Impact:**
```
Agent: 1,200 tokens (persistent)
+ Instructions: 800 tokens (persistent)
+ Turn 1-5 questions: 500 tokens (100 each)
+ Turn 1-5 responses: 2,000 tokens (400 each)
+ Code references: 3,000 tokens (accumulated)
= 7,500 tokens accumulated
```

**Why Agent Size Matters More Than Prompts:**
- **Prompts**: Load once per invocation, then cleared
- **Agents**: Load once per session, persist across many turns
- **Impact**: Smaller agents = more context available for actual work

**Optimization Strategy:**
- Keep agent core instructions < 1,000 tokens
- Extract language-specific rules to instruction files
- Reference detailed examples in context files
- Use handoffs to specialized agents instead of embedding all knowledge

### 4. Tool Alignment Validation

**Critical check** - prevents runtime failures:

```markdown
## Tool Configuration

agent: plan  # READ-ONLY MODE
tools:
  - read_file
  - semantic_search
  - grep_search
  # ❌ NEVER include write tools with agent: plan
```

**Validator checks** (`@prompt-validator` Phase 5):
- `agent: plan` + write tools → ❌ FAIL (misalignment)
- `agent: agent` + only read tools → ⚠️ WARNING (consider `plan` mode)
- Excessive tools (>10) → ⚠️ WARNING (tool clash risk)

## References

- [GitHub: How to write great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) - Analysis of 2,500+ agent files
- [VS Code: Custom Agents](https://code.visualstudio.com/docs/copilot/copilot-customization) - Official agent documentation
- [Microsoft: Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) - Context engineering principles
- [OpenAI: Reasoning Best Practices](https://platform.openai.com/docs/guides/reasoning-best-practices) - Chain-of-thought and phase-based patterns
- `.github/copilot-instructions.md` - Repository-wide context and conventions

**Related instruction files:**
- [prompts.instructions.md](./prompts.instructions.md) - Prompt file creation guidance
- [skills.instructions.md](./skills.instructions.md) - Agent Skill (SKILL.md) creation guidance

**📖 Complete guidance:** [03.00 tech/05.02 PromptEngineering/04. how_to_structure_content_for_copilot_agent_files.md](../../03.00%20tech/05.02%20PromptEngineering/04.%20how_to_structure_content_for_copilot_agent_files.md)
