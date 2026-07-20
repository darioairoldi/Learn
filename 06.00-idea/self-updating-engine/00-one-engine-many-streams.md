---
title: "One engine, many streams: how the self-updating visions fit together"
author: "Dario Airoldi"
date: "2026-07-20"
categories: [idea, self-updating-engine, autonomous-streams, learning-hub]
description: "A short consolidation note that folds the self-updating-* visions (prompt engineering, article writing, research) into one shared engine plus per-domain streams — so the trio reads as one machinery with domain configurations, not three separate systems."
---

# One engine, many streams

> **Chapter of** [Learning Hub: vision, strategy, implementation, and next steps](../learning-hub/00-learning-hub/00-learning-hub.md)
> (Layer ③, the Learning Loop). Read this to see how the several `self-updating-*` folders relate.

## The point

There is **one engine and many streams** — not four separate self-updating systems.

- The [self-updating engine](20260622.01-self-updating-engine-vision.md) is the **portable machinery**: a
  **Detect → Assess → Propose → Execute** loop, a risk-calibrated autonomy gradient, change-risk
  classification, and metadata-guarded changes, behind a clean engine/integration seam.
- An [autonomous stream](../autonomous-streams/autonomous-streams.md) is **one runtime instance** of that
  machinery, configured for a single domain — it supplies the domain's identity, quality model, sources, and
  thresholds; the engine supplies everything else.

So each `self-updating-{domain}` folder is **not** a new engine. It is the **domain configuration** for one
stream running on the shared engine.

## The streams today

| Stream (domain) | What it maintains | Vision |
|---|---|---|
| **Prompt engineering** | Prompts, agents, skills, instructions, context files | [self-updating-prompt-engineering](../self-updating-prompt-engineering/20260531.01-vision.md) |
| **Article writing** | Published articles — freshness, claims, per-dimension review | [self-updating-article-writing](../self-updating-article-writing/20260428.01-vision.v1.md) |
| **Research** | Research briefs and their sources | [self-updating-research](../self-updating-research/01.000-vision.v1.md) |

Future streams — for example **documentation maintenance** or **validation** — instantiate the same engine
with new configuration rather than new machinery. That portability is the whole point: improve the engine
once, and every stream inherits the improvement.

## How to read the folders

- Start with the [engine vision](20260622.01-self-updating-engine-vision.md) for the machinery and its contract.
- Read [autonomous streams](../autonomous-streams/autonomous-streams.md) for the definition of a stream and the
  engine/stream/loop-engineering vocabulary.
- Then each `self-updating-{domain}` folder is just that domain's stream configuration.

## References

- [Self-updating engine vision](20260622.01-self-updating-engine-vision.md) — the shared machinery.
- [Autonomous streams](../autonomous-streams/autonomous-streams.md) — the runtime instances.
- [Learning Hub master](../learning-hub/00-learning-hub/00-learning-hub.md) — where this sits in the three-layer picture.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "00-one-engine-many-streams.md"
  created: "2026-07-20"
  status: "consolidation-note"
-->
