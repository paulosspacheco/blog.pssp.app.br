# Documentação do Projeto ConsoleGraphic

## Visão Geral do Projeto
O projeto **ConsoleGraphic** é uma implementação de um console gráfico multiplataforma baseado no framework Turbo Vision, integrado ao Lazarus Component Library (LCL/Free Pascal). Ele simula um console texto em modo gráfico, suportando buffer de vídeo, cursor piscante, eventos de teclado/mouse, seleção de texto, clipboard (copiar/colar), e rolagem. O foco é compatibilidade com Turbo Vision (ex.: `TEvent`, `TSysKeyEvent`), com conversões CP850/UTF8 para caracteres ASCII/Unicode.

**Objetivo**: Emular console DOS-like em apps LCL, para apps Turbo Vision em GUI moderna.

**Versão Geral**: 0.0.22.0 (Alpha/Funcional, com suporte a hooks para teclado/mouse).

**Problema em Debug**: Perda de foco após ativação de menu (F10) ou comandos, fazendo teclado (setas) falhar até clique do mouse re-ativar `DoEnter` e hook.

**Arquitetura**: Herança linear: Types → Abstract → Buffer → Cursor → KeyEvent → Mouse → ScreenCapture → Video (final LCL integration). Hooks (Keyboard/Mouse) são opcionais (desabilitados por padrão).

Abaixo, descrição detalhada de cada unit fornecida, com features chave, dependências, e relação com o problema de foco/teclado.

## Units Principais

### 1. ConsoleGraphicTypes.pas
**Descrição**: Define tipos, constantes e estruturas base para o projeto (cores RGB, eventos CTRL_*, buffers TScreen, manipuladores TCtrlBreakHandler).  
**Features Chave**:  
- Paletas de 16 cores (DOS, VS Code, WhatsApp, etc.) com `TPalette`.  
- Constantes VK_* (LCL) e kb* (Turbo Vision) para mapeamento.  
- Estruturas: `WordRec` (char+attr), `TSysKeyEvent`, `TPartialRectangle` (para frames).  
- Funções: `UTF8ToCP850`, `MixColors` para encoding/cores.  
**Dependências**: Classes, SysUtils, Graphics, LCLType.  
**Relação com Problema**: Fornece constantes kbF10/kbLeft para mapeamento em `GetKeyEvent`. Sem foco, mapeamento falha (KeyCode inválido).

### 2. ConsoleGraphicAbstract.pas
**Descrição**: Classe abstrata base (`TConsoleGraphicAbstract`) para console gráfico, definindo métodos virtuais para buffer, cursor, eventos, e painting.  
**Features Chave**:  
- Métodos abstratos: `GetCharAt`, `WriteChar`, `SysGotoXY`, `SysTVGetKeyEvent`, `SysTVDetectMouse`.  
- Funções auxiliares: `DrawCellRect`, `MixColors`, `UnicodeToCP850`.  
- Propriedades: `MinSize/MaxSize`, `TextAttr`.  
**Dependências**: ConsoleGraphicTypes, Controls, Graphics.  
**Relação com Problema**: Define `GetKeyEvent` abstrato — implementações dependem de foco LCL. Sem foco, eventos não chegam.

### 3. ConsoleGraphicBuffer.pas
**Descrição**: Gerencia buffer de vídeo (`TConsoleGraphicBuffer`), alocando `FBuffer/FOldBuffer`, redimensionamento (`UpdateDimensions`), e escrita (`WriteStr`).  
**Features Chave**:  
- Alocação dinâmica (`AllocateBuffers`), comparação para repaint parcial (`UpdateConsoleScreen`).  
- Redimensionamento (`Resize`, `AdjustFontToFit` para fonte auto-ajuste).  
- Roteamento (`SysTVShowBuf` com blocos de atributo).  
**Dependências**: ConsoleGraphicAbstract, LCLIntf.  
**Relação com Problema**: Buffer é atualizado em `UpdateConsoleScreen`, mas sem foco, eventos de teclado não escrevem nele (`WriteChar` falha em posições inválidas).

