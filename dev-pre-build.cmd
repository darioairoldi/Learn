@echo off
REM ===========================================================================
REM  dev-pre-build.cmd
REM
REM  Pre-build step for local authoring:
REM   1. Scans the repo for JPEG images larger than a threshold (default 512 KB).
REM   2. Creates a web-optimized sibling "<name>.web.jpg" (quality 82, longest
REM      side <= 2000 px). Never upscales; if compression does not shrink the
REM      file, the .web copy keeps the original bytes.
REM   3. Rewrites Markdown/Quarto image references from "<name>.jpg" to
REM      "<name>.web.jpg" (only where the .web file exists).
REM
REM  Uses Windows PowerShell 5.1 (System.Drawing). Pass-through args are
REM  forwarded to the script, e.g.:
REM     dev-pre-build.cmd -MinSizeKB 512 -Quality 82 -MaxDimension 2000
REM     dev-pre-build.cmd -NoMarkdown          (compress only, skip .md rewrite)
REM     dev-pre-build.cmd -WhatIf              (preview, change nothing)
REM ===========================================================================
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\pre-build-images.ps1" -Root "%~dp0." %*
set EXITCODE=%ERRORLEVEL%
endlocal & exit /b %EXITCODE%
