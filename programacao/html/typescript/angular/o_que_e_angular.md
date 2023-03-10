# <span id="topo"><span>O que é Framework Angular <a href="o_que_e_angular.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="o_que_e_angular.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Instalar](#id_instalar)
      2. [Como criar um novo projeto Angular](#id_Como_criar_novo_projeto)
      3. [Como criar um componente usando  o angular/cli](#id_como_criar_componente)
      4. [Como criar biblioteca com o Angular 2](#id_como_criar_workspace_null)
      5. [Como gerar projeto para publicar na web](#id_como_gerar_projeto_para_publicar_na_web)
      6. [Como criar módulos](#id_como_criar_modulos )
      7. [Como usar rotas em Angular 2](#id_como_usar_rotas_em_angular_2)
         1. [Arquivos para implementação de Rotas](#id_arquivos_implementacao_rotas)
         2. [Exibindo as páginas do projeto](#id_exibindo_paginas_projeto)
         3. [Rotas filhas](#id_rotas_filhas)
         4. [Guardas de Rota (Prevenir o acesso não autorizado)](#id_guardas_de_rota).
      8. [Assunto 08](#id_assunto08)
      9. [Assunto 09](#id_assunto09)
      10. [Assunto 10](#id_assunto10)

   4. Exemplos de uso do angular:
      1. [Como criar formulário de login no angular](./como_criar_formulario_de_login_no_angular.html)
      2. [Ocultar a barra de menu quando o usuário não tiver autenticado](como_criar_formulario_de_login_no_angular.html#id_passo09)
      3. [Usando guada de rotas para usuário não autenticado](como_criar_formulario_de_login_no_angular.html#id_passo10)

   5. [**Referências globais.**](#id_referencias)

   6. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. Descreve um resumo de como foi feito esse documento com as facilidade encontradas para produzi-lo e dificuldade encontrada.

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. [Angular](https://angular.io/docs) é um framework escrito em [typescript](https://www.typescriptlang.org/docs/handbook/typescript-tooling-in-5-minutes.html) criado pelo Google para criação de aplicativos clientes web onde o mesmo se comporta muito parecido com aplicativo desktop ou seja: aplicação single page (Página única).
         2. O Angular tem licença MIT e além do Google existe uma comunidade atuante que melhoram o produto todos os dia saindo uma nova versão a cada 6 meses.
         3. Outra característica que considero importante é que cada versão será compatível com a anterior.
         4. [Introdução aos conceitos do framework angular 2](https://angular.io/guide/architecture#introduction-to-angular-concepts).
         5. [Veja o que é Angular?](https://angular.io/guide/what-is-angular#what-is-angular)

         6. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Programas necessários devem estar instalados:
            1. [**nodejs**](https://nodejs.org/en/download/)
            2. [**npm**](https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm/)
            3. [**vscode**](https://code.visualstudio.com/download)
            4. [**typescript**](http://127.0.0.1:5501/programacao/html/typescript/instalar.html#id_Instalar_typescript)

         2. Conhecimento das linguagens:
            1. [html](../../index.html)
            2. [css](../../css/index.html)
            3. [**typescript**](../index.html)
            4. [javascript](../../js/index.html)
            5. [sql](../../../sql/index.html)
            6. [Conhecimento do conceito de programação orientada a objetos](https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_orientada_a_objetos).

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. O framework Angular ajuda na criação de Single-Page Applications, com nível de produtividade e qualidade acima da média é open source e tem uma comunidade muito ativa.
         2. O angular por ser framework possue tudo que é preciso para construção de aplicativos web.
         3. Por ser escrito em typescript é estável e permite construção de aplicativos sem erros de sintaxe em tempo de execução como ocorre com javascript.
         4. O Angular adapta e estende o HTML tradicional para uma experiência otimizada, com conteúdo dinâmico e ligação direta dos dados, conhecida como [two-way data-binding (ligação de dados bidirecional)](https://www.tutorialsteacher.com/angular/two-way-data-binding), que abre a possibilidade para sincronização automática de modelos e visualizações.

         5. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span> **Desvantagens.**
         1. A desvantagens é relativa ou seja: Caso seja um programador que não tenha conhecimento de programação orientada a objetos terá dificuldade de entender porque o Angular é todo orientado a objetos.
         2. Para programadores que conhecem javascript vai estranhar a linguagem typescript porque a mesma permite identificar erros de sintaxe em tempo de edição do código.

         3. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_instalar></span>**[**Instalar o angular**](https://www.tutorialsteacher.com/angular/install-angular)**
         1. Para instalar a versão mais recente do Node.js, vá para <https://nodejs.org> e baixe o instalador para sua plataforma e instale-o. Isso instalará o Node.js e o NPM em sua máquina local.
         2. Instalar Angular no linux
            1. Código ShellScript

               ```sh
                  # checar versão do node instalada.
                  node -v

                  # Checar a ultima versão no npm
                  npm -v

                  # Instalar a ultima versão do npm caso use um espaço de trabalho para cada projeto
                  sudo npm install -g npm

                  # Caso existe um espaço de trabalho para vários projetos o ideal é instalar o pacote https://pnpm.io/
                  sudo npm install -g pnpm

                  # O Angular oferece muitas bibliotecas e pacotes para o desenvolvimento de aplicativos. 
                  # O Angular CLI também é usado para gerar, construir, executar e implantar aplicativos Angular.
                  sudo npm install -g @angular/cli

                  # Para visualizar a versão atual do angular
                  ng --version

               ```

         3. Referências:
            1. [Angular CLI: Estrutura do projeto](https://www.youtube.com/watch?v=ICvq9YeDCh0&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=28)

         4. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_Como_criar_novo_projeto></span>**Como criar um novo projeto Angular**
         1. A instalação do pacote [**@angular/cli**](https://angular.io/cli) adiciona no prompt do shellscript o comando **ng** onde mesmo possue comando **new** que é usado para criar um espaço de trabalho completo (todos os componentes necessários) para angular criar um novo projeto. [Veja mais...](https://angular.io/cli/new)
         2. **Passo a passo**.
            1. Abre o console do linux **Crt+alt+T** e selecione a pasta raiz de todos os projetos angular 2.
            2. Execute os comandos abaixo para criar e executar o novo projeto:

               ```sh

                  # Para criar um novo projeto                  
                  ng new nome-do-projeto --routing

                  # Perguntas que o comando ng new nome-do-projeto faz:
                     ? Você gostaria de adicionar o roteamento angular? Y/N
                     ? Qual formato de folha de estilo você gostaria de usar? (Use as setas)
                       ❯ CSS 
                         SCSS   [ https://sass-lang.com/documentation/syntax#scss                ] 
                         Sass   [ https://sass-lang.com/documentation/syntax#the-indented-syntax ] 
                         Less   [ http://lesscss.org  

                  # Move apar a pasta do projeto criado
                  cd ./nome-do-projeto

                  # Executa a aplicação criada pelo comando: .
                  ng serve

               ```

               1. **NOTAS:**
                  1. Em seu navegador, abra <http://localhost:4200> para ver o novo aplicativo em execução. Quando você usa o comando **ng serve** para construir um aplicativo e atendê-lo localmente, o servidor reconstrói automaticamente o aplicativo e recarrega a página quando você altera qualquer um dos arquivos de origem.

                  2. O comando **ng new nome-do-projeto** cria os [arquivos de configurações](https://angular.io/guide/file-structure#workspace-configuration-files) do espaço de trabalho. O arquivo [**readme.md**](./readme.html) informa tudo que precisa fazer para executar o projeto criado.

                  3. [Vídeo aula sobre criação de novo projeto com a cli](https://www.youtube.com/watch?v=ICvq9YeDCh0&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=22)

                  4. Pastas criadas pelo comando **ng new nome-do-projeto**:
                     1. **src/**
                        1. Pasta com todos os arquivos do projeto.

                     2. **src/app/**
                        1. Pasta para os componentes do projeto.

                     3. **src/assets/**
                        1. Cada build configuração de destino pode incluir uma assets matriz que lista os arquivos ou pastas que você deseja copiar no estado em que se encontram ao construir seu projeto. Por padrão, a **src/assets/** pasta e **src/favicon.ico** são copiados. [Veja mais...](https://angular.io/guide/workspace-config#assets-configuration).

                     4. **src/environments/**
                        1. Pasta de um projeto que contém o arquivo de configuração base **environment.ts**, que fornece um ambiente padrão. Você pode adicionar padrões de substituição para ambientes adicionais, como produção e teste, em arquivos de configuração específicos de destino. [Veja mais...](https://angular.io/guide/build#configuring-application-environments)

                     5. **node_modules/**
                        1. Pasta com as dependência do Angular para o projeto.

                  5. Arquivos criadas pelo comando **ng new nome-do-projeto**:
                     1. **./src/app/app.component.css**
                        1. Este arquivo é usado para registrar todo o código **.css** da aplicação. [Veja mais...](https://angular.io/guide/component-styles)

                     2. **./src/app/app.component.html**
                        1. Arquivo .html para o template principal do projeto. [Veja a sintaxe do modelo...](https://angular.io/guide/template-syntax)
                        2. [templates-and-views](https://angular.io/guide/architecture-components#templates-and-views)

                     3. **./src/app/app.component.ts**
                        1. Arquivo typescript de componente contém a classe com o código usado pelo template **./src/app/app.component.html**
                        2. [Veja a documentação criando componente](https://angular.io/guide/component-overview)

                     4. **./src/app/app.component.spec.ts**
                        1. Este arquivo é usado para fazer teste unitário da classe.
                        2. Mais informações [clique aqui...](https://angular.io/guide/testing#testing)

                     5. **src/styles.css**
                        1. Arquivos de estilo externo e global. [Veja mais...](https://angular.io/guide/component-styles#external-and-global-style-files)

                     6. **src/index.html**
                        1. ..

                     7. Módulo raiz usados para roteamento de componentes:
                        1. [**./src/app/app.module.ts**](https://angular.io/guide/router#defining-a-basic-route)
                           1. As rotas informam ao roteador qual visualização exibir quando um usuário clica em um link ou cola uma URL na barra de endereço do navegador.
                           2. Este arquivo contem a classe com decorador [NgModule](https://angular.io/api/core/NgModule#ngmodule).
                           3. O componentes [providers](https://angular.io/guide/providers) e [bootstrap](https://getbootstrap.com/) são declarados somente no módulo raiz.
                           4. Só tem sentido usar rotas se a aplicação tiver mais um componentes.

                        2. [**./src/app/app-routing.module.ts**](https://github.com/johnpapa/angular-tour-of-heroes/blob/master/src/app/app-routing.module.ts)
                           1. [Veja a vídeo aula sobre rotas](https://www.youtube.com/watch?v=8OHoAZ6j0Rg&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=51)
                           2. Este arquivo é usado para declarar as rotas da aplicação. [Veja mais...](https://angular.io/guide/router#defining-a-basic-route)
                           3. As rotas são adicionadas na matriz: **const routes: [Routes](https://angular.io/api/router/Route) = [];**
                              1. Cada rota nesta matriz é um **objeto JavaScript** que contém duas propriedades. A primeira propriedade [**path**](https://angular.io/api/router/Route#path), define o caminho do URL para a rota. A segunda propriedade [**component**](https://angular.io/api/router/Route#component), define o componente que o Angular deve usar para o caminho correspondente.
                              2. Exemplo:

                                    ```js
                                       const routes: Routes = [
                                          { path: 'first-component', component: FirstComponent },
                                          { path: 'second-component', component: SecondComponent },
                                          { path: 'nome-do-component', component: NomeDoComponent },

                                          ...

                                          ];
                                    ```

                           4. O arquivo [**src/polyfills.ts**](https://angular.io/guide/browser-support#polyfills) é usado para importas as bibliotecas auxiliares.
            3. **Referências**
               1. [Angular CLI](https://angular.io/cli)
               2. [Angular CLI: Estrutura do projeto](https://www.youtube.com/watch?v=ICvq9YeDCh0&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=28)
               3. [Vídeo aula sobre criação de novo projeto com a cli](https://www.youtube.com/watch?v=ICvq9YeDCh0&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=22)
               4. [CLI ng new](https://angular.io/cli/new)
               5. [arquivos de configurações](https://angular.io/guide/file-structure#workspace-configuration-files)
               6. [**readme.md**](./readme.html)
               7. [Componentes de estilos = css](https://angular.io/guide/component-styles)
               8. [Sintaxe do modelo...](https://angular.io/guide/template-syntax)
               9. [templates-and-views](https://angular.io/guide/architecture-components#templates-and-views)
               10. [Componentes Visão Geral](https://angular.io/guide/component-overview)
               11. [Testando componentes](https://angular.io/guide/testing#testing)
               12. [Definindo uma rota básica](https://angular.io/guide/router#defining-a-basic-route)
               13. [NgModule](https://angular.io/api/core/NgModule#ngmodule)
               14. [providers](https://angular.io/guide/providers)
               15. [bootstrap](https://getbootstrap.com/)
               16. [Vídeo aula sobre módulos](https://www.youtube.com/watch?v=36kd3uR-hG8&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=6)
               17. [Veja a vídeo aula sobre rotas](https://www.youtube.com/watch?v=8OHoAZ6j0Rg&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=51)
               18. [Interface Route](https://angular.io/api/router/Route)
               19. [Configuração de ativos](https://angular.io/guide/workspace-config#assets-configuration).
               20. [Configuração de ambiente do projeto](https://angular.io/guide/build#configuring-application-environments)
               21. [Arquivos de estilo externo e global](https://angular.io/guide/component-styles#external-and-global-style-files)

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_como_criar_componente></span>**Como criar um componente usando  o angular/cli**
         1. [Visão geral da CLI e referência de comando](https://angular.io/cli#cli-overview-and-command-reference)
         2. [Criando um componente usando a CLI Angular](https://angular.io/guide/component-overview#creating-a-component-using-the-angular-cli).
         3. **Exemplo de como criar componente no prompt do linux**.

            ```sh
               # Cria componente de nome home
               ng generate component pages/home
               
            ```

         4. Referências:
            1. [Visão geral da CLI e referência de comando](https://angular.io/cli#cli-overview-and-command-reference)
            2. [Criação de um componente usando a CLI Angular](https://angular.io/guide/component-overview#creating-a-component-using-the-angular-cli)
            3. [Comando **ng generate component**](https://angular.io/cli/generate#component).

         5. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_como_criar_workspace_null></span>**Como criar biblioteca com o Angular 2**
         1. [Visão geral das bibliotecas angulares](https://angular.io/guide/libraries#overview-of-angular-libraries)
         2. [Veja como criar bibliotecas](https://angular.io/guide/creating-libraries)
         3. O flag **--create-application=false** do comando **ng new** cria um novo projeto de aplicativo inicial na pasta **'src'** do novo espaço de trabalho. Quando falso, cria um espaço de trabalho vazio sem aplicativo inicial. Você pode então usar o comando generate application para que todos os aplicativos sejam criados na pasta de projetos. [Veja mais...](https://angular.io/cli/new)
         4. [O como e por que usar o sinalizador --create-application com o Angular CLI para criar um espaço de trabalho sem o aplicativo](https://indepth.dev/posts/1179/angular-workspace-no-application-for-you)
         5. **Exemplo de como criar biblioteca com o Angular 2**.
            1. Como criar workspace vazio:

               ```sh
                  ng new my-workspace --create-application=false
               ```

            2. Como criar uma biblioteca com angula cli:

               ```sh
                  cd my-workspace
                  ng generate library my-lib

               ```

         6. Referências:
            1. [Visão geral das bibliotecas angulares](https://angular.io/guide/libraries#overview-of-angular-libraries)
            2. [Como criar um espaço de trabalho angular.](https://angular.io/cli/new)
            3. [O como e por que usar o sinalizador --create-application com o Angular CLI para criar um espaço de trabalho sem o aplicativo](https://indepth.dev/posts/1179/angular-workspace-no-application-for-you)
            4. [The Angular Library Series - Criando uma biblioteca com Angular CLI](https://medium.com/angular-in-depth/creating-a-library-in-angular-6-87799552e7e5)
            5. [O Projeto Biblioteca](https://indepth.dev/posts/1179/angular-workspace-no-application-for-you)
            6. [foo (em programação de software)](https://searchapparchitecture.techtarget.com/definition/foo-in-software-programming)
         7. <text onclick="goBack()">[🔙]</text>

      5. <span id=id_como_gerar_projeto_para_publicar_na_web></span>**Como gerar projeto para publicar na web**
         1. Quando executamos o comando **ng new nome-do-projeto** o mesmo adiciona no objeto **"scripts": {}** do arquivo **package.json**  a propriedade **"build": "ng build",**. [Veja mais...](https://angular.io/cli/build)
         2. Para gerar a pasta **./dist/nome-do-projeto** executar o seguinte comando:

               ```sh
                  # Executando via comando ng
                  ng build

                  # ou usar somente a abreviação de build = b
                  ng b 

                  # ou pode ser gerado também usando o comando:
                  npm run build
               ```

         3. Referências
            1. [ng build](https://angular.io/cli/build)
         4. <text onclick="goBack()">[🔙]</text>

      6. <span id=id_como_criar_modulos ></span>**Como criar módulos**
            1. Ao criar uma aplicação com o comando **ng new nome-do-projeto --routing** o módulo é criado normalmente, porém quando a aplicação é muito grande precisamos modularizar e neste caso, o comando abaixo se faz necessário. [Veja a vídeo aula para mais informações](https://www.youtube.com/watch?v=36kd3uR-hG8&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=6&t=125s).

            2. Criando módulo usando o angular cli.

                  ```sh
                     ng g m NomeDoModulo
                  ```

            3. **Referências:**
               1. [Vídeo aula sobre módulos](https://www.youtube.com/watch?v=36kd3uR-hG8&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=6&t=125s)
               2. [Definindo uma rota básica](https://angular.io/guide/router#defining-a-basic-route)
               3. [NgModule](https://angular.io/api/core/NgModule#ngmodule)

            4. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_como_usar_rotas_em_angular_2></span>**Como usar rotas em Angular 2**
         1. <scan id="id_arquivos_implementacao_rotas"></scan>**Arquivos para implementação de Rotas**
            1. O comando **ng new nome-do-projeto --routing** cria dois arquivos, sendo um (**src/app/app-routing.module.ts**) para registrar as rotas para os componentes e outro (**src/app/app.module.ts**) para registrar os componentes do projeto:
               1. O arquivo **src/app/app-routing.module.ts** é usado para registrar as rotas  para os componentes que estarão acessível a partir de uma requisição do browser .
                  1. Código typescript criado automaticamente.

                     ```ts
                        import { NgModule } from '@angular/core';
                        import { RouterModule, Routes } from '@angular/router';

                        //Matriz Router criada automaticamente paras as rotas
                        const routes: Routes = [ ]; 

                        /* Exemplo de rota para 3 componentes
                        const routes: Routes = [
                           { path: 'first', component: FirstComponent },
                           { path: 'second', component: SecondComponent },
                           { path: 'rota', component: NomeDoComponent },
                           ...
                        */
                           ];

                        @NgModule({
                        imports: [RouterModule.forRoot(routes)],
                        exports: [RouterModule]
                        })
                        export class AppRoutingModule { } //Classe exportada para a classe AppModule abaixo.

                     ```

                  2. <text onclick="goBack()">[🔙]</text>

               2. O arquivo **src/app/app.module.ts** é usado para registrar todos os componentes (units do delphi) do projeto.
                  1. Código typescript criado automaticamente.

                     ```ts
                        import { NgModule } from '@angular/core';
                        import { BrowserModule } from '@angular/platform-browser';

                        import { AppRoutingModule } from './app-routing.module';
                        import { AppComponent } from './app.component';

                        @NgModule({
                        declarations: [
                           AppComponent
                           
                        ],
                        imports: [
                           BrowserModule,
                           AppRoutingModule
                        ],
                        providers: [],
                        bootstrap: [AppComponent]
                        })
                        export class AppModule { }

                     ```

                  2. <text onclick="goBack()">[🔙]</text>

               3. Com a criação dos dois arquivos acima ao abrir o browser continuaremos a ver a página padrão do Angular na tela sem visualizar rotas porque nem uma rota foi criada acima.

               4. <text onclick="goBack()">[🔙]</text>

         2. <scan id="id_exibindo_paginas_projeto"></scan>**Exibindo as páginas do projeto:**
            1. **Adicionar componentes ao projeto:**
               1. Código shellscript:

                  ```sh
                     # Página para login do usuário
                     ng generate c page/login

                     # Página de inscrição de usuário
                     ng generate c page/signup
                     
                  ```

               2. <text onclick="goBack()">[🔙]</text>

            2. [**Adicionar rotas ao projeto:**](https://angular.io/api/router)
               1. No arquivo **app-routing-module.ts** adicione as seguintes linhas:

                  ```ts

                     // Na secção de importação importe os dois componentes abaixo
                     import { LoginComponent } from './pages/login/login.component';
                     import { SignupComponent } from './pages/signup/signup.component';                  

                     //Na matriz de Routes adicione os dois objetos abaixo:
                     const routes: Routes = [
                     {path:'login', component:LoginComponent},
                     {path:'signup', component:SignupComponent},
                     ];

                  ```

                  1. <text onclick="goBack()">[🔙]</text>

               2. No arquivo **app-module.ts** adicione as seguintes linhas:

                  ```ts
                     // Na secção de importação importe os dois componentes abaixo
                     import { LoginComponent } from './pages/login/login.component';
                     import { SignupComponent } from './pages/signup/signup.component';

                     // Matriz declarations adicione os dois componentes importados
                     declarations: [                       
                        LoginComponent,
                        SignupComponent,                        
                     ],

                  ```

                  1. <text onclick="goBack()">[🔙]</text>

               3. **Notas:**
                  1. Quando configuramos uma rota e navegamos até ela, o Angular recupera a URL, checa no arquivo de rotas e tenta carregar o componente na tela. Neste caso, o que acontece é que o Angular recuperou a URL <http://localhost:4200/login>, encontrou uma rota com este nome, localizou o componente que devia renderizar na tela, mas não conseguiu encontrar ONDE, na tela, ele deveria renderizar este componente. Vamos então para página **app.component.html**, remover todo conteúdo dela e deixar apenas as tags. Desta forma, ao navegar para URL <http://localhost:4200/login>, conseguimos ver o texto “Login Works!”, padrão dos componentes do Angular.
                  2. É importante notar que qualquer HTML contido na página **app.component.html** será exibido em todas as páginas do nosso App, então, é importante que nesta página seja declarado o menu de opções e a tag **\<router-outlet>\</router-outlet>** nele.

                  3. <text onclick="goBack()">[🔙]</text>

            3. <text onclick="goBack()">[🔙]</text>

         3. <sca id="id_rotas_filhas"></sca>**Rotas filhas**:
            1. Veja vídeo aula: [Curso Angular #60: Rotas Filhas](https://www.youtube.com/watch?v=zOxKiW7hkzY&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=61)
            2. Veja vídeo aula: [Curso Angular #61: Rotas Filhas: desenvolvendo as telas](https://www.youtube.com/watch?v=YE9A6NtlkmQ&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=63)

            3. <text onclick="goBack()">[🔙]</text>

         4. <scan id="id_guardas_de_rota"></scan>**Guardas de Rota** ([Prevenir o acesso não autorizado](https://angular.io/guide/router#preventing-unauthorized-access)).
            1. Para prevenir o acesso não autorizado é necessário a proteções de rota para evitar que os usuários naveguem para partes de um aplicativo sem autorização. Os seguintes protetores de rota estão disponíveis em Angular:
               1. [CanActivate](https://angular.io/api/router/CanActivate#canactivate)
                  1. Veja o vídeo: [Curso Angular #64: Usando Guarda de Rotas: CanActivate](https://www.youtube.com/watch?v=vVWttMeiR6s&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=66)
               2. [CanActivateChild](https://angular.io/api/router/CanActivateChild#canactivatechild)
                  1. Veja a vídeo aula:[Curso Angular #65: Usando Guarda de Rotas: CanActivateChild](https://www.youtube.com/watch?v=e7ttQtj2w6E&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=67)
               3. [CanDeactivate](https://angular.io/api/router/CanDeactivate#candeactivate)
                  1. Veja a vídeo aula: [Curso Angular #66: Usando Guarda de Rotas: CanDeactivate](https://www.youtube.com/watch?v=I0JZcL3Bsf4&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=68)
                  2. Veja a vídeo aula: [Curso Angular #67: Usando Guarda de Rotas: CanDeactivate com Interface Genérica](https://www.youtube.com/watch?v=B-a4InjV3mg&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=69)
               4. [Resolve](https://angular.io/api/router/Resolve#resolve)
                  1. Veja a vídeo aula: [Curso Angular #68: Guarda de Rotas: Resolve: carregando dados antes da rota ser ativada](https://www.youtube.com/watch?v=AEUSrpsAPtw&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=70)
               5. [CanLoad](https://angular.io/api/router/CanLoad#canload)
                  1. Veja a vídeo aula: [Curso Angular #69: Usando Guarda de Rotas: CanLoad: como não carregar o módulo sem permissão](https://www.youtube.com/watch?v=SQViHeue6bs&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=71)

            2. Para usar protetores de rota, considere o uso [de rotas sem componentes](https://angular.io/api/router/Route#componentless-routes), pois isso facilita a proteção de rotas secundárias. Crie um serviço para o seu guarda:
               1. Código ShellScript:

                  ```sh
                     ng generate guard your-guard
                  ```

            3. ..
            4. <text onclick="goBack()">[🔙]</text>

         5. Referências:
            1. [@angular/roteador](https://angular.io/api/router#angularrouter)
            2. [angular rotas guardas navegacao](https://balta.io/blog/angular-rotas-guardas-navegacao)
            3. [angular-rotas-guardas-navegacao](https://balta.io/blog/angular-rotas-guardas-navegacao)
            4. [Curso Angular 2 #49: Rotas: Introdução](https://www.youtube.com/watch?v=wzdKc0AFY6k&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=51)
            5. [Curso Angular #50: Rotas: Configurando rotas simples](https://www.youtube.com/watch?v=8OHoAZ6j0Rg&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=51)
            6. [Curso Angular #51: Rotas: RouterLink: definindo rotas no template](https://www.youtube.com/watch?v=zmlooouhauE&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=52)
            7. [Curso Angular #52: Rotas: Aplicando CSS em rotas ativas](https://www.youtube.com/watch?v=4r6uzxmEV-k&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=53)
            8. [Curso Angular #53: Rotas: Definindo e extraindo parâmetros de roteamento](https://www.youtube.com/watch?v=xTkIV8YNgXw&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=54)
            9. Guarda de rotas:
               1. [Curso Angular #64: Usando Guarda de Rotas: CanActivate](https://www.youtube.com/watch?v=vVWttMeiR6s)
               2. [Curso Angular #65: Usando Guarda de Rotas: CanActivateChild](https://www.youtube.com/watch?v=e7ttQtj2w6E&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=67)
               3. [Curso Angular #66: Usando Guarda de Rotas: CanDeactivate](https://www.youtube.com/watch?v=I0JZcL3Bsf4&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=68)
               4. [Curso Angular #67: Usando Guarda de Rotas: CanDeactivate com Interface Genérica](https://www.youtube.com/watch?v=B-a4InjV3mg&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=69)
               5. [Curso Angular #68: Guarda de Rotas: Resolve: carregando dados antes da rota ser ativada](https://www.youtube.com/watch?v=AEUSrpsAPtw&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=70)
               6. [Curso Angular #69: Usando Guarda de Rotas: CanLoad: como não carregar o módulo sem permissão](https://www.youtube.com/watch?v=SQViHeue6bs&list=PLGxZ4Rq3BOBoSRcKWEdQACbUCNWLczg2G&index=71)
            10. .

         6. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto08></span>**Assunto 08**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 08**.
            1. Descrição do exemplo

               ```ts
               ```

         3. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto09></span>**Assunto 09**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 09**.
          3. Descrição do exemplo

               ```ts
               ```

          4. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto10></span>**Assunto 10**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 10**.
             1. Descrição do exemplo

                  ```ts
                  ```

          3. <text onclick="goBack()">[🔙]</text>

      11. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](https://angular.io/docs)
      2. [Documentação de todas as APIs do angular 2](https://angular.io/api)
      3. [Como adicionar bootstrap a um projeto CLI Angular](https://loiane.com/2017/08/how-to-add-bootstrap-to-an-angular-cli-project/)
      4. [Exemplos de bootstrap com angular 2](https://ng-bootstrap.github.io/#/components/accordion/examples)
      5. [Projeto Angular Bootstrap com exemplos](https://ng-bootstrap.github.io/#/getting-started)
      6. [Curso Angular #64: Usando Guarda de Rotas: CanActivate](https://www.youtube.com/watch?v=vVWttMeiR6s)
      7. [ember-cli - Uma estrutura para desenvolvedores web ambiciosos.](https://cli.emberjs.com/release/)

      8. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 22/06/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no o_que_e_angular.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [x] Escrever tópico desvantagens

         - <text onclick="goBack()">[🔙]</text>

      2. 24/06/2021
         - [x] Escrever tópico Conteúdo estudado
         - [x] Escrever tópico Referências

         - <text onclick="goBack()">[🔙]</text>

      3. 02/07/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [x] Escrever o exemplo:Como criar formulário de login no angular
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
