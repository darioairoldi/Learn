---
name: pe-meta-design
description: "Design a new PE-for-PE artifact with full research → build → validate pipeline plus vision alignment, category compliance, and ecosystem coherence checks"
agent: agent
model: claude-opus-4.6
tools:
  - semantic_search
  - read_file
  - file_search
  - grep_search
  - list_dir
  - create_file
handoffs:
  - label: "Research Requirements"
    agent: pe-con-researcher
    send: true
  - label: "Build Artifact"
    agent: pe-con-builder
    send: true
  - label: "Structural Validation"
    agent: pe-con-validator
    send: true
  - label: "Ecosystem Coherence"
    agent: pe-meta-validator
    send: true
argument-hint: '<artifact-type> <description> — e.g., "agent for validating category coverage" or "context file for MCP tool composition patterns"'
version: "1.0.0"
last_updated: "2026-04-28"
goal: "Design and create a PE-for-PE artifact that is both structurally correct and strategically aligned with the PE vision, using the full research → build → validate pipeline with added strategic checks"
scope:
  covers:
    - "Full design pipeline for PE-for-PE artifacts (research → strategic check → build → double validate)"
    - "Vision alignment enforcement during design"
    - "Category reference compliance by construction"
    - "Ecosystem impact analysis before creation"
  excludes:
    - "Domain artifacts (article-writing, documentation — use /pe-con-design for those)"
    - "Ecosystem-wide audits (use /pe-meta-update for those)"
    - "Updates to existing artifacts (use /pe-meta-create-update for those)"
boundaries:
  - "MUST load PE-strategic context before research"
  - "MUST pass PE-strategic constraints to pe-con-researcher and pe-con-builder"
  - "MUST run double validation (structural + ecosystem coherence)"
  - "Only for PE-for-PE artifacts — redirect domain artifacts to /pe-con-design"
rationales:
  - "PE-for-PE artifacts set the quality standard — they must be designed with vision alignment from the start"
  - "Adding strategic context to the research phase prevents structurally correct but strategically misaligned artifacts"
  - "Double validation catches issues that structural validation alone misses"
---

# PE-for-PE Artifact Design

Design and create PE artifacts that serve the PE system itself — with vision alignment, category compliance, and ecosystem coherence built in from the start.

**When to use this vs `/pe-con-design`:**
- This prompt → creating PE infrastructure (pe-* agents, pe-* prompts, PE context files, pe-* instructions, pe-* skills)
- `/pe-con-design` → creating domain-specific artifacts (article-writing, documentation, devops)

## Process

### Phase 0: Load PE-domain strategic context

1. **Load vision document** — `read_file` on the current vision document in `06.00-idea/self-updating-prompt-engineering/` (find `*-vision.v*.md` with highest version)
2. **Load STRUCTURE-README.md** — for Functional Categories and required categories
3. **Load strategic review criteria** — `read_file` on the `pe-strategic-review` files from `.copilot/context/00.00-prompt-engineering/` (see STRUCTURE-README.md → Functional Categories)
4. **Load dependency map** — `read_file` on the `dependency-tracking` files from `.copilot/context/00.00-prompt-engineering/`
5. **Load dispatch table** — `read_file` on `.github/templates/00.00-prompt-engineering/artifact-type-dispatch.template.md`
6. **Determine artifact type** from user input

### Phase 1: Research with PE-strategic constraints

Delegate to `@pe-con-researcher` with added requirements:

**Standard research** (pe-con-researcher handles):
- Use case challenge (3-7 scenarios)
- Pattern discovery from existing PE artifacts
- Tool/mode recommendations
- Scope boundary definition

**Additional PE-strategic requirements** (pass as constraints):
- "This artifact MUST align with vision rationales: [list applicable from the vision alignment checklist]"
- "This artifact MUST use Level 1.5 (category) references for any context file references"
- "This artifact MUST meet the PE quality bar (exemplary level) from `05.06-pe-strategic-review-criteria.md`"
- "This artifact MUST have metadata contracts: goal, scope, boundaries, rationales, version"
- "Check the dependency map for overlap with existing artifacts — avoid duplication"

### Phase 2: Strategic alignment review

Before building, verify the research output:

1. **Vision alignment** — does the proposed artifact serve a vision rationale? Which one? If none, question whether this artifact belongs in pe-meta tier.
2. **Category coverage** — if this is a context file, which Functional Category should it belong to? Does it need a new category?
3. **Ecosystem fit** — does this artifact overlap with an existing one? Would extending an existing artifact be better than creating a new one?
4. **Blast radius** — how many existing artifacts will depend on this new one? Higher dependency = higher quality bar.

