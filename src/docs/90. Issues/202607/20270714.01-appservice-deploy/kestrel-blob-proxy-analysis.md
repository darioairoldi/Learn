# Serving the Quarto site via a Kestrel blob-proxy (caching reverse-proxy) — feasibility analysis

**Date Reported:** 2026-07-14
**Reporter:** Dario Airoldi
**Status:** 🔵 Design proposal — feasibility confirmed, decision open
**Severity:** N/A (architecture option, not a defect)
**Component:** Learning Hub hosting · Azure App Service (Windows) · Azure Blob Storage
**Framework:** ASP.NET Core (Kestrel) · `Azure.Storage.Blobs` · Managed Identity

---

## 📑 Table of Contents

- [📝 Description](#-description)
- [🎯 Requirements Driving It](#-requirements-driving-it)
- [🔬 Feasibility Analysis](#-feasibility-analysis)
- [🏗️ Design Details](#️-design-details)
- [🧪 Reference Implementation Sketch](#-reference-implementation-sketch)
- [⚖️ Trade-offs vs Alternatives](#️-trade-offs-vs-alternatives)
- [✔️ Resolution Status](#️-resolution-status)
- [🎓 Lessons Learned](#-lessons-learned)
- [📎 Appendix](#-appendix)

---

## 📝 Description

Rather than mounting Azure Storage (rejected — Windows App Service supports Azure **Files** only, not
Blob), the proposal is a small **ASP.NET Core (Kestrel) app** that acts as a **caching reverse-proxy**
in front of a Blob container:

1. Request arrives at the app (behind App Service Easy Auth).
2. The app maps the URL path to a blob name and fetches the blob over HTTPS via the Blob SDK.
3. The response is **cached in memory** (LRU with a size cap) and returned with the correct
   `Content-Type`.
4. A deploy uploads only changed blobs, then calls a **cache-invalidation endpoint** → the next
   request serves the fresh page.

This matches the earlier "deploy file to storage → invalidate link → instant refresh" model, with the
Kestrel app playing the role of the web app.

---

## 🎯 Requirements Driving It

| # | Requirement | Met by this design |
|---|-------------|--------------------|
| 1 | Authentication (public + private variants) | ✅ Easy Auth sits in front of the app |
| 2 | Instant availability on deploy (no CDN delay) | ✅ single origin + invalidation endpoint |
| 3 | Progressive deploy (only changed files) | ✅ upload changed blobs |
| 4 | Content decoupled from the app | ✅ content lives in storage |

---

## 🔬 Feasibility Analysis

**Feasible — and the Quarto site works unchanged**, because Quarto output is pure static files
(HTML/CSS/JS/images/`search.json`). Any correct static-file server serves it; here the backing store
is a blob container.

Key findings:

- **Sidesteps the Windows blob-mount limitation.** The app uses the Blob **SDK over HTTPS**, not an OS
  mount, so the "Windows App Service can't mount Blob" constraint does not apply — it runs on the
  existing Windows app.
- **Secretless.** `DefaultAzureCredential` + Managed Identity with the *Storage Blob Data Reader* role
  — no account keys or SAS to manage.
- **Auth preserved.** Easy Auth (Entra ID) still gates the app, so the public/private split is intact.
- **Instant refresh without a CDN.** A single origin means there is nothing to propagate; a long cache
  TTL plus an explicit invalidation call gives immediate freshness with no per-request storage cost.
- **MIME issues disappear.** Content types are set in code (`FileExtensionContentTypeProvider` or the
  blob's stored content-type), so the earlier IIS `.woff` 404 class of problem cannot recur.
- **Existing stack fit.** The repo already builds/publishes .NET (MetadataWatcher), so an ASP.NET Core
  app aligns with current tooling.

---

## 🏗️ Design Details

| Concern | Handling |
|---------|----------|
| **Default documents** | `/` → `index.html`; `/foo/` → `foo/index.html` in the path normalizer |
| **Content types** | `FileExtensionContentTypeProvider`, or read the blob's stored content-type |
| **404** | Serve `404.html` with status 404 (matches current `web.config` behavior) |
| **Memory** | LRU `IMemoryCache` with a **size cap**; cache on access — never preload all HTML |
| **Instant refresh** | Long TTL + `/_cache/invalidate` endpoint called by deploy (or short TTL / ETag revalidation) |
| **Browser cache** | Send `ETag` + `Cache-Control: no-cache` on HTML so clients revalidate |
| **Cold path** | First hit for an uncached path = one in-region blob fetch (tens of ms); warm = memory |

---

## 🧪 Reference Implementation Sketch

Approx. 100 lines of minimal-API code:

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddMemoryCache(o => o.SizeLimit = 200_000_000); // ~200 MB LRU cap
var app = builder.Build();

var container = new BlobContainerClient(
    new Uri("https://samplestmcstitn01.blob.core.windows.net/learn"),
    new DefaultAzureCredential());              // managed identity, no keys
var ctp = new FileExtensionContentTypeProvider();

app.MapPost("/_cache/invalidate", (string? path, IMemoryCache c) => {
    if (path is null) { /* flush all */ } else c.Remove(Norm(path));
    return Results.Ok();
}); // protect with a key / auth

app.MapGet("/{**path}", async (string? path, IMemoryCache cache) => {
    var key = Norm(path);                        // "" -> index.html, "foo/" -> foo/index.html
    var entry = await cache.GetOrCreateAsync(key, async e => {
        var blob = container.GetBlobClient(key);
        if (!await blob.ExistsAsync()) {
            var nf = await container.GetBlobClient("404.html").DownloadContentAsync();
            var b = nf.Value.Content.ToArray(); e.SetSize(b.Length);
            return new Cached(b, "text/html", 404);
        }
        var r = await blob.DownloadContentAsync();
        var bytes = r.Value.Content.ToArray(); e.SetSize(bytes.Length);
        ctp.TryGetContentType(key, out var mime);
        return new Cached(bytes, mime ?? "application/octet-stream", 200);
    });
    return Results.Bytes(entry!.Bytes, entry.ContentType, statusCode: entry.Status);
});
```

---

## ⚖️ Trade-offs vs Alternatives

| | **Kestrel blob-proxy** (this) | **Per-file deploy into `wwwroot`** (Option B) |
|---|---|---|
| Progressive deploy | ✅ upload changed blobs | ✅ PUT changed files |
| Instant refresh | ✅ invalidate endpoint | ✅ (no CDN) |
| Auth (Easy Auth) | ✅ | ✅ |
| Windows blob limit | ✅ N/A (SDK over HTTPS) | ✅ N/A |
| Serving latency | ✅ warm = memory; cold = one blob fetch | ✅ local SSD always |
| **Content/app decoupling** | ✅ content in storage | ❌ content in the app |
| **Code to own** | ⚠️ a small app to build/secure/monitor | ✅ none |

**Lower-code alternative:** **YARP** + output caching can reverse-proxy to the blob static-website
endpoint with mostly configuration instead of custom code.

**Deciding factor:** whether **content-in-storage decoupling** (deploy = blob upload + cache flush,
content independent of the app) is worth owning ~100 lines of caching-proxy code. If not, Option B
delivers the same progressive + instant behavior with zero custom code and fastest serving.

---

## ✔️ Resolution Status

**Status:** 🔵 Feasibility confirmed — awaiting decision

- [x] Confirmed the design is feasible and the Quarto site works unchanged
- [x] Confirmed it avoids the Windows blob-mount limitation (SDK over HTTPS)
- [x] Confirmed auth (Easy Auth) and instant refresh (invalidate endpoint) are satisfied
- [ ] **Decide:** Kestrel blob-proxy (content decoupled) vs Option B (per-file `wwwroot`, no code)
- [ ] If chosen: scaffold the app, assign *Storage Blob Data Reader* to the app identity, wire the
      deploy to upload blobs + call `/_cache/invalidate`
- [ ] Confirm public/private split shape (two sites vs one mixed site)

---

## 🎓 Lessons Learned

- A **SDK-over-HTTPS proxy** is a clean way around platform mount limitations — the "Windows can't
  mount Blob" wall only applies to OS mounts, not to code that calls the Blob API.
- The user's "deploy + invalidate link" mental model maps cleanly onto an **app-level cache
  invalidation endpoint**, giving instant refresh without a CDN.
- Custom-code convenience must be weighed against **operational ownership** — a caching proxy is small
  but is still an app to secure, monitor, and maintain versus zero-code static serving.

---

## 📎 Appendix

### Related documents

- [overview.md](overview.md) — static-asset 404s (`.woff` MIME, missing SVG)
- [deploy-failure-and-strategy-analysis.md](deploy-failure-and-strategy-analysis.md) — OneDeploy 500
  root cause, image compression, and the full deployment-strategy comparison

### References

- Mount Azure Storage (Windows = Files only) — <https://learn.microsoft.com/en-us/azure/app-service/configure-connect-to-azure-storage>
- Static website hosting in Azure Storage — <https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website>
- Azure Blob storage client library for .NET — <https://learn.microsoft.com/en-us/dotnet/api/overview/azure/storage.blobs-readme>
