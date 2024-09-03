<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# VERBOS OU MÉTODOS HTTP

## Os verbos HTTP, também conhecidos como métodos HTTP, são comandos que indicam a ação desejada a ser realizada em um recurso na web. Aqui estão os principais verbos HTTP

1. _GET_: Solicita a recuperação de um recurso. Não deve alterar o estado do servidor, sendo considerado um método seguro e idempotente.

2. _POST_: Envia dados ao servidor para criar ou modificar um recurso. É utilizado principalmente para enviar formulários ou dados de uma aplicação para o servidor.

3. _PUT_: Atualiza ou cria um recurso em uma URL específica. É idempotente, o que significa que várias requisições PUT com os mesmos dados não devem alterar o estado do recurso além da primeira requisição.

4. _DELETE_: Remove um recurso identificado pela URL. Como PUT, é idempotente.

5. _PATCH_: Aplica modificações parciais a um recurso. Diferente do PUT, que substitui o recurso completo, o PATCH altera apenas os campos fornecidos.

6. _HEAD_: Solicita as mesmas informações que o GET, mas sem o corpo da resposta. É utilizado para obter metadados, como cabeçalhos HTTP.

7. _OPTIONS_: Retorna os métodos HTTP suportados por um recurso. Útil para verificar quais operações são permitidas em um endpoint.

8. _TRACE_: Realiza um loopback de uma mensagem de solicitação para fins de teste e diagnóstico, retornando a requisição ao cliente.

9. _CONNECT_: Estabelece um túnel para o servidor identificado pela URL de destino. É usado principalmente para conectar o cliente a um servidor proxy, especialmente para comunicações seguras via HTTPS.

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")