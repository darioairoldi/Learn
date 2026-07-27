---
title: "Analysis — one year of an open-weight model"
publish: false
---

# One year of an open-weight model

Area **A1 — gpt-oss model specifics** (scored `absent` in artifact 02). Investigated after the source-soundness gate verdict was revised; see [artifact 03](../03-source-soundness-gate-verdict.md).

## Problem

The Hub has thirteen files covering the Foundry Local / Windows AI Foundry runtime family and **zero** mentioning `gpt-oss`. That leaves a reader who opens the Foundry Local catalog unable to answer three practical questions from Hub content:

1. Is this model still current, and who would ship an update if it weren't?
2. What did the surrounding platform do while the model sat still?
3. When should I pick this model over the others in the same catalog?

A secondary problem is a **framing error** the originating question exposed: treating "gpt-oss" and "Foundry Local models" as alternatives. They aren't — gpt-oss is a Foundry Local catalog model, listed first among its chat-completion options.

## Considerations

**Open-weight release cadence differs structurally from hosted cadence.** A hosted model's identity is an endpoint; capability changes underneath a stable name. An open-weight model's identity is a file hash; capability is fixed at download. Any "is it current?" question therefore has a different shape for each, and conflating them produces bad expectations in both directions.

**Absence of releases is evidence, not a gap in research.** Eleven months of no base-model update is a *finding*, provided it's established from a first-party, timestamped source rather than inferred from silence. The Hugging Face "last updated" field and the GitHub release list both supply that.

**Maintainership determines escalation paths.** If Microsoft were the maintainer, "will this improve?" would be a Foundry roadmap question. It isn't. Microsoft distributes and optimizes (catalog hosting, ONNX quantization); OpenAI owns the weights and has closed the repo to feature contributions. That reframes what a reader can reasonably expect from either party.

**Platform movement and model movement are independent axes.** The Hub's own Build 2026 material documents substantial runtime change (Foundry Local GA, Windows ML GA, Windows ML CLI, WebNN, Ion, Windows ML 2.0) over precisely the interval in which the model didn't change. Treating "gpt-oss is stale" as "local AI is stale" would be a category error.

**Model selection has three axes, not one.** Model choice within a catalog, runtime choice for a given set of weights, and tier choice per task are separable. Portable weights make axis 2 reversible, which is itself an argument for open weights independent of benchmark scores.

**Constraints are asymmetric in kind.** The harmony format requirement is binary — wrong format yields broken output, not degraded output. The 16GB memory floor is a hard envelope. The SWE-bench Pro score of 16.2 is a soft quality expectation. These need different treatment in guidance: two are gates, one is a caveat.

## Deductions

- The **durable article** here is a *timeline plus a decision frame*, not an announcement recap. The announcement is the measurement baseline; the year since is the content.
- **Freezing is simultaneously the feature and the limitation.** Reproducibility and auditability come from the same property that produces capability aging. Guidance must present it as a trade, not a defect.
- **Ecosystem derivative counts are the real activity signal** for a frozen model. 214 adapters and 106 finetunes from `gpt-oss-120b` mean iteration continued — it just moved to third parties, transferring the evaluation and provenance burden to the adopter.
- The **`gpt-oss-safeguard` line is adjacent, not successor.** Its download ratio against the base model (~99k vs ~7.98M per month) confirms it serves a specialized moderation role rather than continuing the general-purpose line.
- **MoE parameter counts break naive tier rules.** Qualcomm's ≤13B on-device heuristic would exclude `gpt-oss-20b` at 21B total, yet 3.6B active parameters give it a much lighter compute profile. Memory, not parameter count, is the binding constraint — the heuristic needs that qualifier to stay useful.
- **The premise correction belongs in the article body**, not a footnote. A reader carrying the "gpt-oss vs Foundry Local" framing will misread everything downstream of it.

## Conclusions

Write one explanation-type article that:

1. Uses the August 2025 announcement as an explicit, dated **baseline** with a source-provenance callout — not as news.
2. Documents the **eleven-month freeze** with first-party timestamps, alongside what *did* ship (safeguard derivative, tooling releases, community derivatives).
3. Separates **maintainer from distributor** in a table, and states the Apache-2.0 consequence plainly, since licensing often decides before benchmarks do.
4. Devotes a section to **roadmap movement in the surrounding products**, sourced from the Hub's own Build 2026 corpus rather than vendor marketing.
5. Corrects the **catalog-membership premise**, then gives reach-for / look-elsewhere criteria on the model axis.
6. Cross-links the seven existing local-AI event summaries so the article acts as the entry point rather than duplicating them.

Explicitly **out of scope**: the broader "local open-weight versus hosted frontier" tier-selection framework. That remains a `03.00-tech/` consolidation task and is recorded as still-open in artifact 03.

