; InnoSetupVersion=6.0.4

#define MyAppName "OBS-Virtualcam"
#define MyAppVersion "2.0.4"
#define MyAppPublisher "Joel Bethke"
#define MyAppURL "https://github.com/Fenrirthviti/obs-virtual-cam"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{F1E7B1CC-0007-43C2-92C2-66334C1EED67}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={code:GetDirName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=OBS-Virtualcam-{#MyAppName}-Installer
Compression=lzma
SolidCompression=yes

[Files]
Source: "..\build-package\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\LICENSE"; Flags: dontcopy

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}" 

[Run]
Filename: "{sys}\regsvr32.exe"; Parameters: "/n /i:""1"" obs-virtualsource.dll"; WorkingDir: "{app}\bin\64bit"; Check: WizardIsTaskSelected('task1'); MinVersion: 0.0,5.0; 
Filename: "{sys}\regsvr32.exe"; Parameters: "/n /i:""1"" obs-virtualsource.dll"; WorkingDir: "{app}\bin\32bit"; Check: WizardIsTaskSelected('task1'); MinVersion: 0.0,5.0; 
Filename: "{sys}\regsvr32.exe"; Parameters: "obs-virtualsource.dll"; WorkingDir: "{app}\bin\64bit"; Check: WizardIsTaskSelected('task2'); MinVersion: 0.0,5.0; 
Filename: "{sys}\regsvr32.exe"; Parameters: "obs-virtualsource.dll"; WorkingDir: "{app}\bin\32bit"; Check: WizardIsTaskSelected('task2'); MinVersion: 0.0,5.0; 

[UninstallRun]
Filename: "{sys}\regsvr32.exe"; Parameters: "/u /s obs-virtualsource.dll"; WorkingDir: "{app}\bin\64bit"; MinVersion: 0.0,5.0; 
Filename: "{sys}\regsvr32.exe"; Parameters: "/u /s obs-virtualsource.dll"; WorkingDir: "{app}\bin\32bit"; MinVersion: 0.0,5.0; 

[Tasks]
Name: "task1"; Description: "1. Install plugin and register 1 virtual camera"; MinVersion: 0.0,5.0; Flags: exclusive
Name: "task2"; Description: "2. Install plugin and register 4 virtual cameras"; MinVersion: 0.0,5.0; Flags: exclusive unchecked

[UninstallDelete]
Type: files; Name: "{app}\bin\64bit\obs-virtualsource.dll"; 
Type: files; Name: "{app}\bin\32bit\obs-virtualsource.dll"; 

[Code]
procedure InitializeWizard();
var
  GPLText: AnsiString;
  Page: TOutputMsgMemoWizardPage;
begin
  ExtractTemporaryFile('LICENSE');
  LoadStringFromFile(ExpandConstant('{tmp}\LICENSE'), GPLText);

  Page := CreateOutputMsgMemoPage(wpWelcome,
    'License Information', 'Please review the license terms before installing OBS-Virtualcam',
    'Press Page Down to see the rest of the agreement. Once you are aware of your rights, click Next to continue.',
    String(GPLText)
  );
end;

// credit where it's due :
// following function come from https://github.com/Xaymar/obs-studio_amf-encoder-plugin/blob/master/%23Resources/Installer.in.iss#L45
function GetDirName(Value: string): string;
var
	InstallPath: string;
begin
	// initialize default path, which will be returned when the following registry
	// key queries fail due to missing keys or for some different reason
	Result := '{pf}\obs-studio';
	// query the first registry value; if this succeeds, return the obtained value
	if RegQueryStringValue(HKLM32, 'SOFTWARE\OBS Studio', '', InstallPath) then
		Result := InstallPath
end;
