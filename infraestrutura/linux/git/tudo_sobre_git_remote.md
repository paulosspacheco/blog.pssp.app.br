<!-- markdownlint-disable-next-line -->
#### Tudo sobre git remoto <a href="listando_o_status_do_repositorio.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Para gerenciar comunicação de repositórios remotos, é necessário salvar no repositório local as referências para os repositórios remotos. Para fazer isso, existe o comando _git remote_.
   1. Suponha que o repositório remoto tenha de a URL _https://github.com/petcomputacaoufrgs/intro-ao-git.git_ e o nome _origin_, então:
      1. Para registrar na máquina local o repositório remoto usar o seguinte comando:

         ```bash

            git remote add origin https://github.com/petcomputacaoufrgs/intro-ao-git.git


         ```

      2. 
   2. ...
   3. ...
2. Use o comando **git status** para checar o estado atual do repositório.

    ```sh
        # A pasta ~/meuProjeto precisa ter sido inicializada pelo comando git init.
        cd ~/meuProjeto

        # Esse comando mostra tudo que precisa ser feito para atualizar o repositório.
        git status
        
    ```

3. **Referências:**
   1. [Status do repositório](https://githowto.com/pt-BR/checking_status)
   2. [Git Status: Inspecting a repository](https://www.atlassian.com/git/tutorials/inspecting-a-repository#:~:text=The%20git%20status%20command%20displays,regarding%20the%20committed%20project%20history.)
