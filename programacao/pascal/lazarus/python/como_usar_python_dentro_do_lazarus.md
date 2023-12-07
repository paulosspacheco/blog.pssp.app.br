<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como usar python dentro do Lazarus <a href="como_usar_python_dentro_do_lazarus.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## 1. INDEX

---

1. [Resumo do conteúdo](#id_resumo)

2. **Introdução**
   1. [Objetivo.](#id_objetivo)
   2. [Pre-requisitos.](#id_pre_requisitos)
   3. [Benefícios.](#id_beneficios)
   4. [Desvantagens.](#id_desvantagens)

3. [**Conteúdo estudado.**](#id_Conteudo)
   1. [Instalar componente python4Laz](#id_Instalar_python4Laz)
   2. [Exemplo de como executar um código python e capturar a saída do python para ser visualizada no Lazarus.](#id_Exemplo_captura_saida_python)
   3. [Exemplo de uso do python no modo console demonstra como informar o nome da lib python no sistema](#id_Exemplo_modo_console)
   4. [Componentes  Python4Laz usados para executar código python e capturar o resultado](#id_assunto04)

4. [**Referências globais.**](#id_referencias)

5. [**Histórico.**](#id_historico)

## 2. CONTEÚDO

---
<!-- markdownlint-disable-next-line -->
1. <span id="id_resumo"><span>**Resumo do conteúdo:**
   1. Este documento descreve como instalar o pacote python4Lazarus, o objetivo desta ação, os benefícios e os malefícios de se usar python com Lazarus, bem como mostra alguns exemplos de seu uso.

2. **Introdução**
   <!-- markdownlint-disable-next-line -->
   1. <span id="id_objetivo"><span>**Objetivo:**
      1. O componente _python4laz_ é um recurso que permite que o se possa aproveita todos os projetos escrito em python no lazarus, tais como Chatgpt, aprendizado de máquina, opencv etc... visto que o lazarus tem recursos RAD que facilita e muito o desenvolvimento de um software.

      2. <text onclick="goBack()">[🔙]</text>

   2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
      1. O python deve estar instalado antes de ser instalar o python4laz;
      2. Os projetos que se deseja usar no python, também deve ser instalados;
      3. Lazarus deve ser instalado com fpcupdeluxe;
      4. O pacote python4laz deve ser instalado com fpcupdeluxe.

      5. <text onclick="goBack()">[🔙]</text>

   3. <span id="id_beneficios"></span>**Benefícios:**
      1. Se tornar mais produtivo aproveitando tudo que existe hoje para python e tudo que existe el freepascal, bem como ter domínio do projeto através dps componentes TDataModule e TForm do Lazarus.

      2. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. O programas escritos em python são mais lentos que freepascal por ser uma linguagem interpretada;
      2. Os usuários do produto pode ser deparar com erros básico de sintaxe;
      3. Qualquer um tem acesso ao código fonte do python.

      4. <text onclick="goBack()">[🔙]</text>

3. <span id=id_Conteudo></span>**Conteúdo estudado**

   1. <span id=id_Instalar_python4Laz></span>**Instalar componente python4Laz**
      1. Para se instalar o componente _Python4Laz_ vamos utilizar o projeto [fpcupdeluxe](https://gladiston.net.br/programacao/lazarus-ide/usando-fpcupdeluge-nivel-medio/) opção _/modules/python4laz_.
      2. O projeto é instalado na pasta ccr onde está instalado o lazarus e o free pascal
      3. <text onclick="goBack()">[🔙]</text>

      <span id=id_Exemplo_captura_saida_python></span>
   2. **Exemplo de como executar um código python e capturar a saída do python para ser visualizada no Lazarus..**
      1. Ao instalar o pacote _Python4Laz_, o sistema copia para a pasta _./ccr/python4laz/demos_lazarus/Python_Console_ um exemplo de como usar o projeto. O arquivo _formmain.pas_ possui uma contante de nome _cPyLibraryLinux_ com o nome da _lib_ python instalada no sistema; a mesma deve conter o nome da _lib_.

      2. Neste exemplo o nome da dll é informado na constante _cPyLibraryLinux_.

      3. O python instalado no Linux mint 21.2 é:
         1. O nome do executável python instado:

            ```bash

              # Nome do executável.
              /usr/bin/python3

            ```

         2. O nome da lib python instalado:

            ```pascal

              Const
                cPyLibraryLinux: string = 'libpython3.10.so.1.0'; //Linux Mint 21.2 Cinnamon 

            ```

      4. **Teste para saber se o python está configurado.**.
         1. Executar o projeto _demo_ da pasta _./ccr/python4laz/demos_lazarus/Python_Console_
         2. No rodapé formulário executado digite o comado python a seguir:

            ```python

              print("Alo mundo");

            ```

         3. **Nota**
            1. Se ao executar o texto alo mundo for impresso é porque o sistema está configurado.
            2. .

      5. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Exemplo_modo_console></span>**Exemplo de uso do python no modo console demonstra como informar o nome da lib python no sistema**
      1. Ao instalar o pacote _Python4Laz_, o sistema copia para a pasta _./ccr/python4laz/demos_lazarus/Python_Thread_ um exemplo de como executar várias tarefas python ao mesmo tempo.
      2. Para que o programa funcione é necessário selecionar a _unit Testthds_ e alterar as propriedades abaixo:

         ```pascal

           TForm1.PythonEngine1.DllName := 'libpython3.10.so.1.0';
           TForm1.PythonEngine1.DllPath := '/lib/x86_64-linux-gnu';

         ```

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_assunto04></span>**Componentes _Python4Laz_ usados para executar código python e capturar o resultado**
      1. A unit _PythonEngine_ contém o componente _PythonEngine_ obrigatório no projeto python no Lazarus. O mesmo é usado para conectar-se a lib python instalada no sistema.
         1. Exemplo de uso:

            ```pascal

               const
                  cPyLibraryWindows: string = 'python37.dll';
                  //  cPyLibraryLinux: string = 'libpython3.8.so.1.0'; //default in Ubuntu 20.x
                  cPyLibraryLinux: string = 'libpython3.10.so.1.0'; //Linux Mint 21.2 Cinnamon
                  cPyLibraryMac: string = '/Library/Frameworks/Python.framework/Versions/3.7/lib/libpython3.7.dylib';
                  cPyZipWindows: string = 'python37.zip'; 
               
               procedure TfmMain.DoPy_InitEngine;
                  var
                  S: string;
               begin
                  S:=
                     {$ifdef windows} cPyLibraryWindows {$endif}
                     {$ifdef linux} cPyLibraryLinux {$endif}
                     {$ifdef darwin} cPyLibraryMac {$endif} ;

                  PythonEngine.DllPath:= ExtractFileDir(S);
                  PythonEngine.DllName:= ExtractFileName(S);
                  PythonEngine.LoadDll;
               end;                
            
            ```

      2. ..

4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
   1. [Site oficial para produzir este documento](https://www.python.org/)
   2. [Download do python](https://www.python.org/downloads/)
   3. [O que é cpython](https://pt.wikipedia.org/wiki/CPython#:~:text=CPython%20%C3%A9%20a%20implementa%C3%A7%C3%A3o%20principal,outros%20desenvolvedores%20espalhados%20pelo%20mundo.&text=CPython%20%C3%A9%20um%20interpretador%20de%20bytecode.)

<!-- markdownlint-disable-next-line -->
   1. <text onclick="goBack()">[🔙]</text>
<!-- markdownlint-disable-next-line -->
1. <span id="id_historico"><span>**HISTÓRICO**

   1. <!--FIXME: Falta fazer os item abaixo: -->
      - [x] Criar este documento baseado no como_usar_python_dentro_do_lazarus.md ;
      - [x] Escrever tópico Objetivos;
      - [x] Escrever tópico Pre-requisitos
      - [x] Escrever tópico Benefícios
      - [x] Escrever tópico desvantagens
      - [ ] Escrever tópico Conteúdo
        - [x] Criar documento de como instalar o pacote python4laz;
        - [x] Criar documento de como configurar o ambiente python no Lazarus.
      - [ ] Escrever tópico Exemplos
      - [x] Escrever tópico Referências
      - [x] Atualizar o histórico deste documento.
      - [ ] Testar este documento depois após uma semana de concluído.

      - <text onclick="goBack()">[🔙]</text>

</main>

[🔝🔝](#topo "Retorna ao topo")
