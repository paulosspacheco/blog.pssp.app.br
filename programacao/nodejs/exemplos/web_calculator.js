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
                    '<body>'+
                
                        '<p> Soma de 1+2 = '+calculator.soma(1,2)+'</p>'+
                        '<p> Sum  de 1+2 = '+calculator.sum(1,2)+'</p>'+
                        '<p> subtrai  de 1-2 = '+calculator.subtrai(1,2)+'</p>'+
                        '<p> multiplica  de 1 * 2 = '+calculator.multiplica (1,2)+'</p>'+
                        '<p> dividi  de 1 / 2 = '+calculator.dividi (1,2)+'</p>')+

                    '</body>'+
                '</html>'    
        }
    );
    server.listen(port, 
                    hostname, 
                    () => {console.log(`Server running at http://${hostname}:${port}/`);}
    );
