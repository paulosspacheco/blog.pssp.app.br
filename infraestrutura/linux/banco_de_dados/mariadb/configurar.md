<!-- markdownlint-disable-next-line -->
<div class="topnav" id="myTopnav"><div w3-include-html="/menu.inc"></div></div>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# _CONFIGURAÇÃO DO MARIADB_<a href="configurar.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a><span id="topo"><span>

## _**INDEX**_<span id="topo_Index"><span>

---

1. [Descobrindo onde os dados são gravados](#id_1)
2. [Como alterar a base de dados padrão do MySQL](#id_2)
3. [Como ajustar a segurança do Banco de dados](#id_3)
4. [Como configurar mariadb para que permita acesso remoto](#id_4)
5. [Como criar DataBase no mariadb](#id_5)
6. [Usuários](#id_6)
   1. [Como adicionar usuários](#id_6.1)
   2. [Como excluir usuários](#id_6.2)
7. [Variáveis ​​de sistema do servidor mariadb](#id_7)
8. [Como o mariadb lida com letras maiúsculas e minúsculas](#id_8)
9. [Como instalar maridb](./instalar.html)
10. [REFERÊNCIAS](#id_referencias)

## _**CONTEÚDO**_<span id="topo_conteudo"><span>

---

### **1. Descobrindo onde os dados são gravados**<span id="id_1"><span>

1. Para saber **onde os dados são gravados no mariadb** usar a sequencia abaixo:
  1. Entrar no cliente _mysql_ do _mariadb_.

     ```sh

        sudo mysql -u root -p  

     ```

  2. Para descobrir a pasta onde os dados são gravados executar o seguinte comando:

     ```sql

         SELECT @@datadir;

     ```

  3. Para visualizar todas as variáveis do mariadb:

     ```sql

        show variables like "%DATA%";

     ```

  4. Para sair do cliente mysql do mariadb:

     ```sql
       
       quit;

     ```

2. [🔝](#topo_Index "Retorna ao topo")  

---

### **2. Como alterar a base de dados padrão do MySQL**<span id="id_2"><span>

1. A pasta de dados padrão do MySQL é: /var/lib/mysql.

2. Como mudar a pasta de dados de _/var/lib/mysql_ para : _/mariadbdatadir_:
  1. O mariadb instalado é a ultima versão estável no momento da publicação desta dica: ubuntu_server-mate 5.4.0-60-generic.

  2. A etapa abaixo só funciona se a pasta estiver na raiz /. Tentei muito fazer funcionar na pasta _/home/mariadbdatadir_, mais não funciona.

  3. Etapas do processo:
     1. Parar a execução do mariadb:

        ```sh

           sudo systemctl stop mariadb 

        ```

     2. Criar pasta customizada _/mariadbdatadir_.

        ```sh
        
           sudo mkdir /mariadbdatadir

        ```

     3. Informa ao linux que o dono da pasta _/mariadbdatadir_ é o usuário  mysql:mysql.

        ```sh

           sudo chown -R mysql:mysql /mariadbdatadir ```

        ```  

     4. Editar o arquivo _/etc/mysql/my.cnf_ e aponte para o novo diretório de dados:

        ```sh
          sudo vi /etc/mysql/my.cnf ```
        ```  

     5. Adicione no final do arquivo _/etc/mysql/my.snf_ as linhas abaixo:

        ```snf

           [mysqld] <br>
           datadir=/mariadbdatadir <br>

        ```

     6. Copia todos as pastas e arquivos da pasta anterior (exceto links simbólicos) para a nova pasta:

        ```sh

           sudo cp -vRp /var/lib/mysql/* /mariadbdatadir ```

        ```

     7. Habilita _mariadb_:

        ```sh
        
           sudo systemctl enable mariadb 

        ```

     8. Inicializa _mariadb_:

        ```sh

           sudo systemctl start mariadb ```

        ```

     9. Checa se foi inicializado:

        ```sh
        
           systemctl status mariadb ```

        ```

     10. Inicializa o Linux para que _mariadb_ se ajusta as mudanças.

        ```sh
        
           reboot

        ```

3. Caso ocorra mensagem de muitos arquivos aberto, entrar no arquivo abaixo e alterar o padrão:
  1. Arquivo /etc/systemd/system/mysql.service contém a variável LimitNOFILE=16384 que determina o número máximo de arquivos abertos.
4. [🔝](#topo_Index "Retorna ao topo")  

---

### **3. Como ajustar a segurança do Banco de dados**<span id="id_3"><span>

1. **mysql_secure_installation** é um script de shell disponível em sistemas Unix e permite que você melhore a segurança da instalação do _MariaDB_ das seguintes maneiras:
  1. Você pode definir uma senha para contas root.
  2. Você pode remover contas root que estão acessíveis de fora do host local.
  3. Você pode remover contas de usuários anônimos.
  4. Você pode remover o banco de dados de teste, que por padrão pode ser acessado por usuários anônimos.
  5. O **mysql_secure_installation** pode ser invocado sem argumentos:

     ```sh
     
        sudo mysql_secure_installation
        
     ```

  6. As mensagens abaixo foi traduzida das mensagens geradas pelo script _mysql_secure_installation_.
     1. NOTA: EXECUTAR TODAS AS PARTES DESTE SCRIPT É RECOMENDADO PARA TODO O MariaDB. SERVIDORES EM USO DE PRODUÇÃO! POR FAVOR, LEIA ATENTAMENTE CADA PASSO.

     2. **ETAPA PARA ALTERAR A SENHA DO ROOT**
        1. Para entrar no _MariaDB_ para protegê-lo, precisaremos da senha atual do usuário root. Se você acabou de instalar o _MariaDB_ e ainda não definiu a senha do root, a senha estará em branco, então você deve apenas pressionar Enter aqui.

           ```sh
           
              Enter current password for root (enter for none): 

           ```

        2. Definir a senha de root garante que ninguém possa logar no usuário root do _MariaDB_ sem a devida autorização. Se você já tem uma senha de root definida, pode responder com segurança 'n'.

           ```sh
           
              # Change the root password? [Y/n] y 
              # New password: 
              # Re-enter new password: 

           ```

     3. **ETAPA PARA EXCLUIR OU NÃO O USUÁRIO ANÔNIMO**
        1. Por padrão, uma instalação do _MariaDB_ tem um usuário anônimo, permitindo que qualquer pessoa se logue no _MariaDB_ sem ter que ter uma conta de usuário criada para eles. Destina-se apenas a teste e para tornar a instalação um pouco mais suave. Você deve removê-los antes de mudar para um ambiente de produção.

           ```sh

             Remove anonymous users? [Y/n] y 

           ```

        2. **ETAPA PARA EXCLUIR OU NÃO O BANCO DE DADOS TESTE**
           1. Por padrão, MariaDB vem com um banco de dados chamado 'teste' que qualquer pessoa pode acessar. Isso também se destina apenas a teste e deve ser removido antes de mudar para um ambiente de produção.

              ```sh

                 Remove test database and access to it? [Y/n] y

              ```

        3. **ETAPA PARA RECARREGAR OU NÃO A TABELA DE PRIVILÉGIOS DO BANCO DE DADOS**
           1. Recarregar as tabelas de privilégios garantirá que todas as alterações feitas até agora terão efeito imediato.

              ```sh

                Reload privilege tables now? [Y/n] y 

              ```

2. [🔝](#topo_Index "Retorna ao topo")

---

### **4. Como configurar mariadb para que permita acesso remoto**<span id="id_4"><span>

1. Para que todos os computadores acessem o banco de dados, edite o arquivo /etc/mysql/my.cnf e adicione no final do arquivo as linhas:
  1. <pre>
     $ sudo vi /etc/mysql/my.cnf
     //em seguida adicione no final do arquivo /etc/mysql/my.cnf
     [mysqld]
        bind-address=*
     ```

2. Execute o comando abaixo no prompt do sistema para reiniciar o banco de dados mariadb:
  1. ```shsudo systemctl restar mariadb ```

3. Habilite o usuário root para acessar de qualquer computador.
  1. Entrar no cliente mysql do mariadb do mariadb.
     1. <pre>mysql -h localhost -u root -p ```
     2. Dê permissão para que o usuário root acesse fora do localhost.
        1. <pre>GRANT ALL ON *.* TO ‘root’@’%’ IDENTIFIED BY ‘password‘;```
           1. Onde: O sinal % significa “qualquer IP”, ou seja,  indica que o usuário pode acessar o banco de dados em qualquer máquina da rede. Para habilitar o acesso apenas para um único IP, substitua o sinal % pelo IP desejado, assim somente a máquina com o IP indicado poderá conectar o servidor.
     3. Para sair do cliente mysql:
        1. <pre>quit;```
4. [🔝](#topo_Index "Retorna ao topo")  

---

### **5. Como criar DataBase no mariadb**<span id="id_5"><span>

1. Entrar no cliente mysql do mariadb do mariadb.
  1. ```shsudo mysql -u root -p```

  2. [Cria o banco de dados nomeDataBase](https://mariadb.com/kb/en/create-database/):
     1. <pre>CREATE DATABASE nomeDataBase;```

  3. [Para visualizar todos os DATABASES](https://mariadb.com/kb/en/show-databases/):
     1. SHOW DATABASES;

  4. Para selecionar o banco de dados criado (nomeDataBase) executar comando:
     1. <pre>USE nomeDataBase;```

  5. Para visualizar as tabela do database selecionado:
     1. <pre>show tables```

  6. [SHOW CHARACTER SET](https://mariadb.com/kb/en/show-character-set/)
     1. Sintaxe:
        1. <pre>SHOW CHARACTER SET [LIKE 'pattern' | WHERE expr]```

     2. Exemplo:
        1. Para checar a lista de opções de tipo de caractere e default collation em latin:
           1. <pre>show character set like 'latin%'```

  7. [Definir conjuntos de caracteres e agrupamentos](https://mariadb.com/kb/en/setting-character-sets-and-collations/):
     1. Exemplo:
        1. Para não distingue letras minúsculas e maiúsculas e nem caracteres acentuados e com cedilha, ou seja, o registro que contém a palavra “Intuição” será retornado quando houver uma procura pela palavra “intúicao
           1. <pre>ALTER DATABASE nomeDataBase CHARACTER SET = 'latin1' COLLATE = 'latin1_swedish_ci';```

  8. [Tabela Esquema de Informação SCHEMATA](https://mariadb.com/kb/en/information-schema-schemata-table/):
     1. Exemplo:
        1. <pre>SELECT * FROM INFORMATION_SCHEMA.SCHEMATA\G```

  9. Para sair do cliente mysql:
     1. <pre>quit;```

2. Obs: O nome do banco de dados usa o mesmo estilo de nomes da linguagem c++, ou seja maiúsculas e minusculas são diferentes, porém é possível mudar o padrão mudando a variável **lower_case_table_names=1** em /etc/mysql/my.cnf .
3. [🔝](#topo_Index "Retorna ao topo")  

---

### 6. Usuários<span id="id_6"><span>

---

#### 6.1 **Adicionando usuários**<span id="id_6.1"><span>

---

##### **6.1.1 [Como adicionar usuários ao banco de dados](https://mariadb.com/kb/en/create-user/)**

1. Entrar no cliente mysql do mariadb do mariadb:
  1. ```shsudo mysql -h localhost -u root -p```

  2. Para GRANT ALL conceder privilégios a um user, permitindo que o usuário controle total sobre um determinado database se tiver no localhost, use a seguinte sintaxe:
     1. Sintaxe:
        1. GRANT ALL PRIVILEGES ON database_name.* TO 'user_name'@'localhost';
     2. Exemplo:
        1. GRANT ALL PRIVILEGES ON Db_BlogPsspAppBr.* TO 'Use_BlogPsspAppBr'@'localhost';

  3. Para criar o usuário "User_BlogPsspAppBr" com permissão de acesso a qualquer computador:
     1. <pre>CREATE USER 'User_BlogPsspAppBr'@'%' IDENTIFIED BY 'senha';```

  4. Para criar o usuário "User_BlogPsspAppBr" com privilégio de administrador, porém só pode acessar o banco de dados pelo IP:"192.168.15.5":
     1. <pre>GRANT ALL PRIVILEGES ON *.* TO 'BlogPsspAppBr''@''192.168.15.5' IDENTIFIED BY 'password' WITH GRANT OPTION; ```
     2. <pre>FLUSH PRIVILEGES;```

  5. Para visualizar todos os usuários cadastrados:
     1. <pre>SELECT User FROM mysql.user; ```
  6. Para sair do cliente mysql:
     1. <pre>quit;</pre
2. [🔝](#topo_Index "Retorna ao topo")

---

##### **6.1.2 Como saber os privilégios dos usuários**

1. Entrar no cliente mysql do mariadb:
  1. ```shsudo mysql -h localhost -u root -p```

  2. <pre>SELECT User, Host FROM mysql.user WHERE Host <> 'localhost';```

  3. Para sair do cliente mysql:
     1. <pre>quit;</pre
2. [🔝](#topo_Index "Retorna ao topo")

---

#### **[6.2 - Excluindo usuários](https://mariadb.com/kb/en/drop-user/)**<span id="id_6.2"><span>

1. O DROP USER extrato remove uma ou mais contas MariaDB. Ele remove linhas de privilégios para a conta de todas as tabelas de permissões. Para usar esta instrução, você deve ter o privilégio global CREATE USER ou o privilégio DELETE para o banco de dados mysql. Cada conta é nomeada usando o mesmo formato do CREATE USER extrato; por exemplo 'jeffrey'@'localhost',. Se você especificar apenas a parte do nome de usuário do nome da conta, uma parte do nome do host de '%'será usada. Para obter informações adicionais sobre como especificar nomes de contas, consulte CREATE USER.Observe que, se você especificar uma conta que está conectada no momento, ela não será excluída até que a conexão seja fechada. A conexão não será fechada automaticamente.
  1. Exemplo:
     1. Entrar no cliente mysql do mariadb:
        1. ```shsudo mysql -h localhost -u root -p```
        2. Apaga o usuário:
           1. <pre>DROP  USER  Nome_do_usuário;```
        3. Para sair do cliente mysql:
     1. <pre>quit;</pre
2. [🔝](#topo_Index "Retorna ao topo")

---

### 7. Variáveis ​​de sistema do servidor mariadb<span id="id_7"><span>

1. Como visualizar todas as variáveis de servidor mariadb:
  1. ```shsudo mysqld --verbose --help```

2. Para ver os valores que um servidor usa com base apenas em seus padrões compilados, ignorando as configurações em qualquer arquivo de opção, use este comando:
  1. ```shsudo mysqld --no-defaults --verbose --help```

3. [Opções de inicialização para o mysqld](https://mariadb.com/kb/pt-br/mysqld-startup-options/).
  1. [Todas as opções de mysqld](https://mariadb.com/kb/en/mysqld-options/).
  2. Os parâmetros do mariadb-server está no arquivo /etc/mysql/my.cnf.
     1. Exemplos de configurações customizadas:
        1. [mysqld]
           1. lower_case_table_names=1 //[Os nomes de variáveis e tabelas usam o padrão windows]
           2. datadir =/mysql //[A pasta com os dados](https://mariadb.com/kb/en/server-system-variables/#datadir)
4. [🔝](#topo_Index "Retorna ao topo")

---

### 8. **Como o mariadb lida com letras maiúsculas e minúsculas**<span id="id_8"><span>

1. [Sensibilidade do Identificador de Caso:](https://dev.mysql.com/doc/refman/8.0/en/identifier-case-sensitivity.html)
  1. No MySQL, os bancos de dados correspondem a diretórios dentro do diretório de dados. Cada tabela em um banco de dados corresponde a pelo menos um arquivo no diretório do banco de dados (e possivelmente mais, dependendo do mecanismo de armazenamento). Os gatilhos também correspondem a arquivos. Conseqüentemente, a distinção entre maiúsculas e minúsculas do sistema operacional subjacente desempenha um papel na distinção entre maiúsculas e minúsculas do banco de dados, tabela e nomes de gatilhos. Isso significa que esses nomes não diferenciam maiúsculas de minúsculas no Windows, mas na maioria das variedades do Unix. Uma exceção notável é o macOS, que é baseado em Unix, mas usa um tipo de sistema de arquivos padrão (HFS +) que não faz distinção entre maiúsculas e minúsculas. No entanto, o macOS também oferece suporte a volumes UFS, que diferenciam maiúsculas de minúsculas, assim como em qualquer Unix. Vejo Seção 1.7.1, “Extensões MySQL para SQL padrão” . A _lower_case_table_names_ variável do sistema também afeta como o servidor lida com a diferenciação de maiúsculas e minúsculas do identificador, conforme descrito posteriormente nesta seção.

2. O modo como os nomes das tabelas e bancos de dados são armazenados no disco e usados ​​no MySQL é afetado pela **lower_case_table_names**  variável do sistema.
  **lower_case_table_names** pode assumir os valores mostrados na tabela a seguir. Esta variável não afeta a diferenciação de maiúsculas e minúsculas dos identificadores de gatilho.
  No Unix, o valor padrão **lower_case_table_names** é 0.
  No Windows, o valor padrão é 1.
  No macOS, o valor padrão é 2.
  **lower_case_table_names** só pode ser configurado ao inicializar o servidor.
  **lower_case_table_names** é proibido alterar a configuração após a inicialização do servidor.
  1. Valores da variável [lower_case_table_names](https://mariadb.com/kb/en/server-system-variables/#lower_case_table_names).
     1. _**0 (zero)**_
        1. Os nomes de tabelas e bancos de dados são armazenados no disco usando as letras maiúsculas especificadas na instrução **CREATE TABLE** ou **CREATE DATABASE**. As comparações de nomes diferenciam maiúsculas de minúsculas. Você não deve definir esta variável como 0 se estiver executando o MySQL em um sistema que tenha nomes de arquivo que não diferenciam maiúsculas de minúsculas (como Windows ou macOS). Se você forçar essa variável para 0 **--lower-case-table-names = 0** em um sistema de arquivos que não faz MyISAM distinção entre maiúsculas e minúsculas e acessar nomes de tabelas usando diferentes maiúsculas e minúsculas , o índice poderá ser corrompido.
     2. _**1 (um)**_  Obs: Penso que o ideal é não diferenciar maiúsculas de minúsculas.
           1. Os nomes das tabelas são armazenados em letras minúsculas no disco e as comparações de nomes não diferenciam maiúsculas de minúsculas. O MySQL converte todos os nomes de tabelas em letras minúsculas no armazenamento e na pesquisa. Esse comportamento também se aplica a nomes de banco de dados e aliases de tabela.
     3. _**2 (dois)**_
        1. Os nomes de tabelas e bancos de dados são armazenados em disco usando letras maiúsculas especificadas na instrução **CREATE TABLE** ou **CREATE DATABASE**, mas o MySQL os converte em minúsculas na pesquisa. As comparações de nomes não diferenciam maiúsculas de minúsculas. Isso funciona apenas em sistemas de arquivos que não fazem distinção entre maiúsculas e minúsculas! InnoDB nomes de tabelas e nomes de visualizações são armazenados em letras minúsculas, assim como para **lower_case_table_names=1**.
3. [🔝](#topo_Index "Retorna ao topo")

---

## REFERÊNCIAS<span id="id_referencias"><span>

1. [1. MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
2. [Como-alterar-a-base-de-dados-padrao-do-MySQL](https://www.vivaolinux.com.br/dica/Como-alterar-a-base-de-dados-padrao-do-MySQL)
3. [mysql_secure_installation](https://mariadb.com/kb/en/mysql_secure_installation/)
4. [Como ajustar a segurança do Banco de dados](https://mariadb.com/kb/en/mysql_secure_installation/)
5. [using-mysqld_install_db](https://mariadb.com/kb/en/mysql_install_db/#using-mysqld_install_db)
6. [Variáveis ​​de sistema do servidor](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_lower_case_table_names)
7. [🔝](#topo_Index "Retorna ao topo")

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); </script>
[🔝🔝](#topo "Retorna ao topo")