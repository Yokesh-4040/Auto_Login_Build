@echo off
echo Testing paths to Icons and Logos directories

echo.
echo Checking v1.2.1\Icons directory:
if exist "..\v1.2.1\Icons" (
    echo FOUND: ..\v1.2.1\Icons
    dir "..\v1.2.1\Icons"
) else (
    echo NOT FOUND: ..\v1.2.1\Icons
)

echo.
echo Checking v1.2.1\Logos directory:
if exist "..\v1.2.1\Logos" (
    echo FOUND: ..\v1.2.1\Logos
    dir "..\v1.2.1\Logos"
) else (
    echo NOT FOUND: ..\v1.2.1\Logos
)

echo.
echo Testing complete.
pause 