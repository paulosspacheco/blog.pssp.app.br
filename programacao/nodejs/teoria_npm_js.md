#### **Teoria sobre o Framework npm** <a href="teoria_npm_js.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. **INDEX**
   1. Objetivo do pacote npm
   2. Arquivo package.json do Node.js
   3. Como compartilhar seu software no repositório npm
   4. Referências
   5. Histórico

2. **CONTEÚDO**

   1. **Objetivo do pacote npm**
      1. O nome npm (Node Package Manager) deriva de quando o npm foi criado pela primeira vez como um gerenciador de pacotes para Node.js.
      2. Todos os pacotes npm são definidos em arquivos chamados package.json.
      3. O conteúdo de package.json deve ser escrito em JSON .
      4. Pelo menos dois campos devem estar presentes no arquivo de definição: nome e versão .

   2. **Arquivo package.json do Node.js**
      1. O nome npm (Node Package Manager) deriva de quando o npm foi criado pela primeira vez como um gerenciador de pacotes para Node.js.
         1. Todos os pacotes npm são definidos em arquivos chamados package.json .
         2. O conteúdo de package.json deve ser escrito em JSON .
         3. Pelo menos dois campos devem estar presentes no arquivo de definição: nome e versão .

            ```json
               {
                  "name" : "Nome do pacote",
                  "version" : "1.2.3",
                  "description" : "Do que se trata o pacote",
                  "main" : "main.js",
                  "keywords" : ["nome do pacote", "nodejs", "npm"],
                  "author" : "Paulo Pacheco",
                  "licence" : "ISC" // Internet Systems Consortium
               }
            ```

      2. O arquivo _package.json_ é um elemento-chave em muitas aplicações do ecossistema _Node.js_ e ele é criado com o comando _npm init_:
           1. O comando _npm init_ fará as perguntas a seguir:
              1. name? - Nome do pacote
              2. version? - Versão do pacote = x.y.z onde:
                 1. x = versão principal e só muda se houver mudanças radicais ou a versão atual é incompatível com as anteriores.
                 2. y = Mudanças pequenas que não quebram a compatibilidade com as versões anteriores.
                 3. z = Não quebra compatibilidade e muda quando um bug foi corrigido.
              3. Description? - Do que se trata o pacote
              4. Entry point? - Onde a primeira instrução será executada. Aqui vamos deixar como src/index.js, mais para frente vamos criar essa pasta e esse arquivo.
              5. Test command? - Tem relação com testes, vamos deixar vazio por hora
              6. Github repository? - Repositório do github
              7. Keywords? - Palavras chaves que vão facilitar na hora de achar nossa biblioteca
              8. License? - Licença da biblioteca

           2. Gerenciando Dependências
              1. O npm pode gerenciar dependências.
              2. O npm pode (em uma linha de comando) instalar todas as dependências de um projeto.
              3. Dependências também são definidas em package.json .

   3. **Como compartilhar seu software no repositório npm**
      1. Se desejar compartilhar seu próprio software no registro npm , você pode fazer login em: <https://www.npmjs.com>

   4. **REFERÊNCIAS**

      1. [O que é npm?](https://www.w3schools.com/whatis/whatis_npm.asp)
      2. [Criando e publicando uma biblioteca Javascript no NPM](https://www.alura.com.br/artigos/criando-e-publicando-uma-biblioteca-javascript-no-npm?gclid=CjwKCAiAsOmABhAwEiwAEBR0ZnMRHSUHOtuv2onQvSaVFvRxeiH2NjgbecqxgdbREcNmJEsyzjs0kRoCQWMQAvD_BwE)
      3. [O guia completo do package.json do Node.js](https://www.luiztools.com.br/post/o-guia-completo-do-package-json-do-node-js/)
      4. .

   5. **HISTÓRICO**

      1. 03/02/2021
         - [X] Criar este documento.
         - [x] Escrever objetivos do npm
         - [x] Comecei a escrever o guia completo do package.json do Node.js

      2. 04/02/2021 <!--TODO: em: 04/02/2021-->
         - [ ] Reorganizar o layout deste documento para que tenha INDEX E CONTEÚDO.
         - [ ] Escrever documento: guia completo do package.json do Node.js
         - [ ] Escrever exemplo de como instalar npm
