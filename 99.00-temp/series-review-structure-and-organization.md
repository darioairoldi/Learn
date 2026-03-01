

## Architecture overview

Your system has **three operational layers** that convert article-series knowledge into enforceable rules:

| Layer | Files | Load behavior | Token cost |
|-------|-------|--------------|------------|
| **Instructions** | article-writing.instructions.md (~880 lines), documentation.instructions.md (~130 lines) | Auto-loaded on every `.md` interaction | High — paid on every edit |
| **Context** | 01-style-guide.md, 02-validation-criteria.md, 3 workflows | Loaded on-demand by prompts | Moderate — only when needed |
| **Prompts** | 5 prompts (create, review, series-review, analysis, summary) | Executed explicitly by the user | Low — only at invocation |

---

## Coverage mapping: Series-level organization rules (12 rules)

The table below maps each rule from the series review to where it's covered across instructions, context files, and prompts. **Direction** shows whether information flows from the articles into operational guidance.

| # | Rule (from series) | Source article | Instructions | Context | Prompts | Coverage |
|---|---|---|---|---|---|---|
| 1 | **Diátaxis four-type framework** | Art. 00 | `article-writing`: 4 types with structure patterns | — | `design-create`: Phase 1 type selection | ✅ Good |
| 2 | **Content-first design** | Art. 02 | — | — | — | ❌ **Gap** |
| 3 | **Topic-based authoring** | Art. 02 | — | — | — | ❌ **Gap** |
| 4 | **Progressive disclosure** | Art. 02 | Brief mention (progressive complexity in checklist) | — | — | ⚠️ Weak |
| 5 | **LATCH framework** | Art. 02 | — | — | — | ❌ **Gap** |
| 6 | **Structural echo pattern** | Art. 08 | `article-writing`: Required Article Elements = implicit echo | — | `design-create`: template structure | ✅ Implicit |
| 7 | **Terminology handoff pattern** | Art. 08 | — | `03-series-planning`: "glossary terms defined consistently" | `series-review`: Phase 3 terminology check | ⚠️ Checked but not taught |
| 8 | **Reference alignment pattern** | Art. 08 | — | `03-series-planning`: "All cross-links valid" | `series-review`: Phase 4 cross-reference | ⚠️ Checked but not taught |
| 9 | **Series-level audit checklist** | Art. 08 | — | `03-series-planning`: consistency checklist | `series-review`: entire prompt | ✅ Good |
| 10 | **Documentation lifecycle** | Art. 10 | — | `02-validation`: freshness, SLAs; `02-review-wf`: stability guide | `review`: triggered reviews | ✅ Good |
| 11 | **Content freshness scoring** | Art. 10 | — | `02-validation`: 5-signal weighted model | `review`: references freshness | ✅ Good |
| 12 | **Three-level quality hierarchy** | Art. 00, 05 | — | `02-validation`: Quality Triangle + 7 dims | `review`: uses 7 dimensions | ⚠️ Triangle exists; 3-level mapping missing |

