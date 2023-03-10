/**
 * Observe o  código TypeScript abaixo e observe a palavra
 * let e string são da linguagem TypeScript e não pertence ao javascript.
 */
var message = 'Hello World';
//Mensagem escrita no console:
console.log(message);
//Vamos dar uma olhada em um exemplo simples baseado em classe:
var Greeter = /** @class */ (function () {
    function Greeter(message) {
        this.greeting = message;
    }
    Greeter.prototype.greet = function () {
        return "Hello, " + this.greeting;
    };
    return Greeter;
}());
var greeter = new Greeter("world");
console.log(greeter.greet());

