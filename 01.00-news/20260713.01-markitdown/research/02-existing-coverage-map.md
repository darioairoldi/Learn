---
title: "MarkItDown observation — existing LearnHub coverage map"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, coverage-map, markitdown, taxonomy]
description: "Internal grounding: what LearnHub already covers for each MarkItDown candidate area, mapped to the documentation taxonomy."
---

# MarkItDown observation — existing LearnHub coverage map

> Workflow step 3: internal grounding before locking priorities.

## 🗺️ Coverage by area

| Area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| A1 — What MarkItDown is | **absent** | none found (one incidental Build-2026 mention only) | Overview |
| A2 — How it works | **absent** | none found | Concepts |
| A3 — Similar tools / alternatives | **absent** | `03.00-tech/20.01-markdown/` covers publishing tools, not converters | Analysis |

## 🧩 Nearest existing content

- `03.00-tech/20.01-markdown/01-quarto/`, `02-mkdocs/`, `03-hugo/` — Markdown **authoring/publishing** stack. Adjacent ecosystem, different job (produce sites *from* Markdown, not produce Markdown *from* documents).
- `02.00-events/202606-build-2026/05-windows/brk261-.../summary.md` — single passing mention of MarkItDown as a demo workload.

## Deduction

MarkItDown (and document-to-Markdown conversion generally) is a genuine **gap** in the corpus. It belongs in the Markdown tech area as a sibling to the publishing tools, because it is the "ingest" half of the Markdown ecosystem the Hub already documents on the "publish" side.
