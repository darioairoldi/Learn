param(
    [string]$BasePath = "e:\dev.darioa.live\darioairoldi\Learn\03.00-tech\05.02-prompt-engineering",
    [switch]$DryRun
)

$cp1252 = [System.Text.Encoding]::GetEncoding(1252)
$fixedCount = 0
$skipCount = 0
$errorCount = 0

# Double-encoded UTF-8 detection using text-level patterns.
# When UTF-8 bytes are read as Windows-1252 and saved back as UTF-8,
# recognizable character sequences appear. We check for these sequences
# at the text level (after UTF-8 decoding) which is more reliable than
# scanning raw bytes.
#
# Key patterns (what the garbled text looks like):
#   Em-dash (—):  â€" = U+00E2 U+20AC U+201D
#   En-dash (–):  â€" = U+00E2 U+20AC U+201C  (same start, different end)
#   Right quote:  â€™ = â + €™
#   Left d-quote: â€œ = â + €œ
#   Right d-quote: ends with â€ + next char
#   Box-drawing:  â"Œ, â"‚, â"œ, â"", etc.
#   Emojis:       ðŸ... (starts with ð = U+00F0)

function Test-HasMojibake {
    param([string]$Text)
    
    # Check for â (U+00E2) followed by smart-quote/currency chars
    # that are hallmarks of double-encoded UTF-8 through Windows-1252
    $e2 = [char]0x00E2  # â
    $euroSign = [char]0x20AC  # € (from CP1252 0x80)
    $ldquo = [char]0x201C  # " (from CP1252 0x93)
    $rdquo = [char]0x201D  # " (from CP1252 0x94)
    $lsquo = [char]0x2018  # ' (from CP1252 0x91)
    $rsquo = [char]0x2019  # ' (from CP1252 0x92)
    $sbquo = [char]0x201A  # ‚ (from CP1252 0x82)
    $f0 = [char]0x00F0    # ð (start of double-encoded emoji/4-byte UTF-8)
    $yDiaer = [char]0x0178  # Ÿ (from CP1252 0x9F)
    
    # Double-encoded em-dash/en-dash: â€" â€" (â followed by €)
    if ($Text.Contains("$e2$euroSign")) { return $true }
    
    # Double-encoded smart quotes: â€™ â€˜ â€œ â€ (â followed by €)
    # Already covered by the â€ pattern above
    
    # Double-encoded box-drawing: â"Œ â"‚ â"œ â"" (â followed by " or " or ')
    if ($Text.Contains("$e2$ldquo") -or $Text.Contains("$e2$rdquo") -or
        $Text.Contains("$e2$lsquo") -or $Text.Contains("$e2$rsquo") -or
        $Text.Contains("$e2$sbquo")) { return $true }
    
    # Double-encoded emoji: ðŸ (ð followed by Ÿ)
    if ($Text.Contains("$f0$yDiaer")) { return $true }
    
    return $false
}

Get-ChildItem -Path $BasePath -Recurse -Filter "*.md" | ForEach-Object {
    $file = $_.FullName
    $fileName = $_.Name
    $bytes = [System.IO.File]::ReadAllBytes($file)
    
    # Detect BOM
    $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    $offset = if ($hasBom) { 3 } else { 0 }
    $contentBytes = $bytes[$offset..($bytes.Length - 1)]
    
    # Decode as UTF-8 (garbled text)
    $garbled = [System.Text.Encoding]::UTF8.GetString($contentBytes)
    
    if (-not (Test-HasMojibake -Text $garbled)) {
        $skipCount++
        Write-Host "SKIP: $fileName"
        return
    }
    
    try {
        # Encode to Windows-1252 to recover original UTF-8 bytes
        $origBytes = $cp1252.GetBytes($garbled)
        # Decode those bytes as UTF-8 to get correct text
        $fixed = [System.Text.Encoding]::UTF8.GetString($origBytes)
        
        if ($DryRun) {
            Write-Host "WOULD FIX: $fileName"
        }
        else {
            # Write back
            $outBytes = [System.Text.Encoding]::UTF8.GetBytes($fixed)
            if ($hasBom) {
                $outBytes = [byte[]]@(0xEF, 0xBB, 0xBF) + $outBytes
            }
            [System.IO.File]::WriteAllBytes($file, $outBytes)
            Write-Host "FIXED: $fileName"
        }
        $fixedCount++
    }
    catch {
        $errorCount++
        Write-Host "ERROR: $fileName - $_"
    }
}

$action = if ($DryRun) { "Would fix" } else { "Fixed" }
Write-Host "`n=== DONE (Phase 1 - CP1252): $action=$fixedCount Skipped=$skipCount Errors=$errorCount ==="

# Phase 2: Fix CP437 mojibake (ΓöÉ → ┐)
# This is a simple text replacement for box-drawing characters
# that were garbled through CP437 encoding
$cp437FixCount = 0
Get-ChildItem -Path $BasePath -Recurse -Filter "*.md" | ForEach-Object {
    $file = $_.FullName
    $fileName = $_.Name
    $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
    
    $newContent = $content
    # CP437 mojibake mappings (UTF-8 bytes read as CP437)
    $newContent = $newContent.Replace([string][char]0x0393 + [string][char]0x00F6 + [string][char]0x00C9, [string][char]0x2510)  # ΓöÉ → ┐
    
    if ($newContent -ne $content) {
        if ($DryRun) {
            Write-Host "WOULD FIX (CP437): $fileName"
        }
        else {
            [System.IO.File]::WriteAllText($file, $newContent, [System.Text.Encoding]::UTF8)
            Write-Host "FIXED (CP437): $fileName"
        }
        $cp437FixCount++
    }
}
Write-Host "`n=== DONE (Phase 2 - CP437): $action=$cp437FixCount files ==="
Write-Host "=== TOTAL: Phase1=$fixedCount Phase2=$cp437FixCount ==="
