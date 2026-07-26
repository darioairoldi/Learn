using Learn.Web.Client;
using Learn.Web.Shared;
using Learn.Web.Shared.Navigation;
using Learn.Web.Shared.Rendering;
using Learn.Web.Shared.Services;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

var builder = WebAssemblyHostBuilder.CreateDefault(args);

// Talk back to the origin that served the app (the Learn.Web host).
builder.Services.AddScoped(_ => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });

// In WASM, content is fetched over HTTP; rendering runs in-browser with the same Markdig engine.
builder.Services.AddScoped<IContentSource, HttpContentSource>();
builder.Services.AddScoped<IMarkdownRenderer, MarkdigMarkdownRenderer>();
builder.Services.AddScoped<PageLoader>();
builder.Services.AddScoped<TocState>();
builder.Services.AddScoped<ThemeState>();
builder.Services.AddScoped<SidebarState>();
builder.Services.AddScoped<NavStats>();
builder.Services.AddScoped<ArticleState>();
builder.Services.AddScoped<INavProvider, HttpNavProvider>();
builder.Services.AddScoped<NavHubClient>();

await builder.Build().RunAsync();
