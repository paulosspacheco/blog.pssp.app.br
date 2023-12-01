<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Ignorando arquivos ao enviar para o repositório git <a href="ignorando_arquivos_ao_enviar_para_o_repositorio_git.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Você pode criar um arquivo [.gitignore](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files) no diretório raiz do seu repositório para informar ao **Git** quais arquivos e diretórios ignorar ao fazer um commit. Para compartilhar as regras de ignorar com outros usuários que clonam o repositório, envie o arquivo **.gitignore** para o seu repositório.
   1. Exemplo de conteúdo de um arquivo **.gitignore**.

      ```sh
         # Compiled source #
         ###################
         *.com
         *.class
         *.dll
         *.exe
         *.o
         *.so   
         *.ppu
         *.bak
         *.compiled
                     
      ```

1. **Referências:**
   1. [Configurando arquivos ignorados para um único repositório](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files)
   1. [Uma coleção de **.gitignore** modelos](https://github.com/github/gitignore)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")