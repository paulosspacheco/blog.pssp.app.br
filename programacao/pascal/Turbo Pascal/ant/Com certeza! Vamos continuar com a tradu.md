Com certeza! Vamos continuar com a tradução e detalhamento do tutorial do "Turbo Vision™ Version 2.0 Programming Guide". O próximo passo é o **Passo 6: Salvando e carregando o *desktop***.

Este passo é crucial porque, até agora, todas as operações realizadas em nosso aplicativo são temporárias e se perdem ao fechar o programa. Com o uso de *streams* e *recursos*, aprenderemos a **salvar o trabalho** e o estado do *desktop* para restaurá-lo posteriormente.

---

### **Passo 6: Salvando e Carregando o Desktop**

O Turbo Vision utiliza **streams (fluxos)** para armazenar objetos, seja em um arquivo de disco ou na memória EMS. Diferente de um arquivo Pascal normal, os *streams* representam um fluxo de bytes lidos ou escritos sequencialmente, lidando com I/O no nível do objeto, e não apenas no nível dos dados. Isso significa que os *streams* sabem que estão lidando com objetos e podem manipular diferentes tipos de objetos, mesmo aqueles que não existiam na compilação do *stream*, graças ao mecanismo de **registro**.

Este passo é dividido em três etapas principais para salvar e carregar o *desktop*:

1.  **Registrando objetos com streams**
2.  **Salvando o desktop**
3.  **Carregando o desktop**

#### 1. Registrando Objetos com Streams

Para que um tipo de objeto possa ser usado com *streams*, ele deve ser **registrado com os streams do Turbo Vision**. O registro informa ao *stream* como identificar o objeto e como ler ou escrever seus dados. A melhor prática é realizar o registro no **construtor da aplicação (`TApplication.Init`)**, garantindo que o acesso ao *stream* ocorra apenas após todos os objetos necessários estarem registrados.

As unidades do Turbo Vision fornecem procedimentos para registrar seus objetos para uso com *streams*. Por exemplo, para registrar objetos da unidade `Editors`, você chama `RegisterEditors`. O objeto `Desktop` está na unidade `App`, e as janelas e seus componentes estão na unidade `Views`. Portanto, é necessário chamar `RegisterApp`, `RegisterViews`, e também `RegisterObjects`.

A listagem a seguir (Listing 4.1) mostra o construtor da aplicação revisado para incluir o registro de objetos e outras inicializações:

```pascal
constructor TTutorApp.Init;
var R: TRect;
begin
  MaxHeapSize := 8192; // Configura buffer para o editor de arquivos
  EditorDialog := StdEditorDialog; // Usa diálogos padrão do editor
  StreamError := @TutorStreamError; // Define o manipulador de erros de stream
  RegisterObjects; // Registra objetos básicos
  RegisterViews; // Registra objetos de view (janelas, etc.)
  RegisterEditors; // Registra objetos do editor
  RegisterApp; // Registra objetos da aplicação e desktop
  inherited Init; // Chama o construtor ancestral
  DesktopA.GetExtent(R);
  ClipboardWindow := New (PEditWindow, Init(R, "", 0));
  if ValidView(ClipboardWindow) <> nil then
  begin
    ClipboardWindowA.SetState(sfVisible, False); // A janela é inicialmente oculta
    InsertWindow(ClipboardWindow);
    Clipboard := ClipboardWindowA.Editor; // Atribui o editor da janela ao Clipboard global
    ClipboardA.CanUndo := False; // Desabilita o desfazer para o clipboard
  end;
end;
```

**Manipulação de Erros de Stream**:
A Listagem 4.1 também introduz um recurso de segurança: a variável `StreamError`. Esta variável aponta para um procedimento que é chamado por qualquer *stream* do Turbo Vision quando um erro é encontrado. Por padrão, `StreamError` é `nil`. No exemplo, ele é atribuído a `TutorStreamError` (Listing 4.2), que é um manipulador de erros simples que relata erros e interrompe a execução:

