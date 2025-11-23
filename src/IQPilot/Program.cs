using Diginsight.Diagnostics;
//using Diginsight.Tools.IQPilot;
using Diginsight.Tools.IQPilot.Server;
using Diginsight.Tools.IQPilot.Services;
using Diginsight.Tools.IQPilot.Tools;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using StreamJsonRpc;
using System.Reflection.PortableExecutable;
using ILogger = Microsoft.Extensions.Logging.ILogger;

namespace Diginsight.Tools.IQPilot;

class Program
{
    static async Task Main(string[] args)
    {
        AppContext.SetSwitch("Azure.Experimental.EnableActivitySource", true);

        using var observabilityManager = new ObservabilityManager();
        ILogger logger = observabilityManager.LoggerFactory.CreateLogger(typeof(Program));
        ObservabilityRegistry.RegisterLoggerFactory(observabilityManager.LoggerFactory);

        using var activity = Observability.ActivitySource.StartMethodActivity(logger);

        var workspaceFolder = args.Length > 0 ? args[0]
            : Environment.GetEnvironmentVariable("IQPILOT_WORKSPACE")
            ?? Directory.GetCurrentDirectory();

        // Setup Serilog
        //var logPath = Path.Combine(workspaceFolder, ".iqpilot", "logs", "iqpilot.log");
        //Directory.CreateDirectory(Path.GetDirectoryName(logPath)!);
        //logger.LogLogger = new LoggerConfiguration()
        //             .MinimumLevel.Debug()
        //             .WriteTo.File(logPath, rollingInterval: RollingInterval.Day)
        //             .CreateLogger();

        try
        {
            logger.LogInformation("IQPilot MCP Server starting");
            logger.LogInformation("Workspace: {Workspace}", workspaceFolder);

            // Load configuration
            var configPath = Path.Combine(workspaceFolder, ".iqpilot", "config.json");
            logger.LogInformation("Loading configuration from: {ConfigPath}", configPath);

            // Build host
            var builder = Host.CreateDefaultBuilder(args)
                //.UseSerilog()
                .ConfigureServices((context, services) =>
                {
                    IHostEnvironment hostEnvironment = context.HostingEnvironment;
                    IConfiguration configuration = context.Configuration;
                    services.AddObservability(configuration, hostEnvironment);
                    observabilityManager.AttachTo(services);
                    services.TryAddSingleton<IActivityLoggingSampler, NameBasedActivityLoggingSampler>();

                    // Core services
                    services.AddSingleton<MetadataManager>();
                    services.AddSingleton<ValidationEngine>();
                    services.AddSingleton<TemplateService>(sp =>
                    {
                        var logger = sp.GetRequiredService<ILogger<TemplateService>>();
                        var templatesPath = Path.Combine(workspaceFolder, ".github", "templates");
                        return new TemplateService(logger, templatesPath);
                    });
                    services.AddSingleton<EventCoordinator>();

                    // Tool handlers
                    services.AddSingleton<MetadataTools>();
                    services.AddSingleton<ValidationTools>();
                    services.AddSingleton<ContentTools>();
                    services.AddSingleton<WorkflowTools>();

                    // Tool registry
                    services.AddSingleton<ToolRegistry>();

                    // MCP Server
                    services.AddSingleton<IQPilotMcpServer>();

                    // Background services
                    services.AddHostedService(sp =>
                    {
                        var logger = sp.GetRequiredService<ILogger<FileWatcherService>>();
                        var metadataManager = sp.GetRequiredService<MetadataManager>();
                        var eventCoordinator = sp.GetRequiredService<EventCoordinator>();
                        return new FileWatcherService(logger, metadataManager, eventCoordinator, workspaceFolder);
                    });
                }).UseDiginsightServiceProvider(true);

            var host = builder.Build();

            // Start background services
            await host.StartAsync();

            // Create MCP server
            var mcpServer = host.Services.GetRequiredService<IQPilotMcpServer>();

            // Setup JSON-RPC over stdio
            using var jsonRpc = new JsonRpc(Console.OpenStandardInput(), Console.OpenStandardOutput(), mcpServer);
            jsonRpc.StartListening();

            logger.LogInformation("MCP Server listening on stdio");

            // Wait for shutdown
            var cts = new CancellationTokenSource();
            Console.CancelKeyPress += (sender, e) =>
            {
                e.Cancel = true;
                cts.Cancel();
            };

            await Task.Delay(-1, cts.Token);

            // Shutdown
            await host.StopAsync();
            logger.LogInformation("IQPilot MCP Server stopped");
        }
        catch (OperationCanceledException)
        {
            logger.LogInformation("Shutdown requested");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Fatal error");
        }
        finally
        {
            //await logger.LogCloseAndFlushAsync();
        }
    }
}

