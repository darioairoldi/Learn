using Diginsight;
using Diginsight.AspNetCore;
using Diginsight.Components;
using Diginsight.Components.Configuration;
using Diginsight.Diagnostics;
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

            // Server-side content source: FileSystem (repo clone) or Blob (storage), selected by config.
            services.AddSingleton<IContentSource>(sp =>
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
            });

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

        app.Run();
    }
}
