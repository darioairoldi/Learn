---
title: "Learning-hub Documentation Taxonomy"
author: "Dario Airoldi"
date: "2026-01-24"
categories: [learnhub, documentation, taxonomy, diataxis, technical-writing]
description: "Comprehensive documentation taxonomy for LearnHub knowledge management, extending Diátaxis with seven content categories optimized for technology intelligence and learning"
---

# Learning-hub Documentation Taxonomy

> A pragmatic documentation framework extending Diátaxis principles for comprehensive technology knowledge management

## Table of contents

- [Introduction](#introduction)
- [Framework foundations](#framework-foundations)
- [The seven content categories](#the-seven-content-categories)
- [Format patterns by content type](#format-patterns-by-content-type)
- [Worked example: Azure Functions](#worked-example-azure-functions)
- [Subject folder template](#subject-folder-template)
- [Validation integration strategy](#validation-integration-strategy)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

The LearnHub Documentation Taxonomy provides a structured approach to organizing technical knowledge for learning, reference, and strategic decision-making. It extends the widely-adopted <mark>**Diátaxis framework**</mark> (a documentation system that organizes content into four types based on user needs: tutorials, how-to guides, reference, and explanation) with additional content categories that address gaps in standard documentation taxonomies.

### Purpose and scope

This taxonomy defines **seven content categories** that together provide comprehensive coverage of any technical subject:

| Category | Purpose | User Question |
|----------|---------|---------------|
| **<mark>Overview</mark>** | First-touch orientation | "What is this? Why should I care?" |
| **<mark>Getting Started</mark>** | First success path | "How do I begin?" |
| **<mark>Concepts</mark>** | Mental model building | "How does this work?" |
| **<mark>How-to</mark>** | Task accomplishment and practice development | "How do I accomplish X effectively?" |
| **<mark>Analysis</mark>** | Strategic evaluation and strategy development | "What approach should we use?" |
| **<mark>Reference</mark>** | Authoritative lookup | "What are the exact specifications?" |
| **<mark>Resources</mark>** | Supporting materials | "Where can I learn more?" |

### Why extend <mark>Diátaxis</mark>?

The Diátaxis framework provides an excellent foundation with its four documentation types (Tutorial, How-to, Reference, Explanation). However, practical knowledge management requires additional structure:

1. **Orientation before learning** — Users need a quick "what is this?" before committing to tutorials
2. **Layered understanding** — Complex subjects benefit from progressive depth (overview → concepts → advanced analysis)
3. **Curated discovery** — Learners need guided paths to external resources, not just internal documentation
4. **Strategic evaluation** — Technology decisions require comparative analysis beyond pure explanation

The LearnHub taxonomy addresses these needs while maintaining compatibility with Diátaxis principles.

## Framework foundations

This taxonomy synthesizes principles from multiple established documentation frameworks. Understanding these foundations helps you apply the taxonomy effectively and adapt it when needed.

### Framework comparison

The table below compares major documentation frameworks and their approaches. For each framework:
- **Content Types** lists the document categories the framework defines
- **Philosophy** describes the core organizing principle or methodology
- **Best For** indicates where the framework excels

| Framework | Content Types | Philosophy | Best For |
|-----------|---------------|------------|----------|
| **Diátaxis** | 4 types (Tutorial, How-to, Reference, Explanation) | User needs along 2 axes (practical/theoretical × study/work) | General docs, open source |
| **<mark>DITA</mark>** (Darwin Information Typing Architecture) | 3 base (Concept, Task, Reference) + specializations | Topic-based authoring, XML, single-sourcing | Enterprise, localization at scale |
| **Microsoft Learn** | 8+ (Overview, Quickstart, Tutorial, Concept, How-to, Reference, Sample, Architecture) | User-centric product documentation | Product docs, learning paths |
| **Good Docs Project** | 10+ templates | Practical templates based on Diátaxis | Open source developer docs |
| **Topic-Based Authoring** | 3 (Conceptual, Procedural, Reference) | Modular, reusable topics | Foundation methodology |
| **Docs as Code** | N/A (workflow) | Git-based, CI/CD, developer collaboration | DevOps integration |

### Mapping LearnHub to standard frameworks

The table below shows how each LearnHub category corresponds to established frameworks. This mapping helps teams familiar with other systems understand where LearnHub content types fit:

| LearnHub Category | Diátaxis | Microsoft Learn | DITA |
|-------------------|----------|-----------------|------|
| **Overview** | ≈ Explanation (intro) | Overview | Concept |
| **Getting Started** | Tutorial | Quickstart + Tutorial | Task |
| **Concepts** | Explanation | Concept | Concept |
| **How-to** | How-to | How-to | Task |
| **Analysis** | — (not addressed) | Architecture (partial) | — |
| **Reference** | Reference | Reference | Reference |
| **Resources** | — (not addressed) | Sample + links | — |

### What makes this taxonomy unique

**1. Splits Diátaxis "Explanation" into three progressive levels:**

```
Overview (orientation) → Concepts (understanding) → Analysis (evaluation)
```

This progression supports different depths of engagement:
- **Overview**: 5-minute read, decide whether to invest further
- **Concepts**: 30-minute study, build working mental model
- **Analysis**: Deep evaluation, support strategic decisions

**2. Adds "Resources" as a first-class content type:**

Most frameworks ignore curated collections. LearnHub explicitly includes:
- Examples and samples galleries
- FAQ compilations
- Migration guides
- External resource curation

**3. Expands "How-to" beyond single tasks:**

Standard How-to guides focus on immediate task accomplishment. LearnHub extends to practice development:
- Task Guides (traditional how-to)
- Patterns & Practices (reusable solutions)
- Techniques (optimization approaches)
- Methodology (complex workflow frameworks)

**4. Expands "Analysis" beyond adoption decisions:**

Rare in standard frameworks but essential for technology intelligence:
- Technology Radar classification (ADOPT/TRIAL/ASSESS/HOLD)
- Comparative analysis
- Strategy development (approach formulation)
- Trend analysis and forecasting

### DITA considerations for future scalability

While this taxonomy uses Markdown and Git-based workflows, the content structure aligns with DITA principles for potential future migration:

- **Topic-based**: Each content type maps to DITA topic types
- **Reusable**: Content can be chunked for single-sourcing
- **Structured**: Consistent patterns enable XML transformation
- **Localizable**: Clear boundaries support translation workflows

If enterprise CCMS or structured translation becomes necessary, the taxonomy provides a migration path.

## The seven content categories

### 1. Overview

**Purpose:** Provide first-touch orientation that answers "What is this? Why should I care?"

**User mode:** Decision-making — Should I invest time learning this?

**Diátaxis mapping:** Entry point to Explanation quadrant

| Attribute | Specification |
|-----------|---------------|
| **Reading time** | 3-5 minutes |
| **Assumed knowledge** | General technical background only |
| **Voice** | Inviting, clear, honest about scope |
| **Outcome** | Reader can decide whether to proceed |

**Required sections:**
- What it is (one-paragraph definition)
- Key benefits (3-5 bullet points)
- Who should use it (target audience)
- When to use it (use cases)
- When NOT to use it (anti-patterns, limitations)
- Prerequisites for learning more

**Anti-patterns to avoid:**
- ❌ Diving into technical details
- ❌ Assuming prior knowledge of the technology
- ❌ Marketing language without substance
- ❌ Omitting limitations or trade-offs

---

### 2. Getting started

**Purpose:** Guide users to their first successful experience with the technology.

**User mode:** Learning by doing — Controlled, successful first steps

**Diátaxis mapping:** Tutorial quadrant

| Attribute | Specification |
|-----------|---------------|
| **Format** | Two tiers: Quickstart (5-min) + Full Tutorial (30-60 min) |
| **Assumed knowledge** | Prerequisites stated explicitly |
| **Voice** | Encouraging, patient, step-by-step |
| **Outcome** | Working result that builds confidence |

**Quickstart characteristics:**
- Complete in 5 minutes or less
- Minimal prerequisites
- Copy-paste ready commands
- Immediate visible result
- Links to full tutorial for depth

**Full tutorial characteristics:**
- Progressive complexity
- Explains "why" at key decision points
- Includes verification steps
- Troubleshooting for common issues
- Clear next steps at conclusion

**Required sections (Full Tutorial):**
- Prerequisites (explicit, verifiable)
- What you'll build/learn
- Step-by-step instructions (numbered)
- Verification ("You should see...")
- Troubleshooting (common issues)
- Next steps

**Anti-patterns to avoid:**
- ❌ Assuming knowledge not in prerequisites
- ❌ Steps that fail silently
- ❌ Missing verification points
- ❌ Overwhelming with options (keep environment controlled)

---

### 3. Concepts

**Purpose:** Build mental models that enable independent problem-solving.

**User mode:** Understanding-oriented — "How does this actually work?"

**Diátaxis mapping:** Explanation quadrant (core)

| Attribute | Specification |
|-----------|---------------|
| **Structure** | Layered: Core → Architecture → Advanced |
| **Assumed knowledge** | Completed Getting Started or equivalent |
| **Voice** | Educational, connects to prior knowledge |
| **Outcome** | Reader understands enough to reason about edge cases |

**Progressive disclosure layers:**

**Layer 1: Core Concepts**
- Fundamental terms and definitions
- Mental models and analogies
- Key principles and constraints
- Relationships between concepts

**Layer 2: Architecture**
- System components and their roles
- Data flow and processing model
- Integration points
- Design patterns employed

**Layer 3: Advanced Topics**
- Edge cases and limitations
- Performance characteristics
- Security considerations
- Customization and extension

**Required sections:**
- Key terms (defined clearly)
- Core principles (3-5 main ideas)
- How it works (conceptual explanation)
- Common misconceptions
- Related concepts (cross-references)

**Anti-patterns to avoid:**
- ❌ Procedural content (belongs in How-to)
- ❌ Exhaustive specifications (belongs in Reference)
- ❌ Opinions without supporting reasoning
- ❌ Assuming reader has read everything else

---

### 4. How-to

**Purpose:** Provide practical guidance for accomplishing goals and developing effective practices.

**User mode:** Task-oriented AND practice-development — "I need to do X" or "What's the best way to do X?"

**Diátaxis mapping:** How-to quadrant (extended)

| Attribute | Specification |
|-----------|---------------|
| **Scope** | From single tasks to reusable methodologies |
| **Assumed knowledge** | User knows what they want to achieve |
| **Voice** | Direct, efficient, goal-focused |
| **Outcome** | Reader can DO something effectively |

**Subcategories:**

The How-to category is divided into four subcategories based on the scope and reusability of the guidance:

| Subcategory | Focus | Title Pattern | Example |
|-------------|-------|---------------|----------|
| **Task Guides** | Accomplish specific goals | "How to [do X]" | "How to configure production settings" |
| **Patterns & Practices** | Reusable solutions to recurring problems | "How to [structure/organize/design X]" | "How to structure prompt files" |
| **Techniques** | Specific approaches for optimal results | "How to [optimize/improve X]" | "How to optimize prompts for specific models" |
| **Methodology** | Frameworks for approaching complex tasks | "How to [orchestrate/approach X]" | "How to orchestrate multiple agents" |

**Subcategory details:**

**Task Guides** (including Troubleshooting)
- Single, specific goal
- Step-by-step instructions
- Verification of success
- Troubleshooting follows "How to fix X" pattern:
  - Symptom description (what the user sees)
  - Diagnosis steps (how to confirm the issue)
  - Solution steps (how to fix it)
  - Prevention (how to avoid recurrence)

**Patterns & Practices**
- Reusable solutions synthesized from experience
- Multiple examples showing the pattern applied
- When to use (and when not to)
- Variations for different contexts

**Techniques**
- Specific approaches for reliability, performance, or efficiency
- Before/after comparisons
- Measurable improvements
- Trade-offs and considerations

**Methodology**
- Frameworks for complex, multi-step work
- Decision points and branching paths
- Coordination between components
- When to adapt the methodology

**Required sections (all subcategories):**
- Goal statement (one sentence)
- Prerequisites
- Core content (steps, patterns, or framework)
- Verification or success criteria
- When to use / When NOT to use

**Anti-patterns to avoid:**
- ❌ Teaching concepts inline (link instead)
- ❌ Vague titles ("Working with authentication")
- ❌ Missing prerequisites
- ❌ No verification of success
- ❌ Patterns without examples
- ❌ Methodology without decision guidance

---

### 5. Analysis

**Purpose:** Provide strategic evaluation, strategy development, and approach comparison for informed decision-making.

**User mode:** Decision-making AND strategic thinking — "What approach should we use?"

**Diátaxis mapping:** Extended Explanation (evaluative and strategic)

| Attribute | Specification |
|-----------|---------------|
| **Scope** | From technology selection to methodology comparison |
| **Assumed knowledge** | Familiarity with technology space |
| **Voice** | Analytical, balanced, explicit about perspective |
| **Outcome** | Reader can DECIDE on approach or strategy |

**Subcategories:**

Analysis content is organized into four subcategories, each addressing a different type of strategic question:

| Subcategory | Focus | User Question | Example |
|-------------|-------|---------------|----------|
| **Technology Radar** | Adoption decisions | "Should we adopt X?" | ADOPT/TRIAL/ASSESS/HOLD classification |
| **Comparative Analysis** | Alternatives evaluation | "How does X compare to Y?" | Framework comparison tables |
| **Strategy Development** | Approach formulation | "What strategy should we use for X?" | Model selection strategy |
| **Trend Analysis** | Future direction assessment | "Where is X heading?" | Ecosystem maturity assessment |

**Subcategory details:**

**Technology Radar**

The <mark>Technology Radar</mark> is a visualization tool (originally created by ThoughtWorks) that classifies technologies into four adoption rings. Each rating indicates how the organization should approach the technology:

| Rating | Definition | Implication |
|--------|------------|-------------|
| **ADOPT** | Proven in production, recommended for new projects | Default choice for relevant use cases |
| **TRIAL** | Worth pursuing, ready for evaluation in real projects | Allocate resources for pilot |
| **ASSESS** | Worth exploring, understand impact | Research and prototyping only |
| **HOLD** | Proceed with caution, consider alternatives | Avoid for new work, plan migration |

**Comparative Analysis**
- Alternatives considered
- Criteria for comparison (explicit, weighted)
- Strengths vs. alternatives
- Weaknesses vs. alternatives
- Decision factors by context
- Recommendation with rationale

**Strategy Development**
- Problem or goal definition
- Options considered
- Evaluation criteria
- Recommended approach with reasoning
- Implementation considerations
- When to revisit the strategy

**Trend Analysis**
- Adoption trajectory
- Ecosystem maturity
- Community health indicators
- Roadmap alignment
- Predicted evolution
- Strategic implications

**Required sections (all subcategories):**
- Context and scope (what decision is being addressed)
- Evidence base (sources supporting analysis)
- Key findings or classification
- Recommendations with rationale
- Review date and validity period

**Anti-patterns to avoid:**
- ❌ Opinions without evidence
- ❌ Outdated analysis without review date
- ❌ Missing alternative perspectives
- ❌ Vendor bias without disclosure
- ❌ Strategy without decision criteria
- ❌ Comparison without clear recommendation

---

### 6. Reference

**Purpose:** Provide authoritative, complete technical specifications.

**User mode:** Information lookup — "What exactly does parameter X do?"

**Diátaxis mapping:** Reference quadrant

| Attribute | Specification |
|-----------|---------------|
| **Structure** | Mirrors the technology's structure |
| **Assumed knowledge** | User knows what they're looking for |
| **Voice** | Austere, formal, precise |
| **Outcome** | User finds exact information needed |

**Reference subtypes:**

The table below describes common reference document formats. Each subtype has a specific structure suited to its content:

| Subtype | Content | Format |
|---------|---------|--------|
| **API Reference** | Endpoints, methods, parameters | Signature + description + example |
| **Configuration Reference** | Settings, options, defaults | Table with name, type, default, description |
| **CLI Reference** | Commands, flags, arguments | Command syntax + options table |
| **Glossary** | Term definitions | Alphabetical, linked |

**Required elements per item:**
- Name/identifier
- Type/syntax
- Description (one sentence)
- Default value (if applicable)
- Constraints/valid values
- Example (minimal, illustrative)

**Anti-patterns to avoid:**
- ❌ Explanatory content (link to Concepts)
- ❌ Procedural content (link to How-to)
- ❌ Incomplete coverage
- ❌ Inconsistent format across items

---

### 7. Resources (optional)

**Purpose:** Curate supporting materials for continued learning and reference.

**User mode:** Self-directed discovery — "Where can I learn more?"

**Diátaxis mapping:** Not addressed in Diátaxis

| Attribute | Specification |
|-----------|---------------|
| **Content** | Curated, not exhaustive |
| **Assumed knowledge** | Varies by resource |
| **Voice** | Helpful guide, brief annotations |
| **Outcome** | User finds appropriate next resource |

**Resource subtypes:**

The table below describes types of supporting materials you might curate for a subject:

| Subtype | Purpose |
|---------|---------|
| **Examples & Samples** | Working code demonstrating patterns |
| **FAQ** | Quick answers to common questions |
| **Migration Guides** | Paths from previous versions or alternatives |
| **Release Notes** | Version history and change documentation |
| **External Resources** | Curated links to official docs, tutorials, communities |

**Required elements:**
- Clear categorization
- Brief description of each resource (1-2 sentences)
- Audience indication (beginner/intermediate/advanced)
- Currency note (when last verified)

**Anti-patterns to avoid:**
- ❌ Dumping links without context
- ❌ Outdated resources without review dates
- ❌ Duplicating content available elsewhere

## Format patterns by content type

### Standard article structure

All content types share a common outer structure:

```markdown
---
title: "Article Title in Sentence Case"
author: "Author Name"
date: "YYYY-MM-DD"
categories: [category1, category2]
description: "One-sentence summary (120-160 characters)"
---

# Article Title

> Brief value proposition or summary

## Table of contents
[Generated based on H2 headings]

## Introduction
[Context, scope, prerequisites]

## [Main content sections]
[Varies by content type]

## Conclusion
[Key takeaways, next steps]

## References
[Classified sources with 📘📗📒📕 markers]

<!-- Validation Metadata
[Validation tracking in HTML comment]
-->
```

### Content-type-specific patterns

The table below shows how each content type should structure its introduction, main sections, and conclusion. Use this as a quick reference when creating new documents:

| Content Type | Introduction Focus | Main Sections | Conclusion Focus |
|--------------|-------------------|---------------|------------------|
| **Overview** | What is this? | Benefits, Use cases, Limitations | Should you proceed? |
| **Getting Started** | What you'll achieve | Prerequisites, Steps, Verification | What's next? |
| **Concepts** | What you'll understand | Principles, How it works, Misconceptions | Related concepts |
| **How-to** | Goal statement | Prerequisites, Steps, Troubleshooting | Verification |
| **Analysis** | Decision context | Radar, Comparison, Strategy, Trends | Recommendation |
| **Reference** | Scope and structure | [Mirrors technology structure] | Related references |
| **Resources** | How to use this list | [Categorized resources] | Contribution guidance |

## Worked example: Azure Functions

The following examples demonstrate each content type using Azure Functions as the subject. These are abbreviated samples showing structure and tone.

### Overview example

```markdown
# Azure Functions overview

> Serverless compute service for event-driven code execution

## What it is

Azure Functions is a serverless compute platform that runs code in response 
to events without requiring infrastructure management. You write functions 
in your preferred language, deploy them, and Azure handles scaling, 
availability, and maintenance.

## Key benefits

- **Pay-per-execution pricing** — No charges when code isn't running
- **Automatic scaling** — Handles load spikes without configuration
- **Language flexibility** — C#, JavaScript, Python, Java, PowerShell
- **Extensive triggers** — HTTP, timers, queues, blobs, and 20+ event sources
- **Local development** — Full debugging support in VS Code

## Who should use it

Azure Functions is ideal for:
- Event-driven processing (queue messages, file uploads)
- Scheduled tasks (data cleanup, report generation)
- API backends (lightweight REST endpoints)
- Workflow orchestration (with Durable Functions)

## When NOT to use it

Consider alternatives when:
- **Long-running processes** (>10 min) — Use Container Apps or AKS
- **Stateful applications** — Use App Service or Kubernetes
- **High-throughput, consistent load** — Reserved capacity may be cheaper
- **Complex dependencies** — Container-based hosting offers more control

## Prerequisites for learning more

- Azure subscription (free tier sufficient for learning)
- Familiarity with at least one supported language
- Basic understanding of HTTP and event-driven architecture
```

### Getting started example (Quickstart)

```markdown
# Quickstart: Create your first Azure Function

> Deploy a working HTTP function in 5 minutes

## Prerequisites

- Azure account ([create free](https://azure.microsoft.com/free/))
- [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local) installed
- VS Code with Azure Functions extension

## Create and deploy

1. **Create function project:**
   ```bash
   func init MyFunctionApp --worker-runtime python
   cd MyFunctionApp
   func new --name HttpTrigger --template "HTTP trigger"
   ```

2. **Test locally:**
   ```bash
   func start
   ```
   Open `http://localhost:7071/api/HttpTrigger?name=World`

3. **Deploy to Azure:**
   ```bash
   az login
   az functionapp create --resource-group myResourceGroup \
     --consumption-plan-location eastus \
     --name myFunctionApp --storage-account mystorageaccount \
     --runtime python
   func azure functionapp publish myFunctionApp
   ```

## Verification

You should see:
```
Functions in myFunctionApp:
    HttpTrigger - [httpTrigger]
        Invoke url: https://myFunctionApp.azurewebsites.net/api/httptrigger
```

## Next steps

- [Full tutorial: Build a complete API](./getting-started-tutorial.md)
- [Concepts: Understanding triggers and bindings](./concepts/triggers-bindings.md)
```

### Concepts example (Core)

```markdown
# Core concepts: Triggers and bindings

> Understand how Azure Functions connects to events and data

## Key terms

| Term | Definition |
|------|------------|
| **Trigger** | Event that causes a function to run (exactly one per function) |
| **Binding** | Declarative connection to data (input or output, zero or more) |
| **Host** | Runtime that manages function execution and scaling |

## Core principles

**1. Functions are event-driven**

Every function has exactly one trigger that defines when it runs. 
The trigger type determines the event source: HTTP requests, queue 
messages, timer schedules, blob uploads, etc.

**2. Bindings eliminate boilerplate**

Instead of writing code to connect to services, you declare bindings 
in configuration. The runtime handles connections, serialization, 
and error handling.

```json
{
  "bindings": [
    { "type": "queueTrigger", "name": "myMessage", "queueName": "input-queue" },
    { "type": "blob", "name": "outputBlob", "path": "output/{rand-guid}.txt", "direction": "out" }
  ]
}
```

**3. Stateless by design**

Functions don't maintain state between invocations. For stateful 
workflows, use Durable Functions extension.

## Common misconceptions

❌ **"Functions are always HTTP endpoints"**  
✅ HTTP is just one trigger type. Functions can respond to queues, 
   timers, database changes, and many other events.

❌ **"Serverless means no servers"**  
✅ Servers exist; you just don't manage them. Azure handles provisioning, 
   patching, and scaling.

## Related concepts

- [Architecture: Hosting plans and scaling](./architecture.md)
- [Reference: Supported triggers and bindings](../reference/triggers-bindings.md)
```

### How-to example: Task Guide

```markdown
# How to configure Azure Functions for production

> Set up monitoring, security, and reliability for production workloads

**Subcategory:** Task Guide

## Goal

Configure an Azure Function app with production-ready settings including 
Application Insights monitoring, managed identity authentication, and 
appropriate scaling limits.

## Prerequisites

- Existing function app deployed to Azure
- Owner or Contributor role on the function app
- Azure CLI installed

## Steps

### 1. Enable Application Insights

```bash
az monitor app-insights component create \
  --app myFunctionApp-insights \
  --location eastus \
  --resource-group myResourceGroup

az functionapp config appsettings set \
  --name myFunctionApp \
  --resource-group myResourceGroup \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=<key-from-above>
```

### 2. Enable managed identity

```bash
az functionapp identity assign \
  --name myFunctionApp \
  --resource-group myResourceGroup
```

### 3. Configure scaling limits

```bash
az functionapp config set \
  --name myFunctionApp \
  --resource-group myResourceGroup \
  --min-tls-version 1.2 \
  --http20-enabled true
```

## Verification

1. Open Azure Portal → Function App → Application Insights
2. Confirm live metrics show incoming requests
3. Check Identity blade shows "System assigned: On"

## Troubleshooting

**Application Insights not showing data:**
- Verify APPINSIGHTS_INSTRUMENTATIONKEY is set correctly
- Wait 2-3 minutes for initial data to appear
- Check function logs for instrumentation errors
```

### How-to example: Patterns & Practices

```markdown
# How to structure Azure Functions projects

> Organize functions, shared code, and configuration for maintainability

**Subcategory:** Patterns & Practices

## Goal

Establish a project structure that scales from simple apps to 
enterprise solutions with multiple function apps and shared libraries.

## When to use this pattern

- Projects with 5+ functions
- Teams with multiple developers
- Solutions requiring shared business logic
- Microservices architectures with multiple function apps

## The pattern

### Recommended folder structure

```
/src
├── FunctionApp.Api/           # HTTP-triggered functions
│   ├── Functions/
│   │   ├── UsersController.cs
│   │   └── OrdersController.cs
│   ├── host.json
│   └── FunctionApp.Api.csproj
├── FunctionApp.Workers/       # Queue/timer-triggered functions
│   ├── Functions/
│   │   ├── OrderProcessor.cs
│   │   └── CleanupJob.cs
│   └── FunctionApp.Workers.csproj
├── Shared.Core/               # Business logic (no Azure dependencies)
│   ├── Services/
│   ├── Models/
│   └── Shared.Core.csproj
└── Shared.Infrastructure/     # Azure-specific implementations
    ├── Repositories/
    └── Shared.Infrastructure.csproj
```

### Key principles

1. **Separate by trigger type** — API functions vs background workers
2. **Extract shared logic** — Business rules in trigger-agnostic libraries
3. **Isolate infrastructure** — Azure SDK dependencies in dedicated project

## When NOT to use

- Simple apps with 1-3 functions (overhead not justified)
- Prototypes and POCs (structure slows iteration)
- Single-developer projects with stable requirements

## Variations

**Monorepo variant:** All function apps share single solution
**Polyrepo variant:** Each function app in separate repository with shared packages

## Related

- [Concepts: Azure Functions architecture](../concepts/architecture.md)
- [How to: Configure for production](./production-config.md)
```

### Reference example

```markdown
# Configuration reference: host.json

> Complete settings reference for Azure Functions host configuration

## Overview

The `host.json` file configures the function host runtime. Settings apply 
to all functions in the app.

## Settings

### extensions

Configures behavior of trigger and binding extensions.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `http.routePrefix` | string | `"api"` | Route prefix for all HTTP functions |
| `http.maxOutstandingRequests` | int | `200` | Maximum concurrent HTTP requests |
| `http.maxConcurrentRequests` | int | `100` | Maximum parallel HTTP requests |
| `queues.batchSize` | int | `16` | Messages retrieved per poll |
| `queues.maxPollingInterval` | duration | `"00:01:00"` | Maximum polling interval |

### logging

Configures logging behavior.

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `logLevel.default` | string | `"Information"` | Default log level |
| `logLevel.Function` | string | `"Information"` | Function execution log level |
| `applicationInsights.samplingSettings.isEnabled` | bool | `true` | Enable telemetry sampling |

## Example

```json
{
  "version": "2.0",
  "extensions": {
    "http": {
      "routePrefix": "api",
      "maxConcurrentRequests": 100
    }
  },
  "logging": {
    "logLevel": {
      "default": "Warning",
      "Function": "Information"
    }
  }
}
```

## Related

- [Concepts: Runtime configuration](../concepts/runtime.md)
- [How to: Configure for production](../howto/production-config.md)
```

### Analysis example: Technology Radar

```markdown
# Analysis: Azure Functions

> Strategic evaluation for serverless adoption decisions

**Subcategory:** Technology Radar

## Technology Radar classification

| Rating | Date | Confidence |
|--------|------|------------|
| **ADOPT** | 2026-01-24 | High |

## Rationale

Azure Functions has matured into a production-ready serverless platform with:
- 5+ years of production usage across enterprises
- Active development with regular feature releases
- Strong ecosystem integration (Azure services, VS Code, GitHub Actions)
- Competitive pricing with consumption-based model

## Comparison to alternatives

| Criteria | Azure Functions | AWS Lambda | Google Cloud Functions |
|----------|----------------|------------|----------------------|
| **Language support** | 7 languages | 7 languages | 4 languages |
| **Max execution time** | 10 min (consumption) | 15 min | 9 min |
| **Cold start** | 1-3s | 0.5-2s | 0.5-2s |
| **Azure integration** | Native | Via connectors | Via connectors |
| **Pricing** | $0.20/million executions | $0.20/million | $0.40/million |

## Recommended contexts

✅ **Use Azure Functions when:**
- Already invested in Azure ecosystem
- Event-driven, short-lived workloads
- Need rapid development with minimal infrastructure

⚠️ **Consider alternatives when:**
- Multi-cloud strategy is required
- Workloads exceed 10-minute execution limit
- Consistent high throughput (reserved capacity may be cheaper)

## Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Vendor lock-in | Use abstraction layers; keep business logic portable |
| Cold start latency | Premium plan with pre-warmed instances |
| Cost unpredictability | Set budget alerts; use Consumption insights |

## Trend analysis

- **Adoption:** Growing steadily in enterprise Azure environments
- **Ecosystem:** Durable Functions extension gaining traction for orchestration
- **Roadmap:** Flex Consumption (preview) addresses cold start concerns
```

### Analysis example: Strategy Development

```markdown
# Analysis: Model selection strategy for prompt engineering

> Develop an approach for choosing AI models across different use cases

**Subcategory:** Strategy Development

## Context

When building AI-powered features, selecting the right model for each 
use case significantly impacts cost, latency, and quality. This strategy 
provides a decision framework.

## Problem definition

No single model is optimal for all tasks. Different models excel at:
- Speed vs. quality trade-offs
- Reasoning depth vs. cost
- Specific domains (code, analysis, creative)

## Options considered

| Option | Approach | Trade-off |
|--------|----------|-----------|
| **Single model** | Use GPT-4o for everything | Simple but suboptimal |
| **Task-based selection** | Match model to task type | Better results, more complexity |
| **Tiered fallback** | Start cheap, escalate if needed | Cost-efficient, adds latency |

## Recommended approach

**Task-based selection with tiered fallback:**

| Task Type | Primary Model | Fallback |
|-----------|---------------|----------|
| Simple queries | GPT-4o-mini | — |
| Code generation | GPT-4o | Claude Sonnet 4 |
| Complex reasoning | o3-mini | o3 |
| Long document analysis | Claude Sonnet 4 | — |

## Decision criteria

1. **Latency requirements** — Sub-second needs eliminate reasoning models
2. **Accuracy requirements** — High-stakes decisions justify o3 costs
3. **Context length** — Documents >100K tokens need Claude or Gemini
4. **Domain specificity** — Some models excel at code, others at analysis

## When to revisit

- New model releases from major providers
- Significant pricing changes
- Observed quality issues in production
- Quarterly review cycle

## Related

- [How to: Optimize prompts for specific models](../howto/model-optimization.md)
- [Reference: Model capabilities comparison](../reference/model-comparison.md)
```

## Subject folder template

When documenting a subject comprehensively, use this folder structure:

```
[Subject Name]/
├── 00-overview.md              # First-touch orientation
├── 01-getting-started/
│   ├── quickstart.md           # 5-minute path
│   └── tutorial.md             # Full learning journey
├── 02-concepts/
│   ├── 01-core-concepts.md     # Fundamental understanding
│   ├── 02-architecture.md      # System design and components
│   └── 03-advanced-topics.md   # Deep dives, edge cases
├── 03-howto/
│   ├── common-task-1.md        # Task-focused guides
│   ├── common-task-2.md
│   └── troubleshooting.md      # Problem-solution pairs
├── 04-analysis/
│   ├── technology-radar.md     # Adoption recommendations
│   ├── comparison.md           # Side-by-side analysis
│   └── strategy.md             # Implementation planning
├── 05-reference/
│   ├── api-reference.md        # API specifications
│   ├── configuration.md        # Settings and options
│   └── glossary.md             # Term definitions
└── 06-resources.md             # Optional: curated links, samples
```

### Naming conventions

- **Folders:** Numbered prefixes (00-, 01-) for ordering
- **Files:** Kebab-case for URL-friendliness
- **Titles:** Sentence case in document headers

### When to use files vs. folders

| Content Volume | Approach |
|----------------|----------|
| Simple subject (< 10 pages) | Single folder with flat files |
| Medium subject (10-30 pages) | Subfolders for concepts, howto, reference |
| Complex subject (30+ pages) | Full template with all subfolders |

## Validation integration strategy

Each content type maps to specific validation dimensions. This section defines the strategy; implementation of prompts and agents follows separately.

### Validation dimensions by content type

The table below maps each content type to its validation priorities. For each content type:
- **Primary Focus** indicates the most critical validation dimension
- **Secondary Focus** lists additional important checks
- **Special Considerations** notes type-specific requirements

| Content Type | Primary Focus | Secondary Focus | Special Considerations |
|--------------|---------------|-----------------|----------------------|
| **Overview** | Clarity, completeness | Readability (Flesch 60-70) | Must answer "why care?" |
| **Getting Started** | Accuracy (steps must work) | Logical flow, gap analysis | Every step must be testable |
| **Concepts** | Logical coherence, completeness | Understandability | Analogies must be accurate |
| **How-to: Task Guides** | Fact accuracy, step completeness | Troubleshooting coverage | Commands must be tested |
| **How-to: Patterns** | Example quality, applicability | When to use / not use | Multiple examples required |
| **How-to: Techniques** | Measurable improvement claims | Trade-off documentation | Before/after evidence |
| **How-to: Methodology** | Completeness, decision guidance | Adaptability notes | Must cover branching paths |
| **Reference** | Exhaustive accuracy, consistency | Format compliance | Must mirror actual system |
| **Resources** | Link validity, currency | Classification accuracy | Review dates required |
| **Analysis: Technology Radar** | Source quality (📘📗 preferred) | Balanced perspective | ADOPT/TRIAL/ASSESS/HOLD required |
| **Analysis: Comparative** | Criteria clarity, fairness | Recommendation strength | Must include alternatives |
| **Analysis: Strategy** | Decision criteria, reasoning | Implementation notes | Revisit triggers required |
| **Analysis: Trends** | Evidence currency, sources | Prediction rationale | Must date predictions |

### Quality thresholds

| Dimension | Minimum Score | Target Score |
|-----------|---------------|--------------|
| Grammar | 90% | 95%+ |
| Readability (Flesch) | 50 | 60-70 |
| Structure | 85% | 95%+ |
| Fact accuracy | 95% | 100% |
| Link validity | 100% | 100% |

### Future implementation needs

| Component | Purpose | Priority |
|-----------|---------|----------|
| Content type detection prompt | Identify document type and subcategory for appropriate validation | High |
| Per-type creation prompts | Guide authors in creating each content type and subcategory | High |
| Per-type validation prompts | Check against type-specific and subcategory requirements | Medium |
| Gap analysis agent | Identify missing content types for a subject | Medium |
| Template generator prompt | Scaffold new subject documentation with subcategory templates | Low |

## Conclusion

The LearnHub Documentation Taxonomy provides a structured approach to comprehensive technology documentation and practice development:

**Key takeaways:**

1. **Seven content categories** serve distinct user needs from orientation to strategic decision-making
2. **Expanded How-to** covers tasks, patterns, techniques, and methodology — supporting both immediate goals and expertise development
3. **Expanded Analysis** covers technology radar, comparative analysis, strategy development, and trend analysis — supporting informed decision-making
4. **Progressive depth** (Overview → Concepts → Analysis) supports different levels of engagement
5. **Compatibility with standards** ensures the taxonomy can evolve with future needs
6. **Consistent patterns** enable validation, automation, and maintainability

**Next steps:**

- Apply the taxonomy to a pilot subject
- Develop content creation prompts for each type and subcategory
- Implement validation prompts aligned with type-specific requirements
- Build gap analysis tooling to identify missing content

## References

### Foundational frameworks

**[Diátaxis - A systematic approach to technical documentation](https://diataxis.fr/)** 📗 [Verified Community]  
Daniele Procida's framework defining four documentation types based on user needs. Primary foundation for this taxonomy's structure.

**[DITA 1.3 Specification](https://docs.oasis-open.org/dita/dita/v1.3/dita-v1.3-part3-all-inclusive.html)** 📘 [Official]  
OASIS standard for structured technical documentation. Relevant for future enterprise scalability and localization requirements.

**[Microsoft Learn Contributor Guide - Content Types](https://learn.microsoft.com/contribute/content-type-overview)** 📘 [Official]  
Microsoft's content type definitions including Overview, Quickstart, Tutorial, Concept, How-to, and Reference patterns.

### Style and quality

**[Microsoft Writing Style Guide](https://learn.microsoft.com/style-guide/)** 📘 [Official]  
Voice, tone, and mechanics guidance. Influences this taxonomy's writing recommendations.

**[Google Developer Documentation Style Guide](https://developers.google.com/style)** 📘 [Official]  
Developer documentation standards with focus on global readability and accessibility.

**[The Good Docs Project](https://thegooddocsproject.dev/)** 📗 [Verified Community]  
Community-driven documentation templates. Practical application of Diátaxis principles.

### Related LearnHub documentation

**[Foundations of Technical Documentation](../../03.00%20tech/40.00%20Technical%20writing/00-foundations-of-technical-documentation.md)** [Internal Reference]  
Comprehensive analysis of documentation frameworks including Diátaxis, Wikipedia, and major style guides.

**[Reference Classification System](../../.copilot/context/90.00-learning-hub/04-reference-classification.md)** [Internal Reference]  
The 📘📗📒📕 source credibility classification used throughout this taxonomy.

**[Validation Criteria](../../.copilot/context/01.00-article-writing/02-validation-criteria.md)** [Internal Reference]  
Quality dimensions and thresholds for documentation validation.

---

<!--
validations:
  grammar:
    status: "not_run"
    last_run: null
  readability:
    status: "not_run"
    last_run: null
  structure:
    status: "not_run"
    last_run: null

article_metadata:
  filename: "01-learnhub-documentation-taxonomy.md"
  content_type: "reference"
  version: "1.0"
  last_updated: "2026-01-24"
  related:
    - "../01-learning-hub-overview/01-learning-hub-introduction.md"
    - "../../03.00-tech/40.00-technical writing/00-foundations-of-technical-documentation.md"
-->
