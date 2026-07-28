---
title: "Investigation backlog — VS Code 1.131 (Insiders)"
publish: false
---

# Investigation backlog

Items surfaced during this investigation that are **out of scope for this run** but worth revisiting.

| # | Item | Why deferred | Revisit when |
|---|---|---|---|
| 1 | Reframe `03.00-tech/05.02-prompt-engineering/03-concepts/01.08-chat-modes-agent-hq-and-execution-contexts.md` around the Agent Host process model | Overwrite/restructure of a published article — gated since the 1.130 investigation | The Agent Host ships stable and `01.08` is scheduled for a revision pass |
| 2 | Add a "migrating and retiring prompt files" section to `04-howto/03.00-how-to-structure-content-for-copilot-prompt-files.md` | The **Migrate Prompts** command ([#325660](https://github.com/microsoft/vscode/issues/325660)) is Insiders-only and its triage UX is still moving | The command reaches a stable release and the target prompt format is final |
| 3 | Confirm which speech model powers built-in on-device dictation, and whether the per-language extension packs from the Speech extension are still required | The release notes do not name the engine; the official Voice support doc still documents the extension-era language packs | Official docs are updated for the built-in stack |
| 4 | Document the settings surface for built-in voice (successors or equivalents of `accessibility.voice.speechTimeout`, `accessibility.voice.autoSynthesize`, `accessibility.voice.keywordActivation`, `accessibility.voice.speechLanguage`) | The 1.131 notes describe behaviour changes without listing setting IDs; guessing IDs would put unverifiable claims in a published article | Setting IDs appear in official docs or the settings UI |
| 5 | Verify whether "Hey Code" keyword activation and walky-talky mode carry over to the built-in engine | Not mentioned in the 1.131 notes; only documented for the extension | Official docs cover built-in voice end to end |
| 6 | Evaluate whether streaming command output changes recommended agent-tool patterns (for example long-running builds in `09.50-how-to-leverage-tools-in-prompt-orchestrations.md`) | Needs hands-on observation of how streaming interacts with tool-call timeouts | After using streaming output in a real orchestration |

## Open questions carried forward

- Does built-in dictation stay fully on-device the way the Speech extension did? The notes say "built-in on-device", which reads as yes, but no privacy statement accompanies the change.
- Does read-aloud TTS use system voices or a bundled synthesiser?
- Is the extension auto-disable reversible per workspace, or global?
