# SmartCache — adopt the standard `Diginsight:SmartCache` convention (duplicate-key crash + missing `ICacheCompanion`)

**Date Reported:** 2026-07-20
**Reporter:** Dario Airoldi
**Status:** ✅ Resolved
**Severity:** High
**Component:** Learn.Web (server host) · Diginsight SmartCache content caching
**Framework:** .NET 10 · Diginsight.SmartCache 3.7.1.13

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

`Learn.Web` caches Markdown content through a Diginsight **SmartCache** decorator over its
`IContentSource`. The cache was originally wired to a **custom** configuration shape
(`Content:Cache` with `Enabled` / `MaxAgeSeconds` / `Redis`) and gated behind an `if (Cache.Enabled)`
switch. The goal of this work was to **replace that bespoke wiring with the standard Diginsight
SmartCache convention** (`Diginsight:SmartCache` with `MaxAge` / `AbsoluteExpiration` /
`SlidingExpiration` / `ServiceBus` / `Redis`, bound via `ConfigureClassAware<SmartCacheCoreOptions>`),
matching the reference application `ABB.EL.Common.Api`.

During the refactor the server failed to start **twice**, on two distinct root causes:

**Failure #1 — configuration parse error (duplicate key):**

```text
System.IO.InvalidDataException: Failed to load configuration from file '...\appsettings.json'.
 ---> System.FormatException: A duplicate key 'Diginsight:SmartCache:MaxAge' was found.
```

**Failure #2 — dependency-injection validation error (missing companion):**

```text
System.AggregateException: Some services are not able to be constructed
 (Error while validating the service descriptor 'ServiceType: Diginsight.SmartCache.ISmartCache ...':
  Unable to resolve service for type 'Diginsight.SmartCache.Externalization.ICacheCompanion'
  while attempting to activate 'Diginsight.SmartCache.SmartCache'.)
```

**Impact:**

- 🔴 The web application **could not start** — both failures are unhandled exceptions during host build.
- 🔴 No content served (home, articles, navigation all unavailable) until each cause was fixed.
- 🔸 Config-parse failure aborts *before* any logging pipeline is fully up, making the first error easy
  to misread as a broad "bad appsettings" problem rather than a single duplicate key.

---

## 🔍 Context Information

| Property | Value |
|----------|-------|
| **Project** | `src/Learn.Web` (server host; RootNamespace `Learn.Web`) |
| **Runtime** | .NET 10, Blazor WebAssembly (prerendered) |
| **Cache library** | Diginsight.SmartCache `3.7.*` → resolved **3.7.1.13** (`net10.0`) |
| **Packages** | `Diginsight.SmartCache` + `.Externalization.Http` + `.Externalization.ServiceBus` + `.Externalization.Redis` |
| **DI validation** | `builder.UseDiginsightServiceProvider(true)` → **ValidateOnBuild = true** |
| **Config loader** | Diginsight `ConfigureAppConfiguration2` (base `appsettings.json` + `{AppName}.settings.*`) |
| **Reference app** | `C:\dev\darioa\01. ABB Port\ABB-EL-Common-Backend\ABB.EL.Common.Api\Startup.cs` |
| **Dev launch** | `dotnet run --project src/Learn.Web --launch-profile https` (ports 7280/5280) |

**Companion architecture (discovered during diagnosis).** SmartCache uses a **companion installer**
pattern to resolve `ICacheCompanion`:

| Assembly | Companion type | Registration API | Role |
|----------|----------------|------------------|------|
| `Diginsight.SmartCache` (core) | `LocalCacheCompanion` | `SetLocalCompanion` (default) | Single-instance, in-process |
| `…Externalization.Http` | `HttpCacheCompanion` | `AddHttp()` | Peer-to-peer value transfer over HTTP |
| `…Externalization.ServiceBus` | `ServiceBusCacheCompanion` | `SetServiceBusCompanion(...)` | Cross-instance invalidation via Service Bus |

`SmartCache`'s constructor takes `ICacheCompanion` **directly**, so exactly one companion must be
registered. `AddHttp()` adds a value-transfer transport but does **not** register a companion on its own.

---

## 🔬 Analysis

### Root cause #1 — two `Diginsight:SmartCache` blocks in `appsettings.json`

