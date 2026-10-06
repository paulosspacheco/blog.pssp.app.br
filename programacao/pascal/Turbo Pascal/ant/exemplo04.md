Com certeza! O "Exemplo 04 do manual" refere-se à seção "Chapter 3 ·Adding windows" do *Guia de Programação do Turbo Vision*, que aborda os "Step 4: Adding a window" e "Step 5: Adding a clipboard window" do tutorial.

Nesta seção, você aprende a adicionar e gerenciar janelas na sua aplicação Turbo Vision. O processo envolve a interação com o objeto `Desktop`, que é fundamental para organizar as janelas na tela.

Aqui estão os principais pontos e passos para "Adicionar Janelas", conforme o manual:

### **Passo 4: Adicionando uma Janela**

1.  **Visão Geral**:
    *   Um dos grandes benefícios do Turbo Vision é a facilidade de criar e gerenciar janelas múltiplas, redimensionáveis e sobrepostas.
    *   O objeto `Desktop` é a chave para gerenciar janelas, rastreando-as e lidando com operações como cascata e mosaico.

2.  **Três Passos para Adicionar uma Janela**:
    *   **Atribuir os Limites da Janela**: Define a posição e o tamanho retangular da janela. Isso é feito usando o método `Assign` em uma variável do tipo `TRect` para definir coordenadas absolutas, por exemplo, `R.Assign(0, 0, 60, 20)`.
    *   **Construir o Objeto da Janela**: Cria uma instância dinâmica do tipo de objeto de janela desejado. Para uma janela genérica, usa-se `New(PWindow, Init(R, 'Um título', wnNoNumber))`. O construtor `Init` requer os limites (`R`), uma *string* para o título e um número para a janela (`wnNoNumber` indica que não há número). Se um número entre 1 e 9 for atribuído, o usuário pode ativar a janela pressionando Alt + o número correspondente.
    *   **Inserir a Janela no Desktop**: O método `Insert` é comum a todos os grupos do Turbo Vision e dá ao grupo controle sobre seus objetos. Ao inserir uma janela no `Desktop`, você instrui o `Desktop` a gerenciá-la. O método `InsertWindow` do objeto `Application` é uma maneira mais segura de fazer isso, pois verifica a validade da janela antes de inseri-la.

3.  **Mosaico (Tiling) e Cascata (Cascading)**:
    *   O `Desktop` tem a capacidade de organizar janelas em mosaico ou cascata. O manipulador de eventos padrão em `TApplication` responde aos comandos `cmTile` e `cmCascade` (do menu Janela) chamando os métodos `Tile` e `Cascade` do `TApplication`.

4.  **Adicionando uma Janela Editora (File Editor Window)**:
    *   **Buffers do Editor de Arquivos**: Se sua aplicação usar editores de arquivos (incluindo a área de transferência), você precisa inicializar a variável global `MaxHeapSize` (do módulo `Memory`) *antes* de construir o objeto `Application`. Isso reserva uma parte da memória (acima do *heap* regular) para os buffers do editor de arquivos.
    *   **Caixas de Diálogo do Editor**: A variável procedural `EditorDialog` (do módulo `Editors`) lida com todas as caixas de diálogo para objetos editor. Por padrão, ela não faz nada. Você deve atribuir a função `StdEditorDialog` a ela para usar as caixas de diálogo padrão do editor (por exemplo, `EditorDialog := StdEditorDialog;`).
    *   **Construindo a Janela Editora**: Você constrói uma instância de `PEditWindow` (em vez de `PWindow`). O construtor é similar, mas passar uma *string* de título vazia resultará em "Untitled" para a janela.

5.  **Usando Caixas de Diálogo Padrão (Standard Dialog Boxes)**:
    *   Para editar arquivos existentes, é melhor usar uma caixa de diálogo que mostre os arquivos disponíveis. O módulo `StdDlgs` do Turbo Vision fornece o objeto `TFileDialog` para isso.
    *   **Caixas de Diálogo Modais**: O método `ExecuteDialog` (do objeto `Application`) não apenas insere a caixa de diálogo no `Desktop`, mas também a torna *modal*. Isso significa que a caixa de diálogo é a única parte ativa da aplicação até ser fechada.
    *   **Construindo uma `TFileDialog`**: O construtor da `TFileDialog` aceita cinco parâmetros: uma máscara inicial de nome de arquivo (ex: `*.*`), um título, um rótulo para a linha de entrada, *flags* de opção (ex: `fdOKButton`, `fdOpenButton`) e o número de uma lista de histórico.
    *   **Executando a `TFileDialog`**: `ExecuteDialog` retorna o valor do comando que fechou a caixa (ex: `cmOK`, `cmCancel`), permitindo que seu programa saiba se o usuário aceitou ou cancelou a ação. Ele também pode inicializar os controles da caixa de diálogo com um registro de dados e ler os valores dos controles após a execução.
    *   **Construindo a Janela Editora de Arquivos**: Se a caixa de diálogo de arquivo não for cancelada, você usa o nome do arquivo selecionado para construir uma `PEditWindow`.

