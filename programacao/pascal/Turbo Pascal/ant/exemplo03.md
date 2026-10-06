Com certeza! O segundo passo no tutorial do Turbo Vision, documentado na seção "Step 2: Customizing menus and status lines", concentra-se em **personalizar os elementos visuais principais da sua aplicação: a linha de status e a barra de menu**. Ele é apresentado em várias iterações (TUTOR02A.PAS, TUTOR02B.PAS, TUTOR02C.PAS) para ilustrar as diferentes personalizações.

O objetivo geral é demonstrar como o Turbo Vision permite que você defina a interface do usuário e como esses elementos da interface geram comandos que sua aplicação pode então responder.

Para este passo, o guia utiliza o programa **`TUTOR02.PAS`** (e suas variações) para ilustrar essas personalizações.

---

### **Programa: TUTOR02A.PAS - Personalizando a Linha de Status**

O `TUTOR02A.PAS` (Listing 1.5) mostra como redefinir a linha de status para exibir diferentes teclas de atalho (hot keys) e informações dependendo do contexto de ajuda da aplicação.

Aqui está o código principal e a explicação:

  ```pascal
    program Tutor02a;
    uses App, Objects, Menus, Drivers, Views, TutConst;

    type TTutorApp = object (TApplication)
      procedure InitStatusLine; virtual; // declara o novo método
    end;

    procedure TTutorApp.InitStatusLine;
    var R: TRect;
    begin
      GetExtent (R) ;           // Obtém os limites da aplicação
      R.A.Y := R.B.Y - 1;      // Define o topo para uma linha acima da base (a última linha da tela)
      New(StatusLine, Init(R, // Constrói a linha de status com os limites R e as definições de status:
        NewStatusDef(0, $EFFF, // Primeira definição para contextos de ajuda de 0 a $EFFF ("normal")
          NewStatusKey('-F3- Open', kbF3, cmOpen,              // Vincula F3 ao comando cmOpen
          NewStatusKey('-F4- New', kbF4, cmNew,                // Vincula F4 ao comando cmNew
          NewStatusKey('-Alt+F3- Close', kbAltF3, cmClose,     // Vincula Alt+F3 ao comando cmClose
          StdStatusKeys(nil)))),                              // Adiciona as teclas de status padrão (Alt+X, F10, etc.)
        NewStatusDef($F000, $FFFF, // Segunda definição para contextos de ajuda de $F000 a $FFFF
          NewStatusKey('-F6- Next', kbF6, cmOrderNext,         // Vincula F6 ao comando cmOrderNext
          NewStatusKey('-Shift+F6- Prev', kbShiftF6, cmOrderPrev, // Vincula Shift+F6 ao comando cmOrderPrev
          StdStatusKeys(nil))), nil)))); // Adiciona as teclas de status padrão para este range e encerra as definições
    end;

    var TutorApp: TTutorApp;

    begin
      TutorApp.Init ;
      TutorApp.Run;
      TutorApp.Done;
    end.
  ```

*   **`uses App, Objects, Menus, Drivers, Views, TutConst;`**: Além de `App`, várias outras unidades são incluídas, como `Menus` (para definições de status), `Drivers` (para códigos de teclado como `kbF3`, `kbAltF3`), `Views` e `Objects`. A unidade **`TutConst`** (Listing 1.3) é uma unidade separada que define constantes de comando (como `cmOpen`, `cmNew`, `cmClose`) em um local central, promovendo flexibilidade e extensibilidade.
*   **`type TTutorApp = object(TApplication) procedure InitStatusLine; virtual; end;`**: A aplicação `TTutorApp` (derivada de `TApplication`, como visto em `TUTOR01.PAS`) **sobrescreve o método virtual `InitStatusLine`** para personalizar a linha de status.
*   **`GetExtent(R); R.A.Y := R.B.Y - 1;`**: Estas linhas obtêm as dimensões da área da aplicação e definem a variável `R` para representar a última linha da tela, onde a linha de status será exibida.
*   **`New(StatusLine, Init(R, ...))`**: Cria e inicializa o objeto `StatusLine`.
*   **`NewStatusDef(0, $EFFF, ...)` e `NewStatusDef($F000, $FFFF, ...)`**: São criadas **duas definições de status**. Cada `TStatusDef` cobre uma faixa de contextos de ajuda (HelpCtx). Isso permite que a linha de status mude dinamicamente as teclas exibidas com base no que o usuário está vendo na tela. Por exemplo, `$F000` e valores mais altos são usados para janelas de entrada de dados personalizadas no tutorial.
*   **`NewStatusKey(...)`**: Esta função define uma nova chave de status na linha de status, ligando um texto (como '-F3- Open'), um código de teclado (`kbF3`) e um comando (`cmOpen`).
*   **`StdStatusKeys(nil)`**: Inclui um conjunto padrão de teclas de atalho (Alt+X para sair, F10 para menu, etc.) sem que você precise defini-las individualmente.

