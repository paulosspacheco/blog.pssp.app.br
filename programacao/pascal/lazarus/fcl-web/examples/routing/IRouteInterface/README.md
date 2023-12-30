<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Exemplo de servidor http escrito em Lazarus

- Esta demonstração demonstra o mecanismo de roteamento do fpWeb.
- Ele pode ser executado como um CGI ou como um programa de servidor HTTP independente.
- Para obter um conjunto correto de rotas na demonstração, usamos o arquivo demo routing.ini deve ser configurado corretamente e colocado próximo ao binário.
- Existe uma seção diferente para cada tipo de binário: (CGI ou Standalone).
- Cada seção precisa de pelo menos a chave _BaseURL_, esta é a _URL_ onde o aplicativo pode ser alcançado.
- Example:

  ```init
    ; arquivo sample.ini

    [CGI]
    ; Assuming the demo is in cgi-bin
    BaseURL=http://localhost/cgi-bin/demorouting.cgi

    [Standalone]
    Port=8080
    ; Optional, the following is the default.
    ;BaseURL=http://localhost:8080/

  ```

</main>

[🔝🔝](#topo "Retorna ao topo")