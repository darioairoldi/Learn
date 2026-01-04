#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Builds inventory of all markdown files in the repository

.DESCRIPTION
    Scans the repository and creates a comprehensive inventory of all markdown files
    with their full paths, relative paths, folder structure, and normalized names.

.PARAMETER RepositoryRoot
    Root path of the repository (defaults to script location)

.PARAMETER OutputFile
    Path to output JSON file (defaults to ./_output/file-inventory.json)

.EXAMPLE
    .\02-build-file-inventory.ps1
    .\02-build-file-inventory.ps1 -RepositoryRoot "E:\repo" -OutputFile "inventory.json"
#>

param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot | Split-Path -Parent),
    [string]$OutputFile = "$PSScriptRoot\_output\file-inventory.json"
)

# Ensure output directory exists
$outputDir = Split-Path -Parent $OutputFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Write-Host "📁 Building file inventory..." -ForegroundColor Cyan
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
    '**/site_libs/**',
    '**/README_files/**',
    '**/index_files/**'
)

# Find all markdown files
$allFiles = Get-ChildItem -Path $RepositoryRoot -Recurse -Include *.md,*.qmd | Where-Object {
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

Write-Host "Found $($allFiles.Count) markdown files" -ForegroundColor Green

# Build inventory
$inventory = @()
$fileCount = 0

foreach ($file in $allFiles) {
    $fileCount++
    $relativePath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart('\', '/')
    
    Write-Progress -Activity "Building inventory" -Status "Processing $relativePath" -PercentComplete (($fileCount / $allFiles.Count) * 100)
    
    # Parse folder structure
    $parts = $relativePath -split '[/\\]'
    $folders = $parts[0..($parts.Length - 2)]
    $fileName = $parts[-1]
    $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    
    # Normalize paths (URL-encode spaces)
    $normalizedPath = $relativePath -replace ' ', '%20'
    $normalizedPathUnix = $relativePath -replace '\\', '/'
    
    # Check for numbered folder prefixes
    $topLevelFolder = if ($folders.Length -gt 0) { $folders[0] } else { "" }
    $hasNumberedPrefix = $topLevelFolder -match '^\d+\.\d+\s'
    
    $inventory += [PSCustomObject]@{
        FullPath = $file.FullName
        RelativePath = $relativePath
        RelativePathUnix = $normalizedPathUnix
        NormalizedPath = $normalizedPath
        FileName = $fileName
        FileNameWithoutExt = $fileNameWithoutExt
        Folders = $folders
        TopLevelFolder = $topLevelFolder
        HasNumberedPrefix = $hasNumberedPrefix
        FolderDepth = $folders.Length
    }
}

Write-Progress -Activity "Building inventory" -Completed

Write-Host "`n✅ Inventory complete!" -ForegroundColor Green
Write-Host "Total files indexed: $($inventory.Count)" -ForegroundColor Cyan
Write-Host "Saving to: $OutputFile" -ForegroundColor Gray

# Save to JSON
$inventory | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "`n📊 Files by top-level folder:" -ForegroundColor Yellow
$inventory | Group-Object TopLevelFolder | Sort-Object Count -Descending | ForEach-Object {
    $folderName = if ($_.Name) { $_.Name } else { "(root)" }
    Write-Host "  ${folderName}: $($_.Count) files" -ForegroundColor Gray
}

Write-Host "`n📊 Files with numbered prefixes: $($inventory | Where-Object HasNumberedPrefix | Measure-Object | Select-Object -ExpandProperty Count)" -ForegroundColor Cyan

Write-Host "`nOutput saved to: $OutputFile" -ForegroundColor Green
