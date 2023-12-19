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
   1. [Instalar postgresSQL no Linux Debian ou derivados](#id_assunto01)
   2. [Aplicativos Clientes disponível do shell do linux](#id_assunto02)
   3. [Aplicativo Cliente GUI dbeaver](#id_assunto03)

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
   **Instalar postgresSQL no Linux Debian ou derivados)**
      1. Código ShellScript para instalar

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

      2. **NOTAS**
         1. Configurações para que o postgres seja acessado fora da rede local:
            1. Editar arquivo _/etc/postgresql/14/main/pg_hba.conf_ e adicione a seguinte linha:

                  ```text

                    host alls all 0.0.0.0/0 md5
                    
                  ```  

            2. _Nota_
               1. Onde _0.0.0.0/0_ é o intervalo de endereços que aceitará conexão de outros IPs que não seja _localhost_.
               2. A autenticação do cliente é controlada pelo arquivo _pg_hba.conf_ veja [mais...](https://pgdocptbr.sourceforge.io/pg74/client-authentication.html)
               3. [Métodos de autenticação](https://pgdocptbr.sourceforge.io/pg74/auth-methods.html)
                  1. Autenticação por senha são:
                     1. _md5_
                        1. Suporta senhas criptografadas armazenadas no catálogo do sistema _pg_shadow_.
                     2. _crypt_
                        1. semelhante ao _md5_
                     3. _password_
                        1. O método _password_ deve ser evitado, especialmente em conexões pela Internet aberta (a menos que seja utilizado _SSL_, _SSH_ ou outro método de segurança para proteger a conexão).

         2. Dados para conexão com banco de de dados postgres
            1. _DataBaseName_ : postgres
            2. _HostName_ : 127.0.0.1  # Obs: a porta 5432 não precisa informar no Lazarus quando for máquina local.
            3. _UserName_ : postgres
            4. _Password_ : masterkey
         3. A versão Linux Mint LMDE 4 Debian cria os arquivos de configurações na pasta: **/etc/postgresql/14/main**
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

                             # Iniciar o banco de dados postgres
                             sudo systemctl start postgresql
                           ```

                  3. _listen_addresses_ : é um parâmetro de configuração que determina qual endereço ou endereços _TCP/IP_ o servidor deve escutar.:
                     1. O padrão é '_localhost_'; use _'*'_ para todos (a alteração requer reinicialização) e essa lista de endereços é separados por vírgula
                        1. _Exemplos_:
                           1. _listen_addresses_ = 'localhost';
                           2. _listen_addresses_ = '*';
                           3. _listen_addresses_ = 'localhost,192.168.15.2';
                     2. O arquivo pode ser editado usando o comando abaixo:

                           ```text

                              sudo xed /etc/postgresql/14/main/postgresql.conf

                           ```

                     3. _Referências_:
                        1. [endereços_de_escuta](https://pgpedia.info/l/listen_addresses.html#:~:text=listen_addresses%20is%20a%20configuration%20parameter,was%20added%20in%20PostgreSQL%208.0.)

                  4. _port_ = 5432 (change requires restart)

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

   3. <span id=id_assunto03></span>**Aplicativo Cliente GUI dbeaver**
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
   4. **Como instalar o cliente GUI PostgresSQL _dbeaver_:**
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

4. <span id=id_referencias></span>
**REFERÊNCIAS GLOBAIS**
   1. [Documentação do PostgreSQL 11.15](https://www.postgresql.org/docs/11/index.html)
   2. [Capítulo 24. Tarefas de manutenção de rotina do banco de dados](https://www.postgresql.org/docs/11/maintenance.html)
   3. [Aplicativo Cliente DBeaver 22.3.2](https://dbeaver.io/2023/01/08/dbeaver-22-3-2/)
   4. [Autenticação do cliente postgresSQL](https://pgdocptbr.sourceforge.io/pg74/client-authentication.html)
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