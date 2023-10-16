# <span id="topo"><span>Teoria do empacotador de módulos javascript webpack <a href="teoria_webpack.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Descrição](#id_descricao)
      5. [Como usar webpack com a linguagem typescript](#id_webpack_typescript)
         1. Vídeos
            1. [Webpack & TypeScript](https://www.youtube.com/playlist?list=PL4cUxeGkcC9hOkGbwzgYFmaxB0WiduYJC);
            2. .
      6. [Vídeo Aula de como usar webpack com typescript](https://www.youtube.com/watch?v=ILnWJ8lQ9L4)

   2. **Instalação e configuração local**
      1. [Instalar a versão mais recente do webpack](#id_Instalar_webpack).
      2. [Instalar plugins html-webpack-plugin](#id_html_webpack_plugin)
      3. [Instalar a versão mais recente do webpack-cli](#id_webpack-cli).
         1. [Instalar webpack-cli init](#id_webpack_cli_init)
         2. [Instalar webpack-cli generators](#id_webpack-cli_generators)
         3. [Instalar nanoid](#id_nanoid).
      4. Configuração do webpack.
         1. [Configuração padrão](#id_configurar_webpack_padrao).
         2. [Configuração personalizada](#id_configurar_webpack_personalizada)

      5. [Instalar a versão mais recente do webpack-dev-server](#id_webpack-dev-server).
      6. .
      7. .

   3. [**Exemplos.**](https://github.com/ruanyf/webpack-demos)
      1. [Exemplo básico](#id_Exemplo_basico)
      2. [Exemplo de webpack com a linguagem javascript](#id_exemplos_javascript)
      3. [Exemplo de webpack com a linguagem typescript](#id_exemplos_typescript).

      4. [Exemplo completo de uso do TipeScript e uma vídeo aula no youtube.com](../html/typescript/webpack_typescript/video_aula_the_net_ninja/curso_webpack_typescript.html)

      5. Exemplo do manual [webpack](https://webpack.js.org/):
         1. [getting-started/#basic-setup](https://webpack.js.org/guides/getting-started/#basic-setup).

   4. [**Referências.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O [webpack](https://webpack.js.org/concepts/) é um compactador javascript e empacotador de módulo estático para aplicativos JavaScript. Quando o [webpack](https://webpack.js.org/concepts/) processa seu aplicativo ele cria uma versão de distribuição na pasta ./dist e copia para ela todos os arquivos .js compactado e todas as dependências tais como arquivos .html, .css e as imagens do projeto. [Veja mais no vídeo...](https://www.youtube.com/watch?v=sU3W2ZTt-8I) ou [Veja mais no site...](https://devheroes.io/webpack-2-para-iniciantes-o-que-e-porque-usar-e-como-iniciar/).

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Assistir o vídeo [Webpack - Curso rápido para iniciantes](https://www.youtube.com/watch?v=sU3W2ZTt-8I)
         2. Ultima versão do programa [nodejs](instalar.html) de preferência a versão LTS. Veja as versões do nodejs [aqui...](https://nodejs.org/en/blog/release/);

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Gerar uma pasta pronta para publicação na web.
         2. Compactar todo código javascript e html e css.
         3. Remove todo código não usado no projeto atual.
         4. Gerar versão compatível com browser antigos usando o babel.
         5. ...

         6. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_descricao"></span>**Descrição:**
         1. O [webpack](https://webpack.js.org/concepts/) é um empacotador de módulo estático para aplicativos JavaScript modernos. Quando o [webpack](https://webpack.js.org/concepts/) processa um projeto, ele constrói internamente um gráfico de dependência que mapeia todos os módulos de que o projeto precisa e gera um ou mais pacotes na pasta _./dist_. Para mais informações sobre o conceito do webpack veja [aqui...](https://webpack.js.org/concepts/) e para acessar a documentação oficial completa clique [aqui...](https://webpack.js.org/guides/).

         2. O webpack deve ser executado usando o comando **[npx](../html/typescript/instalar.html#id_Instalar_npx)**  para que ele execute a versão local do projeto do webpack.
            1. Código sh:

               ```sh
                  npx webpack
               ```

         3. A configuração padrão do webpack não exige que você use um arquivo de configuração, no entanto, ele assumirá que o [ponto de entrada](https://webpack.js.org/concepts/entry-points/) do projeto seja o arquivo _./src/index.js_ e arquivo de saída seja _./dist/main.js_. O arquivo de saída será reduzido e otimizado para produção na pasta _./dist_.

         4. Caso deseje mudar o comportamento padrão é possível criando o arquivo [webpack.config.js](https://webpack.js.org/configuration/#use-different-configuration-file) na pasta do arquivo [package.js](https://nodejs.org/en/knowledge/getting-started/npm/what-is-the-file-package-json/#:~:text=All%20npm%20packages%20contain%20a,as%20handle%20the%20project's%20dependencies.) porque ele espera que exista o arquivo _./index.html_ na pasta do arquivo _package.json_. Veja [mais...](https://webpack.js.org/configuration/)
            1. As propriedades do arquivo _webpack.config.js_ que pode ser personalizadas são:
               1. [Entry](https://webpack.js.org/concepts/#entry)
                  1. Um ponto de entrada indica qual módulo webpack deve usar para começar a construir seu gráfico de dependência interna.
                     1. Exemplo de arquivo _webpack.config.js_:

                        ```JavaScript
                         
                           module.exports = {
                              entry: './foo.js',
                              },
                           };
                           
                        ```

               2. [Output](https://webpack.js.org/concepts/#output)
                  1. A propriedade [output](https://webpack.js.org/configuration/output/) informa ao webpack onde gerar os pacotes que ele cria e como nomear esses arquivos. O padrão é _./dist/main.js_.
                     1. Exemplo de arquivo _webpack.config.js_:

                        ```JavaScript
                           /** 
                           * path é uma biblioteca NodeJs padrão que está globalmente disponível quando você instala o NodeJs.
                           * A linhas a baixo importa o módulo path que tem informações sobre a localização das pastas do projeto.
                           * [Veja mais sobre o módulo path...:](https://nodejs.org/api/path.html).
                           */                         
                           const path = require('path');

                           /**
                            * O objeto module.exports é um objeto de nodejs usado para exportar objetos, 
                            * funções, variáveis e constantes do módulo onde ele for declarado.
                            * [Vaja mais sobre module.exports](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Statements/export)
                            * [Veja mais sobre configuração do arquivo webpack-config.js](https://webpack.js.org/configuration/)
                            */ 
                           module.exports = {
                              /**
                               * Propriedade entry é usada para informa o nome do arquivo principal 
                               * de entrada do pacote webpack e pode ter mais um entrada para o mesmo projeto.
                               * O arquivo de entrada deve importar todos os arquivos de recursos dependentes do projeto. 
                               */                              
                              entry: './src/file.js',

                              /**
                               * O objeto module é usado para definir as regras usada na compilação ele
                               * contém o conjunto de plug-ins ou módulos usados ​​pelo webpack. 
                               */
                              output: {
                                 path: path.resolve(__dirname, 'dist'),
                                 filename: 'my-first-webpack.bundle.js',
                              },
                           };
                           
                        ```

                     2. Essa configuração criará a pasta _./dist_ na pasta do pacote _package.json_ e o arquivo _'./src/file.js'_ e suas dependências será compactado no arquivo _'./dist/my-first-webpack.bundle.js'_.

               3. [Loaders](https://webpack.js.org/loaders/)
                  1. Por padrão o webpack só entende arquivos JavaScript, para que ele possa entender outros tipos de arquivos devemos usar os _Loaders_ que são módulos que podem ser instalados separadamente possibilitando que o _webpack_ converta esses arquivos em módulos válidos e os adicione ao gráfico de dependência. Os _Loaders_ também são utilizados para converter _JavaScript_ de uma versão para outra. Para incluirmos os _Loaders_ criamos uma nova seção _module_ no arquivo de configuração, nessa seção podemos definir uma ou mais [rules](https://webpack.js.org/configuration/module/#modulerules):
                     1. Código javascript do arquivo _webpack.config.js_

                        ```JavaScript
                           
                           const path = require('path') 
                           const config = {
                              output: {
                                 filename: 'my-first-webpack.bundle.js'
                              },
                              /**
                               * O objeto module é usado para definir as regras usada na compilação ele
                               * contém o conjunto de plug-ins ou módulos usados ​​pelo webpack. 
                               */
                              modules: {
                                 // O array rules são usado para passagem de regras na transpilação dos módulos:
                                 rules: [
                                    
                                     // rules for modules (configure loaders, parser options, etc.)
                                    {test: /\.css$/, use: 'raw-loader'}

                                 ]
                              }
                           }

                        ```

                        1. Essa [regra](https://webpack.js.org/configuration/module/#rule) _rules_ diz ao compilador do webpack para quando for encontrado um arquivo _‘.css’_ dentro de uma declaração [require](https://nodejs.org/en/knowledge/getting-started/what-is-require/) ou [import](https://nodejs.org/api/esm.html#esm_import_specifiers), deve se usar o [css-loader](https://www.npmjs.com/package/css-loader) para transformá-lo antes de adicioná-lo ao pacote.
                           1. Na instrução [rules : []](https://webpack.js.org/configuration/module/#rule) temos duas propriedades obrigatórias quais sejam:
                              1. [test](https://webpack.js.org/configuration/module/#ruletest) : Usa-se a _expressão regular_ para encontrar todos os arquivo _'.css'_ da pasta.
                              2. [use](https://webpack.js.org/configuration/module/#ruleuse) :  Usar o pacote _css-loader_ para carregá-los.

               4. [Plugins](https://webpack.js.org/plugins/)
                  1. Os [plugins](https://webpack.js.org/plugins/) servem para executar uma variedade de tarefas como otimização de pacotes, gerenciamento de assets e injeção de variáveis de ambiente. Plugins são definidos em duas partes no arquivo de configuração, no topo do arquivo para plugins externos e na seção plugins dentro da seção module:
                     1. Código javascript do arquivo _webpack.config.js_

                        ```JavaScript
                           // instalado via npm site: https://webpack.js.org/plugins/html-webpack-plugin/
                           const HtmlWebpackPlugin = require('html-webpack-plugin'); 
                           //plugins internos
                           const webpack = require('webpack'); 
                           const config = {
                              module: {
                                 rules: [
                                    {test: /\.css$/, use: 'css-loader'}
                                 ]
                              },
                              plugins: [
                                 new HtmlWebpackPlugin({template: './src/index.html'})
                              ]
                           };
                           module.exports = config;
                        ```

                        1. No código acima, o plugin [html-webpack](https://webpack.js.org/plugins/html-webpack-plugin/) gera um arquivo html e faz a injeção automática do pacote gerado. O _webpack_ possui diversos plugins internos, [confira a lista](https://webpack.js.org/plugins/).

               5. [Mode](https://webpack.js.org/guides/production/#specify-the-mode)
                  1. No atributo _mode_ é definido o _mode_ de execução do _webpack_ como _\<production\>_, _\<development\>_ ou _\<none\>_. De acordo com a opção definida o _webpack_ ativa otimizações específicas. O ambiente padrão é produção:
                     1. Código javascript do arquivo _webpack.config.js_

                        ```JavaScript
                           module.exports = {
                              mode: 'production'
                           }
                        ```

               6. [Browser Compatibility](https://webpack.js.org/concepts/#browser-compatibility)
                  1. _Webpack_ é compatível com todos os navegadores compatíveis com ES5 (IE8 e versões anteriores não são compatíveis). webpack precisa [Promise](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Promise) para [import()](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Statements/import) e [require.ensure()](https://webpack.js.org/api/module-methods/#:~:text=require.ensure,-warning&text=Split%20out%20the%20given%20dependencies,way%20to%20dynamically%20load%20dependencies.) . Se quiser oferecer suporte a navegadores mais antigos, você precisará carregar um [polyfill](https://developer.mozilla.org/en-US/docs/Glossary/Polyfill) antes de usar essas expressões.

         5. O _webpack_ só entende arquivos _JavaScript_ e _JSON_.
            1. Os [carregadores (loaders)](https://webpack.js.org/loaders/) permitem que o webpack processe outros tipos de arquivos e os converta em módulos válidos que possam ser consumidos pelo projeto e adicionados ao gráfico de dependência do projeto.
            2. Os carregadores podem transformar arquivos de uma linguagem diferente (como [TypeScript](../html/typescript/index.html) ) em _JavaScript_ ou carregar imagens embutidas como _URLs_ de dados. Veja [conceitos dos carregadores...](https://webpack.js.org/concepts/loaders/) .

            3. [Usando carregadores](https://webpack.js.org/concepts/loaders/#using-loaders):
               1. Existem três maneiras de usar carregadores em seu aplicativo:
                  1. [Configuração](https://webpack.js.org/concepts/loaders/#configuration) (recomendado): O ideal é usar o arquivo de configuração [webpack.config.js](https://webpack.js.org/concepts/configuration/#simple-configuration) para customizar _webpack_ porque é mais flexível pelo fato de ser um código _javascript_ e usa a variável global [module.exports](https://stackabuse.com/how-to-use-module-exports-in-node-js/) para exportar o que for necessário quando a configuração é diferente do padrão _webpack_.

                     1. Código JavaScript - exemplo de [configuração simples](https://webpack.js.org/concepts/configuration/#simple-configuration):

                        ```JavaScript

                        const path = require('path');

                        module.exports = {
                           mode: 'development',
                           entry: './foo.js',
                           output: {
                              path: path.resolve(__dirname, 'dist'),
                              filename: 'foo.bundle.js',
                           },
                        };
                           
                        ```

                     2. Código JavaScript - exemplo de configuração com [múltiplos configurações](https://webpack.js.org/configuration/configuration-types/#exporting-multiple-configurations):

                        ```JavaScript

                           module.exports = [
                              {
                                 output: {
                                    filename: './dist-amd.js',
                                    libraryTarget: 'amd',
                                 },
                                 name: 'amd',
                                 entry: './app.js',
                                 mode: 'production',
                              },
                              {
                                 output: {
                                    filename: './dist-commonjs.js',
                                    libraryTarget: 'commonjs',
                                 },
                                 name: 'commonjs',
                                 entry: './app.js',
                                 mode: 'production',
                              },
                           ];
                           
                        ```

                     3. Código JavaScript - exemplo de configuração [paralelismo](https://webpack.js.org/configuration/configuration-types/#parallelism):

                        ```JavaScript

                           module.exports = [
                           {
                              //config-1
                           },
                           {
                              //config-2
                           },
                           ];
                           module.exports.parallelism = 1;
                         
                        ```

                  2. [**Inline**](https://webpack.js.org/loaders/expose-loader/#inline) : especifique-os explicitamente em cada instrução do comando [**import**](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Statements/import).
                     1. Código JavaScript exemplo:

                        ```JavaScript
                        
                        // Adds the `jquery` to the global object under the names `$` and `jQuery`
                        import $ from "expose-loader?exposes=$,jQuery!jquery";

                        // Adds the `lodash/concat` to the global object under the name `_.concat`
                        import { concat } from "expose-loader?exposes=_.concat!lodash/concat";

                        // Adds the `map` and `reduce` method from `underscore` to the global object under the name `_.map` and `_.reduce`'
                        import {'map,
                                 reduce,
                        } from "expose-loader?exposes=_.map|map,_.reduce|reduce!underscore";

                        ```

                  3. [**webpack-cli**](https://webpack.js.org/api/cli/) : especifique-os em um comando sh.
                     1. Código sh exemplo:

                        ```sh
                          
                        webpack --module-bind pug-loader --module-bind 'css=style-loader!css-loader'
                        ```

                        1. Nota: O comando acima usa [pug-loader](https://www.npmjs.com/package/pug-loader) para arquivos [**.jade**](https://www.filesuffix.com/pt/extension/jade) ou [.pug](https://www.filesuffix.com/pt/extension/pug) e [**style-loader**](https://webpack.js.org/loaders/style-loader/) e [css-loader](https://webpack.js.org/loaders/css-loader/) para arquivos _.css_.

         6. Os [plug-ins](https://webpack.js.org/concepts/#plugins) podem ser aproveitados para realizar uma ampla gama de tarefas, como otimização de pacote, gerenciamento de ativos e injeção de variáveis ​​de ambiente etc... Veja [mais...](https://webpack.js.org/concepts/#plugins) .

         7. Quando estamos criando um projeto é necessário customizarmos o arquivo de configuração _webpack.config.js_ para o [modo desenvolvimento](https://webpack.js.org/guides/development/). Veja o tópico [usando webpack-dev-server](https://webpack.js.org/guides/development/#using-webpack-dev-server).

         8. O aplicativo [webpack-cli](https://www.npmjs.com/package/webpack-cli) fornece um conjunto flexível de comandos para que os desenvolvedores aumentem a velocidade ao configurar um projeto webpack personalizado. A partir do _webpack v4_, o _webpack_ não espera um arquivo de configuração, mas frequentemente os desenvolvedores desejam criar uma configuração do _webpack_ mais personalizada com base em seus casos de uso e necessidades. O _webpack-cli_ atende a essas necessidades, fornecendo um conjunto de ferramentas para melhorar a configuração do _webpack personalizado_.
            1. Veja o [guia de instalação](https://webpack.js.org/guides/installation/) para saber como instalar.
            2. Para conhecer os comandos do programa [webpack-cli](https://www.npmjs.com/package/webpack-cli) veja o [documento Interface da Linha de comando](https://webpack.js.org/api/cli/).

      5. <span id=id_webpack_typescript></span>
      [Como usar webpack com a linguagem typescript](https://webpack.js.org/configuration/configuration-languages/#typescript).
         1. A forma mais prática de criar ambiente de desenvolvimento _typescript_ é executar a sequencia abaixo. Dica: a ultima linha executa o comando _npx tsc-init_. O programa _tsc-init_ instala o _webpack_ e cria uma configuração básica. [Veja mais...](https://webpack.js.org/guides/typescript/)

            1. Código sh

               ```sh

                  # Instala a linguagem typescript globalmente se não tiver instalado.
                  sudo npm -g install typescript

                  # para saber se foi instalado checar a versão
                  tsc -v 

                  # Instala pacote tsc-init globalmente
                  npm install -g install tsc-init  

                  # Cria arquivo package.json
                  npm init

                  

                  # Instala e configura tudo que é necessário na pasta local.
                  npx tsc-init 

               ```

            2. O comando [npx tsc-init](https://www.npmjs.com/package/tsc-init) instala os seguinte pacotes:
               1. "webpack": "^5.37.0",
                  1. O _webpack_ é um compactador _javascript_ e _empacotador de módulo estático_ para aplicativos _JavaScript_. [Veja mais...](https://webpack.js.org/configuration/configuration-languages/)

               2. "webpack-dev-server": "^3.11.2"
                  1. O _webpack-dev-server_ fornece um _servidor web_ simples e a capacidade de recarregar ao vivo para evitar que a cada alteração do código original o programador tenha que publicar para ver se funcionou as alterações.

               3. "@types/jasmine": "^3.7.2",
                  1. [Este pacote contém definições de tipo para Jasmine](http://jasmine.github.io).

               4. "jasmine-core": "^3.7.1",
                  1. [Jasmine](https://www.npmjs.com/package/jasmine-core) é uma estrutura de desenvolvimento orientada por comportamento para testar o código _JavaScript_ independente de navegadores.

               5. "karma": "^6.3.2",
                  1. [Karma](https://karma-runner.github.io/latest/index.html) é um _test runner_ feito para o _AngularJs_. O principal objetivo do _Karma_ é automatizar os testes em diversos navegadores web com um único comando.

               6. "karma-chrome-launcher": "^3.1.0",
                  1. Pacote _karma_ para o navegador _chrome_. [Veja mais...](https://developers.google.com/web/updates/2017/06/headless-karma-mocha-chai)

               7. "karma-jasmine": "^4.0.1",
                  1. Adaptador para a estrutura de teste _Jasmine_. [Veja mais...](https://www.npmjs.com/package/karma-jasmine)

               8. "karma-webpack": "^5.0.0",
                  1. Use o _webpack_ para pré-processar arquivos no _karma_. [Veja mais...](https://www.npmjs.com/package/karma-webpack)

               9. ["ts-loader": "^9.1.2"](https://webpack.js.org/concepts/loaders/#:~:text=Loaders%20are%20transformations%20that%20are,source%20code%20of%20a%20module.&text=Loaders%20can%20transform%20files%20from,directly%20from%20your%20JavaScript%20modules!),
                  2. Este é o carregador _TypeScript_ para _webpack_. [Veja mais...](https://www.npmjs.com/package/ts-loader)

            3. Para que o projeto seja editado e executado no _vscode_ adicione no registro _"compileOptions"_ do arquivo _tsconfig.json_ as propriedades _outDir_ (diretório de saída para arquivos _.js_) e a propriedade [sourceMap](https://www.typescriptlang.org/tsconfig#sourceMap) (Permite compilar e depurar com vscode  ):

               ```json
                  //tsconfig.json
                  {
                     "compilerOptions"  : 
                     {
                        "outDir": "./src/js", //Pasta de saída dos arquivos .js
                        "sourceMap": true, //Permite compilar e depurar com vscode  
                                           //Gera o arquivo '.map' correspondente  
                     }
                  }
               ```
  
   2. **Instalação e configuração local**
      1. <span id=id_Instalar_webpack></span>**Instalar versão mais recente do** [**webpack**](https://webpack.js.org/guides/installation/):
         1. Criar a pasta e o arquivo de configuração _package.json_ do projeto.

            ```Sh

               mkdir webpack-demo
               npm init -y

            ```

            - Nota: O comando _npm init -y_ criou o arquivo de configuração _package.json_.

               ```json
                  //package.json
                  {
                     "name": "webpack-demo",
                     "version": "1.0.0",
                     "description": "",
                     "main": "index.js",
                     "scripts": {
                        "test": "echo \"Error: no test specified\" && exit 1"
                     },
                     "author": "",
                     "license": "ISC"
                  }
               ```

         2. Instalar [webpack](https://webpack.js.org/) na pasta criada no passo 1:
            1. Código _sh_ para instalação:

               ```sh

                  npm install --save-dev webpack

               ```

               1. O comando _npm install --save-dev webpack_ adicionou no arquivo _package.json_ a chaves: _"devDependencies": {"webpack": "^5.36.1"}_

                  ```json
                     //package.json
                     {
                        "name": "webpack-demo",
                        "version": "1.0.0",
                        "description": "",
                        "main": "index.js",
                        "scripts": {
                           "test": "echo \"Error: no test specified\" && exit 1"
                        },
                        "author": "",
                        "license": "ISC",
                        "devDependencies": {
                           "webpack": "^5.36.1"
                        }
                     }
                  ```

            2. <text onclick="goBack()">[🔙]</text>

         3. <scan id="id_html_webpack_plugin"></scan> **Instalar plugins _html-webpack-plugin_**;
            1. O plugins ["html-webpack-plugin"](https://www.npmjs.com/package/html-webpack-plugin) para _webpack_ simplifica a criação de arquivos _HTML_ para servir seus pacotes _webpack_. Isso é especialmente útil para pacotes _webpack_ que incluem um _hash_ no nome do arquivo, que muda a cada compilação. Você pode deixar o _plugin gerar um arquivo HTML para você_, fornecer seu próprio modelo usando _lodash_ modelos ou usar seu próprio carregador.

               ```sh

                  # Instala plugin a ser usado por alterWebpackConfig()
                  npm install npm install --save-dev html-webpack-plugin

               ```

            2. <text onclick="goBack()">[🔙]</text>

         4. .

      2. <span id=id_webpack-cli></span>**Instalar a versão mais recente do** [webpack-cli](https://webpack.js.org/api/cli/#commands)
         1. Para a versão 4 ou posterior do _webpack_ é preciso instalar o aplicativo [webpack-cli](https://webpack.js.org/api/cli/#commands) para executar o _webpack_ partir da linha de comando.
            1. Código sh para instalação:

               ```sh

                  npm install --save-dev webpack-cli

               ```

               - O comando _npm install --save-dev webpack-cli_ adicionou no arquivo _package.json_ a chaves: _"webpack-cli": "^4.6.0",_

                  ```json
                     //package.json
                     {
                        "name": "webpack-demo",
                        "version": "1.0.0",
                        "description": "",
                        "main": "index.js",
                        "scripts": {
                           "test": "echo \"Error: no test specified\" && exit 1"
                        },
                        "author": "",
                        "license": "ISC",
                        "devDependencies": {
                           "webpack": "^5.36.1",
                           "webpack-cli": "^4.6.0"
                        }
                     }
                  ```

         2. <text onclick="goBack()">[🔙]</text>

         3. <span id=id_webpack_cli_init></span>**Instalar _webpack-cli init_**
            1. Este pacote contém a lógica para criar uma nova configuração do _webpack_. Veja [mais...](https://www.npmjs.com/package/@webpack-cli/init)

               ```sh

                  npm i -D webpack-cli @webpack-cli/init

               ```

            2. <text onclick="goBack()">[🔙]</text>

         4. <span id=id_webpack-cli_generators></span>**Instalar** [webpack-cli generators](https://www.npmjs.com/package/@webpack-cli/generators)
            1. Este pacote contém todos os [geradores yeoman](https://yeoman.io/) relacionados ao webpack-cli..
            2. Veja dica do site [medium.com](https://medium.com/code-prestige/dando-o-pontap%C3%A9-inicial-em-projetos-de-software-com-o-yeoman-2f079cb14cf3) para entender do que se trata.
            3. Código sh

               ```sh

                  npm i -D webpack-cli @webpack-cli/generators
                  
               ```

            4. <text onclick="goBack()">[🔙]</text>

      3. [**Configuração**](https://webpack.js.org/configuration/) _do webpack_:
         1. <span id=id_configurar_webpack_padrao></span> Configuração padrão:
            1. O _webpack_ não exige que você use um arquivo de configuração. No entanto, ele assumirá que o ponto de entrada de seu projeto seja _src/index.js_ e produzirá o resultado _dist/main.js_ reduzido e otimizado para produção.
            2. Para testar se seu projeto está funcionando execute a linha de comando abaixo:

               ```sh

                  ./node_modules/.bin/webpack

               ```

            3. Este comando produzirá a seguinte mensagem:

               ```sh
                  asset main.js 25 bytes [compared for emit] [minimized] (name: main):
                  ./src/index.js 25 bytes [built] [code generated]
                  AVISO na configuração
                     A opção 'mode' não foi definida, o webpack irá retornar para 'production' para este valor.
                     Defina a opção 'mode' como 'development' ou 'production' para habilitar os padrões para cada ambiente.
                     Você também pode defini-lo como 'none' para desativar qualquer comportamento padrão. Saiba mais: <https://webpack.js.org/configuration/mode/>
               ```

            4. Se a opção _'mode'_ não for definido, _webpack_ define _'mode'_ para _'production'_ como o valor padrão.

            5. <text onclick="goBack()">[🔙]</text>

         2. <span id=id_configurar_webpack_personalizada></span> **Configuração Personalizada**.
            1. Quando você precisar alterar a configuração padrão você pode criar o arquivo _webpack.config.js_  na pasta raiz e o _webpack_ irá usá-lo automaticamente para satisfazer sua preferência.
            2. Caso seja necessário o nome do arquivo de configuração diferente de _webpack.config.js_ é possível informar no arquivo _package.json_ na propriedade _script{}_ como no exemplo abaixo:

               ```json
                  //package.json
                  "scripts": {
                     "build": "webpack --config production.config.js"
                  }

               ```

            3. A maneira mais prática para criar o arquivo de configuração _webpack.config.js_ personalizada é executar o comando abaixo:

               ```sh

                  npx webpack-cli init

               ```

               - Este comando faz as seguintes tarefas:
                  1. Cria o arquivo _webpack.config.js_
                  2. Criar um arquivo _./index.html_
                  3. Cria a pasta _./src_
                  4. Cria um arquivo _/.src/index.js_
                  5. ..

            4. <text onclick="goBack()">[🔙]</text>

         3. <span id=id_nanoid></span> **Instalar [nanoid](https://github.com/ai/nanoid)**
            1. Um _gerador de ID de string minúsculo_, seguro, compatível com _URL_ e exclusivo para _JavaScript_.
            2. Obs: Se não instalar [nanoid](https://github.com/ai/nanoid) o comando _npx webpack init_ gerar um erro.

               ```sh

                  npm install --save-dev nanoid
                  npm install --save-dev @types/nanoid

               ```

            3. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_webpack-dev-server></span>
      **Instalar a versão mais recente do** [webpack-dev-server](https://webpack.js.org/guides/development/#using-webpack-dev-server):
         1. O [webpack-dev-server](https://webpack.js.org/guides/development/#using-webpack-dev-server) fornece um _servidor web_ simples e a capacidade de recarregar ao vivo para evitar que a cada alteração do código original o programador tenha que publicar para ver se funcionou as alterações.

            ```sh

               npm install --save-dev webpack-dev-server

            ```

            - O comando _npm install --save-dev webpack-dev-server_ adicionou no arquivo _package.json_ a chaves: _"webpack-dev-server": "^3.11.2"_

               ```json
                  //package.json
                  {
                     "name": "webpack-demo",
                     "version": "1.0.0",
                     "description": "",
                     "main": "index.js",
                     "scripts": {
                        "test": "echo \"Error: no test specified\" && exit 1"
                     },

                     "author": "",
                     "license": "ISC",
                     "devDependencies": {
                        "webpack": "^5.36.1",
                        "webpack-cli": "^4.6.0",
                        "webpack-dev-server": "^3.11.2"
                     }
                  }

               ```

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_exemplos></span>**Exemplos.**
      1. **webpack Getting Started.**
         1. <span id=id_Exemplo_basico></span> [Basic Setup](https://webpack.js.org/guides/getting-started/#basic-setup).
            1. Primeiro, vamos criar um diretório, inicializar o _npm_, instalar o _webpack_ localmente e instalar o _webpack-cli_ (a ferramenta usada para executar o _webpack_ na linha de comando):

               ```sh

                  mkdir basic_setup
                  cd basic_setup
                  npm init -y
                  npm install webpack webpack-cli lodash --save-dev

               ```

            2. Segundo vamos criar o arquivo _./index.html_, a pasta _./src_ e o arquivo _./src/index.js_.

            3. Adicionar código abaixo no arquivo _./src/index.js_

               ```JavaScript

                  import _ from 'lodash';
                  function component() {
                     const element = document.createElement('div');
                     /**
                     Lodash (https://lodash.com/), atualmente incluído por meio de um script,
                     é necessário para que esta linha funcione porque tem a function "_.join()".

                     Lodash é uma biblioteca de utilitários JavaScript 
                     moderna que oferece modularidade, desempenho e extras.
                     
                     */                       
                     element.innerHTML = _.join(['Alo', 'Mundo'], ' ');
                     return element;
                  }

                  document.body.appendChild(component());

               ```

            4. Adicionar código abaixo no arquivo _./index.html_

               ```html

                  <!DOCTYPE html>
                  <html lang="pt-BR">
                  <head>
                     <meta charset="utf-8" />
                     <title>Getting Started</title>
                     <!--  
                     Lodash (https://lodash.com/) é uma biblioteca de utilitários JavaScript 
                     moderna que oferece modularidade, desempenho e extras.
                     -->
                     <!-- <script src="https://unpkg.com/lodash@4.17.20"></script> -->
                  </head>
                  <bodY>
                     <script src="./src/index.js"></script>
                   </body>
                  </html>

               ```

            5. Agora é preciso ajustar o arquivo _package.json_ adicionando a propriedade _"private" : true_ e removendo a propriedade _"main": "index.js"_. Isso evita uma publicação acidental do seu código.

               ```json
                  //package.json
                  {
                     "name": "basic_setup",
                     "version": "1.0.0",
                     "description": "",                        
                     "private": true,
                     "scripts": {
                        "test": "echo \"Error: no test specified\" && exit 1"
                        "build" : "webpack --mode='production'",

                     },
                     "keywords": [],
                     "author": "",
                     "license": "ISC",
                     "devDependencies": {
                        "webpack": "^5.36.2",
                        "webpack-cli": "^4.6.0"
                     }
                  }
                  
               ```

            6. Último passo é preciso seguir os seguintes passos:
               1. Executar comando [npx](../html/typescript/instalar.html#id_Instalar_npx) _webpack_ que tomará nosso script _./src/index.js_ como ponto de entrada e gerará _./dist/main.js_ como saída. O _npx_ executa o binário _webpack_ (_./node_modules/.bin/webpack_) do pacote webpack que instalamos no início:

                  ```sh

                     
                     # O comando abaixo criar a pasta ./dist e
                     # compacta o código javascript ./src/index.js 
                     # para a pasta ./dist                     
                     npx webpack

                  ```

               2. Mova o arquivo _index.html_ para a pasta _./dist_;

               3. No arquivo _./dist/index.html_ troque a linha _\<script src="./src/index.js"\> \</script\>_ para _\<script src="main.js"\>\</script\>_.

                  ```html

                     <!DOCTYPE html>
                     <html lang="pt-BR">
                     <head>
                        <meta charset="utf-8" />
                        <title>Getting Started</title>
                        <!--  
                        Lodash é uma biblioteca de utilitários JavaScript 
                        moderna que oferece modularidade, desempenho e extras.
                        -->
                        <!-- <script src="https://unpkg.com/lodash@4.17.20"></script> -->
                     </head>
                     <bodY>
                        <!-- <script src="./src/index.js"> -->
                        <script src="main.js"></script>
                      </body>
                     </html>

                  ```

               4. Para testar execute o arquivo _./dist/index.html_ no browser.

               5. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_exemplos_javascript></span>**Exemplo de webpack com a linguagem javascript**
         1. Criar o projeto na pasta selecionada:

            ```sh

               npm init -y

               npm install --save-dev @babel/core @babel/cli
               npm install --save-dev @babel/plugin-transform-block-scoping

               npm install --save-dev webpack webpack-cli
               npm i -D webpack-cli @webpack-cli/generators                  
               npm install --save-dev webpack-dev-server                  

               npm install --save-dev nanoid
               npm install --save-dev @types/nanoid
               npm install --save lodash
               
               # Veja nota ...2.1 abaixo para detalhes do comando a seguir.
               npx webpack-cli init  

            ```

            - Notas:
               - O comando _npx webpack-cli init_ acima informa que existe um conflito. Motivo: O arquivo _package.json_ foi criado no primeiro comando. Diga _não_ para que mantenha o _package.json_ atual.

         2. Após criar o projeto, siga os passos abaixo para construção do exemplo 01:  
            1. Selecionar o arquivo _./src/index.js_ e edite o seguinte código:  

               ```JavaScript  

                  function component() {
                     const element = document.createElement('div');

                     // Lodash, currently included via a script, is required for this line to work
                     element.innerHTML = _.join(['Hello', 'webpack'],' ');

                     return element;
                  }

                  document.body.appendChild(component());
                  
               ```

            2. Selecionar o arquivo _./index.html_ e edite o seguinte código:  

               ```html

                  <!DOCTYPE html>
                  <html lang="pt-BR">
                  <head>
                     <meta charset="utf-8" />
                     <title>Getting Started</title>
                     <script src="https://unpkg.com/lodash@4.17.20"></script>
                  </head>
                  <bodY>
                     <script src="./src/index.js"></script>
                   </body>
                  </html>
                  
                  ```

            3. Também precisamos ajustar nosso _package.json_ arquivo para ter certeza de marcar nosso pacote como private, bem como remover a entrada _main_. Isso evita uma publicação acidental do seu código.

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_exemplos_typescript></span>[**Exemplo de webpack com a linguagem typescript**](https://webpack.js.org/configuration/configuration-languages/):
         1. Criar o projeto na pasta selecionada:
            1. Código shellScript
               1. [sh para criar projetos typescript/my-tsc-init-ver-0.2.0.sh](../html/typescript/webpack_typescript/modelo01/my-tsc-init-ver-0.2.0.sh)
               2. [Veja mais...](../html/typescript/webpack_typescript/modelo01/my-tsc-init.md)
            2. .

         2. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [Guia de instalação oficial](https://webpack.js.org/guides/installation/)
      2. [Enhance main window](https://ankiweb.net/shared/info/877182321)
      3. [webpack](https://webpack.js.org/concepts/)
      4. [Vídeo para iniciante sobre webpack](https://www.youtube.com/watch?v=sU3W2ZTt-8I)
      5. [webpack-2-para-iniciantes-o-que-e-porque-usar-e-como-iniciar](https://devheroes.io/webpack-2-para-iniciantes-o-que-e-porque-usar-e-como-iniciar/).
      6. [postcss aumentar a legibilidade do código css](https://postcss.org/)
      7. [nanoid](https://github.com/ai/nanoid)
      8. [configuration/mode](https://webpack.js.org/configuration/mode/)
      9. [O que é babel js](https://www.youtube.com/watch?v=RZQMAuHE_hw)
      10. [Letra da música do programa babel js](https://medium.com/@angustweets/hallelujah-in-praise-of-babel-977020010fad)
      11. [Música do programa bebel js](https://www.youtube.com/watch?v=40abpedBKK8)
      12. [Conceitos do webpack](https://webpack.js.org/concepts/)
      13. [Generate Webpack Configuration file (webpack.config.js) using webpack-cli](https://springbootdev.com/2018/03/06/generate-webpack-config-js-with-webpack-cli/)
      14. [dev-server-configuration](https://webpack.js.org/configuration/dev-server/)
      15. [Webpack & TypeScript](https://www.youtube.com/playlist?list=PL4cUxeGkcC9hOkGbwzgYFmaxB0WiduYJC)
      16. [html-webpack-plugin](https://www.npmjs.com/package/html-webpack-plugin)
      17. [Babel e Webpack que roda em seus Projetos JavaScript?](https://www.you<bodtube.com/watch?v=LMCtGvLJT6c)
      18. [webpack // Dicionário do Programador](https://www.youtube.com/watch?v=PcWOAYbTc9Y&t=5s)
      19. [html-loader](https://github.com/webpack-contrib/html-loader)
      20. [html-webpack-plugin](https://github.com/jantimon/html-webpack-plugin/blob/main/docs/template-option.md)
      21. [html-webpack-template](https://github.com/jaketrent/html-webpack-template)
      22. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 11/05/2023 <!--TODO: HISTÓRICO -->
         - [x] Adaptar css para que acesse os css da pasta /css ;
         - [x] Os destaques que estavam em negritos trocar para enfatizado.

         - <text onclick="goBack()">[🔙]</text>

      2. 27/04/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo02.md ;

         - <text onclick="goBack()">[🔙]</text>

      3. 28/04/2021
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios

         - <text onclick="goBack()">[🔙]</text>

      4. 29/04/2021
         - [x] Criar tópico instalar a versão mais recente do webpack.
         - [x] Criar tópico Instalar a versão mais recente do webpack-cli.
         - [x] Criar tópico Instalar a versão mais recente do webpack-dev-server.

         - <text onclick="goBack()">[🔙]</text>

      5. 30/04/2021
         - [x] Escrever tópico configuração do webpack.
         - [x] Escrever tópico Exemplos - falta executar javascript dentro do arquivo ./index.html

      6. 05/05/2021
         - [x] Escrever tópico Exemplo básico de uso do webpack.

      7. 06/05/2021
         - [x] Escrever tópico descrição do webpack parte 01.

      8. 08/05 a 11/05/2021
         - [x] Escrever tópico descrição do webpack.

      9. 27/05/2021
         - [x] Criar documento: Como usar webpack com a linguagem typescript.
         - [x] Escrever tópico Referências
         - [x] Atualizar o histórico deste documento.

      10. 15/06/2021
         - [x] Depois de tanta luta para entender webpack, achei o projeto webpack-demo com 15 exemplo. Meu erro foi achar que ele pudesse pegar meu projeto atual e transformar em site de distribuição na web. O objetivo do webpack é empacotar javascript apenas.

      11. xx/06/2021 <!--TODO: Falta fazer os item abaixo: -->
         - [ ] Testar este documento depois que eu esquecer dele.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
