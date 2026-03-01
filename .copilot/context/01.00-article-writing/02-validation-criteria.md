# Validation Criteria for Technical Documentation

**Purpose**: Quality thresholds, validation dimensions, automated checking criteria, and content lifecycle metrics for technical documentation review.

**Referenced by**:
- `.github/prompts/01.00-article-writing/article-review-*.prompt.md` (review prompts)
- `.github/prompts/01.00-article-writing/article-design-and-create.prompt.md` (creation quality gate)

---

## ⚠️ Instruction Layering

This context file provides **validation-specific criteria and thresholds**. For writing rules and formatting standards, see auto-loaded instructions:

- `article-writing.instructions.md` — Writing style, structure, Diátaxis, accessibility, quality checklist
- `documentation.instructions.md` — Base structure, reference classification, dual metadata

For quantitative metrics and reference tables, see: `01-style-guide.md` (companion context file)

---

## 🎯 Documentation Quality Triangle

Every article MUST satisfy three quality dimensions simultaneously:

| Dimension | Definition | Key Indicators |
|-----------|-----------|----------------|
| **Accuracy** | Content is factually correct and current | Sources cited, code tested, versions specified |
| **Clarity** | Content is readable and understandable | Readability scores in range, jargon explained, logical flow |
| **Completeness** | Content covers the topic adequately | Core aspects addressed, common questions answered, examples provided |

**Publish-ready** = all three dimensions satisfied with no critical failures.

---

## 📊 Quantitative Validation Targets

| Metric | Target | Automatic Fail |
|--------|--------|----------------|
| Flesch Reading Ease | 50–70 | Below 30 or above 80 without justification |
| FK Grade Level | 8–10 (general); 11–12 (advanced) | Above 14 |
| Active Voice % | 75–85% | Below 60% |
| Avg Sentence Length | 15–25 words | Above 35 words average |
| Paragraph Length | 3–5 sentences | Consistently >7 sentences |
| Spelling Errors | 0 | >5 errors |
| Broken Links | 0% | Any broken link |
| Reference Classification | 100% classified | Any 📕 Unverified in published content |
| Code Examples | All tested | Untested or broken code |

**Note**: Exclude code blocks from readability calculations. Higher complexity is acceptable for code-heavy content if justified.

---

## 📋 Seven Validation Dimensions

### 1. Grammar and Mechanics

**Pass**: Zero spelling errors, consistent capitalization (sentence-style), proper punctuation, contractions used consistently.
**Fail**: >5 spelling errors, grammar errors impeding understanding, inconsistent terminology.

### 2. Readability

**Pass**: Metrics within target range for audience level (see targets table), clear paragraph structure, logical transitions, no redundancy.
**Fail**: Metrics significantly off-target without justification, excessive redundancy, contradictory statements.

### 3. Structure

**Pass**: All required elements present (H1, TOC if >500 words, intro, body, conclusion, references), proper heading hierarchy (no skipped levels), emoji prefixes on H2, valid Markdown, code blocks have language specified.
**Fail**: Missing required sections, broken Markdown, skipped heading levels, code blocks without language.

### 4. Logical Flow

**Pass**: Concepts introduced before used, progressive complexity, smooth transitions, conclusion follows from content, prerequisites stated.
**Fail**: Prerequisites not explained, concepts used before introduction, contradictory statements, disconnected sections.

### 5. Factual Accuracy

**Pass**: All claims verified against authoritative sources, versions current, code tested, links valid.
**Fail**: Factually incorrect information, broken links, uncited statistics, non-functional code, security vulnerabilities.
**Frequency**: Technical details quarterly; statistics annually; general concepts at publication.

### 6. Completeness (Gap Analysis)

**Comprehensive**: All major aspects covered, common use cases explained, examples sufficient.
**Minor gaps**: Nice-to-have topics missing, advanced edge cases unexplored (acceptable).
**Fail**: Critical concepts unexplained, common use cases missing, no examples for complex topics.

