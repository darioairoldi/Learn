

# Prompt Engineering Series — Restructuring Plan

## Design principles applied

From 02-structure-and-information-architecture.md:

- **One Diátaxis type per article** — no mixing overview + concepts + reference
- **Progressive disclosure** — surface → detail → expert
- **Content-first design** — map all information before choosing structure
- **Splitting criteria** — distinct purposes, >1000 lines, independent value sections
- **400-800 line target** per article; >1000 lines signals decomposition needed
- **Audience-segmented reading paths** — Explorer, Beginner, Practitioner

---

## Current inventory (22 articles, 25,920 total lines)

| # | Title | Lines | Folder | Actual Diátaxis type | Problem |
|---|-------|-------|--------|---------------------|---------|
| 01.00 | How Copilot uses markdown and prompt folders | 1184 | 02-getting-started | **Mixed**: overview + concept + reference | 4 types in 1 file; 6 appendixes; 1184 lines |
| 01.01 | Copilot Spaces | — | 02-getting-started | Getting-started / Reference | OK |
| 02.00 | How to name and organize prompt files | 1028 | 04-howto | How-to (foundational) | Foundational enough for getting-started |
| 03.00 | Prompt file structure | 1875 | 04-howto | How-to | Over 1000 lines but internally coherent |
| 04.00 | Agent file structure | 1831 | 04-howto | How-to | Over 1000 lines; contains conceptual content |
| 05.00 | Instruction file structure | 1029 | 04-howto | How-to | OK (borderline length) |
| 06.00 | Skill file structure | 1189 | 04-howto | How-to | OK (borderline length) |
| 07.00 | MCP server creation | 1411 | 04-howto | How-to | Over 1000 lines; contains conceptual content |
| 08.00 | Model-specific optimization | 752 | 04-howto | How-to | Contains heavy conceptual sections |
| 08.01 | OpenAI prompting guide | — | 04-howto | Reference appendix | Tightly coupled to 08.00 |
| 08.02 | Anthropic prompting guide | — | 04-howto | Reference appendix | Tightly coupled to 08.00 |
| 08.03 | Google prompting guide | — | 04-howto | Reference appendix | Tightly coupled to 08.00 |
| 09.00 | Agent hooks | 1065 | 04-howto | How-to | Contains conceptual lifecycle content |
| 09.50 | Tools in orchestrations | 1060 | 04-howto | How-to + Reference hybrid | Two-level arch is conceptual; tool catalog is reference |
| 10.00 | Orchestrator prompt design | 754 | 04-howto | How-to | OK |
| 11.00 | Subagent orchestrations | 724 | 04-howto | How-to | OK |
| 12.00 | Information flow | 1176 | 04-howto | How-to | Over 1000 lines |
| 13.00 | Token optimization | 1479 | 04-howto | How-to | Over 1000 lines |
| 14.00 | Copilot SDK | 578 | 04-howto | How-to | OK |
| 20 | Multi-agent orchestration case study | 2336 | 04-howto | **Case study** | Wrong folder |
| 21.1 | Implementation plan example | 2405 | 04-howto | **Case study** | Wrong folder |
| 22 | Documentation site structure | 328 | 04-howto | **Case study** | Wrong folder |

---

## Target structure

### 01-overview/ (1 article)

| # | Title | Source | Type | Status |
|---|-------|--------|------|--------|
| **01.00** | The GitHub Copilot customization stack | **Rewrite** from current 01.00 | Overview | Create now |

