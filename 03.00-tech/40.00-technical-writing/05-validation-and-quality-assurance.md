---
# Quarto Metadata
title: "Validation and Quality Assurance"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, validation, quality-assurance, reviews, metrics]
description: "Establish documentation quality through validation frameworks, review processes, metrics measurement, and continuous improvement workflows"
---

# Validation and Quality Assurance

> Build confidence in documentation quality through structured validation, measurable metrics, and continuous improvement

## Table of Contents

- [Introduction](#introduction)
- [Validation Frameworks](#validation-frameworks)
- [The Seven Validation Dimensions](#the-seven-validation-dimensions)
- [Review Processes](#review-processes)
- [Quality Metrics](#quality-metrics)
- [Automated Validation](#automated-validation)
- [Continuous Improvement](#continuous-improvement)
- [Validation in This Repository](#validation-in-this-repository)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Documentation quality isn't subjective—it can be measured, validated, and improved systematically. This article presents frameworks for assessing and ensuring documentation quality.

This article covers:

- **Validation frameworks** - Structured approaches to quality assessment
- **Seven dimensions** - Grammar, readability, structure, fact accuracy, logical coherence, coverage, and references
- **Review processes** - Human review workflows that improve quality
- **Quality metrics** - Measurable indicators of documentation health
- **Automation** - Tools that scale validation efforts
- **Continuous improvement** - Workflows that prevent quality regression

**Why validation matters:** Inaccurate documentation erodes trust. Users who find one error question everything else. Systematic validation builds and maintains credibility.

**Prerequisites:** Familiarity with [writing style](01-writing-style-and-voice-principles.md), [structure](02-structure-and-information-architecture.md), and [code documentation](04-code-documentation-excellence.md).

## Validation Frameworks

Different organizations approach documentation validation differently. Understanding multiple frameworks helps you build the right approach for your context.

### The Documentation Quality Triangle

Documentation quality balances three concerns:

```
                Accuracy
                   △
                  /  \
                 /    \
                /      \
               /________\
        Clarity          Completeness
```

**Accuracy:** Information is correct and current
**Clarity:** Information is understandable
**Completeness:** Information is sufficient for user needs

Trade-offs exist:
- Maximum accuracy may sacrifice clarity (technical precision vs. accessibility)
- Maximum completeness may sacrifice clarity (information overload)
- Maximum clarity may sacrifice completeness (oversimplification)

### Wikipedia's Good Article Criteria

Wikipedia's [Good Article criteria](https://en.wikipedia.org/wiki/Wikipedia:Good_article_criteria) provide a tested framework:

1. **Well-written** - Clear, concise prose following style guides
2. **Verifiable** - Claims cited to reliable sources
3. **Broad coverage** - Topic covered comprehensively without major gaps
4. **Neutral** - Fair representation without bias
5. **Stable** - Not subject to ongoing edit wars
6. **Illustrated** - Images have appropriate captions and licenses

**Application to technical documentation:**
| Wikipedia Criterion | Technical Doc Equivalent |
|---------------------|--------------------------|
| Well-written | Grammar, readability, style |
| Verifiable | Accurate technical claims, working code |
| Broad coverage | Complete API coverage, all use cases |
| Neutral | Objective technical presentation |
| Stable | Versioned, change-tracked |
| Illustrated | Diagrams, screenshots, code examples |

### Google's QUAC Framework

Google uses QUAC for documentation quality:

- **Quality** - Technical accuracy and completeness
- **Usability** - Can users accomplish their goals?
- **Accessibility** - Works for all users
- **Consistency** - Follows established patterns

### Microsoft's Five Pillars

Microsoft documentation emphasizes:

1. **Accuracy** - Technically correct
2. **Completeness** - All information present
3. **Clarity** - Understandable writing
4. **Task orientation** - Helps users accomplish goals
5. **Consistency** - Follows style guide

## The Seven Validation Dimensions

This repository uses seven validation dimensions, documented in [validation-criteria.md](../../.copilot/context/01.00-article-writing/02-validation-criteria.md).

### Dimension 1: Grammar

**What it measures:** Language correctness—spelling, grammar, punctuation, syntax

**Quality indicators:**
- No spelling errors
- Correct subject-verb agreement
- Proper punctuation
- Consistent capitalization
- Correct word usage (their/there/they're)

**Validation approach:**
1. Automated spell-check
2. Grammar checker (Grammarly, LanguageTool)
3. Human review for context-dependent issues

**Reference prompt:** [grammar-review.prompt.md](../../.github/prompts/grammar-review.prompt.md)

### Dimension 2: Readability

**What it measures:** How easily text can be understood

**Quality indicators (targets):**
- **Flesch Reading Ease:** 50-70 (plain English)
- **Flesch-Kincaid Grade:** 9-10 (high school level)
- **Sentence length:** 15-25 words average
- **Paragraph length:** 3-5 sentences
- **Active voice:** 75-85%

**Validation approach:**
1. Calculate readability scores
2. Identify overly complex sentences
3. Flag passive voice overuse
4. Check for jargon density

**Reference prompt:** [readability-review.prompt.md](../../.github/prompts/readability-review.prompt.md)

### Dimension 3: Structure

**What it measures:** Organization and navigation effectiveness

**Quality indicators:**
- Logical heading hierarchy (no skipped levels)
- Clear introduction stating scope
- Conclusion summarizing key points
- Effective use of lists and tables
- Appropriate cross-references

**Validation approach:**
1. Check heading hierarchy
2. Verify introduction/conclusion presence
3. Assess information flow
4. Validate internal links

### Dimension 4: Fact Accuracy

**What it measures:** Technical correctness of claims

**Quality indicators:**
- Code examples work as written
- Version numbers are current
- Links resolve correctly
- Technical claims are accurate
- Commands produce expected results

**Validation approach:**
1. Test all code examples
2. Verify version information
3. Check all links
4. Expert review for technical claims

**This is the hardest dimension to automate.** Fact accuracy often requires:
- Domain expertise
- Running code in context
- Access to systems described
- Knowledge of recent changes

### Dimension 5: Logical Coherence

**What it measures:** Argument flow and reasoning consistency

**Quality indicators:**
- Ideas flow logically
- Transitions connect sections
- No contradictions
- Assumptions stated explicitly
- Prerequisites identified

**Validation approach:**
1. Read for argument flow
2. Check for contradictions
3. Verify logical connections
4. Identify unstated assumptions

### Dimension 6: Coverage

**What it measures:** Completeness relative to topic scope

**Quality indicators:**
- All relevant subtopics addressed
- No major gaps
- Edge cases covered
- Error scenarios documented
- Prerequisites documented

**Validation approach:**
1. Compare against topic outline
2. Check for missing scenarios
3. Verify prerequisite documentation
4. Gap analysis against similar resources

### Dimension 7: References

**What it measures:** Citation quality and source reliability

**Quality indicators:**
- Claims supported by references
- Sources are authoritative
- References are current
- Links are functional
- Reference classification accurate (📘📗📒📕)

**Validation approach:**
1. Verify all links
2. Assess source authority
3. Check publication dates
4. Validate classification markers

**Reference classification system:**
| Marker | Category | Sources |
|--------|----------|---------|
| 📘 | Official | Microsoft Learn, vendor documentation |
| 📗 | Verified Community | Peer-reviewed, established blogs |
| 📒 | Community | Personal blogs, forums |
| 📕 | Unverified | Broken links, unknown sources |

## Review Processes

Automated validation catches mechanical issues. Human review catches conceptual issues, audience mismatches, and subtle errors.

### Types of Documentation Review

**Self-review:** Author reviews own work after time gap
- Effective for catching obvious errors
- Limited by author's blind spots

**Peer review:** Colleague reviews before publication
- Catches clarity issues (what's clear to author may not be clear to reader)
- May miss technical accuracy issues

**Expert review:** Subject matter expert validates technical content
- Essential for fact accuracy
- Often bottleneck in process

**User testing:** Target audience attempts to use documentation
- Gold standard for usability
- Most expensive and time-consuming

### Review Checklist

**Before submitting for review:**
- [ ] Spell-check passed
- [ ] Grammar-check passed
- [ ] All links tested
- [ ] Code examples tested
- [ ] Reading level appropriate
- [ ] Follows style guide

**During peer review, check:**
- [ ] Purpose is clear
- [ ] Audience is appropriate
- [ ] Information is complete
- [ ] Structure aids understanding
- [ ] Examples are helpful
- [ ] No contradictions

**During expert review, verify:**
- [ ] Technical claims accurate
- [ ] Code works correctly
- [ ] Versions current
- [ ] Best practices followed
- [ ] No security issues

### Review Feedback Guidelines

**For reviewers:**
- Be specific (not "this is confusing" but "the relationship between X and Y is unclear")
- Suggest solutions when possible
- Distinguish required changes from suggestions
- Focus on the work, not the author

**For authors:**
- Respond to all feedback
- Ask for clarification if needed
- Explain reasoning for disagreements
- Thank reviewers

## Quality Metrics

Metrics make quality visible and improvable over time.

### Quantitative Metrics

**Readability metrics:**
```
Flesch Reading Ease = 206.835 - 1.015(words/sentences) - 84.6(syllables/words)
Flesch-Kincaid Grade = 0.39(words/sentences) + 11.8(syllables/words) - 15.59
```

**Structural metrics:**
- Average section length
- Heading depth distribution
- Code-to-prose ratio
- Links per 1000 words

**Coverage metrics:**
- API coverage percentage
- Error scenario coverage
- Feature documentation coverage

**Currency metrics:**
- Average document age
- Documents updated in last 90 days
- Percentage with verified links

### Qualitative Metrics

**User feedback:**
- Documentation satisfaction scores
- "Was this helpful?" responses
- Support ticket mentions of documentation

**Search metrics:**
- Search queries with no results
- Most-viewed pages
- Pages with high bounce rates

**Maintenance metrics:**
- Time to update after product change
- Review cycle time
- Validation pass rate

### Metric Targets for This Repository

From [validation-criteria.md](../../.copilot/context/01.00-article-writing/02-validation-criteria.md):

| Metric | Target | Measurement |
|--------|--------|-------------|
| Flesch Reading Ease | 50-70 | Per article |
| Flesch-Kincaid Grade | 9-10 | Per article |
| Active Voice | 75-85% | Per article |
| Sentence Length | 15-25 words | Average per article |
| Link Validity | 100% | Site-wide |
| Reference Classification | 100% classified | Per article |

## Automated Validation

Automation scales validation and provides consistency.

### What to Automate

**High automation potential:**
- Spell-checking
- Grammar checking
- Link validation
- Readability scoring
- Heading hierarchy validation
- Style guide compliance

**Medium automation potential:**
- Code example syntax checking
- Terminology consistency
- Reference format validation
- Structure template compliance

**Low automation potential:**
- Fact accuracy
- Logical coherence
- Audience appropriateness
- Completeness for purpose

### Validation Tools

**Text quality:**
- **Vale** - Prose linting with custom rules
- **LanguageTool** - Grammar and style checking
- **textstat** - Readability scoring (Python)
- **write-good** - English prose suggestions

**Link checking:**
- **markdown-link-check** - Validates markdown links
- **linkchecker** - Comprehensive link validation
- **Repository scripts** - [check-links.ps1](../../scripts/check-links.ps1)

**Documentation-specific:**
- **Sphinx** - Documentation build validation
- **MkDocs** - Static site generation with validation
- **Quarto** - This repository's rendering engine

### Implementing Validation Pipeline

```yaml
# Example CI/CD validation workflow
name: Documentation Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check spelling
        uses: streetsidesoftware/cspell-action@v5
        
      - name: Validate links
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        
      - name: Check style
        run: vale .
        
      - name: Build documentation
        run: quarto render
```

### IQPilot Validation Tools

This repository's [IQPilot MCP server](../../src/IQPilot/) provides validation tools:

**Available tools:**
- Grammar validation
- Readability analysis
- Structure validation
- Reference classification check
- Cross-reference validation
- Gap analysis

**Usage pattern:**
1. Author writes/updates documentation
2. Runs validation via natural language ("validate grammar for this article")
3. Tool checks content against criteria
4. Results cached to avoid redundant validation
5. Metadata updated with validation status

## Continuous Improvement

Quality isn't a destination—it's a process.

### The Quality Improvement Cycle

```
    ┌─────────────┐
    │   Measure   │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │   Analyze   │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │   Improve   │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │  Validate   │
    └──────┬──────┘
           │
           └──────► (repeat)
```

**Measure:** Collect metrics on current state
**Analyze:** Identify patterns and root causes
**Improve:** Make targeted changes
**Validate:** Verify improvement achieved

### Documentation Debt

Like technical debt, documentation debt accumulates:

**Types of documentation debt:**
- **Accuracy debt** - Information that's become outdated
- **Coverage debt** - Features lacking documentation
- **Quality debt** - Content that doesn't meet standards
- **Structural debt** - Organization that's grown inconsistent

**Managing documentation debt:**
1. Track known issues (documentation issue backlog)
2. Prioritize by user impact
3. Allocate time for debt reduction
4. Prevent new debt (validation in workflow)

### Validation-Driven Workflows

**Pre-publish validation:**
1. Author completes draft
2. Runs automated validation
3. Fixes identified issues
4. Submits for review
5. Reviewer validates changes
6. Publish

**Post-publish monitoring:**
1. Track user feedback
2. Monitor link health
3. Check for outdated content
4. Schedule periodic reviews

**Triggered updates:**
1. Product change triggers documentation review
2. Identified gaps added to backlog
3. Validation confirms completeness

## Validation in This Repository

### Validation Metadata System

Each article tracks validation status in bottom YAML:

```yaml
<!-- Validation Metadata
validation_status: validated_clean  # or pending, needs_review
validation_history:
  grammar:
    last_run: "2026-01-14"
    status: pass
    score: 95
  readability:
    last_run: "2026-01-10"
    status: pass
    score: 68  # Flesch Reading Ease
    grade: 9.5  # Flesch-Kincaid
-->
```

### Validation Prompts

Located in [.github/prompts/](../../.github/prompts/):

**Core validation prompts:**
- `grammar-review.prompt.md` - Grammar validation
- `readability-review.prompt.md` - Readability analysis
- `structure-review.prompt.md` - Structure validation
- `fact-check.prompt.md` - Fact accuracy review

**Usage:**
```
Run grammar-review.prompt on this article
```

### Validation Caching

IQPilot caches validation results to avoid redundant processing:

- **Cache duration:** 7 days (configurable)
- **Cache invalidation:** Content changes
- **Cache key:** File path + content hash

**Rationale:** Validation (especially AI-powered) can be expensive. Caching reduces costs while maintaining freshness.

### Reference Validation

All references should use classification markers:

**Validation checks:**
1. All external links have markers
2. Markers match source types
3. No 📕 markers in published content
4. Links resolve correctly

**Reference template:**
```markdown
**[Title](url)** 📘 [Official]  
Brief description of content and relevance.
```

## Conclusion

Documentation validation transforms quality from aspiration to achievement. Key principles:

**Multiple dimensions matter** - Grammar, readability, structure, accuracy, coherence, coverage, and references each contribute to quality

**Combine automation with human review** - Automation catches mechanical issues; humans catch conceptual issues

**Measure to improve** - Metrics make quality visible and enable targeted improvement

**Build validation into workflow** - Validate before publishing, monitor after publishing

**Treat documentation debt seriously** - Track and address quality gaps systematically

**Use frameworks consistently** - Wikipedia's criteria, the quality triangle, and this repository's seven dimensions provide tested approaches

**Next in series:**

- [06-citations-and-reference-management.md](06-citations-and-reference-management.md) - Deep dive into reference validation
- [07-ai-enhanced-documentation-writing.md](07-ai-enhanced-documentation-writing.md) - AI-powered validation approaches
- [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) - Readability principles

## References

### Quality Frameworks

**[Wikipedia Good Article Criteria](https://en.wikipedia.org/wiki/Wikipedia:Good_article_criteria)** 📘 [Official]  
Wikipedia's criteria for quality articles, applicable to documentation quality assessment.

**[Wikipedia Featured Article Criteria](https://en.wikipedia.org/wiki/Wikipedia:Featured_article_criteria)** 📘 [Official]  
Wikipedia's highest quality standard, providing aspirational quality criteria.

**[Google Developer Documentation Style Guide - Quality](https://developers.google.com/style)** 📘 [Official]  
Google's documentation quality standards and guidelines.

**[Microsoft Writing Quality](https://learn.microsoft.com/style-guide/top-10-tips-style-voice)** 📘 [Official]  
Microsoft's quality principles for documentation.

### Validation Tools

**[Vale - A Linter for Prose](https://vale.sh/)** 📗 [Verified Community]  
Open-source prose linter with customizable rules.

**[LanguageTool](https://languagetool.org/)** 📗 [Verified Community]  
Grammar and style checker supporting multiple languages.

**[textstat (Python)](https://pypi.org/project/textstat/)** 📗 [Verified Community]  
Python library for calculating text readability metrics.

**[markdown-link-check](https://github.com/tcort/markdown-link-check)** 📗 [Verified Community]  
Tool for validating links in markdown files.

### Metrics and Measurement

**[Flesch Reading Ease](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)** 📘 [Official]  
Wikipedia's explanation of Flesch readability formulas.

**[Plain Language Action and Information Network](https://www.plainlanguage.gov/guidelines/test/)** 📘 [Official]  
US government guidance on testing document readability.

### Review Processes

**[Google Engineering Practices - Code Review](https://google.github.io/eng-practices/review/)** 📘 [Official]  
Google's code review guidelines, applicable to documentation review.

**[Write the Docs - Documentation Review](https://www.writethedocs.org/guide/docs-as-code/)** 📗 [Verified Community]  
Community guidance on documentation review as part of docs-as-code.

### Repository-Specific Documentation

**[Validation Criteria](../../.copilot/context/01.00-article-writing/02-validation-criteria.md)** [Internal Reference]  
This repository's seven validation dimensions and quality targets.

**[Grammar Review Prompt](../../.github/prompts/grammar-review.prompt.md)** [Internal Reference]  
Prompt file for grammar validation.

**[IQPilot README](../../src/IQPilot/README.md)** [Internal Reference]  
MCP server providing validation tools.

**[Link Check Script](../../scripts/check-links.ps1)** [Internal Reference]  
PowerShell script for link validation.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "05-validation-and-quality-assurance.md"
  series: "Technical Documentation Excellence"
  series_position: 6
  total_articles: 8
  prerequisites:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
    - "04-code-documentation-excellence.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "06-citations-and-reference-management.md"
    - "07-ai-enhanced-documentation-writing.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
