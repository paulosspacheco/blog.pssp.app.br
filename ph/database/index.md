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

## Diagrama do banco de dados do projeto

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

## Referências

1. [Gráfico criado com projeto mermaid](https://mermaid.js.org/syntax/flowchart.html)

<!-- markdownlint-disable-next-line -->
</main>
[🔝🔝](#topo "Retorna ao topo")