### 7. Understandability

**Pass**: Target audience can comprehend, jargon marked with `<mark>` and explained in context, tables introduced with context sentences, progressive complexity manageable.
**Fail**: Audience mismatch, unexplained jargon, tables without introduction, sudden complexity jumps.

---
## 🏗️ Series-Level Validation Dimensions

The seven dimensions above validate **individual articles**. When articles form a series, four additional dimensions validate the **series as a whole**. These dimensions are checked by [Phase 2.5: Content Architecture Validation](../../.github/prompts/01.00-article-writing/article-review-series-for-consistency-gaps-and-extensions.prompt.md) in the series review prompt.

| Dimension | Definition | Pass criteria | Fail criteria |
|-----------|-----------|--------------|---------------|
| **Architecture compliance** | Articles follow Diátaxis, folder structure is correct, scopes are right-sized | Each article has one clear Diátaxis type; all in correct folders; 400–800 lines (sweet spot); 800–1,000 acceptable with review | Mixed types, misplaced articles, >1,000 lines without justification |
| **Category coverage** | Series represents appropriate Diátaxis types for its goals | All needed types present; no type >60% of total articles | Missing fundamental type; all articles same type |
| **Progression coherence** | Series forms viable learning paths for different audiences | Prerequisite chain acyclic; reading paths navigable; no orphans | Circular dependencies; dead-end articles; no clear entry point |
| **Structural echo** | Articles of the same Diátaxis type follow the same internal pattern | Tutorials share tutorial structure; references share reference structure | Same-type articles have different section patterns |

### Series size thresholds

| Series size | Minimum Diátaxis types | Rationale |
|-------------|------------------------|----------|
| 1–4 articles | 1 type acceptable | Small series may focus on one purpose |
| 5–9 articles | At least 2 types | Series should serve both learning and doing |
| 10+ articles | At least 3 types | Comprehensive series needs explanation, how-to, AND reference or tutorial |

### Scoring

Series-level dimensions use the same outcome scale as per-article dimensions: **passed**, **minor_issues**, **needs_revision**, **failed**. A series is publish-ready when all four series-level dimensions are passed or minor_issues, AND individual articles pass per-article validation.

**Source rules:**
- Architecture compliance, category coverage, progression coherence: [Art. 02 — Series architecture and planning](../../03.00-tech/40.00-technical-writing/02-structure-and-information-architecture.md)
- Structural echo: [Art. 08 — Series-level audit](../../03.00-tech/40.00-technical-writing/08-consistency-standards-and-enforcement.md)

📖 **Detailed check procedures:** `.github/templates/article-review-series-for-consistency-gaps-and-extensions/guidance-architecture-validation.template.md`

---
## � Comprehension testing (optional validation methods)

Readability formulas predict whether text *should* be understandable. Comprehension tests measure whether text *is actually* understood. Use these methods for high-stakes content (onboarding guides, API quickstarts) or when readability scores pass but user feedback indicates confusion.

📖 **Full methodology with protocols and examples:** [Article 09: Measuring Readability and Comprehension](../../03.00-tech/40.00-technical-writing/09-measuring-readability-and-comprehension.md)

### Cloze test

Delete every 5th word from a representative passage (250–350 words). Ask test subjects to fill in the blanks.

| Cloze score | Comprehension level | Implication |
|-------------|---------------------|-------------|
| 60%+ | Independent | Reader understands without assistance |
| 40–59% | Instructional | Reader understands with some support |
| Below 40% | Frustration | Reader can't understand effectively |

**When to use:** Validate audience reading level before publishing; compare comprehension across draft versions.

### Recall test

Ask readers to read a section, remove the documentation, then ask them to write down or answer questions about key concepts.

- **Free recall** — "Write down everything you remember" (measures deep encoding)
- **Cued recall** — Specific questions like "What command starts the server?" (measures targeted retention)

