<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>

# Banco de dados do projeto

## Cadastros do projeto

1. [Operadores](./operadores.md)
2. [hospitais](./hospitais.md).
3. [natureza da interação](./natureza_da_iinteracao.md)
4. [medicos](./medicos.html)
5. [serviços de agenda](./servicos_de_agenda.html)
6. [convênios](./convenios.html)
7. [clientes](./clientes.index)
8. [Integração](./integracao.html)
9. [Expediente_do_medico_data](./expediente_do_medico_data)
10. [Expediente_do_medico_horas](./expediente_do_medico_horas.html)
11. [Agenda](./agenda.html)
12. [Formas_de_Pagamento](./formas_de_pagamento.html)
13. [Consulta](./consulta.html)

## Diagrama do Entidade e Relacionamentos (DER)

<pre><code class="language-mermaid"><div class="mermaid">

classDiagram

  class operadores {
    +id: Integer
    +nome: String(50) not null
    +telefone: String(20)
  }

  class hospitais {
    +id: Integer
    +nome: String(50)
    +telefone: String(20)
  }

  class status_da_agenda_ou_consulta {
    +id: Integer
    +nome: String(20)
  }

  class medicos {
    +id: Integer
    +id_operadores: Integer
    +nome: String(50)
    +telefone: String(25)
    +telefone_da_secretaria: String(25)
    +login: String(50)
    +senha: String(20)
  }

  class servico_de_agendas {
    +id: Integer
    +id_operador: Integer
    +nome: String(100)
    +login: String(50)
    +senha: String(50)
  }

  class convenios {
    +id: Integer
    +id_medico: Integer
    +nome: String(50)
    +login: String(50)
    +senha: String(50)
  }

  class clientes {
    +id: Integer
    +nome: String(50) not null
    +telefone_whatsApp: String(25)
    +e_mail: String(50)
    +login: String(50) not null
    +senha: String(20) not null
    +id_convenio: Integer
    +dataTime_disponivel: Date
    +matricula_no_convenio: String(50)
  }

  class integracao {
    +id: Integer
    +endereco_do_site: String(255) not null
    +login: String(50) not null
    +senha: String(20) not null
    +status: Boolean not null
  }

  class expediente_do_medico_data {
    +id_medico: Integer not null
    +dataTime: Date not null
  }

  class expediente_do_medico_horas {
    +id_expediente_do_medico_data: Integer not null
    +dataTime_inicial: DateTime not null
    +dataTime_final: DateTime not null
  }

  class agenda {
    +id: Integer
    +id_Medico: Integer not null
    +id_Cliente: Integer not null
    +dataTime: DateTime not null
    +dataTime_confirmacao: DateTime not null
    +id_convenio: Integer
    +id_status_da_agenda_ou_consulta: Integer not null
    +id_formas_de_pagamento: Integer
    +dataTime_criacao: DateTime not null
    +observacoes: String(255)
  }

  class formas_de_pagamento {
    +id: Integer
    +Nome: String(30) not null
  }

  class consulta {
    +id: Integer
    +id_agenda: Integer
    +id_cliente: Integer not null
    +id_medico: Integer not null
    +dataTime: DateTime not null
    +id_convenio: Integer
    +id_forma_de_pagamento: Integer
    +id_status_da_agenda_ou_consulta: Integer not null
    +Observacao: String(255)
  }

  operadores "1" -- "1..n" medicos : id_operadores  
  medicos "1" -- "1..n" convenios : id_medico
  clientes "1" -- "0..n" convenios : id_convenio
  clientes "1" -- "1..n" agenda : id_Cliente
  medicos "1" -- "1..n" expediente_do_medico_data : id_medico
  expediente_do_medico_data "1" -- "1..n" expediente_do_medico_horas : id_expediente_do_medico_data
  agenda "1" -- "0..1" convenios : id_convenio
  agenda "1" -- "0..1" formas_de_pagamento : id_formas_de_pagamento
  agenda "1" -- "1..n" status_da_agenda_ou_consulta : id_status_da_agenda_ou_consulta
  consulta "1" -- "0..1" convenios : id_convenio
  consulta "1" -- "0..1" formas_de_pagamento : id_forma_de_pagamento
  consulta "1" -- "1..n" status_da_agenda_ou_consulta : id_status_da_agenda_ou_consulta
  medicos "1" -- "1..n" agenda : id_Medico
  
