---
status: draft
title: "Event/Content-Site Ingestion — PE Artifact Implementation Plan"
created: "2026-06-07"
last_updated: "2026-06-07"
domain: "learning-hub"
goal: "Turn the one-off Build 2026 conference-download pipeline into a robust, reusable set of PE artifacts (agent + skill + context + scripts) that can ingest any anonymous public event/content site into Learning Hub's per-item folder layout"
owner: "Dario Airoldi"
---

# Event/Content-Site Ingestion — PE Artifact Implementation Plan

> **Status:** `draft` — authoring in progress. Do NOT execute items until the Actionability Gate passes and status is promoted to `actionable`.

## 🎯 Goal & Scope

Convert the ad-hoc pipeline that downloaded all 211 Microsoft Build 2026 sessions into a **reusable, source-agnostic ingestion capability** for Learning Hub, packaged as proper PE artifacts.

**In scope**

- A canonical "event item" schema and output layout (per-item folder: `summary.md`, `transcript.txt`, `images/`, master index `readme.md`).
- A tiered **source-discovery** strategy (structured API → feed/sitemap/JSON-LD → HTML scrape) so the capability is not hard-wired to Build's private API.
- Reusable, parameterized **scripts** for the four mechanical phases (manifest, summaries, transcripts, poster frames).
- An **agent** persona + **skill** + **context** file that orchestrate the workflow with explicit legal/ethical guardrails.

**Out of scope** (see § Park lot)

- Authenticated / paywalled sources, scraping behind login, CAPTCHA bypass.
- Video re-hosting or full-video download (we extract a single poster frame only).
- Automatic publishing/menu wiring (handled by the existing `learnhub-sidebar-menu` prompt).

## 💡 Motivation

