<#
.SYNOPSIS
    Generates original Build-style session title images (black background, color
    mosaic on the right, readable monospace title on the left, no Microsoft logo).

.DESCRIPTION
    For each session summary.md the script:
      1. Reads the H1 heading ("CODE: Title") to get the session code and title.
      2. Renders an original 1280x720 PNG to images/001.01-session-title.png.
         - The title text is drawn as a true text layer (crisp/readable).
         - The mosaic is kept clear of (and thinned around) the title text band.
      3. Updates the summary.md image reference to the .png.
      4. Removes the previously copied .jpg/.jpeg source image (unless -KeepOld).

    Nothing is copied from Microsoft source slides; every image is drawn from scratch.

.PARAMETER Root
    Root folder containing the Build 2026 session folders.

.PARAMETER Folder
    Optional single session folder to (re)generate instead of all sessions.

.PARAMETER KeepOld
    Keep the old .jpg/.jpeg/stray image.png files instead of deleting them.

.EXAMPLE
    ./generate-session-title.ps1
    Regenerate every Build 2026 session title image.

.EXAMPLE
    ./generate-session-title.ps1 -Folder '...\dem375-so-you-want-to-become-an-mvp'
    Regenerate a single session.
#>
[CmdletBinding()]
param(
    [string]$Root = (Join-Path $PSScriptRoot '..\02.00-events\202606-build-2026'),
    [string]$Folder,
    [switch]$KeepOld
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$Palette = @(
    [System.Drawing.Color]::FromArgb(91, 197, 0),    # green
    [System.Drawing.Color]::FromArgb(0, 164, 239),   # blue
    [System.Drawing.Color]::FromArgb(242, 80, 34),   # orange-red
    [System.Drawing.Color]::FromArgb(255, 185, 0),   # yellow
    [System.Drawing.Color]::FromArgb(232, 17, 35),   # red
    [System.Drawing.Color]::FromArgb(134, 97, 197),  # purple
    [System.Drawing.Color]::FromArgb(0, 183, 195),   # teal
    [System.Drawing.Color]::FromArgb(0, 120, 212)    # dark blue
)

function New-TitleImage {
    param(
        [Parameter(Mandatory)][string]$Code,
        [Parameter(Mandatory)][string]$Title,
        [string]$Speakers = '',
        [Parameter(Mandatory)][string]$OutPath
    )

    $W = 1280; $H = 720
    $bmp = New-Object System.Drawing.Bitmap($W, $H)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $black = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0, 0, 0))
    $g.FillRectangle($black, 0, 0, $W, $H)

    # --- Adaptive word-wrap for the title ---
    $marginX = 66
    $maxTextWidth = 660
    $fontSizes = 46, 40, 36, 32, 28, 24, 22, 20
    $titleFont = $null
    $lines = $null
    foreach ($fs in $fontSizes) {
        $f = New-Object System.Drawing.Font('Consolas', $fs, [System.Drawing.FontStyle]::Bold)
        $words = $Title -split '\s+'
        $cur = ''
        $wrapped = New-Object System.Collections.Generic.List[string]
        foreach ($word in $words) {
            $candidate = if ($cur -eq '') { $word } else { "$cur $word" }
            if ($g.MeasureString($candidate, $f).Width -le $maxTextWidth) {
                $cur = $candidate
            }
            else {
                if ($cur -ne '') { $wrapped.Add($cur) }
                $cur = $word
            }
        }
        if ($cur -ne '') { $wrapped.Add($cur) }
        if ($wrapped.Count -le 6) { $titleFont = $f; $lines = $wrapped; break }
        $f.Dispose()
    }
    if ($null -eq $titleFont) {
        $titleFont = New-Object System.Drawing.Font('Consolas', 20, [System.Drawing.FontStyle]::Bold)
        $lines = $wrapped
    }

    $lineHeight = [int]($titleFont.GetHeight($g) * 1.12)
    $titleBlockHeight = $lineHeight * $lines.Count

    # --- Wrap speakers (max 2 lines) ---
    $spkFont = New-Object System.Drawing.Font('Segoe UI', 19, [System.Drawing.FontStyle]::Regular)
    $spkLines = New-Object System.Collections.Generic.List[string]
    if ($Speakers -and $Speakers.Trim() -ne '') {
        $words = $Speakers -split '\s+'
        $cur = ''
        foreach ($word in $words) {
            $candidate = if ($cur -eq '') { $word } else { "$cur $word" }
            if ($g.MeasureString($candidate, $spkFont).Width -le $maxTextWidth) {
                $cur = $candidate
            }
            else {
                if ($cur -ne '') { $spkLines.Add($cur) }
                $cur = $word
            }
        }
        if ($cur -ne '') { $spkLines.Add($cur) }
        while ($spkLines.Count -gt 2) {
            $spkLines[1] = ($spkLines[1].TrimEnd('.', ' ') + '…')
            $spkLines.RemoveAt($spkLines.Count - 1)
        }
    }
    $spkLineHeight = [int]($spkFont.GetHeight($g) * 1.15)
    $spkGap = if ($spkLines.Count -gt 0) { 26 } else { 0 }
    $spkBlockHeight = $spkLineHeight * $spkLines.Count

    $blockHeight = $titleBlockHeight + $spkGap + $spkBlockHeight
    $regionTop = 180; $regionBottom = 560
    $blockTop = [int](($regionTop + $regionBottom) / 2 - $blockHeight / 2)
    if ($blockTop -lt $regionTop) { $blockTop = $regionTop }

    # --- Mosaic on the right, kept clear of the title text band ---
    $rand = New-Object System.Random 20260612
    $cell = 44
    $startX = 760
    $textTop = $blockTop - 20
    $textBottom = $blockTop + $blockHeight + 20
    $textBandStartX = 1080
    for ($x = $startX; $x -lt $W; $x += $cell) {
        for ($y = 0; $y -lt $H; $y += $cell) {
            $inText = ($y + $cell -gt $textTop) -and ($y -lt $textBottom)
            $minX = if ($inText) { $textBandStartX } else { $startX }
            if ($x -lt $minX) { continue }
            $t = ($x - $startX) / ($W - $startX)
            $p = 0.30 + 0.60 * $t
            if ($inText) { $p = $p * 0.45 }   # thin near the text level
            if ($rand.NextDouble() -lt $p) {
                $c = $Palette[$rand.Next(0, $Palette.Count)]
                $brush = New-Object System.Drawing.SolidBrush $c
                $g.FillRectangle($brush, $x, $y, $cell - 3, $cell - 3)
                $brush.Dispose()
            }
        }
    }

    # --- Session code badge (dynamic width) ---
    $badgeFont = New-Object System.Drawing.Font('Consolas', 20, [System.Drawing.FontStyle]::Bold)
    $codeSize = $g.MeasureString($Code, $badgeFont)
    $bw = [int]($codeSize.Width + 36)
    $bh = 46
    $badgeBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0, 120, 212))
    $badgeRect = New-Object System.Drawing.Rectangle $marginX, 90, $bw, $bh
    $r = 10
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($badgeRect.X, $badgeRect.Y, $r * 2, $r * 2, 180, 90)
    $path.AddArc($badgeRect.Right - $r * 2, $badgeRect.Y, $r * 2, $r * 2, 270, 90)
    $path.AddArc($badgeRect.Right - $r * 2, $badgeRect.Bottom - $r * 2, $r * 2, $r * 2, 0, 90)
    $path.AddArc($badgeRect.X, $badgeRect.Bottom - $r * 2, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    $g.FillPath($badgeBrush, $path)

    $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($Code, $badgeFont, $white, [System.Drawing.RectangleF]::op_Implicit($badgeRect), $sf)

    # --- Title text ---
    $cyan = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0, 229, 229))
    $y = $blockTop
    foreach ($ln in $lines) {
        $g.DrawString($ln, $titleFont, $cyan, $marginX, $y)
        $y += $lineHeight
    }

    # --- Speakers (under the title) ---
    if ($spkLines.Count -gt 0) {
        $y += $spkGap
        $spkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(190, 190, 190))
        foreach ($ln in $spkLines) {
            $g.DrawString($ln, $spkFont, $spkBrush, $marginX, $y)
            $y += $spkLineHeight
        }
    }

    # --- Event caption (plain text, no logo) ---
    $capFont = New-Object System.Drawing.Font('Consolas', 16, [System.Drawing.FontStyle]::Regular)
    $gray = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(150, 150, 150))
    $g.DrawString('BUILD 2026', $capFont, $gray, $marginX, 620)

    $dir = Split-Path $OutPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}