</div></code></pre>

- **Explicação do diagrama**
  - O diagrama de entidade de relacionamento (DER) mostra as relações entre as entidades de um sistema. No caso deste diagrama, as entidades são:
    - Operador
    - Hospital
    - Status_da_agenda_ou_consulta
    - Medico
    - ServiçoDeAgendas
    - Convenio
    - Cliente
    - Integração
    - ExpedienteDoMedicoData
    - ExpedienteDoMedicoHoras
    - Agenda
    - FormasDePagamento
    - Consulta

  - A simbologia usada para indicar os relacionamentos são:
    - _1_ : Indica o lado do relacionamento que só pode conter uma ocorrência.

    - _1..1_ : Indica que o identificador de ambas a tabelas devem ser iguais;
      - Exemplo:
        - Código da _agenda.idCliente_  é obrigatório ser igual a _cliente.id_.

    - _1..n_ : Indica que pelo menos _um_ (1) identificador de uma das tabelas devem ser igual o identificador da outra;
      - Exemplo:
        - O identificador _agenda.idNaturezaDaInteracao_ é obrigatório ser igual ao identificador _NaturezaDaInteracao.id_ e _NaturezaDaInteracao.id_ pode existir mais de uma ocorrência na agenda.
    - _0..n_ : Indica que o relacionamento entre as tabelas é opcional e que pode haver mais de referência de uma tabela na outra;
      - Exemplo:
        - O identificador _Consulta.idAgenda_ é opcional ser igual ao identificador _Agenda.id_ porque o médico pode atender um paciente sem que o mesmo tenha sido agendado.

## Diagrama do projeto que deu origem ao gráfico acima

```mermaid

    classDiagram

      class operadores {
        +id: Integer
        +nome: String(50) not null
        +telefone: String(20)
      }

      class hospitais {
        +id: Integer
        +nome: String(50)
        +telefone: String(20)
      }

      class status_da_agenda_ou_consulta {
        +id: Integer
        +nome: String(20)
      }

      class medicos {
        +id: Integer
        +id_operadores: Integer
        +nome: String(50)
        +telefone: String(25)
        +telefone_da_secretaria: String(25)
        +login: String(50)
        +senha: String(20)
      }

      class servico_de_agendas {
        +id: Integer
        +id_operador: Integer
        +nome: String(100)
        +login: String(50)
        +senha: String(50)
      }

      class convenios {
        +id: Integer
        +id_medico: Integer
        +nome: String(50)
        +login: String(50)
        +senha: String(50)
      }

      class clientes {
        +id: Integer
        +nome: String(50) not null
        +telefone_whatsApp: String(25)
        +e_mail: String(50)
        +login: String(50) not null
        +senha: String(20) not null
        +id_convenio: Integer
        +dataTime_disponivel: Date
        +matricula_no_convenio: String(50)
      }

      class integracao {
        +id: Integer
        +endereco_do_site: String(255) not null
        +login: String(50) not null
        +senha: String(20) not null
        +status: Boolean not null
      }

      class expediente_do_medico_data {
        +id_medico: Integer not null
        +dataTime: Date not null
      }

      class expediente_do_medico_horas {
        +id_expediente_do_medico_data: Integer not null
        +dataTime_inicial: DateTime not null
        +dataTime_final: DateTime not null
      }

      class agenda {
        +id: Integer
        +id_Medico: Integer not null
        +id_Cliente: Integer not null
        +dataTime: DateTime not null
        +dataTime_confirmacao: DateTime not null
        +id_convenio: Integer
        +id_status_da_agenda_ou_consulta: Integer not null
        +id_formas_de_pagamento: Integer
        +dataTime_criacao: DateTime not null
        +observacoes: String(255)
      }

      class formas_de_pagamento {
        +id: Integer
        +Nome: String(30) not null
      }

      class consulta {
        +id: Integer
        +id_agenda: Integer
        +id_cliente: Integer not null
        +id_medico: Integer not null
        +dataTime: DateTime not null
        +id_convenio: Integer
        +id_forma_de_pagamento: Integer
        +id_status_da_agenda_ou_consulta: Integer not null
        +Observacao: String(255)
      }

      operadores "1" -- "1..n" medicos : id_operadores  
      medicos "1" -- "1..n" convenios : id_medico
      clientes "1" -- "0..n" convenios : id_convenio
      clientes "1" -- "1..n" agenda : id_Cliente
      medicos "1" -- "1..n" expediente_do_medico_data : id_medico
      expediente_do_medico_data "1" -- "1..n" expediente_do_medico_horas : id_expediente_do_medico_data
      agenda "1" -- "0..1" convenios : id_convenio
      agenda "1" -- "0..1" formas_de_pagamento : id_formas_de_pagamento
      agenda "1" -- "1..n" status_da_agenda_ou_consulta : id_status_da_agenda_ou_consulta
      consulta "1" -- "0..1" convenios : id_convenio
      consulta "1" -- "0..1" formas_de_pagamento : id_forma_de_pagamento
      consulta "1" -- "1..n" status_da_agenda_ou_consulta : id_status_da_agenda_ou_consulta
      medicos "1" -- "1..n" agenda : id_Medico

  ```

