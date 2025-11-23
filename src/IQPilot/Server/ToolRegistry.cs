using Microsoft.Extensions.Logging;
using Diginsight.Tools.IQPilot.Tools;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Server;

/// <summary>
/// Registry of all available MCP tools
/// Manages tool discovery, registration, and execution
/// </summary>
public class ToolRegistry
{
    private readonly Dictionary<string, IToolHandler> _tools = new();
    private readonly ILogger<ToolRegistry> _logger;

    public ToolRegistry(
        MetadataTools metadataTools,
        ValidationTools validationTools,
        ContentTools contentTools,
        WorkflowTools workflowTools,
        ILogger<ToolRegistry> logger)
    {
        _logger = logger;

        // Register all tool handlers
        RegisterTool(metadataTools);
        RegisterTool(validationTools);
        RegisterTool(contentTools);
        RegisterTool(workflowTools);

        _logger.LogInformation("Registered {Count} tool handlers", _tools.Count);
    }

    private void RegisterTool(IToolHandler handler)
    {
        foreach (var tool in handler.GetTools())
        {
            _tools[tool.Name] = handler;
            _logger.LogDebug("Registered tool: {ToolName}", tool.Name);
        }
    }

    public IEnumerable<ToolDefinition> GetAllTools()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { });

        var result = _tools.Values
            .SelectMany(handler => handler.GetTools())
            .Distinct();

        activity?.SetOutput(result);
        return result;
    }

    public async Task<string> ExecuteToolAsync(string toolName, Dictionary<string, object>? arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { toolName });

        if (!_tools.TryGetValue(toolName, out var handler))
        {
            throw new InvalidOperationException($"Tool not found: {toolName}");
        }

        _logger.LogInformation("Executing tool: {ToolName}", toolName);
        
        var result = await handler.ExecuteAsync(toolName, arguments ?? new Dictionary<string, object>());
        
        activity?.SetOutput(result);
        return result;
    }
}

/// <summary>
/// Interface for tool handlers
/// Each handler can provide multiple related tools
/// </summary>
public interface IToolHandler
{
    IEnumerable<ToolDefinition> GetTools();
    Task<string> ExecuteAsync(string toolName, Dictionary<string, object> arguments);
}

/// <summary>
/// Tool definition with name, description, and JSON schema
/// </summary>
public class ToolDefinition
{
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public object InputSchema { get; set; } = new { };

    public override bool Equals(object? obj)
    {
        return obj is ToolDefinition other && Name == other.Name;
    }

    public override int GetHashCode()
    {
        return Name.GetHashCode();
    }
}
