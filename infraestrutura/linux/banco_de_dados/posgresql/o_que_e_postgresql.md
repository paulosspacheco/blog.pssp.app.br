# <span id="topo"><span>O que é banco de dados postgresql<a href="o_que_e_postgresql.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="o_que_e_postgresql.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Instalar no linux Mint - Versão debian 10.](#id_assunto01)
      2. [Aplicativos Clientes disponível do shell do linux](#id_assunto02)
      3. [Assunto 03](#id_assunto03)
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
      1. Este documento descreve passo a passo como instalar o PostgresSQL no linux Mint LMDE 4.
      2. Faz um resumo do objetivo, dos benefícios e desvantagens do PostgresSQL.
      3. Mostra a pasta onde o PostgresSQL mantém suas configurações.
      4. Descreve os parâmetros para conectar-se com o Banco de Dados.
      5. Descreve os clientes cluterdb e createdb.

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O PostgreSQL é um banco de dados livre criado pela Universidade da Califórnia em Berkeley e tem mais de 30 anos de desenvolvimento ativo.
         2. Sua licença é mais flexível do que a licença do mysql porque o mysql é da Oracle e o PostgreSQL é da comunidade.
         3. O mysql por ter sua licença restritiva a comunidade criou o MariaDB e com ele veio as incompatibilidades do projetos existentes. O Lazarus não consegue conectar-se ao mariaDB e por isso estou estudando o PostgreSQL.

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Linguagem sql
         2. sistema operacional linux.

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Banco de dados cliente servidor, robusto, escalável e sua licença é BSD.
         2. .

         3. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Não vi desvantagem em relação ao mysql.
         2. Para uma aplicação mono-usuário é mais difícil de instalar e configurar. O SqLite á mais indicado para essa tarefa.

         3. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_assunto01></span>**Instalar no linux Mint LMDE 4 - Versão Debian 10.**

         1. Código ShellScript

            ```sh
              # Instalar o servidor           
              sudo apt install postgresql

              # Instalar a aplicação cliente:
              sudo apt install postgresql-client

              # Graphical administration tool for PostgreSQL.  obs: Já existe a versão 4, mais o Linux Mint só conhece a 3.
              sudo apt install pgadmin3                    
              
              # Facilidades adicionais para o PostgreSQL : https://www.postgresql.org/docs/11/contrib.html
              # Não deve ser instalado porque quero o básico do banco de dados para manter compatibilidade com os outros.
              sudo apt install postgresql-contrib


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

         2. **NOTAS**
            1. Dados para conexão com banco de de dados postgres
               1. **DataBaseName** : postgres
               2. **HostName** : 127.0.0.1  # Obs: a porta 5432 não precisa informar no Lazarus quando for máquina local.
               3. **UserName** : postgres
               4. **Password** : masterkey

            2. A versão Linux Mint LMDE 4 Debian cria os arquivos de configurações na pasta: **/etc/postgresql/11/main**

               1. A instalação cria o arquivo **/etc/postgresql/11/main/postgresql.conf** com os parâmetros básico do postgresql.

                  1. Parâmetros importantes que devem se alterados para atender a demanda:
                     1. **data_directory** = '/var/lib/postgresql/11/main' Nota:  Pode ser qualquer outro lugar.
                     2. **data_directory** = '/home/paulosspacheco/Documentos/db/postgresql'  
                        1. Nota:
                           1. É necessário mover o conteúdo /var/lib/postgresql/11/main para /home/paulosspacheco/Documentos/db/postgresql usando o seguinte comando:

                              ```sh
                                # Parar o banco de dados postgres
                                sudo systemctl stop postgresql

                                # Entrar no arquivo abaixo e trocar comentar a linha data_directory = '/var/lib/postgresql/11/main' 
                                # Acrescentar a linha:  data_directory = '/home/paulosspacheco/Documentos/db/postgresql'  
                                # Após as alterações acima salvar o arquivo /etc/postgresql/12/main/postgresql.conf
                                sudo xed /etc/postgresql/12/main/postgresql.conf

                                # Clonar a pasta /var/lib/postgresql/11/main para a pasta /home/paulosspacheco/Documentos/db/postgresql
                                sudo rsync -av /var/lib/postgresql/11/main /home/paulosspacheco/Documentos/db/postgresql

                                # Iniciar o banco de dados postgres
                                sudo systemctl start postgresql
                              ```


                     3. **listen_addresses** = 'localhost'
                        1. what IP address(es) to listen on;
                        2. comma-separated list of addresses;
                        3. defaults to 'localhost'; use '*' for all (change requires restart)

                     4. **port** = 5432 (change requires restart)

                  2. Como reiniciar o servidor postgres:

                     ```sh

                       sudo /etc/init.d/postgresql restart

                     ```

                  3. Como parar o servidor postgres:

                     ```sh

                       sudo /etc/init.d/postgresql stop

                     ```

                  4. Como iniciar o servidor postgres:

                     ```sh

                       sudo /etc/init.d/postgresql start

                     ```

               2. Arquivo de log que deve ser apagado com frequência:
                  1. **/var/lib/pgsql/data/pg_log**

         3. **Referências:**
            1. [Vídeo aula de como instalar o postgresSQL no linux](https://www.youtube.com/watch?v=pqDNOGOcUks)
            2. [Como instalar outras versões no linux](https://www.postgresql.org/download/linux/debian/)
            3. [Site oficial do PostgreSQL](https://www.postgresql.org/)
            4. [Configuração pós-instalação -  Bibliotecas compartilhadas](https://www.postgresql.org/docs/14/install-post.html#INSTALL-POST-SHLIBS)
            5. [Manual básico para principiantes](https://www.devmedia.com.br/instalacao-e-configuracao-do-servidor-postgresql-no-linux/26184)

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_assunto02></span>**Aplicativos Clientes disponível do shell do linux**

         1. [**clusterdb**](https://www.postgresql.org/docs/9.1/app-clusterdb.html) - um [cluster](https://www.postgresql.org/docs/11/creating-cluster.html) de banco de dados PostgreSQL.
               1. Código ShellScript

                  ```sh
                  # Para agrupar uma única tabela foo em um banco de dados chamado xyzzy :
                  clusterdb --table foo xyzzy

                  ```

         2. [**createdb**](https://www.postgresql.org/docs/11/app-createdb.html)  - Cria um banco de dados PostgreSQL
            1. Código ShellScript

               ```sh
                 # conecta-se ao usuário postgres:
                 su postgres

                 # Cria o banco de dados teste:
                 createdb teste

                 # Para criar o banco de dados teste usando o servidor em host localhost, porta 5000, usando o template0 banco de dados modelo, aqui está o comando de linha de comando e o comando SQL equivalente:
                 createdb -p 5000 -h localHost -T template0 -e teste # CREATE DATABASE teste TEMPLATE template0;


               ```

         3. **
            1. Código ShellScript

               ```sh
                 # Como usar?
                 

               ```

         4. **
            1. Código ShellScript

               ```sh
                 # Como usar?
                 

               ```

         5. **
            1. Código ShellScript

               ```sh
                 # Como usar?
                 

               ```

         6. **
            1. Código ShellScript

               ```sh
                 # Como usar?
                 

               ```

         7. **
            1. Código ShellScript

               ```sh
                 # Como usar?
                 

               ```

         8. **Referências:**
            1. [title](link)
            2. [title](link)

         9. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_assunto03></span>**Assunto 03**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 03**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

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
      1. [Documentação do PostgreSQL 11.15](https://www.postgresql.org/docs/11/index.html)
      2. [Capítulo 24. Tarefas de manutenção de rotina do banco de dados](https://www.postgresql.org/docs/11/maintenance.html)
      3. [#](##)
      4. [#](##)
      5. [#](##)

      6. <text onclick="goBack()">[🔙]</text>

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
