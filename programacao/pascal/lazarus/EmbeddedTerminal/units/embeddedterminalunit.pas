
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.7.0
   Data: 19/04/2025
   Hora: 19:14:00 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure InitializeCommandHistoryFile; // Inicializar o arquivo de histórico
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
    procedure LimitMemoLines(MaxLines: Integer); // Limitar o número de linhas no TMemo
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.InitializeCommandHistoryFile;
var
  jsonFile: TextFile;
begin
  // Se o arquivo não existir, cria um arquivo JSON válido com um array vazio
  if not FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, '[]'); // Array JSON vazio
      CloseFile(jsonFile);
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao criar arquivo de histórico: ' + E.Message);
    end;
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  fileContent: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  // Inicializar o arquivo de histórico se ele não existir
  InitializeCommandHistoryFile;

  try
    // Ler o arquivo JSON
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Reset(jsonFile);
    jsonString := '';
    while not EOF(jsonFile) do
    begin
      ReadLn(jsonFile, fileContent);
      jsonString := jsonString + fileContent;
    end;
    CloseFile(jsonFile);

    // Verificar se o arquivo está vazio ou contém apenas "[]"
    jsonString := Trim(jsonString);
    if (jsonString = '') or (jsonString = '[]') then
    begin
      Exit;
    end;

    // Tentar parsear o JSON
    try
      jsonData := GetJSON(jsonString);
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao parsear JSON: ' + E.Message);
        Memo1.Lines.Add('Sobrescrevendo arquivo de histórico com formato válido.');
        InitializeCommandHistoryFile;
        Exit;
      end;
    end;

    try
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        InitializeCommandHistoryFile;
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido (não é um array JSON), inicializando novo histórico.');
        InitializeCommandHistoryFile;
      end;
    finally
      jsonData.Free;
    end;
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
      Memo1.Lines.Add('Inicializando novo arquivo de histórico devido a erro.');
      InitializeCommandHistoryFile;
      commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.LimitMemoLines(MaxLines: Integer);
begin
  // Limitar o número de linhas no TMemo para evitar sobrecarga
  while Memo1.Lines.Count > MaxLines do
    Memo1.Lines.Delete(0);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Forçar o PS1 usando um comando inicial
    if shellPath = '/bin/bash' then
    begin
      SetLength(shellArgs, 4);
      shellArgs[0] := PChar(shellPath);
      shellArgs[1] := PChar('-i'); // Modo interativo
      shellArgs[2] := PChar('-c'); // Executar comando
      shellArgs[3] := PChar('PS1="\W\\$ "; exec /bin/bash -i');
      shellArgs[4] := nil; // Terminar o array com nil
    end;

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    // Limitar o número de linhas no TMemo
    LimitMemoLines(1000);
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 200; // Aumentado para 200 ms para lidar com saídas longas
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.6.0
   Data: 19/04/2025
   Hora: 18:45:15 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure InitializeCommandHistoryFile; // Inicializar o arquivo de histórico
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
    procedure LimitMemoLines(MaxLines: Integer); // Limitar o número de linhas no TMemo
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.InitializeCommandHistoryFile;
var
  jsonFile: TextFile;
begin
  // Se o arquivo não existir, cria um arquivo JSON válido com um array vazio
  if not FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, '[]'); // Array JSON vazio
      CloseFile(jsonFile);
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao criar arquivo de histórico: ' + E.Message);
    end;
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  fileContent: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  // Inicializar o arquivo de histórico se ele não existir
  InitializeCommandHistoryFile;

  try
    // Ler o arquivo JSON
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Reset(jsonFile);
    jsonString := '';
    while not EOF(jsonFile) do
    begin
      ReadLn(jsonFile, fileContent);
      jsonString := jsonString + fileContent;
    end;
    CloseFile(jsonFile);

    // Verificar se o arquivo está vazio ou contém apenas "[]"
    jsonString := Trim(jsonString);
    if (jsonString = '') or (jsonString = '[]') then
    begin
      Exit;
    end;

    // Tentar parsear o JSON
    try
      jsonData := GetJSON(jsonString);
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao parsear JSON: ' + E.Message);
        Memo1.Lines.Add('Sobrescrevendo arquivo de histórico com formato válido.');
        InitializeCommandHistoryFile;
        Exit;
      end;
    end;

    try
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        InitializeCommandHistoryFile;
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido (não é um array JSON), inicializando novo histórico.');
        InitializeCommandHistoryFile;
      end;
    finally
      jsonData.Free;
    end;
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
      Memo1.Lines.Add('Inicializando novo arquivo de histórico devido a erro.');
      InitializeCommandHistoryFile;
      commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.LimitMemoLines(MaxLines: Integer);
begin
  // Limitar o número de linhas no TMemo para evitar sobrecarga
  while Memo1.Lines.Count > MaxLines do
    Memo1.Lines.Delete(0);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    // Limitar o número de linhas no TMemo
    LimitMemoLines(1000);
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 200; // Aumentado para 200 ms para lidar com saídas longas
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//============================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.5.52
   Data: 19/04/2025
   Hora: 18:27:00 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure InitializeCommandHistoryFile; // Inicializar o arquivo de histórico
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
    procedure LimitMemoLines(MaxLines: Integer); // Limitar o número de linhas no TMemo
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.InitializeCommandHistoryFile;
var
  jsonFile: TextFile;
