@echo off
echo Verifying Simulanis Auto Login Installer contents...

REM Check if the installer exists
if not exist "SimulanisAutoLogin_Setup.exe" (
    echo Error: SimulanisAutoLogin_Setup.exe not found
    echo Please run build_installer.bat first.
    goto END
)

REM Create test extraction directory
set EXTRACT_DIR=ExtractTest
if exist "%EXTRACT_DIR%" rmdir /s /q "%EXTRACT_DIR%"
mkdir "%EXTRACT_DIR%"

REM Try to extract using NSIS's built-in extraction
echo Extracting installer contents to %EXTRACT_DIR%...
SimulanisAutoLogin_Setup.exe /S /D=%CD%\%EXTRACT_DIR%

REM Check if extraction worked
if not exist "%EXTRACT_DIR%\Icons" (
    echo Icons directory not found in extraction.
    echo Trying alternate extraction method...
    
    REM Try to use 7-Zip if available
    where 7z >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Using 7-Zip for extraction...
        rmdir /s /q "%EXTRACT_DIR%"
        mkdir "%EXTRACT_DIR%"
        7z x -o"%EXTRACT_DIR%" SimulanisAutoLogin_Setup.exe
    ) else (
        echo Warning: 7-Zip not found. Cannot extract installer contents.
        echo Please install 7-Zip or manually check the installer.
        goto END
    )
)

REM Check for icon and logo files
echo.
echo Checking for Icons in the installer:
if exist "%EXTRACT_DIR%\Icons" (
    echo Icons directory found!
    echo Contents:
    dir /b "%EXTRACT_DIR%\Icons"
) else (
    echo ERROR: Icons directory NOT found in installer!
)

echo.
echo Checking for Logos in the installer:
if exist "%EXTRACT_DIR%\Logos" (
    echo Logos directory found!
    echo Contents:
    dir /b "%EXTRACT_DIR%\Logos"
) else (
    echo ERROR: Logos directory NOT found in installer!
)

echo.
echo Verification summary:
if exist "%EXTRACT_DIR%\Icons" (
    if exist "%EXTRACT_DIR%\Logos" (
        echo SUCCESS: Both Icons and Logos directories found in the installer.
        echo The installer is correctly packaged with all required resources.
    ) else (
        echo PARTIAL: Icons found but Logos missing.
    )
) else (
    if exist "%EXTRACT_DIR%\Logos" (
        echo PARTIAL: Logos found but Icons missing.
    ) else (
        echo FAILED: Neither Icons nor Logos directories found in the installer.
        echo You may need to fix the NSIS script or check the source directories.
    )
)

:END
pause 