If strategic issues found: refine requirements and re-run research, or escalate to user.

### Phase 3: Build with PE-strategic constraints

Delegate to `@pe-con-builder` with additional constraints:

- **References**: All context file references MUST use Level 1.5 (category) pattern: `"Load the \`category-name\` files from .copilot/context/00.00-prompt-engineering/ (see STRUCTURE-README.md → Functional Categories)"`
- **Metadata**: MUST include `goal:`, `scope: {covers, excludes}`, `boundaries:`, `rationales:`, `version:`, `last_updated:`
- **N-1 separation**: If the artifact type requires it (check N-1 adoption table in `05.06`), all rule-bearing sections MUST use `**Rule**:` / `**Rationale**:` / `**Example**:` blocks
- **Quality bar**: Boundaries ≥5/2/3 (Always/Ask/Never), test scenarios covering happy+error+edge, response management with recovery actions
- **Naming**: MUST use `pe-` namespace prefix

### Phase 4: Double validation

1. **Structural validation** — delegate to `@pe-con-validator` for standard structural checks
2. **Strategic validation** — check against the strategic review criteria:
   - Vision alignment ✅/❌
   - Category references ✅/❌
   - PE quality bar ✅/❌
   - N-1 separation ✅/❌/N/A
   - Self-update readiness ✅/❌
3. **Ecosystem coherence** (for high-impact artifacts) — delegate to `@pe-meta-validator` for dependency impact

If validation fails: hand back to `@pe-con-builder` for fixes (max 3 iterations).

### Phase 5: Post-creation maintenance

After the artifact is created:
1. **Update STRUCTURE-README.md** if a context file was created (add to File Index + assign to category)
2. **Update `05.01-artifact-dependency-map.md`** with new artifact's dependencies
3. **Update `05.03-pe-workflow-entry-points.md`** if a new prompt or agent entry point was created

## Context Management

pe-meta PE-for-PE prompts have shorter pipelines (5 phases) than pe-gra orchestrators (8 phases) and delegate structural work to pe-con agents. Context accumulation is manageable without formal per-phase summarization. If context exceeds 8,000 tokens before a handoff, summarize prior phases to essential findings only.

## Handoff Data Contracts

| Transition | Strategy | Include | Exclude | Max tokens |
|---|---|---|---|---|
| **Orchestrator → pe-con-researcher** | send: true | User request, artifact type, PE-strategic constraints (vision rationales, L1.5 refs, quality bar, N-1), dispatch table row | Vision document full text, STRUCTURE-README full text | ≤2,000 |
| **pe-con-researcher → Orchestrator** | Structured report | Research report: name, type, mode, tools, scope, requirements with evidence | Raw search results, pattern analysis, full file reads | ≤1,500 |
| **Orchestrator → pe-con-builder** | send: true | Research report + PE constraints (L1.5 mandatory, metadata contracts, N-1, quality bar ≥5/2/3) | Research details, alternatives considered | ≤1,500 |
| **Orchestrator → pe-con-validator** | send: true | File path + "validate this file" | Builder reasoning, research | ≤200 |
| **Orchestrator → pe-meta-validator** | send: true | File path + "ecosystem coherence check" + dependency scope | Structural validation details | ≤500 |

## Response Management

- **Not a PE artifact request** → "This sounds like a domain artifact. Use `/pe-con-design` instead — it handles domain expertise activation."
- **Overlaps with existing artifact** → Present the overlap, ask user: extend existing or create new?
- **All validations pass** → Report success with strategic compliance summary
- **Strategic validation fails but structural passes** → "The artifact is structurally sound but doesn't align with [specific vision rationale]. Here's what needs to change: [...]"

## Embedded Test Scenarios

| # | Scenario | Expected Behavior |
|---|---|---|
| 1 | Design PE context file (happy path) | Phase 0 loads vision → Phase 1 research with PE constraints → Phase 2 strategic check → Phase 3 build with L1.5 refs → Phase 4 double validate → Phase 5 update STRUCTURE-README |
| 2 | Overlap with existing artifact | Phase 2 detects overlap via dependency map → presents options: extend existing or create new → waits for user decision |
| 3 | Domain artifact request (redirect) | Detects non-PE intent → "Use /pe-con-design instead" → STOP |
| 4 | Strategic validation fails after build | Phase 4 strategic check finds missing N-1 separation → hands back to pe-con-builder with fix spec → re-validates (max 3 iterations) |
