---
title: "Analysis — Agents window, terminal, and prompt lifecycle"
publish: false
---

# Analysis — Agents window, terminal, and prompt lifecycle

## Problem statement

Six of the fifteen 1.131 items sit outside voice. They touch the Agents window, the terminal, prompt files, and chat history. Each is small on its own. The question is whether any of them justifies more than a release-summary section, and whether any of them contradicts what the Learning Hub already published.

## Additional considerations

### The items

| Area | Item | Issue |
|---|---|---|
| Agents window | Easier custom session-group creation | [#327153](https://github.com/microsoft/vscode/issues/327153) |
| Agents window | Open a single-file diff from the Changes list in single-pane layout | [#327012](https://github.com/microsoft/vscode/issues/327012) |
| Agents window | Quick-pick folder selection in the new-session view | [#326987](https://github.com/microsoft/vscode/issues/326987) |
| Agent Host | Fuzzy `#` file search in the Agent Host input box | [#326474](https://github.com/microsoft/vscode/issues/326474) |
| Terminal | Streaming of command output | [#324825](https://github.com/microsoft/vscode/issues/324825) |
| Terminal | Ability to disable the dimensions overlay during resize | [#295790](https://github.com/microsoft/vscode/issues/295790) |
| Prompts | Migrate Prompts with triage and cleanup actions | [#325660](https://github.com/microsoft/vscode/issues/325660) |
| Chat | Timestamps on older conversations | [#324482](https://github.com/microsoft/vscode/issues/324482) |

### Relationship to existing coverage

- The **Agent Host** is documented in the 1.130 summary. The fuzzy `#` search item is notable mainly because of *why* it existed: the Agent Host input box had drifted from the local chat input. It is a parity fix, and parity fixes are the expected cost of running agents in a separate process — which is a point the 1.130 article already sets up.
- **Agents window UX** has been covered incrementally across v1.107, v1.128, and v1.130. Three more refinements continue that line.
- **Chat timestamps** were introduced in 1.130 behind `chat.verbose`; 1.131 extends them to older conversations. Strictly an extension of covered ground.

### The two items that are more than polish

**Streaming command output.** Until now an agent running a long command produced nothing until the command finished. Streaming turns a black box into something you can watch — and, more importantly, something you can interrupt early when it is clearly going wrong. That changes the feedback loop for long builds and test runs, not just the visuals.

**Migrate Prompts.** This is lifecycle tooling for prompt files: review what you have, move it to the new format, and delete what is stale. The Learning Hub covers prompt authoring and organisation well, but nothing about retiring prompts. That is a real gap — it is just not one that can be filled responsibly yet.

## Deductions

1. **Nothing here contradicts published Learning Hub content.** No corrections needed.
2. **Nothing here warrants a standalone article.** Splitting three Agents-window tweaks into their own piece would fragment material that reads better as a release narrative.
3. **Streaming output deserves its own release-summary section**, framed around the feedback loop rather than the UI.
4. **Prompt migration is a documented gap with a premature fix.** The command is Insiders-only and its triage UX is still changing. Amending a stable how-to on that basis would date the article quickly. Cover it in the summary; log the amendment as backlog item 2.
5. **The fuzzy `#` search item is worth one sentence of context**, not a section — it illustrates the parity cost of the Agent Host split.

## Conclusions

- Fold all six areas into the release summary as sections or bullets, sized to their impact.
- Give streaming command output a short section of its own.
- Mention Migrate Prompts, note the Insiders caveat, and do not touch `04-howto/03.00`.
- Do not create any tech article from this track.

## Appendix A — Evidence

| Claim | Evidence |
|---|---|
| All eight non-voice items and their issue numbers | Release notes for July 21–24, 2026 — see the table above |
| Agent Host process model already covered | `01.00-news/20260722-vscode-v1.130-release/01-summary.md` § "The Agent Host and AHP" |
| Chat timestamps introduced in 1.130 via `chat.verbose` | Same summary, § "Chat" |
| Agents window covered incrementally | Release summaries in `20251224-vscode-v1.107-release/`, `20260708-vscode-v1.128-release/`, `20260722-vscode-v1.130-release/` |
| Prompt authoring covered, retirement not | `02-getting-started/02.00-how-to-name-and-organize-prompt-files.md`, `04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md` |

## Appendix B — Validation

| Check | Result |
|---|---|
| Every item mapped to an area and an issue | ✅ |
| Cross-checked against existing Learning Hub articles | ✅ No contradictions found |
| No stable article amended on Insiders-only evidence | ✅ Deferred to backlog item 2 |
| Claims about prior releases verified against local files | ✅ Read from the 1.130 summary, not recalled |