```pascal
procedure TutorStreamError(var S: TStream); far;
begin
  ClearScreen; // Limpa a tela
  Writeln('Erro de stream: Status = ', S.Status, ', Info = ', S.ErrorInfo); // Mostra mensagem de erro
  Halt(1); // Interrompe com nível de erro 1
end;
```
Este procedimento, embora simples, garante que quaisquer erros de *stream* sejam reportados.

#### 2. Salvando o Desktop

Para salvar o *desktop* e todas as janelas que ele contém, são necessárias três ações principais:

1.  **Abrir o stream**: Inicializa um objeto *stream* para gravação.
2.  **Armazenar o objeto desktop**: Escreve o objeto `Desktop` no *stream*.
3.  **Fechar o stream**: Finaliza a operação do *stream* e fecha o arquivo.

Para arquivos em disco, `TDosStream` pode ser usado, mas o `TBufStream` (uma versão *buffered*) oferece melhor desempenho, especialmente com muitas transferências de dados pequenos.

O item "Store Desktop" no menu "Options" gera o comando `cmOptionsSave`. O manipulador de eventos da aplicação (`HandleEvent`) precisa ser estendido para responder a este comando, chamando um novo método chamado `SaveDesktop`.

A listagem a seguir (Listing 4.3) mostra o método `SaveDesktop`:

```pascal
procedure TTutorApp.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmOptionsSave:
      begin
        SaveDesktop;
        ClearEvent(Event);
      end;
      // ... outros comandos ...
    end;
  end;
  // inherited HandleEvent(Event); é geralmente recomendado por último - nota para o usuário: o manual o coloca no início, mas em outros trechos sugere ao final.
end;

procedure TTutorApp.SaveDesktop;
var
  DesktopFile: TBufStream;
begin
  // Abre o stream: 'DESKTOP.TUT', cria se não existe, buffer de 1KB
  DesktopFile.Init('DESKTOP.TUT', stCreate, 1024);
  DesktopFile.Put(Desktop); // Armazena o desktop
  DesktopFile.Done; // Fecha o stream
end;
```

*   O método `Init` do `TBufStream` cria um novo arquivo (`stCreate`), mesmo que ele já exista, similar ao `Rewrite` do Pascal.
*   O método `Put` do *stream* é chamado para escrever o objeto `Desktop`. Este método, por sua vez, chama o método `Store` do objeto `Desktop`.
*   Todos os objetos que serão usados com *streams* devem ter um método `Store` (e um `Load` correspondente). Como `TDesktop` descende de `TGroup`, ele automaticamente escreve todas as *subviews* inseridas nele, incluindo o *background* e as janelas.
*   É importante **não chamar `Store` diretamente**; o *stream* o faz no momento apropriado.
*   O método `Done` do *stream* descarrega seu *buffer* e fecha o arquivo associado.

**Preservando a Área de Transferência (Clipboard)**:
Se você salvar o `ClipboardWindow` e depois restaurá-lo, o ponteiro global `Clipboard` (do módulo `Editors`) que aponta para o editor dentro dessa janela se tornará inválido. Para evitar isso, a solução mais simples é **excluir a área de transferência das operações de salvar e carregar**.

A listagem a seguir (Listing 4.4) mostra uma maneira mais segura de salvar o *desktop*, excluindo temporariamente o `ClipboardWindow`:

```pascal
procedure TTutorApp.SaveDesktop;
var
  DesktopFile: TBufStream;
begin
  DesktopA.Delete(ClipboardWindow); // Remove o clipboard do desktop
  DesktopFile.Init('DESKTOP.TUT', stCreate, 1024); // Abre o stream
  DesktopFile.Put(Desktop); // Armazena o desktop
  DesktopFile.Done; // Fecha o stream
  InsertWindow(ClipboardWindow); // Restaura a janela do clipboard
end;
```
Esta abordagem trata o *clipboard* como parte da aplicação, em vez de parte do *desktop*, embora o *desktop* o gerencie.

#### 3. Carregando o Desktop

Restaurar o *desktop* é o inverso de salvá-lo, mas requer algumas precauções. É importante **verificar a validade do objeto carregado** e substituir cuidadosamente o *desktop* existente. Os passos para carregar o objeto correspondem aos de salvar:

