# Classe UiDmxScroller

- [Classe UiDmxScroller](#classe-uidmxscroller)
  - [Construtor](#construtor)
    - [`constructor(title, template)`](#constructortitle-template)
      - [Parâmetros](#parâmetros)
  - [Métodos](#métodos)
    - [`includeCSS()`](#includecss)
      - [Classes CSS utilizadas](#classes-css-utilizadas)
    - [`adjustTableFontSize(container)`](#adjusttablefontsizecontainer)
      - [Parâmetros](#parâmetros-1)
    - [`parseTemplate(template)`](#parsetemplatetemplate)
      - [Parâmetros](#parâmetros-2)
    - [`getValues()`](#getvalues)
      - [Retorno](#retorno)
  - [Exemplo de Uso](#exemplo-de-uso)
  - [Referências](#referências)

---

A classe `UiDmxScroller` herda de `MiMethods` e é responsável por criar uma interface de entrada baseada em uma tabela. Ela permite a personalização do tamanho da fonte e a coleta de valores de campos de entrada.

## Construtor

### `constructor(title, template)`

```javascript

    constructor(title, template)

```

#### Parâmetros

- `title` (String): O título da interface.
- `template` (String): Um template que define a estrutura dos campos de entrada.

## Métodos

### `includeCSS()`

Este método é virtual e pode ser redefinido nas classes filhas. Ele inclui o CSS necessário para a estilização da caixa de diálogo de entrada.

#### Classes CSS utilizadas

1. **`.inputBox-dialog-overlay`**: Define o overlay que cobre a tela quando a caixa de diálogo está ativa, com fundo semi-transparente e oculto por padrão.
2. **`.inputBox-dialog`**: Estiliza a caixa de diálogo centralizada na tela, com fundo branco, bordas arredondadas e sombra. Controla a largura e altura máximas da caixa.
3. **`.inputBox-dialog-header`**: Estiliza o cabeçalho da caixa de diálogo, definindo o tamanho da fonte e espaçamento inferior.
4. **`.inputBox-container`**: Um contêiner flexível que ocupa toda a largura e altura disponíveis, permitindo rolagem vertical quando o conteúdo excede o tamanho da caixa.
5. **`.inputBox-table-title`**: Estiliza a linha de título da tabela, com altura fixa, cor de fundo e centralização do texto.
6. **`.inputBox-table-container`**: Contêiner que permite que a tabela ocupe o espaço restante, com rolagem vertical e horizontal.
7. **`.inputBox-footer-panel`**: Estiliza o painel do rodapé, definindo altura, cor de fundo e alinhamento dos botões.

### `adjustTableFontSize(container)`

Ajusta o tamanho da fonte da tabela com base na largura do contêiner fornecido.

#### Parâmetros

- `container` (HTMLElement): O contêiner cujas dimensões serão utilizadas para ajustar o tamanho da fonte.

### `parseTemplate(template)`

Analisa o [template](./UiDmxScroller.getTemplate.html) fornecido e coleta os campos de entrada definidos.

#### Parâmetros

- `template` (String): Um template que define a estrutura dos campos de entrada, onde cada linha pode conter labels e campos.

  - `Exemplo`

  ```javascript
          const template = `
              ~Nome do Aluno:~ \\ssssssssssssssssssssssssssss  ^Bnome_do_aluno 
              ~Número~:        \\sssssss            ^Bnumero       
              ~Endereço~:      \\ssssssssssssssssssssssssssssss^Bendereco      
              ~Nome da Mãe~:   \\sssssssssssssssssss^Bnome_da_mae                           
          `;


  ```

### `getValues()`

Coleta os valores dos campos de entrada e os retorna como um objeto JSON.

#### Retorno

- (Object|null): Um objeto contendo os valores dos campos de entrada, ou `null` em caso de erro.

## Exemplo de Uso

```javascript

    const template = `
        ~Nome do Aluno:~ \\ssssssssssssssssssssssssssss  ^Bnome_do_aluno 
        ~Número~:        \\sssssss            ^Bnumero       
        ~Endereço~:      \\ssssssssssssssssssssssssssssss^Bendereco      
        ~Nome da Mãe~:   \\sssssssssssssssssss^Bnome_da_mae                           
    `;

    const scroller = new UiDmxScroller("Meu Título",template);
    const values = scroller.getValues();
    console.log(values);

```

## Referências

- [código fonte](../UiDmxScroller.js)
