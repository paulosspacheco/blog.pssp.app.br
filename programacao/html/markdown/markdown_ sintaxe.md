Markdown: Sintaxe
================

<ul id = "ProjectSubmenu">
    <li> <a href="/projects/markdown/" title="Markdown Project Page"> Principal </a> </li>
    <li> <a href="/projects/markdown/basics" title="Markdown Basics"> Noções básicas </a> </li>
    <li> <a class="selected" title="Markdown Syntax Documentation"> Sintaxe </a> </li>
    <li> <a href="/projects/markdown/license" title="Pricing and License Information"> Licença </a> </li>
    <li> <a href="/projects/markdown/dingus" title="Online Markdown Web Form"> Dingus </a> </li>
</ul>

* [Visão geral](#visão geral)
  * [Filosofia](#filosofia)
  * [Inline HTML](#html)
  * [Escape automático para caracteres especiais](#autoescape)
  * [Elementos do bloco](#bloco)
  * [Parágrafos e quebras de linha](#p)
  * [Cabeçalhos](#cabeçalho)
  * [Blockquotes](#blockquote)
  * [Listas](#lista)
  * [Blocos de código](#pré-código)
  * [Regras horizontais](#h)
  * [Span Elements](#span)
  * [Links](#link)
  * [Ênfase](#em)
  * [Código](#código)
  * [Imagens](#img)
* [Diversos](#misc)
  * [Escapes de barra invertida](#barra invertida)
  * [Links automáticos](#autolink)


** Nota: ** Este documento foi escrito usando Markdown; vocês
pode [ver a fonte adicionando '.text' ao URL] [src].

  [src]: /projects/markdown/syntax.text

* * *

<h2 id = "overview"> Visão geral </h2>

<h3 id = "philosophia"> Filosofia </h3>

O Markdown se destina a ser tão fácil de ler e escrever quanto possível.

A legibilidade, no entanto, é enfatizada acima de tudo. Um formatado em Markdown
documento deve ser publicável como está, como texto simples, sem olhar
como se tivesse sido marcado com tags ou instruções de formatação. Enquanto
A sintaxe do Markdown foi influenciada por vários textos para HTML existentes
filtros - incluindo [Setext] [1], [atx] [2], [Textile] [3], [reStructuredText] [4],
[Grutatext] [5] e [EtText] [6] - a única maior fonte de
A inspiração para a sintaxe do Markdown é o formato do e-mail em texto simples.

  [1]: http://docutils.sourceforge.net/mirror/setext.html
  [2]: http://www.aaronsw.com/2002/atx/
  [3]: http://textism.com/tools/textile/
  [4]: http://docutils.sourceforge.net/rst.html
  [5]: http://www.triptico.com/software/grutatxt.html
  [6]: http://ettext.taint.org/doc/

Para este fim, a sintaxe do Markdown é composta inteiramente de pontuação
caracteres, cujos caracteres de pontuação foram cuidadosamente escolhidos para
para parecer o que eles significam. Por exemplo, asteriscos ao redor de uma palavra, na verdade
parece com \ * ênfase \ *. As listas de markdown parecem, bem, listas. Até
blockquotes parecem passagens de texto citadas, supondo que você já
e-mail usado.



<h3 id = "html"> HTML embutido </h3>

A sintaxe do Markdown tem um propósito: ser usada como um
formato para * escrever * para a web.

Markdown não é um substituto para o HTML, nem mesmo perto disso. Está
sintaxe é muito pequena, correspondendo apenas a um subconjunto muito pequeno de
Tags HTML. A ideia é * não * criar uma sintaxe que torne mais fácil
para inserir tags HTML. Na minha opinião, as tags HTML já são fáceis de
inserir. A ideia do Markdown é torná-lo fácil de ler, escrever e
editar prosa. HTML é um formato de * publicação *; Markdown é uma * escrita *
formato. Assim, a sintaxe de formatação do Markdown aborda apenas questões que
pode ser transmitido em texto simples.

Para qualquer marcação que não seja coberta pela sintaxe do Markdown, você simplesmente
use o próprio HTML. Não há necessidade de precedê-lo ou delimitá-lo para
indicam que você está mudando de Markdown para HTML; você acabou de usar
as tags.

As únicas restrições são os elementos HTML de nível de bloco - por exemplo, `<div>`,
`<table>`, `<pre>`, `<p>`, etc. - deve ser separado do ambiente
o conteúdo por linhas em branco e as tags de início e fim do bloco devem
não ser indentado com tabulações ou espaços. Markdown é inteligente o suficiente, não
para adicionar tags `<p>` extras (indesejadas) em torno das tags de nível de bloco HTML.

Por exemplo, para adicionar uma tabela HTML a um artigo Markdown:

    Este é um parágrafo regular.

    <table>
        <tr>
            <td> Foo </td>
        </tr>
    </table>

    Este é outro parágrafo regular.

Observe que a sintaxe de formatação do Markdown não é processada no nível de bloco
Tags HTML. Por exemplo, você não pode usar o estilo Markdown `* ênfase *` dentro de um
Bloco de HTML.

Tags HTML de nível de expansão - por exemplo, `<span>`, `<cite>` ou `<del>` - podem ser
usado em qualquer lugar em um parágrafo Markdown, item de lista ou cabeçalho. Se vocês
desejar, você pode até usar tags HTML em vez da formatação Markdown; por exemplo, se
você prefere usar as tags HTML `<a>` ou `<img>` em vez das tags do Markdown
link ou sintaxe de imagem, vá em frente.

Ao contrário das tags HTML de nível de bloco, a sintaxe Markdown * é * processada dentro
tags de nível de amplitude.

<h3 id = "autoescape"> Escape automático para caracteres especiais </h3>

Em HTML, existem dois caracteres que exigem tratamento especial: `<`
e `&`. Os colchetes angulares esquerdos são usados ​​para iniciar as tags; e comercial são
usado para denotar entidades HTML. Se você quiser usá-los como literais
caracteres, você deve escapá-los como entidades, por exemplo, `& lt;`, e
`& amp;`.

Os e comerciais em particular são atormentadores para os escritores da web. Se você quiser
escrever sobre 'AT&T', você precisa escrever '`AT & amp; T`'. Você ainda precisa
escape e comercial em URLs. Portanto, se você deseja criar um link para:

    http://images.google.com/images?num=30&q=larry+bird

você precisa codificar o URL como:

    http://images.google.com/images?num=30&q=larry+bird

no atributo da tag âncora `href`. Não é preciso dizer que é fácil
esqueça, e é provavelmente a fonte mais comum de validação de HTML
erros em sites bem marcados.

Markdown permite que você use esses personagens naturalmente, cuidando de
todo o escape necessário para você. Se você usar um E comercial como parte de
uma entidade HTML, ela permanece inalterada; caso contrário, será traduzido
em `& amp;`.

Então, se você quiser incluir um símbolo de direitos autorais em seu artigo, você pode escrever:

    &cópia de;

e o Markdown vai deixá-lo sozinho. Mas se você escrever:

    AT&T

Markdown irá traduzi-lo para:

    AT & amp; T

Da mesma forma, como o Markdown oferece suporte a [HTML embutido](#html), se você usar
colchetes angulares como delimitadores para tags HTML, Markdown irá tratá-los como
tal. Mas se você escrever:

    4 <5

Markdown irá traduzi-lo para:

    4 & lt; 5

No entanto, dentro do código Markdown, vãos e blocos, colchetes angulares e
Os e comerciais são **sempre** codificados automaticamente. Isso torna mais fácil de usar
Markdown para escrever sobre o código HTML. (Ao contrário do HTML bruto, que é um
formato terrível para escrever sobre a sintaxe HTML, porque cada `<`
e `&` em seu código de exemplo precisa ser escapado.)


* * *


<h2 id = "block"> Elementos do bloco </h2>


<h3 id = "p"> Parágrafos e quebras de linha </h3>

Um parágrafo é simplesmente uma ou mais linhas consecutivas de texto, separadas
por uma ou mais linhas em branco. (Uma linha em branco é qualquer linha que se pareça com um
linha em branco - uma linha contendo nada além de espaços ou tabulações é considerada
em branco.) Parágrafos normais não devem ser recuados com espaços ou tabulações.

A implicação da regra "uma ou mais linhas consecutivas de texto" é
que o Markdown suporta parágrafos de texto "hard-wrap". Isso difere
significativamente da maioria dos outros formatadores de texto para HTML (incluindo Movable
Opção "Converter quebras de linha" do tipo), que traduz cada quebra de linha
caractere em um parágrafo em uma tag `<br />`.

Quando você * quer * inserir uma tag de quebra `<br />` usando Markdown, você
termine uma linha com dois ou mais espaços e digite return.

Sim, isso exige um pouco mais de esforço para criar um `<br />`, mas um simplista
"cada quebra de linha é uma regra` <br /> `" não funcionaria para Markdown.
Estilo de e-mail do Markdown [blockquoting] [bq] e vários parágrafos [itens da lista] [l]
funcionam melhor - e têm melhor aparência - quando você os formata com pausas rígidas.

  [bq]: #blockquote
  [l]: #list



<h3 id = "header"> Cabeçalhos </h3>

Markdown suporta dois estilos de cabeçalhos, [Setext] [1] e [atx] [2].

Os cabeçalhos de estilo setext são "sublinhados" usando sinais de igual (para o primeiro nível
cabeçalhos) e travessões (para cabeçalhos de segundo nível). Por exemplo:

    Este é um H1
    =============

    Este é um H2
    -------------

Qualquer número de sublinhado `=` 's ou `-`'s funcionará.

Os cabeçalhos de estilo Atx usam de 1 a 6 caracteres hash no início da linha,
correspondendo aos níveis de cabeçalho 1-6. Por exemplo:

    # Este é um H1

    ## Este é um H2

    ###### Este é um H6

Opcionalmente, você pode "fechar" cabeçalhos de estilo atx. Isso é puramente
cosmético - você pode usar se achar que fica melhor. o
os hashes de fechamento nem precisam corresponder ao número de hashes
usado para abrir o cabeçalho. (O número de hashes de abertura
determina o nível do cabeçalho.):

    # Este é um H1 #

    ## Este é um H2 ##

    ### Este é um H3 ######


<h3 id = "blockquote"> Blockquotes </h3>

Markdown usa caracteres do estilo de email `>` para citações em bloco. Se vocês são
familiarizado com a citação de trechos de texto em uma mensagem de e-mail, então você
sabe como criar um blockquote no Markdown. Parece melhor se você estiver duro
envolva o texto e coloque um `>` antes de cada linha:

    > Este é um blockquote com dois parágrafos. Lorem ipsum dolor sit amet,
    > consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
    > Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.
    > 
    > Donec sit amet nisl. Aliquam sempre ipsum sit amet velit. Suspendisse
    > id sem consectetuer libero luctus adipiscing.

Markdown permite que você seja preguiçoso e apenas coloque o `>` antes do primeiro
linha de um parágrafo embrulhado:

    > Este é um blockquote com dois parágrafos. Lorem ipsum dolor sit amet,
    consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
    Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.

    > Donec sit amet nisl. Aliquam sempre ipsum sit amet velit. Suspendisse
    id sem consectetuer libero luctus adipiscing.

Blockquotes podem ser aninhados (ou seja, um blockquote-in-a-blockquote) por
adicionar níveis adicionais de `>`:

    > Este é o primeiro nível de citação.
    >
    >> Este é um blockquote aninhado.
    >
    > Voltar ao primeiro nível.

Blockquotes podem conter outros elementos Markdown, incluindo cabeçalhos, listas,
e blocos de código:

	> ## Este é um cabeçalho.
	> 
	> 1. Este é o primeiro item da lista.
	> 2. Este é o segundo item da lista.
	> 
	> Aqui está um exemplo de código:
	> 
	> return shell_exec ("echo $ input | $ markdown_script");

Qualquer editor de texto decente deve facilitar as citações no estilo e-mail. Para
exemplo, com o BBEdit, você pode fazer uma seleção e escolher Aumentar
Nível de cotação no menu Texto.


<h3 id = "list"> Listas </h3>

Markdown suporta listas ordenadas (numeradas) e não ordenadas (com marcadores).

Listas não ordenadas usam asteriscos, sinais de mais e hifens - de forma intercambiável
- como marcadores de lista:

    * Vermelho
    * Verde
    * Azul

é equivalente a:

    + Vermelho
    + Verde
    + Azul

e:

    - vermelho
    - verde
    - azul

Listas ordenadas usam números seguidos de pontos:

    1. Bird
    2. McHale
    3. Paróquia

É importante notar que os números reais que você usa para marcar o
lista não tem efeito na saída HTML que o Markdown produz. O HTML
O Markdown produzido da lista acima é:

    <ol>
    <li> pássaro </li>
    <li> McHale </li>
    <li> Freguesia </li>
    </ol>

Se, em vez disso, você escreveu a lista no Markdown assim:

    1. Bird
    1. McHale
    1. Freguesia

ou mesmo:

    3. Bird
    1. McHale
    8. Freguesia

você obteria exatamente a mesma saída HTML. A questão é, se você quiser,
você pode usar números ordinais em suas listas Markdown ordenadas, de modo que
os números em sua fonte correspondem aos números em seu HTML publicado.
Mas se você quiser ser preguiçoso, não precisa.

Se você usar a numeração de lista preguiçosa, no entanto, você ainda deve iniciar o
lista com o número 1. Em algum momento no futuro, Markdown pode suportar
começando listas ordenadas em um número arbitrário.

Os marcadores de lista normalmente começam na margem esquerda, mas podem ser recuados por
até três espaços. Os marcadores de lista devem ser seguidos por um ou mais espaços
ou uma guia.

Para deixar as listas bonitas, você pode envolver os itens com recuos deslocados:

    * Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
        Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
        viverra nec, fringilla in, laoreet vitae, risus.
    * Donec sente-se amet nisl. Aliquam sempre ipsum sit amet velit.
        Suspendisse id sem consectetuer libero luctus adipiscing.

Mas se você quiser ser preguiçoso, não precisa:

    * Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
    * Donec sente-se amet nisl. Aliquam sempre ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.

Se os itens da lista forem separados por linhas em branco, o Markdown envolverá o
itens em tags `<p>` na saída HTML. Por exemplo, esta entrada:

    * Pássaro
    * Magia

vai se transformar em:

    <ul>
    <li> pássaro </li>
    <li> Magia </li>
    </ul>

Mas isso:

    * Pássaro

    * Magia

vai se transformar em:

    <ul>
    <li><p>Bird</p> </li>
    <li><p>Magic</p> </li>
    </ul>

Os itens da lista podem consistir em vários parágrafos. Cada subseqüente
parágrafo em um item de lista deve ser indentado por 4 espaços
ou uma guia:

    1. Este é um item de lista com dois parágrafos. Lorem ipsum dolor
        sit amet, consectetuer adipiscing elit. Aliquam hendrerit
        mi posuere lectus.

        Vestibulum enim wisi, viverra nec, fringilla in, laoreet
        vitae, risus. Donec sente-se amet nisl. Aliquam sempre ipsum
        sente-se amet velit.

    2. Suspendisse id sem consectetuer libero luctus adipiscing.

Parece bom se você recuar cada linha do subseqüente
parágrafos, mas aqui novamente, Markdown permitirá que você seja
preguiçoso:

    * Este é um item de lista com dois parágrafos.

        Este é o segundo parágrafo do item da lista. Você é
    necessário apenas para indentar a primeira linha. Lorem ipsum dolor
    sit amet, consectetuer adipiscing elit.

    * Outro item da mesma lista.

Para colocar um blockquote dentro de um item da lista, o blockquote `>`
delimitadores precisam ser indentados:

    * Um item de lista com uma aspa:

        > Este é um blockquote
        > dentro de um item da lista.

Para colocar um bloco de código em um item da lista, o bloco de código precisa
ser indentado * duas vezes * - 8 espaços ou duas tabulações:

    * Um item de lista com um bloco de código:

            <o código vai aqui>


É importante notar que é possível acionar uma lista ordenada por
acidente, escrevendo algo assim:

    1986. Que ótima temporada.

Em outras palavras, uma sequência de * número-período-espaço * no início de um
linha. Para evitar isso, você pode fazer o escape do ponto com barra invertida:

    1986 \. Que ótima temporada.



<h3 id = "precode"> Blocos de código </h3>

Blocos de código pré-formatados são usados ​​para escrever sobre programação ou
código-fonte de marcação. Em vez de formar parágrafos normais, as linhas
de um bloco de código são interpretados literalmente. Markdown envolve um bloco de código
nas tags `<pre>` e `<code>`.

Para produzir um bloco de código no Markdown, simplesmente indente cada linha do
bloquear por pelo menos 4 espaços ou 1 tabulação. Por exemplo, com esta entrada:

    Este é um parágrafo normal:

        Este é um bloco de código.

O Markdown irá gerar:

    <p> Este é um parágrafo normal: </p>

    <pre> <code> Este é um bloco de código.
    </code> </pre>

Um nível de recuo - 4 espaços ou 1 tabulação - é removido de cada
linha do bloco de código. Por exemplo, este:

    Aqui está um exemplo de AppleScript:

        diga ao aplicativo "Foo"
            bip
        fim dizer

vai se transformar em:

    <p> Aqui está um exemplo de AppleScript: </p>

    <pre> <code> diga ao aplicativo "Foo"
        bip
    fim dizer
    </code> </pre>

Um bloco de código continua até atingir uma linha que não está indentada
(ou no final do artigo).

Dentro de um bloco de código, e comercial (`&`) e colchetes angulares (`<` e `>`)
são convertidos automaticamente em entidades HTML. Isso o torna muito
fácil de incluir código-fonte HTML de exemplo usando Markdown - basta colar
e indentá-lo, e Markdown vai lidar com o incômodo de codificar o
e comercial e colchetes angulares. Por exemplo, este:

        <div class = "footer">
            &cópia de; 2004 Foo Corporation
        </div>

vai se transformar em:

    <pre> <code> & lt; div class = "rodapé" & gt;
        & amp; copiar; 2004 Foo Corporation
    & lt; / div & gt;
    </code> </pre>

A sintaxe regular do Markdown não é processada nos blocos de código. Por exemplo,
asteriscos são apenas asteriscos literais dentro de um bloco de código. Isso significa
também é fácil usar o Markdown para escrever sobre a própria sintaxe do Markdown.



<h3 id = "hr"> Regras horizontais </h3>

Você pode produzir uma tag de régua horizontal (`<hr />`) colocando três ou
mais hifens, asteriscos ou sublinhados em uma linha por si só. Se vocês
desejar, você pode usar espaços entre os hífens ou asteriscos. Cada um dos
as seguintes linhas produzirão uma régua horizontal:

    * * *

    ***

    *****

    - - -

    ---------------------------------------


* * *

<h2 id = "span"> Elementos Span </h2>

<h3 id = "link"> Links </h3>

Markdown suporta dois estilos de links: * inline * e * reference *.

Em ambos os estilos, o texto do link é delimitado por [colchetes].

Para criar um link embutido, use um conjunto de parênteses regulares imediatamente
após o colchete de fechamento do texto do link. Dentro dos parênteses,
coloque o URL para onde deseja que o link aponte, junto com um * opcional *
título do link, entre aspas. Por exemplo:

    Este é [um exemplo] (http://example.com/ "Título") link embutido.

    [Este link] (http://example.net/) não tem atributo de título.

Vai produzir:

    <p> Este é <a href="http://example.com/" title="Title">
    um exemplo </a> de link embutido. </p>

    <p> <a href="http://example.net/"> Este link </a> não tem
    atributo de título. </p>

Se você está se referindo a um recurso local no mesmo servidor, você pode
use caminhos relativos:

    Consulte minha página [Sobre] (/ sobre /) para obter detalhes.   

Os links de estilo de referência usam um segundo conjunto de colchetes, dentro
no qual você coloca um rótulo de sua escolha para identificar o link:

    Este é [um exemplo] [id] link de estilo de referência.

Você pode opcionalmente usar um espaço para separar os conjuntos de colchetes:

    Este é [um exemplo] [id] link de estilo de referência.

Então, em qualquer lugar do documento, você define o rótulo do link assim,
em uma linha por si só:

    [id]: http://example.com/ "Título opcional aqui"

Isso é:

* Colchetes contendo o identificador do link (opcionalmente
    recuado a partir da margem esquerda em até três espaços);
* seguido por dois pontos;
* seguido por um ou mais espaços (ou tabs);
* seguido pelo URL do link;
* opcionalmente seguido por um atributo de título para o link, incluído
    entre aspas simples ou duplas, ou entre parênteses.

As três definições de link a seguir são equivalentes:

	[foo]: http://example.com/ "Título opcional aqui"
	[foo]: http://example.com/ 'Título opcional aqui'
	[foo]: http://example.com/ (título opcional aqui)

** Observação: ** há um bug conhecido no Markdown.pl 1.0.1 que impede
as aspas simples sejam usadas para delimitar títulos de links.

O URL do link pode, opcionalmente, estar entre colchetes angulares:

    [id]: <http://example.com/> "Título opcional aqui"

Você pode colocar o atributo de título na próxima linha e usar espaços extras
ou guias para preenchimento, que tendem a ficar melhor com URLs mais longos:

    [id]: http://example.com/longish/path/to/resource/aqui
        "Título opcional aqui"

As definições de link são usadas apenas para criar links durante Markdown
processamento e são retirados de seu documento na saída HTML.

Os nomes de definição de link podem consistir em letras, números, espaços e
pontuação - mas eles * não * diferenciam maiúsculas de minúsculas. Por exemplo, esses dois
links:

	[texto do link] [a]
	[texto do link] [A]

são equivalentes.

O atalho *nome do link implícito* permite que você omita o nome do
link, caso em que o próprio texto do link é usado como o nome.
Basta usar um conjunto vazio de colchetes - por exemplo, para vincular a palavra
"Google" para o site google.com, você pode simplesmente escrever:
[Google][]

E então defina o link:

	[Google]: http://google.com/

Como os nomes dos links podem conter espaços, este atalho funciona até mesmo para
várias palavras no texto do link:

	Visite [Daring Fireball] [] para obter mais informações.

E então defina o link:
	
	[Daring Fireball]: http://daringfireball.net/

As definições de link podem ser colocadas em qualquer lugar em seu documento Markdown. Eu
tendem a colocá-los imediatamente após cada parágrafo em que estão
usado, mas se você quiser, pode colocá-los todos no final do seu
documento, como notas de rodapé.

Aqui está um exemplo de links de referência em ação:

    Recebo 10 vezes mais tráfego do [Google] [1] do que do
    [Yahoo] [2] ou [MSN] [3].

      [1]: http://google.com/ "Google"
      [2]: http://search.yahoo.com/ "Yahoo Search"
      [3]: http://search.msn.com/ "MSN Search"

Usando o atalho do nome do link implícito, você pode escrever:

    Recebo 10 vezes mais tráfego do [Google] [] do que do
    [Yahoo] [] ou [MSN] [].

      [google]: http://google.com/ "Google"
      [yahoo]: http://search.yahoo.com/ "Yahoo Search"
      [msn]: http://search.msn.com/ "MSN Search"

Ambos os exemplos acima produzirão a seguinte saída HTML:

    <p> Recebo 10 vezes mais tráfego de <a href = "http://google.com/"
    title = "Google"> Google </a> do que de
    <a href="http://search.yahoo.com/" title="Yahoo Search"> Yahoo </a>
    ou <a href="http://search.msn.com/" title="MSN Search"> MSN </a>. </p>

Para comparação, aqui está o mesmo parágrafo escrito usando
Estilo de link embutido do Markdown:

    Recebo 10 vezes mais tráfego do [Google] (http://google.com/ "Google")
    do que do [Yahoo] (http://search.yahoo.com/ "Yahoo Search") ou
    [MSN] (http://search.msn.com/ "MSN Search").

O ponto dos links de estilo de referência não é que sejam mais fáceis de
escrever. O ponto é que com links de estilo de referência, seu documento
a fonte é muito mais legível. Compare os exemplos acima: usando
links de estilo de referência, o próprio parágrafo tem apenas 81 caracteres
longo; com links de estilo embutido, tem 176 caracteres; e como HTML bruto,
são 234 caracteres. No HTML bruto, há mais marcação do que
é texto.

Com os links de estilo de referência do Markdown, um documento fonte muito mais
é muito semelhante à saída final, conforme renderizada em um navegador. Por
permitindo que você mova os metadados relacionados à marcação para fora do parágrafo,
você pode adicionar links sem interromper o fluxo narrativo de seu
prosa.

<h3 id = "em"> Ênfase </h3>

Markdown trata asteriscos (`*`) e sublinhados (`_`) como indicadores de
ênfase. O texto agrupado com um `*` ou `_` será agrupado com um
Tag HTML `<em>`; double `*` 's ou `_`'s serão embrulhados com um HTML
`<strong>` tag. Por exemplo, esta entrada:

    * asteriscos simples *

    _sublinhados_

    ** asteriscos duplos **

    __ sublinhados duplos__

vai produzir:

    <em> asteriscos únicos </em>

    <em> sublinhados simples </em>

    <strong> asteriscos duplos </strong>

    <strong> sublinhados duplos </strong>

Você pode usar o estilo de sua preferência; a única restrição é que
o mesmo caractere deve ser usado para abrir e fechar um intervalo de ênfase.

A ênfase pode ser usada no meio de uma palavra:

    inacreditável * malditamente * crível

Mas se você cercar um `*` ou `_` com espaços, será tratado como um
asterisco literal ou sublinhado.

Para produzir um asterisco literal ou sublinhado em uma posição onde
seria usado como um delimitador de ênfase, você pode usar uma barra invertida
escapar disso:

    \ * este texto está rodeado por asteriscos literais \ *



<h3 id = "code"> Código </h3>

Para indicar um intervalo de código, envolva-o com aspas crase (`` `` `).
Ao contrário de um bloco de código pré-formatado, um intervalo de código indica o código dentro de um
parágrafo normal. Por exemplo:

    Use a função `printf ()`.

vai produzir:

    <p> Use a função <code> printf () </code>. </p>

Para incluir um caractere literal de crase em um intervalo de código, você pode usar
vários acúmulos como delimitadores de abertura e fechamento:

    `` Há uma crase literal (`) aqui``

que irá produzir isso:

    <p> <code> Há uma crase literal (`) aqui. </code> </p>

Os delimitadores de crase em torno de um intervalo de código podem incluir espaços -
um após a abertura, um antes do fechamento. Isso permite que você coloque
caracteres literais de crase no início ou no final de um intervalo de código:

	Um único backtick em uma extensão de código: `` `` `
	
	Uma string delimitada por backtick em um intervalo de código: `` `foo`` `

vai produzir:

	<p> Um único crase em um intervalo de código: <code>`</code> </p>
	
	<p> Uma string delimitada por backtick em um código: <code>`foo`</code> </p>

Com uma extensão de código, e comercial e colchetes angulares são codificados como HTML
entidades automaticamente, o que torna mais fácil incluir exemplos de HTML
Tag. Markdown transformará isso:

    Não use nenhuma tag `<blink>`.

para dentro:

    <p> Não use nenhuma tag <code> & lt; blink & gt; </code>. </p>

Você pode escrever isto:

    `& # 8212;` é o equivalente codificado em decimal de `& mdash;`.

para produzir:

    <p> <code> & amp; # 8212; </code> é a codificação decimal
    equivalente a <code> & amp; mdash; </code>. </p>



<h3 id = "img"> Imagens </h3>

Reconhecidamente, é bastante difícil conceber uma sintaxe "natural" para
colocar imagens em um formato de documento de texto simples.

Markdown usa uma sintaxe de imagem que se destina a se assemelhar à sintaxe
para links, permitindo dois estilos: *embutido* e *referência*.

A sintaxe da imagem inline é semelhante a esta:

    ! [Texto alternativo] (/ caminho / para / img.jpg)

    ! [Texto alternativo] (/ caminho / para / img.jpg "Título opcional")

Isso é:

* Um ponto de exclamação: `!`;
* seguido por um conjunto de colchetes, contendo o `alt`
    atribuir texto para a imagem;
* seguido por um conjunto de parênteses, contendo o URL ou caminho para
    a imagem, e um atributo opcional `title` entre duas
    ou aspas simples.

A sintaxe da imagem de estilo de referência é semelhante a esta:

    ! [Alt text] [id]

Onde "id" é o nome de uma referência de imagem definida. Referências de imagem
são definidos usando uma sintaxe idêntica às referências de link:

    [id]: url / para / imagem "Atributo de título opcional"

No momento em que este livro foi escrito, o Markdown não tinha sintaxe para especificar o
dimensões de uma imagem; se isso for importante para você, você pode simplesmente
use tags HTML `<img>` regulares.


* * *


<h2 id = "misc"> Diversos </h2>

<h3 id = "autolink"> Links automáticos </h3>

Markdown suporta um estilo de atalho para a criação de links "automáticos" para URLs e endereços de e-mail: simplesmente coloque o URL ou endereço de e-mail entre colchetes angulares. O que isso significa é que se você deseja mostrar o texto real de um URL ou endereço de e-mail e também fazer com que seja um link clicável, você pode fazer o seguinte:

    <http://example.com/>
    
Markdown transformará isso em:

    <a href="http://example.com/"> http://example.com/ </a>

Links automáticos para endereços de e-mail funcionam de forma semelhante, exceto que
Markdown também executa um pouco de decimal e hexadecimal aleatório
codificação de entidade para ajudar a ocultar seu endereço da coleta de endereço
spambots. Por exemplo, o Markdown tornará isso:

    <endereço@example.com>

em algo assim:

    <a href = "& # x6D; & # x61; i & # x6C; & # x74; & # x6F;: & # x61; & # x64; & # x64; & # x72; & # x65;
    & # 115; & # 115; & # 64; & # 101; & # 120; & # x61; & # 109; & # x70; & # x6C; e & # x2E; & # 99; & # 111;
    & # 109; "> & # x61; & # x64; & # x64; & # x72; & # x65; & # 115; & # 115; & # 64; & # 101; & # 120; & # x61;
    & # 109; & # x70; & # x6C; e & # x2E; & # 99; & # 111; & # 109; </a>

que será processado em um navegador como um link clicável para "address@example.com".

(Este tipo de truque de codificação de entidade vai de fato enganar muitos, se não
a maioria, bots de coleta de endereços, mas definitivamente não enganará todos
eles. É melhor do que nada, mas um endereço publicado desta forma
provavelmente começará a receber spam.)

<h3 id = "backslash"> Escapes de barra invertida </h3>

Markdown permite que você use escapes de barra invertida para gerar
caracteres que, de outra forma, teriam um significado especial no Markdown
sintaxe de formatação. Por exemplo, se você quiser cercar uma palavra
com asteriscos literais (em vez de uma tag HTML `<em>`), você pode usar
barras invertidas antes dos asteriscos, como este:

    \ * asteriscos literais \ *

Markdown fornece escapes de barra invertida para os seguintes caracteres:

    \ barra invertida
    `backtick
    * asterisco
    _ sublinhado
    {} chaves
    [] colchetes
    () parênteses
    # marca de hash
	+ sinal de mais
	- sinal de menos (hífen)
    . ponto
    ! ponto de exclamação
