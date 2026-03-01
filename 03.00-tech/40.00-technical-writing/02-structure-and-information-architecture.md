---
# Quarto Metadata
title: "Structure and Information Architecture"
author: "Dario Airoldi"
date: "2026-01-14"
categories: [technical-writing, information-architecture, structure, navigation, progressive-disclosure]
description: "Master documentation structure through progressive disclosure, the LATCH framework, effective TOC strategies, and navigation hierarchies that guide users to the right information"
---

# Structure and Information Architecture

> Organize technical documentation so readers find what they need, when they need it, with the right level of detail for their current task

## Table of Contents

- [🎯 Introduction](#-introduction)
- [📊 Progressive disclosure: layering complexity](#-progressive-disclosure-layering-complexity)
- [🏗️ The LATCH framework](#-the-latch-framework)
- [📋 Table of contents strategies](#-table-of-contents-strategies)
- [🧭 Navigation hierarchies](#-navigation-hierarchies)
- [📄 Page structure patterns](#-page-structure-patterns)
- [🎨 Content design principles](#-content-design-principles)
- [🔗 Cross-referencing strategies](#-cross-referencing-strategies)
- [ Series architecture and planning](#-series-architecture-and-planning)
- [📌 Applying architecture to this repository](#-applying-architecture-to-this-repository)
- [✅ Conclusion](#-conclusion)
- [📚 References](#-references)

## 🎯 Introduction

Information architecture determines whether users **find** and **understand** your documentation. Even perfectly written content fails if users can't locate it or can't determine which sections apply to their needs.

This article explores:

- **Progressive disclosure** - Revealing complexity in layers appropriate to user needs
- **LATCH framework** - Five universal organizing principles (Location, Alphabet, Time, Category, Hierarchy)
- **TOC strategies** - Designing tables of contents that serve navigation and comprehension
- **Navigation hierarchies** - Creating pathways for different user journeys
- **Page structure** - Patterns for organizing individual documents
- **Content design principles** - Content-first design, structured content models, and topic-based authoring

**Prerequisites:** Understanding of [documentation foundations](00-foundations-of-technical-documentation.md) and the Diátaxis framework is helpful.

## 📊 Progressive disclosure: layering complexity

Progressive disclosure presents information in layers, revealing complexity gradually based on user needs. This principle, borrowed from interface design, reduces cognitive load while ensuring advanced users can access complete information.

### The principle

**Core idea:** Show users the minimum information needed for their current task; provide pathways to more detail when needed.

**Applied to documentation:**
- **Surface level:** What most users need, immediately visible
- **Detail level:** Supporting information, available on demand
- **Expert level:** Edge cases, advanced configuration, behind-the-scenes

### Implementation patterns

**Pattern 1: Lead with essentials, depth below**

```markdown
## Authentication

Authenticate requests using Bearer tokens in the Authorization header.

### Quick Start (Surface)

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" https://api.example.com/users
```

### Token Management (Detail)

Tokens expire after 24 hours. Refresh tokens using the `/auth/refresh` endpoint...

### Advanced: Custom Token Lifetimes (Expert)

For enterprise deployments, configure token lifetime in `auth.config.json`...
```

**Pattern 2: Summary boxes with expansion**

```markdown
> **TL;DR:** Use `npm install package-name` to install packages. 
> For advanced options, see [Installation Options](#installation-options).

## Installation

The npm package manager handles dependencies automatically...
[detailed explanation follows]
```

**Pattern 3: Audience-specific pathways**

```markdown
## Getting Started

Choose your path:

- **[Quick Start](#quick-start)** - Get running in 5 minutes
- **[Standard Setup](#standard-setup)** - Full installation with configuration
- **[Enterprise Deployment](#enterprise-deployment)** - High-availability cluster setup
```

### Progressive disclosure by Diátaxis type

| Content Type | Surface Level | Detail Level | Expert Level |
|--------------|---------------|--------------|--------------|
| **Tutorial** | "Do this, see that" | "Here's why this works" | Links to explanation |
| **How-to** | Steps to accomplish goal | Variations and options | Edge cases, troubleshooting |
| **Reference** | Signature, brief description | Parameters, return values | Implementation notes |
| **Explanation** | Core concept | Supporting details, context | Academic depth, research |

### Anti-patterns to avoid

❌ **Information dumping:** All details on first exposure
> "The authentication system supports OAuth 2.0, SAML 2.0, OpenID Connect, LDAP, Active Directory, custom JWT, API keys with scopes, mTLS, and webhook-based verification. OAuth 2.0 supports authorization code flow, implicit flow, client credentials, and device code flow..."

✅ **Progressive alternative:**
> "Authentication supports multiple methods. Most integrations use OAuth 2.0 ([Quick Start](#oauth-quick-start)). For enterprise SSO, see [SAML Configuration](#saml-configuration)."

❌ **Hiding essential information:** Critical details buried too deep
> Links labeled "Learn more" with no indication of content importance

✅ **Progressive alternative:**
> Explicit labels: "**Required for production:** Configure rate limiting before deployment"

## 🏗️ The LATCH framework

Richard Saul Wurman's LATCH framework identifies five fundamental ways to organize information. Every organizational scheme is a variation of these five approaches.

### L - Location

**Organize by physical or logical position**

**Best for:**
- Geographic information
- Spatial relationships
- Physical system components
- Directory structures

**Documentation examples:**

```markdown
## Azure Regions
- East US
- West Europe  
- Southeast Asia

## File System Structure
/src
  /components
  /utils
/docs
/tests
```

**When to use:** When physical or logical position is the primary concern; when users think "where is this?"

### A - Alphabet

**Organize in alphabetical order**

**Best for:**
- Reference lookups
- Glossaries
- API endpoints (by name)
- Configuration options

**Documentation examples:**

```markdown
## API Methods
- `authenticate()`
- `createUser()`
- `deleteRecord()`
- `getStatus()`

## Configuration Options
| Option | Description |
|--------|-------------|
| `apiKey` | Your API key |
| `baseUrl` | Base URL for requests |
| `timeout` | Request timeout in ms |
```

**When to use:** When users know what they're looking for by name; for exhaustive reference lists.

**Limitation:** Alphabetical order assumes users know the exact term. Provide search or index for discovery.

### T - Time

**Organize chronologically or by sequence**

**Best for:**
- Procedures (step 1, step 2...)
- Changelogs and release notes
- Historical documentation
- Workflows and processes

**Documentation examples:**

```markdown
## Release History
- **v2.0.0** (2026-01-14) - Major authentication overhaul
- **v1.5.2** (2025-12-01) - Security patches
- **v1.5.1** (2025-11-15) - Bug fixes

## Deployment Steps
1. Build the application
2. Run tests
3. Deploy to staging
4. Verify staging
5. Deploy to production
```

**When to use:** When sequence matters; when users need to understand "what comes next" or "what happened when."

### C - Category

**Organize by type, theme, or topic**

**Best for:**
- Conceptual groupings
- Feature documentation
- Topic-based organization
- Product areas

**Documentation examples:**

```markdown
## Documentation by Topic
- **Authentication** - OAuth, API keys, SSO
- **Data Storage** - Databases, file storage, caching
- **Messaging** - Queues, pub/sub, webhooks

## Components by Type
- **UI Components** - Buttons, forms, modals
- **Data Components** - Tables, charts, grids
- **Layout Components** - Headers, sidebars, footers
```

**When to use:** When users think in terms of concepts or features; when content naturally groups by topic.

### H - Hierarchy

**Organize by importance, magnitude, or rank**

**Best for:**
- Priority ordering
- Severity levels
- Organizational structures
- Skill-level content

**Documentation examples:**

```markdown
## Error Severity
- **Critical** - System down, data loss risk
- **High** - Major functionality impaired
- **Medium** - Feature degraded
- **Low** - Cosmetic issues

## Learning Path
- **Beginner** - Fundamentals
- **Intermediate** - Advanced features
- **Expert** - Architecture and optimization
```

**When to use:** When relative importance guides user decisions; when some information is more critical than others.

### Combining LATCH principles

Real documentation combines multiple LATCH approaches:

**Example: API Reference**
- **Category:** Endpoints grouped by resource (users, orders, products)
- **Alphabet:** Methods listed A-Z within each category
- **Time:** Changelog organized chronologically
- **Hierarchy:** Deprecated methods marked as lower priority

**Example: This Repository**
- **Category:** Content by topic (tech, howto, issues, events)
- **Time:** Date-prefixed folders (20250814 topic/)
- **Hierarchy:** Numbered folders (01.00-news, 02.00-events...)
- **Alphabet:** Within categories, often alphabetical

## 📋 Table of contents strategies

Tables of contents serve two functions: **navigation** (getting to content) and **orientation** (understanding structure).

### TOC design principles

**1. Reflect actual structure**
- TOC entries should match heading text exactly
- Hierarchy should match document hierarchy
- No phantom entries (TOC items without corresponding sections)

**2. Balance depth and scannability**
- 5-9 items ideal for scannability (Miller's Law)
- 3 levels maximum for most documents
- Flatten if structure is too deep

**3. Use parallel construction**
- Consistent grammatical structure
- All nouns, all verbs, or all phrases

✅ **Parallel:**
```markdown
- Installing the CLI
- Configuring Authentication
- Deploying Applications
- Troubleshooting Errors
```

❌ **Not parallel:**
```markdown
- Installing the CLI
- How to Configure Authentication
- Application Deployment
- When You Have Errors
```

### TOC patterns

**Pattern 1: Flat TOC (5-7 sections)**

Best for focused articles with linear flow.

```markdown
## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
```

**Pattern 2: Nested TOC (grouped sections)**

Best for comprehensive guides with distinct parts.

```markdown
## Table of Contents
- [Part 1: Setup](#part-1-setup)
  - [Installation](#installation)
  - [Configuration](#configuration)
- [Part 2: Usage](#part-2-usage)
  - [Basic Operations](#basic-operations)
  - [Advanced Features](#advanced-features)
- [Part 3: Reference](#part-3-reference)
  - [API Documentation](#api-documentation)
  - [Configuration Options](#configuration-options)
```

**Pattern 3: Topic-based TOC (conceptual groups)**

Best for explanation articles or conceptual documentation.

```markdown
## Table of Contents
- [Core Concepts](#core-concepts)
- [Authentication](#authentication)
- [Data Management](#data-management)
- [Performance Optimization](#performance-optimization)
- [Security Considerations](#security-considerations)
```

### Auto-generated vs. manual TOCs

**Auto-generated TOCs (Quarto, MkDocs, etc.):**
- ✅ Always synchronized with content
- ✅ Less maintenance
- ❌ May include too many levels
- ❌ Less control over presentation

**Manual TOCs:**
- ✅ Curated, intentional structure
- ✅ Can include descriptions
- ❌ Can become out of sync
- ❌ Maintenance burden

**This repository's approach:** Manual TOCs for key articles (control over presentation), with Quarto's automatic navigation sidebar for site-wide navigation.

## 🧭 Navigation hierarchies

Navigation systems guide users through documentation at multiple scales: site-wide, section-level, and within documents.

### Site-wide navigation

**Primary navigation:** Top-level categories visible from anywhere
- Home
- Getting Started
- Tutorials
- Reference
- API

**Secondary navigation:** Context-specific options within sections
- Within "Reference": Authentication, API, Configuration

**Utility navigation:** Always-available tools
- Search
- Version selector
- Language selector

### Section-level navigation

**Breadcrumbs:** Show path from root
```
Home > Authentication > OAuth 2.0 > Authorization Code Flow
```

**Sidebars:** Show sibling pages and hierarchy
```
Authentication
├── Overview
├── OAuth 2.0 ← You are here
│   ├── Authorization Code
│   ├── Client Credentials
│   └── Device Code
├── API Keys
└── SAML
```

**Previous/Next links:** Support sequential reading
```
← Previous: Getting Started | Next: Configuration →
```

### Navigation by user journey

Different users navigate differently. Design for multiple journeys:

**The Explorer:** Browsing to learn what's possible
- Needs: Clear categories, descriptive titles
- Supports: Category-based navigation, feature lists

**The Searcher:** Looking for specific information
- Needs: Search, index, glossary
- Supports: Search box, alphabetical index, keyword tags

**The Follower:** Working through a sequence
- Needs: Clear next steps, progress indicators
- Supports: Previous/next links, numbered tutorials, learning paths

**The Returner:** Revisiting known information
- Needs: Quick access to frequent destinations
- Supports: Recent pages, bookmarks, persistent URLs

### Navigation patterns in this repository

From [_quarto.yml](../../_quarto.yml):

```yaml
website:
  sidebar:
    contents:
      - section: "News"
        contents: "01.00-news/**"
      - section: "Events"
        contents: "02.00-events/**"
      - section: "Technical"
        contents: "03.00-tech/**"
      - section: "How-To"
        contents: "04.00-howto/**"
```

**Design rationale:**
- **Numbered prefixes** enforce ordering (Category + Hierarchy)
- **Date prefixes** on folders provide chronological context (Time)
- **Topic sections** group related content (Category)
- **Automatic sidebar** from Quarto reduces maintenance

## 📄 Page structure patterns

Individual pages follow structural patterns that support comprehension and navigation.

### The standard article pattern

```markdown
# Title

> Subtitle or description

## Table of Contents
[Navigation links]

## Introduction
- What this covers
- Why it matters
- Prerequisites

## Main Content Sections
[Organized by topic/sequence]

### Subsections as needed

## Conclusion
- Key takeaways
- Next steps

## References
[Cited sources]

<!-- Validation Metadata -->
[Tracking YAML]
```

### The reference pattern

```markdown
# API Reference: [Resource Name]

## Overview
Brief description and purpose

## Endpoints

### GET /resource
[Description, parameters, response, examples]

### POST /resource
[Description, parameters, response, examples]

## Objects

### ResourceObject
[Properties, types, descriptions]

## Errors
[Error codes, meanings, resolution]
```

### The how-to pattern

```markdown
# How to [Accomplish Task]

## Overview
What you'll accomplish

## Prerequisites
- Required tools
- Required access
- Required knowledge

## Steps

### Step 1: [Action]
[Instructions]

### Step 2: [Action]
[Instructions]

## Verification
How to confirm success

## Next Steps
Related tasks

## Troubleshooting
Common issues and solutions
```

### The tutorial pattern

> **Note:** The code block below is a *template example* showing the recommended structure for tutorial-type content. The `What You'll Learn` and `What You've Learned` sections are part of the **tutorial pattern**, not standard article structure used in this series. For the article structure this series follows, see [The Standard Article Pattern](#the-standard-article-pattern) above.

```markdown
# Tutorial: [Learning Goal]

## What You'll Learn
- Skill 1
- Skill 2

## Prerequisites
- Required knowledge level
- Setup requirements

## Part 1: [Foundation]

### [Guided activity]
[Step-by-step with explanations]

### [Practice checkpoint]
[Verify understanding]

## Part 2: [Building]
[Progressive complexity]

## Part 3: [Completing]
[Final product]

## What You've Learned
Summary of skills acquired

## Next Steps
Further learning paths
```

### Wikipedia's article structure

Wikipedia provides a well-tested pattern for encyclopedic content:

```markdown
# Article Title

[Lead section - standalone summary]

## Contents
[Auto-generated TOC]

## History / Background
[Context and origins]

## [Main topic sections]
[Body content]

## See Also
[Related articles]

## Notes
[Explanatory footnotes]

## References
[Citation list]

## External Links
[Curated outside resources]
```

**Key Wikipedia innovations:**
- **Lead section stands alone:** First paragraph summarizes entire article
- **"See also" for discovery:** Related topics for exploration
- **Notes vs. References:** Explanatory notes separated from source citations

## 🎨 Content design principles

Page structure patterns describe *how* to arrange individual documents. Content design principles address the higher-level question: *how do you decide what content to create and how to break it apart?* These principles guide decisions before you start writing a single page.

### Content-first design

**<mark>Content-first design</mark>** means defining the content model—what information exists, who needs it, and in what context—before choosing layout, navigation, or tooling.

**The principle:**

1. **Identify the information** — List every concept, procedure, and reference the audience needs
2. **Prioritize by user task** — Rank information by frequency of need and criticality
3. **Define relationships** — Map which content pieces depend on, extend, or duplicate each other
4. **Choose structure last** — Select page types, navigation, and templates only after the content model is clear

**Why this matters for technical documentation:**

| Design approach | Risk | Symptom |
|----------------|------|---------|
| Template-first | Content forced into ill-fitting containers | Sections with one sentence or "N/A" filler |
| Tool-first | Content constrained by tooling limits | Docs restructured whenever tooling changes |
| **Content-first** | **None (desired approach)** | **Structure emerges naturally from content needs** |

**Practical example:** Before creating a new article in this series, the gap analysis document ([gap-analysis-context-vs-articles.md](../../99.00-temp/gap-analysis-context-vs-articles.md)) identifies what content is missing and where it belongs. Only after confirming the gap do we choose whether it becomes a new article, a section in an existing article, or a cross-reference.

### Structured content models

**<mark>Structured content</mark>** separates content from presentation by defining reusable, typed content components with explicit relationships.

**Key concepts:**

- **Content types** — Named categories of content with defined fields (e.g., "Tutorial" has prerequisites, steps, verification; "Reference" has syntax, parameters, return values)
- **Metadata schemas** — Structured attributes attached to each content unit (this repository uses Quarto YAML front matter and bottom-block validation metadata)
- **Content reuse** — Write once, reference many times; avoid duplicating explanations across articles
- **Separation of concerns** — Content (Markdown), presentation (Quarto/SCSS), and structure (_quarto.yml) live in separate layers

**How this repository applies structured content:**

| Layer | Implementation | Example |
|-------|---------------|---------|
| Content types | Article template with required sections | [article-template.md](../../.github/templates/article-template.md) |
| Metadata schema | Dual YAML blocks (Quarto + validation) | Top YAML for rendering, bottom HTML comment for tracking |
| Reuse via reference | Cross-references instead of duplication | "See [Art. 01](01-writing-style-and-voice-principles.md) for voice principles" |
| Presentation layer | Quarto + cerulean.scss | Consistent rendering independent of content changes |

**Anti-pattern: unstructured content**

- Copy-pasting the same explanation into multiple articles (creates maintenance debt)
- Mixing rendering instructions into prose (breaks when tooling changes)
- Omitting metadata (makes validation, search, and lifecycle management impossible)

For the lifecycle implications of structured vs. unstructured content, see [Article 10: Documentation Lifecycle and Maintenance](10-documentation-lifecycle-and-maintenance.md).

### Topic-based authoring

**<mark>Topic-based authoring</mark>** structures documentation as self-contained, independently addressable units ("topics") rather than monolithic documents.

**Three core topic types** (from DITA — Darwin Information Typing Architecture):

| Topic type | Purpose | Maps to Diátaxis | This series example |
|-----------|---------|-----------------|--------------------|
| **Concept** | Explain what something is and why it matters | Explanation | Art. 00 (Foundations), Art. 03 (Accessibility) |
| **Task** | Guide users through a procedure | How-to guide | 04.00-howto/ articles |
| **Reference** | Provide lookup information | Reference | Art. 04 (Code Documentation), MS Sub-04 (Principles Reference) |

**Benefits for technical documentation:**

- **Independent comprehension** — Each topic makes sense without reading the entire series
- **Flexible assembly** — Topics can be combined into different navigation paths for different audiences
- **Targeted maintenance** — Update one topic without reviewing an entire document
- **Searchability** — Self-contained topics rank better in search engines and AI retrieval systems

**Topic-based authoring in this repository:**

Each article in the Technical Documentation Excellence series is designed as a self-contained topic. The series also demonstrates how topics combine:

- **Sequential path:** Articles 00 → 12 form a learning progression
- **Reference path:** Any article can be read independently via its introduction and prerequisites section
- **Cross-reference mesh:** Articles link to each other for contextual depth without requiring linear reading

**Granularity decision:** When should content be a separate topic (article) vs. a section within a topic?

| Create a separate topic when… | Keep as a section when… |
|-------------------------------|------------------------|
| Content exceeds ~1,500 words | Content is under ~500 words |
| Multiple articles need to reference it | Only one article uses it |
| Content has a distinct audience or purpose | Content shares the same audience and purpose as its parent |
| Content changes on a different schedule | Content changes with its parent |

> **See also:** [Article 10](10-documentation-lifecycle-and-maintenance.md) for how topic-based authoring affects documentation freshness and maintenance scheduling.

### Content density and depth by article type

Not every article needs the same level of detail. A tutorial that explains the mathematical derivation behind readability formulas is misplacing depth; a reference that skips parameter descriptions is withholding it. <mark>Content density</mark> is the ratio of essential information to supporting material within a section.

The appropriate depth depends on the article's Diátaxis type and its role in the series:

| Article type | Appropriate depth | Density target | Example from this series |
|-------------|-------------------|----------------|-------------------------|
| **Explanation** (concepts) | Deep — teach the "why" with models, frameworks, and theory | High density; every paragraph advances understanding | Art. 09's LaTeX formula breakdowns for readability metrics |
| **How-to** (task guidance) | Moderate — enough context to execute, not to theorize | Medium density; context supports action | Art. 07's AI prompting patterns with step-by-step workflows |
| **Reference** (lookup) | Shallow but exhaustive — cover every option without editorializing | High density; minimal prose, maximum data | Art. 04's code documentation patterns (tables, templates) |
| **Tutorial** (learning) | Progressive — start shallow, deepen as learner gains confidence | Low-to-medium; scaffolded with checkpoints | Art. 00's foundations article building from principles to frameworks |

**Signals that depth is wrong:**

| Signal | Problem | Fix |
|--------|---------|-----|
| Readers skip long sections | Too deep for the article type | Extract deep content into a companion explanation article; link to it |
| Readers ask follow-up questions the article should answer | Too shallow | Add the missing analytical layer; ensure the density matches the Diátaxis type |
| Code examples lack context | Depth mismatch — reference-level content in a tutorial-type article | Add scaffolding prose around the code explaining what it demonstrates |
| Lengthy theoretical preambles before practical guidance | Deep explanation in a how-to article | Move theory to a blockquote or "Background" subsection; lead with the task |

**The depth-consistency rule:** Within a single article, maintain consistent depth. If one subsection goes three levels deep (concept → framework → worked example), all major subsections should reach similar depth. An article that alternates between surface treatment and deep analysis feels uneven and erodes reader trust.

> **See also:** [Article 11](11-visual-documentation-and-diagrams.md#visual-requirements-by-article-type) for guidance on which visual types are appropriate at each depth level.

## 🔗 Cross-referencing strategies

Cross-references connect related content, supporting both navigation and comprehension.

### Types of cross-references

**Inline references:** Context-specific links within prose
> "For authentication options, see the [Security Guide](../security/authentication.md)."

**See also sections:** Related content collections
```markdown
## See Also
- [OAuth 2.0 Deep Dive](./oauth-deep-dive.md)
- [API Security Best Practices](../security/api-security.md)
- [Token Management](./token-management.md)
```

**Prerequisites:** Required prior knowledge
```markdown
## Prerequisites
Before starting this tutorial, complete:
- [Getting Started Guide](../getting-started.md)
- [Authentication Setup](./auth-setup.md)
```

**Next steps:** Forward navigation
```markdown
## Next Steps
- [Configure advanced options](./advanced-config.md)
- [Deploy to production](../deployment/production.md)
```

### Cross-reference best practices

**1. Make links meaningful**

❌ **Vague:**
> "For more information, click [here](./more-info.md)."

✅ **Descriptive:**
> "For detailed authentication options, see [Configuring OAuth 2.0](./oauth-config.md)."

**2. Indicate link purpose**

```markdown
- For background, see [History of REST](./rest-history.md) (explanation)
- To implement this, follow [Setting up REST API](./rest-setup.md) (how-to)
- For endpoint details, see [REST API Reference](./rest-reference.md) (reference)
```

**3. Use consistent patterns**

This repository's pattern from [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):
```markdown
See [Article Title](relative/path/to/article.md) for [brief description of what reader will find].
```

**4. Avoid circular references**

Map cross-references to ensure they form useful pathways, not loops.

**5. Validate links regularly**

Broken cross-references undermine trust. See [scripts/check-links.ps1](../../scripts/check-links.ps1) for link validation.

##  Series architecture and planning

Individual articles need structure. So do article *series*. This section covers how to plan a documentation series from scratch—scoping the series, determining article count, designing the learning progression, defining article boundaries, and managing length.

### Scoping a documentation series

Before writing the first article, answer these four questions:

| Question | What it determines | Example answer (this series) |
|----------|-------------------|------------------------------|
| **What's the domain boundary?** | Which topics are in-scope and which belong elsewhere | Technical writing for documentation sites—not creative writing, journalism, or marketing copy |
| **Who's the audience?** | Knowledge level, goals, constraints | Technical professionals who write documentation as part of their role, not full-time technical writers |
| **What's the learning progression?** | Prerequisite chain from foundations to advanced | Foundations → style → structure → accessibility → code docs → validation → citations → AI → consistency → readability → lifecycle → visuals → globalization |
| **What's the scope ceiling?** | When is the series "complete enough"? | When a reader can produce, validate, and maintain a quality documentation site using the principles taught |

**The scope test:** If a proposed article doesn't serve the audience's learning progression or falls outside the domain boundary, it belongs in a different series or as a standalone piece.

### Designing the learning progression

A series isn't just a collection of articles on related topics—it's a **prerequisite chain** where each article builds on concepts from earlier ones.

**Mapping technique:**

1. **List all core concepts** the series must cover
2. **Identify dependencies** — Which concepts require understanding of prior concepts?
3. **Group into articles** — Cluster related concepts that share a natural narrative arc
4. **Order by dependency** — Ensure no article assumes knowledge from a later article
5. **Verify with a "cold reader" test** — Could someone read article N without having read article N+1?

**Prerequisite chain example (this series):**

```
Art. 00 Foundations ──→ Art. 01 Style ──→ Art. 02 Structure
           │                  │                    │
           │                  ▼                    ▼
           │            Art. 03 Accessibility   Art. 04 Code docs
           │                                       │
           ▼                                       ▼
      Art. 05 Validation ──→ Art. 06 Citations ──→ Art. 07 AI-enhanced
           │
           ▼
      Art. 08 Consistency ──→ Art. 09 Readability ──→ Art. 10 Lifecycle
                                                         │
                                                         ▼
                                                   Art. 11 Visuals ──→ Art. 12 Global
```

**Key principle:** Later articles may *reference* earlier ones, but readers shouldn't need to re-read earlier articles to understand the current one. Brief recaps (under 100 words) are acceptable per the [series redundancy policy](08-consistency-standards-and-enforcement.md#acceptable-redundancy-across-articles).

### Determining article count and boundaries

There's no magic number. Article count emerges from the intersection of concept clusters and reader endurance.

**Splitting criteria — when one article should become two:**

| Signal | Example | Action |
|--------|---------|--------|
| **Two distinct audiences** | Developers AND managers both need the content | Split into audience-specific articles |
| **Two distinct purposes** | Explaining a concept AND providing a step-by-step procedure | Split into explanation + how-to |
| **Length exceeds reader endurance** | Over 1,000 lines or 25+ minutes reading time | Look for a natural split point |
| **Subsection has independent value** | A subsection is frequently cross-referenced from other articles | Extract to its own article |
| **Different update cadences** | One section changes monthly, another is permanent | Split to enable independent maintenance |

**Merging criteria — when two articles should become one:**

| Signal | Example | Action |
|--------|---------|--------|
| **Combined length under 500 lines** | Two thin articles that always link to each other | Merge and redirect |
| **Identical audience and purpose** | Two how-to guides that readers always use together | Merge into a single guide |
| **One article is purely setup for the other** | "Prerequisites" article + "Main content" article | Merge with prerequisites as a section |

### Article scope and length guidelines

Articles in a series should be comparable in depth and reading time. Extreme variance signals scope problems.

**Length benchmarks:**

| Article length | Assessment | Action |
|----------------|-----------|--------|
| **Under 400 lines** | Likely too thin—may lack sufficient depth or examples | Consider expanding, or merging with a related article |
| **400–800 lines** | Sweet spot for most articles | Normal range; no action needed |
| **800–1,000 lines** | Acceptable for complex topics with many code examples | Review for sections that could be extracted |
| **Over 1,000 lines** | Likely too long—reader fatigue and maintenance burden | Identify splitting opportunities using the criteria above |

**This series' length distribution:**

| Range | Articles | Assessment |
|-------|----------|------------|
| 550–700 lines | Art. 03, 06, 08, 10 | Concise and focused |
| 700–850 lines | Art. 00, 01, 02, 04, 09, 11, 12 | Standard depth |
| 850–1,000 lines | Art. 05, 07 | Complex topics justified by scope (validation has seven dimensions; AI has rapidly evolving tooling) |

**Scope check:** If an article keeps growing during writing, it probably needs splitting. If you can't write more than 400 lines, the topic may be too narrow for a standalone article.

### Audience-segmented reading paths

Different readers need different paths through a series. The four user journeys from [navigation by user journey](#navigation-by-user-journey) map to distinct reading paths:

**The Explorer (browsing to learn):**
> Start with Art. 00 (Foundations) → skim TOCs of Art. 01–12 → read articles that match your interests

**The Beginner (building skills):**
> Art. 00 → Art. 01 → Art. 02 → Art. 03 → Art. 04 → Art. 05 (sequential, foundations first)

**The Practitioner (solving problems):**
> Jump directly to the relevant article via TOC or search → follow cross-references for prerequisites as needed

**The Reviewer (validating quality):**
> Art. 05 (Validation) → Art. 08 (Consistency) → Art. 01 (Style) → Art. 09 (Readability)

**Implementing reading paths:**

1. **Article introductions** should include a prerequisites list so practitioners can self-assess: "This article assumes familiarity with [X]."
2. **Next Steps sections** should suggest both the sequential next article AND topically related articles for non-sequential readers.
3. **Cross-references** should indicate the Diátaxis type of the target, so readers know whether they're navigating to an explanation, how-to, or reference: "See [Article 05](05-validation-and-quality-assurance.md) for validation frameworks (explanation)" vs. "Follow [the validation workflow](../../.github/prompts/) (how-to)."

**Why this matters:** Without reading paths, every reader enters the series the same way—by starting at Art. 00 and reading sequentially. This works for beginners but frustrates experienced practitioners who only need specific articles. Explicit paths respect different readers' time and expertise levels.

### Series evolution strategies

A documentation series isn't frozen at launch. Articles get added, removed, merged, split, and reordered as the domain evolves. Without explicit evolution strategies, organic growth introduces the same problems you planned away—inconsistent depth, broken cross-references, and orphaned prerequisites.

**Adding an article:**

1. **Validate the gap** — Check the [concept coverage matrix](08-consistency-standards-and-enforcement.md#building-a-concept-coverage-matrix) to confirm the topic isn't already covered
2. **Assign a position** — Place the new article where it fits in the prerequisite chain; update `series_position` metadata in downstream articles if numbering shifts
3. **Wire cross-references** — Add forward links from prerequisite articles and back-links from the new article to its foundations
4. **Update reading paths** — Revise the audience-segmented paths above to include the new article where appropriate
5. **Update totals** — Increment `total_articles` metadata across all articles in the series

**Removing or deprecating an article:**

| Step | Action | Why |
|------|--------|-----|
| 1 | Identify all inbound cross-references | Removing an article breaks every link pointing to it |
| 2 | Redirect or replace references | Point existing links to the closest surviving content |
| 3 | Absorb unique content | If the removed article contains concepts found nowhere else, migrate those sections into a surviving article |
| 4 | Follow the deprecation lifecycle | Use the deprecation process from [Article 10](10-documentation-lifecycle-and-maintenance.md#the-deprecation-process): mark deprecated → remove from navigation → maintain access → redirect → archive |
| 5 | Update metadata | Decrement `total_articles`; adjust `series_position` values |

**Splitting an article:**

Use the [splitting criteria](#determining-article-count-and-boundaries) from earlier in this section. When you split:

- **Preserve the original URL** — Redirect it to the first of the two new articles, or to a disambiguation page if both halves are equally important
- **Distribute cross-references** — Each inbound link should point to whichever new article contains the referenced content
- **Add mutual cross-references** — The two new articles should link to each other: "This article was split from [original]. For [other half's topic], see [sibling article]."

**Merging articles:**

When two articles are thin (under 400 lines each) and share the same audience and purpose:

1. Choose the more intuitive article title as the survivor
2. Redirect the absorbed article's URL to the survivor
3. Combine content, eliminating pure duplication and converting near-duplicates into a single authoritative treatment
4. Update all cross-references that pointed to the absorbed article

**Reordering articles:**

Reordering changes the prerequisite chain and reading paths. Minimize disruption by:

- **Renumbering files** — Keep filenames sequential (`00-`, `01-`, etc.) so the file system reflects the intended learning order
- **Batch-updating metadata** — Change `series_position` in all affected articles in a single pass, not incrementally
- **Reviewing cross-references** — "See the next article" or "the previous article" language must match the new order
- **Announcing the change** — If readers have bookmarked specific positions, a brief note in the series introduction explaining the reorder helps orient returning readers

> **See also:** [Article 08](08-consistency-standards-and-enforcement.md#handling-consistency-during-migration-and-evolution) for consistency maintenance strategies during series changes. [Article 10](10-documentation-lifecycle-and-maintenance.md#deprecation-and-archival) for the full deprecation and archival lifecycle.

## 📌 Applying architecture to this repository

### Current architecture

**LATCH application:**
- **Hierarchy:** Numbered top-level folders (01.00, 02.00, 03.00...)
- **Category:** Topic-based organization within tech/ folder
- **Time:** Date prefixes on event and news folders
- **Alphabet:** Often within categories (Azure, Data, GitHub...)

**Diátaxis mapping:**
- **Tutorials:** GETTING-STARTED.md, introduction articles
- **How-to:** 04.00-howto/ folder
- **Reference:** .copilot/context/, validation-criteria.md
- **Explanation:** 03.00-tech/ conceptual articles

### Progressive disclosure implementation

**Surface level:** README.md, GETTING-STARTED.md
**Detail level:** Topic articles in 03.00-tech/
**Expert level:** Context files in .copilot/context/, source code

### Navigation design

From [_quarto.yml](../../_quarto.yml):
- **Sidebar:** Auto-generated from folder structure
- **TOCs:** Manual in major articles
- **Breadcrumbs:** Via Quarto navigation
- **Cross-references:** Markdown links with descriptive text

### Structural standards

From [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):

**Required article elements:**
1. YAML front matter (Quarto metadata)
2. Title matching filename
3. Table of Contents (for articles > 500 words)
4. Introduction stating scope
5. Conclusion with key takeaways
6. References section (for articles with citations)
7. Validation metadata (bottom YAML)

## ✅ Conclusion

Information architecture determines documentation usability. The right structure helps readers find, understand, and act on information efficiently.

### Key takeaways

- **Progressive disclosure matters** — Layer complexity so users see what they need without being overwhelmed by what they don't
- **LATCH provides organizing options** — Location, Alphabet, Time, Category, Hierarchy cover all information organization needs
- **TOCs serve dual purposes** — Navigation and orientation; design for both through careful structure
- **Navigation supports multiple journeys** — Explorers, searchers, followers, and returners need different pathways
- **Page structure follows patterns** — Articles, references, how-tos, and tutorials each have proven structural templates
- **Content design precedes page design** — Define what information exists and who needs it before choosing structure; use structured content models and topic-based authoring for maintainability and reuse
- **Cross-references connect content** — Meaningful links with clear purposes support discovery and comprehension

### Next steps

- **Next article:** [03-accessibility-in-technical-writing.md](03-accessibility-in-technical-writing.md) — Ensuring documentation works for all users
- **Related:** [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) — Diátaxis framework context
- **Related:** [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) — Voice principles that complement structure

## 📚 References

### Information architecture foundations

**[Information Architecture: For the Web and Beyond (4th Edition)](https://www.oreilly.com/library/view/information-architecture-4th/9781491913529/)** 📗 [Verified Community]  
Rosenfeld, Morville, and Arango's foundational text on information architecture principles.

**[LATCH: The Five Hat Racks - Richard Saul Wurman](https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0002wj)** 📗 [Verified Community]  
Original source for the five universal ways to organize information.

**[Don't Make Me Think - Steve Krug](https://sensible.com/dont-make-me-think/)** 📗 [Verified Community]  
Usability principles applicable to documentation navigation and structure.

### Progressive disclosure

**[Progressive Disclosure - Nielsen Norman Group](https://www.nngroup.com/articles/progressive-disclosure/)** 📗 [Verified Community]  
Foundational article on progressive disclosure in interface design, applicable to documentation.

**[The Principle of Least Astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment)** 📘 [Official]  
Wikipedia's explanation of designing systems (including documentation) to match user expectations.

### Documentation structure standards

**[Diátaxis - Tutorials](https://diataxis.fr/tutorials/)** 📗 [Verified Community]  
Structural guidance for tutorial-type documentation.

**[Google Developer Documentation - Document Structure](https://developers.google.com/style/document-structure)** 📘 [Official]  
Google's guidance on structuring technical documents.

**[Microsoft Writing Style Guide - Content Planning](https://learn.microsoft.com/style-guide/planning/)** 📘 [Official]  
Microsoft's approach to content structure and organization.

**[Wikipedia Manual of Style - Layout](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Layout)** 📘 [Official]  
Wikipedia's article structure standards and section ordering.

### Content design & structured authoring

**[Content Design (Sarah Winters / Content Design London)](https://contentdesign.london/content-design/what-is-content-design)** 📗 [Verified Community]  
Foundational resource on content-first design principles—designing content around user needs before choosing format or structure.

**[DITA - Darwin Information Typing Architecture (OASIS)](https://www.oasis-open.org/committees/dita/)** 📘 [Official]  
The XML standard that formalized topic-based authoring with concept, task, and reference topic types.

**[Every Page is Page One - Mark Baker](https://everypageispageone.com/)** 📗 [Verified Community]  
Topic-based authoring principles for web-era documentation, arguing every topic must stand alone.

### Repository-specific documentation

**[_quarto.yml](../../_quarto.yml)** [Internal Reference]  
This repository's navigation configuration and site structure.

**[Documentation Instructions - Structure](../../.github/instructions/documentation.instructions.md#structure)** [Internal Reference]  
Required article elements and structural standards for this repository.

**[generate-navigation.ps1](../../scripts/generate-navigation.ps1)** [Internal Reference]  
Script for generating navigation structure from folder hierarchy.

---

<!-- Validation Metadata
validation_status: pending_first_validation
article_metadata:
  filename: "02-structure-and-information-architecture.md"
  series: "Technical Documentation Excellence"
  series_position: 3
  total_articles: 13
  prerequisites:
    - "00-foundations-of-technical-documentation.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "01-writing-style-and-voice-principles.md"
    - "03-accessibility-in-technical-writing.md"
    - "10-documentation-lifecycle-and-maintenance.md"
  version: "1.1"
  last_updated: "2026-02-28"
-->
