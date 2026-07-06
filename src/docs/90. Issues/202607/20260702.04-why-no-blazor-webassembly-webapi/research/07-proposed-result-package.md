# Recommended solution architecture

> **Scope note:** this artifact captures the *workflow-design* thread (how the observation-to-integration workflow itself should work). That design is now codified in `.copilot/context/90.00-learning-hub/08-observation-to-integration-workflow.md`. The Blazor subject's per-area conclusions live in `05-analysis/`; the integration record is in `08-approval-and-integration-proposal.md`.

## 🎯 Problem to solve

Create a repeatable workflow that starts from a user observation, infers real interest areas, prioritizes investigation depth, runs selected investigations, and integrates results into LearnHub.

## 🏗️ Recommended architecture

Use a three-layer hybrid model:

1. Deterministic triage layer
2. Agentic investigation layer
3. Integration and governance layer

## ⚙️ Layer design

### 1. Deterministic triage layer

Inputs:

- Observation text
- Current issue context
- Existing local evidence

Outputs:

- Specific question vs broader interest
- Prioritized investigation tracks
- Recommended depth per track
- Expected outcomes per track

Artifacts:

- `01-triage-interest-map.md`
- `02-triage-priority-and-depth.md`
- `03-investigation-backlog.md`
- `04-existing-approaches-contrast.md`

### 2. Agentic investigation layer

Behavior:

- Run selected tracks in order of priority.
- Start with local evidence, then expand externally.
- Maintain fact/assumption/open-question separation.
- Loop with user when decisions or ambiguity appear.

Artifacts:

- `04-user-decisions-log.md`
- `05-research-findings.md`

### 3. Integration and governance layer

Behavior:

- Convert validated findings into LearnHub updates.
- Prefer updating existing content before creating duplicates.
- Keep unresolved items in backlog.

Artifacts:

- `06-integration-plan.md`
- updated issue overview
- optional deep-dive article in `03.00-tech/`

## ✅ Why this is best for your use case

- It explicitly solves interest discovery, not only answer generation.
- It supports mixed-depth research without losing structure.
- It keeps all conversational decisions and evidence in the issue folder.
- It makes final LearnHub integration systematic and auditable.

## 📌 Execution policy

- Triage is mandatory unless user explicitly skips it.
- Only selected tracks move to deep research.
- Every research cycle updates issue-folder artifacts.
- Integration happens only after user validation of direction.

## 📚 References

- [OpenAI - Using tools](https://developers.openai.com/api/docs/guides/tools) 📗 [Verified Community]
- [OpenAI - Working with evals](https://developers.openai.com/api/docs/guides/evals) 📗 [Verified Community]
- [LangChain - Agents](https://docs.langchain.com/oss/python/langchain/agents) 📗 [Verified Community]
- [LangChain - RAG](https://docs.langchain.com/oss/python/langchain/rag) 📗 [Verified Community]
- [Azure Architecture - AI agent design patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns) 📘 [Official]
- [Azure Architecture - RAG design and evaluation guide](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) 📘 [Official]
