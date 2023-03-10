
/**
 * Observe o  código TypeScript abaixo e observe a palavra 
 * let e string são da linguagem TypeScript e não pertence ao javascript.
 */

let message: string = 'Hello World';

//Mensagem escrita no console:
console.log(message);

//Vamos dar uma olhada em um exemplo simples baseado em classe:

class Greeter {
    greeting: string;
  
    constructor(message: string) {
      this.greeting = message;
    }
  
    greet() {
      return "Hello, " + this.greeting;
    }
  }
  
  let greeter = new Greeter("world");

  console.log(greeter.greet() );
