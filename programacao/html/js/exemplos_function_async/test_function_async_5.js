// 3. **Expressão de função assíncrona**
// 1. O exemplo abaixo é a função assíncrona do nosso primeiro exemplo, mas definida como uma expressão de função:
//    1. Código JavaScript:
//    3. **Expressão de função assíncrona**
//    1. O exemplo abaixo é a função assíncrona do nosso primeiro exemplo, mas definida como uma expressão de função:
//       1. Código JavaScript:
   
//           ```javascript

function palhaço_assustador() {
    return new Promise(
                 resolve => {setTimeout(() => { resolve('🤡');}, 2000);});
}
const msg = async function() {  
                    const msg = await palhaço_assustador();
                    console.log('Message:', msg);
                }

console.log(msg().then);

       //```
