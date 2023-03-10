/**
 * Exemplo da execução do modulo soma para ser visualizado no browser
 * Data: 29/01/2021
 * Módulo: web_calcule_soma.js
 */

var soma = require('./soma');
const http = require('http');
const hostname = '127.0.0.1';

const port = 8080;
const server = http.createServer(
    (req, res) => {
                    res.statusCode = 200;
                    res.setHeader('Content-Type', 'text/plain');
                    res.end('Soma de 1+2 = '+soma(1,2));
                    }
);
server.listen(port, 
                hostname, 
                () => {console.log(`Server running at http://${hostname}:${port}/`);}
);

