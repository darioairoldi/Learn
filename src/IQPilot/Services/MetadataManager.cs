using Microsoft.Extensions.Logging;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using System.Text.RegularExpressions;
using Diginsight.Diagnostics;
using System.Diagnostics;

namespace Diginsight.Tools.IQPilot.Services;

/// <summary>
/// Manages article metadata in HTML comment YAML blocks
/// </summary>
public class MetadataManager
{
    private readonly ILogger<MetadataManager> _logger;
    private readonly IDeserializer _yamlDeserializer;
    private readonly ISerializer _yamlSerializer;

    // Regex to extract YAML from HTML comment: <!-- \n---\nYAML\n---\n-->
    private static readonly Regex MetadataRegex = new(
        @"<!--\s*\r?\n---\s*\r?\n(.*?)\r?\n---\s*\r?\n-->",
        RegexOptions.Singleline | RegexOptions.Compiled);

    public MetadataManager(ILogger<MetadataManager> logger)
    {
        _logger = logger;
        _yamlDeserializer = new DeserializerBuilder()
            .WithNamingConvention(UnderscoredNamingConvention.Instance)
            .Build();
        _yamlSerializer = new SerializerBuilder()
            .WithNamingConvention(UnderscoredNamingConvention.Instance)
            .Build();
    }

    /// <summary>
    /// Get metadata from article file
    /// </summary>
    public async Task<Dictionary<string, object>> GetMetadataAsync(string filePath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        if (!File.Exists(filePath))
        {
            throw new FileNotFoundException($"Article not found: {filePath}");
        }

        var content = await File.ReadAllTextAsync(filePath);
        var match = MetadataRegex.Match(content);

        if (!match.Success)
        {
            _logger.LogWarning($"No metadata block found in {filePath}");
            var emptyResult = new Dictionary<string, object>();
            activity?.SetOutput(emptyResult);
            return emptyResult;
        }

        var yamlContent = match.Groups[1].Value;

        Dictionary<string, object> result;
        try
        {
            var metadata = _yamlDeserializer.Deserialize<Dictionary<string, object>>(yamlContent);
            result = metadata ?? new Dictionary<string, object>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Failed to parse metadata in {filePath}");
            throw new InvalidOperationException($"Invalid metadata YAML in {filePath}", ex);
        }

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Update specific metadata fields
    /// </summary>
    public async Task UpdateMetadataAsync(string filePath, Dictionary<string, object> updates)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        if (!File.Exists(filePath))
        {
            throw new FileNotFoundException($"Article not found: {filePath}");
        }

        var content = await File.ReadAllTextAsync(filePath);
        var match = MetadataRegex.Match(content);

        Dictionary<string, object> metadata;

        if (match.Success)
        {
            // Parse existing metadata
            var yamlContent = match.Groups[1].Value;
            metadata = _yamlDeserializer.Deserialize<Dictionary<string, object>>(yamlContent)
                       ?? new Dictionary<string, object>();
        }
        else
        {
            // No existing metadata, create new
            metadata = new Dictionary<string, object>();
        }

        // Apply updates
        foreach (var kvp in updates)
        {
            metadata[kvp.Key] = kvp.Value;
        }

        // Update last_updated timestamp
        if (metadata.ContainsKey("article_metadata") && metadata["article_metadata"] is Dictionary<object, object> articleMeta)
        {
            articleMeta["last_updated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ");
        }

        // Serialize back to YAML
        var newYamlContent = _yamlSerializer.Serialize(metadata);
        var newMetadataBlock = $"<!-- \n---\n{newYamlContent}---\n-->";

        string newContent;
        if (match.Success)
        {
            // Replace existing metadata block
            newContent = content.Remove(match.Index, match.Length);
            newContent = newContent.Insert(match.Index, newMetadataBlock);
        }
        else
        {
            // Append metadata block at end
            newContent = content.TrimEnd() + "\n\n" + newMetadataBlock + "\n";
        }

        await File.WriteAllTextAsync(filePath, newContent);
        _logger.LogInformation($"Updated metadata in {filePath}");
    }

