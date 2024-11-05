# Classe UiDmxScrollerForm

- [Classe UiDmxScrollerForm](#classe-uidmxscrollerform)
  - [Construtor](#construtor)
    - [`constructor(title, template)`](#constructortitle-template)
      - [Parâmetros](#parâmetros)
  - [Métodos](#métodos)
    - [`submit()`](#submit)
    - [`cancel()`](#cancel)
    - [`getPainel()`](#getpainel)
      - [Retorno](#retorno)
    - [`addFieldsToTable(targetContainer = document.body, getPanel = null)`](#addfieldstotabletargetcontainer--documentbody-getpanel--null)
      - [Descrição](#descrição)
      - [Parâmetros](#parâmetros-1)
      - [Retorno](#retorno-1)
      - [Exceções](#exceções)
      - [Exemplo de Uso básico](#exemplo-de-uso-básico)
  - [Detalhes de Implementação da Classe UiDmxScrollerForm](#detalhes-de-implementação-da-classe-uidmxscrollerform)
    - [1. Criação do Contêiner](#1-criação-do-contêiner)
    - [2. Título da Tabela](#2-título-da-tabela)
    - [3. Tabela de Entrada](#3-tabela-de-entrada)
    - [4. Rodapé do Formulário](#4-rodapé-do-formulário)
    - [5. Adição ao DOM](#5-adição-ao-dom)
    - [6. Estilos CSS](#6-estilos-css)
    - [7. Observações Importantes](#7-observações-importantes)
  - [Referências](#referências)

---

A classe `UiDmxScrollerForm` herda de `UiDmxScroller` e é responsável por criar um formulário dinâmico que permite a coleta de dados através de campos de entrada em uma tabela.

## Construtor

### `constructor(title, template)`

#### Parâmetros

- `title` (String): O título do formulário.
- `template` (String): Um template que define a estrutura dos campos de entrada.

## Métodos

### `submit()`

Lida com o envio do formulário. Este método pode ser personalizado para processar os dados conforme necessário.

### `cancel()`

Lida com o cancelamento do formulário. Este método pode ser personalizado para limpar o formulário ou fechar o diálogo.

### `getPainel()`

Cria e retorna um painel com botões para enviar e cancelar o formulário.

#### Retorno

- (HTMLElement): Um elemento de painel contendo os botões "Enviar" e "Cancelar".

### `addFieldsToTable(targetContainer = document.body, getPanel = null)`

#### Descrição

O método `addFieldsToTable` cria um contêiner de tabela dinâmico no DOM, contendo campos de entrada conforme especificado. Ele permite a adição de um rodapé opcional através de um painel, caso um método de obtenção de painel seja fornecido.

#### Parâmetros

- **targetContainer** (`HTMLElement`): O contêiner de destino onde o novo contêiner será adicionado. Por padrão, é o corpo do documento (`document.body`).
- **getPanel** (`function` | `null`): Um método opcional que retorna um painel a ser adicionado ao contêiner. Se não for fornecido, o método `getPainel` da instância é chamado.

#### Retorno

- (HTMLElement): Retorna o `HTMLElement` do contêiner criado que contém a tabela e os campos de entrada.

#### Exceções

- Não lança exceções específicas, mas pode falhar se o `targetContainer` não for um `HTMLElement` válido.

#### Exemplo de Uso básico

```javascript

    <body>
        <div id="formContainer1"></div>
        

        <script type="module">
            import { UiDmxScrollerForm } from './js/UiDmxScrollerForm.js';

            // Define o título e o template do formulário

            const title = 'Teste UiDmxScrollerForm';

            const template = `
            ~ Nome do Aluno:~\\ssssssssssssssssssssssssssss^Bnome_do_aluno   \\ \\   ~ Idade:~\\sss^Bidade    ~Altura:~\\sss^Baltura 
            ~      Endereço:~\\sssssssssssssssssssssssssssssssssss^Bendereco \\ \\   ~ Altura:~\\sss^Baltura  ~Altura:~\\sss^Baltura 
            ~ Nome do Aluno:~\\ssssssssssssssssssssssssssss^Bnome_do_aluno   \\ \\   ~ Idade:~\\sss^Bidade    ~Altura:~\\sss^Baltura 

                `;

            // Método estático para criar o formulário
            UiDmxScrollerForm.createForm(title, template, document.getElementById('formContainer1'));

        </script>
    </body>


```

## Detalhes de Implementação da Classe UiDmxScrollerForm

A classe `UiDmxScrollerForm` implementa um formulário dinâmico que permite a coleta de dados através de campos de entrada em uma tabela. Abaixo estão os detalhes de implementação que descrevem como a classe funciona internamente.

### 1. Criação do Contêiner

- Um elemento `<form>` é criado como o contêiner principal, que contém todos os elementos do formulário, incluindo a tabela de entrada.

### 2. Título da Tabela

- Um título é adicionado ao contêiner, definido pela propriedade `title` da instância. Este título é exibido na parte superior da tabela.

### 3. Tabela de Entrada

- Uma tabela é criada, onde cada linha corresponde a um conjunto de campos definidos na propriedade `fields`.
- Para cada campo, um rótulo (`label`) e um campo de entrada (`input`) são criados:
  - O rótulo é associado ao campo de entrada correspondente.
  - O campo de entrada é estilizado com base na propriedade `maxLength`, que determina o número máximo de caracteres que o usuário pode inserir.

### 4. Rodapé do Formulário

- Se um método `getPanel` for fornecido, o painel correspondente (contendo botões de ação) é adicionado ao contêiner principal.
- Caso contrário, o método `getPainel` da instância é chamado para obter um painel padrão com botões "Enviar" e "Cancelar".

### 5. Adição ao DOM

- O contêiner do formulário é anexado ao `targetContainer` especificado, que pode ser qualquer elemento HTML no qual você deseja que o formulário apareça.

### 6. Estilos CSS

- A classe `inputBox-container` é utilizada para estilizar o contêiner externo do formulário.
- A classe `inputBox-table-title` é utilizada para estilizar o título da tabela.
- A classe `inputBox-table-container` é utilizada para estilizar o contêiner da tabela.

### 7. Observações Importantes

- Certifique-se de que os campos definidos na propriedade `fields` contenham as propriedades necessárias, como `label`, `align`, `id`, `name` e `maxLength`.
- A largura do campo de entrada é calculada com base no número máximo de caracteres permitidos e na largura estimada de cada caractere, garantindo que o layout do formulário seja responsivo e visualmente agradável.

## Referências

- [Código fonte](../UiDmxScrollerForm.js)