# Enhanced link checker with proper URL decoding

$workspaceRoot = "e:\dev.darioa.live\darioairoldi\Learn"
$brokenLinks = @()
$validLinks = @()

# Function to decode URL-encoded paths
function Decode-UrlPath {
    param($path)
    # URL decode
    $decoded = [System.Uri]::UnescapeDataString($path)
    return $decoded
}

# Function to check if file exists
function Test-FilePath {
    param($path, $sourceFile)
    
    # Decode URL encoding
    $cleanPath = Decode-UrlPath $path
    
    # Remove anchors ONLY if they appear after a valid file extension or at the end
    # This preserves C# in filenames but removes #section-anchors
    if ($cleanPath -match '\.md#' -or $cleanPath -match '\.qmd#') {
        $cleanPath = $cleanPath -replace '#.*$', ''
    }
    
    # Skip external URLs
    if ($cleanPath -match '^https?://') {
        return $true
    }
    
    # Skip anchors only  
    if ($cleanPath -match '^#') {
        return $true
    }
    
    $fullPath = Join-Path $workspaceRoot $cleanPath
    
    $exists = Test-Path $fullPath
    
    if (-not $exists) {
        Write-Host "BROKEN in $sourceFile : $path" -ForegroundColor Red
        Write-Host "  Decoded: $cleanPath" -ForegroundColor Yellow
        Write-Host "  Full path: $fullPath" -ForegroundColor Yellow
    }
    
    return $exists
}

Write-Host "`n=== Checking _quarto.yml ===" -ForegroundColor Cyan

$quartoContent = Get-Content "$workspaceRoot\_quarto.yml" -Raw
$hrefPattern = 'href:\s*"([^"]+)"'
$quartoMatches = [regex]::Matches($quartoContent, $hrefPattern)

foreach ($match in $quartoMatches) {
    $filePath = $match.Groups[1].Value
    
    if (Test-FilePath $filePath "_quarto.yml") {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "_quarto.yml"
            Path = $filePath
        }
    }
}

Write-Host "`n=== Checking index.qmd ===" -ForegroundColor Cyan

$indexContent = Get-Content "$workspaceRoot\index.qmd" -Raw
$markdownLinkPattern = '\[([^\]]+)\]\(([^)]+)\)'
$indexMatches = [regex]::Matches($indexContent, $markdownLinkPattern)

foreach ($match in $indexMatches) {
    $filePath = $match.Groups[2].Value
    
    if (Test-FilePath $filePath "index.qmd") {
        $validLinks += $filePath
    } else {
        $brokenLinks += [PSCustomObject]@{
            File = "index.qmd"
            Path = $filePath
        }
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Valid links: $($validLinks.Count)" -ForegroundColor Green
Write-Host "Broken links: $($brokenLinks.Count)" -ForegroundColor $(if ($brokenLinks.Count -gt 0) { 'Red' } else { 'Green' })

if ($brokenLinks.Count -gt 0) {
    Write-Host "`n=== Broken Links Details ===" -ForegroundColor Yellow
    $brokenLinks | Format-Table -AutoSize
} else {
    Write-Host "`n✅ All links are valid!" -ForegroundColor Green
}