## Script SQL PostgresSQLpara criar as tabelas

  ```SQL

    CREATE TABLE operadores (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(50) NOT NULL,
      telefone VARCHAR(20)
    );

    CREATE TABLE hospitais (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(50),
      telefone VARCHAR(20)
    );

    CREATE TABLE status_da_agenda_ou_consulta (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(20)
    );

    CREATE TABLE medicos (
      id SERIAL PRIMARY KEY,
      id_operadores INTEGER REFERENCES operadores(id),
      nome VARCHAR(50),
      telefone VARCHAR(25),
      telefone_da_secretaria VARCHAR(25),
      login VARCHAR(50),
      senha VARCHAR(20)
    );

    CREATE TABLE servico_de_agendas (
      id SERIAL PRIMARY KEY,
      id_operador INTEGER REFERENCES operadores(id),
      nome VARCHAR(100),
      login VARCHAR(50),
      senha VARCHAR(50)
    );

    CREATE TABLE convenios (
      id SERIAL PRIMARY KEY,
      id_medico INTEGER REFERENCES medicos(id),
      nome VARCHAR(50),
      login VARCHAR(50),
      senha VARCHAR(50)
    );

    CREATE TABLE clientes (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(50) NOT NULL,
      telefone_whatsApp VARCHAR(25),
      e_mail VARCHAR(50),
      login VARCHAR(50) NOT NULL,
      senha VARCHAR(20) NOT NULL,
      id_convenio INTEGER REFERENCES convenios(id),
      dataTime_disponivel DATE,
      matricula_no_convenio VARCHAR(50)
    );

    CREATE TABLE integracao (
      id SERIAL PRIMARY KEY,
      endereco_do_site VARCHAR(255) NOT NULL,
      login VARCHAR(50) NOT NULL,
      senha VARCHAR(20) NOT NULL,
      status BOOLEAN NOT NULL
    );

    CREATE TABLE expediente_do_medico_data (
      id_medico INTEGER NOT NULL REFERENCES medicos(id),
      dataTime DATE NOT NULL,
      PRIMARY KEY (id_medico, dataTime)
    );

    CREATE TABLE expediente_do_medico_horas (
      id_expediente_do_medico_data INTEGER NOT NULL REFERENCES expediente_do_medico_data(id_medico, dataTime),
      dataTime_inicial TIMESTAMP NOT NULL,
      dataTime_final TIMESTAMP NOT NULL,
      PRIMARY KEY (id_expediente_do_medico_data)
    );

    CREATE TABLE formas_de_pagamento (
      id SERIAL PRIMARY KEY,
      Nome VARCHAR(30) NOT NULL
    );

    CREATE TABLE agenda (
      id SERIAL PRIMARY KEY,
      id_Medico INTEGER NOT NULL REFERENCES medicos(id),
      id_Cliente INTEGER NOT NULL REFERENCES clientes(id),
      dataTime TIMESTAMP NOT NULL,
      dataTime_confirmacao TIMESTAMP NOT NULL,
      id_convenio INTEGER REFERENCES convenios(id),
      id_status_da_agenda_ou_consulta INTEGER NOT NULL REFERENCES status_da_agenda_ou_consulta(id),
      id_formas_de_pagamento INTEGER REFERENCES formas_de_pagamento(id),
      dataTime_criacao TIMESTAMP NOT NULL,
      observacoes VARCHAR(255)
    );

    CREATE TABLE consulta (
      id SERIAL PRIMARY KEY,
      id_agenda INTEGER REFERENCES agenda(id),
      id_cliente INTEGER NOT NULL REFERENCES clientes(id),
      id_medico INTEGER NOT NULL REFERENCES medicos(id),
      dataTime TIMESTAMP NOT NULL,
      id_convenio INTEGER REFERENCES convenios(id),
      id_forma_de_pagamento INTEGER REFERENCES formas_de_pagamento(id),
      id_status_da_agenda_ou_consulta INTEGER NOT NULL REFERENCES status_da_agenda_ou_consulta(id),
      observacao VARCHAR(255)
    );


  ```

