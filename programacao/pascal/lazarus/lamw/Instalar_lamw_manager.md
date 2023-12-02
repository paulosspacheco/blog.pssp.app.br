<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar LAMW Manager no linux

1. O script **[lamw_manager_setup.sh](https://github.com/dosza/LAMWManager-linux#:~:text=here%20to%20download-,LAMW%20Manager%20Setup,-Go%20to%20download)** é uma instalação antiga do lazarus 2.0.12 versão Linux e suas dependências na época.
2. Esse documento é um resumo de como consegui instalar na data 21/02/2023 o **lamw** e suas dependências no **Linux Mint**.
3. Tive dificuldade para fazer funcionar os exemplos e só depois de muita luta consegui fazer funcionar.

4. **PASSO A PASSO**
   1. Baixar o arquivo **[lamw_manager_setup.sh](https://github.com/dosza/LAMWManager-linux/releases/download/v0.5.3/lamw_manager_setup.sh)** em uma pasta de sua preferência;

   2. Entre no gerenciador de arquivos do Linux e dê permissão para execução do script **lamw_manager_setup.sh**;

   3. Entre na pasta do arquivo **lamw_manager_setup.sh** e execute seguinte comando:

      ```sh
        # Suponha que você queira instalar na pasta ~/lamw então:

        $ env LOCAL_ROOT_LAMW=~/lamw bash lamw_manager_setup.sh -- --update-lamw 

      ```

      1. Nota:
         1. Vai demorar porque esse script instala muitas dependências.
         2. Mais informações de como executar o script [veja aqui...](https://github.com/dosza/LAMWManager-linux/blob/master/lamw_manager/docs/lamw_manager_setup.md)

5. Após a instalação, executa a opção **LAMW4Linux IDE** do menu a opções do Linux;
   1. Com o Lazarus aberto siga esse [esse passo a passo...](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/AppHelloWorld.md);

6. Se você seguiu todos os passos, você terá o app **alo mundo** em seu celular.
   1. Notas:
      1. Seu celular precisa estar no modo desenvolvedor. Para mais informações [**veja aqui...**](https://developer.android.com/studio/debug/dev-options?hl=pt-br)
      2. Ao colocar o seu celular na **porta usb** o gerenciador de aquivos precisa identifica-lo.
         1. Caso o gerenciador de arquivo não detecte seu celular, leia novamente e veja o que você errou nessa etapa.

7. As demostrações foram escritas para celular 32 bits, por isso tem um macete para executa-los em celular 32 bits.
   1. O motivo desse macete é um bug na ide que não modificar a plataforma de 32 para 64 bits.

8. O próximo artigo eu descrevo o passo a passo para fazer as demostrações funcionarem.

</main>

[🔝🔝](#topo "Retorna ao topo")