; Simulanis Auto Login Installer Script
!include "MUI2.nsh"
!include "nsProcess.nsh"

; General
Name "Simulanis Auto Login"
OutFile "SimulanisAutoLogin_Setup.exe"
InstallDir "$PROGRAMFILES\Simulanis Auto Login"
InstallDirRegKey HKCU "Software\Simulanis Auto Login" ""

; Request application privileges
RequestExecutionLevel admin

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_FINISHPAGE_RUN "$INSTDIR\Simulanis Auto Login.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Launch Simulanis Auto Login"
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Add to Windows Startup"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION AddToStartup

; Define the config directory
!define CONFIG_DIR "$APPDATA\Simulanis Auto Login"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language
!insertmacro MUI_LANGUAGE "English"

; Function to add to startup
Function AddToStartup
    CreateShortCut "$SMSTARTUP\Simulanis Auto Login.lnk" "$INSTDIR\Simulanis Auto Login.exe"
FunctionEnd

Function .onInit
    ; Check if application is running
    nsProcess::_FindProcess "Simulanis Auto Login.exe"
    Pop $R0
    ${If} $R0 == 0
        MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
            "Simulanis Auto Login is currently running.$\n$\nClick OK to close it and continue with installation, or Cancel to abort installation." \
            IDCANCEL abort
            nsProcess::_KillProcess "Simulanis Auto Login.exe"
            Sleep 2000
    ${EndIf}
    Goto continue
    
abort:
    Quit
    
continue:
FunctionEnd

Section "Install"
    ; Kill process if still running
    nsProcess::_FindProcess "Simulanis Auto Login.exe"
    Pop $R0
    ${If} $R0 == 0
        nsProcess::_KillProcess "Simulanis Auto Login.exe"
        Sleep 2000
    ${EndIf}
    
    SetOutPath "$INSTDIR"
    
    ; Copy main executable and dependencies with retry
    ClearErrors
    Retry:
        Delete "$INSTDIR\Simulanis Auto Login.exe"
        CopyFiles /SILENT "..\v1.0.1\Simulanis Auto Login.exe" "$INSTDIR"
        ${If} ${Errors}
            MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION \
                "Error copying files. Please ensure no programs are using these files.$\n$\nClick Retry to try again, or Cancel to stop installation." \
                IDRETRY Retry
        ${EndIf}
    
    ; Create and setup config directory in AppData
    CreateDirectory "${CONFIG_DIR}"
    SetOutPath "${CONFIG_DIR}"
    File "..\v1.0.1\headless_config.json"
    
    ; Create directories and copy resources
    SetOutPath "$INSTDIR\Icons"
    File /r "..\v1.0.1\Icons\*.*"
    SetOutPath "$INSTDIR\Logos"
    File /r "..\v1.0.1\Logos\*.*"
    
    ; Copy README and batch files
    SetOutPath "$INSTDIR"
    File "..\v1.0.1\README.md"
    File "..\v1.0.1\Start Simulanis Login (GUI).bat"
    File "..\v1.0.1\Start Simulanis Login.bat"
    
    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\Simulanis Auto Login"
    CreateShortcut "$SMPROGRAMS\Simulanis Auto Login\Simulanis Auto Login.lnk" "$INSTDIR\Simulanis Auto Login.exe"
    CreateShortcut "$SMPROGRAMS\Simulanis Auto Login\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    CreateShortcut "$DESKTOP\Simulanis Auto Login.lnk" "$INSTDIR\Simulanis Auto Login.exe"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Write registry keys
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayName" "Simulanis Auto Login"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayIcon" "$INSTDIR\Simulanis Auto Login.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "Publisher" "Simulanis Solutions Pvt. Ltd."
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayVersion" "1.0.1"
    
    ; Write config directory location to registry
    WriteRegStr HKCU "Software\Simulanis Auto Login" "ConfigDir" "${CONFIG_DIR}"
SectionEnd

Section "Uninstall"
    ; Kill process if running
    nsProcess::_FindProcess "Simulanis Auto Login.exe"
    Pop $R0
    ${If} $R0 == 0
        nsProcess::_KillProcess "Simulanis Auto Login.exe"
        Sleep 2000
    ${EndIf}
    
    ; Remove files from installation directory
    Delete "$INSTDIR\Simulanis Auto Login.exe"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\Start Simulanis Login (GUI).bat"
    Delete "$INSTDIR\Start Simulanis Login.bat"
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove resource directories
    RMDir /r "$INSTDIR\Icons"
    RMDir /r "$INSTDIR\Logos"
    RMDir "$INSTDIR"
    
    ; Remove config directory (optional - comment out to preserve settings)
    RMDir /r "${CONFIG_DIR}"
    
    ; Remove shortcuts
    Delete "$SMPROGRAMS\Simulanis Auto Login\Simulanis Auto Login.lnk"
    Delete "$SMPROGRAMS\Simulanis Auto Login\Uninstall.lnk"
    Delete "$SMSTARTUP\Simulanis Auto Login.lnk"
    RMDir "$SMPROGRAMS\Simulanis Auto Login"
    Delete "$DESKTOP\Simulanis Auto Login.lnk"
    
    ; Remove registry keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login"
    DeleteRegKey HKCU "Software\Simulanis Auto Login"
SectionEnd 