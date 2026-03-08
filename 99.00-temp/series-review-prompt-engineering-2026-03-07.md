---
title: "Series Review: Prompt Engineering for GitHub Copilot"
author: "Dario Airoldi"
date: "2026-03-07"
categories: [tech, prompt-engineering, github-copilot, series-review]
description: "Comprehensive 6-phase review of the 29-article Prompt Engineering series against recent GitHub Copilot releases (VS Code 1.107–1.110, SDK v0.1.30, March 2026 changelog)"
---

# Series Review: Prompt Engineering for GitHub Copilot

**Review date:** 2026-03-07  
**Series folder:** `03.00-tech/05.02-prompt-engineering/`  
**Articles reviewed:** 29 (28 published + 1 unlisted)  
**Web sources consulted:** VS Code 1.99, 1.107, 1.108, 1.110 release notes; GitHub Copilot changelog March 2026; Copilot SDK README  
**Review methodology:** `article-review-series-for-consistency-gaps-and-extensions.prompt.md` v3.1

---

## Executive Summary

### Overall Health Scores

| Dimension | Score | Assessment |
|-----------|-------|------------|
| **Content accuracy** | 6/10 | Multiple version references outdated; model lists stale; feature status flags wrong (hooks "Preview" → GA; skills evolution missing) |
| **Structural architecture** | 5/10 | 13 of 29 articles exceed 1,000 lines; heavy how-to skew (55%); reference section critically thin (1 article) |
| **Terminology consistency** | 7/10 | Generally consistent within articles; cross-article comparison tables repeat with minor variations; some version date errors |
| **Coverage completeness** | 5/10 | 17+ significant gaps from VS Code 1.107–1.110 and March 2026 releases not covered |
| **Cross-referencing** | 8/10 | Strong internal linking between articles; good series navigation via ROADMAP |
| **Relevance to current state** | 5/10 | Series baseline is ~January 2026; 6–8 weeks of major feature releases since then are unaddressed |

### Key Findings (Priority Order)

1. **CRITICAL — 17+ feature gaps**: Copilot Memory, agent plugins, context compaction, Explore subagent, Copilot CLI, agentic browser, fork conversation, shared memory, auto-approve, images in sessions, Jira integration, agentic code review, organization-shared agents, GitHub MCP server built-in, and more — none covered
2. **CRITICAL — Model information stale**: GPT-5.4 GA, Grok Code Fast 1, and deprecation of GPT-5.1 / Gemini 3 Pro not reflected
3. **HIGH — 13 oversized articles**: 45% of articles exceed the 1,000-line threshold; 4 articles exceed 1,800 lines
4. **HIGH — Feature status flags outdated**: Hooks still marked "Preview" (now GA); skills progression from 1.107 → 1.108 → 1.110 not tracked; MCP spec version outdated
5. **MEDIUM — Structural imbalance**: 55% how-to, 3% reference; no tutorials; analysis articles are case studies not Diátaxis-aligned analysis
6. **MEDIUM — Getting Started overlap**: Article 02-getting-started/01.00 (1,184 lines) substantially duplicates overview/01.00

---

## Phase 1: Series Discovery & Inventory

### Series Goals (extracted from ROADMAP.md and overview article)

The series aims to provide a comprehensive guide to all GitHub Copilot customization mechanisms, covering:

1. All 10 customization mechanisms (prompt files, instruction files, context files, agents, skills, hooks, MCP, chat modes, SDK, Copilot Spaces)
2. Conceptual foundations (how Copilot works internally)
3. Practical how-to guides for each mechanism
4. Advanced orchestration patterns (multi-agent workflows)
5. Model-specific optimization
6. Reference material for settings and compatibility

### Article Inventory (29 articles)