begin
  // Se o arquivo não existir, cria um arquivo JSON válido com um array vazio
  if not FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, '[]'); // Array JSON vazio
      CloseFile(jsonFile);
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao criar arquivo de histórico: ' + E.Message);
    end;
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  fileContent: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  // Inicializar o arquivo de histórico se ele não existir
  InitializeCommandHistoryFile;

  try
    // Ler o arquivo JSON
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Reset(jsonFile);
    jsonString := '';
    while not EOF(jsonFile) do
    begin
      ReadLn(jsonFile, fileContent);
      jsonString := jsonString + fileContent;
    end;
    CloseFile(jsonFile);

    // Verificar se o arquivo está vazio ou contém apenas "[]"
    jsonString := Trim(jsonString);
    if (jsonString = '') or (jsonString = '[]') then
    begin
      Exit;
    end;

    // Tentar parsear o JSON
    try
      jsonData := GetJSON(jsonString);
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao parsear JSON: ' + E.Message);
        Memo1.Lines.Add('Sobrescrevendo arquivo de histórico com formato válido.');
        InitializeCommandHistoryFile;
        Exit;
      end;
    end;

    try
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        InitializeCommandHistoryFile;
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido (não é um array JSON), inicializando novo histórico.');
        InitializeCommandHistoryFile;
      end;
    finally
      jsonData.Free;
    end;
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
      Memo1.Lines.Add('Inicializando novo arquivo de histórico devido a erro.');
      InitializeCommandHistoryFile;
      commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.LimitMemoLines(MaxLines: Integer);
begin
  // Limitar o número de linhas no TMemo para evitar sobrecarga
  while Memo1.Lines.Count > MaxLines do
    Memo1.Lines.Delete(0);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('--norc'); // Não carregar arquivos de configuração
    shellArgs[3] := PChar('-c');
    shellArgs[4] := PChar('export COLUMNS=80 LINES=24 TERM=xterm PS1="\W\\$ "; exec /bin/bash -i --norc');
    shellArgs[5] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    // Limitar o número de linhas no TMemo
    LimitMemoLines(1000);
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 200; // Aumentado para 200 ms para lidar com saídas longas
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//==================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.4.0
   Data: 19/04/2025 18:21:00 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure InitializeCommandHistoryFile; // Inicializar o arquivo de histórico
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
    procedure LimitMemoLines(MaxLines: Integer); // Limitar o número de linhas no TMemo
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.InitializeCommandHistoryFile;
var
  jsonFile: TextFile;
begin
  // Se o arquivo não existir, cria um arquivo JSON válido com um array vazio
  if not FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, '[]'); // Array JSON vazio
      CloseFile(jsonFile);
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao criar arquivo de histórico: ' + E.Message);
    end;
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  fileContent: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  // Inicializar o arquivo de histórico se ele não existir
  InitializeCommandHistoryFile;

  try
    // Ler o arquivo JSON
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Reset(jsonFile);
    jsonString := '';
    while not EOF(jsonFile) do
    begin
      ReadLn(jsonFile, fileContent);
      jsonString := jsonString + fileContent;
    end;
    CloseFile(jsonFile);

    // Verificar se o arquivo está vazio ou contém apenas "[]"
    jsonString := Trim(jsonString);
    if (jsonString = '') or (jsonString = '[]') then
    begin
      Exit;
    end;

    // Tentar parsear o JSON
    try
      jsonData := GetJSON(jsonString);
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao parsear JSON: ' + E.Message);
        Memo1.Lines.Add('Sobrescrevendo arquivo de histórico com formato válido.');
        InitializeCommandHistoryFile;
        Exit;
      end;
    end;

    try
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        InitializeCommandHistoryFile;
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido (não é um array JSON), inicializando novo histórico.');
        InitializeCommandHistoryFile;
      end;
    finally
      jsonData.Free;
    end;
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
      Memo1.Lines.Add('Inicializando novo arquivo de histórico devido a erro.');
      InitializeCommandHistoryFile;
      commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.LimitMemoLines(MaxLines: Integer);
begin
  // Limitar o número de linhas no TMemo para evitar sobrecarga
  while Memo1.Lines.Count > MaxLines do
    Memo1.Lines.Delete(0);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    // Limitar o número de linhas no TMemo
    LimitMemoLines(1000);
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 200; // Aumentado para 200 ms para lidar com saídas longas
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.3.0
   Data: 19/04/2025 17:37:00 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure InitializeCommandHistoryFile; // Inicializar o arquivo de histórico
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.InitializeCommandHistoryFile;
var
  jsonFile: TextFile;
