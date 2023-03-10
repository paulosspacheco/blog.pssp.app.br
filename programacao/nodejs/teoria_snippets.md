# <span id="topo"><span>Teoria snippets do editor vscode <a href="teoria_snippets.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="teoria_snippets.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [benefícios.](#id_beneficios)

   2. [**Descrição.**](#id_Descricao)

   3. [**Exemplos.**](#id_exemplos)

   4. [**Referências.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. Trechos de código ([**snippets**](https://code.visualstudio.com/docs/editor/userdefinedsnippets)) são modelos que facilitam a inserção de padrões de código repetidos, como loops ou instruções condicionais.
         No Visual Studio Code, **snippets** aparecem no **IntelliSense (Ctrl + Space)** misturados com outras sugestões, bem como em um seletor de snippet dedicado ( **Insert Snippet** na **Paleta de Comandos = Crtl+ Shift +P**).  
         Caso queira que o conteúdo do campo body seja inserido após teclar no tab é necessário habilitar no campo **"editor.tabCompletion": "on"** da opção **/File/Preferences/Settings**.  
         O uso é simples, ao **digitar uma palavra** no editor, a mesma é localizada no campo **prefix** do arquivo de **snippets** e após pressionar **Tab** o conteúdo do campo **body** do arquivo de snippets é inserido na posição do cursor.

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Editor vsCode.
         2. Extensões do editor vscode:
            1. [JavaScript (ES6) code snippets](https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets).
               1. Esta extensão do vscode  suporta as linguagens:
                   1. JavaScript (.js)
                   2. TypeScript (.ts)
                   3. [JavaScript React (.jsx)](https://www.typescriptlang.org/docs/handbook/jsx.html)
                   4. [TypeScript React (.tsx)](https://www.agatetepe.com.br/typescript-e-react-usando-create-react-app-um-guia-passo-a-passo-para-configurar-seu-primeiro-aplicativo/#:~:text=tsx%20.,o%20JSX%20diretamente%20no%20JavaScript.)
                   5. [Html (.html)](https://developer.mozilla.org/pt-BR/docs/Web/HTML)
                   6. [Vue (.vue)](https://vuejs.org/)
            2. ...
         3. ...

         4. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Os snippets permitem que o programador seja mais produtivo nas seguintes situação:
            1. Códigos repetitivos podem ser replicado com apenas duas ou três letras + a tecla tab;
            2. Memorização de comandos das linguagens para que o programador não tenha que gravar todas as opções de uma linguagem em sua memória.
            3. Padronização de modelos de código onde um arquivo inteiro pode ser inserido com apenas 2 a 4 letras.

         2. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_Descricao></span>**Descrição**
      1. A padronização de código através de snippets é possível através de extensões já programadas tais como:
         1. [**JavaScript (ES6) code snippets**](https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets) paras as linguagens javascript, typescript e html;
         2. [Angular Snippets (Version 11)](https://marketplace.visualstudio.com/items?itemName=johnpapa.Angular2) para é código pre-programados para ser usados com o framework Angular;
         3. [Linguagem c/c++](https://marketplace.visualstudio.com/items?itemName=hars.CppSnippets)

      2. É possível também criar snippets padronizados e sava-los na pasta **~/.config/Code/User/snippets/**.
      3. Os arquivos de snippets tem extensão **.json** e possuem o seguinte formato:
         1. Código json:

            ```json
            
               {
                  " incluir script ./js": // Nome reduzido do snippets.
                   {
                     "prefix": "script", //Chave a ser pesquisada para localizar o snippets quando tiver editando o arquivo.
                     "body": // Entre as tags [] deve ter o código a ser inserido na posição do cursor.
                     [ 
                        "<script type= 'application/x-javascript' src= '$1.js' ></script>",
                        "$2"
                        
                     ],
                     "description": "Descrição detalhada do snippets"
                  }
                  , // Separa outra chave com novo código

                  "incluir arquivo ./css": //Nome reduzido do snippets
                  {
                     "prefix": "css", //Chave a ser pesquisada para localizar o snippets quando tiver editando o arquivo.
                     "body": [ //Entre as tags [] deve ter o código a ser inserido na posição do cursor.
                        
                        "<link type='text/css' href='../../css/$1.css' rel='stylesheet' />"
                        "$2"
                        
                     ],
                     "description": "Descrição detalhada do snippets"
                  },
                  {//....
                  },
                  {//....},                
               }          

            ```

      4. A forma mais fácil de editar um código snippets é usar o site [snippet generator](https://snippet-generator.app/?description=&tabtrigger=&snippet=&mode=vscode) para inserir no lugar certo o nome reduzido, prefixo e o body.
         1. Nota: Depois do snippets pronto é só copiar do site e colocar no arquivo selecionado da pasta: **~/.config/Code/User/snippets/**.

      5. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_exemplos></span>**Exemplos.**
      1. Como adicionar dois snippets sendo um script para incluir um arquivo javascript (.js) e outro snippets para incluir um arquivo .css:
         1. Pressione as sequencia de teclas **CRTL + SHIFT + P** para acessar a Paleta de Comandos;
         2. Escreva a palavra **snippets** na linha de pesquisa;
         3. Selecione a opção: **Preferences: Configure User Snippets**;
         4. Se o arquivo de snippets não existe ainda, digite o nome do arquivo para a customização. Obs: Eu uso o nome da linguagem para  associar o arquivo a linguagem do snippets;
         5. Adicione o **código json** abaixo no arquivo de snippets que vocẽ criou na pasta **~/.config/Code/User/snippets/**
            1. Código json:

                  ```json
                  
                     {
                        " incluir script ./js": {
                           "prefix": "script",
                           "body": [
                              "<script type= 'application/x-javascript' src= '$1.js' ></script>",
                              "$2"
                              
                           ],
                           "description": "Script para incluir um código application/x-javascript na página html"
                        },
                        "incluir arquivo ./css": {
                           "prefix": "css",
                           "body": [
                              
                              "<link type='text/css' href='../../css/$1.css' rel='stylesheet' />"
                              "$2"
                              
                           ],
                           "description": "Incluir arquivo .css na posição do cursor"
                        }                
                     }          

                  ```

      2. ...

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [Vídeo aula sobre snippets](https://www.youtube.com/watch?v=Ye8rWIVnDKs)
      2. [Extensão vscode JavaScript (ES6) code snippets](https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets)
      3. [Extensão vscode Angular Snippets (Version 11)](https://marketplace.visualstudio.com/items?itemName=johnpapa.Angular2)
      4. [Site snippet generator](https://snippet-generator.app/?description=&tabtrigger=&snippet=&mode=vscode)
      5. [#](##)
      6. [#](##)
      7. [#](##)

      8. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 19/05/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo02.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [x] Escrever tópico Descrição
         - [x] Escrever tópico Exemplos
         - [x] Escrever tópico Referências
         - [x] Atualizar o histórico deste documento.
         - [x] Ler no dia seguinte este documento para checar os erros de português.
         - <text onclick="goBack()">[🔙]</text>

      2. ..

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
