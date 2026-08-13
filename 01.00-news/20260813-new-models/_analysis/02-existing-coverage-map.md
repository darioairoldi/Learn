---
title: "Existing coverage map — MAI-Thinking-1 impact"
description: "Current LearnHub coverage status before prioritization"
domain: "learning-hub"
publish: false
---

# Existing coverage map — MAI-Thinking-1 impact

## 🗺️ Coverage matrix

| Area | Coverage | Evidence | Taxonomy fit |
|---|---|---|---|
| Model families and standard vs reasoning distinction | Present | 03.00-tech/05.02-prompt-engineering/03-concepts/01.07-understanding-llm-models-and-model-selection.md | Concepts |
| Model-specific prompting patterns (GPT/Claude/Gemini/reasoning) | Present | 03.00-tech/05.02-prompt-engineering/04-howto/08.00-how-to-optimize-prompts-for-specific-models.md | How-to |
| Cost-to-outcome system optimization (routing, evals, resilience) | Present | 03.00-tech/05.02-prompt-engineering/05-analysis/23-optimizing-ai-systems-on-the-cost-to-outcome-frontier.md | Analysis |
| Context-file guidance for model-specific optimization | Present | .copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md | Context governance |
| Foundry MAI-Thinking-1 API-specific reasoning state handling | Absent | No MAI-specific operational guidance found in PE docs/context | How-to + context amendment |
| Foundry preview constraints and quota caveats in PE guidance | Partial | Generic model deprecation/availability guidance exists, but no MAI preview constraints | Concepts + context amendment |
| Foundry-native evaluation/observability hooks tied to model selection loops | Partial | Frontier analysis covers evaluation conceptually, not Foundry operational workflow details | Analysis + context amendment |

## 🧭 Coverage verdict

- Core prompt-engineering foundations are strong and current.
- The main gap is not generic model strategy; it is Foundry-specific reasoning-model operations and governance caveats.
- This impact touches existing canonical PE artifacts, so changes are meta/architecture amendments, not a stand-alone additive article only.

## 📚 References

- 03.00-tech/05.02-prompt-engineering/03-concepts/01.07-understanding-llm-models-and-model-selection.md
- 03.00-tech/05.02-prompt-engineering/04-howto/08.00-how-to-optimize-prompts-for-specific-models.md
- 03.00-tech/05.02-prompt-engineering/05-analysis/23-optimizing-ai-systems-on-the-cost-to-outcome-frontier.md
- .copilot/context/00.00-prompt-engineering/03.02-model-specific-optimization.md

<!--
context_metadata:
  version: "1.0.0"
  last_updated: "2026-08-13"
-->
