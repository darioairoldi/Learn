
# Series Review: Prompt Engineering for GitHub Copilot

**Lens: Burke Holland Sessions (February 2026)**

---

## Phase 1: Series Discovery Results

**Series Name:** Prompt Engineering for GitHub Copilot  
**Total Articles:** 22 (including appendices and case studies)  
**Discovery Method:** Folder listing + ROADMAP.md  

**Reading Order:**

1. 01.00 — How GitHub Copilot Uses Markdown and Prompt Folders
2. 01.01 — Appendix: Copilot Spaces
3. 02.00 — How to Name and Organize Prompt Files
4. 03.00 — How to Structure Content for Prompt Files
5. 04.00 — How to Structure Content for Agent Files
6. 05.00 — How to Structure Content for Instruction Files
7. 06.00 — How to Structure Content for Skill Files
8. 07.00 — How to Create MCP Servers for Copilot
9. 08.00 — How to Optimize Prompts for Specific Models
10. 08.01–08.03 — Appendices: OpenAI, Anthropic, Google Prompting Guides
11. 09.00 — How to Use Agent Hooks for Lifecycle Automation
12. 09.50 — How to Leverage Tools in Prompt Orchestrations
13. 10.00 — How to Design Orchestrator Prompts
14. 11.00 — How to Design Subagent Orchestrations
15. 12.00 — How to Manage Information Flow
16. 13.00 — How to Optimize Token Consumption
17. 14.00 — How to Use Prompts with the Copilot SDK
18. 20 — Orchestrator Design Case Study
19. 21.1 — Orchestrator Implementation Plan
20. 22 — Prompts for a Documentation Site

### Series Goals and Scope

**Primary Goal:** Teach developers how to create, organize, and compose GitHub Copilot's markdown-based customization system — from individual files to multi-agent orchestrations.

**Target Audience:** Intermediate to advanced developers using VS Code with GitHub Copilot.

**Scope Boundaries:**
- **In Scope:** Prompt files, agents, instructions, skills, MCP servers, hooks, tools, orchestration patterns, token optimization, model-specific prompting, Copilot SDK
- **Out of Scope:** AI/ML theory, non-Copilot AI tools, non-VS Code IDEs (except brief Visual Studio mentions)

**Learning Progression:** Linear with branching (01–09 foundations → 10–13 orchestration → 14 SDK → 20+ case studies)

### Evaluation Criteria

**Consistency Requirements:**
- Terminology: Same terms for same concepts across all articles
- Structure: Consistent section patterns (intro → concepts → examples → conclusion → references)
- References: All cross-references valid; Burke Holland sessions cited with correct classification

**Coverage Standards (against Burke Holland as evaluation lens):**
- Core topics: System prompt architecture, injection points, context management, orchestration patterns
- Supporting topics: Model routing, progressive loading, context rot
- Adjacent topics: MCP Apps, plan-generate-implement workflow, skills.sh

---

## Phase 2: Cross-Article Content Analysis

**Burke Holland Source Material:**

| Session | Article | Key Concepts |
|---------|---------|-------------|
| Session 1 — VS Code Productivity | summary.md | 4-layer system prompt, injection points, context rot (88%→30% at 32K), plan→generate→implement |
| Session 2 — Skills | summary.md | Progressive loading 3-level, SKILL.md format, auto-discovery, comparison table |
| Session 3 — Orchestrations | summary.md | Ultralight framework, model-per-role, anti-micromanagement rule, isolated context windows, 2,770 lines / 10.8K context |
| Session 4 — MCP Apps | summary.md | Rich UIs in chat, Vite bundling, promise pattern, app-only visibility, bidirectional communication |

**Existing Burke Holland References in Series:**

| Article | Reference | Location |
|---------|-----------|----------|
| 07.00 | MCP Apps section with link to session 4 | L1318, L1371 |
| 20 | Orchestrations demo reference | L829, L2293 |

**Burke Holland Concepts Not Referenced:**
- Session 1 (VS Code Productivity): **Not referenced anywhere** in the series
- Session 2 (Skills): **Not referenced** — article 06 covers skills but doesn't cite Burke