    /// <summary>
    /// Validate metadata structure
    /// </summary>
    public async Task<(bool IsValid, List<string> Errors)> ValidateMetadataAsync(string filePath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        var errors = new List<string>();

        (bool IsValid, List<string> Errors) result;
        try
        {
            var metadata = await GetMetadataAsync(filePath);

            // Check required sections
            if (!metadata.ContainsKey("validations"))
            {
                errors.Add("Missing 'validations' section");
            }

            if (!metadata.ContainsKey("article_metadata"))
            {
                errors.Add("Missing 'article_metadata' section");
            }

            // Validate article_metadata structure
            if (metadata.ContainsKey("article_metadata") && metadata["article_metadata"] is Dictionary<object, object> articleMeta)
            {
                if (!articleMeta.ContainsKey("filename"))
                {
                    errors.Add("Missing 'article_metadata.filename'");
                }

                if (!articleMeta.ContainsKey("last_updated"))
                {
                    errors.Add("Missing 'article_metadata.last_updated'");
                }
            }

            // Validate validations structure
            if (metadata.ContainsKey("validations") && metadata["validations"] is Dictionary<object, object> validations)
            {
                foreach (var validationType in new[] { "grammar", "readability", "structure" })
                {
                    if (validations.ContainsKey(validationType) && validations[validationType] is Dictionary<object, object> validation)
                    {
                        if (!validation.ContainsKey("last_validated"))
                        {
                            errors.Add($"Missing 'validations.{validationType}.last_validated'");
                        }

                        if (!validation.ContainsKey("status"))
                        {
                            errors.Add($"Missing 'validations.{validationType}.status'");
                        }
                    }
                }
            }

            result = (errors.Count == 0, errors);
        }
        catch (Exception ex)
        {
            errors.Add($"Validation error: {ex.Message}");
            result = (false, errors);
        }

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Initialize metadata for a new article
    /// </summary>
    public async Task InitializeMetadataAsync(string filePath, string title, string author)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, title, author });

        var metadata = new Dictionary<string, object>
        {
            ["validations"] = new Dictionary<string, object>
            {
                ["grammar"] = new Dictionary<string, object>
                {
                    ["last_validated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                    ["status"] = "not_validated",
                    ["model"] = "",
                    ["issues_found"] = 0
                },
                ["readability"] = new Dictionary<string, object>
                {
                    ["last_validated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                    ["status"] = "not_validated",
                    ["flesch_score"] = 0,
                    ["grade_level"] = 0
                },
                ["structure"] = new Dictionary<string, object>
                {
                    ["last_validated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                    ["status"] = "not_validated",
                    ["has_toc"] = false,
                    ["has_references"] = false
                }
            },
            ["article_metadata"] = new Dictionary<string, object>
            {
                ["filename"] = Path.GetFileName(filePath),
                ["created_date"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                ["last_updated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                ["word_count"] = 0,
                ["estimated_reading_time"] = "0 min"
            },
            ["cross_references"] = new Dictionary<string, object>
            {
                ["related_articles"] = new List<string>(),
                ["topics"] = new List<string>()
            }
        };

        await UpdateMetadataAsync(filePath, metadata);
    }

    /// <summary>
    /// Update validation results in metadata
    /// </summary>
    public async Task UpdateValidationResultAsync(
        string filePath,
        string validationType,
        bool passed,
        Dictionary<string, object> details)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, validationType, passed });

        var metadata = await GetMetadataAsync(filePath);

        if (!metadata.ContainsKey("validations"))
        {
            metadata["validations"] = new Dictionary<string, object>();
        }

        var validations = metadata["validations"] as Dictionary<object, object>
                          ?? new Dictionary<object, object>();

        var validationData = new Dictionary<string, object>
        {
            ["last_validated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
            ["status"] = passed ? "passed" : "failed"
        };

        // Merge in additional details
        foreach (var kvp in details)
        {
            validationData[kvp.Key] = kvp.Value;
        }

        validations[validationType] = validationData;
        metadata["validations"] = validations;

        await UpdateMetadataAsync(filePath, metadata);
    }
}
