# Documentação da Unit FrameLCL_u

**Autor:** Paulo Sérgio da Silva Pacheco
**Criação:** 22/07/2025
**Última Modificação:** 27/07/2025

## 1. Visão Geral

A unit `FrameLCL_u` fornece a classe `TFrameLCL`, uma implementação para a criação de interfaces gráficas em ambiente de console utilizando a Lazarus Component Library (LCL). Esta unit encapsula a complexidade de manipulação de baixo nível do console, oferecendo uma API de alto nível para desenvolvimento de aplicações de console ricas e interativas.

### 1.1. Principais Funcionalidades

* **Manipulação de Eventos:** Suporte completo a eventos de teclado e mouse, permitindo a criação de interfaces responsivas.
* **Constantes Abrangentes:** Uma vasta gama de constantes para teclas virtuais, combinações de teclas e eventos de controle, facilitando o desenvolvimento de interações complexas.
* **Gerenciamento de Tela:** Controle total sobre o buffer de tela, incluindo modos de vídeo, manipulação de cursor e operações de escrita de caracteres e atributos.
* **Configuração do Console:** Funções para configurar a fonte, tamanho e outras propriedades do console.
* **Recursos Gráficos:** Funções para desenhar e manipular elementos na tela, permitindo a criação de interfaces gráficas no console.

### 1.2. Exemplo de Uso Básico

```pascal
var
  Frame: TFrameLCL;
begin
  Frame := TFrameLCL.Create(Self);
  Frame.SetVideoMode(80, 25);
  Frame.WriteStr(10, 5, 'Hello World!', $0F);
  Frame.ShowBuffer(Frame.ScreenBuffer);
end;
```




## 2. Tipos e Constantes

### 2.1. TCtrlEvent

`TCtrlEvent` é um tipo enumerado que define os códigos de eventos de controle que podem ser gerados pelo sistema operacional, alinhados com os eventos do Windows. Estes eventos são cruciais para o tratamento de interrupções e operações de sistema que afetam a aplicação de console.

**Eventos de Controle Incluídos:**
*   `CTRL_C_EVENT`: Gerado quando o usuário pressiona Ctrl+C.
*   `CTRL_BREAK_EVENT`: Gerado quando o usuário pressiona Ctrl+Break.
*   `CTRL_CLOSE_EVENT`: Gerado quando o usuário tenta fechar a janela do console.
*   `CTRL_LOGOFF_EVENT`: Gerado quando o usuário faz logoff do sistema.
*   `CTRL_SHUTDOWN_EVENT`: Gerado quando o sistema está sendo desligado.

**Uso:**
Este tipo é utilizado em manipuladores de eventos para determinar a natureza da interrupção ou evento de controle, permitindo que a aplicação reaja apropriadamente, como salvar dados antes de fechar ou liberar recursos.

### 2.2. Constantes de Teclas Virtuais

A unit `FrameLCL_u` expõe um conjunto abrangente de constantes para teclas virtuais, mapeadas diretamente da unit `ConsoleGraphicVideo`. Estas constantes são essenciais para a detecção e manipulação de entradas do teclado e mouse, fornecendo uma interface padronizada para eventos de entrada.

**Categorias Principais:**
*   **Botões do Mouse:** `VK_LBUTTON`, `VK_RBUTTON`, `VK_MBUTTON`, `VK_XBUTTON1`, `VK_XBUTTON2`.
*   **Teclas Modificadoras:** `VK_SHIFT`, `VK_CONTROL`, `VK_MENU` (Alt), `VK_CAPITAL` (Caps Lock), `VK_NUMLOCK` (Num Lock), `VK_SCROLL` (Scroll Lock).
*   **Teclas de Navegação:** `VK_HOME`, `VK_END`, `VK_UP`, `VK_DOWN`, `VK_LEFT`, `VK_RIGHT`, `VK_PRIOR` (Page Up), `VK_NEXT` (Page Down).
*   **Teclado Numérico:** `VK_NUMPAD0` a `VK_NUMPAD9`, `VK_MULTIPLY`, `VK_ADD`, `VK_SEPARATOR`, `VK_SUBTRACT`, `VK_DECIMAL`, `VK_DIVIDE`.
*   **Teclas de Função (F1-F24):** `VK_F1` a `VK_F24`.
*   **Teclas Especiais:** `VK_BACK` (Backspace), `VK_TAB`, `VK_RETURN` (Enter), `VK_ESCAPE`, `VK_SPACE`, `VK_INSERT`, `VK_DELETE`, `VK_HELP`, `VK_PRINT`, `VK_EXECUTE`, `VK_SNAPSHOT`, `VK_LWIN`, `VK_RWIN`, `VK_APPS`, `VK_SLEEP`.