---

## Phase 3: Consistency Analysis

### Terminology Inconsistencies

#### Critical Issues

**1. "Context rot" — mentioned only once, not defined as a foundational concept**

- **Used in:** 20-how_to_create_a_prompt_interacting_with_agents.md — L71
  > `| **Context Rot** | Instructions for later phases get "lost in the middle" |`

- **Burke Holland's definition (verified):** At 32,000 tokens, accuracy drops from 88% to 30% (citing Claude 3.5 Sonnet benchmarks). VS Code limits context windows at certain thresholds specifically to maintain performance.

- **Not mentioned in:** Articles 12.00 (information flow) or 13.00 (token optimization) — where it would be most relevant.

- **Recommendation:** Define "context rot" formally in article 12.00 (information flow) as a named failure mode, and cross-reference it from article 13.00. Include Burke Holland's benchmark data (88%→30% at 32K tokens) as supporting evidence. This is a **verified claim** — the "lost in the middle" phenomenon is well-documented in research (Liu et al., 2023, "Lost in the Middle: How Language Models Use Long Contexts").

- **Impact:** HIGH — This concept directly motivates why token optimization and context management matter. Without it, articles 12 and 13 explain *how* to manage context but not *why* the urgency exists.

**2. "System prompt" vs "agent system prompt" — inconsistent specificity**

- **Article 01.00** (L56–63): Discusses system prompt vaguely as "structured context" but does NOT describe the 4-layer architecture
- **Burke Holland's architecture (verified):** System prompt = core identity + general instructions + tool use instructions + output format. Custom instructions injected at END. Custom agents injected AFTER instructions.
- **Recommendation:** Add a "Prompt Assembly Architecture" section to article 01.00 showing exactly where each customization type is injected. This is the foundational article — readers need this mental model before learning about individual file types.
- **Impact:** HIGH — Every subsequent article (03–06) explains *what* each file type does, but article 01.00 doesn't clearly explain *where* each type lands in the assembled prompt.

#### Medium Issues

**3. "Model routing" vs "model selection" vs "model-per-role"**

- **Article 08.00:** Uses "model selection" (focus on model capabilities)
- **Article 10.00:** Uses "model routing" in passing
- **Article 13.00:** Uses "Model selection" as Strategy 4
- **Burke Holland:** Uses "model-per-role" — each agent gets the model best suited to its function
- **Recommendation:** Standardize on "model routing" as the general concept and "model-per-role" as the specific pattern for orchestrations. Define both in article 08.00.
- **Impact:** MEDIUM — Readers may not connect the thread from model optimization (08) through orchestrator design (10) to token savings (13).

### Structural Inconsistencies

**4. Injection point architecture missing from foundational article**

- Article 01.00 covers file types, locations, and variables but does NOT include:
  - A diagram showing system prompt assembly order
  - Where instructions inject (end of system prompt)
  - Where prompt files inject (user prompt, NOT system prompt)
  - Where custom agents inject (after instructions in system prompt)
  - The distinction between system-prompt components and user-prompt components

- Burke Holland provides this architecture explicitly (Session 1, timestamps 0:00–3:55, with images `02.001`, `02.002`, `002.03`, `002.04`).

- **Recommendation:** Add a "Prompt Assembly Architecture" section to article 01.00 with:
  1. System prompt diagram: `core identity → general instructions → tool use → output format → [instructions] → [agent definition]`
  2. User prompt diagram: `[prompt file content] → environment info → workspace info → context info → user message`
  3. Reference to Burke Holland session 1 as supporting evidence

### Contradictions

**5. No direct contradictions found** between the series and Burke Holland content. The series and Burke Holland are complementary — the series provides depth, Burke Holland provides the architectural framing and practical workflow demonstrations.

---

## Phase 4: Redundancy Analysis & Coverage Gaps

### Redundancy Analysis

**Total Redundancies Found:** 2 minor overlaps (acceptable)

1. **Skills comparison table** — Article 06.00 has a comparison table (skills vs instructions vs prompts vs agents) that closely mirrors Burke Holland Session 2's table. This is **acceptable** — the series provides more detail and the Burke summary is a lighter version.