## Script SQL PostgresSQLpara criar os relacionamentos

  ```SQL

    -- Adicionando chaves estrangeiras

    -- Tabela medicos
    ALTER TABLE medicos ADD CONSTRAINT fk_medicos_operadores FOREIGN KEY (id_operadores) REFERENCES operadores(id);

    -- Tabela servico_de_agendas
    ALTER TABLE servico_de_agendas ADD CONSTRAINT fk_servico_de_agendas_operadores FOREIGN KEY (id_operador) REFERENCES operadores(id);

    -- Tabela convenios
    ALTER TABLE convenios ADD CONSTRAINT fk_convenios_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id);

    -- Tabela clientes
    ALTER TABLE clientes ADD CONSTRAINT fk_clientes_convenios FOREIGN KEY (id_convenio) REFERENCES convenios(id);

    -- Tabela expediente_do_medico_data
    ALTER TABLE expediente_do_medico_data ADD CONSTRAINT fk_expediente_do_medico_data_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id);

    -- Tabela expediente_do_medico_horas
    ALTER TABLE expediente_do_medico_horas ADD CONSTRAINT fk_expediente_do_medico_horas_expediente_do_medico_data FOREIGN KEY (id_expediente_do_medico_data) REFERENCES expediente_do_medico_data(id_medico, dataTime);

    -- Tabela agenda
    ALTER TABLE agenda ADD CONSTRAINT fk_agenda_medicos FOREIGN KEY (id_Medico) REFERENCES medicos(id);
    ALTER TABLE agenda ADD CONSTRAINT fk_agenda_clientes FOREIGN KEY (id_Cliente) REFERENCES clientes(id);
    ALTER TABLE agenda ADD CONSTRAINT fk_agenda_convenios FOREIGN KEY (id_convenio) REFERENCES convenios(id);
    ALTER TABLE agenda ADD CONSTRAINT fk_agenda_status_da_agenda_ou_consulta FOREIGN KEY (id_status_da_agenda_ou_consulta) REFERENCES status_da_agenda_ou_consulta(id);
    ALTER TABLE agenda ADD CONSTRAINT fk_agenda_formas_de_pagamento FOREIGN KEY (id_formas_de_pagamento) REFERENCES formas_de_pagamento(id);

    -- Tabela consulta
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_agenda FOREIGN KEY (id_agenda) REFERENCES agenda(id);
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id);
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id);
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_convenios FOREIGN KEY (id_convenio) REFERENCES convenios(id);
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_forma_de_pagamento FOREIGN KEY (id_forma_de_pagamento) REFERENCES formas_de_pagamento(id);
    ALTER TABLE consulta ADD CONSTRAINT fk_consulta_status_da_agenda_ou_consulta FOREIGN KEY (id_status_da_agenda_ou_consulta) REFERENCES status_da_agenda_ou_consulta(id);

  ```

