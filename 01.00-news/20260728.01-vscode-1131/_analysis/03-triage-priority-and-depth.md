---
title: "Triage priority and depth — VS Code 1.131 (Insiders)"
publish: false
---

# Triage priority and depth

## Priority tracks

| Track | Areas | Depth | Rationale |
|---|---|---|---|
| **Deep** | Built-in on-device voice stack | Dedicated analysis + concepts article + release-summary section | 9 of 15 release items; coverage `absent`; architectural shift (extension → in-box) with lasting relevance |
| **Standard** | Agents window UX · Terminal and command execution · Prompt lifecycle | Combined analysis note + release-summary sections | New or refined behaviour on ground the Hub already covers; value is in the delta, not a new mental model |
| **Light** | Chat timestamps · Terminal dimensions overlay | Release-summary bullets only | Low learning impact, self-explanatory |

## Depth justification

### Why voice gets a deep track

Three signals line up:

1. **Volume.** The release is dominated by it — dictation refinement, list formatting, filler-word filtering, editor and terminal dictation, read-aloud TTS, mic quick actions, extension auto-disable, and hands-free/auto-send semantics.
2. **Architecture.** [#326969](https://github.com/microsoft/vscode/issues/326969) extends *built-in on-device* dictation beyond chat, and [#327000](https://github.com/microsoft/vscode/issues/327000) auto-disables extension-provided voice mode. Taken together, the VS Code Speech extension stops being the delivery vehicle.
3. **Documentation lag.** The official [Voice support](https://code.visualstudio.com/docs/configure/accessibility/voice) 📘 [Official] page still opens with "install the VS Code Speech extension". A reader following the docs today builds the wrong mental model.

### Why the rest stays standard or light

The Agents window, terminal, and prompt items are refinements of surfaces the Hub already explains. Writing separate articles for each would fragment the material and duplicate the 1.128/1.130 summaries. They belong in the release summary, where the reader sees them in context.

## Integration mode per area

| Area | Mode | Target |
|---|---|---|
| Built-in voice stack | Autonomous — additive | New concepts article + release-summary section |
| Agents window UX | Autonomous — additive | Release-summary section |
| Terminal and command execution | Autonomous — additive | Release-summary section |
| Prompt lifecycle | Autonomous — additive (summary only) | Release-summary section; backlog item for the how-to amendment |
| Chat / terminal overlay | Autonomous — additive | Release-summary bullets |
| `01.08` Agent Host reframing | **Gated** | Not touched |
