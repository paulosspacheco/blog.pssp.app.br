# <span id="topo"><span>O que é templates ejs<a href="o_que_e_ejs.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="o_que_e_ejs.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [benefícios.](#id_beneficios)

   2. [**Descrição.**](#id_Descricao)

   3. [**Exemplos.**](#id_exemplos)

   4. [**Conteúdo01**](#id_instalar)

   5. [**Referências.**](#id_referencias)

   6. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O projeto ejs (Embedded JavaScript templates) é usado para criar página html estática a partir de um modelo de extensão .ejs.
         2. Os modelos recebem varáveis para serem inseridas dentro das tags.
         3. [Veja mais...](https://www.digitalocean.com/community/tutorials/how-to-use-ejs-to-template-your-node-application)

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Nodejs
         2. javascript

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Simplificar a construção de páginas html.

         2. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_Descricao></span>**Descrição**
      1. Tags do modelo:
         1. **<%** Tag 'Scriptlet', para fluxo de controle, sem saída
         2. **<%_** Tag Scriptlet 'Whitespace Slurping', remove todos os espaços em branco antes dela
         3. **<%=** Exibe o valor no modelo (HTML com escape)
         4. **<%-** Exibe o valor sem escape no modelo
         5. **<%#** Tag de comentário, sem execução, sem saída
         6. **<%%** Produz um literal **'<%'**
         7. **%>**  Tag de finalização simples
         8. **-%>** Tag do modo de corte ('nova linha slurp'), corta após a nova linha
         9. **_%>** Tag de finalização 'Whitespace Slurping', remove todos os espaços em branco após ela.

      2. Include do modelo
         1. As inclusões são relativas ao modelo com a **tag include**. (Isso requer a opção 'nome do arquivo'.) Por exemplo, se você tiver **"./views/users.ejs"** e **"./views/user/show.ejs"**, você usaria **<%- include('user/show'); %>**.
         2. Você provavelmente vai querer usar a tag de saída bruta **( <%-)** com sua inclusão para evitar o escape duplo da saída HTML.
            1. Código ejs

               ```ejs
                  <ul>
                     <% users.forEach(function(user){ %>
                        <%- include('user/show', {user: user}); %>
                     <% }); %>
                  </ul>
               ```

            2. .
      3. O EJS é fornecido com uma interface de linha de comando (CLI) com recursos completos. As opções são semelhantes às usadas no código JavaScript:
         1. **cache** As funções compiladas são armazenadas em cache, requer filename
         2. **-o / --output-file** FILE Grave a saída renderizada em FILE em vez de stdout.
         3. **-f / --data-file** FILE Deve ser formatado em JSON. Use a entrada analisada de FILE como dados para renderização.
         4. **-i / --data-input** STRING Deve ser formatado em JSON e codificado por URI. Use a entrada analisada de STRING como dados para renderização.
         5. **-m / --delimiter** CHARACTER Use CHARACTER com colchetes angulares para abrir / fechar (o padrão é%).
         6. **-p / --open-delimiter** CHARACTER Use CHARACTER em vez do colchete angular esquerdo para abrir.
         7. **-c / --close-delimiter** CHARACTER Use CHARACTER em vez de colchete em ângulo reto para fechar.
         8. **-s / --strict** Quando definido como `true`, a função gerada está em modo estrito
         9. **-n / --no-with** Use o objeto 'locals' para vars ao invés de usar `with` (implica --strict).
         10. **-l / --locals-name** Nome a ser usado para o objeto que armazena variáveis ​​locais quando não estiver usando `with`.
         11. **-w / --rm-whitespace** Remova todos os espaços em branco seguros para remover, incluindo espaços em branco à esquerda e à direita.
         12. **-d / --debug** Saída gerada do corpo da função
         13. **-h / --help** Exibir esta mensagem de ajuda.
         14. **-V/v / --version** Mostra a versão EJS.

         15. Exemplo de execução do ejs no prompt de comandos:

            ```sh

               ejs -p [ -c ] ./template_file.ejs -o ./output.html
               ejs ./test/fixtures/user.ejs name=Lerxst
               ejs -n -l _ ./some_template.ejs -f ./data_file.json            

            ```

      4. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_exemplos></span>**Exemplos.**
      1. item 01.
      2. item 02.

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [ejs](https://ejs.co/)
      2. [Manual ejs](https://ejs.co/#install)
      3. [How To Use EJS to Template Your Node Application](https://www.digitalocean.com/community/tutorials/how-to-use-ejs-to-template-your-node-application)
      4. [Gerando HTML estáticos a partir de templates – EJS](https://www.youtube.com/watch?v=l09qRMEq_7U)
      5. [EJS Syntax Reference](https://github.com/mde/ejs/blob/main/docs/syntax.md)
      6. [Modelos de JavaScript incorporados versão tj 1.0](https://github.com/tj/ejs)
      7. [ejs-loader para webpack](https://github.com/difelice/ejs-loader)
      8. [Modelos de JavaScript incorporados versão mde 2.0](https://github.com/mde/ejs)
      9. [https://www.youtube.com/watch?v=1rFbqoMGSSA](Curso de NodeJS - Renderizando EJS/HTML em um projeto Nodejs - #02)
      10. [#](##)
      11. [#](##)
      12. [#](##)

      13. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 08/06/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo02.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [ ] Escrever tópico Referências

         - <text onclick="goBack()">[🔙]</text>

      2. 08/06/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Escrever tópico Descrição
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Conteúdo 01
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
