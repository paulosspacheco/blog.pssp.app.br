# Documentação da Classe `AbstractDialogs`

- [Documentação da Classe `AbstractDialogs`](#documentação-da-classe-abstractdialogs)
  - [Estrutura da Classe](#estrutura-da-classe)
    - [Construtor](#construtor)
    - [Métodos Abstratos](#métodos-abstratos)
    - [Métodos de Instância](#métodos-de-instância)
  - [Exemplo de Uso](#exemplo-de-uso)
  - [Considerações Finais](#considerações-finais)

---

A classe `AbstractDialogs` é uma classe abstrata que estende a classe `UiDmxScrollerForm`. Ela fornece uma estrutura básica para a criação de diálogos em uma interface de usuário, definindo métodos que devem ser implementados por subclasses.

## Estrutura da Classe

### Construtor

```javascript

  constructor(title, template)

```

- **Parâmetros:**
  - `title`: O título do diálogo.
  - `template`: O template a ser utilizado no diálogo.
  
- **Exceções:**
  - Lança um erro se tentar instanciar a classe `AbstractDialogs` diretamente.
  
### Métodos Abstratos

A classe define os seguintes métodos que devem ser implementados por subclasses:

- `createForm()`
  - **Descrição:** Método que deve ser implementado para criar o formulário do diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `createDialog()`
  - **Descrição:** Método que deve ser implementado para criar o diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `setupEventListeners()`
  - **Descrição:** Método que deve ser implementado para configurar os ouvintes de eventos do diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `openDialog()`
  - **Descrição:** Método que deve ser implementado para abrir o diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `collectDialogData()`
  - **Descrição:** Método que deve ser implementado para coletar os dados do diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `closeDialog()`
  - **Descrição:** Método que deve ser implementado para fechar o diálogo.
  - **Exceções:** Lança um erro se não for implementado.

- `submit()`
  - **Descrição:** Método para lidar com o envio do formulário.
  - **Exceções:** Lança um erro se não for implementado.

- `cancel()`
  - **Descrição:** Método para lidar com o cancelamento do formulário.
  - **Exceções:** Lança um erro se não for implementado.

### Métodos de Instância

- `handleDialog(resolve, reject)`
  - **Descrição:** Configura as funções de resolução e rejeição do diálogo e chama o método `openDialog()`.

- `callDialog()`
  - **Descrição:** Retorna uma nova `Promise` que chama `handleDialog`.

- `async executeDialog()`
  - **Descrição:** Executa o diálogo e coleta os dados, retornando-os como um objeto JSON.
  - **Retorno:** Retorna os dados coletados ou `null` em caso de erro.

- `async openDialogAndDisplayData()`
  - **Descrição:** Abre o diálogo e exibe os dados coletados em um alerta.
  - **Tratamento de Erros:** Exibe um alerta com a mensagem de erro, se ocorrer.

## Exemplo de Uso

Para usar a classe `AbstractDialogs`, você deve criar uma subclasse que implemente os métodos abstratos definidos. Aqui está um exemplo de como uma subclasse poderia ser definida:

```javascript
    class MyDialog extends AbstractDialogs {
        createForm() {
            // Implementação do formulário
        }

        createDialog() {
            // Implementação do diálogo
        }

        setupEventListeners() {
            // Implementação dos ouvintes de eventos
        }

        openDialog() {
            // Implementação para abrir o diálogo
        }

        collectDialogData() {
            // Implementação para coletar os dados do diálogo
        }

        closeDialog() {
            // Implementação para fechar o diálogo
        }

        submit() {
            // Implementação para enviar o formulário
        }

        cancel() {
            // Implementação para cancelar o formulário
        }
    }
```

## Considerações Finais

A classe `AbstractDialogs` serve como um ponto de partida para a criação de diálogos personalizados em aplicações que utilizam a classe `UiDmxScrollerForm`. É importante implementar todos os métodos abstratos para garantir o funcionamento adequado da classe.