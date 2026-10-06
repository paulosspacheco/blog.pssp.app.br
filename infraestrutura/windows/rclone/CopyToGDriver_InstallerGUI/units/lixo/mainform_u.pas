unit mainForm_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, FileUtil, Process, Zipper, LazFileUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnCreatePackage: TButton;
    btnBrowseOutput: TButton;
    btnOpenOutput: TButton;
    cbCreateInstaller: TCheckBox;
    cbIncludeRclone: TCheckBox;
    edtOutputDir: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    imgLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblStatus: TLabel;
    memLog: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    rbWindows: TRadioButton;
    rbLinux: TRadioButton;
    rbMacOS: TRadioButton;
    rbAllPlatforms: TRadioButton;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure btnBrowseOutputClick(Sender: TObject);
    procedure btnCreatePackageClick(Sender: TObject);
    procedure btnOpenOutputClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FProjectRoot: string;
    FSourceDir: string;
    procedure Log(const AMessage: string);
    procedure UpdateProgress(AProgress: Integer; const AMessage: string);
    function GetSelectedPlatforms: TStringList;
    function CreatePackageForPlatform(const APlatform: string): Boolean;
    procedure CopyScripts(const AOutputDir: string; const APlatform: string);
    procedure CreateInstallerScript(const AOutputDir: string; const APlatform: string);
    procedure CreateFileAssociations(const AOutputDir: string; const APlatform: string);
    procedure CreateArchive(const AOutputDir, APlatform: string);
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Configurar diretórios padrão
  FProjectRoot := ExtractFilePath(ParamStr(0));
  FSourceDir := FProjectRoot + 'CopyToGDriver' + PathDelim;
  edtOutputDir.Text := FProjectRoot + 'dist' + PathDelim + 'packages' + PathDelim;

  // Configurar UI
  Caption := 'CopyToGDriver Packager - Criador de Instalador';
  lblStatus.Caption := 'Pronto para criar pacotes';
  ProgressBar1.Position := 0;

  Log('CopyToGDriver Packager GUI Iniciado');
  Log('Diretório do projeto: ' + FProjectRoot);
  Log('Diretório fonte: ' + FSourceDir);
end;

procedure TMainForm.btnBrowseOutputClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    edtOutputDir.Text := IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName);
  end;
end;

procedure TMainForm.btnCreatePackageClick(Sender: TObject);
var
  Platforms: TStringList;
  i: Integer;
  Success: Boolean;
begin
  if not DirectoryExists(FSourceDir) then
  begin
    MessageDlg('Erro', 'Diretório fonte não encontrado: ' + FSourceDir, mtError, [mbOK], 0);
    Exit;
  end;

  Platforms := GetSelectedPlatforms;
  try
    memLog.Clear;
    ProgressBar1.Position := 0;
    btnCreatePackage.Enabled := False;

    Log('Iniciando criação de pacotes...');
    Log('Diretório de saída: ' + edtOutputDir.Text);

    Success := True;
    for i := 0 to Platforms.Count - 1 do
    begin
      UpdateProgress(Round((i / Platforms.Count) * 100),
        'Criando pacote para ' + Platforms[i]);

      if not CreatePackageForPlatform(Platforms[i]) then
      begin
        Success := False;
        Log('ERRO: Falha ao criar pacote para ' + Platforms[i]);
      end;
    end;

    UpdateProgress(100, 'Processo concluído');

    if Success then
    begin
      MessageDlg('Sucesso', 'Pacotes criados com sucesso!' + sLineBreak +
                 'Verifique o diretório: ' + edtOutputDir.Text, mtInformation, [mbOK], 0);
      Log('=== TODOS OS PACOTES CRIADOS COM SUCESSO ===');
    end
    else
    begin
      MessageDlg('Aviso', 'Alguns pacotes podem não ter sido criados.' + sLineBreak +
                 'Verifique o log para detalhes.', mtWarning, [mbOK], 0);
    end;

  finally
    Platforms.Free;
    btnCreatePackage.Enabled := True;
  end;
end;

procedure TMainForm.btnOpenOutputClick(Sender: TObject);
var
  Process: TProcess;
begin
  if DirectoryExists(edtOutputDir.Text) then
  begin
    Process := TProcess.Create(nil);
    try
      {$IFDEF WINDOWS}
      Process.Executable := 'explorer.exe';
      Process.Parameters.Add(edtOutputDir.Text);
      {$ENDIF}
      {$IFDEF LINUX}
      Process.Executable := 'xdg-open';
      Process.Parameters.Add(edtOutputDir.Text);
      {$ENDIF}
      {$IFDEF DARWIN}
      Process.Executable := 'open';
      Process.Parameters.Add(edtOutputDir.Text);
      {$ENDIF}
      Process.Execute;
    finally
      Process.Free;
    end;
  end
  else
  begin
    MessageDlg('Aviso', 'Diretório de saída não existe ainda.' + sLineBreak +
               'Crie os pacotes primeiro.', mtInformation, [mbOK], 0);
  end;
