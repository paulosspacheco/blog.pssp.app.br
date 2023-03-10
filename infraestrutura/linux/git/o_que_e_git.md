# <span id="topo"><span>O que é git? <a href="modelo03.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="modelo03.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)
      5. [Documento oficial do Git](https://git-scm.com/docs)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Instalando do git no linux derivados do debian](#id_assunto01)
      2. [Criando repositório git](#id_assunto02)
      3. [Adicionando documento ao repositório](#id_assunto03)
      4. [Listando o status do repositório](#id_assunto04)
      5. [Adicionando modificações ao repositório](#id_assunto05)
      6. [Ignorando arquivos no repositório git](#id_assunto06)
      7. [Configurando git para enviar para o **github**](#id_assunto07)
      8. [Clonando repositório no  github](#id_assunto08)
      9. [Verificando o status atual do projeto.](#id_assunto09)
      10. [Criando script para enviar as alterações para o github](#id_assunto10)
      11. [Voltando um commit do GIT](#id_assunto11)
      12. Documentar como funciona o **git Issues** (Registro de problemas)


   4. [**Referências globais.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. O projeto github permite publicar documentos na nuvem de forma gratuita deste que o documento possa ser compartilhado com o público e o arquivo não seja maior que 50 megas.
      2. **PASSO A PASSO**:
         1. [Instalar o git no desktop](#id_assunto01)
         2. [Criar um repositório no github](https://github.com/)
         3. [Clonando repositório no github](#id_assunto08)
         4. [Crie  o script **pushmain.sh** para enviar as alterações para o github](#id_assunto10)
         5. Copie os arquivo do projeto para a pasta do repositório clonado.
         6. Execute o script **pushmain.sh**
         7. [Verificando o status atual do projeto.](#id_assunto09)

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O git é um programa criado por **Linus Torvalds** cujo objetivo de controlar as versões de múltiplos documentos, podendo ser programas de computador ou outro documento qualquer digital.
         2. O objetivo principal é poder compartilhar as alterações criadas por vários programadores e um administrador fica responsável pelo merge de todas as versões para produzir uma versão única com todas as alterações.

         3. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Ter linux ou windows com uma versão acima de 2003 instalado..

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Espero poder controlar as versões dos produtos que forem produzidos de hoje em diante, bem como voltar no tempo caso seja necessário.

         2. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Não sei ainda....

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_assunto01></span>**Instalando git no linux e derivados do debian**
         1. Para instalar no linux distribuição baseada em Debian como o Ubuntu, Linux Mint, etc use o apt-get:.

               ```sh
                  sudo apt-get install git-all
               ```

         2. Execute os seguintes comandos para fazer com que o git saiba seu nome e endereço de e-mail:

               ```sh

                 git config --global user.name "Seu Nome"
                 git config --global user.email "seu_email@qualquercoisa.com"

               ```

         3. O git funcionando no linux é preciso que os comandos abaixo sejam executado para indicar o término de linha nos arquivos textos:

               ```sh

                  git config --global core.autocrlf input
                  git config --global core.safecrlf warn

               ```

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_assunto02></span>**Criando repositório git**
         1. Use o comando **git init** para criar o repositório na pasta atual.
            1. Exemplo:

               ```sh

                  git init
                  #Initialized empty Git repository in /Users/alex/Documents/Presentations/githowto/auto/hello/.git/

               ```

         2. Use o comando **git init** para criar o repositório na pasta diferente da pasta atual.
            1. Exemplo

               ```sh
                 
                cd ~/meuProjeto                 
                git init --separate-git-dir ~/meuProjeto.git

               ```

         3. **Referências:**
            1. [Crie um repositório](https://githowto.com/pt-BR/create_a_project)
            2. [Como mover/separar a pasta .git da sua árvore de trabalho](https://rakhesh.com/coding/how-to-move-separate-the-git-folder-out-of-your-working-tree/)

         4. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_assunto03></span>**Adicionando documento ao repositório local ou remoto se estiver configurado**
         1. Suponha você queira adicionar todo o conteúdo na pasta corrente  \*.\*  ao repositório então:
            1. Código shellscript

               ```sh
                  # Inicia um novo projeto git
                  git init 

                  # Este comando pode ser executado várias vezes antes de um commit. Ele apenas adiciona o conteúdo do(s) arquivo(s) especificado(s) no momento em que o comando add é executado; se quiser que as alterações subsequentes sejam incluídas no próximo commit, você deve executar git add novamente para adicionar o novo conteúdo ao índice.                

                  #Diga ao comando para preparar automaticamente os arquivos que foram modificados e excluídos, mas os novos arquivos sobre os quais você não informou o Git não são afetados.
                  git add --all ou git add *.* ou git add . 

                  # Use o <msg> fornecido como a mensagem de confirmação. 
                  git commit -m "Primeiro repositório da pasta local" 

                  # Renomeie o branch  atual para main
                  # O comando branch -M não precisa ser feito a todo momento, porque o git sempre envia para
                  # o ultimo ramo selecionando.
                  git branch -M main                                

               ```

         2. **Referências:**
            1. [git init](https://www.atlassian.com/br/git/tutorials/setting-up-a-repository/git-init)
            2. [https://git-scm.com/docs/git/en](https://git-scm.com/docs/git/pt_BR)
            3. [git init](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-init#:~:text=The%20git%20init%20command%20creates,run%20in%20a%20new%20project.)

         3. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_assunto04></span>**Listando o status do repositório**
         1. Use o comando **git status** para checar o estado atual do repositório.
            1. Código shell

               ```sh
                  cd /testGit # A pasta /testGit precisa ter executado o comando git init antes de saber o status

                  git status

                  # Resultado: On branch main nothing to commit (working directory clean)

               ```

         2. **Referências:**
            1. [Status do repositório](https://githowto.com/pt-BR/checking_status)

         3. <text onclick="goBack()">[🔙]</text>

      5. <span id=id_assunto05></span>**Adicionando modificações ao repositório**
         1. Altere qualquer coisa no arquivo **index.html**, em seguida execute os comandos abaixo:
            1. Código ShellScript

               ```sh
                  # Adicionando o arquivo modificado ao repositório
                  git add .

                  # Obtendo o status atual do repositório
                  git status

                  # Tornando a alteração definitiva:
                  git commit -a -m "Alterado o título de index.html"
          

               ```

         2. **Referências:**
            1. [Adicionando modificações](https://githowto.com/pt-BR/staging_changes)
            2. [Exemplo de várias alterações e vários commits](https://githowto.com/pt-BR/changes_not_files)

         3. <text onclick="goBack()">[🔙]</text>

      6. <span id=id_assunto06></span>**Ignorando arquivos no repositório git**
         1. Você pode criar um arquivo [**.gitignore**](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files) no diretório raiz do seu repositório para informar ao **Git** quais arquivos e diretórios ignorar ao fazer um commit. Para compartilhar as regras de ignorar com outros usuários que clonam o repositório, envie o arquivo **.gitignore** para o seu repositório.
         2. Exemplo de arquivo **.gitignore**.
            1. .gitignore

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

         3. **Referências:**
            1. [Configurando arquivos ignorados para um único repositório](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files)
            2. [Uma coleção de **.gitignore** modelos](https://github.com/github/gitignore)

         4. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_assunto07></span>**Configurando git para enviar para o github**
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

            1. NOTA:
               1. Se você estiver usando um sistema legado que não suporta o algoritmo Ed25519, use:

                  ```sh

                    ssh-keygen -t rsa -b 4096 -C "paulosspacheco"

                  ```

               2. Dependendo do seu ambiente, pode ser necessário usar um comando diferente.
                  1. Por exemplo, pode ser necessário usar o acesso root executando **sudo -s -H** antes de iniciar o **ssh-agent** ou pode ser necessário usar exec **ssh-agent bash** ou **exec ssh-agent zsh** para executar o **ssh-agent**.
               3. **ATENÇÃO**:
                  1. [Requisitos de autenticação de token para operações Git](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/).
                     1. [Criação de um token de acesso pessoal](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
                     2. [Novo token de acesso pessoal](https://github.com/settings/tokens/new)

         2. Entre no [github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) para adicionar uma nova chave SSH à sua conta GitHub.

         3. Criando repositório no github e configurando a máquina cliente:
            1. Suponha que o grupo seja **mi** e o projeto seja maricarai então:

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

         4. [Verificando as chaves SSH existentes](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)
            1. Digite **ls -al ~/.ssh** para ver se as chaves SSH existentes estão presentes.

               ```shellScript
                    
                    $ ls -al ~/.ssh
                    # Lists the files in your .ssh directory, if they exist
                   
               ```

            2. Verifique a lista de diretórios para ver se você já possui uma chave SSH pública. Por padrão, os nomes de arquivo das chaves públicas com suporte para o GitHub são um dos seguintes.
               1. ~/.ssh/id_rsa.pub
               2. ~/.ssh/id_ecdsa.pub
               3. ~/.ssh/id_ed25519.pub

            3. [Copie a chave pública SSH gerada para a área de transferência.](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

            4. Acesse o site [github](https://github.com/settings/keys) e cole a chave que está na área de transferência.

            5. Comando para saber se a chave ssh está associada ao github:

               ```powershell

                  git status

               ```

            6. ...

         5. **Referências:**
            1. [get-started](https://docs.github.com/en/get-started)
            2. [Instalando o Git](https://git-scm.com/book/pt-br/v2/Come%C3%A7ando-Instalando-o-Git)
            3. [Preparação](https://githowto.com/pt-BR/setup)
            4. [Criando novo projeto no github](https://github.com/new)
            5. [Novo token de acesso pessoal](https://github.com/settings/tokens/new)
            6. [Como trabalhar com Git e GitHub no VsCode | Tutorial](https://www.youtube.com/watch?v=HIqyLRKv-YE)
            7. [VsCode - [Extensão GitLens], Histórico do GITHUB, no vscode, commit, Linha do código editado (#201)](https://www.youtube.com/watch?v=MbgR1rIDuy4)
            8. [Verificando as chaves SSH existentes](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)
            9. [Configurando arquivos ignorados para todos os repositórios em seu computador](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files).

         6. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto08></span>**Clonando repositório no  github**
         1. **Eureca!!!** a forma mais prática que encontrei para usar o github e vscode foi:
            1. No vscode instalei a extensão [**GitLens — Git supercharged**](https://learn.microsoft.com/pt-br/shows/vs-code-livestreams/10-things-about-gitlens)
               1. Essa extensão habilita o vscode a reconhecer o repositório remoto.

            2. Entre no github e crie um repositório;

            3. Na pasta do projeto clone o repositório clonado com o seguinte comando:

                ```shellScript
                   
                   git clone git@github.com:paulosspacheco/maricarai.git
                   cd ./maricarai
                   code .
                   
                ```

               1. ..

            4. Adicione os arquivos do projeto na pasta clonada.

            5. Execute o script [**pushmain.sh**](./pushmain.sh)

            6. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto09></span>**Verificando o status atual do projeto.**
          1. O git status comando exibe o estado do diretório de trabalho e da área de preparação. Ele permite que você veja quais alterações foram testadas, quais não foram e quais arquivos não estão sendo rastreados pelo Git. A saída de status não mostra nenhuma informação sobre o histórico do projeto confirmado. Para isso, você precisa usar o comando  **git log**
             1. Exemplo de  uso:

              ```shellScript

                # Na pasta do repositório executar comando:  
                git status
             
               ```

          2. Exemplo do comando **status** atual do projeto..

          3. **Referências:**
             1. [Git Status: inspecionando um repositório](https://www.atlassian.com/git/tutorials/inspecting-a-repository#:~:text=The%20git%20status%20command%20displays,regarding%20the%20committed%20project%20history.)
          4. [title](link)

          5. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto10></span>**Criando script para enviar as alterações para o github**
          1. Criar um arquivo **pushmain.sh** e cole os comandos a baixo, em seguida de permissão de execução ao arquivo **pushmain.sh**:

            ```shellScript
               
                #!/bin/bash
                
                # Esse é um parâmetro passado com a descrição do commit
                TextoCommit="$1"  
                
                # Associa o repositório remoto ao repositório local.          
                   git remote add origin git@github.com:paulosspacheco/maricarai.git
                
                # Renomeie o branch  atual para main
                # O comando branch -M não precisa ser feito a todo momento, porque o git sempre envia para
                # o ultimo ramo selecionando.
                   git branch -M main  
                
                # Este comando pode ser executado várias vezes antes de um commit.  
                   git add .
                
                # Use o <msg> fornecido como a mensagem de confirmação. 
                   git commit -a -m "$TextoCommit"
                
                # Envia as alterações locais para o repositório remoto.
                   git push -u origin main                  
                
                # imprime o status atual do repositório
                git status  
            
            
            ```

      11. <span id=id_assunto11></span> **Voltando um commit do GIT**:
          1. O comando abaixo irá desfazer o último commit, colocando todos os arquivos do commit em unstaged changes:
             1. Exemplo de código shellScript:

             ```powershell

               git reset HEAD~1
             
             ```

          2. REFERÊNCIAS
             1. [Git Reset](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset#:~:text=To%20review%2C%20git%20reset%20is,correspond%20to%20the%20three%20trees.)

             2. [Como desfazer o último commit usando o comando Git Reset](https://builtin.com/software-engineering-perspectives/git-reset-soft-head)

      12. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](#1)
      2. [Guia básico de Markdown](https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open)
      3. [Vídeo aula sobre o github](https://www.youtube.com/watch?v=UbJLOn1PAKw&t=5s)
      4. [Git e GitHub - Instalação, Configuração e Primeiros Passos](https://balta.io/blog/git-github-primeiros-passos#requisitos)
      5. [Voltando um commit do GIT](http://www.basef.com.br/index.php/Voltando_um_commit_do_GIT)
      6. [Aprenda GitLab](https://gitlab.com/itms3/learn-gitlab/-/learn_gitlab)
      7. [ COMO USAR O GIT E O GITLAB NA PRÁTICA](https://www.youtube.com/watch?v=un8CDE8qOR8&t=38s)
      8. [Markdown com sabor do GitLab](https://docs.gitlab.com/ee/user/markdown.html)

      9. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. dd/mm/2021 <!--TODO: HISTÓRICO -->

         - <text onclick="goBack()">[🔙]</text>

      2. dd/mm/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Criar este documento baseado no modelo03.md ;
         - [ ] Escrever tópico Objetivos;
         - [ ] Escrever tópico Pre-requisitos
         - [ ] Escrever tópico Benefícios
         - [ ] Escrever tópico desvantagens
         - [ ] Escrever tópico Conteúdo
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
