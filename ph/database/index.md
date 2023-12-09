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
3. [Natureza da interação](./natureza_da_iinteracao.md)
4. [Medicos](./medicos.html)
5. [Expediente_do_medico_data](./expediente_do_medico_data)
6. [Expediente_do_medico_horas](./expediente_do_medico_horas.html)
7. [Serviços de agenda](./servicos_de_agenda.html)
8. [Convênios](./convenios.html)
9. [clientes](./clientes.index)
10. [Integração](./Integracao.html)
11. [Disponibilidade_do_Paciente](./disponibilidade_do_Paciente.html)
12. [Agenda](./agenda.html)

## Diagrama 01

<pre><code class="language-mermaid"><div class="mermaid">

graph TD

graph_title[Assistente Virtual]

A[Operadores] --> |1-n| B(Medicos)
%% O operador é responsável por alimentar os arquivos necessários
%% e que não interessa ao médico

B[Medicos] --> |1-n| b(Hospitais)  
%% Hospitais que o médico atende.

B --> |1-n| C(Expediente do medico data)

C --> |1-n| D(Expediente do médico horas)

D --> |1-1| E(Clientes)

E --> |1-n| F(Agenda)
  %% A agenda deve conter os campos:
    %% Id_medico
    %% Id_Cliente
    %% Data
    %% Hora
    %% Id_Natureza_da_interaçãoo
    %% Comentário

F --> |n-1| n(Natureza da interação)
%% A Natureza da interação pode ser:
  %% 0 - Consulta Agendada
  %% 1 - Consulta Cancelada

B --> |1-n| G(Convênios)

B --> |1-n| E(Clientes)

</div></code></pre>

## Diagrama 02

<pre><code class="language-mermaid"><div class="mermaid">

flowchart TD
    %%{init: {"flowchart": {"htmlLabels": false}} }%%

      1["`
      **1. Operadores**
         id
         Nome
         Telefone`"]

      2["`
      **2. Hospitais**
            id
            Nome
            Telefone`"]

      3["`
      **3. Natureza da interação**
            id
            nome `"]

      4["`
      **4. Médicos**
           Id
           Id_Operadores
           Nome
           Telefone
           Telefone_da_secretaria
           Login
           Senha`"]

      5["`
      **5. Serviço_de_agendas**
           id
           Nome
           Login
           Senha `"]

      6["`
      **6. Convênios**
           Id
           Nome
           Login
           Senha `"]

      7["`
      **7. clientes**
           Id;
           Nome;
           Telefone_WhatsApp;
           e-mail
           Login
           senha
           Id_Convenio
           Data_disponível
           Hora_disponível
           `"]

      8["`
      **8. Integração**
           id
           endereço_do_site
           login
           senha
           status `"]
      9["`
      **9. Expediente_do_medico_data**
           id_medico
           Data`"]

      10["`
      **10. Expediente_do_medico_horas**
            Id_Medico
            Data
            Hora_inicial
            Hora_final`"]

      11["`
      **11. Agenda**
            Id
            Id_Medico
            Id_Cliente
            Data
            Hora
            Id_Convenio
            Id_Natureza_da_Interação
            Observações`"]

1 --> |n-1| 4
4 --> |n-1| 9
4 --> |n-1| 10
4 --> |n-1| 11
7 --> |n-1| 11
6 --> |n-1| 11
3 --> |n-1| 11

</div></code></pre>

<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")
