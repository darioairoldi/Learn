---
title: "Architecture: one system in three layers"
author: "Dario Airoldi"
date: "2026-08-20"
categories: [idea, learning-hub, architecture, markdown, self-updating]
description: "How the Learning Hub works — one system in three layers: storage that holds what you keep, a self-update loop that develops and keeps it current, and dynamic rendering that delivers it live with no build step, governed throughout by metadata carried on the content itself. A chapter of the canonical Learning Hub definition."
---

# Architecture: one system in three layers

> **Chapter of** [Learning Hub](00-learning-hub.md). The front door states *what* the Hub is in sixty
> seconds; this page is *how* it works, in depth.

## 📋 Table of contents

- [🏗️ How it works — one system in three layers](#-how-it-works--one-system-in-three-layers)
- [🔍 Reading the diagram](#-reading-the-diagram)
- [🖥️ Rendering — deliver](#-rendering--deliver)
- [🔄 Self-update loop — develop and keep](#-self-update-loop--develop-and-keep)
- [💾 Storage — hold](#-storage--hold)
- [👥 Audiences and interaction surfaces](#-audiences-and-interaction-surfaces)
- [⚙️ Current implementation](#-current-implementation)
- [🚀 Next steps](#-next-steps)
- [📚 References](#-references)

---

## 🏗️ How it works — one system in three layers

The Learning Hub delivers its vision as **one system in three layers**, fed by **many sources** and governed
throughout by **metadata carried on the content itself**:

![Learning Hub architecture: data sources on the right feed the Hub — met wherever you decide they live, in any medium; prompt-engineering artifacts including context files govern it from above; metadata applies to PE artifacts and articles; inside the Hub, storage sits at the bottom holding public and private stores served as one, self-update logic in the middle, and rendering on top, delivering your knowledge from many sources as one place to think; three colour-coded loops run from the self-update logic back to PE artifacts, context information, and articles.](images/001.01-learning-hub-architecture.v1.png)

| Layer | Verb | One-line definition |
|---|---|---|
| **Rendering** | *deliver* | **Diginsight SmartDocs** — a fully dynamic Markdown-rendering application that renders Markdown → HTML on demand and builds navigation at runtime — **no build step**, content is live the moment it lands. Consumed as an external building block, not owned. |
| **Self-update loop** | *develop and keep* | The prompts, agents and engine that **turn many sources into governed Markdown and then keep it current** — one loop for creation *and* maintenance, under human governance. |
| **Storage** | *hold* | Where what you keep physically lives. **One storage target per Hub instance today**; supporting several targets at once — authenticated or not — is the target design. |

---

## 🔍 Reading the diagram

The Hub itself (navy) stacks **three bands, bottom to top** — the order matters, because it is the order the
content travels:

| Band | What it is |
|---|---|
| **Storage** (bottom) | Where the files actually reside. **One storage target per Hub instance today**; the diagram's public / private split is the *target* — several targets, authenticated or not, served together as one. |
| **Self-update loop** (middle) | **Detect → Assess → Propose → Execute**: deterministic Tier 0 checks, AI-driven Tier 1–2 review, creative and critical analysis, and research. The same loop both *creates* content from the sources and *keeps* it current. |
| **Rendering** (top) | Markdown → HTML on demand, navigation built at runtime. Storage is read **on demand** — there is **no build step**, so a change is live on the next request. |

Three things sit **outside** the Hub and act on it:

- **Prompt-engineering artifacts** (top) — the whole GitHub Copilot customization stack:
  `copilot-instructions.md`, instruction files, prompts, agents, skills, hooks, MCP servers, chat modes,
  templates, prompt snippets, model choice, and **context files**. The context files **are** the context
  information — they are one kind of PE artifact, not a separate category beside them.
- **Metadata** (right) — applies to exactly two things: **PE artifacts and articles**. It carries article and
  folder metadata (identity, navigation, validation state) and the **invariants** — `goal`, `scope`,
  `boundaries`, and the `principles:` block with each principle's priority and rationale. The self-updating
  engine reads exactly this metadata to decide what it may change.
- **Data sources** (right) — met **wherever you decide they live** and **in any medium**: feeds and
  newsletters, conferences and events, meetings and talks, papers and vendor docs, non-text material, and
  your own corrections. All of them enter the *same* pipeline; none is a special case with bespoke
  machinery. That generality is the `generalized-content-engine` principle.

The three coloured arrows are the **self-update loops** — what the logic in the middle band writes back:

| Loop | Target | Stream that implements it |
|---|---|---|
| **self-updating prompt engineering** | PE artifacts | [self-updating-prompt-engineering](../../self-updating-prompt-engineering/20260531.01-vision.md) |
| **self-updating context information** | context files | same stream — context files are PE artifacts, fed by [self-updating-research](../../self-updating-research/01.000-vision.v1.md) |
| **self-updating articles** | articles in storage | [self-updating-article-writing](../../self-updating-article-writing/20260428.01-vision.v1.md) |

All three run on **one engine** with per-domain configuration — see
[One engine, many streams](../../self-updating-engine/00-one-engine-many-streams.md).

---

## 🖥️ Rendering — deliver

The Learning Hub's content is delivered by **Diginsight SmartDocs** — a fully dynamic Markdown-rendering
application that renders Markdown → HTML on demand, builds navigation at runtime, and has **no build step
and no static output**, so a page is live the moment its file lands. Because a page is a pure function of
*its own* Markdown plus a shared shell, the platform is **producer- and source-agnostic** — which is what
lets it serve audiences far beyond a single learner.

**The renderer is a building block, not a Hub component.** SmartDocs lives in its own repository
(`diginsight/smartdocs`), and what *this* repository holds is **content and the self-update loop**. That
separation is the producer-agnostic claim made good: a renderer that never depended on being *this* Hub's
renderer was free to become a general product. The Hub is its most demanding consumer, not its owner.

> 📖 The rendering layer in full — its defining properties, its interaction surfaces, and the audiences it
> generalizes to — is the [Platform and consumers](../04-platform-and-consumers.md) chapter.

---

## 🔄 Self-update loop — develop and keep

Creation and maintenance are **the same loop**, not two systems. Learning does not stop at the first read, so
the machinery that writes an article for the first time is the machinery that revisits it later.

### Producing governed Markdown

The loop reads from **wherever you decide your information lives** — storage accounts, local and network
drives, OneDrive, feeds, private mirrors — and accepts it **in any medium**. Its channels: **feeds and
newsletters** (RSS/Atom, release notes, monitored sites), **conference and event material** (session
catalogs, slides, proceedings — a flagship channel with its own ingestion path from catalog discovery
through transcripts and summaries to navigation wiring), **meetings and talks** (transcripts, recordings,
notes), **deep sources** (papers, industry reports, vendor documentation), **non-text material** (charts and
diagrams, video and audio, live and real-time sessions), and **your own work** (notes,
experiments, and the corrections you make when a model is wrong). Non-public material among these is
resolved from an external mirror and read in place — never copied into the public repository.

What comes out is **governed Markdown** — Markdown carrying the Hub's dual-metadata contract (identity
frontmatter + validation tracking) and passing
its quality model. Today it covers **article writing** and **prompt engineering** (create, validate,
cross-reference, gap-analyse, publish-gate). Its productized name is **IQPilot** — "a quality assurance tool
for written content, like a linter for documentation." The same engine generalizes to **generated content**:
reference documentation from code, documentation sites from a whole repository, and validation reports —
each simply another Markdown producer the platform renders (see [Platform and consumers](../04-platform-and-consumers.md)).

- Concept and taxonomy: [Learning Hub concept](../01-learning-hub-overview/01-learning-hub-introduction.md) · [Documentation taxonomy](../02-documentation-taxonomy/01-learning-hub-documentation-taxonomy.md)
- The content lifecycle: [Automated content lifecycle](../03-automated-content-lifecycle/01-automated-content-lifecycle-with-prompts-agents-and-mcp.md)
- The product: [IQPilot overview](../../iqpilot/01-iqpilot-overview.md)

### Keeping it current

The self-update loop is the machinery that keeps what you keep fresh and compounds judgment: the
[self-updating engine](../../self-updating-engine/20260622.01-self-updating-engine-vision.md) (a portable
**Detect → Assess → Propose → Execute** loop with a risk-calibrated autonomy gradient and metadata-guarded
changes) and the [autonomous streams](../../autonomous-streams/autonomous-streams.md) that instantiate it per
domain. There is **one engine and many streams**, not four separate systems — see
[One engine, many streams](../../self-updating-engine/00-one-engine-many-streams.md). The
[cost-control strategy](../../prompt-engineering-and-azure-openai-cost-control/20260503.01-slidescontent.md)
and [TuneIQ](../../tuneiq/01-tuneiq-design.md) (which tunes the customization stack from real sessions) round
out the loop.

---

## 💾 Storage — hold

Storage is where your knowledge physically lives, and it is deliberately **not** part of the renderer. The
renderer reads it on demand; the self-update loop writes to it. Nothing sits between them — no build, no
static output, no publish step.

**Today:** a Hub instance is bound to **exactly one storage target**, chosen by configuration
(`Content:Source` — a repository clone on the filesystem, or object storage). Non-public source material is
resolved from an external mirror and read in place, never copied into the public repository.

**Target:** a single instance serves **several storage targets at once — authenticated or not** — composed
into one navigable whole. That is what makes the trust boundary real: public knowledge published openly and
private knowledge behind authentication, in the same navigation, without copying anything across the line.

---

## 👥 Audiences and interaction surfaces

The Hub is built for **people first**: an individual learner developing their own knowledge, and a team
learning together and sharing what each of them develops. Producing content and delivering it are decoupled,
so governed Markdown can be produced on any surface and is rendered live by the same platform — by people,
and by the agents working alongside them.

> 📖 The surfaces, and the widening set of audiences the platform generalizes to, are detailed in
> [Platform and consumers](../04-platform-and-consumers.md).

---

## ⚙️ Current implementation

| Layer | Component | Status |
|---|---|---|
| Rendering | **Diginsight SmartDocs** — dynamic Markdown-rendering app, runtime navigation. External building block (`diginsight/smartdocs`), consumed not owned | **Built & live** |
| Storage | Single storage target per instance (`Content:Source` = `Blob` *or* `FileSystem`) | **Built & live** |
| Storage | Several targets at once — authenticated or not — composed into one navigable whole | **Design** — the diagram shows the target |
| Self-update loop · content | Article-writing + prompt-engineering prompts/agents; dual-metadata contract; validation caching | **Built** (IQPilot productization ongoing) |
| Self-update loop · content | Generated docs / validation consumers (documentation-manager, validation-manager) | **Design** — external patterns generalized, not yet hosted |
| Self-update loop · machinery | Self-updating engine, autonomy gradient, metadata guards | **Design-strong**; partly wired |
| Self-update loop · machinery | Autonomous streams on the live source | **Design** |
| Self-update loop · machinery | TuneIQ session capture and analysis | **Design**; capture partly wired |

The platform layer is the concrete outcome of the markdown-first migration — see the
[progressive-build recap](../../../src/docs/90.%20Issues/202607/20270711.02-progressive-build/overview.md)
for how the retired static-site build became this live renderer.

---

## 🚀 Next steps

**Documentation (this repo) — in progress**

1. The [front door](00-learning-hub.md) and this architecture chapter.
2. [Platform and consumers](../04-platform-and-consumers.md) — the platform and its generalized audiences.
3. Rescope IQPilot and TuneIQ to name the live site as a first-class surface.
4. [One engine, many streams](../../self-updating-engine/00-one-engine-many-streams.md) — fold the self-updating trio under one engine.

**Capability (roadmap)**

5. **Multi-source content** — let the renderer host a generated documentation tree (runtime rendering replaces a static build). → [Design spec: live documentation hosting](../../../src/docs/90.%20Issues/202607/20270720.01-learninghub-stratreview/overview.md).
6. **Validation dashboards** — render validation catalog / progress Markdown as live views.
7. **Private mirror** — authenticated, authorized rendering of the non-public knowledge tree (the trust boundary made real).
8. **Streams on the live source** — wire autonomous streams to the same content source the site reads, so detect → propose → execute edits go live immediately.

---

## 📚 References

### Internal references

- [Learning Hub](00-learning-hub.md) — the front door this chapter expands.
- [Platform and consumers](../04-platform-and-consumers.md) — the rendering layer and its audiences, in full.
- [Self-updating engine vision](../../self-updating-engine/20260622.01-self-updating-engine-vision.md) — the machinery of the self-update loop.
- [Learning Hub concept](../01-learning-hub-overview/01-learning-hub-introduction.md) — the principles this architecture serves.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "02-architecture.md"
  created: "2026-08-20"
  content_type: "chapter"
  subject: "learning-hub"
-->
