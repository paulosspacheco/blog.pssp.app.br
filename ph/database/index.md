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

1. [Medicos](./medicos.html)
2. [Expediente_do_medico_data](./expediente_do_medico_data)
3. [Expediente_do_medico_horas](./expediente_do_medico_horas.html)
4. [Serviços de agenda](./servicos_de_agenda.html)
5. [Convênios](./convenios.html)
6. [clientes](./clientes.index)
7. [Integração](./Integracao.html)
8. [Disponibilidade_do_Paciente](./disponibilidade_do_Paciente.html)
9. [Agenda](./agenda.html)

## Fluxograma do projeto

<pre><code class="language-mermaid"><div class="mermaid">

graph TD

graph_title[Assistente Virtual]
A[Operadores] --> B(*️⃣ Medicos)
B --> C(*️⃣ Expediente do medico data)
C --> D(*️⃣ Expediente do médico horas)
D --> E(1️⃣ Clientes)
E --> F(1️⃣ Agenda)
B --> G(*️⃣ Convênios)
B --> E(*️⃣ Clientes)

</div></code></pre>

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
