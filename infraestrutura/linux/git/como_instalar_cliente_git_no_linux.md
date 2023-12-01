<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar cliente git no Linux Debian ou derivados <a href="como_instalar_cliente_git_no_linux.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Para instalar no Linux distribuição baseada em Debian como o Ubuntu, Linux Mint, etc use o apt-get:.

    ```bash
    
      # Atualiza sistema lista do apt-get
      sudo apt-get update

      # Instala o git 
      sudo apt-get install git-all
    ```

2. Execute os seguintes comandos para fazer com que o git saiba seu nome e endereço de e-mail:

    ```bash
      # Adicione o nome do usuário ao git instalado globalmente
      git config --global user.name "Seu Nome"

      # Adicione o e-mail do usuário do git instalado globalmente
      git config --global user.email "seu_email@qualquercoisa.com"

    ```

3. O git funcionando no Linux é preciso que os comandos abaixo sejam executado para indicar o término de linha nos arquivos textos:

    ```bash
      git config --global core.autocrlf input
      git config --global core.safecrlf warn
    ```

## REFERÊNCIAS

1. [1.5 Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. [8.1 Customizing Git - Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
3. [Configurar o Git para uso com delimitadores de linha](https://docs.github.com/pt/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")