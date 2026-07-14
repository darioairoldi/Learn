# Learning Hub — static assets return 404 on Azure App Service deploy

**Date Reported:** 2026-07-14
**Reporter:** Dario Airoldi
**Status:** ✅ Resolved
**Severity:** Medium
**Component:** Learning Hub (Quarto static site) · Azure App Service (Windows / IIS) deployment
**Framework:** Quarto 1.6.42 · IIS static hosting

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🔍 Context Information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction Steps](#-reproduction-steps)
- [✅ Solution Implemented](#-solution-implemented)
- [📚 Additional Information](#-additional-information)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

After deploying the Learning Hub to the Windows Azure App Service `learn-testmc-app-itn-01`, the
site loaded but the browser DevTools **Network** panel reported two `404` responses for static
assets. The pages rendered, but the navbar brand icon was missing and Bootstrap Icons glyphs did
not display.

**Observed error responses:**

| Resource | Status | Initiator |
|----------|--------|-----------|
| `diginsight.bulb.svg` | `404` (served as `text/html`) | `styles.css` |
| `bootstrap-icons.woff?2820a3852bdb9a5832199cc61cec4e65` | `404` | `bootstrap-icons.css` |

**Impact:**

- 🔸 Navbar brand lightbulb icon missing on every page.
- 🔸 Bootstrap Icons font glyphs fail to render (icon characters show as tofu/blank).
- 🔸 Console/network noise on every page load; the custom `404.html` page is served in place of the
  missing assets.

---

## 🔍 Context Information

| Property | Value |
|----------|-------|
| **Hosting** | Azure App Service — Windows plan, IIS static hosting |
| **App name** | `learn-testmc-app-itn-01` |
| **Deploy pipeline** | `.github/workflows/azure-webapp-deploy.yml` (Quarto render → deploy `docs/`) |
| **Static host config** | `deploy/azure/web.config` (copied to `docs/web.config` at deploy time) |
| **Site generator** | Quarto 1.6.42 → static HTML in `docs/` |
| **Bootstrap Icons** | v1.11.1 (shipped as `.woff`, not `.woff2`) |

Both assets were present in the render output (`docs/site_libs/bootstrap/bootstrap-icons.woff` exists),
yet IIS still returned `404` for the font — pointing to a serving/config problem rather than a missing
render artifact. The SVG, by contrast, was genuinely absent from the repository.

---

## 🔬 Analysis

### Root cause #1 — `.woff` MIME type not registered in IIS

IIS on Azure App Service returns `404` for any file extension **without a registered MIME type**
(technically a `404.3`). The deploy `web.config` registered `.woff2` but **not** `.woff`. Bootstrap
Icons v1.11.1 references only the `.woff` format:

```css
/* docs/site_libs/bootstrap/bootstrap-icons.css */
@font-face {
  font-family: "bootstrap-icons";
  src: url("./bootstrap-icons.woff?2820a3852bdb9a5832199cc61cec4e65") format("woff");
}
```

The font file was deployed correctly, but IIS refused to serve it because the extension was unknown.

### Root cause #2 — `diginsight.bulb.svg` referenced but never existed

`styles.css` styled the navbar brand with a background image pointing at a file that does not exist
anywhere in the repository — a leftover from the original "Diginsight Telemetry" theme the stylesheet
was copied from:

```css
.navbar-brand::before {
  background-image: url("diginsight.bulb.svg"); /* file never existed in this repo */
}
```

Because the file was missing, IIS served the custom `404.html` (hence the `text/html` content type on
the `404` response).

### Impact assessment

| Dimension | Assessment |
|-----------|------------|
| **Site availability** | ✅ Unaffected — pages render and navigate normally |
| **Visual correctness** | ⚠️ Degraded — missing brand icon and icon-font glyphs |
| **Severity** | 🟡 Medium — cosmetic + console noise, no functional outage |

---

## 🔄 Reproduction Steps

1. Render the Quarto site and deploy `docs/` to the Windows App Service via
   `azure-webapp-deploy.yml`.
2. Browse to `https://learn-testmc-app-itn-01.azurewebsites.net`.
3. Open DevTools → **Network** panel and reload.
4. Observe two `404` responses: `diginsight.bulb.svg` (from `styles.css`) and `bootstrap-icons.woff`
   (from `bootstrap-icons.css`).

**Affected files:**

| File | Role |
|------|------|
| `deploy/azure/web.config` | IIS static-hosting MIME configuration |
| `styles.css` | Navbar brand icon reference |
| `docs/site_libs/bootstrap/bootstrap-icons.css` | Bootstrap Icons `@font-face` (generated) |

---

## ✅ Solution Implemented

### Fix #1 — Register the `.woff` MIME type

Added a `font/woff` MIME mapping to `deploy/azure/web.config` alongside the existing `.woff2` entry:

```xml
<staticContent>
  <remove fileExtension=".webmanifest" />
  <mimeMap fileExtension=".webmanifest" mimeType="application/manifest+json" />
  <remove fileExtension=".woff" />
  <mimeMap fileExtension=".woff" mimeType="font/woff" />
  <remove fileExtension=".woff2" />
  <mimeMap fileExtension=".woff2" mimeType="font/woff2" />
</staticContent>
```

### Fix #2 — Replace the missing SVG with an inline data URI

Replaced the broken external file reference in `styles.css` with an inline `data:image/svg+xml`
lightbulb icon. This removes the 404 entirely — no separate asset to deploy and no MIME type or
resource-copy concerns:

```css
.navbar-brand::before {
  content: "";
  display: inline-block;
  width: 1.2em;
  height: 1.2em;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23ffc107'%3E%3Cpath d='M2 6a6 6 0 1 1 10.174 4.31c-.203.196-.359.4-.453.619l-.762 1.769A.5.5 0 0 1 10.5 13a.5.5 0 0 1 0 1 .5.5 0 0 1 0 1l-.224.447a1 1 0 0 1-.894.553H6.618a1 1 0 0 1-.894-.553L5.5 15a.5.5 0 0 1 0-1 .5.5 0 0 1 0-1 .5.5 0 0 1-.46-.302l-.761-1.77a2 2 0 0 0-.453-.618A5.98 5.98 0 0 1 2 6'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-size: contain;
  vertical-align: middle;
  margin-right: 8px;
}
```

### Why these fixes

- **Data URI over restoring the SVG file** — self-contained, survives re-renders, and avoids relying
  on Quarto to copy a CSS-referenced asset into the output.
- **MIME registration over converting the font** — the font is generated by Quarto/Bootstrap; fixing
  the host config is the durable fix and also protects any other `.woff` assets.

---

## 📚 Additional Information

- **Deploy flow:** the workflow deletes and re-renders `docs/` on every run, then copies
  `deploy/azure/web.config` → `docs/web.config`. Editing the source files is sufficient; the `docs/`
  build artifact regenerates automatically.
- **Testing recommendation:** after deploy, reload with the Network panel open and confirm zero `404`
  responses; verify the navbar lightbulb renders and Bootstrap Icons glyphs display.
- **No performance impact:** the inline SVG is a few hundred bytes embedded in `styles.css`.

---

## ✔️ Resolution Status

**Status:** ✅ Resolved (pending next deploy)

**Verification checklist:**

- [x] `.woff` MIME type added to `deploy/azure/web.config`
- [x] `styles.css` navbar icon switched to inline data URI
- [x] No remaining relative `url(...)` references to missing assets in `styles.css` / includes
- [ ] Redeploy to App Service and confirm both `404`s are gone
- [ ] Confirm navbar icon + Bootstrap Icons glyphs render on the live site

**Follow-up actions:**

- [ ] Consider a post-deploy link/asset check step in the workflow to catch `404`s automatically.

---

## 🎓 Lessons Learned

**What went wrong:**

- IIS silently refuses to serve any extension lacking a MIME mapping — a `.woff` file can be deployed
  yet still `404`. MIME coverage must match every asset type the site actually references.
- Copied stylesheets can carry dangling references (`diginsight.bulb.svg`) from their origin project
  that only surface once deployed.

**What went right:**

- The custom `404.html` handler made the missing assets visible in the Network panel (as `text/html`
  responses), aiding diagnosis.

**Improvements for the future:**

- Prefer inline data URIs for small theme icons to eliminate a whole class of asset-path/MIME issues.
- Audit `web.config` MIME mappings against the asset extensions Quarto emits (`.woff`, `.woff2`,
  `.json`, `.webmanifest`, etc.) whenever the theme or Quarto version changes.

---

## 📎 Appendix

### Reference: IIS static content MIME behavior

Windows/IIS returns `HTTP 404.3 (Not Found)` for requests whose file extension has no configured MIME
type. Registering the extension under `<staticContent><mimeMap>` in `web.config` resolves it. This is
distinct from a genuinely missing file, which (with a custom `httpErrors` rule) returns the custom
error page as `text/html`.

### Related files

| File | Change |
|------|--------|
| `deploy/azure/web.config` | Added `font/woff` MIME mapping |
| `styles.css` | Inline data-URI lightbulb replacing `diginsight.bulb.svg` |