| # | Folder | File | Lines | Status |
|---|--------|------|-------|--------|
| 1 | 01-overview | 01.00-the_github_copilot_customization_stack.md | 375 | ✅ Sweet spot |
| 2 | 01-overview | 01.01-appendix_copilot_spaces.md | 326 | ✅ Under threshold |
| 3 | 02-getting-started | 01.00-how_github_copilot_uses_markdown_and_prompt_folders.md | 1,184 | ⚠️ SPLIT candidate |
| 4 | 02-getting-started | 02.00-how_to_name_and_organize_prompt_files.md | 1,028 | ⚠️ SPLIT candidate |
| 5 | 03-concepts | 01.02-how_copilot_assembles_and_processes_prompts.md | 323 | ✅ Under threshold |
| 6 | 03-concepts | 01.03-understanding_prompt_files_instructions_and_context_layers.md | 372 | ✅ Sweet spot |
| 7 | 03-concepts | 01.04-understanding_agents_invocation_handoffs_and_subagents.md | 443 | ✅ Sweet spot |
| 8 | 03-concepts | 01.05-understanding_skills_hooks_and_lifecycle_automation.md | 381 | ✅ Sweet spot |
| 9 | 03-concepts | 01.06-understanding_mcp_and_the_tool_ecosystem.md | 491 | ✅ Sweet spot |
| 10 | 03-concepts | 01.07-understanding_llm_models_and_model_selection.md | 430 | ✅ Sweet spot |
| 11 | 03-concepts | 01.08-chat_modes_agent_hq_and_execution_contexts.md | 355 | ✅ Under threshold |
| 12 | 04-howto | 03.00-how_to_structure_content_for_copilot_prompt_files.md | 1,875 | 🔴 SPLIT required |
| 13 | 04-howto | 04.00-how_to_structure_content_for_copilot_agent_files.md | 1,831 | 🔴 SPLIT required |
| 14 | 04-howto | 05.00-how_to_structure_content_for_copilot_instruction_files.md | 1,029 | ⚠️ SPLIT candidate |
| 15 | 04-howto | 06.00-how_to_structure_content_for_copilot_skills.md | 1,189 | ⚠️ SPLIT candidate |
| 16 | 04-howto | 07.00-how_to_create_mcp_servers_for_copilot.md | 1,411 | 🔴 SPLIT required |
| 17 | 04-howto | 08.00-how_to_optimize_prompts_for_specific_models.md | 752 | ✅ Acceptable |
| 18 | 04-howto | 08.01-appendix_openai_prompting_guide.md | 744 | ✅ Acceptable |
| 19 | 04-howto | 08.02-appendix_anthropic_prompting_guide.md | 889 | ✅ Acceptable |
| 20 | 04-howto | 08.03-appendix_google_prompting_guide.md | 871 | ✅ Acceptable |
| 21 | 04-howto | 09.00-how_to_use_agent_hooks_for_lifecycle_automation.md | 1,065 | ⚠️ SPLIT candidate |
| 22 | 04-howto | 09.50-how_to_leverage_tools_in_prompt_orchestrations.md | 1,060 | ⚠️ SPLIT candidate |
| 23 | 04-howto | 10.00-how_to_design_orchestrator_prompts.md | 754 | ✅ Acceptable |
| 24 | 04-howto | 11.00-how_to_design_subagent_orchestrations.md | 724 | ✅ Acceptable |
| 25 | 04-howto | 12.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 1,176 | ⚠️ SPLIT candidate |
| 26 | 04-howto | 13.00-how_to_optimize_token_consumption_during_prompt_orchestrations.md | 1,479 | 🔴 SPLIT required |
| 27 | 05-analysis | 20-how_to_create_a_prompt_interacting_with_agents.md | 2,336 | 🔴 SPLIT required |
| 28 | 05-analysis | 21.1-example_prompt_interacting_with_agents_plan.md | 2,405 | 🔴 SPLIT required |
| 29 | 05-analysis | 22-prompts-and-markdown-structure-for-a-documentation-site.md | 328 | ✅ (unlisted) |

### Size Distribution

