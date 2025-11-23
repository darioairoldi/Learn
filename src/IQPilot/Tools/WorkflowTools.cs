using Microsoft.Extensions.Logging;
using Diginsight.Tools.IQPilot.Server;
using Diginsight.Tools.IQPilot.Services;
using System.Text.Json;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Tools;

/// <summary>
/// MCP Tools for workflow orchestration
/// </summary>
public class WorkflowTools : IToolHandler
{
    private readonly TemplateService _templateService;
    private readonly ValidationEngine _validationEngine;
    private readonly MetadataManager _metadataManager;
    private readonly ILogger<WorkflowTools> _logger;

    public WorkflowTools(
        TemplateService templateService,
        ValidationEngine validationEngine,
        MetadataManager metadataManager,
        ILogger<WorkflowTools> logger)
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
                Name = "iqpilot/workflow/article_creation",
                Description = "Guide through article creation workflow",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        templateName = new { type = "string", description = "Template to use" },
                        title = new { type = "string", description = "Article title" },
                        outputPath = new { type = "string", description = "Output file path" }
                    },
                    required = new[] { "templateName", "title", "outputPath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/workflow/review",
                Description = "Guide through article review workflow",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        filePath = new { type = "string", description = "Article to review" }
                    },
                    required = new[] { "filePath" }
                }
            },
            new ToolDefinition
            {
                Name = "iqpilot/workflow/series_planning",
                Description = "Plan article series with related topics",
                InputSchema = new
                {
                    type = "object",
                    properties = new
                    {
                        topic = new { type = "string", description = "Series topic" },
                        repositoryPath = new { type = "string", description = "Repository root path" }
                    },
                    required = new[] { "topic", "repositoryPath" }
                }
            }
        };
    }

    public async Task<string> ExecuteAsync(string toolName, Dictionary<string, object> arguments)
    {
        return toolName switch
        {
            "iqpilot/workflow/article_creation" => await ArticleCreationWorkflowAsync(arguments),
            "iqpilot/workflow/review" => await ReviewWorkflowAsync(arguments),
            "iqpilot/workflow/series_planning" => await SeriesPlanningWorkflowAsync(arguments),
            _ => throw new InvalidOperationException($"Unknown tool: {toolName}")
        };
    }

    private async Task<string> ArticleCreationWorkflowAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            templateName = arguments["templateName"], title = arguments["title"], outputPath = arguments["outputPath"] 
        });

        var templateName = arguments["templateName"].ToString()!;
        var title = arguments["title"].ToString()!;
        var outputPath = arguments["outputPath"].ToString()!;

        string result;
        try
        {
            var workflow = new List<object>();

            // Step 1: Create article from template
            workflow.Add(new
            {
                step = 1,
                action = "create_article",
                status = "in_progress",
                message = $"Creating article from template '{templateName}'"
            });

            var variables = new Dictionary<string, string>
            {
                ["title"] = title,
                ["author"] = "User",
                ["date"] = DateTime.Now.ToString("yyyy-MM-dd")
            };

            var content = await _templateService.RenderTemplateAsync(templateName, variables);
            await File.WriteAllTextAsync(outputPath, content);

            workflow[0] = new
            {
                step = 1,
                action = "create_article",
                status = "completed",
                message = $"Article created: {outputPath}"
            };

            // Step 2: Initial validation
            workflow.Add(new
            {
                step = 2,
                action = "initial_validation",
                status = "pending",
                message = "Ready for initial validation"
            });

            // Step 3: Content development
            workflow.Add(new
            {
                step = 3,
                action = "content_development",
                status = "pending",
                message = "Write article content"
            });

            // Step 4: Review
            workflow.Add(new
            {
                step = 4,
                action = "review",
                status = "pending",
                message = "Review and validate content"
            });

            var resultObject = new
            {
                workflow = workflow,
                nextAction = "Edit the article content, then run 'iqpilot/workflow/review'",
                filePath = outputPath
            };

            result = JsonSerializer.Serialize(resultObject, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while creating article workflow for template {TemplateName} with title {Title}", templateName, title);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> ReviewWorkflowAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            filePath = arguments["filePath"] 
        });

        var filePath = arguments["filePath"].ToString()!;

        string result;
        try
        {
            var workflow = new List<object>();

            // Step 1: Structure validation
            workflow.Add(new
            {
                step = 1,
                action = "validate_structure",
                status = "in_progress"
            });

            var structureResult = await _validationEngine.ValidateStructureAsync(filePath);

            workflow[0] = new
            {
                step = 1,
                action = "validate_structure",
                status = structureResult.Passed ? "completed" : "failed",
                result = structureResult
            };

            // Step 2: Grammar check
            workflow.Add(new
            {
                step = 2,
                action = "validate_grammar",
                status = "in_progress"
            });

            var content = await File.ReadAllTextAsync(filePath);
            var grammarResult = await _validationEngine.ValidateGrammarAsync(filePath, content);

            workflow[1] = new
            {
                step = 2,
                action = "validate_grammar",
                status = grammarResult.Passed ? "completed" : "failed",
                result = grammarResult
            };

            // Step 3: Readability check
            workflow.Add(new
            {
                step = 3,
                action = "validate_readability",
                status = "in_progress"
            });

            var readabilityResult = await _validationEngine.ValidateReadabilityAsync(filePath, content);

            workflow[2] = new
            {
                step = 3,
                action = "validate_readability",
                status = readabilityResult.Passed ? "completed" : "failed",
                result = readabilityResult
            };

            // Step 4: Publish readiness check
            var allPassed = structureResult.Passed && grammarResult.Passed && readabilityResult.Passed;

            workflow.Add(new
            {
                step = 4,
                action = "publish_ready",
                status = allPassed ? "completed" : "failed",
                ready = allPassed
            });

            var resultObject = new
            {
                workflow = workflow,
                publishReady = allPassed,
                nextAction = allPassed
                    ? "Article is ready for publication"
                    : "Fix validation issues before publishing"
            };

            result = JsonSerializer.Serialize(resultObject, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while reviewing article workflow for file {FilePath}", filePath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }

    private async Task<string> SeriesPlanningWorkflowAsync(Dictionary<string, object> arguments)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { 
            topic = arguments["topic"], repositoryPath = arguments["repositoryPath"] 
        });

        var topic = arguments["topic"].ToString()!;
        var repositoryPath = arguments["repositoryPath"].ToString()!;

        string result;
        try
        {
            // Scan repository for related articles
            var articles = Directory.GetFiles(repositoryPath, "*.md", SearchOption.AllDirectories)
                .Where(f => !f.Contains("node_modules") && !f.Contains(".git"));

            var relatedArticles = new List<object>();

            foreach (var article in articles)
            {
                try
                {
                    var content = await File.ReadAllTextAsync(article);
                    var metadata = await _metadataManager.GetMetadataAsync(article);

                    // Simple relevance check (can be enhanced with semantic search)
                    if (content.Contains(topic, StringComparison.OrdinalIgnoreCase))
                    {
                        relatedArticles.Add(new
                        {
                            filePath = article,
                            title = metadata.ContainsKey("title") ? metadata["title"] : Path.GetFileNameWithoutExtension(article),
                            relevance = "high" // Placeholder for semantic similarity score
                        });
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Error processing article {Article}", article);
                }
            }

            var resultObject = new
            {
                topic = topic,
                existingArticles = relatedArticles,
                suggestions = new[]
                {
                    $"{topic} - Introduction",
                    $"{topic} - Getting Started",
                    $"{topic} - Best Practices",
                    $"{topic} - Advanced Techniques"
                },
                nextAction = "Review existing articles and create missing topics"
            };

            result = JsonSerializer.Serialize(resultObject, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while planning series workflow for topic {Topic} in repository {RepositoryPath}", topic, repositoryPath);
            throw;
        }

        activity?.SetOutput(result);
        return result;
    }
}
