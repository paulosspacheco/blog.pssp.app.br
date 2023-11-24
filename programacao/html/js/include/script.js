document.addEventListener('DOMContentLoaded', function() {
    // Função para carregar o conteúdo HTML de um arquivo externo
    function includeHTML() {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          // Insere o conteúdo do arquivo HTML na div com id 'myTopnav'
          document.getElementById('myTopnav').innerHTML = this.responseText;
        }
      };
      // Especifique o caminho do arquivo HTML que contém o menu
      xhttp.open('GET', 'menu.html', true);
      xhttp.send();
    }
  
    // Chame a função para incluir o conteúdo HTML
    includeHTML();
  });