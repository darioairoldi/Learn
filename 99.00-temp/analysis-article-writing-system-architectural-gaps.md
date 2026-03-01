# Analysis: Article Writing System Architectural Gaps

**Date:** 2026-03-01  
**Context:** The series review prompt was run on the `05.02-prompt-engineering` series and failed to detect structural problems that required a manual 7-phase restructuring. This analysis identifies why, maps what prior Recommendations A-F fixed vs. what they missed, and proposes concrete changes.

---

## 🎯 The failure case

The `05.02-prompt-engineering` series had these architectural problems BEFORE the 7-phase restructuring:

| Problem | What happened | Which rule was violated |
|---------|--------------|----------------------|
| **Mixed Diátaxis types** | Article 01.00 combined tutorial + how-to + reference + explanation in a single 1,200+ line file | Art. 02: "Two distinct purposes → Split into explanation + how-to" |
| **Wrong folder placement** | Concept articles sat in how-to folders, references in tutorial folders | Art. 02: LATCH category mapping to folder structure |
| **Missing concept category** | No explanatory/concept folder existed despite the series needing foundational content | Art. 02: "Diátaxis mapping" requires all 4 types where appropriate |
| **Article scope violations** | Monolithic articles exceeded 1,000 lines without justification | Art. 02: length benchmarks (400–800 sweet spot, 800–1,000 review) and splitting criteria |
| **No cross-category progression** | Articles didn't form a coherent learning path across Diátaxis categories | Art. 02: "Audience-segmented reading paths" |

The series review prompt ran all 6 phases and **caught none of these**. It reported terminology variations, found formatting inconsistencies, and suggested new topic extensions — all valid within-article findings. But the series' fundamental architecture was broken, and the prompt was blind to it.

---

## 📊 Root cause analysis

### What the series review prompt actually checks

| Phase | What it validates | Validation type |
|-------|------------------|-----------------|
| Phase 1: Discovery | Finds articles, extracts goals | Inventory |
| Phase 2: Content Mapping | Terminology index, concept coverage, cross-reference health | **Content-level** |
| Phase 3: Consistency | Terminology variations, structural inconsistencies, contradictions | **Formatting-level** |
| Phase 4: Redundancy/Gaps | Duplicate content, missing topics | **Topic-level** |
| Phase 5: Extensions | Adjacent topics, emerging trends, alternatives | **Topic-level** |
| Phase 6: Recommendations | Per-article action items, health scores | **Aggregation** |

### What it DOESN'T check (the blind spots)

| Missing check | Source rule | Why it matters |
|--------------|-----------|---------------|
| **Diátaxis type compliance per article** | Art. 02: Diátaxis patterns + splitting criteria | Can't catch mixed-type articles or type misassignment |
| **Folder structure validation** | Art. 02: LATCH + category mapping | Can't catch misplaced articles or unused folders |
| **Article scope/size analysis** | Art. 02: length benchmarks, splitting/merging criteria | Can't catch monolithic articles that need decomposition |
| **Diátaxis category coverage** | Art. 02: series scoping + "all 4 types where appropriate" | Can't catch missing categories (e.g., no concept articles exist) |
| **Cross-category learning paths** | Art. 02: audience-segmented reading paths | Can't verify the series forms a coherent progression |
| **Content density by type** | Art. 02: density target table | Can't detect reference-level depth in a tutorial or theory in a how-to |

**Core insight:** The prompt validates **content formatting consistency**, not **content architecture**. It answers "are the articles internally consistent?" but not "are these the right articles, in the right structure, with the right scope?"

---

## 📋 Prior Recommendations A-F: what they fixed vs. what they missed

The coverage analysis in [series-review-structure-and-organization.md](series-review-structure-and-organization.md) proposed Recommendations A-F. Here's their status and residual gaps:

| Rec | What it fixed | Status | What it DIDN'T fix |
|-----|--------------|--------|-------------------|
| **A: Split instructions** | Reduced auto-load from ~880 to ~400 lines; created Tier 2 (`03-article-creation-rules.md`) | ✅ Done | Tier 2 is referenced but not operationalized in the series review prompt |
| **B: Fill 8 coverage gaps (G1-G5)** | Added content-first design, topic-based authoring, progressive disclosure, LATCH, Wikipedia pattern to `03-article-creation-rules.md` | ✅ Done | These rules exist in context files but the series review prompt has NO phases that apply them |
| **C: Eliminate duplications** | Reduced some redundancy between style guide and instructions | Partial | Not the core problem |
| **D: Rule-Dimension Mapping** | Added mapping table to series review prompt | ✅ Done | Table maps per-article dimensions only; no series-level architectural dimensions |
| **E: Phase 5.5 validation gate** | Added pre-writing gate to creation prompt | ✅ Done | Fixes creation-time only; doesn't help during series REVIEW |
| **F: Strengthen series workflow** | Added terminology handoff, cross-reference strategy, content-first design step | ✅ Done | Fixes planning-time only; no enforcement during review |

