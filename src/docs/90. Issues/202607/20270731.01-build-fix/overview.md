---
title: "Learn.Web restore fails because nuget.org is inherited as disabled"
author: "Dario Airoldi"
date: "2026-07-31"
categories: [issue, learn-web, dotnet, nuget, build]
description: "A clean Learn.Web build failed with NU1101 because an inherited user-level setting disabled nuget.org despite the repository source definition."
publish: false
---

# Learn.Web restore fails because nuget.org is inherited as disabled

**Date reported:** July 31, 2026  
**Reporter:** Dario Airoldi  
**Status:** Resolved  
**Severity:** High  
**Component:** `Learn.Web` build and NuGet restore configuration  
**Framework:** .NET 10 (`net10.0`, SDK `10.0.302`)

---

## 📑 Table of contents

- [📝 Description](#-description)
- [🔍 Context information](#-context-information)
- [🔬 Analysis](#-analysis)
- [🔄 Reproduction steps](#-reproduction-steps)
- [✅ Solution implemented](#-solution-implemented)
- [📚 Additional information](#-additional-information)
- [✔️ Resolution status](#️-resolution-status)
- [🎓 Lessons learned](#-lessons-learned)
- [📎 Appendix](#-appendix)
- [📚 References](#-references)

---

## 📝 Description

A normal incremental build of the Learning Hub solution succeeded, but a clean build of the
`Learn.Web` project failed during package restore. NuGet couldn't resolve 36 public dependencies,
including ASP.NET Core WebAssembly, Azure SDK, Diginsight, and OpenTelemetry packages.

The first actionable error was:

```text
error NU1101: Unable to find package Microsoft.AspNetCore.Components.WebAssembly.
No packages exist with this id in source(s): C:\Program Files\dotnet\library-packs
```

The failure blocked clean local builds and any build that required a fresh restore. Incremental builds
could appear healthy when the required packages and outputs were already cached.

## 🔍 Context information

The following environment and diagnostic values were observed during the investigation.

| Property | Observed value |
|---|---|
| Repository | `darioairoldi/Learn`, branch `main` |
| Operating system | Windows |
| .NET SDK | `10.0.302` |
| Target framework | `net10.0` |
| Project | `src/Learn.Web/Learn.Web.csproj` |
| Solution | `src/Learn.sln` |
| Repository NuGet config | `nuget.config` |
| User NuGet config | `C:\Users\darioa\AppData\Roaming\NuGet\NuGet.Config` |
| Failed restore source | `C:\Program Files\dotnet\library-packs` |
| Failure | 36 `NU1101` package-resolution errors |
| User-config modification time | July 31, 2026, 11:21 local time |

### Diagnostic sequence

| Check | Result |
|---|---|
| `dotnet build .\src\Learn.sln --no-restore` | Succeeded because existing restore assets and outputs were available. |
| `dotnet clean .\src\Learn.Web\Learn.Web.csproj` | Succeeded and removed the cached build outputs. |
| `dotnet build .\src\Learn.Web\Learn.Web.csproj` | Failed during restore with 36 `NU1101` errors. |
| `dotnet nuget list source` before the fix | Reported `nuget.org` as disabled. |
| Restore with `--configfile .\nuget.config` | Succeeded because the explicit repository configuration enabled `nuget.org`. |

No application exception or call stack existed because the failure occurred in NuGet restore before
the application compiled or ran.

## 🔬 Analysis

### Root cause

NuGet merges configuration by section. The repository configuration already used `<clear />` inside
`<packageSources>` and then added `nuget.org`. However, `<disabledPackageSources>` is a separate section.
Clearing package-source definitions did not clear disabled-source flags inherited from the user-level
configuration.

The user-level file contained the equivalent of:

```xml
<disabledPackageSources>
	<add key="nuget.org" value="true" />
</disabledPackageSources>
```

As a result, the repository reintroduced the `nuget.org` source definition, but the inherited disable
flag still applied to the same source key. With `nuget.org` unavailable, restore saw only the .NET SDK's
local library-pack source, which doesn't contain the application's public dependencies.

### Why the failure appeared suddenly

The first solution build used `--no-restore` and succeeded from existing assets. A clean project build
forced NuGet to resolve dependencies again and exposed the configuration problem. The application code
hadn't caused the failure.

### Who disabled nuget.org

The disable entry was stored in the roaming user configuration, not in the repository or the inspected
machine-wide Visual Studio and DevExpress configuration files. The user file was modified on July 31,
2026, at 11:21 local time.

NuGet doesn't record which process changed a configuration entry. Searches of PowerShell history and
recent Visual Studio/NuGet logs found no matching command or settings event. The available evidence
therefore can't identify the actor. Plausible causes include:

- Clearing the `nuget.org` checkbox in Visual Studio's NuGet Package Sources settings.
- Running `dotnet nuget disable source nuget.org`.
- An installer, enterprise policy, or configuration script changing the user-level NuGet settings.

The file owner, `BUILTIN\Administrators`, doesn't identify the process or person that made the change.

### Impact assessment

| Surface | Impact |
|---|---|
| Clean local build | Blocked during restore. |
| Fresh developer environment | Blocked because no package cache is available. |
| CI or other clean agents | Potentially blocked if their inherited configuration disables the same source. |
| Incremental local build | Could succeed and conceal the problem. |
| Runtime behavior | Unaffected; the application never reached compilation or startup. |

## 🔄 Reproduction steps

1. Add `nuget.org=true` under `<disabledPackageSources>` in a user-level NuGet configuration.
2. Use a repository `nuget.config` that clears and re-adds `<packageSources>` without clearing
	 `<disabledPackageSources>`.
3. Clean the `Learn.Web` project to remove existing outputs.
4. Run `dotnet build .\src\Learn.Web\Learn.Web.csproj`.
5. Observe `NU1101` errors that list only `C:\Program Files\dotnet\library-packs` as a source.

The configuration path that controlled the failure was [nuget.config](../../../../../nuget.config).
The affected application entry point was
[Learn.Web.csproj](../../../../Learn.Web/Learn.Web.csproj).

## ✅ Solution implemented

The repository configuration now clears inherited disabled-source entries after defining its package
sources:

```xml
<packageSources>
	<clear />
	<add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
</packageSources>
<disabledPackageSources>
	<clear />
</disabledPackageSources>
```

This change keeps the repository's intended single-source configuration deterministic. User-level or
machine-level settings can no longer disable the repository's explicitly selected public source.

- Added `<disabledPackageSources><clear /></disabledPackageSources>` to the repository configuration. (✅ done)
- Preserved the existing `<packageSources>` reset and explicit `nuget.org` definition. (✅ done)
- Avoided application-code changes because the failure was entirely in restore configuration. (✅ done)

## 📚 Additional information

### Verification results

| Verification | Result |
|---|---|
| Clean `Learn.Web` project | Succeeded. |
| Restore without explicit `--configfile` | Succeeded through normal repository config discovery. |
| `Learn.Web` build | Succeeded with 0 errors and 3 existing nullable warnings. |
| Full `src/Learn.sln` build | Succeeded with 0 errors and 5 existing warnings. |

The remaining warnings are unrelated to NuGet restore. Three are nullable warnings in `Learn.Web`
endpoint instrumentation. The solution build also reports one unused-field warning and four
threading-analyzer warnings in `IQPilot`.

### Migration and performance considerations

The fix doesn't change package versions, application binaries, runtime behavior, or restore performance
in a meaningful way. It changes only how NuGet merges disabled-source state from higher-level
configuration files.

No visible-browser validation was required because the fix changes build configuration only. It doesn't
change Learn.Web runtime behavior or UI.

## ✔️ Resolution status

**Status:** Resolved on July 31, 2026.

- Clean `Learn.Web` restore completes through the repository config. (✅ done)
- Clean `Learn.Web` build completes with 0 errors. (✅ done)
- Full `Learn.sln` build completes with 0 errors. (✅ done)
- Root cause documented, including the inherited configuration behavior. (✅ done)
- Exact actor that disabled `nuget.org` remains unknown because NuGet records no provenance. (📌 next steps)

## 🎓 Lessons learned

- **NuGet configuration sections merge independently.** Clearing `<packageSources>` doesn't clear
	`<disabledPackageSources>`.
- **Incremental builds can hide restore failures.** A successful `--no-restore` build proves that cached
	assets compile, not that a fresh environment can restore packages.
- **Test the normal discovery path.** An explicit `--configfile` restore was a useful diagnostic, but the
	final verification had to succeed without that option.
- **Configuration files don't provide attribution.** File timestamps can narrow the time window, but they
	don't identify the process that changed a setting.
- **Repository configuration should isolate required feeds.** Clearing inherited source definitions and
	inherited disabled-source flags makes restore behavior consistent across developer machines and CI.

## 📎 Appendix

### Diagnostic commands

```powershell
dotnet --version
dotnet build .\src\Learn.sln --no-restore
dotnet clean .\src\Learn.Web\Learn.Web.csproj
dotnet build .\src\Learn.Web\Learn.Web.csproj
dotnet nuget list source
dotnet nuget list source --configfile .\nuget.config
dotnet restore .\src\Learn.Web\Learn.Web.csproj --configfile .\nuget.config
dotnet build .\src\Learn.sln
```

### Representative error

```text
C:\dev\darioairoldi\Learn.01\src\Learn.Web.Client\Learn.Web.Client.csproj :
error NU1101: Unable to find package Microsoft.AspNetCore.Components.WebAssembly.
No packages exist with this id in source(s): C:\Program Files\dotnet\library-packs

Restore failed with 36 error(s).
```

## 📚 References

**[NuGet configuration settings](https://learn.microsoft.com/nuget/reference/nuget-config-file)** 📘 [Official]  
Describes NuGet configuration sections, configuration-file locations, and how settings are applied.

**[dotnet nuget disable source](https://learn.microsoft.com/dotnet/core/tools/dotnet-nuget-disable-source)** 📘 [Official]  
Documents the CLI command that writes a disabled package-source setting to NuGet configuration.

**[Repository NuGet configuration](../../../../../nuget.config)** 📘 [Internal]  
Defines the package source and now clears inherited disabled-source entries for deterministic restore.

<!--
validations:
	grammar: {status: "not_run", last_run: null}
	readability: {status: "not_run", last_run: null}
	structure: {status: "not_run", last_run: null}

article_metadata:
	filename: "overview.md"
	created: "2026-07-31"
	last_updated: "2026-07-31"
	status: "resolved"
	issue_type: "build-configuration"
-->
