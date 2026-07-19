---
title: "MarkItDown observation — investigation backlog"
author: "Dario Airoldi"
date: "2026-07-13"
categories: [research, backlog, markitdown]
description: "Concrete questions to resolve per track and the authoritative sources consulted."
---

# MarkItDown observation — investigation backlog

> Workflow step 5: focused-investigation backlog (local-first, then authoritative external).

## A1 — What MarkItDown is

- [x] Who publishes it, license, maturity signals — GitHub `microsoft/markitdown`, PyPI.
- [x] Stated purpose and intended consumer (LLM/text-analysis vs human-fidelity).
- [x] Supported input formats.

## A2 — How it works

- [x] Install / CLI / Python API surface.
- [x] Converter-based architecture and plugin model.
- [x] Optional dependencies per format.
- [x] LLM image-description integration.
- [x] Azure Document Intelligence and Content Understanding integrations.
- [x] Security model (I/O privileges, `convert_*` surface).

## A3 — Similar tools

- [x] Docling (IBM / LF AI & Data) — GitHub repo verified.
- [x] Marker (Datalab) — GitHub repo verified (incl. vendor benchmark).
- [x] textract — cross-reference from MarkItDown README.
- [ ] pandoc, Unstructured, LlamaParse, PyMuPDF4LLM — from general knowledge; **verify before publishing**.

## 📚 Authoritative sources consulted

| Source | Classification |
|---|---|
| [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown) | 📘 Official |
| [pypi.org/project/markitdown](https://pypi.org/project/markitdown/) | 📘 Official |
| [github.com/docling-project/docling](https://github.com/docling-project/docling) | 📗 Verified Community (LF AI & Data / IBM) |
| [github.com/datalab-to/marker](https://github.com/datalab-to/marker) | 📗 Verified Community (vendor repo) |
