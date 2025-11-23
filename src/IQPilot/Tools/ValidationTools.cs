using Microsoft.Extensions.Logging;
using Diginsight.Tools.IQPilot.Server;
using Diginsight.Tools.IQPilot.Services;
using System.Text.Json;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Tools;

/// <summary>
/// MCP Tools for content validation
/// </summary>
public class ValidationTools : IToolHandler
{
    private readonly ValidationEngine _validationEngine;
    private readonly ILogger<ValidationTools> _logger;

    public ValidationTools(ValidationEngine validationEngine, ILogger<ValidationTools> logger)
    {
        _validationEngine = validationEngine;
        _logger = logger;
    }

    public IEnumerable<ToolDefinition> GetTools()
    {
        return new[]
        {
            new ToolDefinition
            {
                Name = "iqpilot/validate/grammar",
                Description = "Check grammar, spelling, and punctuation",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Absolute path to article file" },
                        content = new { type = "string", description = "Article content (optional, will read from file if not provided)" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/validate/readability",
                Description = "Analyze readability (Flesch score, grade level)",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string" },
                        content = new { type = "string" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/validate/structure",
                Description = "Validate article structure (TOC, sections, references)",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/validate/all",
                Description = "Run all validations on an article",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string" }
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
            "iqpilot/validate/grammar" => await ValidateGrammarAsync(arguments),
            "iqpilot/validate/readability" => await ValidateReadabilityAsync(arguments),
            "iqpilot/validate/structure" => await ValidateStructureAsync(arguments),
            "iqpilot/validate/all" => await ValidateAllAsync(arguments),
            _ => throw new InvalidOperationException($"Unknown tool: {toolName}")
        };
    }

    private async Task<string> ValidateGrammarAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var content = arguments.ContainsKey("content")
                ? arguments["content"].ToString()
                : await File.ReadAllTextAsync(filePath);

            var validationResult = await _validationEngine.ValidateGrammarAsync(filePath, content!);

            result = JsonSerializer.Serialize(validationResult, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while validating grammar for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> ValidateReadabilityAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var content = arguments.ContainsKey("content")
                ? arguments["content"].ToString()
                : await File.ReadAllTextAsync(filePath);

            var validationResult = await _validationEngine.ValidateReadabilityAsync(filePath, content!);

            result = JsonSerializer.Serialize(validationResult, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while validating readability for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> ValidateStructureAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var validationResult = await _validationEngine.ValidateStructureAsync(filePath);

            result = JsonSerializer.Serialize(validationResult, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while validating structure for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> ValidateAllAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var validationResults = await _validationEngine.ValidateAllAsync(filePath);

            result = JsonSerializer.Serialize(validationResults, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while running all validations for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }
}