function Get-SessionSpeakers {
    param([Parameter(Mandatory)][string]$SummaryPath)

    $lines = Get-Content $SummaryPath
    $names = New-Object System.Collections.Generic.List[string]
    $inSection = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^##\s+Speakers?\s*$') { $inSection = $true; continue }
        if ($inSection) {
            if ($line -match '^#{1,6}\s+\S') { break }   # next heading ends the section
            $b = [regex]::Match($line, '^\s*[-*]\s+(.+)$')
            if (-not $b.Success) { continue }
            $entry = $b.Groups[1].Value

            # Prefer a bold-wrapped name, else take text before " - ".
            $bold = [regex]::Match($entry, '\*\*([^*]+)\*\*')
            if ($bold.Success) {
                $n = $bold.Groups[1].Value
            }
            else {
                $n = ($entry -split '\s[-–]\s')[0]
            }
            $n = ($n -replace '[*_`]', '').Trim().TrimEnd(',', ' ')
            if ($n -ne '') { $names.Add($n) }
        }
    }

    if ($names.Count -eq 0) { return '' }

    # Dedupe, preserve order.
    $seen = @{}
    $uniq = New-Object System.Collections.Generic.List[string]
    foreach ($n in $names) {
        if (-not $seen.ContainsKey($n.ToLower())) { $seen[$n.ToLower()] = $true; $uniq.Add($n) }
    }

    if ($uniq.Count -le 3) { return ($uniq -join ', ') }
    return (($uniq[0..1] -join ', ') + ', and ' + ($uniq.Count - 2) + ' more')
}

