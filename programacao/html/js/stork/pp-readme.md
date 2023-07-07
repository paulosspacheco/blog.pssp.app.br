# Passo a Passo para instalar o pacote Stork

## Instalação

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

## A biblioteca Javascript

1. Você pode carregar a biblioteca Javascript do Stork CDN (com suporte do AWS Cloudfront) ou auto-hospedá-la.
   1. Do Stork CDN:
      1. Inclua a seguinte tag de _script em seu site_, antes de sua tag _\</body\>_ de fechamento:

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
                     
                  <!-- Logo antes da </body>tag de fechamento, inclua o script Stork e registre o index.-->
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
         1. Neste exemplo de uso o índice está hospedado em: https://files.stork-search.net/releases/v1.6.0/federalist.st
         2. O arquivo css de entrada e saída está hospedado em: "https://files.stork-search.net/releases/v1.6.0/basic.css" 
         3. O programa Stork está hospedado em: https://files.stork-search.net/releases/v1.6.0/stork.js

## REFERÊNCIAS

1. [página de versão mais recente do Stork no Github](https://github.com/jameslittle230/stork/releases/tag/v1.6.0)