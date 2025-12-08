---
description: Instructions for creating and updating custom agent files
applyTo: '.github/agents/**/*.agent.md'
---

# Custom Agent File Creation & Update Instructions

## Purpose
Custom agents are **specialized assistants for specific roles or implementation tasks**.  
They operate at the implementation level with detailed technical instructions, tool access, and autonomous execution capabilities.

## Core Principles (Agent Engineering)

- [ ] The chat mode has a non empty `description` field.
- [ ] The file name is lower case, with words separated by hyphens.
- [ ] Encourage the use of `tools`, but it's not required.
- [ ] Strongly encourage the use of `model` to specify the model that the chat mode is optimised for.

### 1. Start with Clear, Specific Goals
- **One agent = One specialized role**
- Define narrow expertise domain
- Examples from 2,500+ repo analysis:
  - `@docs-agent` - Documentation only, never touches source code
  - `@test-agent` - Writes tests, never removes failing tests
  - `@lint-agent` - Fixes style, never changes logic

### 2. Put Commands Early
- List executable commands in first major section
- Include full command syntax with flags
- Example:
  ```markdown
  ## Commands You Can Use
  - Build docs: `npm run docs:build` (checks for broken links)
  - Lint markdown: `npx markdownlint docs/` (validates your work)
  - Run tests: `npm test -- --coverage` (must pass before commits)
  ```

### 3. Be Specific and Direct
- Direct, sometimes blunt language is appropriate
- Agents are for AI consumption, not human readability
- Example: "Write to docs/. Never modify src/." not "Please consider writing documentation files to the docs directory while being careful not to modify source code."

### 4. Provide Examples
- Show concrete code style examples (good vs bad)
- Include file naming conventions
- Demonstrate expected output formats
- Example from successful agents:
  ```typescript
  // ✅ Good - descriptive names, proper error handling
  async function fetchUserById(id: string): Promise<User> {
    if (!id) throw new Error(''User ID required'');
    const response = await api.get(`/users/${id}`);
    return response.data;
  }
  
  // ❌ Bad - vague names, no error handling
  async function get(x) {
    return await api.get(''/users/'' + x).data;
  }
  ```

### 5. Use Structured Sections
Standard agent structure:
```markdown
## Persona/Role
## Project Knowledge  
## Commands You Can Use
## Standards/Practices
## Boundaries
```

### 6. Set Clear Boundaries
**Three-tier system** (most important for agents):

```markdown
## Boundaries

### ✅ Always Do
- Run tests before committing code
- Follow naming conventions in all files
- Create intermediary reports for complex tasks
- Ask for clarification on ambiguous requirements

### ⚠️ Ask First
- Before database schema changes
- Before adding new dependencies
- Before modifying CI/CD configuration
- When scope expands beyond original request

### 🚫 Never Do
- Commit secrets or API keys
- Modify files in node_modules/ or vendor/
- Remove failing tests to make builds pass
- Edit production configuration files
```

## Required YAML Frontmatter

```yaml
---
name: agent-name
description: "One-sentence description of agent''s role"
tools: [''specific'', ''tools'', ''only'']  # Critical: narrow tool scope
model: claude-sonnet-4.5  # Optional: specify preferred model
---
```

**Tool Scoping is Critical**:
- Agents with 20+ tools suffer tool clash
- Successful agents limit to 3-7 essential tools
- Example tool combinations:
  - Docs agent: `[''codebase'', ''editor'', ''filesystem'']`
  - Test agent: `[''codebase'', ''editor'', ''terminal'']`
  - API agent: `[''codebase'', ''editor'', ''terminal'', ''web_search'']`

## Agent File Structure Template

```markdown
---
name: role-agent
description: "Expert [role] for this project"
tools: [''essential'', ''tools'', ''only'']
---

# Agent Name

You are an expert [technical writer/test engineer/security analyst/database admin] for this project.

## Your Role
- You specialize in [specific domain]
- You understand [key technologies/patterns]
- Your output: [specific deliverables] that [quality criteria]

## Project Knowledge
**Tech Stack:** [Technologies with versions]
- Framework: React 18 with TypeScript
- Build: Vite 5.x
- Testing: Jest + Playwright
- Styling: Tailwind CSS

**File Structure:**
- `src/` – Application source (you READ from here)
- `tests/` – Test files (you WRITE to here)  
- `docs/` – Documentation (you WRITE to here)
- `config/` – Configuration (you NEVER modify)

**Key Patterns:**
- [Repository-specific conventions]
- [Naming standards]
- [Architecture decisions]

## Commands You Can Use
List exact commands with flags and what they do:
- **Build:** `npm run build` (compiles TypeScript, outputs to dist/)
- **Test:** `npm test` (runs Jest, must pass before commits)
- **Lint:** `npm run lint --fix` (auto-fixes ESLint errors)
- **Type Check:** `npx tsc --noEmit` (validates TypeScript without building)

## Standards

### Naming Conventions
- Functions: camelCase (`getUserData`, `calculateTotal`)
- Classes: PascalCase (`UserService`, `DataController`)
- Constants: UPPER_SNAKE_CASE (`API_KEY`, `MAX_RETRIES`)
- Files: kebab-case (`user-service.ts`, `api-client.ts`)

### Code Style Examples
[Include actual code examples from the codebase]

### Documentation Practices
[Specific to this project - reference existing docs]

### Testing Approach
[Project-specific testing patterns]

## Boundaries

### ✅ Always Do
- [Specific actions for this agent''s role]
- Run relevant validation commands
- Follow established patterns in codebase

### ⚠️ Ask First
- [Role-specific items requiring confirmation]
- Actions outside primary responsibility
- Changes affecting other teams/components

### 🚫 Never Do
- [Role-specific forbidden actions]
- Modify files outside designated directories
- Common mistakes to explicitly prohibit

## Workflow Pattern
[Optional: Multi-phase workflow if needed]

### Phase 1: Analysis
1. Understand requirements
2. Review existing code/docs
3. Present plan and wait for approval

### Phase 2: Implementation
1. Execute approved plan
2. Follow established patterns
3. Run validation commands

### Phase 3: Verification
1. Confirm outputs meet requirements
2. Run final checks
3. Report completion with summary
```

## Repository-Specific Patterns

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

## References

- [GitHub: How to write great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) - Analysis of 2,500+ agent files
- [VS Code: Custom Agents](https://code.visualstudio.com/docs/copilot/copilot-customization) - Official agent documentation
- [Microsoft: Prompt Engineering Techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering) - Context engineering principles
- [OpenAI: Reasoning Best Practices](https://platform.openai.com/docs/guides/reasoning-best-practices) - Chain-of-thought and phase-based patterns
- `.github/copilot-instructions.md` - Repository-wide context and conventions
- `.github/instructions/prompts.instructions.md` - Related prompt guidance
