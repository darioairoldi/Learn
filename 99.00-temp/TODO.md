
## Series Review: Agents vs. Subagents vs. Skills vs. Instructions vs. Context Files

### Review scope

I read the decision frameworks, comparison tables, and "when to use" sections across **all major articles** in the series: 01.00 (getting-started), 02.00 (naming), 03.00 (prompts), 04.00 (agents), 05.00 (instructions), 06.00 (skills), 09.50 (tools), 10.00 (orchestrators), and 11.00 (subagents).

---

### What the series does well

**Existing comparison tables are strong.** Four articles provide side-by-side comparisons of the core four types (Prompt / Agent / Instruction / Skill):

| Article | Location | Columns covered |
|---------|----------|-----------------|
| 01.00-how_github_copilot_uses_markdown_and_prompt_folders.md | "Key Differences from Other Customizations" | File, Activation, Resources, Cross-platform, Tool Control, Handoffs |
| 02.00-how_to_name_and_organize_prompt_files.md | "Skills vs. Other Resource Types" | Trigger, Scope, Bundled Resources |
| 04.00-how_to_structure_content_for_copilot_agent_files.md | Full Decision Framework | Decision tree + detailed criteria per type |
| 06.00-how_to_structure_content_for_copilot_skills.md | "Skills vs Other Customization Types" | File, Activation, Resources, Cross-platform, Tool Control, Handoffs, Standard |

**Subagent mechanics are thoroughly covered** in articles 10.00-how_to_design_orchestrator_prompts.md (Handoffs vs. subagents table) and 11.00 (full article on subagent execution, `user-invokable`, `disable-model-invocation`, `agents` array, orchestration patterns).

**Each "structure" article (03-06) has a "When to Use / Don't Use" section** with appropriate cross-references.

---

### Gaps identified

#### Gap 1 (Critical): No unified 5-way comparison

No single article compares ALL FIVE concepts together:

1. Prompt files (`.prompt.md`)
2. Agent files (`.agent.md`) — including the subagent usage mode
3. Instruction files (`.instructions.md` + copilot-instructions.md)
4. Skills (`SKILL.md`)
5. Context files (context or referenced markdown)

The existing tables consistently cover 4 of 5 (Prompt/Agent/Instruction/Skill) but never include **context files** as a formal category, and never distinguish **agent-as-standalone vs. agent-as-subagent** within the comparison.

#### Gap 2 (Critical): Context files aren't formally introduced

Context files are mentioned as implementation details throughout the series — article 03 covers them as "supporting materials," 04.00-how_to_structure_content_for_copilot_agent_files.md mentions "Pattern 3: Extract Examples to Context Files." But context files are **never defined as a customization mechanism** comparable to the other four types, and never appear in any comparison table.

They're a de facto context injection mechanism (manually referenced markdown), but the series doesn't explain:
- How they differ from instructions (manual reference vs. auto-injection)
- How they differ from skills (no discovery, no progressive disclosure)
- When to choose them over the native types

#### Gap 3 (Significant): Subagent concept doesn't appear in articles 01-06

A reader working through articles 01 through 06 sequentially would learn about Prompts, Agents, Instructions, and Skills — but would have **no awareness that agents can also be used as subagents** with fundamentally different characteristics (context isolation, no UI, no handoffs, agent-initiated invocation). The concept only appears in articles 10-11.

The decision frameworks in 04.00-how_to_structure_content_for_copilot_agent_files.md and 05.00-how_to_structure_content_for_copilot_instruction_files.md don't include "subagent" as an option.

#### Gap 4 (Significant): Platform support not integrated into decision trees

The decision trees in articles 04 and 05 don't include a platform branch. A reader choosing between Skills (cross-platform) and Agents (VS Code-only) for a CLI-compatible workflow wouldn't discover this constraint from the decision flowcharts. Article 06's comparison table shows the cross-platform column, but it isn't integrated into the decision logic.

#### Gap 5 (Minor): No mental model / analogy section

The series provides excellent technical detail but lacks a quick conceptual framework. Analogies like:
- **Prompts** = customer orders (specific task, on demand)
- **Agents** = specialists you hire (persona, persistent)
- **Instructions** = kitchen rules posted on the wall (always on, file-specific)
- **Skills** = recipe cards loaded into the chef's brain (auto-discovered, resource-rich)
- **Subagents** = sous-chefs who work independently and report back (isolated context)
- **Context files** = reference books on the shelf (manually consulted)

These would help readers quickly orient before diving into technical detail.

#### Gap 6 (Minor): Comparison table columns inconsistent across articles