---

## Appendix A — Evidence

| # | Claim | Source | Verified |
|---|---|---|---|
| E1 | Launch: `gpt-oss-120b` (117B/5.1B active), `gpt-oss-20b` (21B/3.6B active), 80GB GPU and 16GB envelopes | Azure Blog, Aug 5, 2025 📘 | 2026-07-27 |
| E2 | Base model cards last updated **Aug 26, 2025** | huggingface.co/openai/gpt-oss-120b, -20b 📘 | 2026-07-27 |
| E3 | Latest repo release **v0.0.9**, ~6 months ago, 6 releases total; recent commits are tooling only | github.com/openai/gpt-oss 📘 | 2026-07-27 |
| E4 | Repo governance: *"Outside of bug fixes we do not intend to accept new feature contributions"*; Apache-2.0; ~20.3k stars, 2.1k forks, 63 contributors | github.com/openai/gpt-oss 📘 | 2026-07-27 |
| E5 | `gpt-oss-safeguard-120b` Oct 29, 2025; `-20b` updated Jan 14, 2026; custom safety policies at inference time | Hugging Face model cards 📘 | 2026-07-27 |
| E6 | Downloads/month: base 20b **7.98M**, base 120b **4.33M**, safeguard-20b **99.2k**, safeguard-120b **2.5k** | Hugging Face 📘 | 2026-07-27 |
| E7 | Derivatives from `gpt-oss-120b`: 214 adapters, 106 finetunes, 121 quantizations, 1 merge | Hugging Face 📘 | 2026-07-27 |
| E8 | Benchmarks vs o3 / o4-mini (MMLU, GPQA Diamond, HLE, AIME 2024/2025) | openai.com/open-models 📘 | 2026-07-27 |
| E9 | `gpt-oss-120b` SWE-bench Pro = **16.2** | openai.com/open-models 📘 | 2026-07-27 |
| E10 | Harmony format mandatory; configurable reasoning effort; CoT *"not intended to be shown to end users"*; MXFP4 MoE quantization | Model card, arXiv:2508.10925 📗 | 2026-07-27 |
| E11 | Foundry Local: SDK-first (~20MB, ONNX Runtime, in-process), Windows + macOS + Linux, OpenAI Responses API format, Windows ML packages, Foundry Local on Azure Local, explicit not-a-server boundary, curated catalog rationale | learn.microsoft.com *What is Foundry Local?* (`ms.date: 2026-05-15`, updated 2026-07-14) 📘 | 2026-07-27 |
| E12 | Catalog lists chat models *"(for example, GPT OSS, Qwen, DeepSeek, Mistral, and Phi)"* plus Whisper | learn.microsoft.com 📘 | 2026-07-27 |
| E13 | Build 2026: Foundry Local GA, Windows ML GA, Windows ML CLI preview, WebNN, Ion (Phi Silica successor), Windows ML 2.0 preview, Windows AI APIs beyond Copilot+ | Hub — BRK260 summary | 2026-07-27 |
| E14 | Tiered routing ≤13B on-device / 14–34B on-prem / 70B+ cloud; 67% cloud-token and 70% latency reduction; Snapdragon X2 Elite 80 TOPS | Hub — BRKSP90 summary | 2026-07-27 |
| E15 | Hub coverage scan: 0 matches for `gpt-oss`; 98 matches across 13 files for the Foundry Local family | Repo grep | 2026-07-27 |

## Appendix B — Validation

| Check | Result |
|---|---|
| Every quantitative claim traced to Appendix A | ✅ Pass |
| First-party sources for all model facts | ✅ Pass — OpenAI properties for weights/releases, Microsoft Learn for runtime |
| Roadmap claims grounded in local evidence first | ✅ Pass — E13 and E14 come from the Hub's own Build 2026 summaries, not vendor marketing |
| No competitive framing ("ahead of", "behind") | ✅ Pass — the gpt-oss-absent-from-Build-2026-demos observation is stated as an emphasis signal, not a ranking |
| Implementation-maturity gaps not labelled as design gaps | ✅ Pass — the freeze is attributed to release cadence, and the Foundry Local server boundary is reported as a stated non-goal |
| Premise correction included | ✅ Pass — catalog membership stated before the selection criteria |
| Hard gates distinguished from soft caveats | ✅ Pass — harmony format and 16GB treated as gates; SWE-bench Pro as an expectation |
| Claims that could age fastest | ⚠️ E2, E3, E6, E7 are point-in-time. Each is dated in the article so a later reader can re-check. |
| Out-of-scope items recorded rather than silently dropped | ✅ Pass — terminology sweep and tier-framework consolidation carried in artifact 03 |
