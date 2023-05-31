/*JavaScript
No código HTML da barra de pesquisa, demos à entrada um id = ”barra de pesquisa” e na tecla de ativação 
chamamos a função “pesquisa_animal”. onkeyup chama a função sempre que uma tecla é liberada no teclado.

Primeiro, obtemos nossa entrada usando getElementById . Certifique-se de convertê-lo para minúsculas 
para evitar a diferenciação de maiúsculas e minúsculas durante a pesquisa. Uma série de documentos é 
armazenada em x. Ele contém todas as listas que possuem id = ”animais”. Depois disso, um loop é executado 
para verificar se o innerHTML de cada documento inclui a substring de entrada, caso contrário, a 
propriedade display é definida como 'none' para que fique invisível no front end.
*/

function search_animal() {
    let input = document.getElementById('searchbar').value
    input=input.toLowerCase();
    let x = document.getElementsByClassName('animals');
      
    for (i = 0; i < x.length; i++) { 
        if (!x[i].innerHTML.toLowerCase().includes(input)) {
            x[i].style.display="none";
        }
        else {
            x[i].style.display="list-item";                 
        }
    }
}