**Combinações de Teclas Comuns:**
Além das teclas virtuais individuais, a unit define constantes para combinações de teclas frequentemente usadas, como `kbEsc`, `kbAltSpace`, `kbCtrlIns`, `kbShiftIns`, `kbCtrlDel`, `kbShiftDel`, `kbBack`, `kbCtrlBack`, `kbShiftTab`, `kbTab`, e várias combinações `Alt+Letra` (`kbAltA` a `kbAltZ`), `Ctrl+Letra` (`kbCtrlA` a `kbCtrlZ`), e `Shift/Ctrl/Alt+Função` (`kbShiftF1`, `kbCtrlF1`, `kbAltF1`, etc.).

Essas constantes simplificam a lógica de tratamento de entrada, permitindo que os desenvolvedores verifiquem facilmente qual tecla ou combinação de teclas foi pressionada em um evento de teclado.

### 2.3. Tipos Auxiliares para Códigos Alt

`TAltCodes1` e `TAltCodes2` são tipos string utilizados para mapear caracteres a códigos Alt específicos. Isso é fundamental para a função `GetAltCode`, que permite a conversão de um caractere para seu código Alt correspondente, facilitando a detecção de atalhos Alt+Letra e Alt+Número.

### 2.4. TCtrlBreakHandler

`TCtrlBreakHandler` define a assinatura de uma função que atua como manipulador para eventos de controle do sistema. Esta função deve retornar `Boolean`, indicando se o evento foi tratado pela aplicação (`True`) ou se deve ser propagado para o próximo manipulador (`False`).

```pascal
type
  TCtrlBreakHandler = function: Boolean;
```

**Exemplo de Implementação:**

```pascal
function MyCtrlHandler: Boolean;
begin
  // Lógica para tratar o evento de controle, por exemplo, salvar dados
  Result := True; // Indica que o evento foi tratado
end;
```

### 2.5. Constantes de Comando de Controle Global

Constantes como `Cm_CTRL`, `Cm_CTRL_BREAK_EVENT`, `Cm_CTRL_CLOSE_EVENT`, `Cm_CTRL_LOGOFF_EVENT`, e `Cm_CTRL_SHUTDOWN_EVENT` são usadas para identificar comandos de controle específicos, permitindo que a aplicação reaja a diferentes tipos de eventos de sistema de forma granular.

### 2.6. Tipos para Manipulação de Buffers de Tela

A unit define vários tipos relacionados à manipulação de buffers de tela e fontes, como `PScreen`, `TScreen`, `PDrawBuffer`, `TDrawBuffer`, `TScreenLinear`, `PScreenLinear`, `TScreenMirror`, `PScreenMirror`, `WordRec`, `TFontName`, e `TFontSize`. Estes tipos são a base para as operações de leitura, escrita e manipulação de conteúdo visual no console.

### 2.7. TMessageEvent e TCtrlHandler

`TMessageEvent` é um tipo de procedimento que define a assinatura para manipuladores de mensagens do console, permitindo que a classe `TFrameLCL` notifique a aplicação sobre eventos internos. `TCtrlHandler` é um tipo de função de objeto para manipulação de eventos de controle do sistema, similar a `TCtrlBreakHandler`, mas associado a uma instância de objeto.

### 2.8. TMiFPList

`TMiFPList` é uma classe derivada de `TFPList`, utilizada para o gerenciamento interno de listas específicas do `TFrameLCL`, provavelmente para manter referências a objetos ou recursos alocados dinamicamente.

### 2.9. Tipos de Cursores

Constantes como `crHidden`, `crUnderline`, `crHalfBlock`, e `crBlock` definem os diferentes estilos de cursor disponíveis para o console, permitindo que a aplicação altere a aparência do cursor conforme a necessidade. `TCursor` é o tipo enumerado correspondente a esses estilos.





## 3. Classe TFrameLCL

`TFrameLCL` é a classe central desta unit, projetada para fornecer uma abstração de alto nível para interagir com o console, permitindo a criação de interfaces gráficas ricas em aplicações de console. Ela encapsula a funcionalidade da unit `ConsoleGraphicVideo` e integra-se com o sistema de eventos da LCL.

