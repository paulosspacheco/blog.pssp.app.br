var express = require('express');
var app = express();

// set the view engine to ejs
app.set('view engine', 'ejs');

// use res.render to load up an ejs view file

// Este código define um array chamado mascots e uma string chamada tagline
// index page
app.get('/', function(req, res) {
  var mascots = [
    { name: 'Sammy', organization: "DigitalOcean", birth_year: 2012},
    { name: 'Tux', organization: "Linux", birth_year: 1996},
    { name: 'Moby Dock', organization: "Docker", birth_year: 2013}
  ];
  var tagline = "No programming concept is complete without a cute animal mascot.";

  res.render('pages/index', {
    mascots: mascots,
    tagline: tagline
  });
});

// about page
app.get('/about', function(req, res) {
  res.render('pages/about');
});

app.listen(8080);
console.log('Server is listening on port 8080');


// ------------------------------------
// var express = require('express');
// var app = express();


// //A linha abaixo define o EJS como o mecanismo de visualização para o aplicativo Express
// app.set('view engine', 'ejs');

// // use res.render to load up an ejs view file

// // index page
// // O código abaixo envia uma exibição ao usuário usando res.render(). 
// // Observe que res.render() espera encontrar o arquivo pages/index.ejs na pasta /views do projeto,
// // onde .ejs e o nome da pasta views é opcional.
// app.get('/', function(req, res) {
//   res.render('pages/index');
// });

// // about page
// app.get('/about', function(req, res) {
//   res.render('pages/about');
// });


// //Este código define o aplicativo e escuta na porta 8080.
// app.listen(8080);
// console.log('Server is listening on port 8080');


