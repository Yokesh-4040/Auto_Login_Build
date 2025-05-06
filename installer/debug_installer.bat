@echo off
echo ===== Simulanis Auto Login Installer Debug Tool =====
echo Creating debug report to help diagnose installer issues...
echo.

set LOG_FILE=installer_debug_log.txt
echo Debug Report - %date% %time% > %LOG_FILE%
echo ================================== >> %LOG_FILE%
echo. >> %LOG_FILE%

echo 1. Checking environment...
echo 1. ENVIRONMENT DETAILS >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%
echo Current directory: %CD% >> %LOG_FILE%
echo NSIS directories: >> %LOG_FILE%
if exist "NSIS\makensis.exe" echo - Found local NSIS: NSIS\makensis.exe >> %LOG_FILE%
if exist "C:\Program Files (x86)\NSIS\makensis.exe" echo - Found system NSIS: C:\Program Files (x86)\NSIS\makensis.exe >> %LOG_FILE%
if exist "C:\Program Files\NSIS\makensis.exe" echo - Found 64-bit NSIS: C:\Program Files\NSIS\makensis.exe >> %LOG_FILE%

echo. >> %LOG_FILE%
echo 2. Checking required directories...
echo 2. REQUIRED DIRECTORIES >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%

cd ..
echo Parent directory: %CD% >> %LOG_FILE%
echo. >> %LOG_FILE%

echo Icons directory: >> %LOG_FILE%
if exist "v1.2.1\Icons" (
    echo - FOUND: v1.2.1\Icons >> %LOG_FILE%
    echo - Contents: >> %LOG_FILE%
    dir /b "v1.2.1\Icons" >> %LOG_FILE%
) else (
    echo - MISSING: v1.2.1\Icons directory not found >> %LOG_FILE%
)

echo. >> %LOG_FILE%
echo Logos directory: >> %LOG_FILE%
if exist "v1.2.1\Logos" (
    echo - FOUND: v1.2.1\Logos >> %LOG_FILE%
    echo - Contents: >> %LOG_FILE%
    dir /b "v1.2.1\Logos" >> %LOG_FILE%
) else (
    echo - MISSING: v1.2.1\Logos directory not found >> %LOG_FILE%
)

echo. >> %LOG_FILE%
cd installer
echo Returned to installer directory: %CD% >> %LOG_FILE%

echo 3. Checking NSIS script...
echo 3. NSIS SCRIPT VERIFICATION >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%
echo NSIS script content: >> %LOG_FILE%
type SimulanisAutoLogin.nsi >> %LOG_FILE%

echo. >> %LOG_FILE%
echo 4. Initiating verbose build...
echo 4. VERBOSE BUILD LOG >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%

if exist "NSIS\makensis.exe" (
    echo Using local NSIS for verbose build >> %LOG_FILE%
    NSIS\makensis.exe /V4 SimulanisAutoLogin.nsi >> %LOG_FILE% 2>&1
) else if exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo Using system NSIS for verbose build >> %LOG_FILE%
    "C:\Program Files (x86)\NSIS\makensis.exe" /V4 SimulanisAutoLogin.nsi >> %LOG_FILE% 2>&1
) else if exist "C:\Program Files\NSIS\makensis.exe" (
    echo Using 64-bit NSIS for verbose build >> %LOG_FILE%
    "C:\Program Files\NSIS\makensis.exe" /V4 SimulanisAutoLogin.nsi >> %LOG_FILE% 2>&1
) else (
    echo ERROR: No NSIS installation found >> %LOG_FILE%
)

echo. >> %LOG_FILE%
echo 5. Checking installer output...
echo 5. INSTALLER OUTPUT >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%
if exist "SimulanisAutoLogin_Setup.exe" (
    echo - FOUND: Installer was created >> %LOG_FILE%
    echo - File size: >> %LOG_FILE%
    dir SimulanisAutoLogin_Setup.exe >> %LOG_FILE%
) else (
    echo - MISSING: Installer was not created >> %LOG_FILE%
)

echo.
echo Debug complete! Report saved to: %LOG_FILE%
echo Please check this file for details about what might be going wrong.

echo.
echo 6. RECOMMENDATION: >> %LOG_FILE%
echo -------------------- >> %LOG_FILE%
echo After reviewing this report, try the following: >> %LOG_FILE%
echo 1. Make sure the Icons and Logos directories exist in v1.2.1 >> %LOG_FILE%
echo 2. Try rebuilding with the updated script >> %LOG_FILE%
echo 3. Use verify_installer.bat to verify the contents >> %LOG_FILE%

pause 