# --- Enumerate target sessions ---
if ($Folder) {
    $summaries = @(Get-Item (Join-Path $Folder 'summary.md'))
}
else {
    $summaries = Get-ChildItem -Path $Root -Recurse -Filter 'summary.md'
}
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$count = 0
foreach ($s in $summaries) {
    $raw = [System.IO.File]::ReadAllText($s.FullName)
    $h1 = ([regex]::Match($raw, '(?m)^#\s+(.+?)\s*$')).Groups[1].Value
    $cm = [regex]::Match($h1, '^\s*([A-Za-z0-9.\-]+)\s*:\s*(.+)$')
    if ($cm.Success) {
        $code = $cm.Groups[1].Value.ToUpper()
        $title = $cm.Groups[2].Value.Trim()
    }
    else {
        $code = (($s.Directory.Name -split '-')[0]).ToUpper()
        $title = $h1
    }

    $imgDir = Join-Path $s.Directory.FullName 'images'
    $outPng = Join-Path $imgDir '001.01-session-title.png'
    $speakers = Get-SessionSpeakers -SummaryPath $s.FullName
    New-TitleImage -Code $code -Title $title -Speakers $speakers -OutPath $outPng

    # Update the markdown image reference -> .png
    $new = $raw -replace 'images/001\.01-session-title\.(jpe?g)', 'images/001.01-session-title.png'
    # Normalize the non-standard key01 reference
    $escTitle = $title
    $new = $new -replace '!\[alt text\]\(image\.png\)', ('![{0}](images/001.01-session-title.png)' -f $escTitle)
    if ($new -ne $raw) {
        [System.IO.File]::WriteAllText($s.FullName, $new, $utf8NoBom)
    }

    if (-not $KeepOld) {
        foreach ($old in @('001.01-session-title.jpg', '001.01-session-title.jpeg')) {
            $p = Join-Path $imgDir $old
            if (Test-Path $p) { Remove-Item $p -Force }
        }
        # stray root image.png used only by key01
        $strayPng = Join-Path $s.Directory.FullName 'image.png'
        if ((Test-Path $strayPng) -and ($raw -match '!\[alt text\]\(image\.png\)')) {
            Remove-Item $strayPng -Force
        }
    }

    $count++
}

Write-Host "Generated $count session title image(s)."
