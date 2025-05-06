@echo off
echo Checking NSIS Installation...
echo ============================
echo.

echo Checking standard NSIS installation locations:

if exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo [FOUND] NSIS found at C:\Program Files (x86)\NSIS\makensis.exe
) else (
    echo [NOT FOUND] NSIS not found at C:\Program Files (x86)\NSIS\makensis.exe
)

if exist "C:\Program Files\NSIS\makensis.exe" (
    echo [FOUND] NSIS found at C:\Program Files\NSIS\makensis.exe
) else (
    echo [NOT FOUND] NSIS not found at C:\Program Files\NSIS\makensis.exe
)

if exist "NSIS\makensis.exe" (
    echo [FOUND] NSIS found at local NSIS\makensis.exe
) else (
    echo [NOT FOUND] NSIS not found at local NSIS\makensis.exe
)

echo.
echo Checking PATH environment for NSIS:
where makensis 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [FOUND] NSIS found in PATH environment variable
) else (
    echo [NOT FOUND] NSIS not found in PATH environment variable
)

echo.
echo NSIS Installation Summary:
echo -------------------------
if exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo NSIS is properly installed. You can use build_installer.bat
) else if exist "C:\Program Files\NSIS\makensis.exe" (
    echo NSIS is installed in C:\Program Files. Update build_installer.bat path.
) else if exist "NSIS\makensis.exe" (
    echo Local NSIS installation detected. build_installer.bat should work.
) else (
    echo NSIS not found. Please install NSIS from https://nsis.sourceforge.io/Download
    echo After installation, try running build_installer.bat again.
)

echo.
echo If you need to manually create the installer, run this command:
echo "C:\Program Files (x86)\NSIS\makensis.exe" SimulanisAutoLogin.nsi

pause 