---
title: "Plan — Publish Quarto Site to Azure Web App"
status: actionable
domain: "learning-hub"
goal: "Publish the Quarto-rendered static site to Azure Web App learn-testmc-app-itn-01 via a secretless OIDC GitHub Actions workflow, running alongside the existing gh-pages deployment"
---

# Plan — Publish Quarto Site to Azure Web App

## 🎯 Objective

Stand up a repeatable, secretless deployment that renders the Quarto site and
publishes the static `docs/` output to the **Windows** Azure App Service
`learn-testmc-app-itn-01`, without disturbing the existing GitHub Pages
deployment.

- **Target Web App:** `learn-testmc-app-itn-01` (does not exist yet — must be provisioned)
- **Resource group:** `learn-testmc-rg-itn-01` (exists, region `italynorth`)
- **Subscription:** `5ebe191f-c334-4a27-acd4-17f9594aa05a`
- **Auth:** OIDC federated credential (no secrets/publish profile stored)
- **Runner:** `ubuntu-latest`
- **Relationship to gh-pages:** additive — both deployments coexist

> **Discovery (2026-06-24):** The resource group exists in `italynorth`, but neither
> the Web App nor an App Service plan exist. A provisioning phase (Phase 2) was
> added; subsequent phases were renumbered.

## 🧭 Motivation

The site currently deploys only to GitHub Pages. A parallel Azure App Service
target is needed for testing/hosting under a custom Azure URL. OIDC removes the
risk of long-lived publish profiles or client secrets living in GitHub.

## 📋 Decisions (informational)

| Decision | Choice | Reason |
|---|---|---|
| Authentication | OIDC federated credential | Secretless; Microsoft-recommended |
| Runner | `ubuntu-latest` | Simplest for Azure deploy |
| App Service OS | Windows | Serves static HTML natively via IIS — no startup command |
| Existing gh-pages | Keep | New workflow is additive |
| Role scope | `Website Contributor` on the Web App | Least privilege |
| OIDC subject | `repo:darioairoldi/Learn:ref:refs/heads/main` | Branch-based trust |
| App Service plan SKU | `F1` (Free) | Zero cost; sufficient for a static test site |
| Region | `italynorth` | Matches the existing resource group |

---

## ⚙️ Actions

### Phase 1 — Repository artifacts (✅ done)

- Create deploy workflow [.github/workflows/azure-webapp-deploy.yml](../../../../.github/workflows/azure-webapp-deploy.yml) — renders Quarto, copies `web.config`, logs in via OIDC, deploys `docs/`. (✅ done)
- Create IIS [deploy/azure/web.config](../../../../deploy/azure/web.config) — default document, MIME types, Quarto `404.html`. (✅ done)
- Confirm `navigation.json` reaches `docs/` automatically via `quarto render` (root-level non-source file is copied by Quarto). (✅ done — verified during analysis)

### Phase 2 — Provision Windows App Service (✅ done)

The Web App and its App Service plan did not exist; both created in
`italynorth` on the Free `F1` SKU.

- Set active subscription. (✅ done)
  ```bash
  az account set --subscription 5ebe191f-c334-4a27-acd4-17f9594aa05a
  ```
- Create a **Windows** App Service plan. (✅ done — `learn-testmc-plan-itn-01`, F1, Ready)
  ```bash
  az appservice plan create \
    --name learn-testmc-plan-itn-01 \
    --resource-group learn-testmc-rg-itn-01 \
    --location italynorth \
    --sku F1
  ```
- Create the Web App on that plan. (✅ done — Running)
  ```bash
  az webapp create \
    --name learn-testmc-app-itn-01 \
    --resource-group learn-testmc-rg-itn-01 \
    --plan learn-testmc-plan-itn-01
  ```
- Confirm the app resolves at `https://learn-testmc-app-itn-01.azurewebsites.net`. (✅ done)

### Phase 3 — Azure identity & permissions (✅ done)

Created in tenant `b92a0fb8-931a-44be-85ba-09c887a3ad01`.

