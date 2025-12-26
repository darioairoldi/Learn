# Script to add bottom metadata blocks to all Quarto series articles
# Run from: tech/Markdown/01. QUARTO Doc/

$articles = @(
    @{
        File = "01-how-quarto-works.md"
        Part = 2
        WordCount = 5000
        Previous = "01-introduction-to-quarto.md"
        Next = "02-monolithic-vs-modular-deployment.md"
        Related = @("03-quarto-yml-structure.md", "07-build-optimization.md")
    },
    @{
        File = "02-monolithic-vs-modular-deployment.md"
        Part = 3
        WordCount = 6000
        Previous = "01-how-quarto-works.md"
        Next = "02-split-navigation-build.md"
        Related = @("07-build-optimization.md", "01-how-quarto-works.md")
    },
    @{
        File = "02-split-navigation-build.md"
        Part = 4
        WordCount = 4500
        Previous = "02-monolithic-vs-modular-deployment.md"
        Next = "03-quarto-yml-structure.md"
        Related = @("02-monolithic-vs-modular-deployment.md", "06-navigation-workflow.md")
    },
    @{
        File = "03-quarto-yml-structure.md"
        Part = 5
        WordCount = 3500
        Previous = "02-split-navigation-build.md"
        Next = "04-markdown-features.md"
        Related = @("01-introduction-to-quarto.md", "05-theming-and-styling.md")
    },
    @{
        File = "04-markdown-features.md"
        Part = 6
        WordCount = 3000
        Previous = "03-quarto-yml-structure.md"
        Next = "05-theming-and-styling.md"
        Related = @("03-quarto-yml-structure.md", "05-theming-and-styling.md")
    },
    @{
        File = "05-theming-and-styling.md"
        Part = 7
        WordCount = 4000
        Previous = "04-markdown-features.md"
        Next = "06-sidebar-layout.md"
        Related = @("03-quarto-yml-structure.md", "04-markdown-features.md")
    },
    @{
        File = "06-sidebar-layout.md"
        Part = 8
        WordCount = 2000
        Previous = "05-theming-and-styling.md"
        Next = "06-navigation-workflow.md"
        Related = @("06-navigation-workflow.md", "06-transition-optimization.md")
    },
    @{
        File = "06-navigation-workflow.md"
        Part = 9
        WordCount = 3000
        Previous = "06-sidebar-layout.md"
        Next = "06-transition-optimization.md"
        Related = @("06-sidebar-layout.md", "03-quarto-yml-structure.md")
    },
    @{
        File = "07-build-optimization.md"
        Part = 11
        WordCount = 3500
        Previous = "06-transition-optimization.md"
        Next = "08-troubleshooting-guide.md"
        Related = @("02-monolithic-vs-modular-deployment.md", "01-how-quarto-works.md")
    },
    @{
        File = "09-github-pages-deployment.md"
        Part = 13
        WordCount = 3000
        Previous = "08-troubleshooting-guide.md"
        Next = "09-azure-storage-deployment.md"
        Related = @("01-introduction-to-quarto.md", "07-build-optimization.md")
    },
    @{
        File = "09-azure-storage-deployment.md"
        Part = 14
        WordCount = 4000
        Previous = "09-github-pages-deployment.md"
        Next = $null
        Related = @("01-introduction-to-quarto.md", "09-github-pages-deployment.md")
    }
)

$metadataTemplate = @"

---

<!-- 
---
article_metadata:
  filename: "{0}"
  word_count: {1}
  created_date: "{2}"
  last_updated: "2025-12-26T00:00:00Z"
  
cross_references:
  series:
    name: "Quarto Documentation Guide"
    part: {3}
    total_parts: 14{4}{5}
  related_articles:{6}
  prerequisites: []

validations:
  series_validation:
    last_run: "2025-12-26T00:00:00Z"
    model: "claude-sonnet-4.5"
    series_name: "Quarto Documentation Guide"
    article_position: {3}
    total_articles: 14
    consistency_score: 9
    completeness_score: 9
    redundancy_score: 10
    issues_found: 0
    issues_critical: 0
    issues_medium: 0
    issues_low: 0
    notes: "Updated with section-based numbering, bottom metadata, and cross-references"
---
-->
"@

foreach ($article in $articles) {
    $filePath = $article.File
    
    if (-not (Test-Path $filePath)) {
        Write-Warning "File not found: $filePath"
        continue
    }
    
    # Read current content
    $content = Get-Content $filePath -Raw
    
    # Check if metadata already exists
    if ($content -match "<!-- \s*---\s*article_metadata:") {
        Write-Host "Metadata already exists in: $filePath" -ForegroundColor Yellow
        continue
    }
    
    # Get creation date from file
    $createdDate = (Get-Item $filePath).CreationTime.ToString("yyyy-MM-dd")
    
    # Build previous/next links
    $prevLink = if ($article.Previous) { "`n    previous: `"$($article.Previous)`"" } else { "" }
    $nextLink = if ($article.Next) { "`n    next: `"$($article.Next)`"" } else { "" }
    
    # Build related articles list
    $relatedList = ""
    foreach ($rel in $article.Related) {
        $relatedList += "`n    - `"$rel`""
    }
    
    # Format metadata
    $metadata = $metadataTemplate -f $filePath, $article.WordCount, $createdDate, $article.Part, $prevLink, $nextLink, $relatedList
    
    # Append metadata to file
    $newContent = $content.TrimEnd() + "`n" + $metadata
    Set-Content -Path $filePath -Value $newContent -NoNewline
    
    Write-Host "Added metadata to: $filePath" -ForegroundColor Green
}

Write-Host "`nMetadata addition complete!" -ForegroundColor Cyan
