<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Tudo sobre git remoto <a href="listando_o_status_do_repositorio.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Para gerenciar comunicação de repositórios remotos, é necessário salvar no repositório local as referências para os repositórios remotos. Para fazer isso, existe o comando _git remote_.

2. Suponha que o repositório remoto tenha a URL _https://github.com/petcomputacaoufrgs/intro-ao-git.git_ e o nome _origin_, então:
   1. Comando para registrar na máquina local um repositório remoto:
      1. Sintaxe: git remote add origin git@ip_server:/home/git/repositório.git

         ```bash
            # Exemplos 

            # Repositório na rede local: ip=192.168.15.3
            git remote add origin git@192.168.15.3:/home/git/teste.git
           
            # Repositório no github 
            # No github a url é: git@github.com:Usuário/NomeDoRepositório.git
            git remote add origin git@github.com:paulosspacheco/blog.pssp.app.br.git

         ```

3. Use o comando **git status** para checar o estado atual do repositório.

    ```sh
        # A pasta ~/meuProjeto precisa ter sido inicializada pelo comando git init.
        cd ~/meuProjeto

        # Esse comando mostra tudo que precisa ser feito para atualizar o repositório.
        git status
        
    ```

4. **Referências:**
   1. [Status do repositório](https://githowto.com/pt-BR/checking_status)
   2. [Git Status: Inspecting a repository](https://www.atlassian.com/git/tutorials/inspecting-a-repository#:~:text=The%20git%20status%20command%20displays,regarding%20the%20committed%20project%20history.)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")