### 3.1. Estrutura da Classe

```pascal
TFrameLCL = class(TFrame)
  FConsole: TConsoleGraphicVideo;
  // ... outras variáveis de instância e métodos ...
public
  class var MiFPList: TMiFPList;
  // ... construtores, destrutores, propriedades e métodos públicos ...
private
  FDragging: Boolean;
  FOnMessage: TMessageEvent;
  FCursorLines: SmallWord;
  FScreenMode: Word;
  // ... métodos privados para acesso a propriedades e manipulação interna ...
protected
  procedure TranslateLCLEventToTVEvent(const LCLKey: Word; const Shift: TShiftState; var TVEvent: TEvent); virtual;
  // ... outros métodos protegidos ...
end;
```

`TFrameLCL` herda de `TFrame`, o que a torna compatível com o framework LCL e permite que ela seja usada como um componente visual em ambientes de design-time, embora seu foco principal seja a manipulação de console. Ela mantém uma instância de `TConsoleGraphicVideo` (`FConsole`) para todas as operações de baixo nível com o console.

### 3.2. Construtor e Destrutor

*   **`constructor Create(AOwner: TComponent); override;`**
    O construtor de `TFrameLCL` inicializa a instância da classe, configurando o ambiente do console. Ele cria uma instância de `TConsoleGraphicVideo` e configura suas propriedades iniciais, como `Left`, `Top`, `Height`, `Width`, `Color`, `CursorX`, `CursorY`, `FontName`, `FontSize`, e `Align`. Também registra manipuladores de eventos de controle do console para garantir que a aplicação possa responder a eventos do sistema, como fechamento de janela.

*   **`destructor Destroy; override;`**
    O destrutor é responsável por liberar os recursos alocados pela instância de `TFrameLCL`. Isso inclui a desativação do manipulador de eventos de controle do console e a liberação da lista `MiFPList`, garantindo que não haja vazamentos de memória.

### 3.3. Propriedades

`TFrameLCL` expõe várias propriedades para controlar o estado e o comportamento do console e da interface gráfica:

*   **`Console: TConsoleGraphicVideo`** (somente leitura)
    Fornece acesso à instância subjacente de `TConsoleGraphicVideo`, permitindo operações diretas de baixo nível com o console, se necessário.

*   **`ScreenBuffer: Pointer`** (somente leitura)
    Retorna um ponteiro para o buffer de tela atual do console, que contém os caracteres e atributos exibidos na tela. Isso permite a manipulação direta do conteúdo da tela.

*   **`ScreenMirror: pointer`** (somente leitura)
    Retorna um ponteiro para o buffer espelho da tela, usado para otimizar a atualização da tela, exibindo apenas as diferenças entre o buffer principal e o espelho.

*   **`ConsoleTitle: AnsiString`** (leitura e escrita)
    Permite obter e definir o título da janela do console.

*   **`CursorLines: SmallWord`** (leitura e escrita)
    Controla as linhas do cursor, influenciando sua aparência.

*   **`OnMessage: TMessageEvent`** (leitura e escrita)
    Define um manipulador de eventos para mensagens internas da classe, permitindo que a aplicação reaja a eventos específicos gerados por `TFrameLCL`.

*   **`CursorX: Integer`** (leitura e escrita)
    Define ou obtém a posição X (coluna) do cursor no console.

*   **`CursorY: Integer`** (leitura e escrita)
    Define ou obtém a posição Y (linha) do cursor no console.

### 3.4. Métodos de Manipulação de Buffer e Tela

*   **`function GetScreenBuffer: Pointer;`**
    Retorna um ponteiro para o buffer de tela principal, onde o conteúdo visual é armazenado.

*   **`function GetScreenMirror: pointer;`**
    Retorna um ponteiro para o buffer espelho, usado para otimizações de renderização.

*   **`function GetBufferChar(X, Y: Integer): Char;`**
    Obtém o caractere na posição especificada (X, Y) do buffer de tela.

*   **`function GetBufferAttr(X, Y: Integer): Byte;`**
    Obtém o atributo (cor, estilo) do caractere na posição especificada (X, Y) do buffer de tela.

*   **`procedure MoveAnsiChar(var Dest; C: AnsiChar; Attr: Byte; Count: Word);`**
    Move um caractere ANSI para um destino específico no buffer, com um atributo e uma contagem de repetições.

