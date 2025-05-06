# Script to extract and verify the Simulanis Auto Login installer contents
$ErrorActionPreference = "Stop"

# Create an output directory
$extractDir = ".\ExtractedContents"
New-Item -Path $extractDir -ItemType Directory -Force | Out-Null

Write-Host "Extracting installer contents to $extractDir..." -ForegroundColor Green

# Use 7-Zip if available
$7zipPath = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $7zipPath) {
    Write-Host "Using 7-Zip to extract files..." -ForegroundColor Cyan
    & $7zipPath x -o"$extractDir" "..\SimulanisAutoLogin_Setup.exe"
} else {
    Write-Host "7-Zip not found. Using built-in extraction..." -ForegroundColor Yellow
    # Alternative extraction using PowerShell (may not work for all NSIS installers)
    Copy-Item "..\SimulanisAutoLogin_Setup.exe" "$extractDir\installer.exe"
    Set-Location $extractDir
    # Try to run with /NCRC /S to extract files
    Start-Process -FilePath ".\installer.exe" -ArgumentList "/NCRC", "/S" -NoNewWindow -Wait
}

# Check for the expected directories and files
Write-Host "Checking for expected directories and files:" -ForegroundColor Green

$directories = @("$extractDir\Icons", "$extractDir\Logos")
$files = @(
    "$extractDir\SimulanisLogin.exe",
    "$extractDir\config.json"
)

foreach ($dir in $directories) {
    if (Test-Path $dir) {
        Write-Host "Directory found: $dir" -ForegroundColor Green
        $items = Get-ChildItem -Path $dir
        $itemCount = ($items | Measure-Object).Count
        Write-Host "  Contents: $itemCount items" -ForegroundColor Cyan
        foreach ($item in $items) {
            Write-Host "    - $($item.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "Directory missing: $dir" -ForegroundColor Red
    }
}

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "File found: $file" -ForegroundColor Green
    } else {
        Write-Host "File missing: $file" -ForegroundColor Red
    }
}

Write-Host "Verification complete." -ForegroundColor Green 