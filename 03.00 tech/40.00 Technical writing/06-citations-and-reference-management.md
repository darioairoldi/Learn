---
# Quarto Metadata
title: "Citations and Reference Management"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, citations, references, source-evaluation, link-management]
description: "Master technical citation practices through source evaluation frameworks, reference classification systems, citation formatting, and strategies for preventing link rot"
---

# Citations and Reference Management

> Build documentation credibility through proper source evaluation, consistent citation practices, and sustainable reference management

## Table of Contents

- [Introduction](#introduction)
- [Why Citations Matter in Technical Writing](#why-citations-matter-in-technical-writing)
- [Source Evaluation Frameworks](#source-evaluation-frameworks)
- [The Reference Classification System](#the-reference-classification-system)
- [Citation Formatting](#citation-formatting)
- [Managing References Over Time](#managing-references-over-time)
- [Preventing Link Rot](#preventing-link-rot)
- [Wikipedia's Approach to Sources](#wikipedias-approach-to-sources)
- [Applying Citations to This Repository](#applying-citations-to-this-repository)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Citations in technical documentation serve different purposes than academic citations. They establish credibility, enable verification, and help readers find additional resources—but they must be practical for the technical writing context.

This article covers:

- **Source evaluation** - How to assess whether a source is reliable
- **Reference classification** - The 📘📗📒📕 system explained
- **Citation formatting** - Consistent presentation of references
- **Link management** - Preventing references from becoming invalid
- **Wikipedia's model** - Lessons from the world's largest reference work

**Prerequisites:** Understanding of [validation principles](05-validation-and-quality-assurance.md) helps contextualize reference validation.

## Why Citations Matter in Technical Writing

### The Purposes of Technical Citations

**1. Establishing authority**
> "This approach is recommended by the [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines) 📘 [Official]"

Readers trust claims backed by recognized authorities more than unsupported assertions.

**2. Enabling verification**
> "The Flesch Reading Ease formula calculates... [source](url)"

Technical readers may want to verify claims. Citations make verification possible.

**3. Providing depth**
> "For complete coverage of OAuth 2.0, see [RFC 6749](https://tools.ietf.org/html/rfc6749) 📘 [Official]"

Citations let you reference comprehensive sources without duplicating their content.

**4. Acknowledging sources**
> "This article's structure follows the [Diátaxis framework](https://diataxis.fr/) 📗 [Verified Community]"

Proper attribution is ethical and helps readers understand influences.

**5. Supporting currency**
> "As of Python 3.11 ([release notes](https://docs.python.org/3/whatsnew/3.11.html)), performance improved..."

Dated references help readers assess whether information is current.

### When to Cite

**Always cite:**
- Direct quotes
- Statistics and measurements
- Specific claims about products or services
- Recommendations attributed to organizations
- Technical specifications

**Consider citing:**
- Best practices (if attributed)
- Design patterns (original sources)
- Algorithms (foundational papers)

**Usually don't need to cite:**
- Common knowledge in the field
- Your own original analysis
- Basic syntax from official documentation (implicit)

## Source Evaluation Frameworks

Not all sources are equally reliable. Evaluation frameworks help you assess source quality.

### The <mark>CRAAP Test</mark>

The CRAAP test (California State University, Chico) evaluates sources on five criteria:

**<mark>C - Currency</mark>**
- When was the information published or updated?
- Is the information current for the topic?
- Are links functional?

*Technical relevance:* Technology changes rapidly. A 2020 article about React hooks may be outdated; a 2020 article about HTTP fundamentals is likely still accurate.

**<mark>R - Relevance</mark>**
- Does the information address your topic?
- Is it appropriate for your audience?
- Have you considered multiple sources?

*Technical relevance:* A beginner tutorial may be relevant for your beginner audience but not for advanced users.

**<mark>A - Authority</mark>**
- Who created the information?
- What are their credentials?
- Is there organizational backing?

*Technical relevance:* Microsoft documenting Azure > random blog documenting Azure. But recognized community experts can also be authoritative.

**<mark>A - Accuracy</mark>**
- Is the information supported by evidence?
- Can you verify claims independently?
- Has it been reviewed or edited?

*Technical relevance:* Can you run the code examples? Do the API calls work? Does the configuration produce described results?

**<mark>P - Purpose</mark>**
- What is the creator's intention?
- Is it to inform, teach, sell, or persuade?
- Are biases acknowledged?

*Technical relevance:* Vendor documentation may be accurate but biased toward their product. Community content may be more objective but less authoritative.

### Applying CRAAP to Technical Sources

| Source Type | Currency | Authority | Accuracy | Typical Rating |
|-------------|----------|-----------|----------|----------------|
| Official vendor docs | Usually current | High | Verifiable | 📘 Official |
| RFC/Standards | Dated but canonical | Highest | Defined by spec | 📘 Official |
| GitHub repositories | Variable | Depends on maintainer | Code is testable | 📗-📒 Variable |
| Stack Overflow | Variable | Community-voted | Community-verified | 📒 Community |
| Personal blogs | Variable | Individual | Variable | 📒 Community |
| Medium articles | Variable | Unknown | Unverified | 📒-📕 Varies |

### The SIFT Method

For quick evaluation, SIFT provides a faster framework:

**<mark>S - Stop</mark>**
Before using a source, pause. Don't assume it's reliable.

**<mark>I - Investigate the source</mark>**
Who published this? What's their reputation?

**<mark>F - Find better coverage</mark>**
Are there more authoritative sources for this claim?

**<mark>T - Trace claims to original</mark>**
Where did this information originally come from?

## The Reference Classification System

This repository uses a four-tier classification system to indicate source reliability at a glance.

### The Four Tiers

**📘 Official**
Primary sources with institutional authority.

*Includes:*
- `*.microsoft.com` and `learn.microsoft.com`
- `docs.github.com`
- Vendor official documentation
- RFC documents
- W3C specifications
- IEEE/ACM publications

*Reader interpretation:* "This is the authoritative source."

**📗 Verified Community**
Reviewed secondary sources with established credibility.

*Includes:*
- `github.blog`
- `devblogs.microsoft.com`
- Recognized technical publications (Ars Technica, The Register)
- Well-known expert blogs (Martin Fowler, Julia Evans)
- Academic papers
- Conference proceedings

*Reader interpretation:* "This is well-vetted and trustworthy."

**📒 Community**
Unreviewed community contributions.

*Includes:*
- `medium.com` articles
- `dev.to` posts
- Personal blogs
- Stack Overflow answers
- Forum posts
- Tutorial sites

*Reader interpretation:* "Useful but verify independently."

**📕 Unverified**
Sources that need attention.

*Includes:*
- Broken links
- Unknown sources
- Sources that fail CRAAP test
- Content without clear authorship

*Reader interpretation:* "This reference needs fixing before publication."

### Classification Decision Tree

```
Is the source from the product/service vendor?
├─ Yes → Is it official documentation?
│   ├─ Yes → 📘 Official
│   └─ No → 📗 Verified Community (vendor blog)
└─ No → Is it from a recognized institution/expert?
    ├─ Yes → 📗 Verified Community
    └─ No → Is the author identifiable?
        ├─ Yes → 📒 Community
        └─ No → 📕 Unverified (investigate further)
```

### Edge Cases

**GitHub repositories:**
- Official org repos (microsoft/*, google/*) → 📘 Official
- Widely-used community repos (1000+ stars) → 📗 Verified
- Personal repos → 📒 Community

**Medium articles:**
- From official publications (Netflix Tech Blog) → 📗 Verified
- From recognized experts → 📗 Verified
- From unknown authors → 📒 Community

**YouTube videos:**
- Official channels (Microsoft Developer) → 📘 Official
- Recognized educators (Fireship, Traversy Media) → 📗 Verified
- Unknown creators → 📒 Community

## Citation Formatting

Consistent citation formatting aids readability and enables automation.

### This Repository's Format

**Inline citation (brief):**
```markdown
...as recommended by the [Microsoft Style Guide](url) 📘 [Official].
```

**Reference list entry (full):**
```markdown
**[Full Title](url)** 📘 [Official]  
Brief description explaining the resource's relevance and value.
```

### Format Components

**1. Title as link**
- Use the actual title of the resource
- Link to the primary URL
- Don't use "click here" or "this article"

**2. Classification marker**
- Emoji first: 📘, 📗, 📒, or 📕
- Text label in brackets: [Official], [Verified Community], [Community], [Unverified]

**3. Description (reference lists)**
- One to two sentences
- Explain why this source is relevant
- Note any limitations or context

### Examples

**Good reference entries:**

```markdown
**[Keep a Changelog](https://keepachangelog.com/en/1.0.0/)** 📗 [Verified Community]  
De facto standard for changelog formatting. Provides templates and reasoning for changelog structure.

**[RFC 7231 - HTTP/1.1 Semantics](https://tools.ietf.org/html/rfc7231)** 📘 [Official]  
IETF standard defining HTTP methods, status codes, and headers. Canonical reference for HTTP behavior.

**[Understanding Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)** 📒 [Community]  
Popular visual guide to CSS Flexbox. Note: Check for updates as CSS evolves.
```

**Bad reference entries:**

```markdown
[Link](url) - vague title, no classification

**Some Article** 📘 - no link, no description

**[Great Resource](url)**  
This is a really great resource that you should definitely read because it's very helpful and informative and I learned a lot from it. - too long, not informative
```

### Citation Density

**How many citations is enough?**

- **Claims page:** Heavy citation (support each claim)
- **Tutorial:** Light citation (readers need to do, not verify)
- **Reference:** Moderate (link to related resources)
- **How-to:** Light to moderate (cite prerequisites, alternatives)

**Guideline:** Cite enough to establish credibility without disrupting readability. If every sentence has a citation, consider whether you're adding value or just aggregating sources.

## Managing References Over Time

References require maintenance. Links break, content changes, better sources emerge.

### Reference Lifecycle

```
Discovery → Evaluation → Citation → Monitoring → Update/Replace
```

**Discovery:** Finding potential sources during research
**Evaluation:** Assessing with CRAAP/SIFT, assigning classification
**Citation:** Formatting and placing in document
**Monitoring:** Checking link validity and content currency
**Update/Replace:** Fixing broken links, finding better sources

### Reference Inventory

Maintain awareness of references in your documentation:

**Per-document tracking:**
- Count of references by classification
- List of URLs for link checking
- Date of last reference review

**Site-wide tracking:**
- Total external links
- Broken link count
- References pending review (📕)

### Update Triggers

**Review references when:**
- Product version changes (your product or referenced product)
- Reader reports broken link
- Scheduled review (quarterly recommended)
- Major industry changes

## Preventing Link Rot

Link rot—URLs that no longer work—undermines documentation credibility.

### Link Rot Statistics

Studies suggest:
- ~38% of links break within 6 years
- Shorter URLs are slightly more stable
- .gov and .edu domains are more stable than .com

### Prevention Strategies

**1. Prefer stable URLs**
- Official documentation URLs over blog posts
- Permalinks over dated URLs when available
- Canonical URLs over redirected URLs

**2. Use archived versions**
- Internet Archive (archive.org) for backup
- Link to archived version alongside live version
- Archive important pages proactively

```markdown
**[Original Article](https://example.com/article)** | [Archived](https://web.archive.org/web/20260114/https://example.com/article) 📗 [Verified]
```

**3. Local backups**
- For critical references, keep local copies
- Note: Respect copyright; use for reference only
- Document retrieval date

**4. Prefer DOIs and stable identifiers**
- Academic papers: Use DOI links
- Standards: Use canonical identifiers
- Example: `https://doi.org/10.1145/12345` vs. conference website

**5. Automated monitoring**
- Regular link checking (weekly/monthly)
- Alerts for broken links
- Repository uses: [check-links.ps1](../../scripts/check-links.ps1)

### When Links Break

**Immediate actions:**
1. Mark as 📕 [Unverified]
2. Search for new URL (content may have moved)
3. Check Internet Archive for cached version
4. Find alternative source if unavailable

**Document the situation:**
```markdown
**[Original Title](broken-url)** 📕 [Unverified - Link broken as of 2026-01-14]  
[Archived version](archive-url) available. Seeking current source.
```

## Wikipedia's Approach to Sources

Wikipedia has developed sophisticated source practices worth studying.

### Wikipedia's Source Categories

**Primary sources:** Direct evidence (original research, datasets)
- Acceptable for basic facts
- Should be interpreted by secondary sources

**Secondary sources:** Analysis of primary sources
- Preferred for most content
- Provide context and interpretation

**Tertiary sources:** Compilations (encyclopedias, textbooks)
- Useful for basic information
- Don't cite Wikipedia from Wikipedia

### Wikipedia's Reliability Guidelines

From [Wikipedia:Reliable sources](https://en.wikipedia.org/wiki/Wikipedia:Reliable_sources):

**Generally reliable:**
- Major news organizations
- Academic journals
- University press publications
- Government publications

**Generally unreliable:**
- Self-published sources (with exceptions for recognized experts)
- User-generated content
- Sources with clear bias
- Anonymous sources

**Evaluate individually:**
- Blog posts (depends on author)
- Conference papers (depends on venue)
- Preprints (may not be peer-reviewed)

### Wikipedia's Citation Templates

Wikipedia uses structured citation templates:

```
{{cite web
 | url = https://example.com/article
 | title = Article Title
 | author = Author Name
 | date = 2026-01-14
 | access-date = 2026-01-15
 | publisher = Publisher Name
}}
```

**Key fields:**
- `url` - Resource location
- `title` - Resource title
- `author` - Creator attribution
- `date` - Publication date
- `access-date` - When you accessed it (for web sources)
- `publisher` - Publishing organization

**Adaptation for technical docs:**
```markdown
**[Article Title](url)** 📗 [Verified Community]  
By Author Name, Publisher Name, 2026-01-14. Accessed 2026-01-15.
Description of relevance.
```

### Lessons from Wikipedia

1. **Classification aids trust** - Readers should know source quality at a glance
2. **Prefer secondary sources** - Analysis and interpretation add value
3. **Date everything** - Publication and access dates matter
4. **Dead links happen** - Have a strategy for broken links
5. **Anyone can edit** - Build verification into your process

## Applying Citations to This Repository

### Reference Standards

From [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):

**Required for all articles:**
- References section at end
- All external links classified with 📘📗📒📕
- No 📕 markers in published content
- Descriptive link text (not "click here")

**Reference section format:**
```markdown
## References

### Category Name

**[Title](url)** 📘 [Official]  
Description.

**[Title](url)** 📗 [Verified Community]  
Description.
```

### Validation Integration

Reference validation is part of the seven validation dimensions:

**Reference checks:**
1. All external links have classification markers
2. Classification matches source type
3. Links resolve correctly
4. Descriptions are meaningful
5. No unverified sources in published content

### Common Reference Patterns in This Repository

**Microsoft documentation:**
```markdown
**[Microsoft Learn: Topic](https://learn.microsoft.com/...)** 📘 [Official]
```

**GitHub documentation:**
```markdown
**[GitHub Docs: Feature](https://docs.github.com/...)** 📘 [Official]
```

**Community guides:**
```markdown
**[Write the Docs: Guide](https://www.writethedocs.org/...)** 📗 [Verified Community]
```

**Framework documentation:**
```markdown
**[Diátaxis](https://diataxis.fr/)** 📗 [Verified Community]
```

### Reference Maintenance Workflow

1. **During writing:** Add references with classification
2. **Before review:** Verify all links work
3. **During validation:** Check classification accuracy
4. **Monthly:** Run link checker site-wide
5. **On broken link:** Update or archive immediately

## Conclusion

Citations build documentation credibility. Key principles:

**Evaluate sources systematically** - Use CRAAP or SIFT to assess reliability before citing

**Classify for reader trust** - The 📘📗📒📕 system communicates source quality at a glance

**Format consistently** - Standard formatting aids readability and enables automation

**Plan for maintenance** - Links break; have monitoring and recovery strategies

**Learn from Wikipedia** - The world's largest reference work offers tested practices

**Match citation density to purpose** - Heavy for claims, light for tutorials

**Next in series:**

- [07-ai-enhanced-documentation-writing.md](07-ai-enhanced-documentation-writing.md) - AI assistance in reference discovery and validation
- [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) - Reference validation context
- [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) - How references support Diátaxis types

## References

### Source Evaluation

**[CRAAP Test](https://libguides.csuchico.edu/c.php?g=414315&p=2822716)** 📘 [Official]  
California State University, Chico's source evaluation framework. Original source of the CRAAP criteria.

**[SIFT Method - Mike Caulfield](https://hapgood.us/2019/06/19/sift-the-four-moves/)** 📗 [Verified Community]  
Quick source evaluation method by digital literacy expert. Practical alternative to CRAAP.

**[Wikipedia: Reliable Sources](https://en.wikipedia.org/wiki/Wikipedia:Reliable_sources)** 📘 [Official]  
Wikipedia's comprehensive guidance on evaluating source reliability.

**[Wikipedia: Identifying Reliable Sources](https://en.wikipedia.org/wiki/Wikipedia:Identifying_reliable_sources)** 📘 [Official]  
Decision guidance for classifying source reliability.

### Citation Practices

**[Wikipedia: Citing Sources](https://en.wikipedia.org/wiki/Wikipedia:Citing_sources)** 📘 [Official]  
Wikipedia's citation standards and practices.

**[APA Style - References](https://apastyle.apa.org/style-grammar-guidelines/references)** 📘 [Official]  
American Psychological Association reference formatting (academic standard).

**[Google Developer Documentation - Link Text](https://developers.google.com/style/link-text)** 📘 [Official]  
Google's guidance on writing effective link text.

### Link Management

**[Web Archive (Internet Archive)](https://archive.org/web/)** 📘 [Official]  
Primary resource for archived web content. Use for broken link recovery.

**[Perma.cc](https://perma.cc/)** 📗 [Verified Community]  
Harvard Library's link preservation service. Creates permanent archives of web pages.

**[DOI Foundation](https://www.doi.org/)** 📘 [Official]  
Digital Object Identifier system for permanent content identification.

### Reference Management Tools

**[Zotero](https://www.zotero.org/)** 📗 [Verified Community]  
Open-source reference management software. Useful for tracking sources during research.

**[markdown-link-check](https://github.com/tcort/markdown-link-check)** 📗 [Verified Community]  
Tool for validating markdown links. Useful for reference maintenance.

### Repository-Specific Documentation

**[Documentation Instructions - References](../../.github/instructions/documentation.instructions.md)** [Internal Reference]  
This repository's reference formatting standards.

**[Link Check Script](../../scripts/check-links.ps1)** [Internal Reference]  
PowerShell script for validating links across the repository.

**[Validation Criteria - References](../../.copilot/context/01.00%20article-writing/02-validation-criteria.md)** [Internal Reference]  
Reference validation dimension details.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "06-citations-and-reference-management.md"
  series: "Technical Documentation Excellence"
  series_position: 7
  total_articles: 8
  prerequisites:
    - "05-validation-and-quality-assurance.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "03-accessibility-in-technical-writing.md"
    - "05-validation-and-quality-assurance.md"
    - "07-ai-enhanced-documentation-writing.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
