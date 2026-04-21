
## Cross-Comparison: The Three Context-File Prompts

### Feature Matrix

| Feature / Section | CREATE-UPDATE | DESIGN | REVIEW |
|---|---|---|---|
| **Architecture** | Standalone expert (does work itself) | Orchestrator (delegates to specialists) | Orchestrator (delegates to specialists) |
| **Agent mode** | `agent: agent` | `agent: agent` | `agent: plan` |
| **Tool count** | 9 tools (read+write+fetch) | 4 tools (read+create) | 4 tools (read-only) |
| **Handoffs** | 2 (researcher, validator) | 8 (3 context + 4 cross-type validators + builder update) | 6 (validator, builder, 4 cross-type validators) |

---

### A. What's in CREATE-UPDATE but NOT in DESIGN or REVIEW

These are capabilities unique to the standalone prompt that the orchestrators don't replicate (intentionally or not):

| # | Feature | In CREATE-UPDATE | DESIGN | REVIEW | Analysis |
|---|---|---|---|---|---|
| **A1** | **Source Discovery Pipeline** (Phases 1.2–1.5) | ✅ Full 4-step priority-ordered pipeline: User Input → Execution Context → STRUCTURE-README.md → Semantic Search → Additional Discovery | ❌ Delegates to researcher with list of what to check, but no priority ordering or classification | ❌ N/A (review, not creation) | **Gap in DESIGN.** The researcher agent knows to check STRUCTURE-README.md, but DESIGN doesn't pass the priority-ordering logic (which source wins when they conflict). The researcher agent file may handle this internally, but without explicit guidance, it's dependent on agent quality. |
| **A2** | **Source Prioritization & Classification** (Phase 1.5) | ✅ Full framework: 5 criteria (Relevance, Authority, Recency, Impact, Efficiency), 4 categories (Primary/Secondary/Tertiary/Exclude), gap analysis | ❌ Not present — researcher does unstructured research | ❌ N/A | **Gap in DESIGN.** When multiple sources conflict or overlap, CREATE-UPDATE has a formal decision framework. DESIGN relies on researcher judgment without explicit criteria. This matters for complex topics with many sources. |
| **A3** | **Structured Phase Output Formats** | ✅ Every phase has a formatted output template (e.g., "📋 Phase 1: Context Collection Complete" with specific fields) | ❌ Gates have checklists but no structured output format between phases | ❌ Has report template only at end | **Gap in DESIGN.** CREATE-UPDATE's per-phase output templates make it explicit what information passes forward. DESIGN has context rot prevention rules saying "pass structured summary" but doesn't define the format. |
| **A4** | **Token Budget by Content Type** | ✅ Detailed table: Core Principles 800–1,200, Pattern Libraries 1,500–2,500, Workflow Documentation 1,000–2,000, Glossary 500–1,000 | ❌ Only mentions the 2,500 overall cap | ❌ Mentions 2,500 cap only | **Minor gap.** The type-specific budgets help right-size files. DESIGN's researcher could propose a tighter budget, but there's no guidance to do so. |
| **A5** | **Context File Structure Template** (Phase 3) | ✅ Full markdown template with Purpose, Referenced by, Core sections, Anti-patterns, Checklist, References, Version History | ❌ Lists required sections in Phase 3 but no inline template | ❌ Checks for section existence but doesn't define structure | **Acceptable.** DESIGN delegates structure to builder, who has the template from context-files.instructions.md. Not a gap — it's appropriate delegation. |
| **A6** | **Content Principles checklist** | ✅ Explicit list: imperative language, repo-specific examples, reference not duplicate, numbered prefixes | ❌ Mentioned in validation criteria only | ❌ Checks these in validation | **Minor gap.** These are covered by the instruction file (context-files.instructions.md) which the builder auto-loads, so functionally present but not explicit in DESIGN's handoff. |
| **A7** | **`fetch_webpage` tool** | ✅ Available — can fetch external URLs directly | ❌ Not in tool list (relies on researcher) | ❌ Not in tool list | **Intentional.** DESIGN delegates URL fetching to the researcher agent, which has `fetch_webpage` in CREATE-UPDATE's handoff. However, checking the [context-researcher agent](.context-researcher.agent.md), it only has read-only tools and no `fetch_webpage`. **This is an actual gap** — if user provides a URL, neither the DESIGN orchestrator nor the researcher can fetch it. |
| **A8** | **`list_dir` tool** | ✅ Available | ❌ Not in tool list | ❌ Not in tool list | **Minor.** DESIGN relies on researcher which has `list_dir`. Acceptable delegation. |
| **A9** | **`grep_search`, `replace_string_in_file`, `multi_replace_string_in_file` tools** | ✅ Available (full read+write+search) | ❌ Limited to read+create | ❌ Has `grep_search` (read-only) | **Intentional.** DESIGN delegates write operations to builder agent. Correct orchestrator pattern — orchestrator shouldn't have write tools beyond `create_file`. |
| **A10** | **Self-validation checklist** (Phase 4) | ✅ 9-item checklist the prompt runs itself | ❌ Delegates all validation to context-validator | ❌ Delegates all validation | **Intentional.** The CREATE-UPDATE model validates inline because it's a standalone expert. DESIGN correctly delegates. |
| **A11** | **Out of Scope section** | ✅ Explicit redirect table for wrong artifact types | ❌ Not present | ❌ Not present | **Gap in both DESIGN and REVIEW.** When someone asks DESIGN to create a prompt file or REVIEW to review a prompt file, there's no structured redirect. The boundaries say "never" but don't say where to redirect. |