**When to use:** Verify that procedures are memorable enough for users to execute without constant reference.

### Task-based testing

The most authentic test — ask readers to complete a task using the documentation.

| Metric | What it measures | Target |
|--------|------------------|--------|
| Task completion rate | Can users succeed? | 80%+ first attempt |
| Time-on-task | How efficiently? | Within 1.5× estimated time |
| Error rate | How accurately? | <2 wrong actions per task |
| Help requests | Is documentation self-sufficient? | <1 per task |

**When to use:** Before publishing tutorials and how-to guides; when validating a complete documentation workflow.

**Integration with validation workflow:** Add comprehension testing as an optional Phase 8 after the standard 7-dimension validation. It's recommended for P0/P1 content but not required for every article.

---

## 📐 Quality Triangle → criteria → dimensions mapping

The Quality Triangle (Accuracy, Clarity, Completeness) breaks down into six quality criteria, which are measured through the seven validation dimensions. This mapping ensures every validation dimension traces back to a quality goal.

| Quality Triangle dimension | Quality criteria | Validation dimensions (Phase) |
|---------------------------|-----------------|-------------------------------|
| **Accuracy** | Factual correctness | 5. Factual Accuracy |
| **Accuracy** | Technical currency | 5. Factual Accuracy (version checks) |
| **Clarity** | Readability | 2. Readability |
| **Clarity** | Logical flow | 4. Logical Flow |
| **Clarity** | Understandability | 7. Understandability |
| **Completeness** | Structural completeness | 3. Structure |
| **Completeness** | Content coverage | 6. Completeness (Gap Analysis) |
| *(Cross-cutting)* | Mechanical correctness | 1. Grammar and Mechanics |
| *(Series-level)* | Architectural integrity | Architecture compliance, Category coverage, Progression coherence, Structural echo |

**How to use this mapping:**
- During validation, if a dimension fails, trace it to the Quality Triangle dimension to understand the *type* of quality problem
- During creation, ensure your article addresses all three Triangle dimensions — not just accuracy, but also clarity and completeness
- A "publish-ready" article has no critical failures across all three Triangle dimensions

---

## �🤖 AI-Assisted Content Provenance

When AI generates or assists with content, factual claims MUST be tagged:

| Tag | Meaning | Verification Required |
|-----|---------|----------------------|
| `[SPEC]` | Directly from specification or official docs | Low — source confirmed |
| `[INFERRED]` | Logically derived from available information | Medium — human review |
| `[ASSUMED]` | Based on patterns; not directly confirmed | High — must verify before publish |

**Rules:**
- MUST tag all AI-generated factual claims
- MUST verify all `[ASSUMED]` tags before publication
- SHOULD verify `[INFERRED]` tags with source lookup
- `[SPEC]` tags SHOULD include source reference inline

---

## 📅 Content Freshness Scoring

Five signals determine content freshness (weighted):

| Signal | Weight | Fresh (80–100) | Aging (50–79) | Stale (25–49) | Critical (0–24) |
|--------|--------|----------------|---------------|----------------|-----------------|
| Days Since Validation | 30% | <30 days | 30–90 days | 91–180 days | >180 days |
| Version Currency | 25% | Current | One behind | Two behind | Deprecated |
| Link Health | 15% | 100% valid | >90% valid | >75% valid | <75% valid |
| Open Issues | 15% | 0 | 1–2 | 3–5 | >5 |
| Code Validity | 15% | All pass | Minor issues | Some broken | Major failures |

### Documentation Debt Score (Lower Is Better)

```
Debt = (Open Issues × 3) + (Failed Validations × 2) + (Broken Links × 1) + (Days Since Update / 30)
```

### SLA Tiers

| Priority | Category | Response Time |
|----------|----------|---------------|
| **P0** | Security/accuracy errors | 4 hours |
| **P1** | Broken code/links | 24 hours |
| **P2** | Outdated versions | 1 week |
| **P3** | Style/readability issues | 30 days |
| **P4** | Enhancements | Next scheduled review |

