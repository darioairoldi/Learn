#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Extracts all internal markdown links from files in the repository

.DESCRIPTION
    Scans all markdown files and extracts internal links (links to .md or .qmd files).
    Outputs a JSON file with all links found, their source files, and line numbers.

.PARAMETER RepositoryRoot
    Root path of the repository (defaults to script location)

.PARAMETER OutputFile
    Path to output JSON file (defaults to ./_output/all-links.json)

.EXAMPLE
    .\01-extract-all-links.ps1
    .\01-extract-all-links.ps1 -RepositoryRoot "E:\repo" -OutputFile "links.json"
#>

param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot | Split-Path -Parent),
    [string]$OutputFile = "$PSScriptRoot\_output\all-links.json"
)

# Ensure output directory exists
$outputDir = Split-Path -Parent $OutputFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Write-Host "🔍 Scanning repository for internal markdown links..." -ForegroundColor Cyan
Write-Host "Repository: $RepositoryRoot" -ForegroundColor Gray

# Exclusion patterns
$excludePatterns = @(
    '**/docs/**',
    '**/*_files/**',
    '**/node_modules/**',
    '**/.git/**',
    '**/.quarto/**',
    '**/_site/**',
    '**/_freeze/**',
    '**/site_libs/**'
)

# Find all markdown files
$allFiles = Get-ChildItem -Path $RepositoryRoot -Recurse -Include *.md, *.qmd | Where-Object {
    $file = $_
    $exclude = $false
    foreach ($pattern in $excludePatterns) {
        $pattern = $pattern -replace '\*\*/', '*'
        if ($file.FullName -like $pattern) {
            $exclude = $true
            break
        }
    }
    -not $exclude
}

Write-Host "Found $($allFiles.Count) markdown files to scan" -ForegroundColor Green

# Extract links from files
$allLinks = @()
$fileCount = 0

foreach ($file in $allFiles) {
    $fileCount++
    $relativePath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart('\', '/')
    
    Write-Progress -Activity "Extracting links" -Status "Processing $relativePath" -PercentComplete (($fileCount / $allFiles.Count) * 100)
    
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    # Regex to find markdown links to .md or .qmd files
    # Pattern: [text](url.md) or [text](url.qmd)
    $linkPattern = '\[([^\]]+)\]\(([^)]*\.(?:md|qmd)[^)]*)\)'
    
    $matches = [regex]::Matches($content, $linkPattern)
    
    foreach ($match in $matches) {
        $linkText = $match.Groups[1].Value
        $linkUrl = $match.Groups[2].Value
        
        # Skip external links
        if ($linkUrl -match '^https?://') {
            continue
        }
        
        # Find line number
        $beforeMatch = $content.Substring(0, $match.Index)
        $lineNumber = ($beforeMatch -split "`n").Count
        
        $allLinks += [PSCustomObject]@{
            SourceFile     = $relativePath
            SourceFileFull = $file.FullName
            LineNumber     = $lineNumber
            LinkText       = $linkText
            LinkUrl        = $linkUrl
            FullMatch      = $match.Value
        }
    }
}

Write-Progress -Activity "Extracting links" -Completed

Write-Host "`n✅ Extraction complete!" -ForegroundColor Green
Write-Host "Total internal links found: $($allLinks.Count)" -ForegroundColor Cyan
Write-Host "Saving to: $OutputFile" -ForegroundColor Gray

# Save to JSON
$allLinks | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "`n📊 Summary by source file:" -ForegroundColor Yellow
$allLinks | Group-Object SourceFile | Sort-Object Count -Descending | Select-Object -First 10 | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count) links" -ForegroundColor Gray
}

Write-Host "`nOutput saved to: $OutputFile" -ForegroundColor Green