- **Observações**:
  - Essas chaves estrangeiras garantem a integridade referencial das tabelas, o que significa que os dados nas tabelas relacionadas serão consistentes.
  - Por exemplo, a chave estrangeira fk_medico_operador na tabela medico garante que o valor da coluna id_operador em uma linha da tabela medico sempre existirá em uma linha da tabela operador.


## Script SQL PostgresSQLpara criar os índices das tabelas

  ```SQL

    -- Índices para a tabela operadores
    CREATE INDEX idx_operadores_nome ON operadores (nome);

    -- Índices para a tabela medicos
    CREATE INDEX idx_medicos_nome ON medicos (nome);
    CREATE INDEX idx_medicos_id_operadores ON medicos (id_operadores);

    -- Índices para a tabela servico_de_agendas
    CREATE INDEX idx_servico_de_agendas_nome ON servico_de_agendas (nome);
    CREATE INDEX idx_servico_de_agendas_id_operador ON servico_de_agendas (id_operador);

    -- Índices para a tabela convenios
    CREATE INDEX idx_convenios_nome ON convenios (nome);
    CREATE INDEX idx_convenios_id_medico ON convenios (id_medico);

    -- Índices para a tabela clientes
    CREATE INDEX idx_clientes_nome ON clientes (nome);
    CREATE INDEX idx_clientes_login ON clientes (login);
    CREATE INDEX idx_clientes_id_convenio ON clientes (id_convenio);

    -- Índices para a tabela expediente_do_medico_data
    CREATE INDEX idx_expediente_do_medico_data_id_medico ON expediente_do_medico_data (id_medico);
    CREATE INDEX idx_expediente_do_medico_data_dataTime ON expediente_do_medico_data (dataTime);

    -- Índices para a tabela expediente_do_medico_horas
    CREATE INDEX idx_expediente_do_medico_horas_id_expediente_do_medico_data ON expediente_do_medico_horas (id_expediente_do_medico_data);

    -- Índices para a tabela formas_de_pagamento
    CREATE INDEX idx_formas_de_pagamento_nome ON formas_de_pagamento (Nome);

    -- Índices para a tabela agenda
    CREATE INDEX idx_agenda_id_Medico ON agenda (id_Medico);
    CREATE INDEX idx_agenda_id_Cliente ON agenda (id_Cliente);
    CREATE INDEX idx_agenda_dataTime ON agenda (dataTime);
    CREATE INDEX idx_agenda_id_convenio ON agenda (id_convenio);
    CREATE INDEX idx_agenda_id_status_da_agenda_ou_consulta ON agenda (id_status_da_agenda_ou_consulta);
    CREATE INDEX idx_agenda_id_formas_de_pagamento ON agenda (id_formas_de_pagamento);

    -- Índices para a tabela consulta
    CREATE INDEX idx_consulta_id_agenda ON consulta (id_agenda);
    CREATE INDEX idx_consulta_id_cliente ON consulta (id_cliente);
    CREATE INDEX idx_consulta_id_medico ON consulta (id_medico);
    CREATE INDEX idx_consulta_dataTime ON consulta (dataTime);
    CREATE INDEX idx_consulta_id_convenio ON consulta (id_convenio);
    CREATE INDEX idx_consulta_id_forma_de_pagamento ON consulta (id_forma_de_pagamento);
    CREATE INDEX idx_consulta_id_status_da_agenda_ou_consulta ON consulta (id_status_da_agenda_ou_consulta);


  ```

