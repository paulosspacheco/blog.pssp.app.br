<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Adicionando documento ao repositório <a href="adicionando_documento_ao_repositorio.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Siga os comandos abaixo para adicionar todo o conteúdo da pasta corrente  \*.\*  ao repositório git:

    ```bash
    
        # Move-se para o diretório onde ser deseja adicionar os documentos ao repositório
        cd ~/meuProjeto  

        # Caso não existe o repositório ainda, então é necessário inicializa-lo
        git init       
        
        # Adiciona todo o conteúdo alterado ou incluído ou excluído para o repositório
        git add --all # ou git add *.* ou git add . 
        
        # Confirma a alteração realizada pelo comando git add --all
        # Obs: A mensagem indicando o que foi alterado é obrigatória. 
        git commit -m "Primeiro repositório da pasta local" 
        
        # Renomeie o branch  atual para main
        # O comando branch -M não precisa ser feito a todo momento, porque o git sempre envia
        # para o último ramo selecionando.
        git branch -M main                                
    ```

2. **Referências:**
   1. [git init](https://www.atlassian.com/br/git/tutorials/setting-up-a-repository/git-init);
   2. [https://git-scm.com/docs/git/en](https://git-scm.com/docs/git/pt_BR);
   3. [git init](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-init#:~:text=The%20git%20init%20command%20creates,run%20in%20a%20new%20project.).
   4. [Adicionando modificações](https://githowto.com/pt-BR/staging_changes)
   5. [Exemplo de várias alterações e vários commits](https://githowto.com/pt-BR/changes_not_files)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")