---

### B. What's in DESIGN but NOT in CREATE-UPDATE or REVIEW

| # | Feature | In DESIGN | CREATE-UPDATE | REVIEW | Analysis |
|---|---|---|---|---|---|
| **B1** | **Formal Quality Gates with Checklists** | ✅ 5 gates with concrete checklist items per phase | ❌ Phases flow sequentially with no explicit gates | ❌ Gates exist but are vague (no concrete criteria) | **Gap in CREATE-UPDATE and REVIEW.** CREATE-UPDATE has no gate enforcement — it's sequential. For its standalone model this is acceptable, but it means no quality checkpoint between phases. REVIEW has vague gates per the 01. change.md analysis. |
| **B2** | **Goal Alignment Checks** | ✅ Every gate includes `**Goal alignment:** Output serves the original requirement` | ❌ Not present | ❌ Not present | **Gap in both.** CREATE-UPDATE can drift across its 5 phases without checking. REVIEW can expand scope (e.g., scoped review → full audit). |
| **B3** | **Clarification Protocol** | ✅ Structured protocol with gap categorization (Critical/High/Medium/Low), iteration limits, anti-patterns | ❌ Simple "ask clarifying questions before proceeding" | ❌ Not present | **Gap in CREATE-UPDATE.** It says "ask clarifying questions" but doesn't structure the approach. For exploratory scenarios this matters less (CREATE-UPDATE assumes clear requirements), but ambiguous topics can still arrive. |
| **B4** | **Complexity Assessment** | ✅ 3-tier classification (Simple/Moderate/Complex) affecting research depth | ❌ Not present — all topics treated equally | ❌ Not present | **Gap in CREATE-UPDATE.** A simple glossary update and a complex new domain creation both follow the same 5-phase pipeline. Not critical for a standalone prompt, but it means extra work for simple cases. |
| **B5** | **Consumer Impact Analysis** | ✅ Phase 2 explicitly maps which prompts/agents/instructions depend on the file | ❌ "Referenced By" is collected but not as formal analysis | ❌ Listed in goals but not in phase-level process | **Partial gap.** CREATE-UPDATE collects "Referenced By" as user input but doesn't actively discover consumers. DESIGN's researcher does active consumer discovery. REVIEW mentions consumer impact in goals but Phase 2 (validation delegation) doesn't explicitly include it in the handoff. |
| **B6** | **Information Architecture Assessment** | ✅ Researcher checks granularity, domain folder correctness, file naming | ❌ Not present — user specifies folder, prompt follows | ❌ Not present | **Gap in CREATE-UPDATE.** If user picks the wrong domain folder or wrong granularity, CREATE-UPDATE won't catch it. DESIGN's researcher would. |
| **B7** | **Context Rot Prevention (progressive summarization)** | ✅ Full table of what to pass forward vs discard per phase | ❌ Not present | ❌ Not present | **Gap in both.** CREATE-UPDATE has a 5-phase workflow that can accumulate context. REVIEW has 6 phases. Neither implements progressive summarization. For CREATE-UPDATE this is less critical (standalone expert, shorter interactions), but REVIEW's layer audit mode can process many files. |
| **B8** | **Iteration Limits (from 02.03)** | ✅ Explicit: Research→Plan max 2, Build→Validate max 3, Overall max 5 | ❌ No iteration limits defined | ❌ "Maximum 3 fix-validate cycles per file" mentioned in Phase 5 but no other limits | **Gap in CREATE-UPDATE.** Self-validation in Phase 4 can fail indefinitely — no limit on how many times it loops back to Phase 3. |
| **B9** | **Cross-Type Validation** | ✅ Handoffs to instruction-validator, prompt-validator, agent-validator, skill-validator | ❌ Only context-validator | ❌ Has cross-type handoffs (all 4) | **Gap in CREATE-UPDATE.** When a context file change might break a dependent prompt or agent, CREATE-UPDATE can validate it via context-validator but can't check the actual consumers. REVIEW can. |
| **B10** | **Cumulative Progress Tracking** | ✅ Progress template after Phase 4 with drift status | ❌ Not present | ❌ Not present | **Gap in REVIEW** (matters most for layer audit mode reviewing many files). |

---

### C. What's in REVIEW but NOT in CREATE-UPDATE or DESIGN

