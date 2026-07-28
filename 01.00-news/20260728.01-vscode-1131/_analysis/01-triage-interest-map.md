---
title: "Triage and interest map — VS Code 1.131 (Insiders)"
publish: false
---

# Triage and interest map

## Observation intake

| Field | Value |
|---|---|
| Source file | `01.00-news/20260728.01-vscode-1131/overview.md` |
| Observation type | Raw paste of release notes |
| External source | `https://code.visualstudio.com/updates/v1_131` 📘 [Official] |
| Source verdict | `sound` — first-party vendor release notes |
| Triage verdict | `proceed` |

## Context signals

| Signal | Evidence | Implication |
|---|---|---|
| Local paste is incomplete | `overview.md` contains only the **July 24, 2026** slice (5 bullets) plus page boilerplate; the July 21–23 sections are missing | The full source had to be retrieved before analysis — 15 items total across four days |
| No frontmatter | `overview.md` has no top YAML | The file is a raw capture, not a publishable article — Step 11 rewrite required |
| Sibling precedent (canonical) | `01.00-news/20260722-vscode-v1.130-release/` uses `01-summary.md` + `images/` + `_analysis/` | Local convention for a VS Code release entry — replicate it |
| Sibling precedent (consolidation) | `01.00-news/20260723.01-vscode-rel/overview.md` was rewritten as a short "see the canonical summary" pointer | Established pattern for Step 11 issue completion |
| Insiders build | Page title reads *"Visual Studio Code 1.131 (Insiders)"*, notes "continue to evolve as new features are added" | Availability column must say **Insiders** — content is not yet stable |
| Release cadence | 1.128 (Jul 8) → 1.130 (Jul 22) → 1.131 (Jul 24) all have news entries | The Learning Hub already tracks this series; 1.131 continues the arc |

## Candidate areas

Scores are 1–5. `learning_impact` weighs how much a durable Learning Hub article would gain.

| # | Candidate area | Items | relevance | urgency | learning_impact | confidence |
|---|---|---|---|---|---|---|
| A | **Built-in on-device voice stack** — dictation in editor + terminal, read-aloud TTS, incremental refinement, list formatting, filler-word filtering, mic quick actions, extension-voice auto-disable, hands-free/auto-send semantics | 9 | 5 | 4 | 5 | 5 |
| B | **Agents window UX** — custom session groups, single-file diff in single-pane layout, quick-pick folder selection, fuzzy `#` file search in the Agent Host input box | 4 | 4 | 3 | 3 | 5 |
| C | **Terminal and command execution** — streaming command output, dimensions-overlay toggle | 2 | 4 | 3 | 3 | 5 |
| D | **Prompt lifecycle** — Migrate Prompts with triage and cleanup actions | 1 | 5 | 4 | 4 | 4 |
| E | **Chat** — timestamps on older conversations | 1 | 2 | 2 | 1 | 5 |

## Reading of the release

Nine of fifteen items belong to area **A**. That is not incremental polish — it is the same kind of move the Learning Hub already documented for agents in 1.130: a capability **migrates out of an extension and into the product**.

- In 1.130, agent sessions moved from the extension host into a dedicated **Agent Host** process.
- In 1.131, voice moves from the **VS Code Speech extension** into a built-in, on-device engine — and VS Code now *auto-disables* extension-provided voice mode when the built-in one is used.

The official [Voice support](https://code.visualstudio.com/docs/configure/accessibility/voice) 📘 [Official] doc still describes the extension-based model, so the 1.131 notes are ahead of the docs. That gap is exactly where a Learning Hub explainer adds value.

## Triage decision

- **A** → deep track. Clear coverage gap, high durable value.
- **B**, **C**, **D** → standard track, folded into the release summary.
- **E** → light track, one line in the release summary.
