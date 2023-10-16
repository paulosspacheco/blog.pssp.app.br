#### Teoria sobre o Framework nodejs <a href="teoria_node_js.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. **OBJETIVOS**

   1. O [Nodejs](https://nodejs.org/api/documentation.html) é um interpretador javascript executado no servidor, é usado quando precisamos acessar recursos que não estão disponíveis na máquina cliente e sim na máquina servidora, exemplo: banco de dados e páginas html protegidas. Ele é um ambiente de execução da linguagem JavaScript assíncrono e orientado a eventos, o Node.js é projetado para desenvolvimento de aplicações escaláveis de rede.

   2. O [node.js](https://nodejs.org/api/documentation.html) não trabalha criando tarefas do sistema operacional, por isso uma aplicação nunca trava o computador e por isso, ele é indicado para criar [sistemas escaláveis](https://blog.tecnospeed.com.br/escalabilidade-de-software-o-que-e/).
      1. O Node.js permite maior número de conexões concorrentes em relação aos servidores tradicionais que usam tarefas do sistema operacional.
   3. Site oficial: <https://nodejs.org/en/>
   4. A documentação completa: <https://nodejs.org/en/docs/>
   5. Opção "/sobre" do site oficial com exemplos: [About Node.js®](https://nodejs.org/en/about/).
   6. [Node.js tutorial](http://www.w3big.com/pt/nodejs/default.html)
      1. [Curso node js em w3big.com](http://www.w3big.com/pt/nodejs/nodejs-install-setup.html).
      2. [Objetos globais e variáveis ​​globais](http://www.w3big.com/pt/nodejs/nodejs-global-object.html)

2. **EXEMPLOS DE USO DO NODEJS**
   1. [Como analisar argumentos de linha de comando](https://nodejs.org/en/knowledge/command-line/how-to-parse-command-line-arguments/)

      ```Javascript

        /**
        * Exemplo de uso do módulo soma para ser visualizado no console do linux
        * Programa: calc.js
        * Data: 29/01/2021 
        * sintaxe esperada: p1 , sinal, p2
        */
        var myArgs = process.argv.slice(2);
        console.log(myArgs[0], myArgs[1], myArgs[2]);    

        var calculator = require('./calculator.js');


        switch (myArgs[1]) {
            case '+':
                console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.soma(myArgs[0],myArgs[2]));    
                break;

            case '-':
                console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.subtrai(myArgs[0],myArgs[2]));          
                break;

            case '.':
                console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.multiplica(myArgs[0],myArgs[2]));           
                break;

            case '/':
                console.log(myArgs[0], myArgs[1], myArgs[2], ' = ',calculator.dividi(myArgs[0],myArgs[2]));           
                break;

            default:
                console.log('Desculpe, isso não é algo que eu sei fazer.');
        }

      ```

3. **[Exemplos de módulos http](https://www.youtube.com/watch?v=QnTCre0HHv8)**

   1. [Exemplo de uso do módulo 'http'](https://www.w3schools.com/nodejs/nodejs_http.asp):

     ```Javascript

         /** 
          * Para imprimir no browser usa-se o módulo 'http'.
          * Exemplo da uso do modulo http
          * Data: 29/01/2021
          * Programa: hello_world_Http.js
          */

         const http = require('http');
         const hostname = '127.0.0.1';
         
         const port = 8080;
         const server = http.createServer(
             (req, res) => {
                             res.statusCode = 200;
                             res.setHeader('Content-Type', 'text/plain');
                             res.end('Hello World');
                             }
         );
         server.listen(port, 
                         hostname, 
                         () => {console.log(`Server running at http://${hostname}:${port}/`);}
         );

     ```

4. **[Como criar módulos (units do pascal) no node.js](https://docs.npmjs.com/creating-node-js-modules)**
   1. Os módulos ficam em arquivos separados com extensão .js onde os programas e variáveis que serão vistos por outros arquivos devem ser declarados com a palavra reservada [module.exports](https://stackabuse.com/how-to-use-module-exports-in-node-js/).
   2. Exemplo de um módulo que soma, subtrai, multiplica e dividi:

        ```Javascript

           /**
            * Exemplo de módulos em nodejs
            * Nome do módulo calculator.js
            * Data: 29/01/2021
            */
            /**
              var calculator = {
                 soma    : function soma(a,b){ return a+b;  }  ,                        
                    subtrai : function subtrai(a,b){    return a-b; },
                    multiplica : function multiplica(a,b){return a*b;},
                    dividi : function dividi(a,b){return a/b; }
                };
                module.exports = calculator;    
            */
            class calculator {
                constructor() {
                }
                soma(a,b){ return parseInt(a)+parseInt(b) }

                subtrai(a,b){return parseInt(a)-parseInt(b)}

                multiplica(a,b){return parseInt(a)*parseInt(b)}

                dividi(a,b){return parseInt(a)/parseInt(b) }
            }

            let sum = function soma(a,b){ return parseInt(a)+parseInt(b) };

            module.exports = new calculator();
            module.exports.sum = sum;

        ```

   3. **Exemplo de execução do módulo _calculator_ no console:**

        ```Javascript

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

        ```

   4. **Executar programa _web_calculator.js_ para ser visualizado no browser:**

        ```Javascript

            /**
             * Exemplo da execução do modulo soma para ser visualizado no browser
            * Data: 29/01/2021
            * Módulo: web_calculator.js
            */

            var calculator = require('./modulos/calculator.js');
            const http = require('http');
            const hostname = '127.0.0.1';
            
            const port = 8080;
            const server = http.createServer(
                (req, res) => {
                    res.statusCode = 200;
                    res.setHeader('Content-Type', 'text/html');
                    res.end(
                        '<!DOCTYPE html>'+
                        '<html lang="pt-BR">'+
                            '<head>'+
                                '<meta charset="utf-8" />'+
                                '<title>Exemplo do módulo calculator.js</title>'+
                            '</head>'+
                            '<bodY>'+
                        
                                '<p> Soma de 1+2 = '+calculator.soma(1,2)+'</p>'+
                                '<p> Sum  de 1+2 = '+calculator.sum(1,2)+'</p>'+
                                '<p> subtrai  de 1-2 = '+calculator.subtrai(1,2)+'</p>'+
                                '<p> multiplica  de 1 * 2 = '+calculator.multiplica (1,2)+'</p>'+
                                '<p> dividi  de 1 / 2 = '+calculator.dividi (1,2)+'</p>')+

                            ' </body>'+
                        '</html>'    
                }
            );
            server.listen(port, 
                            hostname, 
                            () => {console.log(`Server running at http://${hostname}:${port}/`);}
            );

        ```

   5. **Executar programa  _calc.js_ e _web_calculator.js_ no console:**

        ```sh
            
            # Seleciona a pasta /programacao/nodejs/exemplos
            cd /programacao/nodejs/exemplos

            # Calcula a soma de 1 + 2
            nodejs  calc 3 + 2
            3 + 2
            3 + 2  soma =  5
            3 + 2  sum =  5

            # Executa o servidor web_calculator.js 
            nodejs web_calculator.js                
            Server running at http://127.0.0.1:8080/

        ```

5. **Como implementar modulo em nodejs**

   1. [Pastas como módulos](https://nodejs.org/api/modules.html#modules_folders_as_modules)

   2. [Módulos: módulos CommonJS](https://nodejs.org/api/modules.html#modules_modules_commonjs_modules)

   3. Como criar e usar módulos em nodejs.
      1. [Vídeo aula 04](https://www.youtube.com/watch?v=bWSkUscBeZc)

   4. Como acessar arquivos em nodejs.
      1. [Usar módulo fs](http://www.w3big.com/pt/nodejs/nodejs-fs.html)

   5. Módulos úteis.
      1. [Módulo de path do Node.js](http://www.w3big.com/pt/nodejs/nodejs-path-module.html).
      2. .

6. **Como usar o módulo express do nodejs**

   1. Módulo Express
      1. [Vídeo aula sobre express](https://www.youtube.com/watch?v=UMI7kFwmAHo&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=7)
      2. [Manual express](http://expressjs.com/en/5x/api.html)
      3. [Curso de Node.js - Introdução ao Express #06](https://www.youtube.com/watch?v=pohvlFd0byI&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=6)
      4. [Curso de Node.js - Rotas #07](https://www.youtube.com/watch?v=UMI7kFwmAHo&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=7&t=4s)
      5. [Curso de Node.js - Parâmetros #08](https://www.youtube.com/watch?v=G9b-Zi0rg3o&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=8&t=5s)
      6. [Curso de Node.js - Nodemon #09](https://www.youtube.com/watch?v=u3MrPxq_RyA&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=9)
      7. [Curso de Node.js - Exibindo HTML #10](https://www.youtube.com/watch?v=UkwLcuzJRDQ&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=10).
         1. [Arquivo usado no exemplo da função sendFile()](./test_express.html)
      8. [Curso de Node.js - Instalando o Mysql #11](https://www.youtube.com/watch?v=HmmYkLyVy-c&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=11)
         1. [Tudo que estudei sobre o Mariadb](/infraestrutura/linux/banco_de_dados/mariadb/index.html).
      9. Exemplo de uso Curso de Node.js

            ```javascript
            /**
             * Exemplo de uso Curso de Node.js - Exibindo HTML #10](https://www.youtube.com/watch?v=UkwLcuzJRDQ&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=10)  do módulo express do nodejs
            * Neste exemplo é mostrado o método express().get
            * REFERÊNCIAS:
            *    [Manual express](http://expressjs.com/en/5x/api.html)
            *    [Curso de Node.js - Rotas #07 ](https://www.youtube.com/watch?v=UMI7kFwmAHo&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=7&t=4s) 
            *       Método express().get() 
            *       Método express().send()
            *    [Curso de Node.js - Exibindo HTML #10](https://www.youtube.com/watch?v=UkwLcuzJRDQ&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=10) 
            *       Variável de ambiente _dirname (Retorna a pasta do workspace )
            *       Método express().sendFile()
            * 
            * NOTAS:
            *    O pacote express deve ser instalado na pasta em que o programa será executado.
            *    $ npm install express   
            */
                
                /**Exemplo uso do módulo express
                 * 
                */
                const express = require("express");
                const app = express();

                /**Exemplo de rota da pasta raiz.
                 *  Chamada a este método:http://localhost:8080
                */    
                app.get("/",
                    function (req, res) {
                        res.send("Seja bem-vindo ao meu app!");
                    }
                );

                /**Exemplo de rota sem parâmetros
                 *  Chamada a este método:http://localhost:8080/sobre
                */
                app.get("/sobre",
                    function (req, res) {
                        res.send("Este é um exemplo de uso do módulo express do nodejs!");
                    }
                );

                /**Exemplo de rotas com parâmetros enviados pelo usuário.
                 * Chamada a este método: http://localhost:8080/ola/Paulo/programador
                */
                app.get("/ola/:nome/:profissao",
                    function (req, res) {
                        
                        var resposta =
                            '<ol>' +
                                '<li>' +
                                    "Olá " + req.params.nome + ", tudo bem com você?"+
                                '</li>' +
                                '<li>' +
                                    "Sua profissão é: " + req.params.profissao + " ? "
                                '</li>' +
                            '</ol>'
                        res.send(resposta);
                    }
                );


                /**
                 * Exemplo de uso da variável de ambiente __dirname e do método express().sendFile(). 
                */
                app.get("/blog.pssp.app.br/exemplos/test_express",
                    function (req, res) {
                        //res.send(__dirname)
                        res.sendFile(__dirname+"/test_express.html");
                    }
                );

                // main - obs: O app.listen(port) deve ser a última linha do programa principal.
                app.listen(8080,
                    function () {
                        console.log('Servidor rodando na url http://localhost:8080');
                        console.log('Pasta raiz:' + __dirname )            
                    }
                );


            ```

7. **[Exemplo de acesso a dados usando sequelize](https://sequelize.org/master/)**
   1. ???

## REFERÊNCIAS

   1. [Node.js HTTP Module](https://www.w3schools.com/nodejs/nodejs_http.asp)
   2. [how-to-create-a-web-server-in-node-js-with-the-http-module](https://www.digitalocean.com/community/tutorials/how-to-create-a-web-server-in-node-js-with-the-http-module)
   3. [nodejs_modules.asp](https://www.w3schools.com/nodejs/nodejs_modules.asp)
   4. .

## HISTÓRICO

- [x] Escrever objetivos
- [x] Escrever os exemplos de uso.
  - [x] Servidor web para imprimir alo mundo.
  - [x] Como criar e usar módulos em nodejs.
  - [x] Como usar o módulo express do nodejs
- [x] Estudar a opção que permite alterar o programa nodejs sem tira-lo do ar.
  - O programa nodemon reinicia o nodejs toda vês que se grava o arquivo caso o mesmo foi alterado.
  - Não uso porque o debug não funciona.
