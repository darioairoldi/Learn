---
title: "Learning Hub definition pages — the story plan"
author: "Dario Airoldi"
date: "2026-08-20"
status: "done"
categories: [plan, learning-hub, documentation, narrative, demo]
description: "Write the article the Learning Hub corpus is missing — a single concrete trace that shows the whole arc, from a gap the reader did not know to look for, through a non-text source, to knowledge that is theirs and a stale claim caught months later, doubling as the demo script."
---

# Learning Hub definition pages — the story plan

> **Plan 3 of 3.** Depends on [plan 1](01-basic-corrections-plan.md) for corrected claims, and slots into
> the page set reserved by [plan 2](02-front-door-and-nav-plan.md). It delivers **one article** —
> `06.00-idea/00.00-learning-hub/00-learning-hub/01-what-it-feels-like.md`.

## 📋 Table of contents

- [🎯 Objective](#-objective)
- [🧭 Motivation](#-motivation)
- [🧱 Scope](#-scope)
- [📐 The article contract](#-the-article-contract)
- [🎬 The five beats](#-the-five-beats)
- [⚙️ WS-A-author-the-article — things to do (✅ done)](#-ws-a-author-the-article--things-to-do--done)
- [⚙️ WS-B-wire-it-in — things to do (✅ done)](#-ws-b-wire-it-in--things-to-do--done)
- [⚙️ WS-C-demo-script — things to do (✅ done)](#-ws-c-demo-script--things-to-do--done)
- [🧪 Exit criteria (✅ done)](#-exit-criteria--done)
- [❓ Open decisions](#-open-decisions)
- [🔎 Discovery](#-discovery)
- [🅿️ Park lot](#️-park-lot)
- [📚 References](#-references)

---

## 🎯 Objective

Write the single artifact the Learning Hub corpus does not have: a **concrete trace of one person using
it**, start to finish.

Six of the seven existing articles describe the *system*. The seventh describes a *routine* and is largely
a catalog. Nothing anywhere shows the product in use — which is why the definition reads as architecture
rather than as a thing that helps someone. This article closes that gap, and it is the same narrative the
demo follows.

## 🧭 Motivation

The agreed positioning makes four claims. Prose asserts them; a trace **demonstrates** them, and it
demonstrates all four in one pass:

| Claim | Where the trace proves it |
|---|---|
| Learning starts before reading | Beat 1 — the reader is handed a gap they had not thought to look for |
| Any source, any medium — wherever you decide | Beat 2 — the source is a recorded session in personal storage, not a feed and not text |
| It becomes yours, not a corpus | Beat 3 — the output is connected to the reader's existing work and kept where they chose |
| An AI that thinks with you, not for you | Beat 3 — the AI pushes back, the reader decides |
| Foresight, not a tidy archive | Beat 4 — a claim in it goes stale and the loop catches it |

A second reason: this article is the only place where the *dogfooding* argument becomes visible rather than
asserted. The trace happens **inside** the Hub that publishes it.

## 🧱 Scope

**In scope** — one new article, its links, and a short demo mapping.

**Out of scope, explicitly:**

- Any change to the claims or principles — owned by [plan 1](01-basic-corrections-plan.md).
- Any change to the front door beyond the two links WS-B adds — owned by [plan 2](02-front-door-and-nav-plan.md).
- Building or wiring any capability. **The trace narrates behaviour that is designed but not fully built,
  so it MUST label maturity inline** (see `A6-maturity-honesty`). It is a walkthrough, not a claim of
  shipped function.
- Screen recordings or slides.

## 📐 The article contract

| Property | Value |
|---|---|
| Path | `06.00-idea/00.00-learning-hub/00-learning-hub/01-what-it-feels-like.md` |
| H1 | Sentence case, naming the pre-reading gap — e.g. *"The thing you didn't know to look for"* |
| Classification | **Concepts / narrative walkthrough**, not How-to — the reader follows a story, not instructions |
| Length | 900–1,400 words |
| Voice | Second person, past tense for the trace, present tense for what the system does |
| Frontmatter | `title`, `author`, `date`, `categories`, `description` per the dual-metadata contract |
| Bottom metadata | `validations:` block plus `article_metadata:` with `content_type: "chapter"` |
| Status markers | **None.** This is a reader-facing narrative, not executed work — status suffixes are out of scope for tutorial and narrative content |

**Boundary (public repository):** the trace MUST NOT name any customer, product, engagement, employer,
colleague, or internal system. The subject matter must be a **public technology topic**. This mirrors the
boundary note already carried by the platform chapter.

## 🎬 The five beats

The article follows exactly these beats, in order, each as one H2 section.

**Beat 1 — the gap you didn't know you had.** The reader is not searching. The Hub, reading what they have
already accumulated, surfaces a gap: something adjacent to their work that they have never covered, and
that recent material suggests will matter to them. This is the move that proves learning starts *before*
reading — and it is `foresight-and-gap-surfacing`, the P0 principle plan 1 adds, in action.

**Beat 2 — the source is not an article.** Following the gap leads to a **recorded conference session held
in the reader's own storage** — chosen deliberately: it is not text, not a feed, and not in the repository.
The Hub reads it where the reader decided it lives. Show the transcript and the extracted structure as
intermediate artifacts.

**Beat 3 — the AI thinks with you.** The reader develops the material, and the AI works against them, not
merely for them: it pushes back on a claim the session asserted without evidence, opens a line the reader
had not considered, and connects the topic to something they wrote months earlier. **The reader makes every
call.** The output is a page in their own knowledge — connected, sourced, and theirs.

**Beat 4 — three months later.** The self-update loop revisits the page: a claim it carries no longer holds
because the underlying technology moved. The loop detects it, assesses it, proposes a correction, and waits
for the reader — the **Detect → Assess → Propose → Execute** gradient under human governance. Nothing is
changed silently.

**Beat 5 — what compounded.** Close on what the reader now has that they would not have had otherwise: the
correction they made in Beat 3 is theirs and shaped everything the AI did afterwards; the gap in Beat 1
produced the next gap. State plainly that the cycle closed — *Think ahead* produced the next *Gather*.

---

## ⚙️ WS-A-author-the-article — things to do (✅ done)

- **A1-choose-the-subject** — Choose one public technology topic for the trace and use it consistently through all five beats. It must satisfy three tests: it is public; it plausibly has recorded conference sessions; and it has visibly moved in the last year so Beat 4's staleness is credible. Record the chosen topic in the article's introduction. (✅ done — **Model Context Protocol**: public, has recorded conference sessions, and has visibly moved in the last year, so Beat 4's staleness is credible. Named in the introduction, with a note that nothing in the trace depends on the topic being MCP.)

- **A2-write-the-five-beats** — Write the five beats as five H2 sections in the order specified above, each with an emoji-prefixed sentence-case heading. Every beat must end with one italic line naming which claim it just demonstrated. (✅ done — five H2 beats in order, each closing with its italic claim line.)

- **A3-show-the-artifacts** — Include the intermediate artifacts as short fenced blocks or quoted extracts, not as description: the surfaced gap, an extract of the session transcript, the AI's pushback on the weak claim, and the staleness proposal from Beat 4. A trace that only *describes* its artifacts is prose, not a trace. (✅ done — four fenced artifacts: the surfaced gap, the session extraction summary, the freshness proposal, and the follow-on gap; the AI's pushback and its unconsidered line are quoted as blockquotes.)

- **A4-the-ai-must-lose-an-argument** — In Beat 3, the reader must **overrule the AI at least once**, and the article must state that this correction becomes part of what the reader owns. This is the concrete form of *thinks with you, not for you*, and of the learning-exhaust argument. (✅ done — the reader keeps a comparison table the AI proposed dropping, on a distinction the AI had not weighted; the article states that the correction becomes part of what the Hub holds and shapes later proposals.)

- **A5-name-no-one** — Apply the public-repository boundary: no customer, product, engagement, employer, colleague or internal system is named. **If the chosen subject cannot be written without naming one → choose a different subject and restart from A1.** (✅ done — the only named entity is a public open standard; no customer, product, engagement, employer, colleague or internal system appears. The restart branch was not needed.)

- **A6-maturity-honesty** — Add one short callout stating which parts of the trace run today and which are designed, consistent with the graded implementation table. The trace must not read as a claim of shipped function. (✅ done — callout placed before the table of contents: reading, rendering and navigation are built and live; the Beat 1 gap surfacing and Beat 4 staleness detection are design-strong and partly wired, running on a prompt rather than a schedule.)

- **A7-references** — Add a References section with internal links to the front door, the concept and principles chapter, and the self-updating engine vision, plus any external source used for the subject matter, each classified with the required emoji marker. (✅ done — four internal references and one external, classified 📗 [Verified Community], with an explicit note that the article makes no normative claim about the protocol.)

---

## ⚙️ WS-B-wire-it-in — things to do (✅ done)

- **B1-front-door-link** — Add the article to the front door's reading paths as the **second stop on the "I want to use it" door**, immediately after the front door itself. (✅ done — the "I want to use it" door now reads story → technologies routine.)

- **B2-lead-link-from-the-hook** — Add one inline link from the front door's positioning paragraph directly to this article, phrased as an invitation to see it happen rather than as a cross-reference. (✅ done — "Watch that happen once", placed on the sentence about learning starting before you read.)

- **B3-chapter-blockquote** — Give the article the folder's standard chapter blockquote naming the front door as its parent, matching the pattern used by the existing chapters. (✅ done)

- **B4-concept-chapter-backlink** — Add one link from [01-learning-hub-introduction.md](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) § *Implementation boundaries and handoffs* pointing to this article as the concrete illustration of the concept. (✅ done — added as the first handoff, above the canonical-architecture entry.)

- **B5-link-check** — Resolve every link added or referenced by WS-B. **If a target does not exist yet because plan 2 has not landed → land plan 2's WS-B first, then complete B1 and B2.** (✅ done — plan 2 was already `done`, so the negative branch was not needed. Verified against the live renderer: both front-door links resolve to the article with HTTP 200.)

---

## ⚙️ WS-C-demo-script — things to do (✅ done)

- **C1-beat-to-demo-mapping** — At the end of the article, add a short table mapping each of the five beats to what would be shown on screen in a live demonstration. Keep it to five rows and one sentence each. (✅ done — § *Walking it as a demo*, five rows.)

- **C2-timing** — Annotate the mapping with a target duration per beat so the whole trace can be walked in under five minutes. (✅ done — 45s / 60s / 90s / 45s / 30s = **4m30s**, with a closing note that the pause in beat 4 is the point to land.)

---

## 🧪 Exit criteria (✅ done)

- The article exists at the contracted path, is 900–1,400 words, and carries both metadata blocks. (✅ done — **1,266 words as rendered** by SmartDocs. Raw token count including Markdown syntax is 1,560; the rendered figure is the one the range is about, consistent with how plan 2 measured the front door.)
- All five beats are present, in order, each closing with the claim it demonstrates. (✅ done — confirmed against the live render: the H2 sequence is Beat 1 → 5, then the demo mapping, then References.)
- Beat 2's source is non-text and held outside the repository. (✅ done — a conference session recording in personal cloud storage, resolved in place and never copied into the public tree.)
- Beat 3 contains a pushback the reader overrules. (✅ done)
- Beat 4 shows a proposal awaiting human approval, never a silent change. (✅ done — the artifact ends on "Awaiting your approval", and the beat names the propose/execute gap as where governance lives.)
- No customer, product, engagement, employer, colleague or internal system is named. (✅ done — the only named entity is a public open standard.)
- The maturity callout is present. (✅ done)
- The article is reachable from the front door by two distinct links, and every link resolves. (✅ done — verified in the browser: two links found, both returning HTTP 200 at the article; folder-wide scan reports 0 broken anchors and 0 broken in-folder links.)
- The beat-to-demo mapping is present and totals under five minutes. (✅ done — 4m30s.)

## ❓ Open decisions

None. The one genuine choice — the subject of the trace — is bounded by the three tests in `A1-choose-the-subject`
and by the restart branch in `A5-name-no-one`, so it has a deterministic outcome without a preference call.

## 🔎 Discovery

- **DS-1-real-trace-or-composed** — Whether a real past learning episode fits the five beats closely enough to be narrated directly. **If one does → narrate it, with identifying detail removed per A5.** **If none does → compose the trace and state in the introduction that it is a composed walkthrough of designed behaviour, not a recorded session.** Either branch satisfies every other item; only the introduction's wording differs. (✅ done — no single past episode covers all five beats, so the **negative branch applied**: the trace is composed and says so in a callout. Beat 4 is grounded in the real staleness case documented in the automated-content-lifecycle article, and that grounding is stated in the beat.)

- **DS-2-artifact-fidelity** — Whether real intermediate artifacts (an actual transcript extract, an actual staleness proposal) can be produced at authoring time. **If they can → use them verbatim.** **If they cannot → write representative artifacts and label them as illustrative in the same fenced block.** (✅ done — real artifacts could not be produced because the gap-surfacing and freshness loops are not yet scheduled, so the **negative branch applied**: the artifacts are representative and the first one carries an explicit "illustrative" note.)

## 🅿️ Park lot

- **PL-1-screen-recording** — Recording the demo rather than describing it. → `defer` (needs the capability in Beat 4 to be wired).
- **PL-2-second-trace** — A second trace for the team-learning case, once `collaborative-learning` moves past P2. → `defer`.
- **PL-3-story-for-machine-producers** — An equivalent trace for the documentation-manager consumer. → `defer`.
- **PL-4-innovation-studio-media** — Reusing the trace's artifacts in the submission's media gallery. → `closed: outside this repository`.

## 📚 References

### Internal references

- [Basic corrections plan](01-basic-corrections-plan.md) — sibling plan 1; supplies the corrected claims this trace demonstrates.
- [Front door and navigation plan](02-front-door-and-nav-plan.md) — sibling plan 2; reserves this article's slot and its reading-path entry.
- [Learning Hub: vision, strategy, implementation](../../../../../06.00-idea/00.00-learning-hub/00-learning-hub/00-learning-hub.md) — the parent page.
- [Learning Hub concept and principles](../../../../../06.00-idea/00.00-learning-hub/01-learning-hub-overview/01-learning-hub-introduction.md) — source of the principles the beats demonstrate.
- [Platform and consumers](../../../../../06.00-idea/00.00-learning-hub/04-platform-and-consumers.md) — source of the public-repository boundary note this plan applies.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "03-the-story-plan.md"
  created: "2026-08-20"
  content_type: "plan"
  subject: "learning-hub"
-->