| Article | Columns used |
|---------|-------------|
| 01.00 | File, Activation, Resources, Cross-platform, Tool Control, Handoffs |
| 02.00 | Trigger, Scope, Bundled Resources |
| 06.00 | File, Activation, Resources, Cross-platform, Tool Control, Handoffs, Standard |

The different column sets for the same core comparison create cognitive load. "Trigger" in 02 = "Activation" in 01/06, but "Scope" in 02 doesn't map to any column in 01/06.

---

### Consistency issues

| Issue | Details |
|-------|---------|
| **Terminology drift** | Article 10 uses "agent-level handoffs" to distinguish from subagents; articles 01-06 use "handoffs" without this qualifier. The distinction between handoff-based orchestration and subagent-based orchestration isn't bridged. |
| **Activation mechanism gaps** | The comparison tables show 4 activation mechanisms (explicit command, file pattern, agent picker, description match) but don't include: always-on (copilot-instructions.md), agent-initiated (`runSubagent`), or manual reference (context files). |
| **Forward references missing** | Articles 03-06 don't mention that file types can participate in subagent orchestrations. Readers of article 04 learn about handoffs but won't discover subagent delegation until article 11. |

---

### Recommendations

#### 1. Create a unified decision guide (new article or major section)

**Where:** Either a new article (e.g., `08.00-choosing-the-right-customization-type.md`) or a major new section in article 01.

**Content:** A single canonical table covering ALL six concepts:

| Type | File | Activation | Context model | Resources | Cross-platform | Tool control | Handoffs |
|------|------|-----------|---------------|-----------|----------------|-------------|----------|
| **Prompt** | `.prompt.md` | On-demand (`/cmd`) | Injected into user prompt | None | VS Code only | Full | No |
| **Agent** | `.agent.md` | Agent picker | Overrides system prompt | None | VS Code only | Full | Yes |
| **Subagent** | `.agent.md` | Agent-initiated (`runSubagent`) | Isolated context window | None | VS Code only | Inherited or overridden | No |
| **Instruction** | `.instructions.md` | Auto (file pattern) | Injected into system prompt | None | VS Code + Coding Agent | None | No |
| **Skill** | `SKILL.md` | Auto (description match) | Progressive disclosure (3 levels) | Templates, scripts, examples | VS Code, CLI, Coding Agent, SDK | Limited | No |
| **Context file** | Any `.md` | Manual reference | Read on demand | Anything in the directory | Depends on referencing mechanism | None | No |

Plus a decision flowchart that includes platform support as a branch.

#### 2. Formally introduce context files in article 01

Add a brief section in article 01 (after Skills) explaining that manually-referenced markdown files are a de facto context mechanism. Clarify:
- They're not a GitHub Copilot feature; they're a convention
- They load only when explicitly referenced (via `#file:`, markdown links in agent/prompt bodies, or read_file tool calls)
- They fill a gap between "always-on instructions" and "on-demand prompts" — they're "on-demand context"

#### 3. Add a subagent forward-reference in article 04's decision framework

In 04.00-how_to_structure_content_for_copilot_agent_files.md, add a note after the "Agent File" branch:

> Agents can also be used as **subagents** — running in isolated context within an orchestration workflow. When an agent is invoked as a subagent, it doesn't show handoff buttons, runs with context isolation, and returns only a summary to the calling agent. See Article 11: Subagent Orchestrations.

#### 4. Add platform support branches to decision trees

In the decision flowcharts in articles 04.00-how_to_structure_content_for_copilot_agent_files.md and 05.00-how_to_structure_content_for_copilot_instruction_files.md, add an early branch:

```
Does this need to work outside VS Code (CLI, coding agent, SDK)?
  YES → Consider Skills (cross-platform) or Instructions (VS Code + coding agent)
  NO  → Continue to Prompt / Agent / Instruction decision
```

#### 5. Standardize comparison table columns

Adopt a canonical column set across all comparison tables. The most complete set is article 06's: **File, Activation, Resources, Cross-platform, Tool Control, Handoffs, Standard**. Add **Context Model** (how the content enters the model's context) for the unified table.

#### 6. Add forward references to articles 03-06

Each article (03-06) should include a brief callout near its "When to Use" section:

> **In orchestration workflows:** This file type can participate in multi-agent workflows via subagents. See Article 11: Subagent Orchestrations for how agents delegate work in isolated contexts.

---

### Summary

The series does an excellent job explaining each customization type **individually** and provides strong comparison tables for the core four types. The critical gap is the **absence of a unified view** that includes all five (or six) concepts — especially context files (never formally introduced) and the agent-vs-subagent distinction (deferred until articles 10-11, absent from earlier decision frameworks). Implementing recommendations 1-3 would close the primary comprehension gap that emerged in our earlier Q&A.