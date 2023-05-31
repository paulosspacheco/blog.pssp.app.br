
/**

               2. Como o que é retornado no passo anterior é uma promessa, você poderia fazer algo assim:
               1. Código JavaScript.
       
                   ```javascript
*/       
                         async function hello() {
                         return 'Hello Alligator!';
                         }
       
                         const b = hello();
       
                        //b.then(x => console.log(x)); // Hello Alligator!
                        hello().then(x => console.log(x)); // Hello Alligator!
       
                   //```               