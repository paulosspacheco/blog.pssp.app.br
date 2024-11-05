# Documentação da Classe `Dialog`

- [Documentação da Classe `Dialog`](#documentação-da-classe-dialog)
  - [Descrição](#descrição)
  - [Herança](#herança)
  - [Construtor](#construtor)
    - [`constructor(title: string, template: string)`](#constructortitle-string-template-string)
      - [Parâmetros](#parâmetros)
  - [Métodos](#métodos)
    - [`createDialog()`](#createdialog)
    - [`setupEventListeners()`](#setupeventlisteners)
    - [`collectDialogData()`](#collectdialogdata)
      - [Retorno](#retorno)
    - [`closeDialog()`](#closedialog)
    - [`validateFields()`](#validatefields)
    - [`validateField(field: Object)`](#validatefieldfield-object)
      - [Parâmetros](#parâmetros-1)
      - [Retorno](#retorno-1)
    - [`submit()`](#submit)
    - [`cancel()`](#cancel)
    - [`getPainel()`](#getpainel)
    - [`openDialog()`](#opendialog)
    - [`addFieldsToDialog()`](#addfieldstodialog)
    - [`static showModal(title: string, template: string)`](#static-showmodaltitle-string-template-string)
      - [Parâmetros](#parâmetros-2)
      - [Retorno](#retorno-2)
  - [Exemplo de Uso](#exemplo-de-uso)

---

## Descrição

A classe `Dialog` é responsável pela manipulação de diálogos modais em uma interface HTML. Ela estende a classe `AbstractDialogs`, fornecendo métodos para abrir, fechar, confirmar e cancelar diálogos. Além disso, gerencia eventos de botão para a interação do usuário.

## Herança

- Extende: `AbstractDialogs`

## Construtor

### `constructor(title: string, template: string)`

Cria uma nova instância da classe `Dialog`.

#### Parâmetros

- `title` (string): Título do diálogo.
- `template` (string): Template usado para criar o formulário do diálogo.

## Métodos

### `createDialog()`

Adiciona um contêiner de campos a um diálogo modal. Se o diálogo não existir, ele é criado dinamicamente.

### `setupEventListeners()`

Configura ouvintes de eventos para os botões de abrir, confirmar e cancelar o diálogo.

### `collectDialogData()`
Coleta os dados do diálogo.

#### Retorno

- `Object`: Um objeto contendo os dados inseridos pelo usuário.

### `closeDialog()`

Fecha o diálogo e remove o overlay associado.

### `validateFields()`

Valida os campos do diálogo, verificando se estão vazios ou se excedem o comprimento máximo permitido.

### `validateField(field: Object)`

Valida um campo específico.

#### Parâmetros

- `field` (Object): O campo a ser validado.

#### Retorno

- `boolean`: Retorna `true` se a validação passar, `false` caso contrário.

### `submit()`

Confirma o diálogo. Verifica a validade do formulário antes de confirmar. Se válido, coleta os dados e fecha o diálogo.

### `cancel()`

Cancela o diálogo e rejeita a promessa associada com uma mensagem de cancelamento.

### `getPainel()`

Cria e retorna um painel de botões (Cancelar e OK) para o diálogo.

### `openDialog()`

Abre o diálogo modal e captura os dados inseridos.

### `addFieldsToDialog()`

Adiciona um contêiner de campos ao diálogo modal. Se o elemento `dialog` não existir, ele é criado dinamicamente.

### `static showModal(title: string, template: string)`

Abre o diálogo modal e retorna uma promessa.

#### Parâmetros

- `title` (string): Título do diálogo.
- `template` (string): Template usado para criar o formulário do diálogo.

#### Retorno

- `Promise`: Retorna uma promessa que resolve com os dados coletados ou rejeita com uma mensagem de erro.

## Exemplo de Uso

```javascript
    Dialog.showModal('Título do Diálogo', 'Template do Diálogo')
        .then(data => {
            console.log('Dados capturados:', data);
        })
        .catch(error => {
            console.error('Erro:', error);
        });

```
