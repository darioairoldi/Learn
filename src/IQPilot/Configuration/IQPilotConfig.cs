using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using System.Text.Json;

namespace MetadataWatcher.Configuration;

/// <summary>
/// Main IQPilot configuration loaded from iqpilot.config.json
/// Supports site-specific customization while maintaining framework defaults
/// </summary>
public class IQPilotConfig
{
    public SiteConfig Site { get; set; } = new();
    public MetadataConfig Metadata { get; set; } = new();
    public TemplatesConfig Templates { get; set; } = new();
    public PromptsConfig Prompts { get; set; } = new();
    public ValidationConfig Validation { get; set; } = new();
    public WorkflowsConfig Workflows { get; set; } = new();
    public FilePatternsConfig FilePatterns { get; set; } = new();

    /// <summary>
    /// Load configuration from repository path
    /// Merges framework defaults with site-specific overrides
    /// </summary>
    public static IQPilotConfig Load(string repoPath)
    {
        // Start with framework defaults
        var config = LoadDefaults();

        // Load site-specific config if exists
        var siteConfigPath = Path.Combine(repoPath, ".iqpilot", "config.json");
        if (File.Exists(siteConfigPath))
        {
            var siteConfig = LoadFromFile(siteConfigPath);
            config = Merge(config, siteConfig);
        }

        // Resolve paths relative to repo
        config.ResolveRelativePaths(repoPath);

        return config;
    }

    private static IQPilotConfig LoadDefaults()
    {
        return new IQPilotConfig
        {
            Metadata = new MetadataConfig
            {
                Structure = "dual-yaml",
                TopBlock = new TopBlockConfig
                {
                    RequiredFields = new[] { "title", "author", "date" },
                    OptionalFields = new[] { "categories", "description", "draft" }
                },
                BottomBlock = new BottomBlockConfig
                {
                    Format = "html-comment-yaml",
                    Sections = new[] { "validations", "article_metadata", "cross_references" }
                }
            },
            Templates = new TemplatesConfig
            {
                UseDefaults = true
            },
            Prompts = new PromptsConfig
            {
                UseDefaults = true,
                Enabled = new[] { "grammar-review", "readability-review", "structure-validation" }
            },
            Validation = new ValidationConfig
            {
                Grammar = new GrammarConfig { Enabled = true },
                Readability = new ReadabilityConfig { Enabled = true, TargetGradeLevel = 10 },
                Facts = new FactsConfig { Enabled = true, RequireSources = true }
            },
            Workflows = new WorkflowsConfig
            {
                AutoSyncMetadata = true,
                AutoValidateOnSave = false
            },
            FilePatterns = new FilePatternsConfig
            {
                Articles = "**/*.md",
                Exclude = new[] { "README.md", "node_modules/**", "_site/**", "docs/**" }
            }
        };
    }

    private static IQPilotConfig LoadFromFile(string path)
    {
        var json = File.ReadAllText(path);
        return JsonSerializer.Deserialize<IQPilotConfig>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        }) ?? new IQPilotConfig();
    }

    private static IQPilotConfig Merge(IQPilotConfig defaults, IQPilotConfig overrides)
    {
        // Simple merge - overrides take precedence
        // For production, implement deep merge logic
        return new IQPilotConfig
        {
            Site = overrides.Site ?? defaults.Site,
            Metadata = overrides.Metadata ?? defaults.Metadata,
            Templates = MergeTemplates(defaults.Templates, overrides.Templates),
            Prompts = MergePrompts(defaults.Prompts, overrides.Prompts),
            Validation = overrides.Validation ?? defaults.Validation,
            Workflows = overrides.Workflows ?? defaults.Workflows,
            FilePatterns = overrides.FilePatterns ?? defaults.FilePatterns
        };
    }

    private static TemplatesConfig MergeTemplates(TemplatesConfig defaults, TemplatesConfig overrides)
    {
        return new TemplatesConfig
        {
            Directory = overrides.Directory ?? defaults.Directory,
            UseDefaults = overrides.UseDefaults,
            CustomTemplates = (overrides.CustomTemplates ?? Array.Empty<CustomTemplate>())
                .Concat(defaults.CustomTemplates ?? Array.Empty<CustomTemplate>())
                .ToArray()
        };
    }

    private static PromptsConfig MergePrompts(PromptsConfig defaults, PromptsConfig overrides)
    {
        return new PromptsConfig
        {
            Directory = overrides.Directory ?? defaults.Directory,
            UseDefaults = overrides.UseDefaults,
            Enabled = overrides.Enabled?.Any() == true ? overrides.Enabled : defaults.Enabled
        };
    }

    private void ResolveRelativePaths(string repoPath)
    {
        if (!string.IsNullOrEmpty(Templates.Directory))
        {
            Templates.Directory = Path.Combine(repoPath, Templates.Directory);
        }
        if (!string.IsNullOrEmpty(Prompts.Directory))
        {
            Prompts.Directory = Path.Combine(repoPath, Prompts.Directory);
        }
    }
}

public class SiteConfig
{
    public string Name { get; set; } = "Documentation Site";
    public string Type { get; set; } = "documentation";
    public string? Author { get; set; }
    public string? Repository { get; set; }
    public string? EditorialStandards { get; set; }
}

public class MetadataConfig
{
    public string Structure { get; set; } = "dual-yaml";
    public TopBlockConfig TopBlock { get; set; } = new();
    public BottomBlockConfig BottomBlock { get; set; } = new();
}

public class TopBlockConfig
{
    public string[] RequiredFields { get; set; } = Array.Empty<string>();
    public string[] OptionalFields { get; set; } = Array.Empty<string>();
}

public class BottomBlockConfig
{
    public string Format { get; set; } = "html-comment-yaml";
    public string[] Sections { get; set; } = Array.Empty<string>();
}

public class TemplatesConfig
{
    public string? Directory { get; set; }
    public bool UseDefaults { get; set; } = true;
    public CustomTemplate[]? CustomTemplates { get; set; }
}

public class CustomTemplate
{
    public string Name { get; set; } = string.Empty;
    public string Path { get; set; } = string.Empty;
}

public class PromptsConfig
{
    public string? Directory { get; set; }
    public bool UseDefaults { get; set; } = true;
    public string[] Enabled { get; set; } = Array.Empty<string>();
}

public class ValidationConfig
{
    public GrammarConfig Grammar { get; set; } = new();
    public ReadabilityConfig Readability { get; set; } = new();
    public FactsConfig Facts { get; set; } = new();
    public StructureConfig Structure { get; set; } = new();
}

public class GrammarConfig
{
    public bool Enabled { get; set; } = true;
    public bool AutoFix { get; set; } = false;
}

public class ReadabilityConfig
{
    public bool Enabled { get; set; } = true;
    public int TargetGradeLevel { get; set; } = 10;
    public int FleschScoreMin { get; set; } = 60;
}

public class FactsConfig
{
    public bool Enabled { get; set; } = true;
    public bool RequireSources { get; set; } = true;
}

public class StructureConfig
{
    public bool Enabled { get; set; } = true;
    public bool RequireToc { get; set; } = true;
    public bool RequireReferences { get; set; } = true;
}

public class WorkflowsConfig
{
    public bool AutoValidateOnSave { get; set; } = false;
    public bool AutoSyncMetadata { get; set; } = true;
    public bool ValidateBeforeCommit { get; set; } = false;
}

public class FilePatternsConfig
{
    public string Articles { get; set; } = "**/*.md";
    public string[] Exclude { get; set; } = Array.Empty<string>();
}
