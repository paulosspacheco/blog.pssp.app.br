// 4. **[Função de seta](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions/Arrow_functions) assíncrona**
//      1. Aqui está o mesmo exemplo mais uma vez, mas desta vez definido como uma função de seta:
//         1. Código JavaScript

//             ```javascript

function palhaço_assustador() {
    return new Promise(
                resolve => {setTimeout(() => { resolve('🤡');}, 2000);});
}
const msg = async () => {  
                const msg = await palhaço_assustador();
                console.log('Message:', msg);
                }

console.log(msg().then);              

//            ```

  