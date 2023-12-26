<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# COMO INSTALAR O BANCO DE DADOS MARIADB <a href="instalar.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **INDEX**<span id="topo_Index"><span>

---

   1. [Instalar versão do MariaDb da distribuição linux originárias do debian (Ubuntu, Linux Mint, etc)](#id_1)
   2. [Testando o servidor](#id_2)
   3. [Instalar extensões do vscode para acessar mariadb](#id_3)
   4. [HISTÓRICOS](#id_4)
   5. [Como configurar mariadb](./configurar.html)
   6. [REFERÊNCIAS](#id_referencias)

## **CONTEÚDO**<span id="topo_conteudo"><span>

---

### **1. Instalar versão do MariaDb da distribuição linux originárias do debian (Ubuntu, Linux Mint, etc)**<span id="id_1"><span>

---

1. Mais informações sobre instalação do mariadb veja em: <https://mariadb.com/kb/en/installing-mariadb-deb-files/>

   1. Instala o servidor de banco de dados mariadb e seus acessórios:
      1. Código ShellScript

         ```bash

           # Atualiza o repositório:
           sudo update

           # Atualiza o linux para a ultima versão:
           sudo upgrade

           # Instalar o servidor mariadb:
           sudo apt install mariadb-server

         ```

      2. **Permitir acesso remoto**
         1. Se você tiver as **tabelas de ip** habilitadas e quiser se conectar ao banco de dados **MySQL de outra máquina**, você deve abrir uma **porta no firewall** do seu servidor **(a porta padrão é 3306)**. Você **não precisa fazer isso se o aplicativo que usa o MySQL estiver sendo executado no mesmo servidor**.

         2. Execute o seguinte comando para permitir o acesso remoto ao servidor mysql:
            1. Código ShellScript

               ```bash

                  sudo ufw enable
                  sudo ufw allow mysql

               ```

   2. Como instalar a aplicação cliente MariaDb
      1. Código ShellScript

         ```bash

           # Instala a aplicação cliente do mariadb
           sudo apt install mariadb-client

           # Instala a aplicação para criação de backup
           sudo apt install mariadb-backup
  
         ```

      2. **REFERÊNCIAS**
         1. [Documentação do mariadb-cliente](https://mariadb.com/kb/en/mysql-command-line-client)
         2. [Instala a aplicação para criação de backup](https://mariadb.com/kb/en/backup-and-restore-overview/)

   3. [🔝](#topo_Index "Retorna ao topo")

---

### **2. [Testando o servidor](https://dev.mysql.com/doc/refman/5.7/en/testing-server.html)**<span id="id_2"><span>

   1. Código ShellScript

      ```bash

        # Visualiza o número da versão instalada:
        sudo mysqladmin version

        # Visualiza as variáveis do mariadb:
        sudo mysqladmin variables

        # Parar a execução do banco de dados:
        sudo systemctl stop mariadb

        # Iniciar a execução do banco de dados:
        sudo systemctl start mariadb

        # Habilitar mariadb:
        sudo systemctl enable mariadb

        # Visualizar os bancos de dados do mariadb:
        sudo mysqlshow -hlocalhost -u root -p

        # O comando sem parâmetros mostra todos os banco de dados do mariadb:
        sudo mysqlshow

        # O comando com parâmetro (nome de banco de dados) exibe uma lista das tabelas do banco de dados passado no parâmetro:
        sudo mysqlshow mysql

        # Use o programa mysql para selecionar informações de uma tabela do database mysql:
        sudo mysql -e "SELECT User, Host, plugin FROM mysql.user" 

        # Para ver uma listagem completa das opções para o mysqld e seus valores atuais (baseados no seu my.cnf local), execute:
        sudo mysqld --help --verbose

        # Listar o arquivo de log do mariadb :
        sudo systemctl status mariadb.service

        # Listar o status do banco de dados:
        sudo systemctl status mysql.service

        # mysqladmin é uma ferramenta cliente que permite executar comandos administrativos.  
        #   Exemplo para ver a versão do banco de dados:
        sudo mysqladmin -p -u root version

      ```

   2. **REFERÊNCIAS**
       1. **[mysqlshow](https://mariadb.com/kb/en/mysqlshow/)**
       2. ..

   3. [🔝](#topo_Index "Retorna ao topo")

---

### **3. Instalar [extensões do vscode](https://code.visualstudio.com/docs/editor/extension-gallery?pub=clarkyu&ext=vscode-sql-beautify) para acessar mariadb**<span id="id_3"><span>

   1. Instalar extensão [SQL TOOLS](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools).
      1. [Vídeo aula de como usar sql tools](https://www.youtube.com/watch?v=5TVBSrFuCDA).
      2. [Documentação completa do sql tools](https://vscode-sqltools.mteixeira.dev/)
   2. Instalar extensão [SQLTools MySQL/MariaDB](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-mysql)
      1. [Documentação completa de SQLTools MySQL/MariaDB](https://vscode-sqltools.mteixeira.dev/?umd_source=repository&utm_medium=readme&utm_campaign=mysql)
   3. Instalar extensão [SQL Beautify](https://marketplace.visualstudio.com/items?itemName=clarkyu.vscode-sql-beautify) para embeleza SQL.
   4. Instalar extensão [SQL Formatter](https://marketplace.visualstudio.com/items?itemName=adpyke.vscode-sql-formatter)
      1. Essa extensão usa [SQL Formatter Plus](https://github.com/kufii/sql-formatter-plus)
   5. [🔝](#topo_Index "Retorna ao topo")

---

### **4. HISTÓRICOS**<span id="id_4"><span>

#### 27/01/2021

- [x] instalar mariadb server
- [x] Testar conexão com servidor
  - [x] Fazer teste local
  - [x] Fazer teste remoto
- [x] Criar banco de dado db_blogpsspappbr.db

[🔝](#topo_Index "Retorna ao topo")

---

### **REFERÊNCIAS**<span id="id_referencias"><span>

   1. [how-to-install-mysql-on-ubuntu-20-04-pt-requisitos](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04-pt#pr%C3%A9-requisitos)
   2. [MariaDB.com](MariaDB.com)
      1. [getting-installing-and-upgrading-mariadb](https://mariadb.com/kb/en/getting-installing-and-upgrading-mariadb/).
      2. [Distribuições que incluem MariaDB](https://mariadb.com/kb/en/distributions-which-include-mariadb/)
      3. [https://mariadb.com/developers](https://mariadb.com/developers/)
      4. [Documentação em português](https://mariadb.com/kb/pt/documentation/)
      5. [mysql_install_db](https://mariadb.com/kb/en/mysql_install_db/)
      6. [data-directory-initialization.html](https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization.html)
      7. [backup-and-restore-overview](https://mariadb.com/kb/en/backup-and-restore-overview/)
      8. [starting-and-stopping-mariadb-automatically](https://mariadb.com/kb/en/starting-and-stopping-mariadb-automatically/).
      9. [full-list-of-mariadb-options-system-and-status-variables](https://mariadb.com/kb/en/full-list-of-mariadb-options-system-and-status-variables/)
      10. 
   3. Vídeo aula [Servidor MySQL no Ubuntu](https://www.youtube.com/watch?v=1f22RUeiVwI).
   4. [documento mariadb-package-repository-setup-and-usage](https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/).
   5. [install mariadb ubuntu 18 04](https://www.youtube.com/watch?v=bCKxijsiG9M).
   6. [Testando o servidor](https://dev.mysql.com/doc/refman/5.7/en/testing-server.html)
   7. [🔝](#topo_Index "Retorna ao topo")

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")