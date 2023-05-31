/**
 * Exemplo de uso do módulo express do nodejs
 * Neste exemplo é mostrado o método express().get
 * REFERÊNCIAS:
 *    [Manual express](http://expressjs.com/en/5x/api.html)
 *    [Vídeo do Victor Lima - aula 07 ](https://www.youtube.com/watch?v=UMI7kFwmAHo&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=7) 
 *       Método express().get() 
 *       Método express().send()
 *    [Vídeo do Victor Lima - aula 10 ](https://www.youtube.com/watch?v=UkwLcuzJRDQ&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=10) 
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
            res.send("Método: app.get('/',function(req,res){}))");
        }
    );

    /**Exemplo de rota sem parâmetros
     *  Chamada a este método:http://localhost:8080/sobre
     */
    app.get("/sobre",
        function (req, res) {
            res.send("Método: app.get('/sobre',function(req,res){}))");
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
