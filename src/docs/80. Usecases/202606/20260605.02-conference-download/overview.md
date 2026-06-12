# Use case: Ingest a public event/content site into Learning Hub

> **Created:** 2026-06-07 · **Domain:** learning-hub · **Status:** exploration
> **Implementation plan:** [01-event-ingestion-pe-artifacts-plan.md](01-event-ingestion-pe-artifacts-plan.md)

## 🎯 Purpose

Capture a repeatable workflow that turns an **anonymous, public** event or content site (conference session catalogs, talk replays, doc portals) into a structured Learning Hub corpus — one folder per item with a `summary.md`, a normalized `transcript.txt`, a poster `images/`, and a master index — with near-zero manual effort.

This use case was discovered while downloading all 211 Microsoft Build 2026 sessions. That run proved the value; the goal now is to make it a first-class, source-agnostic capability instead of throwaway scripts.

## ⚙️ Operational context

| Input | A public event/content site URL |
|---|---|
| Output | Per-item folders (`summary.md`, `transcript.txt`, `images/`) + master `readme.md` index |
| Trigger | A future `/learninghub-ingest-event-site` prompt → event-ingestion agent |
| Constraint | Public/anonymous content only; respect robots.txt & ToS; single poster frame; no auth bypass |

## 🔬 Behavior (high level)

1. **Discover the source** via tiered strategy: structured API → declared feed (sitemap/RSS/JSON-LD) → HTML scrape.
2. **Build a manifest** in a canonical event-item schema (id, title, speakers, date, description, tags, transcript/video/watch URLs).
3. **Generate `summary.md`** per item (HTML→Markdown, speaker resolution, date formatting, attribution).
4. **Acquire transcripts** and normalize any format (DOCX/VTT/SRT/text) to `transcript.txt`.
5. **Extract one poster frame** per video via ffmpeg HTTP range-seek + brightness validation (no full download).
6. **Build the master index** and normalize folders to kebab-case.

All phases are manifest-driven, idempotent (skip-existing), and batchable.

## 🧱 Planned PE artifacts

A reusable **context** file, a **skill** bundling parameterized scripts, an orchestrating **agent**, a thin **prompt** entry point, and generalized **scripts**. See the [implementation plan](01-event-ingestion-pe-artifacts-plan.md) for the full design, steps, guardrails, and exit criteria.

## 🔗 Related

- [Implementation plan](01-event-ingestion-pe-artifacts-plan.md)
- Existing sidebar wiring prompt: `.github/prompts/90.00-learning-hub/learninghub-createorupdate-quarto-menu.prompt.md`
