@echo off
echo Simulanis Auto Login Installer Creation Tool
echo =========================================
echo.

echo Step 1: Building the installer...
call build_installer.bat

echo.
echo Step 2: Verifying the installer contents...
call verify_installer.bat

echo.
echo Installer creation process complete.
echo If successful, your installer is ready at: %CD%\SimulanisAutoLogin_Setup.exe

pause 