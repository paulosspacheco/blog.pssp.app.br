<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar e configurar LamW<a href="instalar_econfigurar_lamw.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">➚</a>

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
      2. Instalar Laz4Android
         1. [Download](https://sourceforge.net/projects/laz4android/)
            1. Last update:2022-08-15
            2. FPC: 3.2.2 (win32/win64/arm-android/aarch64-android/i386-android/x86_64-android/jvm-android)
            3. Lazarus:2.2.2
            4. Android NDK: r19c
            5. 1.Update to Lazarus 2.2.2 source + FPC 3.2.2
            6. I recommend using laz4android + LAMW(Lazarus Android Module Wizard) to develop android apps.

2. **Passo a passo para instalar a infraestrutura android**.
   1. Instalar [Android Studio](https://developer.android.com/studio?gclid=CjwKCAjw-b-kBhB-EiwA4fvKrEsTffVft6mg-eLbZ3JJYdnWSaD5gEdVKuKZHzXlifA0Up-MEt49ehoCd8kQAvD_BwE&gclsrc=aw.ds)

   2. Instalação de Pacotes necessário para o LamW:
      1. Instalar NDK
         1. [Downloads do NDK](https://developer.android.com/ndk/downloads?hl=pt-br)
         2. ou entrar no _Android Studio_ e siga os passos do link a seguir:
            1. [Downloads do NDK](https://developer.android.com/ndk/downloads?hl=pt-br)
      2. CMake
         1. Instalar _CMake_
         2. [Configurar uma versão específica do CMak](https://developer.android.com/studio/projects/install-ndk?hl=pt-br#vanilla_cmake)

      3. Gradle
         1. [Instalar sdkman](https://sdkman.io/install)
         2. Instalar gradle

            ```bash

              cd ./sdkman
              sdk install gradle
              # o lamw sugere o numerod a versão.

            ```

      4. **Referências**:
         1. [HowTo - Ambiente de desenvolviment](https://forum.lazarus.freepascal.org/index.php/topic,40750.html)

   3. Configurar Lazarus para registrar a infraestrutura:
      1. Selecionar opção _/menu_ _/tools_ _/[LAMW] Android Project Options_ _/Paths Settings [Jdk, Sdk, Ndk, ...]_
         1. Preencher o formulário:
            1. ![Paths Settings [Jdk, Sdk, Ndk, ...]](./img/form_path_lamw.jpeg)

         2. O arquivo [_/fpcupdeluxe/config_lazarus/LAMW.ini_](./LAMW.ini) após instalar LamW e editado os campos solicitados:

            ```ini

               [NewProject]
                  PathToSmartDesigner=/home/paulosspacheco/v/fpcupdeluxe/lazarus/components/lazandroidmodulewizard-master/android_wizard/smartdesigner
                  PathToJavaTemplates=/home/paulosspacheco/v/fpcupdeluxe/lazarus/components/lazandroidmodulewizard-master/android_wizard/smartdesigner/java
                  PathToJavaJDK=/usr/lib/jvm/java-1.11.0-openjdk-amd64/bin/java
                  NDKRelease=25.2.9519653
                  NDK=6
                  PrebuildOSYS=linux-x86_32
                  PathToAndroidNDK=/home/paulosspacheco/v/android-sdk/ndk/25.2.9519653
                  PathToAndroidSDK=/home/paulosspacheco/v/android-sdk
                  PathToGradle=/home/paulosspacheco/.sdkman/candidates/gradle/6.6.1
                  PathToAntBin=/usr/bin/ant
                  PathToWorkspace=/home/paulosspacheco/v/paulosspacheco/LazarusProjects/lamw
                  InstructionSet=1
                  PackagePrefaceName=org.lamw

            ```

      2. ...  

   4. **Notas**
      1. Mensagem após pressionar o botão ok ao informar pasta do ndk e sdk caso não ache o ndk:

         ```md

            Warning. Minimum Target API required by "Google Play Store" = 30
            Please, update your android sdk/platforms folder!
            How to:
               .open a command line terminal and go to folder "sdk/tools/bin"
               .run the command> sdkmanager --update
               .run the command> sdkmanager "build-tools;30.0.2" "platforms;android-30"

            ```

   5. Confirmar todas as licenças instaladas:

      ```bash
         # Na pasta /android-sdk/cmdline-tools executar e confirmar com yes 
         sdkmanager --licenses
      ```

   6. ..
   7. 
3. **Passo  a passo de como usar o LamW**.
   1. ????


</main>

[🔝🔝](#topo "Retorna ao topo")