
<!-- markdownlint-disable-next-line -->
<div class="topnav" id="myTopnav"><div w3-include-html="/menu.inc"></div></div>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

#### O QUE É LINGUAGEM SQL <a href="o_que_e_sql.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a> <span id="topo_Index"><span>

## **1. INDEX**

---

1. [O que é Linguagem SQL](#id_01)
2. [Comandos SQL mais importantes](#id_02)
   1. [RECORDS](#id_02_01)
   2. [DATABASE](#id_02_02)
   3. [TABLE](#id_02_03)
   4. [INDEX](#id_02_04)
   5. [TRANSAÇÕES](#id_02_05)
   6. [VIEWS](#id_02_06)
3. [REFERÊNCIAS](#id_referencias)

## **2. CONTEÚDO**

---

### **1. O que é Linguagem SQL**<span id=id_01></span>

 1. Structured Query Language, ou Linguagem de Consulta Estruturada ou SQL, é a linguagem de pesquisa declarativa padrão para banco de dados relacional (base de dados relacional). Muitas das características originais do SQL foram inspiradas na álgebra relacional. O SQL foi desenvolvido originalmente no início dos anos 70 nos laboratórios da IBM em San Jose, dentro do projeto System R, que tinha por objetivo demonstrar a viabilidade da implementação do modelo relacional proposto por E. F. Codd. O nome original da linguagem era SEQUEL, acrônimo para "Structured English Query Language" (Linguagem de Consulta Estruturada, em Inglês), vindo daí o facto de, até hoje, a sigla, em inglês, ser comumente pronunciada "síquel" ao invés de "és-kiú-él", letra a letra. No entanto, em português, a pronúncia mais corrente é letra a letra: "ésse-quê-éle". [Veja mais...](https://pt.wikipedia.org/wiki/SQL)
    1. Bons tutoriais que encontrei na web.:
       1. [Tutorial w3schools.com/sql](https://www.w3schools.com/sql/default.asp);
       2. [mysqltutorial.org](https://www.mysqltutorial.org/)
          1. [basic-mysql-tutorial](https://www.mysqltutorial.org/basic-mysql-tutorial.aspx)
          2. [introduction-to-sql-stored-procedures](https://www.mysqltutorial.org/introduction-to-sql-stored-procedures.aspx)
          3. [mysql-triggers](https://www.mysqltutorial.org/mysql-triggers.aspx)
          4. [mysql-views-tutorial](https://www.mysqltutorial.org/mysql-views-tutorial.aspx)
          5. [mysql-index](https://www.mysqltutorial.org/mysql-index/)
 2. Dicas:
    1. Não há diferença entre maiúsculas e minusculas como na linguagem c++.
    2. A linguagem é interpretada.
    3. Existe um padrão na linguagem sql chamado _ansi sql_ ou _sql 92_, porém o mesmo não é seguido pelos fabricantes de banco de dados.
    4. O sql além de armazenar dados é possível fazer programas a serem executados ao incluir ou excluir ou alterar um registro das tabelas.
    5. O mysql não tem opção de depurar programas.
    6. [Dicas de como depurar sql](http://campeche.inf.furb.br/tccs/2012-II/TCC2012-2-10-VF-FabianoBender.pdf).
    7. [Comparativo entre mysql x postgreSQL](https://www.devmedia.com.br/postgresql-x-mysql-qual-escolher/3923).
    8. [MySQL UUID Smackdown: UUID vs. INT para chave primária](https://www.mysqltutorial.org/mysql-uuid/)
    9. [Dicas de MySQL](https://www.mysqltutorial.org/mysqltips.aspx)
 3. [🔝](#topo_Index "Retorna ao topo")  

### **2. Comandos SQL mais importantes**<span id=id_02></span>

<span id=id_02_01></span>

 1. <span id=id_02_02></span>[**DATABASE**](https://mariadb.com/kb/pt-br/create-database/)
    1. [CREATE DATABASE - cria um novo banco de dados](https://www.w3schools.com/sql/sql_create_db.asp)
       1. **Sintaxe**:

            ```sql

               CREATE DATABASE databasename;

            ```

       2. **Exemplo**:
          1. A seguinte instrução SQL cria um banco de dados chamado "testDB":

             ```sql

             CREATE DATABASE testDB;

             ```

       3. **NOTA**:
          1. _Certifique-se de ter privilégios de administrador antes de criar qualquer banco de dados. Uma vez que um banco de dados é criado, você pode verificá-lo na lista de bancos de dados com o seguinte comando SQL:_

            ```sql

             SHOW DATABASES;

            ```

       4. [Veja mais...](https://www.w3schools.com/sql/sql_create_db.asp)

    2. DROP DATABASE - A instrução **DROP DATABASE** é usada para eliminar um banco de dados SQL existente.
       1. **Sintaxe**:

          ```sql

            DROP DATABASE databasename;

          ```

       2. **Exemplo**:
          1. A seguinte instrução SQL elimina o banco de dados existente "testDB":

             ```sql

               DROP DATABASE testDB;

             ```

       3. **NOTA**:
          1. _Certifique-se de ter privilégios de administrador antes de descartar qualquer banco de dados. Uma vez que um banco de dados é descartado, você pode verificá-lo na lista de bancos de dados com o seguinte comando SQL: SHOW DATABASES;_

             ```sql

                 SHOW DATABASES;

             ```

          2. A instrução acima não funciona no prompt do banco de dados sqlite.

       4. [Veja mais...](https://www.w3schools.com/sql/sql_drop_db.asp)

    3. [ALTER DATABASE - modifica um banco de dados](https://mariadb.com/kb/pt-br/alter-database/)
       1. Exemplo para alterar o CHARSET e COLLATION de um banco existente:
          1. <pre>ALTER DATABASE `sua_base`
                     CHARSET = Latin1
                     COLLATE = latin1_swedish_ci; //Não distingue letras minúsculas e maiúsculas e nem caracteres acentuados e com cedilha, ou seja, o registro que contém a palavra “Intuição” será retornado quando houver uma procura pela palavra “intúicao”.
             </pre>
          2. <pre>ALTER DATABASE `sua_base`
                     CHARSET = UTF8
                     COLLATE = utf8_general_ci; // Não há distinção entre letras maiúsculas e minúsculas. Buscando por “teste”, registros como “Teste” ou “TESTE” serão retornados.
              </pre>

    4. [DROP DATABASE - Apaga o Banco de dados](https://www.w3schools.com/sql/sql_drop_db.asp).
    5. A instrução DROP DATABASE é usada para eliminar um banco de dados SQL existente.
       1. Sintaxe:
          1. <pre>DROP DATABASE databasename;</pre>

          2. A seguinte instrução SQL elimina o banco de dados existente "testDB":
             1. <pre>DROP DATABASE testDB;</pre>

 2. **RECORDS**

    1. **SELECT** - A instrução **SELECT** é usada para selecionar dados de um banco de dados. Os dados retornados são armazenados em uma tabela de resultados, chamada de conjunto de resultados.
       1. **Sintaxe**:

          ```sql

             SELECT column1, column2, ... FROM table_name; 

           ```

       2. **Exemplo**:
          1. Para selecionar todos os campos de uma tabela:

             ```sql

                 SELECT * FROM table_name; 

             ```

       3. [Veja mais...](https://www.w3schools.com/sql/sql_select.asp)

    2. **UPDATE** - A instrução **UPDATE** é usada para modificar os registros existentes em uma tabela.
       1. **Sintaxe**:

          ```sql

             UPDATE table_name
                   SET column1 = value1, column2 = value2, ...
                   WHERE condition;
          ```

       2. **Exemplo**:
          1. A instrução SQL a seguir atualiza o primeiro cliente (CustomerID = 1) com uma nova pessoa de contato e uma nova cidade.

          ```sql

            UPDATE Customers
                   SET ContactName='Alfred Schmidt', City='Frankfurt'
                   WHERE CustomerID=1;

          ```

       3. _**NOTA**_
          1. _Tenha cuidado ao atualizar registros em uma tabela! Observe a cláusula **WHERE** na declaração **UPDATE**. A cláusula **WHERE** especifica quais registros devem ser atualizados. Se você omitir a cláusula **WHERE**, todos os registros da tabela serão atualizados!_

       4. [Veja mais..](https://www.w3schools.com/sql/sql_update.asp)

    3. DELETE - exclui dados de um banco de dados
       1. Sintaxe:
          1. <pre>DELETE FROM table_name
                     WHERE condition;
             </pre>
       2. A seguinte instrução SQL exclui o cliente "Alfreds Futterkiste" da tabela "Clientes":
          1. <pre>DELETE FROM Customers
                     WHERE CustomerName='Alfreds Futterkiste';
             </pre>

    4. INSERT INTO - insere novos dados em um banco de dados
       1. Sintaxe:
          1. <pre>INSERT INTO table_name
                          (column1, column2, column3, ...)
                   VALUES (value1, value2, value3, ...);
             </pre>
       2. Se você estiver adicionando valores para todas as colunas da tabela, não será necessário especificar os nomes das colunas na consulta SQL. No entanto, certifique-se de que a ordem dos valores esteja na mesma ordem das colunas da tabela. A sintaxe INSERT INTO seria a seguinte:
          1. <pre>INSERT INTO table_name
                     VALUES (value1, value2, value3, ...);
             </pre>
       3. A seguinte instrução SQL insere um novo registro na tabela "Clientes":
          1. <pre>INSERT INTO Customers
                    (CustomerName, ContactName, Address, City, PostalCode, Country)
                    VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');
             </pre>
       4. A seguinte instrução SQL insere 3 registros na tabela "books":
          1. <pre>INSERT INTO books
                     (title, author_id, isbn, year_pub)
                  VALUES('The Trial', '1', '0805210407', '1995'),
                        ('The Metamorphosis', '1', '0553213695', '1995'),
                        ('America', '1', '0805210644', '1995');
             </pre>
    5. [🔝](#topo_Index "Retorna ao topo")  

    6. [🔝](#topo_Index "Retorna ao topo")  

 3. <span id=id_02_03></span>[**TABLE**](https://mariadb.com/kb/en/create-table/)

    1. [CREATE TABLE - cria uma nova tabela](https://www.w3schools.com/sql/sql_create_table.asp).
       1. Sintaxe:
          1. <pre>CREATE TABLE table_name (
                      column1 datatype,
                      column2 datatype,
                      column3 datatype,
                      ....);
              </pre>
          2. O exemplo a seguir cria uma tabela chamada "Persons" que contém cinco colunas: PersonID, LastName, FirstName, Address e City:
             1. <pre>CREATE TABLE Persons (
                         PersonID int,
                         LastName varchar(255),
                         FirstName varchar(255),
                         Address varchar(255),
                         City varchar(255));
                </pre>

    2. [ALTER TABLE - modifica uma tabela](https://www.w3schools.com/sql/sql_alter.asp)
       1. Sintaxe para adicionar uma coluna a uma tabela:
          1. <pre>ALTER TABLE table_name
                    ADD column_name datatype;
             </pre>
       2. O seguinte SQL adiciona uma coluna "Email" à tabela "Customers":
          1. <pre>ALTER TABLE Customers
                    ADD Email varchar(255);
             </pre>

    3. [DROP TABLE - exclui uma tabela](https://www.w3schools.com/sql/sql_drop_table.asp)
       1. A instrução DROP TABLE é usada para eliminar uma tabela existente em um banco de dados.
          1. Sintaxe:
             1. <pre>DROP TABLE table_name;</pre>

          2. A seguinte instrução SQL elimina a tabela existente "Shippers":
             1. <pre>DROP TABLE Shippers; </pre>

    4. [🔝](#topo_Index "Retorna ao topo")  

 4. <span id=id_02_04></span>[**INDEX**](https://mariadb.com/kb/pt-br/create-index/)

    1. Observação: a sintaxe para criar índices varia entre os diferentes bancos de dados. Portanto: Verifique a sintaxe para criar índices em seu banco de dados.

       1. [Dicas boas sobre index](https://www.w3schools.com/sql/sql_create_index.asp) 
       2. [Sintaxe do MySql](https://dev.mysql.com/doc/refman/8.0/en/create-index.html):

          1. CREATE INDEX - Cria um índice em uma tabela. Valores duplicados são permitidos:
              1. Sintaxe:
                 1. <pre>CREATE INDEX index_name
                           ON table_name (column1, column2, ...);
                    </pre>

              2. A instrução SQL abaixo cria um índice denominado "idx_lastname" na coluna "LastName" da tabela "Pessoas":
                 1. <pre>CREATE INDEX idx_lastname
                           ON Persons (LastName);
                     </pre>

              3. Se quiser criar um índice em uma combinação de colunas, você pode listar os nomes das colunas entre parênteses, separados por vírgulas
                 1. <pre>CREATE INDEX idx_pname
                           ON Persons (LastName, FirstName);
                    </pre>

          2. CREATE UNIQUE INDEX - Cria um índice exclusivo em uma tabela. Valores duplicados não são permitidos:
             1. Sintaxe:
                1. <pre>CREATE UNIQUE INDEX index_name
                           ON table_name (column1, column2, ...);
                   </pre>

          3. DROP INDEX - A instrução DROP INDEX é usada para excluir um índice em uma tabela.
             1. Sintaxe:
                1. <pre>ALTER TABLE table_name
                           DROP INDEX index_name;
                   </pre>

    2. [🔝](#topo_Index "Retorna ao topo")  

 5. <span id=id_02_05></span>**[TRANSAÇÕES](https://mariadb.com/kb/en/transactions/)**
    1. [START TRANSACTION](https://mariadb.com/kb/en/start-transaction/)
       1. .
    2. [COMMIT](https://mariadb.com/kb/en/commit/)
       1. .
    3. [ROLLBACK](https://mariadb.com/kb/en/rollback/)
       1. .
    4. [SET TRANSACTION](https://mariadb.com/kb/en/set-transaction/)
       1. .
    5. [LOCK TABLES](https://mariadb.com/kb/en/lock-tables/)
       1. .
    6. [UNLOCK TABLES](https://mariadb.com/kb/en/transactions-unlock-tables/)
       1. .
 6. [🔝](#topo_Index "Retorna ao topo")  

 7. <span id=id_02_06></span> [**VIEWS**](https://mariadb.com/kb/en/foreign-keys/)
    1. Uma chave estrangeira é uma restrição que pode ser usada para impor a integridade dos dados. É composto por uma coluna (ou conjunto de colunas) em uma tabela chamada tabela filho, que faz referência a uma coluna (ou conjunto de colunas) em uma tabela chamada tabela pai. Se chaves estrangeiras são usadas, MariaDB executa algumas verificações para garantir que algumas regras de integridade sejam sempre aplicadas. Para uma explicação mais completa, consulte Bancos de dados relacionais: Chaves estrangeiras .
       1. As chaves estrangeiras (FOREIGN KEY) só podem ser usadas com mecanismos de armazenamento que as suportem. O InnoDB padrão e o PBXT obsoleto oferecem suporte a chaves estrangeiras.
       2. As tabelas particionadas não podem conter chaves estrangeiras e não podem ser referenciadas por uma chave estrangeira.
    2. As chaves estrangeiras são criadas com CREATE TABLE ou ALTER TABLE . A definição deve seguir esta sintaxe:
       1. <pre>[CONSTRAINT [symbol]] FOREIGN KEY
               [index_name] (index_col_name, ...)
               REFERENCES tbl_name (index_col_name,...)
               [ON DELETE reference_option]
               [ON

               reference_option:

                  RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT</pre>.

    3. [Exemplos](https://mariadb.com/kb/en/foreign-keys/).
       1. Vamos ver um exemplo. Vamos criar uma tabela author  e uma tabela book. Ambas as tabelas têm uma chave primária chamada author_id também possui uma chave estrangeira composta por um campo chamado author_id, que se refere à author chave primária. O nome da restrição de chave estrangeira é opcional, mas vamos especificá-lo porque queremos que ele apareça em mensagens de erro: fk_book_author.
          1. <pre>CREATE TABLE author (
                     id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                     name VARCHAR(100) NOT NULL
                  ) ENGINE = InnoDB;

                  CREATE TABLE book (
                     id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                     title VARCHAR(200) NOT NULL,
                     author_id SMALLINT UNSIGNED NOT NULL,

                     CONSTRAINT `fk_book_author`
                     FOREIGN KEY (author_id) REFERENCES author (id)
                        ON DELETE CASCADE
                        ON UPDATE RESTRICT
                  ) ENGINE = InnoDB;
          </pre>

    4. [Dicas em www.w3schools.com](https://www.w3schools.com/sql/sql_foreignkey.asp)

    5. [🔝](#topo_Index "Retorna ao topo")  

## **3. REFERÊNCIAS**<span id=id_referencias></span>

---

 1. [Tutorial w3schools.com/sql](https://www.w3schools.com/sql/default.asp)
 2. [wikipedia.org/wiki/SQL)](https://pt.wikipedia.org/wiki/SQL)
 3. [Artigos MariaDB para iniciantes](https://mariadb.com/kb/en/beginner-mariadb-articles/)
    1. [MariaDB Basics](https://mariadb.com/kb/en/mariadb-basics/)
    2. [Obtendo dados de MariaDB](https://mariadb.com/kb/en/getting-data-from-mariadb/)
 4. [Restrição SQL FOREIGN KEY](https://www.w3schools.com/sql/sql_foreignkey.asp)
 5. [Para saber onde estão as bases de dados fisicamente](http://www.help.market.com.br/linux/index.html?reiniciar_o_servico_do_postgre.htm)

 6. [🔝](#topo_Index "Retorna ao topo")  

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); </script>
[🔝🔝](#topo "Retorna ao topo")