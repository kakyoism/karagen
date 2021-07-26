; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "karagen"
#define MyAppVersion "0.1.4"
#define MyAppPublisher "kakyoism.com"
#define MyAppURL "https://github.com/kakyoism/karagen"
#define MyAppExeName "karagen.exe"
#define MyRootDir "D:\kakyo\_dev"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{14B56AFE-9EF8-4368-B327-977D3F58DA78}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile={#MyRootDir}\karagen\LICENSE
InfoBeforeFile={#MyRootDir}\karagen\_ci\_preinstall.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir={#MyRootDir}\karagen\build\windows
OutputBaseFilename=install_karagen_{#MyAppVersion}
SetupIconFile={#MyRootDir}\karagen\_assets\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\_dep\_postinstall.bat"; Description: "{cm:T_PostBuild}"; Flags: nowait postinstall skipifsilent

[CustomMessages]
T_PostBuild=Run Post-Build script to install dependencies: ffmpeg, libsndfile.

[Files]
Source: "{#MyRootDir}\karagen\README.html"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyRootDir}\karagen\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyRootDir}\karagen\build\windows\runner\Release\file_selector_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyRootDir}\karagen\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyRootDir}\karagen\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; Source: "{#MyRootDir}\karagen\build\windows\runner\Release\pretrained_models\*"; DestDir: "{app}\pretrained_models"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyRootDir}\karagen\_ci\_3rdparty\*"; DestDir: "{app}\_dep\_3rdparty"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyRootDir}\karagen\_ci\_postinstall.bat"; DestDir: "{app}\_dep"; Flags: ignoreversion
Source: "{#MyRootDir}\karagen\_ci\_postinstall.py"; DestDir: "{app}\_dep"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