begin
  // Se o arquivo não existir, cria um arquivo JSON válido com um array vazio
  if not FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, '[]'); // Array JSON vazio
      CloseFile(jsonFile);
      Memo1.Lines.Add('Arquivo de histórico criado: EmbeddedTerminalUnit.json');
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao criar arquivo de histórico: ' + E.Message);
    end;
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  i: Integer;
  fileContent: String;
begin
  commandHistory.Clear;
  historyIndex := -1;

  // Inicializar o arquivo de histórico se ele não existir
  InitializeCommandHistoryFile;

  try
    // Ler o arquivo JSON
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Reset(jsonFile);
    jsonString := '';
    while not EOF(jsonFile) do
    begin
      ReadLn(jsonFile, fileContent);
      jsonString := jsonString + fileContent;
    end;
    CloseFile(jsonFile);

    // Verificar se o arquivo está vazio ou contém apenas "[]"
    jsonString := Trim(jsonString);
    if (jsonString = '') or (jsonString = '[]') then
    begin
      Memo1.Lines.Add('Histórico vazio, nenhum comando carregado.');
      Exit;
    end;

    // Log do conteúdo do arquivo para depuração
    Memo1.Lines.Add('Conteúdo do arquivo de histórico: ' + jsonString);

    // Tentar parsear o JSON
    try
      jsonData := GetJSON(jsonString);
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao parsear JSON: ' + E.Message);
        Memo1.Lines.Add('Sobrescrevendo arquivo de histórico com formato válido.');
        InitializeCommandHistoryFile;
        Exit;
      end;
    end;

    try
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        InitializeCommandHistoryFile;
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
        Memo1.Lines.Add('Histórico carregado com ' + IntToStr(commandHistory.Count) + ' comandos.');
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido (não é um array JSON), inicializando novo histórico.');
        InitializeCommandHistoryFile;
      end;
    finally
      jsonData.Free;
    end;
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
      Memo1.Lines.Add('Inicializando novo arquivo de histórico devido a erro.');
      InitializeCommandHistoryFile;
      commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);

      // Log para depuração
      Memo1.Lines.Add('Histórico salvo com ' + IntToStr(commandHistory.Count) + ' comandos.');
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.



//=====================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.1.0
   Data: 19/04/2025 17:28:00 hs (Horário de Brasília)
   Estado da versão: Não Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  if FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      // Ler o arquivo JSON
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Reset(jsonFile);
      jsonString := '';
      while not EOF(jsonFile) do
      begin
        ReadLn(jsonFile, jsonString);
      end;
      CloseFile(jsonFile);

      // Verificar se o arquivo está vazio ou contém apenas "[]"
      if Trim(jsonString) = '' then
      begin
        Memo1.Lines.Add('Arquivo de histórico vazio, inicializando novo histórico.');
        Exit;
      end;
      if Trim(jsonString) = '[]' then
      begin
        Memo1.Lines.Add('Histórico vazio, nenhum comando carregado.');
        Exit;
      end;

      // Parsear o JSON
      jsonData := GetJSON(jsonString);
      if not Assigned(jsonData) then
      begin
        Memo1.Lines.Add('Erro: Arquivo de histórico inválido, inicializando novo histórico.');
        Exit;
      end;

      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end
      else
      begin
        Memo1.Lines.Add('Erro: Formato de histórico inválido, inicializando novo histórico.');
      end;
      jsonData.Free;
    except
      on E: Exception do
      begin
        Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
        commandHistory.Clear; // Garantir que o histórico esteja limpo em caso de erro
      end;
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    try
      for i := 0 to commandHistory.Count - 1 do
        jsonArray.Add(commandHistory[i]);

      // Salvar no arquivo
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Rewrite(jsonFile);
      WriteLn(jsonFile, jsonArray.FormatJSON);
      CloseFile(jsonFile);
    finally
      jsonArray.Free;
    end;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.



//==============================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.3.0.0
   Data: 19/04/2025 17:14:00 hs (Horário de Brasília)
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    commandHistory: TStringList; // Histórico de comandos
    historyIndex: Integer; // Índice atual no histórico para navegação
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
    procedure LoadCommandHistory; // Carregar o histórico do arquivo JSON
    procedure SaveCommandHistory; // Salvar o histórico no arquivo JSON
    procedure AddCommandToHistory(const Command: String); // Adicionar comando ao histórico
    procedure NavigateHistory(Direction: Integer); // Navegar pelo histórico (setas)
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.LoadCommandHistory;
var
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  jsonString: String;
  i: Integer;
begin
  commandHistory.Clear;
  historyIndex := -1;

  if FileExists('EmbeddedTerminalUnit.json') then
  begin
    try
      // Ler o arquivo JSON
      AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
      Reset(jsonFile);
      jsonString := '';
      while not EOF(jsonFile) do
      begin
        ReadLn(jsonFile, jsonString);
      end;
      CloseFile(jsonFile);

      // Parsear o JSON
      jsonData := GetJSON(jsonString);
      if jsonData is TJSONArray then
      begin
        jsonArray := TJSONArray(jsonData);
        for i := 0 to jsonArray.Count - 1 do
        begin
          if jsonArray.Types[i] = jtString then
            commandHistory.Add(jsonArray.Strings[i]);
        end;
      end;
      jsonData.Free;
    except
      on E: Exception do
        Memo1.Lines.Add('Erro ao carregar histórico: ' + E.Message);
    end;
  end;

  // Definir o índice para o final do histórico (nenhum comando selecionado)
  historyIndex := commandHistory.Count;