| Category | Count | Percentage |
|----------|-------|------------|
| ✅ Sweet spot (400–800 lines) | 12 | 41% |
| ✅ Under threshold (<400 lines) | 4 | 14% |
| ⚠️ SPLIT candidate (1,000–1,500 lines) | 7 | 24% |
| 🔴 SPLIT required (>1,500 lines) | 6 | 21% |

---

## Phase 2: Content Architecture Validation

### a) Diátaxis Compliance

| Folder | Intended Type | Articles | Actual Compliance |
|--------|--------------|----------|-------------------|
| 01-overview | Explanation | 2 | ✅ Correct — overview + appendix |
| 02-getting-started | Tutorial/Orientation | 2 | ⚠️ Mixed — 01.00 mixes tutorial, reference, and overview content (1,184 lines covering ALL 10 mechanisms) |
| 03-concepts | Explanation | 7 | ✅ Correct — all are conceptual explanations |
| 04-howto | How-to | 16 | ✅ Correct — practical procedural guides |
| 05-analysis | Analysis (custom) | 3 | ⚠️ Content is case studies + planning doc, not standard Diátaxis |
| 06-reference | Reference | 1 | ⚠️ Critically thin — only 1 reference article (settings) |

**Issues:**

1. **02-getting-started/01.00** (1,184 lines) is a mini-encyclopedia, not a getting-started guide. It covers prompt files, instruction files, context files, chat modes, agents, skills, hooks, MCP, SDK, and `.copilot/` folder plus 7 appendices. This duplicates both the overview and individual concept articles.

2. **05-analysis** articles are labeled "analysis" but contain implementation plans (21.1) and case studies (20). The folder doesn't map to a standard Diátaxis type. Article 22 is unlisted and appears to be a documentation-site-specific guide.

3. **06-reference** has only 1 article (settings/compatibility). A series of this size should have at minimum:
   - YAML frontmatter reference (currently buried in howto articles)
   - Tool catalog reference (currently in 09.50)
   - Glossary of terms
   - Version compatibility matrix (currently embedded in overview)

### b) Category Coverage Matrix

| Diátaxis Type | Articles | % | Assessment |
|---------------|----------|---|------------|
| Explanation (overview + concepts) | 9 | 31% | ✅ Good |
| How-to | 16 | 55% | ⚠️ Over-concentrated |
| Tutorial | 0 | 0% | 🔴 Missing |
| Reference | 1 | 3% | 🔴 Critically thin |
| Analysis (custom) | 3 | 10% | ⚠️ Non-standard type |

**Recommendation:** Extract reference material from howto articles into dedicated reference articles. Consider at least 1 tutorial (end-to-end walkthrough of creating a complete customization stack).

### c) Article Scope/Size Analysis

**Articles requiring splitting (>1,500 lines):**

| Article | Lines | Splitting Recommendation |
|---------|-------|------------------------|
| 04-howto/03.00 (prompt files) | 1,875 | Split into: YAML frontmatter reference + content structuring guide + advanced patterns |
| 04-howto/04.00 (agent files) | 1,831 | Split into: agent file basics + execution contexts guide + advanced agent patterns |
| 04-howto/07.00 (MCP servers) | 1,411 | Split into: MCP fundamentals + implementation by language + MCP Apps appendix |
| 04-howto/13.00 (token optimization) | 1,479 | Split into: core strategies (1-6) + advanced strategies (7-9) + implementation patterns |
| 05-analysis/20 (orchestration case study) | 2,336 | Split into: case study walkthrough + implementation reference |
| 05-analysis/21.1 (orchestration plan) | 2,405 | Split into: executive summary + detailed specifications |

**Articles on the boundary (1,000–1,500 lines):**

| Article | Lines | Action |
|---------|-------|--------|
| 02-getting-started/01.00 | 1,184 | Reduce scope — move detailed mechanism coverage to concept articles |
| 02-getting-started/02.00 | 1,028 | Extract naming conventions reference into 06-reference |
| 04-howto/05.00 (instructions) | 1,029 | Review for extraction opportunities |
| 04-howto/06.00 (skills) | 1,189 | Review; skills content needs updates anyway |
| 04-howto/09.00 (hooks) | 1,065 | Review for extraction; needs GA status update |
| 04-howto/09.50 (tools) | 1,060 | Extract tool catalog to reference article |
| 04-howto/12.00 (info flow) | 1,176 | Review for extraction opportunities |

