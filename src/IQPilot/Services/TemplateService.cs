using Microsoft.Extensions.Logging;
using System.Reflection;
using System.Text.RegularExpressions;
using Diginsight.Diagnostics;
using System.Diagnostics;

namespace Diginsight.Tools.IQPilot.Services;

/// <summary>
/// Manages article templates (embedded and site-specific)
/// </summary>
public class TemplateService
{
    private readonly ILogger<TemplateService> _logger;
    private readonly string? _siteTemplatesPath;
    private readonly Dictionary<string, string> _templateCache = new();

    public TemplateService(ILogger<TemplateService> logger, string? siteTemplatesPath = null)
    {
        _logger = logger;
        _siteTemplatesPath = siteTemplatesPath;
    }

    /// <summary>
    /// Get template content by name
    /// Priority: site-specific > embedded resources
    /// </summary>
    public async Task<string> GetTemplateAsync(string templateName)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { templateName });

        // Check cache first
        if (_templateCache.TryGetValue(templateName, out var cachedTemplate))
        {
            activity?.SetOutput(cachedTemplate);
            return cachedTemplate;
        }

        string template;

        // Try site-specific template first
        if (!string.IsNullOrEmpty(_siteTemplatesPath))
        {
            var siteTemplatePath = Path.Combine(_siteTemplatesPath, $"{templateName}.md");
            if (File.Exists(siteTemplatePath))
            {
                _logger.LogInformation($"Loading site template: {siteTemplatePath}");
                template = await File.ReadAllTextAsync(siteTemplatePath);
                _templateCache[templateName] = template;
                activity?.SetOutput(template);
                return template;
            }
        }

        // Fallback to embedded resource
        template = await LoadEmbeddedTemplateAsync(templateName);
        _templateCache[templateName] = template;
        activity?.SetOutput(template);
        return template;
    }

    /// <summary>
    /// Render template with variable substitution
    /// </summary>
    public async Task<string> RenderTemplateAsync(string templateName, Dictionary<string, string> variables)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { templateName });

        var template = await GetTemplateAsync(templateName);

        // Substitute variables: {{variable_name}}
        var rendered = template;
        foreach (var kvp in variables)
        {
            var placeholder = $"{{{{{kvp.Key}}}}}";
            rendered = rendered.Replace(placeholder, kvp.Value);
        }

        // Remove any remaining unfilled placeholders
        rendered = Regex.Replace(rendered, @"\{\{[^}]+\}\}", "");

        activity?.SetOutput(rendered);
        return rendered;
    }

    /// <summary>
    /// List available templates
    /// </summary>
    public async Task<List<string>> ListTemplatesAsync()
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { });

        var templates = new HashSet<string>();

        // Add embedded templates
        var assembly = Assembly.GetExecutingAssembly();
        var resourceNames = assembly.GetManifestResourceNames()
            .Where(r => r.StartsWith("IQPilot.Embedded.templates.") && r.EndsWith(".md"));

        foreach (var resourceName in resourceNames)
        {
            var templateName = resourceName
                .Replace("IQPilot.Embedded.templates.", "")
                .Replace(".md", "");
            templates.Add(templateName);
        }

        // Add site-specific templates
        if (!string.IsNullOrEmpty(_siteTemplatesPath) && Directory.Exists(_siteTemplatesPath))
        {
            var siteTemplates = Directory.GetFiles(_siteTemplatesPath, "*.md")
                .Select(f => Path.GetFileNameWithoutExtension(f));
            foreach (var template in siteTemplates)
            {
                templates.Add(template);
            }
        }

        var result = templates.OrderBy(t => t).ToList();
        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Load template from embedded resources
    /// </summary>
    private async Task<string> LoadEmbeddedTemplateAsync(string templateName)
    {
        var assembly = Assembly.GetExecutingAssembly();
        var resourceName = $"IQPilot.Embedded.templates.{templateName}.md";

        using var stream = assembly.GetManifestResourceStream(resourceName);
        if (stream == null)
        {
            throw new FileNotFoundException($"Template not found: {templateName}");
        }

        using var reader = new StreamReader(stream);
        var content = await reader.ReadToEndAsync();

        _logger.LogInformation($"Loaded embedded template: {templateName}");
        return content;
    }

    /// <summary>
    /// Clear template cache
    /// </summary>
    public void ClearCache()
    {
        _templateCache.Clear();
        _logger.LogInformation("Template cache cleared");
    }
}
