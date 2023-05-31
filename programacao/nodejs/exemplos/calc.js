/**
* Exemplo de usu do módulo  soma para ser visualizado no console do linux
* Programa: calc.js
* Data: 29/01/2021 
* sintaxe esperada: p1 , sinal, p2
*/
var myArgs = process.argv.slice(2);
console.log(myArgs[0], myArgs[1], myArgs[2]);    

var calculator = require('./modulos/calculator.js');

switch (myArgs[1]) {
    case '+':
        console.log(myArgs[0], myArgs[1], myArgs[2], ' soma = ',calculator.soma(myArgs[0],myArgs[2]));   
        console.log(myArgs[0], myArgs[1], myArgs[2], ' sum = ',calculator.sum(myArgs[0],myArgs[2]));     
        break;

    case '-':
        console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.subtrai(myArgs[0],myArgs[2]));          
        break;
        console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.multiplica(myArgs[0],myArgs[2]));           
        break;

    case '/':
        console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.dividi(myArgs[0],myArgs[2]));           
        break;

    default:
        console.log('Desculpe, isso não é algo que eu sei fazer.');
}

