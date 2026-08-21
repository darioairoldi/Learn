---
title: "Learning Hub definition pages — front door and navigation plan"
author: "Dario Airoldi"
date: "2026-08-20"
status: "done"
categories: [plan, learning-hub, documentation, information-architecture]
description: "Turn the canonical Learning Hub page into a 60-second front door, extract the architecture into its own chapter, add visible proof and reading paths, rebalance the consumers chapter toward humans, reduce the concept count to one user-facing and one builder-facing spine, and split the technologies article into a routine plus a source catalog."
---

# Learning Hub definition pages — front door and navigation plan

> **Plan 2 of 3.** Depends on [plan 1](01-basic-corrections-plan.md) having landed — the front door quotes
> corrected claims, so running this first would enshrine the wrong wording. The new narrative article
> referenced from the front door is delivered by [plan 3](03-the-story-plan.md); this plan only reserves
> its slot and links to it.

## 📋 Table of contents

- [🎯 Objective](#-objective)
- [🧭 Motivation](#-motivation)
- [🧱 Scope](#-scope)
- [🗺️ Target page set and nav order](#️-target-page-set-and-nav-order)
- [⚙️ WS-A-split-canonical — things to do (✅ done)](#-ws-a-split-canonical--things-to-do--done)
- [⚙️ WS-B-front-door — things to do (✅ done)](#-ws-b-front-door--things-to-do--done)
- [⚙️ WS-C-visible-proof — things to do (✅ done)](#-ws-c-visible-proof--things-to-do--done)
- [⚙️ WS-D-reading-paths — things to do (✅ done)](#-ws-d-reading-paths--things-to-do--done)
- [⚙️ WS-E-consumers-rebalance — things to do (✅ done)](#-ws-e-consumers-rebalance--things-to-do--done)
- [⚙️ WS-F-one-spine — things to do (✅ done)](#-ws-f-one-spine--things-to-do--done)
- [⚙️ WS-G-howto-split — things to do (✅ done)](#-ws-g-howto-split--things-to-do--done)
- [🧪 Exit criteria (✅ done)](#-exit-criteria--done)
- [❓ Open decisions](#-open-decisions)
- [🔎 Discovery](#-discovery)
- [🅿️ Park lot](#️-park-lot)
- [📚 References](#-references)

---

## 🎯 Objective

Give the Learning Hub a page a cold reader can absorb in sixty seconds, and a reading order they can
follow — without renaming or reordering any existing page.

Today [00-learning-hub.md](../../../../../06.00-idea/00.00-learning-hub/00-learning-hub/00-learning-hub.md)
is simultaneously the elevator pitch and the architecture spec, opens with an administrative sentence
("Read this first. This is the canonical definition"), carries no screenshot and no example, and is
followed by six further pages that describe the *system* rather than anyone *using* it.

## 🧭 Motivation

Six things make a definition page land. The folder currently has **one** of them — honest maturity grading,
which is a real asset and is retained untouched.

| # | Property | Today | Delivered by |
|---|---|---|---|
| 1 | A hook in the first ten words | Missing | WS-B |
| 2 | Proof you can see | Missing (only an architecture diagram) | WS-C |
| 3 | One concrete story | Missing entirely | [plan 3](03-the-story-plan.md) |
| 4 | Honest maturity | **Present** — keep as is | — |
| 5 | A reading path, not a file list | Missing (nav contradicts the prose order) | WS-D |
| 6 | Few enough named concepts to hold | ~30 across seven pages | WS-F |

## 🧱 Scope

**In scope** — the seven existing articles under `06.00-idea/00.00-learning-hub/`, two new articles created
by this plan, and one new article created by plan 3.

**Out of scope, explicitly:**

- Any change to a claim's wording that plan 1 owns. If a WS below needs corrected wording, it **quotes**
  plan 1's result; it does not re-decide it.
- **Renaming or renumbering any existing file or folder.** Nav order derives from numeric prefixes and has
  no per-file override, so every reorder is a rename; with 105 inbound references this is parked
  (`PL-1-sidebar-rename`).
- Application changes of any kind. This plan is content-only.

## 🗺️ Target page set and nav order

Navigation sorts by `SortKey`: a numeric prefix yields `(0, value, name)` ascending, so **both new files
take unused whole-number prefixes inside the existing `00-learning-hub/` folder**. No existing prefix
changes, no collision, and no reliance on fractional-prefix parsing.

| Nav position | Page | Action |
|---|---|---|
| `00-learning-hub/00-learning-hub.md` | Front door — 60 seconds | **rewrite** (WS-B) |
| `00-learning-hub/01-what-it-feels-like.md` | The story | **new** — [plan 3](03-the-story-plan.md) |
| `00-learning-hub/02-architecture.md` | Three layers, in depth | **new** (WS-A) |
| `01-learning-hub-overview/01-learning-hub-introduction.md` | Concept and principles | unchanged here |
| `01-learning-hub-overview/02-using-learning-hub-for-learning-technologies.md` | The routine | **trimmed** (WS-G) |
| `01-learning-hub-overview/03-technology-learning-source-catalog.md` | The catalog | **new** (WS-G) |
| `02-documentation-taxonomy/…` · `03-automated-content-lifecycle/…` | Builder chapters | unchanged |
| `04-platform-and-consumers.md` | Platform and audiences | **edited** (WS-A, WS-E) |
| `05-own-your-learning-loop.md` | The economic rationale | unchanged here |

The intended **reading order** differs from this sidebar order (the rationale should be read early). Because
reordering needs renames, the reading order is carried **in-page** by WS-D, and the sidebar rename is parked.

---

## ⚙️ WS-A-split-canonical — things to do (✅ done)

- **A1-create-architecture-chapter** — Create `06.00-idea/00.00-learning-hub/00-learning-hub/02-architecture.md` and **move** into it, unchanged except for heading level fixes, the current § *How it works — one system in three layers* and § *Reading the diagram* from `00-learning-hub.md`, including the architecture image and the three-loop table. Give it the standard chapter blockquote pointing back to the front door. (✅ done — `02-architecture.md` holds How it works, Reading the diagram, the three layer sections, audiences, the graded implementation table and next steps.)

- **A2-canonical-keeps-a-summary** — In `00-learning-hub.md`, replace the moved sections with the existing three-row layer table (Rendering / Self-update loop / Storage, with their verbs and one-line definitions) plus a single link to `02-architecture.md`. No other prose from the moved sections may remain. (✅ done — three-row table with SmartDocs named in the Rendering row, plus one 📖 pointer.)

- **A3-dedupe-rendering** — Delete the § *Rendering — deliver* prose from the new `02-architecture.md` where it restates [04-platform-and-consumers.md](../../../../../06.00-idea/00.00-learning-hub/04-platform-and-consumers.md) § *The platform*, and replace it with a one-paragraph summary plus a link. The platform chapter becomes the single owner of rendering detail. (✅ done — the architecture chapter now carries a two-paragraph summary, one of which is the SmartDocs ownership fact, then defers to the platform chapter.)

- **A4-repoint-inbound-anchors** — Any link in the seven articles that targets the moved sections by anchor (for example `#️-how-it-works--one-system-in-three-layers`) must be repointed to `02-architecture.md`. **If a link's anchor no longer exists at the new location → repoint it to the page without an anchor.** (✅ done — a scan found no inbound links to the moved sections, so the negative branch was not needed; the only cross-page anchor is the new front-door link to the implementation table, which resolves.)

---

## ⚙️ WS-B-front-door — things to do (✅ done)

Rewrite `00-learning-hub.md` so it contains **exactly these blocks, in this order**, and nothing else above
the References section. Target length: **under 700 words**.

- **B1-hook** — Open with the hook as the first line after the H1: **"Stop keeping up. Start thinking ahead."** Remove the current administrative opener ("Read this first. This is the canonical definition…"). Retain the canonical-authority statement, moved below the hook and reduced to one sentence. (✅ done)

- **B2-tagline** — Immediately below the hook, the agreed one-paragraph positioning: what you meet — any source, any medium — becomes living knowledge that's yours, with an AI that thinks *with* you, not for you. (✅ done)

- **B3-screenshot** — The site screenshot from WS-C, above the fold, with descriptive alt text. (✅ done — placed directly under the tagline, before the cycle; alt text describes runtime navigation, article, and outline, and makes the no-build-step point.)

- **B4-five-bullets** — Five bullets, one line each, in the cycle order: Gather · Keep · Enrich · Learn in context · Think ahead, with a closing half-sentence stating that Think ahead produces the next Gather. Full definitions stay in the concept chapter; these are labels plus one clause. (✅ done — five bullets plus the closing "it is a cycle, not a pipeline" line.)

- **B5-maturity-one-liner** — One sentence stating what is running today versus designed, followed by a link to the graded implementation table (which moves to `02-architecture.md` with WS-A). Do not restate the table. (✅ done)

- **B6-dogfooding-line** — Add the sentence that is currently nowhere in the corpus: this page is itself a Learning Hub article — governed by the metadata contract it describes, served by the renderer it specifies, kept current by the loop it defines. (✅ done)

- **B7-reading-paths-block** — The three-door block from WS-D. (✅ done)

- **B8-trim-the-map** — Reduce the § *The map — sibling visions as chapters* table to the sibling **visions outside this folder** only. Chapters inside the folder are reached through the reading paths, not through a second list. (✅ done — trimmed to the nine outside-folder visions and, to meet the word budget, compressed from a role table to three grouped lines: machinery, streams, product.)

---

## ⚙️ WS-C-visible-proof — things to do (✅ done)

> **Unblocked.** SmartDocs was already running from `diginsight/smartdocs` on `http://localhost:5280`, and its
> Development profile already points `Site:Spaces[0]:FileSystem:RootPath` at this repository — so it renders
> this content directly, no configuration change needed.

- **C1-capture-screenshot** — Capture a screenshot of the running site showing the sidebar and a rendered Learning Hub article, in a **visible browser window**. Save it as `06.00-idea/00.00-learning-hub/00-learning-hub/images/002.01-learning-hub-live-site.png`. (✅ done — captured in a visible browser at 1200×688 CSS px. Two obstacles had to be cleared first: the running instance was serving a **stale render cache** (2,620 words, the pre-split canonical), cleared with `POST /_nav/invalidate`; and emulating a viewport larger than the real browser window produced a layout/paint mismatch, fixed by resizing the actual window over CDP so layout and paint agree.)

- **C2-screenshot-safety** — Before committing, check the capture for in-image disclosure — address bar, window title, terminal prompt, account chrome. **If anything identifying is visible → crop or re-capture.** (✅ done — the capture carries no address bar, window title, terminal prompt or account chrome, and names no customer, product or engagement. The negative branch was not needed.)

---

## ⚙️ WS-D-reading-paths — things to do (✅ done)

- **D1-three-doors** — Author the reading-paths block for the front door with exactly three doors: **"2 minutes"** → this page; **"I want to use it"** → the story, then the technologies routine; **"I want to understand or build it"** → architecture → own your learning loop → concept and principles → platform and consumers → taxonomy → automated content lifecycle. Each door is one line: label, then the ordered links. (✅ done — the "use it" door currently lists the technologies routine only; [plan 3](03-the-story-plan.md) B1 inserts the story ahead of it once that article exists, so no link points at a missing file.)

- **D2-state-the-order-is-in-page** — Add one sentence under the block noting that this is the intended reading order and that the sidebar is ordered by filename. Without it a reader sees a contradiction and trusts neither. (✅ done)

- **D3-remove-competing-orders** — Delete the prose reading sequence at the end of [01-learning-hub-introduction.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) § Conclusion and replace it with a link to the front door's reading paths, so exactly one ordering statement exists in the folder. (✅ done)

---

## ⚙️ WS-E-consumers-rebalance — things to do (✅ done)

- **E1-humans-first** — In [04-platform-and-consumers.md](../../../../../06.00-idea/00.00-learning-hub/04-platform-and-consumers.md) § *The consumers*, order the subsections **humans first**: the individual learner, then a team learning together, then the documentation manager, the validation manager, and app-dev doc generation. (✅ done)

- **E2-add-the-team-consumer** — Add the missing *team learning together* subsection: shared governed artifacts, peer corrections as first-class input to the same loop, and reuse across instances where policy allows. Mark it explicitly as **declared intent, not built capability**, consistent with `collaborative-learning` remaining P2 (plan 1, B4). (✅ done — added with an explicit maturity blockquote citing the P2 grade.)

- **E3-retitle-the-section** — Retitle § *The consumers* so it does not read as machine-only, and adjust the section's lead sentence to say the platform serves people first and producers second. (✅ done — now § *Who it serves — people first, then producers*; TOC anchor regenerated.)

---

## ⚙️ WS-F-one-spine — things to do (✅ done)

- **F1-declare-the-two-spines** — On the front door, state in one sentence that the **cycle of five moves** is the user-facing spine and the **three layers** are the builder-facing spine. Every other named scheme is a mapping onto one of these two. (✅ done — § *Two spines, and nothing else to memorise*.)

- **F2-demote-the-four-transformations** — In `01-learning-hub-introduction.md`, move the four transformations (information-centric, structured knowledge development, active critical and creative development, collaborative learning) into an appendix section presented **as a mapping table** onto the five moves. Remove the defensive sentence "not a second vocabulary" — the table makes the point without it. (✅ done — converted to a four-row mapping table and the defensive sentence removed. **Deviation:** it stays in place rather than moving to an appendix, because later sections of the chapter refer back to these principles and an appendix would leave forward references. The `**Priority: Pn** · \`id\`` token was preserved verbatim inside the table cells so the priority-sync check still finds it.)

- **F3-demote-the-five-cs** — In [05-own-your-learning-loop.md](../../../../../06.00-idea/00.00-learning-hub/05-own-your-learning-loop.md), keep the Control / Capability / Choice / Cost / Compound argument but present the five parts as a mapping onto the three layers, so a reader is not asked to hold a fifth independent scheme. (✅ done — added a **Layer** column plus a closing note that all five live in the self-update loop, only *Compound* also depends on storage, and none belongs to rendering.)

- **F4-concept-count-check** — After F1–F3, count the distinct named schemes a front-door reader must hold. **If it exceeds two (the cycle and the three layers) → move the excess into an appendix mapping rather than deleting it.** (✅ done — the front door names exactly two spines; the transformations and the five C's are both now presented as mappings, so the negative branch was not needed.)

---

## ⚙️ WS-G-howto-split — things to do (✅ done)

[02-using-learning-hub-for-learning-technologies.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/02-using-learning-hub-for-learning-technologies.md)
is classified How-to but is largely a catalog of roughly fifty feeds — a **Resources** artifact by the
project's own taxonomy — and it is entirely text and RSS, which reinforces the text bias plan 1 corrects.

- **G1-create-the-catalog** — Create `06.00-idea/00.00-learning-hub/01-learning-hub-overview/03-technology-learning-source-catalog.md` and **move** every source table into it, unchanged. Classify it as **Resources** in its frontmatter and H1. (✅ done — 70 lines of tables moved verbatim by script, with line-number assertions guarding the extraction.)

- **G2-keep-the-routine** — Leave in the original article only the practical routine: what to do daily, weekly and per event, and how sources are triaged. Classify it as **How-to**. Add a link to the catalog where the tables used to be. (✅ done — the automated-processing architecture stayed with the routine and was promoted to an H2.)

- **G3-reframe-the-opening** — Rewrite the article's Executive Summary so it does not open on "subscribe to the firehose". It must state the routine's purpose in the agreed terms: fewer, better questions and less time spent keeping up. (✅ done)

- **G4-add-non-text-sources** — Add at least one non-text source class to the catalog (recorded sessions, video channels, or event recordings), so the folder's only source list is not text-only. (✅ done — added a § *Non-text sources* table: conference session catalogs, video channels, and your own recorded meetings read in place.)

---

## 🧪 Exit criteria (✅ done)

- `00-learning-hub.md` is under 700 words, opens with the hook, and contains blocks B1–B8 in order. (✅ done — **639 words as rendered** by SmartDocs, with all eight blocks present in order. Raw token count including Markdown syntax and image alt text is 731; the rendered figure is the one the criterion is about, since it is what a reader actually reads.)
- `02-architecture.md` exists, holds the three-layer detail and the diagram, and no architecture prose remains on the front door beyond the summary table. (✅ done)
- A site screenshot renders above the fold on the front door and carries alt text. (✅ done — verified in the browser: the image resolves via `/_content-raw/…`, loads at 1200×688, and carries alt text.)
- Exactly one reading-order statement exists in the folder, and it names three doors. (✅ done — the competing sequence in the concept chapter's conclusion now points at the front door.)
- § *The consumers* lists humans before machine producers and includes the team subsection marked as intent. (✅ done)
- A front-door reader is asked to hold exactly two named schemes. (✅ done)
- The technologies article contains no source tables; `03-technology-learning-source-catalog.md` contains them plus at least one non-text class. (✅ done)
- Every link created or moved by this plan resolves. (✅ done — verified by scan: 0 broken anchors, 0 broken in-folder links, 0 `U+FFFD`.)

## ❓ Open decisions

None. The two genuine trade-offs are resolved deterministically: **new files take unused whole-number
prefixes inside `00-learning-hub/`** (no renames, no fractional-prefix dependency), and **reading order is
carried in-page** rather than by renumbering (`PL-1-sidebar-rename` parked with its blast radius recorded).

## 🔎 Discovery

- **DS-1-can-the-app-run-locally** — Whether the renderer can be built and run to take the capture. **Resolved: it cannot be run from this repository.** The renderer moved out of `Learn.01` and became **Diginsight SmartDocs** (`diginsight/smartdocs`, working copy `C:\dev\darioa\Diginsight\smartdocs.01`, projects `Diginsight.SmartDocs.Web` / `.Client` / `.Shared`); the `src/Learn.Web*` folders left behind here contain build output and one `.csproj.user`, no source. **Negative branch taken → capture C1 either by running SmartDocs from its own repository against this content, or from the already-published site**, in a visible browser window either way, with C2 applied unchanged. (✅ done — resolved by evidence; the capture route is now unambiguous.)

- **DS-2-screenshot-content** — Which article to show in the capture. **If plan 3's story article exists at capture time → show it** (it demonstrates the product better than a vision page). **If it does not → show the front door itself.** (✅ done — the story does not exist yet, so the negative branch applied: the capture shows the front door, which also makes the dogfooding point self-evident.)

## 🅿️ Park lot

- **PL-1-sidebar-rename** — Renumbering so the sidebar matches the reading order. → `defer` (105 inbound references across 30 files; needs the repo-wide link fix first).
- **PL-2-per-parent-order-manifest** — Implementing the `children:` ordering manifest that would make reordering possible without renames. → `defer` (application change; already specified in the navigation ordering plan).
- **PL-3-taxonomy-relocation** — Moving the documentation taxonomy behind the builder door in the sidebar. → `defer` (needs `PL-1-sidebar-rename`).
- **PL-4-front-door-video** — A short screen recording as an alternative to the static screenshot. → `defer`.

## 📚 References

### Internal references

- [Basic corrections plan](01-basic-corrections-plan.md) — sibling plan 1; must land first.
- [The story plan](03-the-story-plan.md) — sibling plan 3; supplies `01-what-it-feels-like.md`.
- [Learning Hub: vision, strategy, implementation](../../../../../06.00-idea/00.00-learning-hub/00-learning-hub/00-learning-hub.md) — rewritten by WS-B.
- [Platform and consumers](../../../../../06.00-idea/00.00-learning-hub/04-platform-and-consumers.md) — rebalanced by WS-E.
- [Learning Hub improvements — ordering plan](../../202607/20270720.01-learninghub-stratreview/00.02-learning-hub-improvements-ordering-plan.md) — the source of the `SortKey` behaviour this plan relies on.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "02-front-door-and-nav-plan.md"
  created: "2026-08-20"
  content_type: "plan"
  subject: "learning-hub"
-->
