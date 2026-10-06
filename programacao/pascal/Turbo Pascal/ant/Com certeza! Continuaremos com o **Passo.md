Com certeza! Continuaremos com o **Passo 8: Criando uma Janela de Entrada de Dados** do "Turbo Vision™ Version 2.0 Programming Guide". Este passo é crucial para desenvolver interfaces onde o usuário pode inserir e manipular informações de forma estruturada.

---

### **Passo 8: Criando uma Janela de Entrada de Dados**

No Turbo Vision, a entrada de dados geralmente ocorre em **caixas de diálogo**. No entanto, neste exemplo específico do tutorial, a janela de entrada de dados que será criada **não será modal**. Em vez de ser executada (o que a tornaria modal e bloquearia outras interações), ela será **inserida** na aplicação, como uma janela comum. É importante notar que um `TDialog` (caixa de diálogo) é, na verdade, um tipo especializado de `TWindow` (janela).

Este passo é dividido em três partes principais para a criação da janela de entrada de dados:

1.  **Criando um novo tipo de janela**
2.  **Prevenindo janelas duplicadas**
3.  **Adicionando controles à janela**

#### 1. Criando um Novo Tipo de Janela

Para personalizar a janela de entrada de dados, é necessário definir um **novo tipo de objeto** para ela, que será chamado `TOrderWindow`. A aplicação (`TTutorApp`) manterá um ponteiro para este objeto de janela de pedidos, permitindo o acesso e gerenciamento.

A aplicação também precisa responder ao comando `cmOrderWin`, que está vinculado ao item "Examine" no menu "Orders". Quando o usuário seleciona "Orders | Examine", a janela de entrada de pedidos deve ser exibida.

As modificações no código incluem:

*   **Declaração de `TOrderWindow`**: `TOrderWindow` é declarado como um objeto que herda de `TDialog`.
*   **Ponteiro na Aplicação**: Uma variável `OrderWindow: POrderWindow;` é adicionada ao objeto `TTutorApp`, servindo como um ponteiro para a janela de pedidos.
*   **Método `Init` de `TOrderWindow`**:
    *   Ele define os limites (`Bounds`) da janela e o título como **'Orders'**.
    *   Define a opção `ofCentered`, garantindo que a caixa de diálogo seja **centralizada na área de trabalho**.
    *   Define o `HelpCtx` (contexto de ajuda) para `$F000`. Esta alteração é significativa porque, como foi visto no Passo 2, a linha de status muda automaticamente quando o contexto de ajuda da aplicação cai em uma faixa específica (neste caso, `$F000 .. $FFFF`), exibindo as chaves de status apropriadas definidas para essa faixa.
*   **Método `HandleEvent` de `TTutorApp`**: É modificado para chamar `OpenOrderWindow` em resposta ao comando `cmOrderWin`.
*   **Método `OpenOrderWindow` de `TTutorApp`**: Este método cria uma nova instância de `TOrderWindow` e a insere na área de trabalho (`desktop`).

Ao executar o programa, o usuário notará que, ao selecionar "Orders | Examine", uma caixa de diálogo com o título 'Orders' aparecerá centralizada. Além disso, a **linha de status será alterada** porque `TOrderWindow` define um novo contexto de ajuda (`HelpCtx`) para `$F000`. Isso faz com que a linha de status exiba automaticamente as chaves de status definidas para essa faixa.

#### 2. Prevenindo Janelas Duplicadas

Um problema potencial surge se o usuário tentar abrir a janela de pedidos novamente quando uma já estiver aberta: `OpenOrderWindow` simplesmente cria e insere uma nova janela, fazendo com que a aplicação `TTutorApp` rastreie apenas a mais recente. Para evitar isso e garantir que, se uma janela já estiver aberta, ela seja trazida para a frente, utiliza-se um mecanismo de **mensagens broadcast**.

O processo é o seguinte:

*   **Envio de Mensagem Broadcast**: A aplicação envia uma mensagem broadcast (`evBroadcast`) com um comando específico (`cmFindOrderWindow`) para o objeto `Desktop`. O `Desktop`, por sua vez, retransmite essa mensagem para todas as suas subviews (as janelas que gerencia).
    *   A função `Message(Receiver, What, Command, InfoPtr)` é usada para enviar a mensagem. Ela retorna `nil` se nenhuma view respondeu, ou um ponteiro para a view que a tratou.
    *   No método `OpenOrderWindow` de `TTutorApp`, a lógica é modificada: se a mensagem de busca (`cmFindOrderWindow`) retornar `nil`, uma nova `TOrderWindow` é criada e inserida. Caso contrário (se uma janela de pedidos existente responder), a janela existente é trazida para a frente usando o método `Select`.
*   **Resposta à Mensagem**: O objeto `TOrderDialog` (a `TOrderWindow`) tem um método `HandleEvent` modificado para responder a essa mensagem broadcast. Quando recebe um `evBroadcast` com `cmFindOrderWindow`, ele simplesmente **limpa o evento** (`ClearEvent(Event)`).
    *   O método `ClearEvent` não apenas marca o evento como tratado, mas também define o campo `InfoPtr` do registro de evento para o endereço do próprio objeto (`@Self`) que o tratou. Dessa forma, a função `Message` da aplicação pode retornar um ponteiro para a `TOrderWindow` que já está aberta.

Após essas modificações, a aplicação agora pode gerenciar a abertura da janela de entrada de dados, garantindo que não haja duplicatas e que as janelas existentes sejam reutilizadas.

#### 3. Adicionando Controles à Janela

Neste ponto, a janela de entrada de dados (`TOrderWindow`) já pode ser aberta e gerenciada. A próxima fase envolve a **adição de controles** (como botões, caixas de entrada de texto, botões de rádio, etc.) a esta janela. No entanto, os detalhes sobre como definir e manipular os valores desses controles, bem como a resposta aos botões na parte inferior da janela, serão abordados no próximo passo do tutorial.

---

Com estas etapas, a aplicação ganhou uma funcionalidade importante para entrada de dados e um gerenciamento mais robusto de suas janelas. O próximo passo do tutorial é o **Passo 9: Configurando os Valores de Controle**.