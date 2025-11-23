using Microsoft.Extensions.Logging;
using System.Text.RegularExpressions;
using Diginsight.Diagnostics;
using System.Diagnostics;

namespace Diginsight.Tools.IQPilot.Services;

/// <summary>
/// Executes validation logic for articles
/// </summary>
public class ValidationEngine
{
    private readonly MetadataManager _metadataManager;
    private readonly ILogger<ValidationEngine> _logger;

    public ValidationEngine(MetadataManager metadataManager, ILogger<ValidationEngine> logger)
    {
        _metadataManager = metadataManager;
        _logger = logger;
    }

    /// <summary>
    /// Validate grammar and spelling
    /// </summary>
    public async Task<ValidationResult> ValidateGrammarAsync(string filePath, string content)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        _logger.LogInformation($"Validating grammar for {filePath}");

        // Basic grammar checks (placeholder for AI model integration)
        var issues = new List<string>();

        // Check for common grammar issues
        if (Regex.IsMatch(content, @"\b(it's)\s+(own|your|their)\b", RegexOptions.IgnoreCase))
        {
            issues.Add("Potential incorrect use of 'it's' (possessive should be 'its')");
        }

        if (Regex.IsMatch(content, @"\b(their|they're|there)\b.*\b(their|they're|there)\b", RegexOptions.IgnoreCase))
        {
            issues.Add("Check usage of their/they're/there");
        }

        // Check for repeated words
        var repeatedWords = Regex.Matches(content, @"\b(\w+)\s+\1\b", RegexOptions.IgnoreCase);
        if (repeatedWords.Count > 0)
        {
            issues.Add($"Found {repeatedWords.Count} repeated word(s)");
        }

        var passed = issues.Count == 0;

        var result = new ValidationResult
        {
            Passed = passed,
            IssuesFound = issues.Count,
            Issues = issues,
            Timestamp = DateTime.UtcNow
        };

        // Update metadata
        await _metadataManager.UpdateValidationResultAsync(
            filePath,
            "grammar",
            passed,
            new Dictionary<string, object>
            {
                ["issues_found"] = issues.Count,
                ["model"] = "basic-regex"
            });

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Validate readability (Flesch score, grade level)
    /// </summary>
    public async Task<ValidationResult> ValidateReadabilityAsync(string filePath, string content)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        _logger.LogInformation($"Validating readability for {filePath}");

        // Calculate readability metrics
        var (fleschScore, gradeLevel) = CalculateReadability(content);

        var passed = fleschScore >= 60 && gradeLevel <= 10; // Configurable thresholds

        var result = new ValidationResult
        {
            Passed = passed,
            Metrics = new Dictionary<string, object>
            {
                ["flesch_score"] = fleschScore,
                ["grade_level"] = gradeLevel,
                ["target_flesch_min"] = 60,
                ["target_grade_max"] = 10
            },
            Timestamp = DateTime.UtcNow
        };

