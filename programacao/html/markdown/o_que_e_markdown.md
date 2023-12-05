<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# LINGUAGEM DE MARCAÇÃO DE TEXTO MARKDOWN <a href="o_que_e_markdown.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba."> ➚ </a>

<span id="id_topo"> <span>

## INDEX

---

1. **[O que é linguagem de marcação de texto markdown](#id_O_que_e_markdown)**

2. **[Linguagem Markdown x linguagem HTML no documento ".md"](#id-Markdown-x-linguagem-HTML)**

3. **Tag \\** [Simula comportamento do texto entre aspas "tag html" da linguagem html em documento markdown](#id-caractere-especial)

4. **Tag \# (cancela)** [Títulos - Simula comportamento das tags html \<h1\> a \<h6\>](#id-h1)
5. **[Estilo das letras](#id-estilos)**

   1. **Tag \*\* (dois asterisco)** [Texto em negrito - Simula comportamento da tag html \<b\>\<\b\>](#id-negrito)

   2. **Tag \_ (underline) ou \*** [Texto em itálico - Simula comportamento da tag html \<i\>\<\\i>](#id-itálico)

   3. [É possível combinar o \_itálico com o \*\*negrito\*\*](#id-itálico-negrito)

   4. **Tag \~~** [Texto tachado - Simula comportamento da tag html \<s\>\<\\s>](#id-tachado)

   5. **Tag \` (crase)** [texto enfatizando - Simula comportamento da tah html \<em\>\<\\em>](#id-enfatizado)

6. **[Listas em markdown](#id-listas-em-markdown)**

   1. **Tag \- (traço)** [Lista não numeradas - Simula comportamento da tag html \<ul\>](#id-lista-nao-enumerada)

   2. **Tag \. (ponto)** [Lista numeradas - Simula comportamento da tag html \<ol\>](#id-lista-enumerada)

   3. **Tag \[ \]** [Listas de tarefas - Simula o comportamento da tag \<input type="checkbox"\>](#id-lista-de-tarefas)

7. **Tag \_\_\_**[Simula comportamento da tag html \<hr\> (Desenha linha horizontal)](#id-hr)

8. **Tag \>**[Citações - Simula comportamento da tag html \<blockquote\>](#id-blockquote)

9. **Tag \[\]\(\ \"\")** [Âncora para links - Simula a tag html \<a\>\<\/a\>](#id-link)

10. **Tag \![\]\(\ \"\")** [Âncora para imagem - Simula a tag html \<img\>](#id-link-img)

11. [**Escrita de equações matemáticas**](#id-escrita-de-equações)

12. [**Tabelas**](#id-tabelas)

    1. [Tabela simples](#id-tabela-simples)

    2. [Tabelas de links, onde os links ficam fora da tabela](#id-tabelas-links-referencias)

13. [Como configurar e usar emoji em textos markdown no vscode](#id-emoji)

14. [Mermaid Fluxogramas e diagramas](#id_mermaid)

    1. [Dica de como instalar suporte a fluxograma em documentos markdown](#id-fluxograma)

    2. [Diagramas de relacionamento de entidades](#id_Diagramas)
       1. [classDiagram](#id_classDiagram)
       2. [erDiagram](#id_erDiagram)
    3. [Gráfico de pizza](#id_pie)

15. [Tag html \<details\>](#id-details)

16. **Tag \```** [As 3 crases - Simula a tag html \<code\>](#id-código)

17. [Notas de rodapé em documentos markdown](#id-notas-de-rodapé)

18. [Editores markdown para linux](#id-editores-markdown)

    1. [Visual Studio Code](#id-editor-vscode)

       1. Extensões vscode:
          1. [Indispensável essa extensão: Markdown Highlight.js](https://marketplace.visualstudio.com/items?itemName=davidmwhynot.markdown-higlightjs)
          2. [Markdown Checkboxes](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-checkbox)

    2. [Editor ReText vem na distribuição ubuntu](#id-reText)

    3. [Editor ghostwriter vem na distribuição ubuntu](#id-ghostwriter)

    4. [Google docs com a extensão GD2md-html](#id-google-docs-gd2md-html)

    5. [Editor web dillinger](#id-dillinger)

    6. [Editor web stackedit](#id-stackedit)

    7. [Editor natable](#id-notable)

19. [Gerador de site baseado em arquivo markdown](#id_mkdocs)
20.

21. [Referências](#id_referencias)

## CONTEÚDO

---

1. **_O que é linguagem de marcação de texto markdown._** <span id="id_O_que_e_markdown"> <span>

   1. Desenvolvido em 2004 por John Gruber e Aaron Swartz para simplificar a estruturação de um texto, o Markdown é um sistema de formatação aberto que torna a escrita e a leitura mais simples. Com uma codificação mínima, além de fácil, ele é visualmente mais "limpo" e pode ser convertido facilmente para HTML.

   2. Notas:

      1. [Ferramentas usadas para produzir este documento](editores_markdown.html).

      2. [basic-syntax](https://www.markdownguide.org/basic-syntax/)

   3. <text onclick="goBack()">[🔙]</text>

2. <span id="id-Markdown-x-linguagem-HTML"><span> **_Linguagem Markdown x linguagem HTML no documento .md_**.

   1. As <b> tags html</b> podem ser incluídas em um documento markdown.
   2. Tags da linguagem Markdown não serão reconhecida dentro de tags html ex: (\<table\> , \<div\>, \<pre>).
   3. O código .CSS pode ser incluído na primeira linha do documento Markdown.
   4. Para que um códigos html ou javascript seja visualizado deve-se usar 3 crases (\`\`\`) + nome da linguagem.

      1. [Exemplos](#id-código-exemplo):

   5. <text onclick="goBack()">[🔙]</text>

3. **_Para exibir um caractere literal que de outra forma seria usado para <span id="id-caractere-especial"><span> formatar texto em um documento Markdown, adicione uma barra invertida ( \\ ) na frente do caractere._**

   1. Exemplo:

      1. O asterisco ( \* ) é um tag markdown e para que ele seja visualizado em um texto o mesmo deve ser precedido do caractere ( \\ ).
         1. Exemplo:
            1. \\\*
      2. O \<div\> estaria invisível se não fosse o caractere \\ antes de \< e antes \>.

   2. <text onclick="goBack()">[🔙]</text>

4. **_Como criar a tag html \<hx\> onde x varia de 1 a 6 em um documento Markdown?_** <span id="id-h1"><span>

   1. Usar o caractere \# em frente do texto da seguinte forma:

      1. \# h1
      2. \#\# h2
      3. \#\#\# h3
      4. \#\#\#\# h4
      5. \#\#\#\#\# h5
      6. \#\#\#\#\#\# h6
      7. [Exemplo do resultado](#id-exemplo-hx)

   2. <text onclick="goBack()">[🔙]</text>

5. **_Estilo das letras_**<span id="id-estilos"><span>

   1. <span id="id-negrito"><span>Dois asterisco (\*\*) no começo e dois asteriscos (\*\*) no fim da frase muda a fonte da frase para negrito.

      1. Exemplo:

         1. (\*\*)Esta frase está em negrito (\*\*)
         2. **Esta frase está em negrito**.

      2. <text onclick="goBack()">[🔙]</text>

   2. <span id="id-itálico"></span>As fontes itálica pode ser obtida inserindo underline ( \_ ) no início e no fim da frase.

      1. Exemplo:

         1. \_Exemplo de itálico\_
         2. _Exemplo de itálico_

      2. <text onclick="goBack()">[🔙]</text>

   3. <span id="id-itálico-negrito"></span>É possível combinar o \_itálico com o \*\*negrito\*\*\_

      1. É possível combinar o \_itálico com o \*\*negrito\*\*\_
      2. É possível combinar o _itálico com o **negrito**_

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id="id-tachado"></span>A tag ( ~~ ) no inicio e no fim da texto, muda o estilo da fonte para que desenhe uma linha horizontal no centro do texto.

      1. Exemplo:

         1. \~\~Este frase sairá como uma linha horizonta no centro dela.~~
         2. ~~Este frase sairá como uma linha horizontal no centro dela.~~

      2. <text onclick="goBack()">[🔙]</text>

   5. <span id="id-enfatizado"></span>**_Para dar ênfase ao texto usar o caractere crase (`) no inicio e no final do texto._**

      1. Exemplo:

         1. \`Esta frase está com estilo ênfase\`.
         2. `Esta frase está com estilo ênfase`.

      2. <text onclick="goBack()">[🔙]</text>

   6. <text onclick="goBack()">[🔙🔙]</text>

6. <span id="id-listas-em-markdown"></span>**Listas em markdown**

   1. <span id="id-lista-nao-enumerada"></span>**_Listas não ordenadas_**

      1. Um asterisco ( \* ) cria uma lista não ordenada e tabula com a tecla tab.

         1. Exemplo:
            1. \- Grupo
               1. \- Linha 01.
               2. \- Linha 02.
               3. \- Linha 03.
               4. [Resultado do exemplo](#id-Listas-Nao-Ordenadas-exemplo-resultado)

      2. <text onclick="goBack()">[🔙]</text>

   2. <span id="id-lista-enumerada"></span>**_Listas ordenadas ou numerada_**

      1. Um ponto parágrafo ( \. ) após o número, cria uma lista ordenada com valor inicial igual ao número digitado e tabula com a tecla tab.

      2. Atenção: No vscode quando alteramos um número da sequência a lista dos número seguintes são alterados porém não altera o espaçamento dos números seguintes. Para que agente não perca o andamento do projeto é bom instalar a extensão markdownlint.

      3. É possível criar **listas não ordenadas** dentro de **listas ordenadas**.

         1. **Exemplo:**
            1. titulo 01
               1. item 01
               2. item 02
                  - item 01
                  - item 02
               3. item 03
            2. título 02
            3. título 03

      4. <text onclick="goBack()">[🔙]</text>

   3. <span id="id-lista-de-tarefas"></span>**Listas de tarefas - Simula o comportamento da tag \<input type="checkbox"\>**

      1. [x] item 01 [x]
      2. [ ] item 02 [ ]
      3. [ ] item 03 [ ]

      - [x] item 01 [x]
      - [x] item 02 [x]
      - [x] item 02 [x]

      - <text onclick="goBack()">[🔙]</text>

7. <span id="id-hr"></span>**_Como criar a tag html \<hr\> em documentos markdown?_**

   1. Três underline (\_\_\_) juntos desenha uma linha horizontal.

      1. Exemplo:
         1. \_\_\_
         2. [Veja o resultado do exemplo](#id-hr-resultado)

   2. <text onclick="goBack()">[🔙]</text>

8. <span id="id-blockquote"></span>**_Usar o sinal (>) no início da frase para indicar citação. Citações podem ser aninhadas concatenando o sinal (>). Ex: >>> _**

   1. Veja o [exemplo de citação em anexo...](#id-blockquote-exemplo)

   2. <text onclick="goBack()">[🔙]</text>

9. **As tags \[texto](#url "hint")**

   1. <span id="id-link"></span>Simula a tag html \<a href="#url" title="hint"\>texto\</a\> (âncora)

      1. **[texto]** Local onde o texto visível do link é inserido.
      2. **(#url "hint")** Simula o atributo href="#url" e title="hint" da tag html \<a\>.
      3. Exemplo:
         1. \[texto visível do link](#url "Esse texto é visualizado quando o mouse é posicionado em cima do link"\)
            1. [texto visível do link](#url "Esse texto é visualizado quando o mouse é posicionado em cima do link")
         2. \[A tag markdown não aceita Javascript]("javascript:alert('Hello World!');"\)
         3. Caso queira executar javascript é preciso usar o próprio html.
         4. Exemplo:
            1. <a href="javascript:alert('Hello World!');">Execute JavaScript</a>
         5. Como enviar e-mail usando tags markdown:
            1. Usar o link \[Enviar e-mail](mailto:example@gitlab.com \"Enviará um e-mail para: mailto:example@gitlab.co \"\)
            2. Exemplo:
               1. [Enviar e-mail](mailto:example@gitlab.com "Enviará um e-mail para: mailto:example@gitlab.co ")
         6. Link para um id dentro do documento: \[Ir para o topo deste documento](#id_topo\)
         7. Ex: [Ir para o todo deste documento](#id_topo)

   2. <text onclick="goBack()">[🔙]</text>

10. <span id="id-link-img"></span>**_As tags \!\[Texto Alternativo](#url-img "hint")_**

    1. **_Simula a tag html \<img src="#url" alt\=\"Texto Alternativo\" title="hint"> (âncora da imagem)_**

       1. **_ \! _** O sinal de exclamação indica que a sequência seguinte trata-se de uma imagem.
       2. **_\[Texto Alternativo] _** Se por alguma motivo a imagem não poder ser visualizada o texto alternativo é visualizado.
       3. **_(\#url-img \"hint") _** Simula o atributo src="#url-img" e title="hint" da tag html \<img\>.
       4. Exemplo:
          1. \!\[texto alternativo](#url-img "Esse texto é visualizado quando o mouse é posicionado em cima da imagem"\)
             1. ![Logomarca linux](https://d33wubrfki0l68.cloudfront.net/e7ed9fe4bafe46e275c807d63591f85f9ab246ba/e2d28/assets/images/tux.png "Logomarca do sistema operacional Linux")
             2. Nota: A imagem será visualizada na posição em que é referênciada pelo documento.
                1. ===============>![Logomarca linux](https://d33wubrfki0l68.cloudfront.net/e7ed9fe4bafe46e275c807d63591f85f9ab246ba/e2d28/assets/images/tux.png "Logomarca do sistema operacional Linux")
                2.

    2. <text onclick="goBack()">[🔙]</text>

11. <span id="id-escrita-de-equações"></span>**_[Escrita de equações matemáticas](https://ajustetecnico.github.io/blog/2018/09/19/equacoes-latex/):_**

    1. A fórmula deve estar entre (\$\$).
       1. Exemplos: Letras = \$\$letra\$\$
          1. Letra \(mu\):\$\$\mu\$\$
             1. $$\mu$$
          2. Letra sigma: \$\$sigma\$\$
             1. $$\sigma$$
          3. O acento circunflexo desenha em sobrescrito: \$\$ 2\^\{sobrescrito\}\$\$
             1. $$2^{sobrescrito}$$
          4. Letra sigma ao quadrado: \$\$\sigma^{2}\$\$
             1. $$\sigma^{2}$$
          5. O ( \_ ) underline desenha em subscrito: \$\$3\_{subscrito}\$\$
             1. $$3_{subscrito}$$
          6. Letra alfa:\$\$\alpha\$\$
             1. $$\alpha$$
          7. Letra beta: \$\$\beta\$\$
             1. $$\beta$$
          8. Letra epsilon: \$\$\epsilon\$\$
             1. $$\epsilon$$
       2. Exemplo: Fórmulas= \$\$Expressão matemática\$\$
          1. \$\$f(x*{i}) = \alpha*{i} + \beta*{i} x*{i} + \epsilon\_{i}\$\$
             1. $$f(x_{i}) = \alpha_{i} + \beta_{i} x_{i} + \epsilon_{i}$$
          2. \$\$f(x) = ax^2 + bx + c \$\$
             1. $$f(x) = ax^2 + bx + c$$
          3. $e = mc^2$
    2. O site [math.justforfun](https://marketplace.visualstudio.com/items?itemName=justforfun-click.math-to-svg) tem um serviço que retorna uma imagem de uma expressão matemática.

       1. Exemplo:
          1. Retorna a expressão matemática passada no parâmetro:
             1. <https://math.justforfun.click/$/>
             2. {
                (2x², + , 17y⁴, =, 23,,(1)),
                ( x , - , y , =, 5,,(2))
                }
          2. obs:A tag markdown não executa esta api.
             1. Usar o código html para que funcione.
                1. <img src="https://math.justforfun.click/$/
                     {
                      (2x², + , 17y⁴, =, 23,,(1)),
                     ( x , - , y   , =,  5,,(2))
                    :}"  alt="Retorna a expressão matemática passada no parâmetro" title="Retorna a expressão matemática passada no parâmetro">
          3. [Símbolos matemáticos usado na API](http://asciimath.org/ "Esses símbolos podem ser usado na API: https://math.justforfun.click/$/")

    3. <text onclick="goBack()">[🔙]</text>

12. <span id="id-tabelas"></span>**_Tabelas ( \<table\> \<\/table\> \<tr\>\<\/tr\> \<td\>\<\/\td\> )_**

    1. <span id="id-tabela-simples"></span>**_Tabela simples_**

       1. Para dizer para o sistema que se trata de uma tabela os seguintes caracteres são usado:

          1. A barra vertical (**|**) Representa a tag \< td \> \< /td \>.
          2. Dois pontos (**:**) informa ao sistema se a coluna está alinhada a esquerda, centro ou direita.
          3. O sinal de menos (**-**) usado junto com o dois pontos **:** para informa o tipo de alinhamento onde:
             1. a esquerda usar a combinação (**:---**);
             2. a direita usar combinação **---:**;
             3. ao centro usar combinação **:---:**).
             4. Obs: O local onde o alinhamento deve ser informado é na linha abaixo do nome das colunas.
                1. EXEMPLO:
                   1. \|col 01\|col 02\|col 03  
                      \|:-----|:----:|-----:  
                      \|a11 | a12 | a13  
                      \|a21 | a22 | a23  
                      \|a31 | a32 | a33  
                      [Veja em anexo o resultado](#id-tabela-simples-exemplo)...

       2. <text onclick="goBack()">[🔙]</text>

    2. <span id="id-tabelas-links-referencias"></span>**_Tabelas de links, onde os links ficam fora da tabela._**

       1. Exemplo de tabela usando links nas células sendo que os links ficam fora da tabela

          1. =================================================
          2. |First Header | Second Header | Third Header
          3. |:-------------|:---------------------|:-----------
          4. |\[onze]\[11] | \[12] | \[13]
          5. |\[21] | \[vinde e dois]\[22] | \[23]
          6. |\[31] | \[32] | \[three trees]\[33]
          7. Matriz de links:
             1. \[11]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=11>
             2. \[12]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=12>
             3. \[13]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=13>
             4. \[21]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=21>
             5. \[22]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=22>
             6. \[23]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=23>
             7. \[31]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=31>
             8. \[32]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=32>
             9. \[33]:<http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=33>
          8. Link abaixo mostra o resultado do exemplo:

             1. [Resultado do exemplo abaixo](#id_tabela_link_referencia)

          9. <text onclick="goBack()">[🔙]</text>

    3. <text onclick="goBack()">[🔙🔙]</text>

13. <span id="id-emoji"></span>Como configurar e usar emoji em textos markdown no vscode:

    1. Emoje na web:

       1. [🎸 emoji-on-vscode](https://dev.to/pjijin/emoji-on-vscode--571l)
       2. [🥕 https://emojipedia.org/people/](https://emojipedia.org/people/)
       3. [😀 https://marketplace.visualstudio.com/items?itemName=devzstudio.emoji-snippets](https://marketplace.visualstudio.com/items?itemName=devzstudio.emoji-snippets)
       4. :brazil: O emoji pode ser escrito com dois pontos no começo e dois pontos no final.
       5. :smile: :+1:
       6. [Referência ao código do emoji da linguagem html](https://www.w3schools.com/charsets/ref_emoji.asp)
          1. Exemplo:
             1. &#8986;
             2. &#8987;
       7. _Depois de ler mais sobre o assunto do emoji cheguei a conclusão de que o código html é o mais indicado porque vai funcionar em qualquer lugar do mundo_.

    2. Extensão **Markdown Emoji**
       1. [Lista de emoji markdown](https://www.webfx.com/tools/emoji-cheat-sheet/)
          1. :persevere:
          2. :cry:
    3. <text onclick="goBack()">[🔙]</text>

14. <scan id=id_mermaid></scan>[**Mermaid Live Editor**](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW0NocmlzdG1hc10gLS0-fEdldCBtb25leXwgQihHbyBzaG9wcGluZylcbiAgICBCIC0tPiBDe0xldCBtZSB0aGlua31cbiAgICBDIC0tPnxPbmV8IERbTGFwdG9wXVxuICAgIEMgLS0-fFR3b3wgRVtpUGhvbmVdXG4gICAgQyAtLT58VGhyZWV8IEZbZmE6ZmEtY2FyIENhcl0iLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)

    1. O Mermaid permite criar diagramas usando texto e código. Isso simplifica a manutenção de diagramas complexos. É uma ferramenta de diagramação e gráficos baseada em Javascript que renderiza definições de texto inspiradas no Markdown para criar e modificar diagramas dinamicamente.

       1. Links para a documentação oficial.

          1. [mermaid-js](https://mermaid-js.github.io/mermaid/#/flowchart?id=flowcharts-basic-syntax)
          2. [Extensão markdown-mermaid](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
          3. [Exemplo de link em gráfico com mermaid](https://mermaid-js.github.io/mermaid/#/flowchart?id=interaction)
          4. [Mermaid Markdown Syntax Highlightin](https://marketplace.visualstudio.com/items?itemName=bpruitt-goddard.mermaid-markdown-syntax-highlighting)
          5. [Entity Relationship Diagrams](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram?id=entity-relationship-diagrams)

       2. <span id="id-fluxograma"></span>Dica de como instalar suporte a fluxograma em documentos markdown:

          1. Exemplos:

             1. [Mermaid flowchart](https://mermaid-js.github.io/mermaid/#/flowchart?id=graph)

                1. Graph TD - vertical

                   ```javascript

                   graph TD
                      %% Este é um comentário sobre: Start[(Início)] --> a[Elemento a]
                      Start[(Início)] --> a[Elemento a]
                      a --> b[Link...]
                      b --> c[Elemento c]
                      b --> d[Elemento d]
                      d --> e((Elemento e))
                      d --> f[(Elemento f)]
                      f --> g>Elemento g]
                      g --> h[/Elemento h/]
                      h --> i[\Emento i\]
                      f --> j[/Elemento j\]
                      f --> k[\Elemento k/]
                      f --> se{Elemento se}
                      se --> true([Elemento true])
                      se --> false([Elemento false])
                      true --> continua{{Elemento continua}}
                      continua --> a
                      false --> pare{{Elemento pare}}
                      click b href "https://mermaid-js.github.io/mermaid/#/flowchart?id=interaction" "Titulo do link" _blank

                   ```

                   ```mermaid

                   graph TD
                      %% Este é um comentário sobre: Start[(Início)] --> a[Elemento a]
                      Start[(Início)] --> a[Elemento a]
                      a --> b[Link...]
                      b --> c[Elemento c]
                      b --> d[Elemento d]
                      d --> e((Elemento e))
                      d --> f[(Elemento f)]
                      f --> g>Elemento g]
                      g --> h[/Elemento h/]
                      h --> i[\Emento i\]
                      f --> j[/Elemento j\]
                      f --> k[\Elemento k/]
                      f --> se{Elemento se}
                      se --> true([Elemento true])
                      se --> false([Elemento false])
                      true --> continua{{Elemento continua}}
                      continua --> a
                      false --> pare{{Elemento pare}}
                      click b href "https://mermaid-js.github.io/mermaid/#/flowchart?id=interaction" "Titulo do link" _blank

                   ```

                   ***

                2. graph LR horizontal

                   ```javascript
                   graph LR
                   A[Natal] -->|Ganhe dinheiro| B(Vai fazer compras)
                   B --> C{Deixe-me pensar}
                   C -->|Um| D[Laptop]
                   C -->|Dois| E[Celular]
                   C -->|Três| F[fa:fa-car Carro]

                   ```

                   ```mermaid
                   graph LR
                   A[Natal] -->|Ganhe dinheiro| B(Vai fazer compras)
                   B --> C{Deixe-me pensar}
                   C -->|Um| D[Laptop]
                   C -->|Dois| E[Celular]
                   C -->|Três| F[fa:fa-car Carro]

                   ```

             2. <text onclick="goBack()">[🔙]</text>

       3. <span id="id_Diagramas">Diagramas de relacionamento de entidades

          1. <scan id=id_classDiagram></scan>[Class diagramas](https://mermaid-js.github.io/mermaid/#/classDiagram).

             1. Na engenharia de software, um diagrama de classes na Unified Modeling Language (UML) é um tipo de diagrama de estrutura estática que descreve a estrutura de um sistema, mostrando as classes do sistema, seus atributos, operações (ou métodos) e os relacionamentos entre os objetos. [Veja mais...](https://pt.wikipedia.org/wiki/Diagrama_de_classes)

                1. Código mermaid

                ```javascript
                   Animal <|-- Duck
                   Animal <|-- Fish
                   Animal <|-- Zebra
                   Animal : +int age
                   Animal : +String gender
                   Animal : +isMammal()
                   Animal : +mate()
                   class Duck{+String beakColor
                               +swim()
                               +quack()
                            }
                   class Fish{-int sizeInFeet
                            -canEat()
                            }
                   class Zebra{+bool is_wild
                               +run()
                            }
                ```

                ```mermaid
                   classDiagram

                      Animal <|-- Duck
                      Animal <|-- Fish
                      Animal <|-- Zebra
                      Animal : +int age
                      Animal : +String gender
                      Animal: +isMammal()
                      Animal: +mate()
                      class Duck{
                         +String beakColor
                         +swim()
                         +quack()
                      }
                      class Fish{
                         -int sizeInFeet
                         -canEat()
                      }
                      class Zebra{
                         +bool is_wild
                         +run()
                      }
                ```

                ```javascript
                   classDiagram

                      Class01 <|-- AveryLongClass : Cool
                      Class03 *-- Class04
                      Class05 o-- Class06
                      Class07 .. Class08
                      Class09 --> C2 : Where am i?
                      Class09 --* C3
                      Class09 --|> Class07
                      Class07 : equals()
                      Class07 : Object[] elementData
                      Class01 : size()
                      Class01 : int chimp
                      Class01 : int gorilla
                      Class08 <--> C2: Cool label

                ```

                ```mermaid
                   classDiagram

                      Class01 <|-- AveryLongClass : Cool
                      Class03 *-- Class04
                      Class05 o-- Class06
                      Class07 .. Class08
                      Class09 --> C2 : Where am i?
                      Class09 --* C3
                      Class09 --|> Class07
                      Class07 : equals()
                      Class07 : Object[] elementData
                      Class01 : size()
                      Class01 : int chimp
                      Class01 : int gorilla
                      Class08 <--> C2: Cool label

                ```

             2. <text onclick="goBack()">[🔙]</text>

          2. <scan id=id_erDiagram></scan> [erDiagramas](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram?id=entity-relationship-diagrams)

             1. Um modelo de entidade-relacionamento (ou modelo ER) descreve coisas inter-relacionadas de interesse em um domínio específico de conhecimento. Um modelo ER básico é composto de tipos de entidade (que classificam as coisas de interesse) e especifica relacionamentos que podem existir entre entidades (instâncias desses tipos de entidade). [Veja mais...](https://pt.wikipedia.org/wiki/Modelo_entidade_relacionamento)

                1. **Sintaxe**:

                   1. A sintaxe do projeto mermaid para diagramas ER é compatível com PlantUML, com uma extensão para rotular o relacionamento. Cada declaração consiste nas seguintes partes:

                      1. _\<first-entity\>\[\<relationship\> \<second-entity\> : \<relationship-label\>\]_

                         1. Onde:

                            1. _first-entity_ é o nome de uma entidade. Os nomes devem começar com um caractere alfabético e também podem conter dígitos, hifens e sublinhados.
                            2. _relationship_ descreve a maneira como ambas as entidades se relacionam.
                            3. _second-entity_ é o nome da outra entidade.
                            4. _relationship-label_ descreve o relacionamento da perspectiva da primeira entidade.

                            5. Nota: Apenas a _first-entity_ parte de uma declaração é obrigatória. Isso torna possível mostrar uma entidade sem relacionamentos, o que pode ser útil durante a construção iterativa de diagramas. Se qualquer outra parte de uma instrução for especificada, todas as partes são obrigatórias.
                            6. Exemplo:
                               1. PROPERTY ||--|{ ROOM : contains

                2. [**Sintaxe de relacionamento**](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram?id=relationship-syntax).

                   1. A _relationship_ parte de cada declaração pode ser dividida em três subcomponentes:
                      1. a cardinalidade da primeira entidade em relação à segunda,
                      2. se o relacionamento confere identidade a uma entidade 'filha'
                      3. a cardinalidade da segunda entidade em relação à primeira
                   2. Cardinalidade é uma propriedade que descreve quantos elementos de outra entidade podem estar relacionados à entidade em questão. No exemplo acima, a PROPERTY pode ter uma ou mais ROOM instâncias associadas a ele, enquanto a ROOM só pode ser associado a uma PROPERTY. Em cada marcador de cardinalidade existem dois caracteres. O caractere externo representa um valor máximo e o caractere interno representa um valor mínimo. A tabela abaixo resume as possíveis cardinalidades:
                      1. | Valor (esquerda) | Valor (direita) |            Significado             |
                         | :--------------- | --------------: | :--------------------------------: |
                         | \|o              |             o\| |             Zero ou um             |
                         | \|\|             |            \|\| |           Exatamente um            |
                         | \}o              |             o\{ | Zero ou mais (sem limite superior) |
                         | \}\|             |            \|\{ |  Um ou mais (sem limite superior)  |

                3. **Identificação**.

                   1. Os relacionamentos podem ser classificados como identificadores ou não identificadores e são processados ​​com linhas sólidas ou tracejadas, respectivamente. Isso é relevante quando uma das entidades em questão não pode ter existência independente sem a outra. Por exemplo, uma empresa que faz seguro para pessoas que dirigem carros pode precisar armazenar dados em _NAMED-DRIVERs_.

                      1. Na modelagem disso, podemos começar observando que um _CAR_ pode ser conduzido por muitas _PERSON_ instâncias e uma _PERSON_ pode conduzir muitos _CARs_ - ambas as entidades podem existir sem a outra, portanto, esta é uma relação não identificadora que podemos especificar em Mermaid como: _PERSON_ }|..|{ _CAR_ : "_driver_". Observe os dois pontos no meio do relacionamento que resultarão em uma linha tracejada sendo desenhada entre as duas entidades. Mas quando esse relacionamento muitos-para-muitos é resolvido em dois relacionamentos um-para-muitos, observamos que a _NAMED-DRIVER_ não pode existir sem a _PERSON_ e a _CAR-_ os relacionamentos se tornam identificadores e seriam especificados usando hifens, que se traduzem em uma linha sólida:

                         1. Exemplo:

                            ```javascript

                               erDiagram
                                 CAR ||--o{ NAMED-DRIVER : allows
                                 PERSON ||--o{ NAMED-DRIVER : is

                            ```

                            ```mermaid

                               erDiagram
                                 CAR ||--o{ NAMED-DRIVER : allows
                                 PERSON ||--o{ NAMED-DRIVER : is

                            ```

                4. [Atributos](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram?id=attributes)

                   1. Os atributos podem ser definidos para entidades especificando o nome da entidade seguido por um bloco contendo vários _type name_ pares, onde um bloco é delimitado por uma abertura { (abre chave) e um fechamento } (fecha chave).

                      1. [Exemplo:](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZXJEaWFncmFtXG4gICAgICAgICAgQ1VTVE9NRVIgfXwuLnx7IERFTElWRVJZLUFERFJFU1MgOiBoYXNcbiAgICAgICAgICBDVVNUT01FUiB8fC0tb3sgT1JERVIgOiBwbGFjZXNcbiAgICAgICAgICBDVVNUT01FUiB8fC0tb3sgSU5WT0lDRSA6IFwibGlhYmxlIGZvclwiXG4gICAgICAgICAgREVMSVZFUlktQUREUkVTUyB8fC0tb3sgT1JERVIgOiByZWNlaXZlc1xuICAgICAgICAgIElOVk9JQ0UgfHwtLXx7IE9SREVSIDogY292ZXJzXG4gICAgICAgICAgT1JERVIgfHwtLXx7IE9SREVSLUlURU0gOiBpbmNsdWRlc1xuICAgICAgICAgIFBST0RVQ1QtQ0FURUdPUlkgfHwtLXx7IFBST0RVQ1QgOiBjb250YWluc1xuICAgICAgICAgIFBST0RVQ1QgfHwtLW97IE9SREVSLUlURU0gOiBcIm9yZGVyZWQgaW5cIlxuICAgICAgICAgICAgIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)

                         ```javascript

                           erDiagram
                               CAR ||--o{ NAMED-DRIVER : allows
                               CAR {
                                  string registrationNumber
                                  string make
                                  string model
                               }
                               PERSON ||--o{ NAMED-DRIVER : is
                               PERSON {
                                  string firstName
                                  string lastName
                                  int age
                               }
                         ```

                         ```mermaid

                            erDiagram
                                CAR ||..o{ NAMED-DRIVER : allows
                                CAR {
                                   string registrationNumber
                                   string make
                                   string model
                                }
                                PERSON ||--o{ NAMED-DRIVER : is
                                PERSON {
                                   string firstName
                                   string lastName
                                   int age
                                }
                                NAMED-DRIVER {
                                   int id
                                   string name
                                   string date
                                }
                         ```

             2. <text onclick="goBack()">[🔙]</text>

          3. <scan id=id_pie></scan> [Gráfico de pizza](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoicGllIHRpdGxlIFBldHMgYWRvcHRlZCBieSB2b2x1bnRlZXJzXG4gICAgXCJEb2dzXCIgOiAzODZcbiAgICBcIkNhdHNcIiA6IDg1XG4gICAgXCJSYXRzXCIgOiAxNVxuICAgIFwicGF1bG9cIjogNTBcbiAgICAgICAgICAgICIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

             1. Exemplo de uso do gráfico de pizza.

                ```javascript

                   pie title Animais de estimação adotados por voluntários
                        "Cachorros" : 386
                        "Gatos    " : 85
                        "Ratos    " : 15

                ```

                ```mermaid

                   pie title Animais de estimação adotados por voluntários
                        "Cachorros" : 386
                        "Gatos    " : 85
                        "Ratos    " : 15

                ```

             2. <text onclick="goBack()">[🔙]</text>

15. <span id="id-details"><span>O elemento semântico html \<details\> funciona em markdown se o mesmo estiver isolado do código markdown, já que html não conhece markdown.

    1. [Veja o exemplo nos anexo](#id-details-exemplo)

    2. <text onclick="goBack()">[🔙]</text>

16. <span id="id-código"><span>Tag \``` As 3 crases é usada para informar que o texto seguinte é um código javascript ou html.

    1. [Veja o exemplo anexo...](#id-código-exemplo)

    2. <text onclick="goBack()">[🔙]</text>

17. <span id="id-notas-de-rodapé"><span>Notas de rodapé em documentos markdown.

    1. A extensão [markdown-footnotes](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes) permite implementar notas de rodapé em documentos markdown.

       1. [Exemplo de como usar nota de rodapé](#id-markdown-footnotes-exemplo).

    2. <text onclick="goBack()">[🔙]</text>

18. <span id="id-editores-markdown"><span>Editores markdown para linux.

    1. <span id="id-editor-vscode"><span>Visual Studio Code com as extensões abaixo atendeu 100% de minhas necessidades:

       1. [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one "Tem quase tudo que é precisa para escrever o Markdown (atalhos de teclado, sumário, visualização automática e muito mais)")

          1. Ao inserir uma elemento na lista enumerada o número seguintes é calculado.
          2. **Atalhos do teclado da extensão markdown-all-in-one:**
             1. **Ctrl/Cmd + B** - Alternar negrito
             2. **Ctrl/Cmd + I** - Alternar itálico
             3. **Ctrl / Cmd + Shift + ]** - Alternar título (Insere cancela (#))
             4. **Ctrl/Cmd + Shift + [** - Alternar título (Excluir cancela (#))
             5. **Ctrl/Cmd + M** - Alternar ambiente matemático
             6. **Alt+C** - Marcar / Desmarcar item da lista de tarefas
             7. **Ctrl/Cmd + Shift + V** - Alternar visualização

       2. A extensão [Markdown Shortcuts](https://marketplace.visualstudio.com/items?itemName=mdickin.markdown-shortcuts) facilita muito edição de tags markdown.

       3. [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint "Linting de marcação e verificação de estilo para código do Visual Studio")
       4. [Mermaid Markdown Syntax Highlighting](https://marketplace.visualstudio.com/items?itemName=bpruitt-goddard.mermaid-markdown-syntax-highlighting "Suporte de sintaxe Markdown para a linguagem de gráficos Mermaid")
       5. [Markdown Footnotes](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes "Adiciona suporte de sintaxe de nota de rodapé [^1] à visualização embutida do Markdown do VS Code")
       6. [Bookmarks](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks "Marque as linhas e pule para elas")
       7. [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker "Verificador ortográfico para código-fonte")
       8. [Brazilian Portuguese - Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker-portuguese-brazilian "Extensão do dicionário do português brasileiro para o código VS")
       9. [html-to-javascript-string](https://marketplace.visualstudio.com/items?itemName=evileumas.html-to-javascript-string "Esta extensão converte o texto selecionado do editor em string javascript")
       10. [vscode pdf](https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf "Essa extensão permite visualizar pdf no vscode").
       11. [markdown-preview-enhanced](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced "Visualização de Markdown aprimorada")
       12. [markdown-pdf](https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf "Converte markdown para pdf")
       13. [Instant Markdown](https://marketplace.visualstudio.com/items?itemName=dbankier.vscode-instant-markdown "Ao editar documentos markdown em vscode esta extensão atualiza instantaneamente no navegador.")
       14. A extensão [Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree "Este link descreve tudo que é necessário fazer para configurar a extensão.") para criar lista com todos os cometários do código que contenha as palavras: TODO: ou FIXME:
       15. [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid "Gera fluxogramas, diagramas e muito mais")
       16. A extensão [markdown-footnotes]("https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes") é usada para criar notas de rodapé em documentos markdown.
       17. [Todos os erros que viola as regras markdown](https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md)
       18. [markdown-extended](https://marketplace.visualstudio.com/items?itemName=jebbs.markdown-extended)
       19. Extensão [**Markdown Emoji**](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-emoji)
           1. :persevere:
       20. <text onclick="goBack()">[🔙]</text>

    2. <span id="id-reText"><span>Editor [ReText](http://manpages.ubuntu.com/manpages/bionic/man1/retext.1.html#:~:text=ReText%20is%20a%20simple%20editor,to%20write%20custom%20export%20extensions. "Editor de texto para Markdown e reStructuredText") vem na distribuição ubuntu.

       1. Instalei porém o mesmo não reconheceu o documento o_que_e_markdown.md que criei com vscode.
       2. O que eu percebi de positivo caso o documento não use sintaxe estendida é a exportação para pdf, html e open office.

       3. <text onclick="goBack()">[🔙]</text>

    3. <span id="id-ghostwriter"><span>Editor [ghostwriter](https://wereturtle.github.io/ghostwriter/) vem na distribuição ubuntu.

       1. obs: Ele só exporta para html e não reconhece comentários em html embutido.

       2. <text onclick="goBack()">[🔙]</text>

    4. <span id="id-google-docs-gd2md-html"><span>Google docs com a extensão GD2md-html.

       1. O google docs usa a extensão [GD2md-html](https://gsuite.google.com/marketplace/app/docs_to_markdown/700168918607 "para converter documentos editados no google docs para arquivo com extensão .md (.markdown)")

       2. <text onclick="goBack()">[🔙]</text>

    5. <span id="id-dillinger"><span>Editor web dillinger:

       1. O [dillinger](https://www.markdownguide.org/tools/dillinger/ "Dillinger é um editor Markdown online.") é um editor de código markdown que funciona no browser.
       2. obs: Não reconhece a tag \<big\>\<\/big\>.

       3. <text onclick="goBack()">[🔙]</text>

    6. <span id="id-stackedit"><span>Editor web stackedit.

       1. O [stackedit](https://stackedit.io/app "stackedit é um editor Markdown online.") perde a formação do texto markdown quando o mesmo é editado em outro editor.

       2. <text onclick="goBack()">[🔙]</text>

    7. <span id="id-notable"><span>O Editor notable para desktop linux.

       1. O [Editor notable](https://notable.app/ "O notable está no repositório do ubuntu") é muito bom reconheceu quase tudo que escrevi no vscode só tive dois problema:

          1. A sintaxe da fórmula matemática o símbolo \$\$ deve está unido na fórmula e não pode ter espaço em braco entre o símbolo e o inicio da fórmula.
          2. Exemplo:
             1. \$\$ f(x) = ax^2 + bx + c \$\$ --errado
             2. \$\$f(x) = ax^2 + bx + c\$\$ --certo
          3. O gráfico e fluxogramas não funcionaram.

       2. <text onclick="goBack()">[🔙]</text>

19. <span id="id_mkdocs"><span> MkDocs é um Gerador de site estático baseado em arquivo markdown.

    1. MkDocs é um gerador de site estático rápido, simples e absolutamente lindo que é voltado para a documentação do projeto de construção.  
       Os arquivos de origem da documentação são gravados em Markdown e configurados com um único arquivo de configuração YAML. Comece lendo a introdução abaixo e, em seguida, verifique o Guia do Usuário para obter mais informações.

       1. [Escrevendo seus documentos markdown para mkdocs](https://www.mkdocs.org/user-guide/writing-your-docs/).

       2. <text onclick="goBack()">[🔙]</text>

---

---

## A N E X O S

---

<span id="id-exemplo-hx"><span>

> ### Exemplo da reapresentação das tags \<hx\> onde x varia de 1 a 6\_\*\*
>
> # h1
>
> ## h2
>
> ### h3
>
> #### h4
>
> ##### h5
>
> ###### h6
>
> <text onclick="goBack()">[🔙]</text>

<span id="id-código-exemplo"><span>

---

> ### Exemplo de como visualizar código no documento
>
> > \`\`\`javascript
> >
> > ```javascript
> >   <script>
> >        function fancyAlert(arg) {
> >            if(arg) {
> >            $.facebox({div:'#foo'})
> >            }
> >        }
> >   </script>
> >
> > ```
> >
> > \`\`\`
> >
> > \`\`\`html
> >
> > ```Html
> >
> >   <html lang="pt-BR">
> >      <head>
> >      </head>
> >      <bodY>
> >          <p>Alo Mundo.</p>
> >          <script>
> >             document.print("Alo Mundo");
> >             <img src="https://math.justforfun.click/$/
> >                      {
> >                      (2x², + , 17y⁴, =, 23,,(1)),
> >                      ( x , - , y   , =,  5,,(2))
> >                     :}"
> >                      alt="API WEB https://math.justforfun.click/$/ "
> >                      title="Retorna a expressão matemática passada no parâmetro">
> >          </script>
> >       </body>
> >   </html>
> > ```
> >
> > \`\`\`
> >
> > \```json
> >
> > ```json
> > {
> >   "firstName": "John",
> >   "lastName": "Smith",
> >   "age": 25
> > }
> > ```
> >
> > \```

<text onclick="goBack()">[🔙]</text>

---

<span id="id-blockquote-exemplo"><span>

> ### Este é uma citação
>
> - O sinal usado abre e fecha este código no HTML.
>
> > - `O bloco pode ser aninhado se o sinal  \>>  for  colocar no início da linha.`
>
> - Para adicionar mais uma linha à citação, basta teclar \<enter\> que o vscode posiciona na próxima linha da citação com a tag \>.
> - Isso gerará um novo parágrafo dentro do blockquote.
> - As tags markdown negrito, itálico, enfatizado, lista numeras e lista não numeradas funcionam dentro de uma citação.
>
> 1. Título
>    1. item 01
>    2. item 02

<text onclick="goBack()">[🔙]</text>

---

<span id="id-tabela-simples-exemplo"><span>

> ### Exemplo de tabela
>
> | col 01 | col 02 | col 03 |
> | :----- | :----: | -----: |
> | a11    |  a12   |    a13 |
> | a21    |  a22   |    a23 |
> | a31    |  a32   |    a33 |

<text onclick="goBack()">[🔙]</text>

<span id="id_tabela_link_referencia"> <span>

---

> ### Exemplo de tabela usando linhas nas células sendo que os links ficam fora da tabela
>
> ===========================================
> |First Header | Second Header| Third Header
> |:-------------|:------------ |:-----------
> |[onze][11] | [12] | [13]
> |[21] | [vinde e dois][22] | [23]
> |[31] | [32] | [three trees][33]
>
> > #### Abaixo temos a matriz com os links da tabela acima. (A matriz ficará oculta quando o html for gerado)
> >
> > [11]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=11
> > [12]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=12
> > [13]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=13
> > [21]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=21
> > [22]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=22
> > [23]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=23
> > [31]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=31
> > [32]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=32
> > [33]: http://www.a-big-long-big-big-long-hyperlink/more-long-stuff?id=33

<text onclick="goBack()">[🔙]</text>

<span id="id-Listas-Nao-Ordenadas-exemplo-resultado"><span>

---

> ### Lista não ordenada
>
> - Titulo da lista
>   - item 01
>   - item 02
>   - item 03

<text onclick="goBack()">[🔙]</text>

---

<span id="id-lista-ordenada-exemplo"><span>

> ### Lista ordenada
>
> 1. Título
>    1. item 01
>    2. item 03
>
> <text onclick="goBack()">[🔙]</text>

<span id="id-hr-resultado"><span>

> ### A tag (\_\_\_) simula comportamento da tag html \<hr\>

<text onclick="goBack()">[🔙]</text>

---

### [Diagramas de relacionamento de entidades](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram)

---

<span id="id-details-exemplo"><span>

### Elemento semântico html \<details\>

> O elemento semântico html \<details\> funciona em markdown se o mesmo estiver isolado do código markdown, já que html não conhece markdown.
>
>  <details>
>    <summary>Exemplo da tag html details</summary>
>      <p>Tudo que tiver dentro da tag html &lt;details&gt; e &lt;/details&gt;  só aparecerá se o mouse for clicado no botão </p>
>      <p>
>        * Este documento não será interpretado como documento markdown porque está dentro de um código html.
>      </p>
>      <ol>
>        <li>
>          item 01
>        </li>
>        <li>
>          item 0>
>  </details>
>
> ```html
> <details>
>   <summary>Exemplo da tag html details</summary>
>   <p>
>     Tudo que tiver dentro da tag html &lt;details&gt; e &lt;/details&gt; só
>     aparecerá se o mouse for clicado no botão
>   </p>
>   <p>
>     * Está linha não será interpretado como documento markdown porque está
>     dentro de um código html..
>   </p>
>   <ol>
>     <li>item 01</li>
>     <li>item 02</li>
>   </ol>
> </details>
> ```

<text onclick="goBack()">[🔙]</text>

---

<span id="id-markdown-footnotes-exemplo"><span>

## [Demostração da extensão markdown-footnotes](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes)

```markdown
1.  Aqui está uma nota de rodapé simples, [^1]
2.  e aqui está outra mais longa.[^2]

    1. NOTAS DE RODAPÉS QUE SERÁ INCLUÍDO NO FINAL DO HTML.
       1. [^1]: Esta é a primeira nota de rodapé.
       2. [^2]:
              Aqui está um com vários parágrafos e código.
              Avance parágrafos para incluí-los na nota de rodapé.
              Adicione quantos parágrafos desejar.

3.  Esse texto espero não entrar na nota de rodapé número.
```

### O Código markdown com **notas de rodapé** descrito acima

1. Aqui está uma nota de rodapé simples, [^1].
2. e aqui está outra mais longa.[^2]

   1. NOTAS DE RODAPÉS QUE SERÁ INCLUÍDO NO FINAL DO HTML.
      1. [^1]: Esta é a primeira nota de rodapé.
      2. [^2]:
             Aqui está um com vários parágrafos e código.
             Avance parágrafos para incluí-los na nota de rodapé.
             Adicione quantos parágrafos desejar.

3. Esse texto espero não entrar na nota de rodapé número.

<text onclick="goBack()">[🔙]</text>

---

### [Vai para o incio](#id_topo "Vai para o topo do documento")

<pre>

   Se esse texto aparecer preto é porque o meu tema foi aceito.
</pre>

<span id=id_referencias></span>

## REFERÊNCIAS

<ol>
    <li>
        <a href="https://github.com/DavidAnson/markdownlint/blob/v0.21.1/doc/Rules.md#md023---headings-must-start-at-the-beginning-of-the-line" target="_blank" title="">Mensagens de erro sintático do código markdown</a>
    </li>
    <li>
        <a href="https://daringfireball.net/projects/markdown/syntax" target="_blank" title="">Markdown: Sintaxe</a>
    </li>
    <li><a href="https://www.markdownguide.org/getting-started/" target="_blank"
            title="Site com a documentação completa do markdown">O que é Markdown?</a></li>
    <li>
        <a href="https://www.markdownguide.org/basic-syntax/" target="_blank" title="">Sintaxe básica</a>
    </li>
    <li><a href="https://www.markdownguide.org/tools/" target="_blank" title="">Aplicativos e componentes que
        suportam Markdown.</a></li>
    <li>
        <a href="https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open"
            target="_blank" title="">Guia básico de Markdown</a>
    </li>
    <li>
        <a href="https://about.gitlab.com/handbook/markdown-guide/"
            target="_blank">https://about.gitlab.com/handbook/markdown-guide/</a>
    </li>
    <li>
        <a href="https://spec.commonmark.org/0.29/#why-is-a-spec-needed-"
            title="Documento da especificação Markdown - Versão 0.29 (06/04/2019)" target="_blank">Especificação
            CommonMark Spec</a>
    </li>
    <li>
        <a href="https://daringfireball.net/projects/markdown/syntax" target="_blank"
            title="Clique e acesse agora!">Markdown: Syntax</a>
    </li>
    <li>
        <a href="https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open"
            target="_blank" title="Clique e acesse agora!">Guia básico de Markdown</a>
    </li>
    <li>
        <a href="https://blog.da2k.com.br/2015/02/08/aprenda-markdown" target="_blank" title="">Aprenda Markdown</a>
    </li>
    <li>
        <a href="https://www.markdownguide.org/extended-syntax/" target="_blank" title="">Sintaxe Estendida</a>
    </li>
    <li>
        <a href="https://dillinger.io/" target="_blank">Editor Markdown free na WEB</a>
    </li>
    <li>
        <a href="https://stackedit.io/editor" target="_blank" title="Clique e acesse agora!">Editor de texto
            markdown na web</a>
    </li>
    <li>
        <a href="./markdown_readme.md" target="_blank" title="Clique e acesse agora!">./markdown readme.md</a>
    </li>
    <li>
        <a href="https://github.com/DavidAnson/markdownlint/blob/v0.21.1/doc/Rules.md#md033" target="_blank"
            title="">Todos os erros da extensão Markdownlint</a>
    </li>
    <li>
        <a href="https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open"
            target="_blank" title="">Guia-basico-de-markdown#open</a>
    </li>
    <li>
        <a href="https://markdown-guide.readthedocs.io/en/latest/basics.html" target="_blank"
            title="">https://markdown-guide.readthedocs.io/en/latest/basics.html</a>
    </li>
    <li>
        <a href="https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker"
            target="_blank" title="Corregedor ortográfico">code-spell-checker</a>
    </li>
    <li>
        <a href="https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker-portuguese-brazilian"
            target="_blank"
            title="Junto com a extensão code-spell-checker corrige ortografia em arquivos markdown ">code-spell-checker-portuguese-brazilian</a>
    </li>
    <li>
        <a href="https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes" target="_blank"
            title="Extensão bierner.markdown-footnotes">Extensão para criar notas de rodapé</a>
    </li>
    <li>
        <a href="https://marketplace.visualstudio.com/items?itemName=mdickin.markdown-shortcuts"        target="_blank" title="Essa extensão vscode facilita muito edição de tags markdown.">
          **Markdown Shortcuts**
        </a>
    </li>
    <li><a href="https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md"
           target="_blank"
           title="Todos os erros que pode aparecer ao codificar markdown">
           docs/RULES.md
           </a
        >
    </li>
    <li><a href="https://code.visualstudio.com/docs/languages/markdown" target="_blank" title="">Markdown e código do Visual Studio</a></li>
    <li>
        <a href="https://pandoc.org/MANUAL.html#extension-citations" target="_blank" title="">pandoc - extension-citations</a>
    </li>
    <li>
        <a href="https://pandoc.org/MANUAL.html" target="_blank" title="">Pandoc - Manual do Usuário</a>
    </li>
    <li>
        <a href="https://marketplace.visualstudio.com/items?itemName=bpruitt-goddard.mermaid-markdown-syntax-highlighting" target="_blank" title="">mermaid-markdown-syntax-highlighting</a>
    </li>
    <li>
        <a href="https://www.mkdocs.org/" target="_blank" title="">Gerador de sites mkdocs.org</a>
    </li>
    <li>
        <a href="https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW0NocmlzdG1hc10gLS0-fEdldCBtb25leXwgQihHbyBzaG9wcGluZylcbiAgICBCIC0tPiBDe0xldCBtZSB0aGlua31cbiAgICBDIC0tPnxPbmV8IERbTGFwdG9wXVxuICAgIEMgLS0-fFR3b3wgRVtpUGhvbmVdXG4gICAgQyAtLT58VGhyZWV8IEZbZmE6ZmEtY2FyIENhcl1cbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9" target="_blank" title="">Mermaid Live Editor</a>
    </li>

</ol>

</main>

[🔝🔝](#topo "Retorna ao topo")