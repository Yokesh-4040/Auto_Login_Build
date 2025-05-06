@echo off
echo Building installer using direct NSIS call...
echo =========================================
echo.

REM Try to build with standard NSIS path - no variables
echo Trying to build with Program Files (x86) path...
"C:\Program Files (x86)\NSIS\makensis.exe" SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Installer built using Program Files (x86) NSIS.
    goto VERIFY
)

echo.
echo Trying to build with Program Files path...
"C:\Program Files\NSIS\makensis.exe" SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Installer built using Program Files NSIS.
    goto VERIFY
)

echo.
echo Trying to build with local NSIS path...
"NSIS\makensis.exe" SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Installer built using local NSIS.
    goto VERIFY
)

echo.
echo Failed to build the installer with any NSIS path.
echo Please install NSIS or check its installation path.
goto END

:VERIFY
echo.
echo Checking installer file:
if exist "SimulanisAutoLogin_Setup.exe" (
    echo Installer created successfully: %CD%\SimulanisAutoLogin_Setup.exe
    echo Size:
    dir SimulanisAutoLogin_Setup.exe | findstr /C:"SimulanisAutoLogin_Setup.exe"
) else (
    echo ERROR: Installer file was not created despite successful return code.
)

:END
pause 