# Analyze broken links and find correct paths

$workspaceRoot = "e:\dev.darioa.live\darioairoldi\Learn"
$corrections = @()

# List of broken links from the check
$brokenLinks = @(
    # From _quarto.yml
    "events/202506 Build 2025/DEM515 Write better C# code/README.GPT5.md",
    "events/202506 Build 2025/DEM515 Write better C# code/SUMMARY.md",
    "20251005 Feeds architectures and protocols/04. C# Reference Classes for Reading Feeds.md",
    "20250713 Use http files for easy and repeatable test/01. Using HTTP Files for API Testing (VSCode Rest Client).md",
    
    # From index.qmd (decoded)
    "20250713 Use http files for easy and repeatable test/01. Using HTTP Files for API Testing (VSCode Rest Client).md",
    "20250713 Use http files for easy and repeatable test/02. Using HTTP Files for API Testing (Visual Studio).md",
    "20250709 Manage GitRepo from commandline/README.md",
    "20250825 Github repositories limitations/README.md",
    "20251018 ISSUE Github action fails with Artifact storage quota has been hit/01. README.md",
    "20251018 ISSUE Github action fails with Artifact storage quota has been hit/02. QUICKSTART.md",
    "20251018 ISSUE Github action fails with Artifact storage quota has been hit/03. SOLUTION_SUMMARY.md",
    "20251018 ISSUE Github action fails with Artifact storage quota has been hit/05. FINAL_SOLUTION_NO_ARTIFACTS.md",
    "20251013 HowTo Expose My Computer with No-IP DDNS/README.md",
    "20250702 Azure Naming conventions/",
    "20250704 TableStorageAccess options/",
    "20250706 CosmosDB Access options/01. Azure CosmosDB Access Options.md",
    "20250709 Manage GitRepo from commandline/",
    "20251018 ISSUE Github action fails with Artifact storage quota has been hit/",
    "20250825 Github repositories limitations/"
)

Write-Host "Searching for correct paths..." -ForegroundColor Cyan

# Check each broken link
foreach ($link in $brokenLinks | Select-Object -Unique) {
    Write-Host "`nBroken: $link" -ForegroundColor Yellow
    
    # Extract filename or folder name
    $parts = $link -split '/'
    $lastPart = $parts[-1]
    
    if ($lastPart -match '\.(md|qmd)$') {
        # It's a file
        $filename = $lastPart
        $searchPattern = "**\$filename"
    } elseif ($lastPart -eq "") {
        # Directory link (ends with /)
        $dirname = $parts[-2]
        $searchPattern = "**\$dirname\README.md"
    } else {
        # Could be directory or file without extension
        $searchPattern = "**\$lastPart*"
    }
    
    Write-Host "Searching for: $searchPattern" -ForegroundColor Gray
    
    $found = Get-ChildItem -Path $workspaceRoot -Filter "*$lastPart*" -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 3
    
    if ($found) {
        Write-Host "Found:" -ForegroundColor Green
        foreach ($file in $found) {
            $relativePath = $file.FullName.Replace($workspaceRoot + "\", "")
            Write-Host "  -> $relativePath" -ForegroundColor Green
            
            $corrections += [PSCustomObject]@{
                Broken = $link
                Correct = $relativePath
            }
        }
    } else {
        Write-Host "  NOT FOUND" -ForegroundColor Red
    }
}

Write-Host "`n`n=== Summary of Corrections ===" -ForegroundColor Cyan
$corrections | Format-Table -AutoSize
$corrections | Export-Csv "$workspaceRoot\link-corrections.csv" -NoTypeInformation
Write-Host "Corrections exported to: link-corrections.csv" -ForegroundColor Yellow
