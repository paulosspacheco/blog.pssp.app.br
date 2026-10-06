unit SetupForm_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, Process, FileUtil, Zipper, LazFileUtils, Spin
  {$IFDEF WINDOWS}, Windows{$ENDIF};

type

  { TSetupForm }

  TSetupForm = class(TForm)
    btnInstall: TButton;
    btnBrowse: TButton;
    cbCreateDesktopShortcut: TCheckBox;
    cbCreateStartMenu: TCheckBox;
    cbAutoInstallRclone: TCheckBox;
    cbAutoConfigRemote: TCheckBox;
    cbForceSync: TCheckBox;
    cbVerboseMode: TCheckBox;
    cbDryRun: TCheckBox;
    cbSkipExisting: TCheckBox;
    edtInstallPath: TEdit;
    edtExcludePatterns: TEdit;
    edtIncludePatterns: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblStatus: TLabel;
    memLog: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    seMaxTransfers: TSpinEdit;
    seRetryCount: TSpinEdit;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure cbDryRunChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAppPath: string;
    FIsAdmin: Boolean;
    FPlatform: string;
    procedure Log(const AMessage: string);
    procedure UpdateProgress(AProgress: Integer; const AMessage: string);
    function CheckAdmin: Boolean;
    function GetDefaultInstallPath: string;
    procedure ExtractPackage;
    procedure RunInstallerScript;
    procedure CreateShortcuts;
    function ExecuteProcess(const ACommand: string; const AParameters: array of string): Boolean;
    function BuildScriptParameters: string;
    procedure SaveStringToFile(const FileName, Content: string);
  public
  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.lfm}

{ TSetupForm }

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  // Detectar plataforma
  {$IFDEF WINDOWS}
  FPlatform := 'windows';
  {$ENDIF}
  {$IFDEF LINUX}
  FPlatform := 'linux';
  {$ENDIF}
  {$IFDEF DARWIN}
  FPlatform := 'macos';
  {$ENDIF}

  FAppPath := ExtractFilePath(ParamStr(0));
  FIsAdmin := CheckAdmin;

  // Configurar caminho padrão
  edtInstallPath.Text := GetDefaultInstallPath;

  // Configurar valores padrão
  seMaxTransfers.Value := 4;
  seRetryCount.Value := 3;
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
  Log('CopyToGDriver Installer v1.0');
  Log('Plataforma: ' + FPlatform);

  if FIsAdmin then
    Log('✓ Executando com privilégios de administrador')
  else
  begin
    Log('⚠ ATENÇÃO: Execute como administrador para instalação completa');
    MessageDlg('Aviso',
      'Recomendado executar como administrador para instalação completa.' + sLineBreak +
      'Alguns recursos podem não funcionar corretamente.',
      mtWarning, [mbOK], 0);
  end;
end;

procedure TSetupForm.btnBrowseClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    edtInstallPath.Text := IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName) + 'CopyToGDriver';
  end;
end;

procedure TSetupForm.cbDryRunChange(Sender: TObject);
begin
  if cbDryRun.Checked then
  begin
    Log('⚠ Modo Dry Run ativado - nenhuma alteração real será feita');
  end;
end;

procedure TSetupForm.btnInstallClick(Sender: TObject);
begin
  btnInstall.Enabled := False;
  try
    // Mudar para aba de progresso
    PageControl1.ActivePage := TabSheet2;
    memLog.Clear;
    ProgressBar1.Position := 0;

    Log('Iniciando instalação do CopyToGDriver...');
    Log('Parâmetros configurados: ' + BuildScriptParameters);

    // Passo 1: Extrair pacote
    UpdateProgress(25, 'Extraindo arquivos...');
    ExtractPackage;

    // Passo 2: Executar script de instalação
    UpdateProgress(75, 'Executando configuração...');
    RunInstallerScript;

    // Passo 3: Criar atalhos
    UpdateProgress(90, 'Criando atalhos...');
    CreateShortcuts;

    // Finalização
    UpdateProgress(100, 'Instalação concluída!');
    Log('✓ Instalação concluída com sucesso!');

    MessageDlg('Instalação Concluída',
      'CopyToGDriver foi instalado com sucesso!' + sLineBreak + sLineBreak +
      'Local: ' + edtInstallPath.Text + sLineBreak +
      'Parâmetros: ' + BuildScriptParameters + sLineBreak + sLineBreak +
      'Você pode agora usar o comando "copydrive" no terminal.',
      mtInformation, [mbOK], 0);

  except
    on E: Exception do
    begin
      Log('❌ Erro na instalação: ' + E.Message);
      MessageDlg('Erro',
        'Ocorreu um erro durante a instalação:' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
    end;
  end;
  btnInstall.Enabled := True;
end;

function TSetupForm.BuildScriptParameters: string;
var
  Params: TStringList;
begin
  Params := TStringList.Create;
  try
    Params.Delimiter := ' ';
    Params.StrictDelimiter := True;

    // Parâmetros de instalação
    if cbAutoInstallRclone.Checked then
      Params.Add('--auto-install-rclone');

    if cbAutoConfigRemote.Checked then
      Params.Add('--auto-config-remote');

    // Parâmetros de execução
    if cbForceSync.Checked then
      Params.Add('--force');

    if cbVerboseMode.Checked then
      Params.Add('--verbose');

    if cbDryRun.Checked then
      Params.Add('--dry-run');

    if cbSkipExisting.Checked then
      Params.Add('--skip-existing');

    // Parâmetros com valores
    if seMaxTransfers.Value > 1 then
      Params.Add('--transfers=' + IntToStr(seMaxTransfers.Value));

    if seRetryCount.Value > 0 then
      Params.Add('--retries=' + IntToStr(seRetryCount.Value));

    // Padrões de exclusão/inclusão
    if Trim(edtExcludePatterns.Text) <> '' then
      Params.Add('--exclude=' + edtExcludePatterns.Text);

    if Trim(edtIncludePatterns.Text) <> '' then
      Params.Add('--include=' + edtIncludePatterns.Text);

    Result := Params.DelimitedText;
  finally
    Params.Free;
  end;
end;

procedure TSetupForm.Log(const AMessage: string);
begin
  memLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + AMessage);
  memLog.SelStart := Length(memLog.Text);
  Application.ProcessMessages;