The reference SmartCache block had **already been pasted** into the `Diginsight` section of
`appsettings.json`. The refactor then **inserted a second** `SmartCache` block near the top of the same
section. Flattened to configuration keys, both blocks produced `Diginsight:SmartCache:MaxAge`, and the
`System.Text.Json`-based configuration provider **rejects duplicate keys** (unlike lenient JSON
readers), aborting host construction before startup.

> `appsettings.json` **is** JSONC (line comments are tolerated by the config provider). The strict rule
> is about **duplicate keys**, not comments.

### Root cause #2 — `SetServiceBusCompanion(predicate, …)` with a false predicate leaves no companion

The initial refactor mirrored the reference app verbatim:

```csharp
services
    .AddSmartCache(configuration, environment, loggerFactory)
    .AddHttp()
    .SetServiceBusCompanion(
        static (c, _) => { /* true only when ConnectionString + TopicName present */ },
        sbo => { /* bind Diginsight:SmartCache:ServiceBus */ });
```

In **local development there is no Service Bus** connection string, so the predicate returns `false`.
`SetServiceBusCompanion` then **overrode the default local companion** but installed nothing active →
`ICacheCompanion` had **no registration** at all. With `UseDiginsightServiceProvider(true)` enabling
**ValidateOnBuild**, the container eagerly tried to construct `SmartCache`, could not resolve
`ICacheCompanion`, and threw during host build.

The reference app does not hit this because its development environment **does** supply a Service Bus
connection string (predicate `true` → the Service Bus companion registers `ICacheCompanion`). `Learn.Web`
runs standalone, so it needs the **default local companion** to remain in place.

### Impact assessment

| Dimension | Assessment |
|-----------|------------|
| **Availability** | Total — app failed to start on both causes |
| **Scope** | Startup only; no data loss, no runtime corruption |
| **Detectability** | High once running — both surface as explicit unhandled exceptions |
| **Environment sensitivity** | High — cause #2 is invisible where Service Bus is configured (e.g. the reference app) |

---

## 🔄 Reproduction Steps

1. Add a `Diginsight:SmartCache` block to `appsettings.json` while another already exists in the same
   `Diginsight` section.
2. Run `dotnet run --project src/Learn.Web --launch-profile https`.
3. **Observe Failure #1:** `FormatException: A duplicate key 'Diginsight:SmartCache:MaxAge' was found.`
4. Remove the duplicate block; run again.
5. With **no Service Bus** connection string configured, wire the companion as
   `.AddHttp().SetServiceBusCompanion(<false-predicate>, …)`.
6. **Observe Failure #2:** `Unable to resolve service for type 'ICacheCompanion' while attempting to
   activate 'Diginsight.SmartCache.SmartCache'.`

**Affected code locations:**

| File | Role |
|------|------|
| `src/Learn.Web/appsettings.json` | `Diginsight:SmartCache` configuration section |
| `src/Learn.Web/Program.cs` | SmartCache registration + companion wiring |
| `src/Learn.Web/ContentSources/SmartCacheContentSource.cs` | Cache decorator over `IContentSource` |
| `src/Learn.Web/ContentOptions.cs` | Removed the obsolete `Content:Cache` options |
| `src/Learn.Web/Learn.Web.csproj` | SmartCache package references |

---

## ✅ Solution Implemented

### Fix #1 — single `Diginsight:SmartCache` block, tailored to Learn.Web

Removed the duplicate and kept one block, adjusted for this app (Learn topic name, opt-in Redis
subsection, a commented class-aware example). Also removed an unrelated `QueryCostMetricRecorder`
block that came in with the reference paste (Cosmos-specific, unused here).

```jsonc
"Diginsight": {
  // ...
  "SmartCache": {
    "MaxAge": "00:05",
    // Class-aware override example (freshness per caller type):
    // "MaxAge@SmartCacheContentSource": "12:00",
    "AbsoluteExpiration": "1",
    "SlidingExpiration": "04:00",
    "ServiceBus": {
      // "ConnectionString" from Key Vault; with a TopicName it enables the Service Bus companion.
      "TopicName": "smartcache-learnweb"
    },
    "Redis": {
      // Set "Configuration" (e.g. "localhost:6379") to enable the Redis passive backing store.
      "Configuration": "",
      "KeyPrefix": "learn-content:"
    }
  }
}
```

### Fix #2 — keep the default local companion; wire Service Bus only when configured

Bind the core options class-aware, then make the Service Bus companion **conditional in C#** so the
default `LocalCacheCompanion` survives for standalone/dev, and enable Redis only when configured:

```csharp
services.ConfigureClassAware<SmartCacheCoreOptions>(configuration.GetSection("Diginsight:SmartCache"));

