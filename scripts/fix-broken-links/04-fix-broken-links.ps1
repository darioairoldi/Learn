#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Fixes broken internal links based on analysis results

.DESCRIPTION
    Applies fixes to broken links based on the reconciliation analysis.
    Can fix high-confidence matches automatically or generate a report
    for manual review.

.PARAMETER AnalysisFile
    Path to analysis JSON file from step 3

.PARAMETER DryRun
    If specified, shows what would be fixed without making changes

.PARAMETER AutoFix
    If specified, automatically fixes high-confidence broken links

.PARAMETER Confidence
    Minimum confidence level to fix: HIGH, MEDIUM, or ALL

.PARAMETER ExcludeDotFolders
    If specified, excludes files in folders starting with '.' (like .github, .copilot)

.EXAMPLE
    .\04-fix-broken-links.ps1 -DryRun
    .\04-fix-broken-links.ps1 -AutoFix -Confidence HIGH
    .\04-fix-broken-links.ps1 -AutoFix -ExcludeDotFolders
#>

param(
    [string]$AnalysisFile = "$PSScriptRoot\_output\broken-links-analysis.json",
    [switch]$DryRun,
    [switch]$AutoFix,
    [ValidateSet('HIGH', 'MEDIUM', 'ALL')]
    [string]$Confidence = 'HIGH',
    [switch]$ExcludeDotFolders
)

Write-Host "🔧 Preparing to fix broken links..." -ForegroundColor Cyan

# Load analysis
Write-Host "Loading analysis results..." -ForegroundColor Gray
$analysis = Get-Content -Path $AnalysisFile -Raw | ConvertFrom-Json

$brokenLinks = $analysis.BrokenLinks

# Exclude dot folders if requested
if ($ExcludeDotFolders) {
    $brokenLinks = $brokenLinks | Where-Object { 
        $_.SourceFile -notmatch '^\.[\\/]' -and 
        $_.SourceFile -notmatch '[\\/]\.[\\/]'
    }
    Write-Host "Excluding files in dot folders (like .github, .copilot)..." -ForegroundColor Gray
}

# Filter by confidence
$linksToFix = switch ($Confidence) {
    'HIGH' { $brokenLinks | Where-Object { $_.Confidence -eq 'HIGH' } }
    'MEDIUM' { $brokenLinks | Where-Object { $_.Confidence -in @('HIGH', 'MEDIUM') } }
    'ALL' { $brokenLinks }
}

Write-Host "Links to fix (confidence $Confidence): $($linksToFix.Count)" -ForegroundColor Cyan

if ($linksToFix.Count -eq 0) {
    Write-Host "No links to fix with confidence level: $Confidence" -ForegroundColor Yellow
    exit 0
}

# Group by source file for efficient batch processing
$linksByFile = $linksToFix | Group-Object SourceFileFull

Write-Host "`n📝 Files to update: $($linksByFile.Count)" -ForegroundColor Yellow

foreach ($fileGroup in $linksByFile) {
    $filePath = $fileGroup.Name
    $links = $fileGroup.Group
    
    Write-Host "`n  Processing: $($links[0].SourceFile)" -ForegroundColor Cyan
    Write-Host "  Fixes to apply: $($links.Count)" -ForegroundColor Gray
    
    if ($DryRun) {
        foreach ($link in $links) {
            $oldUrl = $link.LinkUrl
            $newPath = if ($link.MatchedFile) {
                # Calculate relative or absolute path based on original link style
                if ($link.LinkUrl.StartsWith('.')) {
                    # Was relative, keep relative
                    $link.MatchedFile
                }
                else {
                    # Was absolute from root, keep absolute
                    $link.MatchedFile
                }
            }
            else {
                $link.CorrectedPath
            }
            
            # URL-encode spaces
            $newUrl = $newPath -replace ' ', '%20' -replace '\\', '/'
            
            Write-Host "    Line $($link.LineNumber): $oldUrl → $newUrl" -ForegroundColor Yellow
        }
        continue
    }
    
    if (-not $AutoFix) {
        Write-Host "    [Skipping - AutoFix not enabled]" -ForegroundColor Gray
        continue
    }
    
    # Read file content
    $content = Get-Content -Path $filePath -Raw
    $originalContent = $content
    
    # Apply fixes (process in reverse line order to preserve line numbers)
    $sortedLinks = $links | Sort-Object LineNumber -Descending
    
    foreach ($link in $sortedLinks) {
        $oldPattern = [regex]::Escape($link.LinkUrl)
        
        # Determine new path
        $newPath = if ($link.MatchedFile) {
            $link.MatchedFile
        }
        else {
            $link.CorrectedPath
        }
        
        # URL-encode spaces and normalize separators
        $newUrl = $newPath -replace ' ', '%20' -replace '\\', '/'
        
        # Build full link pattern to replace
        $linkTextEscaped = [regex]::Escape($link.LinkText)
        $fullPattern = "\[$linkTextEscaped\]\($oldPattern\)"
        $replacement = "[$($link.LinkText)]($newUrl)"
        
        if ($content -match $fullPattern) {
            $content = $content -replace $fullPattern, $replacement
            Write-Host "    ✅ Fixed: $($link.LinkUrl) → $newUrl" -ForegroundColor Green
        }
        else {
            Write-Host "    ⚠️ Could not find exact match for: $($link.LinkUrl)" -ForegroundColor Yellow
        }
    }
    
    # Save if changes were made
    if ($content -ne $originalContent) {
        Set-Content -Path $filePath -Value $content -NoNewline -Encoding UTF8
        Write-Host "  💾 Saved changes to file" -ForegroundColor Green
    }
}

if ($DryRun) {
    Write-Host "`n🔍 DRY RUN - No changes were made" -ForegroundColor Yellow
    Write-Host "Run with -AutoFix to apply changes" -ForegroundColor Gray
}
elseif ($AutoFix) {
    Write-Host "`n✅ Fixes applied successfully!" -ForegroundColor Green
    Write-Host "Total links fixed: $($linksToFix.Count)" -ForegroundColor Cyan
}
else {
    Write-Host "`n💡 Use -AutoFix to apply changes or -DryRun to preview" -ForegroundColor Yellow
}
