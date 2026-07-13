---
title: "How to create a multi-repository documentation site"
author: "Dario Airoldi"
date: "2026-07-01"
categories: [architecture, documentation, deployment, azure]
description: "Analysis of multi-repository documentation hosting patterns, limitations of monolithic SWA deployment, and implementation plans for modular alternatives."
draft: false
---

# How to create a multi-repository documentation site

## Table of contents

- [Introduction](#introduction)
- [Problem statement](#problem-statement)
- [What we observed with Azure Static Web Apps](#what-we-observed-with-azure-static-web-apps)
- [Why monolithic SWA deployment does not fit this use case](#why-monolithic-swa-deployment-does-not-fit-this-use-case)
- [Alternative architecture options](#alternative-architecture-options)
- [Contrast and comparison](#contrast-and-comparison)
- [Cost and manageability evaluation](#cost-and-manageability-evaluation)
- [Recommended implementation plans](#recommended-implementation-plans)
- [Operational controls for reliability](#operational-controls-for-reliability)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

This document analyzes the deployment problem encountered while publishing documentation from multiple repositories into one shared site. The key requirement is modularity: each repository must publish only its own site subtree without overwriting sibling documentation from other repositories.

The recent case confirmed that the previous approach was monolithic in practice and therefore fragile for multi-repository ownership. The team moved to a modular pattern using Azure Web App and merge-based deployment. This paper explains why that works and evaluates additional alternatives that may be even better depending on governance, cost, and operational constraints.

## Problem statement

The target behavior is:

1. Multiple repositories publish into one shared documentation host.
2. Each repository updates only its own path, such as `/diginsight-telemetry/` or `/diginsight-components/`.
3. Root homepage (`/`) acts as a catalog, not a hard redirect to a single site.
4. Deployments are safe under concurrency and do not destroy sibling content.

The anti-pattern is a full-site replacement deployment where repository A can unintentionally erase repository B output.

## What we observed with Azure Static Web Apps

In the previous model, deployments were driven with SWA deployment token semantics and site artifact push behavior. While SWA is excellent for many static site scenarios, the way it was used here behaved as a single deployable unit from the perspective of each publishing workflow.

Capabilities explored:

- SWA token-based deployment for static artifact publication.
- Auth and route handling at the site level.
- Fast publish workflow for one artifact set.

Observed limitation for this case:

- The deployment operation did not provide native path-scoped, sibling-preserving merge semantics across independent repository pipelines. In practical terms, each repo pipeline could become a full-site publisher unless custom preservation logic was added externally.

## Why monolithic SWA deployment does not fit this use case

For a multi-repository documentation estate, monolithic deployment introduces three systemic risks:

1. Ownership coupling: one repository can accidentally impact another repository's published docs.
2. Release coupling: teams must coordinate to avoid collisions and overwrites.
3. Recovery complexity: restoring missing sibling sites requires external snapshots or rebuilds from other repos.

This is not a failure of SWA as a product. It is a mismatch between deployment granularity required by the architecture (path-level modular updates) and deployment granularity used in the pipeline (whole artifact publication).

## Alternative architecture options

### Option A: Azure Web App with modular merge deployment (implemented)

Pattern:

1. Download current `wwwroot`.
2. Replace only current repo path.
3. Regenerate root catalog page from template + registry.
4. Deploy merged package.

Strengths:

- Immediate compatibility with current assets and auth model.
- Explicit sibling preservation checks.
- Inspectable and debuggable via Azure CLI and Kudu APIs.

Risks:

- Merge logic must be maintained in pipeline code.
- Requires careful concurrency control and validation checks.

### Option B: Azure Storage Static Website + CDN/Front Door path routing

Pattern:

- Each repo deploys to isolated blob prefix or isolated storage container.
- Edge routing maps prefixes to origins or paths.
- Root catalog is generated centrally.

Strengths:

- Native static hosting economics and scale.
- Strong separation of repository outputs.
- Simple path-based ownership boundaries.

Important constraints for this case:

- Azure Storage Static Website endpoint is anonymous by design for web delivery and does not provide built-in Microsoft Entra ID (Azure AD) interactive sign-in for documentation viewers.
- To enforce end-user authentication, a separate fronting/interception layer is required.
- That fronting layer is out-of-process and introduces at least one additional network hop in the request path.

Risks:

- Requires edge configuration management (CDN/Front Door rules).
- Auth integration may be more involved than current App Service setup.
- Added auth proxy/interception can increase latency on cache misses and complicate troubleshooting.

### Option C: SWA with centralized aggregator repository

Pattern:

- Individual repos publish artifacts to a package/artifact store.
- A dedicated aggregator repo composes all sub-sites into one final SWA artifact.
- Only aggregator deploys to SWA.

Strengths:

- Keeps SWA hosting benefits.
- Removes direct multi-repo write collisions on production host.

Risks:

- Adds orchestrator pipeline complexity.
- Introduces additional latency and dependency graph for releases.

### Option D: Multi-origin reverse proxy architecture (Front Door or App Gateway)

Pattern:

- Keep each repo/site independently hosted (could be SWA, Web App, Blob static sites).
- Present a unified domain through path routing (`/diginsight-telemetry/*`, `/diginsight-components/*`).

Strengths:

- Maximum team autonomy.
- Independent scaling and release cadence.
- Blast radius is naturally contained per origin.

Risks:

- More infrastructure components.
- Requires consistent shared nav/catalog strategy and cross-origin governance.
- Increased cost and management overhead are common, especially with enterprise gateway features not strictly required for docs hosting.

## Contrast and comparison

| Criterion | Option A Web App modular merge | Option B Storage + CDN | Option C SWA aggregator | Option D Multi-origin proxy |
|---|---|---|---|---|
| Time to production | Fast | Medium | Medium | Medium/High |
| Per-repo isolation | Medium | High | High (at deploy gate) | Very high |
| Operational simplicity | Medium | Medium | Medium/Low | Medium |
| Risk of overwrite | Low (with checks) | Very low | Very low | Very low |
| Cost efficiency | Medium | High | Medium | Medium |
| Debuggability | High | Medium | Medium | Medium |
| Best for current state | Yes | Maybe | Maybe | Maybe |

## Cost and manageability evaluation

### Specific note on Front Door and App Gateway

You are correct that Front Door and App Gateway can add non-trivial platform cost and operational overhead compared with the currently implemented option.

In this use case, those services can improve architectural isolation, but they are not automatically the best answer when the primary objective is efficient and low-cost modular documentation publishing.

### Cost and complexity profile

| Option | Relative platform cost | Operational complexity | Reliability impact | Comments |
|---|---|---|---|---|
| Option A Web App modular merge (implemented) | Low/Medium | Medium | High (with merge checks) | Best immediate value for current setup |
| Option B Storage static website + CDN/Front Door | Medium | Medium/High | High | Good long-term static hosting model, but edge config adds cost and governance |
| Option C SWA aggregator | Medium | Medium/High | Medium/High | Preserves SWA model but increases pipeline orchestration complexity |
| Option D Front Door multi-origin | Medium/High | High | Very high | Strong isolation and routing flexibility, higher ongoing cost |
| Option E App Gateway multi-origin | High | High | Very high | Powerful enterprise gateway features, often over-sized for docs-only workload |

Performance note:

1. Option A keeps auth and content serving in the same hosting tier, avoiding an additional external interception hop for basic protected documentation scenarios.
2. Options B, D, and E can still perform well with caching, but they usually require extra network traversal and additional policy/runtime layers in the critical path.

### Weighted decision matrix

Weights aligned to requested priorities:

- Efficiency: 30%
- Reliability: 30%
- Cost: 25%
- Ease of management: 15%

Scoring scale: 1 (weak) to 5 (strong)

| Option | Efficiency (30%) | Reliability (30%) | Cost (25%) | Ease (15%) | Weighted score |
|---|---:|---:|---:|---:|---:|
| Option A Web App modular merge | 4 | 4 | 4 | 4 | 4.0 |
| Option B Storage + CDN/Front Door | 3 | 4 | 3 | 3 | 3.3 |
| Option C SWA aggregator | 3 | 3 | 3 | 2 | 2.85 |
| Option D Front Door multi-origin | 3 | 5 | 2 | 2 | 3.15 |
| Option E App Gateway multi-origin | 2 | 5 | 1 | 2 | 2.45 |

Interpretation:

1. Option A is currently the best fit overall for your constraints.
2. Option D can be technically stronger for large-scale federated estates, but usually at higher cost and management burden.
3. Option E is generally justified only when broader enterprise gateway/security requirements already exist beyond docs hosting.

### Practical recommendation

Given the stated priorities, the most balanced approach is:

1. Keep Option A as the production baseline now.
2. Evaluate Option D only if the number of repositories and independent origins grows enough to justify edge-routing economics.
3. Avoid Option E for this scope unless App Gateway is already mandated for platform-wide policy reasons.
4. Treat Option B as viable mainly for public docs or cases where externalized auth and extra network hops are acceptable.

## Recommended implementation plans

### Plan 1 (now): Harden Option A

1. Keep current modular merge workflow as default.
2. Add mandatory pre-deploy assertions:
   - sibling paths present before and after merge,
   - root catalog contains all expected registered sites.
3. Add post-deploy verification via Kudu API.
4. Keep local fallback script aligned with workflow logic.
5. Complete OIDC RBAC grant for CI identity.

Success criteria:

- Zero sibling loss across 30+ consecutive deployments.
- Deterministic root catalog generation from `docs/homepage-template.html` and registry.

### Plan 2 (parallel evaluation): Prototype Option C and Option D

1. Build a small proof-of-concept for aggregator SWA pipeline.
2. Build a small proof-of-concept for multi-origin routing.
3. Measure:
   - deployment lead time,
   - operational toil,
   - rollback time,
   - incident blast radius.

Success criteria:

- Objective scorecard with weighted decision matrix.
- Decision proposal for long-term target architecture.

### Plan 3 (strategic): Decide between Option A long-term vs migration

1. If Option A remains best, codify it as organization standard.
2. If another option wins, perform phased migration by repo path.
3. Keep route compatibility and avoid URL breaking changes.

Success criteria:

- No consumer-facing URL regressions.
- Documented runbook and ownership model per repo/path.

## Operational controls for reliability

Use these controls regardless of chosen architecture:

1. Concurrency lock per environment.
2. Sibling preservation guardrails.
3. Artifact manifest per deployment (paths + checksum).
4. Automated smoke test for `/`, `/diginsight-telemetry/`, `/diginsight-components/`.
5. Rollback package retention and one-command restore.
6. Identity separation between user-auth apps and CI workload identities.

## Conclusion

Yes, the point is correct: the previous SWA deployment method functioned as a monolithic site publish model for this use case, which conflicts with modular multi-repository ownership.

The implemented Azure Web App merge deployment solves that mismatch efficiently today and has already demonstrated reliable modular updates with path preservation and template-based root catalog generation.

Additional options exist and may be better in some organizations, especially multi-origin routing and aggregator-based SWA composition. However, under the stated priorities (efficient, reliable, less expensive, easy to manage), and considering authentication plus request-path overhead, the implemented Web App modular merge model is currently the strongest overall fit.

## References

- **[Overview of Azure Static Web Apps](https://learn.microsoft.com/azure/static-web-apps/overview)** 📘 [Official]  
  Product capabilities and deployment model context for static site hosting.

- **[Configure app settings and routes in Azure Static Web Apps](https://learn.microsoft.com/azure/static-web-apps/configuration)** 📘 [Official]  
  Explains SWA route and runtime configuration behavior, important when evaluating path ownership patterns.

- **[Deploy files to Azure App Service by using ZIP deploy](https://learn.microsoft.com/azure/app-service/deploy-zip?tabs=cli)** 📘 [Official]  
  Core mechanism used in the modular merge deployment approach.

- **[Use OpenID Connect with GitHub Actions and Azure](https://learn.microsoft.com/azure/developer/github/connect-from-azure-openid-connect)** 📘 [Official]  
  Identity federation model used for CI deployment authentication.

- **[Azure Front Door documentation](https://learn.microsoft.com/azure/frontdoor/front-door-overview)** 📘 [Official]  
  Relevant for multi-origin path-routing architecture options.

<!--
validations:
  grammar: {status: "not_run", last_run: null}
  readability: {status: "not_run", last_run: null}

article_metadata:
  filename: "01-how-to-create-a-multirepository-documentation-site.md"
-->
