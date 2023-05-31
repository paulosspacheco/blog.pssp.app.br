    /**
    * Exemplo de uso de passagem de parâmetro em node.js
    * Programa: node_argv.js
    * Data: 29/01/2021 
    */

var myArgs = process.argv.slice(2);

console.log('myArgs: ', myArgs);

switch (myArgs[0]) {
    case 'insulto':
        console.log('Parâmetro 0 =',myArgs[0], 'e parâmetro 1 =',myArgs[1], );
        break;

    case 'elogio':
        console.log('Parâmetro 0 =',myArgs[0], 'e parâmetro 1 =',myArgs[1], );
        break;

    default:
        console.log('Desculpe, isso não é algo que eu sei fazer.');
}