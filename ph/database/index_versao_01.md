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

## Diagrama 01 do banco de dados do projeto

<pre><code class="language-mermaid"><div class="mermaid">

flowchart TD

      1[("`
      **1. operadores**
         id
         nome
         telefone`")]

      2[("`
      **2. hospitais**
            id
            nme
            telefone`")]

      3[("`
      **3. natureza da interação**
            id
            nome `")]

      4[("`
      **4. médicos**
      id
      id_operadores
      nome
      telefone
      telefone_da_secretaria
      login
      senha`")]

      5[("`
      **5. serviço_de_agendas**
           id
           id_operador
           nome
           login
           senha `")]

      6[("`
      **6. convênios**
           id
           nome
           login
           senha `")]

      7[("`
      **7. clientes**
           id;
           nome;
           telefone_whatsApp;
           e-mail
           login
           senha
           id_convênio
           dataTime_disponível
           matricula_no_convênio
           `")]

      8[("`
      **8. integração**
           id
           endereço_do_site
           login
           senha
           status `")]

      9[("`
      **9. expediente_do_medico_data**
           id_medico
           data
       `")]

      10[("`
      **10. expediente_do_medico_horas**
            id_medico
            data
            dataTime_inicial
            dataTime_final
            `")]

      11[("`
      **11. agenda**
            id
            id_medico
            id_cliente
            dataTime
            dataTime_confirmação
            id_convênio
            id_natureza_da_interação
            observações
        `")]

      12[("`
      **12. formas_de_pagamento**
            id
            nome
        `")]

      13[("`
      **13. consulta**
            id
            id_agenda
            if_cliente
            id_medico
            dataTime
            id_Convênio
            id_forma_de_pagamento
         `")]  

1 --> |n-1| 4
4 --> |n-1| 9
4 --> |n-1| 10
4 --> |n-1| 11
7 --> |n-1| 11
6 --> |n-1| 11
3 --> |n-1| 11
12 --> |n-1| 13
11 o--o |1-1| 13
4 --> |n-1| 13
6 --> |n-1| 13
7 --> |n-1| 13

</div></code></pre>

## Diagrama 02 do banco de dados do projeto _ Sugestão Bard do Google

<pre><code class="language-mermaid"><div class="mermaid">

classDiagram

class Operador {
  id: Integer
  nome: String
  telefone: String
}

class Hospital {
  id: Integer
  nome: String
  telefone: String
}

class NaturezaDaInteracao {
  id: Integer
  nome: String
}

class Medico {
  id: Integer
  idOperador: Integer
  nome: String
  telefone: String
  telefoneSecretaria: String
  login: String
  senha: String
}

class ServicoDeAgendas {
  id: Integer
  id_operador:Integer
  nome: String
  login: String
  senha: String
}

class Convenio {
  id: Integer
  idMedico: Integer
  nome: String
  login: String
  senha: String
}

class Cliente {
  id: Integer
  nome: String
  telefoneWhatsapp: String
  email: String
  login: String
  senha: String
  idConvenio: Integer
  dataTimeDisponivel: Date
  matriculaNoConvenio: Integer
}

class Integracao {
  id: Integer
  enderecoDoSite: String
  login: String
  senha: String
  status: Boolean
}

class ExpedienteDoMedicoData {
  idMedico: Integer
  dataTime: Date
}

class ExpedienteDoMedicoHoras {
  idMedico: Integer
  dataTimeInicial: Date
  dataTimeFinal: Date
}

class Agenda {
  id: Integer
  idMedico: Integer
  idCliente: Integer
  dataTime: Date
  dataTimeConfirmacao: Date
  idConvenio: Integer
  idNaturezaDaInteracao: Integer
  idFormasDePagamento: Integer
  observacoes: String
}

class FormasDePagamento {
  id: Integer
  nome: String
}

class Consulta {
  id: Integer
  idAgenda: Integer
  Cliente: Boolean
  idMedico: Integer
  dataTime: Date
  idConvenio: Integer
  idFormasDePagamento: Integer
}

Operador "1" -- "1..n" Medico
Hospital "1" -- "0..n" Medico
Medico "1" -- "1..n" ExpedienteDoMedicoData
ExpedienteDoMedicoData   "1" -- "1..n" ExpedienteDoMedicoHoras
Medico   "1" -- "1..n" ExpedienteDoMedicoHoras
Medico "1" -- "1..n" Agenda
Cliente "1" -- "1..n" Agenda
NaturezaDaInteracao  "1" -- "1..n" Agenda
Convenio  "1" -- "0..n" Agenda
FormasDePagamento  "1" -- "0..n" Agenda

Medico "1" -- "1..n" Consulta
Agenda "1" -- "0..n" Consulta
Convenio "1" -- "0..n" Consulta
FormasDePagamento  "1" -- "0..n" Consulta



</div></code></pre>

- **Explicação do diagrama**
  - O diagrama de entidade de relacionamento (DER) mostra as relações entre as entidades de um sistema. No caso deste diagrama, as entidades são:
    - Operador
    - Hospital
    - NaturezaDaInteracao
    - Medico
    - ServicoDeAgendas
    - Convenio
    - Cliente
    - Integracao
    - ExpedienteDoMedicoData
    - ExpedienteDoMedicoHoras
    - Agenda
    - FormasDePagamento
    - Consulta

  - As relações entre essas entidades são:
    - Operador pode criar Agendas.
    - Operador pode se autenticar em um ServicoDeAgendas.
    - Hospital pode ter Medicos.
    - Medico pode atender a Clientes.
    - Medico pode estar associado a um ou mais Convenios.
    - Cliente pode agendar Consultas.
    - Cliente pode se autenticar em um Integracao.
    - Medico pode ter Expedientes.
    - ExpedienteDoMedicoData e ExpedienteDoMedicoHoras são chaves múltiplas

</div></code></pre>

## Referências

1. [Gráfico criado com projeto mermaid](https://mermaid.js.org/syntax/flowchart.html)

<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")

