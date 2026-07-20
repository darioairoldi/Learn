---
title: "Evolve for the validation-manager: live validation dashboards behind a private mirror"
author: "Dario Airoldi"
date: "2026-07-20"
categories: [plan, learn-web, validation-manager, security, dashboards]
description: "Evolution plan to render validation catalog/progress Markdown as live dashboards and to introduce the authenticated, authorized private mirror — making the trust boundary real so autonomous validation of software applications can publish non-public results safely."
draft: true
status: draft
---

# Evolve for the validation-manager: live validation dashboards behind a private mirror

> **Status: draft.** Design + investigation plan. Investigation is complete; the recommended
> approach and phases are **proposals** pending the [§ Open decisions](#-open-decisions). This plan
> covers roadmap capabilities **#6 (validation dashboards)** and **#7 (private mirror)**. Parent:
> [strat-review overview](overview.md).

---

## 🎯 Goal

Evolve the architecture toward **full support for autonomous validation of software applications**:
(a) render **validation catalog / progress Markdown as live dashboards**, and (b) introduce the
**private mirror** — authenticated, authorized rendering of the non-public knowledge tree — so the
"trust boundary" from the platform vision becomes real.

## 🧭 Motivation

A **validation-manager** stream (Layer ②/③) runs checks against a software application and produces
results — a catalog of checks and a progress/status rollup — as Markdown. Those results are usually
**non-public**. The Learning Hub can already render Markdown live, but it (1) renders Markdown as
prose, not as **status dashboards**, and (2) has **no authentication at all** — so it cannot yet host
private validation output. Both gaps must close for autonomous validation to publish safely.

## 🔎 Investigation: dashboards and the trust boundary today (✅ done)

- **The app is fully anonymous.** `Program.cs` registers **no** `AddAuthentication` /
  `AddAuthorization` and uses no `UseAuthentication` / `RequireAuthorization`. Every route and every
  `/_nav`/content endpoint is public. The private mirror is therefore **greenfield**.
- **Visibility is already modeled but not enforced.** The mount design (plan 00.01) defines
  `visibility: public | private`, and the platform vision describes a public/private "curated
  narrative" fit — but with no auth, `private` cannot be honored yet.
- **Rendering is prose-oriented.** Markdig renders Markdown → HTML. A validation **dashboard** (status
  tiles, pass/fail rollups, trend) needs either (a) Markdown authored as tables the renderer styles as
  status, or (b) a light **dashboard view** that reads a structured progress file. No such view exists.
- **Content sources are read-only + credential-shared.** `BlobContentSource` uses one
  `DefaultAzureCredential`; there is no per-viewer authorization path.

## 🧩 Recommended approach (🟡 todo)

### A. Live validation dashboards (capability #6)

- **Structured progress file + dashboard view.** The validation-manager writes a machine-readable
  progress file (e.g. `progress.yml`: check id, status, severity, last-run) alongside human Markdown.
  A **dashboard component** renders that file as status tiles / rollups, with the Markdown catalog as
  the drill-down detail. Keeps content-as-source-of-truth while giving a real dashboard. (🟡 todo)
- **Markdown-native fallback.** Where a full component is overkill, render a conventionally-structured
  status **table** in Markdown with CSS status styling — no code per project. (🟡 todo)

### B. The private mirror (capability #7)

- **Introduce authentication.** Add an identity provider (Entra ID recommended, given the Azure
  footprint) with `AddAuthentication`/`AddAuthorization`; keep public content anonymous, require
  sign-in only for `private` mounts and admin/write endpoints. (🟡 todo — design decision)
- **Enforce mount visibility.** The composite/nav filters `private` mounts out of anonymous
  listings; content + `/_nav` + `/_content` for a private prefix require an authorized session. A
  private tree is **invisible**, not merely un-linked, to anonymous users. (🟡 todo)
- **Authorize the write + invalidate + order endpoints.** The write path (`IContentWriter`), scoped
  invalidation (plan 00.03), and reorder (plan 00.02) all require an authorized principal — the same
  boundary that protects private reading protects mutation. (🟡 todo)
- **One boundary, reused everywhere.** Public reading stays open; private reading, all writes, and all
  invalidation share a single auth model — the trust boundary made real. (🟡 todo)

## 🗺️ Trust-boundary matrix (✅ done)

| Surface | Anonymous | Authorized |
|---|---|---|
| Public mounts / curated content (read) | ✅ allowed | ✅ allowed |
| Private mounts (read + even *listing*) | 🚫 hidden | ✅ allowed (if entitled) |
| Write (`IContentWriter`), reorder | 🚫 denied | ✅ allowed (admin) |
| `POST /_nav/invalidate` | 🚫 denied (key/auth) | ✅ allowed |

## 🪜 Proposed implementation phases (🟡 todo)

1. **Phase 0 — dashboard view (public sample).** Build the progress-file dashboard view against a
   sample validation output on a **public** mount to prove the rendering. (🟡 todo)
2. **Phase 1 — authentication.** Add the identity provider; sign-in flow; an `admin`/`viewer`
   authorization policy. Public content unchanged. (🟡 todo)
3. **Phase 2 — enforce private visibility.** Filter `private` mounts from anonymous nav/content;
   require entitlement to read; hide (not 403-leak) their existence. (🟡 todo)
4. **Phase 3 — protect mutation.** Require auth on write / reorder / invalidate; wire the
   validation-manager stream to publish into a **private** mount. (🟡 todo)

## ❓ Open decisions

- **D1-identity-provider** — **Entra ID** (recommended, matches the Azure/managed-identity footprint)
  or another provider? *Resolves:* user / tenant constraints. *Gates:* Phase 1.
- **D2-authorization-granularity** — is a coarse **`admin` vs `viewer`** model enough for v1, or is
  **per-mount entitlement** (viewer A sees project X only) required? *Resolves:* how many private
  audiences exist. *Gates:* Phase 2 policy.
- **D3-dashboard-surface** — ship the **structured-progress dashboard component** (recommended) or
  start with **Markdown status tables** only? *Resolves:* how rich the first dashboards must be.
  *Gates:* Phase 0 scope.

## 🔭 Discovery

- **DS1-prerender-and-private** — the site prerenders interactive WASM components server-side. *During
  Phase 2* → confirm private content is **not** prerendered into anonymous responses (authorize before
  prerender); if prerender cannot be gated per-component, serve private routes only post-auth.

## 🅿️ Park lot

- **Audit log** of who viewed which private tree. → `defer`
- **Row-level redaction** (public + private content interleaved in one page). → `closed: keep public/private at the tree boundary for v1`
- **External sharing links** (time-boxed tokens to a private page). → `defer`

## 📚 References

- [Platform and consumers](../../../../../06.00-idea/learning-hub/04-platform-and-consumers.md) 📒 [Internal]  
Defines the validation-manager audience and the public/private trust boundary this plan enforces.
- [Mount plan](00.01-learning-hub-improvements-mount-plan.md) 📒 [Internal]  
Defines the `visibility: private` this plan makes enforceable.
- [Invalidation plan](00.03-learning-hub-improvements-invalidation-plan.md) 📒 [Internal]  
The invalidate/write endpoints this plan places behind auth.
- [Strat-review overview](overview.md) 📒 [Internal]  
The capability context (public vs. private mounts).
