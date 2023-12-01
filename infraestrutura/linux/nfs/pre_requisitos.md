<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Pre-requisitos para instalar o serviço NFS

1. Linux Debian ou distribuições derivadas.
2. Para servidores que suportam conexões NFSv2 ou NFSv3, o serviço rpcbind deve estar em execução. Para verificar se rpcbind está ativo, use o seguinte comando:

    ```sh
       # Checa o status do serviço 
       systemctl status rpcbind

    ```

3. Caso a máquina que está no servidor esteja por traz de um firewall atente-se para configurar a porta do serviço NFS.

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")