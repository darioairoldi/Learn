# Learning Hub deploy to Azure App Service fails (OneDeploy 500) — root cause and deployment-strategy analysis

**Date Reported:** 2026-07-14
**Reporter:** Dario Airoldi
**Status:** 🟡 In Progress — immediate cause fixed; deployment-strategy decision open
**Severity:** High (deployments to the public site were blocked)
**Component:** Learning Hub deploy pipeline · Azure App Service (Windows / IIS) · GitHub Actions
**Framework:** Quarto 1.6.42 · `azure/webapps-deploy@v3` (OneDeploy) · self-hosted Windows runner

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Implemented](#-solution-implemented)
- [🧭 Deployment-Strategy Investigation](#-deployment-strategy-investigation)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

The `Deploy Quarto Site to Azure Web App` workflow renders the Quarto site and pushes `docs/`
to the Windows App Service `learn-testmc-app-itn-01` via `azure/webapps-deploy@v3` (OneDeploy).
The deploy step failed:

```text
Package deployment using OneDeploy initiated.
Error: Failed to deploy web package to App Service.
Error: Deployment Failed, Error: Failed to deploy web package using OneDeploy to App Service.
Internal Server Error (CODE: 500)
```

The Node deprecation warnings in the same log (`punycode`, `Buffer()`, `url.parse`) are **noise from
the deploy action** ([Azure/webapps-deploy#545](https://github.com/Azure/webapps-deploy/issues/545)),
not the cause.

**Impact:** new content could not be published to the site; every deploy attempt returned a
server-side 500 during package upload/extraction.

---

## 🔍 Context Information

| Property | Value |
|----------|-------|
| **Workflow** | `.github/workflows/azure-webapp-deploy.yml` |
| **Runner** | self-hosted Windows |
| **Deploy method** | OneDeploy (`azure/webapps-deploy@v3`), package = `docs/` |
| **App Service** | `learn-testmc-app-itn-01` (Windows, IIS static hosting) |
| **Rendered output** | 590.7 MB across ~950 files |

**Package composition (before fix):**

| Type | Size | Files | Note |
|------|------|-------|------|
| `.jpg` | 306.5 MB | 71 | Travel photos, 6–8 MB each (camera originals) |
| `.html` | 240.2 MB | 472 | ~0.5 MB/page — see sidebar finding |
| `.png` | 28.5 MB | 313 | Screenshots |
| `search.json` | 13.1 MB | 1 | Quarto search index |

---

## 🔬 Analysis

### Primary root cause — oversized deploy package (already-compressed JPEGs)

OneDeploy uploads a **zip**. JPEGs are already compressed, so the 306 MB of photos did **not** shrink
in the zip — the upload payload stayed enormous (~380 MB). A package that large overwhelms the
SCM/Kudu OneDeploy extraction path (storage/time budget), producing the server-side **500**.

### Secondary finding — duplicated sidebar HTML

A trivial 485 KB content page was measured as **86% sidebar**: Quarto inlines the **entire 810-entry
site navigation into every one of the 472 pages** (~190 MB of duplicated markup). This bloats the
extracted footprint (not the zip upload, since HTML compresses ~90%). It is **not** the deploy
blocker but is a real size/performance liability and constrains size-limited hosts (e.g. SWA).

### Impact assessment

| Dimension | Assessment |
|-----------|------------|
| Deploy availability | 🔴 Blocked (500 on every run) |
| Serving (once deployed) | 🟢 Unaffected |
| End-user page weight | 🟠 Poor — visitors downloaded 6–8 MB photos + heavy HTML |

---

## 🔄 Reproduction Steps

1. Render the site (`quarto render`) → ~590 MB `docs/`.
2. Run `azure-webapp-deploy.yml` (OneDeploy, package = `docs/`).
3. Deploy step returns `Internal Server Error (CODE: 500)`.

**Affected files:**

| File | Role |
|------|------|
| `.github/workflows/azure-webapp-deploy.yml` | Render + OneDeploy pipeline |
| `90.00-travel/paris-2025/images/*.jpg` | Full-resolution source photos |
| `_quarto.yml` | Sidebar config driving the 810-entry nav |

---

## ✅ Solution Implemented

### Build-time image compression (immediate fix)

Added `scripts/compress-images.ps1` (System.Drawing under Windows PowerShell 5.1; applies EXIF
orientation; downsizes to 2000px longest side at JPEG q82; skips small images; never enlarges the
file) and wired a **Compress images in output** step into the workflow between render and deploy.
It compresses the disposable `docs/` copies only — full-resolution originals in source are untouched.

**Measured result on the real output:**

| Metric | Before | After |
|--------|--------|-------|
| JPEGs | 305.9 MB | 23.7 MB |
| Total `docs/` | 590.7 MB | 308.5 MB |
| Est. zip upload | ~380 MB | ~65 MB |

The ~6× smaller upload removes the condition that triggered the OneDeploy 500.

### Planned refinement — source-stored compressed variants

Rather than recompressing the throwaway `docs/` on every build, move to a **compress-by-default,
source-stored** convention so compressed images are committed and referenced directly:

- `foo.jpg` — full-res original (git source of truth; not referenced/published)
- `foo.web.jpg` — default published variant (2000px / q82), referenced by markdown
- `foo.zoom.jpg` — larger variant (≈2400px / q85) for images meant to be viewed large
- `foo.nocompress.jpg` — opt-out marker; kept full quality, referenced directly

**Sizing criterion (validated):** cap by **display width**, not original size. The content column is
900px (`_quarto.yml` → `body-width`), so ~2000px (2× for HiDPI) is the natural cap; add a secondary
file-size clamp for unusually heavy images. Auto-scaling the target by the *original's* pixel size is
the wrong signal (screens never render those extra pixels).

**Quality/size sweep (source photo `001.02-conciergerie.jpg`, 6.9 MB, 4000×1848):**

| Max dim | Quality | Output | Size |
|---------|---------|--------|------|
| 2400px | 88 | 2400×1109 | 531 KB |
| 2000px | 82 | 2000×924 | 294 KB |
| 1600px | 80 | 1600×739 | 176 KB |

---

## 🧭 Deployment-Strategy Investigation

Triggered by the desire for **progressive (per-file) deploy** and **instant refresh**, several
alternative hosting/deploy models were evaluated against firm requirements.

### Requirements

1. **Authentication** — the public Learning Hub *and* a private variant must both work.
2. **Instant availability on deploy** — a deployed file must be live on next browser refresh, with
   **no CDN propagation delay**.
3. **Progressive deploy** — publish only changed files, not the whole package.

### Options evaluated

| Option | Auth | Instant (no CDN) | Progressive | Verdict |
|--------|------|------------------|-------------|---------|
| **App Service + Easy Auth** (serve from `wwwroot`) | ✅ Entra ID, site-wide gate | ✅ served from local SSD | ✅ via per-file deploy | **Recommended** |
| Azure Static Web Apps | ✅ per-route roles | ⚠️ CDN propagation (fast, not instant) | ✅ native | Good for mixed per-page auth; CDN + size limits (free 250 MB / std 500 MB) conflict with 305 MB output |
| Storage Static Website + Front Door | ❌ anonymous only | ⚠️ CDN | ✅ `azcopy sync` | **Ruled out** by auth requirement |
| App Service reads from Storage mount | ✅ | ✅ | ✅ | Feasible but Windows = **Azure Files only** (blob is Linux-only); SMB per-request latency |
| `WEBSITE_RUN_FROM_PACKAGE=1` | ✅ | ✅ | ❌ (whole package) | Parked — 1 GB zip limit uncertain given ~340 MB of originals; not progressive |

### Key facts established (Microsoft Learn)

- **Windows App Service cannot mount Azure Blob** — only Azure Files (SMB). Blob (read-only, cached)
  mounts are **Linux-only**.
- **Storage Static Website** (`$web`) is **anonymous read only** — no AuthN/AuthZ.
- `WEBSITE_RUN_FROM_PACKAGE=1` (local zip) is documented to **improve** cold start (not degrade it);
  its real constraints are read-only `wwwroot` and a **1 GB** zip limit.
- With **no CDN**, there is nothing to "invalidate" server-side — immediacy is governed by **browser
  cache headers** (`Cache-Control: no-cache` + `ETag` on HTML), not a purge call.

### Recommendation

**Stay on App Service** — it uniquely satisfies auth (Easy Auth) + immediacy (direct `wwwroot`
serving, no CDN). Achieve progressive + instant with **per-file deploy into `wwwroot`**
(Kudu VFS `PUT /api/vfs/site/wwwroot/...` or `az webapp deploy --type static`) plus HTML cache
headers — no storage account, no SMB latency, fastest serving. The storage-mount variant remains a
fallback if content/app decoupling becomes a requirement.

---

## 📚 Additional Information

- The `docs/` folder is **gitignored** and re-rendered on every deploy, so build-time compression
  and any in-place processing never touch committed source.
- A second, related issue in this folder ([overview.md](overview.md)) covers static-asset **404s**
  (`.woff` MIME type + a missing `diginsight.bulb.svg`) surfaced on the same App Service.

---

## ✔️ Resolution Status

**Status:** 🟡 In Progress

**Done:**

- [x] Root-caused the OneDeploy 500 to package size (already-compressed JPEGs in the zip)
- [x] Added `scripts/compress-images.ps1` + workflow compression step (590 → 308 MB; ~65 MB upload)
- [x] Validated quality/size policy with a real-image sweep
- [x] Investigated and compared deployment strategies against auth + immediacy + progressive
- [x] Established platform facts (Windows blob-mount limit, static-website no-auth, RFP limits)

**Open decisions:**

- [ ] Confirm public/private split shape: **two sites** (uniform gate each) vs **one site, mixed
      per-page** — determines App Service Easy Auth vs SWA
- [ ] Choose deploy mechanism: **per-file `wwwroot` deploy (Option B, recommended)** vs Azure Files
      mount (Option A)
- [ ] Implement source-stored compressed-image convention (`.web` / `.zoom` / `.nocompress`)
- [ ] Decide whether to fix the 810-entry sidebar duplication (per-section sidebars)

---

## 🎓 Lessons Learned

**What went wrong:**

- Deploying a static site as one large package coupled *content weight* to *deploy reliability*;
  already-compressed JPEGs made the zip upload huge and tripped OneDeploy's 500.
- A copied theme carried a 810-entry global sidebar inlined into every page — invisible until size
  became a problem.

**What went right:**

- Compressing the disposable `docs/` artifact fixed the blocker without touching source originals.
- Grounding the architecture options in Microsoft Learn caught two would-be dead ends early
  (Windows blob-mount limit; static-website has no auth).

**Improvements for the future:**

- Treat requirements (auth, immediacy, progressive) as filters *first* — they eliminated the
  storage+CDN path before any work was spent on it.
- Prefer display-width-based image sizing + source-stored variants so page weight is bounded at
  authoring time, not patched at deploy time.

---

## 📎 Appendix

### References

- Deploy files / OneDeploy — <https://learn.microsoft.com/en-us/azure/app-service/deploy-zip>
- Run from package — <https://learn.microsoft.com/en-us/azure/app-service/deploy-run-package>
- Mount Azure Storage (Windows = Files only) — <https://learn.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage>
- Storage static website (anonymous only) — <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website>

### Changed / added files

| File | Change |
|------|--------|
| `scripts/compress-images.ps1` | New — in-place JPEG downscale/re-encode for the deploy artifact |
| `.github/workflows/azure-webapp-deploy.yml` | New **Compress images in output** step (render → compress → deploy) |
