@echo off
echo Building Simulanis Auto Login Installer...

REM Build the installer
"C:\Program Files (x86)\NSIS\makensis.exe" SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installer built successfully: SimulanisAutoLogin_Setup.exe
) else (
    echo.
    echo Error building installer
)

pause 