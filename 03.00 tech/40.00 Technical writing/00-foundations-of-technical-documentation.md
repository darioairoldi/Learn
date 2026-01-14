---
# Quarto Metadata
title: "Foundations of Technical Documentation"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, documentation, style-guides, best-practices]
description: "Comprehensive guide to technical documentation foundations, exploring authoritative frameworks including Diátaxis, Wikipedia, and major style guides from Microsoft, Google, and Apple"
---

# Foundations of Technical Documentation

> Understanding the principles, frameworks, and decision-making strategies that underpin effective technical documentation across industries and platforms

## Table of Contents

- [Introduction](#introduction)
- [What Makes Documentation "Good"?](#what-makes-documentation-good)
- [The Diátaxis Framework: Four Documentation Types](#the-diataxis-framework-four-documentation-types)
- [Major Style Guides Comparison](#major-style-guides-comparison)
- [Wikipedia's Documentation Model](#wikipedias-documentation-model)
- [Decision Frameworks: When Guidelines Conflict](#decision-frameworks-when-guidelines-conflict)
- [Applying Foundations to This Repository](#applying-foundations-to-this-repository)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Technical documentation exists at the <mark>intersection</mark> of <mark>technology</mark>, <mark>communication</mark>, and <mark>user experience</mark>. Whether you're documenting APIs for developers, writing user guides for enterprise software, or creating knowledge bases for community projects, the fundamental question remains: **what makes documentation effective?**

This article establishes the foundational principles of technical documentation by:

- <mark>Analyzing authoritative frameworks</mark> (<mark>Diátaxis</mark>) that define documentation types
- Comparing major style guides (<mark>Microsoft</mark>, <mark>Google</mark>, <mark>Apple</mark>, <mark>Wikipedia</mark>)
- Identifying <mark>decision-making strategies</mark> when guidelines conflict
- <mark>Bridging theory with the practical implementation</mark> used in this repository

**Prerequisites:** Familiarity with documentation concepts is helpful but not required. This article serves as the foundation for the entire technical writing series.

## What Makes Documentation "Good"?

Before examining specific frameworks and guidelines, we must establish criteria for quality documentation. Drawing from multiple authoritative sources, effective technical documentation exhibits these characteristics:

### <mark>User-Centered Attributes</mark>

**Findability** - Users can locate the <mark>information they need quickly</mark>
- Clear <mark>information architecture</mark>
- Effective <mark>search optimization</mark>
- Logical <mark>navigation hierarchies</mark>

**Understandability** - Content matches the user's knowledge level
- Appropriate <mark>technical depth</mark>
- Clear <mark>explanations of complex concepts</mark>
- <mark>Context provided when needed</mark>

**Actionability** - Users can accomplish their goals
- <mark>Concrete</mark>, <mark>specific</mark> guidance
- <mark>Complete procedures</mark> <mark>without gaps</mark>
- <mark>Working code examples</mark>

### Content Quality Attributes

**Accuracy** - Information is factually correct and current
- <mark>Verified against reliable sources</mark>
- <mark>Regularly updated</mark>
- <mark>Version-specific when relevant</mark>

**Consistency** - <mark>Uniform style</mark>, <mark>terminology</mark>, and <mark>structure</mark>
- <mark>Predictable patterns across documents</mark>
- <mark>Standardized formatting</mark>
- <mark>Coherent voice and tone</mark>

**Completeness** - All necessary information is present
- <mark>Prerequisites identified</mark>
- <mark>Edge cases addressed</mark>
- <mark>Related concepts linked</mark>

> **Note:** This repository's validation system (see [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md)) operationalizes these principles through seven validation dimensions: grammar, readability, structure, facts, logic, understandability, and gaps.

## The Diátaxis Framework: Four Documentation Types

The **<mark>Diátaxis framework** (from Ancient Greek διάταξις: "arrangement") provides a systematic approach to understanding documentation needs.  
Created by <mark>Daniele Procida</mark>, it identifies four distinct documentation types based on two axes:

**Theoretical/Practical Axis:**
- **<mark>Practical</mark>** documentation focuses on doing (hands-on activities)
- **<mark>Theoretical</mark>** documentation focuses on understanding (cognitive activities)

**Study/Work Axis:**
- **<mark>Study</mark>** mode: learning-oriented, acquisition phase
- **<mark>Work</mark>** mode: task-oriented, application phase

This creates four quadrants:

| Mode | Practical | Theoretical |
|------|-----------|-------------|
| **<mark>Study</mark>** | **Tutorials** <br> Learning-oriented <br> Lesson format | **Explanation** <br> Understanding-oriented <br> Discussion format |
| **<mark>Work</mark>** | **How-to Guides** <br> Task-oriented <br> Step-by-step format | **Reference** <br> Information-oriented <br> Description format |

### <mark>Tutorials</mark> (<mark>Learning by Doing</mark>)

**Purpose:** Guide newcomers through their first successful experience

**Characteristics:**
- <mark>Learning-oriented</mark>, not goal-oriented
- Carefully <mark>controlled environment</mark>
- <mark>Immediate</mark>, <mark>visible</mark> <mark>results</mark>
- Build <mark>confidence through success</mark>
- Example: "Your First API Call: A Beginner's Tutorial"

**Key principle from Diátaxis:** "A tutorial is an experience under the control of the teacher."

### <mark>How-to Guides</mark> (<mark>Solving Specific Problems</mark>)

**Purpose:** Direct users to <mark>accomplish specific real-world tasks</mark>

**Characteristics:**
- <mark>Goal-oriented</mark> and <mark>practical</mark>
- <mark>Assume</mark> some <mark>knowledge</mark>
- <mark>Focus on results</mark>, not learning
- <mark>Multiple valid approaches acceptable</mark>
- Example: "How to Authenticate with OAuth 2.0"

**Key principle:** How-to guides <mark>serve work, not study</mark>. They get users from A to B efficiently.

### <mark>Reference</mark> (<mark>Information Lookup</mark>)

**Purpose:** Provide accurate, complete technical descriptions

**Characteristics:**
- <mark>Information-oriented</mark>
- <mark>Austere, formal tone</mark>
- <mark>Structure mirrors the codebase</mark>
- <mark>Comprehensive coverage</mark>
- Example: API endpoint documentation, configuration parameters

**Key principle:** Reference material <mark>describes the machinery</mark>. It must be accurate, consistent, and complete.

### <mark>Explanation</mark> (<mark>Understanding Concepts</mark>)

**Purpose:** Clarify and illuminate the topic

**Characteristics:**
- Understanding-oriented
- Discusses alternatives and context
- Explores "why" questions
- Makes connections between concepts
- Example: "Understanding REST Architectural Constraints"

**Key principle:** Explanation deepens and broadens understanding. It discusses the bigger picture.

### Why This Matters

The Diátaxis framework prevents common documentation failures:

**Problem:** "Our tutorial keeps failing for users"
- **Diagnosis:** Tutorial includes troubleshooting steps (how-to guide content)
- **Solution:** Keep tutorial environment simple; move troubleshooting to how-to guides

**Problem:** "Reference docs are too hard to read"
- **Diagnosis:** Reference includes conceptual explanations (explanation content)
- **Solution:** Keep reference austere; move concepts to explanation articles

**Repository application:** This technical writing series follows Diátaxis structure:
- **Tutorial:** [Getting Started with IQPilot](../../GETTING-STARTED.md)
- **How-to:** [How to Structure Content for Copilot Instruction Files](../05.02 PromptEngineering/05. how_to_structure_content_for_copilot_instruction_files.md)
- **Reference:** [Validation Criteria](../../.copilot/context/validation-criteria.md)
- **Explanation:** This article

## Major Style Guides Comparison

Different organizations approach technical writing with varying priorities. Understanding these differences helps you make informed decisions when guidelines conflict.

### Comparison Table: <mark>Core Principles</mark>

| Aspect | Microsoft Writing Style Guide 📘 | Google Developer Docs 📘 | Apple Style Guide 📘 | Wikipedia Manual of Style 📘 |
|--------|-----------------------------------|--------------------------|---------------------|------------------------------|
| **<mark>Primary Audience</mark>** | Developers, IT Pros, End Users | Developers, Technical Practitioners | General Consumers, Developers | General Public, Academic Community |
| **<mark>Voice/Person</mark>** | Second person (you)<br>Conversational warmth | Second person (you)<br>Friendly but professional | Second person sparingly<br>Professional, polished | Third person<br>Encyclopedic, neutral |
| **<mark>Active/Passive Voice</mark>** | Prefer active voice<br>Allow passive when appropriate | Prefer active voice<br>Use passive for objectivity | Prefer active voice<br>Human-centered language | Both acceptable<br>Context-dependent |
| **<mark>Sentence Length</mark>** | Prefer shorter sentences<br>Readability focus | Short, scannable sentences<br>Mobile-friendly | Varied for natural rhythm<br>Clarity paramount | Varies by context<br>Completeness valued |
| **<mark>Technical Depth</mark>** | Layered (progressive disclosure) | Direct, no assumed knowledge | Invisible complexity | Comprehensive, linked |
| **<mark>Accessibility Priority</mark>** | High - WCAG guidelines | Very High - Global developer audience | High - Universal design | High - Screen reader compatible |
| **<mark>Citation Requirements</mark>** | Optional for common knowledge | Not emphasized | Minimal | Mandatory for all claims |
| **<mark>Revision Culture</mark>** | Regular updates<br>Living document | Continuous iteration | Controlled releases | Community-driven consensus |

### Microsoft Writing Style Guide

**Philosophy:** "<mark>Write like you speak</mark>" - <mark>conversational</mark>, <mark>inclusive</mark>, <mark>accessible</mark>

**Top 10 Principles (per learn.microsoft.com/style-guide):**

1. Use <mark>bigger ideas</mark>, <mark>fewer words</mark>
2. <mark>Write like you speak</mark>
3. Project <mark>friendliness</mark>
4. Get to the point <mark>fast</mark>
5. Be <mark>brief</mark>
6. When in doubt, <mark>don't capitalize</mark>
7. <mark>Skip periods in UI labels</mark>
8. <mark>Don't use common words in new ways</mark>
9. Use <mark>technical terms carefully</mark>
10. Be <mark>inclusive and use bias-free language</mark>

**Strengths:**
- Strong emphasis on <mark>bias-free communication</mark>
- Detailed guidance on <mark>global English</mark>
- Comprehensive <mark>accessibility guidelines</mark>
- Practical examples <mark>from real Microsoft products</mark>

**When to prefer Microsoft style:** <mark>Developer-facing content</mark> for enterprise software, when balancing technical precision with approachability.

### Google Developer Documentation Style Guide

**Philosophy:** "Documentation is user assistance" - <mark>clarity</mark>, <mark>scannability</mark>, <mark>global readability</mark>

**Key Characteristics:**
- <mark>Exceptionally detailed word list</mark> (preferred terms)
- Strong focus on <mark>internationalization</mark>
- <mark>Mobile-first mindset</mark> (short, scannable sections)
- <mark>API documentation standards</mark> (OpenAPI integration)

**Strengths:**
- Comprehensive <mark>guidance for API reference</mark>
- Explicit <mark>accessibility requirements</mark>
- Clear <mark>code example standards</mark>
- <mark>Global audience considerations</mark>

**When to prefer Google style:** <mark>API documentation, content for international developer audiences</mark>, open-source project documentation.

### Apple Style Guide

**Philosophy:** "<mark>Simplicity is sophistication</mark>" - <mark>clean</mark>, <mark>human-centered</mark>, <mark>refined</mark>

**Key Characteristics:**
- <mark>Elegant prose over bullet points</mark>
- <mark>Human interface guidelines influence</mark>
- <mark>Minimal jargon and acronyms</mark>
- <mark>Premium brand voice</mark>

**Strengths:**
- Emphasis on user experience writing
- Integration with interface design
- Consistent premium brand voice
- Strong visual-text integration

**When to prefer Apple style:** Consumer-facing documentation, user guides for designed experiences, content where brand voice matters.

### Wikipedia Manual of Style

**Philosophy:** "<mark>Neutral point of view</mark>" - <mark>encyclopedic</mark>, <mark>verifiable</mark>, <mark>community-maintained</mark>

**Key Characteristics:**
- <mark>Encyclopedic tone</mark> (<mark>third person</mark>, <mark>neutral</mark>)
- <mark>Rigorous citation requirements</mark>
- <mark>Neutral point of view (NPOV) policy</mark>
- <mark>Consensus-driven style decisions</mark>

**Core Policies:**
1. **<mark>Neutral Point of View (NPOV)</mark>** - Represent all significant viewpoints fairly, proportionately, without editorial bias
2. **<mark>Verifiability</mark>** - Cite reliable sources for all non-obvious claims
3. **No Original Research** - Report what sources say, don't synthesize new conclusions
4. **Manual of Style** - Consistency in formatting, structure, and presentation

**Unique Principles Not Emphasized Elsewhere:**

**Citation Rigor:**
- Every claim requires a reliable source
- Source credibility classification
- "Citation needed" culture
- Verifiable over "true" (what can be verified in sources matters more than absolute truth)

**NPOV Techniques:**
- "According to X" attribution for contested claims
- Avoid "some people think" weasel words
- Weight viewpoints proportionally to their prominence in sources
- Present opinions as opinions, facts as facts

**Strengths:**
- Unparalleled source verification standards
- Clear guidance on handling controversial topics
- Systematic approach to neutrality
- Community-maintained quality control

**When to prefer Wikipedia style:** Technical articles requiring source verification, multi-viewpoint analysis, community documentation, knowledge base articles.

**Limitations for software documentation:**
- Second-person prohibition awkward for how-to guides ("A user opens the settings" vs "Open the settings")
- Encyclopedic tone too formal for tutorials
- Over-citation can interrupt flow

## Wikipedia's Documentation Model

Wikipedia's approach to documentation offers valuable lessons, particularly around source credibility, neutrality, and community maintenance.

### Source Credibility Framework

Wikipedia categorizes sources with a sophistication worth emulating:

**Primary Sources** - <mark>Direct</mark>, firsthand evidence
- Original research papers
- Official specifications
- Source code
- Example: "The HTTP/1.1 specification (RFC 2616)"

**Secondary Sources** - <mark>Analysis and interpretation</mark>
- Academic articles
- Technical books
- Peer-reviewed journals
- Example: "Analysis of REST principles in Fielding's dissertation"

**Tertiary Sources** - <mark>Compilations and summaries</mark>
- Encyclopedias
- Handbooks
- Almanacs
- Example: "MDN Web Docs summary of HTTP methods"

**Reliable vs. Unreliable Indicators:**

✅ **Reliability indicators:**
- Peer review process
- Editorial oversight
- Fact-checking standards
- Author expertise
- Institutional backing

❌ **Unreliability indicators:**
- Self-published without editorial review
- Anonymous authorship without accountability
- Advocacy sites with clear bias
- User-generated content without expert verification
- Broken or missing citations

**Repository application:** This aligns with our reference classification system:
- 📘 **Official** - Primary sources (Microsoft Learn, official docs)
- 📗 **Verified Community** - Reputable secondary sources (GitHub blog, academic)
- 📒 **Community** - Tertiary or less rigorous sources (Medium, personal blogs)
- 📕 **Unverified** - Broken links, unknown sources (flag for fixing)

See [06-citations-and-reference-management.md](06-citations-and-reference-management.md) for complete citation guidelines.

### Neutral Point of View (NPOV) Application

While pure NPOV isn't suitable for all technical documentation, its principles inform quality writing:

**Avoid stating opinions as facts:**
- ❌ "React is the best JavaScript framework"
- ✅ "React is widely used in enterprise applications, with significant adoption by companies like Facebook, Netflix, and Airbnb"

**Distinguish contested from uncontested claims:**
- ❌ "This is the fastest algorithm"
- ✅ "Benchmarks from Smith et al. (2024) show O(n log n) performance"

**Weight viewpoints appropriately:**
- ❌ "Some developers prefer NoSQL databases" (weasel words)
- ✅ "According to the 2024 Stack Overflow survey, 38% of developers use NoSQL databases for production applications"

**Repository application:** Our validation system includes a "fact-checking" dimension specifically to verify claims against reliable sources.

### Wikipedia's Structural Patterns

**Information Architecture:**
- Lead section summarizes article without requiring further reading
- Table of contents provides navigation
- "See also" sections for related topics
- References section for source verification
- External links for additional resources

**This repository adopts similar patterns:**
- Article introductions establish scope and prerequisites
- TOCs in every substantial article
- Cross-references using markdown links
- References section with emoji-classified sources
- Related articles linked in context

## Decision Frameworks: When Guidelines Conflict

Style guides sometimes contradict each other. Use these frameworks to decide:

### Framework 1: <mark>Audience-First Decisions</mark>

**Ask:** Who is the primary reader?

| If primary audience is... | Prefer guidelines from... | Because... |
|---------------------------|---------------------------|------------|
| <mark>End users (non-technical)</mark> | Apple, Microsoft | User-centered, conversational approach |
| <mark>Developers (practitioners)</mark> | Google, Microsoft | Technical precision, code-focused |
| <mark>Researchers/academics</mark> | Wikipedia | Verifiability, neutral tone |
| <mark>Mixed technical levels</mark> | Microsoft | <mark>Progressive disclosure</mark>, <mark>layered content</mark> |
| <mark>International</mark>/non-native English | Google | Global readability standards |

**Example decision:**
- **Conflict:** Microsoft says "you can," Apple says "users can," Wikipedia says "one can"
- **Resolution:** Developer documentation → Use "you" (Google/Microsoft)
- **Rationale:** Developers expect direct instruction; formality creates distance

### Framework 2: <mark>Content Type Decisions</mark>

**Apply Diátaxis principles:**

| If content type is... | Voice preference | Detail level | Source expectation |
|-----------------------|------------------|--------------|-------------------|
| **<mark>Tutorial</mark>** | Second person ("you") | Progressive, controlled | Minimal citations (focus on experience) |
| **<mark>How-to</mark>** | Second person imperative | Task-focused, efficient | Citations for non-obvious claims |
| **<mark>Reference</mark>** | Third person or neutral | Complete, exhaustive | Citations for all claims |
| **<mark>Explanation</mark>** | Third person or educational first-person plural ("we") | Conceptual depth | Heavy citations for theories |

**Example decision:**
- **Conflict:** Should API reference use "you" or third person?
- **Resolution:** Reference type → Use third person (Wikipedia/formal style)
- **Rationale:** Reference describes the system, not user actions

### Framework 3: <mark>Context-Specific Decisions</mark>

**Consider these factors:**

**Brand/Organization Requirements:**
- Corporate style guides override general principles
- Open-source projects may prefer community-established patterns
- Consistency with existing docs matters more than theoretical "best" choice

**Platform/Medium:**
- Mobile displays → Shorter sentences (Google style)
- Print documentation → More formal tone (Apple style)
- Interactive docs → Conversational style (Microsoft)
- API references → Structured, austere (Diátaxis reference principles)

**Maintenance Considerations:**
- Community-maintained → Clear, simple rules (like Wikipedia's guidelines)
- Single-author → More flexibility for voice and style
- Automated generation → Strict structure requirements

### Framework 4: <mark>The "Least Harm" Principle</mark>

When truly stuck, choose the option that:
1. **<mark>Reduces ambiguity</mark>** - Clear beats clever
2. **<mark>Increases accessibility</mark>** - More people can use it
3. **<mark>Maintains consistency</mark>** - Matches existing patterns
4. **<mark>Simplifies maintenance</mark>** - Easier for future editors

**Example decision:**
- **Conflict:** Capitalize "internet" or not?
- **Historical context:** AP Stylebook capitalized until 2016, then lowercased
- **Current consensus:** Microsoft, Google, Apple, Wikipedia all lowercase
- **Resolution:** Use "internet" (lowercase)
- **Rationale:** Current consensus, simpler rule (consistency > tradition)

## Applying Foundations to This Repository

This repository's documentation system emerged from these foundational principles:

### Diátaxis Structure Mapping

Our content organization follows Diátaxis categories:

**<mark>Tutorials (Study + Practical)</mark>:**
- [GETTING-STARTED.md](../../GETTING-STARTED.md) - IQPilot setup tutorial
- [01.01-introduction-to-quarto.md](../20.01 Markdown/01. QUARTO Doc/01.01-introduction-to-quarto.md) - Quarto learning path

**<mark>How-to Guides (Work + Practical)</mark>:**
- [04.00 howto/](../../04.00 howto/) directory
- Prompt files in [.github/prompts/](../../.github/prompts/)

**<mark>Reference (Work + Theoretical)</mark>:**
- [validation-criteria.md](../../.copilot/context/validation-criteria.md)
- [dual-yaml-helpers.md](../../.copilot/context/dual-yaml-helpers.md)

**<mark>Explanation (Study + Theoretical)</mark>:**
- This article series (technical writing foundations)
- Concept articles in [03.00 tech/](../../03.00 tech/)

### Style Guide Synthesis

This repository synthesizes guidelines from multiple sources:

**<mark>Voice and Tone:</mark> Microsoft-inspired
- Second person for procedural content
- Conversational but professional
- Active voice preference (15-25 word sentences)

**<mark>Citation Requirements:</mark> Wikipedia-inspired
- Four-tier classification (📘📗📒📕)
- Every external claim referenced
- Source credibility assessment

**<mark>Accessibility:</mark> Google-inspired
- Readability targets (Flesch 50-70, Grade 9-10)
- Plain language principles
- Alternative text for images

**<mark>Structure:</mark> Diátaxis-informed
- Clear content type distinctions
- Cross-references between related types
- Navigation optimized for different user needs

### Dual Metadata Architecture

Our unique contribution: separate Quarto rendering metadata from validation tracking.

**Top YAML (Quarto):**
```yaml
---
title: "Article Title"
author: "Author Name"
date: "2026-01-14"
categories: [cat1, cat2]
description: "Brief description"
---
```

**Bottom YAML (Validation tracking):**
```html
<!-- Validation Metadata
validation_status: validated
last_validated: 2026-01-14
validation_scores:
  grammar: 95
  readability: 88
  structure: 92
-->
```

This separation follows the single-responsibility principle: Quarto metadata controls rendering; validation metadata tracks quality.

See [dual-yaml-helpers.md](../../.copilot/context/dual-yaml-helpers.md) for complete guidelines.

## Conclusion

Effective technical documentation rests on three pillars:

1. **Framework Understanding** - Diátaxis provides systematic guidance on what content to create and how to structure it based on user needs

2. **Style Guide Awareness** - Microsoft, Google, Apple, and Wikipedia offer proven approaches to voice, tone, structure, and credibility that can be adapted to your context

3. **Decision-Making Capability** - When guidelines conflict, apply audience-first, content-type, and context-specific frameworks rather than arbitrary choices

**Key takeaways:**

- Documentation is not one thing - tutorials, how-to guides, reference, and explanation serve different needs
- No single style guide is "best" - choose based on audience, content type, and context
- Wikipedia's rigor around sources and neutrality raises quality standards
- Consistency within a project matters more than adhering to any external standard
- This repository synthesizes best practices while maintaining coherent, maintainable patterns

**Next in this series:**

- [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) - Deep dive into active/passive voice, readability formulas, and sentence structure
- [02-structure-and-information-architecture.md](02-structure-and-information-architecture.md) - Progressive disclosure, LATCH framework, TOC strategies
- [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) - How this repository operationalizes these principles through validation

## References

### Official Style Guides

**[Microsoft Writing Style Guide](https://learn.microsoft.com/style-guide/)** 📘 [Official]  
Comprehensive style guide for Microsoft products. Emphasis on conversational tone, bias-free communication, and accessibility.

> **📚 Deep Dive:** For comprehensive analysis of Microsoft's style principles, see the [Microsoft Writing Style Guide Series](Microsoft%20Writing%20Style%20Guide/00-microsoft-style-guide-overview.md), including in-depth coverage of voice, mechanics, and machine-readable rules for prompts and agents.

**[Google Developer Documentation Style Guide](https://developers.google.com/style)** 📘 [Official]  
Detailed guidance for developer-facing documentation. Strong focus on global readability, API standards, and accessibility.

**[Apple Style Guide](https://help.apple.com/applestyleguide/)** 📘 [Official]  
Refinement-focused style guide emphasizing simplicity, human-centered language, and brand voice consistency.

### Frameworks and Standards

**[Diátaxis - A systematic approach to technical documentation](https://diataxis.fr/)** 📗 [Verified Community]  
Daniele Procida's framework for understanding documentation through four types: tutorials, how-to guides, reference, and explanation.

**[Wikipedia Manual of Style](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style)** 📘 [Official]  
Comprehensive style guide for encyclopedic content. Core resource for neutral point of view, citations, and verifiability standards.

**[Wikipedia Neutral Point of View Policy](https://en.wikipedia.org/wiki/Wikipedia:Neutral_point_of_view)** 📘 [Official]  
Fundamental policy for representing viewpoints fairly without editorial bias. Key guidance on due weight, balance, and source selection.

### Community Resources

**[Write the Docs - Style Guides](https://www.writethedocs.org/guide/writing/style-guides/)** 📗 [Verified Community]  
Curated collection of style guide resources, including links to major tech company guides and guidance for creating your own.

**[Red Hat Documentation Style Guide](https://redhat-documentation.github.io/supplementary-style-guide/)** 📗 [Verified Community]  
Open-source documentation standards. Strong example of community-maintained style guidelines.

### Repository-Specific Documentation

**[Documentation Instructions](../../.github/instructions/documentation.instructions.md)** [Internal Reference]  
This repository's comprehensive style guide with voice, tone, formatting, and citation requirements.

**[Validation Criteria](../../.copilot/context/validation-criteria.md)** [Internal Reference]  
Seven validation dimensions (grammar, readability, structure, logic, facts, understandability, gaps) with scoring thresholds.

**[Dual YAML Helpers](../../.copilot/context/dual-yaml-helpers.md)** [Internal Reference]  
Guidelines for separating Quarto rendering metadata from validation tracking metadata.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "00-foundations-of-technical-documentation.md"
  series: "Technical Documentation Excellence"
  series_position: 1
  total_articles: 8
  prerequisites: []
  related_articles:
    - "01-writing-style-and-voice-principles.md"
    - "02-structure-and-information-architecture.md"
    - "05-validation-and-quality-assurance.md"
    - "06-citations-and-reference-management.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