**Pattern:** All implemented recommendations improved **creation-time** and **per-article** validation. None added **series-level architectural validation** to the review process. The prompt engineering series was created BEFORE these improvements AND reviewed AFTER them — but the review prompt still couldn't catch the architectural problems because those checks don't exist.

---

## 🏗️ The gap: no architectural validation layer

The system has three validation opportunities:

```
Planning time          Creation time           Review time
(03-series-planning)   (article-design-create)  (series-review prompt)
        │                       │                        │
 ✅ Has content-first    ✅ Has Phase 5.5          ❌ NO architectural
    design step              validation gate          validation phases
 ✅ Has terminology      ✅ Checks Diátaxis type   ❌ NO Diátaxis compliance
    handoff rule             for single article        check across series
 ❌ NO Diátaxis          ❌ NO series awareness     ❌ NO folder validation
    category planning        during creation          ❌ NO scope/size analysis
 ❌ NO folder            ❌ NO folder placement     ❌ NO category coverage
    structure planning       check                    ❌ NO learning path check
```

The architectural validation gap is systemic — it doesn't exist at ANY of the three validation points. But the highest-impact place to add it is the **series review prompt**, because that's the checkpoint where the entire series is analyzed holistically.

---

## 🔧 Proposed changes

### Change 1: Add "Content Architecture" phase to the series review prompt

**File:** `article-review-series-for-consistency-gaps-and-extensions.prompt.md`  
**Impact:** HIGH — this is the core fix  
**Effort:** Medium  

Add a new **Phase 2.5: Content Architecture Validation** between Phase 2 (Content Mapping) and Phase 3 (Consistency Analysis). This phase runs 5 architectural checks:

**a) Diátaxis compliance per article**
- For each article: identify its actual Diátaxis type based on content analysis (not just metadata)
- Flag articles mixing >1 Diátaxis type (splitting candidates)
- Flag articles whose content doesn't match their stated type
- Flag articles in wrong Diátaxis-aligned folders

**b) Folder structure analysis**
- Map every article to its folder; check folder-Diátaxis alignment
- Report empty/overcrowded folders
- Identify misplaced articles (how-to content in concept folder, etc.)

**c) Article scope/size analysis**
- Check line counts against Art. 02's benchmarks (under 400 too thin, 400–800 sweet spot, 800–1,000 review, over 1,000 split)
- Apply splitting criteria: multiple audiences, multiple purposes, excessive length, subsections with independent value, different update cadences
- Apply merging criteria: combined <500 lines, identical audience/purpose, purely setup content

**d) Category coverage matrix**
- Build a Diátaxis type × article matrix showing distribution
- Flag missing types the series should have based on its goals
- Flag over-concentration (e.g., 90% how-to, 0% explanation)

**e) Learning path analysis**
- Verify prerequisite chains have no cycles
- Check that 4 reader journeys are viable: explorer, beginner, practitioner, reviewer (per Art. 02)
- Flag orphaned articles (no inbound or outbound cross-references)

**Source rules (add to Rule-Dimension Mapping table):**

| Validation dimension | Key rules to check | Source |
|---|---|---|
| **Content architecture** | Diátaxis compliance, folder alignment, scope/size, category coverage, learning paths | Art. 02 → Series architecture and planning; Art. 08 → Series-level audit |

### Change 2: Revise the "Ask First" boundary

**File:** `article-review-series-for-consistency-gaps-and-extensions.prompt.md`  
**Impact:** HIGH — unblocks architectural recommendations  
**Effort:** Low  

Current boundary:
> ⚠️ Ask First: Before suggesting major series restructuring (>50% of articles affected)

This conflates **diagnosis** with **implementation**. The AI should always diagnose and recommend — it should only ask before implementing large changes.

Proposed revision:

> ✅ Always Do:
> - Diagnose and report architectural problems (Diátaxis violations, scope issues, missing categories, folder misalignment) with specific evidence — even if >50% of articles are affected
> - Provide restructuring recommendations with effort estimates and priority
>
> ⚠️ Ask First:
> - Before implementing structural changes that affect >50% of articles
> - Before recommending deletion of existing articles
> - Before recommending splitting one article into multiple

### Change 3: Add series-level validation dimensions to `02-validation-criteria.md`

**File:** `02-validation-criteria.md`  
**Impact:** MEDIUM — provides the framework other prompts can reference  
**Effort:** Medium  

Add a new section **"Series-Level Validation Dimensions"** after the existing 7 per-article dimensions:

| Dimension | Definition | Pass criteria | Fail criteria |
|-----------|-----------|--------------|--------------|
| **Architecture compliance** | Articles follow Diátaxis, folder structure is correct, scopes are right-sized | Each article has one clear Diátaxis type; all in correct folders; 400–800 lines (sweet spot); 800–1,000 acceptable with review | Mixed types, misplaced articles, >1,000 lines without justification |
| **Category coverage** | Series represents appropriate Diátaxis types for its goals | All needed types present; no type >60% of total articles | Missing fundamental type; all articles same type |
| **Progression coherence** | Series forms viable learning paths for different audiences | Prerequisite chain acyclic; reading paths navigate able; no orphans | Circular dependencies; dead-end articles; no clear entry point |
| **Structural echo** | Articles of the same Diátaxis type follow the same internal pattern | Tutorials share tutorial structure; references share reference structure | Same-type articles have different section patterns |

### Change 4: Enhance the series planning workflow with category planning

**File:** `03-series-planning-workflow.md`  
**Impact:** MEDIUM — prevents problems at planning time  
**Effort:** Low  

Add to **Phase 2: Structure** a new subsection **"Diátaxis category planning"**:

**Diátaxis category planning:**
For each planned article, assign a Diátaxis type. Build a category coverage matrix:

```yaml
# Category coverage matrix — add to series planning notes
categories:
  concept:  # Explanation articles
    - "00-overview.md"
    - "01-foundations.md"
  howto:    # How-to guides
    - "02-basic-setup.md"
  tutorial: # Step-by-step tutorials  
    - "03-first-project.md"
  reference: # Lookup content
    - "04-api-reference.md"
```

**Validation criteria:**
- A series with 5+ articles SHOULD have at least 2 Diátaxis types
- A series with 10+ articles SHOULD have at least 3 Diátaxis types
- If a series has only how-to articles, ask: "Are there concepts worth explaining? Are there patterns worth documenting as references?"

**Folder structure planning:**
Map category names to folders BEFORE creating articles. Use the structure template from Phase 2's YAML format. This prevents the drift that occurs when articles are created and placed ad-hoc.

### Change 5: Add series awareness to the creation prompt

**File:** `article-design-and-create.prompt.md`  
**Impact:** LOW-MEDIUM — catches individual misplacements at creation time  
**Effort:** Low  

Add to **Phase 5.5: Pre-writing validation gate** two new checks:

```markdown
- [ ] **Series context** (if part of a series): Diátaxis type is consistent with the category folder this article will live in
- [ ] **Scope check:** Article doesn't combine content that should be split per topic-based authoring criteria (>1 distinct purpose, >1 distinct audience)
```

### Change 6: Externalize Phase 2.5 guidance to a template file

**File:** New template file in `.github/templates/article-review-series-for-consistency-gaps-and-extensions/`  
**Impact:** LOW — keeps the prompt lean while providing detailed guidance  
**Effort:** Low  

Create `guidance-architecture-validation.template.md` containing:
- Detailed instructions for each of the 5 architectural checks
- The splitting/merging criteria tables from Art. 02
- The length benchmark table from Art. 02
- The category coverage validation criteria
- Example output format for the architecture assessment

This follows the existing pattern where verbose guidance is externalized to templates (e.g., `guidance-discovery-and-inventory.template.md`, `guidance-research-and-extensions.template.md`).

---

## 📊 Prioritized implementation plan

