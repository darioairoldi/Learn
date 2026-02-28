# Series Structural Review: Technical Writing (40.00)

> Structural analysis for optimal readability, understandability, consistency, and reliability

**Series:** `03.00-tech/40.00-technical-writing/` (8 main articles + 5 Microsoft sub-articles)  
**Review date:** 2026-07-22  
**Methodology:** article-review-series-for-consistency-gaps-and-extensions.prompt.md (v2.0, 6-phase)  
**Instruction files reviewed:** `documentation.instructions.md` (133 lines), `article-writing.instructions.md` (833 lines)

---

## 📋 Table of Contents

- [Executive summary](#executive-summary)
- [Phase 1–2: Discovery and content mapping](#phase-12-discovery-and-content-mapping)
- [Phase 3–4: Consistency and gap analysis](#phase-34-consistency-and-gap-analysis)
- [Phase 5–6: Extensions and recommendations](#phase-56-extensions-and-recommendations)
- [Per-article action items](#per-article-action-items)
- [Priority implementation plan](#priority-implementation-plan)

---

## 🎯 Executive summary

This review analyzed all 13 articles in the Technical Writing series against the structural rules defined in `article-writing.instructions.md` and `documentation.instructions.md`. The analysis focused on **optimal article structure** for readability, understandability, consistency, and reliability.

**Overall assessment:** The series has strong content quality and consistent reference formatting. However, it deviates from the documented structural standards in several systematic ways, creating an opportunity for significant improvement across the entire series.

### Findings at a glance

| Finding | Severity | Scope | Status |
|---------|----------|-------|--------|
| Missing H2 emoji prefixes | **CRITICAL** | All 13 articles (~170+ headings) | Not started |
| MS sub-articles missing Conclusion pattern | **MODERATE** | 5 sub-articles | Not started |
| Inconsistent `<mark>` jargon tagging | **MODERATE** | Articles 02–07 (main) | Not started |
| Malformed `<mark>` tag in MS-00 | **LOW** | 1 article, 1 line | Not started |
| Main article endings standardized | — | 8 main articles | **COMPLETED** |

---

## 📋 Phase 1–2: Discovery and content mapping

### Series inventory

**Main series (8 articles):**

| # | File | Lines | TOC | Intro | Conclusion pattern | Refs w/ emoji | Validation metadata |
|---|------|-------|-----|-------|--------------------|---------------|---------------------|
| 00 | `00-foundations-of-technical-documentation.md` | ~600 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 01 | `01-writing-style-and-voice-principles.md` | ~775 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 02 | `02-structure-and-information-architecture.md` | ~824 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 03 | `03-accessibility-in-technical-writing.md` | ~710 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 04 | `04-code-documentation-excellence.md` | ~940 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 05 | `05-validation-and-quality-assurance.md` | ~693 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 06 | `06-citations-and-reference-management.md` | ~649 | ✅ | ✅ | ✅ (standardized) | ✅ | ✅ |
| 07 | `07-ai-enhanced-documentation-writing.md` | ~910 | ✅ | ✅ | ✅ (standardized + Series Summary) | ✅ | ✅ |

**Microsoft Writing Style Guide sub-series (5 articles):**

| # | File | Lines | TOC | Intro | Conclusion pattern | Series Nav | Validation metadata |
|---|------|-------|-----|-------|--------------------|------------|---------------------|
| MS-00 | `00-microsoft-style-guide-overview.md` | ~328 | ✅ | ✅ | ❌ (Series Nav only) | ✅ | ✅ |
| MS-01 | `01-microsoft-voice-and-tone.md` | ~498 | ✅ | ✅ | ❌ (Series Nav only) | ✅ | ✅ |
| MS-02 | `02-microsoft-mechanics-and-formatting.md` | ~560 | ✅ | ✅ | ❌ (Series Nav only) | ✅ | ✅ |
| MS-03 | `03-microsoft-compared-to-other-guides.md` | ~460 | ✅ | ✅ | ❌ (Series Nav only) | ✅ | ✅ |
| MS-04 | `04-microsoft-style-principles-reference.md` | ~1060 | ✅ | ✅ | ❌ (Series Nav only) | ✅ | ✅ |

### Structural rules checked

Rules from `article-writing.instructions.md` Quality Checklist:

| Rule | Requirement | Source |
|------|-------------|--------|
| H2 emoji prefix | Every `##` heading MUST start with an emoji | Quality Checklist → Structure |
| Conclusion structure | Key takeaways + next steps + series navigation | Required Elements → Conclusion |
| `<mark>` jargon tags | Jargon terms marked with `<mark>` on first use | Quality Checklist → Understandability |
| Sentence-style caps | Sentence-style capitalization throughout | Quality Checklist → Writing Style |
| Contractions | Used consistently | Quality Checklist → Writing Style |
| Oxford commas | In all lists | Quality Checklist → Mechanics |
| Reference classification | Emoji markers (📘📗📒📕) on all references | Quality Checklist → References |
| Validation metadata | Bottom HTML comment with `article_metadata:` | Quality Checklist → Metadata |

---

## 🔍 Phase 3–4: Consistency and gap analysis

### Finding 1: H2 heading emoji prefixes — MISSING (CRITICAL)

**Rule:** "Emoji prefixes on ALL H2 section headings (MUST — every `##` heading starts with an emoji)" — [article-writing.instructions.md](../.github/instructions/article-writing.instructions.md), Quality Checklist → Structure

**Status:** **ZERO H2 headings** across any of the 13 articles have emoji prefixes. This affects approximately **170+ headings** across the entire series.

**Examples of current vs. required format:**

| Current | Required |
|---------|----------|
| `## Introduction` | `## 🎯 Introduction` |
| `## Table of Contents` | `## 📋 Table of contents` |
| `## Conclusion` | `## ✅ Conclusion` |
| `## References` | `## 📚 References` |
| `## Active vs. Passive Voice` | `## 💡 Active vs. passive voice` |
| `## The Diátaxis Framework` | `## 🏗️ The Diátaxis framework` |

**Suggested emoji mapping for standard sections:**

| Section | Emoji | Rationale |
|---------|-------|-----------|
| Table of contents | 📋 | List/checklist |
| Introduction | 🎯 | Goal/purpose |
| Conclusion | ✅ | Completion |
| References | 📚 | Books/sources |
| Applying to this repository | ⚙️ | Configuration/application |
| Series navigation | 🔗 | Links |

**Content-specific H2s** should use the most appropriate emoji from the approved set: 🎯📋🏗️⚙️💡❓📚🚀✅📌🔗⚠️

**Impact:** This is the single largest structural deviation from documented standards. Fixing it would significantly improve visual scanning, navigation consistency, and alignment with the quality checklist.

---

### Finding 2: MS sub-articles missing Conclusion pattern (MODERATE)

**Rule:** Required article elements include "Conclusion → Key takeaways (summary bullets) → Next steps → Series navigation" — [article-writing.instructions.md](../.github/instructions/article-writing.instructions.md), Required Elements

**Status:** All 5 Microsoft sub-articles end with `## Series Navigation` → `## References` instead of `## Conclusion` → `### Key Takeaways` → `### Next Steps` → `## References`.

**Current ending pattern (MS sub-articles):**
```markdown
## Series Navigation
[Table of 5 articles with links]
[Related articles links]

## References
[Classified references]
```

**Required ending pattern:**
```markdown
## Conclusion
[Summary paragraph]

### Key Takeaways
- **[Takeaway]** — [explanation]
- ...

### Next Steps
- **Next article:** [link] — description
- **Related:** [link] — description

## References
[Classified references]
```

**Note:** The `## Series Navigation` table is valuable and should be preserved. Consider moving it into the `### Next Steps` subsection or keeping it as an additional section before References.

---

### Finding 3: Inconsistent `<mark>` jargon tagging (MODERATE)

**Rule:** "Jargon terms marked with `<mark>` on first use" and "Jargon introduced with explanatory sentences (not just dropped)" — [article-writing.instructions.md](../.github/instructions/article-writing.instructions.md), Quality Checklist → Understandability

**Status:**

| Article | `<mark>` usage | Assessment |
|---------|----------------|------------|
| 00 — Foundations | **Extensive** (50+ instances) | ✅ Model article |
| 01 — Writing style | **Good** (15+ instances) | ✅ Good usage |
| 02 — Structure | **None** on first-use jargon | ❌ Missing |
| 03 — Accessibility | **None** on first-use jargon | ❌ Missing |
| 04 — Code documentation | **None** on first-use jargon | ❌ Missing |
| 05 — Validation | **None** on first-use jargon | ❌ Missing |
| 06 — Citations | **None** on first-use jargon | ❌ Missing |
| 07 — AI-enhanced | **None** on first-use jargon | ❌ Missing |
| MS-00 — Overview | **Extensive** (30+ instances) | ✅ Model article |
| MS-01 — Voice and tone | **Good** (in H2 headings) | ✅ Partial |
| MS-02 — Mechanics | **Good** (in H2 headings) | ✅ Partial |
| MS-03 — Comparative | **None/minimal** | ⚠️ Low |
| MS-04 — Reference | **None/minimal** | ⚠️ Low |

**Key jargon terms that should have `<mark>` on first use in articles 02–07:**

- Article 02: progressive disclosure, LATCH framework, information architecture, navigation hierarchy
- Article 03: WCAG, screen reader, cognitive accessibility, alt text, ARIA
- Article 04: API reference, docstring, code comments, deprecation notices, changelog
- Article 05: validation dimensions, readability score, Flesch-Kincaid, fact-checking
- Article 06: CRAAP test, SIFT method, DOI, reference classification, link rot
- Article 07: hallucination, prompt engineering, chain-of-thought, temperature, few-shot learning

---

### Finding 4: Malformed `<mark>` tag in MS-00 (LOW)

**Location:** `microsoft-writing-style-guide/00-microsoft-style-guide-overview.md`, line 27

**Current:** `<mark>documentation</<mark>documentation</mark>`  
**Should be:** `<mark>documentation</mark>`

This is a rendering bug — the malformed closing tag `</<mark>` will cause HTML parsing issues.

---

### Finding 5: Consistent elements (PASSING)

The following rules are **consistently followed** across all 13 articles:

- ✅ **YAML frontmatter** at top of every article
- ✅ **Table of Contents** present in every article
- ✅ **Introduction** section in every article
- ✅ **References** section with emoji classification (📘📗📒📕) in every article
- ✅ **Validation metadata** (`article_metadata:`) in HTML comment at bottom of every article
- ✅ **Contractions** used consistently (don't, can't, won't, it's, isn't)
- ✅ **Second person** voice (you/your) throughout
- ✅ **Sentence-style capitalization** in headings (no title case)
- ✅ **Main article endings** now follow standardized Conclusion + Key Takeaways + Next Steps pattern (completed this session)

---

## 🚀 Phase 5–6: Extensions and recommendations

### Priority 1 — Add emoji prefixes to all H2 headings (CRITICAL)

**Effort:** High (~170+ headings across 13 articles)  
**Impact:** High (visual consistency, navigation, quality checklist compliance)  
**Approach:** Process one article at a time. Use consistent emoji assignment for standard sections (Introduction, Conclusion, References, TOC). Select content-appropriate emoji for body sections.

**Recommendation:** Create a dedicated prompt or script to automate the emoji prefix assignment, given the volume of headings.

### Priority 2 — Add Conclusion pattern to MS sub-articles (MODERATE)

**Effort:** Moderate (5 articles, one section each)  
**Impact:** Moderate (series consistency, reader experience)  
**Approach:** For each MS sub-article:
1. Add `## Conclusion` with summary paragraph before the existing `## Series Navigation`
2. Add `### Key Takeaways` with 3–5 bullets
3. Convert `## Series Navigation` content into `### Next Steps` format (retain the series table)
4. Keep `## References` as the final section

### Priority 3 — Add `<mark>` jargon tags to articles 02–07 (MODERATE)

**Effort:** Moderate (6 articles, ~5–10 terms per article)  
**Impact:** Moderate (understandability, first-use jargon highlighting)  
**Approach:** For each article, identify domain-specific terms on their first use and wrap them with `<mark>` tags. Use articles 00 and 01 as the style model — they demonstrate extensive, appropriate `<mark>` usage.

### Priority 4 — Fix malformed `<mark>` tag in MS-00 (LOW)

**Effort:** Minimal (1 line edit)  
**Impact:** Low (rendering fix)  
**Location:** `microsoft-writing-style-guide/00-microsoft-style-guide-overview.md`, line 27

---

## 📌 Per-article action items

### Main series

| Article | Emoji H2s needed | `<mark>` needed | Other |
|---------|-------------------|------------------|-------|
| 00 | ~10 H2 headings | ✅ Already done | — |
| 01 | ~10 H2 headings | ✅ Already done | — |
| 02 | ~30+ H2 headings | ❌ Add to ~5–8 terms | Has inline `## Conclusion` in code example (OK) |
| 03 | ~12 H2 headings | ❌ Add to ~6–8 terms | Contains H2s inside examples (skip those) |
| 04 | ~10 H2 headings | ❌ Add to ~5–7 terms | — |
| 05 | ~8 H2 headings | ❌ Add to ~4–6 terms | Template ref in code block (OK) |
| 06 | ~8 H2 headings | ❌ Add to ~5–7 terms | Template refs in code blocks (OK) |
| 07 | ~10 H2 headings | ❌ Add to ~5–8 terms | — |

### Microsoft sub-series

| Article | Emoji H2s needed | Conclusion pattern | `<mark>` needed | Other |
|---------|-------------------|--------------------|------------------|-------|
| MS-00 | ~8 H2 headings | ❌ Add | ✅ Already done | Fix malformed `<mark>` tag on line 27 |
| MS-01 | ~8 H2 headings | ❌ Add | ✅ Partial (in headings) | — |
| MS-02 | ~8 H2 headings | ❌ Add | ✅ Partial (in headings) | — |
| MS-03 | ~10 H2 headings | ❌ Add | ⚠️ Low usage | — |
| MS-04 | ~14 H2 headings | ❌ Add | ⚠️ Low usage | — |

---

## 📊 Priority implementation plan

### Wave 1 — Quick fixes (1 session)
1. Fix malformed `<mark>` tag in MS-00 line 27
2. Verify all main article endings are correct (already done)

### Wave 2 — Conclusion pattern for MS sub-articles (1–2 sessions)
1. Add Conclusion + Key Takeaways + Next Steps to each of the 5 MS sub-articles
2. Integrate existing Series Navigation content into the new pattern

### Wave 3 — Emoji H2 prefixes (2–3 sessions)
1. Define emoji mapping for all standard sections
2. Apply to articles 00–03 (main)
3. Apply to articles 04–07 (main)
4. Apply to MS sub-articles 00–04

### Wave 4 — `<mark>` jargon tagging (2–3 sessions)
1. Identify first-use jargon terms in articles 02–07
2. Add `<mark>` tags for each term's first appearance
3. Review MS-03 and MS-04 for missing tags

---

## 📚 References

- **[article-writing.instructions.md](../.github/instructions/article-writing.instructions.md)** — Source of structural rules and quality checklist
- **[documentation.instructions.md](../.github/instructions/documentation.instructions.md)** — Base markdown rules and essential structure
- **[gap-analysis-context-vs-articles.md](gap-analysis-context-vs-articles.md)** — Prior gap analysis from initial series review
- **[article-review-series-for-consistency-gaps-and-extensions.prompt.md](../.github/prompts/01.00-article-writing/article-review-series-for-consistency-gaps-and-extensions.prompt.md)** — Review methodology (v2.0, 6-phase)

---

<!--
article_metadata:
  filename: "series-structural-review-technical-writing.md"
  created: "2026-07-22"
  purpose: "Structural review of 40.00 Technical Writing series against documented standards"
  methodology: "article-review-series-for-consistency-gaps-and-extensions.prompt.md v2.0"
  scope: "13 articles (8 main + 5 MS sub-articles)"
  key_findings:
    - "CRITICAL: Zero H2 emoji prefixes across all 170+ headings"
    - "MODERATE: 5 MS sub-articles missing Conclusion pattern"
    - "MODERATE: Articles 02-07 missing <mark> jargon tags"
    - "LOW: Malformed <mark> tag in MS-00 line 27"
  completed_fixes:
    - "All 8 main article endings standardized (Conclusion + Key Takeaways + Next Steps)"
-->