- **Observações**:
  - Após criar as tabelas e as chaves estrangeiras, você poderá inserir dados nas tabelas. Os dados que você insere devem corresponder aos atributos das classes no diagrama de classes.
  - Por exemplo, para inserir um médico na tabela medico, você precisará fornecer os valores para os seguintes atributos:
    - id (auto-incrementado)
    - id_operador
    - nome
    - telefone
    - telefone_secretaria
    - login
    - senha
  - Exemplos de consultas que você pode usar para trabalhar com os dados no banco de dados:
    - Para obter uma lista de todos os médicos:

       ```sql

         SELECT *
         FROM medico;

       ```

    - Para obter uma lista de todos os médicos de um determinado hospital:

       ```sql

        SELECT *
        FROM medico
        WHERE id_hospital = 1;

       ```

    - Para obter uma lista de todas as consultas de um determinado paciente:

       ```sql

        SELECT *
        FROM consulta
        WHERE id_cliente = 1;

       ```

    - Para obter uma lista de todas as consultas de um determinado médico:

       ```sql

        SELECT *
        FROM consulta
        WHERE id_medico = 1;

       ```

## Compartilhar o  acesso ao banco de dados

- Conceder acesso ao banco de dados:

    ```sql

      GRANT ALL PRIVILEGES ON DATABASE mydatabase TO mypartner;
    
    ```

  - Este comando concederá ao seu parceiro todos os privilégios no banco de dados mydatabase.

## Ferramenta que pode ser usada para executar os scripts acima?

- _psql_
  
  - Para executar os scripts acima usando o _psql_, você precisará conectar-se ao banco de dados PostgreSQL. Você pode fazer isso usando o comando psql:

    ```bash

      psql -h <host> -p <port> -d <database> -U <username>

    ```

  - Por exemplo, para conectar-se ao banco de dados PostgreSQL chamado _mydatabase_ no host _localhost_ na porta _5432_, você usaria o seguinte comando:

    ```bash

      psql -h localhost -p 5432 -d mydatabase -U myuser

    ```

  - Uma vez conectado ao banco de dados, você pode executar os scripts acima usando o comando \i:

    ```bash

      \i create_tables.sql

    ```

    - Nota:
      - Este comando irá executar o script _create_tables_.sql, que criará as tabelas necessárias para o diagrama de classes.

- _dbeaver-ce_
  - O _DBeaver Community Edition_ (DBeaver CE) é uma ferramenta de gerenciamento de banco de dados relacional de código aberto. Ele oferece suporte a vários bancos de dados, como MySQL, PostgreSQL, SQLite, Oracle, Microsoft SQL Server, e muitos outros. O DBeaver CE é uma versão gratuita e de código aberto da ferramenta, projetada para ser usada por desenvolvedores, administradores de banco de dados e qualquer pessoa envolvida no gerenciamento e manipulação de bancos de dados.

  - Principais características do DBeaver CE:
    - Conectividade com Múltiplos Bancos de Dados: Oferece suporte a uma ampla variedade de sistemas de gerenciamento de banco de dados, permitindo que os usuários se conectem a diferentes bancos de dados a partir de uma única interface.

    - Interface Gráfica Intuitiva: Possui uma interface de usuário gráfica intuitiva que facilita o desenvolvimento, gerenciamento e consulta de bancos de dados.

    - Editor SQL: Inclui um editor SQL poderoso com realce de sintaxe, conclusão automática e outras funcionalidades que facilitam a escrita e execução de consultas SQL.
    - Gerenciamento de Metadados: Permite a visualização e edição de metadados do banco de dados, como tabelas, índices, procedimentos armazenados, entre outros.
    - Exportação e Importação de Dados: Facilita a transferência de dados entre diferentes fontes, com suporte a várias opções de exportação e importação.
    - Visualização de Dados: Oferece recursos visuais para a visualização de dados, incluindo gráficos e ferramentas de exploração de dados.
    - Suporte a Plugins: Permite a extensão de funcionalidades por meio de plugins, proporcionando flexibilidade para atender a diferentes necessidades.

  - O DBeaver CE é uma escolha popular devido à sua versatilidade e ao fato de ser gratuito e de código aberto. No entanto, é importante observar que existem versões comerciais do DBeaver (DBeaver EE) que oferecem recursos adicionais e suporte aprimorado, mas a versão Community Edition é uma opção robusta para muitos desenvolvedores e administradores de banco de dados.

## Referências

1. [Gráfico criado com projeto mermaid](https://mermaid.js.org/syntax/flowchart.html)
2. [PostgreSQL: The World's Most Advanced Open Source](https://www.postgresql.org/)

<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")