end;

procedure TForm1.SaveCommandHistory;
var
  jsonArray: TJSONArray;
  jsonFile: TextFile;
  i: Integer;
begin
  try
    // Criar um array JSON com o histórico
    jsonArray := TJSONArray.Create;
    for i := 0 to commandHistory.Count - 1 do
      jsonArray.Add(commandHistory[i]);

    // Salvar no arquivo
    AssignFile(jsonFile, 'EmbeddedTerminalUnit.json');
    Rewrite(jsonFile);
    WriteLn(jsonFile, jsonArray.FormatJSON);
    CloseFile(jsonFile);

    jsonArray.Free;
  except
    on E: Exception do
      Memo1.Lines.Add('Erro ao salvar histórico: ' + E.Message);
  end;
end;

procedure TForm1.AddCommandToHistory(const Command: String);
begin
  // Evitar duplicatas consecutivas
  if (commandHistory.Count = 0) or (commandHistory[commandHistory.Count - 1] <> Command) then
  begin
    commandHistory.Add(Command);
    SaveCommandHistory;
  end;
  // Definir o índice para o final do histórico
  historyIndex := commandHistory.Count;
end;

procedure TForm1.NavigateHistory(Direction: Integer);
begin
  if commandHistory.Count = 0 then Exit;

  // Ajustar o índice com base na direção (1 para baixo, -1 para cima)
  historyIndex := historyIndex + Direction;

  // Garantir que o índice seja cíclico
  if historyIndex < 0 then
    historyIndex := commandHistory.Count - 1
  else if historyIndex >= commandHistory.Count then
    historyIndex := 0;

  // Exibir o comando do histórico, mantendo o prompt
  if (historyIndex >= 0) and (historyIndex < commandHistory.Count) then
    InputEdit.Text := currentPrompt + commandHistory[historyIndex]
  else
    InputEdit.Text := currentPrompt; // Limpar se não houver comando

  // Posicionar o cursor no final do texto
  InputEdit.SelStart := Length(InputEdit.Text);
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Inicializar o histórico de comandos
  commandHistory := TStringList.Create;
  historyIndex := -1;
  LoadCommandHistory; // Carregar o histórico do arquivo
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
  commandHistory.Free; // Liberar o histórico
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
  command: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  command := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text)));
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  // Adicionar o comando ao histórico
  AddCommandToHistory(command);
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_UP, VK_DOWN]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
  // Capturar setas para cima e para baixo para navegar pelo histórico
  if Key = VK_UP then
  begin
    NavigateHistory(-1); // Navegar para o comando anterior
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end
  else if Key = VK_DOWN then
  begin
    NavigateHistory(1); // Navegar para o comando seguinte
    Key := 0; // Cancelar a tecla para evitar comportamento padrão
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.9.0
   Data: 19/04/2025 16:49 hs
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
  public
  end;

var
  Form1: TForm1;

