---
title: "Autonomous streams: definition and positioning"
author: "Dario Airoldi"
date: "2026-07-11"
categories: [autonomous-streams, loop-engineering, self-updating-engine, idea]
description: "Definition of autonomous streams and how they relate to loop engineering and the self-updating engine."
---

# Autonomous streams: definition and positioning

An <mark>**autonomous stream**</mark> is a named, goal-bound pipeline that continuously discovers work, executes it, validates outcomes, and records state.  
It is the operational unit that turns loop-engineering principles into repeatable behavior in the Learning Hub.

## 🎯 What an autonomous stream is

An autonomous stream is not a generic "agent run." It is a durable operating lane with:

- A stable purpose and scope.
- Explicit trigger sources.
- A verifiable done condition.
- A risk-calibrated autonomy policy.
- Persistent memory and outcome logging.

In practice, each stream owns one problem family (for example, document maintenance, reference hygiene, or structured investigation) and runs its loop repeatedly instead of as a one-shot task.

## 🔁 How it relates to loop engineering

Loop engineering defines the discipline: design autonomous cycles that can decide what to do next, validate progress, and stop only when exit conditions hold.

Autonomous streams are the concrete instances of that discipline in this repository.  
If loop engineering is the method, a stream is the productized implementation of one loop.

## 🏗️ How it relates to the self-updating engine

The self-updating engine is the shared machinery. A stream is one configured consumer of that machinery.

| Layer | Function |
|---|---|
| Self-updating engine | Supplies Detect → Assess → Propose → Execute, autonomy routing, and metadata-guarded execution |
| Autonomous stream | Supplies domain purpose, triggers, constraints, and acceptance conditions |

This separation keeps the system portable: improve machinery once in the engine, then inherit improvements across all streams.

## ✅ Design boundary that must hold

An autonomous stream may update its domain artifacts, but it must not rewrite its own governing logic directly.  
When a stream detects that its own behavior needs revision, it emits signals that a meta-maintenance stream can evaluate and apply under governance.

## 🚀 Why this definition matters

This definition prevents terminology drift and keeps architecture discussions precise:

- "Loop engineering" names the discipline.
- "Self-updating engine" names the machinery.
- "Autonomous stream" names one runtime instance of that machinery in a specific domain.

## 📚 References

- [Self-updating engine: vision and rationale (v1.0)](../self-updating-engine/20260622.01-self-updating-engine-vision.md) 📒 [Internal]  
Defines the portable machinery that autonomous streams instantiate.
- [Loop engineering and the Learning Hub: analysis and alignment](../../01.00-news/20260710.01-loop-engineering/overview.md) 📒 [Internal]  
Provides the analysis that motivated this terminology alignment.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}
article_metadata:
  filename: "autonomous-streams.md"
  created: "2026-07-11"
  last_updated: "2026-07-11"
  content_type: "idea"
-->