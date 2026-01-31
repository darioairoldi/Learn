# GitHub Artifacts Cleanup Script
# This script will help clean up artifacts and workflow runs to free storage

Write-Host "GitHub Artifacts Cleanup Tool" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: The updated workflow uses artifacts with 1-day retention," -ForegroundColor Yellow
Write-Host "      so they auto-delete after 24 hours. This script helps" -ForegroundColor Yellow
Write-Host "      clean up older artifacts from previous workflow versions." -ForegroundColor Yellow
Write-Host ""

$repo = "diginsight/tools"

# Check if gh CLI is installed and authenticated
try {
    $authStatus = gh auth status 2>&1
    Write-Host "✓ GitHub CLI authenticated" -ForegroundColor Green
} catch {
    Write-Host "✗ GitHub CLI not authenticated. Please run: gh auth login" -ForegroundColor Red
    exit 1
}

# Function to delete all artifacts
function Remove-AllArtifacts {
    Write-Host "`nStep 1: Checking for artifacts..." -ForegroundColor Yellow
    
    $artifactsJson = gh api "repos/$repo/actions/artifacts" --jq '.artifacts'
    $artifacts = $artifactsJson | ConvertFrom-Json
    
    if ($artifacts.Count -eq 0) {
        Write-Host "✓ No artifacts found" -ForegroundColor Green
        return
    }
    
    Write-Host "Found $($artifacts.Count) artifacts. Deleting..." -ForegroundColor Yellow
    
    foreach ($artifact in $artifacts) {
        Write-Host "  Deleting artifact: $($artifact.name) (ID: $($artifact.id))" -ForegroundColor Gray
        gh api "repos/$repo/actions/artifacts/$($artifact.id)" -X DELETE 2>&1 | Out-Null
    }
    
    Write-Host "✓ All artifacts deleted" -ForegroundColor Green
}

# Function to delete old workflow runs
function Remove-OldWorkflowRuns {
    param(
        [int]$KeepLast = 5
    )
    
    Write-Host "`nStep 2: Checking workflow runs..." -ForegroundColor Yellow
    
    $runsJson = gh api "repos/$repo/actions/runs?per_page=100" --jq '.workflow_runs'
    $runs = $runsJson | ConvertFrom-Json
    
    if ($runs.Count -eq 0) {
        Write-Host "✓ No workflow runs found" -ForegroundColor Green
        return
    }
    
    Write-Host "Found $($runs.Count) workflow runs" -ForegroundColor Yellow
    
    # Sort by created date and skip the most recent ones
    $runsToDelete = $runs | Sort-Object -Property created_at -Descending | Select-Object -Skip $KeepLast
    
    if ($runsToDelete.Count -eq 0) {
        Write-Host "✓ Keeping all runs (less than $KeepLast total)" -ForegroundColor Green
        return
    }
    
    Write-Host "Deleting $($runsToDelete.Count) old workflow runs (keeping last $KeepLast)..." -ForegroundColor Yellow
    
    foreach ($run in $runsToDelete) {
        Write-Host "  Deleting run: $($run.name) - $($run.created_at) (ID: $($run.id))" -ForegroundColor Gray
        try {
            gh api "repos/$repo/actions/runs/$($run.id)" -X DELETE 2>&1 | Out-Null
        } catch {
            Write-Host "    Warning: Could not delete run $($run.id)" -ForegroundColor DarkYellow
        }
    }
    
    Write-Host "✓ Old workflow runs deleted" -ForegroundColor Green
}

# Function to show storage status
function Show-StorageStatus {
    Write-Host "`nStep 3: Checking storage status..." -ForegroundColor Yellow
    
    # Show remaining artifacts
    $artifactsJson = gh api "repos/$repo/actions/artifacts" --jq '.artifacts'
    $artifacts = $artifactsJson | ConvertFrom-Json
    Write-Host "  Artifacts remaining: $($artifacts.Count)" -ForegroundColor Cyan
    
    # Show remaining runs
    $runsJson = gh api "repos/$repo/actions/runs?per_page=100" --jq '.workflow_runs'
    $runs = $runsJson | ConvertFrom-Json
    Write-Host "  Workflow runs remaining: $($runs.Count)" -ForegroundColor Cyan
    
    Write-Host "`n✓ Cleanup complete!" -ForegroundColor Green
    Write-Host "`nNote: GitHub recalculates storage quota every 6-12 hours." -ForegroundColor Yellow
    Write-Host "If the issue persists, check your billing dashboard at:" -ForegroundColor Yellow
    Write-Host "https://github.com/settings/billing/summary" -ForegroundColor Cyan
}

# Main execution
Write-Host "This script will clean up artifacts and old workflow runs." -ForegroundColor White
Write-Host "Repository: $repo" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Do you want to proceed? (Y/N)"
if ($confirm -ne 'Y' -and $confirm -ne 'y') {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

# Execute cleanup
Remove-AllArtifacts
Remove-OldWorkflowRuns -KeepLast 5
Show-StorageStatus

Write-Host "`nYou can now try running your workflow again!" -ForegroundColor Green