**Summary:** 4 rules well-covered, 3 partially covered (reviewed but not proactively applied), **5 rules not operationalized** (2, 3, 4, 5, and 12's full hierarchy).

---

## Coverage mapping: Per-article internal structure rules (20 rules)

| # | Rule | Source | Instructions | Context | Prompts | Coverage |
|---|---|---|---|---|---|---|
| 1 | **Standard article pattern** | Art. 02 | `article-writing`: Required Article Elements | `01-creation-wf` | `design-create`: Phase 5–6 | ✅ Excellent |
| 2 | **Reference pattern** | Art. 02 | `article-writing`: type listed | — | — | ⚠️ Listed but no template |
| 3 | **How-to pattern** | Art. 02 | `article-writing`: Common Patterns | — | `design-create`: template selection | ✅ Good |
| 4 | **Tutorial pattern** | Art. 02 | `article-writing`: Common Patterns | — | `design-create`: template selection | ✅ Good |
| 5 | **Wikipedia pattern** | Art. 02 | — | — | — | ❌ **Gap** |
| 6 | **Active voice default** | Art. 01 | `article-writing`: explicit rule | `01-style-guide`: 80–90% target | — | ✅ Excellent |
| 7 | **Readability targets** | Art. 01, 09 | `article-writing`: Flesch 50–70 etc. | `01-style-guide`: full tables; `02-validation`: pass/fail | — | ✅ Excellent (but 3-way duplication) |
| 8 | **Heading hierarchy** | Art. 02 | `article-writing`: "Limit depth to H3" | — | — | ✅ Good |
| 9 | **TOC design** | Art. 02 | `article-writing`: ">500 words" only | — | — | ⚠️ Missing: 5–9 items, parallel construction |
| 10 | **Table introduction rule** | Instructions | `article-writing`: explicit REQUIRED rule | — | — | ✅ Good |
| 11 | **Jargon marking** | Art. 01, 08 | `article-writing`: `<mark>` rule | — | `design-create`: Phase 6 | ✅ Good |
| 12 | **Seven validation dimensions** | Art. 05 | — | `02-validation`: complete treatment | `review`: 7-phase process | ✅ Good |
| 13 | **Conclusion standard** | Art. 08 | `article-writing`: "Summary + Next steps" | — | — | ⚠️ Missing: bold+em-dash Key Takeaways pattern |
| 14 | **Reference classification** | Art. 06 | `documentation.instructions`: 📘📗📒📕 | — | All prompts | ✅ Excellent |
| 15 | **Cross-reference strategies** | Art. 02 | — | `03-series-planning`: basic checklist | `series-review`: validation only | ⚠️ 5 strategies not distilled |
| 16 | **Comprehension testing** | Art. 09 | — | — | — | ❌ **Gap** |
| 17 | **Information scent** | Art. 09 | — | — | — | ❌ **Gap** |
| 18 | **Seven readability formulas** | Art. 01, 09 | — | `01-style-guide`: all 7 with CI/CD recommendation | `02-validation`: primary + secondary | ✅ Good |
| 19 | **Accessibility** | Art. 03 | `article-writing`: dedicated section | — | — | ✅ Good |
| 20 | **Visual content decisions** | Art. 11 | — | `01-style-guide`: visual budget, diagramming | — | ⚠️ Not enforced by prompts |

**Summary:** 11 well-covered, 6 partially covered, **3 rules not operationalized** (5, 16, 17).

---

## Key findings

### 1. Coverage gaps — 8 rules never reach the AI agent

These rules exist in the articles but aren't in any file the AI reads during creation or review:

| Gap | Rule | Impact | Why it matters |
|-----|------|--------|---------------|
| **G1** | Content-first design | Not applied during creation | Agent creates articles without first mapping audience + content needs |
| **G2** | Topic-based authoring | Not applied | Self-contained topic principle not enforced |
| **G3** | Progressive disclosure (operational) | Weak — only a checklist mention | No 3-layer model guidance during writing |
| **G4** | LATCH framework | Not applied | No guidance on choosing organizing principle |
| **G5** | Wikipedia pattern | Not available as template | Missing page pattern option |
| **G6** | Comprehension testing | Not integrated | Review process never tests reader comprehension |
| **G7** | Information scent | Not integrated | Link text quality never checked |
| **G8** | 3-level quality hierarchy (full) | Partial | Quality Triangle exists but mapping to 6 criteria → 7 dimensions isn't operational |

### 2. Duplication — 3 areas with redundant content

| Duplication | Files involved | Lines wasted |
|---|---|---|
| **Readability targets** | article-writing.instructions.md (lines ~395–410) + 01-style-guide.md (lines ~18–50) + 02-validation-criteria.md (lines ~37–55) | ~60 lines across 3 files |
| **Procedure writing rules** | article-writing.instructions.md (Procedures section ~460–485) + 01-style-guide.md (Procedure Quick Rules ~162–175) | ~25 lines duplicated |
| **Common Patterns** | article-writing.instructions.md (lines ~757–840) duplicates what should be in templates files | ~80 lines in auto-loaded file |

### 3. Token efficiency problem

article-writing.instructions.md (~880 lines) is **auto-loaded on every `.md` file interaction** — even simple file reads, small edits, or metadata updates. It contains:

- **Always needed** (~400 lines): voice, mechanics, formatting, accessibility, boundaries
- **Only needed during creation/review** (~480 lines): Diátaxis structures, required elements, common patterns, quality checklist, writing style deep rules, technical content rules

Every markdown interaction pays the token cost for rules that are only relevant during dedicated creation or review sessions.

### 4. Prompt-instruction linkage gap

The prompts say "Apply all rules from auto-loaded article-writing.instructions.md" but don't map specific rules to specific workflow phases. The review prompt checks 7 validation dimensions but doesn't reference which instruction rules map to each dimension.

---

## Recommendations

### Recommendation A: Split instructions into two tiers (highest efficiency impact)

**Goal:** Reduce auto-load cost by ~50% while maintaining full coverage.

**Tier 1 — Keep in article-writing.instructions.md (auto-loaded, ~400 lines):**
- Core writing principles (voice)
- Mechanical rules (capitalization, punctuation, contractions, person, numbers)
- Formatting standards (code blocks, emphasis, lists, tables, links, UI elements)
- Accessibility requirements
- Critical boundaries (always/ask/never)
- Compact checklist (abbreviated — reference 02-validation-criteria.md for details)

**Tier 2 — Move to new context file `01.00-article-writing/03-article-creation-rules.md` (loaded by prompts):**
- Diátaxis structure patterns (4 types with full templates)
- Required article elements (detailed section requirements)
- Common patterns (or move these to templates directory)
- Writing style deep rules (active voice guidance, plain language tables, global-ready writing detailed rules)
- Technical content requirements
- Quality checklist (verbose version — merge with or reference 02-validation-criteria.md)
- Reference Materials section

**In article-writing.instructions.md Tier 1, add a pointer:**
> For comprehensive article creation guidance (Diátaxis patterns, required elements, templates, technical content rules): See `.copilot/context/01.00-article-writing/03-article-creation-rules.md`

**Update prompts:** Add `03-article-creation-rules.md` to the context references in article-design-and-create.prompt.md and the review prompts.

### Recommendation B: Fill the 8 coverage gaps

Add the missing rules to appropriate operational files:

| Gap | Add to | What to add |
|-----|--------|-------------|
| **G1**: Content-first design | `03-article-creation-rules.md` (new Tier 2) OR 01-article-creation-workflow.md | 3-step process: map audience → inventory existing content → define scope before writing |
| **G2**: Topic-based authoring | `03-article-creation-rules.md` | Self-contained topic principle: each article must be comprehensible independently, even when part of a series |
| **G3**: Progressive disclosure | `03-article-creation-rules.md` | 3-layer model (surface → detail → expert) with application table by Diátaxis type |
| **G4**: LATCH framework | `03-article-creation-rules.md` | 5 organizing principles with "when to use which" decision table |
| **G5**: Wikipedia pattern | templates OR `03-article-creation-rules.md` | Wikipedia-style template (Lead, TOC, Body, See Also, Notes, References) |
| **G6**: Comprehension testing | 02-validation-criteria.md | Add cloze test, recall test, and task-based testing as optional validation methods |
| **G7**: Information scent | article-writing.instructions.md Tier 1 (compact) | Add to Links section: "Link text must contain trigger words that match what readers are looking for" |
| **G8**: 3-level quality hierarchy | 02-validation-criteria.md | Add explicit mapping table: Quality Triangle → 6 criteria → 7 dimensions |

### Recommendation C: Eliminate 3 duplications

| Duplication | Action |
|---|---|
| **Readability targets** | Keep quantitative tables in 01-style-guide.md only. In article-writing.instructions.md, keep one summary sentence with a reference: "Readability targets: Flesch 50–70, FK 8–10. See 01-style-guide.md for full metrics." In 02-validation-criteria.md, keep pass/fail thresholds only (they're different from targets). |
| **Procedure rules** | Keep the detailed 7-rule list in article-writing.instructions.md Tier 1 only (it's always-needed formatting). Remove the "Procedure Writing Quick Rules" section from 01-style-guide.md or replace it with a pointer. |
| **Common Patterns** | Move pattern templates to templates as separate files (e.g., `tutorial-intro-pattern.md`, `howto-intro-pattern.md`). Replace in instructions with: "See templates in templates for article introduction patterns." |

### Recommendation D: Add rule-dimension mapping to prompts

Add a compact mapping table to the review prompt that connects validation dimensions to specific instruction rules:

```markdown
## Rule-Dimension Mapping

| Validation dimension | Key rules to check | Source |
|---|---|---|
| Grammar & Mechanics | Sentence case, Oxford comma, contractions, en dashes | `article-writing.instructions` → Mechanical Rules |
| Readability | Flesch 50-70, FK 8-10, 15-25 word sentences | `01-style-guide.md` → Primary Metrics |
| Structure | Required sections, heading hierarchy, emoji H2, TOC | `article-writing.instructions` → Required Elements |
| Logical flow | Progressive disclosure, prerequisite ordering | `03-article-creation-rules.md` → Progressive Disclosure |
| Factual accuracy | Sources cited, code tested, versions current | `02-validation-criteria.md` → Dimension 5 |
| Completeness | Diátaxis type fully covered, common use cases | `02-validation-criteria.md` → Dimension 6 |
| Understandability | Jargon marked, tables introduced, audience-appropriate | `article-writing.instructions` → Jargon rules |
```

This gives the AI agent a direct lookup path from "what to check" to "where the rules are," reducing hallucinated rule interpretations.

### Recommendation E: Add creation-time validation checkpoints

In article-design-and-create.prompt.md, add inline validation gates between phases:

```markdown
### Phase 5.5: Pre-writing validation gate

Before drafting (Phase 6), verify:
- [ ] Diátaxis type selected and structure pattern identified
- [ ] Progressive disclosure plan: what's surface vs. detail vs. expert?
- [ ] Content-first check: audience defined, existing content mapped, no duplication
- [ ] LATCH principle chosen for primary organization
- [ ] Template selected and required elements identified
```

This operationalizes the gap rules (G1–G4) without requiring a separate context file.

### Recommendation F: Strengthen series workflows

Add to 03-series-planning-workflow.md → Phase 2 (Structure):

1. **Terminology handoff rule:** "For each concept, identify the article that introduces it. All subsequent articles must use the same term without redefining it. Maintain a terminology map: `term → introducing article → definition`."

2. **Cross-reference strategy selection:** "Choose your cross-referencing approach per article: inline references, See Also blocks, Prerequisites sections, Next Steps links, or hub-and-spoke navigation."

3. **Content-first design step:** "Before structuring, answer: What content already exists? Who needs it? What's the minimum viable series that covers all audience needs?"

---

## Prioritized implementation plan

| Priority | Recommendation | Effort | Impact |
|---|---|---|---|
| **P1** | **A**: Split instructions into two tiers | Medium (restructure, update prompt references) | High — ~50% token reduction on every `.md` interaction |
| **P1** | **C**: Eliminate 3 duplications | Low (remove/consolidate ~165 lines) | Medium — reduces maintenance burden and conflicting guidance |
| **P2** | **B**: Fill 8 coverage gaps | Medium (write ~200 lines of new operational rules) | High — 8 rules from articles become actionable |
| **P2** | **E**: Add creation-time validation gate | Low (add ~15 lines to prompt) | Medium — operationalizes 4 gap rules at creation time |
| **P3** | **D**: Add rule-dimension mapping to review prompts | Low (add ~20 lines) | Medium — improves review accuracy and consistency |
| **P3** | **F**: Strengthen series workflows | Low (add ~30 lines) | Medium — fills series-level operational gaps |

**P1 changes** together reduce token cost by ~50% per interaction and eliminate conflicting guidance. **P2 changes** close the gap between what the articles teach and what the AI agent can execute. **P3 changes** improve precision of existing processes. 

Completed: *Write recommendations* (7/7)

Would you like me to proceed with implementing any of these recommendations? I'd suggest starting with P1 (splitting instructions + eliminating duplications) for the biggest immediate impact on efficiency.