### 4. ConsoleGraphicCursor.pas
**Descrição**: Gerencia cursor piscante (`TConsoleGraphicCursor`), com posicionamento (`SysGotoXY`), tipos (`crUnderline`), e timer implícito.  
**Features Chave**:  
- Piscagem (`ShouldDrawCursor` via `GetSystemTickCount`).  
- Validação de limites (`SetCursorX/Y` clamp a Cols/Rows).  
- Tipos: crHidden, crUnderline, crHalfBlock, crBlock.  
**Dependências**: ConsoleGraphicBuffer.  
**Relação com Problema**: Cursor pisca em `DoEnter` (ativa timer/foco), mas sem foco, não pisca após F10 — visual confirma perda de foco.

### 5. ConsoleGraphicKeyEvent.Consts.pas
**Descrição**: Constantes para eventos de teclado (`TConsoleGraphicKeyEventConsts`), mapeando VK_* (LCL) para kb* (TV) e máscaras kbShift.  
**Features Chave**:  
- Constantes kbF10, kbLeft, kbCtrlC, etc.  
- Tabelas AltCodes para Alt+letra/número.  
- KeyTranslateTable para combinações (ex.: Ctrl+Ins = kbCtrlIns).  
**Dependências**: ConsoleGraphicCursor, LCLType.  
**Relação com Problema**: kbF10 = $4400 usado em `GetKeyEvent` — sem foco, LCL não envia VK_F10, mapeamento falha.

### 6. ConsoleGraphicKeyEvent.pas
**Descrição**: Implementa processamento de teclado (`TConsoleGraphicKeyEvent`), com fila `FKeyEvents`, conversão LCL→TV (`LCLKeyToTurboVision`), e handlers (`DoKeyHandler`).  
**Features Chave**:  
- `KeyDown`/`UTF8KeyPress` adicionam a fila se hook off.  
- `ProcessKeyEvent` processa fila, movendo cursor/rolando tela.  
- `GetKeyEvent` preenche `TEvent` de buffer/hook, filtrando repetições.  
- Hook opcional (`fEnableKeyBordHook = False` por padrão).  
**Dependências**: ConsoleGraphicKeyEvent.Consts, KeyboardEventBuffer*, KeyboardHookManager*.  
**Relação com Problema**: Hook off faz depender de LCL KeyDown (falha sem foco). `DoEnter` re-anexa hook, mas F10 não chama DoEnter — mouse sim.

### 7. KeyboardEventBuffer.pas
**Descrição**: Buffer circular thread-safe (`TKeyboardEventBuffer`) para eventos ketDown (teclas pressionadas), ignorando ketUp.  
**Features Chave**:  
- Push/Pop/Peek com `TCriticalSection`.  
- Grow automático se cheio.  
**Dependências**: SyncObjs.  
**Relação com Problema**: Buffer armazena eventos do hook — se hook não captura (sem foco), buffer vazio, `GetKeyEvent` falha.

### 8. KeyboardEventBufferHookHelper.pas
**Descrição**: Helper (`TKeyboardHookHelper`) para substituir WindowProc e rotear LM_KEY* para gerenciador.  
**Features Chave**:  
- `HookWindowProc` intercepta LM_KEYFIRST..LM_KEYLAST.  
- Singleton `TKeyboardHookManager` gerencia helpers e buffer.  
- Filtragem em `AddToBuffer` (ignora repetições, modificadores puros).  
**Dependências**: KeyboardEventBuffer.  
**Relação com Problema**: Hook anexado em `CreateWnd` se ativado, mas desanexado em `DestroyWnd`. Sem foco, mensagens não chegam ao WindowProc.

### 9. KeyboardHookManagerCp850_u.pas
**Descrição**: Gerenciador singleton (`TKeyboardHookManagerCp850`) com conversão Unicode→CP850 para Turbo Vision.  
**Features Chave**:  
- `ConvertToCP850` converte CharCode para CP850.  
- Singleton garante uma instância.  
**Dependências**: KeyboardEventBufferHookHelper, ConsoleGraphicAbstract.  
**Relação com Problema**: Conversão em `ConvertEvent` — sem eventos (foco perdido), conversão não ocorre.

### 10. KeyboardHookManagerCp850Tv_u.pas
**Descrição**: Especializado para TV (`TKeyboardHookManagerCp850Tv`), com mapeamento LCL→TV (`LCLKeyToTV`) e tradução (`TranslateKeyEvent`).  
**Features Chave**:  
- `GetNextEvent` pop do buffer e traduz para `TEvent`.  
- `LCLKeyToTV` mapeia VK_F10→kbF10, com Shift/Ctrl/Alt.  
**Dependências**: KeyboardHookManagerCp850_u, ConsoleGraphicKeyEvent.Consts.  
**Relação com Problema**: `GetKeyEvent` usa isso — sem buffer cheio (foco perdido), retorna evNothing.

