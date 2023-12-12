<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

<script type="application/x-javascript" src="/js/mermaid.min.js"></script>

# Banco de dados do projeto

## Diagrama do Entidade e Relacionamentos (DER) 

<pre><code class="language-mermaid"><div class="mermaid">

classDiagram
    note "Do Pato até a Zebra"
    Animal <|-- Pato
    note for Pato "pode voar\npode nadar\npode mergulhar\npode comer"

    note for Peixe "pode nadar\npode mergulhar\npode comer"
    Animal <|-- Peixe

    note for Zebra "pode correr\npode andar\npode comer"
    Animal <|-- Zebra

    Animal : +int idade
    Animal : +String gênero
    Animal: +éMamífero()
    Animal: +acasalar()
    class Pato{
        +String corBico
        +nadar()
        +quack()
    }
    class Peixe{
        -int tamanhoEmPés
        -podeComer()
    }
    class Zebra{
        +bool éSelvagem
        +correr()
    }

</div></code></pre>