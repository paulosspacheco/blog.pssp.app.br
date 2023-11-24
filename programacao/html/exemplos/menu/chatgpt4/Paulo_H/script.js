// ### Arquivo JavaScript (`script.js`)

// javascript
// JavaScript para alternar a exibição do menu dropdown

document.addEventListener('DOMContentLoaded', function () {
    var dropdown = document.querySelector('.dropbtn');

    dropdown.addEventListener('click', function(event) {
        event.stopPropagation();
        this.nextElementSibling.classList.toggle('show');
    });
});

// Fechar o dropdown se clicar fora dele
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
}

/*
### Modificando o JavaScript

    Atualize o código JavaScript para lidar com cliques nos elementos `rootTree`, 
    alternando a visibilidade dos elementos `children` correspondentes.

javascript
*/
// Adicione isto ao seu arquivo JavaScript existente

document.addEventListener('DOMContentLoaded', function () {
    var rootTreeElements = document.querySelectorAll('.rootTree');

    rootTreeElements.forEach(function(elem) {
        elem.addEventListener('click', function() {
            var childrenElement = this.parentElement.querySelector('.children');
            if (childrenElement) {
                childrenElement.classList.toggle('show-children');
            }
        });
    });
});