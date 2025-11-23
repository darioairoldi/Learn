using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Collections.Concurrent;
using FileSystemWatcher = System.IO.FileSystemWatcher;
using Diginsight.Diagnostics;

namespace Diginsight.Tools.IQPilot.Services;

/// <summary>
/// Background service that watches for file changes and syncs metadata
/// Integrated with EventCoordinator for deduplication
/// </summary>
public class FileWatcherService : BackgroundService
{
    private readonly ILogger<FileWatcherService> _logger;
    private readonly MetadataManager _metadataManager;
    private readonly EventCoordinator _eventCoordinator;
    private readonly string _workspaceFolder;
    private FileSystemWatcher? _watcher;
    private readonly ConcurrentDictionary<string, DateTime> _recentRenames = new();
    private readonly TimeSpan _debounceTime = TimeSpan.FromMilliseconds(500);

    public FileWatcherService(
        ILogger<FileWatcherService> logger,
        MetadataManager metadataManager,
        EventCoordinator eventCoordinator,
        string workspaceFolder)
    {
        _logger = logger;
        _metadataManager = metadataManager;
        _eventCoordinator = eventCoordinator;
        _workspaceFolder = workspaceFolder;
    }

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Starting FileWatcherService for: {Workspace}", _workspaceFolder);

        try
        {
            _watcher = new FileSystemWatcher
            {
                Path = _workspaceFolder,
                Filter = "*.md",
                NotifyFilter = NotifyFilters.FileName | NotifyFilters.LastWrite | NotifyFilters.CreationTime,
                IncludeSubdirectories = true,
                EnableRaisingEvents = false
            };

            _watcher.Created += OnFileCreated;
            _watcher.Changed += OnFileChanged;
            _watcher.Renamed += OnFileRenamed;
            _watcher.Deleted += OnFileDeleted;

            _watcher.EnableRaisingEvents = true;
            _logger.LogInformation("FileSystemWatcher started successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to initialize FileSystemWatcher");
        }

        return Task.CompletedTask;
    }

    private async void OnFileCreated(object sender, FileSystemEventArgs e)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath = e.FullPath });
        
        try
        {
            await _eventCoordinator.OnFileCreatedAsync(e.FullPath, "FileSystemWatcher");
            activity?.SetOutput(true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing file created event: {Path}", e.FullPath);
            activity?.SetOutput(false);
        }
    }

    private async void OnFileChanged(object sender, FileSystemEventArgs e)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath = e.FullPath });
        
        try
        {
            await _eventCoordinator.OnFileChangedAsync(e.FullPath, "FileSystemWatcher");
            activity?.SetOutput(true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing file changed event: {Path}", e.FullPath);
            activity?.SetOutput(false);
        }
    }

    private async void OnFileRenamed(object sender, RenamedEventArgs e)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new 
        { 
            oldPath = e.OldFullPath, 
            newPath = e.FullPath,
            oldFileName = Path.GetFileName(e.OldFullPath),
            newFileName = Path.GetFileName(e.FullPath)
        });
        
        bool result = false;
        try
        {
            var now = DateTime.UtcNow;
            var oldPath = e.OldFullPath;

            // Local debounce (in addition to EventCoordinator)
            if (_recentRenames.TryGetValue(oldPath, out var lastRename))
            {
                if (now - lastRename < _debounceTime)
                {
                    _logger.LogTrace("Debouncing rename event: {OldPath}", oldPath);
                    result = false;
                    return;
                }
            }

            _recentRenames[oldPath] = now;

            if (!e.FullPath.EndsWith(".md", StringComparison.OrdinalIgnoreCase))
            {
                result = false;
                return;
            }

            _logger.LogInformation("File renamed: {OldName} -> {NewName}",
                Path.GetFileName(e.OldFullPath),
                Path.GetFileName(e.FullPath));

            // Notify EventCoordinator
            await _eventCoordinator.OnFileRenamedAsync(e.OldFullPath, e.FullPath, "FileSystemWatcher");

            // Update metadata filename field
            await UpdateMetadataFilenameAsync(e.FullPath, Path.GetFileName(e.FullPath));
            
            result = true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing file renamed event: {Path}", e.FullPath);
            result = false;
        }
        finally
        {
            activity?.SetOutput(result);
        }
    }

    private async void OnFileDeleted(object sender, FileSystemEventArgs e)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath = e.FullPath });
        
        try
        {
            await _eventCoordinator.OnFileDeletedAsync(e.FullPath, "FileSystemWatcher");
            activity?.SetOutput(true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing file deleted event: {Path}", e.FullPath);
            activity?.SetOutput(false);
        }
    }

    /// <summary>
    /// Update article_metadata.filename after rename
    /// </summary>
    private async Task UpdateMetadataFilenameAsync(string filePath, string newFilename)
    {
        using var activity = Observability.ActivitySource.StartMethodActivity(_logger, () => new { filePath, newFilename });
        
        bool result = false;
        try
        {
            var metadata = await _metadataManager.GetMetadataAsync(filePath);

            if (!metadata.ContainsKey("article_metadata"))
            {
                _logger.LogWarning("No article_metadata section found in: {Path}", filePath);
                result = false;
                return;
            }

            // Update filename and last_updated
            var updates = new Dictionary<string, object>
            {
                ["article_metadata"] = new Dictionary<string, object>
                {
                    ["filename"] = newFilename,
                    ["last_updated"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")
                }
            };

            await _metadataManager.UpdateMetadataAsync(filePath, updates);
            _logger.LogInformation("Successfully updated metadata filename: {Filename}", newFilename);
            result = true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to update metadata filename for: {Path}", filePath);
            result = false;
        }
        finally
        {
            activity?.SetOutput(result);
        }
    }

    public override void Dispose()
    {
        if (_watcher != null)
        {
            _watcher.EnableRaisingEvents = false;
            _watcher.Created -= OnFileCreated;
            _watcher.Changed -= OnFileChanged;
            _watcher.Renamed -= OnFileRenamed;
            _watcher.Deleted -= OnFileDeleted;
            _watcher.Dispose();
        }

        base.Dispose();
    }
}
