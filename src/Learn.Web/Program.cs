using Learn.Web;
using Learn.Web.Components;
using Learn.Web.ContentSources;
using Learn.Web.Shared;
using Learn.Web.Shared.Navigation;
using Learn.Web.Shared.Rendering;
using Learn.Web.Shared.Services;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

// File logging to the shared Diginsight log folder, matching the sample apps:
//   %USERPROFILE%\LogFiles\Diginsight\Learn.Web.<yyyyMMdd>.log
string logDir = Path.Combine(
    Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "LogFiles", "Diginsight");
Directory.CreateDirectory(logDir);
log4net.GlobalContext.Properties["LogDir"] = logDir;
builder.Logging.AddLog4Net("log4net.config");

// Razor Components host with interactive WebAssembly components (prerendered by default).
builder.Services.AddRazorComponents()
    .AddInteractiveWebAssemblyComponents();

builder.Services.Configure<ContentOptions>(builder.Configuration.GetSection("Content"));

// Server-side content source: FileSystem (repo clone) in dev, Blob (storage) in prod.
builder.Services.AddSingleton<IContentSource>(sp =>
{
    ContentOptions options = sp.GetRequiredService<IOptions<ContentOptions>>().Value;
    IWebHostEnvironment env = sp.GetRequiredService<IWebHostEnvironment>();

    if (string.Equals(options.Source, "FileSystem", StringComparison.OrdinalIgnoreCase))
    {
        string root = Path.GetFullPath(Path.Combine(env.ContentRootPath, options.FileSystem.RootPath));
        return new FileSystemContentSource(root);
    }

    return new BlobContentSource(options.Blob.AccountUri, options.Blob.ContainerName);
});

builder.Services.AddScoped<IMarkdownRenderer, MarkdigMarkdownRenderer>();
builder.Services.AddScoped<PageLoader>();
builder.Services.AddScoped<NavigationService>();
builder.Services.AddScoped<TocState>();
builder.Services.AddScoped<ThemeState>();

WebApplication app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/error", createScopeForErrors: true);
    app.UseHsts();
    app.UseHttpsRedirection();
}

app.UseAntiforgery();

// Map fingerprinted static assets (app.css + the WASM _framework payload). Must run before
// AddInteractiveWebAssemblyRenderMode so the client bootstrap (blazor.web.js) is served.
app.MapStaticAssets();

// Raw Markdown/asset endpoint consumed by the WASM client's HttpContentSource.
app.MapGet("/_content-raw/{**key}", async (string key, IContentSource source, CancellationToken ct) =>
{
    ContentResult? result = await source.GetAsync(key, ct);
    return result is null
        ? Results.NotFound()
        : Results.Bytes(result.Bytes, result.ContentType ?? "text/markdown; charset=utf-8");
});

app.MapRazorComponents<App>()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(Learn.Web.Client.Marker).Assembly);

app.Run();
