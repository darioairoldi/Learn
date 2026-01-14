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

- [Introduction](#introduction)
- [Progressive Disclosure: Layering Complexity](#progressive-disclosure-layering-complexity)
- [The LATCH Framework](#the-latch-framework)
- [Table of Contents Strategies](#table-of-contents-strategies)
- [Navigation Hierarchies](#navigation-hierarchies)
- [Page Structure Patterns](#page-structure-patterns)
- [Cross-Referencing Strategies](#cross-referencing-strategies)
- [Applying Architecture to This Repository](#applying-architecture-to-this-repository)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Information architecture determines whether users **find** and **understand** your documentation. Even perfectly written content fails if users can't locate it or can't determine which sections apply to their needs.

This article explores:

- **Progressive disclosure** - Revealing complexity in layers appropriate to user needs
- **LATCH framework** - Five universal organizing principles (Location, Alphabet, Time, Category, Hierarchy)
- **TOC strategies** - Designing tables of contents that serve navigation and comprehension
- **Navigation hierarchies** - Creating pathways for different user journeys
- **Page structure** - Patterns for organizing individual documents

**Prerequisites:** Understanding of [documentation foundations](00-foundations-of-technical-documentation.md) and the Diátaxis framework is helpful.

## Progressive Disclosure: Layering Complexity

Progressive disclosure presents information in layers, revealing complexity gradually based on user needs. This principle, borrowed from interface design, reduces cognitive load while ensuring advanced users can access complete information.

### The Principle

**Core idea:** Show users the minimum information needed for their current task; provide pathways to more detail when needed.

**Applied to documentation:**
- **Surface level:** What most users need, immediately visible
- **Detail level:** Supporting information, available on demand
- **Expert level:** Edge cases, advanced configuration, behind-the-scenes

### Implementation Patterns

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

### Progressive Disclosure by Diátaxis Type

| Content Type | Surface Level | Detail Level | Expert Level |
|--------------|---------------|--------------|--------------|
| **Tutorial** | "Do this, see that" | "Here's why this works" | Links to explanation |
| **How-to** | Steps to accomplish goal | Variations and options | Edge cases, troubleshooting |
| **Reference** | Signature, brief description | Parameters, return values | Implementation notes |
| **Explanation** | Core concept | Supporting details, context | Academic depth, research |

### Anti-patterns to Avoid

❌ **Information dumping:** All details on first exposure
> "The authentication system supports OAuth 2.0, SAML 2.0, OpenID Connect, LDAP, Active Directory, custom JWT, API keys with scopes, mTLS, and webhook-based verification. OAuth 2.0 supports authorization code flow, implicit flow, client credentials, and device code flow..."

✅ **Progressive alternative:**
> "Authentication supports multiple methods. Most integrations use OAuth 2.0 ([Quick Start](#oauth-quick-start)). For enterprise SSO, see [SAML Configuration](#saml-configuration)."

❌ **Hiding essential information:** Critical details buried too deep
> Links labeled "Learn more" with no indication of content importance

✅ **Progressive alternative:**
> Explicit labels: "**Required for production:** Configure rate limiting before deployment"

## The LATCH Framework

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

### Combining LATCH Principles

Real documentation combines multiple LATCH approaches:

**Example: API Reference**
- **Category:** Endpoints grouped by resource (users, orders, products)
- **Alphabet:** Methods listed A-Z within each category
- **Time:** Changelog organized chronologically
- **Hierarchy:** Deprecated methods marked as lower priority

**Example: This Repository**
- **Category:** Content by topic (tech, howto, issues, events)
- **Time:** Date-prefixed folders (20250814 topic/)
- **Hierarchy:** Numbered folders (01.00 news, 02.00 events...)
- **Alphabet:** Within categories, often alphabetical

## Table of Contents Strategies

Tables of contents serve two functions: **navigation** (getting to content) and **orientation** (understanding structure).

### TOC Design Principles

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

### TOC Patterns

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

### Auto-generated vs. Manual TOCs

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

## Navigation Hierarchies

Navigation systems guide users through documentation at multiple scales: site-wide, section-level, and within documents.

### Site-Wide Navigation

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

### Section-Level Navigation

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

### Navigation by User Journey

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

### Navigation Patterns in This Repository

From [_quarto.yml](../../_quarto.yml):

```yaml
website:
  sidebar:
    contents:
      - section: "News"
        contents: "01.00 news/**"
      - section: "Events"
        contents: "02.00 events/**"
      - section: "Technical"
        contents: "03.00 tech/**"
      - section: "How-To"
        contents: "04.00 howto/**"
```

**Design rationale:**
- **Numbered prefixes** enforce ordering (Category + Hierarchy)
- **Date prefixes** on folders provide chronological context (Time)
- **Topic sections** group related content (Category)
- **Automatic sidebar** from Quarto reduces maintenance

## Page Structure Patterns

Individual pages follow structural patterns that support comprehension and navigation.

### The Standard Article Pattern

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

### The Reference Pattern

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

### The How-To Pattern

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

### The Tutorial Pattern

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

### Wikipedia's Article Structure

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

## Cross-Referencing Strategies

Cross-references connect related content, supporting both navigation and comprehension.

### Types of Cross-References

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

### Cross-Reference Best Practices

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

## Applying Architecture to This Repository

### Current Architecture

**LATCH application:**
- **Hierarchy:** Numbered top-level folders (01.00, 02.00, 03.00...)
- **Category:** Topic-based organization within tech/ folder
- **Time:** Date prefixes on event and news folders
- **Alphabet:** Often within categories (Azure, Data, GitHub...)

**Diátaxis mapping:**
- **Tutorials:** GETTING-STARTED.md, introduction articles
- **How-to:** 04.00 howto/ folder
- **Reference:** .copilot/context/, validation-criteria.md
- **Explanation:** 03.00 tech/ conceptual articles

### Progressive Disclosure Implementation

**Surface level:** README.md, GETTING-STARTED.md
**Detail level:** Topic articles in 03.00 tech/
**Expert level:** Context files in .copilot/context/, source code

### Navigation Design

From [_quarto.yml](../../_quarto.yml):
- **Sidebar:** Auto-generated from folder structure
- **TOCs:** Manual in major articles
- **Breadcrumbs:** Via Quarto navigation
- **Cross-references:** Markdown links with descriptive text

### Structural Standards

From [documentation.instructions.md](../../.github/instructions/documentation.instructions.md):

**Required article elements:**
1. YAML front matter (Quarto metadata)
2. Title matching filename
3. Table of Contents (for articles > 500 words)
4. Introduction stating scope
5. Conclusion with key takeaways
6. References section (for articles with citations)
7. Validation metadata (bottom YAML)

## Conclusion

Information architecture determines documentation usability. Key principles:

**Progressive disclosure matters** - Layer complexity so users see what they need without being overwhelmed by what they don't

**LATCH provides organizing options** - Location, Alphabet, Time, Category, Hierarchy cover all information organization needs

**TOCs serve dual purposes** - Navigation and orientation; design for both through careful structure

**Navigation supports multiple journeys** - Explorers, searchers, followers, and returners need different pathways

**Page structure follows patterns** - Articles, references, how-tos, and tutorials each have proven structural templates

**Cross-references connect content** - Meaningful links with clear purposes support discovery and comprehension

**Next in series:**

- [03-accessibility-in-technical-writing.md](03-accessibility-in-technical-writing.md) - Ensuring documentation works for all users
- [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) - Diátaxis framework context
- [01-writing-style-and-voice-principles.md](01-writing-style-and-voice-principles.md) - Voice principles that complement structure

## References

### Information Architecture Foundations

**[Information Architecture: For the Web and Beyond (4th Edition)](https://www.oreilly.com/library/view/information-architecture-4th/9781491913529/)** 📗 [Verified Community]  
Rosenfeld, Morville, and Arango's foundational text on information architecture principles.

**[LATCH: The Five Hat Racks - Richard Saul Wurman](https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0002wj)** 📗 [Verified Community]  
Original source for the five universal ways to organize information.

**[Don't Make Me Think - Steve Krug](https://sensible.com/dont-make-me-think/)** 📗 [Verified Community]  
Usability principles applicable to documentation navigation and structure.

### Progressive Disclosure

**[Progressive Disclosure - Nielsen Norman Group](https://www.nngroup.com/articles/progressive-disclosure/)** 📗 [Verified Community]  
Foundational article on progressive disclosure in interface design, applicable to documentation.

**[The Principle of Least Astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment)** 📘 [Official]  
Wikipedia's explanation of designing systems (including documentation) to match user expectations.

### Documentation Structure Standards

**[Diátaxis - Tutorials](https://diataxis.fr/tutorials/)** 📗 [Verified Community]  
Structural guidance for tutorial-type documentation.

**[Google Developer Documentation - Document Structure](https://developers.google.com/style/document-structure)** 📘 [Official]  
Google's guidance on structuring technical documents.

**[Microsoft Writing Style Guide - Content Planning](https://learn.microsoft.com/style-guide/planning/)** 📘 [Official]  
Microsoft's approach to content structure and organization.

**[Wikipedia Manual of Style - Layout](https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Layout)** 📘 [Official]  
Wikipedia's article structure standards and section ordering.

### Repository-Specific Documentation

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
  total_articles: 8
  prerequisites:
    - "00-foundations-of-technical-documentation.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "01-writing-style-and-voice-principles.md"
    - "03-accessibility-in-technical-writing.md"
  version: "1.0"
  last_updated: "2026-01-14"
-->
