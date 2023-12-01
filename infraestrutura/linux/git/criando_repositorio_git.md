<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Criando repositório git <a href="criando_repositorio_git.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Use o comando **git init** para criar o repositório na pasta atual.

    ```sh
       # Mova-se para a pasta que deseja adicionar o git.
       cd ~/meuProjeto   

       # Inicializa a pasta ~/meuProjeto para que aceite comandos do git onde o 
       # repositório é criado dentro da pasta cd ~/meuProjeto   
       git init
        
    ```

2. Use o comando **git init** para criar o repositório na pasta diferente da pasta atual.

    ```sh

       # Mova-se para a pasta que deseja adicionar o git.
       cd ~/meuProjeto 

       # Inicializa a pasta ~/meuProjeto para que aceite comandos do git onde o 
       # repositório é criado fora da pasta cd ~/meuProjeto e dentro da pasta 
       # ~/meuProjeto.git
       git init --separate-git-dir ~/meuProjeto.git

    ```

3. **Referências:**
   1. [Crie um repositório](https://githowto.com/pt-BR/create_a_project)
   2. [Como mover/separar a pasta .git da sua árvore de trabalho](https://rakhesh.com/coding/how-to-move-separate-the-git-folder-out-of-your-working-tree/)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")