| Priority | Change | Files affected | Effort | Impact |
|----------|--------|---------------|--------|--------|
| **P1** | **Change 1**: Add Content Architecture phase to series review prompt | `article-review-series-*.prompt.md` + new template | Medium | **Critical** — core fix for the blind spot |
| **P1** | **Change 2**: Revise "Ask First" boundary | `article-review-series-*.prompt.md` | Low | **Critical** — unblocks Change 1's effectiveness |
| **P2** | **Change 3**: Add series-level validation dimensions | `02-validation-criteria.md` | Medium | **High** — provides the framework; referenced by prompts |
| **P2** | **Change 4**: Category planning in series workflow | `03-series-planning-workflow.md` | Low | **High** — prevents problems at planning time |
| **P3** | **Change 5**: Series awareness in creation prompt | `article-design-and-create.prompt.md` | Low | **Medium** — catches individual misplacements |
| **P3** | **Change 6**: Externalize architecture guidance | New template file | Low | **Low** — organizational improvement |

**Implementation order:** P1 first (Changes 1+2 together), then P2 (Changes 3+4), then P3 (Changes 5+6). P1 alone would have caught the prompt engineering series problems.

---

## 🧪 Validation: would Change 1 have caught the prompt engineering problems?

| Problem from the case | Phase 2.5 check that catches it | Expected output |
|-----------------------|--------------------------------|-----------------|
| Article 01.00 mixed 4 Diátaxis types | Check (a): Diátaxis compliance | "01.00 contains tutorial steps, how-to procedures, reference tables, and conceptual explanations. Recommend splitting into 4 articles by type." |
| Articles in wrong folders | Check (b): Folder structure | "Found 3 how-to articles in the concept folder, 2 concept articles with no folder." |
| No concept category existed | Check (d): Category coverage | "Series has 0 explanation articles across 15+ articles. Missing foundational/concept content for: [list]." |
| Monolithic 1,200+ line articles | Check (c): Scope/size | "01.00: 1,247 lines (exceeds 1,000 threshold). Splitting criteria met: multiple audiences, multiple purposes." |
| No coherent learning paths | Check (e): Learning paths | "No viable beginner path: concept articles missing; practitioners can't enter mid-series without reading 01.00 in full." |

**Answer: Yes.** All 5 architectural problems would have been detected by the proposed Phase 2.5 checks.

---

## 📚 Source traceability

Every proposed check traces to authoritative rules:

| Check | Source article | Specific section |
|-------|---------------|-----------------|
| Diátaxis compliance | Art. 02 | "Diátaxis mapping" + Splitting criteria ("Two distinct purposes → Split") |
| Folder structure | Art. 02 | "Applying architecture to this repository" + LATCH framework → Category principle |
| Scope/size analysis | Art. 02 | "Article scope and length guidelines" (4-tier benchmarks: 400–800 sweet spot, 800–1,000 review; splitting/merging tables) |
| Category coverage | Art. 02 | "Scoping a documentation series" + "Designing the learning progression" |
| Learning paths | Art. 02 | "Audience-segmented reading paths" (4 reader journeys) |
| Structural echo | Art. 08 | "Structural consistency" + "Series-level audit" checklist |
| Terminology handoff | Art. 08 | "Terminology consistency" + glossary maintenance |

---

## ✅ Summary

The `01.00-article-writing` system's three-layer architecture (instructions → context → prompts) effectively validates **per-article quality** — voice, mechanics, formatting, readability, completeness. The prior Recommendations A-F successfully filled creation-time gaps and improved token efficiency.

**What's missing is a series-level architectural validation layer.** The series review prompt checks content consistency but not content architecture. It answers "are the articles well-written?" but not "are these the right articles?"

The 6 proposed changes add that architectural layer at three points: review time (Changes 1-2, highest impact), the validation framework (Change 3), planning time (Change 4), and creation time (Changes 5-6). Together, they close the gap between what the `40.00-technical-writing` articles teach about series architecture and what the AI agent can actually validate.

<!--
analysis_metadata:
  filename: "analysis-article-writing-system-architectural-gaps.md"
  created: "2026-03-01"
  purpose: "Post-mortem analysis of series review system failure; restructuring proposal for 01.00-article-writing"
  status: "proposal"
  related_files:
    - "99.00-temp/series-review-structure-and-organization.md"
    - ".github/prompts/01.00-article-writing/article-review-series-for-consistency-gaps-and-extensions.prompt.md"
    - ".copilot/context/01.00-article-writing/02-validation-criteria.md"
    - ".copilot/context/01.00-article-writing/03-article-creation-rules.md"
    - ".copilot/context/01.00-article-writing/workflows/03-series-planning-workflow.md"
    - ".github/prompts/01.00-article-writing/article-design-and-create.prompt.md"
-->
