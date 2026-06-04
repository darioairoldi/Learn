$f = '03.00-tech\05.02-prompt-engineering\05-analysis\31-self-maintaining-prompt-engineering-pe-meta-implementation.md'
$hits = Select-String -Path $f -Pattern '\bD(3[0-5]|[12][0-9]|[1-9])\b(?!-[a-z])' -AllMatches
$filtered = $hits | Where-Object {
  $_.Line -notmatch '<group\|D#>' -and
  $_.Line -notmatch '^\| v\d' -and
  $_.Line -notmatch '"v\d+\.\d+' -and
  $_.Line -notmatch '^>\s*\*\*Most recent'
}
Write-Host ("Total: {0}; Filtered: {1}" -f $hits.Count, $filtered.Count)
$filtered | Select-Object -First 30 | ForEach-Object {
  Write-Host ("  L{0}: {1}" -f $_.LineNumber, $_.Line.Substring(0,[Math]::Min(140,$_.Line.Length)))
}
