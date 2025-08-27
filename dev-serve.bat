@echo off
echo ======================================
echo  Quarto Local Development Environment
echo ======================================

echo.
echo [1/3] Checking navigation.json...
powershell -ExecutionPolicy Bypass -File "scripts/generate-navigation.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to generate navigation.json
    echo Check the console output above for details.
    pause
    exit /b 1
)

echo.
echo [2/3] Starting Quarto preview server...
echo This will open your browser automatically.
echo Press Ctrl+C to stop the server when done.
echo.

quarto preview

echo.
echo [3/3] Quarto preview stopped.
echo.
pause