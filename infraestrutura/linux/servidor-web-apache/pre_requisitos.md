<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Pre-requisito para instalar o servidor web apache2

1. Sistema operacional Linux ou  windows instalado;
2. Comunicação com a internet;
3. Direitos de [root](https://www.ssh.com/academy/pam/root-user-account#what-is-a-root-user?) ao sistema operacional;
4. Noções básicas de redes de computadores;
5. Noções básicas de Linux em linha de comando (Gerenciamento de diretórios e arquivos);
6. Saber usar um editor de texto qualquer;
7. Espaço em disco necessário:
   1. Para os programas:
      - 20 MG
   2. Para os sites:
      - Depende do tamanho dos sites.

8. Para que o site fica disponível ao público é necessário instalar e configurar o servidor de DNS [bind9](https://wiki.debian.org/Bind9);

9. Opcional:
   1. Abrir a porta _tcp:80_ e permitir tráfego http, caso queira tráfego _HTTPS_ a porta _tcp:443_ deve ser aberta. Se quiser abrir portas diferentes, configure o firewall, depois configure o Apache para usar o firewall.

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")