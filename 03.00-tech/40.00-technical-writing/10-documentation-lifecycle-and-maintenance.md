---
# Quarto Metadata
title: "Documentation Lifecycle and Maintenance"
author: "Dario Airoldi"
date: "2026-02-28"
categories: [technical-writing, documentation, lifecycle, maintenance, content-strategy, reliability]
description: "Manage documentation through its entire lifecycle—from creation through review, publication, maintenance, and retirement—to ensure long-term reliability and freshness"
---

# Documentation Lifecycle and Maintenance

> Documentation doesn't end at "publish." Long-term reliability requires deliberate systems for maintaining, updating, and eventually retiring content.

## Table of Contents

- [Introduction 🎯](#introduction)
- [The documentation lifecycle 🔄](#the-documentation-lifecycle)
- [Content freshness and staleness detection 📋](#content-freshness-and-staleness-detection)
- [Versioned documentation strategies 🏗️](#versioned-documentation-strategies)
- [Technical debt in documentation ⚠️](#technical-debt-in-documentation)
- [Ownership and maintenance responsibility 👥](#ownership-and-maintenance-responsibility)
- [Documentation SLAs 📐](#documentation-slas)
- [Deprecation and archival 📦](#deprecation-and-archival)
- [Tooling for lifecycle management ⚙️](#tooling-for-lifecycle-management)
- [Applying lifecycle management to this repository 📌](#applying-lifecycle-management-to-this-repository)
- [Conclusion ✅](#conclusion)
- [References 📚](#references)

## 🎯 Introduction

Most documentation guidance focuses on *creating* content—writing clearly, structuring logically, validating thoroughly. But documentation that's accurate on the day it's published can become misleading six months later when APIs change, features evolve, or best practices shift. Reliability isn't a one-time achievement; it's an ongoing commitment.

This article covers the full <mark>documentation lifecycle</mark>—the stages content passes through from initial creation to eventual retirement. You'll find that [validation and quality assurance](05-validation-and-quality-assurance.md) briefly touches on documentation debt and maintenance metrics, and [consistency standards](08-consistency-standards-and-enforcement.md) addresses consistency during migration. This article expands those brief mentions into a comprehensive maintenance framework.

**This article covers:**

- **Lifecycle phases** — The stages every document passes through, from draft to retirement
- **Freshness signals** — How to detect and prevent content staleness
- **Versioned documentation** — Strategies for multi-version content
- **Documentation debt** — Identifying, measuring, and reducing accumulated quality issues
- **Ownership models** — Who maintains what, and how responsibilities transfer
- **SLAs** — Setting and measuring response times for documentation updates
- **Deprecation and archival** — Retiring content gracefully without breaking user trust

**Article type:** Explanation (understanding concepts) with how-to elements (actionable patterns)

**Prerequisites:** Familiarity with [validation and quality assurance](05-validation-and-quality-assurance.md) and [consistency standards](08-consistency-standards-and-enforcement.md) provides useful context. Understanding of [foundations](00-foundations-of-technical-documentation.md) is recommended.

## 🔄 The documentation lifecycle

Documentation isn't static—it moves through phases, and each phase has distinct activities, risks, and quality concerns. Understanding these phases helps you plan maintenance before it becomes urgent.

### The five lifecycle phases

Every document passes through five phases. Some cycle between phases repeatedly; others move linearly toward retirement.

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  Create  │───▶│  Review  │───▶│ Publish  │───▶│ Maintain │───▶│  Retire │
└─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │                              │
                    │              ┌────────────────┘
                    │              │
                    ▼              ▼
               ┌──────────────────────┐
               │   Revision cycle     │
               │  (back to Review)    │
               └──────────────────────┘
```

| Phase | Activities | Key risks | Quality focus |
|-------|-----------|-----------|---------------|
| **Create** | Draft, structure, write, add examples | Incomplete coverage, assumptions about audience | Accuracy, completeness, alignment with user needs |
| **Review** | Peer review, technical review, editorial review, validation | Missed errors, inconsistent standards | Grammar, readability, factual correctness |
| **Publish** | Deploy, index, notify users, integrate into navigation | Broken links, missing metadata, visibility gaps | Discoverability, SEO, cross-referencing |
| **Maintain** | Monitor freshness, update for changes, fix reported issues | Staleness, scope creep, neglect | Currency, relevance, link health |
| **Retire** | Deprecate, redirect, archive, remove from navigation | Broken inbound links, lost knowledge, user confusion | Graceful transition, redirect coverage |

### Phase transitions

Not every document follows a clean linear path. Articles cycle between Maintain and Review repeatedly as products change. Some documents skip directly from Create to Retire when projects are canceled. The key insight: **plan for every phase at creation time**, even if retirement seems distant.

**Transition triggers:**

| Transition | Trigger | Example |
|---|---|---|
| Create → Review | Draft complete, validation passes minimum thresholds | Author submits for peer review |
| Review → Publish | All review feedback addressed, validation scores meet targets | Article merged to main branch |
| Publish → Maintain | Content live and accessible to users | First user-facing deployment |
| Maintain → Review | Product change, reported inaccuracy, scheduled freshness review | API v2 released; article covers v1 only |
| Maintain → Retire | Product deprecated, content superseded, relevance lost | Feature removed from product |

### Create with maintenance in mind

Decisions made during creation directly affect maintenance cost. Front-load these considerations:

- **Scope boundaries** — Define what the article covers *and what it doesn't*. Narrow scope reduces the surface area that can become stale.
- **Version specificity** — State which versions you're targeting. "Configure Azure Functions" ages faster than "Configure Azure Functions (v4.x, .NET 8)."
- **Change sensitivity** — Identify which parts depend on external factors (UI screenshots, API responses, CLI output) that change without your control.
- **Cross-references** — Link to canonical sources instead of duplicating volatile information. If the Azure portal changes its navigation, one update propagates through all cross-references.

## 📋 Content freshness and staleness detection

<mark>Content freshness</mark> measures how current and accurate documentation is relative to the product or technology it describes. <mark>Staleness</mark> is the opposite—content that no longer reflects reality.

### Freshness signals

Freshness isn't binary. Documents exist on a spectrum from "just verified" to "critically outdated." These signals help you assess where an article falls:

**Positive freshness signals:**
- Last validation date within defined threshold (e.g., <90 days)
- No open issues or reported inaccuracies
- Referenced product versions match current releases
- All code examples tested against current APIs
- External links resolve and content hasn't changed materially

**Staleness indicators:**
- Last update date exceeds freshness threshold
- Referenced product version is no longer current
- Code examples produce errors or deprecated warnings
- External links return 404 or redirect to different content
- User-reported inaccuracies in feedback or issues
- Terminology has shifted in the product (e.g., "Azure Active Directory" → "Microsoft Entra ID")

### Freshness scoring model

Assign a freshness score to each article based on objective criteria. This removes guesswork from prioritization.

| Signal | Weight | Scoring |
|--------|--------|---------|
| Days since last validation | 30% | 0-90 days: 10pts; 91-180: 7pts; 181-365: 4pts; >365: 0pts |
| Version currency | 25% | Current version: 10pts; n-1: 7pts; n-2: 3pts; older: 0pts |
| Link health | 15% | All valid: 10pts; <5% broken: 7pts; 5-15%: 4pts; >15%: 0pts |
| Open issues | 15% | None: 10pts; 1-2 minor: 7pts; 3+ or critical: 3pts |
| Code example validity | 15% | All pass: 10pts; warnings only: 7pts; errors: 3pts; untested: 0pts |

**Thresholds:**
- **Fresh** (80-100): No action needed
- **Aging** (50-79): Schedule review within 30 days
- **Stale** (25-49): Prioritize for immediate review
- **Critical** (0-24): Flag for urgent update or temporary deprecation notice

### Automated freshness monitoring

Don't rely on memory or manual tracking. Automate freshness checks:

1. **Validation metadata timestamps** — Use the `last_run` field in bottom metadata to track when each validation dimension was last checked (see [validation and quality assurance](05-validation-and-quality-assurance.md))
2. **Link checkers** — Schedule automated link health scans (weekly or on CI)
3. **Version watchers** — Monitor product release notes and flag articles referencing outdated versions
4. **Feedback channels** — Set up issue templates or feedback forms for readers to report inaccuracies
5. **Git history analysis** — Track file modification dates relative to freshness thresholds

## 🏗️ Versioned documentation strategies

When products support multiple versions simultaneously, documentation must serve users on different versions without confusing either group. <mark>Versioned documentation</mark> provides version-specific content while maintaining a coherent overall experience.

### Versioning approaches

| Approach | Description | Best for | Trade-offs |
|----------|-------------|----------|------------|
| **Version branches** | Separate Git branches per version (e.g., `docs/v1`, `docs/v2`) | Major version differences with divergent content | High maintenance; content duplication; merge conflicts |
| **Version selectors** | Single source with UI-based version switching | Products with version-specific APIs or behaviors | Requires tooling support; complex content management |
| **Inline versioning** | Version-specific callouts within a single document | Minor differences between versions | Cluttered documents if differences are significant |
| **Evergreen + changelog** | Always document the latest version; maintain a changelog for breaking changes | Rapidly evolving products with backward compatibility | Older-version users may struggle to find relevant info |
| **Snapshot archival** | Publish versioned snapshots at each release; latest is default | Products with clear release cycles | Storage overhead; risk of users finding archived versions via search |

### Choosing a strategy

Consider these factors when selecting a versioning approach:

- **Divergence rate** — How different are the versions? Minor differences favor inline versioning. Major API changes favor branches.
- **User distribution** — What percentage of users are on each version? If 95% are on the latest, evergreen makes sense.
- **Maintenance capacity** — How many writers maintain the documentation? Version branches multiply workload.
- **Tooling support** — Does your documentation platform support version selectors natively? Quarto, Docusaurus, and ReadTheDocs handle this differently.
- **SEO impact** — Multiple versions create duplicate content risks. Use canonical URLs and version metadata to guide search engines.

### Version lifecycle alignment

Align documentation versions with product support lifecycles:

```
Product v1 (GA)     ──────────────▶  Product v1 (End of Support)
  │                                     │
  ▼                                     ▼
Docs v1 (Active)    ──────────────▶  Docs v1 (Archived)
                                        │
                                        ▼
                                    Deprecation notice added
                                    Redirect to latest version
```

**Rules of thumb:**
- Document only supported product versions
- When a product version reaches end-of-support, add a deprecation banner to its documentation
- Don't delete archived documentation—redirect it and mark it clearly as superseded
- Maintain redirects for at least 12 months after retirement

## ⚠️ Technical debt in documentation

<mark>Documentation debt</mark>—like technical debt in code—accumulates when maintainers take shortcuts or defer necessary updates. Article [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) introduces this concept briefly with four debt types. Here, we expand on how to identify, measure, and systematically reduce documentation debt.

### Types of documentation debt

| Debt type | Description | Example | Detection method |
|-----------|-------------|---------|-----------------|
| **Accuracy debt** | Information that's become outdated | API endpoint changed; article still references old path | Version checking, user reports, link monitoring |
| **Coverage debt** | Features or scenarios lacking documentation | New product feature shipped without documentation | Feature-to-docs mapping, gap analysis |
| **Quality debt** | Content that doesn't meet current standards | Articles written before style guide adoption | Validation scoring, style linting |
| **Structural debt** | Organization that's grown inconsistent | Navigation doesn't reflect current information architecture | Structural audits, consistency checks |
| **Reference debt** | Broken links, outdated citations, missing sources | Cited blog post deleted; reference still present | Automated link checking, reference validation |

### Measuring documentation debt

You can't reduce what you don't measure. Quantify documentation debt using these approaches:

**Debt inventory:**
1. Run validation across all articles—failures indicate quality debt
2. Check link health across the corpus—broken links indicate reference debt
3. Map product features to documentation—gaps indicate coverage debt
4. Compare article dates to product release dates—misalignment indicates accuracy debt
5. Audit structural patterns across the series—inconsistencies indicate structural debt

**Debt score per article:**

Calculate a simple debt score:

```
Debt Score = (Open Issues × 3) + (Failed Validations × 2) + (Broken Links × 1) + (Days Since Update / 30)
```

Higher scores indicate higher debt. Sort by score to prioritize reduction efforts.

### Debt reduction strategies

**The maintenance budget approach:**  
Allocate a fixed percentage of documentation time to debt reduction—typically 15-25% of writing capacity. This prevents debt from compounding while still allowing forward progress on new content.

**The 20% rule:**  
When updating an article for any reason, spend an additional 20% of the effort fixing unrelated debt in the same document. Touch it once, leave it better.

**Sprint-based debt reduction:**  
Schedule dedicated "documentation health" sprints quarterly. Focus exclusively on reducing the highest-scoring debt items.

**Prevention over cure:**  
- Require validation passes before publication (prevents quality debt)
- Include documentation in product feature checklists (prevents coverage debt)
- Run automated link checks in CI (prevents reference debt)
- Review structural consistency during series reviews (prevents structural debt)

## 👥 Ownership and maintenance responsibility

Documentation without clear ownership becomes nobody's responsibility. Ownership models define who's accountable for content accuracy and updates.

### Ownership models

| Model | Description | Works well when | Risks |
|-------|-------------|----------------|-------|
| **Author-owned** | Original author maintains the article | Small teams, personal knowledge bases | Author leaves; knowledge lost |
| **Team-owned** | A team shares responsibility for a documentation area | Product teams, engineering organizations | Diffusion of responsibility |
| **Rotating steward** | Assigned maintainer rotates on a schedule | Medium-sized teams with multiple writers | Inconsistent attention during handoffs |
| **Community-owned** | Anyone can contribute; maintainers review | Open-source projects, community documentation | Quality variation; review bottleneck |

### Defining ownership clearly

Vague ownership means no ownership. Make responsibility explicit:

- **Document owner field** — Include an owner identifier in article metadata (bottom validation block)
- **Scope definition** — Specify what each owner maintains (articles, sections, references, code examples)
- **Review cadence** — Define how often owners must review their assigned content
- **Escalation path** — Specify what happens when an owner can't update content in time
- **Transfer protocol** — Define how ownership transfers when authors change roles

### Knowledge transfer during transitions

When an owner leaves or transitions:

1. **Audit current state** — Run full validation on all owned articles
2. **Document tribal knowledge** — Capture context that isn't written down (why decisions were made, known limitations)
3. **Overlap period** — Allow 2-4 weeks of shared ownership during transition
4. **Verify transfer** — New owner confirms they understand the content and can maintain it
5. **Update metadata** — Change ownership fields in all affected articles

## 📐 Documentation SLAs

A <mark>documentation SLA</mark> (service level agreement) defines the maximum acceptable time between a product change and the corresponding documentation update. Without SLAs, documentation updates drift indefinitely.

### Defining response times

Not all documentation updates carry the same urgency. Tier your SLA by impact:

| Tier | Description | Response time | Example |
|------|-------------|---------------|---------|
| **P0 — Critical** | Documentation causes user harm (wrong commands, security issues) | 4 hours | Article instructs users to use a revoked API key pattern |
| **P1 — High** | Documentation blocks user workflow | 24 hours | Breaking API change shipped; docs show old signature |
| **P2 — Medium** | Documentation is inaccurate but workaround exists | 5 business days | UI navigation changed; article references old menu path |
| **P3 — Low** | Documentation is imprecise or could be improved | 30 days | Link to blog post now redirects; content still accessible |
| **P4 — Minor** | Cosmetic or stylistic issue | Next scheduled review | Typo in example code comment |

### SLA tracking and measurement

Track SLA compliance to identify systemic issues:

**Metrics to capture:**
- **Mean time to update (MTTU)** — Average time from product change to documentation update
- **SLA compliance rate** — Percentage of updates completed within SLA
- **SLA breach rate by tier** — Which tiers are underperforming?
- **Update backlog age** — How old are pending documentation updates?

**Tracking implementation:**
1. Log product changes that require documentation updates (link to release notes, feature flags, or deployment tickets)
2. Record when the documentation update is started and completed
3. Calculate MTTU and compliance per tier
4. Review metrics monthly; adjust SLAs if consistently breached (they may be unrealistic) or consistently exceeded (they may be too lenient)

### Integrating SLAs with development workflows

Documentation SLAs work best when integrated into existing workflows:

- **Definition of Done** — Include "documentation updated" in the team's definition of done for user-facing changes
- **Release checklists** — Add documentation review to release checklists
- **Change notifications** — Set up automated alerts when product changes occur (release notes published, feature flags toggled, API versions bumped)
- **Blocked deployments** — For P0/P1 items, consider blocking deployment until documentation is updated (or at minimum logged for immediate follow-up)

## 📦 Deprecation and archival

Retiring documentation gracefully matters as much as publishing it well. Abrupt removal breaks inbound links, frustrates users, and erodes trust.

### The deprecation process

Follow a predictable deprecation lifecycle:

```
Active ──▶ Deprecated ──▶ Archived ──▶ Removed
  │            │              │            │
  │       Banner added    Navigation     Links
  │       Links still     removed        return
  │       work            Content still  410 Gone
  │                       accessible     (or redirect)
  │                       via direct URL
```

**Step-by-step:**

1. **Mark as deprecated** — Add a visible deprecation banner at the top of the article. Include the date, the reason, and a link to the replacement content.

   ```markdown
   > ⚠️ **Deprecated (February 2026):** This article covers Azure Functions v3, 
   > which reached end of support in December 2025. 
   > See [Azure Functions v4 migration guide](link) for current guidance.
   ```

2. **Update metadata** — Set the article status to "deprecated" in bottom metadata. Include the deprecation date and replacement link.

3. **Remove from navigation** — Take the article out of the sidebar, table of contents, and any curated lists. It should no longer appear as a recommended path.

4. **Maintain access** — Keep the content accessible via direct URL for at least 12 months. Users may have bookmarked it, and external sites may link to it.

5. **Set up redirects** — When you eventually remove the content, configure permanent redirects (HTTP 301) to the replacement article.

6. **Archive or remove** — After the redirect period, archive the raw content in a dedicated archive folder or remove it entirely.

### What to do with orphaned content

Sometimes content doesn't have a direct replacement. Handle these cases explicitly:

- **Concept still valid, product changed** — Redirect to the most relevant current article. Add a sentence explaining the transition.
- **Concept no longer relevant** — Archive with a note explaining why the content was retired. Don't redirect to unrelated content.
- **Partial overlap with new content** — Redirect to the closest match. Acknowledge in the new article that some previous content isn't fully covered.

### Archive structure

If you maintain an archive, keep it organized:

```
archive/
├── 2025/
│   ├── azure-functions-v3-guide.md
│   └── deprecation-log.md
├── 2026/
│   └── ...
└── README.md  (explains archive purpose, organization, and access policy)
```

Include a deprecation log that records what was retired, when, why, and where users should go instead.

## ⚙️ Tooling for lifecycle management

Manual lifecycle management doesn't scale. These tools and patterns help automate the most tedious aspects:

### Metadata-driven tracking

Use validation metadata (bottom block) to track lifecycle state:

```yaml
article_metadata:
  filename: "article-name.md"
  status: "active"           # draft | active | deprecated | archived
  created: "2026-01-14"
  last_updated: "2026-02-28"
  last_reviewed: "2026-02-28"
  next_review: "2026-05-28"
  owner: "author-id"
  version_target: "v4.x"
  deprecation_date: null
  replacement_url: null
```

### Automated checks

| Check | Frequency | Tool |
|-------|-----------|------|
| Link health | Weekly | `check-links.ps1`, automated CI |
| Freshness threshold | Monthly | Script comparing `last_reviewed` to threshold |
| Version currency | On product release | Script comparing `version_target` to latest release |
| Orphan detection | Quarterly | Script finding articles not in navigation |
| Deprecation review | Quarterly | Script finding deprecated articles past archive date |

### CI/CD integration

Integrate lifecycle checks into your documentation pipeline:

1. **On pull request** — Validate link health, check metadata completeness, run style linting
2. **On merge** — Update `last_updated` timestamp, trigger freshness score recalculation
3. **On schedule (weekly)** — Run full link check, generate freshness report
4. **On schedule (monthly)** — Generate documentation health dashboard, flag articles below freshness threshold
5. **On product release** — Flag articles referencing the previous version for review

## 📌 Applying lifecycle management to this repository

This section maps lifecycle concepts to the specific structure and tooling of this Learning Documentation Site.

### Current lifecycle support

**What's already in place:**
- **Dual metadata system** — Bottom validation metadata tracks `last_updated`, `version`, and validation timestamps per dimension
- **Validation caching** — IQPilot MCP server caches validation results, skipping re-validation within seven days of a clean run
- **Link checking scripts** — `scripts/check-links.ps1` and `scripts/check-links-enhanced.ps1` verify link health
- **File date conventions** — Date-prefixed folders (e.g., `20260214-topic/`) encode creation dates in folder names

**What could be enhanced:**
- **Add `status` field** — Extend article metadata to include lifecycle status (`draft`, `active`, `deprecated`, `archived`)
- **Add `next_review` field** — Track when each article is next due for freshness review
- **Add `owner` field** — Assign explicit ownership for each article or series
- **Freshness dashboard** — Create a script that generates a freshness report across all articles based on `last_updated` and validation timestamps
- **Deprecation workflow** — Define a standard deprecation banner format and add it to article templates

### Recommended freshness thresholds for this series

| Content type | Freshness threshold | Rationale |
|---|---|---|
| Foundational concepts (Art. 00-03) | 12 months | Principles change slowly |
| Tool-specific guidance (Art. 04-05, 07) | 6 months | Tools and versions change frequently |
| Standards and patterns (Art. 06, 08) | 9 months | Standards evolve at moderate pace |
| Lifecycle and process (this article) | 12 months | Process guidance is relatively stable |
| Global writing (Art. 12) | 12 months | Language principles are long-lived |

### Integration with validation workflow

This article's lifecycle concepts complement the validation system described in [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md):

- **Validation** checks quality at a point in time
- **Lifecycle management** ensures quality persists over time
- Together, they form a complete reliability framework: validate content quality *and* monitor content currency

## ✅ Conclusion

Documentation reliability isn't achieved at publication—it's maintained through deliberate lifecycle management. The most beautifully written article becomes a liability if it describes a workflow that no longer exists or references an API that's been retired.

### Key Takeaways

- **Plan for all five phases at creation time** — Draft, review, publish, maintain, and retire aren't separate concerns; decisions at creation determine maintenance cost
- **Automate freshness detection** — Use metadata timestamps, link health checks, and version monitoring to catch staleness before readers do
- **Quantify documentation debt** — Measure accuracy, coverage, quality, structural, and reference debt so you can prioritize reduction efforts
- **Assign clear ownership** — Documentation without an explicit owner becomes nobody's responsibility; make accountability visible in metadata
- **Set realistic SLAs** — Tier response times by impact; track compliance and adjust when SLAs are consistently breached or exceeded
- **Deprecate gracefully** — Announce deprecation, maintain access, redirect links, and archive content rather than deleting abruptly

### Next Steps

- **Previous article:** [08-consistency-standards-and-enforcement.md](08-consistency-standards-and-enforcement.md) — Consistency enforcement during documentation evolution
- **Related:** [05-validation-and-quality-assurance.md](05-validation-and-quality-assurance.md) — Validation frameworks and documentation debt concepts expanded here
- **Related:** [00-foundations-of-technical-documentation.md](00-foundations-of-technical-documentation.md) — Quality criteria that lifecycle management sustains over time
- **Related:** [12-writing-for-global-audiences.md](12-writing-for-global-audiences.md) — Translation maintenance as a lifecycle concern

## 📚 References

### Official documentation

**[Microsoft Writing Style Guide](https://learn.microsoft.com/style-guide/welcome/)** 📘 [Official]  
The authoritative source for Microsoft documentation standards. Establishes voice, tone, mechanics, and accessibility rules that lifecycle management helps preserve over time.

**[Google Developer Documentation Style Guide — Maintaining Docs](https://developers.google.com/style)** 📘 [Official]  
Google's guide includes guidance on keeping documentation current. Emphasizes documentation-as-code practices and review workflows.

**[Diátaxis Framework — Quality](https://diataxis.fr/quality/)** 📗 [Verified Community]  
Daniele Procida's framework for documentation quality. Distinguishes functional quality (does it work?) from deep quality (does it serve users well?)—both of which degrade without maintenance.

**[Write the Docs — Documentation Maintenance](https://www.writethedocs.org/guide/)** 📗 [Verified Community]  
Community-maintained guidance on documentation practices including content maintenance, review workflows, and documentation health. A practical companion to the principles in this article.

### Verified community resources

**[Docs Like Code](https://www.docslikecode.com/)** 📗 [Verified Community]  
Anne Gentle's approach to treating documentation with the same rigor as code: version control, reviews, CI/CD pipelines, and automated testing. Directly supports lifecycle management through engineering practices.

**[The Good Docs Project](https://thegooddocsproject.dev/)** 📗 [Verified Community]  
Open-source project creating documentation templates and best practices. Includes lifecycle-aware templates and maintenance guidance.

**[RFC 7234 — HTTP Caching](https://datatracker.ietf.org/doc/html/rfc7234)** 📘 [Official]  
While focused on HTTP, this RFC's freshness model (max-age, stale-while-revalidate) provides a useful conceptual framework for documentation freshness scoring.

### Repository-specific documentation

**[Documentation Instructions](../../.github/instructions/documentation.instructions.md)** [Internal Reference]  
This repository's formatting, structure, and reference standards.

**[Article Writing Instructions](../../.github/instructions/article-writing.instructions.md)** [Internal Reference]  
Comprehensive writing guidance: voice, tone, Diátaxis patterns, accessibility, and mechanical rules.

**[Validation Criteria](../../.copilot/context/01.00-article-writing/02-validation-criteria.md)** [Internal Reference]  
Seven validation dimensions used for quality assessment across the series. Lifecycle management ensures these dimensions remain satisfied over time.

---

<!--
article_metadata:
  filename: "10-documentation-lifecycle-and-maintenance.md"
  series: "Technical Documentation Excellence"
  series_position: 11
  total_articles: 13
  prerequisites:
    - "05-validation-and-quality-assurance.md"
    - "08-consistency-standards-and-enforcement.md"
  related_articles:
    - "00-foundations-of-technical-documentation.md"
    - "05-validation-and-quality-assurance.md"
    - "08-consistency-standards-and-enforcement.md"
    - "12-writing-for-global-audiences.md"
  version: "1.0"
  last_updated: "2026-02-28"

validations:
  grammar:
    status: "not_run"
    last_run: null
  readability:
    status: "not_run"
    last_run: null
  structure:
    status: "not_run"
    last_run: null
  facts:
    status: "not_run"
    last_run: null
  logic:
    status: "not_run"
    last_run: null
  coverage:
    status: "not_run"
    last_run: null
  references:
    status: "not_run"
    last_run: null
-->
