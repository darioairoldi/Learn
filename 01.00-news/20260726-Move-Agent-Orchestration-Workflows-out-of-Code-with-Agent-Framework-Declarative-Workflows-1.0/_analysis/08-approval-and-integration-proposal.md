---
title: "Integration record — Declarative Workflows 1.0"
publish: false
---

# Integration record

- **Integration state**: `completed` (autonomous clear-gap tech integration — additive, no existing article overwritten).
- **Mode**: tech-article.

## Taxonomy mapping & placement

| Conclusion | Taxonomy | Target path | Change |
|---|---|---|---|
| Explain Declarative Workflows 1.0 (concept + YAML + runtime + building blocks) | Concepts/How-to (Tech) | `01.00-news/20260726-…/overview.md` | Rewrote the raw stub into a full reader-facing article (matches local news convention) |
| Disambiguate vs Copilot prompt-file orchestration | How-to (Tech) | same article, cross-link section | Added a "How this relates" section linking to `03.00-tech/05.02-prompt-engineering/04-howto/10.00…` and `11.00…` |

**Placement rationale**: the news-folder convention (reverse-paradox, loop-engineering) turns `overview.md` into the reader-facing article; no dedicated `03.00-tech` agent-framework subject folder exists, and creating one for a single announcement would be premature. Matched local convention.

## Source-provenance callout

- Snapshot: reused the existing `images/001.01-article-title.png` (recognizable header banner — title + author byline). No new capture needed.
- Link: canonical DevBlogs URL with 📘 [Official] marker.
- Description: one line (author, venue, date, what it is).

## Reader-facing reframing

- Investigation "Problem statement" → reader-facing introduction to declarative workflows and their capabilities. No "problem statement" framing in the published article.

## Cross-linking

- Added related-links to the Hub's Copilot orchestration how-tos and PE orchestrator patterns, framed as an adjacent (different-layer) topic.

## What changed

- `overview.md`: raw stub → full article (frontmatter, intro, source callout, TOC, sections, references).
- `_analysis/`: working artifacts 01–05, 07, 08 created (`publish: false`).

## Meta/architecture impact

None. No vision or PE-artifact amendment; no gated plan required.
