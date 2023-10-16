const fs = require('fs');
fs.readdir('/home/paulosspacheco/blog.pssp.app.br', (err, files) => {
  if (err) {
    console.error(err);
    return;
  }
  console.log(files);
});