*   **`procedure MoveBuf(var Dest; var Source; Attr: Byte; Count: Word); overload;`**
    Copia um buffer de origem para um buffer de destino, aplicando um atributo e limitando a contagem de caracteres.

*   **`procedure MoveBuf(Dest, Source: PScreen; Count: Word); overload;`**
    Copia o conteúdo de um buffer de tela (`PScreen`) para outro, com uma contagem específica.

*   **`procedure MoveCStr(var Dest; const Str: String; Attrs: SmallWord);`**
    Move uma string para um destino no buffer, interpretando caracteres especiais (como `~` para atalhos) e aplicando atributos.

*   **`procedure MoveStr(var Dest; const Str: String; Attr: Byte);`**
    Move uma string para um destino no buffer, aplicando um atributo uniforme a todos os caracteres.

*   **`procedure MoveAttr(var Dest: TDrawBuffer; const Inicio, Fin: Integer; Attr: Byte);`**
    Define um atributo específico para um intervalo de caracteres em um buffer de desenho (`TDrawBuffer`).

*   **`procedure WriteStr(X, Y: Integer; const S: string; Attr: Byte); overload;`**
    Escreve uma string na posição (X, Y) do console com um atributo especificado.

*   **`procedure WriteStr(X, Y: Integer; Str: String); overload;`**
    Escreve uma string na posição (X, Y) do console, usando os atributos padrão.

*   **`procedure WriteChar(X, Y: Integer; Ch: Char; Attr: Byte); overload;`**
    Escreve um caractere na posição (X, Y) do console com um atributo especificado.

*   **`procedure WriteChar(Ch: Char; Attr: Byte); overload;`**
    Escreve um caractere na posição atual do cursor com um atributo especificado.

*   **`procedure Print(Str: String);`**
    Imprime uma string na posição atual do cursor, sem adicionar uma nova linha.

*   **`procedure PrintLn(Str: String);`**
    Imprime uma string na posição atual do cursor e avança para a próxima linha.

*   **`procedure SetCurPos(X, Y: Integer);`**
    Define a posição do cursor no console para as coordenadas (X, Y).

*   **`procedure SetCursorType(NewType: TCursor);`**
    Define o tipo de cursor (oculto, sublinhado, meio-bloco, bloco).

*   **`procedure SetCurType(Y1, Y2: Integer; aShow: Boolean);`**
    Configura as propriedades visuais do cursor, incluindo sua altura e visibilidade.

*   **`function GetCursorPos: TPoint;`**
    Retorna a posição atual do cursor como um registro `TPoint` (X, Y).

*   **`procedure ShowBuffer(BufOfs, Len: Word); overload;`**
    Exibe uma porção do buffer de tela, otimizando a atualização ao verificar as diferenças entre o buffer principal e o espelho.

*   **`procedure ShowBuffer(BufOfs, Len: Word; SrcBuf: PScreen); overload;`**
    Exibe uma porção de um buffer de origem (`SrcBuf`) no console, com um deslocamento e comprimento especificados.

*   **`procedure ShowBuffer(const SrcBuf: PScreen); overload;`**
    Exibe o conteúdo completo de um buffer de origem (`SrcBuf`) no console.

*   **`procedure ClearScreen;`**
    Limpa todo o conteúdo da tela do console.

*   **`function GotoXY(X1, Y1: Integer): Integer;`**
    Move o cursor para a posição (X1, Y1) e retorna um valor indicando o sucesso da operação.

*   **`function CharWidth: Byte;`**
    Retorna a largura de um caractere em pixels.

*   **`function CharHeight: Byte;`**
    Retorna a altura de um caractere em pixels.

*   **`function ScreenWidth: Integer;`**
    Retorna a largura da tela do console em caracteres.

*   **`function ScreenHeight: Integer;`**
    Retorna a altura da tela do console em caracteres.

*   **`function GetMax_X: Integer;`**
    Retorna o número máximo de colunas na tela.

*   **`function GetMax_Y: Integer;`**
    Retorna o número máximo de linhas na tela.

*   **`function MinWinSize: TPoint;`**
    Retorna o tamanho mínimo da janela do console.

*   **`function MaxWinSize: TPoint;`**
    Retorna o tamanho máximo da janela do console.

### 3.5. Métodos de Configuração do Console

*   **`procedure SetVideoMode(Mode: Word); overload;`**
    Define o modo de vídeo do console usando um código de modo predefinido.