**Content:**
- Series introduction — what is Copilot customization, who is this series for
- The customization stack — 8 mechanisms mapped visually (prompt files, instructions, agents, skills, hooks, MCP, SDK, Spaces)
- 1-2 paragraph per mechanism → links to concept articles for "why" and how-to articles for "how"
- Key Takeaways compatibility table (moved from current 01.00)
- Audience-segmented reading paths (Explorer, Beginner, Practitioner)
- Curated references (split from current 01.00's references section)
- **Target: ~500-700 lines**

---

### 02-getting-started/ (2 articles)

| # | Title | Source | Type | Status |
|---|-------|--------|------|--------|
| **01.01** | Copilot Spaces | Keep in place | Getting-started | No change |
| **02.00** | How to name and organize prompt files | **Move** from `04-howto/` | How-to (foundational) | Move now |

**Rationale for 02.00 move:** This is the first practical step a reader takes. It covers file naming, folder organization, .github structure — prerequisite knowledge for every other how-to article. It belongs in "getting started" per the learning progression.

---

### 03-concepts/ (7 explanation articles)

All concept articles follow the Diátaxis **Explanation** pattern: Introduction (why this matters) → Core concepts → Context (how it fits) → Alternatives → Deep dive → Conclusion.

| # | Title | Source | Type | Status |
|---|-------|--------|------|--------|
| **01.02** | How Copilot assembles and processes prompts | **Extract** from 01.00 (L116-215) | Explanation | Create now |
| **01.03** | Understanding prompt files, instructions, and context layers | **New** (synthesized from conceptual sections in 03.00, 05.00, 01.00) | Explanation | Create now |
| **01.04** | Understanding agents, invocation, handoffs, and subagents | **New** (synthesized from 04.00, 11.00, 01.00 Appendix A) | Explanation | Create now |
| **01.05** | Understanding skills, hooks, and lifecycle automation | **New** (synthesized from conceptual sections in 06.00, 09.00) | Explanation | Create now |
| **01.06** | Understanding MCP and the tool ecosystem | **New** (synthesized from 07.00, 09.50) | Explanation | Create now |
| **01.07** | Understanding LLM models and model selection | **New** (synthesized from 08.00, 01.00 Appendix D BYOK) | Explanation | Create now |
| **01.08** | Chat modes, Agent HQ, and execution contexts | **Extract** from 01.00 (L261-330 + Appendix A L770-950) | Explanation | Create now |

**Numbering rationale:** The 01.xx range preserves the "Foundations" convention (01-09). Concept articles ARE foundations — they provide the conceptual bedrock the how-to guides build on.

#### Detailed content plan per concept article

**01.02 — How Copilot assembles and processes prompts**
- System prompt layers diagram (core identity → model rules → tool instructions → output format → custom instructions → agent definition)
- User prompt assembly (prompt file body → environment info → workspace info → context → your message)
- The context window: what it is, how it grows, why earlier content loses influence
- Context rot: the phenomenon, its impact, mitigation strategies
- "Why this matters" decision table: which mechanism to use based on assembly position
- Links to: 03.00 (prompt file how-to), 05.00 (instructions how-to), 12.00 (information flow how-to)
- **Source:** 01.00 L116-215 (full section move)
- **Target: ~400-500 lines**

**01.03 — Understanding prompt files, instructions, and context layers**
- What each is conceptually: prompt files (reusable commands), instructions (persistent rules), context files (background knowledge)
- The critical distinction: prompts inject into user prompt, instructions inject into system prompt
- When to use which — decision triangle with clear criteria
- How they compose: layering instructions + prompt + agent in a single request
- Global vs. workspace vs. path-specific scope
- Links to: 03.00 (prompt how-to), 05.00 (instructions how-to), 02.00 (organization how-to)
- **Source:** New, synthesized from conceptual sections in 01.00 (L48-115, L216-260), 03.00, 05.00
- **Target: ~500-600 lines**

**01.04 — Understanding agents, invocation, handoffs, and subagents**
- What agents are: specialized AI personas with identity, tools, and workflows
- Agents vs. prompts vs. instructions — why agents exist as a separate concept
- Invocation techniques: direct selection, `agents` property for subagent routing, `runSubagent` tool
- Handoff patterns: when an agent delegates to another agent, context isolation, summary returns
- Subagent architecture: independent context windows, synchronous execution, parallel support
- The orchestrator pattern conceptually (not the how-to — that's 10.00)
- `.agent.md` vs `AGENTS.md` — when to use which
- Links to: 04.00 (agent how-to), 10.00 (orchestrator how-to), 11.00 (subagent how-to)
- **Source:** New, synthesized from 01.00 (L330-410), 04.00 conceptual sections, 11.00 conceptual sections, 01.00 Appendix A partial
- **Target: ~500-700 lines**

**01.05 — Understanding skills, hooks, and lifecycle automation**
- Skills: what they are, how they differ from agents and instructions, the "portable capability" concept
- Progressive disclosure in skills: SKILL.md → templates → scripts → examples
- Hooks: deterministic automation at lifecycle points vs. natural language instruction
- The 8 lifecycle events conceptually: when each fires, what each controls
- Skills vs. hooks: complementary mechanisms (hooks for enforcement, skills for capability)
- When to use skills, when hooks, when both
- Links to: 06.00 (skill how-to), 09.00 (hook how-to)
- **Source:** New, synthesized from 01.00 (L410-535), 06.00 conceptual sections, 09.00 conceptual sections
- **Target: ~400-500 lines**

**01.06 — Understanding MCP and the tool ecosystem**
- What MCP is: protocol for extending AI with custom tools, resources, integrations
- The two-level tool architecture: YAML declarations (permissions) vs. runtime tool calls (execution)
- Tool categories conceptually: search, edit, execute, interact, delegate
- Tool sources: built-in tools, MCP servers, VS Code extensions
- When to build an MCP server vs. use built-in tools vs. use extension tools
- MCP Registry, discovery, gallery
- Links to: 07.00 (MCP how-to), 09.50 (tools how-to)
- **Source:** New, synthesized from 01.00 (L535-600), 07.00 conceptual sections, 09.50 conceptual sections
- **Target: ~500-600 lines**

**01.07 — Understanding LLM models and model selection**
- Model families: GPT (explicit instruction), Claude (clarity/context), Gemini (structured), Reasoning (minimal guidance)
- Capabilities comparison: context window, vision, tool calling, reasoning
- The "different compiler" analogy — same prompt, different outputs
- Selection criteria: task type, cost, speed, capability needs
- BYOK concept: bring-your-own-key providers, Language Models Editor, quota implications
- Multi-model architecture patterns: routing different tasks to different models
- HuggingFace integration for open-weights models
- Links to: 08.00 (optimization how-to), 08.01-08.03 (provider reference guides)
- **Source:** New, synthesized from 08.00 conceptual sections, 01.00 Appendix D (BYOK), 01.00 Key Takeaways BYOK row
- **Target: ~500-600 lines**

**01.08 — Chat modes, Agent HQ, and execution contexts**
- The four chat modes: Agent (autonomous editing), Plan (structured planning), Ask (read-only), Edit (inline)
- When to use which mode
- Agent HQ: unified interface for managing sessions across contexts
- Execution contexts: local (interactive), background (work tree), cloud (GitHub PR)
- Work tree isolation: how it works, benefits, workflow
- Plan → Agent delegation workflow
- Entry points for delegation
- Links to: overview (01.00), agent concept (01.04)
- **Source:** 01.00 (L261-330 + Appendix A L770-950) — full section move
- **Target: ~500-600 lines**

---

### 04-howto/ (15 articles — pruned, not restructured)

| # | Title | Lines | Status |
|---|-------|-------|--------|
| 03.00 | How to structure content for prompt files | 1875 | **Keep** |
| 04.00 | How to structure content for agent files | 1831 | **Keep** |
| 05.00 | How to structure content for instruction files | 1029 | **Keep** |
| 06.00 | How to structure content for skill files | 1189 | **Keep** |
| 07.00 | How to create MCP servers for Copilot | 1411 | **Keep** |
| 08.00 | How to optimize prompts for specific models | 752 | **Keep** |
| 08.01 | Appendix: OpenAI prompting guide | — | **Keep** (appendix to 08.00) |
| 08.02 | Appendix: Anthropic prompting guide | — | **Keep** (appendix to 08.00) |
| 08.03 | Appendix: Google prompting guide | — | **Keep** (appendix to 08.00) |
| 09.00 | How to use agent hooks | 1065 | **Keep** |
| 09.50 | How to leverage tools in orchestrations | 1060 | **Keep** |
| 10.00 | How to design orchestrator prompts | 754 | **Keep** |
| 11.00 | How to design subagent orchestrations | 724 | **Keep** |
| 12.00 | How to manage information flow | 1176 | **Keep** |
| 13.00 | How to optimize token consumption | 1479 | **Keep** |
| 14.00 | How to use prompts with the Copilot SDK | 578 | **Keep** |

**Changes to existing how-to articles:**
- Each how-to article's conceptual "Understanding" section gets a brief summary (2-3 sentences) + link to the corresponding concept article
- The full conceptual content stays in the how-to for now (no destructive extraction) — concept articles are synthesized from the same source material, not moved away. This preserves self-containment of how-to articles while concept articles provide deeper, cross-cutting understanding.
- Over time, conceptual sections in how-tos can be trimmed as readers learn to navigate to concepts first.

**Removed from 04-howto/:**
- 02.00 → moved to `02-getting-started/`
- 20, 21.1, 22 → moved to `05-analysis/`

---

### 05-analysis/ (3 articles)

| # | Title | Lines | Source | Status |
|---|-------|-------|--------|--------|
| 20 | Multi-agent prompt orchestration case study | 2336 | **Move** from `04-howto/` | Move now |
| 21.1 | Implementation plan example | 2405 | **Move** from `04-howto/` | Move now |
| 22 | Documentation site structure (unlisted) | 328 | **Move** from `04-howto/` | Move now |

**Rationale:** All three self-identify as applied patterns / case studies. Article 20's own description says "Case study." They demonstrate concepts and how-tos in practice — the Diátaxis "Explanation + applied practice" category.

---

### 06-reference/ (1 article)

| # | Title | Source | Type | Status |
|---|-------|--------|------|--------|
| **01.09** | Copilot settings, IDE support, and compatibility reference | **Extract** from 01.00 appendixes | Reference | Create now |

**Content — all extracted from current 01.00:**
- VS Code Settings Reference tables (prompt, instructions, agent, MCP settings — L640-665)
- Deprecated VS Code Settings (Appendix B — L950-970)
- Feature Compatibility Matrix (Appendix C — L970-1000)
- BYOK tables and provider list (Appendix D tables only — L1000-1100; conceptual BYOK content goes to 01.07)
- Legacy `.chatmode.md` Migration (Appendix E — L1100-1120)
- JetBrains IDE Support: supported files, global instructions, differences (Appendix F — L1120-1150)
- **Target: ~400-500 lines** (mostly tables)

---

## Content traceability matrix (01.00 → destinations)

Every section of the current 1184-line article 01.00 has a mapped destination:

| 01.00 Section | Lines | Destination | Action |
|---------------|-------|-------------|--------|
| YAML + H1 + Introduction | L1-18 | **01.00 overview** (01-overview/) | Rewrite as series overview |
| TOC | L20-47 | — | Replaced by new article TOCs |
| 📝 Prompt Files | L48-115 | **01.00 overview** (brief summary) + **01.03 concept** (detail) | Brief stays in overview; detail synthesized into concept |
| 🏗️ Assembly Architecture | L116-215 | **01.02 concept** (03-concepts/) | Full move |
| 📚 Custom Instructions | L216-260 | **01.00 overview** (brief) + **01.03 concept** | Brief stays; detail to concept |
| 🤖 Chat Modes | L261-330 | **01.08 concept** (03-concepts/) | Full move |
| 🔧 Custom Agents | L330-410 | **01.00 overview** (brief) + **01.04 concept** | Brief stays; detail synthesized |
| 🎯 Agent Skills | L410-470 | **01.00 overview** (brief) + **01.05 concept** | Brief stays; detail synthesized |
| 🪝 Agent Hooks | L470-535 | **01.00 overview** (brief) + **01.05 concept** | Brief stays; detail synthesized |
| 🔌 MCP | L535-600 | **01.00 overview** (brief) + **01.06 concept** | Brief stays; detail synthesized |
| 🧰 Copilot SDK | L600-625 | **01.00 overview** (brief) | Brief stays; detail already in 14.00 |
| 📁 .copilot/ folder | L625-640 | **01.00 overview** | Stays in overview |
| ⚙️ VS Code Settings | L640-665 | **01.09 reference** (06-reference/) | Full move |
| 🔑 Key Takeaways table | L665-680 | **01.00 overview** | Stays in overview |
| 📚 References | L682-770 | Split across destination articles | Each article gets its relevant references |
| Appendix A: Agent Architecture | L770-950 | **01.08 concept** (03-concepts/) | Full move |
| Appendix B: Deprecated Settings | L950-970 | **01.09 reference** (06-reference/) | Full move |
| Appendix C: Compatibility Matrix | L970-1000 | **01.09 reference** (06-reference/) | Full move |
| Related articles links | L1000-1010 | **01.00 overview** | Absorbed into reading paths |
| Appendix D: BYOK | L1010-1100 | **01.07 concept** (concepts) + **01.09 reference** (tables) | Split: conceptual → 01.07, tables → 01.09 |
| Appendix E: Legacy Migration | L1100-1120 | **01.09 reference** (06-reference/) | Full move |
| Appendix F: JetBrains | L1120-1150 | **01.09 reference** (06-reference/) | Full move |
| Validation metadata | L1150-1184 | **01.00 overview** (new metadata block) | Reset for new article |

**Zero information lost.** Every line has a destination.

---

## Resulting structure summary

| Folder | Articles | Count | Diátaxis type |
|--------|----------|-------|---------------|
| **01-overview/** | 01.00 (customization stack) | 1 | Overview |
| **02-getting-started/** | 01.01 (Spaces), 02.00 (naming/organizing) | 2 | Tutorial / First-steps |
| **03-concepts/** | 01.02–01.08 (7 explanation articles) | 7 | Explanation |
| **04-howto/** | 03.00–14.00 (15 how-to guides) | 15 | How-to |
| **05-analysis/** | 20, 21.1, 22 (3 case studies) | 3 | Analysis / Applied patterns |
| **06-reference/** | 01.09 (settings/IDE/compatibility) | 1 | Reference |
| **TOTAL** | | **29** (22 original + 7 new concept articles) | |

All 6 folders populated. Original 22 articles preserved (4 moved, 1 decomposed). 7 new concept articles added. No information lost.

---

## Cross-reference update scope

| Update needed | Files affected |
|---------------|---------------|
| ROADMAP.md paths and article list | 1 file |
| Internal `../` links in all articles | ~25 files |
| readme.txt files (populate with folder descriptions) | 6 files |
| New articles need validation metadata blocks | 8 files (01.00 rewrite + 7 concepts + 01.09 reference) |
| How-to articles: add "See concept article X for..." links | 12 files |

---

## Implementation order

| Phase | Work | Files touched |
|-------|------|---------------|
| **Phase 1: Create concept articles** | Write 01.02-01.08 in `03-concepts/` | 7 new files |
| **Phase 2: Create reference article** | Write 01.09 in `06-reference/` | 1 new file |
| **Phase 3: Rewrite overview** | New 01.00 in `01-overview/` | 1 new file |
| **Phase 4: Move files** | 02.00 → getting-started; 20, 21.1, 22 → analysis | 4 file moves |
| **Phase 5: Delete old 01.00** | Remove decomposed original from 02-getting-started/ | 1 deletion |
| **Phase 6: Update cross-references** | Fix all `../` paths across all articles + ROADMAP | ~25 files |
| **Phase 7: Populate readme.txt** | Add folder descriptions to all 6 readme.txt files | 6 files |

---

Shall I proceed with implementation starting from Phase 1?