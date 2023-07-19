// O exemplo node-js-fs-readdir-recursive-directory-search.js lista os arquivos da pasta 
// "/home/paulosspacheco/blog.pssp.app.br", porém era está listando todos os arquivos da pasta
// "/home/paulosspacheco/blog.pssp.app.br.git" não sei porque.

//https://stackoverflow.com/questions/5827612/node-js-fs-readdir-recursive-directory-search

// ***Um loop paralelo ficaria assim:***

// var fs = require('fs');
// var path = require('path');
// var walk = function(dir, done) {
//   var results = [];
//   fs.readdir(dir, function(err, list) {
//     if (err) return done(err);
//     var pending = list.length;
//     if (!pending) return done(null, results);
//     list.forEach(function(file) {
//       file = path.resolve(dir, file);
//       fs.stat(file, function(err, stat) {
//         if (stat && stat.isDirectory()) {
//           walk(file, function(err, res) {
//             results = results.concat(res);
//             if (!--pending) done(null, results);
//           });
//         } else {
//           results.push(file);
//           if (!--pending) done(null, results);
//         }
//       });
//     });
//   });
// };

// ***Um loop serial ficaria assim:***

var fs = require("fs");
var path = require("path");
var walk = function (dir, done) {
  var results = [];
  fs.readdir(dir, function (err, list) {
    if (err) return done(err);
    var i = 0;
    (function next() {
      var file = list[i++];
      if (!file) return done(null, results);
      file = path.resolve(dir, file);
      fs.stat(file, function (err, stat) {
        if (stat && stat.isDirectory()) {
          walk(file, function (err, res) {
            results = results.concat(res);
            next();
          });
        } else {
          results.push(file);
          next();
        }
      });
    })();
  });
};

//E para testá-lo em seu diretório pessoal (AVISO: a lista de resultados será
//enorme se você tiver muitas coisas em seu diretório pessoal):

// O Código abaixo pega a pasta corrente
// walk(process.env.HOME, function(err, results) {
//   if (err) throw err;
//   console.log(results);
// });

// A variável dir abaixo aponta para meu site.
var dir = "/home/paulosspacheco";
walk(dir, function (err, results) {
  if (err) throw err;
  console.log(results);
});