### 11. MouseEventBuffer.pas
**Descrição**: Buffer circular (`TMouseEventBuffer`) para eventos metDown/Up/Move/Wheel, com detecção double-click por tempo/distância.  
**Features Chave**:  
- Push com double-click check.  
- Grow automático.  
**Dependências**: SyncObjs.  
**Relação com Problema**: Paralelo a keyboard buffer — mouse ativa foco em `MouseDown`, "consertando" teclado.

### 12. MouseEventBufferHookHelper.pas
**Descrição**: Helper (`TMouseHookHelper`) para WindowProc hook de LM_MOUSE*.  
**Features Chave**:  
- `HookWindowProc` roteia para gerenciador.  
- Singleton `TMouseHookManager` gerencia buffer.  
**Dependências**: MouseEventBuffer.  
**Relação com Problema**: Hook anexado em `CreateWnd` se ativado, mas desabilitado por padrão.

### 13. MouseEventBufferHookHelperEx.pas
**Descrição**: Estendido (`TMouseHookManagerEx`) com char position (`GetCharPosition`) e filtragem moves (só se posição mudou).  
**Features Chave**:  
- `HandleMouseEvent` filtra LM_MOUSE* e adiciona a buffer.  
- `FLastMouseMoveCharPos` evita spam de moves.  
**Dependências**: MouseEventBufferHookHelper.  
**Relação com Problema**: Filtragem otimiza, mas mouse events ativam `SetFocus` em `MouseDown`, despertando teclado.

### 14. ConsoleGraphicScreenCapture.pas
**Descrição**: Suporte a seleção/copiar/colar (`TConsoleGraphicScreenCapture`), com menu popup.  
**Features Chave**:  
- Seleção com mouse (`MouseDown/Move/Up` para FSel*).  
- `CopyToClipboard` constrói string do buffer, converte UTF8/CP850.  
**Dependências**: ConsoleGraphicMouse, Clipbrd.  
**Relação com Problema**: `MouseDown` herda `SetFocus`, ativando foco/teclado.

### 15. ConsoleGraphicMouse.pas
**Descrição**: Gerencia eventos de mouse (`TConsoleGraphicMouse`), com buffer `FMouseEvents` e simulação (`SimulateMouseDown`).  
**Features Chave**:  
- `GetMouseEvent` desinfileira e converte para `TEvent` (evMouseDown/Move).  
- Hook opcional (`EnableMouseHook = false`).  
- `MouseDown` chama `SetFocus`.  
**Dependências**: ConsoleGraphicKeyEvent, MouseEventBuffer*.  
**Relação com Problema**: `SetFocus` em `MouseDown` "conserta" teclado. F10 não chama isso.

### 16. ConsoleGraphicVideo.pas
**Descrição**: Classe final (`TConsoleGraphicVideo`), integra tudo com LCL painting (`Paint`), timer cursor (`TimerHandler`), e hooks (`CreateWnd`).  
**Features Chave**:  
- `Paint` renderiza buffer centralizado, com cursor.  
- `DoEnter` re-anexa hook de teclado, ativa timer.  
- `Select` chama `SetFocus` se TabStop/CanFocus.  
**Dependências**: Todas as anteriores + ExtCtrls, Clipbrd.  
**Relação com Problema**: `DoEnter` re-anexa hook, mas só chamado por mouse/foco LCL. F10 ativa menu sem DoEnter, perdendo hook.

## Arquitetura Geral
- **Herança**: Types → Abstract → Buffer → Cursor → KeyEvent → Mouse → ScreenCapture → Video.
- **Hooks**: Opcionais (desabilitados por padrão) — teclado/mouse anexados em `CreateWnd` se ativados, re-anexados em `DoEnter`.
- **Problema Central**: Hooks desabilitados + falta de `SetFocus` em ativação de menu (F10) = perda de captura de teclado até mouse.
- **Solução Recomendada**: Ativar hooks no construtor, adicionar `SetFocus` em TvMenus.HandleEvent para cmMenu, e `ProcessMessages` após comandos.

**Próximo Passo**: Teste as sugestões acima. Se precisar de mais units ou log, envie! O projeto é robusto para console gráfico.