end;

procedure TSetupForm.UpdateProgress(AProgress: Integer; const AMessage: string);
begin
  ProgressBar1.Position := AProgress;
  lblStatus.Caption := AMessage;
  Application.ProcessMessages;
end;

function TSetupForm.CheckAdmin: Boolean;
{$IFDEF WINDOWS}
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS     = $00000220;
var
  hToken: THandle = 0;
  ptgGroups: PTokenGroups = nil;
  dwInfoSize: DWORD = 0;
  psidAdministrators: PSID = nil;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;

  if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken) then
    Exit;

  try
    if not GetTokenInformation(hToken, TokenGroups, nil, 0, dwInfoSize) then
    begin
      if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
        Exit;
    end;

    ptgGroups := GetMem(dwInfoSize);

    try
      if GetTokenInformation(hToken, TokenGroups, ptgGroups, dwInfoSize, dwInfoSize) then
      begin
        bSuccess := AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
          SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
          0, 0, 0, 0, 0, 0, psidAdministrators);

        if bSuccess then
        begin
          try
            for x := 0 to ptgGroups^.GroupCount - 1 do
            begin
              if EqualSid(psidAdministrators, ptgGroups^.Groups[x].Sid) then
              begin
                Result := True;
                Break;
              end;
            end;
          finally
            FreeSid(psidAdministrators);
          end;
        end;
      end;
    finally
      FreeMem(ptgGroups);
    end;
  finally
    CloseHandle(hToken);
  end;
end;
{$ELSE}
begin
  // No Linux/macOS, verificar se é root (UID 0)
  Result := (GetUserID = 0);
end;
{$ENDIF}

function TSetupForm.GetDefaultInstallPath: string;
begin
  {$IFDEF WINDOWS}
  Result := 'C:\scripts\CopyToGDriver';
  {$ENDIF}
  {$IFDEF LINUX}
  Result := GetUserDir + 'scripts/CopyToGDriver';
  {$ENDIF}
  {$IFDEF DARWIN}
  Result := GetUserDir + 'scripts/CopyToGDriver';
  {$ENDIF}
end;

procedure TSetupForm.ExtractPackage;
var
  AZipper: TUnZipper;
  PackageFile, ExtractPath: string;
begin
  // Encontrar arquivo do pacote
  PackageFile := FAppPath + 'CopyToGDriver.zip';
  ExtractPath := edtInstallPath.Text;

  if not FileExists(PackageFile) then
  begin
    // Tentar encontrar em subdiretórios
    PackageFile := FAppPath + 'packages\' + FPlatform + '\CopyToGDriver.zip';
    if not FileExists(PackageFile) then
      raise Exception.Create('Arquivo do pacote não encontrado: ' + PackageFile);
  end;

  Log('Extraindo: ' + PackageFile);
  Log('Para: ' + ExtractPath);

  // Criar diretório de instalação
  if not ForceDirectories(ExtractPath) then
    raise Exception.Create('Não foi possível criar diretório: ' + ExtractPath);

  // Extrair arquivos
  AZipper := TUnZipper.Create;
  try
    AZipper.FileName := PackageFile;
    AZipper.OutputPath := ExtractPath;
    AZipper.Examine;
    AZipper.UnZipAllFiles;
    Log('✓ Extração concluída');
  finally
    AZipper.Free;
  end;
end;

procedure TSetupForm.RunInstallerScript;
var
  InstallScript, InstallPath, Parameters: string;
