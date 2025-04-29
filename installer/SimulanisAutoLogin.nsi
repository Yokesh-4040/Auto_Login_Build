; Simulanis Auto Login Installer Script
!include "MUI2.nsh"
!include "FileFunc.nsh"

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
!define MUI_FINISHPAGE_RUN "$INSTDIR\SimulanisLogin.exe"
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
    CreateShortCut "$SMSTARTUP\Simulanis Auto Login.lnk" "$INSTDIR\SimulanisLogin.exe"
FunctionEnd

Section "Install"
    SetOutPath "$INSTDIR"
    
    ; Add files to install
    File "..\v1.1.0\SimulanisLogin.exe"
    File "..\v1.1.0\config.json"
    
    ; Copy resource directories
    SetOutPath "$INSTDIR\Icons"
    File /r "..\v1.1.0\Icons\*.*"
    SetOutPath "$INSTDIR\Logos"
    File /r "..\v1.1.0\Logos\*.*"
    
    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\Simulanis Auto Login"
    CreateShortcut "$SMPROGRAMS\Simulanis Auto Login\Simulanis Auto Login.lnk" "$INSTDIR\SimulanisLogin.exe"
    CreateShortcut "$SMPROGRAMS\Simulanis Auto Login\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    CreateShortcut "$DESKTOP\Simulanis Auto Login.lnk" "$INSTDIR\SimulanisLogin.exe"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Write registry keys
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayName" "Simulanis Auto Login"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayIcon" "$INSTDIR\SimulanisLogin.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "Publisher" "Simulanis Solutions Pvt. Ltd."
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Simulanis Auto Login" \
                     "DisplayVersion" "1.1.0"
    
    ; Write config directory location to registry
    WriteRegStr HKCU "Software\Simulanis Auto Login" "ConfigDir" "${CONFIG_DIR}"
    
    ; Add Zone.Identifier to mark as safe
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Policies\Associations" \
                     "LowRiskFileTypes" ".exe;.bat;.cmd;.msi;.zip;.rar;.7z"
SectionEnd

Section "Uninstall"
    ; Remove files from installation directory
    Delete "$INSTDIR\SimulanisLogin.exe"
    Delete "$INSTDIR\config.json"
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove resource directories
    RMDir /r "$INSTDIR\Icons"
    RMDir /r "$INSTDIR\Logos"
    RMDir "$INSTDIR"
    
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