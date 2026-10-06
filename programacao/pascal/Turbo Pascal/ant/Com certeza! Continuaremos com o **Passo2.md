Com certeza! Continuaremos com o **Passo 9: Configurando os Valores de Controle** do "Turbo Vision™ Version 2.0 Programming Guide". Este passo é crucial para gerenciar a interação entre os dados da sua aplicação e os controles visuais na janela de entrada de dados.

---

### **Passo 9: Configurando os Valores de Controle**

O objetivo principal deste passo é mostrar como **definir e ler os valores dos controles** que foram adicionados à janela de entrada de dados (`TOrderWindow`), além de como a aplicação responde aos botões localizados na parte inferior dessa janela. Isso estabelece a ponte entre a lógica de dados do seu programa e sua interface de usuário.

Este passo utiliza um mecanismo de transferência de dados entre um registro Pascal e os controles visuais, permitindo que a aplicação preencha os campos da janela com dados e leia os dados inseridos pelo usuário de volta para a aplicação.

#### **1. O Registro de Dados (`TOrder`)**

*   A base para a transferência de dados para e dos controles da janela de entrada de dados é um **registro de dados**.
*   Para esta aplicação de tutorial, é definido um novo tipo de registro chamado `TOrder`, que encapsula todos os dados que a janela de entrada de pedidos irá exibir e manipular. Este registro inclui campos como `OrderNum`, `StockNum`, `OrderDate`, `Quantity`, `Payment`, `Received` e `MemoLen` (Listagem 5.6).
*   Uma variável global, `OrderInfo`, do tipo `TOrder`, é adicionada ao objeto da aplicação (`TTutorApp`). Esta variável atuará como um **buffer central** para os dados da ordem.
*   O construtor `Init` do `TTutorApp` é modificado para **inicializar os campos de `OrderInfo` com valores padrão**, por exemplo, `OrderNum := '42'`, `StockNum := 'AAA-9999'`, `Quantity := 111`, etc.. Isso garante que, ao iniciar a aplicação, haja dados iniciais para preencher a janela de pedidos.

#### **2. Definindo Valores para os Controles (`SetData`)**

*   Para preencher os controles visuais da `TOrderWindow` com os dados armazenados em `OrderInfo`, o método `OpenOrderWindow` do `TTutorApp` é atualizado para incluir uma chamada a `OrderWindowA.SetData(OrderInfo)`.
*   O método `SetData` é uma funcionalidade herdada por `TDialog` (e `TWindow`) que **copia os dados de um registro de dados fornecido para os controles correspondentes** na janela.
*   Graças a essa chamada, quando a janela de entrada de pedidos é aberta, ela exibe automaticamente os valores padrão definidos em `OrderInfo`, tornando a interface preenchida e pronta para a interação do usuário.

#### **3. Lendo Valores dos Controles (`GetData`)**

*   Para capturar as informações inseridas ou modificadas pelo usuário nos controles da janela e transferi-las de volta para a aplicação, um novo método, `SaveOrderData`, é adicionado ao objeto `TTutorApp`.
*   Este método `SaveOrderData` chama `OrderWindowA.GetData(OrderInfo)`.
*   O método `GetData` de uma `TWindow` (ou `TDialog`) atua de forma inversa ao `SetData`, **copiando os valores atuais dos controles da janela de volta para o registro de dados** fornecido (`OrderInfo`).
*   `SaveOrderData` é projetado para ser invocado em resposta ao comando `cmOrderSave`, que está associado ao botão "Save" (Salvar) na janela de pedidos.
*   Como resultado, se o usuário modificar os valores dos controles na janela, clicar em "Save", fechar a janela e depois reabri-la, os controles exibirão os valores que tinham no momento em que a janela foi fechada. Isso ocorre porque `OrderInfo` foi atualizado pelo `GetData` e, em seguida, usado para re-inicializar a janela na próxima abertura. Este processo garante que os valores dos controles sejam **persistentes**.

#### **4. Adição de Controles (Revisão)**

*   Embora os detalhes de como "adicionar controles" à janela de entrada de dados tenham sido mencionados na terceira parte do Passo 8, é importante reiterar que este Passo 9 depende de que esses controles já estejam configurados na `TOrderWindow`.
*   As Listagens 5.4 e 5.5 (p.66-67) demonstram como esses controles, como `TLabel` (rótulos) e `TInputLine` (linhas de entrada de texto), seriam criados e inseridos na janela, definindo seus limites (`TRect`), títulos e contextos de ajuda.

Com a implementação dessas funcionalidades de `SetData` e `GetData`, a aplicação agora possui um mecanismo robusto para gerenciar a entrada de dados de forma bidirecional, ligando a interface de usuário diretamente aos dados da aplicação.

O próximo passo no tutorial será o **Passo 10: Validando Entrada de Dados**, onde você aprenderá a garantir que os dados inseridos pelo usuário sejam corretos e válidos.