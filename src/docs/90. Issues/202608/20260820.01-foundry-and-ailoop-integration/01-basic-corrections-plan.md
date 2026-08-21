---
title: "Learning Hub definition pages — basic corrections plan"
author: "Dario Airoldi"
date: "2026-08-20"
status: "in-progress"
categories: [plan, learning-hub, documentation, vision, corrections]
description: "Correct the shipped claims in the seven Learning Hub definition pages so they match the agreed positioning — learning starts before reading, any source and any medium, knowledge that is yours rather than one corpus, an AI that thinks with you — then clear the principles-contract gaps and the naming, metadata, convention and validation defects."
---

# Learning Hub definition pages — basic corrections plan

> **Plan 1 of 3.** This plan changes **claims and hygiene** only — no page is created, split, renamed or
> reordered here. Structure work is [plan 2](02-front-door-and-nav-plan.md); the new narrative article is
> [plan 3](03-the-story-plan.md). Plans 2 and 3 assume this plan has landed.

## 📋 Table of contents

- [🎯 Objective](#-objective)
- [🧭 Motivation](#-motivation)
- [🧱 Scope](#-scope)
- [📐 The agreed positioning (the yardstick)](#-the-agreed-positioning-the-yardstick)
- [⚙️ WS-A-claim-corrections — things to do (✅ done)](#-ws-a-claim-corrections--things-to-do--done)
- [⚙️ WS-B-principles-contract — things to do (✅ done)](#-ws-b-principles-contract--things-to-do--done)
- [⚙️ WS-C-diagram-text — things to do (🟡 todo)](#-ws-c-diagram-text--things-to-do--todo)
- [⚙️ WS-D-housekeeping — things to do (🟡 todo)](#-ws-d-housekeeping--things-to-do--todo)
- [🧪 Exit criteria (🟡 todo)](#-exit-criteria--todo)
- [❓ Open decisions](#-open-decisions)
- [🔎 Discovery](#-discovery)
- [🅿️ Park lot](#-park-lot)
- [📚 References](#-references)

---

## 🎯 Objective

Bring the claims made by the seven Learning Hub definition pages into line with the agreed positioning,
make the `principles:` contract actually cover those claims, and clear the consistency defects that
undermine the pages' credibility.

Three claim defects are being corrected, all of which are currently **shipped in the documentation**, not
merely missing from the pitch:

1. The arc **starts too late** — the vision opens at consumption ("you read an article, watch a talk").
2. The corpus framing is **warehouse language** — "into one place… normalized into a single corpus"
   contradicts the multi-source storage design and describes the wrong benefit.
3. The engine is **text-biased** — the `generalized-content-engine` P0 principle and the diagram's data
   sources are all document-shaped.

Plus two contract gaps: the **core value has no principle behind it**, and the principle that now carries
the headline claim is ranked below the plumbing.

## 🧭 Motivation

The `principles:` block in [01-learning-hub-introduction.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md)
is not decoration — the self-updating engine reads `goal`, `scope`, `boundaries` and each principle's
priority to decide what it may change autonomously. So a claim the pages make that no principle covers is
a claim nothing is obliged to preserve. Today the canonical calls compounding foresight *"the Learning
Hub's core value"*, and **no principle mentions foresight, discovery, or gap-surfacing at all**.

Correcting the copy without correcting the contract would leave the pages over-claiming against their own
governance model. This plan closes both together.

## 🧱 Scope

**In scope** — the seven articles under `06.00-idea/00.00-learning-hub/`, the folder's diagram source
(`_assets/images.v2.pptx`) and its PNG export.

**Out of scope, explicitly:**

- Creating, splitting, renaming or reordering any page → [plan 2](02-front-door-and-nav-plan.md).
- The new narrative article → [plan 3](03-the-story-plan.md).
- Any file outside `06.00-idea/00.00-learning-hub/` except the two plan siblings.
- The Innovation Studio submission text itself (copy is agreed; publishing it is a manual action outside
  this repository).

## 📐 The agreed positioning (the yardstick)

Informational — every edit below is checked against this table.

| Claim | Wording that satisfies it |
|---|---|
| Learning starts **before** reading | "when you sense a gap, when something makes you curious, when you don't yet know what you should be looking for" |
| **Any source, any medium** | "your information **wherever you decide**, in any medium" |
| It becomes **yours**, not a corpus | "**it becomes yours** — active knowledge instead of passive, scattered information" |
| The AI **amplifies you** | "an AI that thinks **with** you, not **for** you" — faster, further, more creatively |
| Personal **and** shared | "alone or with the people you learn with" |
| The hook | "**Stop keeping up. Start thinking ahead.**" |

**Retained deliberately:** "one corpus" in its **delivery** sense — several storage targets served as one
navigable whole. Only the **ingestion** sense is being removed.

---

## ⚙️ WS-A-claim-corrections — things to do (✅ done)

All items edit [00-learning-hub.md](../../../../../06.00-idea/00.00-learning-hub/00-learning-hub/00-learning-hub.md)
unless stated otherwise. Anchor strings below are quoted from the current file; each is unique within it.

- **A1-vision-opening** — Replace the § Vision opening paragraph (anchor: `Most learning is **consume-and-forget**`) so that it, in this order: (a) opens with the hook **"Stop keeping up. Start thinking ahead."**; (b) states that learning starts *before* reading, naming the three triggers — sensing a gap, being made curious, not yet knowing what to look for; (c) states that most tools meet you only after that moment and only for text; (d) closes on the retained **consume-and-forget → develop-and-keep** antithesis. Keep the paragraph at four sentences or fewer. (✅ done — the section now opens on the hook, then the three pre-reading triggers, then the retained antithesis.)

- **A2-moves-are-a-cycle** — Replace `It rests on five moves:` with wording that declares the moves a **cycle, not a pipeline**. After the *Think ahead* bullet, add one sentence stating that **Think ahead produces the next Gather** — foresight is both the output and the trigger. (✅ done — lead-in now reads "a **cycle**, not a pipeline"; a closing paragraph states that *Think ahead* produces the next *Gather*.)

- **A3-gather-bullet** — Rewrite the **Gather** bullet (anchor: `bring what you learn from many sources into one place`). Remove `into one place` and `normalized into a single corpus`. The replacement MUST use **"your information wherever you decide, in any medium"**, MUST state that non-public material is read in place and never copied, and MUST add the clause **"including what you didn't know to look for."** (✅ done)

- **A4-learn-in-context-active** — Rewrite the **Learn in context** bullet in the active voice, leading with **"the AI thinks *with* you, not *for* you."** Immediately after the five-move list, add a new H3 subsection `### 🤝 What "thinks with you" means` listing exactly four behaviours: pushes back on a weak claim · opens a line you hadn't considered · connects what's in front of you to what you already know · hands your gaps back as the next thing worth asking. Close the subsection with "alone, or with the people you learn with." (✅ done — bullet rewritten in the active voice and the four-behaviour subsection added.)

- **A5-corpus-terms** — Replace the **ingestion-sense** uses of *corpus* with knowledge-that-is-yours wording, at these five locations, and nowhere else: (1) `00-learning-hub.md` § Vision, *Learn in context* bullet — `The corpus itself becomes the context`; (2) `00-learning-hub.md` § Vision, *Think ahead* bullet — `As the corpus grows and the AI learns your goals`; (3) [01-learning-hub-introduction.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) § Overview — `As the corpus grows and AI comes to understand your`; (4) same file, `information-centric` principle statement — `into a growing corpus`; (5) [05-own-your-learning-loop.md](../../../../../06.00-idea/00.00-learning-hub/05-own-your-learning-loop.md) — `a compounding corpus`. **Do not change** `00-learning-hub.md` § Storage `Target:` paragraph or the `incremental-integration` principle — both use *corpus* in the retained architecture sense. (✅ done — all five changed; the two architecture-sense uses left intact as specified.)

- **A6-any-medium-sources** — In § Self-update loop → *Producing governed Markdown*, extend the source-channel sentence beyond document-shaped inputs: add **charts and diagrams**, **video and audio**, and **live/real-time sessions**, and state that sources are read from wherever the owner decides they live (storage accounts, local and network drives, OneDrive, feeds, private mirrors). (✅ done)

- **A7-audiences-humans-first** — In § Audiences and interaction surfaces, add one lead sentence naming the **human** audiences (an individual learner; a team learning together) before the surfaces table, so the section does not open on producer plumbing. Do not restructure the table. (✅ done)

---

## ⚙️ WS-B-principles-contract — things to do (✅ done)

All items edit the `principles:` block **and** the matching body annotations in
[01-learning-hub-introduction.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md).
Every priority appears in **two** places — the frontmatter `priority:` field and the body's
`**Priority: Pn**` line — and both MUST be changed in the same edit.

| Id | Principle | Change | Reason |
|---|---|---|---|
| B1 | `active-critical-and-creative-development` | **P1 → P0**; restate to include *thinks with you, not for you* and the speed / reach / creativity gains | It now carries the headline claim, yet ranks below the plumbing |
| B2 | `generalized-content-engine` | Restate as **any source, any medium**, naming charts and diagrams, video and audio, and live interaction | Currently enumerates only document-shaped sources |
| B3 | *(new)* `foresight-and-gap-surfacing` | **Add at P0** | The declared core value has no principle behind it |
| B4 | `collaborative-learning` | **Keep at P2**; add a one-line maturity note that it is declared intent, not built capability | Prevents the pitch's "alone or together" from reading as a shipped feature |

- **B1-promote-active-development** — Apply the B1 row. The restated statement MUST contain the phrase *thinks with you, not for you* and MUST name creativity, speed, and reach of thinking as the gains. (✅ done — P0 in both frontmatter and body annotation.)

- **B2-widen-generalized-content-engine** — Apply the B2 row. The restated statement MUST name at least one non-text medium and MUST name real-time interaction. (✅ done)

- **B3-add-foresight-principle** — Apply the B3 row. Add the frontmatter entry with `id: foresight-and-gap-surfacing`, `priority: P0`, and a statement covering: turning fresh information into implications *for the owner*, surfacing knowledge gaps before they bite, and feeding those gaps back as the next question. Add the matching body subsection with its `**Priority: P0** · \`foresight-and-gap-surfacing\`` annotation, placed with the other principle annotations. (✅ done — added to the P0 group, with a new body subsection § *Foresight — the move the transformations serve*.)

- **B4-collaborative-maturity-note** — Apply the B4 row. One line, in the body annotation only; the frontmatter statement is unchanged. (✅ done)

- **B5-priority-sync-check** — After B1–B4, walk every principle id in the frontmatter and confirm the body annotation states the same priority. **If any mismatch is found → correct the body to match the frontmatter**, which is authoritative. (✅ done — all nine principles checked; every body annotation already matched, so the negative branch was not needed.)

---

## ⚙️ WS-C-diagram-text — things to do (🟡 todo)

The rendered diagram is `00-learning-hub/images/001.01-learning-hub-architecture.v1.png`; its source is
`06.00-idea/00.00-learning-hub/_assets/images.v2.pptx`. Edit the source and re-export to the **same
filename**, so no article link changes.

- **C1-diagram-text-panels** — Change exactly these strings in the source deck: (1) Hub band subtitle `one governed corpus — delivered live, kept current` → wording that names *your knowledge*, many sources, one place to think; (2) DATA SOURCES panel subtitle `what you meet, normalised into one corpus` → wording that says *wherever you decide, any medium*; (3) MULTI-SOURCE STORAGE subtitle `where the files reside — public and private, one corpus` → keep the delivery sense, reworded as *served as one*. (✅ done — replaced at **run level** via PowerPoint automation so each run kept its own font size and colour; a first attempt that set whole text frames flattened the MULTI-SOURCE STORAGE subtitle and was rolled back from backup.)

- **C2-diagram-media-row** — Add one DATA SOURCES entry covering **non-text media** (charts and diagrams, video and audio, live sessions), so the panel matches the widened B2 principle. (🟡 todo — To do: the DATA SOURCES panel is full at five cards, so a sixth needs the panel re-proportioned. That is deck design work, not a text substitution, and was deliberately not automated. The medium generality is already carried by the panel subtitle changed in C1, so the diagram is not inconsistent with the article in the meantime.)

- **C3-reexport-and-alt-text** — Re-export the slide to `001.01-learning-hub-architecture.v1.png` at the existing dimensions, then update the image **alt text** in `00-learning-hub.md` so it describes the changed panels. (✅ done — exported at 1341×752, matching the previous asset exactly; alt text rewritten.)

---

## ⚙️ WS-D-housekeeping — things to do (🟡 todo)

- **D1-name-normalization** — Normalize every occurrence of `LearnHub`, `Learning-hub` and lowercase `learning hub` to **Learning Hub** across the seven articles, including the H1 and `title:` of [01-learning-hub-documentation-taxonomy.md](../../../../../06.00-idea/00.00-learning-hub/02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md). Do not rename files. (✅ done — 10 occurrences normalized; also corrected a stale `filename:` in the taxonomy article's bottom metadata that still read `01-learnhub-…`.)

- **D2-sentence-case-titles** — Convert Title Case H1/H2 headings to sentence case across the seven articles, per the repository formatting standard. (✅ done — verified by scan; the only remaining capitalised word is the proper noun "Azure Functions".)

- **D3-emoji-h2** — Apply the emoji-on-H2 convention uniformly: add emoji to the H2s in the taxonomy article and in [02-using-learning-hub-for-learning-technologies.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/02-using-learning-hub-for-learning-technologies.md), and fix the internally mixed [01-automated-content-lifecycle-with-prompts-agents-and-mcp.md](../../../../../06.00-idea/00.00-learning-hub/03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md) (`## Introduction` unmarked, `## 🔬 Lessons learned` marked). Regenerate each affected article's TOC anchors in the same edit, since adding a leading emoji changes the anchor. (✅ done — 33 headings, scoped by a fence-aware scan so the taxonomy article's template headings inside code blocks were left untouched. This also surfaced and fixed **14 pre-existing broken TOC anchors** in the lifecycle article, whose headings already carried emoji its TOC did not account for.)

- **D4-frontmatter-sync** — In `01-learning-hub-introduction.md`, set `version:` to `"1.7"` and `date:` to `"2026-08-20"` (currently `"1.4"` / `"2025-08-29"` while the changelog already runs to v1.6), and add a **v1.7 (2026-08-20)** entry to § Most recent changes summarising WS-A and WS-B. (✅ done)

- **D5-drop-promissory-footer** — Delete the four promissory lines at the end of `01-learning-hub-introduction.md` (`Document Status`, `Implementation Time`, `Maintenance`, `Expected Impact`). They are unsourced and contradict the graded maturity table in the canonical. (✅ done)

- **D6-internal-link-integrity** — Resolve every relative link **whose target is inside** `06.00-idea/00.00-learning-hub/`, from all seven articles. **If a link does not resolve → repoint it to the correct path.** Links pointing outside the folder are out of scope here (see `PL-2-repo-wide-broken-links`). (✅ done — every in-folder link resolves; the negative branch was not needed. The scan did confirm a large number of out-of-folder dead links, which stay parked.)

- **D7-run-validations** — Run the grammar and readability validations on all seven articles and update **only** the bottom HTML-comment `validations:` block in each. Every file currently reads `not_run`. The top YAML MUST NOT be touched by validation. (🟡 todo — To do: this needs the article-review prompt run once per article, which is a substantial task in its own right and will surface change proposals outside this plan's scope. Flipping the blocks from `not_run` without actually running them would defeat the very criterion this item exists to satisfy, so they are deliberately left unchanged.)

- **D8-encoding-check** — After all edits, scan the seven articles for `U+FFFD` replacement characters and confirm UTF-8 encoding is preserved. **If any `U+FFFD` is found → repair it without retyping the affected emoji.** (✅ done — zero replacement characters; every file's original BOM state preserved by the rewrite script.)

---

## 🧪 Exit criteria (🟡 todo)

- No article under `06.00-idea/00.00-learning-hub/` contains `into one place`, `normalized into a single corpus`, or `normalised into one corpus`. (✅ done — verified by scan.)
- The § Vision opening names the pre-reading trigger; the five moves are declared a cycle. (✅ done)
- `active-critical-and-creative-development` is P0, `generalized-content-engine` names a non-text medium, and `foresight-and-gap-surfacing` exists at P0 — in both frontmatter and body. (✅ done)
- The re-exported diagram carries the three changed panel strings and the media row. (🟡 todo — the three strings are landed and visually verified; the media row is pending `C2-diagram-media-row`.)
- All seven articles use "Learning Hub", sentence-case headings, and emoji H2s with matching TOC anchors. (✅ done — verified by scan: zero naming variants, zero broken anchors.)
- No article's `validations:` block reads `not_run`. (🟡 todo — pending `D7-run-validations`.)
- No `U+FFFD` present in any of the seven articles. (✅ done — verified by scan.)

## ❓ Open decisions

None. `B4-collaborative-maturity-note` resolves the recurring collaboration question by **keeping P2 and
declaring intent**, consistent with the agreed copy's conditional phrasing ("alone or with the people you
learn with"). Promotion to P1 would require capability work and is therefore out of this plan's scope.

## 🔎 Discovery

- **DS-1-diagram-source-currency** — Whether `_assets/images.v2.pptx` contains the slide that produced the current `.v1.png`. **If it does not → author the three changed panels plus the media row on a new slide in the same deck and export from there.** **If PowerPoint is unavailable at execution time → complete WS-A/B/D, leave WS-C unmarked, and record the exact target strings in the plan so the export is a mechanical follow-up.** (✅ done — probed the deck's slide XML: `slide1.xml` contains all three target strings intact, each in a single text run, so the deck is current and neither negative branch was needed. PowerPoint was available.)

## 🅿️ Park lot

- **PL-1-sidebar-rename** — Reordering the sidebar so the economic rationale appears before the builder chapters requires renaming numeric prefixes; nav order has no per-file override. → `defer` (blast radius: 105 inbound references across 30 files).
- **PL-2-repo-wide-broken-links** — Many files outside this folder link to `06.00-idea/learning-hub/…`, but the folder is `06.00-idea/00.00-learning-hub/…`; those links are broken today. → `defer` (needs its own plan; touches 30 files).
- **PL-3-howto-split** — Splitting the technologies article into a routine plus a source catalog. → `→ 02-front-door-and-nav-plan.md`.
- **PL-4-five-moves-visual** — A diagram of the closed five-move cycle (distinct from the layer diagram). → `defer`.
- **PL-5-vocabulary-consolidation** — Reducing the ~30 named concepts to one user-facing and one builder-facing spine. → `→ 02-front-door-and-nav-plan.md`.

## 📚 References

### Internal references

- [Learning Hub: vision, strategy, implementation](../../../../../06.00-idea/00.00-learning-hub/00-learning-hub/00-learning-hub.md) — primary target of WS-A.
- [Learning Hub concept and principles](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) — primary target of WS-B.
- [Own your learning loop](../../../../../06.00-idea/00.00-learning-hub/05-own-your-learning-loop.md) — touched by A5.
- [Front door and navigation plan](02-front-door-and-nav-plan.md) — sibling plan 2.
- [The story plan](03-the-story-plan.md) — sibling plan 3.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "01-basic-corrections-plan.md"
  created: "2026-08-20"
  content_type: "plan"
  subject: "learning-hub"
-->