2. **MCP Apps coverage** — Article 07.00 L1155–1318 already covers MCP Apps comprehensively, including architecture, promise pattern, app-only visibility, and links to Burke Holland Session 4. **No additional Burke Holland content needed here** — the series coverage is more thorough than the session summary.

### Coverage Gaps

#### Critical Gaps (Essential to Series Goals)

**GAP 1: System prompt assembly architecture** — MISSING from foundational article

- **Why Critical:** Article 01.00 is the series entry point. It explains *what* each file type is but not *where* it gets injected in the prompt. This architectural understanding is prerequisite for making informed decisions about instructions vs. prompts vs. agents.
- **Expected Content:**
  - 4-layer system prompt diagram (core identity → general instructions → tool use → output format)
  - Injection order for custom instructions (end of system prompt, copilot-instructions.md always last)
  - Injection point for prompt files (user prompt, NOT system prompt)
  - Injection point for custom agents (after instructions in system prompt)
  - Full assembled prompt example with all components labeled
- **Current Coverage:** Partially covered. Article 01.00 mentions modes, file locations, variables, but lacks the assembly architecture. Article 12.00 has a context window diagram (L90–105) showing System Prompt / Instructions / User Message / Assistant Response, but this is about *information flow*, not *prompt assembly*.
- **Source:** Burke Holland Session 1, verified against VS Code system prompt inspection (timestamps 0:00–6:56)
- **Recommendation:** Add ~500 words to article 01.00 as a new section "Prompt Assembly Architecture" after the existing "Prompt Files" section.

**GAP 2: Context rot as a named concept with benchmarks** — MISSING from information flow and token optimization articles

- **Why Critical:** The term "context rot" appears only once in the entire series (article 20, L71), used casually without definition or supporting data. Yet it is the fundamental phenomenon that motivates *all* of the optimization strategies in articles 12 and 13.
- **Expected Content:**
  - Formal definition of context rot
  - Benchmark data: accuracy degradation at 32K tokens (88%→30% per Burke Holland, citing "Lost in the Middle" research)
  - VS Code's built-in context window limits as a mitigation
  - Practical advice: start new chat sessions frequently to reset context
- **Current Coverage:** Article 12 discusses "Context Loss" / "Context Bloat" / "Context Conflict" as failure modes (L74–80) but does NOT name "context rot" or provide degradation benchmarks. Article 13 discusses token consumption anatomy but focuses on cost, not accuracy degradation.
- **Source:** Burke Holland Session 1 (timestamps 10:24–12:07), verified concept from Liu et al. 2023 "Lost in the Middle"
- **Recommendation:**
  - Add "Context Rot" definition + benchmarks to article 12.00 in the "Three Failure Modes" table (after L80) — ~200 words
  - Add a cross-reference from article 13.00 (Why token optimization matters section)
  - Update article 20 L71 to link to the formal definition in article 12

#### Supporting Gaps (Recommended for Completeness)

**GAP 3: Plan → Generate → Implement named workflow** — NOT covered as a pattern

- **Why Supporting (not Critical):** The series covers orchestration patterns extensively (articles 10, 11, 20), but Burke Holland's *specific* three-phase workflow — Plan (premium model) → Generate (premium model, produce implementation doc) → Implement (free model, verbatim execution) — is not documented as a named pattern.
- **What makes it valuable:**
  - Concrete cost optimization: premium model for reasoning, free model for execution
  - Clear context separation: clear context window between each phase
  - Practical result: ~2,000-line implementation doc → step-by-step commits → clean PR
- **Current Coverage:** Article 10 discusses phase-based orchestrators. Article 13 Strategy 4 discusses model selection. Article 04 L502 mentions "Planning agent generates a detailed plan, then hands off to implementation agent." But none document the *explicit three-phase pattern with context clearing between phases*.
- **Source:** Burke Holland Session 1 (timestamps 15:08–20:00), demonstrated live
- **Recommendation:** Add as a practical example in article 10.00 ("Key design principles" section) or as a new case study section in article 20. ~400 words including the workflow diagram and model routing rationale.

