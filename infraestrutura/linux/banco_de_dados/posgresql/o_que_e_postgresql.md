<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# O que é banco de dados postgresql<a href="o_que_e_postgresql.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

1. [Resumo do conteúdo](#id_resumo)
2. **Introdução**
   1. [Objetivo.](#id_objetivo)
   2. [Pre-requisitos.](#id_pre_requisitos)
   3. [Benefícios.](#id_beneficios)
   4. [Desvantagens.](#id_desvantagens)
3. [**Conteúdo estudado.**](#id_Conteudo)
   1. [Instalar postgreSQL no Linux Debian ou derivados](#id_assunto01)
   2. [Aplicativos Clientes disponível do shell do linux](#id_assunto02)
   3. [Aplicativo Cliente GUI dbeaver](#id_assunto03)
   4. [Como trocar a senha do banco postgreSQL no linux caso se esqueça?](#id_assunto04)

4. [**Referências globais.**](#id_referencias)
5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

1. <span id="id_resumo"><span>**Resumo do conteúdo:**
   1. Este documento descreve passo a passo como instalar o postgreSQL no linux Mint LMDE 4.
   2. Faz um resumo do objetivo, dos benefícios e desvantagens do postgreSQL.
   3. Mostra a pasta onde o postgreSQL mantém suas configurações.
   4. Descreve os parâmetros para conectar-se com o Banco de Dados.
   5. Descreve os clientes cluterdb e createdb.
2. **Introdução**
   1. <span id="id_objetivo"><span>**Objetivo:**
      1. O PostgreSQL é um banco de dados livre criado pela Universidade da Califórnia em Berkeley e tem mais de 30 anos de desenvolvimento ativo.
      2. Sua licença é mais flexível do que a licença do mysql porque o mysql é da Oracle e o PostgreSQL é da comunidade.
      3. O mysql por ter sua licença restritiva a comunidade criou o MariaDB e com ele veio as incompatibilidades do projetos existentes. O Lazarus não consegue conectar-se ao mariaDB e por isso estou estudando o PostgreSQL.
      4. <text onclick="goBack()">[🔙]</text>
   2. **Pre-requisitos:**<span id="id_pre_requisitos"></span>
      1. Linguagem sql
      2. sistema operacional linux.
      3. <text onclick="goBack()">[🔙]</text>
   3. <span id="id_beneficios"></span>
   **Benefícios:**
      1. Banco de dados cliente servidor, robusto, escalável e sua licença é BSD.
      2. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. Não vi desvantagem em relação ao mysql.
      2. Para uma aplicação mono-usuário é mais difícil de instalar e configurar. O SqLite á mais indicado para essa tarefa.
      3. <text onclick="goBack()">[🔙]</text>

3. <span id=id_Conteudo></span>**Conteúdo estudado**
   1. <span id=id_assunto01></span>
   **Instalar postgreSQL no Linux Debian ou derivados)**
      1. **Código ShellScript para instalar**

         ```bash
           # Instalar o servidor           
           sudo apt install postgresql

           # Instalar a aplicação cliente:
           sudo apt install postgresql-client

           # Client sql aceita vários bancos de dados Link: https://dbeaver.io/
           # https://en.wikipedia.org/wiki/DBeaver
           # [dbeaver.io/download](https://dbeaver.io/download/)
       
           # Facilidades adicionais para o PostgreSQL : https://www.postgresql.org/docs/11/contrib.html
           # Não deve ser instalado porque quero o básico do banco de dados para manter compatibilidade com os outros.
           sudo apt install postgresql-contrib

           # Configure o Firewall (Opcional):
           #    Se estiver usando um firewall, abra a porta 3389, que é a porta padrão para o protocolo RDP:
             sudo ufw allow 5432/tcp
             sudo ufw reload

           # Selecionando o usuário postgres
             sudo su postgres

           # entrar no prompt do Postgres
             psql
          
           # visualizando a lista dos bancos de dados no programa psql
             \l

           # Definindo senha masterkey para o usuário Postgres
             \password

           # Para sair do programa psql
             \q

           # Sair do usuário postgres
             exit
           
           # Executar psql estando dentro do usuário corrente.
             psql -Upostgres -hlocalhost

         ```

      2. **Configurações para que o postgres seja acessado fora da rede local**:
         1. **Execute os passos abaixo para definir o método de autenticação do banco:**

            ```bash

               # Parar o banco de dados postgres
                  sudo systemctl stop postgresql

                  sudo xed /etc/postgresql/14/main/pg_hba.conf

               # adicione no final do arquivo pg_hba.conf a linha abaixo e salve e saia do editor
                  host all  all 0.0.0.0/0 scram-sha-256
               
               # Inicia o banco de dados postgres
                  sudo systemctl start postgresql 
            ```  

            1. _Nota_
               1. Onde _0.0.0.0/0_ é o intervalo de endereços que aceitará conexão de outros IPs que não seja _localhost_.
               2. A autenticação do cliente é controlada pelo arquivo _pg_hba.conf_ veja [mais...](https://pgdocptbr.sourceforge.io/pg74/client-authentication.html)
               3. [Métodos de autenticação](https://pgdocptbr.sourceforge.io/pg74/auth-methods.html)
                  1. Autenticação por senha são:
                     1. _[scram-sha-256](https://www.postgresql.org/docs/current/auth-password.html)_
                        1. O método _scram-sha-256_ executa a autenticação SCRAM-SHA-256, conforme descrito em RFC 7677. É um esquema de desafio-resposta que evita a detecção de senhas em conexões não confiáveis ​​e oferece suporte ao armazenamento de senhas no servidor em um formato criptografado com hash que é considerado seguro.
                     2. _md5_
                        1. Suporta senhas criptografadas armazenadas no catálogo do sistema _pg_shadow_.
                        2. O método _md5_ usa um mecanismo personalizado de resposta a desafios e menos seguro. Ele evita a detecção de senhas e evita o armazenamento de senhas no servidor em texto simples, mas não oferece proteção se um invasor conseguir roubar o hash da senha do servidor. Além disso, o algoritmo hash MD5 hoje em dia não é mais considerado seguro contra determinados ataques.
                        3. O método _md5_ não pode ser usado com o recurso db_user_namespace.
                        4. Para facilitar a transição do método _md5_ para o método _SCRAM_ mais recente, se _md5_ for especificado como um método em pg_hba.conf mas a senha do usuário no servidor estiver criptografada para SCRAM (veja abaixo), então a autenticação baseada em SCRAM será escolhida automaticamente.

                     3. _password_
                        1. O método _password_ envia a senha em texto não criptografado e, portanto, é vulnerável à detecção de senha “sniffing< /span>_password_ poderá ser usado com segurança. (Embora a autenticação por certificado SSL possa ser uma escolha melhor se depender do uso de SSL). ataques. Deve sempre ser evitado, se possível. Se a conexão estiver protegida por criptografia SSL, então ”.
                  2. **Notas**:
                     1. O cliente _dbeaver-ce_  não aceita o método _md5_, _crypt_ e _password_
                     2. A senha de cada usuário do banco de dados é armazenada no _pg_authid_ catálogo do sistema.

         2. **Definir no arquivo _/etc/postgresql/14/main/postgresql.conf_ os parâmetros:**
            1. _[listen_addresses](https://www.postgresql.org/docs/current/runtime-config-connection.html#GUC-LISTEN-ADDRESSES)_ : Especifica os endereços TCP/IP nos quais o servidor deve escutar conexões de aplicativos cliente. 
                  1. O valor assume a forma de uma lista separada por vírgulas de nomes de host e/ou endereços IP numéricos. 
                  2. A entrada especial _*_ corresponde a todas as interfaces IP disponíveis.
                  3. A entrada _0.0.0.0_ permite escutar todos os endereços IPv4
                  4. A entrada _::_ permite escutar todos os endereços IPv6.
                  5. Nota:
                     1. Se a lista estiver vazia, o servidor não escuta nenhuma interface IP; nesse caso, apenas soquetes de domínio Unix podem ser usados ​​para conectar-se a ele.
                     2. Se a lista não estiver vazia, o servidor será iniciado se puder escutar pelo menos um endereço TCP/IP.
                     3. Um aviso será emitido para qualquer endereço TCP/IP que não possa ser aberto.
                     4. O valor padrão é _localhost_ , que permite apenas conexões locais de _“loopback”_ TCP/IP.
                     5. O padrão é '_localhost_'; use _'*'_ para todos (a alteração requer reinicialização) e essa lista de endereços é separados por vírgula
                  6. _Exemplos_:

                        ```bash
                           # Só aceita conexão local
                             listen_addresses = 'localhost'

                           # Aceitas conexão de todos os IPS IPv4 e IPv6   
                           listen_addresses = '*'

                           # Aceitas conexão do localhost e do ip 192.168.15.2
                           listen_addresses = 'localhost,192.168.15.2'

                        ```

                  7. O arquivo pode ser editado usando os comandos abaixo:

                        ```bash

                           # Parar o banco de dados postgres
                             sudo systemctl stop postgresql

                           # Edita o arquivo postgreSQL.conf   
                             sudo xed /etc/postgresql/14/main/postgresql.conf

                           # Inicia o banco de dados postgres
                             sudo systemctl start postgresql

                        ```

                  8. _Referências_:
                     1. [endereços_de_escuta](https://pgpedia.info/l/listen_addresses.html#:~:text=listen_addresses%20is%20a%20configuration%20parameter,was%20added%20in%20PostgreSQL%208.0.)
                     2. [client-authentication.html](https://www.postgresql.org/docs/current/client-authentication.html)

            2. _port_ = 5432 (change requires restart)

      3. **Dados para conexão com banco de dados postgres**
         1. _DataBaseName_ : postgres
         2. _HostName_ : 127.0.0.1  # Obs: a porta 5432 não precisa informar no Lazarus quando for máquina local.
         3. _UserName_ : postgres
         4. _Password_ : masterkey
      4. **A versão Linux Mint LMDE 4 Debian cria os arquivos de configurações na pasta:** _/etc/postgresql/14/main_
         1. A instalação cria o arquivo **/etc/postgresql/14/main/postgresql.conf** com os parâmetros básico do postgresql.
            1. Parâmetros importantes que devem se alterados para atender a demanda:
               1. _data_directory_ = '/var/lib/postgresql/14/main' Nota:  Pode ser qualquer outro lugar.
               2. _data_directory_ = '/home/paulosspacheco/Documentos/db/postgresql'  
                  1. Nota:
                     1. É necessário mover o conteúdo /var/lib/postgresql/14/main para /home/paulosspacheco/Documentos/db/postgresql usando o seguinte comando:

                        ```bash
                          # Parar o banco de dados postgres
                          sudo systemctl stop postgresql

                          # Entrar no arquivo abaixo e trocar comentar a linha data_directory = '/var/lib/postgresql/14/main' 
                          # Acrescentar a linha:  data_directory = '/home/paulosspacheco/Documentos/db/postgresql'  
                          # Após as alterações acima salvar o arquivo /etc/postgresql/14/main/postgresql.conf
                          sudo xed /etc/postgresql/14/main/postgresql.conf

                          # Clonar a pasta /var/lib/postgresql/14/main para a pasta /home/paulosspacheco/Documentos/db/postgresql
                          sudo rsync -av /var/lib/postgresql/14/main /home/paulosspacheco/Documentos/db/postgresql

                          # Inicia o banco de dados postgres
                          sudo systemctl start postgresql
                        ```

            2. Como reiniciar o servidor postgres:

               ```bash

                 # comando 01
                   sudo /etc/init.d/postgresql restart

                 # ou
                   sudo service postgresql restart
                   
               ```

            3. Como parar o servidor postgres:

               ```bash

                 sudo /etc/init.d/postgresql stop

               ```

            4. Como iniciar o servidor postgres:

               ```bash

                 sudo /etc/init.d/postgresql start

               ```

         2. Arquivo de log que deve ser apagado com frequência:
            1. **/var/lib/pgsql/data/pg_log**

   2. **Referências:**
      1. [Vídeo aula de como instalar o postgreSQL no linux](https://www.youtube.com/watch?v=pqDNOGOcUks)
      2. [Como instalar outras versões no linux](https://www.postgresql.org/download/linux/debian/)
      3. [Site oficial do PostgreSQL](https://www.postgresql.org/)
      4. [Configuração pós-instalação -  Bibliotecas compartilhadas](https://www.postgresql.org/docs/14/install-post.html#INSTALL-POST-SHLIBS)
      5. [Manual básico para principiantes](https://www.devmedia.com.br/instalacao-e-configuracao-do-servidor-postgresql-no-linux/26184)
      6. [Documentação → PostgreSQL 16](https://www.postgresql.org/docs/current/auth-password.html)

      7. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_assunto02></span>**Aplicativos Clientes disponível do shell do linux**
      1. [**clusterdb**](https://www.postgresql.org/docs/9.1/app-clusterdb.html) - um [cluster](https://www.postgresql.org/docs/11/creating-cluster.html) de banco de dados PostgreSQL.
            1. Código ShellScript

               ```bash
               # Para agrupar uma única tabela foo em um banco de dados chamado xyzzy :
               clusterdb --table foo xyzzy

               ```

      2. [**createdb**](https://www.postgresql.org/docs/11/app-createdb.html)  - Cria um banco de dados PostgreSQL
         1. Código ShellScript

            ```bash
              # conecta-se ao usuário postgres:
              su postgres

              # Cria o banco de dados teste:
              createdb teste

              # Para criar o banco de dados teste usando o servidor em host localhost, porta 5000, usando o template0 banco de dados modelo, aqui está o comando de linha de comando e o comando SQL equivalente:
              createdb -p 5000 -h localHost -T template0 -e teste # CREATE DATABASE teste TEMPLATE template0;


            ```

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_assunto03></span>**Aplicativo Cliente GUI dbeaver**
      1. O DBeaver Community Edition (DBeaver CE) é uma ferramenta de gerenciamento de banco de dados relacional de código aberto. Ele oferece suporte a vários bancos de dados, como MySQL, PostgreSQL, SQLite, Oracle, Microsoft SQL Server, e muitos outros. O DBeaver CE é uma versão gratuita e de código aberto da ferramenta, projetada para ser usada por desenvolvedores, administradores de banco de dados e qualquer pessoa envolvida no gerenciamento e manipulação de bancos de dados.
      2. Principais características do DBeaver CE:
         1. Conectividade com Múltiplos Bancos de Dados: Oferece suporte a uma ampla variedade de sistemas de gerenciamento de banco de dados, permitindo que os usuários se conectem a diferentes bancos de dados a partir de uma única interface.
         2. Interface Gráfica Intuitiva: Possui uma interface de usuário gráfica intuitiva que facilita o desenvolvimento, gerenciamento e consulta de bancos de dados.
         3. Editor SQL: Inclui um editor SQL poderoso com realce de sintaxe, conclusão automática e outras funcionalidades que facilitam a escrita e execução de consultas SQL.
         4. Gerenciamento de Metadados: Permite a visualização e edição de metadados do banco de dados, como tabelas, índices, procedimentos armazenados, entre outros.
         5. Exportação e Importação de Dados: Facilita a transferência de dados entre diferentes fontes, com suporte a várias opções de exportação e importação.
         6. Visualização de Dados: Oferece recursos visuais para a visualização de dados, incluindo gráficos e ferramentas de exploração de dados.
         7. Suporte a Plugins: Permite a extensão de funcionalidades por meio de plugins, proporcionando flexibilidade para atender a diferentes necessidades.
      3. O DBeaver CE é uma escolha popular devido à sua versatilidade e ao fato de ser gratuito e de código aberto. No entanto, é importante observar que existem versões comerciais do DBeaver (DBeaver EE) que oferecem recursos adicionais e suporte aprimorado, mas a versão Community Edition é uma opção robusta para muitos desenvolvedores e administradores de banco de dados.

      4. **Como instalar o cliente GUI postgreSQL _dbeaver_:**
         1. Baixar pacote Dbeaver em [dbeaver.io](https://dbeaver.io/download/)
         2. Instalar pacote.
            1. _Linux Debian ou derivados_
               1. Baixar pacote [Linux Debian package (installer)](https://dbeaver.io/download/#:~:text=Linux%20Debian%20package%20(installer))

                  ```bash

                     cd ~Download
                     sudo apr install ./dbeaver-ce_23.3.0_amd64.deb

                  ```

               2. Obs:
                  1. Observe nome do arquivo ao clicar no link para [download](https://dbeaver.io/download/#:~:text=Linux%20Debian%20package%20(installer)) porque pode mudar o número da versão.

            2. _[MacOS](https://formulae.brew.sh/cask/dbeaver-community)_

                  ```bash

                     brew install --cask dbeaver-community

                  ```

   5. <span id=id_assunto04></span>**Como trocar a senha do banco _postgreSQL_ no linux caso se esqueça?**
      1. Passo 01:
         1. Mudar o tipo de acesso no arquivo _pg_hba.conf_:

            ```bash

               # Parar o banco de dados postgres
               sudo systemctl stop postgresql

               sudo xed /etc/postgresql/14/main/pg_hba.conf

               # Procurar  a linha  host all  all localhost scram-sha-256 e troque para
               # host all  all localhost trust
                  
               # Inicia o banco de dados postgres
               sudo systemctl start postgresql                

            ```

      2. Passo 02
         1. Entrar no usuário postgres, executar programa  _psql_ e alterar a senha;

            ```bash

               # logar-se ao usuário postgres: 
                 sudo su postgres

               # Executar cliente psql:
                 psql -U postgres;

               # Alterar a senha:
                 ALTER ROLE postgres PASSWORD 'nova senha';

               # Sair do cliente psql
               \q

               # sair do usuário postgres

            ```

      3. Passo 03:
         1. Retornar ao tipo de acesso original no arquivo _pg_hba.conf_:

            ```bash

               # Parar o banco de dados postgres
               sudo systemctl stop postgresql

               sudo xed /etc/postgresql/14/main/pg_hba.conf

               # Procurar  a linha host all  all localhost trust  e troque para
               # host all  all localhost scram-sha-256
                  
               # Inicia o banco de dados postgres
               sudo systemctl start postgresql                
               
            ```

4. <span id=id_referencias></span>
**REFERÊNCIAS GLOBAIS**
   1. [Documentação do PostgreSQL 11.15](https://www.postgresql.org/docs/11/index.html)
   2. [Capítulo 24. Tarefas de manutenção de rotina do banco de dados](https://www.postgresql.org/docs/11/maintenance.html)
   3. [Aplicativo Cliente DBeaver 22.3.2](https://dbeaver.io/2023/01/08/dbeaver-22-3-2/)
   4. [Autenticação do cliente postgreSQL](https://pgdocptbr.sourceforge.io/pg74/client-authentication.html)
   5. [POSTGRESQL - MÉTODOS DE AUTENTICAÇÃO DE SENHA](https://acervolima.com/postgresql-metodos-de-autenticacao-de-senha/)

   6. <text onclick="goBack()">[🔙]</text>

1. <span id="id_historico"><span>
**HISTÓRICO**
   1. 14/12/2023 <!--TODO: HISTÓRICO -->
   2. 14/12/2023 <!--FIXME: Falta fazer os item abaixo: -->
      - [x] Criar este documento baseado no modelo03.md ;
      - [x] Escrever tópico Objetivos;
      - [x] Escrever tópico Pre-requisitos
      - [x] Escrever tópico Benefícios
      - [x] Escrever tópico desvantagens
      - [x] Escrever tópico Instalar no linux Mint LMDE 4
      - [x] Escrever tópico Aplicativos Clientes disponível do shell do linux
      - [x] Escrever tópico Aplicativo Cliente GUI dbeaver
      - [x] Escrever tópico Referências
      - [x] Atualizar o histórico deste documento.
      - [ ] Testar este documento depois após uma semana de concluído.

      - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")