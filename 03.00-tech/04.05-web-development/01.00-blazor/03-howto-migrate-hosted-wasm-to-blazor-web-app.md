---
title: "How to Migrate a Hosted Blazor WebAssembly App to a Blazor Web App"
author: "Dario Airoldi"
date: "2026-07-06"
date-modified: last-modified
categories: [blazor, dotnet, web-development, how-to, migration]
description: "Step-by-step conversion of a legacy .NET 7 hosted Blazor WebAssembly solution (Client + Server + Shared) into a unified .NET 8+ Blazor Web App."
---

# How to Migrate a Hosted Blazor WebAssembly App to a Blazor Web App

The Hosted Blazor WebAssembly template (Client + Server + Shared) was retired from the default experience in .NET 8. Your existing solution still builds, but to unlock the new Blazor features you convert it into a **Blazor Web App**. This guide follows the official minimal-change path.

> **Before you start:** this is the *minimal* conversion. To adopt every new Blazor Web App convention, create a fresh Blazor Web App and move your components into it instead. Always work on a branch and commit before each step.

## 📑 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1 — Update SDK, target framework, and packages](#step-1--update-sdk-target-framework-and-packages)
3. [Step 2 — Adjust the `.Client` project file](#step-2--adjust-the-client-project-file)
4. [Step 3 — Move `index.html` into an `App` component](#step-3--move-indexhtml-into-an-app-component)
5. [Step 4 — Share `_Imports.razor` and shorthand render modes](#step-4--share-_importsrazor-and-shorthand-render-modes)
6. [Step 5 — Update `App.razor`](#step-5--update-apprazor)
7. [Step 6 — Add a `PageTitle` to layouts](#step-6--add-a-pagetitle-to-layouts)
8. [Step 7 — Trim `.Client/Program.cs`](#step-7--trim-clientprogramcs)
9. [Step 8 — Update `.Server/Program.cs`](#step-8--update-serverprogramcs)
10. [Step 9 — Run from the `.Server` project](#step-9--run-from-the-server-project)
11. [Validation checklist](#validation-checklist)
12. [References](#references)

## Prerequisites

- The .NET 8 SDK (or later) installed.
- A working, committed copy of your .NET 7 hosted solution (`.Client`, `.Server`, `.Shared`).
- Visual Studio 2022 with the **ASP.NET and web development** workload, or VS Code + the .NET CLI.

## Step 1 — Update SDK, target framework, and packages

Apply the standard .NET 7 → 8 updates to **all three** projects (`.Client`, `.Server`, `.Shared`):

- Bump the SDK `version` in `global.json` (for example `8.0.100`).
- Change the TFM to `net8.0` in each `.csproj`.
- Update `Microsoft.AspNetCore.*`, `Microsoft.EntityFrameworkCore.*`, `Microsoft.Extensions.*`, and `System.Net.Http.Json` package `Version` attributes to `8.0.0` or later.

## Step 2 — Adjust the `.Client` project file

In the `.Client` `.csproj`, add:

```xml
<NoDefaultLaunchSettingsFile>true</NoDefaultLaunchSettingsFile>
<StaticWebAssetProjectMode>Default</StaticWebAssetProjectMode>
```

Then remove the dev-server package reference:

```diff
- <PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly.DevServer" ... />
```

## Step 3 — Move `index.html` into an `App` component

- Move the contents of `.Client/wwwroot/index.html` into a new `App.razor` created at the **root of the `.Server` project**, then delete `index.html`.
- Rename the existing `.Client/App.razor` to `Routes.razor`.
- In `Routes.razor`, set the router's `AppAssembly` to `typeof(Program).Assembly`.

## Step 4 — Share `_Imports.razor` and shorthand render modes

Add this line to the `.Client` `_Imports.razor`, then copy that file into the `.Server` project too:

```razor
@using static Microsoft.AspNetCore.Components.Web.RenderMode
```

## Step 5 — Update `App.razor`

In the new `.Server/App.razor`:

- Replace the `<title>…</title>` with a `HeadOutlet` component (prerender disabled):

  ```razor
  <HeadOutlet @rendermode="new InteractiveWebAssemblyRenderMode(prerender: false)" />
  ```

- Point the CSS style bundle at the **server** assembly name:

  ```diff
  - <link href="{CLIENT PROJECT ASSEMBLY NAME}.styles.css" rel="stylesheet">
  + <link href="{SERVER PROJECT ASSEMBLY NAME}.styles.css" rel="stylesheet">
  ```

- Replace the `<div id="app">…</div>` markup with the `Routes` component:

  ```razor
  <Routes @rendermode="new InteractiveWebAssemblyRenderMode(prerender: false)" />
  ```

- Switch the script from `blazor.webassembly.js` to `blazor.web.js`:

  ```diff
  - <script src="_framework/blazor.webassembly.js"></script>
  + <script src="_framework/blazor.web.js"></script>
  ```

## Step 6 — Add a `PageTitle` to layouts

In `.Client/Shared/MainLayout.razor` (and other layouts), add the site's default title:

```razor
<PageTitle>{TITLE}</PageTitle>
```

## Step 7 — Trim `.Client/Program.cs`

Remove the manual root-component registrations:

```diff
- builder.RootComponents.Add<App>("#app");
- builder.RootComponents.Add<HeadOutlet>("head::after");
```

## Step 8 — Update `.Server/Program.cs`

Add Razor component + interactive WebAssembly services:

```csharp
builder.Services.AddRazorComponents()
    .AddInteractiveWebAssemblyComponents();
```

Add antiforgery middleware after `app.UseHttpsRedirection` (and after any `UseAuthentication`/`UseAuthorization`):

```csharp
app.UseAntiforgery();
```

Remove the old WASM host wiring:

```diff
- app.UseBlazorFrameworkFiles();
- app.MapFallbackToFile("index.html");
```

Map Razor components with the WebAssembly render mode and the client assembly:

```csharp
app.MapRazorComponents<App>()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof({CLIENT APP NAMESPACE}._Imports).Assembly);
```

## Step 9 — Run from the `.Server` project

Start the solution from the **`.Server`** project (select it in Solution Explorer, or run from its folder with the .NET CLI). The `.Server` project is now the single host.

## Validation checklist

- [ ] All three projects target `net8.0`+ and build.
- [ ] `index.html` deleted; `App.razor` lives in `.Server`; old `App.razor` renamed to `Routes.razor`.
- [ ] Script is `blazor.web.js`; style bundle points at the server assembly.
- [ ] `Program.cs` uses `AddRazorComponents().AddInteractiveWebAssemblyComponents()` and `MapRazorComponents<App>()…`.
- [ ] App runs from the `.Server` project and routes/deep links work.

## References

- [Migrate from ASP.NET Core in .NET 7 to .NET 8 — Convert a hosted Blazor WebAssembly app into a Blazor Web App](https://learn.microsoft.com/en-us/aspnet/core/migration/70-to-80?view=aspnetcore-10.0#convert-a-hosted-blazor-webassembly-app-into-a-blazor-web-app) 📘 [Official]
- [ASP.NET Core Blazor render modes](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/render-modes?view=aspnetcore-10.0) 📘 [Official]
- [What's new in ASP.NET Core in .NET 8](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-8.0?view=aspnetcore-10.0#blazor) 📘 [Official]

<!--
article_metadata:
  content_type: "how-to"
  subcategory: "task-guide"
  created: "2026-07-06"
  last_updated: "2026-07-06"
  status: "draft"
  primary_topic: "Blazor"
  source_issue: "src/docs/90. Issues/202607/20260702.04-why-no-blazor-webassembly-webapi"
-->