*   **`procedure SetVideoMode(aScreenWidth, aScreenHeight: Integer); overload;`**
    Define o modo de vídeo do console especificando a largura e altura da tela em caracteres.

*   **`function SetConsoleInfo(FonteBase: String; MaxCols: Integer): Integer; overload;`**
    Configura informações do console, como a fonte base e o número máximo de colunas.

*   **`function SetConsoleInfo(aFontName: TFontName; aFontSize: TFontSize; aCols: Integer = 80; aRows: Integer = 25): Integer; overload;`**
    Configura informações do console, incluindo nome da fonte, tamanho da fonte, número de colunas e linhas.

*   **`procedure DetectVideo;`**
    Detecta o modo de vídeo atual do console.

*   **`procedure HideMouse;`**
    Oculta o cursor do mouse no console.

*   **`procedure ShowMouse;`**
    Exibe o cursor do mouse no console.

*   **`procedure SetCrtData;`**
    Define dados internos relacionados ao CRT (Cathode Ray Tube), que afetam a exibição do console.

*   **`procedure SetConsoleCtrlHandle;`**
    Registra o manipulador de eventos de controle do console (`DoCtrlHandler`) para que a aplicação possa responder a eventos como Ctrl+C ou fechamento de janela.

*   **`procedure SysCtrlSleep(const Delay: Cardinal);`**
    Pausa a execução do programa por um determinado período, permitindo que o sistema processe outros eventos.

*   **`procedure NotifyCloseQuery;`**
    Notifica a aplicação sobre uma tentativa de fechamento da janela do console, chamando o manipulador de eventos de fechamento.

*   **`procedure SetConsoleDoHandlerEvent;`**
    Registra um manipulador de eventos genérico (`HandlerEvent`) para o console, que pode ser usado para processar diversos tipos de eventos.

### 3.6. Métodos de Manipulação de Eventos e Teclas

*   **`function GetShiftState: Byte;`**
    Retorna o estado atual das teclas modificadoras (Shift, Ctrl, Alt).

*   **`procedure GetMouseEvent(var Event: TEvent);`**
    Obtém um evento de mouse do console e o armazena na variável `Event`.

*   **`procedure GetKeyEvent(var Event: TEvent);`**
    Obtém um evento de teclado do console e o armazena na variável `Event`.

*   **`function GetAltAnsiChar(KeyCode: SmallWord): AnsiChar;`**
    Converte um código de tecla virtual em um caractere ANSI correspondente, especialmente para combinações Alt.

*   **`function GetCtrlAnsiChar(KeyCode: SmallWord): AnsiChar;`**
    Converte um código de tecla virtual em um caractere ANSI correspondente, especialmente para combinações Ctrl.

*   **`function GetAltCode(Ch: AnsiChar): SmallWord;`**
    Retorna o código Alt correspondente a um caractere ANSI, facilitando a detecção de atalhos.

*   **`function CtrlToArrow(KeyCode: SmallWord): SmallWord;`**
    Converte códigos de teclas Ctrl em códigos de teclas de seta, útil para navegação baseada em Ctrl.

*   **`function CStrLen(S: String): Integer;`**
    Calcula o comprimento de uma string, ignorando caracteres de controle específicos (como `~`).

*   **`class procedure FormatStr(var Result: AnsiString; Format: AnsiString; var Params); overload;`**
    Formata uma string com parâmetros, similar à função `printf` em C, permitindo a inserção de valores formatados.

*   **`class procedure FormatStr(var Result: AnsiString; Format: AnsiString); overload;`**
    Sobrecarga de `FormatStr` que formata uma string sem parâmetros adicionais.

*   **`class function UnicodeToCP850(Unicode: Word): AnsiChar;`**
    Converte um caractere Unicode para o conjunto de caracteres CP850 (Code Page 850), comum em ambientes de console.

*   **`procedure WndProc(var Message: TLMessage);`**
    Manipulador de mensagens da janela, que propaga mensagens para a instância de `TConsoleGraphicVideo` para processamento de eventos de baixo nível.

### 3.7. TViewComponent

`TViewComponent` é uma classe base simples, derivada de `TComponent`, que pode ser usada para componentes visuais genéricos. No contexto desta unit, ela serve como um exemplo ou um placeholder para futuras extensões de componentes que interagem com a `TFrameLCL`.

*   **`constructor Create(AOwner: TComponent);`**
    Construtor padrão para `TViewComponent`.

