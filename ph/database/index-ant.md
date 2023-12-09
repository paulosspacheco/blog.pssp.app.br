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
6. [convênios](./Convenios.html)
7. [clientes](./clientes.index)
8. [Integração](./Integracao.html)
9. [Expediente_do_medico_data](./expediente_do_medico_data)
10. [Expediente_do_medico_horas](./expediente_do_medico_horas.html)
11. [Agenda](./agenda.html)
12. [Formas_de_Pagamento](./formas_de_pagamento.html)
13. [Consulta](./consulta.html)

## Diagrama 01 - Relacionamentos visão 1-->n

<pre><code class="language-mermaid"><div class="mermaid">

graph TD

graph_title[Assistente Virtual]

A[Operadores] --> |1-n| B(medicos)
%% O operador é responsável por alimentar os arquivos necessários
%% e que não interessa ao médico

B[medicos] --> |1-n| b(Hospitais)  
%% Hospitais que o médico atende.

B --> |1-n| C(Expediente do medico data)

C --> |1-n| D(Expediente do médico horas)

D --> |1-1| E(clientes)

E --> |1-n| F(Agenda)
  %% A agenda deve conter os campos:
    %% Id_medico
    %% Id_Cliente
    %% Data
    %% Hora
    %% Id_Natureza_da_interaçãoo
    %% Comentário

F --> |n-1| n(natureza da interação)
%% A natureza da interação pode ser:
  %% 0 - Consulta Agendada
  %% 1 - Consulta Cancelada

B --> |1-n| G(convênios)

B --> |1-n| E(clientes)

</div></code></pre>

## Diagrama 02 - Relacionamentos visão n-->1

<pre><code class="language-mermaid"><div class="mermaid">

flowchart TD
    %%{init: {"flowchart": {"htmlLabels": false}} }%%

      1[("`
      **1. Operadores**
         id
         Nome
         Telefone`")]

      2[("`
      **2. Hospitais**
            id
            Nome
            Telefone`")]

      3[("`
      **3. natureza da interação**
            id
            nome `")]

      4[("`
      **4. Médicos**
      Id
      Id_Operadores
      Nome
      Telefone
      Telefone_da_secretaria
      Login
      Senha`")]

      5[("`
      **5. Serviço_de_agendas**
           id
           Nome
           Login
           Senha `")]

      6[("`
      **6. convênios**
           Id
           Nome
           Login
           Senha `")]

      7[("`
      **7. clientes**
           Id;
           Nome;
           Telefone_WhatsApp;
           e-mail
           Login
           senha
           Id_Convênio
           DataTime_disponível
           Matricula_no_convênio
           `")]

      8[("`
      **8. Integração**
           id
           endereço_do_site
           login
           senha
           status `")]
      9[("`
      **9. Expediente_do_medico_data**
           id_medico
           Data
       `")]

      10[("`
      **10. Expediente_do_medico_horas**
            Id_Medico
            Data
            DataTime_inicial
            DataTime_final
            `")]

      11[("`
      **11. Agenda**
            Id
            Id_Medico
            Id_Cliente
            DataTime
            DataTime_confirmação
            Id_Convênio
            Id_Natureza_da_Interação
            Observações
        `")]

      12[("`
      **12. Formas_de_Pagamento**
            id
            Nome
        `")]

      13[("`
      **13. Consulta**
            id
            id_agenda
            if_cliente
            id_medico
            DataTime
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
11 --> |1-1| 13
4 --> |n-1| 13
6 --> |n-1| 13
7 --> |n-1| 13

</div></code></pre>


<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")