### d) Learning Path Analysis

The ROADMAP.md defines a clear linear reading order (01.00 → 01.01 → 01.02 → ... → 14.00). Cross-references between articles are strong. However:

- **No explicit "beginner path"** for users who only want to use prompt files (the simplest mechanism)
- **No "quick start" path** — the getting-started articles are 1,184 and 1,028 lines respectively, which is intimidating for newcomers
- **Orchestration learning path** (10 → 11 → 12 → 13 → 20 → 21.1) is well-structured with progressive complexity
- **Article 22** (unlisted) is disconnected from the series — no inbound or outbound cross-references

---

## Phase 3: Consistency Analysis

### Terminology Inconsistencies

| Term | Variations Found | Recommended Standard | Affected Articles |
|------|-----------------|---------------------|-------------------|
| Agent mode / agent mode | Mixed casing | "agent mode" (lowercase) | 01.00, 01.08, 03.00, 04.00 |
| VS Code version references | "1.107 (December 2024)" in 06.00 | Should be "1.107 (November 2025)" | 06.00 header banner |
| MCP spec version | "December 2024" / "MCP 1.0" | Should reference "2025-11-25" per 1.107 | 01.06, 07.00 |
| Hooks status | "Preview" / "VS Code 1.109.3" | Should be "GA" per 1.110 | 09.00 header banner, 01.05 |
| Skills status | "Preview" / "VS Code 1.107" | Should note progression: 1.107 → 1.108 → 1.110 (slash commands, plugins) | 06.00 header banner, 01.05 |
| SDK version | "January 2026" / "technical preview" | Now "v0.1.30, 27 releases, BYOK support" | 14.00 |

### Structural Inconsistencies

| Pattern | Expected | Actual Deviation |
|---------|----------|-----------------|
| Comparison tables | Each article compares its mechanism to others | Tables repeat across 05.00, 06.00, 09.00, 09.50 with slightly different columns — should be centralized in a reference article |
| "When to use X" sections | Present in each howto article | Overlapping guidance; reader gets fragmented view. A single decision framework reference would be more effective. |
| Header banners | Preview/experimental warnings present | Status flags are outdated (hooks, skills) |
| Date references | Articles dated 2025-12–2026-02 | No systematic review/update dates tracked |

### Version Reference Contradictions

| Contradiction | Article A | Article B | Resolution |
|--------------|-----------|-----------|------------|
| Skills introduction date | 06.00: "VS Code 1.107 (December 2024)" | 01.05: "1.107" | **Both wrong on date** — 1.107 was November 2025, not December 2024. Fix to "VS Code 1.107 (November 2025)" |
| MCP features | 01.06: "MCP 1.0 (December 2024)" with Tasks, Sampling, Elicitation | 07.00: standard MCP without new spec features | MCP spec 2025-11-25 added URL elicitation, Tasks for long-running calls, enum choices, custom icons. Both need updating. |
| Hooks lifecycle events | 09.00: 8 events listed | 01.05: 8 events referenced | Consistent count, but 1.110 may have expanded events — needs verification |

---

## Phase 4: Redundancy Detection & Coverage Gaps

### Redundancy Analysis

