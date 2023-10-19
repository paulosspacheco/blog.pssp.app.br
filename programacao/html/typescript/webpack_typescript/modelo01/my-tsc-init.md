<span id="topo"><span>

# Passo a passo para criar um novo projeto typescript  <a href="readme.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [benefícios.](#id_beneficios)

   2. [**Passo a passo para criar um novo projeto typescript.**](#id_passo_a_passo)
      1. [Passo 01 - Criar a função rename()](#id_passo01)
      2. [Passo 02 - Criar função ifExistProject(){}](#id_passo02)
      3. [Passo 03 - Criar as pasta do projeto;](#id_passo03)
      4. [Passo 04 - Criar workspace para o projeto do vscode na pasta raiz do projeto;](#id_passo04)
      5. [Passo 05 - Adicionar o código **.html** no arquivo ./src/html/index.html;](#id_passo05);
      6. [Passo 06 - Adicionar o código **.css** no arquivo ./src/css/defaulttheme.css;](#id_passo06);
      7. [Passo 07 - Adicionar o código **.ts** no arquivo ./src/ts/index.ts;](#id_passo07)
      8. [Passo 08 - Executar o programa **tsc-init** para iniciar tudo que for preciso para o projeto;](#id_passo08)
      9. [Passo 09 - Instalar pacotes.](#id_passo09)
      10. [Passo 10 - Customizar o comportamento do webpack no arquivo **webpack-config.js**;](#id_passo10)
      11. [Passo11 - Customizar arquivo package.json;](#id_passo11)
      12. [Passo12 - Customizar arquivo tsconfig.json;](#id_passo12)
      13. [Versão completa (my-tsc-init.sh) dos 12 passos para iniciar um projeto typeScript](./my-tsc-init-ver-0.2.0.md).

   3. [**Referências.**](#id_referencias)

   4. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. Este documento descreve como configurar um novo projeto typescript com tudo que é preciso.

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Os programs nodejs, typescript, tsc-init devem estar instalado globalmente. [Veja como...](../../instalar.html)

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Ganhar temos ao iniciar um novo projeto pois os documentos oficiais não foram claros quando iniciei. [Veja por si mesmo...](https://www.typescriptlang.org/docs/)

         2. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_passo_a_passo></span>**Passo a passo para criar um novo projeto typescript**
      1. <scan id="id_passo01"></scan>Passo 01 - Criar a função rename()
         1. Código shellscript

            ```sh

               # Função para renomeá arquivo e apagar o arquivo anterior se existir
               rename(){
               #Parâmetros
               # Chamada: rename param1 param2
               fileName="$1";
               fileNameOld="$2";     

               # begin
                  if [ -f $fileNameOld ]; then
                     # Se $fileNameOld já existe então apaga
               #        echo O arquivo $fileNameOld foi criado anteriormente!. 
               #        echo Tecle ENTER para apaga-lo.
               #        read input
                     rm $fileNameOld
                  fi

                  if [ -f $filename ]; then # Se $filename existe renomeia para $fileNameOld
               #        echo O arquivo $fileName foi criado anteriormente!. 
               #        echo Tecle ENTER para renomear para $fileNameOld.
               #        read input
                     mv  $fileName $fileNameOld   
                  fi
               # end    
               }

            ```

         2. <text onclick="goBack()">[🔙]</text>
      2. <scan id="id_passo02"> </scan>Passo 02 - Cria a função ifExistProject():
         1. Código shellscript

            ```sh
               # Passo 02 - Retorna o nome do projeto ou aborta o script
               ifExistProject(){ 

               # Se o parâmetro 01 não existe então fazer nome do project igual ./myproject  
               if [ -z $project ]; # -z indica que a string $pasta existe e é vazia.
               then     
                  # echo  -z $pasta retorno true
                  # read input
                  project="./myproject"
               else  
                  # echo  -z $pasta retorno false  
                  # read input
                  project="./$project"
               fi   

               if [ -d $project ]; then # Se $pasta já existe então aborta execução.
                     #echo O project $project foi criado anteriormente!. Tecle ENTER para sair.
                     #read input
                     exit EEXIST #  aborta o script  
                     
               fi

               }

            ```

         2. <text onclick="goBack()">[🔙]</text>

      3. <scan id="id_passo03"> </scan>Passo 03 - Criar as pasta do projeto:
         1. Código shellscript

            ```sh

               # Passo 03 - Criar as pasta do projeto;
               createProject(){

               ifExistProject # Se o projeto já existe essa função aborta
               
               # Cria a pasta do project passada no parâmetro 01
               mkdir $project

               # Cria as pasta para os códigos fontes do project
               mkdir ./"$project"/src      # Pasta raiz do código fonte 
               mkdir ./"$project"/src/html # Pasta html de entrada de webpack
               mkdir ./"$project"/src/css  # Pasta css de entrada de webpack
               mkdir ./"$project"/src/js   # Pasta de saide js de tsc 
               mkdir ./"$project"/src/ts   # Pasta de entrada ts de tsc
               mkdir ./"$project"/dist     # Pasta destino do webpack para ser publicada na web.

               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"
               createProject               

            ```

         2. <text onclick="goBack()">[🔙]</text>

      4. <scan id="id_passo04"> </scan>Passo 04 - Criar workspace para o projeto do vscode na pasta raiz do projeto.
         1. Código ShellScript

            ```sh

               # Passo 04 - Criar workspace para o projeto do vscode na pasta raiz do projeto;
               createWorkspace(){

               cat >"./"$project"/workspace.code-workspace"<<EOT
               {
                  "folders": [
                     {
                           "path": "."
                     }   
                  ]
               }
               EOT

               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"
               createWorkspace               

            ```

         2. <text onclick="goBack()">[🔙]</text>

      5. <scan id="id_passo05"> </scan>Passo 05 - Adicionar o código [**.html**](https://developer.mozilla.org/en-US/docs/Web/HTML) no arquivo ./src/html/index.html.
         1. Código ShellScript

            ```sh

               # Passo 05 - Adicionar o código .html no arquivo ./src/html/index.html;
               createFileIndexHtml(){
               
               # Criar arquivo inicial index.html
               cat >"./"$project"/src/html/index.html"<<EOT

                  <!DOCTYPE html>
                        <html dir="ltr" lang="pt-br">

                           <head>
                              <meta http-equiv="content-type" content="text/html; charset=utf-8" />

                              <meta name="viewport" content="width=device-width, initial-scale=1.0" />

                              <title>Modelo de project typescript</title>

                              <meta name="createDate" content="28/05/2021" />
                              <meta name="createDateUpdate" content="25/05/2021" />
                              <meta name="description" content="Todos project typescript deve seguir essa sequência ao iniciar..." />
                              <meta name="keywords" content="typescript,webpack" />

                              <link type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
                                    rel="stylesheet" />

                           </head>

                           <bodY>
                              <p>Alo mundo</p>
                            </body>

                        </html>

                  EOT
               
               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"
               createFileIndexHtml               
               
            ```

         2. <text onclick="goBack()">[🔙]</text>

      6. <scan id="id_passo06"></scan> Passo 06 - Adicionar o código **.css** no arquivo ./src/css/defaulttheme.css;
         1. Código ShellScript

            ```sh

               # Passo 06 - Adicionar o código .css no arquivo ./src/css/defaulttheme.css;;
               createFiledefaultThemeCss() {

               cat >"./"$project"/src/css/defaulttheme.css"<<EOT
                  html {
                     scroll-behavior: smooth;
                     /* scroll lento*/
                  }

                  body {
                     margin: 0;
                     font-family: Arial
                  }

               EOT
               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"            
               createFiledefaultThemeCss

            ```

         2. <text onclick="goBack()">[🔙]</text>

      7. <scan id="id_passo07"> </scan>Passo 07 - Adicionar o código [**.ts**](https://www.typescriptlang.org/docs/) no arquivo ./src/ts/index.ts
          1. Código ShellScript

               ```sh

                  # Passo 05 - Adicionar o código .ts no arquivo ./src/ts/index.ts;
                  createIndexTs(){

                     cat >"./"$project"/src/ts/index.ts"<<EOT
                     /**
                        * Programa: Classe Print
                        * Objetivo: Usada para imprimir um texto o console.
                        * Criado em: 16/06/2021
                        * Atualizado em: 16/06/2021
                        */
                     class Print{
                        /** Imprime um texto no console
                        * @param s :String
                        */
                        public print(s:string){
                           console.log(s);    
                        }
                     }   

                     /**
                        * Cria objeto p;
                        */
                     let p = new Print();

                     /**
                        * Imprime no console o texto : Alo Mundo
                        */
                     p.print('Alo mundo');

                     EOT

                  }

                  # PROGRAMA PRINCIPAL
                  # $1 é passado na execução de my-tsc-init.sh

                  project="$1"               
                  createIndexTs

               ```

          2. <text onclick="goBack()">[🔙]</text>

      8. <scan id="id_passo08"></scan>Passo 08 - Executar o programa [**tsc-init**](https://www.npmjs.com/package/tsc-init) para iniciar tudo que for preciso para o projeto;
         1. Código shellscript

            ```sh
               
               # Passo 06 - Executar o programa tsc-init para iniciar tudo que for preciso para o projeto;
               execTscInit(){
               cd $project
               tsc-init 
               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"            
               execTscInit

            ```

         2. <text onclick="goBack()">[🔙]</text>

      9. <scan id="id_passo09"></scan>Passo09 - Instalar pacotes.
         1. Código shellscript

            ```sh
               # Passo 09 - Instalar pacotes.
               installPackages(){

                  # Instala plugin a ser usado por alterWebpackConfig()                  
                  npm install npm install --save-dev html-webpack-plugin
                  # instalar plugin clean-webpack-plugin para deletar a pasta dist toda vez que que o comando npm run build for executado
                  npm --save-dev install clean-webpack-plugin

                  
               }

               # PROGRAMA PRINCIPAL
               # $1 é passado na execução de my-tsc-init.sh

               project="$1"            
               execTscInit

            ```

         2. <text onclick="goBack()">[🔙]</text>

      10. <scan id="id_passo10"></scan> Passo 10 - Customizar o comportamento do webpack no arquivo **webpack-config.js**.
          1. Código shellscript

             ```sh

                # Passo10 - Customizar o comportamento do  webpack no arquivo webpack-config.js;
                alterWebpackConfig(){

                  echo "... ";
                  echo "Adiciona const path = require('path') em webpack.config.js;"
                  echo "Adiciona a declaração \"const HtmlWebpackPlugin = require('html-webpack-plugin')\" em webpack.config.js"

                  subStrOrigem='module.exports = {'
                  subStrDestino=" const path = require('path');\n const HtmlWebpackPlugin = require('html-webpack-plugin'); \n\n module.exports = {"
                                 
                  fileNameOld="./webpack.config.js.ant"
                  fileName="./webpack.config.js"

                  rename "$fileName" "$fileNameOld"

                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 
                        
                  echo ...
                  
                  echo Adiciona a propriedade "HtmlWebpackPlugin" em module.exports = { webpack.config.js

                  subStrOrigem='module.exports = {'
                  subStrDestino="module.exports = \{plugins:\[new HtmlWebpackPlugin\(\{filename:'index.html',template:'.\/src\/html\/index.html',inject:'body'\}\)\],"
                                 
                  fileNameOld="./webpack.config.js.ant"
                  fileName="./webpack.config.js"

                  rename "$fileName" "$fileNameOld"

                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 

                  echo ...

                  echo ...
                  echo Alterar o arquivo webpack.config.js  

                  # Atualiza o arquivo de entrada de webpack.config.js
                  subStrOrigem="entry: '.\/index.ts'"
                  subStrDestino="entry: '.\/src\/ts\/index.ts'"
                  fileNameOld="./webpack.config.js.ant"
                  fileName="./webpack.config.js"
                  rename "$fileName" "$fileNameOld"
                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName   
                }
                # PROGRAMA PRINCIPAL
                # $1 é passado na execução de my-tsc-init.sh

                project="$1"            
                alterWebpackConfig                 

             ```

          2. <text onclick="goBack()">[🔙]</text>

      11. <scan id="id_passo11"></scan> Passo 11 - Customizar arquivo package.json;
          1. Código shellscript

             ```sh
                # Passo11 - Customizar arquivo package.json;
                alterPackage(){
                  echo ...
               
                  echo Atualiza script "dev" do package.json
                  subStrOrigem="webpack-dev-server --inline --hot"
                  subStrDestino="webpack serve --mode development --env development --hot --port 3000"
                  fileNameOld="./package.json.ant"
                  fileName="./package.json"
                  rename "$fileName" "$fileNameOld"
                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 

                  echo ...
                  echo  Atualiza script "build" do package.json
                  subStrOrigem="webpack -p"
                  subStrDestino="webpack --mode='production'"
                  fileNameOld="./package.json.ant"
                  fileName="./package.json"
                  rename "$fileName" "$fileNameOld"
                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 
                }

                # PROGRAMA PRINCIPAL
                # $1 é passado na execução de my-tsc-init.sh

                project="$1"            
                alterPackage

             ```

          2. <text onclick="goBack()">[🔙]</text>

      12. <scan id="id_passo12"></scan> Passo 12 - Customizar arquivo tsconfig.json;
          1. Código shellscript

             ```sh
                # Passo 12 - Customizar arquivo tsconfig.json;
                alterTsconfig(){

                  echo ...
                        
                  echo Adiciona a propriedade "outDir" em "compilerOptions": {} do tsconfig.json

                  subStrOrigem='"compilerOptions": {'
                  subStrDestino='"compilerOptions": {"outDir": ".\/src\/js",'                
                                    
                  fileNameOld="./tsconfig.json.ant"
                  fileName="./tsconfig.json"

                  rename "$fileName" "$fileNameOld"

                  sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 

                  echo ...                
                }

                # PROGRAMA PRINCIPAL
                # $1 é passado na execução de my-tsc-init.sh

                project="$1"            
                alterTsconfig

             ```

          2. <text onclick="goBack()">[🔙]</text>
.
   3. <span id=id_referencias></span>**REFERÊNCIAS**
       1. [Documentação oficial typescript](https://www.typescriptlang.org/)
       2. O programa [tsc-init](https://www.npmjs.com/package/tsc-init) cria projeto typescript com tudo que é preciso para para o desenvolvimento.
       3. [O que é shellscript](../../../../shellscript/o_que_e_shellscript.html)
       4. [webpack x typescript](https://webpack.js.org/guides/typescript/)
       5. [#](##)
       6. [#](##)

       7. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_historico"><span>**HISTÓRICO**

       1. 28/05/2021 <!--TODO: HISTÓRICO -->
            - [x] Criar este documento baseado no modelo02.md ;
            - [x] Escrever tópico Objetivos;
            - [x] Escrever tópico Pre-requisitos
            - [x] Escrever tópico Benefícios

            - <text onclick="goBack()">[🔙]</text>

       2. 08/06/2021 <!--TODO: HISTÓRICO -->
             - [x] Escrever tópico Passo a Passo
               - [x]  Passo 01 - Função para renomeá arquivo e apagar o arquivo anterior se existir
               - [x]  # Passo 02 - Retorna o nome do projeto ou aborta o script ifExistProject(){}
               - [x]  # Passo 03 - Criar as pasta do projeto;createProject(){}
               - [x]  # Passo 04 - Criar workspace para o projeto do vscode na pasta raiz do projeto;createWorkspace(){}
               - [x] # Passo 05 - Adicionar o código .html no arquivo ./src/html/index.html;createFileIndexHtml(){}
               - [x] # Passo 06 - Adicionar o código .css no arquivo ./src/css/defaulttheme.css;createFiledefaultThemeCss() {}
               - [x] # Passo 07 - Adicionar o código .ts no arquivo ./src/ts/index.ts;createIndexTs(){}
               - [x]  Passo 08 - Executar o programa tsc-init para iniciar tudo que for preciso para o projeto;execTscInit(){}

               - [x]  # Passo 09 - Instalar pacotes.installPackages(){}
               - [x]  # Passo10 - Customizar o comportamento do webpack no arquivo webpack-config.js;alterWebpackConfig(){}
               - [x]  # Passo11 - Customizar arquivo package.json;alterPackage(){}
               - [x]  # Passo 12 - Customizar arquivo tsconfig.json;alterTsconfig(){}

             - [x] Escrever tópico Referências
             - [x] Atualizar o histórico deste documento.

             - <text onclick="goBack()">[🔙]</text>

       3. 15/06/2021 <!--FIXME: Falta fazer os item abaixo: -->
          - [ ] Testar este documento depois após uma semana de concluído.

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
