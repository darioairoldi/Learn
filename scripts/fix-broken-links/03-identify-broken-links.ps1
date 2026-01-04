#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Identifies broken internal links by reconciling with file inventory

.DESCRIPTION
    Takes the extracted links and file inventory, validates each link, and
    attempts to reconcile broken links with actual file locations using
    intelligent matching strategies.

.PARAMETER RepositoryRoot
    Root path of the repository (defaults to script location)

.PARAMETER LinksFile
    Path to links JSON file from step 1

.PARAMETER InventoryFile
    Path to inventory JSON file from step 2

.PARAMETER OutputFile
    Path to output JSON file with broken links analysis

.EXAMPLE
    .\03-identify-broken-links.ps1
#>

param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot | Split-Path -Parent),
    [string]$LinksFile = "$PSScriptRoot\_output\all-links.json",
    [string]$InventoryFile = "$PSScriptRoot\_output\file-inventory.json",
    [string]$OutputFile = "$PSScriptRoot\_output\broken-links-analysis.json"
)

# Load required assembly for URL decoding
Add-Type -AssemblyName System.Web

Write-Host "🔍 Analyzing links and identifying broken ones..." -ForegroundColor Cyan

# Load data
Write-Host "Loading links..." -ForegroundColor Gray
$allLinks = Get-Content -Path $LinksFile -Raw | ConvertFrom-Json

Write-Host "Loading file inventory..." -ForegroundColor Gray
$inventory = Get-Content -Path $InventoryFile -Raw | ConvertFrom-Json

Write-Host "Total links to validate: $($allLinks.Count)" -ForegroundColor Cyan
Write-Host "Total files in inventory: $($inventory.Count)" -ForegroundColor Cyan

# Function to normalize path
function Normalize-Path {
    param([string]$Path)
    # URL decode the path (handles %20, %23, etc.)
    $Path = [System.Web.HttpUtility]::UrlDecode($Path)
    # Normalize slashes
    return ($Path -replace '\\', '/').Trim()
}