The Build ingestion proved that a public event site can be turned into a structured, searchable Learning Hub corpus (summaries + transcripts + posters + index) with near-zero manual effort. That capability is broadly valuable (Ignite, //Build, GitHub Universe, KubeCon, conference replays, doc portals). Today it lives only as throwaway scripts in a temp folder. This plan makes it a **first-class, repeatable Learning Hub workflow**.

## 🔍 Background — How the Build pipeline actually worked

The pipeline succeeded because it discovered a clean structured data source and treated every phase as **idempotent + manifest-driven**. Mechanics observed in this conversation:

1. **Source discovery.** A private but unauthenticated JSON API was found behind the site: `https://api-v2.build.microsoft.com/api`.
   - `/session/all/en-US` (enumeration) → list of session codes → `manifest.json` (`{code, group, folder}`, 211 rows).
   - `/session/en-US-{CODE}` → per-session: `title`, `description`, `aiDescription` (HTML), `sessionLevel`, `sessionType`, `location`, `topic`, `durationInMinutes`, `startDateTime` (UTC), `speakerIds[]`, `tags[]`, `relatedSessionCodes[]`, `captionFileLink` (transcript `.docx`), `downloadVideoLink` (HIGHMP4).
   - `/speaker/all/en-US` → 427 speakers → hashtable keyed by `speakerId` to resolve name/role/company.
2. **Summary generation** (`gen-summaries.ps1`). HTML→Markdown conversion, UTC→PDT date formatting, speaker resolution by id, wrote a templated `summary.md` per session.
3. **Transcript acquisition.** `captionFileLink` downloaded to `transcript.docx`; later normalized to `transcript.txt` (`convert-transcripts.ps1` — handled both real DOCX zip and `.docx`-mislabeled WebVTT/text).
4. **Poster frame** (`gen-frames.ps1`). ffmpeg **HTTP range-seek** (`-ss {sec} -i {url} -frames:v 1`) grabbed one frame from the CDN video without downloading it; `System.Drawing` brightness sampling rejected black slates and retried at other timestamps.
5. **Index + cleanup.** Master `readme.md` index; per-session folders normalized to kebab-case; uniform image naming.

**Reliability primitives that made it robust:** manifest-driven enumeration, `Skip`/`Take` batching, skip-if-exists idempotency, per-item JSON logs, signature-based file-type detection, and validation passes (brightness, file count, ref count).

## 🧭 Generalization analysis

The hard part of generalizing is that **most sites do NOT expose a Build-style JSON API**. The reusable design must degrade gracefully across source types and isolate all site-specific logic into a small **adapter**.

### Source-discovery tiers (adapter resolves one)

| Tier | Technique | Tooling |
|---|---|---|
| T1 — Structured API | Capture XHR/fetch calls via browser devtools/network; probe known patterns (`/api`, `/graphql`, `_next/data`) | browser tools, `fetch_webpage`, `run_in_terminal` (curl/Invoke-RestMethod) |
| T2 — Declared feed | `sitemap.xml`, RSS/Atom, `JSON-LD` (`<script type="application/ld+json">`), OpenGraph | `fetch_webpage`, terminal |
| T3 — HTML scrape | Render + extract with Playwright when no structured data exists | browser/playwright tools |

The adapter's only job: emit a normalized `manifest.json` + per-item metadata in the **canonical schema** below. All downstream phases are source-independent.

### Canonical event-item schema

```jsonc
{
  "id": "BRK246",                // stable code/slug
  "group": "developer-tools",    // optional grouping
  "title": "...",
  "speakers": [{ "name": "...", "role": "...", "org": "..." }],
  "startUtc": "2026-06-02T16:30:00Z",
  "durationMin": 45,
  "description": "...",          // plain text/markdown
  "aiSummary": "...",            // optional
  "tags": ["..."],
  "watchUrl": "https://...",
  "transcriptUrl": "https://...",// docx | vtt | srt | txt
  "videoUrl": "https://...",     // for single poster frame only
  "related": ["..."]
}
```

### Asset-acquisition (source-independent, reusable)

- **Transcript normalize:** detect by byte signature (`50 4B` = DOCX zip → extract `word/document.xml`; `WEBVTT`/SRT/text → passthrough) → `transcript.txt`.
- **Poster frame:** ffmpeg HTTP range-seek + brightness validation, uniform filename, no full download.
- **Idempotency:** manifest-driven, skip-existing, `-Skip`/`-Take`, JSON logs per phase.

### Guardrails (must be encoded in the agent + context)

- Only **public, anonymous** content. No login, token, paywall, or CAPTCHA bypass.
- Respect `robots.txt`, site ToS, and polite rate limiting (throttle + retry/backoff).
- Single poster frame only — never re-host or redistribute full media.
- Preserve attribution (`watchUrl`, speaker credits) in every `summary.md`.
- Treat fetched page/transcript content as **untrusted** — stay alert to prompt-injection in scraped text.

## 🧱 Proposed PE artifacts

| # | Artifact | Path | Role |
|---|---|---|---|
| A1 | **Context** | `.copilot/context/90.00-learning-hub/08-event-site-ingestion.md` | Canonical schema, discovery tiers, asset techniques, output layout, guardrails (the reusable knowledge) |
| A2 | **Skill** | `.github/skills/event-site-ingestion/SKILL.md` (+ `scripts/`) | AI-discovered procedure bundling the parameterized scripts + step recipes |
| A3 | **Agent** | `.github/agents/90.00-learning-hub/event-ingestion.agent.md` | Persona + scoped tools + boundaries that orchestrate end-to-end |
| A4 | **Prompt** | `.github/prompts/90.00-learning-hub/learninghub-ingest-event-site.prompt.md` | Thin `/command` entry point that hands off to the agent/skill |
| A5 | **Scripts** | `scripts/event-ingestion/*.ps1` | Generalized `build-manifest`, `gen-summaries`, `fetch-transcripts`, `gen-frames`, `build-index`, parameterized by an adapter config |

## 🛠️ Implementation steps

> Each step is a discrete, verifiable unit. Marking uses suffix notation per `plan-marking.instructions.md` (e.g. `… (✅ done)`), never checkboxes.

### Phase 1 — Extract & generalize the scripts

1. Copy the four temp scripts (`gen-summaries.ps1`, `convert-transcripts.ps1`, `gen-frames.ps1`, `fix-frames.ps1`) into `scripts/event-ingestion/` and strip all Build-specific literals (API base, PDT offset, folder roots) into a `adapter.config.json`.
2. Refactor `gen-summaries.ps1` to read the **canonical schema** `manifest.json` instead of calling the Build API directly; the API call moves into an adapter (`adapters/build.ps1`).
3. Add a `build-index.ps1` that emits the master `readme.md` from the manifest.
4. Add a `bundle ffmpeg` resolver: detect a system `ffmpeg`, else use a configured portable path; never assume admin install.

### Phase 2 — Author the context file (A1)

5. Write `08-event-site-ingestion.md` documenting the canonical schema, the three discovery tiers, asset-acquisition recipes, the per-item output layout, and the guardrails. Follow `documentation.instructions.md` + dual-metadata.

### Phase 3 — Author the skill (A2)

6. Create `.github/skills/event-site-ingestion/SKILL.md` per `pe-skills.instructions.md`, with a description tuned for discovery ("ingest a public event/conference/content site into Learning Hub"), step recipes, and the `scripts/` referenced relatively.

### Phase 4 — Author the agent (A3)

7. Create `event-ingestion.agent.md` per `pe-agents.instructions.md`: scoped tools (`run_in_terminal`, `fetch_webpage`, browser/playwright tools, file ops), explicit `✅ Always / ⚠️ Ask first / 🚫 Never` boundaries encoding the guardrails, and a phased workflow with summarization between phases.

### Phase 5 — Author the prompt entry point (A4)

8. Create `learninghub-ingest-event-site.prompt.md` per `pe-prompts.instructions.md`: required YAML frontmatter, an `argument-hint` for the target site URL, and a handoff to the agent.

### Phase 6 — Validate end-to-end

9. Dry-run the new artifacts against a **second** public source (e.g. a small public talk list or the Build site re-run) to prove the adapter boundary holds.
10. Run the PE validation skill (`pe-prompt-engineering-validation`) over A1–A4; fix C/H findings.
11. Confirm output parity with the Build run: per-item `summary.md` + `transcript.txt` + `images/` + master index, all idempotent on re-run.

## ✅ Exit criteria

- A1–A5 exist, pass their respective instruction-file checklists, and cross-reference each other correctly.
- A fresh ingestion of a public source produces the canonical layout with zero manual edits.
- Re-running is idempotent (skip-existing) and batchable (`-Skip`/`-Take`).
- All guardrails are encoded in both the agent boundaries and the context file.

## 🅿️ Park lot

- Authenticated/paywalled source ingestion → `defer` (separate plan; raises legal/ToS scope).
- Full-video archival / clip extraction → `closed: out of scope — single poster frame only by design`.
- Auto-wiring ingested folders into the Quarto sidebar → `→ learninghub-sidebar-menu` (existing prompt already owns this).
- Speaker-photo / per-slide image extraction beyond one poster → `defer`.
- Non-PowerShell (cross-platform `bash`/Python) script variants → `defer`.

## 📚 References

- 📖 `.github/instructions/pe-prompts.instructions.md`, `pe-agents.instructions.md`, `pe-skills.instructions.md`, `pe-context-files.instructions.md`
- 📖 `.github/instructions/plan-execution.instructions.md`, `plan-marking.instructions.md`
- 📖 `.copilot/context/00.00-prompt-engineering/01.03-file-type-decision-guide.md` — which artifact type for which need
- 📒 Reference implementation (temp, to be generalized): `gen-summaries.ps1`, `gen-frames.ps1`, `convert-transcripts.ps1`
- 🔗 Sibling use-case overview: [overview.md](overview.md)
