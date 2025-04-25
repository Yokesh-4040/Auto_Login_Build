# Get the version from command line argument
param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

Write-Host "Creating build package for version: $Version"

# Set up paths
$sourceDir = Join-Path $PWD "$Version\SimulanisLogin"
$buildDir = Join-Path $PWD "releases\$Version\build"
$zipPath = Join-Path $PWD "releases\$Version\Simulanis_Auto_Login_${Version}_Build.zip"

Write-Host "Source directory: $sourceDir"
Write-Host "Build directory: $buildDir"
Write-Host "Zip path: $zipPath"

# Create build directory
New-Item -Path $buildDir -ItemType Directory -Force

# Check if source exists
if (-not (Test-Path $sourceDir)) {
    Write-Error "Source directory not found: $sourceDir"
    Write-Host "Current directory contents:"
    Get-ChildItem -Recurse | ForEach-Object { Write-Host $_.FullName }
    exit 1
}

# Copy files
Write-Host "Copying files..."
Copy-Item -Path "$sourceDir\SimulanisLogin.exe" -Destination $buildDir -Force
Copy-Item -Path "$sourceDir\config.json" -Destination "$buildDir\headless_config.json" -Force

# Copy directories
foreach ($dir in @("Icons", "Logos", "_internal")) {
    $sourcePath = Join-Path $sourceDir $dir
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $buildDir -Recurse -Force
        Write-Host "Copied $dir directory"
    } else {
        Write-Warning "Directory not found: $dir"
    }
}

# Create batch files
@"
@echo off
start "" "%~dp0SimulanisLogin.exe"
"@ | Out-File -FilePath "$buildDir\Start Simulanis Login.bat" -Encoding ASCII -Force

@"
@echo off
start "" "%~dp0SimulanisLogin.exe" --gui
"@ | Out-File -FilePath "$buildDir\Start Simulanis Login (GUI).bat" -Encoding ASCII -Force

Write-Host "Created batch files"

# Create zip file using 7-Zip if available, otherwise fall back to Compress-Archive
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $sevenZipPath) {
    Write-Host "Using 7-Zip to create archive"
    & $sevenZipPath a -tzip $zipPath "$buildDir\*"
} else {
    Write-Host "Using Compress-Archive"
    Compress-Archive -Path "$buildDir\*" -DestinationPath $zipPath -Force
}

# Verify zip file
if (Test-Path $zipPath) {
    $zipFile = Get-Item $zipPath
    Write-Host "Successfully created zip file: $($zipFile.FullName)"
    Write-Host "Size: $($zipFile.Length) bytes"
} else {
    Write-Error "Failed to create zip file"
    exit 1
}

# Cleanup
Remove-Item -Path $buildDir -Recurse -Force
Write-Host "Cleaned up build directory" 