# Function to resolve relative path
function Resolve-RelativePath {
    param(
        [string]$SourceFile,
        [string]$LinkUrl,
        [string]$RepositoryRoot
    )
    
    # Strip fragment identifier (anchor) only if it's after a valid file extension
    # Pattern: .md#anchor or .qmd#anchor - keep the #anchor part out
    if ($LinkUrl -match '(.+\.(?:md|qmd))(#.*)$') {
        $LinkUrl = $matches[1]  # Keep only the file path part
    }
    
    # Decode URL encoding (including %23 for #, %20 for space, etc.)
    $LinkUrl = [System.Web.HttpUtility]::UrlDecode($LinkUrl)
    
    # If absolute path (from repo root), must start with a folder name or ./
    # Relative links: ./file.md, ../file.md, or just filename.md (same directory)
    $isAbsolute = $LinkUrl -match '^[^./\\].*/'
    
    if ($isAbsolute) {
        return Normalize-Path $LinkUrl
    }
    
    # Get source directory
    $sourceDir = Split-Path -Parent (Join-Path $RepositoryRoot $SourceFile)
    
    # Resolve relative path
    $resolvedPath = Join-Path $sourceDir $LinkUrl
    $resolvedPath = [System.IO.Path]::GetFullPath($resolvedPath)
    
    # Make relative to repo root
    if ($resolvedPath.StartsWith($RepositoryRoot)) {
        $resolvedPath = $resolvedPath.Substring($RepositoryRoot.Length).TrimStart('\', '/')
    }
    
    return Normalize-Path $resolvedPath
}

# Function to find matching file
function Find-MatchingFile {
    param(
        [string]$TargetPath,
        [array]$Inventory
    )
    
    $normalized = Normalize-Path $TargetPath
    
    # Strategy 1: Exact match (normalized)
    $exactMatch = $Inventory | Where-Object {
        (Normalize-Path $_.RelativePath) -eq $normalized -or
        (Normalize-Path $_.RelativePathUnix) -eq $normalized
    } | Select-Object -First 1
    
    if ($exactMatch) {
        return @{
            Found = $true
            Match = $exactMatch
            Strategy = "Exact"
            Confidence = "HIGH"
        }
    }
    
    # Strategy 2: Filename match
    $targetFileName = Split-Path -Leaf $normalized
    $fileMatches = $Inventory | Where-Object {
        $_.FileName -eq $targetFileName
    }
    
    if ($fileMatches.Count -eq 1) {
        return @{
            Found = $true
            Match = $fileMatches[0]
            Strategy = "Filename"
            Confidence = "HIGH"
        }
    }
    
    # Strategy 2b: Filename match with numbered prefix flexibility
    # e.g., "Summary.md" should match "01. Summary.md" or "02. README.Sonnet4.md"
    $targetFileNameNoPrefix = $targetFileName -replace '^\d+\.\s+', ''
    $fileMatchesWithPrefix = $Inventory | Where-Object {
        ($_.FileName -replace '^\d+\.\s+', '') -eq $targetFileNameNoPrefix
    }
    
    if ($fileMatchesWithPrefix.Count -ge 1) {
        # Check if it's in a similar folder structure
        $targetDir = Split-Path -Parent $normalized
        
        foreach ($candidate in $fileMatchesWithPrefix) {
            $candidatePath = Normalize-Path $candidate.RelativePath
            $candidateDir = Split-Path -Parent $candidatePath
            
            # Normalize directories by removing numbered prefixes for comparison
            # Pattern: "01.00 news" -> "news", "20251224 vscode v1.107 Release" -> "vscode v1.107 Release"
            function Remove-NumberedPrefixes {
                param([string]$Path)
                $parts = $Path -split '[/\\]'
                $cleanParts = $parts | ForEach-Object {
                    $_ -replace '^\d+\.\d+\s+', '' -replace '^\d+\.\s+', '' -replace '^\d{8}\s+', ''
                }
                return ($cleanParts -join '/')
            }
            
            $targetDirClean = Remove-NumberedPrefixes $targetDir
            $candidateDirClean = Remove-NumberedPrefixes $candidateDir
            
            # If directories match (ignoring numbered prefixes), it's HIGH confidence
            if ($targetDirClean -eq $candidateDirClean) {
                return @{
                    Found = $true
                    Match = $candidate
                    Strategy = "NumberedFilename"
                    Confidence = "HIGH"
                }
            }
        }
    }
    
    # Strategy 3: Check if path missing numbered prefix
    # e.g., "tech/Azure/..." should be "03.00 tech/02.01 Azure/..."
    $folderMappings = @{
        'news' = '01.00 news'
        'events' = '02.00 events'
        'tech' = '03.00 tech'
        'howto' = '04.00 howto'
        'issues' = '05.00 issues'
        'idea' = '06.00 idea'
        'projects' = '07.00 projects'
    }
    
    foreach ($key in $folderMappings.Keys) {
        if ($normalized -match "^$key[/\\]") {
            $corrected = $normalized -replace "^$key", $folderMappings[$key]
            $corrected = Normalize-Path $corrected
            
            $match = $Inventory | Where-Object {
                (Normalize-Path $_.RelativePath) -eq $corrected -or
                (Normalize-Path $_.RelativePathUnix) -eq $corrected
            } | Select-Object -First 1
            
            if ($match) {
                return @{
                    Found = $true
                    Match = $match
                    Strategy = "NumberedPrefix"
                    Confidence = "HIGH"
                    Correction = $corrected
                }
            }
        }
    }
    
    # Strategy 4: Fuzzy folder match with filename
    if ($fileMatches.Count -gt 1) {
        # Multiple files with same name - need more context
        $targetParts = $normalized -split '[/\\]'
        $targetFolders = $targetParts[0..($targetParts.Length - 2)]
        
        foreach ($candidate in $fileMatches) {
            $candidateParts = $candidate.RelativePath -split '[/\\]'
            $candidateFolders = $candidateParts[0..($candidateParts.Length - 2)]
            
            # Check if folder structure is similar
            $matchCount = 0
            foreach ($folder in $targetFolders) {
                if ($candidateFolders -contains $folder -or 
                    ($candidateFolders | Where-Object { $_ -match [regex]::Escape($folder) })) {
                    $matchCount++
                }
            }
            
            if ($matchCount -gt 0) {
                return @{
                    Found = $true
                    Match = $candidate
                    Strategy = "FuzzyFolder"
                    Confidence = "MEDIUM"
                    MatchCount = $matchCount
                    Alternatives = $fileMatches.Count
                }
            }
        }
    }
    
    return @{
        Found = $false
        Strategy = "None"
        Confidence = "NONE"
    }
}

# Validate all links
$results = @()
$linkCount = 0

foreach ($link in $allLinks) {
    $linkCount++
    Write-Progress -Activity "Validating links" -Status "Checking link $linkCount of $($allLinks.Count)" -PercentComplete (($linkCount / $allLinks.Count) * 100)
    
    # Resolve the target path
    $targetPath = Resolve-RelativePath -SourceFile $link.SourceFile -LinkUrl $link.LinkUrl -RepositoryRoot $RepositoryRoot
    
    # Try to find matching file
    $matchResult = Find-MatchingFile -TargetPath $targetPath -Inventory $inventory
    
    $results += [PSCustomObject]@{
        SourceFile = $link.SourceFile
        LineNumber = $link.LineNumber
        LinkText = $link.LinkText
        LinkUrl = $link.LinkUrl
        TargetPath = $targetPath
        IsValid = $matchResult.Found
        MatchStrategy = $matchResult.Strategy
        Confidence = $matchResult.Confidence
        MatchedFile = if ($matchResult.Found) { $matchResult.Match.RelativePath } else { $null }
        MatchedFileFull = if ($matchResult.Found) { $matchResult.Match.FullPath } else { $null }
        CorrectedPath = if ($matchResult.Correction) { $matchResult.Correction } else { $null }
        Alternatives = if ($matchResult.Alternatives) { $matchResult.Alternatives } else { 0 }
    }
}

Write-Progress -Activity "Validating links" -Completed

# Analyze results
$validLinks = $results | Where-Object { $_.IsValid }
$brokenLinks = $results | Where-Object { -not $_.IsValid }
$highConfidenceFixes = $results | Where-Object { -not $_.IsValid -and $_.Confidence -eq "HIGH" }

Write-Host "`n✅ Validation complete!" -ForegroundColor Green
Write-Host "Total links validated: $($results.Count)" -ForegroundColor Cyan
Write-Host "Valid links: $($validLinks.Count) ✅" -ForegroundColor Green
Write-Host "Broken links: $($brokenLinks.Count) ❌" -ForegroundColor Red
Write-Host "High-confidence fixes available: $($highConfidenceFixes.Count) 🔧" -ForegroundColor Yellow

# Save results
$outputData = @{
    Summary = @{
        TotalLinks = $results.Count
        ValidLinks = $validLinks.Count
        BrokenLinks = $brokenLinks.Count
        HighConfidenceFixes = $highConfidenceFixes.Count
    }
    AllResults = $results
    BrokenLinks = $brokenLinks
    HighConfidenceFixes = $highConfidenceFixes
}

$outputData | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "`n📊 Broken links by source file:" -ForegroundColor Yellow
$brokenLinks | Group-Object SourceFile | Sort-Object Count -Descending | Select-Object -First 10 | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count) broken links" -ForegroundColor Gray
}

Write-Host "`nOutput saved to: $OutputFile" -ForegroundColor Green
