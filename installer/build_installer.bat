@echo off
echo Building Simulanis Auto Login Installer...

REM Check if the Icons and Logos directories exist
echo Verifying required files and directories...
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

REM Check for makensis.exe in several possible locations
SET FOUND_NSIS=0

REM Try the local NSIS directory
IF EXIST "NSIS\makensis.exe" (
    echo Using local NSIS installation
    SET "NSIS_EXE=NSIS\makensis.exe" 
    SET FOUND_NSIS=1
    GOTO BUILD
)

REM Try the relative path with proper quoting
IF EXIST ".\NSIS\makensis.exe" (
    echo Using local NSIS installation (relative path)
    SET "NSIS_EXE=.\NSIS\makensis.exe"
    SET FOUND_NSIS=1
    GOTO BUILD
)

REM Try the standard location
IF EXIST "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo Using NSIS from C:\Program Files (x86)\NSIS
    SET "NSIS_EXE=C:\Program Files (x86)\NSIS\makensis.exe"
    SET FOUND_NSIS=1
    GOTO BUILD
)

REM Try the 64-bit Program Files location
IF EXIST "C:\Program Files\NSIS\makensis.exe" (
    echo Using NSIS from C:\Program Files\NSIS
    SET "NSIS_EXE=C:\Program Files\NSIS\makensis.exe"
    SET FOUND_NSIS=1
    GOTO BUILD
)

REM If we haven't found NSIS yet, we've got a problem
IF %FOUND_NSIS% EQU 0 (
    echo Error: Could not find makensis.exe
    echo Please install NSIS or copy makensis.exe to this directory.
    GOTO END
)

:BUILD
REM Build the installer
echo Running: "%NSIS_EXE%" SimulanisAutoLogin.nsi
"%NSIS_EXE%" SimulanisAutoLogin.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installer built successfully: SimulanisAutoLogin_Setup.exe
    
    REM Verify the installer contains the required files
    echo Checking installer contents...
    if exist "SimulanisAutoLogin_Setup.exe" (
        echo Installer created successfully.
        echo To test if Icons and Logos are included, run: verify_installer.bat
    ) else (
        echo Warning: Installer file was not created.
    )
) else (
    echo.
    echo Error building installer
)

:END
pause 