| Object | Value |
|---|---|
| App registration `appId` (AZURE_CLIENT_ID) | `05c0d91c-6de7-448b-963e-4375f603bf5c` |
| Service principal objectId | `fb07dac4-a2c7-431b-8c42-576764be6f8a` |
| Tenant (AZURE_TENANT_ID) | `b92a0fb8-931a-44be-85ba-09c887a3ad01` |
| Federated subject | `repo:darioairoldi/Learn:ref:refs/heads/main` |
| Role | `Website Contributor` scoped to the Web App |

- Create app registration + service principal. (✅ done — `github-learn-deploy`)
- Add federated credential bound to `darioairoldi/Learn` branch `main`. (✅ done)
- Assign `Website Contributor` scoped to the Web App resource only. (✅ done)

### Phase 4 — GitHub configuration (✅ done)

Set as repo owner `darioairoldi` (after `gh auth login`). These three values are
non-sensitive identifiers (no client secret exists — OIDC):

- Add `AZURE_CLIENT_ID` = `05c0d91c-6de7-448b-963e-4375f603bf5c`. (✅ done)
- Add `AZURE_TENANT_ID` = `b92a0fb8-931a-44be-85ba-09c887a3ad01`. (✅ done)
- Add `AZURE_SUBSCRIPTION_ID` = `5ebe191f-c334-4a27-acd4-17f9594aa05a`. (✅ done)

Commands used (run as repo admin):
```bash
gh secret set AZURE_CLIENT_ID       --repo darioairoldi/Learn --body 05c0d91c-6de7-448b-963e-4375f603bf5c
gh secret set AZURE_TENANT_ID       --repo darioairoldi/Learn --body b92a0fb8-931a-44be-85ba-09c887a3ad01
gh secret set AZURE_SUBSCRIPTION_ID --repo darioairoldi/Learn --body 5ebe191f-c334-4a27-acd4-17f9594aa05a
```

### Phase 5 — First deploy & verification (🟡 todo)

- Commit and push Phase 1 artifacts to `main` (or trigger **Run workflow** manually). (🟡 todo)
- Confirm the **Deploy Quarto Site to Azure Web App** run succeeds (login → render → deploy). (🟡 todo)
- Verify the site loads at `https://learn-testmc-app-itn-01.azurewebsites.net`. (🟡 todo)
- Verify `https://learn-testmc-app-itn-01.azurewebsites.net/navigation.json` returns JSON and the Related Pages widget loads. (🟡 todo)
- Verify a non-existent path returns Quarto's `404.html`. (🟡 todo)
- Confirm the existing gh-pages deployment is unaffected. (🟡 todo)

### Phase 6 — Optional hardening (📌 next steps)

- Switch to a GitHub **Environment** (`production`) with manual approval; update OIDC subject to `repo:darioairoldi/Learn:environment:production` and add `environment:` to the job. (📌 next steps)
- Configure a custom domain + managed certificate on the Web App. (📌 next steps)
- Add a deployment slot (`staging`) and swap-on-success. (📌 next steps)

---

## ✅ Exit Criteria

- The workflow renders and deploys `docs/` to the Web App on push to `main`. (🟡 todo)
- The Azure-hosted site loads correctly, including `navigation.json` and `404.html`. (🟡 todo)
- No secrets/publish profiles are stored in GitHub (OIDC only). (🟡 todo)
- The gh-pages deployment continues to function. (🟡 todo)

## 🅿️ Park lot

- Linux App Service hosting variant (would require a static-file server/startup command) → defer
- Caching/CDN (Azure Front Door) in front of the Web App → defer
- Automated link-check gate before deploy → → 02-deploy-quality-gate-plan.md

## 🔎 Actionability Gate

- **Clarity** — every step is a concrete command or UI action with a verifiable result. ✅
- **Non-ambiguity** — each step has one interpretation. ✅
- **Scope discipline** — expansions routed to § Park lot. ✅
- **Coverage promise** — Phase 1 → repo files; Phase 2–4 → external Azure/GitHub state with verification; Phase 5 → deferred. ✅

## 📚 References

- [.github/workflows/azure-webapp-deploy.yml](../../../../.github/workflows/azure-webapp-deploy.yml) — the deploy workflow
- [deploy/azure/web.config](../../../../deploy/azure/web.config) — IIS static hosting config
- [.github/workflows/quarto-publish.direct.yml](../../../../.github/workflows/quarto-publish.direct.yml) — existing gh-pages deployment