begin
  InstallPath := edtInstallPath.Text;
  Parameters := BuildScriptParameters;

  case FPlatform of
    'windows':
      begin
        InstallScript := InstallPath + '\includes\windows\CopyToGDriver_Installer.ps1';
        if FileExists(InstallScript) then
        begin
          Log('Executando instalador Windows...');
          Log('Parâmetros: ' + Parameters);

          // Criar arquivo de parâmetros temporário
          if Parameters <> '' then
          begin
            SaveStringToFile(InstallPath + '\install_params.txt', Parameters);
          end;

          if ExecuteProcess('powershell.exe',
            ['-ExecutionPolicy', 'Bypass', '-WindowStyle', 'Hidden', '-File',
             InstallScript, '-path', InstallPath, '-parameters', Parameters]) then
            Log('✓ Script de instalação executado')
          else
            Log('⚠ Script de instalação pode não ter executado completamente');
        end
        else
          Log('❌ Script de instalação não encontrado: ' + InstallScript);
      end;

    'linux', 'macos':
      begin
        InstallScript := InstallPath + '/includes/' + FPlatform + '/CopyToGDriver_Installer.sh';
        if FileExists(InstallScript) then
        begin
          Log('Executando instalador ' + FPlatform + '...');
          Log('Parâmetros: ' + Parameters);

          ExecuteProcess('chmod', ['+x', InstallScript]);

          // Para Linux/macOS, passar parâmetros diretamente
          if ExecuteProcess('bash', [InstallScript, Parameters]) then
            Log('✓ Script de instalação executado')
          else
            Log('⚠ Script de instalação pode não ter executado completamente');
        end
        else
          Log('❌ Script de instalação não encontrado: ' + InstallScript);
      end;
  end;
end;

procedure TSetupForm.CreateShortcuts;
{$IFDEF WINDOWS}
var
  VBScript, DesktopPath, UserProfile: string;
  VBSFile: TextFile;
begin
  if cbCreateDesktopShortcut.Checked then
  begin
    Log('Criando atalho na área de trabalho...');

    // Obter diretório do usuário usando SysUtils.GetEnvironmentVariable
    UserProfile := SysUtils.GetEnvironmentVariable('USERPROFILE');
    if UserProfile = '' then
      UserProfile := 'C:\Users\' + SysUtils.GetEnvironmentVariable('USERNAME');

    VBScript := GetTempDir + 'create_shortcut.vbs';
    DesktopPath := UserProfile + '\Desktop\CopyToGDriver.lnk';

    AssignFile(VBSFile, VBScript);
    try
      Rewrite(VBSFile);
      WriteLn(VBSFile, 'Set WshShell = WScript.CreateObject("WScript.Shell")');
      WriteLn(VBSFile, 'Set oShellLink = WshShell.CreateShortcut("' + DesktopPath + '")');
      WriteLn(VBSFile, 'oShellLink.TargetPath = "C:\Program Files\Git\git-bash.exe"');
      WriteLn(VBSFile, 'oShellLink.Arguments = "--cd=' + edtInstallPath.Text + ' -- ' + edtInstallPath.Text + '\CopyToGDriver.sh"');
      WriteLn(VBSFile, 'oShellLink.WindowStyle = 1');
      WriteLn(VBSFile, 'oShellLink.Description = "CopyToGDriver - Google Drive Sync"');
      WriteLn(VBSFile, 'oShellLink.WorkingDirectory = "' + edtInstallPath.Text + '"');
      WriteLn(VBSFile, 'oShellLink.Save');
    finally
      CloseFile(VBSFile);
    end;

    if ExecuteProcess('wscript', [VBScript]) then
      Log('✓ Atalho criado na área de trabalho')
    else
      Log('⚠ Não foi possível criar o atalho');

    // Limpar arquivo temporário
    if FileExists(VBScript) then
      SysUtils.DeleteFile(VBScript);
  end;

  if cbCreateStartMenu.Checked then
  begin
    Log('Criando entrada no Menu Iniciar...');
    // Implementação para Menu Iniciar pode ser adicionada aqui
  end;
end;
{$ELSE}
begin
  if cbCreateDesktopShortcut.Checked then
    Log('Criando atalho na área de trabalho...');

  if cbCreateStartMenu.Checked then
    Log('Criando entrada no menu de aplicações...');
end;
{$ENDIF}

function TSetupForm.ExecuteProcess(const ACommand: string; const AParameters: array of string): Boolean;
var
  Process: TProcess;
  i: Integer;
begin
  Result := False;
  Process := TProcess.Create(nil);
  try
    Process.Executable := ACommand;
    for i := 0 to High(AParameters) do
      Process.Parameters.Add(AParameters[i]);

    Process.Options := [poWaitOnExit, poNoConsole];
    Process.ShowWindow := swoHide;

    try
      Process.Execute;
      Result := (Process.ExitStatus = 0);
    except
      on E: Exception do
        Log('Erro ao executar ' + ACommand + ': ' + E.Message);
    end;
  finally
    Process.Free;
  end;
end;

procedure TSetupForm.SaveStringToFile(const FileName, Content: string);
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    Strings.Text := Content;
    Strings.SaveToFile(FileName);
  finally
    Strings.Free;
  end;
end;

end.
