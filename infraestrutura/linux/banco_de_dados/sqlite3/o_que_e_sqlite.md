<!-- markdownlint-disable-next-line -->
<div class="topnav" id="myTopnav"><div w3-include-html="/menu.inc"></div></div>

<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# O que é banco de dados sqLite<a href="o_que_e_sqlite.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

1. [Resumo do conteúdo](#id_resumo)
2. **Introdução**
    1. [Objetivo.](#id_objetivo)
    2. [Pre-requisitos.](#id_pre_requisitos)
    3. [Benefícios.](#id_beneficios)
    4. [Desvantagens.](#id_desvantagens)
3. [**Conteúdo estudado.**](#id_Conteudo)
    1. [Como instalar no Linux](#id_assunto01)
    2. [Como conectar-se ao banco de dados SQLite](#id_assunto02)
    3. [Lista de comandos do cliente sqlite3](#id_assunto03)
    <!-- 4. [Assunto 04](#id_assunto04)
    4. [Assunto 05](#id_assunto05)
    5. [Assunto 06](#id_assunto06)
    6. [Assunto 07](#id_assunto07)
    7. [Assunto 08](#id_assunto08)
    8. [Assunto 09](#id_assunto09)
    9.  [Assunto 10](#id_assunto10) -->
4. [**Referências globais.**](#id_referencias)
5. [**Histórico.**](#id_historico)

## 2. CONTEÚDO

1. Resumo do conteúdo:<span id="id_resumo"><span>
   1. Descreve um resumo de como foi feito esse documento com as facilidade encontradas para produzi-lo e dificuldade encontrada.

2. **Introdução**

   1. <span id="id_objetivo"><span>**Objetivo:**
      1. [SQLite](https://www.sqlite.org/index.html) é uma biblioteca de linguagem C que implementa um mecanismo de banco de dados SQL pequeno, rápido, independente, de alta confiabilidade e com todos os recursos. **SQLite** é o mecanismo de banco de dados mais usado no mundo. O **SQLite** está embutido em todos os telefones celulares e na maioria dos computadores e vem dentro de inúmeros outros aplicativos que as pessoas usam todos os dias.
      2. [Sobre o SQLite](https://www.sqlite.org/about.html)
      3. <text onclick="goBack()">[🔙]</text>

   2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
      1. Linguagem MySql;
      2. Saber como instalar pacotes no sistema operacional Linux;
      3. <text onclick="goBack()">[🔙]</text>

   3. <span id="id_beneficios"></span>**Benefícios:**
      1. Quando você tem a exigência de ler e escrever direto da unidade de armazenamento.
      2. Facilidade de distribuição do aplicativo porque o pacote é distribuído na mesma pasta do aplicativo;
      3. Linguagem SQL permite geração de consultas complexas com relativa facilidade;
      4. Todos os celulares do mundo tem o sqlite instalado;
      5. O banco de dados SqLite é um arquivo único permitindo backup com facilidade;
      6. Como a aplicação usa SQL, a mesma pode ser adaptada facilmente para outros bancos de dados cliente-servidor, desde que não use nada específico de algum banco de dados em particular.
         1. Exemplo:
            1. Os tipos de dados o Mysql tem mais opções que o sqlite, para ter compatibilidade usar os tipos do sqlite;
            2. [Diagrama de sintaxe do SQLite](https://www.sqlite.org/syntaxdiagrams.html)
      7. <text onclick="goBack()">[🔙]</text>
   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. Não permite controle de usuários, por isso é criado para acesso de único usuário;
      2. A SQLite não tem um mecanismo de autenticação integrado. Os arquivos da base de dados podem ser acessados por qualquer um;
      3. Não é facilmente escalável;
      4. Não é adequada para grandes bases de dados;
      5. <text onclick="goBack()">[🔙]</text>
3. <span id=id_Conteudo></span>**Conteúdo estudado**
   1. <span id=id_assunto01></span>**Como instalar no Linux**
      1. A página do site [w3big](http://www.w3big.com/sqlite/sqlite-installation.html) tem instruções detalhada de como instalar o sqlite.
         1. Instalar no Linux distribuição Debian e seus derivados**.

            ```sh

              # biblioteca compartilhada SQLite 3
              sudo apt install sqlite3

              # Pacote para que o Lazarus reconheça O SQLite 3 na ide.
              # SQLite 3 development files
              sudo apt install libsqlite3-dev
              
              # GUI editor for SQLite databases
              sudo apt install sqlitebrowser

            ```

      2. **Referências:**
         1. [SqLite oficial](https://www.sqlite.org/index.html)
         2. [SQLite vs MySQL – Qual a Diferença e Qual Usar](https://www.hostinger.com.br/tutoriais/sqlite-vs-mysql#:~:text=Diferen%C3%A7a%20de%20arquitetura%20%E2%80%94%20MySQL%20x%20SQLite&text=SQLite%20%C3%A9%20uma%20base%20de,de%20um%20servidor%20para%20rodar.)
         3. [Sintaxe SQL do SQLite](https://www.sqlite.org/lang.html)
         4. [SQLite Tutorial](http://www.w3big.com/pt/sqlite/default.html)
      3. <text onclick="goBack()">[🔙]</text>
   2. <span id=id_assunto02></span>**Como conectar-se ao banco de dados SQLite**
      1. Como criar o banco de dados **DataBase1.db3**?
         1. Entrar no shell do linux e executar os comandos:

            ```sh

              # Abre o cliente SqLite com nome do banco de dados DataBase1.db3
              sqlite3 DataBase1.db3

              # Cria a tabela  tabela1
              CREATE TABLE tabela1(id INT, nome TXT);

              # .EXIT sai do cliente sqLite3 ou pressione Click ^D.
              .EXIT


            ```

            1. **NOTAS**
               1. Para ver todos as opções do cliente **sqlite3** escreva **.help**
               2. Caso o comando **CREATE TABLE** não seja executado o banco de dados não será criado porque não existe tabela dentro dele.
      2. Principais comandos:
         1. **.databases**
            1. Lista todos os bancos de dados da pasta.
         2. **.cd DIRECTORY**
            1. Altere o diretório de trabalho para DIRETÓRIO
      3. **Referências:**
         1. [Cliente sqLite3](https://www.sqlite.org/cli.html)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_assunto03></span>**Lista de comandos do cliente sqlite3**
      1. sqlite> .help
         1. .archive ...
            1. Gerenciar arquivos SQL
         2. .auth ON|OFF
            1. Mostrar retornos de chamada do autorizador
         3. .backup ?DB? FILE
            1. Backup de banco de dados (padrão "principal") para FILE
         4. .bail on|off
            1. Pare depois de acertar um erro. Padrão DESLIGADO
         5. .binary on|off
            1. Ligue ou desligue a saída binária. Padrão DESLIGADO
         6. .cd DIRECTORY
            1. Altere o diretório de trabalho para DIRETÓRIO
         7. .changes on|off
            1. Mostrar o número de linhas alteradas pelo SQL
         8. .check GLOB
             1. Falha se a saída porque .testcase não corresponde
         9. .clone NEWDB
             1. Clone dados em NEWDB do banco de dados existente
         10. .databases
             1. Listar nomes e arquivos de bancos de dados anexados
         11. .dbconfig ?op? ?val?
             1. Listar ou alterar as opções sqlite3_db_config()
         12. .dbinfo ?DB?
             1. Mostrar informações de status sobre o banco de dados
         13. .dump ?TABLE? ...
             1. Renderize todo o conteúdo do banco de dados como SQL
         14. .echo on|off
             1. Ativar ou desativar o eco de comando
         15. .eqp on|off|full|...
             1. Ativar ou desativar o EXPLAIN QUERY PLAN automático
         16. .excel
             1. Exibir a saída do próximo comando na planilha
         17. .exit ?CODE?
             1. Saia deste programa com o código de retorno CODE
         18. .expert
             1. EXPERIMENTAL. Sugerir índices para consultas
         19. .explain ?on|off|auto?
             1. Altere o modo de formatação EXPLAIN. Padrão: automático
         20. .filectrl CMD ...
             1. Execute várias operações sqlite3_file_control()
         21. .fullschema ?--indent?
             1. Mostrar esquema e o conteúdo das tabelas sqlite_stat
         22. .headers on|off
             1. Ativar ou desativar a exibição de cabeçalhos
         23. .help ?-all? ?PATTERN?
             1. Mostrar texto de ajuda para PATTERN
         24. .import FILE TABLE
             1. Importar dados de FILE para TABLE
         25. .imposter INDEX TABLE
             1. Criar tabela impostor TABLE no índice INDEX
         26. .indexes ?TABLE?
             1. Mostrar nomes de índices
         27. .limit ?LIMIT? ?VAL?
             1. Exibir ou alterar o valor de um SQLITE_LIMIT
         28. .lint OPTIONS
             1. Relate possíveis problemas de esquema.
         29. .load FILE ?ENTRY?
             1. Carregar uma biblioteca de extensão
         30. .log FILE|off
             1. Ative ou desative o registro. ARQUIVO pode ser stderr/stdout
         31. .mode MODE ?TABLE?
             1. Definir modo de saída
         32. .nullvalue STRING
             1. Use STRING no lugar de valores NULL
         33. .once (-e|-x|FILE)
             1. Saída para o próximo comando SQL apenas para FILE
         34. .open ?OPTIONS? ?FILE?
             1. Feche o banco de dados existente e reabra FILE
         35. .output ?FILE?
             1. Envie a saída para FILE ou stdout se FILE for omitido
         36. .parameter CMD ...
             1. Gerenciar associações de parâmetros SQL
         37. .print STRING...
             1. Imprimir literal STRING
         38. .progress N
             1. Invocar o manipulador de progresso após cada N opcodes
         39. .prompt MAIN CONTINUE
             1. Substitua os prompts padrão
         40. .quit
             1. Sair deste programa
         41. .read FILE
             1. Ler entrada de FILE
         42. .recover
             1. Recupere o máximo de dados possível de db corrompido.
         43. .restore ?DB? FILE
             1. Restaurar o conteúdo do banco de dados (padrão "principal") de FILE
         44. .save FILE
             1. Gravar banco de dados na memória em FILE
         45. .scanstats on|off
             1. Ativar ou desativar as métricas sqlite3_stmt_scanstatus()
         46. .schema ?PATTERN?
             1. Mostrar as instruções CREATE correspondentes a PATTERN
         47. .selftest ?OPTIONS?
             1. Executar testes definidos na tabela SELFTEST
         48. .separator COL ?ROW?
             1. Alterar os separadores de coluna e linha
         49. .session ?NAME? CMD ...
             1. Criar ou controlar sessões
         50. .sha3sum ...
             1. Calcular um hash SHA3 do conteúdo do banco de dados
         51. .shell CMD ARGS...
             1. Execute o CMD ARGS... em um shell do sistema
         52. .show
             1. Mostrar os valores atuais para várias configurações
         53. .stats ?on|off?
             1. Mostrar estatísticas ou ativar ou desativar estatísticas
         54. .system CMD ARGS...
             1. Execute o CMD ARGS... em um shell do sistema
         55. .tables ?TABLE?
             1. Listar nomes de tabelas que correspondem ao padrão LIKE TABLE
         56. .testcase NAME
             1. Comece a redirecionar a saída para 'testcase-out.txt'
         57. .testctrl CMD ...
             1. Execute várias operações sqlite3_test_control()
         58. .timeout MS
             1. Tente abrir tabelas bloqueadas por milissegundos de MS
         59. .timer on|off
             1. Ativar ou desativar o temporizador SQL
         60. .trace ?OPTIONS?
             1. Saída de cada instrução SQL à medida que é executada
         61. .vfsinfo ?AUX?
             1. Informações sobre o VFS de nível superior
         62. .vfslist
             1. Listar todos os VFSs disponíveis
         63. .vfsname ?AUX?
             1. Imprima o nome da pilha VFS
         64. .width NUM1 NUM2 ...
             1. Definir larguras de coluna para o modo "coluna"

      2. **Referências:**
         1. [Cliente SqLite3](https://www.sqlite.org/cli.html)
         2. [title](link)

      3. <text onclick="goBack()">[🔙]</text>

4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
   1. [Site oficial para produzir este documento](#1)

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

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")