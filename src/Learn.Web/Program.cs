using Diginsight;
using Diginsight.AspNetCore;
using Diginsight.Components;
using Diginsight.Components.Configuration;
using Diginsight.Diagnostics;
using Diginsight.SmartCache;
using Diginsight.SmartCache.Externalization.Redis;
using Learn.Web.Components;
using Learn.Web.ContentSources;
using Learn.Web.Endpoints;
using Learn.Web.Navigation;
using Learn.Web.Shared;
using Learn.Web.Shared.Navigation;
using Learn.Web.Shared.Rendering;
using Learn.Web.Shared.Services;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Options;

namespace Learn.Web;

public class Program
{
    public static void Main(string[] args)
    {
        // Diginsight early logging (console + log4net to %USERPROFILE%\LogFiles\Diginsight\Learn.Web.<date>.log).
        using var observabilityManager = new ObservabilityManager();
        ILogger logger = observabilityManager.LoggerFactory.CreateLogger(typeof(Program));

        WebApplication app;
        using (var activity = Observability.ActivitySource.StartMethodActivity(logger, new { args }))
        {
            var builder = WebApplication.CreateBuilder(args);

            // Merge external/environment configuration (e.g. the Testmc overlay from the sibling
            // Learn.internal repo, selected via AppsettingsEnvironmentName + ExternalConfigurationFolder).
            builder.Host.ConfigureAppConfiguration2(observabilityManager.LoggerFactory);

            IServiceCollection services = builder.Services;
            IConfiguration configuration = builder.Configuration;
            IWebHostEnvironment environment = builder.Environment;

            // Diginsight telemetry integrated with OpenTelemetry (+ log4net file logging).
            services.AddAspNetCoreObservability(configuration, environment, out IOpenTelemetryOptions openTelemetryOptions);
            observabilityManager.AttachTo(services);
            services.AddHttpObservability(openTelemetryOptions);

            services.TryAddSingleton<EarlyLoggingManager>(observabilityManager);
            services.AddHttpContextAccessor();
            services.AddDynamicLogLevel<DefaultDynamicLogLevelInjector>();

            // Razor Components host with interactive WebAssembly components (prerendered by default).
            services.AddRazorComponents()
                .AddInteractiveWebAssemblyComponents();

            services.Configure<ContentOptions>(configuration.GetSection("Content"));

            // Physical server-side content source: FileSystem (repo clone) or Blob (storage), selected by config.
            static IContentSource CreatePhysicalContentSource(IServiceProvider sp)
            {
                ContentOptions options = sp.GetRequiredService<IOptions<ContentOptions>>().Value;
                IWebHostEnvironment env = sp.GetRequiredService<IWebHostEnvironment>();

                if (string.Equals(options.Source, "FileSystem", StringComparison.OrdinalIgnoreCase))
                {
                    string root = Path.GetFullPath(Path.Combine(env.ContentRootPath, options.FileSystem.RootPath));
                    return new FileSystemContentSource(root,
                        sp.GetRequiredService<ILogger<FileSystemContentSource>>());
                }

                return new BlobContentSource(options.Blob.AccountUri, options.Blob.ContainerName,
                    sp.GetRequiredService<ILogger<BlobContentSource>>());
            }

            // Optional SmartCache layer over the content source (off by default; config-gated).
            // Enabled → caches Markdown source bytes in-memory; a Redis connection string adds a
            // distributed, multi-instance backing store. When disabled, behavior is unchanged.
            ContentOptions contentOptions = configuration.GetSection("Content").Get<ContentOptions>() ?? new ContentOptions();
            if (contentOptions.Cache.Enabled)
            {
                SmartCacheBuilder smartCacheBuilder =
                    services.AddSmartCache(configuration, environment, observabilityManager.LoggerFactory);

                if (!string.IsNullOrWhiteSpace(contentOptions.Cache.Redis.Configuration))
                {
                    smartCacheBuilder.AddRedis(o =>
                    {
                        o.Configuration = contentOptions.Cache.Redis.Configuration;
                        o.KeyPrefix = contentOptions.Cache.Redis.KeyPrefix;
                    });
                }

                services.AddSingleton<IContentSource>(sp => new SmartCacheContentSource(
                    CreatePhysicalContentSource(sp),
                    sp.GetRequiredService<ISmartCache>(),
                    sp.GetRequiredService<ICacheKeyService>(),
                    TimeSpan.FromSeconds(contentOptions.Cache.MaxAgeSeconds),
                    sp.GetRequiredService<ILogger<SmartCacheContentSource>>()));
            }
            else
            {
                services.AddSingleton<IContentSource>(CreatePhysicalContentSource);
            }

            services.AddScoped<IMarkdownRenderer, MarkdigMarkdownRenderer>();
            services.AddScoped<PageLoader>();
            services.AddScoped<TocState>();
            services.AddScoped<ThemeState>();
            services.AddScoped<SidebarState>();
            // Dynamic, spec-compliant menu built on demand from the live content hierarchy.
            services.AddMemoryCache();
            services.AddSingleton<IContentLister>(sp => (IContentLister)sp.GetRequiredService<IContentSource>());
            services.AddSingleton<DynamicNavBuilder>();
            services.AddScoped<INavProvider, ServerNavProvider>();

            builder.UseDiginsightServiceProvider(true);

            app = builder.Build();
            logger.LogDebug("Host built");

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

            // Content passthrough + dynamic navigation APIs (see the *Endpoints classes).
            app.MapContentEndpoints();
            app.MapNavEndpoints();

            app.MapRazorComponents<App>()
                .AddInteractiveWebAssemblyRenderMode()
                .AddAdditionalAssemblies(typeof(Learn.Web.Client.Marker).Assembly);
        }

        // Warm the navigation index in the background so the first request (and the breadcrumb /
        // prev-next it feeds) does not pay the full tree walk on the request path.
        _ = Task.Run(async () =>
        {
            try { await app.Services.GetRequiredService<DynamicNavBuilder>().GetIndexAsync(); }
            catch { /* best-effort warm-up */ }
        });

        app.Run();
    }
}
