# <span id="topo"><span>Links Simbólicos no Linux <a href="linksimbolico.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="linksimbolico.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## CONTEÚDO

   1. O Que é Link Simbólico Linux?
      1. Links Simbólicos são úteis para simplificar o acesso a arquivos que estão com nome da pasta muito grande ou esteja em um hd diferente.

   2. [Como criar Link Simbólico para arquivos no Linux?](https://man7.org/linux/man-pages/man1/ln.1.html)
      1. Usa-se o  comando ln e a opção -s.
         1. Sintaxe:
            1. ln -s [target file or Dir] [filename or nameDir]
               1. Onde:
                  1. -s            =  --symbolic -> faça links simbólicos em vez de links físicos.
                  2. [target file or dir] = Nome do arquivo existente ou nome da pasta para qual você está criando o link.
                  3. [filename or Dir] = Nome do link simbólico para o arquivo ou pasta.
               2. Atenção:
                  1. O [filename or nameDir] (nome do arquivo ou nome da pasta destino) precisa não existir. obs: Se existir o link simbólico não será criado.

               3. Exemplo de link para a pasta .../blog.pssp.app.br:
                  1. ln -s "/home/paulosspacheco/Documentos/blogger/blog.pssp.app.br" "/home/paulosspacheco/vscode/node.js/blog.pssp.app.br"

   3. <span id='id_referencias'></span>**REFERÊNCIAS**
      1. [Manual Linux](https://man7.org/linux/man-pages/man1/ln.1.html)
      2. <https://www.hostinger.com.br/tutoriais/como-criar-link-simbolico-linux/>
      3. <https://canaltech.com.br/linux/aprenda-a-usar-links-simbolicos-e-hardlinks-no-linux/>

   4. <span id='id_historico'></span></span>**HISTÓRICO**

      <!--TODO: HISTÓRICO -->

     1. 12/02/2021
         - [x] Criado este documento;
  