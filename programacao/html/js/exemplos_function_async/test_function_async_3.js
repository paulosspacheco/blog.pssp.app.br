/*  3. **Promessa de retorno**.
     1. As funções assíncronas sempre retornam uma promessa, portanto, 
        o seguinte pode não produzir o resultado que você deseja:
        1. Código JavaScript:

            ```javascript
*/
               async function hello() {
               return 'Hello Alligator!';
               }

               const b = hello();

               console.log(b); // [object Promise] { ... }

  