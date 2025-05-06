@echo off
echo Copying resource files for NSIS installer...
echo This script ensures icons and logos are in the correct location for the installer.

REM Check source directories exist
cd ..
if not exist "v1.2.1\Icons" (
    echo ERROR: Source directory v1.2.1\Icons not found!
    goto END
)

if not exist "v1.2.1\Logos" (
    echo ERROR: Source directory v1.2.1\Logos not found!
    goto END
)

REM Create temporary directories in the installer folder
cd installer
if not exist "Icons" mkdir Icons
if not exist "Logos" mkdir Logos

REM Copy all files to the installer directory
echo Copying Icons...
xcopy /y "..\v1.2.1\Icons\*.*" "Icons\"
echo Copying Logos...
xcopy /y "..\v1.2.1\Logos\*.*" "Logos\"

echo Resource files copied successfully!
echo.
echo Now running the installer build script...
call build_installer.bat

:END
pause 