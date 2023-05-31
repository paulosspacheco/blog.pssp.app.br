#### Configurando git para enviar para o github <a href="configurando_git_para_enviar_para_o_github.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Para [conectar-se ao github.com](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) é necessário criar um chave do protocolo SSH (Secure Shell Protocol), que fornece um canal seguro em uma rede não segura da seguinte forma:

    ```sh
        
        # Gerando uma chave ssh na pasta ~/ssh
        ssh-keygen -t ed25519 -C "seu_email@qualquercoisa.com"           

        # Adicionando sua chave SSH ao agente ssh
        eval "$(ssh-agent -s)"

        # Adicione sua chave privada SSH ao agente ssh. 
        # Se você criou sua chave com um nome diferente ou se está adicionando uma 
        # chave existente com um nome diferente, substitua id_ed25519 no comando 
        # pelo nome de seu arquivo de chave privada:

        ssh-add ~/.ssh/id_ed25519

    ```

   1. NOTAS:
      1. Se você estiver usando um sistema legado que não suporta o algoritmo Ed25519, use:

         ```sh

           ssh-keygen -t rsa -b 4096 -C "paulosspacheco"

         ```

      2. Dependendo do seu ambiente, pode ser necessário usar um comando diferente.
         1. Por exemplo, pode ser necessário usar o acesso root executando **sudo -s -H** antes de iniciar o **ssh-agent** ou pode ser necessário usar exec **ssh-agent bash** ou **exec ssh-agent zsh** para executar o **ssh-agent**.

      3. **REFERÊNCIAS**:
         1. [Requisitos de autenticação de token para operações Git](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/).
            1. [Criação de um token de acesso pessoal](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
            2. [Novo token de acesso pessoal](https://github.com/settings/tokens/new)

2. Entre no [github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) para adicionar uma nova chave SSH à sua conta GitHub.

3. Criando repositório no github e configurando a máquina cliente:
4. Suponha que o grupo seja **mi** e o projeto seja maricarai então:

   ```sh
   
      # criando uma pasta para os arquivos do git separado da pasta corrente que se deseja versionar
      git init --separate-git-dir ../maricarai.git 

      # Associa o repositório remoto ao repositório local.          
      git remote add origin git@github.com:paulosspacheco/maricarai.git

      # Cria um ramo para a versão     
        git branch -M main                           

      # Adiciona todos os arquivo da pasta que se quer versionar
      git add .        

      # Finaliza a transação do comando git add e registra o nome das alterações feitas       
      git commit -m "Descreva as alterações feitas"

      # Envia as alterações locais para o repositório remoto.
      git push -u origin main                  
      
      # Pull requests (Solicitações de pull) 

   ```

   1. **ATENÇÃO**
      1. [Lei sobre Pull Requests para finalizar o processo de atualização](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)
      2. [Como criar seu primeiro pull request no GitHub](https://m.youtube.com/watch?v=Du04jBWrv4A)

5. [Verificando as chaves SSH existentes](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)
6. Digite **ls -al ~/.ssh** para ver se as chaves SSH existentes estão presentes.

   ```shellScript
        
        $ ls -al ~/.ssh
        # Lists the files in your .ssh directory, if they exist
       
   ```

7. Verifique a lista de diretórios para ver se você já possui uma chave SSH pública. Por padrão, os nomes de arquivo das chaves públicas com suporte para o GitHub são um dos seguintes.
   1. ~/.ssh/id_rsa.pub
   2. ~/.ssh/id_ecdsa.pub
   3. ~/.ssh/id_ed25519.pub

8. [Copie a chave pública SSH gerada para a área de transferência.](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

9. Acesse o site [github](https://github.com/settings/keys) e cole a chave que está na área de transferência.

10. Comando para saber se a chave ssh está associada ao github:

   ```powershell

      git status

   ```

##### REFERÊNCIAS

1. [get-started](https://docs.github.com/en/get-started)
2. [Instalando o Git](https://git-scm.com/book/pt-br/v2/Come%C3%A7ando-Instalando-o-Git)
3. [Preparação](https://githowto.com/pt-BR/setup)
4. [Criando novo projeto no github](https://github.com/new)
5. [Novo token de acesso pessoal](https://github.com/settings/tokens/new)
6. [Como trabalhar com Git e GitHub no VsCode | Tutorial](https://www.youtube.com/watch?v=HIqyLRKv-YE)
7. [VsCode - [Extensão GitLens], Histórico do GITHUB, no vscode, commit, Linha do código editado (#201)](https://www.youtube.com/watch?v=MbgR1rIDuy4)
8. [Verificando as chaves SSH existentes](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)
9. [Configurando arquivos ignorados para todos os repositórios em seu computador](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files).
