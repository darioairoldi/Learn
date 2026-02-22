Summarized conversation history

  

Created 7 todos

Searched for files matching `**/03.00-tech/05.02-prompt-engineering/*10.00*`, 1 match

Searched for files matching `**/03.00-tech/05.02-prompt-engineering/20*`, 1 match

Searched for files matching `**/03.00-tech/05.02-prompt-engineering/09*`, 1 match

Searched for files matching `**/.github/prompts/article-review*`, no matches

Searched for files matching `**/.github/prompts/*.prompt.md`, 11 matches

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/.github/prompts/series-validation.prompt.md#1-1), lines 1 to 100

Starting: *Read article 10.00 (info flow)* (2/7)

Now let me read both articles in full, plus article 09.00 (user-edited) for context:   

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/10.00-how_to_manage_information_flow_during_prompt_orchestrations.md#1-1), lines 1 to 150

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#1-1), lines 1 to 150

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/09.00-how_to_use_agent_hooks_for_lifecycle_automation.md#1-1), lines 1 to 100

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/10.00-how_to_manage_information_flow_during_prompt_orchestrations.md#150-150), lines 150 to 400

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#150-150), lines 150 to 500

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/10.00-how_to_manage_information_flow_during_prompt_orchestrations.md#400-400), lines 400 to 700

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#500-500), lines 500 to 900

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/10.00-how_to_manage_information_flow_during_prompt_orchestrations.md#700-700), lines 700 to 1000

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#900-900), lines 900 to 1400

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/10.00-how_to_manage_information_flow_during_prompt_orchestrations.md#1000-1000), lines 1000 to 1153

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#1400-1400), lines 1400 to 1900

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#1900-1900), lines 1900 to 2400

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/20-how_to_create_a_prompt_interacting_with_agents.md#2400-2400), lines 2400 to 2777

Starting: *Fetch VS Code subagents docs* (5/7)

Now let me fetch the current VS Code subagents documentation to understand the official API: 



Fetched https://code.visualstudio.com/docs/copilot/chat/subagents



Fetched 2 resources

Starting: *Analyze overlap and propose coverage* (6/7)

Let me also quickly check the current ROADMAP to ensure my recommendations align with the current article numbering: 

