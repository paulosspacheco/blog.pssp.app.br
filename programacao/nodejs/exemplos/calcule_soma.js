/**
 * Exemplo de usu do módulo  soma para ser visualizado no console do linux
 * Programa: calcule_soma.js
 * Data: 29/01/2021 
 */

var soma = require('./soma');
console.log('Soma de 1+2 = '+soma(1,2));

//Parâmetros passado pela linha de comando
var myArgs = process.argv.slice(2);
console.log('myArgs: ', myArgs);