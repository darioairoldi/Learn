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

- [🎯 Introduction](#-introduction)
- [🏗️ Validation frameworks](#-validation-frameworks)
- [📏 The seven validation dimensions](#-the-seven-validation-dimensions)
- [👥 Review processes](#-review-processes)
- [📊 Quality metrics](#-quality-metrics)
- [🤖 Automated validation](#-automated-validation)
- [🛠️ Documentation tooling ecosystem](#-documentation-tooling-ecosystem)
- [🧪 Documentation testing](#-documentation-testing)
- [📈 Metrics dashboard](#-metrics-dashboard)
- [🔄 Continuous improvement](#-continuous-improvement)
- [📌 Applying validation to this repository](#-applying-validation-to-this-repository)
- [✅ Conclusion](#-conclusion)
- [📚 References](#-references)

## 🎯 Introduction

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

## 🏗️ Validation frameworks

Different organizations approach documentation validation differently. Understanding multiple frameworks helps you build the right approach for your context.

### The documentation quality triangle

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

#### Reconciling the Quality Triangle with quality criteria

The Quality Triangle captures the fundamental *tensions* in documentation quality—you can't maximize all three vertices simultaneously. But the triangle is intentionally simplified. [Article 00](00-foundations-of-technical-documentation.md) defines six more granular quality criteria (Findability, Understandability, Actionability, Accuracy, Consistency, Completeness) that map into the triangle's three vertices:

| Triangle vertex | Maps to quality criteria | What it covers |
|----------------|--------------------------|----------------|
| **Accuracy** | Accuracy | Correct, current, version-specific information |
| **Clarity** | Understandability, Findability | Readers can comprehend and locate the information they need |
| **Completeness** | Completeness, Actionability, Consistency | Information is sufficient, procedures work end-to-end, and patterns are predictable |

**The relationship is hierarchical:**

1. The **Quality Triangle** shows the high-level trade-offs (useful for prioritization decisions)
2. Art. 00's **six quality criteria** decompose the triangle into assessable attributes (useful for quality reviews)
3. This article's **seven validation dimensions** operationalize the criteria into automated and manual checks (useful for validation workflows)

The [reconciliation table in Art. 00](00-foundations-of-technical-documentation.md#reconciling-quality-criteria-with-validation-dimensions) maps all six criteria to the seven validation dimensions, completing the chain from abstract tensions to concrete checks.

> **On deliberate overlap with Article 00:** [Article 00](00-foundations-of-technical-documentation.md) *defines* the six quality criteria and maps them to validation dimensions (definition level). This article introduces the Quality Triangle and *operationalizes* the criteria into automated and manual checks (application level). Both perspectives are intentional—the three-level hierarchy (Triangle → criteria → dimensions) requires coverage in both articles. See [Article 08](08-consistency-standards-and-enforcement.md#acceptable-redundancy-across-articles) for the series redundancy policy.

### Wikipedia's good article criteria

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

### Google's QUAC framework

Google uses QUAC for documentation quality:

- **Quality** - Technical accuracy and completeness
- **Usability** - Can users accomplish their goals?
- **Accessibility** - Works for all users
- **Consistency** - Follows established patterns

### Microsoft's five pillars

Microsoft documentation emphasizes:

1. **Accuracy** - Technically correct
2. **Completeness** - All information present
3. **Clarity** - Understandable writing
4. **Task orientation** - Helps users accomplish goals
5. **Consistency** - Follows style guide

## 📏 The seven validation dimensions

This repository uses seven validation dimensions, documented in [validation-criteria.md](../../.copilot/context/01.00-article-writing/02-validation-criteria.md).

### Dimension 1: grammar

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

### Dimension 2: readability

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

### Dimension 3: structure

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

### Dimension 4: fact accuracy

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

### Dimension 5: logical coherence

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

### Dimension 6: coverage

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

### Dimension 7: references

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

## 👥 Review processes

Automated validation catches mechanical issues. Human review catches conceptual issues, audience mismatches, and subtle errors.

### Types of documentation review

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

### Review checklist

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

### Review feedback guidelines

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

## 📊 Quality metrics

Metrics make quality visible and improvable over time.

### Quantitative metrics

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

### Qualitative metrics

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

### Metric targets for this repository

From [validation-criteria.md](../../.copilot/context/01.00-article-writing/02-validation-criteria.md):

| Metric | Target | Measurement |
|--------|--------|-------------|
| Flesch Reading Ease | 50-70 | Per article |
| Flesch-Kincaid Grade | 9-10 | Per article |
| Active Voice | 75-85% | Per article |
| Sentence Length | 15-25 words | Average per article |
| Link Validity | 100% | Site-wide |
| Reference Classification | 100% classified | Per article |

## 🤖 Automated validation

Automation scales validation and provides consistency.

### What to automate

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

### Validation tools

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

### Implementing validation pipeline

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

### IQPilot validation tools

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

## 🛠️ Documentation tooling ecosystem

The validation tools above are part of a broader <mark>docs-as-code</mark> approach where documentation follows the same workflows as software: version control, pull requests, automated checks, and continuous deployment.

### The docs-as-code philosophy

<mark>Docs-as-code</mark> treats documentation as a first-class engineering artifact:

| Principle | Software equivalent | Documentation practice |
|-----------|---------------------|----------------------|
| **Version control** | Git branching | Documentation in the same repository as code, full change history |
| **Code review** | Pull requests | Documentation changes reviewed before merge |
| **Automated testing** | CI/CD pipelines | Linting, link checking, build validation on every commit |
| **Continuous deployment** | CD to production | Automated site builds on merge to main |
| **Issue tracking** | Bug reports | Documentation gaps tracked alongside code bugs |

**Benefits over traditional documentation tools:**
- **Collaboration** — Multiple contributors work in parallel via branching
- **Traceability** — Every change has an author, timestamp, and rationale
- **Quality gates** — Automated checks prevent regression before merge
- **Single source of truth** — Documentation lives next to the code it describes

### Static site generators comparison

Choosing the right rendering tool affects authoring experience, output quality, and workflow integration:

| Generator | Language | Strengths | Best for |
|-----------|----------|-----------|----------|
| **<mark>Quarto</mark>** | R/Python/Julia | Computational notebooks, scientific publishing, cross-format output (HTML, PDF, EPUB) | Technical content with embedded code, data-driven docs |
| **MkDocs** (Material) | Python | Clean themes, search, navigation plugins | Developer-facing documentation sites |
| **Docusaurus** | JavaScript | React integration, versioning, i18n built-in | Open-source project documentation |
| **Hugo** | Go | Fastest build times, flexible templating | Large sites needing fast builds |
| **Sphinx** | Python | Cross-referencing, API doc generation (autodoc), PDF output | Python library documentation |
| **Jekyll** | Ruby | GitHub Pages native, large ecosystem | Simple blogs and project pages |

**This repository uses Quarto** because it supports Markdown and QMD files, produces clean HTML for GitHub Pages, enables computational content, and integrates well with a validation-focused workflow. See [01.01-introduction-to-quarto.md](../20.01-markdown/01.%20QUARTO%20Doc/01.01-introduction-to-quarto.md) for the full Quarto setup.

### End-to-end documentation workflow

A complete docs-as-code pipeline integrates authoring, validation, and publishing:

```
Author → Commit → PR → Automated checks → Review → Merge → Build → Deploy
  │                        │                  │              │
  ├─ Write in Markdown     ├─ Lint (Vale)     ├─ Human SME   ├─ SSG renders
  ├─ Use templates         ├─ Link check      │  review      ├─ Deploy to
  └─ Follow style guide    ├─ Build test      └─ Style check │  GitHub Pages
                           └─ Readability                    └─ Invalidate cache
                              scoring
```

**Key integration points:**
1. **Pre-commit hooks** — Run fast checks (spelling, formatting) before code leaves the developer's machine
2. **CI pipeline** — Run comprehensive checks (validation dimensions, link verification, build) on every pull request
3. **Merge gates** — Require passing checks and reviewer approval before documentation changes merge
4. **Deployment triggers** — Automatically rebuild and publish the site when the main branch updates

### Collaborative authoring patterns

Scaling documentation beyond a single author requires explicit patterns:

**<mark>Ownership model:</mark>** Assign each document or section a primary owner responsible for accuracy and currency. See [10-documentation-lifecycle-and-maintenance.md](10-documentation-lifecycle-and-maintenance.md) for ownership frameworks.

**<mark>Branching strategy:</mark>** Use feature branches for new content and short-lived branches for fixes. Keep documentation branches aligned with code feature branches when documenting new features.

**<mark>Review workflow:</mark>** Documentation pull requests should include:
- A subject-matter expert reviewer (technical accuracy)
- A style reviewer (consistency and readability)
- Automated validation passing (minimum quality gate)

**<mark>Conflict resolution:</mark>** When style decisions conflict between contributors, record the decision in a style decision log (see [08-consistency-standards-and-enforcement.md](08-consistency-standards-and-enforcement.md)) to prevent recurring debates.

**For more on tooling integration with consistency enforcement:** See [Article 08](08-consistency-standards-and-enforcement.md) for Vale configuration, markdownlint setup, and automated style enforcement patterns.

## 🧪 Documentation testing

Validation checks whether documentation meets defined standards. <mark>Documentation testing</mark> goes further—it verifies that documentation actually *works* for its intended audience. Testing answers the question: "Can real users accomplish their goals using this documentation?"

### The validation-testing distinction

The distinction is critical:

| Aspect | Validation | Testing |
|--------|-----------|---------|
| **Question asked** | "Does this meet our standards?" | "Does this work for users?" |
| **Evaluator** | Automated tools, reviewers | Target audience representatives |
| **Measures** | Compliance with rules | Task success, comprehension, findability |
| **When to use** | Every commit, every review | Before major releases, after significant changes |
| **Cost** | Low (automated) to medium (review) | Medium to high (requires participants) |

Both are necessary. A document can pass all seven [validation dimensions](#-the-seven-validation-dimensions) and still confuse users if its mental model doesn't match theirs.

### Smoke testing

<mark>Smoke testing</mark> for docs is the fastest verification—a quick pass to catch obvious problems before deeper testing:

**Smoke test checklist:**
- [ ] All code examples compile or run without errors
- [ ] All links resolve (no 404s)
- [ ] Screenshots match the current UI
- [ ] The documented procedure still produces the expected outcome
- [ ] Prerequisites are still accurate and available

**When to smoke test:** After every product update, dependency upgrade, or UI change. Automate what you can (link checking, build validation) and manually verify the rest.

### Task-completion testing

<mark>Task-completion testing</mark> measures whether users can accomplish specific goals using your documentation:

**Process:**
1. **Define tasks** — Concrete, measurable activities (e.g., "Deploy your first Azure Function using this guide")
2. **Recruit participants** — 3–5 users matching your target audience
3. **Observe without helping** — Watch participants follow the documentation
4. **Record outcomes** — Task success rate, time-on-task, errors encountered, questions asked

**Metrics:**

| Metric | Target | What it reveals |
|--------|--------|----------------|
| **Task completion rate** | > 80% | Whether instructions actually work |
| **Time-on-task** | Within 2× expected time | Whether instructions are efficient |
| **Error rate** | < 2 errors per task | Where instructions are ambiguous |
| **Assistance requests** | 0 | Where documentation has gaps |

**For comprehensive methodology**, including cloze tests, recall tests, think-aloud protocols, and information scent analysis, see [Article 09: Measuring Readability and Comprehension](09-measuring-readability-and-comprehension.md).

### Heuristic evaluation

<mark>Heuristic evaluation</mark> uses expert reviewers (not end users) to identify usability problems against a set of documentation quality principles:

**Ten documentation heuristics:**

1. **Visibility of system state** — Does the documentation show where you are in a process?
2. **Match with mental models** — Does the structure match how users think about the topic?
3. **User control** — Can readers navigate freely, skip known content, and backtrack?
4. **Consistency** — Are terms, formatting, and patterns used uniformly?
5. **Error prevention** — Does the documentation warn about common mistakes before they happen?
6. **Recognition over recall** — Are key terms, commands, and parameters visible when needed (not buried earlier)?
7. **Flexibility** — Does it serve both novice and experienced users?
8. **Minimalism** — Is every section earning its place? No filler?
9. **Error recovery** — When users encounter problems, does the documentation help them recover?
10. **Help and orientation** — Are there sufficient cross-references, TOCs, and navigation aids?

**Process:** Two to three evaluators independently rate documentation against each heuristic (scale of 1–5), then compare notes. Focus remediation on heuristics where evaluators agree the score is low.

### Integration into the validation workflow

Documentation testing fits into the broader quality workflow at specific trigger points:

| Trigger | Test type | Depth |
|---------|-----------|-------|
| **Every commit** | Smoke test (automated portion) | Links, builds, linting |
| **Pre-publication** | Full smoke test + heuristic evaluation | Manual verification of examples and procedures |
| **Major release** | Task-completion testing with users | 3–5 participants, 3–5 core tasks |
| **Quarterly review** | Heuristic evaluation + metrics review | Expert assessment against documentation heuristics |
| **User feedback spike** | Targeted task-completion testing | Focused on problematic areas |

## 📈 Metrics dashboard

Individual metrics (covered in [Quality metrics](#-quality-metrics)) become actionable only when you can see them together, track trends over time, and connect them to decisions. A <mark>metrics dashboard</mark> transforms scattered measurements into a unified quality view.

### Dashboard design principles

**Effective documentation dashboards follow four principles:**

1. **Actionable over comprehensive** — Show metrics that drive decisions, not everything you can measure
2. **Trends over snapshots** — A single readability score is less useful than a 6-month trend line
3. **Thresholds over raw numbers** — Color-code metrics as green/yellow/red against targets
4. **Grouped by audience** — Authors need different views than managers need

### Key metrics to track

The following metrics bring together measurements from across the validation framework:

| Category | Metric | Source | Target | Frequency |
|----------|--------|--------|--------|-----------|
| **Readability** | Flesch Reading Ease (avg) | textstat, IQPilot | 50–70 | Per article |
| **Readability** | FK Grade Level (avg) | textstat, IQPilot | 9–10 | Per article |
| **Structure** | Validation pass rate | IQPilot structure check | 100% | Per commit |
| **Currency** | Articles updated in last 90 days | Git history | > 80% | Monthly |
| **Currency** | Average document age (days) | Article metadata | < 180 | Monthly |
| **Links** | Link validity rate | check-links.ps1 | 100% | Weekly |
| **References** | Classification coverage | Manual or IQPilot | 100% | Per article |
| **Coverage** | Articles with all 7 dimensions validated | Validation metadata | 100% | Monthly |
| **Review** | Average review cycle time (days) | PR history | < 5 | Monthly |
| **Testing** | Last smoke test date | Test log | < 30 days | Monthly |

### Example dashboard layout

```
┌─────────────────────────────────────────────────────────────┐
│                  Documentation Quality Dashboard            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Overall Health: ██████████░░ 83%   Articles: 13/13 current │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Readability  │  │  Structure   │  │   Currency   │      │
│  │   🟢 62.3    │  │   🟢 100%    │  │   🟡 77%     │      │
│  │  (target 60) │  │  (all pass)  │  │ (target 80%) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Links     │  │  References  │  │   Testing    │      │
│  │   🟢 100%    │  │   🟢 100%    │  │   🔴 45 days │      │
│  │  (all valid) │  │ (classified) │  │ (target <30) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                             │
│  Trend: Readability ────────/──── ↑ improving               │
│  Trend: Currency   ──────\────── ↓ needs attention          │
│                                                             │
│  Action items: 3 articles need readability review           │
│                2 articles have stale links                  │
│                Smoke test overdue by 15 days                │
└─────────────────────────────────────────────────────────────┘
```

### Building your dashboard

**For small teams (this repository's approach):**

Use a simple script that aggregates validation metadata from article HTML comments:

```powershell
# scripts/quality-dashboard.ps1
# Aggregate validation metadata across all articles

$articles = Get-ChildItem -Path "03.00-tech/40.00-technical-writing/" -Filter "*.md"

foreach ($article in $articles) {
    $content = Get-Content $article.FullName -Raw
    
    # Extract validation metadata from bottom HTML comment
    if ($content -match '(?s)<!--(.+?)-->') {
        $metadata = $Matches[1]
        # Parse and aggregate metrics
    }
}

# Output summary table
$results | Format-Table Article, Readability, Structure, Currency, Links -AutoSize
```

**For larger teams:** Consider dedicated tools:

| Tool | Strengths | Best for |
|------|-----------|----------|
| **Grafana + Prometheus** | Time-series visualization, alerting | Teams already using Grafana for infrastructure monitoring |
| **Power BI** | Rich visualizations, data modeling | Microsoft-ecosystem teams |
| **Custom Markdown report** | No extra infrastructure, version-controlled | Small teams, open-source projects |
| **GitHub Actions summary** | Integrated with CI/CD, no separate tool | Teams using GitHub for documentation |

### Connecting metrics to action

Metrics without action are decoration. Define clear escalation rules:

| Condition | Action | Owner |
|-----------|--------|-------|
| Readability score drops below 50 | Flag for readability review | Article author |
| Link validity drops below 95% | Run link fix script immediately | Repository maintainer |
| Article not updated in 180+ days | Add to quarterly freshness review | Content owner |
| Validation pass rate drops below 90% | Block merge until resolved | CI/CD pipeline |
| Smoke test overdue by 30+ days | Schedule testing session | QA reviewer |

## 🔄 Continuous improvement

Quality isn't a destination—it's a process.

### The quality improvement cycle

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

### Documentation debt

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

### Validation-driven workflows

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

## 📌 Applying validation to this repository

### Validation metadata system

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

### Validation prompts

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

### Validation caching

IQPilot caches validation results to avoid redundant processing:

- **Cache duration:** 7 days (configurable)
- **Cache invalidation:** Content changes
- **Cache key:** File path + content hash

**Rationale:** Validation (especially AI-powered) can be expensive. Caching reduces costs while maintaining freshness.

### Reference validation

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

## ✅ Conclusion

Documentation validation transforms quality from aspiration to achievement. Systematic validation across multiple dimensions ensures documentation meets and maintains high standards.

### Key takeaways

- **Multiple dimensions matter** — Grammar, readability, structure, accuracy, coherence, coverage, and references each contribute to quality
- **Combine automation with human review** — Automation catches mechanical issues; humans catch conceptual issues
- **Measure to improve** — Metrics make quality visible and enable targeted improvement
- **Build validation into workflow** — Validate before publishing, monitor after publishing
- **Adopt docs-as-code** — Version control, pull requests, automated checks, and continuous deployment for documentation
- **Treat documentation debt seriously** — Track and address quality gaps systematically
- **Use frameworks as a hierarchy** — The Quality Triangle shows trade-offs, Art. 00's six criteria decompose them, and this article's seven dimensions operationalize them into checks

### Next steps

- **Next article:** [06-citations-and-reference-management.md](06-citations-and-reference-management.md) — Deep dive into reference validation
- **Related:** [07-ai-enhanced-documentation-writing.md](07-ai-enhanced-documentation-writing.md) — AI-powered validation approaches
- **Related:** [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) — Readability principles

## 📚 References

### Quality frameworks

**[Wikipedia Good Article Criteria](https://en.wikipedia.org/wiki/Wikipedia:Good_article_criteria)** 📘 [Official]  
Wikipedia's criteria for quality articles, applicable to documentation quality assessment.

**[Wikipedia Featured Article Criteria](https://en.wikipedia.org/wiki/Wikipedia:Featured_article_criteria)** 📘 [Official]  
Wikipedia's highest quality standard, providing aspirational quality criteria.

**[Google Developer Documentation Style Guide - Quality](https://developers.google.com/style)** 📘 [Official]  
Google's documentation quality standards and guidelines.

**[Microsoft Writing Quality](https://learn.microsoft.com/style-guide/top-10-tips-style-voice)** 📘 [Official]
Microsoft's quality principles for documentation.

### Validation tools

**[Vale - A Linter for Prose](https://vale.sh/)**📗 [Verified Community]  
Open-source prose linter with customizable rules.

**[LanguageTool](https://languagetool.org/)** 📗 [Verified Community]  
Grammar and style checker supporting multiple languages.

**[textstat (Python)](https://pypi.org/project/textstat/)** 📗 [Verified Community]  
Python library for calculating text readability metrics.

**[markdown-link-check](https://github.com/tcort/markdown-link-check)** 📗 [Verified Community]  
Tool for validating links in markdown files.

### Metrics and measurement

**[Flesch Reading Ease](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)** 📘 [Official]  
Wikipedia's explanation of Flesch readability formulas.

**[Plain Language Action and Information Network](https://www.plainlanguage.gov/guidelines/test/)** 📘 [Official]  
US government guidance on testing document readability.

### Review processes

**[Google Engineering Practices - Code Review](https://google.github.io/eng-practices/review/)** 📘 [Official]  
Google's code review guidelines, applicable to documentation review.

**[Write the Docs - Documentation Review](https://www.writethedocs.org/guide/docs-as-code/)** 📗 [Verified Community]  
Community guidance on documentation review as part of docs-as-code.

### Repository-specific documentation

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
  total_articles: 13
  prerequisites:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
    - "04-code-documentation-excellence.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "06-citations-and-reference-management.md"
    - "07-ai-enhanced-documentation-writing.md"
  version: "1.2"
  last_updated: "2026-02-28"
  changes:
    - "v1.2: Added Documentation Tooling Ecosystem section (docs-as-code philosophy, SSG comparison, end-to-end workflow, collaborative authoring patterns). Updated conclusion with docs-as-code takeaway."
    - "v1.1: Added Quality Triangle reconciliation with Art. 00 quality criteria. Updated conclusion to reflect framework hierarchy."
-->
