---
title: "6 VITAL Rules for Production-Ready Copilot Agents"
author: "Mario Fontana"
date: "2026-01-11"
categories: [recording, ai-agents, prompt-engineering]
description: "Professional prompt engineering techniques for deploying AI agents in production environments"
---

# Session Summary: 6 VITAL Rules for Production-Ready Copilot Agents

**Recording Date:** 2026-01-11  
**Summary Date:** 2026-01-11  
**Summarized By:** GitHub Copilot  
**Recording Link:** [YouTube Podcast](https://www.youtube.com/@ioeilmiocopilot)  
**Duration:** ~48 minutes  
**Speaker:** Mario Fontana (Microsoft)  

![Session Title](<images/001.01a session title.png>)

---

## Executive Summary

This masterclass challenges the <mark>misconception that prompt engineering is just "writing well"</mark>.  

Mario Fontana shares <mark>six fundamental rules</mark> for designing production-grade AI agents, emphasizing that creating reliable agent behavior is pure behavioral engineering.  

The session focuses on practical techniques used in real production projects to <mark>control hallucinations</mark> and ensure <mark>agents execute tasks without improvisation</mark>, distinguishing between demo-quality toys and professional production agents.

## Table of Contents

- 🚨 [00:00 - The Uncomfortable Truth About AI Hallucinations](#000---the-uncomfortable-truth-about-ai-hallucinations)
- 📐 [04:56 - The Invisible Line: Chat Prompts vs Agent Prompts](#0456---the-invisible-line-chat-prompts-vs-agent-prompts)
- ⚙️ [11:36 - Rule 1: <mark>Treat System Prompts as Production Software</mark>](#1136---rule-1-treat-system-prompts-as-production-software)
- 🔄 [20:41 - Rule 2: <mark>Beyond "Think Step by Step" - Structured Reasoning</mark>](#2041---rule-2-beyond-think-step-by-step---structured-reasoning)
- ✂️ [27:47 - Rule 3: <mark>Ruthless Reduction - The 10-20% Token Target</mark>](#2747---rule-3-ruthless-reduction---the-10-20-token-target)
- 🤖 [33:27 - Rule 4: <mark>Automate Reviews with Agent Reviewers</mark>](#3327---rule-4-automate-reviews-with-agent-reviewers)
- 🧠 [39:41 - Rule 5: <mark>Separate Behavior from Context</mark>](#3941---rule-5-separate-behavior-from-context)
- 🎯 [44:20 - Rule 6: <mark>Model-Specific Prompt Optimization</mark>](#4420---rule-6-model-specific-prompt-optimization)
- 📋 [47:56 - Recap and Looking Forward](#4756---recap-and-looking-forward)

---

### [00:00] The Uncomfortable Truth About AI Hallucinations

**Key Insight:** <mark>LLMs will always hallucinate</mark> - it's a fundamental mathematical limitation, not a bug to be fixed.

Mario opens with a stark production scenario: an AI agent invents a 40% discount for a new customer contract. The customer has already signed, and there are no error logs - just perfectly constructed, perfectly plausible, perfectly wrong responses.

**Core Problem:**
- <mark>LLMs are optimized for statistical probability of the next word</mark>, <mark>not truth</mark>
- They maximize "truthfulness appearance," not correctness
- When they don't find the answer, they improvise and hallucinate

**Referenced Research:**
- **2024 Paper:** "LLMs Will Always Hallucinate, and We Need to Live With This" ([LLMs Will Always Hallucinate](https://arxiv.org/abs/2409.05746))
- **June 2025 Paper:** "On the Fundamental Impossibility of Hallucination Control" ([On the Fundamental Impossibility of Hallucination Control in Large Language Models](https://arxiv.org/abs/2506.06382))
  - **Impossibility Theorem:** No inference mechanism can be simultaneously truthful, complete, informative, and optimal
  - This is a mathematical limit, not a correctable bug

**The Silver Lining:**
When you have properly designed architecture, <mark>you can reduce hallucination frequency</mark>. <mark>You can't eliminate them</mark>, but you can make them <mark>measurable</mark>, <mark>manageable</mark>, and <mark>engineerable</mark>.

**Production Reality:**
The answer isn't "change models," "add more data," or "hope it goes better." The answer is <mark>treating your system prompt as true application infrastructure</mark>.

---

### [04:56] The Invisible Line: Chat Prompts vs Agent Prompts

**The Critical Distinction:**
Most failures occur because developers don't see the invisible line separating <mark>chat prompts</mark> from <mark>production agent prompts</mark>. Crossing this line changes everything.

**Example of Dangerous Prompt:**
```
Respond based on provided documents.
If the question doesn't concern documents, don't respond.
Be precise. Don't hallucinate.
```

**Why This Fails in Production:**
- Doesn't specify what counts as a source
- Doesn't define what to do when something is missing
- Doesn't specify what's allowed
- Doesn't explain what to do when sources contradict

**Real-World Scenario:**
When asked "What's the maximum discount for a new customer?", the agent:
1. Searches documents
2. Finds "15% renewal discount"
3. Finds nothing about new customer discounts
4. Must choose: say "I don't know" (seems unhelpful) or complete/improvise
5. Generates plausible answer (e.g., 40%) because it sounds truthful

**The Paradigm Shift:**
- **Chat Prompt:** Temporary, single-moment question
- **System Prompt:** Permanent production configuration
- System prompts are <mark>production code written in natural language</mark>.
- Production code <mark>must be tested</mark>, or it will likely explode

**Framework Differences:**
- **Chat Frameworks:** <mark>**CoSTAR**</mark> (great for conversations)
- **Agent Frameworks:** <mark>**RTF**</mark> (Role-Task-Format), guardrail-oriented patterns aligned to how agents process structure

**What Professional System Prompts Must Include:**
1. **<mark>Role & Identity</mark>:** Clear definition of agent capabilities
2. **<mark>Document Scope</mark>:** What sources are considered authoritative
3. **<mark>Response Management</mark>:** How to handle different question types
   - Ambiguous/complex questions
   - Out-of-context questions
   - Partially correlated questions
4. **<mark>Data Gaps</mark>:** How to handle missing information
5. **<mark>Conflict Resolution</mark>:** What to do when sources contradict
6. **<mark>Privacy & Confidentiality</mark>:** Especially for corporate environments
7. **<mark>Quality Control</mark>:** What to do/not do, what to write/not write
8. **<mark>Error Handling</mark>:** Clear boundaries and how to manage them
**<mark>Professional Response Example</mark>:**
> "I haven't found the specific policy for new customers. I found 15% for renewals. For undocumented cases, contact the commercial office."

**Why This Works:**
<mark>The agent doesn't invent or improvise</mark> because it has rules that eliminate the need to improvise.

---

### [11:36] Rule 1: <mark>Treat System Prompts as Production Software</mark>

**Core Principle:** System prompts are not simple text files - they are essential production components of your solution.

**The Promptware Engineering Concept:**
Recent paper formalizes this: [Promptware Engineering: Software Engineering for LLM Prompt Development](https://arxiv.org/abs/2503.02400)
- Prompts are code written as software
- They must be treated with software engineering discipline

**Common Anti-Pattern:**
```
system_prompt_v3_final_REALLY_final_use_this_one.txt
```
This file is a symptom you're managing your agent's brain with Word document logic.

**Version Control Requirements:**
System prompts must live in a repository with:
- **Versions:** Clear version tags (e.g., v1.2.3)
- **Reviews:** Code review process before deployment
- **Traceability:** Answer three critical questions when issues occur:
  1. When did behavior change?
  2. Who changed what?
  3. Which tests were passed?
  4. Why wasn't it caught?

**What to Version Together:**
Everything that defines behavior:
- Agent instructions
- Action references
- Policy on when/what agent can call
- Fallback rules
- Response format
- Starter prompts

**Why Version Together:**
In Copilot Studio, behavior is the interaction of 5 tightly correlated variables:
1. Textual instructions
2. Tools/Actions
3. Data in knowledge base
4. Scope limits
5. Response format

If you change one without the other, you've modified the system without knowing it.

**Testing Strategy:**
Don't test with "I tried three prompts manually." <mark>Use structured test cases</mark>:

**Recommended Test Set (20 cases):**
- **<mark>5 Easy Cases</mark>:** Everything should work perfectly
- **<mark>5 Ambiguous Cases</mark>:** Agent should stop or ask for clarification
- **<mark>5 Out-of-Scope Cases</mark>:** Agent should refuse correctly
- **<mark>5 Plausible Traps</mark>:** Seems right but wrong - test hallucination prevention

**Evaluation Criteria (Behavioral, not accuracy):**
- ✓ Cited sources correctly
- ✓ Used "uncertain" language when data missing
- ✓ Avoided invented numbers
- ✓ Followed imposed format
- ✓ Called tools only when allowed

**Integration with Analytics:**
Track KPIs you can read in Analytics:
- Errors per scenario
- Hallucination rates
- Source citation compliance

**Deployment Patterns:**

**1. Canary Deployment (5-25-100 pattern):**
- Deploy to 5% of users first
- If successful, expand to 25%
- Finally roll out to 100%
- In Copilot Studio: Use Teams channels with specific security groups

**2. Ring Deployment (inside-out expansion):**
- **Ring 0 (Internal):** Development team
- **Ring 1 (Beta):** Test users
- **Ring 2 (Production):** All users
- Native support via Power Platform environments and pipelines

**3. Feature Flags:**
- Turn off new functionality with a click (no redeployment needed)
- Soft rollback capability
- If agent starts hallucinating, change environment variable
- All agents stop using new logic within minutes

**Production Safeguards:**
- Automated test suite runs on every deployment
- CI/CD pipelines with approval gates
- Git with ready rollback (no stress)
- Analytics showing where agents are failing
- Test kit integrated into every pipeline release
- **Control System:** Central dashboard for administrators to see all agents, usage, and policy compliance

**Bottom Line:**
A system prompt modification is a **release**, not a quick edit. Treat it as such.

---

### [20:41] Rule 2: <mark>Beyond "Think Step by Step" - Structured Reasoning</mark>

**The Problem with "Think Step by Step":**
This phrase has become a mantra, appearing everywhere in prompts, articles, tutorials, and social media. But in production, this phrase alone can actually be a problem.

**Why Generic "Think Step by Step" Fails:**

**Example Dangerous Prompt:**
```
Respond to user questions about [topic].
Think step by step before responding.
```

This might help in simple chat scenarios, but it's not a solution or control mechanism for production agents.

**The Real Issue:**
- The point isn't to think **more**
- The point is to think the **right steps**
- If the model doesn't know which steps to take, it produces beautiful reasoning that leads to wrong answers

**Real-World Example:**
**Question:** "Does a part-time employee transferred from Italy to Germany mid-fiscal year have the right to Christmas bonus?"

**What Happens with Generic Prompting:**
The agent produces a generic checklist that seems reasoned, but the answer is likely wrong because:
- This case has many country-specific exceptions
- Mid-year transfers have special rules
- The model has no concrete procedure to follow
- It thought "step by step," but didn't know which steps to take
- It based reasoning on general knowledge, which is insufficient for HR/legal contexts

**The Solution: ReAct Pattern (<mark>Reason + Act</mark>)**

**ReAct = Reason and Act (not just "think better"):**
- **Think:** Analyze what's needed
- **Act:** Consult sources, use tools, retrieve policies
- **Observe:** What did you find?
- **Think:** Reason again based on observations
- **Loop:** Continue until complete

**Why ReAct Works:**
It extends reasoning with environmental interaction, making the model more reliable for tasks requiring external data. This is a true agent pattern.

**Implementation Strategy:**
Don't use ReAct as a phrase to paste. Make it effective through:
1. **Don't give permission to reason generally**
2. **Teach how to reason in specific scenarios**
3. **Provide curated examples with domain precedents**
4. **Give operational checklists for the domain**
5. **Specify the sequence of moves for different scenarios**

**Professional ReAct Example (HR/Legal Domain):**

**Prompt Structure:**
```markdown
Think: Which jurisdictions are involved?
Action: Extract mentioned countries (France, Italy, Germany)
Observation: Identified France and Italy as relevant countries
Think: Check if policy exists for mid-year transfers
Action: Search transfer policy database
Observation: No policy found for mid-year transfers
Final Response: "I haven't found the policy for mid-year transfers. 
I found policies for single-nation scenarios. 
I recommend escalation to HR for this undocumented case."
```

**Key Difference:**
- Doesn't reason generically
- Knows what to do: identify jurisdictions → retrieve policies → signal gaps
- Doesn't invent because it has a procedure that leaves no room for improvisation

**How to Implement:**

**Step 1:** Identify 3-5 most critical/ambiguous scenarios
**Step 2:** For each, write complete example:
- Question type
- Decision checklist
- Tools to use
- Sources to consult
- Final response type

**Step 3:** Put these examples where the model can always see them, so it uses them as operational precedents

**The Real Value:**
Not in the magic phrase, but in:
- The examples you provide
- The steps you teach
- The Think-Act-Observe loop you design

---

### [27:47] Rule 3: <mark>Ruthless Reduction - The 10-20% Token Target</mark>

**The Paradox:**
The more examples you add, the more precise you try to be, the more your system prompt grows. But if it grows too much, it doesn't become more intelligent - it becomes more contradictory.

**What Happens with Contradictory Prompts:**
When a scope is contradictory, the agent doesn't warn you. It decides probabilistically which rule wins each time.

**Common Contradiction Example:**
- **Line 15:** "Respond only on contractual clauses in Legal repository"
- **Line 167:** "For workflow questions, use documents in HR repository"
- **Line 245:** "Never respond on topics outside Legal repository"

**The Question:**
Is scope legal-only, or also HR, or never outside Legal? Who decides? Not you, because you don't see these contradictions. **The model decides.**

**Rule 3 Essence:**
After initial draft, perform reduction. Target: **10-20% shorter without losing critical information**

**Sprint-Style Target:**
Treat each refactor as a sprint goal: reduce 10% tokens without losing clear behaviors

**Benefits of Reduction:**
1. **More Coherence:** Fewer contradictions = fewer hallucinations
2. **More Predictability:** Stable behavior
3. **Lower Costs:** Real token savings

**Reduction Iteration Process:**

**1. Eliminate Redundancies:**
- Same concept repeated in multiple sections → keep one, remove others
- **Example:** Instead of writing "technical documentation repository" 15 times:
  ```markdown
  # Define once at top
  TechRepo = Technical Documentation Repository
  
  # Use everywhere else
  Search TechRepo for...
  ```
- **Result:** 20% fewer tokens, same clarity

**2. Resolve Contradictions:**
- When you find "only X" then "also Y" → choose one unambiguously
- Don't leave the model to decide
- If policy is ambiguous to you, it will be ambiguous to the model
- Clarify before deployment

**3. Optimize Examples:**
- Don't show 5 complete identical examples
- Show the pattern once (Question → Response)
- One fully curated complete example
- Additional variations only if they differ meaningfully (Scenario B, Scenario C)
- **Result:** Same value, half the space, more readable

**4. Remove Filler Words:**
- Cut: "please," "kindly," "if possible," "try to"
- The model doesn't need politeness
- Every useless word is a wasted token
- System prompts need precision, not courtesy
- Put courtesy in the user interface, not the system prompt

**Test After Each Reduction:**
Run key scenarios:
- Behavior unchanged? ✓ OK
- Behavior changed? → Evaluate and adjust

**Real-World Example:**
Legal prompt reduced from **300 lines to 150-180 lines**:
- Zero redundancy
- Zero contradictions
- Same capability
- Much more predictable behavior
- 30% fewer tokens per interaction

**Benefits Summary:**
- Better coherence
- Fewer hallucinations
- Lower costs (shows up in compliance reports)

**Advanced Techniques:**
- **Prompt Compression:** Frameworks like LangChain compression (aggressive)
- Other specialized compression tools
- (Note: Mario offers to create dedicated episode if there's interest)

**Practical Philosophy:**
Precision and iteration, just like code. Every word must earn its place.

---

### [33:27] Rule 4: <mark>Automate Reviews with Agent Reviewers</mark>

**The Problem with Manual Review:**

**Three Structural Problems:**
1. **Time:** System prompts with hundreds of lines require 2-3 hours of true attention
2. **Focus Loss:** You start losing focus, things slip through
3. **Scalability:** Becomes half-day tasks, so you start skipping reviews

**The Danger:**
When you skip review, you're back to the invented 40% discount scenario.

**The Solution: Agent Reviewer**

**Concept:**
Create a dedicated agent with a single purpose: **<mark>criticize and improve your agent instructions</mark>**

This isn't a tool - it's a proper **reviewer agent** that looks at the same things every time without getting tired:
- Redundancies
- Contradictions
- Ambiguous scope
- Missing fallbacks
- Overly generic examples
- Untested edge cases

**Output Structure:**
1. **Structured Analysis:** Itemized list of problems found
2. **Proposed Version:** Improved, more robust version

**Time Comparison:**
- **Human Time:** 1-3 hours
- **Agent Time:** 30 seconds
- **Completeness:** Finds ALL issues its control system can detect, not just some

**This Isn't a Shortcut:**
It's a pattern. You're using a model to improve the output quality.

**The Real Point:**
Not to have AI write everything, but to have:
- **Constant review:** Every time, every prompt
- **Repeatable review:** Same quality checks
- **Scalable review:** Works on every modification, every agent
- **No human dependency:** Doesn't depend on someone's attention span

**Building the Reviewer Agent:**

**Think Like a Professional:**
The reviewer must enforce discipline:
- **What to Check:** Specific criteria
- **How to Classify Errors:** Severity levels
- **Where Errors Found:** Line numbers, sections
- **Production Impact:** What could go wrong
- **Concrete Correction:** Specific fix proposal

**Critical Requirement - Structured Output:**
- Must be testable
- Must be comparable across versions
- Enables batch testing
- Integrates into pipelines
- Can be used in future automated workflows

**Uncertainty Handling:**
If reviewer isn't sure about a problem, it must **explicitly signal** uncertainty

**Where to Run:**
Anywhere convenient - just make the decision to do it. The advantage for future agents will be enormous.

**Recommended Workflow:**

1. **<mark>Write</mark>** system prompt in rough version
2. **<mark>Pass to reviewer</mark>** for analysis
3. **<mark>Review output</mark>** - see what it proposed
4. **<mark>Test</mark>** the recommendations
5. **<mark>Evaluate</mark>** results
6. **<mark>Re-pass to reviewer</mark>** until fully satisfied
7. **<mark>Deploy</mark>** when no critical issues remain

**This is a Quality Gate** - same logic as software quality gates.

**Continuous Improvement:**
When you discover a new type of error in production:
- Add it to <mark>reviewer's control checklist</mark>
- Reviewer evolves with you
- Becomes part of your control platform

**Similar to Copilot Control System:**
Just as Control System is for administrators to monitor agents, the reviewer agent is for developers to control prompt quality.

**Available Resources:**
Microsoft offers prompt coach agents to improve daily requests, or use as template for custom reviewers.

**Connection to Rule 1:**
Remember: **No more** `prompt_reviewer_final_v7_this_time_for_real.txt`
- It's code
- Treat it as such
- Always version controlled

**Rule 4 Summary:**
Automate review in 30 seconds, get a report, stop going by instinct.

---

### [39:41] Rule 5: <mark>Separate Behavior from Context</mark>

**The Core Problem:**
Even if your prompt is perfect, <mark>your agent can still hallucinate for a much more banal reason: **context**</mark>

Many system prompts fail not because of how they reason, but because of how they're **conditioned by their context**.

**The Mistake:**
If you put things in the system prompt that the architecture can already provide, you're paying twice:
- Once in complexity
- Once in fragility

**What Changed: <mark>Microsoft Graph Intelligence Layer</mark>**

**Announced:** November 2025 at Ignite

This isn't a feature - it's an **architectural layer** between Graph and agents.  
It fundamentally changes:
- What you should put in agent instructions
- **Especially what you should NOT put there**

**Before Intelligence Layer:**
<mark>Many projects hardcoded organizational context in system prompts</mark>:
- Procedures
- Who approves what
- Who owns what
- Team structures

**Why This Seemed Useful:**
It provides context... until it changes.

**The Danger:**
<mark>When a person changes roles, or a team reorganizes, an outdated prompt becomes a **potential hazard**</mark>:
- Generates plausible responses
- But based on outdated information
- No error thrown - just wrong guidance

**The More Context You Hardcode:**
- More risk of contradictions
- Harder to maintain coherence across versions
- Brittleness increases

**Intelligence Layer Architecture:**

**Three Components:**

1. **Data (Microsoft Graph):**
   - Relationships
   - Meetings, chats, work connections
   - How work is actually connected

2. **Memory:**
   - Preferences
   - Habits
   - User-specific customization ("how you want it")

3. **Knowledge:**
   - Organizational structure
   - Actual interaction patterns
   - How the organization really works

**Key Feature: Permission-Aware:**
- Security stays under control
- Traceable at every step
- Provides signals to the model
- Model decides how to use them based on the prompt

**The New Separation:**

**In System Prompt (Behavior):**
- What the agent does
- How it reasons
- How it responds when something is missing

**From Intelligence Layer (Context):**
- Who the user is
- What they're working on
- Relevant organizational relationships
- Available resources

**Example: Legal Agent**

**Before (Brittle Approach):**
```markdown
If user is in Legal Team → Business tone
If user works on Project X → Prioritize documents Y
...
```

**Problem:** You're transforming the system prompt into a mini corporate directory that becomes outdated.

**After (Rule 5 Approach):**
```markdown
Adapt tone based on user's ACTUAL role
Prioritize sources relevant to user's CURRENT work
If role not available OR no relevant sources:
  [Define fallback behavior]
```

**Write the Rule, Not the List:**
- <mark>Don't repeat organizational context that can be provided dynamically</mark>
- <mark>Define behavior for missing context</mark>
- <mark>Agent must know what to do when it "doesn't know"</mark>

**Benefits:**
- Simpler system prompt
- Separates behavior from context
- More maintainable
- Self-documenting limitations

**Critical Principle:**
Every time you manually write context into the system prompt, you're **building fragility** into your system.

---

### [44:20] Rule 6: <mark>Model-Specific Prompt Optimization</mark>

**The Uncomfortable Reality:**
A "good generic prompt" doesn't exist. There exists a **good prompt for that specific model**.

**Why This Matters:**
The prompt that works perfectly on Model A won't necessarily work the same on Model B. What works today can change tomorrow when you update the model version.

**What Changes Between Model Versions:**
- Sensitivity to certain <mark>constraints</mark>
- How <mark>ambiguity</mark> is handled
- Response patterns
- Token interpretation

**Common Developer Reaction:**
"Wait, I didn't change anything. How is this possible?"

**The Analogy:**
It's like changing your compiler and expecting identical behavior.

**The Rule (Simple but Often Ignored):**

**Every time you change model or version:**
1. **<mark>Read the official prompt guide</mark>** for that specific model
2. **<mark>Connect model change to test pipeline</mark>** updated with latest official guide

**Why Official Documentation:**
Don't read an article that summarizes characteristics.  
<mark>Read the **official guide**</mark> because it contains:
- <mark>What the model follows</mark> reliably
- What <mark>changed from previous version</mark>
- <mark>Model-specific behavior patterns</mark>
- <mark>Recommended prompt structures</mark>

**Without This Step:**
You're making luck-based changes, not engineering-based changes.

**Practical Implementation:**

**Option 1: <mark>Use Copilot Chat</mark>**
Open Copilot chat and ask:
> "How do I optimize this prompt for the new version?"

**Option 2: <mark>Update Agent Reviewer</mark>**
Better yet, update your agent prompt reviewer with model-specific knowledge.

**Option 3: <mark>Model-Specific Reviewers</mark>**
Create dedicated agent prompt reviewers for each model you use regularly.

**Multi-Model Architecture in Copilot Studio**

**Historical Context:**
- **Before:** One agent = one model
- **September 2025:** Microsoft announced multi-model selection
- **May 2025:** "Bring Your Own Model" - connect models supported by Studio

**Current State (January 2026):**
- Catalog offers **11,000+ models**
- Can only use chat-completion compatible models
- **Critical Capability:** Each agent action can use a different model

**Strategic Implication:**
You're no longer forced to choose "the best model." You can choose **which model for which task**.

**Example Multi-Model Agent:**

**Architecture:**
- **Main Agent Instruction:** Uses Model A (e.g., GPT-4o)
- **Long Document Analysis Action:** Uses Model B (e.g., Claude with 200K context)
- **Complex Reasoning Task:** Uses Model C (e.g., o1-preview)

**Result:**
Everything works perfectly... until you realize each model needs model-specific prompt optimization.

**Anthropic Integration:**
Microsoft announced Anthropic Claude models joining Copilot Studio lineup, expanding model selection options.

---

### [47:56] Recap and Looking Forward

**What We Covered Today - The First Six Rules:**

These build the foundation - prompt engineering as architecture, not text; prompt engineering as mindset:

1. **Rule 1:** Treat system prompts as production software
   - Version control, reviews, structured testing
   
2. **Rule 2:** Move beyond "think step by step" to structured reasoning
   - Real examples, domain-specific checklists, ReAct patterns

3. **Rule 3:** Ruthlessly reduce prompt length
   - Target 10-20% reduction to eliminate contradictions
   
4. **Rule 4:** Automate reviews with dedicated agent reviewers
   - 30-second reviews, consistent quality checks

5. **Rule 5:** Separate behavior from context
   - Use intelligence layer for dynamic context
   
6. **Rule 6:** Optimize prompts for specific models
   - Model-specific guidance, test pipeline integration

**But This Is Only the Beginning:**

Even if you implement all six rules perfectly, the invented 40% discount can still happen. Why? **Because this was only the first point of failure.**

**The Second Point of Failure (More Subtle and Dangerous):**
It doesn't concern what the agent thinks - it concerns **where the agent gets its truth**.

**Coming in Episode 2 - Six Advanced Rules:**

Topics include:
- **Explicit Grounding:** Forcing agents to cite sources correctly
- **Guardrail Testing:** The right way to test boundaries
- **Production Monitoring:** Real-time hallucination detection
- How to minimize risks through engineering, not magic

**The Series:**
- **Episode 1:** 6 Vital Rules [This session]
- **Episode 2:** 6 Advanced Rules [Coming soon]
- **Future episodes** based on community interest

**Core Message:**
You'll never eliminate hallucinations, but you can **engineer reliability** by:
- Finding problems before production
- Making issues measurable and manageable
- Building systems, not hoping for magic

---

## Key Takeaways

1. **Hallucinations Are Fundamental:** Mathematical impossibility theorem proves LLMs will always hallucinate - architect around this reality

2. **Chat ≠ Production:** The critical distinction between temporary chat prompts and permanent production system prompts

3. **Prompts Are Code:** Version control, testing, and deployment discipline are mandatory, not optional

4. **Structure Over Magic Phrases:** "Think step by step" alone is dangerous - use structured ReAct patterns with domain examples

5. **Less Is More:** Target 10-20% token reduction to eliminate contradictions and improve coherence

6. **Automate Quality:** Agent reviewers provide consistent 30-second reviews vs. 2-3 hour manual processes

7. **Context Separation:** Don't hardcode organizational context that changes - use intelligence layer dynamically

8. **Model Specificity:** Each model needs its own prompt optimization - no universal prompts exist

9. **Multi-Model Strategy:** Different tasks can use different models - optimize each action appropriately

10. **Engineering Mindset:** This is behavioral engineering, not creative writing - discipline and testing are essential

---

## Resources

**Research Papers:**
- [LLMs Will Always Hallucinate, and We Need to Live With This](https://arxiv.org/abs/2409.05746) (2024)
- [On the Fundamental Impossibility of Hallucination Control in Large Language Models](https://arxiv.org/abs/2506.06382) (June 2025)
- [Promptware Engineering: Software Engineering for LLM Prompt Development](https://arxiv.org/abs/2503.02400)

**Microsoft Documentation:**
- [Copilot Studio: Testing, deployment, and launch](https://learn.microsoft.com/en-us/microsoft-365/copilot/)
- [Anthropic joins the multi-model lineup in Microsoft Copilot Studio](https://www.microsoft.com/en-us/microsoft-365/blog/)

**Follow Mario Fontana:**
- Newsletter: [LinkedIn Newsletter](https://www.linkedin.com/newsletters/)
- LinkedIn: [linkedin.com/in/fontanamario](https://www.linkedin.com/in/fontanamario/)
- Podcast YouTube: [@ioeilmiocopilot](https://www.youtube.com/@ioeilmiocopilot)
- X (Twitter): [@mariofontana](https://x.com/mariofontana)
- Bluesky: [fontanamario.bsky.social](https://bsky.app/profile/fontanamario.bsky.social)

---

**Next Episode:** Six Advanced Rules covering explicit grounding, guardrail testing, and production monitoring strategies.
