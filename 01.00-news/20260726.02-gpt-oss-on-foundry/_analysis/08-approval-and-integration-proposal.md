---
title: "Integration record — gpt-oss one year on"
publish: false
---

# Integration record

Step 11 of `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`. Integration proceeded after the gate verdict was revised — see [artifact 03](03-source-soundness-gate-verdict.md).

## Deliverable

| | |
|---|---|
| **File** | [`overview.md`](../overview.md) |
| **Action** | Rewrite in place — triage record → reader-facing article |
| **Diátaxis type** | Explanation |
| **Integration mode** | (a) tech-article, additive |
| **Approval gate** | Not applicable — no meta or architecture amendment |

## Taxonomy mapping

| Dimension | Value | Rationale |
|---|---|---|
| **Area** | `01.00-news/` | Retained. The folder already existed from the observation capture, and the local convention is that a news folder's `overview.md` becomes the published article. |
| **Folder** | `20260726.02-gpt-oss-on-foundry` | Unchanged — renaming would break the sibling ordering and the `_analysis/` trail. |
| **Categories** | `open-weight-models`, `foundry-local`, `windows-ai`, `ai-models` | Replaces the triage-only `[triage, open-weight-models, foundry-local]`. `triage` dropped because the file is no longer a triage record. |
| **Publish state** | `publish: false` **removed** | The file is now reader-facing. |

## Placement rationale

The article was *not* placed in `03.00-tech/`, despite being explanation-type rather than news. Two reasons:

- The `_analysis/` trail, the captured source, and the provenance snapshot all live in this folder. Splitting the article away from its evidence would leave a stub.
- The consolidation article that genuinely belongs in `03.00-tech/` — the local-open-weight versus hosted-frontier tier framework — is a **different, still-unwritten** deliverable. Placing this one there would occupy the slot without filling the gap.

## Source provenance

| | |
|---|---|
| **Canonical link** | Azure Blog announcement (the upstream substance), not the Tech Community teaser |
| **Snapshot** | `images/001.01-source.png` — captured 2026-07-27 |
| **Capture method** | Headed browser, element capture of the smallest common ancestor of the `h1` and the hero image |
| **Contents** | Hero art, publication date, full title, and byline (Asha Sharma and Logan Iyer) |
| **Quality** | No scrollbars, no consent overlay, title legible |

The teaser is retained as a secondary link inside the References entry, since it's the link that was originally captured.

## Reframing note

The submitted subject ("gpt-oss launched on Azure AI Foundry") failed the gate. The **published** subject is different: *what a year of a frozen open-weight model looks like, and how the surrounding roadmaps moved*. The article therefore treats the August 2025 post as a dated baseline to measure against rather than as news, and says so in the lead.

No triage vocabulary survives in the published text — no "verdict", no "why this didn't become an article", no gate references. The research trail is linked at the end as working notes.

## Cross-linking

Seven existing Hub articles are linked from the *How this relates* section, each with a one-line descriptor explaining what it adds:

- BRK223, DEM520, DEM524, BRK225 (Build 2025)
- BRK260, OD851, BRKSP90 (Build 2026)

Direction is **one-way** (new article → existing summaries). No inbound links were added to the event summaries, so no existing top YAML was touched.

## What changed relative to the triage state

| Before | After |
|---|---|
| `publish: false` watch-item | Published article |
| Title framed as "Triaged: …" | "gpt-oss one year on: frozen weights, a moving runtime" |
| Announcement restated in ~4 sentences | Baseline section with specs, quantization, and benchmark tables |
| No timeline | Eleven-month release timeline with first-party timestamps |
| No maintainership content | Maintainer / distributor / community table plus licensing consequence |
| No roadmap content | Foundry Local repositioning, Windows AI Foundry three-layer status, tiered-routing economics |
| No selection guidance | Premise correction plus reach-for / look-elsewhere criteria |
| Bare link list | Cross-links with descriptors, classified references, TOC, provenance callout |

## Meta and architecture impact

**None.** No changes to instruction files, context files, prompts, agents, or the workflow contract.

Two maintenance items surfaced by the original triage remain **open** and are deliberately not discharged here:

- Azure AI Foundry → Microsoft Foundry terminology sweep across Build 2025 articles. (📌 next steps)
- A `03.00-tech/` decision-framework article on local open-weight versus hosted frontier inference. (📌 next steps)

## Validation

| Check | Result |
|---|---|
| Emoji prefix on every H2 | ✅ done |
| Sentence-case headings | ✅ done |
| TOC present with anchors matching headings | ✅ done |
| Source-provenance callout with snapshot adjacent to classified link | ✅ done |
| References carry 📘/📗 markers with descriptions | ✅ done |
| Relative cross-links resolve | ✅ done — paths carried over from the verified triage list |
| Bottom validation metadata block present | ✅ done |
| Top YAML of existing articles untouched | ✅ done |
| Working artifacts kept out of navigation (`publish: false`) | ✅ done |
| Rendered check in Learn.Web | 🟡 todo |
