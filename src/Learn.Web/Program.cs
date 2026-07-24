using Diginsight;
using Diginsight.AspNetCore;
using Diginsight.Components;
using Diginsight.Components.Configuration;
using Diginsight.Diagnostics;
using Diginsight.SmartCache;
using Diginsight.SmartCache.Externalization.Http;
using Diginsight.SmartCache.Externalization.Redis;
using Diginsight.SmartCache.Externalization.ServiceBus;
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
    private static readonly string SmartCacheServiceBusSubscriptionName = Guid.NewGuid().ToString("N");

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

            // SmartCache over the content source (Diginsight convention). Core options bind from
            // Diginsight:SmartCache (MaxAge / AbsoluteExpiration / SlidingExpiration + class-aware
            // overrides like MaxAge@CachedContentSource). Always on; distributed sync is opt-in:
            //   • Diginsight:SmartCache:ServiceBus (ConnectionString + TopicName) → Service Bus companion
            //   • Diginsight:SmartCache:Redis:Configuration → Redis passive backing store
            services.ConfigureClassAware<SmartCacheCoreOptions>(configuration.GetSection("Diginsight:SmartCache"));

            SmartCacheBuilder smartCacheBuilder = services
                .AddSmartCache(configuration, environment, observabilityManager.LoggerFactory)
                .AddHttp();

            // Distributed cross-instance invalidation via Service Bus is opt-in: only wire the Service
            // Bus companion when it is actually configured. Otherwise AddSmartCache's default
            // (single-instance, in-process) companion is kept — required for the DI container to
            // resolve ICacheCompanion when running standalone (e.g. local dev, no Service Bus).
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

            services.AddSingleton<IContentSource>(sp => new CachedContentSource(
                CreatePhysicalContentSource(sp),
                sp.GetRequiredService<ISmartCache>(),
                sp.GetRequiredService<ILogger<CachedContentSource>>()));

            services.AddScoped<IMarkdownRenderer, MarkdigMarkdownRenderer>();
            services.AddScoped<PageLoader>();
            services.AddScoped<TocState>();
            services.AddScoped<ThemeState>();
            services.AddScoped<SidebarState>();
            services.AddScoped<NavStats>();
            // Dynamic, spec-compliant menu built on demand from the live content hierarchy.
            services.AddMemoryCache();
            services.AddSingleton<IContentLister>(sp => (IContentLister)sp.GetRequiredService<IContentSource>());
            services.AddSingleton<DynamicNavBuilder>();
            services.AddSingleton<CachedDynamicNavBuilder>(sp => new CachedDynamicNavBuilder(
                sp.GetRequiredService<DynamicNavBuilder>(),
                sp.GetRequiredService<ISmartCache>(),
                sp.GetRequiredService<ILogger<CachedDynamicNavBuilder>>()));
            services.AddSingleton<INavBuilder>(sp => sp.GetRequiredService<CachedDynamicNavBuilder>());
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

        // Warm the navigation index and every per-level cache entry in the background so the first
        // request (and expand-all) does not pay cold origin fetches on the request path.
        _ = Task.Run(async () =>
        {
            try
            {
                var cachedNav = app.Services.GetRequiredService<CachedDynamicNavBuilder>();
                await cachedNav.GetIndexAsync();
                // The walk above filled the recursive per-folder counts. Any level a client requested
                // while it was still running got cached with null counts, so drop those levels before
                // (re)warming them so they rebuild with the computed counts.
                cachedNav.InvalidateLevels();
                await cachedNav.WarmAllLevelsAsync();
            }
            catch { /* best-effort warm-up */ }
        });

        app.Run();
    }
}