1.  **Abrir o stream**
2.  **Ler o objeto**
3.  **Fechar o stream**

A listagem a seguir (Listing 4.5) mostra o código para recuperar o objeto *desktop*:

```pascal
// Fragmento de código para leitura do desktop
// DesktopFile.Init('DESKTOP.TUT', stOpenRead, 1024); // Abre o stream para leitura
// TempDesktop := PDesktop(DesktopFile.Get); // Obtém o desktop (para uma variável temporária)
// DesktopFile.Done; // Fecha o stream
```
Dois pontos importantes sobre este código:
*   O *desktop* carregado é atribuído a uma **variável temporária (`TempDesktop`)** para evitar a perda do `Desktop` antigo caso o novo seja inválido e para permitir a liberação da memória do antigo `Desktop`.
*   O método `Get` é usado para ler o objeto do *stream*, sendo a contraparte do método `Put`. `Get` lê as informações que `Put` escreveu e chama o **construtor `Load`** do objeto para lê-lo do *stream*.
*   `Get` retorna um ponteiro do tipo `PObject`, então é necessário fazer um **typecast** para o tipo apropriado (`PDesktop` neste caso).

**Validando o Objeto**:
Após carregar um objeto do *stream*, é recomendável passá-lo por `ValidView` para garantir que ele foi construído corretamente. `ValidView` retorna `nil` se o método `Valid` do objeto retornar `False`.

```pascal
// Fragmento de código para validação
// if ValidView(TempDesktop) <> nil then
// begin
//   // ... código para substituir o Desktop ...
// end;
```

**Substituindo o Desktop**:
Uma vez que o `TempDesktop` é considerado válido, o *desktop* existente pode ser substituído. Isso envolve cinco etapas:

1.  Remover o `ClipboardWindow` do *desktop* (o `TempDesktop` não tem este objeto, então ele será reinserido no final).
2.  Deletar o *desktop* antigo do objeto da aplicação (`Delete(Desktop)`).
3.  Dispor (liberar a memória) do *desktop* antigo (`Dispose(Desktop, Done)`).
4.  Atribuir o novo *desktop* (`Desktop := TempDesktop`).
5.  Inserir o novo *desktop* (`Insert(Desktop)`).
6.  Ajustar o tamanho e a posição do *desktop* à tela atual, especialmente se o modo de vídeo mudou entre salvar e carregar (`GetExtent(R); R.Grow(0, -1); DesktopA.Locate(R)`).
7.  Reinserir o `ClipboardWindow`.

A listagem a seguir (Listing 4.6) mostra o método `LoadDesktop` completo:

```pascal
procedure TTutorApp.LoadDesktop;
var
  DesktopFile: TBufStream;
  TempDesktop: PDesktop;
  R: TRect;
begin
  DesktopFile.Init('DESKTOP.TUT', stOpenRead, 1024); // Abre o stream
  TempDesktop := PDesktop(DesktopFile.Get); // Obtém o desktop
  DesktopFile.Done; // Fecha o stream

  if ValidView(TempDesktop) <> nil then // Se o novo desktop é válido
  begin
    DesktopA.Delete(ClipboardWindow); // Remove o clipboard do desktop atual
    Delete(Desktop); // Deleta o desktop antigo da aplicação
    Dispose(Desktop, Done); // Libera a memória do desktop antigo

    Desktop := TempDesktop; // Atribui o novo desktop
    Insert(Desktop); // Insere o novo desktop na aplicação

    GetExtent(R);
    R.Grow(0, -1); // Ajusta o retângulo para a área da aplicação, considerando menu e status bar
    DesktopA.Locate(R); // Ajusta o novo desktop ao tamanho da tela

    InsertWindow(ClipboardWindow); // Reinserir a janela do clipboard
  end;
end;
```
Este método completo garante que o *desktop* seja restaurado de forma segura e consistente, ajustando-se às condições atuais da aplicação.

---

Este cobre o Passo 6. O próximo passo do tutorial é o **Passo 7: Usando Recursos**.