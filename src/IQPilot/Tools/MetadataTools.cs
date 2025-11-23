using Microsoft.Extensions.Logging;
using Diginsight.Tools.IQPilot.Server;
using Diginsight.Tools.IQPilot.Services;
using System.Text.Json;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Tools;

/// <summary>
/// MCP Tools for metadata operations
/// </summary>
public class MetadataTools : IToolHandler
{
    private readonly MetadataManager _metadataManager;
    private readonly ILogger<MetadataTools> _logger;

    public MetadataTools(MetadataManager metadataManager, ILogger<MetadataTools> logger)
    {
        _metadataManager = metadataManager;
        _logger = logger;
    }

    public IEnumerable<ToolDefinition> GetTools()
    {
        return new[]
        {
            new ToolDefinition
            {
                Name = "iqpilot/metadata/get",
                Description = "Get metadata from an article file",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Absolute path to article file" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/metadata/update",
                Description = "Update metadata fields in an article",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Absolute path to article file" },
                        updates = new { type = "object", description = "Metadata updates as key-value pairs" }
                    },
                    required = new[] { "filePath", "updates" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/metadata/validate",
                Description = "Validate metadata structure in an article",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Absolute path to article file" }
                    },
                    required = new[] { "filePath" }
                }
            }
        };
    }

    public async Task<string> ExecuteAsync(string toolName, Dictionary<string, object> arguments)
    {
        return toolName switch
        {
            "iqpilot/metadata/get" => await GetMetadataAsync(arguments),
            "iqpilot/metadata/update" => await UpdateMetadataAsync(arguments),
            "iqpilot/metadata/validate" => await ValidateMetadataAsync(arguments),
            _ => throw new InvalidOperationException($"Unknown tool: {toolName}")
        };
    }

    private async Task<string> GetMetadataAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var metadata = await _metadataManager.GetMetadataAsync(filePath);

            result = JsonSerializer.Serialize(metadata, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while getting metadata for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> UpdateMetadataAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;
        var updatesElement = (JsonElement)arguments["updates"];

        string result;
        try
        {
            // Convert JsonElement to Dictionary<string, object>
            var updates = JsonSerializer.Deserialize<Dictionary<string, object>>(updatesElement.GetRawText())
                          ?? new Dictionary<string, object>();

            await _metadataManager.UpdateMetadataAsync(filePath, updates);

            result = $"✓ Metadata updated successfully in {Path.GetFileName(filePath)}";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while updating metadata for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> ValidateMetadataAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var (isValid, errors) = await _metadataManager.ValidateMetadataAsync(filePath);

            if (isValid)
            {
                result = $"✓ Metadata structure is valid in {Path.GetFileName(filePath)}";
            }
            else
            {
                result = JsonSerializer.Serialize(new
                {
                    valid = false,
                    errors = errors,
                    message = $"✗ Metadata structure is invalid in {Path.GetFileName(filePath)}"
                }, new JsonSerializerOptions { WriteIndented = true });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while validating metadata for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }
}
