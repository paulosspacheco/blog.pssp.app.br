<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>

# Diagramas do projeto
- [Diagramas do projeto](#diagramas-do-projeto)
  - [Diagrama do Entidade e Relacionamentos (DER)](#diagrama-do-entidade-e-relacionamentos-der)
  - [Diagrama do projeto que deu origem ao gráfico acima](#diagrama-do-projeto-que-deu-origem-ao-gráfico-acima)
  - [Referências](#referências)

## Diagrama do Entidade e Relacionamentos (DER)

<pre><code class="language-mermaid"><div class="mermaid">

classDiagram

  class operadores {
    +id: Integer
    +nome: String(50) not null
    +login: String(50) not null
    +password: String(50) not null
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
    +data: Date not null
    +hora_inicial: timestamp not null
    +hora_final: timestamp not null
  }

  class agenda {  
    +id: Integer
    +id_Medico: Integer not null
    +id_Cliente: Integer not null
    +data: timestamp not null
    +hora: timestamp not null
    +data_confirmacao: timestamp not null
    +id_convenio: Integer
    +id_status_da_agenda_ou_consulta: Integer not null
    +id_formas_de_pagamento: Integer
    +dataTime_criacao: timestamp not null
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
    +dataTime: timestamp not null
    +id_convenio: Integer
    +id_forma_de_pagamento: Integer
    +id_status_da_agenda_ou_consulta: Integer not null
    +Observacao: String(255)
  }

  operadores "1" -- "1..n" medicos : id_operadores  
  medicos "0" -- "1..n" convenios : id_medico
  clientes "1" -- "0..n" convenios : id_convenio
  clientes "1" -- "1..n" agenda : id_Cliente
  medicos "1" -- "0..n" expediente_do_medico_data : id_medico
  expediente_do_medico_data "1" -- "1..n" medicos : id_medico
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
        +login: String(50) not null
        +password: String(50) not null        
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
        +data: Date not null
        +hora_inicial: timestamp not null
        +hora_final: timestamp not null              
      }
      
      class agenda {
        +id: Integer
        +id_Medico: Integer not null
        +id_Cliente: Integer not null
        +data: timestamp not null
        +hora: timestamp not null
        +data_confirmacao: timestamp not null
        +id_convenio: Integer
        +id_status_da_agenda_ou_consulta: Integer not null
        +id_formas_de_pagamento: Integer
        +dataTime_criacao: timestamp not null
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
        +dataTime: timestamp not null
        +id_convenio: Integer
        +id_forma_de_pagamento: Integer
        +id_status_da_agenda_ou_consulta: Integer not null
        +Observacao: String(255)
      }

     class dm_xtable {
        +id:integer
        +nome String(50)
        +endereco String(255)    
        +cnpj String(18)  
        +cpf String(14)
        +cep String(10)
        +valor_SMALLINT SMALLINT
        +valor_Integer Integer
        +valor_FLOAT8 DOUBLE
        +Data_1 timestamp 
        +hora_1 timestamp    
        +hora_2 timestamp
     }  
);



      operadores "1" -- "1..n" medicos : id_operadores  
      medicos "0" -- "1..n" convenios : id_medico
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

## Referências

1. [Gráfico criado com projeto mermaid](https://mermaid.js.org/syntax/flowchart.html)
2. [PostgreSQL: The World's Most Advanced Open Source](https://www.postgresql.org/)

<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")