SmartCacheBuilder smartCacheBuilder = services
    .AddSmartCache(configuration, environment, observabilityManager.LoggerFactory)
    .AddHttp();

// Service Bus companion is OPT-IN: only wire it when actually configured, otherwise the default
// (single-instance, in-process) companion is kept — required for the DI container to resolve
// ICacheCompanion when running standalone (local dev, no Service Bus).
IConfigurationSection serviceBusSection = configuration.GetSection("Diginsight:SmartCache:ServiceBus");
bool serviceBusConfigured =
    !string.IsNullOrEmpty(serviceBusSection[nameof(SmartCacheServiceBusOptions.ConnectionString)])
    && !string.IsNullOrEmpty(serviceBusSection[nameof(SmartCacheServiceBusOptions.TopicName)]);
if (serviceBusConfigured)
{
    smartCacheBuilder.SetServiceBusCompanion(
        static (_, _) => true,
        sbo =>
        {
            serviceBusSection.Bind(sbo);
            sbo.SubscriptionName = SmartCacheServiceBusSubscriptionName;
        });
}

// Opt-in Redis passive backing store (distributed, multi-instance).
string? smartCacheRedis = configuration["Diginsight:SmartCache:Redis:Configuration"];
if (!string.IsNullOrWhiteSpace(smartCacheRedis))
{
    smartCacheBuilder.AddRedis(o =>
    {
        o.Configuration = smartCacheRedis;
        o.KeyPrefix = configuration["Diginsight:SmartCache:Redis:KeyPrefix"] ?? "learn-content:";
    });
}
```

### Fix #3 — config-driven `MaxAge` in the cache decorator

`SmartCacheContentSource` no longer takes a `maxAge` constructor argument. It issues
`new SmartCacheOperationOptions()` and passes `callerType: typeof(SmartCacheContentSource)`, so the
freshness window comes from configuration — the global `Diginsight:SmartCache:MaxAge` (`00:05`) plus the
optional class-aware override `MaxAge@SmartCacheContentSource`.

### Why these fixes

- **Conditional companion over verbatim copy** — the app must run **standalone** in dev; keeping the
  default local companion is the behaviour the library provides for single-instance operation.
- **Config-driven freshness over a hardcoded `maxAge`** — one convention, per-caller overridable, and
  consistent with every other Diginsight-instrumented service.
- **Delete the old `Content:Cache` shape entirely** — removes a second, non-standard configuration
  surface (`ContentOptions.Cache` / `CacheOptions` / `RedisOptions`) that would otherwise drift.

---

## 📚 Additional Information

- **Runtime verification (Diginsight log).** Two requests for the same file produced the expected
  sequence:
  - Request 1 → `SmartCacheContentSource.GetAsync` → `SmartCache.GetAsync` **Cache miss** →
    `FileSystemContentSource.GetAsync` (reads file) → `SmartCache.SetValue`.
  - Request 2 → **Cache hit** (`callerType:SmartCacheContentSource`; minimum creation date =
    `now − 5min`, exactly the `MaxAge=00:05` window).
- **Console is disabled in dev** (`Observability:ConsoleEnabled=false`); verification relies on
  `%USERPROFILE%\LogFiles\Diginsight\Learn.Web.<yyyyMMdd>.log`, not stdout.
- **Distributed topology.** `ServiceBus` (push invalidation) and `Redis` (passive backing store) are
  both opt-in and only activate when their respective configuration is present — safe to leave empty
  in single-instance deployments.
- **Reload / freshness consideration (open).** Global `MaxAge` is `00:05`. In dev, the FileSystem
  source uses `WatchForChanges`, but SmartCache is **not** invalidated on file change — an edited
  Markdown file can be up to 5 minutes stale. The class-aware `MaxAge@SmartCacheContentSource`
  override is left commented as the tuning knob; a change-driven invalidation hook is a possible
  future improvement.

---

## ✔️ Resolution Status

**Status:** ✅ Resolved

**Verification checklist:**

- [x] Single `Diginsight:SmartCache` block in `appsettings.json` (duplicate removed)
- [x] Unrelated `QueryCostMetricRecorder` reference-paste block removed
- [x] `Program.cs` wires the Service Bus companion only when configured; default local companion kept
- [x] Opt-in Redis backing store wired only when `Redis:Configuration` is non-empty
- [x] `SmartCacheContentSource` uses config-driven `MaxAge` (no `maxAge` ctor arg)
- [x] Build succeeds (0 errors; 2 pre-existing `CS8604` nullable-logger warnings, unrelated)
- [x] Server boots cleanly (DI ValidateOnBuild passes with the default local companion)
- [x] Log confirms **Cache miss → Cache hit** through `SmartCacheContentSource`
- [x] Headed browser smoke test: **11/12** checks pass (the 12th is an expected `index.md` probe 404)

**Follow-up actions:**

- [ ] Consider change-driven SmartCache invalidation in dev (avoid up-to-5-min staleness on file edits).
- [ ] Document the standard `Diginsight:SmartCache` block in the app README / config reference.

---

## 🎓 Lessons Learned

**What went wrong:**

- The .NET configuration provider **rejects duplicate keys**; pasting a reference block into a file that
  already contained one produced an opaque `FormatException` before logging was fully available.
- Copying DI wiring **verbatim** from a reference app is environment-sensitive: a `false`
  Service-Bus predicate that is harmless where Service Bus is configured leaves **no companion** in a
  standalone app, and `ValidateOnBuild` turns that into a hard startup failure.

**What went right:**

- `UseDiginsightServiceProvider(true)` (**ValidateOnBuild**) surfaced the missing `ICacheCompanion`
  **at startup** instead of on first cache use — a fail-fast that made the cause unambiguous.
- The companion **installer** model (core `LocalCacheCompanion`, Http, Service Bus) meant the fix was a
  configuration/wiring decision, not a code workaround.

**Improvements for the future:**

- Before inserting a config block, grep the target file for the same section to avoid duplicate keys.
- When adapting reference DI wiring, make environment-dependent companions **conditional in code** so
  the app degrades cleanly to single-instance defaults.
- Prefer **config-driven, class-aware** options (`MaxAge@Type`) over hardcoded constructor arguments.

---

## 📎 Appendix

### A. Companion decision matrix

| Configuration present | Companion used | Effect |
|-----------------------|----------------|--------|
| none (dev default) | `LocalCacheCompanion` | In-process cache, single instance |
| `ServiceBus:ConnectionString` + `TopicName` | `ServiceBusCacheCompanion` | Cross-instance push invalidation |
| `Redis:Configuration` | `LocalCacheCompanion`/Service Bus + Redis backing | Distributed passive backing store |

### B. Key error signatures

```text
# Failure #1 (config parse)
System.FormatException: A duplicate key 'Diginsight:SmartCache:MaxAge' was found.

# Failure #2 (DI validation)
Unable to resolve service for type 'Diginsight.SmartCache.Externalization.ICacheCompanion'
while attempting to activate 'Diginsight.SmartCache.SmartCache'.
```

### C. Files changed

| File | Change |
|------|--------|
| `src/Learn.Web/appsettings.json` | Single `Diginsight:SmartCache` block; removed duplicate + `QueryCostMetricRecorder` |
| `src/Learn.Web/Program.cs` | `ConfigureClassAware<SmartCacheCoreOptions>`; conditional Service Bus companion; opt-in Redis |
| `src/Learn.Web/ContentSources/SmartCacheContentSource.cs` | Config-driven `MaxAge` (removed ctor arg) |
| `src/Learn.Web/ContentOptions.cs` | Removed obsolete `Content:Cache` / `CacheOptions` / `RedisOptions` |
| `src/Learn.Web/Learn.Web.csproj` | Added `.Externalization.Http` + `.Externalization.ServiceBus` package refs |

### D. Reference

- Reference application: `ABB.EL.Common.Api\Startup.cs` (standard `Diginsight:SmartCache` convention).
- Log file: `%USERPROFILE%\LogFiles\Diginsight\Learn.Web.<yyyyMMdd>.log`.
