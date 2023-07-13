<!-- markdownlint-disable-next-line -->
#### O que é pacote de pesquisa de site stork <a href="o_que_e_stork.html"  target="_blank"  title="Pressione aqui para expandir este documento em nova aba.">➚</a>

<!-- markdownlint-disable-next-line -->
<main>

- [OBJETIVO](#objetivo)
- [PASSO 01 - Instalação do stork no sistema operacional linux](#passo-01---instalação-do-stork-no-sistema-operacional-linux)
- [PASSO 02 - **Configurando o seu site para hospeda o stork:**](#passo-02---configurando-o-seu-site-para-hospeda-o-stork)
- [PASSO 03 -  Como criar um índice de pesquisa para o stork](#passo-03----como-criar-um-índice-de-pesquisa-para-o-stork)
- [PASSO 04 - Como criar uma página de pesquisa usando o pacote stork instalado em https://files.stork-search.net](#passo-04---como-criar-uma-página-de-pesquisa-usando-o-pacote-stork-instalado-em-httpsfilesstork-searchnet)
- [PASSO 05 - Como criar uma página de pesquisa usando o pacote stork instalado no seu site](#passo-05---como-criar-uma-página-de-pesquisa-usando-o-pacote-stork-instalado-no-seu-site)
- [Testando o índice criado por stork](#testando-o-índice-criado-por-stork)
- [REFERÊNCIAS](#referências)

## OBJETIVO

1. O pacote de pesquisa [_stork_](https://stork-search.net/) tem como objetivo indexar um [site estático](https://en.wikipedia.org/wiki/Static_web_page) para fazer pesquisas no mesmo usando apenas as linguagens javascript e webassembler.
2. Motivo:
   1. O servidor web _github.io_ não permite instalar programas _cgi_, _fastcgi_ ou _módulo apache_ no _servidor web_ sem que pague mensalidade para o mesmo.

## PASSO 01 - Instalação do stork no sistema operacional linux

1. Usando o [gerenciador de pacotes rust](https://doc.rust-lang.org/cargo/index.html)
   1. Instalar [Rust toolchain](https://doc.rust-lang.org/cargo/getting-started/installation.html) para que o pacote cargo fique disponível

      ```bash

         curl https://sh.rustup.rs -sSf | sh

         Rust is installed now. Great!

       ```

   2. Instalar o pacote Stock

      ```bash

         cargo install stork-search --locked

      ```

   3. Referência
      1. [Installing Stork...](https://stork-search.net/docs/install)

## PASSO 02 - [**Configurando o seu site para hospeda o stork:**](https://stork-search.net/docs/self-hosting)

1. Baixe [_stork.js_](https://github.com/jameslittle230/stork/releases/download/v1.6.0/stork.js), [_stork.wasm_](https://github.com/jameslittle230/stork/releases/download/v1.6.0/stork.wasm) e [_stork.js.map_](https://github.com/jameslittle230/stork/releases/download/v1.6.0/stork.js.map) da [_Versão Stork - v1.6.0 Latest_](https://github.com/jameslittle230/stork/releases/tag/v1.6.0) do _Github_ e publique esses arquivos em seu _servidor web_.

2. Certifique-se de servir _stork.wasm_ com o tipo _MIME_ correto e certifique-se de chamar _stork.initialize("stork.wasm")_ com o _URL onde você está hospedando_ o arquivo _stork.wasm_.

3. Sirva esses arquivos de seu _servidor web_. Carregue os arquivos Javascript _stork.js_ e _WASM_ _stork.wasm_ em seu servidor ou host da Web e os _apresente publicamente_ como faria com uma folha de _estilo_ ou _imagem_.

4. Certifique-se de servir o arquivo _WASM_ com o _application/wasm_ tipo [_MIME_](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) . Se você estiver colocando esses arquivos atrás do _seu CDN_, certifique-se de encaminhar o _Content-Type_ cabeçalho_ da fonte do arquivo, por meio desse CDN.

5. Inicialize o _Stork_ em sua página da Web com o _URL do WASM_. A página Javascript avançado descreve o _stork.initialize()_ método, que instrui o _Stork a carregar o WASM_. Certifique-se de chamar este método - mesmo se estiver usando a _stork.register()_ API mais simples - _antes de chamar qualquer outro método Stork_:

   ```js

      <script src="/js/stork.js"></script>

      <script>
         stork.initialize("/js/stork.wasm")
         stork.register("yourIndexName", "/index-file.st")
      </script>

   ```

6. **NOTAS**
   1. No site _pssp.app.br_ o arquivo [_stork.js_](/js/stork.js) e [_stork.wasm_](/js/stork.wasm) deve ficar na pasta /js.
   2. [Usando uma API JavaScript do WebAssembly](https://developer.mozilla.org/pt-BR/docs/WebAssembly/Using_the_JavaScript_API).
   3. Como escrever políticas de segurança de conteúdo:
      1. Stork conta com a capacidade de executar _WASM_ no navegador. A maioria das definições de política de segurança de conteúdo bloqueará a execução do _WASM_ por padrão. Você pode ver este manifesto como um erro de carregamento _WASM_ genérico:

         ```js

            Uncaught (in promise) StorkError: Error while loading WASM at /stork.wasm

            Wasm code generation disallowed by embedder                  

         ```

      2. Infelizmente, não há muitas boas opções para ter um [_CSP_](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) restritivo e executar o _WASM_ no navegador, mesmo que você _auto-hospede_ o arquivo _WASM_. Para que o _Stork_ funcione, você terá que _permitir a execução do WASM dentro de sua script-src diretiva_. O seguinte [_CSP_](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) é o [_CSP_](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) minimamente permissivo que ainda permitirá que o _Stork_ funcione em todos os principais navegadores:

         ```html
                           
            <meta
              http-equiv="Content-Security-Policy"
              content="default-src 'self'; script-src 'unsafe-eval';" 
           />

         ```

      3. O Google Chrome oferece suporte às políticas _'wasm-unsafe-eval'_(ou, às vezes, ) em sua diretiva para permitir a execução do _WASM_. No entanto, no momento em que este livro foi escrito, o _Safari_ e o _Firefox_ exigem que você especifique a política em sua diretiva, o que torna seu _CSP_ restritivo muito menos restritivo._'wasm-eval'script-srcunsafe-evalscript-src_.

7. **REFERÊNCIAS**
   1. [Download Stork - v1.6.0 Latest](https://github.com/jameslittle230/stork/releases/tag/v1.6.0)

## PASSO 03 -  [Como criar um índice de pesquisa para o stork](https://stork-search.net/docs/build)

1. Para criar um índice para arquivo [stork.js](/js/stork.js), é necessário instalar o pacote _stork_ descrito no [_passo 01_ acima](#passo-01---instalação-do-stork-no-sistema-operacional-linux).

2. Cada arquivo da lista de arquivos as serem pesquisados, devem ter as palavras _\<main>_  _\</main>_ para marcar o trecho de código que deve ser pesquisado.
   1. Exemplo:

      ```md

         <!-- markdownlint-disable-next-line -->
         <link type="text/css" href="../../../css/defaulttheme.css" rel="stylesheet" />

         <!-- markdownlint-disable-next-line -->
         <main>

         # Reflexão sobre fake, fatos e opinião

         >    1. Qual a diferença entre: fake x fatos x opinião?  
         >       1. Fake news são textos que não descrevem a verdade ou descrevem verdades fora do contexto.
         >            1. Exemplo de mentira:  
         >                1. O Brasil foi descoberto por Portugal. (Se havia morador ele não estava perdido).
         >            2. Exemplo de verdade fora do contexto:  
         >               1. Uma doença enradicada em anos anteriores, pode ser anunciada no momento atual com imagens da época em que ela foi enradicada.
         >
         >    2. Fatos são textos que descrevem a verdade:
         >       1. Portugal não conhecia o Brasil até o ano de 1500.
         >    3. Opinião são textos que descrevem pontos de vista pessoal ou cultural:
         >       1. Portugal ao chegar no Brasil e perceber que as pessoas que aqui vivia não possuía a pólvora, decidiram se apropriar.  
         >       2. Os políticos do Brasil são desonestos.  

         <!-- markdownlint-disable-next-line -->
         </main>

      ```

3. O programa de linha de comando _stork_, receberá um arquivo de configuração e criará um _arquivo de índice_. Um arquivo de índice é um _blob serializado e compactado_ que a biblioteca _Stork Javascript_ baixará e analisará. Geralmente tem a extensão de arquivo _.st_  e tem aproximadamente o tamanho de um _JPEG_.

4. Para criar um índice de pesquisa, o projeto _Stork_ requer que se crie um _arquivo de configuração_ que declare quais documentos devem ser indexados. Este arquivo de configuração deve ter o formato de arquivo [TOML](https://toml.io/en/).
   1. Arquivo exemplo de meta-dados que o stork espera:

      ```ini
         # index_stork.toml
         [input]
         base_directory = ""
         url_prefix = ""
         files = [
            {path = "./linguas_humanas/portugues/producao_de_textos/fake_fato_opiniao.html",  url = "0001", title = "Reflexão sobre fake, fatos e opinião"},
            {path = "./linguas_humanas/portugues/producao_de_textos/descricao_de_textos.html",  url = "0002", title = "Estudo da língua portuguesa"},
            {path = "./programacao/html/js/stork/o_que_e_stork.html",  url = "0001", title = "O que é pacote de pesquisa de site stork"}        
         ]

      ```

      1. **Notas:**
         1. _base_directory_ = diretório base que deve ser usado para resolver caminhos relativos. Esse caminho estará relacionado ao diretório de trabalho quando você executar o comando _stork build_.
         2. _url_prefix_ = ???Não compreendi do que se trata
         3. _files_ = A lista de arquivos e suas pastas juntamente com seus títulos
         4. [Veja todos os atributos aceitos pelo arquivo _basic.toml_ ...](https://stork-search.net/docs/config-ref)
         5. [Veja como o arquivo _basic.toml_ pode ter outros formatos de declaração...](https://stork-search.net/docs/build)

   2. Exemplo de como criar o índice _list_stork.st_ usando o arquivo _index_stork.toml_ descrito acima:

      ```bash

         # Cria índice para stork.js         
         stork build --input index_stork.toml --output list_stork.st

      ```

      1. **Notas**
         1. Todos os caminhos de arquivo no arquivo de configuração, incluindo o diretório base, são relativos ao diretório de trabalho quando você executa o comando Stork . Por exemplo, se você estiver no diretório _~/project_, ao executar _stork build --input index_stork.toml --output list_stork.st, o Stork procurará os arquivos em:
            1. ./project/my_files/federalist-1.txt
            2. ./project/my_files/federalist-2.txt
            3. ./project/my_files/federalist-3.txt

5. **Referências:**
   1. [Indexação de arquivos HTML e Markdown](https://stork-search.net/docs/html)
   2. [Indexação de conteúdo não inglês](https://stork-search.net/docs/languages)

## PASSO 04 - Como criar uma página de pesquisa usando o pacote stork instalado em https://files.stork-search.net

1. Use o modelo abaixo para criar sua página de pesquisa:

   ```html

      <!DOCTYPE html>
      <html lang="en">
         <head>
            <meta charset="utf-8" />
            <title>Federalist Search</title>

            <!-- O Stork é altamente personalizável e, se você quiser, pode escrever CSS que 
                 faça com que a saída do Stork pareça exatamente como você deseja. Como alternativa, 
                 você pode usar um dos temas pré-existentes para criar rapidamente uma aparência polida 
                 para sua interface de pesquisa. Aqui, estamos usando o tema Básico: -->
            <link 
               rel="stylesheet" 
               href="https://files.stork-search.net/releases/v1.6.0/basic.css" 
            />

         </head>

         <body>
            <!-- Cada interface de pesquisa deve ter um elemento de entrada e um elemento de saída . 
                 (O wrapper é usado apenas pelo tema basic.css que incluímos acima.) -->
            <div class="stork-wrapper">
               <input data-stork="federalist" class="stork-input" />
               <div data-stork="federalist-output" class="stork-output"></div>
            </div>
               
            <!-- Você pode carregar a biblioteca Javascript do Stork CDN (com suporte do AWS Cloudfront) ou auto-hospedá-la.
               Logo antes da </body>tag de fechamento, inclua o script Stork e registre o index.-->
            <script src="https://files.stork-search.net/releases/v1.6.0/stork.js"></script>
            <script>
               stork.register(
               'federalist',
               'https://files.stork-search.net/releases/v1.6.0/federalist.st'
               )
            </script>
         </body>

      </html>
       

   ```

2. **Nota**:
   1. Onde tiver a palavra _federalist_  troca o nome do seu índice criado em...
   2. [Neste exemplo de uso o índice está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/federalist.st)
   3. [O arquivo css de entrada e saída está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/basic.css)
   4. [O programa Stork está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/stork.js)
   5. O Código fonte foi do [projeto stork.js](https://github.com/jameslittle230/stork/tree/master) foi script em _typescript_, e o arquivo stork.js foi gerado pelo transpilador.
   6. [Construindo uma interface de pesquisa](https://stork-search.net/docs/interface)

## PASSO 05 - Como criar uma página de pesquisa usando o pacote stork instalado no seu site

1. Use o modelo abaixo para criar sua página de pesquisa e salve o arquivo na raiz do site:

   ```html

      <!DOCTYPE html>
      <html lang="en">
         <head>
            <meta charset="utf-8" />
            <title>Titulo de sua pesquisa</title>

            <!-- O Stork é altamente personalizável e, se você quiser, pode escrever CSS que 
               faça com que a saída do Stork pareça exatamente como você deseja. Como alternativa, 
               você pode usar um dos temas pré-existentes para criar rapidamente uma aparência polida 
               para sua interface de pesquisa. Aqui, estamos usando o tema stork.css: -->
            <link 
               rel="stylesheet" 
               href="/css/stork.css" 
            />

         </head>

         <body>
            <!-- Cada interface de pesquisa deve ter um elemento de entrada e um elemento de saída . 
               (O wrapper é usado apenas pelo tema stork.css que incluímos acima.) -->
            <div class="stork-wrapper">
               <input data-stork="list_stork" class="stork-input" />
               <!-- <div data-stork="list_stork" class="stork-output"></div> -->
               <div data-stork="list_stork-output" class="stork-output"></div>         
            </div>

            <!-- Código javascript deve está localizado na pasta /js .
               O código /js/stork.js depende do código /js/stork.wasm                 
            -->
            <script src="/js/stork.js"></script>

            <!-- O código javascript precisa saber o nome da lista que le deve pesquisar -->
            <script>
               stork.initialize("/js/stork.wasm")
               stork.register('list_stork', 'list_stork.st' )
            </script>
            
         </body>

      </html>
            

   ```

2. **Nota**:
   1. Onde tiver a palavra _federalist_  troca o nome do seu índice criado em...
   2. [Neste exemplo de uso o índice está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/federalist.st)
   3. [O arquivo css de entrada e saída está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/basic.css)
   4. [O programa Stork está hospedado em...:](https://files.stork-search.net/releases/v1.6.0/stork.js)
   5. O Código fonte foi do [projeto stork.js](https://github.com/jameslittle230/stork/tree/master) foi script em _typescript_, e o arquivo stork.js foi gerado pelo transpilador.
   6. [Construindo uma interface de pesquisa](https://stork-search.net/docs/interface)

## Testando o índice criado por stork

1. Depois de escrever um arquivo de configuração, você pode querer testar o funcionamento da interface de pesquisa antes de carregá-lo em seu site. O Stork oferece um modo de teste, no qual ele criará seu índice de pesquisa e o carregará em uma interface da Web simplificada para que você possa brincar com a funcionalidade de pesquisa enquanto itera em sua configuração.

2. Para testar seu índice, execute:

   ```bash

      stork test --config basic.toml
      # or
      stork test --index my-index.st

   ```

   1. **Nota:**
      1. Após executar o comando acima executar no browser  <http://localhost:1612>, a página web servida pela Stork.

## REFERÊNCIAS

1. [Link da versão mais recente do Stork no Github](https://github.com/jameslittle230/stork/releases/tag/v1.6.0)
2. [Construindo uma interface de pesquisa](https://stork-search.net/docs/interface)
3. [https://github.com/jameslittle230/stork](https://github.com/jameslittle230/stork)
4. [Stork Demo 1](https://codepen.io/littleguy230/pen/oNBJBmK)
5. [Stork Turns One: Construindo uma ferramenta de busca para sites estáticos com Rust e WebAssembly](https://jameslittle.me/blog/2020/one-year-of-stork)
6. [Log de alterações do stork](https://stork-search.net/changelog)

<!-- markdownlint-disable-next-line -->
</main>