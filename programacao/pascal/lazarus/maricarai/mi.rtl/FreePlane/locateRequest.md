<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>

# Análise de uso da requisição TMi_rtl_WebModule.CmlocateRequest() do Servidor REST API e uma Aplicação Cliente

- [Análise de uso da requisição TMi\_rtl\_WebModule.CmlocateRequest() do Servidor REST API e uma Aplicação Cliente](#análise-de-uso-da-requisição-tmi_rtl_webmodulecmlocaterequest-do-servidor-rest-api-e-uma-aplicação-cliente)
  - [Visão Geral](#visão-geral)
  - [Arquitetura](#arquitetura)
  - [Fluxo de Operação](#fluxo-de-operação)
  - [Diagramas de sequência](#diagramas-de-sequência)
    - [Diagrama de sequência com a interação entre o browser, usuário e servidor](#diagrama-de-sequência-com-a-interação-entre-o-browser-usuário-e-servidor)
  - [Considerações](#considerações)
    - [Explicação](#explicação)

## Visão Geral

Este documento descreve a interação entre uma aplicação cliente e um servidor REST API para localizar e exibir registros. O fluxo é iniciado quando o usuário solicitar um formulário em seguida pressiona o botão na aplicação cliente para realizar uma pesquisa.

## Arquitetura

- **Servidor REST API**: Fornece o serviço de localização de registros.
- **Aplicação Cliente**: Interage com o usuário e faz requisições ao servidor para localizar registros.

## Fluxo de Operação

1. **Usuário Pressiona o Botão Localizar**

   - O usuário pressiona o botão "Localizar" na aplicação cliente.

2. **Aplicação Cliente Exibe Formulário de Pesquisa**

   - A aplicação cliente exibe um formulário para o usuário inserir os dados da pesquisa. O formulário coleta as informações necessárias para a pesquisa, como o termo de pesquisa ou identificador do registro.

3. Aplicação Cliente Requisita o Método Localizar no Servidor

   - Após o usuário enviar o formulário, a aplicação cliente faz uma requisição HTTP POST ao servidor REST API com os dados da pesquisa.

   - Exemplo de Requisição:

     ```text

        POST /api/localizar
        Content-Type: application/json

        {
        "termo": "valor pesquisado"
        }

     ```

4. Servidor REST API Processa a Requisição

   - O servidor REST API processa a requisição e localiza o registro correspondente. O servidor então responde com os dados do registro encontrado.

   - Exemplo de Resposta:

   ```text

        HTTP/1.1 200 OK
        Content-Type: application/json

        {
        "id": 123,
        "nome": "Registro Encontrado",
        "descricao": "Descrição do registro encontrado."
        }

   ```

5. Aplicação Cliente Exibe o Resultado

   - A aplicação cliente recebe a resposta do servidor e exibe as informações do registro encontrado na interface do usuário.

   ```text
        Resultado da Pesquisa:
        - ID: 123
        - Nome: Registro Encontrado
        - Descrição: Descrição do registro encontrado.
   
   ```

## Diagramas de sequência

### Diagrama de sequência com a interação entre o browser, usuário e servidor

---
<pre><code class="language-mermaid"><div class="mermaid">

---
config:
 theme: neo-dark
---
sequenceDiagram
    participant B as Browser
    participant U as Usuário
    participant S as Servidor API
    U->>B  : Usuário requisita formulário associado a url digita pelo usuário.
    B->>S  : O Browser pede para o servidor o formulário (envia a url passada pelo cliente).
    S-->>B : Formulário retornado para o browser
    U->>B  : Usuário Pressiona Botão Localizar
    B->>U  : Qual o Id do registro?
    U->>B  : Usuário retorna o número do registro
    B->>S  : Browser pede para o servidor localizar o registro número x.
    S-->>B : Servidor retorno o json com os campos do registro
    B->>U  : Browser retorna o formulário preenchido com os dados do servidor

</div></code></pre>

---

## Considerações

- Certifique-se de que o servidor REST API está configurado corretamente para lidar com requisições CORS, se necessário.
- A aplicação cliente deve validar os dados do formulário antes de enviá-los para o servidor.
- A resposta do servidor deve ser tratada para lidar com possíveis erros ou registros não encontrados.

### Explicação

 sequenceDiagram

- **Visão Geral**: Descreve o propósito do documento e as partes envolvidas.
- **Fluxo de Operação**: Detalha o processo passo a passo desde o acionamento do botão até a exibição dos resultados.
- **Diagramas**: Um diagrama de sequência Mermaid mostra a interação entre o cliente e o servidor.

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
