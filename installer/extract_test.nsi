; Extract Test Script
!include "MUI2.nsh"

Name "Extract Test"
OutFile "ExtractTest.exe"
InstallDir "$TEMP\SimulanisExtractTest"

; Interface
!define MUI_ABORTWARNING

; Pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Language
!insertmacro MUI_LANGUAGE "English"

Section "Extract"
    SetOutPath "$INSTDIR"
    
    ; Extract files from the original installer
    DetailPrint "Extracting installer contents..."
    
    ; Use 7z.exe to extract the installer if available
    IfFileExists "$SYSDIR\7z.exe" 0 NoExtractor
    DetailPrint "Using 7z for extraction..."
    nsExec::Exec '"$SYSDIR\7z.exe" x -o"$INSTDIR" "SimulanisAutoLogin_Setup.exe"'
    Goto Done
    
    NoExtractor:
    DetailPrint "No extractor available."
    MessageBox MB_OK "Could not extract installer. 7-Zip not found."
    
    Done:
    DetailPrint "Extraction complete. Check $INSTDIR folder."
    ExecShell "open" "$INSTDIR"
SectionEnd 