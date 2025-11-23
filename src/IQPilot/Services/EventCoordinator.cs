using Microsoft.Extensions.Logging;
using System.Collections.Concurrent;
using System.Diagnostics;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Services;

/// <summary>
/// Coordinates file events from multiple sources (FileSystemWatcher + VS Code Extension)
/// Deduplicates events to prevent double-processing
/// </summary>
public class EventCoordinator
{
    private readonly ILogger<EventCoordinator> _logger;
    private readonly ConcurrentDictionary<string, DateTime> _recentEvents = new();
    private readonly TimeSpan _deduplicationWindow = TimeSpan.FromMilliseconds(500);

    public EventCoordinator(ILogger<EventCoordinator> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Register file event and check if it should be processed
    /// Returns true if event is new and should be processed
    /// </summary>
    public bool ShouldProcessEvent(string eventKey, string source)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { eventKey, source });
        
        var now = DateTime.UtcNow;

        bool result;
        // Check if we've seen this event recently
        if (_recentEvents.TryGetValue(eventKey, out var lastSeen))
        {
            var elapsed = now - lastSeen;
            if (elapsed < _deduplicationWindow)
            {
                _logger.LogDebug($"Duplicate event from {source}: {eventKey} (seen {elapsed.TotalMilliseconds}ms ago)");
                result = false; // Duplicate, skip processing
                activity?.SetOutput(result);
                return result;
            }
        }

        // Record this event
        _recentEvents[eventKey] = now;
        _logger.LogDebug($"New event from {source}: {eventKey}");

        // Cleanup old events (older than 5 seconds)
        CleanupOldEvents(now);

        result = true; // New event, process it
        activity?.SetOutput(result);
        return result;
    }

    /// <summary>
    /// Process file created event
    /// </summary>
    public async Task OnFileCreatedAsync(string filePath, string source = "unknown")
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, source });
        
        var eventKey = $"created:{filePath}";
        if (!ShouldProcessEvent(eventKey, source))
        {
            return;
        }

        _logger.LogInformation($"File created: {filePath} (source: {source})");

        // Trigger handlers (to be implemented)
        await Task.CompletedTask;
    }

    /// <summary>
    /// Process file changed event
    /// </summary>
    public async Task OnFileChangedAsync(string filePath, string source = "unknown")
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, source });
        
        var eventKey = $"changed:{filePath}";
        if (!ShouldProcessEvent(eventKey, source))
        {
            return;
        }

        _logger.LogInformation($"File changed: {filePath} (source: {source})");

        // Trigger handlers (to be implemented)
        await Task.CompletedTask;
    }

    /// <summary>
    /// Process file renamed event
    /// </summary>
    public async Task OnFileRenamedAsync(string oldPath, string newPath, string source = "unknown")
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { oldPath, newPath, source });
        
        var eventKey = $"renamed:{oldPath}→{newPath}";
        if (!ShouldProcessEvent(eventKey, source))
        {
            return;
        }

        _logger.LogInformation($"File renamed: {oldPath} → {newPath} (source: {source})");

        // Trigger metadata sync handler
        await SyncMetadataAfterRenameAsync(newPath);
    }

    /// <summary>
    /// Process file deleted event
    /// </summary>
    public async Task OnFileDeletedAsync(string filePath, string source = "unknown")
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, source });
        
        var eventKey = $"deleted:{filePath}";
        if (!ShouldProcessEvent(eventKey, source))
        {
            return;
        }

        _logger.LogInformation($"File deleted: {filePath} (source: {source})");

        // Trigger handlers (to be implemented)
        await Task.CompletedTask;
    }

    /// <summary>
    /// Sync metadata filename after rename
    /// </summary>
    private async Task SyncMetadataAfterRenameAsync(string newPath)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { newPath });
        
        try
        {
            // This will be called by FileWatcherService
            _logger.LogDebug($"Metadata sync triggered for {newPath}");
            await Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error syncing metadata for {newPath}");
            activity?.SetStatus(ActivityStatusCode.Error, ex.Message);
            throw;
        }
    }

    /// <summary>
    /// Remove events older than 5 seconds
    /// </summary>
    private void CleanupOldEvents(DateTime now)
    {
        var cutoff = now - TimeSpan.FromSeconds(5);
        var oldKeys = _recentEvents.Where(kvp => kvp.Value < cutoff).Select(kvp => kvp.Key).ToList();

        foreach (var key in oldKeys)
        {
            _recentEvents.TryRemove(key, out _);
        }

        if (oldKeys.Count > 0)
        {
            _logger.LogTrace($"Cleaned up {oldKeys.Count} old events");
        }
    }

    /// <summary>
    /// Clear all tracked events (for testing)
    /// </summary>
    public void Clear()
    {
        _recentEvents.Clear();
        _logger.LogDebug("Event coordinator cleared");
    }
}
