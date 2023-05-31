# <span id="topo"><span>INSTALAR E CONFIGURAR O NODEJS <a href="instalar.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. INDEX**

   <span id="topo_Objetivo"><span>
   1. [Objetivo deste documento](#id_objetivo).
   2. [Pre-requisitos para compreensão deste documento](#id_pre_requisitos).
   3. [Os benefícios que este documento pode me trazer](#id_beneficios).

   4. [Como instalar nodejs no Linux](#id_instalar_nodejs_no_linux)
      1. [Instalar usando a versão da distribuição linux debian ou derivados](#id_instalar_nodejs_no_linux_1).
      2. [Instalar a versão de distribuição do site github](#id_instalar_nodejs_no_linux_2).

   5. [Instalar extensões vscode para nodejs](#id_extensoes)

   6. [Referências](#id_referencias)
   7. [Histórico](#id_historico)

2. CONTEÚDO
   1. <span id="id_objetivo"><span>Objetivos.
      1. Ensinar como instalar nodejs usado o pacote da distribuição debian;
      2. Ensinar como instalar nodejs usado o pacote da distribuição de github;  
      3. Relacionar as extensões do vscode necessárias para trabalhar com nodejs;
      4. [🔝](#topo_Objetivo "Retorna ao topo")

   2. <span id="id_pre_requisitos"></span>Pre-requisitos:
      1. Sistema operacional debian ou seus derivados;
      2. IDE vscode na microsoft;
      3. Familiaridade com javascript para testar os exemplos de conexão com banco de dados;
      4. [🔝](#topo_Objetivo "Retorna ao topo")

   3. <span id="id_beneficios"></span>Benefícios deste documento:
      1. Permitir criação de aplicativo back-end para construção de sites.
      2. [🔝](#topo_Objetivo "Retorna ao topo")

   4. [🔝](#topo_Objetivo "Retorna ao topo")

   5. <span id="id_instalar_nodejs_no_linux"></span>**Instalar pacote node js no Linux**.
      1. [Dependências do node js](https://nodejs.org/en/docs/meta/topics/dependencies/)

      2. <span id='id_instalar_nodejs_no_linux_1'></span>[_**Instalar usando a versão da distribuição linux debian ou derivados**_.]
         1. [Biblioteca c libuv1](https://github.com/libuv/libuv)

            ```sh

               sudo apt install libuv1

            ```

         2. Instalar o nodejs:

            ```sh
             
               sudo apt install nodejs
               # obs: O pacote nodejs contém os binários node e npm.
            ```

         3. Instalar a documentação:

            ```sh

               sudo apt install nodejs-doc 

            ```

         4. Instalar o pacote [**npm**](https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm/). Nota: **npm** são duas coisas: em primeiro lugar, é um [repositório online](https://www.npmjs.com/) para a publicação de projetos Node.js de código aberto; em segundo lugar, é um utilitário de linha de comando para interagir com o referido repositório que auxilia na instalação do pacote, gerenciamento de versão e gerenciamento de dependência.
            1. Código shellscript

               ```shellscript

                  sudo apt install npm

               ```

            2. <text onclick="goBack()">[🔙]</text>

      3. Como instalar pacotes via npm:
         1. Instalar pacotes no projeto atual. Dica...: [link para config npm](https://docs.npmjs.com/cli/v7/using-npm/config)

            ```sh

              npm install package

            ```

         2. Como instalar pacotes npm globalmente:

            ```sh
               npm install -g package
            ```

         3. Notas:
            1. Por padrão, o comando _npm install package_ simplesmente instala um pacote em _node_modules_. Ao tentar instalar dependências para seu aplicativo _/_ módulo, você precisa primeiro instalá-las e, em seguida, adicioná-las à seção _dependencies_ de seu package.json*.
            2. _--save-dev_ adiciona o pacote de terceiros a seção _devDependencies_ (dependências de desenvolvimento) do pacote. Ele não será instalado quando alguém executar _npm install package_ diretamente para instalar seu pacote. Normalmente, ele só é instalado se alguém clonar seu repositório de origem primeiro e depois executá npm install-lo.
            3. _--save_ adiciona o pacote a seção _dependencies_ (dependências de terceiros) do pacote. Ele será instalado junto com o pacote sempre que alguém o executar _npm install package_.
            4. _Dependências de desenvolvimento_ são aquelas dependências necessárias apenas para o desenvolvimento do pacote. Isso pode incluir executores de teste, compiladores, empacotadores, etc. Ambos os tipos de dependências são armazenados no _package.js_ no arquivo de pacote. _--save_ adiciona a dependencies, _--save-dev_ adiciona a devDependencies.
            5. A documentação de instalação do npm pode ser [consultada aqui](https://docs.npmjs.com/cli/v6/commands/npm-install).
            6. **ATENÇÃO**: O flag _--save_ agora é a opção padrão, desde o NPM 5. Portanto, não é mais explicitamente necessário. É possível executar _npm install package_ sem o _--save_ para obter o mesmo resultado.

      4. [Instalar eslint](https://eslint.org/) (ESLint analisa estaticamente seu código para encontrar problemas rapidamente)

         ```sh

            npm install eslint  

         ```

      5. [Instalar nodemon](https://nodemon.io/) (Os projetos executados com _nodemon_ é recarregado toda vêz que é modificado em disco e só deve ser usado caso não se use o vscode com opção de debug).

         ```sh

            sudo npm install -g nodemon

         ```

      6. [Instalar sequelize](https://sequelize.org/master/manual/getting-started.html) (Sequelize é um Node.js ORM baseado em promessa para Postgre , MySQL , MariaDB , SQLite e Microsoft SQL Server . Ele oferece suporte a transações sólidas, relações, carregamento rápido e lento, replicação de leitura e muito mais)
         1. [Documentação da classe sequelize:](https://sequelize.org/master/class/lib/sequelize.js~Sequelize.html).
         2. Criar pasta do projeto de banco de dados nodejs (Obs: Não pode ser dentro de um link do linux)

            ```sh
            
               mkdir NodeSequelize
               cd NodeSequelize
            
               
            ```

         3. Iniciar projeto nodejs na pasta NodeSequelize

            ```sh

               npm init 
               # Obs: Se neste momento não solicitar os parâmetros básicos do pacote package.json algo está errado.

            ```

         4. Instalar pacote principal _sequelize_ dentro da pasta _NodeSequelize_:

            ```sh

               sudo npm install sequelize

            ```

         5. Na pasta _NodeSequelize_, instalar pacote que permite _sequelize_ reconheça o [banco de dados mariadb](https://sequelize.org/master/manual/getting-started.html):

            ```sh

               sudo npm install mariadb  
               # Obs: se quiser instalar globalmente isar o paramento -g

            ```

         6. Opcionalmente pode-se instalar pacote [Sequelize CLI (Command Line Interface)](https://levelup.gitconnected.com/creating-sequelize-associations-with-the-sequelize-cli-tool-d83caa902233) caso queira acessar o banco de dados pelo terminal do linux:

            ```sh
            
               npm install --save-dev sequelize-cli 

            ```

            1. Notas:
               1. O flag _--save-dev_ registra em _package.json_ as dependência no desenvolvimento  (_devDependencies_).
               2. O comando  sequelize-cli é usado para manipular o banco de dados a partir do prompt do linux, porém não vejo necessidade de instalar porque uso o [mysql workbench](https://www.mysql.com/products/workbench/) faz essa tarefa com mais facilidade.

         7. [Teste conexão mariadb passando um string](https://sequelize.org/master/manual/getting-started.html#testing-the-connection)

            ```javascript
            /**
             * Conectando-se a um banco de dados.
            * O exemplo abaixo é a forma mais simples para conectar-se a um 
            * banco de dados com o módulo Sequelize.
            */
               // Importando a class  Sequelize 
               const { Sequelize } = require('sequelize');

               // Criar o objeto sequelize passando como parâmetro um string de conexão.
               const sequelize = new Sequelize('mariadb://root:password@192.168.15.3:3306/mysql');
               
               /**
                * Testando a conexão
               * Você pode usar a .authenticate() função para testar se a conexão está OK:
               */
               sequelize.authenticate().then(
                  //Essa função será executada se o banco de dados está conectado
                  function () {
                     console.log('A conexão foi estabelecida com sucesso.');
                  }
               ).catch(
                  //Esta função é executada se o banco de dados não for conectado.
                  function (error) {
                     console.error('Não foi possível conectar à base de dados::', error);
                  }
               );

               /**
                * Fechando a conexão
               * Sequelize manterá a conexão aberta por padrão e usará a mesma 
               * conexão para todas as consultas. Se você precisar fechar a conexão, ligue 
               * sequelize.close(). (Obs: O método sequelize.close()  é assíncrona e retorna uma Promessa).
               * 
               */

               sequelize.close().then();
                  
            ```

         8. [Teste conexão mariadb passando um objeto json](https://sequelize.org/master/manual/getting-started.html#testing-the-connection)

            ```javascript
               /**
               * Exemplo de como conectar-se ao banco de dados mariadb.
               * 
               * O construtor Sequelize aceita várias opções de constructor. 
               * Eles estão documentados na [Referência da API](https://sequelize.org/master/class/lib/sequelize.js~Sequelize.html#instance-constructor-constructor) .
               * 
               */
               const
                  Sequelize = require('sequelize');

               /**
               * Cria objeto connection para conecta-ser ao mariadb.
               * https://sequelize.org/v5/manual/dialects.html
               * A seguir criamos uma nova instância do Sequelize usando o seu construtor que 
               * possui a seguinte sintaxe:
               *    conexao = new Sequelize(database, [username=null], [password=null], [options={}])
               *       onde :
               *              1. database: é o nome do schema do banco de dados que vamos acessar. 
               *                           No nosso exemplo usamos o schema mac_demo criado no MySQL;
               *              2. username: é o nome do usuário de acesso ao MySQL, no exemplo estou 
               *                           usando o usuário root;
               *              3. password: é senha do usuário root. Para o exemplo estou usando a 
               *                           senha do usuário root;
               *              4. [options={}] = {host: '192.168.15.3',port: '3306',dialect: 'mariadb'}
               * */
               const
                  connection = new Sequelize('mysql', 'root', 'password',
                                             { host: '192.168.15.3', port: '3306', dialect: 'mariadb' });

               /**
               * TESTE DA CONEXÃO
               * Conecta-se ao banco de dados mariadb com autenticação.
               * 
               */
                  var conexao = connection.authenticate().then(
                     function () { console.log('A conexão foi estabelecida com sucesso.'); }
                  ).catch(
                     function () { console.error('Não foi possível conectar à base de dados::', error); }
                  );


               /**
               * Fechando a conexão
               * 
               * Sequelize manterá a conexão aberta por padrão e usará a mesma 
               * conexão para todas as consultas. Se você precisar fechar a conexão, 
               * ligue sequelize.close()(Obs: O método sequelize.close é assíncrona e retorna uma Promessa).
               * 
               */

               //sequelize.close();
                  
            ```

         9. [🔝](#topo_Objetivo "Retorna ao topo")

      7. <span id='id_instalar_nodejs_no_linux_2'></span>_**Instalar a versão de distribuição do site github**_:

         1. [Instruções de instalação no ubuntu](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
            1. Registra o repositório com a versão 15.x

               ```sh
               
                  curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash - 

               ```

            2. Atualizar lista do repositório

               ```sh
               
                  sudo apt update 

               ```

            3. Atualizar todos os programas da distribuição

               ```sh

                 sudo apt upgrade

               ```  

            4. Instalar nodejs

               ```sh
               
                  sudo apt-get install -y nodejs  

               ```

            5. Instalar a documentação:

               ```sh
               
                  apt install nodejs-doc

               ```

            6. Instalar o gerenciador de pacotes:

               ```sh

                  sudo apt install npm 

               ```

            7. [Instalar eslint](https://eslint.org/)

               ```sh

                  npm install eslint

               ```

            8. [Acesso a dados com pacote sequelize.org](https://sequelize.org/)

               ```sh

                  npm install --save sequelize

               ```

            9. [Acesso a dados com pacote sequelize.org](https://sequelize.org/)

               ```sh

                  npm install --save mariadb

               ```

            10. [Express Framework web rápido, flexível e minimalista para Node.js](https://expressjs.com/pt-br/)

                ```sh
                
                   npm install express --save

                ```

            11. Framework LoopBack:
                1. [LoopBack 4 CLI](https://loopback.io/doc/en/lb4/Getting-started.html#install-loopback-4-cli)
                2. [LoopBack](https://loopback.io/doc/en/lb4/#:~:text=LoopBack%20is%20a%20highly%20extensible,and%20SOAP%20or%20REST%20services.) é uma estrutura Node.js e TypeScript premiada , altamente extensível e de código aberto baseada no Express. Ele permite que você crie rapidamente APIs e micros serviços compostos de sistemas de back-end, como bancos de dados e serviços SOAP ou REST.
                3. [Getting-started.html](https://loopback.io/doc/en/lb4/Getting-started.html)

         2. [🔝](#topo_Objetivo Retorna ao topo)

  1. <span id='id_extensoes'></span>**Instalar extensões vscode para nodejs**.

      1. [**AutoFileName**](https://marketplace.visualstudio.com/items?itemName=JerryHong.autofilename):
         1. Ajuda a encontrar o nome completo do arquivo automaticamente.
      2. [**Node.js Modules Intellisense**](https://marketplace.visualstudio.com/items?itemName=leizongmin.node-module-intellisense):
         1. Autocompletes módulos Node.js em declarações de importação.
         2. Implementa autocomplete em módulos JavaScript / TypeScript em instruções de importação.
      3. [**Live Serve**](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
         1. Servidor web para teste de páginas html.
      4. [**Beautify json**](https://marketplace.visualstudio.com/items?itemName=HookyQR.beautify)
         1. Enfeitar JSON.
      5. [**Fix JSON**](https://marketplace.visualstudio.com/items?itemName=oliversturm.fix-json)
         1. Corrija o conteúdo JSON usando [jsonic](http://jsonic.net/index.html)
      6. [**Node.js Extension Pack**](https://marketplace.visualstudio.com/items?itemName=waderyan.nodejs-extension-pack "https://marketplace.visualstudio.com/items?itemName=waderyan.nodejs-extension-pack")
         1. [vscode-eslint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
            1. A extensão usa a biblioteca ESLint instalada na pasta da área de trabalho aberta. Se a pasta não fornecer um, a extensão procurará uma versão de instalação global.
         2. [npm support for VS Code](https://marketplace.visualstudio.com/items?itemName=eg2.vscode-npm-script).
            1. Esta extensão oferece suporte à execução de scripts npm definidos no package.json arquivo e à validação dos módulos instalados em relação às dependências definidas no package.json.
         3. [JavaScript (ES6) code snippets](https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets)
            1. Esta extensão contém trechos de código para JavaScript na sintaxe ES6 para o editor de código Vs (suporta JavaScript e TypeScript).
         4. [Search node_modules](https://marketplace.visualstudio.com/items?itemName=jasonnutter.search-node-modules "Pesquise rapidamente por módulos de nó em seu projeto." ).
            1. Navegue rapidamente e abra arquivos node_modules percorrendo a árvore de pastas.
         5. [npm Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense):
            1. Plug-in de código do Visual Studio que autocompleta módulos npm em instruções de importação.
         6. [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)
            1. Plug-in de código do Visual Studio que preenche automaticamente nomes de arquivos.
         7. Programa para reiniciar servidor nodejs se o código fonte for trocado
            1. <https://nodemon.io/>
            2. [Vídeo Aula sobre nodemon](https://www.youtube.com/watch?v=u3MrPxq_RyA&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=9)
         8. [Sequelize VSCode Association Snippet](https://marketplace.visualstudio.com/items?itemName=louisyuenll.sequelize-vscode-association-snippet)

         9. A extensão [Paste JSON as Code](https://marketplace.visualstudio.com/items?itemName=quicktype.quicktype) Copy JSON, paste as Go, TypeScript, C#, C++ and more.
         10. [Delphi Keymap](https://marketplace.visualstudio.com/items?itemName=alefragnani.delphi-keybindings)

      7. [🔝](#topo_Objetivo "Retorna ao topo")

  2. <span id='id_referencias'></span>**REFERÊNCIAS**
     1. [Dependências do node js](https://nodejs.org/en/docs/meta/topics/dependencies/)
     2. [Biblioteca c libuv1](https://github.com/libuv/libuv)
     3. [NodeSource Node.js Binary Distributions](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
     4. [Instruções de instalação no ubuntu](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
     5. [npm Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense)
     6. [AutoFileName](https://marketplace.visualstudio.com/items?itemName=JerryHong.autofilename)
     7. [Node.js Modules Intellisense](https://marketplace.visualstudio.com/items?itemName=leizongmin.node-module-intellisense)
     8. [Instalar eslint](https://eslint.org/)
     9. Instalar extensão [vscode-eslint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
     10. [Lista de framework baseado em express](https://expressjs.com/en/resources/frameworks.html)
     11. [nodejs-install-setup.html](http://www.w3big.com/pt/nodejs/nodejs-install-setup.html)
     12. [Acesse a banco de dados sequelize](https://www.youtube.com/watch?v=0q0u8syrztg&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=16)
         1. [Acesso a dados com pacote sequelize.org](https://sequelize.org/)
     13. [node_sequelize1](http://www.macoratti.net/17/01/node_sequelize1.html)
     14. [Framework loopback](https://loopback.io/doc/en/lb4/index.html)
         1. [Extending-LoopBack-4](https://loopback.io/doc/en/lb4/Extending-LoopBack-4.html)
     15. [get-started-with-creating-a-restful-api-endpoints-in-nodejs-and-expressjs](https://scotch.io/@gilles/get-started-with-creating-a-restful-api-endpoints-in-nodejs-and-expressjs)

     16. [🔝](#topo_Objetivo "Retorna ao topo")

  3. <span id='id_historico'></span></span>**HISTÓRICO**

      <!--DONE: HISTÓRICO -->

     1. 10/05/2023
         - [x] Trocado todo o código \<pre\>\</pre\> por \```sh \``` e usado o tema da pasta /css;
     2. 04/02/2021
         - [x] Criado este documento;

     3. 06/12/2020
         - [x] instalar nodejs
         - [x] [Nodejs Docs](https://nodejs.org/en/docs/)
         - [x] instalar extensões do vscode para nodejs
           - [x] npm Intellisense
           - [x] AutoFileName
           - [x] Node.js Modules Intellisense
           - [x] eslint nodejs para uso na linha de comandos
           - [x] Instalar extensão [vscode-eslint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

     4. 08/02/2021
         - [x] Extensão sequelize para acessar banco de dados:
           - [x] Instalar sequelize;
           - [x] Testar acesso ao banco de dados mariadb.

     5. 11/02/2021. <!--FIXME: Falta fazer os item abaixo: -->
         - [x] Documentar a segunda forma de conectar-se ao banco de dados mariadb.
         - [x] Criar um index no arquivo instalar.md.

     6. [🔝](#topo_Objetivo "Retorna ao topo")

[🔝🔝](#topo "Retorna ao topo")
