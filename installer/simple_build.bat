@echo off
echo Building Simulanis Auto Login Installer...

cd /D "%~dp0"

echo Using NSIS from Program Files (x86)...
"C:\Program Files (x86)\NSIS\makensis.exe" SimulanisAutoLogin.nsi

echo.
echo Build command completed.
echo If successful, the installer file should be at:
echo %~dp0SimulanisAutoLogin_Setup.exe

pause 