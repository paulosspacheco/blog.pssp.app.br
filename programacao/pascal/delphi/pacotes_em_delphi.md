# <span id="topo"><span>Tudo sobre pacotes delphi XE<a href="modelo03.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>
## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Assunto 01](#id_assunto01)
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
         1. Este documento contém tudo que estudei sobre criação de pacotes em delphi e suas configurações.

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Domínio da linguagem pascal versão delphi;
         2. Conhecimento básico do IDE Delphix XE.

         3. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Os pacotes em Delphi são semelhantes as DLL (Dynamic-link library) do windows com algumas diferenças:
            1. A DLL permite apenas criar biblioteca de funções e os Pacotes Delphi permitem criar bibliotecas de classes.
            2. Como os pacotes delphi possuem classes, as mesmas podem ser instanciadas e herdadas como se fizesse parte do projeto atual;
            3. Os pacotes delphi podem acompanhar o projeto principal assim como as DLL, porém é possível que as classes dentro deles sejam ligadas em tempo de projeto ou em tempo de execução como as DLLs.
            4. Os pacotes permitem facilitar o desenvolvimento porque isola os programas de acordo com sua função facilitando assim a manutenção do mesmo.

         2. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. A instalação e configurações de pacotes dão trabalho para manter atualizado.

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_assunto01></span>**Tipos de pacotes**
         1. ![Imagem do formulário](./imgs/Instalar_pacotes_delphi.jpg)
         2. _Pacotes ligados em tempo de projeto:_
               1. Quando se instala um pacote na opção **/menu/project/options/packages/desine/pokages**  o mesmo passa fazer parte da IDE e seus objetos são inserido do executável sem necessidade de distribuir o código seu_pacote.BPL.

         3. _Pacotes ligados em tempo de execução:_
            1. Na opção /menu/project/options/packages/runtime/pokages quando instalado o pacote será ligado em tempo de execução e o seu_pacote.BPL deve ser distribuido junto com executável.

         4. **Extensões de nome de arquivos**:
               1. _.DPK_
                  1. Código fonte do pacote
               2. _.DCP_
                  1. Uma imagem binária contendo o cabeçalho do pacote e a concatenação de todos os arquivos DCU do pacote. Um arquivo único DCP é criado para cada pacote. O nome base para o DCP é o nome base do arquivo fonte DPK. Isto é necessário para linkar os pacotes run-time. Fazendo uma analogia, um DCP está para um pacote, assim como um DCU está para uma unit.
               3. _.DCU_
                  1. Uma imagem binária para um arquivo único contendo um pacote. Um DCU é criado, quando necessário, para cada arquivo (unit).
               4. _.BPL_
                  1. O pacote run-time. Nada mais é que uma DLL Windows , porém com características especiais do Delphi. O nome base para a BPL é o nome base para o arquivo fonte DPK. Este é o arquivo que você precisa enviar junto com sua aplicação.
         5. **Pasta dos pacotes delphi**:
            1. Nome das variáveis de ambiente tem a sintaxe $(VariableName) e cada campo possui um valor padrão e está associado a uma entrada no registro do windows. A instalação define o valor padrão:
               1. _$(BDS)_  Contém a pasta raiz onde o delphi foi instalado. No windows 2003 é a pasta: 'C:\Arquivos de programas\Embarcadero\RAD Studio\8.0' e está definido na variável do registro _RootDir_ = "HKEY_CURRENT_USER\Software\Embarcadero\BDS\8.0"

               2. _$(BDSCOMMONDIR)_ Contém o nome da pasta comum a todos os usuários do sistema e é definido na instalação do delphi e é guardada no registro do windows 2003 em .
                     1. No windows 2003 seu conteúdo contém o nome da pasta: 'C:\Documents and Settings\All Users\Documentos\RAD Studio\8.0'

               3. _$(BDSLIB)_ Contém o nome da pasta raiz das bibliotecas da IDE e é definido no registro do windows quando se instala o delphi: "HKEY_CURRENT_USER\Software\Embarcadero\BDS\8.0\Library\"
                  1. Pasta: "C:\Arquivos de programas\Embarcadero\RAD Studio\8.0\lib"

               4. _$(Platform)_ Contem o nome da pasta da plataforma destino da compilação e pode conter os seguintes valores:
                  1. win32
                  2. linux32
                  3. osx32

               5. $(BDSBIN) Contém o nome da pasta raiz dos executáveis da IDE Delphi. No windows 2003 é: "C:\Arquivos de programas\Embarcadero\RAD Studio\8.0\bin"

               6. _$(Config)_ a variável $(Config) é resolvida para a configuração específica definida no campo Destino na página _Opções do projeto específico_, onde $(Config) é especificado. Se você especificar $(Config) em um caminho e, em seguida, construir seu pacote com uma configuração de Depuração como Destino , $(Config) incluirá apenas o diretório de Depuração e a compilação pode perder quaisquer elementos que existam apenas no diretório de Lançamento.

            2. _Pasta com as Libs do IDE_:
               1. $(BDS)bin
               2. $(BDS)\source
               3. $(BDSLIB)\win32\debug
               4. $(BDSLIB)\win32\release
               5. $(BDS)\ObjRepos
               6. $(BDS)\include
               7. $(BDS)\help
               8. $(BDS)\License
               9. $(BDS)\OCX
               10. $(BDS)\8.0\RaveReports
               11. $(BDS)\schemas
               12. $(BDS)\Welcomepage

            3. _Pasta dos pacotes instalados pelo usuário_:
               1. $(BDSCOMMONDIR)
               2. $(BDSCOMMONDIR)\Dcp
               3. $(BDSCOMMONDIR)\Bpl
               4. $(BDSCOMMONDIR)\Dcu

         6. ..
         7. **Referências:**
            1. [Pacotes: Teoria e Prática - Parte I Conhecendo seus benefícios e aplicações](http://theclub.com.br/Restrito/Revistas/200901/paco0901.aspx)

            2. [Embarcadero Library - Translated](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Library_-_Translated)

            3. [Embarcadero Library](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Library)

            4. [Delphi Compiler](https://docwiki.embarcadero.com/RADStudio/Sydney/en/Delphi_Compiler)

         8. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_assunto02></span>**Assunto 02**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 02**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_assunto03></span>**Assunto 03**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 03**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_assunto04></span>**Assunto 04**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 04**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      5. <span id=id_assunto05></span>**Assunto 05**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 05**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      6. <span id=id_assunto06></span>**Assunto 06**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 06**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_assunto07></span>**Assunto 07**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 07**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto08></span>**Assunto 08**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 08**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto09></span>**Assunto 09**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 09**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [Quick Tips : Como trabalhar com Packages no Delphi](https://www.devmedia.com.br/quick-tips-como-trabalhar-com-packages-no-delphi/16421)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto10></span>**Assunto 10**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 10**.
             1. Descrição do exemplo

                  ```ts
                  ```

          3. **Referências:**
             1. [title](link)
             2. [title](link)

          4. <text onclick="goBack()">[🔙]</text>

      11. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](#1)
      2. [#](##)
      3. [#](##)
      4. [#](##)
      5. [#](##)

      6. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. dd/mm/2021 <!--TODO: HISTÓRICO -->

         - <text onclick="goBack()">[🔙]</text>

      2. dd/mm/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Criar este documento baseado no modelo03.md ;
         - [ ] Escrever tópico Objetivos;
         - [ ] Escrever tópico Pre-requisitos
         - [ ] Escrever tópico Benefícios
         - [ ] Escrever tópico desvantagens
         - [ ] Escrever tópico Conteúdo
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
