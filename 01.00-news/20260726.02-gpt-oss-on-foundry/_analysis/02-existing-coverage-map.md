---
title: "Existing LearnHub coverage map — local/open-weight model inference"
publish: false
---

# Existing LearnHub coverage map

Internal grounding for each candidate area, before priorities are locked.

## Coverage table

| Area | Coverage | Local evidence | Taxonomy category |
|---|---|---|---|
| **A1** — gpt-oss model family specifics | `absent` | `gpt-oss` returns **0 matches** repo-wide | Reference |
| **A2** — Foundry Local / Windows AI Foundry runtime | `present` | See "Evidence — A2" below (7 articles) | Concepts + How-to |
| **A3** — Open-weight vs proprietary model selection | `partial` | `dem524` (privacy/offline rationale), `brk260` ("Foundry Local to run open-source models locally"), `brksp90` (on-device vs 70B routing) | Analysis |
| **A4** — Hybrid cloud-to-edge inference | `partial` | `brk223`, `brk260`, `od851` (Windows ML across GPU/NPU/CPU, WebNN) | Concepts |
| **A5** — "Microsoft Foundry" terminology currency | `partial` | `02.00-events/202606-build-2026/` articles already use "Microsoft Foundry" in tags; older Build 2025 articles use "Azure AI Foundry" | Reference (maintenance) |

## Evidence — A2 (the substantive overlap)

| Article | What it already covers |
|---|---|
| `02.00-events/202506-build-2025/brk-breakout-sessions/brk223-an-overview-of-windows-ai-foundry/` | Windows AI Foundry end-to-end: local AI development and deployment |
| `02.00-events/202506-build-2025/dem-demonstrations/dem520-local-ai-development-with-foundry-local-and-dotnet-aspire/` | Foundry Local hands-on with .NET Aspire, incl. runnable samples |
| `02.00-events/202506-build-2025/dem-demonstrations/dem524-running-large-language-models-on-your-local-machine/` | Running LLMs locally via Foundry Local; offline/secure-network/edge scenarios |
| `02.00-events/202506-build-2025/brk-breakout-sessions/brk225-bring-your-own-model-to-windows-using-windows-ml/` | Bring-your-own-model on Windows ML, Windows AI Foundry integration |
| `02.00-events/202606-build-2026/05-windows/brk260-build-apps-w-local-ai-for-unmetered-intelligence-on-every-windows-pc/` | Foundry Local for open-source models; Foundry Toolkit optimization; Windows ML across GPU/NPU/CPU |
| `02.00-events/202606-build-2026/05-windows/od851-expand-local-ai-reach-with-windows-ml/` | Expanding local AI reach with Windows ML |
| `02.00-events/202606-build-2026/04-developer-tools-and-frameworks/brksp90-stop-routing-docstrings-to-70b-models-with-on-device-ai-on-snapdragon/` | On-device AI economics — when *not* to route to a large cloud model |

## Reading

The source's **durable** message — "open-weight models let you run capable inference locally, cloud-optionally, on your own hardware" — is **already covered**, and covered more recently (Build 2026, June 2026) than the source itself (August 2025).

The only `absent` slice is **A1**, the gpt-oss model-family datasheet. That is a catalog fact with a short shelf life, not a concept the Hub is missing.
