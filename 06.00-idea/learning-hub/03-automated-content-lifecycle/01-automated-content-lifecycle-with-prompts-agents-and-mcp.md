---
title: "Automated content lifecycle with prompts, agents, and MCP"
author: "Dario Airoldi"
date: "2026-02-22"
categories: [learnhub, automation, prompts, agents, mcp, content-lifecycle]
description: "Architecture for automating Learning Hub content creation, validation, maintenance, and evolution using GitHub Copilot prompts, agents, subagents, and the IQPilot MCP server"
---

# Automated content lifecycle with prompts, agents, and MCP

> How the Learning Hub documentation taxonomy can be maintained, validated, and evolved automatically through a layered automation architecture

## Table of contents

- [Introduction](#introduction)
- [Lessons learned: the prompt engineering series](#lessons-learned-the-prompt-engineering-series)
- [Taxonomy improvements based on real-world experience](#taxonomy-improvements-based-on-real-world-experience)
- [The automation architecture](#the-automation-architecture)
- [Layer 1: Prompts — single-article operations](#layer-1-prompts--single-article-operations)
- [Layer 2: Agents — specialized roles](#layer-2-agents--specialized-roles)
- [Layer 3: Subagent orchestrations — multi-agent workflows](#layer-3-subagent-orchestrations--multi-agent-workflows)
- [Layer 4: IQPilot MCP server — deterministic infrastructure](#layer-4-iqpilot-mcp-server--deterministic-infrastructure)
- [Content lifecycle workflows](#content-lifecycle-workflows)
- [Implementation roadmap](#implementation-roadmap)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

The Learning Hub's documentation taxonomy defines **seven content categories** (Overview, Getting Started, Concepts, How-to, Analysis, Reference, Resources) that together provide comprehensive coverage of any technical subject. However, defining a taxonomy isn't enough—you need automation to **maintain it at scale**.

This document proposes a layered automation architecture that uses GitHub Copilot's customization stack—prompts, agents, subagents, hooks, and MCP servers—to make the taxonomy self-sustaining. It's informed by practical experience reviewing and maintaining a 15-article prompt engineering series, where every category of maintenance problem the taxonomy aims to prevent was encountered and resolved manually.

### What you'll find here

- **Analysis of real maintenance problems** discovered during the prompt engineering series review
- **Taxonomy improvements** addressing gaps revealed by practical experience
- **A four-layer automation architecture** mapping each maintenance task to the right tool
- **Concrete agent and prompt specifications** with tool configurations
- **Implementation roadmap** for incremental delivery

### Prerequisites

- Familiarity with the [Learning Hub documentation taxonomy](../02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md)
- Understanding of [GitHub Copilot customization](../../03.00-tech/05.02-prompt-engineering/02-getting-started/01.00-how_github_copilot_uses_markdown_and_prompt_folders.md) (prompts, agents, MCP)
- Access to the repository's [IQPilot MCP server](../../src/IQPilot/README.md)

---

## 🔬 Lessons learned: the prompt engineering series

The prompt engineering series (15 published articles in `03.00-tech/05.02-prompt-engineering/`) served as an unplanned but thorough test of Learning Hub's taxonomy concepts. A comprehensive review uncovered six categories of problems that any documentation system must address automatically.

### Problem 1: Content drift and staleness

**What happened:** Articles written months apart referenced different versions of the same features. Article 04 (agent files) described the original YAML frontmatter, while VS Code had added `user-invokable`, `disable-model-invocation`, and `agents` properties. Article 01 (overview) didn't mention hooks or Copilot Spaces—features that had become first-class customization categories.

**Taxonomy implication:** <mark>Product knowledge</mark> (what a tool is, how it's configured) and <mark>usage mastery</mark> (how to use it effectively) were mixed in the same articles. Product knowledge goes stale with every release; usage mastery evolves with experience. When they're mixed, you can't update one without risking the other.

**Automation need:** A mechanism to detect when external product changes invalidate article content, and to separate product-knowledge updates from usage-mastery updates so they can proceed on independent cadences.

### Problem 2: Cross-reference fragility

**What happened:** When three articles were renumbered (10→12, 11→13, 12→14), every cross-reference across the entire series needed updating. References like "see articles 02–10" became incorrect. The "Related articles in this series" section had inconsistent formatting across articles (`## 🔗 References` vs `## 📚 References`, title case vs sentence case).

**Taxonomy implication:** Cross-references are a maintenance liability proportional to series size. Without automation, they silently break.

**Automation need:** Automated cross-reference validation that runs after any structural change (rename, add, delete, reorder) and fixes broken references without human intervention.

### Problem 3: Coverage gaps

**What happened:** Three major gaps were discovered—agent hooks (zero coverage), subagent orchestrations (outdated coverage), and Copilot Spaces (not mentioned). These gaps existed for months because no automated process compared series scope to current product capabilities.

**Taxonomy implication:** The <mark>gap analysis</mark> process is manual and expensive. It requires comparing internal documentation against external product evolution—a task that AI can perform continuously.

**Automation need:** Periodic gap scanning that compares series coverage against official product documentation, release notes, and changelog feeds.

### Problem 4: Content redundancy

**What happened:** Several conceptual explanations were duplicated across articles. The concept of "context injection" was explained in articles 01, 03, 05, and 07 with slight variations. Article 20 contained ~485 lines of orphaned content from earlier drafts.

**Taxonomy implication:** Without the taxonomy's separation of concerns (Concepts vs How-to vs Reference), authors naturally repeat foundational explanations in every article that needs them. The taxonomy solves this by having one authoritative Concepts page that others cross-reference.

**Automation need:** Redundancy detection that identifies duplicate explanations across articles and recommends consolidation into the canonical location defined by the taxonomy.

### Problem 5: Structural inconsistency

**What happened:** Article 01 lived in `02-getting-started/` subfolder while all other articles were at the series root. Empty placeholder subfolders (`01-overview/`, `03-concepts/`, etc.) suggested an intended reorganization that was never completed.

**Taxonomy implication:** The taxonomy's subject folder template defines a clear structure, but migrating existing content into that structure is a significant effort that needs tooling support.

**Automation need:** Structure validation that compares a subject's actual file layout against the taxonomy template and generates a migration plan.

### Problem 6: Two-layer content tension

**What happened:** Articles like 04 (agent files, ~1,750 lines) mixed comprehensive product documentation (YAML schema, property reference tables) with usage guidance (design patterns, best practices, anti-patterns). This made the articles large, hard to maintain, and difficult to update when only the product spec changed.

**Taxonomy implication:** This is the core tension the taxonomy's seven categories are designed to resolve. Product knowledge belongs in `03-concepts/` and `06-reference/`. Usage mastery belongs in `04-howto/` and `05-analysis/`. By separating them, each layer can evolve independently:

| Layer | Content type | Update trigger | Maintenance pattern |
|-------|-------------|----------------|-------------------|
| **Product knowledge** | Concepts, Reference | Product releases, API changes | Automatable — compare against official docs |
| **Usage mastery** | How-to, Analysis | Experience, experimentation, community patterns | Author-driven — requires human insight |

---

## 🔧 Taxonomy improvements based on real-world experience

The prompt engineering review revealed several improvements needed in the taxonomy itself.

### Improvement 1: Add content-type and revalidation metadata to articles

**Problem:** There's no machine-readable way to identify what taxonomy category an article belongs to, what it's trying to achieve, or what would make it stale. Without this, revalidation is limited to surface checks (grammar, readability) instead of purpose-driven checks ("does this article still accomplish its goal?").

**Solution:** Add structured metadata to the bottom validation block that describes the article's identity, intent, and dependencies:

```yaml
article_metadata:
  # --- Identity (what is this?) ---
  content_type: "howto/patterns"            # category/subcategory from taxonomy
  content_layer: "usage-mastery"            # product-knowledge | usage-mastery | mixed
  subject: "prompt-engineering"
  subject_path: "03.00-tech/05.02-prompt-engineering/"

  # --- Intent (what does this achieve?) ---
  goal: "Teach readers how to apply proven structural patterns when writing prompt files"
  scope:
    includes:
      - "Prompt file structural patterns"
      - "Anti-patterns with corrections"
      - "Template examples for common scenarios"
    excludes:
      - "Agent file patterns (covered in article 04)"
      - "MCP server configuration"
  audience: "intermediate"                  # beginner | intermediate | advanced
  prerequisites:
    - article: "01.00-how_github_copilot_uses_markdown_and_prompt_folders.md"
      reason: "Assumes understanding of prompt file basics"

  # --- Dependencies (what makes this stale?) ---
  product_dependencies:
    - product: "VS Code GitHub Copilot"
      features: ["prompt files", "YAML frontmatter", "argument-hint"]
      min_version: "1.100"
      docs_url: "https://code.visualstudio.com/docs/copilot/copilot-customization"
    - product: "GitHub Copilot Chat"
      features: ["agent mode", "plan mode"]
      docs_url: "https://docs.github.com/en/copilot/customizing-copilot"
  
  # --- Revalidation (when and how to check?) ---
  revalidation:
    cadence: "quarterly"                    # monthly | quarterly | on-release | manual
    last_verified: "2026-02-22"
    staleness_signals:                      # what triggers early revalidation
      - "VS Code Copilot extension release"
      - "Changes to prompt file YAML schema"
    key_claims:                             # specific facts to verify
      - claim: "Prompt files support 'agent', 'plan', and 'ask' modes"
        source: "https://code.visualstudio.com/docs/copilot/copilot-customization"
      - claim: "The tools property accepts an array of tool names"
        source: "https://code.visualstudio.com/docs/copilot/copilot-customization"

  # --- Validation results (what was checked, when, by whom?) ---
  validations:
    grammar:
      status: "pass"                        # pass | fail | warning | not_run
      score: 95                             # 0-100 where applicable
      last_run: "2026-02-22T14:30:00Z"      # ISO 8601 timestamp
      performed_by: "grammar-review.prompt.md"  # prompt, agent, or MCP tool that ran it
      notes: "2 minor issues fixed"         # optional summary
    technical_writing:
      status: "pass"
      score: 88
      last_run: "2026-02-22T14:35:00Z"
      performed_by: "readability-review.prompt.md"
    structure:
      status: "pass"
      score: 100
      last_run: "2026-02-22T14:32:00Z"
      performed_by: "structure-validation.prompt.md"
    topic_coverage:
      status: "not_run"
      last_run: null
      performed_by: null
    topic_gaps:
      status: "not_run"
      last_run: null
      performed_by: null
    redundancy:
      status: "not_run"
      last_run: null
      performed_by: null
    fact_checking:
      status: "warning"
      score: 72
      last_run: "2026-02-20T09:00:00Z"
      performed_by: "fact-checking.prompt.md"
      notes: "3 claims need re-verification against VS Code 1.108"
    logical_sequence:
      status: "pass"
      score: 90
      last_run: "2026-02-22T14:40:00Z"
      performed_by: "logic-analysis.prompt.md"
    relevance:
      status: "not_run"
      last_run: null
      performed_by: null
    naming:
      status: "pass"
      last_run: "2026-02-22T14:28:00Z"
      performed_by: "iqpilot/metadata/validate"
    reachability:
      status: "not_run"
      last_run: null
      performed_by: null
    links:
      status: "pass"
      last_run: "2026-02-22T14:29:00Z"
      performed_by: "iqpilot/xref/validate"
      notes: "12 internal links, 4 external — all resolved"
```

Each validation entry records four pieces of information:

| Field | Purpose | How automation uses it |
|-------|---------|----------------------|
| `status` | Current result: `pass`, `fail`, `warning`, `not_run` | Pre-publish gate blocks on any `fail` in critical dimensions |
| `score` | Numeric quality score (0–100) where applicable | Subject health dashboard aggregates scores across articles |
| `last_run` | ISO 8601 timestamp of when this dimension was last evaluated | Triage scheduler compares against `revalidation.cadence` to identify stale validations |
| `performed_by` | Identity of the prompt, agent, or MCP tool that ran the check | Audit trail — know exactly what tool produced each result; enables re-running the same tool |
| `notes` | Optional human-readable summary of findings | Quick triage without re-reading full validation output |

**Staleness detection logic:**

A validation result is considered **stale** when any of these conditions is true:

1. `last_run` is older than the article's `revalidation.cadence` (e.g., >90 days for quarterly)
2. `last_run` is older than the article's `last_updated` timestamp (content changed after validation)
3. A `staleness_signal` event occurred after `last_run` (e.g., VS Code released a new version)
4. A `product_dependency` changelog entry matches `alert_keywords` after `last_run`

When a validation is stale, the triage scheduler flags it for re-execution using the same `performed_by` tool, ensuring consistency.

The table below explains how each metadata group enables different automation capabilities:

| Metadata group | Fields | Automation it enables |
|---------------|--------|----------------------|
| **Identity** | `content_type`, `content_layer`, `subject` | Taxonomy compliance checks, coverage reports, decomposition detection |
| **Intent** | `goal`, `scope`, `audience`, `prerequisites` | Goal-driven revalidation ("does the article still achieve this?"), scope-creep detection, audience-appropriate readability targets |
| **Dependencies** | `product_dependencies` | Freshness monitoring (fetch docs_url, compare features against current state), version-triggered revalidation |
| **Revalidation** | `cadence`, `last_verified`, `staleness_signals`, `key_claims` | Scheduled review automation, claim-by-claim fact-checking, priority triage (overdue articles first) |
| **Validations** | `status`, `score`, `last_run`, `performed_by`, `notes` | Audit trail, staleness detection, re-execution targeting, subject health dashboards |

**How revalidation uses this metadata:**

1. **Freshness monitor** reads `product_dependencies` → fetches each `docs_url` → compares documented features against `key_claims` → flags mismatches → updates `validations.fact_checking`
2. **Taxonomy guardian** reads `content_type` and `scope` → checks that actual content stays within declared scope → flags scope creep → updates `validations.relevance`
3. **Triage scheduler** reads `revalidation.cadence` and each `validations.*.last_run` → identifies stale validations → prioritizes by `content_layer` (product-knowledge articles first, since they go stale faster) → queues re-execution using the original `performed_by` tool
4. **Readability calibrator** reads `audience` → adjusts Flesch target (beginner: 60-70, intermediate: 50-60, advanced: 40-50) → updates `validations.technical_writing`
5. **Prerequisite validator** reads `prerequisites` → verifies linked articles exist and haven't changed scope
6. **Subject health dashboard** aggregates all `validations.*.status` and `score` values across articles → surfaces worst scores and oldest `last_run` timestamps first

### Improvement 2: Add subject-level metadata

**Problem:** The taxonomy defines subject folders but doesn't have a manifest file that declares what a subject covers, what its boundaries are, and what external products it depends on. Without this, gap analysis and freshness monitoring have no anchor point.

**Solution:** Add a `_subject.yml` file to each subject folder. This manifest serves as the **single source of truth** for a subject's scope, structure, dependencies, and monitoring configuration:

```yaml
# 05.02-prompt-engineering/_subject.yml
subject:
  name: "Prompt Engineering for GitHub Copilot"
  description: "Comprehensive guide to GitHub Copilot customization"
  version: "1.0"

  # --- Intent (what does this subject cover?) ---
  goal: >
    Enable readers to master GitHub Copilot's customization stack—from basic
    prompt files through agents, hooks, and MCP integration—with enough
    depth to build production-quality AI workflows.
  scope:
    includes:
      - "Prompt files (.prompt.md) — creation, naming, structure, patterns"
      - "Agent files (.agent.md) — configuration, boundaries, tool alignment"
      - "Instruction files — global, folder-level, and inline"
      - "Hooks — PreToolUse, PostToolUse, custom event hooks"
      - "MCP integration — server configuration, tool usage in prompts"
      - "Subagent orchestrations — runSubagent, multi-agent workflows"
    excludes:
      - "MCP server development (covered in 07.00-projects/)"
      - "Azure-specific prompt patterns (covered in 02.01-azure/)"
      - "General AI/LLM theory (covered in other subjects)"
  audience: "intermediate"                  # beginner | intermediate | advanced
  prerequisite_subjects:
    - path: "03.00-tech/05.01-github/"
      reason: "GitHub basics and Copilot subscription assumed"

  # --- Categories (taxonomy coverage) ---
  categories:
    overview:
      status: planned
      articles: []
    getting-started:
      status: published
      articles:
        - path: "02-getting-started/01.00-how_github_copilot_uses_markdown_and_prompt_folders.md"
    concepts:
      status: planned
      articles: []
    howto:
      status: published
      articles:
        - path: "02.00-how_to_name_and_organize_prompt_files.md"
        - path: "03.00-how_to_write_effective_copilot_instructions.md"
        # ... all how-to articles
    analysis:
      status: planned
      articles: []
    reference:
      status: planned
      articles: []
    resources:
      status: planned
      articles: []

  # --- Dependencies (what external products does this subject track?) ---
  product_dependencies:
    - product: "VS Code"
      relevance: "Primary IDE for Copilot customization"
      changelog: "https://code.visualstudio.com/updates"
      docs:
        - "https://code.visualstudio.com/docs/copilot/copilot-customization"
        - "https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode"
    - product: "GitHub Copilot"
      relevance: "Core product being documented"
      changelog: "https://github.blog/changelog/"
      docs:
        - "https://docs.github.com/en/copilot/customizing-copilot"
        - "https://docs.github.com/en/copilot/using-github-copilot/using-extensions-to-integrate-external-tools-with-copilot-chat"

  # --- Monitoring and revalidation ---
  monitoring:
    review_cadence: "monthly"
    last_reviewed: "2026-02-22"
    staleness_signals:
      - "VS Code monthly release (features may change)"
      - "GitHub Copilot extension updates"
      - "New Copilot Chat capabilities announced on github.blog"
    alert_keywords:                         # terms to watch in changelogs
      - "prompt file"
      - "agent mode"
      - "copilot customization"
      - "instruction file"
      - "model context protocol"
      - "runSubagent"
```

**How subject-level metadata drives automation:**

| Metadata section | Automation it enables |
|-----------------|----------------------|
| **`goal` + `scope`** | Gap analysis compares `scope.includes` against actual article coverage — anything listed but not covered is a gap. Scope creep detection flags articles drifting into `scope.excludes` territory. |
| **`categories`** | Coverage matrix generation — instantly shows which taxonomy categories have content and which are empty. Enables "subject health dashboard" reporting. |
| **`product_dependencies`** | Freshness monitor fetches each `changelog` URL and scans for `alert_keywords`. When a keyword appears in a recent changelog entry, it triggers revalidation of articles depending on that product. |
| **`monitoring`** | Triage scheduler reads `review_cadence` and `last_reviewed` to surface overdue subjects. `staleness_signals` provide human-readable context for why a review is needed. |
| **`prerequisite_subjects`** | Cross-subject dependency tracking — if a prerequisite subject changes scope, downstream subjects may need updating. |

### Improvement 3: Define comprehensive validation dimensions per content type

**Problem:** The taxonomy's "Validation integration strategy" section lists validation priorities but doesn't connect them to executable prompts. Validation is also incomplete—it covers language quality but misses topic coverage, logical coherence, naming conventions, navigation reachability, and link integrity.

**Solution:** Define **12 validation dimensions** as the complete validation surface, then map each to a prompt or MCP tool and specify which dimensions are critical for each content type.

#### The 12 validation dimensions

The table below describes each validation dimension, what it checks, and which tool handles it. Dimensions are grouped by what they validate:

**Content quality:**

| # | Dimension | What it checks | Tool | New? |
|---|-----------|---------------|------|------|
| 1 | **Grammar correctness** | Spelling, punctuation, sentence structure, contractions, capitalization | `grammar-review.prompt.md` | Exists |
| 2 | **Technical writing compliance** | Microsoft Writing Style Guide adherence: active voice, plain language, sentence-style caps, Oxford commas, second person | `readability-review.prompt.md` | Exists |
| 3 | **Structure validation** | Required sections present, heading hierarchy (H1→H2→H3), TOC accuracy, frontmatter completeness, validation metadata block | `structure-validation.prompt.md` | Exists |

**Content completeness:**

| # | Dimension | What it checks | Tool | New? |
|---|-----------|---------------|------|------|
| 4 | **Topic coverage** | Article addresses all aspects declared in its `scope.includes` metadata; no promised topics are missing | `topic-coverage-check.prompt.md` | **New** |
| 5 | **Topic gaps** | Missing information, perspectives, or subtopics that the audience would expect based on the article's `goal` and `content_type` | `gap-analysis.prompt.md` | Exists |
| 6 | **Redundancy detection** | Duplicate explanations within the article or across sibling articles in the same subject; orphaned content from earlier drafts | `redundancy-check.prompt.md` | **New** |

**Content accuracy:**

| # | Dimension | What it checks | Tool | New? |
|---|-----------|---------------|------|------|
| 7 | **Fact-checking** | Technical claims verified against official documentation; API signatures, version numbers, feature descriptions, and configuration options match current product state | `fact-checking.prompt.md` | Exists |

**Content coherence:**

| # | Dimension | What it checks | Tool | New? |
|---|-----------|---------------|------|------|
| 8 | **Logical sequence** | Ideas progress from simple to complex; prerequisites appear before dependent content; steps follow a testable order | `logic-analysis.prompt.md` | Exists |
| 9 | **Relevance validation** | Every section contributes to the article's declared `goal`; no scope creep into territory declared in `scope.excludes` | `taxonomy-compliance-validation.prompt.md` | **New** |

**Infrastructure integrity:**

| # | Dimension | What it checks | Tool | New? |
|---|-----------|---------------|------|------|
| 10 | **Article naming** | Filename follows kebab-case convention with numeric prefix; matches `article_metadata.filename`; no spaces, uppercase, or special characters | `iqpilot/metadata/validate` (MCP) | Extend |
| 11 | **Reachability from menu** | Article appears in `_quarto.yml` navigation; rendered page is accessible from the site menu | `iqpilot/navigation/check` (MCP) | **New** |
| 12 | **Links validation** | All internal cross-references resolve to existing files; anchor fragments (`#section`) match actual headings; external URLs return HTTP 200 | `iqpilot/xref/validate` (MCP) | **New** |

#### Validation mapping per content type

Each content type requires all 12 dimensions but with different **priority weightings**. The table below marks dimensions as critical (must pass before publication), recommended (should pass), or optional (nice to have) for each type.

```yaml
# In _subject.yml or as a global taxonomy configuration
validation_dimensions:
  # --- Content quality ---
  grammar:
    tool: "grammar-review.prompt.md"
    description: "Spelling, punctuation, sentence structure"
  technical_writing:
    tool: "readability-review.prompt.md"
    description: "MS Writing Style Guide compliance, Flesch score"
  structure:
    tool: "structure-validation.prompt.md"
    description: "Required sections, heading hierarchy, TOC"
  
  # --- Content completeness ---
  topic_coverage:
    tool: "topic-coverage-check.prompt.md"
    description: "All scope.includes topics addressed"
  topic_gaps:
    tool: "gap-analysis.prompt.md"
    description: "Missing information the audience would expect"
  redundancy:
    tool: "redundancy-check.prompt.md"
    description: "Duplicate content within or across articles"
  
  # --- Content accuracy ---
  fact_checking:
    tool: "fact-checking.prompt.md"
    description: "Technical claims verified against official docs"

  # --- Content coherence ---
  logical_sequence:
    tool: "logic-analysis.prompt.md"
    description: "Progressive complexity, prerequisite ordering"
  relevance:
    tool: "taxonomy-compliance-validation.prompt.md"
    description: "Content stays within declared scope"
  
  # --- Infrastructure integrity ---
  naming:
    tool: "iqpilot/metadata/validate"
    description: "Kebab-case filename, numeric prefix, metadata match"
  reachability:
    tool: "iqpilot/navigation/check"
    description: "Article appears in _quarto.yml navigation"
  links:
    tool: "iqpilot/xref/validate"
    description: "Internal refs resolve, external URLs return 200"

# Priority mapping per content type
# C = critical (must pass), R = recommended, O = optional
validation_mapping:
  overview:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C        # Must cover the "why care?" angle
    topic_gaps: R
    redundancy: O
    fact_checking: R          # Overview claims should be accurate but aren't deeply technical
    logical_sequence: R
    relevance: C              # Must not drift into how-to territory
    naming: C
    reachability: C
    links: C
    special: "Must answer 'why does this subject matter?'"

  getting-started:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C        # Must cover minimum viable knowledge
    topic_gaps: C             # Beginners can't fill gaps themselves
    redundancy: R
    fact_checking: C          # Wrong steps = broken first experience
    logical_sequence: C       # Critical — beginners depend on step order
    relevance: C
    naming: C
    reachability: C           # Must be discoverable — it's the entry point
    links: C
    special: "Every step must be executable by a beginner"

  concepts:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C
    topic_gaps: C             # Concepts must be comprehensive
    redundancy: C             # This IS the canonical source — no duplication
    fact_checking: C          # Product knowledge must match current state
    logical_sequence: C       # Ideas must build on each other
    relevance: C              # Must not contain procedural steps
    naming: C
    reachability: R
    links: C
    special: "Must be the single authoritative source for each concept"

  howto/task-guides:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C
    topic_gaps: R
    redundancy: R
    fact_checking: C          # Wrong instructions = failed tasks
    logical_sequence: C       # Steps must be in testable order
    relevance: C              # Must not contain conceptual explanations
    naming: C
    reachability: R
    links: C
    special: "Every step must be independently testable"

  howto/patterns:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C
    topic_gaps: R
    redundancy: C             # Patterns must not duplicate each other
    fact_checking: C          # Pattern examples must use current syntax
    logical_sequence: R
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Each pattern must include problem, solution, and example"

  howto/techniques:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: R
    topic_gaps: R
    redundancy: R
    fact_checking: C          # Technique demonstrations must work
    logical_sequence: C
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Must include before/after comparison"

  howto/methodology:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C
    topic_gaps: C
    redundancy: R
    fact_checking: R          # Methodology draws on principles, not product specs
    logical_sequence: C       # Methodology depends on correct ordering
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Must connect theory to practice"

  analysis/technology-radar:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: R
    topic_gaps: C             # Missing technologies = blind spots
    redundancy: R
    fact_checking: C          # Technology assessments must reflect current state
    logical_sequence: R
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Must use ADOPT/TRIAL/ASSESS/HOLD framework"

  analysis/comparative:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C        # Must cover all compared items equally
    topic_gaps: R
    redundancy: R
    fact_checking: C          # Comparisons must use accurate data for all items
    logical_sequence: R
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Must use consistent evaluation criteria across all items"

  analysis/strategy:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: C
    topic_gaps: R
    redundancy: R
    fact_checking: C          # Strategy recommendations must be based on verified facts
    logical_sequence: C
    relevance: C
    naming: C
    reachability: R
    links: C
    special: "Must connect recommendations to evidence"

  analysis/trends:
    grammar: C
    technical_writing: C
    structure: C
    topic_coverage: R
    topic_gaps: R
    redundancy: R
    fact_checking: C          # Trend claims must cite verifiable sources
    logical_sequence: R
    relevance: C
    naming: C
    reachability: R
    links: C                  # External trend sources must be reachable
    special: "Must cite primary sources for each trend claim"

  reference:
    grammar: C
    technical_writing: R      # Formal tone acceptable
    structure: C
    topic_coverage: C         # Must mirror actual system completely
    topic_gaps: C             # Missing parameters/properties = bugs
    redundancy: C             # One canonical definition per item
    fact_checking: C          # THE most critical — reference IS the source of truth
    logical_sequence: R       # Alphabetical or grouped, not narrative
    relevance: C
    naming: C
    reachability: C           # Must be findable for quick lookup
    links: C
    special: "Must mirror actual system — every property, parameter, return value"

  resources:
    grammar: C
    technical_writing: R
    structure: C
    topic_coverage: R
    topic_gaps: R
    redundancy: C             # No duplicate resource listings
    fact_checking: R          # Resource descriptions should be accurate
    logical_sequence: R
    relevance: C              # Every resource must be relevant to the subject
    naming: C
    reachability: R
    links: C                  # Resource links MUST work — they're the content
    special: "Every resource must include classification emoji and description"
```

#### How automation uses this mapping

The validation mapping enables three automation patterns:

1. **Pre-publish gate:** Before marking an article as `publish-ready`, run all dimensions marked `C` (critical) for its content type. Block publication if any critical dimension fails.

2. **Targeted revalidation:** When a product dependency triggers revalidation, don't re-run all 12 dimensions. Instead:
   - Product release → run `fact_checking`, `topic_coverage`, `topic_gaps`, `relevance`, `links`
   - Article renamed → run `naming`, `reachability`, `links`
   - Series restructured → run `links`, `reachability`, `redundancy`

3. **Subject health dashboard:** Aggregate per-article dimension scores into a subject-level matrix showing which articles pass/fail which dimensions. Surface the worst scores first.

### Improvement 4: Define content decomposition rules

**Problem:** No guidance exists for when and how to split a "mixed" article into taxonomy-aligned pages.

**Solution:** Add decomposition rules to the taxonomy:

**When to decompose:**
- Article exceeds 1,500 lines AND mixes product knowledge with usage mastery
- Article contains reference tables (>50 rows) alongside narrative content
- Article's product-knowledge sections need updates more than twice per year

**Decomposition pattern:**
1. Extract product-knowledge sections → `03-concepts/` page
2. Extract reference tables and schemas → `06-reference/` page
3. Refocus remaining howto content → `04-howto/` page (tighter, more focused)
4. Add cross-references between all three pages
5. Update `_subject.yml` manifest

---

## 🏗️ The automation architecture

The Learning Hub content lifecycle is automated through four layers, each using the appropriate tool for its scope.

The table below describes the four layers and their responsibilities. For each layer:
- **Scope** indicates the operational boundary (single file, multi-file, cross-cutting)
- **Trigger** describes what initiates the operation
- **Example** shows a typical use case

| Layer | Tool | Scope | Trigger | Example |
|-------|------|-------|---------|---------|
| **1. Prompts** | `.prompt.md` files | Single article | User invokes | Grammar review, readability check |
| **2. Agents** | `.agent.md` files | Multi-article | User invokes | Series review, taxonomy compliance |
| **3. Subagent orchestrations** | Agent + `runSubagent` | Cross-cutting | User invokes coordinator | Full content lifecycle audit |
| **4. MCP server** | IQPilot (C#) | Infrastructure | Programmatic | Metadata sync, validation caching, file operations |

### Why four layers?

Each layer addresses a different automation need:

- **Prompts** are lightweight and focused—ideal for single-article quality checks that run in seconds
- **Agents** have persistent context and tool access—ideal for multi-file analysis that requires reading, comparing, and reasoning
- **Subagent orchestrations** coordinate multiple specialists—ideal for complex workflows where no single agent has all the expertise
- **MCP servers** provide deterministic, fast operations—ideal for file I/O, metadata parsing, and caching where AI reasoning isn't needed

---

## 📋 Layer 1: Prompts — single-article operations

Prompts are the atomic units of the content lifecycle. They serve two distinct purposes:

- **Creative prompts** operate *before and during writing* — they research topics, explore approaches, generate outlines, and provide creative critique
- **Validation prompts** operate *after writing* — they check grammar, structure, compliance, and freshness

Both follow the same single-article scope, but creative prompts are generative (they produce new content and ideas) while validation prompts are evaluative (they assess existing content against standards).

### Existing prompts (already implemented)

| Prompt | Purpose | Type | Taxonomy category served |
|--------|---------|------|------------------------|
| `grammar-review.prompt.md` | Language quality | Validation | All categories |
| `readability-review.prompt.md` | Flesch score, sentence complexity | Validation | All categories |
| `structure-validation.prompt.md` | Required sections, heading hierarchy | Validation | All categories |
| `fact-checking.prompt.md` | Claims against sources | Validation | Concepts, Reference, How-to |
| `logic-analysis.prompt.md` | Conceptual flow and coherence | Validation | Concepts, Analysis |
| `gap-analysis.prompt.md` | Missing information | Validation | All categories |
| `understandability-review.prompt.md` | Audience-appropriate complexity | Validation | All categories |
| `publish-ready.prompt.md` | Pre-publication checklist | Validation | All categories |

### New creative prompts

These prompts support the research and development phases of content creation. They run *before* an article is written, helping the author explore the topic space, gather evidence, and choose the most effective approach.

#### 1. `topic-research.prompt.md`

**Purpose:** Research a topic thoroughly before writing, gathering official documentation, community perspectives, and identifying the unique angle this article should take.

**Why needed:** Writers often jump straight into drafting without surveying what already exists. This leads to articles that duplicate official docs, miss important perspectives, or fail to offer original value. Research-first writing produces more focused, differentiated content.

```yaml
---
name: topic-research
description: "Research a topic by gathering official docs, community perspectives, and identifying the article's unique angle"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - fetch_webpage
  - semantic_search
  - grep_search
argument-hint: 'Describe the topic you want to research'
---
```

**Key outputs:**
- Official documentation summary (what Microsoft/GitHub already covers, with links)
- Community landscape (notable blog posts, tutorials, conference talks on this topic)
- Knowledge gaps (what existing sources don't cover or cover poorly)
- Unique angle recommendation (the specific perspective or value-add this article should provide)
- Key claims to make (facts that will anchor the article, with source links for verification)
- Suggested references list with classification emojis

#### 2. `approach-explorer.prompt.md`

**Purpose:** Generate and compare multiple ways to structure and present an article, then recommend the strongest approach.

**Why needed:** The first structural idea isn't always the best. This prompt encourages divergent thinking—exploring narrative approaches, organizational patterns, and presentation styles—before committing to a structure. It's especially valuable for complex topics where the "obvious" structure (chronological, feature-by-feature) may not be the most effective for learning.

```yaml
---
name: approach-explorer
description: "Generate and compare multiple structural approaches for an article, recommending the strongest one"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - semantic_search
  - grep_search
argument-hint: 'Describe the topic and attach any research notes with #file'
---
```

**Key outputs:**
- Three to five distinct structural approaches, each with:
  - Name and one-sentence description
  - Proposed outline (H2/H3 headings)
  - Strengths (what this approach does well)
  - Weaknesses (what it sacrifices or risks)
  - Best suited for (which audience level and content type)
- Comparative matrix scoring each approach on: clarity, completeness, engagement, maintainability
- Recommended approach with rationale
- Risk assessment: what could go wrong with the recommended approach and how to mitigate it

#### 3. `outline-generator.prompt.md`

**Purpose:** Transform a chosen approach into a detailed, taxonomy-compliant article outline with section descriptions, estimated word counts, and source assignments.

**Why needed:** The gap between "I know the approach" and "I have a detailed plan" is where many articles stall. This prompt bridges that gap by producing a complete blueprint that the author can fill in section by section, with each section's purpose and sources pre-identified. It also ensures the outline respects the taxonomy's content-type requirements from the start.

```yaml
---
name: outline-generator
description: "Generate a detailed, taxonomy-compliant article outline from a chosen approach"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - semantic_search
  - grep_search
argument-hint: 'Describe the topic, content type, and chosen approach. Attach research notes with #file'
---
```

**Key outputs:**
- Complete heading hierarchy (H1 through H3) with section descriptions
- Per-section specification:
  - Purpose (what this section accomplishes for the reader)
  - Key points to cover
  - Sources to cite (from research phase)
  - Estimated word count
  - Content type alignment (confirms section belongs in this article, not a sibling)
- Required article metadata (suggested `content_type`, `goal`, `scope`, `audience`)
- Taxonomy compliance pre-check (validates outline against content-type requirements before writing begins)
- Cross-reference plan (planned links to existing articles in the same subject)

### New validation prompts

#### 4. `taxonomy-compliance-validation.prompt.md`

**Purpose:** Verify an article conforms to its declared taxonomy category.

**Why needed:** Articles tend to drift from their category over time. A how-to guide accumulates conceptual explanations; a concepts page grows procedural steps.

```yaml
---
name: taxonomy-compliance-validation
description: "Verify article conforms to its taxonomy category requirements"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - semantic_search
  - grep_search
argument-hint: 'Attach the article to check with #file'
---
```

**Key checks:**
- Read article's `content_type` from bottom metadata
- Load category requirements from taxonomy document
- Validate required sections present
- Detect content that belongs in a different category (conceptual content in how-to, procedural content in concepts)
- Report compliance score and specific violations

#### 5. `content-freshness-validation.prompt.md`

**Purpose:** Detect stale product knowledge by comparing against official documentation.

**Why needed:** Product knowledge articles go stale with every release. This prompt checks whether the article's technical claims still match current official documentation.

```yaml
---
name: content-freshness-validation
description: "Compare article's product claims against current official documentation"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - fetch_webpage
  - semantic_search
argument-hint: 'Attach the article and provide official doc URLs'
---
```

**Key checks:**
- Extract technical claims from article (versions, API signatures, feature descriptions)
- Fetch latest official documentation
- Compare claims against current state
- Report: current, outdated, removed, new-feature-not-covered
- Estimate freshness score as percentage of claims still accurate

#### 6. `cross-reference-validation.prompt.md`

**Purpose:** Validate all internal cross-references in an article.

**Why needed:** Cross-references break silently when articles are renamed, moved, or renumbered.

```yaml
---
name: cross-reference-validation
description: "Validate internal links and cross-references in an article"
agent: agent
model: claude-opus-4.6
tools:
  - read_file
  - file_search
  - list_dir
  - replace_string_in_file
argument-hint: 'Attach the article to validate with #file'
---
```

**Key checks:**
- Extract all internal links (`[text](path)`)
- Verify each target file exists
- Check anchor fragments (`#section-name`) resolve
- Verify "Related articles" section matches actual series content
- Auto-fix broken references when possible

#### 7. `content-decomposition-analysis.prompt.md`

**Purpose:** Analyze a mixed article and produce a decomposition plan.

**Why needed:** Large articles that mix product knowledge and usage mastery need systematic decomposition into taxonomy-aligned pages.

```yaml
---
name: content-decomposition-analysis
description: "Analyze mixed article and produce taxonomy decomposition plan"
agent: plan
model: claude-opus-4.6
tools:
  - read_file
  - semantic_search
  - grep_search
argument-hint: 'Attach the article to analyze with #file'
---
```

**Key outputs:**
- Content classification: each section tagged as product-knowledge or usage-mastery
- Proposed target locations (concepts, howto, reference pages)
- Cross-reference plan showing how decomposed pages link together
- Migration risk assessment

---

## 🤖 Layer 2: Agents — specialized roles

Agents are persistent specialists that handle multi-file analysis and complex workflows. Each agent has a narrow role, specific tool access, and clear boundaries.

Like the prompts layer, agents serve two purposes: **creative agents** research and explore *before* content exists, while **compliance agents** monitor and validate *after* content is written. This mirrors the creative/validation split at the prompt level, but agents operate across multiple files and have persistent context for deeper analysis.

### Design pattern: Six-role separation of concerns

The agents follow a six-role pattern organized into two groups:

**Creative roles** (generative — produce new ideas and plans):

- **Researcher** (read-only) — Investigates external sources, gathers evidence, maps the topic landscape
- **Explorer** (read-only) — Generates multiple approaches, compares alternatives, recommends strategies

**Compliance roles** (evaluative — assess existing content):

- **Guardian** (read-only) — Monitors compliance and reports violations
- **Auditor** (read-only) — Analyzes multi-file consistency and detects redundancy
- **Restructurer** (read-write) — Executes structural changes approved by read-only agents
- **Monitor** (read-only) — Tracks external changes and detects content staleness

This separation ensures three things: creative work happens before commitment to a structure, analysis never accidentally modifies content, and write operations only happen after explicit approval.

### Creative agents

Creative agents operate during the research and planning phases—before an article is written or when planning major content changes. They're read-only by design: their output is plans, comparisons, and recommendations that the author (or a write-capable agent) acts on.

#### 1. `topic-researcher.agent.md`

**Role:** Deep-dive research across multiple sources for a proposed topic, producing a comprehensive research brief that anchors the writing process.

```yaml
---
description: "Topic research specialist that gathers official docs, community perspectives, and competitive landscape to produce a research brief"
agent: plan
tools:
  - read_file
  - fetch_webpage
  - semantic_search
  - grep_search
  - file_search
  - list_dir
handoffs:
  - label: "Explore approaches"
    agent: approach-explorer
    send: true
---
```

**Responsibilities:**
- Fetch and summarize official documentation for the topic's product dependencies
- Search for notable community articles, blog posts, and conference talks
- Scan existing repository content to identify what's already covered (avoid duplication)
- Identify the knowledge gaps—what no existing source covers well
- Map the topic's dependency graph (what concepts must the reader already know?)
- Produce a structured research brief with:
  - Topic landscape summary (what exists, who wrote it, how authoritative)
  - Gap analysis (what's missing or poorly covered elsewhere)
  - Unique angle recommendation (the specific value-add this content should provide)
  - Source library (URLs with classification emojis, organized by authority)
  - Risk assessment (topics that are volatile, controversial, or fast-moving)
- Hand off to `approach-explorer` when research is complete and the author is ready for structuring

**Boundaries:**
- ✅ Always: Fetch at least 3 official sources before concluding research; report confidence level; classify all sources with emoji markers
- ⚠️ Ask first: When topic scope seems too broad or too narrow for a single article; when no official documentation exists
- 🚫 Never: Write article content; modify existing files; recommend an approach without research evidence; skip existing content scan (risk of duplication)

#### 2. `approach-explorer.agent.md`

**Role:** Generate and evaluate multiple structural and narrative approaches for an article, then recommend the strongest option with evidence.

```yaml
---
description: "Content strategy specialist that generates multiple approaches, evaluates trade-offs, and recommends the strongest structure"
agent: plan
tools:
  - read_file
  - semantic_search
  - grep_search
  - file_search
  - list_dir
---
```

**Responsibilities:**
- Read the research brief (from `topic-researcher` or author-provided notes)
- Read the taxonomy's content-type requirements for the target category
- Generate 3–5 distinct structural approaches, varying by:
  - Narrative frame (problem-first, concept-first, example-first, comparison-driven)
  - Organizational pattern (sequential, hierarchical, matrix, progressive disclosure)
  - Level of abstraction (conceptual overview vs deep technical walkthrough)
- For each approach, produce:
  - Proposed outline (H2/H3 headings with one-sentence descriptions)
  - Strengths and weaknesses
  - Audience alignment score (how well it serves the target audience level)
  - Taxonomy compliance assessment (does this structure satisfy the content-type requirements?)
  - Maintainability forecast (how easy to update when products change?)
- Build a comparative matrix scoring all approaches on: clarity, completeness, engagement, maintainability, and taxonomy compliance
- Recommend the strongest approach with explicit rationale
- Identify risks and mitigation strategies for the recommended approach

**Boundaries:**
- ✅ Always: Generate at least 3 approaches; include taxonomy compliance in evaluation; consider maintainability (not just initial quality)
- ⚠️ Ask first: When all approaches score similarly (let the author choose); when the topic seems to need multiple articles rather than one
- 🚫 Never: Write article content; select an approach and proceed without author approval; ignore taxonomy content-type requirements; recommend only one approach without alternatives

### Compliance agents

Compliance agents operate after content exists—during review, maintenance, and evolution phases. They detect problems, measure quality, and recommend fixes.

#### 3. `taxonomy-guardian.agent.md`

**Role:** Monitor and enforce taxonomy compliance across a subject's content.

```yaml
---
description: "Taxonomy compliance specialist that monitors content categorization and structural alignment"
agent: plan
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - semantic_search
  - fetch_webpage
handoffs:
  - label: "Fix Compliance Issues"
    agent: content-restructurer
    send: true
---
```

**Responsibilities:**
- Read `_subject.yml` manifest to understand subject structure
- Scan all articles for `content_type` metadata
- Compare actual content against declared category requirements
- Detect mixed content that should be decomposed
- Generate taxonomy compliance report with per-article scores
- Compare subject coverage against taxonomy template (identify missing categories)
- Hand off structural fixes to `content-restructurer`

**Boundaries:**
- ✅ Always: Read all articles before analysis; cite specific sections for violations
- ⚠️ Ask first: Before recommending article decomposition
- 🚫 Never: Modify files; skip manifest check; approve mixed content without flagging

#### 4. `content-freshness-monitor.agent.md`

**Role:** Detect stale product knowledge across a subject by comparing against external sources.

```yaml
---
description: "Product knowledge freshness specialist that detects stale content by comparing against official documentation"
agent: plan
tools:
  - read_file
  - fetch_webpage
  - grep_search
  - file_search
  - semantic_search
---
```

**Responsibilities:**
- Read `_subject.yml` to get monitoring URLs (official docs, changelogs)
- Fetch latest official documentation pages
- Compare product claims in articles against current state
- Detect new features not covered in any article
- Detect deprecated features still presented as current
- Generate freshness report with:
  - Per-article freshness score
  - List of stale claims with source links
  - List of uncovered new features
  - Priority ranking for updates

**Boundaries:**
- ✅ Always: Fetch official docs before comparing; report confidence level for each finding
- ⚠️ Ask first: When official docs are ambiguous or contradictory
- 🚫 Never: Update articles directly; assume stale without evidence; skip changelog review

#### 5. `series-coherence-auditor.agent.md`

**Role:** Audit an article series for consistency, redundancy, and logical progression.

```yaml
---
description: "Series-level content auditor for consistency, redundancy detection, and progression analysis"
agent: plan
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - semantic_search
handoffs:
  - label: "Fix Series Issues"
    agent: content-restructurer
    send: true
---
```

**Responsibilities:**
- Read all articles in a series sequentially
- Build terminology cross-reference matrix
- Detect redundant explanations (same concept in multiple articles)
- Validate cross-references and "Related articles" sections
- Assess logical progression (beginner → advanced)
- Verify heading format consistency
- Generate coherence report with specific line references

This agent encapsulates the manual work performed during the prompt engineering series review, making it repeatable and consistent.

#### 6. `content-restructurer.agent.md`

**Role:** Execute structural changes: decompose articles, migrate files, update cross-references.

```yaml
---
description: "Content restructuring specialist that executes taxonomy-aligned decompositions and migrations"
agent: agent
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - multi_replace_string_in_file
  - file_search
  - grep_search
  - list_dir
---
```

**Responsibilities:**
- Execute decomposition plans produced by `taxonomy-guardian`
- Create new taxonomy-aligned files from extracted content
- Update all cross-references across affected articles
- Update `_subject.yml` manifest
- Update `_quarto.yml` navigation
- Validate no broken links remain after restructuring

**Boundaries:**
- ✅ Always: Work from an approved decomposition plan; backup original before modification
- ⚠️ Ask first: Before deleting original article; when decomposition creates >5 new files
- 🚫 Never: Restructure without a plan; modify content beyond structural changes; skip cross-reference update

---

## 🎭 Layer 3: Subagent orchestrations — multi-agent workflows

Subagent orchestrations coordinate multiple agents for complex workflows that span the entire content lifecycle.

### Orchestration 1: Full subject audit

**Coordinator:** `subject-audit-coordinator.agent.md`

**Purpose:** Run a comprehensive audit of a subject's documentation health.

```yaml
---
description: "Coordinates comprehensive subject documentation audit using specialized subagents"
agent: agent
tools:
  - read_file
  - list_dir
  - file_search
agents:
  - taxonomy-guardian
  - content-freshness-monitor
  - series-coherence-auditor
---
```

**Workflow:**

```
subject-audit-coordinator
├── 1. taxonomy-guardian          # Check taxonomy compliance
│   └── Returns: compliance report, missing categories, mixed content
├── 2. content-freshness-monitor  # Check product knowledge currency
│   └── Returns: freshness report, stale claims, uncovered features
├── 3. series-coherence-auditor   # Check series consistency
│   └── Returns: coherence report, redundancies, broken references
└── 4. Coordinator synthesizes
    └── Produces: unified audit report with prioritized action items
```

**Key design decisions:**
- Subagents run sequentially (each needs the subject context, but their analyses are independent)
- Coordinator synthesizes findings, removing duplicates and conflicting recommendations
- Output: single prioritized action plan with estimated effort

### Orchestration 2: Content creation pipeline

**Coordinator:** `content-creation-coordinator.agent.md`

**Purpose:** Guide creation of a new article through a full research→explore→outline→write→review pipeline. This is the orchestration that addresses the document's core gap: the creative and development phases that precede validation.

```yaml
---
description: "Coordinates the full content creation lifecycle from research through publication-ready review"
agent: agent
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - list_dir
  - file_search
  - semantic_search
agents:
  - topic-researcher
  - approach-explorer
  - taxonomy-guardian
---
```

**Workflow:**

```
content-creation-coordinator
│
├── PHASE A: RESEARCH (creative — divergent)
│   ├── 1. Scope the topic
│   │   └── Reads _subject.yml → identifies gap → defines topic boundaries
│   ├── 2. topic-researcher (subagent)
│   │   └── Returns: research brief (official docs, community landscape,
│   │       knowledge gaps, unique angle, source library)
│   └── 3. Author reviews research brief (human checkpoint)
│       └── Confirms topic scope, approves angle, adds domain insight
│
├── PHASE B: EXPLORE (creative — evaluative)
│   ├── 4. approach-explorer (subagent)
│   │   └── Returns: 3-5 structural approaches with comparative matrix,
│   │       taxonomy compliance assessment, maintainability forecast
│   └── 5. Author selects approach (human checkpoint)
│       └── Picks approach (or requests hybrid), provides rationale
│
├── PHASE C: PLAN (creative — convergent)
│   ├── 6. Generate detailed outline
│   │   └── Runs outline-generator prompt with selected approach +
│   │       research brief → produces full heading hierarchy with
│   │       per-section specs, source assignments, word count estimates
│   ├── 7. taxonomy-guardian (subagent, pre-write check)
│   │   └── Validates outline against content-type requirements BEFORE
│   │       writing begins — catches structural problems early
│   └── 8. Author approves outline (human checkpoint)
│       └── Final adjustments before committing to write
│
├── PHASE D: CREATE (human-driven with AI assistance)
│   ├── 9. Create article scaffold from approved outline
│   │   └── Uses IQPilot content/create tool with outline metadata
│   ├── 10. Author writes content (human step)
│   │   └── Fills in sections using outline specs and source assignments
│   └── 11. In-progress creative support (optional, on-demand)
│       ├── topic-research prompt → for individual section deep-dives
│       └── approach-explorer prompt → when a section's structure isn't working
│
├── PHASE E: REVIEW (validation — evaluative)
│   ├── 12. taxonomy-guardian (subagent, post-write check)
│   │   └── Validates completed article against taxonomy requirements
│   ├── 13. Run quality prompts in sequence
│   │   ├── grammar-review
│   │   ├── readability-review
│   │   ├── structure-validation
│   │   ├── fact-checking (if concepts/reference/how-to)
│   │   └── logic-analysis (if concepts/analysis)
│   └── 14. Author addresses findings (human step)
│
└── PHASE F: PUBLISH (infrastructure)
    ├── 15. Update _subject.yml manifest
    ├── 16. Update _quarto.yml navigation
    └── 17. Run publish-ready prompt (final gate)
```

**Key design decisions:**
- **Three human checkpoints** (steps 3, 5, 8) ensure the author maintains creative control while benefiting from AI research and exploration
- **Pre-write taxonomy check** (step 7) catches structural problems in the outline stage—much cheaper to fix than after 1,000 lines are written
- **Creative support during writing** (step 11) is on-demand, not mandatory—some sections flow naturally, others need additional research
- **Research produces artifacts** — the research brief and approach comparison are saved alongside the article, serving as documentation of the creative process and as context for future updates
- **Separation of creative and validation phases** — Phases A–C are generative (expanding possibilities), Phase D is human-driven (applying judgment), Phase E is evaluative (measuring quality)

### Orchestration 3: Maintenance sweep

**Coordinator:** `maintenance-sweep-coordinator.agent.md`

**Purpose:** Periodic maintenance of all subjects—detect staleness, fix broken links, update metadata.

```yaml
---
description: "Coordinates periodic maintenance across all subjects in the repository"
agent: agent
tools:
  - read_file
  - list_dir
  - file_search
  - grep_search
  - replace_string_in_file
agents:
  - content-freshness-monitor
  - series-coherence-auditor
  - content-restructurer
---
```

**Workflow:**

```
maintenance-sweep-coordinator
├── For each subject folder:
│   ├── 1. content-freshness-monitor
│   │   └── Detect stale product knowledge
│   ├── 2. series-coherence-auditor
│   │   └── Detect broken refs, redundancy
│   └── 3. content-restructurer (if needed)
│       └── Fix broken references, update metadata
└── Generate: repository-wide health dashboard
```

---

## ⚙️ Layer 4: IQPilot MCP server — deterministic infrastructure

The IQPilot MCP server handles operations that should be deterministic, fast, and don't require AI reasoning. It currently provides 16 tools across four categories.

### Current IQPilot tools

| Category | Tool | Purpose |
|----------|------|---------|
| **Validation** | `iqpilot/validate/grammar` | Grammar and spelling |
| | `iqpilot/validate/readability` | Flesch score, grade level |
| | `iqpilot/validate/structure` | TOC, sections, headings |
| | `iqpilot/validate/all` | Run all validations |
| **Content** | `iqpilot/content/create` | Create from template |
| | `iqpilot/content/analyze_gaps` | Identify missing information |
| | `iqpilot/content/find_related` | Find related articles |
| | `iqpilot/content/publish_ready` | Publication readiness check |
| **Metadata** | `iqpilot/metadata/get` | Read article metadata |
| | `iqpilot/metadata/update` | Update metadata fields |
| | `iqpilot/metadata/validate` | Validate metadata structure |
| **Workflow** | `iqpilot/workflow/create_article` | Guided creation workflow |
| | `iqpilot/workflow/review_article` | Guided review workflow |
| | `iqpilot/workflow/plan_series` | Series planning |

### Proposed new IQPilot tools

The following tools address gaps discovered during the prompt engineering review.

#### `iqpilot/taxonomy/classify`

**Purpose:** Determine an article's taxonomy category from its content.

**Why MCP:** Classification rules are deterministic (section patterns, keyword analysis) and don't need AI reasoning for the initial pass.

**Parameters:**
- `filePath` (string) — Path to article
- `taxonomyPath` (string, optional) — Path to taxonomy definition

**Returns:** Suggested `content_type`, `content_layer`, confidence score, and evidence.

#### `iqpilot/taxonomy/coverage`

**Purpose:** Generate a coverage report for a subject showing which taxonomy categories have content and which are empty.

**Why MCP:** File listing and manifest reading are pure I/O operations.

**Parameters:**
- `subjectPath` (string) — Path to subject folder
- `manifestPath` (string, optional) — Path to `_subject.yml`

**Returns:** Coverage matrix showing each category's status, article count, and total word count.

#### `iqpilot/xref/validate`

**Purpose:** Validate all internal cross-references in one or more articles.

**Why MCP:** Link resolution is deterministic—check if target file exists and anchor resolves.

**Parameters:**
- `filePath` (string) — Article or folder path
- `recursive` (boolean) — Check all files in folder

**Returns:** List of broken links with source location, target path, and suggested fix.

#### `iqpilot/xref/update`

**Purpose:** Batch-update cross-references when articles are renamed or moved.

**Why MCP:** Find-and-replace across files is a deterministic operation that should be fast and reliable.

**Parameters:**
- `oldPath` (string) — Original file path or pattern
- `newPath` (string) — New file path
- `scope` (string) — Folder to scan for references

**Returns:** List of files updated with before/after for each changed reference.

#### `iqpilot/subject/manifest`

**Purpose:** Generate or update a `_subject.yml` manifest by scanning a subject folder.

**Why MCP:** Directory traversal and metadata extraction are I/O operations.

**Parameters:**
- `subjectPath` (string) — Path to subject folder
- `outputPath` (string, optional) — Where to write manifest

**Returns:** Generated manifest YAML content.

---

## 🔄 Content lifecycle workflows

This section maps the complete content lifecycle to the automation layers defined above. The lifecycle has six phases—three creative (research, develop, create), three evaluative (review, maintain, evolve). Earlier versions of this document focused almost entirely on the evaluative phases. The creative phases below ensure that content starts strong, not just finishes clean.

### Phase 1: Research — understand the landscape

Before writing anything, understand what exists, what's missing, and what unique value the new article can provide.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Identify subject gaps | Agent | `taxonomy-guardian` | Coverage matrix showing empty categories |
| Check coverage matrix | MCP | `iqpilot/taxonomy/coverage` | Per-category article count and word count |
| Research the topic deeply | Agent | `topic-researcher` | Research brief: official docs, community landscape, knowledge gaps, unique angle |
| Scan for existing coverage | Prompt | `topic-research` | What the repository already covers (avoid duplication) |
| Author reviews research brief | Human | — | Confirms scope, approves angle, adds domain insight |

### Phase 2: Develop — explore approaches and plan structure

With research in hand, explore multiple ways to present the content. This is the creative divergent phase—generate options, evaluate trade-offs, then converge on the best approach.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Explore structural approaches | Agent | `approach-explorer` | 3–5 approaches with comparative matrix |
| Author selects approach | Human | — | Chosen approach with rationale |
| Generate detailed outline | Prompt | `outline-generator` | Full heading hierarchy with per-section specs |
| Pre-write taxonomy check | Agent | `taxonomy-guardian` | Outline compliance report (catch problems before writing) |
| Author approves outline | Human | — | Final outline ready for writing |
| Create article scaffold | MCP | `iqpilot/content/create` | File with metadata, headings, and section stubs |

### Phase 3: Create — write with creative support

The author writes the article, with on-demand creative assistance available for individual sections that need deeper research or alternative structuring.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Author writes content | Human | — | Article draft |
| Section-level research (on demand) | Prompt | `topic-research` | Deep-dive into a specific section's topic |
| Section restructuring (on demand) | Prompt | `approach-explorer` | Alternative structure for a section that isn't working |
| In-line fact gathering (on demand) | Prompt | `content-freshness-validation` | Current product state for specific claims |

### Phase 4: Review — validate quality and compliance

Once the article is complete, run the evaluative pipeline to check quality across all relevant dimensions.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Taxonomy compliance | Prompt | `taxonomy-compliance-validation` | Compliance score and violations |
| Grammar and readability | MCP | `iqpilot/validate/all` | Language quality scores |
| Fact-checking | Prompt | `fact-checking` | Claim verification report |
| Structure validation | MCP | `iqpilot/validate/structure` | Section and heading compliance |
| Single-article review | Prompt | `article-review-for-consistency-gaps-and-extensions` | Comprehensive quality report |
| Series-level review | Prompt | `article-review-series-for-consistency-gaps-and-extensions` | Series coherence report |
| Full subject audit | Orchestration | `subject-audit-coordinator` | Unified audit with prioritized actions |
| Publish readiness | MCP | `iqpilot/content/publish_ready` | Go/no-go decision |

### Phase 5: Maintain — detect staleness and drift

After publication, ongoing monitoring ensures content stays accurate and relevant.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Freshness monitoring | Agent | `content-freshness-monitor` | Stale claims, uncovered features |
| Cross-reference validation | MCP | `iqpilot/xref/validate` | Broken links with suggested fixes |
| Redundancy detection | Agent | `series-coherence-auditor` | Duplicate content across articles |
| Broken link repair | MCP | `iqpilot/xref/update` | Auto-fixed references |
| Metadata sync | MCP (existing) | `iqpilot/metadata/update` | Updated validation timestamps |

### Phase 6: Evolve — restructure and improve

When articles grow too large, drift from their category, or need deeper treatment, use the creative and compliance tools together to plan and execute major changes.

| Task | Layer | Tool | Output |
|------|-------|------|--------|
| Decomposition analysis | Prompt | `content-decomposition-analysis` | Split plan with target locations |
| Research for new articles | Agent | `topic-researcher` | Research briefs for each decomposed piece |
| Explore approaches for new structure | Agent | `approach-explorer` | Structural options for the restructured content |
| Execute decomposition | Agent | `content-restructurer` | New taxonomy-aligned files |
| Update manifest | MCP | `iqpilot/subject/manifest` | Updated `_subject.yml` |
| Validate post-restructure | Orchestration | `subject-audit-coordinator` | Full audit of restructured subject |

### Visualization: Lifecycle automation flow

```
┌───────────────────────────────────────────────────────────────────────┐
│                       CONTENT LIFECYCLE                               │
│                                                                       │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌────────┐│
│  │RESEARCH │──>│ DEVELOP │──>│ CREATE  │──>│ REVIEW  │──>│PUBLISH ││
│  │         │   │         │   │         │   │         │   │        ││
│  │research │   │explore  │   │write +  │   │validate │   │gate    ││
│  │brief    │   │approaches│   │creative │   │12 dims  │   │        ││
│  │         │   │outline  │   │support  │   │         │   │        ││
│  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └───┬────┘│
│                                                               │      │
│       CREATIVE (generative)          EVALUATIVE (quality)     │      │
│  ◄──────────────────────────►  ◄──────────────────────────►   │      │
│                                                               ▼      │
│  ┌─────────┐                                            ┌─────────┐ │
│  │ EVOLVE  │◄───────────────────────────────────────────│MAINTAIN │ │
│  │         │                                            │         │ │
│  │research │   Uses BOTH creative and compliance tools  │monitor  │ │
│  │+ explore│   to plan and execute major restructuring  │freshness│ │
│  │+ restruct│                                           │links    │ │
│  └────┬────┘                                            └─────────┘ │
│       │                                                              │
│       └──────────────> Back to RESEARCH for new articles ──────────>│
│                                                                       │
│   ┌───────────────────────────────────────────────────────────────┐  │
│   │ Layer 4: MCP Server (deterministic infrastructure)             │  │
│   │  metadata sync · xref validation · coverage · scaffolding      │  │
│   ├───────────────────────────────────────────────────────────────┤  │
│   │ Layer 3: Subagent Orchestrations (multi-agent workflows)       │  │
│   │  subject audit · creation pipeline · maintenance sweep         │  │
│   ├───────────────────────────────────────────────────────────────┤  │
│   │ Layer 2: Agents (multi-file specialists)                       │  │
│   │  CREATIVE: researcher · explorer                               │  │
│   │  COMPLIANCE: guardian · monitor · auditor · restructurer       │  │
│   ├───────────────────────────────────────────────────────────────┤  │
│   │ Layer 1: Prompts (single-article operations)                   │  │
│   │  CREATIVE: topic-research · approach-explorer · outline-gen    │  │
│   │  VALIDATION: grammar · readability · structure · facts · gaps  │  │
│   └───────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 🗺️ Implementation roadmap

### Phase 1: Foundation + creative prompts (weeks 1–2)

**Goal:** Enable taxonomy-aware content management and creative research tooling.

| Task | Deliverable | Effort |
|------|-------------|--------|
| Define `_subject.yml` schema | Schema spec + example for prompt-engineering | 2 hours |
| Add `content_type` to existing articles | Metadata update for 15 prompt-eng articles | 1 hour |
| Create `topic-research.prompt.md` | Research brief generation prompt | 3 hours |
| Create `approach-explorer.prompt.md` | Multi-approach comparison prompt | 3 hours |
| Create `outline-generator.prompt.md` | Taxonomy-compliant outline generation | 2 hours |
| Create `taxonomy-compliance-validation.prompt.md` | Working prompt with tests | 3 hours |
| Create `cross-reference-validation.prompt.md` | Working prompt with tests | 2 hours |

### Phase 2: Creative + monitoring agents (weeks 3–4)

**Goal:** Enable AI-assisted research, approach exploration, and content health monitoring.

| Task | Deliverable | Effort |
|------|-------------|--------|
| Create `topic-researcher.agent.md` | Agent with multi-source research + research brief output | 4 hours |
| Create `approach-explorer.agent.md` | Agent with multi-approach generation + comparative analysis | 4 hours |
| Create `taxonomy-guardian.agent.md` | Agent with manifest reading + compliance scanning | 4 hours |
| Create `content-freshness-monitor.agent.md` | Agent with web fetch + comparison logic | 4 hours |
| Create `content-freshness-validation.prompt.md` | Single-article freshness prompt | 2 hours |
| Pilot: Research + create one article using full creative pipeline | Article created via research→explore→outline→write flow | 4 hours |

### Phase 3: IQPilot extensions (weeks 5–8)

**Goal:** Add deterministic taxonomy operations to MCP server.

| Task | Deliverable | Effort |
|------|-------------|--------|
| Implement `iqpilot/taxonomy/classify` | C# tool + tests | 8 hours |
| Implement `iqpilot/taxonomy/coverage` | C# tool + tests | 4 hours |
| Implement `iqpilot/xref/validate` | C# tool + tests | 6 hours |
| Implement `iqpilot/xref/update` | C# tool + tests | 6 hours |
| Implement `iqpilot/subject/manifest` | C# tool + tests | 4 hours |

### Phase 4: Orchestrations (weeks 9–10)

**Goal:** Enable complex multi-agent workflows including the full creation pipeline.

| Task | Deliverable | Effort |
|------|-------------|--------|
| Create `series-coherence-auditor.agent.md` | Agent with redundancy detection | 4 hours |
| Create `content-restructurer.agent.md` | Agent with decomposition execution | 6 hours |
| Create `subject-audit-coordinator.agent.md` | Coordinator orchestrating compliance subagents | 4 hours |
| Create `content-creation-coordinator.agent.md` | Coordinator orchestrating full research→create→review pipeline | 6 hours |
| Pilot: Full audit of prompt-engineering subject | Audit report + action items | 4 hours |

### Phase 5: Continuous maintenance (week 11+)

**Goal:** Establish ongoing maintenance cadence.

| Task | Deliverable | Effort |
|------|-------------|--------|
| Create `maintenance-sweep-coordinator.agent.md` | Periodic sweep orchestrator | 4 hours |
| Establish monthly review cadence | Scheduled checklist + dashboard | 1 hour/month |
| Pilot decomposition of prompt-eng article 04 | 3 taxonomy-aligned articles from 1 mixed article | 6 hours |

---

## 🎯 Conclusion

The prompt engineering series review revealed that maintaining documentation quality at scale requires systematic automation, not just good intentions. The six categories of problems discovered—staleness, cross-reference fragility, coverage gaps, redundancy, structural inconsistency, and content tension—map precisely to the Learning Hub taxonomy's structure.

But quality automation alone isn't enough. **Content must start strong, not just finish clean.** The architecture addresses both sides of the content lifecycle:

- **Creative tooling** (research, exploration, outlining) ensures articles are well-researched, thoughtfully structured, and differentiated *before* the first line is written
- **Validation tooling** (12 dimensions, compliance agents, health monitoring) ensures articles remain accurate, consistent, and well-maintained *after* publication

**Key takeaways:**

- **Research before writing produces better content.** The `topic-researcher` and `approach-explorer` agents ensure authors don't start from a blank page—they start from a research brief, a chosen structural approach, and a detailed outline.
- **Product knowledge and usage mastery must be separated** so each can evolve on its own cadence. Product knowledge is automatable (compare against official docs); usage mastery requires human insight.
- **Creative and evaluative tools work at every layer.** Prompts have creative variants (topic-research, outline-generator) alongside validation variants (grammar-review, structure-validation). Agents have creative roles (researcher, explorer) alongside compliance roles (guardian, auditor). Orchestrations weave both together.
- **The content creation pipeline has three human checkpoints** (research review, approach selection, outline approval) that keep the author in creative control while AI handles the research-intensive groundwork.
- **The taxonomy needs machine-readable metadata** (`content_type`, `_subject.yml` manifests) to enable both creative planning (gap identification, coverage analysis) and automated compliance checking.
- **Cross-reference maintenance** is the most fragile aspect of multi-article documentation and should be handled by deterministic MCP tools, not AI reasoning.

**Next steps:**

1. Review this document and decide on Phase 1 implementation priorities
2. Create the three creative prompts (`topic-research`, `approach-explorer`, `outline-generator`) first—they're immediately useful, even without the full agent infrastructure
3. Create `_subject.yml` schema and pilot with the prompt engineering subject
4. Build `taxonomy-compliance-validation.prompt.md` as the first validation automation
5. Pilot the full creative pipeline by writing one new article using research→explore→outline→write

---

## 📚 References

### Internal documentation

**[Learning Hub documentation taxonomy](../02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md)** [Internal Reference]
Defines the seven content categories, format patterns, and validation integration strategy. This document's automation architecture implements the taxonomy's "Future implementation needs" section.

**[Learning Hub introduction](../01-learning-hub-overview/01-learning-hub-introduction.md)** [Internal Reference]
Core transformation principles—information-centric, structured knowledge development, active critical analysis, collaborative learning—that guide automation design decisions.

**[Using Learning Hub for learning technologies](../01-learning-hub-overview/02-using-learning-hub-for-learning-technologies.md)** [Internal Reference]
Monitoring sources, scheduled prompts, and technology radar implementation. The freshness monitoring agent builds on this document's intelligence sources.

**[IQPilot MCP server](../../src/IQPilot/README.md)** [Internal Reference]
Technical documentation for the existing MCP server. New taxonomy-related tools extend the existing tool categories.

**[Prompt engineering series](../../03.00-tech/05.02-prompt-engineering/ROADMAP.md)** [Internal Reference]
The series whose review generated the practical lessons informing this architecture.

### GitHub Copilot customization

**[Customizing GitHub Copilot in your editor](https://code.visualstudio.com/docs/copilot/copilot-customization)** 📘 [Official]
VS Code documentation for prompt files, agent files, instructions, and MCP integration. Defines the customization primitives this architecture uses.

**[Using agent mode in VS Code](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode)** 📘 [Official]
Agent mode capabilities including `runSubagent`, tool access, and autonomous execution. Foundation for Layer 2 and Layer 3 design.

**[Model Context Protocol specification](https://modelcontextprotocol.io/)** 📘 [Official]
MCP protocol specification. Foundation for Layer 4 IQPilot extensions.

### Documentation frameworks

**[Diátaxis — A systematic approach to technical documentation](https://diataxis.fr/)** 📗 [Verified Community]
Four-type documentation framework that the Learning Hub taxonomy extends. Understanding Diátaxis is essential for understanding why the taxonomy has seven categories instead of four.

**[Microsoft Writing Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/)** 📘 [Official]
Voice, tone, and mechanics standards that all Learning Hub content follows. The grammar-review and readability-review prompts enforce these standards.

---

<!--
article_metadata:
  # --- Identity ---
  filename: "01-automated-content-lifecycle-with-prompts-agents-and-mcp.md"
  content_type: "concepts/explanation"
  content_layer: "usage-mastery"
  subject: "learning-hub"
  subject_path: "06.00-idea/learning-hub/"
  version: "1.0"
  last_updated: "2026-02-22"

  # --- Intent ---
  goal: "Define the automation architecture for maintaining Learning Hub content taxonomy using prompts, agents, and MCP"
  scope:
    includes:
      - "Validation dimensions and per-type priority mapping"
      - "Four-layer automation architecture (prompts, agents, subagents, MCP)"
      - "Article and subject metadata schemas"
      - "Content lifecycle workflows"
      - "Implementation roadmap"
    excludes:
      - "Actual prompt/agent implementation code"
      - "IQPilot MCP server C# source changes"
  audience: "intermediate"
  prerequisites:
    - article: "../02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md"
      reason: "Must understand the 7-category taxonomy this document automates"
  related:
    - "../01-learning-hub-overview/01-learning-hub-introduction.md"
    - "../02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md"
    - "../../src/IQPilot/README.md"

  # --- Revalidation ---
  revalidation:
    cadence: "quarterly"
    last_verified: "2026-02-22"
    staleness_signals:
      - "New GitHub Copilot customization features"
      - "Changes to prompt/agent file schema"
      - "IQPilot MCP server tool additions"

  # --- Validation results ---
  validations:
    grammar:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    technical_writing:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    structure:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    topic_coverage:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    topic_gaps:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    redundancy:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    fact_checking:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    logical_sequence:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    relevance:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    naming:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    reachability:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
    links:
      status: "not_run"
      score: null
      last_run: null
      performed_by: null
-->