Read [](file:///e%3A/dev.darioa.live/darioairoldi/Learn/03.00-tech/05.02-prompt-engineering/ROADMAP.md)

Starting: *Present recommendations* (7/7)

Here's my series validation analysis for the overlap between articles 10.00 and 20, and my recommendations for restructuring coverage to cleanly accommodate the subagents article.

---

## Series overlap analysis

### Article profiles

| Article | Word count | Primary focus | Written |
|---------|-----------|---------------|---------|
| **10.00** — Information flow | ~4,200 | Context window mechanics, communication pathways, handoff strategies, token efficiency patterns | Jan 2026 |
| **20** — Orchestrating agents | ~10,500 | Orchestrator design, specialized agent pattern, phase-based coordination, implementation case study | Dec 2025 |

### Overlapping content (significant)

I identified **seven content areas** that appear in both articles with substantial overlap:

| Topic | Art. 10.00 location | Art. 20 location | Overlap severity |
|-------|---------------------|-------------------|------------------|
| **Handoff `send: true` vs `send: false`** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **Critical** — identical tables, identical diagrams |
| **Progressive summarization pattern** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **Critical** — same strategy, same token math |
| **File-based isolation pattern** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **Critical** — identical `.copilot/temp/` convention |
| **User-mediated handoff pattern** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **High** — same concept, similar examples |
| **Structured report passing** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **High** — same report templates |
| **Token budget estimates** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **Moderate** — overlapping tables |
| **Reliability checksum pattern** | 10.00-how_to_manage_information_flow_during_prompt_orchestrations.md | 20-how_to_create_a_prompt_interacting_with_agents.md | **Moderate** — identical checklist |

### What each article does well (unique value)

**Article 10.00 — Information flow** (unique strengths):
- Context window as communication bus architecture diagram
- Component roles taxonomy (customization files vs. tool sources)
- Direction/persistence classification (User → Model, System → Model, Model ↔ Tool)
- Communication pathways reference (Prompt → Agent, Instructions, MCP, Snippets)
- Pitfalls and solutions catalogue

**Article 20 — Orchestrating agents** (unique strengths):
- Specialized agent pattern (researcher/builder/validator/updater)
- Use Case Challenge methodology
- Phase-based orchestrator design with flow diagrams
- Architecture analysis and decision framework (single prompt vs. orchestrator+agents)
- Tool Composition Validation
- Execution contexts (Local/Background/Cloud) and Agent HQ
- Complete implementation case study
- Full "Common Mistakes" catalogue (9 mistakes)

### What's missing (the subagents gap)

**Neither article covers:**
- `runSubagent` tool and the `agent` tool alias
- `user-invokable` / `disable-model-invocation` frontmatter
- `agents` array for restricting subagents
- Context isolation mechanics (subagents get clean context, don't inherit conversation)
- Parallel subagent execution
- Coordinator/worker pattern with formal subagent API
- Multi-perspective review pattern
- How subagents differ from handoffs (subagent returns result to same session; handoff creates new session)

**Article 20 has a brief "Subagents (Experimental)" section** (~15 lines at 20-how_to_create_a_prompt_interacting_with_agents.md) that mentions `runSubagent` and `infer: true` but is outdated (`infer` is now deprecated) and far too shallow.

---

## Recommended restructuring

### The core problem

Articles 10.00 and 20 were written independently and both tried to be the "orchestration article." This created two problems:
1. **Redundancy**: Five handoff patterns appear in both articles nearly verbatim
2. **Scope confusion**: Article 10.00 is titled "information flow" but half its content is handoff implementation patterns that belong in an orchestration article; Article 20 has a massive "Information Exchange Protocols" section that duplicates 10.00

### Proposed article scope separation

I recommend a **three-article split** that eliminates overlaps and creates a clean home for subagents:

| Article | Title | Scope | Focus |
|---------|-------|-------|-------|
| **10.00** (refocused) | How to manage information flow during prompt orchestrations | **Theory + architecture** — How data moves through the customization stack | Context window model, component roles, communication pathways, direction/persistence taxonomy, pitfalls catalogue |
| **13.00** (new) | How to design subagent orchestrations | **Subagent API + orchestration patterns** — The modern way to build multi-agent workflows | `runSubagent` tool, `user-invokable`/`disable-model-invocation`, `agents` array, coordinator/worker, multi-perspective review, context isolation, parallel execution |
| **20** (refocused) | How to create a prompt orchestrating multiple agents | **Case study + advanced workflow design** — End-to-end orchestrator design with specialized agents | Specialized agent pattern, Use Case Challenge, architecture analysis, execution contexts, implementation case study, common mistakes |

### What moves where

#### From article 20 → article 10.00 (information flow owns this)
- Nothing needs to move *into* 10.00. Article 10.00 already covers the theory comprehensively.

#### From article 20: remove duplicated content, cross-reference 10.00
Replace the entire `📡 Information Exchange Protocols` section (~430 lines, lines 870–1335) with a concise cross-reference to article 10.00. The section currently duplicates:
- Context Carryover Strategies → already in 10.00 as Pattern 1/2
- Token-Efficient Communication Patterns → already in 10.00 as strategy comparison + patterns 1–5
- Agent Input Expectations → keep a summary in 20, reference 10.00 for details
- Reliability Checksum Pattern → already in 10.00

#### From article 10.00: remove implementation-heavy patterns, cross-reference 20/13
The five implementation patterns (lines 650–840: Full Context, Progressive Summarization, File-Based Isolation, User-Mediated, Structured Report) overlap with 20's patterns. **Keep them in 10.00** as that's their natural home for the "information flow strategies" topic, but add a cross-reference note saying 20 shows them applied in a real orchestrator context.

#### From article 20: extract subagents content → new article 13.00
- Remove the shallow "Subagents (Experimental)" subsection (~15 lines)
- The new article 13.00 becomes the definitive subagents reference

#### Article 20: update outdated orchestration patterns
- Update the `infer: true` references to `user-invokable: false`
- Add cross-reference to 13.00 for subagent-based orchestration
- Keep the "handoffs" orchestration model as the "classic" approach, clearly differentiating it from subagents

### Proposed content outlines

#### Article 10.00 (refocused) — "How to manage information flow"

**Keep as-is** (already well-structured):
1. Why information flow matters (context problem, failure modes)
2. Information flow architecture (context window bus, component roles, direction/persistence)
3. Communication pathways (Prompt→Agent, Agent→Agent handoffs, Instructions, Tools, MCP, Snippets)
4. Communication strategies comparison (matrix, token analysis, robustness)
5. Implementation patterns (five patterns — these are the canonical source)
6. Common pitfalls
7. Best practices

**Add**:
- Brief "Subagent context isolation" section noting that subagents use clean context windows (cross-reference 13.00 for details)
- Update conclusion to reference the three related orchestration articles (13.00 and 20)

#### Article 13.00 (new) — "How to design subagent orchestrations"

1. **Understanding subagents** — What they are, how they differ from handoffs/sessions
2. **Subagent execution mechanics** — Clean context, synchronous blocking, result return
3. **Controlling invocation** — `user-invokable`, `disable-model-invocation`, `agents` array
4. **Orchestration patterns** — Coordinator/worker, multi-perspective review
5. **Information flow in subagent orchestrations** — Context isolation advantages, what flows vs. what doesn't, token implications (cross-reference 10.00)
6. **Subagents vs. handoffs** — Decision framework for choosing the right mechanism
7. **Advanced patterns** — Parallel execution, combining subagents with hooks (cross-ref 09.00)
8. **Common pitfalls**
9. **Conclusion**

#### Article 20 (refocused) — "How to create a prompt orchestrating multiple agents"

**Keep**:
1. The Problem (monolithic prompt → specialized agents)
2. Architecture Overview (execution contexts, Agent HQ, deployment options, sharing)
3. Specialized Agent Pattern (four-role pattern)
4. Use Case Challenge methodology  
5. Orchestrator Design (phase-based coordination)
6. Structure Definition & Architecture Analysis
7. Handling Agent Creation
8. Complete Workflow examples
9. Execution Flow Control Patterns
10. Key Design Decisions
11. Context Engineering for Orchestrators
12. Implementation Example
13. Real Case Study
14. Common Mistakes

**Remove** (cross-reference 10.00 and 13.00 instead):
- `📡 Information Exchange Protocols` section → replaced with a summary paragraph cross-referencing 10.00
- `Subagents (Experimental)` subsection → replaced with cross-reference to 13.00

**Update**:
- `infer: true/false` → `user-invokable` / `disable-model-invocation`
- Add note in Architecture Overview distinguishing "handoff-based orchestration" (this article) from "subagent-based orchestration" (article 13.00)

### Cross-reference map after restructuring

```
Article 10.00 (Information Flow)
  ├── References → 13.00 (subagent context isolation)
  ├── References → 20 (patterns applied in real orchestrator)
  └── References → 04.00 (agent file structure)

Article 13.00 (Subagents) — NEW
  ├── References → 10.00 (information flow theory, token strategies)
  ├── References → 20 (handoff-based orchestration comparison)
  ├── References → 04.00 (agent file YAML properties)
  ├── References → 09.00 (hooks integration with SubagentStart/Stop)
  └── References → 11.00 (token optimization)

Article 20 (Orchestrator Design)
  ├── References → 10.00 (information flow strategies)
  ├── References → 13.00 (subagent-based orchestration)
  ├── References → 04.00 (agent file structure)
  └── References → 21.1 (implementation plan)
```

### Reading order: learning progression

```
Beginner path:     01 → 02 → 03 → 04 → 05 → 06 → 07

Advanced path:     08 → 09 (hooks) → 10 (info flow) → 11 (tokens) → 12 (SDK)

Orchestration:     13 (subagents) → 20 (full orchestrator design) → 21.1 (case study)
```

The progression makes sense: readers learn **information flow theory** (10), then **subagent mechanics** (13, the modern lightweight approach), then **full orchestrator design** (20, the advanced case-study-driven article with handoffs, Use Case Challenge, etc.).

---

## Recommended actions (prioritized)

| Priority | Action | Effort |
|----------|--------|--------|
| 1 | **Write article 13.00** — Subagent orchestrations (the new content that doesn't exist yet) | High |
| 2 | **Trim article 20** — Remove `📡 Information Exchange Protocols` section, replace with cross-reference to 10.00. Update deprecated `infer` references. | Medium |
| 3 | **Update article 10.00** — Add brief subagent context isolation note, update cross-references | Low |
| 4 | **Update ROADMAP** — Reflect the refocused scopes | Low |

### What NOT to do

- **Don't renumber articles** — The current numbering works. 10=info flow, 13=subagents, 20=orchestrator design.
- **Don't merge 10.00 and 20** — They serve genuinely different purposes (theory vs. practice).
- **Don't remove patterns from 10.00** — They belong there as the canonical source; 20 should cross-reference, not duplicate.

---

Want me to proceed with writing article 13.00 (subagents), or would you prefer to start with trimming article 20's duplicated sections first? 

Completed: *Present recommendations* (7/7)