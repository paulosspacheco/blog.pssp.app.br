# <span id="topo"><span>O que é nvm <a href="o_que_e_nvm.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="o_que_e_nvm.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)
      5. [Documentação oficial](https://github.com/nvm-sh/nvm#table-of-contents)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Instalação do NVM (MacOS e Linux)](#id_assunto01)
      2. [Como usar NVM para instalar uma versão qualquer do nodejs](#id_assunto02)
         1. [Como instalar nodejs](#id_como_instalar_nodejs)
         2. [Como desinstalar nodejs](#id_como_desinstalar_nodejs)
         3. [Como selecionar uma versão qualquer do nodejs](#id_selecionar_versao_nodejs)
      3. [Desinstalação manual do NVM](#id_assunto03)
      4. [Assunto 04](#id_assunto04)
      5. [Assunto 05](#id_assunto05)
      6. [Assunto 06](#id_assunto06)
      7. [Assunto 07](#id_assunto07)
      8. [Assunto 08](#id_assunto08)
      9. [Assunto 09](#id_assunto09)
      10. [Assunto 10](#id_assunto10)

   4. [**Referências globais.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. Este documento contém anotações sobre o pacote [NVM](https://github.com/nvm-sh/nvm#about) usado para instalar várias versões do nodejs na pasta **/home/nomeDoUsuario/.nvm** com propósito de manter a compatibilidade dos pacotes criados até o momento em seu computador.
      2. Cada assunto anotado possui um link para referência estudada.
      3. O node instalado na pasta local, outros usuários não terão acesso.
      4. O comando **sudo** não será necessário ao instalar pacote **npm** com opção **-g**
      5. A documentação principal estudada está no site: <https://github.com/nvm-sh/nvm#node-version-manager--->

      6. <text onclick="goBack()">[🔙]</text>

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. [Node Version Manager (nvm)](https://nodejs.org/pt-br/download/package-manager/) é um script bash utilizado para gerenciar múltiplas versões do Node.js. Ele Permite que você instale, desinstale, mude de versão.

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Sistemas operacionais Linux e Mac OS X.

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Quando se usa a versão nodejs que vem na distribuição linux tive problema com projeto criados em versões anterior, ou seja pararam de funcionar.
         2. O **nvm** existe justamente para selecionar a versão adequada para cada projeto.
         3. Perdi muto tempo com o angular porque o comando **ng new nomeDoProjeto** não funcionava mais.

         4. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Precisa está configurando cada projeto para informar ao nvm a versão a ser usada.

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_assunto01></span>**Instalação do NVM (MacOS e Linux)**
         1. É recomendado desinstalar qualquer versão do Node.js presente em sua máquina antes de instalar o NVM para evitar colisões.
         2. Para instalar o [NVM](https://github.com/nvm-sh/nvm#installing-and-updating) basta usar o [**curl**](https://www.geeksforgeeks.org/curl-command-in-linux-with-examples/) para baixar o nvm a partir do repositório. [Veja mais...](https://github.com/nvm-sh/nvm#installing-and-updating)
            1. **Instalar nvm**

               ```sh
                  # O comando abaixo baixa a versão 0.38.0 do nvm. 
                  # É bom olhar o site do [nvm](https://github.com/nvm-sh/nvm#installing-and-updating) para checar a ultima versão.
                  
                  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

               ```

            2. **Notas:**
               1. O script acima clona o repositório nvm em **~/.nvm** e tenta adicionar as linhas de origem do fragmento abaixo ao arquivo de perfil correto (~/.bash_profile, ~/.zshrc, ~/.profile, or **~/.bashrc**).
               2. Notas Adicionais
                  1. Se a variável de ambiente **$XDG_CONFIG_HOME** estiver presente, ele colocará os arquivos nvm lá.

                  2. Você pode adicionar --no-use ao final do script acima (... nvm.sh --no-use) para adiar o uso do nvm até que você o use manualmente.

                  3. Você pode personalizar a fonte de instalação, diretório, perfil e versão usando as variáveis **NVM_SOURCE**, **NVM_DIR**, **PROFILE** e **NODE_VERSION**. Ex: **curl ... | NVM_DIR="path/to/nvm"**. Certifique-se de que o **NVM_DIR** não contenha uma barra final.

                  4. O instalador pode usar **git**, **curl** ou **wget** para baixar o nvm, o que estiver disponível.

               3. Solução de problemas no Linux mint
                  1. No Linux, depois de executar o script de instalação, feche seu terminal atual e abra um novo terminal, em seguida execute o comando abaixo para que o nvm fique público em qualquer pasta:
                     1. Código shellscript

                        ```sh

                           # Comando bash para atualizar o ambiente com as alterações realizada na instalação.

                           source ~/.bashrc  

                           # Teste para saber se está funcionando.
                           nvm --version

                        ```

               4. Ao usar o nvm, você não precisa do sudo para instalar globalmente um módulo com npm -g, então, em vez de fazer sudo npm install -g grunt, faça npm install -g grunt  
               Se você tiver um arquivo ~/.npmrc, certifique-se de que ele não contenha nenhuma configuração de prefixo (que não é compatível com nvm)  
               Você pode (mas não deve?) Manter a instalação anterior do node do "sistema", mas o nvm só estará disponível para sua conta de usuário (a que foi usada para instalar o nvm). Isso pode causar incompatibilidades de versão, pois outros usuários estarão usando /usr/local/lib/node_modules/* VS sua conta de usuário usando ~/.nvm/versions/node/vX.X.X/lib/node_modules/*.

         3. **Referências:**
            1. [Instalação do nvm](https://github.com/nvm-sh/nvm#installing-and-updating)
            2. [**curl**](https://www.geeksforgeeks.org/curl-command-in-linux-with-examples/)
            3. [Important Notes](https://github.com/nvm-sh/nvm#important-notes)

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_assunto02></span>**Como usar [NVM](https://github.com/nvm-sh/nvm#usage) para instalar uma versão qualquer do nodejs**:
         1. <span id=id_como_instalar_nodejs></span>**Como instalar nodejs**:
            1. Para instalar a última versão do nodejs

               ```sh

                  nvm install node # "node" é um apelido para a versão mais recente

               ```

            2. A primeira versão instalada se torna o padrão. Novos shells começarão com a versão padrão do node, porém se aparecer a mensagem abaixo execute o comando **nvm alias default nomeDaVersao**.

               ```sh

                  N/A: version "N/A -> N/A" is not yet installed.

                  You need to run "nvm install N/A" to install it before using it.

               ```

            3. Para baixar, compilar e instalar uma versão qualquer do node, faça o seguinte:
               1. Descubra o código da versão com o comando **nvm ls-remote**:

                  ```sh

                     # Lista todos as versões do repositório remoto.
                     nvm ls-remote 

                  ```

               2. O comando acima mostra o número de todas as versões disponíveis no repositório. Use este número para executar o comando abaixo:

                  ```sh

                     # Instalar uma versão específica do nodejs.
                     nvm install NúmeroDaVersão

                  ```

            4. Suponha que você queira instalar a [ultima versão LTS](https://github.com/nvm-sh/nvm#long-term-support) então:

                  ```sh

                     nvm install lts/*

                  ```

            5. <text onclick="goBack()">[🔙]</text>

         2. <scan id="id_como_desinstalar_nodejs"></scan>**Como desinstalar nodejs**
            1. Para desinstalar o nodejs é preciso saber o nome da versão a ser removida. Para saber o nome das versões instaladas use o comando **nvm ls**.
               1. Código shellScript

                  ```sh
                     # descobre o nome da versão:
                     nvm ls

                     # Como o nome da versão obtido na linha anterior execute o comando:
                     nvm uninstall nomeDaVersao 
                  ```

               2. .

            2. <text onclick="goBack()">[🔙]</text>

         3. <scan id="id_selecionar_versao_nodejs"></scan>**Como selecionar uma versão qualquer do nodejs**
            1. Selecionar a versão corrente no prompt:

               ```sh

                  nvm use node

               ```

            2. Selecionar a uma versão qualquer do nodejs no prompt:

               ```sh

                  # númeroDaVersão pode ser encontrada com o comando nvm ls
                  nvm use númeroDaVersão

               ```

            3. Selecionar uma versão usando arquivo [Arquivo oculto **.nvmrc**](https://github.com/nvm-sh/nvm#nvmrc) com o número da versão da pasta corrente.
               1. Exemplo:

                  ```sh
                     # Criar arquivo .nvmrc com a versão v16.5.0 na pasta corrente.
                     echo "v16.5.0" > .nvmrc 

                     # Criar arquivo .nvmrc com a ultima versão LTS na pasta corrente.
                     echo "lts/*" > .nvmrc 

                     # Criar arquivo .nvmrc com a ultima versão corrente padrão na pasta corrente.
                     echo "node" > .nvmrc 

                     # Para selecionar a versão usar comando:
                     nvm use
                  
                  ```

               2. ..
            4. <text onclick="goBack()">[🔙]</text>

         4. **Referências:**
            1. [Uso do NVM](https://github.com/nvm-sh/nvm#usage)
            2. [Instala a ultima versão LTS](https://github.com/nvm-sh/nvm#long-term-support)
            3. [Arquivo .nvmrc](https://github.com/nvm-sh/nvm#nvmrc)
            4. [title](link)
            5. [title](link)

         5. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_assunto03></span>**Desinstalação manual do NVM**

         1. Para [remover nvm](https://github.com/nvm-sh/nvm#manual-uninstall) manualmente, execute o seguinte:
            1. Código ShellScript

               ```sh
                  rm -rf "$NVM_DIR"
               ```

            2. Edite ~/.bashrc(ou outra configuração de recurso do shell) e remova as linhas abaixo:

               ```sh
                  export NVM_DIR="$HOME/.nvm" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
                  [[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion
               ```

         2. **Referências:**
            1. [Manual Uninstall](https://github.com/nvm-sh/nvm#manual-uninstall)
            2. ...

         3. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_assunto04></span>**Assunto 04**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 04**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      5. <span id=id_assunto05></span>**Assunto 05**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 05**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      6. <span id=id_assunto06></span>**Assunto 06**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 06**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_assunto07></span>**Assunto 07**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 07**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto08></span>**Assunto 08**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 08**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto09></span>**Assunto 09**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 09**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto10></span>**Assunto 10**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 10**.
             1. Descrição do exemplo

                  ```ts
                  ```

          3. **Referências:**
             1. [title](link)
             2. [title](link)

          4. <text onclick="goBack()">[🔙]</text>

      11. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](https://github.com/nvm-sh/nvm)
      2. [Instalando Node.js via gerenciador pacotes](https://nodejs.org/pt-br/download/package-manager/)
      3. [Instalação do nvm](https://github.com/nvm-sh/nvm#installing-and-updating)
      4. [#](##)
      5. [#](##)
      6. [#](##)

      7. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 15/07/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo03.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [x] Escrever tópico desvantagens
         - [x] Instalação do NVM (MacOS e Linux)

         - <text onclick="goBack()">[🔙]</text>

      2. 20/07/2021 <!--TODO: HISTÓRICO -->
         - [x] Escrever tópico como desinstalar NVM
         - [x] Escrever tópico Como usar NVM para instalar uma versão qualquer do nodejs
           - [x] Como instalar nodejs
           - [x] Como desinstalar o nodejs
           - [x] Como selecionar uma versão qualquer do nodejs
         - [ ] Escrever tópico resumo do documento.
         - [x] Escrever tópico Referências
         - [x] Atualizar o histórico deste documento.         

      3. 20/07/2021 <!--TODO: HISTÓRICO -->
         - [x] Ler documento e corrigir os erros encontrado.

      4. 23/07/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
