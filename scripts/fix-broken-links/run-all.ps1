#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Master script to run all broken link fix steps

.DESCRIPTION
    Runs all four steps in sequence:
    1. Extract all internal links
    2. Build file inventory
    3. Identify broken links
    4. Fix broken links (with options)

.PARAMETER DryRun
    Preview fixes without applying them

.PARAMETER AutoFix
    Automatically apply high-confidence fixes

.PARAMETER Confidence
    Minimum confidence level: HIGH (default), MEDIUM, or ALL

.PARAMETER ExcludeDotFolders
    Exclude files in folders starting with '.' (like .github, .copilot)

.EXAMPLE
    .\run-all.ps1 -DryRun
    .\run-all.ps1 -AutoFix
    .\run-all.ps1 -AutoFix -Confidence MEDIUM
    .\run-all.ps1 -AutoFix -ExcludeDotFolders
#>

param(
    [switch]$DryRun,
    [switch]$AutoFix,
    [ValidateSet('HIGH', 'MEDIUM', 'ALL')]
    [string]$Confidence = 'HIGH',
    [switch]$ExcludeDotFolders
)

$ErrorActionPreference = 'Stop'

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Broken Link Detection and Fix - Complete Pipeline" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan

$startTime = Get-Date

# Step 1: Extract all links
Write-Host "`n▶ STEP 1/4: Extracting all internal links..." -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
& "$PSScriptRoot\01-extract-all-links.ps1"
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Error "Step 1 failed"
}

# Step 2: Build file inventory
Write-Host "`n▶ STEP 2/4: Building file inventory..." -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
& "$PSScriptRoot\02-build-file-inventory.ps1"
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Error "Step 2 failed"
}

# Step 3: Identify broken links
Write-Host "`n▶ STEP 3/4: Identifying broken links..." -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
& "$PSScriptRoot\03-identify-broken-links.ps1"
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Error "Step 3 failed"
}

# Step 4: Fix broken links
Write-Host "`n▶ STEP 4/4: Fixing broken links..." -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray

$fixParams = @{
    Confidence = $Confidence
}

if ($DryRun) {
    $fixParams['DryRun'] = $true
}

if ($AutoFix) {
    $fixParams['AutoFix'] = $true
}

if ($ExcludeDotFolders) {
    $fixParams['ExcludeDotFolders'] = $true
}

& "$PSScriptRoot\04-fix-broken-links.ps1" @fixParams
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Error "Step 4 failed"
}

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Pipeline complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Duration: $($duration.TotalSeconds.ToString('F2')) seconds" -ForegroundColor Gray
Write-Host "`nOutput files:" -ForegroundColor Yellow
Write-Host "  • $PSScriptRoot\_output\all-links.json" -ForegroundColor Gray
Write-Host "  • $PSScriptRoot\_output\file-inventory.json" -ForegroundColor Gray
Write-Host "  • $PSScriptRoot\_output\broken-links-analysis.json" -ForegroundColor Gray

if ($DryRun) {
    Write-Host "`n💡 This was a dry run. Use -AutoFix to apply changes." -ForegroundColor Yellow
} elseif ($AutoFix) {
    Write-Host "`n🎉 Broken links have been fixed automatically!" -ForegroundColor Green
} else {
    Write-Host "`n💡 Use -DryRun to preview or -AutoFix to apply fixes." -ForegroundColor Yellow
}
