using Microsoft.Extensions.Logging;
using Diginsight.Tools.IQPilot.Server;
using Diginsight.Tools.IQPilot.Services;
using System.Text.Json;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Tools;

/// <summary>
/// MCP Tools for content creation and analysis
/// </summary>
public class ContentTools : IToolHandler
{
    private readonly TemplateService _templateService;
    private readonly ValidationEngine _validationEngine;
    private readonly MetadataManager _metadataManager;
    private readonly ILogger<ContentTools> _logger;

    public ContentTools(
        TemplateService templateService,
        ValidationEngine validationEngine,
        MetadataManager metadataManager,
        ILogger<ContentTools> logger)
    {
        _templateService = templateService;
        _validationEngine = validationEngine;
        _metadataManager = metadataManager;
        _logger = logger;
    }

    public IEnumerable<ToolDefinition> GetTools()
    {
        return new[]
        {
            new ToolDefinition
            {
                Name = "iqpilot/content/create",
                Description = "Create a new article from template",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        templateName = new { type = "string", description = "Template name (article, howto, tutorial, etc.)" },
                        title = new { type = "string", description = "Article title" },
                        author = new { type = "string", description = "Author name" },
                        outputPath = new { type = "string", description = "Output file path" },
                        variables = new { type = "object", description = "Additional template variables (optional)" }
                    },
                    required = new[] { "templateName", "title", "author", "outputPath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/content/analyze_gaps",
                Description = "Identify missing information or logical gaps",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Path to article file" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/content/find_related",
                Description = "Find related articles and topics",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Path to article file" },
                        repositoryPath = new { type = "string", description = "Repository root path (optional)" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/content/publish_ready",
                Description = "Check if article is ready for publication",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Path to article file" }
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
            "iqpilot/content/create" => await CreateArticleAsync(arguments),
            "iqpilot/content/analyze_gaps" => await AnalyzeGapsAsync(arguments),
            "iqpilot/content/find_related" => await FindRelatedAsync(arguments),
            "iqpilot/content/publish_ready" => await CheckPublishReadyAsync(arguments),
            _ => throw new InvalidOperationException($"Unknown tool: {toolName}")
        };
    }

    private async Task<string> CreateArticleAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            templateName = arguments["templateName"],
            title = arguments["title"],
            outputPath = arguments["outputPath"]
        });

        var templateName = arguments["templateName"].ToString()!;
        var title = arguments["title"].ToString()!;
        var author = arguments["author"].ToString()!;
        var outputPath = arguments["outputPath"].ToString()!;

        string result;
        try
        {
            var variables = new Dictionary<string, string>
            {
                ["title"] = title,
                ["author"] = author,
                ["date"] = DateTime.Now.ToString("yyyy-MM-dd")
            };

            // Add any custom variables
            if (arguments.ContainsKey("variables") && arguments["variables"] is JsonElement jsonVars)
            {
                foreach (var prop in jsonVars.EnumerateObject())
                {
                    variables[prop.Name] = prop.Value.GetString() ?? "";
                }
            }

            var content = await _templateService.RenderTemplateAsync(templateName, variables);
            await File.WriteAllTextAsync(outputPath, content);

            _logger.LogInformation("Created article: {OutputPath}", outputPath);

            result = JsonSerializer.Serialize(new
            {
                success = true,
                filePath = outputPath,
                message = $"Article created from template '{templateName}'"
            }, new JsonSerializerOptions { WriteIndented = true });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while creating article from template {TemplateName} at {OutputPath}", templateName, outputPath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> AnalyzeGapsAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"]
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var content = await File.ReadAllTextAsync(filePath);

            var gaps = await _validationEngine.AnalyzeGapsAsync(filePath, content);

            result = JsonSerializer.Serialize(gaps, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while analyzing content gaps for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> FindRelatedAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"],
            repositoryPath = arguments.ContainsKey("repositoryPath") ? arguments["repositoryPath"] : null
        });

        var filePath = arguments["filePath"].ToString()!;
        var repositoryPath = arguments.ContainsKey("repositoryPath")
            ? arguments["repositoryPath"].ToString()
            : Path.GetDirectoryName(filePath);

        string result;
        try
        {
            var content = await File.ReadAllTextAsync(filePath);
            var metadata = await _metadataManager.GetMetadataAsync(filePath);

            var related = await _validationEngine.FindRelatedArticlesAsync(
                filePath,
                content,
                metadata,
                repositoryPath!);

            result = JsonSerializer.Serialize(related, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while finding related articles for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> CheckPublishReadyAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"]
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            // Run all validations
            var validations = await _validationEngine.ValidateAllAsync(filePath);

            // Check metadata completeness
            var metadata = await _metadataManager.GetMetadataAsync(filePath);
            var metadataValid = await _metadataManager.ValidateMetadataAsync(filePath);

            var allPassed = validations.All(v => v.Value.Passed) && metadataValid.IsValid;

            var resultObject = new
            {
                ready = allPassed,
                validations = validations,
                metadata = new
                {
                    valid = metadataValid.IsValid,
                    errors = metadataValid.Errors
                },
                checklist = new[]
                {
                    new { item = "Grammar check", passed = validations.ContainsKey("grammar") && validations["grammar"].Passed },
                    new { item = "Readability check", passed = validations.ContainsKey("readability") && validations["readability"].Passed },
                    new { item = "Structure validation", passed = validations.ContainsKey("structure") && validations["structure"].Passed },
                    new { item = "Metadata complete", passed = metadataValid.IsValid }
                }
            };

            result = JsonSerializer.Serialize(resultObject, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while checking publish readiness for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }
}
