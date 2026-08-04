---
title: "Proposed result package — VS Code 1.131 (Insiders)"
publish: false
---

# Proposed result package

## Selected workflow pattern

`release-notes-to-summary-plus-concepts-article` — the pattern established by the 1.130 investigation, extended with one durable tech article because this release contains a genuine coverage gap rather than only incremental change.

## Deliverables

| # | Deliverable | Path | Mode | Status |
|---|---|---|---|---|
| 1 | Canonical release summary | `01.00-news/20260728.01-vscode-1131/01-summary.md` | Additive — new file | Proposed |
| 2 | Concepts article on the built-in voice stack | `03.00-tech/05.02-prompt-engineering/03-concepts/01.10-understanding-voice-input-dictation-and-read-aloud.md` | Additive — new file | Proposed |
| 3 | Roadmap row for the new concepts article | `03.00-tech/05.02-prompt-engineering/ROADMAP.md` | Additive — one row, one count | Proposed |
| 4 | Issue completion rewrite | `01.00-news/20260728.01-vscode-1131/overview.md` | Rewrite of a raw capture | Proposed |

## Deliverable 1 — release summary outline

Follows the 1.130 `01-summary.md` shape.

- Frontmatter: `title`, `author`, `date: "2026-07-28"`, `categories: [vscode, release, voice, dictation, agents]`, `description`
- Source callout: classified link plus the provenance snapshot at `images/001.01-source.png`
- Table of contents
- **Release at a glance** table — Availability column reads *Insiders* throughout
- **Voice moves in-box** — the delivery-model change, with a Before/After table
- **Dictation you can actually write prose with** — incremental refinement, list formatting, filler-word filtering
- **Turn control and microphone handling** — the hands-free/auto-send change and its trap
- **Agents window** — session groups, single-file diff, folder quick-pick, fuzzy `#` search
- **Terminal and command execution** — streaming output, dimensions overlay
- **Prompts** — Migrate Prompts, with the Insiders caveat
- **Chat** — timestamps on older conversations
- **Where this fits** — links to the 1.130 and 1.128 summaries and the new concepts article
- **References** — classified, each with a description

## Deliverable 2 — concepts article outline

Placed in `03-concepts/` because voice is an input modality for the chat and agent surfaces that `01.02`–`01.09` already explain. Next free number in that band is `01.10`.

- What voice actually does in VS Code today — editor dictation, chat voice, terminal voice, read-aloud
- The delivery model, before and after — extension-provided versus built-in on-device
- Why it stays on-device, and what that buys you
- What makes a transcript usable — refinement, structure, filler removal
- Turn control: hands-free versus explicit send
- What to re-check in an existing setup
- Where the docs are still behind
- References

Deliberately **excludes** setting IDs — the 1.131 notes name none, and the published `accessibility.voice.*` keys belong to the extension era. Backlog items 4 and 5 track the follow-up.

## Deliverable 4 — issue completion

`overview.md` becomes a short pointer to the published `01-summary.md`, with proper frontmatter added. It doesn't duplicate the summary or expose working analysis.

## Explicitly out of scope

| Item | Reason |
|---|---|
| Reframing `03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md` | Gated — overwrite of a published article |
| Amending `04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md` | Gated — overwrite based on Insiders-only behaviour |
| Any navigation or `metadata.yml` change | Navigation is built at runtime from the content hierarchy; new files appear without edits |
