@echo off
echo Verifying Simulanis Auto Login Installer contents...

REM Check if the installer exists
if not exist "SimulanisAutoLogin_Setup.exe" (
    echo Error: SimulanisAutoLogin_Setup.exe not found
    goto END
)

REM Create test directory
set TEST_DIR=TestExtract\ExtractedContents
if exist "%TEST_DIR%" rmdir /s /q "%TEST_DIR%"
mkdir "%TEST_DIR%"

REM Try to extract using 7-Zip (if available)
where 7z >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using 7-Zip to extract installer...
    7z x -o"%TEST_DIR%" "SimulanisAutoLogin_Setup.exe" >nul
) else (
    echo 7-Zip not found. Trying alternative extraction method...
    
    REM Try to run the installer with /S /D=%TEST_DIR% options for silent extract
    echo Using installer's extraction capability with /NCRC flag (to skip CRC check)...
    SimulanisAutoLogin_Setup.exe /NCRC /D=%TEST_DIR%
    
    if not exist "%TEST_DIR%" (
        echo No extraction methods available. Install 7-Zip or extract manually.
        echo You can download 7-Zip from: https://www.7-zip.org/
        goto END
    )
)

REM List everything extracted for debugging
echo.
echo All Extracted Files (for debugging):
dir /s /b "%TEST_DIR%" | find /v "NSIS"

REM Check for specific files that should be present
echo.
echo Checking for specific files that should be included:
set MISSING_FILES=0

REM Check main executable
if exist "%TEST_DIR%\$PLUGINSDIR\app-64.7z" (
    echo - Found app-64.7z archive (contains application files)
) else (
    set /a MISSING_FILES+=1
    echo - MISSING: app-64.7z archive
)

REM Check for extracted files
echo.
echo Checking all possible locations for Icons and Logos:

REM Check direct paths
if exist "%TEST_DIR%\Icons\*.png" (
    echo - Found Icons directory with PNG files
    echo   Contents:
    dir /b "%TEST_DIR%\Icons\*.png"
) else (
    echo - Icons directory not found at root level
)

if exist "%TEST_DIR%\Logos\*.png" (
    echo - Found Logos directory with PNG files
    echo   Contents:
    dir /b "%TEST_DIR%\Logos\*.png"
) else (
    echo - Logos directory not found at root level
)

REM Check in common NSIS extraction locations
if exist "%TEST_DIR%\$_OUTDIR\Icons\*.png" (
    echo - Found Icons directory in $_OUTDIR
    echo   Contents:
    dir /b "%TEST_DIR%\$_OUTDIR\Icons\*.png"
) else (
    echo - Icons directory not found in $_OUTDIR
)

if exist "%TEST_DIR%\$_OUTDIR\Logos\*.png" (
    echo - Found Logos directory in $_OUTDIR
    echo   Contents:
    dir /b "%TEST_DIR%\$_OUTDIR\Logos\*.png"
) else (
    echo - Logos directory not found in $_OUTDIR
)

REM Search for any PNG files recursively
echo.
echo Searching for any PNG files in the extracted content:
dir /s /b "%TEST_DIR%\*.png" | find /v "NSIS"

REM Summary
echo.
echo Verification Summary:
if %MISSING_FILES% GTR 0 (
    echo - WARNING: %MISSING_FILES% required files or directories are missing!
    echo - The installer may not work correctly. Please check the NSIS script.
) else (
    echo - All expected file structures found.
    echo - Next step: Test installing the application to verify functionality.
)

:END
pause 