| Content | Primary Location | Duplicated In | Action |
|---------|-----------------|---------------|--------|
| 10-mechanism overview | 01-overview/01.00 | 02-getting-started/01.00 (1,184 lines covering same ground) | **CONSOLIDATE** — reduce getting-started to orientation only, remove mechanism deep-dives |
| Comparison tables (skill vs instruction vs prompt vs agent) | Should be in 06-reference | 05.00, 06.00, 09.00, 09.50, 04.00 — each has its own version | **CONSOLIDATE** — create reference article with master comparison matrix |
| "When to use X" decision guidance | Scattered across all howto articles | 05.00, 06.00, 07.00, 09.00, 01.03 | **CONSOLIDATE** — create comprehensive decision framework reference |
| Context rot discussion | 12.00 (primary) | 01.02, 13.00 | **ACCEPTABLE** — different depths appropriate for each context |
| YAML frontmatter reference | 03.00 (detailed) | 04.00, 05.00, 06.00 (partial) | **EXTRACT** — to a dedicated YAML frontmatter reference article |
| Orchestrator pattern | 10.00 (design), 20 (case study), 21.1 (plan) | Significant overlap between 20 and 10.00 | **ALIGN** — make 20 explicitly a case study applying 10.00, remove duplicate explanations |

### Coverage Gaps (17+ items from recent releases)

#### CRITICAL Gaps (features already GA or widely available)

| # | Gap | Source | Impact | Recommended Article |
|---|-----|--------|--------|-------------------|
| 1 | **Copilot Memory** — persistent memory across sessions, on by default for Pro/Pro+ since March 4, 2026 | GitHub Copilot changelog | HIGH — fundamentally changes context management advice in articles 12.00, 13.00 | New concept article OR major update to 01.08 |
| 2 | **GPT-5.4 GA** (March 5, 2026) — latest GA model | GitHub Copilot changelog | HIGH — model tables in 01.07, 08.00, 08.01 all outdated | Update 01.07, 08.00, 08.01 |
| 3 | **Gemini 3 Pro and GPT-5.1 deprecated** (March 2, 2026) | GitHub Copilot changelog | HIGH — 08.00 and 08.03 reference Gemini 3 Pro without deprecation notice | Update 08.00, 08.03 |
| 4 | **Grok Code Fast 1** available in Copilot Free auto-selection (March 4, 2026) | GitHub Copilot changelog | MEDIUM — new model family not mentioned anywhere | Update 01.07, 08.00 |
| 5 | **Hooks now GA** (VS Code 1.110, February 2026) | VS Code 1.110 release notes | HIGH — article 09.00 says "Preview" in header banner | Update 09.00, 01.05, 01.00 |
| 6 | **MCP spec 2025-11-25** — URL elicitation, Tasks for long-running tool calls, enum choices, custom icons | VS Code 1.107 release notes | HIGH — articles 01.06 and 07.00 reference old spec | Update 01.06, 07.00 |
| 7 | **GitHub MCP Server built-in** (Preview, VS Code 1.107) — built into Copilot Chat extension | VS Code 1.107 release notes | MEDIUM — not mentioned in 07.00 or 01.06 | Add to 07.00, 01.06 |
| 8 | **SDK v0.1.30** — 27 releases, BYOK support, community SDKs (Java, Rust, Clojure, C++) | Copilot SDK README | MEDIUM — article 14.00 references early state | Update 14.00 |

#### HIGH Gaps (new features since January 2026)

| # | Gap | Source | Recommended Article |
|---|-----|--------|-------------------|
| 9 | **Agent plugins** — prepackaged bundles of skills/tools/hooks/MCP servers from Extensions view | VS Code 1.110 | New concept section in 01.05 + new howto article |
| 10 | **Skills as slash commands** — trigger skills directly from chat | VS Code 1.110 | Update 06.00, 01.05 |
| 11 | **Context compaction** — `/compact` command with guidance, large tool output to disk, plan memory persistence | VS Code 1.110 | New section in 13.00 (token optimization) + update 01.08 |
| 12 | **Explore subagent** — built-in lightweight model subagent for parallelized codebase research | VS Code 1.110 | Update 11.00 (subagent orchestrations) |
| 13 | **Auto-approve from chat** — `/autoApprove` and `/yolo` commands with terminal sandboxing | VS Code 1.110 | Update 09.00 (hooks, since it relates to approval control) |
| 14 | **Fork conversation** — branch from any checkpoint in chat | VS Code 1.110 | Update 01.08 (chat modes) |
| 15 | **Shared agent memory** — across Copilot coding agent, CLI, and code review | VS Code 1.110 | New section in Copilot Memory article |
| 16 | **Copilot CLI bundled in VS Code** — native support with diff tabs | VS Code 1.110 | Update 01.00 overview or new appendix |
| 17 | **Organization-shared agents** — agents shared at org level via `.github/agents/` | VS Code 1.107 | Update 04.00, 01.04 |