        // Update metadata
        await _metadataManager.UpdateValidationResultAsync(
            filePath,
            "readability",
            passed,
            new Dictionary<string, object>
            {
                ["flesch_score"] = fleschScore,
                ["grade_level"] = gradeLevel
            });

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Validate article structure
    /// </summary>
    public async Task<ValidationResult> ValidateStructureAsync(string filePath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        _logger.LogInformation($"Validating structure for {filePath}");

        var content = await File.ReadAllTextAsync(filePath);
        var issues = new List<string>();

        // Check for TOC
        var hasToc = content.Contains("## Table of Contents", StringComparison.OrdinalIgnoreCase) ||
                     content.Contains("## Contents", StringComparison.OrdinalIgnoreCase);

        if (!hasToc)
        {
            issues.Add("Missing Table of Contents");
        }

        // Check for References section
        var hasReferences = content.Contains("## References", StringComparison.OrdinalIgnoreCase) ||
                            content.Contains("## Sources", StringComparison.OrdinalIgnoreCase);

        if (!hasReferences)
        {
            issues.Add("Missing References section");
        }

        // Check heading hierarchy
        var headings = Regex.Matches(content, @"^(#{1,6})\s+(.+)$", RegexOptions.Multiline);
        var headingLevels = headings.Select(m => m.Groups[1].Value.Length).ToList();

        for (int i = 1; i < headingLevels.Count; i++)
        {
            if (headingLevels[i] > headingLevels[i - 1] + 1)
            {
                issues.Add($"Heading hierarchy skip detected (h{headingLevels[i - 1]} to h{headingLevels[i]})");
                break;
            }
        }

        // Check for introduction
        var hasIntro = Regex.IsMatch(content, @"^##\s+(Introduction|Overview)", RegexOptions.Multiline | RegexOptions.IgnoreCase);
        if (!hasIntro)
        {
            issues.Add("Missing Introduction/Overview section");
        }

        var passed = issues.Count == 0;

        var result = new ValidationResult
        {
            Passed = passed,
            IssuesFound = issues.Count,
            Issues = issues,
            Metrics = new Dictionary<string, object>
            {
                ["has_toc"] = hasToc,
                ["has_references"] = hasReferences,
                ["has_intro"] = hasIntro,
                ["heading_count"] = headings.Count
            },
            Timestamp = DateTime.UtcNow
        };

        // Update metadata
        await _metadataManager.UpdateValidationResultAsync(
            filePath,
            "structure",
            passed,
            new Dictionary<string, object>
            {
                ["has_toc"] = hasToc,
                ["has_references"] = hasReferences,
                ["has_intro"] = hasIntro
            });

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Run all validations
    /// </summary>
    public async Task<Dictionary<string, ValidationResult>> ValidateAllAsync(string filePath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        var content = await File.ReadAllTextAsync(filePath);

        var results = new Dictionary<string, ValidationResult>
        {
            ["grammar"] = await ValidateGrammarAsync(filePath, content),
            ["readability"] = await ValidateReadabilityAsync(filePath, content),
            ["structure"] = await ValidateStructureAsync(filePath)
        };

        activity?.SetOutput(results);
        return results;
    }

    /// <summary>
    /// Analyze content gaps
    /// </summary>
    public async Task<GapAnalysisResult> AnalyzeGapsAsync(string filePath, string content)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath });

        _logger.LogInformation($"Analyzing gaps for {filePath}");

        var gaps = new List<string>();

        // Check for code examples if technical content
        if (Regex.IsMatch(content, @"\b(function|class|method|API|library|framework)\b", RegexOptions.IgnoreCase))
        {
            if (!content.Contains("```"))
            {
                gaps.Add("Technical content without code examples");
            }
        }

        // Check for visual aids
        if (content.Length > 2000 && !Regex.IsMatch(content, @"!\[.*\]\(.*\)"))
        {
            gaps.Add("Long article without images or diagrams");
        }

        // Check for practical examples
        if (!Regex.IsMatch(content, @"##\s+(Example|Demo|Walkthrough|Tutorial)", RegexOptions.IgnoreCase))
        {
            gaps.Add("Missing practical examples section");
        }

        // Check for prerequisites
        if (!Regex.IsMatch(content, @"##\s+(Prerequisites|Requirements|Before)", RegexOptions.IgnoreCase))
        {
            gaps.Add("Missing prerequisites section");
        }

        var result = new GapAnalysisResult
        {
            Gaps = gaps,
            Suggestions = new List<string>
            {
                "Consider adding visual diagrams for complex concepts",
                "Include practical code examples",
                "Add troubleshooting section for common issues"
            }
        };

        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Find related articles
    /// </summary>
    public async Task<List<RelatedArticle>> FindRelatedArticlesAsync(
        string filePath,
        string content,
        Dictionary<string, object> metadata,
        string repositoryPath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, repositoryPath });

        _logger.LogInformation($"Finding related articles for {filePath}");

        var related = new List<RelatedArticle>();

        // Extract keywords from content (simple approach)
        var keywords = ExtractKeywords(content);

        // Scan repository for articles with similar keywords
        var articles = Directory.GetFiles(repositoryPath, "*.md", SearchOption.AllDirectories)
            .Where(f => f != filePath && !f.Contains("node_modules") && !f.Contains(".git"));

        foreach (var article in articles)
        {
            try
            {
                var articleContent = await File.ReadAllTextAsync(article);
                var similarity = CalculateSimilarity(keywords, articleContent);

                if (similarity > 0.3) // Threshold for relevance
                {
                    related.Add(new RelatedArticle
                    {
                        FilePath = article,
                        Title = ExtractTitle(articleContent),
                        Similarity = similarity
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning($"Error processing article {article}: {ex.Message}");
            }
        }

        var result = related.OrderByDescending(r => r.Similarity).Take(5).ToList();

        activity?.SetOutput(result);
        return result;
    }

    // Helper methods

    private (double FleschScore, int GradeLevel) CalculateReadability(string content)
    {
        // Remove markdown and code blocks
        var text = Regex.Replace(content, @"```[\s\S]*?```", "");
        text = Regex.Replace(text, @"[#*`\[\]()]", "");

        var sentences = Regex.Split(text, @"[.!?]+").Where(s => !string.IsNullOrWhiteSpace(s)).Count();
        var words = text.Split(new[] { ' ', '\n', '\r', '\t' }, StringSplitOptions.RemoveEmptyEntries).Length;
        var syllables = CountSyllables(text);

        if (sentences == 0 || words == 0) return (0, 0);

        // Flesch Reading Ease
        var fleschScore = 206.835 - 1.015 * (words / (double)sentences) - 84.6 * (syllables / (double)words);

        // Flesch-Kincaid Grade Level
        var gradeLevel = 0.39 * (words / (double)sentences) + 11.8 * (syllables / (double)words) - 15.59;

        return (Math.Round(fleschScore, 1), (int)Math.Round(gradeLevel));
    }

    private int CountSyllables(string text)
    {
        // Simplified syllable counting
        var words = text.Split(new[] { ' ', '\n', '\r', '\t' }, StringSplitOptions.RemoveEmptyEntries);
        var totalSyllables = 0;

        foreach (var word in words)
        {
            var vowels = Regex.Matches(word.ToLower(), @"[aeiouy]+").Count;
            totalSyllables += Math.Max(1, vowels); // At least 1 syllable per word
        }

        return totalSyllables;
    }

    private List<string> ExtractKeywords(string content)
    {
        // Extract words from headings and emphasized text
        var keywords = new HashSet<string>();

        var headings = Regex.Matches(content, @"^#{1,6}\s+(.+)$", RegexOptions.Multiline);
        foreach (Match match in headings)
        {
            var words = match.Groups[1].Value.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            foreach (var word in words)
            {
                if (word.Length > 4) keywords.Add(word.ToLower());
            }
        }

        return keywords.ToList();
    }

    private double CalculateSimilarity(List<string> keywords, string content)
    {
        var matches = keywords.Count(k => content.Contains(k, StringComparison.OrdinalIgnoreCase));
        return keywords.Count > 0 ? matches / (double)keywords.Count : 0;
    }

    private string ExtractTitle(string content)
    {
        // Try to extract from YAML frontmatter first
        var yamlMatch = Regex.Match(content, @"^---\s*\r?\ntitle:\s*[""']?(.+?)[""']?\s*\r?\n", RegexOptions.Multiline);
        if (yamlMatch.Success)
        {
            return yamlMatch.Groups[1].Value;
        }

        // Fallback to first h1 heading
        var headingMatch = Regex.Match(content, @"^#\s+(.+)$", RegexOptions.Multiline);
        return headingMatch.Success ? headingMatch.Groups[1].Value : "Untitled";
    }
}

public class ValidationResult
{
    public bool Passed { get; set; }
    public int IssuesFound { get; set; }
    public List<string> Issues { get; set; } = new();
    public Dictionary<string, object> Metrics { get; set; } = new();
    public DateTime Timestamp { get; set; }
}

public class GapAnalysisResult
{
    public List<string> Gaps { get; set; } = new();
    public List<string> Suggestions { get; set; } = new();
}

public class RelatedArticle
{
    public string FilePath { get; set; } = "";
    public string Title { get; set; } = "";
    public double Similarity { get; set; }
}
