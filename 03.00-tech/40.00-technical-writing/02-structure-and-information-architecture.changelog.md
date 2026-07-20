---
title: "02-structure-and-information-architecture — change history"
description: "Per-version change history for 02-structure-and-information-architecture."
last_updated: "2026-07-20"
status: "living"
---

# Change history — 02-structure-and-information-architecture

## v1.0.1 — 2026-07-20

Reframed all Quarto references for the current architecture: the Learning Hub builds navigation at runtime from the folder hierarchy (Learn.Web / DynamicNavBuilder) with an optional per-folder `metadata.yml`, replacing the retired `_quarto.yml` `website.sidebar` example, the "Navigation design" section, and the `_quarto.yml` / `generate-navigation.ps1` reference entries (now pointing at the runtime nav rules and `DynamicNavBuilder`).