#### MEDIUM Gaps (newer features, some experimental)

| # | Gap | Source | Recommended Article |
|---|-----|--------|-------------------|
| 18 | **Agentic browser tools** — agents drive integrated browser | VS Code 1.110 (experimental) | Brief mention in 09.50 (tools) |
| 19 | **Images in agent sessions** — visual input to agents | GitHub Copilot changelog (March 5, 2026) | Brief mention in 01.08 |
| 20 | **Copilot coding agent for Jira** — assign issues from Jira | GitHub Copilot changelog (March 5, 2026) | Brief mention in 01.00 or new appendix |
| 21 | **Agentic code review** — code review on agentic architecture | GitHub Copilot changelog (March 5, 2026) | Brief mention in overview |
| 22 | **Figma MCP server** — design/code sync from VS Code | GitHub Copilot changelog (March 6, 2026) | Example in 07.00 (MCP servers) |
| 23 | **Azure Entra ID default auth for BYOK** | VS Code 1.107 | Update reference article 01.09 |
| 24 | **Anthropic extended thinking interleaved** via BYOK | VS Code 1.107 | Update 08.02 (Anthropic appendix) |
| 25 | **Create customizations from chat** — `/create-*` commands for prompts, skills, agents, hooks | VS Code 1.110 | New section or article on chat-based authoring |

---

## Phase 5: Extension Opportunities

### Priority 1: Core Coverage (should be in the series)

| Topic | Type | Estimated Effort | Justification |
|-------|------|-----------------|---------------|
| **Copilot Memory and persistent context** | New concept article | 4–6 hours | Fundamentally changes how prompt engineering works — context now persists across sessions |
| **Agent plugins ecosystem** | New concept section + howto | 3–4 hours | Plugins bundle skills/tools/hooks/MCP into installable packages — the next evolution of customization |
| **Comprehensive decision framework reference** | New reference article | 3–4 hours | Consolidates scattered "when to use X" tables from 6+ articles |
| **YAML frontmatter reference** | New reference article | 2–3 hours | Consolidates prompt/agent/instruction/skill YAML schemas currently buried in howto articles |
| **Version compatibility matrix** | Expand reference 01.09 | 2–3 hours | Track which features require which VS Code version; currently scattered across articles |

### Priority 2: Adjacent Topics

| Topic | Type | Estimated Effort | Justification |
|-------|------|-----------------|---------------|
| **End-to-end tutorial: Building a complete customization stack** | New tutorial | 6–8 hours | The series has 0 tutorials — a guided walkthrough of creating prompts + agents + skills + hooks for a real project |
| **Copilot CLI integration guide** | New howto | 3–4 hours | Copilot CLI is now bundled in VS Code; relevant for prompt engineers who work across IDE and terminal |
| **Context compaction and /compact strategies** | New howto section | 2–3 hours | Directly relevant to token optimization article (13.00) |

### Priority 3: Emerging Topics

| Topic | Type | Estimated Effort | Justification |
|-------|------|-----------------|---------------|
| **Xcode support for customizations** | Appendix | 1–2 hours | When available; currently VS Code and JetBrains only |
| **xAI Grok model family** | Update to 08.00 | 1–2 hours | Grok Code Fast 1 is now in Copilot; may need prompting guide appendix if xAI publishes official guidance |
| **Multi-modal prompting** (images in sessions) | New concept section | 2–3 hours | Images in agent sessions (March 2026) opens visual prompt engineering |

---

## Phase 6: Per-Article Action Items

### Immediate Priority (version/status corrections)