### **Passo 5: Adicionando uma Janela da Área de Transferência (Clipboard Window)**

1.  **O que é o Clipboard**: A área de transferência é um objeto editor que está sempre presente na aplicação e permite recortar, copiar e colar texto entre janelas.
2.  **Construindo a Janela da Área de Transferência**:
    *   Cria-se uma `PEditWindow` da mesma forma que uma janela editora de arquivos, mas ela é inicialmente **oculta** usando o método `Hide`.
    *   A variável global `Clipboard` (do módulo `Editors`) deve ser definida para apontar para o editor dentro da janela da área de transferência (`Clipboard := ClipboardWindowA.Editor;`).
    *   A capacidade de "desfazer" (`CanUndo`) da área de transferência deve ser desabilitada (`ClipboardA.CanUndo := False`), pois ela não suporta essa funcionalidade.
3.  **Exibindo a Janela da Área de Transferência**:
    *   Em resposta ao comando `cmClipShow` (gerado pelo item "Show clipboard" do menu Editar), a janela da área de transferência é exibida usando `ClipboardWindowA.Show`.
    *   Para garantir que a janela da área de transferência apareça à frente das outras janelas (a ordem Z), você deve chamar `Select` nela (`ClipboardWindowA.Select;`), antes de `Show`. O método `Select` torna o objeto a subview selecionada e, se o *flag* `ofTopSelect` estiver definido, move-o para a frente.

Esses passos detalham o processo para integrar janelas e suas funcionalidades avançadas, como edição de arquivos e área de transferência, em uma aplicação Turbo Vision.

Com certeza! Continuaremos com a documentação do "Exemplo 04 do manual", focando nos exemplos de uso práticos (listagens de código) para adicionar e gerenciar janelas.

### **Passo 4: Adicionando uma Janela**

Como mencionado anteriormente, o `Desktop` é fundamental para gerenciar janelas múltiplas e redimensionáveis. O manual apresenta os seguintes exemplos de código para demonstrar a adição de janelas:

*   **Adicionando uma Janela Simples de Forma Segura (Listing 3.1)**:
    *   Este exemplo, parte do `TUTOR04A.PAS`, mostra como criar e inserir uma janela básica no *desktop* de forma segura.
    *   O método `NewWindow` da aplicação `TTutorApp` é redefinido para criar uma `PWindow` (uma janela genérica).
    *   As **coordenadas da janela** são definidas usando `R.Assign(0, 0, 60, 20)` para um retângulo de 60 colunas por 20 linhas.
    *   A janela é então construída com `New(TheWindow, Init(R, 'A window', wnNoNumber))`. O parâmetro `wnNoNumber` indica que a janela não terá um número associado, mas se um número de 1 a 9 for atribuído, o usuário pode ativá-la com Alt + número.
    *   A **inserção da janela no *desktop*** é feita com `InsertWindow(TheWindow)`. O método `InsertWindow` da aplicação é recomendado por ser mais seguro, verificando se a janela foi construída com sucesso e se há memória suficiente.

    ```pascal
    procedure TTutorApp.NewWindow;
    var
      R: TRect;
      TheWindow: PWindow;
    begin
      R.Assign(0, 0, 60, 20);
      New(TheWindow, Init(R, 'A window', wnNoNumber));
      InsertWindow(TheWindow); { insere a janela no desktop }
    end;
    ```
    *   O `HandleEvent` da `TTutorApp` é modificado para chamar `NewWindow` quando o comando `cmNew` (gerado pelo menu "File | New") é recebido.

*   **Adicionando uma Janela Editora de Arquivos (Listing 3.2)**:
    *   Este exemplo, que completa o `TUTOR04B.PAS`, demonstra a configuração necessária e a criação de uma janela para edição de arquivos.
    *   **Antes de construir o objeto da aplicação**, é necessário **inicializar `MaxHeapSize := 8192`** (do módulo `Memory`). Isso reserva 128KB de memória acima do *heap* regular para *buffers* do editor de arquivos.
    *   A **variável procedural `EditorDialog`** (do módulo `Editors`) deve ser definida para `StdEditorDialog` (`EditorDialog := StdEditorDialog;`). Isso garante que as caixas de diálogo padrão do editor (como "salvar alterações") sejam usadas.
    *   O método `NewWindow` é alterado para construir uma `PEditWindow` (janela editora) em vez de uma `PWindow`. Uma *string* vazia para o título resulta no título "Untitled".

    ```pascal
    
    constructor TTutorApp.Init;
    begin
      MaxHeapSize := 8192; { configura a área de buffer do editor de arquivos acima do heap }
      EditorDialog := StdEditorDialog; { usa diálogos do editor padrão }
      inherited Init;
      DisableCommands([cmOrderWin, cmStockWin, cmSupplierWin]);
    end;

    procedure TTutorApp.NewWindow;
    var
      R: TRect;
      TheWindow: PEditWindow; { nota a mudança de tipo aqui }
    begin
      R.Assign(0, 0, 60, 20);
      New(TheWindow, Init(R, '', wnNoNumber)); { constrói a janela editora }
      InsertWindow(TheWindow);
    end;
    ```

