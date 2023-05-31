// 2. <span id=id_sintaxe></span>[**Sintaxe da função seta (arrow function)**](https://developer.mozilla.org//en-US/docs/Web/JavaScript/Reference/Functions#the_arrow_function_expression_%3E):
// 1. ([param[, param]]) => { statements}
// 2. param => expression
//    1. **param**
//       1. O nome de um argumento. Nenhum argumento precisa ser indicado com (). Para apenas um argumento, os parênteses não são necessários. (como  foo => 1)
//    2. **statements** or expression
//       1. Várias instruções precisam ser colocadas entre colchetes. Uma única expressão não requer colchetes. A expressão também é o valor de retorno implícito da função.
// 3. Diferenças e limitações das arrow functions :
//    1. Não tem vínculos próprios com [this](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this) ou [super](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/super) não deve ser usado como [methods](https://developer.mozilla.org/en-US/docs/Glossary/Method).
//    2. Não tem [arguments](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments), nem [new.targe](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target)t palavras-chave.
//    3. Não é adequado para [call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call), [apply](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) e [bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) métodos, que geralmente dependem de estabelecer um [scope](https://developer.mozilla.org/en-US/docs/Glossary/Scope).
//    4. Não pode ser usado como [constructors](https://developer.mozilla.org/en-US/docs/Glossary/Constructor).
//    5. Não pode usar [yield](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield), dentro de seu corpo.
// 4. Exemplos:
//    1. Exemplo javascript para contar o tamanho de cada string de um array:

//       ```javascript

         const materials = [
         'Hydrogen',
         'Helium',
         'Lithium',
         'Beryllium'
         ];

         console.log(materials.map(material => material.length));
         // expected output: Array [8, 6, 7, 9]