**Resultado:** Ao executar este programa, a linha de status exibirá as novas teclas de atalho definidas. O item "Alt+F3 Close" não estará destacado (habilitado) por padrão, pois o comando `cmClose` está desabilitado até que haja algo para fechar.

---

### **Programa: TUTOR02B.PAS - Construindo uma Barra de Menu Simples**

O `TUTOR02B.PAS` (Listing 1.6) ilustra a construção de uma barra de menu básica.

Aqui está o código principal:

  ```pascal
    procedure TTutorApp.InitMenuBar;
    var R: TRect;
    begin
      GetExtent(R);                // Obtém os limites da aplicação
      R.B.Y := R.A.Y + 1;          // Define a altura da barra de menu (uma linha no topo)
      MenuBar := New (PMenuBar, Init(R, NewMenu( // Cria a barra de menu com os limites R e um novo menu:
        NewItem('-N-ew', "", kbNoKey, cmNew, hcNew,                                // Item 'New'
        NewItem('-O-pen...', 'F3', kbF3, cmOpen, hcOpen,                           // Item 'Open'
        NewItem('-S-ave', 'F2', kbF2, cmSave, hcSave,                              // Item 'Save'
        NewItem('Sav;e -a-s...', "", kbNoKey, cmSaveAs, hcSaveAs,                  // Item 'Save As'
        NewLine (                                                                 // Adiciona uma linha divisória
        NewItem('E-x-it', 'Alt+X', kbAltX, cmQuit, hcExit, nil))))))))) ;          // Item 'Exit'
    end;
  ```

*   **`procedure TTutorApp.InitMenuBar;`**: A aplicação sobrescreve o método virtual `InitMenuBar` para criar sua barra de menu.
*   **`GetExtent(R); R.B.Y := R.A.Y + 1;`**: Define a variável `R` para representar a primeira linha da tela, onde a barra de menu será exibida.
*   **`MenuBar := New(PMenuBar, Init(R, NewMenu(...)))`**: Cria e inicializa o objeto `MenuBar`, que é uma `TMenuBar`. O `NewMenu` cria a lista de itens do menu.
*   **`NewItem(...)`**: Cada `NewItem` define um item individual no menu. Cada item possui seis partes:
    1.  **Texto do rótulo**: A string exibida (ex: `'-N-ew'`). O til (`~`) indica uma tecla de atalho.
    2.  **Rótulo da hot key**: Texto para a hot key (ex: `'F3'`).
    3.  **Scan code da hot key**: O código de teclado (ex: `kbF3`).
    4.  **Comando**: O comando inteiro associado (ex: `cmNew`).
    5.  **Contexto de ajuda**: Um número de contexto de ajuda (ex: `hcNew`).
    6.  **Ponteiro para o próximo item**: `nil` se for o último item, ou outro `NewItem`.
*   **`NewLine`**: Insere uma linha divisória no menu para agrupar itens.

**Resultado:** Uma barra de menu simples aparece no topo da tela com as opções "New", "Open...", "Save", "Save As..." e "Exit".

---

### **Programa: TUTOR02C.PAS - Definindo um Menu Complexo**

O `TUTOR02C.PAS` (Listing 1.8) expande a barra de menu para incluir submenus e utiliza funções auxiliares para simplificar a declaração de menus complexos.

Aqui está um trecho do código para ilustrar o uso de funções padrão:

```pascal
procedure TTutorApp.InitMenuBar;
var R: TRect;
begin
  GetExtent (R) ;
  R.B.Y := R.A.Y + 1;
  MenuBar := New (PMenuBar, Init(R, NewMenu(
    NewSubMenu ( '-F-ile', hcNoContext, NewMenu (
      StdFileMenuItems(nil)) ), // Utiliza função padrão para o menu 'File'
    NewSubMenu('-E-dit', hcNoContext, NewMenu(
      StdEditMenuItems( NewLine ( NewItem('-S-how clipboard',
        hcNoContext, kbNoKey, cmClipShow, nil))))), // Utiliza função padrão e adiciona um item customizado
    NewSubMenu('-O-rders', hcNoContext, NewMenu(
      NewItem ( '-N-ew', 'F9', kbF9, cmOrderNew, hcNoContext,
      NewItem('-S-ave', "", kbNoKey, cmOrderSave, hcNoContext,
      NewLine (
      NewItem('Next', 'PgDn', kbPgDn, cmOrderNext, hcNoContext,
      NewItem('Prev', 'PgUp', kbPgUp, cmOrderPrev, hcNoContext, nil))))))),
    NewSubMenu('O-p-tions', hcNoContext, NewMenu(
      NewItem('-T-oggle video', kbNoKey, cmOptionsVideo, hcNoContext,
      NewItem('-S-ave desktop', hcNoContext, kbNoKey, cmOptionsSave,
      NewItem('-L-oad desktop', hcNoContext, kbNoKey, cmOptionsLoad,
      nil)))) ),
    NewSubMenu('-W-indow', hcNoContext, NewMenu(
      NewItem('Orders', "", kbNoKey, cmOrderWin, hcNoContext,
      NewItem('Stock items', "", kbNoKey, cmStockWin, hcNoContext,
      NewItem('Suppliers', "", kbNoKey, cmSupplierWin, hcNoContext,
      NewLine ( StdWindowMenuItems(nil)))))), // Utiliza função padrão para o menu 'Window'
    NewSubMenu('-H-elp', hcNoContext, NewMenu(
      NewItem('-A-bout...', "", kbNoKey, cmAbout, hcNoContext, nil) ), nil)))))))));
end;
```

*   **`NewSubMenu(...)`**: Esta função cria um submenu, recebendo um rótulo de texto (ex: `'-F-ile'`), um contexto de ajuda, e um ponteiro para outro `TMenu` que representa os itens dentro desse submenu.
*   **Funções de Menu Padrão**: Em vez de definir cada item manualmente, o Turbo Vision fornece funções como **`StdFileMenuItems`**, **`StdEditMenuItems`** e **`StdWindowMenuItems`**. Essas funções retornam listas de `PMenuItem` para menus comuns, simplificando a declaração de menus complexos.
*   **Submenus Customizados**: Além dos menus padrão, são adicionados submenus customizados como "Orders" e "Options", que contêm seus próprios itens e comandos. Por exemplo, `cmClipShow` para mostrar a janela da área de transferência e `cmOptionsVideo` para alternar o modo de vídeo.

**Resultado:** Uma aplicação com uma barra de menu rica, incluindo submenus "File", "Edit", "Orders", "Options", "Window" e "Help", onde cada um pode ter seus próprios itens e hot keys.

---

### **Principais Conclusões do "Segundo Exemplo" (`TUTOR02.PAS` e suas variações)**

*   **Personalização da Interface do Usuário**: Demonstra como personalizar os elementos essenciais da interface gráfica (barra de menu e linha de status) para se adequarem às necessidades da sua aplicação.
*   **Extensibilidade e Programação Orientada a Objetos**: Através da sobrescrita de métodos virtuais como `InitStatusLine` e `InitMenuBar`, o Turbo Vision promove a extensão da funcionalidade padrão sem modificar o código-fonte original do *framework*. Isso garante uma base sólida e reutilizável.
*   **Contexto-sensibilidade**: A linha de status pode exibir informações diferentes dependendo do "contexto de ajuda" atual da aplicação (`HelpCtx`), permitindo *feedback* dinâmico ao usuário.
*   **Definição de Comandos**: O exemplo solidifica o conceito de comandos como constantes inteiras (`cmNew`, `cmOpen`, etc.) que são vinculadas a itens de menu e teclas de atalho. Isso estabelece a base para o modelo de programação orientada a eventos, onde a aplicação responde a esses comandos, independentemente de como foram gerados.
*   **Separação da Lógica da UI**: Uma das vantagens mais importantes é que você define como os comandos são gerados (através de menus ou teclas de atalho) separadamente de como a aplicação responde a esses comandos. Isso torna o código mais flexível e fácil de manter.
*   **Reutilização de Código**: O uso de funções padrão como `StdStatusKeys` e `StdFileMenuItems` ilustra a reutilização de componentes de interface comuns, reduzindo a duplicação de código e o esforço de desenvolvimento.