*   **`procedure DoAfterCreate;`**
    Método chamado após a criação do componente, permitindo inicializações adicionais.

*   **`function GetCurrentField(FieldNum: Longint): Pointer;`**
    Um método placeholder que pode ser usado para obter um ponteiro para um campo específico, dependendo da implementação.





## 4. Exemplos de Uso Avançados

### 4.1. Exemplo de Manipulação de Eventos de Teclado e Mouse

Este exemplo demonstra como capturar e processar eventos de teclado e mouse usando a classe `TFrameLCL`. Ele cria uma janela de console simples que exibe as coordenadas do mouse e as teclas pressionadas.

```pascal
program ConsoleApp;

uses
  SysUtils, Classes, FrameLCL_u, Windows;

var
  Frame: TFrameLCL;
  Running: Boolean;

procedure HandleKeyEvent(Sender: TObject; Event: TEvent);
begin
  if Event.What = evKeyDown then
  begin
    Frame.WriteStr(1, 1, Format(
      'Key Pressed: VK=%d, Char=\'%s\', ShiftState=%d', [
      Event.KeyCode, AnsiChar(Event.KeyCode), Event.ShiftState
    ]), $0F);
    if Event.KeyCode = VK_ESCAPE then
      Running := False;
  end;
end;

procedure HandleMouseEvent(Sender: TObject; Event: TEvent);
begin
  if Event.What = evMouseDown then
  begin
    Frame.WriteStr(1, 2, Format(
      'Mouse Click: X=%d, Y=%d, Button=%d', [
      Event.Mouse.Where.X, Event.Mouse.Where.Y, Event.Mouse.Buttons
    ]), $0F);
  end;
end;

begin
  Frame := TFrameLCL.Create(nil);
  try
    Frame.SetVideoMode(80, 25); // Define o modo de vídeo para 80 colunas e 25 linhas
    Frame.ConsoleTitle := 'Exemplo de Eventos de Console';
    Frame.ClearScreen;

    Frame.WriteStr(1, 0, 'Pressione ESC para sair.', $0F);

    // Atribui os manipuladores de eventos
    Frame.Console.SetKeyEventHandler(HandleKeyEvent, True);
    Frame.Console.SetMouseEventHandler(HandleMouseEvent, True);

    Running := True;
    while Running do
    begin
      // Loop principal da aplicação
      // TFrameLCL.Console.ProcessEvents; // Processa eventos (já feito internamente pelo SetHandlerEvent)
      Sleep(10); // Pequena pausa para evitar consumo excessivo de CPU
    end;

  finally
    Frame.Free;
  end;
end.
```

### 4.2. Exemplo de Manipulação de Buffer de Tela e Atributos

Este exemplo demonstra como manipular diretamente o buffer de tela para desenhar formas e texto com diferentes atributos (cores).

```pascal
program ConsoleGraphics;

uses
  SysUtils, Classes, FrameLCL_u, Windows, ConsoleGraphicVideo;

var
  Frame: TFrameLCL;
  ScreenBuf: PScreen;
  X, Y: Integer;

begin
  Frame := TFrameLCL.Create(nil);
  try
    Frame.SetVideoMode(80, 25);
    Frame.ConsoleTitle := 'Exemplo de Gráficos no Console';
    Frame.ClearScreen;

    ScreenBuf := Frame.GetScreenBuffer;

    // Desenha um retângulo com fundo azul e texto branco
    for Y := 5 to 10 do
    begin
      for X := 10 to 70 do
      begin
        ScreenBuf^[Y * Frame.ScreenWidth + X].Ch := ' ';
        ScreenBuf^[Y * Frame.ScreenWidth + X].Attr := $1F; // Fundo azul, texto branco
      end;
    end;

    Frame.WriteStr(25, 7, 'Olá, Mundo!', $1E); // Fundo azul, texto amarelo

    // Desenha uma linha diagonal com fundo vermelho e texto verde
    for X := 0 to 19 do
    begin
      ScreenBuf^[(15 + X) * Frame.ScreenWidth + (10 + X)].Ch := '#';
      ScreenBuf^[(15 + X) * Frame.ScreenWidth + (10 + X)].Attr := $4A; // Fundo vermelho, texto verde
    end;

    Frame.ShowBuffer(ScreenBuf); // Exibe o buffer atualizado

    Frame.WriteStr(1, 24, 'Pressione qualquer tecla para sair.', $0F);
    ReadLn;

  finally
    Frame.Free;
  end;
end.
```


