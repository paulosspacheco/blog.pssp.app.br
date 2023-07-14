var express = require('express');
var app = express();


//A linha abaixo define o EJS como o mecanismo de visualização para o aplicativo Express
app.set('view engine', 'ejs');

// use res.render to load up an ejs view file

// index page
// O código abaixo envia uma exibição ao usuário usando res.render(). 
// Observe que res.render() espera encontrar o arquivo pages/index.ejs na pasta views,
// onde .ejs e o nome da pasta views é opcional.
// Observe que a pasta view deve ser criado com o comando: mkdir views no prompt do linux.
app.get('/', function(req, res) {
  res.render('pages/index');
});

// about page
app.get('/about', function(req, res) {
  res.render('pages/about');
});


//Este código define o aplicativo e escuta na porta 8080.
app.listen(8080);
console.log('Server is listening on port 8080');