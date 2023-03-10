// 2. <span id=Como_fazer_01></span>**Qual a diferença entre arrow function (=>) e function() em javascript**

// 1. Arrow-Function incluída na es6 não é apenas uma [sugar syntax](https://pt.wikipedia.org/wiki/A%C3%A7%C3%BAcar_sint%C3%A1tico) de Function, as duas sintaxes tem suas peculiaridades. Abaixo citarei algumas delas e quais as vantagens em usar as Arrow functions.

//    1. O que é arrow function?
//       1. Arrow function é uma função no javascript, porem ela traz algumas diferenças quando comparada com funções normais, vejamos abaixo:
//          1. **Lexical this**
//             1. Ele captura o valor de **this** do contexto vinculado, ou seja do escopo em que ele se encontra, por exemplo:
//                1. Código JavaScript

              // ```javascript

                  function Mensagem() {
                  
                     this.mensagem = 'Passou';
                     
                     // Traditional function
                     this.logado = function() {
                        setTimeout(function() {console.log(this.mensagem);}, 1000);
                     };
                     
                  }

                  var msg = new Mensagem(); 
                  msg.logado(); // undefined


            //    ```

            // 2. A função _Mensagem_ ao ser instanciada, retornara um objeto com 2 propriedades, _mensagem_ e _logado_. Que não logou a _mensagem_ desejada porque o **this** na linha 8 trata-se da função anônima _logado_. Para funcionar como esperado, basta trocar a função na linha 7 por uma **arrow function**.
            //    1. Código JavaScript

            //    ```javascript

                  function MensagemArrow() {
                  
                     this.mensagem = 'Passou';
                     
                     // Arrow function
                     this.logado = function() {
                        setTimeout( () => {console.log(this.mensagem);}, 1000 );
                     }
                     
                  }

                  var msgArrow = new MensagemArrow(); 
                  msgArrow.logado(); // "Passou"


            //    ```

            // 3. Neste caso funciona como esperado porque o **this** dentro da arrow function é uma referência do **this** da função acima no caso a função _Mensagem_ assim o **this** dentro da função _logado_ será o mesmo que o da função _Mensagem_.
