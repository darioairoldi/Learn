---
name: promot-createorupdate-prompt-guidance
description: "Generate or update `.github/instructions/prompts.instructions.md` and `.github/instructions/agents.instructions.md` for guiding prompts and agents creation"
agent: agent
model: claude-opus-4.5
tools: []
argument-hint: 'Works with files in active folder or specify paths'
---

# Generate or Update Prompt Instruction files

## Goal
- Generate or update  
  `.github/instructions/prompts.instructions.md` 
  `.github/instructions/agents.instructions.md`  
  for guiding effective prompts and agents creation.

## Workflow

### Phase 1. Analyze Current Conversation
Analyze the current conversation and identify the specific needs for prompt and agent guidance 

### Phase 2. Analyze Public Guidance
- Focus on discovering the public knowledge on Github Copilot behaviour and and guidance on effective prompts structure

- Focus on discovering the essential knowledge that would help creating effective prompts immediately productive and applicable to this content repository. 

### Phase 3. Read and Understand available templates
Read the template files located at:
`.github/copilot/templates/**.md`

Understand the enhanced structure including:
- **Header with metadata** (Date, Author, Status, Severity, ...)
- **Table of Contents** with emoji navigation
- **Comprehensive sections** with detailed subsections
- **Modern formatting** with tables, code blocks, and checklists


### Phase 4. create or update Prompts and Agents Instruction files
- instruction files should apply to creation and update of prompts and agents files
- prompts and agents should Start with Clear, Specific Goals
- prompts shoud work at plan level / workflow definition
- agents should focus at implementation leve land task specific instructions
- prompts and agents shoud use proper tools to avoid clash 
- prompts and agents shoud discover the relevant context to avoid Poisoning
- prompts and agents shoud select the useful context to avoid distraction, confusion or tunnel vision 
- prompts and agents should provide examples
- prompts and agents should use Structured Sections
- prompts and agents should Set Clear Boundaries
- prompts and agents should focus on major components, service boundaries, data flows, and the "why" behind structural decisions
- prompts and agents should focus on Critical workflows (context search, builds, tests, debugging) especially commands that aren't obvious from file inspection alone

- prompts and agents can be parametric to ensure wide and effective applicability 
- instruction file can refer on prompt and agent templates if useful to ensure wide and effective applicability 


#### Content Guidelines:
- Source existing AI best practices from `**/{.github/copilot-instructions.md,AGENT.md,AGENTS.md,CLAUDE.md,.cursorrules,.windsurfrules,.clinerules,.cursor/rules/**,.windsurf/rules/**,.clinerules/**,README.md}` (do one glob search).

(read more at https://aka.ms/vscode-instructions-docs):
	- If `.github/instructions/**.instructions.md` file exists, merge intelligently - preserve valuable content while updating outdated sections
	- Write concise, actionable instructions (~20-50 lines) using markdown structure
	- Include specific examples from the codebase when describing patterns
	- Avoid generic advice ("write tests", "handle errors") - focus on THIS project's specific approaches
	- Document only discoverable patterns, not aspirational practices
	- Reference key files/directories that exemplify important patterns

Update `.github/instructions/**.instructions.md` for the user, then ask for feedback on any unclear or incomplete sections to iterate.

### Quality Assurance
Ensure the generated guidance
- ✅ is consistent with the current conversation analysis
- ✅ is consistent to public documentation on github copilot and LLM models 
- ✅ focus on creating effective prompts and agents for this repository
- ✅ Uses consistent formatting throughout
- ✅ include clear references from which it was created from

:


