@echo off
echo Building Simulanis Auto Login Installer...

REM Check if the Icons and Logos directories exist
echo Verifying required directories...
cd ..
if not exist "v1.2.1\Icons" (
    echo Error: Icons directory not found at v1.2.1\Icons
    echo Please ensure the Icons directory exists with all required icon files
    goto END
)

if not exist "v1.2.1\Logos" (
    echo Error: Logos directory not found at v1.2.1\Logos
    echo Please ensure the Logos directory exists with all required logo files
    goto END
)

echo Required directories verified successfully.
cd installer

REM Check for NSIS in different locations and use quotes to handle paths with spaces
set NSIS_PATH="C:\Program Files (x86)\NSIS\makensis.exe"

REM Check if NSIS exists in the standard location
if exist %NSIS_PATH% (
    echo Using NSIS from C:\Program Files (x86)\NSIS
) else (
    REM Try local NSIS directory
    if exist "NSIS\makensis.exe" (
        set NSIS_PATH="NSIS\makensis.exe"
        echo Using local NSIS installation
    ) else (
        echo Error: Could not find NSIS installation. 
        echo Please install NSIS to C:\Program Files (x86)\NSIS 
        echo or add NSIS folder to the installer directory.
        goto END
    )
)

REM Build the installer (with properly quoted path)
echo Running NSIS compiler...
%NSIS_PATH% SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installer built successfully: SimulanisAutoLogin_Setup.exe
    
    REM Verify the installer was created
    if exist "SimulanisAutoLogin_Setup.exe" (
        echo Installer file created: %CD%\SimulanisAutoLogin_Setup.exe
        echo Size: 
        dir SimulanisAutoLogin_Setup.exe | findstr /C:"SimulanisAutoLogin_Setup.exe"
    ) else (
        echo Warning: Installer file was not created.
    )
) else (
    echo.
    echo Error building installer. Error code: %ERRORLEVEL%
)

:END
pause 