using Microsoft.Extensions.Logging;
using StreamJsonRpc;
using System.Diagnostics;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Server;

/// <summary>
/// MCP (Model Context Protocol) Server for IQPilot
/// Provides tools for content validation, metadata management, and workflow orchestration
/// </summary>
public class IQPilotMcpServer : IDisposable
{
    private readonly ILogger<IQPilotMcpServer> _logger;
    private readonly JsonRpc _rpc;
    private readonly ToolRegistry _toolRegistry;
    private bool _isInitialized;

    public IQPilotMcpServer(
        Stream inputStream,
        Stream outputStream,
        ToolRegistry toolRegistry,
        ILogger<IQPilotMcpServer> logger)
    {
        _logger = logger;
        _toolRegistry = toolRegistry;

        // Create JSON-RPC connection
        _rpc = new JsonRpc(outputStream, inputStream, this)
        {
            SynchronizationContext = null
        };

        _rpc.StartListening();
        _logger.LogInformation("IQPilot MCP Server started");
    }

    /// <summary>
    /// MCP Protocol: Initialize
    /// Called when client connects to server
    /// </summary>
    [JsonRpcMethod("initialize")]
    public async Task<InitializeResult> InitializeAsync(InitializeParams parameters)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            clientName = parameters.ClientInfo?.Name, 
            clientVersion = parameters.ClientInfo?.Version 
        });

        _logger.LogInformation("Initializing IQPilot MCP Server v{Version}", "1.0.0");
        _logger.LogInformation("Client: {ClientName} v{ClientVersion}",
            parameters.ClientInfo?.Name,
            parameters.ClientInfo?.Version);

        _isInitialized = true;

        var result = await Task.FromResult(new InitializeResult
        {
            ProtocolVersion = "2024-11-05",
            ServerInfo = new ServerInfo
            {
                Name = "iqpilot",
                Version = "1.0.0"
            },
            Capabilities = new ServerCapabilities
            {
                Tools = new ToolsCapability
                {
                    ListChanged = false
                }
            }
        });

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// MCP Protocol: List available tools
    /// </summary>
    [JsonRpcMethod("tools/list")]
    public async Task<ToolsListResult> ListToolsAsync()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { });

        _logger.LogDebug("Listing available tools");

        var tools = _toolRegistry.GetAllTools()
            .Select(t => new ToolInfo
            {
                Name = t.Name,
                Description = t.Description,
                InputSchema = t.InputSchema
            })
            .ToArray();

        var result = await Task.FromResult(new ToolsListResult
        {
            Tools = tools
        });

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// MCP Protocol: Call a tool
    /// </summary>
    [JsonRpcMethod("tools/call")]
    public async Task<ToolCallResult> CallToolAsync(ToolCallRequest request)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { toolName = request.Name });

        _logger.LogInformation("Tool call: {ToolName}", request.Name);

        ToolCallResult result;
        try
        {
            var toolResult = await _toolRegistry.ExecuteToolAsync(request.Name, request.Arguments);

            result = new ToolCallResult
            {
                Content = new[]
                {
                    new ToolContent
                    {
                        Type = "text",
                        Text = toolResult
                    }
                },
                IsError = false
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error executing tool: {ToolName}", request.Name);

            result = new ToolCallResult
            {
                Content = new[]
                {
                    new ToolContent
                    {
                        Type = "text",
                        Text = $"Error: {ex.Message}"
                    }
                },
                IsError = true
            };
        }

        activity?.SetOutput(result);
        return result;
    }

    public void Dispose()
    {
        _logger.LogInformation("Shutting down IQPilot MCP Server");
        _rpc?.Dispose();
    }
}

// MCP Protocol Types
public class InitializeParams
{
    public string? ProtocolVersion { get; set; }
    public ClientInfo? ClientInfo { get; set; }
}

public class ClientInfo
{
    public string? Name { get; set; }
    public string? Version { get; set; }
}

public class InitializeResult
{
    public string? ProtocolVersion { get; set; }
    public ServerInfo? ServerInfo { get; set; }
    public ServerCapabilities? Capabilities { get; set; }
}

public class ServerInfo
{
    public string? Name { get; set; }
    public string? Version { get; set; }
}

public class ServerCapabilities
{
    public ToolsCapability? Tools { get; set; }
}

public class ToolsCapability
{
    public bool ListChanged { get; set; }
}

public class ToolsListResult
{
    public ToolInfo[]? Tools { get; set; }
}

public class ToolInfo
{
    public string? Name { get; set; }
    public string? Description { get; set; }
    public object? InputSchema { get; set; }
}

public class ToolCallRequest
{
    public string Name { get; set; } = string.Empty;
    public Dictionary<string, object>? Arguments { get; set; }
}

public class ToolCallResult
{
    public ToolContent[]? Content { get; set; }
    public bool IsError { get; set; }
}

public class ToolContent
{
    public string Type { get; set; } = "text";
    public string Text { get; set; } = string.Empty;
}
