//```javascript

/**
 * Exemplo de function assíncrona
 * test_function_async_2.js
 * O poder das funções assíncronas se torna mais evidente quando 
 * há várias etapas envolvidas.
 */            
function who() {
   return new Promise(
      resolve => {setTimeout(() => {resolve('🤡');}, 200);});
}

function what() {
   return new Promise(
      resolve => {setTimeout(() => {resolve('espreita');}, 300);});
}

function where() {
   return new Promise(
      resolve => {setTimeout(() => {resolve('nas sombras');}, 500)});
}

async function msg() {
   const a = await who();
   const b = await what();
   const c = await where();

   console.log(`${ a } ${ b } ${ c }`);
}

msg(); // 🤡 espreita nas sombras <- após 1 segundo

//```