---

## 🔧 Automated Validation Stack

| Tool | Validates | Use For |
|------|----------|---------|
| **Vale** | Style rules, terminology, tone | Custom rules for MS style guide enforcement |
| **LanguageTool** | Grammar, spelling | Programmatic grammar checking |
| **textstat** (Python) | Readability formulas | Flesch, FK, Gunning Fog, SMOG, Coleman-Liau, ARI |
| **markdown-link-check** | Link validity | Automated broken link detection |
| **markdownlint** | Markdown formatting | Heading hierarchy, code blocks, list consistency |
| **IQPilot MCP** | All 7 dimensions | 16 integrated validation tools with caching |

---

## 📊 Validation Outcomes

| Status | Definition | Action |
|--------|-----------|--------|
| **passed** | Meets all criteria | Publish-ready |
| **minor_issues** | Meets most criteria; issues don't block understanding | Can publish with notes |
| **needs_revision** | Issues impede understanding | Fix before publication; re-validate |
| **failed** | Critical errors or omissions | Major revision required |

### Overall Readiness

- **Ready to Publish**: All critical passed, important passed/minor_issues, no broken links, metadata complete
- **Needs Minor Work**: Critical passed, some important needs_revision
- **Not Ready**: Any critical failed/needs_revision

---

## ✅ Pre-Publication Checklist

### Critical (MUST Pass)

- [ ] Grammar: passed
- [ ] Structure: passed
- [ ] Facts: passed (<30 days)
- [ ] Links: 100% valid
- [ ] Code: functional
- [ ] No placeholders (TODO, TBD)

### Important (SHOULD Pass)

- [ ] Readability: within target or justified
- [ ] Logic: passed
- [ ] Completeness: comprehensive or minor_gaps
- [ ] Understandability: passed for target audience
- [ ] All AI content tagged with provenance markers

### Recommended

- [ ] Series validated (if applicable): architecture compliance, category coverage, progression coherence, structural echo
- [ ] Cross-references added
- [ ] Freshness score >80
- [ ] CRAAP test passed on all references (Currency, Relevance, Authority, Accuracy, Purpose)

---

## References

- **External:** [Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/)
- **External:** [Diátaxis Framework](https://diataxis.fr/)
- **Internal:** `.copilot/context/01.00-article-writing/01-style-guide.md` (quantitative targets and replacement tables)
- **Internal:** `.github/instructions/article-writing.instructions.md` (auto-loaded writing rules)
- **Internal:** `03.00-tech/40.00-technical-writing/` (source articles 05, 06, 07, 09, 10)

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 2.2.0 | 2026-03-01 | Added Series-Level Validation Dimensions section with 4 dimensions (architecture compliance, category coverage, progression coherence, structural echo), series size thresholds, scoring rules, and source traceability. Updated Quality Triangle mapping with series-level row. Enhanced Pre-Publication Checklist series line. Source: analysis-article-writing-system-architectural-gaps.md Change 3. | System |
| 2.1.0 | 2026-03-01 | Added comprehension testing section with cloze test, recall test, and task-based testing as optional validation methods (G6). Added Quality Triangle → 6 criteria → 7 dimensions mapping table (G8). Source: Recommendation B from coverage analysis + Art. 09. | System |
| 2.0.0 | 2026-02-28 | Major rewrite: added Quality Triangle, AI provenance tags ([SPEC]/[INFERRED]/[ASSUMED]), content freshness scoring with weighted formula, documentation debt score, SLA tiers, automated tool stack (Vale, textstat, markdownlint), CRAAP test reference; removed duplication with auto-loaded instructions (jargon/table intro rules, formatting standards); streamlined 7 dimensions. Source: 40.00-technical-writing articles 05, 06, 07, 09, 10 | System |
| 1.0.0 | 2025-12-26 | Initial version | System |