| # | Feature | In REVIEW | CREATE-UPDATE | DESIGN | Analysis |
|---|---|---|---|---|---|
| **C1** | **Dual validation modes** (scoped vs layer audit) | ✅ Two modes with different behaviors | ❌ N/A (always single file) | ❌ Always creates single file + validates | **Unique to REVIEW.** Appropriate — only review needs batch processing. |
| **C2** | **Dependency map loading** | ✅ Loads 05.01-artifact-dependency-map.md for consumer relationships | ❌ Not present | ❌ Not present (researcher does it) | **Gap in CREATE-UPDATE.** Knowing the dependency map before creation would help validate "Referenced By" accuracy. |
| **C3** | **Cross-type validation handoffs** (all 4 validator types) | ✅ Can validate dependent prompts, agents, instructions, skills | ❌ Only context-validator | ✅ Has all 4 | **Gap in CREATE-UPDATE** — if a context file update breaks a dependent prompt, CREATE-UPDATE can't detect it. |
| **C4** | **Contradiction detection** | ✅ Explicitly checks for contradictions between context files AND instruction files | ❌ Only checks for duplication, not contradiction | ❌ Researcher presumably checks, but not explicit in handoff | **Gap in CREATE-UPDATE and partially in DESIGN.** Duplication ≠ contradiction. Two files can say opposite things without duplicating text. |

---

### D. What's MISSING from ALL THREE (Production-Readiness Gaps)

| # | Requirement | CREATE-UPDATE | DESIGN | REVIEW | Source |
|---|---|---|---|---|---|
| **D1** | **YAML Frontmatter validation** | ❌ Context file structure template doesn't include YAML frontmatter (`title`, `description`, `version`, `last_updated`) | ❌ Section outline doesn't mention YAML frontmatter | ❌ Validator likely checks but not explicit | context-files.instructions.md requires YAML frontmatter for every context file |
| **D2** | **Template externalization** | Phase output templates are inline (>10 lines each) | ❌ Not applicable (delegates content creation) | ❌ Report template is inline but small | `04.03` Requirement 6: inline blocks >10 lines MUST be externalized to templates |

---

### E. Gaps Confirmed in REVIEW (from 01. change.md analysis)

The attached change document analyzed instruction-file-design and instruction-file-review. The same gaps apply to context-file-review since it follows the identical pattern:

| # | Gap | Status in context-file-review |
|---|---|---|
| **E1** | No Embedded Test Scenarios | ❌ Missing — 0 test scenarios |
| **E2** | No Error Recovery Workflows | ❌ Missing — no recovery for when validator/builder fail |
| **E3** | No Response Management Templates | ❌ Missing — no structured responses for edge cases |
| **E4** | Vague Gate Check Criteria | ⚠️ Phases exist but gates are implicit, not concrete checklists |
| **E5** | No Goal Alignment Checks | ❌ Missing |
| **E6** | No Context Rot Prevention | ❌ Missing — layer audit can process 25+ files |
| **E7** | No Cumulative Progress Tracking | ❌ Missing — critical for layer audit mode |

---

### Priority Recommendations

**CRITICAL (production-readiness blockers):**

| File | Gap | Fix |
|---|---|---|
| **REVIEW** | E1: Zero test scenarios | Add 5 scenarios: happy path, layer audit conflict, token budget, fix-loop limit, layer boundary violation |
| **REVIEW** | E2: No error recovery | Add recovery for: validator empty, builder creates new issues, file not found |
| **REVIEW** | E3: No response management | Add templates for: no issues found, file not found, intentional overlap, cross-type failure |
| **DESIGN** | A7: `fetch_webpage` gap | Either add `fetch_webpage` to context-researcher agent OR add it to DESIGN orchestrator tools OR document the limitation |

**HIGH:**

| File | Gap | Fix |
|---|---|---|
| **REVIEW** | E4-E5: Vague gates, no goal alignment | Add concrete gate checklists + goal alignment to each phase |
| **CREATE-UPDATE** | A11: No Out of Scope redirects in DESIGN/REVIEW | Add `## 🚫 Out of Scope` section with redirect table to both |
| **CREATE-UPDATE** | B2: No goal alignment | Add goal alignment check between Phases 2→3 and 4→5 |
| **ALL THREE** | D1: YAML frontmatter not in creation template | Add YAML frontmatter to CREATE-UPDATE's Phase 3 template and DESIGN's Phase 3 section outline |

**MEDIUM:**

| File | Gap | Fix |
|---|---|---|
| **REVIEW** | E6-E7: No context rot prevention or progress tracking | Add progressive summarization + layer audit progress template |
| **CREATE-UPDATE** | A2: No source prioritization in DESIGN | Add prioritization criteria to DESIGN's Phase 2 researcher handoff |
| **CREATE-UPDATE** | B8: No iteration limits | Add "max 3 loops between Phase 3↔4" |
| **CREATE-UPDATE** | C4: No contradiction detection | Add contradiction check to Phase 4 validation checklist | 

Completed: *Present findings* (4/4)

Want me to implement any of these fixes? The most impactful ones would be:
1. **REVIEW** — add production-readiness sections (test scenarios, error recovery, response management, concrete gates)
2. **DESIGN** — resolve the `fetch_webpage` gap (context-researcher agent has no fetch capability)
3. **ALL THREE** — add YAML frontmatter to the creation template/section outlines