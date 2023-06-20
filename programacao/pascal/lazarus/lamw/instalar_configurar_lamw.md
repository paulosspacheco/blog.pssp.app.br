<!-- markdownlint-disable-next-line -->
#### Como instalar e configurar LamW<a href="instalar_econfigurar_lamw.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">➚</a>

1. **Passo  a passo para instalar os pacote no Lazarus**
   1. Baixar o projeto LamW do repositório github.
      1. [Click aqui para download do projeto LamW](https://github.com/jmpessoa/lazandroidmodulewizard)
      2. Descompactar para a pasta _[/lazarus/components/lazandroidmodulewizard-master](/lazarus/components/lazandroidmodulewizard-master)_

   2. Instalar os pacotes na seguinte ordem:
      1. _tfpandroidbridge_pack.lpk_ (na pasta "..../android_bridges");
      2. _lazandroidwizardpack.lpk_ (na pasta ""..../android_wizard");
      3. _amw_ide_tools.lpk_ (na pasta "..../ide_tools")

   3. Se estiver no sistema operacional _windows_ :
      1. Baixar os fontes do projeto Free Pascal
         1. _[Click aqui para download](https://gitlab.com/freepascal.org/fpc/source/-/archive/main/source-main.zip)_
         2. Descompactar na pasta _[/lazarus/components/lazandroidmodulewizard-master](/lazarus/components/free_pascal_source_main)_

      2. Execute o Lazarus e selecione a opção  _"/Tools/[LAMW] Android Module Wizard/Build FPC Cross Android"  e repita o processo "Build and install"_ uma vez para cada arquitetura relacionada abaixo.
         1. [x] Armv7a + Soft (android 32 bits <<-- testado!)
            1. [x] Construir
            2. [x] Instalar
         2. [x] Aarch64 (android 64 bits <<-- testado!)
            1. [x] Construir
            2. [x] Instalar

         3. **Notas**
            1. Depois de _build_ e _install_" os _cross-compilers_, executar os passos: infrastructure;
            2. Depois de executar os passos da infraestrutura, executar os teste conforme os passos: usando o LamW

   4. Se estiver no sistema operacional _Linux_:
      1. Instalar programa [_fpCupeDeLuxe_](https://wiki.lazarus.freepascal.org/fpcupdeluxe) 
         1. Na aba _Cross/CPU_ selecione o processador destino:
            1. 32 bits
                  1. Processador _Armv7a_
                  2. etc..
            2. 64 bits
               1. Processador _Aarch64_
               2. etc..

         2. Na aba _Cross/OS_ selecione o sistema operacional destino:
            1. Android
            2. etc...

2. **Passo a passo para instalar a infraestrutura android**.
   1. Instalar [Android Studio](https://developer.android.com/studio?gclid=CjwKCAjw-b-kBhB-EiwA4fvKrEsTffVft6mg-eLbZ3JJYdnWSaD5gEdVKuKZHzXlifA0Up-MEt49ehoCd8kQAvD_BwE&gclsrc=aw.ds)
   2. Instalação de Pacotes necessário para o LamW:
      1. Entrar no _Android Studio_ e siga os passos do link a seguir:
         1. [Instalar uma versão específica do NDK](https://developer.android.com/studio/projects/install-ndk?hl=pt-br#specific-version)

      2. CMake
         1. Instalar _CMake_
         2. [Configurar uma versão específica do CMak](https://developer.android.com/studio/projects/install-ndk?hl=pt-br#vanilla_cmake)

   3. Mensagem ao tentar atualizar a opção:

      ```md

        Warning. Minimum Target API required by "Google Play Store" = 30
        Please, update your android sdk/platforms folder!
        How to:
         .open a command line terminal and go to folder "sdk/tools/bin"
         .run the command> sdkmanager --update
         .run the command> sdkmanager "build-tools;30.0.2" "platforms;android-30"

      ```

   4. Confirmar todas as licenças instaladas:

      ```bash
         # Na pasta /android-sdk/cmdline-tools executar e confirmar com yes 
         sdkmanager --licenses

      ```

   5. ????
3. **Passo  a passo de como usar o LamW**.
   1. ????
