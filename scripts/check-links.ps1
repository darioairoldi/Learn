# Script to check all file links in _quarto.yml and index.qmd

$workspaceRoot = "e:\dev.darioa.live\darioairoldi\Learn"
$brokenLinks = @()
$validLinks = @()

# Extract file paths from _quarto.yml
$quartoContent = Get-Content "$workspaceRoot\_quarto.yml" -Raw
$indexContent = Get-Content "$workspaceRoot\index.qmd" -Raw

# Pattern to match href paths
$hrefPattern = 'href:\s*"([^"]+)"'
$markdownLinkPattern = '\[([^\]]+)\]\(([^)]+)\)'

# Function to check if file exists
function Test-FilePath {
    param($path)
    
    # Clean up the path
    $cleanPath = $path -replace '%20', ' '
    $cleanPath = $cleanPath -replace '#.*$', ''  # Remove anchors
    
    # Skip external URLs
    if ($cleanPath -match '^https?://') {
        return $true
    }
    
    # Skip anchors only
    if ($cleanPath -match '^#') {
        return $true
    }
    
    $fullPath = Join-Path $workspaceRoot $cleanPath
    
    return Test-Path $fullPath
}

Write-Host "`n=== Checking _quarto.yml ===" -ForegroundColor Cyan

# Check href paths in _quarto.yml
$quartoMatches = [regex]::Matches($quartoContent, $hrefPattern)
foreach ($match in $quartoMatches) {
    $filePath = $match.Groups[1].Value
    
    if (Test-FilePath $filePath) {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "_quarto.yml"
            Path = $filePath
        }
        Write-Host "BROKEN: $filePath" -ForegroundColor Red
    }
}

Write-Host "`n=== Checking index.qmd ===" -ForegroundColor Cyan

# Check markdown links in index.qmd
$indexMatches = [regex]::Matches($indexContent, $markdownLinkPattern)
foreach ($match in $indexMatches) {
    $filePath = $match.Groups[2].Value
    
    if (Test-FilePath $filePath) {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "index.qmd"
            Path = $filePath
        }
        Write-Host "BROKEN: $filePath" -ForegroundColor Red
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Valid links: $($validLinks.Count)" -ForegroundColor Green
Write-Host "Broken links: $($brokenLinks.Count)" -ForegroundColor $(if ($brokenLinks.Count -gt 0) { 'Red' } else { 'Green' })

if ($brokenLinks.Count -gt 0) {
    Write-Host "`n=== Broken Links Details ===" -ForegroundColor Yellow
    $brokenLinks | Format-Table -AutoSize
    
    # Export to file for reference
    $brokenLinks | Export-Csv "$workspaceRoot\broken-links.csv" -NoTypeInformation
    Write-Host "`nBroken links exported to: broken-links.csv" -ForegroundColor Yellow
}
