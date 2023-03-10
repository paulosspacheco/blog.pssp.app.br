# <span id="topo"><span>Modelo de documento markdown <a href="arrow_functions.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="arrow_functions.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo da função seta](#id_objetivo)

      2. [Pre-requisitos.](#id_pre_requisitos)

   2. [Sintaxe da function seta (arrow function)](#id_sintaxe)

   3. [Diferença entre arrow function (=>) e function() em javascript](#id_diferença_arrow_function)

   4. [Referências](#id_referencias)
   5. [Histórico](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**
      1. **Objetivo**

         1. <span id="id_objetivo"><span>**Objetivo da função seta:**

            1. A arrow function tem por finalidade tornar a sintaxe mais fácil de ser lida e expressa, é útil quando usado como função anônima para interagir com coleções, porque  ela usa o **this** da coleção e não seu próprio **this**.
            2. Uma expressão arrow function possui uma sintaxe mais curta quando comparada a uma expressão de função (function expression) e não tem seu próprio **this**, **arguments**, **super** ou **new.target**. Estas expressões de funções são melhor aplicadas para funções que **não sejam métodos**, e elas não podem ser usadas como construtoras (**constructors**)
         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos**:
            1. Conhecimento da [linguagem html](https://developer.mozilla.org/pt-BR/docs/Glossario/HTML).
            2. Conhecimento de [funções javascript](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Function).

            3. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_sintaxe></span>[**Sintaxe da função seta (arrow function)**](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#syntax):

      1. **Sintaxe básica**:
         1. Um parâmetro com a expressão simples, o retorno não é necessário:
            1. param => expression
               1. **param**
                  1. O nome de um argumento.
                  2. Nenhum argumento precisa ser indicado com ().
                  3. Para apenas um argumento, os parênteses não são necessários. (como  foo => 1)
               2. **statements** or expression
                  1. Várias instruções precisam ser colocadas entre colchetes.
                  2. Uma única expressão não requer colchetes.
                  3. A expressão também é o valor de retorno implícito da função.

         2. Vários parâmetros requerem parênteses. Com a expressão simples, o retorno não é necessário:
            1. ([param[, param]]) => { statements}
            2. (param1, paramN) => expression

         3. As instruções multilinhas requerem colchetes e retorno:
            1. Código javascript:

               ```javascript

                 param => {  let a = 1;  
                           return a + param;
                          }

               ```

         4. Vários parâmetros requerem parênteses. As instruções multilinhas requerem colchetes e retorno:
            1. Código javascript:

               ```javascript

                 (param1, paramN) => { let a = 1;
                                       return a + param1 + paramN;
                                     }

               ```

      2. **Sintaxe avançada**:
         1. Para retornar uma expressão literal de objeto, são necessários parênteses em torno da expressão:
            1. Código javascript:

               ```javascript

                  params => ({foo: "a"}) // returning the object {foo: "a"}

               ```

         2. [Rest parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) are supported:
            1. Código javascript:

               ```javascript

                  (a, b, ...r) => expression

               ```

         3. [Default parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters) are supported:
            1. Código javascript:

               ```javascript

                  (a=400, b=20, c) => expression

               ```

         4. [Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)  within params supported:
            1. Código javascript:

               ```javascript

                  ([a, b] = [10, 20]) => a + b;  // result is 30
                  ({ a, b } = { a: 10, b: 20 }) => a + b; // result is 30

               ```

         5. [Exemplo javascript](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#fun%C3%A7%C3%B5es_mais_curtas) para contar o tamanho de cada string de um array:
            1. Código javascript:

               ```javascript

                  const materials = ['Hydrogen','Helium','Lithium','Beryllium'];
                 
                  /**
                   *  Array.prototype.map()
                   *  Cria uma nova matriz com os resultados da chamada de uma
                   *  função fornecida em cada elemento desta matriz.
                   *  EXEMPLO DE USO:
                  */
                  result = materials.map(material => material.length);
                  console.log(result);
                  // expected output: Array [8, 6, 7, 9]

               ```

         6. A lista de parâmetros para uma função sem parâmetros deve ser escrita com um par de parênteses.
            1. Código javascript:

               ```javascript

                     () => { statements }

               ```

      3. Diferenças e limitações das arrow functions :
         1. Não tem vínculos próprios com [this](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this) ou [super](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/super) não deve ser usado como [methods](https://developer.mozilla.org/en-US/docs/Glossary/Method).
         2. Não tem [arguments](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments), nem [new.targe](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target)t palavras-chave.
         3. Não é adequado para [call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call), [apply](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) e [bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) métodos, que geralmente dependem de estabelecer um [scope](https://developer.mozilla.org/en-US/docs/Glossary/Scope).
         4. Não pode ser usado como [constructors](https://developer.mozilla.org/en-US/docs/Glossary/Constructor).
         5. Não pode usar [yield](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield), dentro de seu corpo.

      4. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_diferença_arrow_function></span>**Diferença entre arrow function (=>) e function() em javascript**

      1. Arrow-Function incluída na es6 não é apenas uma [sugar syntax](https://pt.wikipedia.org/wiki/A%C3%A7%C3%BAcar_sint%C3%A1tico) de function, as duas sintaxes tem suas peculiaridades. Abaixo citarei algumas delas e quais as vantagens em usar as Arrow functions.

         1. O que é arrow function?
            1. Arrow function é uma função no javascript, porem ela traz algumas diferenças quando comparada com funções normais, vejamos abaixo:
               1. **Lexical this**
                  1. Ele captura o valor de **this** do contexto vinculado, ou seja do escopo em que ele se encontra, por exemplo:
                     1. Código JavaScript

                     ```javascript

                     1   function Mensagem() {
                     2   
                     3   this.mensagem = 'Passou';
                     4   
                     5   // Traditional function
                     6   this.logado = function() {
                     7         setTimeout(function() {//setTimeout=Executa um bloco específico uma vez depois de um determinado tempo
                     8         console.log(this.mensagem);         
                     9         },30);
                     10   };
                     11   }
                     12
                     13   var msg = new Mensagem(); 
                     14   msg.logado(); // undefined


                     ```

                  2. A função _Mensagem_ ao ser instanciada, retornara um objeto com 2 propriedades, _mensagem_ e _logado_. Que não logou a _mensagem_ desejada porque o **this** na linha 8 trata-se da função anônima _logado_. Para funcionar como esperado, basta trocar a função na linha 7 por uma **arrow function**.
                     1. Código JavaScript

                     ```javascript

                     1   function Mensagem() {
                     2   
                     3   this.mensagem = 'Passou';
                     4   
                     5   // Traditional function
                     6   this.logado = function() {
                     7         setTimeout(() => {  //setTimeout=Executa um bloco específico uma vez depois de um determinado tempo
                     8         console.log(this.mensagem);         
                     9         },30);
                     10   };
                     11   }
                     12
                     13   var msg = new Mensagem(); 
                     14   msg.logado(); // "Passou"

                     ```

                  3. Neste caso funciona como esperado porque o **this** dentro da arrow function é uma referência do **this** da função acima no caso a função _Mensagem_ assim o **this** dentro da função _logado_ será o mesmo que o da função _Mensagem_.
         2. .
      2. ...

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [Arrow functions descrição](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#descri%C3%A7%C3%A3o)

      2. [Arrow functions examples](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

      3. [Arrow functions syntax](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#syntax)

      4. [Arrow functions sintaxe avançada](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#sintaxe_avan%C3%A7ada)

      5. [Arrow functions usada em coleções](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#fun%C3%A7%C3%B5es_mais_curtas)

      6. [Arrow functions vs Functions](https://medium.com/frontend-quest/arrow-functions-vs-functions-9048ec12b5c6)

      7. [Arrow functions - https://developer.mozilla.org/](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions#syntax)

      8. [Arrow function expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

      9. [comparing traditional functions to arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions#comparing_traditional_functions_to_arrow_functions)

      10. [Syntactic Sugar](https://pt.wikipedia.org/wiki/A%C3%A7%C3%BAcar_sint%C3%A1tico)

      11. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 15/02/2021 <!--TODO: HISTÓRICO -->
         - [x] Criado a versão 0.0.1 deste documento;
         - [x] Escrever objetivo de arrow function
         - [x] Escrever a diferença entre arrow function e funções normais.
         - [x] Escrever o tópico sintaxe de arrow function;
         - [x] Conferir os links do documento
         - [x] Inserir os botões de retorno para o topo.

         - <text onclick="goBack()">[🔙]</text>

      2. 16/02/2021
         - [x] Fazer revisão do texto do documento para saber se os textos estão claros.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

<script>function goBack() { window.history.back()}</script>