| Article | Action | Details | Effort |
|---------|--------|---------|--------|
| 01-overview/01.00 | UPDATE | Add version references through VS Code 1.110; mention Copilot Memory, agent plugins, Copilot CLI, shared memory; update feature matrix | 2 hours |
| 03-concepts/01.05 | UPDATE | Change hooks status from Preview to GA; add skills progression (1.107 → 1.108 slash commands → 1.110 plugins); add agent plugins concept | 1.5 hours |
| 03-concepts/01.06 | UPDATE | Update MCP spec from "December 2024" to "2025-11-25"; add Tasks, URL elicitation, enum choices; mention GitHub MCP Server built-in | 1.5 hours |
| 03-concepts/01.07 | UPDATE | Add GPT-5.4, Grok Code Fast 1; mark GPT-5.1 and Gemini 3 Pro as deprecated; update model comparison table | 1.5 hours |
| 03-concepts/01.08 | UPDATE | Add fork conversation, context compaction (/compact), images in sessions, plan memory persistence | 1 hour |
| 04-howto/06.00 | UPDATE | Update skills status banner; add slash command invocation; add agent plugins section; fix "1.107 (December 2024)" → "(November 2025)" | 2 hours |
| 04-howto/08.00 | UPDATE | Update model family comparison table with GPT-5.4, Grok, deprecations | 1 hour |
| 04-howto/08.03 | UPDATE | Add deprecation notice for Gemini 3 Pro; note migration guidance | 0.5 hours |
| 04-howto/09.00 | UPDATE | Change header banner from "Preview" to GA; add auto-approve integration (/autoApprove, /yolo); update from 1.109.3 to 1.110 | 1.5 hours |
| 06-reference/01.09 | UPDATE | Add Azure Entra ID default auth; update BYOK providers; add VS Code 1.107–1.110 settings | 1.5 hours |
| 04-howto/14.00 | UPDATE | Update SDK to v0.1.30; add BYOK support; mention community SDKs (Java, Rust, Clojure, C++); reflect 27 releases history | 1.5 hours |

### Short-Term Priority (content gaps)

| Article | Action | Details | Effort |
|---------|--------|---------|--------|
| NEW: 03-concepts/01.09 or 01.10 | CREATE | "Understanding Copilot Memory and persistent context" — covers memory types, cross-session persistence, impact on prompt engineering | 4–6 hours |
| NEW: 06-reference/01.10 | CREATE | "Customization decision framework reference" — consolidated when-to-use guidance | 3–4 hours |
| NEW: 06-reference/01.11 | CREATE | "YAML frontmatter reference" — all YAML schemas for prompt/agent/instruction/skill files | 2–3 hours |
| 04-howto/07.00 | UPDATE | Add MCP spec 2025-11-25 features; mention GitHub MCP Server built-in; add Figma MCP example; update server lifecycle | 2 hours |
| 04-howto/11.00 | UPDATE | Add Explore subagent (built-in); update parallel execution guidance | 1 hour |
| 04-howto/13.00 | UPDATE | Add context compaction (/compact); large tool output to disk; plan memory persistence; update cost estimates | 2 hours |
| 04-howto/04.00 | UPDATE | Add organization-shared agents; update execution contexts; mention agent plugins | 1.5 hours |

### Medium-Term Priority (structural improvements)

| Article | Action | Details | Effort |
|---------|--------|---------|--------|
| 02-getting-started/01.00 | REDUCE | Currently 1,184 lines — remove detailed mechanism descriptions that duplicate overview and concept articles; target <600 lines as a true "getting started" orientation | 3 hours |
| 04-howto/03.00 | SPLIT | 1,875 lines → split into: (a) "How to write prompt file YAML frontmatter" (reference), (b) "How to structure prompt file content" (howto), (c) appendix for advanced patterns | 4 hours |
| 04-howto/04.00 | SPLIT | 1,831 lines → split into: (a) "How to create agent files" (howto basics), (b) "Agent execution contexts and deployment" (howto advanced) | 3 hours |
| 04-howto/07.00 | SPLIT | 1,411 lines → split into: (a) "MCP server fundamentals" (howto), (b) "MCP implementation by language" (howto/reference), (c) "MCP Apps" (appendix) | 4 hours |
| 05-analysis/20 + 21.1 | RESTRUCTURE | 2,336 + 2,405 = 4,741 lines combined — these are case studies; restructure into concise case study (800 lines max) + separate implementation plan document | 5 hours |
| Multiple howto articles | EXTRACT | Remove duplicated comparison tables from 05.00, 06.00, 09.00, 09.50 → cross-reference to new reference article | 3 hours |

