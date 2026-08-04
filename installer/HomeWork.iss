#ifndef SourceDir
  #define SourceDir "..\build\windows\x64\runner\Release"
#endif

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

[Setup]
AppId={{A6279BE8-1E4D-4D1A-974B-0CB78AF32710}
AppName=HomeWork
AppVersion={#AppVersion}
AppPublisher=Base27-CVNSS
AppPublisherURL=https://github.com/Base27-CVNSS/HomeWork
AppSupportURL=https://github.com/Base27-CVNSS/HomeWork/issues
AppUpdatesURL=https://github.com/Base27-CVNSS/HomeWork/releases
DefaultDirName={localappdata}\Programs\HomeWork
DefaultGroupName=HomeWork
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=HomeWork-Setup
SetupIconFile=..\assets\branding\homework.ico
UninstallDisplayIcon={app}\HomeWork.exe
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
CloseApplications=yes
RestartApplications=no
VersionInfoVersion={#AppVersion}
VersionInfoCompany=Base27-CVNSS
VersionInfoDescription=HomeWork Windows Installer
VersionInfoProductName=HomeWork

[Tasks]
Name: "desktopicon"; Description: "Tạo biểu tượng ngoài màn hình"; GroupDescription: "Biểu tượng bổ sung:"; Flags: unchecked

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\HomeWork"; Filename: "{app}\HomeWork.exe"
Name: "{autodesktop}\HomeWork"; Filename: "{app}\HomeWork.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\HomeWork.exe"; Description: "Mở HomeWork"; Flags: nowait postinstall skipifsilent
