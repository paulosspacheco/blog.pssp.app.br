# <span id="topo"><span>Como criar projetos free pascal multiplataforma <a href="modelo03.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="modelo03.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**CONTEÚDO ESTUDADO.**](#id_Conteudo)
      1. [Estudar como o projeto free pascal foi criado.](#id_assunto01)
      2. [Assunto 02](#id_assunto02)
      3. [Assunto 03](#id_assunto03)
      4. [Assunto 04](#id_assunto04)
      5. [Assunto 05](#id_assunto05)
      6. [Assunto 06](#id_assunto06)
      7. [Assunto 07](#id_assunto07)
      8. [Assunto 08](#id_assunto08)
      9. [Assunto 09](#id_assunto09)
      10. [Assunto 10](#id_assunto10)

   4. [**Referências globais.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. Descreve um resumo de como foi feito esse documento com as facilidade encontradas para produzi-lo e dificuldade encontrada.

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. Para que o framework MarIcarai tenha o máximo possível de programadores utilizando-o preciso diminuir a curva de aprendizado. Para que a [curva de aprendizado](https://pt.wikipedia.org/wiki/Curva_de_aprendizagem) seja mais rápida possível é preciso aproveitar o máximo do conhecimento do novo programador, por isso devo aproveitar todas a rotinas prontas do lazarus porque as mesmas tem documentação.
         2. [Documentação on-line do free pascal](https://www.freepascal.org/docs.html)

         3. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Ter o lazarus instalado no windows ou no linux, minha preferência é linux.
            1. Obs: A forma mais fácil de instalar o lazarus em todas as plataformas é usar o projeto [fpcupdeluxe](https://wiki.lazarus.freepascal.org/fpcupdeluxe) no sistema operacional de sua preferência.
         2. Domínio da linguagem pascal.
         3. Domínio das apis do sistema operacional destino do código.

         4. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. O free pascal permite criar projetos em todos os sistemas operacionais existente no momento (25/10/2021).

         2. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Para criar um aplicativo para vários sistemas operacionais é preciso abrir mão de projetos bons mais que existe somente em um sistema operacional.

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**CONTEÚDO ESTUDADO**
      1. <span id=id_assunto01></span>[**Estudar como o projeto free pascal foi criado.**](https://www.freepascal.org/)
         1. Como o free pascal padroniza o nome das unit?
            1. O nome das units gravadas em arquivos são sempre em minusculas.
            2. O nome das units usa a letra maiuscula para separar as palavras por exemplo:
               1. O arquivo sysinitpas.pp é a unit SysInitPas;

         2. Como o free pascal padroniza o nome de classes?
            1. Nome de classes sempre começa com letra maiuscula.

         3. Como o free pascal padroniza o nome de objetos instanciados, variáveis e atributos?
            1. Analisando o código **classes.pp** observei que não existe padrão, já que pascal ignora minúsculas e maiusculas, por isso posso adotar o padrão usado em java exceto no nome dos pacotes já que pascal é compilado:
               1. Nome de pacotes MarIcarai começa com as letras mi.NomeDoPacote;

               2. Nome de atributos privados começa com _ (underline) e a primeira letra é maiuscula e os atributos publicos ou protegidos começa com f e a letra seguinte maiuscula;

               3. As propriedade começa com letra maiuscula;

               4. Propriedade e métodos das classes começo com letra minusculas;

               5. Nome de variáveis e objetos (classes instanciadas) começa com letras minúsculas;

               6. Nome de classes, interfaces, tipos e constantes começa com letra maiusculas;

               7. Nome de palavras reservadas e identificadores começa com letra minusculas;

               8. Nome de constantes  usar letras maiusculas e separadas com sinal de underline (_);

               9. Exemplo do padrão adotado no projeto MarIcarai:

                  ```pascal

                       const

                           NUMERO_PI = 3.14;

                       type

                           TMyClass  = class
                                          public
                                             fNome : String;   

                                          private
                                             _SomeVar : Integer;

                                          published 
                                             SomaVar read _SomeVar write _SomeVar;
                                             
                                          public    
                                             procedure  escrevaSomeVar(); 
                                       end;

                       var
                         i : Integer;                          
                         objeto : TMyClass;

                       begin
                         
                         objeto := Tclass.create();
                         objeto.fNome := 'Meu padrão';
                         objeto.SomaValor := 40;
                         objeto.escrevaSomeVar();

                         for i := 1 to 10 do
                         begin
                           writeLn(i);
                         end;

                       end.  
                  ```

               10. .
            2. ..

         4. Como o Free pascal organiza suas pastas apos ser instalado.
            1. Ao instalar free pascal usando o projeto [**fpcupdeluxe**](https://wiki.lazarus.freepascal.org/fpcupdeluxe) ele criar dentro da pasta que você informa em [**fpcupdeluxe**](https://wiki.lazarus.freepascal.org/fpcupdeluxe) as seguintes pasta:
               1. SuaPasta/fpc
                  1. Essa pasta contem o compilador e as units compiladas:
                     1. A pasta **SuaPasta/fpc/bin** conta contém o compilador da plataforma default;
                     2. A pasta **SuaPasta/fpc/lib** contém as units compiladas, pacotes dll (windows ), .so (linux), etc de todas as plataformas destino instalada;
                        1. Obs: Aqui o sistema criar sub pastas para todas as versões instaladas;
                     3. A pasta **SuaPasta/fpc/share** é usada para a documentação comum a todas as plataformas;
                     4. O link **SuaPasta/fpc/units** aponta para a pasta **SuaPasta/fpc/lib/fpc/3.3.1/units**.

               2. SuaPasta/fpcsrc
                  1. A pasta **SuaPasta/fpcsrc/compiler** contém os fontes do compilador;
                  2. A pasta **SuaPasta/fpcsrc/packages** contém os fontes dos pacotes instalados do fpc
                     1. Cada pacote em **SuaPasta/fpcsrc/packages** contém as seguintes pastas:
                        1. **SuaPasta/fpcsrc/packages/src**
                           1. Para criar uma fonte multiplataforma é necessário escrever as units para cada plataforma.
                              1. Exemplo:
                                 1. SuaPasta/fpcsrc/packages/rtl-console/src/win
                                 2. SuaPasta/fpcsrc/packages/rtl-console/src/linux
                                 3. SuaPasta/fpcsrc/packages/rtl-console/src/inc
                                    1. Obs: A pasta **SuaPasta/fpcsrc/packages/inc** contém o código fonte comum em todas as plataformas** .
                                    SuaPasta/fpcsrc/packages

                        2. **SuaPasta/fpcsrc/packages/examples**
                           1. Contém os exemplos de uso do pacote.

                        3. **SuaPasta/fpcsrc/packages/tests**
                           1. .
                        4. **SuaPasta/fpcsrc/packages/units** //Units compiladas por plataforma
                  3. .
               3. .
            2. Ao instalar o Free pascal na plataforma linux x86_64 ele cria as seguintes pastas:

               1. **/fpc/bin/x86_64-linux** Nota: Binários da plataforma default

               2. **/fpc/share/doc/fpc-3.2.2** Nota: Esta pasta contém exemplo de como usar free pascal
                  1. Para testar os exemplos desta pasta é necessário usar o **IDE /fpc/bin/x86_64-linux/fp** no console.
                  2. Para testar usando o ide lazarus é preciso criar um projeto lazarus e configurar para que os mesmos funcionem.

               3. **/fpc/lib/fpc/3.2.2/units/**
                  1. **i386-win32** Nota: Units compiladas da plataforma i386-win32
                  2. **units/x86_64-linux** Nota: Units compiladas da plataforma x86_64-linux
                  3. **arm-android** Nota: Units compiladas da plataforma  arm-android

               4. O link **units** aponta para  **/fpc/lib/fpc/3.2.2/units/**.

               5. A pasta **/fpcsrc** contém os fontes do projeto do compilador free pascal.

         5. Pacotes comuns em todos os sistemas operacionais:
            1. O pacote [**FCL**](https://www.freepascal.org/fcl/fcl.html) (FCL - FREE COMPONENT LIBRARY) é usado para fornecer um conjunto completo de classes, de forma que um programador seja capaz de lidar com as tarefas de programação mais comuns; sempre que possível, a equipe FP tenta manter a compatibilidade do Delphi, de forma que o código escrito para um compilador possa ser compilado pelo outro.

            2. O pacote [RTL](https://www.freepascal.org/docs-html/current/rtl/index.html) é mantido pela equipe do free pascal.  é importante conhecer todas as units deste pacote para que seja aproveitado o máximo possível do trabalho feito pela equipe free pascal.

               1. [Compilando o RTL](https://www.freepascal.org/docs-html/prog/progsu224.html);

               2. A unidade [**objpas**](https://www.freepascal.org/docs-html/current/rtl/objpas/index.html) é feita para compatibilidade com Object Pascal implementado pelo Delphi. A unidade é carregada automaticamente pelo compilador Free Pascal sempre que o modo Delphi ou **objfpc** é inserido, seja através das opções de linha de comando -Sd ou -Sh ou com as diretivas **{$ MODE DELPHI}** ou **{$ MODE OBJFPC}**;

               3. A unit [printer](https://wiki.lazarus.freepascal.org/Using_the_printer) foi implementada nas seguintes plataformas:
                  1. Dos,
                  2. Windows
                  3. Linux
                  4. OS/2

      2. Utilitários:
         1. O utilitário [**h2pas**](https://www.freepascal.org/tools/h2pas.html) converte um arquivo de cabeçalho C em uma unidade pascal.

      3. Como o projeto free pascal implementa o conceito de multiplataforma?.
         1. Analisando o pacote **rtl** percebi que as units são implementada  em todas as plataformas e são incluida através de duas includes sendo uma antes da palavra implementation e outra após a palavra implementation. A unit principal só tem programas comuns a todas as plataformas e nas includes tem a implementação em cada plataforma.
            1. Exemplo:
               1.  

      4. **Exemplo do assunto 01**.
         1. Descrição do exemplo

            ```ts
            ```

      5. **Referências:**
         1. [**Estudar como o projeto free pascal foi criado.**](https://www.freepascal.org/)
         2. [Instalar com fpcupdeluxe](https://wiki.lazarus.freepascal.org/fpcupdeluxe) 
         3. [**FCL**](https://www.freepascal.org/fcl/fcl.html)
         4. .

      6. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_assunto02></span>**Assunto 02**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 02**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto03></span>**Assunto 03**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 03**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto04></span>**Assunto 04**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 04**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)
         4. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto05></span>**Assunto 05**
         5. Descrição do conteúdo.
         6. **Exemplo do assunto 05**.
            1. Descrição do exemplo

               ```ts
               ```

         7.  **Referências:**
            2. [title](link)
            3. [title](link)

         8.  <text onclick="goBack()">[🔙]</text>

      11. <span id=id_assunto06></span>**Assunto 06**
         9.  Descrição do conteúdo.
         10. **Exemplo do assunto 06**.
            1. Descrição do exemplo

               ```ts
               ```

         11. **Referências:**
            2. [title](link)
            3. [title](link)

         12. <text onclick="goBack()">[🔙]</text>

      12. <span id=id_assunto07></span>**Assunto 07**
         13. Descrição do conteúdo.
         14. **Exemplo do assunto 07**.
            1. Descrição do exemplo

               ```ts
               ```

         15. **Referências:**
            2. [title](link)
            3. [title](link)

         16. <text onclick="goBack()">[🔙]</text>

      13. <span id=id_assunto08></span>**Assunto 08**
         17. Descrição do conteúdo.
         18. **Exemplo do assunto 08**.
            1. Descrição do exemplo

               ```ts
               ```

         19. **Referências:**
            2. [title](link)
            3. [title](link)

         20. <text onclick="goBack()">[🔙]</text>

      14. <span id=id_assunto09></span>**Assunto 09**
         21. Descrição do conteúdo.
         22. **Exemplo do assunto 09**.
            1. Descrição do exemplo

               ```ts
               ```

         23. **Referências:**
            2. [title](link)
            3. [title](link)

         24. <text onclick="goBack()">[🔙]</text>

      15. <span id=id_assunto10></span>**Assunto 10**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 10**.
             1. Descrição do exemplo

                  ```ts
                  ```

          3. **Referências:**
             1. [title](link)
             2. [title](link)

          4. <text onclick="goBack()">[🔙]</text>

      16. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](#1)
      2. [Dica de como criar programa multiplataforma](https://wiki.freepascal.org/Multiplatform_Programming_Guide)
      3. [Guia rápido de referência da linguagem Pascal Versão Free Pascal](https://www.inf.ufpr.br/cursos/ci055/pascal.pdf)
      4. [Free Pascal Reference guide](https://www.freepascal.org/docs-html/ref/ref.html)
      5. [Hierarquia do sistema de arquivos Linux](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/dev.html)
      6. [ERRNO (3) Manual do programador Linux ERRNO (3)](https://man7.org/linux/man-pages/man3/errno.3.html)
      7. [Unit SysUtils reference](https://www.freepascal.org/docs-html/rtl/sysutils/index.html)
      8. [Unit lazFileUtils for linux](https://github.com/alrieckert/lazarus/blob/master/components/lazutils/unixlazfileutils.inc)
      9. [O que é wrappers?](https://en.wikipedia.org/wiki/Wrapper_function)
      10. [Sintaxe modo FPC](https://www.freepascal.org/docs-html/prog/progse72.html)
      11. [Acesso a arquivos com free pascal](https://www.freepascal.org/docs-html/rtl/sysutils/filecreate.html)
      12. [Pasta com todas as units da LCL Lazarus](https://lazarus-ccr.sourceforge.io/docs/lcl/)
      13. [Dicas de como usar o IDE Lazarus](https://gladiston.net.br/programacao/lazarus-ide/)

      14. <text onclick="goBack()">[🔙]</text>

1.  <span id="id_historico"><span>**HISTÓRICO**

  1. 26/10/2021 <!--TODO: HISTÓRICO -->
         - [x] Criar este documento baseado no modelo03.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [x] Escrever tópico desvantagens

         - <text onclick="goBack()">[🔙]</text>

      1.  27/10/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [x]Instalar o pacote [PasDoc](https://pasdoc.github.io/)
         - [ ] Escrever tópico Conteúdo
           - [ ] Estudar como o projeto free pascal foi criado.
           - [ ] 
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