### Long-Term Priority (new content)

| Article | Action | Details | Effort |
|---------|--------|---------|--------|
| NEW: Tutorial | CREATE | End-to-end tutorial: "Build a complete Copilot customization stack for your project" — walks through creating each file type for a sample project | 6–8 hours |
| NEW: Copilot CLI | CREATE | "How to use Copilot CLI with your customization stack" — integration guide | 3–4 hours |
| NEW: Agent plugins | CREATE | "How to create and distribute agent plugins" — when plugin system is stable | 4–5 hours |

---

## Appendix A: Web Research Sources

| Source | URL | Key Findings |
|--------|-----|------------|
| VS Code 1.99 Release Notes | code.visualstudio.com/updates/v1_99 | Agent mode GA, MCP support, BYOK preview, unified chat view |
| VS Code 1.107 Release Notes | code.visualstudio.com/updates/v1_107 | Agent HQ, subagents, Claude skills, org-shared agents, MCP spec 2025-11-25, GitHub MCP Server, extended thinking |
| VS Code 1.108 Release Notes | code.visualstudio.com/updates/v1_108 | Agent Skills experimental, terminal auto-approve, agent sessions improvements |
| VS Code 1.110 Changelog | github.blog/changelog/... | Hooks GA, agent plugins, skills as slash commands, agentic browser, /compact, shared memory, Explore subagent, Copilot CLI, fork conversation |
| GitHub Copilot Changelog | github.blog/changelog (March 2026) | GPT-5.4 GA, Grok Code Fast 1, Copilot Memory default, Gemini 3 Pro/GPT-5.1 deprecated, Jira integration, agentic code review, Figma MCP |
| Copilot SDK README | github.com/nicolo-ribaudo/copilot-sdk | v0.1.30, 27 releases, 46 contributors, BYOK support, community SDKs |

## Appendix B: Article Cross-Reference Matrix

Strong cross-references exist between:
- Concepts → Howto (each concept links to its corresponding howto)
- Orchestration chain: 10.00 → 11.00 → 12.00 → 13.00 → 20 → 21.1
- Model chain: 01.07 → 08.00 → 08.01/08.02/08.03

Weak or missing cross-references:
- Article 22 (unlisted) has no inbound references
- 01.01 (Copilot Spaces) is somewhat isolated — only linked from 01.00
- No article references the SDK article (14.00) from the MCP article (07.00) or vice versa
- New features (Memory, plugins, CLI) have no articles to reference

---

## Recommendations Timeline

### Week 1: Version and Status Corrections
- Fix all outdated version references (hooks GA, skills progression, MCP spec, model tables)
- Update 11 existing articles with immediate priority items
- **Estimated effort:** 15 hours

### Week 2–3: Content Gap Filling
- Create Copilot Memory concept article
- Create decision framework reference article
- Create YAML frontmatter reference article
- Update 7 articles with short-term priority items
- **Estimated effort:** 20 hours

### Week 4–6: Structural Improvements
- Split 6 oversized articles
- Reduce getting-started/01.00 scope
- Consolidate comparison tables into reference
- **Estimated effort:** 22 hours

### Month 2+: New Content
- Create end-to-end tutorial
- Create Copilot CLI guide
- Create agent plugins guide (when stable)
- **Estimated effort:** 15–20 hours

**Total estimated effort for full revision: ~70–80 hours**
