---
title: "Existing Learning Hub coverage map — Frontier performance curve"
publish: false
domain: "learning-hub"
---

# Existing Learning Hub coverage map — Frontier performance curve

> Working artifact for internal grounding before priorities lock. Non-published.

## 🗺️ Coverage map

| Area | Nearest existing content | Coverage | Taxonomy |
|---|---|---|---|
| Model characteristics and static selection | `03-concepts/01.07-understanding-llm-models-and-model-selection.md` | **present** | Concepts |
| Per-task model routing | Prompt YAML guidance, orchestrator guidance, and cost-control slides | **partial** | How-to / Analysis |
| Learned routing, cascades, and threshold-based escalation | No canonical treatment | **absent** | Analysis |
| Product-specific evaluation environments | Evals appear across PE visions and validation guidance, but not as the optimization objective for a model portfolio | **partial** | Concepts / Analysis |
| System-level cost-to-outcome frontier | No canonical treatment | **absent** | Analysis |
| Cost per accepted result | Token optimization exists; outcome-normalized economics doesn't | **partial** | Analysis / Reference |
| Model substitutability and resilience | Model-independence test in the cost-control idea deck and Reverse Information Paradox analysis | **partial** | Analysis |
| Hardware and energy co-optimization | Local inference and quantization appear in the GPT-OSS analysis | **partial** | Analysis |
| Microsoft MAI production evidence | No coverage | **absent** | News / Analysis |

## ✅ Verdict

The Learning Hub covers individual mechanisms but lacks the unifying production model: **optimize the complete AI system against workload-specific outcomes, then route each request to the least expensive path that passes quality and risk gates**. This is a clear, additive gap in the prompt-engineering Analysis band.