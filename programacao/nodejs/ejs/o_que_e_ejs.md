<!-- markdownlint-disable-next-line -->
# <span id="topo"><span>O que é templates ejs<a href="o_que_e_ejs.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. **INDEX**
   1. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [benefícios.](#id_beneficios)
   2. [**Descrição.**](#id_Descricao)
   3. [**Referências.**](#id_referencias)
   4. [**Histórico.**](#id_historico)

2. **CONTEÚDO**
   1. **Introdução**
      <!-- markdownlint-disable-next-line -->
      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O projeto ejs (Embedded JavaScript templates) é usado para criar página html estática a partir de um modelo de extensão _.ejs_.
         2. Os modelos _recebem varáveis_ para serem inseridas dentro das tags.
         3. [Veja mais...](https://www.digitalocean.com/community/tutorials/how-to-use-ejs-to-template-your-node-application)
         <!-- markdownlint-disable-next-line -->
         4. <text onclick="goBack()">[🔙]</text>
      <!-- markdownlint-disable-next-line -->
      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Nodejs
         2. javascript
         <!-- markdownlint-disable-next-line -->
         3. <text onclick="goBack()">[🔙]</text>
      <!-- markdownlint-disable-next-line -->
      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Simplificar a construção de páginas html através de modelos pre-fabricados.
         <!-- markdownlint-disable-next-line -->
         2. <text onclick="goBack()">[🔙]</text>

   <!-- markdownlint-disable-next-line -->
   2. <span id=id_Descricao></span>**Descrição**
      1. Tags do modelo:
         1. _<%_ Tag 'Scriptlet', para fluxo de controle, sem saída
         2. _<%__ Tag Scriptlet 'Whitespace Slurping', remove todos os espaços em branco antes dela
         3. _<%=_ Exibe o valor no modelo (HTML com escape)
         4. _<%-_ Exibe o valor sem escape no modelo
         5. _<%#_ Tag de comentário, sem execução, sem saída
         6. _<%%_ Produz um literal _'<%'_
         7. _%>_  Tag de finalização simples
         8. _-%>_ Tag do modo de corte ('nova linha slurp'), corta após a nova linha
         9. __%>_ Tag de finalização 'Whitespace Slurping', remove todos os espaços em branco após ela.

      2. **Include do modelo**
         1. As inclusões são relativas ao modelo com a _tag include_. (Isso requer a opção '_nome do arquivo_'). Por exemplo, se você tiver _"./views/users.ejs"_ e _"./views/user/show.ejs"_, você usaria _<%- include('user/show'); %>_.
         2. Você provavelmente vai querer usar a tag de saída bruta _( <%-)_ com sua inclusão para evitar o escape duplo da saída _HTML_.

            ```html
               <!-- Código ejs -->
               <ul>
                  <% users.forEach(function(user){ %>
                     <%- include('user/show', {user: user}); %>
                  <% }); %>
               </ul>
            ```

      3. O _EJS_ é fornecido com uma interface de linha de comando (_CLI_) com recursos completos. As opções são semelhantes às usadas no código _JavaScript_:
         1. _cache_ As funções compiladas são armazenadas em cache, requer filename
         2. _-o / --output-file_ FILE Grave a saída renderizada em FILE em vez de stdout.
         3. _-f / --data-file_ FILE Deve ser formatado em JSON. Use a entrada analisada de FILE como dados para renderização.
         4. _-i / --data-input_ STRING Deve ser formatado em JSON e codificado por URI. Use a entrada analisada de STRING como dados para renderização.
         5. _-m / --delimiter_ CHARACTER Use CHARACTER com colchetes angulares para abrir / fechar (o padrão é%).
         6. _-p / --open-delimiter_ CHARACTER Use CHARACTER em vez do colchete angular esquerdo para abrir.
         7. _-c / --close-delimiter_ CHARACTER Use CHARACTER em vez de colchete em ângulo reto para fechar.
         8. _-s / --strict_ Quando definido como `true`, a função gerada está em modo estrito
         9. _-n / --no-with_ Use o objeto 'locals' para vars ao invés de usar `with` (implica --strict).
         10. _-l / --locals-name_ Nome a ser usado para o objeto que armazena variáveis ​​locais quando não estiver usando `with`.
         11. _-w / --rm-whitespace_ Remova todos os espaços em branco seguros para remover, incluindo espaços em branco à esquerda e à direita.
         12. _-d / --debug_ Saída gerada do corpo da função
         13. _-h / --help_ Exibir esta mensagem de ajuda.
         14. _-V/v / --version_ Mostra a versão EJS.

         15. Exemplo de execução do _ejs_ no prompt de comandos:

            ```sh

               ejs -p [ -c ] ./template_file.ejs -o ./output.html
               ejs ./test/fixtures/user.ejs name=Lerxst
               ejs -n -l _ ./some_template.ejs -f ./data_file.json            

            ```
         <!-- markdownlint-disable-next-line -->
      4. <text onclick="goBack()">[🔙]</text>
         <!-- markdownlint-disable-next-line -->
      5. <text onclick="goBack()">[🔙]</text>

   <!-- markdownlint-disable-next-line -->
   3. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [ejs](https://ejs.co/)
      2. [Manual ejs](https://ejs.co/#install)
      3. [How To Use EJS to Template Your Node Application](https://www.digitalocean.com/community/tutorials/how-to-use-ejs-to-template-your-node-application)
      4. [Gerando HTML estáticos a partir de templates – EJS](https://www.youtube.com/watch?v=l09qRMEq_7U)
      5. [EJS Syntax Reference](https://github.com/mde/ejs/blob/main/docs/syntax.md)
      6. [Modelos de JavaScript incorporados versão tj 1.0](https://github.com/tj/ejs)
      7. [ejs-loader para webpack](https://github.com/difelice/ejs-loader)
      8. [Modelos de JavaScript incorporados versão mde 2.0](https://github.com/mde/ejs)
      9. [https://www.youtube.com/watch?v=1rFbqoMGSSA](Curso de NodeJS - Renderizando EJS/HTML em um projeto Nodejs - #02)
      <!-- markdownlint-disable-next-line -->
      10. <text onclick="goBack()">[🔙]</text>
   <!-- markdownlint-disable-next-line -->
   4. <span id="id_historico"><span>**HISTÓRICO**

      1. 08/06/2021 <!--DONE: HISTÓRICO -->
         - [x] ;

      2. 08/06/2021 <!--DONE: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo02.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [ ] Escrever tópico Referências
         <!-- markdownlint-disable-next-line -->
         - <text onclick="goBack()">[🔙]</text>

      3. 08/06/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Escrever tópico Descrição
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Conteúdo 01
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.
         <!-- markdownlint-disable-next-line -->
         - <text onclick="goBack()">[🔙]</text>

   [🔝🔝](#topo "Retorna ao topo")
   <!-- markdownlint-disable-next-line -->
   <script>    function goBack() {    window.history.back()}</script>

3. **REFERÊNCIAS**
   1. [ejs.co](https://ejs.co/#install)