*   **Abrindo um Arquivo para Edição Usando uma Caixa de Diálogo Padrão (Listing 3.3)**:
    *   Este exemplo, que compõe o `TUTOR04C.PAS`, mostra como usar uma caixa de diálogo `TFileDialog` para selecionar um arquivo e abri-lo em um `PEditWindow`.
    *   O método `OpenWindow` é introduzido em `TTutorApp` e é chamado em resposta ao comando `cmOpen` (do menu "File | Open").
    *   Uma instância de `TFileDialog` é criada com uma máscara inicial de arquivo (`'*.*'`), um título ("Open file"), um rótulo para a entrada ("-F-ile name"), *flags* de opção (`fdOKButton or fdOpenButton`) e um número para a lista de histórico (1).
    *   A **caixa de diálogo é executada de forma modal** usando `ExecuteDialog(FileDialog, @TheFile)`. `ExecuteDialog` retorna o comando que a fechou (por exemplo, `cmOK`, `cmCancel`).
    *   Se o usuário não cancelar (`<> cmCancel`), uma nova `PEditWindow` é criada e inserida, usando o nome do arquivo selecionado (`TheFile`) como título.

    ```pascal
    procedure TTutorApp.OpenWindow;
    var
      R: TRect;
      FileDialog: PFileDialog;
      TheFile: FNameStr;
    const
      FDOptions: Word = fdOKButton or fdOpenButton;
    begin
      TheFile := '*.*'; { máscara inicial para nomes de arquivos }
      New(FileDialog, Init(TheFile, 'Open file', '-F-ile name', FDOptions, 1));
      if ExecuteDialog(FileDialog, @TheFile) <> cmCancel then
      begin
        R.Assign(0, 0, 75, 20);
        InsertWindow(New(PEditWindow, Init(R, TheFile, wnNoNumber)));
      end;
    end;
    ```

### **Passo 5: Adicionando uma Janela da Área de Transferência (Clipboard Window)**

Este passo detalha como adicionar e gerenciar a janela da área de transferência (clipboard) na aplicação.

*   **Criando a Janela da Área de Transferência (Listing 3.4)**:
    *   Uma nova `PEditWindow` é criada para atuar como a janela da área de transferência (`ClipboardWindow`).
    *   A janela é inicializada de forma similar a outras janelas editoras, mas é **escondida (`SetState(sfVisible, False)`)** antes de ser inserida para evitar que "pisque" na tela.
    *   A **variável global `Clipboard`** (do módulo `Editors`) é configurada para apontar para o editor dentro desta janela (`Clipboard := ClipboardWindowA.Editor;`).
    *   A funcionalidade de "desfazer" (`CanUndo`) é desabilitada para o clipboard (`ClipboardA.CanUndo := False`).

    ```pascal
    constructor TTutorApp.Init;
    var R: TRect;
    begin
      MaxHeapSize := 8192;
      EditorDialog := StdEditorDialog;
      StreamError := @TutorStreamError;
      RegisterObjects; RegisterViews; RegisterEditors; RegisterApp;
      inherited Init;
      DesktopA.GetExtent(R);
      ClipboardWindow := New (PEditWindow, Init(R, '', 0));
      if ValidView(ClipboardWindow) <> nil then
      begin
        ClipboardWindowA.SetState(sfVisible, False); { a janela é inicialmente oculta }
        InsertWindow(ClipboardWindow);
        Clipboard := ClipboardWindowA.Editor;
        ClipboardA.CanUndo := False;
      end;
    end;
    ```

*   **Mostrando a Janela da Área de Transferência na Frente (Listing 3.6)**:
    *   Para exibir a janela da área de transferência em resposta ao comando `cmClipShow` (gerado pelo item "Show clipboard" do menu Editar), é necessário adicioná-la à frente das outras janelas.
    *   O método `HandleEvent` da `TTutorApp` é modificado para responder a `cmClipShow`.
    *   Para garantir que a janela apareça no topo (corrigindo a ordem Z), o método **`Select`** é chamado antes de `Show` (`ClipboardWindowA.Select; ClipboardWindowA.Show;`). `Select` torna o objeto a *subview* selecionada e o move para a frente, se o *flag* `ofTopSelect` estiver definido.

    ```pascal
    procedure TTutorApp.HandleEvent(var Event: TEvent);
    begin
      // ... outro código de tratamento de eventos ...
      if Event.What = evCommand then
      begin
        case Event.Command of
          cmClipShow:
            with ClipboardWindowA do
            begin
              Select; { move a janela para a frente }
              Show;   { exibe a janela }
              ClearEvent(Event);
            end;
          // ... outros comandos ...
        end;
      end;
      inherited HandleEvent(Event); // Chamar o inherited HandleEvent é geralmente recomendado por último
    end;
    ```