// Importar a função setenv da biblioteca C padrão (libc)
function setenv(name, value: PChar; overwrite: cint): cint; cdecl; external 'c';

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv
    SetLength(shellArgs, 3);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando setenv
    if setenv('COLUMNS', '80', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir COLUMNS: ', StrError(fpGetErrno));
    if setenv('LINES', '24', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir LINES: ', StrError(fpGetErrno));
    if setenv('TERM', 'xterm', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir TERM: ', StrError(fpGetErrno));
    if setenv('PS1', '\W\$ ', 1) <> 0 then
      Writeln(StdErr, 'Erro ao definir PS1: ', StrError(fpGetErrno));

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.7.0
   Estado da versão: Não Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 4);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('--norc'); // Não carregar arquivos de configuração
    shellArgs[3] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente usando SetEnvironmentVariable
    SetEnvironmentVariable('COLUMNS', '80');
    SetEnvironmentVariable('LINES', '24');
    SetEnvironmentVariable('TERM', 'xterm');
    SetEnvironmentVariable('PS1', '\W\$ ');

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//===========================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.6.0
   Estado da versão: Não Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Função para remover sequências ANSI
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 4);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('--norc'); // Não carregar arquivos de configuração
    shellArgs[3] := nil; // Terminar o array com nil

    // Definir variáveis de ambiente
    fpSetenv('COLUMNS', '80', 1);
    fpSetenv('LINES', '24', 1);
    fpSetenv('TERM', 'xterm', 1);
    fpSetenv('PS1', '\W\\$ ', 1);

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.5.0
   Estado da versão: Não Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
    function StripAnsi(const s: String): String; // Nova função para remover sequências ANSI
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

function TForm1.StripAnsi(const s: String): String;
var
  i: Integer;
  inEscape: Boolean;
  resultStr: String;
begin
  resultStr := '';
  inEscape := False;
  for i := 1 to Length(s) do
  begin
    if s[i] = #27 then // Código de escape ANSI começa com ESC (#27)
    begin
      inEscape := True;
      Continue;
    end;
    if inEscape then
    begin
      // Sequências ANSI geralmente terminam com uma letra (como 'm', 'h', etc.)
      if (s[i] in ['A'..'Z', 'a'..'z']) then
        inEscape := False;
      Continue;
    end;
    resultStr := resultStr + s[i];
  end;
  Result := resultStr;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 6);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('--norc'); // Não carregar arquivos de configuração
    shellArgs[3] := PChar('-c');
    shellArgs[4] := PChar('export COLUMNS=80 LINES=24 TERM=xterm PS1="\W\\$ "; echo "COLUMNS=$COLUMNS"; exec /bin/bash -i --norc');
    shellArgs[5] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := StripAnsi(Copy(output, 1, lineBreakPos-1)); // Remover sequências ANSI
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        line := StripAnsi(output); // Remover sequências ANSI
        if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//====================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.4.0
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/bash como shell padrão
  shellPath := '/bin/bash';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /bin/sh...');
    shellPath := '/bin/sh';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm PS1="\W\\$ "; echo "COLUMNS=$COLUMNS"; exec /bin/bash -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        if (Length(output) > 0) and (output[Length(output)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//======================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.3.0
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm PS1="\W\\$ "; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha termina com '$', indicando que é o prompt
        else if (Length(line) > 0) and (line[Length(line)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante termina com '$', indicando que é o prompt
        if (Length(output) > 0) and (output[Length(output)] = '$') then
        begin
          if not promptDetected then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end
          else
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
          end;
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//======================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.2.0
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  // Posicionar o cursor na última linha
  Memo1.CaretPos := Point(0, Memo1.Lines.Count - 1);
  // Garantir que a última linha esteja visível
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  // Forçar atualização visual
  Application.ProcessMessages;
  Memo1.Repaint;
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end
        // Verificar se a linha é o prompt do shell
        else if not promptDetected then
        begin
          // Considerar a primeira linha não vazia e sem conteúdo de inicialização como o prompt
          if (Length(line) > 0) and (line[1] in ['$']) then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if line = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if not promptDetected then
        begin
          if (Length(output) > 0) and (output[1] in ['$']) then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if output = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
          ScrollMemoToBottom; // Rolar para a última linha após adicionar
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após processar todas as linhas
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//======================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.2.1.7
   Estado da versão: Funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count * 100); // Forçar rolagem para o final com um valor grande
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
        end
        // Verificar se a linha é o prompt do shell
        else if not promptDetected then
        begin
          // Considerar a primeira linha não vazia e sem conteúdo de inicialização como o prompt
          if (Length(line) > 0) and (line[1] in ['$']) then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if line = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if not promptDetected then
        begin
          if (Length(output) > 0) and (output[1] in ['$']) then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if output = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if InputEdit.CanFocus then
    InputEdit.SetFocus; // Focar o cursor no InputEdit quando o formulário for exibido
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//==========================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.2.6
   Estado da versão: Não funcional
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ' + StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count * 100); // Forçar rolagem para o final com um valor grande
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
        end
        // Verificar se a linha é o prompt do shell
        else if not promptDetected then
        begin
          // Considerar a primeira linha não vazia e sem conteúdo de inicialização como o prompt
          if (Length(line) > 0) and (line[1] in ['$']) then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if line = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if not promptDetected then
        begin
          if (Length(output) > 0) and (output[1] in ['$']) then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if output = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
    InputEdit.SetFocus; // Focar o cursor no InputEdit
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
  begin
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
    ScrollMemoToBottom; // Garantir que o Memo1 role para a última linha
  end;
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//======================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.2.5
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Ignorar linhas de inicialização como COLUMNS=80
        if Pos('COLUMNS=', line) > 0 then
        begin
          Memo1.Lines.Add(line);
        end
        // Verificar se a linha é o prompt do shell
        else if not promptDetected then
        begin
          // Considerar a primeira linha não vazia e sem conteúdo de inicialização como o prompt
          if (Length(line) > 0) and (line[1] in ['$']) then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if line = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if not promptDetected then
        begin
          if (Length(output) > 0) and (output[1] in ['$']) then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if output = TrimRight(currentPrompt) then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//==================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.2.4
   Observação: Não funciona.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    promptDetected: Boolean; // Controlar se o prompt já foi detectado
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0);
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Verificar se a linha é o prompt do shell
        if not promptDetected then
        begin
          // A primeira linha após COLUMNS=80 é o prompt
          if Pos('COLUMNS=', line) = 0 then
          begin
            currentPrompt := line + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if line = currentPrompt then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if not promptDetected then
        begin
          if Pos('COLUMNS=', output) = 0 then
          begin
            currentPrompt := output + ' ';
            InputEdit.Text := currentPrompt;
            promptDetected := True;
          end;
        end
        else if output = currentPrompt then
        begin
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  promptDetected := False; // Inicializar como falso
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

//===============================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.2.3
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
    procedure SendCtrlC;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns
  Result := (Pos('ls: não foi possível abrir o diretório', line) > 0) or
            (Pos(': not found', line) > 0); // Filtra erros como "command: not found"
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.SendCtrlC;
begin
  if (masterFD <> -1) and (childPID > 0) then
  begin
    // Enviar o caractere Ctrl+C (ASCII 3) para o PTY
    if fpWrite(masterFD, PChar(#3), 1) = -1 then
    begin
      Memo1.Lines.Add('Erro ao enviar Ctrl+C: ' + StrError(fpGetErrno));
    end;
    // Alternativamente, enviar SIGINT diretamente ao processo filho
    fpKill(childPID, SIGINT);
  end;
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Verificar se a linha é o prompt do shell
        if line = '$' then
        begin
          currentPrompt := line + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if output = '$' then
        begin
          currentPrompt := output + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
  // Capturar Ctrl+C para enviar SIGINT ao shell
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    SendCtrlC;
    Key := 0; // Cancelar a tecla para evitar que o Ctrl+C seja processado pelo Lazarus
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


//===================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
    Versão: 0.1.2.2
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio, LCLType; // Adicionado LCLType

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns, como "ls: não foi possível abrir o diretório"
  Result := Pos('ls: não foi possível abrir o diretório', line) > 0;
  // Adicione outros padrões de erro aqui, se necessário
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Verificar se a linha é o prompt do shell
        if line = '$' then
        begin
          currentPrompt := line + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if output = '$' then
        begin
          currentPrompt := output + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  Memo1.ScrollBars := ssAutoBoth; // Adicionado para suportar rolagem horizontal e vertical
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  // Extrair o comando, ignorando o prompt
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding;
  if s = LineEnding then Exit; // Evitar enviar comando vazio
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Proteger o prompt de ser editado ou apagado
  if (Key = VK_BACK) or (Key = VK_DELETE) then
  begin
    // Impedir a exclusão se o cursor estiver dentro do prompt
    if InputEdit.SelStart < Length(currentPrompt) then
    begin
      Key := 0; // Cancelar a tecla
    end;
  end;
  // Impedir a digitação antes do prompt
  if (InputEdit.SelStart < Length(currentPrompt)) and not (Key in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
  begin
    InputEdit.SelStart := Length(InputEdit.Text);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.



//===========================================
unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.1.1
 
}
}
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
  private
    masterFD: cint;
    childPID: pid_t;
    currentPrompt: String; // Armazenar o prompt real do shell
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
    function IsErrorMessage(const line: String): Boolean;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

function ioctl(fd: cint; request: culong; argp: pointer): cint; cdecl;
  external 'libc' name 'ioctl';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

{ TForm1 }

function TForm1.IsErrorMessage(const line: String): Boolean;
begin
  // Filtrar mensagens de erro comuns, como "ls: não foi possível abrir o diretório"
  Result := Pos('ls: não foi possível abrir o diretório', line) > 0;
  // Adicione outros padrões de erro aqui, se necessário
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL or IXON or IXOFF or BRKINT or IGNPAR; // Mapear CR para NL, controle de fluxo, entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD or CLOCAL;          // 8 bits por caractere, leitura habilitada, controle local

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Criar uma nova sessão para o processo filho
    if fpSetSid = -1 then
    begin
      Writeln(StdErr, 'Erro ao criar nova sessão: ', StrError(fpGetErrno));
    end;

    // Definir o PTY como terminal de controle
    if ioctl(0, TIOCSCTTY, nil) = -1 then
    begin
      Writeln(StdErr, 'Erro ao definir PTY como terminal de controle: ', StrError(fpGetErrno));
    end;

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
  line: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        line := Copy(output, 1, lineBreakPos-1);
        // Verificar se a linha é o prompt do shell
        if line = '$' then
        begin
          currentPrompt := line + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(line) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(line);
        end;
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Verificar se a saída restante é o prompt do shell
        if output = '$' then
        begin
          currentPrompt := output + ' ';
          InputEdit.Text := currentPrompt; // Exibir o prompt real no InputEdit
        end
        else if not IsErrorMessage(output) then // Filtrar mensagens de erro
        begin
          Memo1.Lines.Add(output);
        end;
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  currentPrompt := '$ '; // Prompt inicial padrão
  // Definir a fonte do Memo1 como "Courier New" para garantir formatação correta
  Memo1.Font.Name := 'Courier New';
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := currentPrompt; // Exibir o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = currentPrompt then Exit; // Evitar enviar comando vazio
  s := Trim(Copy(InputEdit.Text, Length(currentPrompt) + 1, Length(InputEdit.Text))) + LineEnding; // Remover o prompt real
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := currentPrompt; // Restaurar o prompt real
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.


unit EmbeddedTerminalUnit;
{: Este unit implementa um terminal embutido no formulário gráfico.
   Programador: Grok
   Analista: Paulo Pacheco
   Data: 19/04/2025
   Versão: 0.1.0.1
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unix, BaseUnix, unixtype, ctypes, termio;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    InputEdit: TEdit;
    SendBtn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
  private
    masterFD: cint;
    childPID: pid_t;
    procedure StartShell;
    procedure ReadFromPTY;
    procedure SetNonBlocking(fd: cint);
    procedure ScrollMemoToBottom;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function openpty(out amaster, aslave: cint; name: PChar; termp, winp: pointer): cint; cdecl;
  external 'libutil' name 'openpty';

// Constantes POSIX definidas manualmente
const
  EAGAIN = 11;    // Operação não bloqueante sem dados
  EIO = 5;        // Erro de entrada/saída
  ENOENT = 2;     // Arquivo ou diretório não encontrado
  EACCES = 13;    // Permissão negada
  ENOEXEC = 8;    // Formato de executável inválido

// Função StrError simplificada
function StrError(err: cint): String;
begin
  case err of
    EAGAIN: Result := 'Nenhum dado disponível (EAGAIN)';
    EIO: Result := 'Erro de entrada/saída (EIO)';
    ENOENT: Result := 'Arquivo não encontrado (ENOENT)';
    EACCES: Result := 'Permissão negada (EACCES)';
    ENOEXEC: Result := 'Formato de executável inválido (ENOEXEC)';
    else Result := 'Erro desconhecido (' + IntToStr(err) + ')';
  end;
end;

procedure TForm1.SetNonBlocking(fd: cint);
var
  flags: cint;
begin
  flags := fpFcntl(fd, F_GETFL, 0);
  if flags = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter flags do descritor: ' + StrError(fpGetErrno));
    Exit;
  end;
  if fpFcntl(fd, F_SETFL, flags or O_NONBLOCK) = -1 then
    Memo1.Lines.Add('Erro ao configurar modo não bloqueante: ' + StrError(fpGetErrno));
end;

procedure TForm1.StartShell;
var
  slaveFD: cint;
  shellPath: String;
  shellArgs: array of PChar;
  term: termios;
  winsize: TWinSize;
begin
  // Inicializar estrutura termios
  FillChar(term, SizeOf(term), 0);
  if TCGetAttr(0, term) = -1 then
  begin
    Memo1.Lines.Add('Erro ao obter atributos do terminal: ' + StrError(fpGetErrno));
  end;
  term.c_lflag := term.c_lflag or ICANON or ECHO or ISIG or IEXTEN; // Modo canônico, eco, sinais e extensões
  term.c_iflag := term.c_iflag or ICRNL;                           // Mapear CR para NL na entrada
  term.c_oflag := term.c_oflag or OPOST or ONLCR;                  // Processar saída e mapear NL para CR-NL
  term.c_cflag := term.c_cflag or CS8 or CREAD;                   // 8 bits por caractere, leitura habilitada

  // Configurar o tamanho da janela do terminal
  FillChar(winsize, SizeOf(winsize), 0);
  winsize.ws_row := 24; // Linhas
  winsize.ws_col := 80; // Colunas
  winsize.ws_xpixel := 0;
  winsize.ws_ypixel := 0;

  // Tentar abrir o PTY com configurações de terminal
  if openpty(masterFD, slaveFD, nil, @term, @winsize) = -1 then
  begin
    Memo1.Lines.Add('Erro ao criar PTY: ' + StrError(fpGetErrno));
    Exit;
  end;
  Memo1.Lines.Add('PTY criado com sucesso. masterFD: ' + IntToStr(masterFD) + ', slaveFD: ' + IntToStr(slaveFD));

  // Configurar modo não bloqueante
  SetNonBlocking(masterFD);

  // Tentar usar /bin/sh como shell padrão
  shellPath := '/bin/sh';
  if not FileExists(shellPath) then
  begin
    Memo1.Lines.Add('Shell ' + shellPath + ' não encontrado. Tentando /usr/bin/bash...');
    shellPath := '/usr/bin/bash';
    if not FileExists(shellPath) then
    begin
      Memo1.Lines.Add('Shell ' + shellPath + ' também não encontrado. Abortando.');
      fpClose(masterFD);
      fpClose(slaveFD);
      masterFD := -1;
      Exit;
    end;
  end;

  // Criar processo filho
  childPID := fpFork;
  if childPID = 0 then
  begin
    // Processo filho
    fpClose(masterFD);
    fpDup2(slaveFD, 0); // stdin
    fpDup2(slaveFD, 1); // stdout
    fpDup2(slaveFD, 2); // stderr
    fpClose(slaveFD);

    // Preparar argumentos para fpExecv com inicialização do ambiente
    SetLength(shellArgs, 5);
    shellArgs[0] := PChar(shellPath);
    shellArgs[1] := PChar('-i'); // Modo interativo
    shellArgs[2] := PChar('-c');
    shellArgs[3] := PChar('export COLUMNS=80 LINES=24 TERM=xterm; echo "COLUMNS=$COLUMNS"; exec /bin/sh -i');
    shellArgs[4] := nil; // Terminar o array com nil

    // Log antes de executar o shell
    Writeln(StdErr, 'Processo filho iniciado. Tentando executar: ' + shellPath);

    // Tentar executar o shell com as variáveis de ambiente
    fpExecv(shellPath, PPChar(@shellArgs[0]));
    // Se fpExecv falhar, exibir erro e encerrar o processo filho
    Writeln(StdErr, 'Erro ao executar ' + shellPath + ': ', StrError(fpGetErrno));
    Halt(1);
  end
  else if childPID > 0 then
  begin
    // Processo pai
    Memo1.Lines

.Add('Processo filho criado com PID: ' + IntToStr(childPID));
    fpClose(slaveFD);
  end
  else
  begin
    Memo1.Lines.Add('Erro ao criar processo: ' + StrError(fpGetErrno));
    fpClose(masterFD);
    fpClose(slaveFD);
    masterFD := -1; // Marcar como inválido
  end;
end;

procedure TForm1.ScrollMemoToBottom;
begin
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.SelLength := 0;
  Memo1.ScrollBy(0, Memo1.Lines.Count); // Forçar rolagem para o final
  Application.ProcessMessages; // Garantir que o componente atualize
  Memo1.Repaint; // Forçar atualização visual
end;

procedure TForm1.ReadFromPTY;
var
  buffer: array[0..1023] of char;
  count: Integer;
  output: String;
  lineBreakPos: Integer;
  lineEnd: String;
begin
  // Verificar se masterFD é válido
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível ler.');
    Timer1.Enabled := False;
    Exit;
  end;

  FillChar(buffer, SizeOf(buffer), 0);
  count := fpRead(masterFD, buffer, SizeOf(buffer)-1);
  if count > 0 then
  begin
    buffer[count] := #0;
    output := Copy(buffer, 1, count);
    // Dividir a saída em linhas com base em quebras de linha (#10 ou #13)
    lineEnd := #10; // Usar LF como padrão para Unix
    while output <> '' do
    begin
      lineBreakPos := Pos(lineEnd, output);
      if lineBreakPos = 0 then
        lineBreakPos := Pos(#13, output); // Tentar CR se LF não for encontrado
      if lineBreakPos > 0 then
      begin
        // Evitar adicionar o prompt $ como uma linha separada
        if Copy(output, 1, lineBreakPos-1) <> '$' then
          Memo1.Lines.Add(Copy(output, 1, lineBreakPos-1));
        Delete(output, 1, lineBreakPos);
        // Remover CR ou LF adicional se for uma sequência CR+LF
        if (Length(output) > 0) and (output[1] in [#10, #13]) then
          Delete(output, 1, 1);
      end
      else
      begin
        // Evitar adicionar o prompt $ como uma linha separada
        if output <> '$' then
          Memo1.Lines.Add(output);
        output := '';
      end;
    end;
    ScrollMemoToBottom; // Rolar para o final após adicionar texto
  end
  else if count = 0 then
  begin
    Memo1.Lines.Add('Shell terminado.');
    Timer1.Enabled := False;
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
    ScrollMemoToBottom;
  end
  else if (count = -1) and (fpGetErrno <> EAGAIN) then
  begin
    Memo1.Lines.Add('Erro ao ler PTY: ' + StrError(fpGetErrno));
    // Desativar timer se for um erro crítico como EIO
    if fpGetErrno = EIO then
    begin
      Timer1.Enabled := False;
      SendBtn.Enabled := False;
      InputEdit.Enabled := False;
    end;
    ScrollMemoToBottom;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  masterFD := -1;
  childPID := 0;
  StartShell;
  if (childPID > 0) and (masterFD <> -1) then
  begin
    Timer1.Interval := 100;
    Timer1.Enabled := True;
    InputEdit.Text := '$ '; // Simular o prompt inicial
  end
  else
  begin
    Memo1.Lines.Add('Falha ao iniciar o shell. Verifique os erros acima.');
    SendBtn.Enabled := False;
    InputEdit.Enabled := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if masterFD <> -1 then fpClose(masterFD);
  if childPID > 0 then fpKill(childPID, SIGTERM);
end;

procedure TForm1.SendBtnClick(Sender: TObject);
var
  s: String;
begin
  if masterFD = -1 then
  begin
    Memo1.Lines.Add('PTY inválido. Não é possível enviar comandos.');
    ScrollMemoToBottom;
    Exit;
  end;
  if InputEdit.Text = '$ ' then Exit; // Evitar enviar comando vazio
  s := Trim(Copy(InputEdit.Text, 3, Length(InputEdit.Text))) + LineEnding; // Remover o prompt simulado
  if fpWrite(masterFD, PChar(s)^, Length(s)) = -1 then
  begin
    Memo1.Lines.Add('Erro ao escrever no PTY: ' + StrError(fpGetErrno));
    ScrollMemoToBottom;
  end
  else
    InputEdit.Text := '$ '; // Restaurar o prompt simulado
end;

procedure TForm1.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // #13 é o código para a tecla Enter
  begin
    Key := #0; // Impedir que o Enter adicione uma nova linha no TEdit
    SendBtnClick(Sender); // Chamar a mesma lógica do botão Enviar
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ReadFromPTY;
end;

end.