end;

procedure TMainForm.Log(const AMessage: string);
begin
  memLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + AMessage);
  memLog.SelStart := Length(memLog.Text);
  Application.ProcessMessages;
end;

procedure TMainForm.UpdateProgress(AProgress: Integer; const AMessage: string);
begin
  ProgressBar1.Position := AProgress;
  lblStatus.Caption := AMessage;
  Application.ProcessMessages;
end;

function TMainForm.GetSelectedPlatforms: TStringList;
begin
  Result := TStringList.Create;

  if rbWindows.Checked or rbAllPlatforms.Checked then
    Result.Add('windows');
  if rbLinux.Checked or rbAllPlatforms.Checked then
    Result.Add('linux');
  if rbMacOS.Checked or rbAllPlatforms.Checked then
    Result.Add('macos');
end;

function TMainForm.CreatePackageForPlatform(const APlatform: string): Boolean;
var
  PlatformOutputDir: string;
begin
  Result := False;
  try
    Log('>>> Criando pacote para: ' + APlatform);

    // Criar diretório da plataforma
    PlatformOutputDir := IncludeTrailingPathDelimiter(edtOutputDir.Text) + APlatform + PathDelim;
    ForceDirectories(PlatformOutputDir);

    // Copiar scripts
    CopyScripts(PlatformOutputDir, APlatform);

    // Criar script de instalação
    if cbCreateInstaller.Checked then
      CreateInstallerScript(PlatformOutputDir, APlatform);

    // Criar associações de arquivo
    CreateFileAssociations(PlatformOutputDir, APlatform);

    // Criar arquivo compactado
    CreateArchive(PlatformOutputDir, APlatform);

    Log('<<< Pacote para ' + APlatform + ' criado com sucesso');
    Result := True;

  except
    on E: Exception do
    begin
      Log('ERRO em ' + APlatform + ': ' + E.Message);
    end;
  end;
end;

procedure TMainForm.CopyScripts(const AOutputDir: string; const APlatform: string);
var
  SearchRec: TSearchRec;
  SourcePath, DestPath: string;
