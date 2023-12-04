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

## Referências

1. [Tutoriais](https://mermaid.js.org/config/Tutorials.html)
2. [Mermaid Live](https://mermaid.live/edit#pako:eNp10VFrwyAQB_CvIvfc9APkrUQZgXUZJi0UfHF6XYUkFqeFEfPdZ5aErR3zzeN3_5NzAGU1Qg7oqJHvTnaiJ-kUh7qp9oyTMW63cSCUPZdHxk_ZjlLO6prk5CI_HmyMWWYHUnGaLjm5tlLhP6Z8OVZlwZIS0Br51iI5Wydg1n-mPSQ7VGhua_aaNaH4g5S9oVvIXPsNsrJh-6RMr9qg16hXXtFD0WTFrmFPFT-tLUv9O7X30vT3_u59a7IA6zQ61GmGANhAh66TRqdlD1O3AH_BDgVMVONZhtZPCxgTlcHb-rNXkHsXcAPhqqXH5Yfm4vgFrhOHgA)
3. [Github Mermaid](https://github.com/mermaid-js/mermaid)
4. [How to add Mermaid (Markdown) Plugin in Visual Studio Code](https://www.youtube.com/watch?v=p4lk9o5WDeY)
5. [Como criar diagramas como código com Mermaid, GitHub e Visual Studio Code](https://www.freecodecamp.org/news/diagrams-as-code-with-mermaid-github-and-vs-code/)

</main>

[🔝🔝](#topo "Retorna ao topo")