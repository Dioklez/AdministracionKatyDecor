#define MyAppName "KatyDecor Admin"
#define MyAppVersion "2.0.0"
#define MyAppPublisher "Katy Decor Comercial"
#define MyAppExeName "katydecor_desktop.exe"
#define MyAppDir "D:\aaron\Documents\Trabajo\KatyDecor\Administracion\KatyDecorDesktop\build\windows\x64\runner\Release"
#define MyIconFile "D:\aaron\Documents\Trabajo\KatyDecor\Administracion\KatyDecorDesktop\windows\runner\resources\app_icon.ico"

[Setup]
AppId={{8B4F2E1A-3C9D-4F7B-A2E6-1D5C8B9F0E3A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\KatyDecor Admin
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=D:\aaron\Documents\Trabajo\KatyDecor\Administracion\KatyDecorDesktop\installer
OutputBaseFilename=KatyDecorAdmin-Setup-v{#MyAppVersion}
SetupIconFile={#MyIconFile}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "Crear acceso directo en el escritorio"; GroupDescription: "Accesos directos:"; Flags: checkedonce

[Files]
Source: "{#MyAppDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\Desinstalar {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Iniciar {#MyAppName}"; Flags: nowait postinstall skipifsilent