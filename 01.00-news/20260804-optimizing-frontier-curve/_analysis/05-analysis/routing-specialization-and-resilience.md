---
title: "Area analysis — Routing, specialization, and resilience"
publish: false
domain: "learning-hub"
---

# Area analysis — Routing, specialization, and resilience

## 🎯 Problem statement

Sending every request to one frontier generalist model wastes capacity, but indiscriminate use of smaller models risks quality and safety. The architecture needs a reliable way to specialize common paths and escalate exceptional work.

## 🔎 Additional considerations

- Static routing assigns task classes; dynamic routing estimates difficulty or confidence per request.
- Specialization needs stable tasks, representative data, trustworthy graders, and sufficient traffic volume.
- Escalation policies need observable failure signals and tested fallback behavior.
- Provider-specific prompt adapters can coexist with model-neutral tool and evaluation contracts.

## 💡 Deductions

1. **The 90/10 split is an example, not a prescription.** Each workload must derive its threshold from its own quality, risk, and cost curves.
2. **Evaluations are the router's contract.** Without task-specific acceptance criteria, routing becomes price-based guesswork.
3. **Substitutability is operational, not declarative.** Teams must replace a model and rerun the same eval suite to prove resilience.
4. **Specialization and routing reinforce each other.** A specialized model creates a cheap common path; routing limits its exposure to cases that fit that path.

## ✅ Conclusions

Use the least expensive model that passes explicit workload gates, retain a stronger fallback, and keep durable capability in model-neutral context, tools, actions, memory, and evaluations. Revalidate thresholds whenever the portfolio changes.

## 📚 Appendix A — Evidence

- Microsoft AI reports MDASH routing up to 90% of tasks to MAI-Cyber-1-Flash and reserving GPT-5.4 for exceptional cases 📘.
- FrugalGPT and RouteLLM independently demonstrate cascades and learned routers 📗.
- The Learning Hub already states a model-independence test, but doesn't connect it to production routing and resilience.

## 🧪 Appendix B — Validation

The analysis separates the supported pattern from Microsoft's exact ratio. No conclusion depends on reproducing Microsoft's unpublished routing data or product metrics.