begin
  Log('  Copiando scripts principais...');

  // Copiar scripts .sh
  if FindFirst(FSourceDir + '*.sh', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        SourcePath := FSourceDir + SearchRec.Name;
        DestPath := AOutputDir + SearchRec.Name;
        CopyFile(SourcePath, DestPath);
        Log('    - ' + SearchRec.Name);
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;

  // Copiar scripts específicos da plataforma
  Log('  Copiando scripts da plataforma ' + APlatform + '...');
  SourcePath := FSourceDir + 'includes' + PathDelim + APlatform + PathDelim;
  if DirectoryExists(SourcePath) then
  begin
    if FindFirst(SourcePath + '*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          DestPath := AOutputDir + SearchRec.Name;
          CopyFile(SourcePath + SearchRec.Name, DestPath);
          Log('    - ' + SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  end;

  // Copiar includes comuns
  Log('  Copiando includes comuns...');
  SourcePath := FSourceDir + 'includes' + PathDelim + 'common' + PathDelim;
  if DirectoryExists(SourcePath) then
  begin
    if FindFirst(SourcePath + '*.sh', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          DestPath := AOutputDir + SearchRec.Name;
          CopyFile(SourcePath + SearchRec.Name, DestPath);
          Log('    - ' + SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  end;
end;

procedure TMainForm.CreateInstallerScript(const AOutputDir: string; const APlatform: string);
var
  ScriptFile: TStringList;
  ScriptName: string;
begin
  Log('  Criando script de instalação...');

  case APlatform of
    'windows': ScriptName := 'Instalar_CopyToGDriver.bat';
    'linux': ScriptName := 'instalar_copy2gdriver.sh';
    'macos': ScriptName := 'instalar_copy2gdriver.sh';
  else
    ScriptName := 'installer.sh';
  end;

  ScriptFile := TStringList.Create;
  try
    case APlatform of
      'windows':
        begin
          ScriptFile.Add('@echo off');
          ScriptFile.Add('title CopyToGDriver Installer');
          ScriptFile.Add('echo =================================');
          ScriptFile.Add('echo     INSTALADOR CopyToGDriver');
          ScriptFile.Add('echo =================================');
          ScriptFile.Add('echo.');
          ScriptFile.Add('set INSTALL_DIR=%USERPROFILE%\CopyToGDriver');
          ScriptFile.Add('');
          ScriptFile.Add('echo Criando diretório de instalação...');
          ScriptFile.Add('if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"');
          ScriptFile.Add('');
          ScriptFile.Add('echo Copiando arquivos...');
          ScriptFile.Add('xcopy /Y /E "%~dp0*" "%INSTALL_DIR%\"');
          ScriptFile.Add('');
          ScriptFile.Add('echo Registrando no menu de contexto...');
          ScriptFile.Add('reg add "HKEY_CLASSES_ROOT\*\shell\CopyToGDriver" /ve /d "Enviar para Google Drive" /f');
          ScriptFile.Add('reg add "HKEY_CLASSES_ROOT\*\shell\CopyToGDriver\command" /ve /d "\"%INSTALL_DIR%\CopyToGDriver.sh\" \"%%1\"" /f');
          ScriptFile.Add('');
          ScriptFile.Add('echo.');
          ScriptFile.Add('echo =================================');
          ScriptFile.Add('echo Instalação concluída com sucesso!');
          ScriptFile.Add('echo Diretório: %INSTALL_DIR%');
          ScriptFile.Add('echo =================================');
          ScriptFile.Add('echo.');
          ScriptFile.Add('pause');
        end;

      'linux', 'macos':
        begin
          ScriptFile.Add('#!/bin/bash');
          ScriptFile.Add('echo "================================="');
          ScriptFile.Add('echo "    INSTALADOR CopyToGDriver"');
          ScriptFile.Add('echo "================================="');
          ScriptFile.Add('');
          ScriptFile.Add('INSTALL_DIR="$HOME/CopyToGDriver"');
          ScriptFile.Add('');
          ScriptFile.Add('echo "Criando diretório de instalação..."');
          ScriptFile.Add('mkdir -p "$INSTALL_DIR"');
          ScriptFile.Add('');
          ScriptFile.Add('echo "Copiando arquivos..."');
          ScriptFile.Add('cp -r ./* "$INSTALL_DIR/"');
          ScriptFile.Add('');
          ScriptFile.Add('echo "Tornando scripts executáveis..."');
          ScriptFile.Add('chmod +x "$INSTALL_DIR"/*.sh');
          ScriptFile.Add('');
          ScriptFile.Add('echo "Criando atalho no menu de aplicações..."');
          ScriptFile.Add('# Adicionar entrada no menu de aplicações');
          ScriptFile.Add('');
          ScriptFile.Add('echo "');
          ScriptFile.Add('=================================');
          ScriptFile.Add('Instalação concluída com sucesso!');
          ScriptFile.Add('Diretório: $INSTALL_DIR');
          ScriptFile.Add('================================="');
        end;
    end;

    ScriptFile.SaveToFile(AOutputDir + ScriptName);
    Log('    Script criado: ' + ScriptName);

  finally
    ScriptFile.Free;
  end;
end;

procedure TMainForm.CreateFileAssociations(const AOutputDir: string; const APlatform: string);
var
  AssocFile: TStringList;
begin
  Log('  Criando associações de arquivo...');

  AssocFile := TStringList.Create;
  try
    case APlatform of
      'windows':
        begin
          AssocFile.Add('Windows Registry Editor Version 5.00');
          AssocFile.Add('');
          AssocFile.Add('[HKEY_CLASSES_ROOT\*\shell\CopyToGDriver]');
          AssocFile.Add('@="Enviar para Google Drive"');
          AssocFile.Add('"Icon"="\"%USERPROFILE%\\CopyToGDriver\\icon.ico\""');
          AssocFile.Add('');
          AssocFile.Add('[HKEY_CLASSES_ROOT\*\shell\CopyToGDriver\command]');
          AssocFile.Add('@="\"%USERPROFILE%\\CopyToGDriver\\CopyToGDriver.sh\" \"%1\""');
        end;

      'linux':
        begin
          AssocFile.Add('[Desktop Entry]');
          AssocFile.Add('Name=CopyToGDriver');
          AssocFile.Add('Comment=Enviar arquivos para Google Drive');
          AssocFile.Add('Exec=/home/$USER/CopyToGDriver/CopyToGDriver.sh %F');
          AssocFile.Add('Icon=drive');
          AssocFile.Add('Terminal=false');
          AssocFile.Add('Type=Application');
          AssocFile.Add('MimeType=inode/directory;');
          AssocFile.Add('Categories=Utility;');
        end;
    end;

    case APlatform of
      'windows': AssocFile.SaveToFile(AOutputDir + 'file_association.reg');
      'linux': AssocFile.SaveToFile(AOutputDir + 'copy2gdriver.desktop');
    end;

    Log('    Associações criadas para ' + APlatform);

  finally
    AssocFile.Free;
  end;
end;

procedure TMainForm.CreateArchive(const AOutputDir, APlatform: string);
var
  AZipper: TZipper;
  SearchRec: TSearchRec;
  ArchiveName: string;
begin
  Log('  Criando arquivo compactado...');

  ArchiveName := AOutputDir + 'CopyToGDriver_' + APlatform + '_' +
                FormatDateTime('yyyy-mm-dd', Now) + '.zip';

  AZipper := TZipper.Create;
  try
    AZipper.FileName := ArchiveName;

    if FindFirst(AOutputDir + '*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
           (ExtractFileName(ArchiveName) <> SearchRec.Name) then
        begin
          AZipper.Entries.AddFileEntry(AOutputDir + SearchRec.Name, SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    AZipper.ZipAllFiles;
    Log('    Arquivo criado: ' + ExtractFileName(ArchiveName));

  finally
    AZipper.Free;
  end;
end;

end.