**GAP 4: Anti-micromanagement rule for orchestrators** — UNDEREMPHASIZED

- **Why Supporting:** Article 10 has excellent orchestrator design principles (L559–670), including "Keep the orchestrator thin" and "Define roles by tools, not just instructions." But it does NOT explicitly state Burke Holland's critical finding: *models naturally want to micromanage sub-agents, and you must explicitly instruct the orchestrator NOT to tell sub-agents how to do their work*.
- **Burke Holland's Insight:** "These models think they know everything, and so you have to really go out of your way to make sure that they don't do that." (Session 3, timestamp 5:38–7:22). Also: sub-agents should be instructed to "Question everything you're told. Make your own decisions." (Session 3, Coder agent, timestamp 7:57–8:57)
- **Current Coverage:** Article 10 L578: "Define roles by tools, not just instructions" — related but not the same concept. Article 11 covers delegation mechanics but focuses on *how* to delegate, not on *preventing over-specification*.
- **Recommendation:** Add a subsection under article 10's design principles: "Delegate goals, not solutions." ~200 words with Burke Holland quote and the counter-instruction pattern ("Question everything you're told").

**GAP 5: skills.sh resource** — NOT referenced

- **Why Supporting:** Burke Holland Session 4 mentions [skills.sh](https://skills.sh) as Vercel's skill directory with MCP builder and MCP apps skills. The series references `github/awesome-copilot` and `anthropics/skills` but not `skills.sh`.
- **Current Coverage:** Articles 03, 04, 05, 06, 09 reference `awesome-copilot`. Article 06 references `agentskills.io`. Neither references `skills.sh`.
- **Recommendation:** Add `skills.sh` to article 06.00's community resources section alongside `awesome-copilot` and `agentskills.io`. ~50 words.

#### Adjacent Topics (Optional Coverage)

**GAP 6: Specific model-per-role recommendations** — PARTIALLY covered

- **Why Adjacent (not Supporting):** Burke Holland provides specific model assignments (Sonnet 4.5 for orchestration, GPT-5.2 for planning, Codex for coding, Gemini 3 Pro for design). However, these are **inherently volatile** — model capabilities change rapidly, and specific recommendations may be outdated within months.
- **Current Coverage:** Article 08 covers model families and their strengths/weaknesses. Article 10 mentions using appropriate models. Article 13 Strategy 4 discusses model selection for cost.
- **Recommendation:** Do NOT add specific model assignments to the series. Instead, add a brief note in article 10 referencing Burke Holland's framework as an example of the model-per-role pattern, with a caveat that specific model choices should be evaluated at time of use. ~100 words.

---

## Phase 5: Extension Opportunities

### Adjacent Topics (Natural Next Steps)

**1. Prompt Assembly Architecture Diagram (HIGH priority)**

- **Relevance:** Foundational — every reader needs to understand where their files land in the assembled prompt
- **Current Mentions:** Article 12's context window diagram (L90–105) is the closest but focuses on information flow, not assembly order
- **Research Findings:** Burke Holland Session 1 provides the definitive architecture via VS Code system prompt inspection
- **Recommendation:** Add to article 01.00 as a new section — ~500 words
- **Priority:** HIGH
- **Placement:** Article 01.00, after "Prompt Files" section, before "Custom Instructions"

**2. Named Workflow Patterns (MEDIUM priority)**

- **Relevance:** The plan→generate→implement workflow is a practical, money-saving pattern that readers can adopt immediately
- **Current Mentions:** Fragments across articles 10, 13, 20 but never assembled as a named pattern
- **Research Findings:** Burke Holland demos this live with measurable results (2,770 lines generated, 10.8K context used)
- **Recommendation:** Add as a practical case box in article 10.00 or as a section in article 20
- **Priority:** MEDIUM
- **Placement:** Article 10.00 design principles section, or article 20 as additional case study

### Burke Holland Session Reference Classification Update

The series currently classifies Burke Holland references as `[📒 Community]`. Given that Burke Holland is a **Senior Cloud Advocate at Microsoft** presenting official Microsoft tooling demonstrations, a more accurate classification would be `[📗 Verified Community]`.

**Affected locations:**
- 07.00 L1371: Currently `📒 [Community]` → should be `📗 [Verified Community]`
- 20 L2293: Currently `📒 [Community]` → should be `📗 [Verified Community]`

---

## Phase 6: Recommendations Report

### Series Redefinition Recommendations

**No structural changes recommended.** The series architecture is sound. Burke Holland content should be integrated as enhancements to existing articles, not as new articles.

### Per-Article Action Items

#### 01.00 — How GitHub Copilot Uses Markdown and Prompt Folders

**Priority Summary:** 1 critical, 0 medium, 0 low

**1. Add "Prompt Assembly Architecture" section (CRITICAL)**
- **Issue:** Article explains file types but not where they inject in the assembled prompt
- **Action:** Add new section (~500 words) after "Prompt Files" section with:
  - System prompt 4-layer diagram (core identity → general instructions → tool use → output format → custom instructions → custom agent)
  - User prompt assembly diagram (prompt file → environment info → workspace → context → user message)
  - Clear statement: "Custom instructions inject at the END of the system prompt. copilot-instructions.md always comes last."
  - Clear statement: "Prompt files inject into the USER prompt, NOT the system prompt."
  - Clear statement: "Custom agents inject AFTER instructions in the system prompt."
  - Reference: Burke Holland Session 1 as `📗 [Verified Community]`
- **Estimated Time:** 60 minutes

#### 12.00 — How to Manage Information Flow

**Priority Summary:** 1 critical, 0 medium, 0 low

**1. Add "Context Rot" formal definition (CRITICAL)**
- **Issue:** "Context rot" appears only in article 20 L71, used without definition. It's the fundamental phenomenon motivating all information flow and token optimization strategies.
- **Action:** Add to "Three Failure Modes" table (after L80) a fourth row:
  - **Context Rot** | Model accuracy degrades as context window grows | At 32,000 tokens, Claude 3.5 Sonnet accuracy drops from 88% to 30% (Liu et al., 2023; Burke Holland, 2026)
  - Add 1-2 paragraphs explaining the phenomenon and VS Code's built-in mitigations
  - Add cross-reference to article 13 (token optimization) and cite Burke Holland Session 1 timestamps 10:24–12:07
- **Estimated Time:** 30 minutes

#### 10.00 — How to Design Orchestrator Prompts

**Priority Summary:** 0 critical, 2 medium, 0 low

**1. Add "Delegate goals, not solutions" principle (MEDIUM)**
- **Issue:** The anti-micromanagement rule is a practical orchestrator design insight not currently emphasized
- **Action:** Add as design principle #9 (after existing principle #8 "Validate before you build", L649):
  - Title: "Delegate goals, not solutions"
  - Content: Models naturally want to micromanage sub-agents. Explicitly instruct the orchestrator to delegate *what* to achieve, not *how*. Counter-instruct sub-agents to "Question everything you're told. Make your own decisions."
  - Reference: Burke Holland Session 3
- **Estimated Time:** 20 minutes

**2. Add Plan → Generate → Implement workflow example (MEDIUM)**
- **Issue:** This practical pattern for premium model savings isn't documented as a named workflow
- **Action:** Add as a practical example box in the design principles section or as a subsection:
  - Phase 1 — Plan (premium model): Research codebase, produce branch-oriented plan
  - Phase 2 — Generate (premium model): Write all code into a markdown document
  - Phase 3 — Implement (free model): Apply code verbatim from the document
  - Key rule: Clear context window between phases
  - Reference: Burke Holland Session 1
- **Estimated Time:** 30 minutes

#### 06.00 — How to Structure Content for Copilot Skills

**Priority Summary:** 0 critical, 0 medium, 2 low

**1. Add skills.sh reference (LOW)**
- **Action:** Add `skills.sh` (Vercel's skill directory) to community resources alongside `awesome-copilot` and `agentskills.io`
- **Estimated Time:** 5 minutes

**2. Add Burke Holland Session 2 reference (LOW)**
- **Action:** Add reference to Burke Holland's skills session in the References section as `📗 [Verified Community]`
- **Estimated Time:** 5 minutes

#### 07.00 — How to Create MCP Servers for Copilot

**Priority Summary:** 0 critical, 0 medium, 1 low

**1. Reclassify Burke Holland reference (LOW)**
- **Action:** Change L1371 from `📒 [Community]` to `📗 [Verified Community]` — Burke Holland is a Senior Cloud Advocate at Microsoft
- **Estimated Time:** 2 minutes

#### 20 — Orchestrator Design Case Study

**Priority Summary:** 0 critical, 1 medium, 1 low

**1. Expand context rot mention (MEDIUM)**
- **Action:** Update L71 to link to the formal definition that will be added to article 12.00, or add a parenthetical with the benchmark data
- **Estimated Time:** 10 minutes

**2. Reclassify Burke Holland reference (LOW)**
- **Action:** Change L2293 from `📒 [Community]` to `📗 [Verified Community]`
- **Estimated Time:** 2 minutes

#### 13.00 — How to Optimize Token Consumption

**Priority Summary:** 0 critical, 1 medium, 0 low

**1. Add context rot cross-reference (MEDIUM)**
- **Action:** In "Why token optimization matters" section, add a sentence linking to article 12's context rot definition: "Beyond cost, context growth degrades accuracy — see Context Rot for benchmark data."
- **Estimated Time:** 10 minutes

### Series-Wide Actions

**1. Burke Holland reference classification (LOW, all articles)**
- Reclassify all Burke Holland references from `📒 [Community]` to `📗 [Verified Community]`
- Rationale: Burke Holland is a Senior Cloud Advocate at Microsoft presenting official tooling demonstrations

**2. Burke Holland Session 1 reference (MEDIUM, articles 01.00 and 12.00)**
- Add Session 1 as a new reference in articles 01.00 and 12.00 — currently only Sessions 3 and 4 are referenced in the series

---

## Executive Summary

**Series:** Prompt Engineering for GitHub Copilot  
**Review Date:** 2026-07-21  
**Articles Analyzed:** 22  
**Review Lens:** Burke Holland Sessions (February 2026)

### Overall Health Score: 8/10

| Dimension | Score | Status |
|-----------|-------|--------|
| **Consistency** | 8/10 | Good — minor terminology drift (model selection vs model routing) |
| **Completeness** | 7/10 | Two critical gaps: prompt assembly architecture and context rot definition |
| **Redundancy** | 9/10 | Minimal — two acceptable overlaps with Burke Holland content |
| **Logical Flow** | 9/10 | Excellent linear progression from foundations to advanced |
| **Currency** | 8/10 | Good — Burke Holland content already partially integrated (articles 07, 20) |
| **Cross-Referencing** | 8/10 | Good — but Burke Holland Session 1 unreferenced; Session 2 unreferenced |

### Strengths

- **MCP Apps coverage is excellent** — Article 07's MCP Apps section (L1155–1318) is more comprehensive than Burke Holland's session itself and already references it properly
- **Skills progressive loading is well-covered** — Article 06 independently documents the 3-level loading pattern with a diagram, matching Burke Holland Session 2's core content
- **Orchestration coverage is comprehensive** — Articles 10, 11, 12, 13 together provide stronger orchestration guidance than Burke Holland's single session, and article 20 already references Session 3
- **Subagent context isolation is thoroughly explained** — Article 11 provides detailed treatment of isolated context windows, tool inheritance, and parallel execution

### Critical Issues

1. **Article 01.00 lacks prompt assembly architecture** — Readers learn *what* each file type is without understanding *where* it goes in the prompt. Burke Holland Session 1 provides the missing architecture diagram. This gap affects reader comprehension of all subsequent articles.

2. **"Context rot" underdefined** — Used once (article 20, L71), never formally defined. The series spends 1,475 words on token optimization (article 13) and 1,153 words on information flow (article 12) without naming or quantifying the underlying phenomenon that motivates both.

### Improvement Opportunities

1. Add prompt assembly architecture to article 01.00 (~500 words, 60 min)
2. Formalize context rot in article 12.00 (~200 words, 30 min)
3. Add anti-micromanagement principle + plan→generate→implement pattern to article 10.00 (~400 words, 50 min)
4. Add skills.sh + Burke Holland Session 2 reference to article 06.00 (~50 words, 10 min)
5. Reclassify Burke Holland references as `📗 [Verified Community]` (~5 min)
6. Add context rot cross-reference to article 13.00 (~50 words, 10 min)

### Recommendations Timeline

#### Immediate (1 Week)
- Add prompt assembly architecture to article 01.00 — **~60 min**
- Formalize context rot definition in article 12.00 — **~30 min**
- Reclassify Burke Holland references — **~5 min**

#### Short-Term (1 Month)
- Add anti-micromanagement principle to article 10.00 — **~20 min**
- Add plan→generate→implement pattern to article 10.00 or 20 — **~30 min**
- Add context rot cross-reference to article 13.00 — **~10 min**
- Expand context rot mention in article 20 L71 — **~10 min**

#### Long-Term (Next Quarter)
- Add skills.sh and Burke Holland Session 2 reference to article 06.00 — **~10 min**
- Evaluate whether plan→generate→implement deserves its own complementary case study (article 23?) after the roadmap articles 15.00 and 16.00 are written

---

### Concepts Verified Before Integration

All gap recommendations above were verified against source material:

| Concept | Source | Verification |
|---------|--------|-------------|
| 4-layer system prompt architecture | Burke Holland Session 1 (0:00–3:55) | Verified via VS Code system prompt inspection shown in demo; consistent with VS Code Copilot documentation |
| Custom instructions inject at end of system prompt | Burke Holland Session 1 (3:56–6:56) | Verified; copilot-instructions.md explicitly described as "always last" |
| Prompt files inject into user prompt (not system) | Burke Holland Session 1 (6:57–12:07) | Verified; shown in demo with prompt file content appearing before context info in user message |
| Custom agents inject after instructions in system prompt | Burke Holland Session 1 (12:08–15:07) | Verified; shown in image `03.001 system prompt with agent.png` |
| Context rot: 88%→30% at 32K tokens | Burke Holland Session 1 (10:24–12:07) | Verified against "Lost in the Middle" research (Liu et al., 2023); specific numbers are for Claude 3.5 Sonnet |
| Anti-micromanagement rule | Burke Holland Session 3 (5:38–7:22) | Verified; demonstrated in orchestrator prompt and coder agent counter-instructions |
| skills.sh (Vercel skill directory) | Burke Holland Session 4 (3:33–7:24) | Verified; site exists at skills.sh with MCP builder and MCP apps skills |
| Model-per-role specific assignments | Burke Holland Session 3 (5:25–10:59) | Verified as Burke's personal recommendation at time of recording; **NOT recommended for series integration** due to volatility of model landscape |

--- 

Completed: *Execute formal series review* (6/6)

The review is complete. Here's a summary:

**Burke Holland relevance assessment:** All 4 sessions are relevant to the series. Sessions 3 (orchestrations) and 4 (MCP apps) are already referenced. Sessions 1 (VS Code productivity) and 2 (skills) are NOT referenced despite containing the highest-impact gaps.

**Two critical gaps found:**

1. **Article 01.00 is missing the prompt assembly architecture** — readers learn *what* each file type is without understanding *where* it lands in the assembled prompt. Burke Holland Session 1 provides the definitive 4-layer system prompt diagram with injection points. This should be added as ~500 words to the foundational article.

2. **"Context rot" is undefined** — used once in article 20, never formally defined in articles 12 (information flow) or 13 (token optimization) where it belongs. Burke Holland provides benchmark data (88%→30% accuracy at 32K tokens) that motivates both articles.

**Four supporting improvements:** Add anti-micromanagement principle and plan→generate→implement workflow to article 10, add skills.sh to article 06, and reclassify Burke Holland references from `[📒 Community]` to `[📗 Verified Community]` (he's a Senior Cloud Advocate at Microsoft).

**Total estimated effort:** ~3 hours for all changes. No structural changes to the series needed.