<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>
<!-- 
Esse pacote mermaid é completo porém ocupa quase 1 mg de código
<script type="application/x-javascript" src="/js/bierner.markdown-mermaid.js"></script> -->

<span id="topo"><span>

# Editor de diagrama, fluxogramas e vários tipos de gráficos mermaid em markdown

## Objetivo

- Este código implementa gráficos com a biblioteca _"/js/mermaid.min.js"_.
- Este arquivo não declara a _sintaxe markdown_ para mermaid porque a instalação da extensão _Markdown Preview Mermaid Support_ faz com que toda vêz que se salva um documento markdown, a biblioteca é salva, mesmo não precisando dela e o código é muito grande, por isso estou usando o código _mermaid.min.js_ por ser pequeno e prática.

## As possíveis orientações do Fluxograma são:

- TB - De cima para baixo
- TD - De cima para baixo/igual a de cima para baixo
- BT - De baixo para cima
- RL – Da direita para a esquerda
- LR - Da esquerda para a direita

## Exemplos graph TD

  ```mermaid

     graph TD;
        A(Características?)-->B(O que é Mermaid?);    
        A(Características?)-->C(Aceita comentários?); 
        A(Características?)-->D(Aceita imagem?); 

        B-->f1(É um recurso gráfico editado com editor de texto.);
        C-->f2(Não sei)
        D-->f3(Vou checar)

  ```

  <pre><code class="language-mermaid"><div class="mermaid">

    graph TD;
        A(Características?)-->B(O que é Mermaid?);    
        A(Características?)-->C(Aceita comentários?); 
        A(Características?)-->D(Aceita imagem?); 

        B-->f1(É um recurso gráfico editado com editor de texto.);
        C-->f2(Não sei)
        D-->f3(Vou checar)

</div></code></pre>

## Exemplos de gráfico de setor

  ```mermaid

    pie title Animais de estimação adotados por voluntários
      "Cachorros" : 386
      "Gatos" : 85
      "Ratas" : 15
  
  ```

<pre><code class="language-mermaid"><div class="mermaid">

   pie title Animais de estimação adotados por voluntários
   "Cachorros" : 386
   "Gatos" : 85
   "Ratas" : 15

</div></code></pre>

<pre><code class="language-mermaid"><div class="mermaid">

flowchart LR

A[Hard] -->|Text| B(Round)
B --> C{Decision}
C -->|One| D[Result 1]
C -->|Two| E[Result 2]

</div></code></pre>

## Exemplo listas e markdown

<pre><code class="language-mermaid"><div class="mermaid">

flowchart TD
    %% A linha abaixo é uma diretivas%%
    %%{init: {"flowchart": {"htmlLabels": false}} }%%

    %%Definindo estilo do gráfico%%
    classDef default fill:#e6c07b,stroke:#333,stroke-width:4px;

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
      **3. Natureza da interação**
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
      **6. Convênios**
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
           Id_Convenio
           Data_disponível
           Hora_disponível
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
           Data`")]

      10[("`
      **10. Expediente_do_medico_horas**
            Id_Medico
            Data
            Hora_inicial
            Hora_final`")]

      11[("`
      **11. Agenda**
            Id
            Id_Medico
            Id_Cliente
            Data
            Hora
            Id_Convenio
            Id_Natureza_da_Interação
            Observações`")]

1 --> |n-1| 4
4 --> |n-1| 9
4 --> |n-1| 10
4 --> |n-1| 11
7 --> |n-1| 11
6 --> |n-1| 11
3 --> |n-1| 11

</div></code></pre>

## Exemplo Aplicando estilos

<pre><code class="language-mermaid"><div class="mermaid">

flowchart LR
    A:::foo & B:::bar --> C:::foobar
    classDef foo stroke:#f00
    classDef bar stroke:#0f0
    classDef foobar stroke:#00f
</div></code></pre>

<!-- linkStyle 3 stroke:#ff3,stroke-width:1px,color:red; -->
<!-- linkStyle 1,2,3 color:Red; -->

## Referências

1. [Tutoriais](https://mermaid.js.org/config/Tutorials.html)
2. [Mermaid Live](https://mermaid.live/edit#pako:eNp10VFrwyAQB_CvIvfc9APkrUQZgXUZJi0UfHF6XYUkFqeFEfPdZ5aErR3zzeN3_5NzAGU1Qg7oqJHvTnaiJ-kUh7qp9oyTMW63cSCUPZdHxk_ZjlLO6prk5CI_HmyMWWYHUnGaLjm5tlLhP6Z8OVZlwZIS0Br51iI5Wydg1n-mPSQ7VGhua_aaNaH4g5S9oVvIXPsNsrJh-6RMr9qg16hXXtFD0WTFrmFPFT-tLUv9O7X30vT3_u59a7IA6zQ61GmGANhAh66TRqdlD1O3AH_BDgVMVONZhtZPCxgTlcHb-rNXkHsXcAPhqqXH5Yfm4vgFrhOHgA)
3. [Github Mermaid](https://github.com/mermaid-js/mermaid)
4. [How to add Mermaid (Markdown) Plugin in Visual Studio Code](https://www.youtube.com/watch?v=p4lk9o5WDeY)
5. [Como criar diagramas como código com Mermaid, GitHub e Visual Studio Code](https://www.freecodecamp.org/news/diagrams-as-code-with-mermaid-github-and-vs-code/)
6. [Crie diagramas para transmitir informações sobre gráficos](https://docs.github.com/pt/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)
7. [flowchart](https://mermaid.js.org/syntax/flowchart.html)

</main>

[🔝🔝](#topo "Retorna ao topo")