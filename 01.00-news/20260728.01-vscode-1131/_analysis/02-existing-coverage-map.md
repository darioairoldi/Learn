---
title: "Existing coverage map — VS Code 1.131 (Insiders)"
publish: false
---

# Existing coverage map

## Method

- `grep_search` for `speech|text-to-speech|accessibility|microphone` across `03.00-tech/**` → 163 matches in 31 files, **none** about VS Code voice input. Every hit was technical-writing accessibility guidance, Quarto theming, an audio-transcription mention in the MarkItDown article, or ARIA examples in prompt-engineering samples.
- `grep_search` for `dictation|Voice Mode|Agent Host|hands-free` → 83 matches in 25 files, all on the **Agent Host** side; zero on voice.
- `file_search` across `03.00-tech/05.02-prompt-engineering/**` → 55 files, folders `01-overview` / `02-getting-started` / `03-concepts` / `04-howto` / `05-analysis` / `06-reference`, articles numbered `NN.NN-kebab-title.md`.

## Coverage by area

| Area | Coverage | Local evidence | Taxonomy |
|---|---|---|---|
| Built-in on-device voice stack (dictation, TTS, Voice Mode) | `absent` | No article mentions VS Code voice input, dictation, or speech-to-text. `03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md` covers chat surfaces but only keyboard/text modalities | Concepts |
| Agent Host (the runtime the fuzzy `#` search lands in) | `present` | `20260722-vscode-v1.130-release/01-summary.md` § "The Agent Host and AHP" documents the process model and AHP | Overview / News |
| Agents window UX | `partial` | Release summaries for v1.107, v1.128, v1.130 each cover a slice; `01.08` describes worktrees as Copilot-only | Overview / News |
| Terminal streaming command output | `absent` | Terminal coverage in past summaries is limited to link handling (`diff.mnemonicPrefix` in 1.130) | Overview / News |
| Prompt file lifecycle and migration | `partial` | `02-getting-started/02.00-how-to-name-and-organize-prompt-files.md` and `04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md` cover authoring and placement, but nothing on migrating or retiring prompts | How-to |
| Chat timestamps | `partial` | 1.130 summary covers hover timestamps via `chat.verbose`; 1.131 extends them to older conversations | Overview / News |
| Terminal dimensions overlay | `absent` | Not covered — low learning impact | Overview / News |

## Integration priority assessment

- **Built-in voice stack** — entirely new topic, no article to overwrite, and the official docs still describe the superseded extension model. Clear gap, purely **additive** → **autonomous**. Warrants both a section in the release summary *and* a durable concepts article.
- **Agents window / Agent Host UX** — incremental refinements on ground already covered → fold into the release summary, no separate article.
- **Streaming command output** — new but small; it changes how you *watch* an agent work rather than what it can do → release summary section.
- **Prompt migration and triage** — genuinely useful, but the "Migrate Prompts" command is Insiders-only and its final shape is unsettled. Cover it in the release summary and record a backlog item rather than amending the stable how-to articles now.
- **Chat timestamps, terminal overlay** — one line each in the release summary.

## Gated items

| Item | Why gated |
|---|---|
| Restructuring `03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md` to adopt Agent Host-era framing | Carried over from the 1.130 investigation and still open. It is an **overwrite/restructure** of a published article, not an additive change. Not touched by this run. |
| Amending `04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md` with a migration section | Overwrite of a stable how-to based on an Insiders-only, still-changing command. Deferred to the backlog. |
